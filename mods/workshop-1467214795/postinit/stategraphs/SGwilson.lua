local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

IAENV.AddStategraphPostInit("wilson", function(inst)


local ToggleOffPhysics
local ToggleOnPhysics
local DoFoleySounds
local ClearStatusAilments
local ForceStopHeavyLifting

do
    --FIX Collision Problems from ToggleOn/OffPhysics functions.
    local _jumpin_onenter = inst.states["jumpin"].onenter
    local _jumpin_onexit = inst.states["jumpin"].onexit
    ToggleOffPhysics = UpvalueHacker.GetUpvalue(_jumpin_onenter, "ToggleOffPhysics")
    ToggleOnPhysics = UpvalueHacker.GetUpvalue(_jumpin_onexit, "ToggleOnPhysics")
    UpvalueHacker.SetUpvalue(_jumpin_onenter, function(...) ToggleOffPhysics(...) end, "ToggleOffPhysics")
    UpvalueHacker.SetUpvalue(_jumpin_onexit, function(...) ToggleOnPhysics(...) end, "ToggleOnPhysics")

    local _run_start_timeevent_2 = inst.states["run_start"].timeline[2].fn
    DoFoleySounds = UpvalueHacker.GetUpvalue(_run_start_timeevent_2, "DoFoleySounds")
    UpvalueHacker.SetUpvalue(_run_start_timeevent_2, function(...) DoFoleySounds(...) end, "DoFoleySounds")

    local _electrocute_onenter = inst.states["electrocute"].onenter
    ClearStatusAilments = UpvalueHacker.GetUpvalue(_electrocute_onenter, "ClearStatusAilments")
    ForceStopHeavyLifting = UpvalueHacker.GetUpvalue(_electrocute_onenter, "ForceStopHeavyLifting")
    UpvalueHacker.SetUpvalue(_electrocute_onenter, function(...) ClearStatusAilments(...) end, "ClearStatusAilments")
    UpvalueHacker.SetUpvalue(_electrocute_onenter, function(...) ForceStopHeavyLifting(...) end, "ForceStopHeavyLifting")


    local _ToggleOnPhysics = ToggleOnPhysics
    ToggleOnPhysics = function(inst, ...)
        _ToggleOnPhysics(inst, ...)
        inst.Physics:CollidesWith(COLLISION.WAVES)
    end
end

local function OnExitRow(inst)
    local boat = inst.replica.sailor:GetBoat()
    if boat and boat.components.rowboatwakespawner then
        boat.components.rowboatwakespawner:StopSpawning()
    end
    if inst.sg.nextstate ~= "row_ia" and inst.sg.nextstate ~= "sail_ia" then
        inst.components.locomotor:Stop(nil, true)
        if inst.sg.nextstate ~= "row_stop_ia" and inst.sg.nextstate ~= "sail_stop_ia" then --Make sure equipped items are pulled back out (only really for items with flames right now)
            local equipped = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if equipped then
                equipped:PushEvent("stoprowing", {owner = inst})
            end
            if boat then
                boat.replica.sailable:PlayIdleAnims()
            end
        end
    end
end

local function OnExitSail(inst)
    local boat = inst.replica.sailor:GetBoat()
    if boat and boat.components.rowboatwakespawner then 
        boat.components.rowboatwakespawner:StopSpawning()
    end 

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
end

local function installBermudaFX(inst)

    if inst.sg.statemem.startinfo then print("WARNING: installBermudaFX twice???") return end

    inst.AnimState:Pause()

    inst.sg.statemem.startinfo = {
        --TODO store original ADDcolour and erosion
        -- colour = inst.AnimState:GetMultColour(),
        scale = inst.Transform:GetScale(),
    }

    --[[
    local textures = {
        "images/bermudaTriangle01.tex",
        "images/bermudaTriangle02.tex",
        "images/bermudaTriangle03.tex",
        "images/bermudaTriangle04.tex",
        "images/bermudaTriangle05.tex",
    }
    --]]

    local colours = {
        {30/255, 57/255, 81/255, 1.0},
        {30/255, 57/255, 81/232, 1.0},
        {30/255, 57/255, 81/232, 1.0},
        {30/255, 57/255, 81/232, 1.0},

        {255/255, 255/255, 255/255, 1.0},
        {255/255, 255/255, 255/255, 1.0},

        {0, 0, 0, 1.0},
    }

    local colourfn = nil
    local posfn = nil
    local scalefn = nil
    local texturefn = nil

    colourfn = function()
        local colour = colours[math.random(#colours)]
        inst.AnimState:SetAddColour(colour[1], colour[2], colour[3], colour[4])
        inst.sg.statemem.colourtask = nil
        inst.sg.statemem.colourtask = inst:DoTaskInTime(math.random(10, 15) * FRAMES, colourfn)
    end

    posfn = function()
        local offset = Vector3(math.random(-1, 1) * .1, math.random(-1, 1) * .1, math.random(-1, 1) * .1)
        inst.Transform:SetPosition((inst:GetPosition() + offset):Get())
        inst.sg.statemem.postask = nil
        inst.sg.statemem.postask = inst:DoTaskInTime(math.random(6, 9) * FRAMES, posfn)
    end

    scalefn = function()
        inst.Transform:SetScale(math.random(95, 105) * 0.01, math.random(99, 101) * 0.01, 1)

        inst.sg.statemem.scaletask = nil
        inst.sg.statemem.scaletask = inst:DoTaskInTime(math.random(5, 8) * FRAMES, scalefn)
    end

    texturefn = function()
        inst.AnimState:SetErosionParams(math.random(1, 4) * 0.1, 0, 1)
        --AnimState does not have SetErosionTexture in DST, and TheSim is a touchy subject
        --inst.AnimState:SetErosionParams(math.random(4, 6) * 0.1, 0, 1)
        --TheSim:SetErosionTexture(textures[math.random(#textures)])

        inst.sg.statemem.texturetask = nil
        inst.sg.statemem.texturetask = inst:DoTaskInTime(math.random(4, 7) * FRAMES, texturefn)
    end

    colourfn()
    posfn()
    scalefn()
    texturefn()
end

local function removeBermudaFX(inst)

    if inst.sg.statemem.startinfo then
        inst.sg.statemem.colourtask:Cancel()
        inst.sg.statemem.colourtask = nil
        inst.sg.statemem.postask:Cancel()
        inst.sg.statemem.postask = nil
        inst.sg.statemem.scaletask:Cancel()
        inst.sg.statemem.scaletask = nil
        inst.sg.statemem.texturetask:Cancel()
        inst.sg.statemem.texturetask = nil

        --TODO can we restore the original values from statemem?
        inst.AnimState:SetAddColour(0,0,0,1)
        inst.Transform:SetScale(1,1,1)
        inst.AnimState:SetErosionParams(0, 0, 0)
        --TheSim:SetErosionTexture("images/erosion.tex")

        inst.AnimState:Resume()

        inst.sg.statemem.startinfo = nil
    end
end


--STATEGRAPH PATCHES, not poluting this files namespace though.
do
    local _fishing_strain_onenter = inst.states["fishing_strain"].onenter
    inst.states["fishing_strain"].onenter = function(inst, ...)
        _fishing_strain_onenter(inst, ...)

        if inst.components.sailor and inst.components.sailor:IsSailing() then
            if math.random() < TUNING.FISHING_CROCODOG_SPAWN_CHANCE then          
                TheWorld.components.hounded:SummonSpawn(Point(inst.Transform:GetWorldPosition()), "crocodog")
            end 
        end
    end

    local _transform_werebeaver_exit = inst.states["transform_werebeaver"].onexit
    inst.states["transform_werebeaver"].onexit = function(inst, ...)
        if inst.sg:HasStateTag("drowning") then return end -- simple hack to prevent looping
        if inst.components.sailor and inst.components.sailor:IsSailing() then
            inst.sg:AddStateTag("drowning")

            --this will cause the boat to "drown" the player and handle the rest of the code.
            if inst.components.sailor and inst.components.sailor:IsSailing() then
                inst.components.sailor.boat.components.boathealth:MakeEmpty()
            end 
            --inst.sg:GoToState("werebeaver_death_boat")
        else
            _transform_werebeaver_exit(inst, ...)
        end
    end


    local _play_flute_onenter = inst.states["play_flute"].onenter
    inst.states["play_flute"].onenter = function(inst, ...)
        _play_flute_onenter(inst, ...)
        local act = inst:GetBufferedAction()
        if act and act.invobject and act.invobject.flutebuild then
            inst.AnimState:OverrideSymbol("pan_flute01", act.invobject.flutebuild or "pan_flute", act.invobject.flutesymbol or "pan_flute01")
        end
    end
    local _use_fan_onenter = inst.states["use_fan"].onenter
    inst.states["use_fan"].onenter = function(inst, ...)
        _use_fan_onenter(inst, ...)
		local invobject = inst.bufferedaction.invobject
        if invobject and invobject.components.fan and invobject.components.fan.overridebuild then
            inst.AnimState:OverrideSymbol(
                "fan01",
                invobject.components.fan.overridebuild or "fan",
                invobject.components.fan.overridesymbol or "swap_fan"
            )
        end
    end

    local _mine_timeevent_1 = inst.states["mine"].timeline[1].fn --How to make sure this is our intended target?
    inst.states["mine"].timeline[1].fn = function(inst, ...)
        if inst.sg.statemem.action ~= nil then
            local target = inst.sg.statemem.action.target
            if target ~= nil and target:IsValid() then
                local coral = target:HasTag("coral")
                local charcoal = target:HasTag("charcoal")
                if coral or charcoal then
                    if target.Transform ~= nil then
                        SpawnAt("mining_fx", target)
                    end
                    inst.SoundEmitter:PlaySound(coral and "ia/common/coral_mine" or "ia/common/charcoal_mine")
                    inst:PerformBufferedAction()
                    return
                end
            end
        end
        _mine_timeevent_1(inst, ...) --default handler
    end

end

do
    -- HANDLER PATCHES

    local _locomote_eventhandler = inst.events.locomote.fn
    inst.events.locomote.fn = function(inst, data)
        local is_attacking = inst.sg:HasStateTag("attack")

        local is_moving = inst.sg:HasStateTag("moving")
        local is_running = inst.sg:HasStateTag("running")
        local should_move = inst.components.locomotor:WantsToMoveForward()
        if inst.components.sailor and inst.components.sailor.boat and not inst.components.sailor.boat.components.sailable then
            should_move = false
        end

        local should_run = inst.components.locomotor:WantsToRun()
        local hasSail = inst.replica.sailor and inst.replica.sailor:GetBoat() and inst.replica.sailor:GetBoat().replica.sailable:GetIsSailEquipped() or false
        if not should_move then
            if inst.components.sailor and inst.components.sailor.boat then
                inst.components.sailor.boat:PushEvent("boatstopmoving")
            end
        end 
        if should_move then 
            if inst.components.sailor and inst.components.sailor.boat then
                inst.components.sailor.boat:PushEvent("boatstartmoving")
            end
        end 

        if inst.sg:HasStateTag("busy") or inst:HasTag("busy") then
            return _locomote_eventhandler(inst, data)
        end
        if inst.components.sailor and inst.components.sailor:IsSailing() then
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

    local _death_eventhandler = inst.events.death.fn
    inst.events.death.fn = function(inst, data)
        if data.cause == "drowning" then
            inst.sg:GoToState("death_boat")
        else
            if inst.components.sailor and inst.components.sailor.boat and inst.components.sailor.boat.components.container then
                inst.components.sailor.boat.components.container:Close(true)
            end
            _death_eventhandler(inst, data)
        end
    end

    local _attacked_eventhandler = inst.events.attacked.fn
    inst.events.attacked.fn = function(inst, data)
        if inst.components.sailor and inst.components.sailor:IsSailing() then
            local boat = inst.components.sailor:GetBoat()
            if not inst.components.health:IsDead() and not (boat and boat.components.boathealth and boat.components.boathealth:IsDead()) then

                if not boat.components.sailable or not boat.components.sailable:CanDoHit() then 
                    return 
                end

                if data.attacker and (data.attacker:HasTag("insect") or data.attacker:HasTag("twister"))then
                    local is_idle = inst.sg:HasStateTag("idle")
                    if not is_idle then
                        return
                    end
                end

                boat.components.sailable:GetHit()
                
                _attacked_eventhandler(inst, data)
            end
        else
            _attacked_eventhandler(inst, data)
        end
    end

	local _attack_actionhandler = inst.actionhandlers[ACTIONS.ATTACK].deststate
	inst.actionhandlers[ACTIONS.ATTACK].deststate = function(inst, action, ...)
		if not (inst.sg:HasStateTag("attack") and action.target == inst.sg.statemem.attacktarget or inst.components.health:IsDead()) then
			local weapon = inst.components.combat ~= nil and inst.components.combat:GetWeapon() or nil
			if weapon and weapon:HasTag("speargun") then
				return "speargun"
			end
		end
		return _attack_actionhandler(inst, action, ...)
	end

    -- Disembark properly and drop no skeleton
    local _death_animover = inst.states.death.events.animover.fn
    inst.states.death.events.animover.fn = function(inst, ...)
        if inst.AnimState:AnimDone() and not inst.sg:HasStateTag("dismounting")
        and IsOnWater(inst) then
            if inst.components.sailor then
                inst.components.sailor:Disembark()
            end
            inst:PushEvent(inst.ghostenabled and "makeplayerghost" or "playerdied", {skeleton = false})
        else
            _death_animover(inst, ...)
        end
    end
end

do
	local _attack_onenter = inst.states.attack.onenter
	inst.states.attack.onenter = function(inst, data)

		local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
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
		if action.target and action.target.components.workable
		and action.target.components.workable:GetWorkAction() == ACTIONS.FISH
		and action.target.components.workable:CanBeWorked() then
			return "fishing_retrieve"
		end
		if type(_fish_actionhandler) == "function" then
			return _fish_actionhandler(inst, action, ...)
		end
		return _fish_actionhandler
	end
end


local actionhandlers = {
    ActionHandler(ACTIONS.EMBARK, "embark"),
    ActionHandler(ACTIONS.DISEMBARK, "disembark"),
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
        return not inst.sg:HasStateTag("prehack") and (inst.sg:HasStateTag("hacking") and "hack" or "hack_start") or nil
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
    EventHandler("drown_fake", function(inst, data)
        if inst.components.health and not inst.components.health:IsDead() then
            if IsOnWater(inst) then
                if data and not data.rescueitem then
                    data.rescueitem = inst -- require a rescueitem for logic
                end
                inst.sg:GoToState("death_boat", data)
            elseif IsOnLand(inst) then
                if data and not data.rescueitem then
                    data.rescueitem = inst -- require a rescueitem for logic
                end
                --inst.sg:GoToState("death_boat", data)
            end
        end          
    end),

    EventHandler("vacuum_in", function(inst)
        if inst.components.health and not inst.components.health:IsDead() and
        not (IsOnWater(inst:GetPosition())) and
        not inst.sg:HasStateTag("vacuum_in") and
        not (inst.components.sailor and inst.components.sailor:IsSailing()) then
            inst.sg:GoToState("vacuumedin")
        end          
    end),

    EventHandler("vacuum_out", function(inst, data)
        if inst.components.health and not inst.components.health:IsDead() and
        not (IsOnWater(inst:GetPosition())) and
        not inst.sg:HasStateTag("vacuum_out") and
        not (inst.components.sailor and inst.components.sailor:IsSailing()) then 
            inst.sg:GoToState("vacuumedout", data)
        else
            inst:RemoveTag("NOVACUUM")
        end          
    end),

    EventHandler("vacuum_held", function(inst)
        if inst.components.health and not inst.components.health:IsDead() and
        not (IsOnWater(inst:GetPosition())) and
        not inst.sg:HasStateTag("vacuum_held") and
        not (inst.components.sailor and inst.components.sailor:IsSailing()) then 

            inst.sg:GoToState("vacuumedheld")
        end          
    end),

    EventHandler("sailequipped", function(inst)
        if inst.sg:HasStateTag("rowing") then 
            inst.sg:GoToState("sail_ia")
            local equipped = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if equipped then 
                equipped:PushEvent("stoprowing", {owner = inst})
            end
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
            
            local equipped = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if equipped then 
                equipped:PushEvent("startrowing", {owner = inst})
            end
        end         
    end),

    EventHandler("boatattacked", inst.events.attacked.fn),

    EventHandler("boostbywave", function(inst, data)
        if inst.sg:HasStateTag("running") then 
            
            local boost = data.boost or TUNING.WAVEBOOST
            if inst.components.sailor then
                local boat = inst.components.sailor:GetBoat()
                if boat and boat.waveboost and not data.boost then
                    boost = boat.waveboost
                end
                -- sanity boost, walani's surfboard mainly
                if boat and boat.wavesanityboost and inst.components.sanity then
                    inst.components.sanity:DoDelta(boat.wavesanityboost)
                end
            end

            if inst.components.locomotor then
                inst.components.locomotor.boost = boost
            end
        end 
    end),
}

local states = {
    State{
        name = "rowl_start_ia",
        tags = { "moving", "running", "rowing", "boating", "canrotate", "autopredict" },

        onenter = function(inst)
            local boat = inst.replica.sailor:GetBoat()

            inst.components.locomotor:RunForward()

            if not inst:HasTag("mime") then
                inst.AnimState:OverrideSymbol("paddle", "swap_paddle", "paddle")
            end
            --TODO allow custom paddles?
            inst.AnimState:OverrideSymbol("wake_paddle", "swap_paddle", "wake_paddle")

			--RoT has row_pre, which is identical but uses the equipped item as paddle
            inst.AnimState:PlayAnimation("row_ia_pre")
            if boat then
                boat.replica.sailable:PlayPreRowAnims()
            end

            DoFoleySounds(inst)

            local equipped = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if equipped then 
                equipped:PushEvent("startrowing", {owner = inst})
            end
            inst:PushEvent("startrowing")
        end,

        onupdate = function(inst)
            inst.components.locomotor:RunForward()
        end,

        onexit = OnExitRow,

        events = {   
            EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState("row_ia")
				end
			end),
        },  
    },

    State{
        name = "row_ia",
        tags = { "moving", "running", "rowing", "boating", "canrotate", "autopredict" },

        onenter = function(inst) 
            local boat = inst.replica.sailor:GetBoat()

            if boat and boat.replica.sailable.creaksound then
                inst.SoundEmitter:PlaySound(boat.replica.sailable.creaksound, nil, nil, true)
            end
            inst.SoundEmitter:PlaySound("ia/common/boat/paddle", nil, nil, true)
            DoFoleySounds(inst)

            if not inst.AnimState:IsCurrentAnimation("row_loop") then
				--RoT has row_medium, which is identical but uses the equipped item as paddle
                inst.AnimState:PlayAnimation("row_loop", true)
            end
            if boat then
                boat.replica.sailable:PlayRowAnims()
            end

            if boat and boat.components.rowboatwakespawner then 
                boat.components.rowboatwakespawner:StartSpawning()
            end

            if inst.components.mapwrapper
            and inst.components.mapwrapper._state > 1
            and inst.components.mapwrapper._state < 5 then
                inst.sg:AddStateTag("nomorph")
                -- TODO pause predict?
            end

            inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())
        end,

        onexit = OnExitRow,

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
        tags = { "canrotate", "idle", "autopredict"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            local boat = inst.replica.sailor:GetBoat()
            inst.AnimState:PlayAnimation("row_pst")
            if boat then
                boat.replica.sailable:PlayPostRowAnims()
            end

            --If the player had something in their hand before starting to row, put it back.
            if inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
                inst.AnimState:PushAnimation("item_out", false)
            end
        end,

        events = {
            EventHandler("animqueueover", function(inst)
				if inst.AnimState:AnimDone() then
					local equipped = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
					if equipped then
						equipped:PushEvent("stoprowing", {owner = inst})
					end
					inst:PushEvent("stoprowing")
					inst.sg:GoToState("idle")
				end
            end),
        },
    },

    State{
        name = "sail_start_ia",
        tags = {"moving", "running", "canrotate", "boating", "sailing", "autopredict"},

        onenter = function(inst)
            local boat = inst.replica.sailor:GetBoat()

            inst.components.locomotor:RunForward()

            inst.AnimState:PlayAnimation("sail_pre")
            if boat then
                boat.replica.sailable:PlayPreSailAnims()
            end

            local equipped = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if equipped then 
                equipped:PushEvent("startsailing", {owner = inst})
            end
        end,

        onupdate = function(inst)
            inst.components.locomotor:RunForward()
        end,

        onexit = OnExitSail,

        events = {   
            EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState("sail_ia")
				end
			end),
        },
    },

    State{
        name = "sail_ia",
        tags = {"canrotate", "moving", "running", "boating", "sailing", "autopredict"},

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

            if boat and boat.components.rowboatwakespawner then 
                boat.components.rowboatwakespawner:StartSpawning()
            end 

            if inst.components.mapwrapper
            and inst.components.mapwrapper._state > 1
            and inst.components.mapwrapper._state < 5 then
                inst.sg:AddStateTag("nomorph")
                --TODO pause predict?
            end
            inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())
        end,

        onexit = OnExitSail,

        events = {   
            --EventHandler("animover", function(inst) inst.sg:GoToState("sail_ia") end ),
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
        tags = {"canrotate", "idle", "autopredict"},

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
				if inst.AnimState:AnimDone() then
					local equipped = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
					if equipped then 
						equipped:PushEvent("stopsailing", {owner = inst})
					end
					inst.sg:GoToState("idle")
				end
            end),
        },
    },

    State{
        name = "embark",
        tags = {"canrotate", "boating", "busy", "nomorph", "nopredict"},
        onenter = function(inst)
            local BA = inst:GetBufferedAction()
            if BA.target and BA.target.components.sailable and not BA.target.components.sailable:IsOccupied() then
                BA.target.components.sailable.isembarking = true
                if inst.components.sailor and inst.components.sailor:IsSailing() then
                    inst.components.sailor:Disembark(nil, true)
                else
                    inst.sg:GoToState("jumponboatstart")
                end
			else
				--go to idle first so wilson can go to the talk state if desired -M
				--and in my defence, Klei does that too, in opengift state
				inst.sg:GoToState("idle")
				inst:PushEvent("actionfailed", { action = inst.bufferedaction, reason = "INUSE" })
				inst:ClearBufferedAction()
            end
        end,

        onexit = function(inst)
        end,
    },

    State{
        name = "disembark",
        tags = {"canrotate", "boating", "busy", "nomorph", "nopredict"},
        onenter = function(inst)
            inst:PerformBufferedAction()
        end,

        onexit = function(inst)
        end,
    },

    State{
        name = "jumponboatstart",
        tags = { "doing", "nointerupt", "busy", "canrotate", "nomorph", "nopredict", "amphibious"},

        onenter = function(inst)
			if inst.Physics.ClearCollidesWith then
			inst.Physics:ClearCollidesWith(COLLISION.LIMITS) --R08_ROT_TURNOFTIDES
			end
            inst.components.locomotor:StopMoving()
            --inst.components.locomotor:EnableGroundSpeedMultiplier(false)
            inst.AnimState:PlayAnimation("jumpboat")
            inst.SoundEmitter:PlaySound("ia/common/boatjump_whoosh")

            local BA = inst:GetBufferedAction()
            inst.sg.statemem.startpos = inst:GetPosition()
            inst.sg.statemem.targetpos = BA.target and BA.target:GetPosition()
            
            inst:PushEvent("ms_closepopups")

            if inst.components.health ~= nil then
                inst.components.health:SetInvincible(true)
            end

            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(false)
                inst.components.playercontroller:RemotePausePrediction()
            end
        end,

        onexit = function(inst)
        --This shouldn"t actually be reached
			if inst.Physics.ClearCollidesWith then
			inst.Physics:CollidesWith(COLLISION.LIMITS) --R08_ROT_TURNOFTIDES
			end
            inst.components.locomotor:Stop()
            --inst.components.locomotor:EnableGroundSpeedMultiplier(true)
            if inst.components.health ~= nil then
                inst.components.health:SetInvincible(false)
            end

            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(true)
            end
        end,

        timeline = {
            -- Make the action cancel-able until this?
            TimeEvent(7 * FRAMES, function(inst)
                inst:ForceFacePoint(inst.sg.statemem.targetpos:Get())
                local dist = inst:GetPosition():Dist(inst.sg.statemem.targetpos)
                local speed = dist / (18/30)
                inst.Physics:SetMotorVelOverride(1 * speed, 0, 0)
            end),
        },

        events = {
            EventHandler("animover", function(inst)
                if inst.components.playercontroller ~= nil then
                    inst.components.playercontroller:Enable(true)
                end

                if inst.components.health ~= nil then
                    inst.components.health:SetInvincible(false)
                end
                inst.Transform:SetPosition(inst.sg.statemem.targetpos:Get())
                inst.Physics:Stop()

                inst.components.locomotor:Stop()
                --inst.components.locomotor:EnableGroundSpeedMultiplier(true)
                inst:PerformBufferedAction()
            end),
        },
    },

    State{
        name = "jumpboatland",
        tags = { "doing", "nointerupt", "busy", "canrotate", "invisible", "nomorph", "nopredict", "amphibious"},

        onenter = function(inst, pos)
			if inst.Physics.ClearCollidesWith then
			inst.Physics:CollidesWith(COLLISION.LIMITS) --R08_ROT_TURNOFTIDES
			end
            if inst.components.health ~= nil then
                inst.components.health:SetInvincible(true)
            end
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("landboat")
            local boat = inst.components.sailor.boat 
            if boat and boat.landsound then
                inst.SoundEmitter:PlaySound(boat.landsound)
            end
        end,

        onexit = function(inst)
            if inst.components.health ~= nil then
                inst.components.health:SetInvincible(false)
            end
        end,

        events = {
            EventHandler("animqueueover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState("idle")
				end
            end),
        },
    },

    State{
        name = "jumpoffboatstart",
        tags = { "doing", "nointerupt", "busy", "canrotate", "nomorph", "nopredict", "amphibious"},

        onenter = function(inst, pos)
			if inst.Physics.ClearCollidesWith then
			inst.Physics:ClearCollidesWith(COLLISION.LIMITS) --R08_ROT_TURNOFTIDES
			end
            inst.components.locomotor:StopMoving()
            --inst.components.locomotor:EnableGroundSpeedMultiplier(false)
            inst.AnimState:PlayAnimation("jumpboat")
            inst.SoundEmitter:PlaySound("ia/common/boatjump_whoosh")

            inst.sg.statemem.startpos = inst:GetPosition()
            inst.sg.statemem.targetpos = pos
            
            inst:PushEvent("ms_closepopups")

            if inst.components.health ~= nil then
                inst.components.health:SetInvincible(true)
            end

            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(false)
                inst.components.playercontroller:RemotePausePrediction()
            end
        end,

        onexit = function(inst)
        --This shouldn"t actually be reached
			if inst.Physics.ClearCollidesWith then
			inst.Physics:CollidesWith(COLLISION.LIMITS) --R08_ROT_TURNOFTIDES
			end
            inst.components.locomotor:Stop()
            --inst.components.locomotor:EnableGroundSpeedMultiplier(true)
            if inst.components.health ~= nil then
                inst.components.health:SetInvincible(false)
            end

            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(true)
            end
        end,

        timeline = {
            --Make the action cancel-able until this?
            TimeEvent(7 * FRAMES, function(inst)
                inst:ForceFacePoint(inst.sg.statemem.targetpos:Get())
                local dist = inst:GetPosition():Dist(inst.sg.statemem.targetpos)
                local speed = dist / (18/30)
                inst.Physics:SetMotorVelOverride(1 * speed, 0, 0)
            end),
        },

        events = {
            EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.Transform:SetPosition(inst.sg.statemem.targetpos:Get())
					if inst.components.health ~= nil then
						inst.components.health:SetInvincible(false)
					end
					inst.sg:GoToState("jumpoffboatland")
				end
            end),
        },
    },

    State{
        name = "jumpoffboatland",
        tags = { "doing", "nointerupt", "busy", "canrotate", "nomorph", "nopredict", "amphibious"},

        onenter = function(inst, pos)
			if inst.Physics.ClearCollidesWith then
			inst.Physics:CollidesWith(COLLISION.LIMITS) --R08_ROT_TURNOFTIDES
			end
            if inst.components.health ~= nil then
                inst.components.health:SetInvincible(true)
            end
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("land", false)
            inst.SoundEmitter:PlaySound("ia/common/boatjump_to_land")
            PlayFootstep(inst)
        end,

        onexit = function(inst)
            if inst.components.health ~= nil then
                inst.components.health:SetInvincible(false)
            end
        end,

        events = {
            EventHandler("animqueueover", function(inst)
                inst:PerformBufferedAction()
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState("idle")
				end
            end),
        },
    },

    State{
        name = "hack_start",
        tags = {"prehack", "working"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("chop_pre")
        end,

        events = {
            EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("hack")
                end
            end),
        },
    },

    State{
        name = "hack",
        tags = {"prehack", "hacking", "working"},

        onenter = function(inst)
            inst.sg.statemem.action = inst:GetBufferedAction()
            inst.AnimState:PlayAnimation("chop_loop")            
        end,

        timeline = {
            TimeEvent(2*FRAMES, function(inst) 
                inst:PerformBufferedAction() 
            end),


            TimeEvent(9*FRAMES, function(inst)
                inst.sg:RemoveStateTag("prehack")
            end),

            TimeEvent(14*FRAMES, function(inst)
                if inst.components.playercontroller ~= nil and
                inst.components.playercontroller:IsAnyOfControlsPressed(
                CONTROL_PRIMARY, CONTROL_ACTION, CONTROL_CONTROLLER_ACTION) and
                inst.sg.statemem.action ~= nil and
                inst.sg.statemem.action:IsValid() and
                inst.sg.statemem.action.target ~= nil and
                inst.sg.statemem.action.target.components.hackable ~= nil and
                inst.sg.statemem.action.target.components.hackable:CanBeHacked() and
                inst.sg.statemem.action.target:IsActionValid(inst.sg.statemem.action.action) and
                CanEntitySeeTarget(inst, inst.sg.statemem.action.target) then
                    inst:ClearBufferedAction()
                    inst:PushBufferedAction(inst.sg.statemem.action)
                end
            end),

            TimeEvent(16*FRAMES, function(inst) 
                inst.sg:RemoveStateTag("hacking")
            end),
        },

        events = {
            EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState("idle")
				end
			end),
        },
    },

    State{
        name = "death_boat",
        tags = {"busy", "pausepredict", "nomorph" },

        onenter = function(inst, params)
            ClearStatusAilments(inst)
            ForceStopHeavyLifting(inst)

            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
            inst:ClearBufferedAction()
            if params and params.rescueitem and inst.components.health then
                --This guy isn"t actually dying.
                inst.sg.statemem.rescueitem = params.rescueitem
                inst.components.health:SetInvincible(true)
            end

            inst.components.burnable:Extinguish()

            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:RemotePausePrediction()
                inst.components.playercontroller:Enable(false)
            end

            -- inst.last_death_position = inst:GetPosition()

            inst.AnimState:Hide("swap_arm_carry")
            inst.AnimState:PlayAnimation("boat_death")

            inst.components.inventory:DropEverything(true)

            SpawnAt("boat_death", inst)

            if inst:HasTag("beaver") then
                inst.AnimState:SetBuild("werebeaver_boat_death")
                inst.AnimState:SetBank("werebeaver_boat_death")
                inst.AnimState:PlayAnimation("boat_death")
                inst.SoundEmitter:PlaySound("ia/characters/woodie/sinking_death_werebeaver")
            else
                if not inst:HasTag("mime") then
                    local soundname = inst.soundsname or inst.prefab
                    --local path = inst.talker_path_override or "ia/characters/vanilla/"
                    --inst.SoundEmitter:PlaySound(path..soundname.."_drown_voice")
                    local path = inst.talker_path_override or "ia/characters/"
                    inst.SoundEmitter:PlaySound(path..soundname.."/sinking_death")
                end
            end

            inst.sg:SetTimeout(8) -- just in case

            --Don"t process other queued events if we died this frame
            inst.sg:ClearBufferedEvents()
        end,

        onexit= function(inst) 
            if not inst.sg.statemem.rescueitem then
                --You should never leave this state once you enter it!
                assert(false, "Left drown state.")
            end
        end,

        ontimeout= function(inst)  --failsafe
            if inst.sg.statemem.rescueitem then
                --copy from animover
                if inst:HasTag("beaver") then
                    inst.AnimState:SetBank("werebeaver")
                    if inst.components.skinner then
                        inst.components.skinner:SetSkinMode("werebeaver_skin")
                    else
                        inst.AnimState:SetBuild("werebeaver")
                    end
                end
                inst:PushEvent("beachresurrect", {rescueitem = inst.sg.statemem.rescueitem})
                inst.sg.statemem.rescueitem:PushEvent("preventdrowning", {target = inst})
                if inst.components.playercontroller ~= nil then
                    inst.components.playercontroller:Enable(true)
                end
            else
                inst:PushEvent(inst.ghostenabled and "makeplayerghost" or "playerdied", {skeleton = false})
            end
        end,

        timeline = {
            TimeEvent(50*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("ia/common/boat/sinking/shadow")
            end),
            TimeEvent(70*FRAMES, function(inst)
                inst.DynamicShadow:Enable(false)
            end),
        },

        events = {
            EventHandler("animover", function(inst)
                if inst.sg.statemem.rescueitem then
                    if inst:HasTag("beaver") then
                        inst.AnimState:SetBank("werebeaver")
                        if inst.components.skinner then
                            inst.components.skinner:SetSkinMode("werebeaver_skin")
                        else
                            inst.AnimState:SetBuild("werebeaver")
                        end
                    end
                    inst:PushEvent("beachresurrect", {rescueitem = inst.sg.statemem.rescueitem})
                    inst.sg.statemem.rescueitem:PushEvent("preventdrowning", {target = inst})
                    if inst.components.playercontroller ~= nil then
                        inst.components.playercontroller:Enable(true)
                    end
                else
                    inst:PushEvent(inst.ghostenabled and "makeplayerghost" or "playerdied", {skeleton = false})
                end
            end),
        },
    },

    State{
        name = "jumpinbermuda",
        tags = {"doing", "busy", "canrotate", "nopredict", "nomorph"},

        onenter = function(inst, data)
            inst.components.locomotor:Stop()

            inst.sg.statemem.teleportarrivestate = "jumpoutbermuda" -- for teleporter cmp
            inst.sg.statemem.target = data.teleporter
            if data.teleporter ~= nil and data.teleporter.components.teleporter ~= nil then
                data.teleporter.components.teleporter:RegisterTeleportee(inst)
            end

            installBermudaFX(inst)
        end,

        onexit = function(inst)
            removeBermudaFX(inst)

            if inst.sg.statemem.isteleporting then
                inst.components.health:SetInvincible(false)

                if TUNING.DO_SEA_DAMAGE_TO_BOAT and inst.components.sailor.boat and
                inst.components.sailor.boat.components.boathealth then
                    inst.components.sailor.boat.components.boathealth:SetInvincible(false)
                end
                if inst.components.playercontroller ~= nil then
                    inst.components.playercontroller:Enable(true)
                end
                inst:Show()
                inst.DynamicShadow:Enable(true)
            elseif inst.sg.statemem.target ~= nil
            and inst.sg.statemem.target:IsValid()
            and inst.sg.statemem.target.components.teleporter ~= nil then
                inst.sg.statemem.target.components.teleporter:UnregisterTeleportee(inst)
            end
        end,

        timeline = {
            -- this is just hacked in here to make the sound play BEFORE the player hits the wormhole
            TimeEvent(30*FRAMES, function(inst)
                inst:Hide()
                removeBermudaFX(inst)
                inst.components.health:SetInvincible(true)
                SpawnPrefab("pixel_out").Transform:SetPosition(inst:GetPosition():Get())
            end),

            TimeEvent(40*FRAMES, function(inst)
                if inst.sg.statemem.target ~= nil
                and inst.sg.statemem.target:IsValid()
                and inst.sg.statemem.target.components.teleporter ~= nil then
                    --Unregister first before actually teleporting
                    inst.sg.statemem.target.components.teleporter:UnregisterTeleportee(inst)
                    if inst.sg.statemem.target.components.teleporter:Activate(inst) then
                        inst.sg.statemem.isteleporting = true
                        inst.components.health:SetInvincible(true)

                        if TUNING.DO_SEA_DAMAGE_TO_BOAT and inst.components.sailor.boat and 
                        inst.components.sailor.boat.components.boathealth then
                            inst.components.sailor.boat.components.boathealth:SetInvincible(true)
                        end

                        if inst.components.playercontroller ~= nil then
                            inst.components.playercontroller:Enable(false)
                        end
                        inst:Hide()
                        inst.DynamicShadow:Enable(false)
                        return
                    end
                    inst.sg:GoToState("jumpoutbermuda")
                end
            end),
        },
    },

    State{
        name = "jumpoutbermuda",
        tags = {"doing", "busy", "canrotate", "nopredict", "nomorph"},

        onenter = function(inst, data)
            inst.components.locomotor:Stop()

            SpawnPrefab("pixel_in").Transform:SetPosition(inst:GetPosition():Get())
        end,

        onexit = function(inst)
            removeBermudaFX(inst)
            inst:Show()
        end,

        timeline =
        {

            TimeEvent(10*FRAMES, function(inst)
                inst:Show()
                installBermudaFX(inst)
                --inst.components.health:SetInvincible(false)
            end),

            TimeEvent(35*FRAMES, function(inst)
                inst.sg:GoToState("idle") 
            end),
        },
    },

    State{
        name = "vacuumedin",
        tags = {"busy", "vacuum_in", "canrotate", "pausepredict"},

        onenter = function(inst)
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(false)
                inst.components.playercontroller:RemotePausePrediction()
                end
                inst.AnimState:PlayAnimation("flying_pre")
                inst.AnimState:PlayAnimation("flying_loop", true)
        end,

        onexit = function(inst)
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(true)
            end
        end,
    },

    State{
        name = "vacuumedheld",
        tags = {"busy", "vacuum_held", "pausepredict"},

        onenter = function(inst)
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(false)
                inst.components.playercontroller:RemotePausePrediction()
            end
            inst.DynamicShadow:Enable(false)
            inst:Hide()
        end,

        onexit = function(inst)
            inst:Show()
            inst.DynamicShadow:Enable(true)
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(true)
            end
        end,
    },

    State{
        name = "vacuumedout",
        tags = {"busy", "vacuum_out", "canrotate", "pausepredict"},

        onenter = function(inst, data)
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(false)
                inst.components.playercontroller:RemotePausePrediction()
            end
            inst.AnimState:PlayAnimation("flying_loop", true)

            inst.sg.mem.angle = math.random(360)
            inst.sg.mem.speed = data.speed

            local rx, rz = math.rotate(math.rcos(inst.sg.mem.angle) * inst.sg.mem.speed, math.rsin(inst.sg.mem.angle) * inst.sg.mem.speed, math.rad(inst.Transform:GetRotation()))

            DoShoreMovement(inst, {x = rx, z = rz}, function() inst.Physics:SetMotorVelOverride(rx, 0, rz) end)

            inst.sg:SetTimeout(FRAMES*10)
        end,


        onupdate = function(inst)
            local rx, rz = math.rotate(math.rcos(inst.sg.mem.angle) * inst.sg.mem.speed, math.rsin(inst.sg.mem.angle) * inst.sg.mem.speed, math.rad(inst.Transform:GetRotation()))

            DoShoreMovement(inst, {x = rx, z = rz}, function() inst.Physics:SetMotorVelOverride(rx, 0, rz) end)
        end,

        ontimeout = function(inst)
            inst.Physics:ClearMotorVelOverride()

            local item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if item then
                inst.components.inventory:DropItem(item)
            end

            for i = 1, 4 do
                item = nil 
                local slot = math.random(1,inst.components.inventory:GetNumSlots())
                item = inst.components.inventory:GetItemInSlot(slot)
                if item then 
                    inst.components.inventory:DropItem(item, true, true)
                end 
            end

            inst.Physics:SetMotorVel(0,0,0)
            inst.sg:GoToState("vacuumedland")
            inst:DoTaskInTime(5, function(inst) inst:RemoveTag("NOVACUUM") end)
        end,

        onexit = function(inst)
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(true)
            end
        end,
    },

    State{
        name = "vacuumedland",
        tags = {"busy", "pausepredict"},

        onenter = function(inst)
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(false)
                inst.components.playercontroller:RemotePausePrediction()
            end
            inst.AnimState:PlayAnimation("flying_land")
            inst.components.health:SetInvincible(true)
        end,

        onexit = function(inst)
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(true)
            end
            inst.components.health:SetInvincible(false)
        end,

        events = {
            EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState("idle")
				end
			end),
        },
    },

    State{
        name = "throw",
        tags = {"attack", "notalking", "abouttoattack"},
        
        onenter = function(inst)
            if inst:HasTag("_sailor") and inst:HasTag("sailing") then
                inst.sg:AddStateTag("boating")
            end
            inst.sg.statemem.target = inst.components.combat.target
            inst.components.combat:StartAttack()
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("throw")
            
            if inst.components.combat.target then
                if inst.components.combat.target and inst.components.combat.target:IsValid() then
                    inst:FacePoint(inst.components.combat.target.Transform:GetWorldPosition())
                end
            end
            
        end,
        
        timeline=
        {
            TimeEvent(7*FRAMES, function(inst)
                inst:PerformBufferedAction()
                inst.components.combat:DoAttack(inst.sg.statemem.target)
                inst.sg:RemoveStateTag("abouttoattack")
            end),
            TimeEvent(11*FRAMES, function(inst) inst.sg:RemoveStateTag("attack") end),
        },
        
        events=
        {
            EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState("idle")
				end
            end),
        },
    },

    State{
        name = "speargun",
        tags = {"attack", "notalking", "abouttoattack"},

        onenter = function(inst)
            if inst:HasTag("_sailor") and inst:HasTag("sailing") then
                inst.sg:AddStateTag("boating")
            end
            inst.sg.statemem.target = inst.components.combat.target
            inst.components.combat:StartAttack()
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("speargun")
            
            if inst.components.combat.target then
                if inst.components.combat.target and inst.components.combat.target:IsValid() then
                    inst:FacePoint(inst.components.combat.target.Transform:GetWorldPosition())
                end
            end
        end,
        
        timeline=
        {
           
            TimeEvent(12*FRAMES, function(inst)
                inst:PerformBufferedAction()
                inst.components.combat:DoAttack(inst.sg.statemem.target)
                inst.sg:RemoveStateTag("abouttoattack")
                inst.SoundEmitter:PlaySound("ia/common/use_speargun")
            end),
            TimeEvent(20*FRAMES, function(inst) inst.sg:RemoveStateTag("attack") end),
        },
        
        events=
        {
            EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState("idle")
				end
            end),
        },
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
                inst:PerformBufferedAction()
            end),
            TimeEvent(15*FRAMES, function(inst) inst.sg:RemoveStateTag("attack") end),
        },

        events = {
            EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState("idle")
				end
			end),
        },
    },
	
    State{
        name = "peertelescope",
        tags = {"doing", "busy", "canrotate", "nopredict"},

        onenter = function(inst)
            inst.sg.statemem.action = inst:GetBufferedAction()
            local act = inst:GetBufferedAction()

			if act then
			local pt = act.GetActionPoint and act:GetActionPoint() or act.pos
				if pt then
					inst:ForceFacePoint(pt.x, pt.y, pt.z)
				end
			end
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
                if not inst.AnimState:AnimDone() then --skip the second callback
					inst:PerformBufferedAction()
					-- if ThePlayer and inst == ThePlayer and ThePlayer.HUD and ThePlayer.HUD.controls then
						-- ThePlayer.HUD.controls:ShowMap()
					-- end
				end
            end ),
            EventHandler("animqueueover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState("idle")
				end
            end ),
        },
    },
	
    State{
        name = "fishing_retrieve",
        --tags = {"prefish", "fishing", "boating"},
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("fishing_pre") --14
            inst.AnimState:PushAnimation("fishing_cast") --8-11, new in DST, contains part of old fishing_pre
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
                inst:PerformBufferedAction()
            end),
            TimeEvent((22+5+14+8)*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/common/fishingpole_fishcaught") end),
            TimeEvent((22+5+14+14)*FRAMES, function(inst)
                local equippedTool = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                if equippedTool and equippedTool.components.fishingrod and equippedTool.components.fishingrod.target then
                    equippedTool.components.fishingrod.target:PushEvent("retrieve")
                end
            end),
            TimeEvent((22+5+14+23)*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/common/fishingpole_fishland") end),
            TimeEvent((22+5+14+14+10)*FRAMES, function(inst)
				local equippedTool = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
				if equippedTool and equippedTool.components.fishingrod then
					equippedTool.components.fishingrod:Retrieve()
				end
			end),
            --TimeEvent((26+5+14+24)*FRAMES, function(inst)end),
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
