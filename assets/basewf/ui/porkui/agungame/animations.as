
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

// This class is really similar to my original animations.as found in ui/porkui/as/
// in ui_porkui.pk3 of your warsow install directory
// However, this class has been reworked, and offers a lot more possibilities now

const int ANIMTYPE_POSITIONX = 0x1;
const int ANIMTYPE_POSITIONY = 0x2;
const int ANIMTYPE_OPACITY = 0x4; // Won't work with images (only with elements that support the color css attribute)

funcdef void AnimDoneCallback( Element @elem );

array<Animation@> animList;

void DeleteAllAnimations()
{
	while( animList.length > 0 )
		animList[0].free();
}

class Animation
{
	int animTime;
	int animStartTime;
	uint animType;
	Vec3 animStartValue;
	Vec3 animDestValue;
	int animEase;
	Element @animElement;
	AnimDoneCallback @animDoneCb;

	bool disable;

	Animation( Element @elem, AnimDoneCallback @animDoneCallback = null )
	{
		@animElement = @elem;
		animTime = 500;
		animStartValue = Vec3(0,0,0);
		animDestValue = Vec3(0,0,0);
		animEase = EASE_NONE;
		animType = 0;

		disable = false;

		@animDoneCb = @animDoneCallback;

		animList.insertLast( @this );
	}

	~Animation( )
	{
		@animDoneCb = null;
		@animElement = null;
	}

	void free()
	{
		@animDoneCb = null;
		@animElement = null;

		disable = true;

		animList.removeAt( animList.find( this ) );
	}

	void setAnimPositionsX( int start, int dest )
	{
		animStartValue.x = start;
		animDestValue.x = dest;
		animType |= ANIMTYPE_POSITIONX;
	}

	void setAnimPositionsY( int start, int dest )
	{
		animStartValue.y = start;
		animDestValue.y = dest;
		animType |= ANIMTYPE_POSITIONY;
	}

	void setAnimOpacities( int start, int dest )
	{
		animStartValue.z = start;
		animDestValue.z = dest;
		animType |= ANIMTYPE_OPACITY;
	}

	void setAnimDuration( int duration )
	{
		animTime = duration;
	}

	void setAnimEase( int ease )
	{
		animEase = ease;
	}

	void startAnimation()
	{
		if( @animElement == null || animTime <= 0 )
			return;
		animStartTime = window.time;
		if( (animType & ANIMTYPE_POSITIONX) != 0 )
		{
			animElement.css( "position", "absolute" )
				.css( "left", animStartValue.x + "px" );
		}
		if( (animType & ANIMTYPE_POSITIONY) != 0 )
		{
			animElement.css( "position", "absolute" )
				.css( "top", animStartValue.y + "px" );
		}
		if( (animType & ANIMTYPE_OPACITY) != 0 )
		{
			String color = animElement.css( "color" );
			if( color == "" || color.substr( 0, 4 ) != "rgba" )
				color = "255, 255, 255";
			else
				color = color.substr( 0, color.locate( ",", 2 ) );
			animElement.css( "color", "rgba(" + color + ", " + animStartValue.z + ")" );
		}
		window.setInterval( __AnimationCallback, 10, any(@this) );
	}

	bool animate() // do not call this one, it's just for the scheduler
	{
		if( @animElement == null || animTime <= 0 )
			return false; // something went wrong

		if( disable )
			return false;

		float frac;

		if( animTime > 0 )
		{
			frac = float( window.time - animStartTime ) / animTime;
			frac = applyEase( frac, animEase );
			if( frac > 1 )
				frac = 1;
		}
		else
		{
			frac = 1;
		}
		if( (animType & ANIMTYPE_POSITIONX) != 0 )
		{
			setElementValue( 'left', int(animStartValue.x), int(animDestValue.x), frac );
		}
		if( (animType & ANIMTYPE_POSITIONY) != 0 )
		{
			setElementValue( 'top', int(animStartValue.y), int(animDestValue.y), frac );
		}
		if( (animType & ANIMTYPE_OPACITY) != 0 )
		{
			setElementOpacity( int(animStartValue.z), int(animDestValue.z), frac );
		}

		if( frac == 1 ) 					// we are done
		{
			if( @animDoneCb is null )		// check whether we need to inform someone that we are done
				return false;				// doesn't look like it
			else
				animDoneCb( animElement );
			return false;
		}
		return true; // continue to call this function
	}

	private void setElementValue( String prop, int start, int dest, float frac )
	{
		int tmp = dest - start;
		tmp = start + int( float( tmp ) * frac );
		animElement.css( prop, tmp + "px" );
	}

	private void setElementOpacity( int start, int dest, float frac )
	{
		int tmp = dest - start;
		tmp = start + int( float( tmp ) * frac );

		String color = animElement.css( "color" );
		if( color == "" || color.substr( 0, 4 ) != "rgba" )
			color = "255, 255, 255, ";
		else
			color = color.substr( 0, color.locate( ",", 2 ) ) + ", ";

		animElement.css( "color", "rgba(" + color + tmp + ")" );
	}

	bool opEquals(Animation @anim)
	{
        return anim is this;
	}
}

bool __AnimationCallback( any & obj ) // this one will serve as a relay, handing scheduler-call over to the class
{
	Animation @anim;
	obj.retrieve(@anim);

	if( @anim == null )
		return false; // something went wrong, just disable that scheduler

	return anim.animate();
}

