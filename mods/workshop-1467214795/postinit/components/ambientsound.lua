local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

IAENV.AddComponentPostInit("ambientsound", function(cmp)


local AMBIENT_SOUNDS = UpvalueHacker.GetUpvalue(cmp.OnUpdate, "AMBIENT_SOUNDS")
local SEASON_SOUND_KEY = UpvalueHacker.GetUpvalue(cmp.OnUpdate, "SEASON_SOUND_KEY")

AMBIENT_SOUNDS[ GROUND.JUNGLE ] = {
	sound = "ia/amb/mild/jungleAMB", 
	wintersound = "ia/amb/wet/jungleAMB", 
	springsound = "ia/amb/green/jungleAMB", 
	summersound = "ia/amb/dry/jungleAMB", 
	rainsound = "ia/amb/rain/jungleAMB", 
	hurricanesound = "ia/amb/hurricane/jungleAMB",
}
AMBIENT_SOUNDS[ GROUND.BEACH ] = {
	sound = "ia/amb/mild/beachAMB", 
	wintersound = "ia/amb/wet/beachAMB", 
	springsound = "ia/amb/green/beachAMB", 
	summersound = "ia/amb/dry/beachAMB", 
	rainsound = "ia/amb/rain/beachAMB", 
	hurricanesound = "ia/amb/hurricane/beachAMB",
}
-- AMBIENT_SOUNDS[ GROUND.SWAMP ] = {
	-- sound = "ia/amb/mild/marshAMB", 
	-- wintersound = "ia/amb/wet/marshAMB", 
	-- springsound = "ia/amb/green/marshAMB", 
	-- summersound = "ia/amb/dry/marshAMB", 
	-- rainsound = "ia/amb/rain/marshAMB", 
	-- hurricanesound = "ia/amb/hurricane/marshAMB",
-- }
AMBIENT_SOUNDS[ GROUND.MAGMAFIELD ] = {
	sound = "ia/amb/mild/rockyAMB", 
	wintersound = "ia/amb/wet/rockyAMB", 
	springsound = "ia/amb/green/rockyAMB", 
	summersound = "ia/amb/dry/rockyAMB", 
	rainsound = "ia/amb/rain/rockyAMB", 
	hurricanesound = "ia/amb/hurricane/rockyAMB",
}
AMBIENT_SOUNDS[ GROUND.TIDALMARSH ] = {
	sound = "ia/amb/mild/marshAMB", 
	wintersound = "ia/amb/wet/marshAMB", 
	springsound = "ia/amb/green/marshAMB", 
	summersound = "ia/amb/dry/marshAMB", 
	rainsound = "ia/amb/rain/marshAMB", 
	hurricanesound = "ia/amb/hurricane/marshAMB",
}
AMBIENT_SOUNDS[ GROUND.MEADOW ] = {
	sound = "ia/amb/mild/grasslandAMB", 
	wintersound = "ia/amb/wet/grasslandAMB", 
	springsound = "ia/amb/green/grasslandAMB", 
	summersound = "ia/amb/dry/grasslandAMB", 
	rainsound = "ia/amb/rain/grasslandAMB", 
	hurricanesound = "ia/amb/hurricane/grasslandAMB",
}
AMBIENT_SOUNDS[ GROUND.OCEAN_SHALLOW ] = {
	sound = "ia/amb/mild/ocean_shallow", 
	wintersound = "ia/amb/wet/ocean_shallowAMB", 
	springsound = "ia/amb/green/ocean_shallowAMB", 
	summersound = "ia/amb/dry/ocean_shallow", 
	rainsound = "ia/amb/rain/ocean_shallowAMB", 
	hurricanesound = "ia/amb/hurricane/ocean_shallowAMB",
}
AMBIENT_SOUNDS[ GROUND.OCEAN_MEDIUM ] = {
	sound = "ia/amb/mild/ocean_shallow", 
	wintersound = "ia/amb/wet/ocean_shallowAMB", 
	springsound = "ia/amb/green/ocean_shallowAMB", 
	summersound = "ia/amb/dry/ocean_shallow", 
	rainsound = "ia/amb/rain/ocean_shallowAMB", 
	hurricanesound = "ia/amb/hurricane/ocean_shallowAMB",
}
AMBIENT_SOUNDS[ GROUND.OCEAN_DEEP ] = {
	sound = "ia/amb/mild/ocean_deep", 
	wintersound = "ia/amb/wet/ocean_deepAMB", 
	springsound = "ia/amb/green/ocean_deepAMB", 
	summersound = "ia/amb/dry/ocean_deep", 
	rainsound = "ia/amb/rain/ocean_deepAMB", 
	hurricanesound = "ia/amb/hurricane/ocean_deepAMB",
}
AMBIENT_SOUNDS[ GROUND.OCEAN_SHIPGRAVEYARD ] = {
	sound = "ia/amb/mild/ocean_deep", 
	wintersound = "ia/amb/wet/ocean_deepAMB", 
	springsound = "ia/amb/green/ocean_deepAMB", 
	summersound = "ia/amb/dry/ocean_deep", 
	rainsound = "ia/amb/rain/ocean_deepAMB", 
	hurricanesound = "ia/amb/hurricane/ocean_deepAMB",
}
-- AMBIENT_SOUNDS[ GROUND.OCEAN_SHORE ] = {
	-- sound = "ia/amb/mild/waves", 
	-- wintersound = "ia/amb/wet/waves", 
	-- springsound = "ia/amb/green/waves", 
	-- summersound = "ia/amb/dry/waves", 
	-- rainsound = "ia/amb/rain/waves", 
	-- hurricanesound = "ia/amb/hurricane/waves",
-- }
AMBIENT_SOUNDS[ GROUND.OCEAN_CORAL ] = {
	sound = "ia/amb/mild/coral_reef", 
	wintersound = "ia/amb/wet/coral_reef", 
	springsound = "ia/amb/green/coral_reef", 
	summersound = "ia/amb/dry/coral_reef", 
	rainsound = "ia/amb/rain/coral_reef", 
	hurricanesound = "ia/amb/hurricane/coral_reef",
}
AMBIENT_SOUNDS[ GROUND.MANGROVE ] = {
	sound = "ia/amb/mild/mangrove", 
	wintersound = "ia/amb/wet/mangrove", 
	springsound = "ia/amb/green/mangrove", 
	summersound = "ia/amb/dry/mangrove", 
	rainsound = "ia/amb/rain/mangrove", 
	hurricanesound = "ia/amb/hurricane/mangrove",
}
AMBIENT_SOUNDS[ GROUND.RIVER ] = {
	sound = "ia/amb/mild/waves", 
	wintersound = "ia/amb/wet/waves", 
	springsound = "ia/amb/green/waves", 
	summersound = "ia/amb/dry/waves", 
	rainsound = "ia/amb/rain/waves", 
	hurricanesound = "ia/amb/hurricane/waves",
}
AMBIENT_SOUNDS[ GROUND.VOLCANO ] = {
	sound = "ia/amb/volcano/ground_ash", 
	dormantsound = "ia/amb/volcano/dormant", 
	activesound = "ia/amb/volcano/active",
}
AMBIENT_SOUNDS[ GROUND.VOLCANO_ROCK ] = {
	sound = "ia/amb/volcano/ground_ash", 
	dormantsound = "ia/amb/volcano/dormant", 
	activesound = "ia/amb/volcano/active",
}
-- AMBIENT_SOUNDS[ GROUND.VOLCANO_LAVA ] = { --TODO re-enable
	-- sound = "ia/amb/volcano/lava",
-- }
AMBIENT_SOUNDS[ GROUND.ASH ] = {
	sound = "ia/amb/volcano/ground_ash", 
	dormantsound = "ia/amb/volcano/dormant", 
	activesound = "ia/amb/volcano/active",
}

SEASON_SOUND_KEY["mild"] = "sound"
SEASON_SOUND_KEY["wet"] = "wintersound"
SEASON_SOUND_KEY["green"] = "springsound"
SEASON_SOUND_KEY["dry"] = "summersound"


end)
