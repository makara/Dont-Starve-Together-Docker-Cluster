
local assets=
{
  Asset("ANIM", "anim/rainbowjellyfish.zip"),
  Asset("ANIM", "anim/meat_rack_food.zip"),
  Asset("INV_IMAGE", "rainbowJellyJerky"),
}


local prefabs=
{
  "rainbowjellyfish_planted",
}

local function playDeadAnimation(inst)
  inst.AnimState:PlayAnimation("death_ground", true)
  inst.AnimState:PushAnimation("idle_ground", true)
end

local function ondropped(inst)
  --Get tile under my position and set animation accordingly
  if IsOnWater(inst) then
    local replacement = SpawnPrefab("rainbowjellyfish_planted")
    replacement.Transform:SetPosition(inst.Transform:GetWorldPosition())

    inst:Remove()
  else
    local replacement = SpawnPrefab("rainbowjellyfish_dead")
    replacement.Transform:SetPosition(inst.Transform:GetWorldPosition())
    replacement.AnimState:PlayAnimation("stunned_loop", true)
    replacement:DoTaskInTime(2.5, playDeadAnimation)
    replacement:AddTag('stinger')
    inst:Remove()
  end
end

local function oneaten_light(inst, eater)
    if eater.rainbowjellylight and eater.rainbowjellylight:IsValid() then
        eater.rainbowjellylight.components.spell.lifetime = 0
        eater.rainbowjellylight.components.spell:ResumeSpell()
    else
        local light = SpawnPrefab("rainbowjellylight")

        light.components.spell:SetTarget(eater)
		if light:IsValid() then
			if not light.components.spell.target then
				light:Remove()
			else
				light.components.spell:StartSpell()
			end
		end
    end
end

local function commonfn(Sim)
  local inst = CreateEntity()
  inst.entity:AddTransform()
  inst.entity:AddNetwork()
  inst.Transform:SetScale(0.8, 0.8, 0.8)

  inst.entity:AddAnimState()
  MakeInventoryPhysics(inst)
  inst.entity:AddSoundEmitter()
  
  inst.AnimState:SetRayTestOnBB(true);
  inst.AnimState:SetBank("rainbowjellyfish")
  inst.AnimState:SetBuild("rainbowjellyfish")

  inst.AnimState:SetLayer( LAYER_BACKGROUND )
  inst.AnimState:SetSortOrder( 3 )

  inst._startspell = net_event(inst.GUID, "rainbowjellyfish._startspell")

  return inst
end

local function common_master(inst)
  inst:AddComponent("inspectable")
  inst:AddComponent("perishable")

  inst:AddComponent("tradable")
  inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
  inst.components.tradable.dubloonvalue = TUNING.DUBLOON_VALUES.SEAFOOD
end

local function defaultfn()

  local inst = commonfn()
  
  inst:AddTag("show_spoilage")
  inst:AddTag("jellyfish")
  inst:AddTag("fishmeat")
  inst:AddTag("cookable") --added to pristine state for optimization

  inst.entity:SetPristine()
  
  if not TheWorld.ismastersim then
    return inst
  end

  common_master(inst)
  
  MakeInvItemIA(inst)

  inst.components.perishable:SetPerishTime(TUNING.PERISH_ONE_DAY * 1.5)
  inst.components.perishable:StartPerishing()
  inst.components.perishable.onperishreplacement = "rainbowjellyfish_dead"

  inst.components.inventoryitem:SetOnDroppedFn(ondropped)
  inst.AnimState:PlayAnimation("idle_ground", true)

--  MakeInventoryFloatable(inst, "idle_water", "idle_ground")

  inst:AddComponent("cookable")
  inst.components.cookable.product = "rainbowjellyfish_cooked"

  inst:AddComponent("health")
  inst.components.health.murdersound = "ia/creatures/jellyfish/death_murder"

  inst:AddComponent("lootdropper")
  inst.components.lootdropper:SetLoot({"rainbowjellyfish_dead"})

  return inst

end

local function deadfn()
  local inst = commonfn()

  inst.Transform:SetScale(0.7, 0.7, 0.7)

	--TODO this looks very nonsensical, besides serving no clear purpose (never triggers) -M
	inst:ListenForEvent("rainbowjellyfish._startspell", function(inst)
		oneaten_light(nil, inst)
	end)

	MakeInventoryFloatable(inst)
	inst.components.floater:UpdateAnimations("idle_water", "idle_ground")

  inst.entity:SetPristine()
  
  if not TheWorld.ismastersim then
    return inst
  end

  common_master(inst)

  MakeInvItemIA(inst)

  inst:AddComponent("edible")
  inst.components.edible.foodtype = "MEAT"
  inst.components.edible:SetOnEatenFn(oneaten_light)

  inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
  inst.components.perishable:StartPerishing()
  inst.components.perishable.onperishreplacement = "spoiled_food"

  inst.AnimState:PlayAnimation("idle_ground", true)

  inst:AddComponent("cookable")
  inst.components.cookable.product = "rainbowjellyfish_cooked"

  inst:AddComponent("dryable")
  inst.components.dryable:SetProduct("jellyjerky")
  inst.components.dryable:SetDryTime(TUNING.DRY_FAST)

  inst:AddComponent("stackable")
  inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

  return inst
end


local function cookedfn()
  local inst = commonfn()

  inst.entity:SetPristine()
  
  if not TheWorld.ismastersim then
    return inst
  end

  common_master(inst)

  MakeInvItemIA(inst)

  inst:AddComponent("edible")
  inst.components.edible.foodtype = "MEAT"
  inst.components.edible.foodstate = "COOKED"
  inst.components.edible.hungervalue = TUNING.CALORIES_MEDSMALL
  inst.components.edible.sanityvalue = 0

  inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
  inst.components.perishable:StartPerishing()
  inst.components.perishable.onperishreplacement = "spoiled_food"

  inst.AnimState:PlayAnimation("cooked", true)
  inst:AddComponent("stackable")
  inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
  return inst
end

--this should not really exist, its just a copy of normal jellyjerky
local function driedfn()
  local inst = commonfn()

  inst.entity:SetPristine()
  
  if not TheWorld.ismastersim then
    return inst
  end

  common_master(inst)

  MakeInvItemIA(inst)

  inst:AddComponent("edible")
  inst.components.edible.foodtype = "MEAT"
  inst.components.edible.foodstate = "DRIED"
  inst.components.edible.hungervalue = TUNING.CALORIES_MEDSMALL
  inst.components.edible.sanityvalue = 0

  inst.components.perishable:SetPerishTime(TUNING.PERISH_PRESERVED)
  inst.components.perishable:StartPerishing()
  inst.components.perishable.onperishreplacement = "spoiled_food"

  inst.AnimState:SetBank("meat_rack_food")
  inst.AnimState:SetBuild("meat_rack_food_sw")
  inst.AnimState:PlayAnimation("idle_dried_jellyjerky", true)
  inst:AddComponent("stackable")
  inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
  return inst

end

return Prefab( "rainbowjellyfish", defaultfn, assets),
Prefab( "rainbowjellyfish_dead", deadfn, assets),
Prefab( "rainbowjellyfish_cooked", cookedfn, assets),
Prefab( "rainbowjellyjerky", driedfn, assets)
