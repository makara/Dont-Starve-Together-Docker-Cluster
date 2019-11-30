local assets = {
    Asset("ANIM", "anim/axe_obsidian.zip"),
    Asset("ANIM", "anim/swap_axe_obsidian.zip"),
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_axe_obsidian", "swap_axe")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("axe_obsidian")
    inst.AnimState:SetBuild("axe_obsidian")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")

	MakeInventoryFloatable(inst)
	inst.components.floater:UpdateAnimations("idle_water", "idle")

    MakeObsidianToolPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    MakeInvItemIA(inst)
    -----
    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP, TUNING.OBSIDIANTOOL_WORK)

    if TheNet:GetServerGameMode() ~= "quagmire" then
        -------
        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(TUNING.AXE_USES)
        inst.components.finiteuses:SetUses(TUNING.AXE_USES)
        inst.components.finiteuses:SetOnFinished(inst.Remove)
        inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 1 / TUNING.OBSIDIANTOOLFACTOR)

        -------
        inst:AddComponent("weapon")
        inst.components.weapon:SetDamage(TUNING.AXE_DAMAGE)
        inst.components.weapon.attackwear = 1 / TUNING.OBSIDIANTOOLFACTOR
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")

    inst.components.equippable:SetOnEquip(onequip)

    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0)

    MakeObsidianTool(inst, "axe")

    return inst
end

return Prefab("obsidianaxe", fn, assets)
