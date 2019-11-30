local assets = {
    Asset("ANIM", "anim/lobster_build.zip"),
    Asset("ANIM", "anim/lobster_build_color.zip"),
    Asset("ANIM", "anim/lobster.zip"),
}

local prefabs = {
    "lobster_dead",
}

local brain = require "brains/lobsterbrain"

local function StartDay(inst)
    if inst:IsAsleep() and inst.components.homeseeker then
        inst.components.homeseeker:GoHome(true)
    end
end

local function OnCookedFn(inst)
    inst.SoundEmitter:PlaySound("ia/creatures/lobster/death")
end

local function OnAttacked(inst, data)
    local x,y,z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x,y,z, 30, {'lobster'}, {"INLIMBO"})
    
    local num_friends = 0
    local maxnum = 5
    for k,v in pairs(ents) do
        v:PushEvent("gohome")
        num_friends = num_friends + 1
        
        if num_friends > maxnum then
            break
        end
    end
end

local function CanBeAttacked(inst)
    return not IsOnWater(inst)
end

local function onpickup(inst)
    inst.components.timer:StopTimer("dryout")
end

local function onnolongerlanded(inst)
	inst:RemoveTag("aquatic")
	inst:RemoveTag("fireimmune")
	inst:RemoveTag("noattack")
end

local function onlanded(inst)
	if IsOnWater(inst) then
        inst:AddTag("aquatic")
        inst:AddTag("fireimmune")
        inst:AddTag("noattack")
	else
		onnolongerlanded(inst)
	end
end

local function ondrop(inst)
    local onwater = IsOnWater(inst)

    --See where it is dropped
    --Start "death" logic if dropped on ground
    --Release if dropped in water.

    if not onwater then
        inst.AnimState:SetMultColour(1, 1, 1, 1)
        inst.AnimState:SetBuild("lobster_build_color")
        inst.sg:GoToState("stunned")
        inst.components.timer:StartTimer("dryout", 15)
        inst:RemoveTag("fireimmune")
    else
        --Play splash
        SpawnPrefab("splash_water_drop").Transform:SetPosition(inst:GetPosition():Get())
        inst.AnimState:SetMultColour(1, 1, 1, .30)
        inst.AnimState:SetBuild("lobster_build")
        inst.sg:GoToState("idle")
        inst:AddTag("fireimmune")
    end
end

local function ontimerdone(inst, data)
    if data.name and data.name == "dryout" then
		-- TODO this causes the lobster to seemingly duplicate for a moment, try locking the loot on the pos?
        inst.components.health:Kill()
    end
end

local function onload(inst)
    if IsOnWater(inst) then
        inst:AddTag("aquatic")
        inst:AddTag("fireimmune")
        inst:AddTag("noattack")
    end
end

local function ShouldSleep(inst)
    return NocturnalSleepTest(inst) and inst:GetIsOnWater()
end

local function ShouldWake(inst)
    return NocturnalWakeTest(inst) or not inst:GetIsOnWater()
end

local function onsleep(inst)
    if not IsOnWater(inst) then
        inst.components.health:Kill()
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddPhysics()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.Transform:SetFourFaced()

    MakeUnderwaterCharacterPhysics(inst, 1, 0.5)
    MakePoisonableCharacter(inst)

    inst.AnimState:SetBank("lobster")
    inst.AnimState:SetBuild("lobster_build")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    
    inst.AnimState:SetMultColour(1, 1, 1, .30)

    inst:AddTag("animal")
    inst:AddTag("prey")
    inst:AddTag("lobster")
    inst:AddTag("smallcreature")
    inst:AddTag("canbetrapped")
    inst:AddTag("packimfood")
    inst:AddTag("fireimmune")
    inst:AddTag("catfood")
    inst:AddTag("aquatic")

    --cookable (from cookable component) added to pristine state for optimization
    inst:AddTag("cookable")

    MakeFeedableSmallLivestockPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        function inst.OnEntityReplicated(inst)
            inst.replica.combat.canbeattackedfn = CanBeAttacked
        end
        return inst
    end

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = TUNING.LOBSTER_WALK_SPEED
    inst.components.locomotor.runspeed = TUNING.LOBSTER_RUN_SPEED
    inst:SetStateGraph("SGlobster")

    inst:SetBrain(brain)
    
    inst:AddComponent("eater")
    inst.components.eater:SetDiet({FOODTYPE.MEAT}, {FOODTYPE.MEAT})

    MakeInvItemIA(inst)
    inst.components.inventoryitem.nobounce = true
    inst.components.inventoryitem.canbepickedup = false
    inst.components.inventoryitem.canbepickedupalive = true
	inst.components.inventoryitem:SetSinks(false)
    inst.components.inventoryitem:SetOnPickupFn(onpickup)

    inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
    inst.components.tradable.dubloonvalue = TUNING.DUBLOON_VALUES.SEAFOOD

    inst:AddComponent("cookable")
    inst.components.cookable.product = "lobster_dead_cooked"
    inst.components.cookable:SetOnCookedFn(OnCookedFn)
    
    inst:AddComponent("knownlocations")

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "chest"
    inst.replica.combat.canbeattackedfn = CanBeAttacked

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.LOBSTER_HEALTH)
    inst.components.health.murdersound = "ia/creatures/lobster/death"
    
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"lobster_dead"})
    
    inst:AddComponent("inspectable")

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetNocturnal(true)
    inst.components.sleeper:SetWakeTest(ShouldWake)
    inst.components.sleeper:SetSleepTest(ShouldSleep)

    inst:AddComponent("appeasement")
    inst.components.appeasement.appeasementvalue = TUNING.APPEASEMENT_MEDIUM
    
    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", ontimerdone)

    MakeFeedableSmallLivestock(inst, TUNING.LOBSTER_PERISH_TIME, nil, ondrop)
    MakeSmallBurnableCharacter(inst, "chest")
    MakeTinyFreezableCharacter(inst, "chest")

    inst.no_wet_prefix = true
	inst:ListenForEvent("on_landed", onlanded)
	inst:ListenForEvent("on_no_longer_landed", onnolongerlanded)
    inst:ListenForEvent("attacked", OnAttacked)
    inst.OnLoad = onload

    inst:WatchWorldState("isday", function() StartDay(inst) end)
    inst:ListenForEvent("gotosleep", onsleep)

    return inst
end

return Prefab("lobster", fn, assets, prefabs)
