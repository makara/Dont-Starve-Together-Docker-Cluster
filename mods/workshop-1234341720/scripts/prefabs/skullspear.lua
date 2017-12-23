local assets=
{
    Asset("ANIM", "anim/skullspear.zip"),
    Asset("ANIM", "anim/swap_skullspear.zip"),
 
    Asset("ATLAS", "images/inventoryimages/skullspear.xml"),
    Asset("IMAGE", "images/inventoryimages/skullspear.tex"),
}
local prefabs = {}

local SANITYABSORB = 0.9999

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

	local function onattack(inst, attacker)
	  local attacker = inst.components.inventoryitem.owner
      if math.random() < SANITYABSORB then
	  		attacker.components.sanity:DoDelta(0.33)
		end
end

local function fn()

    local function OnEquip(inst, owner)
        owner.AnimState:OverrideSymbol("swap_object", "swap_skullspear", "swap_skullspear")
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
	
    anim:SetBank("skullspear")
    anim:SetBuild("skullspear")
    anim:PlayAnimation("idle")
	
	if not TheWorld.ismastersim then
      
	return inst
	  
    end	
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetOnAttack(onattack)
	inst.components.weapon:SetDamage(42)
	
	inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(420)
    inst.components.finiteuses:SetUses(420)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	inst:AddComponent("tradable")
	
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )
	inst.components.equippable.dapperness = (0.050)
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "skullspear"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/skullspear.xml"
	
	inst:ListenForEvent("equip", function(inst, data) onequip(inst, data) end)
	inst:ListenForEvent("unequip", function(inst, data) onunequip(inst, data) end)

    return inst
	
end

return  Prefab("common/inventory/skullspear", fn, assets, prefabs)