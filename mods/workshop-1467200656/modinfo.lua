-- Mod Name
name = "Island Adventures - Assets"

-- Mod Authors
author = "Atlantic Aristocracy"

-- Mod Version
version = "0.16"

-- Mod Description
description = "This mod contains sound and animation files for \"Island Adventures\". It does nothing on its own."

description = description .. "\n\nVersion: " .. version

-- Custom field that lets the core mod detect this mod more easily
IslandAdventuresAssets = true

folder_name = folder_name or "workshop-"
if not folder_name:find("workshop-") then
    name = " " .. name .. " - GitLab Ver."
    description = description .. "\n\nRemember to manually update! The version number does NOT increase with every gitlab update."
    IslandAdventuresAssetsGitLab = true
end

-- In-game link to a thread or file download on the Klei Entertainment Forums
forumthread = "/topic/72797-island-adventures-a-shipwrecked-port"

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
    -- "island_adventures",
}

-- Preview image
icon_atlas = "ia-icon.xml"
icon = "ia-icon.tex"
