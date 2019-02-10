
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
SetWindowSize( 1280, 1024, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 640, 480 ) // doesn't have to match the window
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
Rem Sample : Wobble Effect
Rem

SourceImage = LoadImage( "saf.jpg" )

Rem Set Amplitude, Speed, Step
Amplitude As Integer = 8
Speed As Integer = 1
mStep As Integer = 1
SetImageWobbleValues( Amplitude, Speed, mStep )

do

ClearScreen()
dbCenterText( ( xtGetBitmapWidth( 0 ) /2 ), 0, "DarkBASIC Professional 2 AppGameKIT - Extends PlugIn" )
dbCenterText( ( xtGetBitmapWidth( 0 ) /2 ), 12, "Wobble Effect Demonstration" )
dbCenterText( ( xtGetBitmapWidth( 0 ) /2 ), 36, "Press 1-2 to decrease/increase amplitude" )
dbCenterText( ( xtGetBitmapWidth( 0 ) /2 ), 48, "Press 4-5 to decrease/increase speed" )
dbCenterText( ( xtGetBitmapWidth( 0 ) /2 ), 60, "Press 7-8 to decrease/increase step" )
dbCenterText( ( xtGetBitmapWidth( 0 ) / 2 ), 76, "Press 9-6 to set SyncRate(60)/SyncRate(MAX)" )

  Amplitude = Amplitude + GetRawKeyState( 50 ) - GetRawKeyState( 49 )
  if Amplitude < 1 Then Amplitude = 1 
  Speed = Speed + GetRawKeyState( 53 ) - GetRawKeyState( 52 )
  if Speed < 1 Then Speed = 1
  mStep = mStep + GetRawKeyState( 56 ) - GetRawKeyState( 55 )
  if mStep < 1 Then mStep = 1  
  if GetRawKeyState( 57 ) = 1 Then SetSyncRate( 0, 0 )
  if GetRawKeyState( 54 ) = 1 Then SetSyncRate( 60, 0 )
   SetImageWobbleValues( Amplitude, Speed, mStep )
  Image = ImageWobbleEx( SourceImage, 2 )
  PasteImage( 2, ( xtGetBitmapWidth( 0 ) - GetImageWidth( 2 ) ) / 2 , 80 )
  dbSetCursor( 0, 80 )
  dbPrint( "AMPLITUDE : " + Str( Amplitude ) )
  dbPrint( "SPEED     : " + Str( Speed ) )
  dbPrint( "STEP      : " + Str( mStep ) )
  dbPrint( "FRAMERATE : " + Str( ScreenFPS() ) )
  Sync()
loop

DeleteImage( SourceImage )
DeleteImage( 2 )

End
