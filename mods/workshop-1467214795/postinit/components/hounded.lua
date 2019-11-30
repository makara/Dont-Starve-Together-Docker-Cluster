local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

IAENV.AddComponentPostInit("hounded", function(cmp)


local SuperHoundWaves = false
local SummonSpawn_old = UpvalueHacker.GetUpvalue(cmp.SummonSpawn, "SummonSpawn")
if not SummonSpawn_old then -- Super Hound Waves, probably
	SummonSpawn_old = UpvalueHacker.GetUpvalue(cmp.SummonSpawn, "OriginalSummonSpawn")
	if SummonSpawn_old then
		SuperHoundWaves = true
	end
end
local GetSpawnPoint_old = UpvalueHacker.GetUpvalue(SummonSpawn_old, "GetSpawnPoint")
local GetSpecialSpawnChance_old = UpvalueHacker.GetUpvalue(SummonSpawn_old, "GetSpecialSpawnChance")
local SPAWN_DIST = UpvalueHacker.GetUpvalue(GetSpawnPoint_old, "SPAWN_DIST") or 30

local function GroundTestCroc(pt)
	return IsInIAClimate(pt)
end

local function NoHolesCroc(pt)
	return GroundTestCroc(pt) and not TheWorld.Map:IsPointNearHole(pt)
end
local function NoHolesHound(pt)
	return not GroundTestCroc(pt) and not TheWorld.Map:IsPointNearHole(pt)
end

local function GetSpawnPointCroc(pt)
    if not TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) then
        pt = FindNearbyLand(pt, 1) or pt
    end
    local offset = FindWalkableOffset(pt, math.random() * 2 * PI, SPAWN_DIST, 12, true, true, NoHolesCroc)
    if offset ~= nil then
        offset.x = offset.x + pt.x
        offset.z = offset.z + pt.z
        return offset
    end
end

local function GetSpawnPoint(pt)
    if not TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) then
        pt = FindNearbyLand(pt, 1) or pt
    end
    local offset = FindWalkableOffset(pt, math.random() * 2 * PI, SPAWN_DIST, 12, true, true, NoHolesHound)
    if offset ~= nil then
        offset.x = offset.x + pt.x
        offset.z = offset.z + pt.z
		print("FOUND HOUND SPAWNPOINT",TheWorld.Map:GetTileAtPoint(offset.x, 0, offset.z))
        return offset
    end
end

local function GetSpecialCrocChance()
	-- same as hound chance, except we undo the season modifier
    local chance = GetSpecialSpawnChance_old()
    return TheWorld.state.issummer and chance * 2/3 or chance
end

local function SummonSpawn(pt, overrideprefab)
	if GroundTestCroc(pt) or overrideprefab then
		local spawn_pt = GetSpawnPointCroc(pt)
		if spawn_pt ~= nil then
			local spawn = SpawnPrefab(
				overrideprefab
				or	math.random() < GetSpecialCrocChance() 
					and ((TheWorld.state.isspring and "watercrocodog")
						or (TheWorld.state.issummer and "poisoncrocodog"))
				or "crocodog"
			)
			if spawn ~= nil then
				spawn.Physics:Teleport(spawn_pt:Get())
				spawn:FacePoint(pt)
				if spawn.components.spawnfader ~= nil then
					spawn.components.spawnfader:FadeIn()
				end
				return spawn
			end
		end
	else
		return SummonSpawn_old(pt) -- regular spawn behaviour, except we still edit GetSpawnPoint
	end
end

-- Note: always set the deepest value first, or else we'd need to upvalue our own modifications
UpvalueHacker.SetUpvalue(SummonSpawn_old, GetSpawnPoint, "GetSpawnPoint")
if SuperHoundWaves then
	UpvalueHacker.SetUpvalue(cmp.SummonSpawn, SummonSpawn, "OriginalSummonSpawn")
else
	UpvalueHacker.SetUpvalue(cmp.SummonSpawn, SummonSpawn, "SummonSpawn")
end

cmp.SummonSpecialSpawn = function(self, pt, prefab, num)
	if pt == nil or prefab == nil then return end
	for i = 1, (num and math.max(num, 1) or 1), 1 do
		SummonSpawn(pt, prefab)
	end
end


end)
