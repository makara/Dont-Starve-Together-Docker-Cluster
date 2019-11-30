-- Debug weapon of mass glitchiness

local assets =
{
	Asset("ANIM", "anim/trident.zip"),
	Asset("ANIM", "anim/swap_trident.zip"),
}

local prefabs = {}


local function onequip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_staffs", "swap_opalstaff")
	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function terraform(staff, target, pt)
    local caster = staff.components.inventoryitem.owner

    local world = TheWorld
    local map = world.Map

    local original_tile_type = map:GetTileAtPoint(pt:Get())
    local x, y = map:GetTileCoordsAtPoint(pt:Get())

    local targettile = GROUND.OCEAN_SHALLOW

    if IsWater(original_tile_type) then
        targettile = GROUND.DIRT
    end

    map:SetTile(x, y, targettile)
    map:RebuildLayer(original_tile_type, x, y)
    map:RebuildLayer(targettile, x, y)
    --world.components.shorecollisions:UpdateTileCollisions(x, y)

    world.minimap.MiniMap:RebuildLayer(original_tile_type, x, y)
    world.minimap.MiniMap:RebuildLayer(targettile, x, y)
end

local function light_reticuletargetfn()
    return Vector3(TheLocalPlayer.entity:LocalToWorldSpace(5, 0, 0))
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("trident")
	inst.AnimState:SetBuild("trident")
	inst.AnimState:PlayAnimation("idle")

    inst:AddTag("nopunch")

    inst:AddComponent("reticule")
    inst.components.reticule.targetfn = light_reticuletargetfn
    inst.components.reticule.ease = true

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    MakeInvItemIA(inst, "trident")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(terraform)
    inst.components.spellcaster.canuseonpoint_water = true
    inst.components.spellcaster.canuseonpoint = true
    inst.components.spellcaster.quickcast = true

    return inst
end

return Prefab("terraformstaff", fn, assets, prefabs)
