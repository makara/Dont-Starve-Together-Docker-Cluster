local function onboat(self, boat)
    if boat then
        self.inst:StartUpdatingComponent(self)
    else
        self.inst:StopUpdatingComponent(self)
    end
end

local Sailor = Class(function(self, inst)
    self.inst = inst
    self.boat = self.inst.replica.sailor and self.inst.replica.sailor:GetBoat() or nil
end, 
nil, 
{
    boat = onboat,
})

function Sailor:OnUpdate(dt)
    if self.boat and self.boat:IsValid() then
        local rot = self.inst.Transform:GetRotation()
        self.boat.Transform:SetRotation(rot)
        for visual, v in pairs(self.boat.boatvisuals) do
            visual.Transform:SetRotation(rot)
        end
    end 
end

return Sailor