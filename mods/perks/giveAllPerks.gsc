#include common_scripts/utility;
#include maps/mp/zombies/_zm_utility;
#include maps/mp/zombies/_zm_perks;

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
		level.perk_purchase_limit = 9;

		// Gives all the perks available in the map to the player
		giveAllPerks(self, level);
	}
}

/*
 * Function that gives the player all the perks available
 */
giveAllPerks(p, l)
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
