-- local Recipe = GLOBAL.Recipe
-- local Ingredient = GLOBAL.Ingredient
-- local RECIPETABS = GLOBAL.RECIPETABS
-- local TECH = GLOBAL.TECH
local AllRecipes = GLOBAL.AllRecipes

if GetModConfigData("AltEndtable") then
	AllRecipes["endtable"].ingredients = {
		Ingredient("limestonenugget", 2),
		Ingredient("boards", 2),
		Ingredient("turf_snakeskin", 2),
	}
end

if GetModConfigData("AltSeawreath") then
	if AllRecipes["kelphat"] ~= nil then
	AllRecipes["kelphat"].ingredients = {
		Ingredient("seaweed", 12),
	}
	end
end

if GetModConfigData("AltFloralshirt") then
	AllRecipes["hawaiianshirt"].ingredients = {
		Ingredient("papyrus", 3),
		Ingredient("silk", 3),
		Ingredient("petals", 5),
	}
end

if GetModConfigData("AltHoundius") then
	AllRecipes["eyeturret_item"].ingredients = {
		Ingredient("tigereye", 1),
		Ingredient("minotaurhorn", 1),
		Ingredient("thulecite", 5),
	}
end

if GLOBAL.rawget(GLOBAL, "SLOTMACHINE_LOOT") then
    GLOBAL.SLOTMACHINE_LOOT.goodspawns.chesstrinketswhite = 1.15
    GLOBAL.SLOTMACHINE_LOOT.actions.chesstrinketswhite = {
        treasure = "slot_chesstrinketswhite",
    }
    GLOBAL.AddTreasureLoot("slot_chesstrinketswhite", {
        loot = {
            trinket_30 = 1,
            trinket_15 = 1,
			trinket_28 = 1,
        },
    })
end

if GLOBAL.rawget(GLOBAL, "SLOTMACHINE_LOOT") then
    GLOBAL.SLOTMACHINE_LOOT.goodspawns.chesstrinketsblack = 1.15
    GLOBAL.SLOTMACHINE_LOOT.actions.chesstrinketsblack = {
        treasure = "slot_chesstrinketsblack",
    }
    GLOBAL.AddTreasureLoot("slot_chesstrinketsblack", {
        loot = {
            trinket_31 = 1,
            trinket_16 = 1,
			trinket_29 = 1,
        },
    })
end

if GetModConfigData("dragonfly") == 2 then
AddPrefabPostInit("dragonfly", function(inst)	 
		if inst.components.lootdropper ~= nil then 
	inst.components.lootdropper:AddChanceLoot("obsidian", 1)
	inst.components.lootdropper:AddChanceLoot("obsidian", 1)
	inst.components.lootdropper:AddChanceLoot("obsidian", 1)
	inst.components.lootdropper:AddChanceLoot("obsidian", 0.50)
	inst.components.lootdropper:AddChanceLoot("obsidian", 0.50)
	inst.components.lootdropper:AddChanceLoot("obsidian", 0.33)
	inst.components.lootdropper:AddChanceLoot("obsidian", 0.33)
	inst.components.lootdropper:AddChanceLoot("obsidian", 0.25)
	--inst.components.lootdropper:AddChanceLoot("dragoonheart", 1)
	--inst.components.lootdropper:AddChanceLoot("dragoonheart", 0.50)
	--inst.components.lootdropper:AddChanceLoot("dragoonheart", 0.25)
	end end)
end
--Island Adventures currently doesn't have dragoons, it has the dens but no dragoons themselves, so no hearts.