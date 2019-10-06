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
This file depends onwf-scriptutils:
	functioncallcenter.as
	clientcvar.as
	achievementcenter.as
	admin.as
*/

const String AGG_GAMEMENU_TITLE = "Gamemenu";
const String AGG_GAMEMENU_BUTTON1 = "Agungame options";
const String AGG_GAMEMENU_BUTTON2 = "Achievements";
const String AGG_GAMEMENU_BUTTON3 = "Statistics";
const String AGG_GAMEMENU_BUTTON4 = "Adminpanel";

const String AGG_OPTIONSFILE = "agungame/aggoptions";
const String AGG_STATSFILE = "agungame/statistics";
const String AGG_RATINGFILE = "agungame/aggrating";
const String AGG_FIRSTSTEPSFILE = "agungame/aggfirststeps";
const String AGG_ACHIEVEMENTSFILE = "agungame/achievements";
const String AGG_ADMINFILE = "agungame/admin/main";

bool AGG_ShowGamemenu( Client @client, String &cmdString, String &argsString, int argc )
{
	if( @client == null || client.state() < CS_SPAWNED )
		return true;

	String mecu = "mecu ";

	if( ClientCvar::Get( client, "ui_basepath" ) != "ui/porkui" )
	{
		mecu += "\"At the moment we are unable to support warsow-uis other than the standart porkui. You should use porkui if you want to access more advanced options or statistics\" ";

		if( ClientCvar::Get( client, "cg_agg_autoswitch" ) != "0" )
			mecu += "\"Disable autoswitch\" \"seta cg_agg_autoswitch 0;\" ";
		else
			mecu += "\"Enable autoswitch\" \"seta cg_agg_autoswitch 1;\" ";

		if( AchievementCenter::IsActive( client ) )
			G_AppendToFile( "agungame_custom_uis.txt", AchievementCenter::LoginName( client ) + " - " + ClientCvar::Get( client, "ui_basepath" ) + "\n" );
	}
	else
	{
		mecu += "\"" + AGG_GAMEMENU_TITLE + "\" \"" + AGG_GAMEMENU_BUTTON1 + "\" \"gtoptions;\" \"" + AGG_GAMEMENU_BUTTON2 + "\" \"gtachievements 0 30;\" \"" + AGG_GAMEMENU_BUTTON3 + "\" \"gtstats;\"";

		if( @Admin::BestEnabledAchievement( client ) != null )
			mecu += " \"" + AGG_GAMEMENU_BUTTON4 + "\" \"gtadmin ui;\"";
	}

	client.execGameCommand( mecu );
	return true;
}

bool AGG_GTOptions( Client @client, String &cmdString, String &argsString, int argc )
{
	client.execGameCommand( "cmd menu_open " + AGG_OPTIONSFILE + " available \"" + AchievementCenter::AvailableModels(client) + "\" models \"" + AchievementCenter::AllModels() + "\";\n" );
	return true;
}

bool AGG_GTStats( Client @client, String &cmdString, String &argsString, int argc )
{
	String randomString = random() * float(levelTime) * brandom(1, 10);
	String wmmname = "";

	// AchievementCenter already knows everything about the client, so just use that data
	if( AchievementCenter::IsActive( client ) )
		wmmname = AchievementCenter::LoginName( client );

	client.execGameCommand( "cmd menu_open " + AGG_STATSFILE + " random \"" + randomString + "\" wmmname \"" + wmmname + "\"\n" ); // Not sure if we need a timestamp (idiv nocache=1)
	return true;
}

void AGG_InterfaceShowFirstSteps( Client @client )
{
	if( @client == null )
		return;

	if( client.state() < CS_SPAWNED )
		return; // this should theoretically never be reached

	client.execGameCommand( "cmd menu_open " + AGG_FIRSTSTEPSFILE + ";\n" );
}

void AGG_InterfaceShowRatingRequest( Client @client )
{
	if( @client == null )
		return;

	if( client.state() < CS_SPAWNED )
		return;

	client.execGameCommand( "cmd menu_open " + AGG_RATINGFILE + ";\n" );
}

void AGG_InterfaceShowAdmin( Client @client )
{
	if( @client == null )
		return;

	if( client.state() < CS_SPAWNED )
		return;

	String playerlist = "";
	for( int i = 0; i < maxClients; i++ )
	{
		Client @player = @G_GetClient( i );
		if( player.state() < CS_SPAWNED )
			continue;

		bool active = AchievementCenter::IsActive( player );

		AchievementMeta @admin = @Admin::BestEnabledAchievement( player );
		String name = StringUtils::Replace( player.name, " ", "_" );

		playerlist += i + " " + name + " " + ( @admin == null ? ( active ? "authed" : "none" ) : admin.identifier ) + " " + player.muted + " ";
	}
	if( playerlist.len() > 0 )
		playerlist = playerlist.substr( 0, playerlist.len() - 1 );

	AchievementMeta @own = @Admin::BestEnabledAchievement( client );
	if( @own == null )
		return;

	String ownRank = own.identifier;

	bool authed = Admin::AchievementAccess::IsAuthed( own );
	bool hasNoPw = Admin::AchievementAccess::HasNotSetPassword( own );

	client.execGameCommand( "cmd menu_open " + AGG_ADMINFILE + " authed " + ( hasNoPw ? "2" : ( authed ? "1" : "0" ) ) + " own " + ownRank + " playerlist \"" + playerlist + "\" isOp " + ( client.isOperator ? "1" : "0" ) + ";\n" );
}

void AGG_InterfaceCheckRating( Client @client )
{
	if( @client == null )
		return;

	if( client.state() < CS_SPAWNED )
		return; // this should theoretically never be reached

	String rating = ClientCvar::Get( client, "cg_agg_rating" );
	String dontAsk = ClientCvar::Get( client, "cg_agg_rating_dontask" );
	String ui = ClientCvar::Get( client, "ui_basepath" );

	if( rating == "null" || dontAsk == "null" || ui == "null" )
	{
		FunctionCallCenter::SetTimeoutArg( AGG_InterfaceCheckGamesPlayed, 1500, any(@client) ); // retry later
		return;
	}

	if( rating == "1" || rating == "2" || rating == "3" || rating == "4" || rating == "5" || dontAsk != "0" || ui != "ui/porkui" )
		return;

	AGG_InterfaceShowRatingRequest( client );
}

void AGG_InterfaceCheckGamesPlayed( any & arg )
{
	Client @client = null;
	arg.retrieve( @client );
	if( @client == null ) // something went wrong
		return;

	if( client.state() < CS_CONNECTING ) // client disconnected immediately
		return;

	if( client.state() < CS_SPAWNED ) // client is still connecting
	{
		FunctionCallCenter::SetTimeoutArg( AGG_InterfaceCheckGamesPlayed, 2500, any(@client) ); // retry later
		return;
	}

	String gamesPlayedContent = ClientCvar::Get( client, "cg_agg_gamesplayed" );
	if( gamesPlayedContent == "null" ) // something failed, or data is not up to date yet
	{
		FunctionCallCenter::SetTimeoutArg( AGG_InterfaceCheckGamesPlayed, 2500, any(@client) ); // retry later
		return;
	}


	if( gamesPlayedContent.len() == 0 )
		return;

	if( !gamesPlayedContent.isNumerical() )
		return;

	int gamesPlayed = gamesPlayedContent.toInt();
	if( gamesPlayed == 0 )
		AGG_InterfaceShowFirstSteps( client );
	else if( gamesPlayed > 0 )
		AGG_InterfaceCheckRating( client );

	ClientCvar::Set( client, "cg_agg_gamesplayed", (gamesPlayed + 1) + "" );
}

void AGG_InterfaceHandleScoreEvent( Client @client, String &score_event, String &args )
{
	if( @client != null && score_event == "enterGame" )
		FunctionCallCenter::SetTimeoutArg( AGG_InterfaceCheckGamesPlayed, 2500, any(@client) );
}

// =============================================
// achievements

bool AGG_InterfaceShowAchievements( Client @client, String &cmdString, String &argsString, int argc )
{
	if( @client == null || client.state() < CS_SPAWNED )
		return false;

	String start = argsString.getToken( 0 );
	String count = argsString.getToken( 1 );

	if( start.len() == 0 || count.len() == 0 || !start.isNumerical() || !count.isNumerical() || start.toInt() < 0 || count.toInt() < 0 )
		return true;

	String cmd = "menu_open " + AGG_ACHIEVEMENTSFILE + " ac ";
	String add = AchievementCenter::StandartAchievementsInterfaceString( client, start.toInt(), count.toInt() );
	if( add != "" )
		cmd += "\"" + add + "\"";
	else
		return true;

	client.execGameCommand( "cmd " + cmd + ";" );
	return true;
}

// =============================================
// ratings

int[] ratings(5); // 1 2 3 4 5

void AGG_InterfaceRatingChanged( Client @client, String cvarname, String oldcontent , String newcontent )
{
	if( oldcontent.isNumeric() )
	{
		int oldRating = oldcontent.toInt() - 1;
		if( oldRating >= 0 && oldRating <= 4 )
		{
			if( ratings[oldRating] >= 0 )
				ratings[oldRating]--;
		}
	}
	if( newcontent.isNumeric() )
	{
		int newRating = newcontent.toInt() - 1;
		if( newRating >= 0 && newRating <= 4 )
			ratings[newRating]++;
	}
}

void AGG_InterfaceRatingLoad()
{
	String path = "ratings/agungame.gtr";
	if( !G_FileExists( path ) )
		G_WriteFile( path, "0|0|0|0|0" );
	String file = G_LoadFile( path );
	String@[]@ splitResult = StringUtils::Split( file, "|" );
	bool failed = false;
	failed = failed || ( splitResult.length != 5 );
	if( !failed )
	{
		for( int i = 0; i < 5; i++ )
			failed = failed || splitResult[i].isNumerical();
	}
	if( !failed )
	{
		G_Print( "AGG_InterfaceRatingLoad: Failed to load ratings.\n" );
		return;
	}
	for( int i = 0; i < 5; i++ )
		ratings[i] = splitResult[i].toInt();
}

void AGG_InterfaceRatingSave()
{
	String path = "ratings/agungame.gtr";
	String content = ratings[0] + "|" + ratings[1] + "|" + ratings[2] + "|" + ratings[3] + "|" + ratings[4];
	G_WriteFile( path, content );
}


bool AGG_MapSelectorTest( Client @client, String &cmdString, String &argsString, int argc )
{
	Vec3 mins, maxs;
	CM_MapBounds( mins, maxs );

	//we need a square box, images are square as well
	Vec3 diff = maxs - mins;

	if( diff.y > diff.x )
	{
		mins.x -= ( diff.y - diff.x ) * 0.5;
		maxs.x += ( diff.y - diff.x ) * 0.5;
	}
	else
	{
		mins.y -= ( diff.x - diff.y ) * 0.5;
		maxs.y += ( diff.x - diff.y ) * 0.5;
	}
	G_Print( "mins: " + mins.x + " " + mins.y + " " + mins.z + " maxs: " + maxs.x + " " + maxs.y + " " + maxs.z + "\n" );

	float width = maxs.x - mins.x;
	float height = maxs.y - mins.y; // 2d height, not upwards... don't be confused! :)

	Vec3 origin = client.getEnt().origin;

	G_Print( "origin: " + origin.x + " " + origin.y + " " + origin.z + "\n" );
	G_Print( "height: " + height + "\n" );
	G_Print( "width: " + width + "\n" );

	double x = ( origin.x - mins.x ) / width;
	double y = 1 - ( ( origin.y - mins.y ) ) / height;

	G_Print( "x: " + x + "\n" );
	G_Print( "y: " + y + "\n" );

	client.execGameCommand( "cmd menu_open " + "agungame/maplocation" + " cmd \"say\" own \"" + x + " " + y + "\";\n" );
	return true;
}


// =============================================
// Init

void AGG_InterfaceInit()
{
	FunctionCallCenter::RegisterCommand( "gametypemenu", AGG_ShowGamemenu );
	FunctionCallCenter::RegisterCommand( "gtoptions", AGG_GTOptions );
	FunctionCallCenter::RegisterCommand( "gtstats", AGG_GTStats );
	FunctionCallCenter::RegisterCommand( "mapselector", AGG_MapSelectorTest );

	FunctionCallCenter::RegisterScoreEventListener( AGG_InterfaceHandleScoreEvent );

	FunctionCallCenter::RegisterCommand( "gtachievements", AGG_InterfaceShowAchievements );

	AGG_InterfaceRatingLoad();
	FunctionCallCenter::RegisterGametypeShutdownListener( AGG_InterfaceRatingSave );

	ClientCvar::Register( "cg_agg_rating", "-" );
	ClientCvar::Register( "cg_agg_gamesplayed", "0" );
	ClientCvar::Register( "cg_agg_rating_dontask", "0" );

	ClientCvar::Register( "ui_basepath", "ui/porkui" );

	ClientCvar::RegisterChangeCallback( "cg_agg_rating", AGG_InterfaceRatingChanged );

	G_PureFile( "ui/porkui/" + AGG_OPTIONSFILE + ".rml" );
	G_PureFile( "ui/porkui/" + AGG_STATSFILE + ".rml" );
	G_PureFile( "ui/porkui/" + AGG_RATINGFILE + ".rml" );
	G_PureFile( "ui/porkui/" + AGG_FIRSTSTEPSFILE + ".rml" );
}
