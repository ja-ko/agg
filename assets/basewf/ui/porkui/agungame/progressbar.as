
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

const String PROGRESSBAR_LEFT_IMAGELEFT = "/test/progressbar_left_left.tga";
const String PROGRESSBAR_LEFT_IMAGECENTER = "/test/progressbar_left_center.tga";
const String PROGRESSBAR_LEFT_IMAGERIGHT = "/test/progressbar_left_right.tga";

const String PROGRESSBAR_RIGHT_IMAGELEFT = "/test/progressbar_right_left.tga";
const String PROGRESSBAR_RIGHT_IMAGECENTER = "/test/progressbar_right_center.tga";
const String PROGRESSBAR_RIGHT_IMAGERIGHT = "/test/progressbar_right_right.tga";

const int PROGRESSBAR_HEIGHT = 22;

class Progressbar
{
	Element @container;
	Element @left;
	Element @right;

	bool failed;

	float value;

	Progressbar( Element @elem )
	{
		@container = @elem;
		if( @elem == null )
		{
			failed = true;
			return;
		}

		@left = @container.firstChild();
		@right = @container.lastChild();

		if( @left == null || @right == null || !left.hasAttr( "progressbar" ) || !right.hasAttr( "progressbar" ) )
		{
			String content = "<div class='progressbar_left' progressbar='left'> </div>";
			content += "<div class='progressbar_right' progressbar='right'> </div>";
			container.setInnerRML( content );

			@left = @container.firstChild();
			@right = @container.lastChild();
		}

		left.css( "height", PROGRESSBAR_HEIGHT + "px" );
		right.css( "height", PROGRESSBAR_HEIGHT + "px" );
		container.css( "height", PROGRESSBAR_HEIGHT + "px" );
		container.css( "position", "absolute" );

		failed = false;
		//setValueInstant( 0.0f );
	}

	void setValueInstant( float inValue )
	{
		if( failed )
			return;

		value = inValue;
		value = ( value < 0.0f ) ? 0.0f : value;
		value = ( value > 1.0f ) ? 1.0f : value;

		int leftWidth = int( value * 100.0f );
		int rightWidth = int( 100.0f - leftWidth );

		if( leftWidth <= 0 )
			emptyBar();
		else if( leftWidth >= 100 )
			fullBar();
		else
		{
			left.removeClass( "progressbar_full" );
			left.removeClass( "progressbar_empty" );
			left.setClass( "progressbar_left", true );
			left.css( "width", leftWidth + "%" );
			right.css( "display", "block" );
			right.css( "width", rightWidth + "%" );
			right.css( "left", leftWidth + "%" );
		}
	}

	void fullBar()
	{
		left.removeClass( "progressbar_left" );
		left.removeClass( "progressbar_empty" );
		left.setClass( "progressbar_full", true );
		left.css( "width", "100%" );
		right.css( "display", "none" );
	}

	void emptyBar()
	{
		left.removeClass( "progressbar_left" );
		left.removeClass( "progressbar_full" );
		left.setClass( "progressbar_empty", true );
		left.css( "width", "100%" );
		right.css( "display", "none" );
	}
}
