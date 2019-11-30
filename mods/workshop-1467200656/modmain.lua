
if GLOBAL.TheNet:IsDedicated() then return end

Assets = {
  -- Asset("SOUND", "sound/ia_amb_hurricane.fsb"),
  Asset("SOUND", "sound/ia_amb_rain.fsb"),
  Asset("SOUND", "sound/ia_amb_green.fsb"),
  Asset("SOUND", "sound/ia_amb_mild.fsb"),
  Asset("SOUND", "sound/ia_amb_wet.fsb"),
  Asset("SOUND", "sound/ia_amb_dry.fsb"),
  Asset("SOUND", "sound/ia_amb_misc.fsb"),
  Asset("SOUND", "sound/ia_creature.fsb"),
  Asset("SOUND", "sound/ia_music.fsb"),
  Asset("SOUND", "sound/ia_sfx.fsb"),
  Asset("SOUND", "sound/ia_sfx_lp.fsb"),
  Asset("SOUND", "sound/ia_voice.fsb"),
  Asset("SOUND", "sound/ia_volcano.fsb"),
  -- These are loaded by the characters directly once needed
  -- Asset("SOUND", "sound/ia_walani.fsb"),
  -- Asset("SOUND", "sound/ia_warly.fsb"),
  -- Asset("SOUND", "sound/ia_wilbur.fsb"),
  -- Asset("SOUND", "sound/ia_woodlegs.fsb"),
  Asset("SOUNDPACKAGE", "sound/ia.fev"),
}

