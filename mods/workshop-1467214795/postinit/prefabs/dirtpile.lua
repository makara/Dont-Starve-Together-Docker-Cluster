local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

local function dohack(inst)
	-- This section is actually a Hunter component postinit
	-- Need to wait a tick for Hunter to set the callback
	if inst._ondirtremove and not rawget(_G, "IA_DIRTPILE_UPVALUEHACKED") then
		-- This fails quiet if something is awry
		local old_GetSpawnPoint = UpvalueHacker.GetUpvalue(inst._ondirtremove, "ResetHunt", "StartCooldown", "OnCooldownEnd", "BeginHunt", "OnUpdateHunt", "StartDirt", "SpawnDirt", "GetSpawnPoint")
		if old_GetSpawnPoint then
			
			local function IsValidLand(pt)
				local tile = TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
				return not IsWater(tile)
			end

			local function GetSpawnPoint(pt, radius, hunt)
				local spawn_point = old_GetSpawnPoint(pt, radius, hunt)
				if spawn_point and IsValidLand(spawn_point) then
					return spawn_point
				end
			end
			UpvalueHacker.SetUpvalue(inst._ondirtremove, GetSpawnPoint, "ResetHunt", "StartCooldown", "OnCooldownEnd", "BeginHunt", "OnUpdateHunt", "StartDirt", "SpawnDirt", "GetSpawnPoint")

			local function GetRunAngle(pt, angle, radius)
				local offset, result_angle = FindWalkableOffset(pt, angle, radius, 14, true, false, IsValidLand)
				return result_angle
			end
			UpvalueHacker.SetUpvalue(inst._ondirtremove, GetRunAngle, "ResetHunt", "StartCooldown", "OnCooldownEnd", "BeginHunt", "OnUpdateHunt", "StartDirt", "GetNextSpawnAngle", "GetRunAngle")
			
			rawset(_G, "IA_DIRTPILE_UPVALUEHACKED", true)
			
		end
	end
	
	
	-- Failsafe (the first dirt can spawn on water, but that is usually a fresh hunt, so it doesn't matter)
	if inst:GetIsOnWater() or IsInIAClimate(inst) then
		inst:Remove()
	end
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddPrefabPostInit("dirtpile", function(inst)


if TheWorld.ismastersim then

	inst:DoTaskInTime(0, dohack)
	
end


end)
