name = "Remove Penalty"

description = "Removes the movement-speed penalty of Piggyback and/or Marble-suit"

author = "ChaosMind42"

version = "1.2"

api_version = 10

dont_starve_compatible = true
reign_of_giants_compatible = true
dst_compatible = true

forumthread = ""

all_clients_require_mod = true
clients_only_mod = false

server_filter_tags = {"utility"}

configuration_options =
{

   	{
		name = "PIGGYBACKSPDMULT",
		label = "Piggyback spd pen",
		options =	{
						{description = "off", data = 1},
						{description = "on", data = 0.8},
					},
		default = 1,
	},
   	{
		name = "MARBLESUITSPDMULT",
		label = "Marble-Suit spd pen",
		options =	{
						{description = "off", data = 1},
						{description = "on", data = 0.7},
					},
		default = 1,
	},
}

priority = 0.00378965501

