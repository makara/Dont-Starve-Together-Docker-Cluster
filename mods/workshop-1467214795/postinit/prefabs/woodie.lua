local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local function startbeaver(inst, data)
	if inst.components.poisonable then
		inst.components.poisonable:SetBlockAll(true)
	end
	inst.components.health.cantdrown = true
end
local function stopbeaver(inst, data)
	if inst.components.poisonable and not inst:HasTag("playerghost") then
		inst.components.poisonable:SetBlockAll(false)
	end
	inst.components.health.cantdrown = false
end

local function deployitem(inst, data)
	if not inst:HasTag("playerghost")
	and data.prefab == "coconut" or data.prefab == "jungletreeseed" then
		--inst.components.beaverness:DoDelta(TUNING.WOODIE_PLANT_TREE_GAIN)
		inst.components.sanity:DoDelta(TUNING.SANITY_TINY)
	end
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddPrefabPostInit("woodie", function(inst)


if TheWorld.ismastersim then

	inst:ListenForEvent("startbeaver", startbeaver)
	inst:ListenForEvent("stopbeaver", stopbeaver)
	inst:ListenForEvent("deployitem", deployitem)
	
end


end)
