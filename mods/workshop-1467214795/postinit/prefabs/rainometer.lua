local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local function DoCheckRain(inst)
	if not inst:HasTag("burnt") and inst:HasTag("flooded") then
		if inst.task ~= nil then
			inst.task:Cancel()
			inst.task = nil
		end
		inst.AnimState:SetPercent("meter", 1)
	end
end

local function onStartFlooded(inst)
	if not inst.floodtask then
		inst.floodtask = inst:DoPeriodicTask(4, DoCheckRain)
	end
end

local function onStopFlooded(inst)
	if inst.floodtask then
		inst.floodtask:Cancel()
		inst.floodtask = nil
	end
	inst:PushEvent("animover") --hopefully this doesn't need any event data
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddPrefabPostInit("rainometer", function(inst)


inst:AddComponent("floodable")

if TheWorld.ismastersim then

	inst.components.floodable:SetFX("shock_machines_fx",5)
	inst.components.floodable.onStartFlooded = onStartFlooded
	inst.components.floodable.onStopFlooded = onStopFlooded

end


end)
