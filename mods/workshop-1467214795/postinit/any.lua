local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

---------------------------------------------------------------------------------------------------------------------------------------------

local LIGHT = "LIGHT"
local MEDIUM = "MEDIUM"
local HEAVY = "HEAVY"

local addBlowInWind = {
	acorn = MEDIUM,
	balloon = LIGHT,
	butterflywings = LIGHT,
	charcoal = LIGHT,
	cutgrass = LIGHT,
	cutreeds = LIGHT,
	egg = MEDIUM,
	featherfan = LIGHT,
	feather_crow = LIGHT,
	feather_robin = LIGHT,
	feather_robin_winter = LIGHT,
	feather_canary = LIGHT,
	flint = MEDIUM,
	fish = MEDIUM,
	flint = HEAVY,
	froglegs = MEDIUM,
	gears = HEAVY,
	goldnugget = MEDIUM, --SW says log is heavier than goldnugget
	goose_feather = LIGHT,
	heatrock = HEAVY,
	rocks = HEAVY,
	ice = MEDIUM,
	livinglog = HEAVY,
	log = HEAVY,
	lureplantbulb = HEAVY,
	meat = MEDIUM,
	cookedmeat = MEDIUM,
	meat_dried = MEDIUM,
	smallmeat = LIGHT,
	cookedsmallmeat = LIGHT,
	smallmeat_dried = LIGHT,
	monstermeat = MEDIUM,
	cookedmonstermeat = MEDIUM,
	monstermeat_dried = MEDIUM,
	green_cap = LIGHT,
	green_cap_cooked = LIGHT,
	red_cap = LIGHT,
	red_cap_cooked = LIGHT,
	blue_cap = LIGHT,
	blue_cap_cooked = LIGHT,
	nightmarefuel = LIGHT,
	nitre = MEDIUM,
	papyrus = LIGHT,
	petals = LIGHT,
	petals_evil = LIGHT,
	pinecone = LIGHT,
	poop = MEDIUM,
	rope = LIGHT,
	seeds = LIGHT,
	silk = LIGHT,
	spidergland = MEDIUM,
	spoiledfood = MEDIUM,
	stinger = LIGHT,
	torch = MEDIUM,
	transistor = MEDIUM,
	twigs = LIGHT,
	umbrella = LIGHT,
	--screw typing out all the vegetables TODO make a loop similiar to their prefab file
}

local neveronwater = {
	walrus_camp = true,
	evergreen = true,
	pinecone_sapling = true,
	evergreen_sparse = true,
	lumpy_sapling = true,
	twiggytree = true,
	twiggy_nut_sapling = true,
	deciduoustree = true,
	acorn_sapling = true,
	livingtree_sapling = true,
	sapling = true,
	grass = true,
}
local function RemoveOnWater(inst)
	if IsOnWater(inst) then
		inst:Remove()
	end
end

---------------------------------------------------------------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
---------------------------------------------------------------------------------------------------------------------------------------------

IAENV.AddPrefabPostInitAny(function(inst)


if inst and TheWorld.ismastersim then
    --if this list gets larger we can modify this a bit.
    if (inst.prefab == "wx78" or inst.prefab == "abigail"
	or inst:HasTag("shadow") or inst:HasTag("chess") )
	and inst.poisonimmune ~= false then inst.poisonimmune = true end

    if inst.components and inst.components.combat and inst.components.health and not inst.poisonimmune and not inst.components.poisonable then
        if inst:HasTag("player") then
            MakePoisonableCharacter(inst, nil, nil, "player", 0, 0, 1)
            inst.components.poisonable.duration = TUNING.TOTAL_DAY_TIME * 3
            inst.components.poisonable.transfer_poison_on_attack = false
        else
            MakePoisonableCharacter(inst)
        end
    end
	
	if addBlowInWind[inst.prefab] then
		MakeBlowInHurricane(inst, TUNING.WINDBLOWN_SCALE_MIN[addBlowInWind[inst.prefab]], TUNING.WINDBLOWN_SCALE_MAX[addBlowInWind[inst.prefab]])
	end

	if neveronwater[inst.prefab] then
		inst:DoTaskInTime(0,RemoveOnWater)
	end

    if inst.prefab == "fish" or inst.prefab == "fish_cooked" then
        inst:AddTag("packimfood")
    end
    if inst.prefab == "tornado" then
        inst:AddTag("amphibious")
    end

    if inst:HasTag("SnowCovered") then
        if not inst.components.climatetracker then
			inst:AddComponent("climatetracker")
		end

        --objects that move between climates now properly update being snow covered.
        inst:ListenForEvent("climatechange", function(inst, data)
            if not IsInIAClimate(inst) and TheWorld.state.issnowcovered then
                inst.AnimState:Show("snow")
            else
                inst.AnimState:Hide("snow")
            end
        end)
    end

end

if inst then
    if inst:HasTag("bird") then
        inst:AddTag("amphibious")
    end
end

end)
