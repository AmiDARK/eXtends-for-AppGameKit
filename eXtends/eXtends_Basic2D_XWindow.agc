
Function XWindow_InitializeSkin()
	SkinInit AS Integer = 0
	SkinInit = 1
	For XLoop = 0 To 11
		Fichier As String : Fichier =  XWinFiles[ XLoop ]
		If GetFileExists( Fichier ) = 1
			SkinImage[ XLoop ] = LoadImage( Fichier , XWinSystem.MipMapMode )
			If SkinImage[ XLoop ] > 0
				SkinImageX[ XLoop ] = GetImageWidth( SkinImage[ XLoop ] )
				SkinImageY[ XLoop ] = GetImageHeight( SkinImage[ XLoop ] )
			EndIf
		Else
			Message( "Basic2D-XWindow : Setup cannot load XSkin file '" + Fichier + "'" )
			SkinInit = 0
		EndIf
	Next XLoop
	if SkinInit = 0
		for XLoop = 0 To 11
			If SkinImage[ Xloop ] > 0 Then DeleteImage( SkinImage[ XLoop ] )
			SkinImageX[ XLoop ] = 0
			SkinImageY[ XLoop ] = 0
		Next XLoop
		Message( "Basic2D-XWindow : Cannot create skin" )
	Endif

EndFunction SkinInit

Function XWindow_Initialize( Skin As String )
	INITIALIZED AS Integer = 0
		If GetFileExists( Skin ) = 1
			FileIO = OpenToRead( Skin )
				_HEADER$ = ReadLine( FileIO )
				If _HEADER$ = "[XWINDOW_SKIN]"
					XWinSystem.Skin = ReadLine( FileIO )
					For XLoop = 0 To 11
						XWinFiles[ XLoop ] = ReadLine( FileIO )
					Next XLoop
					Sync()
					_HEADER$ = ReadLine( FileIO )
					INITIALIZED = 1
				Else
					Message( "Basic2D-XWindow : File '" + Skin + "' contain unexpected content" )
				EndIf   
			CloseFile( FileIO )
		Else
			Message( "Basic2D-XWindow : Files Not found for XWindow" )
		EndIf
		For XLoop = 1 To 11
			XWinDisplay[ XLoop ] = - 1
		Next XLoop
		XWinDisplay[ 0 ] = 0
		If INITIALIZED = 1
			INITIALIZED = XWindow_InitializeSkin()
			If INITIALIZED = 0
				INITIALIZED = -1
				Message( "Basic2D-XWindow : Unable to setup Skin" )
			EndIf
		EndIf
		XWinSystem.OldWindow = -1 : XWinSystem.CurrentWindow = -1
		XWinSystem.DragWindow = - 1 : XWinSystem.AllowDragging = 0
	XWinSystem.SkinLoaded = INITIALIZED
EndFunction INITIALIZED

Function XWindow_ClearSystem()
	For XLoop = 255 To 1 Step - 1
		If XGadget[ XLoop ].Exist = 1
			XWindow_DeleteGadget( XLoop )
		EndIf
	Next XLoop
	For XLoop = 16 To 0 Step - 1
		If XWindow[ XLoop ].Exist = 1
			XWindow_Delete( XLoop )
		EndIf
	Next XLoop
	// On supprime ensuite les images servant à faire le système
	If XWinSystem.SkinLoaded > 0
		For XLoop = 0 To 11
			If GetImageExists( SkinImage[ XLoop ] ) = 1 
				SkinImage[ XLoop ] = 0 
				DeleteImage( SkinImage[ XLoop ] )
			EndIf
		Next XLoop
	EndIf
	// Suppression des données de compteurs de fenêtres.
	For XLoop = 1 To 11
		XWinDisplay[ XLoop ] = - 1
	Next XLoop 
	XWinDisplay[ 0 ] = 0
	XWinSystem.SkinLoaded = 0
EndFunction

Function XWindow_TrueCloseMode()
	XWinSystem.CloseMode = 1
EndFunction

Function XWindow_FakeCloseMode()
	XWinSystem.CloseMode = 0
EndFunction

Function XWindow_EnableAlphaiser()
	XWinSystem.AllowAlphaiser = 1
EndFunction

Function XWindow_DisableAlphaiser()
	XWinSystem.AllowAlphaiser = 0
EndFunction

Function XWindow_SetupAlphaiserInternal()
	TESTEUR As Integer = 0
EndFunction

Function XWindow_Create( WinNum As Integer , XSize As Integer , YSize As Integer )
	If WinNum > 0 And WinNum < 16 And B2DInitialized = 1
		If XWindow[ WinNum ].Exist = 0
			XWindow[ WinNum ].Exist = 1 : // Valide la création de la fenêtre.
			XWindow[ WinNum ].Format = 0 : // Définit le type de fenêtre ( 0 = Normal , 1 = Chat )
			XWindow[ WinNum ].XSize = XSize
			XWindow[ WinNum ].YSize = YSize
			XWindow[ WinNum ].Refresh = 5 : // Force le rafraichissement de l'image complête de la fenêtre.
			XWindow[ WinNum ].Linked = 0 : // La fenêtre est liée à une autre fenêtre .
			XWindow[ WinNum ].Moveable = 1 : // définit la fenêtre comme draggeable ( déplaçable ).
			XWindow[ WinNum ].Close = 1 : // Ajoute le gadget de fermeture de fenêtre.
			XWindow[ WinNum ].Borders = 1 : // Autorise l'affichage des bordures de fenêtre.
			XWindow[ WinNum ].Bgd = 1 : // Autorise l'affichage de la trame de fond de la fenêtre.
			XWindow[ WinNum ].Alpha = 255 : // Valeur d'alpha mapping par défaut.
			XWindow[ WinNum ].GadgetCount = 0 : // Aucun gadget inclus dans la fenêtre par défaut.
			XWindow[ WinNum ].Hidden = 0 : // Par défaut, la fenêtre serat visible et pas cachée.
			XWindow[ WinNum ].Xpos = 0
			XWindow[ WinNum ].YPos = 0
			XWindow[ WinNum ].Title = 1
			XWindow[ WinNum ].Name = "XGui Window"
			XWindow[ WinNum ].XDSize = 0
			XWindow[ WinNum ].YDSize = 0
			XWindow[ WinNum ].Parent = 0
			XWindow[ WinNum ].ChildCount = 0
			XWinDisplay[ 0 ] = XWinDisplay[ 0 ] + 1
			XWinDisplay[ XWinDisplay[ 0 ] ] = WinNum
		EndIf
	EndIf
EndFunction

Function XWindow_SetChatWin( WinNum As Integer )
	If WinNum > -1 And WinNum < 16 And B2DInitialized = 1
		If XWindow[ WinNum ].Exist = 0
			// Prevent any other window from being a chat window too.
			For XLoop = 0 To 15
				XWindow[ WinNum ].Format = 0
			Next XLoop
			XWindow[ WinNum ].Format = 1
		EndIf
	EndIf
EndFunction

Function XWindow_DisableChatwin()
	For XLoop = 0 To 15
		XWindow[ XLoop ].Format = 0
	Next XLoop
EndFunction

Function XWindow_Alpha( WinNum As Integer , Alpha As Integer )
	If WinNum > -1 And WinNum < 16
		If XWindow[ WinNum ].Exist = 1
			If Alpha < 1 : Alpha = 1 : EndIf
			If Alpha > 255 : Alpha = 255 : EndIf
			XWindow[ WinNum ].Alpha = Alpha
			If XWindow[ WinNum ].Refresh = 0 : XWindow[ WinNum ].Refresh = 1 : EndIf
		EndIf
	EndIf
EndFunction

Function XWindow_ToBack( WinNum As Integer )
	If WinNum > -1 And WinNum < 16
		If XWinDisplay[ 0 ] > 0 And XWindow[ WinNum ].Exist = 1
			If XWinDisplay[ 0 ] > 1 And XWinDisplay[ 1 ] <> WinNum
				XWinpos = 0 : Repeat : XWinPos = XWinPos + 1 : Until XWinDisplay[ XWinPos ] = WinNum Or XWinPos = 16
				If XWinPos > 1
					For XLoop = XWinPos-1 To 1 Step 1
						XWinDisplay[ XLoop + 1 ] = XWinDisplay[ XLoop ]
					Next XLoop
					XWinDisplay[ 1 ] = WinNum
					XWinSystem.CheckPriorities = 1
				EndIf
			EndIf
		EndIf
	EndIf
EndFunction

Function XWindow_ToFront( WinNum As Integer )
	If WinNum > -1 And WinNum < 16
		If XWinDisplay[ 0 ] > 0 And XWindow[ WinNum ].Exist = 1
			If XWinDisplay[ 0 ] > 1 And XWinDisplay[ XWinDisplay[ 0 ] ] <> WinNum
				XWinpos = 0 : Repeat : XWinPos = XWinPos + 1 : Until XWinDisplay[ XWinPos ] = WinNum Or XWinPos = 16
				If XWinPos < XWinDisplay[ 0 ]
					For XLoop = XwinPos To XWinDisplay[ 0 ]-1 Step 1
						XWinDisplay[ XLoop ] = XWinDisplay[ XLoop + 1 ]
					Next XLoop
					XWinDisplay[ XWinDisplay[ 0 ] ] = WinNum
					XWinSystem.CheckPriorities = 1
				EndIf
			EndIf
		EndIf
	EndIf
EndFunction

Function XWindow_Position( WinNum As Integer , Xpos As Integer , Ypos As Integer )
	If WinNum > -1 And WinNum < 16
		If XWindow[ WinNum ].Exist = 1
			XWindow[ WinNum ].Xpos = Xpos : XWindow[ WinNum ].Ypos = Ypos
			If XWindow[ WinNum ].Refresh = 0 : XWindow[ WinNum ].Refresh = 1 : EndIf
		EndIf
	EndIf
EndFunction

Function XWindow_Properties( WinNum As Integer , Borders As Integer , Title As Integer , Draggeable As Integer , Close As Integer )
	If WinNum > -1 And WinNum < 16
		If XWindow[ WinNum ].Exist = 1
			// Avant de modifier les propriétés d'affichage de la fenêtre et de la retracer entièrement,
			// On vérifie si il y a des gadgets dans la dite fenêtre.
			If XWindow[ WinNum ].GadgetCount > 0
				// On recale les gadgets par rapport à en haut à gauche sans bordures ...
				If XWindow[ WinNum ].Borders = 1
					XAdd = -8 : YAdd = -8
					If XWindow[ WinNum ].Title = 1 : YAdd = -16 : EndIf
					For XLoop = 1 To XWinSystem.GadgetCount
						If XGadget[ XLoop ].Window = WinNum
							XGadget[ XLoop ].Xpos = XGadget[ XLoop ].Xpos + XAdd
							XGadget[ XLoop ].Ypos = XGadget[ XLoop ].Ypos + YAdd
						EndIf
					Next XLoop
				EndIf
				If XWindow[ WinNum ].Refresh < 3 : XWindow[ WinNum ].Refresh = 3 : EndIf
			EndIf
			XWindow[ WinNum ].Borders = Borders
			XWindow[ WinNum ].Title = Title
			XWindow[ WinNum ].Moveable = Draggeable
			XWindow[ WinNum ].Close = Close
			XWindow[ WinNum ].Refresh = 5
			// Une fois les propriétés modifiées, on repositionne les gadgets de la fenêtre ou il faut...
			If XWindow[ WinNum ].GadgetCount > 0 And XWindow[ WinNum ].Borders = 1
				For XLoop = 1 To XWinSystem.GadgetCount
					If XGadget[ XLoop ].Window = WinNum : XWindow_GadgetAdaptInternal( XLoop ) : EndIf 
				Next XLoop
			EndIf
		EndIf
	EndIf
EndFunction

Function XWindow_SetBorderOff( WinNum As Integer )
	If WinNum > 1 And WinNum < 16
		XWindow_Properties( WinNum , 0 , 0 , 0 , 0 )
	EndIf
EndFunction

Function XWindow_SetBorderOn( WinNum As Integer )
	If WinNum > -1 And WinNum < 16
		Title As Integer : Title = XWindow[ WinNum ].Title
		Draggeable As Integer : Draggeable = XWindow[ WinNum ].Moveable
		Close As Integer : Close = XWindow[ WinNum ].Close
		XWindow_Properties( WinNum , 1 , Title , Draggeable , Close )
	EndIf
EndFunction

Function XWindow_SetTitleOff( WinNum As Integer )
	If WinNum > -1 And WinNum < 16
		Borders As Integer : Borders = XWindow[ WinNum ].Borders
		Draggeable As Integer : Draggeable = XWindow[ WinNum ].Moveable
		Close As Integer : Close = XWindow[ WinNum ].Close
		XWindow_Properties( WinNum , Borders , 0 , Draggeable , Close )
	EndIf
EndFunction

Function XWindow_SetTitleOn( WinNum As Integer )
	If WinNum > -1 And WinNum < 16
		Borders As Integer : Borders = XWindow[ WinNum ].Borders
		Draggeable As Integer : Draggeable = XWindow[ WinNum ].Moveable
		Close As Integer : Close = XWindow[ WinNum ].Close
		XWindow_Properties( WinNum , Borders , 1 , Draggeable , Close )
	EndIf
EndFunction

Function XWindow_SetDraggingOff( WinNum As Integer )
	If WinNum > -1 And WinNum < 16
		Borders As Integer : Borders = XWindow[ WinNum ].Borders
		Title As Integer : Title = XWindow[ WinNum ].Title
		Close As Integer : Close = XWindow[ WinNum ].Close
		XWindow_Properties( WinNum , Borders , Title , 0 , Close )
	EndIf
EndFunction

Function XWindow_SetDraggingOn( WinNum As Integer )
	If WinNum > -1 And WinNum < 16
		Borders As Integer : Borders = XWindow[ WinNum ].Borders
		Title As Integer : Title = XWindow[ WinNum ].Title
		Close As Integer : Close = XWindow[ WinNum ].Close
		XWindow_Properties( WinNum , Borders , Title , 1 , Close )
	EndIf
EndFunction

Function XWindow_SetCloseOff( WinNum As Integer )
	If WinNum > -1 And WinNum < 16
		Borders As Integer : Borders = XWindow[ WinNum ].Borders
		Title As Integer : Title = XWindow[ WinNum ].Title
		Draggeable As Integer : Draggeable = XWindow[ WinNum ].Moveable
		XWindow_Properties( WinNum , Borders , Title , Draggeable , 0 )
	EndIf
EndFunction

Function XWindow_SetCloseOn( WinNum As Integer )
	If WinNum > -1 And WinNum < 16
		Borders As Integer : Borders = XWindow[ WinNum ].Borders
		Title As Integer : Title = XWindow[ WinNum ].Title
		Draggeable As Integer : Draggeable = XWindow[ WinNum ].Moveable
		XWindow_Properties( WinNum , Borders , Title , Draggeable , 1 )
	EndIf
EndFunction

Function XWindow_Title( WinNum As Integer , NewTitle As String )
	If WinNum > -1 And WinNum < 16
		If XWindow[ WinNum ].Exist = 1
			XWindow[ WinNum ].Name = NewTitle
			XWindow[ WinNum ].Borders = 1
			XWindow[ WinNum ].Title = 1
			If XWindow[ WinNum ].Refresh < 4 : XWindow[ WinNum ].Refresh = 4 : EndIf
		EndIf
	EndIf
EndFunction

Function XWindow_Delete( WinNum As Integer )
	If WinNum > -1 And WinNum < 16
		If XWindow[ WinNum ].Exist = 1
			// Avant de supprimer la fenêtre, on vérifie si il y a pas des gadgets dedans ....
			If XWindow[ WinNum ].GadgetCount > 0
				For XLoop = XWinSystem.GadgetCount To 1 Step -1
					If XGadget[ XLoop ].Window = WinNum : XWindow_DeleteGadget( XLoop ) : EndIf 
				Next XLoop
			EndIf
			// On met la fenêtre au premier plan pour la supprimer de la liste plus facilement...
			XWindow_ToFront( WinNum ) : XWinDisplay[ 0 ] = XWinDisplay[ 0 ] - 1
			// On supprime la fenêtre réellement.
			If XWindowSprite[ WinNum ] > 0
				XWindowSprite[ WinNum ] = 0 : DeleteSprite( XWindowSprite[ WinNum ] )
			EndIf
			If XWindowImage[ WinNum ] > 0
				If GetImageExists( XWindowImage[ WinNum ] ) = 1 : XWindowImage[ WinNum ] = 0 : DeleteImage( XWindowImage[ WinNum ] ) : EndIf
			EndIf
			If XWindowBitmap[ WinNum ] > 0
				If GetImageExists( XWindowBitmap[ WinNum ] ) = 1 : XWindowBitmap[ WinNum ] = 0 : DeleteImage( XWindowBitmap[ WinNum ] ) : EndIf
			EndIf
			XWindow[ WinNum ].Exist = 0 : XWindow[ WinNum ].Format = 0
			XWindow[ WinNum ].XSize = 0 : XWindow[ WinNum ].YSize = 0
			XWindow[ WinNum ].Refresh = 0 : XWindow[ WinNum ].Linked = 0
			XWindow[ WinNum ].Moveable = 0 : XWindow[ WinNum ].Close = 0
			XWindow[ WinNum ].Borders = 0 : XWindow[ WinNum ].Bgd = 0
			XWindow[ WinNum ].Alpha = 0 : XWindow[ WinNum ].GadgetCount = 0
			XWindow[ WinNum ].Parent = 0 : XWindow[ WinNum ].ChildCount = 0
			XWindow[ WinNum ].Hidden = 0
			XWindow[ WinNum ].Xpos = 0 : XWindow[ WinNum ].YPos = 0
			XWindow[ WinNum ].Title = 1 : XWindow[ WinNum ].Name = "XGui Window"
			XWindow[ WinNum ].XDSize = 0 : XWindow[ WinNum ].YDSize = 0
		EndIf
	EndIf
EndFunction

Function XWindow_Show( WinNum As Integer )
	If WinNum > -1 And WinNum < 16
		If XWindow[ WinNum ].Exist = 1
			If XWindowSprite[ WinNum ] > 0
				SetSpriteVisible( XWindowSprite[ WinNum ], 1 ) : XWindow[ WinNum ].Hide = 0
			Else
				XWindow[ WinNum ].Hide = 3
			EndIf
		EndIf
	EndIf
EndFunction

Function XWindow_Hide( WinNum As Integer )
	If WinNum > -1 And WinNum < 16
		If XWindow[ WinNum ].Exist = 1
			If XWindowSprite[ WinNum ] > 0
				SetSpriteVisible( XWindowSprite[ WinNum ], 0 )
				XWindow[ WinNum ].Hide = 1
			Else
				XWindow[ WinNum ].Hide = 2
			EndIf
		EndIf
	EndIf
EndFunction

Function GetWindowVisible( WinNum As Integer )
	RETOUR As Integer = 0
	If WinNum > -1 And WinNum < 16
		If XWindow[ WinNum ].Hide = 0
			RETOUR = 1
		Else 
			RETOUR = 0
		EndIf
	Else
		RETOUR = 0
	EndIf
EndFunction RETOUR

Function XWindow_XLimit( WinNum As Integer )
	XResult As Integer : XResult = XWindow[ WinNum ].XSize
	XLimit As Integer = 0
	For XLoop = 0 To 16
		If XWindow[ XLoop ].Parent = WinNum And XLoop <> WinNum
			If XWindow[ XLoop ].Alignment = 8
				If XWindow[ XLoop ].Hide = 0
					XLimit = XWindow[ WinNum ].XSize + XWindow[ XLoop ].XSize
					If XLimit > XResult : XResult = XLimit : EndIf
				EndIf
			EndIf
		EndIf
	Next XLoop
EndFunction XResult

Function XWindow_XMin( WinNum As Integer )
	XResult As Integer = 0
	XLimit As Integer = 0
	For XLoop = 0 To 16
		If XWindow[ XLoop ].Parent = WinNum And XLoop <> WinNum
			If XWindow[ XLoop ].Alignment = 4
				If XWindow[ XLoop ].Hide = 0
					XLimit = XWindow[ XLoop ].XSize
					If XLimit > XResult : XResult = XLimit : EndIf
				EndIf
			EndIf
		EndIf
	Next XLoop
EndFunction xResult

Function XWindow_YLimit( WinNum As Integer )
	YResult As Integer : YResult = XWindow[ WinNum ].YSize
	YLimit As Integer = 0
	For XLoop = 0 To 16
		If XWindow[ XLoop ].Parent = WinNum And XLoop <> WinNum
			If XWindow[ XLoop ].Alignment = 2
				If XWindow[ XLoop ].Hide = 0
					YLimit = XWindow[ WinNum ].YSize + XWindow[ XLoop ].YSize
					If YLimit > YResult : YResult = YLimit : EndIf
				EndIf
			EndIf
		EndIf
	Next XLoop
EndFunction YResult

Function XWindow_YMin( WinNum As Integer )
	YResult As Integer = 0
	YLimit As Integer = 0
	For XLoop = 0 To 16
		If XWindow[ XLoop ].Parent = WinNum And XLoop <> WinNum
			If XWindow[ XLoop ].Alignment = 1
				If XWindow[ XLoop ].Hide = 0
					YLimit = XWindow[ XLoop ].YSize
					If YLimit > YResult : YResult = YLimit : EndIf
				EndIf
			EndIf
		EndIf
	Next XLoop
EndFunction YResult

Function XWindow_RepositionAttached( WinNum As Integer )
	For XLoop = 0 To 16
		If XWindow[ XLoop ].Parent = WinNum And XLoop <> WinNum
			Select XWindow[ XLoop ].Alignment
				Case 1
					XWindow[ XLoop ].Xpos = XWindow[ WinNum ].Xpos
					XWindow[ XLoop ].YPos = XWindow[ WinNum ].Ypos - XWindow[ XLoop ].YSize
				EndCase
				Case 2
					XWindow[ XLoop ].Xpos = XWindow[ WinNum ].Xpos
					XWindow[ XLoop ].YPos = XWindow[ WinNum ].Ypos + XWindow[ WinNum ].YSize
				EndCase
				Case 4
					XWindow[ XLoop ].Xpos = XWindow[ WinNum ].Xpos - XWindow[ XLoop ].XSize
					XWindow[ XLoop ].YPos = XWindow[ WinNum ].Ypos
				EndCase
				Case 8
					XWindow[ XLoop ].Xpos = XWindow[ WinNum ].Xpos + XWindow[ WinNum ].XSize
					XWindow[ XLoop ].YPos = XWindow[ WinNum ].Ypos
				EndCase
			EndSelect
			If XWindow[ XLoop ].Refresh = 0 : XWindow[ XLoop ].Refresh = 1 : EndIf
		EndIf
	Next XLoop
EndFunction

Function XWindow_Refresh()
	If B2DInitialized = 1
		For XLoop = 0 To 16
			If XWindow[ XLoop ].Exist = 1 And XWindow[ XLoop ].Refresh > 0
				XWindow_RefreshInternal( XLoop )
			EndIf
		Next XLoop
		For XLoop = 1 To XWinDisplay[ 0 ]
			WinNum = XWinDisplay[ XLoop ]
			If XWindowSprite[ WinNum ] > 0 
				Select XWindow[ WinNum  ].Hide
					Case 2:
						SetSpriteVisible( XWindowSprite[ WinNum ], 0 )
						XWindow[ WinNum ].Hide = 1
					EndCase
					Case 3:
						SetSpriteVisible( XWindowSprite[ WinNum ], 1 ) : SetSpriteDepth( XWindowSprite[ WinNum ] , XLoop )
						XWindow[ WinNum ].Hide = 0
					EndCase
				EndSelect
			EndIf
			If XWinSystem.CheckPriorities = 1 And XWinDisplay[ 0 ] > 1
				SetSpriteDepth( XWindowSprite[ WinNum ] , 16 - XLoop )             
			EndIf
		Next XLoop
		XWinSystem.CheckPriorities = 0
		XWindow_GetWindowInternal()
		// DBSetCurrentBitmap( 0 )
		// Si l'on est pas en mode saisie de texte, on vérifie si la touche de saisie de texte a été préssée 
		If XWinSystem.ChatGadget > 0
			If XWinSystem.ChatReading = 0
				If XWinSystem.ChatScanCode <> 0
					// Si la touche a été préssée alors on enclenche le mode SAISIE DE TEXTE POUR LE CHAT :)
					If GetRawKeyState( XWinSystem.ChatScanCode ) = 1
						XWinSystem.ChatReading = 1
						XWinSystem.ChatInText = "\"
						XWinSystem.LastKey = XWinSystem.ChatScanCode
					EndIf
				EndIf
			Else
				// Si l'on est dans le mode chat.
				NewKey As Integer : NewKey = GetRawLastKey() : MajMode As Integer = 0 : // MajMode = DBShiftKey()
				If NewKey > 0 And NewKey <> XWinSystem.LastKey
					// On gère tout d'abord les touches systèmes.
					Select NewKey
						// Supprimer le dernier caractère.
						// Touches Escape pour annuler le texte.et désactiver le mode de saisie de texte.
						Case 1
							XWinSystem.ChatInText = " " : XWindow_SetGadgetTextInternal( XWinSystem.ChatGadget , XWinSystem.ChatInText )
							NewKey = 0 : XWinSystem.ChatReading = 0
						EndCase
						Case 14
							If Len( XWinSystem.ChatInText ) > 1
								XWinSystem.ChatInText = Left( XWinSystem.ChatInText , Len( XWinSystem.ChatInText ) - 1 )
								XWindow_SetGadgetTextInternal( XWinSystem.ChatGadget , XWinSystem.ChatInText )
							Else
								XWinSystem.ChatInText = "\"
								XWindow_SetGadgetTextInternal( XWinSystem.ChatGadget , XWinSystem.ChatInText )
							EndIf
							NewKey = 0
						EndCase
						// Touches Entrée 1 pour valider le texte.et désactiver le mode de saisie de texte.
						Case 28
							If Len( XWinSystem.ChatInText ) > 0
								XWinSystem.ChatInText = Right( XWinSystem.ChatInText , Len( XWinSystem.ChatInText ) - 1 )
								XWindow_TalkToChatInternal( XWinSystem.ChatInText )
							EndIf
							XWinSystem.ChatInText = "" : XWindow_SetGadgetTextInternal( XWinSystem.ChatGadget , XWinSystem.ChatInText )
							NewKey = 0 : XWinSystem.ChatReading = 0
						EndCase
						// Touches Entrée 2 pour valider le texte.et désactiver le mode de saisie de texte.
						Case 156
							If Len( XWinSystem.ChatInText ) > 0
								XWinSystem.ChatInText = Right( XWinSystem.ChatInText , Len( XWinSystem.ChatInText ) - 1 )
								XWindow_TalkToChatInternal( XWinSystem.ChatInText )
							EndIf
							XWinSystem.ChatInText = "" : XWindow_SetGadgetTextInternal( XWinSystem.ChatGadget , XWinSystem.ChatInText )
							NewKey = 0 : XWinSystem.ChatReading = 0
						EndCase
					EndSelect
					// On gère ensuite les textes
					If NewKey > 0
//						XWinSystem.ChatInText = XWinSystem.ChatInText + ChatChar( NewKey )
						If MajMode = 1
							XWinSystem.ChatInText = XWinSystem.ChatInText + Upper( ChatChar[ NewKey ] )
						Else
							XWinSystem.ChatInText = XWinSystem.ChatInText + Lower( ChatChar[ NewKey ] )
						EndIf
						XWindow_SetGadgetTextInternal( XWinSystem.ChatGadget , XWinSystem.ChatInText )
					EndIf
				EndIf
				XWinSystem.LastKey = NewKey
			EndIf
		EndIf
	EndIf
EndFunction

Function XWindow_RefreshInternal( WinNum As Integer )
	If XWindow[ WinNum ].Exist = 1
		// Si on a changé les propriétés d'affichage de la fenêtre, on doit la recréer...
		If XWindow[ WinNum ].Refresh = 5
			If XWindowBitmap[ WinNum ] > 0
				XWindowBitmap[ WinNum ] = 0
				//  BMP_Delete( XWindowBitmap[ WinNum ] )
			EndIf
			XWindow[ WinNum ].Refresh = 4
		EndIf
		// Si le bitmap de la fenêtre n'est pas crée on le crée.
		/* If XWindowBitmap[ WinNum ] = 0
			XWindowBitmap[ WinNum ] = CreateBitmap( XWindow[ WinNum ].XSize , XWindow[ WinNum ].YSize ) 
		Else
			If GetBitmapExists( XWindowBitmap[ WinNum ] ) = 0
				XWindowBitmap[ WinNum ] = CreateBitmap( XWindow[ WinNum ].XSize , XWindow[ WinNum ].YSize ) 
			EndIf
		EndIf*/
		// On vérifie que le système ait bien été initialisé.
		// SetCurrentBitmap( XWindowBitmap[ WinNum ] ) // Replace DBSetCurrentBitmap
		If XWinSystem.SkinLoaded > 0
			// On vérifie, si le rafraichissement est à 5 alors on retrace les contours de la fenêtre.
			If XWindow[ WinNum ].Refresh = 4
				XWindow[ WinNum ].Refresh = 3
				// Si le tramage de fond est activé, on le rafraichit.
				If XWindow[ WinNum ].bgd = 1
					TempSpr = CreateSprite( SkinImage[ 4 ] )
					XLoop As Integer = 0
					Repeat
						YLoop As Integer = 0
						Repeat
							SetSpritePosition( TempSpr, XLoop, YLoop )
							DrawSprite( TempSpr ) 
							YLoop = YLoop + SkinImageY[ 4 ]
						Until YLoop > XWindow[ WinNum ].YSize
						XLoop = XLoop + SkinImageX[ 4 ]
					Until XLoop > XWindow[ WinNum ].XSize
					DeleteSprite( TempSpr )
				EndIf
				// Si les bordures sont activées, on les rafraichit.
				If XWindow[ WinNum ].Borders = 1
					// Tracé des bordures HAUT/BAS
					XLoop = 0
					Repeat
						PasteImage( SkinImage[ 1 ] , XLoop , 0 )
						PasteImage( SkinImage[ 7 ] , XLoop , XWindow[ WinNum ].YSize - SkinImageY[ 7 ] )
						XLoop = XLoop + SkinImageX[ 1 ]
					Until XLoop > XWindow[ WinNum ].XSize
					// Tracé des bordures GAUCHE/DROITE
					YLoop = 0
					Repeat
						PasteImage( SkinImage[ 3 ] , 0 , YLoop )
						PasteImage( SkinImage[ 5 ] , XWindow[ WinNum ].XSize - SkinImageX[ 5 ] , YLoop )
						YLoop = YLoop + SkinImageY[ 3 ]
					Until YLoop > XWindow[ WinNum ].YSize
					// On gère les 2 cas pour le texte , le cas FONTE par défaut et le cas XFONT
					// Tracé du titre de la fenêtre à gérer.
					If XWindow[ WinNum ].Title = 1
						// Utilisation du texte simple pour le titre 
						For XLoop = 0 To XWindow[ WinNum ].XSize + 64 Step 64
							PasteImage( SkinImage[ 9 ] , XLoop , 0 )
						Next XLoop
						XPos As Integer : XPos = ( XWindow[ WinNum ].XSize - dbTextWidth( XWindow[ WinNum ].Name ) ) / 2
						dbSetcursor( Xpos + 1 , 1 ) : DBInk( 0 , 0 )
						dbPrint( XWindow[ WinNum ].Name )
						dbSetCursor( Xpos , 0 ) : dbInk( DBRgb( 255 , 255 , 255 ) , 0 )
						dbPrint( XWindow[ WinNum ].Name )
					EndIf
					// Tracé des 4 Coins.
					If XWindow[ WinNum ].Title = 0
						PasteImage( SkinImage[ 0 ], 0, 0 )
					Else
						PasteImage( SkinImage[ 10 ], 0, 0 )
					EndIf
					If XWindow[ WinNum ].Close = 0
						If XWindow[ WinNum ].Title = 0
							PasteImage( SkinImage[ 2 ] , XWindow[ WinNum ].XSize - SkinImageX[ 2 ] , 0 )
						EndIf
					Else
						PasteImage( SkinImage[ 11 ] , XWindow[ WinNum ].XSize - SkinImageX[ 11 ] , 0 )
					EndIf
					PasteImage( SkinImage[ 6 ] , 0 , XWindow[ WinNum ].YSize - SkinImageY[ 6 ] )
					PasteImage( SkinImage[ 8 ] , XWindow[ WinNum ].XSize - SkinImageX[ 8 ] , XWindow[ WinNum ].YSize - SkinImageY[ 8 ] )
				EndIf
			EndIf
			// On Rafraichit les gadgets inclus dans la fenêtre.
			If XWindow[ WinNum ].Refresh = 3
				XWindow[ WinNum ].Refresh = 2
				If XWindow[ WinNum ].GadgetCount > 0 And XWinSystem.GadgetCount > 0
					For XLoop = 1 To XWinSystem.GadgetCount
						If XGadget[ XLoop ].Window = WinNum 
							XWindow_GadgetRefreshFast( XLoop )
						EndIf
					Next XLoop
				EndIf
				// On Rafraichit le Chat si la fenêtre le contient
				If XWindowImage[ WinNum ] = 0
					XWindowImage[ WinNum ] = GetImage( 0 , 0 , XWindow[ WinNum ].XSize , XWindow[ WinNum ].YSize ) // , XWinSystem.MipMapMode ) is not supported in AGK
				Else
					GetImage( XWindowImage[ WinNum ], 0, 0, XWindow[ WinNum ].XSize, XWindow[ WinNum ].YSize ) // , XWinSystem.MipMapMode )
				EndIf
				// Upper line changer !!! for GetBitmapX/Y asking for bitmap number
			EndIf
		Else
			Message( "Basic2D XWindow : Impossible de créer la fenêtre, skin non initialisé" )
		EndIf
		XMin = XWindow_XMin( WinNum ) : YMin = XWindow_YMin( WinNum )
		XMax = xtGetBitmapWidth(0) - XWindow_XLimit( WinNum )
		YMax = xtGetBitmapHeight(0) - XWindow_YLimit( WinNum )
		If XWindow[ WinNum ].Xpos < XMin : XWindow[ WinNum ].Xpos = XMin : EndIf
		If XWindow[ WinNum ].Xpos > XMax : XWindow[ WinNum ].Xpos = XMax : EndIf
		If XWindow[ WinNum ].Ypos < YMin : XWindow[ WinNum ].Ypos = YMin : EndIf
		If XWindow[ WinNum ].Ypos > YMax : XWindow[ WinNum ].Ypos = YMax : EndIf
		XWindow_RepositionAttached( WinNum )
		If XWindowSprite[ WinNum ] = 0
			XWindowSprite[ WinNum ] = CreateSprite( XWindowImage[ WinNum ] ) 
			SetSpritePosition( XWindowSprite[ WinNum ], XWindow[ WinNum ].Xpos , XWindow[ WinNum ].Ypos )
		Else
			SetSpritePosition( XWindowSprite[ WinNum ], XWindow[ WinNum ].Xpos , XWindow[ WinNum ].Ypos )
			SetSpriteImage( XWindowSprite[ WinNum ] , XWindowImage[ WinNum ] )
		EndIf
		If XWindow[ WinNum ].Refresh = 2
			XWindow[ WinNum ].Refresh = 1
			If XWindow[ WinNum ].XDSize > 0 And XWindow[ WinNum ].YDSize > 0
				XPercent As Integer : XPercent = ( 100 * XWindow[ WinNum ].XDSize ) / XWindow[ WinNum ].XSize
				YPercent As Integer : YPercent = ( 100 * XWindow[ WinNum ].YDSize ) / XWindow[ WinNum ].YSize
				SetSpriteScale( XWindowSprite[ WinNum ] , XPercent , YPercent )
			EndIf
		EndIf
		If XWindow[ WinNum ].Refresh = 1
			SetSpriteColorAlpha( XWindowSprite[ WinNum ] , XWindow[ WinNum ].Alpha )    
//			if XWindow[ WinNum ].Hide = 1 : DBHideSprite( XWindowSprite[ WinNum ] ) : EndIf      
			XWindow[ WinNum ].Refresh = 0
		EndIf
	EndIf
EndFunction

Function XWindow_GetWindowInternal()
	XM As Integer : YM As Integer : MC As Integer
	XM = GetRawMouseX() : YM = GetRawMouseY() : MC = GetRawMouseLeftState()
	If MC = 0 : XWinSystem.DragWindow = - 1 : EndIf
	XWinSystem.CurrentGadget = 0
	XWinSystem.OldWindow = XWinSystem.CurrentWindow
	If XWinSystem.DragWindow = - 1
		XWinSystem.CurrentWindow = - 1
		If XWinDisplay[ 0 ] > 0
			For XLoop = XWinDisplay[ 0 ] To 1 Step -1
				WinNum = XWinDisplay[ XLoop ]
				// Si le curseur de la souris se trouve dans la fenêtre .
				If XWindow[ WinNum ].Hide = 0
					If XM >= XWindow[ WinNum ].XPos And YM >= XWindow[ WinNum ].YPos
						If XM <= XWindow[ WinNum ].Xpos + XWindow[ WinNum ].XSize
							If YM <= XWindow[ WinNum ].YPos + XWindow[ WinNum ].YSize
								If XWinSystem.CurrentWindow = -1 : XWinSystem.CurrentWindow = WinNum : EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			Next XLoop
		EndIf
		// On vérifie la position de la souris dans la fenêtre  Si on peut déplacer la fenêtre ?
		XPosIn As Integer
		If XWinSystem.CurrentWindow > -1
			YPosIn = YM - XWindow[ XWinSystem.CurrentWindow ].YPos
			If YPosIn < 16 And XWindow[ XWinSystem.CurrentWindow ].Moveable = 1
				XWinSystem.AllowDragging = 1
			Else
				XWinSystem.AllowDragging = 0
			EndIf
			// Si le curseur de la souris est dans la zone de déplacement alors, on calcule si on la déplace, ferme , etc...
			XPosIn = XM - XWindow[ XWinSystem.CurrentWindow ].XPos
			// Vérifie que la fenêtre ne soit pas une fenêtre attachée à une autre.
			If MC = 1 And XWinSystem.OldMouseClick = 0
				// Lorsque l'on est dans une fenetre, si l'on clique dessus, elle passe auto au premier plan.
				If XWinDisplay[ XWinDisplay[ 0 ] ] <> XWinSystem.CurrentWindow
					XWindow_ToFront( XWinSystem.CurrentWindow )
				EndIf
				// Mise en place du déplacement de fenêtre.
				If XPosIn < XWindow[ XWinSystem.CurrentWindow ].XSize - SkinImageX[ 11 ] And YPosIn <= SkinImageY[ 11 ]
					If XWinSystem.DragWindow = -1 And XWinSystem.AllowDragging = 1 And XWindow[ XWinSystem.CurrentWindow ].Parent = 0
						XWinSystem.DragWindow = XWinSystem.CurrentWindow
						XWinSystem.XDragOrigin = XWindow[ XWinSystem.DragWindow ].Xpos
						XWinSystem.YDragOrigin = XWindow[ XWinSystem.DragWindow ].Ypos        
						XWinSystem.XDragMouse = XM : XWinSystem.YDragMouse = YM
					EndIf
				EndIf
				// ON VERIFIE SI L'ON SE TROUVE SUR UN GADGET DANS LA FENETRE.
				If XWindow[ XWinSystem.CurrentWindow ].GadgetCount > 0
					For XLoop = XWinSystem.GadgetCount To 1 Step - 1
						If XGadget[ XLoop ].Window = XWinSystem.CurrentWindow
//							XGad.l = XWindow[ XWinSystem.CurrentWindow ].Xpos + XGadget( Xloop ].Xpos
//							YGad.l = XWindow[ XWinSystem.CurrentWindow ].Ypos + XGadget( Xloop ].Ypos
							XGad As Integer : XGad = XGadget[ Xloop ].Xpos
							YGad As Integer : YGad = XGadget[ Xloop ].Ypos
							If XPosIn >= XGad And YPosIn >= YGad
								If XPosIn <= XGad + XGadget[ XLoop ].XSize And YPosIn <= YGad + XGadget[ XLoop ].YSize
									If XWinSystem.CurrentGadget = 0 : XWinSystem.CurrentGadget = XLoop : EndIf
								EndIf
							EndIf
						EndIf
					Next XLoop
				EndIf
				// Suppression de la fenêtre ???
				If XposIn >= XWindow[ XWinSystem.CurrentWindow ].XSize - SkinImageX[ 11 ] And YPosIn <= SkinImageY[ 11 ]
					If XWindow[ XWinSystem.CurrentWindow ].Close = 1
						If XWinSystem.CloseMode = 1
							XWindow_Delete( XWinSystem.CurrentWindow )
						Else
							XWindow_Hide( XWinSystem.CurrentWindow )
						EndIf
					EndIf
					XWinSystem.CurrentWindow = -1 : XWinSystem.OldWindow = - 1
				EndIf   
			EndIf
		Else
			XWinSystem.AllowDragging = 0
			XWinSystem.DragWindow = -1
		EndIf
	Else
		// Déplacement de la fenêtre ???
		XADD As Integer : XADD = XM - XWinSystem.XDragMouse
		YADD As Integer : YADD = YM - XWinSystem.YDragMouse
		XWindow[ XWinSystem.DragWindow ].Xpos = XWinSystem.XDragOrigin + XADD
		XWindow[ XWinSystem.DragWindow ].Ypos = XWinSystem.YDragOrigin + YADD
		If XWindow[ XWinSystem.DragWindow ].Refresh = 0 : XWindow[ XWinSystem.DragWindow ].Refresh = 1 : EndIf
	EndIf
	XWinSystem.OldMouseClick = MC
EndFunction

Function XWindow_GetCurrentWindow()
	WinNum As Integer : WinNum = XWinSystem.CurrentWindow
EndFunction WinNum

Function XWindow_GetWinXPos( WinNum As Integer )
	Value As Integer = -1
	If WinNum > -1 And WinNum < 16
		Value = XWindow[ WinNum ].Xpos
	EndIf
EndFunction Value

Function XWindow_GetWinYPos( WinNum As Integer )
	Value As Integer = -1
	If WinNum > -1 And WinNum < 16
		Value = XWindow[ WinNum ].Ypos
	EndIf
EndFunction Value

Function XWindow_Exist( WinNum As Integer )
	Value As Integer = -1
	If WinNum > -1 And WinNum < 16
		Value = XWindow[ WinNum ].Exist
	EndIf
EndFunction Value

Function XWindow_Stretch( WinNum As Integer , XSize As Integer , YSize As Integer )
	If WinNum > 0 And WinNum < 16
		If XSize > 0 And YSize > 0
			XWindow[ WinNum ].XDSize = XSize
			XWindow[ WinNum ].YDSize = YSize
		EndIf
	EndIf
EndFunction

Function XWindow_DefaultSize( WinNum As Integer )
	If WinNum > 0 And WinNum < 16
		XWindow[ WinNum ].XDSize = 0
		XWindow[ WinNum ].YDSize = 0
		XWindow[ WinNum ].Refresh = 5
	EndIf
EndFunction

Function XWindow_UseXFont( WinNum As Integer , FontNumber As Integer )
	If WinNum > 0 And WinNum < 16
		If XWindow[ WinNum ].Exist = 1
			If FontNumber > 0 And FontNumber < 17
				If XFont_Exist( FontNumber ) = 1
					XWindow[ WinNum ].XFont = FontNumber
					If XWindow[ WinNum ].Refresh < 3
						XWindow[ WinNum ].Refresh = 3
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
EndFunction

Function XWindow_DefaultFont( WinNum As Integer )
	If WinNum > 0 And WinNum < 16
		If XWindow[ WinNum ].Exist = 1
			XWindow[ WinNum ].XFont = 0
			If XWindow[ WinNum ].Refresh < 3
				XWindow[ WinNum ].Refresh = 3
			EndIf
		EndIf
	EndIf
EndFunction  

Function XWindow_GetFreeWindow()
	WinNum As Integer = 0
	Retour As Integer = 0
	Repeat
		WinNum = WinNum + 1
	Until XWindow[ WinNum ].Exist = 0 Or WinNum = 16
	If XWindow[ WinNum ].Exist = 0 : RETOUR = WinNum : EndIf
EndFunction RETOUR

Function XGui_UseMipMap( Mode As Integer )
	XWinSystem.MipMapMode = Mode
EndFunction

/*
Function XWindow_UseXFont( WinNum As Integer , FontNumber As Integer )
	If WinNum > 0 And WinNum < 16
		If XWindow[ WinNum ].Exist = 1
			If FontNumber > 0 And FontNumber < 17
				If XFont_Exist( FontNumber ) = 1
					XWindow[ WinNum ].XFont = FontNumber
					If XWindow[ WinNum ].Refresh < 3 : XWindow[ WinNum ].Refresh = 3 : EndIf
				EndIf
			EndIf
		EndIf
	EndIf
EndFunction  
//
Function XWindow_DefaultFont( WinNum As Integer )
	If WinNum > 0 And WinNum < 16
		If XWindow[ WinNum ].Exist = 1
			XWindow[ WinNum ].XFont = 0
			If XWindow[ WinNum ].Refresh < 3 : XWindow[ WinNum ].Refresh = 3 : EndIf
		EndIf
	EndIf
EndFunction  
*/
