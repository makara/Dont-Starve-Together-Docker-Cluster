local assets=
{
    Asset("ANIM", "anim/pirate.zip"),
    Asset("ANIM", "anim/swap_pirate.zip"),
 
    Asset("ATLAS", "images/inventoryimages/pirate.xml"),
    Asset("IMAGE", "images/inventoryimages/pirate.tex"),
}
local prefabs = {}

local function onfinished(inst)
    inst:Remove()
end

local CRITCHANCE = 0.15


local function onattack(inst, attacker, target)
	local health = target.components.health
	local attacker = inst.components.inventoryitem.owner
	attacker.components.health:DoDelta(0.15)
	if math.random() < CRITCHANCE then
		health:DoDelta(-20)
	end
end

local function fn()

    local function OnEquip(inst, owner)
        owner.AnimState:OverrideSymbol("swap_object", "swap_pirate", "swap_pirate")
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
	
    anim:SetBank("pirate")
    anim:SetBuild("pirate")
    anim:PlayAnimation("idle")
	
	if not TheWorld.ismastersim then
      
	return inst
	  
    end	
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetOnAttack(onattack)
	inst.components.weapon:SetDamage(43)
	
	inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(240)
    inst.components.finiteuses:SetUses(240)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("talker")
	
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )
	inst.components.equippable.walkspeedmult = 1.05
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "pirate"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/pirate.xml"
	
	inst:ListenForEvent("equip", function(inst, data) onequip(inst, data) end)
	inst:ListenForEvent("unequip", function(inst, data) onunequip(inst, data) end)

    return inst
	
end

return  Prefab("common/inventory/pirate", fn, assets, prefabs)