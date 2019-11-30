--customisation options

frontendassets = {
	Asset("IMAGE", "images/customization_shipwrecked.tex"),
	Asset("ATLAS", "images/customization_shipwrecked.xml"),
}

if GLOBAL.rawget(GLOBAL, "GEMWORLDGENCALLBACKS") == nil then GLOBAL.GEMWORLDGENCALLBACKS = {} end

GLOBAL.GEMWORLDGENCALLBACKS[#GLOBAL.GEMWORLDGENCALLBACKS + 1] = function()
	modimport "main/strings" --need a better solution for frontend strings -Z

	local STRINGS = GLOBAL.STRINGS

	local rate_descriptions = {
		{ text = STRINGS.UI.SANDBOXMENU.SLIDENEVER, data = "never" },
		{ text = STRINGS.UI.SANDBOXMENU.SLIDEVERYRARE, data = "veryrare" },
		{ text = STRINGS.UI.SANDBOXMENU.SLIDERARE, data = "rare" },
		{ text = STRINGS.UI.SANDBOXMENU.SLIDEDEFAULT, data = "default" },
		{ text = STRINGS.UI.SANDBOXMENU.SLIDEOFTEN, data = "often" },
		{ text = STRINGS.UI.SANDBOXMENU.SLIDEALWAYS, data = "always" },
	}

	local islandquantity_descriptions = {
		{ text = STRINGS.UI.SANDBOXMENU.BRANCHINGLEAST, data = "never" },
		{ text = STRINGS.UI.SANDBOXMENU.SLIDERARE, data = "rare" },
		{ text = STRINGS.UI.SANDBOXMENU.SLIDEDEFAULT, data = "default" },
		{ text = STRINGS.UI.SANDBOXMENU.SLIDEOFTEN, data = "often" },
		{ text = STRINGS.UI.SANDBOXMENU.BRANCHINGMOST, data = "always" },
	}

	local worldtypes = {
		{ text = STRINGS.UI.SANDBOXMENU.WORLDTYPE_DEFAULT, data = "default" },
		{ text = STRINGS.UI.SANDBOXMENU.WORLDTYPE_MERGED, data = "merged" },
		-- { text = STRINGS.UI.SANDBOXMENU.WORLDTYPE_ISLANDS, data = "islands" },
		{ text = STRINGS.UI.SANDBOXMENU.WORLDTYPE_ISLANDSONLY, data = "islandsonly" },
	}

	WorldGenOptions.AddGroup("islandmisc", {
		customtext = STRINGS.UI.SANDBOXMENU.CUSTOMIZATIONPREFIX_IA..STRINGS.UI.SANDBOXMENU.CHOICEMISC,
		desc = nil,
		enable = true,
		items = {
			["primaryworldtype"] = {value = "merged", enable = false, image = "world_map.tex", desc = worldtypes, order = 1, world={"forest"}},
			["islandquantity"] = {value = "default", enable = false, image = "world_size.tex", desc = islandquantity_descriptions, order = 2, world={"forest"}},
			-- ["islandsize"] = {value = "default", enable = false, image = "world_size.tex", desc = WorldGenOptions.size_descriptions, order = 3, world={"forest"}},
			["volcano"] = {value = "default", enable = false, image = "volcano.tex", atlas = "images/customization_shipwrecked.xml", desc = WorldGenOptions.yesno_descriptions, order = 4, world={"forest"}},
			["dragoonegg"] = {value = "default", enable = false, image = "dragooneggs.tex", atlas = "images/customization_shipwrecked.xml", desc = WorldGenOptions.frequency_descriptions, order = 5, world={"forest"}},
			["tides"] = {value = "default", enable = false, image = "tides.tex", atlas = "images/customization_shipwrecked.xml", desc = WorldGenOptions.yesno_descriptions, order = 6, world={"forest"}},
			["floods"] = {value = "default", enable = false, image = "floods.tex", atlas = "images/customization_shipwrecked.xml", desc = WorldGenOptions.frequency_descriptions, order = 7, world={"forest"}},
			["oceanwaves"] = {value = "default", enable = false, image = "waves.tex", atlas = "images/customization_shipwrecked.xml", desc = rate_descriptions, order = 8, world={"forest"}},
			["poison"] = {value = "default", enable = false, image = "poison.tex", atlas = "images/customization_shipwrecked.xml", desc = WorldGenOptions.yesno_descriptions, order = 9, world={"forest"}},
			["bermudatriangle"] = {value = "default", enable = false, image = "bermudatriangle.tex", atlas = "images/customization_shipwrecked.xml", desc = WorldGenOptions.frequency_descriptions, order = 10, world={"forest"}},
		}
	})
	WorldGenOptions.AddGroup("islandresources", {
		customtext = STRINGS.UI.SANDBOXMENU.CUSTOMIZATIONPREFIX_IA..STRINGS.UI.SANDBOXMENU.CHOICERESOURCES,
		desc = WorldGenOptions.frequency_descriptions,
		-- enable = false,
		items = {
			["fishinhole"] = {value = "default", enable = false, image = "shoals.tex", atlas = "images/customization_shipwrecked.xml", order = 8, world={"forest"}},
			["seashell"] = {value = "default", enable = false, image = "seashell.tex", atlas = "images/customization_shipwrecked.xml", order = 9, world={"forest"}},
			["bush_vine"] = {value = "default", enable = false, image = "vines.tex", atlas = "images/customization_shipwrecked.xml", order = 10, world={"forest"}},
			["seaweed"] = {value = "default", enable = false, image = "seaweed.tex", atlas = "images/customization_shipwrecked.xml", order = 11, world={"forest"}},
			["sandhill"] = {value = "default", enable = false, image = "sand.tex", atlas = "images/customization_shipwrecked.xml", order = 12, world={"forest"}},
			["crate"] = {value = "default", enable = false, image = "crates.tex", atlas = "images/customization_shipwrecked.xml", order = 13, world={"forest"}},
			["bioluminescence"] = {value = "default", enable = false, image = "bioluminescence.tex", atlas = "images/customization_shipwrecked.xml", order = 14, world={"forest"}},
			["coral"] = {value = "default", enable = false, image = "coral.tex", atlas = "images/customization_shipwrecked.xml", order = 15, world={"forest"}},
			["coral_brain_rock"] = {value = "default", enable = false, image = "braincoral.tex", atlas = "images/customization_shipwrecked.xml", order = 16, world={"forest"}},
			["bamboo"] = {value = "default", enable = false, image = "bamboo.tex", atlas = "images/customization_shipwrecked.xml", order = 17, world={"forest"}},
			["tidalpool"] = {value = "default", enable = false, image = "tidalpools.tex", atlas = "images/customization_shipwrecked.xml", order = 18, world={"forest"}},
			["poisonhole"] = {value = "default", enable = false, image = "poisonhole.tex", atlas = "images/customization_shipwrecked.xml", order = 19, world={"forest"}},
		}
	})
	WorldGenOptions.AddGroup("islandunprepared", {
		customtext = STRINGS.UI.SANDBOXMENU.CUSTOMIZATIONPREFIX_IA..STRINGS.UI.SANDBOXMENU.CHOICEFOOD,
		desc = WorldGenOptions.frequency_descriptions,
		-- enable = false,
		items = {
			--Note: This one could be linked to Carrots
			["sweet_potato"] = {value = "default", enable = true, image = "sweetpotatos.tex", atlas = "images/customization_shipwrecked.xml", order = 2, world={"forest"}},
			["limpets"] = {value = "default", enable = false, image = "limpets.tex", atlas = "images/customization_shipwrecked.xml", order = 4, world={"forest"}},
			["mussel_farm"] = {value = "default", enable = false, image = "mussels.tex", atlas = "images/customization_shipwrecked.xml", order = 5, world={"forest"}},
		}
	})
	WorldGenOptions.AddGroup("islandanimals", {
		customtext = STRINGS.UI.SANDBOXMENU.CUSTOMIZATIONPREFIX_IA..STRINGS.UI.SANDBOXMENU.CHOICEANIMALS,
		desc = WorldGenOptions.frequency_descriptions,
		-- enable = false,
		items = {
			["wildbores"] = {value = "default", enable = false, image = "wildbores.tex", atlas = "images/customization_shipwrecked.xml", order = 3, world={"forest"}},
			["whalehunt"] = {value = "default", enable = false, image = "whales.tex", atlas = "images/customization_shipwrecked.xml", order = 7, world={"forest"}},
			["crabhole"] = {value = "default", enable = false, image = "crabbits.tex", atlas = "images/customization_shipwrecked.xml", order = 8, world={"forest"}},
			["ox"] = {value = "default", enable = false, image = "ox.tex", atlas = "images/customization_shipwrecked.xml", order = 9, world={"forest"}},
			["solofish"] = {value = "default", enable = false, image = "dogfish.tex", atlas = "images/customization_shipwrecked.xml", order = 10, world={"forest"}},
			["doydoy"] = {value = "default", enable = false, image = "doydoy.tex", atlas = "images/customization_shipwrecked.xml", desc = WorldGenOptions.yesno_descriptions, order = 11, world={"forest"}},
			["jellyfish"] = {value = "default", enable = false, image = "jellyfish.tex", atlas = "images/customization_shipwrecked.xml", order = 12, world={"forest"}},
			["lobster"] = {value = "default", enable = false, image = "lobsters.tex", atlas = "images/customization_shipwrecked.xml", order = 13, world={"forest"}},
			--Note: This one could be linked to Birds
			["seagull"] = {value = "default", enable = false, image = "seagulls.tex", atlas = "images/customization_shipwrecked.xml", order = 14, world={"forest"}},
			["ballphin"] = {value = "default", enable = false, image = "ballphins.tex", atlas = "images/customization_shipwrecked.xml", order = 15, world={"forest"}},
			["primeape"] = {value = "default", enable = false, image = "monkeys.tex", atlas = "images/customization_shipwrecked.xml", order = 16, world={"forest"}},
		}
	})
	WorldGenOptions.AddGroup("islandmonsters", {
		customtext = STRINGS.UI.SANDBOXMENU.CUSTOMIZATIONPREFIX_IA..STRINGS.UI.SANDBOXMENU.CHOICEMONSTERS,
		desc = WorldGenOptions.frequency_descriptions,
		enable = false,
		items = {
			--TODO implement "Sharx" as "likelihood of sharx/crocodogs when meat lands on water" ?
			-- ["sharx"] = {value = "default", enable = false, image = "crocodog.tex", atlas = "images/customization_shipwrecked.xml", order = 1, world={"forest"}},
			--Note: This one is houndwaves, which technically speaking already exists.
			-- ["crocodog"] = {value = "default", enable = false, image = "crocodog.tex", atlas = "images/customization_shipwrecked.xml", order = 2, world={"forest"}},
			["twister"] = {value = "default", enable = false, image = "twister.tex", atlas = "images/customization_shipwrecked.xml", order = 7, world={"forest"}},
			["tigershark"] = {value = "default", enable = false, image = "tigershark.tex", atlas = "images/customization_shipwrecked.xml", order = 8, world={"forest"}},
			["kraken"] = {value = "default", enable = false, image = "kraken.tex", atlas = "images/customization_shipwrecked.xml", order = 9, world={"forest"}},
			["flup"] = {value = "default", enable = false, image = "flups.tex", atlas = "images/customization_shipwrecked.xml", order = 10, world={"forest"}},
			["mosquito"] = {value = "default", enable = false, image = "mosquitos.tex", atlas = "images/customization_shipwrecked.xml", order = 11, world={"forest"}},
			["swordfish"] = {value = "default", enable = false, image = "swordfish.tex", atlas = "images/customization_shipwrecked.xml", order = 12, world={"forest"}},
			["stungray"] = {value = "default", enable = false, image = "stinkrays.tex", atlas = "images/customization_shipwrecked.xml", order = 13, world={"forest"}},
		}
	})

	local servercreationscreen --= GLOBAL.TheFrontEnd:GetActiveScreen()
	for i, screen in pairs(GLOBAL.TheFrontEnd.screenstack) do
		if screen.name == "ServerCreationScreen" then
			servercreationscreen = screen
			break
		end
	end
	if servercreationscreen and servercreationscreen.world_tabs and servercreationscreen.world_tabs[1] then
		local Levels = GLOBAL.require "map/levels"
		local PopupDialogScreen = GLOBAL.require "screens/redux/popupdialog"

		--Disable Caves on Shipwrecked worlds
		if not servercreationscreen.world_tabs[1].ia_hijacked then
			servercreationscreen.world_tabs[1].ia_hijacked = true

			local function processOption(optionname, value)
				if (optionname == "primaryworldtype" and value == "islandsonly" or optionname == "task_set" and value == "islandadventures")
				and servercreationscreen.world_tabs[1].allowEdit and servercreationscreen.world_tabs[2].allowEdit then
					--Politely ask to disable caves
					if servercreationscreen.world_tabs[2] and servercreationscreen.world_tabs[2].current_option_settings[servercreationscreen.world_tabs[2].tab_location_index] then
						GLOBAL.TheFrontEnd:PushScreen(PopupDialogScreen(GLOBAL.STRINGS.UI.SANDBOXMENU.IA_NOCAVES_TITLE, STRINGS.UI.SANDBOXMENU.IA_NOCAVES_BODY,
						{
							{text=GLOBAL.STRINGS.UI.CUSTOMIZATIONSCREEN.YES, cb = function()
								servercreationscreen.world_tabs[2]:RemoveMultiLevel(servercreationscreen.world_tabs[2].currentmultilevel)
								servercreationscreen.world_tabs[2]:UpdateMultilevelUI()
								GLOBAL.TheFrontEnd:PopScreen()
							end},
							{text=GLOBAL.STRINGS.UI.CUSTOMIZATIONSCREEN.NO, cb = function()
								GLOBAL.TheFrontEnd:PopScreen()
							end}
						}))
					end
					if servercreationscreen.world_tabs[2] and servercreationscreen.world_tabs[2].sublevel_adder_overlay and servercreationscreen.world_tabs[2].sublevel_adder_overlay.body then
						servercreationscreen.world_tabs[2].sublevel_adder_overlay.body:SetString(GLOBAL.STRINGS.UI.SANDBOXMENU.ADDLEVEL_WARNING_IA)
					end
					return true
				else
					--Check if the warnings are still relevant
					local current_option_settings = servercreationscreen.world_tabs[1] and servercreationscreen.world_tabs[1].current_option_settings[servercreationscreen.world_tabs[1].tab_location_index]
					local presetdata = Levels.GetDataForLevelID(current_option_settings.preset)
					local primaryworldtype = current_option_settings and current_option_settings.tweaks.primaryworldtype
						or presetdata and presetdata.overrides.primaryworldtype
					local task_set = current_option_settings and current_option_settings.tweaks.task_set
						or presetdata and presetdata.overrides.task_set
					if primaryworldtype ~= "islandsonly" and task_set ~= "islandadventures" then
						if servercreationscreen.world_tabs[2] and servercreationscreen.world_tabs[2].sublevel_adder_overlay and servercreationscreen.world_tabs[2].sublevel_adder_overlay.body then
							servercreationscreen.world_tabs[2].sublevel_adder_overlay.body:SetString(GLOBAL.STRINGS.UI.SANDBOXMENU.ADDLEVEL_WARNING)
						end
						return false
					end
				end
			end

			--update when the preset changes
			local LoadPreset_old = servercreationscreen.world_tabs[1].LoadPreset
			servercreationscreen.world_tabs[1].LoadPreset = function(self, preset, ...)
				LoadPreset_old(self, preset, ...)
				
				local presetdata = Levels.GetDataForLevelID(self.current_option_settings[self.tab_location_index].preset)
				if presetdata then
					if not processOption("primaryworldtype", presetdata.overrides.primaryworldtype) then
						processOption("task_set", presetdata.overrides.task_set)
					end
				end
				-- processOption("primaryworldtype", preset == "SURVIVAL_SHIPWRECKED_CLASSIC" and "islandsonly")
			end

			--update when the option changes
			local SetTweak_old = servercreationscreen.world_tabs[1].SetTweak
			servercreationscreen.world_tabs[1].SetTweak = function(self, level, option, value, ...)
				SetTweak_old(self, level, option, value, ...)
				processOption(option, value)
				return 
			end
		end

		
		--Automatically try switching to the Shipwrecked Preset
		local presetspinner = servercreationscreen.world_tabs[1].presetspinner.spinner
		if presetspinner and #presetspinner.options > 1 then --only 1 if already generated
			for i, preset in pairs(presetspinner.options) do
				if preset.data == "SURVIVAL_SHIPWRECKED_CLASSIC" then
					local oldSelection = presetspinner.selectedIndex
					presetspinner:SetSelectedIndex(i)
					presetspinner:Changed(oldSelection)
					break
				end
			end
		end

	end

end
