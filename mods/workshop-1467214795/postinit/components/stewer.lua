local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local Harvest_old
local function Harvest(self, ...)
    if IA_CONFIG.oldwarly and self.done and self.gourmetcook and self.product ~= nil and PrefabExists(self.product .."_gourmet") then
		self.product = self.product .."_gourmet"
	end
	self.gourmetcook = nil
	local ret = Harvest_old(self, ...)
	if self.inst.components.container ~= nil and self.inst:HasTag("flooded") then      
		self.inst.components.container.canbeopened = false
	end
	return ret
end

local StopCooking_old
local function StopCooking(self, ...)
    if IA_CONFIG.oldwarly and self.gourmetcook and self.product ~= nil and PrefabExists(self.product .."_gourmet") then
		self.product = self.product .."_gourmet"
	end
	self.gourmetcook = nil
	return StopCooking_old(self, ...)
end

local OnSave_old
local function OnSave(self, ...)
    local data, refs = OnSave_old(self, ...)
	data.gourmetcook = self.gourmetcook
	return data, refs
end

local OnLoad_old
local function OnLoad(self, data, ...)
	OnLoad_old(self, data, ...)
	self.gourmetcook = data.gourmetcook
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("stewer", function(cmp)


Harvest_old = cmp.Harvest
cmp.Harvest = Harvest
StopCooking_old = cmp.StopCooking
cmp.StopCooking = StopCooking
OnSave_old = cmp.OnSave
cmp.OnSave = OnSave
OnLoad_old = cmp.OnLoad
cmp.OnLoad = OnLoad


end)
