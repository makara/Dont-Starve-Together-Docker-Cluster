local MakeAssetLoader = require("prefabs/assetloader")

local ASSETPREFABPREFIX = "GEMCOREASSETLOADER"

local frontend_assets_prefabs = {}
local frontend_assets_prefabnames = {}

local MakeGemFunction = gemrun("gemfunctionmanager")

local function unloadassets(modname)
    if modname == nil then
        TheSim:UnloadPrefabs(frontend_assets_prefabs)
        TheSim:UnregisterPrefabs(frontend_assets_prefabnames)
        frontend_assets_prefabs = {}
        frontend_assets_prefabnames = {}
    else
        local idx = table.reverselookup(frontend_assets_prefabnames, ASSETPREFABPREFIX..modname)
        if idx ~= nil then
            TheSim:UnloadPrefabs({frontend_assets_prefabs[idx]})
            table.remove(frontend_assets_prefabs, idx)
            TheSim:UnregisterPrefabs({frontend_assets_prefabnames[idx]})
            table.remove(frontend_assets_prefabnames, idx)
        end
    end
end

local function loadassets(modname, assets)
    if assets then
        assert(KnownModIndex:DoesModExistAnyVersion(modname), "modname "..modname.." must refer to a valid mod!")
        local prefabname = ASSETPREFABPREFIX..modname
        for i, v in ipairs(assets) do
            if softresolvefilepath(v.file, nil, MODS_ROOT..modname.."/") ~= nil then
                resolvefilepath(v.file, nil, MODS_ROOT..modname.."/")
            end
        end
        local prefab = MakeAssetLoader(prefabname, assets)
        frontend_assets_prefabs[#frontend_assets_prefabs + 1] = prefab
        frontend_assets_prefabnames[#frontend_assets_prefabnames + 1] = prefabname
        RegisterPrefabs(prefab)
        TheSim:LoadPrefabs({prefabname})
    end
end

gemrun("unloadmodany", unloadassets)
MakeGemFunction("unloadassets", function(functionname, modname, ...) unloadassets(modname) end, true)
MakeGemFunction("loadassets", function(functionname, modname, assets, ...) loadassets(modname, assets) end, true)