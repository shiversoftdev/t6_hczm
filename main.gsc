/*
*	 Black Ops 2 - GSC Studio by iMCSx
*
*	 Creator : A
*	 Project : Hardcore Zombies
*    Mode : Zombies
*	 Date : 2016/01/24 - 16:16:42	
*
*/	

#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;

init()
{
    level thread onPlayerConnect();
    level thread InitializeHardcoreParameters();
    setDvar("party_connectToOthers" , "0");
	setDvar("partyMigrate_disabled" , "1");
	setDvar("party_mergingEnabled" , "0");
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawned();
    }
}

onPlayerSpawned()
{
    self endon("disconnect");
	level endon("game_ended");
	firstspawn = true;
    for(;;)
    {
        self waittill("spawned_player");
        self thread autorevivesect();
		self.maxhealth = 50;
		self.health = self.maxhealth;
		self setempjammed( true );
		self setclientuivisibilityflag( "hud_visible", 0 );
		self disableaimassist();
    }
}

InitializeHardcoreParameters()
{

for(i=30;i>0;i--)
{
iprintlnbold("Hardcore starting in "+i);
wait 1;
}
level.pers_upgrade_jugg = 0;
level.zombie_vars[ "zombie_score_bonus_melee" ] = 5;
level.zombie_vars[ "zombie_score_bonus_burn" ] = 5;
level.zombie_vars[ "zombie_score_bonus_head" ] = 10;
level.zombie_vars[ "zombie_score_bonus_neck" ] = 10;
level.zombie_vars[ "zombie_score_bonus_torso" ] = 5;
level.zombie_vars[ "zombie_score_damage_light" ] = 1;
level.zombie_vars[ "zombie_score_damage_normal" ] = 1;
level.zombie_vars[ "penalty_no_revive" ] = 1;
level.zombie_vars[ "penalty_died" ] = 1;
level.zombie_vars[ "penalty_downed" ] = 3;
setDvar( "player_lastStandBleedoutTime","20.0" );
level.perk_purchase_limit = 2;
level.zombie_vars[ "zombie_new_runner_interval" ] = 1;
level.zombie_actor_limit = 20;
level.zombie_ai_limit = 52;/*Insane 72*/
level.zombie_vars[ "zombie_max_ai" ] = 52;/*Insane 72*/
level.zombie_vars[ "zombie_ai_per_player" ] = 13;/*Insane 18*/
level.zombie_vars[ "zombie_health_increase_multiplier" ] = 1.15;/*Insane 1.5*/
level.zombie_vars[ "zombie_health_increase" ] = 400;/*Insane 600*/
level.zombie_vars[ "zombie_move_speed_multiplier" ] = 90; /*Insane 180*/
level.zombie_vars[ "zombie_between_round_time" ] = 3;/*Insane 0.01*/
level.zombie_vars[ "zombie_spawn_delay" ] = 0.01;
level.zombie_vars[ "zombie_perk_juggernaut_health" ] = 150;
level.zombie_vars[ "zombie_perk_juggernaut_health_upgrade" ] = 150;
foreach(player in level.players)
{
player.maxhealth = 50;
player.health = player.maxhealth;
player setempjammed( true );
player setclientuivisibilityflag( "hud_visible", 0 );
player disableaimassist();
}
level thread hardcoreroundswitch();
}

hardcoreroundswitch()
{
level thread maps/mp/zombies/_zm_audio::change_zombie_music( "dog_start" );
//ent = spawn( "script_origin", self.origin );
//ent playsound( "zmb_dog_round_start" );
for(;;)
{
level waittill( "between_round_over" );
wait 5.0;
level thread maps/mp/zombies/_zm_audio::change_zombie_music( "dog_start" );
}
}

autorevivesect()
{
for(j=3;j>0;j--)
{
self iprintln(j + " self revives remaining ");
for(;;)
{
if(self maps/mp/zombies/_zm_laststand::player_is_in_laststand()){
	for(i = 15; i>0;i--)
	{
	self iprintlnbold("Self-reviving in "+i);
	wait 1;
	}
	if(self maps/mp/zombies/_zm_laststand::player_is_in_laststand()){
	self maps/mp/zombies/_zm_laststand::auto_revive( self );
	self.maxhealth=50;
	self.health=50;
	break;
	}
	}
wait .1;
}
wait 1;

}

}


