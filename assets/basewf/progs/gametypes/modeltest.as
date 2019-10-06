/*
Copyright (C) 2009-2010 Chasseur de bots

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
*/

int prcYesIcon;
int prcShockIcon;
int prcShellIcon;

int modelDistance = 50;

int modelnum = 0;

Cvar dmAllowPowerupDrop( "dm_powerupDrop", "1", CVAR_ARCHIVE );
Cvar dmAllowPowerups( "dm_allowPowerups", "1", CVAR_ARCHIVE );

///*****************************************************************
/// NEW MAP ENTITY DEFINITIONS
///*****************************************************************


///*****************************************************************
/// LOCAL FUNCTIONS
///*****************************************************************

// a player has just died. The script is warned about it so it can account scores
void DM_playerKilled( cEntity @target, cEntity @attacker, cEntity @inflicter )
{
    if ( match.getState() != MATCH_STATE_PLAYTIME )
        return;

    if ( @target.client == null )
        return;

    // update player score based on player stats

    target.client.stats.setScore( target.client.stats.frags - target.client.stats.suicides );
    if ( @attacker != null && @attacker.client != null )
        attacker.client.stats.setScore( attacker.client.stats.frags - attacker.client.stats.suicides );

    // drop items
    if ( ( G_PointContents( target.origin ) & CONTENTS_NODROP ) == 0 )
    {
        // drop the weapon
        if ( target.client.weapon > WEAP_GUNBLADE )
        {
            GENERIC_DropCurrentWeapon( target.client, true );
        }

        target.dropItem( AMMO_PACK_WEAK );

        if ( dmAllowPowerupDrop.boolean )
        {
            if ( target.client.inventoryCount( POWERUP_QUAD ) > 0 )
            {
                target.dropItem( POWERUP_QUAD );
                target.client.inventorySetCount( POWERUP_QUAD, 0 );
            }

            if ( target.client.inventoryCount( POWERUP_SHELL ) > 0 )
            {
                target.dropItem( POWERUP_SHELL );
                target.client.inventorySetCount( POWERUP_SHELL, 0 );
            }
        }
    }
    
    award_playerKilled( @target, @attacker,@inflicter );
}

///*****************************************************************
/// MODULE SCRIPT CALLS
///*****************************************************************

bool GT_Command( cClient @client, String &cmdString, String &argsString, int argc )
{
    if ( cmdString == "drop" )
    {
        String token;

        for ( int i = 0; i < argc; i++ )
        {
            token = argsString.getToken( i );
            if ( token.len() == 0 )
                break;

            if ( token == "fullweapon" )
            {
                GENERIC_DropCurrentWeapon( client, true );
                GENERIC_DropCurrentAmmoStrong( client );
            }
            else if ( token == "weapon" )
            {
                GENERIC_DropCurrentWeapon( client, true );
            }
            else if ( token == "strong" )
            {
                GENERIC_DropCurrentAmmoStrong( client );
            }
            else
            {
                GENERIC_CommandDropItem( client, token );
            }
        }

        return true;
    }
    else if ( cmdString == "cvarinfo" )
    {
        GENERIC_CheatVarResponse( client, cmdString, argsString, argc );
        return true;
    }
    // example of registered command
    else if ( cmdString == "gametype" )
    {
        String response = "";
        Cvar fs_game( "fs_game", "", 0 );
        String manifest = gametype.manifest;

        response += "\n";
        response += "Gametype " + gametype.name + " : " + gametype.title + "\n";
        response += "----------------\n";
        response += "Version: " + gametype.version + "\n";
        response += "Author: " + gametype.author + "\n";
        response += "Mod: " + fs_game.string + (!manifest.empty() ? " (manifest: " + manifest + ")" : "") + "\n";
        response += "----------------\n";

        G_PrintMsg( client.getEnt(), response );
        return true;
    }
	else if ( cmdString == "selectmodel")
	{
		String modelPfad = argsString.getToken( 0 );
		G_PrintMsg( null, "Pfad: " + modelPfad + "\n" );
		int model = G_ModelIndex( modelPfad );
		G_PrintMsg( null, "ModelIndex: " + model + "\n" );
		Cvar numbot( "g_numbots", "0", CVAR_ARCHIVE );
		numbot.set( 6 );
		Cvar dummy( "bot_dummy", "0", CVAR_ARCHIVE );
		dummy.set( 1 );
		Vec3 angles = client.getEnt().angles;
		Vec3 direction, r, u;
		Vec3 temp;
		angles.angleVectors( direction, r, u );
		direction.z = 0;
		temp.x = direction.y;
		temp.y = -direction.x;
		direction.normalize();
		temp.normalize();
		G_PrintMsg( null, "Laenge: " + direction.length() + "\n" );
		Vec3 ownorigin = client.getEnt().origin;
		Vec3 botOrigin;
		int x = 0;
		for ( int i = 0; i < maxClients; i++ )
		{
			botOrigin = ownorigin + (direction * 120) - (temp*((modelDistance/2)*(numbot.integer-1))) + ( temp *  (x*modelDistance)  );
			cClient @client = @G_GetClient( i );
			client.inventoryClear();
			if ( client.isBot() )
			{
				x ++;
				modelnum ++;
				client.getEnt().origin = botOrigin;
				client.getEnt().angles = temp.toAngles();
				if ( modelnum == 1 )
				{
					client.getEnt().setupModel( "models/players/bigvic" );
				}
				if ( modelnum == 2 )
				{
					client.getEnt().setupModel( "models/players/bobot" );
				}
				if ( modelnum == 3 )
				{
					client.getEnt().setupModel( "models/players/monada" );
				}
				if ( modelnum == 4 )
				{
					client.getEnt().setupModel( "models/players/padpork" );
				}
				if ( modelnum == 5 )
				{
					client.getEnt().setupModel( "models/players/silverclaw" );
				}
				if ( modelnum == 6 )
				{
					client.getEnt().setupModel( "models/players/viciious" );
					modelnum = 0;
				}
			}
		}
		for ( int i = 0; i < maxClients; i++ )
		{
			cEntity @ent = @G_GetClient( i ).getEnt();
			if ( ent.client.state() >= CS_SPAWNED && ent.team != TEAM_SPECTATOR )
			{
				ent.modelindex2 = model;
			}
		}
		
		return true;
	}
	else if ( cmdString == "spinleft" )
	{
		for ( int i = 0 ; i < maxClients; i++ )
		{
			cClient @client = @G_GetClient( i );
			if ( client.isBot() )
			{
				Vec3 angles = client.getEnt().angles;
				Vec3 dir, r, u;
				angles.angleVectors(dir, r, u);
				dir.z = 0;
				Vec3 temp;
				temp.x = dir.y;
				temp.y = -dir.x;
				client.getEnt().angles = temp.toAngles();
			}
		}
		return true;
	}
	else if ( cmdString == "spinright" )
	{
		for ( int i = 0 ; i < maxClients; i++ )
		{
			cClient @client = @G_GetClient( i );
			if ( client.isBot() )
			{
				Vec3 angles = client.getEnt().angles;
				Vec3 dir, r, u;
				angles.angleVectors(dir, r, u);
				dir.z = 0;
				Vec3 temp;
				temp.x = -dir.y;
				temp.y = dir.x;
				client.getEnt().angles = temp.toAngles();
			}
		}
		return true;
	}
	else if ( cmdString == "dummy" )
	{
		Cvar dummy( "bot_dummy", "0", CVAR_ARCHIVE );
		if ( dummy.integer == 0 )
			dummy.set( 1 );
		else 
			dummy.set( 0 );
		return true;	
	}
	else if ( cmdString == "distance" )
	{
		modelDistance = argsString.toInt();
		Cvar numbot( "g_numbots", "0", CVAR_ARCHIVE );
		Vec3 angles = client.getEnt().angles;
		Vec3 direction, r, u;
		Vec3 temp;
		angles.angleVectors( direction, r, u );
		direction.z = 0;
		temp.x = direction.y;
		temp.y = -direction.x;
		direction.normalize();
		temp.normalize();
		G_PrintMsg( null, "Laenge: " + direction.length() + "\n" );
		Vec3 ownorigin = client.getEnt().origin;
		Vec3 botOrigin;
		int x = 0;
		for ( int i = 0; i < maxClients; i++ )
		{
			botOrigin = ownorigin + (direction * 120) - (temp*((modelDistance/2)*(numbot.integer-1))) + ( temp *  (x*modelDistance)  );
			cClient @client2 = @G_GetClient( i );
			client2.inventoryClear();
			if ( client2.isBot() )
			{
				x ++;
				modelnum ++;
				client2.getEnt().origin = botOrigin;
			}
		}		
	}
    else if ( cmdString == "callvotevalidate" )
    {
        String votename = argsString.getToken( 0 );
        if ( votename == "dm_allow_powerups" )
        {
            String voteArg = argsString.getToken( 1 );
            if ( voteArg.len() < 1 )
            {
                client.printMessage( "Callvote " + votename + " requires at least one argument\n" );
                return false;
            }

            int value = voteArg.toInt();
            if ( voteArg != "0" && voteArg != "1" )
            {
                client.printMessage( "Callvote " + votename + " expects a 1 or a 0 as argument\n" );
                return false;
            }

            if ( voteArg == "0" && !dmAllowPowerups.boolean )
            {
            	client.printMessage( "Powerups are already disallowed\n" );
                return false;
            }

            if ( voteArg == "1" && dmAllowPowerups.boolean )
            {
            	client.printMessage( "Powerups are already allowed\n" );
                return false;
            }

            return true;
        }

        if ( votename == "dm_powerup_drop" )
        {
            String voteArg = argsString.getToken( 1 );
            if ( voteArg.len() < 1 )
            {
                client.printMessage( "Callvote " + votename + " requires at least one argument\n" );
                return false;
            }

            int value = voteArg.toInt();
            if ( voteArg != "0" && voteArg != "1" )
            {
                client.printMessage( "Callvote " + votename + " expects a 1 or a 0 as argument\n" );
                return false;
            }

            if ( voteArg == "0" && !dmAllowPowerupDrop.boolean )
            {
            	client.printMessage( "Powerup drop is already disallowed\n" );
                return false;
            }

            if ( voteArg == "1" && dmAllowPowerupDrop.boolean )
            {
            	client.printMessage( "Powerup drop is already allowed\n" );
                return false;
            }

            return true;
        }

        client.printMessage( "Unknown callvote " + votename + "\n" );
        return false;
    }
    else if ( cmdString == "callvotepassed" )
    {
        String votename = argsString.getToken( 0 );
        if ( votename == "dm_allow_powerups" )
        {
        	if( argsString.getToken( 1 ).toInt() > 0 )
            	dmAllowPowerups.set( 1 );
            else
            	dmAllowPowerups.set( 0 );

            // force a match restart to update
            match.launchState( MATCH_STATE_POSTMATCH );
            return true;
        }

        if ( votename == "dm_powerup_drop" )
        {
            if( argsString.getToken( 1 ).toInt() > 0 )
            	dmAllowPowerupDrop.set( 1 );
            else
            	dmAllowPowerupDrop.set( 0 );
        }

        return true;
    }

    return false;
}

// When this function is called the weights of items have been reset to their default values,
// this means, the weights *are set*, and what this function does is scaling them depending
// on the current bot status.
// Player, and non-item entities don't have any weight set. So they will be ignored by the bot
// unless a weight is assigned here.
bool GT_UpdateBotStatus( cEntity @self )
{
    return GENERIC_UpdateBotStatus( self );
}

// select a spawning point for a player
cEntity @GT_SelectSpawnPoint( cEntity @self )
{
    return GENERIC_SelectBestRandomSpawnPoint( self, "info_player_deathmatch" );
}

String @GT_ScoreboardMessage( uint maxlen )
{
    String scoreboardMessage = "";
    String entry;
    cTeam @team;
    cEntity @ent;
    int i, carrierIcon, readyIcon;

    @team = @G_GetTeam( TEAM_PLAYERS );

    // &t = team tab, team tag, team score (doesn't apply), team ping (doesn't apply)
    entry = "&t " + int( TEAM_PLAYERS ) + " " + team.stats.score + " 0 ";
    if ( scoreboardMessage.len() + entry.len() < maxlen )
        scoreboardMessage += entry;

    for ( i = 0; @team.ent( i ) != null; i++ )
    {
        @ent = @team.ent( i );

        if ( ( ent.effects & EF_QUAD ) != 0 )
            carrierIcon = prcShockIcon;
        else if ( ( ent.effects & EF_SHELL ) != 0 )
            carrierIcon = prcShellIcon;
        else
            carrierIcon = 0;

        if ( ent.client.isReady() )
            readyIcon = prcYesIcon;
        else
            readyIcon = 0;

		int playerID = ( ent.isGhosting() && ( match.getState() == MATCH_STATE_PLAYTIME ) ) ? -( ent.playerNum + 1 ) : ent.playerNum;

        entry = "&p " + playerID + " " + ent.client.clanName + " " + ent.client.stats.score + " " + ent.client.ping
                + " " + carrierIcon + " " + readyIcon + " ";

        if ( scoreboardMessage.len() + entry.len() < maxlen )
            scoreboardMessage += entry;
    }

    return scoreboardMessage;
}

// Some game actions trigger score events. These are events not related to killing
// oponents, like capturing a flag
// Warning: client can be null
void GT_scoreEvent( cClient @client, String &score_event, String &args )
{
    if ( score_event == "dmg" )
    {
    }
    else if ( score_event == "kill" )
    {
        cEntity @attacker = null;

        if ( @client != null )
            @attacker = @client.getEnt();

        int arg1 = args.getToken( 0 ).toInt();
        int arg2 = args.getToken( 1 ).toInt();

        // target, attacker, inflictor
        DM_playerKilled( G_GetEntity( arg1 ), attacker, G_GetEntity( arg2 ) );
    }
    else if ( score_event == "award" )
    {
    }
}

// a player is being respawned. This can happen from several ways, as dying, changing team,
// being moved to ghost state, be placed in respawn queue, being spawned from spawn queue, etc
void GT_playerRespawn( cEntity @ent, int old_team, int new_team )
{
    if ( ent.isGhosting() )
        return;

    if ( gametype.isInstagib )
    {
        ent.client.inventoryGiveItem( WEAP_INSTAGUN );
        ent.client.inventorySetCount( AMMO_INSTAS, 1 );
        ent.client.inventorySetCount( AMMO_WEAK_INSTAS, 1 );
    }
    else
    {
        cItem @item;
        cItem @ammoItem;

        // the gunblade can't be given (because it can't be dropped)
        ent.client.inventorySetCount( WEAP_GUNBLADE, 1 );

        @item = @G_GetItem( WEAP_GUNBLADE );

        @ammoItem = @G_GetItem( item.ammoTag );
        if ( @ammoItem != null )
            ent.client.inventorySetCount( ammoItem.tag, ammoItem.inventoryMax );

        @ammoItem = item.weakAmmoTag == AMMO_NONE ? null : @G_GetItem( item.weakAmmoTag );
        if ( @ammoItem != null )
            ent.client.inventorySetCount( ammoItem.tag, ammoItem.inventoryMax );

        if ( match.getState() <= MATCH_STATE_WARMUP )
        {
            ent.client.inventoryGiveItem( ARMOR_YA );
            ent.client.inventoryGiveItem( ARMOR_YA );

            // give all weapons
            for ( int i = WEAP_GUNBLADE + 1; i < WEAP_TOTAL; i++ )
            {
                if ( i == WEAP_INSTAGUN ) // dont add instagun...
                    continue;

                ent.client.inventoryGiveItem( i );

                @item = @G_GetItem( i );

                @ammoItem = item.weakAmmoTag == AMMO_NONE ? null : @G_GetItem( item.weakAmmoTag );
                if ( @ammoItem != null )
                    ent.client.inventorySetCount( ammoItem.tag, ammoItem.inventoryMax );

                @ammoItem = @G_GetItem( item.ammoTag );
                if ( @ammoItem != null )
                    ent.client.inventorySetCount( ammoItem.tag, ammoItem.inventoryMax );
            }
        }
        else
        {
            ent.health = ent.maxHealth * 1.25;
        }
    }

    // select rocket launcher if available
    ent.client.selectWeapon( -1 ); // auto-select best weapon in the inventory

    // add a teleportation effect
    ent.respawnEffect();
}

// Thinking function. Called each frame
void GT_ThinkRules()
{
    if ( match.scoreLimitHit() || match.timeLimitHit() || match.suddenDeathFinished() )
        match.launchState( match.getState() + 1 );

    if ( match.getState() >= MATCH_STATE_POSTMATCH )
        return;

	GENERIC_Think();

    // check maxHealth rule
    for ( int i = 0; i < maxClients; i++ )
    {
        cEntity @ent = @G_GetClient( i ).getEnt();
        if ( ent.client.state() >= CS_SPAWNED && ent.team != TEAM_SPECTATOR )
        {
            if ( ent.health > ent.maxHealth )
                ent.health -= ( frameTime * 0.001f );

            GENERIC_ChargeGunblade( ent.client );
        }
    }
}

// The game has detected the end of the match state, but it
// doesn't advance it before calling this function.
// This function must give permission to move into the next
// state by returning true.
bool GT_MatchStateFinished( int incomingMatchState )
{
    if ( match.getState() <= MATCH_STATE_WARMUP && incomingMatchState > MATCH_STATE_WARMUP
            && incomingMatchState < MATCH_STATE_POSTMATCH )
        match.startAutorecord();

    if ( match.getState() == MATCH_STATE_POSTMATCH )
        match.stopAutorecord();
    return true;
}

// the match state has just moved into a new state. Here is the
// place to set up the new state rules
void GT_MatchStateStarted()
{
    switch ( match.getState() )
    {
    case MATCH_STATE_WARMUP:
        gametype.pickableItemsMask = gametype.spawnableItemsMask;
        gametype.dropableItemsMask = gametype.spawnableItemsMask;
        GENERIC_SetUpWarmup();
		CreateSpawnIndicators( "info_player_deathmatch", TEAM_PLAYERS );
		break;

    case MATCH_STATE_COUNTDOWN:
        gametype.pickableItemsMask = 0; // disallow item pickup
        gametype.dropableItemsMask = 0; // disallow item drop
        GENERIC_SetUpCountdown();
		DeleteSpawnIndicators();
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

// the gametype is shutting down cause of a match restart or map change
void GT_Shutdown()
{
}

// The map entities have just been spawned. The level is initialized for
// playing, but nothing has yet started.
void GT_SpawnGametype()
{
gametype.canForceModels = false;
}

// Important: This function is called before any entity is spawned, and
// spawning entities from it is forbidden. If you want to make any entity
// spawning at initialization do it in GT_SpawnGametype, which is called
// right after the map entities spawning.

void GT_InitGametype()
{
    gametype.title ="Model Test";
    gametype.version = "1.02";
    gametype.author = "Warsow Development Team";
	
	Cvar numbot( "g_numbots", "0", CVAR_ARCHIVE );
	numbot.set( 6 );

    // if the gametype doesn't have a config file, create it
    if ( !G_FileExists( "configs/server/gametypes/" + gametype.name + ".cfg" ) )
    {
        String config;

        // the config file doesn't exist or it's empty, create it
        config = "// '" + gametype.title + "' gametype configuration file\n"
                 + "// This config will be executed each time the gametype is started\n"
                 + "\n\n// map rotation\n"
                 + "set g_maplist \"wdm1 wdm2 wdm3 wdm4 wdm5 wdm6 wdm7 wdm8 wdm9 wdm10 wdm11 wdm12 wdm13 wdm14 wdm15 wdm18 wdm19 wdm20\" // list of maps in automatic rotation\n"
                 + "set g_maprotation \"1\"   // 0 = same map, 1 = in order, 2 = random\n"
                 + "\n// game settings\n"
                 + "set g_scorelimit \"0\"\n"
                 + "set g_timelimit \"15\"\n"
                 + "set g_warmup_timelimit \"1\"\n"
                 + "set g_match_extendedtime \"0\"\n"
                 + "set g_allow_falldamage \"1\"\n"
                 + "set g_allow_selfdamage \"1\"\n"
                 + "set g_allow_teamdamage \"1\"\n"
                 + "set g_allow_stun \"1\"\n"
                 + "set g_teams_maxplayers \"0\"\n"
                 + "set g_teams_allow_uneven \"0\"\n"
                 + "set g_countdown_time \"5\"\n"
                 + "set g_maxtimeouts \"3\" // -1 = unlimited\n"
                 + "set g_challengers_queue \"0\"\n"
                 + "set dm_allowPowerups \"1\"\n"
                 + "set dm_powerupDrop \"1\"\n"
                 + "\necho \"" + gametype.name + ".cfg executed\"\n";

        G_WriteFile( "configs/server/gametypes/" + gametype.name + ".cfg", config );
        G_Print( "Created default config file for '" + gametype.name + "'\n" );
        G_CmdExecute( "exec configs/server/gametypes/" + gametype.name + ".cfg silent" );
    }

    gametype.spawnableItemsMask = ( IT_WEAPON | IT_AMMO | IT_ARMOR | IT_POWERUP | IT_HEALTH );

    if( !dmAllowPowerups.boolean )
		gametype.spawnableItemsMask &= ~IT_POWERUP;

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
    gametype.shootingDisabled = true;
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

    // define the scoreboard layout
    G_ConfigString( CS_SCB_PLAYERTAB_LAYOUT, "%n 112 %s 52 %i 52 %l 48 %p 18 %p 18" );
    G_ConfigString( CS_SCB_PLAYERTAB_TITLES, "Name Clan Score Ping C R" );

    // precache images that can be used by the scoreboard
    prcYesIcon = G_ImageIndex( "gfx/hud/icons/vsay/yes" );
    prcShockIcon = G_ImageIndex( "gfx/hud/icons/powerup/quad" );
    prcShellIcon = G_ImageIndex( "gfx/hud/icons/powerup/warshell" );

    // add commands
    G_RegisterCommand( "drop" );
    G_RegisterCommand( "gametype" );
	G_RegisterCommand( "selectmodel" );
	G_RegisterCommand( "spinleft" );
	G_RegisterCommand( "spinright" );
	G_RegisterCommand( "dummy" );
	G_RegisterCommand( "distance" );

    // add callvotes
    G_RegisterCallvote( "dm_allow_powerups", "1 or 0", "Anables or disables the spawning of powerups in dm." );
    G_RegisterCallvote( "dm_powerup_drop", "1 or 0", "Anables or disables the dropping of powerups at dying in dm." );

    G_Print( "Gametype '" + gametype.title + "' initialized\n" );
}
