local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

--This is, strictly speaking, very improper and inaccurate, but since this is just negligible fx, it should be fine -M
local OnTemperatureChanged_old
local function OnTemperatureChanged(self, temperature)
    if IsInIAClimate(self.inst) then
		temperature = TheWorld.state.islandtemperature
	end
	return OnTemperatureChanged_old(self, temperature)
end


----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("frostybreather", function(cmp)


OnTemperatureChanged_old = cmp.OnTemperatureChanged
cmp.OnTemperatureChanged = OnTemperatureChanged

--refresh that hook
cmp:StopWatchingWorldState("temperature", OnTemperatureChanged_old)
cmp:WatchWorldState("temperature", cmp.OnTemperatureChanged)


end)
