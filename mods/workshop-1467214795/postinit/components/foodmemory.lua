local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local GetBaseFood_old
local function GetBaseFood(self, prefab, ...)
	if prefab:sub(-8) == "_gourmet" then --maybe find the char index instead in case something else is appended
		prefab = prefab:sub(1, -9)
	end
	return GetBaseFood_old(self, prefab, ...)
end

--Note: foodinst is set in postinit/eater.lua
local RememberFood_old
local function RememberFood(self, ...)
	if not self.restricttag or not self.foodinst or self.foodinst:HasTag(self.restricttag) then
		return RememberFood_old(self, ...)
	end
end

local GetFoodMultiplier_old
local function GetFoodMultiplier(self, prefab, ...)
	if not self.restricttag or not self.foodinst or self.foodinst:HasTag(self.restricttag) then
		return GetFoodMultiplier_old(self, prefab, ...)
	elseif self.cookedmult and string.find(prefab, "cooked") then
		return self.cookedmult
	elseif self.driedmult and string.find(prefab, "dried") then
		return self.driedmult
	end
	return self.rawmult or 1
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("foodmemory", function(cmp)


GetBaseFood_old = cmp.GetBaseFood
cmp.GetBaseFood = GetBaseFood
RememberFood_old = cmp.RememberFood
cmp.RememberFood = RememberFood
GetFoodMultiplier_old = cmp.GetFoodMultiplier
cmp.GetFoodMultiplier = GetFoodMultiplier


end)
