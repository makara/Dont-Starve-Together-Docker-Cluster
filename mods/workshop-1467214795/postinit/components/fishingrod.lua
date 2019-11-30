local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

--completely override to get rid of equippable condition
local function OnUpdate(self)
	if self:IsFishing() then
		if not self.fisherman:IsValid()
		or (not self.fisherman.sg:HasStateTag("fishing") and not self.fisherman.sg:HasStateTag("catchfish") )
		or (self.inst.components.equippable and not self.inst.components.equippable.isequipped) then
            self:StopFishing()
		end
	end
end

local _Collect
local function Collect(self)

    if self.caughtfish and self.fisherman and self.fisherman:GetIsOnWater() then 
		--print("bargle, I'm boating!")

        if self.caughtfish.Physics ~= nil then
            self.caughtfish.Physics:SetActive(true)
        end
        self.caughtfish.entity:Show()
        if self.caughtfish.DynamicShadow ~= nil then
            self.caughtfish.DynamicShadow:Enable(true)
        end
		-- print("CAUGHT FISH",self.caughtfish,self.caughtfish.components.inventoryitem)
		self.fisherman.components.inventory:GiveItem(self.caughtfish, nil, self.fisherman:GetPosition())
		
        self.caughtfish.persists = true
        self.inst:PushEvent("fishingcollect", {fish = self.caughtfish} )
        self.fisherman:PushEvent("fishingcollect", {fish = self.caughtfish} )
        self:StopFishing()
    else
		return _Collect(self)
	end
end

local _StartFishing
local function StartFishing(self, target, fisherman, ...)
	_StartFishing(self, target, fisherman, ...)
    if target and target.components.workable
	and target.components.workable:GetWorkAction() == ACTIONS.FISH
	and target.components.workable:CanBeWorked() then
        self.target = target
        self.fisherman = fisherman
        -- self.inst:StartUpdatingComponent(self)
    end
end

local function Retrieve(self)
    local numworks = 1
    if self.fisherman and self.fisherman.components.worker then
        numworks = self.fisherman.components.worker:GetEffectiveness(ACTIONS.FISH)
    end
    if self.target and self.target.components.workable then
        self.target.components.workable:WorkedBy(self.fisherman, numworks)
        self.inst:PushEvent("retrievecollect")
        self.target:PushEvent("retrievecollect")
    end
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("fishingrod", function(cmp)


_StartFishing = cmp.StartFishing
cmp.StartFishing = StartFishing
_Collect = cmp.Collect
cmp.Collect = Collect
cmp.OnUpdate = OnUpdate

cmp.Retrieve = Retrieve


end)
