local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local ZERO_DISTANCE = 10
local ZERO_DISTSQ = ZERO_DISTANCE * ZERO_DISTANCE

local OnUpdate_old
local function OnUpdate(self, dt, applyhealthdelta, ...)
    if IsInIAClimate(self.inst) then
		
		--if this edit causes conflicts, it's probably best to add the other mods changes to this edit -M
		
		self.externalheaterpower = 0
		self.delta = 0
		self.rate = 0

		if self.settemp ~= nil or
			self.inst.is_teleporting or
			(self.inst.components.health ~= nil and self.inst.components.health.invincible) then
			return
		end

		-- Can override range, e.g. in special containers
		local mintemp = self.mintemp
		local maxtemp = self.maxtemp
		local ambient_temperature = TheWorld.state.islandtemperature --THIS is the ONE line we needed to change

		local owner = self.inst.components.inventoryitem ~= nil and self.inst.components.inventoryitem.owner or nil
		if owner ~= nil and owner:HasTag("fridge") and not owner:HasTag("nocool") then
			-- Inside a fridge, excluding icepack ("nocool")
			-- Don't cool it below freezing unless ambient temperature is below freezing
			mintemp = math.max(mintemp, math.min(0, ambient_temperature))
			self.rate = owner:HasTag("lowcool") and -.5 * TUNING.WARM_DEGREES_PER_SEC or -TUNING.WARM_DEGREES_PER_SEC
		else
			-- Prepare to figure out the temperature where we are standing
			local x, y, z = self.inst.Transform:GetWorldPosition()
			local ents = self.usespawnlight and
				TheSim:FindEntities(x, y, z, ZERO_DISTANCE, nil, self.ignoreheatertags, { "HASHEATER", "spawnlight" }) or
				TheSim:FindEntities(x, y, z, ZERO_DISTANCE, { "HASHEATER" }, self.ignoreheatertags)
			if self.usespawnlight and #ents > 0 then
				for i, v in ipairs(ents) do
					if v.components.heater == nil and v:HasTag("spawnlight") then
						ambient_temperature = math.clamp(ambient_temperature, 10, TUNING.OVERHEAT_TEMP - 20)
						table.remove(ents, i)
						break
					end
				end
			end

			--print(ambient_temperature, "ambient_temperature")
			self.delta = (ambient_temperature + self.totalmodifiers + self:GetMoisturePenalty()) - self.current
			--print(self.delta + self.current, "initial target")

			if self.inst.components.inventory ~= nil then
				for k, v in pairs(self.inst.components.inventory.equipslots) do
					if v.components.heater ~= nil then
						local heat = v.components.heater:GetEquippedHeat()
						if heat ~= nil and
							((heat > self.current and v.components.heater:IsExothermic()) or
							(heat < self.current and v.components.heater:IsEndothermic())) then
							self.delta = self.delta + heat - self.current
						end
					end
				end
				for k, v in pairs(self.inst.components.inventory.itemslots) do
					if v.components.heater ~= nil then
						local heat, carriedmult = v.components.heater:GetCarriedHeat()
						if heat ~= nil and
							((heat > self.current and v.components.heater:IsExothermic()) or
							(heat < self.current and v.components.heater:IsEndothermic())) then
							self.delta = self.delta + (heat - self.current) * carriedmult
						end
					end
				end
				local overflow = self.inst.components.inventory:GetOverflowContainer()
				if overflow ~= nil then
					for k, v in pairs(overflow.slots) do
						if v.components.heater ~= nil then
							local heat, carriedmult = v.components.heater:GetCarriedHeat()
							if heat ~= nil and
								((heat > self.current and v.components.heater:IsExothermic()) or
								(heat < self.current and v.components.heater:IsEndothermic())) then
								self.delta = self.delta + (heat - self.current) * carriedmult
							end
						end
					end
				end
			end

			--print(self.delta + self.current, "after carried/equipped")

			-- Recently eaten temperatured food is inherently equipped heat/cold
			if self.bellytemperaturedelta ~= nil then
				self.delta = self.delta + self.bellytemperaturedelta
			end

			--print(self.delta + self.current, "after belly")

			-- If very hot (basically only when have overheating screen effect showing) and under shelter, cool slightly
			if self.sheltered and self.current > TUNING.TREE_SHADE_COOLING_THRESHOLD then
				self.delta = self.delta - (self.current - TUNING.TREE_SHADE_COOLER)
			end

			--print(self.delta + self.current, "after shelter")

			for i, v in ipairs(ents) do 
				if v ~= self.inst and
					not v:IsInLimbo() and
					v.components.heater ~= nil and
					(v.components.heater:IsExothermic() or v.components.heater:IsEndothermic()) then

					local heat = v.components.heater:GetHeat(self.inst)
					if heat ~= nil then
						-- This produces a gentle falloff from 1 to zero.
						local heatfactor = 1 - self.inst:GetDistanceSqToInst(v) / ZERO_DISTSQ
						if self.inst:GetIsWet() then
							heatfactor = heatfactor * TUNING.WET_HEAT_FACTOR_PENALTY
						end

						if v.components.heater:IsExothermic() then
							-- heating heatfactor is relative to 0 (freezing)
							local warmingtemp = heat * heatfactor
							if warmingtemp > self.current then
								self.delta = self.delta + warmingtemp - self.current
							end
							self.externalheaterpower = self.externalheaterpower + warmingtemp
						else--if v.components.heater:IsEndothermic() then
							-- cooling heatfactor is relative to overheattemp
							local coolingtemp = (heat - self.overheattemp) * heatfactor + self.overheattemp
							if coolingtemp < self.current then
								self.delta = self.delta + coolingtemp - self.current
							end
						end
					end
				end
			end

			--print(self.delta + self.current, "after heaters")

			-- Winter insulation only affects you when it's cold out, summer insulation only helps when it's warm
			if ambient_temperature >= TUNING.STARTING_TEMP then
				-- it's warm out
				if self.delta > 0 then
					-- If the player is heating up, defend using insulation.
					local winterInsulation, summerInsulation = self:GetInsulation()
					self.rate = math.min(self.delta, TUNING.SEG_TIME / (TUNING.SEG_TIME + summerInsulation))
				else
					-- If they are cooling, do it at full speed, and faster if they're overheated
					self.rate = math.max(self.delta, self.current >= self.overheattemp and -TUNING.THAW_DEGREES_PER_SEC or -TUNING.WARM_DEGREES_PER_SEC)
				end
			-- it's cold out
			elseif self.delta < 0 then
				-- If the player is cooling, defend using insulation.
				local winterInsulation, summerInsulation = self:GetInsulation()
				self.rate = math.max(self.delta, -TUNING.SEG_TIME / (TUNING.SEG_TIME + winterInsulation))
			else
				-- If they are heating up, do it at full speed, and faster if they're freezing
				self.rate = math.min(self.delta, self.current <= 0 and TUNING.THAW_DEGREES_PER_SEC or TUNING.WARM_DEGREES_PER_SEC)
			end

			--print(self.delta + self.current, "after insulation")
			--print(self.rate, "final rate\n\n")
		end

		self:SetTemperature(math.clamp(self.current + self.rate * dt, mintemp, maxtemp))

		--applyhealthdelta nil defaults to true
		if applyhealthdelta ~= false and self.inst.components.health ~= nil then
			if self.current < 0 then
				self.inst.components.health:DoDelta(-self.hurtrate * dt, true, "cold")
			elseif self.current > self.overheattemp then
				self.inst.components.health:DoDelta(-self.hurtrate * dt, true, "hot")
			end
		end
		
		
	else
		OnUpdate_old(self, dt, applyhealthdelta, ...)
	end
end


----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("temperature", function(cmp)


OnUpdate_old = cmp.OnUpdate
cmp.OnUpdate = OnUpdate


end)
