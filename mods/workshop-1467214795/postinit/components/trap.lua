local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local _OnUpdate
local function OnUpdate(self, dt, ...)
	if (not self.water and IsOnLand(self.inst)) or (self.water and IsOnWater(self.inst)) then
		return _OnUpdate(self, dt, ...)
	end
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("trap", function(cmp)


cmp.water = false

_OnUpdate = cmp.OnUpdate
cmp.OnUpdate = OnUpdate


end)
