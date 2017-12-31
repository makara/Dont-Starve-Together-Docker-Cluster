return Class(function(self, inst)

	assert(TheWorld.ismastersim, "Shard_OnlinePacks should not exist on client")

	--Public
	self.inst = inst

	--Private
	local _ismastershard = TheWorld.ismastershard
	local _segs = {}

	--Network
	local _other = net_string(inst.GUID, "shard_onlinepacks._other", "onlinepacks_dirty")
	local _mission = net_string(inst.GUID, "shard_onlinepacks._mission", "onlinepacks_dirty")
	local _pack = net_string(inst.GUID, "shard_onlinepacks._pack", "onlinepacks_dirty")
	local _death = net_string(inst.GUID, "shard_onlinepacks._death", "onlinepacks_dirty")
	local _clean = net_string(inst.GUID, "shard_onlinepacks._clean", "onlinepacks_dirty")
	local _sys = net_string(inst.GUID, "shard_onlinepacks._sys", "onlinepacks_dirty")

	local OnVarUpdate = _ismastershard and function(src, data)
		local netstr = json.encode(data)
		if data.type == "shard_clean" then
			_clean:set(netstr)
		elseif data.type == "onlinepacks_death" then
			_death:set(netstr)
		elseif data.tag then
			if data.tag == "sys" then
				_sys:set(netstr)
			elseif data.tag == "pack" then
				_pack:set(netstr)
			elseif data.tag == "mission" then
				_mission:set(netstr)
			end
		else
			_other:set(netstr)
		end
	end or nil

	local OnVarDirty = not _ismastershard and function()
		local dirty = {
			_other = _other:value(),
			_mission = _mission:value(),
			_pack = _pack:value(),
			_death = _death:value(),
			_clean = _clean:value(),
			_sys = _sys:value(),
		}
		for k, v in pairs(dirty) do
			if _segs[k] ~= v then
				_segs[k] = v
				if v ~= "" then
					local data = json.decode(v)
					data.tag = nil
					inst:PushEvent("onlinepacks_slave_update", data)
				end
			end
		end
	end or nil

	if _ismastershard then
		--Register master shard events
		inst:ListenForEvent("onlinepacks_master_update", OnVarUpdate, inst)
	else
		--Register network variable sync events
		inst:ListenForEvent("onlinepacks_dirty", OnVarDirty)
	end
end)