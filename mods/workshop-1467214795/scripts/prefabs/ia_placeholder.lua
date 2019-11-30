local assets = {
  Asset("ANIM", "anim/dubloon.zip"),
}

local function basic()
    local inst = CreateEntity()
    inst.entity:AddTransform()

    function inst:OnLoad(data)
        inst.data = data
    end

    function inst:OnSave(data)
        if inst.data then
            for k, v in pairs(inst.data) do
        	   data[k] = v
            end
        end
    end

    return inst
end

local function item()
    local inst = basic()

    inst.entity:AddNetwork()
    inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("dubloon")
    inst.AnimState:SetBuild("dubloon")
    inst.AnimState:PlayAnimation("idle")

	MakeInventoryFloatable(inst)
	inst.components.floater:UpdateAnimations("idle_water", "idle")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    MakeInvItemIA(inst, "dubloon")

    inst:AddComponent("inspectable")
    inst.components.inspectable.descriptionfn = function(inst, viewer)
        return GetString(viewer, "ANNOUNCE_UNIMPLEMENTED")
    end

    return inst
end

return
Prefab("beachresurrector", basic),
Prefab("butterfly_areaspawner", basic),
Prefab("buriedtreasure", basic),
Prefab("quackenbeak", item, assets),
Prefab("volcanostaff", item, assets)
