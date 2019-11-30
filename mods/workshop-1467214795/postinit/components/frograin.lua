local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

IAENV.AddComponentPostInit("frograin", function(cmp)


local SpawnFrogForPlayer_old = UpvalueHacker.GetUpvalue(cmp.SetSpawnTimes, "ToggleUpdate", "ScheduleSpawn", "SpawnFrogForPlayer")
local _scheduledtasks = UpvalueHacker.GetUpvalue(SpawnFrogForPlayer_old, "_scheduledtasks")

local function SpawnFrogForPlayer(player, reschedule)
	--There is no poisonfrograin... yet >:)  -M
	if not IA_CONFIG.poisonfrograin and IsInIAClimate(player) then
		_scheduledtasks[player] = nil
		return reschedule(player)
	end
	SpawnFrogForPlayer_old(player, reschedule)
end

UpvalueHacker.SetUpvalue(cmp.SetSpawnTimes, SpawnFrogForPlayer, "ToggleUpdate", "ScheduleSpawn", "SpawnFrogForPlayer")


end)
