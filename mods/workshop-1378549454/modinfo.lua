--[[
Copyright (C) 2018 Zarklord

This file is part of Gem Core.

The source code of this program is shared under the RECEX
SHARED SOURCE LICENSE (version 1.0).
The source code is shared for referrence and academic purposes
with the hope that people can read and learn from it. This is not
Free and Open Source software, and code is not redistributable
without permission of the author. Read the RECEX SHARED
SOURCE LICENSE for details 
The source codes does not come with any warranty including
the implied warranty of merchandise. 
You should have received a copy of the RECEX SHARED SOURCE
LICENSE in the form of a LICENSE file in the root of the source
directory. If not, please refer to 
<https://raw.githubusercontent.com/Recex/Licenses/master/SharedSourceLicense/LICENSE.txt>
]]

name = "[API] Gem Core"
version = "4.1.0"
credits = "\n\nCredits:\nZarklord - For creating this API.\nFidooop - For ensuring things were done right.\nRezecib - For his wonderful upvalue hacker.\nNSimplex - For memspikefix."
description = "Version: "..version.."\nLibrary of powerful modding tools for mod developers.\n\nVisit https://gitlab.com/DSTAPIS/GemCore/wikis/home for API info"..credits
author = "Zarklord"

restart_required = false

dst_compatible = true

api_version_dst = 10

--Custom field that lets the mods detect this mod more easily.
GemCore = true

folder_name = folder_name or "workshop-"
if not folder_name:find("workshop-") then
    name = name.." - GitLab Version"
    version = version.."G"
    GemCoreGitLab = true
end

--largest number for priority possible
priority = 2147483647
	
icon_atlas = "gemcore.xml"
icon = "gemcore.tex"

all_clients_require_mod = true
client_only_mod = false


server_filter_tags = 
{ 
    "gemcore",
}

configuration_options = {}
