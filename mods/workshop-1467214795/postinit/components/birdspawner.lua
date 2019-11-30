local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

IAENV.AddComponentPostInit("birdspawner", function(cmp)


-- Birds shall not land on water

--local _SpawnBird = self.SpawnBird
--function self:SpawnBird(spawnpoint, ...)
--  if not IsOnWater(spawnpoint:Get()) then
--    _SpawnBird(self, spawnpoint, ...)
--  end
--end

-- local _GetSpawnPoint = self.GetSpawnPoint
-- function self:GetSpawnPoint(pt)
  -- local target = _GetSpawnPoint(self, pt)
  -- if target and not IsOnWater(target:Get()) then
    -- return target
  -- end
-- end

local birdvstile = {
	[GROUND.DIRT] = "toucan",
	[GROUND.ROCKY] = "toucan",
	[GROUND.SAVANNA] = {"parrot","toucan"},
	[GROUND.GRASS] = "parrot",
	[GROUND.FOREST] = {"toucan","parrot"},
	[GROUND.MARSH] = "toucan",

	[GROUND.SNAKESKIN] = {"toucan","parrot"},

	[GROUND.MEADOW] = "toucan",
	[GROUND.BEACH] = "toucan",
	[GROUND.JUNGLE] = "parrot",
	[GROUND.SWAMP] = "toucan",
	-- [GROUND.MANGROVE] = "seagull",
	-- [GROUND.MAGMAFIELD] = "toucan",
	-- [GROUND.TIDALMARSH] = "toucan",
}

local function IsDangerNearby(x, y, z)
  local ents = TheSim:FindEntities(x, y, z, 8, { "scarytoprey" })
  return next(ents) ~= nil
end

local SpawnBirdOld = cmp.SpawnBird

local RelevantSpawnBird = function(self, bird_prefab, spawnpoint, ignorebait)
  local isonwater = IsOnWater(spawnpoint:Get())
  
  local bird = SpawnPrefab(bird_prefab)
  if math.random() < .5 then
    bird.Transform:SetRotation(180)
  end
  if bird:HasTag("bird") then
    spawnpoint.y = 15
  end 
  
  if bird.components.eater and not ignorebait then
    local bait = TheSim:FindEntities(spawnpoint.x, 0, spawnpoint.z, 15)
    for k, v in pairs(bait) do
      local x, y, z = v.Transform:GetWorldPosition()
      if bird.components.eater:CanEat(v) and
      v.components.bait and
      not (v.components.inventoryitem and v.components.inventoryitem:IsHeld()) and
      not IsDangerNearby(x, y, z) and
	  (isonwater or not IsOnWater(x,y,z)) then --do not spawn land birds on water
        spawnpoint.x, spawnpoint.z = x, z
        bird.bufferedaction = BufferedAction(bird, v, ACTIONS.EAT)
        break
      elseif v.components.trap and
      v.components.trap.isset and
      (not v.components.trap.targettag or bird:HasTag(v.components.trap.targettag)) and
      not v.components.trap.issprung and
      math.random() < TUNING.BIRD_TRAP_CHANCE and
      not IsDangerNearby(x, y, z) and
	  (isonwater or not IsOnWater(x,y,z)) then
        spawnpoint.x, spawnpoint.z = x, z
        break
      end
    end
  end

  bird.Physics:Teleport(spawnpoint:Get())

  return bird
end

function cmp:SpawnBird(spawnpoint, ignorebait)
  local tile = TheWorld.Map:GetTileAtPoint(spawnpoint:Get())
  local bird_prefab = nil

  if IsOnWater(spawnpoint:Get()) then
	if math.random() < TUNING.CORMORANT_CHANCE then
		bird_prefab = "cormorant"
	else
		bird_prefab = "seagull"
	end

  elseif IsInIAClimate(spawnpoint) then
    if tile == GROUND.BEACH and TheWorld.state.iswinter then
      bird_prefab = "seagull"

    elseif birdvstile[tile] ~= nil then
      if type(birdvstile[tile]) == "table" then
        bird_prefab = GetRandomItem(birdvstile[tile])
      else
        bird_prefab = birdvstile[tile]
      end

      if bird_prefab == "parrot" and math.random() < TUNING.PARROT_PIRATE_CHANCE then
        bird_prefab = "parrot_pirate"
      end

    else
      return --SW explicitly does not spawn birds on undefined turfs
    end

  else
    return SpawnBirdOld(self, spawnpoint, ignorebait)
  end

  return RelevantSpawnBird(self, bird_prefab, spawnpoint, ignorebait)
end


end)
