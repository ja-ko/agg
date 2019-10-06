
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

class ModelViewer
{
	private Element @m_elem;
	
	ModelViewer( Element @inElem )
	{
		@m_elem = @inElem;
	}
	
	void set_element( Element @elem )
	{
		ModelViewer old( m_elem );
		@m_elem = @elem; 
		if( @old.get_element() != null && @m_elem != null )
		{
			modelPath = old.modelPath;
			modelFov = old.modelFov;
			modelScale = old.modelScale;
			outlineHeight = old.outlineHeight;
			outlineColor = old.outlineColor;
			shaderColor = old.shaderColor;
			rotationX = old.rotationX;
			rotationY = old.rotationY;
			rotationZ = old.rotationZ;
			rotationSpeedX = old.rotationSpeedX;
			rotationSpeedY = old.rotationSpeedY;
			rotationSpeedZ = old.rotationSpeedZ;
		}
	}
	
	Element@ get_element()
	{
		return @m_elem;
	}
	
	void set_modelPath( String model )
	{
		if( @m_elem == null )
			return;
		m_elem.setProp( "model-modelpath", model );
	}
	
	String get_modelPath()
	{
		if( @m_elem == null )
			return "";
		return m_elem.getProp( "model-modelpath" );
	}
	
	void set_modelFov( String fov )
	{
		if( @m_elem == null )
			return;
		m_elem.setProp( "model-fov-x", fov );
	}
	
	String get_modelFov()
	{
		if( @m_elem == null )
			return "";
		return m_elem.getProp( "model-fov-x" );
	}
	
	void set_modelScale( String scale )
	{
		if( @m_elem == null )
			return;
		m_elem.setProp( "model-scale", scale );
	}
	
	String get_modelScale()
	{
		if( @m_elem == null )
			return "";
		return m_elem.getProp( "model-scale" );
	}
	
	void set_outlineHeight( String height )
	{
		if( @m_elem == null )
			return;
		m_elem.setProp( "model-outline-height", height );
	}
	
	String get_outlineHeight()
	{
		if( @m_elem == null )
			return "";
		return m_elem.getProp( "model-outline-height" );
	}
	
	void set_outlineColor( String hex )
	{
		if( @m_elem == null )
			return;
		m_elem.setProp( "model-outline-color", hex );
	}
	
	String get_outlineColor()
	{
		if( @m_elem == null )
			return "";
		return m_elem.getProp( "model-outline-color" );
	}
	
	void set_shaderColor( String hex )
	{
		if( @m_elem == null )
			return;
		m_elem.setProp( "model-shader-color", hex );
	}
	
	String get_shaderColor()
	{
		if( @m_elem == null )
			return "";
		return m_elem.getProp( "model-shader-color" );
	}
	
	void set_rotationX( String rotation )
	{
		if( @m_elem == null )
			return;
		m_elem.setProp( "model-rotation-pitch", rotation );
	}
	
	String get_rotationX()
	{
		if( @m_elem == null )
			return "";
		return m_elem.getProp( "model-rotation-pitch" );
	}
	
	void set_rotationY( String rotation )
	{
		if( @m_elem == null )
			return;
		m_elem.setProp( "model-rotation-yaw", rotation );
	}
	
	String get_rotationY()
	{
		if( @m_elem == null )
			return "";
		return m_elem.getProp( "model-rotation-yaw" );
	}
	
	void set_rotationZ( String rotation )
	{
		if( @m_elem == null )
			return;
		m_elem.setProp( "model-rotation-roll", rotation );
	}
	
	String get_rotationZ()
	{
		if( @m_elem == null )
			return "";
		return m_elem.getProp( "model-rotation-roll" );
	}
	
	void set_rotationSpeedX( String speed )
	{
		if( @m_elem == null )
			return;
		m_elem.setProp( "model-rotation-speed-pitch", speed );
	}
	
	String get_rotationSpeedX()
	{
		if( @m_elem == null )
			return "";
		return m_elem.getProp( "model-rotation-speed-pitch" );
	}
	
	void set_rotationSpeedY( String speed )
	{
		if( @m_elem == null )
			return;
		m_elem.setProp( "model-rotation-speed-yaw", speed );
	}
	
	String get_rotationSpeedY()
	{
		if( @m_elem == null )
			return "";
		return m_elem.getProp( "model-rotation-speed-yaw" );
	}
	
	void set_rotationSpeedZ( String speed )
	{
		if( @m_elem == null )
			return;
		m_elem.setProp( "model-rotation-speed-roll", speed );
	}
	
	String get_rotationSpeedZ()
	{
		if( @m_elem == null )
			return "";
		return m_elem.getProp( "model-rotation-speed-roll" );
	}
}
