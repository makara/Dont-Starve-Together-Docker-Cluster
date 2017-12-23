name = "More Weapons and Magic"
description = "Please rate and share it! Every help/donation is appreciated! Hope you enjoy brothers and sisters! :) Version: 0.1" 
author = "Weexer"

version = "0.1"

forumthread = ""

api_version = 10

dst_compatible = true

dont_starve_compatible = false
reign_of_giants_compatible = false

all_clients_require_mod = true

icon = "modicon.tex"
icon_atlas = "modicon.xml"

configuration_options =
{
	{
		name = "book_slowness",
		label = "Book Slowness",
        hover = "Configure Recipe Difficulty",
		options =
	{
		{description = "Easy", data = "easy", hover = "1 Compass, 2 Slurtle Slime, 2 Papyrus"},
		{description = "Normal", data = "normal", hover = "1 Compass, 4 Slurtle Slime, 3 Papyrus"},
		{description = "Hard", data = "hard", hover = "1 Orange Gem, 6 Slurtle Slime, 4 Papyrus"},
	},
		default = "normal",
	},
	{
		name = "book_freeze",
		label = "Book Freezing",
        hover = "Configure Recipe Difficulty",
		options =
	{
		{description = "Easy", data = "easy", hover = "6 Ice, 1 Blue Gem, 2 Papyrus"},
		{description = "Normal", data = "normal", hover = "8 Ice, 2 Blue Gem, 3 Papyrus"},
		{description = "Hard", data = "hard", hover = "10 Ice, 3 Blue Gem, 4 Papyrus"},
	},
		default = "normal",
	},
	{
		name = "book_healing",
		label = "Book Healing",
        hover = "Configure Recipe Difficulty",
		options =
	{
		{description = "Easy", data = "easy", hover = "2 Healing Salve, 1 Red Gem, 2 Papyrus"},
		{description = "Normal", data = "normal", hover = "4 Healing Salve, 2 Red Gem, 3 Papyrus"},
		{description = "Hard", data = "hard", hover = "6 Healing Salve, 3 Red Gem, 4 Papyrus"},
	},
		default = "normal",
	},
	{
		name = "book_lava",
		label = "Book Lava",
        hover = "Configure Recipe Difficulty",
		options =
	{
		{description = "Easy", data = "easy", hover = "2 Nightmare Fuel, 1 Red Gem, 2 Papyrus"},
		{description = "Normal", data = "normal", hover = "4 Nightmare Fuel, 2 Red Gem, 3 Papyrus"},
		{description = "Hard", data = "hard", hover = "6 Nightmare Fuel, 3 Red Gem, 4 Papyrus"},
	},
		default = "normal",
	},
	{
		name = "book_sleepingfield",
		label = "Book Sleeping Bombs",
        hover = "Configure Recipe Difficulty",
		options =
	{
		{description = "Easy", data = "easy", hover = "1 Pan Flute, 1 Nightmare Fuel, 2 Papyrus"},
		{description = "Normal", data = "normal", hover = "1 Mandrake, 2 Nightmare Fuel, 3 Papyrus"},
		{description = "Hard", data = "hard", hover = "1 Mandrake, 3 Nightmare Fuel, 4 Papyrus"},
	},
		default = "normal",
	},
	{
		name = "book_light",
		label = "Book Light",
        hover = "Configure Recipe Difficulty",
		options =
	{
		{description = "Easy", data = "easy", hover = "2 Lightbulb, 1 Yellow Gem, 2 Papyrus"},
		{description = "Normal", data = "normal", hover = "1 Lantern, 1 Yellow Gem, 3 Papyrus"},
		{description = "Hard", data = "hard", hover = "3 Nightmare Fuel, 1 Yellow Gem, 4 Papyrus"},
	},
		default = "normal",
	},
	{
		name = "book_tornado",
		label = "Book Tornado",
        hover = "Configure Recipe Difficulty",
		options =
	{
		{description = "Easy", data = "easy", hover = "1 Grass Umbrella, 2 Crow Feather, 2 Winter Feather"},
		{description = "Normal", data = "normal", hover = "1 Umbrella, 3 Crow Feather, 3 Winter Feather"},
		{description = "Hard", data = "hard", hover = "1 Eyebrella, 4 Crow Feather, 4 Winter Feather"},
	},
		default = "normal",
	},
	{
		name = "book_meteor",
		label = "Book Meteor",
        hover = "Configure Recipe Difficulty",
		options =
	{
		{description = "Easy", data = "easy", hover = "4 Moon rocks, 1 Red Gem, 2 Papyrus"},
		{description = "Normal", data = "normal", hover = "6 Moon rocks, 2 Red Gem, 3 Papyrus"},
		{description = "Hard", data = "hard", hover = "8 Moon rocks, 3 Red Gem, 4 Papyrus"},
	},
		default = "normal",
	},
	{
		name = "book_dogs",
		label = "Book Wolves",
        hover = "Configure Recipe Difficulty",
		options =
	{
		{description = "Easy", data = "easy", hover = "4 Houndstooth, 1 Bone Shard, 2 Papyrus"},
		{description = "Normal", data = "normal", hover = "6 Houndstooth, 2 Bone Shard, 3 Papyrus"},
		{description = "Hard", data = "hard", hover = "8 Hounds Tooth, 3 Bone Shard, 4 Papyrus"},
	},
		default = "normal",
	},
	{
		name = "book_summon",
		label = "Book Summon Boss",
        hover = "Configure Recipe Difficulty",
		options =
	{
		{description = "Easy", data = "easy", hover = "1 Thulecite Medallion, 2 Telltale Heart, 1 Green Gem"},
		{description = "Normal", data = "normal", hover = "2 Thulecite Medallion, 3 Telltale Heart, 1 Yellow Gem"},
		{description = "Hard", data = "hard", hover = "3 Thulecite Medallion, 4 Telltale Heart, 1 Orange Gem"},
	},
		default = "normal",
	},
	{
		name = "flamesword",
		label = "Recipe Flamesword",
        hover = "Configure Recipe Difficulty",
		options =
	{
		{description = "Easy", data = "easy", hover = "2 Red Gem, 4 Marble, 1 Green Gem"},
		{description = "Normal", data = "normal", hover = "3 Red Gem, 5 Marble, 1 Green Gem"},
		{description = "Hard", data = "hard", hover = "4 Red Gem, 7 Marble, 1 Green Gem"},
	},
		default = "normal",
	},
	{
		name = "katana",
		label = "Recipe Bushido Katana",
        hover = "Configure Recipe Difficulty",
		options =
	{
		{description = "Easy", data = "easy", hover = "1 Red Gem, 3 Nightmare Fuel, 2 Marble"},
		{description = "Normal", data = "normal", hover = "2 Red Gem, 4 Nightmare Fuel, 3 Marble"},
		{description = "Hard", data = "hard", hover = "3 Red Gem, 5 Nightmare Fuel, 4 Marble"},
	},
		default = "normal",
	},
	{
		name = "healingstaff",
		label = "Recipe Healing Staff",
        hover = "Configure Recipe Difficulty",
		options =
	{
		{description = "Easy", data = "easy", hover = "1 Red Gem, 1 Walking Cane, 2 Living Log"},
		{description = "Normal", data = "normal", hover = "2 Red Gem, 1 Walking Cane, 4 Living Log"},
		{description = "Hard", data = "hard", hover = "3 Red Gem, 1 Walking Cane, 6 Living Log"},
	},
		default = "normal",
	},
	{
		name = "poseidon",
		label = "Recipe Poseidon's Trident",
        hover = "Configure Recipe Difficulty",
		options =
	{
		{description = "Easy", data = "easy", hover = "1 Blue Gem, 1 Tantacle Spike, 7 Ice"},
		{description = "Normal", data = "normal", hover = "2 Blue Gem, 1 Tantacle Spike, 10 Ice"},
		{description = "Hard", data = "hard", hover = "3 Blue Gem, 1 Tantacle Spike, 14 Ice"},
	},
		default = "normal",
	},
	{
		name = "teleportstaff",
		label = "Recipe Teleport Spear",
        hover = "Configure Recipe Difficulty",
		options =
	{
		{description = "Easy", data = "easy", hover = "1 Orange Gem, 2 Gold Nugget, 1 Spear"},
		{description = "Normal", data = "normal", hover = "1 Orange Gem, 4 Gold Nugget, 1 Spear"},
		{description = "Hard", data = "hard", hover = "1 Orange Gem, 8 Gold Nugget, 1 Spear"},
	},
		default = "normal",
	},
	{
		name = "skullspear",
		label = "Recipe Skull Spear",
        hover = "Configure Recipe Difficulty",
		options =
	{
		{description = "Easy", data = "easy", hover = "1 Hounds Tooth, 1 Bone Shard, 1 Spear"},
		{description = "Normal", data = "normal", hover = "2 Hounds Tooth, 2 Bone Shard, 1 Spear"},
		{description = "Hard", data = "hard", hover = "3 Hounds Tooth, 3 Bone Shard, 1 Spear"},
	},
		default = "normal",
	},
	{
		name = "halberd",
		label = "Recipe Halberd",
        hover = "Configure Recipe Difficulty",
		options =
	{
		{description = "Easy", data = "easy", hover = "3 Twigs, 1 Rope, 1 Spear"},
		{description = "Normal", data = "normal", hover = "2 Flint, 2 Rope, 1 Spear"},
		{description = "Hard", data = "hard", hover = "4 Flint, 2 Rope, 1 Spear"},
	},
		default = "normal",
	},
	{
		name = "deathscythe",
		label = "Recipe Death's Scythe",
        hover = "Configure Recipe Difficulty",
		options =
	{
		{description = "Easy", data = "easy", hover = "1 Walrus Tusk, 3 Nightmare Fuel, 1 Telltale Heart"},
		{description = "Normal", data = "normal", hover = "8 Ice, 5 Nightmare Fuel, 2 Telltale Heart"},
		{description = "Hard", data = "hard", hover = "10 Ice, 7 Nightmare Fuel, 3 Telltale Heart"},
	},
		default = "normal",
	},
	{
		name = "purplesword",
		label = "Recipe Purple Sword",
        hover = "Configure Recipe Difficulty",
		options =
	{
		{description = "Easy", data = "easy", hover = "2 Purple Gem, 4 Flint, 1 Rope"},
		{description = "Normal", data = "normal", hover = "2 Purple Gem, 1 Dragon Scales, 2 Rope"},
		{description = "Hard", data = "hard", hover = "3 Purple Gem, 1 Dragon Scales, 2 Silk"},
	},
		default = "normal",
	},
	{
		name = "battleaxe",
		label = "Recipe Battle Axe",
        hover = "Configure Recipe Difficulty",
		options =
	{
		{description = "Easy", data = "easy", hover = "2 Golden Axe, 3 Nitre, 1 Nightmare Fuel"},
		{description = "Normal", data = "normal", hover = "2 Golden Axe, 3 Charcoal, 2 Nightmare Fuel"},
		{description = "Hard", data = "hard", hover = "2 Golden Axe, 3 Silk, 3 Nightmare Fuel"},
	},
		default = "normal",
	},
	{
		name = "pirate",
		label = "Recipe Pirate Sword",
        hover = "Configure Recipe Difficulty",
		options =
	{
		{description = "Easy", data = "easy", hover = "1 Bat Wing, 1 Gold Nugget, 1 Rope"},
		{description = "Normal", data = "normal", hover = "1 Bat Wing, 2 Gold Nugget, 2 Rope"},
		{description = "Hard", data = "hard", hover = "1 Bat Wing, 3 Gold Nugget, 2 Rope"},
	},
		default = "normal",
	},
}