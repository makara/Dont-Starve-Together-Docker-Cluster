if not IA_CONFIG.allowprimeapebarrel then return end --public DEBUG option

require "prefabutil"
-- require "recipes"

local assets =
{
  Asset("ANIM", "anim/monkey_barrel_tropical.zip"),
  Asset("SOUND", "sound/monkey.fsb"),
}

local prefabs =
{
  "primeape",
  "poop",
  "cave_banana",
  "collapse_small",
}

SetSharedLootTable( 'primeapebarrel',
{
    {'poop',        1.0},
    {'poop',        1.0},
    {'cave_banana', 1.0},
    {'cave_banana', 1.0},
    {'trinket_4',   .01},
})

local function shake(inst)
    inst.AnimState:PlayAnimation(math.random() > .5 and "move1" or "move2")
	inst.AnimState:PushAnimation("idle")
	inst.SoundEmitter:PlaySound("dontstarve/creatures/monkey/barrel_rattle")
end

local function enqueueShake(inst)
    if inst.shake ~= nil then
        inst.shake:Cancel()
    end
    inst.shake = inst:DoPeriodicTask(GetRandomWithVariance(10, 3), shake)
end

local function onhammered(inst)
    if inst.shake ~= nil then
		inst.shake:Cancel()
		inst.shake = nil
	end
	inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
	inst:Remove()
end

local function onhit(inst, worker)
    if inst.components.childspawner ~= nil then
        inst.components.childspawner:ReleaseAllChildren(worker)
    end
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle", false)

    enqueueShake(inst)
end

local function pushsafetospawn(inst)
    inst.safetospawntask = nil
    inst:PushEvent("safetospawn")
end

local function ReturnChildren(inst)
    for k, child in pairs(inst.components.childspawner.childrenoutside) do
        if child.components.homeseeker ~= nil then
            child.components.homeseeker:GoHome()
        end
        child:PushEvent("gohome")
    end

	if inst.safetospawntask then
		inst.safetospawntask:Cancel()
	end
	inst.safetospawntask = inst:DoTaskInTime(math.random(60, 120), pushsafetospawn)
end

local function OnIgniteFn(inst)
    inst.AnimState:PlayAnimation("shake", true)

    if inst.shake ~= nil then
        inst.shake:Cancel()
        inst.shake = nil
    end

    if inst.components.childspawner ~= nil then
        inst.components.childspawner:ReleaseAllChildren()
    end
end

local function ongohome(inst, child)
    if child.components.inventory ~= nil then
        child.components.inventory:DropEverything(false, true)
    end
end

local function onsafetospawn(inst)
    if inst.components.childspawner ~= nil then
        inst.components.childspawner:StartSpawning()
    end
end

local function OnHaunt(inst)
    if inst.components.childspawner == nil or
        not inst.components.childspawner:CanSpawn() or
        math.random() > TUNING.HAUNT_CHANCE_HALF then
        return false
    end

    local target =
        FindEntity(inst,
            25,
            nil,
            { "_combat" },
            { "playerghost", "INLIMBO" },
            { "character", "monster" }
        )

    if target ~= nil then
        onhit(inst, target)
        return true
    end

    return false
end

local function onbuilt(inst)
  inst.AnimState:PlayAnimation("place")
  inst.AnimState:PushAnimation("idle")
  inst.SoundEmitter:PlaySound("ia/common/monkey_barrel_place")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("prime_ape.tex")

    MakeObstaclePhysics(inst, 1)

	inst.AnimState:SetBank("barrel_tropical")
	inst.AnimState:SetBuild("monkey_barrel_tropical")
	inst.AnimState:PlayAnimation("idle", true)

	-- MakeSnowCoveredPristine(inst)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent( "childspawner" )
	inst.components.childspawner:SetRegenPeriod(120)
	inst.components.childspawner:SetSpawnPeriod(30)
	inst.components.childspawner:SetMaxChildren(math.random(3, 4))
	inst.components.childspawner:StartRegen()
	inst.components.childspawner.childname = "primeape"
	inst.components.childspawner:StartSpawning()
	inst.components.childspawner.ongohome = ongohome
	inst.components.childspawner:SetSpawnedFn(shake)

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable('primeapebarrel')

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)

    local function ondanger()
        if inst.components.childspawner ~= nil then
            inst.components.childspawner:StopSpawning()
            ReturnChildren(inst) 
        end
    end
	
    --Monkeys all return on a quake start
    inst:ListenForEvent("warnquake", ondanger, TheWorld)

    --Monkeys all return on danger
    inst:ListenForEvent("primeapedanger", ondanger)

    inst:ListenForEvent("safetospawn", onsafetospawn)

	inst:ListenForEvent("onbuilt", onbuilt)

    inst:AddComponent("inspectable")

    MakeLargeBurnable(inst)
	MakeLargePropagator(inst)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_SMALL)
    inst.components.hauntable:SetOnHauntFn(OnHaunt)

    enqueueShake(inst)

	return inst
end

return Prefab( "primeapebarrel", fn, assets, prefabs),
MakePlacer("primeapebarrel_placer", "barrel_tropical", "monkey_barrel_tropical", "idle")
