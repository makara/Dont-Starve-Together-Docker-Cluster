local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local Eat_old
local function Eat(self, food, feeder, ...)
	-- self.inst:PushEvent("oneatpre", {food=food, feeder=feeder})
	if self.inst.components.foodmemory then
		self.inst.components.foodmemory.foodinst = food
	end
	local ret = Eat_old(self, food, feeder, ...)
	if self.inst.components.foodmemory then
		self.inst.components.foodmemory.foodinst = nil
	end
	return ret
end

local function SetCarnivore(self, human)
    if human then
        self.inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODTYPE.MEAT, FOODTYPE.GOODIES })
    else
        self.inst.components.eater:SetDiet({ FOODTYPE.MEAT }, { FOODTYPE.MEAT })
    end
end

local function SetVegetarian(self, human)
    if human then
        self.inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODTYPE.VEGGIE })
    else
        self.inst.components.eater:SetDiet({ FOODTYPE.VEGGIE }, { FOODTYPE.VEGGIE })
    end
end

local function SetInsectivore(self)
    self.inst.components.eater:SetDiet({ FOODTYPE.INSECT }, { FOODTYPE.INSECT })
end

local function SetBird(self)
    self.inst.components.eater:SetDiet({ FOODTYPE.SEEDS }, { FOODTYPE.SEEDS })
end

local function SetBeaver(self)
    self.inst.components.eater:SetDiet({ FOODTYPE.WOOD }, { FOODTYPE.WOOD })
end

local function SetElemental(self, human)
    if human then
        self.inst.components.eater:SetDiet({ FOODTYPE.MEAT, FOODTYPE.VEGGIE, FOODTYPE.INSECT, FOODTYPE.SEEDS, FOODTYPE.GENERIC, FOODTYPE.ELEMENTAL }, { FOODTYPE.ELEMENTAL })
    else
        self.inst.components.eater:SetDiet({ FOODTYPE.ELEMENTAL }, { FOODTYPE.ELEMENTAL })
    end
end

local function SetOmnivore(self)
    self.inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI })
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("eater", function(cmp)

Eat_old = cmp.Eat
cmp.Eat = Eat

cmp.SetCarnivore = SetCarnivore
cmp.SetVegetarian = SetVegetarian
cmp.SetInsectivore = SetInsectivore
cmp.SetBird = SetBird
cmp.SetBeaver = SetBeaver
cmp.SetElemental = SetElemental
cmp.SetOmnivore = SetOmnivore

end)
