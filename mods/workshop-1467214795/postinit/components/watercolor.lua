local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

IAENV.AddComponentPostInit("watercolor", function(cmp)


local COLORS = UpvalueHacker.GetUpvalue(cmp.Initialize, "COLORS") or UpvalueHacker.GetUpvalue(cmp.OnPhaseChanged, "COLORS")

local Initialize_old = cmp.Initialize
function cmp:Initialize(...)
	if self.inst and self.inst:HasTag("island") then
		COLORS.default.color = {.5, .5, .4, 1} --gentle fog colour, not too bright
	end
	return Initialize_old(self, ...)
end


end)
