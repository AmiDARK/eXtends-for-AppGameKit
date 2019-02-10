
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
SetSyncRate( 60, 0 ) // 60fps on computer
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

Rem ***************************************************
Rem *                                                 *
Rem * DarkBasic Professional Extends TPC Pack Ver 1.3 *
Rem *                                                 *
Rem ***************************************************
Rem Author : Frédéric Cordier - Odyssey-Creators
Rem Date   : 2008.February.16
Rem Sample : Basic 2D - Xwindow Demonstration
Rem
  // Set Bitmap Format 21
  ClearScreen()
  EnableClearColor( 0 )
  background = LoadImage( "background.png" )
SetRenderToScreen()
  dbSetCursor( 0, 0 )
  dbInk( dbrgb( 255, 255, 255 ), dbrgb( 0, 0, 0 ) )
  dbPrint( "Choose which skin to use :" )
  dbPrint( "1 - Ancient Style" )
  dbPrint( "2 - RPG Style" )
  dbPrint( "3 - Granit Style" )
  dbPrint( "4 - Custom size skin with PNG Transparency" ) 
  // Sync()
  Skin As Integer = 0
  repeat
	  sync()
	  Skin = ( 1 * GetRawKeyState( 49 ) ) + ( 2 * GetRawKeyState( 50 ) ) + ( 3 * GetRawKeyState( 51 ) ) + ( 4 * GetRawKeyState( 52 ) )
	  until Skin > 0
	SkinFile As String
  Select Skin
    Case 1 : SkinFile = "ancientblue.skin" : EndCase
    Case 2 : SkinFile = "FFRpg_Style.skin" : EndCase
    Case 3 : SkinFile = "granit.skin" : EndCase
    Case 4 : SkinFile = "Custom.skin" : EndCase
	Case Default : SkinFile = "ancientBlue.skin" : EndCase
   EndSelect
Rem
Rem
  // XGui MipMap Mode 1
	If XWindow_Initialize( SkinFile ) = 1

		XWindow_EnableAlphaiser()
		XWindow_SetTextTransparent()
		XFont_SetupFont( "font16x16.png" , 1 , 16 , 32 , 0 )

		XWindow_Create( 1 , 320 , 240 )
		XWindow_Position( 1 , 0 , 0 )
		XWindow_Title( 1, "Première Fenêtre" )
		XWindow_UseXFont( 1, 1 )
		XWindow_Alpha( 1, 192 )
		// XGui Window Properties 1, 1, 0, 0, 0
		XWindow_AddGadgetTexte( 1 , 1 , 4 , 4 , 64, 16, "HELLO" )
		SCORE = LoadImage( "score.jpg" )
		XWindow_AddGadget( 1 , 2 , 128 , 0 , 64 , 16 , SCORE )

		XWindow_Create( 2 , 512 , 256 )
		XWindow_Title( 2, "Deuxième Fenêtre" )
		XWindow_Position( 2 , 128 , 128 )
		XWindow_UseXFont( 2, 1 )
		XWindow_Alpha( 2, 128 )


 
		Sync()
		XWindow_Refresh()

		XFont_SetCurrentFont( 0 )


		Do
			PasteImage( background, 0, 0 )
			xtSetCurrentBitmap( 0 )
			XWindow_Refresh()
			Sync()
		Loop
		XWindow_ClearSystem()
	Else
		Message( "Cannot Initialize Choosen XGUI : DarkBASIC Professional Extends PlugIN Sample" )
	Endif
	DeleteImage( SCORE )
End
