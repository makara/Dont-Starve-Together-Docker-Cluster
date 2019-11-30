local ia_fx = {
    {
    	name = "splash_water",
    	bank = "splash_water",
    	build = "splash_water",
    	anim = "idle",
	},
    {
    	name = "splash_water_drop",
    	bank = "splash_water_drop",
    	build = "splash_water_drop",
    	anim = "idle",
	},
	{
    	name = "splash_water_sink",
    	bank = "splash_water_drop",
    	build = "splash_water_drop",
    	anim = "idle_sink",
	},
    {
    	name = "splash_water_big",
    	bank = "splash_water_big",
    	build = "splash_water_big",
    	anim = "idle",
	},
	{
	    name = "hacking_fx", 
	    bank = "hacking_fx", 
	    build = "hacking_fx", 
	    anim = "idle",
    },
    {
	    name = "hacking_bamboo_fx", 
	    bank = "hacking_bamboo_fx", 
	    build = "hacking_bamboo_fx", 
	    anim = "idle",
    },
	{
	    name = "boat_hit_fx", --dummy fx data, not working quite yet
	    bank = "boat_hit_debris",
	    build = "boat_hit_debris",
	    anim = "hit_rowboat",
    },
    {
    	name = "boat_hit_fx_raft_log",
	    bank = "boat_hit_debris",
	    build = "boat_hit_debris",
	    anim = "hit_raft_log",
    },
    {
    	name = "boat_hit_fx_raft_bamboo",
	    bank = "boat_hit_debris",
	    build = "boat_hit_debris",
	    anim = "hit_raft_bamboo",
    },
    {
    	name = "boat_hit_fx_rowboat",
	    bank = "boat_hit_debris",
	    build = "boat_hit_debris",
	    anim = "hit_rowboat",
    },
    {
    	name = "boat_hit_fx_cargoboat",
	    bank = "boat_hit_debris",
	    build = "boat_hit_debris",
	    anim = "hit_cargoboat",
    },
    {
    	name = "boat_hit_fx_armoured",
	    bank = "boat_hit_debris",
	    build = "boat_hit_debris",
	    anim = "hit_armoured",
    },
    {
    	name = "splash_footstep",
    	bank = "splash_footstep",
    	build = "splash_footstep",
    	anim = "anim",
	},
    {
    	name = "jungle_chop",
    	bank = "chop_jungle",
    	build = "chop_jungle",
    	anim = "chop",
	},
    {
    	name = "jungle_fall",
    	bank = "chop_jungle",
    	build = "chop_jungle",
    	anim = "fall",
	},
    {
    	name = "mangrove_chop",
    	bank = "chop_mangrove",
    	build = "chop_mangrove",
    	anim = "chop",
	},
    {
    	name = "mangrove_fall",
    	bank = "chop_mangrove",
    	build = "chop_mangrove",
    	anim = "fall",
	},
	{
		name = "bombsplash",
    	bank = "bombsplash",
    	build = "water_bombsplash",
    	anim = "splash",
	},
	{
		name = "lava_bombsplash",
    	bank = "lava_bombsplash",
    	build = "lava_bombsplash",
    	anim = "splash",
	},
	{
		name = "clouds_bombsplash",
    	bank = "clouds_bombsplash",
    	build = "clouds_bombsplash",
    	anim = "splash",
	},
    {
	    name = "explode_large",
	    bank = "explode",
	    build = "explode",
	    anim = "large",
        bloom = true,
		sound = "dontstarve/common/blackpowder_explo",
        fn = function(inst)
			inst.AnimState:SetLightOverride(-1)
		end,
    },
    {
    	name = "explodering_fx",
    	bank = "explode_ring_fx",
    	build = "explode_ring_fx",
    	anim = "idle",
        fn = function(inst)
			inst.AnimState:SetFinalOffset(-1)
			inst.AnimState:SetOrientation( GLOBAL.ANIM_ORIENTATION.OnGround )
			inst.AnimState:SetLayer( GLOBAL.LAYER_BACKGROUND )
			inst.AnimState:SetSortOrder( 3 )
		end,
	},
	{
		name = "pixel_out",
    	bank = "pixels",
    	build = "pixel_fx",
    	anim = "out",
	},
	{
		name = "pixel_in",
    	bank = "pixels",
    	build = "pixel_fx",
    	anim = "in",
	},
    {
	    name = "small_puff_light", 
	    bank = "small_puff", 
	    build = "smoke_puff_small", 
	    anim = "puff",
	    sound = "dontstarve/common/deathpoof",
	    tintalpha = 0.5,
    },
    {
	    name = "coconut_chunks", 
	    bank = "ground_breaking", 
	    build = "ground_chunks_breaking", 
	    anim = "idle",
	    sound = "ia/creatures/palm_tree_guard/coconut_explode",
	    tint = GLOBAL.Vector3(183/255,143/255,85/255),
	},
	{
	    name = "poop_splat", 
	    bank = "ground_breaking", 
	    build = "ground_chunks_breaking", 
	    anim = "idle",
	    sound = "ia/common/poop_splat",
	    tint = GLOBAL.Vector3(183/255,143/255,85/255),
	},
	{
	    name = "smoke_out", 
	    bank = "smoke_out", 
	    build = "smoke_plants", 
	    anim = "smoke_loop",
	    --sound = "dontstarve/common/deathpoof",
	    --tintalpha = 0.5,
    },
    {
	    name = "shock_machines_fx", 
	    bank = "shock_machines_fx", 
	    build = "shock_machines_fx", 
	    anim = "shock",
	    sound = "ia/creatures/jellyfish/electric_land",
	},
	{
		name = "feathers_packim_fire",
	    bank = "feathers_packim", 
	    build = "feathers_packim_fire", 
	    anim = "transform",
	},
	{
		name = "feathers_packim_fat",
	    bank = "feathers_packim", 
	    build = "feathers_packim", 
	    anim = "transform",
	},
	{
		name = "feathers_packim",
	    bank = "feathers_packim", 
	    build = "feathers_packim", 
	    anim = "transform",
	},
    {
	    name = "boat_death", 
	    bank = "boatdeathshadow", 
	    build = "boat_death_shadows", 
	    anim = "boat_death",
	    tintalpha = 0.5,
    },
    {
    	name = "dragoon_charge_fx",
    	bank = "fx",
    	build = "dragoon_charge_fx",
    	anim = "move",
	},
    {
    	name = "splash_lava_drop",
    	bank = "splash_lava_drop",
    	build = "splash_lava_drop",
    	anim = "idle_sink",
	},
    {
    	name = "splash_clouds_drop",
    	bank = "splash_clouds_drop",
    	build = "splash_clouds_drop",
    	anim = "idle_sink",
	},
    {
    	name = "kraken_ink_splat",
    	bank = "ink",
    	build = "ink_projectile",
    	anim = "splat",
	},
    {
    	name = "doydoy_mate_fx",
    	bank = "doydoy_mate_fx",
    	build = "doydoy_mate_fx",
		-- sound = "ia/creatures/doydoy/mating_voices_LP",
		-- sound2 = "ia/creatures/doydoy/mating_cloud_LP",
		transform = GLOBAL.Vector3(1.2,1.2,1.2),
    	anim = "mate_pre",
	    animqueue = true,
        fn = function(inst)
			inst.AnimState:SetSortOrder(-1)
			inst.AnimState:PushAnimation("mate_loop")
			inst.AnimState:PushAnimation("mate_loop")
			inst.AnimState:PushAnimation("mate_loop")
			inst.AnimState:PushAnimation("mate_pst", false)
			inst.entity:AddSoundEmitter()
			inst.SoundEmitter:PlaySound("ia/creatures/doydoy/mating_voices_LP", "voices_LP")
			inst.SoundEmitter:PlaySound("ia/creatures/doydoy/mating_cloud_LP", "cloud_LP")
			inst:ListenForEvent("onremove", function()
				inst.SoundEmitter:KillAllSounds()
			end)
		end,
	},
    {
    	name = "windswirl",
    	bank = "wind_fx",
    	build = "wind_fx",
    	anim = "side_wind_loop",
	    autorotate = true,
	    nofaced = true,
        fn = function(inst)
			inst.AnimState:SetOrientation( GLOBAL.ANIM_ORIENTATION.OnGround )
			if GLOBAL.TheWorld.state.gustspeed < 0.01 then
				inst:Remove()
			else
				inst.AnimState:SetMultColour(1, 1, 1, GLOBAL.TheWorld.state.gustspeed)
			end
		end,
	},
    -- { --used by blowinwindgustitem, except this thing's invisible, so it'd just clog the network
    	-- name = "windtrail",
    	-- bank = "action_lines",
    	-- build = "action_lines",
    	-- anim = "idle_loop",
	    -- autorotate = true,
	    -- nofaced = true,
	-- },
}

-- Sneakily add these to the FX table
-- Also force-load the assets because the fx file won't do for some reason

GLOBAL.require("fx")

if GLOBAL.package.loaded.fx then
	for k,v in pairs(ia_fx) do
		table.insert(GLOBAL.package.loaded.fx, v)
		table.insert(Assets, Asset("ANIM", "anim/".. v.build ..".zip"))
	end
end
