local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local _GetEquippedItem
local function GetEquippedItem(self, eslot)
    if eslot == nil then
        return false
    else
        return _GetEquippedItem(self, eslot)
    end
end

local _Equip
local function Equip(self, item, ...)
	if item == nil or item.components.equippable == nil or item.components.equippable.equipslot == nil then
        return false
    else
        return _Equip(self, item, ...)
    end
end

local function GetWindproofness(self, slot)
    local windproofness = 0
    if slot then
        local item = self:GetItemSlot(slot)
        if item and item.components.windproofer then
            windproofness = windproofness + item.components.windproofer.GetEffectiveness()
        end
    else
        for k,v in pairs(self.equipslots) do
            if v and v.components.windproofer then
                windproofness = windproofness + v.components.windproofer:GetEffectiveness()  
            end
        end
    end
    return windproofness
end

local function DropItemBySlot(self, slot)
    local item = self:RemoveItemBySlot(slot)
    if item ~= nil then
        item.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
        if item.components.inventoryitem ~= nil then
            item.components.inventoryitem:OnDropped(true)
        end
        item.prevcontainer = nil
        item.prevslot = nil
        self.inst:PushEvent("dropitem", { item = item })
    end
end

local function IsWindproof(self)
    return self:GetWindproofness() >= 1
end

local function InvSpaceChanged(inst)
    inst:PushEvent("invspacechange", {percent = inst.components.inventory:NumItems() / inst.components.inventory.maxslots})
end


----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("inventory", function(cmp)


_GetEquippedItem = cmp.GetEquippedItem
cmp.GetEquippedItem = GetEquippedItem
_Equip = cmp.Equip
cmp.Equip = Equip

cmp.GetWindproofness = GetWindproofness
cmp.DropItemBySlot = DropItemBySlot
cmp.IsWindproof = IsWindproof

cmp.inst:ListenForEvent("itemget", InvSpaceChanged)
cmp.inst:ListenForEvent("itemlose", InvSpaceChanged)
cmp.inst:ListenForEvent("dropitem", InvSpaceChanged)


end)
