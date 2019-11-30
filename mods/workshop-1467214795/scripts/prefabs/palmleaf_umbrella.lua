local assets=
{
  Asset("ANIM", "anim/swap_parasol_palmleaf.zip"),
  Asset("ANIM", "anim/parasol_palmleaf.zip"),
}

--in DST, this is handled by the world component "weather"
-- local function UpdateSound(inst)
  -- local equipper = inst.components.equippable:IsEquipped() and inst.components.inventoryitem:GetGrandOwner()
  -- local soundShouldPlay = TheWorld.state.israining and equipper and not equipper.sg:HasStateTag("rowing")
  -- if soundShouldPlay ~= inst.SoundEmitter:PlayingSound("umbrellarainsound") then
    -- if soundShouldPlay then
      -- inst.SoundEmitter:PlaySound("dontstarve/rain/rain_on_umbrella", "umbrellarainsound") 
    -- else
      -- inst.SoundEmitter:KillSound("umbrellarainsound")
    -- end
  -- end
-- end  

local function onfinished(inst)
  inst:Remove()
end

local function onperish(inst)
  if inst.components.inventoryitem and inst.components.inventoryitem:IsHeld() then
    local owner = inst.components.inventoryitem.owner
    inst:Remove()

    if owner then
      owner:PushEvent("umbrellaranout")
    end
  else
    inst:Remove()
  end
end    


local function common_fn(Sim)
  local inst = CreateEntity()
  local trans = inst.entity:AddTransform()
  inst.entity:AddAnimState()
  inst.entity:AddNetwork()
  inst.entity:AddSoundEmitter()

  MakeInventoryPhysics(inst)

  inst:AddTag("nopunch")
  inst:AddTag("umbrella")

  MakeSnowCoveredPristine(inst)
	MakeInventoryFloatable(inst)
	inst.components.floater:UpdateAnimations("idle_water", "idle")

    return inst
end

local function master_fn(inst)
  MakeBlowInHurricane(inst, TUNING.WINDBLOWN_SCALE_MIN.LIGHT, TUNING.WINDBLOWN_SCALE_MAX.LIGHT)

  inst:AddComponent("waterproofer")
  inst:AddComponent("inspectable")
  inst:AddComponent("equippable")

  inst:AddComponent("insulator")
  inst.components.insulator:SetSummer()

  -- inst:ListenForEvent("rainstop", function() UpdateSound(inst) end, TheWorld) 
  -- inst:ListenForEvent("rainstart", function() UpdateSound(inst) end, TheWorld) 

  -- inst:ListenForEvent("startrowing", function() UpdateSound(inst) end)
  -- inst:ListenForEvent("stoprowing", function() UpdateSound(inst) end)
end

local function onequip_palmleaf(inst, owner) 
  owner.AnimState:OverrideSymbol("swap_object", "swap_parasol_palmleaf", "swap_parasol_palmleaf")
  owner.AnimState:Show("ARM_carry")
  owner.AnimState:Hide("ARM_normal")
  -- UpdateSound(inst)

  owner.DynamicShadow:SetSize(1.7, 1)
end

local function onunequip_palmleaf(inst, owner) 
  owner.AnimState:Hide("ARM_carry") 
  owner.AnimState:Show("ARM_normal") 
  -- UpdateSound(inst)

  owner.DynamicShadow:SetSize(1.3, 0.6)
end

local function palmleaf()
  local inst = common_fn()

  inst.AnimState:SetBank("parasol_palmleaf")
  inst.AnimState:SetBuild("parasol_palmleaf")
  inst.AnimState:PlayAnimation("idle")

	inst.entity:SetPristine()

  if not TheWorld.ismastersim then
    return inst
  end

	master_fn(inst)

  MakeInvItemIA(inst)

  inst:AddComponent("perishable")
  inst.components.perishable:SetPerishTime(TUNING.GRASS_UMBRELLA_PERISHTIME)
  inst.components.perishable:StartPerishing()
  inst.components.perishable:SetOnPerishFn(onperish)
  inst:AddTag("show_spoilage")

  inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_MED)

  inst.components.equippable:SetOnEquip( onequip_palmleaf )
  inst.components.equippable:SetOnUnequip( onunequip_palmleaf )

  inst.components.insulator:SetInsulation(TUNING.INSULATION_MED)

  inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL

  inst:AddComponent("appeasement")
  inst.components.appeasement.appeasementvalue = TUNING.WRATH_SMALL

  MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
  MakeSmallPropagator(inst)

  return inst
end

return Prefab( "palmleaf_umbrella", palmleaf, assets)
