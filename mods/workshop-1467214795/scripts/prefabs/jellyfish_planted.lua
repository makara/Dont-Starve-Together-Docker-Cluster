local assets = {
    Asset("Anim", "anim/jellyfish.zip")
}

local prefabs = {
    "jellyfish_dead"
}

local function onworked(inst, worker)
    --stupid DST change, explosives do a "work" check before an attack check, this is reversed in SW
    if not worker.components.explosive then
        if worker.components.inventory then
            local toGive = SpawnPrefab("jellyfish")
            worker.components.inventory:GiveItem(toGive, nil, inst:GetPosition())
            worker.SoundEmitter:PlaySound("ia/common/bugnet_inwater")
        end
        inst:Remove()
    end
end

local function onattacked(inst, data)
    if data.attacker.components.health then
        if (data.weapon == nil or (not (data.weapon.components.projectile) and not (data.weapon.components.weapon and data.weapon.components.weapon:CanRangedAttack()))) and
        (data.attacker:HasTag("player") and not data.attacker.components.inventory:IsInsulated()) then
            data.attacker.components.health:DoDelta(-TUNING.JELLYFISH_DAMAGE, nil, inst.prefab, nil, inst)
            data.attacker.sg:GoToState("electrocute")
        end
    end
end

local brain = require "brains/jellyfishbrain"
local function fn()
	local inst = CreateEntity()

    inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	inst.AnimState:SetBank("jellyfish")
	inst.AnimState:SetBuild("jellyfish")
    inst.AnimState:PlayAnimation("idle", true)

    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
	
    MakeCharacterPhysics(inst, 1, 0.5)
    inst.Transform:SetFourFaced()
    
    inst:AddTag("aquatic")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = TUNING.JELLYFISH_WALKSPEED

    inst:SetStateGraph("SGjellyfish")
    inst:SetBrain(brain)

    inst:AddComponent("combat")
    inst.components.combat:SetHurtSound("ia/creatures/jellyfish/hit")
    inst:ListenForEvent("attacked", onattacked)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.JELLYFISH_HEALTH)

    MakeMediumFreezableCharacter(inst, "jelly")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"jellyfish_dead"})

    inst:AddComponent("inspectable")
    inst:AddComponent("knownlocations")

    inst:AddComponent("sleeper")
    inst.components.sleeper.onlysleepsfromitems = true

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.NET)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(onworked)

    return inst
end

return Prefab("jellyfish_planted", fn, assets, prefabs)