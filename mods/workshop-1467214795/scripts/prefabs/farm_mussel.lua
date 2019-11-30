require "prefabutil"

local assets = 
{
    Asset("ANIM", "anim/musselfarm.zip"),
    Asset("MINIMAP_IMAGE", "farm_mussel")
}

local prefabs =
{
    "mussel",
    "collapse_small",
}

local function NewPoint(pt)
    local theta = math.random() * 2 * PI
    local radius = 6 + math.random() * 6

    local result_offset = FindValidPositionByFan(theta, radius, 12, function(offset)
        local spawn_point = pt + offset
        if GetGroundTypeAtPosition(spawn_point) == GROUND.OCEAN_SHALLOW then
            return true
        end
        return false
    end)

    if result_offset then
        return pt + result_offset
    end
end

local function MoveLocations(inst, child)
    local pos = Vectory3(inst.Transform:GetWorldPosition())
    local spawn_point = NewPoint(pos)

    if spawn_point then
        child.Transform:SetPosition(spawn_point:Get())
    end
end

local function OnPicked(inst, picker)
    inst.AnimState:PlayAnimation("picked")
    inst.components.growable:SetStage(1)
end

local function GetStatus(inst)
    if inst.growthstage > 0 then
        return "STICK_PLANTED"
    end
end

local function MakeEmpty(inst)
    -- never called?
end
local function MakeFull(inst)
    inst.AnimState:PlayAnimation("idle_full")
end

-- Stages
local function SetHidden(inst)
    inst.components.pickable.numtoharvest = 0
    inst.components.pickable.canbepicked = false
    --inst.components.blowinwindgust:Stop()
    inst.MiniMapEntity:SetEnabled(false)
    inst.Physics:SetCollides(false)
    inst:Hide()
    inst.components.stickable:UnStuck()
end

local function SetUnderwater(inst)
    inst.AnimState:PlayAnimation("idle_underwater", true)
    inst.components.pickable.numtoharvest = 0
    inst.components.pickable.canbepicked = false
    --inst.components.blowinwindgust:STop()
    inst.AnimState:SetLayer( LAYER_BACKGROUND )
    inst.AnimState:SetSortOrder( 2 )
    inst.MiniMapEntity:SetEnabled(false)
    inst.Physics:SetCollides(false)
    inst:Show()
    inst.components.stickable:UnStuck()
end

local function SetAboveWater(inst)
    -- common
    inst.AnimState:SetLayer( LAYER_WORLD )
    inst.AnimState:SetSortOrder( 0 )
    --inst.components.blowinwidngust:Start()
    inst.MiniMapEntity:SetEnabled(true)
    inst.Physics:SetCollides(true)
    inst.components.growable:StartGrowing()
    inst:Show()
    inst.components.stickable:Stuck()
end

local function SetEmpty(inst)
    inst.AnimState:PlayAnimation("idle_empty", true)
    inst.components.pickable.numtoharvest = 0
    inst.components.pickable.canbepicked = false
    inst.components.pickable.hasbeenpicked = false

    SetAboveWater(inst)
end

local function SetSmall(inst)
    inst.AnimState:PlayAnimation("idle_small", true)
    inst.components.pickable.numtoharvest = TUNING.MUSSEL_CATCH_SMALL
    inst.components.pickable.canbepicked = true
    inst.components.pickable.hasbeenpicked = false

    SetAboveWater(inst)
end

local function SetMedium(inst)
    inst.AnimState:PlayAnimation("idle_small", true)
    inst.components.pickable.numtoharvest = TUNING.MUSSEL_CATCH_MED
    inst.components.pickable.canbepicked = true
    inst.components.pickable.hasbeenpicked = false

    SetAboveWater(inst)
end

local function SetFull(inst)
    inst.AnimState:PlayAnimation("idle_full", true)
    inst.components.pickable.numtoharvest = TUNING.MUSSEL_CATCH_LARGE
    inst.components.pickable.canbepicked = true
    inst.components.pickable.hasbeenpicked = false

    SetAboveWater(inst)
end

local function GrowHidden(inst)
end

local function GrowUnderwater(inst)
end

local function GrowEmpty(inst)
    inst.growthstage = 2
    inst.AnimState:PlayAnimation("empty_to_small")
    inst.AnimState:PushAnimation("idle_small", true)
end

local function GrowSmall(inst)
end

local function GrowMedium(inst)
    inst.AnimState:PlayAnimation("small_to_full")
    inst.AnimState:PushAnimation("idle_full", true)
end

local function GrowFull(inst)
end

local function GrowTime(inst)
    return GetRandomWithVariance(TUNING.MUSSEL_CATCH_TIME.BASE, TUNING.MUSSEL_CATCH_TIME.RANDOM)
end

local growth_stages =
{
    {
        name = "hidden",
        time = GrowTime,
        fn = SetHidden,
        growfn = GrowHidden,
    },
    {
        name = "underwater",
        time = function(inst)
            return nil
        end,
        fn = SetUnderwater,
        growfn = GrowUnderwater,
    },
    {
        name = "empty",
        time = GrowTime,
        fn = SetEmpty,
        growfn = GrowEmpty,
    },
    {
        name = "small",
        time = GrowTime,
        fn = SetSmall,
        growfn = GrowSmall,
    },
    {
        name = "medium",
        time = GrowTime,
        fn = SetMedium,
        growfn = GrowMedium,
    },
    {
        name = "full",
        time = GrowTime,
        fn = SetFull,
        growfn = GrowFull,
    }
}

local function OnPoked(inst, worker, stick)
    inst.SoundEmitter:PlaySound("ia/common/plant_mussel")
    inst.components.growable:SetStage(3)

    if stick.components.stackable and stick.components.stackable.stacksize > 1 then
        stick = stick.components.stackable:Get()
    end

    stick:Remove()
end

local function OnGustHarvest(inst)
    if inst.components.pickable and inst.components.pickable.numtoharvest > 0 then
        for i = 1, inst.components.pickable.numtoharvest, 1 do
            inst.components.lootdropper:SpawnLootPrefab(
                inst.components.pickable.product)
        end
        OnPicked(inst, nil)
    end
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 0.8, 1.2)
 	inst.Physics:SetCollides(false)

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("farm_mussel.tex")
    minimap:SetEnabled(false)

    inst.AnimState:SetBank("musselfarm")
    inst.AnimState:SetBuild("musselfarm")
    inst.AnimState:PlayAnimation("idle_underwater", true)
    inst.AnimState:SetLayer( LAYER_BACKGROUND )
    inst.AnimState:SetSortOrder( 3 )
    inst.AnimState:SetRayTestOnBB(true)

    inst:AddTag("structure")
    inst:AddTag("farm_mussel")
    inst:AddTag("aquatic")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.no_wet_prefix = true
	inst.growthstage = 0
	inst.targettime = nil

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus

    inst:AddComponent("stickable")
    inst.components.stickable:SetOnPokeCallback(OnPoked)

--	inst:AddComponent("blowinwindgust")
--	inst.components.blowinwindgust:SetWindSpeedThreshold(TUNING.MUSSELFARM_WINDBLOWN_SPEED)
--	inst.components.blowinwindgust:SetDestroyChance(TUNING.MUSSELFARM_WINDBLOWN_FALL_CHANCE)
--	inst.components.blowinwindgust:SetDestroyFn(ongustharvest)

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/harvest_berries"
    inst.components.pickable.canbepicked = false
    inst.components.pickable.hasbeenpicked = false
    inst.components.pickable.product = "mussel"
    inst.components.pickable.numtoharvest = 0
    inst.components.pickable.onpickedfn = OnPicked
    inst.components.pickable.makeemptyfn = MakeEmpty
    inst.components.pickable.makefullfn = MakeFull
    inst.components.pickable.makebarrenfn = MakeEmpty

    inst:AddComponent("growable")
    inst.components.growable.stages = growth_stages
    inst.components.growable:SetStage(2)
    inst.components.growable.loopstages = false

    inst:AddComponent("lootdropper")

    return inst
end

return Prefab( "farm_mussel", fn, assets, prefabs)