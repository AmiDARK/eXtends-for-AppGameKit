
//
Function RTS_EnableShadowShadings()
	UseShadowsOn = 1
EndFunction

Function RTS_DisableShadowShadings()
	UseShadowsOn = 0
EndFunction

Function RTS_SetAutoZoom( DefAutoZoomV As Float )
	If DefAutoZoomV < 0.0001 : DefAutoZoomV = 0.0001 : EndIf
	DefAutoZoom = DefAutoZoomV
EndFunction

Function RTS_RealTime_SetClock( Hour As Integer, Minutes As Integer, TSpeed As Float )
	// définition de l'heure par défaut ...
	RTSky.Hour = Hour : RTSky.Minutes = Minutes : RTSky.Secunds = 0
	RTSky.TimeSpeed = TSpeed
EndFunction
//
Function RTS_GetDay()
EndFunction RTSky.Day

Function RTS_GetHour()
EndFunction RTSky.Hour

Function RTS_GetMinutes()
EndFunction RTSky.Minutes

Function RTS_GetSecunds()
EndFunction RTSky.Secunds

Function RTS_SetDay( VALUE As Integer )
	RTSky.Day = VALUE
EndFunction

Function RTS_SetHour( VALUE As Integer )
	RTSky.Hour = VALUE
EndFunction

Function RTS_SetMinutes( VALUE As Integer )
	RTSky.Minutes = VALUE
EndFunction

Function RTS_SetSecunds( VALUE As Integer )
	RTSky.secunds = VALUE
EndFunction

Function RTS_SetTimeExpansion( TSpeed As Float )
	RTSky.TimeSpeed = TSpeed
EndFunction

Function RTS_SetWind( XSpeed As Float, ZSpeed As Float ) 
	RTSky.WindXSpeed = XSpeed
	RTSky.WindYSpeed = ZSpeed
EndFunction

Function RTS_CloudPersistence( Value As Float )
	If Value <= 1.0 : Value = 1.0 : EndIf
	if Value > 255 : Value = 255: Endif
	RTSky.CloudPercent = Value
EndFunction


Function RTS_SetMistAlpha( Value As Float )
	If Value <= 1.0 : Value = 1.0 : EndIf
	if Value > 255 : Value = 255: Endif
	RTSky.MistPercent = Value
EndFunction

Function RTS_SetFogControlOn()
	RTSky.FogControl = 1
EndFunction

Function RTS_SetFogControlOff()
	RTSky.FogControl = 0
EndFunction

Function RTS_SetFogDistance( Distance As Float )
	RTSkyFogDistance = Distance
EndFunction

Function RTS_SetFogColor( Red As Integer, Green As Integer, Blue As Integer )
	RTSky.FogRed = Red
	RTSky.FogGreen = Green
	RTSky.FogBlue = Blue
	RTSky.MinFogRed = Red / 10
	RTSky.MinFogGreen = Green / 10
	RTSky.MinFogBlue = Blue / 10
EndFunction

Function RTS_SetFogColorEx( Red As Integer, Green As Integer, Blue As Integer, MinRed As Integer, MinGreen As Integer, MinBlue As Integer )
	RTSky.FogRed = Red
	RTSky.FogGreen = Green
	RTSky.FogBlue = Blue
	RTSky.MinFogRed = MinRed
	RTSky.MinFogGreen = MinGreen
	RTSky.MinFogBlue = MinBlue
EndFunction

Function RTS_ClearRTSkybox()
	If RTSky.Initialized = 1
		For XLoop = 10 To 0 Step -1
			If RTSObjects[ XLoop ] > 0
				If GetObjectExists( XLoop ) = 1
					DeleteObject( RTSObjects[ XLoop ] )
					RTSObjects[ XLoop ] = 0
				EndIf
			EndIf
			If RTSTextures[ XLoop ] > 0
				If GetImageExists( XLoop ) = 1
					DeleteImage( RTSTextures[ XLoop ] )
					RTSTextures[ XLoop ] =  0 
				EndIf
			EndIf
		Next XLoop
		RTSky.Initialized = 0
	EndIf
 EndFunction

Function RTS_GetObjectLoaded( ID As Integer )
EndFunction RTSObjects[ ID ]

Function RTSkySystem_Update()
	//
	// *********************************************************************************************************************************************************
	// *                                                                                                                                                       *
	// *                                                           Real-Time Sky System Clock update                                                           *
	// *                                                                                                                                                       *
	// *********************************************************************************************************************************************************
	//
	// Real-Time clock updates
	NewTime As Integer
	NewTime = Timer() / 16000 // Led Timer AppGameKit est à 16.000.000 au lieu de 1.000 sous DarkBasic Professional
	Delay As Float : Delay = ( NewTime - RTSky.NewTimer )
	If RTSky.NewTimer = 0 Then Delay = 1.0
	RTSky.NewTimer = NewTime
	RTSky.Secunds = RTSky.Secunds + ( RTSky.TimeSpeed * Delay )
	If RTSky.Secunds >= 60
		RTTemp As Float : RTTemp = Trunc( RTSky.Secunds / 60 )
		RTSky.Secunds = RTSky.Secunds - ( RTTemp * 60 )
		RTSky.Minutes = RTSky.Minutes + RTTemp
		If RTSky.Minutes > 59
			RTTemp = Trunc( RTSky.Minutes / 60 )
			RTSky.Minutes = RTSky.Minutes - ( RTTemp * 60 )
			RTSky.Hour = RTSky.Hour + RTTemp
			If RTSky.Hour > 23
				RTTemp = Trunc( RTSky.Hour / 24 )
				RTSky.Hour = RTSky.Hour - ( RTTemp * 24 )
				RTSky.Day = RTSky.Day  + RTTemp
			EndIf   
		EndIf
	EndIf

	//
	// *********************************************************************************************************************************************************
	// *                                                                                                                                                       *
	// *                                                    Real-Time Sky System Camera informations update                                                    *
	// *                                                                                                                                                       *
	// *********************************************************************************************************************************************************
	//
	// Camera Support : Get current camera informations
	XC As Float : YC As Float : ZC As Float
	XCam1 As Float : YCam1 As Float : ZCam1 As Float
	XC = GetCameraX( 1 ) : XCam1 = XC
	YC = GetCameraY( 1 ) : YCam1 = YC
	ZC = GetCameraZ( 1 ) : ZCam1 = ZC
	// Handle camera movement
	CamMemory.XShift = CamMemory.XPos - XCam1
	CamMemory.YShift = CamMemory.YPos - YCam1
	CamMemory.ZShift = CamMemory.ZPos - ZCam1
	// Update Camera position
	CamMemory.XPos = XCam1
	CamMemory.YPos = YCam1
	CamMemory.ZPos = ZCam1

	//
	// *********************************************************************************************************************************************************
	// *                                                                                                                                                       *
	// *                                                     Real-Time Sky System Mathematics calculation                                                      *
	// *                                                                                                                                                       *
	// *********************************************************************************************************************************************************
	//

	// ********************************************************************************************* Calculate all fadings ratio depending on clock time
	// Day/Night light intensity calculations
	RTCOUNTER As Integer
	RTCounter = ( RTSky.Hour * 3600 ) + ( RTSky.Minutes * 60 ) + RTSky.Secunds
	DECA As Float
	DECA = RTSky.Secunds * 0.01666
	PERCENT As Float
	PERCENT2 As Float
	PERCENT3 As Float
	PERCENTX As Integer 
	EnlightRatio as Float : EnlightRatio = 0.5 + ( ( RTSky.MistPercent + RTSky.CloudPercent ) / 300.0 )

	// ************************************                        full night from 20h00 to 04h00
	If RTSky.Hour > 20 or RTSky.Hour < 4
		PERCENT = 0
		PERCENT2 = 90.0
	EndIf
	// ************************************      Handle calculation for day rising 03H00 to 11H00
	If RTSky.Hour > 3 And RTSky.Hour < 11
		PERCENT = ( ( ( RTSky.Hour - 4 ) * 60 ) + RTSky.Minutes ) / 1.8 // Resize *2 from original to divide /2 on objects
		If PERCENT > 150.0 : PERCENT3 = 150.0  : EndIf
		PERCENT2 = 90 - ( ( ( ( RTSky.Hour - 4 ) * 60 ) + RTSky.Minutes ) / 1.8 )
		If PERCENT2 < 0.0 Then PERCENT2 = 0
		//PERCENT3 = ( ( ( RTSky.Hour - 4 ) * 60 ) + RTSky.Minutes ) / 2.1
		PERCENT3 = ( 480 - (( RTSky.Hour * 60 ) + RTSky.Minutes ) )
		If PERCENT3 > 100.0 : PERCENT3 = 100.0  : EndIf
		If PERCENT3 < 0.0 : PERCENT3 = 0 : EndIf
	EndIf
	// ************************************ Handle calculations for full day cycle 09H00 to 16H00
	If RTSky.Hour > 10 And RTSky.Hour < 16
		PERCENT = 150
		PERCENT2 = 0.0
	EndIf
	// ************************************   Handle calculations for night rising 10H00 to 14H00
	If RTSky.Hour > 10 And RTSky.Hour < 14 : PERCENT3 = 0.0 : EndIf
	// ************************************   Handle calculations for night rising 13H00 to 21H00
	If RTSky.Hour > 13 And RTSky.Hour < 21
		PERCENT3= ( ( ( RTSky.Hour - 14 ) * 60 ) + RTSky.Minutes ) / 2.1
		If PERCENT > 150.0 : PERCENT3 = 150.0 - ( PERCENT3 - 100.0 ) : EndIf

		PERCENT3 = ( ( ( RTSky.Hour * 60 ) + RTSky.Minutes ) ) - 960
		If PERCENT3 > 100.0 : PERCENT3 = 100.0  : EndIf
		If PERCENT3 < 0.0 : PERCENT3 = 0 : EndIf
	EndIf
	// ************************************   Handle calculations for night rising 15H00 to 21H00
	If RTSky.Hour > 15 And RTSky.Hour < 21
		PERCENT = ( ( 360.0 - ( ( ( RTSky.Hour - 15 ) * 60 ) + RTSky.Minutes ) ) + DECA ) / 1.8
		PERCENT2 = ( ( ( RTSky.Hour - 19 ) * 60 ) + RTSky.Minutes ) / 1.33
		If PERCENT2 < 0.0 Then PERCENT2 = 0.0
		If PERCENT2 > 90.0 Then PERCENT2 = 90.0
	EndIf
	// ************************************   Handle a percent value with lower limit set to equal 10
	PERCENTZ = PERCENT
	If PERCENT < 20 Then PERCENT = 20
	PERCENTX = PERCENT * 2.0
	if PERCENT > 150.0 then PERCENT = 150.0

	// ************************************   Calculate values that will be used for sun/moon and halos
	ANGLE As Float : ANGLE = ( ( ( RTSky.Hour * 60.0 ) + RTSky.Minutes + DECA ) / 4.0 ) + 90.0
	XPos As Float : XPos = Cos( ANGLE ) * 3000 
	YPos As Float : YPos = Sin( ANGLE ) * 3000

	//
	// *********************************************************************************************************************************************************
	// *                                                                                                                                                       *
	// *                                                          Real-Time Sky System object updates                                                          *
	// *                                                                                                                                                       *
	// *********************************************************************************************************************************************************
	//

	// ********************************************************************************************* 1. Update the deep sky (stars) night visibility and position
	// Define the background deep night stars brighness
	SetObjectColor( RTSObjects[ 2 ], PERCENT2*2.5, PERCENT2*2.5, PERCENT2*2.5, PERCENT2*2.5 )
	SetObjectPosition( RTSObjects[ 2 ] , XC , YC , ZC )

	// ********************************************************************************************* 2. Update the global day/night sky color visual
	// Handle sky effects
	SetObjectColor( RTSObjects[ 0 ], 255, 255, 255, PERCENTZ * 1.5 )
	// SetObjectColorEmissive( RTSObjects[ 0 ], 64, 64, 255 )
	SetObjectPosition( RTSObjects[ 0 ] , XC , YC , ZC )

	// ********************************************************************************************* 3. Update the sun's halo position using latest coordinates calculation
	// Move the sun's halo where it must run to follow the sun moves
	SetObjectPosition( RTSObjects[ 5 ] , XC - XPos , YC - Ypos , ZC )
	SetObjectScale( RTSObjects[ 5 ] , PERCENT3 / 100.0 , PERCENT3 / 100.0 , PERCENT3 / 100.0 )
	SetObjectLookAt( RTSObjects[ 5 ], XC, YC, ZC, 0 )
	// ********************************************************************************************* 3.B Update the sun's halo brightness depending on clock time
	If ( RTSky.Hour < 11 or RTSky.Hour > 3 ) and RTSky.SkyHalo = 1
		SetObjectImage( RTSObjects[ 5 ] , RTSTextures[ 5 ], 0 )
		RTSky.SkyHalo = 0
	Else
		If ( RTSky.Hour > 13 And RTSky.Hour < 21 ) and RTSky.SkyHalo = 0
			SetObjectImage( RTSObjects[ 5 ] , RTSTextures[ 6 ], 0 )
			RTSky.SkyHalo = 1
		EndIf
	Endif

	// ********************************************************************************************* 4. Update the sun position using latest coordinates calculation
	// Move the sun where it must run
	SetObjectPosition( RTSObjects[ 3 ] , XC - ( XPos * 1.05 ) , YC - ( Ypos *1.05 ) , ZC )
	SetObjectLookAt( RTSObjects[ 3 ], XC, YC, ZC, 0 )

	// ********************************************************************************************* 5. Update the moon position and lookat using latest coordinates calculation
	// Move the moon where it must run to escape the sun.
	SetObjectPosition( RTSObjects[ 4 ] , XC + Xpos , YC + Ypos , ZC )
	SetObjectLookAt( RTSObjects[ 4 ], XC, YC, ZC, 0 )
	// ********************************************************************************************* 5.B Update the moon brightness
	// Moon is brighter at 00h00 o'clock ...
	PERCENTMOON as Float
	PERCENTMOON = ( abs( RTCounter - 46800 ) / 80 )
	SetObjectColor( RTSObjects[ 4 ], PERCENTMOON, PERCENTMOON, PERCENTMOON, PERCENTMOON )

	// ********************************************************************************************* 6. Update Clouds Scrolling depending on wind amplitude
	// Clouds Scrolling
	RTSky.CloudsXShift = RTSky.CloudsXShift + ( RTSky.WindXSpeed * Delay * 0.0001 ) 
	RTSky.CloudsYShift = RTSky.CloudsXShift + ( RTSky.WindXSpeed * Delay * 0.0001 )
	SetObjectUVOffset( RTSObjects[ 1 ] , 0, RTSky.CloudsXShift , RTSky.CloudsYShift )
	// ********************************************************************************************* 6.B Set Clouds density
	// Clouds Density
    SetObjectColor( RTSObjects[ 1 ], PERCENT, PERCENT, PERCENT, RTSky.CloudPercent )
	// ********************************************************************************************* 6.C Set Clouds Position
	SetObjectPosition( RTSObjects[ 1 ] , XC , YC , ZC )

	// ********************************************************************************************* 7. Set Misty ambient density and position
	// Define mist density (raining days ?)
	SetObjectColor( RTSObjects[ 7 ], PERCENT, PERCENT, PERCENT, RTSky.MistPercent )
	SetObjectPosition( RTSObjects[ 7 ] , XC , YC , ZC )

	// ********************************************************************************************* 9. Define the Aurore/Aube effect and position
	// Define the Aurore & Aube position
	FALPHA As Float
	If RTSky.Hour > 12
		SetObjectRotation( RTSObjects[ 8 ], 0.0, 180.0, 0.0 )
		FALPHA = 100.0 - Abs( ( ( ( RTSky.Hour - 18.0 ) * 60.0 ) + RTSky.Minutes ) / 1.20 )
	Else
		SetObjectRotation( RTSObjects[ 8 ], 0.0, 0.0, 0.0 )
		FALPHA = 100.0 - Abs( ( ( ( RTSky.Hour - 6.0 ) * 60.0 ) + RTSky.Minutes ) / 1.20 )
	EndIf
	If FALPHA < 0.0 : FALPHA = 0.0 : EndIf  
	SetObjectColor( RTSObjects[ 8 ], 255, 255, 255, FALPHA * 2.0 )
	SetObjectPosition( RTSObjects[ 8 ] , XC , YC , ZC )

	// ********************************************************************************************* 9. Define the far away background brighness and position
	// Define the far away background brightness depending on the clock time
	BgdEnlight as Float : BgdEnlight = PERCENT / EnlightRatio
	SetObjectColor( RTSObjects[ 9 ], BgdEnlight, BgdEnlight, BgdEnlight, 255 )
	SetObjectPosition( RTSObjects[ 9 ] , XC , YC , ZC )

	// ********************************************************************************************* 10. Define the ground brighness and position
	// Define the ground brightness depending on the clock time
	// BgdEnlight = ( PERCENTX * 1.25 ) / EnlightRatio
	SetObjectColor( RTSObjects[ 6 ], BgdEnlight, BgdEnlight, BgdEnlight, 255 )
	SetObjectPosition( RTSObjects[ 6 ] , XC , YC , ZC )
	// ********************************************************************************************* 10.B Scroll the ground texture if camera movement was detected
	// Scroll ground texture if camera movements are detected
	// If Abs( CamMemory.XShift ) < 100 And Abs( CamMemory.YShift ) < 100 And Abs( CamMemory.ZShift ) < 100
	// 	SetObjectUVOffset( RTSObjects[ 6 ], 0, CamMemory.XShift / 1000.0 , CamMemory.ZShift / 1000.0 )
	// EndIf

	//
	// *********************************************************************************************************************************************************
	// *                                                                                                                                                       *
	// *                                                    Real-Time Sky System Light & Fog effects updates                                                   *
	// *                                                                                                                                                       *
	// *********************************************************************************************************************************************************
	//

	// ********************************************************************************************* 1. Calculate the sun 3D position and 3D Vector for light
	// Calculate the position of the sun in the sky to define it's light direction
	LANGLE As Float
	YPos2 As Float : XPos2 As Float
	// Rem Calcul pour le YPOS#
	If RTSky.Hour > 5 And RTSky.Hour < 18
		LANGLE = 180 - ( ( ( ( RTSky.Hour - 6 ) * 60 ) + RTSky.Minutes + ( RTSky.Secunds * 0.01666 ) ) / 4.0 )
		Ypos2 = 0 - Sin( LANGLE )
	Else
		YPos2 = 0.0
	EndIf
	If RTSky.Hour > 3 And RTSky.Hour < 20
		LANGLE = 270 - ( ( ( ( RTSky.Hour - 4 ) * 60 ) + RTSky.Minutes + ( RTSky.Secunds * 0.01666 ) ) / 2.66667 )
		XPos2 = Cos( LANGLE )
	Else
		XPos2 = 0.0
	EndIf
	XAngle As Float : // YAngle As Float
	RANGE As Float : RANGE = ( 512.00 * PERCENT ) * DefAutoZoom

	// ********************************************************************************************* 1.B Update the sun datas (position, direction)
	// Calculate the position of the sun in the sky to define it's light direction
	SetSunDirection( XCam1 + ( XPos * 12 ) , YCam1 + ( YPos * 12 ) , ZCam1 )
	SetSunActive( 1 )
	ClearPointLights()
	CreatePointLight( 1, XCam1 - ( XPos * 12 * DefAutoZoom ) , YCam1 - ( YPos * 12 * DefAutoZoom ) , ZCam1, RANGE, RVB1 , RVB2 , RVB3 )

	// ********************************************************************************************* 2. Calculate the FOG system if ENABLED
	// Calculate the fog system
	If RTSky.FogControl = 1
		FPERCENT as Float
		FPERCENT = ( ( RTSky.Hour * 3600 ) + ( RTSky.Minutes * 60 ) + RTSky.Secunds ) / 432.0
		If FPERCENT > 100 : FPERCENT = 100 - ( FPERCENT - 100 ) : EndIf
		RVB1 = ( PERCENT * RTSky.AmbientRed ) / 100
		RVB2 = ( PERCENT * RTSky.AmbientGreen ) / 100
		RVB3 = ( PERCENT * RTSky.AmbientBlue ) / 100
		If RVB1 < RTSky.MinAmbientRed : RVB1 = RTSky.MinAmbientRed : EndIf
		If RVB2 < RTSky.MinAmbientGreen : RVB2 = RTSky.MinAmbientGreen : EndIf
		If RVB3 < RTSky.MinAmbientBlue : RVB3 = RTSky.MinAmbientBlue : EndIf
		SetSunColor( RVB1, RVB2, RVB3 )
		// On déplace l'ombre portée selon la position du soleil.
		// Percent2 As Float
		If UseShadowsOn = 1
			// Position the shadow at the same position than the displayed sun object.
			// DBSetShadowPosition( 0-1, XC - ( XPos / 3.0 ) , YC - ( Ypos / 3.0 ) , ZC )              Is ShadowMode also available on AppGameKit ?
			Percent2 = ( FPERCENT - 50.0 )
			If Percent2 < 0.0 : Percent2 = 0.0 : EndIf
			// DBSetShadowColor( 16, 16, 16, Int( Percent2 * 5 ) )                                     Is ShadowMode also available on AppGameKit ?
		EndIf
		RVB1 = ( PERCENT * RTSky.FogRed ) / 100
		RVB2 = ( PERCENT * RTSky.FogGreen ) / 100
		RVB3 = ( PERCENT * RTSky.FogBlue ) / 100
		If PERCENT < 10.0 : PERCENT = 10.0 : EndIf
		SetFogRange( 0, Trunc( 512 + ( ( PERCENT * RTSky.FogDistance ) / 100 ) ) )
		If RVB1 < RTSky.MinFogRed : RVB1 = RTSky.MinFogRed : EndIf
		If RVB2 < RTSky.MinFogGreen : RVB2 = RTSky.MinFogGreen : EndIf
		If RVB3 < RTSky.MinFogBlue : RVB3 = RTSky.MinFogBlue : EndIf
		SetFogColor( RVB1 , RVB2 , RVB3 )
	EndIf

	//
	// *********************************************************************************************************************************************************
	// *                                                                                                                                                       *
	// *                                                   Real-Time Sky System Draw the whole SkySystem scene                                                 *
	// *                                                                                                                                                       *
	// *********************************************************************************************************************************************************
	//

	// ********************************************************************************************* 1. Enable all 3D models
	// Makes all the 3D models used for the Real-Time Sky system to be visible for drawing
	SetObjectvisible( RTSObjects[ 0 ], 1 ) // Sky backdrop is OK
	SetObjectvisible( RTSObjects[ 1 ], 1 ) // Clouds are OK
	SetObjectvisible( RTSObjects[ 2 ], 1 ) // Stars are OK
	SetObjectvisible( RTSObjects[ 3 ], 1 ) // Sun Ok
	SetObjectvisible( RTSObjects[ 4 ], 1 ) // Moon Ok 
	SetObjectvisible( RTSObjects[ 5 ], 1 ) // Halo 1 Ok
	SetObjectvisible( RTSObjects[ 6 ], 1 ) // Halo 2
	SetObjectvisible( RTSObjects[ 7 ], 1 ) // Misty Ambience
	SetObjectvisible( RTSObjects[ 8 ], 1 ) // Aurore/Aube
	SetObjectvisible( RTSObjects[ 9 ], 1 ) // Far Away

	// ********************************************************************************************* 2. Draw the whole scene !
	// Render all the models in the correct order to maximize the render effects and visuals
	DrawObject( RTSObjects[ 2 ] ) // 1. Draw the stars (backdrop)
	DrawObject( RTSObjects[ 0 ] ) // 2. Draw the sky color (that faded by night)
	DrawObject( RTSObjects[ 5 ] ) // 3. Draw the sun halo
	DrawObject( RTSObjects[ 3 ] ) // 5. Draw the sun (over the halo)
	DrawObject( RTSObjects[ 4 ] ) // 6. Draw the moon
	DrawObject( RTSObjects[ 1 ] ) // 8. Draw the cloud to be displayed over all the stuffs already drawn
	DrawObject( RTSObjects[ 7 ] ) // 10. Draw the misty ambient
	DrawObject( RTSObjects[ 8 ] ) // 4. Draw the opening and the ending of the day (Aurore/Aube)
	DrawObject( RTSObjects[ 9 ] ) // 8. Draw the far away city
	DrawObject( RTSObjects[ 6 ] ) // 7. Draw the ground (so sun and moon will be overwritten when they're in the ground

	// ********************************************************************************************* 3. Disable all 3D models
	// Makes all the 3D models used for the Real-Time Sky system to be invisible
	SetObjectvisible( RTSObjects[ 0 ], 0 ) // Sky backdrop is OK
	SetObjectvisible( RTSObjects[ 1 ], 0 ) // Clouds are OK
	SetObjectvisible( RTSObjects[ 2 ], 0 ) // Stars are OK
	SetObjectvisible( RTSObjects[ 3 ], 0 ) // Sun Ok
	SetObjectvisible( RTSObjects[ 4 ], 0 ) // Moon Ok 
	SetObjectvisible( RTSObjects[ 5 ], 0 ) // Halo 1 Ok
	SetObjectvisible( RTSObjects[ 6 ], 0 ) // Halo 2
	SetObjectvisible( RTSObjects[ 7 ], 0 ) // Misty Ambience
	SetObjectvisible( RTSObjects[ 8 ], 0 ) // Aurore/Aube
	SetObjectvisible( RTSObjects[ 9 ], 0 ) // Far Away

EndFunction

	//
	// *********************************************************************************************************************************************************
	// *                                                                                                                                                       *
	// *                                                            Real-Time Sky System setup method                                                          *
	// *                                                                                                                                                       *
	// *********************************************************************************************************************************************************
	//

Function RTS_RealTimeSky_Setup( SkyBoxes As String )

	// ********************************************************************************************* 1. Setup default datas
	// Define the background deep night stars brighness
	RTSky.Initialized = 1
	RTSky.SkyBoxDrawer = "" // SkyBoxes + "\" Removed folder for AppGameKit as it is not handled
	RTSky.SkyBoxFile = SkyBoxes + ".x4r"
	RTSky.AmbientRed = 255
	RTSky.AmbientGreen = 255
	RTSky.AmbientBlue = 255
	RTSky.FogRed = 255
	RTSky.FogGreen = 255
	RTSky.FogBlue = 255
	RTSky.FogDistance = 4096
	RTSky.XView = 0.0 
	RTSky.YView = 0.0
	RTSky.ZView = 0.0

	// ********************************************************************************************* 1. Open the definition file and load filenames for textures
	// Define the background deep night stars brighness
	FileOpened As Integer
	FileOpened = OpenToRead( RTSky.SkyBoxFile )
	If FileOpened > 0
		_HEADER As String : _HEADER = ReadLine( FileOpened )
		If _HEADER = "X4 RealTime-SkyBox Definition"
			Repeat
				myDATA As String : myDATA = ReadLine( FileOpened )
				Select myDATA
					Case "CIEL:" 
						RTSky.SkyFile = ReadLine( FileOpened )
					EndCase
					Case "NUAGES:"
						RTSky.CloudFile = ReadLine( FileOpened )
					EndCase
					Case "ETOILES:"
						RTSky.StarsFile = ReadLine( FileOpened )
					EndCase
					Case "SOLEIL:"
						RTSky.SunFile = ReadLine( FileOpened )
					EndCase
					Case "LUNE:"
						RTSky.MoonFile = ReadLine( FileOpened )
					EndCase
					Case "HALOLEVER:"
						RTSky.GetUpHalo = ReadLine( FileOpened )
					EndCase
					Case "HALOCOUCHER:"
						RTSky.GetDownHalo = ReadLine( FileOpened ) 
					EndCase
					Case "MINAMBIENT:"
						RTSky.MinAmbientRed = Val( ReadLine( FileOpened ) )
						RTSky.MinAmbientGreen = Val( ReadLine( FileOpened ) )
						RTSky.MinAmbientBlue = Val( ReadLine( FileOpened ) )
					EndCase
					Case "AMBIENT:"
						RTSky.AmbientRed = Val( ReadLine( FileOpened ) )
						RTSky.AmbientGreen = Val( ReadLine( FileOpened ) )
						RTSky.AmbientBlue = Val( ReadLine( FileOpened ) )
					EndCase
					Case "FOG:"
						RTSky.FogRed = Val( ReadLine( FileOpened ) )
						RTSky.FogGreen = Val( ReadLine( FileOpened ) )
						RTSky.FogBlue = Val( ReadLine( FileOpened ) )
					EndCase
					Case "FOGDISTANCE:"
						RTSky.FogDistance = Val( ReadLine( FileOpened ) )
					EndCase
					Case "AURORE:"
						RTSky.Aurore1 = ReadLine( FileOpened )
					EndCase
					Case "BACKGROUND:"
						RTSky.FarAway = ReadLine( FileOpened )
					EndCase
					Case "GROUND:"
						RTSky.Ground = ReadLine( FileOpened )
					EndCase
				EndSelect                
			Until myDATA = "ENDOFRSD" Or GetFilePos( FileOpened ) = GetFileSize( FileOpened )
		Else 
			RTSky.Initialized = 0
			// Message( "! ! ! WARNING ! ! !" , "File does not correspond to real-time skybox" )
		EndIf   
		CloseFile( FileOpened )
	else
		Initialized = -1
	EndIf

	// ********************************************************************************************* 3. Setup the stars
	// 
	RTSObjects[ 2 ] = LoadObject( RTSky.SkyBoxDrawer + "Ciel_ver2018.obj" )
	SetObjectScalePermanent( RTSObjects[ 2 ] , 10 , 10 , 10 )
	RTSTextures[ 2 ] = LoadImage( RTSky.StarsFile, 1 )
	SetObjectImage( RTSObjects[ 2 ] , RTSTextures[ 2 ], 0 )
	SetObjectCullMode( RTSObjects[ 2 ], 0 )
	SetObjectLightMode( RTSObjects[ 2 ], 0 )
	SetObjectFogMode( RTSObjects[ 2 ], 0 )

	// ********************************************************************************************* 4. Setup the blue-sky
	// 
	RTSObjects[ 0 ] = LoadObject( RTSky.SkyBoxDrawer + "Ciel_ver2018.obj" )
	SetObjectScalePermanent( RTSObjects[ 0 ] , 9 , 9 , 9 )
	RTSTextures[ 0 ] = LoadImage( RTSky.SkyBoxDrawer + RTSky.SkyFile, 0 )
	SetObjectImage( RTSObjects[ 0 ], RTSTextures[ 0 ], 0 )
	DBSetObject4( RTSObjects[ 0 ], 1, 3, 0, 2, 0, 0, 0 ) // Set to 0 from 2
	SetObjectBlendModes( RTSObjects[ 0 ], 2, 3 )

	// ********************************************************************************************* 5. Setup the halos for both morning and evening sun's halos
	// 
	RTSObjects[ 5 ] = CreateObjectPlane( 2048, 1536 )
	RTSTextures[ 5 ] = LoadImage( RTSky .SkyBoxDrawer + RTSky.GetUpHalo, 0 )  // Load the 1st halo
	SetObjectImage( RTSObjects[ 5 ] , RTSTextures[ 5 ], 0 )
	DBSetObject4( RTSObjects[ 5 ] , 1 , 1 , 0 , 2 , 0 , 0 , 0 )
	// SetObjectBlendModes( RTSObjects[ 5 ], 2, 1 )
	RTSTextures[ 6 ] = LoadImage( RTSky.SkyBoxDrawer + RTSky.GetDownHalo, 0 ) // Load the 2nd halo

	// ********************************************************************************************* 6. Setup the sun
	// 
	RTSObjects[ 3 ] = CreateObjectPlane( 256  , 256 )
	RTSTextures[ 3 ] = LoadImage( RTSky.SkyBoxDrawer + RTSky.SunFile, 0 )
	SetObjectImage( RTSObjects[ 3 ] , RTSTextures[ 3 ], 0 )
	SetObjectColor( RTSObjects[ 3 ], 255, 255, 255, 255 )
	DBSetObject4( RTSObjects[ 3 ] , 1 , 1 , 0 , 2 , 0 , 0 , 0 )
	// SetObjectBlendModes( RTSObjects[ 3 ], 1, 6 )

	// ********************************************************************************************* 7. Setup the moon
	// 
	RTSObjects[ 4 ] = CreateObjectPlane( 160 , 160 )
	RTSTextures[ 4 ] = LoadImage( RTSky.SkyBoxDrawer + RTSky.MoonFile, 0 )
	SetObjectImage( RTSObjects[ 4 ] , RTSTextures[ 4 ], 0 )
	DBSetObject4( RTSObjects[ 4 ] , 1 , 1 , 0 , 0 , 0 , 0 , 0 )

	// ********************************************************************************************* 8. Setup the clouds
	// 
	RTSObjects[ 1 ] = LoadObject( RTSky.SkyBoxDrawer + "CloudsGround_ver2018.obj" )
	SetObjectScalePermanent( RTSObjects[ 1 ] , 12 , 6 , 12 )
	RTSTextures[ 1 ] = LoadImage( RTSky.SkyBoxDrawer + RTSky.CloudFile, 0 )
	SetImageWrapU( RTSTextures[ 1 ], 1 )
	SetImageWrapV( RTSTextures[ 1 ], 1 )
	SetObjectImage( RTSObjects[ 1 ] , RTSTextures[ 1 ], 0 )
	DBSetObject4( RTSObjects[ 1 ] , 1 , 3, 0 , 0 , 1, 1, 1 )
	SetObjectBlendModes( RTSObjects[ 1 ], 2, 3 )
	// SetObjectColor( RTSObjects[ 1 ], 255, 255, 255, 128 ) // Useless because it will be overwritten during updates

	// ********************************************************************************************* 9. Setup the misty fog
	// 
	RTSObjects[ 7 ] = LoadObject( RTSky.SkyBoxDrawer + "CloudsGround_ver2018.obj" )
	RTSTextures[ 7 ] = LoadImage( RTSky.SkyBoxDrawer + "gris.png", 0 )
	SetObjectImage( RTSObjects[ 7 ] , RTSTextures[ 7 ], 0 )
	DBSetObject4( RTSObjects[ 7 ] , 1 , 1 , 0 , 2 , 0 , 0 , 0 )
	// SetObjectBlendModes( RTSObjects[ 7 ], 2, 1 )

	// ********************************************************************************************* 10. Setup the 'morning' aurore effect
	// 
	RTSObjects[ 8 ] = LoadObject( RTSky.SkyBoxDrawer + "LC.x" )
	RTSTextures[ 8 ] = LoadImage( RTSky.SkyBoxDrawer + RTSky.Aurore1, 0 )
	SetObjectImage( RTSObjects[ 8 ] , RTSTextures[ 8 ], 0 )
	DBSetObject4( RTSObjects[ 8 ] , 1 , 3 , 1 , 2 , 0 , 0 , 0 )
	SetObjectColor( RTSObjects[ 8 ], 255, 255, 255, 255 )
	SetObjectBlendModes( RTSObjects[ 8 ], 2, 1 )
	SetObjectScale( RTSObjects[ 8 ], 0.25, 0.25, 0.25 )

	// ********************************************************************************************* 11. Setup the background model (city, mountains, etc.)
	// 
	RTSObjects[ 9 ] = LoadObject( RTSky.SkyBoxDrawer + "FarAway.x" )
	SetObjectScale( RTSObjects[ 9 ], 0.05, 0.05, 0.05 )
	RTSTextures[ 9 ] = LoadImage( RTSky.SkyBoxDrawer + RTSky.FarAway, 1 )
	SetObjectImage( RTSObjects[ 9 ] , RTSTextures[ 9 ], 0 )
	SetImageWrapU( RTSTextures[ 9 ], 1 )
	SetImageWrapV( RTSTextures[ 9 ], 1 )
	DBSetObject4( RTSObjects[ 9 ] , 1 , 0 , 1 , 2 , 0 , 0 , 0 )
	SetObjectAlphaMask( RTSObjects[ 9 ], 1 )

	// ********************************************************************************************* 11. Setup the ground
	// 
	RTSObjects[ 6 ] = LoadObject( RTSky.SkyBoxDrawer + RTSky.SkyBoxDrawer + "CloudsGround_ver2018.obj" )
	SetObjectRotation( RTSObjects[ 6 ] , 180 , 0 , 0 )
	SetObjectScale( RTSObjects[ 6 ], 4, 1, 4 )
	SetObjectPosition( RTSObjects[ 6 ] , 0 , 0 , 0 )
	FadeObject( RTSObjects[ 6 ], 100 )
    RTSTextures[ 10 ] = LoadImage( RTSky.SkyBoxDrawer + RTSky.Ground, 1 )
	SetImageWrapU( RTSTextures[ 10 ], 1 )
	SetImageWrapV( RTSTextures[ 10 ], 1 )
	SetObjectImage( RTSObjects[ 6 ], RTSTextures[ 10 ], 0 )
	DBSetObject4( RTSObjects[ 6 ] , 1 , 1 , 0 , 2 , 1 , 1 , 1 )
	
	// ********************************************************************************************* 11. Setup global states for all models
	// 
	for iLoop = 0 to 9
		SetObjectDepthWrite( RTSObjects[ iLoop ], 0 )                  // Disable Z/Depth buffering writing for all models
		SetObjectvisible( RTSObjects[ iLoop ], 0 )                     // Makes them invisible so, only RTSkySystem_Update() will render them
		SetObjectCollisionMode( RTSObjects[ iLoop ], 0 )               // Disable collisions as they must not use them
	next iLoop

	If RTSky.CloudPercent <= 1.0 : RTSky.CloudPercent = 1.0 : EndIf
	If RTSky.CloudPercent > 99 : RTSky.CloudPercent = 99: Endif

 EndFunction

