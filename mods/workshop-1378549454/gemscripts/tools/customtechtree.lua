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
 
--keep a separate list of all the custom techs for use with techname_bonus
--more effecient than itterating through all the techs... just go through the custom ones...
local CustomTechTree = {}

local CUSTOM_TECH_BONUS = {}
local CUSTOM_TECH_KEY = {}
local CUSTOM_TECH_HINT = {}
 
local TechTree = require("techtree")

local function __techindex(t, k)
    local val = rawget(t, k)
    return (type(val) == "number" and val >= 1 and val) or 0
end

local function __technewindex(t, k, v)
    rawset(t, k, ((type(v) == "number" and v >= 1 and v) or nil))
end

local _Create = TechTree.Create
TechTree.Create = function(t)
    return setmetatable(t or {}, {__index = __techindex, __newindex = __technewindex})
end
 
--sadly because of when this is exectued we have to redo any and all call's to TechTree.Create
TECH.NONE = TechTree.Create()

for k, v in pairs(AllRecipes) do
    v.level = TechTree.Create(v.level)
end

for k, v in pairs(TUNING.PROTOTYPER_TREES) do
    v = TechTree.Create(v)
end

function CustomTechTree.AddNewTechType(techtype)
    --add tech to all tech list
    TechTree.AVAILABLE_TECH[#TechTree.AVAILABLE_TECH + 1] = techtype
    --add to this list for custom bonus proccessing
    CUSTOM_TECH_BONUS[#CUSTOM_TECH_BONUS + 1] = techtype
end
 
function CustomTechTree.AddTechHint(Tech,NewHint)
    --adding the tech that you want to one list and the hint to the next
    CUSTOM_TECH_KEY[#CUSTOM_TECH_KEY + 1] = Tech
    CUSTOM_TECH_HINT[#CUSTOM_TECH_HINT + 1] = NewHint
end
 
function CustomTechTree.AddPrototyperTree(TreeName,Tech)
    --adds a prototyper tree to TUNING.PROTOTYPER_TREES how it should be done
    --note: this is only for what the prototyper machine should output
    --creating a tech for recipes can be done by doing: TECH.TECHNAME = {TECHTYPE = 1, OTHERTECHTYPE = 3}
    TUNING.PROTOTYPER_TREES[TreeName] = TechTree.Create(Tech)
end

if TheNet:GetIsServer() then
    GEMENV.AddComponentPostInit("builder", function(builder)
        local _PushEvent = builder.inst.PushEvent
        function builder.inst:PushEvent(event, data, ...)
            if event == "techtreechange" then
                if builder.current_prototyper ~= nil then
                    --it handles our bonus correctly if it doesnt have a prototyper machine found...
                    for i, v in ipairs(CUSTOM_TECH_BONUS) do
                        builder.accessible_tech_trees[v] = builder.accessible_tech_trees[v] + (builder[string.lower(v).."_bonus"] or 0)
                    end
                end
                _PushEvent(self, event, {level = builder.accessible_tech_trees})
            else
                _PushEvent(self, event, data, ...)
            end
        end
    end)


    --I shouldn't need to do this, BUT if someone messes with the TUNING.PROTOTYPER_TREES, this must happen.
    local Prototyper = require("components/prototyper")
    local _GetTechTrees = Prototyper.GetTechTrees
    function Prototyper:GetTechTrees(...)
        return TechTree.Create(_GetTechTrees(self, ...))
    end
end
 
local function CompareTech(recipetech,createdtech)
    --comparine two tech trees
    if recipetech == createdtech then return true end --in the likely case both refer to the global TECH def, speed things up
    for i, v in ipairs(TechTree.AVAILABLE_TECH) do
        if (recipetech[v] or 0) == (createdtech[v] or 0) then
            return false
        end
    end
    return true
end

local RecipePopup = require("widgets/recipepopup")
local TEASER_TEXT_WIDTH = 64 * 3 + 24
 
local _Refresh = RecipePopup.Refresh
function RecipePopup:Refresh()
    _Refresh(self)
    if self.teaser ~= nil and self.teaser:IsVisible() and (self.teaser:GetString() == STRINGS.UI.CRAFTING.CANTRESEARCH or self.teaser:GetString() == "") then
            for i, v in ipairs(CUSTOM_TECH_KEY) do
                --compare each custom tech to the recipe's tech if it matches exactly then its the same tech and can have a custom hint
            if CompareTech(self.recipe.level,v) then
                --set custom hint
                self.teaser:SetMultilineTruncatedString(CUSTOM_TECH_HINT[i], 3, TEASER_TEXT_WIDTH, 38, true)
                    break
                end
            end
        end
    end
 
GEMENV.AddPrefabPostInit("player_classified", function(inst)
    for i, v in ipairs(CUSTOM_TECH_BONUS) do
        inst[string.lower(v) .. "bonus"] = net_tinybyte(inst.GUID, "builder." .. string.lower(v) .. "_bonus")
    end
end)
 
return CustomTechTree