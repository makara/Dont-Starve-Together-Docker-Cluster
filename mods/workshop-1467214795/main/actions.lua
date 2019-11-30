-- Make the actions
local IAENV = env

GLOBAL.setfenv(1, GLOBAL)

local _Actionctor = Action._ctor
Action._ctor = function(self, data, instant, rmb, distance, ghost_valid, ghost_exclusive, canforce, rangecheckfn, ...)
    if data == nil then
        data = {}
	elseif type(data) ~= "table" then
		print("WARNING: Positional Action parameters are deprecated. Please pass action a table instead.")
		data = {priority=data}
	end
    self.crosseswaterboundaries = data.crosseswaterboundaries
    _Actionctor(self, data, instant, rmb, distance, ghost_valid, ghost_exclusive, canforce, rangecheckfn, ...)
end

local REPAIRBOAT = Action({distance = 3})
REPAIRBOAT.id = "REPAIRBOAT"
REPAIRBOAT.str = "Repair"
IAENV.AddAction(REPAIRBOAT)

local READMAP = Action()
READMAP.id = "READMAP"
READMAP.str = "Read"
IAENV.AddAction(READMAP)

local DEPLOY_AT_RANGE = Action({priority = 0, distance = 2.1}) --is DEPLOY, but has a distance of 1 in SW (DEPLOY has a value of 1.1 in DST, and 0 in DS, so we do 2.1) ; used for elephant cactus
DEPLOY_AT_RANGE.id = "DEPLOY_AT_RANGE"
DEPLOY_AT_RANGE.str = ACTIONS.DEPLOY.str
IAENV.AddAction(DEPLOY_AT_RANGE)

local LAUNCH = Action({distance = 3, crosseswaterboundaries = true}) --is DEPLOY, but has a distance of 3, probably can be handled better. used for the surfboard
LAUNCH.id = "LAUNCH"
LAUNCH.str = "Launch"
IAENV.AddAction(LAUNCH)

local RETRIEVE = Action({priority = 1, distance = 3, crosseswaterboundaries = true})
RETRIEVE.id = "RETRIEVE"
RETRIEVE.str = "Retrieve"
IAENV.AddAction(RETRIEVE)

local CUREPOISON = Action()
CUREPOISON.id = "CUREPOISON"
CUREPOISON.str = {
    GENERIC = "Quaff",
    GLAND = "Ingest"
}
IAENV.AddAction(CUREPOISON)

local PEER = Action({priority = 10, instant = false, rmb = true, distance = 40, crosseswaterboundaries = true})
PEER.id = "PEER"
PEER.str = "Peer"
IAENV.AddAction(PEER)

local EMBARK = Action({priority = 1, distance = 6})
EMBARK.id = "EMBARK"
EMBARK.str = {
    GENERIC = "Embark",
    SURF = "Surf"
}
IAENV.AddAction(EMBARK)

local DISEMBARK = Action({priority = 1, distance = 4}) --from 2.5 because of R08_ROT_TURNOFTIDES oceantype
DISEMBARK.id = "DISEMBARK"
DISEMBARK.str = "Disembark"
IAENV.AddAction(DISEMBARK)

local HACK = Action({mindistance = 1.75}) --changed from distance to mindistance to fix whale carcass -M
HACK.id = "HACK"
HACK.str = "Hack"
IAENV.AddAction(HACK)

local TOGGLEON = Action({priority = 2})
TOGGLEON.id = "TOGGLEON"
TOGGLEON.str = "Turn On"
IAENV.AddAction(TOGGLEON)

local TOGGLEOFF = Action({priority = 2})
TOGGLEOFF.id = "TOGGLEOFF"
TOGGLEOFF.str = "Turn Off"
IAENV.AddAction(TOGGLEOFF)

local STICK = Action()
STICK.id = "STICK"
STICK.str = "Plant Stick"
IAENV.AddAction(STICK)

local MATE = Action()
MATE.id = "MATE"
MATE.str = ""
IAENV.AddAction(MATE)

local CRAB_HIDE = Action()
CRAB_HIDE.id = "CRAB_HIDE"
CRAB_HIDE.str = ""
IAENV.AddAction(CRAB_HIDE)

local TIGERSHARK_FEED = Action()
TIGERSHARK_FEED.id = "TIGERSHARK_FEED"
TIGERSHARK_FEED.str = ""
IAENV.AddAction(TIGERSHARK_FEED)

local FLUP_HIDE = Action()
FLUP_HIDE.id = "FLUP_HIDE"
FLUP_HIDE.str = ""
IAENV.AddAction(FLUP_HIDE)

local THROW = Action({priority = 0, instant = false, rmb = true, distance = 20, crosseswaterboundaries = true})
THROW.id = "THROW"
THROW.str = "Throw At"
IAENV.AddAction(THROW)

local LAUNCH_THROWABLE = Action({priority = 0, instant = false, rmb = true, distance = 20, crosseswaterboundaries = true})
LAUNCH_THROWABLE.id = "LAUNCH_THROWABLE"
LAUNCH_THROWABLE.str = "Launch"
IAENV.AddAction(LAUNCH_THROWABLE)

local PACKUP = Action({priority = 2, rmb = true})
PACKUP.id = "PACKUP"
PACKUP.str = "Pick up"
IAENV.AddAction(PACKUP)

REPAIRBOAT.fn = function(act)
    if act.target and act.target ~= act.invobject and act.target.components.repairable and act.invobject and act.invobject.components.repairer then
        return act.target.components.repairable:Repair(act.doer, act.invobject)
    elseif act.doer.components.sailor and act.doer.components.sailor.boat and act.doer.components.sailor.boat.components.repairable and act.invobject and act.invobject.components.repairer then
        return act.doer.components.sailor.boat.components.repairable:Repair(act.doer, act.invobject)
    end
end

READMAP.fn = function(act)
    local targ = act.target or act.invobject
    if targ and targ.components.book and act.doer and act.doer.components.reader then
        return act.doer.components.reader:Read(targ)
    end
end

DEPLOY_AT_RANGE.strfn = ACTIONS.DEPLOY.strfn
DEPLOY_AT_RANGE.fn = ACTIONS.DEPLOY.fn

LAUNCH.fn = ACTIONS.LAUNCH.fn

RETRIEVE.fn = function(act)
    if act.doer.components.inventory and act.target and act.target.components.inventoryitem and not act.target:IsInLimbo() then    
        act.doer:PushEvent("onpickup", {item = act.target})

        --special case for trying to carry two backpacks
        if not act.target.components.inventoryitem.cangoincontainer and act.target.components.equippable and act.doer.components.inventory:GetEquippedItem(act.target.components.equippable.equipslot) then
            local item = act.doer.components.inventory:GetEquippedItem(act.target.components.equippable.equipslot)
            if item.components.inventoryitem and item.components.inventoryitem.cangoincontainer then
                
                --act.doer.components.inventory:SelectActiveItemFromEquipSlot(act.target.components.equippable.equipslot)
                act.doer.components.inventory:GiveItem(act.doer.components.inventory:Unequip(act.target.components.equippable.equipslot))
            else
                act.doer.components.inventory:DropItem(act.doer.components.inventory:GetEquippedItem(act.target.components.equippable.equipslot))
            end
            act.doer.components.inventory:Equip(act.target)
            return true
        end

        if act.doer:HasTag("player") and act.target.components.equippable and act.target.components.equippable.equipslot 
        and not act.doer.components.inventory:GetEquippedItem(act.target.components.equippable.equipslot) then
            act.doer.components.inventory:Equip(act.target)
        else
           act.doer.components.inventory:GiveItem(act.target, nil, Vector3(TheSim:GetScreenPos(act.target.Transform:GetWorldPosition())))
        end
        return true 
    end

    if act.doer.components.inventory and act.target and act.target.components.pickupable and not act.target:IsInLimbo() then    
        act.doer:PushEvent("onpickup", {item = act.target})
        return act.target.components.pickupable:OnPickup(act.doer)
    end
end

CUREPOISON.strfn = function(act)
    if act.invobject and act.invobject:HasTag("venomgland") then
        return "GLAND"
    end
end


CUREPOISON.fn = function(act)
    if act.invobject and act.invobject.components.poisonhealer then
        local target = act.target or act.doer
        return act.invobject.components.poisonhealer:Cure(target)
    end
end

ACTIONS.PEER.fn = function(act)
    --For use telescope
    local telescope = act.invobject or (act.doer and act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS))

    if telescope and telescope.components.telescope and telescope.components.telescope.canuse then
        return telescope.components.telescope:Peer(act.doer, act.GetActionPoint and act:GetActionPoint() or act.pos)
    end
end

EMBARK.strfn = function(act)
    local obj = act.target
    if obj.prefab == "surfboard" then
        return "SURF"
    end
end 

EMBARK.fn = function(act)
    if act.target.components.sailable then
        act.doer.components.sailor:Embark(act.target)
        return true
    end
end

DISEMBARK.fn = function(act)
    if act.doer.components.sailor then
        if act.doer.components.sailor:IsSailing() then 
			local pos = act.GetActionPoint and act:GetActionPoint() or act.pos
            act.doer.components.sailor:Disembark(pos)
            return true
        end
    end
end

local _DoToolWork = UpvalueHacker.GetUpvalue(ACTIONS.CHOP.fn, "DoToolWork")
local function DoToolWork(act, workaction, ...)
    if act.target.components.hackable ~= nil and
    act.target.components.hackable:CanBeHacked() and
    workaction == ACTIONS.HACK then
        if act.invobject and act.invobject.components.obsidiantool then
            act.invobject.components.obsidiantool:Use(act.doer, act.target)
        end
        act.target.components.hackable:Hack(
            act.doer,
            (   act.invobject ~= nil and
                act.invobject.components.tool ~= nil and
                act.invobject.components.tool:GetEffectiveness(workaction)
            ) or
            (   act.doer ~= nil and
                act.doer.components.worker ~= nil and
                act.doer.components.worker:GetEffectiveness(workaction)
            ) or
            1
        )
        return true
    elseif act.target.components.workable ~= nil and
    act.target.components.workable:CanBeWorked() and
    act.target.components.workable:GetWorkAction() == workaction then
        if act.invobject and act.invobject.components.obsidiantool then
            act.invobject.components.obsidiantool:Use(act.doer, act.target)
        end
    end
    return _DoToolWork(act, workaction, ...)
end
UpvalueHacker.SetUpvalue(ACTIONS.CHOP.fn, DoToolWork, "DoToolWork")

HACK.fn = function(act)
    DoToolWork(act, ACTIONS.HACK)
    return true
end

TOGGLEON.fn = function(act)
    local tar = act.target or act.invobject
    if tar and tar.components.equippable and tar.components.equippable:IsEquipped() and tar.components.equippable.togglable and not tar.components.equippable:IsToggledOn() then
        tar.components.equippable:ToggleOn()
        return true
    end
end

TOGGLEOFF.fn = function(act)
    local tar = act.target or act.invobject
    if tar and tar.components.equippable and tar.components.equippable:IsEquipped() and tar.components.equippable.togglable and tar.components.equippable:IsToggledOn() then
        tar.components.equippable:ToggleOff()
        return true
    end
end

STICK.fn = function(act)
    if act.target.components.stickable then
        act.target.components.stickable:PokedBy(act.doer, act.invobject)
        return true
    end
end

MATE.fn = function(act)
    if act.target == act.doer then
        return false
    end

    if act.doer.components.mateable then
        act.doer.components.mateable:Mate()
        return true
    end
end

CRAB_HIDE.fn = function(act)
    --Dummy action for crab.
end

TIGERSHARK_FEED.fn = function(act)
    --Drop some gross food near your kittens
    local doer = act.doer
    if doer and doer.components.lootdropper then
        doer.components.lootdropper:SpawnLootPrefab("mysterymeat")
    end
end

FLUP_HIDE.fn = function(act)
    --Dummy action for flup hiding
end

THROW.fn = function(act)
    local thrown = act.invobject or act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    if act.target and not act.pos then
		act:SetActionPoint(act.target:GetPosition())
    end
    if thrown and thrown.components.throwable then
		local pos = act.GetActionPoint and act:GetActionPoint() or act.pos
        thrown.components.throwable:Throw(pos, act.doer)
        return true
    end
end

LAUNCH_THROWABLE.fn = function(act)
    if act.target and not act.pos then
		act:SetActionPoint(act.target:GetPosition())
    end
	local pos = act.GetActionPoint and act:GetActionPoint() or act.pos
    act.invobject.components.thrower:Throw(pos)
    return true
end

--for pickupable, because we are NOT hijacking PICKUP if it can be avoided -M
PACKUP.fn = function(act)
	if act.doer.components.inventory and act.target and act.target.components.pickupable and not act.target:IsInLimbo() then    
		act.doer:PushEvent("onpickup", {item = act.target})
		return act.target.components.pickupable:OnPickup(act.doer)
	end
end

--distance changes between SW and DST
ACTIONS.RUMMAGE.distance = 2
-- ACTIONS.RUMMAGE.priority = 1

ACTIONS.TOSS.crosseswaterboundaries = true
ACTIONS.CASTSPELL.crosseswaterboundaries = true

local _RUMMAGEstrfn = ACTIONS.RUMMAGE.strfn
function ACTIONS.RUMMAGE.strfn(act, ...)
    local targ = act.target or act.invobject

    return targ ~= nil and
        targ.replica.container and
        targ.replica.container.type == "boat" and
        (targ.replica.container:IsOpenedBy(act.doer) and "CLOSE" or
        "INSPECT") or _RUMMAGEstrfn(act, ...)
end

local _RUMMAGEfn = ACTIONS.RUMMAGE.fn
function ACTIONS.RUMMAGE.fn(act, ...)
    local ret = _RUMMAGEfn(act, ...)
    if ret == nil then
        local targ = act.target or act.invobject

        if targ ~= nil and targ.components.container ~= nil then
            if not targ.components.container.canbeopened and targ.components.container.type == "boat" then
                if CanEntitySeeTarget(act.doer, targ) then
                    act.doer:PushEvent("opencontainer", { container = targ })
                    targ.components.container:Open(act.doer)
                end
                return true
            end
        end
    end
    return ret
end

local _EQUIPfn = ACTIONS.EQUIP.fn
function ACTIONS.EQUIP.fn(act, ...)
    if act.doer.components.inventory and act.invobject.components.equippable.equipslot then
        return _EQUIPfn(act, ...)
    end
    --Boat equip slots
    if act.doer.components.sailor and act.doer.components.sailor.boat and act.invobject.components.equippable.boatequipslot then 
        local boat = act.doer.components.sailor.boat
        if boat.components.container and boat.components.container.hasboatequipslots then
            boat.components.container:Equip(act.invobject)
        end 
    end 
end

local _UNEQUIPfn = ACTIONS.UNEQUIP.fn
function ACTIONS.UNEQUIP.fn(act, ...)
    if act.invobject.components.equippable.boatequipslot and act.invobject.parent then
        local boat = act.invobject.parent
        if boat.components.container then 
            boat.components.container:Unequip(act.invobject.components.equippable.boatequipslot)
            if act.invobject.components.inventoryitem.cangoincontainer and not GetGameModeProperty("non_item_equips") then
                act.doer.components.inventory:GiveItem(act.invobject)
            else
                act.doer.components.inventory:DropItem(act.invobject, true, true)
            end
        elseif boat.components.inventory and act.invobject.components.equippable.equipslot then
            return _UNEQUIPfn(act, ...)
        end
        return true
    else
        return _UNEQUIPfn(act, ...)
    end
end

local _UNWRAPstrfn = ACTIONS.UNWRAP.strfn
function ACTIONS.UNWRAP.strfn(act, ...)
	local tunacan = act.target or act.invobject
    if tunacan ~= nil and tunacan.prefab == "tunacan" then
        return "OPENCAN"
    end
    return _UNWRAPstrfn and _UNWRAPstrfn(act, ...)
end

local _JUMPINstrfn = ACTIONS.JUMPIN.strfn
function ACTIONS.JUMPIN.strfn(act, ...)
    if act.target ~= nil and act.target.prefab == "bermudatriangle" then
        return "BERMUDA"
    end
    return _JUMPINstrfn(act, ...)
end

-- Patch for bermuda triangle wormholes
local _JUMPINfn = ACTIONS.JUMPIN.fn
function ACTIONS.JUMPIN.fn(act, ...)
	if act.doer ~= nil
	and act.doer.sg ~= nil
	and act.doer.sg.currentstate.name == "jumpin_pre"
	and not act.doer:HasTag("playerghost") --just use the default ghost states if ghost
	and act.target ~= nil
	and act.target.prefab == "bermudatriangle"
	and act.target.components.teleporter ~= nil
	and act.target.components.teleporter:IsActive() then
		act.doer.sg:GoToState("jumpinbermuda", { teleporter = act.target })
		return true
	end
	return _JUMPINfn(act, ...)
end

-- Patch for hackable things
local _FERTILIZEfn = ACTIONS.FERTILIZE.fn
function ACTIONS.FERTILIZE.fn(act, ...)
    if _FERTILIZEfn(act, ...) then return true end
    if act.target.components.hackable and act.target.components.hackable:CanBeFertilized()
    and act.invobject and act.invobject.components.fertilizer then
        act.target.components.hackable:Fertilize(act.invobject, act.doer)
        return true     
    end
end

local _HARVESTfn = ACTIONS.HARVEST.fn
function ACTIONS.HARVEST.fn(act, ...)
    if act.target.components.breeder then
        return act.target.components.breeder:Harvest(act.doer)
    else
        return _HARVESTfn(act, ...)
    end
end

local _PLANTfn = ACTIONS.PLANT.fn
function ACTIONS.PLANT.fn(act, ...)
    if act.doer.components.inventory ~= nil and act.invobject ~= nil and act.target.components.breeder ~= nil then
        local seed = act.doer.components.inventory:RemoveItem(act.invobject)
        if seed then
            if act.target.components.breeder:Seed(seed) then
                return true
            else
                --UGH, this is gross.
                act.doer.components.inventory:GiveItem(seed)
            end
        end
    end
    return _PLANTfn(act, ...)
end

local _FISHfn = ACTIONS.FISH.fn
function ACTIONS.FISH.fn(act, ...)
    if act.doer and act.doer.components.fishingrod then
        --mermfisher
		act.doer.components.fishingrod:StartFishing(act.target, act.doer)
		return true
    end
    return _FISHfn(act, ...)
end

--warly
local _COOKfn = ACTIONS.COOK.fn
function ACTIONS.COOK.fn(act, ...)
	if IA_CONFIG.oldwarly and act.doer ~= nil and act.doer:HasTag("masterchef") and act.target.components.stewer ~= nil then
        if act.target.components.stewer:IsCooking() then
            --Already cooking
            return _COOKfn(act, ...)
        end
		act.target.components.stewer.gourmetcook = true
		local cooking = require("cooking")
		cooking.enableWarly = true
		local ret = {_COOKfn(act, ...)}
		cooking.enableWarly = false
        if not act.target.components.stewer:IsCooking() then
			act.target.components.stewer.gourmetcook = false
        end
		return unpack(ret)
	end
    return _COOKfn(act, ...)
end

local _STOREstrfn = ACTIONS.STORE.strfn
function ACTIONS.STORE.strfn(act, ...)
	return _STOREstrfn(act, ...) or (act.target ~= nil and act.target.prefab == "portablecookpot" and "COOK")
end

local _HAMMERextra_arrive_dist = ACTIONS.HAMMER.extra_arrive_dist
function ACTIONS.HAMMER.extra_arrive_dist(inst, dest, bufferedaction)
	local distance = _HAMMERextra_arrive_dist and _HAMMERextra_arrive_dist(inst, dest, bufferedaction) or 0
	if inst ~= nil and dest ~= nil then
		-- local px, py, pz = inst:GetPosition()
		local dx, dy, dz = dest:GetPoint()
		if IsOnWater(inst) ~= IsOnWater({x=dx,y=dy,z=dz}) then
			distance = distance + 1
		end
	end
	return distance
end

---------------------------------------------------------------------
------------------------COMPONENT ACTIONS----------------------------
---------------------------------------------------------------------

IAENV.AddComponentAction("SCENE", "breeder", function(inst, doer, actions, right)
    if inst:HasTag("breederharvest") and doer.replica.inventory then
        table.insert(actions, ACTIONS.HARVEST)
    end
end)

IAENV.AddComponentAction("SCENE", "sailable", function(inst, doer, actions, right)
    if inst:HasTag("sailable") and not (doer.replica.rider and doer.replica.rider:IsRiding()) then
        if not right then
            table.insert(actions, ACTIONS.EMBARK)
        end
    end
end)

IAENV.AddComponentAction("USEITEM", "poisonhealer", function(inst, doer, target, actions, right)
    if inst:HasTag("poison_antidote") and target and target:HasTag("poisonable") then
        if target:HasTag("poison") or 
        (target:HasTag("player") and 
        ((target.components.poisonable and target.components.poisonable:IsPoisoned()) or
        (target.player_classified and target.player_classified.ispoisoned:value()) or
        inst:HasTag("poison_vaccine"))) then
            table.insert(actions, ACTIONS.CUREPOISON)
        end
    end
end)

IAENV.AddComponentAction("USEITEM", "seedable", function(inst, doer, target, actions, right)
    if target:HasTag("breeder") and target:HasTag("canbeseeded") then
        table.insert(actions, ACTIONS.PLANT)
    end
end)

IAENV.AddComponentAction("USEITEM", "sticker", function(inst, doer, target, actions, right)
    if target:HasTag("canbesticked") then
        table.insert(actions, ACTIONS.STICK)
    end
end)

IAENV.AddComponentAction("POINT", "throwable", function(inst, doer, pos, actions, right)
    if right and not TheWorld.Map:IsGroundTargetBlocked(pos) and not (inst.replica.equippable and not inst.replica.equippable:IsEquipped()) then
        table.insert(actions, ACTIONS.THROW)
    end
end)

IAENV.AddComponentAction("POINT", "thrower", function(inst, doer, pos, actions, right)
    if right and not TheWorld.Map:IsGroundTargetBlocked(pos) and not (inst.replica.equippable and not inst.replica.equippable:IsEquipped()) then
        table.insert(actions, ACTIONS.LAUNCH_THROWABLE)
    end
end)

IAENV.AddComponentAction("POINT", "telescope", function(inst, doer, pos, actions, right)
    if right and inst:HasTag("telescope") then
        table.insert(actions, ACTIONS.PEER)
    end
end)

IAENV.AddComponentAction("INVENTORY", "repairer", function(inst, doer, actions, right)
    if doer and doer.replica.sailor and doer.replica.sailor:GetBoat() then
        local boat = doer.replica.sailor:GetBoat()
        for k, v in pairs(MATERIALS) do
            if boat:HasTag("repairable_"..v) then
                if inst:HasTag("health_"..v) and boat.replica.boathealth ~= nil then
                    table.insert(actions, ACTIONS.REPAIRBOAT)
                end
                return
            end
        end
    end
end)

IAENV.AddComponentAction("EQUIPPED", "throwable", function(inst, doer, target, actions, right)
    if right and
        not (doer.components.playercontroller ~= nil and
            doer.components.playercontroller.isclientcontrollerattached) and
        not TheWorld.Map:IsGroundTargetBlocked(target:GetPosition()) and
        not (inst.replica.equippable and not inst.replica.equippable:IsEquipped()) and
        target ~= doer then
        table.insert(actions, ACTIONS.THROW)
    end
end)

IAENV.AddComponentAction("EQUIPPED", "thrower", function(inst, doer, target, actions, right)
    if right and
        not (doer.components.playercontroller ~= nil and
            doer.components.playercontroller.isclientcontrollerattached) and
        not TheWorld.Map:IsGroundTargetBlocked(target:GetPosition()) and
        not (inst.replica.equippable and not inst.replica.equippable:IsEquipped()) and
        target ~= doer then
        table.insert(actions, ACTIONS.LAUNCH_THROWABLE)
    end
end)

IAENV.AddComponentAction("INVENTORY", "poisonhealer", function(inst, doer, actions, right)
    if inst:HasTag("poison_antidote") and doer:HasTag("poisonable") and 
    (doer:HasTag("player") and 
    ((doer.components.poisonable and doer.components.poisonable:IsPoisoned()) or
    (doer.player_classified and doer.player_classified.ispoisoned:value()) or
    inst:HasTag("poison_vaccine"))) then
        table.insert(actions, ACTIONS.CUREPOISON)
    end
end)

IAENV.AddComponentAction("ISVALID", "hackable", function(inst, action, right)
    return action == ACTIONS.HACK and inst:HasTag("hack_workable")
end)

IAENV.AddComponentAction("SCENE", "pickupable", function(inst, doer, actions, right)
    if right and inst:HasTag("canbepickedup") and not inst:HasTag("fire")
	and doer.replica.inventory ~= nil and (doer.replica.rider == nil or not doer.replica.rider:IsRiding()) then
		if inst:HasTag("floating") or inst:HasTag("aquatic") then
			table.insert(actions, ACTIONS.RETRIEVE)
		else
			table.insert(actions, ACTIONS.PACKUP)
		end
	end
end)

local COMPONENT_ACTIONS = UpvalueHacker.GetUpvalue(EntityScript.CollectActions, "COMPONENT_ACTIONS")
local SCENE = COMPONENT_ACTIONS.SCENE
local USEITEM = COMPONENT_ACTIONS.USEITEM
local POINT = COMPONENT_ACTIONS.POINT
local EQUIPPED = COMPONENT_ACTIONS.EQUIPPED
local INVENTORY = COMPONENT_ACTIONS.INVENTORY
local ISVALID = COMPONENT_ACTIONS.ISVALID

local _USEITEMfertilizer = USEITEM.fertilizer
function USEITEM.fertilizer(inst, doer, target, actions, ...)
    if not inst:HasTag("fertilizer_volcanic") and not inst:HasTag("fertilizer_oceanic") and not target:HasTag("witherable_volcanic") and not target:HasTag("witherable_oceanic") then
        _USEITEMfertilizer(inst, doer, target, actions, ...)
    elseif inst:HasTag("fertilizer_volcanic") then
        if target:HasTag("witherable_volcanic") and target:HasTag("barren") then
            table.insert(actions, ACTIONS.FERTILIZE)
        end
    elseif inst:HasTag("fertilizer_oceanic") then
        if target:HasTag("witherable_oceanic") and target:HasTag("barren") then
            table.insert(actions, ACTIONS.FERTILIZE)
        end
    end
end
local _USEITEMrepairer = USEITEM.repairer
function USEITEM.repairer(inst, doer, target, actions, right, ...)
    if right then
        _USEITEMrepairer(inst, doer, target, actions, right, ...)
    else
        for k, v in pairs(MATERIALS) do
            if target:HasTag("repairable_"..v) then
                if inst:HasTag("health_"..v) and target.replica.boathealth ~= nil then
                    table.insert(actions, ACTIONS.REPAIRBOAT)
                end
                return
            end
        end
    end
end

local _POINTdeployable = POINT.deployable
function POINT.deployable(inst, doer, pos, actions, right, ...)
    if right and inst.replica.inventoryitem ~= nil and inst.replica.inventoryitem:CanDeploy(pos, nil, doer) then
        if inst:HasTag("boat") then
            table.insert(actions, ACTIONS.LAUNCH)
        else
            if inst.replica.inventoryitem:DeployAtRange() then
                table.insert(actions, ACTIONS.DEPLOY_AT_RANGE)
            else
                _POINTdeployable(inst, doer, pos, actions, right, ...)
            end
        end
    end
end

local _SCENEinventoryitem = SCENE.inventoryitem
function SCENE.inventoryitem(inst, doer, actions, right, ...)
    if (inst:HasTag("floating") or inst.components.floater and inst.components.floater:IsFloating()) and not doer:CanOnWater() then
        if inst.replica.inventoryitem:CanBePickedUp() and doer.replica.inventory ~= nil and
        (doer.replica.inventory:GetNumSlots() > 0 or inst.replica.equippable ~= nil) and
        not (inst:HasTag("catchable") or inst:HasTag("fire") or inst:HasTag("smolder")) and
        (right or not inst:HasTag("heavy")) and
        not (right and inst.replica.container ~= nil and inst.replica.equippable == nil) then
            table.insert(actions, ACTIONS.RETRIEVE)
        end
    else
       _SCENEinventoryitem(inst, doer, actions, right, ...)
    end
end

local _INVENTORYequippable = INVENTORY.equippable
function INVENTORY.equippable(inst, doer, actions, ...)
    local canEquip = true 
    local container = nil
    if inst.replica.equippable:BoatEquipSlot() ~= "INVALID" and inst.replica.equippable:EquipSlot() == "INVALID" then --Can only be equipped on a boat 
        canEquip = false
        
        local sailor = doer.replica.sailor
        local boat = sailor and sailor:GetBoat()
        if boat and boat.replica.container.hasboatequipslots and boat.replica.container.enableboatequipslots then 
            canEquip = true 
        end 
    end 
    
    if not inst.replica.equippable:IsEquipped() and canEquip then
        _INVENTORYequippable(inst, doer, actions, ...)
    elseif inst.replica.equippable:IsEquipped() then
        if inst:HasTag("togglable") then 
            if inst:HasTag("toggled") then 
                table.insert(actions, ACTIONS.TOGGLEOFF)
            else 
                table.insert(actions, ACTIONS.TOGGLEON)
            end 
        else
            _INVENTORYequippable(inst, doer, actions, ...)
        end        
    end
end

local _SCENEcontainer = SCENE.container
function SCENE.container(inst, doer, actions, right, ...)
    if not inst:HasTag("bundle") and not inst:HasTag("burnt") and 
    doer.replica.inventory ~= nil and
    not (doer.replica.rider ~= nil and
    doer.replica.rider:IsRiding()) and
    right and inst.replica.container.type == "boat" then
        table.insert(actions, ACTIONS.RUMMAGE)
    else
        _SCENEcontainer(inst, doer, actions, right, ...)
    end
end

local _SCENErideable = SCENE.rideable
function SCENE.rideable(inst, doer, actions, right, ...)
    if not (doer and doer:HasTag("_sailor") and doer:HasTag("sailing")) then
        return _SCENErideable(inst, doer, actions, right, ...)
    end
end

local _USEITEMfuel = USEITEM.fuel
function USEITEM.fuel(inst, doer, target, actions, right, ...)
    local _actioncount = #actions
    _USEITEMfuel(inst, doer, target, actions, right, ...)
    if #actions == _actioncount then --if _USEITEMfuel didn't add an action, we process the "secondaryfuel"
        if not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding())
            or (target.replica.inventoryitem ~= nil and target.replica.inventoryitem:IsGrandOwner(doer)) then
            if inst.prefab ~= "spoiled_food" and
                inst:HasTag("quagmire_stewable") and
                target:HasTag("quagmire_stewer") and
                target.replica.container ~= nil and
                target.replica.container:IsOpenedBy(doer) then
                return
            end
            for k, v in pairs(FUELTYPE) do
                if inst:HasTag(v.."_secondaryfuel") then
                    if target:HasTag(v.."_fueled") then
                        table.insert(actions, inst:GetIsWet() and ACTIONS.ADDWETFUEL or ACTIONS.ADDFUEL)
                    end
                end
            end
        end
    end
end