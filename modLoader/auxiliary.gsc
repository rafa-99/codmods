/*
 * Draws the counter in desired position
 */
drawCounter(counterVar, x, y, font, size)
{
	counterVar = createfontstring( font, size );
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
	if(isDefined(p.afterlife) && p.afterlife)
	{
		return 0.2;
	}
	return 1;
}

/*
 * Function that gives the player all the perks if they are available in the current map
 */
giveAllPerks(p, l, animation)
{
    if (isDefined(l.zombiemode_using_juggernaut_perk) && l.zombiemode_using_juggernaut_perk)
         p doGivePerk("specialty_armorvest", animation);
    if (isDefined(l._custom_perks) && isDefined(l._custom_perks["specialty_nomotionsensor"]))
        p doGivePerk("specialty_nomotionsensor", animation);
    if (isDefined(l.zombiemode_using_doubletap_perk) && l.zombiemode_using_doubletap_perk)
         p doGivePerk("specialty_rof", animation);
    if (isDefined(l.zombiemode_using_marathon_perk) && l.zombiemode_using_marathon_perk)
        p doGivePerk("specialty_longersprint", animation);
    if (isDefined(l.zombiemode_using_sleightofhand_perk) && l.zombiemode_using_sleightofhand_perk)
        p doGivePerk("specialty_fastreload", animation);
    if(isDefined(l.zombiemode_using_additionalprimaryweapon_perk) && l.zombiemode_using_additionalprimaryweapon_perk)
        p doGivePerk("specialty_additionalprimaryweapon", animation);
    if (isDefined(l.zombiemode_using_revive_perk) && l.zombiemode_using_revive_perk)
       p doGivePerk("specialty_quickrevive", animation);
    if (isDefined(l.zombiemode_using_chugabud_perk) && l.zombiemode_using_chugabud_perk)
        p doGivePerk("specialty_finalstand", animation);
    if (isDefined(l._custom_perks) && isDefined(l._custom_perks["specialty_grenadepulldeath"]))
        p doGivePerk("specialty_grenadepulldeath", animation);
    if (isDefined(l._custom_perks) && isDefined(l._custom_perks["specialty_flakjacket"]) && (l.script != "zm_buried"))
        p doGivePerk("specialty_flakjacket", animation);
    if (isDefined(l.zombiemode_using_deadshot_perk) && l.zombiemode_using_deadshot_perk)
        p doGivePerk("specialty_deadshot", animation);
    if (isDefined(l.zombiemode_using_tombstone_perk) && l.zombiemode_using_tombstone_perk)
        p doGivePerk("specialty_scavenger", animation);
}

/*
 * Displays animation while giving perk
 */
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

/*
 * Displays crosshair for third person
 */
useCrosshairs(p)
{
	p.dot = drawCounter(p.dot, 0, 0, "default", 1.7);
	p.dot.label = &"+";
}

/*
 * Gives the player a custom weapon
 */
giveCustomWeapon(p, weapon)
{
	if ( isDefined(weapon) )
	{
		p giveWeapon(weapon);
		p givemaxammo(weapon);
	}
}


/*
 * Receive a pack a punched weapon
 */
givePaPWeapon(p, baseWeapon)
{
	if ( isDefined(baseWeapon) )
	{
		weapon = get_upgrade_weapon(baseWeapon, 0 );
		if ( isDefined(weapon) )
		{
			p giveweapon(weapon, 0, p get_pack_a_punch_weapon_options(weapon));
			p givemaxammo(weapon);
		}
	}
}

/*
 * Checks if its the initial round
 */
initialRound(l)
{
	return (l.round_number == l.start_round);
}

/*
 * Wait for the player to be revived in the initial round if is playing MotD
 */
waitMotd(p, l)
{
	if(isDefined(p.afterlife) && initialRound(l))
	{
		p waittill("player_revived");
	}
	
	wait 1;
}

/*
 * Fixing some scenary lighting
 */
visualFix(l)
{
	if( l.script == "zm_buried" )
	{
		while( 1 )
		{	
			self setclientdvar( "r_lightTweakSunLight", 1 );
			self setclientdvar( "r_sky_intensity_factor0", 0 );
			wait 0.05;
		}
	}
	else if( l.script == "zm_prison" || l.script == "zm_tomb" )
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

/*
 * Tweaks some lighting setting and enables nightmode
 */
enableNightMode(l)
{
	if( !isDefined( l.default_r_exposureValue ) )
		l.default_r_exposureValue = getDvar( "r_exposureValue" );
	if( !isDefined( l.default_r_lightTweakSunLight ) )
		l.default_r_lightTweakSunLight = getDvar( "r_lightTweakSunLight" );
	if( !isDefined( l.default_r_sky_intensity_factor0 ) )
		l.default_r_sky_intensity_factor0 = getDvar( "r_sky_intensity_factor0" );
	
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
	
	if( l.script == "zm_buried" )
	{
		self setclientdvar( "r_exposureValue", 3.5 );
	}
	else if( l.script == "zm_tomb" )
	{
		self setclientdvar( "r_exposureValue", 4 );
	}
	else if( l.script == "zm_nuked" )
	{
		self setclientdvar( "r_exposureValue", 5.6 );
	}
	else if( l.script == "zm_highrise" )
	{
		self setclientdvar( "r_exposureValue", 3.9 );
	}
}
