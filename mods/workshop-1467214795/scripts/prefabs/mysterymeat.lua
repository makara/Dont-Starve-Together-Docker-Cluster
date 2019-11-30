local assets=
{
  Asset("ANIM", "anim/mystery_meat.zip"),
}

local function impact(inst)
	inst.SoundEmitter:PlaySound("ia/common/mysterymeat_impactland")
end

local function fn(Sim)
  local inst = CreateEntity()
  inst.entity:AddTransform()
  inst.entity:AddAnimState()
  inst.entity:AddSoundEmitter()
  inst.entity:AddNetwork()

  MakeInventoryPhysics(inst)

  inst:AddTag("kittenchow")

  inst.AnimState:SetBank("mysterymeat")
  inst.AnimState:SetBuild("mystery_meat")
  inst.AnimState:PlayAnimation("idle")

	MakeInventoryFloatable(inst)
	inst.components.floater:UpdateAnimations("idle_water", "idle")

  inst.entity:SetPristine()

  if not TheWorld.ismastersim then
    return inst
  end

	inst:ListenForEvent("floater_startfloating", impact)

  inst:AddComponent("inspectable")

  MakeInvItemIA(inst)

  inst:AddComponent("appeasement")
  inst.components.appeasement.appeasementvalue = TUNING.WRATH_LARGE

  inst:AddComponent("edible")
  inst.components.edible.healthvalue = TUNING.SPOILED_HEALTH
  inst.components.edible.hungervalue = TUNING.SPOILED_HUNGER
  inst.components.edible.foodtype = "MEAT"

  inst:AddComponent("stackable")
  inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

  return inst
end

return Prefab( "mysterymeat", fn, assets)
