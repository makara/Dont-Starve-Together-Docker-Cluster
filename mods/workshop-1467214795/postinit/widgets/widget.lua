local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local function Shake(self, duration, speed, scale)
    if not self.inst.components.uianim then
        self.inst:AddComponent("uianim")
    end
    self.inst.components.uianim:Shake(duration, speed, scale)
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddClassPostConstruct("widgets/widget", function(widget)


widget.Shake = Shake


end)
