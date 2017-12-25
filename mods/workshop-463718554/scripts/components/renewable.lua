local Renewable = Class(function(self, inst)
    self.inst = inst
	self.delay = 0
	self.shouldAdd = TheWorld.components.renewablerespawner.shouldAdd
end)

function Renewable:OnRemoveEntity()
	if self.shouldAdd then
		TheWorld.components.renewablerespawner:AddInstance(self.inst, self.delay)
	end
end

function Renewable:OnSave()
	return {
		delay = self.delay,
		shouldAdd = self.shouldAdd
	}
end

function Renewable:OnLoad(data)
	if data then
		self.delay = data.delay
		self.shouldAdd = data.shouldAdd
	end
end

return Renewable