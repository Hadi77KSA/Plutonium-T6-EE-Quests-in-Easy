#include common_scripts\utility;
#include maps\mp\zm_prison_sq_bg;

main()
{
	replaceFunc( maps\mp\zm_prison_sq_bg::init, ::easy_sq_bg_init );
	thread onPlayerConnect();
}

onPlayerConnect()
{
	while ( true )
	{
		level waittill( "connected", player );
		player iPrintLn( "^5Free Blundergat Quest in Easy Difficulty" );
	}
}

easy_sq_bg_init()
{
	precachemodel( "p6_zm_al_skull_afterlife" );
	flag_init( "warden_blundergat_obtained" );
	level thread wait_for_initial_conditions();
}
