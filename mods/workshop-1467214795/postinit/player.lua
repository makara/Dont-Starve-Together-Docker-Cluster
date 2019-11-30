local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local function blockPoison(inst, data)
	if inst.components.poisonable then
		inst.components.poisonable:SetBlockAll(true)
	end
end
local function unblockPoison(inst, data)
	if inst.components.poisonable and not inst:HasTag("beaver") then
		inst.components.poisonable:SetBlockAll(true)
	end
end

----------------------------------------------------------------------------------------

--Attempt autodisembarking
--basically a copy of controller disembarking from postinit/components/playercontroller.lua
local function hitcoastline(inst)
	-- If the player is the host and he doesn't want autodisembark, then don't
	if not IA_CONFIG.autodisembark or inst.noautodisembark then return end

	--Ignore if the player is any of this
	if inst.sg:HasStateTag("busy") or inst:IsAmphibious() or
		(inst.components.health and inst.components.health:IsDead()) then
		return
	end
	
	if inst.components.sailor and inst.components.sailor:IsSailing() then
		--Check if the player is close to land and facing towards it
		local angle = inst.Transform:GetRotation() * DEGREES
		local dir = Vector3(math.cos(angle), 0, -math.sin(angle))
		dir = dir:GetNormalized()

		local myPos = inst:GetPosition()
		local step = 0.4
		local numSteps = 8 
		local landingPos = nil 

		for i = 1, numSteps, 1 do 
			local testPos = myPos + dir * step * i 
			local testTile = TheWorld.Map:GetTileAtPoint(testPos.x , testPos.y, testPos.z) 
			if not IsWater(testTile) then 
				landingPos = testPos
				break
			end 
		end 
		if landingPos then 
			landingPos.x, landingPos.y, landingPos.z = TheWorld.Map:GetTileCenterPoint(landingPos.x, 0, landingPos.z)
			inst:PushBufferedAction(BufferedAction(inst, nil, ACTIONS.DISEMBARK, nil, landingPos))
		end
	end
end

----------------------------------------------------------------------------------------

local function beachresurrect(inst)
	local oldpos = inst:GetPosition()
	--Step 1: find position
	local testwaterfn = function(offset)
		local test_point = oldpos + offset
		local tile = TheWorld.Map:GetTileAtPoint(test_point:Get())
		if IsWater(tile) or tile == GROUND.INVALID or tile == GROUND.IMPASSABLE then
			return false
		end
		
		local waterPos = FindValidPositionByFan(0, 12, 6, function(offset)
			return IsOnWater(test_point + offset)
		end)
		if waterPos == nil then
			return false
		end
		
		-- print("should be good... just checking for dangers now.")
		
		--TODO this is not Webber-friendly
		if #TheSim:FindEntities(oldpos.x, oldpos.y, oldpos.z, 12, nil, nil, {"fire", "hostile"}) > 0 then
			return false
		end
		
		return true
	end
	
	
	local pt
	for radius = 8, 508, 10 do
		local result_offset = FindValidPositionByFan(0, radius, 4 + 14 * math.floor(radius/508), testwaterfn)
		if result_offset then
			--we got a winner, stop the loop
			-- print("WE GOT A POINT AT RADIUS..."..radius)
			pt = oldpos + result_offset
			break
		end
	end
	if not pt then
		--try again, but farther
		for radius = 520, 3020, 25 do
			local result_offset = FindValidPositionByFan(0, radius, 16 + 16 * math.floor(radius/3020), testwaterfn)
			if result_offset then
				--we got a winner, stop the loop
				-- print("WE GOT A POINT AT RADIUS..."..radius)
				pt = oldpos + result_offset
				break
			end
		end
	end
	if not pt then
		--find a multiplayer_portal of any kind, those are safe
		for guid, ent in pairs(Ents) do
			if ent:IsValid() and ent.prefab and string.gsub(ent.prefab, 0, 18) == "multiplayer_portal" then
				pt = ent:GetPosition()
				break
			end
		end
	end
	if not pt then
		--failsafe to killing the player
		print("FATAL: Not able to beachresurrect "..tostring(inst)..". Kill them with \"drowning\" instead.")
		inst.components.health:DoDelta(-inst.components.health.currenthealth, false, "drowning", false, nil, true)
		return
	end
	
	--Step 2: put player there
	local crafting = GetValidRecipe("boat_lograft")
	if crafting and crafting.ingredients then
		for _, v in pairs(crafting.ingredients) do
			for i = 1, v.amount do
				local offset = FindValidPositionByFan(math.random()*2*PI, math.random()*2+2, 8, function(pos)
					return not IsOnWater(pos + pt)
				end)
				local item = SpawnPrefab(v.type)
				if offset then
					item.Transform:SetPosition((pt+offset):Get())
				else
					item.Transform:SetPosition(pt:Get())
				end
				item:Hide()
				item:DoTaskInTime(math.random()*3, function()
					item:Show()
					SpawnAt("sand_puff", item)
				end)
			end
		end
	end
	
			
	-- inst.components.hunger:Pause()
	inst:ScreenFade(false, .4, false)
	
	inst:DoTaskInTime(3, function()
		inst.Transform:SetPosition(pt:Get())
		SpawnAt("collapse_small", inst)
	end)
	
	inst:DoTaskInTime(3.4, function()
		
		inst:ScreenFade(true, .4, false)
		
		inst.sg:GoToState("wakeup")
		
		-- inst.components.hunger:Resume()
		
		if inst.components.health then
			inst.components.health:SetInvincible(false)
		end
		
		if inst.components.moisture then
			inst.components.moisture:SetPercent(1)
		end
		
		if not TheWorld.state.isday then
			SpawnAt("spawnlight_multiplayer", inst)
		end
	end)
	
end

----------------------------------------------------------------------------------------

local function newstate(inst, data)
	--data.statename
	if inst:HasTag("idle") then
		if inst._embarkingboat and inst._embarkingboat:IsValid() then
			inst.components.sailor:Embark(inst._embarkingboat)
			inst._embarkingboat = nil
		end
		inst:RemoveEventCallback("newstate", newstate)
	end
end

local function stop(inst)
	if inst.Physics then
		inst.Physics:Stop()
	end
end

local function ms_respawnedfromghost(inst, data)
	if IsOnWater(inst) and inst.components.sailor then
		local boat = FindEntity(inst, 5, nil, {"sailable"}, {"INLIMBO", "fire", "NOCLICK"})
		if boat then
			boat.components.sailable.isembarking = true
			inst._embarkingboat = boat
			--Move there!
			inst:ForceFacePoint(boat:GetPosition():Get())
			local dist = inst:GetPosition():Dist(boat:GetPosition())
			inst.Physics:SetMotorVelOverride(dist / .8, 0, 0)
			inst:DoTaskInTime(.8, stop)
			--Drowning immunity appears to be not needed. -M
			inst:ListenForEvent("newstate", newstate)
		end
	end
end

----------------------------------------------------------------------------------------

local function gotnewitem(inst,data)
	if (data.slot ~= nil or data.eslot ~= nil)
	and TheFocalPoint --just a small failsafe
	and IsOnWater(inst) then
		-- This might sound weird since the normal sound also plays
		TheFocalPoint.SoundEmitter:PlaySound("ia/common/water_collect_resource")
	end
end

----------------------------------------------------------------------------------------

local sailface = {
wilson = {
	wilson_none = "wilson_none",
	wilson_ice = "wilson_ice",
	wilson_magma = "wilson_magma",
	wilson_pigguard = "wilson_pigguard", --Event version
	wilson_pigguard_d = "wilson_pigguard", --"real" version
	wilson_shadow = "wilson_shadow",
	wilson_survivor = "wilson_survivor",
	wilson_victorian = "wilson_victorian",
},
willow = {
	willow_none = "willow_none",
	willow_ice = "willow_ice",
	willow_magma = "willow_magma",
	willow_victorian = "willow_victorian",
},
wolfgang = {
	wolfgang_none = {
		wimpy = "wolfgang_none_wimpy",
		normal = "wolfgang_none_normal",
		mighty = "wolfgang_none_mighty",
	},
	wolfgang_combatant = {
		wimpy = "wolfgang_combatant_wimpy",
		normal = "wolfgang_combatant",
		mighty = "wolfgang_combatant_mighty",
	},
	wolfgang_formal = {
		wimpy = "wolfgang_none_wimpy", --formal wimpy is normal wimpy
		normal = "wolfgang_formal",
		mighty = "wolfgang_formal_mighty",
	},
	wolfgang_gladiator = {
		wimpy = "wolfgang_gladiator_wimpy",
		normal = "wolfgang_gladiator",
		mighty = "wolfgang_gladiator_mighty",
	},
	wolfgang_ice = {
		wimpy = "wolfgang_ice_wimpy",
		normal = "wolfgang_ice",
		mighty = "wolfgang_ice_mighty",
	},
	wolfgang_magma = {
		wimpy = "wolfgang_magma_wimpy",
		normal = "wolfgang_magma",
		mighty = "wolfgang_magma_mighty",
	},
	wolfgang_rose = {
		wimpy = "wolfgang_rose_wimpy",
		normal = "wolfgang_rose",
		mighty = "wolfgang_rose_mighty",
	},
	wolfgang_shadow = {
		wimpy = "wolfgang_shadow_wimpy",
		normal = "wolfgang_shadow",
		mighty = "wolfgang_shadow_mighty",
	},
	wolfgang_survivor = {
		wimpy = "wolfgang_survivor_wimpy",
		normal = "wolfgang_survivor",
		mighty = "wolfgang_survivor_mighty",
	},
	wolfgang_victorian = {
		wimpy = "wolfgang_victorian_wimpy",
		normal = "wolfgang_victorian",
		mighty = "wolfgang_victorian_mighty",
	},
	wolfgang_walrus = { --Event version
		wimpy = "wolfgang_walrus_wimpy",
		normal = "wolfgang_walrus",
		mighty = "wolfgang_walrus_mighty",
	},
	wolfgang_walrus_d = { --"real" version
		wimpy = "wolfgang_walrus_wimpy",
		normal = "wolfgang_walrus",
		mighty = "wolfgang_walrus_mighty",
	},
	wolfgang_wrestler = {
		wimpy = "wolfgang_wrestler_wimpy",
		normal = "wolfgang_wrestler",
		mighty = "wolfgang_wrestler_mighty",
	},
},
wendy = {
	wendy_none = "wendy_none",
	wendy_formal = "wendy_formal",
	wendy_ice = "wendy_ice",
	wendy_magma = "wendy_magma",
},
wx78 = {
	wx78_none = "wx78_none",
	wx78_formal = "wx78_formal",
	wx78_gladiator = "wx78_gladiator",
	wx78_magma = "wx78_magma",
	wx78_nature = "wx78_nature",
	wx78_rhinorook = "wx78_rhinorook", --Event version
	wx78_rhinorook_d = "wx78_rhinorook", --"real" version
	wx78_victorian = "wx78_victorian",
	wx78_wip = "wx78_wip",
},
wickerbottom = {
	wickerbottom_none = "wickerbottom_none",
	wickerbottom_combatant = "wickerbottom_combatant",
	wickerbottom_formal = "wickerbottom_formal",
	wickerbottom_gladiator = "wickerbottom_gladiator",
	wickerbottom_ice = "wickerbottom_ice",
	wickerbottom_lightninggoat = "wickerbottom_lightninggoat", --Event version
	wickerbottom_lightninggoat_d = "wickerbottom_lightninggoat", --"real" version
	wickerbottom_magma = "wickerbottom_magma",
	wickerbottom_rose = "wickerbottom_rose",
	wickerbottom_shadow = "wickerbottom_shadow",
	wickerbottom_survivor = "wickerbottom_survivor",
	wickerbottom_victorian = "wickerbottom_victorian",
},
woodie = {
	woodie_none = "woodie_none",
	woodie_combatant = "woodie_combatant",
	woodie_gladiator = "woodie_gladiator",
	-- woodie_magma = "woodie_magma",
	woodie_survivor = "woodie_survivor",
},
wes = {
	wes_none = "wes_none",
	wes_combatant = "wes_combatant",
	wes_gladiator = "wes_gladiator",
	wes_magma = "wes_magma",
	wes_mandrake = "wes_mandrake", --Event version
	wes_mandrake_d = "wes_mandrake", --"real" version
	wes_nature = "wes_nature",
	wes_rose = "wes_rose",
	wes_shadow = "wes_shadow",
	wes_survivor = "wes_survivor",
	wes_victorian = "wes_victorian",
	wes_wrestler = "wes_wrestler",
},
waxwell = {
	waxwell_none = "waxwell_none",
	waxwell_combatant = "waxwell_combatant",
	waxwell_formal = "waxwell_formal",
	waxwell_gladiator = "waxwell_gladiator",
	waxwell_krampus = "waxwell_krampus", --Event version
	waxwell_krampus_d = "waxwell_krampus", --"real" version
	waxwell_magma = "waxwell_magma",
	waxwell_nature = "waxwell_nature",
	waxwell_survivor = "waxwell_survivor",
	waxwell_unshadow = "waxwell_unshadow",
	waxwell_victorian = "waxwell_victorian",
},
wathgrithr = {
	wathgrithr_none = "wathgrithr_none",
	wathgrithr_combatant = "wathgrithr_combatant",
	wathgrithr_cook = "wathgrithr_cook",
	wathgrithr_deerclops = "wathgrithr_deerclops", --Event version
	wathgrithr_deerclops_d = "wathgrithr_deerclops", --"real" version
	wathgrithr_gladiator = "wathgrithr_gladiator",
	wathgrithr_nature = "wathgrithr_nature",
	wathgrithr_survivor = "wathgrithr_survivor",
	wathgrithr_wrestler = "wathgrithr_wrestler",
},
webber = {
	webber_none = "webber_none",
	webber_bat = "webber_bat", --Event version
	webber_bat_d = "webber_bat", --"real" version
	webber_ice = "webber_ice",
	webber_magma = "webber_magma",
	webber_victorian = "webber_victorian",
},
winona = {
	winona_none = "winona_none",
	winona_combatant = "winona_combatant",
	winona_formal = "winona_formal", --Heirloom version
	winona_formalp = "winona_formal", --"real" version
	winona_gladiator = "winona_gladiator",
	winona_grassgecko = "winona_grassgecko", --Event version
	winona_grassgecko_d = "winona_grassgecko", --"real" version
	winona_magma = "winona_magma",
	winona_rose = "winona_rose", --Heirloom version
	winona_rosep = "winona_rose", --"real" version
	winona_shadow = "winona_shadow", --Heirloom version
	winona_shadowp = "winona_shadow", --"real" version
	winona_survivor = "winona_survivor", --Heirloom version
	winona_survivorp = "winona_survivor", --"real" version
	winona_victorian = "winona_victorian",
},
wortox = {
	wortox_none = "wortox_none",
	wortox_minotaur = "wortox_minotaur",
	wortox_original = "wortox_original",
	wortox_survivor = "wortox_survivor",
},
wormwood = {
	wormwood_none = "wormwood_none",
},
warly = {
	warly_none = "warly_none",
},
}

local Skinner = require("components/skinner")

local _SetSkinMode = Skinner.SetSkinMode
function Skinner:SetSkinMode(...)
	_SetSkinMode(self, ...)
    if not sailface[self.inst.prefab] then return end

    local skinname = self.skin_name
    local skin_type = self.skintype or ""

    if not skinname or skinname == "" then skinname = self.inst.prefab .."_none" end

    local face = sailface[self.inst.prefab][skinname] or sailface[self.inst.prefab][self.inst.prefab .."_none"]

    if self.inst.prefab == "wolfgang" then face = face[skin_type:find("wimpy") and "wimpy" or skin_type:find("mighty") and "mighty" or "normal"] end

    -- print("SETTING SAILFACE", skinname, self.skin_name, face)
    self.inst.AnimState:OverrideSymbol("face_sail", "swap_sailface", face)
end

--for debug testing, enable this code:
-- local char_prefab = nil
-- _G.sface = "wilson_none" --set this via console
-- IAENV.AddClassPostConstruct("widgets/skinspuppet", function(inst)
	-- local SetSkins_old = inst.SetSkins
	-- function inst:SetSkins(character, ...)
		-- char_prefab = character
		-- SetSkins_old(self, character, ...)
	-- end
	
	-- function inst:DoEmote()
		-- self.animstate:SetBank("wilson")
		-- self.animstate:OverrideSymbol("face_sail", "swap_sailface", _G.sface)
		-- self.animstate:PlayAnimation("sail_pre", false)
		-- self.animstate:PushAnimation("sail_loop", false)
		-- self.animstate:PushAnimation("sail_loop", false)
		-- self.animstate:PushAnimation("sail_loop", false)
		-- self.animstate:PushAnimation("sail_pst", false)
		-- -- self.looping = true
	-- end
-- end)

local function WaterFailsafe(inst)
	local my_x, my_y, my_z = inst.Transform:GetWorldPosition()
	if not TheWorld.Map:IsPassableAtPoint(my_x, my_y, my_z)
	and not inst:HasTag("aquatic") then
	for k,v in pairs(Ents) do
			if v:IsValid() and v:HasTag("multiplayer_portal") then
				inst.Transform:SetPosition(v.Transform:GetWorldPosition())
				inst:SnapCamera()
			end
		end
	end
end

local OnLoad_old
local function OnLoad(inst, data, ...)
	local pendingtasks = {}
	for per, _ in pairs(inst.pendingtasks) do
		pendingtasks[per] = true
	end
	OnLoad_old(inst, data, ...)
	local newtasks = {}
	for per, _ in pairs(inst.pendingtasks) do
		if not pendingtasks[per] and per.period == 0 and per.limit == 1 then
			table.insert(newtasks, per)
		end
	end
	if #newtasks == 1 then
		newtasks[1]:Cancel()
		--recreate with appropriate fn
		inst:DoTaskInTime(0, WaterFailsafe)
	end
end

local OnNewSpawn
local function OnNewSpawn_ia(inst, ...)
	-- if IA_CONFIG.newplayerboats then --made it not wrap if the config is not set to begin with -M
		if inst.components.builder then
			-- inst.components.builder:BufferBuild("boat_lograft")
			inst.components.builder:UnlockRecipe("boat_lograft")
			inst.components.builder.buffered_builds["boat_lograft"] = 0
			inst.replica.builder:SetIsBuildBuffered("boat_lograft", true)
		end
	-- end
	return OnNewSpawn(inst, ...)
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddPrefabPostInitAny(function(inst)
if not inst:HasTag("player") then return end


inst.Physics:CollidesWith(COLLISION.WAVES)


if TheWorld.ismastersim then	
	if not inst.components.climatetracker then
		inst:AddComponent("climatetracker")
	end
    inst.components.climatetracker.period = 2
    inst:AddComponent("sailor")
    inst:AddComponent("keeponland")
    inst:AddComponent("ballphinfriend")
	if TheWorld:HasTag("island") then
		inst:AddComponent("mapwrapper")
	end

    inst:ListenForEvent("death", blockPoison)
    inst:ListenForEvent("respawnfromghost", unblockPoison)
    inst:ListenForEvent("hitcoastline", hitcoastline)
	inst:ListenForEvent("beachresurrect", beachresurrect)
	inst:ListenForEvent("ms_respawnedfromghost", ms_respawnedfromghost)

	if inst.OnLoad then
		OnLoad_old = inst.OnLoad
		inst.OnLoad = OnLoad
	end
	if inst.OnNewSpawn and IA_CONFIG.newplayerboats then
		OnNewSpawn = inst.OnNewSpawn
		inst.OnNewSpawn = OnNewSpawn_ia
	end
end

if not TheNet:IsDedicated() then
	inst:DoTaskInTime(0, function()
		if inst == TheLocalPlayer then --only do this for the local player character
			inst:AddComponent("windvisuals")
			-- inst.components.windvisuals:SetRate(1.0)
			inst:AddComponent("watervisuals")
			inst.components.watervisuals:SetWaveSettings(0.8)
            inst:AddComponent("sailor_client")
			-- player_common prefers to only set callbacks like this in "SetOwner", as the character owner can theoretically change
			inst:ListenForEvent("gotnewitem", gotnewitem)
		end
	end)
end


end)
