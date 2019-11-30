local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local _GetTargetMoisture
local function GetTargetMoisture(self, ...)
	-- if GetTime() <= (self.inst.spawntime or 0) then return 0 end

	local isheld = self.inst.components.inventoryitem:IsHeld()
    -- local owner = self.inst.components.inventoryitem.owner

	--Hack to counter floater not giving a damn about inventory
	if isheld and self.inst.components.floater and self.inst.components.floater:IsFloating() then
		return 0 --could use owner moisture as cap?
    elseif not isheld and not TheWorld.state.israining then
        if self.inst.Transform then
            local x, y, z = self.inst.Transform:GetWorldPosition()
            if x and y and z then
                if IsOnFlood(x, y, z) then
                    return TUNING.MOISTURE_MAX_WETNESS
                end
            end
        end
    end
	return _GetTargetMoisture(self, ...)
end

local _UpdateMoisture
local function UpdateMoisture(self, ...)
    local t = GetTime()
    local dt = t - self.lastUpdate
    if dt <= 0 then
        return _UpdateMoisture(self, ...)
    end

    if self.inst:IsValid() and not self.inst.components.inventoryitem:IsHeld() and self.inst.components.floater and self.inst.components.floater:IsFloating() then
        self.lastUpdate = t
        if self.moisture < TUNING.MOISTURE_MAX_WETNESS then
            self:SetMoisture(TUNING.MOISTURE_MAX_WETNESS)
        end
    else
        if not self.inst.components.inventoryitem:IsHeld() then
            if self.inst.Transform then
                local x, y, z = self.inst.Transform:GetWorldPosition()
                if x and y and z then
					if IsOnFlood(x, y, z) then
                        local moisture = math.max(self.moisture, TUNING.MOISTURE_FLOOD_WETNESS)
                        if self.moisture < moisture then
                            self:SetMoisture(moisture)
                        end
                    end
                end
            end
        end
        return _UpdateMoisture(self, ...)
    end
end


----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("inventoryitemmoisture", function(cmp)


_GetTargetMoisture = cmp.GetTargetMoisture
cmp.GetTargetMoisture = GetTargetMoisture

_UpdateMoisture = cmp.UpdateMoisture
cmp.UpdateMoisture = UpdateMoisture


end)
