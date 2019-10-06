
/*
 * (C) Copyright 2013 Jannik "drahti" Kolodziej
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
 */

Element @star1;
Element @star2;
Element @star3;
Element @star4;
Element @star5;


void onStarRatingShow( Element @body, Event @evt )
{
	@star1 = @body.getElementById( "star1" );
	@star2 = @body.getElementById( "star2" );
	@star3 = @body.getElementById( "star3" );
	@star4 = @body.getElementById( "star4" );
	@star5 = @body.getElementById( "star5" );
	
	refreshStarRating();
}

void onStarClick( Element @star, Event @evt )
{
	if( @star == null )
		return;
	
	Cvar rating( "cg_agg_rating", "-", CVAR_ARCHIVE );
	
	if( @star == @star1 )
		rating.set( "1" );
		
	if( @star == @star2 )
		rating.set( "2" );
	
	if( @star == @star3 )
		rating.set( "3" );
	
	if( @star == @star4 )
		rating.set( "4" );
	
	if( @star == @star5 )
		rating.set( "5" );
		
	refreshStarRating();
}

void refreshStarRating()
{
	Cvar rating( "cg_agg_rating", "-", CVAR_ARCHIVE );
	if( @star1 == null || @star2 == null || @star3 == null || @star4 == null || @star5 == null )
		return;
	
	if( rating.string == "-" )
		setActiveStars( 0 );
	else if( rating.string == "1" )
		setActiveStars( 1 );
	else if( rating.string == "2" )
		setActiveStars( 2 );
	else if( rating.string == "3" )
		setActiveStars( 3 );
	else if( rating.string == "4" )
		setActiveStars( 4 );
	else if( rating.string == "5" )
		setActiveStars( 5 );
}

void setActiveStars( int count )
{
	if( @star1 == null || @star2 == null || @star3 == null || @star4 == null || @star5 == null )
		return;
		
	DeselectStar( star1 );
	DeselectStar( star2 );
	DeselectStar( star3 );
	DeselectStar( star4 );
	DeselectStar( star5 );
	
	if( count > 0 )
		SelectStar( star1 );
	if( count > 1 )
		SelectStar( star2 );
	if( count > 2 )
		SelectStar( star3 );
	if( count > 3 )
		SelectStar( star4 );
	if( count > 4 )
		SelectStar( star5 );
}

void SelectStar( Element @star )
{
	if( @star == null )
		return;
	star.setClass( "star", false );
	star.setClass( "star-selected", true );
}

void DeselectStar( Element @star )
{
	if( @star == null )
		return;
	star.setClass( "star-selected", false );
	star.setClass( "star", true );
}
