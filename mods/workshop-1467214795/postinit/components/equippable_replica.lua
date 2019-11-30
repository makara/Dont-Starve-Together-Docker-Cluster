local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

local EquipSlot = require("equipslotutil")

----------------------------------------------------------------------------------------

local function SetBoatEquipSlot(self, eslot)
    self._boatequipslot:set(EquipSlot.BoatToID(eslot))
end

local function BoatEquipSlot(self)
    return EquipSlot.BoatFromID(self._boatequipslot:value())
end

local _IsEquipped
local function IsEquipped(self, container)
    local isequipped = _IsEquipped(self)
    local isboatequipped = false
    if not self.inst.components.equippable then
        local inventoryitem = self.inst.replica.inventoryitem
        local parent = self.inst.entity:GetParent()
        isboatequipped = inventoryitem ~= nil and inventoryitem:IsHeld() and
            parent and parent:HasTag("boatcontainer") and parent.replica.container:GetItemInBoatSlot(self:BoatEquipSlot()) == self.inst
    end
    return isequipped or isboatequipped
end


----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddClassPostConstruct("components/equippable_replica", function(cmp)


cmp._boatequipslot = EquipSlot.BoatCount() <= 7 and net_tinybyte(cmp.inst.GUID, "equippable._boatequipslot") or net_smallbyte(cmp.inst.GUID, "equippable._boatequipslot")

cmp.SetBoatEquipSlot = SetBoatEquipSlot
cmp.BoatEquipSlot = BoatEquipSlot
_IsEquipped = cmp.IsEquipped
cmp.IsEquipped = IsEquipped


end)