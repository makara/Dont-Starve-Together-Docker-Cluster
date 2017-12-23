local assets=
{ 
	Asset("ANIM", "anim/katana.zip"),
    Asset("ANIM", "anim/swap_katana.zip"), 
	
    Asset("ATLAS", "images/inventoryimages/katana.xml"),
    Asset("IMAGE", "images/inventoryimages/katana.tex"),
}

local prefabs = {}

local function onfinished(inst)
    inst:Remove()
end

local HPABSORB = 0.9999
local CRITCHANCE = 0.35

local function onattack(inst, attacker)
	  local attacker = inst.components.inventoryitem.owner
      if math.random() < HPABSORB then
	  		attacker.components.health:DoDelta(0.33)
		end
end

local function onattack(inst, attacker, target)
	local health = target.components.health
	local attacker = inst.components.inventoryitem.owner
	attacker.components.health:DoDelta(0.33)
	if math.random() < CRITCHANCE then
		health:DoDelta(-30)
	end
end

    local function OnEquip(inst, owner) 
        owner.AnimState:OverrideSymbol("swap_object", "swap_katana", "swap_katana")
        owner.AnimState:Show("ARM_carry") 
        owner.AnimState:Hide("ARM_normal")
    end

    local function OnUnequip(inst, owner) 
        owner.AnimState:Hide("ARM_carry") 
        owner.AnimState:Show("ARM_normal")
    end
	
	
local function fn()

    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
	inst.entity:AddNetwork()
    anim:SetBank("katana")
    anim:SetBuild("katana")
    anim:PlayAnimation("idle")
	
    inst:AddTag("sharp")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	
	inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(46)
	inst.components.weapon.onattack = onattack
	inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(600)
    inst.components.finiteuses:SetUses(600)
	inst.components.finiteuses:SetOnFinished( onfinished)

    inst:AddComponent("inspectable")
	
	inst:AddComponent("talker")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "katana"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/katana.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )
	
	
    return inst
end

return  Prefab("common/inventory/katana", fn, assets, prefabs)