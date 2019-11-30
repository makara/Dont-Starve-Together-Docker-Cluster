local require = GLOBAL.require

if GetModConfigData("devmode") then
	GLOBAL.CHEATS_ENABLED = true
	GLOBAL.require( 'debugkeys' )
end

-- Dependencies are imported in modworldgenmain.lua

-- Crash if IA assets is not enabled
local childmods_missing = true
for i,v in pairs(GLOBAL.KnownModIndex.savedata.known_mods) do
	if v and v.modinfo and v.modinfo.IslandAdventuresAssets
	and (GLOBAL.KnownModIndex:IsModEnabled(i) or GLOBAL.KnownModIndex:IsModTempEnabled(i) or GLOBAL.KnownModIndex:IsModForceEnabled(i)) then
		-- GLOBAL.KnownModIndex:Enable(i)
		childmods_missing = false
	end
end
if childmods_missing then
	AddGamePostInit(function()
		local txttitle = "FATAL: Required Mod MISSING"
		local txtbody = "Please make sure you have \"Island Adventures - Assets\" installed and enabled."
		GLOBAL.TheFrontEnd:PushScreen(GLOBAL.require("screens/redux/popupdialog")(
				txttitle, txtbody, 
                {{text="OK", cb = function()
                    GLOBAL.error(txttitle .."\n".. txtbody)
                end}}))
	end)
	return
end


-- Import constants and data.

GLOBAL.IA_CONFIG = {
	-- Some of these may be treated as client-side, as indicated by the bool
	autodisembark = GetModConfigData("autodisembark"),
	dynamicmusic = GetModConfigData("dynamicmusic", true),
	locale = GetModConfigData("locale", true),
	droplootground = GetModConfigData("droplootground"),
	limestonerepair = GetModConfigData("limestonerepair"),
	tuningmodifiers = GetModConfigData("tuningmodifiers"),
	bossbalance = GetModConfigData("bossbalance"),
	oldwarly = GetModConfigData("oldwarly"),
	newplayerboats = GetModConfigData("newplayerboats"),
	allowprimeapebarrel = GetModConfigData("allowprimeapebarrel"),
	-- throttletime_flood = GetModConfigData("throttletime_flood"),
	scale_floodpuddles = GetModConfigData("scale_floodpuddles"),
	poisonenabled = true, --set in tuning_override_ia
}

-- modimport "main/strings"
modimport "main/assets"
modimport "main/fx"

-- Import the framework.

SetupGemCoreEnv()
modimport "libraries/tilestate"
modimport "libraries/dynamiczoom"
modimport "main/standardcomponents"


--------------------------------- Crafting ---------------------------------
-- Create the custom techtrees
CustomTechTree.AddNewTechType("WATER")
CustomTechTree.AddNewTechType("OBSIDIAN")

GLOBAL.TECH.WATER_TWO = {WATER = 2}
GLOBAL.TECH.OBSIDIAN_TWO = {OBSIDIAN = 2}

--this allows the jelly brain hat to give access to recipes using these tech.
GLOBAL.TECH.LOST.WATER = 10
GLOBAL.TECH.LOST.OBSIDIAN = 10

CustomTechTree.AddPrototyperTree("SEALAB", {SCIENCE = 2, WATER = 2})
CustomTechTree.AddPrototyperTree("OBSIDIAN_BENCH", {OBSIDIAN = 2})

if TUNING.PROTOTYPER_TREES.ALCHEMYMACHINE then
	TUNING.PROTOTYPER_TREES.ALCHEMYMACHINE.WATER = 1
end

-- Create the recipe tabs
if GLOBAL.RECIPETABS.SEAFARING then
--reskin the SEAFARING tab
GLOBAL.RECIPETABS.SEAFARING.str="NAUTICAL"
GLOBAL.RECIPETABS.SEAFARING.sort=1.6
GLOBAL.RECIPETABS.SEAFARING.icon_atlas="images/ia_hud.xml"
GLOBAL.RECIPETABS.SEAFARING.icon="tab_nautical.tex"
else
AddRecipeTab("NAUTICAL", 1.6, "images/ia_hud.xml", "tab_nautical.tex")
end
AddRecipeTab("OBSIDIAN", 10, "images/ia_hud.xml", "tab_obsidian.tex", nil, true)

function GLOBAL.AquaticRecipe(name, distance)
    if GLOBAL.AllRecipes[name] then
        GLOBAL.AllRecipes[name].aquatic = true
        GLOBAL.AllRecipes[name].distance = distance -- boats use distance of 4
    end
end
--------------------------------------------------------------------


-- Import various scripts
modimport "main/util"
modimport "main/commands"
modimport "main/recipes"
modimport "main/cooking"
modimport "main/containers"
modimport "main/actions"
modimport "main/postinit"
modimport "main/tuning"
modimport "main/tuning_override_ia"
modimport "main/treasurehunt"

--Extra Equip Slots
--Zarklord: god i love metatables, this is really a perfect solution cause this function is only called for undefined values so if EES is running BACK NECK and or WAIST is defined and we dont execute this metatable.
GLOBAL.setmetatable(GLOBAL.EQUIPSLOTS, {__index = function(t,k)
    if k == "BACK" or k == "NECK" then
        return GLOBAL.rawget(t, "BODY")
    elseif k == "WAIST" then
        return GLOBAL.rawget(t, "HANDS")
    end
    return GLOBAL.rawget(t, k)
end})

local ES = require("equipslotutil")

local _ESInitialize = ES.Initialize
local BOATEQUIPSLOT_NAMES, BOATEQUIPSLOT_IDS
function ES.Initialize()
    _ESInitialize()
    GLOBAL.assert(BOATEQUIPSLOT_NAMES == nil and BOATEQUIPSLOT_IDS == nil, "Equip slots already initialized")

    BOATEQUIPSLOT_NAMES = {}
    for k, v in pairs(GLOBAL.BOATEQUIPSLOTS) do
        table.insert(BOATEQUIPSLOT_NAMES, v)
    end

    GLOBAL.assert(#BOATEQUIPSLOT_NAMES <= 63, "Too many equip slots!")

    BOATEQUIPSLOT_IDS = table.invert(BOATEQUIPSLOT_NAMES)
end

-- These are meant for networking, and can be used in prefab or
-- component logic. They are not valid when modmain is loading.
function ES.BoatToID(eslot)
    return BOATEQUIPSLOT_IDS[eslot] or 0
end

function ES.BoatFromID(eslotid)
    return BOATEQUIPSLOT_NAMES[eslotid] or "INVALID"
end
local _ESToID = ES.ToID
function ES.ToID(eslot)
    return _ESToID(eslot) or 0
end

local _ESFromID = ES.FromID
function ES.FromID(eslotid)
    return _ESFromID(eslotid) or "INVALID"
end

function ES.BoatCount()
    return #BOATEQUIPSLOT_NAMES
end


-- Import strings only afterwards to reset API nonsense
modimport "main/strings"

CustomTechTree.AddTechHint(GLOBAL.TECH.WATER_TWO, GLOBAL.STRINGS.UI.CRAFTING.NEEDSEALAB)

SetSoundAlias("dontstarve/movement/ia_run_sand", "ia/movement/walk_sand")
SetSoundAlias("dontstarve/movement/ia_run_sand_small", "ia/movement/walk_sand_small")
SetSoundAlias("dontstarve/movement/ia_run_sand_large", "ia/movement/walk_sand_large")
SetSoundAlias("dontstarve/movement/ia_walk_sand", "ia/movement/walk_sand")
SetSoundAlias("dontstarve/movement/ia_walk_sand_small", "ia/movement/walk_sand_small")
SetSoundAlias("dontstarve/movement/ia_walk_sand_large", "ia/movement/walk_sand_large")

SetSoundAlias("dontstarve/movement/run_slate", "ia/movement/walk_slate")
SetSoundAlias("dontstarve/movement/run_slate_small", "ia/movement/walk_slate_small")
SetSoundAlias("dontstarve/movement/run_slate_large", "ia/movement/walk_slate_large")
SetSoundAlias("dontstarve/movement/walk_slate", "ia/movement/walk_slate")
SetSoundAlias("dontstarve/movement/walk_slate_small", "ia/movement/walk_slate_small")
SetSoundAlias("dontstarve/movement/walk_slate_large", "ia/movement/walk_slate_large")

--TODO, get the actual sounds, and replace these "placeholder sounds"
SetSoundAlias("dontstarve/movement/run_rock", "dontstarve/movement/run_dirt")
SetSoundAlias("dontstarve/movement/run_rock_small", "dontstarve/movement/run_dirt_small")
SetSoundAlias("dontstarve/movement/run_rock_large", "dontstarve/movement/run_dirt_large")
SetSoundAlias("dontstarve/movement/walk_rock", "dontstarve/movement/walk_dirt")
SetSoundAlias("dontstarve/movement/walk_rock_small", "dontstarve/movement/walk_dirt_small")
SetSoundAlias("dontstarve/movement/walk_rock_large", "dontstarve/movement/walk_dirt_large")

--fix item images in menu and on minisigns
GLOBAL.require("simutil")
local GetInventoryItemAtlas_old = GLOBAL.GetInventoryItemAtlas
local inventoryItemAtlasLookup = GLOBAL.UpvalueHacker.GetUpvalue(GLOBAL.GetInventoryItemAtlas, "inventoryItemAtlasLookup")
local ia_inventoryimages = GLOBAL.resolvefilepath("images/ia_inventoryimages.xml")
GLOBAL.GetInventoryItemAtlas = function(imagename)
	if inventoryItemAtlasLookup[imagename] then
		return inventoryItemAtlasLookup[imagename]
	end
	if GLOBAL.TheSim:AtlasContains(ia_inventoryimages, imagename) then
		inventoryItemAtlasLookup[imagename] = ia_inventoryimages
		return ia_inventoryimages
	end
	return GetInventoryItemAtlas_old(imagename)
end

-- Add mod character to mod character list. Also specify a gender. Possible genders are MALE, FEMALE, ROBOT, NEUTRAL, PLURAL, and ATTACK_HELICOPTER.
-- AddModCharacter("warly", "MALE")
--dumb fix because Klei is dumb and changed the way bigportraits work without adjusting the API
-- GLOBAL.PREFAB_SKINS["warly"] = {"warly_none"}
-- GLOBAL.PREFAB_SKINS_IDS["warly"] = {["warly_none"] = 1}

if GLOBAL.IA_CONFIG.oldwarly then
	--Warly announces his same old penalty
	GLOBAL.require("stringutil")
	local GetDescription_old = GLOBAL.GetDescription
	GLOBAL.GetDescription = function(inst, item, ...)
		local ret = GetDescription_old(inst, item, ...)
		if type(inst) == "table" and inst.components.foodmemory then
			local prefab = item and item.prefab
			if prefab then
				local stage = math.min(inst.components.foodmemory:GetMemoryCount(prefab), #GLOBAL.STRINGS.CHARACTERS.WARLY.WARN_SAME_OLD)
				if stage > 0 then
					ret = ret .."\n".. GLOBAL.STRINGS.CHARACTERS.WARLY.WARN_SAME_OLD[stage]
				end
			end
		end
		return ret
	end
end

--------------------------------- FLOOD ---------------------------------

GLOBAL.RegisterTileState("flood", false, "floodtile", 2.6, nil, nil, nil, .5, "flood")

------------------------------ Several Action Fixes -------------------------------------

-- Not really post-init compatible, sadly
GLOBAL.require('bufferedaction')
local _BufferedAction = GLOBAL.BufferedAction._ctor
GLOBAL.BufferedAction._ctor = function(self, doer, target, action, invobject, pos, recipe, distance, forced, rotation, ...)
    _BufferedAction(self, doer, target, action, invobject, pos, recipe, distance, forced, rotation, ...)
    if not self.distance and action then
        -- ATTACK action is kind of hacky
        if action == GLOBAL.ACTIONS.ATTACK and doer.replica.combat then
            self.distance = doer.replica.combat:GetAttackRangeWithWeapon()
        end
    else
        -- Correct BUILD distance if necessary
        local rec = GLOBAL.GetValidRecipe(recipe)
        if rec and rec.distance then
            self.distance = rec.distance
        end
    end
end

--------------------------------- Naughtiness ---------------------------------

local function GetDoyDoyNaughtiness()
    return GLOBAL.TheWorld.components.doydoyspawner:GetInnocenceValue()
end

AddNaughtinessFor("doydoy", GetDoyDoyNaughtiness)
AddNaughtinessFor("doydoybaby", GetDoyDoyNaughtiness)
AddNaughtinessFor("ballphin", 2)
AddNaughtinessFor("toucan", 2)
AddNaughtinessFor("parrot", 1)
AddNaughtinessFor("parrot_pirate", 6)
AddNaughtinessFor("seagull", 1)
AddNaughtinessFor("cormorant", 1)
AddNaughtinessFor("crab", 1)
AddNaughtinessFor("solofish", 2)
AddNaughtinessFor("swordfish", 4)
AddNaughtinessFor("whale_white", 6)
AddNaughtinessFor("whale_blue", 7)
AddNaughtinessFor("jellyfish_planted", 1)
AddNaughtinessFor("rainbowjellyfish_planted", 1)
AddNaughtinessFor("ox", 4)
AddNaughtinessFor("lobster", 2)
AddNaughtinessFor("primeape", 2)
AddNaughtinessFor("twister_seal", 50)

--------------------------------- Projectile Fix ---------------------------------

local function UpdateFloatable(inst)
	if inst.components.inventoryitem and not inst.components.inventoryitem:IsHeld() then
		local water = GLOBAL.IsOnWater(inst)
		--tell the component to refresh
		--this has a 1 tick delay to the anim, so don't do it if the water floating didn't change
		if not water or not (inst.components.floater and inst.components.floater:IsFloating()) then
			inst.components.inventoryitem:SetLanded(false,true)
		end
	end
end

local _Launch = GLOBAL.Launch
function GLOBAL.Launch(inst, ...)
    _Launch(inst, ...)
    if inst and inst:IsValid() then
		inst:DoTaskInTime(.6, UpdateFloatable)
	end
end
local _Launch2 = GLOBAL.Launch2
function GLOBAL.Launch2(inst, ...)
    _Launch2(inst, ...)
    if inst and inst:IsValid() then
		inst:DoTaskInTime(.6, UpdateFloatable)
	end
end
local _LaunchAt = GLOBAL.LaunchAt
function GLOBAL.LaunchAt(inst, ...)
	_LaunchAt(inst, ...)
    if inst and inst:IsValid() then
		inst:DoTaskInTime(.6, UpdateFloatable)
	end
end
-- end

------------------------------ SW Replicatable Components ------------------------------------------------------------

AddReplicableComponent("geyserfx")
AddReplicableComponent("mapwrapper")
AddReplicableComponent("sailable")
AddReplicableComponent("sailor")
AddReplicableComponent("boathealth")
AddReplicableComponent("boatcontainer")

AddSpoofedReplicableComponent("boatcontainer", "container")

------------------------------ Replicatable Components ---------------------------------------

local function printinvalid(rpcname, player)
    print(string.format("Invalid %s RPC from (%s) %s", rpcname, player.userid or "", player.name or ""))

    --This event is for MODs that want to handle players sending invalid rpcs
    GLOBAL.TheWorld:PushEvent("invalidrpc", { player = player, rpcname = rpcname })

    if GLOBAL.BRANCH == "dev" then
        --Internal testing
        assert(false, string.format("Invalid %s RPC from (%s) %s", rpcname, player.userid or "", player.name or ""))
    end
end

AddModRPCHandler("Island Adventure", "ForceUpdateFacing", function(player, direction)
    --print("Received ForceUpdateFacing request...")
    player.Transform:SetRotation(direction)
    player.components.sailor:AlignBoat()
    if player.player_classified then 
        player.player_classified.facingsynced:set_local(true)
        player.player_classified.facingsynced:set(true)
    end
end)

AddModRPCHandler("Island Adventure", "ClientRequestDisembark", function(player)
    player:PushEvent("hitcoastline")
end)

AddModRPCHandler("Island Adventure", "BoatEquipActiveItem", function(player, container)
    if container ~= nil then
        container.components.container:BoatEquipActiveItem()
    end
end)

AddModRPCHandler("Island Adventure", "SwapBoatEquipWithActiveItem", function(player, container)
    if container ~= nil then
        container.components.container:SwapBoatEquipWithActiveItem()
    end
end)

AddModRPCHandler("Island Adventure", "TakeActiveItemFromBoatEquipSlot", function(player, eslot, container)
    if not GLOBAL.checknumber(eslot) then
        printinvalid("TakeActiveItemFromBoatEquipSlot", player)
        return
    end
    if container ~= nil then
        container.components.container:TakeActiveItemFromBoatEquipSlotID(eslot)
    end
end)
