local assets =
{
  Asset("ANIM", "anim/messagebottle.zip"),

}

local function revealTreasure(inst)
  if inst.treasure and inst.treasure:IsValid() then
    inst.treasure:Reveal(inst)
    inst.treasure:RevealFog(inst)
  end
end

local function showOnMinimap(treasure, reader)
  if treasure and treasure:IsValid() then
    treasure:FocusMinimap(treasure)
  end
end

local function readfn(inst, reader)

  print("Read Message Bottle", tostring(inst.treasure), tostring(inst.treasureguid))

  if (not inst.treasure and inst.treasureguid) or (not SaveGameIndex:IsModeShipwrecked() 
    or TheWorld:HasTag("volcano") ) then

    reader.components.talker:Say(GetString(reader, "ANNOUNCE_OTHER_WORLD_TREASURE"))
    return true
  end

  local message
  if inst.treasure then
    --message = GetString(reader, "ANNOUNCE_TREASURE")
    revealTreasure(inst)
    inst.treasure:DoTaskInTime(0, function() showOnMinimap(inst.treasure, reader) end)
  else
    --reader.components.talker:Say(GetString(reader, messages[inst.message]))
    message = GetString(reader, "ANNOUNCE_MESSAGEBOTTLE", inst.message)
  end

  if inst.debugmsg then
    print(inst.debugmsg)
    reader.components.talker:Say(inst.debugmsg)
  elseif message then
    reader.components.talker:Say(message)
  end

  inst.components.inventoryitem:RemoveFromOwner(true)
  inst:Remove()

  reader:DoTaskInTime(3*FRAMES, function() reader.components.inventory:GiveItem(SpawnPrefab("messagebottleempty")) end)
  -- reader.components.inventory:GiveItem(SpawnPrefab("messagebottleempty"))

  return true
end

local function OnSave_message(inst, data)
	local refs = {}
	if inst.treasure then
		data.treasure = inst.treasure.GUID
		table.insert(refs, inst.treasure.GUID)
	elseif inst.treasureguid then
		data.treasure = inst.treasureguid
		table.insert(refs, inst.treasureguid)
	end
	data.message = inst.message
	return refs
end

local function OnLoadPostPass_message(inst, ents, data)
	-- inst.components.inventoryitem:OnHitGround() --this now handles hitting water or land 
	if data then
		if data.treasure then
			if ents[data.treasure] then
				inst.treasure = ents[data.treasure].entity
			end
			inst.treasureguid = data.treasure
		end
		inst.message = data.message
	end
end


local function clientcommonfn()
  local inst = CreateEntity()
  local trans = inst.entity:AddTransform()
  inst.entity:AddAnimState()
  inst.entity:AddNetwork()

  MakeInventoryPhysics(inst)

  inst.AnimState:SetBank("messagebottle")
  inst.AnimState:SetBuild("messagebottle")

	MakeInventoryFloatable(inst)

    return inst
end

local function mastercommonfn(inst)
  inst:AddComponent("inspectable")

  MakeInvItemIA(inst)

  inst:AddComponent("waterproofer")
  inst.components.waterproofer:SetEffectiveness(0)

  inst.no_wet_prefix = true
end

local function messagebottlefn()
  local inst = clientcommonfn()
  local minimap = inst.entity:AddMiniMapEntity()

  -- inst.AnimState:PlayAnimation("idle", true)
  inst:AddTag("messagebottle")
  inst:AddTag("nosteal")

  minimap:SetIcon("messagebottle.tex")

	inst.components.floater:UpdateAnimations("idle_water", "idle")

	inst.entity:SetPristine()

  if not TheWorld.ismastersim then
    return inst
  end

	mastercommonfn(inst)

	--TODO remove this once readable
    inst.components.inspectable.descriptionfn = function(inst, viewer)
        return GetString(viewer, "ANNOUNCE_UNIMPLEMENTED")
    end

	--This won't do, only Wickerbottom and Maxwell can read.
	-- inst:AddComponent("book")
	-- inst.components.book.onread = readfn

  inst.treasure = nil
  inst.treasureguid = nil

	inst.OnSave = OnSave_message
	inst.OnLoadPostPass = OnLoadPostPass_message

  return inst
end

local function emptybottlefn(Sim)
  local inst = clientcommonfn()

	inst.components.floater:UpdateAnimations("idle_water_empty", "idle_empty")

	inst.entity:SetPristine()

  if not TheWorld.ismastersim then
    return inst
  end

	mastercommonfn(inst)

  inst:AddComponent("stackable")
  inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

  return inst
end

return Prefab("messagebottle", messagebottlefn, assets),
Prefab("messagebottleempty", emptybottlefn, assets)
