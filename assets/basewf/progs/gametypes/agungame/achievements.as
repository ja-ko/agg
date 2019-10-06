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
	achievementcenter.as
	functioncallcenter.as
*/

const String AC_MODEL_WINGS = "models/agungame/playerextensions/wings.md3";
const String AC_MODEL_SPIKES = "models/agungame/playerextensions/spikes.md3";
const String AC_MODEL_WINDINGKEY = "models/agungame/playerextensions/windingkey.md3";

const int[] AC_MASSMURDERER_AMOUNT = {100,500,2500,20000};
const uint[] AC_MASSMURDERER_POINTS = {5,10,50,150};
const int[] AC_FROG_AMOUNT = {100,5000,50000,133700};
const uint[] AC_FROG_POINTS = {1,10,50,100};
const uint[] AC_REGULAR_AMOUNT = {60,24*60,24*60*5,24*60*14};
const uint[] AC_REGULAR_POINTS = {15,70,250,500};
const uint AC_COWARD_POINTS = 5;
const int[] AC_BADLUCK_AMOUNT = {100,120,140,160};
const uint[] AC_BADLUCK_POINTS = {5,5,5,5};
const float[] AC_ROADRUNNER_VALUES = {1000, 1300, 2000, 2500}; // speed check �ndern und mit <= speedticker testen
const int[] AC_ROADRUNNER_POINTS = {5,10,15,20};
const int[] AC_ROADRUNNER_TICKERCOUNT = {10,10,10,10}; //Tickercount * 500millis = time u need to have the speed
const int AC_PIGHUNTER_POINTS = 5;
const uint AC_PIGHUNTER_AMOUNT = 100;
const int AC_KALLE_POINTS = 5;
const uint AC_KALLE_VALUE = 60;
const int AC_KALLE_TICKERCOUNT = 10;
const uint AC_ADMINKILL_AMOUNT = 50;
const int AC_ADMINKILL_POINTS = 5;
const int AC_LUCKER_POINTS = 25;
const uint AC_LUCKER_AMOUNT = 100;
const int AC_CHATKILLER_POINTS = 5;
const int AC_CHATKILLERELITE_POINTS = 5;
const int AC_MINESWEEPER_POINTS = 20;
const uint AC_MINESWEEPER_AMOUNT = 400;

const String AC_MASSMURDERER_ID = "mm";
const String AC_FROG_ID = "fr";
const String AC_REGULAR_ID = "re";
const String AC_COWARD_ID = "co";
const String AC_BADLUCK_ID = "bl";
const String AC_ROADRUNNER_ID = "rr";
const String AC_PIGHUNTER_ID = "ph";
const String AC_KALLE_ID = "p";
const String AC_ADMINKILL_ID = "ak";
const String AC_LUCKER_ID = "l";
const String AC_CHATKILLER_ID = "ck";
const String AC_CHATKILLERELITE_ID = "ce";
const String AC_MINESWEEPER_ID = "mw";

// ===========================================
// Scoreboardachievement: Admin

class AdminAchievement : AchievementScoreboard
{
	AchievementScoreboard @copy()
	{
		AdminAchievement ret;
		ret.identifier = "scoreboard:admin";
		ret.color = S_COLOR_ORANGE;
		ret.rank = "Admin";
		return ret;
	}

	void init( Client @inClient, String serializedData ) override
	{
		@client = @inClient;

		if( serializedData == "1" )
			available = true;
	}

	String shutdown() override
	{
		if( available )
			return "1";
		else
			return "0";
	}
}

// ===========================================
// Scoreboardachievement: Member

class MemberAchievement : AchievementScoreboard
{
	AchievementScoreboard @copy()
	{
		MemberAchievement ret;
		ret.identifier = "scoreboard:member";
		ret.color = S_COLOR_RED;
		ret.rank = "Member";
		return ret;
	}

	void init( Client @inClient, String serializedData ) override
	{
		@client = @inClient;

		if( serializedData == "1" )
			available = true;
	}

	String shutdown() override
	{
		if( available )
			return "1";
		else
			return "0";
	}
}

// ===========================================
// Scoreboardachievement: Special

class SpecialAchievement : AchievementScoreboard
{
	AchievementScoreboard @copy()
	{
		SpecialAchievement ret;
		ret.identifier = "scoreboard:special";
		ret.color = S_COLOR_GREEN;
		ret.rank = "ExeptionalUser";
		return ret;
	}

	void init( Client @inClient, String serializedData ) override
	{
		@client = @inClient;

		if( serializedData == "1" )
			available = true;
	}

	String shutdown() override
	{
		if( available )
			return "1";
		else
			return "0";
	}
}

// ===========================================
// Scoreboardachievement: Supporter

class SupporterAchievement : AchievementScoreboard
{
	AchievementScoreboard @copy()
	{
		SupporterAchievement ret;
		ret.identifier = "scoreboard:supporter";
		ret.color = S_COLOR_CYAN;
		ret.rank = "Supporter";
		return ret;
	}

	void init( Client @inClient, String serializedData ) override
	{
		@client = @inClient;

		if( serializedData == "1" )
			available = true;
	}

	String shutdown() override
	{
		if( available )
			return "1";
		else
			return "0";
	}
}

// ===========================================
// Scoreboardachievement: Top5

class Top5Achievement : AchievementScoreboard
{
	AchievementScoreboard @copy()
	{
		Top5Achievement ret;
		ret.identifier = "scoreboard:top5";
		ret.color = S_COLOR_YELLOW;
		ret.rank = "Top5";
		return ret;
	}

	void init( Client @inClient, String serializedData ) override
	{
		@client = @inClient;

		if( serializedData == "1" )
			available = true;
	}

	String shutdown() override
	{
		if( available )
			return "1";
		else
			return "0";
	}
}

void Top5Achievement_Init()
{
	FunctionCallCenter::RegisterGametypeShutdownListener( Top5Achievement_Shutdown );
	G_Print( "Top5Achievement initializing\n" );
	Cvar g_agg_top1( "g_agg_top1", "", CVAR_ARCHIVE );
	Cvar g_agg_top2( "g_agg_top2", "", CVAR_ARCHIVE );
	Cvar g_agg_top3( "g_agg_top3", "", CVAR_ARCHIVE );
	Cvar g_agg_top4( "g_agg_top4", "", CVAR_ARCHIVE );
	Cvar g_agg_top5( "g_agg_top5", "", CVAR_ARCHIVE );

	if( G_FileExists( StringUtils::RemoveInvalidPathChars( "achievements/" + gametype.name + ".top5" ) ) )
	{
		String top5 = G_LoadFile( StringUtils::RemoveInvalidPathChars( "achievements/" + gametype.name + ".top5" ) );
		String@[]@ splitResult = @StringUtils::Split( top5, "\n" );
		if( splitResult.length != 5 )
		{
			G_Print( "ERROR: Top5Achievement initialization failed\n" );
			return;
		}
		g_agg_top1.set( splitResult[0] );
		g_agg_top2.set( splitResult[1] );
		g_agg_top3.set( splitResult[2] );
		g_agg_top4.set( splitResult[3] );
		g_agg_top5.set( splitResult[4] );
	}
	else
		G_Print( "ERROR: Top5Achievement initialization failed\n" );
}

void Top5Achievement_Shutdown()
{
	G_Print( "Top5Achievement serializing\n" );
	Cvar g_agg_top1( "g_agg_top1", "", CVAR_ARCHIVE );
	Cvar g_agg_top2( "g_agg_top2", "", CVAR_ARCHIVE );
	Cvar g_agg_top3( "g_agg_top3", "", CVAR_ARCHIVE );
	Cvar g_agg_top4( "g_agg_top4", "", CVAR_ARCHIVE );
	Cvar g_agg_top5( "g_agg_top5", "", CVAR_ARCHIVE );

	if( g_agg_top1.string != "" )
	{
		String[] names = {
			g_agg_top1.string,
			g_agg_top2.string,
			g_agg_top3.string,
			g_agg_top4.string,
			g_agg_top5.string };
		String toplist = "";
		for( int i = 0; i < 5; i++ )
			toplist += names[i] + "\n";
		toplist = toplist.substr( 0, toplist.len() - 1 ); // remove last \n
		String oldlist = G_LoadFile( StringUtils::RemoveInvalidPathChars( "achievements/" + gametype.name + ".top5" ) );
		if( toplist != oldlist )
		{
			String@[]@ oldnames = @StringUtils::Split( oldlist, "\n" );
			for( int i = 0; i < 5; i++ )
			{
				if( names.find( oldnames[i] ) == -1 )
				{
					String oldpath = StringUtils::RemoveInvalidPathChars( "achievements/" + oldnames[i] + ".ac" );
					if( G_FileExists( oldpath ) )
					{
						Dictionary @dict = @Serialization::DeserializeStringDictionary( oldpath );
						dict.set( "scoreboard:top5", "0" );
						Serialization::SerializeStringDictionary( dict, oldpath );
					}
				}

				String path = StringUtils::RemoveInvalidPathChars( "achievements/" + names[i] + ".ac" );
				if( !G_FileExists( path ) )
					continue;
				Dictionary @dict = @Serialization::DeserializeStringDictionary( path );
				dict.set( "scoreboard:top5", "1" );
				Serialization::SerializeStringDictionary( dict, path );
			}
			G_WriteFile( StringUtils::RemoveInvalidPathChars( "achievements/" + gametype.name + ".top5" ), toplist );
		}
	}
	else
		G_Print( "ERROR: Top5Achievement serialization failed\n" );
}

// ===========================================
// Modelextension: Spikes

class SpikeTestAchievement : AchievementModel
{
	AchievementModel @copy()
	{
		SpikeTestAchievement ret;
		ret.identifier = "model:spikes";
		ret.modelPath = AC_MODEL_SPIKES;
		ret.modelID = G_ModelIndex( ret.modelPath );
		String@[]@ splitResult = StringUtils::Split( ret.modelPath, "/" );
		ret.modelName = StringUtils::Replace( splitResult[splitResult.length() - 1], ".md3", "" );
		return ret;
	}

	void init( Client @inClient, String serializedData ) override
	{
		@client = @inClient;
		available = true;
	}

	String shutdown() override
	{
		return "0";
	}
}

// ===========================================
// Modelextension: Wings

class WingsTestAchievement : AchievementModel
{
	AchievementModel @copy()
	{
		WingsTestAchievement ret;
		ret.identifier = "model:wings";
		ret.modelPath = AC_MODEL_WINGS;
		ret.modelID = G_ModelIndex( ret.modelPath );
		String@[]@ splitResult = StringUtils::Split( ret.modelPath, "/" );
		ret.modelName = StringUtils::Replace( splitResult[splitResult.length() - 1], ".md3", "" );
		return ret;
	}

	void achievementPointsChanged( uint newPoints ) override
	{
		if( !available && newPoints >= 100 )
		{
			available = true;
			AGG_SilentAward(client, S_COLOR_YELLOW + "Model extension unlocked: " + S_COLOR_ORANGE + "Wings" );
		}
	}

	void init( Client @inClient, String serializedData ) override
	{
		if( serializedData == "1" )
			available = true;
		else
			available = false;

		@client = @inClient;
	}

	String shutdown() override
	{
		return available ? "1" : "0";
	}
}

// ===========================================
// Modelextension: WindingKey

class WindingKey : AchievementModel
{
	AchievementModel @copy()
	{
		WindingKey ret;
		ret.identifier = "model:windingkey";
		ret.modelPath = AC_MODEL_WINDINGKEY;
		ret.modelID = G_ModelIndex( ret.modelPath );
		String@[]@ splitResult = StringUtils::Split( ret.modelPath, "/" );
		ret.modelName = StringUtils::Replace( splitResult[splitResult.length() - 1], ".md3", "" );
		return ret;
	}

	void achievementPointsChanged( uint newPoints ) override
	{
		if( !available && newPoints >= 50 )
		{
			available = true;
			AGG_SilentAward(client, S_COLOR_YELLOW + "Model extension unlocked: " + S_COLOR_ORANGE + "Winding Key" );
		}
	}

	void init( Client @inClient, String serializedData ) override
	{
		if( serializedData == "1" )
			available = true;
		else
			available = false;

		@client = @inClient;
	}

	String shutdown() override
	{
		return available ? "1" : "0";
	}
}

// ===========================================
// Achievement: Test

class Test : AchievementStandart
{
	AchievementStandart @copy()
	{
		Test ret;
		ret.identifier = "";
		ret.points = 0;
		return ret;
	}

	uint checkReached()
	{
		return points;
	}

	void init( Client @inClient, String serializedData ) override
	{
		@client = @inClient;
	}

	String shutdown() override
	{
		return "test";
	}

	float get_progress()
	{
        return -1337;
	}

    bool opEquals( Test @input )
	{
        return opEquals(input);
	}

}

array<Test@> testarchievment;

// ===========================================
// Achievement: Lucker

class Lucker : AchievementStandart
{
    uint reach;

	AchievementStandart @copy()
	{
		Lucker ret;
		ret.identifier = "standart:lucker";
		ret.points = AC_LUCKER_POINTS;
		ret.ui_identifier = AC_LUCKER_ID;
		ret.reach = AC_LUCKER_AMOUNT;
		return ret;
	}

	uint checkReached()
	{
		if ( reach <= 0 )
        {
            reached = true;
            return points;
        }
        return 0;
	}

	void init( Client @inClient, String serializedData ) override
	{
		@client = @inClient;

		if( serializedData == "done" )
         	reached = true;
		else
		{
		    reach = serializedData.toInt();
		    if ( reach <= 0 )
                reach = AC_LUCKER_AMOUNT;

			ActiveLuckerAchievements.insertLast( this );

			if( @LuckerAchievement_listenerHandle == null )
			{
				@LuckerAchievement_listenerHandle = FunctionCallCenter::RegisterScoreEventListener( Lucker_KillHandler );
			}
		}
	}

	String shutdown() override
	{
		if( ActiveLuckerAchievements.find( this ) != -1 )
			ActiveLuckerAchievements.removeAt( ActiveLuckerAchievements.find( this ) );

		if( ActiveLuckerAchievements.length == 0 )
		{
			FunctionCallCenter::RemoveScoreEventListener( LuckerAchievement_listenerHandle );
			@LuckerAchievement_listenerHandle = null;
		}
		return reached ? "done" : reach + "";
	}

	float get_progress()
	{
        return reached ? -1.0f : float(AC_LUCKER_AMOUNT-reach)/float(AC_LUCKER_AMOUNT);
	}

    bool opEquals( Lucker @input )
	{
        return opEquals(input);
	}
}

ListenerHandle @LuckerAchievement_listenerHandle = null;
array<Lucker@> ActiveLuckerAchievements;
void Lucker_KillHandler( Client @client, String &score_event, String &args )
{
	if( score_event != "instashield" )
		return;
	int attacker = args.getToken( 0 ).toInt();
	if ( @G_GetEntity( attacker ) == null)
        return;
	for( uint i = 0; i < ActiveLuckerAchievements.length; i++ )
	{
		if( @ActiveLuckerAchievements[i] == null || @ActiveLuckerAchievements[i].client == null  || @client == @ActiveLuckerAchievements[i].client )
			continue;
        if( @G_GetEntity( attacker ).client == @ActiveLuckerAchievements[i].client )
        {
            ActiveLuckerAchievements[i].reach--;
        }
	}
}

// ===========================================
// Achievement: Adminkill

class AdminKill : AchievementStandart
{
    uint reach;

	AchievementStandart @copy()
	{
		AdminKill ret;
		ret.identifier = "standart:adminkill";
		ret.points = AC_ADMINKILL_POINTS;
		ret.ui_identifier = AC_ADMINKILL_ID;
		ret.reach = AC_ADMINKILL_AMOUNT;
		return ret;
	}

	uint checkReached()
	{
		if ( reach <= 0 )
        {
            Achievements::SilentAward(client, S_COLOR_YELLOW + "Achievement unlocked: " + S_COLOR_ORANGE + "Admin Kill");
            reached = true;
            return points;
        }
        return 0;
	}

	void init( Client @inClient, String serializedData ) override
	{
		@client = @inClient;

		if( serializedData == "done" )
         	reached = true;
		else
		{
		    reach = serializedData.toInt();
		    if ( reach <= 0 )
                reach = AC_ADMINKILL_AMOUNT;

			ActiveAdminKillAchievements.insertLast( this );

			if( @AdminKillAchievement_listenerHandle == null )
			{
				@AdminKillAchievement_listenerHandle = FunctionCallCenter::RegisterScoreEventListener( AdminKill_KillHandler );
			}
		}
	}

	String shutdown() override
	{
		if( ActiveAdminKillAchievements.find( this ) != -1 )
			ActiveAdminKillAchievements.removeAt( ActiveAdminKillAchievements.find( this ) );

		if( ActiveAdminKillAchievements.length == 0 )
		{
			FunctionCallCenter::RemoveScoreEventListener( AdminKillAchievement_listenerHandle );
			@AdminKillAchievement_listenerHandle = null;
		}
		return reached ? "done" : reach + "";
	}

	float get_progress()
	{
        return reached ? -1.0f : float(AC_ADMINKILL_AMOUNT-reach)/float(AC_ADMINKILL_AMOUNT);
	}

    bool opEquals( AdminKill @input )
	{
        return opEquals(input);
	}
}

ListenerHandle @AdminKillAchievement_listenerHandle = null;
array<AdminKill@> ActiveAdminKillAchievements;
void AdminKill_KillHandler( Client @client, String &score_event, String &args )
{
	if( score_event != "kill" )
		return;
	int tar = args.getToken( 0 ).toInt();
	if ( @G_GetEntity( tar ) == null)
        return;
	for( uint i = 0; i < ActiveAdminKillAchievements.length; i++ )
	{
		if( @ActiveAdminKillAchievements[i] == null || @ActiveAdminKillAchievements[i].client == null  || @G_GetEntity( tar ) == @ActiveAdminKillAchievements[i].client.getEnt() )
			continue;
        if( @client == @ActiveAdminKillAchievements[i].client )
        {
            if ( Achievements::PlayerAchievedAchievement( @G_GetEntity( tar ).client, "scoreboard:admin" ) )
                ActiveAdminKillAchievements[i].reach--;
        }
	}
}

// ===========================================
// Achievement: Kalle

class Kalle : AchievementStandart
{
    bool reach;
    bool ping;
    int tickercount;

	AchievementStandart @copy()
	{
		Kalle ret;
		ret.identifier = "standart:kalle";
		ret.points = AC_KALLE_POINTS;
		ret.ui_identifier = AC_KALLE_ID;
		ret.reach = false;
		ret.ping = false;
		ret.tickercount = -2;
		return ret;
	}

	uint checkReached()
	{
		if( reach )
		{
			if( ActiveKalleAchievements.find( this ) != -1 )
				ActiveKalleAchievements.removeAt( ActiveKalleAchievements.find( this ) );
			if( ActiveKalleAchievements.length == 0 )
			{
				FunctionCallCenter::RemoveTimeoutArg( KalleAchievement_listenerHandle );
				KalleAchievement_listenerHandle = -1;
			}
			reached = true;
			return points;
		}
		return 0;
	}

	void init( Client @inClient, String serializedData ) override
	{
		@client = @inClient;
		if( serializedData == "done" )
			reached = true;
		else
		{
			ActiveKalleAchievements.insertLast( this );

			if( KalleAchievement_listenerHandle == -1 )
			{
				KalleAchievement_listenerHandle = FunctionCallCenter::SetIntervalArg( Kalle_IntervalHandle, 500, any(null) );
			}
		}
	}

	String shutdown() override
	{
		if( ActiveKalleAchievements.find( this ) != -1 )
			ActiveKalleAchievements.removeAt( ActiveKalleAchievements.find( this ) );

		if( ActiveKalleAchievements.length == 0 )
		{
			FunctionCallCenter::RemoveTimeoutArg( KalleAchievement_listenerHandle );
			KalleAchievement_listenerHandle = -1;
		}
		return reached ? "done" : "";
	}

	float get_progress()
	{
        return -1.0f;
	}

    bool opEquals( Kalle @input )
	{
        return opEquals(input);
	}

	void think()
	{
        if ( ping && !reach )
        {
            if ( tickercount <= 1 )
            {
                Achievements::SilentAward(client, S_COLOR_YELLOW + "Achievement unlocked: " + S_COLOR_ORANGE + "Kalle");
                reach = true;
            }
            tickercount --;
        }
        else
        {
            tickercount = AC_KALLE_TICKERCOUNT;
        }
	}
}


int KalleAchievement_listenerHandle = -1;
array<AchievementStandart@> ActiveKalleAchievements;
bool Kalle_IntervalHandle( any &arg )
{
    uint ping;
	for( uint i = 0; i < ActiveKalleAchievements.length; i++ )
	{
		if( @ActiveKalleAchievements[i] == null || @ActiveKalleAchievements[i].client == null )
			continue;
		if ( ActiveKalleAchievements[i].client.state() < CS_SPAWNED )
            continue;
		ping = uint(ActiveKalleAchievements[i].client.ping);
        if( cast<Kalle>(ActiveKalleAchievements[i]) !is null )
        {
            cast<Kalle>(ActiveKalleAchievements[i]).think();
            if ( ping >= AC_KALLE_VALUE && !cast<Kalle>(ActiveKalleAchievements[i]).ping )
            {
                cast<Kalle>(ActiveKalleAchievements[i]).tickercount = AC_KALLE_TICKERCOUNT;
                cast<Kalle>(ActiveKalleAchievements[i]).ping = true;
            }
            if ( ping < AC_KALLE_VALUE )
            {
                cast<Kalle>(ActiveKalleAchievements[i]).tickercount = AC_KALLE_TICKERCOUNT;
                cast<Kalle>(ActiveKalleAchievements[i]).ping = false;
            }
        }
	}
	return true;
}

// ===========================================
// Achievement: PigHunter

class PigHunter : AchievementStandart
{
    uint reach;

	AchievementStandart @copy()
	{
		PigHunter ret;
		ret.identifier = "standart:pighunter";
		ret.points = AC_PIGHUNTER_POINTS;
		ret.ui_identifier = AC_PIGHUNTER_ID;
		reach = AC_PIGHUNTER_AMOUNT;
		return ret;
	}

	uint checkReached()
	{
		if ( reach <= 0 )
        {
            Achievements::SilentAward(client, S_COLOR_YELLOW + "Achievement unlocked: " + S_COLOR_ORANGE + "Pig Hunter");
            reached = true;
            return points;
        }
        return 0;
	}

	void init( Client @inClient, String serializedData ) override
	{
		@client = @inClient;

		if( serializedData == "done" )
         	reached = true;
		else
		{
		    reach = serializedData.toInt();
		    if ( reach <= 0 )
                reach = AC_PIGHUNTER_AMOUNT;

            ClientCvar::Register( "cg_teambetamodel", "" );
            ClientCvar::Register( "cg_forceteamplayersteambeta", "" );
            ClientCvar::Register( "cg_teamplayersmodel", "" );
            ClientCvar::Register( "model", "" );

			ActivePigHunterAchievements.insertLast( this );

			if( @PigHunterAchievement_listenerHandle == null )
			{
				@PigHunterAchievement_listenerHandle = FunctionCallCenter::RegisterScoreEventListener( PigHunter_KillHandler );
			}
		}
	}

	String shutdown() override
	{
		if( ActivePigHunterAchievements.find( this ) != -1 )
			ActivePigHunterAchievements.removeAt( ActivePigHunterAchievements.find( this ) );

		if( ActivePigHunterAchievements.length == 0 )
		{
			FunctionCallCenter::RemoveScoreEventListener( PigHunterAchievement_listenerHandle );
			@PigHunterAchievement_listenerHandle = null;
		}
		return reached ? "done" : reach + "";
	}

	float get_progress()
	{
        return reached ? -1.0f : float(AC_PIGHUNTER_AMOUNT-reach)/float(AC_PIGHUNTER_AMOUNT);
	}

    bool opEquals( PigHunter @input )
	{
        return opEquals(input);
	}
}

ListenerHandle @PigHunterAchievement_listenerHandle = null;
array<PigHunter@> ActivePigHunterAchievements;
void PigHunter_KillHandler( Client @client, String &score_event, String &args )
{
	if( score_event != "kill" )
		return;
	int tar = args.getToken( 0 ).toInt();
	if ( @G_GetEntity( tar ) == null)
        return;
	for( uint i = 0; i < ActivePigHunterAchievements.length; i++ )
	{
		if( @ActivePigHunterAchievements[i] == null || @ActivePigHunterAchievements[i].client == null  || @G_GetEntity( tar ) == @ActivePigHunterAchievements[i].client.getEnt() )
			continue;
        if( @client == @ActivePigHunterAchievements[i].client )
        {
                String cg_teambetamodel = ClientCvar::Get( client, "cg_teambetamodel" );
                String cg_forceteamplayersteambeta = ClientCvar::Get( client, "cg_forceteamplayersteambeta" );
                String cg_teamplayersmodel = ClientCvar::Get( client, "cg_teamplayersmodel" );
                String model = ClientCvar::Get( @G_GetEntity( tar ).client, "model" );
				if( cg_teambetamodel != "null" && cg_forceteamplayersteambeta != "null" && cg_teamplayersmodel != "null" && model != "null" )
				{
					if( cg_teamplayersmodel == "" && ( cg_forceteamplayersteambeta != "1" || cg_teambetamodel == "" ) )
                    {
                        if ( model == "padpork" )
                                ActivePigHunterAchievements[i].reach--;
                    }
				}
        }
	}
}

// ===========================================
// Achievement: Coward

class CowardAchievement : AchievementStandart
{
    bool reach;

	AchievementStandart @copy()
	{
		CowardAchievement ret;
		ret.identifier = "standart:coward";
		ret.points = AC_COWARD_POINTS;
		ret.ui_identifier = AC_COWARD_ID;
		reach = false;
		return ret;
	}

	uint checkReached()
	{
		if ( reach )
        {
            Achievements::SilentAward(client, S_COLOR_YELLOW + "Achievement unlocked: " + S_COLOR_ORANGE + "Coward");
            reached = true;
            return points;
        }
        return 0;
	}

	void init( Client @inClient, String serializedData ) override
	{
		@client = @inClient;
		if( serializedData == "done" )
			reached = true;
		else
		{
			ActiveCowardAchievements.insertLast( this );

			if( CowardAchievement_listenerHandle == -1 )
			{
				CowardAchievement_listenerHandle = int(FunctionCallCenter::RegisterCommand( "kill", Coward_SuicideHandle ));
			}
		}
	}

	String shutdown() override
	{
		if( ActiveCowardAchievements.find( this ) != -1 )
			ActiveCowardAchievements.removeAt( ActiveCowardAchievements.find( this ) );

		if( ActiveCowardAchievements.length == 0 )
		{
			FunctionCallCenter::UnRegisterCommand( "kill", CowardAchievement_listenerHandle );
			CowardAchievement_listenerHandle = -1;
		}
		return reached ? "done" : "";
	}

	float get_progress()
	{
        return -1.0f;
	}

    bool opEquals( CowardAchievement @input )
	{
        return opEquals(input);
	}
}

int CowardAchievement_listenerHandle = -1;
array<CowardAchievement@> ActiveCowardAchievements;
bool Coward_SuicideHandle( Client @client, String &cmdString, String &argsString, int argc )
{
	for( uint i = 0; i < ActiveCowardAchievements.length; i++ )
	{
		if( @ActiveCowardAchievements[i] == null || @ActiveCowardAchievements[i].client == null )
            continue;
		if( @client == @ActiveCowardAchievements[i].client )
		{
            ActiveCowardAchievements[i].reach = true;
		}
	}
	return true;
}

// ===========================================
// Achievement:Road Runner

class Turtle : AchievementStandart
{
    bool reach;
    bool speed;
    int speedticker;

	AchievementStandart @copy()
	{
		Turtle ret;
		ret.identifier = "standart:roadrunner:turtle";
		ret.points = AC_ROADRUNNER_POINTS[0];
		ret.ui_identifier = AC_ROADRUNNER_ID;
		ret.reach = false;
		ret.speed = false;
		ret.speedticker = -2;
		return ret;
	}

	uint checkReached()
	{
		if( reach )
		{
			if( ActiveRoadRunnerAchievements.find( this ) != -1 )
				ActiveRoadRunnerAchievements.removeAt( ActiveRoadRunnerAchievements.find( this ) );
			if( ActiveRoadRunnerAchievements.length == 0 )
			{
				FunctionCallCenter::RemoveTimeoutArg( RoadRunnerAchievement_listenerHandle );
				RoadRunnerAchievement_listenerHandle = -1;
			}
			reached = true;
			reach = false;
			return points;
		}
		return 0;
	}

	void init( Client @inClient, String serializedData ) override
	{
		@client = @inClient;
		if( serializedData == "done" )
			reached = true;
		else
		{
			ActiveRoadRunnerAchievements.insertLast( this );

			if( RoadRunnerAchievement_listenerHandle == -1 )
			{
				RoadRunnerAchievement_listenerHandle = FunctionCallCenter::SetIntervalArg( RoadRunner_IntervalHandle, 500, any(null) );
			}
		}
	}

	String shutdown() override
	{
		if( ActiveRoadRunnerAchievements.find( this ) != -1 )
			ActiveRoadRunnerAchievements.removeAt( ActiveRoadRunnerAchievements.find( this ) );

		if( ActiveRoadRunnerAchievements.length == 0 )
		{
			FunctionCallCenter::RemoveTimeoutArg( RoadRunnerAchievement_listenerHandle );
			RoadRunnerAchievement_listenerHandle = -1;
		}
		return reached ? "done" : "";
	}

	float get_progress()
	{
        return -1.0f;
	}

    bool opEquals( Turtle @input )
	{
        return opEquals(input);
	}

	void think()
	{
	    if ( !reach && !reached )
        {
            if ( speed )
            {
                if ( speedticker <= 1 )
                {
                    reach = true;
                    Achievements::SilentAward(client, S_COLOR_YELLOW + "Achievement unlocked: " + S_COLOR_ORANGE + "Turtle");
                }
                speedticker --;
            }
            else
            {
                speedticker = AC_ROADRUNNER_TICKERCOUNT[0];
            }
        }
	}
}

class Bunny : AchievementStandart
{
    bool reach;
    bool speed;
    int speedticker;

	AchievementStandart @copy()
	{
		Bunny ret;
		ret.identifier = "standart:roadrunner:bunny";
		ret.points = AC_ROADRUNNER_POINTS[1];
		ret.reach = false;
		ret.speed = false;
		ret.speedticker = -2;
		return ret;
	}

	uint checkReached()
	{
		if( reach )
		{
			if( ActiveRoadRunnerAchievements.find( this ) != -1 )
				ActiveRoadRunnerAchievements.removeAt( ActiveRoadRunnerAchievements.find( this ) );
			if( ActiveRoadRunnerAchievements.length == 0 )
			{
				FunctionCallCenter::RemoveTimeoutArg( RoadRunnerAchievement_listenerHandle );
				RoadRunnerAchievement_listenerHandle = -1;
			}
			reached = true;
			reach = false;
			return points;
		}
		return 0;
	}

	void init( Client @inClient, String serializedData ) override
	{
		@client = @inClient;
		if( serializedData == "done" )
			reached = true;
		else
		{
			ActiveRoadRunnerAchievements.insertLast( this );

			if( RoadRunnerAchievement_listenerHandle == -1 )
			{
				RoadRunnerAchievement_listenerHandle = FunctionCallCenter::SetIntervalArg( RoadRunner_IntervalHandle, 500, any(null) );
			}
		}
	}

	String shutdown() override
	{
		if( ActiveRoadRunnerAchievements.find( this ) != -1 )
			ActiveRoadRunnerAchievements.removeAt( ActiveRoadRunnerAchievements.find( this ) );

		if( ActiveRoadRunnerAchievements.length == 0 )
		{
			FunctionCallCenter::RemoveTimeoutArg( RoadRunnerAchievement_listenerHandle );
			RoadRunnerAchievement_listenerHandle = -1;
		}
		return reached ? "done" : "";
	}

	float get_progress()
	{
        return -1.0f;
	}

    bool opEquals( Bunny @input )
	{
        return opEquals(input);
	}

	void think()
	{
	    if ( !reach && !reached )
        {
            if ( speed )
            {
                if ( speedticker <= 1 )
                {
                    reach = true;
                    Achievements::SilentAward(client, S_COLOR_YELLOW + "Achievement unlocked: " + S_COLOR_ORANGE + "Bunny");
                }
                speedticker --;
            }
            else
            {
                speedticker = AC_ROADRUNNER_TICKERCOUNT[1];
            }
        }
	}
}

class Hawk : AchievementStandart
{
    bool reach;
    bool speed;
    int speedticker;

	AchievementStandart @copy()
	{
		Hawk ret;
		ret.identifier = "standart:roadrunner:hawk";
		ret.points = AC_ROADRUNNER_POINTS[2];
		ret.reach = false;
		ret.speed = false;
		ret.speedticker = -2;
		return ret;
	}

	uint checkReached()
	{
		if( reach )
		{
			if( ActiveRoadRunnerAchievements.find( this ) != -1 )
				ActiveRoadRunnerAchievements.removeAt( ActiveRoadRunnerAchievements.find( this ) );
			if( ActiveRoadRunnerAchievements.length == 0 )
			{
				FunctionCallCenter::RemoveTimeoutArg( RoadRunnerAchievement_listenerHandle );
				RoadRunnerAchievement_listenerHandle = -1;
			}
			reached = true;
			reach = false;
			return points;
		}
		return 0;
	}

	void init( Client @inClient, String serializedData ) override
	{
		@client = @inClient;
		if( serializedData == "done" )
			reached = true;
		else
		{
			ActiveRoadRunnerAchievements.insertLast( this );

			if( RoadRunnerAchievement_listenerHandle == -1 )
			{
				RoadRunnerAchievement_listenerHandle = FunctionCallCenter::SetIntervalArg( RoadRunner_IntervalHandle, 500, any(null) );
			}
		}
	}

	String shutdown() override
	{
		if( ActiveRoadRunnerAchievements.find( this ) != -1 )
			ActiveRoadRunnerAchievements.removeAt( ActiveRoadRunnerAchievements.find( this ) );

		if( ActiveRoadRunnerAchievements.length == 0 )
		{
			FunctionCallCenter::RemoveTimeoutArg( RoadRunnerAchievement_listenerHandle );
			RoadRunnerAchievement_listenerHandle = -1;
		}
		return reached ? "done" : "";
	}

	float get_progress()
	{
        return -1.0f;
	}

    bool opEquals( Hawk @input )
	{
        return opEquals(input);
	}

	void think()
	{
	    if ( !reached )
        {
            if ( speed )
            {
                if ( speedticker <= 1 )
                {
                    reach = true;
                    Achievements::SilentAward(client, S_COLOR_YELLOW + "Achievement unlocked: " + S_COLOR_ORANGE + "Hawk");
                }
                speedticker --;
            }
            else
            {
                speedticker = AC_ROADRUNNER_TICKERCOUNT[2];
            }
        }
	}
}

class RoadRunner : AchievementStandart
{
    bool reach;
    bool speed;
    int speedticker;

	AchievementStandart @copy()
	{
		RoadRunner ret;
		ret.identifier = "standart:roadrunner:roadrunner";
		ret.points = AC_ROADRUNNER_POINTS[3];
		ret.reach = false;
		ret.speed = false;
		ret.speedticker = -2;
		return ret;
	}

	uint checkReached()
	{
		if( reach )
		{
			if( ActiveRoadRunnerAchievements.find( this ) != -1 )
				ActiveRoadRunnerAchievements.removeAt( ActiveRoadRunnerAchievements.find( this ) );
			if( ActiveRoadRunnerAchievements.length == 0 )
			{
				FunctionCallCenter::RemoveTimeoutArg( RoadRunnerAchievement_listenerHandle );
				RoadRunnerAchievement_listenerHandle = -1;
			}
			reached = true;
			reach = false;
			return points;
		}
		return 0;
	}

	void init( Client @inClient, String serializedData ) override
	{
		@client = @inClient;
		if( serializedData == "done" )
			reached = true;
		else
		{
			ActiveRoadRunnerAchievements.insertLast( this );

			if( RoadRunnerAchievement_listenerHandle == -1 )
			{
				RoadRunnerAchievement_listenerHandle = FunctionCallCenter::SetIntervalArg( RoadRunner_IntervalHandle, 500, any(null) );
			}
		}
	}

	String shutdown() override
	{
		if( ActiveRoadRunnerAchievements.find( this ) != -1 )
			ActiveRoadRunnerAchievements.removeAt( ActiveRoadRunnerAchievements.find( this ) );

		if( ActiveRoadRunnerAchievements.length == 0 )
		{
			FunctionCallCenter::RemoveTimeoutArg( RoadRunnerAchievement_listenerHandle );
			RoadRunnerAchievement_listenerHandle = -1;
		}
		return reached ? "done" : "";
	}

	float get_progress()
	{
        return reached ? 1 : 0;
	}

    bool opEquals( RoadRunner @input )
	{
        return opEquals(input);
	}

	void think()
	{
	    if ( !reach && !reached )
        {
            if ( speed )
            {
                if ( speedticker <= 1 )
                {
                    reach = true;
                    Achievements::SilentAward(client, S_COLOR_YELLOW + "Achievement unlocked: " + S_COLOR_ORANGE + "Road Runner");
                }
                speedticker --;
            }
            else
            {
                speedticker = AC_ROADRUNNER_TICKERCOUNT[3];
            }
        }
	}
}

int RoadRunnerAchievement_listenerHandle = -1;
array<AchievementStandart@> ActiveRoadRunnerAchievements;
bool RoadRunner_IntervalHandle( any &arg )
{
    float clientspeed;
    Vec3 tempvec;
	for( uint i = 0; i < ActiveRoadRunnerAchievements.length; i++ )
	{
		if( @ActiveRoadRunnerAchievements[i] == null || @ActiveRoadRunnerAchievements[i].client == null )
			continue;
		tempvec = ActiveRoadRunnerAchievements[i].client.getEnt().velocity;
		tempvec.z = 0;
		clientspeed = tempvec.length();
        if( cast<Turtle>(ActiveRoadRunnerAchievements[i]) !is null )
        {
            cast<Turtle>(ActiveRoadRunnerAchievements[i]).think();
            if ( clientspeed >= AC_ROADRUNNER_VALUES[0] && !cast<Turtle>(ActiveRoadRunnerAchievements[i]).speed )
            {
                cast<Turtle>(ActiveRoadRunnerAchievements[i]).speedticker = AC_ROADRUNNER_TICKERCOUNT[0];
                cast<Turtle>(ActiveRoadRunnerAchievements[i]).speed = true;
            }
            if ( clientspeed < AC_ROADRUNNER_VALUES[0] )
            {
                cast<Turtle>(ActiveRoadRunnerAchievements[i]).speedticker = AC_ROADRUNNER_TICKERCOUNT[0];
                cast<Turtle>(ActiveRoadRunnerAchievements[i]).speed = false;
            }
        }
        else if( cast<Bunny>(ActiveRoadRunnerAchievements[i]) !is null )
        {
            cast<Bunny>(ActiveRoadRunnerAchievements[i]).think();
            if ( clientspeed >= AC_ROADRUNNER_VALUES[1] && !cast<Bunny>(ActiveRoadRunnerAchievements[i]).speed )
            {
                cast<Bunny>(ActiveRoadRunnerAchievements[i]).speedticker = AC_ROADRUNNER_TICKERCOUNT[1];
                cast<Bunny>(ActiveRoadRunnerAchievements[i]).speed = true;
            }
            if ( clientspeed < AC_ROADRUNNER_VALUES[1] )
            {
                cast<Bunny>(ActiveRoadRunnerAchievements[i]).speedticker = AC_ROADRUNNER_TICKERCOUNT[1];
                cast<Bunny>(ActiveRoadRunnerAchievements[i]).speed = false;
            }
        }
        else if( cast<Hawk>(ActiveRoadRunnerAchievements[i]) !is null )
        {
            cast<Hawk>(ActiveRoadRunnerAchievements[i]).think();
            if ( clientspeed >= AC_ROADRUNNER_VALUES[2] && !cast<Hawk>(ActiveRoadRunnerAchievements[i]).speed )
            {
                cast<Hawk>(ActiveRoadRunnerAchievements[i]).speedticker = AC_ROADRUNNER_TICKERCOUNT[2];
                cast<Hawk>(ActiveRoadRunnerAchievements[i]).speed = true;
            }
            if ( clientspeed < AC_ROADRUNNER_VALUES[2] )
            {
                cast<Hawk>(ActiveRoadRunnerAchievements[i]).speedticker = AC_ROADRUNNER_TICKERCOUNT[2];
                cast<Hawk>(ActiveRoadRunnerAchievements[i]).speed = false;
            }
        }
        else if( cast<RoadRunner>(ActiveRoadRunnerAchievements[i]) !is null )
        {
            cast<RoadRunner>(ActiveRoadRunnerAchievements[i]).think();
            if ( clientspeed >= AC_ROADRUNNER_VALUES[3] && !cast<RoadRunner>(ActiveRoadRunnerAchievements[i]).speed )
            {
                cast<RoadRunner>(ActiveRoadRunnerAchievements[i]).speedticker = AC_ROADRUNNER_TICKERCOUNT[3];
                cast<RoadRunner>(ActiveRoadRunnerAchievements[i]).speed = true;
            }
            if ( clientspeed < AC_ROADRUNNER_VALUES[3] )
            {
                cast<RoadRunner>(ActiveRoadRunnerAchievements[i]).speedticker = AC_ROADRUNNER_TICKERCOUNT[3];
                cast<RoadRunner>(ActiveRoadRunnerAchievements[i]).speed = false;
            }
        }
	}
	return true;
}

// ===========================================
// Achievement: Bad Luck

class BadLuckStep1 : AchievementStandart
{
	int deathAmount;

	AchievementStandart @copy()
	{
		BadLuckStep1 ret;
		ret.identifier = "standart:badluck:step1";
		ret.points = AC_BADLUCK_POINTS[0];
		ret.deathAmount = 0;
		ret.ui_identifier = AC_BADLUCK_ID;
		return ret;
	}

	uint checkReached()
	{

		if( deathAmount >= AC_BADLUCK_AMOUNT[0] )
		{
			Achievements::SilentAward(client, S_COLOR_YELLOW + "Achievement unlocked: " + S_COLOR_ORANGE + "Bad Luck Bronze");
			if( ActiveBadLuckAchievement.find( this ) != -1 )
				ActiveBadLuckAchievement.removeAt( ActiveBadLuckAchievement.find( this ) );
			if( ActiveBadLuckAchievement.length == 0 )
			{
				FunctionCallCenter::RemoveScoreEventListener( BadLuckAchievements_listenerHandle );
				@BadLuckAchievements_listenerHandle = null;
			}
			reached = true;
			return points;
		}
		return 0;
	}

	void init( Client @inClient, String serializedData ) override
	{
		@client = @inClient;
		if( serializedData == "done" )
			reached = true;
		else
		{
			deathAmount = serializedData.toInt();

			ActiveBadLuckAchievement.insertLast( this );

			if( @BadLuckAchievements_listenerHandle == null )
			{
				@BadLuckAchievements_listenerHandle = @FunctionCallCenter::RegisterScoreEventListener( BadLuckAchievements_ScoreEvent );

			}
		}
	}

	String shutdown() override
	{
		if( ActiveBadLuckAchievement.find( this ) != -1 )
			ActiveBadLuckAchievement.removeAt( ActiveBadLuckAchievement.find( this ) );

		if( ActiveBadLuckAchievement.length == 0 )
		{
			FunctionCallCenter::RemoveScoreEventListener( BadLuckAchievements_listenerHandle );
			@BadLuckAchievements_listenerHandle = null;
		}
		return reached ? "done" : "";
	}

	float get_progress()
	{
        return float(deathAmount)/float(AC_BADLUCK_AMOUNT[0]);
	}

    bool opEquals( BadLuckStep1 @input )
	{
        return opEquals(input);
	}
}

class BadLuckStep2 : AchievementStandart
{
	int deathAmount;

	AchievementStandart @copy()
	{
		BadLuckStep2 ret;
		ret.identifier = "standart:badluck:step2";
		ret.points = AC_BADLUCK_POINTS[1];
		ret.deathAmount = 0;
		return ret;
	}

	uint checkReached()
	{

		if( deathAmount >= AC_BADLUCK_AMOUNT[1] )
		{
			Achievements::SilentAward(client, S_COLOR_YELLOW + "Achievement unlocked: " + S_COLOR_ORANGE + "Bad Luck Silver");
			if( ActiveBadLuckAchievement.find( this ) != -1 )
				ActiveBadLuckAchievement.removeAt( ActiveBadLuckAchievement.find( this ) );
			if( ActiveBadLuckAchievement.length == 0 )
			{
				FunctionCallCenter::RemoveScoreEventListener( BadLuckAchievements_listenerHandle );
				@BadLuckAchievements_listenerHandle = null;
			}
			reached = true;
			return points;
		}
		return 0;
	}

	void init( Client @inClient, String serializedData ) override
	{
		@client = @inClient;
		if( serializedData == "done" )
			reached = true;
		else
		{
			deathAmount = serializedData.toInt();

			ActiveBadLuckAchievement.insertLast( this );

			if( @BadLuckAchievements_listenerHandle == null )
			{
				@BadLuckAchievements_listenerHandle = @FunctionCallCenter::RegisterScoreEventListener( BadLuckAchievements_ScoreEvent );

			}
		}
	}

	String shutdown() override
	{
		if( ActiveBadLuckAchievement.find( this ) != -1 )
			ActiveBadLuckAchievement.removeAt( ActiveBadLuckAchievement.find( this ) );

		if( ActiveBadLuckAchievement.length == 0 )
		{
			FunctionCallCenter::RemoveScoreEventListener( BadLuckAchievements_listenerHandle );
			@BadLuckAchievements_listenerHandle = null;
		}
		return reached ? "done" : "";
	}

	float get_progress()
	{
        return float(deathAmount)/float(AC_BADLUCK_AMOUNT[1]);
	}

    bool opEquals( BadLuckStep2 @input )
	{
        return opEquals(input);
	}
}

class BadLuckStep3 : AchievementStandart
{
	int deathAmount;

	AchievementStandart @copy()
	{
		BadLuckStep3 ret;
		ret.identifier = "standart:badluck:step3";
		ret.points = AC_BADLUCK_POINTS[2];
		ret.deathAmount = 0;
		return ret;
	}

	uint checkReached()
	{

		if( deathAmount >= AC_BADLUCK_AMOUNT[2] )
		{
			Achievements::SilentAward(client, S_COLOR_YELLOW + "Achievement unlocked: " + S_COLOR_ORANGE + "Bad Luck Gold");
			if( ActiveBadLuckAchievement.find( this ) != -1 )
				ActiveBadLuckAchievement.removeAt( ActiveBadLuckAchievement.find( this ) );
			if( ActiveBadLuckAchievement.length == 0 )
			{
				FunctionCallCenter::RemoveScoreEventListener( BadLuckAchievements_listenerHandle );
				@BadLuckAchievements_listenerHandle = null;
			}
			reached = true;
			return points;
		}
		return 0;
	}

	void init( Client @inClient, String serializedData ) override
	{
		@client = @inClient;
		if( serializedData == "done" )
			reached = true;
		else
		{
			deathAmount = serializedData.toInt();

			ActiveBadLuckAchievement.insertLast( this );

			if( @BadLuckAchievements_listenerHandle == null )
			{
				@BadLuckAchievements_listenerHandle = @FunctionCallCenter::RegisterScoreEventListener( BadLuckAchievements_ScoreEvent );

			}
		}
	}

	String shutdown() override
	{
		if( ActiveBadLuckAchievement.find( this ) != -1 )
			ActiveBadLuckAchievement.removeAt( ActiveBadLuckAchievement.find( this ) );

		if( ActiveBadLuckAchievement.length == 0 )
		{
			FunctionCallCenter::RemoveScoreEventListener( BadLuckAchievements_listenerHandle );
			@BadLuckAchievements_listenerHandle = null;
		}
		return reached ? "done" : "";
	}

	float get_progress()
	{
        return float(deathAmount)/float(AC_BADLUCK_AMOUNT[2]);
	}

    bool opEquals( BadLuckStep3 @input )
	{
        return opEquals(input);
	}
}

class BadLuckStep4 : AchievementStandart
{
	int deathAmount;

	AchievementStandart @copy()
	{
		BadLuckStep4 ret;
		ret.identifier = "standart:badluck:step4";
		ret.points = AC_BADLUCK_POINTS[3];
		ret.deathAmount = 0;
		ret.ui_identifier = AC_BADLUCK_ID;
		return ret;
	}

	uint checkReached()
	{

		if( deathAmount >= AC_BADLUCK_AMOUNT[3] )
		{
			Achievements::SilentAward(client, S_COLOR_YELLOW + "Achievement unlocked: " + S_COLOR_ORANGE + "Bad Luck Master");
			if( ActiveBadLuckAchievement.find( this ) != -1 )
				ActiveBadLuckAchievement.removeAt( ActiveBadLuckAchievement.find( this ) );
			if( ActiveBadLuckAchievement.length == 0 )
			{
				FunctionCallCenter::RemoveScoreEventListener( BadLuckAchievements_listenerHandle );
				@BadLuckAchievements_listenerHandle = null;
			}
			reached = true;
			return points;
		}
		return 0;
	}

	void init( Client @inClient, String serializedData ) override
	{
		@client = @inClient;
		if( serializedData == "done" )
			reached = true;
		else
		{
			deathAmount = serializedData.toInt();

			ActiveBadLuckAchievement.insertLast( this );

			if( @BadLuckAchievements_listenerHandle == null )
			{
				@BadLuckAchievements_listenerHandle = @FunctionCallCenter::RegisterScoreEventListener( BadLuckAchievements_ScoreEvent );

			}
		}
	}

	String shutdown() override
	{
		if( ActiveBadLuckAchievement.find( this ) != -1 )
			ActiveBadLuckAchievement.removeAt( ActiveBadLuckAchievement.find( this ) );

		if( ActiveBadLuckAchievement.length == 0 )
		{
			FunctionCallCenter::RemoveScoreEventListener( BadLuckAchievements_listenerHandle );
			@BadLuckAchievements_listenerHandle = null;
		}
		return reached ? "done" : "";
	}

	float get_progress()
	{
        return float(deathAmount)/float(AC_BADLUCK_AMOUNT[3]);
	}

    bool opEquals( BadLuckStep4 @input )
	{
        return opEquals(input);
	}
}

ListenerHandle @BadLuckAchievements_listenerHandle = null;
array<AchievementStandart@> ActiveBadLuckAchievement;
void BadLuckAchievements_ScoreEvent( Client @client, String &score_event, String &args )
{
	if( score_event != "kill" )
		return;
	int tar = args.getToken( 0 ).toInt();
	if ( @G_GetEntity( tar ) == null)
        return;
	for( uint i = 0; i < ActiveBadLuckAchievement.length; i++ )
	{
		if( @ActiveBadLuckAchievement[i] == null || @ActiveBadLuckAchievement[i].client == null  || @G_GetEntity( tar ) != @ActiveBadLuckAchievement[i].client.getEnt() )
			continue;
        if( cast<BadLuckStep1>(ActiveBadLuckAchievement[i]) !is null )
            cast<BadLuckStep1>(ActiveBadLuckAchievement[i]).deathAmount++;
        else if( cast<BadLuckStep2>(ActiveBadLuckAchievement[i]) !is null )
            cast<BadLuckStep2>(ActiveBadLuckAchievement[i]).deathAmount++;
        else if( cast<BadLuckStep3>(ActiveBadLuckAchievement[i]) !is null )
            cast<BadLuckStep3>(ActiveBadLuckAchievement[i]).deathAmount++;
        else if( cast<BadLuckStep4>(ActiveBadLuckAchievement[i]) !is null )
            cast<BadLuckStep4>(ActiveBadLuckAchievement[i]).deathAmount++;
	}
}

// ===========================================
// Achievement: mass murderer

class MassMurdererAchievementStep1 : AchievementStandart
{
	int killAmount;

	AchievementStandart @copy()
	{
		MassMurdererAchievementStep1 ret;
		ret.identifier = "standart:massmurderer:step1";
		ret.points = AC_MASSMURDERER_POINTS[0];
		ret.killAmount = 0;
		ret.ui_identifier = AC_MASSMURDERER_ID;
		return ret;
	}

	uint checkReached()
	{

		if( killAmount >= AC_MASSMURDERER_AMOUNT[0] )
		{
			Achievements::SilentAward(client, S_COLOR_YELLOW + "Achievement unlocked: " + S_COLOR_ORANGE + "Mass Murderer Bronze");
			if( ActiveMassMurdererAchievements.find( this ) != -1 )
				ActiveMassMurdererAchievements.removeAt( ActiveMassMurdererAchievements.find( this ) );
			if( ActiveMassMurdererAchievements.length == 0 )
			{
				FunctionCallCenter::RemoveScoreEventListener( MassMurdererAchievements_listenerHandle );
				@MassMurdererAchievements_listenerHandle = null;
			}
			reached = true;
			return points;
		}
		return 0;
	}

	void init( Client @inClient, String serializedData ) override
	{
		@client = @inClient;
		if( serializedData == "done" )
			reached = true;
		else
		{
			killAmount = serializedData.toInt();

			ActiveMassMurdererAchievements.insertLast( this );

			if( @MassMurdererAchievements_listenerHandle == null )
			{
				@MassMurdererAchievements_listenerHandle = @FunctionCallCenter::RegisterScoreEventListener( MassMurdererAchievements_ScoreEvent );

			}
		}
	}

	String shutdown() override
	{
		if( ActiveMassMurdererAchievements.find( this ) != -1 )
			ActiveMassMurdererAchievements.removeAt( ActiveMassMurdererAchievements.find( this ) );

		if( ActiveMassMurdererAchievements.length == 0 )
		{
			FunctionCallCenter::RemoveScoreEventListener( MassMurdererAchievements_listenerHandle );
			@MassMurdererAchievements_listenerHandle = null;
		}
		return reached ? "done" : killAmount + "";
	}

	float get_progress()
	{
        return float(killAmount)/float(AC_MASSMURDERER_AMOUNT[0]);
	}

    bool opEquals( MassMurdererAchievementStep1 @input )
	{
        return opEquals(input);
	}
}

class MassMurdererAchievementStep2 : AchievementStandart
{
	int killAmount;

	AchievementStandart @copy()
	{
		MassMurdererAchievementStep2 ret;
		ret.identifier = "standart:massmurderer:step2";
		ret.points = AC_MASSMURDERER_POINTS[1];
		ret.killAmount = 0;
		return ret;
	}

	uint checkReached()
	{
		if( killAmount >= AC_MASSMURDERER_AMOUNT[1] )
		{
			Achievements::SilentAward(client, S_COLOR_YELLOW + "Achievement unlocked: " + S_COLOR_ORANGE + "Mass Murderer Silver");
			if( ActiveMassMurdererAchievements.find( this ) != -1 )
				ActiveMassMurdererAchievements.removeAt( ActiveMassMurdererAchievements.find( this ) );
			if( ActiveMassMurdererAchievements.length == 0 )
			{
				FunctionCallCenter::RemoveScoreEventListener( MassMurdererAchievements_listenerHandle );
				@MassMurdererAchievements_listenerHandle = null;
			}
			reached = true;
			return points;
		}
		return 0;
	}

	void init( Client @inClient, String serializedData ) override
	{
		@client = @inClient;
		if( serializedData == "done" )
			reached = true;
		else
		{
			killAmount = serializedData.toInt();

			if( @MassMurdererAchievements_listenerHandle == null )
			{
				@MassMurdererAchievements_listenerHandle = @FunctionCallCenter::RegisterScoreEventListener( MassMurdererAchievements_ScoreEvent );
			}

			ActiveMassMurdererAchievements.insertLast( this );
		}
	}

	String shutdown() override
	{
		if( ActiveMassMurdererAchievements.find( this ) != -1 )
			ActiveMassMurdererAchievements.removeAt( ActiveMassMurdererAchievements.find( this ) );

		if( ActiveMassMurdererAchievements.length == 0 )
		{
			FunctionCallCenter::RemoveScoreEventListener( MassMurdererAchievements_listenerHandle );
			@MassMurdererAchievements_listenerHandle = null;
		}
		return reached ? "done" : killAmount + "";
	}

    float get_progress()
	{
        return float(killAmount)/float(AC_MASSMURDERER_AMOUNT[1]);
	}

    bool opEquals( MassMurdererAchievementStep2 @input )
	{
        return opEquals(input);
	}
}

class MassMurdererAchievementStep3 : AchievementStandart
{
	int killAmount;

	AchievementStandart @copy()
	{

		MassMurdererAchievementStep3 ret;
		ret.identifier = "standart:massmurderer:step3";
		ret.points = AC_MASSMURDERER_POINTS[2];
		ret.killAmount = 0;
		return ret;
	}

	uint checkReached()
	{
		if( killAmount >= AC_MASSMURDERER_AMOUNT[2] )
		{
			Achievements::SilentAward(client, S_COLOR_YELLOW + "Achievement unlocked: " + S_COLOR_ORANGE + "Mass Murderer Gold");
			if( ActiveMassMurdererAchievements.find( this ) != -1 )
				ActiveMassMurdererAchievements.removeAt( ActiveMassMurdererAchievements.find( this ) );
			if( ActiveMassMurdererAchievements.length == 0 )
			{
				FunctionCallCenter::RemoveScoreEventListener( MassMurdererAchievements_listenerHandle );
				@MassMurdererAchievements_listenerHandle = null;
			}
			reached = true;
			return points;
		}
		return 0;
	}

	void init( Client @inClient, String serializedData ) override
	{
		@client = @inClient;
		if( serializedData == "done" )
			reached = true;
		else
		{
			killAmount = serializedData.toInt();

			if( @MassMurdererAchievements_listenerHandle == null )
			{
				@MassMurdererAchievements_listenerHandle = @FunctionCallCenter::RegisterScoreEventListener( MassMurdererAchievements_ScoreEvent );
			}

			ActiveMassMurdererAchievements.insertLast( this );
		}
	}

	String shutdown() override
	{
		if( ActiveMassMurdererAchievements.find( this ) != -1 )
			ActiveMassMurdererAchievements.removeAt( ActiveMassMurdererAchievements.find( this ) );

		if( ActiveMassMurdererAchievements.length == 0 )
		{
			FunctionCallCenter::RemoveScoreEventListener( MassMurdererAchievements_listenerHandle );
			@MassMurdererAchievements_listenerHandle = null;
		}
		return reached ? "done" : killAmount + "";
	}

    float get_progress()
	{
        return float(killAmount)/float(AC_MASSMURDERER_AMOUNT[2]);
	}

    bool opEquals( MassMurdererAchievementStep3 @input )
	{
        return opEquals(input);
	}
}

class MassMurdererAchievementStep4 : AchievementStandart
{
	int killAmount;

	AchievementStandart @copy()
	{
		MassMurdererAchievementStep4 ret;
		ret.identifier = "standart:massmurderer:step4";
		ret.points = AC_MASSMURDERER_POINTS[3];
		ret.killAmount = 0;
		return ret;
	}

	uint checkReached()
	{
		if( killAmount >= AC_MASSMURDERER_AMOUNT[3] )
		{
			Achievements::SilentAward(client, S_COLOR_YELLOW + "Achievement unlocked: " + S_COLOR_ORANGE + "Mass Murderer Master");
			if( ActiveMassMurdererAchievements.find( this ) != -1 )
				ActiveMassMurdererAchievements.removeAt( ActiveMassMurdererAchievements.find( this ) );
			if( ActiveMassMurdererAchievements.length == 0 )
			{
				FunctionCallCenter::RemoveScoreEventListener( MassMurdererAchievements_listenerHandle );
				@MassMurdererAchievements_listenerHandle = null;
			}
			reached = true;
			return points;
		}
		return 0;
	}

	void init( Client @inClient, String serializedData ) override
	{
		@client = @inClient;
		if( serializedData == "done" )
			reached = true;
		else
		{
			killAmount = serializedData.toInt();

			if( @MassMurdererAchievements_listenerHandle == null )
			{
				@MassMurdererAchievements_listenerHandle = @FunctionCallCenter::RegisterScoreEventListener( MassMurdererAchievements_ScoreEvent );
			}

			ActiveMassMurdererAchievements.insertLast( this );
		}
	}

	String shutdown() override
	{
		if( ActiveMassMurdererAchievements.find( this ) != -1 )
			ActiveMassMurdererAchievements.removeAt( ActiveMassMurdererAchievements.find( this ) );

		if( ActiveMassMurdererAchievements.length == 0 )
		{
			FunctionCallCenter::RemoveScoreEventListener( MassMurdererAchievements_listenerHandle );
			@MassMurdererAchievements_listenerHandle = null;
		}
		return reached ? "done" : killAmount + "";
	}

    float get_progress()
	{
        return float(killAmount)/float(AC_MASSMURDERER_AMOUNT[3]);
	}

    bool opEquals( MassMurdererAchievementStep4 @input )
	{
        return opEquals(input);
	}
}

ListenerHandle @MassMurdererAchievements_listenerHandle = null;
array<AchievementStandart@> ActiveMassMurdererAchievements;
void MassMurdererAchievements_ScoreEvent( Client @client, String &score_event, String &args )
{
	if( score_event != "kill" )
		return;
	for( uint i = 0; i < ActiveMassMurdererAchievements.length; i++ )
	{
		if( @ActiveMassMurdererAchievements[i] == null || @ActiveMassMurdererAchievements[i].client == null )
			continue;
		if( @client == @ActiveMassMurdererAchievements[i].client )
		{
			if( cast<MassMurdererAchievementStep1>(ActiveMassMurdererAchievements[i]) !is null )
				cast<MassMurdererAchievementStep1>(ActiveMassMurdererAchievements[i]).killAmount++;
			else if( cast<MassMurdererAchievementStep2>(ActiveMassMurdererAchievements[i]) !is null )
				cast<MassMurdererAchievementStep2>(ActiveMassMurdererAchievements[i]).killAmount++;
			else if( cast<MassMurdererAchievementStep3>(ActiveMassMurdererAchievements[i]) !is null )
				cast<MassMurdererAchievementStep3>(ActiveMassMurdererAchievements[i]).killAmount++;
			else if( cast<MassMurdererAchievementStep4>(ActiveMassMurdererAchievements[i]) !is null )
				cast<MassMurdererAchievementStep4>(ActiveMassMurdererAchievements[i]).killAmount++;
		}
	}
}

// ===========================================
// Achievement: Frog

class Tadpole : AchievementStandart
{
    int jumpcount;

	AchievementStandart @copy()
	{
		Tadpole ret;
		ret.identifier = "standart:frog:tadpole";
		ret.points = AC_FROG_POINTS[0];
		ret.jumpcount = 0;
		ret.ui_identifier = AC_FROG_ID;
		return ret;
	}

	uint checkReached()
	{
		if ( jumpcount >= AC_FROG_AMOUNT[0] )
        {
            Achievements::SilentAward(client, S_COLOR_YELLOW + "Achievement unlocked: " + S_COLOR_ORANGE + "Tadpole");
			if( FrogAchievements.find( this ) != -1 )
				FrogAchievements.removeAt( FrogAchievements.find( this ) );
			if( FrogAchievements.length == 0 )
			{
				FunctionCallCenter::RemoveScoreEventListener( FrogAchievement_listenerHandle );
				@FrogAchievement_listenerHandle = null;
			}
            reached = true;
            return points;
        }
        return 0;
	}

	void init( Client @inClient, String serializedData ) override
	{
        @client = @inClient;
		if( serializedData == "done" )
			reached = true;
		else
		{
			jumpcount = serializedData.toInt();

			if( @FrogAchievement_listenerHandle == null )
			{
				@FrogAchievement_listenerHandle = @FunctionCallCenter::RegisterScoreEventListener( FrogAchievements_ScoreEvent );
			}

			FrogAchievements.insertLast( this );
		}
	}

	String shutdown() override
	{
        if( FrogAchievements.find( this ) != -1 )
			FrogAchievements.removeAt( FrogAchievements.find( this ) );

		if( FrogAchievements.length == 0 )
		{
			FunctionCallCenter::RemoveScoreEventListener( FrogAchievement_listenerHandle );
			@FrogAchievement_listenerHandle = null;
		}
		return reached ? "done" : jumpcount + "";
	}

    float get_progress()
	{
        return float(jumpcount)/float(AC_FROG_AMOUNT[0]);
	}

    bool opEquals( Tadpole @input )
	{
        return opEquals(input);
	}
}

class YoungFrog : AchievementStandart
{
    int jumpcount;

	AchievementStandart @copy()
	{
		YoungFrog ret;
		ret.identifier = "standart:frog:youngfrog";
		ret.points = AC_FROG_POINTS[1];
		ret.jumpcount = 0;
		return ret;
	}

	uint checkReached()
	{
		if ( jumpcount >= AC_FROG_AMOUNT[1] )
        {
            Achievements::SilentAward(client, S_COLOR_YELLOW + "Achievement unlocked: " + S_COLOR_ORANGE + "Young Frog");
			if( FrogAchievements.find( this ) != -1 )
				FrogAchievements.removeAt( FrogAchievements.find( this ) );
			if( FrogAchievements.length == 0 )
			{
				FunctionCallCenter::RemoveScoreEventListener( FrogAchievement_listenerHandle );
				@FrogAchievement_listenerHandle = null;
			}
            reached = true;
            return points;
        }
        return 0;
	}

	void init( Client @inClient, String serializedData ) override
	{
        @client = @inClient;
		if( serializedData == "done" )
			reached = true;
		else
		{
			jumpcount = serializedData.toInt();

			if( @FrogAchievement_listenerHandle == null )
			{
				@FrogAchievement_listenerHandle = @FunctionCallCenter::RegisterScoreEventListener( FrogAchievements_ScoreEvent );
			}

			FrogAchievements.insertLast( this );
		}
	}

	String shutdown() override
	{
        if( FrogAchievements.find( this ) != -1 )
			FrogAchievements.removeAt( FrogAchievements.find( this ) );

		if( FrogAchievements.length == 0 )
		{
			FunctionCallCenter::RemoveScoreEventListener( FrogAchievement_listenerHandle );
			@FrogAchievement_listenerHandle = null;
		}
		return reached ? "done" : jumpcount + "";
	}

    float get_progress()
	{
        return float(jumpcount)/float(AC_FROG_AMOUNT[1]);
	}

    bool opEquals( YoungFrog @input )
	{
        return opEquals(input);
	}
}

class Frog : AchievementStandart
{
    int jumpcount;

	AchievementStandart @copy()
	{
		Frog ret;
		ret.identifier = "standart:frog:frog";
		ret.points = AC_FROG_POINTS[2];
		ret.jumpcount = 0;
		return ret;
	}

	uint checkReached()
	{
		if ( jumpcount >= AC_FROG_AMOUNT[2] )
        {
            Achievements::SilentAward(client, S_COLOR_YELLOW + "Achievement unlocked: " + S_COLOR_ORANGE + "Frog");
			if( FrogAchievements.find( this ) != -1 )
				FrogAchievements.removeAt( FrogAchievements.find( this ) );
			if( FrogAchievements.length == 0 )
			{
				FunctionCallCenter::RemoveScoreEventListener( FrogAchievement_listenerHandle );
				@FrogAchievement_listenerHandle = null;
			}
            reached = true;
            return points;
        }
        return 0;
	}

	void init( Client @inClient, String serializedData ) override
	{
        @client = @inClient;
		if( serializedData == "done" )
			reached = true;
		else
		{
			jumpcount = serializedData.toInt();

			if( @FrogAchievement_listenerHandle == null )
			{
				@FrogAchievement_listenerHandle = @FunctionCallCenter::RegisterScoreEventListener( FrogAchievements_ScoreEvent );
			}

			FrogAchievements.insertLast( this );
		}
	}

	String shutdown() override
	{
        if( FrogAchievements.find( this ) != -1 )
			FrogAchievements.removeAt( FrogAchievements.find( this ) );

		if( FrogAchievements.length == 0 )
		{
			FunctionCallCenter::RemoveScoreEventListener( FrogAchievement_listenerHandle );
			@FrogAchievement_listenerHandle = null;
		}
		return reached ? "done" : jumpcount + "";
	}

    float get_progress()
	{
        return float(jumpcount)/float(AC_FROG_AMOUNT[2]);
	}

    bool opEquals( Frog @input )
	{
        return opEquals(input);
	}
}

class ElderFrog : AchievementStandart
{
    int jumpcount;

	AchievementStandart @copy()
	{
		ElderFrog ret;
		ret.identifier = "standart:frog:elderfrog";
		ret.points = AC_FROG_POINTS[3];
		ret.jumpcount = 0;
		return ret;
	}

	uint checkReached()
	{
		if ( jumpcount >= AC_FROG_AMOUNT[3] )
        {
            Achievements::SilentAward(client, S_COLOR_YELLOW + "Achievement unlocked: " + S_COLOR_ORANGE + "Elder Frog");
			if( FrogAchievements.find( this ) != -1 )
				FrogAchievements.removeAt( FrogAchievements.find( this ) );
			if( FrogAchievements.length == 0 )
			{
				FunctionCallCenter::RemoveScoreEventListener( FrogAchievement_listenerHandle );
				@FrogAchievement_listenerHandle = null;
			}
            reached = true;
            return points;
        }
        return 0;
	}

	void init( Client @inClient, String serializedData ) override
	{
        @client = @inClient;
		if( serializedData == "done" )
			reached = true;
		else
		{
			jumpcount = serializedData.toInt();

			if( @FrogAchievement_listenerHandle == null )
			{
				@FrogAchievement_listenerHandle = @FunctionCallCenter::RegisterScoreEventListener( FrogAchievements_ScoreEvent );
			}

			FrogAchievements.insertLast( this );
		}
	}

	String shutdown() override
	{
        if( FrogAchievements.find( this ) != -1 )
			FrogAchievements.removeAt( FrogAchievements.find( this ) );

		if( FrogAchievements.length == 0 )
		{
			FunctionCallCenter::RemoveScoreEventListener( FrogAchievement_listenerHandle );
			@FrogAchievement_listenerHandle = null;
		}
		return reached ? "done" : jumpcount + "";
	}

    float get_progress()
	{
        return float(jumpcount)/float(AC_FROG_AMOUNT[3]);
	}

    bool opEquals( ElderFrog @input )
	{
        return opEquals(input);
	}
}

ListenerHandle @FrogAchievement_listenerHandle = null;
array<AchievementStandart@> FrogAchievements;
void FrogAchievements_ScoreEvent( Client @client, String &score_event, String &args )
{
	if( score_event != "jump" )
		return;
	for( uint i = 0; i < FrogAchievements.length; i++ )
	{
		if( @FrogAchievements[i] == null || @FrogAchievements[i].client == null )
			continue;
		if( @client == @FrogAchievements[i].client )
		{
			if( cast<Tadpole>(FrogAchievements[i]) !is null )
				cast<Tadpole>(FrogAchievements[i]).jumpcount++;
			else if( cast<YoungFrog>(FrogAchievements[i]) !is null )
				cast<YoungFrog>(FrogAchievements[i]).jumpcount++;
			else if( cast<Frog>(FrogAchievements[i]) !is null )
				cast<Frog>(FrogAchievements[i]).jumpcount++;
            else if( cast<ElderFrog>(FrogAchievements[i]) !is null )
				cast<ElderFrog>(FrogAchievements[i]).jumpcount++;
		}
	}
}

// ===========================================
// Achievement: ChatKiller

class ChatKiller : AchievementStandart
{
    bool reach;

	AchievementStandart @copy()
	{
		ChatKiller ret;
		ret.identifier = "standart:chatkiller";
		ret.points = AC_CHATKILLER_POINTS;
		ret.ui_identifier = AC_CHATKILLER_ID;
		ret.reach = false;
		return ret;
	}

	uint checkReached()
	{
		if ( reach )
        {
            Achievements::SilentAward(client, S_COLOR_YELLOW + "Achievement unlocked: " + S_COLOR_ORANGE + "Chat Killer");
            reached = true;
            return points;
        }
        return 0;
	}

	void init( Client @inClient, String serializedData ) override
	{
		@client = @inClient;

		if( serializedData == "done" )
         	reached = true;
		else
		{
            reach = false;

			ActiveChatKillerAchievements.insertLast( this );

			if( @ChatKillerAchievement_listenerHandle == null )
			{
				@ChatKillerAchievement_listenerHandle = FunctionCallCenter::RegisterScoreEventListener( ChatKiller_KillHandler );
			}
		}
	}

	String shutdown() override
	{
		if( ActiveChatKillerAchievements.find( this ) != -1 )
			ActiveChatKillerAchievements.removeAt( ActiveChatKillerAchievements.find( this ) );

		if( ActiveChatKillerAchievements.length == 0 )
		{
			FunctionCallCenter::RemoveScoreEventListener( ChatKillerAchievement_listenerHandle );
			@ChatKillerAchievement_listenerHandle = null;
		}
		return reached ? "done" : "";
	}

	float get_progress()
	{
        return -1.0f;
	}

    bool opEquals( ChatKiller @input )
	{
        return opEquals(input);
	}
}

ListenerHandle @ChatKillerAchievement_listenerHandle = null;
array<ChatKiller@> ActiveChatKillerAchievements;
void ChatKiller_KillHandler( Client @client, String &score_event, String &args )
{
	if( score_event != "kill" )
		return;

	if( @client == null )
		return;

	int tar = args.getToken( 0 );

	Entity @attacker = client.getEnt();
	Entity @target = @G_GetEntity( tar );

	if( @target == null || @attacker == @target ||  @target.client == null ) // avoid selfkills
		return;

	for( uint i = 0; i < ActiveChatKillerAchievements.length; i++ )
	{
		ChatKiller @active = @ActiveChatKillerAchievements[i];
		if( @active != null && @active.client == @attacker.client )
		{
			if( ( target.client.buttons & BUTTON_BUSYICON ) != 0 )
				active.reach = true;
		}
	}
}

// ===========================================
// Achievement: ChatKillerElite

class ChatKillerElite : AchievementStandart
{
    bool reach;

	AchievementStandart @copy()
	{
		ChatKillerElite ret;
		ret.identifier = "standart:chatkillerelite";
		ret.points = AC_CHATKILLERELITE_POINTS;
		ret.ui_identifier = AC_CHATKILLERELITE_ID;
		ret.reach = false;
		return ret;
	}

	uint checkReached()
	{
		if ( reach )
        {
            Achievements::SilentAward(client, S_COLOR_YELLOW + "Achievement unlocked: " + S_COLOR_ORANGE + "Chat Killer Elite");
            reached = true;
            return points;
        }
        return 0;
	}

	void init( Client @inClient, String serializedData ) override
	{
		@client = @inClient;

		if( serializedData == "done" )
         	reached = true;
		else
		{
            reach = false;

			ActiveChatKillerEliteAchievements.insertLast( this );

			if( @ChatKillerEliteAchievement_listenerHandle == null )
			{
				@ChatKillerEliteAchievement_listenerHandle = FunctionCallCenter::RegisterScoreEventListener( ChatKillerElite_KillHandler );
			}
		}
	}

	String shutdown() override
	{
		if( ActiveChatKillerEliteAchievements.find( this ) != -1 )
			ActiveChatKillerEliteAchievements.removeAt( ActiveChatKillerEliteAchievements.find( this ) );

		if( ActiveChatKillerEliteAchievements.length == 0 )
		{
			FunctionCallCenter::RemoveScoreEventListener( ChatKillerEliteAchievement_listenerHandle );
			@ChatKillerEliteAchievement_listenerHandle = null;
		}
		return reached ? "done" : "";
	}

	float get_progress()
	{
        return -1.0f;
	}

    bool opEquals( ChatKillerElite @input )
	{
        return opEquals(input);
	}
}

ListenerHandle @ChatKillerEliteAchievement_listenerHandle = null;
array<ChatKillerElite@> ActiveChatKillerEliteAchievements;
void ChatKillerElite_KillHandler( Client @client, String &score_event, String &args )
{
	if( score_event != "kill" )
		return;

	if( @client == null )
		return;

	int tar = args.getToken( 0 );

	Entity @attacker = client.getEnt();
	Entity @target = @G_GetEntity( tar );

	if( @target == null || @attacker == @target ||  @target.client == null ) // avoid selfkills
		return;

	for( uint i = 0; i < ActiveChatKillerEliteAchievements.length; i++ )
	{
		ChatKillerElite @active = @ActiveChatKillerEliteAchievements[i];
		if( @active != null && @active.client == @attacker.client )
		{
			if( ( attacker.client.buttons & BUTTON_BUSYICON ) != 0 )
				active.reach = true;
		}
	}
}

// ===========================================
// Agungame Achievements
// ===========================================

// ===========================================
// Achievement: Regular

class RegularStep1 : AchievementStandart
{
    uint onlinetime;

	AchievementStandart @copy()
	{
		RegularStep1 ret;
		ret.identifier = "standart:regular:step1";
		ret.points = AC_REGULAR_POINTS[0];
		ret.onlinetime = 0;
		ret.ui_identifier = AC_REGULAR_ID;
		return ret;
	}

	uint checkReached()
	{
		if ( ( onlinetime + ( Achievements::PlayTime( client ) / 1000 / 60 ) ) >= AC_REGULAR_AMOUNT[0] )
        {
            Achievements::SilentAward(client, S_COLOR_YELLOW + "Achievement unlocked: " + S_COLOR_ORANGE + "Regular Bronze");
			if( RegularAchievements.find( this ) != -1 )
				RegularAchievements.removeAt( RegularAchievements.find( this ) );
            reached = true;
            return points;
        }
        return 0;
	}

	void init( Client @inClient, String serializedData ) override
	{
        @client = @inClient;
		if( serializedData == "done" )
			reached = true;
		else
		{
			onlinetime = serializedData.toInt();
			RegularAchievements.insertLast( this );
		}
	}

	String shutdown() override
	{
        if( RegularAchievements.find( this ) != -1 )
			RegularAchievements.removeAt( RegularAchievements.find( this ) );
        onlinetime += ( Achievements::PlayTime( client ) / 1000 / 60 );
		return reached ? "done" : onlinetime + "";
	}

    float get_progress()
	{
        return ( float(onlinetime) + ( float(Achievements::PlayTime( client ) / 1000) / 60.0f ) ) / float(AC_REGULAR_AMOUNT[0]);
	}

    bool opEquals( RegularStep1 @input )
	{
        return opEquals(input);
	}
}

class RegularStep2 : AchievementStandart
{
    uint onlinetime;

	AchievementStandart @copy()
	{
		RegularStep2 ret;
		ret.identifier = "standart:regular:step2";
		ret.points = AC_REGULAR_POINTS[1];
		ret.onlinetime = 0;
		return ret;
	}

	uint checkReached()
	{
		if ( ( onlinetime + ( Achievements::PlayTime( client ) / 1000 / 60 ) ) >= AC_REGULAR_AMOUNT[1] )
        {
            Achievements::SilentAward(client, S_COLOR_YELLOW + "Achievement unlocked: " + S_COLOR_ORANGE + "Regular Silver");
			if( RegularAchievements.find( this ) != -1 )
				RegularAchievements.removeAt( RegularAchievements.find( this ) );
            reached = true;
            return points;
        }
        return 0;
	}

	void init( Client @inClient, String serializedData ) override
	{
        @client = @inClient;
		if( serializedData == "done" )
			reached = true;
		else
		{
			onlinetime = serializedData.toInt();
			RegularAchievements.insertLast( this );
		}
	}

	String shutdown() override
	{
        if( RegularAchievements.find( this ) != -1 )
			RegularAchievements.removeAt( RegularAchievements.find( this ) );
        onlinetime += ( Achievements::PlayTime( client ) / 1000 / 60 );
		return reached ? "done" : onlinetime + "";
	}

    float get_progress()
	{
        return ( float(onlinetime) + ( float(Achievements::PlayTime( client ) / 1000) / 60.0f ) ) / float(AC_REGULAR_AMOUNT[1]);
	}

    bool opEquals( RegularStep2 @input )
	{
        return opEquals(input);
	}
}

class RegularStep3 : AchievementStandart
{
    uint onlinetime;

	AchievementStandart @copy()
	{
		RegularStep3 ret;
		ret.identifier = "standart:regular:step3";
		ret.points = AC_REGULAR_POINTS[2];
		ret.onlinetime = 0;
		return ret;
	}

	uint checkReached()
	{
		if ( ( onlinetime + ( Achievements::PlayTime( client ) / 1000 / 60 ) ) >= AC_REGULAR_AMOUNT[2] )
        {
            Achievements::SilentAward(client, S_COLOR_YELLOW + "Achievement unlocked: " + S_COLOR_ORANGE + "Regular Gold");
			if( RegularAchievements.find( this ) != -1 )
				RegularAchievements.removeAt( RegularAchievements.find( this ) );
            reached = true;
            return points;
        }
        return 0;
	}

	void init( Client @inClient, String serializedData ) override
	{
        @client = @inClient;
		if( serializedData == "done" )
			reached = true;
		else
		{
			onlinetime = serializedData.toInt();
			RegularAchievements.insertLast( this );
		}
	}

	String shutdown() override
	{
        if( RegularAchievements.find( this ) != -1 )
			RegularAchievements.removeAt( RegularAchievements.find( this ) );
        onlinetime += ( Achievements::PlayTime( client ) / 1000 / 60 );
		return reached ? "done" : onlinetime + "";
	}

    float get_progress()
	{
        return ( float(onlinetime) + ( float(Achievements::PlayTime( client ) / 1000) / 60.0f ) ) / float(AC_REGULAR_AMOUNT[2]);
	}

    bool opEquals( RegularStep3 @input )
	{
        return opEquals(input);
	}
}

class RegularStep4 : AchievementStandart
{
    uint onlinetime;

	AchievementStandart @copy()
	{
		RegularStep4 ret;
		ret.identifier = "standart:regular:step4";
		ret.points = AC_REGULAR_POINTS[3];
		ret.onlinetime = 0;
		return ret;
	}

	uint checkReached()
	{
		if ( ( onlinetime + ( Achievements::PlayTime( client ) / 1000 / 60 ) ) >= AC_REGULAR_AMOUNT[3] )
        {
            Achievements::SilentAward(client, S_COLOR_YELLOW + "Achievement unlocked: " + S_COLOR_ORANGE + "Regular Master");
			if( RegularAchievements.find( this ) != -1 )
				RegularAchievements.removeAt( RegularAchievements.find( this ) );
            reached = true;
            return points;
        }
        return 0;
	}

	void init( Client @inClient, String serializedData ) override
	{
        @client = @inClient;
		if( serializedData == "done" )
			reached = true;
		else
		{
			onlinetime = serializedData.toInt();
			RegularAchievements.insertLast( this );
		}
	}

	String shutdown() override
	{
        if( RegularAchievements.find( this ) != -1 )
			RegularAchievements.removeAt( RegularAchievements.find( this ) );
        onlinetime += ( Achievements::PlayTime( client ) / 1000 / 60 );
		return reached ? "done" : onlinetime + "";
	}

    float get_progress()
	{
        return ( float(onlinetime) + ( float(Achievements::PlayTime( client ) / 1000) / 60.0f ) ) / float(AC_REGULAR_AMOUNT[3]);
	}

    bool opEquals( RegularStep4 @input )
	{
        return opEquals(input);
	}
}

array<AchievementStandart@> RegularAchievements;

// ===========================================
// Achievement: Minesweeper

class Minesweeper : AchievementStandart
{
    uint reach;

	AchievementStandart @copy()
	{
		Minesweeper ret;
		ret.identifier = "standart:minesweeper";
		ret.points = AC_MINESWEEPER_POINTS;
		ret.ui_identifier = AC_MINESWEEPER_ID;
		ret.reach = AC_MINESWEEPER_AMOUNT;
		return ret;
	}

	uint checkReached()
	{
		if ( reach <= 0 )
        {
            Achievements::SilentAward(client, S_COLOR_YELLOW + "Achievement unlocked: " + S_COLOR_ORANGE + "Minesweeper");
            reached = true;
            return points;
        }
        return 0;
	}

	void init( Client @inClient, String serializedData ) override
	{
		@client = @inClient;

		if( serializedData == "done" )
         	reached = true;
		else
		{
            reach = serializedData.toInt();

            if ( reach <= 0)
                reach = AC_MINESWEEPER_AMOUNT;

			ActiveMinesweeperAchievements.insertLast( this );

			if( @MinesweeperAchievement_listenerHandle == null )
			{
				@MinesweeperAchievement_listenerHandle = FunctionCallCenter::RegisterScoreEventListener( Minesweeper_KillHandler );
			}
		}
	}

	String shutdown() override
	{
		if( ActiveMinesweeperAchievements.find( this ) != -1 )
			ActiveMinesweeperAchievements.removeAt( ActiveMinesweeperAchievements.find( this ) );

		if( ActiveMinesweeperAchievements.length == 0 )
		{
			FunctionCallCenter::RemoveScoreEventListener( MinesweeperAchievement_listenerHandle );
			@MinesweeperAchievement_listenerHandle = null;
		}
		return reached ? "done" : reach + "";
	}

	float get_progress()
	{
        return reached ? -1.0f : float( AC_MINESWEEPER_AMOUNT-reach )/float(AC_MINESWEEPER_AMOUNT);
	}

    bool opEquals( Minesweeper @input )
	{
        return opEquals(input);
	}
}

ListenerHandle @MinesweeperAchievement_listenerHandle = null;
array<Minesweeper@> ActiveMinesweeperAchievements;
void Minesweeper_KillHandler( Client @client, String &score_event, String &args )
{
	if( score_event != "kill" )
		return;
	int tar = args.getToken( 0 ).toInt();
	int weapon = args.getToken( 3 ).toInt();
	if ( @G_GetEntity( tar ) == null)
        return;
	for( uint i = 0; i < ActiveMinesweeperAchievements.length; i++ )
	{
		if( @ActiveMinesweeperAchievements[i] == null || @ActiveMinesweeperAchievements[i].client == null  || @client == @ActiveMinesweeperAchievements[i].client )
			continue;
        if( @G_GetEntity( tar ).client == @ActiveMinesweeperAchievements[i].client )
        {
            if (weapon == MOD_GRENADE_W)
                ActiveMinesweeperAchievements[i].reach --;
        }
	}
}

// ===========================================
// Init Achievements

namespace Achievements
{
	void SilentAward( Client @client, String message )
	{
		::AGG_SilentAward( client, message );
	}

	uint PlayTime( Client @client )
	{
		Player @player = @::AGG_GetPlayer( client );
		if ( @player == null || client.state() < ::CS_SPAWNED )
			return 0;
		return player.playTime;
	}

	bool PlayerAchievedAchievement( Client @client, String identifier )
	{
		if( @client == null )
			return false;

		PlayerAchievementCenter @ac_player = @AchievementCenter::ac_playerCenter[client.playerNum];
		if( @ac_player == null )
			return false;

		for( uint i = 0; i < ac_player.scoreboardAchievements.length; i++ )
		{
			if( @ac_player.scoreboardAchievements[i] == null )
				continue;
			if( ac_player.scoreboardAchievements[i].identifier == identifier )
				return ac_player.scoreboardAchievements[i].available;
		}

		for( uint i = 0; i < ac_player.modelAchievements.length; i++ )
		{
			if( @ac_player.modelAchievements[i] == null )
				continue;
			if( ac_player.modelAchievements[i].identifier == identifier )
				return ac_player.modelAchievements[i].available;
		}

		for( uint i = 0; i < ac_player.standartAchievementsStreak.length; i++ )
		{
			if( @ac_player.standartAchievementsStreak[i] == null )
				continue;
			for( uint j = 0; j < ac_player.standartAchievementsStreak[i].streak.length; j++ )
			{
				if( @ac_player.standartAchievementsStreak[i].streak[j] == null )
					continue;
				if( ac_player.standartAchievementsStreak[i].streak[j].identifier == identifier )
					return ac_player.standartAchievementsStreak[i].streak[j].reached;
			}
		}
		return false;
	}

	void Init()
	{
		AchievementCenter::RegisterAchievement( AdminAchievement() );
		AchievementCenter::RegisterAchievement( MemberAchievement() );
		AchievementCenter::RegisterAchievement( SpecialAchievement() );
		AchievementCenter::RegisterAchievement( SupporterAchievement() );
		AchievementCenter::RegisterAchievement( Top5Achievement() );
		AchievementCenter::RegisterAchievement( SpikeTestAchievement() );
		AchievementCenter::RegisterAchievement( WingsTestAchievement() );
		AchievementCenter::RegisterAchievement( WindingKey() );
		AchievementCenter::RegisterAchievement( MassMurdererAchievementStep1(), MassMurdererAchievementStep2(), MassMurdererAchievementStep3(), MassMurdererAchievementStep4());
		AchievementCenter::RegisterAchievement( Tadpole(), YoungFrog(), Frog(), ElderFrog() );
		AchievementCenter::RegisterAchievement( RegularStep1(), RegularStep2(), RegularStep3(), RegularStep4() );
		AchievementCenter::RegisterAchievement( CowardAchievement() );
		AchievementCenter::RegisterAchievement( BadLuckStep1(), BadLuckStep2(), BadLuckStep3(), BadLuckStep4() );
		AchievementCenter::RegisterAchievement( Turtle(), Bunny(), Hawk(), RoadRunner() );
		AchievementCenter::RegisterAchievement( PigHunter() );
		AchievementCenter::RegisterAchievement( Kalle() );
        AchievementCenter::RegisterAchievement( Lucker() );
		AchievementCenter::RegisterAchievement( AdminKill() );
		AchievementCenter::RegisterAchievement( ChatKiller() );
		AchievementCenter::RegisterAchievement( ChatKillerElite() );
		AchievementCenter::RegisterAchievement( Minesweeper() );
		AchievementCenter::Init();

		::Top5Achievement_Init();

		::G_PureFile( ::AC_MODEL_SPIKES );
		::G_PureFile( ::AC_MODEL_WINGS );
	}
}
