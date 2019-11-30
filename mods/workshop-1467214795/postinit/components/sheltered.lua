local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local _OnUpdate
local function OnUpdate(self, dt)
	_OnUpdate(self, dt)
	--handle palmleaf huts
    local x, y, z = self.inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 2, { "dryshelter" }, { "FX", "NOCLICK", "DECOR", "INLIMBO", "stump", "burnt" })
	if #ents > 0 then
		self:SetSheltered(true, true)
	end
end

local _SetSheltered
local function SetSheltered(self, shelter, dryshelter)
	--exception for the announcement
    if shelter and self.presheltered
    and not self.sheltered and self.inst.replica.sheltered:IsSheltered()
	and IsInIAClimate(self.inst) then
        self.sheltered = true
        self.inst:PushEvent("sheltered", true)
        if self.announcecooldown <= 0 and (TheWorld.state.islandisraining or TheWorld.state.islandtemperature >= TUNING.OVERHEAT_TEMP - 5) then
            self.inst.components.talker:Say(GetString(self.inst, "ANNOUNCE_SHELTER"))
            self.announcecooldown = TUNING.TOTAL_DAY_TIME
        end
	else
		_SetSheltered(self, shelter)
	end
	--handle palmleaf huts
    if dryshelter and not self.waterproofness_nodryshelter then
	-- and self.inst.replica.sheltered and self.inst.replica.sheltered:IsSheltered()
		self.waterproofness_nodryshelter = self.waterproofness
		self.waterproofness = TUNING.WATERPROOFNESS_ABSOLUTE
	elseif self.waterproofness_nodryshelter then -- only do this once so we don't interfere with dynamic char stats more than necessary
		self.waterproofness = self.waterproofness_nodryshelter
		self.waterproofness_nodryshelter = nil
	end
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("sheltered", function(cmp)


_OnUpdate = cmp.OnUpdate
cmp.OnUpdate = OnUpdate
_SetSheltered = cmp.SetSheltered
cmp.SetSheltered = SetSheltered


end)
