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
	scoreboard.as
	functioncallcenter.as
	achievementcenter.as
*/

Player@[] aggPlayerList(maxClients);

class Weapon
{
	int weap;
	int ammo;

	Weapon()
	{
		weap = WEAP_NONE;
		ammo = 255;
	}

	Weapon(int w, int a)
	{
		weap = w;
		if( a <= 0 )
			a = 255;
		ammo = a;
	}

	void giveToClient( Client @client )
	{
		if( @client == null )
			return;
		if( weap == WEAP_NONE )
			return;


		if( weap == WEAP_GUNBLADE )
		{
			client.inventorySetCount( WEAP_GUNBLADE, 1 );
			client.inventorySetCount( AMMO_GUNBLADE, 10 );
		}
		else
		{
			client.inventoryGiveItem( weap );

			Item @item = @G_GetItem( weap );

			Item @ammoItem = item.ammoTag == AMMO_NONE ? null : @G_GetItem( item.ammoTag );
			if ( @ammoItem != null )
				client.inventorySetCount( ammoItem.tag, ammo );
		}
	}

	void refreshAmmo( Client @client )
	{
		if( @client == null )
			return;

		if( weap == WEAP_NONE )
			return;

		if( ammo < 255 ) // not infinite ammo
			return;

		if( weap == WEAP_GUNBLADE )
		{
			client.inventorySetCount( WEAP_GUNBLADE, 1 );
			client.inventorySetCount( AMMO_GUNBLADE, 10 );
			return;
		}

		Item @item = @G_GetItem( weap );

		Item @ammoItem = item.ammoTag == AMMO_NONE ? null : @G_GetItem( item.ammoTag );
		if ( @ammoItem != null )
			client.inventorySetCount( ammoItem.tag, ammo );
	}

	String get_weaponColor()
	{
		switch( weap )
		{
		case WEAP_GUNBLADE:
			return S_COLOR_WHITE;
		case WEAP_MACHINEGUN:
			return S_COLOR_GREY;
		case WEAP_RIOTGUN:
			return S_COLOR_ORANGE;
		case WEAP_GRENADELAUNCHER:
			return S_COLOR_BLUE;
		case WEAP_ROCKETLAUNCHER:
			return S_COLOR_RED;
		case WEAP_PLASMAGUN:
			return S_COLOR_GREEN;
		case WEAP_LASERGUN:
			return S_COLOR_YELLOW;
		case WEAP_ELECTROBOLT:
			return S_COLOR_CYAN;
		case WEAP_INSTAGUN:
			return S_COLOR_BLUE;
		}
		return S_COLOR_BLACK;
	}
}

Weapon[] AGG_WEAPORDER;

class Player
{
	private int m_playerNum;

	private int m_killStreakAmount;
	private int m_deathStreakAmount;

	private array<Streak@> m_killStreakList;
	private array<Streak@> m_deathStreakList;

	private int m_score;
	private int m_frags;
	private int m_deaths;

	private uint m_playTime;

	Player( int num )
	{
		m_playerNum = num;
		reset();

		m_killStreakList.insertLast( KillStreakGrenadeRefill( this ) );

		m_deathStreakList.insertLast( DeathStreakProtection( this ) );
		m_deathStreakList.insertLast( DeathStreakMartyrium( this ) );
		m_deathStreakList.insertLast( DeathStreakSpeedIncrement( this ) );
	}

	void reset()
	{
		m_killStreakAmount = 0;
		m_deathStreakAmount = 0;
		m_playTime = 0;
		m_score = 0;
		m_frags = 0;
		m_deaths = 0;
	}

	void joinedTeam()
	{
		if( @get_client() == null || client.state() < CS_SPAWNED ) // ASbug ( i guess ) I can't use @client, have to use get_client
			return;

		client.stats.setScore( m_score );
	}

	void leftTeam()
	{

	}

	void respawned()
	{
		Client @client = @G_GetClient( m_playerNum );
		if( @client == null || client.getEnt().team == TEAM_SPECTATOR || client.state() < CS_SPAWNED )
			return;

		AGG_WEAPORDER[0].giveToClient( client );
		client.selectWeapon( -1 );

		for( uint i = 0; i < m_killStreakList.length; i++ )
			m_killStreakList[i].respawn();
		for( uint i = 0; i < m_deathStreakList.length; i++ )
			m_deathStreakList[i].respawn();
	}

	void killedPlayer( Player @target )
	{
		m_killStreakAmount++;
		m_deathStreakAmount = 0;
		if( match.getState() == MATCH_STATE_PLAYTIME )
		{
			m_score++;
			m_frags++;
			client.stats.setScore( m_score );
		}
		if( uint(m_killStreakAmount) < AGG_WEAPORDER.length )
		{
			AGG_WEAPORDER[m_killStreakAmount].giveToClient( client );
			int weap = AGG_WEAPORDER[m_killStreakAmount].weap;
			if( weap != WEAP_NONE )
			{
				silentAward( S_COLOR_GREEN + "You are given a" + (weap == WEAP_ELECTROBOLT ? "n" : "") + " " + AGG_WEAPORDER[m_killStreakAmount].weaponColor + G_GetItem( weap ).name + S_COLOR_GREEN + "!" );
				String cvarcontent = ClientCvar::Get( client, "cg_agg_autoswitch" );
				if( cvarcontent != "null" )
				{
					if( cvarcontent != "0" )
						client.selectWeapon(weap);
				}
			}
		}

		for( uint i = 0; i < m_killStreakList.length; i++ )
			m_killStreakList[i].handleStreak( m_killStreakAmount );
	}

	void selfkill()
	{

	}

	void died( Player @attacker )
	{
		m_deathStreakAmount++;
		m_killStreakAmount = 0;

		if( match.getState() == MATCH_STATE_PLAYTIME )
			m_deaths++;

		for( uint i = 0; i < m_deathStreakList.length; i++ )
			m_deathStreakList[i].handleStreak( m_deathStreakAmount );
	}

	void think()
	{
		if( client.state() >= CS_CONNECTED && entity.team != TEAM_SPECTATOR && match.getState() == MATCH_STATE_PLAYTIME )
			m_playTime += frameTime;
		if( client.inventoryCount( WEAP_GUNBLADE ) > 0 )
			client.inventorySetCount( AMMO_GUNBLADE, 10 );

		if( client.state() > CS_SPAWNED || entity.team == TEAM_PLAYERS )
		{
			int maxWeap = uint(m_killStreakAmount) >= AGG_WEAPORDER.length ? AGG_WEAPORDER.length - 1 : m_killStreakAmount;
			for( int i = maxWeap; i >= 0; i-- )
				AGG_WEAPORDER[i].refreshAmmo( client );
		}
	}

	void silentAward( String award )
	{
		AGG_SilentAward( client, award );
	}

	void newMatchState( int state )
	{
		if( state >= MATCH_STATE_POSTMATCH )
			return;
		m_deathStreakAmount = 0;
		m_killStreakAmount = 0;
		m_deaths = 0;
		m_frags = 0;
		m_score = 0;
	}





	// name clan score K/D weapon time [admin/special] loggedin achievementpoints ping
	String get_scoreboardString()
	{
		String ret = "&p ";
		ret += (( match.getState() < MATCH_STATE_PLAYTIME && !entity.client.isReady() ) ? ScoreBoardHelper::InactivePlayer( m_playerNum ) : m_playerNum) + " ";
		ret += client.clanName + " ";
		ret += m_score + " ";
		if( m_deaths == m_frags )
			ret += "1.00 ";
		else if( m_deaths == 0 )
			ret += "999 ";
		else
		{
			String tmp = float(m_frags) / float(m_deaths);
			tmp = tmp.substr(0, 4);
			ret += tmp + " ";
		}
		ret += AGG_WeaponImage( client.weapon ) + " ";
		ret += int(m_playTime / 1000.0f / 60.0f) + " ";
		ret += "%rank%" + " "; // achievementcenter will replace this
		ret += ScoreBoardHelper::ConvertToPicture( AchievementCenter::IsActive( client ) ) + " ";
		ret += AchievementCenter::AchievementPoints( client ) + " ";
		ret += client.ping;
		return ret;
	}

	Client @get_client()
	{
		return G_GetClient( m_playerNum );
	}

	Entity @get_entity()
	{
		return ( @get_client() != null ) ? client.getEnt() : null;
	}

	PlayerMMInfo get_mmInfo()
	{
		return PlayerMMInfo( m_playerNum );
	}

	uint get_playTime()
	{
		return m_playTime;
	}

}

Player @AGG_GetPlayer( int playerNum )
{
	return ( playerNum >= 0 && playerNum < maxClients ) ? aggPlayerList[playerNum] : null;
}

Player @AGG_GetPlayer( Client @client )
{
	return ( @client != null ) ? aggPlayerList[client.playerNum] : null;
}

Player @AGG_GetPlayer( Entity @ent )
{
	return ( @ent != null && @ent.client != null ) ? aggPlayerList[ent.client.playerNum] : null;
}

Player @AGG_GetPlayer( PlayerMMInfo player ) // I have no idea why we would need this, but let's add this just in case
{
	return ( player.playerNum > 0 && player.playerNum < maxClients ) ? aggPlayerList[player.playerNum] : null;
}

// =========================================
// We should use the stuff above
// =========================================

void AGG_PlayerInit()
{
	FunctionCallCenter::RegisterScoreEventListener( AGG_PlayerScoreEvent );
	FunctionCallCenter::RegisterPlayerRespawnListener( AGG_PlayerRespawn );
	FunctionCallCenter::RegisterThinkRulesListener( AGG_PlayerThink );
	FunctionCallCenter::RegisterMatchStateStartedListener( AGG_PlayerMatchStateStarted );

	ScoreBoardHelper::Init( _AGG_BuildScoreboardStringCB );

	for( int i = 0; i < maxClients; i++ )
		@aggPlayerList[i] = Player(i);

	AGG_PlayerInitWeapon();
}

void AGG_PlayerInitWeapon()
{
	Weapon[] COPYME = {
	Weapon( WEAP_INSTAGUN, 0 ),
	Weapon( WEAP_NONE, 0 ),
	Weapon( WEAP_GRENADELAUNCHER, 1 ),
	//Weapon( WEAP_NONE, 0 ),
	Weapon( WEAP_ROCKETLAUNCHER, 0 ),
	//Weapon( WEAP_NONE, 0 ),
	Weapon( WEAP_NONE, 0 ),
	Weapon( WEAP_PLASMAGUN, 100 ),
	//Weapon( WEAP_NONE, 0 ),
	Weapon( WEAP_NONE, 0 ),
	Weapon( WEAP_LASERGUN, 100 ),
	//Weapon( WEAP_NONE, 0 ),
	Weapon( WEAP_NONE, 0 ),
	Weapon( WEAP_NONE, 0 ),
	Weapon( WEAP_MACHINEGUN, 70 ),
	//Weapon( WEAP_NONE, 0 ),
	//Weapon( WEAP_NONE, 0 ),
	//Weapon( WEAP_NONE, 0 ),
	Weapon( WEAP_NONE, 0 ),
	Weapon( WEAP_NONE, 0 ),
	Weapon( WEAP_RIOTGUN, 7 ) };
	AGG_WEAPORDER = COPYME;
}

void AGG_PlayerScoreEvent( Client @client, String &score_event, String &args )
{
	if( score_event == "kill" )
	{
        int tar = args.getToken( 0 ).toInt();
        int inflictor = args.getToken( 1 ).toInt();
        int mod = args.getToken( 2 ).toInt();

        Player @attacker = @AGG_GetPlayer( client );
        Player @target = @AGG_GetPlayer( G_GetEntity( tar ) );

        if( @attacker != null && @attacker != @target )
			attacker.killedPlayer( target );
		else if( @attacker != null )
			attacker.selfkill();
		if( @target != null )
			target.died( attacker );
	}
	else if( score_event == "enterGame" )
	{
		Player @player = @AGG_GetPlayer( client );
		if( @player != null )
			player.reset();
	}
}

void AGG_PlayerRespawn( Entity @ent, int old_team, int new_team )
{
	Player @dude = @AGG_GetPlayer( ent );
	if( @dude == null )
		return;

	if( old_team != new_team )
	{
		if( new_team == TEAM_PLAYERS )
			dude.joinedTeam();
		else if( new_team == TEAM_SPECTATOR )
			dude.leftTeam();
	}
	else
		dude.respawned();
}

void AGG_PlayerThink()
{
	for( int i = 0; i < maxClients; i++ )
		AGG_GetPlayer( i ).think();
}

void AGG_PlayerMatchStateStarted()
{
	for( int i = 0; i < maxClients; i++ )
		AGG_GetPlayer( i ).newMatchState( match.getState() );
}

String _AGG_BuildScoreboardStringCB( Entity @ent )
{
	if( @ent == null || @ent.client == null || ent.team == TEAM_SPECTATOR || ent.client.state() < CS_SPAWNED )
		return "";

	if( @AGG_GetPlayer( ent ) == null )
		return "";
	else
		return AGG_GetPlayer( ent ).scoreboardString;
}
