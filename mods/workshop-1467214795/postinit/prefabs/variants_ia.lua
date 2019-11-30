local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local function IsOnIATurf(inst)
	local tile = TheWorld.Map:GetTileAtPoint(inst:GetPosition():Get())
	--Hardcode beach because it is "climate neutral" for compatibility with old worlds (beach surrounds mainland) -M
	return CLIMATE_TURFS and tile and CLIMATE_TURFS.ISLAND[tile] or tile == GROUND.BEACH
end

----------------------------------------------------------------------------------------

local POSSIBLE_VARIANTS = {
	grass = {
		default = {build="grass1"},
		tropical = {build="grassgreen_build",testfn=IsOnIATurf},
	},
	krampus = {
		default = {build="krampus_build"},
		tropical = {build="krampus_hawaiian_build",testfn=IsInIAClimate},
	},
	butterfly = {
		default = {build="butterfly_basic",invimage="default"},
		tropical = {build="butterfly_tropical_basic",invimage="butterfly_tropical",testfn=IsInIAClimate},
	},
	cutgrass = {
		default = {build="cutgrass",invimage="default"},
		tropical = {build="cutgrassgreen",invimage="cutgrass_tropical"},
	},
	butterflywings = {
		default = {build="butterfly_wings",bank="butterfly_wings",invimage="default"},
		tropical = {build="butterfly_tropical_wings",bank="butterfly_tropical_wings",invimage="butterflywings_tropical"},
	},
	log = {
		default = {build="log",invimage="default"},
		tropical = {build="log_tropical",invimage="log_tropical",sourceprefabs={
			"palmtree",
			"jungletree",
			"mangrovetree",
			"livingjungletree",
			"leif_palm",
		}},
	},
	cave_banana = {
		default = {name="default",build="cave_banana",invimage="default"},
		tropical = {name="BANANA",build="bananas",invimage="bananas",sourceprefabs={
			"primeape",
			"primeapebarrel",
			"jungletree",
		}},
	},
	cave_banana_cooked = {
		default = {name="default",build="cave_banana",invimage="default"},
		tropical = {name="BANANA_COOKED",build="bananas",invimage="bananas_cooked"},
	},
}

----------------------------------------------------------------------------------------

local function fn(inst)


if TheWorld.ismastersim then

	if not inst.components.visualvariant then
		inst:AddComponent("visualvariant")
	end
	for k,v in pairs(POSSIBLE_VARIANTS[inst.prefab]) do
		--allow others to override us
		if not next(inst.components.visualvariant.possible_variants) then
			inst.components.visualvariant.possible_variants = POSSIBLE_VARIANTS[inst.prefab]
		elseif not inst.components.visualvariant.possible_variants[k] then
			inst.components.visualvariant.possible_variants[k] = v
		end
	end
	
end


end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

for k,v in pairs(POSSIBLE_VARIANTS) do
	IAENV.AddPrefabPostInit(k, fn)
end
