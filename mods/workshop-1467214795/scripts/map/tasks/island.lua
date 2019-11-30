require "map/rooms/ia/terrain_beach"
require "map/rooms/ia/terrain_jungle"
require "map/rooms/ia/terrain_magmafield"
require "map/rooms/ia/terrain_mangrove"
require "map/rooms/ia/terrain_meadow"
require "map/rooms/ia/terrain_ocean"
require "map/rooms/ia/terrain_tidalmarsh"
require "map/rooms/ia/volcano"
require "map/rooms/ia/water_content"

--[[
AddTask("SampleTask", { --Name to use in the 'tasks' or 'optionaltasks' list
		--This is the lock that require to use the task
		locks=LOCKS.ISLAND1,

		--These are the key(s) given when the task is used. KEYS.ISLAND2 unlocks LOCK.ISLAND2
		keys_given={KEYS.ISLAND2},

		--This is new in DST, it groups tasks into a region separate from the mainland
		region_id = "islandadventures0",
		
		--This is new in DST, it applies tags to all the rooms of the task
		room_tags={"RoadPoison", "not_mainland"},

		--This is used add links between biomes in an island which can make interesting shapes
		--0-1 seems to be a good amount
		crosslink_factor=math.random(0,1),

		--When an island is generated this gives a chance the island ends will be connected making
		--a round island and sometimes lagoons
		make_loop=math.random(0, 100) < 50,
		
		-- This is a SW-exclusive feature, it is not available in IA.
		-- From a quick glance, it seems to not have done anything special anyways.
		gen_method = "lagoon",

		-- Mark this as an actual island, else it becomes part of the mainland.
		island=true,
		
		--The rooms (biomes) that the task (island) contains.
		--Rooms can be found in the map/rooms/ folder
		--Shipwrecked files: terrain_beach.lua, terrain_island.lua, terrain_jungle.lua, terrain_ocean.lua, terrain_swamp.lua
		--See map/rooms/terrain_jungle.lua for room info
		room_choices={
			--From terrain_jungle.lua, add 2 to 5 JungleClearing biomes to the island
			["JungleClearing"] = 2 + math.random(0, 3),

			--From terrain_savanna.lua, add 1 BareMangrove biome to the island
			["BareMangrove"] = 1,

			--From terrain_savanna.lua, add 3 + 0 to 3 Plain biomes to the island
			["Plain"] = 3 + math.random(0, 3),

			--From terrain_forest.lua, add 1 Clearing biome to the island
			["Clearing"] = 1,

			--From terrain_rocky.lua, add 1 to 4 Rocky biomes to the island
			["RockyIsland"] = 1 + math.random(0, 3),

			--From graveyard.lua, add 0 to 1 Graveyard biomes to the island
			["Graveyard"] = math.random(0, 1),

			--From terrain_jungle.lua, add 0 to 2 JungleDenseVery biomes to the island
			["JungleDenseVery"] = math.random(0, 2),

				--From terrain_jungle.lua, add 0 to 2 JungleDenseVery biomes to the island
			["BeachPalmForest"] = math.random(0, 2),
		},

		--This is a backup basically, a background room of just this tile type is added to the task
		--GROUND (tile types) are in constants.lua
		room_bg=GROUND.JUNGLE,

		background_room="BeachSand",

		--Used for debug stuff
		colour={r=1,g=1,b=0,a=1}
	})
]]

AddTask("HomeIslandVerySmall", {
		locks=LOCKS.NONE, --LOCKS.ISLAND1,
		keys_given={KEYS.ISLAND2},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_HomeIslandVerySmall",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["JungleDenseMedHome"] = 1, --changed from JungleDense to remove monkeys
			["BeachSandHome"] = 2,
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="BeachSandHome",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("HomeIslandSmall", {
		locks=LOCKS.NONE, --LOCKS.ISLAND1,
		keys_given={KEYS.ISLAND2},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_HomeIslandSmall",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["JungleDenseMedHome"] = 2, --changed from JungleDense to remove monkeys
			["BeachUnkept"] = 1,
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="BeachSandHome",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("HomeIslandSmallBoon", {
		locks=LOCKS.NONE, --LOCKS.ISLAND1,
		keys_given={KEYS.ISLAND2},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_HomeIslandSmallBoon",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["JungleDenseHome"] = 2,
			["JungleDenseMedHome"] = 1, --changed from JungleDense to remove monkeys
			["BeachSandHome"] = 1, 
			["BeachUnkept"] = 1,
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="BeachSandHome", --removed BeachUnkept, added unkept above
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("HomeIslandSmallBoon_Road", {
		locks=LOCKS.NONE, --LOCKS.ISLAND1,
		keys_given={KEYS.ISLAND1, KEYS.ISLAND2},
		--region_id="islandadventures0",
		room_tags={},
		--region_id="ia_HomeIslandSmallBoon",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["JungleDenseHome"] = 2,
			["JungleDenseMedHome"] = 1, --changed from JungleDense to remove monkeys
			["BeachSandHome"] = 1,
			["BeachUnkept"] = 1,
		},
		room_bg=GROUND.JUNGLE,
		background_room="BeachSandHome", --removed BeachUnkept, added unkept above
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1},
	})

AddTask("HomeIslandSingleTree", {
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_HomeIslandSingleTree",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["OceanShallow"] = 1, -- was BeachSinglePalmTreeHome
		}, 
		room_bg=GROUND.OCEAN_SHALLOW,
		background_room="OceanShallow",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("HomeIslandMed", {
		locks=LOCKS.NONE, --LOCKS.ISLAND1,
		keys_given={KEYS.ISLAND2},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_HomeIslandMed",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["JungleDenseMedHome"] = 3 + math.random(0, 3), --changed from JungleDense to remove monkeys
			["BeachUnkept"] = 1, 
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="BeachSandHome",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("HomeIslandLarge", {
		locks=LOCKS.NONE, --LOCKS.ISLAND1,
		keys_given={KEYS.ISLAND2},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_HomeIslandLarge",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["JungleDenseMedHome"] = 3 + math.random(0, 3), --changed from JungleDense to remove monkeys
			["BeachUnkept"] = 2
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="BeachSandHome",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("HomeIslandLargeBoon", {
		locks=LOCKS.NONE, --LOCKS.ISLAND1,
		keys_given={KEYS.ISLAND2},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_HomeIslandLargeBoon",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["JungleDenseMedHome"] = 3 + math.random(0, 3), --changed from JungleDense to remove monkeys
			["BeachUnkept"] = 2, 
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="BeachSandHome",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})
--[[
AddTask("LagoonTest", {
		locks=LOCKS.NONE, --LOCKS.ISLAND1,
		keys_given={KEYS.ISLAND2},
		gen_method = "lagoon",
		room_choices={
			{
				["OceanShallow"] = 2
			},
			{
				["BeachSand"] = 5,
			},
			{
				["JungleDense"] = 10,
			},
			{
				["BeachUnkept"] = 18 -- was 3*18
			}, 
		}, 
		room_bg=GROUND.JUNGLE,
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})
]]
AddTask("DesertIsland", {
		locks=LOCKS.NONE, --LOCKS.ISLAND1,
		keys_given={KEYS.ISLAND2},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_DesertIsland",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["BeachSand"] = 1 + math.random(0, 3),
		}, 
		room_bg=GROUND.BEACH,
		background_room="BeachSand",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

-- AddTask("VolcanoIsland",
		-- locks=LOCKS.NONE, --LOCKS.ISLAND1,
		-- keys_given={KEYS.ISLAND1},
		-- crosslink_factor=math.random(0,1),
		-- make_loop=math.random(0, 100) < 50,
		-- island=true,
		-- room_choices={
			-- ["VolcanoRock"] = 1,
			-- ["MagmaVolcano"] = 1,
			-- ["VolcanoObsidian"] = 1,
			-- ["VolcanoObsidianBench"] = 1,
			-- ["VolcanoAltar"] = 1,
			-- ["VolcanoLava"] = 1
		-- }, 
		-- room_bg=GROUND.BEACH,
		-- background_room="OceanDeep",
		-- colour={r=1,g=1,b=0,a=1}
	-- })

AddTask("JungleMarsh", {
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		gen_method = "lagoon",
		island=true,
		room_choices={
			["TidalMarsh"] = 2,
			["JungleDense"] = 6, 
			["JungleDenseBerries"] = 2
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="OceanShallow",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("BeachJingleS", {
		locks=LOCKS.NONE, --LOCKS.ISLAND1,
		keys_given={KEYS.ISLAND2},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_BeachJingleS",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["JungleDenseMed"] = 3, 
			["BeachUnkept"] = 1
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="BeachSand",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})
	
AddTask("BeachBothJungles", {
		locks=LOCKS.NONE, --LOCKS.ISLAND1,
		keys_given={KEYS.ISLAND2},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_BeachBothJungles",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["JungleDenseMed"] = 1,
			["JungleDense"] = 2, 
			["BeachSand"] = 3 
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="BeachUnkept",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("BeachJungleD", {
		locks=LOCKS.NONE, --LOCKS.ISLAND1,
		keys_given={KEYS.ISLAND2},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_BeachJungleD",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["JungleDense"] = 2, 
			["BeachSand"] = 1 
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="BeachSand",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("BeachSavanna", {
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_BeachSavanna",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["BeachSand"] = 2, 
			["NoOxMeadow"] = 2 
		}, 
		room_bg=GROUND.BEACH,
		background_room="BeachUnkept",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("GreentipA", {
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_GreentipA",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["BeachSand"] = 2,
			["MeadowCarroty"] = 1, 
			["JungleDenseMed"] = 3,
			["BeachUnkept"] = 1 
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="BeachSand",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("GreentipB", {
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_GreentipB",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["BeachSand"] = 1, 
			["NoOxMangrove"] = 2, 
			["JungleDense"] = 2 
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="BeachSand",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("HalfGreen", {
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_HalfGreen",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["BeachSand"] = 3,
			["Mangrove"] = 1,
			["JungleDenseMed"] = 1,
			["NoOxMeadow"] = 1
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="BeachUnkept",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("BeachRockyland", {
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_BeachRockyland",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["BeachSand"] = 1,
			["Magma"] = 1
		}, 
		room_bg=GROUND.BEACH,
		background_room="BeachSand",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("LotsaGrass", {
		locks=LOCKS.NONE, --LOCKS.ISLAND1,
		keys_given={KEYS.ISLAND2},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_LotsaGrass",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["NoOxMangrove"] = 1,
			["JungleDenseMed"] = 1,
			["NoOxMeadow"] = 2
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="BeachSand",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("AllBeige", {
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_AllBeige",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["BeachSand"] = 1,
			["Magma"] = 1,
			["NoOxMangrove"] = 1
		}, 
		room_bg=GROUND.BEACH,
		background_room="BeachUnkept",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("BeachMarsh", {
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_BeachMarsh",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["BeachSand"] = 1,
			["TidalMarsh"] = 2
		}, 
		room_bg=GROUND.BEACH,
		background_room="BeachUnkept",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("Verdant", {
		locks=LOCKS.NONE, --LOCKS.ISLAND1,
		keys_given={KEYS.ISLAND2},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_Verdant",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["BeachSand"] = 1,
			["BeachPiggy"] = 1,
			["JungleDenseMed"] = 1
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="BeachSand",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("VerdantMost", {
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_VerdantMost",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["BeachSand"] = 1,
			["BeachSappy"] = 1,
			["JungleDenseMed"] = 1,
			["JungleDenseBerries"] = 1
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="BeachUnkept",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("Vert", {
		locks=LOCKS.NONE, --LOCKS.ISLAND1,
		keys_given={KEYS.ISLAND2},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_Vert",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["BeachSand"] = 1,
			["MeadowCarroty"] = 1,
			["JungleDense"] = 1
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="BeachUnkept",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

--[[AddTask("JungleSparse", {
		locks=LOCKS.ISLAND4,
		keys_given={KEYS.ISLAND5},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_JungleSparse",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["JungleDenseMed"] = 1
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="JungleDenseMed",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("JungleBoth", {
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_JungleBoth",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["JungleSparse"] = 1,
			["JungleDense"] = 1
		}, 
		room_bg=GROUND.JUNGLE,
		background_room={"JungleSparse", "JungleDense"},
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})
]]
AddTask("Florida Timeshare", {
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_Florida Timeshare",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["TidalMarsh"] = 1,
			["JungleDenseMed"] = 1
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="BeachSand",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("JungleSRockyland", {
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		gen_method = "lagoon",
		island=true,
		room_choices={
			["JungleDenseMed"] = 2,
			["Magma"] = 6
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="JungleSparse",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("JungleSSavanna", {
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_JungleSSavanna",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["BareMangrove"] = 1, --BareMangrove includes Ox
			["JungleDenseMed"] = 1
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="JungleSparse",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("JungleBeige", {
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_JungleBeige",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["BareMangrove"] = 1,
			["Magma"] = 1,
			["JungleDenseMed"] = 1
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="NoOxMangrove",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("FullofBees", {
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_FullofBees",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["BeesBeach"] = 2,
			--["SavannaBees"] = 1,
			["JungleDense"] = 1,
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="JungleBees", --was NoOxMangrove and JungleSparse
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("JungleDense", {------THIS IS A GOOD EXAMPLE OF THEMED ISLAND
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["TidalMarsh"] = 1,
			["JungleFlower"] = 1,
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="JungleDense",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("JungleDMarsh", {
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_JungleDMarsh",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["TidalMarsh"] = 1,
			["JungleDense"] = 1
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="TidalMermMarsh",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("JungleDRockyland", {
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		gen_method = "lagoon",
		island=true,
		room_choices={
			["JungleDense"] = 2,
			["Magma"] = 4
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="JungleDense",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("JungleDRockyMarsh", {
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		gen_method = "lagoon",
		island=true,
		room_choices={
			["TidalMarsh"] = 2,
			["JungleDense"] = 4,
			["Magma"] = 2
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="BeachSand",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("JungleDSavanna", {
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_JungleDSavanna",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["BareMangrove"] = 1,
			["JungleDense"] = 1
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="JungleDense",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("JungleDSavRock", {
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_JungleDSavRock",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["BareMangrove"] = 1,
			["Magma"] = 1,
			["JungleDense"] = 1
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="JungleDense", --"NoOxMangrove",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("HotNSticky", {  
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["TidalMarsh"] = 2,
			["JungleDenseMed"] = 1,
			["JungleDense"] = 1
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="JungleDense",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("Marshy", { -- not being called
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["TidalMarsh"] = 1,
			["TidalMermMarsh"] = 1
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="TidalMarsh",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("NoGreen A", {
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_NoGreen A",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["TidalMarsh"] = 1,
			["Magma"] = 1
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="TidalMarsh",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("NoGreen B", {
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_NoGreen B",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["ToxicTidalMarsh"] = 2,
			["Magma"] = 1,
			["BareMangrove"] = 1
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="TidalMarsh",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("Savanna", {
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_Savanna",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["BeachUnkept"] = 1,
			["BareMangrove"] = 1 
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="BeachNoCrabbits",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("Rockyland", {
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_Rockyland",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["Magma"] = 2, --was 1
			["ToxicTidalMarsh"] = math.random(0, 1),
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="BeachUnkept",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("PalmTreeIsland", {
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_PalmTreeIsland",
		crosslink_factor=1,
		make_loop=true,
		island=true,
		room_choices={
			["BeachSinglePalmTree"] = 1,
			["OceanShallowSeaweedBed"] = 1,
			["OceanShallow"] = 1,
		}, 
		room_bg=GROUND.OCEAN_SHALLOW,
		background_room="OceanShallow",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("DoydoyIslandGirl", {
		locks=LOCKS.NONE, --LOCKS.ISLAND1,
		keys_given={KEYS.ISLAND1},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_DoydoyIslandGirl",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
				["JungleSparse"] = 2,
		}, 
		set_pieces={
			{name="DoydoyGirl"}
		},
		room_bg=GROUND.OCEAN_SHALLOW,
		background_room="OceanShallow",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("DoydoyIslandBoy", {
		locks=LOCKS.NONE, --LOCKS.ISLAND1,
		keys_given={KEYS.ISLAND1},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_DoydoyIslandBoy",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
				["JungleSparse"] = 2,
		},
		set_pieces={
			{name="DoydoyBoy"}
		},
		room_bg=GROUND.OCEAN_SHALLOW,
		background_room="OceanShallow",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("IslandCasino", {
		locks=LOCKS.ISLAND4,
		keys_given={KEYS.ISLAND5},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_IslandCasino",
		crosslink_factor=1, --math.random(0,1),
		make_loop=true, --math.random(0, 100) < 50,
		island=true,
		room_choices={
			["BeachPalmCasino"] = 1, -- MR went from 1-5
			["Mangrove"] = math.random(1, 2)
		}, 
		set_pieces={
			{name="Casino"}
		},
		room_bg=GROUND.OCEAN_SHALLOW,
		background_room="OceanShallow",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("KelpForest", {
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_KelpForest",
		crosslink_factor=1,
		make_loop=true,
		island=true,
		room_choices={
			["OceanMediumSeaweedBed"] = math.random(1, 3), --CM was 2, 5
		},
		room_bg=GROUND.OCEAN_MEDIUM,
		background_room="OceanMediumSeaweedBed",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("GreatShoal", {
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_GreatShoal",
		crosslink_factor=1,
		make_loop=true,
		island=true,
		room_choices={
			["OceanMediumShoal"] = math.random(1, 3), --CM was 2, 5
		},
		room_bg=GROUND.OCEAN_MEDIUM,
		background_room="OceanMediumShoal",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("BarrierReef", {
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_BarrierReef",
		crosslink_factor=0,
		make_loop=false,
		island=true,
		room_choices={
			["OceanCoral"] = math.random(1, 3), --CM was 2, 5
		},
		room_bg=GROUND.OCEAN_CORAL,
		background_room="OceanCoral",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

--Test tasks ================================================================================================================================================================
AddTask("IslandParadise", {
		locks=LOCKS.NONE, --LOCKS.ISLAND1,
		keys_given={KEYS.PICKAXE,KEYS.AXE,KEYS.GRASS,KEYS.WOOD,KEYS.TIER1,KEYS.ISLAND2},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_IslandParadise",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["BeachSand"] = 1, --CM + math.random(0, 2),
			["Jungle"] = 2, --CM + math.random(0, 1),
			["MeadowMandrake"] = 1,
			["Magma"] = 1, --CM + math.random(0, 1),
			["JungleDenseVery"] = math.random(0, 1),
			["BareMangrove"] = 1,
		}, 
		room_bg=GROUND.BEACH,
		background_room="BeachGravel",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

--[[AddTask("ThemePigIsland", {
		locks=LOCKS.NONE, --LOCKS.ISLAND1,
		keys_given={KEYS.ISLAND1},
		gen_method = "lagoon",
		room_choices={
			{
				["JunglePigs"] = 1, 
				["JungleDenseMed"] = 2
			},
			{
				["JunglePigGuards"] = 5 + math.random(0, 3), --was 5 +
			},
		},
		set_pieces={
			{name="DefaultPigking"}
		},
		--room_bg=GROUND.IMPASSABLE,
		--background_room="BGImpassable",
		room_bg=GROUND.TIDALMARSH,
		background_room={"BeachSand","BeachPiggy","BeachPiggy","BeachPiggy","TidalMarsh"},
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=0.5,g=0,b=1,a=1}
	})
]]
AddTask("PiggyParadise", {
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3,KEYS.ISLAND4},
		gen_method = "lagoon",
		island=true,
		room_choices={
			["JungleDenseBerries"] = 3,
			["BeachPiggy"] = 5 + math.random(1, 3),
		},
		--[[set_pieces={
			{name="DefaultPigking"}
		},]]
		--room_bg=GROUND.IMPASSABLE,
		--background_room="BGImpassable",
		room_bg=GROUND.TIDALMARSH,
		background_room="BeachPiggy",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=0.5,g=0,b=1,a=1}
	})

AddTask("BeachPalmForest", {
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3,KEYS.ISLAND4},
		island=true,
		room_choices={
			["BeachPalmForest"] = 1 + math.random(0, 3),
		}, 
		--room_bg=GROUND.IMPASSABLE,
		--background_room="BGImpassable",
		room_bg=GROUND.TIDALMARSH,
		background_room="OceanShallow",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=0.5,g=0,b=1,a=1}
	})

AddTask("ThemeMarshCity", {
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		island=true,
		room_choices={
			["TidalMermMarsh"] = 1 + math.random(0, 1),
			["ToxicTidalMarsh"] = 1 + math.random(0, 1),
			["JungleSpidersDense"] = 1, --CM was 3,
		}, 
		--room_bg=GROUND.IMPASSABLE,
		--background_room="BGImpassable",
		room_bg=GROUND.TIDALMARSH,
		background_room="BeachSand","BeachPiggy","TidalMarsh",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=0.5,g=0,b=1,a=1}
	})

AddTask("Spiderland", {
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_Spiderland",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["MagmaSpiders"] = 1,
			["JungleSpidersDense"] = 2,
			["JungleSpiderCity"] = 1 --need to make this jungly instead of using basegame trees and ground
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="BeachGravel", --removed MagmaSpiders
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("IslandJungleBamboozled", {  
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["JungleBamboozled"] = 1 + math.random(0,1), -- added the random bonus room
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="OceanShallow",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("IslandJungleMonkeyHell", {  
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["JungleMonkeyHell"] = 3,
			--["JungleDenseBerries"] =1,
			--["JungleDenseMedHome"] =1,
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="Jungle",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("IslandJungleCritterCrunch", {  
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["JungleCritterCrunch"] = 2,
			["JungleDenseCritterCrunch"] = 1,
			--["Jungle"] = 1,
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="JungleDenseCritterCrunch",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

--[[AddTask("IslandMagmaJungle", {  
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["MagmaForest"] = 1,
			--["JungleClearing"] = 1,
			["Jungle"] = 1,
		}, 
		room_bg=GROUND.JUNGLE,
		--background_room={"JungleClearing"},
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})
]]
AddTask("IslandJungleShroomin", {  
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["JungleShroomin"] = 2,
			--["JungleDenseMed"] = 1,
			--["Jungle"] = 1,
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="JungleDenseMedHome",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("IslandJungleRockyDrop", {  
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		gen_method = "lagoon",
		island=true,
		room_choices={
			["MagmaSpiders"] = 2,
			["JungleRockyDrop"] = 4, 
			["Jungle"] = 2
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="JungleDenseMedHome",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("IslandJungleEyePlant", {  
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["JungleEyeplant"] = 1,
			["TidalMarsh"] = 1,
			--["JungleDense"] = 1,
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="JungleDenseMedHome",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

--[[AddTask("IslandJungleGrassy", {  
		locks=LOCKS.NONE, --LOCKS.ISLAND1,
		keys_given={KEYS.ISLAND2},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["JungleGrassy"] = 1,
			["JungleDenseBerries"] = 1,
			["Jungle"] = 1,
		}, 
		room_bg=GROUND.JUNGLE,
		--background_room={"JungleClearing", "JungleDense"},
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("IslandJungleSappy", {  
		locks=LOCKS.NONE, --LOCKS.ISLAND1,
		keys_given={KEYS.ISLAND2},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["JungleSappy"] = 1,
			["JungleDenseMedHome"] = 1,
			["JungleDenseVery"] = 1,
		}, 
		room_bg=GROUND.JUNGLE,
		--background_room={"JungleClearing", "Jungle"},
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("IslandJungleNoGrass", {  
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["JungleNoGrass"] = 2, --CM + math.random(0, 3),
			--["Jungle"] = 1,
		}, 
		room_bg=GROUND.JUNGLE,
		--background_room={"JungleSparseHome", "JungleDenseMed"},
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	}) ]]

AddTask("IslandJungleBerries", {  
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["JungleDenseBerries"] = 4,
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="Jungle",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("IslandJungleNoBerry", {  
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["JungleNoBerry"] = 3,
			--[[ ["Jungle"] = 1,
			["JungleDenseVery"] = 1, ]]
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="JungleSparse",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("IslandJungleNoRock", {  
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["JungleNoRock"] = 1,
			--["JungleEyeplant"] = 1,
			["TidalMarsh"] = 1,
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="JungleDense",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("IslandJungleNoMushroom", {  
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["JungleNoMushroom"] = 1,
			--["Jungle"] = 1,
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="JungleNoMushroom",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("IslandJungleNoFlowers", {  
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["JungleNoFlowers"] = math.random(3,5),
			--["JungleDenseMedHome"] = 1,
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="Jungle",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("IslandJungleEvilFlowers", {  
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["JungleEvilFlowers"] = 2,
			["ToxicTidalMarsh"] = 1,
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="JungleDenseMed",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

--[[AddTask("IslandJungleMorePalms", {  
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["JungleMorePalms"] = math.random(2,3),
			--["JungleDense"] = 1,
			--["JungleDenseBerries"] = 1,
		}, 
		room_bg=GROUND.JUNGLE,
		--background_room={"JungleSparse", "JungleDense"},
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	}) ]]

AddTask("IslandJungleSkeleton", {  
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["JungleSkeleton"] = 1,
			["JungleDenseMedHome"] = 1,
			["TidalMermMarsh"] = 1,
		}, 
		room_bg=GROUND.JUNGLE,
		background_room="Jungle",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("IslandBeachCrabTown", {  
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["BeachCrabTown"] = math.random(1,3),
		}, 
		room_bg=GROUND.BEACH,
		background_room="BeachSand",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("IslandBeachDunes", {  
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["BeachDunes"] = 1,
			["BeachUnkept"] = 1,
			-- ["BeachSinglePalmTree"] = 1,
		}, 
		room_bg=GROUND.BEACH,
		background_room="BeachUnkept",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("IslandBeachGrassy", {  
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["BeachGrassy"] = 1,
			["BeachPalmForest"]=1,
			["BeachSandHome"]=1,
		}, 
		room_bg=GROUND.BEACH,
		background_room="BeachGravel",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("IslandBeachSappy", {  
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["BeachSappy"] = 1,
			["BeachSand"] = 1,
			["BeachUnkept"] = 1, --was BeachGravel
		}, 
		room_bg=GROUND.BEACH,
		background_room="BeachSandHome",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("IslandBeachRocky", {  
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["BeachRocky"] = 1,
			--["BeachGravel"] = 1,
			["BeachUnkept"] = 1,
			["BeachSandHome"] = 1,
		}, 
		room_bg=GROUND.BEACH,
		background_room="BeachSandHome",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("IslandBeachLimpety", {  
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["BeachLimpety"] = 1,
			["BeachSand"] = 1,
		}, 
		room_bg=GROUND.BEACH,
		background_room="BeachUnkept", --was BeachGravel instead of Unkept
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("IslandBeachForest", {  
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["BeachPalmForest"] = 1,
			["BeachSandHome"] = 1,
			-- ["BeachSinglePalmTree"] = 1,
		}, 
		room_bg=GROUND.BEACH,
		background_room="BeachUnkept",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("IslandBeachSpider", {  
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["BeachSpider"] = 2,
			--["BeachUnkept"] = 1,
		}, 
		room_bg=GROUND.BEACH,
		background_room="BeachUnkept", --was BeachGravel instead of Unkept
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("IslandBeachNoFlowers", {  
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["BeachNoFlowers"] = 1,
			["BeachUnkept"] = 1, --was BeachGravel
		}, 
		room_bg=GROUND.BEACH,
		background_room="BeachSand",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

--[[AddTask("IslandBeachFlowers", {  
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["BeachFlowers"] = 1,
			--["BeachSandHome"] = 1,
		}, 
		room_bg=GROUND.BEACH,
		background_room={"BeachSandHome", "BeachSand"}, --removed BeachGravel
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	}) ]]

AddTask("IslandBeachNoLimpets", {  
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["BeachNoLimpets"] = 1,
		}, 
		room_bg=GROUND.BEACH,
		background_room="BeachSand",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("IslandBeachNoCrabbits", {  
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["BeachNoCrabbits"] = 2,
			--["BeachSinglePalmTree"] = 1, -- this leaves a lot of empty space possibly the size of a whole screen
			--["BeachSandHome"] = 1,
		}, 
		room_bg=GROUND.BEACH,
		background_room="BeachUnkept", --was BeachGravel instead of Unkept
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("IslandMangroveOxBoon", {  
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["MangroveOxBoon"] = 1,
			["MangroveWetlands"] = 1,
			["JungleNoRock"] = 1,
		}, 
		room_bg=GROUND.MANGROVE,
		background_room="BeachGravel",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

--[[AddTask("IslandMeadowWetlands", {  
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["MeadowWetlands"] = 2,
			["BG_Mangrove"] = 1,
			["BareMangrove"] = 1,
			--["NoOxMangrove"] = 1,
		}, 
		room_bg=GROUND.MANGROVE,
		--background_room={"BareMangrove", "Plain"},
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("IslandSavannaFlowery", {  
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["SavannaFlowery"] = 2,
			--["BG_Mangroves"] = 1,
			--["Plain"] = 1,
		}, 
		room_bg=GROUND.MANGROVE,
		--background_room={"BG_Mangroves", "BareMangrove"},
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})
]]
AddTask("IslandMeadowBees", {  
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["MeadowBees"] = 1,
			["NoOxMeadow"] = 1,
		}, 
		room_bg=GROUND.MANGROVE,
		background_room="NoOxMeadow",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("IslandMeadowCarroty", {  
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["MeadowCarroty"] = 1,
			["NoOxMeadow"] = 1,
		}, 
		room_bg=GROUND.MANGROVE,
		--background_room="BareMangrove", --do not use "Plain", it's Savanna
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

--[[AddTask("IslandSavannaSappy", {  
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["SavannaSappy"] = 1,
			--["BareMangrove"] = 1,
			--["BG_Mangroves"] = 1,
		}, 
		room_bg=GROUND.MANGROVE,
		background_room={"SavannaSappy", "SavannaSappy", "SavannaSappy", "BareMangrove", "BeachSappy", "BeachUnkept"}, --was BeachGravel instead of Unkept
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("IslandSavannaSpider", {  
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["SavannaSpider"] = 3,
			--["BareMangrove"] = 1,
			--["NoOxMangrove"] = 1,
			--["Plain"] = 1,
		}, 
		room_bg=GROUND.MANGROVE,
		--background_room={"NoOxMangrove", "BG_Mangroves"},
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("IslandSavannaRocky", {  
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		gen_method = "lagoon",
		room_choices={
			{
				["SavannaRocky"] = 2
			},
			{
				["BeachRocky"] = 3,  --CM was 4
				["BeachSand"] = 3 --CM was 4
			},
		}, 
		room_bg=GROUND.MANGROVE,
		--background_room={"BareMangrove", "Plain"},
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	}) ]]

AddTask("IslandRockyGold", {  
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["MagmaGoldBoon"] = 1,
			["MagmaGold"] = 1,
			["BeachSandHome"] = 1,
		}, 
		room_bg=GROUND.BEACH ,
		background_room="BeachUnkept",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

--[[AddTask("IslandRockyBlueMushroom", {  
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["RockyBlueMushroom"] = 1,
			["MolesvilleRockyIsland"] = 1,
			["BeachSand"] = 1,
		}, 
		room_bg=GROUND.BEACH ,
		--background_room={"BeachGravel", "BeachUnkept"},
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	}) ]]

AddTask("IslandRockyTallBeach", {  
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["MagmaTallBird"] = 1,
			["GenericMagmaNoThreat"] = 1,
			["BeachUnkept"] = 1, --was BeachGravel
		}, 
		room_bg=GROUND.BEACH ,
		background_room="BeachUnkept",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("IslandRockyTallJungle", {  
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["MagmaTallBird"] = 1,
			["BG_Magma"] = 1,
			["JungleDenseMed"] = 1,
		}, 
		room_bg=GROUND.JUNGLE ,
		background_room="JungleSparseHome",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

-- AddTask("Chess", {
		-- locks=LOCKS.ISLAND2,
		-- keys_given={KEYS.ISLAND3},
		-- crosslink_factor=math.random(0,1),
		-- make_loop=math.random(0, 100) < 50,
		island=true,
		-- room_choices={
			-- ["MarbleForest"] = 1,
			-- ["ChessArea"] = 1,
			-- --["ChessMarsh"] = 1,
			-- --["ChessForest"] = 1,
		-- },
		-- colour={r=0.5,g=0.7,b=0.5,a=0.3},						
	-- })

AddTask("PirateBounty", {
		locks=LOCKS.ISLAND4,
		keys_given={KEYS.ISLAND5},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_PirateBounty",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["BeachUnkeptDubloon"] = 1,
		},
		set_pieces={
			{name="Xspot"}
		},
		room_bg=GROUND.BEACH ,
		background_room="OceanShallowSeaweedBed", --removed "OceanShallowReef"
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=0.5,g=0.7,b=0.5,a=0.3},						
	})

AddTask("IslandOasis", {
		locks=LOCKS.ISLAND4,
		keys_given={KEYS.ISLAND5},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_IslandOasis",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["Jungle"] = 1,
		},
		set_pieces={
			{name="JungleOasis"}
		},
		room_bg=GROUND.BEACH ,
		background_room="OceanShallowSeaweedBed", --removed "OceanShallowReef"
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=0.5,g=0.7,b=0.5,a=0.3},						
	})

AddTask("ShellingOut", {
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3, KEYS.ISLAND4},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_ShellingOut",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["BeachShells"] = 2,
		},
		room_bg=GROUND.BEACH ,
		background_room="OceanShallow", --removed "OceanShallowReef"
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=0.5,g=0.7,b=0.5,a=0.3},						
	})

AddTask("Cranium", {
		locks=LOCKS.ISLAND4,
		keys_given={KEYS.ISLAND5},
		gen_method = "lagoon",
		island=true,
		room_choices={
			["BeachSkull"] = 1,
			["Jungle"] = 6,
		},
		--[[treasures = { 
			{name="DeadmansTreasure"} 
		},]]
		room_bg=GROUND.BEACH,
		background_room="BeachSand",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("CrashZone", {
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_CrashZone",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["Jungle"] = 2,
			["MagmaForest"] = 1,
		}, 
		room_bg=GROUND.BEACH,
		background_room="BeachUnkept",
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=1,g=1,b=0,a=1}
	})

AddTask("SharkHome", {
		locks=LOCKS.ISLAND4,
		keys_given={KEYS.ISLAND5},
		--region_id="islandadventures0",
		room_tags={"RoadPoison", "not_mainland"},
		--region_id="ia_SharkHome",
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["BeachSand"] = 1,
		},
		set_pieces={
			{name="SharkHome"}
		},
		room_bg=GROUND.BEACH ,
		background_room="OceanShallowSeaweedBed", --removed "OceanShallowReef"
		--cove_room_name = "Empty_Cove",
		--cove_room_chance = 1,
		--cove_room_max_edges = 2,
		colour={r=0.5,g=0.7,b=0.5,a=0.3},						
	})