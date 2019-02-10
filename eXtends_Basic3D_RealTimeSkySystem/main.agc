
// ************************************************************ eXtends setup variables
#insert  "../eXtends/eXtends_Setup.agc"
// ************************************************************ eXtends dynamic list handler
#include "../eXtends/eXtends_DynamicListHandler.agc"
// ************************************************************ eXtends error Handler methods
#include "../eXtends/eXtends_errorHandler.agc"
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

// TO DO : 
// - Réinjecter la sensibilité lumière a FarAway.x
//      Mais intégrer la mise à jour de l'intensité lumière ambiante sur le cycle pour que tout le FarAway soit bien éclairé en plein jour
// - Récupérer les coordonnées d'affichage du soleil 3D dans le ciel et l'utiliser pour récupérer 4 pixels dedans après tracé des nuages.
//      L'intensité global de la moyenne des 4 points définira l'intensité lumineuse globale de l'environnement graphique.

// show all errors
SetErrorMode(2)

// set window properties
SetWindowTitle( "eXtends" )
SetWindowSize( 640, 480, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 640, 480 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 60, 0 ) // 60fps on computer
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

CLOUDP = 25
Dim OBJ[ 7 ]

dbInkEx( 255, 255, 255 )
StartTextInput()
Repeat
	ClearScreen()
	dbSetCursor( 0,0 )
	// Here is a print with a really long texte that should be displayed in more than one line to test how my engine handle the multi-line text writing.
	dbPrint( "Real Time SkySystem Ver1.0 by Frederic Cordier (c)2006-2019" )
	dbPrint( "Select which skysystem you want to see :" )
	dbPrint( "1 = Big city - polluted" )
	dbPrint( "2 = Snow mountains - Big blue" )
	dbPrint( "3 = Massive mountains" )
	dbPrint( "4 = Desert mountains" )
	dbPrint( "5 = Desert mountains 2" )
	dbRefresh()
	Sync()
Until GetTextInputCompleted() = 1

// Backdrop On
Select getTextInput()
	Case "1" : RTS_RealTimeSky_Setup( "RTS_BigCity" ) : EndCase
	Case "2" : RTS_RealTimeSky_Setup( "RTS_SnowMountain" ) : EndCase
	Case "3" : RTS_RealTimeSky_Setup( "RTS_MassiveMountain" ) : EndCase
	Case "4" : RTS_RealTimeSky_Setup( "RTS_DesertMountain" ) : EndCase
	Case "5" : RTS_RealTimeSky_Setup( "RTS_DesertMountain2" ) : EndCase
EndSelect
SetClearColor( 255, 255, 255 )
RTS_RealTime_SetClock( 16 , 0 , 10.0 )
RTS_SetWind( -0.80, 0.20 )
RTS_SetAutoZoom( 0.005 )
RTS_CloudPersistence( 255 )
RTS_SetMistAlpha( 0 )
RTS_SetFogControlOn()
// Set Camera Range 1 , 110000
// Clear Camera View 0 , Rgb( 0 , 0 , 0 )
SetCameraPosition( 1, 0 , 0 , 0 )
SetCameraRange( 1, 10, 50000 )
SetClearColor( 0, 0, 0 )
do
	ClearScreen()
	SetCameraPosition( 1, 0, 0, 0 )
	// XAngle As Float : XAngle = ( ( GetPointerY() - GetWindowHeight() ) / 4 ) + 180.0
	// YAngle As Float : YAngle = ( GetPointerX() / 4 ) + 90.0
	YAdd As Integer : YAdd = ( GetRawKeyState( 39 ) - GetRawkeyState( 37 ) )
	XAdd As Integer : XAdd = ( GetRawKeyState( 38 ) - GetRawKeyState( 40 ) )
	YAngle = YAngle + YAdd
	XAngle = XAngle + XAdd
	SetCameraRotation( 1, XAngle , YAngle, 0 )
	RTSkySystem_Update()
	dbSetCursor( 0 , 0 )
	dbPrint( "Frame Rate : " + str( ScreenFps() ) )
	dbPrint( "Clock : " + Str( Round( RTS_GetHour() ) ) + "h" + Str( Round( RTS_GetMinutes() ) ) + "m" + Str( Round( RTS_GetSecunds() ) ) + "s" )
	dbPrint( "Object Pos 3 : " + Str( GetObjectSizeMaxY( RTSObjects[ 1 ] ) - GetObjectSizeMinY( RTSObjects[ 1 ] ) ) )
	dbPrint( "Angle = " + Str( YAngle ) )
	dbRefresh()
	Sync()
loop
RTS_ClearRTSkybox()
End

