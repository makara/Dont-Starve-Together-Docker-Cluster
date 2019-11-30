local assets =
{
  Asset("ANIM", "anim/seashell.zip"),
}

local function fn(Sim)
  local inst = CreateEntity()
  inst.entity:AddTransform()
  inst.entity:AddAnimState()
  inst.entity:AddNetwork()

  MakeInventoryPhysics(inst)

  inst.AnimState:SetBank("seashell")
  inst.AnimState:SetBuild("seashell")
  inst.AnimState:PlayAnimation("idle")

  inst:AddTag("molebait")

	MakeInventoryFloatable(inst)
	inst.components.floater:UpdateAnimations("idle_water", "idle")
	
  inst.entity:SetPristine()

  if not TheWorld.ismastersim then
    return inst
  end

  MakeBlowInHurricane(inst, TUNING.WINDBLOWN_SCALE_MIN.LIGHT, TUNING.WINDBLOWN_SCALE_MAX.LIGHT)

  inst:AddComponent("stackable")
  inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

  inst:AddComponent("tradable")

  inst:AddComponent("inspectable")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.ELEMENTAL
    inst.components.edible.healthvalue = 1
    inst:AddComponent("bait")
  
  MakeInvItemIA(inst)

  return inst
end

return Prefab( "seashell", fn, assets) 

