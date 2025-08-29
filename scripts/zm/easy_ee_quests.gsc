main()
{
	if ( maps\mp\zombies\_zm_utility::is_classic() || maps\mp\zombies\_zm_utility::is_survival() )
	{
		replaceFunc( maps\mp\zombies\_zm::init_levelvars, ::init_levelvars );
	}
}

init_levelvars()
{
	setGametypeSetting( "zmDifficulty", 0 );
	disableDetourOnce( maps\mp\zombies\_zm::init_levelvars );
	maps\mp\zombies\_zm::init_levelvars();
	setGametypeSetting( "zmDifficulty", 1 );
	level.gamedifficulty = 1;
}

init()
{
	if ( maps\mp\zombies\_zm_utility::is_classic() || maps\mp\zombies\_zm_utility::is_survival() )
	{
		thread onPlayerConnect();
		thread gameDifficulty();
	}
}

onPlayerConnect()
{
	for (;;)
	{
		level waittill( "connected", player );
		player thread msg();
	}
}

msg()
{
	self endon( "disconnect" );
	common_scripts\utility::flag_wait( "initial_players_connected" );
	self iPrintLn( "^5EE Quests in Easy Difficulty" );
}

gameDifficulty()
{
	common_scripts\utility::flag_wait( "initial_blackscreen_passed" );
	waittillframeend;
	level.gamedifficulty = 0;
}
