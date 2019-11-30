local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local function OnIsRaining(self, israining)
    if israining then
        self:Pause()
    else
        self:Resume()
    end
end

local StartWatchingRain
local function StartWatchingRain_IA(self, ...)
	if IsInIAClimate(self.inst) then
		if not self.watchingrain then
			self.watchingrain = true
			self:WatchWorldState("islandisraining", OnIsRaining)
		end
	else
		return StartWatchingRain(self, ...)
	end
end

local StopWatchingRain
local function StopWatchingRain_IA(self, ...)
	self:StopWatchingWorldState("islandisraining", OnIsRaining)
	return StopWatchingRain(self, ...)
end

local StartDrying
local function StartDrying_IA(self, ...)
	local ret = StartDrying(self, ...)

    if not self.task and IsInIAClimate(self.inst) and not (TheWorld.state.islandisraining or self.protectedfromrain) then
        self:Resume()
    end
	
	return ret
end

local LongUpdate
local function LongUpdate_IA(self, ...)
	local ret = LongUpdate(self, ...)

    if self:IsDrying() and not self.task
	and IsInIAClimate(self.inst) and not (TheWorld.state.islandisraining or self.protectedfromrain) then
		self:Resume()
	end
	
	return ret
end

local OnLoad
local function OnLoad_IA(self, ...)
	local ret = OnLoad(self, ...)

    if self:IsDrying() and not self.task
	and IsInIAClimate(self.inst) and not (TheWorld.state.islandisraining or self.protectedfromrain) then
		self:Resume()
	end
	
	return ret
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("dryer", function(cmp)


-- if cmp.inst and cmp.inst.worldstatewatching and cmp.inst.worldstatewatching.israining then
	-- for i, v in ipairs(cmp.inst.worldstatewatching.israining) do

--only wrap the upvalue once, so we don't add our code twice -M
if not StartWatchingRain then
	StartWatchingRain = UpvalueHacker.GetUpvalue(cmp.LongUpdate, "StartWatchingRain")
	if StartWatchingRain then
		UpvalueHacker.SetUpvalue(cmp.LongUpdate, StartWatchingRain_IA, "StartWatchingRain")
	else
		StartWatchingRain = UpvalueHacker.GetUpvalue(cmp.OnLoad, "StartWatchingRain")
		if StartWatchingRain then
			UpvalueHacker.SetUpvalue(cmp.OnLoad, StartWatchingRain_IA, "StartWatchingRain")
		end
	end
end

--failsafe failsafe failsafe failsafe -M
if not StopWatchingRain then
	StopWatchingRain = UpvalueHacker.GetUpvalue(cmp.OnRemoveFromEntity, "StopWatchingRain")
	if StopWatchingRain then
		UpvalueHacker.SetUpvalue(cmp.OnRemoveFromEntity, StopWatchingRain_IA, "StopWatchingRain")
	else
		StopWatchingRain = UpvalueHacker.GetUpvalue(cmp.OnLoad, "StopWatchingRain")
		if StopWatchingRain then
			UpvalueHacker.SetUpvalue(cmp.OnLoad, StopWatchingRain_IA, "StopWatchingRain")
		else
			StopWatchingRain = UpvalueHacker.GetUpvalue(cmp.StartDrying, "StopWatchingRain")
			if StopWatchingRain then
				UpvalueHacker.SetUpvalue(cmp.StartDrying, StopWatchingRain_IA, "StopWatchingRain")
			else
				StopWatchingRain = UpvalueHacker.GetUpvalue(cmp.StopDrying, "StopWatchingRain")
				if StopWatchingRain then
					UpvalueHacker.SetUpvalue(cmp.StopDrying, StopWatchingRain_IA, "StopWatchingRain")
				else
					StopWatchingRain = UpvalueHacker.GetUpvalue(cmp.DropItem, "StopWatchingRain")
					if StopWatchingRain then
						UpvalueHacker.SetUpvalue(cmp.DropItem, StopWatchingRain_IA, "StopWatchingRain")
					else
						StopWatchingRain = UpvalueHacker.GetUpvalue(cmp.Harvest, "StopWatchingRain")
						if StopWatchingRain then
							UpvalueHacker.SetUpvalue(cmp.Harvest, StopWatchingRain_IA, "StopWatchingRain")
						end
					end
				end
			end
		end
	end
end

StartDrying = cmp.StartDrying
cmp.StartDrying = StartDrying_IA
LongUpdate = cmp.LongUpdate
cmp.LongUpdate = LongUpdate_IA
OnLoad = cmp.OnLoad
cmp.OnLoad = OnLoad_IA

end)
