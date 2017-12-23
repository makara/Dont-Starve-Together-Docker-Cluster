local assets=
{
    Asset("ANIM", "anim/poseidon.zip"),
    Asset("ANIM", "anim/swap_poseidon.zip"),
 
    Asset("ATLAS", "images/inventoryimages/poseidon.xml"),
    Asset("IMAGE", "images/inventoryimages/poseidon.tex"),
}
local prefabs = {}

local HPABSORB = 0.9999

local function onattack(inst, attacker)
	  local attacker = inst.components.inventoryitem.owner
      if math.random() < HPABSORB then
			attacker.components.sanity:DoDelta(0.50)
		end
end

local function fn()

    local function OnEquip(inst, owner)
        owner.AnimState:OverrideSymbol("swap_object", "swap_poseidon", "swap_poseidon")
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")
	end
	
    local function OnUnequip(inst, owner) 
	
        owner.AnimState:Hide("ARM_carry") 
        owner.AnimState:Show("ARM_normal") 
		
    end

	
local function freezeSpell(inst, target)
	local attacker = inst.components.inventoryitem.owner
    if target.components.sleeper ~= nil and target.components.sleeper:IsAsleep() then
        target.components.sleeper:WakeUp()
    end
    if target.components.burnable ~= nil then
        if target.components.burnable:IsBurning() then
            target.components.burnable:Extinguish()
        elseif target.components.burnable:IsSmoldering() then
            target.components.burnable:SmotherSmolder()
        end
    end
    if target.components.combat ~= nil then
        target.components.combat:SuggestTarget(attacker)
    end
    if target.sg ~= nil and not target.sg:HasStateTag("frozen") then
        target:PushEvent("attacked", { attacker = attacker, damage = 40, weapon = inst })
    end
    if target.components.freezable ~= nil then
        target.components.freezable:AddColdness(2)
        target.components.freezable:SpawnShatterFX()
    end
end

local function SanityCheck(inst, level)
    level = inst.components.sanity.current
    if level > 50 then
        inst.components.sanity:DoDelta(-10)
        return true
    end
return false
end

local function HungerCheck(inst, level1)
    level1 = inst.components.hunger.current
    if level1 > 50 then
        inst.components.hunger:DoDelta(-10)
        return true
    end
return false
end


local function aoeSpell(inst, target)
    local caster = inst.components.inventoryitem.owner
    if not caster then caster = target or caster end
	if SanityCheck(caster) and HungerCheck(caster) then
		inst.components.talker:Say("Freezing spell!")
		inst.components.finiteuses:Use(5)
		local x, y, z = target.Transform:GetWorldPosition()
		local spell = SpawnPrefab("lightning")
		spell.Transform:SetPosition(x, y, z)
		spell:DoTaskInTime(8, spell.KillFX)
		local spell2 = SpawnPrefab("deer_ice_circle")
		spell2.Transform:SetPosition(x, y, z)
		spell2:DoTaskInTime(8, spell2.KillFX)
		local spell3 = SpawnPrefab("deer_ice_burst")
		spell3.Transform:SetPosition(x, y, z)
		spell3:DoTaskInTime(8, spell3.KillFX)
		local spell4 = SpawnPrefab("deer_ice_flakes")
		spell4.Transform:SetPosition(x, y, z)
		spell4:DoTaskInTime(8, spell4.KillFX)
		local ents = TheSim:FindEntities(x, y, z, 9, {"freezable"})
		for k, v in pairs(ents) do
			freezeSpell(inst, v)
		end
	else
		inst.components.talker:Say("I need more sanity or hunger!")
    end
end

		
local function castFreeze(inst, target)
	if target then
		aoeSpell(inst, target)
	end
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
	
    anim:SetBank("poseidon")
    anim:SetBuild("poseidon")
    anim:PlayAnimation("idle")
	
	
	if not TheWorld.ismastersim then
      
	return inst
	  
    end	
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetOnAttack(onattack)
	inst.components.weapon:SetDamage(40)
	
	inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(200)
    inst.components.finiteuses:SetUses(200)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
	
	inst:AddComponent("inspectable")
	
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )
	inst.components.equippable.walkspeedmult = 1.0
	inst.components.equippable.dapperness = (0.050)
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "poseidon"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/poseidon.xml"
	
    inst.fxcolour = {51/255, 153/255, 73/255}
    inst:AddComponent("spellcaster")
	inst.components.spellcaster:SetSpellFn(castFreeze)
	inst.components.spellcaster.canuseontargets = true
	inst.components.spellcaster.canonlyuseonlocomotors = true

	
	inst:ListenForEvent("equip", function(inst, data) onequip(inst, data) end)
	inst:ListenForEvent("unequip", function(inst, data) onunequip(inst, data) end)

    return inst
	
end

return  Prefab("common/inventory/poseidon", fn, assets, prefabs)