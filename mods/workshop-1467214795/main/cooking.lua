local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

local cooking = require("cooking")
require("util")

local COMMON = 3
local UNCOMMON = 1
local RARE = .5

IA_VEGGIES = {
    sweet_potato = {
        seed_weight = COMMON,
        health = TUNING.HEALING_TINY,
        hunger = TUNING.CALORIES_SMALL,
        sanity = 0,
        perishtime = TUNING.PERISH_MED,
        cooked_health = TUNING.HEALING_SMALL,
        cooked_hunger = TUNING.CALORIES_SMALL,
        cooked_perishtime = TUNING.PERISH_FAST,
        cooked_sanity = 0,
    }
}

IAENV.AddIngredientValues({"seaweed"}, {veggie=1}, true, true)
IAENV.AddIngredientValues({"sweet_potato"}, {veggie=1}, true)
IAENV.AddIngredientValues({"coffeebeans"}, {fruit=.5})
IAENV.AddIngredientValues({"coffeebeans_cooked"}, {fruit=1})
IAENV.AddIngredientValues({"coconut_cooked", "coconut_halved"}, {fruit=1,fat=1})
IAENV.AddIngredientValues({"doydoyegg"}, {egg=1}, true)
IAENV.AddIngredientValues({"dorsalfin"}, {inedible=1})
IAENV.AddIngredientValues({"shark_fin", "fish_tropical", "solofish_dead", "swordfish_dead"}, {meat=0.5,fish=1})
IAENV.AddIngredientValues({"fish_med", "roe", "purple_grouper", "pierrot_fish", "neon_quattro"}, {meat=0.5,fish=1}, true)
IAENV.AddIngredientValues({"fish_small", "fish_small"}, {fish=0.5}, true)
IAENV.AddIngredientValues({"jellyfish", "jellyfish_dead", "jellyfish_cooked", "jellyjerky"}, {fish=1,jellyfish=1,monster=1})
IAENV.AddIngredientValues({"limpets", "mussel"}, {fish=.5}, true)
IAENV.AddIngredientValues({"lobster"}, {fish=2}, true)
IAENV.AddIngredientValues({"crab"}, {fish=.5})


local foods = {
	californiaroll = 
	{
		test = function(cooker, names, tags) return (names.seaweed and names.seaweed == 2) and (tags.fish and tags.fish >= 1) end,
		priority = 20,
		foodtype = FOODTYPE.MEAT,
		health = TUNING.HEALING_MED,
		hunger = TUNING.CALORIES_LARGE,
		perishtime = TUNING.PERISH_MED,
		sanity = TUNING.SANITY_SMALL,
		cooktime = .5,
	},

	seafoodgumbo = 
	{
		test = function(cooker, names, tags) return tags.fish and tags.fish > 2 end,
		priority = 10,
		foodtype = FOODTYPE.MEAT,
		health = TUNING.HEALING_LARGE,
		hunger = TUNING.CALORIES_LARGE,
		perishtime = TUNING.PERISH_MED,
		sanity = TUNING.SANITY_MEDLARGE,
		cooktime = 1,
        potlevel = "low",
	},

	bisque = 
	{
		test = function(cooker, names, tags) return names.limpets and names.limpets == 3 and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.MEAT,
		health = TUNING.HEALING_HUGE,
		hunger = TUNING.CALORIES_MEDSMALL,
		perishtime = TUNING.PERISH_MED,
		sanity = TUNING.SANITY_TINY,
		cooktime = 1,
	},

--[[
	ceviche = 
	{
		test = function(cooker, names, tags) return tags.fish and tags.fish >= 2 and tags.frozen end,
		priority = 20,
		foodtype = FOODTYPE.MEAT,
		health = TUNING.HEALING_MED,
		hunger = TUNING.CALORIES_MED,
		perishtime = TUNING.PERISH_MED,
		sanity = TUNING.SANITY_TINY,
		temperature = TUNING.COLD_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
		cooktime = 0.5,
	},
]]

	jellyopop = 
	{
		test = function(cooker, names, tags) return tags.jellyfish and tags.frozen and names.twigs end,
		priority = 20,
		foodtype = FOODTYPE.MEAT,
		health = TUNING.HEALING_MED,
		hunger = TUNING.CALORIES_SMALL,
		perishtime = TUNING.PERISH_SUPERFAST,
		sanity = 0,
		temperature = TUNING.COLD_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
		cooktime = 0.5,
        potlevel = "low",
	},

--[[
	bananapop = 
	{
		test = function(cooker, names, tags) return names.cave_banana and tags.frozen and tags.inedible and not tags.meat and not tags.fish end,
		priority = 20,
		foodtype = FOODTYPE.VEGGIE,
		health = TUNING.HEALING_MED,
		hunger = TUNING.CALORIES_SMALL,
		perishtime = TUNING.PERISH_SUPERFAST,
		sanity = TUNING.SANITY_LARGE,
		temperature = TUNING.COLD_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
		cooktime = 0.5,
	},
]]

	lobsterbisque = 
	{
		test = function(cooker, names, tags) return names.lobster and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.MEAT,
		health = TUNING.HEALING_HUGE,
		hunger = TUNING.CALORIES_MED,
		perishtime = TUNING.PERISH_MED,
		sanity = TUNING.SANITY_SMALL,
		cooktime = 0.5,
	},

	lobsterdinner = 
	{
		test = function(cooker, names, tags) return names.lobster and tags.fat and not tags.meat and not tags.frozen end,
		priority = 25,
		foodtype = FOODTYPE.MEAT,
		health = TUNING.HEALING_HUGE,
		hunger = TUNING.CALORIES_LARGE,
		perishtime = TUNING.PERISH_SLOW,
		sanity = TUNING.SANITY_HUGE,
		cooktime = 1,
	},

	sharkfinsoup = 
	{
		test = function(cooker, names, tags) return names.shark_fin end,
		priority = 20,
		foodtype = FOODTYPE.MEAT,
		health = TUNING.HEALING_LARGE,
		hunger = TUNING.CALORIES_SMALL,
		perishtime = TUNING.PERISH_MED,
		sanity = -TUNING.SANITY_SMALL,
		naughtiness = 10,
		cooktime = 1,
        potlevel = "low",
	},

	surfnturf = 
	{
		test = function(cooker, names, tags) return tags.meat and tags.meat >= 2.5 and tags.fish and tags.fish >= 1.5 and not tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.MEAT,
		health = TUNING.HEALING_HUGE,
		hunger = TUNING.CALORIES_LARGE,
		perishtime = TUNING.PERISH_MED,
		sanity = TUNING.SANITY_LARGE,
		cooktime = 1,
        potlevel = "high",
	},

	coffee = 
	{
		test = function(cooker, names, tags) return names.coffeebeans_cooked and (names.coffeebeans_cooked == 4 or (names.coffeebeans_cooked == 3 and (tags.dairy or tags.sweetener)))	end,
		priority = 30,
		-- foodtype = FOODTYPE.VEGGIE,
		foodtype = FOODTYPE.GOODIES, --Taffy and others got changed to this too
		health = TUNING.HEALING_SMALL,
		hunger = TUNING.CALORIES_TINY,
		perishtime = TUNING.PERISH_MED,
		sanity = -TUNING.SANITY_TINY,
		caffeinedelta = TUNING.CAFFEINE_FOOD_BONUS_SPEED,
		caffeineduration = TUNING.FOOD_SPEED_LONG,
		cooktime = 0.5,
        potlevel = "low",
	},

	tropicalbouillabaisse =
	{
		test = function(cooker, names, tags) return (names.purple_grouper or names.purple_grouper_cooked) and (names.pierrot_fish or names.pierrot_fish_cooked) and (names.neon_quattro or names.neon_quattro_cooked) and tags.veggie end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		health = TUNING.HEALING_MED,
		hunger = TUNING.CALORIES_LARGE,
		perishtime = TUNING.PERISH_MED,
		sanity = TUNING.SANITY_MED,
		cooktime = 2,
        potlevel = "low",
        boost_dry = true,
        boost_cool = true,
        boost_surf = true,
	},

	caviar =
	{
		-- test = function(cooker, names, tags) return (names.roe or 0) + (names.roe_cooked or 0) == 3 and tags.veggie end,
		test = function(cooker, names, tags) return (names.roe or names.roe_cooked == 3) and tags.veggie end,
		priority = 20,
		foodtype = FOODTYPE.MEAT,
		health = TUNING.HEALING_SMALL,
		hunger = TUNING.CALORIES_SMALL,
		perishtime = TUNING.PERISH_MED,
		sanity = TUNING.SANITY_LARGE,
		cooktime = 2,
	},	
}
local warlyfoods = {
	sweetpotatosouffle =
	{
		test = function(cooker, names, tags) return (names.sweet_potato and names.sweet_potato == 2) and tags.egg and tags.egg >= 2 end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		health = TUNING.HEALING_MED,
		hunger = TUNING.CALORIES_LARGE,
		perishtime = TUNING.PERISH_MED,
		sanity = TUNING.SANITY_MED,
		cooktime = 2,
        potlevel = "low",
        tags = { "masterfood" },
	},

--[[
	monstertartare =
	{
		-- test = function(cooker, names, tags) return (names.monstermeat or names.monstermeat_dried or names.cookedmonstermeat)
			-- and tags.monster and tags.monster >= 2 and tags.egg and tags.veggie end,
		test = function(cooker, names, tags) return tags.monster and tags.monster >= 2 and tags.egg and tags.veggie end,
		priority = 30,
		foodtype = FOODTYPE.MEAT,
		health = TUNING.HEALING_SMALL,
		hunger = TUNING.CALORIES_LARGE,
		perishtime = TUNING.PERISH_MED,
		sanity = TUNING.SANITY_SMALL,
		cooktime = 2,
        tags = { "masterfood" },
	},
]]

--[[
	freshfruitcrepes =
	{
		test = function(cooker, names, tags) return tags.fruit and tags.fruit >= 1.5 and tags.dairy and names.honey end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		health = TUNING.HEALING_HUGE,
		hunger = TUNING.CALORIES_SUPERHUGE,
		perishtime = TUNING.PERISH_MED,
		sanity = TUNING.SANITY_MED,
		cooktime = 2,
        tags = { "masterfood" },
	},
]]

	musselbouillabaise =
	{
		test = function(cooker, names, tags) return (names.mussel and names.mussel == 2) and tags.veggie and tags.veggie >= 2 end,
		priority = 30,
		foodtype = FOODTYPE.MEAT,
		health = TUNING.HEALING_MED,
		hunger = TUNING.CALORIES_LARGE,
		perishtime = TUNING.PERISH_MED,
		sanity = TUNING.SANITY_MED,
		cooktime = 2,
        potlevel = "low",
        tags = { "masterfood" },
	},
}

if IA_CONFIG.oldwarly then
	--upgrade monstertartare
	local monstertartare = cooking.GetRecipe("portablecookpot","monstertartare")
	if monstertartare then
		monstertartare.test = function(cooker, names, tags) return tags.monster and tags.monster >= 2 and tags.egg and tags.veggie end
		monstertartare.health = TUNING.HEALING_SMALL
		monstertartare.hunger = TUNING.CALORIES_LARGE
		monstertartare.perishtime = TUNING.PERISH_MED
		monstertartare.sanity = TUNING.SANITY_SMALL
		monstertartare.cooktime = 2
	end
end

----------------------------------------------------------------------------------------

for k,v in pairs(foods) do
	v.name = k
	v.weight = v.weight or 1
	v.priority = v.priority or 0
	IAENV.AddCookerRecipe("cookpot", v)
	-- if not IA_CONFIG.oldwarly then
		AddCookerRecipe("portablecookpot", v)
	-- end
end

for k,v in pairs(warlyfoods) do
	v.name = k
	v.weight = v.weight or 1
	v.priority = v.priority or 0
	IAENV.AddCookerRecipe("portablecookpot", v)
end

-- spice it!
local spicedfoods = shallowcopy(require("spicedfoods"))
GenerateSpicedFoods(foods)
GenerateSpicedFoods(warlyfoods)
local ia_spiced = {}
local new_spicedfoods = require("spicedfoods")
for k,v in pairs(new_spicedfoods) do
	if not spicedfoods[k] then
		ia_spiced[k] = v
	end
end
for k,v in pairs(ia_spiced) do
	new_spicedfoods[k] = nil --do not let the game make the prefabs
	IAENV.AddCookerRecipe("portablespicer", v)
end

IA_PREPAREDFOODS = MergeMaps(foods, warlyfoods, ia_spiced)

----------------------------------------------------------------------------------------

--The following makes "portablecookpot" a synonym of "cookpot" and also implements Warly's unique recipes
local CalculateRecipe_old = cooking.CalculateRecipe
cooking.CalculateRecipe = function(cooker, names, ...)
	-- Spicer wetgoop fix! (in the unlikely case somebody has Gourmet food and a spicer at the same time)
	for k, v in pairs(names) do
		if v:sub(-8) == "_gourmet" then
			names[k] = v:sub(1, -9)
		end
	end

	if not IA_CONFIG.oldwarly then return CalculateRecipe_old(cooker, names, ...) end

	if cooker == "portablecookpot" then cooker = "cookpot" end
	local ret
	if cooking.enableWarly and cooker == "cookpot" then
		--TODO This includes meatballs n shit now
		ret = {CalculateRecipe_old("portablecookpot", names, ...)} --get Warly recipe
	end
	if not ret or not ret[1] then
		ret = {CalculateRecipe_old(cooker, names, ...)}
	end
	return unpack(ret)
end

--This can be called when the food is done, thus don't use cooking.enableWarly
local GetRecipe_old = cooking.GetRecipe
cooking.GetRecipe = function(cooker, ...)
	if not IA_CONFIG.oldwarly then return GetRecipe_old(cooker, ...) end

	if cooker == "portablecookpot" then cooker = "cookpot" end
	-- local ret
	-- if cooking.enableWarly and cooker == "cookpot" then
		-- ret = GetRecipe_old("portablecookpot", ...)
	-- end
	-- ret = ret or GetRecipe_old(cooker, ...) or GetRecipe_old("portablecookpot", ...)
	return GetRecipe_old(cooker, ...) or GetRecipe_old("portablecookpot", ...)
end
local IsModCookingProduct_old = IsModCookingProduct
IsModCookingProduct = function(cooker, ...)
	-- if not IA_CONFIG.oldwarly then return IsModCookingProduct_old(cooker, ...) end

	if cooker == "portablecookpot" then cooker = "cookpot" end
	return IsModCookingProduct_old(cooker, ...) or IsModCookingProduct_old("portablecookpot", ...)
end
