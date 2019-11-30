local require = GLOBAL.require
require("map/lockandkey")

local function AddSimpleKeyLock(name)
    table.insert(GLOBAL.KEYS_ARRAY, name)
    GLOBAL.KEYS[name] = #GLOBAL.KEYS_ARRAY
    table.insert(GLOBAL.LOCKS_ARRAY, name)
    GLOBAL.LOCKS[name] = #GLOBAL.KEYS_ARRAY
    GLOBAL.LOCKS_KEYS[GLOBAL.LOCKS[name]] = {GLOBAL.KEYS[name]}
end

AddSimpleKeyLock("ISLAND1")
AddSimpleKeyLock("ISLAND2")
AddSimpleKeyLock("ISLAND3")
AddSimpleKeyLock("ISLAND4")

GLOBAL.FOODSTATE = {
    RAW = 0,
    COOKED = 1,
    DRIED = 2,
    PREPARED = 3,
}

GLOBAL.FOODGROUP.TIGERSHARK = {
    name = "TIGERSHARK",
    types = {
        GLOBAL.FOODTYPE.MEAT,
        GLOBAL.FOODTYPE.VEGGIE,
        GLOBAL.FOODTYPE.GENERIC,
    },
}

GLOBAL.FUELTYPE.MECHANICAL = "MECHANICAL"
GLOBAL.FUELTYPE.TAR = "TAR"

GLOBAL.MATERIALS.BOAT = "boat"
GLOBAL.MATERIALS.LIMESTONE = "limestone"
GLOBAL.MATERIALS.SANDBAGSMALL = "sandbagsmall"

GLOBAL.TOOLACTIONS.HACK = true

GLOBAL.EXIT_DESTINATION = {
    WATER = 1,
    LAND = 2
}

GLOBAL.BOATEQUIPSLOTS = {
    BOAT_SAIL = "sail", 
    BOAT_LAMP = "lamp", 
}

if GLOBAL.rawget(GLOBAL, "GetNextAvaliableCollisionMask") then
    GLOBAL.COLLISION.WAVES = GLOBAL.GetNextAvaliableCollisionMask()
end

GLOBAL.FISH_FARM = {
    SIGN = {
        fish_tropical = "buoy_sign_2",
        purple_grouper = "buoy_sign_3",
        pierrot_fish = "buoy_sign_4",
        neon_quattro = "buoy_sign_5",
    },
    SEEDWEIGHT = {
        fish_tropical = 3,
        purple_grouper = 1,
        pierrot_fish = 1,
        neon_quattro = 1,
    },
}

GLOBAL.CLIMATES = {
    "forest",
    "cave",
    "island",
    "volcano",
}
GLOBAL.CLIMATE_IDS = table.invert(GLOBAL.CLIMATES)

local GROUND = GLOBAL.GROUND

--any turf NOT listed in these two tables is considered to be for the climate FOREST/CAVE(depending on the wether your in a forest/cave shard)
GLOBAL.CLIMATE_TURFS = {
    --TODO, fill in with default entries from the tiles that exist in DST
    FOREST = GLOBAL.setmetatable({}, {__index = function(t, key)
        for k, v in pairs(GLOBAL.CLIMATE_TURFS) do
            if k ~= "FOREST" and k ~= "CAVE" then
                if v[key] then
                    return false
                end
            end
        end
        return true
    end}),
    CAVE = GLOBAL.setmetatable({}, {__index = function(t, key)
        for k, v in pairs(GLOBAL.CLIMATE_TURFS) do
            if k ~= "FOREST" and k ~= "CAVE" then
                if v[key] then
                    return false
                end
            end
        end
        return true
    end}),
    --NEUTRAL is a special case, this means, keep your current climate.
    NEUTRAL = {
        [GROUND.INVALID] = true,
        [GROUND.IMPASSABLE] = true,
        [GROUND.DIRT] = true,
        [GROUND.BEACH] = true,
        [GROUND.RIVER] = true,
    },
    ISLAND = {
        [GROUND.MEADOW] = true,
        [GROUND.JUNGLE] = true,
        [GROUND.TIDALMARSH] = true,
        [GROUND.MAGMAFIELD] = true,
        [GROUND.OCEAN_SHALLOW] = true,
        [GROUND.OCEAN_MEDIUM] = true,
        [GROUND.OCEAN_DEEP] = true,
        [GROUND.OCEAN_CORAL] = true,
        [GROUND.OCEAN_SHIPGRAVEYARD] = true,
        [GROUND.MANGROVE] = true,
    },
    VOLCANO = {
        [GROUND.VOLCANO] = true,
        [GROUND.VOLCANO_ROCK] = true,
        [GROUND.ASH] = true,
    },
}

GLOBAL.CLIMATE_ROOMS = {
	ISLAND = {
		"Beach",
		-- "Jungle", --conflicts with "CaveJungle" in ruins
		"Magma",
		"Mangrove",
		-- "Meadow", --conflicts with several cave mushroom rooms
		"TidalMarsh",
		"Ocean",
	},
}