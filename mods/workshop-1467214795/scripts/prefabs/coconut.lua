require "prefabutil"
local assets =
{
  Asset("ANIM", "anim/coconut.zip"),
}

local function plant(inst, growtime)
    local sapling = SpawnPrefab("coconut_sapling")
    sapling:StartGrowing(growtime)
    sapling.Transform:SetPosition(inst.Transform:GetWorldPosition())
    sapling.SoundEmitter:PlaySound("dontstarve/wilson/plant_tree")
    inst:Remove()
end

local function ondeploy (inst, pt) 
  inst = inst.components.stackable:Get()
  inst.Transform:SetPosition(pt:Get() )
  local timeToGrow = GetRandomWithVariance(TUNING.COCONUT_GROWTIME.base, TUNING.COCONUT_GROWTIME.random)
  plant(inst, timeToGrow)

  --tell any nearby leifs to chill out
  local ents = TheSim:FindEntities(pt.x,pt.y,pt.z, TUNING.LEIF_PINECONE_CHILL_RADIUS, {"leif"})

  local played_sound = false
  for k,v in pairs(ents) do

    local chill_chance = TUNING.LEIF_PINECONE_CHILL_CHANCE_FAR
    if distsq(pt, Vector3(v.Transform:GetWorldPosition())) < TUNING.LEIF_PINECONE_CHILL_CLOSE_RADIUS*TUNING.PALMTREEGUARD_PINECONE_CHILL_CLOSE_RADIUS then
      chill_chance = TUNING.LEIF_PINECONE_CHILL_CHANCE_CLOSE
    end

    if math.random() < chill_chance then
      if v.components.sleeper then
        v.components.sleeper:GoToSleep(1000)
      end
    else
      if not played_sound then
        v.SoundEmitter:PlaySound("dontstarve/creatures/leif/taunt_VO")
        played_sound = true
      end
    end

  end

end

-- local notags = {'NOBLOCK', 'player', 'FX'}
-- local function test_ground(inst, pt)
  -- local tiletype = GetGroundTypeAtPosition(pt)
  -- local ground_OK = tiletype == GROUND.DIRT or tiletype == GROUND.BEACH
  -- inst:IsPosSurroundedByLand(pt.x, pt.y, pt.z, 1)

  -- if ground_OK then
    -- local ents = TheSim:FindEntities(pt.x,pt.y,pt.z, 4, nil, notags) -- or we could include a flag to the search?
    -- local min_spacing = inst.components.deployable.min_spacing or 2

    -- for k, v in pairs(ents) do
      -- if v ~= inst and v:IsValid() and v.entity:IsVisible() and not v.components.placer and v.parent == nil then
        -- if distsq( Vector3(v.Transform:GetWorldPosition()), pt) < min_spacing*min_spacing then
          -- return false
        -- end
      -- end
    -- end
    -- return true
  -- end
  -- return false
-- end

local function OnLoad(inst, data)
  if data and data.growtime then
    plant(inst, data.growtime)
  end
end

local function clientcommon()
  local inst = CreateEntity()
  inst.entity:AddTransform()
  inst.entity:AddAnimState()
  inst.entity:AddSoundEmitter()
  inst.entity:AddNetwork()

  MakeInventoryPhysics(inst)

  inst.AnimState:SetBank("coconut")
  inst.AnimState:SetBuild("coconut")
  inst.AnimState:PlayAnimation("idle")

  inst:AddTag("coconut")
  inst:AddTag("cattoy")

	return inst
end

local function mastercommon(inst)
	MakeBlowInHurricane(inst, TUNING.WINDBLOWN_SCALE_MIN.MEDIUM, TUNING.WINDBLOWN_SCALE_MAX.MEDIUM)

  inst:AddComponent("tradable")

  inst:AddComponent("stackable")
  inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

  inst:AddComponent("inspectable")

  MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
  MakeSmallPropagator(inst)
  MakeHauntableLaunchAndPerish(inst)

  inst:AddComponent("perishable")
  inst.components.perishable:SetPerishTime(TUNING.PERISH_PRESERVED)
  inst.components.perishable:StartPerishing()
  inst.components.perishable.onperishreplacement = "spoiled_food"

  inst:AddComponent("edible")
  inst.components.edible.foodtype = FOODTYPE.RAW

  MakeInvItemIA(inst)
end

local function onhacked(inst)
  local nut = inst 
  if inst.components.inventoryitem then 
    local owner = inst.components.inventoryitem.owner
    if inst.components.stackable and inst.components.stackable.stacksize > 1 then 
      nut = inst.components.stackable:Get()
      inst.components.workable:SetWorkLeft(1)
    end 
    if owner then 
      local hacked = SpawnPrefab("coconut_halved")
      hacked.components.stackable.stacksize = 2
      if owner.components.inventory and not owner.components.inventory:IsFull() then
        owner.components.inventory:GiveItem(hacked)
      elseif owner.components.container and not owner.components.container:IsFull() then
        owner.components.container:GiveItem(hacked)
      else
        inst.components.lootdropper:DropLootPrefab(hacked)
      end
    else 
      inst.components.lootdropper:SpawnLootPrefab("coconut_halved")
      inst.components.lootdropper:SpawnLootPrefab("coconut_halved")
    end 
    inst.SoundEmitter:PlaySound("ia/common/bamboo_hack")
  end
  nut:Remove()

end 

local function raw()
  local inst = clientcommon()

	inst:AddTag("deployedplant")

	MakeInventoryFloatable(inst)
	inst.components.floater:UpdateAnimations("idle_water", "idle")
	
  inst.entity:SetPristine()
  
  if not TheWorld.ismastersim then
    return inst
  end

	mastercommon(inst)

  inst.components.inventoryitem.imagename = "coconut" --Why is this explicitly set to the prefab name? -M

  inst:AddTag("show_spoilage")
  inst:AddComponent("workable")
  inst.components.workable:SetWorkAction(ACTIONS.HACK)
  inst.components.workable:SetWorkLeft(1)
  inst.components.workable:SetOnFinishCallback(onhacked)

  inst:AddComponent("lootdropper")

  inst:AddComponent("deployable")
  inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
  inst.components.deployable.ondeploy = ondeploy


  inst.components.edible.healthvalue = 0
  inst.components.edible.hungervalue = TUNING.CALORIES_TINY/2

  inst.OnLoad = OnLoad

  return inst
end 

local function cooked()
  local inst = clientcommon()

	MakeInventoryFloatable(inst)
	inst.components.floater:UpdateAnimations("cooked_water", "cook")
	
  inst.entity:SetPristine()
  
  if not TheWorld.ismastersim then
    return inst
  end

	mastercommon(inst)

  inst.components.inventoryitem.imagename = "coconut_cooked"

  inst.AnimState:PlayAnimation("cook")
  
  inst.components.edible.foodstate = "COOKED"
  inst.components.edible.hungervalue = TUNING.CALORIES_TINY
  inst.components.edible.healthvalue = TUNING.HEALING_TINY
  inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
  inst.components.edible.foodtype = FOODTYPE.SEEDS

  return inst
end

local function halved()
  local inst = clientcommon()

	MakeInventoryFloatable(inst)
	inst.components.floater:UpdateAnimations("chopped_water", "chiopped")
	
  inst.entity:SetPristine()
  
  if not TheWorld.ismastersim then
    return inst
  end

	mastercommon(inst)

  inst.components.inventoryitem.imagename = "coconut_halved"

  inst:AddComponent("cookable")
  inst.components.cookable.product = "coconut_cooked"
  inst.AnimState:PlayAnimation("chopped")
  
  inst.components.edible.hungervalue = TUNING.CALORIES_TINY/2
  inst.components.edible.healthvalue = TUNING.HEALING_TINY
  inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
  inst.components.edible.foodtype = FOODTYPE.SEEDS

  return inst
end


local function growtree(inst)
    local tree = SpawnPrefab("palmtree_short")
    if tree then
        tree.Transform:SetPosition(inst.Transform:GetWorldPosition())
        tree:growfromseed()
        inst:Remove()
    end
end

local function stopgrowing(inst)
    inst.components.timer:StopTimer("grow")
end

local function startgrowing(inst, growtime)
    if not inst.components.timer:TimerExists("grow") then
        growtime = growtime or GetRandomWithVariance(TUNING.COCONUT_GROWTIME.base, TUNING.COCONUT_GROWTIME.random)
        inst.components.timer:StartTimer("grow", growtime)
    end
end

local function ontimerdone(inst, data)
    if data.name == "grow" then
        growtree(inst)
    end
end

local function digup(inst, digger)
    inst.components.lootdropper:DropLoot()
    inst:Remove()
end

local function saplingfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("coconut")
	inst.AnimState:SetBuild("coconut")
	inst.AnimState:PlayAnimation("planted")

	-- inst:AddTag("coconut")
	-- inst:AddTag("isgrowing")
	inst:AddTag("plant")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.StartGrowing = startgrowing

	inst:AddComponent("timer")
	inst:ListenForEvent("timerdone", ontimerdone)
	startgrowing(inst)

	inst:AddComponent("inspectable")

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"twigs"})

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(digup)
	inst.components.workable:SetWorkLeft(1)

	MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
	inst:ListenForEvent("onignite", stopgrowing)
	inst:ListenForEvent("onextinguish", startgrowing)
	MakeSmallPropagator(inst)

	MakeHauntableIgnite(inst)

	return inst
end

return Prefab( "coconut", raw, assets, prefabs),
Prefab( "coconut_sapling", saplingfn, assets),
Prefab( "coconut_cooked", cooked, assets),
Prefab( "coconut_halved", halved, assets),
MakePlacer( "coconut_placer", "coconut", "coconut", "planted" ) 


