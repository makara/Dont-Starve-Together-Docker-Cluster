local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local tempcheckhacked = false
local function DoCheckTemp(self)
	if not self:HasTag("burnt") then
		if self:HasTag("flooded") then
			self.AnimState:SetPercent("meter", math.random())
			return
		end
		if self._iaclimate == nil then
			self._iaclimate = IsInIAClimate(self)
		end
		self.AnimState:SetPercent("meter", 1 - math.clamp(
			self._iaclimate and TheWorld.state.islandtemperature or TheWorld.state.temperature,
			0, TUNING.OVERHEAT_TEMP) / TUNING.OVERHEAT_TEMP)
	end
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddPrefabPostInit("winterometer", function(inst)


inst:AddComponent("floodable")

if TheWorld.ismastersim then

	inst.components.floodable:SetFX("shock_machines_fx",5)
	
	if not tempcheckhacked then
		for i, v in ipairs(inst.event_listening["animover"][inst]) do
			if UpvalueHacker.GetUpvalue(v, "DoCheckTemp") then
				-- StartCheckTemp = v
				tempcheckhacked = true
				UpvalueHacker.SetUpvalue(v, DoCheckTemp, "DoCheckTemp")
				break
			end
		end
	end
	
end


end)

