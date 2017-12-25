--[[
*********************************************************************************************************
Original coding created by: DMCartz
Massively rewritten by: phixius83
MASSIVELY re-rewritten by: DragonWolfLeo & SinisterHumanoid
Date: 012/22/16
Description: Tweak the durability for weapons, armor, staffs, amulets, tools, traps, clothing and lights.
*********************************************************************************************************
]]

-----------------------
-- General information!
-----------------------

name = "Tweak Those Tools, Re-Tweaked!"					-- Comment out depending on which version we're working on
description = "Version 5.21  \nAllows tweaking of just about every item in the game with durability or fuel usage.\n(Re-Fixed Version)"
author = "DMCartz, phixius83, Dragon Wolf Leo, SinisterHumanoid"

version = "5.21"

-- Currently no forum thread.
forumthread = ""

-- Developed for this version of the game.
api_version = 10

-- Custom icon.
icon_atlas = "Tweak.xml"
icon = "Tweak.tex"

-- Priority
priority = -1
-----------------
-- Compatibility!
-----------------

-- Only supported for Don't Starve Together!
dont_starve_compatible = false
reign_of_giants_compatible = true
dst_compatible = true

-- Not required by all clients.
all_clients_require_mod = false

--------------------------------------------------
-- Begin code for configuring all of the settings!
--------------------------------------------------

configuration_options =
{
	{
		name = "WEAPON_DURABILITY",
		label = "Weapon Durability",
		options =	{
						{description = "25%", data = 0.25},
						{description = "50%", data = 0.5},
						{description = "75%", data = 0.75},
						{description = "Default", data = "Default"},
						{description = "200%", data = 2},
						{description = "300%", data = 3},
						{description = "400%", data = 4},
						{description = "500%", data = 5},
						{description = "750%", data = 7.5},
						{description = "1000%", data = 10},
						{description = "Infinite", data = "Infinite"},
					},

		default = "Default",
	},
	
	{
		name = "ARMOR_DURABILITY",
		label = "Armor Durability",
		options =	{
						{description = "25%", data = 0.25},
						{description = "50%", data = 0.5},
						{description = "75%", data = 0.75},
						{description = "Default", data = "Default"},
						{description = "200%", data = 2},
						{description = "300%", data = 3},
						{description = "400%", data = 4},
						{description = "500%", data = 5},
						{description = "750%", data = 7.5},
						{description = "1000%", data = 10},
						{description = "Infinite", data = "Infinite"},
					},

		default = "Default",
	},
	
	{
		name = "STAFF_DURABILITY",
		label = "Staff Durability",
		options =	{
						{description = "25%", data = 0.25},
						{description = "50%", data = 0.5},
						{description = "75%", data = 0.75},
						{description = "Default", data = "Default"},
						{description = "200%", data = 2},
						{description = "300%", data = 3},
						{description = "400%", data = 4},
						{description = "500%", data = 5},
						{description = "750%", data = 7.5},
						{description = "1000%", data = 10},
						{description = "Infinite", data = "Infinite"},
					},

		default = "Default",
	},
	
	{
		name = "AMULET_DURABILITY",
		label = "Amulet Durability",
		options =	{
						{description = "25%", data = 0.25},
						{description = "50%", data = 0.5},
						{description = "75%", data = 0.75},
						{description = "Default", data = "Default"},
						{description = "200%", data = 2},
						{description = "300%", data = 3},
						{description = "400%", data = 4},
						{description = "500%", data = 5},
						{description = "750%", data = 7.5},
						{description = "1000%", data = 10},
						{description = "Infinite", data = "Infinite"},
					},

		default = "Default",
	},

	{
		name = "TOOL_DURABILITY",
		label = "Tool Durability",
		options =	{
						{description = "25%", data = 0.25},
						{description = "50%", data = 0.5},
						{description = "75%", data = 0.75},
						{description = "Default", data = "Default"},
						{description = "200%", data = 2},
						{description = "300%", data = 3},
						{description = "400%", data = 4},
						{description = "500%", data = 5},
						{description = "750%", data = 7.5},
						{description = "1000%", data = 10},
						{description = "Infinite", data = "Infinite"},
					},

		default = "Default",
	},
	
	{
		name = "GOLD_DURABILITY",
		label = "Gold Tool Durability",
		options =	{
						{description = "25%", data = 0.25},
						{description = "50%", data = 0.5},
						{description = "75%", data = 0.75},
						{description = "Default", data = "Default"},
						{description = "200%", data = 2},
						{description = "300%", data = 3},
						{description = "400%", data = 4},
						{description = "500%", data = 5},
						{description = "750%", data = 7.5},
						{description = "1000%", data = 10},
						{description = "Infinite", data = "Infinite"},
					},

		default = "Default",
	},

	{
		name = "TRAP_DURABILITY",
		label = "Trap Durability",
		options =	{
						{description = "25%", data = 0.25},
						{description = "50%", data = 0.5},
						{description = "75%", data = 0.75},
						{description = "Default", data = "Default"},
						{description = "200%", data = 2},
						{description = "300%", data = 3},
						{description = "400%", data = 4},
						{description = "500%", data = 5},
						{description = "750%", data = 7.5},
						{description = "1000%", data = 10},
						{description = "Infinite", data = "Infinite"},
					},

		default = "Default",
	},
	
	{
		name = "CLOTHING_DURABILITY",
		label = "Clothing Durability",
		options =	{
						{description = "25%", data = 0.25},
						{description = "50%", data = 0.5},
						{description = "75%", data = 0.75},
						{description = "Default", data = "Default"},
						{description = "200%", data = 2},
						{description = "300%", data = 3},
						{description = "400%", data = 4},
						{description = "500%", data = 5},
						{description = "750%", data = 7.5},
						{description = "1000%", data = 10},
						{description = "Infinite", data = "Infinite"},
					},

		default = "Default",
	},
	
		{
		name = "LIGHT_DURABILITY",
		label = "Light Durability",
		options =	{
						{description = "25%", data = 0.25},
						{description = "50%", data = 0.5},
						{description = "75%", data = 0.75},
						{description = "Default", data = "Default"},
						{description = "200%", data = 2},
						{description = "300%", data = 3},
						{description = "400%", data = 4},
						{description = "500%", data = 5},
						{description = "750%", data = 7.5},
						{description = "1000%", data = 10},
						{description = "Infinite", data = "Infinite"},
					},

		default = "Default",
	},
	
		{
		name = "CAMPING_DURABILITY",
		label = "Camping Durability",
		options =	{
						{description = "25%", data = 0.25},
						{description = "50%", data = 0.5},
						{description = "75%", data = 0.75},
						{description = "Default", data = "Default"},
						{description = "200%", data = 2},
						{description = "300%", data = 3},
						{description = "400%", data = 4},
						{description = "500%", data = 5},
						{description = "750%", data = 7.5},
						{description = "1000%", data = 10},
						{description = "Infinite", data = "Infinite"},
					},

		default = "Default",
	},
	
		{
		name = "BOOK_DURABILITY",
		label = "Book Durability",
		options =	{
						{description = "25%", data = 0.25},
						{description = "50%", data = 0.5},
						{description = "75%", data = 0.75},
						{description = "Default", data = "Default"},
						{description = "200%", data = 2},
						{description = "300%", data = 3},
						{description = "400%", data = 4},
						{description = "500%", data = 5},
						{description = "750%", data = 7.5},
						{description = "1000%", data = 10},
						{description = "Infinite", data = "Infinite"},
					},

		default = "Default",
	},
		{
		name = "FOOD_PRESERVATION",
		label = "Food Preservation",
		options =	{
						{description = "25%", data = 0.25},
						{description = "50%", data = 0.5},
						{description = "75%", data = 0.75},
						{description = "Default", data = "Default"},
						{description = "200%", data = 2},
						{description = "300%", data = 3},
						{description = "400%", data = 4},
						{description = "500%", data = 5},
						{description = "750%", data = 7.5},
						{description = "1000%", data = 10},
						{description = "Infinite", data = "Infinite"},
					},

		default = "Default",
	},
		{
		name = "FOOD_SELECTION",
		label = "Food Tweak",
		hover = "Tells the mod to either tweak all foods, or just those preserved with a meat rack or ice box.",
		options =	{
						{description = "All Food", data = "All"},
						{description = "Preserved", data = "Preserved"},
					},

		default = "Preserved",
	},
		{
		name = "DEBUGOPTIONS",
		label = "Debug",
		hover = "Using Debug tools will cause a LOT of spam in the console.  Use at own risk.",
		options =	{
						{description = "Off", data = "Off"},
						{description = "Weapons", data = "Weapon"},
						{description = "Armor", data = "Armor"},
						{description = "Staves", data = "Staff"},
						{description = "Amulets", data = "Amulet"},
						{description = "Tools", data = "Tool"},
						{description = "Gold Tools", data = "GoldTool"},
						{description = "Traps", data = "Trap"},
						{description = "Clothing", data = "Clothing"},
						{description = "Lights", data = "Light"},
						{description = "Camping", data = "Camping"},
						{description = "Books", data = "Book"},
						{description = "Food", data = "Food"},
					},

		default = "Off",
	},
	
}