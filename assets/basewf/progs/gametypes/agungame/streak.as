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
Contributors:
	Jonas "Jonsen" Vothknecht
*/

/*
This file depends on wf-scriptutils:
	functioncallcenter.as

*/

const uint KS_NADEREFILL_AMOUNT = 5;
const uint KS_NADEREFILL_INTERVAL = 5;

const uint DS_PROTECTION_STREAKAMOUNT = 3;
const uint DS_PROTECTION_WEAPONTIME = 1; // Time until you get your weapon back in sec AND noobprotection time
const uint DS_PROTECTION_MAXTIME = 7;
const uint DS_MARTYRIUM_STREAKAMOUNT = 6;
const uint DS_SPEEDINCREMENT_STREAKAMOUNT = 8;
const uint DS_SPEEDINCREMENT_BASICSPEED = 360;
const uint DS_SPEEDINCREMENT_MAXSPEED = 390;

class Streak
{
	Player @m_player;

	Streak( Player @inPlayer )
	{
		@m_player = @inPlayer;
	}

	void handleStreak( int streakAmount )
	{
	}

	void respawn()
	{
	}
}

// ====================================
// Killstreaks
// ====================================

class KillStreakGrenadeRefill : Streak
{
	KillStreakGrenadeRefill( Player @inPlayer )
	{
		super( inPlayer );
	}

	void handleStreak( int streakAmount ) override
	{
		if ( streakAmount >= KS_NADEREFILL_AMOUNT && ( streakAmount - KS_NADEREFILL_AMOUNT ) % KS_NADEREFILL_INTERVAL == 0 )
		{
			Client @client = @m_player.client;
			if( client.inventoryCount( AMMO_GRENADES ) > 0 )
				return;
			client.inventorySetCount( AMMO_GRENADES, 1 );
			m_player.silentAward( S_COLOR_BLUE + "Grenade refilled!" );
		}
	}
}

// ====================================
// Deathstreaks
// ====================================


class DeathStreakProtection : Streak
{
	uint protectionTime;

	DeathStreakProtection( Player @inPlayer )
	{
		protectionTime = 0;
		super( inPlayer );
	}

	void handleStreak( int streakAmount ) // TODO: we need to take the weapon away to give it back later
	{
		if ( streakAmount >= DS_PROTECTION_STREAKAMOUNT )
		{
			protectionTime = int( streakAmount / 5 ) + 2;
			if ( protectionTime > DS_PROTECTION_MAXTIME )
                protectionTime = DS_PROTECTION_MAXTIME;
		}
		else
		{
			protectionTime = DS_PROTECTION_WEAPONTIME;
		}
	}

	void callbackProtection()
	{
		m_player.client.inventorySetCount( POWERUP_SHELL, 0 );
	}

	void callbackWeapon()
	{
		m_player.client.pmoveFeatures = m_player.client.pmoveFeatures | uint(PMFEAT_WEAPONSWITCH);
		m_player.client.selectWeapon( -1 );
	}

	void respawn()
	{
		if ( protectionTime > 0 )
		{
			m_player.client.inventorySetCount( POWERUP_SHELL, protectionTime + 999 ); // +1 so it doesn't stop before the callback
			m_player.client.pmoveFeatures = m_player.client.pmoveFeatures & ~uint(PMFEAT_WEAPONSWITCH);
			m_player.client.selectWeapon( WEAP_NONE );
			FunctionCallCenter::SetTimeoutArg( _StopDeathStreakProtection, protectionTime * 1000 + 250, any(@this) );
			FunctionCallCenter::SetTimeoutArg( _GiveWeapon, DS_PROTECTION_WEAPONTIME * 1000, any(@this) );
			protectionTime = 0;
		}
	}
}

void _StopDeathStreakProtection( any &arg )
{
	DeathStreakProtection @streak;
	arg.retrieve( @streak );
	if( @streak == null )
		return;
	streak.callbackProtection();
}

void _GiveWeapon( any &arg )
{
	DeathStreakProtection @streak;
	arg.retrieve( @streak );
	if( @streak == null )
		return;
	streak.callbackWeapon();
}

// -----------------------------------------------------

class DeathStreakMartyrium : Streak
{
	DeathStreakMartyrium( Player @inPlayer )
	{
		super( inPlayer );
	}

	void handleStreak( int streakAmount ) override
	{
		if ( streakAmount >= DS_MARTYRIUM_STREAKAMOUNT )
		{
			Entity @nade = G_FireGrenade( m_player.entity.origin,  Vec3( 0, 0, 0 ), 0, 150, 65, 100, 1250, m_player.entity );
			nade.classname = "martyrium";
			nade.nextThink = levelTime + 750;
			m_player.silentAward( S_COLOR_BLUE + "Martyrium" );
		}
	}
}

// -----------------------------------------------------

class DeathStreakSpeedIncrement : Streak
{

	bool hasSpeedIncrement;
	uint speed;

	DeathStreakSpeedIncrement( Player @inPlayer )
	{
		super( inPlayer );
		hasSpeedIncrement = false;
		speed = 0;
	}

	void handleStreak( int streakAmount ) override
	{
		if ( streakAmount >= DS_SPEEDINCREMENT_STREAKAMOUNT )
		{
			hasSpeedIncrement = true;
			speed = DS_SPEEDINCREMENT_BASICSPEED + (( streakAmount - DS_SPEEDINCREMENT_STREAKAMOUNT ) * 5 );
			if ( speed > DS_SPEEDINCREMENT_MAXSPEED )
				speed = DS_SPEEDINCREMENT_MAXSPEED;
		}
		else
		{
			hasSpeedIncrement = false;
			speed = 0;
		}
	}

	void respawn()
	{
		if ( hasSpeedIncrement )
		{
			m_player.client.pmoveMaxSpeed = speed ;
			G_PrintMsg( m_player.entity, "Your speed was increased by " + ( speed - 320 ) + "\n" );
		}
	}
}
