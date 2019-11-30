local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

local function onvolcanic(self, volcanic)
    if volcanic then
        self.inst:AddTag("witherable_volcanic")
    else
        self.inst:RemoveTag("witherable_volcanic")
    end
end

local function onoceanic(self, oceanic)
    if oceanic then
        self.inst:AddTag("witherable_oceanic")
    else
        self.inst:RemoveTag("witherable_oceanic")
    end
end

IAENV.AddComponentPostInit("witherable", function(cmp)

addsetter(cmp, "volcanic", onvolcanic)
addsetter(cmp, "oceanic", onoceanic)

cmp.volcanic = false
cmp.oceanic = false


local _WitherHandler = UpvalueHacker.GetUpvalue(cmp.ForceWither, "WitherHandler")

local DoCropWither = UpvalueHacker.GetUpvalue(_WitherHandler, "DoCropWither")
local DoPickableWither = UpvalueHacker.GetUpvalue(_WitherHandler, "DoPickableWither")

local function DoHackableWither(inst, self)
    local hackable = inst.components.hackable
    if hackable == nil then
        return false
    end

    self.restore_cycles = hackable.cycles_left
    if not hackable:IsBarren() then
        hackable:MakeBarren()
    end
    return true
end

local function WitherHandler(target, self, force)
    local _temperature = rawget(TheWorld.state, "temperature")
    if IsInIAClimate(self.inst) then
        TheWorld.state.temperature = TheWorld.state.islandtemperature
    end
	if self.volcanic then
		self.task = nil
		self.task_to_time = nil

		if not (force or (TheWorld.state.temperature <= self.wither_temp)) then
			--Reschedule
			self:Start()
		else
			self.withered = true
			if DoCropWither(self.inst, self) or DoPickableWither(self.inst, self) or DoHackableWither(self.inst, self) then
				self:DelayRejuvenate(TUNING.TOTAL_DAY_TIME)
			else
				print("Failed to wither "..tostring(self.inst))
			end
		end
	elseif target.components.hackable then
        self.task = nil
        self.task_to_time = nil

         --This is one of two lines we needed to change for temperature
        if force or (not TheWorld.state.israining and TheWorld.state.temperature > self.wither_temp) then
            self.withered = true
            if DoHackableWither(self.inst, self) then
                self:DelayRejuvenate(TUNING.TOTAL_DAY_TIME)
            else
                print("Failed to wither "..tostring(self.inst))
            end
        else
            --Reschedule
            self:Start()
        end
    else
        _WitherHandler(target, self, force)
    end
    TheWorld.state.temperature = _temperature
end


UpvalueHacker.SetUpvalue(cmp.ForceWither, WitherHandler, "WitherHandler")

local _RejuvenateHandler = UpvalueHacker.GetUpvalue(cmp.ForceRejuvenate, "RejuvenateHandler")

local DoPickableRejuvenate = UpvalueHacker.GetUpvalue(_RejuvenateHandler, "DoPickableRejuvenate")

local function DoHackableRejuvenate(inst, self)
    local hackable = inst.components.hackable
    if hackable == nil then
        return false
    end
    if self.restore_cycles ~= nil then
        hackable.cycles_left = math.max(hackable.cycles_left or 0, self.restore_cycles)
        self.restore_cycles = nil
    else
        hackable.cycles_left = nil
    end
    if not hackable:IsBarren() then
        hackable:MakeEmpty()
    end
    return true
end

local function RejuvenateHandler(target, self, force)
    local _temperature = rawget(TheWorld.state, "temperature")
    if IsInIAClimate(self.inst) then
        TheWorld.state.temperature = TheWorld.state.islandtemperature
    end
	if self.volcanic then
		self.task = nil
		self.task_to_time = nil

		if not (force or TheWorld.state.temperature >= self.wither_temp) then
			--Reschedule
			self:Start()
		elseif DoPickableRejuvenate(self.inst, self) or DoHackableRejuvenate(self.inst, self) then
			self.withered = false
			self:DelayWither(15)
		else
			self.withered = false
			print("Failed to rejuvenate "..tostring(self.inst))
		end
	elseif target.components.hackable then
        self.task = nil
        self.task_to_time = nil

        if not (force or TheWorld.state.temperature < self.rejuvenate_temp or TheWorld.state.israining) then
            --Reschedule
            self:Start()
        elseif DoHackableRejuvenate(self.inst, self) then
            self.withered = false
            self:DelayWither(15)
        else
            self.withered = false
            print("Failed to rejuvenate "..tostring(self.inst))
        end
    else
        _RejuvenateHandler(target, self, force)
    end
    TheWorld.state.temperature = _temperature
end

--TODO sure this needs to be set everytime? -M
UpvalueHacker.SetUpvalue(cmp.ForceRejuvenate, RejuvenateHandler, "RejuvenateHandler")


end)
