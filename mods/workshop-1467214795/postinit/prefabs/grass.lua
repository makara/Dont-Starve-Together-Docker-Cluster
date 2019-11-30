local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

local animdata = {
	bankgust = "grass_floating",
	bankidle = "grass",
}

IAENV.AddPrefabPostInit("grass", function(inst)


if TheWorld.ismastersim then

	MakePickableBlowInWindGust(inst, TUNING.GRASS_WINDBLOWN_SPEED, TUNING.GRASS_WINDBLOWN_FALL_CHANCE, animdata)
	
end


end)