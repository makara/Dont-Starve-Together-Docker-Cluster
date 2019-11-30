local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

if not rawget(_G, "WorldSim") then
	print("SKIPPING WATERGEN")
	return
end


require "constants"
require "map/ocean_gen"
IAENV.modimport "main/spawnutil"
require "mathutil"
local Room = require "map/rooms"
local AllLayouts = require("map/layouts").Layouts

-- local function is_waterlined(ground)
	-- return ground ~= GROUND.IMPASSABLE and not IsWaterTile(ground)
-- end

-------------------------------------------------------------------------------
-------------------         Fill Open Water Functions       -------------------
-------------------------------------------------------------------------------

local function checkTile(x, y, check_fn)
	return --not WorldSim:IsTileReserved(x, y) and
			(check_fn == nil or check_fn(WorldSim:GetTile(x, y), x, y))
end

local function checkAllTiles(check_fn, x1, y1, x2, y2)
	for j = y1, y2, 1 do
		for i = x1, x2, 1 do
			if not checkTile(i, j, check_fn) then
				return false, i, j
			end
		end
	end
	return true, 0, 0
end

local function findEdgeLayoutPositions(radius, edge_dist, check_fn)
	local positions = {}
	local size = 2 * radius
	edge_dist = edge_dist or 0

	local width, height = WorldSim:GetWorldSize()
	local adj_width, adj_height = width - 2 * edge_dist - size,
								  height - 2 * edge_dist - size

	local edge_x = function(start_y)
		local x, y = 0, 0
		local i = 0
		while i < adj_width do
			x = i + edge_dist
			y = start_y
			local x2, y2 = x + size - 1, y + size - 1
			if checkTile(x2, y, check_fn) and checkTile(x2, y2, check_fn) then
				if checkTile(x, y, check_fn) and checkTile(x, y2, check_fn) then
					local ok, last_x, last_y = checkAllTiles(check_fn, x, y, x2, y2)
					if ok == true then
						table.insert(positions, {x = x, y = y, x2 = x2, y2 = y2, size = size})
						i = i + size + 1
					else
						i = i + last_x - x + 1
					end
				else
					i = i + 1
				end
			else
				i = i + size + 1
			end
		end
	end

	local edge_y = function(start_x)
		local x, y = 0, 0
		local i = 0
		while i < adj_height do
			x = start_x
			y = i + edge_dist + size
			local x2, y2 = x + size - 1, y + size - 1
			if checkTile(x2, y, check_fn) and checkTile(x2, y2, check_fn) then
				if checkTile(x, y, check_fn) and checkTile(x, y2, check_fn) then
					local ok, last_x, last_y = checkAllTiles(check_fn, x, y, x2, y2)
					if ok == true then
						table.insert(positions, {x=x, y=y, x2=x2, y2=y2, size=size})
						i = i + size + 1
					else
						i = i + last_y - y + 1
					end
				else
					i = i + 1
				end
			else
				i = i + size + 1
			end
		end
	end

	edge_x(edge_dist)
	edge_x(adj_height)

	edge_y(edge_dist)
	edge_y(adj_width)

	return positions
end

function FillOpenWater(set_pieces, entitiesOut, width, height)
	print("Fill open water...")

	local prefab_list = {}

	local check_fn = function(ground, x, y)
		return ground == ground.IMPASSABLE
	end

	local add_fn = {
		fn=function(prefab,
					points_x,
					points_y,
					idx,
					entitiesOut,
					width,
					height,
					prefab_list,
					prefab_data,
					rand_offset)
			AddEntity(prefab, points_x[idx], point_y[idx],
					  entitiesOut, width, height, prefab_list,
					  preafb_data, rand_offset)
		end,
		args = {
			entitiesOut = entitiesOut,
			width = width,
			height = height,
			rand_offset = true,
			debug_prefab_list = prefab_list
		}
	}

	local obj_layout = require "map/object_layout"

	local positions = {}
	local curidx = {}
	local radius = {50}
	for i = 1, #radius, 1 do
		positions[i] = shuffleArray(
							findEdgeLayoutPositions(radius[i],
							 TUNING.MAPEDGE_PADDING + 8, check_fn))
		curidx[i] = 1
		print(string.format("Found %d positions, radius %d", #positions[i], radius[i]))
	end

	for name, data in pairs(set_pieces) do
		local layout = obj_layout.LayoutForDefinition(name)
		local prefabs = obj_layout.ConvertLayoutToEntitylist(layout)
		local layoutsize = GetLayoutRadius(layout, prefabs)
		local count = data.count or 1

		for j = 1 , count, 1 do
			local radiusidx = 1

			local i = 0
			while i < count and radiusidx <= #radiux do
				if curidx[radiusidx]>= #positions[radiusidx] or
					radius[radiusidx] < layoutsize then
					radiusidx = radiusidx + 1
				else
					local pos = positions[radiusidx][curidx[radiuxidx]]
					local adj = 0.5 * (pos.size - layoutsize)
					local x, y = pos.x + adj, pos.y2 - adj
					print(string.format("Place fill layout %s at (%f, %f)", name, x, y))
					obj_layout.ReserveAndPlaceLayout("POSITIONED", layout, prefabs, add_fn, {x, y})
					curidx[radiusidx] = curidx[radiusidx] + 1
				end
			end
		end
	end
end

-------------------------------------------------------------------------------
-------------------      End Fill Open Water Functions      -------------------
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
------------------- Convert Impassible Tiles to Water Tiles -------------------
-------------------------------------------------------------------------------

local function simplexnoise2d(x, y, octaves, persistence)
	local noise = 0
	local amps = 0
	local amp = 1
	local freq = 2
	for i = 0, math.max(octaves-1,1),1 do
		noise = noise + amp * perlin(freq * x, freq * y, 0)
		amps = amps + amp
		amp = amp * persistence
		freq = freq * 2
	end
	return noise / amps
end


-- This is Box Blur, which simulates Gaussian Blur, which is used by SW too, except SW has it in C++...
-- Huge thanks to Ivan Kutskir from http://blog.ivank.net/ for explaining Box Blur and giving examples!

local function boxesForGauss(sigma, n)  -- standard deviation, number of boxes
	local wIdeal = math.sqrt((12*sigma*sigma/n)+1)  -- Ideal averaging filter width
	local wl = math.floor(wIdeal)
	if wl%2 == 0 then
		wl = wl - 1
	end
	local wu = wl + 2

	local mIdeal = (12*sigma*sigma - n*wl*wl - 4*n*wl - 3*n)/(-4*wl - 4)
	local m = RoundBiasedUp(mIdeal)
	-- local sigmaActual = math.sqrt( (m*wl*wl + (n-m)*wu*wu - n)/12 )

	local sizes = {}
	for i = 0, n-1 do
		if i < m then
			table.insert(sizes, wl)
		else
			table.insert(sizes, wu)
		end
	end
	return sizes
end

-- local function boxBlurH (scl, tcl, w, h, r)
	-- local iarr = 1 / (r + r + 1)
	-- for i= 0, h - 1 do
		-- local ti = i*w
		-- local li = ti + 1
		-- local ri = ti+r + 1
		-- local fv = scl[ti + 1]
		-- local lv = scl[ti + w]
		-- local val = (r+1)*fv
		-- for j= 1, r do
			-- val = val + scl[ti+j]
		-- end
		-- for j= 0, r do
			-- val = val + scl[ri] - fv
			-- ri = ri + 1
			-- tcl[ti + 1] = RoundBiasedUp(val*iarr)
			-- ti = ti + 1
		-- end
		-- for j= r+2, w-r do
			-- val = val + scl[ri] - scl[li]
			-- ri = ri + 1
			-- li = li + 1
			-- tcl[ti + 1] = RoundBiasedUp(val*iarr)
			-- ti = ti + 1
		-- end
		-- for j= w-r, w-1 do
			-- val = val + lv - scl[li]
			-- li = li + 1
			-- tcl[ti + 1] = RoundBiasedUp(val*iarr)
			-- ti = ti + 1
		-- end
	-- end
-- end
-- local function boxBlurT (scl, tcl, w, h, r)
	-- local iarr = 1 / (r + r + 1);
	-- for i= 0, w - 1 do
		-- local ti = i
		-- local li = ti + 1
		-- local ri = ti+r*w + 1
		-- local fv = scl[ti + 1]
		-- local lv = scl[ti+w*(h-1) + 1]
		-- local val = (r+1)*fv
		-- for j= 0, r-1 do
			-- val = val + scl[ti+j*w + 1]
		-- end
		-- for j= 0, r do
			-- val = val + scl[ri] - fv
			-- tcl[ti + 1] = RoundBiasedUp(val*iarr)
			-- ri = ri + w
			-- ti = ti + w
		-- end
		-- for j= r+2, h-r do
			-- val = val + scl[ri] - scl[li]
			-- tcl[ti + 1] = RoundBiasedUp(val*iarr)
			-- li = li + w
			-- ri = ri + w
			-- ti = ti + w
		-- end
		-- for j= h-r, h-1   do
			-- val = val + lv - scl[li]
			-- tcl[ti + 1] = RoundBiasedUp(val*iarr)
			-- li = li + w
			-- ti = ti + w
		-- end
	-- end
-- end
-- local function boxBlur (scl, tcl, w, h, r)
	-- for i = 1, #scl do
		-- tcl[i] = scl[i]
	-- end
	-- boxBlurH(tcl, scl, w, h, r)
	-- boxBlurT(scl, tcl, w, h, r)
-- end
-- local function gaussBlur (scl, tcl, w, h, r)
	-- local bxs = boxesForGauss(r, 3)
	-- boxBlur (scl, tcl, w, h, (bxs[1]-1)/2)
	-- boxBlur (tcl, scl, w, h, (bxs[2]-1)/2)
	-- boxBlur (scl, tcl, w, h, (bxs[3]-1)/2)
-- end


local function boxBlurSimple (scl, tcl, w, h, r)
	for i=0, h - 1 do
		for j=0, w - 1 do
			local val = 0
			for iy=i-r, i+r do
				for ix=j-r, j+r do
					local x = math.min(w-1, math.max(0, ix))
					local y = math.min(h-1, math.max(0, iy))
					val = val + scl[y*w+x + 1]
				end
			tcl[i*w+j + 1] = val/((r+r+1)*(r+r+1))
			end
		end
	end
end
local function gaussBlurSimple (scl, tcl, w, h, r)
	local bxs = boxesForGauss(r, 3)
	boxBlurSimple (scl, tcl, w, h, (bxs[1]-1)/2)
	boxBlurSimple (tcl, scl, w, h, (bxs[2]-1)/2)
	boxBlurSimple (scl, tcl, w, h, (bxs[3]-1)/2)
end



local WORLD_TILES = {}

local function GetTileTypes(width, height)
	for y = 0, width, 1 do
		for x = 0, height, 1 do
			if WORLD_TILES[x+1] == nil then
				WORLD_TILES[x+1] = {}
			end
			WORLD_TILES[x+1][y+1] = WorldSim:GetTile(x, y)
		end
	end
end

local function SetTile(x,y,ground)
	WORLD_TILES[x+1][y+1] = ground
	WorldSim:SetTile(x, y, ground)
end

local Ocean_ConvertImpassibleToWater_old = Ocean_ConvertImpassibleToWater
Ocean_ConvertImpassibleToWater = function(width, height, data, ...)
	if IA_worldtype == "default" then --use default water in non-merged default worlds
		Ocean_ConvertImpassibleToWater_old(width, height, data, ...)
	else
		data = TUNING.WATERGEN --force override
		GetTileTypes(width, height)

		print("Convert impassable tiles to water...")

		if data == nil then
			data = {}
		end

		local offx_water, offy_water = math.random(-width, width), math.random(-height, height)
		local offx_coral, offy_coral = math.random(-width, width), math.random(-height, height)
		local offx_grave, offy_grave = math.random(-width, width), math.random(-height, height)

		local noise_octave_water = data.noise_octave_water or 12
		local noise_octave_coral = data.noise_octave_coral or 4
		local noise_octave_grave = data.noise_octave_grave or 4
		local noise_persistence_water = data.noise_persistence_water or 0.5
		local noise_persistence_coral = data.noise_persistence_coral or 0.5
		local noise_persistence_grave = data.noise_persistence_grave or 0.5
		local noise_scale_water = data.noise_scale_water or 3
		local noise_scale_coral = data.noise_scale_coral or 6
		local noise_scale_grave = data.noise_scale_grave or 6
		local init_level_coral = data.init_level_coral or 0.65
		local init_level_grave = data.init_level_grave or 0.65
		local init_level_medium = data.init_level_medium or 0.35

		--local TILES = {}

		local ROT_to_IA = {
			[GROUND.OCEAN_COASTAL_SHORE] = GROUND.OCEAN_SHALLOW,
			[GROUND.OCEAN_COASTAL] = GROUND.OCEAN_SHALLOW,
			[GROUND.OCEAN_SWELL] = GROUND.OCEAN_MEDIUM,
			[GROUND.OCEAN_ROUGH] = GROUND.OCEAN_DEEP,
			[GROUND.OCEAN_REEF_SHORE] = GROUND.OCEAN_CORAL,
			[GROUND.OCEAN_REEF] = GROUND.OCEAN_CORAL,
			[GROUND.OCEAN_HAZARDOUS] = GROUND.OCEAN_SHIPGRAVEYARD,
		}

		-- local doblur = false

		for y = 0, height, 1 do
			for x = 0, width, 1 do
				local ground = WORLD_TILES[x+1][y+1]
				--convert ROT water to IA water
				if ground and ROT_to_IA[ ground ] ~= nil then
					SetTile(x, y, ROT_to_IA[ ground ])
				elseif ground == GROUND.IMPASSABLE then --and not IsCloseToLand(x, y, 2)
					-- doblur = true --only blur if we add any ocean ourselves
					local nx, ny = x/width, y/height
					SetTile(x, y, GROUND.OCEAN_SHALLOW)
					if simplexnoise2d(noise_scale_coral * (nx + offx_coral),
							noise_scale_coral * (ny + offy_coral),
							noise_octave_coral, noise_persistence_coral) > init_level_coral then
						SetTile(x, y, GROUND.OCEAN_CORAL)
					else
						local waternoise = simplexnoise2d(noise_scale_water * (nx + offx_water),
							noise_scale_water * (ny + offy_water),
							noise_octave_water, noise_persistence_water)

						if waternoise > init_level_medium then
							SetTile(x, y, GROUND.OCEAN_MEDIUM)
						else
							local gravenoise = simplexnoise2d(noise_scale_grave * (nx + offx_grave),
								noise_scale_grave * (ny + offy_grave),
								noise_octave_grave, noise_persistence_grave)
									
							if gravenoise > init_level_grave then
								SetTile(x, y, GROUND.OCEAN_SHIPGRAVEYARD)
							else
								SetTile(x, y, GROUND.OCEAN_DEEP)
							end
						end
					end
				end
			end
		end

		-- if not doblur then
			-- print("Skip elevation map, no blur!")
			-- return
		-- end

		-- AddShore(width, height)
		AddShoreline_IA(width, height)
		-- AddRiver(width, height)
		AddRiverNoBeach(width, height)

		-- Okay, now blur things a bit
		print("Start assembling elevation map")

		local ellevels = data.ellevels or
		{
			[GROUND.OCEAN_CORAL] = 2.0,
			[GROUND.MANGROVE] = 1.0,
			[GROUND.BEACH] = 1.0,
			[GROUND.RIVER] = 1.0,
			[GROUND.OCEAN_SHALLOW] = 0.9,
			[GROUND.OCEAN_MEDIUM] = 0.4,
			[GROUND.OCEAN_DEEP] = 0.0,
			[GROUND.OCEAN_SHIPGRAVEYARD] = 0.0,
			[GROUND.IMPASSABLE] = 0.0,
		}


		-- Remember that our cache starts with 1, but WorldSim with 0

		WORLD_TILES = {}
		GetTileTypes(width, height)
		local EL_MAP_OLD = {}
		local EL_MAP_NEW = {}
		local edgebuffer = TUNING.MAPWRAPPER_WARN_RANGE
		local edgefalloff = TUNING.MAPEDGE_PADDING
		for x, t in ipairs(WORLD_TILES) do
			for y, tile in ipairs(t) do
				--force deep at the edge
				if x < edgebuffer or x > width - edgebuffer or y < edgebuffer or y > height - edgebuffer then
					table.insert(EL_MAP_OLD, 0)
					-- remove coral reefs at the edge
					if tile == GROUND.OCEAN_CORAL or tile == GROUND.MANGROVE then
						-- SetTile(x, y, GROUND.OCEAN_DEEP)
						WORLD_TILES[x][y] = GROUND.OCEAN_DEEP
					end
				elseif x < edgefalloff or x > width - edgefalloff or y < edgefalloff or y > height - edgefalloff then
					table.insert(EL_MAP_OLD, (ellevels[tile] or 1) / 2)
				else
					table.insert(EL_MAP_OLD, ellevels[tile] or 1)
				end
				-- print("OLD ELEVATION:",#EL_MAP_OLD,x,y,ellevels[tile])
			end
		end

		print("Done assembling elevation map")

		gaussBlurSimple(EL_MAP_OLD, EL_MAP_NEW, width, height, data.sigma or 3)
		--EL_MAP_NEW = EL_MAP_OLD

		local final_level_shallow = data.final_level_shallow or .35
		local final_level_medium = data.final_level_medium or .05

		for i, el in ipairs(EL_MAP_NEW) do

			local x = math.floor(math.max(0, i - 1) / (height + 1) )
			local y = i-1 - x*(width + 1)

			-- print("NEW ELEVATION:",i,x,y,el)
			local tile = WORLD_TILES[x+1][y+1]

			if (IsWaterTile(tile) and tile ~= GROUND.MANGROVE and tile ~= GROUND.RIVER)
			or tile == GROUND.IMPASSABLE then
				-- local falloff = getEdgeFalloff(x, y, width, height, TUNING.MAPWRAPPER_WARN_RANGE + 1, TUNING.MAPWRAPPER_WARN_RANGE + 5, 0.0, 1.0)
				-- local cmlevel = cm[y * width + x] * falloff
				-- local glevel = g[y * width + x] * falloff
				if el > final_level_shallow then
					if tile ~= GROUND.OCEAN_CORAL then
						WorldSim:SetTile(x, y, GROUND.OCEAN_SHALLOW)
					end
				elseif el > final_level_medium then
					if tile ~= GROUND.OCEAN_CORAL then
						WorldSim:SetTile(x, y, GROUND.OCEAN_MEDIUM)
					end
				else
					if tile ~= GROUND.OCEAN_SHIPGRAVEYARD then
						WorldSim:SetTile(x, y, GROUND.OCEAN_DEEP)
					end
				end
			end

		end
	end
end

function AddShoreline_IA(width, height)
	print("Adding shoreline...")

	for y = 0, height, 1 do
		for x = 0, width, 1 do
			local ground = WORLD_TILES[x+1][y+1]
			if IsWaterTile(ground) and ground ~= GROUND.MANGROVE and IsCloseToShore(x, y, 3) then
				SetTile(x, y, GROUND.OCEAN_SHALLOW)
			end
		end
	end
end

-- For populating with generic stuff
local addedshore = {}
function AddShore(width, height)
	print("Adding shore...")

	local offs = {
						  -- {0, 2},
			  -- {-1, 1}, {0, 1}, {1, 1},
	-- {-2,0}, {-1,0},            {1, 0}, {2, 0},
			  -- {-1,-1}, {0,-1}, {1,-1},
						  -- {0,-2},
				-- {-1, 2}, {0, 2}, {1, 2},
	-- {-2, 1}, {-1, 1}, {0, 1}, {1, 1}, {2, 1},
	-- {-2, 0}, {-1, 0},            {1, 0}, {2, 0},
	-- {-2,-1}, {-1,-1}, {0,-1}, {1,-1}, {2,-1},
				-- {-1,-2}, {0,-2}, {1,-2},
	-- sorted by "priority", starting adjacient
			   {0, 1},{-1, 0},{1, 0},{0,-1},
			   {-1, 1},{1, 1},{-1,-1},{1,-1},
			   {0, 2},{-2, 0},{2, 0}, {0,-2},
			   {-1, 2},{1, 2},{-2, 1},{2, 1},{-2,-1},{2,-1},{-1,-2},{1,-2},
	}
	-- Purposefully skip the exact world border because we want no land there
	for y = 6, height - 6, 1 do
		for x = 6, width - 6, 1 do
			local ground = WORLD_TILES[x+1][y+1]
			-- if ground == GROUND.IMPASSABLE and IsCloseToLand(x, y, 2) then
				-- SetTile(x, y, GROUND.BEACH)
			-- end
			if IsWaterOrImpassable(ground) and ground ~= GROUND.MANGROVE then
				for i = 1, #offs, 1 do
					local offx = x + offs[i][1]
					local offy = y + offs[i][2]
					local ground = WORLD_TILES[offx+1][offy+1]
					if not IsWaterOrImpassable(ground) then
						if ground ~= GROUND.DIRT
						and ground ~= GROUND.MARSH
						and ground ~= GROUND.BEACH then
							if ground == GROUND.ROCKY then
								SetTile(x, y, GROUND.DIRT)
								table.insert(addedshore, {x,y})
								break
							else
								SetTile(x, y, GROUND.BEACH)
								-- if addedshore[x+1] == nil then
									-- addedshore[x+1] = {}
								-- end
								-- addedshore[x+1][y+1] = true
								table.insert(addedshore, {x,y})
								break
							end
						end
					end
				end

			end
		end
	end
end



local function isLandNoBeach(ground)
	return not IsWaterOrImpassable(ground) and ground ~= GROUND.BEACH
end
function AddRiver(width, height)
	print("Adding Rivers...")

	for _, pos in pairs(addedshore) do
		local ground = WORLD_TILES[pos[1]+1][pos[2]+1]
		if not IsWaterOrImpassable(ground) then
			-- horizontal
			for x1 = 1,4,1 do
				local x2 = 5 - x1
				if isLandNoBeach(WORLD_TILES[pos[1]+1+x1][pos[2]+1])
				and isLandNoBeach(WORLD_TILES[pos[1]+1-x2][pos[2]+1]) then
					local side1 = WORLD_TILES[pos[1]+1][pos[2]+3]
					local side2 = WORLD_TILES[pos[1]+1][pos[2]-1]
					if --side1 == GROUND.RIVER or side2 == GROUND.RIVER or
					(not isLandNoBeach(side1) and not isLandNoBeach(side2)) then
						SetTile(pos[1], pos[2], GROUND.RIVER)
					end
				end
			end
			-- vertical
			for x1 = 1,4,1 do
				local x2 = 5 - x1
				if isLandNoBeach(WORLD_TILES[pos[1]+1][pos[2]+1+x1])
				and isLandNoBeach(WORLD_TILES[pos[1]+1][pos[2]+1-x2]) then
					local side1 = WORLD_TILES[pos[1]+3][pos[2]+1]
					local side2 = WORLD_TILES[pos[1]-1][pos[2]+1]
					if --side1 == GROUND.RIVER or side2 == GROUND.RIVER or
					(not isLandNoBeach(side1) and not isLandNoBeach(side2)) then
						SetTile(pos[1], pos[2], GROUND.RIVER)
					end
				end
			end
			-- diagonal
			if (isLandNoBeach(WORLD_TILES[pos[1]+3][pos[2]+3])
			and isLandNoBeach(WORLD_TILES[pos[1]-1][pos[2]-1])
			and not isLandNoBeach(WORLD_TILES[pos[1]+3][pos[2]-1])
			and not isLandNoBeach(WORLD_TILES[pos[1]-1][pos[2]+3]))
			or (isLandNoBeach(WORLD_TILES[pos[1]+3][pos[2]-1])
			and isLandNoBeach(WORLD_TILES[pos[1]-1][pos[2]+3])
			and not isLandNoBeach(WORLD_TILES[pos[1]+3][pos[2]+3])
			and not isLandNoBeach(WORLD_TILES[pos[1]-1][pos[2]-1])) then
				SetTile(pos[1], pos[2], GROUND.RIVER)
			end
		end
	end
	-- now go over it all again several times to smoothen the connection to the ocean
	for i = 1,2,1 do
		for _, pos in pairs(addedshore) do
			local ground = WORLD_TILES[pos[1]+1][pos[2]+1]
			if not IsWaterOrImpassable(ground) then
				for x = -1,1,1 do -- maybe we should do a taxicab distance of 2 instead?
				for y = -1,1,1 do
					-- if an adjacient tile is river and the opposite isn't beach
					if WORLD_TILES[pos[1]+1+x][pos[2]+1+y] == GROUND.RIVER
					and WORLD_TILES[pos[1]+1-x][pos[2]+1-y] ~= GROUND.BEACH then
						SetTile(pos[1], pos[2], GROUND.RIVER)
					end
				end
				end
			end
		end
	end
	-- and now smoothen the beach even more
	for _, pos in pairs(addedshore) do
		local ground = WORLD_TILES[pos[1]+1][pos[2]+1]
		if not IsWaterOrImpassable(ground) then
			local nwater = 0

			if IsWaterOrImpassable(WORLD_TILES[pos[1]+2][pos[2]+1]) then
				nwater = nwater + 1
			end
			if IsWaterOrImpassable(WORLD_TILES[pos[1]+0][pos[2]+1]) then
				nwater = nwater + 1
			end
			if IsWaterOrImpassable(WORLD_TILES[pos[1]+1][pos[2]+2]) then
				nwater = nwater + 1
			end
			if IsWaterOrImpassable(WORLD_TILES[pos[1]+1][pos[2]+0]) then
				nwater = nwater + 1
			end

			if nwater > 2 and IsCloseToTileType(pos[1],pos[2],1,GROUND.RIVER) then
				SetTile(pos[1], pos[2], GROUND.RIVER)
			end
		end
	end
end



function AddRiverNoBeach(width, height)
	print("Adding Rivers...")
--[[
	local offs = {
						  -- {0, 2},
			  -- {-1, 1}, {0, 1}, {1, 1},
	-- {-2,0}, {-1,0},            {1, 0}, {2, 0},
			  -- {-1,-1}, {0,-1}, {1,-1},
						  -- {0,-2},
				-- {-1, 2}, {0, 2}, {1, 2},
	-- {-2, 1}, {-1, 1}, {0, 1}, {1, 1}, {2, 1},
	-- {-2, 0}, {-1, 0},            {1, 0}, {2, 0},
	-- {-2,-1}, {-1,-1}, {0,-1}, {1,-1}, {2,-1},
				-- {-1,-2}, {0,-2}, {1,-2},
	-- sorted by "priority", starting adjacient
			   {0, 1},{-1, 0},{1, 0},{0,-1},
			   {-1, 1},{1, 1},{-1,-1},{1,-1},
			   {0, 2},{-2, 0},{2, 0}, {0,-2},
			   {-1, 2},{1, 2},{-2, 1},{2, 1},{-2,-1},{2,-1},{-1,-2},{1,-2},
	}
	-- Purposefully skip the exact world border because we want no land there
	for y = 6, height - 6, 1 do
		for x = 6, width - 6, 1 do
			local ground = WORLD_TILES[x+1][y+1]
			-- if ground == GROUND.IMPASSABLE and IsCloseToLand(x, y, 2) then
				-- SetTile(x, y, GROUND.BEACH)
			-- end
			if IsWaterOrImpassable(ground) and ground ~= GROUND.MANGROVE then
				for i = 1, #offs, 1 do
					local offx = x + offs[i][1]
					local offy = y + offs[i][2]
					local ground = WORLD_TILES[offx+1][offy+1]
					if not IsWaterOrImpassable(ground) then
						if ground ~= GROUND.DIRT
						and ground ~= GROUND.MARSH
						and ground ~= GROUND.BEACH then
							if ground == GROUND.ROCKY then
								SetTile(x, y, GROUND.DIRT)
								table.insert(addedshore, {x,y})
								break
							else
								SetTile(x, y, GROUND.BEACH)
								-- if addedshore[x+1] == nil then
									-- addedshore[x+1] = {}
								-- end
								-- addedshore[x+1][y+1] = true
								table.insert(addedshore, {x,y})
								break
]]
	-- local checkedtiles = {}
	-- for y = 8, height - 6, 1 do
		-- for x = 8, width - 6, 1 do
			-- local ground = WORLD_TILES[x][y]
			-- if IsWaterOrImpassable(ground) then
				-- SetTile(x -1, y -1, GROUND.RIVER)
			-- end
		-- end
	-- end
end



-- Copy from node class
local function AddEntity(prefab, x, y, entitiesOut, width, height, prefab_list, prefab_data, rand_offset)

	WorldSim:ReserveTile(x, y)
	local tile = WorldSim:GetVisualTileAtPosition(x, y)
	if  tile <= GROUND.IMPASSABLE or tile >= GROUND.UNDERGROUND then
		return
	end

	x = (x - width/2.0)*TILE_SCALE
	y = (y - height/2.0)*TILE_SCALE


	if rand_offset ~= false then
		x = x + math.random() * 3 - 1.5
		y = y + math.random() * 3 - 1.5
	end

	-- Round for reducing filesize
	x = math.floor(x*100)/100.0
	y = math.floor(y*100)/100.0

	if entitiesOut[prefab] == nil then
		entitiesOut[prefab] = {}
	end

	local save_data = {x=x, z=y}
	if prefab_data then

		if prefab_data.data then
			if type(prefab_data.data) == "function" then
				save_data["data"] = prefab_data.data()
			else
				save_data["data"] = prefab_data.data
			end
		end
		if prefab_data.id then
			save_data["id"] = prefab_data.id
		end
		if prefab_data.scenario then
			save_data["scenario"] = prefab_data.scenario
		end
	end
	table.insert(entitiesOut[prefab], save_data)

	if prefab_list[prefab] == nil then
		prefab_list[prefab] = 0
	end
	prefab_list[prefab] = prefab_list[prefab] + 1
end







-- function FillOpenWater(set_pieces, entitiesOut, width, height)
	-- print("Fill open water...")

	-- local prefab_list = {}

	-- local check_fn = function(ground, x, y)
		-- return ground == ground.IMPASSABLE
	-- end

	-- local add_fn = {
		-- fn=function(prefab,
					-- points_x,
					-- points_y,
					-- idx,
					-- entitiesOut,
					-- width,
					-- height,
					-- prefab_list,
					-- prefab_data,
					-- rand_offset)
			-- AddEntity(prefab, points_x[idx], point_y[idx],
					  -- entitiesOut, width, height, prefab_list,
					  -- preafb_data, rand_offset)
		-- end,
		-- args = {
			-- entitiesOut = entitiesOut,
			-- width = width,
			-- height = height,
			-- rand_offset = true,
			-- debug_prefab_list = prefab_list
		-- }
	-- }

	-- local obj_layout = require "map/object_layout"

	-- local positions = {}
	-- local curidx = {}
	-- local radius = {50}
	-- for i = 1, #radius, 1 do
		-- positions[i] = shuffleArray(
							-- findEdgeLayoutPositions(radius[i],
							 -- TUNING.MAPEDGE_PADDING + 8, check_fn))
		-- curidx[i] = 1
		-- print(string.format("Found %d positions, radius %d", #positions[i], radius[i]))
	-- end

	-- for name, data in pairs(set_pieces) do
		-- local layout = obj_layout.LayoutForDefinition(name)
		-- local prefabs = obj_layout.ConvertLayoutToEntitylist(layout)
		-- local layoutsize = GetLayoutRadius(layout, prefabs)
		-- local count = data.count or 1

		-- for j = 1 , count, 1 do
			-- local radiusidx = 1

			-- local i = 0
			-- while i < count and radiusidx <= #radiux do
				-- if curidx[radiusidx]>= #positions[radiusidx] or
					-- radius[radiusidx] < layoutsize then
					-- radiusidx = radiusidx + 1
				-- else
					-- local pos = positions[radiusidx][curidx[radiuxidx]]
					-- local adj = 0.5 * (pos.size - layoutsize)
					-- local x, y = pos.x + adj, pos.y2 - adj
					-- print(string.format("Place fill layout %s at (%f, %f)", name, x, y))
					-- obj_layout.ReserveAndPlaceLayout("POSITIONED", layout, prefabs, add_fn, {x, y})
					-- curidx[radiusidx] = curidx[radiusidx] + 1
				-- end
			-- end
		-- end
	-- end
-- end


local function PlaceSingleWaterSetPiece(set_piece, add_fn, checkFn, reserved)
	assert(type(set_piece) == "string", "Attempt to place invalid Water setpiece: ".. set_piece)
	assert(type(add_fn.fn) == "function", "Attempt to place Water setpiece with invalid add_fn: ".. set_piece)
	assert(type(checkFn) == "function", "Attempt to place Water setpiece with invalid checkFn: ".. set_piece)

	local layout = AllLayouts[set_piece]
	if type(layout) ~= "table" then print('Attempt to place invalid Water setpiece: ' .. set_piece) return end

	local layout_x = #layout.ground[1]
	local layout_y = #layout.ground

	local position

	local width, height = WorldSim:GetWorldSize()
	local adj_width = width - 2 * TUNING.MAPEDGE_PADDING - layout_x
	local adj_height = height - 2 * TUNING.MAPEDGE_PADDING - layout_y

	-- start searching big steps, then refine with each failed iteration
	local incs = {263, 137, 67, 31, 17, 9, 5, 3, 1}

	for k = 1, #incs, 1 do
		if position == true then break end
		local start_x, start_y = math.random(0, adj_width), math.random(0, adj_height)
		local i, j = 0, 0
		while j < adj_height and position ~= true do
			local y = ((start_y + j) % adj_height) + TUNING.MAPEDGE_PADDING
			while i < adj_width and position ~= true do
				local x = ((start_x + i) % adj_width) + TUNING.MAPEDGE_PADDING
				--local ground = WorldSim:GetTile(x, y)
				--if checkFn(ground, x, y) then
				local x2 = x + layout_x
				local y2 = y + layout_y
				if checkTile(x, y, checkFn) and checkTile(x2, y2, checkFn)
				and checkTile(x2, y, checkFn) and checkTile(x, y2, checkFn) then
					local ok, last_x, last_y = checkAllTiles(checkFn, x, y, x2, y2)
					if ok == true then
						position = {x,y}
						break
						-- table.insert(positions, {x = x, y = y, x2 = x2, y2 = y2, size = size})
						-- i = i + size + 1
					-- else
						-- i = i + last_x - x + 1
					end
				end
				i = i + incs[k]
			end
			j = j + incs[k]
			i = 0
		end
	end

	if not position then print("COULD NOT FIND AREA FOR ".. set_piece) return end

	local obj_layout = require "map/object_layout"
	obj_layout.Place(position, set_piece, add_fn) --, [choices], [world])

	for y = position[2], position[2] + layout_y, 1 do
		for x = position[1], position[1] + layout_x, 1 do
			if not reserved[x] then
				reserved[x] = {}
			end
			reserved[x][y] = true
		end
	end

	-- return true, position
end

local function PopulateWaterType(checkFn, spawnFn, entitiesOut, width, height, water_contents, world_gen_choices)
	local prefab_list = {}
	local generate_these = {}
	local pos_needed = 0
	local reserved = {}

	local edge_dist = TUNING.MAPWRAPPER_WARN_RANGE + 2 --16

	print("Static layouts...")
	if water_contents.countstaticlayouts ~= nil then
		local add_fn = {
			fn=function(prefab, points_x, points_y, idx, entitiesOut, width, height, prefab_list, prefab_data, rand_offset)
				AddEntity(prefab, points_x[idx], points_y[idx], entitiesOut, width, height, prefab_list, prefab_data, rand_offset)
			end,
			args={entitiesOut=entitiesOut, width=width, height=height, rand_offset = true, debug_prefab_list=prefab_list}
		}

		for set_piece, count in pairs(water_contents.countstaticlayouts) do
			if type(count) == "function" then
				count = count()
			end
			print("Trying to add", count, set_piece)
			if water_contents.staticlayoutspawnfn and water_contents.staticlayoutspawnfn[set_piece] then
				local fn = function(ground, x, y)
					return checkFn(ground, x, y)
						and water_contents.staticlayoutspawnfn[set_piece](x, y, entitiesOut)
						and not (reserved[x] and reserved[x][y])
				end
				for i = 1, count, 1 do
					PlaceSingleWaterSetPiece(set_piece, add_fn, fn, reserved)
				end
			else
				local fn = function(ground, x, y)
					return checkFn(ground, x, y)
						-- and water_contents.staticlayoutspawnfn[set_piece](x, y, entitiesOut)
						and not (reserved[x] and reserved[x][y])
				end
				for i = 1, count, 1 do
					PlaceSingleWaterSetPiece(set_piece, add_fn, fn, reserved)
				end
			end
		end
	end

	print("Counted prefabs...")
	if water_contents.countprefabs ~= nil then
		for prefab, count in pairs(water_contents.countprefabs) do
			if type(count) == "function" then
				count = count()
			end
			generate_these[prefab] = count
			pos_needed = pos_needed + count
		end

		--get a bunch of points
		local points_x, points_y = GetRandomWaterPoints(checkFn, width, height, edge_dist, 2 * pos_needed)
		-- print("## got points for countprefabs", pos_needed)

		local pos_cur = 1
		for prefab, count in pairs(generate_these) do
			print("Trying to add", count, prefab)
			local added = 0
			while added < count and pos_cur <= #points_x do
			--for id = 1, math.min(count, #points_x) do
				-- print("trying to add", prefab)
				if SpawntestFn(prefab, points_x[pos_cur], points_y[pos_cur], entitiesOut) then
					-- print("added")
					local prefab_data = {}
					prefab_data.data = water_contents.prefabdata and water_contents.prefabdata[prefab] or nil
					AddEntity(prefab, points_x[pos_cur], points_y[pos_cur], entitiesOut, width, height, prefab_list, prefab_data)
					added = added + 1
				end
				pos_cur = pos_cur + 1
			end
		end
	end

	print("Distributed prefabs...")
	if water_contents.distributepercent and water_contents.distributeprefabs then
		-- print("## found distributeprefabs")
		for y = edge_dist, height - edge_dist - 1, 1 do
			for x = edge_dist, width - edge_dist - 1, 1 do
				if checkTile(x, y, checkFn) then
				--if checkFn(ground, x, y) then
					if math.random() < water_contents.distributepercent then
						-- print("trying to add distributable")
						local ground = WorldSim:GetTile(x, y)
						if ground == GROUND.BEACH then print("UH OH, WE'RE SPAWNING ON BEACH") end --debug
						local prefab = spawnFn.pickspawnprefab(water_contents.distributeprefabs, ground)
						if prefab ~= nil then
							-- print("trying to add",prefab)
							if SpawntestFn(prefab, x, y, entitiesOut) then
								-- print("added")
								local prefab_data = {}
								prefab_data.data = water_contents.prefabdata and water_contents.prefabdata[prefab] or nil
								AddEntity(prefab, x, y, entitiesOut, width, height, prefab_list, prefab_data)
							end
						end
					end
				end
			end
		end
	end

	-- PopulateWaterExtra(checkFn, spawnFn, entitiesOut, width, height, water_contents, world_gen_choices, prefab_list)

	print("Done populating water!")
end

local function PopulateShore(spawnFn, entitiesOut, width, height, world_gen_choices)
	local prefab_list = {}
	local contents = Room.GetRoomByName("BeachGeneric").contents

	print("Distributed prefabs...")
	if contents.distributepercent and contents.distributeprefabs then
		-- for x = 0, width, 1 do
		-- if addedshore[x+1] then
			-- for y = 0, height, 1 do
			-- if addedshore[x+1][y+1] then
				-- if math.random() < contents.distributepercent then
					-- local ground = WorldSim:GetTile(x, y)
					-- local prefab = spawnFn.pickspawnprefab(contents.distributeprefabs, ground)
					-- if prefab ~= nil then
						-- if SpawntestFn(prefab, x, y, entitiesOut) then
							-- local prefab_data = {}
							-- prefab_data.data = contents.prefabdata and contents.prefabdata[prefab] or nil
							-- AddEntity(prefab, x, y, entitiesOut, width, height, prefab_list, prefab_data)
						-- end
					-- end
				-- end
			-- end
			-- end
		-- end
		-- end
		for i, pos in pairs(addedshore) do
			local ground = WORLD_TILES[pos[1]+1][pos[2]+1]
			-- print(pos[1],pos[2],ground)
			if not IsWaterOrImpassable(ground) and math.random() < contents.distributepercent then
				-- print("spawnprefab")
				-- print(WorldSim:GetTile(pos[1], pos[2]))
				-- local ground = WorldSim:GetTile(pos[1], pos[2])
				local prefab = spawnFn.pickspawnprefab(contents.distributeprefabs, ground)
				if prefab ~= nil then
					-- print(prefab)
					if SpawntestFn(prefab, pos[1], pos[2], entitiesOut) then
						local prefab_data = {}
						prefab_data.data = contents.prefabdata and contents.prefabdata[prefab] or nil
						AddEntity(prefab, pos[1], pos[2], entitiesOut, width, height, prefab_list, prefab_data)
						-- print("SUCCESS")
					end
				end
			end
			-- print("------------")
		end
	end

	-- PopulateWaterExtra(checkFn, spawnFn, entitiesOut, width, height, water_contents, world_gen_choices, prefab_list)
end

function PopulateWater(spawnFn, entitiesOut, width, height, water, world_gen_choices)
	print("Populate water...")
	for room, data in pairs(water) do
		print("####",data.room.name)
		--AdjustDistribution(data.room.contents, world_gen_choices)
		PopulateWaterType(data.checkFn, spawnFn, entitiesOut, width, height, data.room.contents, world_gen_choices)
	end
	print("####\tShore")
	-- This simulates the effects of a flood
	 PopulateShore(spawnFn, entitiesOut, width, height, world_gen_choices)
end