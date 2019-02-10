

// **************************************************************
Function L3D_GetDistance( XPos As Float, YPos As Float, ZPos As Float, XCam As Float, YCam As Float, ZCam As Float )
	XDist As Float : XDist = XCam - XPos
	YDist As Float : YDist = YCam - YPos
	ZDist As Float : ZDist = ZCam - ZPos
	Distance As Float : Distance = Sqrt( ( XDist * XDist ) + ( YDist * YDist ) + ( ZDist * ZDist ) )
EndFunction Distance
// **************************************************************
Function L3D_ClearList()
	For XLoop = 0 To 7
		CLight[ XLoop ].Distance = 999999.0
		CLight[ XLoop ].VLight = 0
	Next XLoop
	CLight[ 0 ].Distance = 0
EndFunction
// **************************************************************
Function L3D_CheckInListPos( NewDistance As Float )
	InPos As Integer = 8
	For XLoop = 7 To 1 Step -1
		If NewDistance < CLight[ XLoop ].Distance
			InPos = XLoop
		EndIf
	Next XLoop
EndFunction InPos
// **************************************************************
Function L3D_InsertInList( NLight As Integer, Distance As Float , InPos As Integer )
	If InPos < 7
		XLoop = 6
		Repeat
			CLight[ XLoop + 1 ].VLight = CLight[ XLoop ].VLight
			CLight[ XLoop + 1 ].Distance = CLight[ XLoop ].Distance
			XLoop = XLoop - 1
		Until XLoop < InPos
	EndIf
	CLight[ InPos ].VLight = NLight
	CLight[ InPos ].Distance = Distance
EndFunction
// **************************************************************
Function L3D_RefreshTrueLight()
	InCount As Integer = 0
	Check As Integer = 1
	TotalLights As Integer = 0
	Repeat
		If CLight[ Check ].VLight > 0
			LNumber As Integer : LNumber = CLight[ Check ].VLight
			Repeat
				InCount = InCount + 1
			Until DLight[ InCount ].Locked = 0 Or InCount = 8
			If InCount < 8
				TotalLights = TotalLights + 1
				If GetPointLightExists( InCount ) = 1
					DeletePointLight( InCount )
				EndIf
				DLight[ InCount ].VLight = CLight[ Check ].VLight
				DLight[ InCount ].Active = 1
				CreatePointLight( InCount, VLight[ LNumber ].XPos, VLight[ LNumber ].YPos, VLight[ LNumber ].ZPos, VLight[ LNumber ].Range, VLight[ LNumber ].Red, VLight[ LNumber ].Green, VLight[ LNumber ].Blue )
				// On Calcule la couleur finale selon le type de lumière.
				Red As Integer : Red = VLight[ LNumber ].Red
				Green As Integer : Green = VLight[ LNumber ].Green
				Blue As Integer : Blue = VLight[ LNumber ].Blue
				Range As Integer  : Range = VLight[ LNumber ].Range
				Flash As Integer = 1
				Amplitude As float
				Select VLight[ LNumber ].lType
					Case 1
						VLight[ LNumber ].ActualState = VLight[ LNumber ].ActualState + 2
						If VLight[ LNumber ].ActualState > 255
							VLight[ LNumber ].ActualState = VLight[ LNumber ].ActualState - 256
						EndIf
						If VLight[ LNumber ].ActualState < 128
							Amplitude = ( 50.0 + ( VLight[ LNumber ].ActualState / 2.56 ) ) * 0.01
						Else
							Amplitude = ( 50.0 + ( ( 128 + ( 128 - VLight[ LNumber ].ActualState ) ) / 2.56 ) ) * 0.01
						EndIf
						Red = Red * Amplitude : Green = Green + Amplitude : Blue = Blue + Amplitude
						Range = Range * Amplitude
					EndCase
					Case 2
						VLight[ LNumber ].ActualState = VLight[ LNumber ].ActualState + 1
						If VLight[ LNumber ].ActualState > 255
							VLight[ LNumber ].ActualState = VLight[ LNumber ].ActualState - 256
						EndIf
						If VLight[ LNumber ].ActualState < 128
							Amplitude = ( VLight[ LNumber ].ActualState / 1.28 ) * 0.01
						Else
							Amplitude = ( ( 128 + ( 128 - VLight[ LNumber ].ActualState ) ) / 1.28 ) * 0.01
						EndIf
						Red = Red * Amplitude : Green = Green + Amplitude : Blue = Blue + Amplitude
						Range = Range * Amplitude
					EndCase
					Case 3
						Flash = Random( 0, 2 )
						Red = Red * Flash / 2.0 : Green = Green * Flash / 2.0 : Blue = Blue * Flash / 2.0
						Range = Range * Flash / 2.0
					EndCase
				EndSelect
				SetPointLightColor( InCount, Red, Green, Blue )
				SetPointLightRadius( InCount, Range )
				DLight[ InCount ].Color = ( Red * 65536 ) + ( Green * 256 ) + Blue
				DLight[ InCount ].Range = Range
				// On Calcule le halo lumineux si nécessaire.
				If VLight[ LNumber ].Halo = 0 Or Flash = 0
					If DLight[ InCount ].HaloObject > 0
						SetObjectvisible( DLight[ InCount ].HaloObject, 0 )
					EndIf
				Else
					If DLight[ InCount ].HaloObject = 0
						DLight[ InCount ].HaloObject = CreateObjectPlane( 32.0, 32.0 )
						// DBSetObject4( DLight[ InCount ].HaloObject, 1, 0, 0, 1, 0, 0, 0 )         -> To Add
						// DBGhostObjectOn( DLight[ InCount ].HaloObject )                           -> To Add
					Else
						SetObjectVisible( DLight[ InCount ].HaloObject, 1 )
					EndIf
					SetObjectImage( DLight[ InCount ].HaloObject, VLight[ LNumber ].Halo, 0 )
					SetObjectPosition( DLight[ InCount ].HaloObject, VLight[ LNumber ].XPos, VLight[ LNumber ].YPos, VLight[ LNumber ].ZPos )
					// DBSetCurrentCamera( CameraNumber )                                            -> To Add
					// DBSetToCameraOrientation( DLight[ InCount ].HaloObject )                      -> To Add
				EndIf
			EndIf
		EndIf
		Check = Check + 1 // Next Light from the list.   
	Until Check = 8 Or InCount = 8
	// Si il reste des lumières, on les supprime.
	InCount = InCount + 1
	If InCount < 7
		Repeat
			If DLight[ InCount ].Locked = 0
				If GetPointLightExists( InCount ) = 1
					DeletePointLight( InCount )
				EndIf
			EndIf
			InCount = InCount + 1
		Until InCount = 8
	EndIf
	// TotalLights = TotalLights - 1
EndFunction TotalLights
// **************************************************************
Function L3D_TurnOffLight( LightNumber As Integer )
	If GetPointLightExists( LightNumber ) = 1
		DeletePointLight( LightNumber )
	EndIf
EndFunction
// **************************************************************
Function L3D_SetDisplayCamera( CameraNumber As Integer )
	If L3DInitialized = 1
		If CameraNumber > 0
			VisibilityCam = CameraNumber
		EndIf
	EndIf
EndFunction
// **************************************************************
Function L3D_GetTrueLightColor( LightID As Integer )
	Retour As Integer
	Retour = DLight[ LightID ].Color
EndFunction Retour
// **************************************************************
Function L3D_GetTrueLightRange( LightID As Integer )
  Retour As Integer
  Retour = DLight[ LightID ].Range
 EndFunction Retour
// **************************************************************
Function L3D_GetDisplayCamera()
	CameraNumber As Integer = -1
	If L3DInitialized = 1
		CameraNumber = VisibilityCam
	EndIf
EndFunction CameraNumber
// **************************************************************
Function L3D_SetVisibilityDistance( Distance As Float )
	If L3DInitialized = 1
		VisibilityDistance = Distance
	EndIf
EndFunction
// **************************************************************
Function L3D_GetVisibilityDistance()
	Distance As Integer = 0
	If L3DInitialized = 1
		Distance = VisibilityDistance
	EndIf
 EndFunction Distance
// **************************************************************
Function L3D_ShowVLight( LightNumber As Integer )
	If L3DInitialized = 1
		If VLight[ LightNumber ].Active = 1
			VLight[ LightNumber ].On = 1
		EndIf
	EndIf
EndFunction
// **************************************************************
Function L3D_HideVLight( LightNumber As Integer )
	If L3DInitialized = 1
		If VLight[ LightNumber ].Active = 1
			VLight[ LightNumber ].On = 0
		EndIf
	EndIf
EndFunction
// **************************************************************
                                                              // Empêche la DLL d'utiliser la lumière et la laisse libre pour l'utilisateur.
Function L3D_LockLight( LightNumber As Integer )
	If L3DInitialized = 1
		If DLight[ LightNumber ].Active = 1
			L3D_TurnOffLight( LightNumber )
		EndIf
		DLight[ LightNumber ].Locked = 1
		DLight[ LightNumber ].VLight = 0
		DLight[ LightNumber ].Active = 0
	EndIf
EndFunction
// **************************************************************
//                                                                // Permet à la DLL d'utiliser une lumière pour les lumières réelles.
Function L3D_UnLockLight( LightNumber As Integer )
	If L3DInitialized = 1
		DLight[ LightNumber ].Locked = 0
		DLight[ LightNumber ].VLight = 0
		DLight[ LightNumber ].Active = 0
	EndIf
EndFunction
// **************************************************************
//                                                                // Renvoie le nombre de lumières pouvant être utilisées.
Function L3D_GetTotalFreeLight()
	If L3DInitialized = 1
		LCount As Integer = 0
		For XLoop = 0 To 7
			If DLight[ XLoop ].Locked = 0
				LCount = LCount + 1
			EndIf
		Next XLoop 
	Else
		LCount = 0
	EndIf
 EndFunction LCount
// **************************************************************
//                                                                // Renvoie 1 si la lumière est bloquée.
Function L3D_GetLocked( LightNumber As Integer )
	GLocked As Integer = -1
	If L3DInitialized = 1
		GLocked = DLight[ LightNumber ].Locked
	EndIf
EndFunction GLocked
// **************************************************************
//
Function L3D_AddVirtualLight( XPos As Float, YPos As Float, ZPos As Float, Range As Float, Red As Integer, Green As Integer, Blue As Integer, lType As Integer )
	If L3DInitialized = 1
		Target As Integer
		Targer = DLH_GetNextFreeItem()
		If Target > 0
			VLight[ Target ].Active = 1
			VLight[ Target ].On = 1
			VLight[ Target ].XPos = XPos
			VLight[ Target ].YPos = YPos
			VLight[ Target ].ZPos = Zpos
			VLight[ Target ].Range = Range
			VLight[ Target ].Red = Red
			VLight[ Target ].Green = Green
			VLight[ Target ].Blue = Blue
			VLight[ Target ].lType = lType
		EndIf
	Else
		Target = 0
	EndIf
EndFunction Target
// **************************************************************
//
Function L3D_SetVLightColor( LightNumber As Integer, Red As Integer, Green As Integer, Blue As Integer )
	If L3DInitialized = 1
		If VLight[ LightNumber ].Active = 1
			VLight[ LightNumber ].Red = Red
			VLight[ LightNumber ].Green = Green
			VLight[ LightNumber ].Blue = Blue
		EndIf
	EndIf
EndFunction
// **************************************************************
//
Function L3D_SetVLightRange( LightNumber As Integer, Range As Float )
	If L3DInitialized = 1
		If VLight[ LightNumber ].Active = 1
			VLight[ LightNumber ].Range = Range
		EndIf
	EndIf
EndFunction
// **************************************************************
//
Function L3D_PositionVLight( LightNumber As Integer, XPos As Float, YPos As Float, ZPos As Float )
	If L3DInitialized = 1
		If VLight[ LightNumber ].Active = 1
			VLight[ LightNumber ].XPos = XPos
			VLight[ LightNumber ].YPos = YPos
			VLight[ LightNumber ].ZPos = ZPos
		EndIf
	EndIf
EndFunction
// **************************************************************
//
Function L3D_DeleteVirtualLight( LightNumber As Integer )
	Target As Integer = 0
	If L3DInitialized = 1
		If VLight[ LightNumber ].Active = 1
			VLight[ LightNumber ].Active = 0
			VLight[ LightNumber ].On = 0
			VLight[ LightNumber ].XPos = 0
			VLight[ LightNumber ].YPos = 0
			VLight[ LightNumber ].ZPos = 0
			VLight[ LightNumber ].Range = 0
			VLight[ LightNumber ].Red = 0
			VLight[ LightNumber ].Green = 0
			VLight[ LightNumber ].Blue = 0
			VLight[ LightNumber ].Style = 0
		EndIf
		Target = DLH_FreeItem( LightNumber )
	EndIf
EndFunction Target
//
// **************************************************************
Function L3D_SetVLightHalo( LightNumber As Integer, HaloImage As Integer )
	If L3DInitialized = 1
		If VLight[ LightNumber ].Active = 1
			If HaloImage > 0
				If GetImageExists( HaloImage ) = 1
					VLight[ LightNumber ].Halo = HaloImage
				EndIf
			Else
				VLight[ LightNumber ].Halo = 0
			EndIf
		EndIf
	EndIf
EndFunction
// **************************************************************
Function L3D_SetVLightAsFixed( LightNumber As Integer )
	If L3DInitialized = 1
		If VLight[ LightNumber ].Active = 1
			VLight[ LightNumber ].lType = 0
		EndIf
	EndIf
EndFunction
// **************************************************************
Function L3D_SetVLightAsFlame( LightNumber As Integer )
	If L3DInitialized = 1
		If VLight[ LightNumber ].Active = 1
			VLight[ LightNumber ].lType = 1
		EndIf
	EndIf
EndFunction
// **************************************************************
Function L3D_SetVLightAsPulse( LightNumber As Integer )
	If L3DInitialized = 1
		If VLight[ LightNumber ].Active = 1
			VLight[ LightNumber ].lType = 2
		EndIf
	EndIf
EndFunction
// **************************************************************
Function L3D_SetVLightAsFlashs( LightNumber As Integer )
	If L3DInitialized = 1
		If VLight[ LightNumber ].Active = 1
			VLight[ LightNumber ].lType = 3
		EndIf
	EndIf
EndFunction
//
// **************************************************************
// **************************************************************
// **************************************************************
// **************************************************************
//
Function L3D_GetVirtualLightsCount()
	Target As Integer = 0
	If L3DInitialized = 1
		Target = DLH_GetCount()
	EndIf
 EndFunction Target
//

Function L3D_ClearVirtualLights()
	If L3DInitialized = 1
		// On Supprime la liste des lumières virtuelles.
		Count As Integer
		Count = DLH_GetItemCounter()
		For XLoop = Count To 0 Step -1
			VLight[ XLoop ].Active = 0 : VLight[ XLoop ].On = 0
			VLight[ XLoop ].XPos = 0 : VLight[ XLoop ].YPos = 0 : VLight[ XLoop ].ZPos = 0
			VLight[ XLoop ].Red = 0 : VLight[ XLoop ].Green = 0 : VLight[ XLoop ].Blue = 0
			VLight[ XLoop ].Range = 0 : VLight[ XLoop ].Style = 0
		Next XLoop
		// On supprime tout les objets qui ne l'auraient pas été...
		DLH_ClearList()
		// On Supprime les lumières réelles non lockées et donc potentiellement utilisées par le système.
		For XLoop = 1 To 7
			If DLight[ XLoop ].Locked = 0 And DLight[ XLoop ].VLight > 0
				If GetPointLightExists( XLoop ) = 1
					DeletePointLight( XLoop )
					DLight[ XLoop ].VLight = 0
					DLight[ XLoop ].Active = 0
					If DLight[ XLoop ].HaloObject > 0
						If GetObjectExists( DLight[ XLoop ].HaloObject ) = 1
							DeleteObject( DLight[ XLoop ].HaloObject ) // Suppression des HALOS lumineux.
							DLight[ XLoop ].HaloObject = 0
						EndIf
					EndIf
				EndIf
			EndIf
		Next XLoop
	EndIf
EndFunction
//
Function L3D_RefreshLights()
	Count As Integer = 0
	If L3DInitialized = 1
		TILESMAX As Integer = 8
		// On récupère la position de la caméra de visibilité.
		XCamPos As Float : XCamPos = GetCameraX( VisibilityCam )
		YCamPos As Float : YCamPos = GetCameraY( VisibilityCam )
		ZCamPos As Float : ZCamPos = GetCameraZ( VisibilityCam )
		// On compte le nombre de lumières réelles libres pour l'affichage des lumières virtuelles.
		LCount As Integer = 0
		For XLoop = 1 To 7
			If DLight[ XLoop ].Locked = 0
				LCount = LCount + 1
			EndIf
		Next XLoop
		// On va parcourir la liste pour savoir quelles sont les LCOUNT lumières les plus proches.
		VCount As Integer : VCount = DLH_GetItemCounter()
		L3D_ClearList()
		For XLoop = 1 To VCount + 1
			// On ne prends en compte la lumière que si elle existe et qu'elle est activée ( = on )
			If VLight[ XLoop ].Active = 1
				If VLight[ XLoop ].On = 1
					NewDistance As Float
					NewDistance = L3D_GetDistance( XCamPos, YCamPos, ZCamPos, VLight[ XLoop ].Xpos, VLight[ XLoop ].YPos, VLight[ XLoop ].Zpos )
					If NewDistance < VisibilityDistance
						LightPos As Integer : LightPos = L3D_CheckInListPos( NewDistance )
						If LightPos < 8
							L3D_InsertInList( XLoop, NewDistance , LightPos )
						EndIf
					EndIf
				EndIf
			EndIf
		Next XLoop
		Count = L3D_RefreshTrueLight()
	EndIf
 EndFunction Count

    
