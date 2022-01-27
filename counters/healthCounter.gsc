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

	// Mod that adds a health counter to the bottom of the screen
        self thread healthCounter(self, 0, 190);
    }
}

/*
 * Function that draws a health counter
 */
healthCounter(p, x, y)
{
	p.healthcounter = drawCounter(p.healthcounter, x, y);

	while(1)
	{
        p.healthcounter.alpha = checkAfterlife(p);

        // Setting Counter Colors
        health = p.health;
        if( health <= 15 )
        {
        	p.healthcounter.label = &"Health: ^1";
        }
        else if ( health <= 50 )
        {
        	p.healthcounter.label = &"Health: ^3";
        }
        else
        {
        	p.healthcounter.label = &"Health: ^2";
        }

		p.healthcounter setValue(health);
		wait 0.05;
    }
}

// Aux Functions

/*
 * Draws the counter in desired position
 */
drawCounter(counterVar, x, y)
{
	counterVar = createfontstring( "Objective", 1.7 );
	counterVar setpoint( "CENTER", "CENTER", x, y);
	counterVar.alpha = 1;
	counterVar.hidewheninmenu = 1;
	counterVar.hidewhendead = 1;
	return counterVar;
}

/*
 * Checks if the player has entered afterlife
 */
checkAfterlife(p)
{
		if(isdefined(p.afterlife) && p.afterlife)
		{
			return 0.2;
		}
		return 1;
}
