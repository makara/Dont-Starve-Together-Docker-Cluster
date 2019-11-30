local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local function OnPoisonDamage(parent, data)
    parent.player_classified.poisonpulse:set_local(true)
    parent.player_classified.poisonpulse:set(true)
end

local function OnBoostByWave(parent, data)
    if parent.sg:HasStateTag("running") then 
        local boost = data.boost or TUNING.WAVEBOOST
        if parent.components.sailor then
            local boat = parent.components.sailor:GetBoat()
            if boat and boat.waveboost and not data.boost then
                boost = boat.waveboost
            end
        end
        parent.player_classified.waveboost:set_local(boost)
        parent.player_classified.waveboost:set(boost)
    end 
end

local function OnPoisonPulseDirty(inst)
    if inst._parent ~= nil then
        inst._parent:PushEvent("poisondamage")
    end
end

local function OnWaveBoostDirty(inst)
    if inst._parent and inst._parent.components.locomotor then
        inst._parent.components.locomotor.boost = inst.waveboost:value()
    end
end

local function OnClimateDirty(inst)
    if inst._parent ~= nil then
        inst._parent:PushEvent("climatechange", {climate = inst._climate:value()})
    end
end

local function OnPeerTelescope(inst)
    if inst._parent ~= nil then
		if inst._parent.HUD and inst._parent.HUD.controls then
			inst._parent.HUD.controls:ShowMap()
		end
		-- if TheFocalPoint.entity:GetParent() == inst._parent then
			-- TheFocalPoint.SoundEmitter:PlaySound("dontstarve/HUD/Together_HUD/learn_map")
		-- end
    end
end

local function RegisterNetListeners(inst)
    if TheWorld.ismastersim then
        inst._parent = inst.entity:GetParent()
        inst:ListenForEvent("poisondamage", OnPoisonDamage, inst._parent)
        inst:ListenForEvent("boostbywave", OnBoostByWave, inst._parent)
    else
        inst.poisonpulse:set_local(false)
        inst.waveboost:set_local(0)
        --inst.facingsynced:set_local(false)
        inst:ListenForEvent("poisonpulsedirty", OnPoisonPulseDirty)
        inst:ListenForEvent("waveboostdirty", OnWaveBoostDirty)
        inst:ListenForEvent("climatedirty", OnClimateDirty)
    end
	inst:ListenForEvent("telescope.peer", OnPeerTelescope)
end


----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddPrefabPostInit("player_classified", function(inst)


inst.isjellybrainhat = net_bool(inst.GUID, "builder.jellybrainhat", "recipesdirty")

inst.hasmomentum = net_bool(inst.GUID, "locomotor.hasmomentum")
inst.externalspeedadder = net_float(inst.GUID, "locomotor.externalspeedadder")
inst.externalaccelerationadder = net_float(inst.GUID, "locomotor.externalaccelerationadder")
inst.externalaccelerationmultiplier = net_float(inst.GUID, "locomotor.externalaccelerationmultiplier")
inst.externaldecelerationadder = net_float(inst.GUID, "locomotor.externaldecelerationadder")
inst.externaldecelerationmultiplier = net_float(inst.GUID, "locomotor.externaldecelerationmultiplier")
inst.windspeedmult = net_float(inst.GUID, "locomotor.windspeedmult")

inst.disable = net_bool(inst.GUID, "locomotor.disable")
--inst.facingsynced = net_bool(inst.GUID, "locomotor.facingsynced")
inst.waveboost = net_ushortint(inst.GUID, "locomotor.waveboost", "waveboostdirty")

inst.ispoisoned = net_bool(inst.GUID, "poisonable.ispoisoned")
inst.poisonpulse = net_bool(inst.GUID, "poisonable.poisonpulse")

inst._climate = net_tinybyte(inst.GUID, "climatetracker._climate", "climatedirty")

inst.peertelescope = net_event(inst.GUID, "telescope.peer")

inst.isjellybrainhat:set(false)

inst.hasmomentum:set(false)
inst.externalspeedadder:set(0)
inst.externalaccelerationadder:set(0)
inst.externalaccelerationmultiplier:set(1)
inst.externaldecelerationadder:set(0)
inst.externaldecelerationmultiplier:set(1)
inst.windspeedmult:set(1)

inst.disable:set(false)

inst.ispoisoned:set(false)

inst._climate:set(0)

--Delay net listeners until after initial values are deserialized
inst:DoTaskInTime(0, RegisterNetListeners)


end)
