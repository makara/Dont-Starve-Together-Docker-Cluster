local _G = GLOBAL
local TheNet = _G.TheNet
local require = _G.require
require("linklist")
print("[LinkedList]", _G.LinkedList)
print("[LinkedList2]", _G.LinkedList2)
local LinkedList2 = _G.LinkedList2

if not TheNet then -- Is not a server
	return
end
if not TheNet:GetIsServer() then -- Is not a server
	return
end

local despawn_delay = GetModConfigData("despawn_delay")
local despawn_mode = GetModConfigData("despawn_mode")

local res_mode = GetModConfigData("res_mode")

local _debug = GetModConfigData("_debug")

local limit_table = GetModConfigData("limit_table")

local prefabs = 
{

mole = 24,
--molehill = 24,

bee = 60,
killerbee = 30,

babybeefalo = 5,
beefalo = 20,
beefaloherd = 20,

bat = 40,
frog = 40,

mosquito = 20,

monkey = 40,

spiderden = 40,
spider = 60,
spider_warrior = 30,
spiderqueen = 5,
spider_hider = 60,
spider_spitter = 35,

skeleton_player = 16,

spoiled_food = 500,

--hound = 20,
firehound = 20,
icehound = 20,

bunnyman = 30,
pigman = 30,
merm = 30,
rocky = 30,

leif_sparse = 10,
lightninggoat = 10,

mossling = 12,

glommer = 8,
rabbit = 160,
--rabbithole = 160,

penguin = 40,

--fireflies = 600,

--marsh_bushs = 150,
--red_mushroom = 160,
--blue_mushroom = 160,
--green_mushroom = 160,
--flower = 200,
--cactuss = 200,
--carrot_planteds = 200,
--tumbleweedspawners = 50,
--tumbleweed = 50,
--saplings = 1000,
--grass = 500,
}


if limit_table and type(limit_table) == "table" then
	print("[limit_table]", limit_table)
	for k, v in pairs(limit_table) do
		print('['..k..']',v)
	end
	prefabs = limit_table
else
	print("[limit_table] use default!")
end


local spawn_fns = {}
local select_fns = {}

spawn_fns["NEW"] = function (name, ent) end
select_fns["NEW"] = function (name, ent)
	return ent
end

local entlist = {}
if despawn_mode ~= "NEW" then
--	local entlist = {}

	spawn_fns["OLD"] = function (name, ent)
		local list = entlist[name]
		if list == nil then
			list = LinkedList2()
			entlist[name] = list
		end
		list:Append(ent)
	end
	select_fns["OLD"] = function (name, ent)
		local list = entlist[name]
		if list == nil then
			return ent
		end
		local oldest = list:Head()
		list:Remove(oldest)
		return oldest
	end

	local random = math.random
	spawn_fns["RANDOM"] = spawn_fns["OLD"]
	select_fns["RANDOM"] = function (name, ent)
		local list = entlist[name]
		if list == nil then
			return ent
		end
		local count = list:Count()
--print (name.." count : ", count)
		if count == 0 then
			return ent
		end
		local id = random(count)
--print (name.." selected : ", id)
		local i = 0
		local it = list:Iterator()
		while it:Next() ~= nil do
			i = i + 1
			if i == id then
				local current = it:Current()
--print ("[remove]:", i, current)
				it:RemoveCurrent()
				return current
			end
		end
		return ent
	end

end



--- counting variable ---
local counts = {}
local dec_fns = {}

dec_fns["MEM"] = function (inst)
	local name = inst.prefab
--	print (inst, " despawned : ", counts[name]-1)
	if counts[name] > 0 then
		counts[name] = counts[name] - 1
	end
	if entlist[name] == nil then
		return
	end
	entlist[name]:Remove(inst)
end

dec_fns["CPU"] = function (inst)
	local name = inst.prefab
--	print (inst, " despawned")
	if entlist[name] == nil then
		return
	end
	entlist[name]:Remove(inst)
end

local dec_fn = dec_fns[res_mode]
local select_fn = select_fns[despawn_mode]
local random = math.random

local function do_despawn(to_despawn, TheWorld)
	local delay = despawn_delay + despawn_delay*math.random()
	TheWorld:DoTaskInTime(delay, function(inst)
--		print (to_despawn.prefab.." emit despawn : ", to_despawn)

		local homeseeker = to_despawn.components.homeseeker
		if homeseeker ~= nil and homeseeker.home ~= nil then
--			print("[has home]", to_despawn, ' -> ' , homeseeker.home)
			local home = homeseeker.home
			local childspawner = home.components.childspawner
			if childspawner ~= nil then
				childspawner:OnChildKilled(to_despawn)
			end

			local data = home.data
			if data ~= nil then
--				print('[home.prefab]', home.prefab, data)
				if data.children ~= nil then
--					print('[data.children]', data.children, #data.children, data.children[to_despawn])
--					for k,v in pairs(data.children) do
--						print('[home.data.children]', k, v)
--					end
					data.children[to_despawn] = nil
				end
			end
		end


		local invitem = to_despawn.components.inventoryitem
		if invitem ~= nil and invitem.owner ~= nil then
--			print("[has owner]", to_despawn)
			dec_fn(to_despawn)
			return
		end

		to_despawn:Remove()
	end)
end

local function despawn(ent, TheWorld)
	local to_despawn = select_fn(ent.prefab, ent)
--	print (name.." wait despawn : ", to_despawn)
	do_despawn(to_despawn, TheWorld)
end

local function _dumpqueue(name)
	local ents = entlist
	if name ~= nil and ents[name] then
		local count = ents[name]:Count()
		print('[Prefab queue]', count, name, ents[name])
		local i = 0
		local it = ents[name]:Iterator()
		while it:Next() ~= nil do
			i = i + 1
			print('[Prefab queue]['..i..']\t', it:Current())
		end
		return ents[name]
	else
		return nil
	end
end

local function WaitActivated(inst)
	local TheWorld = inst

	local old_SpawnPrefab = nil
	local count_fns = {}
	local dec_fn = dec_fns[res_mode]

	count_fns["MEM"] = function (name, ent)
		ent:ListenForEvent("onremove", dec_fn)
		if counts[name] == nil then
			counts[name] = 1
		else
			counts[name] = counts[name] + 1
		end
		return counts[name]
	end

	count_fns["CPU"] = function (name, ent)
		ent:ListenForEvent("onremove", dec_fn)
		local Ents = _G.Ents
		local b = 0
		for k,v in pairs(Ents) do
			if v.prefab == name then
				local invitem = v.components.inventoryitem
				if invitem == nil then
	--				print("[has owner]", name)
					b = b + 1
				else
					if invitem.owner == nil then
	--					print("[has owner]", name)
						b = b + 1
					end
				end
			end
		end
		return b
	end


	if _G.SpawnPrefab ~= nil then
--		print("[SpawnPrefab]", _G.SpawnPrefab)
		local count_fn = count_fns[res_mode]
		local spawn_fn = spawn_fns[despawn_mode]

		old_SpawnPrefab = _G.SpawnPrefab
		_G.SpawnPrefab = function (name, skin, skin_id, creator)

			local ent = old_SpawnPrefab(name, skin, skin_id, creator)

			if ent == nil then
				return nil
			end

			local lim = prefabs[name]
			if lim ~= nil then

				--spawn_fns[despawn_mode](name, ent)
				--local N = count_fns[res_mode](name, ent)
				spawn_fn(name, ent)
				local N = count_fn(name, ent)

				if N <= lim then
					return ent
				else
					print (ent, " is reach lim : "..N)
					despawn(ent, TheWorld)
					return ent
				end
			else
				return ent
			end
		end
	end

	if _debug then
		prefabs["spider"] = 3
		prefabs["spider_warrior"] = 2
		prefabs["spoiled_food"] = 0
		prefabs["killerbee"] = 6
		prefabs["frog"] = 6
		prefabs["walrus"] = 1
		prefabs["icehound"] = 3
	end

	-- debug dump
	_G.rawset(_G, "c_showcount", function(name)
		if name ~= nil then
			print('[Prefab count]', name, counts[name])
			return counts[name]
		else
			print('[Prefab count] list:', counts)
			for k, v in pairs(counts) do
				print('['..k..']',v)
			end
			return counts
		end
	end)

	_G.rawset(_G, "c_showlimit", function(name)
		if name ~= nil then
			print('[Prefab limit]', name, prefabs[name])
			return prefabs[name]
		else
			print('[Prefab limit] list:', prefabs)
			for k, v in pairs(prefabs) do
				print('['..k..']',v)
			end
			return prefabs
		end
	end)
	_G.rawset(_G, "c_setlimit", function(name, count)
		if name ~= nil then
			prefabs[name] = count
			print('[Prefab limit]', name, prefabs[name])
			return prefabs[name]
		else
			print('[set Prefab limit] need Prefab name')
		end
	end)

	if despawn_mode ~= "NEW" then
		_G.rawset(_G, "c_dumpqueue", _dumpqueue)
	end

end

AddPrefabPostInit("world", WaitActivated)


