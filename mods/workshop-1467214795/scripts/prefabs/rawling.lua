local assets =
{
	Asset("ANIM", "anim/basketball.zip"),
	Asset("ANIM", "anim/swap_basketball.zip"),
}

local prefabs =
{
}

local function onputininventory(inst)
    inst.Physics:SetFriction(.1)
end

local function onthrown(inst)

	inst:DoTaskInTime(0.3, function(inst)
		if inst.components.sentientball then
			inst.components.sentientball:OnThrown()
		end
		inst.components.inventoryitem.canbepickedup = true
	end)
	
	inst.components.inventoryitem.canbepickedup = false
    inst.Physics:SetFriction(.2)
	inst.Transform:SetFourFaced()
	-- inst:FacePoint(pt:Get())
    inst.AnimState:PlayAnimation("throw", true)
    inst.SoundEmitter:PlaySound("ia/common/coconade_throw")

	local thrower = inst.components.complexprojectile.attacker
    if thrower and thrower.components.sanity then
    	thrower.components.sanity:DoDelta(TUNING.SANITY_SUPERTINY)
    end
end

local function onhitground(inst)
	if IsOnWater(inst) then
		--splash fx TODO -M
	else
		inst.AnimState:PlayAnimation("idle")
	end
	-- inst.components.inventoryitem:OnDropped()
end

local function oncollision(inst, other)
	inst.SoundEmitter:PlaySound("ia/common/monkey_ball/bounce")
end

local function onequip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_basketball", "swap_basketball")
	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")

	if inst.components.sentientball then
		inst.components.sentientball:OnEquipped()
	end
end

local function onunequip(inst, owner)
	owner.AnimState:ClearOverrideSymbol("swap_object")
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")
end

local function ReticuleTargetFn()
	-- return inst.components.throwable:GetThrowPoint()
    local player = TheLocalPlayer
    local ground = TheWorld.Map
    local pos = Vector3()
    --Attack range is 8, leave room for error
    --Min range was chosen to not hit yourself (2 is the hit range)
    for r = 6.5, 3.5, -.25 do
        pos.x, pos.y, pos.z = player.entity:LocalToWorldSpace(r, 0, 0)
        if ground:IsPassableAtPoint(pos:Get()) and not ground:IsGroundTargetBlocked(pos) then
            return pos
        end
    end
    return pos
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("basketball")
	inst.AnimState:SetBuild("basketball")
	inst.AnimState:PlayAnimation("idle")
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon( "rawling.tex" )

	MakeInventoryPhysics(inst)

	inst:AddTag("nopunch")
	inst:AddTag("irreplaceable")
	
    inst:AddComponent("reticule")
    inst.components.reticule.targetfn = ReticuleTargetFn
    inst.components.reticule.ease = true
	
	inst:AddComponent("talker")
	inst.components.talker.fontsize = 28
	inst.components.talker.font = TALKINGFONT
	inst.components.talker.colour = Vector3(.9, .4, .4, 1)
	inst.components.talker.offset = Vector3(0,100,0)
	inst.components.talker.symbol = "swap_object"

	MakeInventoryFloatable(inst)
	inst.components.floater:UpdateAnimations("idle_water", "idle")
	inst:ListenForEvent("on_landed", onhitground)

    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end

	MakeBlowInHurricane(inst, TUNING.WINDBLOWN_SCALE_MIN.MEDIUM, TUNING.WINDBLOWN_SCALE_MAX.MEDIUM)

	inst:AddComponent("inspectable")

	MakeInvItemIA(inst)
    inst.components.inventoryitem:SetOnPutInInventoryFn(onputininventory)
	inst.components.inventoryitem.bouncesound = "ia/common/monkey_ball/bounce"

	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(onequip)
	inst.components.equippable:SetOnUnequip(onunequip)
	inst.components.equippable.equipstack = true
	inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED

	-- note: We don't actually use a classified, so the lines do not sync up. Who cares? -M
	inst:AddComponent("sentientball")
	
	MakeSmallBurnable(inst, TUNING.LARGE_BURNTIME)
	MakeSmallPropagator(inst)
	
    inst:AddComponent("complexprojectile")
    inst.components.complexprojectile:SetHorizontalSpeed(10)
    inst.components.complexprojectile:SetGravity(-15)
    inst.components.complexprojectile:SetLaunchOffset(Vector3(.25, 1, 0))
    inst.components.complexprojectile:SetOnLaunch(onthrown)
    inst.components.complexprojectile:SetOnHit(onhitground)

	inst.Physics:SetCollisionCallback(oncollision)

	inst:ListenForEvent("ontalk", function() 
		if not inst.SoundEmitter:PlayingSound("special") then
			inst.SoundEmitter:PlaySound("ia/characters/rawling/talk_LP", "talk") 
		end
	end)
	inst:ListenForEvent("donetalking", function() inst.SoundEmitter:KillSound("talk") end)

	--TODO should say something, like Lucy does
    MakeHauntableLaunch(inst)
	
	return inst
end

return Prefab( "rawling", fn, assets, prefabs)
