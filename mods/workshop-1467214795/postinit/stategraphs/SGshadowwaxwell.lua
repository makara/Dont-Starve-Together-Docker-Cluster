local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------


IAENV.AddStategraphState("shadowmaxwell",State{

	name = "embark_shadow",
	tags = { "boating", "nointerrupt", "jumping", "moving", "busy", "canrotate", "nomorph", "amphibious"},

	onenter = function(inst, pos)
		inst.Physics:ClearCollidesWith(COLLISION.LIMITS) --R08_ROT_TURNOFTIDES
		inst.components.locomotor:StopMoving()
		--inst.components.locomotor:EnableGroundSpeedMultiplier(false)
		inst.AnimState:PlayAnimation("jumpboat") --24 * FRAMES
		inst.AnimState:PushAnimation("landboat", false)
		-- inst.SoundEmitter:PlaySound("ia/common/boatjump_whoosh")

		inst.sg.statemem.startpos = inst:GetPosition()
		inst.sg.statemem.targetpos = pos

		if inst.components.health ~= nil then
			inst.components.health:SetInvincible(true)
		end
	end,

	onexit = function(inst)
		inst.Physics:CollidesWith(COLLISION.LIMITS) --R08_ROT_TURNOFTIDES
		inst.components.locomotor:Stop()
		--inst.components.locomotor:EnableGroundSpeedMultiplier(true)
		if inst.components.health ~= nil then
			inst.components.health:SetInvincible(false)
		end
	end,

	events =
	{
		EventHandler("animover", function(inst)
			if inst.AnimState:AnimDone() then
				--end of landboat
				inst.components.locomotor:Stop()
				inst.sg:GoToState("idle")
			end
		end),
	},

	timeline =
	{
		TimeEvent(7 * FRAMES, function(inst)
			inst:ForceFacePoint(inst.sg.statemem.targetpos:Get())
			local dist = inst:GetPosition():Dist(inst.sg.statemem.targetpos)
			local speed = dist / (18/30)
			inst.Physics:SetMotorVelOverride(1 * speed, 0, 0)
			
			SpawnAt("sanity_raise", inst.sg.statemem.targetpos)
		end),
		TimeEvent(20 * FRAMES, function(inst)
			SpawnAt("statue_transition_2", inst.sg.statemem.targetpos)
		end),
		TimeEvent(22 * FRAMES, function(inst)
			if not inst.boat then
				inst.boat = SpawnAt("shadowwaxwell_boat", inst.sg.statemem.targetpos)
			end
		end),
		TimeEvent(24 * FRAMES, function(inst)
			--end of jumpboat
			-- inst:PerformBufferedAction()
			inst.Transform:SetPosition(inst.sg.statemem.targetpos:Get())
			inst.Physics:Stop()
			inst.components.locomotor:Stop()

			inst:AddTag("aquatic")
			inst:AddTag("sailing")
			inst.components.locomotor.hasmomentum = true

			if inst.boat then
				-- inst.SoundEmitter:PlaySound(inst.boat.landsound)
				--attach boat code
				-- inst.boat = inst.boat
				inst.boat.sailor = inst
				inst.boat.Physics:Teleport(0, -0.1, 0)
				inst:AddChild(inst.boat)
			end
		end),
	},
})

IAENV.AddStategraphState("shadowmaxwell",State{

	name = "disembark_shadow",
	tags = { "boating", "nointerrupt", "jumping", "moving", "busy", "canrotate", "nomorph", "amphibious"},

	onenter = function(inst, pos)
		inst.Physics:ClearCollidesWith(COLLISION.LIMITS) --R08_ROT_TURNOFTIDES
		inst.components.locomotor:StopMoving()
		--inst.components.locomotor:EnableGroundSpeedMultiplier(false)
		inst.AnimState:PlayAnimation("jumpboat") --24 * FRAMES
		inst.AnimState:PushAnimation("landboat", false)
		-- inst.SoundEmitter:PlaySound("ia/common/boatjump_whoosh")

		inst.sg.statemem.startpos = inst:GetPosition()
		inst.sg.statemem.targetpos = pos

		if inst.components.health ~= nil then
			inst.components.health:SetInvincible(true)
		end

		if inst.boat then
			inst:RemoveChild(inst.boat)
			inst.boat.Physics:Teleport(inst.sg.statemem.startpos:Get())
		end
	end,

	onexit = function(inst)
		inst.Physics:CollidesWith(COLLISION.LIMITS) --R08_ROT_TURNOFTIDES
		inst.components.locomotor:Stop()
		--inst.components.locomotor:EnableGroundSpeedMultiplier(true)
		if inst.components.health ~= nil then
			inst.components.health:SetInvincible(false)
		end
	end,

	events =
	{
		EventHandler("animover", function(inst)
			if inst.AnimState:AnimDone() then
				--end of landboat
				inst.components.locomotor:Stop()
				inst.sg:GoToState("idle")
			else
				--end of jumpboat
				inst.Transform:SetPosition(inst.sg.statemem.targetpos:Get())
				inst.Physics:Stop()
				inst.components.locomotor:Stop()
				
				-- inst:PerformBufferedAction()
				inst:RemoveTag("aquatic")
				inst:RemoveTag("sailing")
				-- inst.components.locomotor:RemoveExternalSpeedAdder(boat, "SAILOR")
				inst.components.locomotor.hasmomentum = false
			end
		end),
	},

	timeline =
	{
		TimeEvent(7 * FRAMES, function(inst)
			inst:ForceFacePoint(inst.sg.statemem.targetpos:Get())
			local dist = inst:GetPosition():Dist(inst.sg.statemem.targetpos)
			local speed = dist / (18/30)
			inst.Physics:SetMotorVelOverride(1 * speed, 0, 0)
		end),
		TimeEvent(9 * FRAMES, function(inst)
			-- SpawnAt("statue_transition", inst.sg.statemem.startpos)
			SpawnAt("statue_transition_2", inst.sg.statemem.startpos)
		end),
		TimeEvent(12 * FRAMES, function(inst)
			if inst.boat then
				inst.boat:Remove()
				inst.boat = nil
			end
		end),
	},
})


IAENV.AddStategraphState("shadowmaxwell",State{

	name = "row_start_ia",
	tags = {"moving", "running", "boating", "canrotate"},

	onenter = function(inst)
		inst.components.locomotor:RunForward()
		inst.AnimState:PlayAnimation("row_pre")
	end,

	events =
	{
		EventHandler("animover", function(inst)
			if inst.AnimState:AnimDone() then
				inst.sg:GoToState("row_ia")
			end
		end),
	},
})
IAENV.AddStategraphState("shadowmaxwell",State{

	name = "row_ia",
	tags = {"moving", "running", "boating", "canrotate"},

	onenter = function(inst)
		inst.components.locomotor:RunForward()
		if not inst.AnimState:IsCurrentAnimation("row_loop") then
			inst.AnimState:PlayAnimation("row_loop", true)
		end
		inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())
	end,

	ontimeout = function(inst)
		inst.sg:GoToState("row_ia")
	end,
})
IAENV.AddStategraphState("shadowmaxwell",State{

	name = "row_stop_ia",
	tags = {"canrotate", "idle"},

	onenter = function(inst)
		inst.components.locomotor:Stop()
		inst.AnimState:PlayAnimation("row_pst")
	end,

	events =
	{
		EventHandler("animover", function(inst)
			if inst.AnimState:AnimDone() then
				inst.sg:GoToState("idle")
			end
		end),
	},
})

IAENV.AddStategraphState("shadowmaxwell",State{

	name = "sail_start_ia",
	tags = {"moving", "running", "boating", "canrotate"},

	onenter = function(inst)
		inst.components.locomotor:RunForward()
		inst.AnimState:PlayAnimation("sail_pre")
	end,

	events =
	{
		EventHandler("animover", function(inst)
			if inst.AnimState:AnimDone() then
				inst.sg:GoToState("sail_ia")
			end
		end),
	},
})
IAENV.AddStategraphState("shadowmaxwell",State{

	name = "sail_ia",
	tags = {"moving", "running", "boating", "sailing", "canrotate"},

	onenter = function(inst)
		inst.components.locomotor:RunForward()
		if not inst.AnimState:IsCurrentAnimation("sail_loop") then
			inst.AnimState:PlayAnimation("sail_loop", true)
		end
		inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())
	end,

	ontimeout = function(inst)
		inst.sg:GoToState("sail_ia")
	end,
})
IAENV.AddStategraphState("shadowmaxwell",State{

	name = "sail_stop_ia",
	tags = {"canrotate", "idle"},

	onenter = function(inst)
		inst.components.locomotor:Stop()
		inst.AnimState:PlayAnimation("sail_pst")
	end,

	events =
	{
		EventHandler("animover", function(inst)
			if inst.AnimState:AnimDone() then
				inst.sg:GoToState("idle")
			end
		end),
	},
})



local event_locomote_old
local function locomote_handler(inst)

	if inst.sg:HasStateTag("nointerrupt") then return end

	local is_moving = inst.sg:HasStateTag("moving")
	local should_move = inst.components.locomotor:WantsToMoveForward()

	local leader = inst.components.follower and inst.components.follower:GetLeader()
	local leaderHasSail = leader and leader.sg and leader.sg:HasStateTag("sailing")
	local hasSail = inst.sg:HasStateTag("sailing")

	if not inst.sg:HasStateTag("busy") and not inst:HasTag("busy") and inst.boat then
		if not inst.sg:HasStateTag("attack") then
			if is_moving and not should_move then
				inst.sg:GoToState(hasSail and "sail_stop_ia" or "row_stop_ia")
			elseif not is_moving and should_move then
				inst.sg:GoToState(leaderHasSail and "sail_start_ia" or "row_start_ia")
			end
		end
		return
	end
	
	return event_locomote_old(inst)
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddStategraphPostInit("shadowmaxwell", function(sg)


event_locomote_old = sg.events["locomote"].fn
sg.events["locomote"].fn = locomote_handler


end)
