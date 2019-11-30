local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

IAENV.AddPrefabPostInit("eel", function(inst)


inst:AddTag("fishmeat")
-- inst:AddTag("packimfood")

if TheWorld.ismastersim then

    if inst.components.tradable then
		inst.components.tradable.dubloonvalue = TUNING.DUBLOON_VALUES.SEAFOOD
	end
	
	inst:AddComponent("appeasement")
	inst.components.appeasement.appeasementvalue = TUNING.APPEASEMENT_TINY
	
end


end)
