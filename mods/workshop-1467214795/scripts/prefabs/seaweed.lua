local assets=
{
  Asset("ANIM", "anim/seaweed.zip"),
  Asset("ANIM", "anim/meat_rack_food_sw.zip"),
}


local prefabs = 
{
  "seaweed_planted",
  "seaweed_cooked",
  "seaweed_dried",
}

local function raw_onlanded(inst)
	if not inst.components.blowinwindgustitem then return end
	if IsOnWater(inst) then
		inst.components.blowinwindgustitem:SetMaxSpeedMult(TUNING.WINDBLOWN_SCALE_MAX.MEDIUM)
		inst.components.blowinwindgustitem:SetMinSpeedMult(TUNING.WINDBLOWN_SCALE_MIN.MEDIUM)
	else
		inst.components.blowinwindgustitem:SetMaxSpeedMult(TUNING.WINDBLOWN_SCALE_MAX.LIGHT)
		inst.components.blowinwindgustitem:SetMinSpeedMult(TUNING.WINDBLOWN_SCALE_MIN.LIGHT)
	end
end

local function commonfn(name)
  local inst = CreateEntity()
  inst.entity:AddTransform()
  inst.entity:AddAnimState()
  inst.entity:AddNetwork()

  MakeInventoryPhysics(inst)

  inst.entity:AddSoundEmitter()

  inst.AnimState:SetRayTestOnBB(true);    
  inst.AnimState:SetBank("seaweed")
  inst.AnimState:SetBuild("seaweed")

  inst.AnimState:SetLayer( LAYER_BACKGROUND )
  inst.AnimState:SetSortOrder( 3 )

	MakeInventoryFloatable(inst)

	return inst
end

local function commonmasterfn(inst)
  inst:AddComponent("edible")
  inst.components.edible.foodtype = "VEGGIE"

  inst:AddComponent("stackable")
  inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

  inst:AddComponent("inspectable")

  MakeInvItemIA(inst)

  inst:AddComponent("perishable")
  inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
  inst.components.perishable:StartPerishing()
  inst.components.perishable.onperishreplacement = "spoiled_food"


  --shine(inst)
end

local function defaultfn()

  local inst = commonfn("seaweed")

  inst.AnimState:PlayAnimation("idle_water", true)

	inst.components.floater:UpdateAnimations("idle_water", "idle")

	inst.entity:SetPristine()
  
  if not TheWorld.ismastersim then
    return inst
  end

	commonmasterfn(inst)

  inst.components.edible.healthvalue = TUNING.HEALING_TINY
  inst.components.edible.hungervalue = TUNING.CALORIES_TINY
  inst.components.edible.sanityvalue = -TUNING.SANITY_SMALL
  inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)

  inst:AddComponent("cookable")
  inst.components.cookable.product = "seaweed_cooked"

  inst:AddComponent("dryable")
  inst.components.dryable:SetProduct("seaweed_dried")
  inst.components.dryable:SetDryTime(TUNING.DRY_FAST)

  MakeBlowInHurricane(inst, TUNING.WINDBLOWN_SCALE_MIN.MEDIUM, TUNING.WINDBLOWN_SCALE_MAX.MEDIUM)
	inst:ListenForEvent("on_landed", raw_onlanded)

  inst:AddComponent("fertilizer")
  inst.components.fertilizer.fertilizervalue = TUNING.POOP_FERTILIZE
  inst.components.fertilizer.soil_cycles = TUNING.POOP_SOILCYCLES
  inst.components.fertilizer.withered_cycles = TUNING.POOP_WITHEREDCYCLES
  inst.components.fertilizer.oceanic = true

  return inst
end 


local function cookedfn()

  local inst = commonfn("seaweed_cooked")

  inst.AnimState:PlayAnimation("cooked", true)
 
	inst.components.floater:UpdateAnimations("cooked_water", "cooked")

	inst.entity:SetPristine()

  if not TheWorld.ismastersim then
    return inst
  end
  
	commonmasterfn(inst)

  inst.components.edible.foodstate = "COOKED"
  inst.components.edible.healthvalue = TUNING.HEALING_SMALL
  inst.components.edible.hungervalue = TUNING.CALORIES_TINY
  inst.components.edible.sanityvalue = 0--TUNING.SANITY_SMALL
  inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)

  return inst
end 

local function driedfn()
  local inst = commonfn("seaweed_dried")

  inst.AnimState:SetBank("meat_rack_food")
  inst.AnimState:SetBuild("meat_rack_food_sw")
  inst.AnimState:PlayAnimation("idle_dried_seaweed")

	inst.components.floater:UpdateAnimations("idle_dried_seaweed_water", "idle_dried_seaweed")

	inst.entity:SetPristine()

  if not TheWorld.ismastersim then
    return inst
  end

	commonmasterfn(inst)
	
  inst.components.edible.foodstate = "DRIED"
  inst.components.edible.healthvalue = TUNING.HEALING_SMALL
  inst.components.edible.hungervalue = TUNING.CALORIES_SMALL
  inst.components.edible.sanityvalue = 0--TUNING.SANITY_SMALL
  inst.components.perishable:SetPerishTime(TUNING.PERISH_PRESERVED)


  return inst
end 

return Prefab( "seaweed", defaultfn, assets, prefabs), 
Prefab( "seaweed_cooked", cookedfn, assets), 
Prefab( "seaweed_dried", driedfn, assets)
