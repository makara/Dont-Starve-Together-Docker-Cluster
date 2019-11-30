local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

--Zarklord: blindly replace this function, since idk what else to do...
local function CanBuildAtPoint(self, pt, recipe, rot)
    return TheWorld.Map:CanDeployRecipeAtPoint(pt, recipe, rot, self.inst)
end

local function SetIsJellyBrainHat(self, isjellybrainhat)
    if self.classified ~= nil then
        self.classified.isjellybrainhat:set(isjellybrainhat)
    end
end

local _KnowsRecipe
local function KnowsRecipe(self, recipename, ...)
    if self.inst.components.builder ~= nil then
        return _KnowsRecipe(self, recipename, ...)
    elseif self.classified ~= nil then
        local knows = _KnowsRecipe(self, recipename, ...)
        if not knows and self.classified.isjellybrainhat:value() then
            local recipe = GetValidRecipe(recipename)
            if recipe ~= nil then
                local valid_tech = true
                for techname, level in pairs(recipe.level) do
                    if level ~= 0 and (TECH.LOST[techname] or 0) == 0 then
                        valid_tech = false
                        break
                    end
                end
                for i, v in ipairs(recipe.tech_ingredients) do
                    if not self:HasTechIngredient(v) then
                        valid_tech = false
                        break
                    end
                end
                knows = valid_tech and (recipe.builder_tag == nil or self.inst:HasTag(recipe.builder_tag))
            end
        end
        return knows
    end
end


----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddClassPostConstruct("components/builder_replica", function(cmp)


cmp.CanBuildAtPoint = CanBuildAtPoint
cmp.SetIsJellyBrainHat = SetIsJellyBrainHat
_KnowsRecipe = cmp.KnowsRecipe
cmp.KnowsRecipe = KnowsRecipe


end)
