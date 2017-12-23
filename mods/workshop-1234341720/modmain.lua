Assets = {
	Asset("ATLAS", "images/inventoryimages/weapontab.xml"),	
}

PrefabFiles = {    
"pirate",	
"battleaxe",	
"purplesword",	
"deathscythe", 
"skullspear", 
"halberd", 
"teleportstaff", 
"poseidon", 
"healingstaff", 
"katana", 
"flamesword",
"book_summon",
"book_dogs",
"book_meteor",
"book_tornado",
"book_light",
"book_sleepingfield",
"book_freeze",
"book_lava",
"book_healing",
"book_slowness",
}
local _G = GLOBAL
local RECIPETABS = _G.RECIPETABS
local TECH = _G.TECH
local Ingredient = _G.Ingredient
local CUSTOM_RECIPETABS = _G.CUSTOM_RECIPETABS
local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

local function booker(inst)
	inst:AddComponent("reader") 
end

for k,prefabname in ipairs(GLOBAL.DST_CHARACTERLIST) do
	AddPrefabPostInit(prefabname, booker)
end

for k,prefabname in ipairs(GLOBAL.MODCHARACTERLIST) do
	AddPrefabPostInit(prefabname, booker)
end

TUNING.HEALTH_ABSORPTION = 0.5

STRINGS.NAMES.WEAPONS_TAB = "WEAPONS"
STRINGS.TABS.WEAPONS_TAB = "Weapons"
GLOBAL.RECIPETABS['WEAPONS_TAB'] = {str = "WEAPONS_TAB", sort=1, icon = "weapontab.tex", icon_atlas = "images/inventoryimages/weapontab.xml"}

modimport("scripts/recipes.lua")
STRINGS.NAMES.poseidon = "Poseidon's Trident"
STRINGS.NAMES.POSEIDON = "Poseidon's Trident"
STRINGS.NAMES.pirate = "Pirate Sword"
STRINGS.NAMES.PIRATE = "Pirate Sword"
STRINGS.NAMES.battleaxe = "Shadow Battle Axe"
STRINGS.NAMES.BATTLEAXE = "Shadow Battle Axe"
STRINGS.NAMES.purplesword = "Purple Dragon's Sword"
STRINGS.NAMES.PURPLESWORD = "Purple Dragon's Sword"
STRINGS.NAMES.deathscythe = "Death's Scythe"
STRINGS.NAMES.DEATHSCYTHE = "Death's Scythe"
STRINGS.NAMES.skullspear = "Skull Spear"
STRINGS.NAMES.SKULLSPEAR = "Skull Spear"
STRINGS.NAMES.halberd = "Crusader's Halberd"
STRINGS.NAMES.HALBERD = "Crusader's Halbard"
STRINGS.NAMES.teleportstaff = "Teleport Spear"
STRINGS.NAMES.TELEPORTSTAFF = "Teleport Spear"
STRINGS.NAMES.healingstaff = "Healing Staff"
STRINGS.NAMES.HEALINGSTAFF = "Healing Staff"
STRINGS.NAMES.katana = "Bushido Katana"
STRINGS.NAMES.KATANA = "Bushido Katana"
STRINGS.NAMES.flamesword = "Phoenix's Flamesword"
STRINGS.NAMES.FLAMESWORD = "Phoenix's Flamesword"

STRINGS.NAMES.BOOK_SUMMON = "Forbidden Tome"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOOK_SUMMON = "This is not as heavy as summoned pet!"
STRINGS.RECIPE_DESC.BOOK_SUMMON = "Summon big pet"
STRINGS.NAMES.book_summon = "Forbidden Tome"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.book_summon = "This is not as heavy as summoned pet!"
STRINGS.RECIPE_DESC.book_summon = "Summon big pet"

STRINGS.NAMES.BOOK_SLOWNESS = "Lord of Times"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOOK_SLOWNESS = "I'm now the king of escaping!"
STRINGS.RECIPE_DESC.BOOK_SLOWNESS = "Makes every monster pretty slow"
STRINGS.NAMES.book_slowness = "Lord of Times"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.book_slowness = "I'm now the king of escaping!"
STRINGS.RECIPE_DESC.book_slowness = "Makes every monster pretty slow"

STRINGS.NAMES.BOOK_HEALING = "Tome of Healing"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOOK_HEALING = "Live for another person - not yourself!"
STRINGS.RECIPE_DESC.BOOK_HEALING = "Healing Spell for parties"
STRINGS.NAMES.book_healing = "Tome of Healing"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.book_healing = "Live for another person - not yourself!"
STRINGS.RECIPE_DESC.book_healing = "Healing Spell for parties"

STRINGS.NAMES.BOOK_LIGHT = "Light in the Darkness"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOOK_LIGHT = "Drawf star eh?"
STRINGS.RECIPE_DESC.BOOK_LIGHT = "Put Your faith in the light!"
STRINGS.NAMES.book_light = "Light in the Darkness"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.book_light = "Drawf star eh?"
STRINGS.RECIPE_DESC.book_light = "Put Your faith in the light!"

STRINGS.NAMES.BOOK_FREEZE = "Chilling Adventure"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOOK_FREEZE = "Freeze!"
STRINGS.RECIPE_DESC.BOOK_FREEZE = "It says weather anomalies are included"
STRINGS.NAMES.book_freeze = "Chilling Adventure"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.book_freeze = "Freeze!"
STRINGS.RECIPE_DESC.book_freeze = "It says weather anomalies are included"

STRINGS.NAMES.BOOK_SLEEPINGFIELD = "The Sleepy Stories"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOOK_SLEEPINGFIELD = "I'm not sleepy at all..."
STRINGS.RECIPE_DESC.BOOK_SLEEPINGFIELD = "Creates sleeping fields"
STRINGS.NAMES.book_sleepingfield = "The Sleepy Stories"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.book_sleepingfield = "I'm not sleepy at all..."
STRINGS.RECIPE_DESC.book_sleepingfield = "Creates sleeping fields"

STRINGS.NAMES.BOOK_LAVA = "Tome of Lava"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOOK_LAVA = "Fire is good!"
STRINGS.RECIPE_DESC.BOOK_LAVA = "That's quite hot stuff..."
STRINGS.NAMES.book_lava = "Tome of Lava"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.book_lava = "Fire is good!"
STRINGS.RECIPE_DESC.book_lava = "That's quite hot stuff..."


STRINGS.NAMES.BOOK_TORNADO = "The Windy Stories"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOOK_TORNADO = "I need to wear something warm before using it"
STRINGS.RECIPE_DESC.BOOK_TORNADO = "The elements will guide You!"
STRINGS.NAMES.book_tornado = "The Windy Stories"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.book_tornado = "I need to wear something warm before using it"
STRINGS.RECIPE_DESC.book_tornado = "The elements will guide You!"

STRINGS.NAMES.BOOK_METEOR = "Meteor Shower"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOOK_METEOR = "I think it's going to be rainy..."
STRINGS.RECIPE_DESC.BOOK_METEOR = "Praise Demeter for heavy rain!"
STRINGS.NAMES.book_meteor = "Meteor Shower"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.book_meteor = "I think it's going to be rainy..."
STRINGS.RECIPE_DESC.book_meteor = "Praise Demeter for heavy rain!"

STRINGS.NAMES.BOOK_DOGS = "Wolves Pack"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOOK_DOGS = "It can be very noisy out there in next few seconds!"
STRINGS.RECIPE_DESC.BOOK_DOGS = "Summon some bad wolfs"
STRINGS.NAMES.book_dogs = "Wolves Pack"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.book_dogs = "It can be very noisy out there in next few seconds!"
STRINGS.RECIPE_DESC.book_dogs = "Summon some bad wolfs"

STRINGS.RECIPE_DESC.pirate = "Aye aye captain!"
STRINGS.RECIPE_DESC.PIRATE = "Aye aye captain!"
STRINGS.RECIPE_DESC.battleaxe = "Basic barbarian's tool."
STRINGS.RECIPE_DESC.BATTLEAXE = "Basic barbarian's tool."
STRINGS.RECIPE_DESC.purplesword = "Sword that suits kings!"
STRINGS.RECIPE_DESC.PURPLESWORD = "Sword that suits kings!"
STRINGS.RECIPE_DESC.deathscythe = "Grim Reaper's Scythe with style!"
STRINGS.RECIPE_DESC.DEATHSCYTHE = "Grim Reaper's Scythe with style!"
STRINGS.RECIPE_DESC.skullspear = "Used by shamans in their rituals."
STRINGS.RECIPE_DESC.SKULLSPEAR = "Used by shamans in their rituals."
STRINGS.RECIPE_DESC.halberd = "Yes my lord?"
STRINGS.RECIPE_DESC.HALBERD = "Yes my lord?"
STRINGS.RECIPE_DESC.teleportstaff = "Blink Spear."
STRINGS.RECIPE_DESC.TELEPORTSTAFF = "Blink Spear."
STRINGS.RECIPE_DESC.poseidon = "My wrath with Your commands!"
STRINGS.RECIPE_DESC.POSEIDON = "My wrath with Your commands!"
STRINGS.RECIPE_DESC.healingstaff = "Please God, let me save one more!"
STRINGS.RECIPE_DESC.HEALINGSTAFF = "Please God, let me save one more!"
STRINGS.RECIPE_DESC.katana = "Courage is my path!"
STRINGS.RECIPE_DESC.KATANA = "Courage is my path!"
STRINGS.RECIPE_DESC.flamesword = "I raised from inferno!"
STRINGS.RECIPE_DESC.FLAMESWORD = "I raised from inferno!"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.pirate = "Arrrr, lets slice some fools!"
GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.pirate = "Arrrr, lets slice some fools!"
GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.pirate = "Arrrr, lets slice some fools!"
GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.pirate = "Arrrr, lets slice some fools!"
GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.pirate = "Arrrr, lets slice some fools!"
GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.pirate = "Arrrr, lets slice some fools!"
GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.pirate = "Arrrr, lets slice some fools!"
GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.pirate = "Arrrr, lets slice some fools!"
GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.pirate = "Arrrr, lets slice some fools!"
GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.pirate = "Arrrr, lets slice some fools!"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.PIRATE = "Arrrr, lets slice some fools!"
GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.PIRATE = "Arrrr, lets slice some fools!"
GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.PIRATE = "Arrrr, lets slice some fools!"
GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.PIRATE = "Arrrr, lets slice some fools!"
GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.PIRATE = "Arrrr, lets slice some fools!"
GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.PIRATE = "Arrrr, lets slice some fools!"
GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.PIRATE = "Arrrr, lets slice some fools!"
GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.PIRATE = "Arrrr, lets slice some fools!"
GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.PIRATE = "Arrrr, lets slice some fools!"
GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.PIRATE = "Arrrr, lets slice some fools!"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.battleaxe = "For Asgard my companions! "
GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.battleaxe = "For Asgard my companions! "
GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.battleaxe = "For Asgard my companions! "
GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.battleaxe = "For Asgard my companions! "
GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.battleaxe = "For Asgard my companions! "
GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.battleaxe = "For Asgard my companions! "
GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.battleaxe = "For Asgard my companions! "
GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.battleaxe = "For Asgard my companions! "
GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.battleaxe = "For Asgard my companions! "
GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.battleaxe = "For Asgard my companions! "

STRINGS.CHARACTERS.GENERIC.DESCRIBE.BATTLEAXE = "For Asgard my companions! "
GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.BATTLEAXE = "For Asgard my companions! "
GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.BATTLEAXE = "For Asgard my companions! "
GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.BATTLEAXE = "For Asgard my companions! "
GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.BATTLEAXE = "For Asgard my companions! "
GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.BATTLEAXE = "For Asgard my companions! "
GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.BATTLEAXE = "For Asgard my companions! "
GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.BATTLEAXE = "For Asgard my companions! "
GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.BATTLEAXE = "For Asgard my companions! "
GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.BATTLEAXE = "For Asgard my companions! "

STRINGS.CHARACTERS.GENERIC.DESCRIBE.purplesword = "The mystery sword, that fits me!"
GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.purplesword = "The mystery sword, that fits me!"
GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.purplesword = "The mystery sword, that fits me!"
GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.purplesword = "The mystery sword, that fits me!"
GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.purplesword = "The mystery sword, that fits me!"
GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.purplesword = "The mystery sword, that fits me!"
GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.purplesword = "The mystery sword, that fits me!"
GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.purplesword = "The mystery sword, that fits me!"
GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.purplesword = "The mystery sword, that fits me!"
GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.purplesword = "The mystery sword, that fits me!"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.PURPLESWORD = "The mystery sword, that fits me!"
GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.PURPLESWORD = "The mystery sword, that fits me!"
GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.PURPLESWORD = "The mystery sword, that fits me!"
GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.PURPLESWORD = "The mystery sword, that fits me!"
GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.PURPLESWORD = "The mystery sword, that fits me!"
GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.PURPLESWORD = "The mystery sword, that fits me!"
GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.PURPLESWORD = "The mystery sword, that fits me!"
GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.PURPLESWORD = "The mystery sword, that fits me!"
GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.PURPLESWORD = "The mystery sword, that fits me!"
GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.PURPLESWORD = "The mystery sword, that fits me!"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.deathscythe = "Deeattthhhhh upon us...."
GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.deathscythe = "Deeattthhhhh upon us...."
GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.deathscythe = "Deeattthhhhh upon us...."
GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.deathscythe = "Deeattthhhhh upon us...."
GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.deathscythe = "Deeattthhhhh upon us...."
GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.deathscythe = "Deeattthhhhh upon us...."
GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.deathscythe = "Deeattthhhhh upon us...."
GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.deathscythe = "Deeattthhhhh upon us...."
GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.deathscythe = "Deeattthhhhh upon us...."
GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.deathscythe = "Deeattthhhhh upon us...."

STRINGS.CHARACTERS.GENERIC.DESCRIBE.DEATHSCYTHE = "Deeattthhhhh upon us...."
GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.DEATHSCYTHE = "Deeattthhhhh upon us...."
GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.DEATHSCYTHE = "Deeattthhhhh upon us...."
GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.DEATHSCYTHE = "Deeattthhhhh upon us...."
GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.DEATHSCYTHE = "Deeattthhhhh upon us...."
GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.DEATHSCYTHE = "Deeattthhhhh upon us...."
GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.DEATHSCYTHE = "Deeattthhhhh upon us...."
GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.DEATHSCYTHE = "Deeattthhhhh upon us...."
GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.DEATHSCYTHE = "Deeattthhhhh upon us...."
GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.DEATHSCYTHE = "Deeattthhhhh upon us...."

STRINGS.CHARACTERS.GENERIC.DESCRIBE.skullspear = "Ugha ugha ugha!"
GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.skullspear = "Ugha ugha ugha!"
GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.skullspear = "Ugha ugha ugha!"
GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.skullspear = "Ugha ugha ugha!"
GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.skullspear = "Ugha ugha ugha!"
GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.skullspear = "Ugha ugha ugha!"
GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.skullspear = "Ugha ugha ugha!"
GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.skullspear = "Ugha ugha ugha!"
GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.skullspear = "Ugha ugha ugha!"
GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.skullspear = "Ugha ugha ugha!"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.SKULLSPEAR = "Ugha ugha ugha!"
GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.SKULLSPEAR = "Ugha ugha ugha!"
GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.SKULLSPEAR = "Ugha ugha ugha!"
GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.SKULLSPEAR = "Ugha ugha ugha!"
GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.SKULLSPEAR = "Ugha ugha ugha!"
GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.SKULLSPEAR = "Ugha ugha ugha!"
GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.SKULLSPEAR = "Ugha ugha ugha!"
GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.SKULLSPEAR = "Ugha ugha ugha!"
GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.SKULLSPEAR = "Ugha ugha ugha!"
GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.SKULLSPEAR = "Ugha ugha ugha!"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.halberd = "Longer, greater, slower but sharper!"
GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.halberd = "Longer, greater, slower but sharper!"
GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.halberd = "Longer, greater, slower but sharper!"
GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.halberd = "Longer, greater, slower but sharper!"
GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.halberd = "Longer, greater, slower but sharper!"
GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.halberd = "Longer, greater, slower but sharper!"
GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.halberd = "Longer, greater, slower but sharper!"
GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.halberd = "Longer, greater, slower but sharper!"
GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.halberd = "Longer, greater, slower but sharper!"
GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.halberd = "Longer, greater, slower but sharper!"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.HALBERD = "Longer, greater, slower but sharper!"
GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.HALBERD = "Longer, greater, slower but sharper!"
GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.HALBERD = "Longer, greater, slower but sharper!"
GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.HALBERD = "Longer, greater, slower but sharper!"
GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.HALBERD = "Longer, greater, slower but sharper!"
GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.HALBERD = "Longer, greater, slower but sharper!"
GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.HALBERD = "Longer, greater, slower but sharper!"
GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.HALBERD = "Longer, greater, slower but sharper!"
GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.HALBERD = "Longer, greater, slower but sharper!"
GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.HALBERD = "Longer, greater, slower but sharper!"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.teleportstaff = "#FeelsLazyMan"
GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.teleportstaff = "#FeelsLazyMan"
GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.teleportstaff = "#FeelsLazyMan"
GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.teleportstaff = "#FeelsLazyMan"
GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.teleportstaff = "#FeelsLazyMan"
GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.teleportstaff = "#FeelsLazyMan"
GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.teleportstaff = "#FeelsLazyMan"
GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.teleportstaff = "#FeelsLazyMan"
GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.teleportstaff = "#FeelsLazyMan"
GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.teleportstaff = "#FeelsLazyMan"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.TELEPORTSTAFF = "#FeelsLazyMan"
GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.TELEPORTSTAFF = "#FeelsLazyMan"
GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.TELEPORTSTAFF = "#FeelsLazyMan"
GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.TELEPORTSTAFF = "#FeelsLazyMan"
GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.TELEPORTSTAFF = "#FeelsLazyMan"
GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.TELEPORTSTAFF = "#FeelsLazyMan"
GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.TELEPORTSTAFF = "#FeelsLazyMan"
GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.TELEPORTSTAFF = "#FeelsLazyMan"
GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.TELEPORTSTAFF = "#FeelsLazyMan"
GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.TELEPORTSTAFF = "#FeelsLazyMan"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.poseidon = "Do You want to conquer with my power!?"
GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.poseidon = "Do You want to conquer with my power!?"
GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.poseidon = "Do You want to conquer with my power!?"
GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.poseidon = "Do You want to conquer with my power!?"
GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.poseidon = "Do You want to conquer with my power!?"
GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.poseidon = "Do You want to conquer with my power!?"
GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.poseidon = "Do You want to conquer with my power!?"
GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.poseidon = "Do You want to conquer with my power!?"
GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.poseidon = "Do You want to conquer with my power!?"
GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.poseidon = "Do You want to conquer with my power!?"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.POSEIDON = "Do You want to conquer with my power!?"
GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.POSEIDON = "Do You want to conquer with my power!?"
GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.POSEIDON = "Do You want to conquer with my power!?"
GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.POSEIDON = "Do You want to conquer with my power!?"
GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.POSEIDON = "Do You want to conquer with my power!?"
GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.POSEIDON = "Do You want to conquer with my power!?"
GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.POSEIDON = "Do You want to conquer with my power!?"
GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.POSEIDON = "Do You want to conquer with my power!?"
GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.POSEIDON = "Do You want to conquer with my power!?"
GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.POSEIDON = "Do You want to conquer with my power!?"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.healingstaff = "I'm the healer! Make some space!"
GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.healingstaff = "I'm the healer! Make some space!"
GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.healingstaff = "I'm the healer! Make some space!"
GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.healingstaff = "I'm the healer! Make some space!"
GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.healingstaff = "I'm the healer! Make some space!"
GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.healingstaff = "I'm the healer! Make some space!"
GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.healingstaff = "I'm the healer! Make some space!"
GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.healingstaff = "I'm the healer! Make some space!"
GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.healingstaff = "I'm the healer! Make some space!"
GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.healingstaff = "I'm the healer! Make some space!"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.HEALINGSTAFF = "I'm the healer! Make some space!"
GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.HEALINGSTAFF = "I'm the healer! Make some space!"
GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.HEALINGSTAFF = "I'm the healer! Make some space!"
GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.HEALINGSTAFF = "I'm the healer! Make some space!"
GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.HEALINGSTAFF = "I'm the healer! Make some space!"
GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.HEALINGSTAFF = "I'm the healer! Make some space!"
GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.HEALINGSTAFF = "I'm the healer! Make some space!"
GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.HEALINGSTAFF = "I'm the healer! Make some space!"
GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.HEALINGSTAFF = "I'm the healer! Make some space!"
GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.HEALINGSTAFF = "I'm the healer! Make some space!"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.katana = "For honor!"
GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.katana = "For honor!"
GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.katana = "For honor!"
GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.katana = "For honor!"
GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.katana = "For honor!"
GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.katana = "For honor!"
GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.katana = "For honor!"
GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.katana = "For honor!"
GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.katana = "For honor!"
GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.katana = "For honor!"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.KATANA = "For honor!"
GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.KATANA = "For honor!"
GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.KATANA = "For honor!"
GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.KATANA = "For honor!"
GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.KATANA = "For honor!"
GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.KATANA = "For honor!"
GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.KATANA = "For honor!"
GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.KATANA = "For honor!"
GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.KATANA = "For honor!"
GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.KATANA = "For honor!"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.flamesword = "You will burn into ashes!"
GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.flamesword = "You will burn into ashes!"
GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.flamesword = "You will burn into ashes!"
GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.flamesword = "You will burn into ashes!"
GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.flamesword = "You will burn into ashes!"
GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.flamesword = "You will burn into ashes!"
GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.flamesword = "You will burn into ashes!"
GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.flamesword = "You will burn into ashes!"
GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.flamesword = "You will burn into ashes!"
GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.flamesword = "You will burn into ashes!"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.FLAMESWORD = "You will burn into ashes!"
GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.FLAMESWORD = "You will burn into ashes!"
GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.FLAMESWORD = "You will burn into ashes!"
GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.FLAMESWORD = "You will burn into ashes!"
GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.FLAMESWORD = "You will burn into ashes!"
GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.FLAMESWORD = "You will burn into ashes!"
GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.FLAMESWORD = "You will burn into ashes!"
GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.FLAMESWORD = "You will burn into ashes!"
GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.FLAMESWORD = "You will burn into ashes!"
GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.FLAMESWORD = "You will burn into ashes!"
