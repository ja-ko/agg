
/*
 * (C) Copyright 2013 Jannik "drahti" Kolodziej and others
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the GNU Lesser General Public License
 * (LGPL) version 2.1 which accompanies this distribution, and is available at
 * http://www.gnu.org/licenses/lgpl-2.1.html
 *
 * This code is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * Contributors:
 *     Jonas "Jonsen" Vothknecht
 */

String colorcode_red = "#ff0000";

class AchievementDescription
{
	AchievementDescription()
	{
		ui_identifier = "";
	}

	String[] m_name;
	String[] m_description;
	String[] m_imagePath;

	String ui_identifier;

	int achievementOffset;

	String name( int stage )
	{
		if( stage < 0 || uint(stage) >= m_name.length )
			return "NameOutOfBounds";
		return m_name[stage];
	}

	String description( int stage )
	{
		if( stage < 0 || uint(stage) >= m_description.length )
			return "DescriptionOutOfBounds";
		return m_description[stage];
	}

	String image( int stage )
	{
		if( stage < 0 || uint(stage) >= m_imagePath.length )
			return "/gfx/kandru/achievements/out_of_bounds";
		return m_imagePath[stage];
	}

}

class Fallback : AchievementDescription
{
	Fallback()
	{
		// AS is weird...
		String[] cp_name = { "" };
		String[] cp_description = { "" };
		String[] cp_imagePath = { "" };

		m_name = cp_name;
		m_description = cp_description;
		m_imagePath = cp_imagePath;

		achievementOffset = 75;
		ui_identifier = "fallback";
	}

	// Fallback is special, other achievementdescriptions dont need anything of the stuff below
	String name( int stage ) override
	{
		return "NameFallback";
	}

	String description( int stage ) override
	{
		return "DescriptionFallback";
	}

	String image( int stage )
	{
		return "/gfx/kandru/achievements/fallback";
	}
}

class Minesweeper : AchievementDescription
{
	Minesweeper()
	{
		// AS is weird...
		String[] cp_name = { "???", "Minesweeper" };
		String[] cp_description = { "Seek and you shall find.<br/>Step on it, nevermind...", "Ain't you got nothing better to do than playing minesweeper?<br/>(Trigger 400 enemy mines)" };
		String[] cp_imagePath = { "/gfx/kandru/achievements/locked", "/gfx/kandru/achievements/minesweeper" };

		m_name = cp_name;
		m_description = cp_description;
		m_imagePath = cp_imagePath;

		achievementOffset = 100;
		ui_identifier = "mw";
	}

}

class ChatKiller : AchievementDescription
{
	ChatKiller()
	{
		// AS is weird...
		String[] cp_name = { "???", "Chat Killer" };
		String[] cp_description = { "Don't try to get this one...", "Idiot...<br/>(Kill someone who is chatting)" };
		String[] cp_imagePath = { "/gfx/kandru/achievements/locked", "/gfx/kandru/achievements/chatkiller_normal" };

		m_name = cp_name;
		m_description = cp_description;
		m_imagePath = cp_imagePath;

		achievementOffset = 75;
		ui_identifier = "ck";
	}

}

class ChatKillerElite : AchievementDescription
{
	ChatKillerElite()
	{
		// AS is weird...
		String[] cp_name = { "???", "Chat Killer Elite" };
		String[] cp_description = { "You can't get this one either.", "Well, that was impressive!<br/>(Kill someone while chatting yourself)" };
		String[] cp_imagePath = { "/gfx/kandru/achievements/locked", "/gfx/kandru/achievements/chatkiller_elite" };

		m_name = cp_name;
		m_description = cp_description;
		m_imagePath = cp_imagePath;

		achievementOffset = 75;
		ui_identifier = "ce";
	}

}

class Lucker : AchievementDescription
{
	Lucker()
	{
		// AS is weird...
		String[] cp_name = { "Are you lucky?", "Lucker" };
		String[] cp_description = { "Manage to block 100 projectiles with your spawnprotection.", "Don't try and claim it was skill. It wasn't...<br/>You blocked 100 shots with your spawnprotection." };
		String[] cp_imagePath = { "/gfx/kandru/achievements/locked", "/gfx/kandru/achievements/lucker" };

		m_name = cp_name;
		m_description = cp_description;
		m_imagePath = cp_imagePath;

		achievementOffset = 75;
		ui_identifier = "l";
	}

}


class Kalle : AchievementDescription
{
	Kalle()
	{
		// AS is weird...
		String[] cp_name = { "???", "<span style='color:"+colorcode_red+";'>Kalle</span>" };
		String[] cp_description = { "This is impossible for some of you, but really easy for others..." ,"Your Ping was over 60 for at least 10 seconds" };
		String[] cp_imagePath = { "/gfx/kandru/achievements/locked", "/gfx/kandru/achievements/highping" };

		m_name = cp_name;
		m_description = cp_description;
		m_imagePath = cp_imagePath;

		achievementOffset = 75;
		ui_identifier = "p";
	}

}

class AdminKill : AchievementDescription
{
	AdminKill()
	{
		// AS is weird...
		String[] cp_name = { "Adminkiller", "Adminkiller" };
		String[] cp_description = { "Kill 50 admins to receive this achievement." ,"I hope you are not proud of yourself, just because you killed a couple of my friends..." };
		String[] cp_imagePath = { "/gfx/kandru/achievements/locked", "/gfx/kandru/achievements/adminkiller" };

		m_name = cp_name;
		m_description = cp_description;
		m_imagePath = cp_imagePath;

		achievementOffset = 75;
		ui_identifier = "ak";
	}

}

class PigHunter : AchievementDescription
{
	PigHunter()
	{
		// AS is weird...
		String[] cp_name = { "???", "Pig Hunter" };
		String[] cp_description = { "Go hunting! You need 100", "Sooo much ham...<br/>(Kill 100 players that use the padpork model)" };
		String[] cp_imagePath = { "/gfx/kandru/achievements/locked", "/gfx/kandru/achievements/pighunter" };

		m_name = cp_name;
		m_description = cp_description;
		m_imagePath = cp_imagePath;

		achievementOffset = 75;
		ui_identifier = "ph";
	}

}

class Coward : AchievementDescription
{
	Coward()
	{
		// AS is weird...
		String[] cp_name = { "???", "Coward" };
		String[] cp_description = { "Be a Coward...", "You are a coward ... Congratulations!" };
		String[] cp_imagePath = { "/gfx/kandru/achievements/locked", "/gfx/kandru/achievements/coward" };

		m_name = cp_name;
		m_description = cp_description;
		m_imagePath = cp_imagePath;

		achievementOffset = 75;
		ui_identifier = "co";
	}

}

class SpeedOMeter : AchievementDescription
{
	SpeedOMeter()
	{
		// AS is weird...
		String[] cp_name = { "SpeedOMeter", "Turtle", "Bunny", "Hawk", "RoadRunner" };
		String[] cp_description = { "Be faster than 1000.", "Be faster than 1300.", "Be faster than 2000.", "Be faster than 2500.", "Wow, you are a really fast dude ... over 2500, respect." };
		String[] cp_imagePath = { "/gfx/kandru/achievements/locked" };

		m_name = cp_name;
		m_description = cp_description;
		m_imagePath = cp_imagePath;

		achievementOffset = 75;
		ui_identifier = "rr";
	}

}

class BadLuck : AchievementDescription
{
	BadLuck()
	{
		// AS is weird...
		String[] cp_name = { "BadLuck", "BadLuck Bronze", "BadLuck Silver", "BadLuck Gold", "BadLuck Master" };
		String[] cp_description = { "Die 100 times in a single game.", "Die 120 times in a single game.", "Die 140 times in a single game.", "Die 160 times in a single game.", "You are a really poor guy..." };
		String[] cp_imagePath = { "/gfx/kandru/achievements/locked", "/gfx/kandru/achievements/badluck_bronze", "/gfx/kandru/achievements/badluck_silver" };

		m_name = cp_name;
		m_description = cp_description;
		m_imagePath = cp_imagePath;

		achievementOffset = 75;
		ui_identifier = "bl";
	}

}

class MassMurderer : AchievementDescription
{
	MassMurderer()
	{
		// AS is weird...
		String[] cp_name = { "Mass Murderer", "Mass Murderer Bronze", "Mass Murderer Silver", "Mass Murderer Gold", "Mass Murderer Master" };
		String[] cp_description = { "Kill 100 players to receive this award.", "You killed 100 players, go on,<br/>kill 500 players to be a silver mass murderer.", "You killed 500 players, go on,<br/>kill 2500 players to be a gold mass murderer.", "You killed 2500 players, go on,<br/>kill a total of at least 20000 players to be a master mass murderer.", "You already killed at least 20000 players.\nYou are a real Master Mass Murderer." };
		String[] cp_imagePath = { "/gfx/kandru/achievements/locked" };

		m_name = cp_name;
		m_description = cp_description;
		m_imagePath = cp_imagePath;

		achievementOffset = 100;
		ui_identifier = "mm";
	}

}

class Jumper : AchievementDescription
{
	Jumper()
	{
		// AS is weird...
		String[] cp_name = { "Jumper", "Tadpole", "Young Frog", "Frog", "Elder Frog" };
		String[] cp_description = { "Jumping is fun.", "You already jumped 100 times. 4900 more to go.", "Wohhh, 5000 jumps so far.\nWhats about 50000?", "Looks like u like jumping, 50000 so far.<br/>133700 for the last stage.", "You are definitely the god of jumping ... 133700 times so far." };
		String[] cp_imagePath = { "/gfx/kandru/achievements/locked" };

		m_name = cp_name;
		m_description = cp_description;
		m_imagePath = cp_imagePath;

		achievementOffset = 75;
		ui_identifier = "fr";
	}

}

class Regular : AchievementDescription
{
	Regular()
	{
		// AS is weird...
		String[] cp_name = { "Newbie", "Usual player", "Regular", "Freak", "Addict" };
		String[] cp_description = { "Do u like this gametype? Then keep playing.", "You played 1 hour on this server.", "You played 24 hours on this server.", "You already played 120 hours on our server.", "Do you have a reallife as well? You played 336 hours on our server. \nThanks u for supporting us." };
		String[] cp_imagePath = { "/gfx/kandru/achievements/locked" };

		m_name = cp_name;
		m_description = cp_description;
		m_imagePath = cp_imagePath;

		achievementOffset = 75;
		ui_identifier = "re";
	}

}

void AchievementsInit()
{
	@fallback = Fallback();

	if( descriptions.length != 0 )
		return;
	RegisterAchievementDescription( MassMurderer() );
	RegisterAchievementDescription( Kalle() );
	RegisterAchievementDescription( PigHunter() );
	RegisterAchievementDescription( Coward() );
	RegisterAchievementDescription( SpeedOMeter() );
	RegisterAchievementDescription( BadLuck() );
	RegisterAchievementDescription( Jumper() );
	RegisterAchievementDescription( Regular() );
	RegisterAchievementDescription( AdminKill() );
	RegisterAchievementDescription( Lucker() );
	RegisterAchievementDescription( ChatKiller() );
	RegisterAchievementDescription( ChatKillerElite() );
	RegisterAchievementDescription( Minesweeper() );

}

AchievementDescription@ fallback = null;
array<AchievementDescription@> descriptions;
void RegisterAchievementDescription( AchievementDescription @desc )
{
	if( @desc != null )
		descriptions.insertLast( desc );
}

AchievementDescription@ GetDescription( String identifier )
{
	for( uint i = 0; i < descriptions.length; i++ )
	{
		if( descriptions[i].ui_identifier == identifier )
			return descriptions[i];
	}
	return fallback;
}
