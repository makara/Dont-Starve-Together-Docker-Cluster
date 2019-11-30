local IAENV = env
GLOBAL.setfenv(1, GLOBAL)
IAENV.AddSimPostInit(function()

--Map is not a proper component, so we edit it here instead.

local function IsWaterAny(tile)
	return IsWater(tile) or (tile >= GROUND.OCEAN_START and tile <= GROUND.OCEAN_END)
end

local function quantizepos(pt)
	local x, y, z = TheWorld.Map:GetTileCenterPoint(pt:Get())

	if pt.x > x then
		x = x + 1
	else
		x = x - 1
	end

	if pt.z > z then
		z = z + 1
	else
		z = z - 1
	end

	return Vector3(x,y,z)
end

local CanDeployAtPoint = Map.CanDeployAtPoint
function Map:CanDeployAtPoint(pt, inst, ...)
	if inst.prefab == "tar" then
		pt = quantizepos(pt)
		return CanDeployAtPoint(self, pt, inst, ...) and not IsOnWater(pt, nil, nil, nil, .4) --extra shore spacing
	end
	return CanDeployAtPoint(self, pt, inst, ...)
end

-- Placing on ocean or not
local _CanDeployRecipeAtPoint = Map.CanDeployRecipeAtPoint
function Map:CanDeployRecipeAtPoint(pt, recipe, rot, player)
    local candeploy = _CanDeployRecipeAtPoint(self, pt, recipe, rot, player)
	local test_valid = (not recipe.testfn or recipe.testfn(pt, rot)) and Map:IsDeployPointClear(pt, nil, recipe.min_spacing or 3.2)
    if not test_valid or (not candeploy and not recipe.aquatic) then return false end

    local tile = GROUND.GRASS
    local map = TheWorld.Map;
    tile = map:GetTileAtPoint(pt:Get())

    --how the heck do i figure this out?
    local boating = player ~= nil and IsOnWater(player)

    if tile == GROUND.IMPASSABLE or (boating and not recipe.aquatic) then
        return false
    end

    if recipe.aquatic then
		local x, y, z = pt:Get()
        if boating then
            local minBuffer = 2
            return IsWaterAny(tile) and
                IsWaterAny(map:GetTileAtPoint(x + minBuffer, y, z)) and
                IsWaterAny(map:GetTileAtPoint(x - minBuffer, y, z)) and
                IsWaterAny(map:GetTileAtPoint(x , y, z + minBuffer)) and
                IsWaterAny(map:GetTileAtPoint(x , y, z - minBuffer))
        else 
            if not IsShore(GetVisualTileType(x, y, z)) then return false end

            local maxBuffer = 2

            if not ((not IsWaterAny(GetVisualTileType(x + maxBuffer, y, z))) or
            (not IsWaterAny(GetVisualTileType(x - maxBuffer, y, z))) or
            (not IsWaterAny(GetVisualTileType(x , y, z + maxBuffer))) or
            (not IsWaterAny(GetVisualTileType(x , y, z - maxBuffer))) or
            (not IsWaterAny(GetVisualTileType(x + maxBuffer, y, z + maxBuffer))) or
            (not IsWaterAny(GetVisualTileType(x - maxBuffer, y, z + maxBuffer))) or
            (not IsWaterAny(GetVisualTileType(x + maxBuffer , y, z - maxBuffer))) or
            (not IsWaterAny(GetVisualTileType(x - maxBuffer , y, z - maxBuffer)))) then 
                return false 
            end

            local minBuffer = 0.5
            if recipe.name == "ballphinhouse" then --TODO this is not only hacky, but seems misplaced too -M
                minBuffer = 100
            end

            if ((not IsWaterAny(GetVisualTileType(x + minBuffer, y, z))) or
            (not IsWaterAny(GetVisualTileType(x - minBuffer, y, z))) or
            (not IsWaterAny(GetVisualTileType(x , y, z + minBuffer))) or
            (not IsWaterAny(GetVisualTileType(x , y, z - minBuffer))) or
            (not IsWaterAny(GetVisualTileType(x + minBuffer, y, z + minBuffer))) or
            (not IsWaterAny(GetVisualTileType(x - minBuffer, y, z + minBuffer))) or
            (not IsWaterAny(GetVisualTileType(x + minBuffer , y, z - minBuffer))) or
            (not IsWaterAny(GetVisualTileType(x - minBuffer , y, z - minBuffer)))) then
                return false
            end  

            return true
        end
    end

    return candeploy
end


function Map:CanVolcanoPlantAtPoint(x, y, z)
    local tile = self:GetTileAtPoint(x, y, z)
    return tile == GROUND.MAGMAFIELD or tile == GROUND.ASH or tile == GROUND.VOLCANO
end

local _CanDeployPlantAtPoint = Map.CanDeployPlantAtPoint
function Map:CanDeployPlantAtPoint(pt, inst, ...)
    if inst:HasTag("volcanicplant") then
        return self:CanVolcanoPlantAtPoint(pt:Get())
            and self:IsDeployPointClear(pt, inst, inst.replica.inventoryitem ~= nil and inst.replica.inventoryitem:DeploySpacingRadius() or DEPLOYSPACING_RADIUS[DEPLOYSPACING.DEFAULT])
    else
        return _CanDeployPlantAtPoint(self, pt, inst, ...)
    end
end

local _CanDeployWallAtPoint = Map.CanDeployWallAtPoint
function Map:CanDeployWallAtPoint(pt, inst, ...)

	for i, v in ipairs(TheSim:FindEntities(pt.x, 0, pt.z, 2, {"sandbag"})) do
        if v ~= inst and
            v.entity:IsVisible() and
            v.components.placer == nil and
            v.entity:GetParent() == nil then
			local opt = v:GetPosition()
			--important to remove sign in order to calculate accuracte distance
			if math.abs(math.abs(opt.x) - math.abs(pt.x)) < 1 and math.abs(math.abs(opt.z) - math.abs(pt.z)) < 1 then
				return false
			end
        end
    end

    return _CanDeployWallAtPoint(self, pt, inst, ...)
end

---------------------------------------------------------------------------------------------------------------------------------------------

for k, v in pairs(IA_VEGGIES) do
    table.insert(Prefabs.plant_normal.assets, Asset("ANIM", "anim/"..k))
    table.insert(Prefabs.plant_normal.deps, k)
    table.insert(Prefabs.seeds.deps, k)
    VEGGIES[k] = v
	if v.seed_weight then
		TUNING.BURNED_LOOT_OVERRIDES[k .."_seeds"] = "seeds_cooked"
	end
end

----------------------------------------------------------------------------------------------------------------------------------------

function RunAway:GetRunAngle(pt, hp)
  if self.avoid_angle ~= nil then
    local avoid_time = GetTime() - self.avoid_time
    if avoid_time < 1 then
      return self.avoid_angle
    else
      self.avoid_time = nil
      self.avoid_angle = nil
    end
  end

  local angle = self.inst:GetAngleToPoint(hp) + 180 -- + math.random(30)-15
  if angle > 360 then
    angle = angle - 360
  end

  --print(string.format("RunAway:GetRunAngle me: %s, hunter: %s, run: %2.2f", tostring(pt), tostring(hp), angle))

  local radius = 6

  local result_offset, result_angle, deflected = FindWalkableOffset(pt, angle*DEGREES, radius, 8, true, false, IsPositionValidForEnt(self.inst, 2)) -- try avoiding walls
  if result_angle == nil then
    result_offset, result_angle, deflected = FindWalkableOffset(pt, angle*DEGREES, radius, 8, true, true, IsPositionValidForEnt(self.inst, 2)) -- ok don't try to avoid walls, but at least avoid water
    if result_angle == nil then
      return angle -- ok whatever, just run
    end
  end

  result_angle = result_angle / DEGREES
  if deflected then
    self.avoid_time = GetTime()
    self.avoid_angle = result_angle
  end
  return result_angle
end

function Wander:PickNewDirection()
  self.far_from_home = self:IsFarFromHome()

  self.walking = true

  if self.far_from_home then
    --print("Far from home, going back")
    --print(self.inst, Point(self.inst.Transform:GetWorldPosition()), "FAR FROM HOME", self:GetHomePos())
    self.inst.components.locomotor:GoToPoint(self:GetHomePos())
  else
    local pt = Point(self.inst.Transform:GetWorldPosition())
    local angle = (self.getdirectionFn and self.getdirectionFn(self.inst)) 
    -- print("got angle ", angle) 
    if not angle then 
      angle = math.random()*2*PI
      --print("no angle, picked", angle, self.setdirectionFn)
      if self.setdirectionFn then
        --print("set angle to ", angle) 
        self.setdirectionFn(self.inst, angle)
      end
    end

    local radius = 12
    local attempts = 8
    local offset, check_angle, deflected = FindWalkableOffset(pt, angle, radius, attempts, true, false, IsPositionValidForEnt(self.inst, 2)) -- try to avoid walls
    if not check_angle then
      --print(self.inst, "no los wander, fallback to ignoring walls")
      offset, check_angle, deflected = FindWalkableOffset(pt, angle, radius, attempts, true, true, IsPositionValidForEnt(self.inst, 2)) -- if we can't avoid walls, at least avoid water
    end
    if check_angle then
      angle = check_angle
      if self.setdirectionFn then
        --print("(second case) reset angle to ", angle) 
        self.setdirectionFn(self.inst, angle)
      end
    else
      -- guess we don't have a better direction, just go whereever
      --print(self.inst, "no walkable wander, fall back to random")
    end
    --print(self.inst, pt, string.format("wander to %s @ %2.2f %s", tostring(offset), angle/DEGREES, deflected and "(deflected)" or ""))
    if offset then
      self.inst.components.locomotor:GoToPoint(self.inst:GetPosition() + offset)
    else
      self.inst.components.locomotor:WalkInDirection(angle/DEGREES)
    end
  end

  self:Wait(self.times.minwalktime+math.random()*self.times.randwalktime)
end

-------------------------- RANDOM TESTS ----------------------------------------

--CurrentFnToDebug = nil
--currentDebugLocals = nil
--currentDebugUpvals = nil

--mydebuggetstatus = "waiting"

--function SetFnToDebug(fn, base)
--  CurrentFnToDebug = base and getmetatable(base).__index.fn or fn
--  if CurrentFnToDebug ~= nil then
--    mydebuggetstatus = "ready"
--  end
--end

--function MyDebugGetLocal()
--  if mydebuggetstatus == "paused" then
--    return
--  end

--  local funcInf = debug.getinfo(2)

----  print("------------------HOOK------------------")
----  for k, v in pairs(funcInf) do
----    print(k,"=",v)
----  end

----  print("Hook fn for ", funcInf.func, "/ Currently tracked function:", CurrentFnToDebug)

--  currentDebugLocals = nil
--  currentDebugUpvals = nil

--  if CurrentFnToDebug ~= nil and funcInf.func == CurrentFnToDebug then
--    currentDebugLocals={}    
--    local i = 1
--    while true do
--      local n, v = debug.getlocal(2, i)
--      if not n then break end
----      print(tostring(n).." = "..tostring(v))
--      table.insert(currentDebugLocals, {name = n, value = v})
--      i = i + 1
--    end

--    currentDebugUpvals={}
--    i = 1
--    while true do
--      local n, v = debug.getupvalue (funcInf.func, i)
--      if not n then break end
----      print(tostring(n).." = "..tostring(v))
--      table.insert(currentDebugUpvals, {name = n, value = v})
--      i = i + 1
--    end

--    mydebuggetstatus = "paused"
--  end
--end

--debug.sethook(MyDebugGetLocal, "c")

end)
