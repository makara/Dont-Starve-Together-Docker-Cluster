local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

local easing = require("easing")

IAENV.AddComponentPostInit("weather", function(inst)



local _world = TheWorld
local _ismastersim = _world.ismastersim
local _activatedplayer = nil

inst.cannotsnow = _world:HasTag("island") --for TileState

--------------------------------------------------------------------------
--[[ constants ]]
--------------------------------------------------------------------------

--We could fetch the actual upvalues, if any mod adds precip or lightning modes -M
local PRECIP_MODE_NAMES =
{
    "dynamic",
    "always",
    "never",
}
local PRECIP_MODES = table.invert(PRECIP_MODE_NAMES)
local PRECIP_TYPE_NAMES =
{
    "none",
    "rain",
    "snow",
}
local PRECIP_TYPES = table.invert(PRECIP_TYPE_NAMES)
local LIGHTNING_MODE_NAMES =
{
    "rain",
    "snow",
    "any",
    "always",
    "never",
}
local LIGHTNING_MODES = table.invert(LIGHTNING_MODE_NAMES)

local PRECIP_RATE_SCALE = 10
local MIN_PRECIP_RATE = .1
--how fast clouds form
local MOISTURE_RATES = {
    MIN = {
        autumn = 0,
        winter = 3,
        spring = 3,
        summer = 0,
    },
    MAX = {
        autumn = 0.1,
        winter = 3.75,
        spring = 3.75,
        summer = -0.2, --I figured making it dry this way is more fun -M
    }
}

--When the ceil is reached, it starts raining (unit is average days till rain)
local MOISTURE_CEIL_MULTIPLIERS =
{
    autumn = 5.5,
    winter = 6,
    spring = 5.5,
    summer = 4,
}

--When the floor is reached, it stops raining
local MOISTURE_FLOOR_MULTIPLIERS =
{
    autumn = 1,
    winter = 0.5,
    spring = 0.25,
    summer = 1,
}

--POP is not used in SW, so I guessed some reasonable values -M
local PEAK_PRECIPITATION_RANGES =
{
    autumn = { min = 1.0, max = 1.0 },
    winter = { min = 0.8, max = 1.0 },
    spring = { min = 0.3, max = 0.9 },
    summer = { min = 1.0, max = 1.0 },
}
local DRY_THRESHOLD = TUNING.MOISTURE_DRY_THRESHOLD
local WET_THRESHOLD = TUNING.MOISTURE_WET_THRESHOLD
local MIN_WETNESS = 0
local MAX_WETNESS = 100
local MIN_WETNESS_RATE = 0
local MAX_WETNESS_RATE = .75
local MIN_DRYING_RATE = 0
local MAX_DRYING_RATE = .3
local OPTIMAL_DRYING_TEMPERATURE = 70
local WETNESS_SYNC_PERIOD = 10
local SNOW_LEVEL_SYNC_PERIOD = .1

local SEASON_DYNRANGE_DAY = {
    autumn = .05,
    winter = .3,
    spring = .35,
    summer = .05,
}
local SEASON_DYNRANGE_NIGHT = {
    autumn = 0,
    winter = .5,
    spring = .25,
    summer = 0,
}

--[[ Hurricane constants ]]
local GUST_PHASE_NAMES = {
	"calm", --in SW called "wait"
	"active",
	"rampup",
	"rampdown",
}
local GUST_PHASES = table.invert(GUST_PHASE_NAMES)

--------------------------------------------------------------------------

local _hailsound = false
local _windsound = false

local _rainfx
local _snowfx
local _pollenfx
local _hasfx = false
-- local function TryGetFX(player)
	-- local pt = player and player:GetPosition() or {x=0,y=0,z=0}
	-- for i,v in pairs( TheSim:FindEntities(pt.x, pt.y, pt.z, 1, {"FX"}) ) do
		-- if v.prefab then
			-- if v.prefab == "rain" then
				-- _rainfx = v
			-- elseif v.prefab == "snow" then
				-- _snowfx = v
			-- elseif v.prefab == "pollen" then
				-- _pollenfx = v
			-- end
		-- end
	-- end
	-- local _hasfx = _rainfx ~= nil
-- end
-- TryGetFX(ThePlayer)
for i,v in pairs( Ents ) do
	if v.prefab then
		if v.prefab == "rain" then
			_rainfx = v
		elseif v.prefab == "snow" then
			_snowfx = v
		elseif v.prefab == "pollen" then
			_pollenfx = v
		end
	end
end
local _hasfx = _rainfx ~= nil
local _hailfx = _hasfx and SpawnPrefab("hail") or nil

local _season = "autumn"
local _isIAClimate = false

--This is just a crude bandaid fix because other mods override inst.OnUpdate, but we need its upvalues -M
local trueOnUpdate = inst.LongUpdate
--local upvname, upvalue = debug.getupvalue(trueOnUpdate, 1) --TODO ideally loop through all using UpvalueHacker
--while upvname == "_OnUpdate" or upvname == "OnUpdate_old" do
	--trueOnUpdate = upvalue
	--upvname, upvalue = debug.getupvalue(trueOnUpdate, 1)
--end

local StopAmbientRainSound_old = UpvalueHacker.GetUpvalue(trueOnUpdate, "StopAmbientRainSound")
local StopTreeRainSound_old = UpvalueHacker.GetUpvalue(trueOnUpdate, "StopTreeRainSound")
local StopUmbrellaRainSound_old = UpvalueHacker.GetUpvalue(trueOnUpdate, "StopUmbrellaRainSound")
--TODO this should probably be generalised to "is regular climate"
local StopAmbientRainSound = function(...) if not _isIAClimate then StopAmbientRainSound_old(...) end end
local StopTreeRainSound = function(...) if not _isIAClimate then StopTreeRainSound_old(...) end end
local StopUmbrellaRainSound = function(...) if not _isIAClimate then StopUmbrellaRainSound_old(...) end end
UpvalueHacker.SetUpvalue(trueOnUpdate, StopAmbientRainSound, "StopAmbientRainSound")
UpvalueHacker.SetUpvalue(trueOnUpdate, StopTreeRainSound, "StopTreeRainSound")
UpvalueHacker.SetUpvalue(trueOnUpdate, StopUmbrellaRainSound, "StopUmbrellaRainSound")

local StartAmbientRainSound = UpvalueHacker.GetUpvalue(trueOnUpdate, "StartAmbientRainSound")
local StartTreeRainSound = UpvalueHacker.GetUpvalue(trueOnUpdate, "StartTreeRainSound")
local StartUmbrellaRainSound = UpvalueHacker.GetUpvalue(trueOnUpdate, "StartUmbrellaRainSound")
local SetWithPeriodicSync = UpvalueHacker.GetUpvalue(trueOnUpdate, "SetWithPeriodicSync")

local function StartAmbientHailSound(intensity)
    if not _hailsound then
        _hailsound = true
        _world.SoundEmitter:PlaySound("ia/amb/rain/islandhailAMB", "hail")
    end
    _world.SoundEmitter:SetParameter("hail", "intensity", intensity)
end

local function StopAmbientHailSound()
    if _hailsound then
        _hailsound = false
        _world.SoundEmitter:KillSound("hail")
    end
end

local function StartAmbientWindSound(intensity)
    if not _windsound then
        _windsound = true
        _world.SoundEmitter:PlaySound("ia/amb/rain/islandwindAMB", "wind")
    end
    _world.SoundEmitter:SetParameter("wind", "intensity", intensity)
end

local function StopAmbientWindSound()
    if _windsound then
        _windsound = false
        _world.SoundEmitter:KillSound("wind")
    end
end

--Master simulation
local _moisturerateval = _ismastersim and 1 or nil
local _moisturerateoffset = _ismastersim and 0 or nil
local _moistureratemultiplier = _ismastersim and 1 or nil
local _moistureceilmultiplier = _ismastersim and 1 or nil
local _moisturefloormultiplier = _ismastersim and 1 or nil
local _lightningtargets_island = _ismastersim and {} or nil
local _lightningmode = UpvalueHacker.GetUpvalue(trueOnUpdate, "_lightningmode")
--let's hope nobody notices that we basically generate twice as much lightning if both climates are active (unlikely)
local _minlightningdelay_island = nil
local _maxlightningdelay_island = nil
local _nextlightningtime_island = _ismastersim and 5 or nil

local _hurricane_gust_timer = 0.0 --needed by client for simulation
local _hurricane_gust_period = 0.0 --needed by client for simulation
local _hurricane_gust_angletimer = _ismastersim and 0.0 or nil
local _hurricanetease_start = _ismastersim and 0 or nil
local _hurricanetease_started = _ismastersim and false or nil


--Network
local _noisetime = UpvalueHacker.GetUpvalue(trueOnUpdate, "_noisetime")
local _moisture_island = net_float(inst.inst.GUID, "weather._moisture_island")
local _moisturerate_island = net_float(inst.inst.GUID, "weather._moisturerate_island")
local _moistureceil_island = net_float(inst.inst.GUID, "weather._moistureceil_island", "moistureceil_islanddirty")
local _moisturefloor_island = net_float(inst.inst.GUID, "weather._moisturefloor_island")
local _peakprecipitationrate_island = net_float(inst.inst.GUID, "weather._peakprecipitationrate_island")
local _wetness_island = net_float(inst.inst.GUID, "weather._wetness_island")
local _wet_island = net_bool(inst.inst.GUID, "weather._wet_island", "wet_islanddirty")
--this is "preciptype" except there's only rain on islands, so it can be a bool just fine
local _precipisland = net_bool(inst.inst.GUID, "weather._precipisland", "precipislanddirty")
local _precipmode = UpvalueHacker.GetUpvalue(trueOnUpdate, "_precipmode")
local _snowlevel = UpvalueHacker.GetUpvalue(trueOnUpdate, "_snowlevel")
local _lightningtargets = UpvalueHacker.GetUpvalue(trueOnUpdate, "_lightningtargets")
local _hurricane = net_bool(inst.inst.GUID, "weather._hurricane", "hurricanedirty")
local _hurricane_timer = net_float(inst.inst.GUID, "weather._hurricane_timer")
local _hurricane_duration = net_float(inst.inst.GUID, "weather._hurricane_duration")
local _hurricane_gust_speed = net_float(inst.inst.GUID, "weather._hurricane_gust_speed", "hurricane_gust_speeddirty")
--note: _hurricane_gust_angle is a net_ushortint, so it is only whole, positive numbers 
local _hurricane_gust_angle = net_ushortint(inst.inst.GUID, "weather._hurricane_gust_angle", "hurricane_gust_angledirty")
local _hurricane_gust_peak = net_float(inst.inst.GUID, "weather._hurricane_gust_peak")
local _hurricane_gust_state = net_tinybyte(inst.inst.GUID, "weather._hurricane_gust_state")

--------------------------------------------------------------------------
--[[ HURRICANE ]]
--------------------------------------------------------------------------

--TODO this has to be re-written to support client prediction better
local function UpdateHurricaneWind(dt)
	-- TheSim:ProfilerPush("hurricanewind")
	local percent = _hurricane_timer:value() / _hurricane_duration:value()
	if TUNING.HURRICANE_PERCENT_WIND_START <= percent and percent <= TUNING.HURRICANE_PERCENT_WIND_END then
		_hurricane_gust_timer = _hurricane_gust_timer + dt
		if _ismastersim then
			--TODO This should almost certainly be a DoTaskInTime -M
			--or test when exactly it changes in SW, might be cooler to make it change at sunset
			_hurricane_gust_angletimer = _hurricane_gust_angletimer + dt
			if _hurricane_gust_angletimer > 16*TUNING.SEG_TIME then		
				_hurricane_gust_angle:set(math.random(0,360))
				_hurricane_gust_angletimer = 0
			end
		end
		
		if _hurricane_gust_state:value() == GUST_PHASES.calm then
			_hurricane_gust_speed:set(0)
			if _hurricane_gust_timer >= _hurricane_gust_period then
				-- print("GUST Ramp up")
				_hurricane_gust_peak:set(GetRandomMinMax(TUNING.WIND_GUSTSPEED_PEAK_MIN, TUNING.WIND_GUSTSPEED_PEAK_MAX))
				_hurricane_gust_timer = 0.0
				_hurricane_gust_period = TUNING.WIND_GUSTRAMPUP_TIME
				_hurricane_gust_state:set(GUST_PHASES.rampup)
				-- self.inst:PushEvent("wind_rampup")
				-- self.inst:PushEvent("windguststart")
			end

		elseif _hurricane_gust_state:value() == GUST_PHASES.rampup then
			local peak = 0.5 * _hurricane_gust_peak:value()
			local gustspeed = -peak * math.cos(PI * _hurricane_gust_timer / _hurricane_gust_period) + peak
			SetWithPeriodicSync(_hurricane_gust_speed, gustspeed, 20, _ismastersim)
			if _hurricane_gust_timer >= _hurricane_gust_period then
				-- print("GUST Peak")
				_hurricane_gust_timer = 0.0
				_hurricane_gust_period = _ismastersim and GetRandomMinMax(TUNING.WIND_GUSTLENGTH_MIN, TUNING.WIND_GUSTLENGTH_MAX) or TUNING.WIND_GUSTLENGTH_MAX + 10
				_hurricane_gust_state:set(GUST_PHASES.active)
			end

		elseif _hurricane_gust_state:value() == GUST_PHASES.active then
			_hurricane_gust_speed:set(_hurricane_gust_peak:value())
			if _hurricane_gust_timer >= _hurricane_gust_period then
				-- print("GUST Ramp down")
				_hurricane_gust_timer = 0.0
				_hurricane_gust_period = TUNING.WIND_GUSTRAMPDOWN_TIME
				_hurricane_gust_state:set(GUST_PHASES.rampdown)
			end

		elseif _hurricane_gust_state:value() == GUST_PHASES.rampdown then
			local peak = 0.5 * _hurricane_gust_peak:value()
			local gustspeed = peak * math.cos(PI * _hurricane_gust_timer / _hurricane_gust_period) + peak
			SetWithPeriodicSync(_hurricane_gust_speed, gustspeed, 20, _ismastersim)
			if _hurricane_gust_timer >= _hurricane_gust_period then
				-- print("GUST Calm")
				_hurricane_gust_timer = 0.0
				_hurricane_gust_period = _ismastersim and GetRandomMinMax(TUNING.WIND_GUSTDELAY_MIN, TUNING.WIND_GUSTDELAY_MAX) or TUNING.WIND_GUSTDELAY_MAX + 10
				_hurricane_gust_state:set(GUST_PHASES.calm)
				-- self.inst:PushEvent("windgustend")
			end
		end
	else
		_hurricane_gust_timer = 0.0
		_hurricane_gust_speed:set(0.0)
	end
	-- TheSim:ProfilerPop()
end


local function StartHurricaneStorm(duration_override)
	if not _hurricane:value() then
		print("Hurricane start")
		_hurricane_timer:set(0)
		_hurricane_duration:set(duration_override or math.random(TUNING.HURRICANE_LENGTH_MIN, TUNING.HURRICANE_LENGTH_MAX))

		_hurricane_gust_speed:set(0.0)
		_hurricane_gust_timer = 0.0
		_hurricane_gust_period = 0.0 --GetRandomWithVariance(10.0, 4.0)
		_hurricane_gust_peak:set(0.0) --GetRandomWithVariance(0.5, 0.25)
		_hurricane_gust_state:set(GUST_PHASES.calm)
		
		_hurricane:set(true)
	end
end

local function StopHurricaneStorm()
	if _hurricane:value() then
		print("Hurricane stop")
		_hurricane_gust_speed:set(0.0)
		_hurricane_gust_timer = 0.0
		_hurricane_gust_period = 0.0
		_hurricane_gust_peak:set(0.0)
		_hurricane_gust_state:set(GUST_PHASES.calm)
		_hurricane:set(false)
	end
end

--dunno if we really need tease, since hurricane no longer triggers precip either way -M
-- local function StartHurricaneTease(duration_override)
	-- StartHurricaneStorm(duration_override)
-- end

-- local function StopHurricaneTease()
	-- StopHurricaneStorm()
-- end

--------------------------------------------------------------------------

local CalculateMoistureRate_Island = _ismastersim and function()
    return _moisturerateval * _moistureratemultiplier + _moisturerateoffset
end or nil

local RandomizeMoistureCeil_Island = _ismastersim and function()
    return (1 + math.random()) * TUNING.TOTAL_DAY_TIME * _moistureceilmultiplier
end or nil

local RandomizeMoistureFloor_Island = _ismastersim and function()
    return (.25 + math.random() * .5) * _moisture_island:value() * _moisturefloormultiplier
end or nil

local RandomizePeakPrecipitationRate_Island = _ismastersim and function(season)
    local range = PEAK_PRECIPITATION_RANGES[season]
    return range.min + math.random() * (range.max-range.min)
end or nil

local function CalculatePrecipitationRate_Island()
    if _precipmode:value() == PRECIP_MODES.always then
        return .1 + perlin(0, _noisetime:value() * .1, 0) * .9
    elseif _precipisland:value() and _precipmode:value() ~= PRECIP_MODES.never then
        local p = (_moisture_island:value() - _moisturefloor_island:value()) / (_moistureceil_island:value() - _moisturefloor_island:value())
		p = math.max(0, math.min(1, p))
        local rate = MIN_PRECIP_RATE + (1 - MIN_PRECIP_RATE) * math.sin(p * PI)
		-- if _hurricane:value() then
			-- rate = rate * TUNING.HURRICANE_RAIN_SCALE
		-- end
        return math.min(rate, _peakprecipitationrate_island:value())
    end
    return 0
end

local StartPrecipitation_Island = _ismastersim and function()
    _nextlightningtime_island = GetRandomMinMax(_minlightningdelay_island or 5, _maxlightningdelay_island or 15)
	_moisture_island:set(_moistureceil_island:value())
	_moisturefloor_island:set(RandomizeMoistureFloor_Island(_season))
	_peakprecipitationrate_island:set(RandomizePeakPrecipitationRate_Island(_season))
	_precipisland:set(true)
	if _season == "winter" then --should already be handled in OnUpdate
		StartHurricaneStorm()
	end
end or nil

local StopPrecipitation_Island = _ismastersim and function()
	_moisture_island:set(_moisturefloor_island:value())
	_moistureceil_island:set(RandomizeMoistureCeil_Island())
	_precipisland:set(false)
	-- StopHurricaneStorm() --uses _hurricane_timer instead
end or nil

--this is ONLY used in PushWeather
local function CalculatePOP_Island()
    return (_precipisland:value() and 1)
        or ((_moistureceil_island:value() <= 0 or _moisture_island:value() <= _moisturefloor_island:value()) and 0)
        or (_moisture_island:value() < _moistureceil_island:value() and (_moisture_island:value() - _moisturefloor_island:value()) / (_moistureceil_island:value() - _moisturefloor_island:value()))
        or 1
end

--this is ONLY used in PushWeather
local function CalculateLight_Island()
    if _precipmode:value() == PRECIP_MODES.never then
        return 1
    end
	
    local dynrange = _world.state.isday and SEASON_DYNRANGE_DAY[_season] or SEASON_DYNRANGE_NIGHT[_season]

    if _precipmode:value() == PRECIP_MODES.always then
        return 1 - dynrange
    end
    local p = 1 - math.min(math.max((_moisture_island:value() - _moisturefloor_island:value()) / (_moistureceil_island:value() - _moisturefloor_island:value()), 0), 1)
    if _precipisland:value() then
        p = easing.inQuad(p, 0, 1, 1)
    end
    return p * dynrange + 1 - dynrange
end

--this is ONLY called in OnUpdate
local function CalculateWetnessRate_Island(temperature, preciprate)
	return --Positive wetness rate when it's raining
		(_precipisland:value() and easing.inSine(preciprate, MIN_WETNESS_RATE, MAX_WETNESS_RATE, 1))
		--Negative drying rate when it's not raining
		or -math.clamp(easing.linear(temperature, MIN_DRYING_RATE, MAX_DRYING_RATE, OPTIMAL_DRYING_TEMPERATURE)
					+ easing.inExpo(_wetness_island:value(), 0, 1, MAX_WETNESS),
					.01, 1)
end

local function PushWeather_Island()
    local data =
    {
        moisture = _moisture_island:value(),
        pop = CalculatePOP_Island(),
        precipitationrate = CalculatePrecipitationRate_Island(),
        snowlevel = 0,
        wetness = _wetness_island:value(),
        light = CalculateLight_Island(),
		-- gustspeed = _hurricane_gust_speed:value(),
    }
	_world:PushEvent("islandweathertick", data)
	if not _ismastersim then --update visuals directly, probably the cause of some weird subtle bugs
		_world:PushEvent("weathertick", data)
	end
end

--------------------------------------------------------------------------
--[[ Event Callbacks ]]
--------------------------------------------------------------------------

local function OnSeasonTick_Island(src, data)
    _season = data.season

    if _ismastersim then
		--It rains less in the middle of summer
		local p = 1 - math.sin(PI * data.progress)
		_moisturerateval = MOISTURE_RATES.MIN[_season] + p * (MOISTURE_RATES.MAX[_season] - MOISTURE_RATES.MIN[_season])
		_moisturerateoffset = 0

        _moisturerate_island:set(CalculateMoistureRate_Island())
        _moistureceilmultiplier = MOISTURE_CEIL_MULTIPLIERS[_season] or MOISTURE_CEIL_MULTIPLIERS.autumn
        _moisturefloormultiplier = MOISTURE_FLOOR_MULTIPLIERS[_season] or MOISTURE_FLOOR_MULTIPLIERS.autumn
    end
end

local function OnPlayerActivated(src, player)
    _activatedplayer = player
    if _hasfx then
        _hailfx.entity:SetParent(player.entity)
		-- inst:OnUpdate(0)
		--TODO How to clear snowflakes if _isIAClimate?
		-- _snowfx.particles_per_tick = 0
		-- _snowfx:PostInit()
		-- _pollenfx.particles_per_tick = 0
		-- _pollenfx:PostInit()
    end
	-- player:DoTaskInTime(0,function() TryGetFX(player) end)
end

local function OnPlayerDeactivated(src, player)
    if _activatedplayer == player then
        _activatedplayer = nil
		if _hasfx then
			_hailfx.entity:SetParent(nil)
		end
    end
end

--These three are for lightning control in particular
local ChangeTable = _ismastersim and function(t1, t2, item)
	for i, v in ipairs(t1) do
		if v == item then
			table.remove(t1, i)
			--note: this makes item the last element in the ranking, so climate-hopping reduces your odds of getting struck by lightning
			table.insert(t2, item)
			return true
		end
	end
end

local OnClimateDirty = _ismastersim and function(player)
	if IsInIAClimate(player) then
		ChangeTable(_lightningtargets, _lightningtargets_island, player)
	else
		ChangeTable(_lightningtargets_island, _lightningtargets, player)
	end
end

local OnPlayerJoined = _ismastersim and function(src, player)
	if player then
		-- inst:DoTaskInTime(0, function()
			if IsInIAClimate(player) then
				--remove and add to our stalky update table or sth idk
				ChangeTable(_lightningtargets, _lightningtargets_island, player)
			end
		-- end)
		src:ListenForEvent("climatechange", OnClimateDirty, player)
	end
end or nil

local OnPlayerLeft = _ismastersim and function(src, player)
	if player then
		src:RemoveEventCallback("climatechange", OnClimateDirty, player)
	end
    for i, v in ipairs(_lightningtargets_island) do
        if v == player then
            table.remove(_lightningtargets_island, i)
            return
        end
    end
end or nil


local OnForcePrecipitation = _ismastersim and function(src, enable)
    _moisture_island:set(enable ~= false and _moistureceil_island:value() or _moisturefloor_island:value())
end or nil

local OnSetMoistureScale = _ismastersim and function(src, data)
    _moistureratemultiplier = data or _moistureratemultiplier
    _moisturerate_island:set(CalculateMoistureRate_Island())
end or nil

local OnDeltaMoisture = _ismastersim and function(src, delta)
    _moisture_island:set(math.min(math.max(_moisture_island:value() + delta, _moisturefloor_island:value()), _moistureceil_island:value()))
end or nil

local OnDeltaMoistureCeil = _ismastersim and function(src, delta)
    _moistureceil_island:set(math.max(_moistureceil_island:value() + delta, _moisturefloor_island:value()))
end or nil

local OnDeltaWetness = _ismastersim and function(src, delta)
    _wetness_island:set(math.clamp(_wetness_island:value() + delta, MIN_WETNESS, MAX_WETNESS))
end or nil

local OnSetLightningDelay = _ismastersim and function(src, data)
    if _precipisland:value() and data.min and data.max then
        _nextlightningtime_island = GetRandomMinMax(data.min, data.max)
    end
    _minlightningdelay_island = data.min
    _maxlightningdelay_island = data.max
end or nil

local ForceResync = _ismastersim and function(netvar)
    netvar:set_local(netvar:value())
    netvar:set(netvar:value())
end or nil
local OnSimUnpaused = _ismastersim and function()
    --Force resync values that client may have simulated locally
    ForceResync(_moisture_island)
    ForceResync(_wetness_island)
end or nil

local OnForceHurricane = _ismastersim and function(src, enable)
    if enable ~= _hurricane:value() then
		if enable then
			StartHurricaneStorm(type(enable) == "number" and enable or nil)
		else
			StopHurricaneStorm()
		end
	end
end or nil

local OnSetGustAngle = _ismastersim and function(src, angle)
	angle = angle % 360
    if angle ~= _hurricane_gust_angle:value() then
		_hurricane_gust_angle:set(angle)
	end
end or nil

--------------------------------------------------------------------------
--[[ Initialization ]]
--------------------------------------------------------------------------

--Initialize network variables
_moisture_island:set(0)
_moisturerate_island:set(0)
_moistureceil_island:set(0)
_moisturefloor_island:set(0)
_precipisland:set(false)
_peakprecipitationrate_island:set(1)
_wetness_island:set(0)
_wet_island:set(false)

--Dedicated server does not need to spawn the local fx
if _hasfx then
    _hailfx.particles_per_tick = 0
    _hailfx.splashes_per_tick = 0
end

--Register events
inst.inst:ListenForEvent("seasontick", OnSeasonTick_Island, _world)
inst.inst:ListenForEvent("playeractivated", OnPlayerActivated, _world)
inst.inst:ListenForEvent("playerdeactivated", OnPlayerDeactivated, _world)

--Register network variable sync events (worldstate)
inst.inst:ListenForEvent("moistureceil_islanddirty", function() _world:PushEvent("moistureceil_islandchanged", _moistureceil_island:value()) end)
inst.inst:ListenForEvent("precipislanddirty", function() _world:PushEvent("precipitation_islandchanged", _precipisland:value()) end)
inst.inst:ListenForEvent("wet_islanddirty", function() _world:PushEvent("wet_islandchanged", _wet_island:value()) end)
inst.inst:ListenForEvent("hurricanedirty", function() _world:PushEvent("hurricanechanged", _hurricane:value()) end)
inst.inst:ListenForEvent("hurricane_gust_speeddirty", function() _world:PushEvent("gustspeedchanged", _hurricane_gust_speed:value()) end)
inst.inst:ListenForEvent("hurricane_gust_angledirty", function() _world:PushEvent("gustanglechanged", _hurricane_gust_angle:value()) end)

if _ismastersim then
    --Initialize master simulation variables
    _moisturerate_island:set(CalculateMoistureRate_Island())
    _moistureceil_island:set(RandomizeMoistureCeil_Island())

    --Register master simulation events
    inst.inst:ListenForEvent("ms_playerjoined", OnPlayerJoined, _world)
    inst.inst:ListenForEvent("ms_playerleft", OnPlayerLeft, _world)
    inst.inst:ListenForEvent("ms_forceprecipitation", OnForcePrecipitation, _world)
    inst.inst:ListenForEvent("ms_forceprecipitation_island", OnForcePrecipitation, _world)
    inst.inst:ListenForEvent("ms_setmoisturescale", OnSetMoistureScale, _world)
    inst.inst:ListenForEvent("ms_deltamoisture", OnDeltaMoisture, _world)
    inst.inst:ListenForEvent("ms_deltamoisture_island", OnDeltaMoisture, _world)
    inst.inst:ListenForEvent("ms_deltamoistureceil", OnDeltaMoistureCeil, _world)
    inst.inst:ListenForEvent("ms_deltawetness", OnDeltaWetness, _world)
    inst.inst:ListenForEvent("ms_setlightningdelay", OnSetLightningDelay, _world)
    inst.inst:ListenForEvent("ms_simunpaused", OnSimUnpaused, _world)
    inst.inst:ListenForEvent("ms_forcehurricane", OnForceHurricane, _world)
    inst.inst:ListenForEvent("ms_setgustangle", OnSetGustAngle, _world)
end

local OnRemoveEntity_old = inst.OnRemoveEntity
if _hasfx then function inst:OnRemoveEntity(...)
    if _hailfx.entity:IsValid() then
        _hailfx:Remove()
    end
    OnRemoveEntity_old(inst, ...)
end end


--[[
    Client updates temperature, moisture, precipitation effects, and snow
    level on its own while server force syncs values periodically. Client
    cannot start, stop, or change precipitation on its own, and must wait
    for server syncs to trigger these events.
--]]
local OnUpdate_old = inst.OnUpdate
function inst:OnUpdate(dt)
	_isIAClimate = _activatedplayer and IsInIAClimate(_activatedplayer)
	
	if _ismastersim
	and (_world:HasTag("island") or _world:HasTag("volcano"))
	and not _world:HasTag("forest") and not _world:HasTag("caves") then
		SetWithPeriodicSync(_snowlevel, 0, SNOW_LEVEL_SYNC_PERIOD, _ismastersim)
	end
	if _ismastersim or not _isIAClimate then
		OnUpdate_old(self, dt)
	else
		SetWithPeriodicSync(_noisetime, _noisetime:value() + dt, 30, _ismastersim)
	end
	
	if _ismastersim or _isIAClimate then
		local preciprate = CalculatePrecipitationRate_Island()
		
		if _hurricane:value() then
			SetWithPeriodicSync(_hurricane_timer, _hurricane_timer:value() + dt, 100, _ismastersim)
			if _hurricane_duration:value() <= _hurricane_timer:value() then
				StopHurricaneStorm()
			else
				UpdateHurricaneWind(dt)
			end
		end
		
		--Update moisture and toggle precipitation
		if _precipmode:value() == PRECIP_MODES.always then
			if _ismastersim and not _precipisland:value() then
				StartPrecipitation_Island()
			end
		elseif _precipmode:value() == PRECIP_MODES.never then
			if _ismastersim and _precipisland:value() then
				StopPrecipitation_Island()
			end
		elseif _precipisland:value() then
			--Dissipate moisture
			local delta = preciprate * dt * PRECIP_RATE_SCALE
			-- if _hurricane:value() then
				-- delta = delta * TUNING.HURRICANE_DISSIPATION_SCALE
			-- end
			local moisture = math.max(_moisture_island:value() - delta, 0)
			if moisture <= _moisturefloor_island:value() then
				if _ismastersim then
					StopPrecipitation_Island()
				else
					_moisture_island:set_local(math.min(_moisturefloor_island:value() + .001, _moisture_island:value()))
				end
			else
				if _ismastersim and _hurricane:value()
				and moisture <= (_moisturefloor_island:value() + TUNING.HURRICANE_GUST_END_MOISTURE) then
					StopHurricaneStorm() --TODO parallel to _hurricane_timer, can be removed once we better sync precip and hurricane times
				end
				SetWithPeriodicSync(_moisture_island, moisture, 100, _ismastersim)
			end
		elseif _moistureceil_island:value() > 0 then
			--Accumulate moisture
			local moisture = _moisture_island:value() + _moisturerate_island:value() * dt
			if moisture >= _moistureceil_island:value() then
				if _ismastersim then
					StartPrecipitation_Island()
				else
					_moisture_island:set_local(math.max(_moistureceil_island:value() - .001, _moisture_island:value()))
				end
			else
				if _ismastersim and not _hurricane:value() and _season == "winter"
				and moisture >= (_moistureceil_island:value() - TUNING.HURRICANE_GUST_START_MOISTURE) then
					StartHurricaneStorm()
				end
				SetWithPeriodicSync(_moisture_island, moisture, 100, _ismastersim)
			end
		end

		--Update wetness
		local wetrate = CalculateWetnessRate_Island(_world.state.islandtemperature, preciprate)
		SetWithPeriodicSync(_wetness_island, math.clamp(_wetness_island:value() + wetrate * dt, MIN_WETNESS, MAX_WETNESS), WETNESS_SYNC_PERIOD, _ismastersim)
		if _ismastersim then
			if _wet_island:value() then
				if _wetness_island:value() < DRY_THRESHOLD then
					_wet_island:set(false)
				end
			elseif _wetness_island:value() > WET_THRESHOLD then
				_wet_island:set(true)
			end
		end
		
		if _ismastersim then
            if _lightningmode == LIGHTNING_MODES.always or
                LIGHTNING_MODE_NAMES[_lightningmode] == PRECIP_TYPE_NAMES[_precipisland:value() and 2 or 1] or
				-- (LIGHTNING_MODE_NAMES.hurricane == _lightningmode and _hurricane
					-- and MIN_LIGHTNING_HURRICANE < _hurricane_percent and MAX_LIGHTNING_HURRICANE > _hurricane_percent) or
                (_lightningmode == LIGHTNING_MODES.any and _precipisland:value()) then
                if _nextlightningtime_island > dt then
                    _nextlightningtime_island = _nextlightningtime_island - dt
                else
					-- local lightning_preciprate = _hurricane:value() and math.max(.2, preciprate / TUNING.HURRICANE_RAIN_SCALE) or preciprate
					local lightning_preciprate = preciprate
                    local min = _minlightningdelay_island or easing.linear(lightning_preciprate, _hurricane:value() and 4 or 30, _hurricane:value() and -2 or 10, 1)
                    local max = _maxlightningdelay_island or (min + easing.linear(lightning_preciprate, _hurricane:value() and 8 or 30, _hurricane:value() and -4 or 10, 1))
					_nextlightningtime_island = GetRandomMinMax(min, max)
                    if (lightning_preciprate > .75 or _lightningmode == LIGHTNING_MODES.always) and next(_lightningtargets_island) ~= nil
					and (not _hurricane:value() or math.random() < TUNING.HURRICANE_LIGHTNING_STRIKE_CHANCE) then
                        local targeti = math.min(math.floor(easing.inQuint(math.random(), 1, #_lightningtargets_island, 1)), #_lightningtargets_island)
                        local target = _lightningtargets_island[targeti]
                        table.remove(_lightningtargets_island, targeti)
                        table.insert(_lightningtargets_island, target)

                        local x, y, z = target.Transform:GetWorldPosition()
                        local radius = 2 + math.random() * 8
                        local theta = math.random() * 2 * PI
                        local pos = Vector3(x + radius * math.cos(theta), y, z + radius * math.sin(theta))
                        _world:PushEvent("ms_sendlightningstrike", pos)
                    else
                        SpawnPrefab(lightning_preciprate > .5 and "thunder_close" or "thunder_far")._islandthunder:set(true)
                    end
                end
            end
		end
		
		if _isIAClimate then
			
			--Update precipitation effects
			if _precipisland:value() then
				local preciprate_sound = preciprate
				if _activatedplayer == nil then
					StartTreeRainSound(0)
					StopUmbrellaRainSound_old()
				elseif _activatedplayer.replica.sheltered ~= nil and _activatedplayer.replica.sheltered:IsSheltered() then
					StartTreeRainSound(preciprate_sound)
					StopUmbrellaRainSound_old()
					preciprate_sound = preciprate_sound - .4
				else
					StartTreeRainSound(0)
					if _activatedplayer.replica.inventory:EquipHasTag("umbrella") then
						preciprate_sound = preciprate_sound - .4
						StartUmbrellaRainSound()
					else
						StopUmbrellaRainSound_old()
					end
				end
				StartAmbientRainSound(preciprate_sound)
				if _hurricane:value() then --TODO and not volcano
					StartAmbientHailSound(preciprate_sound)
				end
				if _hasfx then
					_rainfx.particles_per_tick = 5 * preciprate
					_rainfx.splashes_per_tick = 2 * preciprate
					if _hurricane:value() then --TODO and not volcano
						_hailfx.particles_per_tick = 5 * preciprate
						_hailfx.splashes_per_tick = 4 * preciprate
					else
						_hailfx.particles_per_tick = 0
						_hailfx.splashes_per_tick = 0
					end
				end
			else
				StopAmbientHailSound()
				StopAmbientRainSound_old()
				StopTreeRainSound_old()
				StopUmbrellaRainSound_old()
				if _hasfx then
					_rainfx.particles_per_tick = 0
					_rainfx.splashes_per_tick = 0
					_hailfx.particles_per_tick = 0
					_hailfx.splashes_per_tick = 0
				end
			end
			
			if _hurricane_gust_speed:value() > 0 then
				StartAmbientWindSound(_hurricane_gust_speed:value())
			else
				StopAmbientWindSound()
			end
			
			--Update pollen
			if _hasfx then
				_pollenfx.particles_per_tick = 0
				_snowfx.particles_per_tick = 0
			end
		end
		
		PushWeather_Island()
	end
	
	if not _isIAClimate and _hasfx then
		--no hail outside the islands climate
		_hailfx.particles_per_tick = 0
		_hailfx.splashes_per_tick = 0
		StopAmbientHailSound()
		StopAmbientWindSound()
	end
	
end

inst.LongUpdate = inst.OnUpdate

local OnSave_old = inst.OnSave
if OnSave_old then function inst:OnSave()
	local t = OnSave_old(self)
	t.moisturerateval_island = _moisturerateval
	t.moisturerateoffset_island = _moisturerateoffset
	t.moistureratemultiplier_island = _moistureratemultiplier
	t.moisturerate_island = _moisturerate_island:value()
	t.moisture_island = _moisture_island:value()
	t.moisturefloor_island = _moisturefloor_island:value()
	t.moistureceilmultiplier_island = _moistureceilmultiplier
	t.moisturefloormultiplier_island = _moisturefloormultiplier
	t.moistureceil_island = _moistureceil_island:value()
	t.precipisland = _precipisland:value() or nil
	t.peakprecipitationrate_island = _peakprecipitationrate_island:value()
	t.minlightningdelay_island = _minlightningdelay_island
	t.maxlightningdelay_island = _maxlightningdelay_island
	t.nextlightningtime_island = _nextlightningtime_island
	t.wetness_island = _wetness_island:value()
	t.wet_island = _wet_island:value() or nil
	t.hurricane_timer= _hurricane and _hurricane:value() and _hurricane_timer:value() or nil
	t.hurricane_duration = _hurricane and _hurricane:value() and _hurricane_duration:value() or nil
	t.hurricane_gust_angle = _hurricane_gust_angle:value() or nil
    return t
end end

local OnLoad_old = inst.OnLoad
if OnLoad_old then function inst:OnLoad(data)
	OnLoad_old(self, data)
    _season = data.season or "autumn"
    _moisturerateval = data.moisturerateval_island or 1
    _moisturerateoffset = data.moisturerateoffset_island or 0
    _moistureratemultiplier = data.moistureratemultiplier_island or 1
    _moisturerate_island:set(data.moisturerate_island or CalculateMoistureRate_Island())
    _moisture_island:set(data.moisture_island or 0)
    _moisturefloor_island:set(data.moisturefloor_island or 0)
    _moistureceilmultiplier = data.moistureceilmultiplier_island or 1
    _moisturefloormultiplier = data.moisturefloormultiplier_island or 1
    _moistureceil_island:set(data.moistureceil_island or RandomizeMoistureCeil_Island())
    _precipisland:set(data.precipisland == true)
    _peakprecipitationrate_island:set(data.peakprecipitationrate_island or 1)
    _minlightningdelay_island = data.minlightningdelay_island
    _maxlightningdelay_island = data.maxlightningdelay_island
    _nextlightningtime_island = data.nextlightningtime_island or 5
    _wetness_island:set(data.wetness_island or 0)
    _wet_island:set(data.wet_island == true)
	_hurricane_gust_angle:set(data.hurricane_gust_angle or math.random(0, 360))
	if data.hurricane_duration and data.hurricane_timer then
		StartHurricaneStorm(data.hurricane_duration)
		_hurricane_timer:set(data.hurricane_timer or 0)
	end
	
	PushWeather_Island()
end end


function inst:GetIADebugString()
    local preciprate = CalculatePrecipitationRate_Island()
    local wetrate = CalculateWetnessRate_Island(_world.state.islandtemperature, preciprate)
    local str =
    {
        string.format("moisture:%2.2f(%2.2f/%2.2f) + %2.2f", _moisture_island:value(), _moisturefloor_island:value(), _moistureceil_island:value(), _moisturerate_island:value()),
        string.format("preciprate:(%2.2f of %2.2f)", preciprate, _peakprecipitationrate_island:value()),
        string.format("wetness:%2.2f(%s%2.2f)%s", _wetness_island:value(), wetrate > 0 and "+" or "", wetrate, _wet_island:value() and " WET" or ""),
        string.format("lightning:%2.2f (%s)", _nextlightningtime_island, LIGHTNING_MODE_NAMES[_lightningmode]),
        string.format("hurricane:%2.2f/%2.2f(%s)", _hurricane_timer:value(), _hurricane_duration:value(), GUST_PHASE_NAMES[_hurricane_gust_state:value()] or "unknown gust phase"),
    }
	
    return table.concat(str, ", ")
end


end)
