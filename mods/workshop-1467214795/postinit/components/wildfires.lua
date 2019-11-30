local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

IAENV.AddComponentPostInit("wildfires", function(cmp)


local ForceWildfireForPlayer
local LightFireForPlayer_old
for i, v in ipairs(cmp.inst.event_listening["ms_lightwildfireforplayer"][cmp.inst]) do
	LightFireForPlayer_old = UpvalueHacker.GetUpvalue(v, "LightFireForPlayer")
	if LightFireForPlayer_old then
		ForceWildfireForPlayer = v
		break
	end
end

local _scheduledtasks = UpvalueHacker.GetUpvalue(LightFireForPlayer_old, "_scheduledtasks")


local function LightFireForPlayer(player, rescheduleFn)
	if IsInIAClimate(player) then
		_scheduledtasks[player] = nil
		rescheduleFn(player)
	else
		LightFireForPlayer_old(player, rescheduleFn)
	end
end

UpvalueHacker.SetUpvalue(ForceWildfireForPlayer, LightFireForPlayer, "LightFireForPlayer")


end)
