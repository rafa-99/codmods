#include common_scripts/utility;
#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/zombies/_zm;
#include maps/mp/zombies/_zm_utility;
#include maps/mp/zombies/_zm_perks;
#include maps/mp/zombies/_zm_afterlife;
#include maps/mp/zombies/_zm_weapons;

// Loads the mods once the player connects to the server
onConnectMods(p, l)
{
	/*
	 * General Mods
	 */

	// Player is invincible
	// godMode(p);

	// Unlimited ammo
	// thread unlimitedAmmo(p);

	// Set initial player points
	// setPlayerPoints(p, 500);

	// Mod that sets the box price
	// setBoxPrice(l, 950);

	// Mod sets a custom perk limit
	// thread setPerkLimit(l, 9);

	// Gives all the perks available in the map to the player
	// thread perkaholic(p, l);

	/*
	 * MotD Mods
	 */

	// Player has 9 lifes in afterlife
	// catHas9Lifes(p, 9);
}

// Loads the mods once the player spawns inside the game
onSpawnMods(p, l)
{
	////////////////////////////////////////////////////////////////////////
	// Waits for the black preload screen to pass so it can load the mods //
	// DO NOT TOUCH THIS LINE BELOW!!                                     //
	flag_wait( "initial_blackscreen_passed" );                            //
	////////////////////////////////////////////////////////////////////////

	// Gives joined players a submachine gun and some points
	// thread joinedBonus(p, l);

	// Sets the player camera to third person
	// playThirdPerson(p, true);

	// Mod that adds a zombie counter to the bottom of the screen
	// thread zombieCounter(p, l, 0, 190);

	// Mod that adds a health counter to the bottom of the screen
	// thread healthCounter(p, 0, 190);

	// Mod that adds a zombie and health counters to the bottom of the screen
	// thread healthCounter(p, -100, 190);
	// thread zombieCounter(p, l, 100, 190);
}

init()
{
	level thread onPlayerConnect();
}

onPlayerConnect()
{
	while(1)
	{
		level waittill("connected", player);
		thread onConnectMods(player, level);
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
    self endon("disconnect");
    while(1)
    {
        self waittill("spawned_player");
        onSpawnMods(self, level);
    }
}

