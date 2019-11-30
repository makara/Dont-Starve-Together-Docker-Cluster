local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local function SetOnGrowthFn(self, fn)
	self.ongrowthfn = fn
end

local _doGrowth
local function DoGrowth(self)

	_doGrowth(self)
	
	local stage = self:GetNextStage()
	local lastStage = self.stage

	if self.ongrowthfn then
		self.ongrowthfn(self.inst, lastStage, stage)
	end
end
	
----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("growable", function(cmp)


if TheWorld.ismastersim then
	
	-- install extra function calls
	cmp.SetOnGrowthFn = SetOnGrowthFn
	
	_doGrowth = cmp.DoGrowth
	cmp.DoGrowth = DoGrowth
	
end


end)
