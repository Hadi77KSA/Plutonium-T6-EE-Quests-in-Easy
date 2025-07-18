#include common_scripts\utility;
#include maps\mp\zm_tomb_ee_main;
#include maps\mp\zombies\_zm_sidequests;

main()
{
	replaceFunc( maps\mp\zm_tomb_ee_main::init, ::easy_ee_main_init );
}

init()
{
	thread onPlayerConnect();
}

onPlayerConnect()
{
	for (;;)
	{
		level waittill( "connected", player );
		player thread display_mod_message();
	}
}

display_mod_message()
{
	self endon( "disconnect" );
	flag_wait( "initial_players_connected" );
	self iPrintLn( "^5Origins EE Quest in Easy Difficulty" );
}

easy_ee_main_init()
{
	registerclientfield( "actor", "ee_zombie_fist_fx", 14000, 1, "int" );
	registerclientfield( "actor", "ee_zombie_soul_portal", 14000, 1, "int" );
	registerclientfield( "world", "ee_sam_portal", 14000, 2, "int" );
	registerclientfield( "vehicle", "ee_plane_fx", 14000, 1, "int" );
	registerclientfield( "world", "ee_ending", 14000, 1, "int" );
	precache_models();
	flag_init( "ee_all_staffs_crafted" );
	flag_init( "ee_all_staffs_upgraded" );
	flag_init( "ee_all_staffs_placed" );
	flag_init( "ee_mech_zombie_hole_opened" );
	flag_init( "ee_mech_zombie_fight_completed" );
	flag_init( "ee_maxis_drone_retrieved" );
	flag_init( "ee_all_players_upgraded_punch" );
	flag_init( "ee_souls_absorbed" );
	flag_init( "ee_samantha_released" );
	flag_init( "ee_quadrotor_disabled" );
	flag_init( "ee_sam_portal_active" );

/* 	if ( !is_sidequest_allowed( "zclassic" ) )
		return; */

/#
	level thread setup_ee_main_devgui();
#/
	declare_sidequest( "little_girl_lost", ::init_sidequest, ::sidequest_logic, ::complete_sidequest, ::generic_stage_start, ::generic_stage_end );
	maps\mp\zm_tomb_ee_main_step_1::init();
	maps\mp\zm_tomb_ee_main_step_2::init();
	maps\mp\zm_tomb_ee_main_step_3::init();
	maps\mp\zm_tomb_ee_main_step_4::init();
	maps\mp\zm_tomb_ee_main_step_5::init();
	maps\mp\zm_tomb_ee_main_step_6::init();
	maps\mp\zm_tomb_ee_main_step_7::init();
	maps\mp\zm_tomb_ee_main_step_8::init();
	flag_wait( "start_zombie_round_logic" );
	sidequest_start( "little_girl_lost" );
}
