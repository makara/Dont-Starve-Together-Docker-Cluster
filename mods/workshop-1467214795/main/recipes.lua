--[[
AddRecipe("name", {Ingredient("name", numrequired)}, GLOBAL.RECIPETABS.LIGHT, GLOBAL.TECH.NONE, "placer", min_spacing, b_nounlock, numtogive, "builder_required_tag", nil, "image.tex", testfn)

GLOBAL.AquaticRecipe("name", distance)
]]

local AllRecipes = GLOBAL.AllRecipes
local RECIPETABS = GLOBAL.RECIPETABS
local CUSTOM_RECIPETABS = GLOBAL.CUSTOM_RECIPETABS
local TECH = GLOBAL.TECH
local AquaticRecipe = GLOBAL.AquaticRecipe

local SortBefore = function(a, b)
	AllRecipes[a].sortkey = (not AllRecipes[b].sortkey and AllRecipes[a].sortkey) or AllRecipes[b].sortkey - .99
end
local SortAfter = function(a, b)
	AllRecipes[a].sortkey = (AllRecipes[b].sortkey or AllRecipes[a].sortkey) + .1
end

--LIGHT:

AddRecipe("chiminea", {Ingredient("limestonenugget", 2), Ingredient("sand", 2), Ingredient("log", 2)}, GLOBAL.RECIPETABS.LIGHT, GLOBAL.TECH.NONE, "chiminea_placer", nil, nil, nil, nil, nil, nil, nil)
SortAfter("chiminea","firepit")
AddRecipe("tarlamp", {Ingredient("tar", 1), Ingredient("seashell", 1)}, GLOBAL.RECIPETABS.LIGHT, GLOBAL.TECH.NONE, nil, nil, nil, nil, nil, nil, nil, nil)
SortAfter("tarlamp","torch")
AddRecipe("obsidianfirepit", {Ingredient("obsidian", 8), Ingredient("log", 3)}, GLOBAL.RECIPETABS.LIGHT, GLOBAL.TECH.SCIENCE_TWO, "obsidianfirepit_placer", nil, nil, nil, nil, nil, nil, nil)
SortAfter("obsidianfirepit","coldfirepit")
AddRecipe("bottlelantern", {Ingredient("messagebottleempty", 1), Ingredient("bioluminescence", 2)}, GLOBAL.RECIPETABS.LIGHT, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, nil, nil, nil)
SortAfter("bottlelantern","lantern")
AddRecipe("boat_torch", {Ingredient("twigs", 2), Ingredient("torch", 1)}, GLOBAL.RECIPETABS.LIGHT, GLOBAL.TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, nil, nil, nil)
SortAfter("boat_torch","bottlelantern")
AddRecipe("boat_lantern", {Ingredient("messagebottleempty", 1), Ingredient("twigs", 2), Ingredient("fireflies", 1)}, GLOBAL.RECIPETABS.LIGHT, GLOBAL.TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, nil, nil, nil)
SortAfter("boat_lantern","boat_torch")
AddRecipe("sea_chiminea", {Ingredient("limestonenugget", 6), Ingredient("sand", 4), Ingredient("tar", 6)}, GLOBAL.RECIPETABS.LIGHT, GLOBAL.TECH.NONE, "sea_chiminea_placer", nil, nil, nil, nil, nil, nil, nil)
SortAfter("sea_chiminea","boat_lantern")
GLOBAL.AquaticRecipe("sea_chiminea")

--TOWN:

AddRecipe("waterchest", {Ingredient("boards", 4), Ingredient("tar", 1)}, GLOBAL.RECIPETABS.TOWN, GLOBAL.TECH.NONE, "waterchest_placer", 1, nil, nil, nil, nil, nil, nil)
SortAfter("waterchest","treasurechest")
GLOBAL.AquaticRecipe("waterchest")
AddRecipe("wall_limestone_item", {Ingredient("limestonenugget", 2)}, GLOBAL.RECIPETABS.TOWN, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, 6, nil, nil, nil, nil)
SortAfter("wall_limestone_item","wall_stone_item")
AddRecipe("wall_enforcedlimestone_item", {Ingredient("limestonenugget", 2), Ingredient("seaweed", 4)}, GLOBAL.RECIPETABS.TOWN, GLOBAL.TECH.SCIENCE_ONE, nil, nil, nil, 6, nil, nil, nil, nil)
SortAfter("wall_enforcedlimestone_item","wall_limestone_item")
AddRecipe("wildborehouse", {Ingredient("bamboo", 8), Ingredient("palmleaf", 5), Ingredient("pigskin", 4)}, GLOBAL.RECIPETABS.TOWN, GLOBAL.TECH.SCIENCE_TWO, "wildborehouse_placer", nil, nil, nil, nil, nil, nil, nil)
SortAfter("wildborehouse","pighouse")
AddRecipe("ballphinhouse", {Ingredient("limestonenugget", 4), Ingredient("seaweed", 4), Ingredient("dorsalfin", 2)}, GLOBAL.RECIPETABS.TOWN, GLOBAL.TECH.SCIENCE_ONE, "ballphinhouse_placer", 6, nil, nil, nil, nil, nil, nil)
SortAfter("ballphinhouse","wildborehouse")
GLOBAL.AquaticRecipe("ballphinhouse")
AddRecipe("primeapebarrel", {Ingredient("twigs", 10), Ingredient("cave_banana", 3), Ingredient("poop", 4)}, GLOBAL.RECIPETABS.TOWN, GLOBAL.TECH.SCIENCE_TWO, "primeapebarrel_placer", nil, nil, nil, nil, nil, nil, nil)
SortAfter("primeapebarrel","ballphinhouse")
--AddRecipe("dragoonden", {Ingredient("dragoonheart", 1), Ingredient("rocks", 5), Ingredient("obsidian", 4)}, GLOBAL.RECIPETABS.TOWN, GLOBAL.TECH.SCIENCE_TWO, "dragoonden_placer", nil, nil, nil, nil, nil, nil, nil)
--SortAfter("dragoonden","primeapebarrel")
--TODO: add "ore dictionary" for recipes like this. this will never be added like this, just a reminder.
--AddRecipe("turf_road", {Ingredient("turf_magmafield", 2), Ingredient("boards", 1)}, GLOBAL.RECIPETABS.TOWN, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, nil, nil, nil)
AddRecipe("turf_snakeskin", {Ingredient("snakeskin", 2), Ingredient("fabric", 1)}, GLOBAL.RECIPETABS.TOWN, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, nil, nil, nil)
SortAfter("turf_snakeskin","turf_carpetfloor")
AddRecipe("sandbagsmall_item", {Ingredient("sand", 3), Ingredient("fabric", 2)}, GLOBAL.RECIPETABS.TOWN, GLOBAL.TECH.SCIENCE_ONE, nil, nil, nil, 4, nil, nil, nil, nil)
AddRecipe("sandcastle", {Ingredient("sand", 4), Ingredient("palmleaf", 2), Ingredient("seashell", 3)}, GLOBAL.RECIPETABS.TOWN, GLOBAL.TECH.NONE, "sandcastle_placer", nil, nil, nil, nil, nil, nil, nil)

--FARM:

AddRecipe("mussel_stick", {Ingredient("bamboo", 2), Ingredient("vine", 1), Ingredient("seaweed", 1)}, GLOBAL.RECIPETABS.FARM, GLOBAL.TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, nil, nil, nil)
SortBefore("mussel_stick","slow_farmplot")
AddRecipe("fish_farm", {Ingredient("coconut", 4), Ingredient("rope", 2), Ingredient("silk", 2)}, GLOBAL.RECIPETABS.FARM, GLOBAL.TECH.SCIENCE_ONE, "fish_farm_placer", nil, nil, nil, nil, nil, nil, nil)
GLOBAL.AllRecipes.fish_farm.testfn = function(pt, rot)
    local ents = GLOBAL.TheSim:FindEntities(pt.x, pt.y, pt.z, 5, {"structure"})
    if #ents < 1 then
        return true     
    end
    return false
end
GLOBAL.AquaticRecipe("fish_farm")
AddRecipe("mussel_bed", {Ingredient("mussel", 1), Ingredient("coral", 1)}, GLOBAL.RECIPETABS.FARM, GLOBAL.TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, nil, nil, nil)
if GLOBAL.IA_CONFIG.oldwarly then
GLOBAL.AllRecipes["portablecookpot_item"].ingredients = {Ingredient("limestonenugget", 3), Ingredient("redgem", 1), Ingredient("log", 3)}
GLOBAL.AllRecipes["portableblender_item"].builder_tag = "invalid"
GLOBAL.AllRecipes["portablespicer_item"].builder_tag = "invalid"
end

--SURVIVAL:

--AddRecipe("monkeyball", {Ingredient("snakeskin", 4), Ingredient("cave_banana", 1), Ingredient("rope", 2)}, GLOBAL.RECIPETABS.SURVIVAL, GLOBAL.TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, nil, nil, nil)
AddRecipe("palmleaf_umbrella", {Ingredient("palmleaf", 3), Ingredient("twigs", 4), Ingredient("petals", 6)}, GLOBAL.RECIPETABS.SURVIVAL, GLOBAL.TECH.NONE, nil, nil, nil, nil, nil, nil, nil, nil) 
SortAfter("palmleaf_umbrella","grass_umbrella")
AddRecipe("antivenom", {Ingredient("venomgland", 1), Ingredient("coral", 2), Ingredient("seaweed", 3)}, GLOBAL.RECIPETABS.SURVIVAL, GLOBAL.TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, nil, nil, nil)
SortAfter("antivenom","healingsalve")
AddRecipe("thatchpack", {Ingredient("palmleaf", 4)}, GLOBAL.RECIPETABS.SURVIVAL, GLOBAL.TECH.NONE, nil, nil, nil, nil, nil, nil, nil, nil)
SortBefore("thatchpack","backpack")
AddRecipe("palmleaf_hut", {Ingredient("palmleaf", 4), Ingredient("bamboo", 4), Ingredient("rope", 4)}, GLOBAL.RECIPETABS.SURVIVAL, GLOBAL.TECH.SCIENCE_TWO, "palmleaf_hut_placer", nil, nil, nil, nil, nil, nil, nil)
SortAfter("palmleaf_hut","siestahut")
AddRecipe("tropicalfan", {Ingredient("doydoyfeather", 5), Ingredient("cutreeds", 2), Ingredient("rope", 2)}, GLOBAL.RECIPETABS.SURVIVAL, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, nil, nil, nil)
SortAfter("tropicalfan","featherfan")
AddRecipe("seasack", {Ingredient("shark_gills", 1), Ingredient("vine", 2), Ingredient("seaweed", 5)}, GLOBAL.RECIPETABS.SURVIVAL, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, nil, nil, nil)
SortAfter("seasack","icepack")
AddRecipe("doydoynest", {Ingredient("doydoyfeather", 2), Ingredient("twigs", 8), Ingredient("poop", 4)}, GLOBAL.RECIPETABS.SURVIVAL, GLOBAL.TECH.SCIENCE_TWO, "doydoynest_placer", nil, nil, nil, nil, nil, nil, nil)
if GLOBAL.IA_CONFIG.oldwarly then
AddRecipe("chefpack", {Ingredient("fabric", 1), Ingredient("rope", 1), Ingredient("bluegem", 1)}, GLOBAL.RECIPETABS.SURVIVAL, GLOBAL.TECH.NONE, nil, nil, nil, nil, "masterchef", nil, nil, nil)
GLOBAL.AllRecipes["spicepack"].builder_tag = "invalid"
end

--TOOLS:

AddRecipe("machete", {Ingredient("flint", 3), Ingredient("twigs", 1)}, GLOBAL.RECIPETABS.TOOLS, GLOBAL.TECH.NONE, nil, nil, nil, nil, nil, nil, nil, nil)
SortBefore("machete","pickaxe")
AddRecipe("goldenmachete", {Ingredient("goldnugget", 2), Ingredient("twigs", 4)}, GLOBAL.RECIPETABS.TOOLS, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, nil, nil, nil)
SortAfter("goldenmachete","machete")


--SCIENCE:

AddRecipe("sea_lab", {Ingredient("limestonenugget", 2), Ingredient("sand", 2), Ingredient("transistor", 2)}, GLOBAL.RECIPETABS.SCIENCE, GLOBAL.TECH.SCIENCE_ONE, "sea_lab_placer", nil, nil, nil, nil, nil, nil, nil)
SortAfter("sea_lab","researchlab2")
GLOBAL.AquaticRecipe("sea_lab")
AddRecipe("icemaker", {Ingredient("heatrock", 1), Ingredient("bamboo", 5), Ingredient("transistor", 2)}, GLOBAL.RECIPETABS.SCIENCE, GLOBAL.TECH.SCIENCE_TWO, "icemaker_placer", nil, nil, nil, nil, nil, nil, nil)
--AddRecipe("quackendrill", {Ingredient("quackenbeak", 1), Ingredient("gears", 1), Ingredient("transistor", 2)}, GLOBAL.RECIPETABS.TOOLS, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, nil, nil, nil)

--MAGIC:

AddRecipe("piratihatitator", {Ingredient("parrot", 1), Ingredient("boards", 4), Ingredient("piratehat", 1)}, GLOBAL.RECIPETABS.MAGIC, GLOBAL.TECH.SCIENCE_ONE, "piratihatitator_placer", nil, nil, nil, nil, nil, nil, nil)
SortBefore("piratihatitator","researchlab4")
AddRecipe("ox_flute", {Ingredient("ox_horn", 1), Ingredient("nightmarefuel", 2), Ingredient("rope", 1)}, GLOBAL.RECIPETABS.MAGIC, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, nil, nil, nil)
SortAfter("ox_flute","panflute")

--REFINE

AddRecipe("fabric", {Ingredient("bamboo", 3)}, GLOBAL.RECIPETABS.REFINE, GLOBAL.TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, nil, nil, nil)
AddRecipe("limestonenugget", {Ingredient("coral", 3)}, GLOBAL.RECIPETABS.REFINE, GLOBAL.TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, nil, nil, nil)
AddRecipe("nubbin", {Ingredient("corallarve", 1), Ingredient("limestonenugget", 3)}, GLOBAL.RECIPETABS.REFINE, GLOBAL.TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, nil, nil, nil)
AddRecipe("goldnugget", {Ingredient("dubloon", 3)}, GLOBAL.RECIPETABS.REFINE, GLOBAL.TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, nil, nil, nil)
AddRecipe("ice", {Ingredient("hail_ice", 4)}, GLOBAL.RECIPETABS.REFINE, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, nil, nil, nil)
AddRecipe("messagebottleempty", {Ingredient("sand", 3)}, GLOBAL.RECIPETABS.REFINE, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, nil, nil, nil)

--WAR:

AddRecipe("spear_poison", {Ingredient("venomgland", 1), Ingredient("spear", 1)}, GLOBAL.RECIPETABS.WAR, GLOBAL.TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, nil, nil, nil)
SortAfter("spear_poison","spear")
AddRecipe("armorseashell", {Ingredient("seashell", 10), Ingredient("seaweed", 2), Ingredient("rope", 1)}, GLOBAL.RECIPETABS.WAR, GLOBAL.TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, nil, nil, nil)
SortAfter("armorseashell","armorwood")
AddRecipe("armorlimestone", {Ingredient("limestonenugget", 3), Ingredient("rope", 2)}, GLOBAL.RECIPETABS.WAR, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, nil, nil, nil)
SortAfter("armorlimestone","armormarble")
AddRecipe("armorcactus", {Ingredient("needlespear", 3), Ingredient("armorwood", 1)}, GLOBAL.RECIPETABS.WAR, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, nil, nil, nil)
SortAfter("armorcactus","armorlimestone")
AddRecipe("oxhat", {Ingredient("ox_horn", 1), Ingredient("seashell", 4), Ingredient("rope", 1)}, GLOBAL.RECIPETABS.WAR, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, nil, nil, nil)
SortAfter("oxhat","footballhat")
AddRecipe("blowdart_poison", {Ingredient("cutreeds", 2), Ingredient("venomgland", 1), Ingredient("feather_crow", 1)}, GLOBAL.RECIPETABS.WAR, GLOBAL.TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, nil, nil, nil)
SortAfter("blowdart_poison","blowdart_fire")
AddRecipe("coconade", {Ingredient("coconut", 2), Ingredient("rope", 1), Ingredient("gunpowder", 1)}, GLOBAL.RECIPETABS.WAR, GLOBAL.TECH.SCIENCE_ONE, nil, nil, nil, 2, nil, nil, nil, nil)
AddRecipe("spear_launcher", {Ingredient("jellyfish", 1), Ingredient("bamboo", 3)}, GLOBAL.RECIPETABS.WAR, GLOBAL.TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, nil, nil, nil)
AddRecipe("cutlass", {Ingredient("swordfish_dead", 1), Ingredient("goldnugget", 2), Ingredient("twigs", 1)}, GLOBAL.RECIPETABS.WAR, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, nil, nil, nil)

--DRESS:

AddRecipe("brainjellyhat", {Ingredient("coral_brain", 1), Ingredient("jellyfish", 1), Ingredient("rope", 2)}, GLOBAL.RECIPETABS.DRESS, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, nil, nil, nil)
SortAfter("brainjellyhat","catcoonhat")
AddRecipe("shark_teethhat", {Ingredient("houndstooth", 5), Ingredient("goldnugget", 1)}, GLOBAL.RECIPETABS.DRESS, GLOBAL.TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, nil, nil, nil)
SortAfter("shark_teethhat","brainjellyhat")
AddRecipe("snakeskinhat", {Ingredient("snakeskin", 1), Ingredient("strawhat", 1), Ingredient("boneshard", 1)}, GLOBAL.RECIPETABS.DRESS, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, nil, nil, nil)
SortAfter("snakeskinhat","rainhat")
AddRecipe("armor_snakeskin", {Ingredient("snakeskin", 2), Ingredient("vine", 2), Ingredient("boneshard", 2)}, GLOBAL.RECIPETABS.DRESS, GLOBAL.TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, nil, nil, nil)
SortAfter("armor_snakeskin","raincoat")
AddRecipe("blubbersuit", {Ingredient("blubber", 4), Ingredient("fabric", 2), Ingredient("palmleaf", 2)}, GLOBAL.RECIPETABS.DRESS, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, nil, nil, nil)
SortAfter("blubbersuit","armor_snakeskin")
AddRecipe("tarsuit", {Ingredient("tar", 4), Ingredient("fabric", 2), Ingredient("palmleaf", 2)}, GLOBAL.RECIPETABS.DRESS, GLOBAL.TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, nil, nil, nil)
SortAfter("tarsuit","blubbersuit")
--TODO: add "ore dictionary" for recipes like this. this will never be added like this, just a reminder.
--AddRecipe("hawaiianshirt", {Ingredient("papyrus", 3), Ingredient("silk", 3), Ingredient("petals", 5)}, GLOBAL.RECIPETABS.DRESS, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, nil, nil, nil)
AddRecipe("double_umbrellahat", {Ingredient("shark_gills", 2), Ingredient("umbrella", 1), Ingredient("strawhat", 1)}, GLOBAL.RECIPETABS.DRESS, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, nil, nil, nil)
SortAfter("double_umbrellahat","eyebrellahat")
AddRecipe("armor_windbreaker", {Ingredient("blubber", 2), Ingredient("fabric", 1), Ingredient("rope", 1)}, GLOBAL.RECIPETABS.DRESS, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, nil, nil, nil)
AddRecipe("gashat", {Ingredient("messagebottleempty", 2), Ingredient("coral", 3), Ingredient("jellyfish", 1)}, GLOBAL.RECIPETABS.DRESS, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, nil, nil, nil)
AddRecipe("aerodynamichat", {Ingredient("shark_fin", 2), Ingredient("vine", 2), Ingredient("coconut", 1)}, GLOBAL.RECIPETABS.DRESS, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, nil, nil, nil)

--NAUTICAL:

local RECIPETABS_NAUTICAL = GLOBAL.RECIPETABS.SEAFARING or GLOBAL.CUSTOM_RECIPETABS.NAUTICAL


AddRecipe("boat_lograft", {Ingredient("log", 6), Ingredient("cutgrass", 4)}, RECIPETABS_NAUTICAL, GLOBAL.TECH.NONE, "boat_lograft_placer", nil, nil, nil, nil, nil, nil, nil)
GLOBAL.AquaticRecipe("boat_lograft", 4)
AddRecipe("boat_raft", {Ingredient("bamboo", 4), Ingredient("vine", 3)}, RECIPETABS_NAUTICAL, GLOBAL.TECH.NONE, "boat_raft_placer", nil, nil, nil, nil, nil, nil, nil)
GLOBAL.AquaticRecipe("boat_raft", 4)
AddRecipe("boat_row", {Ingredient("boards", 3), Ingredient("vine", 4)}, RECIPETABS_NAUTICAL, GLOBAL.TECH.SCIENCE_ONE, "boat_row_placer", nil, nil, nil, nil, nil, nil, nil)
GLOBAL.AquaticRecipe("boat_row", 4)
AddRecipe("boat_cargo", {Ingredient("boards", 6), Ingredient("rope", 3)}, RECIPETABS_NAUTICAL, GLOBAL.TECH.SCIENCE_TWO, "boat_cargo_placer", nil, nil, nil, nil, nil, nil, nil)
GLOBAL.AquaticRecipe("boat_cargo", 4)
AddRecipe("boat_armoured", {Ingredient("boards", 6), Ingredient("rope", 3), Ingredient("seashell", 10)}, RECIPETABS_NAUTICAL, GLOBAL.TECH.SCIENCE_TWO, "boat_armoured_placer", nil, nil, nil, nil, nil, nil, nil)
GLOBAL.AquaticRecipe("boat_armoured", 4)
AddRecipe("boat_encrusted", {Ingredient("boards", 6), Ingredient("rope", 3), Ingredient("limestonenugget", 4)}, RECIPETABS_NAUTICAL, GLOBAL.TECH.SCIENCE_TWO, "boat_encrusted_placer", nil, nil, nil, nil, nil, nil, nil)
GLOBAL.AquaticRecipe("boat_encrusted", 4)
AddRecipe("boatrepairkit", {Ingredient("boards", 2), Ingredient("stinger", 2), Ingredient("rope", 2)}, RECIPETABS_NAUTICAL, GLOBAL.TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, nil, nil, nil)
AddRecipe("sail_palmleaf", {Ingredient("bamboo", 2), Ingredient("vine", 2), Ingredient("palmleaf", 4)}, RECIPETABS_NAUTICAL, GLOBAL.TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, nil, nil, nil)
AddRecipe("sail_cloth", {Ingredient("bamboo", 2), Ingredient("rope", 2), Ingredient("fabric", 2)}, RECIPETABS_NAUTICAL, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, nil, nil, nil)
AddRecipe("sail_snakeskin", {Ingredient("log", 4), Ingredient("rope", 2), Ingredient("snakeskin", 2)}, RECIPETABS_NAUTICAL, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, nil, nil, nil)
AddRecipe("sail_feather", {Ingredient("bamboo", 4), Ingredient("rope", 2), Ingredient("doydoyfeather", 4)}, RECIPETABS_NAUTICAL, GLOBAL.TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, nil, nil, nil)
AddRecipe("ironwind", {Ingredient("turbine_blades", 1), Ingredient("transistor", 1), Ingredient("goldnugget", 2)}, RECIPETABS_NAUTICAL, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, nil, nil, nil)
AddRecipe("boatcannon", {Ingredient("coconut", 6), Ingredient("log", 5), Ingredient("gunpowder", 4)}, RECIPETABS_NAUTICAL, GLOBAL.TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, nil, nil, nil)
AddRecipe("seatrap", {Ingredient("palmleaf", 4), Ingredient("messagebottleempty", 3), Ingredient("jellyfish", 1)}, RECIPETABS_NAUTICAL, GLOBAL.TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, nil, nil, nil)
AddRecipe("trawlnet", {Ingredient("bamboo", 2), Ingredient("rope", 3)}, RECIPETABS_NAUTICAL, GLOBAL.TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, nil, nil, nil)
AddRecipe("telescope", {Ingredient("messagebottleempty", 1), Ingredient("pigskin", 1), Ingredient("goldnugget", 1)}, RECIPETABS_NAUTICAL, GLOBAL.TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, nil, nil, nil)
AddRecipe("supertelescope", {Ingredient("telescope", 1), Ingredient("tigereye", 1)}, RECIPETABS_NAUTICAL, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, nil, nil, nil)
AddRecipe("captainhat", {Ingredient("seaweed", 1), Ingredient("boneshard", 1), Ingredient("strawhat", 1)}, RECIPETABS_NAUTICAL, GLOBAL.TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, nil, nil, nil)
AddRecipe("piratehat", {Ingredient("boneshard", 2), Ingredient("silk", 2), Ingredient("rope", 1)}, RECIPETABS_NAUTICAL, GLOBAL.TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, nil, nil, nil)
AddRecipe("armor_lifejacket", {Ingredient("fabric", 2), Ingredient("vine", 2), Ingredient("messagebottleempty", 3)}, RECIPETABS_NAUTICAL, GLOBAL.TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, nil, nil, nil)
AddRecipe("buoy", {Ingredient("messagebottleempty", 1), Ingredient("bioluminescence", 2), Ingredient("bamboo", 4)}, RECIPETABS_NAUTICAL, GLOBAL.TECH.SCIENCE_ONE, "buoy_placer", nil, nil, nil, nil, nil, nil, nil)
GLOBAL.AquaticRecipe("buoy")
--AddRecipe("quackeringram", {Ingredient("quackenbeak", 1), Ingredient("rope", 4), Ingredient("bamboo", 4)}, RECIPETABS_NAUTICAL, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, nil, nil, nil)
AddRecipe("tar_extractor", {Ingredient("coconut", 2), Ingredient("limestonenugget", 4), Ingredient("bamboo", 4)}, RECIPETABS_NAUTICAL, GLOBAL.TECH.WATER_TWO, "tar_extractor_placer", nil, nil, nil, nil, nil, nil, nil)
GLOBAL.AquaticRecipe("tar_extractor")
GLOBAL.AllRecipes.tar_extractor.testfn = function(pt, rot)
    local range = .1
    local tarpits = GLOBAL.TheSim:FindEntities(pt.x, pt.y, pt.z, range, {"tarpit"})

    if #tarpits > 0 then
        for k, v in pairs(tarpits) do
            if not v:HasTag("NOCLICK") then
                return true, false
            end
        end
    end
    
    --Fix an extremely inconvenient bug with left-clicking to build a recipe (does not apply to action buttons) -M
    range = 1
    tarpits = GLOBAL.TheSim:FindEntities(pt.x, pt.y, pt.z, range, {"tarpit"})

    if #tarpits > 0 then
        for k, v in pairs(tarpits) do
            if not v:HasTag("NOCLICK") then
                local newpt = v:GetPosition()
                --realign (editing the actual pt via the table pointer)
                pt.x = newpt.x
                pt.y = newpt.y
                pt.z = newpt.z
                return true, false
            end
        end
    end
    
    return false, false
end
AddRecipe("sea_yard", {Ingredient("tar", 6), Ingredient("limestonenugget", 6), Ingredient("log", 4)}, RECIPETABS_NAUTICAL, GLOBAL.TECH.WATER_TWO, "sea_yard_placer", 4, nil, nil, nil, nil, nil, nil)
GLOBAL.AquaticRecipe("sea_yard")

--UNCRAFTABLE:
--NOTE: These recipes are not supposed to be craftable! This is just so the deconstruction staff works as expected.

AddRecipe("wildborehead", {Ingredient("pigskin", 2), Ingredient("bamboo", 2)}, nil, GLOBAL.TECH.LOST, nil, nil, true)

--WORMWOOD:

AddRecipe("poisonbalm", {Ingredient("livinglog", 1), Ingredient("venomgland", 1)}, GLOBAL.CUSTOM_RECIPETABS.NATURE, GLOBAL.TECH.NONE, nil, nil, nil, nil, "plantkin", nil)


--Recipe("obsidianmachete", {Ingredient("machete", 1), Ingredient("obsidian", 3), Ingredient("dragoonheart", 1)}, RECIPETABS.OBSIDIAN, TECH.OBSIDIAN_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, nil, nil, true)
--Recipe("obsidianaxe", {Ingredient("axe", 1), Ingredient("obsidian", 2), Ingredient("dragoonheart", 1)}, RECIPETABS.OBSIDIAN, TECH.OBSIDIAN_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, nil, nil, true)
--Recipe("spear_obsidian", {Ingredient("spear", 1), Ingredient("obsidian", 3), Ingredient("dragoonheart", 1) }, RECIPETABS.OBSIDIAN, TECH.OBSIDIAN_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, nil, nil, true)
--Recipe("volcanostaff", {Ingredient("firestaff", 1), Ingredient("obsidian", 4), Ingredient("dragoonheart", 1)}, RECIPETABS.OBSIDIAN, TECH.OBSIDIAN_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, nil, nil, true)
--Recipe("armorobsidian", {Ingredient("armorwood", 1), Ingredient("obsidian", 5), Ingredient("dragoonheart", 1)}, RECIPETABS.OBSIDIAN, TECH.OBSIDIAN_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, nil, nil, true)
--Recipe("obsidiancoconade", {Ingredient("coconade", 3), Ingredient("obsidian", 3), Ingredient("dragoonheart", 1)}, RECIPETABS.OBSIDIAN, TECH.OBSIDIAN_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, nil, nil, true, 3)
--Recipe("wind_conch", {Ingredient("obsidian", 4), Ingredient("purplegem", 1), Ingredient("magic_seal", 1)}, RECIPETABS.OBSIDIAN, TECH.OBSIDIAN_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, nil, nil, true)
--Recipe("sail_stick", {Ingredient("obsidian", 2), Ingredient("nightmarefuel", 3), Ingredient("magic_seal", 1)}, RECIPETABS.OBSIDIAN, TECH.OBSIDIAN_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, nil, nil, true)

--[[Full Recipe List Copied from SW:
Recipe("chiminea", {Ingredient("limestone", 2), Ingredient("sand", 2), Ingredient("log", 2)}, RECIPETABS.LIGHT, TECH.NONE, RECIPE_GAME_TYPE.SHIPWRECKED, "chiminea_placer")
Recipe("tarlamp", {Ingredient("seashell", 1), Ingredient("tar", 1)}, RECIPETABS.LIGHT, TECH.NONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("obsidianfirepit", {Ingredient("log", 3), Ingredient("obsidian", 8)}, RECIPETABS.LIGHT, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, "obsidianfirepit_placer")
Recipe("bottlelantern", {Ingredient("messagebottleempty", 1), Ingredient("bioluminescence", 2)}, RECIPETABS.LIGHT, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("boat_torch", {Ingredient("twigs", 2), Ingredient("torch", 1)}, RECIPETABS.LIGHT, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("boat_lantern", {Ingredient("messagebottleempty", 1), Ingredient("twigs", 2), Ingredient("fireflies", 1)}, RECIPETABS.LIGHT, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("sea_chiminea", {Ingredient("sand", 4), Ingredient("tar", 6), Ingredient("limestone", 6)}, RECIPETABS.LIGHT, TECH.NONE, RECIPE_GAME_TYPE.SHIPWRECKED, "sea_chiminea_placer", nil, nil, nil, true)

Recipe("waterchest", {Ingredient("tar", 1), Ingredient("boards", 4)}, RECIPETABS.TOWN, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED, "waterchest_placer", 1, nil, nil, true)
Recipe("wall_limestone_item", {Ingredient("limestone", 2)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, nil, nil, nil, 6)
Recipe("wall_enforcedlimestone_item", {Ingredient("limestone", 2), Ingredient("seaweed", 4)}, RECIPETABS.TOWN, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED, nil, nil, nil, 6)
Recipe("wildborehouse", {Ingredient("bamboo", 8), Ingredient("palmleaf", 5), Ingredient("pigskin", 4)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, "wildborehouse_placer")
Recipe("ballphinhouse", {Ingredient("limestone", 4), Ingredient("seaweed", 4), Ingredient("dorsalfin", 2)}, RECIPETABS.TOWN, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED, "ballphinhouse_placer", 100, nil, nil, true)
Recipe("primeapebarrel", {Ingredient("twigs", 10), Ingredient("cave_banana", 3), Ingredient("poop", 4)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, "primeapebarrel_placer")
Recipe("dragoonden", {Ingredient("dragoonheart", 1), Ingredient("rocks", 5), Ingredient("obsidian", 4)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, "dragoonden_placer")
Recipe("turf_road", {Ingredient("turf_magmafield", 1), Ingredient("boards", 1)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("turf_snakeskinfloor", {Ingredient("snakeskin", 2), Ingredient("fabric", 1)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("sandbagsmall_item", {Ingredient("fabric", 2), Ingredient("sand", 3)}, RECIPETABS.TOWN, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED, nil, nil, nil, 4)
Recipe("sand_castle", {Ingredient("sand", 4), Ingredient("palmleaf", 2), Ingredient("seashell", 3)}, RECIPETABS.TOWN,  TECH.NONE, RECIPE_GAME_TYPE.SHIPWRECKED, "sandcastle_placer")

Recipe("mussel_stick", {Ingredient("bamboo", 2), Ingredient("vine", 1), Ingredient("seaweed", 1)}, RECIPETABS.FARM,  TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("fish_farm", {Ingredient("coconut", 4), Ingredient("rope", 2), Ingredient("silk", 2)}, RECIPETABS.FARM,  TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED, "fish_farm_placer", nil, nil, nil, true)
Recipe("mussel_bed", {Ingredient("mussel", 1), Ingredient("coral", 1)}, RECIPETABS.FARM,  TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)

Recipe("monkeyball", {Ingredient("snakeskin", 2), Ingredient("cave_banana", 1), Ingredient("rope", 2)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("palmleaf_umbrella", {Ingredient("twigs", 4) , Ingredient("palmleaf", 3), Ingredient("petals", 6)}, RECIPETABS.SURVIVAL, TECH.NONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("antivenom", {Ingredient("venomgland", 1), Ingredient("seaweed", 3), Ingredient("coral", 2)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("thatchpack", {Ingredient("palmleaf", 4)}, RECIPETABS.SURVIVAL, TECH.NONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("palmleaf_hut", {Ingredient("palmleaf", 4), Ingredient("bamboo", 4), Ingredient("rope", 3)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, "palmleaf_hut_placer")
Recipe("tropicalfan", {Ingredient("doydoyfeather", 5), Ingredient("cutreeds", 2), Ingredient("rope", 2)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("seasack", {Ingredient("seaweed", 5), Ingredient("vine", 2), Ingredient("shark_gills", 1)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("doydoynest", {Ingredient("twigs", 8), Ingredient("doydoyfeather", 2), Ingredient("poop", 4)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, "doydoynest_placer")

Recipe("machete", {Ingredient("twigs", 1), Ingredient("flint", 3)}, RECIPETABS.TOOLS, TECH.NONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("goldenmachete", {Ingredient("twigs", 4), Ingredient("goldnugget", 2)}, RECIPETABS.TOOLS,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)

Recipe("researchlab5", {Ingredient("limestone", 4), Ingredient("sand", 2), Ingredient("transistor", 2)}, RECIPETABS.SCIENCE, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED, "researchlab5_placer", nil, nil, nil, true)
Recipe("icemaker", {Ingredient("heatrock", 1), Ingredient("bamboo", 5), Ingredient("transistor", 2)}, RECIPETABS.SCIENCE,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, "icemaker_placer")
Recipe("quackendrill", {Ingredient("quackenbeak", 1), Ingredient("gears", 1), Ingredient("transistor", 2)}, RECIPETABS.SCIENCE,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)

Recipe("piratihatitator", {Ingredient("parrot", 1), Ingredient("boards", 4), Ingredient("piratehat", 1)}, RECIPETABS.MAGIC, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED, "piratihatitator_placer")
Recipe("ox_flute", {Ingredient("ox_horn", 1), Ingredient("nightmarefuel", 2), Ingredient("rope", 1)}, RECIPETABS.MAGIC,  TECH.MAGIC_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)

Recipe("limestone", {Ingredient("coral", 3)}, RECIPETABS.REFINE,  TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("nubbin", {Ingredient("limestone", 3), Ingredient("corallarve", 1)}, RECIPETABS.REFINE, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("ice", {Ingredient("hail_ice", 4)}, RECIPETABS.REFINE, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("messagebottleempty", {Ingredient("sand", 3)}, RECIPETABS.REFINE,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)

Recipe("spear_poison", {Ingredient("spear", 1), Ingredient("venomgland", 1) }, RECIPETABS.WAR,  TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("armorseashell", {Ingredient("seashell", 10), Ingredient("seaweed", 2), Ingredient("rope", 1)}, RECIPETABS.WAR,  TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("armorlimestone", {Ingredient("limestone", 3), Ingredient("rope", 2)}, RECIPETABS.WAR, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("armorcactus", {Ingredient("needlespear", 3), Ingredient("armorwood", 1)}, RECIPETABS.WAR, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("oxhat", {Ingredient("ox_horn", 1), Ingredient("seashell", 4), Ingredient("rope", 1)}, RECIPETABS.WAR,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("blowdart_poison", {Ingredient("cutreeds", 2), Ingredient("venomgland", 1), Ingredient("feather_crow", 1) }, RECIPETABS.WAR,  TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("coconade", {Ingredient("coconut", 1), Ingredient("gunpowder", 1), Ingredient("rope", 1)}, RECIPETABS.WAR, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("spear_launcher", {Ingredient("bamboo", 3), Ingredient("jellyfish", 1)}, RECIPETABS.WAR,  TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("cutlass", {Ingredient("dead_swordfish", 1), Ingredient("goldnugget", 2), Ingredient("twigs", 1)}, RECIPETABS.WAR, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)

Recipe("brainjellyhat", {Ingredient("coral_brain", 1), Ingredient("jellyfish", 1), Ingredient("rope", 2)}, RECIPETABS.DRESS, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("shark_teethhat", {Ingredient("houndstooth", 5), Ingredient("goldnugget", 1)}, RECIPETABS.DRESS,  TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("snakeskinhat", {Ingredient("snakeskin", 1), Ingredient("strawhat", 1), Ingredient("boneshard", 1)}, RECIPETABS.DRESS, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, nil, nil, nil, nil, true)
Recipe("armor_snakeskin", {Ingredient("snakeskin", 2), Ingredient("vine", 2), Ingredient("boneshard", 2)}, RECIPETABS.DRESS, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED, nil, nil, nil, nil, true)
Recipe("blubbersuit", {Ingredient("blubber", 4), Ingredient("fabric", 2), Ingredient("palmleaf", 2)}, RECIPETABS.DRESS, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, nil, nil, nil, nil, true)
Recipe("tarsuit", {Ingredient("tar", 4), Ingredient("fabric", 2), Ingredient("palmleaf", 2)}, RECIPETABS.DRESS, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED, nil, nil, nil, nil, true)
Recipe("hawaiianshirt", {Ingredient("papyrus", 3), Ingredient("silk", 3), Ingredient("petals", 5)}, RECIPETABS.DRESS,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("double_umbrellahat", {Ingredient("shark_gills", 2), Ingredient("umbrella", 1), Ingredient("strawhat", 1)}, RECIPETABS.DRESS,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("armor_windbreaker", {Ingredient("blubber", 2), Ingredient("fabric", 1), Ingredient("rope", 1)}, RECIPETABS.DRESS,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED) -- CHECK  THIS
Recipe("gashat", {Ingredient("messagebottleempty", 2), Ingredient("coral", 3), Ingredient("jellyfish", 1)}, RECIPETABS.DRESS,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("aerodynamichat", {Ingredient("shark_fin", 1), Ingredient("vine", 2), Ingredient("coconut", 1)}, RECIPETABS.DRESS,  TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)

Recipe("lograft", {Ingredient("log", 6), Ingredient("cutgrass", 4)}, RECIPETABS.NAUTICAL, TECH.NONE, RECIPE_GAME_TYPE.SHIPWRECKED, "lograft_placer", nil, nil, nil, true, 4)
Recipe("raft", {Ingredient("bamboo", 4), Ingredient("vine", 3)}, RECIPETABS.NAUTICAL, TECH.NONE, RECIPE_GAME_TYPE.SHIPWRECKED, "raft_placer", nil, nil, nil, true, 4)
Recipe("rowboat", {Ingredient("boards", 3), Ingredient("vine", 4)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED, "rowboat_placer", nil, nil, nil, true, 4)
Recipe("cargoboat", {Ingredient("boards", 6), Ingredient("rope", 3)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, "cargoboat_placer", nil, nil, nil, true, 4)
Recipe("armouredboat", {Ingredient("boards", 6), Ingredient("rope", 3), Ingredient("seashell", 10)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, "armouredboat_placer", nil, nil, nil, true, 4)
Recipe("encrustedboat", {Ingredient("boards", 6), Ingredient("rope", 3), Ingredient("limestone", 4)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, "encrustedboat_placer", nil, nil, nil, true, 4)
Recipe("boatrepairkit", {Ingredient("boards", 2), Ingredient("stinger", 2), Ingredient("rope", 2)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("sail", {Ingredient("bamboo", 2), Ingredient("vine", 2), Ingredient("palmleaf", 4)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("clothsail", {Ingredient("bamboo", 2), Ingredient("rope", 2), Ingredient("fabric", 2)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("snakeskinsail", {Ingredient("log", 4), Ingredient("rope", 2), Ingredient("snakeskin", 2)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("feathersail", {Ingredient("bamboo", 2), Ingredient("rope", 2), Ingredient("doydoyfeather", 4)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("ironwind", {Ingredient("turbine_blades", 1), Ingredient("transistor", 1), Ingredient("goldnugget", 2)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("boatcannon", {Ingredient("log", 5), Ingredient("gunpowder", 4), Ingredient("coconut", 6)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("seatrap", {Ingredient("palmleaf", 4), Ingredient("messagebottleempty", 2), Ingredient("jellyfish", 1)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("trawlnet", {Ingredient("rope", 3), Ingredient("bamboo", 2)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("telescope", {Ingredient("messagebottleempty", 1), Ingredient("pigskin", 1), Ingredient("goldnugget", 1) }, RECIPETABS.NAUTICAL, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("supertelescope", {Ingredient("telescope", 1), Ingredient("tigereye", 1), Ingredient("goldnugget", 1) }, RECIPETABS.NAUTICAL, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("captainhat", {Ingredient("seaweed", 1), Ingredient("boneshard", 1), Ingredient("strawhat", 1)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("piratehat", {Ingredient("boneshard", 2), Ingredient("rope", 1), Ingredient("silk", 2)}, RECIPETABS.NAUTICAL,  TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("armor_lifejacket", {Ingredient("fabric", 2), Ingredient("vine", 2), Ingredient("messagebottleempty", 3)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("buoy", {Ingredient("messagebottleempty", 1), Ingredient("bamboo", 4), Ingredient("bioluminescence", 2)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_ONE, RECIPE_GAME_TYPE.SHIPWRECKED, "buoy_placer", nil, nil, nil, true)
Recipe("quackeringram", {Ingredient("quackenbeak", 1), Ingredient("bamboo", 4), Ingredient("rope", 4)}, RECIPETABS.NAUTICAL, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("tar_extractor", {Ingredient("coconut", 2), Ingredient("bamboo", 4), Ingredient("limestone", 4)}, RECIPETABS.NAUTICAL, TECH.WATER_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, "tar_extractor_placer", nil, nil, nil, true)
Recipe("sea_yard", {Ingredient("log", 4), Ingredient("tar", 6), Ingredient("limestone", 6)}, RECIPETABS.NAUTICAL, TECH.WATER_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, "sea_yard_placer", nil, nil, nil, true)

Recipe("surfboard_item", {Ingredient("boards", 1), Ingredient("seashell", 2)}, RECIPETABS.NAUTICAL, TECH.NONE,  RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("woodlegshat", {Ingredient("fabric", 3), Ingredient("boneshard", 4), Ingredient("dubloon", 10)}, RECIPETABS.NAUTICAL, TECH.NONE, RECIPE_GAME_TYPE.SHIPWRECKED)
Recipe("woodlegsboat", {Ingredient("boatcannon", 1), Ingredient("boards", 4), Ingredient("dubloon", 4)}, RECIPETABS.NAUTICAL, TECH.NONE, RECIPE_GAME_TYPE.SHIPWRECKED, "woodlegsboat_placer", nil, nil, nil, true, 4)

Recipe("obsidianmachete", {Ingredient("machete", 1), Ingredient("obsidian", 3), Ingredient("dragoonheart", 1)}, RECIPETABS.OBSIDIAN,  TECH.OBSIDIAN_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, nil, nil, true)
Recipe("obsidianaxe", {Ingredient("axe", 1), Ingredient("obsidian", 2), Ingredient("dragoonheart", 1)}, RECIPETABS.OBSIDIAN,  TECH.OBSIDIAN_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, nil, nil, true)
Recipe("spear_obsidian", {Ingredient("spear", 1), Ingredient("obsidian", 3), Ingredient("dragoonheart", 1) }, RECIPETABS.OBSIDIAN,  TECH.OBSIDIAN_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, nil, nil, true)
Recipe("volcanostaff", {Ingredient("firestaff", 1),  Ingredient("obsidian", 4), Ingredient("dragoonheart", 1)}, RECIPETABS.OBSIDIAN, TECH.OBSIDIAN_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, nil, nil, true)
Recipe("armorobsidian", {Ingredient("armorwood", 1), Ingredient("obsidian", 5), Ingredient("dragoonheart", 1)}, RECIPETABS.OBSIDIAN,  TECH.OBSIDIAN_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, nil, nil, true)
Recipe("obsidiancoconade", {Ingredient("coconade", 3), Ingredient("obsidian", 3), Ingredient("dragoonheart", 1)}, RECIPETABS.OBSIDIAN, TECH.OBSIDIAN_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, nil, nil, true, 3)
Recipe("wind_conch", {Ingredient("obsidian", 4), Ingredient("purplegem", 1), Ingredient("magic_seal", 1)}, RECIPETABS.OBSIDIAN, TECH.OBSIDIAN_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, nil, nil, true)
Recipe("sail_stick", {Ingredient("obsidian", 2), Ingredient("nightmarefuel", 3), Ingredient("magic_seal", 1)}, RECIPETABS.OBSIDIAN, TECH.OBSIDIAN_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, nil, nil, true)
--]]