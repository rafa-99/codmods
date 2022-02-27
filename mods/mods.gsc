/*
 * Sets the new buyable perks limit
 */
setPerkLimit(l, numberOfPerks)
{
	l.perk_purchase_limit = numberOfPerks;
}

/*
 * Displays a zombie counter
 */
zombieCounter(p, l, x, y)
{
	p.zombiecounter = drawCounter(p.zombiecounter, x, y, "Objective", 1.7);

	while(1)
	{
		p.zombiecounter.alpha = checkAfterlife(p);

		zombies = l.zombie_total + get_current_zombie_count();
		if ( zombies > 0 )
		{
			p.zombiecounter.label = &"Zombies: ^1";
		}
		else
		{
			p.zombiecounter.label = &"Zombies: ^6";
		}

		p.zombiecounter setvalue(zombies);
		wait 0.05;
	}
}

/*
 * Displays a health counter
 */
healthCounter(p, x, y)
{
	p.healthcounter = drawCounter(p.healthcounter, x, y, "Objective", 1.7);

	while(1)
	{
		p.healthcounter.alpha = checkAfterlife(p);

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

/*
 * Gives all the perks available to the player
 */
perkaholic(p, l)
{
	flag_wait( "initial_blackscreen_passed" );
	waitMotd(p, l);
	
	if (l.round_number == 1)
	{
		if (isDefined(p.customPrimary) && p.customPrimary)
		{
			p waittill("customPrimary");
		}

		giveAllPerks(p, l, true);
	}
	else
	{
		giveAllPerks(p, l, false);
	}
}

/*
 * Sets a custom box price
 */
setBoxPrice(l, price)
{
	for (i = 0; i < l.chests.size; i++)
	{
		level.chests[ i ].zombie_cost = price;
		level.chests[ i ].old_cost = price;
	}
}

/*
 * Sets the player initial points
 */
setPlayerPoints(p, points)
{
	p.score = points;
}

/*
 * Sets the afterlife counter
 */
catHas9Lifes(p, lifes)
{
	if(isDefined(p.afterlife))
	{
		p.lives = lifes;
	}
}

/*
 * Play in third person
 */
playThirdPerson(p, crosshair)
{
	p setClientThirdPerson(1);

	if (crosshair)
	{
		thread useCrosshairs(p);
	}
}

/*
 * Toggle god mode on
 */
godMode(p)
{
	p enableInvulnerability();
}

/*
 * Toggle unlimited ammo on
 */
unlimitedAmmo(p)
{
	for(;;)
	{
		wait 0.05;

		currentWeapon = p getcurrentweapon();
		if ( currentWeapon != "none" )
		{
			p setweaponammoclip( currentWeapon, weaponclipsize(currentWeapon) );
			p givemaxammo( currentWeapon );
		}

		currentoffhand = p getcurrentoffhand();
		if ( currentoffhand != "none" )
			p givemaxammo( currentoffhand );
    }
}

/*
 * Gives later joined players, some bonuses
 */
joinedBonus(p, l)
{
	if ((l.round_number - l.start_round) >= 5 && (l.round_number - l.start_round) < 15)
	{
		if (isDefined(l.zombiemode_using_juggernaut_perk) && l.zombiemode_using_juggernaut_perk)
		{
			p doGivePerk("specialty_armorvest", false);
		}

		p.score += 2500;
		if (!isDefined(p.customSecondary))
		{
			if (l.script == "zm_tomb")
			{
				setSecondaryWeapon(p, l, "mp40_zm", false);
			}
			else
			{
				setSecondaryWeapon(p, l, "mp5k_zm", false);
			}
		}

	}
	else if ((l.round_number - l.start_round) >= 15)
	{
		if (isDefined(l.zombiemode_using_juggernaut_perk) && l.zombiemode_using_juggernaut_perk)
		{
			p doGivePerk("specialty_armorvest", false);
		}
		
		
		if (isDefined(l.zombiemode_using_doubletap_perk) && l.zombiemode_using_doubletap_perk)
		{
			p doGivePerk("specialty_rof", false);
		}
		
		p.score += 7500;
		if (!isDefined(p.customSecondary))
		{
			if (l.script == "zm_tomb")
			{
				setSecondaryWeapon(p, l, "mp40_zm", true);
			}
			else
			{
				setSecondaryWeapon(p, l, "mp5k_zm", true);
			}
		}
	}
}

/*
 * Allows Infinite Afterlife Timer
 */
infinteAfterlifeTimer(p)
{
	p.infinite_mana = 1;
}

/*
 * Sets player primary weapon
 */
setPrimaryWeapon(p, l, weapon, upgraded)
{
	p.customPrimary = true;
	
	waitMotd(p, l);
	currentWeapon = p getcurrentweapon();
	
	if ( currentWeapon != "none" )
	{
		p takeweapon(currentWeapon);
	}
	
	if ( upgraded )
	{
		givePaPWeapon(p, weapon);
	}
	else
	{
		giveCustomWeapon(p, weapon);
	}
	
	p waittill("weapon_change_complete");
	p notify("customPrimary");
}

/*
 * Sets player primary weapon
 */
setSecondaryWeapon(p, l, weapon, upgraded)
{
	p.customSecondary = true;
	
	waitMotd(p, l);
	offHandWeapon = p getcurrentoffhand();
	
	if ( offHandWeapon != "none" )
	{
		p takeweapon(offHandWeapon);
	}
	
	if ( upgraded )
	{
		givePaPWeapon(p, weapon);
	}
	else
	{
		giveCustomWeapon(p, weapon);
	}
}

/*
 * Enables night mode maps
 */
nightmode(p, l)
{
	p setclientdvar( "r_dof_enable", 0 );
	p setclientdvar( "r_lodBiasRigid", -1000 );
	p setclientdvar( "r_lodBiasSkinned", -1000 );
	p setclientdvar( "r_enablePlayerShadow", 1 );
	p setclientdvar( "r_skyTransition", 1 );
	p setclientdvar( "sm_sunquality", 2 );
	p setclientdvar( "vc_fbm", "0 0 0 0" );
	p setclientdvar( "vc_fsm", "1 1 1 1" );
	p thread visualFix(l);
	p thread enableNightMode(l);
}

/*
 * Sets the max zombies to a custom value
 */
setZombieLimit(l, limit)
{
	l.zombie_ai_limit = limit;
}
