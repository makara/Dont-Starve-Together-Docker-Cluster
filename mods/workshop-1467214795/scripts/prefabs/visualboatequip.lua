local function MakeVisualBoatEquip(name, assets, prefabs, commonfn, masterfn, onreplicate)
    local function fn()
        local inst = CreateEntity()

        inst:AddTag("can_offset_sort_pos")

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst.Transform:SetFourFaced()

        inst:AddTag("NOCLICK")
        inst:AddTag("FX")
        inst:AddTag("nointerpolate")

        inst:AddComponent("boatvisualanims")

        inst:Hide()

        --sigh, why is nothing ever simple.
        inst._showtask = inst:DoPeriodicTask(FRAMES, function(inst)
            if inst.boat and inst.Transform:GetRotation() == inst.boat.Transform:GetRotation() then
                inst:DoTaskInTime(FRAMES, inst.Show)
                inst._showtask:Cancel()
                inst._showtask = nil
            end
        end)

        if commonfn then
            commonfn(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            function inst.OnEntityReplicated(inst)
                inst.boat = inst.entity:GetParent()

                inst.boat.boatvisuals[inst] = true
                inst:ListenForEvent("onremove", function(inst)
                    inst.boat.boatvisuals[inst] = nil
                end)

                inst.Transform:SetRotation(inst.boat.Transform:GetRotation())
                inst:StartUpdatingComponent(inst.components.boatvisualanims)

                if onreplicate then
                    onreplicate(inst)
                end
            end
            return inst
        end

        if masterfn then
            masterfn(inst)
        end

        inst.persists = false

        return inst
    end
    return Prefab("visual_"..name.."_boat", fn, assets, prefabs)
end

return MakeVisualBoatEquip