return Class(function(self, inst)
    self.inst = inst


    function self:IsLandTileAtPoint(pos)
        return not IsOnWater(pos.x, pos.y, pos.z)
    end

    function self:IsWaterTileAtPoint(pos)
        return IsOnWater(pos.x, pos.y, pos.z)
    end
end)