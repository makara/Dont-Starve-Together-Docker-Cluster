-- Some code from Russian Language Pack.
-- Thanks to Russian Language Pack(http://steamcommunity.com/sharedfiles/filedetails/?id=354836336) for helping me.
--[[ -- 调试用
local function print_lua_table (lua_table, indent)
	indent = indent or 0
	for k, v in pairs(lua_table) do
		if type(k) == "string" then
			k = string.format("%q", k)
		end
		local szSuffix = ""
		if type(v) == "table" then
			szSuffix = "{"
		end
		local szPrefix = string.rep("	", indent)
		formatting = szPrefix.."["..k.."]".." = "..szSuffix
		if type(v) == "table" then
			print(formatting)
			print_lua_table(v, indent + 1)
			print(szPrefix.."},")
		else
			local szValue = ""
			if type(v) == "string" then
				szValue = string.format("%q", v)
			else
				szValue = tostring(v)
			end
			print(formatting..szValue..",")
		end
	end
end
]]
if not ISPLAYINGNOW then
	--去除KLEI广告。我是简洁控。
	AddClassPostConstruct("screens/multiplayermainscreen", function(self)
		if self.motd then
			self.motd:Hide()
			function SetMOTD(...)
				self.motd:Hide()
			end
			self.SetMOTD = SetMOTD
		end
	end)

	-- 修复游戏模式的汉化
	if GLOBAL.rawget(GLOBAL,"GAME_MODES") and GLOBAL.LanguageTranslator.defaultlang and STRINGS.UI.SERVERCREATIONSCREEN then
		for i,v in pairs(GLOBAL.GAME_MODES) do
			for ii,vv in pairs(STRINGS.UI.GAMEMODES) do
				if v.text and v.text==vv then GLOBAL.GAME_MODES[i].text=GLOBAL.LanguageTranslator.languages[GLOBAL.LanguageTranslator.defaultlang]["STRINGS.UI.GAMEMODES."..ii] or GLOBAL.GAME_MODES[i].text end
				if v.hover_text and v.hover_text==vv then GLOBAL.GAME_MODES[i].hover_text=GLOBAL.LanguageTranslator.languages[GLOBAL.LanguageTranslator.defaultlang]["STRINGS.UI.GAMEMODES."..ii] or GLOBAL.GAME_MODES[i].hover_text end
				if v.description and v.description==vv then GLOBAL.GAME_MODES[i].description=GLOBAL.LanguageTranslator.languages[GLOBAL.LanguageTranslator.defaultlang]["STRINGS.UI.GAMEMODES."..ii] or GLOBAL.GAME_MODES[i].description end
			end
		end
	end

	--修复世界的标题和描述
	if GLOBAL.LanguageTranslator.defaultlang then
		local PresetLevels = {}
		for i,v in pairs(STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELS) do
			if v ~= nil and type(v) == "string" then
				local leveltoshow
				if i ~= nil and type(i) == "string" then
					leveltoshow = GLOBAL.TrimString(string.upper(i)) ~= nil and GLOBAL.TrimString(string.upper(i)) or ""
				else
					leveltoshow = i ~= nil and i or ""
				end
				PresetLevels[v] = GLOBAL.LanguageTranslator.languages[GLOBAL.LanguageTranslator.defaultlang]["STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELS."..leveltoshow] or v
			end
		end
		for i,v in pairs(STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELDESC) do
			if v ~= nil and type(v) == "string" then
				local desctoshow
				if i ~= nil and type(i) == "string" then
					desctoshow = GLOBAL.TrimString(string.upper(i)) ~= nil and GLOBAL.TrimString(string.upper(i)) or ""
				else
					desctoshow = i ~= nil and i or ""
				end
				PresetLevels[v] = GLOBAL.LanguageTranslator.languages[GLOBAL.LanguageTranslator.defaultlang]["STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELDESC."..desctoshow] or v
			end
		end

		AddClassPostConstruct("widgets/customizationtab", function(self)
			local oldUpdatePresetInfo = self.UpdatePresetInfo
			function self:UpdatePresetInfo(level)
				oldUpdatePresetInfo(self, level)
				self.presetdesc:SetString( PresetLevels[self.presetdesc:GetString()] or self.presetdesc:GetString() )
				self.presetspinner.spinner:UpdateText( PresetLevels[self.presetspinner.spinner:GetText()] or self.presetspinner.spinner:GetText() )
			end

		end)
	end

	-- 修复世界选项的汉化
	local SandboxMenuData = {}
	for i,v in pairs(STRINGS.UI.SANDBOXMENU) do
		SandboxMenuData[v] = i
	end
	SandboxMenuData["Classic"] = "经典"
	SandboxMenuData["Medium"] = "中等"

	AddClassPostConstruct("widgets/customizationlist", function(self)
		if self.optionwidgets then
			for i,v in pairs(self.optionwidgets) do
				for ii,vv in pairs(v:GetChildren()) do
					if vv.name and vv.name:upper()=="TEXT" then
						local words = vv:GetString():split(" ")
						local res
						if #words==2 then
							local second = SandboxMenuData[ words[2] ]
							words[2] = STRINGS.UI.SANDBOXMENU[second] or words[2]
							if words[1]==STRINGS.UI.SANDBOXMENU.LOCATION.FOREST then
								res = "地面森林的 "..words[2].." 选项"
							elseif words[1]==STRINGS.UI.SANDBOXMENU.LOCATION.CAVE then
								res = "地下洞穴的 "..words[2].." 选项"
							elseif words[1]==STRINGS.UI.SANDBOXMENU.LOCATION.UNKNOWN then
								res = "某世界的 "..words[2].." 选项"
							end
						end
						if res then vv:SetString(res) end
					elseif vv.name and vv.name:upper()=="OPTION" then
						for iii,vvv in pairs(vv:GetChildren()) do
							if vvv.name and vvv.name:upper()=="SPINNER" then
								for _,opt in ipairs(vvv.options) do
									if SandboxMenuData[opt["text"]] then
										opt["text"] = STRINGS.UI.SANDBOXMENU[ SandboxMenuData[opt["text"]] ] or SandboxMenuData[opt["text"]]
									else
										if not opt["text"] then break end

										local words = opt["text"]:split(" ") or opt["text"] or ""

										for idx, txt in ipairs(words) do
											local p = SandboxMenuData[txt]
											words[idx] = p and STRINGS.UI.SANDBOXMENU[p] or words[idx]
										end

										if opt["text"] == "Classic" then
											words[1] = STRINGS.UI.CUSTOMIZATIONSCREEN.TASKSETNAMES.CLASSIC
										elseif opt["text"] == "Together" then
											words[1] =STRINGS.UI.CUSTOMIZATIONSCREEN.TASKSETNAMES.DEFAULT
										elseif opt["text"] == "Underground" then
											words[1] =STRINGS.UI.CUSTOMIZATIONSCREEN.TASKSETNAMES.CAVE_DEFAULT
										end

										opt["text"] = words[1] or opt["text"]
										for idx=2,#words do opt["text"] = opt["text"].." "..words[idx] end
									end
								end
							end
						end
					end
				end
			end
		end
	end)

	--服务器的连接模式汉化
	local privacy_options = {}
	for i,v in pairs(STRINGS.UI.SERVERCREATIONSCREEN.PRIVACY) do
		privacy_options[v] = i
	end

	AddClassPostConstruct("widgets/serversettingstab", function(self)
		if self.privacy_type and self.privacy_type.buttons and self.privacy_type.buttons.buttonwidgets then
			for _,option in pairs(self.privacy_type.buttons.options) do
				if privacy_options[option.text] then
					option.text = STRINGS.UI.SERVERCREATIONSCREEN.PRIVACY[ privacy_options[option.text] ]
				end
			end
		end
	end)

	-- 修复游戏风格汉化
	AddClassPostConstruct("widgets/intentionpicker", function(self)
		for i,v in ipairs(self.buttons) do
			local buttontittle = self.buttons[i]:GetText()
			if buttontittle == "Social" then
				self.buttons[i]:SetText(STRINGS.UI.INTENTION.SOCIAL)
			elseif buttontittle == "Madness" then
				self.buttons[i]:SetText(STRINGS.UI.INTENTION.MADNESS)
			elseif buttontittle == "Cooperative" then
				self.buttons[i]:SetText(STRINGS.UI.INTENTION.COOPERATIVE)
			elseif buttontittle == "Competitive" then
				self.buttons[i]:SetText(STRINGS.UI.INTENTION.COMPETITIVE)
			elseif buttontittle == "Any" then
				self.buttons[i]:SetText(STRINGS.UI.INTENTION.ANY)
			end
		end
	end)

	-- 设置界面的 Enabled Disabled 汉化
	AddClassPostConstruct("screens/optionsscreen", function(self)
		for _,v in pairs(self) do
			if type(v)=="table" and v.name=="SPINNER" then
				for _,opt in ipairs(v.options) do
					if opt.text=="Enabled" then
						opt.text=STRINGS.UI.OPTIONS.ENABLED
					elseif opt.text=="Disabled" then
						opt.text=STRINGS.UI.OPTIONS.DISABLED
					end
				end
				if v.selectedIndex and v.selectedIndex>0 and v.selectedIndex<=#v.options then v:UpdateText(v.options[v.selectedIndex].text) end
			end
		end
	end)

end

if _G.TheNet:GetIsClient() or ( _G.TheNet:GetIsServer() and _G.TheNet:GetServerIsClientHosted() ) then
	-- 修复在服务器中[Host]为【主机】
	if _G.TheNet.GetClientTable then
		_G.getmetatable(_G.TheNet).__index.GetClientTable = (function()
			local oldGetClientTable = _G.getmetatable(_G.TheNet).__index.GetClientTable
			return function(self, ... )
				local res=oldGetClientTable(self, ...)
				if res and type(res)=="table" then
					for i,v in pairs(res) do
						if v.name and v.prefab then
							if v.name=="[Host]" then v.name="【主机】" end
						end
					end
				end
				return res
			end
		end)()
	end

	--路牌汉化。
	AddClassPostConstruct("widgets/writeablewidget", function(self)
		if self.menu and self.menu.items then
		local translations={["Cancel"]="退出",["Random"]="随机",["Write it!"]="写上去！"}
			for i,v in pairs(self.menu.items) do
				if v.text and translations[v.text:GetString()] then
					v.text:SetString(translations[v.text:GetString()])
				end
			end
		end
	end)

	-- 修复锅的汉化
	AddClassPostConstruct("widgets/containerwidget", function(self)
		if not self.oldOpen then
			self.oldOpen=self.Open
			local function newOpen(self, container, doer)
				self:oldOpen(container, doer)

				if self.button then
					if self.button:GetText()=="Cook" then self.button:SetText(STRINGS.ACTIONS.STORE.COOK) end
					if self.button:GetText()=="Activate" then self.button:SetText(STRINGS.ACTIONS.ACTIVATE.GENERIC) end
				end
				if self.button2 then
					if self.button2:GetText()=="Predict!" then self.button2:SetText("预测") end
				end
			end
			self.Open=newOpen
		end
	end)

	-- 设置界面的 Enabled Disabled 汉化
	AddClassPostConstruct("screens/optionsscreen", function(self)
		for _,v in pairs(self) do
			if type(v)=="table" and v.name=="SPINNER" then
				for _,opt in ipairs(v.options) do
					if opt.text=="Enabled" then
						opt.text=STRINGS.UI.OPTIONS.ENABLED
					elseif opt.text=="Disabled" then
						opt.text=STRINGS.UI.OPTIONS.DISABLED
					end
				end
				if v.selectedIndex and v.selectedIndex>0 and v.selectedIndex<=#v.options then v:UpdateText(v.options[v.selectedIndex].text) end
			end
		end
	end)

end
