local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local function MakeNormal(self)
    self.inst:RemoveTag("fertilizer_volcanic")
    self.inst:RemoveTag("fertilizer_oceanic")
end

local function MakeVolcanic(self)
    self.inst:AddTag("fertilizer_volcanic")
    self.inst:RemoveTag("fertilizer_oceanic")
end

local function MakeOceanic(self)
    self.inst:RemoveTag("fertilizer_volcanic")
    self.inst:AddTag("fertilizer_oceanic")
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("fertilizer", function(cmp)


cmp.MakeNormal = MakeNormal
cmp.MakeVolcanic = MakeVolcanic
cmp.MakeOceanic = MakeOceanic


end)
