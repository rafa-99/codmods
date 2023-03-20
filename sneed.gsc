/*
 *	 Black Ops 2 Plutonium
 *
 *	 Creator : Rafael Marçalo
 *	 Project : SneedZombies
 *	 Version : v1
 *	 Mode : Zombies
 *	 Date : 2023/03/20
 *
 */

//////////////
// INCLUDES //
//////////////

#include common_scripts/utility;
#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/zombies/_zm;
#include maps/mp/zombies/_zm_utility;
#include maps/mp/zombies/_zm_weapons;
#include maps/mp/zombies/_zm_afterlife;
#include maps/mp/zombies/_zm_perks;

//////////
// MAIN //
//////////

init() // entry point
{
	// level setPerkLimit(12); // Sets the max perks allowed to be consumed per player
	level thread onplayerconnect();
}

onplayerconnect()
{
	for(;;)
	{
		level waittill("connected", player);
		player thread onplayerspawned();
	}
}

onplayerspawned()
{
	self endon("disconnect");
	for(;;)
	{
		// self thread darkMode();	// Forces the map to have a darker color palette
		// self infinteAfterlife();	// You'll get infinte time in afterlife;
		self waitForLoadedLevel();
		// self thread welcomeMessage("^3 Welcome to ^1SneedZombies ^3it's time to ^1SNEED ^3some zombies and ^1FEED ^3some points");	// Shows a welcome message
		// self thread zombieCounter(0, 190);	// Shows the number of zombies alive, the parameters are the coordinates X and Y where the counter will appear
		// self thread healthCounter(0, 190);	// Shows your health, the parameters are the coordinates X and Y where the counter will appear
		// level thread customMysteryBoxPrice(500);			// Sets the default mystery box price, the parameters define the box price value
		// self thread customStartingPoints(1000);			// Sets the default player's starting points, the parameters define the players's starting points value
		// self thread customPrimaryWeapon("galil_zm", true);		// Gives the player a custom primary weapon, the parameters define the base weapon codename and true/false if the weapon should come upgraded or not
		// self thread customSecondaryWeapon("ray_gun_zm", false);	// Gives the player a custom secondary weapon, the parameters define the base weapon codename and true/false if the weapon should come upgraded or not
		// level customZombieSpawnLimit(24);	// Sets the max amount of spawned zombies per round
		// self thread perkaholic(true);	// Gives the player all the available perks in the game, the parameters define if the player should see the bottle drinking animation;
		// self godMode();			// Enables player god mode
		// self thread unlimitedAmmo();		// Enables the player to have unlimited ammo;
	}
}

///////////////////////
// !! DANGER ZONE !! //
///////////////////////

///////////////
// MAIN MODS //
///////////////

setPerkLimit(numberOfPerks)
{
	self.perk_purchase_limit = numberOfPerks;
}

welcomeMessage(message)
{
	level waittill( "start_of_round" );
	self iprintln(message);
}

zombieCounter(x, y)
{
	self.zombiecounter = drawCounter(self.zombiecounter, x, y, "Objective", 1.7);

	for(;;)
	{
		zombies = level.zombie_total + get_current_zombie_count();
		if ( zombies > 0 )
		{
			self.zombiecounter.label = &"Zombies: ^1";
		}
		else
		{
			self.zombiecounter.label = &"Zombies: ^6";
		}

		self.zombiecounter setvalue(zombies);
		wait 0.05;
	}
}

healthCounter(x, y)
{
	self.healthcounter = drawCounter(self.healthcounter, x, y, "Objective", 1.7);

	for(;;)
	{
		if ( self checkAfterlife() )
		{
			self.healthcounter.alpha = 0.2;
		}
		else
		{
			self.healthcounter.alpha = 1;
		}

		health = self.health;

		if( health <= 15 )
		{
			self.healthcounter.label = &"Health: ^1";
		}
		else if ( self.health <= 50 )
		{
			self.healthcounter.label = &"Health: ^3";
		}
		else
		{
			self.healthcounter.label = &"Health: ^2";
		}

		self.healthcounter setValue(health);
		wait 0.05;
	}
}

perkaholic(animation)
{
	if (isDefined(self.customPrimary) && self.customPrimary)
	{
		self waittill("customPrimary");
	}

	self giveAllPerks(animation);
}

customMysteryBoxPrice(price)
{
	for (i = 0; i < self.chests.size; i++)
	{
		self.chests[ i ].zombie_cost = price;
		self.chests[ i ].old_cost = price;
	}
}

customStartingPoints(points)
{
	self.score = points;
}

customPrimaryWeapon(weapon, upgraded)
{
	self.customPrimary = true;
	currentWeapon = self getcurrentweapon();

	if ( currentWeapon != "none" )
	{
		self takeweapon(currentWeapon);
	}

	if ( upgraded )
	{
		self givePaPWeapon(weapon);
	}
	else
	{
		self giveWeapon(weapon);
	}

	self waittill("weapon_change_complete");
	self notify("customPrimary");
}

customSecondaryWeapon(weapon, upgraded)
{
	self.customSecondary = true;

	offHandWeapon = self getcurrentoffhand();

	if ( offHandWeapon != "none" )
	{
		self takeweapon(offHandWeapon);
	}

	if ( upgraded )
	{
		self givePaPWeapon(weapon);
	}
	else
	{
		self giveWeapon(weapon);
	}
}

customZombieSpawnLimit(limit)
{
	self.zombie_ai_limit = limit;
}

godMode()
{
	self enableInvulnerability(); // ToDo: Fix when coming back from afterlife, the god mode wears off
}

unlimitedAmmo()
{
	for(;;)
	{
		wait 0.05;

		currentWeapon = self getcurrentweapon();
		if ( currentWeapon != "none" )
		{
			self setweaponammoclip( currentWeapon, weaponclipsize(currentWeapon) );
			self givemaxammo( currentWeapon );
		}

		currentoffhand = self getcurrentoffhand();

		if ( currentoffhand != "none" )
		{
			self givemaxammo( currentoffhand );
		}
	}
}

darkMode()
{
	self setclientdvar( "r_dof_enable", 0 );
	self setclientdvar( "r_lodBiasRigid", -1000 );
	self setclientdvar( "r_lodBiasSkinned", -1000 );
	self setclientdvar( "r_enablePlayerShadow", 1 );
	self setclientdvar( "r_skyTransition", 1 );
	self setclientdvar( "sm_sunquality", 2 );
	self setclientdvar( "vc_fbm", "0 0 0 0" );
	self setclientdvar( "vc_fsm", "1 1 1 1" );
	self thread visualFix();
	self thread enableDarkMode();
}

// Mob of the Dead Specific
infinteAfterlife()
{
	self.infinite_mana = 1;
}


///////////////////
// AUXILIAR CODE //
///////////////////

waitForLoadedLevel()
{
	self waittill("spawned_player");
	flag_wait( "initial_blackscreen_passed" );

	if ( self checkAfterlife() && level initialRound() )
	{
		self waittill("player_revived");
	}

	wait 1;
}

drawCounter(counterVar, x, y, font, size)
{
	counterVar = createfontstring( font, size );
	counterVar setpoint( "CENTER", "CENTER", x, y);
	counterVar.alpha = 1;
	counterVar.hidewheninmenu = 1;
	counterVar.hidewhendead = 1;
	return counterVar;
}

// Level Entity
initialRound()
{
	return (self.round_number == self.start_round);
}

// Player Entity
checkAfterlife()
{
	if( isDefined(self.afterlife) && self.afterlife )
	{
		return 1;
	}
	return 0;
}

doGivePerk(perk, animation)
{
	if ( animation )
	{
		self endon("perk_abort_drinking");
		if (!(self hasperk(perk) || (self maps/mp/zombies/_zm_perks::has_perk_paused(perk))))
		{
			gun = self maps/mp/zombies/_zm_perks::perk_give_bottle_begin(perk);
			evt = self waittill_any_return("fake_death", "death", "player_downed", "weapon_change_complete");
			if (evt == "weapon_change_complete")
				self thread maps/mp/zombies/_zm_perks::wait_give_perk(perk, 1);
			self maps/mp/zombies/_zm_perks::perk_give_bottle_end(gun, perk);
			if (self maps/mp/zombies/_zm_laststand::player_is_in_laststand() || isDefined(self.intermission) && self.intermission)
				return;
			self notify("burp");
		}
	}
	else
	{
		if (!(self hasperk(perk) || (self maps/mp/zombies/_zm_perks::has_perk_paused(perk))))
		{
			self give_perk(perk);
		}
	}
}

giveAllPerks(animation)
{
	if (isDefined(level.zombiemode_using_juggernaut_perk) && level.zombiemode_using_juggernaut_perk)
		self doGivePerk("specialty_armorvest", animation);
	if (isDefined(level._custom_perks) && isDefined(level._custom_perks["specialty_nomotionsensor"]))
		self doGivePerk("specialty_nomotionsensor", animation);
	if (isDefined(level.zombiemode_using_doubletap_perk) && level.zombiemode_using_doubletap_perk)
		self doGivePerk("specialty_rof", animation);
	if (isDefined(level.zombiemode_using_marathon_perk) && level.zombiemode_using_marathon_perk)
		self doGivePerk("specialty_longersprint", animation);
	if (isDefined(level.zombiemode_using_sleightofhand_perk) && level.zombiemode_using_sleightofhand_perk)
		self doGivePerk("specialty_fastreload", animation);
	if(isDefined(level.zombiemode_using_additionalprimaryweapon_perk) && level.zombiemode_using_additionalprimaryweapon_perk)
		self doGivePerk("specialty_additionalprimaryweapon", animation);
	if (isDefined(level.zombiemode_using_revive_perk) && level.zombiemode_using_revive_perk)
		self doGivePerk("specialty_quickrevive", animation);
	if (isDefined(level.zombiemode_using_chugabud_perk) && level.zombiemode_using_chugabud_perk)
		self doGivePerk("specialty_finalstand", animation);
	if (isDefined(level._custom_perks) && isDefined(level._custom_perks["specialty_grenadepulldeath"]))
		self doGivePerk("specialty_grenadepulldeath", animation);
	if (isDefined(level._custom_perks) && isDefined(level._custom_perks["specialty_flakjacket"]) && (l.script != "zm_buried"))
		self doGivePerk("specialty_flakjacket", animation);
	if (isDefined(level.zombiemode_using_deadshot_perk) && level.zombiemode_using_deadshot_perk)
		self doGivePerk("specialty_deadshot", animation);
	if (isDefined(level.zombiemode_using_tombstone_perk) && level.zombiemode_using_tombstone_perk)
		self doGivePerk("specialty_scavenger", animation);
}

giveWeapon(weapon)
{
	if ( isDefined(weapon) )
	{

		self giveWeapon(weapon);
		self givemaxammo(weapon);
	}
}

givePaPWeapon(baseWeapon)
{
	if ( isDefined(baseWeapon) )
	{
		weapon = get_upgrade_weapon(baseWeapon, 0);
		if ( isDefined(weapon) )
		{
			self giveweapon(weapon, 0, self get_pack_a_punch_weapon_options(weapon));
			self givemaxammo(weapon);
		}
	}
}

visualFix()
{
	if( level.script == "zm_buried" )
	{
		while( 1 )
		{
			self setclientdvar( "r_lightTweakSunLight", 1 );
			self setclientdvar( "r_sky_intensity_factor0", 0 );
			wait 0.05;
		}
	}
	else if( level.script == "zm_prison" || level.script == "zm_tomb" )
	{
		while( getDvar( "r_lightTweakSunLight" ) != 0 )
		{
			for( i = getDvar( "r_lightTweakSunLight" ); i >= 0; i = ( i - 0.05 ) )
			{
				self setclientdvar( "r_lightTweakSunLight", i );
				wait 0.05;
			}
			wait 0.05;
		}
	}
	else return;
}

enableDarkMode()
{
	if( !isDefined( level.default_r_exposureValue ) )
		level.default_r_exposureValue = getDvar( "r_exposureValue" );
	if( !isDefined( level.default_r_lightTweakSunLight ) )
		level.default_r_lightTweakSunLight = getDvar( "r_lightTweakSunLight" );
	if( !isDefined( level.default_r_sky_intensity_factor0 ) )
		level.default_r_sky_intensity_factor0 = getDvar( "r_sky_intensity_factor0" );

	self setclientdvar( "r_filmUseTweaks", 1 );
	self setclientdvar( "r_bloomTweaks", 1 );
	self setclientdvar( "r_exposureTweak", 1 );
	self setclientdvar( "vc_rgbh", "0.1 0 0.3 0" );
	self setclientdvar( "vc_yl", "0 0 0.25 0" );
	self setclientdvar( "vc_yh", "0.02 0 0.1 0" );
	self setclientdvar( "vc_rgbl", "0.02 0 0.1 0" );
	self setclientdvar( "r_exposureValue", 3.9 );
	self setclientdvar( "r_lightTweakSunLight", 1 );
	self setclientdvar( "r_sky_intensity_factor0", 0 );

	if( level.script == "zm_buried" )
	{
		self setclientdvar( "r_exposureValue", 3.5 );
	}
	else if( level.script == "zm_tomb" )
	{
		self setclientdvar( "r_exposureValue", 4 );
	}
	else if( level.script == "zm_nuked" )
	{
		self setclientdvar( "r_exposureValue", 5.6 );
	}
	else if( level.script == "zm_highrise" )
	{
		self setclientdvar( "r_exposureValue", 3.9 );
	}
}
