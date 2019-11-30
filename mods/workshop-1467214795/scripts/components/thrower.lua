--Creates & Launches "throwable" items.
local Thrower = Class(function(self, inst)
    self.inst = inst

    self.inst:AddTag("Thrower")

    self.throwable_prefab = "coconade"
    self.range = 15
    self.onthrowfn = nil
end)

function Thrower:GetThrowPoint()
    --For use with controller.
    local owner = self.inst.components.inventoryitem.owner
    if not owner then return end
    local pt = nil
    local rotation = owner.Transform:GetRotation()*DEGREES
    local pos = owner:GetPosition()

    for r = self.range, 1, -1 do
        local numtries = 2*PI*r
        pt = FindValidPositionByFan(rotation, r, numtries, function() return true end) --TODO: #BDOIG Might not need to be walkable?
        if pt then
            return pt + pos
        end
    end
end

function Thrower:Throw(pt)
    local thrown = SpawnPrefab(self.throwable_prefab)
    local x, y, z
    if self.getthrowposition then
        x, y, z = self.getthrowposition(self.inst)
    else
        x, y, z = self.inst.Transform:GetWorldPosition()
    end
    thrown.Transform:SetPosition(x, y, z)
    thrown.components.throwable:Throw(pt, self.inst)

    if self.onthrowfn then
        self.onthrowfn(self.inst, thrown, pt)
    end
end

return Thrower