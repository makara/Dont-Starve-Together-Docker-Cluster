AddPrefabPostInit("world", function (inst)
  inst:DoPeriodicTask(0.033, function ()
    for k,player in pairs(GLOBAL.AllPlayers) do
      local x,y,z = player.Transform:GetWorldPosition()
      GLOBAL.TheWorld.minimap.MiniMap:ShowArea(x, 0, z, 30)
    end
  end)
end)