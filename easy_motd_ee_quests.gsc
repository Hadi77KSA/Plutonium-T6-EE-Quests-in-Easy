#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zm_alcatraz_sq;
#include maps\mp\zm_alcatraz_weap_quest;
#include maps\mp\zm_prison_spoon;
#include maps\mp\zm_prison_sq_bg;
#include maps\mp\zm_prison_sq_final;
#include maps\mp\zombies\_zm_utility;

main()
{
	replaceFunc( maps\mp\zm_alcatraz_sq::start_alcatraz_sidequest, ::easy_start_alcatraz_sidequest );
	onplayerconnect_callback( ::easy_tomahawk_upgrade_quest );
	replaceFunc( maps\mp\zm_prison_spoon::init, ::easy_spoon_init );
	replaceFunc( maps\mp\zm_prison_sq_bg::init, ::easy_sq_bg_init );
	replaceFunc( maps\mp\zm_prison_sq_final::stage_one, ::easy_stage_one );
	thread onPlayerConnect();
}

onPlayerConnect()
{
	while ( true )
	{
		level waittill( "connected", player );
		player iPrintLn( "^5Mob of the Dead EE Quests in Easy Difficulty" );
	}
}

easy_start_alcatraz_sidequest()
{
	init();
	onplayerconnect_callback( ::player_disconnect_watcher );
	onplayerconnect_callback( ::player_death_watcher );
	flag_wait( "start_zombie_round_logic" );
/#
	setup_devgui();
#/
	level.n_quest_iteration_count = 1;
	level.n_plane_fuel_count = 5;
	level.n_plane_pieces_found = 0;
	level.final_flight_players = [];
	level.final_flight_activated = 0;
	level.characters_in_nml = [];
	level.someone_has_visited_nml = 0;
	level.custom_game_over_hud_elem = maps\mp\zm_prison_sq_final::custom_game_over_hud_elem;
	prevent_theater_mode_spoilers();
	setup_key_doors();
	setup_puzzle_piece_glint();
	setup_puzzles();
	setup_quest_triggers();

	maps\mp\zm_prison_sq_final::final_flight_setup();

	level thread warden_fence_hotjoin_handler();

	if ( isdefined( level.host_migration_listener_custom_func ) )
		level thread [[ level.host_migration_listener_custom_func ]]();
	else
		level thread host_migration_listener();

	if ( isdefined( level.manage_electric_chairs_custom_func ) )
		level thread [[ level.manage_electric_chairs_custom_func ]]();
	else
		level thread manage_electric_chairs();

	if ( isdefined( level.plane_flight_thread_custom_func ) )
		level thread [[ level.plane_flight_thread_custom_func ]]();
	else
		level thread plane_flight_thread();

	if ( isdefined( level.track_quest_status_thread_custom_func ) )
		level thread [[ level.track_quest_status_thread_custom_func ]]();
	else
		level thread track_quest_status_thread();

	maps\mp\zm_alcatraz_sq_vo::opening_vo();
}

easy_tomahawk_upgrade_quest()
{
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

easy_spoon_init()
{
	precachemodel( "t6_wpn_zmb_spoon_world" );
	precachemodel( "c_zom_inmate_g_rarmspawn" );
	level thread wait_for_initial_conditions();
	array_thread( level.zombie_spawners, ::add_spawn_function, ::zombie_spoon_func );
	level thread bucket_init();
	spork_portal = getent( "afterlife_show_spork", "targetname" );
	spork_portal setinvisibletoall();
	level.b_spoon_in_tub = 0;
	level.n_spoon_kill_count = 0;
	flag_init( "spoon_obtained" );
	flag_init( "charged_spoon" );
/#
	level thread debug_prison_spoon_quest();
#/
}

easy_sq_bg_init()
{
	precachemodel( "p6_zm_al_skull_afterlife" );
	flag_init( "warden_blundergat_obtained" );
	level thread wait_for_initial_conditions();
}

easy_stage_one()
{
	precachemodel( "p6_zm_al_audio_headset_icon" );
	flag_wait( "quest_completed_thrice" );
	flag_wait( "spoon_obtained" );
	flag_wait( "warden_blundergat_obtained" );
/#
	players = getplayers();

	foreach ( player in players )
	{
		player.fq_client_hint = newclienthudelem( player );
		player.fq_client_hint.x = 25;
		player.fq_client_hint.y = 200;
		player.fq_client_hint.alignx = "center";
		player.fq_client_hint.aligny = "bottom";
		player.fq_client_hint.fontscale = 1.6;
		player.fq_client_hint.alpha = 1;
		player.fq_client_hint.sort = 20;
		player.fq_client_hint settext( 386 + " - " + 481 + " - " + 101 + " - " + 872 );
	}
#/
	for ( i = 1; i < 4; i++ )
	{
		m_nixie_tube = getent( "nixie_tube_" + i, "targetname" );
		m_nixie_tube thread nixie_tube_scramble_protected_effects( i );
	}

	level waittill_multiple( "nixie_tube_trigger_1", "nixie_tube_trigger_2", "nixie_tube_trigger_3" );
	level thread nixie_final_codes( 386 );
	level thread nixie_final_codes( 481 );
	level thread nixie_final_codes( 101 );
	level thread nixie_final_codes( 872 );
	level waittill_multiple( "nixie_final_" + 386, "nixie_final_" + 481, "nixie_final_" + 101, "nixie_final_" + 872 );
	nixie_tube_off();
/#
	players = getplayers();

	foreach ( player in players )
		player.fq_client_hint destroy();
#/
	m_nixie_tube = getent( "nixie_tube_1", "targetname" );
	m_nixie_tube playsoundwithnotify( "vox_brutus_nixie_right_0", "scary_voice" );

	m_nixie_tube waittill( "scary_voice" );

	wait 3;
	level thread stage_two();
}