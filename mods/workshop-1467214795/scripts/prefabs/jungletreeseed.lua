require "prefabutil"
local assets =
{
  Asset("ANIM", "anim/jungletreeseed.zip"),
}

local function plant(inst, growtime)
	local sapling = SpawnPrefab("jungletreeseed_sapling")
	sapling:StartGrowing(growtime)
	sapling.Transform:SetPosition(inst.Transform:GetWorldPosition())
	sapling.SoundEmitter:PlaySound("dontstarve/wilson/plant_tree")
	inst:Remove()
end

local function ondeploy (inst, pt) 
  inst = inst.components.stackable:Get()
  inst.Transform:SetPosition(pt:Get() )
  local timeToGrow = GetRandomWithVariance(TUNING.JUNGLETREESEED_GROWTIME.base, TUNING.JUNGLETREESEED_GROWTIME.random)
  plant(inst, timeToGrow)

  --tell any nearby leifs to chill out
  local ents = TheSim:FindEntities(pt.x,pt.y,pt.z, TUNING.LEIF_PINECONE_CHILL_RADIUS, {"leif"})

  local played_sound = false
  for k,v in pairs(ents) do

    local chill_chance = TUNING.LEIF_PINECONE_CHILL_CHANCE_FAR
    if distsq(pt, Vector3(v.Transform:GetWorldPosition())) < TUNING.LEIF_PINECONE_CHILL_CLOSE_RADIUS*TUNING.LEIF_PINECONE_CHILL_CLOSE_RADIUS then
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
  -- local ground_OK = tiletype ~= GROUND.ROCKY and tiletype ~= GROUND.ROAD and tiletype ~= GROUND.IMPASSABLE and tiletype ~= GROUND.MAGMAFIELD and
  -- tiletype ~= GROUND.UNDERROCK and tiletype ~= GROUND.WOODFLOOR and tiletype ~= GROUND.BEACH and 
  -- tiletype ~= GROUND.CARPET and tiletype ~= GROUND.CHECKER and tiletype < GROUND.UNDERGROUND and
  -- tiletype ~= GROUND.ASH and tiletype ~= GROUND.VOLCANO and tiletype ~= GROUND.VOLCANO_ROCK and tiletype ~= GROUND.BRICK_GLOW and
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

-- backwards-compatibility
local function OnLoad(inst, data)
    if data ~= nil and data.growtime ~= nil then
        plant(inst, data.growtime)
    end
end

local function fn()
  local inst = CreateEntity()
  inst.entity:AddTransform()
  inst.entity:AddAnimState()
  inst.entity:AddSoundEmitter()
  inst.entity:AddNetwork()

  MakeInventoryPhysics(inst)

  inst.AnimState:SetBank("jungletreeseed")
  inst.AnimState:SetBuild("jungletreeseed")
  inst.AnimState:PlayAnimation("idle")

	inst:AddTag("deployedplant")
  inst:AddTag("cattoy")

  inst.entity:SetPristine()

  if not TheWorld.ismastersim then
    return inst
  end

  MakeBlowInHurricane(inst, TUNING.WINDBLOWN_SCALE_MIN.LIGHT, TUNING.WINDBLOWN_SCALE_MAX.LIGHT)

  --inst:AddComponent("edible")
  --inst.components.edible.foodtype = "WOOD"
  --inst.components.edible.woodiness = 2

  inst:AddComponent("tradable")

  inst:AddComponent("stackable")
  inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

  inst:AddComponent("inspectable")

  inst:AddComponent("fuel")
  inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

  inst:AddComponent("appeasement")
  inst.components.appeasement.appeasementvalue = TUNING.WRATH_SMALL

  MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
  MakeSmallPropagator(inst)
  MakeHauntableLaunchAndPerish(inst)

  MakeInvItemIA(inst)
	inst.components.inventoryitem:SetSinks(true)

  inst:AddComponent("deployable")
  inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
  inst.components.deployable.ondeploy = ondeploy

  inst.OnLoad = OnLoad
  
  return inst
end


local function growtree(inst)
    local tree = SpawnPrefab("jungletree_short")
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
        growtime = growtime or GetRandomWithVariance(TUNING.JUNGLETREESEED_GROWTIME.base, TUNING.JUNGLETREESEED_GROWTIME.random)
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

	inst.AnimState:SetBank("jungletreeseed")
	inst.AnimState:SetBuild("jungletreeseed")
	inst.AnimState:PlayAnimation("idle_planted")

	-- inst:AddTag("jungletree")
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


return Prefab( "jungletreeseed", fn, assets),
Prefab( "jungletreeseed_sapling", saplingfn, assets),
MakePlacer( "jungletreeseed_placer", "jungletreeseed", "jungletreeseed", "idle_planted" ) 


