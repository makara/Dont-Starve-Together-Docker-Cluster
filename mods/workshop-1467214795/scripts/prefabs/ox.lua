local brain = require "brains/oxbrain"
require "stategraphs/SGox"

local assets=
{
  Asset("ANIM", "anim/ox_basic.zip"),
  Asset("ANIM", "anim/ox_actions.zip"),
  Asset("ANIM", "anim/ox_build.zip"),
  -- Asset("ANIM", "anim/ox_shaved_build.zip"),

  Asset("ANIM", "anim/ox_basic_water.zip"),
  Asset("ANIM", "anim/ox_actions_water.zip"),

  Asset("ANIM", "anim/ox_heat_build.zip"),
  Asset("SOUND", "sound/beefalo.fsb"),
}

local prefabs =
{
  "meat",
  "poop",
  "ox_horn",
}

SetSharedLootTable( 'ox',
  {
    {'meat',            1.00},
    {'meat',            1.00},
    {'meat',            1.00},
    {'meat',            1.00},
    {'ox_horn',            0.33},
  })

local sounds = 
{
  angry = "ia/creatures/OX/angry",
  curious = "ia/creatures/OX/curious",

  attack_whoosh = "ia/creatures/OX/attack_whoosh",
  chew = "ia/creatures/OX/chew",
  grunt = "ia/creatures/OX/bellow",
  hairgrow_pop = "ia/creatures/OX/hairgrow_pop",
  hairgrow_vocal = "ia/creatures/OX/hairgrow_vocal",
  sleep = "ia/creatures/OX/sleep",
  tail_swish = "ia/creatures/OX/tail_swish",
  walk_land = "ia/creatures/OX/walk_land",
  walk_water = "ia/creatures/OX/walk_water",

  death = "ia/creatures/OX/death",
  mating_call = "ia/creatures/OX/mating_call",

  emerge = "ia/creatures/seacreature_movement/water_emerge_med",
  submerge = "ia/creatures/seacreature_movement/water_submerge_med",
}

local function OnEnterMood(inst)
  if inst.components.beard and inst.components.beard.bits > 0 then
    inst.AnimState:SetBuild("ox_heat_build")
    inst.AnimState:SetBank("ox")
    inst:AddTag("scarytoprey")
  end
end

local function OnLeaveMood(inst)
  if inst.components.beard and inst.components.beard.bits > 0 then
    inst.AnimState:SetBuild("ox_build")
    inst.AnimState:SetBank("ox")
    inst:RemoveTag("scarytoprey")
  end
end

local function Retarget(inst)
	local herd = inst.components.herdmember and inst.components.herdmember:GetHerd()
	if herd and herd.components.mood and herd.components.mood:IsInMood() then
		return FindEntity(
                inst,
                TUNING.OX_TARGET_DIST,
                function(guy)
                    return inst.components.combat:CanTarget(guy)
                        and (guy.components.rider == nil
                            or guy.components.rider:GetMount() == nil
                            or not guy.components.rider:GetMount():HasTag("beefalo"))
                end,
                { "_combat" }, --See entityreplica.lua (re: "_combat" tag)
                { "ox", "wall", "aquatic", "INLIMBO" } --according to SW, ox never attack aquatic life?
            )
	end
end

local function KeepTarget(inst, target)
	local herd = inst.components.herdmember and inst.components.herdmember:GetHerd()
	return herd and herd.components.mood and herd.components.mood:IsInMood()
		or inst:IsNear(herd, TUNING.OX_CHASE_DIST)
end

local function OnNewTarget(inst, data)
	if data and data.target and data.target == inst.components.follower.leader then
		inst.components.follower:SetLeader(nil)
	end
end

local function OnAttacked(inst, data)
  inst.components.combat:SetTarget(data.attacker)
  inst.components.combat:ShareTarget(data.attacker, 30,function(dude)
      return dude:HasTag("ox") and not dude:HasTag("player") and not dude.components.health:IsDead()
    end, 5)
end

local function GetStatus(inst)
	return (inst.components.follower.leader ~= nil and "FOLLOWER")
		or (inst.components.beard ~= nil and inst.components.beard.bits == 0 and "NAKED")
		or (inst.components.domesticatable ~= nil and
			inst.components.domesticatable:IsDomesticated() and
			(inst.tendency == TENDENCY.DEFAULT and "DOMESTICATED" or inst.tendency))
		or nil
end

local function OnWaterChange(inst, onwater)
  if onwater then
    inst.sg:GoToState("submerge")
  else
    inst.sg:GoToState("emerge")
  end
end

local function OnPooped(inst, poop)
  local heading_angle = -(inst.Transform:GetRotation()) + 180

  local pos = Vector3(inst.Transform:GetWorldPosition())
  pos.x = pos.x + (math.cos(heading_angle*DEGREES))
  pos.y = pos.y + 0.9
  pos.z = pos.z + (math.sin(heading_angle*DEGREES))
  poop.Transform:SetPosition(pos.x, pos.y, pos.z)

  if poop.components.inventoryitem then 
    poop.components.inventoryitem:SetLanded(false, true)
  end
end

local function OnEntityWake(inst)
  inst.components.tiletracker:Start()
end

local function OnEntitySleep(inst)
  inst.components.tiletracker:Stop()
end

local function CustomOnHaunt(inst)
	inst.components.periodicspawner:TrySpawn()
	return true
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()
	
	MakeAmphibiousCharacterPhysics(inst, 100, .8)
	
    inst.DynamicShadow:SetSize(6, 2)
	inst.Transform:SetSixFaced()

	inst.AnimState:SetBank("ox")
	inst.AnimState:SetBuild("ox_build")
	inst.AnimState:PlayAnimation("idle_loop", true)

	inst:AddTag("ox")
	inst:AddTag("animal")
	inst:AddTag("largecreature")
	--herdmember (from herdmember component) added to pristine state for optimization
	inst:AddTag("herdmember")
	
	inst.sounds = sounds
	inst.walksound = sounds.walk_land
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end

  inst:AddComponent("eater")
  inst.components.eater:SetVegetarian()

  inst:AddComponent("combat")
  inst.components.combat.hiteffectsymbol = "beefalo_body"
  inst.components.combat:SetDefaultDamage(TUNING.OX_DAMAGE)
  inst.components.combat:SetRetargetFunction(1, Retarget)
  inst.components.combat:SetKeepTargetFunction(KeepTarget)

  inst:AddComponent("health")
  inst.components.health:SetMaxHealth(TUNING.OX_HEALTH)

  inst:AddComponent("lootdropper")
  inst.components.lootdropper:SetChanceLootTable('ox')    

  inst:AddComponent("inspectable")
  inst.components.inspectable.getstatus = GetStatus

  inst:AddComponent("knownlocations")
  inst:AddComponent("herdmember")
  inst.components.herdmember.herdprefab = "oxherd"

  -- inst:ListenForEvent("entermood", OnEnterMood)
  -- inst:ListenForEvent("leavemood", OnLeaveMood)

  inst:AddComponent("leader")
  inst:AddComponent("follower")
  inst.components.follower.maxfollowtime = TUNING.OX_FOLLOW_TIME
  inst.components.follower.canaccepttarget = false
  inst:ListenForEvent("newcombattarget", OnNewTarget)
  inst:ListenForEvent("attacked", OnAttacked)

  inst:AddComponent("periodicspawner")
  inst.components.periodicspawner:SetPrefab("poop")
  inst.components.periodicspawner:SetRandomTimes(TUNING.OX_POOP_PERIOD_MIN, TUNING.OX_POOP_PERIOD_MAX)
  inst.components.periodicspawner:SetDensityInRange(20, 2)
  inst.components.periodicspawner:SetMinimumSpacing(8)
  inst.components.periodicspawner:SetOnSpawnFn(OnPooped)
  inst.components.periodicspawner:Start()

  MakeLargeBurnableCharacter(inst, "swap_fire")
  MakeLargeFreezableCharacter(inst, "beefalo_body")

  inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
  inst.components.locomotor.walkspeed = TUNING.OX_WALK_SPEED
  inst.components.locomotor.runspeed = TUNING.OX_RUN_SPEED

  inst:AddComponent("sleeper")
  inst.components.sleeper:SetResistance(3)

  inst:AddComponent("tiletracker")
  inst.components.tiletracker:SetOnWaterChangeFn(OnWaterChange)

	MakeHauntablePanic(inst)
	AddHauntableCustomReaction(inst, CustomOnHaunt, true, false, true)

  inst:SetBrain(brain)
  inst:SetStateGraph("SGox")

  inst.OnEntityWake = OnEntityWake
  inst.OnEntitySleep = OnEntitySleep

  return inst
end

return Prefab( "ox", fn, assets, prefabs) 
