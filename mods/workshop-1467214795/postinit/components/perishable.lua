local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local Update_old

--have to copy the entire function because of several temperature checks
local function Update_IA(inst, dt)
	if not IsInIAClimate(inst) then
		Update_old(inst, dt)
	else
		if inst.components.perishable then
			
			local modifier = 1
			local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner or nil
			if not owner and inst.components.occupier then
				owner = inst.components.occupier:GetOwner()
			end

			if owner then
				if owner:HasTag("fridge") then
					if inst:HasTag("frozen") and not owner:HasTag("nocool") and not owner:HasTag("lowcool") then
						modifier = TUNING.PERISH_COLD_FROZEN_MULT
					else
						modifier = TUNING.PERISH_FRIDGE_MULT
					end
				elseif owner:HasTag("spoiler") then
					modifier = TUNING.PERISH_GROUND_MULT 
				elseif owner:HasTag("cage") and inst:HasTag("small_livestock") then
					modifier = TUNING.PERISH_CAGE_MULT
				end
			else
				modifier = TUNING.PERISH_GROUND_MULT 
			end

			if inst:GetIsWet() then
				modifier = modifier * TUNING.PERISH_WET_MULT
			end

			
			if TheWorld.state.islandtemperature < 0 then
				if inst:HasTag("frozen") and not inst.components.perishable.frozenfiremult then
					modifier = TUNING.PERISH_COLD_FROZEN_MULT
				else
					modifier = modifier * TUNING.PERISH_WINTER_MULT
				end
			end

			if inst.components.perishable.frozenfiremult then
				modifier = modifier * TUNING.PERISH_FROZEN_FIRE_MULT
			end

			if TheWorld.state.islandtemperature > TUNING.OVERHEAT_TEMP then
				modifier = modifier * TUNING.PERISH_SUMMER_MULT
			end

			modifier = modifier * inst.components.perishable.localPerishMultiplyer

			modifier = modifier * TUNING.PERISH_GLOBAL_MULT
			
			local old_val = inst.components.perishable.perishremainingtime
			local delta = dt or (10 + math.random()*FRAMES*8)
			if inst.components.perishable.perishremainingtime then 
				inst.components.perishable.perishremainingtime = inst.components.perishable.perishremainingtime - delta*modifier
				if math.floor(old_val*100) ~= math.floor(inst.components.perishable.perishremainingtime*100) then
					inst:PushEvent("perishchange", {percent = inst.components.perishable:GetPercent()})
				end
			end

			-- Cool off hot foods over time (faster if in a fridge)
			if inst.components.edible and inst.components.edible.temperaturedelta and inst.components.edible.temperaturedelta > 0 then
				if owner and owner:HasTag("fridge") then
					if not owner:HasTag("nocool") then
						inst.components.edible.temperatureduration = inst.components.edible.temperatureduration - 1
					end
				elseif TheWorld.state.islandtemperature < TUNING.OVERHEAT_TEMP - 5 then
					inst.components.edible.temperatureduration = inst.components.edible.temperatureduration - .25
				end
				if inst.components.edible.temperatureduration < 0 then inst.components.edible.temperatureduration = 0 end
			end
			
			--trigger the next callback
			if inst.components.perishable.perishremainingtime and inst.components.perishable.perishremainingtime <= 0 then
				inst.components.perishable:Perish()
			end
		end
    end
end

local LongUpdate_old
local function LongUpdate(self, dt)
	if IsInIAClimate(self.inst) then
		if self.updatetask ~= nil then
			Update_IA(self.inst, dt or 0)
		end
	else
		LongUpdate_old(self, dt)
	end
end

local StartPerishing_old
local function StartPerishing(self, ...)
	StartPerishing_old(self, ...)
	Update_old = self.updatetask.fn or Update_old
	self.updatetask.fn = Update_IA
end


----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("perishable", function(cmp)


LongUpdate_old = cmp.LongUpdate
cmp.LongUpdate = LongUpdate
StartPerishing_old = cmp.StartPerishing
cmp.StartPerishing = StartPerishing


end)
