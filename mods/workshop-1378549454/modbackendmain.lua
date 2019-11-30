--[[
Copyright (C) 2018, 2019 Zarklord

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
local _G = GLOBAL

modimport("gemscripts/gemrun")
_G.gemrun = gemrun
local MakeGemFunction, DeleteGemFunction = gemrun("gemfunctionmanager")

_G.GEMENV = env

IsTheFrontEnd = false
_G.IsTheFrontEnd = false

_G.UpvalueHacker = gemrun("tools/upvaluehacker")
_G.LocalVariableHacker = gemrun("tools/localvariablehacker")
_G.bit = gemrun("bit")
_G.DebugPrint = gemrun("tools/misc").Global.DebugPrint

gemrun("modconfigmanager")
gemrun("mathutils")
gemrun("tableutils")

gemrun("hooks")

gemrun("tools/dynamictilemanager")
gemrun("tools/originaltiles")
gemrun("tools/worldgenoptions")

modimport("gemscripts/legacy_modbackendmain")

if _G.rawget(_G, "WORLDGEN_MAIN") == 1 then
    gemrun("worldseedhelper")
    
    MakeGemFunction("extendenvironment", function(functionname, env, ...)
        local gemrun = gemrun
        _G.setfenv(1, env)
        UpvalueHacker = gemrun("tools/upvaluehacker")
        LocalVariableHacker = gemrun("tools/localvariablehacker")
        bit = gemrun("bit")
        DebugPrint = gemrun("tools/misc").Global.DebugPrint
        DynamicTileManager = gemrun("tools/dynamictilemanager")
        if modname then
            function GetModModConfigData(optionname, modmodname, ...)
                return _G.GetModModConfigData(optionname, modmodname, modname, ...)
            end
        else
            GetModModConfigData = _G.GetModModConfigData
        end
    end, true)
end

--after initializing, run beta fixes.
if CurrentRelease.GreaterOrEqualTo("R09_ROT_SALTYDOG") then
    gemrun("betafixes_backend")
end

local _InitializeModMain = _G.ModManager.InitializeModMain
function _G.ModManager:InitializeModMain(_modname, env, mainfile, ...)
    if mainfile == "modworldgenmain.lua" then
        env.IsTheFrontEnd = false
    end
    if mainfile == "modmain.lua" and _modname == modname then
        MakeGemFunction("gemfunctionmanager", function(functionname, ...) return MakeGemFunction, DeleteGemFunction end)
    end
    return _InitializeModMain(self, _modname, env, mainfile, ...)
end

DeleteGemFunction("gemfunctionmanager")