local require = GLOBAL.require

local IsTheFrontEnd = GLOBAL.rawget(GLOBAL, "TheFrontEnd") and GLOBAL.rawget(GLOBAL, "IsInFrontEnd") and GLOBAL.IsInFrontEnd()


-- Import dependencies.
GLOBAL.package.loaded["librarymanager"] = nil
local AutoSubscribeAndEnableWorkshopMods = require "librarymanager"
if GLOBAL.IsWorkshopMod(modname) then
    AutoSubscribeAndEnableWorkshopMods({"workshop-1467214795"})
else
    --if the Gitlab Versions dont exist fallback on workshop version
    AutoSubscribeAndEnableWorkshopMods({GLOBAL.KnownModIndex:GetModActualName(" Island Adventures - GitLab Ver.") or "workshop-1467214795"})
end

-- if not GLOBAL.CurrentRelease.GreaterOrEqualTo("R08_ROT_TURNOFTIDES") then return end

local taskutil = require "map/tasks"
local AllLayouts = require("map/layouts").Layouts
local GROUND = GLOBAL.GROUND
local LOCKS = GLOBAL.LOCKS
local KEYS = GLOBAL.KEYS

local new_tasks = {
volcano = {
	taskname = "VolcanoIslandRedux",
	taskdef = {
		locks=LOCKS.ISLAND3,
		keys_given={KEYS.ISLAND4},
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["VolcanoAsh"] = 1,
			["VolcanoRock"] = 1,
			["VolcanoObsidian"] = 1,
			["VolcanoObsidianBench"] = 1,
			["VolcanoAltar"] = 1,
		}, 
		room_bg=GROUND.VOLCANO,
		background_room="VolcanoNoise",
		colour={r=1,g=1,b=0,a=1},
	},
},
sinkhole = {
	taskname = "SinkholeIsland",
	taskdef = {
		locks=LOCKS.NONE,
		keys_given={KEYS.ISLAND2},
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices = {
			["CritterDenTropical"] = 1, 
			["MoonbaseEcho"] = 1, 
			["MagmaSinkhole"] = 1,
		},
		room_bg=GROUND.BEACH,
		background_room="BeachNoFlowers",
		colour={r=0,g=0,b=1,a=1},
	},
	roomdefs = {
		CritterDenTropical = {
			colour={r=.5,g=0.6,b=.08,a=.10},
			value = GROUND.BEACH,
			-- tags = {"RoadPoison"},
			contents =  {
				countprefabs = {
						critterlab = 1,
						statueglommer = GetModConfigData("Glommer"),
						rock_moon_shell = 1,
					},
				distributepercent = .3,
				distributeprefabs =
				{
					palmtree = 2,
					fireflies = .4,
					red_mushroom = .05,
					blue_mushroom = .05,
					green_mushroom = .05,
					grass = .1,
					sapling = .6,
					twiggytree = .3,
					flint = .15,
					magmarock = .1,
					magmarock_gold = .1,
				},
			},
		},
		MoonbaseEcho = {
			colour={r=.8,g=0.5,b=.6,a=.50},
			value = GROUND.BEACH,
			tags = { "RoadPoison" },
			contents =  {
				countstaticlayouts={
					["MoonbaseEcho"] = 1
				},
				distributepercent = .2,
				distributeprefabs=
				{
					palmtree = 2,
					fireflies = .4,
					blue_mushroom = .05,
					green_mushroom = .05,
					grass = .1,
					sapling = .6,
					twiggytree = .3,
					flint = .15,
					magmarock = .1,
					magmarock_gold = .1,
				},
			},
		},
		MagmaSinkhole = {
			colour={r=.8,g=0.5,b=.6,a=.50},
			value = GROUND.MAGMAFIELD,
			contents =  {
				countstaticlayouts={
					["CaveEntrance"] = 1
				},
				countprefabs = {
						walrus_camp = GetModConfigData("Walrus"),
					},
				distributepercent = .15,
				distributeprefabs=
				{
					fireflies = .2,
					blue_mushroom = .05,
					green_mushroom = .05,
					sapling = .4,
					twiggytree = .1,
					magmarock = 1,
					magmarock_gold = 1,
					rock1 = .2, --nitre
					rock_flintless = 1, 
					rocks = .5,
					flint = .5,
				},
			},
		},
	},
},
beequeen = {
	taskname = "BeeQueenIsland",
	required_room = "BeeQueenBee",
	taskdef = {
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["MeadowBees"] = 1, 
			["BeachFlowers"] = function() return math.random(1,2) end, 
			["MeadowBeeQueen"] = 1,
		}, 
		room_bg=GROUND.GRASS,
		background_room="OceanShallow",
		colour={r=0,g=1,b=0.3,a=1},
	},
	roomdefs = {
		MeadowBeeQueen = {
			colour={r=.8,g=1,b=.8,a=.50},
			value = GROUND.MEADOW,
			contents =  {
				countprefabs= {
					beequeenhive = 1,
					beehive = 1,
					wasphive = function() return math.random(2) end,
				},
				countstaticlayouts={
					["StagehandGarden"] = 1
				},
				distributepercent = .45,
				distributeprefabs=
				{
					flower = 3, --lowered from 5
					berrybush2 = 0.5,
					berrybush_juicy = 0.25,
					sweet_potato_planted = 0.2,
				},
			},
		},
	},
},
dragonfly = {
{ --dragonfly 1 (Desert)
	taskname = "DragonflyIsland",
	required_room = "DragonflyArena",
	taskdef = {
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["DragonflyArena"] = 1,
			["Badlands"] = math.random(1,2),
		},
		room_bg=GROUND.DIRT,
		background_room="BGBadlands",
		colour={r=1,g=0.6,b=1,a=1},
	},
},
{ --dragonfly 2 (Volcanic)
	taskname = "DragonflyIsland",
	required_room = "DragonflyArenaVolcanic",
	taskdef = {
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["DragonflyArenaVolcanic"] = 1,
			["VolcanoAsh"] = math.random(1,2),
		},
		room_bg=GROUND.VOLCANO,
		background_room="VolcanoNoise",
		colour={r=1,g=1,b=0,a=1},
	},
	roomdefs = {
		DragonflyArenaVolcanic = {
			colour={r=.8,g=1,b=.8,a=.50},
			value = GROUND.VOLCANO,
			contents =  {
				countprefabs= {
					obsidian_workbench = 1,
				},
				countstaticlayouts={
					["DragonflyArenaVolcanic"] = 1
				},
				distributepercent = .075,
				distributeprefabs=
				{
					coffeebush = 0.2,
					rock_obsidian = 0.1,
					rock_charcoal = 0.2,
					dragoonden = 0.05,
				},
			},
		},
	},
},
},
oasis = {
	taskname = "OasisIsland",
	required_room = "LightningBluffOasis",
	taskdef = {
		locks=LOCKS.ISLAND2,
		keys_given={KEYS.ISLAND3},
		room_tags={"RoadPoison", "not_mainland"},
		crosslink_factor=math.random(0,1),
		make_loop=math.random(0, 100) < 50,
		island=true,
		room_choices={
			["LightningBluffAntlion"] = 1,
			["LightningBluffOasis"] = 1,
		},  
		room_bg=GROUND.DIRT,
		background_room="BGLightningBluff",
		colour={r=.05,g=.5,b=.05,a=1},
	},
},
moon1 = {
	tasks = {
		"MoonIsland_IslandShards",
		"MoonIsland_Beach",
		"MoonIsland_Forest",
		"MoonIsland_Baths",
		"MoonIsland_Mine",
	},
	set_pieces = {
		["MoonAltarRockGlass"] = { count = 1, tasks={"MoonIsland_Mine"} },
		["MoonAltarRockIdol"] = { count = 1, tasks={"MoonIsland_Mine"} },
		["MoonAltarRockSeed"] = { count = 1, tasks={"MoonIsland_Mine"} },
		["BathbombedHotspring"] = {count = 1, tasks={"MoonIsland_Baths"}},
	},
},
}


--Do this beforehand because I'm too lazy to figure a "proper way" if it's not needed. -M
AllLayouts.MoonbaseEcho = GLOBAL.deepcopy( AllLayouts.MoonbaseOne )
AllLayouts.MoonbaseEcho.ground_types = {
	GROUND.BEACH,GROUND.BEACH,GROUND.BEACH,GROUND.BEACH,GROUND.BEACH,
	GROUND.MAGMAFIELD,GROUND.MAGMAFIELD, --tiletype 6/7 would be grass/forest, now it's magmafield
}
AllLayouts.MoonbaseEcho.layout.palmtree_burnt = AllLayouts.MoonbaseEcho.layout.evergreen
AllLayouts.MoonbaseEcho.layout.evergreen = nil

AllLayouts.DragonflyArenaVolcanic = GLOBAL.deepcopy( AllLayouts.DragonflyArena )
AllLayouts.DragonflyArenaVolcanic.ground_types = {
	GROUND.VOLCANO,GROUND.VOLCANO,GROUND.VOLCANO,GROUND.VOLCANO,GROUND.VOLCANO,
}
AllLayouts.DragonflyArenaVolcanic.layout.volcano_shrub = AllLayouts.DragonflyArenaVolcanic.layout.marsh_tree
AllLayouts.DragonflyArenaVolcanic.layout.marsh_tree = nil



AddLevelPreInitAny(function(level)
	if level.location == "forest" then
		local used_rooms = {}
		local used_tasks = {}
		for _, taskname in pairs(level.tasks) do
			local task = taskutil.GetTaskByName(taskname)
			if task then
				used_tasks[taskname] = true
				if task.room_choices then
					for roomname, amt in pairs(task.room_choices) do
						used_rooms[roomname] = true --technically speaking, the amt could be 0, but I doubt a mod would set any of the required_room to that
					end
				end
			end
		end

		local iatasks = require "map/levels/ia"
		for k, data in pairs(new_tasks) do
			if GetModConfigData(k) then
				if type(GetModConfigData(k)) == "number" then
					data = data[GetModConfigData(k)] or data
				end
				if data.required_room and used_rooms[data.required_room] then
					print(k, "is not needed, we already have a", data.required_room)
				else
					if data.roomdefs then
						for roomname, roomdata in pairs(data.roomdefs) do
							AddRoom(roomname, roomdata)
						end
					end
					if data.taskdef then
						AddTask(data.taskname, data.taskdef)
					end
					if data.taskname then
						table.insert(iatasks[1], data.taskname)
					end
					if data.tasks then
						for _, taskname in pairs(data.tasks) do
							--have to verify tasks exist (for non-beta players)
							if not used_tasks[taskname] and taskutil.GetTaskByName(taskname) then
								table.insert(level.tasks, taskname)
							end
						end
					end
					if data.set_pieces then
						for spname, spdata in pairs(data.set_pieces) do
							level.set_pieces[spname] = spdata
						end
					end
				end
			end
		end
	end
end)
