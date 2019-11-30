
--------------------------------------------------------------------------
--[[ Dependencies ]]
--------------------------------------------------------------------------

require("constants")
local easing = require("easing")

--------------------------------------------------------------------------
--[[ Private member functions ]]
--------------------------------------------------------------------------

local function set_ocean_angle(inst)
	inst.currentAngle = 45 * math.random(0, 7) + 22.5 --math.random(0, 359)
end

local function SpawnWaveRipple(inst, x, y, z, angle, speed)
	-- TheSim:ProfilerPush("SpawnWaveRipple")
	local wave = SpawnPrefab( "wave_ripple" )
	wave.Transform:SetPosition( x, y, z )

	--we just need an angle...
	wave.Transform:SetRotation(angle)
	
	--motor vel is relative to the local angle, since we're now facing the way we want to go we just go forward
	wave.Physics:SetMotorVel(speed, 0, 0)

	wave.idle_time = inst.ripple_idle_time

	-- TheSim:ProfilerPop()
	return wave
end

local function SpawnRogueWave(inst, x, y, z, angle, speed)
	-- TheSim:ProfilerPush("SpawnRogueWave")
	local wave = SpawnPrefab( "wave_rogue" )
	wave.Transform:SetPosition( x, y, z )
	wave.Transform:SetRotation(angle)
	
	--motor vel is relative to the local angle, since we're now facing the way we want to go we just go forward
	wave.Physics:SetMotorVel(speed, 0, 0)

	wave.idle_time = inst.ripple_idle_time

	-- TheSim:ProfilerPop()
	return wave
end

local function getRippleRadius()
	-- From values from camera_volcano.lua, camera range 30 to 100
	-- local percent = (TheCamera:GetDistance() - 30) / (70)
	-- local row_radius = (24 - 16) * percent + 16
	-- local col_radius = (8 - 2) * percent + 2
	--print("Ripple ", row_radius, col_radius)
	-- return row_radius, col_radius
	return 24, 8
end

local function getPerSecMult(min, max)
	-- From values from camera_volcano.lua, camera range 30 to 100
	-- local percent = (TheCamera:GetDistance() - 30) / (70)
	-- local mult = (1.5 - 1) * percent + 1 -- 1x to 1.5x 
	--print("Per sec", TheCamera:GetDistance(), mult)
	-- return mult
	return 1.5
end

local function updateSeasonMod(self)
	if TheWorld.state.issummer then
		self.seasonmult = 0.5 * math.sin(PI * TheWorld.state.seasonprogress + (PI/2.0)) + 0.5
	else
		self.seasonmult = 1
	end
end

local function onisnight(self, isnight)
	if isnight and not TheWorld.state.hurricane then
		self.inst:DoTaskInTime(0.25 * math.random() * TUNING.SEG_TIME, function()
			self.currentSpeed = 0.0
			self.nightreset = true
			self.inst:DoTaskInTime(math.random(10, 15), function()
				self.currentSpeed = 1.0
				self.nightreset = false
				set_ocean_angle(self)
			end)
		end)
	end
end

--------------------------------------------------------------------------
--[[ Member variables ]]
--------------------------------------------------------------------------

local WaveManager = Class(function(self, inst)
	self.inst = inst
	
	self.currentAngle = 0
	self.currentSpeed = 1
	
	self.seasonmult = 1
	
	self.ripple_speed = 1.5 --TODO what even is this
	self.ripple_per_sec = 10
	self.ripple_idle_time = 5 
	self.ripple_spawn_rate = 0

	self.ripple_per_sec_mod = 1.0

	set_ocean_angle(self)
	updateSeasonMod(self)
	self:WatchWorldState("isnight", onisnight)
	self:WatchWorldState("cycles", updateSeasonMod)

	self.inst:StartUpdatingComponent(self)
end)

--------------------------------------------------------------------------
--[[ Functions ]]
--------------------------------------------------------------------------


function WaveManager:SpawnLaneWaveRipple(player, x, y, z, row_radius, col_radius)
	local cx, cy, cz = self:GetCurrentVec3() --assuming unit vector here
	local m1 = math.floor(math.random(-row_radius, row_radius)) --math.random(-16, 16)
	local m2 = TUNING.WAVE_LANE_SPACING * math.floor(math.random(-col_radius, col_radius)) --math.random(-2, 2)
	local dx, dz = 2 * m1 * cx + m2 * cz, 2 * m1 * cz + m2 * -cx
	local tx, ty, tz = x + dx, y, z + dz
	--don't spawn waves too close to worlds edge
	local w, h = TheWorld.Map:GetSize()
	w = (w * .5 - TUNING.MAPWRAPPER_WARN_RANGE) * TILE_SCALE 
	h = (h * .5 - TUNING.MAPWRAPPER_WARN_RANGE) * TILE_SCALE 
	if tx < -w or tx > w 
	or tz < -h or tz > h
	then return end
	--ok now check ground tiles
	local ground = TheWorld.Map:GetTileAtPoint( tx, ty, tz )
	if ground == GROUND.OCEAN_MEDIUM or ground == GROUND.OCEAN_DEEP then
		local noSpawn = TheSim:FindEntities(tx, ty, tz, 10, {"nowaves"})
		if noSpawn == nil or #noSpawn == 0 then
			--lastly, make sure there are no waves there already
			local ents = TheSim:FindEntities(tx, ty, tz, 4, {"lanewave"})

			if ents == nil or #ents == 0 then
				local wave
				if (TheWorld.state.isfullmoon --[[and (TheWorld.state.isnight or TheWorld.state.isdusk)]] and math.random() < 0.25)
				or (TheWorld.state.iswinter and math.random() < easing.inOutCirc(1 - ((TheWorld.state.winterlength - TheWorld.state.elapseddaysinseason) / TheWorld.state.winterlength), 0.0, 1.0, 1.0)) then
					wave = SpawnRogueWave(player, tx, ty, tz, -self:GetCurrentAngle(), self.ripple_speed * self:GetCurrentSpeed() * TUNING.ROGUEWAVE_SPEED_MULTIPLIER)
				else
					wave = SpawnWaveRipple(player, tx, ty, tz, -self:GetCurrentAngle(), self.ripple_speed * self:GetCurrentSpeed())
				end
				wave:AddTag("lanewave")
			end
		end
	end
end

function WaveManager:OnUpdate(dt)
	if TheWorld.Map == nil then
		return
	end

	local mult = getPerSecMult()
	local row_radius, col_radius = getRippleRadius()
	
	-- local w, h = TheWorld.Map:GetSize()
	local gridw, gridh = TUNING.WAVE_LANE_SPACING, TUNING.WAVE_LANE_SPACING
	
	if self:GetCurrentSpeed() > 0.0 then		
		self.ripple_spawn_rate = self.ripple_spawn_rate + self.ripple_per_sec * self.ripple_per_sec_mod * mult * self.seasonmult * dt

		while self.ripple_spawn_rate > 1.0 do --TODO maybe optimise by calculating the num to spawn
			for i, player in pairs(AllPlayers) do
				if player:IsValid() and player.entity:IsVisible() then
					local px, py, pz = player.Transform:GetWorldPosition()
					local ents = TheSim:FindEntities(px, py, pz, row_radius, { "lanewave" })
					if #ents < TUNING.MAX_WAVES then
						--snap to map lanes
						local lx, ly, lz = math.floor(px / gridw) * gridw, py, math.floor(pz / gridh) * gridh
						self:SpawnLaneWaveRipple(player, lx, ly, lz, row_radius, col_radius)
					end
				end
			end
			self.ripple_spawn_rate = self.ripple_spawn_rate - 1.0
		end

	end

	if self.ripple_per_sec_mod <= 0.0 then
		self.inst:StopUpdatingComponent(self)
	end

end

function WaveManager:OnSave()
	if self.nightreset == true then --don't accidentally save the idle phase permamently
		self.currentSpeed = 1.0
		set_ocean_angle(self)
	end
	return
	{
		currentAngle = self.currentAngle,
		currentSpeed = self.currentSpeed
	}
end

function WaveManager:OnLoad(data)
	if data then
		self.currentAngle = data.currentAngle or self.currentAngle
		self.currentSpeed = data.currentSpeed or self.currentSpeed
	end
end

function WaveManager:GetCurrentAngle()
	return self.currentAngle
end

function WaveManager:GetCurrentSpeed()
	return self.currentSpeed
end

function WaveManager:GetCurrentVec3()
	return self.currentSpeed * math.cos(self.currentAngle * DEGREES), 0, self.currentSpeed * math.sin(self.currentAngle * DEGREES)
	--return self.currentSpeed * math.sin(self.currentAngle * DEGREES), 0, self.currentSpeed * math.cos(self.currentAngle * DEGREES)
end

function WaveManager:SetWaveSettings(ripple_per_sec)
	self.ripple_per_sec_mod = ripple_per_sec or 1.0
end

return WaveManager
