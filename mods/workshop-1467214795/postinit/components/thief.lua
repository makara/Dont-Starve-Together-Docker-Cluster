local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local function SetCanOpenContainers(self, canopen)
	self.canopencontainers = canopen
end

local StealItemOld
local function StealItem(self, victim, itemtosteal, attack)
	if not (victim.components.inventory and not victim.components.inventory.nosteal) and victim.components.container and not self.canopencontainers then
		return
	else
		StealItemOld(self, victim, itemtosteal, attack)
	end
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("thief", function(cmp)


cmp.canopencontainers = true

StealItemOld = cmp.StealItem
cmp.StealItem = StealItem
cmp.SetCanOpenContainers = SetCanOpenContainers


end)
