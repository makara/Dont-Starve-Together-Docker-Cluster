local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local function trygrowhackable(inst)
	if inst:IsInLimbo()
		or (inst.components.witherable ~= nil
			and inst.components.witherable:IsWithered()) then
		return
	end

	if inst.components.hackable ~= nil then
		if inst.components.hackable:CanBeHacked() and inst.components.hackable.caninteractwith then
			return
		end
		inst.components.hackable:FinishGrowing()
	end
end

local onread_old
local function onread(inst, reader, ...)
	local ret = onread_old(inst, reader, ...)
	if ret then -- should another mod make this book fail, then play along
		local x, y, z = reader.Transform:GetWorldPosition()
		local range = 30
		local ents = TheSim:FindEntities(x, y, z, range, nil, { "pickable", "stump", "withered", "INLIMBO" })
		if #ents > 0 then
			trygrowhackable(table.remove(ents, math.random(#ents)))
			if #ents > 0 then
				local timevar = 1 - 1 / (#ents + 1)
				for i, v in ipairs(ents) do
					v:DoTaskInTime(timevar * math.random(), trygrowhackable)
				end
			end
		end
	end
	return ret
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddPrefabPostInit("book_gardening", function(inst)


if TheWorld.ismastersim then

	onread_old = inst.components.book.onread
	inst.components.book.onread = onread
	
end


end)
