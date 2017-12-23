local assets=
{
    Asset("ANIM", "anim/battleaxe.zip"),
    Asset("ANIM", "anim/swap_battleaxe.zip"),
 
    Asset("ATLAS", "images/inventoryimages/battleaxe.xml"),
    Asset("IMAGE", "images/inventoryimages/battleaxe.tex"),
}
local prefabs = {}

local function IsValidVictim(victim)

    return victim ~= nil
	
        and not (victim:HasTag("veggie") or
		
                victim:HasTag("structure") or
				
                victim:HasTag("wall"))
				
        and victim.components.health ~= nil
		
        and victim.components.combat ~= nil
		
end

local function onattack(inst, attacker, target)

    if not target:IsValid() then
	
        return
		
    end
	
		if target.components.combat ~= nil then
	 
			target.components.combat:SuggestTarget(attacker)
		
		end
	
			if target.components.sleeper ~= nil and target.components.sleeper:IsAsleep() then
	
			target.components.sleeper:WakeUp()
		
			end
	
	end

local function fn()

    local function OnEquip(inst, owner)
        owner.AnimState:OverrideSymbol("swap_object", "swap_battleaxe", "swap_battleaxe")
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
	
    anim:SetBank("battleaxe")
    anim:SetBuild("battleaxe")
    anim:PlayAnimation("idle")
	
	if not TheWorld.ismastersim then
      
	return inst
	  
    end	
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetOnAttack(onattack)
	inst.components.weapon:SetDamage(50)

	inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP)
	
	inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(340)
    inst.components.finiteuses:SetUses(340)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
    inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 1)
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	inst:AddComponent("tradable")
	
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "battleaxe"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/battleaxe.xml"
	
	inst:ListenForEvent("equip", function(inst, data) onequip(inst, data) end)
	inst:ListenForEvent("unequip", function(inst, data) onunequip(inst, data) end)

    return inst
	
end

return  Prefab("common/inventory/battleaxe", fn, assets, prefabs)