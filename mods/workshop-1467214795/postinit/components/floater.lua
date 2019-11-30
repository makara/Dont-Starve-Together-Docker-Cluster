local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local function UpdateAnimations(self, water_anim, land_anim)
    self.wateranim = water_anim or self.wateranim
    self.landanim = land_anim or self.landanim

    if self.showing_effect then
        self:PlayWaterAnim()
    else
        self:PlayLandAnim()
    end
end

local function PlayLandAnim(self)
    local anim = self.landanim
    if anim and type(anim) == "function" then
        anim = self.landanim(self.inst)
    end

	if anim and not self.inst.AnimState:IsCurrentAnimation(anim) then
        -- self.showing_effect = false
        self.inst.AnimState:PlayAnimation(anim, true)
    end

	self.inst.AnimState:SetLayer(LAYER_WORLD)
	self.inst.AnimState:SetSortOrder(0)
    self.inst.AnimState:OverrideSymbol("water_ripple", "ripple_build", "water_ripple")
    self.inst.AnimState:OverrideSymbol("water_shadow", "ripple_build", "water_shadow")
end

local function PlayWaterAnim(self)
    local anim = self.wateranim
    if anim and type(anim) == "function" then
        anim = self.wateranim(self.inst)
    end

	if anim and not self.inst.AnimState:IsCurrentAnimation(anim) then
        -- self.showing_effect = true 
        self.inst.AnimState:PlayAnimation(anim, true)
        self.inst.AnimState:SetTime(math.random())
    end

	self.inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
	self.inst.AnimState:SetSortOrder( 3 )
    self.inst.AnimState:OverrideSymbol("water_ripple", "ripple_build", "water_ripple")
    self.inst.AnimState:OverrideSymbol("water_shadow", "ripple_build", "water_shadow")
end  

local function PlayThrowAnim(self)
    if self.showing_effect then --IsOnWater(self.inst) then
        self:PlayWaterAnim()
    else
        self:PlayLandAnim()
    end

    self.inst.AnimState:ClearOverrideSymbol("water_ripple")
    self.inst.AnimState:ClearOverrideSymbol("water_shadow")
end

----------------------------------------------------------------------------------------

local function OnHitLand(inst)
	if inst.components.floater and inst.components.floater.landanim then
		inst.components.floater:PlayLandAnim()
	end
end

local function OnHitWater(inst)
	if inst.components.floater and inst.components.floater.wateranim then
		inst.components.floater:PlayWaterAnim()
	end
	
	local isheld = inst.components.inventoryitem and inst.components.inventoryitem:IsHeld()
	--don't do this if onload or if held (in the latter case, the floater cmp is being stupid and we should probably fix the excess callbacks)
	if GetTime() > 1 and not isheld then
		--don't forget to reject all the sharx drops here
		if inst.prefab ~= "shark_fin" and not inst:HasTag("monstermeat") and inst.components.edible and inst.components.edible.foodtype == "MEAT" then 		
			local roll = math.random()
			local chance = TUNING.SHARKBAIT_CROCODOG_SPAWN_MULT * inst.components.edible.hungervalue
			print(inst, "Testing for crocodog/sharx:", tostring(roll) .." < ".. tostring(chance), roll<chance)
			if roll < chance then 
				if math.random() < TUNING.SHARKBAIT_SHARX_CHANCE then
					TheWorld.components.hounded:SummonSpecialSpawn(inst:GetPosition(), "sharx", math.random(TUNING.SHARKBAIT_SHARX_MIN,TUNING.SHARKBAIT_SHARX_MAX))
				else
					TheWorld.components.hounded:SummonSpecialSpawn(inst:GetPosition(), "crocodog")
				end	
			end
		end
	end
end

local ShouldShowEffect_old
local function ShouldShowEffect(self, ...)
	--as of right now, the effect only runs if not on a land tile, and IA water is land to the game...
	return ShouldShowEffect_old(self, ...) or IsOnWater(self.inst)
end

local OnLandedClient_old
local function OnLandedClient(self, ...)
	if not self.wateranim then
		return OnLandedClient_old(self, ...)
	end
end

--The floater component is incredibly dumb. -M
local IsFloating_old
local function IsFloating(self, ...)
	return IsFloating_old(self, ...) and not (self.inst.replica.inventoryitem and self.inst.replica.inventoryitem:IsHeld())
end


----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("floater", function(cmp)


ShouldShowEffect_old = cmp.ShouldShowEffect
cmp.ShouldShowEffect = ShouldShowEffect
OnLandedClient_old = cmp.OnLandedClient
cmp.OnLandedClient = OnLandedClient
IsFloating_old = cmp.IsFloating
cmp.IsFloating = IsFloating

cmp.UpdateAnimations = UpdateAnimations
cmp.PlayLandAnim = PlayLandAnim
cmp.PlayWaterAnim = PlayWaterAnim
cmp.PlayThrowAnim = PlayThrowAnim

--Maybe explicitly only install the cb on master? -M
cmp.inst:ListenForEvent("floater_startfloating", OnHitWater)
cmp.inst:ListenForEvent("floater_stopfloating", OnHitLand)


end)
