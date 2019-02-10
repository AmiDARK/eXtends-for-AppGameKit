
// ************************************************************ eXtends dynamic list handler
#insert  "../eXtends/eXtends_Setup.agc"
#include "../eXtends/eXtends_DynamicListHandler.agc"
// ************************************************************ Fake Bitmap inserts
#insert  "../eXtends/eXtends_Bitmap_Setup.agc"                      // DarkBASIC Professional bitmap emulation inserts
#include "../eXtends/eXtends_Bitmap.agc"                           // DarkBASIC Professional bitmap emulation inserts
// ************************************************************ Basic 2D inserts
#insert  "../eXtends/eXtends_Basic2D.agc"                           // Needed for any Basic2D inserts
#include "../eXtends/eXtends_Basic2D_XWindow.agc"                  // Needed for all XWindows functions
#include "../eXtends/eXtends_Basic2D_XFont.agc"                    // Needed for all XFont & XWindows functions
#include "../eXtends/eXtends_Basic2D_XGadgets.agc"                 // Needed for all XGadgets & XWindows functions
// ************************************************************ Basic 3D inserts
#insert  "../eXtends/eXtends_Basic3D_Setup.agc"                     // Needed for any Basic3D inserts
#include "../eXtends/eXtends_Basic3D.agc"                          // Needed for Basic3D functions
#include "../eXtends/eXtends_Basic3D_Billboards.agc"               // Needed for Basic3D Billboards functions
#include "../eXtends/eXtends_Basic3D_Maths.agc"                    // Needed for Basic3D Mathematics functions
#include "../eXtends/eXtends_Basic3D_VirtualLights.agc"            // Needed for Basic3D Virtual Lights calculations.
// ************************************************************ Images inserts
#insert  "../eXtends/eXtends_HighScores_Setup.agc"                  // Liste des fonctions présentes dans le module Image
#include "../eXtends/eXtends_HighScores.agc"                       // Support for specific 2D Image drawing functions.
// ************************************************************ Images inserts
#insert  "../eXtends/eXtends_Image_Setup.agc"                       // Liste des fonctions présentes dans le module Image
#include "../eXtends/eXtends_Image.agc"                            // Support for specific 2D Image drawing functions.
// ************************************************************ Memblocks Functions
#Insert  "../eXtends/eXtends_Memblocks_Setup.agc"
#include "../eXtends/eXtends_Memblocks.agc"
// ************************************************************ Particles 3D inserts
#insert  "../eXtends/eXtends_Particles3D_Setup.agc"
#include "../eXtends/eXtends_Particles3D.agc"
// ************************************************************ Real Time Sky System
#insert  "../eXtends/eXtends_RTSkybox_Setup.agc"
#include "../eXtends/eXtends_RTSkybox.agc"
// ************************************************************ Images inserts
#insert  "../eXtends/eXtends_Sprites2D_Setup.agc"                   // Liste des fonctions présentes dans le module Image
#include "../eXtends/eXtends_Sprites2D.agc"                        // Support for specific 2D Image drawing functions.
// ************************************************************ DarkBASIC Professional text inserts
#insert  "../eXtends/eXtends_Text_Setup.agc"
#include "../eXtends/eXtends_Text.agc"

// show all errors
SetErrorMode(2)

// set window properties
SetWindowTitle( "eXtends" )
SetWindowSize( 1920, 1200, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 60, 0 ) // 60fps on computer
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts


Rem ***************************************************
Rem *                                                 *
Rem * DarkBasic Professional Extends TPC Pack Ver 1.0 *
Rem *                                                 *
Rem ***************************************************
Rem Author : Frédéric Cordier - Odyssey-Creators
Rem Date   : 2008.February.16
Rem Sample : 4 Flames Particles Support Demo
Rem 
SetFogMode( 1 ) // Fog On

SetFogColor( 8, 8, 8 )
SetFogSunColor( 32, 32, 32 )
SetSunDirection( 0.0, -0.1, 0.0 )
SetSunActive( 1 )

RAINDROP = LoadImage( "raindrop.png" )
GROUND = LoadImage( "multi018.jpg" )
REM We check if DBProBasic3DExtends.dll is correctly initialized
  OBJECT1 = CreateObjectPlane( 1024 , 1024 )
  SetObjectRotation( OBJECT1 , 270 , 0 , 0 )
  SetObjectImage( OBJECT1 , GROUND, 0 )
  SetObjectPosition( OBJECT1, 0, -8, 0 )

  Particle1 = P3D_AddParticles( 500, 0, 4 )
  P3D_PositionParticles( Particle1, 0, 0, 0 )
  P3D_SetEmitterRange( Particle1, 1024, 512, 1024 )
  P3D_SetAsRain( Particle1 )

  Particle2 = P3D_AddParticles( 500, RAINDROP, 32 )
  P3D_PositionParticles( Particle2, 0, 16, 0 )
  P3D_SetEmitterRange( Particle2, 1024, 8, 1024 )
  P3D_SetAsSparkle( Particle2 )


Count = 0

For XLoop = 1 to 32
  If GetObjectExists( XLoop ) = 1 Then Inc Count , 1
 Next XLoop

Rem Main Demo Loop
Repeat
  // Set Cursor 0 , 0 : Print "Frame Rate : ", Screen Fps()
  // Print "Press 1 to jump to 60 fps max"
  // Print "Press 2 to jump to max fps"
  // Print Image Exist( 2 )
  // D$ = Inkey$()
  // If d$="1" Then Sync Rate 60
  // If d$="2" Then Sync Rate 0
  YAdd As Integer = 0 : YAdd = ( GetRawKeyState( 39 ) - GetRawkeyState( 37 ) )
  XAdd As Integer = 0 : XAdd = ( GetRawKeyState( 38 ) - GetRawKeyState( 40 ) )
  YAngle = YAngle + YAdd
  XAngle = XAngle + XAdd
  SetCameraPosition( 1, 0, 50, 0 )
  SetCameraRotation( 1, XAngle, YAngle, 0 )
  XMove As Float : XMove = ( ( GetRawMouseLeftPressed() = 1 ) - ( GetRawMouseRightPressed() = 2 ) ) * 5.0

  P3D_UpdateParticles()
  B3D_RefreshBillBoards()

  Sync()

 Until GetRawKeyPressed( 32 ) = 1

DeleteObject( OBJECT1 )
Particle4 = P3D_DeleteParticle( Particle4 )
Particle3 = P3D_DeleteParticle( Particle3 )
Particle2 = P3D_DeleteParticle( Particle2 )
Particle1 = P3D_DeleteParticle( Particle1 )
// DeleteImage( FLAMES )
DeleteImage( GROUND )
End
