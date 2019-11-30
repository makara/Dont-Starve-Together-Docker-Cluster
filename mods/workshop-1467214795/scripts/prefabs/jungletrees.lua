local assets =
{
  Asset("ANIM", "anim/tree_jungle_build.zip"),
  Asset("ANIM", "anim/tree_jungle_normal.zip"),
  Asset("ANIM", "anim/tree_jungle_short.zip"),
  Asset("ANIM", "anim/tree_jungle_tall.zip"),
  Asset("ANIM", "anim/cavein_dust_fx.zip"),
  Asset("SOUND", "sound/forest.fsb"),
}

local prefabs =
{
  "log",
  "jungletreeseed",
  "charcoal",
  -- "treeguard",
  "jungle_chop",
  "jungle_fall",
  "snake",
  "snake_poison",
  "cave_banana",
  "bird_egg",
}

local builds =
{
  normal = {
    file="tree_jungle_build",
    prefab_name="jungletree",
    regrowth_product="jungletree_short",
    regrowth_tuning=TUNING.EVERGREEN_REGROWTH,
    normal_loot = {"log", "log", "jungletreeseed"},
    short_loot = {"log"},
    tall_loot = {"log", "log", "log", "jungletreeseed", "jungletreeseed"},

    leif="leif",
  },
  --[[
	sparse = {
		file="evergreen_new_2",
		prefab_name="evergreen_sparse",
		normal_loot = {"log","log"},
		short_loot = {"log"},
		tall_loot = {"log", "log","log"},
		drop_pinecones=false,
		leif="leif_sparse",
	},
	]]
}

local function makeanims(stage)
  return {
    idle="idle_"..stage,
    sway1="sway1_loop_"..stage,
    sway2="sway2_loop_"..stage,
    chop="chop_"..stage,
    fallleft="fallleft_"..stage,
    fallright="fallright_"..stage,
    stump="stump_"..stage,
    burning="burning_loop_"..stage,
    burnt="burnt_"..stage,
    chop_burnt="chop_burnt_"..stage,
    idle_chop_burnt="idle_chop_burnt_"..stage,
    blown1="blown_loop_"..stage.."1",
    blown2="blown_loop_"..stage.."2",
    blown_pre="blown_pre_"..stage,
    blown_pst="blown_pst_"..stage
  }
end

local short_anims = makeanims("short")
local tall_anims = makeanims("tall")
local normal_anims = makeanims("normal")
local old_anims =
{
  idle="idle_old",
  sway1="idle_old",
  sway2="idle_old",
  chop="chop_old",
  fallleft="chop_old",
  fallright="chop_old",
  stump="stump_old",
  burning="idle_olds",
  burnt="burnt_tall",
  chop_burnt="chop_burnt_tall",
  idle_chop_burnt="idle_chop_burnt_tall",
  blown="blown_loop",
  blown_pre="blown_pre",
  blown_pst="blown_pst"
}

local function dig_up_stump(inst, chopper)
  inst.components.lootdropper:SpawnLootPrefab("log")
  inst:Remove()
end

local function chop_down_burnt_tree(inst, chopper)
  inst:RemoveComponent("workable")
  inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")
  inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
  inst.AnimState:PlayAnimation(inst.anims.chop_burnt)
  RemovePhysicsColliders(inst)
  inst:ListenForEvent("animover", function() inst:Remove() end)
  inst.components.lootdropper:SpawnLootPrefab("charcoal")
  inst.components.lootdropper:DropLoot()
  if inst.pineconetask then
    inst.pineconetask:Cancel()
    inst.pineconetask = nil
  end
end

local function GetBuild(inst)
  local build = builds[inst.build]
  if build == nil then
    return builds["normal"]
  end
  return build
end

local burnt_highlight_override = {.5,.5,.5}
local function OnBurnt(inst, imm)

  local function changes()
    if inst.components.burnable then
      inst.components.burnable:Extinguish()
    end
    inst:RemoveComponent("burnable")
    inst:RemoveComponent("propagator")
    inst:RemoveComponent("growable")
    inst:RemoveComponent("blowinwindgust")
    inst:RemoveComponent("hauntable")
    inst:RemoveTag("shelter")
    inst:RemoveTag("fire")
    inst:RemoveTag("gustable")

    MakeHauntableWork(inst)

    inst.components.lootdropper:SetLoot({})

    if inst.components.workable then
      inst.components.workable:SetWorkLeft(1)
      inst.components.workable:SetOnWorkCallback(nil)
      inst.components.workable:SetOnFinishCallback(chop_down_burnt_tree)
    end
  end

  if imm then
    changes()
  else
    inst:DoTaskInTime( 0.5, changes)
  end
  inst.AnimState:PlayAnimation(inst.anims.burnt, true)
  inst:AddTag("burnt")

	inst.MiniMapEntity:SetIcon("jungletree_burnt.tex")

  inst.highlight_override = burnt_highlight_override
end

local function PushSway(inst)
  if math.random() > .5 then
    inst.AnimState:PushAnimation(inst.anims.sway1, true)
  else
    inst.AnimState:PushAnimation(inst.anims.sway2, true)
  end
end

local function Sway(inst)
  if math.random() > .5 then
    inst.AnimState:PlayAnimation(inst.anims.sway1, true)
  else
    inst.AnimState:PlayAnimation(inst.anims.sway2, true)
  end
  inst.AnimState:SetTime(math.random()*2)
end

local function SetShort(inst)
  inst.anims = short_anims

  if inst.components.workable then
    inst.components.workable:SetWorkLeft(TUNING.JUNGLETREE_CHOPS_SMALL)
  end

  inst.components.lootdropper:SetLoot(GetBuild(inst).short_loot)

  if math.random() < 0.5 then
    for i = 1, TUNING.SNAKE_JUNGLETREE_AMOUNT_SMALL do
      if math.random() < 0.5 and TheWorld.state.cycles >= TUNING.SNAKE_POISON_START_DAY then
        inst.components.lootdropper:AddChanceLoot("snake_poison", TUNING.SNAKE_JUNGLETREE_POISON_CHANCE)
      else
        inst.components.lootdropper:AddChanceLoot("snake", TUNING.SNAKE_JUNGLETREE_CHANCE)
      end
    end
  end

  Sway(inst)
end

local function GrowShort(inst)
  inst.AnimState:PlayAnimation("grow_tall_to_short")
  inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrowFromWilt")
  PushSway(inst)
end

local function SetNormal(inst)
  inst.anims = normal_anims

  if inst.components.workable then
    inst.components.workable:SetWorkLeft(TUNING.JUNGLETREE_CHOPS_NORMAL)
  end

  inst.components.lootdropper:SetLoot(GetBuild(inst).normal_loot)

  if math.random() < 0.5 then
    for i = 1, TUNING.SNAKE_JUNGLETREE_AMOUNT_MED do
      if math.random() < 0.5 and TheWorld.state.cycles >= TUNING.SNAKE_POISON_START_DAY then
        inst.components.lootdropper:AddChanceLoot("snake_poison", TUNING.SNAKE_JUNGLETREE_POISON_CHANCE)
      else
        inst.components.lootdropper:AddChanceLoot("snake", TUNING.SNAKE_JUNGLETREE_CHANCE)
      end
    end
  else
    inst.components.lootdropper:AddChanceLoot("bird_egg", 1.0)
  end

  Sway(inst)
end

local function GrowNormal(inst)
  inst.AnimState:PlayAnimation("grow_short_to_normal")
  inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
  PushSway(inst)
end

local function SetTall(inst)
  inst.anims = tall_anims
  if inst.components.workable then
    inst.components.workable:SetWorkLeft(TUNING.JUNGLETREE_CHOPS_TALL)
  end
  inst.components.lootdropper:SetLoot(GetBuild(inst).tall_loot)

  if math.random() < 0.5 then
    for i = 1, TUNING.SNAKE_JUNGLETREE_AMOUNT_TALL do
      if math.random() < 0.5 and TheWorld.state.cycles >= TUNING.SNAKE_POISON_START_DAY then
        inst.components.lootdropper:AddChanceLoot("snake_poison", TUNING.SNAKE_JUNGLETREE_POISON_CHANCE)
      else
        inst.components.lootdropper:AddChanceLoot("snake", TUNING.SNAKE_JUNGLETREE_CHANCE)
      end
    end
  else
    if math.random() < 0.5 then
      inst.components.lootdropper:AddChanceLoot("bird_egg", 1.0)
    else
      inst.components.lootdropper:AddChanceLoot("cave_banana", 1.0)
    end
  end

  Sway(inst)
end

local function GrowTall(inst)
  inst.AnimState:PlayAnimation("grow_normal_to_tall")
  inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
  PushSway(inst)
end

local function inspect_tree(inst)
  if inst:HasTag("burnt") then
    return "BURNT"
  elseif inst:HasTag("stump") then
    return "CHOPPED"
  end
end

local growth_stages =
{
  {name="short", time = function(inst) return GetRandomWithVariance(TUNING.JUNGLETREE_GROW_TIME[1].base, TUNING.JUNGLETREE_GROW_TIME[1].random) end, fn = function(inst) SetShort(inst) end,  growfn = function(inst) GrowShort(inst) end , leifscale=.7 },
  {name="normal", time = function(inst) return GetRandomWithVariance(TUNING.JUNGLETREE_GROW_TIME[2].base, TUNING.JUNGLETREE_GROW_TIME[2].random) end, fn = function(inst) SetNormal(inst) end, growfn = function(inst) GrowNormal(inst) end, leifscale=1 },
  {name="tall", time = function(inst) return GetRandomWithVariance(TUNING.JUNGLETREE_GROW_TIME[3].base, TUNING.JUNGLETREE_GROW_TIME[3].random) end, fn = function(inst) SetTall(inst) end, growfn = function(inst) GrowTall(inst) end, leifscale=1.25 },
  --{name="old", time = function(inst) return GetRandomWithVariance(TUNING.EVERGREEN_GROW_TIME[4].base, TUNING.EVERGREEN_GROW_TIME[4].random) end, fn = function(inst) SetOld(inst) end, growfn = function(inst) GrowOld(inst) end },
}


local function chop_tree(inst, chopper, chops)

  if chopper and chopper:HasTag("beaver") then
    inst.SoundEmitter:PlaySound("dontstarve/characters/woodie/beaver_chop_tree")
  else
    inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
  end

  local fx = SpawnPrefab("jungle_chop")
  local x, y, z= inst.Transform:GetWorldPosition()
  fx.Transform:SetPosition(x,y + 2 + math.random()*2,z)

  inst.AnimState:PlayAnimation(inst.anims.chop)
  inst.AnimState:PushAnimation(inst.anims.sway1, true)

  --tell any nearby leifs to wake up
  local pt = Vector3(inst.Transform:GetWorldPosition())
  local ents = TheSim:FindEntities(pt.x,pt.y,pt.z, TUNING.PALMTREEGUARD_REAWAKEN_RADIUS, {"treeguard"})
  for k,v in pairs(ents) do
    if v.components.sleeper and v.components.sleeper:IsAsleep() then
      v:DoTaskInTime(math.random(), function() v.components.sleeper:WakeUp() end)
    end
    v.components.combat:SuggestTarget(chopper)
  end
end

local function chop_down_tree(inst, chopper)
  inst:RemoveComponent("burnable")
  MakeSmallBurnable(inst)
  inst:RemoveComponent("propagator")
  MakeSmallPropagator(inst)
  inst:RemoveComponent("workable")
  inst:RemoveTag("shelter")
  inst:RemoveComponent("blowinwindgust")
  inst:RemoveTag("gustable")
  inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")
  local pt = Vector3(inst.Transform:GetWorldPosition())
  local hispos = Vector3(chopper.Transform:GetWorldPosition())

  local he_right = (hispos - pt):Dot(TheCamera:GetRightVec()) > 0

  if he_right then
    inst.AnimState:PlayAnimation(inst.anims.fallleft)
    inst.components.lootdropper:DropLoot(pt - TheCamera:GetRightVec())
  else
    inst.AnimState:PlayAnimation(inst.anims.fallright)
    inst.components.lootdropper:DropLoot(pt + TheCamera:GetRightVec())
  end

  local fx = SpawnPrefab("jungle_fall")
  local x, y, z= inst.Transform:GetWorldPosition()
  fx.Transform:SetPosition(x,y + 2 + math.random()*2,z)

  -- make snakes attack
  local snakes = TheSim:FindEntities(x,y,z, 2, {"snake"})
  for k, v in pairs(snakes) do
    if v.components.combat then
      v.components.combat:SetTarget(chopper)
    end
  end

  inst:DoTaskInTime(.4, function()
      ShakeAllCameras(CAMERASHAKE.FULL, .25, .03,
        inst.components.growable ~= nil and
        inst.components.growable.stage > 2 and .5 or .25,
        inst, 6)
    end)

  inst:RemoveComponent("hauntable")
  MakeHauntableIgnite(inst)

  RemovePhysicsColliders(inst)
  inst.AnimState:PushAnimation(inst.anims.stump)

  inst:AddComponent("workable")
  inst.components.workable:SetWorkAction(ACTIONS.DIG)
  inst.components.workable:SetOnFinishCallback(dig_up_stump)
  inst.components.workable:SetWorkLeft(1)

  inst:AddTag("stump")
  if inst.components.growable then
    inst.components.growable:StopGrowing()
  end

    inst.MiniMapEntity:SetIcon("jungletree_stump.tex")

  inst:AddTag("NOCLICK")
  inst:DoTaskInTime(2, function() inst:RemoveTag("NOCLICK") end)
end

local function chop_down_tree_leif(inst, chopper)
  chop_down_tree(inst, chopper)
end

local function tree_burnt(inst)
  OnBurnt(inst)
  inst.pineconetask = inst:DoTaskInTime(10,
    function()
      local pt = Vector3(inst.Transform:GetWorldPosition())
      if math.random(0, 1) == 1 then
        pt = pt + TheCamera:GetRightVec()
      else
        pt = pt - TheCamera:GetRightVec()
      end
      inst.components.lootdropper:DropLoot(pt)
      inst.pineconetask = nil
    end)
end

local function onhauntjungletree(inst, haunter)
  -- if math.random() <= TUNING.HAUNT_CHANCE_SUPERRARE and
  -- find_leif_spawn_target(inst) and
  -- not (inst:HasTag("burnt") or inst:HasTag("stump")) then

    -- inst.leifscale = GetGrowthStages(inst)[inst.components.growable.stage].leifscale or 1
    -- spawn_leif(inst)

    -- inst.components.hauntable.hauntvalue = TUNING.HAUNT_HUGE
    -- inst.components.hauntable.cooldown_on_successful_haunt = false
    -- return true
  -- end
  if inst.components.workable ~= nil and math.random() <= TUNING.HAUNT_CHANCE_OFTEN then
        inst.components.workable:WorkedBy(haunter, 1)
        inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL
        return true
    end
    return false
end

local function handler_growfromseed (inst)
  inst.components.growable:SetStage(1)
  inst.AnimState:PlayAnimation("grow_seed_to_short")
  inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
  PushSway(inst)
end

local function onsave(inst, data)
  if inst:HasTag("burnt") or inst:HasTag("fire") then
    data.burnt = true
  end

  if inst:HasTag("stump") then
    data.stump = true
  end

  if inst.build ~= "normal" then
    data.build = inst.build
  end
end

local function onload(inst, data)
  if data then
    if not data.build or builds[data.build] == nil then
      inst.build = "normal"
    else
      inst.build = data.build
    end

    if data.burnt then
      inst:AddTag("fire") -- Add the fire tag here: OnEntityWake will handle it actually doing burnt logic
    elseif data.stump then
      inst:RemoveComponent("burnable")
      MakeSmallBurnable(inst)
      inst:RemoveComponent("workable")
      inst:RemoveComponent("propagator")
      MakeSmallPropagator(inst)
      inst:RemoveComponent("growable")
      inst:RemoveComponent("hauntable")
      MakeHauntableIgnite(inst)
      RemovePhysicsColliders(inst)
      inst.AnimState:PlayAnimation(inst.anims.stump)
      inst:AddTag("stump")
      inst:RemoveTag("shelter")
      inst:RemoveTag("gustable")
      inst:RemoveComponent("blowinwindgust")
      inst:AddComponent("workable")
      inst.components.workable:SetWorkAction(ACTIONS.DIG)
      inst.components.workable:SetOnFinishCallback(dig_up_stump)
      inst.components.workable:SetWorkLeft(1)
    end
  end
end

local function OnEntitySleep(inst)
  local fire = false
  if inst:HasTag("fire") then
    fire = true
  end
  inst:RemoveComponent("burnable")
  inst:RemoveComponent("propagator")
  inst:RemoveComponent("inspectable")
  if fire then
    inst:AddTag("fire")
  end
end

local function OnEntityWake(inst)

  if not inst:HasTag("burnt") and not inst:HasTag("fire") then
    if not inst.components.burnable then
      if inst:HasTag("stump") then
        MakeSmallBurnable(inst)
      else
        MakeLargeBurnable(inst)
        inst.components.burnable:SetFXLevel(5)
        inst.components.burnable:SetOnBurntFn(tree_burnt)
      end
    end

    if not inst.components.propagator then
      if inst:HasTag("stump") then
        MakeSmallPropagator(inst)
      else
        MakeLargePropagator(inst)
      end
    end
  elseif not inst:HasTag("burnt") and inst:HasTag("fire") then
    OnBurnt(inst, true)
  end

  if not inst.components.inspectable then
    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = inspect_tree
  end
end


local function makefn(build, stage, data)

  local function fn()
    local l_stage = stage
    if l_stage == 0 then
      l_stage = math.random(1,3)
    end

    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    inst.entity:AddAnimState()

    local sound = inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .25)

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("jungletree.tex")

    minimap:SetPriority(-1)

    inst:AddTag("tree")
	inst:AddTag("plant")
    inst:AddTag("workable")
    inst:AddTag("shelter")
    inst:AddTag("gustable")

    inst.build = build
    inst.AnimState:SetBuild(GetBuild(inst).file)
    inst.AnimState:SetBank("jungletree")

    inst:SetPrefabName( GetBuild(inst).prefab_name )
    inst:AddTag(GetBuild(inst).prefab_name)

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
      return inst
    end

    local color = 0.5 + math.random() * 0.5
    inst.AnimState:SetMultColour(color, color, color, 1)

    MakeLargeBurnable(inst)
    inst.components.burnable:SetFXLevel(5)
    inst.components.burnable:SetOnBurntFn(tree_burnt)

    MakeLargePropagator(inst)

    -------------------
    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = inspect_tree
    -------------------
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetOnWorkCallback(chop_tree)
    inst.components.workable:SetOnFinishCallback(chop_down_tree_leif)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetOnHauntFn(onhauntjungletree)

    -------------------
    inst:AddComponent("lootdropper")
    ---------------------
    inst:AddComponent("growable")
    inst.components.growable.stages = growth_stages
    inst.components.growable:SetStage(l_stage)
    inst.components.growable.loopstages = true
    inst.components.growable.springgrowth = true
    inst.components.growable:StartGrowing()

    inst.growfromseed = handler_growfromseed

--    inst:AddComponent("plantregrowth")
--    inst.components.plantregrowth:SetRegrowthRate(GetBuild(inst).regrowth_tuning.OFFSPRING_TIME)
--    inst.components.plantregrowth:SetProduct(GetBuild(inst).regrowth_product)
--    inst.components.plantregrowth:SetSearchTag(GetBuild(inst).prefab_name)

	MakeTreeBlowInWindGust(inst, TUNING.JUNGLETREE_WINDBLOWN_SPEED, TUNING.JUNGLETREE_WINDBLOWN_FALL_CHANCE)
	inst.PushSway = PushSway

    ---------------------
    --PushSway(inst)
    inst.AnimState:SetTime(math.random()*2)

    ---------------------

    inst.OnSave = onsave
    inst.OnLoad = onload

    MakeSnowCovered(inst, .01)
    ---------------------

    if data =="burnt"  then
      OnBurnt(inst)
    end

    if data =="stump"  then
      inst:RemoveComponent("burnable")
      MakeSmallBurnable(inst)
      inst:RemoveComponent("workable")
      inst:RemoveComponent("propagator")
      MakeSmallPropagator(inst)
      inst:RemoveComponent("growable")
      inst:RemoveComponent("blowinwindgust")
      inst:RemoveTag("gustable")
      RemovePhysicsColliders(inst)
      inst.AnimState:PlayAnimation(inst.anims.stump)
      inst:AddTag("stump")
      inst:AddComponent("workable")
      inst.components.workable:SetWorkAction(ACTIONS.DIG)
      inst.components.workable:SetOnFinishCallback(dig_up_stump)
      inst.components.workable:SetWorkLeft(1)
    end

    inst.OnEntitySleep = OnEntitySleep
    inst.OnEntityWake = OnEntityWake

    return inst
  end
  return fn
end

local function tree(name, build, stage, data)
  return Prefab(name, makefn(build, stage, data), assets, prefabs)
end

return tree("jungletree", "normal", 0),
tree("jungletree_normal", "normal", 2),
tree("jungletree_tall", "normal", 3),
tree("jungletree_short", "normal", 1),
tree("jungletree_burnt", "normal", 0, "burnt"),
tree("jungletree_stump", "normal", 0, "stump")
