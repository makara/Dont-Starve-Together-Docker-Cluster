return {
    ["workshop-463718554"] = { enabled = true,
        configuration_options =
        {
			STARTINGITEMS = true, --false = off, true = Give the player some starting items
			SEASONSTARTINGITEMS = true, --false = off, true = Give the player some starting items that fit current season
			NIGHTSTARTINGITEMS = true, --false = off, true = Give the players some starting items (a torch) if he joins during the night
			PVPSTARTINGITEMS = true, --false = off, true = Give the player some starting items if it is a pvp server
			CAVESTARTINGITEMS = true, --false = off, true = Give the player some starting items if it is a cave server
			REVEALMAP = 1, --0 = off, 1 = reveal the roads on the minimap, 2 = reveal all
			RENEWLIMITEDRESOURCES = 18, --0 = off, Number of days for average limited resource to regenerate (recommended between 6 and 72)
			DRAGONFLYBALANCE = true, --false = off, true = Balance the dragonfly health (and other stats)
			MAXMAXPLAYERS = 32, --6 = off, The maximum number of players that can join the server (not really needed for dedicated servers, as you can already override this)
			REVIVERCRAFTPENALTY = false, --true = off, false = No penalty for crafting the revival item
			DRYINGSPEEDMULTIPLIER = 2, --1 = off, The speed multiplier for the Drying Rack (recommended between 1.5 and 4)
			FARMINGSPEEDMULTIPLIER = 2, --1 = off, The speed multiplier for Farms (recommended between 1.5 and 4)
			BEESSPEEDMULTIPLIER = 2, --1 = off, The speed multiplier for Bee Boxes (recommended 1.2, 1.5 or 2)
			KRAMPUSMULTIPLIER = 2, --1 = off, The multiplier for Krumpus to appear (recommended between 1.5 and 4)
			RESIZEFIREPITS = true, --false = off, true = Make firepits have a larger collision area
            AMOUNTOFCHESTERS = 4, --1 = semi-off, 2-32: 2-32 Eye Bones will be created during world generation
			CANHAUNT = 1, --2 = off, 0 = Can only haunt when it gives a possitive effect, 1 = Can also spawn bosses through haunting 
			GHOSTSANITYDRAIN = false, --true = off, false = No sanity drain when other players are ghosts
			EMPTYINVENTORYDAYS = 2, --0 = off, -1 = Only empty inventory when player is kicked/banned, 1-5 = Player empties inventory when leaving the game within 1-5 days of joining
			PREVENTSTEALINGDAYS = 2, --0 = off, 1-5 = Players cannot steal items within 1-5 days of joining
			PREVENTDESTROYINGDAYS = 5, --0 = off, 1-5 = Players cannot destroy buildings within 1-5 days of joining, -1 = Players can never destroy buildings
			PREVENTBURNING = 2, --0 = off, 1-5 = Players cannot burn objects/items within 1-5 days of joining
			SPREADFIRE = 1, --2 = off, 0 = Fire does not spread, 1 = Fire spreads at halve range
        }
    },
}