
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
Rem Sample : Old Super Nintendo Mosaics Style Demonstration
Rem

SourceImage = LoadImage( "saf.jpg" )
PasteImage( 1, 0, 80 )
Sync()
_Image As Integer = 0
_mos As Integer = 1 : _mos2 As Integer : _mode As Integer = 0 : _update As Integer = 1
do

ClearScreen()
dbCenterText( ( xtGetBitmapWidth( 0 ) / 2 ), 0, "DarkBASIC Professional 2 AppGameKIT - Extends PlugIn" )
dbCenterText( ( xtGetBitmapWidth( 0 ) / 2 ), 12, "Mosaics Effect Demonstration" )
dbCenterText( ( xtGetBitmapWidth( 0 ) / 2 ), 36, "Press 1-2 to Enable/Disable noise" )
dbCenterText( ( xtGetBitmapWidth( 0 ) / 2 ), 48, "Press 3-4 to to decrease/increase Mosaic value" )
dbCenterText( ( xtGetBitmapWidth( 0 ) / 2 ), 60, "Press 5-6 to switch calculation modes to Memblock/DirectImage" )
dbCenterText( ( xtGetBitmapWidth( 0 ) / 2 ), 76, "Press 7-8 to set SyncRate(60)/SyncRate(MAX)" )
dbCenterText( ( xtGetBitmapWidth( 0 ) / 2 ), 92, "Press 9 to refresh Zoom (usefull with noise=ON" )

  _mos2 = _mos - GetRawKeyState( 51 ) + GetRawKeyState( 52 )
  if _mos2 < 1 Then _mos2 = 1
  if _mos2 <> _mos then _update = 1
  _mos = _mos2
  If GetRawKeyState( 49 ) = 1 : _mode = 1 : _update = 1 : Endif
  If GetRawKeyState( 50 ) = 1 : _mode = 0 : _update = 1 : Endif
  If GetRawKeyState( 53 ) = 1 : SetZoomMode( 0 ) : Endif
  If GetRawKeyState( 54 ) = 1 : SetZoomMode( 1 ) : Endif
  If GetRawKeyState( 55 ) = 1 : SetSyncRate( 60, 0 ) : Endif
  If GetRawKeyState( 56 ) = 1 : SetSyncRate( 0, 0 ) : Endif
  If GetRawKeyState( 57 ) = 1 : _update = 1 : Endif
  if _update = 1
    If _Image > 0 Then DeleteImage( _Image )
    _Image = ImageMosaicEx( SourceImage, _mos, _mode, 0 )
    _update = 0
   endif
  if _Image > 0
    if GetImageExists( _Image ) = 1 then PasteImage( _Image, 0, 80 )
    else
		PasteImage( 1, 0, 80 )
   Endif
  dbSetCursor( 0, 80 )
  dbprint( "Mosaic value : " + Str( _mos ) )
  If _mode = 1
	  dbPrint( "Noise mode   : Enabled" )
	Else
	  dbPrint( "Noise mode   : Disabled" )
	Endif
  dbPrint( "Frame Rate   : " + Str( ScreenFPS() ) )
  Sync()
 Loop
End
