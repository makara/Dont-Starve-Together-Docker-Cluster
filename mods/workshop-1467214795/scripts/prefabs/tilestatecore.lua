local assets = {
	Asset('ANIM','anim/webtile.zip'),
	-- Asset('ANIM','anim/snowtile.zip'),
}

local function onsave(inst, data)
	data.tiles = SaveTileState()
end

local function onload(inst, data)
	if data and data.tiles then
		LoadTileState(data.tiles)
	end
end


local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()

	inst:AddTag('NOCLICK')
	inst:AddTag('tilestate')
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.OnSave = onsave
	inst.OnPreLoad = onload

	return inst
end

return Prefab( 'tilestatecore', fn, assets) 
