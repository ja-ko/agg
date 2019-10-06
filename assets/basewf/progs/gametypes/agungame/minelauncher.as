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
	functioncallcenter.as
*/


const int MS_WAITINIT = 0;
const int MS_THROWN = 1;
const int MS_SEARCHING = 2;
const int MS_EJECTING = 3;
const int MS_CHASING = 4;
const int MS_WAITFREE = 5;

const float MINE_ACTIVATIONRADIUS = 350.0f;
const int MINE_EJECTDURATION = 100;
const int MINE_EJECTVELOCITY = 800;
const float MINE_CHASEVELOCITY = 1000.0f;
const float MINE_ACCELERATION = 2000.0f;
const float MINE_EXPLOSIONRADIUS = 100.0f;
const int MINE_EXPLOSIONDAMAGE = 9999;

const uint MINE_PINGPONGTIME = 100;

array<Mine@> aggMines;

class Mine
{
	Entity @mine;
	Entity @target;
	int state;
	Entity @owner;

	uint launchTime;

	Vec3 ejectDirection;

	uint landTime;
	bool pingpong;

	Mine( Entity @nade )
	{
		if( @nade == null )
			return;
		@mine = @nade;
		@owner = @mine.owner;
		state = MS_WAITINIT;
		ejectDirection = vec3Origin;
		landTime = 0;
		pingpong = false;
		if( mine.classname == "grenade" )
			convertNade();
		else if( mine.classname == "mine" )
			state = MS_SEARCHING;

		mine.allowFunctionOverride = false;
		@mine.think = @__MineThink;
		@mine.die = @__MineDie;
		@mine.touch = @__MineTouch;

		mine.nextThink = levelTime + 1;
		aggMines.insertLast( this );
	}

	~Mine()
	{
		free();
	}

	void convertNade()
	{
		mine.classname = "mine";
		mine.modelindex = G_ModelIndex( "models/objects/projectile/glauncher/grenadeweak.md3" );
		mine.avelocity = Vec3( 700, 700, 700 ) * ( ( random() > 0.5f ) ? 1.0f : -1.0f ) + Vec3( brandom(-200,200), brandom(-200,200), brandom(-200,200) );

		state = MS_THROWN;
	}

	void landed( Vec3 surfaceNormal )
	{
		mine.takeDamage = DAMAGE_YES;
		mine.health = 100;
		mine.avelocity = vec3Origin;

		mine.moveType = MOVETYPE_NONE;

		ejectDirection = surfaceNormal;
		landTime = levelTime;

		Vec3 tmp = surfaceNormal.toAngles();
		tmp.x += 90;
		mine.angles = tmp;

		state = MS_SEARCHING;
		mine.nextThink = levelTime + 1;
	}

	void search()
	{
		array<Entity @> @playerList = @G_FindInRadius( mine.origin, MINE_ACTIVATIONRADIUS );
		for( uint i = 0; i < playerList.length; i++ )
		{
			Entity @player = @playerList[i];

			if( @player == null || @player.client == null )
                continue;

			if( player.client.state() < CS_SPAWNED || player.team == TEAM_SPECTATOR || player.isGhosting() || @player == @owner )
				continue;

			Trace tr;
			if( !tr.doTrace( mine.origin, vec3Origin, vec3Origin, player.origin, player.entNum, MASK_SOLID ) )
			{
				@target = @player;
				startEject();
			}
		}
		if( @target == null )
			mine.nextThink = levelTime + 1;
	}

	void startEject()
	{
		state = MS_EJECTING;
		mine.takeDamage = DAMAGE_NO;
		mine.moveType = MOVETYPE_FLY;

		// mine.modelindex = somethingelse;
		G_PositionedSound( mine.origin, CHAN_MUZZLEFLASH, G_SoundIndex( "sounds/misc/timer_bip_bip.wav" ), ATTN_NORM );
		if( ejectDirection != vec3Origin )
		{
			mine.velocity = ejectDirection * MINE_EJECTVELOCITY;
		}

		if( landTime + MINE_PINGPONGTIME >= levelTime )
			pingpong = true;

		mine.nextThink = levelTime + MINE_EJECTDURATION;
	}

	void ejectDone()
	{
		state = MS_CHASING;
		launchTime = levelTime;

		mine.nextThink = levelTime + 1;
	}

	void chase()
	{
		Vec3 dir = target.origin - mine.origin;
		dir.normalize();
		mine.angles = dir.toAngles() + Vec3( 90, 0, 0);
		dir *= ( MINE_CHASEVELOCITY + MINE_ACCELERATION * ( float( levelTime - launchTime ) / 1000.0f ) );
		mine.velocity = dir;
		mine.nextThink = levelTime + 1;
	}

	void explode()
	{
		state = MS_WAITFREE;
		if( @mine == null )
			return;
		mine.explosionEffect( MINE_EXPLOSIONRADIUS );
		mine.splashDamage( owner, MINE_EXPLOSIONRADIUS, MINE_EXPLOSIONDAMAGE, 0, 0, MOD_GRENADE_W );

		if( pingpong )
			AGG_SilentAward( owner.client, S_COLOR_CYAN + "Ping Pong!" );

		mine.nextThink = levelTime + 1;
	}

	void free()
	{
		if( @mine != null )
			mine.freeEntity();
		@mine = null;
		if( aggMines.find( this ) >= 0 )
			aggMines.removeAt( aggMines.find( this ) );
	}

	void think()
	{
		switch( state )
		{
		case MS_WAITINIT: // should be initialized already, something went wrong. kill it with fire
		case MS_WAITFREE:
			free();
			break;
		case MS_SEARCHING:
			search();
			break;
		case MS_EJECTING:
			ejectDone();
			break;
		case MS_CHASING:
			chase();
			break;
		}
	}

	void die()
	{
		explode();
	}

	void touch( Entity @other, const Vec3 planeNormal, int surfFlags )
	{
		if( state == MS_THROWN && @other.client == null )
			landed( planeNormal );
		else if( state == MS_THROWN && @other.client != null )
		{
			AGG_SilentAward( owner.client, S_COLOR_ORANGE + "In da Face!" );
			explode();
		}
		else if( state > MS_SEARCHING && state != MS_WAITFREE )
			explode();
	}

	bool opEquals( Mine @input )
	{
        if( @input == null )
            return false;
        return mine is input.mine;
	}
}

void AGG_MineInit()
{
	FunctionCallCenter::SetInterval( AGG_MineLauncherSearchNades, 1 );
	FunctionCallCenter::RegisterScoreEventListener( AGG_MineHandleScoreEvent );
	FunctionCallCenter::RegisterMatchStateStartedListener( AGG_MineHandleMatchStateStarted );
}


bool AGG_MineLauncherSearchNades()
{
	array<Entity @> @nades = @G_FindByClassname( "grenade" );
	for( uint i = 0; i < nades.length; i++ )
	{
        Entity @nade = @nades[i];
		Mine( nade );
	}
	return true;
}

Mine @AGG_FindMine( Entity @ent )
{
	for( uint i = 0; i < aggMines.length; i++ )
	{
		if( @aggMines[i] == null )
			continue;
		if( @aggMines[i].mine == @ent )
			return aggMines[i];
	}
	return null;
}

void AGG_MineRemoveForClient( Client @owner )
{
	for( uint i = 0; i < aggMines.length; i++ )
	{
		if( @aggMines[i] == null )
			continue;
		if( @aggMines[i].owner.client == @owner && aggMines[i].state <= MS_SEARCHING )
			aggMines[i].free();
	}
}

void AGG_MineHandleScoreEvent( Client @client, String &score_event, String &args )
{
	if( score_event == "kill" )
	{
		int tar = args.getToken( 0 ).toInt();
		Entity @target = @G_GetEntity( tar );
		if( @target == null || @target.client == null )
			return;
		AGG_MineRemoveForClient( target.client );
	}
	else if( score_event == "disconnect" )
		AGG_MineRemoveForClient( client );
}

void AGG_MineHandleRespawn( Entity @ent, int old_team, int new_team )
{
	// no matter what happened, respawn means ent should be removed
	AGG_MineRemoveForClient( ent.client );
}

void AGG_MineHandleMatchStateStarted()
{
	for( int i = 0; i < maxClients; i++ )
		AGG_MineRemoveForClient( G_GetClient(i) );
}

void __MineThink( Entity @ent )
{
	Mine @mine = @AGG_FindMine( ent );
	if( @mine != null )
		mine.think();
}

void __MineTouch(Entity @ent, Entity @other, const Vec3 planeNormal, int surfFlags)
{
	Mine @mine = @AGG_FindMine( ent );
	if( @mine != null )
		mine.touch( other, planeNormal, surfFlags );
}

void __MineDie(Entity @ent, Entity @inflicter, Entity @attacker)
{
	Mine @mine = @AGG_FindMine( ent );
	if( @mine != null )
		mine.die();
}
