--[[
*********************************************************************************************************
Original coding created by: DMCartz
Massively rewritten by: phixius83
MASSIVELY re-rewritten by: DragonWolfLeo & SinisterHumanoid
Date: 012/22/16
Description: Tweak the durability for weapons, armor, staffs, amulets, tools, traps, clothing and lights.
*********************************************************************************************************
]]

-- Store information from configuration menu. 
---------------------------------------------
local TUNING = GLOBAL.TUNING
local WEAPON_DURABILITY = GetModConfigData("WEAPON_DURABILITY")
local ARMOR_DURABILITY = GetModConfigData("ARMOR_DURABILITY")
local STAFF_DURABILITY = GetModConfigData("STAFF_DURABILITY")
local AMULET_DURABILITY = GetModConfigData("AMULET_DURABILITY")
local TOOL_DURABILITY = GetModConfigData("TOOL_DURABILITY")
local GOLD_DURABILITY = GetModConfigData("GOLD_DURABILITY")
local TRAP_DURABILITY = GetModConfigData("TRAP_DURABILITY")
local CLOTHING_DURABILITY = GetModConfigData("CLOTHING_DURABILITY")
local LIGHT_DURABILITY = GetModConfigData("LIGHT_DURABILITY")
local CAMPING_DURABILITY = GetModConfigData("CAMPING_DURABILITY")
local BOOK_DURABILITY = GetModConfigData("BOOK_DURABILITY")
local FOOD_PRESERVATION = GetModConfigData("FOOD_PRESERVATION")
local FOOD_SELECTION = GetModConfigData("FOOD_SELECTION")
local DEBUGOPTIONS = GetModConfigData("DEBUGOPTIONS")

local function GetDurabilitySetting(inst)
	local DURABILITYSETTING = "Default"
	if inst:HasTag("TweakClothes") then
		DURABILITYSETTING = CLOTHING_DURABILITY
	elseif inst:HasTag("TweakWeapon") then
		DURABILITYSETTING = WEAPON_DURABILITY
	elseif inst:HasTag("TweakStaff") then
		DURABILITYSETTING = STAFF_DURABILITY
	elseif inst:HasTag("TweakAmulet") then
		DURABILITYSETTING = AMULET_DURABILITY
	elseif inst:HasTag("TweakTool") then
		DURABILITYSETTING = TOOL_DURABILITY
	elseif inst:HasTag("TweakGold") then
		DURABILITYSETTING = GOLD_DURABILITY
	elseif inst:HasTag("TweakTrap") then
		DURABILITYSETTING = TRAP_DURABILITY
	elseif inst:HasTag("TweakArmor") then
		DURABILITYSETTING = ARMOR_DURABILITY
	elseif inst:HasTag("TweakLight") then
		DURABILITYSETTING = LIGHT_DURABILITY
	elseif inst:HasTag("TweakCamping") then
		DURABILITYSETTING = CAMPING_DURABILITY
	elseif inst:HasTag("TweakBook") then
		DURABILITYSETTING = BOOK_DURABILITY
	elseif inst:HasTag("TweakJerky") then
		DURABILITYSETTING = FOOD_PRESERVATION
	elseif inst:HasTag("TweakFood") then
		DURABILITYSETTING = FOOD_PRESERVATION
	end
	return DURABILITYSETTING
end

--[[
*******************************************************************
Begin code for tuning the durability of each item with percentages!
*******************************************************************
]]

-- Check if the user isn't a client.
if not GLOBAL.TheNet:GetIsClient() then

	-- Weapons
	----------
	
	-- Tweak durability based on tag  
	function AddWeaponTag(inst)
		-- Sets up the Tagging function for weapons
				inst:AddTag("TweakWeapon")
	end
	
    AddPrefabPostInit("batbat", AddWeaponTag)
    AddPrefabPostInit("blowdart_fire", AddWeaponTag)
    AddPrefabPostInit("blowdart_pipe", AddWeaponTag)
    AddPrefabPostInit("blowdart_poison", AddWeaponTag)
    AddPrefabPostInit("blowdart_sleep", AddWeaponTag)
    AddPrefabPostInit("boomerang", AddWeaponTag)
    AddPrefabPostInit("cutlass", AddWeaponTag)
    AddPrefabPostInit("hambat", AddWeaponTag)
    AddPrefabPostInit("harpoon", AddWeaponTag)
    AddPrefabPostInit("javelin", AddWeaponTag)
    AddPrefabPostInit("nightstick", AddWeaponTag)
    AddPrefabPostInit("nightsword", AddWeaponTag)
    AddPrefabPostInit("obsidianmachete", AddWeaponTag)
    AddPrefabPostInit("obsidianspeargun", AddWeaponTag)
    AddPrefabPostInit("peg_leg", AddWeaponTag)
    AddPrefabPostInit("ruins_bat", AddWeaponTag)
    AddPrefabPostInit("scythe", AddWeaponTag)
    AddPrefabPostInit("spear", AddWeaponTag)
    AddPrefabPostInit("spear_obsidian", AddWeaponTag)
    AddPrefabPostInit("spear_poison", AddWeaponTag)
    AddPrefabPostInit("spear_wathgrithr", AddWeaponTag)
    AddPrefabPostInit("speargun", AddWeaponTag)
    AddPrefabPostInit("speargun_poison", AddWeaponTag)
    AddPrefabPostInit("staff_tornado", AddWeaponTag)
    AddPrefabPostInit("tentaclespike", AddWeaponTag)
    AddPrefabPostInit("trident", AddWeaponTag)


	
	-- Armor
	--------
	function AddArmorTag(inst)
		-- Sets up the Tagging function for Armors
				inst:AddTag("TweakArmor")
	end
	
    AddPrefabPostInit("armor_sanity", AddArmorTag)
    AddPrefabPostInit("armordragonfly", AddArmorTag)
    AddPrefabPostInit("armorgrass", AddArmorTag)
    AddPrefabPostInit("armorlimestone", AddArmorTag)
    AddPrefabPostInit("armormarble", AddArmorTag)
    AddPrefabPostInit("armorobsidian", AddArmorTag)
    AddPrefabPostInit("armorruins", AddArmorTag)
    AddPrefabPostInit("armorseashell", AddArmorTag)
    AddPrefabPostInit("armorsnurtleshell", AddArmorTag)
    AddPrefabPostInit("armorwood", AddArmorTag)
    AddPrefabPostInit("beefalo_hide", AddArmorTag)
    AddPrefabPostInit("beehat", AddArmorTag)
    AddPrefabPostInit("footballhat", AddArmorTag)
    AddPrefabPostInit("ruinshat", AddArmorTag)
    AddPrefabPostInit("slurtlehat", AddArmorTag)
    AddPrefabPostInit("wathgrithrhat", AddArmorTag) 
	AddPrefabPostInit("armorskeleton", AddArmorTag)

	
	-- Staffs
	---------
	function AddStaffTag(inst)
		-- Sets up the Tagging function for Staves
				inst:AddTag("TweakStaff")
	end
	
    AddPrefabPostInit("firestaff", AddStaffTag)
    AddPrefabPostInit("greenstaff", AddStaffTag)
    AddPrefabPostInit("icestaff", AddStaffTag)
    AddPrefabPostInit("orangestaff", AddStaffTag)
    AddPrefabPostInit("telestaff", AddStaffTag)
    AddPrefabPostInit("volcanostaff", AddStaffTag)
    AddPrefabPostInit("yellowstaff", AddStaffTag)
	AddPrefabPostInit("opalstaff", AddStaffTag)

	
	-- Amulets
	----------
	function AddAmuletTag(inst)
		-- Sets up the Tagging function for Amulets
			inst:AddTag("TweakAmulet")
	end
	
	AddPrefabPostInit("amulet", AddAmuletTag)
	AddPrefabPostInit("blueamulet", AddAmuletTag)
	AddPrefabPostInit("greenamulet", AddAmuletTag)
	AddPrefabPostInit("yellowamulet", AddAmuletTag)
	AddPrefabPostInit("purpleamulet", AddAmuletTag)
	AddPrefabPostInit("orangeamulet", AddAmuletTag)
	
	-- Tools
	--------
	function AddToolTag(inst)
		-- Sets up the Tagging function for Tools
				inst:AddTag("TweakTool")
	end
	
	AddPrefabPostInit("axe", AddToolTag)
    AddPrefabPostInit("bell", AddToolTag)
    AddPrefabPostInit("boatrepairkit", AddToolTag)
    AddPrefabPostInit("bugnet", AddToolTag)
    AddPrefabPostInit("compass", AddToolTag)
    AddPrefabPostInit("featherfan", AddToolTag)
    AddPrefabPostInit("fertilizer", AddToolTag)
    AddPrefabPostInit("firesuppressor", AddToolTag)
    AddPrefabPostInit("fishingrod", AddToolTag)
    AddPrefabPostInit("hammer", AddToolTag)
    AddPrefabPostInit("horn", AddToolTag)
    AddPrefabPostInit("icemaker", AddToolTag)
    AddPrefabPostInit("machete", AddToolTag)
    AddPrefabPostInit("minifan", AddToolTag)  
    AddPrefabPostInit("monkeyball", AddToolTag)
    AddPrefabPostInit("multitool_axe_pickaxe", AddToolTag)
    AddPrefabPostInit("obsidianaxe", AddToolTag)
    AddPrefabPostInit("panflute", AddToolTag)
    AddPrefabPostInit("pickaxe", AddToolTag)
    AddPrefabPostInit("pitchfork", AddToolTag)
    AddPrefabPostInit("saddle_basic", AddToolTag)
	AddPrefabPostInit("saddle_race", AddToolTag)
    AddPrefabPostInit("saddle_war", AddToolTag)
    AddPrefabPostInit("sail_stick", AddToolTag)
	AddPrefabPostInit("saddlehorn", AddToolTag)
	AddPrefabPostInit("brush", AddToolTag)
    AddPrefabPostInit("seatrap", AddToolTag)
    AddPrefabPostInit("sewing_kit", AddToolTag)
    AddPrefabPostInit("shovel", AddToolTag)
    AddPrefabPostInit("supertelescope", AddToolTag)
    AddPrefabPostInit("telescope", AddToolTag)
    AddPrefabPostInit("tropicalfan", AddToolTag)
    AddPrefabPostInit("whip", AddToolTag)
    AddPrefabPostInit("wind_conch", AddToolTag)
	AddPrefabPostInit("perdfan", AddToolTag)
	
	
	function AddGoldTag(inst)
		-- Sets up the Tagging function for Tools
				inst:AddTag("TweakGold")
	end
	
    AddPrefabPostInit("goldenaxe", AddGoldTag)
    AddPrefabPostInit("goldenmachete", AddGoldTag)
    AddPrefabPostInit("goldenpickaxe", AddGoldTag)
    AddPrefabPostInit("goldenshovel", AddGoldTag)  

	
	-- Specific tweak for heatrock exclusively  (This is necessary because the heatrock durability loss is processed directly on the prefab file.)
	-- Alternative workaround for this would be to modify said prefab file, which may be something we do in the future
	  
	if TOOL_DURABILITY ~= "Default" then

		if TOOL_DURABILITY == "Infinite" then
  
			-- Effectively remove the durability from the heatrock.
			TUNING.HEATROCK_NUMUSES = 100000000
		else                                                                                                
			-- Tweak the uses left of the heatrock.                                                             
			TUNING.HEATROCK_NUMUSES = ( TUNING.HEATROCK_NUMUSES * TOOL_DURABILITY )
		end
	end 
	
	-- Traps
	--------
	function AddTrapTag(inst)
		-- Sets up the Tagging function for Traps
				inst:AddTag("TweakTrap")
	end
	
	AddPrefabPostInit("birdtrap", AddTrapTag)
	AddPrefabPostInit("trap", AddTrapTag)
	AddPrefabPostInit("trap_teeth", AddTrapTag)
	
	-- Clothes
	----------
	function AddClothesTag(inst)
		-- Sets up the Tagging function for Clothes
				inst:AddTag("TweakClothes")
	end
		
    AddPrefabPostInit("aerodynamichat", AddClothesTag)
    AddPrefabPostInit("armor_lifejacket", AddClothesTag)
    AddPrefabPostInit("armor_snakeskin", AddClothesTag)
    AddPrefabPostInit("armor_windbreaker", AddClothesTag)
    AddPrefabPostInit("armorslurper", AddClothesTag)
    AddPrefabPostInit("beargervest", AddClothesTag)
    AddPrefabPostInit("beefalohat", AddClothesTag)
    AddPrefabPostInit("blubbersuit", AddClothesTag)
    AddPrefabPostInit("brainjellyhat", AddClothesTag)
    AddPrefabPostInit("captainhat", AddClothesTag)
    AddPrefabPostInit("catcoonhat", AddClothesTag)
    AddPrefabPostInit("double_umbrellahat", AddClothesTag)
    AddPrefabPostInit("earmuffshat", AddClothesTag)
    AddPrefabPostInit("eyebrellahat", AddClothesTag)
    AddPrefabPostInit("featherhat", AddClothesTag)
    AddPrefabPostInit("flowerhat", AddClothesTag)
    AddPrefabPostInit("gashat", AddClothesTag)
    AddPrefabPostInit("grass_umbrella", AddClothesTag)
    AddPrefabPostInit("hawaiianshirt", AddClothesTag)
    AddPrefabPostInit("icehat", AddClothesTag)
    AddPrefabPostInit("onemanband", AddClothesTag)
    AddPrefabPostInit("palmleaf_umbrella", AddClothesTag)
    AddPrefabPostInit("piratehat", AddClothesTag)
    AddPrefabPostInit("raincoat", AddClothesTag)
    AddPrefabPostInit("rainhat", AddClothesTag)
    AddPrefabPostInit("reflectivevest", AddClothesTag)
    AddPrefabPostInit("shark_teethhat", AddClothesTag)
    AddPrefabPostInit("snakeskinhat", AddClothesTag)
    AddPrefabPostInit("spiderhat", AddClothesTag)
    AddPrefabPostInit("strawhat", AddClothesTag)
    AddPrefabPostInit("sweatervest", AddClothesTag)
    AddPrefabPostInit("tophat", AddClothesTag)
    AddPrefabPostInit("trunkvest_summer", AddClothesTag)
    AddPrefabPostInit("trunkvest_winter", AddClothesTag)
    AddPrefabPostInit("umbrella", AddClothesTag)
    AddPrefabPostInit("walrushat", AddClothesTag)
    AddPrefabPostInit("watermelonhat", AddClothesTag)
    AddPrefabPostInit("winterhat", AddClothesTag)
	AddPrefabPostInit("hivehat", AddClothesTag)
	AddPrefabPostInit("dragonheadhat", AddClothesTag)
	AddPrefabPostInit("dragonbodyhat", AddClothesTag)
	AddPrefabPostInit("dragontailhat", AddClothesTag)
	AddPrefabPostInit("deserthat", AddClothesTag)
	AddPrefabPostInit("goggleshat", AddClothesTag)

	
	-- Light
	--------
	function AddLightTag(inst)
		-- Sets up the Tagging function for Light Sources
				inst:AddTag("TweakLight")
	end
	
	
	
    AddPrefabPostInit("boat_lantern", AddLightTag)
    AddPrefabPostInit("boat_torch", AddLightTag)
    AddPrefabPostInit("bottlelantern", AddLightTag)
    AddPrefabPostInit("lantern", AddLightTag)
    AddPrefabPostInit("lighter", AddLightTag)
    AddPrefabPostInit("minerhat", AddLightTag)
    AddPrefabPostInit("molehat", AddLightTag)
    AddPrefabPostInit("nightlight", AddLightTag)
    AddPrefabPostInit("pumpkin_lantern", AddLightTag)
    AddPrefabPostInit("torch", AddLightTag)
	AddPrefabPostInit("redlantern", AddLightTag)
	AddPrefabPostInit("thurible", AddLightTag)
	
	-- Camping
	----------
	function AddCampingTag(inst)
		-- Sets up the Tagging function for Camping
				inst:AddTag("TweakCamping")
	end

	function AddPitTag(inst)
		-- Sets up the Tagging function to identify Fire Pits.  This is so that when infinite is set, they can decay past massive blaze, but not below regular fire
			inst:AddTag("TweakPit")
	end
		
    AddPrefabPostInit("bedroll_furry", AddCampingTag)
    AddPrefabPostInit("bedroll_straw", AddCampingTag)
    AddPrefabPostInit("campfire", AddCampingTag)
    AddPrefabPostInit("chiminea", AddCampingTag)
    AddPrefabPostInit("coldfire", AddCampingTag)
    AddPrefabPostInit("coldfirepit", AddCampingTag)
    AddPrefabPostInit("deluxe_firepit", AddCampingTag)
    AddPrefabPostInit("endo_firepit", AddCampingTag)
    AddPrefabPostInit("endothermic_torch", AddCampingTag)
    AddPrefabPostInit("firepit", AddCampingTag)
    AddPrefabPostInit("heat_star", AddCampingTag)
    AddPrefabPostInit("ice_star", AddCampingTag)
    AddPrefabPostInit("obsidianfirepit", AddCampingTag)
    AddPrefabPostInit("palmleaf_hut", AddCampingTag)
    AddPrefabPostInit("siestahut", AddCampingTag)
    AddPrefabPostInit("tent", AddCampingTag)
    AddPrefabPostInit("campfire", AddPitTag)
    AddPrefabPostInit("chiminea", AddPitTag)
    AddPrefabPostInit("coldfire", AddPitTag)
    AddPrefabPostInit("coldfirepit", AddPitTag)
    AddPrefabPostInit("deluxe_firepit", AddPitTag)
    AddPrefabPostInit("endo_firepit", AddPitTag)
    AddPrefabPostInit("endothermic_torch", AddPitTag)
    AddPrefabPostInit("firepit", AddPitTag)
    AddPrefabPostInit("heat_star", AddPitTag)
    AddPrefabPostInit("ice_star", AddPitTag)
    AddPrefabPostInit("obsidianfirepit", AddPitTag)
	AddPrefabPostInit("redlantern", AddCampingTag)
	
	
	-- Librarian's Books
	----------
	function AddBookTag(inst)
		-- Sets up the Tagging function for Camping
				inst:AddTag("TweakBook")
	end
	
	AddPrefabPostInit("book_birds", AddBookTag)
	AddPrefabPostInit("book_brimstone", AddBookTag)
	AddPrefabPostInit("book_gardening", AddBookTag)
	AddPrefabPostInit("book_sleep", AddBookTag)
	AddPrefabPostInit("book_tentacles", AddBookTag)
	
	-- Dried Meats
	----------
	function AddJerkyTag(inst)
		-- Sets up the Tagging function for preserved foods
				inst:AddTag("TweakJerky")
	end
	
    AddPrefabPostInit("jellyjerky", AddJerkyTag)
    AddPrefabPostInit("meat_dried", AddJerkyTag)
    AddPrefabPostInit("monstermeat_dried", AddJerkyTag)
    AddPrefabPostInit("seaweed_dried", AddJerkyTag)
    AddPrefabPostInit("smallmeat_dried", AddJerkyTag)
	
	
	-- All Other Food
	----------
	function AddFoodTag(inst)
		-- Sets up the Tagging function for preserved foods
				inst:AddTag("TweakFood")
	end
	
	if FOOD_SELECTION == "All" then			-- Check to see if we're applying this tweak to all foods, and if so, go nuts
    AddPrefabPostInit("acorn_cooked", AddFoodTag)
    AddPrefabPostInit("baconeggs", AddFoodTag)
    AddPrefabPostInit("bananapop", AddFoodTag)
    AddPrefabPostInit("batwing", AddFoodTag)
    AddPrefabPostInit("batwing_cooked", AddFoodTag)
    AddPrefabPostInit("berries", AddFoodTag)
    AddPrefabPostInit("berries_cooked", AddFoodTag)
    AddPrefabPostInit("berries_juicy", AddFoodTag)
    AddPrefabPostInit("berries_juicy_cooked", AddFoodTag)	
    AddPrefabPostInit("bird_egg", AddFoodTag)
    AddPrefabPostInit("bird_egg_cooked", AddFoodTag)
    AddPrefabPostInit("bisque", AddFoodTag)
    AddPrefabPostInit("blue_cap", AddFoodTag)
    AddPrefabPostInit("blue_cap_cooked", AddFoodTag)
    AddPrefabPostInit("bonestew", AddFoodTag)
    AddPrefabPostInit("butter", AddFoodTag)
    AddPrefabPostInit("butterflymuffin", AddFoodTag)
    AddPrefabPostInit("butterflywings", AddFoodTag)
    AddPrefabPostInit("cactus_flower", AddFoodTag)
    AddPrefabPostInit("cactus_meat", AddFoodTag)
    AddPrefabPostInit("cactus_meat_cooked", AddFoodTag)
    AddPrefabPostInit("californiaroll", AddFoodTag)
    AddPrefabPostInit("carrot", AddFoodTag)
    AddPrefabPostInit("carrot_cooked", AddFoodTag)
    AddPrefabPostInit("carrot_seeds", AddFoodTag)
    AddPrefabPostInit("cave_banana", AddFoodTag)
    AddPrefabPostInit("cave_banana_cooked", AddFoodTag)
    AddPrefabPostInit("ceviche", AddFoodTag)
    AddPrefabPostInit("coconut", AddFoodTag)
    AddPrefabPostInit("coconut_cooked", AddFoodTag)
    AddPrefabPostInit("coffee", AddFoodTag)
    AddPrefabPostInit("cookedmeat", AddFoodTag)
    AddPrefabPostInit("cookedmonstermeat", AddFoodTag)
    AddPrefabPostInit("cookedsmallmeat", AddFoodTag)
    AddPrefabPostInit("coral_brain", AddFoodTag)
    AddPrefabPostInit("corn", AddFoodTag)
    AddPrefabPostInit("corn_cooked", AddFoodTag)
    AddPrefabPostInit("corn_seeds", AddFoodTag)
    AddPrefabPostInit("cutlichen", AddFoodTag)
    AddPrefabPostInit("dead_swordfish", AddFoodTag)
    AddPrefabPostInit("dragonfruit", AddFoodTag)
    AddPrefabPostInit("dragonfruit_cooked", AddFoodTag)
    AddPrefabPostInit("dragonfruit_seeds", AddFoodTag)
    AddPrefabPostInit("dragonpie", AddFoodTag)
    AddPrefabPostInit("dragoonheart", AddFoodTag)
    AddPrefabPostInit("drumstick", AddFoodTag)
    AddPrefabPostInit("drumstick_cooked", AddFoodTag)
    AddPrefabPostInit("durian", AddFoodTag)
    AddPrefabPostInit("durian_cooked", AddFoodTag)
    AddPrefabPostInit("durian_seeds", AddFoodTag)
    AddPrefabPostInit("eel", AddFoodTag)
    AddPrefabPostInit("eel_cooked", AddFoodTag)
    AddPrefabPostInit("eggplant", AddFoodTag)
    AddPrefabPostInit("eggplant_cooked", AddFoodTag)
    AddPrefabPostInit("eggplant_seeds", AddFoodTag)
    AddPrefabPostInit("fish", AddFoodTag)
    AddPrefabPostInit("fish_cooked", AddFoodTag)
    AddPrefabPostInit("fish_med", AddFoodTag)
    AddPrefabPostInit("fish_med_cooked", AddFoodTag)
    AddPrefabPostInit("fish_raw", AddFoodTag)
    AddPrefabPostInit("fish_raw_small", AddFoodTag)
    AddPrefabPostInit("fish_raw_small_cooked", AddFoodTag)
    AddPrefabPostInit("fishsticks", AddFoodTag)
    AddPrefabPostInit("fishtacos", AddFoodTag)
    AddPrefabPostInit("flowersalad", AddFoodTag)
    AddPrefabPostInit("foliage", AddFoodTag)
    AddPrefabPostInit("frogglebunwich", AddFoodTag)
    AddPrefabPostInit("froglegs", AddFoodTag)
    AddPrefabPostInit("froglegs_cooked", AddFoodTag)
    AddPrefabPostInit("fruitmedley", AddFoodTag)
    AddPrefabPostInit("goatmilk", AddFoodTag)
    AddPrefabPostInit("green_cap", AddFoodTag)
    AddPrefabPostInit("green_cap_cooked", AddFoodTag)
    AddPrefabPostInit("guacamole", AddFoodTag)
    AddPrefabPostInit("hail_ice", AddFoodTag)
    AddPrefabPostInit("honey", AddFoodTag)
    AddPrefabPostInit("honeyham", AddFoodTag)
    AddPrefabPostInit("honeynuggets", AddFoodTag)
    AddPrefabPostInit("hotchili", AddFoodTag)
    AddPrefabPostInit("ice", AddFoodTag)
    AddPrefabPostInit("icecream", AddFoodTag)
    AddPrefabPostInit("jammypreserves", AddFoodTag)
    AddPrefabPostInit("jellyfish_cooked", AddFoodTag)
    AddPrefabPostInit("jellyfish_dead", AddFoodTag)
    AddPrefabPostInit("jellyopop", AddFoodTag)
    AddPrefabPostInit("kabobs", AddFoodTag)
    AddPrefabPostInit("lightbulb", AddFoodTag)
    AddPrefabPostInit("limpets", AddFoodTag)
    AddPrefabPostInit("limpets_cooked", AddFoodTag)
    AddPrefabPostInit("lobsterbisque", AddFoodTag)
    AddPrefabPostInit("lobsterdinner", AddFoodTag)
    AddPrefabPostInit("mandrakesoup", AddFoodTag)
    AddPrefabPostInit("meat", AddFoodTag)
    AddPrefabPostInit("meatballs", AddFoodTag)
    AddPrefabPostInit("monsterlasagna", AddFoodTag)
    AddPrefabPostInit("monstermeat", AddFoodTag)
    AddPrefabPostInit("mussel", AddFoodTag)
    AddPrefabPostInit("mussel_cooked", AddFoodTag)
    AddPrefabPostInit("perogies", AddFoodTag)
    AddPrefabPostInit("petals", AddFoodTag)
    AddPrefabPostInit("petals_evil", AddFoodTag)
    AddPrefabPostInit("plantmeat", AddFoodTag)
    AddPrefabPostInit("plantmeat_cooked", AddFoodTag)
    AddPrefabPostInit("pomegranate", AddFoodTag)
    AddPrefabPostInit("pomegranate_cooked", AddFoodTag)
    AddPrefabPostInit("pomegranate_seeds", AddFoodTag)
    AddPrefabPostInit("powcake", AddFoodTag)
    AddPrefabPostInit("pumpkin", AddFoodTag)
    AddPrefabPostInit("pumpkin_cooked", AddFoodTag)
    AddPrefabPostInit("pumpkin_seeds", AddFoodTag)
    AddPrefabPostInit("pumpkincookie", AddFoodTag)
    AddPrefabPostInit("ratatouille", AddFoodTag)
    AddPrefabPostInit("red_cap", AddFoodTag)
    AddPrefabPostInit("red_cap_cooked", AddFoodTag)
    AddPrefabPostInit("seafoodgumbo", AddFoodTag)
    AddPrefabPostInit("seaweed", AddFoodTag)
    AddPrefabPostInit("seaweed_cooked", AddFoodTag)
    AddPrefabPostInit("seeds", AddFoodTag)
    AddPrefabPostInit("seeds_cooked", AddFoodTag)
    AddPrefabPostInit("shark_fin", AddFoodTag)
    AddPrefabPostInit("sharkfinsoup", AddFoodTag)
    AddPrefabPostInit("smallmeat", AddFoodTag)
    AddPrefabPostInit("stuffedeggplant", AddFoodTag)
    AddPrefabPostInit("surfnturf", AddFoodTag)
    AddPrefabPostInit("sweet_potato", AddFoodTag)
    AddPrefabPostInit("sweet_potato_cooked", AddFoodTag)
    AddPrefabPostInit("sweet_potato_seeds", AddFoodTag)
    AddPrefabPostInit("taffy", AddFoodTag)
    AddPrefabPostInit("tallbirdegg", AddFoodTag)
    AddPrefabPostInit("tallbirdegg_cooked", AddFoodTag)
    AddPrefabPostInit("trailmix", AddFoodTag)
    AddPrefabPostInit("tropical_fish", AddFoodTag)
    AddPrefabPostInit("trunk_cooked", AddFoodTag)
    AddPrefabPostInit("trunk_summer", AddFoodTag)
    AddPrefabPostInit("trunk_winter", AddFoodTag)
    AddPrefabPostInit("turkeydinner", AddFoodTag)
    AddPrefabPostInit("unagi", AddFoodTag)
    AddPrefabPostInit("waffles", AddFoodTag)
    AddPrefabPostInit("watermelon", AddFoodTag)
    AddPrefabPostInit("watermelon_cooked", AddFoodTag)
    AddPrefabPostInit("watermelon_seeds", AddFoodTag)
    AddPrefabPostInit("watermelonicle", AddFoodTag)
    AddPrefabPostInit("wetgoop", AddFoodTag)
    AddPrefabPostInit("wormlight", AddFoodTag)
	AddPrefabPostInit("blue_mushroomhat", AddFoodTag)
	AddPrefabPostInit("red_mushroomhat", AddFoodTag)
	AddPrefabPostInit("green_mushroomhat", AddFoodTag)
	AddPrefabPostInit("wormlight_lesser", AddFoodTag)
	end
	
	-- Shipwrecked Together Mod Items
	AddPrefabPostInit("donarmorblubbersuit", AddClothesTag)
	AddPrefabPostInit("donarmorlifejacket", AddClothesTag)
	AddPrefabPostInit("donarmorlimestone", AddArmorTag)
	AddPrefabPostInit("donarmorobsidian", AddArmorTag)
	AddPrefabPostInit("donarmorseashell", AddArmorTag)
	AddPrefabPostInit("donarmorsnakeskin", AddClothesTag)
	AddPrefabPostInit("donarmorwindbreaker", AddClothesTag)
	AddPrefabPostInit("donbottlelantern", AddLightTag)
	AddPrefabPostInit("doncactusarmour", AddArmorTag)
	AddPrefabPostInit("donchiminea", AddCampingTag)
	AddPrefabPostInit("donchiminea", AddPitTag)
	AddPrefabPostInit("doncoconut", AddFoodTag)
	AddPrefabPostInit("doncutlass", AddWeaponTag)
	AddPrefabPostInit("donharpoon", AddWeaponTag)
	AddPrefabPostInit("donhataerodynamic", AddClothesTag)
	AddPrefabPostInit("donhatbrainjelly", AddClothesTag)
	AddPrefabPostInit("donhatcaptain", AddClothesTag)
	AddPrefabPostInit("donhatdoubleumbrella", AddClothesTag)
	AddPrefabPostInit("donhatgasmask", AddClothesTag)
	AddPrefabPostInit("donhathornedhelmet", AddClothesTag)
	AddPrefabPostInit("donhatpirate", AddClothesTag)
	AddPrefabPostInit("donhatsharkteeth", AddClothesTag)
	AddPrefabPostInit("donhatsnakeskin", AddClothesTag)
	AddPrefabPostInit("donmachete", AddToolTag)
	AddPrefabPostInit("donobsidianspear", AddWeaponTag)
	AddPrefabPostInit("donsurfboard", AddBoatTag)
	AddPrefabPostInit("dontrident", AddWeaponTag)
	AddPrefabPostInit("dontropicalparasol", AddToolTag)

end


---------------------------------------------------------
-- ARMOR
AddComponentPostInit("armor", function(Armor, inst)
	local TakeDamage_prev = Armor.TakeDamage
	function Armor:TakeDamage(damage_amount, ...)
		--[[MODNOTE: This section deals with the update math, which is where tweak will be applied]]--
		--[[self:SetCondition(self.condition - damage_amount)]]--  Original Text for this section
		
		--[[Get the tags for the item currently being processed, and change our variable to match]]--
		local DURABILITYSETTING = GetDurabilitySetting(inst)
		
		if DURABILITYSETTING ~= "Default" then
			if DURABILITYSETTING == "Infinite" then
				damage_amount = 0
			else
				damage_amount = damage_amount / DURABILITYSETTING
			end
		end

		return TakeDamage_prev(self, damage_amount, ...)
	end
	
end)



-- FINITE USES
AddComponentPostInit("finiteuses", function(FiniteUses, inst)
	local Use_prev = FiniteUses.Use
	function FiniteUses:Use(num, ...)
		--[[MODNOTE: This section deals with the update math, which is where tweak will be applied]]--
		--[[self:SetUses(self.current - (num or 1))]]--  Original Text for this section
		
		--[[Get the tags for the item currently being processed, and change our variable to match]]--
		
		local DURABILITYSETTING = GetDurabilitySetting(inst)
		
		if DURABILITYSETTING ~= "Default" then
			if DURABILITYSETTING == "Infinite" then
				num = 0
			else
				num = (num or 1) / DURABILITYSETTING
			end
		end
		
		return Use_prev(self, num, ...)
	end
	
end)


-- FUELED
AddComponentPostInit("fueled", function(Fueled, inst)
	local DoDelta_prev = Fueled.DoDelta
	function Fueled:DoDelta(amount, ...)
		
		--[[MODNOTE: This section deals with the update math, which is where tweak will be applied]]--
		--[[self.currentfuel = math.max(0, math.min(self.maxfuel, self.currentfuel + amount) )]]--  Original Text for this section
		
		--[[Get the tags for the item currently being processed, and change our variable to match]]--
		
		local DURABILITYSETTING = GetDurabilitySetting(inst)

		if DURABILITYSETTING ~= "Default" then
			if amount >= 1 then  -- Check to see if we're adding fuel to our item, and thus do not need to tweak the value
				self.currentfuel = math.max(0, math.min(self.maxfuel, self.currentfuel + amount) )
			else
				if DURABILITYSETTING == "Infinite" then
					if self.currentfuel >= 270 and self.inst:HasTag("TweakPit") then
						-- do nothing
					else
						return
					end
				else
					amount = amount / DURABILITYSETTING
				end
			end
		end
		
		return DoDelta_prev(self, amount, ...)
	end
	
end)

-- PERISHABLE
-- Perishable's modified local update function
local function Update(inst, dt)
    if inst.components.perishable then
		
		local modifier = 1
		
		local FoodTweak = 1
		if FOOD_PRESERVATION ~= "Default" then
			if FOOD_PRESERVATION ~= "Infinite" then
				FoodTweak = FOOD_PRESERVATION
			end
		else
			FoodTweak = 1
		end
		
		local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner or nil
        if not owner and inst.components.occupier then
            owner = inst.components.occupier:GetOwner()
        end

		if owner then
			if owner:HasTag("fridge") then
				if FOOD_PRESERVATION == "Infinite" then
					modifier = 0
				elseif inst:HasTag("frozen") and not owner:HasTag("nocool") and not owner:HasTag("lowcool") then
					modifier = TUNING.PERISH_COLD_FROZEN_MULT
				else
					modifier = TUNING.PERISH_FRIDGE_MULT
				end
			elseif owner:HasTag("spoiler") then
				modifier = TUNING.PERISH_GROUND_MULT 
			elseif owner:HasTag("cage") and inst:HasTag("small_livestock") then
                modifier = TUNING.PERISH_CAGE_MULT
            end
		else
			modifier = TUNING.PERISH_GROUND_MULT 
		end

		if inst:GetIsWet() then
			modifier = modifier * TUNING.PERISH_WET_MULT
		end

		
		if GLOBAL.TheWorld.state.temperature < 0 then
			if inst:HasTag("frozen") and not inst.components.perishable.frozenfiremult then
				modifier = TUNING.PERISH_COLD_FROZEN_MULT
			else
				modifier = modifier * TUNING.PERISH_WINTER_MULT
			end
		end

		if inst.components.perishable.frozenfiremult then
			modifier = modifier * TUNING.PERISH_FROZEN_FIRE_MULT
		end

		if GLOBAL.TheWorld.state.temperature > TUNING.OVERHEAT_TEMP then
			modifier = modifier * TUNING.PERISH_SUMMER_MULT
		end

        modifier = modifier * inst.components.perishable.localPerishMultiplyer

		modifier = modifier * TUNING.PERISH_GLOBAL_MULT
		
		local old_val = inst.components.perishable.perishremainingtime
		local delta = dt or (10 + math.random()*GLOBAL.FRAMES*8)
		
		if inst.components.perishable.perishremainingtime then  
			
			
			--[[MODNOTE: This section deals with the update math, which is where tweak will be applied]]--
			--[[inst.components.perishable.perishremainingtime = inst.components.perishable.perishremainingtime - delta*modifier]]--  Original Text for this section
			
			local DURABILITYSETTING = GetDurabilitySetting(inst)
			
			if DURABILITYSETTING ~= "Default" then
				if DURABILITYSETTING == "Infinite" then
					inst.components.perishable.perishremainingtime = inst.components.perishable.perishremainingtime
				else
					inst.components.perishable.perishremainingtime = inst.components.perishable.perishremainingtime - ((delta*modifier)/DURABILITYSETTING)
				end
			else
				inst.components.perishable.perishremainingtime = inst.components.perishable.perishremainingtime - delta*modifier
			end
			
			--ModDeBug(inst, owner)  --[[MODNOTE: Send Debug Message as requested by mod]]--
			
			--[[MODNOTE: End of Modded Section]]--	
			
	        if math.floor(old_val*100) ~= math.floor(inst.components.perishable.perishremainingtime*100) then
		        inst:PushEvent("perishchange", {percent = inst.components.perishable:GetPercent()})
		    end
		end

		-- Cool off hot foods over time (faster if in a fridge)
		if inst.components.edible and inst.components.edible.temperaturedelta and inst.components.edible.temperaturedelta > 0 then
			if owner and owner:HasTag("fridge") then
				if not owner:HasTag("nocool") then
					inst.components.edible.temperatureduration = inst.components.edible.temperatureduration - 1
				end
			elseif GLOBAL.TheWorld.state.temperature < TUNING.OVERHEAT_TEMP - 5 then
				inst.components.edible.temperatureduration = inst.components.edible.temperatureduration - .25
			end
			if inst.components.edible.temperatureduration < 0 then inst.components.edible.temperatureduration = 0 end
		end
        
        --trigger the next callback
        if inst.components.perishable.perishremainingtime and inst.components.perishable.perishremainingtime <= 0 then
			inst.components.perishable:Perish()
        end
    end
end

AddComponentPostInit("perishable", function(Perishable, inst)
	if FOOD_PRESERVATION == "Default" then
		return
	end
	
	if Perishable.CustomUpdate == nil then
		-- Replace the original function
		function Perishable:StartPerishing()
			if self.updatetask ~= nil then
				self.updatetask:Cancel()
				self.updatetask = nil
			end

			local dt = 10 + math.random()*GLOBAL.FRAMES*8
			self.updatetask = self.inst:DoPeriodicTask(dt, Update, math.random()*2, dt)
		end
	else
		local CustomUpdate_prev = Perishable.CustomUpdate
		function Perishable:CustomUpdate(dt, ...)
			local DURABILITYSETTING = GetDurabilitySetting(inst)
			
			if DURABILITYSETTING ~= "Default" then
				if DURABILITYSETTING == "Infinite" then
					return
				else
					dt = dt/DURABILITYSETTING
				end
			end
			
			return CustomUpdate_prev(self, dt, ...)
		end	
	end
	
end)




