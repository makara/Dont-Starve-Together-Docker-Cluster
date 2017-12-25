-- This information tells other players more about the mod
name = "Fix Multiplayer"
description = "Fixes multiplayer gameplay with many small tweaks. Intended for open servers, but also useful for private servers."
author = "icke"
version = "1.1.10"
forumthread = ""

-- This lets other players know if your mod is out of date, update it to match the current version in the game
api_version = 10

-- Can specify a custom icon for this mod!
icon_atlas = "FixMultiplayer.xml"
icon = "FixMultiplayer.tex"

-- Compatability
dont_starve_compatible = false
reign_of_giants_compatible = false
dst_compatible = true

all_clients_require_mod = true
clients_only_mod = false

-- ModConfiguration option
configuration_options =
{
	{
		name = "STARTINGITEMS",
		label = "Starting Items",
		options =	{
						{description = "No (off)", data = false},
						{description = "Yes", data = true},
					},
		default = true,
	},
	{
		name = "SEASONSTARTINGITEMS",
		label = "Seasonal Starting Items",
		options =	{
						{description = "No (off)", data = false},
						{description = "Yes", data = true},
					},
		default = true,
	},
	{
		name = "NIGHTSTARTINGITEMS",
		label = "Night Starting Items",
		options =	{
						{description = "No (off)", data = false},
						{description = "Yes", data = true},
					},
		default = true,
	},
	{
		name = "PVPSTARTINGITEMS",
		label = "PVP Starting Items",
		options =	{
						{description = "No (off)", data = false},
						{description = "Yes", data = true},
					},
		default = true,
	},
	{
		name = "CAVESTARTINGITEMS",
		label = "Cave Starting Items",
		options =	{
						{description = "No (off)", data = false},
						{description = "Yes", data = true},
					},
		default = true,
	},
	{
		name = "REVEALMAP",
		label = "Reveal Map",
		options =	{
						{description = "No (off)", data = 0},
						{description = "Only Roads", data = 1},
						{description = "Yes", data = 2},
					},
		default = 1,
	},
	{
		name = "RENEWLIMITEDRESOURCES",
		label = "Renew Limited Resources",
		options =	{
						{description = "No (off)", data = 0},
						{description = "Very Slow", data = 72},
						{description = "Slow", data = 36},
						{description = "Normal", data = 18},
						{description = "Fast", data = 9},
						{description = "Very Fast", data = 6},
					},
		default = 18,
	},
	{
		name = "DRAGONFLYBALANCE",
		label = "Dragonfly Balance",
		options =	{
						{description = "No (off)", data = false},
						{description = "Yes", data = true},
					},
		default = true,
	},
	{
		name = "MAXMAXPLAYERS",
		label = "Max Max Players",
		options =	{
						{description = "6 (off)", data = 6},
						{description = "32", data = 32},
					},
		default = 32,
	},
	{
		name = "REVIVERCRAFTPENALTY",
		label = "Reviver Craft Penalty",
		options =	{
						{description = "No", data = false},
						{description = "Yes (off)", data = true},
					},
		default = false,
	},
	{
		name = "DRYINGSPEEDMULTIPLIER",
		label = "Drying Speed Multiplier",
		options =	{
						{description = "1 (off)", data = 1},
						{description = "1.5", data = 1.5},
						{description = "2", data = 2},
						{description = "3", data = 3},
						{description = "4", data = 4},
					},
		default = 2,
	},
	{
		name = "FARMINGSPEEDMULTIPLIER",
		label = "Farming Speed Multiplier",
		options =	{
						{description = "1 (off)", data = 1},
						{description = "1.5", data = 1.5},
						{description = "2", data = 2},
						{description = "3", data = 3},
						{description = "4", data = 4},
					},
		default = 2,
	},
	{
		name = "BEESSPEEDMULTIPLIER",
		label = "Bees Speed Multiplier",
		options =	{
						{description = "1 (off)", data = 1},
						{description = "1.2", data = 1.2},
						{description = "1.5", data = 1.5},
						{description = "2", data = 2},
					},
		default = 1.5,
	},
	{
		name = "KRAMPUSMULTIPLIER",
		label = "Krampus Multiplier",
		options =	{
						{description = "1 (off)", data = 1},
						{description = "1.5", data = 1.5},
						{description = "2", data = 2},
						{description = "3", data = 3},
						{description = "4", data = 4},
					},
		default = 2,
	},
	{
		name = "RESIZEFIREPITS",
		label = "Resize Fire Pits",
		options =	{
						{description = "No (off)", data = false},
						{description = "Yes", data = true},
					},
		default = true,
	},
	{
		name = "AMOUNTOFCHESTERS",
		label = "Amount of chesters",
		options =	{
						{description = "1 (semi-off)", data = 1},
						{description = "2", data = 2},
						{description = "3", data = 3},
						{description = "4", data = 4},
						{description = "6", data = 6},
						{description = "8", data = 8},
						{description = "10", data = 10},
						{description = "12", data = 12},
						{description = "16", data = 16},
						{description = "20", data = 20},
						{description = "24", data = 24},
						{description = "32", data = 32},
					},
		default = 4,
	},
	{
		name = "CANHAUNT",
		label = "Can Haunt",
		options =	{
						{description = "Only useful", data = 0},
						{description = "+Boss spawn", data = 1},
						{description = "All (off)", data = 2},
					},
		default = 1,
	},
	{
		name = "GHOSTSANITYDRAIN",
		label = "Ghost Sanity Drain",
		options =	{
						{description = "No", data = false},
						{description = "Yes (off)", data = true},
					},
		default = false,
	},
	{
		name = "EMPTYINVENTORYDAYS",
		label = "Empty Inventory Days",
		options =	{
						{description = "No (off)", data = 0},
						{description = "Kick/Ban", data = -1},
						{description = "1", data = 1},
						{description = "2", data = 2},
						{description = "3", data = 3},
						{description = "5", data = 5},
					},
		default = 2,
	},
	{
		name = "PREVENTSTEALINGDAYS",
		label = "Prevent Stealing Days",
		options =	{
						{description = "0 (off)", data = 0},
						{description = "1", data = 1},
						{description = "2", data = 2},
						{description = "3", data = 3},
						{description = "5", data = 5},
					},
		default = 2,
	},
	{
		name = "PREVENTDESTROYINGDAYS",
		label = "Prevent Destroying Days",
		options =	{
						{description = "0 (off)", data = 0},
						{description = "1", data = 1},
						{description = "2", data = 2},
						{description = "3", data = 3},
						{description = "5", data = 5},
						{description = "Forever", data = -1},
					},
		default = 5,
	},
	{
		name = "PREVENTBURNING",
		label = "Prevent Burning Days",
		options =	{
						{description = "0 (off)", data = 0},
						{description = "1", data = 1},
						{description = "2", data = 2},
						{description = "3", data = 3},
						{description = "5", data = 5},
					},
		default = 2,
	},
	{
		name = "SPREADFIRE",
		label = "Spread Fire",
		options =	{
						{description = "No", data = 0},
						{description = "Half Range", data = 1},
						{description = "Yes (off)", data = 2},
					},
		default = 1,
	},
}