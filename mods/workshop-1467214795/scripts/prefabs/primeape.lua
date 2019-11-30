local brain = require "brains/primeapebrain"
local nightmarebrain = require "brains/nightmareprimeapebrain"
require "stategraphs/SGprimeape"

local mods = rawget(_G, "mods")

if mods and mods.HealthInfo then
  mods.HealthInfo.AddToWhiteList("primeape")
end

local assets = 
{
  Asset("ANIM", "anim/kiki_basic_sw.zip"),
  Asset("ANIM", "anim/junglekiki_build.zip"),
  Asset("ANIM", "anim/kiki_nightmare_skin.zip"),
  Asset("SOUND", "sound/monkey.fsb"),
}

local prefabs = 
{
  "poop",
  "monkeyprojectile",
  "smallmeat",
  "cave_banana",
}

local SLEEP_DIST_FROMHOME = 1
local SLEEP_DIST_FROMTHREAT = 20
local MAX_CHASEAWAY_DIST = 80
local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 40

local function IsBanana(item)
    return item.prefab == "cave_banana" or item.prefab == "cave_banana_cooked" or item:HasTag("banana")
end

local function SetHarassPlayer(inst, player)
    if inst.harassplayer ~= player then
        if inst._harassovertask ~= nil then
            inst._harassovertask:Cancel()
            inst._harassovertask = nil
        end
        if inst.harassplayer ~= nil then
            inst:RemoveEventCallback("onremove", inst._onharassplayerremoved, inst.harassplayer)
            inst.harassplayer = nil
        end
        if player ~= nil then
            inst:ListenForEvent("onremove", inst._onharassplayerremoved, player)
            inst.harassplayer = player
            inst._harassovertask = inst:DoTaskInTime(120, SetHarassPlayer, nil)
        end
    end
end

local function WeaponDropped(inst)
	inst:Remove()
end

local function ShouldAcceptItem(inst, item)
	if inst.components.sleeper:IsAsleep() then
		return false
	end

	if item.components.equippable and item.components.equippable.equipslot == EQUIPSLOTS.HEAD then
		return true
	end

	if IsBanana(item) then
		return true
	end
end

local function OnGetItemFromPlayer(inst, giver, item)

	-- I eat bananas
	if IsBanana(item) then
		-- banana makes us friends (unless I'm a guard)
		if inst.components.combat:TargetIs(giver) then
			inst.components.combat:SetTarget(nil)
		elseif giver.components.leader ~= nil
		and giver.components.minigame_participator == nil then
			inst.sg:GoToState("befriend")
			giver:PushEvent("makefriend")
			giver.components.leader:AddFollower(inst)
			inst.components.follower:AddLoyaltyTime(item.components.edible:GetHunger() * TUNING.PRIMEAPE_LOYALTY_PER_HUNGER)
		end
		if inst.components.sleeper:IsAsleep() then
			inst.components.sleeper:WakeUp()
		end
	end

	--I wear hats
	if item.components.equippable and item.components.equippable.equipslot == EQUIPSLOTS.HEAD then
		local current = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
		if current then
			inst.components.inventory:DropItem(current)
		end

		inst.components.inventory:Equip(item)
		inst.AnimState:Show("hat")
	end
end

local function OnRefuseItem(inst, item)
  inst.sg:GoToState("refuse")
  if inst.components.sleeper:IsAsleep() then
    inst.components.sleeper:WakeUp()
  end
end

local function IsPoop(item)
    return item.prefab == "poop"
end

local function oneat(inst)
    --Monkey ate some food. Give him some poop!
    if inst.components.inventory ~= nil then
        local maxpoop = 3
        local poopstack = inst.components.inventory:FindItem(IsPoop)
        if poopstack == nil or poopstack.components.stackable.stacksize < maxpoop then
            inst.components.inventory:GiveItem(SpawnPrefab("poop"))
        end
    end
end

local function onthrow(weapon, inst)
	if inst.components.inventory ~= nil and inst.components.inventory:FindItem(IsPoop) ~= nil then
		inst.components.inventory:ConsumeByName("poop", 1)
	end
end

local function hasammo(inst)
    return inst.components.inventory ~= nil and inst.components.inventory:FindItem(IsPoop) ~= nil
end

local function EquipWeapons(inst)
	if inst.components.inventory ~= nil and not inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
		local thrower = CreateEntity()
		thrower.name = "Thrower"
		thrower.entity:AddTransform()
		thrower:AddComponent("weapon")
		thrower.components.weapon:SetDamage(0)
		thrower.components.weapon:SetRange(TUNING.PRIMEAPE_RANGED_RANGE)
		thrower.components.weapon:SetProjectile("monkeyprojectile")
		thrower.components.weapon:SetOnProjectileLaunch(onthrow)
		thrower:AddComponent("inventoryitem")
		thrower.persists = false
		thrower.components.inventoryitem:SetOnDroppedFn(thrower.Remove)
		thrower:AddComponent("equippable")
		inst.components.inventory:GiveItem(thrower)
		inst.weaponitems.thrower = thrower

		local hitter = CreateEntity()
		hitter.name = "Hitter"
		hitter.entity:AddTransform()
		hitter:AddComponent("weapon")
		hitter.components.weapon:SetDamage(TUNING.PRIMEAPE_MELEE_DAMAGE)
		hitter.components.weapon:SetRange(0)
		hitter:AddComponent("inventoryitem")
		hitter.persists = false
		hitter.components.inventoryitem:SetOnDroppedFn(hitter.Remove)
		hitter:AddComponent("equippable")
		inst.components.inventory:GiveItem(hitter)
		inst.weaponitems.hitter = hitter
	end
end

local function _ForgetTarget(inst)
    inst.components.combat:SetTarget(nil)
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    SetHarassPlayer(inst, nil)
    if inst.task ~= nil then
        inst.task:Cancel()
    end
    inst.task = inst:DoTaskInTime(math.random(55, 65), _ForgetTarget) --Forget about target after a minute

    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 30, { "primeape" })
    for i, v in ipairs(ents) do
        if v ~= inst then
            v.components.combat:SuggestTarget(data.attacker)
            SetHarassPlayer(v, nil)
            if v.task ~= nil then
                v.task:Cancel()
            end
            v.task = v:DoTaskInTime(math.random(55, 65), _ForgetTarget) --Forget about target after a minute
        end
    end
end

local function FindTargetOfInterest(inst)
	if not inst.curious then
		return 
	end

	if inst.harassplayer == nil and inst.components.combat.target == nil then
		local x, y, z = inst.Transform:GetWorldPosition()
        -- Get all players in range
        local targets = FindPlayersInRange(x, y, z, 25)
        -- randomly iterate over all players until we find one we're interested in.
        for i = 1, #targets do
            local randomtarget = math.random(#targets)
            local target = targets[randomtarget]
            table.remove(targets, randomtarget)
            --Higher chance to follow if he has bananas
			local onboat = target.components.sailor and target.components.sailor:IsSailing()
			if not onboat and not target:HasTag("monkey") and not target:HasTag("primeape")
			and (target.components.inventory ~= nil and math.random() < (target.components.inventory:FindItem(IsBanana) ~= nil and .6 or .15)) then
				SetHarassPlayer(inst, target)
				return
			end
		end
	end
end

local function retargetfn(inst)
    return inst:HasTag("nightmare")
        and FindEntity(
                inst,
                20,
                function(guy)
                    return inst.components.combat:CanTarget(guy)
                end,
                { "_combat" }, --see entityreplica.lua
                { "playerghost", "aquatic" },
                { "character", "monster" }
            )
        or nil
end

local function shouldKeepTarget(inst, target)
	local onboat = target.components.sailor and target.components.sailor:IsSailing()
	return not onboat
end

local function _DropAndGoHome(inst)
    if inst.components.inventory ~= nil then
        inst.components.inventory:DropEverything(false, true)
    end
    if inst.components.homeseeker ~= nil and inst.components.homeseeker.home ~= nil then
        inst.components.homeseeker.home:PushEvent("primeapedanger")
    end
end

local function OnPrimeApeDeath(inst, data)
    --A monkey was killed by a player! Run home!
    if data.afflicter ~= nil and data.inst:HasTag("monkey") and data.afflicter:HasTag("player") then
        --Drop all items, go home
        inst:DoTaskInTime(math.random(), _DropAndGoHome)
    end
end

local function onpickup(inst, data)
    local item = data.item
    if item ~= nil and
        item.components.equippable ~= nil and
        item.components.equippable.equipslot == EQUIPSLOTS.HEAD and
        not inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) then
        --Ugly special case for how the PICKUP action works.
        --Need to wait until PICKUP has called "GiveItem" before equipping item.
        inst:DoTaskInTime(0, function()
            if item:IsValid() and
                item.components.inventoryitem ~= nil and
                item.components.inventoryitem.owner == inst then
                inst.components.inventory:Equip(item)
            end
        end)
    end
    -- if data.item:HasTag("monkeybait") then
    -- 	inst:DoTaskInTime(4+math.random()*2, function(inst)
    -- 		local ball = inst.components.inventory:FindItem(function(item) return item:HasTag("monkeybait") end)
    --               local action = BufferedAction(inst, TheLocalPlayer, ACTIONS.THROW, ball)
    -- 		inst.components.locomotor:PushAction(action, true)
    -- 	end)
    -- end
end

local function DoFx(inst)
  if ExecutingLongUpdate then
    return
  end
  inst.SoundEmitter:PlaySound("dontstarve/common/ghost_spawn")

    local x, y, z = inst.Transform:GetWorldPosition()
	local fx = SpawnPrefab("statue_transition_2")
	if fx then
		fx.Transform:SetPosition(x, y, z)
		fx.Transform:SetScale(.8,.8,.8)
	end
	fx = SpawnPrefab("statue_transition")
	if fx then
		fx.Transform:SetPosition(x, y, z)
		fx.Transform:SetScale(.8,.8,.8)
	end
end

local function SetNormalPrimeApe(inst)
  inst:RemoveTag("nightmare")
  inst:SetBrain(brain)
  inst.AnimState:SetBuild("junglekiki_build")
  inst.AnimState:SetMultColour(1,1,1,1)
  inst.curious = true
  inst.soundtype = "ia/creatures/monkey_island"

  -- inst.components.lootdropper:SetLoot(nil)
  inst.components.combat:SetTarget(nil)

  inst:ListenForEvent("entity_death", inst.listenfn, TheWorld)    
end

local function SetNightmarePrimeApe(inst)
  inst:AddTag("nightmare")
  inst.AnimState:SetMultColour(1,1,1,.6)
  inst:SetBrain(nightmarebrain)
  inst.AnimState:SetBuild("kiki_nightmare_skin")
  inst.soundtype = "dontstarve/creatures/monkey_nightmare"
  SetHarassPlayer(inst, nil)
  inst.curious = false
  if inst.task then
    inst.task:Cancel()
    inst.task = nil
  end

  inst.components.lootdropper:SetLoot({"beardhair"})
  inst.components.combat:SetTarget(nil)

  inst:RemoveEventCallback("entity_death", inst.listenfn, TheWorld) 
end

local function TestNightmareArea(inst, area)
    if (TheWorld.state.isnightmarewild or TheWorld.state.isnightmaredawn)
        and inst.components.areaaware:CurrentlyInTag("Nightmare")
        and not inst:HasTag("nightmare") then

        DoFx(inst)
        SetNightmareMonkey(inst)
    elseif (not TheWorld.state.isnightmarewild and not TheWorld.state.isnightmaredawn)
        and inst:HasTag("nightmare") then
        DoFx(inst)
        SetNormalMonkey(inst)
    end
end

local function TestNightmarePhase(inst, phase)
    if (phase == "wild" or phase == "dawn")
        and inst.components.areaaware:CurrentlyInTag("Nightmare")
        and not inst:HasTag("nightmare") then

        DoFx(inst)
        SetNightmareMonkey(inst)
    elseif (phase ~= "wild" and phase ~= "dawn")
        and inst:HasTag("nightmare") then
        DoFx(inst)
        SetNormalMonkey(inst)
    end
end

local function OnCustomHaunt(inst)
    inst.components.periodicspawner:TrySpawn()
    return true
end

local function OnSave(inst, data)
	data.nightmare = inst:HasTag("nightmare") or nil
end

local function OnLoad(inst, data)
	if data ~= nil and data.nightmare then
		SetNightmarePrimeApe(inst)
	end
end

local function PoofHome(inst)
	if inst.components.homeseeker then
		inst.components.homeseeker:GoHome()
	end
end

local function OnEntitySleep(inst)
	if not inst.components.timer:TimerExists("go_home_delay") then
		PoofHome(inst)
	end
end

local function ontimerdone(inst, data)
	if data.name == "CanThrow" then
		inst.CanThrowItems = true
	elseif data.name == "go_home_delay" then
		if inst:IsAsleep() then
			PoofHome(inst)
		end
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()   
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()
    inst.entity:AddLightWatcher() --solely for cave sleeping

    inst.DynamicShadow:SetSize(2, 1.25)

    inst.Transform:SetSixFaced()

    MakeCharacterPhysics(inst, 10, 0.25)

	inst.AnimState:SetBank("kiki")
	inst.AnimState:SetBuild("junglekiki_build")
	inst.AnimState:SetBuild("junglekiki_buil") --set it invalid then correctly again. Don't ask, idk either -M
	inst.AnimState:SetBuild("junglekiki_build") --fixes gitlab issue #240
	inst.AnimState:PlayAnimation("idle_loop", true)

	inst:AddTag("primeape")
	inst:AddTag("animal")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.soundtype = "ia/creatures/monkey_island"

	MakeMediumBurnableCharacter(inst, "kiki_lowerbody")
	MakeMediumFreezableCharacter(inst)

    inst:AddComponent("inventory")

    inst:AddComponent("inspectable")

	inst:AddComponent("thief")
	inst.components.thief:SetCanOpenContainers(false)
	inst.canlootchests = false -- stops it's brain from trying to loot chests

	inst:AddComponent("locomotor")
	inst.components.locomotor:SetSlowMultiplier( 1 )
	inst.components.locomotor:SetTriggersCreep(false)
	inst.components.locomotor.pathcaps = { ignorecreep = false }
	inst.components.locomotor.walkspeed = TUNING.PRIMEAPE_MOVE_SPEED

	inst:AddComponent("combat")
	inst.components.combat:SetAttackPeriod(TUNING.PRIMEAPE_ATTACK_PERIOD)
	inst.components.combat:SetRange(TUNING.PRIMEAPE_MELEE_RANGE)
	inst.components.combat:SetRetargetFunction(1, retargetfn)

	inst.components.combat:SetKeepTargetFunction(shouldKeepTarget)
	inst.components.combat:SetDefaultDamage(0) --This doesn't matter, uses weapon damage

	inst:AddComponent("follower")
	inst.components.follower.maxfollowtime = TUNING.PRIMEAPE_LOYALTY_MAXTIME

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(TUNING.PRIMEAPE_HEALTH)

	inst:AddComponent("periodicspawner")
	inst.components.periodicspawner:SetPrefab("poop")
	inst.components.periodicspawner:SetRandomTimes(TUNING.PRIMEAPE_POOP_PERIOD_MIN, TUNING.PRIMEAPE_POOP_PERIOD_MAX)
	inst.components.periodicspawner:SetDensityInRange(20, 2)
	inst.components.periodicspawner:SetMinimumSpacing(15)
	inst.components.periodicspawner:Start()

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:AddRandomLoot("smallmeat", 0.5)
	inst.components.lootdropper:AddRandomLoot("cave_banana", 0.5)
	inst.components.lootdropper.numrandomloot = 1

	inst:AddComponent("eater")
	inst.components.eater:SetVegetarian()
	inst.components.eater:SetOnEatFn(oneat)

	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ShouldAcceptItem)
	inst.components.trader.onaccept = OnGetItemFromPlayer
	inst.components.trader.onrefuse = OnRefuseItem
	inst.components.trader.deleteitemonaccept = false

	inst:AddComponent("sleeper")
    -- inst.components.sleeper.sleeptestfn = NocturnalSleepTest
    -- inst.components.sleeper.waketestfn = NocturnalWakeTest

    -- inst:AddComponent("areaaware")
	
	inst:SetBrain(brain)
	inst:SetStateGraph("SGprimeape")

	inst.FindTargetOfInterestTask = inst:DoPeriodicTask(10, FindTargetOfInterest)	--Find something to be interested in!

    inst.HasAmmo = hasammo
    inst.curious = true
    inst.harassplayer = nil
    inst._onharassplayerremoved = function() SetHarassPlayer(inst, nil) end

	inst:AddComponent("knownlocations")    

	inst:AddComponent("timer")
	inst:DoTaskInTime(0, function()
		if not inst.components.timer:TimerExists("go_home_delay") then
			inst.components.timer:StartTimer("go_home_delay", TUNING.PRIMEAPE_GOHOME_DELAY) -- every monkey goes home a while after it spawns
		end
	end)

	inst:ListenForEvent("timerdone", ontimerdone)

	inst.listenfn = function(listento, data) OnPrimeApeDeath(inst, data) end

	inst:ListenForEvent("onpickupitem", onpickup)
	inst:ListenForEvent("attacked", OnAttacked)

    -- inst:WatchWorldState("nightmarephase", TestNightmarePhase)
    -- inst:ListenForEvent("changearea", TestNightmareArea)

    MakeHauntablePanic(inst)
    AddHauntableCustomReaction(inst, OnCustomHaunt, true, false, true)
	
    inst.weaponitems = {}
    EquipWeapons(inst)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
	
	inst.OnEntitySleep = OnEntitySleep
	inst.CanThrowItems = true

	return inst
end

return Prefab("primeape", fn, assets, prefabs)
