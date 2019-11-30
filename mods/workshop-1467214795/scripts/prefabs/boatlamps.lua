local MakeVisualBoatEquip = require("prefabs/visualboatequip")

local lanternassets = {
    Asset("ANIM", "anim/swap_lantern_boat.zip"),
}

local torchassets = {
    Asset("ANIM", "anim/swap_torch_boat.zip"),
}

local lanternprefabs = {
    "boat_lantern_light",
}

local torchprefabs = {
    "boat_torch_light",
}

local function fuelupdate(inst)
    if inst._light ~= nil then
        local fuelpercent = inst.components.fueled:GetPercent()
        inst._light.Light:SetIntensity(Lerp(0.4, 0.6, fuelpercent))
        inst._light.Light:SetRadius(Lerp(3, 5, fuelpercent))
        inst._light.Light:SetFalloff(0.9)
    end
end

local function setswapsymbol(inst, symbol)
    if inst.visual then
        inst.visual.AnimState:OverrideSymbol("swap_lantern", inst.visualbuild, symbol)
    end
end

local function turnon(inst)
    if not inst.components.fueled:IsEmpty() then
        if inst.onsound then
            for i, v in ipairs(inst.onsound) do
                inst.SoundEmitter:PlaySound(v)
            end
        end

        if not inst.SoundEmitter:PlayingSound("boatlamp") then 
            inst.SoundEmitter:PlaySound("ia/common/boatlantern_lp", "boatlamp")
        end

        if inst.components.fueled then
            inst.components.fueled:StartConsuming()        
        end
        
        if inst._light == nil or not inst._light:IsValid() then
            inst._light = SpawnPrefab(inst.prefab .."_light")
            if inst.components.fueled.accepting then
                fuelupdate(inst)
            end
        end

        local owner = inst.components.inventoryitem.owner

        inst._light.entity:SetParent((owner or inst).entity)
        setswapsymbol(inst, "swap_lantern")
    end

    inst.components.inventoryitem:ChangeImageName(inst.prefab)
end

local function turnoff(inst)
    inst.SoundEmitter:KillSound("boatlamp")
    
    if inst.offsound then
        for i, v in ipairs(inst.offsound) do
            inst.SoundEmitter:PlaySound(v)
        end
    end

    if inst.components.fueled then
        inst.components.fueled:StopConsuming()        
    end

    setswapsymbol(inst, "swap_lantern_off")
	
	if inst._light ~= nil then
        if inst._light:IsValid() then
            inst._light:Remove()
        end
        inst._light = nil
	end

    inst.components.inventoryitem:ChangeImageName(inst.prefab.."_off")
end

local function toggleon(inst)
    turnon(inst)
end

local function toggleoff(inst)
    turnoff(inst)
end

local function onequip(inst, owner)
    if owner.components.boatvisualmanager then
        owner.components.boatvisualmanager:SpawnBoatEquipVisuals(inst, inst.visualprefab)
    end
    setswapsymbol(inst, inst.components.equippable:IsToggledOn() and "swap_lantern" or "swap_lantern_off")
end

local function onunequip(inst, owner)
    if owner.components.boatvisualmanager then
        owner.components.boatvisualmanager:RemoveBoatEquipVisuals(inst)
    end
    inst.components.equippable:ToggleOff()
end

local function nofuel(inst)
    if inst.components.fueled.accepting then
        inst.components.equippable.togglable = false
        turnoff(inst)
    else
        inst:Remove()
    end
end

local function takefuel(inst)
    if inst.components.equippable and inst.components.equippable:IsEquipped() then
        inst.components.equippable.togglable = true
        turnon(inst)
    end
end

local function OnRemove(inst)
    if inst._light ~= nil then
        if inst._light:IsValid() then
            inst._light:Remove()
        end
        inst._light = nil
    end
end

local function ondropped(inst)
    turnoff(inst)
end
    
local function commonpristinefn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("lantern_boat")
    inst.AnimState:SetBuild("swap_lantern_boat")
    inst.AnimState:PlayAnimation("idle")

    inst.visualbuild = "swap_lantern_boat"

	MakeInventoryFloatable(inst)
	inst.components.floater:UpdateAnimations("idle_water", "idle")
	
    return inst
end

local function serverfn(inst)
    
    inst:AddComponent("inspectable")
    
    MakeInvItemIA(inst)
    inst.components.inventoryitem:SetOnDroppedFn(ondropped)
    inst.components.inventoryitem:ChangeImageName("boat_lantern_off")

    inst:AddComponent("fueled")
    inst.components.fueled:SetDepletedFn(nofuel)
    inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)
        
    inst:AddComponent("equippable")
    inst.components.equippable.boatequipslot = BOATEQUIPSLOTS.BOAT_LAMP
    inst.components.equippable.equipslot = nil
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.togglable = true
    inst.components.equippable.toggledonfn = toggleon
    inst.components.equippable.toggledofffn = toggleoff

    MakeHauntableLaunch(inst)
    
    inst.OnRemove = OnRemove
    
    return inst
end

local function lanternfn()
    local inst = commonpristinefn()

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.onsound = {"ia/common/boatlantern_turnon"}
    inst.offsound = {"ia/common/boatlantern_turnoff"}

    serverfn(inst)

    inst.visualprefab = "boat_lantern"

    inst.components.fueled.fueltype = "CAVE" --For using fireflies as the fuel 
    inst.components.fueled:InitializeFuelLevel(TUNING.BOAT_LANTERN_LIGHTTIME)
    inst.components.fueled:SetUpdateFn(fuelupdate)
    inst.components.fueled.ontakefuelfn = takefuel
    inst.components.fueled.accepting = true

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)
    
    return inst
end

local function torchfn()
    local inst = commonpristinefn()

    inst.AnimState:SetBuild("swap_torch_boat")

    inst.visualbuild = "swap_torch_boat"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.onsound = {"dontstarve/wilson/torch_swing"}
    inst.offsound = {"ia/common/boatlantern_turnoff", "dontstarve/common/fireOut"}

    serverfn(inst)

    inst.visualprefab = "boat_torch"

    inst.components.inventoryitem:ChangeImageName("boat_torch_off")

    inst.components.fueled.fueltype = "BURNABLE"
    inst.components.fueled:InitializeFuelLevel(TUNING.BOAT_TORCH_LIGHTTIME)
    
    return inst
end

local function commonpristinelightfn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    return inst
end

local function serverlightfn(inst)    
    inst.persists = false

    return inst
end

local function lanternlightfn()
    local inst = commonpristinelightfn()
    
    inst.Light:SetColour(180/255, 195/255, 150/255)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    return serverlightfn(inst)
end

local function torchlightfn()
    local inst = commonpristinelightfn()
    
    inst.Light:SetColour(200/255, 200/255, 50/255)
    inst.Light:SetRadius(2)
    inst.Light:SetIntensity(0.75)
    inst.Light:SetFalloff(0.5)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    return serverlightfn(inst)
end

local function lightfn()
    local inst = commonpristinelightfn()
    
    inst.Light:SetColour(200/255, 200/255, 50/255)
    inst.Light:SetRadius(2)
    inst.Light:SetIntensity(0.75)
    inst.Light:SetFalloff(0.5)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    return serverlightfn(inst)
end

function lantern_visual_common(inst)
    inst.AnimState:SetBank("sail_visual")
    inst.AnimState:SetBuild("swap_lantern_boat")
    inst.AnimState:PlayAnimation("idle_loop")
    inst.AnimState:SetSortWorldOffset(0, 0.05, 0) --below the player

    function inst.components.boatvisualanims.update(inst, dt)
        if inst.AnimState:GetCurrentFacing() == FACING_DOWN then
            inst.AnimState:SetSortWorldOffset(0, 0.15, 0) --above the player
        else
            inst.AnimState:SetSortWorldOffset(0, 0.05, 0) --below the player
        end
    end
end

function torch_visual_common(inst)
    inst.AnimState:SetBank("sail_visual")
    inst.AnimState:SetBuild("swap_torch_boat")
    inst.AnimState:PlayAnimation("idle_loop")
    inst.AnimState:SetSortWorldOffset(0, 0.05, 0) --below the player

    function inst.components.boatvisualanims.update(inst, dt)
        if inst.AnimState:GetCurrentFacing() == FACING_DOWN then
            inst.AnimState:SetSortWorldOffset(0, 0.15, 0) --above the player
        else
            inst.AnimState:SetSortWorldOffset(0, 0.05, 0) --below the player
        end
    end
end


return Prefab("boat_lantern", lanternfn, lanternassets, lanternprefabs),
    Prefab("boat_torch", torchfn, torchassets, torchprefabs),
    MakeVisualBoatEquip("boat_lantern", lanternassets, nil, lantern_visual_common),
    MakeVisualBoatEquip("boat_torch", torchassets, nil, torch_visual_common),
    Prefab("boat_lantern_light", lanternlightfn),
    Prefab("boat_torch_light", torchlightfn)