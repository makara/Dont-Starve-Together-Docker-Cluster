local assets = {
    Asset("ANIM", "anim/spider_tropical_build.zip")
}

local prefabs = {
    "spider_warrior"
}

local function fn()
    local inst = Prefabs["spider_warrior"].fn()
    
    inst.AnimState:SetBuild("spider_tropical_build")

    inst.realprefab = "tropical_spider_warrior"

    inst:SetPrefabName("spider_warrior")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.combat.poisonous = true

    inst.components.lootdropper:AddRandomLoot("venomgland", .5)

    return inst
end

return Prefab("tropical_spider_warrior", fn, assets, prefabs)