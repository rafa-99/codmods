#include common_scripts/utility;
#include maps/mp/zombies/_zm_utility;

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

		// Waits for the black preload screen to pass so it can load the mods
		flag_wait( "initial_blackscreen_passed" );

		// Mod that sets the box price
		setBoxPrice(l, 950);
	}
}

/*
 * Function that sets a custom box price
 */
setBoxPrice(l, price)
{
	for (i = 0; i < l.chests.size; i++)
	{
		level.chests[ i ].zombie_cost = price;
		level.chests[ i ].old_cost = price;
	}
}
