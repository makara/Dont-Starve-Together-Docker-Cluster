local function installIAcomponents(inst)
	print("Loading world with IA:",inst:HasTag("forest") and "Has Forest" or "No Forest",inst:HasTag("island") and "Has Islands" or "No Islands")
	if inst.ismastersim then
		if inst:HasTag("island") then
			--inst:AddComponent('tiled')
			inst:AddComponent("worldislandtemperature")
			inst:AddComponent("tigersharker")
			inst:AddComponent("rainbowjellymigration")
			inst:AddComponent("wavemanager_ia") --this excludes visuals, those are clientside only
			inst:AddComponent("chessnavy")
			inst:AddComponent("whalehunter")
			inst:AddComponent("twisterspawner")
			inst:AddComponent("floodmosquitospawner")
			inst:AddComponent("hailrain")
			--inst:AddSpoofedComponent("worldshorecollisions", "shorecollisions")
		end
		inst:AddComponent("doydoyspawner")
	end
	if inst:HasTag("island") then
		inst:AddComponent("flooding")
		GLOBAL.TileState_GroundCreep = true
		if inst.net and inst.net.components.weather then
			inst.net.components.weather.cannotsnow = true
		end
	end
	inst.installIAcomponents = nil --self-destruct after use
end

--------------------------------------------------------------------------

AddPrefabPostInit("world", function(inst)

--------------------------------------------------------------------------

inst.installIAcomponents = installIAcomponents

local OnPreLoad_old = OnPreLoad
inst.OnPreLoad = function(...)
	local primaryworldtype = inst.topology and inst.topology.overrides and inst.topology.overrides.primaryworldtype 
	if not inst.topology or not inst.topology.ia_worldgen_version then primaryworldtype = "merged" end --pre-RoT fix

	if primaryworldtype then
		if primaryworldtype ~= "default" and inst:HasTag("forest") then --crude caves fix
			inst:AddTag("island")
		end
		if primaryworldtype ~= "default" and primaryworldtype ~= "merged" then
			inst:RemoveTag("forest")
		end
	end

	if inst.installIAcomponents then
		inst:installIAcomponents()
	end

	return OnPreLoad_old and OnPreLoad_old(...)
end

--------------------------------------------------------------------------

end)
