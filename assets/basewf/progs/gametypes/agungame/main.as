/*
Copyright (c) 2019, Jannik Kolodziej, All rights reserved.

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 3.0 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library.
*/

/*
This file depends on wf-scriptutils:
	clientcvar.as
	log.as
	functioncallcenter.as
	scoreboard.as;
*/

void AGG_SilentAward( Client @client, String award )
{
	// silent Awards are visible from the client, but are not logged by kandru/log.as or sent to wmm

	if( @client == null || client.state() < CS_SPAWNED || award.len() <= 0 )
		return;

	client.execGameCommand( "aw \"" + award + "\"\n" );

	// add the award also to every player who is chasing this player
	for( int i = 0; i < maxClients; i++ )
	{
		Client @cl = @G_GetClient( i );
		if( @cl == @client )
			return;
		if( cl.state() < CS_SPAWNED )
			return;
		if( !cl.chaseActive )
			return;

		if( cl.chaseTarget == client.getEnt().entNum )
			cl.execGameCommand( "aw \"" + award + "\"\n" );
	}

	// send the award to the score-event listeners
	FunctionCallCenter::GT_scoreEvent( client, "silentaward", award );
}

bool AGG_CheatVarResponse( Client @client, String &cmdString, String &argsString, int argc )
{
	if ( cmdString == "cvarinfo" )
    {
        GENERIC_CheatVarResponse( client, cmdString, argsString, argc );
        return true;
    }
    return false;
}

bool AGG_MatchStateFinished( int incomingMatchState )
{
    if ( match.getState() <= MATCH_STATE_WARMUP && incomingMatchState > MATCH_STATE_WARMUP
            && incomingMatchState < MATCH_STATE_POSTMATCH )
        match.startAutorecord();

    if ( match.getState() == MATCH_STATE_POSTMATCH )
        match.stopAutorecord();

    return true;
}

void AGG_MatchStateStarted()
{
    switch ( match.getState() )
    {
    case MATCH_STATE_WARMUP:
        gametype.pickableItemsMask = gametype.spawnableItemsMask;
        gametype.dropableItemsMask = gametype.spawnableItemsMask;
        GENERIC_SetUpWarmup();
		//CreateSpawnIndicators( "info_player_deathmatch", TEAM_PLAYERS );
		break;

    case MATCH_STATE_COUNTDOWN:
        gametype.pickableItemsMask = 0; // disallow item pickup
        gametype.dropableItemsMask = 0; // disallow item drop
        GENERIC_SetUpCountdown();
		//DeleteSpawnIndicators();
        break;

    case MATCH_STATE_PLAYTIME:
        gametype.pickableItemsMask = gametype.spawnableItemsMask;
        gametype.dropableItemsMask = gametype.spawnableItemsMask;
        GENERIC_SetUpMatch();
        break;

    case MATCH_STATE_POSTMATCH:
        gametype.pickableItemsMask = 0; // disallow item pickup
        gametype.dropableItemsMask = 0; // disallow item drop
        GENERIC_SetUpEndMatch();
        break;

    default:
        break;
    }
}

void AGG_RegisterCommands()
{
}

void AGG_RegisterClientCvars()
{
	ClientCvar::Register( "cg_agg_autoswitch", "1" );
}

void GT_InitGametype()
{
    gametype.title = "agungame";
    gametype.version = "2.0 Alpha";
    gametype.author = "drahti - ^1Kandru";

	AGG_PlayerInit(); // This one will Init the Scoreboard helper, so we don't have to do it here
	AGG_MediaInit();
	AGG_InterfaceInit();
	AGG_MineInit();

	FunctionCallCenter::SetTimeout( StatisticLog::Init, 1 ); // delay StatisticLog::Init() because localTime will need 1 think frame to be set
	Achievements::Init(); // This will Init the Achievementcenter

	Admin::Init();

	FunctionCallCenter::AutoProceedMatchStates = true;
	FunctionCallCenter::RegisterMatchStateFinishedListener( AGG_MatchStateFinished );
	FunctionCallCenter::RegisterMatchStateStartedListener( AGG_MatchStateStarted );

	FunctionCallCenter::RegisterThinkRulesListener( GENERIC_RequestCheatVars );
	FunctionCallCenter::RegisterGametypeCommandListener( AGG_CheatVarResponse );

	// name clan score K/D weapon time [admin/special] loggedin achievementpoints ping
    ScoreBoardHelper::SetLayout( "%n 112 %s 52 %s 52 %s 35 %p 18 %s 52 %s 112 %p 18 %s 56 %l 48" );
    ScoreBoardHelper::SetTitle( "Name Clan Score K/D W Time Rank A APoints Ping" );

	// For now we don't wanna use a gametype cfg

    gametype.spawnableItemsMask = 0;

    if ( gametype.isInstagib )
        gametype.spawnableItemsMask &= ~uint(G_INSTAGIB_NEGATE_ITEMMASK);

    gametype.respawnableItemsMask = gametype.spawnableItemsMask;
    gametype.dropableItemsMask = gametype.spawnableItemsMask;
    gametype.pickableItemsMask = gametype.spawnableItemsMask;

    gametype.isTeamBased = false;
    gametype.isRace = false;
    gametype.hasChallengersQueue = false;
    gametype.maxPlayersPerTeam = 0;

    gametype.ammoRespawn = 20;
    gametype.armorRespawn = 25;
    gametype.weaponRespawn = 5;
    gametype.healthRespawn = 15;
    gametype.powerupRespawn = 90;
    gametype.megahealthRespawn = 20;
    gametype.ultrahealthRespawn = 40;

    gametype.readyAnnouncementEnabled = false;
    gametype.scoreAnnouncementEnabled = false;
    gametype.countdownEnabled = false;
    gametype.mathAbortDisabled = false;
    gametype.shootingDisabled = false;
    gametype.infiniteAmmo = false;
    gametype.canForceModels = true;
    gametype.canShowMinimap = false;
    gametype.teamOnlyMinimap = false;

	gametype.mmCompatible = true;

    gametype.spawnpointRadius = 256;

    if ( gametype.isInstagib )
        gametype.spawnpointRadius *= 2;

    // set spawnsystem type
    for ( int team = TEAM_PLAYERS; team < GS_MAX_TEAMS; team++ )
        gametype.setTeamSpawnsystem( team, SPAWNSYSTEM_INSTANT, 0, 0, false );


	AGG_RegisterCommands();
	AGG_RegisterClientCvars();

    G_Print( "Gametype '" + gametype.title + "' initialized\n" );
}
