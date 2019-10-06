

const String MapLocation_BackgroundMapRml = "<img nocache='1' class='maplocation-backgroundmap' src='' onmouseover='$maplocation_handleMouseOver' onmouseout='$maplocation_handleMouseOut' onmousemove='$maplocation_handleMouseMove' onclick='$maplocation_handleMouseClick' />";

class MapLocationSelector
{
	Element @container;
	Element @mapPicture;
	array<Element@>@ overlayItems;
	
	MapLocationSelector( Element @elem )
	{
		if( @elem == null )
			return;
		
		if( elem.getElementsByClassName( "maplocation-backgroundmap" ).length != 1 )
			createMapSelector( elem );
		else
			createFromElement( elem );
	}
	
	void createMapSelector( Element @elem )
	{
		@container = @elem;
		container.setInnerRML( MapLocation_BackgroundMapRml );
		@mapPicture = container.getElementsByClassName( "maplocation-backgroundmap" )[0];
	}
	
	void createFromElement( Element @elem )
	{
		@container = @elem;
		@mapPicture = @elem.getElementsByClassName( "maplocation-backgroundmap" )[0];
		@overlayItems = elem.getElementsByClassName( "maplocation-item" );
	}
	
	void refreshMapPicture()
	{
		if( @container == null )
			return;
		
		if( @mapPicture == null )
		{
			container.setInnerRML( MapLocation_BackgroundMapRml );
			@mapPicture = container.getElementsByClassName( "maplocation-backgroundmap" )[0];
		}
		if( game.clientState < CA_ACTIVE )
			return;
		String @mapname = @game.cs( CS_MAPNAME );
		if( @mapname == null || mapname.len() == 0 )
			return;
			
		game.print( "mapname: " + mapname + "\n" );
		
		//mapPicture.setAttr( "src", "/minimaps/" + mapname );
		mapPicture.setAttr( "src", "/gfx/kandru/" + mapname );
		mapPicture.setAttr( "width", container.css( "width" ) );
		mapPicture.setAttr( "height", container.css( "height" ) );
	}
	
	void addItemOverlay( String overlayImage, int x, int y, int size_x, int size_y )
	{
		x -= size_x / 2;
		y -= size_y / 2;
		String elem = "<img class='maplocation-item' src='" + overlayImage + "' width='" + size_x + "' height='" + size_y + "' style='position:absolute; top: " + y + "px; left: " + x + "px;' />";
		container.setInnerRML( container.getInnerRML() + elem );
		Element @image = @container.getElementsByClassName( "maplocation-item" )[container.getElementsByClassName( "maplocation-item" ).length-1];
		if( @overlayItems == null )
			@overlayItems = array<Element@>();
		overlayItems.insertLast( image );
	}
	
	void execCommand( String args )
	{
		if( @container == null )
			return;
		String cmd = container.getAttr( "cmd", "" );
		if( cmd == "" )
			return;
		
		game.execAppend( cmd + " " + args + ";" );
	}
	
	void handleMouseEnter( Element @elem, Event @evt )
	{
		
	}
	
	void handleMouseLeave( Element @elem, Event @evt )
	{
		
	}
	
	void handleMouseMove( Element @elem, Event @evt )
	{
		
	}
	
	void handleMouseClick( Element @elem, Event @evt )
	{
		int mouse_x = evt.getParameter( "mouse_x", "0" ).toInt();
		int mouse_y = evt.getParameter( "mouse_y", "0" ).toInt();
		
		int top = container.css( "top" ).substr(0, container.css( "top" ).locate("px", 0) ).toInt();
		int left = container.css( "left" ).substr(0, container.css( "left" ).locate("px", 0) ).toInt();
		
		int width = container.css( "width" ).substr(0, container.css( "width" ).locate("px", 0) ).toInt();
		int height = container.css( "height" ).substr(0, container.css( "height" ).locate("px", 0) ).toInt();
		
		top = mouse_y - top;
		left = mouse_x - left;
		
		float percX = float(left) / float(width);
		float percY = float(top) / float(height);

		execCommand( percX + " " + percY );
	}
	
}

void maplocation_handleMouseOver( Element @elem, Event @evt )
{
	MapLocationSelector selector( elem.getParent() );
	selector.handleMouseEnter( elem, evt );
}

void maplocation_handleMouseOut( Element @elem, Event @evt )
{
	MapLocationSelector selector( elem.getParent() );
	selector.handleMouseLeave( elem, evt );
}

void maplocation_handleMouseMove( Element @elem, Event @evt )
{
	MapLocationSelector selector( elem.getParent() );
	selector.handleMouseMove( elem, evt );
}

void maplocation_handleMouseClick( Element @elem, Event @evt )
{
	MapLocationSelector selector( elem.getParent() );
	selector.handleMouseClick( elem, evt );
}
