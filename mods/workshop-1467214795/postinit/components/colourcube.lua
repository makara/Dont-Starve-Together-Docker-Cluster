local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

IAENV.AddComponentPostInit("colourcube", function(cmp)


local OnOverrideCCPhaseFn
-- local OnPlayerActivated_old
for i, v in ipairs(cmp.inst.event_listening["playeractivated"][TheWorld]) do
	OnOverrideCCPhaseFn = UpvalueHacker.GetUpvalue(v, "OnOverrideCCPhaseFn")
	if OnOverrideCCPhaseFn then
		-- OnPlayerActivated_old = v
		break
	end
end
if not OnOverrideCCPhaseFn then return end

local OnPlayerActivated_old = UpvalueHacker.GetUpvalue(OnOverrideCCPhaseFn, "OnPlayerActivated")
local UpdateAmbientCCTable_old = UpvalueHacker.GetUpvalue(OnOverrideCCPhaseFn, "UpdateAmbientCCTable")
-- local Blend_old = UpvalueHacker.GetUpvalue(UpdateAmbientCCTable_old, "Blend")
local SEASON_COLOURCUBES_old = UpvalueHacker.GetUpvalue(UpdateAmbientCCTable_old, "SEASON_COLOURCUBES")

local SEASON_COLOURCUBES_IA = {
	autumn = {	
		day = resolvefilepath("images/colour_cubes/sw_mild_day_cc.tex"),
		dusk = resolvefilepath("images/colour_cubes/SW_mild_dusk_cc.tex"),
		night = resolvefilepath("images/colour_cubes/SW_mild_dusk_cc.tex"),
		full_moon = resolvefilepath("images/colour_cubes/purple_moon_cc.tex"),
	},
	winter = {
		day = resolvefilepath("images/colour_cubes/SW_wet_day_cc.tex"),
		dusk = resolvefilepath("images/colour_cubes/SW_wet_dusk_cc.tex"),
		night = resolvefilepath("images/colour_cubes/SW_wet_dusk_cc.tex"),
		full_moon = resolvefilepath("images/colour_cubes/purple_moon_cc.tex"),
	},
	spring = {
		day = resolvefilepath("images/colour_cubes/sw_green_day_cc.tex"),
		dusk = resolvefilepath("images/colour_cubes/sw_green_dusk_cc.tex"),
		night = resolvefilepath("images/colour_cubes/sw_green_dusk_cc.tex"),
		full_moon = resolvefilepath("images/colour_cubes/purple_moon_cc.tex"),
	},
	summer = {
		day = resolvefilepath("images/colour_cubes/SW_dry_day_cc.tex"),
		dusk = resolvefilepath("images/colour_cubes/SW_dry_dusk_cc.tex"),
		night = resolvefilepath("images/colour_cubes/SW_dry_dusk_cc.tex"),
		full_moon = resolvefilepath("images/colour_cubes/purple_moon_cc.tex"),
	},
}

local _activatedplayer
local _showsIAcc = false
local function UpdateAmbientCCTable(blendtime)
	
	local climate = GetClimate(_activatedplayer) --Shouldn't this be IsInIAClimate? -Z
    if climate == CLIMATE_IDS.island then
		if not _showsIAcc then
			_showsIAcc = true
			UpvalueHacker.SetUpvalue(UpdateAmbientCCTable_old, SEASON_COLOURCUBES_IA, "SEASON_COLOURCUBES")
		end
	elseif climate == CLIMATE_IDS.forest and _showsIAcc then
		_showsIAcc = false
		UpvalueHacker.SetUpvalue(UpdateAmbientCCTable_old, SEASON_COLOURCUBES_old, "SEASON_COLOURCUBES")
	end
	
	return UpdateAmbientCCTable_old(blendtime)
end

UpvalueHacker.SetUpvalue(OnOverrideCCPhaseFn, UpdateAmbientCCTable, "UpdateAmbientCCTable")

local function onClimateDirty()
	UpdateAmbientCCTable(10)
end
cmp.inst:ListenForEvent("playeractivated", function(src, player)
	if player and _activatedplayer ~= player then
		player:ListenForEvent("climatechange", onClimateDirty)
		player:DoTaskInTime(0, function() UpdateAmbientCCTable(.01) end) --initialise
	end
	_activatedplayer = player
end)
cmp.inst:ListenForEvent("playerdeactivated", function(src, player)
	if player then
		player:RemoveEventCallback("climatechange", onClimateDirty)
		if _activatedplayer == player then
			_activatedplayer = nil
		end
	end
end)


end)
