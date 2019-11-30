local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

IAENV.AddComponentPostInit("regrowthmanager", function(cmp)


local _worldstate = TheWorld.state

cmp:SetRegrowthForType("sweet_potato_planted", TUNING.CARROT_REGROWTH_TIME, "sweet_potato_planted", function()
    return not (_worldstate.isnight or _worldstate.iswinter or _worldstate.snowlevel > 0) and 1 or 0
end)


end)
