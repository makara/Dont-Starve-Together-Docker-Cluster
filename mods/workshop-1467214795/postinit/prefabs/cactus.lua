local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local _makeemptyfn
local function makeemptyfn(inst, ...)
	inst.components.hackable.canbehacked = false
	if _makeemptyfn then _makeemptyfn(inst, ...) end
end
local function makeemptyfn_hackable(inst)
	inst.components.pickable:MakeEmpty() -- This does everything for us
end

local _makebarrenfn
local function makebarrenfn(inst, ...)
	inst.components.hackable.canbehacked = false
	if _makebarrenfn then _makebarrenfn(inst, ...) end
end
local function makebarrenfn_hackable(inst)
	inst.components.pickable:MakeBarren() -- This does everything for us
end

local _onpickedfn
local function onpickedfn(inst, ...)
	inst.components.hackable.canbehacked = false
	if _onpickedfn then _onpickedfn(inst, ...) end
end

local function onfinishfn_hackable(inst, doer, loot)
	doer.SoundEmitter:PlaySound("dontstarve/wilson/harvest_sticks")
	if inst.has_flower and doer and doer.components.inventory then
		local flower = SpawnPrefab("cactus_flower")
		if flower then
			if flower.components.inventoryitem then
				flower.components.inventoryitem:InheritMoisture(TheWorld.state.wetness, TheWorld.state.iswet)
			end
			doer.components.inventory:GiveItem(flower, nil, inst:GetPosition())
		end
	end
	inst.components.pickable:Pick(inst) -- Purposefully no valid doer given to avoid damage & double loot
end

local _onregenfn
local function onregenfn(inst, ...)
	inst.components.hackable:Regen()
	if _onregenfn then _onregenfn(inst, ...) end
end

----------------------------------------------------------------------------------------

local function postinitfn(inst)


if TheWorld.ismastersim then

	inst:AddComponent("hackable")
	inst.components.hackable:SetUp("cactus_meat")
	inst.components.hackable.max_cycles = 127 -- dirty, but realistically speaking, never reached anyways
	inst.components.hackable.cycles_left = 127
	inst.components.hackable.hacksleft = 1
	inst.components.hackable.maxhacks = 1
	
	_makeemptyfn = inst.components.pickable.makeemptyfn
	inst.components.pickable.makeemptyfn = makeemptyfn
	inst.components.hackable.makeemptyfn = makeemptyfn_hackable
	
	_makebarrenfn = inst.components.pickable.makebarrenfn
	inst.components.pickable.makebarrenfn = makebarrenfn
	inst.components.hackable.makebarrenfn = makebarrenfn_hackable
	
	_onpickedfn = inst.components.pickable.onpickedfn
	inst.components.pickable.onpickedfn = onpickedfn
	
	inst.components.hackable.onfinishfn = onfinishfn_hackable
	
	_onregenfn = inst.components.pickable.onregenfn
	inst.components.pickable.onregenfn = onregenfn
	
end


end

IAENV.AddPrefabPostInit("cactus", postinitfn)
IAENV.AddPrefabPostInit("oasis_cactus", postinitfn)
