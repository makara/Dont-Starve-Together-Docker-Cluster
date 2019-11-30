local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

IAENV.AddComponentPostInit("worldwind", function(cmp)

local _OnSave = cmp.OnSave
function cmp:OnSave()
	local t = {}
	local ref
	if _OnSave then t, ref = _OnSave(inst) end
	t.angle = self.angle
	t.timeToWindChange = self.timeToWindChange
	return t, ref
end

local _OnLoad = cmp.OnLoad
function cmp:OnLoad(data)
	if _OnLoad then _OnLoad(inst,data) end
	if data then
		self.angle = data.angle or self.angle
		self.timeToWindChange = data.timeToWindChange or self.timeToWindChange
	end
end

local _OnUpdate = cmp.OnUpdate
function cmp:OnUpdate(dt)
	
	local dochange =  self.timeToWindChange <= 0
	
	_OnUpdate(self, dt)
	
	if dochange then
		--SW uses 16 segments, every time, which might make this too predictable
		self.timeToWindChange = math.random(4, 16) * TUNING.SEG_TIME
	end
	
end

end)
