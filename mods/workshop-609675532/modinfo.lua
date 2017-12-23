name = "Limit Prefab"
description = [[
	Limit Prefab spawn count

	Limit anything you want to !
	Same theory as "Less lags", but implement in a smarter way !!
	If spawned prefab reached limit, will auto despawn after 0.1s(default)

	config:
		- despawn delay: the delay of reached limit auto despawn
		- counting mode: the methoed of counting prefab
			- more RAM : using table + event to count
			- more CPU : loop through all 
		- despawn mode: decide which to despawn
			- remove newest : use less resource of all, but not natural at all
			- remove oldest : as it's name
			- remove random : use most resource of all, but more natural

	License: MIT, Copyright (c) 2016 cs8425

]]
author = "cs8425"
version = "0.3.7"

forumthread = ""

api_version = 10

--icon_atlas = "modicon.xml"
--icon = "modicon.tex"

all_clients_require_mod = false
--all_clients_require_mod = true
client_only_mod = false
dst_compatible = true
server_filter_tags = {"Server admin"}

-- ModConfiguration option
configuration_options = {
	{
		name = "despawn_delay",
		label = "despawn delay",
		options =
		{
			{description = "0", data = 0},
			{description = "0.1", data = 0.1},
			{description = "0.5", data = 0.5},
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "5", data = 5},
			{description = "10", data = 10},
			{description = "20", data = 20},
			{description = "30", data = 30},
		},
		default = 0.1
	},
	{
		name = "res_mode",
		label = "counting mode",
		options =
		{
			{description = "more RAM", data = "MEM"},
			{description = "more CPU", data = "CPU"},
		},
		default = "MEM"
	},
	{
		name = "despawn_mode",
		label = "despawn mode",
		options =
		{
			{description = "remove newest", data = "NEW"},
			{description = "remove oldest", data = "OLD"},
			{description = "remove random", data = "RANDOM"},
		},
		default = "RANDOM"
	},
	{
		name = "_debug",
		label = "debug mode",
		options =
		{
			{description = "Yes", data = true},
			{description = "No", data = false},
		},
		default = false
	},
	{
		name = "limit_table",
		label = "table of prefabs limit",
		options =
		{
			{description = "default", data = "def" },
			{description = "set your self", data = { bee = 30, killerbee = 30, spider = 20, frog = 20} },
		},
		default = "def"
	},
}

