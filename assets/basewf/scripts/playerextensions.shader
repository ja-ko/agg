models/agungame/playerextensions/spikes
{
 nopicmip
 cull front

 if GLSL
 {
  // <base> <cellshade> [diffuse] [decal] [entitydecal] [stripes] [celllight]
  cellshade models/agungame/playerextensions/spikes.png env/cell
 }
 endif
 
 if ! GLSL

 {
  map models/agungame/playerextensions/spikes.png
 }
 
 if textureCubeMap //for 3d cards supporting cubemaps
 {
  shadecubemap env/cell
  blendFunc filter
 }
 endif

 if ! textureCubeMap //for 3d cards not supporting cubemaps
 {
  map gfx/colors/celshade.tga
  blendfunc filter
  tcGen environment
 }
 endif
 
 endif
}

models/agungame/playerextensions/wings
{
 nopicmip

 if GLSL
 {
  // <base> <cellshade> [diffuse] [decal] [entitydecal] [stripes] [celllight]
  cellshade models/agungame/playerextensions/wings.tga env/cell
 }
 endif
 
 if ! GLSL

 {
  map models/agungame/playerextensions/wings.tga
 }
 
 if textureCubeMap //for 3d cards supporting cubemaps
 {
  shadecubemap env/cell
  blendFunc filter
 }
 endif

 if ! textureCubeMap //for 3d cards not supporting cubemaps
 {
  map gfx/colors/celshade.tga
  blendfunc filter
  tcGen environment
 }
 endif
 
 endif
}

models/agungame/playerextensions/target
{
 nopicmip
 cull none

 if GLSL
 {
  // <base> <cellshade> [diffuse] [decal] [entitydecal] [stripes] [celllight]
  cellshade models/agungame/playerextensions/target.png env/cell
 }
 endif
 
 if ! GLSL

 {
  map models/agungame/playerextensions/target.png
 }
 
 if textureCubeMap //for 3d cards supporting cubemaps
 {
  shadecubemap env/cell
  blendFunc filter
 }
 endif

 if ! textureCubeMap //for 3d cards not supporting cubemaps
 {
  map gfx/colors/celshade.tga
  blendfunc filter
  tcGen environment
 }
 endif
 
 endif
}