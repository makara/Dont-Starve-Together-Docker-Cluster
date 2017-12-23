local assets=
{
    Asset("ANIM", "anim/flamesword.zip"),
    Asset("ANIM", "anim/swap_flamesword.zip"),
 
    Asset("ATLAS", "images/inventoryimages/flamesword.xml"),
    Asset("IMAGE", "images/inventoryimages/flamesword.tex"),
}
local prefabs = {}

local CHANCE = 0.10
	
local function onattack(weapon, attacker, target)
    if target ~= nil and target.components.burnable ~= nil and math.random() < CHANCE * target.components.burnable.flammability then
        target.components.burnable:Ignite(nil, attacker)
    end
end

local function fn()

    local function OnEquip(inst, owner)
        owner.AnimState:OverrideSymbol("swap_object", "swap_flamesword", "swap_flamesword")
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")
	end
	
    local function OnUnequip(inst, owner) 
	
        owner.AnimState:Hide("ARM_carry") 
        owner.AnimState:Show("ARM_normal") 
		
    end

	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()	
	inst.entity:SetPristine()

	MakeInventoryPhysics(inst)
    MakeHauntableLaunch(inst)
	
    anim:SetBank("flamesword")
    anim:SetBuild("flamesword")
    anim:PlayAnimation("idle")
	
	if not TheWorld.ismastersim then
      
	return inst
	  
    end	
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetOnAttack(onattack)
	inst.components.weapon:SetDamage(50)

	
	inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(435)
    inst.components.finiteuses:SetUses(435)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	inst:AddComponent("tradable")
	
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "flamesword"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/flamesword.xml"
	
	inst:ListenForEvent("equip", function(inst, data) onequip(inst, data) end)
	inst:ListenForEvent("unequip", function(inst, data) onunequip(inst, data) end)

    return inst
	
end

return  Prefab("common/inventory/flamesword", fn, assets, prefabs)