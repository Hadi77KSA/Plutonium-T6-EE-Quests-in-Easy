#include common_scripts\utility;
#include maps\mp\zm_prison_spoon;
#include maps\mp\zombies\_zm_utility;

main()
{
	replaceFunc( maps\mp\zm_prison_spoon::init, ::easy_spoon_init );
	thread onPlayerConnect();
}

onPlayerConnect()
{
	while ( true )
	{
		level waittill( "connected", player );
		player iPrintLn( "^5Spoon Quest in Easy Difficulty" );
	}
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
