local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local function SerializeObsidianCharge(inst, percent)
    inst.obsidian_charge:set((percent or 0) * 63)
end

local function DeserializeObsidianCharge(inst)
    if inst._parent ~= nil then
        inst._parent:PushEvent("obsidianchargechange", {percent = inst.obsidian_charge:value() / 63})
    end
end

local function SerializeInvSpace(inst, percent)
    inst.invspace:set((percent or 0) * 63)
end

local function DeserializeInvSpace(inst)
    if inst._parent ~= nil then
        inst._parent:PushEvent("invspacechange", {percent = inst.invspace:value() / 63})
    end
end

local function RegisterNetListeners(inst)
    inst:ListenForEvent("obsidianchargedirty", DeserializeObsidianCharge)
    inst:ListenForEvent("invspacedirty", DeserializeInvSpace)
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddPrefabPostInit("inventoryitem_classified", function(inst)



inst.deployatrange = net_bool(inst.GUID, "deployable.deployatrange")
inst.candeployonland = net_bool(inst.GUID, "deployable.candeployonland")
inst.candeployonshallowocean = net_bool(inst.GUID, "deployable.candeployonshallowocean")
inst.candeployonbuildableocean = net_bool(inst.GUID, "deployable.candeployonbuildableocean")
inst.candeployonunbuildableocean = net_bool(inst.GUID, "deployable.candeployonunbuildableocean")
inst.obsidian_charge = net_smallbyte(inst.GUID, "obsidiantool.obsidian_charge", "obsidianchargedirty")
inst.invspace = net_smallbyte(inst.GUID, "inventory.invspace", "invspacedirty")

inst.deployatrange:set(false)
inst.candeployonland:set(true)
inst.candeployonshallowocean:set(false)
inst.candeployonbuildableocean:set(false)
inst.candeployonunbuildableocean:set(false)
inst.obsidian_charge:set(0)
inst.invspace:set(0)

if not TheWorld.ismastersim then

    inst.DeserializeObsidianCharge = DeserializeObsidianCharge
    inst.DeserializeInvSpace = DeserializeInvSpace

    --Delay net listeners until after initial values are deserialized
    inst:DoTaskInTime(0, RegisterNetListeners)
    return
	
end

inst.SerializeObsidianCharge = SerializeObsidianCharge
inst.SerializeInvSpace = SerializeInvSpace


end)
