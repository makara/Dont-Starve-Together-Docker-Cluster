GLOBAL. setfenv(1, GLOBAL)

local tuning_override = require("tuning_override")

-- local function OverrideTuningVariables(tuning)
    -- if tuning ~= nil then
        -- for k, v in pairs(tuning) do
            -- TUNING[k] = v
        -- end
    -- end
-- end

local SPAWN_MODE_FN =
{
    never = "SpawnModeNever",
    always = "SpawnModeHeavy",
    often = "SpawnModeMed",
    rare = "SpawnModeLight",
}

local function SetSpawnMode(spawner, difficulty)
    if spawner ~= nil then
        spawner[SPAWN_MODE_FN[difficulty]](spawner)
    end
end

-- local SEASON_FRIENDLY_LENGTHS =
-- {
    -- noseason = 0,
    -- veryshortseason = TUNING.SEASON_LENGTH_FRIENDLY_VERYSHORT,
    -- shortseason = TUNING.SEASON_LENGTH_FRIENDLY_SHORT,
    -- default = TUNING.SEASON_LENGTH_FRIENDLY_DEFAULT,
    -- longseason = TUNING.SEASON_LENGTH_FRIENDLY_LONG,
    -- verylongseason = TUNING.SEASON_LENGTH_FRIENDLY_VERYLONG,
-- }

-- local SEASON_HARSH_LENGTHS =
-- {
    -- noseason = 0,
    -- veryshortseason = TUNING.SEASON_LENGTH_HARSH_VERYSHORT,
    -- shortseason = TUNING.SEASON_LENGTH_HARSH_SHORT,
    -- default = TUNING.SEASON_LENGTH_HARSH_DEFAULT,
    -- longseason = TUNING.SEASON_LENGTH_HARSH_LONG,
    -- verylongseason = TUNING.SEASON_LENGTH_HARSH_VERYLONG,
-- }

local MULTIPLY = {
	["never"] = 0,
	["veryrare"] = 0.25,
	["rare"] = 0.5,
	["default"] = 1,
	["often"] = 1.5,
	["always"] = 2,
}
local MULTIPLY_COOLDOWNS = {
	["never"] = 0,
	["veryrare"] = 2,
	["rare"] = 1.5,
	["default"] = 1,
	["often"] = .5,
	["always"] = .25,
}
local MULTIPLY_WAVES = {
	["never"] = 0,
	["veryrare"] = 0.25,
	["rare"] = 0.5,
	["default"] = 1,
	["often"] = 1.25,
	["always"] = 1.5,
}


--Overrides are after Load.
--To allow island components to Load, this is usually handled PreLoad in postinit/prefabs/world.lua
--However, the first time the world starts, there is no load, so this is the next-best opportunity.
tuning_override.primaryworldtype = function(difficulty)
	if difficulty ~= "default" and not TheWorld:HasTag("island") then
		TheWorld:AddTag("island")
	end
	if difficulty ~= "default" and difficulty ~= "merged" and TheWorld:HasTag("forest") then
		TheWorld:RemoveTag("forest")
	end
	if TheWorld.installIAcomponents then
		TheWorld:installIAcomponents()
	end
end

tuning_override.volcano = function(difficulty)
    if difficulty == "never" then
        local vm = TheWorld.components.volcanomanager
        if vm then
            vm:SetIntensity(0)
        end
    end
end

tuning_override.dragoonegg = function(difficulty)
    local vm = TheWorld.components.volcanomanager
    if vm then
		vm:SetFirerainIntensity(MULTIPLY[difficulty] or 1)
    end
end

tuning_override.tides = function(difficulty)
    if difficulty == "never" then
        local flooding = TheWorld.components.flooding
        if flooding then
            flooding:SetMaxTideModifier(0)
        end
    end
end

tuning_override.floods = function(difficulty)
    local flooding = TheWorld.components.flooding
    if flooding then
        local lvl = TUNING.MAX_FLOOD_LEVEL --15,
        local freq = TUNING.FLOOD_FREQUENCY --0.005,
		flooding:SetFloodSettings(math.min(1, MULTIPLY[difficulty]) * lvl, (MULTIPLY[difficulty] or 1) * freq)
    end
end

tuning_override.oceanwaves = function(difficulty)
	local wm = TheWorld.components.wavemanager_ia
	if wm then
		wm:SetWaveSettings(MULTIPLY[difficulty] or 1)
	end
	TUNING.WATERVISUALSHIMMER = MULTIPLY_WAVES[difficulty] or 1
	TUNING.WATERVISUALCAMERA = MULTIPLY_WAVES[difficulty] or 1
	-- OverrideTuningVariables({
		-- WATERVISUALSHIMMER = MULTIPLY_WAVES[difficulty] or 1,
		-- WATERVISUALCAMERA = MULTIPLY_WAVES[difficulty] or 1,
	-- })
end

tuning_override.poison = function(difficulty)
	IA_CONFIG.poisonenabled = difficulty ~= "never"
end

tuning_override.tigershark = function(difficulty)
	local tigersharker = TheWorld.components.tigersharker
	if tigersharker then
		tigersharker:SetChanceModifier(MULTIPLY[difficulty] or 1)
		tigersharker:SetCooldownModifier(MULTIPLY_COOLDOWNS[difficulty] or 1)
	end
end

tuning_override.kraken = function(difficulty)
	local krakener = TheWorld.components.krakener
	if krakener then
		krakener:SetChanceModifier(MULTIPLY[difficulty] or 1)
		krakener:SetCooldownModifier(MULTIPLY_COOLDOWNS[difficulty] or 1)
	end
end

tuning_override.twister = function(difficulty)
local basehassler = TheWorld.components.twisterspawner
	if basehassler then
		if difficulty == "never" then
			basehassler:OverrideAttacksPerSeason("TWISTER", 0)
		elseif difficulty == "often" or difficulty == "always" then
			basehassler:OverrideAttacksPerSeason("TWISTER", 2)
		else
			basehassler:OverrideAttacksPerSeason("TWISTER", 1)
		end
		if difficulty == "always" then
			basehassler:OverrideAttackDuringOffSeason("TWISTER", true)
		else
			basehassler:OverrideAttackDuringOffSeason("TWISTER", false)
		end
	end
end

tuning_override.mosquitos = function(difficulty)
	if TheWorld.components.floodmosquitospawner then
		SetSpawnMode(TheWorld.components.floodmosquitospawner, difficulty)
	end
end
