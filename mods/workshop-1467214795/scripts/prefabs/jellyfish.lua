local assets =
{
  Asset('ANIM', 'anim/jellyfish.zip'),
  Asset("ANIM", "anim/meat_rack_food_sw.zip"),
}

local prefabs = 
{
  'jellyfish_planted',
}

local function playshockanim(inst)
  if inst:HasTag('aquatic') then
    inst.AnimState:PlayAnimation('idle_water_shock')
    inst.AnimState:PushAnimation('idle_water', true)
    inst.SoundEmitter:PlaySound("ia/creatures/jellyfish/electric_water")
  else
    inst.AnimState:PlayAnimation('idle_ground_shock')
    inst.AnimState:PushAnimation('idle_ground', true)
    inst.SoundEmitter:PlaySound("ia/creatures/jellyfish/electric_water")
  end
end

local function playdeadanim(inst)
  inst.AnimState:PlayAnimation('idle_ground', true)
end

local function removeifdropped(inst)
	if not inst.components.inventoryitem:IsHeld() then
		local replacement = SpawnPrefab('jellyfish_planted')
		replacement.Transform:SetPosition(inst.Transform:GetWorldPosition())
		inst:Remove()
	end
end

local function ondropped(inst)
	if inst.components.inventoryitem:IsHeld() then return end --KLEI'S FLOATER IMPLEMENTATION SUCKS -M
  if IsOnWater(inst) then
	inst:DoTaskInTime(0, removeifdropped) --KLEI'S BACKPACK IMPLEMENTATION SUCKS -M
  else
    local replacement = SpawnPrefab("jellyfish_dead")
    replacement.Transform:SetPosition(inst.Transform:GetWorldPosition())
    replacement.AnimState:PlayAnimation('death_ground', true)
    replacement:DoTaskInTime(2.5, playdeadanim)
    replacement.shocktask = replacement:DoPeriodicTask(math.random() * 10 + 5, playshockanim)
    replacement:AddTag('stinger')
    inst:Remove()
  end
end

local function ondroppeddead(inst)
  inst:AddTag('stinger')
  inst.shocktask = inst:DoPeriodicTask(math.random() * 10 + 5, playshockanim)
  inst.AnimState:PlayAnimation('idle_ground', true)
end

local function onpickup(inst, guy)
  if inst:HasTag('stinger') and guy.components.combat and guy.components.inventory then
    if not guy.components.inventory:IsInsulated() then
      guy.components.health:DoDelta(-TUNING.JELLYFISH_DAMAGE, nil, inst.prefab, nil, inst)
      guy.sg:GoToState('electrocute')
    end

    inst:RemoveTag('stinger')
  end

  if inst.shocktask then
    inst.shocktask:Cancel()
    inst.shocktask = nil
  end
end

local function commonfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	inst.AnimState:SetBank("jellyfish")
	inst.AnimState:SetBuild("jellyfish")

	inst.AnimState:SetRayTestOnBB(true)
	inst.AnimState:SetLayer( LAYER_BACKGROUND )
	inst.AnimState:SetSortOrder( 3 )

	MakeInventoryPhysics(inst)

	return inst
end

local function masterfn(inst)

  MakeInvItemIA(inst)
  
  inst:AddComponent("inspectable")

  inst:AddComponent('tradable')
  inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
  inst.components.tradable.dubloonvalue = TUNING.DUBLOON_VALUES.SEAFOOD

  return inst
end

local function default()
  local inst = commonfn()
  inst.AnimState:PlayAnimation('idle_ground', true)
  inst:AddTag('show_spoilage')
  inst:AddTag("small_livestock") -- "hungry" instead of "stale"

	MakeInventoryFloatable(inst)
	inst.components.floater:UpdateAnimations("idle_water", "idle_ground")

  inst.entity:SetPristine()

  if not TheWorld.ismastersim then
    return inst
  end

  masterfn(inst)

    inst:AddComponent('perishable')
    inst.components.perishable:SetPerishTime(TUNING.PERISH_ONE_DAY * 1.5)
    inst.components.perishable.onperishreplacement = 'jellyfish_dead'
    inst.components.perishable:StartPerishing()

  inst.components.inventoryitem:SetOnDroppedFn(ondropped)
  inst.components.inventoryitem:SetOnPickupFn(onpickup)

	inst:ListenForEvent("on_landed", ondropped)

  inst:AddComponent('cookable')
  inst.components.cookable.product = 'jellyfish_cooked'

  inst:AddComponent('health')
  inst.components.health.murdersound = 'ia/creatures/jellyfish/death_murder'

  inst:AddComponent('lootdropper')
  inst.components.lootdropper:SetLoot({'jellyfish_dead'})

  return inst
end

local function dead()
  local inst = commonfn()

  inst.AnimState:PlayAnimation('idle_ground')

	MakeInventoryFloatable(inst)
	inst.components.floater:UpdateAnimations("idle_water", "idle_ground")

  inst.entity:SetPristine()

  if not TheWorld.ismastersim then
    return inst
  end

  masterfn(inst)

    inst:AddComponent('edible')
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible.foodstate = 'COOKED'

    inst:AddComponent('perishable')
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
    inst.components.perishable.onperishreplacement = 'spoiled_food'
    inst.components.perishable:StartPerishing()

  inst.components.inventoryitem:SetOnDroppedFn(ondroppeddead)
  inst.components.inventoryitem:SetOnPickupFn(onpickup)

  inst:AddComponent('cookable')
  inst.components.cookable.product = 'jellyfish_cooked'

  inst:AddComponent('dryable')
  inst.components.dryable:SetProduct("jellyjerky")
  inst.components.dryable:SetDryTime(TUNING.DRY_FAST)

  inst:AddComponent('stackable')
  inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

  return inst
end

local function cooked()
  local inst = commonfn()

  inst.AnimState:PlayAnimation('cooked')

  inst.entity:SetPristine()

  if not TheWorld.ismastersim then
    return inst
  end
  
  masterfn(inst)

    inst:AddComponent('edible')
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible.foodstate = 'COOKED'
    inst.components.edible.hungervalue = TUNING.CALORIES_MEDSMALL

    inst:AddComponent('perishable')
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.perishable.onperishreplacement = 'spoiled_food'
    inst.components.perishable:StartPerishing()

  inst:AddComponent('stackable')
  inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

  return inst
end

local function dried()
  local inst = commonfn()
  inst:AddTag('show_spoilage')

  inst.AnimState:SetBank('meat_rack_food')
  inst.AnimState:SetBuild('meat_rack_food_sw')
  inst.AnimState:PlayAnimation('idle_dried_jellyjerky')

	MakeInventoryFloatable(inst)
	inst.components.floater:UpdateAnimations("idle_dried_jellywater", "idle_dried_jellyjerky")

  inst.entity:SetPristine()

  if not TheWorld.ismastersim then
    return inst
  end

  masterfn(inst)

    inst:AddComponent('edible')
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible.foodstate = 'DRIED'
    inst.components.edible.hungervalue = TUNING.CALORIES_MEDSMALL

    inst:AddComponent('perishable')
    inst.components.perishable:SetPerishTime(TUNING.PERISH_PRESERVED)
    inst.components.perishable.onperishreplacement = 'spoiled_food'
    inst.components.perishable:StartPerishing()

  inst:AddComponent('stackable')
  inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

  return inst
end

return Prefab( 'jellyfish', default, assets),
Prefab( 'jellyfish_dead', dead, assets),
Prefab( 'jellyfish_cooked', cooked, assets),
Prefab( 'jellyjerky', dried, assets)