local assets=
{
  Asset("ANIM", "anim/seaweed.zip"),
}

local prefabs=
{
  "seaweed",
}

local function onpickedfn(inst)
  inst.AnimState:PlayAnimation("picking")
  inst.AnimState:PushAnimation("picked", true)
  --inst.entity:Hide()
end

local function ontransplantfn(inst)
	inst.components.pickable:MakeEmpty()
  inst.AnimState:PlayAnimation("picked", true)
  --inst.entity:Hide()
end

local function onregenfn(inst)
  inst.AnimState:PlayAnimation("grow")
  inst.AnimState:PushAnimation("idle_plant", true)
  --inst.entity:Show()
end

local function makeemptyfn(inst)
  inst.AnimState:PlayAnimation("picking")
  inst.AnimState:PushAnimation("picked", true)
  --inst.entity:Hide()
end

local function makebarrenfn(inst)
  inst.AnimState:PlayAnimation("picking")
  inst.AnimState:PushAnimation("picked", true)
  --inst.entity:Hide()
end

local function makefullfn(inst)
  inst.AnimState:PlayAnimation("grow")
  inst.AnimState:PushAnimation("idle_plant", true)
  --inst.entity:Show()
end


local function fn(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local _minimap = inst.entity:AddMiniMapEntity()
	_minimap:SetIcon( "seaweed.tex" )

	inst.AnimState:SetBank("seaweed")
	inst.AnimState:SetBuild("seaweed")
	inst.AnimState:PlayAnimation("idle_plant", true)

	inst.AnimState:OverrideSymbol("water_ripple", "ripple_build", "water_ripple")
	inst.AnimState:OverrideSymbol("water_shadow", "ripple_build", "water_shadow")

	inst.AnimState:SetRayTestOnBB(true)
	inst.AnimState:SetLayer( LAYER_BACKGROUND )
	inst.AnimState:SetSortOrder( 3 )

    inst:AddTag("aquatic")
	inst:AddTag("plant")

  inst.entity:SetPristine()

  if not TheWorld.ismastersim then
    return inst
  end

  inst:AddComponent("inspectable")

  inst:AddComponent("pickable")
  inst.components.pickable.picksound = "ia/common/item_wet_harvest"
  inst.components.pickable:SetUp("seaweed", TUNING.SEAWEED_REGROW_TIME +  math.random()*TUNING.SEAWEED_REGROW_VARIANCE)
  inst.components.pickable:SetOnPickedFn(onpickedfn)
  inst.components.pickable:SetOnRegenFn(onregenfn)
  inst.components.pickable.makeemptyfn = makeemptyfn
  inst.components.pickable.makebarrenfn = makebarrenfn
  inst.components.pickable.makefullfn = makefullfn
  inst.components.pickable.ontransplantfn = ontransplantfn
  inst.components.pickable.quickpick = false


  --MakeSmallBurnable(inst)
  --MakeSmallPropagator(inst)
  --MakeInventoryFloatable(inst, "idle_water", "idle")

  return inst
end

return Prefab( "seaweed_planted", fn, assets) 
