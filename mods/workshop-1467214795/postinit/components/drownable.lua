local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local ShouldDrown
local function ShouldDrown_IA(self, ...)
	return ShouldDrown(self, ...)
		and not (self.inst.components.sailor and self.inst.components.sailor:IsSailing())
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("drownable", function(cmp)


ShouldDrown = cmp.ShouldDrown
cmp.ShouldDrown = ShouldDrown_IA


end)
