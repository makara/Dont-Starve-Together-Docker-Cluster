local assets=
{
	Asset("ANIM", "anim/coconade.zip"),
	Asset("ANIM", "anim/swap_coconade.zip"),

	Asset("ANIM", "anim/coconade_obsidian.zip"),
	Asset("ANIM", "anim/swap_coconade_obsidian.zip"),
	
	Asset("ANIM", "anim/explode_ring_fx.zip"),
}

local prefabs =
{
	"explode_large",
	"explodering_fx",
    "reticule",
}

local function addfirefx(inst, owner)
    if not inst.fire then
		inst.SoundEmitter:KillSound("hiss")
    	inst.SoundEmitter:PlaySound("ia/common/coconade_fuse", "hiss")
        inst.fire = SpawnPrefab( "torchfire" )
        inst.fire.entity:AddFollower()
    end
	if owner then
		inst.fire.Follower:FollowSymbol( owner.GUID, "swap_object", 40, -140, 1 )
	else
		inst.fire.Follower:FollowSymbol( inst.GUID, "swap_flame", 0, 0, 0.1 )
	end
end

local function removefirefx(inst)
    if inst.fire then
		inst.SoundEmitter:KillSound("hiss")
        inst.fire:Remove()
        inst.fire = nil
    end
end

local function onfuse(inst)
	inst.components.explosive:OnBurnt()
end

local function onuse(inst)
	-- if inst.fusetask then
		-- removefirefx(inst)
		-- inst.fusetask:Cancel()
		-- inst.fusetask = nil
	-- else
		local owner = inst.components.inventoryitem.owner
		-- if inst.components.burnable:IsBurning() then
			addfirefx(inst, owner)
		-- end
		inst.fusetarget = GetTime() + TUNING.COCONADE_FUSE
		inst.fusetask = inst:DoTaskInTime(TUNING.COCONADE_FUSE, onfuse)
		inst.fusestart:push()
	-- end
	-- inst.components.useableitem.inuse = false
end

local function onequip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", inst.swapsymbol, inst.swapbuild)
	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")
	if inst.fusetask then
		addfirefx(inst, owner)
	end
end

local function onunequip(inst, owner)
	owner.AnimState:ClearOverrideSymbol("swap_object")
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")
	removefirefx(inst)
end

local function ondropped(inst)
	-- if inst.components.burnable:IsBurning() then
	if inst.fusetask then
		addfirefx(inst)
	end
end

local function onputininventory(inst)
    inst.Physics:SetFriction(.1) --no idea why we are setting friction here, but it does in SW -M
	removefirefx(inst)
	-- if inst.components.burnable:IsBurning() then
    	-- inst.SoundEmitter:PlaySound("ia/common/coconade_fuse", "hiss")
	-- end
end

local function updatelight(inst)
	if inst.fire then
		local pos = inst:GetPosition()
		local rad = math.clamp(Lerp(2, 0, pos.y/6), 0, 2)
		local intensity = math.clamp(Lerp(0.8, 0.5, pos.y/7), 0.5, 0.8)
		local fire = inst.fire._light
		fire.Light:SetRadius(rad)
		fire.Light:SetIntensity(intensity)
	end
end

local function onhitground(inst, thrower, target)
	inst.AnimState:PlayAnimation("idle")
	inst.components.floater:UpdateAnimations("idle_water", "idle") --is this needed?
    inst:RemoveTag("NOCLICK")
	inst.components.inventoryitem:OnDropped()
	-- inst:DoTaskInTime(2, function()
		-- if inst and inst.LightTask then
			-- inst.LightTask:Cancel()
			-- inst.LightTask = nil
		-- end
	-- end)
end

local function onthrown(inst)
	-- local fusetime = TUNING.COCONADE_FUSE
	-- if inst.fusetarget ~= nil and inst.fusetarget > GetTime() then
		-- fusetime = inst.fusetarget - GetTime()
	-- end
	-- inst.fusetask = inst:DoTaskInTime(fusetime, onfuse)
	
    inst:AddTag("NOCLICK")
	if inst.fusetask then
		addfirefx(inst)
	end
	
    inst.Physics:SetFriction(.2)
	inst.Transform:SetFourFaced()
	-- inst:FacePoint(pt:Get())
    inst.AnimState:PlayAnimation("throw", true)
    inst.SoundEmitter:PlaySound("ia/common/coconade_throw")

	-- inst.LightTask = inst:DoPeriodicTask(FRAMES, function()
		-- local pos = inst:GetPosition()

		-- if pos.y <= 0.1 then
			-- onhitground(inst)
		-- end
		
		-- updatelight(inst)
	-- end)
end

local function onexplode(inst, scale)
	scale = scale or 1

	local explode = SpawnPrefab("explode_large")
	local ring = SpawnPrefab("explodering_fx")
	local pos = inst:GetPosition()

	ring.Transform:SetPosition(pos.x, pos.y, pos.z)
	ring.Transform:SetScale(scale, scale, scale)

	explode.Transform:SetPosition(pos.x, pos.y, pos.z)
	-- explode.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
	-- explode.AnimState:SetLightOverride(1)
	explode.Transform:SetScale(scale, scale, scale)
end

local function onexplode_obsid(inst)
	inst.SoundEmitter:PlaySound("ia/common/coconade_obsidian_explode")
	onexplode(inst, 1.3)
end

local function onignite(inst)
	-- inst.components.fuse:StartFuse()
    if inst.components.equippable:IsEquipped() then
    	local owner = inst.components.inventoryitem.owner
    	addfirefx(inst, owner)
    elseif not inst.components.inventoryitem:IsHeld() then
    	addfirefx(inst)
    end

	inst.fusestart:push()
	if inst.components.useableitem then
		inst.components.useableitem.inuse = true
	end
end

local function getstatus(inst)
    if inst.components.burnable:IsBurning() then
        return "BURNING"
    end
end

local function onremove(inst)
	inst.SoundEmitter:KillSound("hiss")
	removefirefx(inst)
	if inst.LightTask then
		inst.LightTask:Cancel()
	end
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

local function fusestart(inst)
	inst.fusevalue = TUNING.COCONADE_FUSE
	inst:PushEvent("fusechanged")
	inst:DoPeriodicTask(1, function()
		--Do the countdown locally as to not clog the network, I guess. Really, I'm just being lazy here. -M
		inst.fusevalue = inst.fusevalue - 1
		inst:PushEvent("fusechanged")
	end)
end

local function commonfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	
	inst:AddTag("thrown")
	inst:AddTag("projectile")
	inst:AddTag("fuse") --UI optimisation
	
    inst:AddComponent("reticule")
    inst.components.reticule.targetfn = ReticuleTargetFn
    inst.components.reticule.ease = true

    inst.OnRemoveEntity = onremove

	--stuff for fuse UI
	--I'm too lazy to make this a component, and it's probably better for network -M
	inst.fusestart = net_event(inst.GUID, "fusestart")
	inst:ListenForEvent("fusestart", fusestart)
	
	MakeInventoryFloatable(inst)
	inst.components.floater:UpdateAnimations("idle_water", "idle")
	
	return inst
end

local function masterfn(inst)

	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = getstatus

	MakeInvItemIA(inst)
    inst.components.inventoryitem:SetOnDroppedFn(ondropped)
    inst.components.inventoryitem:SetOnPutInInventoryFn(onputininventory)

    -- inst:AddComponent("fuse")
    -- inst.components.fuse:SetFuseTime(TUNING.COCONADE_FUSE)
    -- inst.components.fuse.onfusedone = onfuse

	-- inst:AddComponent("burnable")
	-- inst.components.burnable.onignite = onignite
	-- inst.components.burnable.nofx = true
	
    MakeSmallBurnable(inst, TUNING.COCONADE_FUSE)
    -- MakeSmallPropagator(inst)
    --V2C: Remove default OnBurnt handler, as it conflicts with
    --explosive component's OnBurnt handler for removing itself
    inst.components.burnable:SetOnBurntFn(nil)
    inst.components.burnable:SetOnIgniteFn(onignite)

	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(onequip)
	inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("useableitem")
    inst.components.useableitem:SetOnUseFn(onuse)
    -- inst.components.useableitem:SetOnStopUseFn(onstopuse)

	-- consider using complexprojectile instead and dumping "throwable"
	-- action "TOSS" should be already suitable
	-- inst:AddComponent("throwable")
	-- inst.components.throwable.onthrown = onthrown
	
    -- inst:AddComponent("locomotor")

    inst:AddComponent("complexprojectile")
    inst.components.complexprojectile:SetHorizontalSpeed(12)
    -- inst.components.complexprojectile:SetGravity(-15)
    inst.components.complexprojectile.usehigharc = false
    inst.components.complexprojectile:SetLaunchOffset(Vector3(.25, 1, 0))
    inst.components.complexprojectile:SetOnLaunch(onthrown)
    inst.components.complexprojectile:SetOnHit(onhitground)
    inst.components.complexprojectile:SetOnUpdate(updatelight)
	
    -- inst:AddComponent("weapon")
    -- inst.components.weapon:SetDamage(0)
    -- inst.components.weapon:SetRange(8, 10)
	
	inst:AddComponent("explosive")

	inst:AddComponent("appeasement")
    inst.components.appeasement.appeasementvalue = TUNING.WRATH_LARGE
	
	return inst
end


local function firefn()
	local inst = commonfn()

	inst.AnimState:SetBank("coconade")
	inst.AnimState:SetBuild("coconade")
	inst.AnimState:PlayAnimation("idle")

	inst.swapsymbol = "swap_coconade"
	inst.swapbuild = "swap_coconade"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	masterfn(inst)
	
	inst.components.explosive:SetOnExplodeFn(onexplode)
	inst.components.explosive.explosivedamage = TUNING.COCONADE_DAMAGE
	inst.components.explosive.explosiverange = TUNING.COCONADE_EXPLOSIONRANGE
	inst.components.explosive.buildingdamage = TUNING.COCONADE_BUILDINGDAMAGE

	return inst
end

local function obsidianfn()
	local inst = commonfn()

	inst.AnimState:SetBank("coconade_obsidian")
	inst.AnimState:SetBuild("coconade_obsidian")
	inst.AnimState:PlayAnimation("idle")

	inst.swapsymbol = "swap_coconade_obsidian"
	inst.swapbuild = "swap_coconade_obsidian"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	masterfn(inst)

	inst.components.explosive:SetOnExplodeFn(onexplode_obsid)
	inst.components.explosive.explosivedamage = TUNING.COCONADE_OBSIDIAN_DAMAGE
	inst.components.explosive.explosiverange = TUNING.COCONADE_OBSIDIAN_EXPLOSIONRANGE
	inst.components.explosive.buildingdamage = TUNING.COCONADE_OBSIDIAN_BUILDINGDAMAGE

	return inst
end

return Prefab("coconade", firefn, assets, prefabs),
	Prefab("obsidiancoconade", obsidianfn, assets, prefabs)
