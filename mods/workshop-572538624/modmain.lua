--读取配置
local function GetConfig(s,default)
	local c=GetModConfigData(s)
	if c==nil then
		c=default
	end
	if type(c)=="table" then
		c=c.option_data
	end
	return c
end

IS_CHS_ALL_MOD = GetConfig("IS_CHS_ALL_MOD", true)
IS_CHS_FIX_ALL = GetConfig("IS_CHS_FIX_ALL", true)
IS_CHS_SETTINGS = GetConfig("IS_CHS_SETTINGS", true)
IS_CHS_CHARACTER = GetConfig("IS_CHS_CHARACTER", true)
IS_CHS_FIX_STRINGS = GetConfig("IS_CHS_FIX_STRINGS", false)

-- 准备
_G = GLOBAL
STRINGS = _G.STRINGS
require = _G.require
local string = _G.string
if not STRINGS then return end
local chinese_fix = nil
local modtochinese = "mod_main.lua"
local chinese_settings = "mod_info.lua"
chinesefolder = nil
modnametofolder = nil
ISPLAYINGNOW = ( _G.TheNet:GetIsClient() or _G.TheNet:GetIsServer() )
ISCLIENTPLAYINGNOW = _G.TheNet:GetIsClient() or ( _G.TheNet:GetIsServer() and _G.TheNet:GetServerIsClientHosted() )

-- 外接的参数，可被其他mod调用
_G.ChinesePlus =
{
	-- 游戏语言，用于判断语言 0 = 默认， 1 = 简体， 2 = 繁体
	lang = 0,

	-- 是否可以汉化mod内容，用于调用时判断
	mods = false,
	--[[
	-- 其他可调用函数(也可以直接覆盖游戏STRINGS表):
	-- act = 旧的动作id， new = 汉化动作
	_G.ChinesePlus.RenameAction(act,new)

	-- tab = 旧的侧栏id， new = 汉化侧栏
	_G.ChinesePlus.RenameTab(tab,new)

	-- strid = 旧的物品描述id， new = 汉化物品描述 (内含换行功能，不换行会显示空白)
	_G.ChinesePlus.RenameRecipe(strid,new)

	-- strid = 旧的id， new = 汉化内容
	_G.ChinesePlus.RenameStrings(strid,new)
	]]

	-- 是否可以汉化mod选项，用于调用时判断
	settings = false,
	--[[
	-- 其他可调用函数:
	-- name = 要汉化的mod的名字，写原来的就好，不要汉化，靠这个确定汉化的mod是哪个。
	-- description = 汉化mod描述
	-- hash_tbl = 汉化mod选项的快速表
	-- configuration_options = 重写汉化mod选项
	-- custom_fn = 特殊功能
	_G.ChinesePlus.SetConfigTranslation(name,description,hash_tbl,configuration_options,custom_fn)
	]]

	-- 游戏目录里面的 mod 表，mod_names["mod名"]返回true = 开启，mod_names["mod名"] ~= nil表明存在。
	mod_names = nil,

	-- 强制在洞穴服务器开启的客户端 mod 表。
	--[[
	使用方法：
	if not _G.ChinesePlus.force_enable_mod["mod名"] then
		_G.ChinesePlus.force_enable_mod["mod名"] = true
	end
	]]
	force_enable_mod = {
		["Chinese Plus"] = true,
		["Chinese Language Pack"] = true,
		["dix's Simplified Chinese Translation"] = true,
		["MAX DST汉化测试"] = true,
		["[DST]MUSHA For Chinese"] = true,

	},
}

do
	local support_languages = { chs = true, cht = true, zh_CN = "chs", cn = "chs", TW = "cht", }
	local steam_support_languages = { schinese = "chs", tchinese = "cht", }
	local steamlang = _G.TheNet:GetLanguageCode() or nil

	local function chsorcht(langswitch)
		if langswitch == "chs" then
			chinese_fix = "chs_fix.lua"
			chinesefolder = "chs"
			_G.ChinesePlus.lang = 1
		elseif langswitch == "cht" then
			chinese_fix = "cht_fix.lua"
			chinesefolder = "cht"
			_G.ChinesePlus.lang = 2
		else
			print("[Chinese Plus] Can't find language 'chs','cht'... 汉化失败无中文语言包(或你的语言包不在支持列表)！")
			_G.ChinesePlus.lang = 0
		end
	end

	if steamlang and steam_support_languages[steamlang] then
		print("[Chinese Plus] 从 steam 获取语言!")
		chsorcht(steam_support_languages[steamlang])
	else
		local lang = _G.LanguageTranslator.defaultlang or nil
		if lang ~= nil and support_languages[lang] ~= nil then
			if support_languages[lang] ~= true then
				lang = support_languages[lang]
			end
			print("[Chinese Plus] 从翻译 mod 获取语言!")
			chsorcht(lang)
		end
	end
end

if _G.ChinesePlus.lang == 0 then return end

--判断mod是否存在并启用
if IS_CHS_ALL_MOD or IS_CHS_SETTINGS then
	_G.ChinesePlus.mod_names = {}
	modnametofolder = {}
	local function GetAllModNames()
		if not (_G.KnownModIndex and _G.KnownModIndex.savedata and _G.KnownModIndex.savedata.known_mods) then
			return
		end
		for folder, mod in pairs(_G.KnownModIndex.savedata.known_mods) do
			local name = mod.modinfo.name
			if name then
				_G.ChinesePlus.mod_names[name] = ( (mod.enabled or mod.temp_enabled or _G.KnownModIndex:IsModForceEnabled(folder) or _G.KnownModIndex:IsModEnabled(folder) ) and not mod.temp_disabled ) and true or false
				modnametofolder[name] = folder
			end
		end
	end

	GetAllModNames()

	if _G.ChinesePlus.lang ~= 0 and not ISPLAYINGNOW then
		print("[Chinese Plus] 强制创建世界开启汉化mod")

		function _G.SaveIndex:SetServerEnabledMods(slot)
			--Save enabled server mods to the save index
			local server_enabled_mods = _G.ModManager:GetEnabledServerModNames()

			local force_enable_mod_folders = {}
			for k,v in pairs(_G.ChinesePlus.force_enable_mod) do
				if _G.ChinesePlus.mod_names[k] and v then
					force_enable_mod_folders[modnametofolder[k]] = true
					table.insert(server_enabled_mods, modnametofolder[k])
				end
			end

			local enabled_mods = {}
			for _,modname in pairs(server_enabled_mods) do
				local mod_data = { enabled = true } --Note(Peter): The format of mod_data now must match the format expected in modoverrides.lua. See ModIndex:ApplyEnabledOverrides
				mod_data.configuration_options = {}
				local force_local_options = true
				local config = _G.KnownModIndex:LoadModConfigurationOptions(modname, false)
				if force_enable_mod_folders[modname] then
					config = _G.KnownModIndex:LoadModConfigurationOptions(modname, true)
				end
				if config and type(config) == "table" then
					for i,v in pairs(config) do
						if v.saved ~= nil then
								mod_data.configuration_options[v.name] = v.saved
						else
								mod_data.configuration_options[v.name] = v.default
						end
					end
				end
				enabled_mods[modname] = mod_data
			end
			if self.data then self.data.slots[slot or self.current_slot].enabled_mods = enabled_mods end
		end

		AddClassPostConstruct("screens/servercreationscreen", function(self)
				function self:CheckForDisabledMods()

					local function isModEnabled(mod, enabledmods)
						for _,modname in pairs(enabledmods) do
							if mod == modname then
								return true
							end
						end
						return false
					end

					local disabled = {}

					local savedmods = _G.SaveGameIndex:GetEnabledMods(self.saveslot)
					local currentlyenabledmods = _G.ModManager:GetEnabledServerModNames()

					local force_enable_mod_folders = {}
					for k,v in pairs(_G.ChinesePlus.force_enable_mod) do
						if _G.ChinesePlus.mod_names[k] and v then
							force_enable_mod_folders[modnametofolder[k]] = true
						end
					end

					for modname,_ in pairs(savedmods) do
						if not isModEnabled(modname, currentlyenabledmods) then
							if not force_enable_mod_folders[modname] then
								table.insert(disabled, modname)
							end
						end
					end

					return disabled
				end
			end)

	end
end

--[[ -- 调试使用，输出mod信息
for k,v in pairs(_G.ChinesePlus.mod_names) do
	if v then
		print(k.."是启用状态")
	else
		print(k.."是关闭状态")
	end
end
--]]

-- 主要功能开始

function StrLength(str, limit)
	if not str then return str end
	local str_to = string.gsub( str , '\n' , '')
	str_to = string.gsub( str_to , ' ' , '')
	local Size = 0
	local lenInByte = #str_to
	local ennum = 0
	local chnum = 0
	local i = 1
	while true do
		if i <= lenInByte then
			local curByte = string.byte(str_to, i)

			if curByte>0 and curByte<=127 then
				byteCount = 1
			elseif curByte>=192 and curByte<223 then
				byteCount = 2
			elseif curByte>=224 and curByte<239 then
				byteCount = 3
			elseif curByte>=240 and curByte<=247 then
				byteCount = 4
			end

			local char = string.sub(str_to, i, i+byteCount-1)
			i = i + byteCount

			if byteCount == 1 then
				ennum = ennum + 1
			else
				chnum = chnum + 1
			end

			Size = chnum*2 + ennum
			if chnum > 0 and Size > limit and char and not string.find("()", char, 1, true) then
				str_to = string.gsub( str_to, char, char.."\n", 1 )
				ennum = 0
				chnum = 0
				i = i + 1
			end

		else
			break
		end
	end
	return str_to
end

if IS_CHS_FIX_STRINGS and ISCLIENTPLAYINGNOW then
	local function FixStrings()
		local fixid = ""
		local fixstr = ""
		for k, v in pairs(_G.STRINGS.RECIPE_DESC) do
			fixid = "STRINGS.RECIPE_DESC."..k
			fixstr = StrLength(_G.LanguageTranslator.languages[_G.LanguageTranslator.defaultlang][fixid], 16)
			print(fixstr)
			_G.LanguageTranslator.languages[_G.LanguageTranslator.defaultlang][fixid] = fixstr
		end
		for k, v in pairs(_G.STRINGS.SKIN_DESCRIPTIONS) do
			fixid = "STRINGS.SKIN_DESCRIPTIONS."..k
			fixstr = StrLength(_G.LanguageTranslator.languages[_G.LanguageTranslator.defaultlang][fixid], 16)
			_G.LanguageTranslator.languages[_G.LanguageTranslator.defaultlang][fixid] = fixstr
		end
		for k, v in pairs(_G.STRINGS.UI.CRAFTING) do
			fixid = "STRINGS.UI.CRAFTING."..k
			fixstr = StrLength(_G.LanguageTranslator.languages[_G.LanguageTranslator.defaultlang][fixid], 16)
			_G.LanguageTranslator.languages[_G.LanguageTranslator.defaultlang][fixid] = fixstr
		end

		fixid = "STRINGS.UI.BUGREPORTSCREEN.SUBMIT_TEXT"
		fixstr = StrLength(_G.LanguageTranslator.languages[_G.LanguageTranslator.defaultlang][fixid], 36)
		_G.LanguageTranslator.languages[_G.LanguageTranslator.defaultlang][fixid] = fixstr
		fixid = "STRINGS.UI.BUILTINCOMMANDS.HELP.OVERVIEW"
		fixstr = StrLength(_G.LanguageTranslator.languages[_G.LanguageTranslator.defaultlang][fixid], 22)
		_G.LanguageTranslator.languages[_G.LanguageTranslator.defaultlang][fixid] = fixstr
		fixid = "STRINGS.UI.BUILTINCOMMANDS.RESCUE.DESC"
		fixstr = StrLength(_G.LanguageTranslator.languages[_G.LanguageTranslator.defaultlang][fixid], 32)
		_G.LanguageTranslator.languages[_G.LanguageTranslator.defaultlang][fixid] = fixstr
		fixid = "STRINGS.UI.BUILTINCOMMANDS.ROLL.DESC"
		fixstr = StrLength(_G.LanguageTranslator.languages[_G.LanguageTranslator.defaultlang][fixid], 32)
		_G.LanguageTranslator.languages[_G.LanguageTranslator.defaultlang][fixid] = fixstr
		fixid = "STRINGS.UI.CREDITS.ALTGAMES.TITLE"
		fixstr = StrLength(_G.LanguageTranslator.languages[_G.LanguageTranslator.defaultlang][fixid], 24)
		_G.LanguageTranslator.languages[_G.LanguageTranslator.defaultlang][fixid] = fixstr
	end
	-- 修复中文显示空白
	FixStrings()
	print("[Chinese Plus] 修复未正常换行的游戏汉化一部分中文不显示的错误执行完毕。")
end

if IS_CHS_FIX_ALL then
	-- 汉化修复
	if chinese_fix ~= nil then
		modimport(chinese_fix)
		print("[Chinese Plus] 汉化修复完成")
	else
		print("[Chinese Plus] 汉化修复功能所需文本不存在( Chinese Plus 出错了，去反馈吧！)")
	end
end

if IS_CHS_SETTINGS and not ISPLAYINGNOW then
	-- Code from Russian For Mods. Thanks to star(http://steamcommunity.com/id/strelka).
	-- 汉化MOD选项
	if chinese_settings ~= nil then
		local options_data = {nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,}

		function _G.ChinesePlus.SetConfigTranslation(name,description,hash_tbl,configuration_options,custom_fn)
			if not name then
				print("[Chinese Plus] 错误:: 名字哪去了!")
				return
			end

			local data = configuration_options
			if not data then
				data = {}
			end
			options_data[name] = data

			data.description = description
			data.custom_fn = custom_fn
			data.hash_tbl = hash_tbl
			return data
		end

		local function CheckPostModinfoEnv(env)
			local data = (env.name and options_data[env.name])
			if not data then
				return
			end

			if data.description then env.description = data.description end
			if data.custom_fn then data.custom_fn(env) end
			local assoc = {}
			for i,v in pairs(data) do
				if v.name and v.name~="" then
					assoc[v.name] = v
					if v.label == "" then v.label=nil end
					if v.hover == "" then v.hover=nil end
				end
			end

			if env.configuration_options and type(env.configuration_options)=="table" then
				for i,env_opt in pairs(env.configuration_options) do
					if not(env_opt and type(env_opt)=="table") then
						print('[Chinese Plus] 错误:MOD="'..env.name..'" - 损坏的选项 #'..tostring(i))
						break
					end
					if not (env_opt.options and type(env_opt.options)=="table") then
						print('[Chinese Plus] 错误:MOD="'..env.name..'" - 损坏的选项 #'..tostring(i)..": 没有多个选项.")
						break
					end
					local trans = env_opt.name and assoc[env_opt.name]
					if env_opt.name == "" then
						if env_opt.label and data.hash_tbl[env_opt.label] then
							env_opt.label = data.hash_tbl[env_opt.label]
						end
						if env_opt.hover and data.hash_tbl[env_opt.hover] then
							env_opt.hover = data.hash_tbl[env_opt.hover]
						end
					elseif trans then
						if trans.label then
							env_opt.label = trans.label
						end
						if trans.hover then
							env_opt.hover = trans.hover
						end
						local trans_opt = {}
						if trans.options then
							for j,t_opt in pairs(trans.options) do
								if t_opt.data then
									trans_opt[t_opt.data] = t_opt
								end
							end
						end
						for j,opt in pairs(env_opt.options) do
							if not(opt and type(opt)=="table") then
								--print('[Chinese Plus] 提示:没有汉化MOD="'..env.name..'", 选项="'..env_opt.name..'"')
								break
							end
							local trans_var = opt.data and trans_opt[opt.data]
							if trans_var then
								if trans_var.description then
									opt.description = trans_var.description
								end
								if trans_var.hover then
									opt.hover = trans_var.hover
								end
							else
								if opt.description then
									if data.hash_tbl[opt.description] then
										opt.description = data.hash_tbl[opt.description]
									else
										--print('[Chinese Plus] 提示:没有汉化MOD="'..env.name..'", 选项="'..env_opt.name..'", 变量="'..tostring(opt.data)..'", 描述="'..tostring(opt.description)..'"')
									end
								end
								if opt.hover then
									if data.hash_tbl[opt.hover] then
										opt.hover = data.hash_tbl[opt.hover] --Нашли хеш
									else
										--print('[Chinese Plus] 提示:没有汉化MOD="'..env.name..'", 选项="'..env_opt.name..'", 变量="'..tostring(opt.data)..'", 提示="'..tostring(opt.hover)..'"')
									end
								end
							end
						end
					else
						--print('[Chinese Plus] 提示:没有汉化MOD="'..tostring(env.name)..'", 选项="'..tostring(env_opt.name)..'"')
					end
				end
			else
				--print("[Chinese Plus] 提示:要汉化的 MOD 选项为空! ")
			end
		end

		local temp_mark = nil

		local old_kleiloadlua = _G.kleiloadlua
		_G.kleiloadlua = function(path,...)
			local fn = old_kleiloadlua(path,...)
			if fn and type(fn) ~= "string" and path:sub(-12) == "/modinfo.lua" then
				local translatestr = "modinfo_" .. chinesefolder .. ".lua"
				local path_trans = string.gsub( path , 'modinfo.lua' , translatestr)
				temp_mark = path_trans
			end
			return fn
		end

		local old_RunInEnvironment = _G.RunInEnvironment
		_G.RunInEnvironment = function(fn, env, ...)
			if env and temp_mark then
				local fn_trans = old_kleiloadlua(temp_mark)
				temp_mark = nil
				local res = old_RunInEnvironment(fn, env, ...)
				if fn_trans and type(fn_trans) ~= "string" then
					local env_trans = {}
					local status, r = old_RunInEnvironment(fn_trans, env_trans)
					if status == true then
						if env_trans.description then
							env.description = env_trans.description
						end
						if env_trans.configuration_options then
							env.configuration_options = env_trans.configuration_options
						end
					end
				end
				CheckPostModinfoEnv(env)
				return res
			end
			local a,b,c = old_RunInEnvironment(fn, env, ...)
			CheckPostModinfoEnv(env)
			return a,b,c
		end

		modimport(chinese_settings)
		print("[Chinese Plus] 汉化MOD选项完成")

		_G.ChinesePlus.settings = true

		print("[Chinese Plus] 汉化MOD选项函数正常加载")
	else
		print("[Chinese Plus] 汉化MOD选项功能所需文本不存在( Chinese Plus 出错了，去反馈吧！)")
	end
end

if IS_CHS_ALL_MOD then
	-- MOD汉化
	function _G.ChinesePlus.RenameAction(act,new)
		_G.STRINGS.ACTIONS[act] = new
	end

	function _G.ChinesePlus.RenameTab(tab,new)
		_G.STRINGS.TABS[tab] = new
	end

	function _G.ChinesePlus.RenameStrings(strid,new)
		_G.ExecuteConsoleCommand(strid..'="'..new..'"')
	end

	function _G.ChinesePlus.RenameRecipe(strid,new)
		STRINGS.RECIPE_DESC[strid] = StrLength(new, 16)
	end

	if modtochinese ~= nil then
		if ISPLAYINGNOW then
			modimport(modtochinese)
			print("[Chinese Plus] 汉化MOD完成")
		end
	else
		print("[Chinese Plus] 汉化MOD文本不存在( Chinese Plus 出错了，去反馈吧！)。")
	end

	_G.ChinesePlus.mods = true
	print("[Chinese Plus] 汉化MOD函数正常加载")

end
