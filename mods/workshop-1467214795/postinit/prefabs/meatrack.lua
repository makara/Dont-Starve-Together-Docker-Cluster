local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local spec_meatrack_items = {
	seaweed = "seaweed",
	seaweed_dried = "seaweed_dried",
	fish_tropical = "tropical_fish",
	solofish_dead = "dogfish",
	swordfish_dead = "swordfish",
	fish_med = "fish_raw",
	fish_small = "fish_raw_small",
	jellyfish_dead = "jellyfish_dead",
	jellyjerky = "jellyjerky",
	rainbowjellyfish_dead = "jellyfish_dead",
}

local onstartdryingold
local function onstartdrying(inst, ingredient)
	onstartdryingold(inst, ingredient)

	if spec_meatrack_items[ingredient] then
		inst.AnimState:OverrideSymbol("swap_dried", "meat_rack_food_sw", spec_meatrack_items[ingredient])
	end
end

local ondonedryingold
local function ondonedrying(inst, product)
	ondonedryingold(inst, product)

	if spec_meatrack_items[product] then
		inst.AnimState:OverrideSymbol("swap_dried", "meat_rack_food_sw", spec_meatrack_items[product])
	end
end

local getstatus
local function getstatus_ia(inst)
	local ret = getstatus(inst)
	if IsInIAClimate(inst) then
		if ret:find("DRYINGINRAIN") then
			if not TheWorld.state.islandisraining then
				ret = ret:gsub("DRYINGINRAIN","DRYING")
			end
		elseif TheWorld.state.islandisraining then
			ret = ret:gsub("DRYING","DRYINGINRAIN")
		end
	end
	return ret
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddPrefabPostInit("meatrack", function(inst)


if TheWorld.ismastersim then

	onstartdryingold = inst.components.dryer.onstartdrying
	inst.components.dryer:SetStartDryingFn(onstartdrying)
	ondonedryingold = inst.components.dryer.ondonedrying
	inst.components.dryer:SetDoneDryingFn(ondonedrying)
	getstatus = inst.components.inspectable.getstatus
	inst.components.inspectable.getstatus = getstatus_ia
	
end


end)