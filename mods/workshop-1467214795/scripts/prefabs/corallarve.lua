local assets=
{
	Asset("ANIM", "anim/corallarve.zip"),
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("corallarve")
    inst.AnimState:SetBuild("corallarve")
    inst.AnimState:PlayAnimation("idle")

	MakeInventoryFloatable(inst)
	inst.components.floater:UpdateAnimations("idle_water", "idle")
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

    MakeBlowInHurricane(inst, TUNING.WINDBLOWN_SCALE_MIN.HEAVY, TUNING.WINDBLOWN_SCALE_MAX.HEAVY)
	
    inst:AddComponent("inspectable")
    
    MakeInvItemIA(inst)

    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM   

	inst:AddComponent("waterproofer")
    inst:AddComponent("bait")
    inst:AddTag("molebait")

	inst:AddComponent("repairer")
	inst.components.repairer.repairmaterial = "stone"
	inst.components.repairer.healthrepairvalue = TUNING.REPAIR_CUTSTONE_HEALTH

	return inst
end

return Prefab( "corallarve", fn, assets) 
