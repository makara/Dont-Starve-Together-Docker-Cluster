local waveassets =
{
	Asset( "ANIM", "anim/wave_ripple.zip" ),
}

local rogueassets = 
{
    Asset( "ANIM", "anim/wave_rogue.zip" ),
}

local function wetanddamage(inst, other)
	if not other then return end
    --get wet and take damage 
	local boat
	if other.components.sailor then
		boat = other.components.sailor:GetBoat()
	end
    if other.components.moisture then 
        local hitmoisturerate = 1
        if boat and boat.components.sailable then
            hitmoisturerate = boat.components.sailable:GetHitMoistureRate()
        end
        local waterproofMultiplier = 1 
        if other.components.inventory then 
            waterproofMultiplier = 1 - other.components.inventory:GetWaterproofness()
        end 
        other.components.moisture:DoDelta(inst.hitmoisture * hitmoisturerate * waterproofMultiplier)
    end 
    if boat and boat.components.boathealth then
        boat.components.boathealth:DoDelta(inst.hitdamage, "wave")
    end 
end

local function splash(inst)
    SpawnAt("splash_water", inst)
    inst:Remove()
end 


local function oncollidewave(inst, other)
    local boostThreshold = TUNING.WAVE_BOOST_ANGLE_THRESHOLD
    if other and other:HasTag("player") and not other:HasTag("playerghost") and not other.ignorewaves then
        local moving = other.sg:HasStateTag("moving")
		if other.SoundEmitter then
			other.SoundEmitter:PlaySound("ia/common/waves/break")
		end

        local playerAngle =  other.Transform:GetRotation()
        if playerAngle < 0 then playerAngle = playerAngle + 360 end 

        local waveAngle = inst.Transform:GetRotation()
        if waveAngle < 0 then waveAngle = waveAngle + 360 end 

        local angleDiff = math.abs(waveAngle - playerAngle)
        if angleDiff > 180 then angleDiff = 360 - angleDiff end

        local surfer = false
        if other.components.locomotor then
            surfer = other.components.locomotor:GetExternalSpeedAdder(other, "SURF") ~= 0
        end

        if (angleDiff < boostThreshold or surfer) and moving then
            --Do boost
            local rogueboost
            if other.components.sailor and other.components.sailor.boat and other.components.sailor.boat:HasTag("surfboard") and inst.prefab == "wave_rogue" then
                rogueboost = TUNING.SURFBOARD_ROGUEBOOST
            end
            other:PushEvent("boostbywave", {position = inst.Transform:GetWorldPosition(), velocity = inst.Physics:GetVelocity(), boost = rogueboost})
			if other.SoundEmitter then
				other.SoundEmitter:PlaySound("ia/common/waves/boost")
			end
        elseif not surfer then
            wetanddamage(inst, other)
        end 

        splash(inst)
    elseif other and other.components.waveobstacle then
        other.components.waveobstacle:OnCollide(inst)
        wetanddamage(inst, other)
        splash(inst)
    end
end 


local function oncolliderogue(inst, other)
    -- check for surfboard, which actually just boosts
    if other and other:HasTag("player") and not other:HasTag("playerghost") and not other.ignorewaves then
        local surfer = false
        if other.components.locomotor then
            surfer = other.components.locomotor:GetExternalSpeedAdder(other, "SURF") ~= 0
        end

        if surfer or (other.components.sailor and other.components.sailor.boat and other.components.sailor.boat:HasTag("surfboard")) then
            oncollidewave(inst, other)
            return
        else
            wetanddamage(inst, other)
            splash(inst)
            return 
        end
    end

    if other and other.components.waveobstacle then
        other.components.waveobstacle:OnCollide(inst)
        wetanddamage(inst, other)
        splash(inst)
    end
end

local function CheckGround(inst, dt)
    --Check if I'm about to hit land 
    local x, y, z = inst.Transform:GetWorldPosition()
    local vx, vy, vz = inst.Physics:GetVelocity()
    
    local tile = GROUND.DIRT
    if TheWorld.Map then
        tile = TheWorld.Map:GetTileAtPoint(x + vx, y, z + vz)
    end

    if not IsWater(tile) then 
        splash(inst)
    end
end 

local function onsave(inst, data)
    if inst and data then
        data.speed = inst.Physics:GetMotorSpeed()
        data.angle = inst.Transform:GetRotation()
        if inst.sg and inst.sg.currentstate and inst.sg.currentstate.name then
            data.state = inst.sg.currentstate.name
        end
    end
end

local function onload(inst, data)
    if inst and data then
        inst.Transform:SetRotation(data.angle or 0)
        inst.Physics:SetMotorVel(data.speed or 0, 0, 0)
        if inst.sg and data.state then
            inst.sg:GoToState(data.state)
        end
    end
end

local function activate_collision(inst)
	inst.Physics:SetCollisionGroup(COLLISION.WAVES)
	inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:CollidesWith(COLLISION.GIANTS)
	inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
end

local function onRemove(inst)
    if inst and inst.soundloop then
        inst.SoundEmitter:KillSound(inst.soundloop)
    end
end

local function onSleep(inst)
    inst:Remove()
end

local function fn_common()
	local inst = CreateEntity()
	inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
    inst.Transform:SetFourFaced()
	
    inst.entity:AddPhysics()
    inst.Physics:SetSphere(1)
    inst.Physics:ClearCollisionMask()
    --Zarklord: if this is inside activate_collision, the wave doesnt move until activate_collision gets called, moving it here causes it to behave like SW(move immediatly).
    inst.Physics:SetCollides(false) --Still will get collision callback, just not dynamic collisions.
	
    inst:AddTag("FX")
	inst:AddTag("aquatic")
	
	return inst
end

local function fn_master(inst)
	inst.checkgroundtask = inst:DoPeriodicTask(0.5, CheckGround)
	
	inst.OnEntitySleep = onSleep
	inst.done = false
	
    inst:SetStateGraph("SGwave")
    inst.activate_collision = activate_collision

	return inst
end 

local function ripple()
	local inst = fn_common()
	
    inst.entity:AddAnimState()
    inst.AnimState:SetBuild("wave_ripple")
	inst.AnimState:SetBank("wave_ripple")
	
    inst.entity:SetPristine()
  
    if not TheWorld.ismastersim then
        return inst
    end
	
	fn_master(inst)

    inst.persists = false
	
    inst.Physics:SetCollisionCallback(oncollidewave)
	
	inst.hitdamage = -TUNING.WAVE_HIT_DAMAGE
	inst.hitmoisture = TUNING.WAVE_HIT_MOISTURE
	
	inst.soundrise = "ia/common/waves/small"
	
	return inst
end

local function rogue()
	local inst = fn_common()
	
    inst.entity:AddAnimState()
    inst.AnimState:SetBuild("wave_rogue")
	inst.AnimState:SetBank("wave_rogue")
	
    inst.entity:SetPristine()
  
    if not TheWorld.ismastersim then
        return inst
    end
	
	fn_master(inst)
	
    inst.Physics:SetCollisionCallback(oncolliderogue)
	
    inst.hitdamage = -TUNING.ROGUEWAVE_HIT_DAMAGE
    inst.hitmoisture = TUNING.ROGUEWAVE_HIT_MOISTURE

    inst.idle_time = 1
    
    inst.soundrise = "ia/common/waves/large"
    inst.soundloop = "ia/common/waves/large_LP"
    inst.soundtidal = "ia/common/waves/tidal"

    inst:ListenForEvent("onremove", onRemove)
	
	inst.OnSave = onsave
	inst.OnLoad = onload
	
	return inst
end


return Prefab("wave_ripple", ripple, waveassets), 
       Prefab("wave_rogue", rogue, rogueassets)
