--------------------------------------------------------------------------
--[[ WorldIslandTemperature class definition (mostly copied from WorldTemperature) ]]
--------------------------------------------------------------------------

return Class(function(self, inst)

--------------------------------------------------------------------------
--[[ Constants ]]
--------------------------------------------------------------------------

local NOISE_SYNC_PERIOD = 30

--------------------------------------------------------------------------
--[[ Temperature constants ]]
--------------------------------------------------------------------------

local TEMPERATURE_NOISE_SCALE = .025
local TEMPERATURE_NOISE_MAG = 8

local MIN_TEMPERATURE = 35
local MAX_TEMPERATURE = 65
local WINTER_CROSSOVER_TEMPERATURE = 40
local SUMMER_CROSSOVER_TEMPERATURE = 50

local SUMMER_RAIN_TEMP = -10 --TODO implement this
local HURRICANE_TEMP = -10
local HURRICANE_WIND_TEMP = -10

local PHASE_TEMPERATURES =
{
    day = 10,
    night = -5,
}

--------------------------------------------------------------------------
--[[ Member variables ]]
--------------------------------------------------------------------------

--Public
self.inst = inst

--Private
local _world = TheWorld
local _map = _world.Map
local _ismastersim = _world.ismastersim

--Temperature
local _seasontemperature
local _phasetemperature
local _hurricanetemperature
local _globaltemperaturemult = 1
local _globaltemperaturelocus = 0

--Light
local _daylight = true
local _season = "autumn"

--Network
local _noisetime = net_float(inst.GUID, "worldislandtemperature._noisetime")

--------------------------------------------------------------------------
--[[ Private member functions ]]
--------------------------------------------------------------------------

local function SetWithPeriodicSync(netvar, val, period, ismastersim)
    if netvar:value() ~= val then
        local trunc = val > netvar:value() and "floor" or "ceil"
        local prevperiod = math[trunc](netvar:value() / period)
        local nextperiod = math[trunc](val / period)

        if prevperiod == nextperiod then
            --Client and server update independently within current period
            netvar:set_local(val)
        elseif ismastersim then
            --Server sync to client when period changes
            netvar:set(val)
        else
            --Client must wait at end of period for a server sync
            netvar:set_local(nextperiod * period)
        end
    elseif ismastersim then
        --Force sync when value stops changing
        netvar:set(val)
    end
end

local ForceResync = _ismastersim and function(netvar)
    netvar:set_local(netvar:value())
    netvar:set(netvar:value())
end or nil

local function CalculateSeasonTemperature(season, progress)
    return (season == "winter" and math.sin(PI * progress) * (MIN_TEMPERATURE - WINTER_CROSSOVER_TEMPERATURE) + WINTER_CROSSOVER_TEMPERATURE)
        or (season == "spring" and Lerp(WINTER_CROSSOVER_TEMPERATURE, SUMMER_CROSSOVER_TEMPERATURE, progress))
        or (season == "summer" and math.sin(PI * progress) * (MAX_TEMPERATURE - SUMMER_CROSSOVER_TEMPERATURE) + SUMMER_CROSSOVER_TEMPERATURE)
        or Lerp(SUMMER_CROSSOVER_TEMPERATURE, WINTER_CROSSOVER_TEMPERATURE, progress)
end

local function CalculatePhaseTemperature(phase, timeinphase)
    return PHASE_TEMPERATURES[phase] ~= nil and PHASE_TEMPERATURES[phase] * math.sin(timeinphase * PI) or 0
end

local function CalculateHurricaneTemperature(windspeed, progress)
    return HURRICANE_TEMP * math.sin(PI * progress) + HURRICANE_WIND_TEMP * windspeed
end

local function CalculateTemperature()
    local temperaturenoise = 2 * TEMPERATURE_NOISE_MAG * perlin(0, 0, _noisetime:value() * TEMPERATURE_NOISE_SCALE) - TEMPERATURE_NOISE_MAG
    return (((temperaturenoise + _seasontemperature + _phasetemperature + _hurricanetemperature) - _globaltemperaturelocus) * _globaltemperaturemult) + _globaltemperaturelocus
end

local function PushTemperature()
    local data = CalculateTemperature()
    _world:PushEvent("islandtemperaturetick", data)
end

--------------------------------------------------------------------------
--[[ Private event handlers ]]
--------------------------------------------------------------------------

local function OnSeasonTick(src, data)
    _seasontemperature = CalculateSeasonTemperature(data.season, data.progress)
    _season = data.season
    --_seasonprogress = data.progress
end

local function OnClockTick(src, data)
    _phasetemperature = CalculatePhaseTemperature(data.phase, data.timeinphase)
end

local function OnPhaseChanged(src, phase)
    _daylight = phase == "day"
end

local function OnHurricaneTick(src, data)
    _hurricanetemperature = CalculateHurricaneTemperature(data.windspeed, data.progress)
end

local OnSimUnpaused = _ismastersim and function()
    --Force resync values that client may have simulated locally
    ForceResync(_noisetime)
end or nil

--------------------------------------------------------------------------
--[[ Public member functions ]]
--------------------------------------------------------------------------

--This is only used by caves at time of writing, so we don't *need* to copy it from WorldTemperature -M
function self:SetTemperatureMod(multiplier, locus)
    _globaltemperaturemult = multiplier
    _globaltemperaturelocus = locus
    PushTemperature()
end

--------------------------------------------------------------------------
--[[ Initialization ]]
--------------------------------------------------------------------------

_seasontemperature = CalculateSeasonTemperature(_season, .5)
_phasetemperature = CalculatePhaseTemperature(_daylight and "day" or "dusk", 0)
_hurricanetemperature = CalculatePhaseTemperature(0, 0)

--Initialize network variables
_noisetime:set(0)

--Register events
inst:ListenForEvent("seasontick", OnSeasonTick, _world)
inst:ListenForEvent("clocktick", OnClockTick, _world)
inst:ListenForEvent("phasechanged", OnPhaseChanged, _world)
inst:ListenForEvent("hurricanetick", OnHurricaneTick, _world) --not yet sure how hurricane will actually work -M

if _ismastersim then
    --Register master simulation events
    inst:ListenForEvent("ms_simunpaused", OnSimUnpaused, _world)
end

PushTemperature()
inst:StartUpdatingComponent(self)

--------------------------------------------------------------------------
--[[ Update ]]
--------------------------------------------------------------------------

--[[
    Client updates temperature, moisture, precipitation effects, and snow
    level on its own while server force syncs values periodically. Client
    cannot start, stop, or change precipitation on its own, and must wait
    for server syncs to trigger these events.
--]]
function self:OnUpdate(dt)
    --Update noise
    SetWithPeriodicSync(_noisetime, _noisetime:value() + dt, NOISE_SYNC_PERIOD, _ismastersim)

    PushTemperature()
end

self.LongUpdate = self.OnUpdate

--------------------------------------------------------------------------
--[[ Save/Load ]]
--------------------------------------------------------------------------

if _ismastersim then function self:OnSave()
    return
    {
        daylight = _daylight or nil,
        season = _season,
        seasontemperature = _seasontemperature,
        phasetemperature = _phasetemperature,
        hurricanetemperature = _hurricanetemperature,
        noisetime = _noisetime:value(),
    }
end end

if _ismastersim then function self:OnLoad(data)
    _daylight = data.daylight == true
    _season = data.season or "autumn"
    _seasontemperature = data.seasontemperature or CalculateSeasonTemperature(_season, .5)
    _phasetemperature = data.phasetemperature or CalculatePhaseTemperature(_daylight and "day" or "dusk", 0)
    _hurricanetemperature = data.hurricanetemperature or CalculateHurricaneTemperatureTemperature(0, 0)
    _noisetime:set(data.noisetime or 0)

    PushTemperature()
end end

--------------------------------------------------------------------------
--[[ Debug ]]
--------------------------------------------------------------------------

function self:GetDebugString()
    local temperature = CalculateTemperature()
    return string.format("%2.2fC mult: %.2f locus %.1f", temperature, _globaltemperaturemult, _globaltemperaturelocus)
end

--------------------------------------------------------------------------
--[[ End ]]
--------------------------------------------------------------------------

end)
