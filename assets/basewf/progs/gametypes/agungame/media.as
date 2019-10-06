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

// TODO: get rid of this file

int[] MEDIA_weaponList( WEAP_TOTAL );

int AGG_WeaponImage( int weapon )
{
	if( weapon < WEAP_NONE || weapon >= WEAP_TOTAL )
		return 0;
	else
		return MEDIA_weaponList[weapon];
}

void AGG_MediaInit()
{
	MEDIA_weaponList[WEAP_NONE] = G_ImageIndex( "gfx/hud/icons/weapon/nogun_cross" );
	MEDIA_weaponList[WEAP_GUNBLADE] = G_ImageIndex( "gfx/hud/icons/weapon/gunblade" );
	MEDIA_weaponList[WEAP_MACHINEGUN] = G_ImageIndex( "gfx/hud/icons/weapon/machinegun" );
	MEDIA_weaponList[WEAP_RIOTGUN] = G_ImageIndex( "gfx/hud/icons/weapon/riot" );
	MEDIA_weaponList[WEAP_GRENADELAUNCHER] = G_ImageIndex( "gfx/hud/icons/weapon/grenade" );
	MEDIA_weaponList[WEAP_ROCKETLAUNCHER] = G_ImageIndex( "gfx/hud/icons/weapon/rocket" );
	MEDIA_weaponList[WEAP_PLASMAGUN] = G_ImageIndex( "gfx/hud/icons/weapon/plasma" );
	MEDIA_weaponList[WEAP_LASERGUN] = G_ImageIndex( "gfx/hud/icons/weapon/laser" );
	MEDIA_weaponList[WEAP_ELECTROBOLT] = G_ImageIndex( "gfx/hud/icons/weapon/electro" );
	MEDIA_weaponList[WEAP_INSTAGUN] = G_ImageIndex( "gfx/hud/icons/weapon/instagun" );
}

