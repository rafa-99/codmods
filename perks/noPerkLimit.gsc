#include common_scripts/utility;
#include maps/mp/gametypes_zm/_hud_util;
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

	// Mod to Remove the Perk Limit
        level.perk_purchase_limit = 12;
    }
}