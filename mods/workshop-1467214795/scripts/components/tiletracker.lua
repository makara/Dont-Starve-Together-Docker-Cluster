-- if you want to keep something on land or water, consider using "keeponland" component instead

local TileTracker = Class(function(self, inst)
	self.inst = inst
	self.tile = nil
	self.tileinfo = nil
	self.ontilechangefn = nil
	self.onwater = nil
	self.onwaterchangefn = nil
end)

-- function TileTracker:OnEntitySleep()
-- end

-- function TileTracker:OnEntityWake()
-- end

function TileTracker:Start()
	self.inst:StartUpdatingComponent(self)
end

function TileTracker:Stop()
	self.inst:StopUpdatingComponent(self)
end

function TileTracker:OnUpdate(dt)
	local tile, tileinfo = self.inst:GetCurrentTileType()

	if tile and tile ~= self.tile then
		self.tile = tile
		if self.ontilechangefn then
			self.ontilechangefn(self.inst, tile, tileinfo)
		end

		if self.onwaterchangefn or self.inst:HasTag("amphibious") then
			local onwater = IsWater(tile)
			
			if onwater ~= self.onwater then
				if self.onwaterchangefn then 
					self.onwaterchangefn(self.inst, onwater)
				end 
				if self.inst:HasTag("amphibious") then 
					if onwater then 
						self.inst:AddTag("aquatic")
					else
						self.inst:RemoveTag("aquatic")
					end 
				end 
			end
			self.onwater = onwater
		end
	end
end

function TileTracker:SetOnTileChangeFn(fn)
	self.ontilechangefn = fn
end

function TileTracker:SetOnWaterChangeFn(fn)
	self.onwaterchangefn = fn
end

return TileTracker
