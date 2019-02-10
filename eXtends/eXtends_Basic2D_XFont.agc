// *****************************************************************************************************************************
/**  Méthode                            : XFont_Setupfont 
//
// Description                          : Créée une fonte graphique à partir d'un fichier image (.png, .jpg, .bmp, etc.)
//
// @Param ImageName As String           : Fichier Iamge (png, jpg, etc.) à utiliser pour créer la fonte Bitmap
// @FontNumber As Integer               : Le numéro d'index de la fonte de caractères
// @FontSize As Integer                 : La dimension en pixels de la fonte de caractères
// @FirstChar As Integer                : le code ASCII du 1er caractère présent dans la fonte graphique
// @Flag As Integer                     : =1 Case Sensitive, =0 Tout en majuscules
*/
Function XFont_SetupFont( ImageName As String , FontNumber As Integer , FontSize As Integer , FirstChar As Integer , Flag As Integer )
	Btmp As Integer = 0
	FinalFile1 As String : FinalFile1 = "\XWindow\" + ImageName
	FinalFile2 As String : FinalFile2 = ImageName
	If B2DInitialized = 1
		If FontNumber > 0 And FontNumber < 17
			If XFont_Exist( FontNumber ) = 0
				If FontSize = 8 Or FontSize = 16 Or FontSize = 32 Or FontSize = 64
					If GetFileExists( FinalFile1 ) = 1
						Btmp = LoadImage( Finalfile2 )
					Else
						If GetFileExists( FinalFile2 ) = 1
							Btmp = LoadImage( Finalfile2 )
						EndIf
					EndIf
					If Btmp > 0
						PasteImage( Btmp, 0, 0 )
						FirstImage As Integer = 0
						Select FontSize
							Case 8
								For YLoop = 0 To GetImageHeight( Btmp ) - FontSize Step 8
									For Xloop = 0 To getImagewidth( Btmp ) - FontSize Step 8
										XFontImage[ FontNumber, FirstChar + FirstImage ] = GetImage( XLoop , YLoop , FontSize , FontSize )
										FirstImage = FirstImage + 1
									Next XLoop
								Next YLoop
							EndCase
							Case 16
								For YLoop = 0 To GetImageHeight( Btmp ) - FontSize Step 16
									For Xloop = 0 To getImagewidth( Btmp ) - FontSize Step 16
										XFontImage[ FontNumber, FirstChar + FirstImage ] = GetImage( XLoop , YLoop , FontSize , FontSize )
										FirstImage = FirstImage + 1
									Next XLoop
								Next YLoop
							EndCase
							Case 32
								For YLoop = 0 To GetImageHeight( Btmp ) - FontSize Step 32
									For Xloop = 0 To getImagewidth( Btmp ) - FontSize Step 32
										XFontImage[ FontNumber, FirstChar + FirstImage ] = GetImage( XLoop , YLoop , FontSize , FontSize )
										FirstImage = FirstImage + 1
									Next XLoop
								Next YLoop
							EndCase
							Case 64
								For YLoop = 0 To GetImageHeight( Btmp ) - FontSize Step 64
									For Xloop = 0 To getImagewidth( Btmp ) - FontSize Step 64
										XFontImage[ FontNumber, FirstChar + FirstImage ] = GetImage( XLoop , YLoop , FontSize , FontSize )
									Next XLoop
								Next YLoop
							EndCase
						EndSelect
						xtDeleteBitmap( Btmp ) : Btmp = 0
						xtSetCurrentBitmap( 0 )
						XFont[ FontNumber ].FontSize = FontSize
						XFont[ FontNumber ].Exist = 1
						XFont[ FontNumber ].FirstChar = FirstChar
						XFont[ FontNumber ].mType = Flag
						XFontsys.CurrentFont = FontNumber
						INITIALIZED = 1
					Else
						INITIALIZED = - 5 // Impossible de créer un bitmap pour initialiser la fonte graphique.
					EndIf
				Else
					INITIALIZED = - 4 // Dimension de fonte non supportée.
				EndIf
			Else
				INITIALIZED = - 2 // Font Exist.
			EndIf
		Else
			INITIALIZED = - 1 // Font Number is Invalid.
		EndIf
	EndIf
	clearScreen()
EndFunction INITIALIZED
 
// *****************************************************************************************************************************
/**  Méthode                            : XFont_ClearFont 
//
// Description                          : Supprime une fonte graphique de la mémoire
//
// @FontNumber As Integer               : Le numéro d'index de la fonte de caractères
*/
Function XFont_ClearFont( FontNumber )
	If FontNumber > 0 And FontNumber < 17
		If XFont_Exist( FontNumber ) = 1
			For XLoop = 1 To 255
				If XFontImage[ FontNumber, XLoop ] > 0
					DeleteImage( XFontImage[ FontNumber, XLoop ] )
					XFontImage[ FontNumber, XLoop ] = 0
				EndIf
			Next XLoop
			XFont[ FontNumber ].Exist = 0 : XFont[ FontNumber ].FontSize = 0
			XFont[ FontNumber ].FirstChar = 0 : XFont[ FontNumber ].mType = 0
			If XFontSys.CurrentFont = FontNumber : XFontSys.CurrentFont = 0 : EndIf
		Else
			INITIALIZED = - 6 // La font n'existe pas
		EndIf
	Else
		INITIALIZED = - 1 // Font Number is Invalid.
	EndIf
EndFunction
 
// *****************************************************************************************************************************
/**  Méthode                     : XFont_ClearFont 
//
// Description                   : Supprime toutes les fontes graphiques de la mémoire
//
*/
Function XFont_ClearAllFont()
	For XLoop = 1 To 16
		If XFont_Exist( XLoop ) = 1 : XFont_ClearFont( XLoop ) : EndIf
	Next XLoop
EndFunction
 
// *****************************************************************************************************************************
/**  Méthode                     : XFont_ClearFont 
//
// Description                   : Supprime toutes les fontes graphiques de la mémoire
//
// @Return FontNumber As Integer : Renvoie 1 si la fonte d'index demandé existe, sinon 0.
*/
Function XFont_Exist( FontNumber As Integer )
	If FontNumber > 0 And FontNumber < 17
		INITIALIZED = XFont[ FontNumber ].Exist
	Else
		INITIALIZED = - 1 // Font Number is Invalid.
	EndIf 
EndFunction INITIALIZED
 
// *****************************************************************************************************************************
/**  Méthode                     : XFont_SetCursor
//
// Description                   : Positionne le curseur graphique des fontes bitmaps à des coordonnées spécifiques
//
// @Param XCursor As Integer     : L'abscisse sur X de la nouvelle position du curseur graphique
// @Param YCursor As Integer     / L'Ordonnée sur Y de la nouvelle position du curseur graphique
//
*/
Function XFont_SetCursor( XCursor As Integer , YCursor As Integer )
	XFontsys.XCursor = XCursor
	XFontsys.YCursor = YCursor
 EndFunction
 
Function XFont_SetCurrentFont( FontNumber As Integer ) 
	If FontNumber > 0 And FontNumber < 17
		If XFont_Exist( FontNumber ) = 1
			XFontSys.CurrentFont = FontNumber
		Else
			XFontSys.CurrentFont = 0
		EndIf
	EndIf
EndFunction
 
Function XFont_GetTextWidth( Texte As String )
	INITIALIZED As Integer = 0
	If XFontSys.CurrentFont > 0 
		If XFont_Exist( XFontSys.CurrentFont ) = 1 
			INITIALIZED = XFont[ XFontSys.CurrentFont ].FontSize * Len( Texte )
		Else
			INITIALIZED = - 6 // La font n'existe pas
		EndIf
	Else
		INITIALIZED = - 6 // La font n'existe pas
	EndIf
EndFunction INITIALIZED
 
Function XFont_GetTextHeight( Texte As String )
	If XFontSys.CurrentFont > 0
		If XFont_Exist( XFontSys.CurrentFont ) = 1
			INITIALIZED = XFont[ XFontSys.CurrentFont ].FontSize
		Else
			INITIALIZED = - 6 // La font n'existe pas
		EndIf
	Else
		INITIALIZED = - 6 // La font n'existe pas
	EndIf
EndFunction INITIALIZED
 
Function XFont_PrintFast( Texte As String, ReturnCarriage as Integer )
	Char As String
	If B2DInitialized = 1
		If XFontSys.CurrentFont > 0
			If XFont_Exist( XFontSys.CurrentFont ) = 1
				Btmp As Integer : Btmp = XFontSys.Bitmap
				XCurs As Integer : XCurs = XFontSys.XCursor
				YCurs As Integer : YCurs = XFontSys.YCursor
				If xtGetBitmapExists( Btmp ) : xtSetCurrentBitmap( Btmp ) : EndIf
				XWinBmp As Integer = 0 : XMargin As Integer = 0
				For XLoop = 1 To 16
					If Btmp = XWindowBitmap[ XLoop ] : XMargin = 8 : EndIf
				Next XLoop
				if ReturnCarriage = 1
					XMax As Integer : XMax = xtGetBitmapWidth( Btmp ) - ( XFont[ XFontSys.CurrentFont ].FontSize + XMargin )
					If XCurs > XMax
						XCurs = XMargin : YCurs = YCurs + XFont[ XFontSys.CurrentFont ].FontSize
					EndIf
				endif
				If Len( Texte ) > 0
					For XLoop = 1 To Len( Texte )
						If XFont[ XFontSys.CurrentFont ].mType = 0
							Char = Upper( Mid( Texte , XLoop , 1) )
						Else
							Char = Mid( Texte , XLoop , 1)
						EndIf
						Image As Integer : Image = XFontImage[ XFontSys.CurrentFont, Asc( Char ) ]
						If Image > 0
							PasteImageEx( Image , XCurs , YCurs , XFontsys.Opaque )
							XCurs = XCurs + XFont[ XFontSys.CurrentFont ].FontSize
							if ReturnCarriage = 1
								If XCurs > XMax And XFontSys.AutoReturn = 1
									XCurs = XMargin : YCurs = YCurs + XFont[ XFontSys.CurrentFont ].FontSize
								EndIf
							EndIf
						endif
					Next XLoop
					XCurs = XMargin : YCurs = YCurs + XFont[ XFontSys.CurrentFont ].FontSize
					XFontSys.XCursor = XCurs : XFontSys.YCursor = YCurs
				EndIf
				If Btmp > 15 : WinNum = 31 - Btmp : XWindow[ WinNum ].Refresh = 3 : EndIf
				xtSetCurrentBitmap( 0 )
			Else
				INITIALIZED = - 6 // La font n'existe pas
			EndIf
		Else
			INITIALIZED = - 6 // La font n'existe pas
		EndIf
	EndIf
EndFunction

Function XFont_GadgetPrintFast( Texte As String )
	If B2DInitialized = 1
		If XFontSys.CurrentFont > 0
			If XFont_Exist( XFontSys.CurrentFont ) = 1
				XCurs = XFontSys.XCursor : YCurs = XFontSys.YCursor
//					If XCurs > GetBitmapWidth( 0 ) - XFont( XFontSys.CurrentFont )\FontSize
//						XCurs = 0 : YCurs = YCurs + XFont( XFontSys.CurrentFont )\FontSize
//					EndIf
				Char As String
				If Len( Texte ) > 0
					For XLoop = 1 To Len( Texte )
						If XFont[ XFontSys.CurrentFont ].mType = 0
							Char = Upper( Mid( Texte , XLoop , 1) )
						Else
							Char = Mid( Texte , XLoop , 1)
						EndIf
						Image As Integer : Image = XFontImage[ XFontSys.CurrentFont, Asc( Char ) ]
						If Image > 0
							PasteImageEx( Image , XCurs , YCurs , XFontsys.Opaque )
							XCurs = XCurs + XFont[ XFontSys.CurrentFont ].FontSize
						EndIf
					Next XLoop
					XCurs = 0 : YCurs = YCurs + XFont[ XFontSys.CurrentFont ].FontSize
					XFontSys.XCursor = XCurs : XFontSys.YCursor = YCurs
				EndIf
			Else
				INITIALIZED = - 6 // La font n'existe pas
			EndIf
		Else
			INITIALIZED = - 6 // La font n'existe pas
		EndIf
	EndIf
EndFunction
 
Function XFont_PrintF( Texte As String )
	XFont_PrintFast( Texte, 0 )
EndFunction

Function XFont_Print( Texte As String )
	XFont_PrintFast( Texte, 1 )
EndFunction

Function XFont_Text( Texte As String, xPos As Integer, yPos As Integer )
	XCurseur As Integer
	YCurseur As Integer
	XCurseur = XFontSys.XCursor
	YCurseur = XFontSys.YCursor
	XFont_SetCursor( xPos, yPos )
	XFont_PrintFast( Texte, 0 )
	XFontSys.Xcursor = XCurseur
	XFontSys.YCursor = YCurseur
EndFunction
 
Function XFont_SetCurrentBitmap( Btmp As Integer )
	XFontSys.Bitmap = Btmp
EndFunction
 
Function XWindow_AttachWindow( MasterWin As Integer , TargetWin As Integer , Position As Integer )
	If MasterWin > 0 And MasterWin < 17 And B2DInitialized = 1
		If TargetWin > 0 And TargetWin < 17
			If XWindow_Exist( MasterWin ) And XWindow_Exist( Targetwin )
				XWindow[ MasterWin ].ChildCount = XWindow[ Masterwin ].ChildCount + 1
				XWindow[ TargetWin ].Parent = MasterWin
				XWindow[ TargetWin ].Alignment = Position
			EndIf
		EndIf
	EndIf
EndFunction
 
Function XWindow_DetachWindow( TargetWin As Integer )
	If TargetWin > 0 And TargetWin < 17
		If XWindow_Exist( TargetWin )
			XWindow[ XWindow[ TargetWin ].Parent ].ChildCount = XWindow[ XWindow[ TargetWin ].Parent ].ChildCount - 1
			XWindow[ TargetWin ].Alignment = 0
			XWindow[ TargetWin ].Parent = 0
		EndIf
	EndIf
EndFunction
 
Function XWindow_GetAttached( WinNum As Integer )
	Retour As Integer = 0
	If WinNum > 0 And WinNum < 16
		Retour = Xwindow[ WinNum ].Parent
	EndIf
EndFunction Retour
 
Function XWindow_SetTextOpaque()
	XFontsys.Opaque = 0
EndFunction
 
Function XWindow_SetTextTransparent()
	XFontsys.Opaque = 1
EndFunction
 
Function XWindow_GetWinGadgetCount( WinNum As Integer )
EndFunction XWindow[ WinNum ].GadgetCount
 
Function XWindow_SetChatGadget( GadNum As Integer )
	If GadNum > 0 And GadNum < 256 And B2DInitialized = 1
		If XGadget[ GadNum ].Exist = 1
			XWinSystem.ChatGadget = GadNum
			XWinSystem.ChatInText = ""
			XWinSystem.ChatReading = 0
		EndIf
	EndIf
EndFunction
 
Function XWindow_SetChatWindowGadget( GadNum As Integer )
	If GadNum > 0 And GadNum < 256 And B2DInitialized = 1
		If XGadget[ GadNum ].Exist = 1
			XWinSystem.ChatWindowGadget = GadNum 
		EndIf
	EndIf
EndFunction

Function XWindow_TalkToChatInternal( TEXTE As String )
	If XWinSystem.ChatWindowGadget > 0
		// Copy all chat texts up.
		For XLoop = 1 To 31 Step 1
			ChatText[ XLoop ] = ChatText[ XLoop + 1 ]
		Next XLoop
		ChatText[ 32 ] = TEXTE
		WinNum As Integer
		WinNum = XGadget[ XWinSystem.ChatWindowGadget ].Window
		If XWindow[ WinNum ].Refresh < 3
			XWindow[ WinNum ].Refresh = 3
		EndIf
	EndIf
EndFunction
 
Function XWindow_TalkToChat( TEXTE As String )
	XWindow_TalkToChatInternal( TEXTE )
EndFunction
 
Function XWindow_SetChatScanCode( Key As Integer )
	XWinSystem.ChatScanCode = Key
EndFunction
 
Function XWindow_ChatReadingKey()
EndFunction XWinSystem.ChatReading
 
Function XWindow_GetLastCommand( Teste As Integer )
EndFunction ChatText[ 32 ]
 
Function XFont_AutoReturnMode( Mode As Integer )
	XFontSys.AutoReturn = Mode
EndFunction

