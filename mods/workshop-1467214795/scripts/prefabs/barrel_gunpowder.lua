local assets =
{
    Asset("ANIM", "anim/gunpowder_barrel.zip"),
    Asset("ANIM", "anim/explode.zip"),
    Asset("MINIMAP_IMAGE", "barrel_gunpowder")
}

local prefabs =
{
    "explode_small",
}

local function OnIgnite(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_fuse_LP", "hiss")
end

local function OnExplode(inst)
    inst.SoundEmitter:KillSound("hiss")

    local pos = inst:GetPosition()
    SpawnWaves(inst, 6, 360, 5)
    local splash = SpawnPrefab("bombsplash")
    splash.Transform:SetPosition(pos.x, pos.y, pos.z)

    inst.SoundEmitter:PlaySound("ia/common/powderkeg/powderkeg")
    inst.SoundEmitter:PlaySound("ia/common/powderkeg/splash_medium")
end
local function OnHit(inst)
    if inst.components.burnable then
        inst.components.burnable:Ignite()
    end
    if inst.components.freezable then
        inst.components.freezable:UnFreeze()
    end
    if inst.components.health then
        inst.components.health:DoFireDamage(0)
    end
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    
    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("barrel_gunpowder.tex")

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("gunpowder_barrel")
    inst.AnimState:SetBuild("gunpowder_barrel")
    inst.AnimState:PlayAnimation("idle_water")

    --MakeRipples(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(1000000)

    inst:AddComponent("combat")
    inst.components.combat:SetOnHit(OnHit)

    MakeSmallBurnable(inst, 3 + math.random() * 3)
    MakeSmallPropagator(inst)

    inst.components.burnable:SetOnBurntFn(nil)

    inst:AddComponent("explosive")
    inst.components.explosive:SetOnExplodeFn(OnExplode)
    inst.components.explosive:SetOnIgniteFn(OnIgnite)
    inst.components.explosive.explosiverange = TUNING.BARREL_GUNPOWDER_RANGE
    inst.components.explosive.explosivedamage = TUNING.BARREL_GUNPOWDER_DAMAGE
    inst.components.explosive.buildingdamage = 0

	-- er... this can't even go to the altar?
    inst:AddComponent("appeasement")
    inst.components.appeasement.appeasementvalue = TUNING.WRATH_HUGE

    return inst
end

return Prefab("barrel_gunpowder", fn, assets, prefabs)