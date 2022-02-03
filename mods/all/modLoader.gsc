#include common_scripts/utility;
#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/zombies/_zm_utility;
#include maps/mp/zombies/_zm_perks;

/*
 * Function Responsible for Loading the Mods
 * comment with // the mods you want to disable
 * and then compile with a gsc compiler.
 */
modLoader(p, l)
{
	// Preloads tombstone before black screen after loading the map
	//activateTombstone(l);

	////////////////////////////////////////////////////////////////////////
	// Waits for the black preload screen to pass so it can load the mods //
	// DO NOT TOUCH THIS LINE BELOW!!                                     //
	flag_wait( "initial_blackscreen_passed" );                            //
	////////////////////////////////////////////////////////////////////////

	// Mod sets a custom Perk Limit
	thread setPerkLimit(l, 12);

	// Mod that sets the box price
	//setBoxPrice(l, 950);

	// Mod that adds a zombie counter to the bottom of the screen
	// p thread zombieCounter(p, l, 0, 190);
	p thread zombieCounter(p, l, 100, 190);

	// Mod that adds a health counter to the bottom of the screen
	// p thread healthCounter(p, 0, 190);
	p thread healthCounter(p, -100, 190);

	// Gives all the perks available in the map to the player
	perkaholic(p, l);
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

/*
 * Function that updates perk limit
 */
setPerkLimit(l, numberOfPerks)
{
	l.perk_purchase_limit = numberOfPerks;
}


/*
 * Function that draws a zombie counter
 */
zombieCounter(p, l, x, y)
{
	p.zombiecounter = drawCounter(p.zombiecounter, x, y);

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

/*
 * Function that activates solo tombstone perk
 */
activateTombstone(l)
{
	if (isDefined(l.zombiemode_using_tombstone_perk) && l.zombiemode_using_tombstone_perk)
	{
		l thread perk_machine_spawn_init();
		thread solo_tombstone_removal();
		thread turn_tombstone_on();
	}
}

/*
 * Function that gives the player all the perks available
 */
perkaholic(p, l)
{
	level waittill("start_of_round");
	if (isDefined(l.zombiemode_using_juggernaut_perk) && l.zombiemode_using_juggernaut_perk)
		p doGivePerk("specialty_armorvest");
	if (isDefined(l._custom_perks) && isDefined(l._custom_perks["specialty_nomotionsensor"]))
		p doGivePerk("specialty_nomotionsensor");
	if (isDefined(l.zombiemode_using_doubletap_perk) && l.zombiemode_using_doubletap_perk)
		p doGivePerk("specialty_rof");
	if (isDefined(l.zombiemode_using_marathon_perk) && l.zombiemode_using_marathon_perk)
		p doGivePerk("specialty_longersprint");
	if (isDefined(l.zombiemode_using_sleightofhand_perk) && l.zombiemode_using_sleightofhand_perk)
		p doGivePerk("specialty_fastreload");
	if(isDefined(l.zombiemode_using_additionalprimaryweapon_perk) && l.zombiemode_using_additionalprimaryweapon_perk)
		p doGivePerk("specialty_additionalprimaryweapon");
	if (isDefined(l.zombiemode_using_revive_perk) && l.zombiemode_using_revive_perk)
		p doGivePerk("specialty_quickrevive");
	if (isDefined(l.zombiemode_using_chugabud_perk) && l.zombiemode_using_chugabud_perk)
		p doGivePerk("specialty_finalstand");
	if (isDefined(l._custom_perks) && isDefined(l._custom_perks["specialty_grenadepulldeath"]))
		p doGivePerk("specialty_grenadepulldeath");
	if (isDefined(l._custom_perks) && isDefined(l._custom_perks["specialty_flakjacket"]) && (l.script != "zm_buried"))
		p doGivePerk("specialty_flakjacket");
	if (isDefined(l.zombiemode_using_deadshot_perk) && l.zombiemode_using_deadshot_perk)
		p doGivePerk("specialty_deadshot");
	if (isDefined(l.zombiemode_using_tombstone_perk) && l.zombiemode_using_tombstone_perk)
		p doGivePerk("specialty_scavenger");
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

/*
 * Initializes perk machine spawn and location
 */
perk_machine_spawn_init()
{
	match_string = "";
	location = level.scr_zm_map_start_location;
	if ( location != "default" && location == "" && isDefined( level.default_start_location ) )
	{
		location = level.default_start_location;
	}
	match_string = ( level.scr_zm_ui_gametype + "_perks_" ) + location;
	pos = [];
	if ( isDefined( level.override_perk_targetname ) )
	{
		structs = getstructarray( level.override_perk_targetname, "targetname" );
	}
	else
	{
		structs = getstructarray( "zm_perk_machine", "targetname" );
	}
	_a3578 = structs;
	_k3578 = getFirstArrayKey( _a3578 );
	while ( isDefined( _k3578 ) )
	{
		struct = _a3578[ _k3578 ];
		if ( isDefined( struct.script_string ) )
		{
			tokens = strtok( struct.script_string, " " );
			_a3583 = tokens;
			_k3583 = getFirstArrayKey( _a3583 );
			while ( isDefined( _k3583 ) )
			{
				token = _a3583[ _k3583 ];
				if ( token == match_string )
				{
					pos[ pos.size ] = struct;
				}
				_k3583 = getNextArrayKey( _a3583, _k3583 );
			}
		}
		else pos[ pos.size ] = struct;
		_k3578 = getNextArrayKey( _a3578, _k3578 );
	}
	if ( !isDefined( pos ) || pos.size == 0 )
	{
		return;
	}
	precachemodel( "zm_collision_perks1" );
	i = 0;
	while ( i < pos.size )
	{
		perk = pos[ i ].script_noteworthy;
		if ( isDefined( perk ) && isDefined( pos[ i ].model ) )
		{
			use_trigger = spawn( "trigger_radius_use", pos[ i ].origin + vectorScale( ( 0, -1, 0 ), 30 ), 0, 40, 70 );
			use_trigger.targetname = "zombie_vending";
			use_trigger.script_noteworthy = perk;
			use_trigger triggerignoreteam();
			perk_machine = spawn( "script_model", pos[ i ].origin );
			perk_machine.angles = pos[ i ].angles;
			perk_machine setmodel( pos[ i ].model );
			if ( isDefined( level._no_vending_machine_bump_trigs ) && level._no_vending_machine_bump_trigs )
			{
				bump_trigger = undefined;
			}
			else
			{
				bump_trigger = spawn( "trigger_radius", pos[ i ].origin, 0, 35, 64 );
				bump_trigger.script_activated = 1;
				bump_trigger.script_sound = "zmb_perks_bump_bottle";
				bump_trigger.targetname = "audio_bump_trigger";
				if ( perk != "specialty_weapupgrade" )
				{
					bump_trigger thread thread_bump_trigger();
				}
			}
			collision = spawn( "script_model", pos[ i ].origin, 1 );
			collision.angles = pos[ i ].angles;
			collision setmodel( "zm_collision_perks1" );
			collision.script_noteworthy = "clip";
			collision disconnectpaths();
			use_trigger.clip = collision;
			use_trigger.machine = perk_machine;
			use_trigger.bump = bump_trigger;
			if ( isDefined( pos[ i ].blocker_model ) )
			{
				use_trigger.blocker_model = pos[ i ].blocker_model;
			}
			if ( isDefined( pos[ i ].script_int ) )
			{
				perk_machine.script_int = pos[ i ].script_int;
			}
			if ( isDefined( pos[ i ].turn_on_notify ) )
			{
				perk_machine.turn_on_notify = pos[ i ].turn_on_notify;
			}
			if ( perk == "specialty_scavenger" || perk == "specialty_scavenger_upgrade" )
			{
				use_trigger.script_sound = "mus_perks_tombstone_jingle";
				use_trigger.script_string = "tombstone_perk";
				use_trigger.script_label = "mus_perks_tombstone_sting";
				use_trigger.target = "vending_tombstone";
				perk_machine.script_string = "tombstone_perk";
				perk_machine.targetname = "vending_tombstone";
				if ( isDefined( bump_trigger ) )
				{
					bump_trigger.script_string = "tombstone_perk";
				}
			}
			if ( isDefined( level._custom_perks[ perk ] ) && isDefined( level._custom_perks[ perk ].perk_machine_set_kvps ) )
			{
				[[ level._custom_perks[ perk ].perk_machine_set_kvps ]]( use_trigger, perk_machine, bump_trigger, collision );
			}
		}
		i++;
	}
}

/*
 * Allows notifies of solo tombstone
 */
solo_tombstone_removal()
{
	notify( "tombstone_on" );
}

/*
 * Turns tombstone on
 */
turn_tombstone_on()
{
	while ( 1 )
	{
		machine = getentarray( "vending_tombstone", "targetname" );
		machine_triggers = getentarray( "vending_tombstone", "target" );
		i = 0;
		while ( i < machine.size )
		{
			machine[ i ] setmodel( level.machine_assets[ "tombstone" ].off_model );
			i++;
		}
		level thread do_initial_power_off_callback( machine, "tombstone" );
		array_thread( machine_triggers, ::set_power_on, 0 );
		level waittill( "tombstone_on" );
		i = 0;
		while ( i < machine.size )
		{
			machine[ i ] setmodel( level.machine_assets[ "tombstone" ].on_model );
			machine[ i ] vibrate( vectorScale( ( 0, -1, 0 ), 100 ), 0,3, 0,4, 3 );
			machine[ i ] playsound( "zmb_perks_power_on" );
			machine[ i ] thread perk_fx( "tombstone_light" );
			machine[ i ] thread play_loop_on_machine();
			i++;
		}
		level notify( "specialty_scavenger_power_on" );
		array_thread( machine_triggers, ::set_power_on, 1 );
		if ( isDefined( level.machine_assets[ "tombstone" ].power_on_callback ) )
		{
			array_thread( machine, level.machine_assets[ "tombstone" ].power_on_callback );
		}
		level waittill( "tombstone_off" );
		if ( isDefined( level.machine_assets[ "tombstone" ].power_off_callback ) )
		{
			array_thread( machine, level.machine_assets[ "tombstone" ].power_off_callback );
		}
		array_thread( machine, ::turn_perk_off );
		players = get_players();
		_a1718 = players;
		_k1718 = getFirstArrayKey( _a1718 );
		while ( isDefined( _k1718 ) )
		{
			player = _a1718[ _k1718 ];
			player.hasperkspecialtytombstone = undefined;
			_k1718 = getNextArrayKey( _a1718, _k1718 );
		}
	}
}

/*
 * Displays animation while giving perk
 */
doGivePerk(perk)
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
