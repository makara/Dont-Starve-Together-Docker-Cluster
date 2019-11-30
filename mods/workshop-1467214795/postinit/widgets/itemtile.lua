local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

local UIAnim = require("widgets/uianim")
local Image = require("widgets/image")
local Text = require("widgets/text")

----------------------------------------------------------------------------------------


--separate so we can refresh our stuff once on init
local function Refresh_IA(self, ...)
    if self.ismastersim then
        if self.item.components.obsidiantool ~= nil then
            local charge, maxcharge = self.item.components.obsidiantool:GetCharge()
            self.obsidian_charge:GetAnimState():SetPercent("anim", charge / maxcharge)
        end

        if self.item.components.inventory and self.invspace then
            self.invspace:GetAnimState():SetPercent("anim", self.item.components.inventory:NumItems() / self.item.components.inventory.maxslots)
        end
    elseif self.item.replica.inventoryitem ~= nil then
        self.item.replica.inventoryitem:DeserializeUsage()
    end

	if self.item and self.item.fusevalue then
		-- self.fusebg:Show()
		self.fuse:SetString(tostring(math.ceil(self.item.fusevalue)))
	end
end

local _Refresh
local function Refresh(self, ...)
    _Refresh(self, ...)
	Refresh_IA(self, ...)
end


local _StartDrag
local function StartDrag(self, ...)
    _StartDrag(self, ...)
    if self.item.replica.inventoryitem ~= nil then -- HACK HACK: items without an inventory component won't have any of these
        if self.obsidian_charge ~= nil then
            self.obsidian_charge:Hide()
        end
        if self.invspace ~= nil then
            self.invspace:Hide()
        end
        if self.fusebg ~= nil then
            self.fusebg:Hide()
        end
    end
end


----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddClassPostConstruct("widgets/itemtile", function(widget)


if widget.item:HasTag("show_invspace") then
    widget.invspace = widget:AddChild(UIAnim())
    widget.invspace:GetAnimState():SetBank("trawlnet_meter")
    widget.invspace:GetAnimState():SetBuild("trawlnet_meter")
    widget.invspace:SetClickable(false)
end

if widget.item:HasTag("obsidiantool") then
    widget.obsidian_charge = widget:AddChild(UIAnim())
    widget.obsidian_charge:GetAnimState():SetBank("obsidian_tool_meter")
    widget.obsidian_charge:GetAnimState():SetBuild("obsidian_tool_meter")
    widget.obsidian_charge:SetClickable(false)
end

if widget.item:HasTag("fuse") then
	--Doesn't work for some reason. -M
    -- widget.fusebg = widget:AddChild(Image(HUD_ATLAS, "resource_needed.tex"))
    -- widget.fusebg:SetClickable(false)
    -- widget.fusebg:Hide()

	widget.fuse = widget:AddChild(Text(NUMBERFONT, 50))
	if JapaneseOnPS4 and JapaneseOnPS4() then
		widget.fuse:SetHorizontalSqueeze(0.7)
	end
	widget.fuse:SetPosition(5,0,0)
end

if widget.item:HasTag("gourmetfood") then
    widget.gourmetstar = widget:AddChild(Image("images/ia_hud.xml", "gourmetstar.tex"))
    widget.gourmetstar:SetPosition(20,-20,0) --right bottom corner
    widget.gourmetstar:SetClickable(false)
end

--I HATE THIS, but idk how else to ensure proper ordering of these, without nasty hacks. -Z
if widget.fusebg then widget.fusebg:MoveToBack() end
if widget.obsidian_charge then widget.obsidian_charge:MoveToBack() end
if widget.invspace then widget.invspace:MoveToBack() end
if widget.spoilage then widget.spoilage:MoveToBack() end
if widget.bg then widget.bg:MoveToBack() end

if widget.invspace then
    widget.inst:ListenForEvent("invspacechange", function(invitem, data)
		widget.invspace:GetAnimState():SetPercent("anim", data.percent)
	end, widget.item)
end
if widget.obsidian_charge then
    widget.inst:ListenForEvent("obsidianchargechange", function(invitem, data)
		widget.obsidian_charge:GetAnimState():SetPercent("anim", data.percent)
	end, widget.item)
end
if widget.fuse then
    widget.inst:ListenForEvent("fusechanged", function(invitem, data)
		-- widget.fusebg:Show()
		if invitem and invitem.fusevalue then
			widget.fuse:SetString(tostring(math.ceil(invitem.fusevalue)))
		end
	end, widget.item)
end

Refresh_IA(widget)

_Refresh = widget.Refresh
widget.Refresh = Refresh
_StartDrag = widget.StartDrag
widget.StartDrag = StartDrag


end)
