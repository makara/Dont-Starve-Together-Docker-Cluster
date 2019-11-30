local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local function onSinkRescue(self, oldpt, newowner)
	for chester, v in pairs(self.components.leader.followers) do
		local pt = self:GetPosition()
		if newowner then
			pt = newowner:GetPosition()
		end
		chester.Transform:SetPosition(pt.x, pt.y, pt.z)
		if newowner and newowner:HasTag("aquatic") then
			chester:RemoveFromScene()
		else
			chester:ReturnToScene()
		end
	end
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddPrefabPostInit("chester_eyebone", function(inst)


if TheWorld.ismastersim then

	inst.onSinkRescue = onSinkRescue
	
end


end)
