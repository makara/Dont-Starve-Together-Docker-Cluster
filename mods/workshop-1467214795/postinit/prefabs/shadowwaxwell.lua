local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local function embarkboat(inst, data)
	local pos
	if data.target then --the boat the leader is trying to embark
		local target_pt = data.target:GetPosition()
		local offset = FindWaterOffset(target_pt, data.target:GetAngleToPoint(inst:GetPosition()) + ((math.random() * .4)-.2)*PI, 5, 36)
		if offset then
			pos = target_pt + offset
		end
	end
	if not pos then
		local target_pt = inst.components.follower:GetLeader() and inst.components.follower:GetLeader():GetPosition() or inst:GetPosition()
		local offset = FindWaterOffset(target_pt, math.random() * 2*PI, 5, 36)
		if offset then
			pos = target_pt + offset
		end
	end
	if pos then
		inst.sg:GoToState("embark_shadow", pos)
	end
end

local function disembarkboat(inst, data)
	if data.boat_to_boat then return end
	local pos
	local inst_pt = inst:GetPosition()
	if data.pos then
		local offset = FindGroundOffset(inst_pt, inst:GetAngleToPoint(data.pos) + ((math.random() * .4)-.2)*PI, 5, 36)
		if offset then
			pos = inst_pt + offset
		end
	end
	if not pos then
		local target_pt = inst.components.follower:GetLeader() and inst.components.follower:GetLeader():GetPosition() or inst:GetPosition()
		local offset = FindGroundOffset(target_pt, math.random() * 2*PI, 5, 36)
		if offset then
			pos = target_pt + offset
		end
	end
	if pos then
		inst.sg:GoToState("disembark_shadow", pos)
	end
end

local function stopfollowing(inst, data)
    if data.leader then
        inst:RemoveEventCallback("embarkboat", inst.embarkboat, data.leader)
        inst:RemoveEventCallback("disembarkboat", inst.disembarkboat, data.leader)
    end
end
local function startfollowing(inst, data)
    if data.leader then
        inst:ListenForEvent("embarkboat", inst.embarkboat, data.leader)
        inst:ListenForEvent("disembarkboat", inst.disembarkboat, data.leader)
    end
end

local function onremove(inst)
	if inst.boat then
		-- SpawnAt("statue_transition", inst.boat)
		SpawnAt("statue_transition_2", inst.boat)
		inst.boat.sailor = nil
		inst.boat:DoTaskInTime(3 * FRAMES, inst.boat.Remove)
	end
end

local function onspawn(inst)
	if IsOnWater(inst) and not inst.boat then
		inst:AddTag("aquatic")
		inst:AddTag("sailing")
		-- inst.components.locomotor:SetExternalSpeedAdder(boat, "SAILOR", boat.components.sailable.movementbonus)
		inst.components.locomotor.hasmomentum = true

		inst.boat = SpawnPrefab("shadowwaxwell_boat")
		inst.boat.sailor = inst
		inst.boat.Physics:Teleport(0, -0.1, 0)
		inst:AddChild(inst.boat)
	end
end

local nodebrisdmg
local function nodebrisdmg_ia(inst, amount, overtime, cause, ignore_invincible, afflicter, ...)
	return nodebrisdmg and nodebrisdmg(inst, amount, overtime, cause, ignore_invincible, afflicter, ...)
		or cause == "coconut" --might need afflicter tags in the future -M
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

local function fn(inst)


inst.AnimState:OverrideSymbol("paddle", "swap_paddle", "paddle")
inst.AnimState:OverrideSymbol("wake_paddle", "swap_paddle", "wake_paddle")


if TheWorld.ismastersim then

	if inst.components.health then
		nodebrisdmg = inst.components.health.redirect
		inst.components.health.redirect = nodebrisdmg_ia
	end

	inst.embarkboat = function(leader, data) return embarkboat(inst, data) end
	inst.disembarkboat = function(leader, data) return disembarkboat(inst, data) end
	inst:ListenForEvent("startfollowing", startfollowing)
	inst:ListenForEvent("stopfollowing", stopfollowing)
	inst:ListenForEvent("onremove", onremove)

	inst:DoTaskInTime(0, onspawn)

end


end

IAENV.AddPrefabPostInit("shadowlumber", fn)
IAENV.AddPrefabPostInit("shadowminer", fn)
IAENV.AddPrefabPostInit("shadowdigger", fn)
IAENV.AddPrefabPostInit("shadowduelist", fn)
