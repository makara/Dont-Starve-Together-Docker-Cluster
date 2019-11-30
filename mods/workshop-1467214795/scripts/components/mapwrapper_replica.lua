return Class(function(self, inst)

local STATE_WAIT = 0
local STATE_WARN = 1
local STATE_MOVEOFF = 2
local STATE_BLIND = 3
local STATE_MOVEBACK = 4
local STATE_RETURN = 5

local _growlsounds = {
	-- 'ia/common/bermuda/sparks_active',
	-- 'ia/creatures/blue_whale/idle',
	'ia/creatures/blue_whale/breach_swim',
	'ia/creatures/cormorant/takeoff',
	'ia/creatures/crocodog/distant',
	'ia/creatures/crocodog/distant',
	-- 'ia/creatures/quacken/enter',
	'ia/creatures/seagull/takeoff',
	-- 'ia/creatures/sharx/distant',
	'ia/creatures/twister/distant',
	'ia/creatures/white_whale/breach_swim',
	'ia/creatures/white_whale/mouth_open',
	-- 'dontstarve/sanity/creature2/attack_grunt',
	-- 'dontstarve/sanity/creature1/taunt',
}
local _boatsounds = {
	'ia/creatures/seacreature_movement/splash_small',
	'ia/creatures/seacreature_movement/splash_medium',
	-- 'ia/creatures/seacreature_movement/splash_large',
	'ia/creatures/seacreature_movement/thrust',
	-- 'ia/common/brain_coral_harvest',
	-- 'ia/common/pickobject_water',
}

self.inst = inst
self._state = net_tinybyte(inst.GUID, "mapwrapper._state", "mapwrapperdirty")

-- This handles mist for us
if not TheNet:IsDedicated() then
	inst:AddChild( SpawnAt("edgefog", inst) )
end


local function PlayFunnyGrowl(inst)
	inst.SoundEmitter:PlaySound(_growlsounds[math.random(#_growlsounds)])
end
local function PlayFunnyBoat(inst)
	inst.SoundEmitter:PlaySound(_boatsounds[math.random(#_boatsounds)])
end

function self:GetState()
    return self._state:value()
end

function self:SetState()
    if TheNet:IsDedicated() then return end
	
	if self.inst ~= TheLocalPlayer then return end
	
	if self:GetState() == STATE_WARN then
		self.inst.components.talker:Say(GetString(self.inst, "ANNOUNCE_MAPWRAP_WARN"))
		
	elseif self:GetState() == STATE_MOVEOFF then
		self.inst.components.talker:Say(GetString(self.inst, "ANNOUNCE_MAPWRAP_LOSECONTROL"))
		if self.inst.HUD then
			TheFrontEnd:Fade(FADE_OUT, 3, nil, nil, nil, "white")
			self.inst.HUD:Hide()
		end

	elseif self:GetState() == STATE_BLIND then
		self.inst:DoTaskInTime(1.4, PlayFunnyGrowl)
		self.inst:DoTaskInTime(2.1, PlayFunnyGrowl)
		self.inst:DoTaskInTime(2.8, PlayFunnyBoat)
		
	elseif self:GetState() == STATE_MOVEBACK then
		if self.inst.HUD then
			TheFrontEnd:Fade(FADE_IN, 6, nil, nil, nil, "white")
		end

	elseif self:GetState() == STATE_RETURN then
		self.inst.components.talker:Say(GetString(self.inst, "ANNOUNCE_MAPWRAP_RETURN"))
		if self.inst.HUD then
			self.inst.HUD:Show()
		end
	end
	
end

self.inst:ListenForEvent("mapwrapperdirty", function() self:SetState() end)
	
end)
