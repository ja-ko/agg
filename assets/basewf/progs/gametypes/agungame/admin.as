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
	achievementcenter.as
*/

namespace Admin
{
	namespace Permission
	{
		namespace Appoint
		{
			const int SUPERADMIN = 0x1;
			const int ADMIN = 0x2;
			const int MODERATOR = 0x4;
		}

		namespace Dismiss
		{
			const int ADMIN = 0x10;
			const int MODERATOR = 0x20;
		}

		const int CHANGEPWOTHER = 0x100;

		const int KICK = 0x1000;
		const int BAN = 0x2000;
		const int MUTE = 0x4000;
		const int UNMUTE = 0x8000;
		const int OPERATOR = 0x10000;
		const int CHANGEMAP = 0x100000;
		const int QUIT = 0x200000;
		const int RCON = 0x400000;

		const uint ALL = 0xFFFFFFFF;
	}

	namespace Priority
	{
		const int SUPERADMIN = 3; // magic int
		const int ADMIN = 2;
		const int MODERATOR = 1;
	}

	namespace Identifier
	{
		const String SUPERADMIN = "rank:superadmin";
		const String ADMIN = "rank:admin";
		const String MODERATOR = "rank:moderator";
	}


	void Auth( Client @admin, String password )
	{
		UpdateScoreboardRanks( admin );
		AchievementMeta @meta = @BestEnabledAchievement( admin );
		if( @meta == null )
			return; // show notadmin dialog
		if( Admin::AchievementAccess::ValidatePassword( meta, password ) )
		{
			::G_Print( "Admin::Auth: " + admin.name + " authed successfully as " + meta.identifier + "\n" );
			return; // show admin dialog
		}
		else
		{
			::G_Print( "Admin::Auth: " + admin.name + " failed auth as " + meta.identifier + "\n" );
			return; // show wrong pw dialog
		}
	}

	void AppointClient( Client @admin, Client @target, String adminRank )
	{
		// permissions are checked in HandleCommand, just do it here
		PlayerAchievementCenter @ac = @AchievementCenter::ac_playerCenter[target.playerNum];
		if( !ac.isActive )
			return;
		array<AchievementMeta@>@ meta = @ac.metaAchievements;
		if( @meta == null || meta.length == 0 )
			return;

		for( uint i = 0; i < meta.length; i++ )
		{
			if( @meta[i] == null )
				continue;
			if( Admin::AchievementAccess::IsValid( meta[i] ) )
			{
				Admin::AchievementAccess::SetAuthed( meta[i], false );
				meta[i].enabled = false; // you can only have one admintype
			}
			if( meta[i].identifier == adminRank )
			{
				meta[i].enabled = true;
			}
		}

		::G_Print( "Admin::AppointClient: " + admin.name + " advanced " + target.name + " to the rank " + adminRank + "\n" );

		UpdateScoreboardRanks( target );
	}

	void DismissClient( Client @admin, Client @target )
	{
		// permissions are checked in HandleCommand, just do it here
		PlayerAchievementCenter @ac = @AchievementCenter::ac_playerCenter[target.playerNum];
		if( !ac.isActive )
			return;
		array<AchievementMeta@>@ meta = @ac.metaAchievements;
		if( @meta == null || meta.length == 0 )
			return;

		for( uint i = 0; i < meta.length; i++ )
		{
			if( @meta[i] == null )
				continue;
			if( Admin::AchievementAccess::IsValid( meta[i] ) )
			{
				meta[i].enabled = false;
				Admin::AchievementAccess::SetAuthed( meta[i], false );
				::G_Print( "Admin::DismissClient: " + admin.name + " dismissed " + target.name + " from the rank " + meta[i].identifier + "\n" );
			}
		}

		UpdateScoreboardRanks( target );

		// show done dialog
		// inform everyone
	}

	void ChangePWOther( Client @admin, Client @target, String newPw )
	{
		// permissions are checked in HandleCommand, just do it here
		AchievementMeta @meta = @BestEnabledAchievement( target );
		Admin::AchievementAccess::SetPassword( meta, newPw );
		::G_Print( "Admin::ChangePWOther: " + admin.name + " changed " + target.name + "'s password\n" );
	}

	void ChangePWSelf( Client @admin, String newPw )
	{
		// ChangePWSelf has no permission, and cant be checked via HasPermission
		// We need to check whether the client is logged in manually
		AchievementMeta @meta = @BestEnabledAchievement( admin );
		if( !Admin::AchievementAccess::IsAuthed( meta ) )
			return;
		Admin::AchievementAccess::SetPassword( meta, newPw );
		::G_Print( "Admin::ChangePWSelf: " + admin.name + " changed his own password\n" );
	}

	void KickPlayer( Client @admin, Client @target, String message )
	{
		if( @target == null )
			return;
		::G_PrintMsg( null, admin.name + " has kicked " + target.name + ". Reason: " + message + "\n" );
		target.dropClient( message );
		::G_Print( "Admin::KickPlayer: " + admin.name + " kicked " + target.name + " with reason: " + message + "\n" );
	}

	void BanPlayer( Client @admin, Client @target, String message )
	{
		if( @target == null )
			return;
		::G_CmdExecute( "addip " + target.getUserInfoKey( "ip" ) + "\n" );
		::G_PrintMsg( null, admin.name + " has banned " + target.name + ". Reason: " + message + "\n" );
		target.dropClient( message );
		::G_Print( "Admin::BanPlayer: " + admin.name + " banned " + target.name + " with reason: " + message + "\n" );
	}

	void MutePlayer( Client @admin, Client @target )
	{
		if( @target == null )
			return;
		target.muted |= ( 1 | 2 );
		::G_PrintMsg( null, admin.name + " has muted " + target.name + "\n" );
		::G_Print( "Admin::MutePlayer: " + admin.name + " muted " + target.name + "\n" );
	}

	void UnmutePlayer( Client @admin, Client @target )
	{
		if( @target == null )
			return;
		target.muted = 0;
		::G_PrintMsg( null, admin.name + " has unmuted " + target.name + "\n" );
		::G_Print( "Admin::UnmutePlayer: " + admin.name + " unmuted " + target.name + "\n" );
	}

	void MakeOperator( Client @admin )
	{
		if( @admin == null )
			return;

		admin.isOperator = true;
		::G_PrintMsg( null, admin.name + " is now an operator\n" );
		::G_Print( "Admin::MakeOperator: " + admin.name + " is now an operator\n" );
	}

	void ServerChangeMap( Client @admin, String map )
	{
		if( map == "" || changeMapSecs > 0 )
			return;
		::G_PrintMsg( null, admin.name + " commissioned a new map: " + map + "\n" );
		::G_Print( "Admin::ServerChangeMap: " + admin.name + " changed the map to " + map + "\n" );
		changeMapSecs = 5;
		FunctionCallCenter::SetInterval( __changeMapCountdown, 1000 );
		FunctionCallCenter::SetTimeoutArg( __changeMap, changeMapSecs * 1000 + 1000, any(map) );
	}

	int changeMapSecs = 0;
	bool __changeMapCountdown()
	{
		if( changeMapSecs <= 0 )
			return false;
		::G_PrintMsg( null, "Mapchange in " + changeMapSecs + " seconds...\n" );
		changeMapSecs--;
		return true;
	}

	void __changeMap( any & arg )
	{
		String @map;
		arg.retrieve( @map );
		if( @map == null )
			return;
		::G_CmdExecute( "map " + map + "\n" );
	}

	int restartSecs = 0;
	void ServerRestart( Client @admin, String reason )
	{
		if( restartSecs > 0 )
			return;
		restartSecs = 5;
		::G_PrintMsg( null, admin.name + " commissioned a restart: " + reason + "\n" );
		::G_PrintMsg( null, "The interface will say \"server quit\", please just press the reconnect button.\n" );
		FunctionCallCenter::SetTimeout( __restartStartCountdown, 5000 );
	}

	void __restartStartCountdown()
	{
		FunctionCallCenter::SetInterval( __restartCountdown, 1000 );
		FunctionCallCenter::SetTimeout( __restart, restartSecs * 1000 + 1000 );
	}

	bool __restartCountdown()
	{
		if( restartSecs <= 0 )
			return false;
		::G_PrintMsg( null, "Restart in " + restartSecs + " seconds...\n" );
		restartSecs--;
		return true;
	}

	void __restart()
	{
		::G_CmdExecute( "quit\n" );
	}

	void ServerRcon( Client @admin, String cmd )
	{
		::G_CmdExecute( cmd + "\n" );
		// show done dialog
	}

	bool HandleClientCommand( Client @client, String &cmdString, String &argsString, int argc )
	{
		if( @client == null || cmdString != "gtadmin" )
			return false;

		String func = argsString.getToken(0);

		if( func == "auth" )
			Auth( client, argsString.getToken(1) );
		else if( func == "appoint" )
		{
			Client @tar = @::G_GetClient( argsString.getToken(1).toInt() );
			if( @tar == null || @client == @tar )
				return true;
			String rank = argsString.getToken(2);
			int permission = 0;

			if( rank == Admin::Identifier::SUPERADMIN )
				permission = Admin::Permission::Appoint::SUPERADMIN;
			else if( rank == Admin::Identifier::ADMIN )
				permission = Admin::Permission::Appoint::ADMIN;
			else if( rank == Admin::Identifier::MODERATOR )
				permission = Admin::Permission::Appoint::MODERATOR;
			else
				return true;

			if( permission != 0 && HasPermission( client, permission ) && CompareClients( client, tar ) > 0 )
				AppointClient( client, tar, rank );
		}
		else if( func == "dismiss" )
		{
			Client @tar = @::G_GetClient( argsString.getToken(1).toInt() );
			if( @tar == null || @client == @tar )
				return true;
			AchievementMeta @best = @BestEnabledAchievement( tar );
			String rank = ( @best != null ? best.identifier : "" );
			int permission = 0;

			if( rank == Admin::Identifier::ADMIN )
				permission = Admin::Permission::Dismiss::ADMIN;
			else if( rank == Admin::Identifier::MODERATOR )
				permission = Admin::Permission::Dismiss::MODERATOR;
			else
				return true;

			if( permission != 0 && HasPermission( client, permission ) && CompareClients( client, tar ) > 0 )
				DismissClient( client, tar );
		}
		else if( func == "changepwother" )
		{
			Client @tar = @::G_GetClient( argsString.getToken(1).toInt() );
			if( @tar == null )
				return true;
			String pw = argsString.getToken(2);
			if( pw.len() <= 5 || pw.len() > 20 )
				return true;
			int permission = Admin::Permission::CHANGEPWOTHER;
			if( HasPermission( client, permission ) && CompareClients( client, tar ) > 0 )
				ChangePWOther( client, tar, pw );
		}
		else if( func == "changepwself" )
		{
			String pw = argsString.getToken(1);
			if( pw.len() <= 5 || pw.len() > 20 )
				return true;
			ChangePWSelf( client, pw );
		}
		else if( func == "kick" )
		{
			Client @tar = @::G_GetClient( argsString.getToken(1).toInt() );
			if( @tar == null )
				return true;
			String reason = argsString.getToken(2);
			if( reason.len() <= 0 )
				return true;
			int permission = Admin::Permission::KICK;
			if( HasPermission( client, permission ) && CompareClients( client, tar ) > 0 )
				KickPlayer( client, tar, reason );
		}
		else if( func == "ban" )
		{
			Client @tar = @::G_GetClient( argsString.getToken(1).toInt() );
			if( @tar == null )
				return true;
			String reason = argsString.getToken(2);
			if( reason.len() <= 0 )
				return true;
			int permission = Admin::Permission::BAN;
			if( HasPermission( client, permission ) && CompareClients( client, tar ) > 0 )
				BanPlayer( client, tar, reason );
		}
		else if( func == "mute" )
		{
			Client @tar = @::G_GetClient( argsString.getToken(1).toInt() );
			if( @tar == null )
				return true;
			int permission = Admin::Permission::MUTE;
			if( HasPermission( client, permission ) && CompareClients( client, tar ) > 0 )
				MutePlayer( client, tar );
		}
		else if( func == "unmute" )
		{
			Client @tar = @::G_GetClient( argsString.getToken(1).toInt() );
			if( @tar == null )
				return true;
			int permission = Admin::Permission::UNMUTE;
			if( HasPermission( client, permission ) && CompareClients( client, tar ) > 0 )
				UnmutePlayer( client, tar );
		}
		else if( func == "op" )
		{
			int permission = Admin::Permission::OPERATOR;
			if( HasPermission( client, permission ) )
				MakeOperator( client );
		}
		else if( func == "map" )
		{
			String map = argsString.getToken(1);
			if( map.len() <= 0 && !::ML_FilenameExists( map ) )
				return true;
			int permission = Admin::Permission::CHANGEMAP;
			if( HasPermission( client, permission ) )
				ServerChangeMap( client, map );
		}
		else if( func == "restart" )
		{
			String reason = argsString.getToken(1);
			int permission = Admin::Permission::QUIT;
			if( HasPermission( client, permission ) )
				ServerRestart( client, reason );
		}
		else if( func == "rcon" )
		{
			String cmd = argsString.getToken(1);
			if( cmd.len() <= 0 )
				return true;
			int permission = Admin::Permission::RCON;
			if( HasPermission( client, permission ) )
				ServerRcon( client, cmd );
		}
		else if( func == "ui" )
		{
			::AGG_InterfaceShowAdmin( client );
		}
		return true;
	}

	bool HasPermission( Client @client, int permission )
	{
		if( @client == null )
			return false;

		PlayerAchievementCenter @ac = @AchievementCenter::ac_playerCenter[client.playerNum];
		array<AchievementMeta@>@ meta = @ac.metaAchievements;
		if( @meta == null || meta.length == 0 )
			return false;

		for( uint i = 0; i < meta.length; i++ )
		{
			if( @meta[i] != null && meta[i].enabled && Admin::AchievementAccess::IsValid( meta[i] ) && Admin::AchievementAccess::IsAuthed( meta[i] ) )
			{
				if( Admin::AchievementAccess::HasPermission( meta[i], permission ) )
					return true;
			}
		}
		return false;
	}

	int CompareClients( Client @first, Client @second )
	{
		if( @first == @second )
			return 0;
		if( @first == null )
			return -1;
		if( @second == null )
			return 1;

		AchievementMeta @firstBest = BestEnabledAchievement( first );
		AchievementMeta @secondBest = BestEnabledAchievement( second );

		if( @firstBest == null || !Admin::AchievementAccess::IsValid( firstBest ) )
			return -1;
		else if( @secondBest == null || !Admin::AchievementAccess::IsValid( secondBest ) )
			return 1;

		return Admin::AchievementAccess::GetPriority( firstBest ) - Admin::AchievementAccess::GetPriority( secondBest );
	}

	AchievementMeta@ BestEnabledAchievement( Client @client )
	{
		if( @client == null )
			return null;

		if( !AchievementCenter::IsActive( client ) )
			return null;

		PlayerAchievementCenter @ac = @AchievementCenter::ac_playerCenter[client.playerNum];
		array<AchievementMeta@>@ meta = @ac.metaAchievements;
		if( @meta == null || meta.length == 0 )
			return null;

		AchievementMeta @best = null;

		for( uint i = 0; i < meta.length; i++ )
		{
			if( @meta[i] != null && meta[i].enabled && Admin::AchievementAccess::IsValid( meta[i] ) )
			{
				if( @best == null || Admin::AchievementAccess::GetPriority( meta[i] ) > Admin::AchievementAccess::GetPriority( best ) )
					@best = @meta[i];
			}
		}
		return best;
	}

	void UpdateScoreboardRanks( Client @client )
	{
		if( @client == null )
			return;

		PlayerAchievementCenter @ac = @AchievementCenter::ac_playerCenter[client.playerNum];
		array<AchievementScoreboard@>@ scoreboard = @ac.scoreboardAchievements;
		if( @scoreboard == null || scoreboard.length == 0 )
			return;

		AchievementMeta @meta = @BestEnabledAchievement( client );
		String scoreboardIdentifier = "";
		if( @meta != null && meta.identifier == Admin::Identifier::SUPERADMIN )
			scoreboardIdentifier = "scoreboard:admin";
		if( @meta != null && meta.identifier == Admin::Identifier::ADMIN )
			scoreboardIdentifier = "scoreboard:admin";
		if( @meta != null && meta.identifier == Admin::Identifier::MODERATOR )
			scoreboardIdentifier = "scoreboard:member";

		for( uint i = 0; i < scoreboard.length; i++ )
		{
			if( @scoreboard[i] == null )
				continue;
			if( scoreboard[i].identifier == "scoreboard:admin" || scoreboard[i].identifier == "scoreboard:member" )
				scoreboard[i].available = ( scoreboardIdentifier == scoreboard[i].identifier );
		}
	}

	void Init()
	{
		// Meta achievements are maintained and managed by achievementcenter, so we don't have to do that much...
		FunctionCallCenter::RegisterCommand( "gtadmin", Admin::HandleClientCommand );
		AchievementCenter::RegisterAchievement( SuperAdmin() );
		AchievementCenter::RegisterAchievement( Admin() );
		AchievementCenter::RegisterAchievement( Moderator() );
	}

	namespace AchievementAccess
	{
		bool IsValid( AchievementMeta @input )
		{
			if( cast<SuperAdmin>(input) !is null )
				return true;
			if( cast<Admin>(input) !is null )
				return true;
			if( cast<Moderator>(input) !is null )
				return true;
			return false;
		}

		int GetPriority( AchievementMeta @input )
		{
			if( cast<SuperAdmin>(input) !is null )
				return cast<SuperAdmin>(input).priority;
			if( cast<Admin>(input) !is null )
				return cast<Admin>(input).priority;
			if( cast<Moderator>(input) !is null )
				return cast<Moderator>(input).priority;
			return 0;
		}

		bool IsAuthed( AchievementMeta @input )
		{
			if( HasNotSetPassword( input ) )
				return true;
			if( cast<SuperAdmin>(input) !is null )
				return cast<SuperAdmin>(input).isAuthed;
			if( cast<Admin>(input) !is null )
				return cast<Admin>(input).isAuthed;
			if( cast<Moderator>(input) !is null )
				return cast<Moderator>(input).isAuthed;
			return false;
		}

		void SetAuthed( AchievementMeta @input, bool authed )
		{
			if( cast<SuperAdmin>(input) !is null )
				cast<SuperAdmin>(input).isAuthed = authed;
			else if( cast<Admin>(input) !is null )
				cast<Admin>(input).isAuthed = authed;
			else if( cast<Moderator>(input) !is null )
				cast<Moderator>(input).isAuthed = authed;
		}

		bool HasPermission( AchievementMeta @input, int permission )
		{
			if( HasNotSetPassword( input ) )
				return false;
			if( cast<SuperAdmin>(input) !is null )
				return cast<SuperAdmin>(input).hasPermission( permission );
			if( cast<Admin>(input) !is null )
				return cast<Admin>(input).hasPermission( permission );
			if( cast<Moderator>(input) !is null )
				return cast<Moderator>(input).hasPermission( permission );
			return false;
		}

		bool ValidatePassword( AchievementMeta @input, String password )
		{
			if( cast<SuperAdmin>(input) !is null )
				return cast<SuperAdmin>(input).validatePassword( password );
			if( cast<Admin>(input) !is null )
				return cast<Admin>(input).validatePassword( password );
			if( cast<Moderator>(input) !is null )
				return cast<Moderator>(input).validatePassword( password );
			return false;
		}

		bool HasNotSetPassword( AchievementMeta @input )
		{
			if( cast<SuperAdmin>(input) !is null )
				return cast<SuperAdmin>(input).password == "";
			if( cast<Admin>(input) !is null )
				return cast<Admin>(input).password == "";
			if( cast<Moderator>(input) !is null )
				return cast<Moderator>(input).password == "";
			return false;
		}

		void SetPassword( AchievementMeta @input, String password )
		{
			if( cast<SuperAdmin>(input) !is null )
				cast<SuperAdmin>(input).password = password;
			else if( cast<Admin>(input) !is null )
				cast<Admin>(input).password = password;
			else if( cast<Moderator>(input) !is null )
				cast<Moderator>(input).password = password;
		}
	}
}

// I would literally pay money to get these mixins...
class SuperAdmin : AchievementMeta
{
	AchievementMeta @copy() override
	{
		SuperAdmin ret;
		ret.identifier = Admin::Identifier::SUPERADMIN;
		ret.isAuthed = false;
		ret.password = "";
		ret.enabled = false;
		ret.priority = Admin::Priority::SUPERADMIN;

		ret.permissions = Admin::Permission::ALL;

		return ret;
	}

	uint permissions;
	String password;
	bool isAuthed;
	int priority;

	bool validatePassword( String pw )
	{
		if( !enabled )
			return false;
		if( password == "" ) // we need to create our first password
			return true;
		if( password == pw )
		{
			isAuthed = true;
			return true;
		}
		else
			isAuthed = false;
		return false;
	}

	bool hasPermission( int perm )
	{
		return ( ( permissions & perm ) != 0 );
	}

	void init( Client @inClient, String serializedData )
	{
		@client = @inClient;
		if( serializedData == "%nopwyet%" )
		{
			enabled = true;
		}
		else if( serializedData != "" )
		{
			enabled = true;
			password = serializedData;
		}
	}

	String shutdown()
	{
		if( enabled && password == "" )
			return "%nopwyet%";
		if( enabled )
			return password;
		return "";
	}
}

// still no mixins? damn it!
class Admin : AchievementMeta
{
	AchievementMeta @copy() override
	{
		Admin ret;
		ret.identifier = Admin::Identifier::ADMIN;
		ret.isAuthed = false;
		ret.password = "";
		ret.enabled = false;
		ret.priority = Admin::Priority::ADMIN;

		ret.permissions = 0;
		ret.permissions |= Admin::Permission::Appoint::ADMIN;
		ret.permissions |= Admin::Permission::Appoint::MODERATOR;
		ret.permissions |= Admin::Permission::Dismiss::MODERATOR;
		ret.permissions |= Admin::Permission::KICK;
		ret.permissions |= Admin::Permission::BAN;
		ret.permissions |= Admin::Permission::MUTE;
		ret.permissions |= Admin::Permission::UNMUTE;
		ret.permissions |= Admin::Permission::OPERATOR;
		ret.permissions |= Admin::Permission::CHANGEMAP;

		return ret;
	}

	uint permissions;
	String password;
	bool isAuthed;
	int priority;

	bool validatePassword( String pw )
	{
		if( !enabled )
			return false;
		if( password == "" ) // we need to create our first password
			return true;
		if( password == pw )
		{
			isAuthed = true;
			return true;
		}
		else
			isAuthed = false;
		return false;
	}

	bool hasPermission( int perm )
	{
		return ( ( permissions & perm ) != 0 );
	}

	void init( Client @inClient, String serializedData )
	{
		@client = @inClient;
		if( serializedData == "%nopwyet%" )
		{
			enabled = true;
		}
		else if( serializedData != "" )
		{
			enabled = true;
			password = serializedData;
		}
	}

	String shutdown()
	{
		if( enabled && password == "" )
			return "%nopwyet%";
		if( enabled )
			return password;
		return "";
	}

}

class Moderator : AchievementMeta
{
	AchievementMeta @copy() override
	{
		Moderator ret;
		ret.identifier = Admin::Identifier::MODERATOR;
		ret.isAuthed = false;
		ret.password = "";
		ret.enabled = false;
		ret.priority = Admin::Priority::MODERATOR;

		ret.permissions = 0;
		ret.permissions |= Admin::Permission::KICK;
		ret.permissions |= Admin::Permission::MUTE;
		ret.permissions |= Admin::Permission::UNMUTE;
		ret.permissions |= Admin::Permission::OPERATOR;

		return ret;
	}

	uint permissions;
	String password;
	bool isAuthed;
	int priority;

	bool validatePassword( String pw )
	{
		if( !enabled )
			return false;
		if( password == "" ) // we need to create our first password
			return true;
		if( password == pw )
		{
			isAuthed = true;
			return true;
		}
		else
			isAuthed = false;
		return false;
	}

	bool hasPermission( int perm )
	{
		return ( ( permissions & perm ) != 0 );
	}

	void init( Client @inClient, String serializedData )
	{
		@client = @inClient;
		if( serializedData == "%nopwyet%" )
		{
			enabled = true;
		}
		else if( serializedData != "" )
		{
			enabled = true;
			password = serializedData;
		}
	}

	String shutdown()
	{
		if( enabled && password == "" )
			return "%nopwyet%";
		if( enabled )
			return password;
		return "";
	}
}

