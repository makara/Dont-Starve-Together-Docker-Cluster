-- This information tells other players more about the mod
name = "Food Values - Item Tooltips (Server and Client)"
description = "Combines the Display Food Values mod and the Item Tooltips mod for the client and server (incompatible separately). "
author = "gregdwilson"
version = "2.5"

forumthread = ""

-- This lets other players know if your mod is out of date, update it to match the current version in the game
api_version = 10

--This let's the game know that this mod doesn't need to be listed in the server's mod listing
client_only_mod = false

--Let the mod system know that this mod is functional with Don't Starve Together
dst_compatible = true

all_clients_require_mod = true 

-- Can specify a custom icon for this mod!
icon_atlas = "FoodValuesItemTooltips.xml"
icon = "FoodValuesItemTooltips.tex"

-- Specify the priority
priority=3

configuration_options =
{
	{
		name = "DFV_Language",
		label = "Language",
		options =	{
						{description = "English", data = "EN"},
						{description = "French", data = "FR"},
						{description = "German", data = "GR"},
						{description = "Russian", data = "RU"},
						{description = "Spanish", data = "SP"},
						{description = "Italian", data = "IT"},
					},

		default = "EN",
	
	},
	
	{
		name = "DFV_MinimalMode",
		label = "Minimal mode",
		options =	{
						{description = "Off", data = "default"},
						{description = "On", data = "on"},
					},

		default = "default",
	
	},
	
	{
		name = "DFV_ClientPrediction",
		label = "Enable client bruteforce",
		options =	{
						{description = "Off", data = "default"},
						{description = "On", data = "On"},
					},

		default = "default",
	},
	
	{
		name = "DFV_PercentReplace",
		label = "Replace icon %",
		options =	{
						{description = "Off", data = "default"},
						{description = "On", data = "On"},
					},

		default = "default",
	},
	
	{
		name = "DFV_ShowDamage",
		label = "Show damage",
		options =	{
						{description = "On", data = "default"},
						{description = "Off", data = "off"},
					},

		default = "default",
	},
	{
		name = "DFV_ShowUses",
		label = "Show uses",
		options =	{
						{description = "On", data = "default"},
						{description = "Off", data = "off"},
					},

		default = "default",
	},
	{
		name = "DFV_FueledSettings",
		label = "Fueled items time format",
		options =	{
						{description = "Min:Sec", data = "default"},
						{description = "Clock segments", data = "seg"},
						{description = "Both", data = "both"},
						{description = "Off", data = "off"},
					},

		default = "default",
	},
	{
		name = "DFV_ShowTemperature",
		label = "Show temperature",
		options =	{
						{description = "On", data = "default"},
						{description = "Off", data = "off"},
					},

		default = "default",
	},
	{
		name = "DFV_ShowACondition",
		label = "Show armour condition",
		options =	{
						{description = "On", data = "default"},
						{description = "Off", data = "off"},
					},

		default = "default",
	},
	{
		name = "DFV_ShowADefence",
		label = "Show armour defence",
		options =	{
						{description = "On", data = "default"},
						{description = "Off", data = "off"},
					},

		default = "default",
	},
	{
		name = "DFV_ShowAType",
		label = "Show armour type",
		options =	{
						{description = "On", data = "default"},
						{description = "Off", data = "off"},
					},

		default = "default",
	},
	{
		name = "DFV_ShowInsulation",
		label = "Show insulation",
		options =	{
						{description = "On", data = "default"},
						{description = "Off", data = "off"},
					},

		default = "default",
	},
	
	{
		name = "DFV_ShowFireTime",
		label = "Remaining Fire Burn Time",
		options =	{
						{description = "On", data = "default"},
						{description = "Off", data = "off"},
					},

		default = "default",
	},
}