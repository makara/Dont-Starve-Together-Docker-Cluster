--This is for all players. If you don't care for entities, consider using 
-- TheWorld.minimap.MiniMap:EnableFogOfWar(false)
function GLOBAL.c_revealmap()
	local w,h = GLOBAL.TheWorld.Map:GetSize()
	for _,v in pairs(GLOBAL.AllPlayers) do
		for x=-w*4 -6, w*4, 35 do
			for y=-h*4 -6, h*4, 35 do
				v.player_classified.MapExplorer:RevealArea(x,0,y)
			end
		end
	end
end

function GLOBAL.c_poison()
	local player = GLOBAL.ConsoleCommandPlayer()
	if player and player.components.poisonable then
		if player.components.poisonable:IsPoisoned() then
			player.components.poisonable:DonePoisoning()
		else
			player.components.poisonable:Poison()
		end
	end
end

function GLOBAL.c_bermuda()
	if not GLOBAL.TheWorld.ismastersim then return end
	local count = 0
	for k, v in pairs(GLOBAL.Ents) do
		if v.prefab == "bermudatriangle" then
			v:Remove()
			count = count + 1
		end
	end
	print("Removed ".. count .." bermudatriangle. Spawning new ones...")
	
	local width, height = GLOBAL.TheWorld.Map:GetSize()
	
	local function checkTriangle(tile, x, y, points)
		if  tile ~= GLOBAL.GROUND.OCEAN_DEEP then 
			return false 
		end 
		for i = 1, #points, 1 do 
			local dx = x - points[i].x 
			local dy = y - points[i].y
			local dsq = dx * dx + dy * dy

			if dsq < 50 * 50 then 
				return false 
			end 
		end 
		return true 
	end 

	local points = GLOBAL.FindRandomWaterPoints(checkTriangle, TUNING.MAPEDGE_PADDING, 12)
	
	--convert to entity coords
	for i = 1, #points, 1 do 
		points[i].x = (points[i].x - width/2.0)*GLOBAL.TILE_SCALE
		points[i].y = (points[i].y - height/2.0)*GLOBAL.TILE_SCALE
	end 
	---------------------------------
	print(#points .. " points for bermudatriangle")
	if #points < 2 then return print("WARNING: Not enough points for new bermudatriangle") end
	
	local pair = 0
	local min_distsq = 200 * 200
	local is_farenough = function( marker1, marker2)
		local diffx, diffz = marker2.x - marker1.x, marker2.y - marker1.y
		local mag = diffx * diffx + diffz * diffz
		if mag < min_distsq then
			return false
		end
		return true
	end

	for i = #points, 1, -1 do
		if points[i] then --might be removed already
			for j = #points, 1, -1 do
				if points[j] and i ~= j and is_farenough(points[i], points[j]) then
					local berm1 = GLOBAL.SpawnPrefab("bermudatriangle")
					berm1.Transform:SetPosition(points[i].x, 0, points[i].y)
					local berm2 = GLOBAL.SpawnPrefab("bermudatriangle")
					berm2.Transform:SetPosition(points[j].x, 0, points[j].y)
					
					berm1.components.teleporter:Target(berm2)
					berm2.components.teleporter:Target(berm1)
					
					pair = pair + 1
					
					table.remove(points, i)
					table.remove(points, j)
					
					break
				end
			end
		end
	end
	print(pair .. " bermudatriangle pairs placed.")
	
end

function GLOBAL.c_octoking()
	GLOBAL.c_spawn('octopusking')
	GLOBAL.c_give('californiaroll', 3)
	GLOBAL.c_give('seafoodgumbo', 3)
	GLOBAL.c_give('bisque', 3)
	GLOBAL.c_give('jellyopop', 3)
	GLOBAL.c_give('ceviche', 3)
	GLOBAL.c_give('surfnturf', 3)
	GLOBAL.c_give('lobsterbisque', 3)
	GLOBAL.c_give('lobsterdinner', 3)
end

function GLOBAL.c_givetreasuremaps()
	local player = GLOBAL.ConsoleCommandPlayer()
	local x,y,z = player.Transform:GetWorldPosition()
	local treasures = GLOBAL.TheSim:FindEntities(x, y, z, 10000, {"buriedtreasure"}, {"linktreasure"})
	print("Found " .. #treasures .. " treasures")
	if treasures and type(treasures) == "table" and #treasures > 0 then
		for i = 1, #treasures, 1 do
		local bottle = GLOBAL.SpawnPrefab("messagebottle")
		bottle.Transform:SetPosition(x, y, z)
		bottle.treasure = treasures[i]
		if bottle.treasure.debugname then
			bottle.debugmsg = "It's a map to '" .. bottle.treasure.debugname .. "'"
		end
		player.components.inventory:GiveItem(bottle)
		end
	end
end

function GLOBAL.c_revealtreasure()
	local player = GLOBAL.ConsoleCommandPlayer()
	local x,y,z = player.Transform:GetWorldPosition()
	local treasures = GLOBAL.TheSim:FindEntities(x, y, z, 10000, {"buriedtreasure"})
	print("Found " .. #treasures .. " treasures")
	if treasures and type(treasures) == "table" and #treasures > 0 then
		for i = 1, #treasures, 1 do
			treasures[i]:Reveal(treasures[i])
			treasures[i]:RevealFog(treasures[i])
		end
	end
end

-- function GLOBAL.c_erupt()
	-- local vm = TheWorld.components.volcanomanager
	-- if vm then
		-- vm:StartEruption(60.0, 60.0, 60.0, 1 / 8)
	-- end
-- end

-- function GLOBAL.c_hurricane()
	-- local sm = GetSeasonManager()
	-- if sm then
		-- sm:StartHurricaneStorm()
	-- end
-- end

-- function GLOBAL.c_treasuretest()
	-- local l = GetTreasureLootDefinitionTable()

	-- for name, data in pairs(l) do
		-- if type(data) == "table" then

			-- if type(data.loot) == "table" then
				-- for k, _ in pairs(data.loot) do
					-- c_prefabexists(k)
				-- end
			-- end
			-- if type(data.random_loot) == "table" then
				-- for k, _ in pairs(data.random_loot) do
					-- c_prefabexists(k)
				-- end
			-- end
			-- if type(data.chance_loot) == "table" then
				-- for k, _ in pairs(data.chance_loot) do
					-- c_prefabexists(k)
				-- end
			-- end
		-- end
	-- end

	-- local t = GetTreasureDefinitionTable()
	-- local obj_layout = require("map/object_layout")

	-- for name, data in pairs(t) do
		-- if type(data) == "table" then
			-- for i, stage in ipairs(data) do
				-- if type(stage) == "table" then
					-- if stage.treasure_set_piece then
						-- obj_layout.LayoutForDefinition(stage.treasure_set_piece)
					-- end
					-- if stage.treasure_prefab then
						-- c_prefabexists(stage.treasure_prefab)
					-- end
					-- if stage.map_set_piece then
						-- obj_layout.LayoutForDefinition(stage.map_set_piece)
					-- end
					-- if stage.map_prefab then
						-- c_prefabexists(stage.map_prefab)
					-- end
					-- if stage.tier == nil then
						-- if stage.loot == nil then
							-- print("missing loot!", name)
						-- elseif l[stage.loot] == nil then
							-- print("missing loot!", name, stage.loot)
						-- end
					-- end
				-- end
			-- end
		-- end
	-- end
-- end

function GLOBAL.c_spawntreasure(name)
	local x = GLOBAL.c_spawn("buriedtreasure")
	x:Reveal()
	if name then
		x.loot = name
	else
		local treasures = GLOBAL.GetTreasureLootDefinitionTable()
		local treasure = GLOBAL.GetRandomKey(treasures)
		x.loot = treasure
	end
end


-- local embarker1
-- local embarker2
-- local embarkboat
-- function GLOBAL.c_embarktest1()
	-- embarker1 = GLOBAL.c_spawn("wilson")
-- end
-- function GLOBAL.c_embarktest2()
	-- embarker2 = GLOBAL.c_spawn("willow")
-- end
-- function GLOBAL.c_embarktestboat()
	-- embarkboat = GLOBAL.c_spawn("boat_row")
-- end
-- local function embarkdebugprint(title)
	-- print(title)
	-- print("-------------------")
	-- print("embarker1:")
	-- print("boat",
		-- embarker1.components.sailor.sailing,
		-- embarker1.components.sailor:GetBoat())
	-- print("-------------------")
	-- print("embarker2:")
	-- print("boat",
		-- embarker2.components.sailor.sailing,
		-- embarker2.components.sailor:GetBoat())
	-- print("-------------------")
	-- print("embarkboat:")
	-- print("isembarking", 
		-- embarkboat.components.sailable.isembarking)
	-- print("IsOccupied", 
		-- embarkboat.components.sailable:IsOccupied())
	-- print("sailor", 
		-- embarkboat.components.sailable.hassailor,
		-- embarkboat.components.sailable:GetSailor())
	-- print("-------------------")
-- end
-- function GLOBAL.c_embarktest()
	-- if embarkboat == nil then print("Need embarkboat to test!") end
	-- if embarker1 == nil then print("Need embarker1 to test!") end
	-- if embarker2 == nil then print("Need embarker2 to test!") end
	
	-- embarkdebugprint("Preparing embarktest...")
	
	-- embarker1.components.locomotor:PushAction(
		-- GLOBAL.BufferedAction(embarker1, embarkboat, GLOBAL.ACTIONS.EMBARK), true)
	
	-- embarkdebugprint("Sent embarkrequest by embarker1")
	
	-- -- embarker2:DoTaskInTime(0, function()
		-- embarker2.components.locomotor:PushAction(
			-- GLOBAL.BufferedAction(embarker2, embarkboat, GLOBAL.ACTIONS.EMBARK), true)
		
		-- embarkdebugprint("Sent embarkrequest by embarker2")
	-- -- end)
	
	-- embarkboat:DoTaskInTime(3, function()
		-- embarkdebugprint("Embark Report (3 seconds)...")
	-- end)
-- end


-- function GLOBAL.c_rainsinglefrog()
	-- local spawn_point = GLOBAL.ConsoleWorldPosition()
    -- local frog = GLOBAL.SpawnPrefab("frog")
    -- frog.persists = false
    -- if math.random() < .5 then
        -- frog.Transform:SetRotation(180)
    -- end
    -- frog.sg:GoToState("fall")
    -- frog.Physics:Teleport(spawn_point.x, 35, spawn_point.z)
-- end

-- function GLOBAL.c_addweb()
	
	-- local x,y = GLOBAL.TheWorld.Map:GetTileCoordsAtPoint( GLOBAL.ConsoleWorldPosition():Get())
	-- print(x,y)
	-- GLOBAL.SetTileState(x,y, "creep", true )
-- end

-- function GLOBAL.c_removeweb()
	
	-- local x,y = GLOBAL.TheWorld.Map:GetTileCoordsAtPoint( GLOBAL.ConsoleWorldPosition():Get())
	-- print(x,y)
	-- GLOBAL.SetTileState(x,y, "creep" )
-- end

-- function GLOBAL.c_getweb()
	
	-- local x,y = GLOBAL.TheWorld.Map:GetTileCoordsAtPoint( GLOBAL.ConsoleWorldPosition():Get())
	-- local ts = GLOBAL.GetTileState(x,y, "creep" )
	-- print(x,y,ts and ts.val, ts and ts.sources and GLOBAL.next(ts.sources))
-- end

function GLOBAL.c_flood()
	local player = GLOBAL.ConsoleCommandPlayer()
	local pt = player and player:GetPosition() or {x=0,z=0}
	GLOBAL.TheWorld.components.flooding:SpawnPuddle(pt.x, 0, pt.z)
end

function GLOBAL.c_mark()
	--shows all puddles on the map, as rawling
	GLOBAL.TheWorld.components.flooding:ShowPuddles()
end
