local rowboatassets = {
    Asset("ANIM", "anim/rowboat_basic.zip"),
    Asset("ANIM", "anim/rowboat_build.zip"),
    Asset("ANIM", "anim/rowboat_idles.zip"),
    Asset("ANIM", "anim/rowboat_paddle.zip"),
    Asset("ANIM", "anim/rowboat_trawl.zip"),
    Asset("ANIM", "anim/swap_sail.zip"),
    Asset("ANIM", "anim/swap_lantern_boat.zip"),
    Asset("ANIM", "anim/boat_hud_row.zip"),
    Asset("ANIM", "anim/boat_inspect_row.zip"),
    Asset("ANIM", "anim/flotsam_rowboat_build.zip"),
}

local raftassets = {
    Asset("ANIM", "anim/raft_basic.zip"),
    Asset("ANIM", "anim/raft_build.zip"),
    Asset("ANIM", "anim/raft_idles.zip"),
    Asset("ANIM", "anim/raft_paddle.zip"),
    Asset("ANIM", "anim/raft_trawl.zip"),
    Asset("ANIM", "anim/boat_hud_raft.zip"),
    Asset("ANIM", "anim/boat_inspect_raft.zip"),
    Asset("ANIM", "anim/flotsam_bamboo_build.zip"),
}

local surfboardassets = {
    Asset("ANIM", "anim/raft_basic.zip"),
    Asset("ANIM", "anim/raft_surfboard_build.zip"),
    Asset("ANIM", "anim/raft_idles.zip"),
    Asset("ANIM", "anim/raft_paddle.zip"),
    Asset("ANIM", "anim/raft_trawl.zip"),
    Asset("ANIM", "anim/boat_hud_raft.zip"),
    Asset("ANIM", "anim/boat_inspect_raft.zip"),
    Asset("ANIM", "anim/flotsam_surfboard_build.zip"),
    Asset("ANIM", "anim/surfboard.zip"),
}

local cargoassets = {
    Asset("ANIM", "anim/rowboat_basic.zip"),
    Asset("ANIM", "anim/rowboat_cargo_build.zip"),
    Asset("ANIM", "anim/rowboat_idles.zip"),
    Asset("ANIM", "anim/rowboat_paddle.zip"),
    Asset("ANIM", "anim/rowboat_trawl.zip"),
    Asset("ANIM", "anim/swap_sail.zip"),
    Asset("ANIM", "anim/swap_lantern_boat.zip"),
    Asset("ANIM", "anim/boat_hud_cargo.zip"),
    Asset("ANIM", "anim/boat_inspect_cargo.zip"),
    Asset("ANIM", "anim/flotsam_cargo_build.zip"),
}

local armouredboatassets = {
    Asset("ANIM", "anim/rowboat_basic.zip"),
    Asset("ANIM", "anim/rowboat_armored_build.zip"),
    Asset("ANIM", "anim/rowboat_idles.zip"),
    Asset("ANIM", "anim/rowboat_paddle.zip"),
    Asset("ANIM", "anim/rowboat_trawl.zip"),
    Asset("ANIM", "anim/swap_sail.zip"),
    Asset("ANIM", "anim/swap_lantern_boat.zip"),
    Asset("ANIM", "anim/boat_hud_row.zip"),
    Asset("ANIM", "anim/boat_inspect_row.zip"),
    Asset("ANIM", "anim/flotsam_armoured_build.zip"),
}

local encrustedboatassets = {
    Asset("ANIM", "anim/rowboat_basic.zip"),
    Asset("ANIM", "anim/rowboat_encrusted_build.zip"),
    Asset("ANIM", "anim/rowboat_idles.zip"),
    Asset("ANIM", "anim/rowboat_paddle.zip"),
    Asset("ANIM", "anim/rowboat_trawl.zip"),
    Asset("ANIM", "anim/swap_sail.zip"),
    Asset("ANIM", "anim/swap_lantern_boat.zip"),
    Asset("ANIM", "anim/boat_hud_encrusted.zip"),
    Asset("ANIM", "anim/boat_inspect_encrusted.zip"),
  -- TODO: add encrusted flotsam
    Asset("ANIM", "anim/flotsam_armoured_build.zip"),
}

local lograftassets = {
    Asset("ANIM", "anim/raft_basic.zip"),
    Asset("ANIM", "anim/raft_log_build.zip"),
    Asset("ANIM", "anim/raft_idles.zip"),
    Asset("ANIM", "anim/raft_paddle.zip"),
    Asset("ANIM", "anim/raft_trawl.zip"),
    Asset("ANIM", "anim/boat_hud_raft.zip"),
    Asset("ANIM", "anim/boat_inspect_raft.zip"),
    Asset("ANIM", "anim/flotsam_lograft_build.zip"),
}

local woodlegsboatassets = {
    Asset("ANIM", "anim/rowboat_basic.zip"),
    Asset("ANIM", "anim/pirate_boat_build.zip"),
    Asset("ANIM", "anim/rowboat_idles.zip"),
    Asset("ANIM", "anim/rowboat_paddle.zip"),
    Asset("ANIM", "anim/rowboat_trawl.zip"),
    Asset("ANIM", "anim/boat_hud_raft.zip"),
    Asset("ANIM", "anim/boat_inspect_raft.zip"),
    Asset("ANIM", "anim/flotsam_rowboat_build.zip"),
    Asset("ANIM", "anim/pirate_boat_placer.zip"),
}

local prefabs = {
    "rowboat_wake",
    "boat_hit_fx",
    "boat_hit_fx_raft_log",
    "boat_hit_fx_raft_bamboo",
    "boat_hit_fx_rowboat",
    "boat_hit_fx_cargoboat",
    "boat_hit_fx_armoured",
    "flotsam_armoured",
    "flotsam_bamboo",
    "flotsam_cargo",
    "flotsam_lograft",
    "flotsam_rowboat",
    "flotsam_surfboard",
}

local function sink(inst)
    local sailor = inst.components.sailable:GetSailor()
    if sailor then
        sailor.components.sailor:Disembark()

        if sailor.components.health then
            sailor.components.health:Drown()
        end

        inst.SoundEmitter:PlaySound(inst.sinksound) --Not sure why this is here and not in the SG -M
    end
    if inst.components.container then 
        inst.components.container:DropEverything()
    end
    
    inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("run_loop", true)
end

local function onworked(inst, worker)
    inst.components.lootdropper:DropLoot()
    if inst.components.container then
        inst.components.container:DropEverything()
    end
    SpawnAt("collapse_small", inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
    inst:Remove()
end

local function onrepaired(inst, doer, repair_item)
    inst.SoundEmitter:PlaySound("ia/common/boatrepairkit")
end

local function ondisembarked(inst)
    inst.components.workable.workable = false
end

local function onembarked(inst)
    inst.components.workable.workable = true
end

local function onopen(inst)
    if inst.components.sailable.sailor == nil then
        inst.SoundEmitter:PlaySound("ia/common/boat/inventory_open")
    end
end

local function onclose(inst)
    if inst.components.sailable.sailor == nil then
        inst.SoundEmitter:PlaySound("ia/common/boat/inventory_close")
    end
end

local function common()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddPhysics()
    inst.entity:AddMiniMapEntity()

    inst:AddTag("boat")
    inst:AddTag("sailable")

    inst.Transform:SetFourFaced()
    inst.MiniMapEntity:SetPriority(5)

    inst.Physics:SetCylinder(0.25,2)

    inst.no_wet_prefix = true

    inst.sailmusic = "sailing"

    inst.boatvisuals = {}

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("sailable")

    inst.components.sailable.sanitydrain = TUNING.RAFT_SANITY_DRAIN
    inst.components.sailable.movementbonus = TUNING.RAFT_SPEED
    inst.components.sailable.flotsambuild = "flotsam_bamboo_build"
    inst.components.sailable.maprevealbonus = TUNING.MAPREVEAL_RAFT_BONUS

    inst.landsound = "ia/common/boatjump_land_bamboo"
    inst.sinksound = "ia/common/boat/sinking/bamboo"

    inst.waveboost = TUNING.WAVEBOOST

    inst:AddComponent("rowboatwakespawner")

    inst:AddComponent("boathealth")
    inst.components.boathealth:SetDepletedFn(sink)
    inst.components.boathealth:SetHealth(TUNING.RAFT_HEALTH, TUNING.RAFT_PERISHTIME)
    inst.components.boathealth.leakinghealth = TUNING.RAFT_LEAKING_HEALTH
    inst.components.boathealth.damagesound = "ia/common/boat/damage/bamboo"
    inst.components.boathealth.hitfx = "boat_hit_fx_raft_bamboo"

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onworked)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("lootdropper")

    inst:AddComponent("repairable")
    inst.components.repairable.repairmaterial = "boat"
    inst.components.repairable.onrepaired = onrepaired

    inst:ListenForEvent("embarked", onembarked)
    inst:ListenForEvent("disembarked", ondisembarked)

    inst.onworked = onworked

    inst:AddComponent("flotsamspawner")

    inst.components.flotsamspawner.flotsamprefab = "flotsam_bamboo"

    inst:AddSpoofedComponent("boatcontainer", "container")

    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose

    inst:AddComponent("boatvisualmanager")

    return inst
end

local function raftfn()
    local inst = common()

    inst.AnimState:SetBank("raft")
    inst.AnimState:SetBuild("raft_build")
    inst.AnimState:PlayAnimation("run_loop", true)
    inst.MiniMapEntity:SetIcon("boat_raft.tex")

    if not TheWorld.ismastersim then
        function inst.OnEntityReplicated(inst)
            inst.replica.sailable.creaksound = "ia/common/boat/creaks/bamboo"
        end
        return inst
    end
    
    inst.components.container:WidgetSetup("boat_raft")

    inst.components.boathealth:SetHealth(TUNING.RAFT_HEALTH, TUNING.RAFT_PERISHTIME)
    inst.components.boathealth.leakinghealth = TUNING.RAFT_LEAKING_HEALTH
    inst.components.boathealth.damagesound = "ia/common/boat/damage/bamboo"
    inst.components.boathealth.hitfx = "boat_hit_fx_raft_bamboo"

    inst.landsound = "ia/common/boatjump_land_bamboo"
    inst.sinksound = "ia/common/boat/sinking/bamboo"

    inst.components.sailable.sanitydrain = TUNING.RAFT_SANITY_DRAIN
    inst.components.sailable.movementbonus = TUNING.RAFT_SPEED
    inst.components.sailable.flotsambuild = "flotsam_bamboo_build"
    inst.components.sailable.maprevealbonus = TUNING.MAPREVEAL_RAFT_BONUS
    inst.components.sailable.hitmoisturerate = TUNING.RAFT_HITMOISTURERATE

    inst.replica.sailable.creaksound = "ia/common/boat/creaks/bamboo"

    inst.components.flotsamspawner.flotsamprefab = "flotsam_bamboo"

    return inst
end

local function lograftfn()
    local inst = common()

    inst.AnimState:SetBank("raft")
    inst.AnimState:SetBuild("raft_log_build")
    inst.AnimState:PlayAnimation("run_loop", true)
    inst.MiniMapEntity:SetIcon("boat_lograft.tex")

    if not TheWorld.ismastersim then
        function inst.OnEntityReplicated(inst)
            inst.replica.sailable.creaksound = "ia/common/boat/creaks/log"
        end
        return inst
    end
    
    inst.components.container:WidgetSetup("boat_lograft")

    inst.components.boathealth:SetHealth(TUNING.LOGRAFT_HEALTH, TUNING.LOGRAFT_PERISHTIME)
    inst.components.boathealth.leakinghealth = TUNING.LOGRAFT_LEAKING_HEALTH
    inst.components.boathealth.damagesound = "ia/common/boat/damage/log"
    inst.components.boathealth.hitfx = "boat_hit_fx_raft_log"

    inst.landsound = "ia/common/boatjump_land_log"
    inst.sinksound = "ia/common/boat/sinking/log_cargo"

    inst.components.sailable.sanitydrain = TUNING.LOGRAFT_SANITY_DRAIN
    inst.components.sailable.movementbonus = TUNING.LOGRAFT_SPEED
    inst.components.sailable.flotsambuild = "flotsam_lograft_build"
    inst.components.sailable.maprevealbonus = TUNING.MAPREVEAL_LOGRAFT_BONUS
    inst.components.sailable.hitmoisturerate = TUNING.RAFT_HITMOISTURERATE

    inst.components.boathealth.damagesound = "ia/common/boat/damage/log"

    inst.components.flotsamspawner.flotsamprefab = "flotsam_lograft"

    return inst
end

local function rowboatfn()
    local inst = common()

    inst.AnimState:SetBank("rowboat")
    inst.AnimState:SetBuild("rowboat_build")
    inst.AnimState:PlayAnimation("run_loop", true)
    inst.MiniMapEntity:SetIcon("boat_row.tex")

    if not TheWorld.ismastersim then
        function inst.OnEntityReplicated(inst)

        end
        return inst
    end
    
    inst.components.container:WidgetSetup("boat_row")

    inst.components.boathealth:SetHealth(TUNING.ROWBOAT_HEALTH, TUNING.ROWBOAT_PERISHTIME)
    inst.components.boathealth.leakinghealth = TUNING.ROWBOAT_LEAKING_HEALTH
    inst.components.boathealth.damagesound = "ia/common/boat/damage/row"
    inst.components.boathealth.hitfx = "boat_hit_fx_rowboat"

    inst.landsound = "ia/common/boatjump_land_wood"
    inst.sinksound = "ia/common/boat/sinking/row"

    inst.components.sailable.sanitydrain = TUNING.ROWBOAT_SANITY_DRAIN
    inst.components.sailable.movementbonus = TUNING.ROWBOAT_SPEED
    inst.components.sailable.flotsambuild = "flotsam_rowboat_build"
    inst.components.sailable.maprevealbonus = TUNING.MAPREVEAL_ROWBOAT_BONUS

    inst.components.flotsamspawner.flotsamprefab = "flotsam_rowboat"

    return inst 
end

local function armouredboatfn()
    local inst = common()

    inst.AnimState:SetBank("rowboat")
    inst.AnimState:SetBuild("rowboat_armored_build")
    inst.AnimState:PlayAnimation("run_loop", true)
    inst.MiniMapEntity:SetIcon("boat_armoured.tex")

    if not TheWorld.ismastersim then
        function inst.OnEntityReplicated(inst)
            inst.replica.sailable.creaksound = "ia/common/boat/creaks/armoured"
        end
        return inst
    end

    inst.components.container:WidgetSetup("boat_armoured")

    inst.components.boathealth:SetHealth(TUNING.ARMOUREDBOAT_HEALTH, TUNING.ARMOUREDBOAT_PERISHTIME)
    inst.components.boathealth.leakinghealth = TUNING.ARMOUREDBOAT_LEAKING_HEALTH
    inst.components.boathealth.damagesound = "ia/common/boat/damage/armoured"
    inst.components.boathealth.hitfx = "boat_hit_fx_armoured"

    inst.landsound = "ia/common/boatjump_land_shell"
    inst.sinksound = "ia/common/boat/sinking/row"

    inst.components.sailable.sanitydrain = TUNING.ARMOUREDBOAT_SANITY_DRAIN
    inst.components.sailable.movementbonus = TUNING.ARMOUREDBOAT_SPEED
    inst.components.sailable.flotsambuild = "flotsam_armoured_build"
    inst.components.sailable.maprevealbonus = TUNING.MAPREVEAL_ARMOUREDBOAT_BONUS
    inst.components.sailable:SetHitImmunity(TUNING.ARMOUREDBOAT_HIT_IMMUNITY)

    inst.replica.sailable.creaksound = "ia/common/boat/creaks/armoured"

    inst.components.flotsamspawner.flotsamprefab = "flotsam_armoured"

    return inst
end

local function encrustedboatfn()
    local inst = common()

    inst.AnimState:SetBank("rowboat")
    inst.AnimState:SetBuild("rowboat_encrusted_build")
    inst.AnimState:PlayAnimation("run_loop", true)
    inst.MiniMapEntity:SetIcon("boat_encrusted.tex")

    if not TheWorld.ismastersim then
        function inst.OnEntityReplicated(inst)
            inst.replica.sailable.creaksound = "ia/common/boat/creaks/encrusted"
        end
        return inst
    end

    inst.waveboost = TUNING.ENCRUSTEDBOAT_WAVEBOOST

    inst.components.container:WidgetSetup("boat_encrusted")

    inst.components.boathealth:SetHealth(TUNING.ENCRUSTEDBOAT_HEALTH, TUNING.ENCRUSTEDBOAT_PERISHTIME)
    inst.components.boathealth.leakinghealth = TUNING.ENCRUSTEDBOAT_LEAKING_HEALTH
    inst.components.boathealth.damagesound = "ia/common/boat/damage/encrusted"
    inst.components.boathealth.hitfx = "boat_hit_fx_armoured"

    inst.landsound = "ia/common/boatjump_land_shell"
    inst.sinksound = "ia/common/boat/sinking/row"

    inst.components.sailable.sanitydrain = TUNING.ENCRUSTEDBOAT_SANITY_DRAIN
    inst.components.sailable.movementbonus = TUNING.ENCRUSTEDBOAT_SPEED
    inst.components.sailable.flotsambuild = "flotsam_armoured_build"
    inst.components.sailable.maprevealbonus = TUNING.MAPREVEAL_ENCRUSTEDBOAT_BONUS
    inst.components.sailable:SetHitImmunity(TUNING.ENCRUSTEDBOAT_HIT_IMMUNITY)

    inst.replica.sailable.creaksound = "ia/common/boat/creaks/encrusted"

    inst.components.flotsamspawner.flotsamprefab = "flotsam_armoured"

    return inst
end

local function cargofn()
    local inst = common()

    inst.AnimState:SetBank("rowboat")
    inst.AnimState:SetBuild("rowboat_cargo_build")
    inst.AnimState:PlayAnimation("run_loop", true)
    inst.MiniMapEntity:SetIcon("boat_cargo.tex")

    if not TheWorld.ismastersim then
        function inst.OnEntityReplicated(inst)
            inst.replica.sailable.creaksound = "ia/common/boat/creaks/cargo"
        end
        return inst
    end

    inst.components.container:WidgetSetup("boat_cargo")

    inst.components.boathealth:SetHealth(TUNING.CARGOBOAT_HEALTH, TUNING.CARGOBOAT_PERISHTIME)
    inst.components.boathealth.damagesound = "ia/common/boat/damage/cargo"
    inst.components.boathealth.hitfx = "boat_hit_fx_cargoboat"

    inst.landsound = "ia/common/boatjump_land_wood"
    inst.sinksound = "ia/common/boat/sinking/log_cargo"

    inst.components.sailable.sanitydrain = TUNING.CARGOBOAT_SANITY_DRAIN
    inst.components.sailable.movementbonus = TUNING.CARGOBOAT_SPEED
    inst.components.sailable.flotsambuild = "flotsam_rowboat_build"
    inst.components.sailable.maprevealbonus = TUNING.MAPREVEAL_CARGOBOAT_BONUS

    inst.replica.sailable.creaksound = "ia/common/boat/creaks/cargo"

    inst.components.flotsamspawner.flotsamprefab = "flotsam_cargo"

    return inst
end

local function woodlegsboatfn()
    local inst = common()

    inst.AnimState:SetBank("rowboat")
    inst.AnimState:SetBuild("pirate_boat_build")
    inst.AnimState:PlayAnimation("run_loop", true)
    inst.MiniMapEntity:SetIcon("boat_woodlegs.tex")

    if not TheWorld.ismastersim then
        function inst.OnEntityReplicated(inst)
            inst.replica.sailable.creaksound = "ia/common/boat/creaks/armoured"
        end
        return inst
    end

    inst.components.container:WidgetSetup("boat_woodlegs")

    inst.components.boathealth:SetHealth(TUNING.WOODLEGSBOAT_HEALTH, TUNING.ARMOUREDBOAT_PERISHTIME)
    inst.components.boathealth.leakinghealth = TUNING.WOODLEGSBOAT_LEAKING_HEALTH
    inst.components.boathealth.damagesound = "ia/common/boat/damage/armoured"
    inst.components.boathealth.hitfx = "boat_hit_fx_armoured"

    inst.landsound = "ia/common/boatjump_land_shell"
    inst.sinksound = "ia/common/boat/sinking/row"

    inst.components.sailable.sanitydrain = 0
    inst.components.sailable.movementbonus = TUNING.WOODLEGSBOAT_SPEED
    inst.components.sailable.flotsambuild = "flotsam_armoured_build"
    inst.components.sailable.maprevealbonus = TUNING.MAPREVEAL_WOODLEGSBOAT_BONUS
    inst.components.sailable:SetHitImmunity(TUNING.WOODLEGSBOAT_HIT_IMMUNITY)

    inst.replica.sailable.creaksound = "ia/common/boat/creaks/armoured"

    inst.components.flotsamspawner.flotsamprefab = "flotsam_rowboat"

    inst:DoTaskInTime(0.1, function(inst)
        local sailitem = inst.components.container:GetItemInBoatSlot(BOATEQUIPSLOTS.BOAT_SAIL)
        if sailitem == nil then
            local sail = SpawnPrefab("sail_woodlegs")
            inst.components.container:Equip(sail)
        end
        local torchitem = inst.components.container:GetItemInBoatSlot(BOATEQUIPSLOTS.BOAT_LAMP)
        if torchitem == nil then
            local cannon = SpawnPrefab("woodlegs_boatcannon")
            inst.components.container:Equip(cannon)
        end
    end)

    return inst
end

local function pickupfn(inst, guy)
    local board = SpawnPrefab("surfboard_item")
    guy.components.inventory:GiveItem(board)
    --  board.components.pocket:GiveItem("surfboard", inst)
    return true
end

local function surfboardfn()
    local inst = common()

    inst.AnimState:SetBank("raft")
    inst.AnimState:SetBuild("raft_surfboard_build")
    inst.AnimState:PlayAnimation("run_loop", true)
    inst.MiniMapEntity:SetIcon("surfboard.tex")

    inst:AddTag("surfboard")

    if not TheWorld.ismastersim then
        function inst.OnEntityReplicated(inst)

        end
        return inst
    end

    inst.components.container:WidgetSetup("surfboard")

    inst.sinksound = "ia/common/boat/sinking/log_cargo"
    inst.sailsound = "ia/common/sail_LP/surfboard"
    inst.sailmusic = "surfing"

    inst.waveboost = TUNING.SURFBOARD_WAVEBOOST
    inst.wavesanityboost = TUNING.SURFBOARD_WAVESANITYBOOST

    inst.components.sailable.movementbonus = TUNING.SURFBOARD_SPEED
    inst.components.sailable.maprevealbonus = TUNING.MAPREVEAL_RAFT_BONUS
    inst.components.sailable.hitmoisturerate = TUNING.SURFBOARD_HITMOISTURERATE

    --inst.components.sailable.flotsambuild = "flotsam_rowboat_build"

    inst.perishtime = TUNING.SURFBOARD_PERISHTIME
    inst.components.boathealth.maxhealth = TUNING.SURFBOARD_HEALTH
    inst.components.boathealth:SetHealth(TUNING.SURFBOARD_HEALTH, inst.perishtime)

    inst.components.boathealth.damagesound = "ia/common/boat/damage/surfboard"

    --  inst:AddComponent("characterspecific")
    --  inst.components.characterspecific:SetOwner("walani")

    --  inst:AddComponent("pickupable")
    --  inst.components.pickupable:SetOnPickupFn(pickupfn)
    --  inst:SetInherentSceneAltAction(ACTIONS.RETRIEVE)

    inst.components.flotsamspawner.flotsamprefab = "flotsam_surfboard"

    return inst
end

local function surfboard_ondropped(inst)
    --If this is a valid place to be deployed, auto deploy yourself.
    if inst.components.deployable and inst.components.deployable:CanDeploy(inst:GetPosition()) then
        inst.components.deployable:Deploy(inst:GetPosition(), inst)
    end
end

local function surfboarditemfn(Sim)
    local inst = CreateEntity()

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetPriority( 5 )
    minimap:SetIcon("surfboard.tex")

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    inst.entity:AddNetwork()

    inst:AddTag("boat")

    inst.AnimState:SetBank("surfboard")
    inst.AnimState:SetBuild("surfboard")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetOnDroppedFn(surfboard_ondropped)

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploy
    inst.components.deployable.placer = "surfboard_placer"
    inst.components.deployable.test = deploytest
    inst.components.deployable.deploydistance = 3

    --inst:AddComponent("characterspecific")
    --inst.components.characterspecific:SetOwner("walani")

    return inst
end

return Prefab("boat_raft", raftfn, raftassets, prefabs),
Prefab("boat_lograft", lograftfn, lograftassets, prefabs),
Prefab("boat_row", rowboatfn, rowboatassets, prefabs),
Prefab("boat_armoured", armouredboatfn, armouredboatassets, prefabs),
Prefab("boat_encrusted", encrustedboatfn, encrustedboatassets, prefabs),
Prefab("boat_cargo", cargofn, cargoassets, prefabs),
Prefab("boat_woodlegs", woodlegsboatfn, woodlegsboatassets, prefabs),
Prefab("boat_surfboard", surfboardfn, surfboardassets, prefabs),
Prefab("inv_surfboard", surfboarditemfn, surfboardassets, prefabs),
MakePlacer("boat_raft_placer", "raft", "raft_build", "run_loop"),
MakePlacer("boat_lograft_placer", "raft", "raft_log_build", "run_loop"),
MakePlacer("boat_row_placer", "rowboat", "rowboat_build", "run_loop"), 
MakePlacer("boat_armoured_placer", "rowboat", "rowboat_armored_build", "run_loop"), 
MakePlacer("boat_encrusted_placer", "rowboat", "rowboat_encrusted_build", "run_loop"), 
MakePlacer("boat_cargo_placer", "rowboat", "rowboat_cargo_build", "run_loop"), 
MakePlacer("boat_surfboard_placer", "raft", "raft_surfboard_build", "run_loop"), 
MakePlacer("boat_woodlegs_placer", "rowboat", "pirate_boat_build", "run_loop")