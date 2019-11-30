local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

-- install extra function calls
local function SetOnIgniteFn(self, fn)
	self.onignitefn = fn
end

local OnIgnite_old
local function OnIgnite(self)
	OnIgnite_old(self)
	if self.onignitefn then
		self.onignitefn(self.inst)
	end
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("explosive", function(cmp)


if TheWorld.ismastersim then

cmp.SetOnIgniteFn = SetOnIgniteFn

OnIgnite_old = cmp.OnIgnite
cmp.OnIgnite = OnIgnite
	
end


end)
