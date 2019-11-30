local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

IAENV.AddComponentPostInit("shadowcreaturespawner", function(cmp)


local StartSpawn
for i, v in ipairs(cmp.inst.event_listening["ms_playerjoined"][TheWorld]) do
	if UpvalueHacker.GetUpvalue(v, "OnInducedInsanity") then
        StartSpawn =  UpvalueHacker.GetUpvalue(v, "Start", "UpdatePopulation", "StartSpawn")
		break
	end
end
if not StartSpawn then return end

local _UpdateSpawn =  UpvalueHacker.GetUpvalue(StartSpawn, "UpdateSpawn")
local SPAWN_INTERVAL =  UpvalueHacker.GetUpvalue(_UpdateSpawn, "SPAWN_INTERVAL")
local SPAWN_VARIANCE =  UpvalueHacker.GetUpvalue(_UpdateSpawn, "SPAWN_VARIANCE")
local _StartTracking =  UpvalueHacker.GetUpvalue(_UpdateSpawn, "StartTracking")

--No need to set this upvalue, it isn't used anywhere but in our UpdateSpawn edit.
local function StartTracking(player, params, ent, ...)
    ent:ListenForEvent("embarkboat", function()
        if not ent:CanOnWater() then
			ent.spawnedforplayer = nil
			ent.persists = false
			ent.wantstodespawn = true
		end
    end, player)
    ent:ListenForEvent("disembarkboat", function()
        if not ent:CanOnLand() then
			ent.spawnedforplayer = nil
			ent.persists = false
			ent.wantstodespawn = true
		end
    end, player)
	return _StartTracking(player, params, ent, ...)
end

local function UpdateSpawn(player, params, ...)
    if IsLand(GetVisualTileType(player.Transform:GetWorldPosition())) and params.targetpop > #params.ents then
        local playerpos = player:GetPosition()
        local offset = FindGroundOffset(playerpos, 2*math.pi*math.random(), 15, 12)
        if offset then
            offset = offset + playerpos
            local ent = SpawnPrefab(
                player.components.sanity:GetPercent() < .1 and
                math.random() < .5 and
                "terrorbeak" or
                "crawlinghorror"
            )
            ent.Transform:SetPosition(offset:Get())
            StartTracking(player, params, ent)
        end
        --Reschedule spawning if we haven't reached our target population
        params.spawntask =
            params.targetpop ~= #params.ents
            and player:DoTaskInTime(SPAWN_INTERVAL + SPAWN_VARIANCE * math.random(), UpdateSpawn, params)
            or nil
        return
    elseif IsWater(GetVisualTileType(player.Transform:GetWorldPosition())) and params.targetpop > #params.ents then
        local playerpos = player:GetPosition()
        local offset = FindWaterOffset(playerpos, 2*math.pi*math.random(), 15, 12)
        if offset then
            offset = offset + playerpos
            local ent = SpawnPrefab("swimminghorror")
            ent.Transform:SetPosition(offset:Get())
            StartTracking(player, params, ent)
        end
        --Reschedule spawning if we haven't reached our target population
        params.spawntask =
            params.targetpop ~= #params.ents
            and player:DoTaskInTime(SPAWN_INTERVAL + SPAWN_VARIANCE * math.random(), UpdateSpawn, params)
            or nil
        return
    end
    return _UpdateSpawn(player, params, ...)
end

UpvalueHacker.SetUpvalue(StartSpawn, UpdateSpawn, "UpdateSpawn")


end)