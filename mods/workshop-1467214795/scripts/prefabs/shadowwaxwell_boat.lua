local assets = {
    Asset("ANIM", "anim/rowboat_basic.zip"),
	Asset("ANIM", "anim/waxwell_shadowboat_build.zip"),
}

local prefabs = {
    -- "rowboat_wake",
    -- "boat_hit_fx",
    -- "flotsam_rowboat",
}

local function update_rotation(inst)
	if inst and inst.sailor then
		inst.Transform:SetRotation(inst.sailor.Transform:GetRotation())
	end
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddPhysics()
    -- inst.entity:AddMiniMapEntity()

    -- inst:AddTag("boat")
    inst:AddTag("NOCLICK")

    inst.AnimState:SetBank("rowboat")
    inst.AnimState:SetBuild("waxwell_shadowboat_build")
    inst.AnimState:PlayAnimation("run_loop", true)
	inst.AnimState:SetMultColour(0,0,0,.4)

    inst.Transform:SetFourFaced()

    inst.Physics:SetCylinder(0.25,2)

    inst.no_wet_prefix = true
	inst.presists = false

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	--TODO make this prefab a clientside FX so we don't network the rotation so much
	--probably requires the networked "marker" of the FX to announce the parent via netvar
	inst:DoPeriodicTask(FRAMES, update_rotation)

    -- inst:AddComponent("inspectable")
    -- inst:AddComponent("rowboatwakespawner")

    return inst
end

return Prefab("shadowwaxwell_boat", fn, assets, prefabs)