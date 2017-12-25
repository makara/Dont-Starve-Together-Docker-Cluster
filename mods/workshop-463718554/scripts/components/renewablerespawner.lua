local RenewableRespawner = Class(function(self, inst)
	self.inst = inst
	self.doubleRenewDelay = GetModConfigData("RENEWLIMITEDRESOURCES", KnownModIndex:GetModActualName("Fix Multiplayer")) * 2 --It's KnownModIndex not ModIndex, the little documentation there is, is even wrong...
	self.respawnDay = {}
	self.currentDay = 0
	self.currentHour = 0
	self.shouldAdd = true

	for i = 1, self.doubleRenewDelay do
		table.insert(self.respawnDay, {}) --Initialize all respawn days with empty tables
	end
	
	--Won't be exactly in sync with the clock (e.g. after saving/loading), but we don't care and there are enough events happening on clock cycle change already
	self.inst:DoPeriodicTask(TUNING.SEG_TIME, function() self:ClockChanged() end)
end)

function RenewableRespawner:AddInstance(inst, respawndelay)
	local x, y, z = inst.Transform:GetWorldPosition()
	if x ~= 0 and x ~= nil then --Items added with SpawnPrefab that have no location in the world should not be regenerated
		table.insert(self.respawnDay[(self.currentDay+respawndelay)%self.doubleRenewDelay+1], { inst.prefab, x, y, z }) --Randomly add 1 whenever you do something with tables
	end
end

function RenewableRespawner:SpawnInstance(inst)
	local ents = TheSim:FindEntities(inst[2], inst[3], inst[4], 3, { "structure" })  --1=inst.prefab, 2=x, 3=y, 4=z
	for i, v in ipairs(ents) do --Don't respawn in the middle of a base
		return false
	end
	local newPrefab = SpawnPrefab(inst[1])
	if newPrefab then
		newPrefab.Transform:SetPosition(inst[2], inst[3], inst[4])
	end
	return true
end

function RenewableRespawner:ClockChanged()
	self.shouldAdd = false --World is created, all entities that should be added are now added, so we are done adding new ones

	self.currentHour = self.currentHour + 1
	if self.currentHour >= 16 then --16 segments per day
		self.currentHour = 0
		self.currentDay = self.currentDay + 1
		if self.currentDay >= self.doubleRenewDelay then
			self.currentDay = 0
		end
	end

	local entitiesToSpawn = table.getn(self.respawnDay[self.currentDay+1])/(16-self.currentHour) --Respawn 1/16th of the entities for this day and slowly increase this to 100%
	for i = 1, entitiesToSpawn do
		self.shouldAdd = true --Add the respawned one to the list again
		self:SpawnInstance(self.respawnDay[self.currentDay+1][1])
		table.remove(self.respawnDay[self.currentDay+1], 1)
		self.shouldAdd = false --Prevent other prefabs being created to also get added to the list
	end
end

function RenewableRespawner:OnSave()
	self:tprint(self.respawnDay,1)
	return {
		shouldAdd = self.shouldAdd,
		currentHour = self.currentHour,
		currentDay = self.currentDay,
		respawnDay = self.respawnDay
	}
end

function RenewableRespawner:OnLoad(data)
	if data then
		self.currentHour = data.currentHour
		self.currentDay = data.currentDay
		self.respawnDay = data.respawnDay
		self.shouldAdd = data.shouldAdd
		
		local daysToRemove = table.getn(self.respawnDay) - self.doubleRenewDelay
		for i = 1, daysToRemove do --In case renew delay has been reduced move all items awaiting spawn to new spawn date
			for j = 1, table.getn(self.respawnDay[self.doubleRenewDelay+1]) do
				table.insert(self.respawnDay[self.doubleRenewDelay], self.respawnDay[self.doubleRenewDelay+1][j])
			end
			table.remove(self.respawnDay, self.doubleRenewDelay+1)
		end
		
		local daysToAdd = self.doubleRenewDelay - table.getn(self.respawnDay)
		for i = 1, daysToAdd do  --In case renew delay has been increased make table big enough
			table.insert(self.respawnDay, {})
		end
	end
	self:tprint(self.respawnDay,1)
end

--Analyse table structure
function RenewableRespawner:tprint(tbl, indent)
	for k, v in pairs(tbl) do
		local formatting = string.rep("  ", indent) .. k .. ": "
		if type(v) == "table" then
			print(formatting)
			self:tprint(v, indent+1)
		else
			print(formatting .. v)
		end
	end
end

return RenewableRespawner