-- Mod Name
name = "Island Adventures"

-- Mod Authors
author = "Atlantic Aristocracy"

-- Mod Version
version = "0.7.13"
version_title = "Monsoon Tycoon (Open Beta)"

-- Mod Description
description = "Embark on a journey across the ocean together, off shore from the mainland and out in search of exotic materials! Island Adventures brings the seas of Don't Starve: Shipwrecked to you!\n\nShould you encounter a problem, please tell us everything about the problem so we can repair things!"

description = description .. "\n\nVersion: " .. version .. "\n\"" .. version_title .. "\""

-- In-game link to a thread or file download on the Klei Entertainment Forums
forumthread = "/topic/95080-island-adventures-the-shipwrecked-port/"

IslandAdventures = true

folder_name = folder_name or "workshop-"
if not folder_name:find("workshop-") then
	name = " " .. name .. " - GitLab Ver."
	description = description .. "\n\nRemember to manually update! The version number does NOT increase with every gitlab update."
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
priority = 2

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
    "island_adventures",
	"island adventures",
	"island",
	"adventures",
	"shipwrecked",
}

-- Preview image
icon_atlas = "ia-icon.xml"
icon = "ia-icon.tex"


-- Thanks to the Gorge Extender by CunningFox for making me aware of this being possible -M
local emptyoptions = {{description="", data=false}}
local function Breaker(title, hover)
	return {
		name=title,
		hover=hover, --hover does not work, as this item cannot be hovered
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
	Breaker("Tweaks & Changes", "Enable these to permit several small changes to how the game works."),
    {
        name = "autodisembark",
        label   = "Auto-Disembark",
        hover   = "When hitting the coast, you automatically jump out of your boat. More challenging than useful.",
        options = options_enable,
        default = false,
    },
    {
        name = "droplootground", --could be extended to other loot too
        label   = "Drop Hacked Bamboo",
        hover   = "Hacking bamboo or vines does not give the loot directly to the hacker, instead drops it on the floor.",
        options = options_enable,
        default = true,
    },
	{
		name = "limestonerepair",
		label   = "Limestone Repairs",
        hover	= "Coral and Limestone can be used to repair Limestone Walls and Sea Walls.",
        options = options_enable,
		default = true,
	},
	{
		name = "tuningmodifiers",
		label = "Combat Modifiers",
		hover = "Monsters have more health, bosses deal less damage, and armour breaks faster. Klei decided that, we're just playing along.",
		options = options_enable,
		default = true,
	},
	{
		name = "bossbalance",
		label   = "Tigershark Buff",
        hover	= "Tigershark's laughable attack range gets increased, making it a dangerous foe.",
        options = options_enable,
		default = true,
	},
	{
		name = "oldwarly",
		label   = "Pre-Official Warly",
        hover	= "This mod had Warly before he was announced as an official DST character. Use this option to restore the IA Warly.",
        options = options_enable,
		default = false,
	},
	{
		name = "newplayerboats",
		label = "Rafts for New Players",
        hover = "Newly spawned players get given a pre-crafted Log Raft to leave their starting island on.",
        options = options_enable,
		default = false,
	},

	Breaker("Misc."),
    {
        name = "locale",
        label = "Force Translation",
        hover = "Select a translation to enable it regardless of language packs.",
        options = 
		{
			{description = "None", data = false},
			{description = "Deutsch", data = "de"},
			{description = "Español", data = "es"},
			{description = "Français", data = "fr"},
			{description = "Italiano", data = "it"},
			{description = "한국어", data = "ko"},
			{description = "Polski", data = "pl"},
			{description = "Português", data = "pt"},
			{description = "Русский", data = "ru"},
			{description = "中文 (simplified)", data = "sc"},
			{description = "中文 (traditional)", data = "tc"},
		},
        default = false,
    },
    {
        name = "dynamicmusic",
        label   = "Dynamic Music",
        hover   = "If you have problems using IA with other Music Mods, disable this. The unique Combat and Work music will not play.",
        options = options_enable,
        default = true,
    },
	{
		name = "devmode",
		label   = "Dev Mode",
        hover	= "Enable this to turn your keyboard into a minefield of crazy debug hotkeys. (Only use if you know what you are doing!)",
		options = options_enable,
		default = false,
	},
	{
		name = "allowprimeapebarrel",
		label   = "Prime Ape Barrel",
        hover	= "If your game crashes without a message when loading a savefile, try disabling this. IF THIS HELPS, INFORM US IMMEDIATELY. Thanks!",
        options = options_enable,
		default = true,
	},
	{
		name = "scale_floodpuddles",
		label   = "Flood Scale",
        hover	= "If your server suffers network lag-spikes in Monsoon, decrease this number!",
        options = {
			{description = " 1%", data = 0.01, hover = "Puddles will not grow at all."},
			{description = "20%", data = 0.2},
			{description = "40%", data = 0.4},
			{description = "60%", data = 0.6},
			{description = "80%", data = 0.8},
			{description = "100%", data = 1.0, hover = "The default scale. True to Shipwrecked, but might cause intense lagspikes."},
		},
		default = 0.4,
	},
	-- {
		-- name = "codename",
		-- label   = "Fancy Name",
        -- hover	= "This sentence explains the option in greater detail.",
		-- options =
		-- {
			-- {description = "Disabled", data = false},
			-- {description = "Enabled", data = true},
		-- },
		-- default = false,
	-- },
}