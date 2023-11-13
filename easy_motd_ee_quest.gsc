#include common_scripts\utility;
#include maps\mp\zm_alcatraz_sq;
#include maps\mp\zm_prison_sq_final;
#include maps\mp\zombies\_zm_utility;

main()
{
	replaceFunc( maps\mp\zm_alcatraz_sq::start_alcatraz_sidequest, ::easy_start_alcatraz_sidequest );
	replaceFunc( maps\mp\zm_prison_sq_final::stage_one, ::easy_stage_one );
	thread onPlayerConnect();
}

onPlayerConnect()
{
	while ( true )
	{
		level waittill( "connected", player );
		player iPrintLn( "^5Mob of the Dead EE Quest in Easy Difficulty" );
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
