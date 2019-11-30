local assets =
{
	Asset( "ANIM", "anim/wave_shore.zip" )
}

local function onSleep(inst)
	inst:Remove()
end

local function SetAnim(inst)
	local ex, ey, ez = inst.Transform:GetWorldPosition()
	local bearing = -(inst.Transform:GetRotation() + 90) * DEGREES

	local map = TheWorld.Map
	local xr45, yr45 = map:GetTileXYAtPoint(ex + math.cos(bearing - 0.25*math.pi), ey, ez + math.sin(bearing - 0.25*math.pi))
	local xr90, yr90 = map:GetTileXYAtPoint(ex + math.cos(bearing - 0.5*math.pi), ey, ez + math.sin(bearing - 0.5*math.pi))
	local xl45, yl45 = map:GetTileXYAtPoint(ex + math.cos(bearing + 0.25*math.pi), ey, ez + math.sin(bearing + 0.25*math.pi))
	local xl90, yl90 = map:GetTileXYAtPoint(ex + math.cos(bearing + 0.5*math.pi), ey, ez + math.sin(bearing + 0.5*math.pi))

	local left = not IsWater(map:GetTile(xl45, yl45)) and IsWater(map:GetTile(xl90, yl90))
	local right = not IsWater(map:GetTile(xr45, yr45)) and IsWater(map:GetTile(xr90, yr90))

	if left and right then
		inst.AnimState:PlayAnimation("idle_big", false)
	elseif left then
		inst.Transform:SetPosition(ex - 0.5 * TILE_SCALE * math.cos(bearing - 0.5*math.pi), ey, ez - 0.5 * TILE_SCALE * math.sin(bearing - 0.5*math.pi))
		inst.AnimState:PlayAnimation("idle_med", false)
	elseif right then
		inst.Transform:SetPosition(ex + 0.5 * TILE_SCALE * math.cos(bearing - 0.5*math.pi), ey, ez + 0.5 * TILE_SCALE * math.sin(bearing - 0.5*math.pi))
		inst.AnimState:PlayAnimation("idle_med", false)
	else
		local small = {"idle_small", "idle_small2", "idle_small3", "idle_small4"}
		inst.AnimState:PlayAnimation(small[math.random(1, #small)], false)
	end
end

local function fn(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
	inst.entity:AddAnimState()

	inst.AnimState:SetBank("wave_shore")
	inst.AnimState:SetBuild("wave_shore")
    inst.AnimState:PlayAnimation( "idle_small", false )
    inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(ANIM_SORT_ORDER.OCEAN_WAVES)
	
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst:AddTag("NOBLOCK")
	inst:AddTag("ignorewalkableplatforms")
	
	inst.persists = false

	inst.OnEntitySleep = onSleep
	inst:ListenForEvent( "animover", function(inst) inst:Remove() end )

	inst.SetAnim = SetAnim

    return inst
end

return Prefab( "wave_shore", fn, assets )
