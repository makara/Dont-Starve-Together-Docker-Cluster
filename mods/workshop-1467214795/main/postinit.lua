--Update this list when adding files
local component_post = {
    "ambientsound",
    "areaaware",
    "birdspawner",
    "builder",
    "burnable",
    "childspawner",
    "colourcube",
    "combat",
    "cookable",
    "crop",
    "deployable",
    "drownable",
    "dryer",
    "dynamicmusic",
    "eater",
    "edible",
    "equippable",
    "explosive",
    "fertilizer",
    "fishingrod",
    "floater",
    "foodmemory",
    "frograin",
    "frostybreather",
    "fuel",
    "fueled",
    "follower",
    "growable",
    "health",
    "hounded",
    --"hunter",
    "inspectable",
    "inventory",
    "inventoryitem",
    "inventoryitemmoisture",
    "leader",
    "locomotor",
    "lootdropper",
    "moisture",
	"penguinspawner",
    "perishable",
	"pickable",
    "playeractionpicker",
    "playercontroller",
    "regrowthmanager",
    "repairable",
    "shadowcreaturespawner",
    "sheltered",
    "stewer",
    "teamleader",
    "temperature",
    "thief",
    "trap",
    "uianim",
    "watercolor",
    "weather",
    "weapon",
    "wildfires",
    "wisecracker",
    "witherable",
    "worldstate",
    "worldwind",
}

local prefab_post = {
    "ash",
    "book_birds",
    "book_gardening",
    "cactus",
    "campfire",
    "chester",
    "chester_eyebone",
    "cookpot",
    "dirtpile",
    "eel",
    "fireflies",
    "firesuppressor",
    "fish",
    "float_fx",
    "gears",
    "gestalt",
	"grass",
    "healthregenbuff",
    "heatrock",
    "icebox",
    "inventoryitem_classified",
    "lantern",
    "lighter",
    "lightning",
	"lureplant",
    "mandrake",
    "marsh_bush",
    "meatrack",
    --"minisign",
    "player_classified",
    "portablecookpot",
    "prototyper",
    "rainometer",
    "sapling",
    "sewing_tape",
    "shadowmeteor",
    "shadowwaxwell",
    "tentacle",
    "thunder_close",
    "thunder_far",
    "torch",
    "trees",
    "trinkets",
	"variants_ia",
    "warly",
    "warningshadow",
    "winterometer",
    "woodie",
    "world",
    "wormwood_plant_fx",
}

local stategraph_post = {
    "bird",
    "frog",
    "merm",
    "shadowcreature",
    "shadowwaxwell",
    "wilson",
    "wilson_client",
}

local class_post = {
    "components/builder_replica",
    "components/combat_replica",
    "components/equippable_replica",
    "components/inventoryitem_replica",
    "screens/playerhud",
    "widgets/containerwidget",
    "widgets/healthbadge",
    "widgets/inventorybar",
    "widgets/itemtile",
    "widgets/widget",
}

modimport("postinit/sim")
modimport("postinit/any")
modimport("postinit/player")

for _,v in pairs(component_post) do
    modimport("postinit/components/"..v)
end

for _,v in pairs(prefab_post) do
    modimport("postinit/prefabs/"..v)
end

for _,v in pairs(stategraph_post) do
    modimport("postinit/stategraphs/SG"..v)
end

for _,v in pairs(class_post) do
    --These contain a path already, e.g. v= "widgets/inventorybar"
    modimport("postinit/".. v)
end
