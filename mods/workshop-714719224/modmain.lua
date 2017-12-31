if not (GLOBAL.TheNet and GLOBAL.TheNet:GetIsServer()) then return end

local NORMAL_ITEMS = GetModConfigData("NORMAL_ITEMS")
local RARE_ITEMS = GetModConfigData("RARE_ITEMS")
local BUFF_ITEMS = GetModConfigData("BUFF_ITEMS")
local FIRST_AID_KIT = GetModConfigData("FIRST_AID_KIT")
local PACKS_VALUE = GetModConfigData("PACKS_VALUE")
local PACKS_CD = GetModConfigData("PACKS_CD")
local CHALLENGE_MISSION_DIFFICULTY = GetModConfigData("CHALLENGE_MISSION_DIFFICULTY")
local CHALLENGE_MISSION = GetModConfigData("CHALLENGE_MISSION")
local CHALLENGE_MISSION_ROLL = GetModConfigData("CHALLENGE_MISSION_ROLL")
local CHALLENGE_MISSION_CD = GetModConfigData("CHALLENGE_MISSION_CD")
local RECORD_DEATH = GetModConfigData("RECORD_DEATH")
local ANNOUNCE_TIP = GetModConfigData("ANNOUNCE_TIP")

if not NORMAL_ITEMS and RARE_ITEMS == 0 and not BUFF_ITEMS and not FIRST_AID_KIT and CHALLENGE_MISSION == 0 then return end

local _G = GLOBAL
local TheNet = _G.TheNet
local TheShard = _G.TheShard
local require = _G.require

local ismultiworld = TheShard:IsMaster() or TheShard:IsSlave()
local ShardData = ismultiworld and require "sharddata" or nil
local sharddata = ismultiworld and _G.rawget(_G, "ShardData") or nil
local SHARDDATA_VERSION = 1
local PushShardData
local sharddata_member
if ismultiworld then
	if sharddata == nil then
		sharddata_member = {
			shardmod = modname,
			shardkey = nil,
			version = SHARDDATA_VERSION,
			world = {},
			callback = {},
			master_callback = nil,
			slave_callback = nil,
			master_event = nil,
			slave_event = nil,
		}
		sharddata = ShardData(sharddata_member)
		_G.ShardData = sharddata
	else
		sharddata:CompatibleVersion(SHARDDATA_VERSION)
	end
end

local SpawnPrefab = _G.SpawnPrefab
local STRINGS = _G.STRINGS
local AllPlayers = _G.AllPlayers
local TheSim = _G.TheSim
local Vector3 = _G.Vector3
local FindValidPositionByFan = _G.FindValidPositionByFan
local GetTimeReal = _G.GetTimeReal
local PI = _G.PI
local next = _G.next
local TheWorld
local TheWorldState

local MY_STRINGS = {
	packs_msg = {
		"%s (%s) get <%d Day Big Packs> : %s * %d.",
		"%s (%s) get <Rare Packs> : %s.",
	},
	packs_say = {
		"<Online Packs> : Get %s * %d.",
		"<%d Day Big Packs> : Get %s * %d.",
		"<Rare Packs> : Get %s.",
		"<Rare Packs> : Wow! %s is nearby!",
		"<Online Packs> : Get Fresh air.",
	},
	buff_msg = {
		"%s (%s) get <BUFF> : Lv.%d MAX.Hunger.",
		"%s (%s) get <BUFF> : Lv.%d MAX.Sanity.",
		"%s (%s) get <BUFF> : Lv.%d MAX.Health.",
		"%s (%s) get <BUFF> : Lv.%d Hunger.",
		"%s (%s) get <BUFF> : Lv.%d Sanity.",
		"%s (%s) get <BUFF> : Lv.%d Health.",
		"%s (%s) get <BUFF> : Lv.%d Halo.",
	},
	buff_say = {
		"<BUFF> : MAX.Hunger increase %d.",
		"<BUFF> : MAX.Sanity increase %d.",
		"<BUFF> : MAX.Health increase %d.",
		"<BUFF> : Hunger recovery %d.",
		"<BUFF> : Sanity recovery %d.",
		"<BUFF> : Health recovery %d.",
		"<BUFF> : Get a guard ring : %d s.",
	},
	death_msg = {
		"%s (%s) Death, no longer get <Online Packs>.",
		"%s (%s) Restart, no longer get <Online Packs>.",
	},
	aid_say = {
		"<First Aid Kit> : Hunger recovery %d%%.",
		"<First Aid Kit> : Sanity recovery %d%%.",
		"<First Aid Kit> : Health recovery %d%%.",
	},
	mission_msg = {
		"<%s · %s %s Mission> %s (%s) accepted the challenge, monster has %d seconds to reach the battlefield!",
		"<%s · %s %s Mission> Lv.%d %s come in %s side, please kill in %d seconds to kill! Participants have tours!",
		"<Challenge Success> %s Successfully completed the mission, participate in the kill %d players get reward!",
		"<Challenge Failed> %s Failed to complete the mission, participate in the kill %d players get punished!",
		"<Challenge Mission> %s reset the mission!",
	},
	mission_say = {
		"<%s · %s Mission> New mission release! Continuous running %s seconds to accept!!!",
		"<Challenge Mission> Has abandoned the mission!",
		"<%s · %s %s Mission> Accept success! Please be prepared to meet the monster challenge after %d seconds!",
		"<Challenge Mission> Bad luck, the mission was robbed by others!",
		"<Challenge Mission> Monster! I am best quick!",
		"<Challenge Success> Complete the mission, get the reward! %s * %d",
		"<Challenge Success> Participate in the kill to get the reward! %s * %d",
		"<Challenge Failed> Failed to complete the mission, punished!",
		"<Challenge Failed> To participate in the kill penalty!",
		"<%s · %s Mission> New mission release! Are you ready?",
	},
	mission_type = {
		"Resource",
		"Food",
		"Tool",
		"Equipment",
		"Clothes",
	},
	mission_difficulty = {
		"Easy",
		"Hard",
		"Hell",
	},
	mission_level = {
		"Low",
		"Middle",
		"Top",
	},
}

do
	-- auto load languages translate
	local support_languages = { chs = true, cht = true, zh_CN = "chs", cn = "chs", TW = "cht" }
	local steam_support_languages = { schinese = "chs", tchinese = "cht" }

	AddPrefabPostInit("world", function(inst)
		local steamlang = TheNet:GetLanguageCode() or nil
		if steamlang and steam_support_languages[steamlang] then
			print("<OnlinePacks> Get your language from steam!")
			modimport("translate_" .. steam_support_languages[steamlang])
		else
			local lang = _G.LanguageTranslator.defaultlang or nil
			if lang ~= nil and support_languages[lang] ~= nil then
				if support_languages[lang] ~= true then
					lang = support_languages[lang]
				end
				print("<OnlinePacks> Get your language from language mod!")
				modimport("translate_" .. lang)
			end
		end

		if MY_STRINGS_OVERRIDE ~= nil then
			for k, v in pairs(MY_STRINGS_OVERRIDE) do
				if MY_STRINGS[k] ~= nil then
					MY_STRINGS[k] = v
				end
			end
			MY_STRINGS_OVERRIDE = nil
		end
	end)
end

local MISSION_DIFFICULTY_MAX
for k, v in pairs(modinfo.configuration_options) do
	if v.name == "CHALLENGE_MISSION_DIFFICULTY" then
		MISSION_DIFFICULTY_MAX = #v.options - 1
		break
	end
end
local pack_items = require "packlist"
local pack_items_name = {}
local shadowversion = false
local desclist
local mission_type = {
	{ prefab = "resource", chance = 1 },
	{ prefab = "food", chance = 1 },
	{ prefab = "tool", chance = 1 },
	{ prefab = "weapon", chance = 1 },
	{ prefab = "clothe", chance = 1 },
}

local function Desc()
	return {
		["deer_antler1"] = STRINGS.NAMES.DEER_ANTLER,
		["deer_antler2"] = STRINGS.NAMES.DEER_ANTLER,
		["deer_antler3"] = STRINGS.NAMES.DEER_ANTLER,
		["flower_cave_double"] = STRINGS.NAMES.FLOWER_CAVE,
		["flower_cave_triple"] = STRINGS.NAMES.FLOWER_CAVE,
		["moose"] = STRINGS.NAMES.MOOSE2,
		["mooseegg"] = STRINGS.NAMES.MOOSEEGG2,
		["ruins_statue_head"] = STRINGS.NAMES.ANCIENT_STATUE .. " " .. STRINGS.UI.WORLDGEN.NOUNS[31],
		["ruins_statue_head_nogem"] = STRINGS.NAMES.ANCIENT_STATUE,
		["ruins_statue_mage"] = STRINGS.NAMES.ANCIENT_STATUE .. " " .. STRINGS.UI.WORLDGEN.NOUNS[31],
		["ruins_statue_mage_nogem"] = STRINGS.NAMES.ANCIENT_STATUE,
		["spiderden_2"] = STRINGS.NAMES.SPIDERDEN .. "2",
		["spiderden_3"] = STRINGS.NAMES.SPIDERDEN .. "3",
	}
end

local function DescriptionInit(item)
	local str
	if desclist[item.prefab] then
		str = desclist[item.prefab]
	elseif item.prefab ~= nil and item.prefab ~= "" then
		local itemname = string.upper(item.prefab)
		if STRINGS.NAMES[itemname] ~= nil and STRINGS.NAMES[itemname] ~= "" then
			str = STRINGS.NAMES[itemname]
		end
	end
	return str
end

local function UpdateMissionType(pos, support)
	if support > 0 then
		mission_type[pos].chance = mission_type[pos].chance + support * (#mission_type - 1)
		mission_type[pos].chance = math.min((#mission_type - 1) * (#mission_type - 2), mission_type[pos].chance)
		mission_type[pos].chance = math.max(1, mission_type[pos].chance)
	else
		mission_type[pos].chance = mission_type[pos].chance / (#mission_type - 1)
	end
end

local function OneRandom(n)
	if math.random() < n then return true
	end
end

local function WeightedRandom(tables)
	local sum = 0
	for k, v in pairs(tables) do
		sum = sum + v.chance
	end
	local rnd = math.random() * sum
	for k, v in pairs(tables) do
		rnd = rnd - v.chance
		if rnd < 0 then
			return v, k
		end
	end
end

local function SelectedRandom(tables, func)
	local sum = 0
	local select = {}
	for k, v in pairs(tables) do
		if func(v) then
			sum = sum + v.chance
			table.insert(select, k)
		end
	end
	local rnd = math.random() * sum
	for k, v in pairs(select) do
		rnd = rnd - tables[v].chance
		if rnd < 0 then
			return tables[v], v
		end
	end
end

local function RandomPosition(x, y, z)
	return x + math.random(-2, 3), y, z + math.random(-3, 4)
end

local function IsDeathOrAFK(player)
	if player then
		if player:HasTag("player") and player:HasTag("playerghost") or player.userid == nil then
			return true
		elseif player.components and player.components.afk and player.components.afk.afk then
			return true
		end
	end
end

local function IsLowStatus(player)
	if player and player.components then
		if player.components.health and player.components.health:GetPercent() < 0.15 then
			return "health"
		elseif player.components.hunger and player.components.hunger:GetPercent() < 0.15 then
			return "hunger"
		elseif player.components.sanity and player.components.sanity:GetPercent() < 0.15 then
			return "sanity"
		end
	end
end

local function IsMoreMultiWorld()
	return ismultiworld and sharddata:GetWorldNum() > 1
end

local function IsSlaveMultiWorld()
	return ismultiworld and not sharddata.ismastershard
end

local function IsSingleMasterWorld()
	return ismultiworld and sharddata:GetWorldNum() == 1 or not ismultiworld
end

-- 战斗力评分
local function BattleScore(player)
	local score = 0
	local armorscore = 0
	local damage = 0
	if player.components.inventory then
		local item
		if _G.EQUIPSLOTS.NECK then
			score = score + 2
			item = player.components.inventory:GetEquippedItem(_G.EQUIPSLOTS.NECK)
			if item and item.prefab == "amulet" then
				score = score + 5
			end
		end
		if _G.EQUIPSLOTS.BACK then
			score = score + 2
			item = player.components.inventory:GetEquippedItem(_G.EQUIPSLOTS.BACK)
			if item and item:HasTag("backpack") then
				score = score + 2
			end
		end
		item = player.components.inventory:GetEquippedItem(_G.EQUIPSLOTS.HANDS)
		if item and item:HasTag("weapon") then
			damage = item.components.weapon.damage
			if item.components.weapon.hitrange then
				damage = math.max(damage, item.components.weapon.hitrange)
			end
			if item.components.weapon.attackrange then
				score = score + math.max(item.components.weapon.attackrange + item.components.weapon.hitrange * 1.1, item.components.weapon.damage * 1.3)
			else
				score = score + item.components.weapon.damage * 1.5
			end
		end
		item = player.components.inventory:GetEquippedItem(_G.EQUIPSLOTS.HEAD)
		if item and item.components.armor then
			local armorhealth = item.components.armor.maxcondition * item.components.armor:GetPercent() * item.components.armor.absorb_percent
			armorscore = armorscore + armorhealth / 20
			armorscore = armorscore + item.components.armor.absorb_percent * 10
		end
		item = player.components.inventory:GetEquippedItem(_G.EQUIPSLOTS.BODY)
		if item then
			if item.prefab == "amulet" then
				score = score + 5
			elseif item:HasTag("backpack") then
				score = score + 2
			elseif item.components.armor then
				local armorhealth = item.components.armor.maxcondition * item.components.armor:GetPercent() * item.components.armor.absorb_percent
				armorscore = armorscore + armorhealth / 20
				armorscore = armorscore + item.components.armor.absorb_percent * 10
				armorscore = armorscore * 0.85
			end
		end
	end
	return math.ceil(score + armorscore), math.ceil(damage)
end

local function Spawn(player, res, count)
	local item
	for i = 1, count do
		item = SpawnPrefab(res.prefab)
		if res.tag == "building" then
			item.Transform:SetPosition(RandomPosition(player.Transform:GetWorldPosition()))
		else
			player.components.inventory:GiveItem(item)
		end
	end
end

local function SpawnStuff(player, prefab)
	SpawnPrefab(prefab).Transform:SetPosition(player.Transform:GetWorldPosition())
end

-- 以下几个函数来自"小红猪的怪物入侵"
-- 获取怪物要放置的位置
local function GetSpawnPoint(target)
	local pt = Vector3(target.Transform:GetWorldPosition())
	local theta = math.random() * 2 * PI
	local radius = math.random(8, 15)
	-- we have to special case this one because birds can't land on creep
	local result_offset = FindValidPositionByFan(theta, radius, 20, function(offset)
		local pos = pt + offset
		local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 1)
		return next(ents) == nil
	end)
	if result_offset ~= nil then
		local pos = pt + result_offset
		return pos
	end
end

-- 尝试放置怪物
local function TrySpawn(player, monster, changepoint)
	local b
	if player then
		local player_pt = Vector3(player.Transform:GetWorldPosition())
		local pt = GetSpawnPoint(player)
		if pt ~= nil then
			local tile = TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
			local canspawn = tile ~= GLOBAL.GROUND.IMPASSABLE and tile ~= GLOBAL.GROUND.INVALID and tile ~= 255
			if canspawn then
				b = SpawnPrefab(monster)
				if b then
					if changepoint then
						player_pt, pt = pt, player_pt
						player.Transform:SetPosition(player_pt:Get())
					end
					b.Transform:SetPosition(pt:Get())
					if player_pt then
						b:FacePoint(player_pt)
					end
				end
				return b
			else
				b = TrySpawn(player, monster, changepoint)
			end
		end
	end
	return b
end

-- 摧毁效果
local function oncollapse(inst, other)
	if other:IsValid() and other.components.workable ~= nil and other.components.workable:CanBeWorked() then
		SpawnStuff(other, "collapse_small")
		other.components.workable:Destroy(inst)
	end
end

-- 碰撞监测
local function oncollide(inst, other)
	if other ~= nil and (other:HasTag("wall")) and -- HasTag implies IsValid
			Vector3(inst.Physics:GetVelocity()):LengthSq() >= 1 then
		inst:DoTaskInTime(2 * 0.01, oncollapse, other)
	end
end

local MISSION_TIME = 90
local MISSION_WAIT = 60
local MISSION_PUBLISH_WAIT = MISSION_WAIT
local playerlist = {}
local worldlist = {}
local cdlist = {}
local deathlist = {}
local missionlist = {}
local mission_able = false
local mission_delay_able = true
local mission_world
local mission_status
local mission_key = 0
local last_mission_type = 0
local last_mission_difficulty = 0
local last_mission_day = 0
local delay_mission_day = 0

local GenerateOnlinePacks, GenerateMissions, StartMissions, OnMissions, MissionsOver

local function GiveOnlinePacks(packlist)
	local worldday = TheWorldState.cycles
	local givelist = {}
	for k, player in ipairs(AllPlayers) do
		if not IsDeathOrAFK(player) then
			local pack
			for k2, _pack in pairs(packlist) do
				if _pack.userid == player.userid and _pack.worldday == worldday then
					pack = _pack
					table.remove(packlist, k2)
					break
				end
			end
			local firstaid
			if FIRST_AID_KIT and (not RECORD_DEATH or not deathlist[player.userid]) then
				if pack and pack.type == "big" then
					local value = pack.day % 100 == 0 and 1 or 0.3
					player.components.hunger:DoDelta(player.components.hunger.max * value, 5, true)
					player.components.sanity:DoDelta(player.components.sanity.max * value, 5)
					player.components.health:DoDelta(player.components.health.maxhealth * value)
				else
					local lowstatus = IsLowStatus(player)
					if lowstatus then
						local value = 10
						local say
						if lowstatus == "hunger" then
							player.components.hunger:DoDelta(player.components.hunger.max * 0.01 * value, 1, true)
							say = MY_STRINGS.aid_say[1]
						elseif lowstatus == "sanity" then
							player.components.sanity:DoDelta(player.components.sanity.max * 0.01 * value, 1)
							say = MY_STRINGS.aid_say[2]
						elseif lowstatus == "health" then
							player.components.health:DoDelta(player.components.health.maxhealth * 0.01 * value)
							say = MY_STRINGS.aid_say[3]
						end
						if player.components.talker then
							player.components.talker:Say(string.format(say, value), 5)
						end
						firstaid = true
						table.insert(givelist, { userid = player.userid, pack = "aid" })
					end
				end
			end
			if pack then
				local random_item = SelectedRandom(pack_items.normal, function(v)
					if (v.minday == nil or pack.day >= v.minday) and (v.maxday == nil or pack.day <= v.maxday) then
						if pack.type == "normal" or v.tag ~= "food" or OneRandom(0.4) then
							return true
						end
					end
				end)
				if pack.type == "big" then
					pack.count = math.ceil(pack.count * math.min(1, random_item.base))
					player:DoTaskInTime(0.5, function()
						Spawn(player, random_item, pack.count)
						local playername = player:GetDisplayName()
						local charactername = STRINGS.CHARACTER_NAMES[player.prefab] or player.prefab
						local day = player.components.age:GetDisplayAgeInDays()
						if ANNOUNCE_TIP then
							TheNet:Announce(string.format(MY_STRINGS.packs_msg[1], playername, charactername, day, pack_items_name[random_item.prefab], pack.count))
						end
						if player.components.talker then
							player.components.talker:Say(string.format(MY_STRINGS.packs_say[2], day, pack_items_name[random_item.prefab], pack.count))
						end
					end)
					table.insert(givelist, { userid = player.userid, day = pack.day, pack = "big" })
				elseif not firstaid then
					if pack.type == "normal" then
						pack.count = math.min(8, math.ceil(math.random(pack.count * random_item.base))) * PACKS_VALUE
						player:DoTaskInTime(0.5, function()
							Spawn(player, random_item, pack.count)
							if player.components.talker then
								player.components.talker:Say(string.format(MY_STRINGS.packs_say[1], pack_items_name[random_item.prefab], pack.count))
							end
						end)
					elseif pack.type == "null" then
						player:DoTaskInTime(0.5, function()
							if player.components.talker then
								player.components.talker:Say(MY_STRINGS.packs_say[5])
							end
						end)
					end
					table.insert(givelist, { userid = player.userid, day = pack.day, pack = "other" })
				end
			end
		end
	end
	if #givelist ~= 0 then
		if IsSlaveMultiWorld() then
			PushShardData({ type = "onlinepacks_give", data = givelist })
		else
			for k, v in ipairs(givelist) do
				if v.pack == "aid" then
					cdlist[v.userid] = (cdlist[v.userid] or 0) + 1
				elseif v.pack == "other" then
					cdlist[v.userid] = v.day
				end
			end
		end
	end
end

local function GiveOnePacks(pack)
	local worldday = TheWorldState.cycles
	local givelist = {}
	for k, player in ipairs(AllPlayers) do
		if not IsDeathOrAFK(player) and pack.userid == player.userid and pack.worldday == worldday then
			local playername = player:GetDisplayName()
			local charactername = STRINGS.CHARACTER_NAMES[player.prefab] or player.prefab

			if pack.type == "building" then
				if pack.pos == nil then
					local random_item, position = SelectedRandom(pack_items[pack.type], function(v)
						if (v.minday == nil or pack.day >= v.minday) and (v.maxday == nil or pack.day <= v.maxday) then
							return true
						end
					end)
					pack.pos = position
					if player.components.talker then
						player.components.talker:Say(string.format(MY_STRINGS.packs_say[4], pack_items_name[random_item.prefab]), 5)
					end
					if IsSlaveMultiWorld() then
						PushShardData({ type = "onlinepacks_giveone", data = pack })
					else
						TheWorld:DoTaskInTime(60, function()
							if TheWorldState.cycles == pack.worldday and (not RECORD_DEATH or not deathlist[pack.userid]) then
								if IsMoreMultiWorld() then
									PushShardData({ type = "onlinepacks_giveone", tag = "pack", data = pack })
								end
								GiveOnePacks(pack)
							end
						end)
					end
					return
				else
					local random_item = pack_items[pack.type][pack.pos]
					player:DoTaskInTime(0.5, function()
						Spawn(player, random_item, 1)
						if player.components.talker then
							player.components.talker:Say(string.format(MY_STRINGS.packs_say[3], pack_items_name[random_item.prefab]))
						end
					end)
					if ANNOUNCE_TIP and (random_item.maxday == nil or random_item.minday >= 10) then
						TheNet:Announce(string.format(MY_STRINGS.packs_msg[2], playername, charactername, pack_items_name[random_item.prefab]))
					end
					table.insert(givelist, { userid = player.userid, day = pack.day, pack = "other" })
				end
			elseif pack.type == "rare" then
				local random_item = SelectedRandom(pack_items[pack.type], function(v)
					if (v.minday == nil or pack.day >= v.minday) and (v.maxday == nil or pack.day <= v.maxday) then
						return true
					end
				end)
				player:DoTaskInTime(0.5, function()
					Spawn(player, random_item, 1)
					if player.components.talker then
						player.components.talker:Say(string.format(MY_STRINGS.packs_say[3], pack_items_name[random_item.prefab]))
					end
				end)
				table.insert(givelist, { userid = player.userid, day = pack.day, pack = "other" })
			elseif pack.type == "buff" then
				local random_item, position = SelectedRandom(pack_items[pack.type], function(v)
					if (v.minday == nil or pack.day >= v.minday) and (v.maxday == nil or pack.day <= v.maxday) then
						return true
					end
				end)
				local value = math.ceil(pack.count * random_item.base)
				player:DoTaskInTime(0.5, function()
					if random_item.prefab == "maxhunger" then
						local dodelta = player.components.hunger.max - player.components.hunger.current + value
						player.components.hunger:SetMax(player.components.hunger.max + value)
						player.components.hunger:DoDelta(-dodelta, 0.1, true)
					elseif random_item.prefab == "maxsanity" then
						local dodelta = player.components.sanity.max - player.components.sanity.current + value
						player.components.sanity:SetMax(player.components.sanity.max + value)
						player.components.sanity:DoDelta(-dodelta, 0.1)
					elseif random_item.prefab == "maxhealth" then
						local current = player.components.health.currenthealth
						player.components.health:SetMaxHealth(player.components.health.maxhealth + value)
						player.components.health:SetCurrentHealth(current)
					elseif random_item.prefab == "hunger" then
						player.components.hunger:DoDelta(value, 1, true)
					elseif random_item.prefab == "sanity" then
						player.components.sanity:DoDelta(value, 1)
					elseif random_item.prefab == "health" then
						player.components.health:DoDelta(value)
					elseif random_item.prefab == "forcefield" then
						if not player:HasTag("forcefield") then
							local initstate = {}
							initstate.absorb = player.components.health.absorb
							initstate.maxtemp = player.components.temperature.maxtemp
							initstate.mintemp = player.components.temperature.mintemp
							-- damage absorption
							player.components.health.absorb = 0.8
							-- constant temperature
							player.components.temperature.maxtemp = 40
							player.components.temperature.mintemp = 20
							player:AddTag("forcefield")
							local fx = SpawnPrefab("forcefieldfx")
							fx.entity:SetParent(player.entity)
							fx.Transform:SetPosition(0, 0, 0)
							local fx_hitanim = function()
								fx.AnimState:PlayAnimation("hit")
								fx.AnimState:PushAnimation("idle_loop")
							end
							fx:ListenForEvent("blocked", fx_hitanim, player)
							player.active = true
							local fx_func
							fx_func = function(time)
								player:DoTaskInTime(time, function()
									if player.forcefieldtime and player.forcefieldtime > 0 then
										local time = player.forcefieldtime
										player.forcefieldtime = nil
										player:DoTaskInTime(0.1, function() fx_func(time) end)
									else
										fx:RemoveEventCallback("blocked", fx_hitanim, player)
										fx.kill_fx(fx)
										if player:IsValid() then
											-- Return to normal state.
											player.components.health.absorb = initstate.absorb
											player.components.temperature.maxtemp = initstate.maxtemp
											player.components.temperature.mintemp = initstate.mintemp
											player:RemoveTag("forcefield")
											player:DoTaskInTime(0.5, function() player.active = nil end)
										end
									end
								end)
							end
							fx_func(value)
						else
							player.forcefieldtime = (player.forcefieldtime or 0) + value
						end
					end
					if ANNOUNCE_TIP and value > 15 then
						TheNet:Announce(string.format(MY_STRINGS.buff_msg[position], playername, charactername, value))
					end
					if player.components.talker then
						player.components.talker:Say(string.format(MY_STRINGS.buff_say[position], value))
					end
				end)
				table.insert(givelist, { userid = player.userid, day = pack.day, pack = "other" })
			end
			break
		end
	end
	if #givelist ~= 0 then
		if IsSlaveMultiWorld() then
			PushShardData({ type = "onlinepacks_give", data = givelist })
		else
			cdlist[givelist[1].userid] = givelist[1].day
		end
	end
end

--collect players info from every world
local function CollectPlayers()
	for k, v in ipairs(AllPlayers) do
		if v and v.components and not IsDeathOrAFK(v) then
			table.insert(playerlist, {
				userid = v.userid,
				day = v.components.age:GetDisplayAgeInDays(),
			})
		end
	end
	if IsSlaveMultiWorld() then
		PushShardData({ type = "onlinepacks_collect", data = playerlist })
		playerlist = {}
	elseif IsSingleMasterWorld() then
		GenerateOnlinePacks()
	else
		table.insert(worldlist, sharddata.worldid)
		if sharddata:GetWorldNum() == #worldlist then
			GenerateOnlinePacks()
		end
	end
end

local function CollectMissionPlayersReady()
	local able = false
	for k, v in ipairs(AllPlayers) do
		if v and v.components and not IsDeathOrAFK(v) and v.components.age:GetDisplayAgeInDays() >= CHALLENGE_MISSION then
			able = true
			break
		end
	end
	if IsSlaveMultiWorld() then
		PushShardData({ type = "onlinepacks_collect_mission_ready", data = able })
	elseif IsSingleMasterWorld() then
		mission_able = able
		GenerateMissions()
	else
		if able then
			mission_able = true
		end
		table.insert(worldlist, sharddata.worldid)
		if sharddata:GetWorldNum() == #worldlist then
			GenerateMissions()
		end
	end
end

local function CollectMissionsPlayers(data)
	local worldday = TheWorldState.cycles
	local readycount, count = 0, 0
	local runing = {}
	local scores = {}
	local collectready, collect
	collectready = function()
		if TheWorldState.cycles == worldday then
			readycount = readycount + 1
			for k, player in ipairs(AllPlayers) do
				if player and player.components and not IsDeathOrAFK(player) and player.components.age:GetDisplayAgeInDays() >= CHALLENGE_MISSION then
					local sayable = false
					if not player:HasTag("newmission") then
						local fx = SpawnPrefab("forcefieldfx")
						fx.entity:SetParent(player.entity)
						fx.Transform:SetPosition(0, 0, 0)
						player:AddTag("newmission")
						player:DoTaskInTime(5 - readycount * 0.5, function()
							player:RemoveTag("newmission")
							fx.kill_fx(fx)
						end)
						sayable = true
					end
					if sayable or readycount % 3 == 1 and player.components.talker then
						player.components.talker:Say(string.format(MY_STRINGS.mission_say[10], MY_STRINGS.mission_difficulty[data.difficulty], MY_STRINGS.mission_type[data.type]))
					end
				end
			end
			TheWorld:DoTaskInTime(0.5, function()
				if readycount >= 10 then
					collect()
				else
					collectready()
				end
			end)
		end
	end
	collect = function()
		if TheWorldState.cycles == worldday then
			count = count + 1
			local time = 3.5 - count * 0.5
			for k, player in ipairs(AllPlayers) do
				if player and player.components and not IsDeathOrAFK(player) and player.components.age:GetDisplayAgeInDays() >= CHALLENGE_MISSION then
					local x, y, z = player.Transform:GetWorldPosition()
					if runing[player.userid] == nil then
						runing[player.userid] = {}
						scores[player.userid] = {}
					end
					table.insert(runing[player.userid], { x, z })
					if count == 1 then
						scores[player.userid].score, scores[player.userid].damage = BattleScore(player)
					end
					if count <= 6 then
						local run = runing[player.userid]
						local len = #run
						if len == 1 or math.abs(run[len][1] - run[len - 1][1]) > 0.4 or math.abs(run[len][2] - run[len - 1][2]) > 0.4 then
							SpawnStuff(player, shadowversion and ("shadow_shield" .. count) or "shadow_despawn")
						end
						if math.floor(time) == time and player.components.talker then
							player.components.talker:Say(string.format(MY_STRINGS.mission_say[1], MY_STRINGS.mission_difficulty[data.difficulty], MY_STRINGS.mission_type[data.type], time))
						end
					end
				end
			end
			if count == 6 then
				local yesnum, nonum = 0, 0
				for k, info in pairs(runing) do
					if #info >= 4 then
						local run = {}
						local isrun = false
						for i = 1, #info - 1 do
							table.insert(run, math.max(math.abs(info[i][1] - info[i + 1][1]), math.abs(info[i][2] - info[i + 1][2])) > 0.4)
						end
						for i = 1, #run - 2 do
							if run[i] and run[i + 1] and run[i + 2] then
								isrun = true
								break
							end
						end
						if isrun then
							yesnum = yesnum + 1
							missionlist[k] = { accept = true, score = scores[k].score, damage = scores[k].damage }
						end
					end
					if missionlist[k] == nil then
						nonum = nonum + 1
						missionlist[k] = { accept = false, score = scores[k].score, damage = scores[k].damage }
					end
				end
				for k, info in pairs(runing) do
					missionlist[k].yesnum = yesnum
					missionlist[k].nonum = nonum
				end

				for k, player in ipairs(AllPlayers) do
					if missionlist[player.userid] and missionlist[player.userid].accept == false and player.components.talker then
						player.components.talker:Say(MY_STRINGS.mission_say[2], 2)
					end
				end
				if IsSlaveMultiWorld() then
					PushShardData({ type = "onlinepacks_collect_mission", data = missionlist })
					missionlist = {}
				elseif IsSingleMasterWorld() then
					StartMissions()
				else
					table.insert(worldlist, sharddata.worldid)
					if sharddata:GetWorldNum() == #worldlist then
						StartMissions()
					end
				end
			else
				TheWorld:DoTaskInTime(0.5, function()
					collect()
				end)
			end
		end
	end
	TheWorld:DoTaskInTime(0.5, function()
		collectready()
	end)
end

local function AcceptMissions(data)
	for k, player in ipairs(AllPlayers) do
		if player.userid == data.userid then
			local playername = player:GetDisplayName()
			local charactername = STRINGS.CHARACTER_NAMES[player.prefab] or player.prefab
			if player.components.talker then
				player.components.talker:Say(string.format(MY_STRINGS.mission_say[3], MY_STRINGS.mission_difficulty[data.difficulty], MY_STRINGS.mission_level[data.level], MY_STRINGS.mission_type[data.type], MISSION_WAIT), 5)
			end
			SpawnStuff(player, "wathgrithr_spirit")
			if ANNOUNCE_TIP then
				TheNet:Announce(string.format(MY_STRINGS.mission_msg[1], MY_STRINGS.mission_difficulty[data.difficulty], MY_STRINGS.mission_level[data.level], MY_STRINGS.mission_type[data.type], playername, charactername, MISSION_WAIT))
			end
		else
			for k2, v in ipairs(data.failer) do
				if player.userid == v then
					if player.components.talker then
						player.components.talker:Say(MY_STRINGS.mission_say[4], 2)
					end
					table.remove(data.failer, k2)
					break
				end
			end
		end
	end
end

local function SpawnMonster(player, monster_item, level, mission_data)
	local playeruserid = player.userid
	local playername = player:GetDisplayName()
	local playerday = player.components.age:GetDisplayAgeInDays()
	local monster = TrySpawn(player, monster_item.prefab, true)
	monster.components.health:SetMaxHealth(2500 * (mission_data.difficulty + 1))
	monster.components.health:SetCurrentHealth(math.min(1000 * (mission_data.difficulty + 1), level * mission_data.level * 4))

	-- 设置大小
	local currentscale = (monster.Transform:GetScale()) * 1.5
	monster.Transform:SetScale(currentscale, currentscale, currentscale)

	-- 设置击杀掉落
	if not monster.components.lootdropper then
		monster:AddComponent("lootdropper")
	end
	if monster.components.lootdropper.loot then
		monster.components.lootdropper:SetLoot(nil)
	end
	if monster.components.lootdropper.chanceloottable then
		monster.components.lootdropper:SetChanceLootTable(nil)
	end

	local item_type = mission_type[mission_data.type].prefab
	local item_fornum = mission_data.difficulty - 1 + math.ceil(PACKS_VALUE * 0.5)
	local item_num = 1
	if item_type == "resource" or item_type == "food" then
		item_num = 5 + mission_data.difficulty * mission_data.level * PACKS_VALUE
	end
	local item_list = {}
	for k, v in ipairs({ pack_items.normal, pack_items.rare }) do
		for k2, v2 in ipairs(v) do
			if v2.tag == item_type then
				table.insert(item_list, v2)
			end
		end
	end
	for i = item_fornum, 1, -1 do
		local item = SelectedRandom(item_list, function(v)
			if (v.minday == nil or playerday >= v.minday) and (v.maxday == nil or playerday <= v.maxday) then
				return true
			end
		end)
		for j = math.max(item_num * item.base, 1), 1, -1 do
			monster.components.lootdropper:AddChanceLoot(item.prefab, math.max(level * 0.01, 0.7))
		end
	end

	-- 锁定目标
	monster.components.combat:SuggestTarget(player)

	-- 摧毁围墙
	monster.Physics:SetCollisionCallback(oncollide)

	-- 定时删除
	monster:AddComponent("waveexautodelete")
	monster.components.waveexautodelete:SetPerishTime(MISSION_TIME)
	monster.components.waveexautodelete:StartPerishing()
	monster.components.waveexautodelete:SaveRemove()
	monster:AddTag("remove_monster")

	-- 自动回血
	local deltehealth = math.random(5) + level / 10 + mission_data.difficulty * math.min(playerday / 10, 15)
	deltehealth = math.ceil(math.min(deltehealth, mission_data.damage > 0 and mission_data.damage or 10))
	monster.dalta = mission_data.difficulty * mission_data.level * 3
	monster:DoPeriodicTask(1, function()
		if not monster.components.health:IsDead() and monster.dalta > 0 then
			monster.dalta = monster.dalta - 1
			monster.components.health:DoDelta(deltehealth)
			SpawnStuff(monster, "sanity_raise")
		end
	end)
	SpawnStuff(monster, "spawnlight_multiplayer")
	SpawnStuff(monster, "collapse_big")
	SpawnStuff(player, "collapse_small")

	local attacklist = {}
	local attackplayercount = 0
	local attackcount = 0
	local attackstuff = 0
	local difficulty_reverse = MISSION_DIFFICULTY_MAX - mission_data.difficulty
	monster:ListenForEvent("attacked", function(inst, data)
		if data.attacker.userid then
			attackcount = attackcount + 1
			if attacklist[data.attacker.userid] == nil then
				attacklist[data.attacker.userid] = true
				attackplayercount = attackplayercount + 1
				if attackplayercount > 1 and (playerday >= 10 or OneRandom(0.5)) then
					monster.dalta = monster.dalta + math.random(attackplayercount * 3)
				end
			end
			local newstuff = false
			if data.attacker:HasTag("forcefield") then
				data.attacker.components.sanity:DoDelta(1, 1)
			else
				if attackcount % (difficulty_reverse + 4) == 0 and (playerday >= 20 or OneRandom(0.5)) then
					if data.attacker.userid == playeruserid then
						data.attacker.components.hunger:DoDelta(-1, 1, true)
					end
					data.attacker.components.sanity:DoDelta(-data.attacker.components.sanity.max * 0.1, 1)
					SpawnStuff(data.attacker, "sanity_lower")
				end
				if playerday >= 15 and shadowversion and OneRandom(0.15 + attackplayercount * 0.01) then
					SpawnStuff(data.attacker, "fossilspike")
					newstuff = true
				elseif playerday >= 15 and shadowversion and OneRandom(0.15 + attackplayercount * 0.01) then
					SpawnStuff(data.attacker, "stalker_shield")
					newstuff = true
				elseif playerday >= 25 and OneRandom(0.05 + attackplayercount * 0.01) then
					SpawnStuff(data.attacker, "tornado")
					newstuff = true
				elseif attackplayercount > 1 and playerday >= 20 and attackcount % 5 == 0 and OneRandom(0.01 * attackplayercount) then
					monster.dalta = monster.dalta + 2
				elseif mission_data.difficulty >= 3 and playerday >= 35 and OneRandom(0.02 + attackplayercount * 0.01) then
					SpawnStuff(data.attacker, "spat_bomb")
					newstuff = true
				elseif mission_data.difficulty >= 2 and playerday >= 40 and OneRandom(0.02 + attackplayercount * 0.007) then
					SpawnStuff(data.attacker, "sporecloud")
					newstuff = true
				end
			end
			if newstuff then
				attackstuff = attackstuff + 1
				if mission_data.difficulty >= 2 and attackstuff % (5 * (difficulty_reverse + 1)) == 0 and OneRandom(0.5) then
					local playerday = data.attacker.components.age:GetDisplayAgeInDays()
					local item = SelectedRandom(item_list, function(v)
						if (v.minday == nil or playerday >= v.minday) and (v.maxday == nil or playerday <= v.maxday) then
							return true
						end
					end)
					monster.components.lootdropper:AddChanceLoot(item.prefab, 0.2 + attackplayercount * 0.1 + PACKS_VALUE * 0.1)
				end
			end
		end
	end)

	local data
	monster:ListenForEvent("Removed", function()
		if data == nil then
			data = { death = false, userid = playeruserid, name = playername, attack = attacklist, difficulty = mission_data.difficulty, level = mission_data.level }
			for i = 1, math.random(3) do
				SpawnStuff(monster, "tornado")
			end
			if playerday >= 20 then
				SpawnStuff(monster, "shadowmeteor")
			end
			if IsSlaveMultiWorld() then
				PushShardData({ type = "onlinepacks_mission_over", data = data })
			else
				MissionsOver(data)
			end
		end
	end)

	monster:ListenForEvent("death", function()
		if data == nil then
			data = { death = true, userid = playeruserid, name = playername, attack = attacklist, difficulty = mission_data.difficulty, level = mission_data.level }
			SpawnStuff(monster, "wathgrithr_spirit")
			if IsSlaveMultiWorld() then
				PushShardData({ type = "onlinepacks_mission_over", data = data })
			else
				MissionsOver(data)
			end
		end
	end)
end

local function GiveMissions(data)
	for k, player in ipairs(AllPlayers) do
		if player.userid == data.userid then
			player:DoTaskInTime(0.5, function()
				local day = player.components.age:GetDisplayAgeInDays()
				local item = SelectedRandom(pack_items.monster, function(v)
					local mindayable = v.minday == nil
					local maxdayable = v.maxday == nil
					if not mindayable then
						if data.difficulty == 1 then
							if day >= v.minday and v.minday <= 35 then
								mindayable = true
							end
						else
							if day >= v.minday then
								mindayable = true
							end
						end
					end
					if not maxdayable then
						if data.difficulty == 1 then
							maxdayable = true
						elseif data.difficulty == 2 then
							if day <= v.maxday or v.maxday >= 35 then
								maxdayable = true
							end
						else
							if day <= v.maxday then
								maxdayable = true
							end
						end
					end
					if mindayable and maxdayable then
						return true
					end
				end)
				if data.difficulty == 1 and item.base > 2 then
					item.base = 1.5 + (item.base - 2) * 0.2
				elseif data.difficulty == 2 and item.base > 3 then
					item.base = 2.5 + (item.base - 3) * 0.3
				end
				local level = math.ceil(math.max(math.min(day, 200), 75 + data.difficulty * 25) * item.base * (0.7 + data.yesnum * 0.2 + data.nonum * 0.08))
				SpawnMonster(player, item, level, data)
				if ANNOUNCE_TIP then
					TheNet:Announce(string.format(MY_STRINGS.mission_msg[2], MY_STRINGS.mission_difficulty[data.difficulty], MY_STRINGS.mission_level[data.level], MY_STRINGS.mission_type[data.type], level, pack_items_name[item.prefab], player:GetDisplayName(), MISSION_TIME))
				end
				if player.components.talker then
					player.components.talker:Say(MY_STRINGS.mission_say[5], 3)
				end
			end)
			if IsSlaveMultiWorld() then
				PushShardData({ type = "onlinepacks_mission", day = TheWorldState.cycles })
			else
				mission_world = "1"
				OnMissions()
			end
			return
		end
	end
	if IsSlaveMultiWorld() then
		PushShardData({ type = "onlinepacks_mission" })
	elseif IsSingleMasterWorld() then
		OnMissions()
	else
		table.insert(worldlist, sharddata.worldid)
		if sharddata:GetWorldNum() == #worldlist then
			OnMissions()
		end
	end
end

local function GiveMissionPacks(data)
	for k, player in ipairs(AllPlayers) do
		if not IsDeathOrAFK(player) then
			local playerday = player.components.age:GetDisplayAgeInDays()
			if data.userid == player.userid then
				if data.death then
					player.components.hunger:DoDelta(player.components.hunger.max * 0.3 * data.level, 1, true)
					player.components.sanity:DoDelta(player.components.sanity.max * 0.3 * data.level, 1)
					player.components.health:DoDelta(player.components.health.maxhealth * 0.4 * data.level)
					if data.difficulty >= 2 then
						local random_item = SelectedRandom(data.difficulty == 2 and pack_items.normal or pack_items.rare, function(v)
							if v.tag ~= "food" and (v.minday == nil or playerday >= v.minday - 5) and (v.maxday == nil or playerday <= v.maxday) then
								return true
							end
						end)
						local count = data.difficulty == 2 and math.ceil(random_item.base * 5) or 1
						Spawn(player, random_item, count)
						if player.components.talker then
							player.components.talker:Say(string.format(MY_STRINGS.mission_say[6], pack_items_name[random_item.prefab], count), 3)
						end
					end
					SpawnStuff(player, "wathgrithr_spirit")
				else
					player.components.hunger:DoDelta(-player.components.hunger.max * 0.2 * data.level, 5, true)
					player.components.sanity:DoDelta(-player.components.sanity.max * 0.2 * data.level, 5)
					SpawnStuff(player, "sanity_lower")
					SpawnStuff(player, "shadowmeteor")
					if player.components.talker then
						player.components.talker:Say(MY_STRINGS.mission_say[8], 3)
					end
				end
			elseif data.attack[player.userid] then
				if data.death then
					player.components.hunger:DoDelta(player.components.hunger.max * 0.1 * data.level, 1, true)
					player.components.sanity:DoDelta(player.components.sanity.max * 0.1 * data.level, 1)
					player.components.health:DoDelta(player.components.health.maxhealth * 0.1 * data.level)
					if data.difficulty >= 2 then
						local random_item = SelectedRandom(pack_items.normal, function(v)
							if (v.minday == nil or playerday >= v.minday) and (v.maxday == nil or playerday <= v.maxday) then
								return true
							end
						end)
						local count = math.random(data.difficulty * data.level)
						Spawn(player, random_item, count)
						if player.components.talker then
							player.components.talker:Say(string.format(MY_STRINGS.mission_say[7], pack_items_name[random_item.prefab], count), 3)
						end
					end
					SpawnStuff(player, "wathgrithr_spirit")
				else
					player.components.sanity:DoDelta(-player.components.sanity.max * 0.2 * data.level, 5)
					SpawnStuff(player, "sanity_lower")
					if player.components.talker then
						player.components.talker:Say(MY_STRINGS.mission_say[9], 3)
					end
				end
			end
		end
	end
end

local function InitOnlinePacks(src, inst)
	TheWorld = inst
	TheWorldState = inst.state
	desclist = Desc()
	for k, type in pairs(pack_items) do
		local removelist = {}
		for i, item in ipairs(type) do
			if k ~= "buff" then
				if item.tag == "food" then
					pack_items[k][i].chance = item.chance / 3
				end
				local name = DescriptionInit(item)
				if name == nil then
					table.insert(removelist, i)
				else
					pack_items_name[item.prefab] = name
				end
			end
			if PACKS_VALUE ~= 1 then
				if item.minday then
					pack_items[k][i].minday = math.max(math.ceil(item.minday + (1 - PACKS_VALUE) * 3), 0)
				end
				pack_items[k][i].base = item.base * PACKS_VALUE
			end
		end
		for i = #removelist, 1, -1 do
			table.remove(pack_items[k], removelist[i])
		end
	end
	local death_event = function(player, text)
		if not deathlist[player.userid] then
			deathlist[player.userid] = true
			if IsMoreMultiWorld() then
				PushShardData({ type = "onlinepacks_death", data = TheWorld.ismastershard and deathlist or player.userid })
			end
			if ANNOUNCE_TIP and RECORD_DEATH then
				TheNet:Announce(string.format(text, player:GetDisplayName(), STRINGS.CHARACTER_NAMES[player.prefab] or player.prefab))
			end
		end
	end
	inst:ListenForEvent("ms_playerjoined", function(world, player)
		player:ListenForEvent("death", function()
			death_event(player, MY_STRINGS.death_msg[1])
		end)
	end)
	inst:ListenForEvent("ms_playerdespawnanddelete", function(world, player)
		death_event(player, MY_STRINGS.death_msg[2])
	end)
	if TheWorld.ismastershard or not ismultiworld then
		local Old_Networking_RollAnnouncement = _G.Networking_RollAnnouncement
		_G.Networking_RollAnnouncement = function(userid, name, prefab, colour, rolls, max)
			if CHALLENGE_MISSION_ROLL > 0 and rolls[1] >= CHALLENGE_MISSION_ROLL then
				if mission_status == nil or mission_status == "ready" or mission_status == "load" then
					local playerage = 0
					for k, player in ipairs(TheNet:GetClientTable()) do
						if player.userid == userid then
							playerage = player.playerage
							break
						end
					end
					if CHALLENGE_MISSION ~= 0 and playerage > CHALLENGE_MISSION and TheWorldState.cycles - last_mission_day >= CHALLENGE_MISSION_CD then
						worldlist = {}
						mission_able = false
						mission_status = "roll"
						if ANNOUNCE_TIP then
							TheWorld:DoTaskInTime(0.5, function()
								TheNet:Announce(string.format(MY_STRINGS.mission_msg[5], name))
							end)
						end
						TheWorld:DoTaskInTime(1, function()
							if mission_status == "roll" then
								mission_status = "generate"
								if IsMoreMultiWorld() then
									PushShardData({ type = "onlinepacks_collect_mission_ready", tag = "mission" })
								end
								CollectMissionPlayersReady()
							end
						end)
					end
				end
			end
			Old_Networking_RollAnnouncement(userid, name, prefab, colour, rolls, max)
		end
		local items_type = {
			{ type = "null", chance = 0.05, minday = 0 },
			{ type = "normal", chance = NORMAL_ITEMS and 2.0 or 0, minday = 0 },
			{ type = "rare", chance = RARE_ITEMS ~= 0 and RARE_ITEMS ~= 3 and 0.15 * (0.4 + 0.4 * PACKS_VALUE) or 0, minday = 5 },
			{ type = "building", chance = RARE_ITEMS ~= 0 and RARE_ITEMS ~= 2 and 0.15 * (0.4 + 0.4 * PACKS_VALUE) or 0, minday = 5 },
			{ type = "buff", chance = BUFF_ITEMS and 0.4 * (0.5 + 0.4 * PACKS_VALUE) or 0, minday = 5 },
		}
		local cyclescount = 0
		inst:ListenForEvent("cycleschanged", function(world, day)
			local onlinenum = #TheNet:GetClientTable()
			if not TheNet:GetServerIsClientHosted() then
				onlinenum = onlinenum - 1
			end
			if onlinenum ~= 0 then
				if ismultiworld and (not TheNet:GetServerIsClientHosted() or cyclescount > 0) or
						not ismultiworld and cyclescount > 2 then
					if IsMoreMultiWorld() then
						PushShardData({ type = "onlinepacks_collect", tag = "pack" })
					end
					playerlist = {}
					worldlist = {}
					missionlist = {}
					mission_able = false
					mission_delay_able = true
					mission_world = nil
					TheWorld:DoTaskInTime(0.5, function()
						CollectPlayers()
					end)
				else
					cyclescount = cyclescount + 1
				end
			end
		end)
		GenerateOnlinePacks = function()
			local online_items = {}
			local wait_items = {}
			local worldday = TheWorldState.cycles
			for k, v in ipairs(playerlist) do
				if cdlist[v.userid] == nil then
					cdlist[v.userid] = 0
				end
				if not NORMAL_ITEMS and RARE_ITEMS == 0 and not BUFF_ITEMS or
						(v.day - cdlist[v.userid] < PACKS_CD or RECORD_DEATH and deathlist[v.userid]) then
					--
				elseif NORMAL_ITEMS and v.day % 10 == 0 then
					local value
					if v.day % 100 == 0 then
						value = math.max(math.random(v.day), math.random(50), 30)
						value = math.min(50, value)
					else
						value = math.min(math.random(v.day), 10)
						value = math.max(20, value)
					end
					online_items[#online_items + 1] = { worldday = worldday, day = v.day, userid = v.userid, type = "big", count = math.ceil(value * PACKS_VALUE) }
				else

					local random_item = SelectedRandom(items_type, function(val)
						if v.day >= val.minday then
							return true
						else
							return false
						end
					end)
					local random_type = random_item.type
					local value = 0
					if random_type == "normal" then
						value = math.min(v.day * 0.6, math.random(v.day), 4)
					elseif random_type == "rare" or random_type == "building" then
						value = 1
					elseif random_type == "buff" then
						value = math.min(v.day * 0.8, math.random(v.day), 40)
					end
					local item = { worldday = worldday, day = v.day, userid = v.userid, type = random_type, count = math.ceil(value) }
					if item.type == "null" or item.type == "normal" then
						online_items[#online_items + 1] = item
					else
						item.wait = math.random(30, TUNING.TOTAL_DAY_TIME * 0.6 + 30)
						wait_items[#wait_items + 1] = item
					end
				end
			end
			if IsMoreMultiWorld() then
				PushShardData({ type = "onlinepacks_give", tag = "pack", data = online_items })
			end
			GiveOnlinePacks(online_items)
			for k, v in ipairs(wait_items) do
				TheWorld:DoTaskInTime(v.wait, function()
					if TheWorldState.cycles == v.worldday and v.day - cdlist[v.userid] >= PACKS_CD and (not RECORD_DEATH or not deathlist[v.userid]) then
						v.wait = nil
						if IsMoreMultiWorld() then
							PushShardData({ type = "onlinepacks_giveone", tag = "pack", data = v })
						end
						GiveOnePacks(v)
					end
				end)
			end
			mission_status = nil
			if CHALLENGE_MISSION ~= 0 and worldday - last_mission_day - delay_mission_day >= CHALLENGE_MISSION_CD then
				worldlist = {}
				mission_able = false
				mission_status = "ready"
				TheWorld:DoTaskInTime(math.max(math.random(TUNING.TOTAL_DAY_TIME * 0.5), MISSION_PUBLISH_WAIT), function()
					if TheWorldState.cycles == worldday and mission_status == "ready" then
						mission_status = "generate"
						if IsMoreMultiWorld() then
							PushShardData({ type = "onlinepacks_collect_mission_ready", tag = "mission" })
						end
						CollectMissionPlayersReady()
					end
				end)
			end
		end
		GenerateMissions = function()
			if mission_able then
				worldlist = {}
				missionlist = {}
				local type
				type, last_mission_type = WeightedRandom(mission_type)
				last_mission_difficulty = CHALLENGE_MISSION_DIFFICULTY > 0 and CHALLENGE_MISSION_DIFFICULTY or math.random(MISSION_DIFFICULTY_MAX)
				local data = { type = last_mission_type, difficulty = last_mission_difficulty }
				if IsMoreMultiWorld() then
					PushShardData({ type = "onlinepacks_collect_mission", data = data, tag = "mission" })
				end
				CollectMissionsPlayers(data)
			else
				mission_status = nil
			end
		end
		StartMissions = function()
			local worldday = TheWorldState.cycles
			local missions_yes = {}
			local missions_no = {}
			for k, v in pairs(missionlist) do
				table.insert(v.accept and missions_yes or missions_no, k)
			end
			if #missions_yes > 0 or #missions_no > 0 then
				UpdateMissionType(last_mission_type, #missions_yes / (#missions_yes + #missions_no))
			end
			if #missions_yes > 0 then
				local index = math.random(#missions_yes)
				local userid = missions_yes[index]
				table.remove(missions_yes, index)
				local level = 1
				if missionlist[userid].damage > 40 and missionlist[userid].score > 105 then
					level = math.random(2, 3)
				elseif missionlist[userid].damage > 25 and missionlist[userid].score > 80 then
					level = math.random(2)
				end
				local damage = missionlist[userid].damage
				local yesnum = missionlist[userid].yesnum
				local nonum = missionlist[userid].nonum
				local data = { userid = userid, failer = missions_yes, type = last_mission_type, difficulty = last_mission_difficulty, level = level }
				local key = math.random(9999)
				mission_key = key
				mission_status = "load"
				if IsMoreMultiWorld() then
					PushShardData({ type = "onlinepacks_mission_accept", tag = "mission", data = data })
				end
				AcceptMissions(data)
				TheWorld:DoTaskInTime(MISSION_WAIT / 3, function()
					if TheWorldState.cycles == worldday and mission_status == "load" and mission_key == key then
						mission_status = "load_noroll"
					end
				end)
				TheWorld:DoTaskInTime(MISSION_WAIT, function()
					if TheWorldState.cycles == worldday and mission_status == "load_noroll" and mission_key == key then
						worldlist = {}
						mission_world = nil
						mission_status = "on"
						local data = { userid = userid, type = last_mission_type, difficulty = last_mission_difficulty, level = level, damage = damage, yesnum = yesnum, nonum = nonum }
						if IsMoreMultiWorld() then
							PushShardData({ type = "onlinepacks_mission", tag = "mission", data = data })
						end
						GiveMissions(data)
					end
				end)
			elseif #missions_no > 0 and mission_delay_able then
				mission_delay_able = false
				delay_mission_day = delay_mission_day + 2
			end
			if mission_status ~= "load" then
				mission_status = nil
			end
		end
		OnMissions = function()
			delay_mission_day = 0
			if mission_world then
				last_mission_day = TheWorldState.cycles
			else
				last_mission_day = TheWorldState.cycles - CHALLENGE_MISSION_CD
				mission_status = nil
			end
		end
		MissionsOver = function(data)
			mission_status = "over"
			local count = 0
			for k, v in pairs(data.attack) do
				count = count + 1
			end
			if data.death then
				cdlist[data.userid] = 0
				TheNet:Announce(string.format(MY_STRINGS.mission_msg[3], data.name, count))
			else
				cdlist[data.userid] = (cdlist[data.userid] or 0) + 1
				TheNet:Announce(string.format(MY_STRINGS.mission_msg[4], data.name, count))
			end
			if IsMoreMultiWorld() then
				PushShardData({ type = "onlinepacks_mission_give", tag = "mission", data = data })
			end
			GiveMissionPacks(data)
		end
	end
end

local OnShardData = ismultiworld and function(data)
	if sharddata.ismastershard then
		if data.type == "onlinepacks_collect" then
			for k, v in ipairs(data.data) do
				local isnew = true
				for k2, player in ipairs(playerlist) do
					if player.userid == v.userid then
						isnew = false
						break
					end
				end
				if isnew then
					table.insert(playerlist, v)
				end
			end
			table.insert(worldlist, data.worldid)
			if sharddata:GetWorldNum() == #worldlist then
				GenerateOnlinePacks()
			end
		elseif data.type == "onlinepacks_collect_mission_ready" then
			if data.data == true then
				mission_able = true
			end
			table.insert(worldlist, data.worldid)
			if sharddata:GetWorldNum() == #worldlist then
				GenerateMissions()
			end
		elseif data.type == "onlinepacks_collect_mission" then
			for k, v in pairs(data.data) do
				local isnew = true
				for k2, missions in pairs(missionlist) do
					if k == k2 then
						isnew = false
						break
					end
				end
				if isnew or v.accept then
					missionlist[k] = v
				end
			end
			table.insert(worldlist, data.worldid)
			if sharddata:GetWorldNum() == #worldlist then
				StartMissions()
			end
		elseif data.type == "onlinepacks_give" then
			for k, v in ipairs(data.data) do
				if v.pack == "aid" then
					cdlist[v.userid] = (cdlist[v.userid] or 0) + 1
				elseif v.pack == "other" then
					cdlist[v.userid] = v.day
				end
			end
		elseif data.type == "onlinepacks_giveone" then
			TheWorld:DoTaskInTime(60, function()
				local pack = data.data
				if TheWorldState.cycles == pack.worldday and (not RECORD_DEATH or not deathlist[pack.userid]) then
					if IsMoreMultiWorld() then
						PushShardData({ type = "onlinepacks_giveone", tag = "pack", data = pack })
					end
					GiveOnePacks(pack)
				end
			end)
		elseif data.type == "onlinepacks_death" then
			deathlist[data.data] = true
			PushShardData({ type = "onlinepacks_death", data = deathlist })
		elseif data.type == "onlinepacks_mission" then
			if mission_world == nil then
				if data.data == TheWorldState.cycles then
					mission_world = data.worldid
					OnMissions()
				else
					table.insert(worldlist, data.worldid)
					if sharddata:GetWorldNum() == #worldlist then
						OnMissions()
					end
				end
			end
		elseif data.type == "onlinepacks_mission_over" then
			MissionsOver(data.data)
		end
	else
		if data.type == "onlinepacks_collect" then
			CollectPlayers()
		elseif data.type == "onlinepacks_collect_mission_ready" then
			CollectMissionPlayersReady()
		elseif data.type == "onlinepacks_collect_mission" then
			CollectMissionsPlayers(data.data)
		elseif data.type == "onlinepacks_give" then
			GiveOnlinePacks(data.data)
		elseif data.type == "onlinepacks_giveone" then
			GiveOnePacks(data.data)
		elseif data.type == "onlinepacks_death" then
			deathlist = data.data
		elseif data.type == "onlinepacks_mission_accept" then
			AcceptMissions(data.data)
		elseif data.type == "onlinepacks_mission" then
			GiveMissions(data.data)
		elseif data.type == "onlinepacks_mission_give" then
			GiveMissionPacks(data.data)
		end
	end
end or nil

local AddShard = ismultiworld and function(inst)
	inst:AddComponent("shard_onlinepacks")
	local master_event = "onlinepacks_master_update"
	local slave_event = "onlinepacks_slave_update"
	local shardkey
	if sharddata.ismastershard then
		PushShardData = function(data)
			inst:PushEvent(master_event, data)
		end
		if sharddata_member then
			sharddata_member.master_callback = OnShardData
		else
			shardkey = sharddata:Register(modname, OnShardData)
			PushShardData({ type = "shard_key", tag = "sys", key = shardkey })
		end
	else
		PushShardData = sharddata_member and function(data)
			sharddata_member.slave_callback(data)
		end or function(data)
			sharddata:Put(shardkey, modname, data)
		end
		local OnShardDataDirty = sharddata_member and function(src, data)
			OnShardData(data)
		end or function(src, data)
			if shardkey == nil and data.type == "shard_key" then
				shardkey = data.key
			else
				OnShardData(data)
			end
		end
		inst:ListenForEvent(slave_event, OnShardDataDirty, inst)
	end
	if sharddata_member then
		sharddata_member.master_event = master_event
		sharddata_member.slave_event = slave_event
		sharddata_member.init(inst)
	end
end or nil

local function OnWorld(inst)
	if TheWorld.ismastershard or not ismultiworld then
		local Old_OnSave = inst.OnSave
		inst.OnSave = function(inst, data)
			if sharddata then
				sharddata:Clean()
			end
			if deathlist ~= nil then
				data.onlinepacks = {
					["deathlist"] = deathlist,
					["cdlist"] = cdlist,
				}
			end
			if Old_OnSave ~= nil then
				return Old_OnSave(inst, data)
			end
		end
		local Old_OnLoad = inst.OnLoad
		inst.OnLoad = function(inst, data)
			if data ~= nil and data.onlinepacks ~= nil then
				deathlist = data.onlinepacks.deathlist
				cdlist = data.onlinepacks.cdlist
			end
			if Old_OnLoad ~= nil then
				return Old_OnLoad(inst, data)
			end
		end
	end
	local item = SpawnPrefab("shadow_shield1")
	if item then
		shadowversion = true
		item:Remove()
	end
end

AddPrefabPostInit("world", OnWorld)
AddPrefabPostInit("shard_network", AddShard)
AddComponentPostInit("playerspawner", InitOnlinePacks)
