GLOBAL.setfenv(1, GLOBAL)

function GetProperAngle(angle)
    if angle > 360 then
        return angle - 360
    else
        return angle
    end
end

function FindNearbyLand(position, range)
    local finaloffset = FindValidPositionByFan(math.random() * 2 * PI, range or 8, 8, function(offset)
        local x, z = position.x + offset.x, position.z + offset.z
        return TheWorld.Map:IsAboveGroundAtPoint(x, 0, z)
        and not TheWorld.Map:IsPointNearHole(Vector3(x, 0, z))
        and not IsOnWater(x, 0, z)
    end)
    if finaloffset ~= nil then
        finaloffset.x = finaloffset.x + position.x
        finaloffset.z = finaloffset.z + position.z
        return finaloffset
    end
end

-- These functions are a bit overkill for some purposes, but they cover all cases
function EntityScript:IsAmphibious()
	return not self:HasTag("aquatic") and (self:HasTag("amphibious") or self:HasTag("flying")
        or self:HasTag("playerghost") or self:HasTag("ghost")
		or self:HasTag("shadowhand") --special exception, consider using AddPrefabPostInit to do this instead -M
        or (self.sg and self.sg:HasStateTag("amphibious") ))
end

function EntityScript:CanOnWater()
	return self:HasTag("aquatic")
		or (self.components.projectile and self.components.projectile.target)
		or (self.components.complexprojectile and self.components.complexprojectile.owningweapon)
		or self:IsAmphibious()
end

function EntityScript:CanOnLand()
	return not self:HasTag("aquatic") -- most of the time, this ends here
		or self:IsAmphibious()
end

function IsPositionValidForEnt(inst, radius_check)
    return function(pt)
        return inst:IsAmphibious()
			or (inst:HasTag("aquatic") and not inst:GetIsCloseToLand(radius_check, pt))
			or (not inst:HasTag("aquatic") and not inst:GetIsCloseToWater(radius_check, pt))
    end
end

-- keep this function as SW compatibility for now, but preferably use IsOnWater where possible
function EntityScript:GetIsOnWater(x, y, z)
    if not x then
        if not self.Transform then return false end
        x, y, z = self.Transform:GetWorldPosition()
    elseif type(x) == "table" then
        y = x.y or 0
        z = x.z
    end

    if not x or not z then
        return false
    else
        local tile, tileinfo = GetVisualTileType(x, y, z)
        return IsWater(tile)
    end
end

function EntityScript:GetIsFlooded(x, y, z)
    if not x then
        if not self.Transform then return false end
        x, y, z = self.Transform:GetWorldPosition()
    end
	return IsOnFlood(x,y,z)
end

function EntityScript:GetIsCloseToWater(radius, pt, attempts)
    radius = radius or 1
    pt = pt or Point(self.Transform:GetWorldPosition())
    attempts = attempts or 8
    local waterPos = FindValidPositionByFan(0, radius, attempts, function(offset)
        local test_point = pt + offset
        --if IsWater(TheWorld.Map:GetTileAtPoint(test_point:Get()))  then
        if IsOnWater(test_point:Get())  then
            return true
        end
        return false 
    end)

    return waterPos ~= nil
end

function EntityScript:GetIsCloseToLand(radius, pt, attempts)
    radius = radius or 1
    pt = pt or Point(self.Transform:GetWorldPosition())
    attempts = attempts or 8
    local landPos = FindValidPositionByFan(0, radius, attempts, function(offset)
        local test_point = pt + offset
        --if not IsWater(TheWorld.Map:GetTileAtPoint(test_point:Get()))  then
        if not IsOnWater(test_point:Get())  then
            return true
        end
        return false 
    end)

    return landPos ~= nil
end

function EntityScript:IsPosSurroundedByWater(x, y, z, radius)
    for i = -radius, radius, 1 do
        if not IsOnWater(x - radius, y, z + i) or not IsOnWater(x + radius, y, z + i) then
            return false
        end
    end
    for i = -(radius - 1), radius - 1, 1 do
        if not IsOnWater(x + i, y, z -radius) or not IsOnWater(x + i, y, z + radius) then
            return false
        end
    end
    return true
end

function EntityScript:IsPosSurroundedByLand(x, y, z, radius)
    for i = -radius, radius, 1 do
        if IsOnWater(x - radius, y, z + i) or IsOnWater(x + radius, y, z + i) then
            return false
        end
    end
    for i = -(radius - 1), radius - 1, 1 do
        if IsOnWater(x + i, y, z -radius) or IsOnWater(x + i, y, z + radius) then
            return false
        end
    end
    return true
end

local function CanMoveAt(inst, x, y, z, px, py, pz, deg)
    if inst:IsAmphibious() then
        return true
    elseif inst:CanOnLand() then
        return TryMoveOnTile(inst, GetVisualTileType(px, py, pz, 1.5 / 4))
    elseif inst:CanOnWater() then
        return TryMoveOnTile(inst, GetVisualTileType(px, py, pz, 0.001 / 4))
    end
    return false
end

local function AddWorldOffset(tilepercent, wt)
    return IsNumberEven(wt) and (tilepercent >= 0.5 and -2 or 2) or 0
end

local function WaterLandBoundaries(inst, x, y, z, cos, sin)
    local wtx, wty = TheWorld.Map:GetSize()
    
    local tilecenter_x, tilecenter_y, tilecenter_z  = TheWorld.Map:GetTileCenterPoint(x, 0, z)
    if not tilecenter_x and not tilecenter_z then return x, z end
    local tilexpercent = ((tilecenter_x - x)/TILE_SCALE) + .5
    local tilezpercent = ((tilecenter_z - z)/TILE_SCALE) + .5
    if inst:CanOnLand() then
        return math.round(x / 4) * 4 + AddWorldOffset(tilexpercent, wtx) + (tilexpercent >= 0.5 and 1.5 or -1.5), --x
            math.round(z / 4) * 4 + AddWorldOffset(tilezpercent, wty) + (tilezpercent >= 0.5 and 1.5 or -1.5) --z
    elseif inst:CanOnWater() then
        return math.round(x / 4) * 4 + AddWorldOffset(tilexpercent, wtx), --x
            (math.round(z / 4) * 4) + AddWorldOffset(tilezpercent, wty) --z
    end
end

function DoShoreMovement(inst, speed, ...)
    return DoFakePhysicsWallMovement(inst, speed, CanMoveAt, WaterLandBoundaries, ...)
end

local function IsWaterAny(tile)
	return IsWater(tile) or (tile >= GROUND.OCEAN_START and tile <= GROUND.OCEAN_END)
end

function TryMoveOnTile(inst, x, y, z, percentile)
    -- This does not apply to things specifically allowed to ignore water boundaries
    if inst:IsAmphibious() then
        return true
    end

    local tile = y ~= nil and z ~= nil and GetVisualTileType(x, y, z, percentile) or x

    if inst:CanOnLand() and not IsLand(tile) then
        return false
    elseif inst:CanOnWater() and not IsWaterAny(tile) then
        return false
    end

    return true
end

-- Only looks for water, not ground.
function FindWaterOffset(position, start_angle, radius, attempts, check_los, ignore_walls)
    if ignore_walls == nil then
        ignore_walls = true
    end

    local test = function(offset)
        local run_point = position+offset
        local ground = TheWorld
        local tile = GetVisualTileType(run_point.x, run_point.y, run_point.z, 0.001 / 4)

        if not IsWater(tile) or not ground.Map:IsPassableAtPoint(run_point:Get()) then
            return false
        end
        if check_los and not ground.Pathfinder:IsClear(position.x, position.y, position.z,
                                                         run_point.x, run_point.y, run_point.z,
                                                         {ignorewalls = ignore_walls, ignorecreep = true}) then
            return false
        end
        return true
    end

    return FindValidPositionByFan(start_angle, radius, attempts, test)
end

--Only looks for ground, not water.
function FindGroundOffset(position, start_angle, radius, attempts, check_los, ignore_walls)
    if ignore_walls == nil then
        ignore_walls = true
    end

    local test = function(offset)
        local run_point = position+offset
        local ground = TheWorld
        local tile = GetVisualTileType(run_point.x, run_point.y, run_point.z, 1.5 / 4)

        if not IsLand(tile) or not ground.Map:IsPassableAtPoint(run_point:Get()) then
            return false
        end
        if check_los and not ground.Pathfinder:IsClear(position.x, position.y, position.z,
                                                         run_point.x, run_point.y, run_point.z,
                                                         {ignorewalls = ignore_walls, ignorecreep = true}) then
            return false
        end
        return true
    end

    return FindValidPositionByFan(start_angle, radius, attempts, test)
end

--Checks if direction vector tar is between vec1 and vec2
local function isbetween(tar, vec1, vec2)
    return ((vec2.x - vec1.x) * (tar.z - vec1.z) - (vec2.z - vec1.z)*(tar.x-vec1.x)) > 0
end

function CheckLOSFromPoint(pos, target_pos)
    local dist = target_pos:Dist(pos)
    local vec = (target_pos - pos):GetNormalized()

    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, dist, {"blocker"})

    for k,v in pairs(ents) do
        local blocker_pos = v:GetPosition()
        local blocker_vec = (blocker_pos - pos):GetNormalized()
        local blocker_perp = Vector3(-blocker_vec.z, 0, blocker_vec.x)
        local blocker_radius = v.Physics:GetRadius()
        blocker_radius = math.max(0.75, blocker_radius)

        local blocker_edge1 = blocker_pos + Vector3(blocker_perp.x * blocker_radius, 0, blocker_perp.z * blocker_radius)
        local blocker_edge2 = blocker_pos - Vector3(blocker_perp.x * blocker_radius, 0, blocker_perp.z * blocker_radius)

        local blocker_vec1 = (blocker_edge1 - pos):GetNormalized()
        local blocker_vec2 = (blocker_edge2 - pos):GetNormalized()

        --[[
        print("Checking LoS With:", v)
        local colourstr = "00000"..v.GUID
        local r = tonumber(colourstr:sub(-6, -5), 16) / 255
        local g = tonumber(colourstr:sub(-4, -3), 16) / 255
        local b = tonumber(colourstr:sub(-2), 16) / 255
        --Note : world must have debugger component and be debug selected for this to display.
        GetWorld().components.debugger:SetAll(v.GUID.."_angle1", {x=pos.x, y=pos.z}, {x=pos.x + (blocker_vec1.x * dist*2), y= pos.z + (blocker_vec1.z * dist*2)}, {r=r,g=g,b=b,a=1})
        GetWorld().components.debugger:SetAll(v.GUID.."_angle2", {x=pos.x, y=pos.z}, {x=pos.x + (blocker_vec2.x * dist*2), y= pos.z + (blocker_vec2.z * dist*2)}, {r=r,g=g,b=b,a=1})
        --]]

        if isbetween(vec, blocker_vec1, blocker_vec2) then
            -- print(v, "blocks LoS.")
            -- print("-----------")
            return false
        end
    end
    -- print("Nothing blocked LoS.")
    -- print("-----------")

    return true
end

local NOCLICK = {}

function RemoveLocalNOCLICK(ent)
    NOCLICK[ent.entity or ent] = nil
    ent:RemoveEventCallback("onremove", RemoveLocalNOCLICK)
end

function LocalNOCLICK(ent)
    NOCLICK[ent.entity or ent] = true
    ent:ListenForEvent("onremove", RemoveLocalNOCLICK)
end

function IsLocalNOCLICKed(ent)
    return NOCLICK[ent.entity or ent] == true
end

local SGInstance = StateGraphInstance
local _GoToState = SGInstance.GoToState
function SGInstance:GoToState(statename, params, ...)
    self.nextstate = statename
    _GoToState(self, statename, params, ...)
    self.nextstate = nil
end


--Climate Util

local function MakeTestFn(climate, countneutral)
    local climatetiles = CLIMATE_TURFS[string.upper(climate)]
    return function(tile)
        return (climatetiles and climatetiles[tile]) or (countneutral and CLIMATE_TURFS.NEUTRAL[tile])
    end
end

local function TestTurfs(pt, testfn)
    if pt then
        local num = 0
        local srcx, srcy = TheWorld.Map:GetTileCoordsAtPoint(pt:Get())
        for tilex = srcx - 2, srcx + 2, 2 do
            for tiley = srcy - 2, srcy + 2, 2 do
                local tile = TheWorld.Map:GetOriginalTile(tilex, tiley)
                if testfn(tile) then
                    num = num + 1 --no tile is pretty neutral to me
                    if tilex == 0 and tiley == 0 then
                        num = num + 1 --add extra weight to current tile -M
                    end
                end
            end
        end
        return num > 5 --more than half
    end
end

local function TestRoom(inst, pt, climate)
	if CLIMATE_ROOMS[string.upper(climate)] then
		if not TheWorld.Map:IsPassableAtPoint(pt.x, 0, pt.z) then
			return
		end
		-- print("TestRoom",inst)
		local roomid
		-- if inst and not inst.components.areaaware and (inst.components.locomotor or inst.components.inventoryitem) then
			-- inst:AddComponent("areaaware") --make sure moving stuff updates more efficiently (then again, areaaware updates position every tick...)
		-- end
		if inst and inst.components.areaaware and inst.components.areaaware:GetCurrentArea() then
			roomid = inst.components.areaaware:GetCurrentArea().id
		else
			for i, node in ipairs(TheWorld.topology.nodes) do
				if TheSim:WorldPointInPoly(pt.x, pt.z, node.poly) then
					roomid = TheWorld.topology.ids[i]
					break
				end
			end
		end
		if roomid then
			-- if inst and inst:HasTag("player") then print("IN ROOM",roomid) end
			for _, v in pairs(CLIMATE_ROOMS[string.upper(climate)]) do
				if string.find(roomid, v) then
					-- if inst and inst:HasTag("player") then print("ROOM IS",climate) end
					return true
				end
			end
		end
	end
end

local function IsIslandRoomTag(inst, pt)
	-- if not TheWorld.Map:IsPassableAtPoint(pt.x, 0, pt.z) then
		-- return false
	-- end
	if inst and inst.components.areaaware and inst.components.areaaware:GetCurrentArea() then
		return inst.components.areaaware:CurrentlyInTag("islandclimate")
	end
	for i, node in ipairs(TheWorld.topology.nodes) do
		if TheSim:WorldPointInPoly(pt.x, pt.z, node.poly) then
			return table.contains(node.tags, "islandclimate")
		end
	end
end

function CalculateClimate(inst, pt, neutralclimate)
	if inst then
		pt = inst:GetPosition()
	end
	local validclimates = {}
	for i, v in ipairs(CLIMATES) do
		if TheWorld:HasTag(v) then
			validclimates[#validclimates + 1] = v
		end
	end

	if #validclimates == 1 then
		return CLIMATE_IDS[validclimates[1]]
	else
		local _climate
		for i = 2, #validclimates, 1 do
			local climate = validclimates[i]
			if (TheWorld.topology and TheWorld.topology.ia_worldgen_version)
			--hardcoding like yeah B^)  -M
			and ((climate == "island" and (IsOnWater(inst or pt) or IsIslandRoomTag(inst, pt)))
				or (climate == "volcano" and IsIslandRoomTag(inst, pt)))
			or not (TheWorld.topology and TheWorld.topology.ia_worldgen_version)
			--Should the MakeTestFn functions get cached? -M
			and (TestRoom(inst, pt, climate) or TestTurfs(pt, MakeTestFn(climate, neutralclimate and (climate == CLIMATES[neutralclimate])))) then
				-- print("CALC CLIMATE FOR ", inst or pt, climate)
				return CLIMATE_IDS[climate]
			end
		end
		-- print("CALC CLIMATE FAILED ", inst or pt)
		return CLIMATE_IDS[validclimates[1]]
	end

	--failed, just guess based on the world tags
	-- return TheWorld:HasTag("forest") and CLIMATE_IDS.forest or TheWorld:HasTag("cave") and CLIMATE_IDS.cave or CLIMATE_IDS.forest
end

function GetClimate(inst, forceupdate, neutralclimate)
	if not inst or type(inst) ~= "table" then print("Invalid use of GetClimate", inst) return CLIMATE_IDS.forest end
    if TheWorld.ismastersim then
		if inst.is_a and inst:is_a(EntityScript) then
			if not inst.components.climatetracker then
				inst:AddComponent("climatetracker")
			end
			return inst.components.climatetracker:GetClimate(forceupdate)
		elseif inst.is_a and inst:is_a(Vector3) then
			return CalculateClimate(nil, inst, neutralclimate)
		end
    else
        if inst.player_classified then
            return inst.player_classified._climate:value()
        elseif inst.is_a and inst:is_a(EntityScript) then
			if not forceupdate then
				for i, v in ipairs(CLIMATES) do
					if inst:HasTag("Climate_"..v) then
						return i
					end
				end
			end
			--failed, probably has no climatetracker, resort to CalculateClimate
			return CalculateClimate(inst, nil, neutralclimate)
		elseif inst.is_a and inst:is_a(Vector3) then
			return CalculateClimate(nil, inst, neutralclimate)
		end
    end
end

function IsInIAClimate(inst, forceupdate)
    local climate = GetClimate(inst, forceupdate)
    return climate == CLIMATE_IDS.island or climate == CLIMATE_IDS.volcano
end

function IsInClimate(inst, climate, forceupdate, neutralclimate)
    return CLIMATES[GetClimate(inst, forceupdate, neutralclimate)] == climate
end

--End of Climate Util


local _PerformBufferedAction = EntityScript.PerformBufferedAction
function EntityScript:PerformBufferedAction(...)
    local _bufferedaction = self.bufferedaction
    if _PerformBufferedAction(self, ...) == true then
        self:PushEvent("actionsuccess", {action = _bufferedaction})
        return true
    end
end

local _GetIsWet = EntityScript.GetIsWet
function EntityScript:GetIsWet(...)
    return _GetIsWet(self, ...) or IsOnFlood(self:GetPosition():Get()) and not (self.replica.inventoryitem and self.replica.inventoryitem:IsHeld())
end

local _GetAdjectivedName = EntityScript.GetAdjectivedName
function EntityScript:GetAdjectivedName(...)
	return self:HasTag("flooded") and ConstructAdjectivedName(self, self:GetBasicDisplayName(), STRINGS.FLOODEDITEM) or _GetAdjectivedName(self, ...) 
end

local _SetPrefabName = EntityScript.SetPrefabName
function EntityScript:SetPrefabName(name, ...)
    _SetPrefabName(self, name, ...)
    self.entity:SetPrefabName(self.realprefab or self.prefab)
end

local _GetSaveRecord = EntityScript.GetSaveRecord
function EntityScript:GetSaveRecord(...)
    local record, refs = _GetSaveRecord(self, ...)
    record.realprefab = self.realprefab
    return record, refs
end

local _SpawnSaveRecord = SpawnSaveRecord
function SpawnSaveRecord(saved, ...)
    saved.prefab = saved.realprefab or saved.prefab
    return _SpawnSaveRecord(saved, ...)
end

require("components/sleeper")

local _DefaultWakeTest = DefaultWakeTest
function DefaultWakeTest(inst, ...)
    return _DefaultWakeTest(inst, ...) and not (inst.components.poisonable and inst.components.poisonable:IsPoisoned())
end

local _StandardSleepChecks = StandardSleepChecks
function StandardSleepChecks(inst, ...)
    if inst.components.sleeper.onlysleepsfromitems then 
        return false
    end 
    return _StandardSleepChecks(inst, ...)
end

local _StandardWakeChecks = StandardWakeChecks
function StandardWakeChecks(inst, ...)
    if inst.components.sleeper.onlysleepsfromitems then 
        return true
    end 
    return _StandardWakeChecks(inst, ...)
end