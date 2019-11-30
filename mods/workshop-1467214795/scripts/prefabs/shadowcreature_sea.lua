local prefabs = {
    "nightmarefuel",
}

local brain = require("brains/shadowcreaturebrain")

local function NotifyBrainOfTarget(inst, target)
    if inst.brain ~= nil and inst.brain.SetTarget ~= nil then
        inst.brain:SetTarget(target)
    end
end

local function retargetfn(inst)
    local maxrangesq = TUNING.SHADOWCREATURE_TARGET_DIST * TUNING.SHADOWCREATURE_TARGET_DIST
    local rangesq, rangesq1, rangesq2 = maxrangesq, math.huge, math.huge
    local target1, target2 = nil, nil
    for i, v in ipairs(AllPlayers) do
        if v.components.sanity:IsCrazy() and not v:HasTag("playerghost") then
            local distsq = v:GetDistanceSqToInst(inst)
            if distsq < rangesq then
                if inst.components.shadowsubmissive:TargetHasDominance(v) then
                    if distsq < rangesq1 and inst.components.combat:CanTarget(v) then
                        target1 = v
                        rangesq1 = distsq
                        rangesq = math.max(rangesq1, rangesq2)
                    end
                elseif distsq < rangesq2 and inst.components.combat:CanTarget(v) then
                    target2 = v
                    rangesq2 = distsq
                    rangesq = math.max(rangesq1, rangesq2)
                end
            end
        end
    end

    if target1 ~= nil and rangesq1 <= math.max(rangesq2, maxrangesq * .25) then
        --Targets with shadow dominance have higher priority within half targeting range
        --Force target switch if current target does not have shadow dominance
        return target1, not inst.components.shadowsubmissive:TargetHasDominance(inst.components.combat.target)
    end
    return target2
end

local function onkilledbyother(inst, attacker)
    if attacker and attacker.components.sanity then
        attacker.components.sanity:DoDelta(inst.sanityreward or TUNING.SANITY_SMALL)
    end
end

local function CalcSanityAura(inst, observer)
    return inst.components.combat:HasTarget()
        and observer.components.sanity:IsCrazy()
        and -TUNING.SANITYAURA_LARGE
        or 0
end

local function ShareTargetFn(dude)
    return dude:HasTag("shadowcreature") and not dude.components.health:IsDead()
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30, ShareTargetFn, 1)
end

local function OnNewCombatTarget(inst, data)
    NotifyBrainOfTarget(inst, data.target)
end

local function MakeShadowCreature(data)    
    local assets = {
        Asset("ANIM", "anim/"..data.build..".zip"),
    }
    
    local sounds = {
        attack = "dontstarve/sanity/creature"..data.num.."/attack",
        attack_grunt = "dontstarve/sanity/creature"..data.num.."/attack_grunt",
        death = "dontstarve/sanity/creature"..data.num.."/die",
        idle = "dontstarve/sanity/creature"..data.num.."/idle",
        taunt = "dontstarve/sanity/creature"..data.num.."/taunt",
        appear = "dontstarve/sanity/creature"..data.num.."/appear",
        disappear = "dontstarve/sanity/creature"..data.num.."/dissappear",
    }

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeCharacterPhysics(inst, 10, 1.5)
        RemovePhysicsColliders(inst)
        inst.Physics:SetCollisionGroup(COLLISION.SANITY)
        inst.Physics:CollidesWith(COLLISION.SANITY)

        inst.Transform:SetSixFaced()

        inst:AddTag("shadowcreature")
        inst:AddTag("monster")
        inst:AddTag("hostile")
        inst:AddTag("shadow")
        inst:AddTag("notraptrigger")
        inst:AddTag("aquatic")

        inst.AnimState:SetBank(data.bank)
        inst.AnimState:SetBuild(data.build)
        inst.AnimState:PlayAnimation("idle", true)
        inst.AnimState:SetMultColour(1, 1, 1, .5)

        -- this is purely view related
        inst:AddComponent("transparentonsanity")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
        inst.components.locomotor.walkspeed = data.speed
        inst.sounds = sounds
        inst:SetStateGraph("SGshadowcreature_sea")

        inst:SetBrain(brain)
        
        inst:AddComponent("sanityaura")
        inst.components.sanityaura.aurafn = CalcSanityAura
        
        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(data.health)
        inst.components.health.nofadeout = true
        
        inst.sanityreward = data.sanityreward
        
        inst:AddComponent("combat")
        inst.components.combat:SetDefaultDamage(data.damage)
        inst.components.combat:SetAttackPeriod(data.attackperiod)
        inst.components.combat:SetRetargetFunction(3, retargetfn)
        inst.components.combat.onkilledbyother = onkilledbyother

        inst:AddComponent("shadowsubmissive")

        inst:AddComponent("lootdropper")
        inst.components.lootdropper:SetChanceLootTable("shadow_creature")
        
        inst:ListenForEvent("attacked", OnAttacked)
        inst:ListenForEvent("newcombattarget", OnNewCombatTarget)

        inst.persists = false

        return inst
    end
        
    return Prefab(data.name, fn, assets, prefabs)
end

local data = {
    {
        name = "swimminghorror",
        build = "shadow_insanity_water1",
        bank = "shadowseacreature",
        num = 1,
        speed = TUNING.CRAWLINGHORROR_SPEED,
        health = TUNING.CRAWLINGHORROR_HEALTH,
        damage = TUNING.CRAWLINGHORROR_DAMAGE,
        attackperiod = TUNING.CRAWLINGHORROR_ATTACK_PERIOD,
        sanityreward = TUNING.SANITY_MED
    }
}

local ret = {}
for k,v in pairs(data) do
    table.insert(ret, MakeShadowCreature(v))
end

return unpack(ret) 