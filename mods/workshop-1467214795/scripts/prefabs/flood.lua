local assets =
{
	Asset("ANIM", "anim/floodtile.zip"),
}

--for networking entities sans actions (a lot less costly)
--For some reason, the basegame entityscript overrides this function.
local AddNetworkProxy = UpvalueHacker.GetUpvalue(Entity.AddNetwork, "AddNetworkProxy")
if not AddNetworkProxy then
	AddNetworkProxy = Entity.AddNetwork
	print("WARNING: IA could not find AddNetworkProxy, tides and flood are going to be very laggy!")
end

local s = .7063

local function fn()
	local inst = CreateEntity()

	AddNetworkProxy(inst.entity)

	inst.entity:AddTransform()
	inst.Transform:SetScale(s,s,s)

	--need to init this for networking
	inst.entity:AddAnimState()
	inst.AnimState:SetBuild("floodtile")
	inst.AnimState:SetBank("floodtile")

	inst.persists = false

	if not TheWorld.ismastersim then -- NETVAR
		inst:DoTaskInTime(0,function(inst)
			TheWorld.components.flooding:AddFloodTile(inst)
		end)
		inst.OnRemoveEntity = function(inst)
			TheWorld.components.flooding:RemoveFloodTile(inst)
		end
	end

	return inst
end

return Prefab( "flood", fn, assets) 

