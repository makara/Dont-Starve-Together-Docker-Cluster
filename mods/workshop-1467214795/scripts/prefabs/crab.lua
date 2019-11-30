require "stategraphs/SGcrab"

local assets=
{
  Asset("ANIM", "anim/crabbit_build.zip"),
  Asset("ANIM", "anim/crabbit_beardling_build.zip"),
  Asset("ANIM", "anim/beardling_crabbit.zip"),

  Asset("ANIM", "anim/crabbit.zip"),	
}

local prefabs =
{
  "fish_small",
  "fish_small_cooked",
  "beardhair",
}

local crabbitsounds = 
{
  scream = "ia/creatures/crab/scream",
  hurt = "ia/creatures/crab/scream_short",
}

local beardsounds = 
{
  scream = "ia/creatures/crab/bearded_crab",
  hurt = "ia/creatures/crab/scream_short",
}


local brain = require "brains/crabbrain"

local function IsCrazyGuy(guy)
  local sanity = guy ~= nil and guy.replica.sanity or nil
  return sanity ~= nil and (not sanity.IsInsanityMode or sanity:IsInsanityMode()) and sanity:GetPercentNetworked() <= (guy:HasTag("dappereffects") and TUNING.DAPPER_BEARDLING_SANITY or TUNING.BEARDLING_SANITY)
end

local function SetRabbitLoot(lootdropper)
    if not lootdropper.inst._fixedloot then
        lootdropper:SetLoot({"fish_small"})
    end
end

local function SetBeardlingLoot(lootdropper)
    if lootdropper.loot and not lootdropper.inst._fixedloot then
        lootdropper:SetLoot(nil)
        lootdropper:AddRandomLoot("beardhair", .5)
        lootdropper:AddRandomLoot("monstermeat", 1)
        lootdropper:AddRandomLoot("nightmarefuel", 1)
        lootdropper.numrandomloot = 1
    end
end

local function MakeInventoryRabbit(inst)
  inst._crazyinv = nil
  inst.components.inventoryitem:ChangeImageName("crab")
  inst.components.health.murdersound = inst.sounds.hurt
	SetRabbitLoot(inst.components.lootdropper)
end

local function MakeInventoryBeardMonster(inst)
  inst._crazyinv = true
  inst.components.inventoryitem:ChangeImageName("crabbit_beardling")
  inst.components.health.murdersound = beardsounds.hurt
	SetBeardlingLoot(inst.components.lootdropper)
end

local function UpdateInventoryState(inst)
  local viewer = inst.components.inventoryitem:GetGrandOwner()
  while viewer ~= nil and viewer.components.container ~= nil do
    viewer = viewer.components.container.opener
  end
  if IsCrazyGuy(viewer) then
    MakeInventoryBeardMonster(inst)
  else
    MakeInventoryRabbit(inst)
  end
end

local function BecomeRabbit(inst)
  if inst.components.health:IsDead() then
    return
  end

    inst.AnimState:SetBuild("crabbit_build")
    inst.sounds = crabbitsounds
    UpdateInventoryState(inst)
    if inst.components.hauntable ~= nil then
        inst.components.hauntable.haunted = false
    end
end

local function BecomeBeardling(inst)
    if inst.components.health:IsDead() then
        return
    end

    inst.AnimState:SetBuild("crabbit_beardling_build")
    inst.sounds = beardsounds
    UpdateInventoryState(inst)
    if inst.components.hauntable ~= nil then
        inst.components.hauntable.haunted = false
    end
end

local function StopWatchingSanity(inst)
  if inst._sanitywatching ~= nil then
    inst:RemoveEventCallback("sanitydelta", inst.OnWatchSanityDelta, inst._sanitywatching)
    inst._sanitywatching = nil
  end
end

local function WatchSanity(inst, target)
  StopWatchingSanity(inst)
  if target ~= nil then
    inst:ListenForEvent("sanitydelta", inst.OnWatchSanityDelta, target)
    inst._sanitywatching = target
  end
end

local function StopWatchingForOpener(inst)
  if inst._openerwatching ~= nil then
    inst:RemoveEventCallback("onopen", inst.OnContainerOpened, inst._openerwatching)
    inst:RemoveEventCallback("onclose", inst.OnContainerClosed, inst._openerwatching)
    inst._openerwatching = nil
  end
end

local function WatchForOpener(inst, target)
  StopWatchingForOpener(inst)
  if target ~= nil then
    inst:ListenForEvent("onopen", inst.OnContainerOpened, target)
    inst:ListenForEvent("onclose", inst.OnContainerClosed, target)
    inst._openerwatching = target
  end
end

local function OnPickup(inst, owner)
  if owner.components.container ~= nil then
    WatchForOpener(inst, owner)
    WatchSanity(inst, owner.components.container.opener)
  else
    StopWatchingForOpener(inst)
    WatchSanity(inst, owner)
  end
  UpdateInventoryState(inst)
end

local function OnDropped(inst)
  StopWatchingSanity(inst)
  UpdateInventoryState(inst)
  inst.sg:GoToState("stunned")
end

local function CalcSanityAura(inst, observer)
    return IsCrazyGuy(observer) and -TUNING.SANITYAURA_MED or 0
end

local function GetCookProductFn(inst, cooker, chef)
    return IsCrazyGuy(chef) and "cookedmonstermeat" or "fish_small_cooked"
end

local function OnCookedFn(inst)
  inst.SoundEmitter:PlaySound("ia/creatures/crab/scream_short")
end

local function LootSetupFunction(lootdropper)
    local guy = lootdropper.inst.causeofdeath
    if IsCrazyGuy(guy ~= nil and guy.components.follower ~= nil and guy.components.follower.leader or guy) then
        SetBeardlingLoot(lootdropper)
    else
        SetRabbitLoot(lootdropper)
    end
end

local function OnAttacked(inst, data)
  local x,y,z = inst.Transform:GetWorldPosition()
  local ents = TheSim:FindEntities(x,y,z, 30, {'crab'})

  local num_friends = 0
  local maxnum = 5
  for k,v in pairs(ents) do
    v:PushEvent("gohome")
    num_friends = num_friends + 1

    if num_friends > maxnum then
      break
    end
  end
end

local function OnDug(inst, worker)
  local rnd = math.random()
  local home = inst.components.homeseeker and inst.components.homeseeker.home
  if rnd >= 0.66 or not home then
    --Sometimes just go to stunned state

    inst:PushEvent("stunned")
  else
    --Sometimes return home instantly?
    worker:DoTaskInTime(1, function()
        worker:PushEvent("crab_fail")
      end)

    inst.components.lootdropper:SpawnLootPrefab("sand")
    local home = inst.components.homeseeker.home
    home.components.spawner:GoHome(inst)
  end
end

local function DisplayName(inst)
  if inst:HasTag("crab_hidden") then
    return STRINGS.NAMES.CRAB_HIDDEN
  end
  return STRINGS.NAMES.CRAB
end

local function getstatus(inst)
  if inst.sg:HasStateTag("invisible") then 
    return "HIDDEN"
  end
end

local function fn()
  local inst = CreateEntity()
  inst.entity:AddTransform()
  inst.entity:AddAnimState()
  inst.entity:AddPhysics()
  inst.entity:AddNetwork()
  inst.entity:AddLightWatcher()
  inst.entity:AddSoundEmitter()
  local shadow = inst.entity:AddDynamicShadow()
  shadow:SetSize( 1.5, .5 )
  inst.Transform:SetFourFaced()

  MakeCharacterPhysics(inst, 1, 0.5)

  inst.AnimState:SetBank("crabbit")
  inst.AnimState:SetBuild("crabbit_build")
  inst.AnimState:PlayAnimation("idle")

  inst:AddTag("animal")
  inst:AddTag("prey")
  inst:AddTag("rabbit")
  inst:AddTag("smallcreature")
  inst:AddTag("canbetrapped")
  inst:AddTag("cattoy")
  inst:AddTag("catfood")

  --cookable (from cookable component) added to pristine state for optimization
  inst:AddTag("cookable")

  inst.AnimState:SetClientsideBuildOverride("insane", "crabbit_build", "crabbit_beardling_build")

  MakeFeedableSmallLivestockPristine(inst)

  inst.displaynamefn = DisplayName

  inst.entity:SetPristine()

  if not TheWorld.ismastersim then
    return inst
  end

  inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
  inst.components.locomotor.runspeed = TUNING.CRAB_RUN_SPEED
  inst.components.locomotor.walkspeed = TUNING.CRAB_WALK_SPEED
  inst:SetStateGraph("SGcrab")

  inst:SetBrain(brain)

  inst.data = {}

  inst:AddComponent("eater")
	local diet = { FOODTYPE.MEAT, FOODTYPE.VEGGIE, FOODTYPE.INSECT }
    inst.components.eater:SetDiet(diet, diet)

  MakeInvItemIA(inst)
  inst.components.inventoryitem.nobounce = true
  inst.components.inventoryitem.canbepickedup = false
    inst.components.inventoryitem.canbepickedupalive = true --This lets Krampus, eyeplants, etc. pick it up
	inst.components.inventoryitem:SetSinks(true)

  inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura

  inst:AddComponent("cookable")
  inst.components.cookable.product = GetCookProductFn
  inst.components.cookable:SetOnCookedFn(OnCookedFn)

  inst:AddComponent("knownlocations")
  inst:AddComponent("combat")
  inst.components.combat.hiteffectsymbol = "eyes"
  inst:AddComponent("health")
  inst.components.health:SetMaxHealth(TUNING.CRAB_HEALTH)

  inst:AddComponent("workable")
  inst.components.workable:SetWorkAction(ACTIONS.DIG)
  inst.components.workable:SetWorkLeft(1)
  inst.components.workable.workable = false
  inst.components.workable:SetOnFinishCallback(OnDug)

  MakeSmallBurnableCharacter(inst, nil, Vector3(0, 0.1, 0))
  MakeTinyFreezableCharacter(inst, nil, Vector3(0, 0.1, 0))

  inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLootSetupFn(LootSetupFunction)

  inst:AddComponent("tradable")

  inst:AddComponent("inspectable")
  inst.components.inspectable.getstatus = getstatus
  inst:AddComponent("sleeper")

  inst:AddComponent("appeasement")
  inst.components.appeasement.appeasementvalue = TUNING.APPEASEMENT_MEDIUM

  --declared here so it can be used for event handlers
  inst.OnWatchSanityDelta = function(viewer)
    if IsCrazyGuy(viewer) then
      if not inst._crazyinv then
        MakeInventoryBeardMonster(inst)
      end
    elseif inst._crazyinv then
      MakeInventoryRabbit(inst)
    end
  end

  inst.OnContainerOpened = function(container, data)
    WatchSanity(inst, data.doer)
    UpdateInventoryState(inst)
  end

  inst.OnContainerClosed = function()
    StopWatchingSanity(inst)
    UpdateInventoryState(inst)
  end

  inst._sanitywatching = nil
  inst._openerwatching = nil

  BecomeRabbit(inst)

  MakeHauntablePanic(inst)

  inst:ListenForEvent("attacked", OnAttacked)

  MakeFeedableSmallLivestock(inst, TUNING.TOTAL_DAY_TIME*2, OnPickup, OnDropped)

  return inst
end

return Prefab( "crab", fn, assets, prefabs) 
