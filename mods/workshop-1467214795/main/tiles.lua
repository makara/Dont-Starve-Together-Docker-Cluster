GLOBAL.TILE_TYPE = {
    LAND = 0,
    WATER = 1
}

if GLOBAL.IsWorkshopMod(modname) then
    DynamicTileManager.SetWorkshopNonWorkshopLink(modname, "IslandAdventures")
    DynamicTileManager.SetWorkshopNonWorkshopLink(modname, "Island Adventures")
else
    DynamicTileManager.SetWorkshopNonWorkshopLink("workshop-1467214795", modname)
end

local ia_tiles = {
    {
        old_static_id = 90, 
        name = "BEACH",
        texture_name = "beach",
        noise_texture = "ground_noise_sand",
        mini_noise_texture = "mini_beach_noise",
        run_sound="ia_run_sand",
        walk_sound="ia_walk_sand",
        flashpoint_modifier = 0,
        turf_name = "beach",
		-- invatlas = "images/ia_inventoryimages.xml",
		bank_build = "turf_ia",
    },

    {
        old_static_id = 91,
        name = "MEADOW",
        texture_name = "jungle",
        noise_texture = "ground_noise_savannah_detail",
        mini_noise_texture = "mini_savannah_noise",
        runsound="run_tallgrass",
        walksound="walk_tallgrass",
        flashpoint_modifier = 0,
        turf_name = "meadow",
		-- invatlas = "images/ia_inventoryimages.xml",
		bank_build = "turf_ia",
    },

    {
        old_static_id = 92,
        name = "JUNGLE",
        texture_name = "jungle",
        noise_texture = "ground_noise_jungle",
        mini_noise_texture = "mini_jungle_noise",
        runsound="run_woods",
        walksound="walk_woods",
        flashpoint_modifier = 0,
        turf_name = "jungle",
		-- invatlas = "images/ia_inventoryimages.xml",
		bank_build = "turf_ia",
    },

    {
        old_static_id = 93,
        name = "SWAMP",
        texture_name = "swamp",
        noise_texture = "ground_noise_swamp",
        mini_noise_texture = "mini_swamp_noise",
        runsound="run_marsh",
        walksound="walk_marsh",
        flashpoint_modifier = 0,
        turf_name = "swamp",
		-- invatlas = "images/ia_inventoryimages.xml",
		bank_build = "turf_ia",
    },

    {
        old_static_id = 94,
        name = "TIDALMARSH",
        texture_name = "tidalmarsh",
        noise_texture = "ground_noise_tidalmarsh",
        mini_noise_texture = "mini_tidalmarsh_noise",
        runsound="run_marsh",
        walksound="walk_marsh",
        flashpoint_modifier = 0,
        turf_name = "tidalmarsh",
		-- invatlas = "images/ia_inventoryimages.xml",
		bank_build = "turf_ia",
    },

    {
        old_static_id = 95,
        name = "MAGMAFIELD",
        texture_name = "cave",
        noise_texture = "ground_noise_magmafield",
        mini_noise_texture = "mini_magmafield_noise",
        runsound="run_slate",
        walksound="walk_slate",
        snowsound="run_ice",
        flashpoint_modifier = 0,
        turf_name = "magmafield",
		-- invatlas = "images/ia_inventoryimages.xml",
		bank_build = "turf_ia",
    },

    {
        old_static_id = 96,
        name = "VOLCANO_ROCK",
        texture_name = "rocky",
        noise_texture = "ground_volcano_noise",
        mini_noise_texture = "mini_ground_volcano_noise",
        runsound="run_rock",
        walksound="walk_rock",
        snowsound="run_ice",
        flashpoint_modifier = 0,
    },

    {
        old_static_id = 97,
        name = "VOLCANO",
        texture_name = "cave",
        noise_texture = "ground_lava_rock",
        mini_noise_texture = "mini_ground_lava_rock",
        runsound="run_rock",
        walksound="walk_rock",
        snowsound="run_ice",
        flashpoint_modifier = 0,
        turf_name = "volcano",
		-- invatlas = "images/ia_inventoryimages.xml",
		bank_build = "turf_ia",
    },

    {
        old_static_id = 98,
        name = "ASH",
        texture_name = "cave",
        noise_texture = "ground_ash",
        mini_noise_texture = "mini_ash",
        runsound="run_dirt",
        walksound="walk_dirt",
        snowsound="run_ice",
        flashpoint_modifier = 0,
        turf_name = "ash",
		-- invatlas = "images/ia_inventoryimages.xml",
		bank_build = "turf_ia",
    },

    {
        old_static_id = 99,
        name = "SNAKESKIN",
        texture_name = "carpet",
        noise_texture = "noise_snakeskinfloor",
        mini_noise_texture = "noise_snakeskinfloor",
        runsound="run_carpet",
        walksound="walk_carpet",
        flashpoint_modifier = 0,
        turf_name = "snakeskin",
		-- invatlas = "images/ia_inventoryimages.xml",
		bank_build = "turf_ia",
    },

    -------------------------------
    -- WATER
    -- (after Land in order to keep render order consistent)
    -------------------------------

    {
        old_static_id = 100,
        name = "RIVER",
        texture_name = "river",
        noise_texture = "ground_noise_water_river",
        mini_noise_texture = "mini_watershallow_noise",
        flashpoint_modifier = 250,
		--water = true, --R08_ROT_TURNOFTIDES
    },

    {
        old_static_id = 101,
        name = "OCEAN_SHALLOW",
        texture_name = "water_medium",
        noise_texture = "ground_noise_water_shallow",
        mini_noise_texture = "mini_watershallow_noise",
        flashpoint_modifier = 250,
		--water = true, --R08_ROT_TURNOFTIDES
    },

    {
        old_static_id = 102,
        name = "OCEAN_MEDIUM",
        texture_name = "water_medium",
        noise_texture = "ground_noise_water_medium",
        mini_noise_texture = "mini_watermedium_noise",
        flashpoint_modifier = 250,
		--water = true, --R08_ROT_TURNOFTIDES
    },

    {
        old_static_id = 103,
        name = "OCEAN_DEEP",
        texture_name = "water_medium",
        noise_texture = "ground_noise_water_deep",
        mini_noise_texture = "mini_waterdeep_noise",
        flashpoint_modifier = 250,
		--water = true, --R08_ROT_TURNOFTIDES
    },

    {
        old_static_id = 104,
        name = "OCEAN_CORAL",
        texture_name = "water_medium",
        noise_texture = "ground_water_coral",
        mini_noise_texture = "mini_water_coral",
        flashpoint_modifier = 250,
		--water = true, --R08_ROT_TURNOFTIDES
    },

    {
        old_static_id = 105,
        name = "OCEAN_SHIPGRAVEYARD",
        texture_name = "water_medium",
        noise_texture = "ground_water_graveyard",
        mini_noise_texture = "mini_water_graveyard",
        flashpoint_modifier = 250,
		--water = true, --R08_ROT_TURNOFTIDES
    },

    {
        old_static_id = 106,
        name = "MANGROVE",
        texture_name = "water_medium",
        noise_texture = "ground_water_mangrove",
        mini_noise_texture = "mini_water_mangrove",
        flashpoint_modifier = 250,
		--water = true, --R08_ROT_TURNOFTIDES
    },

}

-- Add the ground (including turf items)
for i, tile in ipairs(ia_tiles) do
    DynamicTileManager.AddModTile(modname, tile.name, tile)
end

GLOBAL.GROUND_FLOORING[GROUND.SNAKESKIN] = true

for prefab, filter in pairs(GLOBAL.terrain.filter) do
    if type(filter) == "table" then
        table.insert(filter, GROUND.RIVER)
        table.insert(filter, GROUND.MANGROVE)
        table.insert(filter, GROUND.OCEAN_CORAL)
        table.insert(filter, GROUND.OCEAN_SHALLOW)
        table.insert(filter, GROUND.OCEAN_MEDIUM)
        table.insert(filter, GROUND.OCEAN_DEEP)
        table.insert(filter, GROUND.OCEAN_SHIPGRAVEYARD)
        if table.contains(filter, GROUND.CARPET) then
            table.insert(filter, GROUND.SNAKESKIN)
        end
    end
end

DynamicTileManager.SetTileProperty(GROUND.RIVER, "type", GLOBAL.TILE_TYPE.WATER)
DynamicTileManager.SetTileProperty(GROUND.MANGROVE, "type", GLOBAL.TILE_TYPE.WATER)
DynamicTileManager.SetTileProperty(GROUND.OCEAN_CORAL, "type", GLOBAL.TILE_TYPE.WATER)
DynamicTileManager.SetTileProperty(GROUND.OCEAN_SHALLOW, "type", GLOBAL.TILE_TYPE.WATER)
DynamicTileManager.SetTileProperty(GROUND.OCEAN_MEDIUM, "type", GLOBAL.TILE_TYPE.WATER)
DynamicTileManager.SetTileProperty(GROUND.OCEAN_DEEP, "type", GLOBAL.TILE_TYPE.WATER)
DynamicTileManager.SetTileProperty(GROUND.OCEAN_SHIPGRAVEYARD, "type", GLOBAL.TILE_TYPE.WATER)

--I want to phase out TILE_TYPE, since I want tiles capable of being both land AND water.
DynamicTileManager.SetTileProperty(GROUND.RIVER, "land", false)
DynamicTileManager.SetTileProperty(GROUND.MANGROVE, "land", false)
DynamicTileManager.SetTileProperty(GROUND.OCEAN_CORAL, "land", false)
DynamicTileManager.SetTileProperty(GROUND.OCEAN_SHALLOW, "land", false)
DynamicTileManager.SetTileProperty(GROUND.OCEAN_MEDIUM, "land", false)
DynamicTileManager.SetTileProperty(GROUND.OCEAN_DEEP, "land", false)
DynamicTileManager.SetTileProperty(GROUND.OCEAN_SHIPGRAVEYARD, "land", false)

DynamicTileManager.SetTileProperty(GROUND.RIVER, "water", true)
DynamicTileManager.SetTileProperty(GROUND.MANGROVE, "water", true)
DynamicTileManager.SetTileProperty(GROUND.OCEAN_CORAL, "water", true)
DynamicTileManager.SetTileProperty(GROUND.OCEAN_SHALLOW, "water", true)
DynamicTileManager.SetTileProperty(GROUND.OCEAN_MEDIUM, "water", true)
DynamicTileManager.SetTileProperty(GROUND.OCEAN_DEEP, "water", true)
DynamicTileManager.SetTileProperty(GROUND.OCEAN_SHIPGRAVEYARD, "water", true)

--no ground creep
DynamicTileManager.SetTileProperty(GROUND.RIVER, "groundcreepdisabled", true)
DynamicTileManager.SetTileProperty(GROUND.MANGROVE, "groundcreepdisabled", true)
DynamicTileManager.SetTileProperty(GROUND.OCEAN_CORAL, "groundcreepdisabled", true)
DynamicTileManager.SetTileProperty(GROUND.OCEAN_SHALLOW, "groundcreepdisabled", true)
DynamicTileManager.SetTileProperty(GROUND.OCEAN_MEDIUM, "groundcreepdisabled", true)
DynamicTileManager.SetTileProperty(GROUND.OCEAN_DEEP, "groundcreepdisabled", true)
DynamicTileManager.SetTileProperty(GROUND.OCEAN_SHIPGRAVEYARD, "groundcreepdisabled", true)
--Zarklord: we really need to have _SHORE variants, i think
DynamicTileManager.SetTileProperty(GROUND.RIVER, "isshore", true)
DynamicTileManager.SetTileProperty(GROUND.MANGROVE, "isshore", true)
DynamicTileManager.SetTileProperty(GROUND.OCEAN_CORAL, "isshore", true)
DynamicTileManager.SetTileProperty(GROUND.OCEAN_SHALLOW, "isshore", true)
DynamicTileManager.SetTileProperty(GROUND.OCEAN_SHIPGRAVEYARD, "isshore", true)
-- register as what SW groups in Map:IsBuildableWater
DynamicTileManager.SetTileProperty(GROUND.RIVER, "buildable", true)
DynamicTileManager.SetTileProperty(GROUND.MANGROVE, "buildable", true)
DynamicTileManager.SetTileProperty(GROUND.OCEAN_CORAL, "buildable", true)
DynamicTileManager.SetTileProperty(GROUND.OCEAN_SHALLOW, "buildable", true)

-- ID 1 is for impassable
--Add after mud because that seems to be a relatively constant "last of cave tiles" and before any high priority turf.
DynamicTileManager.ChangeTileRenderOrder(GROUND.BEACH, GROUND.MUD, true)
DynamicTileManager.ChangeTileRenderOrder(GROUND.MEADOW, GROUND.MUD, true)
DynamicTileManager.ChangeTileRenderOrder(GROUND.JUNGLE, GROUND.MUD, true)
DynamicTileManager.ChangeTileRenderOrder(GROUND.SWAMP, GROUND.MUD, true)
DynamicTileManager.ChangeTileRenderOrder(GROUND.TIDALMARSH, GROUND.MUD, true)
DynamicTileManager.ChangeTileRenderOrder(GROUND.MAGMAFIELD, GROUND.MUD, true)
DynamicTileManager.ChangeTileRenderOrder(GROUND.VOLCANO_ROCK, GROUND.MUD, true)
DynamicTileManager.ChangeTileRenderOrder(GROUND.VOLCANO, GROUND.MUD, true)
DynamicTileManager.ChangeTileRenderOrder(GROUND.ASH, GROUND.MUD, true)
--Priority turf
DynamicTileManager.ChangeTileRenderOrder(GROUND.SNAKESKIN, GROUND.CARPET)
--Changing water render order is not advisable, as the
--other tiles can produce visual bugs (grid-shaped bleed-over)
-- DynamicTileManager.ChangeTileRenderOrder(GROUND.RIVER, 2)
-- DynamicTileManager.ChangeTileRenderOrder(GROUND.MANGROVE, 2)
-- DynamicTileManager.ChangeTileRenderOrder(GROUND.OCEAN_CORAL, 2)
-- DynamicTileManager.ChangeTileRenderOrder(GROUND.OCEAN_SHALLOW, 2)
-- DynamicTileManager.ChangeTileRenderOrder(GROUND.OCEAN_MEDIUM, 2)
-- DynamicTileManager.ChangeTileRenderOrder(GROUND.OCEAN_DEEP, 2)
-- DynamicTileManager.ChangeTileRenderOrder(GROUND.OCEAN_SHIPGRAVEYARD, 2)