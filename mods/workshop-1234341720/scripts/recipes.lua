local _G = GLOBAL
local RECIPETABS = _G.RECIPETABS
local TECH = _G.TECH
local Ingredient = _G.Ingredient
local MyRecipesTab = RECIPETABS.WEAPONS_TAB

local easy = (GetModConfigData("book_healing")=="easy")
local normal = (GetModConfigData("book_healing")=="normal")
local hard = (GetModConfigData("book_healing")=="hard")

if easy then
	AddRecipe("book_healing", {Ingredient("healingsalve", 2), Ingredient("redgem", 1), Ingredient("papyrus", 2)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/book_healing.xml", "book_healing.tex")
else if normal then
	AddRecipe("book_healing", {Ingredient("healingsalve", 4), Ingredient("redgem", 2), Ingredient("papyrus", 3)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/book_healing.xml", "book_healing.tex")
else if hard then
	AddRecipe("book_healing", {Ingredient("healingsalve", 6), Ingredient("redgem", 3), Ingredient("papyrus", 4)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/book_healing.xml", "book_healing.tex")
end
end
end

local easy = (GetModConfigData("book_light")=="easy")
local normal = (GetModConfigData("book_light")=="normal")
local hard = (GetModConfigData("book_light")=="hard")

if easy then
	AddRecipe("book_light", {Ingredient("lightbulb", 2), Ingredient("yellowgem", 1), Ingredient("papyrus", 2)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/book_light.xml", "book_light.tex")
else if normal then
	AddRecipe("book_light", {Ingredient("lantern", 1), Ingredient("yellowgem", 1), Ingredient("papyrus", 3)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/book_light.xml", "book_light.tex")
else if hard then
	AddRecipe("book_light", {Ingredient("nightmarefuel", 3), Ingredient("yellowgem", 1), Ingredient("papyrus", 4)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/book_light.xml", "book_light.tex")
end
end
end

local easy = (GetModConfigData("book_freeze")=="easy")
local normal = (GetModConfigData("book_freeze")=="normal")
local hard = (GetModConfigData("book_freeze")=="hard")


if easy then
	AddRecipe("book_freeze", {Ingredient("ice", 6), Ingredient("bluegem", 1), Ingredient("papyrus", 2)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/book_freeze.xml", "book_freeze.tex")
else if normal then
	AddRecipe("book_freeze", {Ingredient("ice", 8), Ingredient("bluegem", 2), Ingredient("papyrus", 3)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/book_freeze.xml", "book_freeze.tex")
else if hard then
	AddRecipe("book_freeze", {Ingredient("ice", 10), Ingredient("bluegem", 3), Ingredient("papyrus", 4)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/book_freeze.xml", "book_freeze.tex")
end
end
end

local easy = (GetModConfigData("book_slowness")=="easy")
local normal = (GetModConfigData("book_slowness")=="normal")
local hard = (GetModConfigData("book_slowness")=="hard")

if easy then
	AddRecipe("book_slowness", {Ingredient("compass", 1), Ingredient("slurtleslime", 2), Ingredient("papyrus", 2)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/book_slowness.xml", "book_slowness.tex")
else if normal then
	AddRecipe("book_slowness", {Ingredient("compass", 1), Ingredient("slurtleslime", 4), Ingredient("papyrus", 3)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/book_slowness.xml", "book_slowness.tex")
else if hard then
	AddRecipe("book_slowness", {Ingredient("orangegem", 1), Ingredient("slurtleslime", 6), Ingredient("papyrus", 4)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/book_slowness.xml", "book_slowness.tex")
end
end
end

local easy = (GetModConfigData("book_lava")=="easy")
local normal = (GetModConfigData("book_lava")=="normal")
local hard = (GetModConfigData("book_lava")=="hard")


if easy then
	AddRecipe("book_lava", {Ingredient("nightmarefuel", 2), Ingredient("redgem", 1), Ingredient("papyrus", 2)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/book_lava.xml", "book_lava.tex")
else if normal then
	AddRecipe("book_lava", {Ingredient("nightmarefuel", 4), Ingredient("redgem", 2), Ingredient("papyrus", 3)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/book_lava.xml", "book_lava.tex")
else if hard then
	AddRecipe("book_lava", {Ingredient("nightmarefuel", 6), Ingredient("redgem", 3), Ingredient("papyrus", 4)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/book_lava.xml", "book_lava.tex")
end
end
end

local easy = (GetModConfigData("book_tornado")=="easy")
local normal = (GetModConfigData("book_tornado")=="normal")
local hard = (GetModConfigData("book_tornado")=="hard")

if easy then
	AddRecipe("book_tornado", {Ingredient("grass_umbrella", 1), Ingredient("feather_robin", 2), Ingredient("feather_robin_winter", 2)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/book_tornado.xml", "book_tornado.tex")
else if normal then
	AddRecipe("book_tornado", {Ingredient("umbrella", 1), Ingredient("feather_robin", 3), Ingredient("feather_robin_winter", 3)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/book_tornado.xml", "book_tornado.tex")
else if hard then
	AddRecipe("book_tornado", {Ingredient("eyebrellahat", 1), Ingredient("feather_robin", 4), Ingredient("feather_robin_winter", 4)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/book_tornado.xml", "book_tornado.tex")
end
end
end

local easy = (GetModConfigData("book_meteor")=="easy")
local normal = (GetModConfigData("book_meteor")=="normal")
local hard = (GetModConfigData("book_meteor")=="hard")

if easy then
	AddRecipe("book_meteor", {Ingredient("moonrocknugget", 4), Ingredient("redgem", 1), Ingredient("papyrus", 2)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/book_meteor.xml", "book_meteor.tex")
else if normal then
	AddRecipe("book_meteor", {Ingredient("moonrocknugget", 6), Ingredient("redgem", 2), Ingredient("papyrus", 3)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/book_meteor.xml", "book_meteor.tex")
else if hard then
	AddRecipe("book_meteor", {Ingredient("moonrocknugget", 8), Ingredient("redgem", 3), Ingredient("papyrus", 4)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/book_meteor.xml", "book_meteor.tex")
end
end
end

local easy = (GetModConfigData("book_dogs")=="easy")
local normal = (GetModConfigData("book_dogs")=="normal")
local hard = (GetModConfigData("book_dogs")=="hard")

if easy then
	AddRecipe("book_dogs", {Ingredient("houndstooth", 4), Ingredient("boneshard", 1), Ingredient("papyrus", 2)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/book_dogs.xml", "book_dogs.tex")
else if normal then
	AddRecipe("book_dogs", {Ingredient("houndstooth", 6), Ingredient("boneshard", 2), Ingredient("papyrus", 3)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/book_dogs.xml", "book_dogs.tex")
else if hard then
	AddRecipe("book_dogs", {Ingredient("houndstooth", 8), Ingredient("boneshard", 3), Ingredient("papyrus", 4)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/book_dogs.xml", "book_dogs.tex")
end
end
end

local easy = (GetModConfigData("book_summon")=="easy")
local normal = (GetModConfigData("book_summon")=="normal")
local hard = (GetModConfigData("book_summon")=="hard")

if easy then
	AddRecipe("book_summon", {Ingredient("nightmare_timepiece", 1), Ingredient("reviver", 2), Ingredient("greengem", 1)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/book_summon.xml", "book_summon.tex")
else if normal then
	AddRecipe("book_summon", {Ingredient("nightmare_timepiece", 2), Ingredient("reviver", 3), Ingredient("yellowgem", 1)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/book_summon.xml", "book_summon.tex")
else if hard then
	AddRecipe("book_summon", {Ingredient("nightmare_timepiece", 3), Ingredient("reviver", 4), Ingredient("orangegem", 1)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/book_summon.xml", "book_summon.tex")
end
end
end

local easy = (GetModConfigData("book_sleepingfield")=="easy")
local normal = (GetModConfigData("book_sleepingfield")=="normal")
local hard = (GetModConfigData("book_sleepingfield")=="hard")

if easy then
	AddRecipe("book_sleepingfield", {Ingredient("panflute", 1), Ingredient("nightmarefuel", 1), Ingredient("papyrus", 2)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/book_sleepingfield.xml", "book_sleepingfield.tex")
else if normal then
	AddRecipe("book_sleepingfield", {Ingredient("mandrake", 1), Ingredient("nightmarefuel", 2), Ingredient("papyrus", 3)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/book_sleepingfield.xml", "book_sleepingfield.tex")
else if hard then
	AddRecipe("book_sleepingfield", {Ingredient("mandrake", 1), Ingredient("nightmarefuel", 3), Ingredient("papyrus", 4)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/book_sleepingfield.xml", "book_sleepingfield.tex")
end
end
end

local easy = (GetModConfigData("flamesword")=="easy")
local normal = (GetModConfigData("flamesword")=="normal")
local hard = (GetModConfigData("flamesword")=="hard")

if easy then
	AddRecipe("flamesword", {Ingredient("redgem", 2), Ingredient("marble", 4), Ingredient("greengem", 1)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/flamesword.xml", "flamesword.tex")
else if normal then
	AddRecipe("flamesword", {Ingredient("redgem", 3), Ingredient("marble", 5), Ingredient("greengem", 1)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/flamesword.xml", "flamesword.tex")
else if hard then
	AddRecipe("flamesword", {Ingredient("redgem", 4), Ingredient("marble", 7), Ingredient("greengem", 1)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/flamesword.xml", "flamesword.tex")
end
end
end

local easy = (GetModConfigData("katana")=="easy")
local normal = (GetModConfigData("katana")=="normal")
local hard = (GetModConfigData("katana")=="hard")

if easy then
	AddRecipe("katana", {Ingredient("redgem", 1), Ingredient("nightmarefuel", 3), Ingredient("marble", 2)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/katana.xml", "katana.tex")
else if normal then
	AddRecipe("katana", {Ingredient("redgem", 2), Ingredient("nightmarefuel", 4), Ingredient("marble", 3)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/katana.xml", "katana.tex")
else if hard then
	AddRecipe("katana", {Ingredient("redgem", 3), Ingredient("nightmarefuel", 5), Ingredient("marble", 4)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/katana.xml", "katana.tex")
end
end
end

local easy = (GetModConfigData("healingstaff")=="easy")
local normal = (GetModConfigData("healingstaff")=="normal")
local hard = (GetModConfigData("healingstaff")=="hard")

if easy then
	AddRecipe("healingstaff", {Ingredient("redgem", 1), Ingredient("cane", 1), Ingredient("livinglog", 2)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_THREE, nil, nil, nil, nil, nil, "images/inventoryimages/healingstaff.xml", "healingstaff.tex")
else if normal then
	AddRecipe("healingstaff", {Ingredient("redgem", 2), Ingredient("cane", 1), Ingredient("livinglog", 4)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_THREE, nil, nil, nil, nil, nil, "images/inventoryimages/healingstaff.xml", "healingstaff.tex")
else if hard then
	AddRecipe("healingstaff", {Ingredient("redgem", 3), Ingredient("cane", 1), Ingredient("livinglog", 6)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_THREE, nil, nil, nil, nil, nil, "images/inventoryimages/healingstaff.xml", "healingstaff.tex")
end
end
end

local easy = (GetModConfigData("poseidon")=="easy")
local normal = (GetModConfigData("poseidon")=="normal")
local hard = (GetModConfigData("poseidon")=="hard")

if easy then
	AddRecipe("poseidon", {Ingredient("bluegem", 1), Ingredient("tentaclespike", 1), Ingredient("ice", 7)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_THREE, nil, nil, nil, nil, nil, "images/inventoryimages/poseidon.xml", "poseidon.tex")
else if normal then
	AddRecipe("poseidon", {Ingredient("bluegem", 2), Ingredient("tentaclespike", 1), Ingredient("ice", 10)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_THREE, nil, nil, nil, nil, nil, "images/inventoryimages/poseidon.xml", "poseidon.tex")
else if hard then
	AddRecipe("poseidon", {Ingredient("bluegem", 3), Ingredient("tentaclespike", 1), Ingredient("ice", 14)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_THREE, nil, nil, nil, nil, nil, "images/inventoryimages/poseidon.xml", "poseidon.tex")
end
end
end

local easy = (GetModConfigData("teleportstaff")=="easy")
local normal = (GetModConfigData("teleportstaff")=="normal")
local hard = (GetModConfigData("teleportstaff")=="hard")

if easy then
	AddRecipe("teleportstaff", {Ingredient("orangegem", 1), Ingredient("goldnugget", 2), Ingredient("spear", 1)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_THREE, nil, nil, nil, nil, nil, "images/inventoryimages/teleportstaff.xml", "teleportstaff.tex")
else if normal then
	AddRecipe("teleportstaff", {Ingredient("orangegem", 1), Ingredient("goldnugget", 4), Ingredient("spear", 1)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_THREE, nil, nil, nil, nil, nil, "images/inventoryimages/teleportstaff.xml", "teleportstaff.tex")
else if hard then
	AddRecipe("teleportstaff", {Ingredient("orangegem", 1), Ingredient("goldnugget", 8), Ingredient("spear", 1)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_THREE, nil, nil, nil, nil, nil, "images/inventoryimages/teleportstaff.xml", "teleportstaff.tex")
end
end
end

local easy = (GetModConfigData("skullspear")=="easy")
local normal = (GetModConfigData("skullspear")=="normal")
local hard = (GetModConfigData("skullspear")=="hard")

if easy then
	AddRecipe("skullspear", {Ingredient("houndstooth", 1), Ingredient("boneshard", 1), Ingredient("spear", 1)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/skullspear.xml", "skullspear.tex")
else if normal then
	AddRecipe("skullspear", {Ingredient("houndstooth", 2), Ingredient("boneshard", 2), Ingredient("spear", 1)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/skullspear.xml", "skullspear.tex")
else if hard then
	AddRecipe("skullspear", {Ingredient("houndstooth", 3), Ingredient("boneshard", 3), Ingredient("spear", 1)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/skullspear.xml", "skullspear.tex")
end
end
end

local easy = (GetModConfigData("halberd")=="easy")
local normal = (GetModConfigData("halberd")=="normal")
local hard = (GetModConfigData("halberd")=="hard")

if easy then
	AddRecipe("halberd", {Ingredient("twigs", 3), Ingredient("rope", 1), Ingredient("spear", 1)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, "images/inventoryimages/halberd.xml", "halberd.tex")
else if normal then
	AddRecipe("halberd", {Ingredient("flint", 2), Ingredient("rope", 2), Ingredient("spear", 1)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, "images/inventoryimages/halberd.xml", "halberd.tex")
else if hard then
	AddRecipe("halberd", {Ingredient("flint", 4), Ingredient("rope", 2), Ingredient("spear", 1)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, "images/inventoryimages/halberd.xml", "halberd.tex")
end
end
end

local easy = (GetModConfigData("deathscythe")=="easy")
local normal = (GetModConfigData("deathscythe")=="normal")
local hard = (GetModConfigData("deathscythe")=="hard")

if easy then
	AddRecipe("deathscythe", {Ingredient("walrus_tusk", 1), Ingredient("nightmarefuel", 3), Ingredient("reviver", 1)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_THREE, nil, nil, nil, nil, nil, "images/inventoryimages/deathscythe.xml", "deathscythe.tex")
else if normal then
	AddRecipe("deathscythe", {Ingredient("walrus_tusk", 1), Ingredient("nightmarefuel", 5), Ingredient("reviver", 2)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_THREE, nil, nil, nil, nil, nil, "images/inventoryimages/deathscythe.xml", "deathscythe.tex")
else if hard then
	AddRecipe("deathscythe", {Ingredient("walrus_tusk", 1), Ingredient("nightmarefuel", 7), Ingredient("reviver", 3)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_THREE, nil, nil, nil, nil, nil, "images/inventoryimages/deathscythe.xml", "deathscythe.tex")
end
end
end

local easy = (GetModConfigData("purplesword")=="easy")
local normal = (GetModConfigData("purplesword")=="normal")
local hard = (GetModConfigData("purplesword")=="hard")

if easy then
	AddRecipe("purplesword", {Ingredient("purplegem", 2), Ingredient("flint", 4), Ingredient("rope", 1)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/purplesword.xml", "purplesword.tex")
else if normal then
	AddRecipe("purplesword", {Ingredient("dragon_scales", 1), Ingredient("purplegem", 2), Ingredient("rope", 2)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/purplesword.xml", "purplesword.tex")
else if hard then
	AddRecipe("purplesword", {Ingredient("dragon_scales", 1), Ingredient("purplegem", 3), Ingredient("silk", 2)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/purplesword.xml", "purplesword.tex")
end
end
end

local easy = (GetModConfigData("battleaxe")=="easy")
local normal = (GetModConfigData("battleaxe")=="normal")
local hard = (GetModConfigData("battleaxe")=="hard")

if easy then
	AddRecipe("battleaxe", {Ingredient("goldenaxe", 2), Ingredient("nitre", 3), Ingredient("nightmarefuel", 1)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/battleaxe.xml", "battleaxe.tex")
else if normal then
	AddRecipe("battleaxe", {Ingredient("goldenaxe", 2), Ingredient("charcoal", 3), Ingredient("nightmarefuel", 2)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/battleaxe.xml", "battleaxe.tex")
else if hard then
	AddRecipe("battleaxe", {Ingredient("goldenaxe", 2), Ingredient("silk", 3), Ingredient("nightmarefuel", 3)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/battleaxe.xml", "battleaxe.tex")
end
end
end

local easy = (GetModConfigData("pirate")=="easy")
local normal = (GetModConfigData("pirate")=="normal")
local hard = (GetModConfigData("pirate")=="hard")

if easy then
	AddRecipe("pirate", {Ingredient("batwing", 1), Ingredient("goldnugget", 1), Ingredient("rope", 1)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/pirate.xml", "pirate.tex")
else if normal then
	AddRecipe("pirate", {Ingredient("batwing", 1), Ingredient("goldnugget", 2), Ingredient("rope", 1)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/pirate.xml", "pirate.tex")
else if hard then
	AddRecipe("pirate", {Ingredient("batwing", 1), Ingredient("goldnugget", 3), Ingredient("rope", 2)}, RECIPETABS.WEAPONS_TAB, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/pirate.xml", "pirate.tex")
end
end
end
