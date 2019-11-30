local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

local tiles = require "worldtiledefs"

--------------------------------- WORLD-GEN START ---------------------------------

function GetShortestDistToPrefab(x, y, ents, prefab)
	local w, h = WorldSim:GetWorldSize()
	local halfw, halfh = w / 2, h / 2
	local dist = 100000
	if ents ~= nil and ents[prefab] ~= nil then
		for i,spawn in ipairs(ents[prefab]) do
			local sx, sy = spawn.x, spawn.z
			local dx, dy = (x - halfw)*TILE_SCALE - sx, (y - halfh)*TILE_SCALE - sy
			local d = math.sqrt(dx * dx + dy * dy)
			if d < dist then
				dist = d
			end
			--print(string.format("GetShortestDistToPrefab (%d, %d) -> (%d, %d) = %d", x, y, sx, sy, dist))
		end
	end
	return dist
end

function GetDistToSpawnPoint(x, y, ents)
	return GetShortestDistToPrefab(x, y, ents, "spawnpoint")
end

function GetDistFromEdge(x, y, w, h)
	local distx = math.min(x, w - x)
	local disty = math.min(y, h - y)
	local dist = math.min(distx, disty)
	--print(string.format("GetDistanceFromEdge (%d, %d), (%d, %d) = %d\n", x, y, w, h, dist))
	return dist
end

-- Simple, obstinate function for worldgen tests; use IsWater() during the actual game
function IsWaterTile(ground)
	return ground == GROUND.RIVER or
    ground == GROUND.OCEAN_SHALLOW or
    ground == GROUND.OCEAN_MEDIUM or
    ground == GROUND.OCEAN_DEEP or
    ground == GROUND.OCEAN_CORAL or
    ground == GROUND.OCEAN_SHIPGRAVEYARD or
    ground == GROUND.MANGROVE
end

-- Simple, obstinate function for worldgen tests; use IsShore() during the actual game
function IsShoreTile(ground)
	return ground == GROUND.MANGROVE or
		(not IsWaterTile(ground) and (not GROUND.OCEAN_START or ground < GROUND.OCEAN_START))
end

function IsCloseToShore(x, y, radius)
	radius = radius or 1
	for i = -radius, radius, 1 do
		if IsShoreTile(WorldSim:GetTile(x - radius, y + i)) or IsShoreTile(WorldSim:GetTile(x + radius, y + i)) then
			return true
		end
	end
	for i = -(radius - 1), radius - 1, 1 do
		if IsShoreTile(WorldSim:GetTile(x + i, y - radius)) or IsShoreTile(WorldSim:GetTile(x + i, y + radius)) then
			return true
		end
	end
	return false
end

function IsSurroundedByWater(x, y, radius)
	radius = radius or 1
	for i = -radius, radius, 1 do
		if not IsWaterTile(WorldSim:GetTile(x - radius, y + i)) or not IsWaterTile(WorldSim:GetTile(x + radius, y + i)) then
			return false
		end
	end
	for i = -(radius - 1), radius - 1, 1 do
		if not IsWaterTile(WorldSim:GetTile(x + i, y - radius)) or not IsWaterTile(WorldSim:GetTile(x + i, y + radius)) then
			return false
		end
	end
	return true
end

function IsSurroundedByLand(x, y, radius)
	radius = radius or 1
	for i = -radius, radius, 1 do
		if IsWaterTile(WorldSim:GetTile(x - radius, y + i)) or IsWaterTile(WorldSim:GetTile(x + radius, y + i)) then
			return false
		end
	end
	for i = -(radius - 1), radius - 1, 1 do
		if IsWaterTile(WorldSim:GetTile(x + i, y - radius)) or IsWaterTile(WorldSim:GetTile(x + i, y + radius)) then
			return false
		end
	end
	return true
end

function IsWaterOrInvalid(ground)
	return IsWaterTile(ground) or ground == GROUND.INVALID
end

function IsWaterOrImpassable(ground)
	return IsWaterTile(ground) or ground == GROUND.IMPASSABLE
end

function IsSurroundedByWaterOrInvalid(x, y, radius)
	radius = radius or 1
	for i = -radius, radius, 1 do
		if not IsWaterOrInvalid(WorldSim:GetTile(x - radius, y + i)) or not IsWaterOrInvalid(WorldSim:GetTile(x + radius, y + i)) then
			return false
		end
	end
	for i = -(radius - 1), radius - 1, 1 do
		if not IsWaterOrInvalid(WorldSim:GetTile(x + i, y - radius)) or not IsWaterOrInvalid(WorldSim:GetTile(x + i, y + radius)) then
			return false
		end
	end
	return true
end

function IsCloseToWater(x, y, radius)
	radius = radius or 1
	for i = -radius, radius, 1 do
		if IsWaterTile(WorldSim:GetTile(x - radius, y + i)) or IsWaterTile(WorldSim:GetTile(x + radius, y + i)) then
			return true
		end
	end
	for i = -(radius - 1), radius - 1, 1 do
		if IsWaterTile(WorldSim:GetTile(x + i, y - radius)) or IsWaterTile(WorldSim:GetTile(x + i, y + radius)) then
			return true
		end
	end
	return false
end

function IsCloseToLand(x, y, radius)
	radius = radius or 1
	for i = -radius, radius, 1 do
		if not IsWaterOrImpassable(WorldSim:GetTile(x - radius, y + i)) or not IsWaterOrImpassable(WorldSim:GetTile(x + radius, y + i)) then
			return true
		end
	end
	for i = -(radius - 1), radius - 1, 1 do
		if not IsWaterOrImpassable(WorldSim:GetTile(x + i, y - radius)) or not IsWaterOrImpassable(WorldSim:GetTile(x + i, y + radius)) then
			return true
		end
	end
	return false
end

function IsCloseToTileType(x, y, radius, tile)
	radius = radius or 1
	for i = -radius, radius, 1 do
		if WorldSim:GetTile(x - radius, y + i) == tile or WorldSim:GetTile(x + radius, y + i) == tile then
			return true
		end
	end
	for i = -(radius - 1), radius - 1, 1 do
		if WorldSim:GetTile(x + i, y - radius) == tile or WorldSim:GetTile(x + i, y + radius) == tile then
			return true
		end
	end
	return false
end

local commonspawnfn = {
	spiderden = function(x, y, ents)
		return not IsCloseToWater(x, y, 5) and GetDistToSpawnPoint(x, y, ents) >= 100
	end,
	fishinhole = function(x, y, ents)
		local tile = WorldSim:GetTile(x, y)
		return (tile == GROUND.OCEAN_CORAL or tile == GROUND.MANGROVE or (IsWaterTile(tile) and not IsCloseToTileType(x, y, 5, GROUND.OCEAN_SHALLOW))) and IsSurroundedByWater(x, y, 1)
	end,
	tidalpool = function(x, y, ents)
		return not IsCloseToWater(x, y, 2) and GetShortestDistToPrefab(x, y, ents, "tidalpool") >= 3 * TILE_SCALE
	end,

	seashell_beached = function(x, y, ents)
		return (not IsCloseToWater(x, y, 1)) and IsCloseToWater(x,y,4)
	end,
	mangrovetree = function(x, y, ents)
		return WorldSim:GetTile(x, y) == GROUND.MANGROVE and IsSurroundedByWater(x, y, 1)
	end,
	grass_water = function(x, y, ents)
		return WorldSim:GetTile(x, y) == GROUND.MANGROVE and IsSurroundedByWater(x, y, 1)
	end,
	
	shipgravefog = function(x, y, ents)
		return GetShortestDistToPrefab(x, y, ents, "shipgravefog") >= 16 * TILE_SCALE
	end
	
}

local function surroundedbywater(x, y, ents)
	return IsSurroundedByWater(x, y, 1)
end

local function notclosetowater(x, y, ents)
	return not IsCloseToWater(x, y, 1)
end


local waterprefabs =
{
	"rock_coral", "seaweed_planted", "mussel_farm", "lobsterhole", "messagebottle", "messagebottleempty", "wreck"
}

local landprefabs =
{
	"jungletree", "palmtree", "bush_vine", "rock_limpet", "sanddune", "sapling", "poisonhole",
	"wildborehouse", "mermhouse", "magmarock", "magmarock_gold", "flower", "fireflies", "grass",
	"bambootree", "berrybush", "berrybush_snake", "berrybush2", "berrybush2_snake", "crabhole", "rock1", "rock2",
	"rock_flintless", "rocks", "flint", "goldnugget", "gravestone", "mound", "red_mushroom", "blue_mushroom",
	"green_mushroom", "carrot_planted", "beehive", "reeds", "marsh_tree", "snakeden", "pond", "primeapebarrel",
	"mandrake", "mermhouse_fisher", "sweet_potato_planted", "flup", "flupspawner_sparse", "wasphive",
	"beachresurrector", "flower_evil", "crate", "tallbirdnest"
}


for i = 1, #waterprefabs, 1 do
	assert(commonspawnfn[waterprefabs[i]] == nil) --don't replace an existing one
	commonspawnfn[waterprefabs[i]] = surroundedbywater
end

for i = 1, #landprefabs, 1 do
	assert(commonspawnfn[landprefabs[i]] == nil) --don't replace an existing one
	commonspawnfn[landprefabs[i]] = notclosetowater
end


function SpawntestFn(prefab, x, y, ents)
	return prefab ~= nil and (commonspawnfn[prefab] == nil or commonspawnfn[prefab](x, y, ents))
end

function GetLayoutRadius(layout, prefabs)
	assert(layout ~= nil)
	assert(prefabs ~= nil)

	local extents = {xmin = 1000000, ymin = 1000000, xmax = -1000000, ymax = -1000000}
	for i = 1, #prefabs, 1 do
		--print(string.format("Prefab %s (%4.2f, %4.2f)", tostring(prefabs[i].prefab), prefabs[i].x, prefabs[i].y))
  if prefabs[i].x < extents.xmin then extents.xmin = prefabs[i].x end
if prefabs[i].x > extents.xmax then extents.xmax = prefabs[i].x end
if prefabs[i].y < extents.ymin then extents.ymin = prefabs[i].y end
if prefabs[i].y > extents.ymax then extents.ymax = prefabs[i].y end
end

local e_width, e_height = extents.xmax - extents.xmin, extents.ymax - extents.ymin
local size = math.ceil(layout.scale * math.max(e_width, e_height))

if layout.ground then
  size = math.max(size, #layout.ground)
end

	--print(string.format("Layout %s dims (%4.2f x %4.2f), size %4.2f", layout.name, e_width, e_height, size))

	return size
end

-- for in-game checks, use FindRandomWaterPoints
--overrides basegame function from RoT, so populating_tile may be a function or nil.
function GetRandomWaterPoints(populating_tile, width, height, edge_dist, needed)
	local points = {}
	local points_x = {}
	local points_y = {}
	local incs = {263, 137, 67, 31, 17, 9, 5, 3, 1}
	local adj_width, adj_height = width - 2 * edge_dist, height - 2 * edge_dist
	local start_x, start_y = math.random(0, adj_width), math.random(0, adj_height)
	
	for inc = 1, #incs, 1 do
		if #points < needed then
			
			--dunno why this was a function
			local i, j = 0, 0
			while j < adj_height and #points < needed do
				local y = ((start_y + j) % adj_height) + edge_dist
				while i < adj_width and #points < needed do
					local x = ((start_x + i) % adj_width) + edge_dist
					--local ground = WorldSim:GetTile(x, y)
					--if populating_tile(ground, x, y) then
					if populating_tile == nil
					or (type(populating_tile) == "function" and populating_tile(WorldSim:GetTile(x,y),x,y,points) )
					or (type(populating_tile) == "number" and not WorldSim:IsTileReserved(x,y) and populating_tile == WorldSim:GetTile(x,y) ) then
						table.insert(points, {x=x, y=y})
					end
					i = i + incs[inc]
				end
				j = j + incs[inc]
				i = 0
			end
			
			--print(string.format("%d (of %d) points found", #points, needed))
		end
	end

	points = shuffleArray(points)
	for i = 1, #points, 1 do
		table.insert(points_x, points[i].x)
		table.insert(points_y, points[i].y)
	end

	return points_x, points_y
end

--------------------------------- WORLD-GEN END ---------------------------------


-- use IsWaterTile during worldgen, this only works during the actual game
function IsWater(ground)
    if ground == GROUND.IMPASSABLE or ground == GROUND.INVALID then
        return true
    end
    local info = GetTileInfo(ground)
    return info ~= nil and info.water or false
end

function IsLand(ground)
    if ground == GROUND.IMPASSABLE or ground == GROUND.INVALID then
        return true
    end
    local info = GetTileInfo(ground)
    return info ~= nil and (info.land or info.land == nil) or false
end

-- use IsShoreTile during worldgen, this only works during the actual game
function IsShore(ground)
    local info = GetTileInfo(ground)
    return info ~= nil and info.isshore
	or ground == GROUND.OCEAN_COASTAL_SHORE or ground == GROUND.OCEAN_REEF_SHORE --R08_ROT_TURNOFTIDES
end

function IsWaterOrFlood(ground)
    return IsWater(ground) --TODO check for flood/tide once that is supported
	--TODO how is this supposed to know *where* to check? It can't smell coordinates from a groundtype! -M
	--I made IsOnFlood to use instead, or use IsOnWater(x,y,z,true) -M
end

function IsNotFloodedLand(ground)
    return IsLand(ground) --TODO check for tile not being flooded/tided once that is supported
end

local RenderTileOrder

function GetVisualTileType(ptx, pty, ptz, percentile)
    percentile = percentile or .25

    if TheWorld.Map then

        if(ptx == nil or ptz == nil) then 
            assert(ptx ~= nil and ptz ~= nil, "trying to get tiletype for a nil position!")
            --print(debug.traceback())
        end


        local tilecenter_x, tilecenter_y,tilecenter_z  = TheWorld.Map:GetTileCenterPoint(ptx,0,ptz)
        local tx, ty = TheWorld.Map:GetTileCoordsAtPoint(ptx, 0, ptz)
        local actual_tile = TheWorld.Map:GetTile(tx, ty)
        
        if actual_tile and tilecenter_x and tilecenter_z then
            local xpercent = ((tilecenter_x - ptx)/TILE_SCALE) + .5
            local ypercent = ((tilecenter_z - ptz)/TILE_SCALE) + .5
            
            local x_off = 0
            local y_off = 0
            
            local x_min = 0
            local x_max = 0
            local y_min = 0
            local y_max = 0

            if xpercent < percentile then
                x_max = 1
                
            elseif xpercent > 1 - percentile then
                x_min = -1
            end

            if ypercent < percentile then
                y_max = 1
                
            elseif ypercent > 1 - percentile then
                y_min = -1
            end
            
            for x = x_min, x_max do
                for y = y_min, y_max do
                    local tile = TheWorld.Map:GetTile(tx + x, ty + y)
                    if not RenderTileOrder then
                        RenderTileOrder = {}
                        for i, v in ipairs(tiles.ground) do
                            RenderTileOrder[v[1]] = i
							if v[1] >= GROUND.OCEAN_START and v[1] <= GROUND.OCEAN_END then
								RenderTileOrder[v[1]] = -1
							end
                        end
                    end
                    if (RenderTileOrder[tile] or 0) > (RenderTileOrder[actual_tile] or 0) then
                        actual_tile = tile
                        x_off = x
                        y_off = y
                    end
                end
            end
            
            return actual_tile
        end     
    end
    return GROUND.IMPASSABLE
end

function IsOnFlood(x, y, z)
	return TheWorld.components.flooding and TheWorld.components.flooding:OnFlood(x,y,z)
end

function IsOnWater(x, y, z, flood, percentile)
    if type(x) == "table" then
        if x.x then
            x, y, z = x.x, x.y, x.z
        elseif x.Transform then
            x, y, z = x.Transform:GetWorldPosition()
        end
    end
    
    -- local iswater = flood and IsWaterOrFlood or IsWater
    -- Calculating the visual tile that much may be taxing...
    -- return iswater(TheWorld.Map:GetTileAtPoint(x,y,z))
    return IsWater(GetVisualTileType(x,y,z,percentile)) or flood and IsOnFlood(x,y,z)
end

function IsOnLand(x, y, z, flood, percentile)
    if type(x) == "table" then
        if x.x then
            x, y, z = x.x, x.y, x.z
        elseif x.Transform then
            x, y, z = x.Transform:GetWorldPosition()
        end
    end
    
    -- local island = flood and IsNotFloodedLand or IsLand
    -- Calculating the visual tile that much may be taxing...
    -- return island(TheWorld.Map:GetTileAtPoint(x,y,z))
    return IsLand(GetVisualTileType(x,y,z,percentile)) or flood and IsOnFlood(x,y,z)
end

-- for worldgen checks, use GetRandomWaterPoints
-- this works tile coords, not actual ingame points
function FindRandomWaterPoints(checkFn, edge_dist, needed)
	local width, height = TheWorld.Map:GetSize()
	local get_points = function(points, checkFn, edge_dist, inc)
		local adj_width, adj_height = width - 2 * edge_dist, height - 2 * edge_dist
		local start_x, start_y = math.random(0, adj_width), math.random(0, adj_height)
		local i, j = 0, 0
		while j < adj_height and #points < needed do
			local y = ((start_y + j) % adj_height) + edge_dist
			while i < adj_width and #points < needed do
				local x = ((start_x + i) % adj_width) + edge_dist
				--local ground = WorldSim:GetTile(x, y)
				--if checkFn(ground, x, y) then
				if checkFn == nil or checkFn(TheWorld.Map:GetTile(x,y),x,y,points) then
					table.insert(points, {x=x, y=y})
				end
				i = i + inc
			end
			j = j + inc
			i = 0
		end
	end

	local points = {}
	local points_x = {}
	local points_y = {}
	local incs = {263, 137, 67, 31, 17, 9, 5, 3, 1}

	for i = 1, #incs, 1 do
		if #points < needed then
			get_points(points, checkFn, edge_dist, incs[i])
			--print(string.format("%d (of %d) points found", #points, needed))
		end
	end

	return shuffleArray(points)
end

function SpawnWaves(inst, numWaves, totalAngle, waveSpeed, wavePrefab, initialOffset, idleTime, instantActive, random_angle)
    wavePrefab = wavePrefab or "wave_rogue"
    totalAngle = math.clamp(totalAngle, 1, 360)

    local pos = inst:GetPosition()
    local startAngle = (random_angle and math.random(-180, 180)) or inst.Transform:GetRotation()
    local anglePerWave = totalAngle/(numWaves - 1)

    if totalAngle == 360 then
        anglePerWave = totalAngle/numWaves
    end

    --[[
    local debug_offset = Vector3(2 * math.cos(startAngle*DEGREES), 0, -2 * math.sin(startAngle*DEGREES)):Normalize()
    inst.components.debugger:SetOrigin("debugy", pos.x, pos.z)
    local debugpos = pos + (debug_offset * 2)
    inst.components.debugger:SetTarget("debugy", debugpos.x, debugpos.z)
    inst.components.debugger:SetColour("debugy", 1, 0, 0, 1)
    --]]

    for i = 0, numWaves - 1 do
        local wave = SpawnPrefab(wavePrefab)

        local angle = (startAngle - (totalAngle/2)) + (i * anglePerWave)
        local rad = initialOffset or (inst.Physics and inst.Physics:GetRadius()) or 0.0
        local total_rad = rad + wave.Physics:GetRadius() + 0.1
        local offset = Vector3(math.cos(angle*DEGREES),0, -math.sin(angle*DEGREES)):Normalize()
        local wavepos = pos + (offset * total_rad)

        if IsOnWater(wavepos) then
            wave.Transform:SetPosition(wavepos:Get())

            local speed = waveSpeed or 6
            wave.Transform:SetRotation(angle)
            wave.Physics:SetMotorVel(speed, 0, 0)
            wave.idle_time = idleTime or 5

            if instantActive then
                wave.sg:GoToState("idle")
            end

            if wave.soundtidal then
                wave.SoundEmitter:PlaySound(wave.soundtidal)
            end
        else
            wave:Remove()
        end
    end
end
