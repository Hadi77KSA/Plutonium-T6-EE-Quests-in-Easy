#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;

main()
{
	onplayerconnect_callback( ::tomahawk_upgrade_quest );
}

tomahawk_upgrade_quest()
{
	if ( !( isdefined( level.gamedifficulty ) && level.gamedifficulty == 0 ) )
		return;

	self endon( "disconnect" );

	for ( self.tomahawk_upgrade_kills = 0; self.tomahawk_upgrade_kills < 15; self.tomahawk_upgrade_kills++ )
		self waittill( "got_a_tomahawk_kill" );

	wait 1.0;
	level thread maps\mp\zombies\_zm_audio::sndmusicstingerevent( "quest_generic" );
	e_org = spawn( "script_origin", self.origin + vectorscale( ( 0, 0, 1 ), 64.0 ) );
	e_org playsoundwithnotify( "zmb_easteregg_scream", "easteregg_scream_complete" );
	e_org waittill( "easteregg_scream_complete" );
	e_org delete();

	while ( level.round_number < 10 )
		wait 0.5;

	self ent_flag_init( "gg_round_done" );

	while ( !self ent_flag( "gg_round_done" ) )
	{
		level waittill( "between_round_over" );
		self.killed_with_only_tomahawk = 1;
		self.killed_something_thq = 0;

		if ( !self maps\mp\zombies\_zm_zonemgr::is_player_in_zone( "zone_golden_gate_bridge" ) )
			continue;

		level waittill( "end_of_round" );

		if ( !self.killed_with_only_tomahawk || !self.killed_something_thq )
			continue;

		if ( !self maps\mp\zombies\_zm_zonemgr::is_player_in_zone( "zone_golden_gate_bridge" ) )
			continue;

		self ent_flag_set( "gg_round_done" );
	}

	level thread maps\mp\zombies\_zm_audio::sndmusicstingerevent( "quest_generic" );
	e_org = spawn( "script_origin", self.origin + vectorscale( ( 0, 0, 1 ), 64.0 ) );
	e_org playsoundwithnotify( "zmb_easteregg_scream", "easteregg_scream_complete" );
	e_org waittill( "easteregg_scream_complete" );
	e_org delete();
	self notify( "hellhole_time" );
	self waittill( "tomahawk_in_hellhole" );

	if ( isdefined( self.retriever_trigger ) )
		self.retriever_trigger setinvisibletoplayer( self );
	else
	{
		trigger = getent( "retriever_pickup_trigger", "script_noteworthy" );
		self.retriever_trigger = trigger;
		self.retriever_trigger setinvisibletoplayer( self );
	}

	self takeweapon( "bouncing_tomahawk_zm" );
	self set_player_tactical_grenade( "none" );
	self notify( "tomahawk_upgraded_swap" );
	level thread maps\mp\zombies\_zm_audio::sndmusicstingerevent( "quest_generic" );
	e_org = spawn( "script_origin", self.origin + vectorscale( ( 0, 0, 1 ), 64.0 ) );
	e_org playsoundwithnotify( "zmb_easteregg_scream", "easteregg_scream_complete" );
	e_org waittill( "easteregg_scream_complete" );
	e_org delete();
	level waittill( "end_of_round" );
	tomahawk_pick = getent( "spinning_tomahawk_pickup", "targetname" );
	tomahawk_pick setclientfield( "play_tomahawk_fx", 2 );
	self.current_tomahawk_weapon = "upgraded_tomahawk_zm";
}
