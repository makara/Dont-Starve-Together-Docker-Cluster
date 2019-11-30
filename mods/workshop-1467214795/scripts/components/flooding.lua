--Flood tiles are fake water on land tiles, and they're only half as wide as real tiles.
--In SW, it is mostly handled engine-side.
--Flood exists as tides and as Green season puddles.
--The puddle sources are also known as "puddle eyes", but that name is too silly for me to write serious code with it. -M
--They spread flood tiles around themselves, but can be blocked by sandbags.
--There's an implicit bug that prevents the spread if the source tile is blocked directly.
--Sandbags can also be used to entirely remove the flood, but the details are weird and possibly inconsistent.
--Puddles dry up over the course of three days in summer.

--------------------------------------------------------------------------

return Class(function(self, inst)

--------------------------------------------------------------------------
--[[ Constants ]]
--------------------------------------------------------------------------

local _moontideheights =
{
	["new"] = 0,
    ["quarter"] = 5,
    ["half"] = 7,
    ["threequarter"] = 8,
    ["full"] = 10,
}

local _surrounding_offsets = {
	{ .5, 0},
	{ 0, .5},
	{-.5, 0},
	{ 0,-.5},
}


--------------------------------------------------------------------------
--[[ Member variables ]]
--------------------------------------------------------------------------

--Public

self.inst = inst

--Private

local _world = TheWorld
local _map = _world.Map
local _ismastersim = _world.ismastersim

local _activeplayers = {}
local _scheduledtasks = {}

local _israining = false
local _isfloodseason = false
local _seasonprogress = 0

local _maxTide = 0
local _maxTideMod = 1 --settings modifier

local _targetTide = 0
local _currentTide = 0

local _puddles = _ismastersim and {}
local _puddle_xy_lookup = _ismastersim and {}
local _blocker_xy_lookup = _ismastersim and {} --will probably be needed clientside when tides get added

local _nPuddlesLeft

local _targetPuddleHeight = _ismastersim and 0

-- for puddles
local _mapedge_padding = TUNING.MAPEDGE_PADDING
local _maxFloodLevel = _ismastersim and TUNING.MAX_FLOOD_LEVEL
local _timeBetweenFloodIncreases = _ismastersim and TUNING.FLOOD_GROW_TIME
local _timeBetweenFloodDecreases = _ismastersim and TUNING.FLOOD_DRY_TIME
local _spawnerFrequency = _ismastersim and TUNING.FLOOD_FREQUENCY --unused

local _flood_xy_lookup = not _ismastersim and {} --NETVAR
local _spawnFloodEvent
local _removeFloodEvent

--------------------------------------------------------------------------
--[[ Private member functions ]]
--------------------------------------------------------------------------

--forward declare
local RefreshPuddle

local GetTilePt = function(x,y,z)
--gets the floodtile center point for any point (as in entity position)
	y = z or y

	local w, h = _map:GetSize()
	-- (x + w/2) / TILE_SCALE
	return
		(math.floor(x) + (math.floor(x+1)%2)) / TILE_SCALE + w/2,
		(math.floor(y) + (math.floor(y+1)%2)) / TILE_SCALE + h/2
end

local SetFloodTile = function(x,y,b)
	b = b==true or nil
	--[[ --NETVAR
	--When trying the netvar again, don't forget to disable AddNetworkProxy in prefabs/flood.lua!
	if _ismastersim then
		local w, h = _map:GetSize()
		local dx = (x - .25) * 2
		local dy = (y - .25) * 2 * (w*2)
		if b then
			print("SET EVENT",x,y,dx,dy)
			_spawnFloodEvent:set(dx + dy)
			_spawnFloodEvent:set_local(0)
		else
			_removeFloodEvent:set(dx + dy)
			_removeFloodEvent:set_local(0)
		end
	end
	]]
	SetTileState(x,y,"flood",b)
	if not _ismastersim then
		local tile = GetTileState(x,y,"flood")
		if tile then
			tile._ms_controlled = true
		end
	end
end

--change this to define _targetTide instead
--[[
function self:GetTideHeight()

	local nightLength = GetClock():GetNightTime()
	local duskLength = GetClock():GetDuskTime()

	--Floods start at the beginning of evening and end at daybreak, in that time they interpolate to max height and back to zero
	local timepassed = 0

	local time = GetClock():GetNormTime()
	local tidePerc = 0
	local startGrowTime = 1.0 - 3/16
	local startShrinkTime = 0
	local endShrinkTime = 3/16

	if time > startGrowTime then
		tidePerc = (time - startGrowTime)/(3/16)
	elseif time > startShrinkTime and time < endShrinkTime then
		tidePerc = 1.0 - (time/(endShrinkTime - startShrinkTime))
	end

	return _maxTide * _maxTideMod * tidePerc
end
]]

local RemovePuddle = _ismastersim and function(puddle)
	--for convenience, this function accepts indexes or data
	local i
	if type(puddle) == "number" then
		i = puddle
		puddle = _puddles[i]
	end
	if not puddle then return end
	if not i then
		for j, p in pairs(_puddles) do
			if p == puddle then
				i = j
				break
			end
		end
	end
	--do the actual RemovePuddle
	if puddle.radius > 0 then
		puddle.radius = 0
		RefreshPuddle(puddle)
	end
	table.remove(_puddles, i)
	_puddle_xy_lookup[puddle.x][puddle.y] = nil
	if not next(_puddle_xy_lookup[puddle.x]) then
		_puddle_xy_lookup[puddle.x] = nil
	end
end

--forward declared
RefreshPuddle = _ismastersim and function(puddle, skipwetcheck)
	-- print("Refresh puddle...",puddle)

	-- remove tiles, iterating backwards to allow removal
	for i = #puddle._children, 1, -1 do
		local pt = puddle._children[i]
		local tile = GetTileState(pt[1],pt[2],"flood")
		if not tile or tile.val == nil then
			table.remove(puddle._children, i)
			-- print("REMOVE BY INVALID")

		-- calculate taxicab distance
		elseif 2* math.abs(puddle.x - pt[1]) + 2* math.abs(puddle.y - pt[2]) >= puddle.radius then
			-- remove this source
			-- print("Remove a child",pt[1],pt[2])
			tile.sources = tile.sources or {}
			tile.sources[puddle] = nil
			if not next(tile.sources) then
				-- print("REMOVE BY DISTANCE",puddle.radius)
				SetFloodTile(pt[1],pt[2],false)
				table.remove(puddle._children, i)
			end
		end
	end

	-- do not expand if there's no radius
	if puddle.radius < 1 then return end
	-- do not expand if the source is blocked (implicit in reachable check)
	-- if _blocker_xy_lookup[puddle.x] and _blocker_xy_lookup[puddle.x][puddle.y] then return end
	-- do not expand if the source is dry
	if not skipwetcheck and not GetTileState(puddle.x,puddle.y,"flood") then return end
	-- confirm that we can reach this tile via taxicab distance before flooding it!
	local reachable = {}
	local q1 = {{puddle.x, puddle.y}}
	local q2 = {}
	for i = 1, puddle.radius do
		for _, pt in pairs(q1) do
			-- print("Try flood",pt[1],pt[2])
			local ground = _map:GetTile(math.ceil(pt[1] -.5), math.ceil(pt[2] -.5))
			if not (_blocker_xy_lookup[pt[1]] and _blocker_xy_lookup[pt[1]][pt[2]])
			and IsLand(ground) and ground ~= GROUND.IMPASSABLE then
				reachable[pt[1]] = reachable[pt[1]] or {}
				reachable[pt[1]][pt[2]] = true
				-- print("Valid")
				for _, offset in pairs(_surrounding_offsets) do
					local qx = pt[1] + offset[1]
					local qy = pt[2] + offset[2]
					if not (reachable[qx] and reachable[qx][qy]) then
						-- print("Queued:",qx,qy)
						table.insert(q2,{qx, qy})
					end
				end
			end
		end
		q1 = q2
		q2 = {}
	end

	-- do not expand if the source is dry and separated from all wet
	-- if not skipwetcheck then
		-- local sourcewet = false
		-- for tx, y in pairs(reachable) do
			-- for ty, _ in pairs(y) do
				-- local tile = GetTileState(tx,ty,"flood")
				-- if tile and tile.val then
					-- sourcewet = true
					-- break
				-- end
			-- end
			-- if sourcewet then break end
		-- end
		-- if not sourcewet then return end
	-- end

	-- add tiles, iterating the previously calculated points

	-- for rx = -puddle.radius, puddle.radius do
		-- for ry = -puddle.radius + math.abs(rx), puddle.radius - math.abs(rx) do
			-- local tx = rx * .5 + puddle.x
			-- local ty = ry * .5 + puddle.y
			-- print("Trying to add a child",rx,ry,tx,ty)
	for tx, y in pairs(reachable) do
		for ty, _ in pairs(y) do
			-- print("Trying to add a child",tx,ty)

			-- local ground = _map:GetTile(math.ceil(tx -.5), math.ceil(ty -.5))
			-- if IsLand(ground) and ground ~= GROUND.IMPASSABLE then

				-- print("Add it")
				-- add it
				local tile = GetTileState(tx,ty,"flood")
				if not tile or tile.val == nil then
					SetFloodTile(tx,ty,true)
					tile = GetTileState(tx, ty, "flood")
				end
				tile.sources = tile.sources or {}
				if not tile.sources[puddle] then
					tile.sources[puddle] = true
					table.insert(puddle._children, {tx,ty})
				end
			-- end
    	end
	end

	if #puddle._children == 0 then
		RemovePuddle(puddle)
	end

end

local InitialiseChildren = _ismastersim and function(puddle)
	-- print("Init puddle...",puddle)
	for i, pt in ipairs(puddle._children) do
		local ground = _map:GetTile(math.ceil(pt[1] -.5), math.ceil(pt[2] -.5))
		if IsLand(ground) and ground ~= GROUND.IMPASSABLE then
			-- print("Add it")
			-- add it
			local tile = GetTileState(pt[1],pt[2],"flood")
			if not tile or tile.val == nil then
				SetFloodTile(pt[1],pt[2],true)
				tile = GetTileState(pt[1], pt[2], "flood")
			end
			tile.sources = tile.sources or {}
			if not tile.sources[puddle] then
				tile.sources[puddle] = true
				-- table.insert(puddle._children, {pt[1],pt[2]})
			end
		end
	end
end

local SpawnPuddleFromData = _ismastersim and function(data)
	assert( data.x ~= nil and data.y ~= nil )
	data.radius = data.radius or 2
	data._children = data._children or {}

	if _puddle_xy_lookup[data.x] and _puddle_xy_lookup[data.x][data.y] then
		-- print("ALREADY HAS A PUDDLE")
		_puddle_xy_lookup[data.x][data.y].radius = math.max(_puddle_xy_lookup[data.x][data.y].radius, data.radius)
		return false
	else
		print("SPAWN PUDDLE",data.x,data.y)

		table.insert(_puddles, data)
		_puddle_xy_lookup[data.x] = _puddle_xy_lookup[data.x] or {}
		_puddle_xy_lookup[data.x][data.y] = data

		if #data._children > 0 then
			InitialiseChildren(data)
		else
			RefreshPuddle(data, true)
		end
		return true
	end
end

--This takes about 6 guesses to find a valid spot. That doesn't seem to impair performance too much.
--We could assemble a list of valid spots to reduce the time this takes, but that might cause a lagspike.
local TrySpawnRandomPuddle = _ismastersim and function()
	local w,h = _map:GetSize()
	local x = math.random(_mapedge_padding, w *2 - _mapedge_padding) / 2 + .25
	local y = math.random(_mapedge_padding, h *2 - _mapedge_padding) / 2 + .25
	local ground = _map:GetTile(math.ceil(x -.5), math.ceil(y -.5))

	if IsLand(ground) and ground ~= GROUND.IMPASSABLE and not GROUND_FLOORING[ground]
	and IsInIAClimate(Vector3((x - w/2)  * TILE_SCALE, 0, (y - h/2) * TILE_SCALE)) then
		if SpawnPuddleFromData({x=x,y=y}) then
			_nPuddlesLeft = _nPuddlesLeft - 1
			-- print("TrySpawnRandomPuddle success! Left:",_nPuddlesLeft)
		end
	else
		-- print("Failed to TrySpawnRandomPuddle")
	end
end

--------------------------------------------------------------------------
--[[ Private event handlers ]]
--------------------------------------------------------------------------

--For when a sandbag or other floodblocker is removed
local floodblockerremoved =  _ismastersim and function(src, data)
	local bx, by, bz = data.blocker.Transform:GetWorldPosition()
	local x, y = GetTilePt(bx,by,bz)
	-- print("floodblockerremoved",x,y)

	if _blocker_xy_lookup[x] then
		_blocker_xy_lookup[x][y] = nil
		if not next(_blocker_xy_lookup[x]) then
			_blocker_xy_lookup[x] = nil
		end
	end
	-- refresh any puddles touching the affected tile
	-- flood doesn't (usually) survive if it gets blocked, so skip the tile itself
	local puddles = {}
	for _, offset in pairs(_surrounding_offsets) do
		local tile = GetTileState(x + offset[1], y + offset[2], "flood")
		if tile and tile.sources then
			for puddle, _ in pairs(tile.sources) do
				puddles[puddle] = true
			end
		end
	end
	for puddle, _ in pairs(puddles) do
		RefreshPuddle(puddle)
	end
end

local floodblockercreated = _ismastersim and function(src, data)
	local bx, by, bz = data.blocker.Transform:GetWorldPosition()
	local x, y = GetTilePt(bx,by,bz)
	-- print("floodblockercreated",x,y)

	if not _blocker_xy_lookup[x] then
		_blocker_xy_lookup[x] = {}
	end
	_blocker_xy_lookup[x][y] = true
	-- check if flood gets removed
	local tile = GetTileState(x, y, "flood")
	if tile then
		if tile.sources then
			-- inform the puddles
			for puddle, _ in pairs(tile.sources) do
				for i, pt in pairs(puddle._children) do
					if pt[1] == x and pt[2] == y then
						-- print("REMOVE BY BLOCKER",puddle)
						table.remove(puddle._children, i)
						break
					end
				end
				if #puddle._children == 0 then
					RemovePuddle(puddle)
				end
			end
		end
		SetFloodTile(x, y, false)
	end
end

local seasontick = _ismastersim and function(src, data)
	_seasonprogress = data.progress or 0
	_isfloodseason =
		data.season == "spring" and data.progress >= 0.25
		-- or data.season == "summer" and data.progress < 0.25 --summer is not necessarily the next season!
end

local moonphasechanged = _ismastersim and function(src, phase)
	assert( phase ~= nil )
	_maxTide = _moontideheights[ phase ] or 0
end

local precipitation_islandchanged = _ismastersim and function(src, bool)
	_israining = bool
end

local spawnflooddirty = not _ismastersim and function(src, data)
	local w, h = _map:GetSize()
	local x = (data % (w*2)) * .5 + .25
	local y = math.floor(data / (w*2)) * .5 + .25
	print("spawnflooddirty",x,y)
	SetFloodTile(x,y,true)
end

local removeflooddirty = not _ismastersim and function(src, data)
	local w, h = _map:GetSize()
	local x = (data % (w*2)) * .5 + .25
	local y = math.floor(data / (w*2)) * .5 + .25
	print("removeflooddirty",x,y)
	SetFloodTile(x,y,false)
end

--------------------------------------------------------------------------
--[[ Initialization ]]
--------------------------------------------------------------------------

--[[ --NETVAR
do
	--try to conserve bandwith by taking the smallest possible netvar (probably net_uint)
	local w, h = _map:GetSize()
	local netvar = w * 2 * h * 2 < 65535 and net_ushortint or net_uint
	_spawnFloodEvent = netvar(inst.GUID, "flooding._spawnFloodEvent","spawnflooddirty")
	_spawnFloodEvent:set_local(0)
	_removeFloodEvent = netvar(inst.GUID, "flooding._removeFloodEvent","removeflooddirty")
	_removeFloodEvent:set_local(0)
end
]]

--Register events
if _ismastersim then
	inst:ListenForEvent("floodblockerremoved", floodblockerremoved, _world)
	inst:ListenForEvent("floodblockercreated", floodblockercreated, _world)
	inst:ListenForEvent("seasontick", seasontick, _world)
	inst:ListenForEvent("moonphasechanged", moonphasechanged, _world)
	inst:ListenForEvent("precipitation_islandchanged", precipitation_islandchanged, _world)
end
--[[ --NETVAR
if not _ismastersim then
	inst:ListenForEvent("spawnflooddirty", spawnflooddirty, _world)
	inst:ListenForEvent("removeflooddirty", removeflooddirty, _world)
end
]]

inst:StartUpdatingComponent(self)

--------------------------------------------------------------------------
--[[ Public member functions ]]
--------------------------------------------------------------------------

--mostly there in case something still tries to use it
function self:GetIsFloodSeason()
	return _isfloodseason
end
function self:SetFloodSettings(maxLevel, frequency)
	_maxFloodLevel = math.min(maxLevel, TUNING.MAX_FLOOD_LEVEL)
	_spawnerFrequency = frequency
end
function self:SetMaxTideModifier(mod)
	_maxTideMod = mod
end


-- NETVAR
function self:AddFloodTile(tile)
	local px, py = GetTilePt(tile.Transform:GetWorldPosition())
	if not _flood_xy_lookup[px] then
		_flood_xy_lookup[px] = {}
	end
	_flood_xy_lookup[px][py] = tile
end
function self:RemoveFloodTile(tile)
	local px, py = GetTilePt(tile.Transform:GetWorldPosition())
	if _flood_xy_lookup[px] then
		_flood_xy_lookup[px][py] = nil
		if not next(_flood_xy_lookup[px]) then
			_flood_xy_lookup[px] = nil
		end
	end
end

function self:P(player)
	print(GetTilePt(player:GetPosition():Get()))
end
function self:IsPointOnFlood(x,y,z)
	local px, py = GetTilePt(x,z)
	local tile = GetTileState(px, py, "flood")
	return tile ~= nil and tile.val
		or _flood_xy_lookup and _flood_xy_lookup[px] and _flood_xy_lookup[px][py] ~= nil -- NETVAR
end
self.OnFlood = self.IsPointOnFlood
-- function self:OnFlood(x,y,z)
	-- return self:IsPointOnFlood(x,y,z)
-- end


if _ismastersim then

--must be entity-coords, not tile coords, radius is optional (2 is default)
function self:SpawnPuddle(x,y,z,radius)
	local px, py = GetTilePt(x,z)

	local ground = _map:GetTile(_map:GetTileCoordsAtPoint(px, 0, py))
	if IsLand(ground) and ground ~= GROUND.IMPASSABLE and not GROUND_FLOORING[ground] then
		-- print("INVALID GROUND FOR PUDDLE")
		return
	else
		SpawnPuddleFromData({
			x = px,
			y = py,
			radius = radius,
		})
	end
end

self.SetPositionPuddleSource = self.SpawnPuddle

end -- _ismastersim

--------------------------------------------------------------------------
--[[ Update ]]
--------------------------------------------------------------------------
local ntries = 0
function self:OnUpdate( dt )

	if _ismastersim then
	--puddle growth is calculated serverside only
		if _isfloodseason then
			local perc = math.max(0, (_seasonprogress - 0.25)/0.75) --Don't spawn floods in the first 1/4 of the season
			_targetPuddleHeight = math.ceil(_maxFloodLevel * perc)
			--There are no puddles in the world? Start spawning them!
			if _israining and _nPuddlesLeft == nil and next(_puddle_xy_lookup) == nil and _spawnerFrequency > 0 then
				local w,h = _map:GetSize()
				_nPuddlesLeft = math.floor(w * .4)
			end
		else
			_targetPuddleHeight = 0
		end

		--Try spawning a puddle
		--Doing this not all at the same tick is probably helpful against local and network lag. -M
		if _nPuddlesLeft then
			ntries = ntries + 1
			TrySpawnRandomPuddle()
			if _nPuddlesLeft <= 0 then
				_nPuddlesLeft = nil
			end
		end

		if #_puddles > 0 then
			for i = #_puddles, 1, -1 do
				local puddle = _puddles[i]

				if _isfloodseason then
					if _israining then --only increase if currently in rain
						puddle.timeSinceIncrease = (puddle.timeSinceIncrease or 0) + dt
						if puddle.timeSinceIncrease > _timeBetweenFloodIncreases then
							puddle.timeSinceIncrease = 0
							if puddle.radius < _targetPuddleHeight then
								puddle.radius = puddle.radius + 1
								RefreshPuddle(puddle)
							end
						end
					end
				else
					--Dry the puddles away!
					puddle.timeSinceDecrease = (puddle.timeSinceDecrease or 0) + dt
					if puddle.timeSinceDecrease > _timeBetweenFloodDecreases then
						-- print("DRY!",puddle)
						puddle.timeSinceDecrease = 0
						puddle.radius = math.max(puddle.radius - 1, 0)
						RefreshPuddle(puddle)
						if puddle.radius <= 0 then
							RemovePuddle(i)
						end
					end
				end
			end
		end
	end -- _ismastersim

	--Tides stuff
	-- local currentHeight = GetWorld().Flooding:GetTargetDepth()
	-- local newHeight = self:GetTideHeight()
	-- GetWorld().Flooding:SetTargetDepth(newHeight)

	-- if newHeight < currentHeight then
		-- --Flood receding
	-- end

	-- if newHeight == 0 and GetIsFloodSeason() then
		-- self:SwitchMode("flood")
	-- end

	-- self.inst:PushEvent("floodChange")
end

function self:LongUpdate(dt)
	self:OnUpdate(dt)
end

--------------------------------------------------------------------------
--[[ Save/Load ]]
--------------------------------------------------------------------------

if _ismastersim then

function self:OnSave()
	local data = {}

	data._targetPuddleHeight = _targetPuddleHeight
	data._nPuddlesLeft = _nPuddlesLeft

	-- if #_puddles > 0 then
		-- data._puddles = {}
		-- for i, puddle in pairs(_puddles) do
			-- table.insert(data._puddles,{x=puddle.x,y=puddle.y,radius=puddle.radius})
		-- end
	-- end
	data._puddles = _puddles

	return data
end

function self:OnLoad(data)
	if data ~= nil then

		_targetPuddleHeight = data._targetPuddleHeight or 0
		_nPuddlesLeft = data._nPuddlesLeft

		if data._puddles then
			-- local w, h = _map:GetSize()
			for i, puddle in pairs(data._puddles) do
				-- self:SpawnPuddle((puddle.x - w/2)  * TILE_SCALE, 0, (puddle.y - h/2) * TILE_SCALE, puddle.radius)
				SpawnPuddleFromData(puddle)
			end
		end

	end
end

end -- _ismastersim

--------------------------------------------------------------------------
--[[ Debug ]]
--------------------------------------------------------------------------

function self:GetDebugString()
	return string.format("tides: %d/%d, max %d, mod %d", _currentTide, _targetTide, _maxTide, _maxTideMod)
end

function self:ShowPuddles()
	--shows all puddles on the map, as rawling
	for x, dy in pairs(_puddle_xy_lookup) do
		for y, puddle in pairs(dy) do
			if puddle._children and #puddle._children > 0 then
				local minimap = GetTileState(puddle._children[1][1],puddle._children[1][2],"flood").inst.entity:AddMiniMapEntity()
				minimap:SetIcon( "rawling.tex" )
			end
		end
	end
end

--------------------------------------------------------------------------

end)
