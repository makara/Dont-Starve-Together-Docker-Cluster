local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

IAENV.AddComponentPostInit("builder", function(cmp)


local function onjellybrainhat(self, jellybrainhat)
    self.inst.replica.builder:SetIsJellyBrainHat(jellybrainhat)
end

addsetter(cmp, "jellybrainhat", onjellybrainhat)

cmp.jellybrainhat = false

--Zarklord: blindly replace this function, since idk what else to do...
function cmp:MakeRecipeAtPoint(recipe, pt, rot, skin)
    if recipe.placer ~= nil and
        self:KnowsRecipe(recipe.name) and
        self:IsBuildBuffered(recipe.name) and
        TheWorld.Map:CanDeployRecipeAtPoint(pt, recipe, rot, self.inst) then
        self:MakeRecipe(recipe, pt, rot, skin)
    end
end

local _KnowsRecipe = cmp.KnowsRecipe
function cmp:KnowsRecipe(recname, ...)
    local knows = _KnowsRecipe(self, recname, ...)
    if not knows and self.jellybrainhat then
        local recipe = GetValidRecipe(recname)
        if recipe == nil then
            return false
        end
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
    return knows
end

local _BufferBuild = cmp.BufferBuild
function cmp:BufferBuild(recname, ...)
    local recipe = GetValidRecipe(recname)
    local shouldevent = recipe ~= nil and recipe.placer ~= nil and not self:IsBuildBuffered(recname) and self:CanBuild(recname)
    _BufferBuild(self, recname, ...)
    if shouldevent then
        self.inst:PushEvent("bufferbuild", {recipe = recipe})
    end
end

local _isloading = false

local _AddRecipe = cmp.AddRecipe
function cmp:AddRecipe(recname, ...)
    if not self.jellybrainhat or _isloading then
        return _AddRecipe(self, recname, ...)
    end
    return
end

local _OnLoad = cmp.OnLoad
function cmp:OnLoad(data, ...)
    _isloading = true
    _OnLoad(self, data, ...)
    _isloading = false
end

local _OnUpdate = cmp.OnUpdate
function cmp:OnUpdate(dt, ...)
    _OnUpdate(self, dt, ...)
    self:EvaluateAutoFixers()
end

function cmp:EvaluateAutoFixers()
    local pos = self.inst:GetPosition()
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, TUNING.RESEARCH_MACHINE_DIST, { "autofixer" }, self.exclude_tags)

    local old_fixer = self.current_fixer
    self.current_fixer = nil

    local fixer_active = false
    for k, v in pairs(ents) do
        if v.components.autofixer then
            if not fixer_active and v.components.autofixer:CanAutoFixUser(self.inst) then
                --activate the first machine in the list. This will be the one you're closest to.
                v.components.autofixer:TurnOn(self.inst)
                fixer_active = true
                self.current_fixer = v

            else
                --you've already activated a machine. Turn all the other machines off.
                v.components.autofixer:TurnOff(self.inst)
            end
        end
    end

    if old_fixer ~= nil and
        old_fixer ~= self.current_fixer and
        old_fixer.components.autofixer ~= nil and
        old_fixer.entity:IsValid() then
        old_fixer.components.autofixer:TurnOff(self.inst)
    end
end

-- ignore flooded prototypers
table.insert(cmp.exclude_tags, "flooded")


end)
