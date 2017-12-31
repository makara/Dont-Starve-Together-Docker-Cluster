-- 本函数来自"小红猪的怪物入侵"
local WaveExAutodelete = Class(function(self, inst)
	self.inst = inst
	self.perishtime = nil
	self.updatetask = nil
	self.perishremainingtime = nil
	self.remove = nil
end)

--- -更新函数，功能的主体部分
local function Update(inst, dt)

	if inst.components.waveexautodelete then
		local owner = nil
		--- -判断物品的拥有者或占有方
		owner = inst.components.inventoryitem
				and inst.components.inventoryitem.owner or nil

		if not owner and inst.components.occupier then
			owner = inst.components.occupier:GetOwner()
		end

		--- -拥有者或占有者为空的时候,开始动用定时删除
		if inst:HasTag("remove_monster") or (not owner and inst:HasTag("wave_monster")) then

			--- -对距离删除时间的计算,核心部分
			if inst.components.waveexautodelete.perishremainingtime then

				inst.components.waveexautodelete.perishremainingtime = inst.components.waveexautodelete.perishremainingtime - 1
				if inst.components.waveexautodelete.perishremainingtime <= 0 then
					inst.components.waveexautodelete:Perish()
				end
			end
			--- -拥有者或占有方存在的时候，剩余离删除时间清零，即重置为设定的perishtime
		else
			inst.components.waveexautodelete.perishremainingtime = inst.components.waveexautodelete.perishtime
		end
	end
end

--[[
----组件自己更新
function Autodelete:LongUpdate(dt)
    if self.updatetask ~= nil then
        Update(self.inst, dt or 0)
    end
end]]

--- -物体移除后
function WaveExAutodelete:OnRemoveEntity()
	self:StopPerishing()
end

--- -执行删除
function WaveExAutodelete:Perish()
	if self.updatetask ~= nil then
		self.updatetask:Cancel()
		self.updatetask = nil
	end
	if self.inst then
		self.inst:PushEvent("Removed")
		SpawnPrefab("collapse_small").Transform:SetPosition(self.inst.Transform:GetWorldPosition())
		self.inst:Remove()
	end
end

--- -设置删除时间
function WaveExAutodelete:SetPerishTime(time)
	self.perishtime = time
	self.perishremainingtime = time
	if self.updatetask ~= nil then
		self:StartPerishing()
	end
end

--- -开始计算
function WaveExAutodelete:StartPerishing()
	if self.updatetask ~= nil then
		self.updatetask:Cancel()
		self.updatetask = nil
	end
	--local dt = .1
	self.updatetask = self.inst:DoPeriodicTask(1, Update)
end

--- -停止计算
function WaveExAutodelete:StopPerishing()
	if self.updatetask ~= nil then
		self.updatetask:Cancel()
		self.updatetask = nil
	end
end

function WaveExAutodelete:SaveRemove()
	self.remove = true
end

--- -存储与载入
function WaveExAutodelete:OnSave()
	if self.remove then
		self.inst.components.health:SetCurrentHealth(0)
		self.inst:Remove()
	end
	return
	{
		paused = self.updatetask == nil or nil,
		time = self.remove and 0 or self.perishremainingtime,
	}
end

function WaveExAutodelete:OnLoad(data)
	if data ~= nil and data.time ~= nil then
		self.perishremainingtime = data.time
		if not data.paused then
			self:StartPerishing()
		end
	end
end

return WaveExAutodelete