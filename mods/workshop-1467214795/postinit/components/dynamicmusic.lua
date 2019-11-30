local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

IAENV.AddComponentPostInit("dynamicmusic", function(cmp)


if IA_CONFIG.dynamicmusic == false then return end


local StartPlayerListeners
for i, v in ipairs(cmp.inst.event_listening["playeractivated"][TheWorld]) do
	if UpvalueHacker.GetUpvalue(v, "StartPlayerListeners") then
		StartPlayerListeners = UpvalueHacker.GetUpvalue(v, "StartPlayerListeners")
		break
	end
end
if not StartPlayerListeners then return end

local StartBusy = UpvalueHacker.GetUpvalue(StartPlayerListeners, "StartBusy")
if not StartBusy then return end


local _playsIAmusic = false

local soundAlias = {
	--busy
	["dontstarve/music/music_work"] = "ia/music/music_work_season_1",
	["dontstarve/music/music_work_winter"] = "ia/music/music_work_season_2",
	["dontstarve_DLC001/music/music_work_spring"] = "ia/music/music_work_season_3",
	["dontstarve_DLC001/music/music_work_summer"] = "ia/music/music_work_season_4",
	--combat
	["dontstarve/music/music_danger"] = "ia/music/music_danger_season_1",
	["dontstarve/music/music_danger_winter"] = "ia/music/music_danger_season_2",
	["dontstarve_DLC001/music/music_danger_spring"] = "ia/music/music_danger_season_3",
	["dontstarve_DLC001/music/music_danger_summer"] = "ia/music/music_danger_season_4",
	--epic
	["dontstarve/music/music_epicfight"] = "ia/music/music_epicfight_season_1",
	["dontstarve/music/music_epicfight_winter"] = "ia/music/music_epicfight_season_2",
	["dontstarve_DLC001/music/music_epicfight_spring"] = "ia/music/music_epicfight_season_3",
	["dontstarve_DLC001/music/music_epicfight_summer"] = "ia/music/music_epicfight_season_4",
	--stinger
	["dontstarve/music/music_dawn_stinger"] = "ia/music/music_dawn_stinger",
	["dontstarve/music/music_dusk_stinger"] = "ia/music/music_dusk_stinger",
}

cmp.iamusictask = cmp.inst:DoPeriodicTask(1, function()
	if not (ThePlayer and ThePlayer:IsValid()) then return end
	if IsInIAClimate(ThePlayer) then
		if not _playsIAmusic then
			-- print("CHANGETO IA MUSIC")
			for k, v in pairs(soundAlias) do
				SetSoundAlias(k,v)
			end
			
			_playsIAmusic = true
			UpvalueHacker.SetUpvalue(StartBusy, true, "_isbusydirty")
		end
	elseif _playsIAmusic then
		-- print("CHANGETO ANR MUSIC")
		for k, v in pairs(soundAlias) do
			SetSoundAlias(k,nil)
		end
		
		_playsIAmusic = false
		UpvalueHacker.SetUpvalue(StartBusy, true, "_isbusydirty")
	end
end)


--Note: We'd have to edit StartBusy, StartDanger, etc. to shut the sailing songs up,
--We'd have to edit StartPlayerListeners/StopPlayerListeners to set the hooks
--We'd have to copy the _soundemitter and stuff
--Really, I want to stop using UpvalueHacker for this, it doesn't solve problems anymore.
--Overriding the whole component seems as feasible. -M

-- function DynamicMusic:StopPlayingBoating()
    -- self.inst.SoundEmitter:SetParameter( "boating", "intensity", 0 )
    -- self.is_boating = false
-- end

-- function DynamicMusic:StartPlayingBoating(surfing)
	-- local sound = "ia/music/music_".. (surfing and "surfing" or "sailing") .."_".. (TheWorld.state.isday and "day" or "night")
	
	-- if self.inst.SoundEmitter:PlayingSound("boating") and _sailingsound ~= sound then
		-- self:StopPlayingBoating()
	-- end
	
	-- self.inst.SoundEmitter:PlaySound( sound, "boating")
    -- self.inst.SoundEmitter:SetParameter( "boating", "intensity", 0 )
-- end

-- function DynamicMusic:OnStartBoating()
    -- if not self.enabled then return end

    -- self:StartPlayingBoating()

    -- if not self.inst.SoundEmitter:PlayingSound("dawn") then
        -- self.boating_timeout = 75
        
        -- if not self.is_boating then
            -- self.is_boating = true
            -- if not self.playing_danger and not self.inst.SoundEmitter:PlayingSound("erupt") then
                -- self:StopPlayingBusy()
                -- self.inst.SoundEmitter:SetParameter( "boating", "intensity", 1 )
            -- end
        -- end
    -- end
-- end

    -- inst:ListenForEvent("mountboat", function(it, data)
        -- if data and data.boat and data.boat.prefab == "surfboard" then
            -- self:OnStartSurfing()
        -- else
            -- self:OnStartBoating()
        -- end
    -- end)
    -- inst:ListenForEvent("dismountboat", function(it, data)
        -- self:StopPlayingBoating()
        -- self:StopPlayingSurfing()
    -- end)


end)
