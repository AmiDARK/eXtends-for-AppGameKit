
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
SetVirtualResolution( 1280, 1024 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 120, 0 ) // 60fps on computer
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

Rem ***************************************************
Rem *                                                 *
Rem * DarkBasic Professional Extends TPC Pack Ver 1.0 *
Rem *                                                 *
Rem ***************************************************
Rem Author : Frédéric Cordier - Odyssey-Creators
Rem Date   : 2008.February.16
Rem Sample : Basic 2D - Bitmap Font Demo
Rem 

Global FullText As String = "Here is a small scroll text demo using xfont developped by frederic cordier for darkbasic professional extends plugin and xquadeditor software. I hope you enjoy that small demo ...                               "
TextShift As Integer = 1
XShift As Integer : yAngle As Integer : yAngle = 0
YPos as Integer : YPos = ( xtGetBitmapHeight( 0 ) / 2 ) - 16
XGui_UseMipMap( 1 )
Feedback = XFont_SetupFont( "font32x32.png" , 1 , 32 , 32 , 0 )
if Feedback = 1
	XFont_AutoReturnMode( 0 )
	XWindow_SetTextTransparent()
	IMG = LoadImage( "background.png" )
	Do
		dbSetCursor( 0, 0 )
		dbPrint( " FPS : " + str( ScreenFPS() ) )
		PasteImage( IMG, 0, 0 )
		Dec XShift, 1 : Rem shift text to 1 pixel on the left.
		If XShift = -30 : XShift = 0 : Inc TextShift, 1 : Endif : Rem On décale de 1 charactère chaque 16 pixels.
		Inc yAngle, 1
		If TextShift > Len( FullText ) : TextShift = TextShift - Len( FullText ) : Endif : Rem on revient au début du texte si la fin est atteinte.

		TitleText As String = "Extends Demonstration"
		XFont_Text( TitleText, ( xtGetBitmapWidth( 0 ) / 2 ) - ( XFont_GetTextWidth( TitleText ) / 2 ), 96 + ( Cos( yAngle + 90 ) * 64 ) )
		ScrollTexte( FullText, TextShift, XShift, YPos, yAngle )
		Sync()
	Loop
else
	Message( "XFont Not Initialized : " + Str( feedback ) )
endif
End


Rem This function will extract the text part to print on screen.
Function ScrollTexte( Texte As String, TextShift As Integer, ScrollShift As Integer, YPos As Integer, yAngle as Integer )
	TilesCount As Integer
	TilesCount = ( xtGetBitmapWidth( 0 ) / 32 ) + 1
	Text2Write As String : Text2Write = Mid( Texte, TextShift, TilesCount )
	for tLoop = 0 to Len( Text2Write ) - 1
		XFont_SetCursor(  ScrollShift , Ypos + ( cos( yAngle ) * 96 ) )
		XFont_PrintF( Mid( Text2Write, tLoop+1, 1 ) )
		ScrollShift = ScrollShift + 32
		yAngle = yAngle + 1
	next tLoop
EndFunction
