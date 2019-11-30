return {
  
  ACTIONS = {
	JUMPIN = {
		BERMUDA = "Enter",
	},
	ACTIVATE = {
		SAND = "Destroy",
	},
    RUMMAGE = {
        INSPECT = "Inspect",
    },
	UNWRAP = {
		--if somebody already made this a table, don't overwrite any of their changes -M
		GENERIC = type(GLOBAL.STRINGS.ACTIONS.UNWRAP) == "string" and GLOBAL.STRINGS.ACTIONS.UNWRAP or nil,
		OPENCAN = "Open", --tunacan
	},
	PACKUP = GLOBAL.STRINGS.ACTIONS.PICKUP,
  },

  SKIN_NAMES =
  {
    walani_none = "Walani",
    -- warly_none = "Warly",
    wilbur_none = "Wilbur",
    woodlegs_none = "Woodlegs",
  },
  
  CHARACTER_NAMES =
  {
    walani = "Walani",
    -- warly = "Warly",
    wilbur = "Wilbur",
    woodlegs = "Woodlegs",
  },

  CHARACTER_QUOTES =
  {
    walani = "\"Forgive me if I don't get up. I don't want to.\"",
    -- warly = "\"Nothing worthwhile is ever done on an empty stomach!\"",
    wilbur = "\"Ooo ooa oah ah!\"",
    woodlegs = "\"Don't ye mind th'scurvy. Yarr-harr-harr!\"",
  },

  CHARACTER_TITLES =
  {
    walani = "The Unperturbable",
    -- warly = "The Culinarian",
    wilbur = "The Monkey King",
    woodlegs = "The Pirate Captain",
  },

  CHARACTER_DESCRIPTIONS =
  {
    walani = "*Loves surfing\n*Dries off quickly\n*Is a pretty chill gal",
    -- warly = "*Has a refined palate\n*Cooks in custom kitchenware\n*Brings a stylish chef pouch",
    wilbur = "*Can't talk\n*Slow as biped, but fast as quadruped\n*Is a monkey",
    woodlegs = "*Can sniff out treasure\n*Captain of the \"Sea Legs\"\n*Pirate",
  },

  FLOODEDITEM = "Flooded",
  GOURMETPREFIX = "Gourmet ", --Please note that the space is intentional, so translations may use hyphons or whatever -M
  GOURMETGENERIC = "Dish", --failsafe, in case the original name is invalid
  
  NAMES =
  {
    WALANI = "Walani",
    -- WARLY = "Warly",
    WILBUR = "Wilbur",
    WOODLEGS = "Woodlegs",
    
    DROWNING = "Drowning",
    POISON = "Poison",

    CRAB = "Crabbit",
    CRABHOLE = "Crabbit Den",
    CRAB_HIDDEN = "Shifting Sands",
    SAND = "Sand",
    SANDDUNE = "Sandy Pile", --Changed from "Sandy Dune"

    ROCK_CORAL = "Coral Reef",
    CORAL = "Coral",

    BARREL_GUNPOWDER = "Gunpowder Barrel", --Changed from "Barrel o' Gunpowder"

    SEAWEED = "Seaweed",
    SEAWEED_COOKED = "Roasted Seaweed", --Changed from "Cooked Seaweed"
    SEAWEED_DRIED = "Dried Seaweed",
    SEAWEED_PLANTED = "Seaweed",

    LIMESTONE = "Limestone",
    LIMESTONENUGGET = "Limestone",

    SWORDFISH = "Swordfish",
    SWORDFISH_DEAD = "Dead Swordfish", --Changed from "Swordfish"
    SOLOFISH = "Dogfish",
    SOLOFISH_DEAD = "Dead Dogfish", --Changed from "Dogfish"

    FISHINHOLE = "Shoal", --Changed from "School of Fish"
    FISH_TROPICAL = "Tropical Fish",
    FISH_MED = "Raw Fish", -- Used to be "Steak"
    FISH_MED_COOKED = "Fish Steak",
    FISH_SMALL = "Fish Morsel", --Changed from "Raw Fish"
    FISH_SMALL_COOKED = "Cooked Fish Morsel", --Changed from "Cooked Fish"
    SPOILED_FISH = "Spoiled Fish",

    BOAT_RAFT = "Raft",
    BOAT_LOGRAFT = "Log Raft",
    BOAT_ROW = "Row Boat",
    BOAT_CARGO = "Cargo Boat",
    BOAT_ARMOURED = "Armoured Boat",
    BOAT_ENCRUSTED = "Encrusted Boat",
    BOAT_SURFBOARD = "Surfboard",
    BOAT_SURFBOARD_ITEM = "Surfboard",
    BOAT_WOODLEGS = "The \"Sea Legs\"",

    SAIL_PALMLEAF = "Thatch Sail",
    SAIL_CLOTH = "Cloth Sail",
    SAIL_SNAKESKIN = "Snakeskin Sail",
    SAIL_FEATHER = "Feather Lite Sail",
    IRONWIND = "Iron Wind",
    BOAT_LANTERN = "Boat Lantern",
    TRAWLNET = "Trawl Net",
    TRAWLNETDROPPED = "Trawl Net",
    BOATCANNON = "Boat Cannon",

    BUSH_VINE = "Viney Bush",
    SNAKEDEN = "Viney Bush",
    VINE = "Vine",
    DUG_BUSH_VINE = "Viney Bush Root",

    BAMBOOTREE = "Bamboo Patch",
    BAMBOO = "Bamboo",

    MUSSEL = "Mussel",
    MUSSEL_COOKED = "Cooked Mussel",
    MUSSEL_STICK = "Mussel Stick",
    MUSSEL_FARM = "Mussels",

    MESSAGEBOTTLE = "Message in a Bottle",
    MESSAGEBOTTLEEMPTY = "Empty Bottle",
    BURIEDTREASURE = "X Marks the Spot",


-- These are copied over from SW directly and haven't really been looked at yet

    TURF_BEACH = "Beach Turf",
    TURF_JUNGLE = "Jungle Turf",
    TURF_SWAMP = "Swamp Turf",

    TURF_VOLCANO = "Volcano Turf",
    TURF_ASH = "Ashy Turf",
    TURF_MAGMAFIELD = "Magma Turf",
    TURF_TIDALMARSH = "Tidal Marsh Turf",
    TURF_MEADOW = "Meadow Turf",

    PORTAL_SHIPWRECKED = "Malfunctioning Novelty Ride",

    BOOK_METEOR = "Joy of Volcanology",

    TRINKET_IA_13 = "Orange Soda",
    TRINKET_IA_14 = "Voodoo Doll",
    TRINKET_IA_15 = "Ukulele",
    TRINKET_IA_16 = "License Plate",
    TRINKET_IA_17 = "Old Boot",
    TRINKET_IA_18 = "Ancient Vase",
    TRINKET_IA_19 = "Brain Cloud Pill",
    TRINKET_IA_20 = "Sextant",
    TRINKET_IA_21 = "Toy Boat",
    TRINKET_IA_22 = "Wine Bottle Candle",
    TRINKET_IA_23 = "Broken AAC Device", -- AAC = Augmentative and Alternative Communication

    SUNKEN_BOAT_TRINKET_1 = "Sextant",
    SUNKEN_BOAT_TRINKET_2 = "Toy Boat", -- "Prototype 0021",
    SUNKEN_BOAT_TRINKET_3 = "Soaked Candle",
    SUNKEN_BOAT_TRINKET_4 = "Sea Worther",
    SUNKEN_BOAT_TRINKET_5 = "Old Boot",

    PRIMEAPE = "Prime Ape",
    PRIMEAPEBARREL = "Prime Ape Hut",
    WILDBOREHOUSE = "Wildbore House",
    WILDBORE = "Wildbore",
    WILDBOREGUARD = "Wildbore Guard",
    WOODLEGS_CAGE = "Woodlegs' Cage",
    WOODLEGS_KEY1 = "Bone Key",
    WOODLEGS_KEY2 = "Golden Key",
    WOODLEGS_KEY3 = "Iron Key",
    BERRYBUSH_SNAKE = "Berry Bush",
    BERRYBUSH2_SNAKE = "Berry Bush",
    DOYDOY = "Doydoy",
    DOYDOYBABY = "Baby Doydoy",
    DOYDOYTEEN = "Teen Doydoy",
    DOYDOYEGG = "Doydoy Egg",
    DOYDOYEGG_CRACKED = "Cracked Doydoy Egg",
    DOYDOYEGG_COOKED = "Fried Doydoy Egg",
    DOYDOYNEST = "Doydoy Nest",
    DOYDOYFEATHER = "Doydoy Feather",
    DUG_BAMBOOTREE = "Bamboo Root",
    PALMLEAF_HUT = "Palm Leaf Hut",
	PALMLEAF_UMBRELLA = "Palm Leaf Umbrella",
    THATCHPACK = "Thatch Pack",
    GRASS_WATER = "Grass",

    PIRATEPACK = "Booty Bag",
    PEG_LEG = "Peg Leg",

    SEASHELL = "Seashell",
    SEASHELL_BEACHED = "Seashell",
    PALMTREE = "Palm Tree",
    LEIF_PALM = "Treeguard",
    COCONUT = "Coconut",
    COCONUT_SAPLING = "Palm Tree Sapling",
    COCONUT_HALVED = "Halved Coconut",
    COCONUT_COOKED = "Roasted Coconut",

    MACHETE = "Machete",
    GOLDENMACHETE = "Luxury Machete",
    TELESCOPE = "Spyglass",
    SUPERTELESCOPE = "Super Spyglass",
    BERMUDATRIANGLE = "Electric Isosceles",
    SANDBAG = "Sandbag",
    SANDBAG_ITEM = "Sandbag",
    SANDBAGSMALL = "Sandbag",
    SANDBAGSMALL_ITEM = "Sandbag",
    DUBLOON = "Dubloons",

    OBSIDIAN_BENCH = "Obsidian Workbench",
    OBSIDIAN_BENCH_BROKEN = "Broken Obsidian Workbench",

    JUNGLETREE = "Jungle Tree",
    JUNGLETREESEED = "Jungle Tree Seed",
    JUNGLETREESEED_SAPLING = "Jungle Tree Sapling",

    BANANA_TREE = "Banana Tree",
    BANANA = "Banana",
    BANANA_COOKED = "Cooked Banana",

    BOAT_INDICATOR = "Don't Click On Me!",
    ARMOR_LIFEJACKET = "Life Jacket",
    ROCK_LIMPET = "Limpet Rock",
    LIMPETS = "Limpets",
    LIMPETS_COOKED = "Cooked Limpets",
    SWEET_POTATO = "Sweet Potato",
    SWEET_POTATO_COOKED = "Cooked Sweet Potato",
    SWEET_POTATO_SEEDS = "Sweet Potato Seeds",
    SWEET_POTATO_PLANTED = "Sweet Potato",

    LUGGAGECHEST = "Steamer Trunk",
    OCTOPUSCHEST = "Octo Chest",

    PEACOCK = "Peacock", --what.
    COCONADE = "Coconade",
    OBSIDIANCOCONADE = "Obsidian Coconade",
    MONKEYBALL = "Silly Monkey Ball",
    OX = "Water Beefalo",
    BABYOX = "Baby Water Beefalo",

    TOUCAN = "Toucan",
    SEAGULL = "Seagull",
    SEAGULL_WATER = "Seagull",
    PARROT = "Parrot",
    CORMORANT = "Cormorant",

    TUNACAN = '"Ballphin Free" Tuna', --this isnt the right formatting, right...?

    SEATRAP = "Sea Trap",

    DRAGOON = "Dragoon",
    DRAGOONEGG = "Dragoon Egg",
    DRAGOONSPIT = "Dragoon Saliva",
    DRAGOONDEN = "Dragoon Den",
    DRAGOONHEART = "Dragoon Heart",
    SNAKE = "Snake",
    SNAKE_POISON = "Poison Snake",
    VENOMGLAND = "Venom Gland",
    LOBSTER = "Wobster",
    LOBSTER_DEAD = "Dead Wobster",
    LOBSTER_DEAD_COOKED = "Delicious Wobster",
    LOBSTERHOLE = "Wobster Den",
    BALLPHIN = "Bottlenose Ballphin",
    BALLPHINHOUSE = "Ballphin Palace",
    DORSALFIN = "Dorsal Fin",
    FLOATER = "Floater",
    NUBBIN = "Coral Nubbin",
    CORALLARVE = "Coral Larva",
    WHALE_BLUE = "Blue Whale",
    WHALE_WHITE = "White Whale",
    WHALE_CARCASS_BLUE = "Blue Whale Carcass",
    WHALE_CARCASS_WHITE = "White Whale Carcass",

    WHALE_BUBBLES = "Suspicious Bubbles",

    BLUBBER = "Blubber",
    BLUBBERSUIT = "Blubber Suit",

    ANTIVENOM = "Anti Venom",
    BLOWDART_POISON = "Poison Dart",
    POISONHOLE = "Poisonous Hole",
    SPEAR_POISON = "Poison Spear",

    FABRIC = "Cloth",

    OBSIDIANAXE = "Obsidian Axe",
    OBSIDIANMACHETE = "Obsidian Machete",
    OBSIDIANSPEARGUN = "Obsidian Speargun",
    SPEAR_OBSIDIAN = "Obsidian Spear",
    ARMOROBSIDIAN = "Obsidian Armor",

    CAPTAINHAT = "Captain Hat",
    PIRATEHAT = "Pirate Hat",
    WORNPIRATEHAT = "Worn Pirate Hat",
    GASHAT = "Particulate Purifier",
    AERODYNAMICHAT = "Sleek Hat",

    JELLYFISH = "Jellyfish",
    JELLYFISH_PLANTED = "Jellyfish",
    JELLYFISH_DEAD = "Dead Jellyfish",
    JELLYFISH_COOKED = "Cooked Jellyfish",
    JELLYJERKY = "Dried Jellyfish",
	
	RAINBOWJELLYFISH = "Rainbow Jellyfish",
	RAINBOWJELLYFISH_PLANTED = "Rainbow Jellyfish",
	RAINBOWJELLYFISH_DEAD = "Dead Rainbow Jellyfish",
	RAINBOWJELLYFISH_COOKED = "Cooked Rainbow Jellyfish",
	RAINBOWJELLYJERKY = "Dried Rainbow Jellyfish",
	
    SPEARGUN = "Speargun",
    SPEARGUN_POISON = "Poison Speargun",

    HARPOON = "Harpoon",

    TRIDENT = "Trident",

    ARMOR_SNAKESKIN = "Snakeskin Jacket",
    SNAKESKINHAT = "Snakeskin Hat",
    SNAKESKIN = "Snakeskin",

    BIGFISHINGROD = "Sport Fishing Rod",

    CHIMINEA = "Chiminea",
    OBSIDIANFIREPIT = "Obsidian Fire Pit",
    OBSIDIAN = "Obsidian",
    LAVAPOOL = "Lava Pool",
    EARRING = "One True Earring",
    CUTLASS = "Cutlass Supreme",
    ARMORSEASHELL = "Seashell Suit",
    SEASACK = "Sea Sack",
    PIRATIHATITATOR = "Piratihatitator",
    SLOTMACHINE = "Slot Machine",
    VOLCANO = "Volcano",
    VOLCANO_EXIT = "Volcano",
    VOLCANO_ALTAR = "Volcano Altar of Snackrifice",
    VOLCANOSTAFF = "Volcano Staff",
    ICEMAKER = "Ice Maker 3000",
    COFFEEBEANS = "Coffee Beans",
    COFFEE = "Coffee",
    COFFEEBEANS_COOKED = "Roasted Coffee Beans",
    COFFEEBUSH = "Coffee Plant",
    DUG_COFFEEBUSH = "Coffee Plant",
    CHEFPACK = "Chef Pouch",
    MAILPACK = "Letter Carrier Bag",
    -- PORTABLECOOKPOT = "Portable Crock Pot",
    -- PORTABLECOOKPOT_ITEM = "Portable Crock Pot",
    ELEPHANTCACTUS = "Elephant Cactus",
    ELEPHANTCACTUS_ACTIVE = "Prickly Elephant Cactus",
    ELEPHANTCACTUS_STUMP = "Elephant Cactus Stump",
    DUG_ELEPHANTCACTUS = "Elephant Cactus",
    ARMORCACTUS = "Cactus Armor",
    NEEDLESPEAR = "Cactus Spike",
    PALMLEAF = "Palm Leaf",
    ARMORLIMESTONE = "Limestone Suit",
    WALL_LIMESTONE = "Limestone Wall",
    WALL_LIMESTONE_ITEM = "Limestone Wall",
	WALL_ENFORCEDLIMESTONE = "Sea Wall",
	WALL_ENFORCEDLIMESTONE_ITEM = "Sea Wall",
    ARMOR_WINDBREAKER = "Windbreaker",
    BOTTLELANTERN = "Bottle Lantern",
    SANDCASTLE = "Sand Castle",
    DOUBLE_UMBRELLAHAT = "Dumbrella",
    HAIL_ICE = "Hail",

    CALIFORNIAROLL = "California Roll",
    SEAFOODGUMBO = "Seafood Gumbo",
    BISQUE = "Bisque",
    -- CEVICHE = "Ceviche",
    JELLYOPOP = "Jelly-O Pop",
    -- BANANAPOP = "Banana Pop",
    LOBSTERBISQUE = "Wobster Bisque",
    LOBSTERDINNER = "Wobster Dinner",
    SHARKFINSOUP = "Shark Fin Soup",
    SURFNTURF = "Surf 'n' Turf",

    SWEETPOTATOSOUFFLE = "Sweet Potato Souffle",
    -- MONSTERTARTARE = "Monster Tartare",
    -- FRESHFRUITCREPES = "Fresh Fruit Crepes",
    MUSSELBOUILLABAISE = "Mussel Bouillabaise",


    BIOLUMINESCENCE = "Bioluminescence",
    SHARK_FIN = "Shark Fin",
    SHARK_GILLS = "Shark Gills",
    STUNGRAY = "Stink Ray",
    TURBINE_BLADES = "Turbine Blades",
    TIGERSHARK = "Tiger Shark",
    TIGEREYE = "Eye of the Tiger Shark",
    SHARKITTEN = "Sharkitten",
    BOATREPAIRKIT = "Boat Repair Kit",
    OBSIDIAN_WORKBENCH = "Obsidian Workbench",
    RAWLING = "Rawling",
    PACKIM_FISHBONE = "Fishbone",
    PACKIM = "Packim Baggims",
    SHARX = "Sea Hound",
    SNAKEOIL = "Snake Oil",

	CROCODOG = "Crocodog",
	POISONCROCODOG = "Yellow Crocodog",
	WATERCROCODOG = "Blue Crocodog",
	
    FROG_POISON = "Poison Frog",

    MYSTERYMEAT = "Bile-Covered Slop",

    OCTOPUSKING = "Yaarctopus",

    MAGMAROCK = "Magma Pile",
    MAGMAROCK_GOLD = "Magma Pile",
    ROCK_OBSIDIAN = "Obsidian Boulder",
    ROCK_CHARCOAL = "Charcoal Boulder",
    VOLCANO_SHRUB = "Burnt Ash Tree",

    FLUP = "Flup",

    CORAL_BRAIN_ROCK = "Brainy Sprout",
    CORAL_BRAIN = "Brainy Matter",
    BRAINJELLYHAT = "Brain of Thought",
    EUREKAHAT = "Eureka! Hat",--wha...

    MANGROVETREE = "Mangrove",
    FLAMEGEYSER = "Krissure",
    TIDALPOOL = "Tidal Pool",
    TIDAL_PLANT = "Plant",

    TELEPORTATO_SW_RING = "Ring Thing",
    TELEPORTATO_SW_BOX = "Screw Thing",
    TELEPORTATO_SW_CRANK = "Grassy Thing",
    TELEPORTATO_SW_POTATO = "Wooden Potato Thing",
    TELEPORTATO_SW_BASE = "Wooden Platform Thing",
    TELEPORTATO_SW_CHECKMATE = "Wooden Platform Thing",

    KNIGHTBOAT = "Floaty Boaty Knight",

    LIVINGJUNGLETREE = "Regular Jungle Tree",

    WALLYINTRO_DEBRIS = "Debris",
    WALLYINTRO = "Rude Bird",

    BLOWDART_FLUP = "Eyeshot",

    MOSQUITO_POISON = "Poison Mosquito",

    MERMFISHER = "Fishermerm",
    MERMHOUSE_FISHER = "Fishermerm's Hut",
    MOSQUITOSACK_YELLOW = "Yellow Mosquito Sack",
    SHARK_TEETHHAT = "Shark Tooth Crown",
    BOAT_TORCH ="Boat Torch",

    MARSH_PLANT_TROPICAL = "Plant",
    WILDBOREHEAD = "Wildbore Head",

    SWIMMINGHORROR = "Swimming Horror",

    CRATE = "Crate",
    BUOY = "Buoy",

    SHARKITTENSPAWNER_ACTIVE = "Sharkitten Den",
    SHARKITTENSPAWNER_INACTIVE = "Sandy Pile",

    TWISTER = "Sealnado",
    TWISTER_SEAL = "Seal",

    SHIPWRECK = "Wreck",
    WRECKOF = "Wreck of the %s",
    TURF_SNAKESKIN = "Snakeskin Rug",

    WILBUR_UNLOCK = "Soggy Monkey",
    WILBUR_CROWN = "Tarnished Crown",

    MAGIC_SEAL = "Magic Seal",
    WIND_CONCH = "Howling Conch",
    SAIL_STICK = "Sail Stick",

    SHIPWRECKED_ENTRANCE = "Seaworthy",
    SHIPWRECKED_EXIT = "Seaworthy",

    INVENTORYWATERYGRAVE = "Watery Grave",
    WATERYGRAVE = "Watery Grave",
    PIRATEGHOST = "Pirate Ghost",

    KRAKEN = "Quacken",
    KRAKEN_TENTACLE = "Quacken Tentacle",
    WOODLEGSHAT = "Lucky Hat",
    SPEAR_LAUNCHER = "Speargun",

    KRAKENCHEST = "Chest of the Depths",

    OX_FLUTE = "Dripple Pipes",
    OXHAT = "Horned Helmet",
    OX_HORN = "Horn",

    QUACKENBEAK = "Quacken Beak",
    QUACKERINGRAM = "Quackering Ram",
    QUACKENDRILL = "Quacken Drill",

    TAR = "Tar",
    TAR_EXTRACTOR = "Tar Extractor",
    TAR_POOL = "Tar Slick",
    TAR_TRAP = "Tar Trap",
    TARLAMP = "Tar Lamp",
    TARSUIT = "Tar Suit",

    SEA_YARD = "Sea Yard",
    SEA_CHIMINEA = "Buoyant Chiminea",       

    ROE = "Roe",
    ROE_COOKED = "Cooked Roe",
    FISH_FARM = "Fish Farm", 

    PURPLE_GROUPER = "Purple Grouper",
    PIERROT_FISH = "Pierrot Fish",
    NEON_QUATTRO = "Neon Quattro",

    PURPLE_GROUPER_COOKED = "Cooked Purple Grouper",
    PIERROT_FISH_COOKED = "Cooked Pierrot Fish",
    NEON_QUATTRO_COOKED = "Cooked Neon Quattro",   

    TROPICALBOUILLABAISSE = "Tropical Bouillabaisse",
    CAVIAR = "Caviar",

    SEA_LAB = "Sea Lab",
    WATERCHEST = "Sea Chest",

    SEAWEED_STALK = "Seaweed Stalk",
    MUSSEL_BED = "Mussel Bed",
	
    TROPICALFAN = "Tropical Fan",
	
	TERRAFORMSTAFF = "Atlantis Staff",

    POISONBALM = "Poison Balm",
  },

  RECIPE_DESC =
  {
    POISONBALM = "The excruciating pain means it's working.",
    ANTIVENOM = "Cures that not-fresh \"poison\" feeling.",
    BLOWDART_POISON = "Spit poison at your enemies.",
    BOAT_ROW = "Row, row, row your boat!",
    BALLPHINHOUSE = "EeEe! EeEe!",
    MACHETE = "Hack stuff!",
    GOLDENMACHETE = "Hack stuff with elegance (and metal)!",
    ARMOR_LIFEJACKET = "Safety first!",
    TELESCOPE = "See across the sea.",
    SUPERTELESCOPE = "See across more sea.",
    PALMLEAF_HUT = "Escape the rain. Mostly.",
    SANDBAG_ITEM = "Sand. Water's greatest enemy.",
    CHIMINEA = "Fire and wind don't mix.",
    PIRATEHAT = "It's a pirate's life for ye!",
    WORNPIRATEHAT = "It's a pirate's life for ye!",
    PIRATIHATITATOR = "Make your pirate hat... magic!",
    SLOTMACHINE = "Leave nothing to chance! Except this.",
    SANDCASTLE = "Therapeutic and relaxing.",
    ICEMAKER = "Ice, ice, baby!",
    VOLCANOSTAFF = "The sky is falling!",
    MUSSEL_STICK = "Mussels stick to it!",
    SEATRAP = "It's a trap for sea creatures.",
    LIMESTONENUGGET = "Stone, with a hint of lime.",
    ARMORLIMESTONE = "Sartorial reef.",
    WALL_LIMESTONE_ITEM = "Coral reef walling.",
	WALL_RUINEDLIMESTONE_ITEM = "Tough wall segments, sorta.",
	WALL_ENFORCEDLIMESTONE_ITEM = "Strong wall segments to build at sea.",
    ARMOR_WINDBREAKER = "Break some wind!",
    BOTTLELANTERN = "Glowing ocean goo in a bottle.",
    OBSIDIANAXE = "Like a regular axe, only hotter.",
    OBSIDIANMACHETE = "Hack'n'burn!",
    OBSIDIANFIREPIT = "The fieriest of all fires!",
    BOAT_RAFT = "Totally sort of seaworthy.",
    SURFBOARD_ITEM = "Cowabunga dudes!",
    BOAT_CARGO = "Hoarding at sea!",
    BOAT_ENCRUSTED = "A tank on high seas!",
    SAIL_PALMLEAF = "Catch the wind!",
    SAIL_CLOTH = "Catch even more wind!",
    SAIL_SNAKESKIN = "Heavy duty wind catcher.",
    SAIL_FEATHER = "Like a bird's wing, for your boat!",
    BOAT_LANTERN = "Shed some light on the situation.",
    BOATCANNON = "It's got your boat's back.",
    TRAWLNET = "The patient fisher is always rewarded.",
    CAPTAINHAT = "Wear one. Your boat will respect you more.",
	NUBBIN = "There's nubbin better!",
    SEASACK = "Keeps your food fresher, longer!",
    ARMORSEASHELL = "Pretty poison prevention.",
    SPEAR_OBSIDIAN = "How about a lil fire with your spear?",
    ARMOROBSIDIAN = "Hot to the touch.",
    COCONADE = "KA-BLAM!",
    OBSIDIANCOCONADE = "KA-BLAMMIER!",
    SPEAR_LAUNCHER = "Laterally eject your spears.",
    SPEARGUN = "Never sail without one!",
    SPEARGUN_POISON = "Sick shot!",
    OBSIDIANSPEARGUN = "Hot shot!",
    CUTLASS = "Fish were harmed in the making of this.",
    SANDCASTLE = "Therapeutic and relaxing.",
    WALL_LIMESTONE_ITEM = "Strong wall segments.",
    FABRIC = "Bamboo is so versatile!",
    MESSAGEBOTTLEEMPTY = "Don't forget to recycle!",
    ICE = "Water of the solid kind.",
    AERODYNAMICHAT = "Aerodynamic design for efficient travel.",
    GASHAT = "Keep nasty airborne particulates away!",
    SNAKESKINHAT = "Keep the rain out, and look cool doing it.",
    ARMOR_SNAKESKIN = "Stay dry and leathery.",
    ARMORCACTUS = "Prickly to the touch.",
    SPEAR_POISON = "Jab'em with a sick stick.",
    IRONWIND = "Motorin'!",
    BOATREPAIRKIT = "Stay afloat in that boat!",
    MONKEYBARREL = "Monkey around by putting monkeys around.",
    BRAINJELLYHAT = "Well aren't you clever?",
    EUREKAHAT = "For when inspiration strikes.",
    BOAT_ARMOURED = "Shell out for this hearty vessel.",
    THATCHPACK = "Carry a light load.",
    BOAT_LOGRAFT = "Boat at your own risk.",
    SANDBAGSMALL_ITEM = "Floodproof.",
    WALL_LIMESTONE = "Tough wall segments.",
    GOLDNUGGET = "Gold! Gold! Gold!",
    BOOK_METEOR = "And the sky shall rain fire!",
    BLUBBERSUIT = "A disgusting way to stay dry.",
    BOAT_TORCH = "See, at sea.",
    PRIMEAPEBARREL = "More monkeys!",
    MONKEYBALL = "Get down to monkey business.",
    WILDBOREHOUSE = "Pig out!",
    DRAGOONDEN = "Enter the Dragoon's Den.",
    BOAT_SURFBOARD = "Hang ten!",
    DOUBLE_UMBRELLAHAT = "Definitely function over fashion.",
    SHARK_TEETHHAT = "Look formidable on the seas.",
    CHEFPACK = "Freshen up your foodstuffs.",
    -- PORTABLECOOKPOT_ITEM = "Better than any takeaway food.",
    BUOY = "Mark your place in the water.",
    WIND_CONCH = "The gales come early.",
    SAILSTICK = "May the wind be always at your back.",
    TURF_SNAKESKIN = "Really ties the room together.",
    DOYDOYNEST = "Just doy it.",
    SHIPWRECKED_ENTRANCE = "Take a vacation. Go somewhere less awful.",
    WOODLEGSHAT = "Sniff out treasures.",
    BOAT_WOODLEGS = "Go do some pirate stuff.",
    OX_FLUTE = "Make the world weep.",
    OXHAT = "Shell out for some poison protection.",
    BOOK_METEOR = "On comets, meteors and eternal stardust.",
    PALMLEAF_UMBRELLA = "Posh & portable tropical protection.",
    QUACKERINGRAM = "Everybody better get out of your way!",
    TAR_EXTRACTOR = "This offshore rig knows the drill.",        
    SEA_YARD = "Keep your boats ship-shape!",
    SEA_CHIMINEA = "Fire that floats!",   
    FISH_FARM = "Grow your own fishfood with roe!",     
    TARLAMP = "A light for your hand, or for your boat!",
    TARSUIT = "The slickest way to stay dry.",
    SEA_LAB = "Unlock crafting recipes... at sea!",
    WATERCHEST = "Davy Jones' storage locker.",
    MUSSEL_BED = "Relocate your favorite mollusc.",
    QUACKENDRILL = "For Deep Sea Quacking.",
    TROPICALFAN = "Luxuriously soft, luxuriously tropical.",
  },

  TABS =
  {
    NAUTICAL = "Nautical",
    OBSIDIAN = "Obsidian",
  },

  PARROTNAMES =
  {
    "Danjaya",
    "Jean Claud Van Dan",
    "Donny Jepp",
    "Crackers",
    "Sully",
    "Reginald VelJohnson",
    "Dan Van 3000",
    "Van Dader",
    "Dirty Dan",
    "Harry",
    "Sammy",
    "Zoe",
    "Kris",
    "Trent",
    "Harrison",
    "Alethea",
    "Jonny Dregs",
    "Frankie",
    "Pollygon",
    "Vixel",
    "Hank",
    "Cutiepie",
    "Vegetable",
    "Scurvy",
    "Black Beak",
    "Octoparrot",
    "Migsy",
    "Amy",
    "Victoire",
    "Cornelius",
    "Long John",
    "Dr Hook",
    "Horatio",
    "Iago",
    "Wilde",
    "Murdoch",
    "Lightoller",
    "Boxhall",
    "Moody",
    "Phillips",
    "Fleet",
    "Barrett",
	"Wisecracker",
  },

  MERMNAMES =
  {
    "Glorpy",
    "Gloppy",
    "Blupper",
    "Glurtski",
    "Glummer",
    "Gluts",
    "Slerm",
    "Sloosher",
    "Slurnnious",
    "Brutter",
    "Glunt",
    "Mropt",
    "Shlorpen",
    "Blunser",
    "Fthhhhh",
    "Blort",
    "Slpslpslp",
    "Glorpen",
    "Rut Rut",
    "Mrwop",
    "Glipn",
    "Glert",
    "Sherpl",
    "Shlubber",

    "Christian",
    "Dan",
    "Drew",
    "Dave",
    "Jon",
    "Matt",
    "Nathan",
    "Vic",
  },

  BALLPHINNAMES=
  {
    "Miah",
    "Marius",
    "Brian",
    "Sushi",
    "Bait",
    "Chips",
    "Poseidon",
    "Flotsam",
    "Jetsam",
    "Seadog",
    "Gilly",
    "Fin",
	"Flipper",
    "Chum",
    "Seabreeze",
    "Tuna",
    "Sharky",
    "Wanda",
    "Neptune",
    "Seasalt",
    "Phlipper",
    "Miso",
    "Wasabi",
    "Jaws",
    "Babel",
    "Earl",
    "Fishi"
  },

  SHIPNAMES =
  {
    "Nautilus",
    "Mackay-Bennett",
    "Mary Celeste",
    "Beagle",
    "Monitor",
    "Santa Maria",
    "Bluenose",
    "Adriatic",
    "Nomadic",
    "Mauretania",
    "Endeavour",
    "Batavia",
    "Edmund Fitzgerald",
    "Pequod",
    "Mississinewa",
    "African Queen",
    "Mont-Blanc",
    "Anita Marie",
    "Caine",
    "Orca",
    "Pharaoh",
    "Nellie",
    "Piper Maru",
    "Minnow",
    "Syracusia",
    "Baron of Renfrew",
    "Ariel",
    "Blackadder",
    "Hispaniola",
    "Pelican",
    "Golden Hind",
    "Resolution",
	"Nina Clara",
	"Pinafore",
  },

  BORE_TALK_FOLLOWWILSON = {"YOU OK BY ME", "I LOVE FRIEND", "YOU IS GOOD", "I FOLLOW!"},
  BORE_TALK_FIND_LIGHT = {"SCARY", "NO LIKE DARK", "WHERE IS SUN?", "STAY NEAR FIRE", "FIRE IS GOOD"},
  BORE_TALK_LOOKATWILSON = {"WHO ARE YOU?", "YOU NOT BORE.", "UGLY MONKEY MAN", "YOU HAS MEAT?"},
  BORE_TALK_RUNAWAY_WILSON = {"TOO CLOSE!", "STAY 'WAY!", "YOU BACK OFF!", "THAT MY SPACE."},
  BORE_TALK_FIGHT = {"I KILL NOW!", "YOU GO SMASH!", "RAAAWR!", "NOW YOU DUN IT!", "GO 'WAY!", "I MAKE YOU LEAVE!",},
  BORE_TALK_RUN_FROM_SPIDER = {"SPIDER BAD!", "NO LIKE SPIDER!", "SCARY SPIDER!"},
  BORE_TALK_HELP_CHOP_WOOD = {"KILL TREE!", "SMASH MEAN TREE!", "I PUNCH TREE!"},
  BORE_TALK_HELP_HACK = {"I HELP GET BUSH!", "I PUNCH BUSH!", "WE PUNCHIN' PLANTS NOW?"},
  BORE_TALK_ATTEMPT_TRADE = {"WHAT YOU GOT?", "BETTER BE GOOD.", "NO WASTE MY TIME."},
  BORE_TALK_PANIC = {"NOOOOO!", "TOO DARK! TOO DARK!", "AAAAAAAAAH!!"},
  BORE_TALK_PANICFIRE = {"HOT HOT HOT!", "OWWWWW!", "IT BURNS!"},
  BORE_TALK_FIND_MEAT = {"ME HUNGRY!", "YUM!", "I EAT FOOD!", "TIME FOR FOOD!"},
  BORE_TALK_EAT_MEAT = {"NOM NOM NOM", "YUM!"},
  BORE_TALK_GO_HOME = {"HOME TIME!", "HOME! HOME!"},

  MERM_TALK_FIND_FOOD = {"Flut!", "Glort grolt flut.", "Florty glut."},
  MERM_TALK_PANIC = {"GLOP GLOP GLOP!", "GLORRRRRP!", "FLOPT! FTHRON!"},
  MERM_TALK_FIGHT = {"GLIE, FLORPY FLOPPER!", "NO! G'WUT OFF, GLORTER!", "WULT FLROT, FLORPER!"},
  MERM_TALK_RUNAWAY = {"Florpy glrop glop!", "GLORP! GLOPRPY GLUP!", "Glut glut flrop!"},
  MERM_TALK_GO_HOME = {"Wort wort flrot.", "Wrut glor gloppy flort."},
  MERM_TALK_FISH = {"Blut flort.", "Glurtsu gleen.", "Blet blurn."},

  BALLPHIN_TALK_FOLLOWWILSON = {"EE!! EE!!", "EEEE!", "EEE, EE?", "EE EEE EE"},
  BALLPHIN_TALK_HOME = {"NEEEEE!!", "Nee! NEe!", "NEE! NEE!"},
  BALLPHIN_TALK_FIND_LIGHT = {"EEEK! EEEK!", "EEK EEK EEK!"},
  BALLPHIN_TALK_PANIC = {"EEEEEEEEH!!", "EEEEEEEEE!!"},
  BALLPHIN_TALK_FIND_MEAT = {"Eee?", "Eee eee ee?", "Ee, ee?"},
  BALLPHIN_TALK_HELP_MINE_CORAL = {"KEEEEEE!", "KEE! KEE!", "KEEE!"},

  SUNKEN_BOAT_SQUAWKS = {"Squaak!", "Raaawk!"},
  SUNKEN_BOAT_REFUSE_TRADE = {"Sqwaak! Useless junk!", "Go away! Sqwaak!", "Wolly does NOT want THAT.", "Land lubber!"},
  SUNKEN_BOAT_ACCEPT_TRADE = {"Thanks, matey!", "A fair trade!", "Yaarr. Thanks buddy."},
  SUNKEN_BOAT_IDLE = 
  {
    "Sqwaaaak!",
    "Where's me treasures?",
    "Wolly wants a cracker.",
    "Abandon ship! Abandon ship!",
    "Thar she blows!",
    "Treasures from the sea?",
    "Lost! Lost! Waaark? Lost!",
    "The treasure's going down!",
  },

  RAWLING =
  {
    in_inventory =
    {
      "Let's cut the bottom out of the basket.",
    },

    equipped =
    {
      "You can carry me. For a couple of steps.",
      "Is this some kind of Canadian joke?",
      "Feel \"free\" to throw me.",
    },

    on_thrown =
    {
      "To the peach basket!",
      "Shoot!",
      "You miss 100% of the shots you don't take!",
      "I believe I can fly!",
    },

    on_ground =
    {
      "I could use a little pick me up.",
    },

    in_container =
    {
      "This isn't a peach basket...",
    },

    on_pickedup=
    {
      "Is that you, James?",
      "You're MY MVP!",
    },

    on_dropped=
    {
      "Dribble me!",
    },

    on_ignite =
    {
      "I'm on fire!",
      "Ow ow ow ow ow!",
    },

    on_extinguish =
    {
      "Saved!",
    },

    on_bounced =
    {
      "Ouch!",
      "Nothin' but peaches!",
      "Splish!",
      "Rejected!",
    },

    on_hit_water =
    {
      "Swish!",
    },
  },

  TALKINGBIRD =
  {
    in_inventory =
    {
      "Adventure!",
      "You stink!",
      "SQUAAAWK!",
      "Hey you!",
      "Chump!",
      "Nerd!",
      "Treasure!",
      "Walk the plank!",
      "Cracker!",
    },

    in_container =
    {
      "Don't bury me!",
      "Out, out!",
      "Sunk!",
      "Me eyes! Me eyes!",
      "Too dark!",
    },

    on_ground =
    {
      "Nice one!",
      "Chump!",
      "Big head!",
      "You stink!",
    },

    on_pickedup =
    {
      "Chump!",
      "Hello!",
      "Feed me!",
      "I'm hungry!",
      "Ouch!",
    },

    on_dropped =
    {
      "Chump!",
      "Bye now!",
      "See ya chump!",
      "Goodbye!",
    },

    on_mounted =
    {
      "Onward!",
      "Uh-oh!",
      "Are you sure about this?",
    },

    on_dismounted =
    {
      "Land!",
      "Solid ground!",
      "We made it!",
    },

    other_owner =
    {
      "Help!",
      "Ack!",
      "Scurvy!",
      "Save me!",
      "I'm okay!",
    },
  },
  
  
  UI = {
	WORLDGEN_IA = {
	  VERBS = {
		-- "Keelhauling",
		"Inundating with",
		"Setting course for",
		"Hoisting",
	  },
	  NOUNS = {
		"jungle...",
		"deep, dark waters...",
		"palms...",
		"snakes...",
		"sea monsters...",
		"a bottle of rum...",
		"fish heads...",
		"chests and chests of dubloons...",
		"chatty parrots...",
		"seafood...",
		"vast ocean...",
		"thalassophobia...",
		"jetsam...",
	  },
	},
    CRAFTING = {
      NEEDSEALAB = "Use a sea lab to build a prototype!",
	},
    CUSTOMIZATIONSCREEN = {
        PRIMARYWORLDTYPE = "World Type",
        ISLANDQUANTITY = "Island Quantity",
        ISLANDSIZE = "Island Size",
        VOLCANO = "Volcano",
        DRAGOONEGG = "Dragoon Eggs",
        TIDES = "Tides",
        FLOODS = "Floods",
        OCEANWAVES = "Waves",
        POISON = "Poison",
        BERMUDATRIANGLE = "Electric Isosceles",
		
		FISHINHOLE = "Shoals",
		SEASHELL = "Seashells",
		BUSH_VINE = "Viney Bushes",
		SEAWEED = "Seaweeds",
		SANDHILL = "Sandy Piles",
		CRATE = "Crates",
		BIOLUMINESCENCE = "Bioluminescence",
		CORAL = "Corals",
		CORAL_BRAIN_ROCK = "Brainy Sprouts",
        BAMBOO = "Bamboo",
		TIDALPOOL = "Tidal Pools",
		POISONHOLE = "Poisonous Holes",
		
		SWEET_POTATO = "Sweet Potatoes",
		LIMPETS = "Limpets",
        MUSSEL_FARM = "Mussels",
		
		WILDBORES = "Wildbores",
		WHALEHUNT = "Whaling",
		CRABHOLE = "Crabbits",
		OX = "Water Beefalos",
		SOLOFISH = "Dogfish",
		DOYDOY = "Doydoys",
        JELLYFISH = "Jellyfish",
		LOBSTER = "Wobsters",
		SEAGULL = "Seagulls",
		BALLPHIN = "Ballphins",
		PRIMEAPE = "Prime Apes",
		
        SHARX = "Sea Hounds",
		CROCODOG = "Crocodogs",
		TWISTER = "Sealnado",
		TIGERSHARK = "Tiger Sharks",
		KRAKEN = "Quacken",
		FLUP = "Flup",
		MOSQUITO = "Poison Mosquitos",
		SWORDFISH = "Swordfish",
		STUNGRAY = "Stink Rays",
		PRESETLEVELS = {
			SURVIVAL_SHIPWRECKED_CLASSIC = "Shipwrecked",
		},
		PRESETLEVELDESC = {
			SURVIVAL_SHIPWRECKED_CLASSIC = "A world of (almost) exclusively Shipwrecked content.",
		},
		TASKSETNAMES = {
			ISLANDADVENTURES = "Islands",
		},
    },
    SANDBOXMENU = {
		IA_NOCAVES_TITLE = "No Cave Entrances!",
		IA_NOCAVES_BODY = "Island-only worlds don't have cave entrances (unless you got an add-on mod for that).\nDo you want to remove the caves from this server?",
		ADDLEVEL_WARNING_IA = "Island-only worlds don't have cave entrances (unless you got an add-on mod for that).\nYou might not be able to access the caves!",
        CUSTOMIZATIONPREFIX_IA = "Island ", --Please note that the space is intentional, so translations may use hyphons or whatever -M
        SLIDEVERYRARE = "Much Less",
        WORLDTYPE_DEFAULT = "Forest",
        WORLDTYPE_MERGED = "Merged",
        WORLDTYPE_ISLANDS = "Islands",
        WORLDTYPE_ISLANDSONLY = "Islands Only",
        IA_START = "Island Adventures",
    },
  },
}
