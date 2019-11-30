local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local GetStatus_old
local function GetStatus(self, viewer, ...)
	return GetStatus_old(self, viewer, ...) or self.inst ~= viewer and self.inst:HasTag("flooded") and "FLOODED" or nil
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("inspectable", function(cmp)

GetStatus_old = cmp.GetStatus
cmp.GetStatus = GetStatus


end)
