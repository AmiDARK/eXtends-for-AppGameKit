
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
Rem * DarkBasic Professional Extends TPC Pack Ver 1.0 *
Rem *                                                 *
Rem ***************************************************
Rem Author : Frédéric Cordier - Odyssey-Creators
Rem Date   : 2008.February.16 New : 2018.07.28
Rem Sample : Billboard Sprites.
Rem 

Rem Firstly we load the bitmap to cut all character animations.
Dim CharAnims[ 16 ]
CharImage = LoadImage( "character.png", 0 )


For XLoop = 0 to 3 Step 1
  XCut = XLoop * 24
	CharAnims[ XLoop ] = CopyImage( CharImage, xCut, 0, 24, 32 )
	CharAnims[ XLoop + 4 ] = CopyImage( CharImage, xCut, 32, 24, 32 )
	CharAnims[ XLoop + 8 ] = CopyImage( CharImage, xCut, 64, 24, 32 )
	CharAnims[ XLoop + 12 ] = CopyImage( CharImage, xCut, 96, 24, 32 )
 Next XLoop
DeleteImage( CharImage )

Rem We load the image for the ground.
GRASS = LoadImage( "grass.jpg" ) 

Rem We Load The Original Object for the crates
CRATE = LoadObject( "crate.x" )
CRATEIMAGE = LoadImage( "crate3.jpg" )
SetObjectImage( CRATE, CRATEIMAGE, 0 )
SetObjectPosition( CRATE, -1024, 0, -1024 )

Rem New We create the Scène
Dim TObject[ 7, 7 ]

Dim Tiles[ 64 ] = [ 1 , 1 , 1 , 1 , 1 , 1 , 1 , 1, 1 , 0 , 0 , 1 , 0 , 0 , 0 , 1, 1 , 1 , 0 , 1 , 0 , 1 , 0 , 1, 1 , 0 , 0 , 1 , 0 , 1 , 0 , 1, 1 , 0 , 1 , 1 , 0 , 1 , 0 , 1, 1 , 0 , 1 , 0 , 0 , 1 , 0 , 1, 1 , 0 , 0 , 0 , 1 , 0 , 0 , 1, 1 , 1 , 1 , 1 , 1 , 1 , 1 , 1 ]



For YLoop = 0 To 7
  For XLoop = 0 to 7
  	 Info = Tiles[ XLoop + ( YLoop * 8 ) ]
  	 Rem Create ground or crate dependaing on data
  	 Select Info
      Case 0
        TObject[ XLoop, YLoop ] = CreateObjectPlane( 64, 64 )
        SetObjectImage( TObject[ XLoop, YLoop ], GRASS, 0 )
        SetObjectRotation( TObject[ XLoop, YLoop ], 90, 0, 0 )
       EndCase
      Case 1
        TObject[ XLoop, YLoop ] = InstanceObject( CRATE )
       EndCase
  	  EndSelect
    Rem Put the object to its final position
    SetObjectPosition( TObject[ XLoop, YLoop ], ( XLoop * 64 ) + 32, Info * 32, ( YLoop * 64 ) + 32 )
   Next XLoop
 Next YLoop

Rem Setup the player position
PlayerXPos = 96 : PlayerZPos =  96 : OldAnim = 0
CharObject = CreateObjectPlane( 24, 32 )
SetObjectTransparency( CharObject, 1 )

B3D_AddBillBoardToList( CharObject ) : Rem Add the object to the billboard list.
// SetObject( CharObject, 1, 1, 0, 0, 0, 0 )

Repeat
  Rem Move the player with arrow keys
  XMove = GetRawKeyState( 39 ) - GetRawKeyState( 37 )
  ZMove = GetRawKeyState( 38 ) - GetRawKeyState( 40 )
  If XMove <> 0
    XTile = ( PlayerXPos + ( 13 * XMove ) ) / 64 : ZTile = PlayerZPos / 64
    If Tiles[ XTile + ( ZTile * 8 ) ] = 0 Then PlayerXPos = PlayerXPos + XMove
   Endif
  If ZMove <> 0
  	 XTile = PlayerXPos / 64 : ZTile = ( PlayerZPos + ( 13 * ZMove ) ) / 64
    If Tiles[ XTile + ( ZTile  * 8 ) ] = 0 Then PlayerZPos = PlayerZPos + ZMove
  	Endif
  SetObjectPosition( CharObject, PlayerXPos, 16, PlayerZPos )
  Rem Animate The Player
  If XMove = -1 Then NewAnim = 3
  If XMove = 1 Then NewAnim = 1
  If ZMove = 1 Then NewAnim = 0
  If ZMove = -1 Then NewAnim = 2
  If NewAnim <> OldAnim
  	 AnimStep = 0 : OldAnim = NewAnim
  	Else  	 
    If XMove <> 0 Or ZMove <> 0 Then AnimStep = AnimStep + 1
    If AnimStep = 32 Then AnimStep = 0
   Endif
  SetObjectImage( CharObject, CharAnims[ ( OldAnim * 4 ) + ( AnimStep / 8 ) ], 0 )
  Rem Position the camera to view the character.
  SetCameraPosition( 1, PlayerXPos, 128.0, PlayerZPos - 48 )
  SetCameraLookAt( 1, PlayerXPos, 0, PlayerZPos, 0 )

  Rem Make the CharObject Update
  B3D_RefreshBillBoards()

  Rem Sync to update All
  Sync()
  finish = 0
 Until finish = 1

Rem We Delete the full maze objects.
For YLoop = 7 To 0 Step -1
  For XLoop = 7 To 0 Step -1
    DeleteObject( TObject[ XLoop, YLoop ] )
   Next XLoop
Next YLoop

Rem We delete the master crate object.
DeleteObject( CRATE )

Rem We delete the master Grass texture.
DeleteImage( GRASS )

End
