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

	/*
	 * Player is invincible
	 */
	// godMode(p);

	/*
	 * Infinte ammo
	 */
	// thread unlimitedAmmo(p);

	/*
	 * Player initial points
	 *
	 * Customizable parameters:
	 * points - Number of points the player will start the game (ex: 500)
	 */
	// setPlayerPoints(p, 500);

	/*
	 * Custom Mystery Box price
	 *
	 * Customizable parameters:
	 * price - Ammount of points required to hit the box (ex: 950)
	 */
	// setBoxPrice(l, 950);

	/*
	 * Custom buyable perk limit
	 *
	 * Customizable parameters:
	 * numberOfPerks - Ammount of perks the player is allowed to purchase (ex: 9)
	 */
	// setPerkLimit(l, 9);

	/*
	 * Gives all the map available perks to the player
	 */
	// thread perkaholic(p, l);

	/*
	 * MotD Mods
	 */

	/*
	 * Custom number of afterlifes
	 *
	 * Customizable parameters:
	 * lifes - Ammount of lifes available in afterlife (ex: 9)
	 *
	 * Visual Bug:
	 * If lifes parameter above 3, the in-game after-life counter wont't show the number.
	 */
	// catHas9Lifes(p, 9);

	/*
	 * Allows infinte afterlife timer
	 */
	// infinteAfterlifeTimer(p);

}

// Loads the mods once the player spawns inside the game
onSpawnMods(p, l)
{
	////////////////////////////////////////////////////////////////////////
	// Waits for the black preload screen to pass so it can load the mods //
	// DO NOT TOUCH THIS LINE BELOW!!                                     //
	flag_wait( "initial_blackscreen_passed" );                           //
	////////////////////////////////////////////////////////////////////////

	/*
	 * Gives the player a custom primary weapon
	 *
	 * Customizable parameters:
	 * weapon - Weapon name string available in the README.md file (ex: galil_zm (Galil))
	 * upgraded - Toggle for pack-a-punched given weapon (ex: true)
	 */
	// thread setPrimaryWeapon(p, l, "galil_zm", true);

	/*
	 * Gives the player a custom secondary weapon
	 *
	 * Customizable parameters:
	 * weapon - Weapon name string available in the README.md file (ex: ray_gun_zm (Ray Gun))
	 * upgraded - Toggle for pack-a-punched given weapon (ex: false)
	 */
	// thread setSecondaryWeapon(p, l, "ray_gun_zm", false);

	/*
	 * Gives joining players a secondary submachine gun and a couple of points
	 */
	// thread joinedBonus(p, l);

	/*
	 * Sets the player camera to the third person
	 *
	 * Customizable parameters:
	 * crosshair - Toggle crosshair for third person camera (ex: true)
	 */
	// playThirdPerson(p, true);

	/*
	 * Adds a zombie counter to the bottom of the screen
	 *
	 * Customizable parameters:
	 * x - X coordinates distance (ex: 0)
	 * y - Y coordinates distance (ex: 190)
	 */
	// thread zombieCounter(p, l, 0, 190);

	/*
	 * Adds a health counter to the bottom of the screen
	 *
	 * Customizable parameters:
	 * x - X coordinates distance (ex: 0)
	 * y - Y coordinates distance (ex: 190)
	 */
	// thread healthCounter(p, 0, 190);

	/*
	 * Adds a zombie and a health counter to the bottom of the screen
	 *
	 * Customizable parameters:
	 * x - X coordinates distance (ex: 100 & -100)
	 * y - Y coordinates distance (ex: 190)
	 */
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
