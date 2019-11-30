local brain = require "brains/birdbrain"

local function onTalkParrot(inst)
	inst.SoundEmitter:PlaySound("ia/creatures/parrot/chirp", "talk") 
end
local function doneTalkParrot(inst)
	inst.SoundEmitter:KillSound("talk")
end
local function updateWaterSeagull(inst)
	if IsOnWater(inst) then
		inst.AnimState:SetBank("seagull_water")
	else
		inst.AnimState:SetBank("seagull")
	end
end
local function updateWaterCormorant(inst)
	if IsOnWater(inst) then
		inst.AnimState:SetBank("cormorant_water")
	else
		inst.AnimState:SetBank("seagull")
	end
end

local function ShouldSleep(inst)
    return DefaultSleepTest(inst) and not inst.sg:HasStateTag("flight")
end

local function OnAttacked(inst, data)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 30, { "bird" })
    local num_friends = 0
    local maxnum = 5
    for k, v in pairs(ents) do
        if v ~= inst then
            v:PushEvent("gohome")
            num_friends = num_friends + 1
        end

        if num_friends > maxnum then
            return
        end
    end
end

local function OnTrapped(inst, data)
    if data and data.trapper and data.trapper.settrapsymbols then
        data.trapper.settrapsymbols(inst.trappedbuild)
    end
end

local function OnPutInInventory(inst)
    --Otherwise sleeper won't work if we're in a busy state
    inst.sg:GoToState("idle")
end

local function OnDropped(inst)
	if IsOnWater(inst) then
		inst.sg:GoToState("flyaway")
	else
		if inst:HasTag("seagull") or inst:HasTag("cormorant") then
			inst.AnimState:SetBank("seagull")
		end
		inst.sg:GoToState("stunned")
	end
end

local function ChooseItem()
    local mercy_items =
    {
        "flint",
        "flint",
        "flint",
        "twigs",
        "twigs",
        "cutgrass",
    }
    return mercy_items[math.random(#mercy_items)]
end

local function ChooseSeeds()
    -- return not TheWorld.state.iswinter and "seeds" or nil
    return "seeds"
end

local function SpawnPrefabChooser(inst)
    if inst.prefab == "parrot_pirate" then
        return "dubloon"
    elseif inst.prefab == "cormorant" then
        return --loot already spawned on landing
    end

    if TheWorld.state.cycles <= 3 then
        -- The item drop is for drop-in players, players from the start of the game have to forage like normal
        return ChooseSeeds()
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    local players = FindPlayersInRange(x, y, z, 20, true)

    -- Give item if only fresh players are nearby
    local oldestplayer = -1
    for i, player in ipairs(players) do
        if player.components.age ~= nil then
            local playerage = player.components.age:GetAgeInDays()
            if playerage >= 3 then
                return ChooseSeeds()
            elseif playerage > oldestplayer then
                oldestplayer = playerage
            end
        end
    end

    -- Lower chance for older players to get item
    return oldestplayer >= 0
        and math.random() < .35 - oldestplayer * .1
        and ChooseItem()
        or ChooseSeeds()
end

local function EatCormorantLoot(inst, bait)
	if bait and not inst.bufferedaction then
		inst.bufferedaction = BufferedAction(inst, bait, ACTIONS.EAT)
	end
end
local function SpawnCormorantLoot(inst)
	if not inst.bufferedaction and IsOnWater(inst)
	and math.random() <= TUNING.CROW_LEAVINGS_CHANCE then
		inst.components.periodicspawner:TrySpawn("roe")
	end
end
local function ScheduleCormorantLoot(inst)
	local pos = inst:GetPosition()
	if pos.y > 1 then
		local vx, vy, vz = inst.Physics:GetMotorVel()
		inst:DoTaskInTime(pos.y / math.abs(vy) + .1, SpawnCormorantLoot)
	end
end

--------------------------------------------------------------------------

local function makebird(name, feathername, soundbank, bank, extra_assets, commonpostfn, masterpostfn)
    local featherpostfix = feathername or name

    local assets =
    {
        Asset("ANIM", "anim/" .. (bank or "crow") .. ".zip"),
        Asset("ANIM", "anim/".. name .."_build.zip"),
        Asset("SOUND", "sound/birds.fsb"),
    }

    if extra_assets ~= nil then
        for i, v in ipairs(extra_assets) do
            table.insert(assets, Asset(v.type, v.asset))
        end
    end

    local prefabs =
    {
        "seeds",
        "smallmeat",
        "cookedsmallmeat",
        "feather_"..featherpostfix,

        --mercy items
        "flint",
        "twigs",
        "cutgrass",
    }

    local function fn()
        local inst = CreateEntity()

        --Core components
        inst.entity:AddTransform()
        inst.entity:AddPhysics()
        inst.entity:AddAnimState()
        inst.entity:AddDynamicShadow()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()
        inst.entity:AddLightWatcher()

        --Initialize physics
        inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
        inst.Physics:ClearCollisionMask()
        inst.Physics:CollidesWith(COLLISION.WORLD)
        inst.Physics:SetMass(1)
        inst.Physics:SetSphere(1)

        inst:AddTag("bird")
        inst:AddTag(name)
        inst:AddTag("smallcreature")
    	-- make birds amphibious so they can be dropped on water (they fly away anyways)
    	inst:AddTag("amphibious")

        --cookable (from cookable component) added to pristine state for optimization
        inst:AddTag("cookable")

        inst.Transform:SetTwoFaced()

        inst.AnimState:SetBank(bank or "crow")
        inst.AnimState:SetBuild(name.."_build")
        inst.AnimState:PlayAnimation("idle")

        inst.DynamicShadow:SetSize(1, .75)
        inst.DynamicShadow:Enable(false)

        MakeFeedableSmallLivestockPristine(inst)

        if commonpostfn ~= nil then commonpostfn(inst) end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.sounds =
        {
            takeoff = soundbank .. "takeoff",
            chirp = soundbank .. "chirp",
            flyin = "dontstarve/birds/flyin",
        }

        inst.trappedbuild = name.."_build"

        inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
        inst.components.locomotor:EnableGroundSpeedMultiplier(false)
        inst.components.locomotor:SetTriggersCreep(false)
        inst:SetStateGraph("SGbird")

        inst:AddComponent("lootdropper")
        inst.components.lootdropper:AddRandomLoot("feather_"..featherpostfix, 1)
        inst.components.lootdropper:AddRandomLoot("smallmeat", 1)
        inst.components.lootdropper.numrandomloot = 1

        inst:AddComponent("occupier")

        inst:AddComponent("eater")
        inst.components.eater:SetDiet({ FOODTYPE.SEEDS }, { FOODTYPE.SEEDS })

        inst:AddComponent("sleeper")
        inst.components.sleeper:SetSleepTest(ShouldSleep)

        MakeInvItemIA(inst, name)
        inst.components.inventoryitem.nobounce = true
        inst.components.inventoryitem.canbepickedup = false
        inst.components.inventoryitem.canbepickedupalive = true

        inst:AddComponent("cookable")
        inst.components.cookable.product = "cookedsmallmeat"

        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(TUNING.BIRD_HEALTH)
        inst.components.health.murdersound = "dontstarve/wilson/hit_animal"

        inst:AddComponent("combat")
        inst.components.combat.hiteffectsymbol = "crow_body"

        inst:AddComponent("inspectable")

        if inst.prefab == "seagull" or inst.prefab == "cormorant" then
            inst.flyawaydistance = TUNING.WATERBIRD_SEE_THREAT_DISTANCE
        else
            inst.flyawaydistance = TUNING.BIRD_SEE_THREAT_DISTANCE
        end

        inst:SetBrain(brain)

        MakeSmallBurnableCharacter(inst, "crow_body")
        MakeTinyFreezableCharacter(inst, "crow_body")

        inst:AddComponent("hauntable")
        inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

        inst:AddComponent("periodicspawner")
        inst.components.periodicspawner:SetPrefab(SpawnPrefabChooser)
        inst.components.periodicspawner:SetDensityInRange(20, 2)
        inst.components.periodicspawner:SetMinimumSpacing(8)

        inst:ListenForEvent("ontrapped", OnTrapped)
        inst:ListenForEvent("attacked", OnAttacked)

        local birdspawner = TheWorld.components.birdspawner
        if birdspawner ~= nil then
            inst:ListenForEvent("onremove", birdspawner.StopTrackingFn)
            inst:ListenForEvent("enterlimbo", birdspawner.StopTrackingFn)
            birdspawner:StartTracking(inst)
        end

        MakeFeedableSmallLivestock(inst, TUNING.BIRD_PERISH_TIME, OnPutInInventory, OnDropped)

        if masterpostfn ~= nil then masterpostfn(inst) end

        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

local function parrot_pirate_common(inst)
    inst:AddComponent("talker")
    inst.components.talker.fontsize = 28
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.colour = Vector3(.9, .4, .4, 1)
    inst:ListenForEvent("donetalking", doneTalkParrot)
    inst:ListenForEvent("ontalk", onTalkParrot)
end

local function parrot_pirate_master(inst)
    inst.components.inspectable.nameoverride = "PARROT"

    inst:AddComponent("named")
    inst.components.named.possiblenames = STRINGS.PARROTNAMES
    inst.components.named:PickNewName()
    inst.components.health.canmurder = false

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = TUNING.SANITYAURA_SMALL

    inst:AddComponent("talkingbird")
end

local function seagull_common(inst)
	inst:DoTaskInTime(0, updateWaterSeagull)
	inst:DoTaskInTime(1, updateWaterSeagull)
end

local function seagull_master(inst)
  inst.components.eater:SetOmnivore()
  
  inst:RemoveComponent("periodicspawner")
end

local function cormorant_common(inst)
	inst:DoTaskInTime(0, updateWaterCormorant)
	inst:DoTaskInTime(1, updateWaterCormorant)
	
	inst.Transform:SetScale(0.85, 0.85, 0.85)
end

local function cormorant_master(inst)
    inst.components.eater:SetOmnivore()
	inst.components.periodicspawner.onspawn = EatCormorantLoot

	inst:DoTaskInTime(0, ScheduleCormorantLoot)
end

return makebird("parrot", "robin", "ia/creatures/parrot/", nil),
makebird("parrot_pirate", "robin", "ia/creatures/parrot/", "parrot_pirate_bank", {{type = "ANIM", asset = "anim/parrot_pirate_bank.zip"}}, parrot_pirate_common, parrot_pirate_master),
makebird("toucan", "crow", "ia/creatures/toucan/"),
makebird("cormorant","crow", "ia/creatures/cormorant/", nil, {{type = "ANIM", asset = "anim/seagull.zip"}, {type = "ANIM", asset = "anim/cormorant_water.zip"}}, cormorant_common, cormorant_master),
makebird("seagull","robin_winter", "ia/creatures/seagull/", "seagull", {{type = "ANIM", asset = "anim/seagull_water.zip"}}, seagull_common, seagull_master)
