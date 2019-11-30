local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local _CanAcceptFuelItem
local function CanAcceptFuelItem(self, item, ...)
    return _CanAcceptFuelItem(self, item, ...) or (self.accepting and item and item.components.fuel and (item.components.fuel.secondaryfueltype == self.fueltype or item.components.fuel.secondaryfueltype == self.secondaryfueltype))
end


----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("fueled", function(cmp)


_CanAcceptFuelItem = cmp.CanAcceptFuelItem
cmp.CanAcceptFuelItem = CanAcceptFuelItem


end)
