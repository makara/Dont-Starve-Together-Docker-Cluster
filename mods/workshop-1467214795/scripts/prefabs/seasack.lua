local assets = {
    Asset("ANIM", "anim/swap_seasack.zip"),
    Asset("ANIM", "anim/ui_icepack_2x3.zip")
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "swap_seasack", "backpack")
    owner.AnimState:OverrideSymbol("swap_body", "swap_seasack", "swap_body")

    if inst.components.container ~= nil then
        inst.components.container:Open(owner)
    end
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    owner.AnimState:ClearOverrideSymbol("backpack")

    if inst.components.container ~= nil then
        inst.components.container:Close(owner)
    end
end

local function onburnt(inst)
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
        inst.components.container:Close()
    end

    SpawnPrefab("ash").Transform:SetPosition(inst.Transform:GetWorldPosition())

    inst:Remove()
end

local function onignite(inst)
    if inst.components.container ~= nil then
        inst.components.container.canbeopened = false
    end
end

local function onextinguish(inst)
    if inst.components.container ~= nil then
        inst.components.container.canbeopened = true
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("seasack")
    inst.AnimState:SetBuild("swap_seasack")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("backpack")
    
    inst:AddTag("fridge")
    inst:AddTag("nocool")

    inst.MiniMapEntity:SetIcon("icepack.tex")

    inst.foleysound = "dontstarve/movement/foley/backpack"

	MakeInventoryFloatable(inst)
	inst.components.floater:UpdateAnimations("idle_water", "anim")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    
    inst:AddComponent("inspectable")
    
    MakeInvItemIA(inst)
    inst.components.inventoryitem.cangoincontainer = false

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BACK
    
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("seasack")

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    inst.components.burnable:SetOnBurntFn(onburnt)
    inst.components.burnable:SetOnIgniteFn(onignite)
    inst.components.burnable:SetOnExtinguishFn(onextinguish)

    MakeHauntableLaunchAndDropFirstItem(inst)

    return inst
end

return Prefab("seasack", fn, assets)