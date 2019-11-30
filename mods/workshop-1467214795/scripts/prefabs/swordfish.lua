local assets =
{
  Asset("ANIM", "anim/fish_dogfish.zip"),
  Asset("ANIM", "anim/fish_swordfish01.zip"),
  Asset("ANIM", "anim/fish_med01.zip"),
}

local invassets=
{
  Asset("ANIM", "anim/fish_swordfish.zip"),
}

local prefabs =
{
  "swordfish_dead"
}


local brain = require "brains/swordfishbrain"


local function retargetfn(inst)
  local dist = TUNING.SWORDFISH_TARGET_DIST
  local notags = {"FX", "NOCLICK","INLIMBO", "swordfish"}
  local yestags = {"aquatic"}
  return FindEntity(inst, dist, function(guy) 
      local shouldtarget =  inst.components.combat:CanTarget(guy)
      return shouldtarget
    end, yestags, notags)
end

local function KeepTarget(inst, target)
  local shouldkeep = inst.components.combat:CanTarget(target)
  local onwater = target:HasTag("aquatic")
  -- local onboat = target.components.sailor and target.components.sailor:IsSailing()
  return shouldkeep and onwater
end

local function SetLocoState(inst, state)
  --"above" or "below"
  inst.LocoState = string.lower(state)
end

local function IsLocoState(inst, state)
  return inst.LocoState == string.lower(state)
end

local function swordfishfn()

  local inst = CreateEntity()
  local trans = inst.entity:AddTransform()
  inst.entity:AddNetwork()
  --trans:SetFourFaced()
  inst.entity:AddSoundEmitter()
  inst.entity:AddAnimState()

  MakeCharacterPhysics(inst, 5, 1.25)
  inst.Physics:ClearCollisionMask()
  inst.Physics:CollidesWith(COLLISION.WORLD)

  inst:AddTag("aquatic")
  inst:AddTag("swordfish")
  inst:AddTag("scarytoprey")

  inst.entity:SetPristine()

  if not TheWorld.ismastersim then
    return inst
  end

  inst:AddComponent("locomotor")
  inst.components.locomotor.walkspeed = TUNING.SWORDFISH_WALK_SPEED
  inst.components.locomotor.runspeed = TUNING.SWORDFISH_RUN_SPEED


  inst.AnimState:SetBank("swordfish")
  inst.AnimState:SetBuild("fish_swordfish")  
  inst.AnimState:PlayAnimation("shadow", true)
  inst.AnimState:SetRayTestOnBB(true)
  inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)

  inst.AnimState:SetLayer(LAYER_BACKGROUND)
  inst.AnimState:SetSortOrder(3)

  inst:AddComponent("inspectable")
  inst.no_wet_prefix = true

  inst:AddComponent("knownlocations")

  inst:AddComponent("combat")
  inst.components.combat:SetDefaultDamage(TUNING.SWORDFISH_DAMAGE)
  inst.components.combat:SetAttackPeriod(TUNING.SWORDFISH_ATTACK_PERIOD)
  inst.components.combat:SetRetargetFunction(3, retargetfn)
  inst.components.combat:SetKeepTargetFunction(KeepTarget)
  --inst.components.combat.hiteffectsymbol = "chest"
  inst:AddComponent("health")
  inst.components.health:SetMaxHealth(TUNING.SWORDFISH_HEALTH)

  inst:AddComponent("eater")
  inst:AddComponent("lootdropper")
  inst.components.lootdropper:SetLoot({"swordfish_dead"})

  inst:AddComponent("sleeper")
  inst.components.sleeper.onlysleepsfromitems = true 
  MakeMediumFreezableCharacter(inst, "swordfish_body")

  SetLocoState(inst, "below")
  inst.SetLocoState = SetLocoState
  inst.IsLocoState = IsLocoState

  inst:SetStateGraph("SGswordfish")

  inst:SetBrain(brain)

  return inst
end

return Prefab("swordfish", swordfishfn, assets, prefabs)
