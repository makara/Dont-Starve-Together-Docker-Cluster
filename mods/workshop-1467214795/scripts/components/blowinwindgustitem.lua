local easing = require("easing")

local SPEED_VAR_PERIOD = 5
local SPEED_VAR_PERIOD_VARIANCE = 2

local function startfromevent(inst)
	inst.components.blowinwindgustitem:Start()
end
local function stopfromevent(inst)
	inst.components.blowinwindgustitem:Stop()
end

local BlowInWind = Class(function(self, inst)

    self.inst = inst

	self.maxSpeedMult = 1.5
	self.minSpeedMult = .5
	self.averageSpeed = (TUNING.WILSON_RUN_SPEED + TUNING.WILSON_WALK_SPEED)/2
	self.speed = 0

	self.velocity = Vector3(0,0,0)

	self.speedVarTime = 0
	self.speedVarPeriod = GetRandomWithVariance(SPEED_VAR_PERIOD, SPEED_VAR_PERIOD_VARIANCE)

	self.spawnPeriod = 1.0
	self.timeSinceSpawn = self.spawnPeriod
	
	self.inst:ListenForEvent("hitland", startfromevent)--R08_ROT_TURNOFTIDES
	self.inst:ListenForEvent("on_landed", startfromevent)--R08_ROT_TURNOFTIDES
	self.inst:ListenForEvent("ondropped", startfromevent)
	self.inst:ListenForEvent("onpickup", stopfromevent)
end)

function BlowInWind:OnRemoveEntity()
	self:Stop()
	self.inst:RemoveEventCallback("hitland", startfromevent)
	self.inst:RemoveEventCallback("on_landed", startfromevent)--R08_ROT_TURNOFTIDES
	self.inst:RemoveEventCallback("ondropped", startfromevent)
	self.inst:RemoveEventCallback("onpickup", stopfromevent)
end

function BlowInWind:OnEntitySleep()
	self:Stop()
end

function BlowInWind:OnEntityWake()
	self:Start()
end

function BlowInWind:Start()
	if (self.inst.components.inventoryitem and self.inst.components.inventoryitem:IsHeld())
	or not IsInIAClimate(self.inst) then
		return
	end
	self.onwater = IsOnWater(self.inst)
	self.inst:StartUpdatingComponent(self)
end

function BlowInWind:Stop()
	self.velocity = Vector3(0,0,0)
	self.speed = 0.0
	if self.inst:IsValid() then
		self.inst.Physics:Stop()
	end
	self.inst:StopUpdatingComponent(self)
end

function BlowInWind:SetMaxSpeedMult(spd)
	if spd then self.maxSpeedMult = spd end
end

function BlowInWind:SetMinSpeedMult(spd)
	if spd then self.minSpeedMult = spd end
end

function BlowInWind:SetAverageSpeed(spd)
	if spd then self.averageSpeed = spd end
end

function BlowInWind:GetSpeed()
	return self.speed
end

function  BlowInWind:GetVelocity()
	return self.velocity
end

function BlowInWind:GetDebugString()
	return string.format("Vel: %2.2f/%2.2f, Speed: %3.3f/%3.3f", self.velocity.x, self.velocity.z, self.speed, self.maxSpeedMult)
end

--disabled cause that FX is invisible (even in SW) -M
-- function BlowInWind:SpawnWindTrail(dt)
    -- self.timeSinceSpawn = self.timeSinceSpawn + dt
    -- if self.timeSinceSpawn > self.spawnPeriod and math.random() < 0.8 then 
        -- local wake = SpawnPrefab( "windtrail")
        -- local x, y, z = self.inst.Transform:GetWorldPosition()
        -- wake.Transform:SetPosition( x, y, z )
        -- wake.Transform:SetRotation(self.inst.Transform:GetRotation())
        -- self.timeSinceSpawn = 0
    -- end
-- end

function BlowInWind:OnUpdate(dt)
	
	if not self.inst then 
		self:Stop()
		return
	end
	
	if self.inst:HasTag("falling")
	or (self.inst.components.inventoryitem and self.inst.components.inventoryitem.is_landed == false) --R08_ROT_TURNOFTIDES
	-- or self.inst:GetPosition().y > 3 --assume this is a falling item that didn't get its tag set
	or (self.inst.components.inventoryitem and self.inst.components.inventoryitem:IsHeld()) then
		return
	end
	
	if TheWorld.state.hurricane and TheWorld.state.gustspeed > 0 then
		local windspeed = TheWorld.state.gustspeed
		local windangle = TheWorld.state.gustangle * DEGREES
		self.velocity = Vector3(windspeed * math.cos(windangle), 0.0, windspeed * math.sin(windangle))
	elseif self.velocity:Length() > 0 then
		--dumb hack to make sure this item stops
		self.velocity = Vector3(0,0,0)
	else
		return
	end
	
	-- unbait from traps
	if self.inst.components.bait and self.inst.components.bait.trap then
		self.inst.components.bait.trap:RemoveBait()
	end

	if self.velocity:Length() > 1 then self.velocity = self.velocity:GetNormalized() end

	-- Map velocity magnitudes to a useful range of walkspeeds
	local curr_speed = self.averageSpeed
	--[[local player = ThePlayer
	if player and player.components.locomotor then
		curr_speed = (player.components.locomotor:GetRunSpeed() + TUNING.WILSON_WALK_SPEED) / 2
	end]]
	self.speed = Remap(self.velocity:Length(), 0, 1, 0, curr_speed) --maybe only if changing dir??

	-- Do some variation on the speed if velocity is a reasonable amount
	if self.velocity:Length() >= .5 then
		self.speedVarTime = self.speedVarTime + dt
		if self.speedVarTime > SPEED_VAR_PERIOD then 
			self.speedVarTime = 0
			self.speedVarPeriod = GetRandomWithVariance(SPEED_VAR_PERIOD, SPEED_VAR_PERIOD_VARIANCE)
		end
		local speedvar = math.sin(2*PI*(self.speedVarTime / self.speedVarPeriod))
		local mult = Remap(speedvar, -1, 1, self.minSpeedMult, self.maxSpeedMult)
		self.speed = self.speed * mult
	end

	-- Walk!	
	self.inst.Transform:SetRotation( math.atan2(self.velocity.z, self.velocity.x)/DEGREES )

	self.inst.Physics:SetMotorVel(self.speed,0,0)

	-- if self.speed > 3.0 then
		-- self:SpawnWindTrail(dt)
	-- end

	if not self.onwater and IsOnWater(self.inst) then
		self.onwater = true
		if self.inst.components.burnable and self.inst.components.burnable:IsBurning() then
  			self.inst.components.burnable:Extinguish() --Do this before anything that required the inventory item component, it gets removed when something is lit on fire and re-added when it's extinguished 
  		end

		if self.inst.components.inventoryitem then
			--set landed to false then true to force refresh this thing
			--setting poll_for_landing would delay it by a tick
			self.inst.components.inventoryitem:SetLanded(false)
			self.inst.components.inventoryitem:SetLanded(true)
		end

		if self.inst.components.floater ~= nil then
			local vx, vy, vz = self.inst.Physics:GetMotorVel()
			self.inst.Physics:SetMotorVel(0.5 * vx, 0, 0)
			self.inst:DoTaskInTime(1.0, function(inst)
				self.inst.Physics:SetMotorVel(0, 0, 0)
				-- if self.inst.components.inventoryitem then 
					-- self.inst.components.inventoryitem:OnHitWater()
				-- end
			end)
			self.inst:StopUpdatingComponent(self)
		end

	-- elseif not IsOnLand(self.inst) then
	else 
		local tile = TheWorld.Map:GetTileAtPoint(self.inst.Transform:GetWorldPosition())
		if tile == GROUND.VOLCANO_LAVA or tile == GROUND.IMPASSABLE or tile == GROUND.INVALID then
			self.inst:DoTaskInTime(0.5, function(inst)
				self.inst.Physics:SetMotorVel(0, 0, 0)
				if self.inst.components.inventoryitem then
					self.inst.components.inventoryitem:SetLanded(false)
					self.inst.components.inventoryitem:SetLanded(true)
				else
					self.inst:Remove()
				end
			end)
			self.inst:StopUpdatingComponent(self)
		end
	end
end

return BlowInWind
