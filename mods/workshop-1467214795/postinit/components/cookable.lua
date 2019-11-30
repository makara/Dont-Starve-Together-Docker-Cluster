local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local Cook_old
local function Cook(self, ...)
    local prod = Cook_old(self, ...)

	if prod.components.visualvariant then
		prod.components.visualvariant:CopyOf(self.inst)
	end

	return prod
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("cookable", function(cmp)


Cook_old = cmp.Cook
cmp.Cook = Cook


end)
