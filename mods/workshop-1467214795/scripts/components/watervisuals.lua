return Class(function(self, inst)

--------------------------------------------------------------------------
--[[ Dependencies ]]
--------------------------------------------------------------------------

local easing = require("easing")
require("constants")

--------------------------------------------------------------------------
--[[ Constants ]]
--------------------------------------------------------------------------

local _map = inst.Map

--------------------------------------------------------------------------
--[[ Spawn functions ]]
--------------------------------------------------------------------------

local function isWater(x, y, z)
	return IsOnWater(x,y,z,true)
end

local function isSurroundedByWater(x, y, z, radius)
	-- TheSim:ProfilerPush("isSurroundedByWater")
	
	for i = -radius, radius, 1 do
		if not isWater(x - radius, y, z + i) or not isWater(x + radius, y, z + i) then
			return false
		end
	end
	for i = -(radius - 1), radius - 1, 1 do
		if not isWater(x + i, y, z -radius) or not isWater(x + i, y, z + radius) then
			return false
		end
	end

	-- TheSim:ProfilerPop()
	return true
end

local function GetWaveBearing(ex, ey, ez, lines)

	--TheSim:SetDebugRenderEnabled(true)
	--inst.draw = inst.entity:AddDebugRender()
	--inst.draw:Flush()
	--inst.draw:SetRenderLoop(true)
	--inst.draw:SetZ(0.15)

	local _offs =
	{
		{-2,-2}, {-1,-2}, {0,-2}, {1,-2}, {2,-2},
		{-2,-1}, {-1,-1}, {0,-1}, {1,-1}, {2,-1},
		{-2, 0}, {-1, 0},          {1, 0}, {2, 0},
		{-2, 1}, {-1, 1}, {0, 1}, {1, 1}, {2, 1},
		{-2, 2}, {-1, 2}, {0, 2}, {1, 2}, {2, 2}
	}

	-- local flooding = GetWorld().Flooding
	local width, height = TheWorld.Map:GetSize()
	local halfw, halfh = 0.5 * width, 0.5 * height
	--local ex, ey, ez = inst.Transform:GetWorldPosition()
	local x, y = TheWorld.Map:GetTileXYAtPoint(ex, ey, ez)
	local xtotal, ztotal, n = 0, 0, 0
	-- for i = 1, #_offs, 1 do
		-- local ground = _map:GetTile( x + _offs[i][1], y + _offs[i][2] )
		-- if _map:IsLand(ground) and not (flooding and flooding:OnFlood(ex + _offs[i][1] * TILE_SCALE, ey, ez + _offs[i][2] * TILE_SCALE)) then
			-- --if lines then table.insert(lines, {ex, ez, ((x + _offs[i][1] - halfw) * TILE_SCALE), ((y + _offs[i][2] - halfh) * TILE_SCALE), 1, 1, 0, 1}) end
			-- xtotal = xtotal + ((x + _offs[i][1] - halfw) * TILE_SCALE)
			-- ztotal = ztotal + ((y + _offs[i][2] - halfh) * TILE_SCALE)
			-- n = n + 1
		-- end
	-- end
	for offx = -2, 2 do
	for offy = -2, 2 do
		if offx ~= 0 or offy ~= 0 then
			if not isWater(ex + offx * TILE_SCALE, ey, ez + offy * TILE_SCALE) then
				xtotal = xtotal + ((x + offx - halfw) * TILE_SCALE)
				ztotal = ztotal + ((y + offy - halfh) * TILE_SCALE)
				n = n + 1
			end
		end
	end
	end

	local bearing = nil
	if n > 0 then
		local a = math.atan2(ztotal/n - ez, xtotal/n - ex)
		--if lines then table.insert(lines, {ex, ez, ex + 10 * math.cos(a), ez + 10 * math.sin(a), 0, 1, 0, 1}) end
		--if lines then table.insert(lines, {ex, ez, ex + math.cos(0), ez + math.sin(0), 1, 0, 1, 1}) end
		bearing = -a/DEGREES - 90
	end

	-- TheSim:ProfilerPop()

	return bearing
end

local function SpawnWaveShore(inst, pt)
	-- TheSim:ProfilerPush("SpawnWaveShore")
	--local lines = {}
	local bearing = GetWaveBearing(pt.x, pt.y, pt.z)
	if bearing then
		local wave = SpawnAt( "wave_shore", pt )
		wave.Transform:SetRotation(bearing)
		wave:SetAnim()

		--[[TheSim:SetDebugRenderEnabled(true)
		wave.draw = wave.entity:AddDebugRender()
		wave.draw:Flush()
		wave.draw:SetRenderLoop(true)
		wave.draw:SetZ(0.15)
		for i = 1, #lines, 1 do
			wave.draw:Line(lines[i][1], lines[i][2], lines[i][3], lines[i][4], lines[i][5], lines[i][6], lines[i][7], lines[i][8])
		end]]
	end
	-- TheSim:ProfilerPop()
end

local function SpawnWaveShimmerRiver(inst, pt)
	SpawnAt( "wave_shimmer_river", pt )
end
local function SpawnWaveShimmerShallow(inst, pt)
	SpawnAt( "wave_shimmer", pt )
end
local function SpawnWaveShimmerMedium(inst, pt)
	SpawnAt( "wave_shimmer_med", pt )
end
local function SpawnWaveShimmerDeep(inst, pt)
	SpawnAt( "wave_shimmer_deep",  pt)
end
local function SpawnWaveShimmerFlood(inst, pt)
	SpawnAt( "wave_shimmer_flood", pt )
end
local function SpawnWaveFlood(inst, pt)
	-- TheSim:ProfilerPush("SpawnWaveFlood")
	SpawnWaveShimmerFlood(inst, pt)
	SpawnWaveShore(inst, pt)
	-- TheSim:ProfilerPop()
end

local function checkflood(inst, x, y, z, ground)
	return IsOnFlood( x, y, z ) and isSurroundedByWater(x, y, z, 2)
end

local function checkground(inst, x, y, z, ground)
	return TheWorld.Map:GetTileAtPoint( x, y, z ) == ground
	and IsWater(TheWorld.Map:GetTileAtPoint( x+3, y, z+3 ))
	and IsWater(TheWorld.Map:GetTileAtPoint( x+3, y, z+3 ))
	and IsWater(TheWorld.Map:GetTileAtPoint( x-3, y, z-3 ))
	and IsWater(TheWorld.Map:GetTileAtPoint( x-3, y, z-3 ))
end

local function checkgroundnear(inst, x, y, z, ground)
	return TheWorld.Map:GetTileAtPoint( x, y, z ) == ground
	-- and IsWater(TheWorld.Map:GetTileAtPoint( x+1, y, z+1 ))
	-- and IsWater(TheWorld.Map:GetTileAtPoint( x+1, y, z+1 ))
	-- and IsWater(TheWorld.Map:GetTileAtPoint( x-1, y, z-1 ))
	-- and IsWater(TheWorld.Map:GetTileAtPoint( x-1, y, z-1 ))
end

local function checkshore(inst, x, y, z, ground)
	local tile = TheWorld.Map:GetTileAtPoint(x, y, z)
	if tile ~= GROUND.RIVER and tile ~= GROUND.IMPASSABLE and tile ~= GROUND.INVALID and IsWaterOrFlood(tile) then
		local gx, gy = TheWorld.Map:GetTileXYAtPoint(x, y, z)
		for i = -1, 1, 1 do
			if not IsWater(TheWorld.Map:GetTile(gx + 1, gy + i)) or not IsWater(TheWorld.Map:GetTile(gx - 1, gy + i)) then
				return true
			end
		end
		return not IsWater(TheWorld.Map:GetTile(gx, gy - 1)) or not IsWater(TheWorld.Map:GetTile(gx, gy + 1))
	end
end

--------------------------------------------------------------------------
--[[ Member variables ]]
--------------------------------------------------------------------------

--Public
self.inst = inst
self.shimmer =
{
	[GROUND.RIVER] = {per_sec = 85, spawn_rate = 0, checkfn = checkgroundnear, spawnfn = SpawnWaveShimmerRiver},
	-- [GROUND.OCEAN_SHORE] = {per_sec = 85, spawn_rate = 0, checkfn = checkshore, spawnfn = SpawnWaveShore},
	[GROUND.OCEAN_SHALLOW] = {per_sec = 75, spawn_rate = 0, checkfn = checkground, spawnfn = SpawnWaveShimmerShallow},
	[GROUND.OCEAN_CORAL] = {per_sec = 80, spawn_rate = 0, checkfn = checkground, spawnfn = SpawnWaveShimmerShallow},
	-- [GROUND.OCEAN_CORAL_SHORE] = {per_sec = 85, spawn_rate = 0, checkfn = checkshore, spawnfn = SpawnWaveShore},
	[GROUND.OCEAN_MEDIUM] = {per_sec = 75, spawn_rate = 0, checkfn = checkground, spawnfn = SpawnWaveShimmerMedium},
	[GROUND.OCEAN_DEEP] = {per_sec = 70, spawn_rate = 0, checkfn = checkground, spawnfn = SpawnWaveShimmerDeep},
	[GROUND.OCEAN_SHIPGRAVEYARD] = {per_sec = 80, spawn_rate = 0, checkfn = checkground, spawnfn = SpawnWaveShimmerDeep},
	[GROUND.MANGROVE] = {per_sec = 80, spawn_rate = 0, checkfn = checkground, spawnfn = SpawnWaveShimmerShallow},
	-- [GROUND.MANGROVE_SHORE] = {per_sec = 85, spawn_rate = 0, checkfn = checkshore, spawnfn = SpawnWaveShore},
	FLOOD = {per_sec = 80, spawn_rate = 0, checkfn = checkflood, spawnfn = SpawnWaveFlood},
	SHORE =  {per_sec = 85, spawn_rate = 0, checkfn = checkshore, spawnfn = SpawnWaveShore},

-- R08_ROT_TURNOFTIDES
	-- [GROUND.OCEAN_COASTAL_SHORE] = {per_sec = 80, spawn_rate = 0, checkfn = checkground, spawnfn = SpawnWaves},
	-- [GROUND.OCEAN_REEF_SHORE] = {per_sec = 80, spawn_rate = 0, checkfn = checkground, spawnfn = SpawnWaves},

	-- [GROUND.OCEAN_COASTAL] = {per_sec = 80, spawn_rate = 0, checkfn = checkground, spawnfn = SpawnWaves},
	-- [GROUND.OCEAN_REEF] = {per_sec = 80, spawn_rate = 0, checkfn = checkground, spawnfn = SpawnWaves},
	-- [GROUND.OCEAN_SWELL] = {per_sec = 80, spawn_rate = 0, checkfn = checkground, spawnfn = SpawnWaveShimmerMedium},
	-- [GROUND.OCEAN_ROUGH] = {per_sec = 80, spawn_rate = 0, checkfn = checkground, spawnfn = SpawnWaveShimmerDeep},
	-- [GROUND.OCEAN_HAZARDOUS] = {per_sec = 80, spawn_rate = 0, checkfn = checkground, spawnfn = SpawnWaveShimmerDeep},
}

-- if CurrentRelease.GreaterOrEqualTo("R08_ROT_TURNOFTIDES") then
	-- self.shimmer[GROUND.OCEAN_COASTAL] = {per_sec = 80, spawn_rate = 0, checkfn = checkground, spawnfn = SpawnWaves}
	-- self.shimmer[GROUND.OCEAN_REEF] = {per_sec = 80, spawn_rate = 0, checkfn = checkground, spawnfn = SpawnWaves}
	-- self.shimmer[GROUND.OCEAN_SWELL] = {per_sec = 80, spawn_rate = 0, checkfn = checkground, spawnfn = SpawnWaveShimmerMedium}
	-- self.shimmer[GROUND.OCEAN_ROUGH] = {per_sec = 80, spawn_rate = 0, checkfn = checkground, spawnfn = SpawnWaveShimmerDeep}
	-- self.shimmer[GROUND.OCEAN_HAZARDOUS] = {per_sec = 80, spawn_rate = 0, checkfn = checkground, spawnfn = SpawnWaveShimmerDeep}
-- end

--Private
local _shimmer_per_sec_mod = TUNING.WATERVISUALSHIMMER
local _camera_per_sec_mod = TUNING.WATERVISUALCAMERA

--------------------------------------------------------------------------
--[[ Functions ]]
--------------------------------------------------------------------------

local function DebugDraw(inst)
	if inst.draw then
		inst.draw:Flush()
		inst.draw:SetRenderLoop(true)
		inst.draw:SetZ(0.15)

		local px, py, pz = inst.Transform:GetWorldPosition()
		local cx, cy, cz = TheWorld.components.ocean:GetCurrentVec3()

		inst.draw:Line(px, pz, 50 * cx + px, 50 * cz + pz, 0, 0, 255, 255)

		local rad = TheWorld.components.ocean:GetCurrentAngle() * DEGREES
		local x, z = 25 * math.cos(rad), 25 * math.sin(rad)

		inst.draw:Line(px, pz, px + x, pz + z, 0, 128, 255, 255)		
	else
		TheSim:SetDebugRenderEnabled(true)
		inst.draw = inst.entity:AddDebugRender()
	end
end

local function getShimmerRadius()
	-- From values from camera_volcano.lua, camera range 30 to 100
	local percent = (TheCamera:GetDistance() - 30) / (70)
	local radius = (75 - 30) * percent + 30
	--print("Shimmer ", TheCamera:GetDistance(), radius)
	return radius
end

local function getPerSecMult(min, max)
	-- From values from camera_volcano.lua, camera range 30 to 100
	local percent = (TheCamera:GetDistance() - 30) / (70)
	local mult = (1.5 - 1) * percent + 1 -- 1x to 1.5x 
	--print("Per sec", TheCamera:GetDistance(), mult)
	return mult
end

function self:OnUpdate(dt)
	
	local px, py, pz = self.inst.Transform:GetWorldPosition()
	local mult = getPerSecMult()

	
	local radius = getShimmerRadius()
	for g, shimmer in pairs(self.shimmer) do
		shimmer.spawn_rate = shimmer.spawn_rate + shimmer.per_sec * _shimmer_per_sec_mod * mult * dt
		while shimmer.spawn_rate > 1.0 do
			local dx, dz = radius * UnitRand(), radius * UnitRand()
			local x, y, z = px + dx, 0, pz + dz
			
			if shimmer.checkfn(self, x, y, z, g) then
				shimmer.spawnfn(self, Vector3(x, y, z))
			end
			shimmer.spawn_rate = shimmer.spawn_rate - 1.0
		end

	end

	if _shimmer_per_sec_mod <= 0.0 and _camera_per_sec_mod <= 0.0 then
		self.inst:StopUpdatingComponent(self)
	end

	-- DebugDraw(self.inst)
end

function self:SetWaveSettings(shimmer_per_sec, camera_per_sec)
	_shimmer_per_sec_mod = shimmer_per_sec or TUNING.WATERVISUALSHIMMER
	_camera_per_sec_mod = camera_per_sec or TUNING.WATERVISUALCAMERA
end

-- function self:OnSave()
	-- return {
		-- shimmer_per_sec_mod = _shimmer_per_sec_mod,
		-- camera_per_sec_mod = _camera_per_sec_mod
	-- }
-- end

-- function self:OnLoad(data)
	-- if data then
		-- _shimmer_per_sec_mod = data.shimmer_per_sec_mod or _shimmer_per_sec_mod
		-- _camera_per_sec_mod = data.camera_per_sec_mod or _camera_per_sec_mod
	-- end
-- end


--Register events
-- inst:ListenForEvent("overrideambientsound", OnOverrideAmbientSound)

inst:StartUpdatingComponent(self)

end)
