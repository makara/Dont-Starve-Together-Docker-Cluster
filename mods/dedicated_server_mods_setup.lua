--There are two functions that will install mods, ServerModSetup and ServerModCollectionSetup. Put the calls to the functions in this file and they will be executed on boot.

--ServerModSetup takes a string of a specific mod's Workshop id. It will download and install the mod to your mod directory on boot.
  --The Workshop id can be found at the end of the url to the mod's Workshop page.
  --Example: http://steamcommunity.com/sharedfiles/filedetails/?id=350811795
  --ServerModSetup("350811795")

--ServerModCollectionSetup takes a string of a specific mod's Workshop id. It will download all the mods in the collection and install them to the mod directory on boot.
  --The Workshop id can be found at the end of the url to the collection's Workshop page.
  --Example: http://steamcommunity.com/sharedfiles/filedetails/?id=379114180
  --ServerModCollectionSetup("379114180")

-- [Simple Health Bar DST](http://steamcommunity.com/sharedfiles/filedetails/?id=1207269058)
ServerModSetup("1207269058")

-- [Wormhole Marks [DST]](http://steamcommunity.com/sharedfiles/filedetails/?id=362175979)
ServerModSetup("362175979")

-- [Increased Stack size](http://steamcommunity.com/sharedfiles/filedetails/?id=374550642)
ServerModSetup("374550642")

-- [Extra Equip Slots](http://steamcommunity.com/sharedfiles/filedetails/?id=375850593)
ServerModSetup("375850593")

-- [Global Positions](http://steamcommunity.com/sharedfiles/filedetails/?id=378160973)
ServerModSetup("378160973")

-- [Remove Penalty](http://steamcommunity.com/sharedfiles/filedetails/?id=378965501)
ServerModSetup("378965501")

-- [Tweak Those Tools, Tweaked!](http://steamcommunity.com/sharedfiles/filedetails/?id=441356490)
ServerModSetup("441356490")

-- [Food Values - Item Tooltips (Server and Client)](http://steamcommunity.com/sharedfiles/filedetails/?id=458940297)
ServerModSetup("458940297")

-- [Restart](http://steamcommunity.com/sharedfiles/filedetails/?id=462434129)
ServerModSetup("462434129")

-- [Fix Multiplayer](http://steamcommunity.com/sharedfiles/filedetails/?id=463718554)
ServerModSetup("463718554")

-- [Quick Pick](http://steamcommunity.com/sharedfiles/filedetails/?id=501385076)
ServerModSetup("501385076")

-- [Less lags](http://steamcommunity.com/sharedfiles/filedetails/?id=597417408)
ServerModSetup("597417408")

-- [Trap Reset](http://steamcommunity.com/sharedfiles/filedetails/?id=679636739)
ServerModSetup("679636739")
