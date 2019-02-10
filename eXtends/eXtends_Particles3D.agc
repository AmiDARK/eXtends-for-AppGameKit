
//
Function P3D_SetParticleImage( ParticleID AS INTEGER, ImageID AS INTEGER )
	if P3DInitialized = 1
		if ParticleSystem[ ParticleID ].Exist = 1
			if ImageID > 0
				if GetImageExists( ImageID ) = 1
					for PLoop = 1 to ParticleSystem[ ParticleID ].Count Step 1
						Object = ParticleObject[ ParticleID, PLoop ].Number
						if Object > 0 then SetObjectImage( Object, ImageID, 0 )
					next PLoop
				else
					// Message d'erreur "L'image demandée n'existe pas
				endif
			else
				// Message d'erreur "Numéro d'image invalide"
			endif
		else
			// Message d'erreur "Système de particule ID# ParticleID non créé"
		endif
	else
		// Message d'erreur "système particle 3D non initialisé
	endif
EndFunction

Function P3D_HideParticle( ParticleID AS INTEGER )
	If P3DInitialized = 1
		If ParticleSystem[ ParticleID ].Hide = 0
			ParticleSystem[ ParticleID ].Hide = 1
			For XLoop = 0 To ParticleSystem[ ParticleID ].Count
				SetObjectVisible( ParticleObject[ ParticleID , XLoop ].Number, 0 )
			Next XLoop
		else
			// Systeme de particule déjà masqué, pas de message d'erreur.
		EndIf
	else
		// Message d'erreur "système particle 3D non initialisé
	EndIf
EndFunction

Function P3D_ShowParticle( ParticleID AS INTEGER )
	If P3DInitialized = 1
		If ParticleSystem[ ParticleID ].Hide = 1
			ParticleSystem[ ParticleID ].Hide = 0
			For XLoop = 0 To ParticleSystem[ ParticleID ].Count
				SetObjectVisible( ParticleObject[ ParticleID , XLoop ].Number, 1 )
			Next XLoop
		else
			// Systeme de particule déjà masqué, pas de message d'erreur.
		EndIf
	else
		// Message d'erreur "système particle 3D non initialisé
	EndIf
EndFunction

Function P3D_GetParticleExist( ParticleID AS INTEGER )
	retour AS INTEGER = 0
	if P3DInitialized = 1
		Retour = ParticleSystem[ ParticleID ].exist
	else
		// Message d'erreur "système particle 3D non initialisé
	Endif
EndFunction retour

Function P3D_DeleteParticle( ParticleID AS INTEGER )
	If P3DInitialized = 1
		If ParticleSystem[ ParticleID ].Exist = 1
			If ParticleSystem[ ParticleID ].Hide = 1
				P3D_ShowParticle( ParticleID )
			EndIf
			ParticleSystem[ ParticleID ].Exist = 0
			ParticleSystem[ ParticleID ].mType = 0
			ParticleSystem[ ParticleID ].Count = 0
			ParticleSystem[ ParticleID ].Size = 0
			// Update to handle internal graphics for custom presets.
			If ParticleSystem[ ParticleID ].UseInternal = 1
				DeleteImage( ParticleSystem[ ParticleID ].LoadedImage )
				ParticleSystem[ ParticleID ].LoadedImage = 0
			EndIf
			ParticleSystem[ ParticleID ].UseInternal = 0
			ParticleID = DLH_FreeItem( ParticleID )
		EndIf
	 Else
		// Message d'erreur "système particle 3D non initialisé
	 EndIf
EndFunction 0

Function P3D_Clear()
	If P3DInitialized = 1
		// On supprime tout les objets qui ne l'auraient pas été...
		If DLH_GetItemCounter() > 0
			For XLoop = DLH_GetItemCounter() To 1 Step -1
				If P3D_GetParticleExist( XLoop ) = 1
					Null = P3D_DeleteParticle( XLoop )
				EndIf
			Next XLoop
			ObjectCount = 0
		EndIf
		// On efface la pile des objets.
		DLH_ClearList()
	EndIf
EndFunction

Function P3D_AddParticles( ParticleCount AS INTEGER , ParticleImage AS INTEGER , ParticleSize AS FLOAT )
	ParticleID = 0
	If P3DInitialized = 1
		ParticleID = DLH_GetNextFreeItem()
		If ParticleID > 0 And ParticleID < 256 And ParticleCount > 8 And ParticleSize > 0.0
			// Si le groupement de particules n'existe pas, on le crée
			If ParticleSystem[ ParticleID ].Exist = 0
				ParticleSystem[ ParticleID ].Exist = 1
				ParticleSystem[ ParticleID ].mType = 0
				ParticleSystem[ ParticleID ].Count = ParticleCount
				ParticleSystem[ ParticleID ].Size =	ParticleSize
				If ParticleImage > 0
					If GetImageExists( ParticleImage ) <> 0
						ParticleSystem[ ParticleID ].LoadedImage = ParticleImage
					Else
						ParticleSystem[ ParticleID ].LoadedImage = 0
						ParticleImage = 0
					EndIf
				Else
					ParticleSystem[ ParticleID ].LoadedImage = 0
					ParticleImage = 0
				EndIf
				For XLoop = 1 To ParticleCount
					Objet = CreateObjectPlane( ParticleSize, ParticleSize )
					SetObjectCollisionMode( Objet, 0 )
					ParticleObject[ ParticleID , XLoop ].Number = Objet
					If Objet > 0
						If ParticleImage > 0
							If GetImageExists( ParticleImage ) <> 0
								SetObjectImage( Objet , ParticleImage , 0 )
							EndIf
						EndIf
						ParticleObject[ ParticleID , XLoop ].XPos = 0
						ParticleObject[ ParticleID , XLoop ].YPos = 0
						ParticleObject[ ParticleID , XLoop ].ZPos = 0
						B3D_AddBillBoardToList( Objet )
					EndIf
				Next XLoop
			EndIf
		EndIf
	EndIf
Endfunction ParticleID

Function P3D_PositionParticles( ParticleID AS INTEGER , XPos AS INTEGER , YPos AS INTEGER , ZPos AS INTEGER )
	If P3DInitialized = 1
		If ParticleID > 0 And ParticleID < 256 
			If ParticleSystem[ ParticleID ].Exist = 1
				ParticleSystem[ ParticleID ].XEmitter = XPos
				ParticleSystem[ ParticleID ].YEmitter = YPos
				ParticleSystem[ ParticleID ].ZEmitter = ZPos
				If ParticleSystem[ ParticleID ].XSize > 0 And ParticleSystem[ ParticleID ].YSize > 0 And ParticleSystem[ ParticleID ].ZSize > 0
					XSize = ParticleSystem[ ParticleID ].XSize
					YSize = ParticleSystem[ ParticleID ].YSize
					ZSize = ParticleSystem[ ParticleID ].ZSize
					ParticleSystem[ ParticleID ].XMin = ParticleSystem[ ParticleID ].XEmitter - ( Xsize / 2 )
					ParticleSystem[ ParticleID ].XMax = ParticleSystem[ ParticleID ].XEmitter + ( Xsize / 2 )
					ParticleSystem[ ParticleID ].YMin = ParticleSystem[ ParticleID ].YEmitter - ( Ysize / 2 )
					ParticleSystem[ ParticleID ].YMax = ParticleSystem[ ParticleID ].YEmitter + ( Ysize / 2 )
					ParticleSystem[ ParticleID ].ZMin = ParticleSystem[ ParticleID ].ZEmitter - ( Zsize / 2 )
					ParticleSystem[ ParticleID ].ZMax = ParticleSystem[ ParticleID ].ZEmitter + ( Zsize / 2 )
				 EndIf
			 EndIf
		 EndIf
	 EndIf
 EndFunction 
 
 Function P3D_SetEmitterRange( ParticleID AS INTEGER , XSize AS INTEGER , YSize AS INTEGER , ZSize AS INTEGER )
	If P3DInitialized = 1
		If ParticleID > 0 And ParticleID < 256 
			If ParticleSystem[ ParticleID ].Exist = 1
				ParticleSystem[ ParticleID ].XSize = XSize
				ParticleSystem[ ParticleID ].YSize = YSize
				ParticleSystem[ ParticleID ].ZSize = ZSize
				ParticleSystem[ ParticleID ].XMin = ParticleSystem[ ParticleID ].XEmitter - ( Xsize / 2 )
				ParticleSystem[ ParticleID ].XMax = ParticleSystem[ ParticleID ].XEmitter + ( Xsize / 2 )
				ParticleSystem[ ParticleID ].YMin = ParticleSystem[ ParticleID ].YEmitter - ( Ysize / 2 )
				ParticleSystem[ ParticleID ].YMax = ParticleSystem[ ParticleID ].YEmitter + ( Ysize / 2 )
				ParticleSystem[ ParticleID ].ZMin = ParticleSystem[ ParticleID ].ZEmitter - ( Zsize / 2 )
				ParticleSystem[ ParticleID ].ZMax = ParticleSystem[ ParticleID ].ZEmitter + ( Zsize / 2 )
			 EndIf
		 EndIf
	 EndIf
 EndFunction 

Function P3D_SetParticlePath( ParticleID AS INTEGER , XMove AS INTEGER , YMove AS INTEGER , ZMove AS INTEGER )
	If P3DInitialized = 1
		If ParticleID > 0 And ParticleID < 256 
			If ParticleSystem[ ParticleID ].Exist = 1
				ParticleSystem[ ParticleID ].XMove = XMove
				ParticleSystem[ ParticleID ].YMove = YMove
				ParticleSystem[ ParticleID ].ZMove = ZMove
			 EndIf
		 EndIf
	 EndIf
 EndFunction 

Function P3D_GetParticleXPath( ParticleID AS INTEGER )
	Retour AS FLOAT : Retour = ParticleSystem[ ParticleID ].XMove 
 EndFunction Retour

Function P3D_GetParticleYPath( ParticleID AS INTEGER )
	Retour AS FLOAT : Retour = ParticleSystem[ ParticleID ].YMove
 EndFunction Retour

Function P3D_GetParticleZPath( ParticleID AS INTEGER )
	Retour AS FLOAT : Retour = ParticleSystem[ ParticleID ].ZMove
 EndFunction Retour

Function P3D_SetAsPrimitive( ParticleID AS INTEGER )
	If P3DInitialized = 1
		If ParticleID > 0 And ParticleID < 256 
			If ParticleSystem[ ParticleID ].Exist = 1
				ParticleSystem[ ParticleID ].mType = 0
			 EndIf
		 EndIf
	 EndIf
 EndFunction 

Function P3DInt_CreateParticleImage( ParticleID AS INTEGER, Source AS STRING )
	If P3DInitialized = 1
		If ParticleID > 0 And ParticleID < 256 
			If ParticleSystem[ ParticleID ].Exist = 1
				// Si aucune image n'est utilisée pour la flamme, on utilise celle contenue dans la DLL.
				If ParticleSystem[ ParticleID ].LoadedImage = 0
					// Memb AS INTEGER : Memb = CreateMemblockFromFile( Source )
					// If Memb > 0
						Img AS INTEGER : Img = LoadImage( Source, 1 )
						ParticleSystem[ ParticleID ].loadedImage = Img
						ParticleSystem[ ParticleID ].UseInternal = 1
						If GetImageExists( Img ) = 1
							For XLoop = 1 To ParticleSystem[ ParticleID ].Count
								SetObjectImage( ParticleObject[ ParticleID , XLoop ].Number , Img, 0 )
							Next XLoop
						EndIf
					// EndIf
				EndIf
			EndIf
		EndIf
	EndIf
EndFunction 

Function P3D_SetAsFlames( ParticleID AS INTEGER )
	If P3DInitialized = 1
		If ParticleID > 0 And ParticleID < 256 
			If ParticleSystem[ ParticleID ].Exist = 1
				ParticleSystem[ ParticleID ].mType = 1
				
				P3DInt_CreateParticleImage( ParticleID, FLAMEPARTICLES )
				
				For XLoop = 1 To ParticleSystem[ ParticleID ].Count
					FLAMESTEP AS FLOAT : FLAMESTEP = 200.0 / ParticleSystem[ ParticleID ].Count
					// We Apply object properties to all entities to make a true flame
					SetObjectTransparency( ParticleObject[ ParticleID , XLoop ].Number , 2 )
					SetObjectLightMode( ParticleObject[ ParticleID , XLoop ].Number ,0 )
					SetObjectFogMode( ParticleObject[ ParticleID , XLoop ].Number , 1 )
					SetObjectDepthWrite( ParticleObject[ ParticleID , XLoop ].Number, 0 )
					B3D_EnableYRot( ParticleObject[ ParticleID , XLoop ].Number )
					// We position the flames for default settings.
					ParticleObject[ ParticleID , XLoop ].Duration = FLAMESTEP * XLoop
					XRand = Random( 0, ParticleSystem[ ParticleID ].XSize - ParticleSystem[ ParticleID ].Size )
					ZRand = Random( 0, ParticleSystem[ ParticleID ].ZSize - ParticleSystem[ ParticleID ].Size )
					ParticleObject[ ParticleID , XLoop ].Xpos = ParticleSystem[ ParticleID ].XMin + XRand + ( ParticleSystem[ ParticleID ].Size / 2 )
					ParticleObject[ ParticleID , XLoop ].Ypos = ParticleObject[ ParticleID , XLoop ].Duration * 0.1
					ParticleObject[ ParticleID , XLoop ].Zpos = ParticleSystem[ ParticleID ].ZMin + ZRand + ( ParticleSystem[ ParticleID ].Size / 2 )
				 Next XLoop				
				ParticleSystem[ ParticleID ].XMove = 0.0
				ParticleSystem[ ParticleID ].YMove = 0.25
				ParticleSystem[ ParticleID ].ZMove = 0.0
				ParticleSystem[ ParticleID ].Duration = ParticleSystem[ ParticleID ].YSize
			 EndIf
		 EndIf
	 EndIf
 EndFunction 

Function P3D_SetAsSmoke( ParticleID AS INTEGER )
	If P3DInitialized = 1
		If ParticleID > 0 And ParticleID < 256 
			If ParticleSystem[ ParticleID ].Exist = 1
				ParticleSystem[ ParticleID ].mType = 2
				
				P3DInt_CreateParticleImage( ParticleID, FLAMEPARTICLES )
				
				For XLoop = 1 To ParticleSystem[ ParticleID ].Count
					SMOKESTEP AS FLOAT : SMOKESTEP = 200.0 / ParticleSystem[ ParticleID ].Count
					SetObjectBlendModes( ParticleObject[ ParticleID , XLoop ].Number , 2, 10 ) // Was DBGhostObjectOn1()
//					// DBSetAlphaFactor( ParticleObject[ ParticleID , XLoop ].Number , 255 )
					SetObjectTransparency( ParticleObject[ ParticleID , XLoop ].Number , 0 )
					SetObjectLightMode( ParticleObject[ ParticleID , XLoop ].Number , 1 )
					SetObjectFogMode( ParticleObject[ ParticleID , XLoop ].Number , 1 )
					SetObjectDepthWrite( ParticleObject[ ParticleID , XLoop ].Number, 0 ) // DBDisableObjectZWrite()
					B3D_EnableYRot( ParticleObject[ ParticleID , XLoop ].Number )
					ParticleObject[ ParticleID , XLoop ].Duration = SMOKESTEP * XLoop
					XRand = Random( 0, ParticleSystem[ ParticleID ].XSize - ParticleSystem[ ParticleID ].Size )
					ZRand = Random( 0, ParticleSystem[ ParticleID ].ZSize - ParticleSystem[ ParticleID ].Size )
					ParticleObject[ ParticleID , XLoop ].Xpos = ParticleSystem[ ParticleID ].XMin + XRand + ( ParticleSystem[ ParticleID ].Size / 2 )
					ParticleObject[ ParticleID , XLoop ].Ypos = ParticleObject[ ParticleID , XLoop ].Duration * 0.1
					ParticleObject[ ParticleID , XLoop ].Zpos = ParticleSystem[ ParticleID ].ZMin + ZRand + ( ParticleSystem[ ParticleID ].Size / 2 )
				 Next XLoop
				ParticleSystem[ ParticleID ].XMove = 0.0
				ParticleSystem[ ParticleID ].YMove = 0.025
				ParticleSystem[ ParticleID ].ZMove = 0.0
				ParticleSystem[ ParticleID ].Duration = ParticleSystem[ ParticleID ].YSize
			 EndIf
		 EndIf
	 EndIf
 EndFunction 

Function P3D_SetAsRain( ParticleID AS INTEGER )
	If P3DInitialized = 1
		If ParticleID > 0 And ParticleID < 256 
			If ParticleSystem[ ParticleID ].Exist = 1
				ParticleSystem[ ParticleID ].mType = 3
				
				P3DInt_CreateParticleImage( ParticleID, RAINPARTICLES )
				
				For XLoop = 1 To ParticleSystem[ ParticleID ].Count


					SetObjectTransparency( ParticleObject[ ParticleID , XLoop ].Number , 2 )
					SetObjectLightMode( ParticleObject[ ParticleID , XLoop ].Number ,1 )
					SetObjectFogMode( ParticleObject[ ParticleID , XLoop ].Number , 1 )
					SetObjectDepthWrite( ParticleObject[ ParticleID , XLoop ].Number, 0 )
					SetObjectColor( ParticleObject[ ParticleID , XLoop ].Number, 128, 128, 128, 255 )
					B3D_DisableYRot( ParticleObject[ ParticleID , XLoop ].Number )
					XRand = Random( 0, ParticleSystem[ ParticleID ].XSize - ParticleSystem[ ParticleID ].Size )
					YRand = Random( 0, ParticleSystem[ ParticleID ].YSize - ParticleSystem[ ParticleID ].Size )
					ZRand = Random( 0, ParticleSystem[ ParticleID ].ZSize - ParticleSystem[ ParticleID ].Size )
					ParticleObject[ ParticleID , XLoop ].XPos = ParticleSystem[ ParticleID ].XMin + XRand
					ParticleObject[ ParticleID , XLoop ].YPos = ParticleSystem[ ParticleID ].YMin + YRand
					ParticleObject[ ParticleID , XLoop ].ZPos = ParticleSystem[ ParticleID ].ZMin + ZRand
				 Next XLoop
				ParticleSystem[ ParticleID ].XMove = 0.0
				ParticleSystem[ ParticleID ].YMove = 0.5
				ParticleSystem[ ParticleID ].ZMove = 0.0
				ParticleSystem[ ParticleID ].Duration = 0.0
			 EndIf
		 EndIf
	 EndIf
 EndFunction 

Function P3D_SetAsSnow( ParticleID AS INTEGER )
	If P3DInitialized = 1
		If ParticleID > 0 And ParticleID < 256 
			If ParticleSystem[ ParticleID ].Exist = 1
				ParticleSystem[ ParticleID ].mType = 4
				
				P3DInt_CreateParticleImage( ParticleID, SNOWPARTICLES )
				
				For XLoop = 1 To ParticleSystem[ ParticleID ].Count
					SetObjectTransparency( ParticleObject[ ParticleID , XLoop ].Number , 2 )
					SetObjectLightMode( ParticleObject[ ParticleID , XLoop ].Number ,0 )
					SetObjectFogMode( ParticleObject[ ParticleID , XLoop ].Number , 1 )
					SetObjectDepthWrite( ParticleObject[ ParticleID , XLoop ].Number, 0 )
					B3D_EnableYRot( ParticleObject[ ParticleID , XLoop ].Number )
					XRand = Random( 0, ParticleSystem[ ParticleID ].XSize - ParticleSystem[ ParticleID ].Size )
					YRand = Random( 0, ParticleSystem[ ParticleID ].YSize - ParticleSystem[ ParticleID ].Size )
					ZRand = Random( 0, ParticleSystem[ ParticleID ].ZSize - ParticleSystem[ ParticleID ].Size )
					ParticleObject[ ParticleID , XLoop ].XPos = ParticleSystem[ ParticleID ].XMin + XRand
					ParticleObject[ ParticleID , XLoop ].YPos = ParticleSystem[ ParticleID ].YMin + YRand
					ParticleObject[ ParticleID , XLoop ].ZPos = ParticleSystem[ ParticleID ].ZMin + ZRand
				 Next XLoop
				ParticleSystem[ ParticleID ].XMove = 0.0
				ParticleSystem[ ParticleID ].YMove = 0.0625
				ParticleSystem[ ParticleID ].ZMove = 0.0
				ParticleSystem[ ParticleID ].Duration = 0.0
			 EndIf
		 EndIf
	 EndIf
 EndFunction 

Function P3D_SetAsSparkle( ParticleID AS INTEGER )
	If P3DInitialized = 1
		If ParticleID > 0 And ParticleID < 256 
			If ParticleSystem[ ParticleID ].Exist = 1
				ParticleSystem[ ParticleID ].mType = 5
				P3DInt_CreateParticleImage( ParticleID, SPARKLEPARTICLES )
				For XLoop = 1 To ParticleSystem[ ParticleID ].Count
					SetObjectTransparency( ParticleObject[ ParticleID , XLoop ].Number , 2 )
					SetObjectLightMode( ParticleObject[ ParticleID , XLoop ].Number , 1 )
					SetObjectFogMode( ParticleObject[ ParticleID , XLoop ].Number , 1 )
					SetObjectDepthWrite( ParticleObject[ ParticleID , XLoop ].Number, 0 )
					SetObjectColor( ParticleObject[ ParticleId, XLoop ].Number, 128, 128, 128, 128 )
					B3D_EnableYRot( ParticleObject[ ParticleID , XLoop ].Number )
					XRand = Random2( 0, ParticleSystem[ ParticleID ].XSize - ParticleSystem[ ParticleID ].Size )
					YRand = Random2( 0, ParticleSystem[ ParticleID ].YSize - ParticleSystem[ ParticleID ].Size )
					ZRand = Random2( 0, ParticleSystem[ ParticleID ].ZSize - ParticleSystem[ ParticleID ].Size )
					ParticleObject[ ParticleID , XLoop ].XPos = ParticleSystem[ ParticleID ].XMin + XRand
					ParticleObject[ ParticleID , XLoop ].YPos = ParticleSystem[ ParticleID ].YMin + YRand
					ParticleObject[ ParticleID , XLoop ].ZPos = ParticleSystem[ ParticleID ].ZMin + ZRand
					ParticleObject[ ParticleID , XLoop ].Duration = Random( 0, 200.0 ) + 50.0
				 Next XLoop
				ParticleSystem[ ParticleID ].XMove = 0.0
				ParticleSystem[ ParticleID ].YMove = 0.0
				ParticleSystem[ ParticleID ].ZMove = 0.0
				ParticleSystem[ ParticleID ].Duration = 250.0
			 EndIf
		 EndIf
	 EndIf
 EndFunction 

Function P3D_UpdateParticles()
	If P3DInitialized = 1
		ActualTime = Timer()
		TimeChange AS FLOAT : TimeChange = ( ActualTime - OldTime ) * 1000
		If TimeChange > 60 : TimeChange = 60 : EndIf
		TimeFactor = TimeChange / 2.0 : OldTime = ActualTime
		For ParticleID = 1 To 256 
			If ParticleSystem[ ParticleID ].Exist = 1 And ParticleSystem[ ParticleID ].Hide = 0
				Select ParticleSystem[ ParticleID ].mType
					Case 0 : P3D_UpdateDefault( ParticleID ) : EndCase
					Case 1 : P3D_UpdateFlames( ParticleID ) : EndCase
					Case 2 : P3D_UpdateSmoke( ParticleID ) : EndCase
					Case 3 : P3D_UpdateRain( ParticleID ) : EndCase
					Case 4 : P3D_UpdateSnow( ParticleID ) : EndCase
					Case 5 : P3D_UpdateSparkles( ParticleID ) : EndCase
				 EndSelect
			 EndIf
		 Next ParticleID
	 EndIf
 EndFunction 

Function P3D_UpdateDefault( ParticleID AS INTEGER )
	If P3DInitialized = 1
		If ParticleID > 0 And ParticleID < 256 
			If ParticleSystem[ ParticleID ].Exist = 1
				For XLoop = 1 To ParticleSystem[ ParticleID ].Count
					// We move the particle component to its next position.
					ParticleObject[ ParticleID , XLoop ].Xpos = ParticleObject[ ParticleID , XLoop ].Xpos + ParticleSystem[ ParticleID ].XMove
					ParticleObject[ ParticleID , XLoop ].Ypos = ParticleObject[ ParticleID , XLoop ].Ypos + ParticleSystem[ ParticleID ].YMove
					ParticleObject[ ParticleID , XLoop ].Zpos = ParticleObject[ ParticleID , XLoop ].Zpos + ParticleSystem[ ParticleID ].ZMove
					// Checking for X limits
					If ParticleObject[ ParticleID , XLoop ].Xpos < ParticleSystem[ ParticleID ].XMin
						ParticleObject[ ParticleID , XLoop ].Xpos = ParticleSystem[ ParticleID ].XMax
					 EndIf
					If ParticleObject[ ParticleID , XLoop ].Xpos > ParticleSystem[ ParticleID ].XMax
						ParticleObject[ ParticleID , XLoop ].Xpos = ParticleSystem[ ParticleID ].XMin
					 EndIf
					// Checking for Y limits
					If ParticleObject[ ParticleID , XLoop ].Ypos < ParticleSystem[ ParticleID ].YMin
						ParticleObject[ ParticleID , XLoop ].Ypos = ParticleSystem[ ParticleID ].YMax
					 EndIf
					If ParticleObject[ ParticleID , XLoop ].Ypos > ParticleSystem[ ParticleID ].YMax
						ParticleObject[ ParticleID , XLoop ].Ypos = ParticleSystem[ ParticleID ].YMin
					 EndIf
					// Checking for Z limits
					If ParticleObject[ ParticleID , XLoop ].Zpos < ParticleSystem[ ParticleID ].ZMin
						ParticleObject[ ParticleID , XLoop ].Zpos = ParticleSystem[ ParticleID ].ZMax
					 EndIf
					If ParticleObject[ ParticleID , XLoop ].Zpos > ParticleSystem[ ParticleID ].ZMax
						ParticleObject[ ParticleID , XLoop ].Zpos = ParticleSystem[ ParticleID ].ZMin
					 EndIf
					// We finalize the object position changes.
					SetObjectPosition( ParticleObject[ ParticleID , XLoop ].Number , ParticleObject[ ParticleID , XLoop ].Xpos , ParticleObject[ ParticleID , XLoop ].Ypos , ParticleObject[ ParticleID , XLoop ].Zpos )
				 Next XLoop
			 EndIf
		 EndIf
	 EndIf
 EndFunction 

Function P3D_UpdateFlames( ParticleID AS INTEGER )
	If P3DInitialized = 1
		If ParticleID > 0 And ParticleID < 256 
			If ParticleSystem[ ParticleID ].Exist = 1
				For XLoop = 1 To ParticleSystem[ ParticleID ].Count
					If ParticleObject[ ParticleID , XLoop ].Number > 0
						If ParticleObject[ ParticleID , XLoop ].Duration > 0
							ParticleObject[ ParticleID , XLoop ].Duration = ParticleObject[ ParticleID , XLoop ].Duration - ( 0.5 * TimeFactor )
							If ParticleObject[ ParticleID , XLoop ].Duration < 0 : ParticleObject[ ParticleID , XLoop ].Duration = 0 : EndIf
							Red AS FLOAT = 255.0
							Green AS FLOAT : Green = ParticleObject[ ParticleID , XLoop ].Duration * 1.28 
							Blue AS FLOAT : Blue = ParticleObject[ ParticleID , XLoop ].Duration * 0.64
							Mult AS FLOAT
							If ParticleObject[ ParticleID , XLoop ].Duration < 200
								Mult = ParticleObject[ ParticleID , XLoop ].Duration / ParticleSystem[ ParticleID ].YSize
								If Mult < 0.0 : Mult = 0 : EndIf
								// DBSetEmissiveMaterial( ParticleObject[ ParticleID , XLoop ].Number , DBRgb( Red * Mult , Green * Mult , Blue * Mult ) ) // Vérifier si ColorEmissive is ok
								SetObjectColor( ParticleObject[ ParticleID, XLoop ].Number, Red * Mult, Green * Mult, Blue * Mult, 255 )
								// SetObjectColorEmissive( ParticleObject[ ParticleID, XLoop ].Number, Red / 4, Green /4, Blue /4 ,  )
							 Else
								Mult = Abs( 250 - ParticleObject[ ParticleID , Xloop ].Duration )
								If Mult < 0.0 : Mult = 0 : EndIf
								// DBSetEmissiveMaterial( ParticleObject[ ParticleID , XLoop ].Number , DBRgb( 255 * Mult , 255 * Mult , 255 * Mult ) ) // Vérifier si ColorEmissive is ok
								SetObjectColor( ParticleObject[ ParticleID , XLoop ].Number , 255 * Mult , 255 * Mult , 255 * Mult, 255 ) 
								// SetObjectColorEmissive( ParticleObject[ ParticleID , XLoop ].Number , Mult , Mult , Mult ) 
							 EndIf
							ParticleObject[ ParticleID , XLoop ].Xpos = ParticleObject[ ParticleID , XLoop ].Xpos + ( ParticleSystem[ ParticleID ].XMove * TimeFactor )
							ParticleObject[ ParticleID , XLoop ].Zpos = ParticleObject[ ParticleID , XLoop ].Zpos + ( ParticleSystem[ ParticleID ].ZMove * TimeFactor )
							ParticleObject[ ParticleID , XLoop ].YPos = ParticleObject[ ParticleID , XLoop ].YPos + ( ParticleSystem[ ParticleID ].YMove * TimeFactor)
							SetObjectPosition( ParticleObject[ ParticleID , XLoop ].Number , ParticleObject[ ParticleID , XLoop ].Xpos , ParticleObject[ ParticleID , XLoop ].Ypos , ParticleObject[ ParticleID , XLoop ].Zpos )
							If ParticleObject[ ParticleID , XLoop ].Duration <= 0
								SetObjectvisible( ParticleObject[ ParticleID , XLoop ].Number, 0 )
								If NextFlame = 0 : NextFlame = XLoop : EndIf
							 EndIf
						 Else
							If NextFlame = 0 : NextFlame = XLoop : EndIf
						 EndIf
					 EndIf
				 Next XLoop 
				If NextFlame > 0
					ParticleObject[ ParticleID , NextFlame ].Duration = ParticleSystem[ ParticleID ].Duration
					XRand = Random( 0, ParticleSystem[ ParticleID ].XSize - ParticleSystem[ ParticleID ].Size )
					ZRand = Random( 0, ParticleSystem[ ParticleID ].ZSize - ParticleSystem[ ParticleID ].Size )
					ParticleObject[ ParticleID , NextFlame ].Xpos = ParticleSystem[ ParticleID ].XMin + XRand + ( ParticleSystem[ ParticleID ].Size / 2 )
					ParticleObject[ ParticleID , NextFlame ].Ypos = ParticleSystem[ ParticleID ].YMin - 8
					ParticleObject[ ParticleID , NextFlame ].Zpos = ParticleSystem[ ParticleID ].ZMin + ZRand + ( ParticleSystem[ ParticleID ].Size / 2 )
					SetObjectPosition( ParticleObject[ ParticleID , NextFlame ].Number , ParticleObject[ ParticleID , NextFlame ].Xpos , ParticleObject[ ParticleID , NextFlame ].Ypos , ParticleObject[ ParticleID , NextFlame ].Zpos )
					SetObjectVisible( ParticleObject[ ParticleID , NextFlame ].Number, 1 )
					NextFlame = 0
				 EndIf
			 EndIf
		 EndIf
	 EndIf					
 EndFunction 

Function P3D_UpdateSmoke( ParticleID AS INTEGER )
	If P3DInitialized = 1
		If ParticleID > 0 And ParticleID < 256 
			If ParticleSystem[ ParticleID ].Exist = 1
				For XLoop = 1 To ParticleSystem[ ParticleID ].Count
					If ParticleObject[ ParticleID , XLoop ].Number > 0
						If ParticleObject[ ParticleID , XLoop ].Duration > 0
							ParticleObject[ ParticleID , XLoop ].Duration = ParticleObject[ ParticleID , XLoop ].Duration - ( 0.05 * TimeFactor )
							If ParticleObject[ ParticleID , XLoop ].Duration < 0 : ParticleObject[ ParticleID , Xloop ].Duration = 0 : EndIf
							If ParticleObject[ ParticleID , XLoop ].Duration < 200
								// DBFadeObject( ParticleObject[ ParticleID , XLoop ].Number , Int( ParticleObject[ ParticleID , XLoop ].Duration ) )                  // ***********************
							 Else
								Value AS INTEGER : Value = Abs( 200 - ParticleObject[ ParticleID , Xloop ].Duration ) : Value = ( 50 - Value ) * 2.0
								// DBFadeObject( ParticleObject[ ParticleID , XLoop ].Number , Value )                                                                 // ***********************
							 EndIf
							ParticleObject[ ParticleID , XLoop ].YPos = ParticleObject[ ParticleID , XLoop ].YPos + ( ParticleSystem[ ParticleID ].YMove * TimeFactor )
							SetObjectPosition( ParticleObject[ ParticleID , XLoop ].Number , ParticleObject[ ParticleID , XLoop ].Xpos , ParticleObject[ ParticleID , XLoop ].Ypos , ParticleObject[ ParticleID , XLoop ].Zpos )
							If ParticleObject[ ParticleID , XLoop ].Duration <= 0 
								SetObjectVisible( ParticleObject[ ParticleID , XLoop ].Number, 0 )
								If NextSmoke = 0 : NextSmoke = XLoop : EndIf
							 EndIf
						 Else
							If NextSmoke = 0 : NextSmoke = XLoop : EndIf
						 EndIf
					 EndIf
				 Next XLoop						 
				If NextSmoke > 0
					ParticleObject[ ParticleID , NextSmoke ].Duration = ParticleSystem[ ParticleID ].Duration
					XRand = Random( 0, ParticleSystem[ ParticleID ].XSize - ParticleSystem[ ParticleID ].Size )
					ZRand = Random( 0, ParticleSystem[ ParticleID ].ZSize - ParticleSystem[ ParticleID ].Size )
					ParticleObject[ ParticleID , NextSmoke ].Xpos = ParticleSystem[ ParticleID ].XMin + XRand + ( ParticleSystem[ ParticleID ].Size / 2 )
					ParticleObject[ ParticleID , NextSmoke ].Ypos = ParticleSystem[ ParticleID ].YMin - 8
					ParticleObject[ ParticleID , NextSmoke ].Zpos = ParticleSystem[ ParticleID ].ZMin + ZRand + ( ParticleSystem[ ParticleID ].Size / 2 )
					SetObjectPosition( ParticleObject[ ParticleID , NextSmoke ].Number , ParticleObject[ ParticleID , NextSmoke ].Xpos , ParticleObject[ ParticleID , NextSmoke ].Ypos , ParticleObject[ ParticleID , NextSmoke ].Zpos )
					SetObjectVisible( ParticleObject[ ParticleID , NextSmoke ].Number, 1 )
					NextSmoke = 0
				 EndIf
			 EndIf
		 EndIf
	 EndIf					
 EndFunction 

Function P3D_UpdateSnow( ParticleID AS INTEGER )
	If P3DInitialized = 1
		If ParticleID > 0 And ParticleID < 256 
			If ParticleSystem[ ParticleID ].Exist = 1
				For XLoop = 1 To ParticleSystem[ ParticleID ].Count
					If ParticleObject[ ParticleID , XLoop ].Number > 0
						XShift AS FLOAT : XShift = TimeFactor * ( ( Random ( 0, 10 ) - 5.0 ) / 100.0 )
						ZShift AS FLOAT : YShift = TimeFactor * ( ( Random ( 0, 10 ) - 5.0 ) / 100.0 )
						ParticleObject[ ParticleID , XLoop ].Xpos = ParticleObject[ ParticleID , XLoop ].Xpos + XShift
						ParticleObject[ ParticleID , XLoop ].Zpos = ParticleObject[ ParticleID , XLoop ].Zpos + ZShift 
						ParticleObject[ ParticleID , XLoop ].YPos = ParticleObject[ ParticleID , XLoop ].YPos - ( ParticleSystem[ ParticleID ].YMove * TimeFactor )
						If ParticleObject[ ParticleID , XLoop ].Xpos < ParticleSystem[ ParticleID ].XMin
							ParticleObject[ ParticleID , Xloop ].Xpos = ParticleSystem[ ParticleID ].XMax - 4
						 Else
							If ParticleObject[ ParticleID , Xloop ].Xpos > ParticleSystem[ ParticleID ].XMax
								ParticleObject[ ParticleID , Xloop ].Xpos = ParticleSystem[ ParticleID ].Xmin + 4
							 EndIf
						 EndIf
						If ParticleObject[ ParticleID , XLoop ].YPos < ParticleSystem[ ParticleID ].YMin
							ParticleObject[ ParticleID , XLoop ].YPos = ParticleSystem[ ParticleID ].YMax
							XRand = Random( 0, ParticleSystem[ ParticleID ].XSize - ParticleSystem[ ParticleID ].Size )
							ZRand = Random( 0, ParticleSystem[ ParticleID ].ZSize - ParticleSystem[ ParticleID ].Size )
							ParticleObject[ ParticleID , XLoop ].XPos = ParticleSystem[ ParticleID ].XMin + Xrand
							ParticleObject[ ParticleID , XLoop ].ZPos = ParticleSystem[ ParticleID ].ZMin + Zrand
						 Else
							If ParticleObject[ ParticleID , XLoop ].YPos > ParticleSystem[ ParticleID ].YMax
								ParticleObject[ ParticleID , XLoop ].YPos = ParticleSystem[ ParticleID ].YMax
								XRand = Random( 0, ParticleSystem[ ParticleID ].XSize - ParticleSystem[ ParticleID ].Size )
								ZRand = Random( 0, ParticleSystem[ ParticleID ].ZSize - ParticleSystem[ ParticleID ].Size )
								ParticleObject[ ParticleID , XLoop ].XPos = ParticleSystem[ ParticleID ].XMin + Xrand
								ParticleObject[ ParticleID , XLoop ].ZPos = ParticleSystem[ ParticleID ].ZMin + Zrand
							 EndIf
						 EndIf
						If ParticleObject[ ParticleID , XLoop ].Zpos < ParticleSystem[ ParticleID ].ZMin
							ParticleObject[ ParticleID , Xloop ].Zpos = ParticleSystem[ ParticleID ].ZMax - 4
						 Else
							If ParticleObject[ ParticleID , Xloop ].Zpos > ParticleSystem[ ParticleID ].ZMax
								ParticleObject[ ParticleID , Xloop ].Zpos = ParticleSystem[ ParticleID ].Zmin + 4
							 EndIf
						 EndIf
						SetObjectPosition( ParticleObject[ ParticleID , Xloop ].Number , ParticleObject[ ParticleID , Xloop ].Xpos , ParticleObject[ ParticleID , Xloop ].Ypos , ParticleObject[ ParticleID , Xloop ].Zpos )
					 EndIf
				 Next XLoop
			 EndIf
		 EndIf
	 EndIf					
 EndFunction 

Function P3D_UpdateRain( ParticleID AS INTEGER )
	If P3DInitialized = 1
		If ParticleID > 0 And ParticleID < 256 
			If ParticleSystem[ ParticleID ].Exist = 1
				For XLoop = 1 To ParticleSystem[ ParticleID ].Count
					If ParticleObject[ ParticleID , XLoop ].Number > 0
//						XShift AS FLOAT = TimeFactor * ( ( Random ( 0, 10 ) - 5.0 ) / 100.0 )
//						ZShift AS FLOAT = TimeFactor * ( ( Random ( 0, 10 ) - 5.0 ) / 100.0 )
//						ParticleObject[ ParticleID , XLoop ].Xpos = ParticleObject[ ParticleID , XLoop ].Xpos + XShift
//						ParticleObject[ ParticleID , XLoop ].Zpos = ParticleObject[ ParticleID , XLoop ].Zpos + ZShift 
						ParticleObject[ ParticleID , XLoop ].YPos = ParticleObject[ ParticleID , XLoop ].YPos - ( ParticleSystem[ ParticleID ].YMove * TimeFactor )
						If ParticleObject[ ParticleID , XLoop ].Xpos < ParticleSystem[ ParticleID ].XMin
							ParticleObject[ ParticleID , Xloop ].Xpos = ParticleSystem[ ParticleID ].XMax - 4
						 Else
							If ParticleObject[ ParticleID , Xloop ].Xpos > ParticleSystem[ ParticleID ].XMax
								ParticleObject[ ParticleID , Xloop ].Xpos = ParticleSystem[ ParticleID ].Xmin + 4
							 EndIf
						 EndIf
						If ParticleObject[ ParticleID , XLoop ].YPos < ParticleSystem[ ParticleID ].YMin
							ParticleObject[ ParticleID , XLoop ].YPos = ParticleSystem[ ParticleID ].YMax
							XRand = Random( 0, ParticleSystem[ ParticleID ].XSize - ParticleSystem[ ParticleID ].Size )
							ZRand = Random( 0, ParticleSystem[ ParticleID ].ZSize - ParticleSystem[ ParticleID ].Size )
							ParticleObject[ ParticleID , XLoop ].XPos = ParticleSystem[ ParticleID ].XMin + Xrand
							ParticleObject[ ParticleID , XLoop ].ZPos = ParticleSystem[ ParticleID ].ZMin + Zrand
						 EndIf
						If ParticleObject[ ParticleID , XLoop ].Zpos < ParticleSystem[ ParticleID ].ZMin
							ParticleObject[ ParticleID , Xloop ].Zpos = ParticleSystem[ ParticleID ].ZMax - 4
						 Else
							If ParticleObject[ ParticleID , Xloop ].Zpos > ParticleSystem[ ParticleID ].ZMax
								ParticleObject[ ParticleID , Xloop ].Zpos = ParticleSystem[ ParticleID ].Zmin + 4
							 EndIf
						 EndIf
						SetObjectPosition( ParticleObject[ ParticleID , Xloop ].Number , ParticleObject[ ParticleID , Xloop ].Xpos , ParticleObject[ ParticleID , Xloop ].Ypos , ParticleObject[ ParticleID , Xloop ].Zpos )
					 EndIf
				 Next XLoop
			 EndIf
		 EndIf
	 EndIf					
 EndFunction 

Function P3D_UpdateSparkles( ParticleID AS INTEGER )
	If P3DInitialized = 1
		If ParticleID > 0 And ParticleID < 256 
			If ParticleSystem[ ParticleID ].Exist = 1
				For XLoop = 1 To ParticleSystem[ ParticleID ].Count
					ParticleObject[ ParticleID, XLoop ].Duration = ParticleObject[ ParticleID, XLoop ].Duration - TimeFactor
					If ParticleObject[ ParticleID, XLoop ].Duration < 0
						// On recrée la particule dans l'espace prévu pour.
						ParticleObject[ ParticleID, XLoop ].Duration = ParticleSystem[ ParticleID ].Duration
						XRand = Random2( 0, ParticleSystem[ ParticleID ].XSize - ParticleSystem[ ParticleID ].Size )
						YRand = Random2( 0, ParticleSystem[ ParticleID ].YSize - ParticleSystem[ ParticleID ].Size )
						ZRand = Random2( 0, ParticleSystem[ ParticleID ].ZSize - ParticleSystem[ ParticleID ].Size )
						ParticleObject[ ParticleID , XLoop ].XPos = ParticleSystem[ ParticleID ].XMin + XRand
						ParticleObject[ ParticleID , XLoop ].YPos = ParticleSystem[ ParticleID ].YMin + YRand
						ParticleObject[ ParticleID , XLoop ].ZPos = ParticleSystem[ ParticleID ].ZMin + ZRand		 
					 Else
						// On met à jour les Sparkles ...
						ParticlePhase AS FLOAT : ParticlePhase = ( ParticleObject[ ParticleID, XLoop ].Duration / ParticleSystem[ ParticleID ].Duration ) * 100.0
						Percent AS FLOAT
						If ParticlePhase < 75.0
							// Phase 2 - Descendante
							Percent = ( ParticlePhase * 4.0 ) / 3.0
						 Else
							// Phase 1 - Ascendante
							Percent = ( 25.0 - Abs( 75 - ParticlePhase ) ) * 4.0
						 EndIf
						SetObjectColor( ParticleObject[ ParticleID , XLoop ].Number, Percent * 3.0, Percent * 3.0, Percent * 3.0, Percent * 3.0 )
						SetObjectPosition( ParticleObject[ ParticleID , Xloop ].Number , ParticleObject[ ParticleID , Xloop ].Xpos , ParticleObject[ ParticleID , Xloop ].Ypos , ParticleObject[ ParticleID , Xloop ].Zpos )
					 EndIf
				 Next XLoop
			 EndIf
		 EndIf
	 EndIf					
 EndFunction 

Function P3D_GetParticleXRange( ParticleID AS INTEGER )
	Range AS INTEGER
	If P3DInitialized = 1
		Range = ParticleSystem[ ParticleID ].XSize
	 Else
		Range = -1
	 EndIf
 EndFunction Range

Function P3D_GetParticleYRange( ParticleID AS INTEGER )
	Range AS INTEGER
	If P3DInitialized = 1
		Range = ParticleSystem[ ParticleID ].YSize
	 Else
		Range = -1
	 EndIf
 EndFunction Range

Function P3D_GetParticleZRange( ParticleID AS INTEGER )
	Range AS INTEGER
	If P3DInitialized = 1
		Range = ParticleSystem[ ParticleID ].ZSize
	 Else
		Range = -1
	 EndIf
 EndFunction Range

Function P3D_GetParticleXPosition( ParticleID AS INTEGER )
	Range AS INTEGER
	If P3DInitialized = 1
		Range = ParticleSystem[ ParticleID ].XEmitter
	 Else
		Range = -1
	 EndIf
 EndFunction Range

Function P3D_GetParticleYPosition( ParticleID AS INTEGER )
	Range AS INTEGER
	If P3DInitialized = 1
		Range = ParticleSystem[ ParticleID ].YEmitter
	 Else
		Range = -1
	 EndIf
 EndFunction Range

Function P3D_GetParticleZPosition( ParticleID AS INTEGER )
	Range AS INTEGER
	If P3DInitialized = 1
		Range = ParticleSystem[ ParticleID ].ZEmitter
	 Else
		Range = -1
	 EndIf
 EndFunction Range

Function P3D_GetParticleCount( ParticleID AS INTEGER )
	Range AS INTEGER
	If P3DInitialized = 1
		Range = ParticleSystem[ ParticleID ].Count
	 Else
		Range = -1
	 EndIf
 EndFunction Range

Function P3D_GetParticleType( ParticleID AS INTEGER )
	Range AS INTEGER
	If P3DInitialized = 1
		Range = ParticleSystem[ ParticleID ].mType
	 Else
		Range = -1
	 EndIf
 EndFunction Range

Function P3D_GetParticleSize( ParticleID AS INTEGER )
	Range AS INTEGER
	If P3DInitialized = 1
		Range = ParticleSystem[ ParticleID ].Size
	 Else
		Range = -1
	 EndIf
 EndFunction Range

Function P3D_GetParticleDuration( ParticleID AS INTEGER )
	Temp AS FLOAT = 0.0
	If P3DInitialized = 1
		Temp = ParticleSystem[ ParticleID ].Duration
	 EndIf
 EndFunction Temp
