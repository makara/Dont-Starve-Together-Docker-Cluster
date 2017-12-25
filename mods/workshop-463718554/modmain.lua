--Give starting items
local startingItems = GetModConfigData("STARTINGITEMS")
local startingSeasonItems = GetModConfigData("SEASONSTARTINGITEMS")
local startingNightItems = GetModConfigData("NIGHTSTARTINGITEMS")
local startingPVPItems = GetModConfigData("PVPSTARTINGITEMS")
local startingCaveItems = GetModConfigData("CAVESTARTINGITEMS")
local function StartingInventory(inst, player)
	local startInventory = {}
	
	if startingItems then
		--At all times
		for i = 1, 13 do --Cut Grass
			table.insert(startInventory, "cutgrass")
		end
		for i = 1, 10 do --Twigs
			table.insert(startInventory, "twigs")
		end
		for i = 1, 6 do --Log
			table.insert(startInventory, "log")
		end
		for i = 1, 8 do --Flint
			table.insert(startInventory, "flint")
		end
		for i = 1, 12 do --Rock
			table.insert(startInventory, "rocks")
		end
		for i = 1, 5 do --Gold Nugget
			table.insert(startInventory, "goldnugget")
		end
		for i = 1, 8 do --Meat
			table.insert(startInventory, "meat")
		end
	end
	
	if startingSeasonItems then
		--During winter
		if GLOBAL.TheWorld.state.iswinter or (GLOBAL.TheWorld.state.isautumn and GLOBAL.TheWorld.state.remainingdaysinseason < 5) then
			for i = 1, 7 do --Cut Grass
				table.insert(startInventory, "cutgrass")
			end
			for i = 1, 5 do --Twigs
				table.insert(startInventory, "twigs")
			end
			for i = 1, 8 do --Log
				table.insert(startInventory, "log")
			end
			for i = 1, 4 do --Meat
				table.insert(startInventory, "meat")
			end
			table.insert(startInventory, "heatrock") --Thermal Stone
			table.insert(startInventory, "winterhat") --Winter Hat
		end
		
		--During summer
		if GLOBAL.TheWorld.state.issummer or (GLOBAL.TheWorld.state.isspring and GLOBAL.TheWorld.state.remainingdaysinseason < 5) then
			for i = 1, 7 do --Cut Grass
				table.insert(startInventory, "cutgrass")
			end
			for i = 1, 8 do --Nitre
				table.insert(startInventory, "nitre")
			end
			for i = 1, 15 do --Ice
				table.insert(startInventory, "ice")
			end
			table.insert(startInventory, "heatrock") --Thermal Stone
			table.insert(startInventory, "strawhat") --Straw Hat
		end
		
		--During spring
		if GLOBAL.TheWorld.state.isspring or (GLOBAL.TheWorld.state.iswinter and GLOBAL.TheWorld.state.remainingdaysinseason < 3) then
			table.insert(startInventory, "umbrella") --Umbrella
		end
	end
	
	if startingNightItems then
		--During the night
		if GLOBAL.TheWorld.state.isnight or (GLOBAL.TheWorld.state.isdusk and GLOBAL.TheWorld.state.timeinphase > .8) then
			table.insert(startInventory, "torch") --Torch
		end
	end
	
	if startingCaveItems then
		--For cave only servers
		if GLOBAL.TheWorld:HasTag("cave") then
			table.insert(startInventory, "minerhat") -- Miner Hat
		end
	end
	
	if startingPVPItems then
		--If PVP server
		if GLOBAL.TheNet:GetPVPEnabled() then
			table.insert(startInventory, "spear") --Spear
			table.insert(startInventory, "footballhat") --Football Helmet
		end
	end
	
	--Get the current player spawning code (or create dummy function in case there is none)
	player.CurrentOnNewSpawn = player.OnNewSpawn or function() return true end
	
	--Replace the function with a function containing our code and the old function at the end
	player.OnNewSpawn = function(...)
		player.components.inventory.ignoresound = true
		for i, itemName in pairs(startInventory) do
			player.components.inventory:GiveItem(GLOBAL.SpawnPrefab(itemName))
		end
		player.components.inventory.ignoresound = true
		
		return player.CurrentOnNewSpawn(...)
	end
end

--Reveal the map
local revealMap = GetModConfigData("REVEALMAP")
local function RevealMap(inst, player)
	player:DoTaskInTime(1, function(player)
		--Reveal roads
		if revealMap == 1 then
			local width, height = GLOBAL.TheWorld.Map:GetSize()
			for i = -2*width+20, 2*width-20, 2 do
				for j = -2*height+20, 2*height-20, 2 do
					if GLOBAL.RoadManager:IsOnRoad(i, 0, j) then
						GLOBAL.TheWorld.minimap.MiniMap:ShowArea(i, 0, j, 10)
					end
				end
			end
		end

		--Reveal entire map
		if revealMap == 2 then
			local width, height = GLOBAL.TheWorld.Map:GetSize()
			for i = -2*width+20, 2*width-20, 20 do
				for j = -2*height+20, 2*height-20, 20 do
					if GLOBAL.TheWorld.Map:GetTileAtPoint(i, 0, j) ~= 1 then --1 is map tile for ocean
						GLOBAL.TheWorld.minimap.MiniMap:ShowArea(i, 0, j, 20)
					end
				end
			end
		end
	end)
end

--Starting inventory, map reveal and renew resources
if revealMap ~= 0 or startinItems or startingSeasonItems or startingNightItems or startingPVPItems or startingCaveItems then
	AddPrefabPostInit("world", function(inst)
		if startinItems or startingSeasonItems or startingNightItems or startingPVPItems then
			inst:ListenForEvent("ms_playerspawn", StartingInventory, inst)
		end
		if revealMap ~= 0 then
			inst:ListenForEvent("playeractivated", RevealMap, inst)
		end
	end)
end

--Renew world (blueprint in case of old bell blueprint, flowers because they don't regrow fast enough)
local renewLimitedResources = GetModConfigData("RENEWLIMITEDRESOURCES")
if renewLimitedResources ~= 0 then
	local renew_short = { "berrybush", "carrot_planted", "deciduoustrees", "evergreens", "flint", "flower", "grass", "rock1", "rock2", "sapling" }
	for k, prefab in ipairs(renew_short) do --Items lying on the ground that are frequently harvested and very basic resources that should always be available
		AddPrefabPostInit(prefab, function(inst)
			if GLOBAL.TheWorld.ismastersim then
				inst:AddComponent("renewable")
				inst.components.renewable.delay = math.ceil(0.5*renewLimitedResources)
			end
		end)
	end
	local renew_normal = { "beefalo", "beehive", "bishop", "blueprint", "cactus", "catcoonden", "cave_banana_tree", "cave_fern", "chessjunk1", "chessjunk2", "chessjunk3", "fireflies",
		"flower_cave", "flower_evil", "knight", "lichen", "livingtree", "mandrake_planted", "marblepillar", "marbletree", "marsh_bush", "marsh_tree", "mermhouse", "minotaur", "mound",
		"red_mushroom", "green_mushroom", "blue_mushroom", "mushtree_small", "mushtree_medium", "mushtree_tall", "pighouse",  "rabbithole", "rabbithouse", "reeds", "resurrectionstone",
		"rock_tough", "rock_flintless", "slurtlehole", "rook", "ruins_table", "ruins_chair", "ruins_vase", "ruins_plate", "ruins_bowl", "ruins_chipbowl", "stalagmite", "stalagmite_tall",
		"statueharp", "statuemaxwell", "statueruins", "pighead", "mermhead", "tentacle", "ancient_altar", "ancient_altar_broken", "ruins_statue_mage", "ruins_statue_mage_nogem",
		"houndbone", "stalagmite_full", "stalagmite_med", "stalagmite_low", "stalagmite_tall_full", "stalagmite_tall_med", "stalagmite_tall_low", "rocky", "bat", "worm",
		"bishop_nightmare", "rook_nightmare", "knight_nightmare" }
	for k, prefab in ipairs(renew_normal) do --Most items
		AddPrefabPostInit(prefab, function(inst)
			if GLOBAL.TheWorld.ismastersim then
				inst:AddComponent("renewable")
				inst.components.renewable.delay = math.ceil(renewLimitedResources) --Defaults to this
			end
		end)
	end
	local renew_long = { "houndmound", "molehill", "pigtorch", "spiderden", "spiderhole", "tallbirdnest", "wasphive" }
	for k, prefab in ipairs(renew_long) do --Mainly mob spawning structures (that are destroyed for a reason)
		AddPrefabPostInit(prefab, function(inst)
			if GLOBAL.TheWorld.ismastersim then
				inst:AddComponent("renewable")
				inst.components.renewable.delay = math.ceil(2*renewLimitedResources)
			end
		end)
	end
	
	local currentActionDigFn = GLOBAL.ACTIONS.DIG.fn or function() return true end
	GLOBAL.ACTIONS.DIG.fn = function(act) --Mounds do not disappear, and thus are not marked for respawning normally...
		if act.target and act.target.prefab == "mound" then
			act.target:DoTaskInTime(TUNING.SEG_TIME, function(inst) --Saving and loading server will cause this task to cancel, thus we don't want a too long time to ensure it will regenerate
				inst:Remove()
			end)
		end
		return currentActionDigFn(act)
	end
	
	AddPrefabPostInit("forest", function(inst) --Add the renewable respawner for the overworld
		if GLOBAL.TheWorld.ismastersim then
			inst:AddComponent("renewablerespawner")
		end
	end)
	AddPrefabPostInit("cave", function(inst) --Add the renewable respawner for the caves
		if GLOBAL.TheWorld.ismastersim then
			inst:AddComponent("renewablerespawner")
		end
	end)
end

--Firefly Balance
if GetModConfigData("DRAGONFLYBALANCE") then
	TUNING.DRAGONFLY_HEALTH = 5500
	DRAGONFLY_BREAKOFF_DAMAGE = 1000
	DRAGONFLY_STUN_DURATION = 5
end

--Max Server Size
local maxMaxPlayers = GetModConfigData("MAXMAXPLAYERS")
if (maxMaxPlayers ~= 6) then
	TUNING.MAX_SERVER_SIZE = maxMaxPlayers
end

--Revival health penalty
if not GetModConfigData("REVIVERCRAFTPENALTY") then
	TUNING.REVIVER_CRAFT_HEALTH_PENALTY = 0
	TUNING.REVIVER_CRAFT_SANITY_PENALTY = 0
	AddPrefabPostInit("reviver", function(inst) --Remove getting damaged effect
		if GLOBAL.TheWorld.ismastersim then
			inst.components.inventoryitem:SetOnPickupFn(inst.onpickup)
		end
	end)
end

--Ghost sanity drain
if not GetModConfigData("GHOSTSANITYDRAIN") then
	TUNING.SANITY_GHOST_PLAYER_DRAIN = 0
end

--Faster Drying (drying time)
local dryingSpeedMultiplier = GetModConfigData("DRYINGSPEEDMULTIPLIER")
if dryingSpeedMultiplier ~= 1 then
	TUNING.DRY_FAST = TUNING.DRY_FAST/dryingSpeedMultiplier
	TUNING.DRY_MED = TUNING.DRY_MED/dryingSpeedMultiplier
end

--Faster Farming (growth bonus is multiplied by grow time to get total grow time, so smaller is faster)
local farmingSpeedMultiplier = GetModConfigData("FARMINGSPEEDMULTIPLIER")
if farmingSpeedMultiplier ~= 1 then
	TUNING.FARM1_GROW_BONUS = TUNING.FARM1_GROW_BONUS/farmingSpeedMultiplier
	TUNING.FARM2_GROW_BONUS = TUNING.FARM2_GROW_BONUS/farmingSpeedMultiplier
	TUNING.FARM3_GROW_BONUS = TUNING.FARM3_GROW_BONUS/farmingSpeedMultiplier
end

--Faster Beeboxes
local beesSpeedMultiplier = GetModConfigData("BEESSPEEDMULTIPLIER")
if BeesSpeedMultiplier ~= 1 then
	AddComponentPostInit("pollinator", function(inst)
		inst.collectcount = 6/beesSpeedMultiplier-1 --Bees return to hive if collected > collectcount (by default collectcount is 5)
	end)
	TUNING.BEEBOX_RELEASE_TIME = TUNING.BEEBOX_RELEASE_TIME/beesSpeedMultiplier --Make bees spawn faster as well
end

--Krampus spawn multiplier
local krampusMultiplier = GetModConfigData("KRAMPUSMULTIPLIER")
if krampusMultiplier ~= 1 then
	TUNING.KRAMPUS_THRESHOLD = TUNING.KRAMPUS_THRESHOLD/krampusMultiplier
	TUNING.KRAMPUS_THRESHOLD_VARIANCE = TUNING.KRAMPUS_THRESHOLD_VARIANCE/krampusMultiplier
end

--Resize fire pits, so it is easier to cook/refuel fire
if GetModConfigData("RESIZEFIREPITS") then
	AddPrefabPostInit("campfire", function(inst)
		GLOBAL.RemovePhysicsColliders(inst)
		GLOBAL.MakeObstaclePhysics(inst, 0.6)
	end)
	AddPrefabPostInit("coldfire", function(inst)
		GLOBAL.RemovePhysicsColliders(inst)
		GLOBAL.MakeObstaclePhysics(inst, 0.6)
	end)
	AddPrefabPostInit("firepit", function(inst)
		GLOBAL.RemovePhysicsColliders(inst)
		GLOBAL.MakeObstaclePhysics(inst, 0.9)
	end)
	AddPrefabPostInit("coldfirepit", function(inst)
		GLOBAL.RemovePhysicsColliders(inst)
		GLOBAL.MakeObstaclePhysics(inst, 0.9)
	end)
end

--Make the character talk sound
local function DoTalkSound(inst)
	if inst.talksoundoverride then
		inst.SoundEmitter:PlaySound(inst.talksoundoverride, "talk")
		return true
	elseif not inst:HasTag("mime") then
		inst.SoundEmitter:PlaySound((inst.talker_path_override or "dontstarve/characters/")..(inst.soundsname or inst.prefab).."/talk_LP", "talk")
		return true
	end
end

--Prevent stealing of new characters
local preventStealingDays = GetModConfigData("PREVENTSTEALINGDAYS")
if preventStealingDays > 0 then
	AddComponentPostInit("container", function(inst)
		inst.CurrentOpen = inst.Open
		function inst:Open(doer)
			if inst.opener == nil and doer then
				local canOpen = true
				if self.inst.prefab == "chester" then
					if doer.components.inventory == nil then --Just in case
						canOpen = false
					else
						local eyebone = doer.components.inventory:GetItemByName("chester_eyebone", 1)
						canOpen = false
						for k, v in pairs(eyebone) do
							if k.chesterTag and self.inst.chesterTag == k.chesterTag then
								canOpen = true
							end
						end 
					end
				elseif self.inst.prefab == "dragonflychest" and (not doer.components.builder or not doer.components.builder:KnowsRecipe("dragonflychest")) then
					canOpen = false --The builder does not know the dragonfly chest recipe, so it is certain he did not build this
				elseif self.inst.prefab == "icebox" and (not doer.components.builder or not doer.components.builder:KnowsRecipe("icebox")) then
					canOpen = false --The builder does not know the icebox recipe, so it is certain he did not build this
				elseif self.inst.prefab == "treasurechest" and (not doer.components.builder or not doer.components.builder:KnowsRecipe("treasurechest")) then
					canOpen = false --The builder does not know the treasure chest recipe, so it is certain he did not build this
				end
				if  doer.components.age:GetAgeInDays() >= preventStealingDays then --Is old enough, so rest doesn't matter
					canOpen = true
				end
				if canOpen then --There is no (certain) reason why he shouldn't be allowed to open the chest
					return self:CurrentOpen(doer)
				elseif doer.components.talker then
					doer.components.talker:Say("It's locked.") --Show text
					doer.SoundEmitter:KillSound("talk") --Stop talking if currently talking
					DoTalkSound(doer) --Add talk sound
					doer:DoTaskInTime(0.8, function(inst) inst.SoundEmitter:KillSound("talk") end) --Stop talking again after 0.8 seconds
				end
			end
		end
	end)
end

--Make multiple chesters possible (can't be turned off completely)
AddPrefabPostInit("chester", function(inst)
	--Replace current save function with one that save the id of the eyebone that chester is bound too
	inst.CurrentOnSave = inst.OnSave or function() return true end
	inst.OnSave = function(inst, data)
		data.chesterTag = inst.chesterTag
		return inst.CurrentOnSave(inst, data)
	end
	
	--Replace current load function with one that load the id of the eyebone that chester is bound too
	inst.CurrentOnPreLoad = inst.OnPreLoad or function() return true end
	inst.OnPreLoad = function(inst, data)
		if data.chesterTag then
			inst.chesterTag = data.chesterTag
			inst:AddTag(data.chesterTag)
		else  --In case mod is applied to non-modded world
			inst.chesterTag = "chester_boneid0"
			inst:AddTag("chester_boneid0")
		end
		return inst.CurrentOnPreLoad(inst, data)
	end
end)

--Empty inventory on leave/kick
local emptyInventoryDays = GetModConfigData("EMPTYINVENTORYDAYS")
if emptyInventoryDays ~= 0 then
	local TheNetIndex = GLOBAL.getmetatable(GLOBAL.TheNet).__index
	--Drop on kick
	local CurrentKick = TheNetIndex.Kick or function() return true end
	TheNetIndex.Kick = function(inst, userid, ...)
		for k, v in pairs(GLOBAL.AllPlayers) do
			if v.userid == userid and player.components.inventory then
				player.components.inventory:DropEverything(false, false)
			end
		end
		return CurrentKick(inst, userid, ...)
	end
	--Drop on ban
	local CurrentBan = TheNetIndex.Kick or function() return true end
	TheNetIndex.Kick = function(inst, userid, ...)
		for k, v in pairs(GLOBAL.AllPlayers) do
			if v.userid == userid and player.components.inventory then
				player.components.inventory:DropEverything(false, false)
			end
		end
		return CurrentBan(inst, userid, ...)
	end
	--Drop on leave
	if emptyInventoryDays > 0 then
		AddComponentPostInit("playerspawner", function(PlayerSpawner, inst)
			inst:ListenForEvent("ms_playerdespawn", function (inst, player)
				if player.components.inventory and player.components.age and player.components.age:GetAgeInDays() < emptyInventoryDays then
					player.components.inventory:DropEverything(false, false)
				end
			end)
		end)
	end
end

--Prevent destroying structures
local nonPlayerStructure = { beehive = true, houndmound = true, mermhead = true, mermhouse = true, pighead = true, pighouse = true, rabbithouse = true, spiderden = true, wasphive = true}
local preventDestroyingDays = GetModConfigData("PREVENTDESTROYINGDAYS")
if preventDestroyingDays ~= 0 then
	AddComponentPostInit("workable", function(workable, inst)
		if GLOBAL.TheWorld.ismastersim then
			workable.CurrentWorkedBy = workable.WorkedBy or function() return true end
			function workable:WorkedBy(worker, numworks)
				if not inst:HasTag("structure") or nonPlayerStructure[workable.inst.prefab] or (preventDestroyingDays ~= -1 and worker.components.age and worker.components.age:GetAgeInDays() >= preventDestroyingDays) then
					return workable:CurrentWorkedBy(worker, numworks)
				elseif worker.components.talker then
					worker.components.talker:Say("It's too strong.") --Show text
					worker.SoundEmitter:KillSound("talk") --Stop talking if currently talking
					DoTalkSound(worker) --Add talk sound
					worker:DoTaskInTime(1, function(inst) inst.SoundEmitter:KillSound("talk") end) --Stop talking again after 1 second
				end
			end
		end
	end)
	--We can't determine who uses the explosive, but aside from trolling there is hardly any good reason to blow up buildings with explosives
	AddComponentPostInit("explosive", function(explosive, inst)
		inst.buildingdamage = 0
		explosive.CurrentOnBurnt = explosive.OnBurnt
		function explosive:OnBurnt()
			local x, y, z = self.inst.Transform:GetWorldPosition()
			local ents2 = GLOBAL.TheSim:FindEntities(x, y, z, explosive.explosiverange, nil, { "INLIMBO" })
			local ents3 = {}
			local nearbyStructure = false
			for k, v in ipairs(ents2) do
				if v.components.burnable ~= nil and not v.components.burnable:IsBurning() then
					if v:HasTag("structure") and not nonPlayerStructure[v.prefab] then
						nearbyStructure = true
					end
					table.insert(ents3, v)
				end
			end
			explosive:CurrentOnBurnt()
			if nearbyStructure then  --Make sure structures aren't lit on fire (indirectly) from explosives
				for k, v in ipairs(ents3) do
					if v:IsValid() and not v:IsInLimbo() and v.components.burnable ~= nil and v.components.burnable:IsBurning() then
						v.components.burnable:Extinguish(true, 100)
					end
				end
			end
		end
	end)
end

--Prevent burning (and burning buildings)
local preventBurningDays = GetModConfigData("PREVENTBURNING")
if preventBurningDays ~= 0 or preventDestroyingDays ~= 0 then
	AddComponentPostInit("lighter", function(lighter, inst)
		lighter.CurrentLight = lighter.Light or function() return true end
		function lighter:Light(target)
			if inst.components.inventoryitem.owner then
				if inst.components.inventoryitem.owner.components.age and inst.components.inventoryitem.owner.components.age:GetAgeInDays() >= preventBurningDays
					and (not target:HasTag("structure") or nonPlayerStructure[target.prefab] or (preventDestroyingDays ~= -1 and inst.components.inventoryitem.owner.components.age and inst.components.inventoryitem.owner.components.age:GetAgeInDays() >= preventDestroyingDays))then
					return lighter:CurrentLight(target)
				elseif inst.components.inventoryitem.owner.components.talker then
					inst.components.inventoryitem.owner.components.talker:Say("It won't burn.") --Show text
					inst.components.inventoryitem.owner.SoundEmitter:KillSound("talk") --Stop talking if currently talking
					DoTalkSound(inst.components.inventoryitem.owner) --Add talk sound
					inst.components.inventoryitem.owner:DoTaskInTime(1, function(inst) inst.SoundEmitter:KillSound("talk") end) --Stop talking again after 1 second
				end
			end
		end
	end)
	AddPrefabPostInit("lighter", function(inst)
		if GLOBAL.TheWorld.ismastersim then
			inst.Currentonattack = inst.onattack or function() return true end
			inst.onattack = function(weapon, attacker, target)
				if attacker.components.age and attacker.componants.age:GetAgeInDays() >= preventBurningDays 
					and (not target:HasTag("structure") or nonPlayerStructure[target.prefab] or (preventDestroyingDays ~= -1 and attacker.components.age and attacker.components.age:GetAgeInDays() >= preventDestroyingDays)) then
					return inst.Currentonattack(weapon, attacker, target)
				end
			end
		end
	end)
	AddPrefabPostInit("torch", function (inst)
		if GLOBAL.TheWorld.ismastersim then
			inst.Currentonattack = inst.onattack or function() return true end
			inst.onattack = function(weapon, attacker, target)
				if attacker.components.age and attacker.componants.age:GetAgeInDays() >= preventBurningDays
					and (not targe:HasTag("structure") or nonPlayerStructure[target.prefab] or (preventDestroyingDays ~= -1 and attacker.components.age and attacker.components.age:GetAgeInDays() >= preventDestroyingDays)) then
					return inst.Currentonattack(weapon, attacker, target)
				end
			end
		end
	end)
	AddComponentPostInit("firebug", function (inst)
		inst.CurrentOnUpdate = OnUpdate
		inst.OnUpdate = function(inst, dt)
			if inst.components.age and inst.components.age:GetAgeInDays() >= preventBurningDays then
				return inst:CurrentOnUpdate(dt)
			end
		end
	end)
end

--Prevent fire from spreading
local spreadFire = GetModConfigData("SPREADFIRE")
if spreadFire ~= 2 then
	local CurrentMakeSmallPropagator = GLOBAL.MakeSmallPropagator
	GLOBAL.MakeSmallPropagator = function(inst)
		CurrentMakeSmallPropagator(inst)
		if inst.components.propagator then
			if spreadFire == 1 then --Half range
				inst.components.propagator.propagaterange = inst.components.propagator.propagaterange/2
			else
				inst.components.propagator.propagaterange = 0
			end
		end
	end

	local CurrentMakeMediumPropagator = GLOBAL.MakeMediumPropagator
	GLOBAL.MakeMediumPropagator = function(inst)
		CurrentMakeMediumPropagator(inst)
		if inst.components.propagator then
			if spreadFire == 1 then --Half range
				inst.components.propagator.propagaterange = inst.components.propagator.propagaterange/2
			else
				inst.components.propagator.propagaterange = 0
			end
		end
	end
	
	local MakeLargePropagator = GLOBAL.MakeLargePropagator
	GLOBAL.MakeLargePropagator = function(inst)
		MakeLargePropagator(inst)
		if inst.components.propagator then
			if spreadFire == 1 then --Half range
				inst.components.propagator.propagaterange = inst.components.propagator.propagaterange/2
			else
				inst.components.propagator.propagaterange = 0
			end
		end
	end
end

--Prevent haunting (except when it gives a positive effect)
local canHaunt = GetModConfigData("CANHAUNT")
if canHaunt ~= 2 then
	--Launching is negative
	GLOBAL.MakeHauntableLaunch = function(inst, chance, speed, cooldown, haunt_value)
		if not inst.components.hauntable then inst:AddComponent("hauntable") end
		inst.components.hauntable.cooldown = cooldown or TUNING.HAUNT_COOLDOWN_SMALL
	end
	--Launching and destroying are negative
	GLOBAL.MakeHauntableLaunchAndSmash = function(inst, launch_chance, smash_chance, speed, cooldown, launch_haunt_value, smash_haunt_value)
		if not inst.components.hauntable then inst:AddComponent("hauntable") end
		inst.components.hauntable.cooldown = cooldown or TUNING.HAUNT_COOLDOWN_SMALL
	end
	--Destroying rocks/trees/etc can be positive, destroying buildings is not (use whitelist in case of mods adding buildings)
	local whitelist = {chessjunk = true, evergreens = true, livingtree = true, marblepillar = true, marbletree = true, marsh_tree = true, mermhead = true, mooseegg = true, pighead = true, 
		pighouse = true, rabbithouse = true, rock1 = true, rock2 = true, rock_flintless = true, rock_ice = true, statueglommer = true, statueharp = true, statuemaxwell = true}
	GLOBAL.MakeHauntableWork = function(inst, chance, cooldown, haunt_value)
		if not inst.components.hauntable then inst:AddComponent("hauntable") end
		inst.components.hauntable.cooldown = cooldown or TUNING.HAUNT_COOLDOWN_SMALL
		inst.components.hauntable:SetOnHauntFn(function(inst, haunter)
			if not whitelist[inst.prefab] then --Only the positive effects
				return false
			end
			chance = chance or TUNING.HAUNT_CHANCE_OFTEN
			if math.random() <= chance then
				if inst.components.workable and inst.components.workable.workleft > 0 then
					inst.components.hauntable.hauntvalue = haunt_value or TUNING.HAUNT_SMALL
					inst.components.workable:WorkedBy(haunter, 1)
					return true
				end
			end
			return false
		end)
	end
	--Igniting is negative and all prefabs that have this already have MakeHauntableWork
	GLOBAL.MakeHauntableWorkAndIgnite = function(inst, work_chance, ignite_chance, cooldown, work_haunt_value, ignite_haunt_value)
		if not inst.components.hauntable then inst:AddComponent("hauntable") end
		inst.components.hauntable.cooldown = cooldown or TUNING.HAUNT_COOLDOWN_MEDIUM
	end
	--Freezing is negative
	GLOBAL.MakeHauntableFreeze = function(inst, chance, cooldown, haunt_value)
		if not inst.components.hauntable then inst:AddComponent("hauntable") end
		inst.components.hauntable.cooldown = cooldown or TUNING.HAUNT_COOLDOWN_MEDIUM
	end
	--Igniting is negative
	GLOBAL.MakeHauntableIgnite = function(inst, chance, cooldown, haunt_value)
		if not inst.components.hauntable then inst:AddComponent("hauntable") end
		inst.components.hauntable.cooldown = cooldown or TUNING.HAUNT_COOLDOWN_MEDIUM
	end
	--Launching and igniting are negative
	GLOBAL.MakeHauntableLaunchAndIgnite = function(inst, launchchance, ignitechance, speed, cooldown, launch_haunt_value, ignite_haunt_value)
		if not inst.components.hauntable then inst:AddComponent("hauntable") end
		inst.components.hauntable.cooldown = cooldown or TUNING.HAUNT_COOLDOWN_SMALL
	end
	--May be positive, may not be positive
	GLOBAL.MakeHauntableChangePrefab = function(inst, newprefab, chance, haunt_value, nofx)
		if not newprefab then return end
		if type(newprefab) == "table" then
			newprefab = newprefab[math.random(#newprefab)]
		end

		if not inst.components.hauntable then inst:AddComponent("hauntable") end
		inst.components.hauntable.cooldown_on_successful_haunt = false
		inst.components.hauntable:SetOnHauntFn(function(inst, haunter)
			if inst.prefab == "bee" then --We don't want to turn bees into killer bees, others are fine
				return false
			end
			chance = chance or TUNING.HAUNT_CHANCE_HALF
			if math.random() <= chance then
				if not nofx then
					local fx = GLOBAL.SpawnPrefab("small_puff")
					fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
				end
				local new = GLOBAL.SpawnPrefab(newprefab)
				if new then
					new.Transform:SetPosition(inst.Transform:GetWorldPosition())
					new:PushEvent("spawnedfromhaunt", {haunter=haunter, oldPrefab=inst}) --#srosen need to circle back and make sure anything that gets change-prefab'd from a haunt gets haunt FX and cooldown appropriately
					inst:PushEvent("despawnedfromhaunt", {haunter=haunter, newPrefab=new})
				end														 -- also that any relevant data gets carried over (i.e. bees' home, etc)
				inst.components.hauntable.hauntvalue = haunt_value or TUNING.HAUNT_SMALL
				inst:DoTaskInTime(0, function(inst) 
					inst:Remove() 
				end)
				return true
			end
			return false
		end)
	end 
	--Unused, but mods may use it
	GLOBAL.MakeHauntableLaunchOrChangePrefab = function(inst, launchchance, prefabchance, speed, cooldown, newprefab, prefab_haunt_value, launch_haunt_value, nofx)
		if not newprefab then return end
		if not inst.components.hauntable then inst:AddComponent("hauntable") end
		inst.components.hauntable.cooldown = cooldown or TUNING.HAUNT_COOLDOWN_SMALL
	end 
	--Unused, but mods may use it
	GLOBAL.MakeHauntablePerish = function(inst, perishpct, chance, cooldown, haunt_value)
		if not inst.components.hauntable then inst:AddComponent("hauntable") end
		inst.components.hauntable.cooldown = cooldown or TUNING.HAUNT_COOLDOWN_SMALL
	end
	--Launching and perishing are negative (except for eggs, rotten eggs are useful)
	GLOBAL.MakeHauntableLaunchAndPerish = function(inst, launchchance, perishchance, speed, perishpct, cooldown, launch_haunt_value, perish_haunt_value)
		if not inst.components.hauntable then inst:AddComponent("hauntable") end
		inst.components.hauntable:SetOnHauntFn(function(inst, haunter)
			if (inst.prefab == "bird_egg") then
				perishchance = perishchance or TUNING.HAUNT_CHANCE_OCCASIONAL
				if math.random() <= perishchance and inst.components.perishable then
					inst.components.perishable:ReducePercent(perishpct or .3)
					inst.components.hauntable.hauntvalue = perish_haunt_value or TUNING.HAUNT_MEDIUM
					inst.components.hauntable.cooldown = cooldown or TUNING.HAUNT_COOLDOWN_MEDIUM
					return true
				end
			end
			return false
		end)
	end
	--GLOBAL.MakeHauntablePanic is often useful and never really harmful, so keep it as it is
	--Unlike MakeHauntablePanic this is never useful and may be harmful
	GLOBAL.MakeHauntablePanicAndIgnite = function(inst, panictime, panicchance, ignitechance, cooldown, panic_haunt_value, ignite_haunt_value)
		if not inst.components.hauntable then inst:AddComponent("hauntable") end
		inst.components.hauntable.cooldown = cooldown or TUNING.HAUNT_COOLDOWN_MEDIUM
	end
	--GLOBAL.MakeHauntablePlayAnim is not harmful and mods may use it
	--Spider queen summons extra spiders, but others can be useful
	GLOBAL.MakeHauntableGoToState = function(inst, state, chance, cooldown, haunt_value)
		if not (inst and inst.sg) or not state then return end

		if not inst.components.hauntable then inst:AddComponent("hauntable") end
		inst.components.hauntable.cooldown = cooldown or TUNING.HAUNT_COOLDOWN_SMALL
		inst.components.hauntable:SetOnHauntFn(function(inst, haunter)
			if inst.prefab == "spiderqueen" then
				return false
			end
			chance = chance or TUNING.HAUNT_CHANCE_ALWAYS
			if math.random() <= chance then
				inst.sg:GoToState(state)
				inst.components.hauntable.hauntvalue = haunt_value or TUNING.HAUNT_TINY
				return true
			end
			return false
		end)
	end
	--Dropping items is negative (from chester) is negative
	GLOBAL.MakeHauntableDropFirstItem = function(inst, chance, cooldown, haunt_value)
		if not inst.components.hauntable then inst:AddComponent("hauntable") end
		inst.components.hauntable.cooldown = cooldown or TUNING.HAUNT_COOLDOWN_SMALL
	end
	--Dropping items (from backpacks) is negative
	GLOBAL.MakeHauntableLaunchAndDropFirstItem = function(inst, launchchance, dropchance, speed, cooldown, launch_haunt_value, drop_haunt_value)
		if not inst.components.hauntable then inst:AddComponent("hauntable") end
		inst.components.hauntable.cooldown = cooldown or TUNING.HAUNT_COOLDOWN_SMALL
	end
	--Only harmful for chester, horn, lavae_pet, lighter, meat, mininglantern, panflute, pigman, preparedfoods, fire/deconstruction staff
	--Use blacklist, as it is unknown what reactions mods add
	local blacklist = {chester = true, horn = true, lavae_pet = true, lighter = true, meat = true, mininglantern = true, panflute = true, pigman = true, preparedfoods = true, firestaff = true, greenstaff = true}
	GLOBAL.AddHauntableCustomReaction = function(inst, fn, secondrxn, ignoreinitialresult, ignoresecondaryresult)
		if not inst.components.hauntable then inst:AddComponent("hauntable") end
		local onhaunt = inst.components.hauntable.onhaunt
		
		inst.components.hauntable:SetOnHauntFn(function(inst, haunter)
			if blacklist[inst.prefab] then
				return false
			end
			local result = false
			if secondrxn then -- Custom reaction to come after any existing reactions (i.e. additional effects that are conditional on existing reactions)
				if onhaunt then
					result = onhaunt(inst, haunter)
				end
				if not onhaunt or result or ignoreinitialresult then -- Can use ignore flags if we don't care about the return value of a given part
					local prevresult = result
					result = fn(inst, haunter)
					if ignoresecondaryresult then result = prevresult end
				end
			else -- Custom reaction to come before any existing reactions (i.e. conditions required for existing reaction to trigger)
				result = fn(inst, haunter)
				if (result or ignoreinitialresult) and onhaunt then -- Can use ignore flags if we don't care about the return value of a given part
					local prevresult = result
					result = onhaunt(inst, haunter)
					if ignoresecondaryresult then result = prevresult end
				end
			end
			return result
		end)
	end
	--Dropping items (from chests) or destroying them is negative
	GLOBAL.AddHauntableDropItemOrWork = function(inst)
		if not inst.components.hauntable then inst:AddComponent("hauntable") end
		inst.components.hauntable.cooldown = TUNING.HAUNT_COOLDOWN_SMALL
	end
	
	--Individual items that for some reason do not make use of the above system
	AddPrefabPostInit("ash", function(inst) if GLOBAL.TheWorld.ismastersim then inst.components.hauntable:SetOnHauntFn(function(inst, haunter) return false end) end end)
	AddPrefabPostInit("deciduoustree", function(inst)
		if GLOBAL.TheWorld.ismastersim then
			inst.components.hauntable:SetOnHauntFn(function(inst, haunter) --Only the positive effect
				local isstump = inst:HasTag("stump")
				if not isstump and inst.components.workable and math.random() <= TUNING.HAUNT_CHANCE_OFTEN then
					inst.components.workable:WorkedBy(haunter, 1)
					inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL
					return true
				elseif not (isstump or inst.monster) and  math.random() <= TUNING.HAUNT_CHANCE_SUPERRARE and canHaunt == 1 then
					inst:StartMonster(true)
					inst.components.hauntable.hauntvalue = TUNING.HAUNT_HUGE
					return true
				end
				return false
			end)
		end
	end)
	AddPrefabPostInit("nightlight", function(inst) if GLOBAL.TheWorld.ismastersim then inst.components.hauntable:SetOnHauntFn(function(inst, haunter) return false end) end end)
	AddPrefabPostInit("gemsocket", function(inst) if GLOBAL.TheWorld.ismastersim then inst.components.hauntable:SetOnHauntFn(function(inst, haunter) return false end) end end)
	AddPrefabPostInit("coldfirepit", function(inst)
		if GLOBAL.TheWorld.ismastersim then
			inst.components.hauntable:SetOnHauntFn(function(inst, haunter) --Only the positive effect
				if math.random() <= TUNING.HAUNT_CHANCE_RARE then
					if inst.components.fueled and not inst.components.fueled:IsEmpty() then
						inst.components.fueled:DoDelta(TUNING.MED_FUEL)
						inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL
						return true
					end
				end
				return false
			end)
		end
	end)
	AddPrefabPostInit("cookpot", function(inst) if GLOBAL.TheWorld.ismastersim then inst.components.hauntable:SetOnHauntFn(function(inst, haunter) return false end) end end)
	AddPrefabPostInit("evergreen", function(inst)
		if GLOBAL.TheWorld.ismastersim then
			inst.components.hauntable:SetOnHauntFn(function(inst, haunter) --Only the positive effect
				if math.random() <= TUNING.HAUNT_CHANCE_OFTEN then
					if inst.components.workable then
						inst.components.workable:WorkedBy(haunter, 1)
						inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL
						return true
					end
				elseif math.random() <= TUNING.HAUNT_CHANCE_SUPERRARE and canHaunt == 1 then
					if inst.components.growable then
						if inst.components.growable.stage == "short" then
							inst.leifscale = 0.7
						elseif inst.components.growable.stage == "tall" then
							inst.leifscale = 1.25
						else
							inst.leifscale = 1
						end
					else
						inst.leifscale = 1
					end
					local leiftype = "leif"
					if inst.build == "sparse" then
						leiftype = "leif_sparse"
					end
					local leif = GLOBAL.SpawnPrefab(leiftype)
					local scale = inst.leifscale
					local r,g,b,a = inst.AnimState:GetMultColour()
					leif.AnimState:SetMultColour(r,g,b,a)

					--we should serialize this?
					leif.components.locomotor.walkspeed = leif.components.locomotor.walkspeed*scale
					leif.components.combat.defaultdamage = leif.components.combat.defaultdamage*scale
					leif.components.combat.hitrange = leif.components.combat.hitrange*scale
					leif.components.combat.attackrange = leif.components.combat.attackrange*scale
					local maxhealth = leif.components.health.maxhealth*scale
					local currenthealth = leif.components.health.currenthealth*scale
					leif.components.health:SetMaxHealth(maxhealth)
					leif.components.health:SetCurrentHealth(currenthealth)

					leif.Transform:SetScale(scale,scale,scale) 
					if inst.chopper then leif.components.combat:SuggestTarget(inst.chopper) end
					leif.sg:GoToState("spawn")
					inst:Remove()

					leif.Transform:SetPosition(inst.Transform:GetWorldPosition())		
					
					inst.components.hauntable.hauntvalue = TUNING.HAUNT_HUGE
					inst.components.hauntable.cooldown_on_successful_haunt = false
					return true
				end
				return false
			end)
		end
	end)
	AddPrefabPostInit("evergreen_sparse", function(inst)
		if GLOBAL.TheWorld.ismastersim then
			inst.components.hauntable:SetOnHauntFn(function(inst, haunter) --Only the positive effect
				if math.random() <= TUNING.HAUNT_CHANCE_OFTEN then
					if inst.components.workable then
						inst.components.workable:WorkedBy(haunter, 1)
						inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL
						return true
					end
				elseif math.random() <= TUNING.HAUNT_CHANCE_SUPERRARE and canHaunt == 1 then
					if inst.components.growable then
						if inst.components.growable.stage == "short" then
							inst.leifscale = 0.7
						elseif inst.components.growable.stage == "tall" then
							inst.leifscale = 1.25
						else
							inst.leifscale = 1
						end
					else
						inst.leifscale = 1
					end
					local leiftype = "leif"
					if inst.build == "sparse" then
						leiftype = "leif_sparse"
					end
					local leif = GLOBAL.SpawnPrefab(leiftype)
					local scale = inst.leifscale
					local r,g,b,a = inst.AnimState:GetMultColour()
					leif.AnimState:SetMultColour(r,g,b,a)

					--we should serialize this?
					leif.components.locomotor.walkspeed = leif.components.locomotor.walkspeed*scale
					leif.components.combat.defaultdamage = leif.components.combat.defaultdamage*scale
					leif.components.combat.hitrange = leif.components.combat.hitrange*scale
					leif.components.combat.attackrange = leif.components.combat.attackrange*scale
					local maxhealth = leif.components.health.maxhealth*scale
					local currenthealth = leif.components.health.currenthealth*scale
					leif.components.health:SetMaxHealth(maxhealth)
					leif.components.health:SetCurrentHealth(currenthealth)

					leif.Transform:SetScale(scale,scale,scale) 
					if inst.chopper then leif.components.combat:SuggestTarget(inst.chopper) end
					leif.sg:GoToState("spawn")
					inst:Remove()

					leif.Transform:SetPosition(inst.Transform:GetWorldPosition())		
					
					inst.components.hauntable.hauntvalue = TUNING.HAUNT_HUGE
					inst.components.hauntable.cooldown_on_successful_haunt = false
					return true
				end
				return false
			end)
		end
	end)
	AddPrefabPostInit("farmplot", function(inst) if GLOBAL.TheWorld.ismastersim then inst.components.hauntable:SetOnHauntFn(function(inst, haunter) return false end) end end)
	AddPrefabPostInit("firepit", function(inst)
		if GLOBAL.TheWorld.ismastersim then
			inst.components.hauntable:SetOnHauntFn(function(inst, haunter) --Only the positive effect
				if math.random() <= TUNING.HAUNT_CHANCE_RARE then
					if inst.components.fueled and not inst.components.fueled:IsEmpty() then
						inst.components.fueled:DoDelta(TUNING.MED_FUEL)
						inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL
						return true
					end
				end
				return false
			end)
		end
	end)
	AddPrefabPostInit("mushrooms", function(inst)
		if GLOBAL.TheWorld.ismastersim then
			inst.components.hauntable:SetOnHauntFn(function(inst, haunter) --Only the positive effect
				if math.random() <= TUNING.HAUNT_CHANCE_OCCASIONAL then
					local fx = SpawnPrefab("small_puff")
					if fx then fx.Transform:SetPosition(inst.Transform:GetWorldPosition()) end
					local prefab = pickswitchprefab(inst)
					local new = nil
					if prefab then new = SpawnPrefab(prefab) end
					if new then
						new.Transform:SetPosition(inst.Transform:GetWorldPosition())
						-- Make it the right state
						if inst.components.pickable and not inst.components.pickable.canbepicked then
							if new.components.pickable then
								new.components.pickable:MakeEmpty()
							end
						elseif inst.components.pickable and not inst.components.pickable.caninteractwith then
							new.AnimState:PlayAnimation("inground")
							if new.components.pickable then
								new.components.pickable.caninteractwith = false
							end
						else
							new.AnimState:PlayAnimation(new.data.animname)
							if new.components.pickable then
								new.components.pickable.caninteractwith = true
							end
						end
					end
					inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL
					inst:DoTaskInTime(0, inst.Remove)
					return true
				elseif inst.components.pickable and inst.components.pickable:CanBePicked() and inst.components.pickable.caninteractwith then
					inst:closetaskfn()
					inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL
					return true
				end
				return false
			end)
		end
	end)
	AddPrefabPostInit("spiderden", function(inst)
		if GLOBAL.TheWorld.ismastersim and canHaunt == 0 then --Do not allow spawning of queens through haunting
			inst.components.hauntable:SetOnHauntFn(function(inst, haunter) return false end)
		end
	end)
	AddPrefabPostInit("spiderden_2", function(inst)
		if GLOBAL.TheWorld.ismastersim and canHaunt == 0 then --Do not allow spawning of queens through haunting
			inst.components.hauntable:SetOnHauntFn(function(inst, haunter) return false end)
		end
	end)
	AddPrefabPostInit("spiderden_3", function(inst)
		if GLOBAL.TheWorld.ismastersim and canHaunt == 0 then --Do not allow spawning of queens through haunting
			inst.components.hauntable:SetOnHauntFn(function(inst, haunter) return false end)
		end
	end)
	AddPrefabPostInit("stafflight", function(inst) if GLOBAL.TheWorld.ismastersim then inst.components.hauntable:SetOnHauntFn(function(inst, haunter) return false end) end end)
	AddPrefabPostInit("trap_teeth", function(inst)
		if GLOBAL.TheWorld.ismastersim then
			inst.components.hauntable:SetOnHauntFn(function(inst, haunter) --Only the positive effect
				if inst.components.mine and not inst.components.mine.inactive and inst.components.mine.issprung then
					if math.random() <= TUNING.HAUNT_CHANCE_OFTEN then
						inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL
						inst.components.mine:Reset()
						return true
					end
				end
				return false
			end)
		end
	end)
end