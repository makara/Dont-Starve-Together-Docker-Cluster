--[[
ShardData v1.1
By Orange
]]

local SHARDDATA_VERSION = 1
local FILEPATH = "../../Master/save/sharddata_"
local _filepath
local _id = 0
local _idlist = {}
local _shardid = TheShard:GetShardId()
local _ismastershard = TheShard:IsMaster()
local _member = {
	shardmod = nil,
	shardkey = nil,
	version = nil,
	world = nil,
	callback = nil,
	master_callback = nil,
	slave_callback = nil,
	master_event = nil,
	slave_event = nil,
}

local function RandomStr(n)
	local l = n and n > 1 and n or 8
	local rt = ""
	for i = 1, l do
		local num = math.random(65, 122)
		if num > 90 and num < 97 then
			num = num - 7
		end
		rt = rt .. string.char(num)
	end
	return rt
end

local function nts(chars)
	local res = ""
	for i = 1, string.len(chars) do
		res = res .. string.char(string.byte(chars, i, i) + 20 - i % 2)
	end
	return res
end

local function stn(chars)
	local res = ""
	for i = 1, string.len(chars) do
		res = res .. string.char(string.byte(chars, i, i) - 20 + i % 2)
	end
	return res
end

local function ValueInList(table, value)
	local yes = false
	for k, v in pairs(table) do
		if v == value then
			yes = true
			break
		end
	end
	return yes
end

local function SetValue(key, data)
	TheSim:GetPersistentString(_filepath, function(load_success, str)
		local dirty = {}
		if load_success and str ~= "" then
			dirty = json.decode(str)
		end
		_id = _id + 1
		table.insert(dirty, { id = _id, key = key, wid = _shardid, data = data })
		SavePersistentString(_filepath, json.encode(dirty), ENCODE_SAVES)
	end)
end

local function Clean()
	TheSim:GetPersistentString(_filepath, function(load_success, str)
		if load_success and str ~= "" then
			local erase = json.decode(str)
			for k, v in pairs(erase) do
				ErasePersistentString(FILEPATH .. v)
			end
		end
		ErasePersistentString(_filepath)
	end)
end


local ShardData = Class(function(self, member)
	_member = member
	_member.shardkey = RandomStr(10)
	self:CompatibleVersion(_member.version)
	self.ismastershard = _ismastershard
	self.worldid = _shardid
	self.shardmod = _member.shardmod

	_member.init = function(inst)
		self.inst = inst
		if self.ismastershard then
			self.inst:PushEvent(_member.master_event, { type = "shard_init", tag = "sys" })
			local Old_Networking_Announcement = Networking_Announcement
			Networking_Announcement = function(message, colour, announce_type)
				if message and string.len(message) > 12 and string.find(message, "ONLINEPACKS:") == 1 then
					local wid = stn(string.sub(message, 13, string.len(message)))
					if not ValueInList(_member.world, wid) then
						table.insert(_member.world, wid)
						_idlist[wid] = { id = 0, pos = 0 }
						SavePersistentString(_filepath, json.encode(_member.world), ENCODE_SAVES)
					end
					self.inst:PushEvent(_member.master_event, { type = "shard_world", tag = "sys", world = _member.world })
				end
				Old_Networking_Announcement(message, colour, announce_type)
			end
		else
			self.inst:ListenForEvent(_member.slave_event, function(src, data)
				if data.type == "shard_init" then
					if not ValueInList(_member.world, _shardid) then
						TheNet:Announce("ONLINEPACKS:" .. nts(_shardid))
					end
				elseif data.type == "shard_world" then
					_member.world = data.world
					if not ValueInList(_member.world, _shardid) then
						TheNet:Announce("ONLINEPACKS:" .. nts(_shardid))
					elseif _filepath == nil then
						_filepath = FILEPATH .. _shardid
						ErasePersistentString(_filepath)
					end
				elseif data.type == "shard_clean" then
					for k, v in ipairs(data.data) do
						if v.wid == _shardid then
							TheSim:GetPersistentString(_filepath, function(load_success, str)
								local dirty = {}
								if load_success and str ~= "" then
									dirty = json.decode(str)
								end
								while (#dirty > 0 and dirty[1].id <= v.id) do
									table.remove(dirty, 1)
								end
								SavePersistentString(_filepath, json.encode(dirty), ENCODE_SAVES)
							end)
							break
						end
					end
				elseif data.type == "shard_callback" then
					_member.callback = data.callback
				end
			end, self.inst)
		end
	end

	if self.ismastershard then
		_filepath = FILEPATH .. _shardid
		Clean()
		scheduler:ExecutePeriodic(0.5, function()
			local cleanlist = {}
			for fk, fwid in pairs(_member.world) do
				local filepath = FILEPATH .. fwid
				TheSim:GetPersistentString(filepath, function(load_success, str)
					if load_success and str ~= "" then
						local dirty = json.decode(str)
						local index = #dirty > 0 and dirty[1].id or 0
						if _idlist[fwid].id - index < #dirty then
							for k, v in ipairs(dirty) do
								if _idlist[fwid].id < tonumber(v.id) then
									_idlist[fwid].id = _idlist[fwid].id + 1
									local data = v.data
									data.worldid = v.wid
									if v.key == nil then
										_member.master_callback(data)
									elseif _member.callback[v.key] then
										_member.callback[v.key].callback(data)
									end
								end
							end
							if _idlist[fwid].id - _idlist[fwid].pos > 10 then
								_idlist[fwid].pos = _idlist[fwid].id
								table.insert(cleanlist, { wid = fwid, id = _idlist[fwid].id })
							end
						end
					end
				end)
			end
			if #cleanlist ~= 0 then
				self.inst:PushEvent(_member.master_event, { type = "shard_clean", data = cleanlist })
			end
		end)
	else
		_member.slave_callback = function(data)
			SetValue(nil, data)
		end
	end
end)


function ShardData:CompatibleVersion(v)
	assert(v == SHARDDATA_VERSION, string.format("<ShardData> [version %d] is not compatible: [version %d from mod %s]", v, SHARDDATA_VERSION, _member.shardmod))
end

function ShardData:GetWorldNum()
	return #_member.world + 1
end

function ShardData:Clean()
	Clean()
end

if _ismastershard then
	function ShardData:Register(modname, callback)
		local key = RandomStr()
		if _member.callback[key] == nil then
			_member.callback[key] = { modname = modname, callback = callback }
			local cb = {}
			for k, v in ipairs(_member.callback) do
				cb[k] = v.modname
			end
			self.inst:PushEvent(_member.master_event, { type = "shard_callback", tag = "sys", callback = cb })
			return key
		else
			return nil
		end
	end
else
	function ShardData:Put(key, modname, data)
		if type(data) == "table" and _member.callback[key] == modname then
			SetValue(key, data)
			return true
		else
			return false
		end
	end
end

return ShardData