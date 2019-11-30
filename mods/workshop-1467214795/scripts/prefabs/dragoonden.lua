require "prefabutil"

local assets = {
    Asset("ANIM", "anim/dragoon_den.zip"),
}

local prefabs = {
    "dragoon",
}

local function ongohome(inst, child)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle")
end

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
    inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle")
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle")
    inst.SoundEmitter:PlaySound("ia/common/dragoon_den_place")
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1.5)

    inst.MiniMapEntity:SetIcon("dragoonden.tex")

    inst.AnimState:SetBank("dragoon_den")
    inst.AnimState:SetBuild("dragoon_den")
    inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("structure")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(nil)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

--[[
    inst:AddComponent("childspawner")
    inst.components.childspawner:SetRegenPeriod(120)
    inst.components.childspawner:SetSpawnPeriod(30)
    inst.components.childspawner:SetMaxChildren(math.random(3,4))
    inst.components.childspawner:StartRegen()
    inst.components.childspawner.childname = "dragoon"
    inst.components.childspawner:StartSpawning()
    inst.components.childspawner.ongohome = ongohome
    ]]

    inst:AddComponent("inspectable")

    --inst:WatchWorldState("startdusk", function() inst.components.childspawner:StopSpawning() end)
    --inst:WatchWorldState("startday", function() inst.components.childspawner:StartSpawning() end)

    inst:ListenForEvent("onbuilt", onbuilt)

    return inst
end

return Prefab("dragoonden", fn, assets, prefabs),
        MakePlacer("dragoonden_placer", "dragoon_den", "dragoon_den", "idle")