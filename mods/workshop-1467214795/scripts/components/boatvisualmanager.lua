local BoatVisualManager = Class(function(self, inst)
    self.inst = inst
    self.visuals = {}
end)

function BoatVisualManager:SpawnBoatEquipVisuals(item, visualprefab)
    assert(visualprefab and type(visualprefab) == "string", "item.visualprefab must be a valid string!")

    local visual = SpawnPrefab("visual_"..visualprefab.."_boat")
    visual.entity:SetParent(self.inst.entity)
    self.visuals[item] = visual

    item.visual = visual

    visual.boat = self.inst

    visual.boat.boatvisuals[visual] = true
    visual:ListenForEvent("onremove", function(inst)
        inst.boat.boatvisuals[inst] = nil
    end)

    visual.Transform:SetRotation(visual.boat.Transform:GetRotation())
    visual:StartUpdatingComponent(visual.components.boatvisualanims)
end

function BoatVisualManager:RemoveBoatEquipVisuals(item)
    item.visual = nil
    if self.visuals[item] then
        self.visuals[item]:Remove()
        self.visuals[item] = nil
    end
end

return BoatVisualManager