local assets_seeds =
{
  Asset("ANIM", "anim/seeds.zip"),
}

local function OnDeploy(inst, pt)--, deployer, rot)
    local plant = SpawnPrefab("plant_normal_ground")
    plant.components.crop:StartGrowing(inst.components.plantable.product, inst.components.plantable.growtime)
    plant.Transform:SetPosition(pt.x, 0, pt.z)
    plant.SoundEmitter:PlaySound("dontstarve/wilson/plant_seeds")
    inst:Remove()
end

local function MakeVeggie(name, has_seeds)

  local assets =
  {
    Asset("ANIM", "anim/"..name..".zip"),
  }

  local assets_cooked =
  {
    Asset("ANIM", "anim/"..name..".zip"),
  }

  local prefabs =
  {
    name.."_cooked",
    "spoiled_food",
  }

  if has_seeds then
    table.insert(prefabs, name.."_seeds")
  end

  local function fn_seeds()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("seeds")
    inst.AnimState:SetBuild("seeds")
    inst.AnimState:SetRayTestOnBB(true)

	inst:AddTag("deployedplant")

    --cookable (from cookable component) added to pristine state for optimization
    inst:AddTag("cookable")

	inst.overridedeployplacername = "seeds_placer"

	MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
      return inst
    end

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.SEEDS

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("tradable")
    inst:AddComponent("inspectable")
    
    MakeInvItemIA(inst)

    inst.AnimState:PlayAnimation("idle")
    inst.components.edible.healthvalue = TUNING.HEALING_TINY/2
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("cookable")
    inst.components.cookable.product = "seeds_cooked"

    inst:AddComponent("bait")
    inst:AddComponent("plantable")
    inst.components.plantable.growtime = TUNING.SEEDS_GROW_TIME
    inst.components.plantable.product = name

	inst:AddComponent("deployable")
	inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
	inst.components.deployable.restrictedtag = "plantkin"
	inst.components.deployable.ondeploy = OnDeploy

    MakeHauntableLaunchAndPerish(inst)

    return inst
  end

  local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank(name)
    inst.AnimState:SetBuild(name)
    inst.AnimState:PlayAnimation("idle")

    --cookable (from cookable component) added to pristine state for optimization
    inst:AddTag("cookable")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
      return inst
    end

    inst:AddComponent("edible")
    inst.components.edible.healthvalue = IA_VEGGIES[name].health
    inst.components.edible.hungervalue = IA_VEGGIES[name].hunger
    inst.components.edible.sanityvalue = IA_VEGGIES[name].sanity or 0      
    inst.components.edible.foodtype = FOODTYPE.VEGGIE

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(IA_VEGGIES[name].perishtime)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("stackable")
    if name ~= "pumpkin" and
    name ~= "eggplant" and
    name ~= "durian" and 
    name ~= "watermelon" then
      inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    end

    if name == "watermelon" then
      inst.components.edible.temperaturedelta = TUNING.COLD_FOOD_BONUS_TEMP
      inst.components.edible.temperatureduration = TUNING.FOOD_TEMP_BRIEF
    end

    inst:AddComponent("inspectable")
    
    MakeInvItemIA(inst, name)

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    ---------------------        

    inst:AddComponent("bait")

    ------------------------------------------------
    inst:AddComponent("tradable")

    ------------------------------------------------  

    inst:AddComponent("cookable")
    inst.components.cookable.product = name.."_cooked"

    MakeHauntableLaunchAndPerish(inst)

    return inst
  end

  local function fn_cooked()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank(name)
    inst.AnimState:SetBuild(name)
    inst.AnimState:PlayAnimation("cooked")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
      return inst
    end

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(IA_VEGGIES[name].cooked_perishtime)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("edible")
    inst.components.edible.healthvalue = IA_VEGGIES[name].cooked_health
    inst.components.edible.hungervalue = IA_VEGGIES[name].cooked_hunger
    inst.components.edible.sanityvalue = IA_VEGGIES[name].cooked_sanity or 0
    inst.components.edible.foodtype = FOODTYPE.VEGGIE

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")
    
    MakeInvItemIA(inst, name.."_cooked")

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    ---------------------        

    inst:AddComponent("bait")

    ------------------------------------------------
    inst:AddComponent("tradable")

    MakeHauntableLaunchAndPerish(inst)

    return inst
  end

  local base = Prefab(name, fn, assets, prefabs)
  local cooked = Prefab(name.."_cooked", fn_cooked, assets_cooked)
  local seeds = has_seeds and Prefab(name.."_seeds", fn_seeds, assets_seeds) or nil

  return base, cooked, seeds
end

local prefs = {}
for veggiename,veggiedata in pairs(IA_VEGGIES) do
  local veg, cooked, seeds = MakeVeggie(veggiename, veggiename ~= "berries" and veggiename ~= "cave_banana" and veggiename ~= "cactus_meat" and veggiename ~= "berries_juicy")
  table.insert(prefs, veg)
  table.insert(prefs, cooked)
  if seeds then
    table.insert(prefs, seeds)
  end
end

return unpack(prefs)