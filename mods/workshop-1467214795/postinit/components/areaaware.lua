local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local function embark(inst)
	if inst.components.areaaware then
		inst.components.areaaware:UpdatePosition(inst.Transform:GetWorldPosition())
	end
end

local _OnRemoveFromEntity
local function OnRemoveFromEntity(self, ...)
	self.inst:RemoveEventCallback("embark", embark)
	return _OnRemoveFromEntity(self, ...)
end

local _UpdatePosition
local function UpdatePosition(self, x, y, z, ...)
	if IsOnWater(x, y, z) then
		--the game doesn't even clear the last room, but ocean has no rooms
		--clear so we don't drag rooms like sandstorm desert along forever
		--Update: as of RoT, the game clears if on RoT water only...
		if self.current_area_data ~= nil then
			self.current_area = -1
			self.current_area_data = nil
			self.inst:PushEvent("changearea")
		end
		return true
	end
	return _UpdatePosition(self, x, y, z, ...)
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("areaaware", function(cmp)


_OnRemoveFromEntity = cmp.OnRemoveFromEntity
cmp.OnRemoveFromEntity = OnRemoveFromEntity
_UpdatePosition = cmp.UpdatePosition
cmp.UpdatePosition = UpdatePosition

--Not using this event makes the whole thing a bit less precise,
--sometimes requiring people to sail a bit for the effects to stop.
cmp.inst:ListenForEvent("embark", embark)


end)
