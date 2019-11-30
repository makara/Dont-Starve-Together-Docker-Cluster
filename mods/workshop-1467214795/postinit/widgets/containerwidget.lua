local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

local BoatEquipSlot = require "widgets/boatequipslot"
local BoatBadge = require "widgets/boatbadge"
local ItemTile = require "widgets/itemtile"
local InvSlot = require "widgets/invslot"
local Widget = require "widgets/widget"
local Text = require "widgets/text"
local UIAnim = require "widgets/uianim"
local ImageButton = require "widgets/imagebutton"

----------------------------------------------------------------------------------------

local DOUBLECLICKTIME = .33
local HUD_ATLAS = "images/ia_hud.xml"

local _Open
local function Open(self, container, doer, boatwidget)
    local _GetWidget = container.replica.container.GetWidget
    function container.replica.container:GetWidget()
        return _GetWidget(self, boatwidget)
    end
    _Open(self, container, doer)
    local widget = container.replica.container:GetWidget()
    container.replica.container.GetWidget = _GetWidget

    self.onitemequipfn = function(inst, data) self:OnItemEquip(data.item, data.eslot) end
    self.inst:ListenForEvent("equip", self.onitemequipfn, container)
  
    self.onitemunequipfn = function(inst, data) self:OnItemUnequip(data.item, data.eslot) end
    self.inst:ListenForEvent("unequip", self.onitemunequipfn, container)

    if container.replica.container.type == "boat" then
        self.boatbadge:SetPosition(widget.badgepos.x, widget.badgepos.y)
        self.boatbadge:Show()
        if container and container.replica.boathealth then
            self.inst:ListenForEvent("boathealthchange", function(boat, data) self:BoatDelta(boat, data) end, container)
            self.boatbadge:SetPercent(container.replica.boathealth:GetPercent(), container.replica.boathealth:GetMaxHealth())
        end

        if container.replica.container.hasboatequipslots then
            self:AddBoatEquipSlot(BOATEQUIPSLOTS.BOAT_SAIL, HUD_ATLAS, "equip_slot_boat_utility.tex")
            self:AddBoatEquipSlot(BOATEQUIPSLOTS.BOAT_LAMP, HUD_ATLAS, "equip_slot_boat_light.tex")
            local lastX = widget.equipslotroot.x
            local lastY = widget.equipslotroot.y
            local spacing = 80
            local eslot_order = {}
            for k, v in ipairs(self.boatEquipInfo) do
                local slot = BoatEquipSlot(v.slot, v.atlas, v.image, self.owner)
                self.boatEquip[v.slot] = self:AddChild(slot)
                slot:SetPosition(lastX, lastY, 0)
                lastX = lastX - spacing
                local obj = container.replica.container:GetItemInBoatSlot(v.slot)
                if obj then
                    local tile = ItemTile(obj)
                    slot:SetTile(tile)
                end
                if not container.replica.container._enableboatequipslots:value() then
                    slot:Hide()
                end
            end    
        end
        self.boatbadge:MoveToFront()

        self:Refresh()
    end 
end

local function AddBoatEquipSlot(self, slot, atlas, image, sortkey)
    sortkey = sortkey or #self.boatEquipInfo
    table.insert(self.boatEquipInfo, {slot = slot, atlas = atlas, image = image, sortkey = sortkey})
    table.sort(self.boatEquipInfo, function(a,b) return a.sortkey < b.sortkey end)
end

local function BoatDelta(self, boat, data)
    if data.damage then
        self:Shake(0.25, 0.05, 5)
    end
    
    self.boatbadge:SetPercent(data.percent, data.maxhealth)

    if data.percent <= .25 then
        self.boatbadge:StartWarning()
    else
        self.boatbadge:StopWarning()
    end

    if self.prev_boat_pct and data.percent > self.prev_boat_pct then
        self.boatbadge:PulseGreen()
        --TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/health_up")
    elseif self.prev_boat_pct and data.damage and data.percent < self.prev_boat_pct then
        self.boatbadge:PulseRed()
        --TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/health_down")
    end
    self.prev_boat_pct = data.percent
end

local function OnItemEquip(self, item, slot)
    if slot ~= nil and self.boatEquip[slot] ~= nil then
        self.boatEquip[slot]:SetTile(ItemTile(item))
    end
end 

local function OnItemUnequip(self, item, slot)
    if slot ~= nil and self.boatEquip[slot] ~= nil then
        self.boatEquip[slot]:SetTile(nil)
    end
end 


local _Refresh
local function Refresh(self)
    _Refresh(self)
    local boatequips = self.container.replica.container.GetBoatEquips and self.container.replica.container:GetBoatEquips() or {}
    for k, v in pairs(self.boatEquip) do
        local item = boatequips[k]
        if item == nil then
            if v.tile ~= nil then
                v:SetTile(nil)
            end
        elseif v.tile == nil or v.tile.item ~= item then
            v:SetTile(ItemTile(item))
        else
            v.tile:Refresh()
        end
    end
end

local _Close
local function Close(self)
    if self.isopen then
        if self.container ~= nil then
            if self.onitemequipfn then
                self.inst:RemoveEventCallback("equip", self.onitemequipfn, self.container)
                self.onitemequipfn = nil
            end
            if self.onitemunequipfn then
                self.inst:RemoveEventCallback("unequip", self.onitemunequipfn, self.container)
                self.onitemunequipfn = nil
            end
        end
        _Close(self)
        self.boatbadge:Hide()
        for i,v in pairs(self.boatEquip) do
            v:Kill()
        end
    end
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddClassPostConstruct("widgets/containerwidget", function(widget)


widget.boatEquipInfo = {}
widget.boatEquip = {}

widget.boatbadge = widget:AddChild(BoatBadge(widget.owner))
widget.boatbadge:Hide()

widget.AddBoatEquipSlot = AddBoatEquipSlot
widget.BoatDelta = BoatDelta
widget.OnItemEquip = OnItemEquip
widget.OnItemUnequip = OnItemUnequip

_Open = widget.Open
widget.Open = Open
_Close = widget.Close
widget.Close = Close
_Refresh = widget.Refresh
widget.Refresh = Refresh


end)

