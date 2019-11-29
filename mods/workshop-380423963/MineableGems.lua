_G = _G or GLOBAL
if not (_G.TheNet and _G.TheNet:GetIsServer()) then
	return
end
------------ Server side ---------------

--Safe getting/setting global variables.
local GetGlobal=function(gname,default)
	local res=_G.rawget(_G,gname)
	if default~=nil and res==nil then
		_G.rawset(_G,gname,default)
		return default
	end
	return res
end


--Locals (Add compatibility with any other mineable mods).
local mods = GetGlobal("mods",{})
local t = mods.mine or {} --All loot mods should register itself here.
mods.mine = t

--Saving work of other mods with higher priority.
local LootTables
local protected_objects --prevent deleting loot

--Function for adding new loot.
local AddLoot; AddLoot = function (prefab,loot,value)
	if type(prefab) == "table" then --group of prefabs
		for i,v in ipairs(prefab) do
			AddLoot(v,loot,value)
		end
		return
	end
	--Create table if needed
	if not LootTables[prefab] then
		LootTables[prefab] = {}
	end
	--We want to protect out loot from overwriting.
	if not LootTables[prefab].protect then
		LootTables[prefab].protect = {"protect",-1}
		--Mark basic loot status
		local a = {}
		for _,v in ipairs(LootTables[prefab]) do
			a[v[1]] = true
		end
		LootTables[prefab].protect.marks = a
	end
	--Divide loot into single objects
	while value>0.0000001 do
		local val=value>1 and 1 or value
		table.insert(LootTables[prefab],{loot,val})
		value=value-val
	end
	LootTables[prefab].protect.marks[loot] = true
end


--Connect all loot mods together.
local function NewSetSharedLootTable(name, tbl)
	if not (LootTables[name] and LootTables[name].protect) then
		LootTables[name] = tbl --Somebody is trying to create or replace unknown data... Let him do it.
	else
		--Somebody is trying to hack us.... Let him import his data and prevent breaking ours.
		local a = LootTables[name]
		for i,v in ipairs(tbl) do
			if not a.protect.marks[v[1]] then
				table.insert(a, v)
			end
		end
	end
end

--Deprecated names in settings.
local steal_options = {["Boulder Blue Gem"]=-1,["Boulder Purple Gem"]=-1,
	["Gold Vein Red Gem"]=-1,["Gold Vein Purple Gem"]=-1,
	["Flintless Blue Gem"]=-1,["Flintless Red Gem"]=-1,["Flintless Purple Gem"]=-1,
	["Meteor Yellow Gem"]=-1,["Meteor Orange Gem"]=-1,["Meteor Green Gem"]=-1,
}
function GetModConfigDataOld(option)
	if steal_options[option] ~= -1 then
		return steal_options[option]
	end
end
--Dirty hack
if _G.KnownModIndex and _G.KnownModIndex.LoadModOverides then
	--Stealing options (from all mods).
	local mod_overrides = _G.KnownModIndex:LoadModOverides() --Have to grab it again, cos old options are lost.
	for modname,env in pairs(mod_overrides) do 
		if env.configuration_options ~= nil and env.enabled then --options exists
			for option,override in pairs(env.configuration_options) do
				if steal_options[option] then
					if steal_options[option] ~= -1 then
						print("MINEABLE GEMS ERROR: Mod option names conflict! - "..tostring(option))
						print("Probably you enabled two or more Mineable Gems mods from Star.")
					end
					steal_options[option] = override
					print("Option "..tostring(option).." is overrided.")
				end
			end
		end
	end
end



--Safe get config numbers.
local function GetConf(name,default,name_old)
	local res = GetModConfigData(name)
	if res == nil and name_old ~= nil then --supporting old names?
		print("Trying to get old settings...")
		res = GetModConfigDataOld(name_old)
	end
	if type(res) == "string" then
		res = _G.tonumber(res)
	end
	if type(res) ~= "number" then
		return default
	end
	return res
end




--Add custom loot
local function PreInitLoot()
	--Mineable Gems Mod
	if t.MineableGems then
		print("MINEABLE GEMS ERROR: You enabled two or more same mods.")
		return
	end
	t.MineableGems = {} --protect from two mineable gems mods at once (protect from fool users and modders)
	--Boulder
	AddLoot('rock1','bluegem',GetConf("boulder_blue",0.2,"Boulder Blue Gem"))
	AddLoot('rock1','purplegem',GetConf("boulder_purple",0.05,"Boulder Purple Gem"))
	
	--Gold Vein
	AddLoot('rock2','redgem',GetConf("goldvein_red",0.1,"Gold Vein Red Gem"))
	AddLoot('rock2','purplegem',GetConf("goldvein_purple",0.05,"Gold Vein Purple Gem"))

	--Flintless
	local flintless = {'rock_flintless', 'rock_flintless_med', 'rock_flintless_low'}
	AddLoot(flintless,'bluegem',GetConf("flintless_blue",0.5,"Flintless Blue Gem"))
	AddLoot(flintless,'redgem',GetConf("flintless_red",0.2,"Flintless Red Gem"))
	AddLoot(flintless,'purplegem',GetConf("flintless_purple",0.1,"Flintless Purple Gem"))

	--Moon Rock
	AddLoot('rock_moon','yellowgem',GetConf("moon_yellow",0.02,"Meteor Yellow Gem"))
	AddLoot('rock_moon','orangegem',GetConf("moon_orange",0.02,"Meteor Orange Gem"))
	AddLoot('rock_moon','greengem',GetConf("moon_green",0.02,"Meteor Green Gem"))
	
	--Stalagmite rocks
	local stalagmite = {"stalagmite_tall_full_rock", "stalagmite_tall_med_rock", "stalagmite_tall_low_rock",
		"full_rock","med_rock","low_rock",
	}
	AddLoot(stalagmite,'yellowgem',GetConf("stalagmite_yellow",0.02))
	AddLoot(stalagmite,'orangegem',GetConf("stalagmite_orange",0.02))
	AddLoot(stalagmite,'greengem',GetConf("stalagmite_green",0.02))
	
end

--[[ New loot
AddSimPostInit(function()

local _LT = GLOBAL.LootTables

table.insert(_LT['full_rock'], {"orangegem", 0.02})
table.insert(_LT['full_rock'], {"yellowgem", 0.02})
table.insert(_LT['full_rock'], {"greengem", 0.02})
table.insert(_LT['stalagmite_tall_full_rock'], {"orangegem", 0.02})
table.insert(_LT['stalagmite_tall_full_rock'], {"yellowgem", 0.02})
table.insert(_LT['stalagmite_tall_full_rock'], {"greengem", 0.02})

end)
--]]

--Creates neat array without spaces (nils).
local function MakeNeatArray(data) -- { A, B, C }
	local res = {}
	for k,v in pairs(data) do
		if v ~= nil then
			table.insert(res,v)
		end
	end
	return res
end

--Adds a loot to caves
--local empty_derbis = { weight=0, loot={} }
function AddDerbisData(prefab,chance)
	chance =_G.tonumber(chance) or 0
	if chance <= 0 then
		--adding nil wont change an array length
		return --empty_derbis
	end
	return {
		weight = chance,
		loot = { prefab },
	}
end


--Earthquake
DERBIS_DATA=MakeNeatArray({
	-- common
	AddDerbisData("rocks",GetConf("common_loot_rocks",0.37)),
	AddDerbisData("flint",GetConf("common_loot_flint",0.37)),
	AddDerbisData("charcoal",GetConf("common_loot_charcoal",0)),
	-- uncommon
	AddDerbisData("goldnugget",GetConf("uncommon_loot_goldnugget",0.05)),
	AddDerbisData("nitre",GetConf("uncommon_loot_nitre",0.05)),
	AddDerbisData("rabbit",GetConf("uncommon_loot_rabbit",0.05)),
	AddDerbisData("mole",GetConf("uncommon_loot_mole",0.05)), 
	-- rare
	AddDerbisData("redgem",GetConf("rare_loot_redgem",0.015)),
	AddDerbisData("bluegem",GetConf("rare_loot_bluegem",0.015)),
	AddDerbisData("marble",GetConf("rare_loot_marble",0.015)), 
})
local new_caves_loot = {
	"guano", "foliage", "cutlichen", --common
	"seeds", "spoiled_food", "rottenegg", "pinecone", --uncommon
	"lightbulb", "durian", "gears", --rare
}
for i,v in ipairs(new_caves_loot) do
	local weight = GetConf("new_loot_"..v,0)
	if weight > 0 then
		table.insert(DERBIS_DATA,weight)
	end
end

DERBIS__WINTER_DATA = _G.deepcopy(DERBIS_DATA)
local derb_ice = AddDerbisData("ice",GetConf("ice",0))
if derb_ice ~= nil then
	table.insert(DERBIS__WINTER_DATA, derb_ice) --adding nil wont change an array length
end

QUAKE_DATA={
    warningtime = 7,
    quaketime = function() return math.random(10, 15) end,
    debrispersecond = function() return math.random(5, 6) end, -- how much junk falls
    nextquake = function() return TUNING.TOTAL_DAY_TIME + math.random() * TUNING.TOTAL_DAY_TIME * 2 end,
    mammals = 1,
}



local function OnDayEnd(w) --,data)
	local q = w.components.quaker
	if q == nil then
		return
	end
	if w.state.iswinter then
		q:SetDebris(DERBIS__WINTER_DATA)
	else
		q:SetDebris(DERBIS_DATA)
	end
end


local is_forest
local function ForestInit(inst)
	if is_forest==true then
		return
	end
	is_forest=true
	LootTables = GetGlobal("LootTables",{}) --i hope this is a real table
	_G.SetSharedLootTable=NewSetSharedLootTable
	PreInitLoot()
	if GetModConfigData("change_cave_loot") then
		local q = inst.components.quaker
		if q and q.SetQuakeData and q.SetDebris then
			inst:WatchWorldState("cycles", OnDayEnd)
			OnDayEnd(inst)
			--print("Setting quake data and derbis...")
			--q:SetQuakeData(QUAKE_DATA)
			--q:SetDebris(DERBIS_DATA)
		end
	end
end

AddPrefabPostInit("world",ForestInit)
AddPrefabPostInit("forest",ForestInit)

