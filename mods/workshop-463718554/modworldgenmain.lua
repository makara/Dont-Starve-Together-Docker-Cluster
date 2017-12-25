if GetModConfigData("AMOUNTOFCHESTERS") > 1 then
	local Layouts = GLOBAL.require("map/layouts").Layouts
	local StaticLayouts = GLOBAL.require("map/static_layout")
	local tasks = GLOBAL.require("map/tasks")

	--Load layout
	Layouts["multiple_chesters"] = StaticLayouts.Get("map/static_layout/multiple_chesters")

	--Make sure setpiece is generated
	AddLevelPreInitAny(function(level)
		if level.location == "forest" then
		
			--Get list of tasks (required to create setpieces)
			local taskNames = {}
			for _, taskName in pairs(level.tasks) do
				local task = tasks.GetTaskByName(taskName, tasks.sampletasks)
				if task ~= nil then
					table.insert(taskNames, taskName)
				end
			end
		
			if not level.set_pieces then
				level.set_pieces = {}
			end

			level.set_pieces["multiple_chesters"] = { count = GetModConfigData("AMOUNTOFCHESTERS")-1, tasks = taskNames } --1 Chester create by default, so 1 less
		end
	end)
end