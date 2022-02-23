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
	if (l.round_number == 1)
	{
		l waittill("start_of_round");
		giveAllPerks(p, l, true);
	}
	else
	{
		l waittill("start_of_round");
		giveAllPerks(p, l, false);
		p notify("burp");
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
	l waittill("start_of_round");
	if (l.round_number > 5 && l.round_number <= 15)
	{
		p.score += 2500;
		if (l.script == "zm_tomb")
		{
			giveCustomWeapon(p, "mp40_zm");
		}
		else
		{
			giveCustomWeapon(p, "mp5k_zm");
		}
	}
	else if (l.round_number > 15)
	{
		p.score += 7500;
		if (l.script == "zm_tomb")
		{
			givePaPWeapon(p, "mp40_zm");
		}
		else
		{
			givePaPWeapon(p, "mp5k_zm");
		}
	}
}
