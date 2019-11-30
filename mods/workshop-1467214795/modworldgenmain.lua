local require = GLOBAL.require

local IsTheFrontEnd = GLOBAL.rawget(GLOBAL, "TheFrontEnd") and GLOBAL.rawget(GLOBAL, "IsInFrontEnd") and GLOBAL.IsInFrontEnd()

-- Unpack the scripts folder
if GLOBAL.IsWorkshopMod(modname) then
	GLOBAL.package.loaded.luapacker = nil
	local LuaPacker = require("luapacker")
	LuaPacker.UnpackForVersion( MODROOT, "scripts", GLOBAL.GetModVersion(modname) )
end

-- Import dependencies.
GLOBAL.package.loaded["librarymanager"] = nil
local AutoSubscribeAndEnableWorkshopMods = require "librarymanager"
if GLOBAL.IsWorkshopMod(modname) then
    AutoSubscribeAndEnableWorkshopMods({"workshop-1378549454", "workshop-1467200656"})
else
    --if the Gitlab Versions dont exist fallback on workshop version
    local GEMCORE = GLOBAL.KnownModIndex:GetModActualName("[API] Gem Core - GitLab Version") or "workshop-1378549454"
    local IAASSETS = GLOBAL.KnownModIndex:GetModActualName(" Island Adventures - Assets - GitLab Ver.") or "workshop-1467200656"
    AutoSubscribeAndEnableWorkshopMods({GEMCORE, IAASSETS})
end


--used by FrontEnd and Generate alike -M
modimport "main/strings" --need a better solution for frontend strings -Z
local iatasks = require "map/levels/ia"
-- require "map/tasksets/ia"

AddLevel(GLOBAL.LEVELTYPE.SURVIVAL, {
	id = "SURVIVAL_SHIPWRECKED_CLASSIC",
	name = GLOBAL.STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELS.SURVIVAL_SHIPWRECKED_CLASSIC,
	desc = GLOBAL.STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELDESC.SURVIVAL_SHIPWRECKED_CLASSIC,
	location = "forest",
	version = 4,
	overrides = {
		task_set = "islandadventures",
		start_location = "islandadventures",
		prefabswaps_start = "classic",
		loop = "always", --"never" in SW, but here it helps keep things square-ish to fit the map better. -M
		branching = "most",
		roads = "never",
		frograin = "never",
		wildfires = "never",

		deerclops = "never",
		bearger = "never",
		-- goosemoose = "never", --unnecessary
		-- dragonfly = "never", --unnecessary
		-- antliontribute = "never", --unnecessary

		perd = "never",
		penguins = "never",
		hunt = "never",

		primaryworldtype = "islandsonly",
	},
	required_setpieces = {
		-- "Sculptures_1",
		-- "Maxwell5",
	},
	-- numrandom_set_pieces = 4,
	numrandom_set_pieces = 0,
	random_set_pieces =
	{
		-- "Sculptures_2",
		-- "Sculptures_3",
		-- "Sculptures_4",
		-- "Sculptures_5",
		-- "Chessy_1",
		-- "Chessy_2",
		-- "Chessy_3",
		-- "Chessy_4",
		-- "Chessy_5",
		-- "Chessy_6",
		-- --"ChessSpot1",
		-- --"ChessSpot2",
		-- --"ChessSpot3",
		-- "Maxwell1",
		-- "Maxwell2",
		-- "Maxwell3",
		-- "Maxwell4",
		-- "Maxwell6",
		-- "Maxwell7",
		-- "Warzone_1",
		-- "Warzone_2",
		-- "Warzone_3",
	},
})

AddStartLocation("islandadventures", {
    name = GLOBAL.STRINGS.UI.SANDBOXMENU.IA_START,
    location = "forest",
    start_setpeice = "IA_Start",
    start_node = "BeachSandHome_Spawn",
})

AddTaskSet("islandadventures", {
	name = GLOBAL.STRINGS.UI.CUSTOMIZATIONSCREEN.TASKSETNAMES.ISLANDADVENTURES,
	location = "forest",
	tasks = {
		"DesertIsland",
		"DoydoyIslandGirl",
		"DoydoyIslandBoy",
		"IslandCasino",
		"PirateBounty",
		"ShellingOut",
		"JungleMarsh",
		"IslandMangroveOxBoon",
		"SharkHome",
		"IslandOasis",
		"HomeIslandSmallBoon_Road",
		-- "VolcanoIsland",
	},
	numoptionaltasks = 0, --22,
	optionaltasks = {
		"BeachBothJungles",
		"IslandParadise",
		"Cranium",
		"BeachJingleS",
		"BeachSavanna",
		"GreentipA",
		"GreentipB",
		"HalfGreen",
		"BeachRockyland",
		"LotsaGrass",
		"CrashZone",
		"BeachJungleD",
		"AllBeige",
		"BeachMarsh",
		"Verdant",
		"Vert",
		"VerdantMost",
		"Florida Timeshare",
		"PiggyParadise",
		"BeachPalmForest",
		"IslandJungleShroomin",
		"IslandJungleNoFlowers",
		"IslandBeachGrassy",
		"IslandBeachRocky",
		"IslandBeachSpider",
		"IslandBeachNoCrabbits",
		"JungleSRockyland",
		"JungleSSavanna",
		"JungleBeige",
		"Spiderland",
		"IslandJungleBamboozled",
		"IslandJungleNoBerry",
		"IslandBeachDunes",
		"IslandBeachSappy",
		"IslandBeachNoLimpets",
		"JungleDense",
		"JungleDMarsh",
		"JungleDRockyland",
		"JungleDRockyMarsh",
		"JungleDSavanna",
		"JungleDSavRock",
		"ThemeMarshCity",
		"IslandJungleCritterCrunch",
		"IslandRockyTallJungle",
		"IslandBeachNoFlowers",
		"NoGreen A",
		"KelpForest",
		"GreatShoal",
		"BarrierReef",
		"HotNSticky",
		"Marshy",
		"Rockyland",
		"IslandJungleMonkeyHell",
		"IslandJungleSkeleton",
		"FullofBees",
		"IslandJungleRockyDrop",
		"IslandJungleEvilFlowers",
		"IslandBeachCrabTown",
		"IslandBeachForest",
		"IslandJungleNoRock",
		"IslandJungleNoMushroom",
		"NoGreen B",
		"Savanna",
		"IslandBeachLimpety",
		"IslandMeadowBees",
		"IslandRockyGold",
		"IslandRockyTallBeach",
		"IslandMeadowCarroty",
	},
	valid_start_tasks = {
		"HomeIslandSmallBoon_Road",
	},
	set_pieces = {
		-- ["ResurrectionStone"] = { count=2, tasks={"Make a pick", "Dig that rock", "Great Plains", "Squeltch", "Beeeees!", "Speak to the king", "Forest hunters" } },
		-- ["ResurrectionStoneSw"] = { count=2, tasks={ "IslandParadise", "VerdantMost", "AllBeige", "NoGreen B", "Florida Timeshare","PiggyParadise","JungleDRockyland","JungleDRockyMarsh","JungleDSavRock","IslandJungleRockyDrop", } },
		["ResurrectionStoneSw"] = { count=2, tasks={"ShellingOut", "JungleMarsh", GLOBAL.unpack(iatasks[2])} },
		-- ["WormholeGrass"] = { count=8, tasks={"Make a pick", "Dig that rock", "Great Plains", "Squeltch", "Beeeees!", "Speak to the king", "Forest hunters", "Befriend the pigs", "For a nice walk", "Kill the spiders", "Killer bees!", "Make a Beehat", "The hunters", "Magic meadow", "Frogs and bugs" } },
		-- ["CaveEntrance"] = { count = 10, tasks={"Make a pick", "Dig that rock", "Great Plains", "Squeltch", "Beeeees!", "Speak to the king classic", "Forest hunters", "Befriend the pigs", "For a nice walk", "Kill the spiders", "Killer bees!", "Make a Beehat", "The hunters", "Magic meadow", "Frogs and bugs"} },
	},
})

if IsTheFrontEnd then
	modimport "modworldgenmain_frontend"
else
	modimport "modworldgenmain_backend"
end
