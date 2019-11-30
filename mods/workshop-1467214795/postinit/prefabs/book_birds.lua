local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local onread_old
local function onread(inst, reader, ...)
    if TheWorld.state.iswinter and IsInIAClimate(reader) then
        return false, "NOBIRDS"
    end
	return onread_old(inst, reader, ...)
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddPrefabPostInit("book_birds", function(inst)


if TheWorld.ismastersim then

	onread_old = inst.components.book.onread
	inst.components.book.onread = onread
	
end


end)
