local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

IAENV.AddStategraphPostInit("wilson_client", function(inst)


local TIMEOUT = 2

local DoFoleySounds

do
    local _run_start_timeevent_2 = inst.states["run_start"].timeline[2].fn
    DoFoleySounds = UpvalueHacker.GetUpvalue(_run_start_timeevent_2, "DoFoleySounds")
    UpvalueHacker.SetUpvalue(_run_start_timeevent_2, function(...) DoFoleySounds(...) end, "DoFoleySounds")
end


--STATEGRAPH PATCHES, not poluting this files namespace though.
do
    local _locomote_eventhandler = inst.events.locomote.fn
    inst.events.locomote.fn = function(inst, data)
        if inst.sg:HasStateTag("busy") or inst:HasTag("busy") then
            return
        end
        local is_attacking = inst.sg:HasStateTag("attack")

        local is_moving = inst.sg:HasStateTag("moving")
        local is_running = inst.sg:HasStateTag("running")
        local should_move = inst.components.locomotor:WantsToMoveForward()
        if inst.replica.sailor and inst.replica.sailor:GetBoat() and not inst.replica.sailor:GetBoat().replica.sailable then
            should_move = false
        end

        local should_run = inst.components.locomotor:WantsToRun()
        local hasSail = inst.replica.sailor and inst.replica.sailor:GetBoat() and inst.replica.sailor:GetBoat().replica.sailable:GetIsSailEquipped() or false


        if inst:HasTag("_sailor") and inst:HasTag("sailing") then
            if not is_attacking then
                if is_moving and not should_move then         
                    if hasSail then
                        inst.sg:GoToState("sail_stop_ia")
                    else
                        inst.sg:GoToState("row_stop_ia")
                    end
                elseif not is_moving and should_move or (is_moving and should_move and is_running ~= should_run) then         
                    if hasSail then
                        inst.sg:GoToState("sail_start_ia")
                    else
                        inst.sg:GoToState("rowl_start_ia")
                    end
                end
            end
            return
        end

        _locomote_eventhandler(inst, data)
    end
end

do
	local _attack_actionhandler = inst.actionhandlers[ACTIONS.ATTACK].deststate
	inst.actionhandlers[ACTIONS.ATTACK].deststate = function(inst, action, ...)
		if not (inst.sg:HasStateTag("attack") and action.target == inst.sg.statemem.attacktarget or inst.replica.health:IsDead()) then
			local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			if equip and equip:HasTag("speargun") then
				return "speargun"
			end
		end
		return _attack_actionhandler(inst, action, ...)
	end
end

do
	local _attack_onenter = inst.states.attack.onenter
	inst.states.attack.onenter = function(inst, data)

		local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		if equip and equip:HasTag("cutlass") then
			SetSoundAlias("dontstarve/wilson/attack_weapon", "ia/common/swordfish_sword")
		elseif equip and equip:HasTag("pegleg") then
			SetSoundAlias("dontstarve/wilson/attack_weapon", "ia/common/pegleg_weapon")
		end

		_attack_onenter(inst, data)

		SetSoundAlias("dontstarve/wilson/attack_weapon", nil)

	end
end

do
	local _fish_actionhandler = inst.actionhandlers[ACTIONS.FISH].deststate
	inst.actionhandlers[ACTIONS.FISH].deststate = function(inst, action, ...)
		if action.target and action.target:HasTag("FISH_workable") then
			return "fishing_retrieve"
		end
		if type(_fish_actionhandler) == "function" then
			return _fish_actionhandler(inst, action, ...)
		end
		return _fish_actionhandler
	end
end


local actionhandlers = {
    ActionHandler(ACTIONS.THROW, "throw"),
    ActionHandler(ACTIONS.LAUNCH_THROWABLE, "cannon"),
    ActionHandler(ACTIONS.RETRIEVE, "dolongaction"),
    ActionHandler(ACTIONS.STICK, "doshortaction"),
    ActionHandler(ACTIONS.DEPLOY_AT_RANGE, "doshortaction"),
    ActionHandler(ACTIONS.LAUNCH, "doshortaction"),
    ActionHandler(ACTIONS.HACK, function(inst)
        if inst:HasTag("beaver") then
            return not inst.sg:HasStateTag("gnawing") and "gnaw" or nil
        end
        return not inst.sg:HasStateTag("prehack") and "hack_start" or nil
    end),
    ActionHandler(ACTIONS.TOGGLEON, "give"),
    ActionHandler(ACTIONS.TOGGLEOFF, "give"),
    ActionHandler(ACTIONS.REPAIRBOAT, "dolongaction"),
    ActionHandler(ACTIONS.CUREPOISON, function(inst, action)
        local target = action.target

        if not target or target == inst then
            return "quickeat"
        else
            return "give"
        end
    end),
    ActionHandler(ACTIONS.PACKUP, "doshortaction"),
    ActionHandler(ACTIONS.PEER, "peertelescope"),
}

local events = {
    EventHandler("sailequipped", function(inst)
        if inst.sg:HasStateTag("rowing") then 
            inst.sg:GoToState("sail_ia")
        end 
    end),

    EventHandler("sailunequipped", function(inst)
        if inst.sg:HasStateTag("sailing") then 
            inst.sg:GoToState("row_ia")

            if not inst:HasTag("mime") then
                inst.AnimState:OverrideSymbol("paddle", "swap_paddle", "paddle")
            end
            --TODO allow custom paddles?
            inst.AnimState:OverrideSymbol("wake_paddle", "swap_paddle", "wake_paddle")
        end         
    end),
}

local states = {
    State{
        name = "rowl_start_ia",
        tags = { "moving", "running", "rowing", "boating", "canrotate"},

        onenter = function(inst)
            local boat = inst.replica.sailor:GetBoat()

            inst.components.locomotor:RunForward()

            if not inst:HasTag("mime") then
                inst.AnimState:OverrideSymbol("paddle", "swap_paddle", "paddle")
            end
            --TODO allow custom paddles?
            inst.AnimState:OverrideSymbol("wake_paddle", "swap_paddle", "wake_paddle")

            inst.AnimState:PlayAnimation("row_pre")
            if boat then
                boat.replica.sailable:PlayPreRowAnims()
            end

            DoFoleySounds(inst)
        end,

        onupdate = function(inst)
            inst.components.locomotor:RunForward()
        end,

        events = {   
            EventHandler("animover", function(inst) inst.sg:GoToState("row_ia") end),
        },
    },

    State{
        name = "row_ia",
        tags = { "moving", "running", "rowing", "boating", "canrotate"},

        onenter = function(inst) 
            local boat = inst.replica.sailor:GetBoat()

            if boat and boat.replica.sailable.creaksound then
                inst.SoundEmitter:PlaySound(boat.replica.sailable.creaksound, nil, nil, true)
            end
            inst.SoundEmitter:PlaySound("ia/common/boat/paddle", nil, nil, true)
            DoFoleySounds(inst)

            
            if not inst.AnimState:IsCurrentAnimation("row_loop") then
                inst.AnimState:PlayAnimation("row_loop", true)
            end
            if boat then
                boat.replica.sailable:PlayRowAnims()
            end
            inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())
        end,

        onexit = function(inst)
            local boat = inst.replica.sailor:GetBoat()
            if inst.sg.nextstate ~= "row_ia" and inst.sg.nextstate ~= "sail_ia" then 
                inst.components.locomotor:Stop(nil, true)
                if inst.sg.nextstate ~= "row_stop_ia" and inst.sg.nextstate ~= "sail_stop_ia" then
                    if boat then
                        boat.replica.sailable:PlayIdleAnims()
                    end
                end
            end
        end,

        timeline = {
            TimeEvent(8*FRAMES, function(inst)
                local boat = inst.replica.sailor:GetBoat()
                if boat and boat.replica.container then
                    local trawlnet = boat.replica.container:GetItemInBoatSlot(BOATEQUIPSLOTS.BOAT_SAIL)
                    if trawlnet and trawlnet.rowsound then
                        inst.SoundEmitter:PlaySound(trawlnet.rowsound, nil, nil, true)
                    end
                end
            end),
        },

        events = {
            EventHandler("trawlitem", function(inst) 
                local boat = inst.replica.sailor:GetBoat() 
                if boat then
                    boat.replica.sailable:PlayTrawlOverAnims()
                end
            end),
        },

        ontimeout = function(inst) inst.sg:GoToState("row_ia") end,
    },
    State{
        name = "row_stop_ia",
        tags = { "canrotate", "idle"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            local boat = inst.replica.sailor:GetBoat()
            inst.AnimState:PlayAnimation("row_pst")
            if boat then
                boat.replica.sailable:PlayPostRowAnims()
            end
        end,

        events = {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "sail_start_ia",
        tags = {"moving", "running", "canrotate", "boating", "sailing"},

        onenter = function(inst)
            local boat = inst.replica.sailor:GetBoat()

            inst.components.locomotor:RunForward()

            inst.AnimState:PlayAnimation("sail_pre")
            if boat then
                boat.replica.sailable:PlayPreSailAnims()
            end
        end,

        onupdate = function(inst)
            inst.components.locomotor:RunForward()
        end,

        events = {   
            EventHandler("animover", function(inst) inst.sg:GoToState("sail_ia") end),
        },
    },

    State{
        name = "sail_ia",
        tags = {"canrotate", "moving", "running", "boating", "sailing"},

        onenter = function(inst)
            local boat = inst.replica.sailor:GetBoat()

            local loopsound = nil 
            local flapsound = nil 

            if boat and boat.replica.container and boat.replica.container.hasboatequipslots then 
                local sail = boat.replica.container:GetItemInBoatSlot(BOATEQUIPSLOTS.BOAT_SAIL)
                if sail then 
                    loopsound = sail.loopsound
                    flapsound = sail.flapsound
                end 
            elseif boat and boat.replica.sailable.sailsound then
                loopsound = boat.replica.sailable.sailsound
            end
           
            if not inst.SoundEmitter:PlayingSound("sail_loop") and loopsound then 
                inst.SoundEmitter:PlaySound(loopsound, "sail_loop", nil, true)
            end 

            if flapsound then 
                inst.SoundEmitter:PlaySound(flapsound, nil, nil, true) 
            end

            if boat and boat.replica.sailable.creaksound then
                inst.SoundEmitter:PlaySound(boat.replica.sailable.creaksound, nil, nil, true)
            end
            
            
            if not inst.AnimState:IsCurrentAnimation("sail_loop") then
                inst.AnimState:PlayAnimation("sail_loop", true)
            end
            if boat then
                boat.replica.sailable:PlaySailAnims()
            end
            inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())
        end,

        onexit = function(inst)
            local boat = inst.replica.sailor:GetBoat()
            if inst.sg.nextstate ~= "sail_ia" then 
                inst.SoundEmitter:KillSound("sail_loop")
                if inst.sg.nextstate ~= "row_ia" then 
                    inst.components.locomotor:Stop(nil, true)
                end 
                if inst.sg.nextstate ~= "row_stop_ia" and inst.sg.nextstate ~= "sail_stop_ia" then
                    if boat then
                        boat.replica.sailable:PlayIdleAnims()
                    end
                end
            end
        end,

        events = {
            EventHandler("trawlitem", function(inst) 
                local boat = inst.replica.sailor:GetBoat() 
                if boat then
                    boat.replica.sailable:PlayTrawlOverAnims()
                end
            end),
        },

        ontimeout = function(inst) inst.sg:GoToState("sail_ia") end,
    },

    State{
        name = "sail_stop_ia",
        tags = {"canrotate", "idle"},

        onenter = function(inst) 
            local boat = inst.replica.sailor:GetBoat()

            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("sail_pst")
            if boat then
                boat.replica.sailable:PlayPostSailAnims()
            end
        end,
            
        events = {   
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle") 
            end),
        },
    },

    State{ 
        name = "hack_start",
        tags = {"prehack", "hacking", "working"},

        onenter = function(inst)
            inst.components.locomotor:Stop()

            if not inst:HasTag("working") then
                inst.AnimState:PlayAnimation("chop_pre")
                inst.AnimState:PushAnimation("chop_lag", false)
            end

            inst:PerformPreviewBufferedAction()
            inst.sg:SetTimeout(TIMEOUT)
        end,

        onupdate = function(inst)
            if inst:HasTag("working") then
                if inst.entity:FlattenMovementPrediction() then
                    inst.sg:GoToState("idle", "noanim")
                end
            elseif inst.bufferedaction == nil then
                inst.sg:GoToState("idle")
            end
        end,

        ontimeout = function(inst)
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle")
        end
    },

    -- BERMUDA STATES

    State{
        name = "jumpinbermuda",
        tags = {"doing", "busy", "canrotate"},

        onenter = function(inst, data)
            inst.components.locomotor:Stop()

            inst.AnimState:Pause()

            inst:PerformPreviewBufferedAction()
            inst.sg:SetTimeout(TIMEOUT)
        end,

        onupdate = function(inst)
            if inst:HasTag("doing") then
                if inst.entity:FlattenMovementPrediction() then
                    inst.sg:GoToState("idle", "noanim")
                end
            elseif inst.bufferedaction == nil then
                inst.sg:GoToState("idle")
            end
        end,

        ontimeout = function(inst)
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle")
        end,
    },

    State{
        name = "speargun",
        tags = {"attack", "notalking", "abouttoattack"},

        onenter = function(inst)
            if inst:HasTag("_sailor") and inst:HasTag("sailing") then
                inst.sg:AddStateTag("boating")
            end
			local target = inst.replica.combat:GetTarget()
            inst.sg.statemem.target = target
            inst.replica.combat:StartAttack()
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("speargun")
            
			if target and target:IsValid() then
				inst:FacePoint(target.Transform:GetWorldPosition())
            end
        end,
        
        timeline=
        {
           
            TimeEvent(12*FRAMES, function(inst)
                inst:PerformPreviewBufferedAction()
                inst.sg:RemoveStateTag("abouttoattack")
                inst.SoundEmitter:PlaySound("ia/common/use_speargun")
            end),
            TimeEvent(20*FRAMES, function(inst) inst.sg:RemoveStateTag("attack") end),
        },
        
        events=
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },

        onexit = function(inst)
            if inst.sg:HasStateTag("abouttoattack") and inst.replica.combat ~= nil then
                inst.replica.combat:CancelAttack()
            end
        end,
    },

    State{
        name = "throw",
        tags = {"attack", "notalking", "abouttoattack"},
        
        onenter = function(inst)
            if inst:HasTag("_sailor") and inst:HasTag("sailing") then
                inst.sg:AddStateTag("boating")
            end
			local target = inst.replica.combat:GetTarget()
            inst.sg.statemem.target = target
            inst.replica.combat:StartAttack()
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("throw")
            
			if target and target:IsValid() then
				inst:FacePoint(inst.replica.combat:GetTarget().Transform:GetWorldPosition())
            end
            
        end,
        
        timeline = {
            TimeEvent(7*FRAMES, function(inst)
                inst:PerformPreviewBufferedAction()
                inst.sg:RemoveStateTag("abouttoattack")
            end),
            TimeEvent(11*FRAMES, function(inst) inst.sg:RemoveStateTag("attack") end),
        },
        
        events = {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },

        onexit = function(inst)
            if inst.sg:HasStateTag("abouttoattack") and inst.replica.combat ~= nil then
                inst.replica.combat:CancelAttack()
            end
        end,
    },

    State{
        name = "cannon",
        tags = {"busy"},

        onenter = function(inst)
            if inst:HasTag("_sailor") and inst:HasTag("sailing") then
                inst.sg:AddStateTag("boating")
            end
            inst.AnimState:PlayAnimation("give")
        end,

        timeline = {
            TimeEvent(13*FRAMES, function(inst) 
                --Light Cannon
                inst.sg:RemoveStateTag("abouttoattack")
                inst:PerformPreviewBufferedAction()
            end),
            TimeEvent(15*FRAMES, function(inst) inst.sg:RemoveStateTag("attack") end),
        },

        events = {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
	
    State{
        name = "peertelescope",
        tags = {"doing", "busy", "canrotate", "nopredict"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("telescope", false)
            inst.AnimState:PushAnimation("telescope_pst", false)

            inst.components.locomotor:Stop()
        end,

        timeline = 
        {
            TimeEvent(20*FRAMES, function(inst) inst.SoundEmitter:PlaySound("ia/common/use_spyglass") end),
        },

        events = {
            EventHandler("animover", function(inst)
                if not inst.AnimState:AnimDone() then
					inst:PerformPreviewBufferedAction()
					-- if ThePlayer and inst == ThePlayer and ThePlayer.HUD and ThePlayer.HUD.controls then
						-- ThePlayer.HUD.controls:ShowMap()
					-- end
				end
            end ),
            EventHandler("animqueueover", function(inst)
                inst.sg:GoToState("idle")
            end ),
        },
    },

    State{
        name = "fishing_retrieve",
        --tags = {"prefish", "fishing", "boating"},
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("fishing_pre") --14
            inst.AnimState:PushAnimation("fishing_cast") --8-12, new in DST, contains part of old fishing_pre
            inst.AnimState:PushAnimation("bite_heavy_pre") --5
            inst.AnimState:PushAnimation("bite_heavy_loop") --14
            inst.AnimState:PushAnimation("fish_catch", false)
            inst.AnimState:OverrideSymbol("fish01", "graves_water_crate", "fish01")
        end,

        onexit = function(inst)
            inst.AnimState:ClearOverrideSymbol("fish01")
        end,

        timeline =
        {
            TimeEvent(13*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/common/fishingpole_cast") end),
            TimeEvent(15*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/common/fishingpole_baitsplash")
                inst:PerformPreviewBufferedAction()
            end),
            TimeEvent((22+5+14+8)*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/common/fishingpole_fishcaught") end),
            TimeEvent((22+5+14+23)*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/common/fishingpole_fishland") end),
        },

        events=
        {
            EventHandler("animqueueover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState("idle")
				end
            end ),
        },
    },
}

for k, v in pairs(actionhandlers) do
    assert(v:is_a(ActionHandler), "Non-action handler added in mod actionhandler table!")
    inst.actionhandlers[v.action] = v
end

for k, v in pairs(events) do
    assert(v:is_a(EventHandler), "Non-event added in mod events table!")
    inst.events[v.name] = v
end

for k, v in pairs(states) do
    assert(v:is_a(State), "Non-state added in mod state table!")
    inst.states[v.name] = v
end


end)
