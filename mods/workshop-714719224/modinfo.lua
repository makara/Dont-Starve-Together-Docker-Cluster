name = "OnlinePacks"
author = "Orange"
version = "0.5.2"
forumthread = "http://steamcommunity.com/sharedfiles/filedetails/?id=714719224"
api_version = 10
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false
dst_compatible = true
all_clients_require_mod = false
client_only_mod = false
server_filter_tags = { "onlinepacks" }

icon_atlas = "modicon.xml"
icon = "modicon.tex"

description = [[Server side MOD.
Online players can receive random bonus awards every day: daily first-aid kit, basic materials, rare items, or buildings, can also accept a variety of challenge mission, kill the monster to win the reward. Resets the mission type by dice roll. The more difficult the mission reward the more generous.
Welcome message and praise in the Steam Workshop!
]]

configuration_options = {
	{
		name = "NORMAL_ITEMS",
		label = "Normal Items",
		options =
		{
			{ description = "On", data = true },
			{ description = "Off", data = false },
		},
		default = true,
	},
	{
		name = "RARE_ITEMS",
		label = "Rare Items",
		options =
		{
			{ description = "On", data = 1 },
			{ description = "Only item", data = 2 },
			{ description = "Only building", data = 3 },
			{ description = "Off", data = 0 },
		},
		default = 1,
	},
	{
		name = "BUFF_ITEMS",
		label = "BUFF Items",
		options =
		{
			{ description = "On", data = true },
			{ description = "Off", data = false },
		},
		default = true,
	},
	{
		name = "FIRST_AID_KIT",
		label = "First Aid Kit",
		options =
		{
			{ description = "On", data = true },
			{ description = "Off", data = false },
		},
		default = true,
	},
	{
		name = "PACKS_VALUE",
		label = "Package Value",
		options =
		{
			{ description = "x 0.5", data = 0.5 },
			{ description = "x 1", data = 1 },
			{ description = "x 2", data = 2 },
			{ description = "x 3", data = 3 },
			{ description = "x 4", data = 4 },
			{ description = "x 5", data = 5 },
		},
		default = 1,
	},
	{
		name = "PACKS_CD",
		label = "Package Interval (day)",
		options =
		{
			{ description = "Every day", data = 1 },
			{ description = "2", data = 2 },
			{ description = "3", data = 3 },
			{ description = "4", data = 4 },
			{ description = "5", data = 5 },
		},
		default = 2,
	},
	{
		name = "CHALLENGE_MISSION_DIFFICULTY",
		label = "Mission Difficulty",
		options =
		{
			{ description = "Random", data = 0 },
			{ description = "Easy", data = 1 },
			{ description = "Hard", data = 2 },
			{ description = "Hell", data = 3 },
		},
		default = 0,
	},
	{
		name = "CHALLENGE_MISSION",
		label = "Challenge Mission (day)",
		options =
		{
			{ description = "Off", data = 0 },
			{ description = "5", data = 5 },
			{ description = "10", data = 10 },
			{ description = "15", data = 15 },
			{ description = "20", data = 20 },
			{ description = "25", data = 25 },
			{ description = "30", data = 30 },
		},
		default = 5,
	},
	{
		name = "CHALLENGE_MISSION_ROLL",
		label = "Dice Roll Reset (point)",
		options =
		{
			{ description = "Off", data = 0 },
			{ description = "5", data = 5 },
			{ description = "50", data = 50 },
			{ description = "60", data = 60 },
			{ description = "70", data = 70 },
			{ description = "80", data = 80 },
			{ description = "85", data = 85 },
			{ description = "90", data = 90 },
			{ description = "95", data = 95 },
		},
		default = 70,
	},
	{
		name = "CHALLENGE_MISSION_CD",
		label = "Mission Interval (day)",
		options =
		{
			{ description = "Every day", data = 1 },
			{ description = "2", data = 2 },
			{ description = "3", data = 3 },
			{ description = "5", data = 5 },
			{ description = "8", data = 8 },
			{ description = "10", data = 10 },
		},
		default = 3,
	},
	{
		name = "RECORD_DEATH",
		label = "Record Death",
		options =
		{
			{ description = "On", data = true, hover = "Death or Restart are no longer gift packs" },
			{ description = "Off", data = false, hover = "Always the gift packs" },
		},
		default = true,
	},
	{
		name = "ANNOUNCE_TIP",
		label = "Announce Tip",
		options =
		{
			{ description = "On", data = true },
			{ description = "Off", data = false },
		},
		default = true,
	},
}
