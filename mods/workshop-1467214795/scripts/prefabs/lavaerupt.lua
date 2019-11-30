local erupt_assets =
{
	Asset("ANIM", "anim/lava_erupt.zip"),
}

local bubble_assets =
{
	Asset("ANIM", "anim/lava_erupt.zip"),
	Asset("ANIM", "anim/lava_bubbling.zip"),
}

local function OnEntitySleep(inst)
	inst:Remove()
end

local function commonfn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst:AddTag("FX")

	return inst	
end

local function masterfn(inst)
	inst.persists = false

	inst.OnEntitySleep = OnEntitySleep

	inst:ListenForEvent("animover", function(inst) inst:Remove() end)

	return inst	
end

local function eruptfn()
	local inst = commonfn()
	
	inst.AnimState:SetBank("lava_erupt")
	inst.AnimState:SetBuild("lava_erupt")
	inst.AnimState:PlayAnimation("idle")
	inst.SoundEmitter:PlaySound("ia/common/volcano/rock_launch")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst = masterfn(inst)

	return inst
end

local function bubblefn()
	local inst = commonfn()
	
	inst.AnimState:SetBank("lava_bubbling")
	inst.AnimState:SetBuild("lava_erupt")
	inst.AnimState:PlayAnimation("idle")
	inst.SoundEmitter:PlaySound("ia/amb/volcano/lava_bubbling")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst = masterfn(inst)

	return inst
end

return Prefab("lava_erupt", eruptfn, erupt_assets),
		Prefab("lava_bubbling", bubblefn, bubble_assets)