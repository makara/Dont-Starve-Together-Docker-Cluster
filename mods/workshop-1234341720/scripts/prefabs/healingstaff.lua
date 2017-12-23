local assets=
{
    Asset("ANIM", "anim/healingstaff.zip"),
    Asset("ANIM", "anim/swap_healingstaff.zip"),
 
    Asset("ATLAS", "images/inventoryimages/healingstaff.xml"),
    Asset("IMAGE", "images/inventoryimages/healingstaff.tex"),
}
local prefabs = {}

local function SanityCheck(inst, level)
    level = level or inst.components.sanity.current
    if level > 50 then
        inst.components.sanity:DoDelta(-15)
		
        return true
    end
return false
end
  
local function HealFunc(inst, target)
    print(inst, target)
    local caster = inst.components.inventoryitem.owner
    if not caster then caster = target or caster end
		
    if SanityCheck(caster) then
        target.components.health:DoDelta(25)
		inst.components.talker:Say("Healing spell!")
    else
    inst.components.talker:Say("I need more sanity!")
    end
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
        owner.AnimState:OverrideSymbol("swap_object", "swap_healingstaff", "swap_healingstaff")
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

	inst:AddComponent("talker")
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()	
	inst.entity:SetPristine()

	MakeInventoryPhysics(inst)
    MakeHauntableLaunch(inst)
	
    anim:SetBank("healingstaff")
    anim:SetBuild("healingstaff")
    anim:PlayAnimation("idle")
	
	
	if not TheWorld.ismastersim then
      
	return inst
	  
    end	
	
	inst.fxcolour = {255/255,90/255,70/255}
    inst:AddComponent("spellcaster")
	inst.components.spellcaster:SetSpellFn(HealFunc)
	inst.components.spellcaster.canuseontargets = true
	inst.components.spellcaster.canonlyuseonlocomotors = true
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetOnAttack(onattack)
	inst.components.weapon:SetDamage(20)
	
	inst:AddComponent("inspectable")
	inst:AddComponent("tradable")
	
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )
	inst.components.equippable.walkspeedmult = 1.25
	inst.components.equippable.dapperness = (0.033)
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "healingstaff"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/healingstaff.xml"
	
	inst:ListenForEvent("equip", function(inst, data) onequip(inst, data) end)
	inst:ListenForEvent("unequip", function(inst, data) onunequip(inst, data) end)

    return inst
	
end

return  Prefab("common/inventory/healingstaff", fn, assets, prefabs)