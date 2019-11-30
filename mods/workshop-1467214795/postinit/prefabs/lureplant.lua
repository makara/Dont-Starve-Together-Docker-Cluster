local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddPrefabPostInit("lureplant", function(inst)


if TheWorld.ismastersim then

	if inst.components.minionspawner.validtiletypes then
		inst.components.minionspawner.validtiletypes[GROUND.BEACH] = true
		inst.components.minionspawner.validtiletypes[GROUND.JUNGLE] = true
		inst.components.minionspawner.validtiletypes[GROUND.TIDALMARSH] = true
		inst.components.minionspawner.validtiletypes[GROUND.MEADOW] = true
	end	

end


end)
