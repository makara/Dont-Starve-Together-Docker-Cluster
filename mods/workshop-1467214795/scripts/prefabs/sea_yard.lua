require "prefabutil"

local assets = {
    Asset("ANIM", "anim/sea_yard.zip"),
    Asset("ANIM", "anim/sea_yard_meter.zip"),   
}

local prefabs = {
    "collapse_big",
    "sea_yard_arms_fx"
}

local function StartTimer(inst)
    if not inst.task_fix then
        inst.task_fix = inst:DoTaskInTime(1, function()
            inst.task_fix = nil
            inst.fixfn(inst)
        end)
    end
end

local function fixfn(inst)
    for i, user in ipairs(inst.components.autofixer.users) do
        if user.components.sailor and user.components.sailor.boat and user.components.sailor.boat.components.boathealth and user.armsfx then
            local boat = user.components.sailor.boat
            local oldpercent = boat.components.boathealth:GetPercent()
            local newpercent = math.min(1, oldpercent + 0.005)
            boat.components.boathealth:SetPercent(newpercent)
            if newpercent >= 1 then
                inst.components.autofixer:TurnOff(user)
            end 
        else
            inst.components.autofixer:TurnOff(user)
        end
    end
    if #inst.components.autofixer.users > 0 then
        StartTimer(inst)
    end
end

local function autofixtestfn(inst, user)
    return user.components.sailor and user.components.sailor.boat and user.components.sailor.boat.components.boathealth and user.components.sailor.boat.components.boathealth:GetPercent() < 1
end

local function canturnon(inst)
    return not inst.components.fueled:IsEmpty()
end

local function startfixing(inst, user)
    if autofixtestfn(inst, user) then
        if not user.armsfx then     
            local arms = SpawnPrefab("sea_yard_arms_fx")
            arms.entity:SetParent(user.entity)
            arms.AnimState:SetFinalOffset(5)
            
            user.armsfx = arms
            inst.components.fueled.rate = #inst.components.autofixer.users
            if not inst.components.fueled.consuming then                                       
                inst.components.fueled:StartConsuming()
            end         
        end
    end
    StartTimer(inst)
end

local function stopfixing(inst, user)
    local _usercount = #inst.components.autofixer.users
    if _usercount == 0 then
        inst.components.fueled.rate = 1
        inst.components.fueled:StopConsuming()
    elseif _usercount >= 1 then
        inst.components.fueled.rate = _usercount
    end

    if user.armsfx then
        user.armsfx.stopfx(user.armsfx, user)        
    end
end

local function onturnon(inst)
    if not inst:HasTag("burnt") then
        inst.SoundEmitter:PlaySound("ia/creatures/seagull/chirp")
        inst:DoTaskInTime(18 * FRAMES, function() inst.SoundEmitter:PlaySound("ia/creatures/seagull/chirp") end)
        inst.AnimState:PlayAnimation("enter")
        inst.AnimState:PushAnimation("idle", true)
    end
end

local function onturnoff(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PushAnimation("idle", true)
    end
end

local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_big")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("hit")

        inst.AnimState:PushAnimation("idle", true)
                
        inst.SoundEmitter:PlaySound("ia/creatures/seagull/chirp")
    end
end

local function OnSave(inst, data)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
end

local function OnLoad(inst, data)
    if data ~= nil and data.burnt and inst.components.burnable ~= nil and inst.components.burnable.onburnt ~= nil then
        inst.components.burnable.onburnt(inst)
    end
end

local function OnFuelSectionChange(new, old, inst)
    if inst._fuellevel ~= new then
        inst._fuellevel = new
        inst.AnimState:OverrideSymbol("swap_meter", "sea_yard_meter", tostring(new))
    end
end

local function OnFuelEmpty(inst)
    inst.components.autofixer:TurnOff()
end

local function OnAddFuel(inst)
    inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/machine_fuel")
end

local function getstatus(inst, viewer)
    if inst.components.fueled and inst.components.fueled.currentfuel <= 0 then
        return "OFF"
    elseif inst.components.fueled and (inst.components.fueled.currentfuel / inst.components.fueled.maxfuel) <= .25 then
        return "LOWFUEL"
    else
        return "ON"
    end
end

local function onplaced(inst)
    inst.components.autofixer.locked = false
    inst:RemoveEventCallback("animover", onplaced)
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle", true)
    inst.SoundEmitter:PlaySound("ia/common/shipyard/craft")  

    inst:ListenForEvent("animover", onplaced) 
end

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetPriority(5)
    inst.MiniMapEntity:SetIcon("sea_yard.tex")
    
    MakeObstaclePhysics(inst, .4)
    
    inst.AnimState:SetBank("sea_yard")
    inst.AnimState:SetBuild("sea_yard")
    inst.AnimState:PlayAnimation("idle", true)

    inst.AnimState:OverrideSymbol("swap_meter", "sea_yard_meter", "10")

    inst:AddTag("structure")
    inst:AddTag("nowaves")

    --autofixer (from autofixer component) added to pristine state for optimization
    inst:AddTag("autofixer")

    MakeSnowCoveredPristine(inst)
    
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst._fuellevel = 10

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus

    inst:AddComponent("autofixer")
    inst.components.autofixer:SetAutoFixUserTestFn(autofixtestfn)
    inst.components.autofixer:SetCanTurnOnFn(canturnon)
    inst.components.autofixer:SetOnTurnOnFn(onturnon)
    inst.components.autofixer:SetOnTurnOffFn(onturnoff)
    inst.components.autofixer:SetStartFixingFn(startfixing)
    inst.components.autofixer:SetStopFixingFn(stopfixing)
    inst.components.autofixer.locked = true

    inst:AddComponent("fueled")
    inst.components.fueled:SetDepletedFn(OnFuelEmpty)
    inst.components.fueled:SetTakeFuelFn(OnAddFuel)
    inst.components.fueled.accepting = true
    inst.components.fueled:SetSections(10)
    inst.components.fueled:SetSectionCallback(OnFuelSectionChange)
    inst.components.fueled:InitializeFuelLevel(TUNING.SEA_YARD_MAX_FUEL_TIME)
    inst.components.fueled.bonusmult = 5
    inst.components.fueled.fueltype = FUELTYPE.TAR

    inst:ListenForEvent("onbuilt", onbuilt)

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    MakeSnowCovered(inst)

    inst.OnSave = OnSave 
    inst.OnLoad = OnLoad
    inst.fixfn = fixfn

    return inst
end

--Using old prefab names
return Prefab("sea_yard", fn, assets, prefabs),
    MakePlacer("sea_yard_placer", "sea_yard", "sea_yard", "placer" )
