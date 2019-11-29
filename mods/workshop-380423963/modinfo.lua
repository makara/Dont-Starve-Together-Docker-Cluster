--[[
Copy & paste for dedicated servers:

["workshop-380423963"] = { --Mineable Gems
	enabled = true,
	configuration_options =
	{
		-- 1 means 100%, 0.3 means 30%, 0.15 means 15% etc.
		-- Also 3.7 means 3 gems + 70% chance of 4th gem.
		boulder_blue = 0.01,
		boulder_purple = 0.005, --Means 0.5%
		goldvein_red = 0.01,
		goldvein_purple = 0.005,
		flintless_blue = 0.02,
		flintless_red = 0.02,
		flintless_purple = 0.01,
		moon_yellow = 0.01,
		moon_orange = 0.01,
		moon_green = 0.01,
		--caves
		stalagmite_yellow = 0.02,
		stalagmite_orange = 0.02,
		stalagmite_green = 0.02,
		
		--STANDARD CAVE DEBRIS
		--common
		common_loot_rocks = 0.37,
		common_loot_flint = 0.37,
		common_loot_charcoal = 0,
		--uncommon
		uncommon_loot_goldnugget = 0.05,
		uncommon_loot_nitre = 0.05,
		uncommon_loot_rabbit = 0.05,
		uncommon_loot_mole = 0.05,
		--rare
		rare_loot_redgem = 0.015,
		rare_loot_bluegem = 0.015,
		rare_loot_marble = 0.015,

		--ADDITIONAL CAVE DEBRIS (weight: can be any number)
		--common: recommended 0.37
		guano = 0,
		foliage = 0,
		cutlichen = 0,
		--uncommon: recommended 0.05
		seeds = 0,
		spoiled_food = 0,
		rottenegg = 0,
		pinecone = 0,
		--rare: recommended 0.015
		lightbulb = 0,
		durian = 0,
		gears = 0,
		
		--winter
		ice = 0,
	}
},


--]]

name = "Mineable Gems"
version = "2.20"
version_compatible = "2.20"
russian = russian or (language == "ru")
description =
	russian and "Ver. "..version.."\nДобавляет шанс дропа драг. камней с обычных валунов."
	or "Ver. "..version.."\nGives boulders a chance to drop gems."
author = "star"
forumthread = ""
api_version = 10
dont_starve_compatible = false
reign_of_giants_compatible = false
dst_compatible = true
all_clients_require_mod = false
client_only_mod = false
server_filter_tags = {"mineable gems"}

icon_atlas = "preview.xml"
icon = "preview.tex"

options = 
{
	{description = "0%", data = 0.00},
	{description = "0.2%", data = 0.002},
	{description = "0.3%", data = 0.003},
	{description = "0.4%", data = 0.004},
	{description = "0.5%", data = 0.005},
	{description = "0.7%", data = 0.007},
	{description = "1%", data = 0.01},
	{description = "1.5%", data = 0.015},
	{description = "2%", data = 0.02},
	{description = "3%", data = 0.03},
	{description = "5%", data = 0.05},
	{description = "7%", data = 0.07},
	{description = "10%", data = 0.1},
	{description = "15%", data = 0.15},
	{description = "20%", data = 0.2},
	{description = "25%", data = 0.25},
	{description = "30%", data = 0.3},
	{description = "35%", data = 0.35},
	{description = "40%", data = 0.4},
	{description = "50%", data = 0.5},
	{description = "60%", data = 0.6},
	{description = "75%", data = 0.75},
	{description = "100%", data = 1},
	{description = "125%", data = 1.25},
	{description = "150%", data = 1.5},
	{description = "175%", data = 1.75},
	{description = "200%", data = 2},
	{description = "250%", data = 2.5},
	{description = "300%", data = 3},
}

local opt_weight =
{
	{description = "0", data = 0.00},
	{description = "0.02", data = 0.0002},
	{description = "0.05", data = 0.0005},
	{description = "0.1", data = 0.001},
	{description = "0.2", data = 0.002},
	{description = "0.3", data = 0.003},
	{description = "0.4", data = 0.004},
	{description = "0.5", data = 0.005},
	{description = "0.7", data = 0.007},
	{description = "1", data = 0.01},
	{description = "1.5", data = 0.015},
	{description = "2", data = 0.02},
	{description = "2.5", data = 0.025},
	nil,nil,nil,nil,nil,nil,
}
local c = #opt_weight
for i=0.03,1.000001,0.01 do
	c=c+1
	opt_weight[c] = {description = (i*100).."%", data = i}
end


local empty_options = {{description = "", data = 0 }}

--Will show a title between option groups.
local function Title(title,hover)
	return {
		name = "",
		label = title,
		hover=hover,
		options = empty_options,
		default = 0,
	}
end

SEPARATOR = Title("")


configuration_options =
{
	{
		name = "boulder_blue",
		label = russian and "Валун / Сапфир" or "Boulder Blue Gem",
		hover = "Blue Gem",
		options = options,
		default = 0.2,
	},
	{
		name = "boulder_purple",
		label = russian and "Валун / Аметист" or "Boulder Purple Gem",
		hover = "Purple Gem",
		options = options,
		default = 0.05,
	},
	SEPARATOR,
	{
		name = "goldvein_red",
		label = russian and "Золотоносный / Рубин" or "Gold Vein Red Gem",
		hover = "Red Gem",
		options = options,
		default = 0.1,
	},
	{
		name = "goldvein_purple",
		label = russian and "Золотоносный / Аметист" or "Gold Vein Purple Gem",
		hover = "Purple Gem",
		options = options,
		default = 0.05,
	},
	SEPARATOR,
	{
		name = "flintless_blue",
		label = russian and "Острый / Сапфир" or "Flintless Blue Gem",
		hover = "Blue Gem",
		options = options,
		default = 0.5,
	},
	{
		name = "flintless_red",
		label = russian and "Острый / Рубин" or "Flintless Red Gem",
		hover = "Red Gem",
		options = options,
		default = 0.2,
	},
	{
		name = "flintless_purple",
		label = russian and "Острый / Аметист" or "Flintless Purple Gem",
		hover = "Purple Gem",
		options = options,
		default = 0.1,
	},
	SEPARATOR,
	{
		name = "moon_yellow",
		label = russian and "Лунный / Цитрин" or "Meteor Yellow Gem",
		hover = "Yellow Gem",
		options = options,
		default = 0.02,
	},
	{
		name = "moon_orange",
		label = russian and "Лунный / Цитрин" or "Meteor Orange Gem",
		hover = "Orange Gem",
		options = options,
		default = 0.02,
	},
	{
		name = "moon_green",
		label = russian and "Лунный / Изумруд" or "Meteor Green Gem",
		hover = "Green Gem",
		options = options,
		default = 0.02,
	},
	SEPARATOR,
	{
		name = "stalagmite_yellow",
		label = russian and "Сталагмит / Цитрин" or "Stalagmite Yellow Gem",
		hover = "Yellow Gem",
		options = options,
		default = 0.02,
	},
	{
		name = "stalagmite_orange",
		label = russian and "Сталагмит / Цитрин" or "Stalagmite Orange Gem",
		hover = "Orange Gem",
		options = options,
		default = 0.02,
	},
	{
		name = "stalagmite_green",
		label = russian and "Сталагмит / Изумруд" or "Stalagmite Green Gem",
		hover = "Green Gem",
		options = options,
		default = 0.02,
	},
	SEPARATOR,
	{
		name = "change_cave_loot",
		label = russian and "Менять лут пещер" or "Change Cave Loot",
		options = {
			{description = "Yes", data = true},
			{description = "No", data = false},
		},
		default = false,
	},
	SEPARATOR,
	Title("CAVE DEBRIS","You can change standard cave debris while quake."),
}



local arr_weight = {0,
	.0001,.0002,.0003,.0004,.0005,.0006,.0007,.0008,.0009,
	.0010,.0011,.0012,.0013,.0014,.0015,.0017,.0020,.0025,.0030,.0035,.0040,.0045,.005,.006,.007,.008,.009,
	.010,.011,.012,.013,.014,.015,.017,.020,.025,.030,.035,.040,.045,.05,.06,.07,.08,.09,
	.10,.11,.12,.13,.14,.15,.17,.20,.25,.30,.35,.40,.45,.5,.6,.7,.8,.9,
	1,1.1,1.2,1.3,1.4,1.5,1.6,1.7,1.8,1.9,2,2.5,3,3.5,4,4.5,5,5.5,6,6.5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,25,30,35,40,45,50,}
local conf_weight = {}
for i=1,#arr_weight do
	conf_weight[i] = { description = (arr_weight[i]*100).."%", data = arr_weight[i], }
end

--Type hack
local type_hack = "qwertyuiopasdhjk12345"
local function is_num(val) --Only for "string" or "number".
	return "" .. val ~= val
end
local function check_table(val) --Only for "string", "table" or "nil". Result is string, not a boolean.
	return val and (val.len and "string" or "table") or "nil"
end
local function is_string(val) --Only for "string", "table" or "nil". Will return true only for strings. Falsy for tables and nils.
	return val and val.len and true
end
local function type(val) --Only for "string", "table" or "number". Slow function.
	if type_hack:gsub(type_hack,val)==type_hack then return "table" end
	return isnum(val)
end

local function AddOption(option)
	configuration_options[#configuration_options+1] = option
end

local function AddConfigs(arr)
	if is_string(arr[1]) then
		AddOption({
			name = arr[1],
			label = arr[2],
			options = conf_weight,
			default = arr[3],
			hover = arr[4],
		})
		return
	end
	for i=1,#arr do --go deeper
		AddConfigs(arr[i])
	end
end


AddConfigs({
	{
		{"common_loot_rocks", russian and "Камни" or "Rocks", 0.35},
		{"common_loot_flint", russian and "Кремень" or "Flint", 0.35},
		{"common_loot_charcoal", russian and "Уголь" or "Charcoal", 0},
	},
	{
		{"uncommon_loot_goldnugget", russian and "Золото" or "Gold Nugget", 0.05},
		{"uncommon_loot_nitre", russian and "Селитра" or "Nitre", 0.05},
		{"uncommon_loot_rabbit", russian and "Кролики" or "Rabbit", 0.05},
		{"uncommon_loot_mole", russian and "Кроты" or "Mole", 0.05},
	},
	{
		{"rare_loot_redgem", russian and "Рубин" or "Red Gem", 0.015, "Red Gem"},
		{"rare_loot_bluegem", russian and "Сапфир" or "Blue Gem", 0.015, "Blue Gem"},
		{"rare_loot_marble", russian and "Мрамор" or "Marble", 0.015},
	},
})

	
AddOption(SEPARATOR)
AddOption(Title("ADDITIONAL DEBRIS","Additional cave loot while quake."))

AddConfigs({
	--new_loot_common
	{
		{"guano", russian and "Гуано" or "Guano", 0},
		{"foliage", russian and "Листва" or "Foliage", 0},
		{"cutlichen", russian and "Лишайник" or "Lichen", 0},
	},
	--new_loot_uncommon
	{
		{"seeds", russian and "Семена" or "Seeds", 0},
		{"spoiled_food", russian and "Гниль" or "Rot", 0},
		{"rottenegg", russian and "Тухлое яйцо" or "Rotten Egg", 0},
		{"pinecone", russian and "Шишки" or "Pine Cone", 0},
	},
	--new_loot_rare
	{
		{"lightbulb", russian and "Лампочка" or "Light Bulb", 0},
		{"durian", russian and "Дуриан" or "Durian", 0},
		{"gears", russian and "Шестерёнки" or "Gears", 0},
	},
})

AddOption(SEPARATOR)
AddOption(Title("WINTER DEBRIS"))

AddConfigs({
	{"ice", russian and "Лёд" or "Ice", 0},
})


priority = 101.00380423963 --must be strong enough


