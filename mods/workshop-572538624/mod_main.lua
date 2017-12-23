--[[
-- http://steamcommunity.com/sharedfiles/filedetails/?id=000000000
mod_main_do["xxxxxxxxxx"] = 000000000
]]

local prefix_str = "mod_main/" .. chinesefolder .. "/"
local mod_main_do = {}
ForceTranslateList = {}
local function TheEnd()
  for k,v in pairs(mod_main_do) do
    if _G.ChinesePlus.mod_names[k] then
      modimport(prefix_str..tostring(v))
    end
  end

  local OldRegisterPrefabs = _G.ModManager.RegisterPrefabs
  local function NewRegisterPrefabs(self)
    OldRegisterPrefabs(self)
    for _,v in pairs(ForceTranslateList) do
      v()
    end
  end
  _G.ModManager.RegisterPrefabs=NewRegisterPrefabs
end

if IS_CHS_CHARACTER then

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=421029894
  mod_main_do["Caitlin"] = 421029894

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=406913232
  mod_main_do["Kyle"] = 406913232

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=391086703
  mod_main_do["Heather"] = 391086703

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=774265381
  mod_main_do["Nelke"] = 774265381

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=733740417
  mod_main_do["Mae"] = 733740417

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=791838548
  mod_main_do["The Engineer"] = 791838548

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=589167205
  mod_main_do["The Spy"] = 589167205

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=379628839
  mod_main_do["The Medic"] = 379628839

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=725343070
  mod_main_do["Winnie, The Shepherd Girl"] = 725343070

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=469134741
  mod_main_do["Winnie"] = 469134741

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=697356989
  mod_main_do["Shipwrecked Characters"] = 697356989

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=510232127
  mod_main_do["Ear Character[DST]"] = 510232127

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=498383066
  mod_main_do["Annie(P)"] = 498383066

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=498729626
  mod_main_do["Annie(P) ===Silhcade Edition==="] = 498729626

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=622471256
  mod_main_do["Playable Pets"] = 622471256

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=622596425
  mod_main_do["Playable Pets -Caves"] = 622596425

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=566155039
  mod_main_do["Saitama(P)(One Punch Man)"] = 566155039

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=409184357
  mod_main_do["Zoro(P)"] = 409184357

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=380079744
  mod_main_do["Luffy(OS 4.0)"] = 380079744

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=388109833
  mod_main_do["Ace(P)"] = 388109833

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=490153236
  mod_main_do["Chopper"] = 490153236

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=454781545
  mod_main_do["Sanji(P)"] = 454781545

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=485291255
  mod_main_do["Law(P)"] = 485291255

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=528613635
  mod_main_do["Usopp(P)"] = 528613635

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=659946242
  mod_main_do["Penny Polendina"] = 659946242

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=531060374
  mod_main_do["San(P)(Princess Mononoke)"] = 531060374

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=359479220
  mod_main_do["Sollyz [DST]"] = 359479220

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=359821133
  mod_main_do["Haruz [DST]"] = 359821133

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=364189966
  mod_main_do["Mitsuru [DST]"] = Mitsuru

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=431003525
  mod_main_do["Saber Lion(P)"] = 431003525

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=382501575
  if _G.ChinesePlus.mod_names["Crash Bandicoot 3.0.0"] then
    mod_main_do["Crash Bandicoot 3.0.0"] = 382501575
  end

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=366048578
  mod_main_do["Devon: DST!"] = 366048578

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=458365884
  mod_main_do["Xenomorph"] = 458365884

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=364491382
  mod_main_do["Faroz Character [DST]"] = 364491382

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=399799824
  mod_main_do["Tamamo(OS 4.0)"] = 399799824

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=461627386
  mod_main_do["Madoka(P)"] = 461627386

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=636699513
  mod_main_do["Fujiwara no Mokou"] = 636699513

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=653080747
  mod_main_do["Black Rock Shooter (Sprite Only)"] = 653080747

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=598857873
  mod_main_do["Momiji Inubashiri(Touhou)"] = 598857873

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=604415323
  mod_main_do["Windkind"] = 604415323

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=637526073
  mod_main_do["Aria Crystal"] = 637526073

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=644762623
  mod_main_do["Miku the Sweet Devil"] = 644762623

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=653958766
  mod_main_do["Elizabeth"] = 653958766

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=654033874
  mod_main_do["Neptune"] = 654033874

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=628057994
  mod_main_do["Tong"] = 628057994

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=590947472
  mod_main_do["Speed Of Sound Sonic"] = 590947472

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=613399079
  mod_main_do["-The Tomahawk Men-"] = 613399079

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=660788832
  mod_main_do["SpiderMan"] = 660788832

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=647370020
  mod_main_do["SpiderPool"] = 647370020

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=664262357
  mod_main_do["Blanc"] = 664262357

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=618785273
  mod_main_do["Womp"] = 618785273

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=607654103
  mod_main_do["DST Warly"] = 607654103

  -- http://steamcommunity.com/sharedfiles/filedetails/?id=676503184
  mod_main_do["Deadpool"] = 676503184

end

-- http://steamcommunity.com/sharedfiles/filedetails/?id=357875628
mod_main_do["Wall Gates"] = 357875628

-- http://steamcommunity.com/sharedfiles/filedetails/?id=458940297
mod_main_do["Food Values - Item Tooltips (Server and Client)"] = 458940297

-- http://steamcommunity.com/sharedfiles/filedetails/?id=382177939
mod_main_do["DST Storm Cellar"] = 382177939

-- http://steamcommunity.com/sharedfiles/filedetails/?id=370373189
mod_main_do["DST Advanced Farming"] = 370373189

-- http://steamcommunity.com/sharedfiles/filedetails/?id=650779849
mod_main_do["Advanced Farming"] = 650779849

-- http://steamcommunity.com/sharedfiles/filedetails/?id=356435289
mod_main_do["DST Fish Farm"] = 356435289

-- http://steamcommunity.com/sharedfiles/filedetails/?id=396026892
mod_main_do["Large Chest"] = 396026892

-- http://steamcommunity.com/sharedfiles/filedetails/?id=510956288
mod_main_do["Rot Machine"] = 510956288

-- http://steamcommunity.com/sharedfiles/filedetails/?id=488009136
mod_main_do["Archery Mod [DST Version]"] = 488009136

-- http://steamcommunity.com/sharedfiles/filedetails/?id=418604101
mod_main_do["Steampunk DST"] = 418604101

-- http://steamcommunity.com/sharedfiles/filedetails/?id=525966989
mod_main_do["Silver Bird Cage"] = 525966989

-- http://steamcommunity.com/sharedfiles/filedetails/?id=385006082
mod_main_do["DST Path Lights"] = 385006082

-- http://steamcommunity.com/sharedfiles/filedetails/?id=447092740
mod_main_do["More Actions"] = 447092740

-- http://steamcommunity.com/sharedfiles/filedetails/?id=516523980
mod_main_do["Mining Machine [DST]"] = 516523980

-- http://steamcommunity.com/sharedfiles/filedetails/?id=508739792
mod_main_do["Sentries Mod [DST Version]"] = 508739792

-- http://steamcommunity.com/sharedfiles/filedetails/?id=496205036
mod_main_do["Apothecary Medicamento"] = 496205036

-- http://steamcommunity.com/sharedfiles/filedetails/?id=522117250
mod_main_do["Birds and Berries and Trees and Flowers for Friends"] = 522117250

-- http://steamcommunity.com/sharedfiles/filedetails/?id=387716835
mod_main_do["Aquarium"] = 387716835

-- http://steamcommunity.com/sharedfiles/filedetails/?id=463740026
mod_main_do["Personal Chesters"] = 463740026

-- http://steamcommunity.com/sharedfiles/filedetails/?id=545653509
mod_main_do["Glimmer and Family DST"] = 545653509

-- http://steamcommunity.com/sharedfiles/filedetails/?id=554999204
mod_main_do["Don't Starve Dolls(Standalone)"] = 554999204

-- http://steamcommunity.com/sharedfiles/filedetails/?id=362175979
mod_main_do["Wormhole Marks"] = 362175979

-- http://steamcommunity.com/sharedfiles/filedetails/?id=354415247
mod_main_do["Throwable Spears"] = 354415247

-- http://steamcommunity.com/sharedfiles/filedetails/?id=458587300
mod_main_do["Fast Travel"] = 458587300

-- http://steamcommunity.com/sharedfiles/filedetails/?id=537902048
mod_main_do["Scythestest"] = 537902048

-- http://steamcommunity.com/sharedfiles/filedetails/?id=346968521
mod_main_do["DST Wilson's House"] = 346968521

-- http://steamcommunity.com/sharedfiles/filedetails/?id=386087632
mod_main_do["Golden Spear"] = 386087632

-- http://steamcommunity.com/sharedfiles/filedetails/?id=506204512
mod_main_do["8 Faced Fences Gates [DST]"] = 506204512

-- http://steamcommunity.com/sharedfiles/filedetails/?id=404983266
mod_main_do["Pickle It"] = 404983266

-- http://steamcommunity.com/sharedfiles/filedetails/?id=376333686
mod_main_do["Combined Status"] = 376333686

-- http://steamcommunity.com/sharedfiles/filedetails/?id=444235588
mod_main_do["Deluxe Campfires 2.11"] = 444235588

-- http://steamcommunity.com/sharedfiles/filedetails/?id=623749604
mod_main_do[" Storeroom"] = 623749604

-- http://steamcommunity.com/sharedfiles/filedetails/?id=514078314
mod_main_do["Turfed!"] = 514078314

-- http://steamcommunity.com/sharedfiles/filedetails/?id=436897772
mod_main_do["<default>'s item pack"] = 436897772

-- http://steamcommunity.com/sharedfiles/filedetails/?id=663554209
mod_main_do["Magic Freezer"] = 663554209

-- http://steamcommunity.com/sharedfiles/filedetails/?id=666925991
mod_main_do["Ax of Fury [DST + RoG]"] = 666925991

-- http://steamcommunity.com/sharedfiles/filedetails/?id=610165296
mod_main_do["Toptoptoptoptoptoptoptophat"] = 610165296

-- http://steamcommunity.com/sharedfiles/filedetails/?id=614931358
mod_main_do["Portable cookpot"] = 614931358

-- http://steamcommunity.com/sharedfiles/filedetails/?id=587832350
mod_main_do["Christmas Tree DST"] = 587832350

-- http://steamcommunity.com/sharedfiles/filedetails/?id=381565292
mod_main_do["Waiter 101 v4.2x"] = 381565292

-- http://steamcommunity.com/sharedfiles/filedetails/?id=345692228
mod_main_do["Minimap HUD"] = 345692228

-- http://steamcommunity.com/sharedfiles/filedetails/?id=656256171
mod_main_do["Slot Machine"] = 656256171

-- http://steamcommunity.com/sharedfiles/filedetails/?id=609599183
mod_main_do["Lightsaber"] = 609599183

-- http://steamcommunity.com/sharedfiles/filedetails/?id=351325790
mod_main_do["Geometric Placement"] = 351325790

-- http://steamcommunity.com/sharedfiles/filedetails/?id=378160973
mod_main_do["Global Positions"] = 378160973

-- http://steamcommunity.com/sharedfiles/filedetails/?id=396822875
mod_main_do["Spike Trap"] = 396822875

-- http://steamcommunity.com/sharedfiles/filedetails/?id=512502326
mod_main_do["Flower Box DST"] = 512502326

-- http://steamcommunity.com/sharedfiles/filedetails/?id=727774324
mod_main_do["Craft Pot"] = 727774324

-- http://steamcommunity.com/sharedfiles/filedetails/?id=722788575
--mod_main_do["Your Rules!"] = 722788575

-- http://steamcommunity.com/sharedfiles/filedetails/?id=741879530
mod_main_do["Rezecib's Rebalance"] = 741879530

-- http://steamcommunity.com/sharedfiles/filedetails/?id=651419070
mod_main_do["Auto Actions"] = 651419070

-- http://steamcommunity.com/sharedfiles/filedetails/?id=655236052
mod_main_do["Make"] = 655236052

-- http://steamcommunity.com/sharedfiles/filedetails/?id=366676924
mod_main_do["DST Always On Tiki Torch"] = 366676924

-- http://steamcommunity.com/sharedfiles/filedetails/?id=787954095
mod_main_do["Magic Bottle Lanterns (DST)"] = 787954095

-- http://steamcommunity.com/sharedfiles/filedetails/?id=659459255
mod_main_do["Mandrake Tree"] = 659459255

-- http://steamcommunity.com/sharedfiles/filedetails/?id=755028761
mod_main_do["Trash Can"] = 755028761

-- http://steamcommunity.com/sharedfiles/filedetails/?id=384396097
mod_main_do["DST Spider Cage"] = 384396097

-- http://steamcommunity.com/sharedfiles/filedetails/?id=436654027
mod_main_do["Beefalo Milk"] = 436654027

-- http://steamcommunity.com/sharedfiles/filedetails/?id=786566397
mod_main_do["[DST] Monster Healthbars"] = 786566397

-- http://steamcommunity.com/sharedfiles/filedetails/?id=429396134
mod_main_do["Craftable Gnome"] = 429396134

-- http://steamcommunity.com/sharedfiles/filedetails/?id=430292771
mod_main_do["Gnomestaff (Wabbajack)"] = 430292771

-- http://steamcommunity.com/sharedfiles/filedetails/?id=806988346
mod_main_do["Little Rocket Man"] = 806988346

TheEnd()
