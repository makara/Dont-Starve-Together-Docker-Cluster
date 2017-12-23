--[[
-- http://steamcommunity.com/sharedfiles/filedetails/?id=000000000
mod_info_do["xxxxxxxxxx"] = 000000000
]]

local prefix_str = "mod_info/" .. chinesefolder .. "/"
local mod_info_do = {}
mod_to_c = ""
local function TheEnd()
  for k,v in pairs(mod_info_do) do
    mod_to_c = k
    if _G.ChinesePlus.mod_names[mod_to_c] ~= nil then
      modimport(prefix_str..tostring(v))
    end
  end
end

if IS_CHS_CHARACTER then

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=421029894
  mod_info_do["Caitlin"] = 421029894

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=406913232
  mod_info_do["Kyle"] = 406913232

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=391086703
  mod_info_do["Heather"] = 391086703

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=774265381
  mod_info_do["Nelke"] = 774265381

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=733740417
  mod_info_do["Mae"] = 733740417

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=791838548
  mod_info_do["The Engineer"] = 791838548

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=589167205
  mod_info_do["The Spy"] = 589167205

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=379628839
  mod_info_do["The Medic"] = 379628839

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=697356989
  mod_info_do["Shipwrecked Characters"] = 697356989

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=676503184
  mod_info_do["Deadpool"] = 676503184

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=656065472
  mod_info_do["Demoman"] = 656065472

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=665141515
  mod_info_do["Soldier (TF2)"] = 665141515

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=607654103
  mod_info_do["DST Warly"] = 607654103

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=647370020
  mod_info_do["SpiderPool"] = 647370020

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=660788832
  mod_info_do["SpiderMan"] = 660788832

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=566155039
  mod_info_do["Saitama(P)(One Punch Man)"] = 566155039

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=622471256
  mod_info_do["Playable Pets"] = 622471256

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=622596425
  mod_info_do["Playable Pets -Caves"] = 622596425

end

-- http://steamcommunity.com/sharedfiles/filedetails/?id=375859599
mod_info_do["Health Info"] = 375859599

-- http://steamcommunity.com/sharedfiles/filedetails/?id=365119238
mod_info_do["SmartCrockPot"] = 365119238

-- http://steamcommunity.com/sharedfiles/filedetails/?id=382177939
mod_info_do["DST Storm Cellar"] = 382177939

-- http://steamcommunity.com/sharedfiles/filedetails/?id=351325790
mod_info_do["Geometric Placement"] = 351325790

-- http://steamcommunity.com/sharedfiles/filedetails/?id=376333686
mod_info_do["Combined Status"] = 376333686

-- http://steamcommunity.com/sharedfiles/filedetails/?id=444438334
mod_info_do["DJPaul's Sort Inventory"] = 444438334

-- http://steamcommunity.com/sharedfiles/filedetails/?id=352373173
mod_info_do["Gesture Wheel"] = 352373173

-- http://steamcommunity.com/sharedfiles/filedetails/?id=496249680
mod_info_do["Extra Equip Slots API Edition"] = 496249680

-- http://steamcommunity.com/sharedfiles/filedetails/?id=458940297
mod_info_do["Food Values - Item Tooltips (Server and Client)"] = 458940297

-- http://steamcommunity.com/sharedfiles/filedetails/?id=458587300
mod_info_do["Fast Travel"] = 458587300

-- http://steamcommunity.com/sharedfiles/filedetails/?id=378160973
mod_info_do["Global Positions"] = 378160973

-- http://steamcommunity.com/sharedfiles/filedetails/?id=387716835
mod_info_do["Aquarium"] = 387716835

-- http://steamcommunity.com/sharedfiles/filedetails/?id=459280938
mod_info_do["Complete Your Map"] = 459280938

-- http://steamcommunity.com/sharedfiles/filedetails/?id=503187227
mod_info_do["Advanced World Generation"] = 503187227

-- http://steamcommunity.com/sharedfiles/filedetails/?id=360823660
mod_info_do["Simple Protection"] = 360823660

-- http://steamcommunity.com/sharedfiles/filedetails/?id=404161345
mod_info_do["Ownership"] = 404161345

-- http://steamcommunity.com/sharedfiles/filedetails/?id=444235588
mod_info_do["Deluxe Campfires 2.11"] = 444235588

-- http://steamcommunity.com/sharedfiles/filedetails/?id=623749604
mod_info_do[" Storeroom"] = 623749604

-- http://steamcommunity.com/sharedfiles/filedetails/?id=494699184
mod_info_do["DST Tweak Tool"] = 494699184

-- http://steamcommunity.com/sharedfiles/filedetails/?id=651419070
mod_info_do["Auto Actions"] = 651419070

-- http://steamcommunity.com/sharedfiles/filedetails/?id=370373189
mod_info_do["DST Advanced Farming"] = 370373189

-- http://steamcommunity.com/sharedfiles/filedetails/?id=650779849
mod_info_do["Advanced Farming"] = 650779849

-- http://steamcommunity.com/sharedfiles/filedetails/?id=514078314
mod_info_do["Turfed!"] = 514078314

-- http://steamcommunity.com/sharedfiles/filedetails/?id=436897772
mod_info_do["<default>'s item pack"] = 436897772

-- http://steamcommunity.com/sharedfiles/filedetails/?id=663554209
mod_info_do["Magic Freezer"] = 663554209

-- http://steamcommunity.com/sharedfiles/filedetails/?id=345692228
mod_info_do["Minimap HUD"] = 345692228

-- http://steamcommunity.com/sharedfiles/filedetails/?id=656256171
mod_info_do["Slot Machine"] = 656256171

-- http://steamcommunity.com/sharedfiles/filedetails/?id=609599183
mod_info_do["Lightsaber"] = 609599183

-- http://steamcommunity.com/sharedfiles/filedetails/?id=672584952
mod_info_do["[Updated] Complete Your Map"] = 672584952

-- http://steamcommunity.com/sharedfiles/filedetails/?id=594431975
mod_info_do["Starting Items and Recipes"] = 594431975

-- http://steamcommunity.com/sharedfiles/filedetails/?id=396822875
mod_info_do["Spike Trap"] = 396822875

-- http://steamcommunity.com/sharedfiles/filedetails/?id=512502326
mod_info_do["Flower Box DST"] = 512502326

-- http://steamcommunity.com/sharedfiles/filedetails/?id=666155465
mod_info_do["Show Me"] = 666155465

-- http://steamcommunity.com/sharedfiles/filedetails/?id=722788575
--mod_info_do["Your Rules!"] = 722788575

-- http://steamcommunity.com/sharedfiles/filedetails/?id=597417408
mod_info_do["1.Less lags"] = 597417408

-- http://steamcommunity.com/sharedfiles/filedetails/?id=609675532
mod_info_do["Limit Prefab"] = 609675532

-- http://steamcommunity.com/sharedfiles/filedetails/?id=609051112
mod_info_do["Action Queue(DST)"] = 609051112

-- http://steamcommunity.com/sharedfiles/filedetails/?id=727774324
mod_info_do["Craft Pot"] = 727774324

-- http://steamcommunity.com/sharedfiles/filedetails/?id=522023088
mod_info_do["Ice Fling Range Check [DST CLIENT]"] = 522023088

-- http://steamcommunity.com/sharedfiles/filedetails/?id=522117250
mod_info_do["Birds and Berries and Trees and Flowers for Friends"] = 522117250

-- http://steamcommunity.com/sharedfiles/filedetails/?id=587832350
mod_info_do["Christmas Tree DST"] = 587832350

-- http://steamcommunity.com/sharedfiles/filedetails/?id=554999204
mod_info_do["Don't Starve Dolls(Standalone)"] = 554999204

-- http://steamcommunity.com/sharedfiles/filedetails/?id=356435289
mod_info_do["DST Fish Farm"] = 356435289

-- http://steamcommunity.com/sharedfiles/filedetails/?id=385006082
mod_info_do["DST Path Lights"] = 385006082

-- http://steamcommunity.com/sharedfiles/filedetails/?id=346968521
mod_info_do["DST Wilson's House"] = 346968521

-- http://steamcommunity.com/sharedfiles/filedetails/?id=396026892
mod_info_do["Large Chest"] = 396026892

-- http://steamcommunity.com/sharedfiles/filedetails/?id=404983266
mod_info_do["Pickle It"] = 404983266

-- http://steamcommunity.com/sharedfiles/filedetails/?id=614931358
mod_info_do["Portable cookpot"] = 614931358

-- http://steamcommunity.com/sharedfiles/filedetails/?id=525966989
mod_info_do["Silver Bird Cage"] = 525966989

-- http://steamcommunity.com/sharedfiles/filedetails/?id=381565292
mod_info_do["Waiter 101 v4.2x"] = 381565292

-- http://steamcommunity.com/sharedfiles/filedetails/?id=362175979
mod_info_do["Wormhole Marks"] = 362175979

-- http://steamcommunity.com/sharedfiles/filedetails/?id=418604101
mod_info_do["Steampunk DST"] = 418604101

-- http://steamcommunity.com/sharedfiles/filedetails/?id=545653509
mod_info_do["Glimmer and Family DST"] = 545653509

-- http://steamcommunity.com/sharedfiles/filedetails/?id=508739792
mod_info_do["Sentries Mod [DST Version]"] = 508739792

-- http://steamcommunity.com/sharedfiles/filedetails/?id=488009136
mod_info_do["Archery Mod [DST Version]"] = 488009136

-- http://steamcommunity.com/sharedfiles/filedetails/?id=516523980
mod_info_do["Mining Machine [DST]"] = 516523980

-- http://steamcommunity.com/sharedfiles/filedetails/?id=658639965
mod_info_do["Topography"] = 658639965

-- http://steamcommunity.com/sharedfiles/filedetails/?id=655236052
mod_info_do["Make"] = 655236052

-- http://steamcommunity.com/sharedfiles/filedetails/?id=767776640
mod_info_do["Repair Combinate"] = 767776640

-- http://steamcommunity.com/sharedfiles/filedetails/?id=786556008
mod_info_do["45 Inventory Slots"] = 786556008

-- http://steamcommunity.com/sharedfiles/filedetails/?id=543945797
mod_info_do["Damage Indicators"] = 543945797

-- http://steamcommunity.com/sharedfiles/filedetails/?id=366676924
mod_info_do["DST Always On Tiki Torch"] = 366676924

-- http://steamcommunity.com/sharedfiles/filedetails/?id=503919639
mod_info_do["DST Equipment Switcher"] = 503919639

-- http://steamcommunity.com/sharedfiles/filedetails/?id=788268084
mod_info_do["DST One Click Action"] = 788268084

-- http://steamcommunity.com/sharedfiles/filedetails/?id=787954095
mod_info_do["Magic Bottle Lanterns (DST)"] = 787954095

-- http://steamcommunity.com/sharedfiles/filedetails/?id=646227245
mod_info_do["Easy Domesticate"] = 646227245

-- http://steamcommunity.com/sharedfiles/filedetails/?id=659459255
mod_info_do["Mandrake Tree"] = 659459255

-- http://steamcommunity.com/sharedfiles/filedetails/?id=785295023
mod_info_do["Super Wall DST"] = 785295023

-- http://steamcommunity.com/sharedfiles/filedetails/?id=755028761
mod_info_do["Trash Can"] = 755028761

-- http://steamcommunity.com/sharedfiles/filedetails/?id=382363357
mod_info_do["Useless Junk"] = 382363357

-- http://steamcommunity.com/sharedfiles/filedetails/?id=384396097
mod_info_do["DST Spider Cage"] = 384396097

-- http://steamcommunity.com/sharedfiles/filedetails/?id=514758022
mod_info_do["World Regrowth"] = 514758022

-- http://steamcommunity.com/sharedfiles/filedetails/?id=568252867
mod_info_do["World Resource Regeneration"] = 568252867

-- http://steamcommunity.com/sharedfiles/filedetails/?id=436654027
mod_info_do["Beefalo Milk"] = 436654027

-- http://steamcommunity.com/sharedfiles/filedetails/?id=780009141
mod_info_do["Finder"] = 780009141

-- http://steamcommunity.com/sharedfiles/filedetails/?id=786654500
mod_info_do["FinderMod"] = 786654500

-- http://steamcommunity.com/sharedfiles/filedetails/?id=786975044
mod_info_do["Pickable Machines"] = 786975044

-- http://steamcommunity.com/sharedfiles/filedetails/?id=786566397
mod_info_do["[DST] Monster Healthbars"] = 786566397

-- http://steamcommunity.com/sharedfiles/filedetails/?id=357875628
mod_info_do["Wall Gates"] = 357875628

-- http://steamcommunity.com/sharedfiles/filedetails/?id=429396134
mod_info_do["Craftable Gnome"] = 429396134

-- http://steamcommunity.com/sharedfiles/filedetails/?id=430292771
mod_info_do["Gnomestaff (Wabbajack)"] = 430292771

-- http://steamcommunity.com/sharedfiles/filedetails/?id=806988346
mod_info_do["Little Rocket Man"] = 806988346

-- http://steamcommunity.com/sharedfiles/filedetails/?id=422659100
mod_info_do["Fear of Gnomes"] = 422659100

-- http://steamcommunity.com/sharedfiles/filedetails/?id=482119182
mod_info_do["Iceflingomatic Behavior Configurator"] = 482119182

-- http://steamcommunity.com/sharedfiles/filedetails/?id=496205036
mod_info_do["Apothecary Medicamento"] = 496205036

-- http://steamcommunity.com/sharedfiles/filedetails/?id=563754964
mod_info_do["More Drops"] = 563754964

-- http://steamcommunity.com/sharedfiles/filedetails/?id=638159924
mod_info_do["Icebox Tweak + Fresher Food"] = 638159924

-- http://steamcommunity.com/sharedfiles/filedetails/?id=728459184
mod_info_do["Increase Storage"] = 728459184

TheEnd()
