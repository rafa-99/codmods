#include common_scripts/utility;
#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/zombies/_zm;
#include maps/mp/zombies/_zm_utility;
#include maps/mp/zombies/_zm_perks;
#include maps/mp/zombies/_zm_afterlife;

/*
 * Function Responsible for Loading the Mods
 * uncomment the // for the mods you want to enable
 * and then compile with a gsc compiler.
 */
modLoader(p, l)
{
	// Preloads tombstone before black screen after loading the map
	// activateTombstone(l);

	////////////////////////////////////////////////////////////////////////
	// Waits for the black preload screen to pass so it can load the mods //
	// DO NOT TOUCH THIS LINE BELOW!!                                     //
	flag_wait( "initial_blackscreen_passed" );                            //
	////////////////////////////////////////////////////////////////////////
	
	// Player has 9 lifes in afterlife
	// catHas9Lifes(p, 9);
	
	// Player is invincible
	// godMode(p);
	
	// Unlimited ammo
	// thread unlimitedAmmo(p);
	
	// Sets the player camera to third person
	// playThirdPerson(p, true);
	
	// Set initial player points
	// setPlayerPoints(p, 500);
	
	// Mod sets a custom perk limit
	// thread setPerkLimit(l, 12);

	// Mod that sets the box price
	// setBoxPrice(l, 950);

	// Mod that adds a zombie counter to the bottom of the screen
	// thread zombieCounter(p, l, 0, 190);

	// Mod that adds a health counter to the bottom of the screen
	// thread healthCounter(p, 0, 190);

	// Mod that adds a zombie and health counters to the bottom of the screen
	// thread healthCounter(p, -100, 190);
	// thread zombieCounter(p, l, 100, 190);

	// Gives all the perks available in the map to the player
	// perkaholic(p, l, true);
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
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");
	level endon("game_ended");
	while(1)
	{
		self waittill("spawned_player");
		modLoader(self, level);
	}
}
