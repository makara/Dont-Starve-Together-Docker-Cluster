local deepcopy = GLOBAL.deepcopy
local GetTableSize = GLOBAL.GetTableSize
local next = GLOBAL.next
local assert = GLOBAL.assert
local require = GLOBAL.require

SetupGemCoreWorldGenEnv()

-- local polyutil = require "polyutil"
require "map/storygen"
modimport "main/watergen"
require "map/terrain"
local Story = GLOBAL.Story
local LOCKS_KEYS = GLOBAL.LOCKS_KEYS
local terrain = GLOBAL.terrain
local taskutil = require "map/tasks"
local roomutil = require "map/rooms"
local startlocations = require "map/startlocations"
local customise = require "map/customise"
local map = require "map/forest_map"
local AllLayouts = require("map/layouts").Layouts
local _Generate = map.Generate
local TRANSLATE_TO_PREFABS = map.TRANSLATE_TO_PREFABS
local TRANSLATE_AND_OVERRIDE = map.TRANSLATE_AND_OVERRIDE
local MULTIPLY = map.MULTIPLY

-- These get set together with story params
local minlinks
local maxlinks
local minislands
local maxislands

GLOBAL.IA_worldtype = "islandsonly"

-- GLOBAL.global("IslandTasks")
-- GLOBAL.IslandTasks = {}
-- Patch this class before adding our own tasks
local _Task = GLOBAL.Task._ctor
GLOBAL.Task._ctor = function(self, id, data)
    _Task(self, id, data)
    self.island = data.island or false
    self.set_pieces = data.set_pieces
end

modimport "main/tiles"
modimport "main/constants"
modimport "main/tuning"
modimport "main/layouts"
modimport "main/tuning_override_ia"
require "map/tasks/island"
-- local iatasks = require "map/levels/ia"

TRANSLATE_TO_PREFABS["crabhole"] =			{"crabhole"}
TRANSLATE_TO_PREFABS["ox"] =				{"ox"}
TRANSLATE_TO_PREFABS["solofish"] =			{"solofish"}
TRANSLATE_TO_PREFABS["jellyfish"] =			{"jellyfish_planted", "jellyfish_spawner"}
TRANSLATE_TO_PREFABS["fishinhole"] =		{"fishinhole"}
TRANSLATE_TO_PREFABS["seashell"] =			{"seashell_beached"}
TRANSLATE_TO_PREFABS["seaweed"] =			{"seaweed_planted"}
TRANSLATE_TO_PREFABS["obsidian"] =			{"obsidian"}
TRANSLATE_TO_PREFABS["limpets"] =			{"rock_limpet"}
TRANSLATE_TO_PREFABS["coral"] =				{"rock_coral"}
TRANSLATE_TO_PREFABS["coral_brain_rock"] =	{"coral_brain_rock"}
--TRANSLATE_TO_PREFABS["bermudatriangle"] =	{"bermudatriangle_MARKER"}
TRANSLATE_TO_PREFABS["flup"] =				{"flup", "flupspawner", "flupspawner_sparse", "flupspawner_dense"}
TRANSLATE_TO_PREFABS["sweet_potato"] =		{"sweet_potato_planted"}
TRANSLATE_TO_PREFABS["wildbores"] =			{"wildborehouse"}
TRANSLATE_TO_PREFABS["bush_vine"] =			{"bush_vine", "snakeden"}
TRANSLATE_TO_PREFABS["bamboo"] =			{"bamboo", "bambootree"}
TRANSLATE_TO_PREFABS["crate"] =				{"crate"}
TRANSLATE_TO_PREFABS["tidalpool"] =			{"tidalpool"}
TRANSLATE_TO_PREFABS["sandhill"] =			{"sanddune"}
TRANSLATE_TO_PREFABS["poisonhole"] =		{"poisonhole"}
TRANSLATE_TO_PREFABS["mussel_farm"] =		{"mussel_farm"}
TRANSLATE_TO_PREFABS["doydoy"] =			{"doydoy", "doydoybaby"}
TRANSLATE_TO_PREFABS["lobster"] =			{"lobster", "lobsterhole"}
TRANSLATE_TO_PREFABS["primeape"] =			{"primeape", "primeapebarrel"}
TRANSLATE_TO_PREFABS["bioluminescence"] =	{"bioluminescence", "bioluminescence_spawner"}
TRANSLATE_TO_PREFABS["ballphin"] =			{"ballphin", "ballphin_spawner"}
TRANSLATE_TO_PREFABS["swordfish"] =			{"swordfish", "swordfish_spawner"}
TRANSLATE_TO_PREFABS["stungray"] =			{"stungray", "stungray_spawner"}

TRANSLATE_AND_OVERRIDE["volcano"]=			{"volcano"}
TRANSLATE_AND_OVERRIDE["seagull"] =			{"seagullspawner"}

--Make sure these do not spawn on land. Blame the cheap implementation of customisation. -M
local TRANSLATE_EXCLUSIVE_TO_WATER =
{
	"solofish",
	"jellyfish_planted",
	"jellyfish_spawner",
	"fishinhole",
	"seaweed_planted",
	"rock_coral",
	"coral_brain_rock",
	"mussel_farm",
	"lobster",
	"lobsterhole",
	"bioluminescence",
	"bioluminescence_spawner",
	"ballphin",
	"ballphin_spawner",
	"swordfish",
	"swordfish_spawner",
	"stungray",
	"stungray_spawner",
	"seagullspawner",
}


--
--fix inconsistent translating in DST ocean_gen
local customise = require("map/customise")
local function TranslateWorldGenChoices(gen_params)
    if gen_params == nil or GetTableSize(gen_params) == 0 then
        return nil, nil
    end

    local translated_prefabs = {}
    local runtime_overrides = {}

    for tweak, v in pairs(gen_params) do
        if v ~= "default" then
            if TRANSLATE_AND_OVERRIDE[tweak] ~= nil then --Override and Translate
                for i,prefab in ipairs(TRANSLATE_AND_OVERRIDE[tweak]) do --Translate
                    translated_prefabs[prefab] = MULTIPLY[v]
                end

                runtime_overrides[tweak] = v --Override
            elseif TRANSLATE_TO_PREFABS[tweak] ~= nil then --Translate only
                for i,prefab in ipairs(TRANSLATE_TO_PREFABS[tweak]) do
                    translated_prefabs[prefab] = MULTIPLY[v]
                end
            else --Override only
                runtime_overrides[tweak] = v
            end
        end
    end

    if GetTableSize(translated_prefabs) == 0 then
        translated_prefabs = nil
    end

    if GetTableSize(runtime_overrides) == 0 then
        runtime_overrides = nil
    end

    return translated_prefabs, runtime_overrides
end

require "map/ocean_gen"
local PopulateWaterPrefabWorldGenCustomizations_old = GLOBAL.PopulateWaterPrefabWorldGenCustomizations
GLOBAL.PopulateWaterPrefabWorldGenCustomizations = function(populating_tile, spawnFn, entitiesOut, width, height, edge_dist, water_contents, world_gen_choices, prefab_list, ...)
	--no overrides, default
	if world_gen_choices == nil or GLOBAL.GetTableSize(world_gen_choices) == 0 then
        return PopulateWaterPrefabWorldGenCustomizations_old(populating_tile, spawnFn, entitiesOut, width, height, edge_dist, water_contents, world_gen_choices, prefab_list, ...)
    end
	--translate overrides
    local translated_prefabs = {}
    for tweak, v in pairs(world_gen_choices) do
        if v ~= "default" then
            if TRANSLATE_AND_OVERRIDE[tweak] ~= nil then
                for i,prefab in ipairs(TRANSLATE_AND_OVERRIDE[tweak]) do
                    translated_prefabs[prefab] = MULTIPLY[v]
                end
            elseif TRANSLATE_TO_PREFABS[tweak] ~= nil then
                for i,prefab in ipairs(TRANSLATE_TO_PREFABS[tweak]) do
                    translated_prefabs[prefab] = MULTIPLY[v]
                end
			end
		end
	end
	return PopulateWaterPrefabWorldGenCustomizations_old(populating_tile, spawnFn, entitiesOut, width, height, edge_dist, water_contents, translated_prefabs, prefab_list, ...)
end
--

do
	--fix last minute RoT retrofitting changes <.<
	local savefileupgrades = require("savefileupgrades")
	for i, v in ipairs(savefileupgrades.upgrades) do
		print("retro",v,v.version)
		if v.version and (v.version == 5.00 or v.version == 5.01 or v.version == 5.0) then
			print("\"Retrofit\" complete")
			v.fn = function(savedata) end
			break
		end
	end
end


local function GenerateTreasure(root, entities, width, height)

	print("GenerateTreasure")

	if entities.buriedtreasure == nil then
		entities.buriedtreasure = {}
	end
	if entities.messagebottle == nil then
		entities.messagebottle = {}
	end

	local minPaddingTreasure = 4

	local numTreasures = 18
	local numBottles = numTreasures + #entities.buriedtreasure --some might already exist (e.g. DeadmansChest/RockSkull setpiece)

	local function checkLand(tile, x, y)
		if GLOBAL.IsWaterTile(tile) then return false end --TODO should be a "not IsLandTile"
		local halfw, halfh = width / 2, height / 2
		for prefab, ents in pairs(entities) do
			for i, spawn in ipairs(ents) do
				local dx, dy = (x - halfw)*GLOBAL.TILE_SCALE - spawn.x, (y - halfh)*GLOBAL.TILE_SCALE - spawn.z
				if math.abs(dx) < minPaddingTreasure and math.abs(dy) < minPaddingTreasure then --This way, it accurately simulates the setpiece dimensions -M
					-- print("FAILED POINT", dx, dy)
					return false
				end
			end
		end
		return true
	end
	local function checkWater(tile)
		return GLOBAL.IsWaterTile(tile)
	end

	--Yes, using GetRandomWaterPoints to get explicitly non-water points. -M
	local pointsX_g, pointsY_g = GLOBAL.GetRandomWaterPoints(checkLand, width, height, TUNING.MAPEDGE_PADDING, numTreasures)
	local pointsX_w, pointsY_w = GLOBAL.GetRandomWaterPoints(checkWater, width, height, TUNING.MAPEDGE_PADDING, numBottles)

	for i = 1, #pointsX_g, 1 do
		local entData = {}
		entData.x = (pointsX_g[i] - width/2.0)*GLOBAL.TILE_SCALE
		entData.z = (pointsY_g[i] - height/2.0)*GLOBAL.TILE_SCALE
		table.insert(entities.buriedtreasure, entData)
	end
	for i = 1, #pointsX_w, 1 do
		local entData = {}
		entData.x = (pointsX_w[i] - width/2.0)*GLOBAL.TILE_SCALE
		entData.z = (pointsY_w[i] - height/2.0)*GLOBAL.TILE_SCALE
		-- entData.data = {treasureguid = 1234}
		table.insert(entities.messagebottle, entData)
	end

	print("GenerateTreasure done")

end


local function GenerateBermudaTriangles(root, entities, width, height)

    local numTriangles = TUNING.BERMUDA_AMOUNT
    local minDistSq = 50 * 50

    if entities.bermudatriangle_MARKER == nil then
        entities.bermudatriangle_MARKER = {}
    end

    local function checkTriangle(tile, x, y, points)
        if  tile ~= GLOBAL.GROUND.OCEAN_DEEP then
            return false
        end
        for i = 1, #points, 1 do
            local dx = x - points[i].x
            local dy = y - points[i].y
            local dsq = dx * dx + dy * dy

            if dsq < minDistSq then
                return false
            end
        end
        return true
    end

    local pointsX, pointsY = GLOBAL.GetRandomWaterPoints(checkTriangle, width, height, TUNING.MAPEDGE_PADDING, numTriangles)

    for i = 1, #pointsX, 1 do
        local entData = {}
        entData.x = (pointsX[i] - width/2.0)*GLOBAL.TILE_SCALE
        entData.z = (pointsY[i] - height/2.0)*GLOBAL.TILE_SCALE
        table.insert(entities.bermudatriangle_MARKER, entData)
    end
    ---------------------------------
    print(#entities.bermudatriangle_MARKER .. " points for bermudatriangle")
    if #entities.bermudatriangle_MARKER < 2 then return print("WARNING: Not enough points for new bermudatriangle") end

    if entities.bermudatriangle == nil then
        entities.bermudatriangle = {}
    end

    local id = root.MIN_WORMHOLE_ID
    local pair = 0
    minDistSq = minDistSq * GLOBAL.TILE_SCALE
    local is_farenough = function( marker1, marker2)
        local diffx, diffz = marker2.x - marker1.x, marker2.z - marker1.z
        local mag = diffx * diffx + diffz * diffz
        if mag < minDistSq then
            return false
        end
        return true
    end

    for i = #entities.bermudatriangle_MARKER, 1, -1 do
        local firstMarkerData = entities.bermudatriangle_MARKER[i]
        if firstMarkerData ~= nil then
            for j = #entities.bermudatriangle_MARKER, 1, -1 do
                local secondMarkerData = entities.bermudatriangle_MARKER[j]
                if secondMarkerData ~= nil and i ~= j and is_farenough(firstMarkerData, secondMarkerData) then
                    firstMarkerData["id"] = id
                    secondMarkerData["id"] = id + 1
                    id = id + 2
                    pair = pair + 1

                    firstMarkerData["data"] = {teleporter={target=secondMarkerData["id"]}}
                    secondMarkerData["data"] = {teleporter={target=firstMarkerData["id"]}}

                    table.insert(entities.bermudatriangle, firstMarkerData)
                    table.insert(entities.bermudatriangle, secondMarkerData)

                    entities.bermudatriangle_MARKER[i] = nil
                    entities.bermudatriangle_MARKER[j] = nil
                    break
                end
            end

            if max_pairs and pair >= max_pairs then
                break
            end
        end
    end

    print(pair .. " bermudatriangle pairs placed.")

    root.MIN_WORMHOLE_ID = id
    entities.bermudatriangle_MARKER = nil

end


local function GetIslandTaskset(usedTasks)
	usedTasks = usedTasks or {}
	local tasks = {}
    local iatasks = require "map/levels/ia"
    for i, v in pairs(iatasks[1]) do
		if not usedTasks[v] then
			table.insert(tasks, taskutil.GetTaskByName(v))
		end
    end
	local optionalTasks = {}
	for i, v in pairs(iatasks[2]) do
		if not usedTasks[v] then
			table.insert(optionalTasks, v)
		end
	end
    for i, v in pairs(GLOBAL.PickSome(math.random(minislands, maxislands), optionalTasks)) do
        table.insert(tasks, taskutil.GetTaskByName(v))
    end
	return tasks
end


function Story:LinkIslandNodesAroundMainlandByKeys(unusedTasks, anchor_tasks)
	if not unusedTasks then return end
	unusedTasks = deepcopy(unusedTasks)

    local availableKeys = {}
    for _,t in ipairs(self.tasks) do
		for _,k in pairs(t.keys_given) do
			availableKeys[k] = availableKeys[k] or {}
			table.insert(availableKeys[k], t)
		end
    end

	local lastNode = next(anchor_tasks) --default

	--Try to use nearby tasks first, cache placed islands for the next round
	local accepting_tasks = {}
	local next_accepting_tasks = {}
	for k, v in pairs(anchor_tasks) do
		-- print("initial accepting of",k.id)
		accepting_tasks[k] = k.id == 1
	end

    print("Linking islands...")

    while GetTableSize(unusedTasks) > 0 do

		local effectiveLastNode = lastNode
		local currentNode = nil

		--print("\n\n### About to insert a node. Last node:", lastNode.id)

		--print("\tHave Keys:")
		--for key, keyNodes in pairs(availableKeys) do
			--print("\t\t",KEYS_ARRAY[key], GetTableSize(keyNodes))
		--end

		for taskid, node in pairs(unusedTasks) do

			--print("  TASK: "..taskid)
			--print("\t Locks:")

			local locks = {}
			for i,v in ipairs(self.tasks[taskid].locks) do
				local lock = {keys=LOCKS_KEYS[v], unlocked=false}
				locks[v] = lock
				--print("\t\tLock:",LOCKS_ARRAY[v],tabletoliststring(lock.keys, function(x) return KEYS_ARRAY[x] end))
			end


			local unlockingNodes = {}

			for lock,lockData in pairs(locks) do
				--print("\tUnlocking",LOCKS_ARRAY[lock])
				for key, keyNodes in pairs(availableKeys) do	-- Do we have any key for this lock?
					for reqKeyIdx,reqKey in ipairs(lockData.keys) do
						if reqKey == key then -- If yes, get the nodes with that key so that we can potentially attach to one.
							for i,node in ipairs(keyNodes) do
								if accepting_tasks[node] then
									unlockingNodes[node.id] = node
								end
							end
							lockData.unlocked = true
							--print("\t\t\tUnlocked!", KEYS_ARRAY[key])
						end
					end
				end
			end

			--nothing immediately unlocked this, so
			if next(unlockingNodes) == nil then
				for k, v in pairs(accepting_tasks) do
					unlockingNodes[k.id] = k
				end
			end

			local unlocked = true
			-- for lock,lockData in pairs(locks) do
				-- --print("\tDid we unlock ", LOCKS_ARRAY[lock])
				-- if lockData.unlocked == false then
					-- --print("\t\tno.")
					-- unlocked = false
					-- break
				-- end
			-- end

			if unlocked then
				-- this task is presently unlockable!
				currentNode = node
				--print ("StartParentNode",startParentNode.id,"currentNode",currentNode.id)

				local lowest = {i=999,node=nil}
				local highest = {i=-1,node=nil}
				for id,node in pairs(unlockingNodes) do
					if node.story_depth >= highest.i then
						highest.i = node.story_depth
						highest.node = node
					end
					if node.story_depth < lowest.i then
						lowest.i = node.story_depth
						lowest.node = node
					end
				end

				--I slightly modified this part so "default" is actually default (i.e. "else"). Nothing island-specific about it. -M
				if self.gen_params.branching == "most" then
					effectiveLastNode = lowest.node
					--print("\tAttaching "..currentNode.id.." to lowest key", effectiveLastNode.id)
				elseif self.gen_params.branching == "least" then
					effectiveLastNode = highest.node
					--print("\tAttaching "..currentNode.id.." to highest key", effectiveLastNode.id)
				elseif self.gen_params.branching == "never" then
					effectiveLastNode = lastNode
					--print("\tAttaching "..currentNode.id.." to end of chain", effectiveLastNode.id)
				else --default
					effectiveLastNode = GLOBAL.GetRandomItem(unlockingNodes)
					--print("\tAttaching "..currentNode.id.." to random key", effectiveLastNode.id)
				end

				break
			end

		end

		if effectiveLastNode == nil then --failsafe, get any accepting_tasks
			effectiveLastNode = next(accepting_tasks)
		end

		if currentNode == nil then
			currentNode = self:GetRandomNodeFromTasks(unusedTasks)
			--print("\t\tAttaching random node "..currentNode.id.." to last node", effectiveLastNode.id)
		end

		local lastNodeExit = effectiveLastNode:GetRandomNodeForExit()
		local currentNodeEntrance = currentNode.entrancenode or currentNode:GetRandomNodeForEntrance()

		assert(lastNodeExit)
		assert(currentNodeEntrance)

        self:SeparateByOcean(lastNodeExit, currentNodeEntrance)

		-- if self.gen_params.island_percent ~= nil and self.gen_params.island_percent >= math.random() and currentNodeEntrance.data.entrance == false then
			-- self:SeperateStoryByBlanks(lastNodeExit, currentNodeEntrance )
		-- else
			-- self.rootNode:LockGraph(effectiveLastNode.id..'->'..currentNode.id, lastNodeExit, currentNodeEntrance, {type="none", key=self.tasks[currentNode.id].locks, node=nil})
		-- end

		--print("\t\tAdding keys to keyring:")
		for i,v in ipairs(self.tasks[currentNode.id].keys_given) do
			if availableKeys[v] == nil then
				availableKeys[v] = {}
			end
			table.insert(availableKeys[v], currentNode)
			--print("\t\t",KEYS_ARRAY[v])
		end

		--Count down the accepted tasks
		if accepting_tasks[effectiveLastNode] and accepting_tasks[effectiveLastNode] > 1 then
			accepting_tasks[effectiveLastNode] = accepting_tasks[effectiveLastNode] - 1
		else
			accepting_tasks[effectiveLastNode] = nil
		end
		next_accepting_tasks[currentNode] = 2

		--Time for next ring?
		if not next(accepting_tasks) then
			accepting_tasks = next_accepting_tasks
			next_accepting_tasks = {}
		end

		unusedTasks[currentNode.id] = nil
		-- usedTasks[currentNode.id] = currentNode
		lastNode = currentNode
	end

    print("Done with islands.")
end


function Story:SeparateByOcean(start_node, end_node, links)
    local blank_node = GLOBAL.Graph("LOOP_BLANK"..tostring(self.loop_blanks), {parent=self.rootNode, default_bg=GLOBAL.GROUND.OCEAN_SHALLOW, colour = {r=0,g=0,b=0,a=1}, background="BGImpassable" })
    GLOBAL.WorldSim:AddChild(self.rootNode.id, "LOOP_BLANK"..tostring(self.loop_blanks), GLOBAL.GROUND.OCEAN_SHALLOW, 0, 0, 0, 1, "blank")

    local nodes = {}
    local new_node = nil
    local previous_node = nil
    links = links or math.random(minlinks, maxlinks)
    for i = 1, links, 1 do
        new_node = blank_node:AddNode({
			id="LOOP_BLANK_SUB "..tostring(self.loop_blanks),
			data={
				type=GLOBAL.NODE_TYPE.Blank,
				name="LOOP_BLANK_SUB",
				tags = {"RoadPoison", "ForceDisconnected"},
				colour={r=0.3,g=.8,b=.5,a=.50},
				value = self.impassible_value,
				internal_type = GLOBAL.NODE_INTERNAL_CONNECTION_TYPE.EdgeCentroid,
			  }
		})

        if previous_node then
            local edge = blank_node:AddEdge({
                            node1id = new_node.id,
                            node2id = previous_node.id})
        end

        self.loop_blanks = self.loop_blanks + 1
        previous_node = new_node
        table.insert(nodes, new_node)
    end

    local first_node = nodes[1]
    local last_node = nodes[#nodes]

    self.rootNode:LockGraph(start_node.id..'->'..first_node.id, start_node, first_node, { type = "none", key = GLOBAL.KEYS.NONE, node = nil })
    self.rootNode:LockGraph(end_node.id..'->'..last_node.id, end_node, last_node, { type = "none", key = GLOBAL.KEYS.NONE, node = nil })
end

--copy of LinkNodesByKeys, except forces blanks between tasks
function Story:LinkIslandNodesByKeys(startParentNode, unusedTasks)
    print("[Story Gen] LinkIslandNodesByKeys")
	--print("\n\n### START PARENT NODE:",startParentNode.id)
	local lastNode = startParentNode
	local availableKeys = {}
	for i,v in ipairs(self.tasks[startParentNode.id].keys_given) do
		availableKeys[v] = {}
		table.insert(availableKeys[v], startParentNode)
	end
	local usedTasks = {}

	startParentNode.story_depth = 0
	local story_depth = 1
	local currentNode = nil

	while GetTableSize(unusedTasks) > 0 do
		local effectiveLastNode = lastNode

		--print("\n\n### About to insert a node. Last node:", lastNode.id)

		--print("\tHave Keys:")
		for key, keyNodes in pairs(availableKeys) do
			--print("\t\t",KEYS_ARRAY[key], GetTableSize(keyNodes))
		end

		for taskid, node in pairs(unusedTasks) do

			--print("  TASK: "..taskid)
			--print("\t Locks:")

			local locks = {}
			for i,v in ipairs(self.tasks[taskid].locks) do
				local lock = {keys=LOCKS_KEYS[v], unlocked=false}
				locks[v] = lock
				--print("\t\tLock:",LOCKS_ARRAY[v],tabletoliststring(lock.keys, function(x) return KEYS_ARRAY[x] end))
			end


			local unlockingNodes = {}

			for lock,lockData in pairs(locks) do						-- For each lock:
				--print("\tUnlocking",LOCKS_ARRAY[lock])
				for key, keyNodes in pairs(availableKeys) do			-- Do we have any key for
					for reqKeyIdx,reqKey in ipairs(lockData.keys) do	   -- this lock?
						if reqKey == key then							-- If yes, get the nodes with
																		   -- that key so that we
							for i,node in ipairs(keyNodes) do			   -- can potentially attach
								unlockingNodes[node.id] = node			   -- to one.
							end
							lockData.unlocked = true					-- Also unlock the lock
							--print("\t\t\tUnlocked!", KEYS_ARRAY[key])
						end
					end
				end
			end

			local unlocked = true
			for lock,lockData in pairs(locks) do
				--print("\tDid we unlock ", LOCKS_ARRAY[lock])
				if lockData.unlocked == false then
					--print("\t\tno.")
					unlocked = false
					break
				end
			end

			if unlocked then
				-- this task is presently unlockable!
				currentNode = node
				--print ("StartParentNode",startParentNode.id,"currentNode",currentNode.id)

				local lowest = {i=999,node=nil}
				local highest = {i=-1,node=nil}
				for id,node in pairs(unlockingNodes) do
					if node.story_depth >= highest.i then
						highest.i = node.story_depth
						highest.node = node
					end
					if node.story_depth < lowest.i then
						lowest.i = node.story_depth
						lowest.node = node
					end
				end

				if self.gen_params.branching == nil or self.gen_params.branching == "default" or self.gen_params.branching == "random" then
					effectiveLastNode = GLOBAL.GetRandomItem(unlockingNodes)
					--print("\tAttaching "..currentNode.id.." to random key", effectiveLastNode.id)
				elseif self.gen_params.branching == "most" then
					effectiveLastNode = lowest.node
					--print("\tAttaching "..currentNode.id.." to lowest key", effectiveLastNode.id)
				elseif self.gen_params.branching == "least" then
					effectiveLastNode = highest.node
					--print("\tAttaching "..currentNode.id.." to highest key", effectiveLastNode.id)
				elseif self.gen_params.branching == "never" then
					effectiveLastNode = lastNode
					--print("\tAttaching "..currentNode.id.." to end of chain", effectiveLastNode.id)
				end

				break
			end

		end

		if currentNode == nil then
			currentNode = self:GetRandomNodeFromTasks(unusedTasks)
			--print("\t\tAttaching random node "..currentNode.id.." to last node", effectiveLastNode.id)
		end

		currentNode.story_depth = story_depth
		story_depth = story_depth + 1

		local lastNodeExit = effectiveLastNode:GetRandomNodeForExit()
		local currentNodeEntrance = currentNode.entrancenode or currentNode:GetRandomNodeForEntrance()

		assert(lastNodeExit)
		assert(currentNodeEntrance)

		self:SeparateByOcean(lastNodeExit, currentNodeEntrance )

		--print("\t\tAdding keys to keyring:")
		for i,v in ipairs(self.tasks[currentNode.id].keys_given) do
			if availableKeys[v] == nil then
				availableKeys[v] = {}
			end
			table.insert(availableKeys[v], currentNode)
			--print("\t\t",KEYS_ARRAY[v])
		end

		unusedTasks[currentNode.id] = nil
		usedTasks[currentNode.id] = currentNode
		lastNode = currentNode
		currentNode = nil
	end

	return lastNode:GetRandomNodeForExit()
end


function Story:GenerateNodesForIslands(taskset)
	-- Generate all the TERRAIN
	local task_nodes = {}
	for k, task in pairs(taskset) do
		assert(self.TERRAIN[task.id] == nil, "Cannot add the same task twice!")

		local task_node = self:GenerateNodesFromTask(task, task.crosslink_factor or 1, nil)
		for k,v in pairs(task_node.nodes) do
			v.data = v.data or {}
			v.data.tags = v.data.tags or {}
			if not table.contains(v.data.tags, "islandclimate") then
				table.insert(v.data.tags, "islandclimate")
			end
		end
		self.TERRAIN[task.id] = task_node
		task_nodes[task.id] = task_node
	end
	return task_nodes
end

local GenerateNodesFromTasks_old = Story.GenerateNodesFromTasks
function Story:GenerateNodesFromTasks(...)
	if GLOBAL.IA_worldtype == "islandsonly" and self.level.location == "forest" then

		if not self.level.ia_compatible then
			--purge non-islands
			--This assumes regions are islands, which is not necessarily true. -M
			for k, v in pairs(self.region_tasksets["mainland"]) do
				if not (startTask and startTask == k) and not v.island then --mod support, probably -M
					self.region_tasksets["mainland"][k] = nil
					self.tasks[v.id] = nil
				end
			end

			--inject IA islands
			for k, v in pairs(GetIslandTaskset(self.tasks)) do
				self.tasks[v.id] = v
				self.region_tasksets["mainland"][v.id] = v
			end

			--fix starter task (needs to have roads or worldgen crashes when Encoding)
			HomeIslandSmallBoon = taskutil.GetTaskByName("HomeIslandSmallBoon_Road")
			self.tasks["HomeIslandSmallBoon_Road"] = HomeIslandSmallBoon
			self.region_tasksets["mainland"]["HomeIslandSmallBoon_Road"] = HomeIslandSmallBoon
			if not self.level.valid_start_tasks then
				self.level.valid_start_tasks = {}
			end
			self.level.valid_start_tasks[1] = "HomeIslandSmallBoon_Road"
		end


		-- self.gen_params.island_percent = 1
		-- local g = self:GenerateNodesForRegion(self.region_tasksets["mainland"], "LinkNodesByKeys")
		local task_nodes = self:GenerateNodesForIslands(self.region_tasksets["mainland"])

		local startingTask = self:_FindStartingTask(task_nodes)
		task_nodes[startingTask.id] = nil

		print("[Story Gen] Generate nodes (IA). Starting at: " .. startingTask.id)

		local finalNode = self:LinkIslandNodesByKeys(startingTask, task_nodes)
		local entranceNode = startingTask:GetRandomNodeForEntrance()

		-- form the map into a loop!
		if entranceNode.data.task ~= finalNode.data.task
		and math.random() < (self.gen_params.loop_percent or .5) then
			--print("Adding map loop")
			self:SeperateStoryByBlanks(entranceNode, finalNode )
		end

		local g = {startingTask = startingTask, entranceNode = entranceNode, finalNode = finalNode}

		--fix start node
		if not self.level.ia_compatible then
			-- self.level.valid_start_tasks = {"HomeIslandSmallBoon"}
			self.gen_params.start_node = "BeachSandHome_Spawn"
		end
		self.startNode = self:_AddPlayerStartNode(g) -- Adds where the player portal will be spawned and used in placement.lua to force the starting point to be at the center of the map

		--also patch this stuff, there's probably a better location for it though -M --TODO
		if not self.level.ia_compatible then
			local iatasks = require "map/levels/ia"
			self.level.set_pieces["ResurrectionStone"] = iatasks[1]
			self.level.set_pieces["WormholeGrass"] = nil--iatasks[1]
			self.level.set_pieces["CaveEntrance"] = iatasks[1]
			self.level.set_pieces["MooseNest"] = nil--iatasks[1]
		end

		return g
	else
		return GenerateNodesFromTasks_old(self, ...)
	end
end


--add IA islands as a special kind of region
local AddRegionsToMainland_old = Story.AddRegionsToMainland
function Story:AddRegionsToMainland(on_region_added_fn, ...)
	if GLOBAL.IA_worldtype ~= "merged" or self.level.location ~= "forest" then
		return AddRegionsToMainland_old(self, on_region_added_fn, ...)
	end

	--find valid nodes at the ocean
	--This probably doesn't work well with branching == "least". -M
	local nodes = {}
	for _, edge in pairs(self.rootNode.exit_edges) do
		nodes[edge.node1] = nil --no longer valid
		if edge.node2 then
			nodes[edge.node2] = true --now valid
		end
	end

	print("Adding regular regions...")
	--add actual regions
	AddRegionsToMainland_old(self, on_region_added_fn, ...)
	print("Done adding regular regions. Next up: Island Adventures pseudo-region...")
	--nodes used by regions are no longer at the ocean and thus no longer valid
	--If you want to make region nodes valid, run FindMainlandNodesForIslands after AddRegionsToMainland_old and skip this part. -M
	--There's probably a more efficient way to do this, but at least we can rest asured this works. -M
	for _, edge in pairs(self.rootNode.exit_edges) do
		nodes[edge.node1] = nil --no longer valid
	end
	local anchor_tasks = {}
	for node, _ in pairs(nodes) do
		if node.graph then
			anchor_tasks[node.graph] = true
		end
	end

	--now add the islands all around the mainland
	local new_tasks = GetIslandTaskset(self.tasks)
	-- self.region_tasksets.islandadventures = {}
	for k, task in pairs(new_tasks) do
		self.tasks[task.id]=task
		-- self.region_tasksets.islandadventures[task.id] = task
	end
	local new_task_nodes = self:GenerateNodesForIslands( new_tasks, anchor_tasks )
	-- self:AddCoveNodes( new_task_nodes )
	self:LinkIslandNodesAroundMainlandByKeys( new_task_nodes, anchor_tasks )
	self:InsertAdditionalSetPieces( new_task_nodes )

	if on_region_added_fn ~= nil then
		on_region_added_fn()
	end

end

-- GLOBAL.Graph.PopulateVoronoi = function() end --DEBUG faster island gen tests
-- GLOBAL.PopulateOcean = function() end --DEBUG faster island gen tests

-- local BuildStory_old = GLOBAL.BuildStory
-- GLOBAL.BuildStory = function(tasks, story_gen_params, level, ...)
	-- local topology_save, story

	-- if GLOBAL.IA_worldtype ~= "islandsonly" then then
		-- print("Building default mainland")
		-- topology_save, story = BuildStory_old(tasks, story_gen_params, level)
	-- else
		-- print("Building starting island")
		-- local start_time = GLOBAL.GetTimeReal()

		-- --"terrain" is never declared in the og function. Maybe global on accident? -M
		-- story = GLOBAL.Story("GAME", tasks, terrain, story_gen_params, level)
		-- story.tasks.HomeIslandSmallBoon = taskutil.GetTaskByName("HomeIslandSmallBoon")
		-- story.tasks.HomeIslandMed = taskutil.GetTaskByName("HomeIslandMed")
		-- story.region_tasksets["mainland"] = {HomeIslandSmallBoon = story.tasks.HomeIslandSmallBoon,HomeIslandMed = story.tasks.HomeIslandMed}
		-- story.gen_params.start_node = "BeachSandHome_Spawn"
		-- story:GenerationPipeline()
		-- topology_save = {root=story.rootNode, startNode=story.startNode, GlobalTags = story.GlobalTags}
	-- end

	-- --done in AddRegionsToMainland now
	-- -- if not level.overrides.worldtype or level.overrides.worldtype ~= 0 then
		-- -- print("Building surrounding islands")
	-- -- end

    -- --story:InsertAdditionalTreasures()

    -- return topology_save, story
-- end

--fix setpieces on water
local InsertAdditionalSetPieces_old = Story.InsertAdditionalSetPieces
function Story:InsertAdditionalSetPieces(task_nodes, ...)
	local tasks = task_nodes or self.rootNode:GetChildren()
	local setpieces_cached = {}
	local is_entrance = function(room)
		-- return true if the room is an entrance
		return room.data.entrance == true
	end
	local is_background_ok = function(room, setpiece_data)
		-- return true if the piece is not backround restricted, or if it is but we are on a background
		return setpiece_data.restrict_to ~= "background" or room.data.type == "background"
	end
	local isnt_blank_or_water = function(room)
		return room.data.type ~= "blank" and not GLOBAL.IsWaterOrImpassable(room.data.value)
	end

	for id, task in pairs(tasks) do
		-- print("trying setpieces for task",id)
		if task.set_pieces ~= nil and #task.set_pieces >0 then
			for i = #task.set_pieces, 1, -1 do
				local setpiece_data = task.set_pieces[i]
				--This flag is what marks setpieces for this process
				if AllLayouts[setpiece_data.name] and AllLayouts[setpiece_data.name].restrict_to_valid_land then
					local choicekeys = GLOBAL.shuffledKeys(task.nodes)
					local choice = nil
					for i, choicekey in ipairs(choicekeys) do
						if not is_entrance(task.nodes[choicekey]) and is_background_ok(task.nodes[choicekey], setpiece_data) and isnt_blank_or_water(task.nodes[choicekey]) then
							choice = choicekey
							break
						end
					end

					if choice == nil then
						print("Warning! Couldn't find a valid land spot in "..task.id.." for "..setpiece_data.name)
						break
					end

					-- print("Setpiece Placing "..setpiece_data.name.." in "..task.id..":"..task.nodes[choice].id)

					if task.nodes[choice].data.terrain_contents.countstaticlayouts == nil then
						task.nodes[choice].data.terrain_contents.countstaticlayouts = {}
					end
					--print ("Set peice", name, choice, room_choices._et[choice].contents, room_choices._et[choice].contents.countstaticlayouts[name])
					task.nodes[choice].data.terrain_contents.countstaticlayouts[setpiece_data.name] = 1

					if setpieces_cached[task] == nil then
						setpieces_cached[task] = {}
					end
					--temporarily remove setpiece so it won't get added twice
					table.insert(setpieces_cached[task], setpiece_data)
					table.remove(task.set_pieces, i)
				end
			end
		end
	end
	--now place regular setpieces
	InsertAdditionalSetPieces_old(self, task_nodes, ...)
	--restore set_pieces
	for task, set_pieces in pairs(setpieces_cached) do
		for i, setpiece_data in pairs(set_pieces) do
			table.insert(task.set_pieces, setpiece_data)
		end
	end
end


local world_gen_choices_water --cache -M
local PopulateExtra_old = GLOBAL.Node.PopulateExtra
GLOBAL.Node.PopulateExtra = function(self, world_gen_choices, ...)
	--exclude water prefabs if not on water
	if not GLOBAL.IsWaterTile(self.data.value) then
		local choices = world_gen_choices_water
		if world_gen_choices and not choices then
			choices = deepcopy(world_gen_choices) --could probably be shallow copy -M
			for k, v in pairs(TRANSLATE_EXCLUSIVE_TO_WATER) do
				choices[v] = nil
			end
			world_gen_choices_water = choices
		end
		--TODO further limit kelp to shallow, coral to reef, etc?
		world_gen_choices = choices
	end
	return PopulateExtra_old(self, world_gen_choices, ...)
end

local _PostPopulate = GLOBAL.Graph.GlobalPostPopulate
GLOBAL.Graph.GlobalPostPopulate = function(self, entities, width, height, ...)
	_PostPopulate(self, entities, width, height, ...)
	if GLOBAL.IA_worldtype ~= "default" then
		GenerateBermudaTriangles(self, entities, width, height, ...)
		GenerateTreasure(self, entities, width, height, ...)
	end
end

MapTagger.AddMapTag("Packim_Fishbone", function(tagdata)
	if tagdata["Packim_Fishbone"] == false then
		return
	end
	tagdata["Packim_Fishbone"] = false
	return "ITEM", "packim_fishbone"
end)
MapTagger.AddMapData("Packim_Fishbone", true)
MapTagger.AddMapTag("islandclimate", function(tagdata) return "TAG", "islandclimate" end)

local function injectTasksIntoSet(taskset)
	-- local iatasks = require "map/levels/ia"
	-- for i, v in pairs(iatasks[1]) do
		-- table.insert(taskset.tasks, v)
	-- end
	-- for i, v in pairs(GLOBAL.PickSome(math.random(minislands, maxislands), iatasks[2])) do
		-- table.insert(taskset.tasks, v)
	-- end
	--also inject ocean_population while we're at it
	if not taskset.ocean_population then
		taskset.ocean_population = {}
	end
	-- table.insert(taskset.ocean_population, "WaterAll") --TODO this doesn't work without further work, but is only used for treasure maps, so maybe we can spawn the maps in a different way (bermuda?) -M
	table.insert(taskset.ocean_population, "WaterCoral")
	table.insert(taskset.ocean_population, "WaterDeep")
	table.insert(taskset.ocean_population, "WaterMangrove")
	table.insert(taskset.ocean_population, "WaterMedium")
	table.insert(taskset.ocean_population, "WaterShallow")
	table.insert(taskset.ocean_population, "WaterShipGraveyard")
end
-- AddTaskSetPreInit("default", injectTasksIntoSet)

local function levelPreInitAny(level)
	local islandquantity = level.overrides.islandquantity or "default"
	local islandlinks = level.overrides.world_size or "default"
	-- Island stuff
	minislands = TUNING.MIN_ISLANDS[islandquantity] or 4
	maxislands = TUNING.MAX_ISLANDS[islandquantity] or 6
    minlinks = TUNING.MIN_ISLANDLINKS[islandlinks] or 4
    maxlinks = TUNING.MAX_ISLANDLINKS[islandlinks] or 7

	if GLOBAL.IA_worldtype == "islandsonly" and minislands > 0 then
		minislands = minislands + 3
		maxislands = maxislands + 3
	end

	if level.location == "forest" then
		injectTasksIntoSet(level)
	end

	TUNING.BERMUDA_AMOUNT = TUNING.BERMUDA_AMOUNT * MULTIPLY[level.overrides.bermudatriangle or "default"]
end
AddLevelPreInitAny(levelPreInitAny)


function map.Generate(prefab, map_width, map_height, tasks, level, level_type, ...)
    --initialise global scope parameters
    assert(level.overrides ~= nil, "Level must have overrides specified.")
	if not level.overrides.primaryworldtype then level.overrides.primaryworldtype = "merged" end --Haack, but needed so the override function always gets called. -M
	--We should compare this to the shard somehow. (Is this master or caves/volcano?) -M
	GLOBAL.IA_worldtype = (level.overrides.primaryworldtype == "default" or prefab == "caves") and "default"
		or (level.overrides.primaryworldtype == "merged") and "merged"
		or "islandsonly"

	local save = _Generate(prefab, map_width, map_height, tasks, level, level_type, ...)
	--set a version flag
	if save and save.map and save.map.topology then
		save.map.topology.ia_worldgen_version = 1
		--Feel free to increase this version when making big changes. -M
		--Test this during simulation via TheWorld.topology.ia_worldgen_version
	end
	return save
end


if GLOBAL.ModManager.worldgen then
    local _G = GLOBAL
    local debug = _G.debug
    local funcs = {}

    function hook()
        -- passing 2 to to debug.getinfo means 'give me info on the function that spawned
        -- this call to this function'. level 1 is the C function that called the hook.
        local info = debug.getinfo(1)
        if info ~= nil then
        if funcs[info.name] == nil or funcs[info.name] == true then return end
            local i, variables = 1, {""}
            -- now run through all the local variables at this level of the lua stack
            while true do
                local name, value = debug.getlocal(2, i)
                if name == nil then
                    break
                end
                -- this just skips unused variables
                if name ~= "(*temporary)" then
                    variables[tostring(name)] = value
                end
                i = i + 1
            end
                -- this is what dumps info about a function thats been called
            print((info.name or "unknown").. "(".. DataDumper(variables, '').. ")")
        funcs[info.name] = true
        end
    end

    -- tell the debug library to call lua function 'hook 'every time a function call
    -- is made...
    --debug.sethook(hook, "c")

    for k,v in pairs(GLOBAL.getmetatable(GLOBAL.WorldSim).__index) do
        funcs[k] = false
    end
end