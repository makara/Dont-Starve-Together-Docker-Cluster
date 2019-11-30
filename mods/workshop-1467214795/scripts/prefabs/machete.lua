local assets = {
    machete = {
        Asset("ANIM", "anim/machete.zip"),
        Asset("ANIM", "anim/swap_machete.zip"),
    },
    machete_obsidian = {
        Asset("ANIM", "anim/machete_obsidian.zip"),
        Asset("ANIM", "anim/swap_machete_obsidian.zip"),
    },
    machete_golden = {
        Asset("ANIM", "anim/goldenmachete.zip"),
        Asset("ANIM", "anim/swap_goldenmachete.zip"),
    },
}

local function onfinished(inst)
    inst:Remove()
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_machete", "swap_machete")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function pristinefn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("machete")
    inst.AnimState:SetBuild("machete")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")

	MakeInventoryFloatable(inst)
	inst.components.floater:UpdateAnimations("idle_water", "idle")

	return inst
end

local function masterfn(inst)

    MakeInvItemIA(inst)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.MACHETE_DAMAGE)

    -----
    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.HACK)
    -------
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.MACHETE_USES)
    inst.components.finiteuses:SetUses(TUNING.MACHETE_USES)
    inst.components.finiteuses:SetOnFinished( onfinished)
    inst.components.finiteuses:SetConsumption(ACTIONS.HACK, 1)
    -------
    inst:AddComponent("equippable")

    inst:AddComponent("inspectable")

    inst.components.equippable:SetOnEquip( onequip )

    inst.components.equippable:SetOnUnequip( onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

local function normal()
    local inst = pristinefn()

    inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	masterfn(inst)
	
    return inst
end

local function onequipgold(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_goldenmachete", "swap_goldenmachete")
    owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function golden()
    local inst = pristinefn()

    inst.AnimState:SetBuild("goldenmachete")

    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	masterfn(inst)

    inst.components.finiteuses:SetConsumption(ACTIONS.HACK, 1 / TUNING.GOLDENTOOLFACTOR)
    inst.components.weapon.attackwear = 1 / TUNING.GOLDENTOOLFACTOR
    inst.components.equippable:SetOnEquip(onequipgold)

    return inst
end

local function onequipobsidian(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_machete_obsidian", "swap_machete")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function obsidian()
    local inst = pristinefn()

    inst.AnimState:SetBuild("machete_obsidian")
    inst.AnimState:SetBank("machete_obsidian")

    MakeObsidianToolPristine(inst)

    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	masterfn(inst)

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0)

    MakeObsidianTool(inst, "machete")

    inst.components.tool:SetAction(ACTIONS.HACK, TUNING.OBSIDIANTOOL_WORK)

    inst.components.finiteuses:SetConsumption(ACTIONS.HACK, 1 / TUNING.OBSIDIANTOOLFACTOR)
    inst.components.weapon.attackwear = 1 / TUNING.OBSIDIANTOOLFACTOR
    inst.components.equippable:SetOnEquip(onequipobsidian)

    return inst
end

return Prefab("machete", normal, assets.machete),
    Prefab("goldenmachete", golden, assets.machete_golden),
    Prefab("obsidianmachete", obsidian, assets.machete_obsidian)