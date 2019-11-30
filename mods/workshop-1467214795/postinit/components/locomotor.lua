local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local SPEED_MOD_TIMER_DT = FRAMES

local _GetSpeedMultiplier

----------------------------------------------------------------------------------------
--These functions have a server variant and a client variant

local function onhasmomentum_ms(self, hasmomentum)
	if self.inst.player_classified ~= nil then
		self.inst.player_classified.hasmomentum:set(hasmomentum)
	end
end

local function ondisable_ms(self, disable)
	if self.inst.player_classified ~= nil then
		self.inst.player_classified.disable:set(disable)
	end
end

local function onexternalspeedadder_ms(self, externalspeedadder)
	if self.inst.player_classified ~= nil then
		self.inst.player_classified.externalspeedadder:set(externalspeedadder)
	end
end

local function onexternalaccelerationadder_ms(self, externalaccelerationadder)
	if self.inst.player_classified ~= nil then
		self.inst.player_classified.externalaccelerationadder:set(externalaccelerationadder)
	end
end

local function onexternalaccelerationmultiplier_ms(self, externalaccelerationmultiplier)
	if self.inst.player_classified ~= nil then
		self.inst.player_classified.externalaccelerationmultiplier:set(externalaccelerationmultiplier)
	end
end

local function onexternaldecelerationadder_ms(self, externaldecelerationadder)
	if self.inst.player_classified ~= nil then
		self.inst.player_classified.externaldecelerationadder:set(externaldecelerationadder)
	end
end

local function onexternaldecelerationmultiplier_ms(self, externaldecelerationmultiplier)
	if self.inst.player_classified ~= nil then
		self.inst.player_classified.externaldecelerationmultiplier:set(externaldecelerationmultiplier)
	end
end

local function HasMomentum_ms(self)
	return self.hasmomentum
end

local function IsDisabled_ms(self)
	return self.disable
end

local function ExternalSpeedAdder_ms(self)
	return self.externalspeedadder
end

local function GetSpeedAdder_ms(self)
	local add = self:ExternalSpeedAdder()
	return add
end

local function ExternalAccelerationAdder_ms(self)
	return self.externalaccelerationadder
end

local function GetAccelerationAdder_ms(self)
	local add = self:ExternalAccelerationAdder()
	return add
end

local function ExternalAccelerationMultiplier_ms(self)
	return self.externalaccelerationmultiplier
end

local function GetAccelerationMultiplier_ms(self)
	local mult = self:ExternalAccelerationMultiplier()
	return mult
end

local function ExternalDecelerationAdder_ms(self)
	return self.externaldecelerationadder
end

local function GetDecelerationAdder_ms(self)
	local add = self:ExternalDecelerationAdder()
	return add
end

local function ExternalDecelerationMultiplier_ms(self)
	return self.externaldecelerationmultiplier
end

local function GetDecelerationMultiplier_ms(self)
	local mult = self:ExternalDecelerationMultiplier()
	return mult
end

local function GetSpeedMultiplier_ms(self)
	local windmult = 1
	
	if TheWorld.state.hurricane and IsInIAClimate(self.inst) then
		local windangle = self.inst.Transform:GetRotation() - TheWorld.state.gustangle
		local windspeed = TheWorld.state.gustspeed
		local windproofness = 1.0
		if not self.inst.components.sailor or not self.inst.components.sailor:IsSailing() then 
			if self.inst.components.inventory then
				windproofness = 1.0 - self.inst.components.inventory:GetWindproofness()
			end
		end 
		local windfactor = TUNING.WIND_PUSH_MULTIPLIER * windproofness * windspeed * math.cos(windangle * DEGREES) + 1.0
		windmult = math.max(0.1, windfactor)
		-- if self.inst:HasTag("player") then
			-- print(string.format("Loco wind angle %4.2f, factor %4.2f (%4.2f), %s\n", windangle, windfactor, math.cos(windangle * DEGREES) + 1.0, self.inst.prefab))
		-- end
	end
	if self.inst.player_classified ~= nil then
		--TODO This would probably be a lot easier on the network if we just send the windproofness -M
		self.inst.player_classified.windspeedmult:set(windmult)
	end

    local tarmult = 1
    if self.inst.slowing_objects and next(self.inst.slowing_objects) then
        tarmult = TUNING.SLOWING_OBJECT_SLOWDOWN
    end

	local floodmult = 1
	if TheWorld.components.flooding and TheWorld.components.flooding:IsPointOnFlood(self.inst:GetPosition():Get()) then
		floodmult = TUNING.FLOOD_SPEED_MULTIPLIER
	end

	return _GetSpeedMultiplier(self) * windmult * floodmult * tarmult
end

----------------------------------------------------------------------------------------

-- if not TheNet:IsDedicated() then
--dedicated implies server, so we can safely skip these on dedicated
--well, we could, if we declare the local variables outside, but I'm too lazy for that -M


local function HasMomentum_client(self)
	return self.inst.player_classified ~= nil and self.inst.player_classified.hasmomentum:value() or self.hasmomentum
end

local function IsDisabled_client(self)
	return self.inst.player_classified ~= nil and self.inst.player_classified.disable:value() or self.disable
end

local function ExternalSpeedAdder_client(self)
	return self.inst.player_classified ~= nil and self.inst.player_classified.externalspeedadder:value() or self.externalspeedadder
end

local function GetSpeedAdder_client(self)
	local add = self:ExternalSpeedAdder()
	return add
end

local function ExternalAccelerationAdder_client(self)
	return self.inst.player_classified ~= nil and self.inst.player_classified.externalaccelerationadder:value() or self.externalaccelerationadder
end

local function GetAccelerationAdder_client(self)
	local add = self:ExternalAccelerationAdder()
	return add
end

local function ExternalAccelerationMultiplier_client(self)
	return self.inst.player_classified ~= nil and self.inst.player_classified.externalaccelerationmultiplier:value() or self.externalaccelerationmultiplier
end

local function GetAccelerationMultiplier_client(self)
	local mult = self:ExternalAccelerationMultiplier()
	return mult
end

local function ExternalDecelerationAdder_client(self)
	return self.inst.player_classified ~= nil and self.inst.player_classified.externaldecelerationadder:value() or self.externaldecelerationadder
end

local function GetDecelerationAdder_client(self)
	local add = self:ExternalDecelerationAdder()
	return add
end

local function ExternalDecelerationMultiplier_client(self)
	return self.inst.player_classified ~= nil and self.inst.player_classified.externaldecelerationmultiplier:value() or self.externaldecelerationmultiplier
end

local function GetDecelerationMultiplier_client(self)
	local mult = self:ExternalDecelerationMultiplier()
	return mult
end

local function GetWindMult_client(self)
	return self.inst.player_classified ~= nil and self.inst.player_classified.windspeedmult:value() or nil
end

local function GetSpeedMultiplier_client(self)
	local windmult = self:GetWindMult()
	
	if windmult == nil then
		windmult = 1
		if TheWorld.state.hurricane and IsInIAClimate(self.inst) then
			local windangle = self.inst.Transform:GetRotation() - TheWorld.state.gustangle
			local windspeed = TheWorld.state.gustspeed
			local windproofness = 1.0
			--Client does not have these components, but at least we can calculate the angle -M
			-- if not self.inst.components.sailor or not self.inst.components.sailor:IsSailing() then 
				-- if self.inst.components.inventory then
					-- windproofness = 1.0 - self.inst.components.inventory:GetWindproofness()
				-- end
			-- end
			local windfactor = TUNING.WIND_PUSH_MULTIPLIER * windproofness * windspeed * math.cos(windangle * DEGREES) + 1.0
			windmult = math.max(0.1, windfactor)
		end
	end

    local tarmult = 1
    if self.inst.slowing_objects and next(self.inst.slowing_objects) then
        tarmult = TUNING.SLOWING_OBJECT_SLOWDOWN
    end

	local floodmult = 1
	if TheWorld.components.flooding and TheWorld.components.flooding:IsPointOnFlood(self.inst:GetPosition():Get()) then
		floodmult = TUNING.FLOOD_SPEED_MULTIPLIER
	end
	
	return _GetSpeedMultiplier(self) * windmult * floodmult
end


-- end

----------------------------------------------------------------------------------------

local _StopMoving
local function StopMoving(self)
    self.slowing = false
    _StopMoving(self)
end

local function SetExternalAccelerationAdder(self, source, key, a)
    if key == nil then
        return
    elseif a == nil or a == 0 then
        self:RemoveExternalAccelerationAdder(source, key)
        return
    end
    local src_params = self._externalaccelerationadders[source]
    if src_params == nil then
        self._externalaccelerationadders[source] = {
            adders = {[key] = a},
            onremove = function(source)
                self._externalaccelerationadders[source] = nil
                self.externalaccelerationadder = self:RecalculateExternalAccelerationAdder(self._externalaccelerationadders)
            end,}
        self.inst:ListenForEvent("onremove", self._externalaccelerationadders[source].onremove, source)
        self.externalaccelerationadder = self:RecalculateExternalAccelerationAdder(self._externalaccelerationadders)
    elseif src_params.adders[key] ~= a then
        src_params.adders[key] = a
        self.externalaccelerationadder = self:RecalculateExternalAccelerationAdder(self._externalaccelerationadders)
    end
end

local function RemoveExternalAccelerationAdder(self, source, key)
    local src_params = self._externalaccelerationadders[source]
    if src_params == nil then
        return
    elseif key ~= nil then
        src_params.adders[key] = nil
        if next(src_params.adders) ~= nil then
            --this source still has other keys
            self.externalaccelerationadder = self:RecalculateExternalAccelerationAdder(self._externalaccelerationadders)
            return
        end
    end
    --remove the entire source
    self.inst:RemoveEventCallback("onremove", src_params.onremove, source)
    self._externalaccelerationadders[source] = nil
    self.externalaccelerationadder = self:RecalculateExternalAccelerationAdder(self._externalaccelerationadders)
end

local function RecalculateExternalAccelerationAdder(self, sources)
    local a = 0
    for source, src_params in pairs(sources) do
        for k, v in pairs(src_params.adders) do
            a = a + v
        end
    end
    return a
end

local function GetExternalAccelerationAdder(self, source, key)
    local src_params = self._externalaccelerationadders[source]
    if src_params == nil then
        return 0
    elseif key == nil then
        local a = 0
        for k, v in pairs(src_params.adders) do
            a = a + v
        end
        return a
    end
    return src_params.adders[key] or 0
end

local function SetExternalAccelerationMultiplier(self, source, key, m)
    if key == nil then
        return
    elseif m == nil or m == 1 then
        self:RemoveExternalAccelerationMultiplier(source, key)
        return
    end
    local src_params = self._externalaccelerationmultipliers[source]
    if src_params == nil then
        self._externalaccelerationmultipliers[source] = {
            multipliers = {[key] = m},
            onremove = function(source)
                self._externalaccelerationmultipliers[source] = nil
                self.externalaccelerationmultiplier = self:RecalculateExternalAccelerationMultiplier(self._externalaccelerationmultipliers)
            end,}
        self.inst:ListenForEvent("onremove", self._externalaccelerationmultipliers[source].onremove, source)
        self.externalaccelerationmultiplier = self:RecalculateExternalAccelerationMultiplier(self._externalaccelerationmultipliers)
    elseif src_params.multipliers[key] ~= m then
        src_params.multipliers[key] = m
        self.externalaccelerationmultiplier = self:RecalculateExternalAccelerationMultiplier(self._externalaccelerationmultipliers)
    end
end

local function RemoveExternalAccelerationMultiplier(self, source, key)
    local src_params = self._externalaccelerationmultipliers[source]
    if src_params == nil then
        return
    elseif key ~= nil then
        src_params.multipliers[key] = nil
        if next(src_params.multipliers) ~= nil then
            --this source still has other keys
            self.externalaccelerationmultiplier = self:RecalculateExternalAccelerationMultiplier(self._externalaccelerationmultipliers)
            return
        end
    end
    --remove the entire source
    self.inst:RemoveEventCallback("onremove", src_params.onremove, source)
    self._externalaccelerationmultipliers[source] = nil
    self.externalaccelerationmultiplier = self:RecalculateExternalAccelerationMultiplier(self._externalaccelerationmultipliers)
end

local function RecalculateExternalAccelerationMultiplier(self, sources)
    local m = 1
    for source, src_params in pairs(sources) do
        for k, v in pairs(src_params.multipliers) do
            m = m * v
        end
    end
    return m
end

local function GetExternalAccelerationMultiplier(self, source, key)
    local src_params = self._externalaccelerationmultipliers[source]
    if src_params == nil then
        return 1
    elseif key == nil then
        local m = 1
        for k, v in pairs(src_params.multipliers) do
            m = m * v
        end
        return m
    end
    return src_params.multipliers[key] or 1
end

local function SetExternalDecelerationAdder(self, source, key, a)
    if key == nil then
        return
    elseif a == nil or a == 0 then
        self:RemoveExternalDecelerationAdder(source, key)
        return
    end
    local src_params = self._externaldecelerationadders[source]
    if src_params == nil then
        self._externaldecelerationadders[source] = {
            adders = {[key] = a},
            onremove = function(source)
                self._externaldecelerationadders[source] = nil
                self.externaldecelerationadder = self:RecalculateExternalDecelerationAdder(self._externaldecelerationadders)
            end,}
        self.inst:ListenForEvent("onremove", self._externaldecelerationadders[source].onremove, source)
        self.externaldecelerationadder = self:RecalculateExternalDecelerationAdder(self._externaldecelerationadders)
    elseif src_params.adders[key] ~= a then
        src_params.adders[key] = a
        self.externaldecelerationadder = self:RecalculateExternalDecelerationAdder(self._externaldecelerationadders)
    end
end

local function RemoveExternalDecelerationAdder(self, source, key)
    local src_params = self._externaldecelerationadders[source]
    if src_params == nil then
        return
    elseif key ~= nil then
        src_params.adders[key] = nil
        if next(src_params.adders) ~= nil then
            --this source still has other keys
            self.externaldecelerationadder = self:RecalculateExternalDecelerationAdder(self._externaldecelerationadders)
            return
        end
    end
    --remove the entire source
    self.inst:RemoveEventCallback("onremove", src_params.onremove, source)
    self._externaldecelerationadders[source] = nil
    self.externaldecelerationadder = self:RecalculateExternalDecelerationAdder(self._externaldecelerationadders)
end

local function RecalculateExternalDecelerationAdder(self, sources)
    local a = 0
    for source, src_params in pairs(sources) do
        for k, v in pairs(src_params.adders) do
            a = a + v
        end
    end
    return a
end

local function GetExternalDecelerationAdder(self, source, key)
    local src_params = self._externaldecelerationadders[source]
    if src_params == nil then
        return 0
    elseif key == nil then
        local a = 0
        for k, v in pairs(src_params.adders) do
            a = a + v
        end
        return a
    end
    return src_params.adders[key] or 0
end

local function SetExternalDecelerationMultiplier(self, source, key, m)
    if key == nil then
        return
    elseif m == nil or m == 1 then
        self:RemoveExternalDecelerationMultiplier(source, key)
        return
    end
    local src_params = self._externaldecelerationmultipliers[source]
    if src_params == nil then
        self._externaldecelerationmultipliers[source] = {
            multipliers = {[key] = m},
            onremove = function(source)
                self._externaldecelerationmultipliers[source] = nil
                self.externaldecelerationmultiplier = self:RecalculateExternalDecelerationMultiplier(self._externaldecelerationmultipliers)
            end,}
        self.inst:ListenForEvent("onremove", self._externaldecelerationmultipliers[source].onremove, source)
        self.externaldecelerationmultiplier = self:RecalculateExternalDecelerationMultiplier(self._externaldecelerationmultipliers)
    elseif src_params.multipliers[key] ~= m then
        src_params.multipliers[key] = m
        self.externaldecelerationmultiplier = self:RecalculateExternalDecelerationMultiplier(self._externaldecelerationmultipliers)
    end
end

local function RemoveExternalDecelerationMultiplier(self, source, key)
    local src_params = self._externaldecelerationmultipliers[source]
    if src_params == nil then
        return
    elseif key ~= nil then
        src_params.multipliers[key] = nil
        if next(src_params.multipliers) ~= nil then
            --this source still has other keys
            self.externaldecelerationmultiplier = self:RecalculateExternalDecelerationMultiplier(self._externaldecelerationmultipliers)
            return
        end
    end
    --remove the entire source
    self.inst:RemoveEventCallback("onremove", src_params.onremove, source)
    self._externaldecelerationmultipliers[source] = nil
    self.externaldecelerationmultiplier = self:RecalculateExternalDecelerationMultiplier(self._externaldecelerationmultipliers)
end

local function RecalculateExternalDecelerationMultiplier(self, sources)
    local m = 1
    for source, src_params in pairs(sources) do
        for k, v in pairs(src_params.multipliers) do
            m = m * v
        end
    end
    return m
end

local function GetExternalDecelerationMultiplier(self, source, key)
    local src_params = self._externaldecelerationmultipliers[source]
    if src_params == nil then
        return 1
    elseif key == nil then
        local m = 1
        for k, v in pairs(src_params.multipliers) do
            m = m * v
        end
        return m
    end
    return src_params.multipliers[key] or 1
end

local function GetDeceleration(self)
    local add = self:GetDecelerationAdder()
    local mult = self:GetDecelerationMultiplier()
    return (self.deceleration + add) * mult
end

local function GetAcceleration(self)
    local add = self:GetAccelerationAdder()
    local mult = self:GetAccelerationMultiplier()
    return (self.acceleration + add) * mult
end

local _Stop
local function Stop(self, sgparams, stopmomentum)
    if self:HasMomentum() and not stopmomentum then
        self.slowing = true
    elseif (not self:HasMomentum()) or stopmomentum then
        self.momentumvelocity = nil
        _Stop(self, sgparams)
    end
end

local _SetExternalSpeedMultiplier
local function SetExternalSpeedMultiplier(self, source, key, m, timer)
    if key == nil then
        return
    elseif m == nil or m == 1 then
        self:RemoveExternalSpeedMultiplier(source, key)
        return
    end
    _SetExternalSpeedMultiplier(self, source, key, m)
    if timer then
        local externaltimers = self.externalspeedmultipliers_timer[source]
        if externaltimers == nil then
            self.externalspeedmultipliers_timer[source] = {
                timers = {[key] = timer},
                onremove = function(source)
                    self.externalspeedmultipliers_timer[source] = nil
                end,}
                self.inst:ListenForEvent("onremove", self.externalspeedmultipliers_timer[source].onremove, source)
            else
                externaltimers.timers[key] = timer
            end

            if not self.updating_mods_task then
            self.updating_mods_task = self.inst:DoPeriodicTask(SPEED_MOD_TIMER_DT, function() self:UpdateSpeedModifierTimers(SPEED_MOD_TIMER_DT) end)
        end
    end
end
local _RemoveExternalSpeedMultiplier
local function RemoveExternalSpeedMultiplier(self, source, key)
    local src_params = self._externalspeedmultipliers[source]
    if src_params == nil then
        return
    end
    if key == nil then
        if self.externalspeedmultipliers_timer[source] then
            self.inst:RemoveEventCallback("onremove", self.externalspeedmultipliers_timer[source].onremove, source)
            self.externalspeedmultipliers_timer[source] = nil
        end
    end
    if key ~= nil then
        if self.externalspeedmultipliers_timer[source] and self.externalspeedmultipliers_timer[source].timers[key] then
            self.externalspeedmultipliers_timer[source].timers[key] = nil
        end
    end
    _RemoveExternalSpeedMultiplier(self, source, key)
end

local function SetExternalSpeedAdder(self, source, key, a, timer)
    if key == nil then
        return
    elseif a == nil or a == 0 then
        self:RemoveExternalSpeedAdder(source, key)
        return
    end
    local src_params = self._externalspeedadders[source]
    if src_params == nil then
        self._externalspeedadders[source] = {
            adders = {[key] = a},
            onremove = function(source)
                self._externalspeedadders[source] = nil
                self.externalspeedadder = self:RecalculateExternalSpeedAdder(self._externalspeedadders)
            end,}
        self.inst:ListenForEvent("onremove", self._externalspeedadders[source].onremove, source)
        self.externalspeedadder = self:RecalculateExternalSpeedAdder(self._externalspeedadders)
    elseif src_params.adders[key] ~= a then
        src_params.adders[key] = a
        self.externalspeedadder = self:RecalculateExternalSpeedAdder(self._externalspeedadders)
    end

    if timer then
        local externaltimers = self.externalspeedadder_timer[source]
        if externaltimers == nil then
            self.externalspeedadder_timer[source] = {
                timers = {[key] = timer},
                onremove = function(source)
                    self.externalspeedadder_timer[source] = nil
                end,}
            self.inst:ListenForEvent("onremove", self.externalspeedadder_timer[source].onremove, source)
        else
            externaltimers.timers[key] = timer
        end

        if not self.updating_mods_task then
            self.updating_mods_task = self.inst:DoPeriodicTask(SPEED_MOD_TIMER_DT, function() self:UpdateSpeedModifierTimers(SPEED_MOD_TIMER_DT) end)
        end
    end
end

local function RemoveExternalSpeedAdder(self, source, key)
    local src_params = self._externalspeedadders[source]
    if src_params == nil then
        return
    elseif key ~= nil then
        src_params.adders[key] = nil
        if self.externalspeedadder_timer[source] and self.externalspeedadder_timer[source].timers[key] then
            self.externalspeedadder_timer[source].timers[key] = nil
        end
        if next(src_params.adders) ~= nil then
			--this source still has other keys
			self.externalspeedadder = self:RecalculateExternalSpeedAdder(self._externalspeedadders)
			return
        end
    end
    --remove the entire source
    self.inst:RemoveEventCallback("onremove", src_params.onremove, source)
    if self.externalspeedadder_timer[source] then
        self.inst:RemoveEventCallback("onremove", self.externalspeedadder_timer[source].onremove, source)
        self.externalspeedadder_timer[source] = nil
    end
    self._externalspeedadders[source] = nil
    self.externalspeedadder = self:RecalculateExternalSpeedAdder(self._externalspeedadders)
end

local function GetExternalSpeedAdder(self, source, key)
    local src_params = self._externalspeedadders[source]
    if src_params == nil then
        return 0
    elseif key == nil then
        local a = 0
        for k, v in pairs(src_params.adders) do
            a = a + v
        end
        return a
    end
    return src_params.adders[key] or 0
end

local function RecalculateExternalSpeedAdder(self, sources)
    local a = 0
    for source, src_params in pairs(sources) do
        for k, v in pairs(src_params.adders) do
            a = a + v
        end
    end
    return a
end

local function UpdateSpeedModifierTimers(self, dt)
    local function CheckForRemainingTimers()
        for k, source in pairs(self.externalspeedadder_timer) do
            for key, time in pairs(source.timers) do
                if time > 0 then
                    return true
                end
            end
        end

        for k, source in pairs(self.externalspeedmultipliers_timer) do
            for key, time in pairs(source.timers) do
                if time > 0 then
                    return true
                end
            end
        end

        return false
    end

    for k, source in pairs(self.externalspeedadder_timer) do
        for key, time in pairs(source.timers) do
            source.timers[key] = time - dt
            if source.timers[key] <= 0 then
                self:RemoveExternalSpeedAdder(k, key)
                if not CheckForRemainingTimers() then
                    return
                end
            end
        end
    end

    for k, source in pairs(self.externalspeedmultipliers_timer) do
        for key, time in pairs(source.timers) do
            source.timers[key] = time - dt
            if source.timers[key] <= 0 then
                self:RemoveExternalSpeedMultiplier(k, key)
                if not CheckForRemainingTimers() then
                    return
                end
            end
        end
    end

    if not CheckForRemainingTimers() then
		--Why is this only done here and not in the above returns too? -M
        self.updating_mods_task:Cancel()
        self.updating_mods_task = nil
    end
end

local function OnSave(self)
    return {
        _externalspeedmultipliers = self._externalspeedmultipliers[self.inst] and self._externalspeedmultipliers[self.inst].multipliers or nil,
        externalspeedmultipliers_timer = self.externalspeedmultipliers_timer[self.inst] and self.externalspeedmultipliers_timer[self.inst].timers or nil,
        
        _externalspeedadders = self._externalspeedadders[self.inst] and self._externalspeedadders[self.inst].adders or nil,
        externalspeedadder_timer = self.externalspeedadder_timer[self.inst] and self.externalspeedadder_timer[self.inst].timers or nil,
    }
end

local function OnLoad(self, data)
    if data._externalspeedmultipliers then
        for key, mult in pairs(data._externalspeedmultipliers) do
            local timer = data.externalspeedmultipliers_timer and data.externalspeedmultipliers_timer[key] or nil
            --we only want to load speed values that have a timer.
            if timer then
                self:SetExternalSpeedMultiplier(self.inst, key, mult, timer)
            end
        end
    end

    if data._externalspeedadders then
        for key, add in pairs(data._externalspeedadders) do
            local timer = data.externalspeedadder_timer and data.externalspeedadder_timer[key] or nil
            --we only want to load speed values that have a timer.
            if timer then
                self:SetExternalSpeedAdder(self.inst, key, add, timer)
            end
        end
    end
end

local function LongUpdate(self, dt)
    if self.updating_mods_task then
        self:UpdateSpeedModifierTimers(dt)
    end
end

local function GetWalkSpeed(self)
    return (self.walkspeed + self:GetSpeedAdder()) * self:GetSpeedMultiplier()
end

local function GetRunSpeed(self)
    return (self:RunSpeed() + self:GetSpeedAdder()) * self:GetSpeedMultiplier()
end

local _PreviewAction
local function PreviewAction(self, bufferedaction, run, try_instant)
    _PreviewAction(self, bufferedaction, run, try_instant)

    if bufferedaction.action == ACTIONS.LOOKAT and
    self.inst.sg ~= nil and
    self.inst.components.playercontroller ~= nil and
    not self.inst.components.playercontroller.directwalking and bufferedaction.target ~= nil then
        local boat = nil

        if self.inst.replica.sailor then
            boat = self.inst.replica.sailor:GetBoat()
        end

        if boat and not boat.replica.sailable:HasSailor() then
            boat.Transform:SetRotation(self.inst.Transform:GetRotation())
        end
    end
end

local function HandleDisembark(inst)
    if TheWorld.ismastersim then
        inst:PushEvent("hitcoastline")
    elseif inst:HasTag("player") and IA_CONFIG.autodisembark ~= false then
        SendModRPCToServer(MOD_RPC["Island Adventure"]["ClientRequestDisembark"])
    end
end

local function TryGetNewDest(inst, radius, tolerance)
    local tryRadius = radius or (inst.trygetawayfromshore and 2) or 4
    local tryAngle = GetProperAngle(inst.Transform:GetRotation() + 90)
    local pt = inst:GetPosition()

    tolerance = tolerance or tryRadius/3

    local result_offset, result_angle, deflected = FindWalkableOffset(pt, tryAngle*DEGREES, tryRadius, 8, true, false, IsPositionValidForEnt(inst, tolerance))

    if result_offset then
        local destPoint = pt + result_offset

        if not inst.trygetawayfromshore then
            inst.components.locomotor:GoToPoint(destPoint)
            inst.trygetawayfromshore = true
            return true
        else
            inst.components.locomotor:Stop()
            if inst.Physics then
                inst.Physics:Teleport(destPoint:Get())
            else
                inst.Transform:SetPosition(destPoint:Get())
            end

            inst.trygetawayfromshore = nil

            inst.takeabreak = true
            inst:DoTaskInTime(1, function() inst.takeabreak = nil end)
            return true
        end
    elseif not inst.trygetawayfromshore then
        inst.trygetawayfromshore = true
        return false
    elseif not inst.takeabreak then
        --we dont want to spam the log a ton with followers we can't kill.
        if inst.components.follower == nil or inst.components.follower.leader == nil then
            print(tostring(inst).." is stuck! HELP!")
        end

        inst.takeabreak = true

        inst:DoTaskInTime(5, function()
            if TryGetNewDest(inst, 4, 1) then
                inst.trygetawayfromshore = nil
                inst:DoTaskInTime(1, function() inst.takeabreak = nil end)
            else
                if inst.components.follower == nil or inst.components.follower.leader == nil then
                    print("Attempting to teleport "..tostring(inst).." to safety...")
                end
                --TODO: handle stuff needing to teleport to water instead of land.
                local radius = 3
                local testwaterfn = function(offset)
                    local test_point = pt + offset
                    if IsOnWater(test_point.x, test_point.y, test_point.z) then
                        return false
                    end
                    return true 
                end
                local result_offset = FindValidPositionByFan(0, radius, 12, testwaterfn)
                --try again with wider radii, just to be sure
                if not result_offset then
                    for radius = 8, 20, 4 do
                        result_offset = FindValidPositionByFan(0, radius, 12, testwaterfn)
                        --we got a winner, stop the loop
                        if result_offset then
                            break
                        end
                    end
                end

                --save or drown
                if result_offset then
                    --small visual FX so players recognise this as failsafe
                    SpawnAt("sand_puff", inst)
                    inst.Transform:SetPosition((result_offset + pt):Get())
                    inst.components.locomotor:Stop()
                    inst:DoTaskInTime(1, function() inst.takeabreak = nil end)
                elseif inst.components.follower == nil or inst.components.follower.leader == nil then
                    print("Not able to rescue "..tostring(inst).."... RIP...")
                    --hopefully nobody tries trawling this guy -M
                    SpawnAt("splash_water_sink", inst)
                    inst:DoTaskInTime(0.5, function() inst:Remove() end)
                else
                    inst.components.locomotor:Stop()
                    inst:DoTaskInTime(5, function() inst.takeabreak = nil end)
                end
            end
        end)

    return false
    end
end

local _WantsToMoveForward
local function WantsToMoveForward(self)
    if self.inst.takeabreak then
        return false
    end

    if TheWorld.ismastersim and not TryMoveOnTile(self.inst, GetVisualTileType(self.inst.Transform:GetWorldPosition())) and not self.inst:HasTag("player") then
        self.inst:PushEvent("hitcoastline")

        return TryGetNewDest(self.inst)
    end

    if self.inst.trygetawayfromshore then
        self.inst.trygetawayfromshore = nil
    end

    return _WantsToMoveForward(self)
end

local _OnUpdate
local function OnUpdate(self, dt)
    if self:IsDisabled() then return end
    --all these return _OnUpdate(self, dt) are basicaly a way to prevent execution from reaching our momentum code if it shouldnt...
    if not self.inst:IsValid() then
        return _OnUpdate(self, dt)
    end
    local dsq = 0 --distance to target, squared 
    if self.dest then
        --Print(VERBOSITY.DEBUG, "    w dest")
        if not self.dest:IsValid() or (self.bufferedaction and not self.bufferedaction:IsValid()) then
            return _OnUpdate(self, dt)
        end

        if self.inst.components.health and self.inst.components.health:IsDead() then
            return _OnUpdate(self, dt)
        end

        local destpos_x, destpos_y, destpos_z = self.dest:GetPoint()
        local mypos_x, mypos_y, mypos_z = self.inst.Transform:GetWorldPosition()
        dsq = distsq(destpos_x, destpos_z, mypos_x, mypos_z)
    end

    --OKAY SO:
    --we make GetMotorSpeed return 0, so that a if block inside _OnUpdate never executes
    --lastly make make self:Stop() always get called with a true to stopmomentum inside the update loop.
    local _GetMotorSpeed = Physics.GetMotorSpeed
    function Physics.GetMotorSpeed(physics, ...)
        if physics == self.inst.Physics then
            return 0
        end
        return _GetMotorSpeed(physics, ...)
    end
    
    local _RealStop = self.Stop
    function self:Stop(sgparams)
        _RealStop(self, sgparams, true)
    end

    _OnUpdate(self, dt)

    Physics.GetMotorSpeed = _GetMotorSpeed
    
    self.Stop = _RealStop

    local cur_speed = self:HasMomentum() and self.momentumvelocity or self.inst.Physics:GetMotorSpeed()
    self.momentumvelocity = nil

    --wave boosting, only works with momentum...
    if self.boost then
        cur_speed = cur_speed + self.boost
        self.boost = nil
    end
    
    if self:HasMomentum() then
        local currentSpeed = cur_speed 
        if self.wantstomoveforward then 

            local targetSpeed = self.isrunning and self:GetRunSpeed() or self:GetWalkSpeed()

            --print("runspeed is ", self.runspeed)
            --print("multiplied speed is ", targetSpeed)
            local dist = math.sqrt(dsq)

            local deceleration = self:GetDeceleration()
            local acceleration = self:GetAcceleration()

            local stopdistance = math.pow(currentSpeed, 2)/(deceleration * 2.0)
            
            if(stopdistance >= dist and dist > 0) then 
                targetSpeed = currentSpeed - deceleration * GetTickTime()
            end 

            if self.slowing then 
                targetSpeed = 0 
            end 

            if(targetSpeed > currentSpeed) then 
                currentSpeed = currentSpeed + acceleration * GetTickTime()
                --I don't think we have to clamp the speed here, it gets done down below 
                if(currentSpeed > targetSpeed) then 
                    currentSpeed = targetSpeed
                end 
            elseif (targetSpeed < currentSpeed or targetSpeed == 0) then 
                currentSpeed = currentSpeed - deceleration * GetTickTime()
                if(currentSpeed <= 0) then 
                    currentSpeed = 0
                    self:Stop(nil, true)
                end 
            end
        end
        currentSpeed = math.min(currentSpeed, (self.maxSpeed + self:GetSpeedAdder()) * self:GetSpeedMultiplier())
        if DoShoreMovement(self.inst, {x = currentSpeed}, function() self.inst.Physics:SetMotorVel(currentSpeed, 0, 0) end) then
            self.momentumvelocity = currentSpeed
            if self.inst.replica.sailor then
                HandleDisembark(self.inst)
            end
        end

    elseif cur_speed > 0 then
        if self.allow_platform_hopping and (self.bufferedaction == nil or not self.bufferedaction.action.disable_platform_hopping) then

            local mypos_x, mypos_y, mypos_z = self.inst.Transform:GetWorldPosition()

            local destpos_x, destpos_y, destpos_z
            destpos_y = 0

            local rotation = self.inst.Transform:GetRotation() * DEGREES
            local forward_x, forward_z = math.cos(rotation), -math.sin(rotation)                

            local dest_dot_forward = 0

            local map = TheWorld.Map
            local my_platform = map:GetPlatformAtPoint(mypos_x, mypos_z)            

            if self.dest and self.dest:IsValid() then
                destpos_x, destpos_y, destpos_z = self.dest:GetPoint()
                local dest_dir_x, dest_dir_z = VecUtil_Normalize(destpos_x - mypos_x, destpos_z - mypos_z)                
                dest_dot_forward = VecUtil_Dot(dest_dir_x, dest_dir_z, forward_x, forward_z)                
                local dist = VecUtil_Length(destpos_x - mypos_x, destpos_z - mypos_z)
                if dist <= 1.5 then
                    local other_platform = map:GetPlatformAtPoint(destpos_x, destpos_z)
                    if my_platform == other_platform then
                        dest_dot_forward = 1
                    end
                end

            end 

            local forward_angle_span = 0.1
            if dest_dot_forward <= 1 - forward_angle_span then
                destpos_x, destpos_z = forward_x * self.hop_distance + mypos_x, forward_z * self.hop_distance + mypos_z
            end

            local other_platform = map:GetPlatformAtPoint(destpos_x, destpos_z)

            local can_hop = false
			local hop_x, hop_z, target_platform, blocked
            local too_early_top_hop = self.time_before_next_hop_is_allowed > 0
			if my_platform ~= other_platform and not too_early_top_hop
				    and (self.inst.replica.inventory == nil or not self.inst.replica.inventory:IsHeavyLifting())
				    and (self.inst.replica.rider == nil or not self.inst.replica.rider:IsRiding())
				then

				can_hop, hop_x, hop_z, target_platform, blocked = self:ScanForPlatform(my_platform, destpos_x, destpos_z)
			end

            if not blocked then
                if can_hop then
                    self.last_platform_visited = my_platform

                    self:StartHopping(hop_x, hop_z, target_platform)
                elseif self.inst.components.amphibiouscreature ~= nil and other_platform == nil and not self.inst.sg:HasStateTag("jumping") then
                    local dist = self.inst:GetPhysicsRadius(0) + 2.5
                    local _x, _z = forward_x * dist + mypos_x, forward_z * dist + mypos_z
                    if my_platform ~= nil then
                        local temp_x, temp_z, temp_platform = nil, nil, nil
                        can_hop, temp_x, temp_z, temp_platform, blocked = self:ScanForPlatform(nil, _x, _z)
                    end

                    if not can_hop and self.inst.components.amphibiouscreature:ShouldTransition(_x, _z) then
                        -- If my_platform ~= nil, we already ran the "is blocked" test as part of ScanForPlatform.
                        -- Otherwise, run one now.
                        if (my_platform ~= nil and not blocked) or 
                                not self:TestForBlocked(mypos_x, mypos_z, forward_x, forward_z, self.inst:GetPhysicsRadius(0), dist * 1.41421) then -- ~sqrt(2); _x,_z are a dist right triangle so sqrt(dist^2 + dist^2)
                            self.inst:PushEvent("onhop", {x = _x, z = _z})
                        end
                    end
                end
            end

			if (not can_hop and my_platform == nil and target_platform == nil and not self.inst.sg:HasStateTag("jumping")) and self.inst.components.drownable ~= nil and self.inst.components.drownable:ShouldDrown() then
				self.inst:PushEvent("onsink")
			end

        else
			local speed_mult = self:GetSpeedMultiplier()
			local desired_speed = (self.isrunning and self:RunSpeed() or self.walkspeed) + self:GetSpeedAdder()
			if self.dest and self.dest:IsValid() then
				local destpos_x, destpos_y, destpos_z = self.dest:GetPoint()
				local mypos_x, mypos_y, mypos_z = self.inst.Transform:GetWorldPosition()
				local dsq = distsq(destpos_x, destpos_z, mypos_x, mypos_z)
				if dsq <= .25 then
					speed_mult = math.max(.33, math.sqrt(dsq))
				end
			end

			DoShoreMovement(self.inst, {x = desired_speed * speed_mult}, function() self.inst.Physics:SetMotorVel(desired_speed * speed_mult, 0, 0) end)
		end
    end
end

local _WalkForward
local function WalkForward(self, direct, ...)
    DoShoreMovement(self.inst, {x = self:GetWalkSpeed()}, _WalkForward, self, direct, ...)
end

local _RunForward
local function RunForward(self, direct, ...)
    if self:HasMomentum() then
        self.isrunning = true
        if direct then self.wantstomoveforward = true end
        self:StartUpdatingInternal()
    else
        DoShoreMovement(self.inst, {x = self:GetRunSpeed()}, _RunForward, self, direct, ...)
    end
end

local _WalkInDirection
local function WalkInDirection(self, direct)
    if self.inst.replica and self.inst.replica.sailor then
        self.inst.replica.sailor:AlignBoat(direction)
    end
    _WalkInDirection(self, direct)
    self.slowing = false
end

local _RunInDirection
local function RunInDirection(self, direction, throttle)
    if self.inst.replica and self.inst.replica.sailor then
        self.inst.replica.sailor:AlignBoat(direction)
    end
    _RunInDirection(self, direction, throttle)
    self.slowing = false
end

local _GoToEntity
local function GoToEntity(self, inst, bufferedaction, run)
    self.slowing = false
    return _GoToEntity(self, inst, bufferedaction, run)
end

local _GoToPoint
local function GoToPoint(self, pt, bufferedaction, run, overridedest)
    self.slowing = false
    return _GoToPoint(self, pt, bufferedaction, run, overridedest)
end


----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("locomotor", function(cmp)


cmp._externalspeedadders = {}
cmp.externalspeedadder = 0

cmp.externalspeedadder_timer = {}
cmp.externalspeedmultipliers_timer = {}

cmp._externalaccelerationadders = {}
cmp.externalaccelerationadder = 0

cmp._externalaccelerationmultipliers = {}
cmp.externalaccelerationmultiplier = 1

cmp._externaldecelerationadders = {}
cmp.externaldecelerationadder = 0

cmp._externaldecelerationmultipliers = {}
cmp.externaldecelerationmultiplier = 1

cmp.hasmomentum = false

cmp.disable = false

cmp.acceleration = 6
cmp.deceleration = 6
cmp.currentSpeed = 0 
cmp.abruptdeceleration = 8
cmp.abruptAngleThreshold = 120 
cmp.maxSpeed = 12
cmp.slowing = false


if TheWorld.ismastersim then
	
	cmp.HasMomentum = HasMomentum_ms
	cmp.IsDisabled = IsDisabled_ms
	cmp.ExternalSpeedAdder = ExternalSpeedAdder_ms
	cmp.GetSpeedAdder = GetSpeedAdder_ms
	cmp.ExternalAccelerationAdder = ExternalAccelerationAdder_ms
	cmp.GetAccelerationAdder = GetAccelerationAdder_ms
	cmp.ExternalAccelerationMultiplier = ExternalAccelerationMultiplier_ms
	cmp.GetAccelerationMultiplier = GetAccelerationMultiplier_ms
	cmp.ExternalDecelerationAdder = ExternalDecelerationAdder_ms
	cmp.GetDecelerationAdder = GetDecelerationAdder_ms
	cmp.ExternalDecelerationMultiplier = ExternalDecelerationMultiplier_ms
	cmp.GetDecelerationMultiplier = GetDecelerationMultiplier_ms
	_GetSpeedMultiplier = cmp.GetSpeedMultiplier
	cmp.GetSpeedMultiplier = GetSpeedMultiplier_ms
	
    addsetter(cmp, "hasmomentum", onhasmomentum_ms)
    addsetter(cmp, "disable", ondisable_ms)
    addsetter(cmp, "externalspeedadder", onexternalspeedadder_ms)
    addsetter(cmp, "externalaccelerationadder", onexternalaccelerationadder_ms)
    addsetter(cmp, "externalaccelerationmultiplier", onexternalaccelerationmultiplier_ms)
    addsetter(cmp, "externaldecelerationadder", onexternaldecelerationadder_ms)
    addsetter(cmp, "externaldecelerationmultiplier", onexternaldecelerationmultiplier_ms)
	
else
	
	cmp.HasMomentum = HasMomentum_client
	cmp.IsDisabled = IsDisabled_client
	cmp.ExternalSpeedAdder = ExternalSpeedAdder_client
	cmp.GetSpeedAdder = GetSpeedAdder_client
	cmp.ExternalAccelerationAdder = ExternalAccelerationAdder_client
	cmp.GetAccelerationAdder = GetAccelerationAdder_client
	cmp.ExternalAccelerationMultiplier = ExternalAccelerationMultiplier_client
	cmp.GetAccelerationMultiplier = GetAccelerationMultiplier_client
	cmp.ExternalDecelerationAdder = ExternalDecelerationAdder_client
	cmp.GetDecelerationAdder = GetDecelerationAdder_client
	cmp.ExternalDecelerationMultiplier = ExternalDecelerationMultiplier_client
	cmp.GetDecelerationMultiplier = GetDecelerationMultiplier_client
	cmp.GetWindMult = GetWindMult_client
	_GetSpeedMultiplier = cmp.GetSpeedMultiplier
	cmp.GetSpeedMultiplier = GetSpeedMultiplier_client

end

_StopMoving = cmp.StopMoving
cmp.StopMoving = StopMoving
cmp.SetExternalAccelerationAdder = SetExternalAccelerationAdder
cmp.RemoveExternalAccelerationAdder = RemoveExternalAccelerationAdder
cmp.RecalculateExternalAccelerationAdder = RecalculateExternalAccelerationAdder
cmp.GetExternalAccelerationAdder = GetExternalAccelerationAdder
cmp.SetExternalAccelerationMultiplier = SetExternalAccelerationMultiplier
cmp.RemoveExternalAccelerationMultiplier = RemoveExternalAccelerationMultiplier
cmp.RecalculateExternalAccelerationMultiplier = RecalculateExternalAccelerationMultiplier
cmp.GetExternalAccelerationMultiplier = GetExternalAccelerationMultiplier
cmp.SetExternalDecelerationAdder = SetExternalDecelerationAdder
cmp.RemoveExternalDecelerationAdder = RemoveExternalDecelerationAdder
cmp.RecalculateExternalDecelerationAdder = RecalculateExternalDecelerationAdder
cmp.GetExternalDecelerationAdder = GetExternalDecelerationAdder
cmp.SetExternalDecelerationMultiplier = SetExternalDecelerationMultiplier
cmp.RemoveExternalDecelerationMultiplier = RemoveExternalDecelerationMultiplier
cmp.RecalculateExternalDecelerationMultiplier = RecalculateExternalDecelerationMultiplier
cmp.GetExternalDecelerationMultiplier = GetExternalDecelerationMultiplier
cmp.GetDeceleration = GetDeceleration
cmp.GetAcceleration = GetAcceleration
_Stop = cmp.Stop
cmp.Stop = Stop
_SetExternalSpeedMultiplier = cmp.SetExternalSpeedMultiplier
cmp.SetExternalSpeedMultiplier = SetExternalSpeedMultiplier
_RemoveExternalSpeedMultiplier = cmp.RemoveExternalSpeedMultiplier
cmp._RemoveExternalSpeedMultiplier = RemoveExternalSpeedMultiplier
cmp.SetExternalSpeedAdder = SetExternalSpeedAdder
cmp.RemoveExternalSpeedAdder = RemoveExternalSpeedAdder
cmp.RecalculateExternalSpeedAdder = RecalculateExternalSpeedAdder
cmp.GetExternalSpeedAdder = GetExternalSpeedAdder
cmp.UpdateSpeedModifierTimers = UpdateSpeedModifierTimers
cmp.OnSave = OnSave
cmp.OnLoad = OnLoad
cmp.LongUpdate = LongUpdate
cmp.GetWalkSpeed = GetWalkSpeed
cmp.GetRunSpeed = GetRunSpeed
_PreviewAction = cmp.PreviewAction
cmp.PreviewAction = PreviewAction
_WantsToMoveForward = cmp.WantsToMoveForward
cmp.WantsToMoveForward = WantsToMoveForward
_OnUpdate = cmp.OnUpdate
cmp.OnUpdate = OnUpdate
_WalkForward = cmp.WalkForward
cmp.WalkForward = WalkForward
_RunForward = cmp.RunForward
cmp.RunForward = RunForward
_WalkInDirection = cmp.WalkInDirection
cmp.WalkInDirection = WalkInDirection
_RunInDirection = cmp.RunInDirection
cmp.RunInDirection = RunInDirection
_GoToEntity = cmp.GoToEntity
cmp.GoToEntity = GoToEntity
_GoToPoint = cmp.GoToPoint
cmp.GoToPoint = GoToPoint


end)
