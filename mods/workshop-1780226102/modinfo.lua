-- Mod Name
name = "Island Adventures - Essential Islands Addon"

-- Mod Authors
author = "Mobbstar, Terra M Welch"

-- Mod Version
version = "0.5.4.1"

-- Mod Description
description = "Adds special Islands to the Island Adventures mod worlds. Mostly only required when generating new worlds.\n\nShould you encounter a problem, please tell me everything about the problem so I can repair things!"

description = description .. "\n\nVersion: " .. version

-- In-game link to a thread or file download on the Klei Entertainment Forums
forumthread = "/topic/95080-island-adventures-the-shipwrecked-port/"

IslandAdventures = true

folder_name = folder_name or "workshop-"
if not folder_name:find("workshop-") then
	name = " " .. name .. " - Local Ver."
	description = description .. "\n\nRemember to manually update!"
	IslandAdventuresGitlab = true
end

-- Don't Starve API version
-- Note: We set this to 10 so that it's incompatible with single player.
api_version = 10
-- Don't Starve Together API version
api_version_dst = 10

-- Priority of which our mod will be loaded
-- Below 0 means other mods will override our mod by default.
-- Above 0 means our mod will override other mods by default.
priority = 1 --loads after IA (2) but before generic mods

-- Forces user to reboot game upon enabling the mod
restart_required = false

-- Engine/DLC Compatibility
-- Don't Starve (Vanilla, no DLCs)
dont_starve_compatible = false
-- Don't Starve: Reign of Giants
reign_of_giants_compatible = false
-- Don't Starve: Shipwrecked
shipwrecked_compatible = false
-- Don't Starve Together
dst_compatible = true

-- Client-only mods don't affect other players or the server.
client_only_mod = false
-- Mods which add new objects are required by all clients.
all_clients_require_mod = true

-- Server search tags for the mod.
server_filter_tags =
{
    "Terra M Welch",
	"Mobbstar",
	"Island Adventures",
	"Island_Adventures",
	"Essential Islands",
}

-- Preview image
icon_atlas = "ia-icon.xml"
icon = "ia-icon.tex"


-- Thanks to the Gorge Extender by CunningFox for making me aware of this being possible -M
local emptyoptions = {{description="", data=false}}
local function Breaker(title, hover)
	return {
		name=title,
		hover=hover, --hover does not work
		options=emptyoptions,
		default=false,
	}
end

local options_enable = {
	{description = "Disabled", data = false},
	{description = "Enabled", data = true},
}
configuration_options =
{
	Breaker("Islands"),
	{
		name = "volcano",
		label = "Vulcanico",
        hover = "Volcano contents; This is actually a debug testing island directly from Shipwrecked.",
        options = options_enable,
		default = false,
	},
	{
		name = "sinkhole",
		label = "Cape Cavern",
        hover = "Cave Entrance; Also has a Rock Den for getting pets",
        options = options_enable,
		default = true,
	},
	{
		name = "beequeen",
		label = "Noble Bee Beach",
        hover = "Bee Queen",
        options = options_enable,
		default = true,
	},
	{
        name = "dragonfly",
        label = "Dragonflyland",
        hover = "Dragonfly; Remember to enable her in the customisation options!",
        options = {
            {description = "Disabled", data = 0, hover = "Dragonfly will be disabled."},
            {description = "Desert", data = 1, hover = "Dragonfly will be on a desert island with RoG climate."},
            {description = "Volcanic", data = 2, hover = "Dragonfly will be on a volcano themed island and will drop obsidian."},
        },
        default = 1,
    },
	{
		name = "oasis",
		label = "Sandstorm Oasis",
        hover = "Antlion",
        options = options_enable,
		default = true,
	},
	{
		name = "moon1",
		label = "Luna Island",
        hover = "From the Turn Of Tides update",
        options = options_enable,
		default = false,
	},
	Breaker("Contents"),
	{	
		name = "Glommer",
		label = "Glommer Buddy!",
		hover = "Glommer's statue on the cave island.",
		options =	{
						{description = "Disabled", data = 0, hover = "It's too dangerous glommer!"},
						{description = "Enabled", data = 1, hover = "Look glommer buddy, waves!"},
					},
		default = 0,
	},
	{	
		name = "Walrus",
		label = "Tropical Walrus",
		hover = "Walrus camp on the cave island.",
		options =	{
						{description = "Disabled", data = 0, hover = "Pray to RNGesus when you gamble those dubloons."},
						{description = "Enabled", data = 1, hover = "A tad less RNG heavy."},
					},
		default = 0,
	},
	{
		name = "AltEndtable",
		label = "End Table Tweak",
		hover = "Tweaked end table recipe for shipwrecked worlds",
        options =	{
						{description = "Disabled", data = false, hover = "Recipe will remain vanilla."},
						{description = "Enabled", data = true, hover = "Will now take 2 Limestone, 2 Boards and 2 Snakeskin Rug"},
					},
		default = true,
	},
	{
		name = "AltSeawreath",
		label = "Seawreath Tweak",
		hover = "Alternate seawreath recipe(Return of Them beta only!)",
        options =	{
						{description = "Disabled", data = false, hover = "Keep the vanilla recipe of 12 kelp fronds."},
						{description = "Enabled", data = true, hover = "Change the recipe to 12 seaweed."},
					},
		default = false,
	},
	{
		name = "AltFloralshirt",
		label = "Floral Shirt Tweak",
		hover = "Use the floral shirt recipe from singleplayer shipwrecked?",
        options =	{
						{description = "Disabled", data = false, hover = "Keep the cactus flower requirement."},
						{description = "Enabled", data = true, hover = "Cactus flower requirement replaced with petals."},
					},
		default = false,
	},
	{
		name = "AltHoundius",
		label = "Houndius Tweak",
		hover = "Want the houndius in your shipwrecked world?",
        options =	{
						{description = "Disabled", data = false, hover = "Tooth traps are better anyway."},
						{description = "Enabled", data = true, hover = "Tiger shark eyes are great substitutes for deerclops eyes."},
					},
		default = false,
	},
	-- {
		-- name = "codename",
		-- label = "Fancy Name",
        -- hover = "This sentence explains the option in greater detail.",
		-- options =
		-- {
			-- {description = "Disabled", data = false},
			-- {description = "Enabled", data = true},
		-- },
		-- default = false,
	-- },
}