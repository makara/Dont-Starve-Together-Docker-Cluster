
local function OnCreate(inst, scenariorunner)
	if inst == nil or inst.components.container == nil then
		return
	end

	inst.components.boathealth:SetPercent(GetRandomWithVariance(0.48, 0.1))

	local pt = inst:GetPosition()
	
	if math.random() < 0.99 then
		local choices = {"sail_palmleaf", "sail_cloth"}
		local sail = SpawnPrefab( choices[math.random(#choices)] )
		if sail then
			sail.Transform:SetPosition(pt.x + 1, 0, pt.z + 1.8)
			sail.components.fueled:SetPercent(GetRandomWithVariance(0.3, 0.1))
			--inst.components.boatequip:EquipSail(sail) --This does not seem to work, not critical though
		end
	end

	if math.random() < 0.9 then
		local lantern = SpawnPrefab("boat_lantern")
		if lantern then
			lantern.Transform:SetPosition(pt.x - 1.5, 0, pt.z - .5)
			lantern.components.fueled:SetPercent(GetRandomWithVariance(0.25, 0.1))
			-- inst.components.boatequip:EquipLamp(lantern)
			-- lantern.components.equippable:ToggleOff() --TODO
		end
	end
end

return
{
	OnCreate = OnCreate
}