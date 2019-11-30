local assets=
{
  Asset("ANIM", "anim/obsidian.zip"),
}

local function hitwater(inst)
	inst.SoundEmitter:PlaySound("ia/common/obsidian_wetsizzles")
end

local function fn()
  local inst = CreateEntity()
  inst.entity:AddTransform()
  inst.entity:AddAnimState()
  inst.entity:AddSoundEmitter()
  inst.entity:AddNetwork()

  MakeInventoryPhysics(inst)


  inst.AnimState:SetRayTestOnBB(true);
  inst.AnimState:SetBank("obsidian")
  inst.AnimState:SetBuild("obsidian")
  inst.AnimState:PlayAnimation("idle")

  inst:AddTag("molebait")
  
	MakeInventoryFloatable(inst)
	inst.components.floater:UpdateAnimations("idle_water", "idle")

  inst.entity:SetPristine()

  if not TheWorld.ismastersim then
    return inst
  end

  MakeBlowInHurricane(inst, TUNING.WINDBLOWN_SCALE_MIN.HEAVY, TUNING.WINDBLOWN_SCALE_MAX.HEAVY)

	inst:ListenForEvent("floater_startfloating", hitwater)

  inst:AddComponent("stackable")
  inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

  inst:AddComponent("inspectable")

  inst:AddComponent("waterproofer")
  inst.components.waterproofer:SetEffectiveness(0)
  inst.no_wet_prefix = true

  MakeInvItemIA(inst)

  inst:AddComponent("appeasement")
  inst.components.appeasement.appeasementvalue = TUNING.WRATH_LARGE

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.ELEMENTAL
    inst.components.edible.hungervalue = 3
    inst:AddComponent("tradable")
    inst:AddComponent("bait")

  MakeHauntableLaunch(inst)

  return inst
end

return Prefab( "obsidian", fn, assets)
