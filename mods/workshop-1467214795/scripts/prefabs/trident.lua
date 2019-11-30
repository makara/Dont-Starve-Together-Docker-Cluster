local assets =
{
	Asset("ANIM", "anim/trident.zip"),
	Asset("ANIM", "anim/swap_trident.zip"),
}

local function onfinished(inst)
	inst:Remove()
end

local function refreshDamage(owner, data)
	-- Practically doesn't matter if that trident is a different one, but it should be the same -M
	if owner and data and data.weapon and data.weapon.prefab == "trident" then
		if owner:HasTag("aquatic") then 
			data.weapon.components.weapon:SetDamage( TUNING.SPEAR_DAMAGE*3 )
		else
			data.weapon.components.weapon:SetDamage( TUNING.SPEAR_DAMAGE )
		end
	end
end 

local function onequip(inst, owner) 
	owner.AnimState:OverrideSymbol("swap_object", "swap_trident", "swap_trident")
	owner.AnimState:Show("ARM_carry") 
	owner.AnimState:Hide("ARM_normal")
	
	-- Cleanest way to callback before the damage is actually used -M
	inst:ListenForEvent("onattackother", refreshDamage, owner)
end

local function onunequip(inst, owner) 
	owner.AnimState:Hide("ARM_carry") 
	owner.AnimState:Show("ARM_normal")
	
	inst:RemoveEventCallback("onattackother", refreshDamage, owner)
end

-- local function getDamage(inst)
	-- if inst.components.inventoryitem and inst.components.inventoryitem.owner then 
		-- if inst.components.inventoryitem.owner:HasTag("aquatic") then 
			-- return TUNING.SPEAR_DAMAGE*3
		-- end 
	-- end 
	-- return TUNING.SPEAR_DAMAGE
-- end 

-- local function onattack(inst, attacker, target)
	-- if attacker:HasTag("aquatic") then
		-- inst.components.weapon:SetDamage(TUNING.SPEAR_DAMAGE*3)
	-- else
		-- inst.components.weapon:SetDamage(TUNING.SPEAR_DAMAGE)
	-- end
-- end


local function commonfn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("trident")
	inst.AnimState:SetBuild("trident")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("sharp")

	MakeInventoryFloatable(inst)
	inst.components.floater:UpdateAnimations("idle_water", "idle")
	
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	-------
	
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(TUNING.SPEAR_DAMAGE)
	-- inst.components.weapon:SetOnAttack(onattack)
	-- inst.components.weapon.getdamagefn = getDamage
	
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(TUNING.SPEAR_USES)
	inst.components.finiteuses:SetUses(TUNING.SPEAR_USES)
	
	inst.components.finiteuses:SetOnFinished( onfinished )

	inst:AddComponent("inspectable")
	
	MakeInvItemIA(inst)
	
	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip( onequip )
	inst.components.equippable:SetOnUnequip( onunequip )
	
	return inst
end

return Prefab( "trident", commonfn, assets)
