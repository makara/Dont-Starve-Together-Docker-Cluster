
local widget_treasurechest =
{
    widget =
    {
        slotpos = {},
        animbank = "ui_chest_3x3",
        animbuild = "ui_chest_3x3",
        pos = GLOBAL.Vector3(0, 200, 0),
        side_align_tip = 160,
    },
    type = "chest",
}
for y = 2, 0, -1 do
    for x = 0, 2 do
        table.insert(widget_treasurechest.widget.slotpos, GLOBAL.Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 80, 0))
    end
end

local widget_octopuschest = {
    widget =
    {
        slotpos = {},
        animbank = "ui_thatchpack_1x4",
        animbuild = "ui_thatchpack_1x4",
        pos = GLOBAL.Vector3(75,200,0),
        side_align_tip = 160,
    },
    type = "chest",
}
for y = 0, 3 do
  table.insert(widget_octopuschest.widget.slotpos, GLOBAL.Vector3(-162 +(75/2), -y*75 + 114 ,0))
end

-- I love the Gem Core API
AddContainerWidget("trawlnetdropped", widget_treasurechest)
AddContainerWidget("luggagechest", widget_treasurechest)
AddContainerWidget("waterchest", widget_treasurechest)
AddContainerWidget("krakenchest", widget_treasurechest)
AddContainerWidget("octopuschest", widget_octopuschest)

local widget_fat_packim =
{
    widget =
    {
        slotpos = {},
        animbank = "ui_chester_shadow_3x4",
        animbuild = "ui_chester_shadow_3x4",
        pos = GLOBAL.Vector3(0, 220, 0),
        side_align_tip = 160,
    },
    type = "chest",
}

for y = 2.5, -0.5, -1 do
    for x = 0, 2 do
        table.insert(widget_fat_packim.widget.slotpos, GLOBAL.Vector3(75 * x - 75 * 2 + 75, 75 * y - 75 * 2 + 75, 0))
    end
end

AddContainerWidget("packim", widget_treasurechest)
AddContainerWidget("fat_packim", widget_fat_packim)

local widget_thatchpack = {
    widget = {
        slotpos = {},
        animbank = "ui_thatchpack_1x4",
        animbuild = "ui_thatchpack_1x4",
        pos = GLOBAL.Vector3(-5,-70,0),
    },
    issidewidget = true,
    type = "pack",
}

for y = 0, 3 do
    table.insert(widget_thatchpack.widget.slotpos, GLOBAL.Vector3(-162 + (75 / 2), -75 * y + 114 ,0))
end

local widget_seasack = {
    widget = {
        slotpos = {},
        animbank = "ui_icepack_2x3",
        animbuild = "ui_icepack_2x3",
        pos = GLOBAL.Vector3(-5,-70,0),
    },
    issidewidget = true,
    type = "pack",
}

for y = 0, 2 do
    table.insert(widget_seasack.widget.slotpos, GLOBAL.Vector3(-162, -75 * y + 75, 0))
    table.insert(widget_seasack.widget.slotpos, GLOBAL.Vector3(-162 + 75, -75 * y + 75, 0))
end

local widget_piratepack = {
    widget = {
        slotpos = {},
        animbank = "ui_backpack_2x4",
        animbuild = "ui_backpack_2x4",
        pos = GLOBAL.Vector3(-5,-70,0),
    },
    issidewidget = true,
    type = "pack",
}

for y = 0, 3 do
    table.insert(widget_piratepack.widget.slotpos, GLOBAL.Vector3(-162, -75 * y + 114, 0))
    table.insert(widget_piratepack.widget.slotpos, GLOBAL.Vector3(-162 + 75, -75 * y + 114, 0))
end

local widget_chefpack = {
    widget = {
        slotpos = {},
        animbank = "ui_backpack_2x4",
        animbuild = "ui_backpack_2x4",
        pos = GLOBAL.Vector3(-5,-70,0),
    },
    issidewidget = true,
    type = "pack",
	itemtestfn = function(container, item, slot)
		for k, v in pairs(GLOBAL.FOODGROUP.OMNI.types) do
			if item:HasTag("edible_"..v) then
				return true
			end
		end
		return item:HasTag("edible_RAW") --raw birchnuts and such
	end
}

for y = 0, 3 do
    table.insert(widget_chefpack.widget.slotpos, GLOBAL.Vector3(-162, -75 * y + 114, 0))
    table.insert(widget_chefpack.widget.slotpos, GLOBAL.Vector3(-162 + 75, -75 * y + 114, 0))
end

AddContainerWidget("thatchpack", widget_thatchpack)
AddContainerWidget("seasack", widget_seasack)
AddContainerWidget("piratepack", widget_piratepack)
AddContainerWidget("chefpack", widget_chefpack)

--[[
local cooking = GLOBAL.require("cooking")

local widget_portablecookpot =
{
	widget =
	{
		slotpos =
		{
			GLOBAL.Vector3(0, 64 + 32 + 8 + 4, 0), 
			GLOBAL.Vector3(0, 32 + 4, 0),
			GLOBAL.Vector3(0, -(32 + 4), 0), 
			GLOBAL. Vector3(0, -(64 + 32 + 8 + 4), 0),
		},
		animbank = "ui_cookpot_1x4",
		animbuild = "ui_cookpot_1x4",
		pos = GLOBAL.Vector3(200, 0, 0),
		side_align_tip = 100,
		buttoninfo =
		{
			text = GLOBAL.STRINGS.ACTIONS.COOK,
			position = GLOBAL.Vector3(0, -165, 0),
			fn = function(inst)
				if inst.components.container ~= nil then
					GLOBAL.BufferedAction(inst.components.container.opener, inst, GLOBAL.ACTIONS.COOK):Do()
				elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
					GLOBAL.SendRPCToServer(GLOBAL.RPC.DoWidgetButtonAction, GLOBAL.ACTIONS.COOK.code, inst, GLOBAL.ACTIONS.COOK.mod_name)
				end
			end,
			validfn = function(inst)
				return inst.replica.container ~= nil and inst.replica.container:IsFull()
			end,
		},
	},
	acceptsstacks = false,
	type = "cooker",
	itemtestfn = function(container, item, slot)
		return cooking.IsCookingIngredient(item.prefab) and not container.inst:HasTag("burnt")
	end,
}

AddContainerWidget("portablecookpot", widget_portablecookpot)
]]


local boat_raft = {
    widget = {
        slotpos = {},
        animbank = "boat_hud_raft",
        animbuild = "boat_hud_raft",
        pos = GLOBAL.Vector3(750, 75, 0),
        badgepos = GLOBAL.Vector3(0, 40, 0),
        equipslotroot = GLOBAL.Vector3(-80, 40, 0),
    },
    inspectwidget = {
        slotpos = {},
        animbank = "boat_inspect_raft",
        animbuild = "boat_inspect_raft",
        pos = GLOBAL.Vector3(200, 0, 0),
        badgepos = GLOBAL.Vector3(0, 5, 0),
        equipslotroot = {},
    },
    type = "boat",
    side_align_tip = -500,
    canbeopened = false,
    hasboatequipslots = false,
    enableboatequipslots = true,
}

local boat_lograft = {
    widget = {
        slotpos = {},
        animbank = "boat_hud_raft",
        animbuild = "boat_hud_raft",
        pos = GLOBAL.Vector3(750, 75, 0),
        badgepos = GLOBAL.Vector3(0, 40, 0),
        equipslotroot = GLOBAL.Vector3(-80, 40, 0),
        --side_align_tip = -500,
    },
    inspectwidget = {
        slotpos = {},
        animbank = "boat_inspect_raft",
        animbuild = "boat_inspect_raft",
        pos = GLOBAL.Vector3(200, 0, 0),
        badgepos = GLOBAL.Vector3(0, 5, 0),
        equipslotroot = {},
    },
    type = "boat",
    side_align_tip = -500,
    canbeopened = false,
    hasboatequipslots = false,
    enableboatequipslots = true,
}

local boat_row = {
    widget = {
        slotpos = {},
        animbank = "boat_hud_row",
        animbuild = "boat_hud_row",
        pos = GLOBAL.Vector3(750, 75, 0),
        badgepos = GLOBAL.Vector3(0, 40, 0),
        equipslotroot = GLOBAL.Vector3(-80, 40, 0),
        --side_align_tip = -500,
    },
    inspectwidget = {
        slotpos = {},
        animbank = "boat_inspect_row",
        animbuild = "boat_inspect_row",
        pos = GLOBAL.Vector3(200, 0, 0),
        badgepos = GLOBAL.Vector3(0, 40, 0),
        equipslotroot = GLOBAL.Vector3(40, -45, 0),
    },
    type = "boat",
    side_align_tip = -500,
    canbeopened = false,
    hasboatequipslots = true,
    enableboatequipslots = true,
}

local boat_armoured = {
    widget = {
        slotpos = {},
        animbank = "boat_hud_row",
        animbuild = "boat_hud_row",
        pos = GLOBAL.Vector3(750, 75, 0),
        badgepos = GLOBAL.Vector3(0, 40, 0),
        equipslotroot = GLOBAL.Vector3(-80, 40, 0),
        --side_align_tip = -500,
    },
    inspectwidget = {
        slotpos = {},
        animbank = "boat_inspect_row",
        animbuild = "boat_inspect_row",
        pos = GLOBAL.Vector3(200, 0, 0),
        badgepos = GLOBAL.Vector3(0, 40, 0),
        equipslotroot = GLOBAL.Vector3(40, -45, 0),
    },
    type = "boat",
    side_align_tip = -500,
    canbeopened = false,
    hasboatequipslots = true,
    enableboatequipslots = true,
}

local boat_encrusted = {
    widget = {
        slotpos = {},
        animbank = "boat_hud_encrusted",
        animbuild = "boat_hud_encrusted",
        pos = GLOBAL.Vector3(750, 75, 0),
        badgepos = GLOBAL.Vector3(0, 40, 0),
        equipslotroot = GLOBAL.Vector3(-80, 40, 0),
        --side_align_tip = -500,
    },
    inspectwidget = {
        slotpos = {},
        animbank = "boat_inspect_encrusted",
        animbuild = "boat_inspect_encrusted",
        pos = GLOBAL.Vector3(200, 0, 0),
        badgepos = GLOBAL.Vector3(0, 155, 0),
        equipslotroot = GLOBAL.Vector3(40, 70, 0),
    },
    type = "boat",
    side_align_tip = -500,
    canbeopened = false,
    hasboatequipslots = true,
    enableboatequipslots = true,
}

for i = 2, 1,-1 do
    table.insert(boat_encrusted.widget.slotpos, GLOBAL.Vector3(-13-(80*(i+2)), 40 ,0))
end

for x = 0, 1 do
    table.insert(boat_encrusted.inspectwidget.slotpos, GLOBAL.Vector3(-40 + (x*80), 70 + (1*-75),0))
end

local boat_cargo = {
    widget = {
        slotpos = {},
        animbank = "boat_hud_cargo",
        animbuild = "boat_hud_cargo",
        pos = GLOBAL.Vector3(750, 75, 0),
        badgepos = GLOBAL.Vector3(0, 40, 0),
        equipslotroot = GLOBAL.Vector3(-80, 40, 0),
        --side_align_tip = -500,
    },
    inspectwidget = {
        slotpos = {},
        animbank = "boat_inspect_cargo",
        animbuild = "boat_inspect_cargo",
        pos = GLOBAL.Vector3(200, 0, 0),
        badgepos = GLOBAL.Vector3(0, 155, 0),
        equipslotroot = GLOBAL.Vector3(40, 70, 0),
    },
    type = "boat",
    side_align_tip = -500,
    canbeopened = false,
    hasboatequipslots = true,
    enableboatequipslots = true,
}

for i = 6, 1,-1 do
    table.insert(boat_cargo.widget.slotpos, GLOBAL.Vector3(-13-(80*(i+2)), 40 ,0))
end

for y = 1, 3 do
    for x = 0, 1 do
        table.insert(boat_cargo.inspectwidget.slotpos, GLOBAL.Vector3(-40 + (x*80), 70 + (y*-75),0))
    end
end

local boat_woodlegs = {
    widget = {
        slotpos = {},
        animbank = "boat_hud_raft",
        animbuild = "boat_hud_raft",
        pos = GLOBAL.Vector3(750, 75, 0),
        badgepos = GLOBAL.Vector3(0, 40, 0),
        equipslotroot = GLOBAL.Vector3(-80, 40, 0),
        --side_align_tip = -500,
    },
    inspectwidget = {
        slotpos = {},
        animbank = "boat_inspect_raft",
        animbuild = "boat_inspect_raft",
        pos = GLOBAL.Vector3(200, 0, 0),
        badgepos = GLOBAL.Vector3(0, 5, 0),
        equipslotroot = GLOBAL.Vector3(40, -45, 0),
    },
    type = "boat",
    side_align_tip = -500,
    canbeopened = false,
    hasboatequipslots = true,
    enableboatequipslots = false,
}

local boat_surfboard = {
    widget = {
        slotpos = {},
        animbank = "boat_hud_raft",
        animbuild = "boat_hud_raft",
        pos = GLOBAL.Vector3(750, 75, 0),
        badgepos = GLOBAL.Vector3(0, 40, 0),
        equipslotroot = GLOBAL.Vector3(-80, 40, 0),
        --side_align_tip = -500,
    },
    inspectwidget = {
        slotpos = {},
        animbank = "boat_inspect_raft",
        animbuild = "boat_inspect_raft",
        pos = GLOBAL.Vector3(200, 0, 0),
        badgepos = GLOBAL.Vector3(0, 5, 0),
        equipslotroot = {},
    },
    type = "boat",
    side_align_tip = -500,
    canbeopened = false,
    hasboatequipslots = false,
    enableboatequipslots = true,
}

AddContainerWidget("boat_raft", boat_raft)
AddContainerWidget("boat_lograft", boat_lograft)
AddContainerWidget("boat_row", boat_row)
AddContainerWidget("boat_armoured", boat_armoured)
AddContainerWidget("boat_encrusted", boat_encrusted)
AddContainerWidget("boat_cargo", boat_cargo)
AddContainerWidget("boat_woodlegs", boat_woodlegs)
AddContainerWidget("boat_surfboard", boat_surfboard)
