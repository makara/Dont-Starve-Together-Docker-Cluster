-- Copyright (C) 2018 Mobbstar

-- This software library changes snow and spider creep to be tile-based and modifiable
-- It includes a prefab file called "tilestatecore.lua" for storing data between sessions
-- It includes anim files "webtile.zip" and "snowtile.zip" for the basegame states

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
-- GNU General Public License for more details.

-- Tilestate is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- You should have received a copy of the GNU General Public License
-- along with Tilestate. If not, see <http://www.gnu.org/licenses/>.

-- For examples of how to use this library, see the 'Basegame states' at the end

local THIS_VERSION = 5 --INCREMENT THIS NUMBER IF EDITING THE FILE, ONLY EDIT IF TRULY NECESSARY
if GLOBAL.rawget(GLOBAL, "TILESTATE_VERSION") ~= nil then
	if GLOBAL.TILESTATE_VERSION >= THIS_VERSION then
		return -- don't load twice, don't load inferior versions
	end
	-- this is the newer version, load and override
end
GLOBAL.TILESTATE_VERSION = THIS_VERSION

table.insert(PrefabFiles,"tilestatecore")

table.insert(Assets,GLOBAL.Asset("ANIM","anim/webtile.zip"))
--table.insert(Assets,GLOBAL.Asset("ANIM","anim/snowtile.zip"))

local tiledata = {}
local states = {}
local mainent

function GLOBAL.RegisterTileState(key, persists, anim, sort, ondelta, ntextures, randomtextures, scale, prefab)
	if not key or states[key] or key == "x" or key == "y" then
		print("failed attempt to register TileState",key)
		return
	end
	
	if persists == nil then persists = true end
	
	states[key] = {
		persists = persists,
		anim = anim,
		sort = sort,
		ondelta = ondelta,
		ntex = ntextures,
		randtex = randomtextures,
		scale = scale and .5 or nil, --since this is a botch-job for now, hardcode to these two possible values
		prefab = prefab,
	}
end

function GLOBAL.GetTileState(x,y,key)
	-- if states[key].scale == .5 and (math.floor(x) == x or math.floor(y) == y) then
		-- for xa = x+.25, x+.75, .5 do
		-- for ya = y+.25, y+.75, .5 do
			-- if tiledata[xa] and tiledata[xa][ya] then
				-- return tiledata[xa][ya][key]
			-- end
		-- end
		-- end
	-- else
		if tiledata[x] and tiledata[x][y] then
			return tiledata[x][y][key]
		end
	-- end
end

local function createvisual(x,y,data,anim)
	local inst = data.prefab and GLOBAL.SpawnPrefab(data.prefab) or GLOBAL.CreateEntity()

	if not inst.Transform then
		inst.entity:AddTransform()
	end
	if not inst.AnimState then
		inst.entity:AddAnimState()
	end

	local w, h = GLOBAL.TheWorld.Map:GetSize()
	inst.Transform:SetPosition((x - w/2) * GLOBAL.TILE_SCALE, 0, (y - h/2) * GLOBAL.TILE_SCALE)

	inst.AnimState:SetBuild(data.anim)
	inst.AnimState:SetBank(data.anim)
	inst.AnimState:PlayAnimation(anim)

	inst.AnimState:SetOrientation(GLOBAL.ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(GLOBAL.LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(data.sort or 2)

    inst:AddTag("NOCLICK")
    inst:AddTag("FX")
    inst.persists = inst.persists or false

	return inst
end

local function gettexture(x,y,ntex,randtex)
	if ntex then
		if randtex then
			return math.random(ntex)
		else
			--print("TEXTURE FOR",x,y,"IS", ((x-1)%ntex + 1) + ntex * ((y-1)%ntex) )
			return ((x-1)%ntex + 1) + ntex * ((y-1)%ntex)
		end
	end
	return ""
end

-- These are for bleed
local offset = {
	{-1, 1}, {0, 1}, {1, 1},
	{-1, 0},         {1, 0},
	{-1,-1}, {0,-1}, {1,-1},
}
--w e r
--s   f
--x c v
local offset1 = {
	{0,-1,"e"},{1,0,"f"},{0,1,"c"},{-1,0,"s"},
}
local offset2 = {
	{-1,-1,"w","e","s"},{1,-1,"r","e","f"},{1,1,"v","f","c"},{-1,1,"x","c","s"},
}

local function updatebleed(x,y,key)
	local tile = GLOBAL.GetTileState(x,y,key)
	local anim = ""
	local scale = states[key].scale or 1
	for i, off in ipairs(offset1) do
		local xb = x + off[1] * scale
		local yb = y + off[2] * scale
		if GLOBAL.GetTileState(xb,yb,key) and GLOBAL.GetTileState(xb,yb,key).val ~= nil then
			anim = anim .. off[3]
		end
	end
	for i, off in ipairs(offset2) do
		local xb = x + off[1] * scale
		local yb = y + off[2] * scale
		-- when a side is available, the corners are irrelevant
		if not string.find(anim, off[4]) and not string.find(anim, off[5])
		and GLOBAL.GetTileState(xb,yb,key) and GLOBAL.GetTileState(xb,yb,key).val ~= nil then
			anim = anim .. off[3]
		end
	end
	if anim ~= "" then
		if not tile then
			tiledata[x] = tiledata[x] or {}
			tiledata[x][y] = tiledata[x][y] or {}
			tiledata[x][y][key] = tiledata[x][y][key] or {}
			tile = tiledata[x][y][key]
		end
		if tile.inst and tile.inst:IsValid() then
			tile.inst.AnimState:PlayAnimation(anim .. gettexture(x,y,states[key].ntex,states[key].randtex))
		else
			tile.inst = createvisual(x,y, states[key],
				anim .. gettexture(x,y,states[key].ntex,states[key].randtex))
		end
	elseif tile and tile.inst then
		tile.inst:Remove()
		tiledata[x][y][key] = nil
	end
end

local function bleednearby(x,y,key)
	local scale = states[key].scale or 1
	-- check all eight surrounding tiles for this key
	-- if the key has NO value or is NOT there, it should probably bleed instead
	for i, off in pairs(offset) do
		local xa = x + off[1] * scale 
		local ya = y + off[2] * scale
		local tile = GLOBAL.GetTileState(xa,ya,key)
		if not (tile and tile.val ~= nil) then
			updatebleed(xa,ya,key)
		end
	end
end

local function newtilevisual(x,y,key)
	tiledata[x][y][key].inst = createvisual(x,y, states[key],
		"full".. gettexture(x,y,states[key].ntex,states[key].randtex))
	bleednearby(x,y,key)
end

function GLOBAL.SetTileState(x,y,key,val)
	if not x or not y or not key then print("invalid use of TileState",key) return end
	if not states[key] then print("failed attempt to set unregistered TileState", key) return end
	
	if val ~= nil then
		-- create tile entry if needed
		tiledata[x] = tiledata[x] or {}
		tiledata[x][y] = tiledata[x][y] or {}
		tiledata[x][y][key] = tiledata[x][y][key] or {}
		local oldval = tiledata[x][y][key].val
		tiledata[x][y][key].val = val
		if states[key].anim then
			-- needs visuals
			if not tiledata[x][y][key].inst then
				newtilevisual(x,y,key)
			-- if this was previously bleed, update visuals
			elseif oldval == nil then
				tiledata[x][y][key].inst.AnimState:PlayAnimation("full" .. gettexture(x,y,states[key].ntex,states[key].randtex))
				bleednearby(x,y,key)
			end
		end
		if states[key].ondelta then
			states[key].ondelta(val, oldval, tiledata[x][y][key].inst)
		end
		return tiledata[x][y][key]
	else
		-- remove this entry
		if tiledata[x] and tiledata[x][y] and tiledata[x][y][key] then
			if tiledata[x][y][key].inst then
				if states[key].ondelta then
					states[key].ondelta(nil, tiledata[x][y][key].val, tiledata[x][y][key].inst)
				end
				tiledata[x][y][key].val = nil
				tiledata[x][y][key].inst:Remove()
				bleednearby(x,y,key)
				updatebleed(x,y,key)
			end
			-- tiledata[x][y][key] = nil
		end
		-- if not GLOBAL.next(tiledata[x][y]) then
			-- tiledata[x][y] = nil
		-- end
		-- if not GLOBAL.next(tiledata[x]) then
			-- tiledata[x] = nil
		-- end
	end
	
end

function GLOBAL.SaveTileState()
	local save = {}
	for x, a in pairs(tiledata) do
		-- save[x] = {}
		for y, b in pairs(a) do
			-- save[x][y] = {}
			table.insert(save, {x=x, y=y, states={}})
			for key, c in pairs(b) do
				if states[key].persists then
					-- save[x][y][key] = c.val
					save[#save].states[key]=c.val
				end
			end
		end
	end
	return save
end

function GLOBAL.LoadTileState(save)
	for i, pt in pairs(save) do
		for k, v in pairs(pt.states) do
			-- for even better performance, this should not do visuals yet, so we don't calculate unnecessary bleed
			GLOBAL.SetTileState(pt.x,pt.y,k,v)
		end
	end
end

AddSimPostInit(function()
    if GLOBAL.TILESTATE_VERSION == THIS_VERSION then
        if GLOBAL.TheWorld.ismastersim then
            --First time running? Set the save/load prefab up!
            if GLOBAL.TheSim:FindFirstEntityWithTag("tilestate") == nil then
                GLOBAL.SpawnPrefab("tilestatecore")
                --set it up here
            end
        end
    end
end)


-- Basegame states

-- GLOBAL.RegisterTileState("creep", false, "tile") --debug
GLOBAL.RegisterTileState("creep", false, "webtile", 2.5, nil, 2, false)
-- GLOBAL.RegisterTileState("snow", false, "snowtile", 1.8, nil, ntextures, false)

AddComponentPostInit("weather", function(inst)
    if GLOBAL.TILESTATE_VERSION == THIS_VERSION then
        local _OnUpdate = inst.OnUpdate
        function inst:OnUpdate(...)
        	_OnUpdate(self, ...)
        	
        	--Disable default snow and rain puddles
        	--GLOBAL.TheWorld.Map:SetOverlayLerp(0) --TODO use regular snow until snow tiles are implemented
        	
        	if self.cannotsnow then -- Possibly also support regional snow control using room tags?
        		GLOBAL.TheWorld.Map:SetOverlayLerp(0) -- While we are using regular snow instead of tiles, nevertheless let mods disable it
        		return
        	end
        	--TODO set the actual snow tiles and their intensity (if it changed (significantly))
        end
    end
end)


-- Mods can set this global flag to true to enable tilestate creep for spiderdens of all kinds
GLOBAL.TileState_GroundCreep = false

-- Worldtiledefs/PlayFootstep would need a patch for creep

-- React to creep tiles properly
AddComponentPostInit("locomotor", function(inst)
    if GLOBAL.TILESTATE_VERSION == THIS_VERSION then
    	local _UpdateGroundSpeedMultiplier = inst.UpdateGroundSpeedMultiplier
    	function inst:UpdateGroundSpeedMultiplier(...)
    		local x,y = GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(self.inst:GetPosition():Get())
    		local creep = GLOBAL.GetTileState(x,y,"creep")
    		if self.triggerscreep and creep and creep.val then
    			if not self.wasoncreep then
    				for src, _ in pairs(creep.sources) do
    					src:PushEvent("creepactivate", { target = self.inst })
    				end
    				self.wasoncreep = true
    			end
    			self.groundspeedmultiplier = self.slowmultiplier
    		else
    			_UpdateGroundSpeedMultiplier(self, ...)
    		end
    	end
    end
end)


local function SetRadius_tilestate(self, radius)
	if self.ignoreSetRadius then
		--ignore and try again in a tick, as we just spawned and likely get moved
		self._creepradius:set_local(radius)
		-- print("SETRADIUS IGNORED")
		return
	end
	local inst = self.inst
	-- print("SETRADIUS",inst,radius)
	self._groundcreep = self._groundcreep or {}
	if GLOBAL.TheWorld.ismastersim then
		self._creepradius:set(radius)
	end
	
	-- remove tiles, iterating backwards to allow removal
	for i = #self._groundcreep, 1, -1 do
		local pt = self._groundcreep[i]
		local tile = GLOBAL.GetTileState(pt[1],pt[2],"creep")
		if not tile or tile.val == nil then
			table.remove(self._groundcreep, i)
		else
			-- if this tile is too far away, the dist will be above 0
			local dist = inst:GetDistanceSqToInst(tile.inst) - radius*radius
			if dist > 0 then
				-- remove this source
				tile.sources = tile.sources or {}
				tile.sources[inst] = nil
				if not GLOBAL.next(tile.sources) then
					-- this tile has no sources left, tell it to vanish (starting inside)
					tile.inst._creeptask = tile.inst:DoPeriodicTask(.4,function()
						dist = dist - 16
						if dist < 0 then
							tile.inst._creeptask:Cancel()
							-- Double-check sources, since a new source might have appeared by now
							if not GLOBAL.next(tile.sources) then
								GLOBAL.SetTileState(pt[1],pt[2],"creep",nil)
								table.remove(self._groundcreep, i)
							end
						end
					end)
				end
			end
		end
	end

	-- add tiles, starting with a round estimate
	local pos = inst:GetPosition()
	for px = pos.x - radius, pos.x + radius, 4 do
    	for pz = pos.z - radius, pos.z + radius, 4 do
    		-- is it actually in the radius?
    		if inst:GetDistanceSqToPoint(GLOBAL.TheWorld.Map:GetTileCenterPoint(px, 0, pz)) <= radius*radius then
    			local x, y = GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(px, 0, pz)
    			
    			local tile = GLOBAL.GetTileState(x,y,"creep")
    			local ground = GLOBAL.TheWorld.Map:GetTile(x, y)
    			local info = GLOBAL.GetTileInfo(ground)
    			if ground == GLOBAL.GROUND.IMPASSABLE or (info ~= nil and info.groundcreepdisabled) then
    				-- This is not normal ground at all, so don't put a tile here
    				if tile and tile.val ~= nil then
    					tile.sources = tile.sources or {}
    					for i, src in pairs(tile.sources) do
    						for j, pt in pairs(src._groundcreep) do
    							if pt[1] == x and pt[2] == y then
    								table.remove(src._groundcreep, j)
    							end
    						end
    					end
						GLOBAL.SetTileState(x,y,"creep",nil)
    				end
    			else
    				-- add it
    				if not tile or tile.val == nil then
						tile = GLOBAL.SetTileState(x,y,"creep",true)
    				end
    				tile.sources = tile.sources or {}
    				tile.sources[inst] = true
					--TODO doesn't this add itself several times?
					table.insert(self._groundcreep, {x,y})
    			end
    		end
    		
    	end
	end
	
end

local function updateGroundCreepEntityClient(inst)
	-- print("updateGroundCreepEntityClient",inst)
	inst.GroundCreepEntity.ignoreSetRadius = nil
	inst.GroundCreepEntity:SetRadius(inst.GroundCreepEntity._creepradius:value() or 0)
end

local _AddGroundCreepEntity = GLOBAL.Entity.AddGroundCreepEntity
function GLOBAL.Entity:AddGroundCreepEntity()
	if not GLOBAL.TileState_GroundCreep then
		return _AddGroundCreepEntity(self)
	end

    local guid = self:GetGUID()
    local inst = GLOBAL.Ents[guid]
	-- print("AddGroundCreepEntity",inst)
    inst.GroundCreepEntity = {inst = inst, SetRadius = SetRadius_tilestate}
	inst.GroundCreepEntity._creepradius = GLOBAL.net_smallbyte(guid, "GroundCreepEntity._creepradius", "creepradiusdirty")
	inst.GroundCreepEntity._creepradius:set_local(0)
	inst.GroundCreepEntity.ignoreSetRadius = true --ignore the first SetRadius because we likely get moved after spawning
	if GLOBAL.TheWorld.ismastersim then
		inst:DoTaskInTime(0, updateGroundCreepEntityClient)
	else
		inst:ListenForEvent("creepradiusdirty", updateGroundCreepEntityClient)
		inst:DoTaskInTime(1, updateGroundCreepEntityClient) -- Wait a bit, in case this gets moved in a moment
	end
	local _OnRemoveEntity = inst.OnRemoveEntity
	function inst:OnRemoveEntity(...)
		if _OnRemoveEntity then
			_OnRemoveEntity(self, ...)
		end
		inst.GroundCreepEntity:SetRadius(0)
	end
    return inst.GroundCreepEntity
end

