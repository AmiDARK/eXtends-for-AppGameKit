
//
// ******************************************
// *                                        *
// * GESTION DES GADGETS DU SYSTEME XWINDOW *
// *                                        *
// ******************************************
//
Function XWindow_AddGadget( WinNum As Integer , GadNum As Integer , Xpos As Integer , Ypos As Integer , XSize As Integer , Ysize As Integer , Imag As Integer )
	If WinNum > -1 And WinNum < 16 And B2DInitialized = 1
		If GadNum > 0 And GadNum < 256
			If XGadget[ GadNum ].Exist = 0 And XWindow[ WinNum ].Exist = 1
				If GetImageExists( Imag ) = 1
					XGadget[ GadNum ].Image = Imag : XGadget[ GadNum ].Window = WinNum
					XGadget[ GadNum ].XPos = XPos : XGadget[ GadNum ].YPos = YPos
					XGadget[ GadNum ].XSize = XSize : XGadget[ GadNum ].YSize = YSize
					XGadget[ GadNum ].Exist = 1 : XGadget[ GadNum ].Texte = ""
					If XWindow[ WinNum ].Refresh < 3 : XWindow[ WinNum ].Refresh = 3 : EndIf
					XWindow[ WinNum ].GadgetCount = XWindow[ WinNum ].GadgetCount + 1
					XWinSystem.GadgetCount = XWinSystem.GadgetCount + 1
					XWindow_GadgetAdaptInternal( GadNum )
				EndIf
			EndIf
		EndIf
	EndIf
EndFunction  
//
Function XWindow_AddGadgetCombination( WinNum As Integer , GadNum As Integer , Xpos As Integer , Ypos As Integer , XSize As Integer , Ysize As Integer , Imag As Integer , TEXTE As String )
	If WinNum > -1 And WinNum < 16 And B2DInitialized = 1
		If GadNum > 0 And GadNum < 256
			If XGadget[ GadNum ].Exist = 0 And XWindow[ WinNum ].Exist = 1
				If GetImageExists( Imag ) = 1
					XGadget[ GadNum ].Image = Imag : XGadget[ GadNum ].Window = WinNum
					XGadget[ GadNum ].XPos = XPos : XGadget[ GadNum ].YPos = YPos
					XGadget[ GadNum ].XSize = XSize : XGadget[ GadNum ].YSize = YSize
					XGadget[ GadNum ].Exist = 1 : XGadget[ GadNum ].Texte = TEXTE
					If XWindow[ WinNum ].Refresh < 3 : XWindow[ WinNum ].Refresh = 3 : EndIf
					XWindow[ WinNum ].GadgetCount = XWindow[ WinNum ].GadgetCount + 1
					XWinSystem.GadgetCount = XWinSystem.GadgetCount + 1
					XWindow_GadgetAdaptInternal( GadNum )
				EndIf
			EndIf
		EndIf
	EndIf
EndFunction  
//
Function XWindow_AddGadgetTexte( WinNum As Integer , GadNum As Integer , Xpos As Integer , Ypos As Integer , XSize As Integer , Ysize As Integer , TEXTE As String )
	If WinNum > 0 And WinNum < 16 And B2DInitialized = 1
		If GadNum > 0 And GadNum < 256
			If XGadget[ GadNum ].Exist = 0 And XWindow[ WinNum ].Exist = 1
				XGadget[ GadNum ].Image = 0 : XGadget[ GadNum ].Window = WinNum
				XGadget[ GadNum ].XPos = XPos : XGadget[ GadNum ].YPos = YPos
				XGadget[ GadNum ].XSize = XSize : XGadget[ GadNum ].YSize = YSize
				XGadget[ GadNum ].Exist = 1 : XGadget[ GadNum ].Texte = TEXTE
				If XWindow[ WinNum ].Refresh < 3 : XWindow[ WinNum ].Refresh = 3 : EndIf
				XWindow[ WinNum ].GadgetCount = XWindow[ WinNum ].GadgetCount + 1
				XWinSystem.GadgetCount = XWinSystem.GadgetCount + 1
				XWindow_GadgetAdaptInternal( GadNum )
			EndIf
		EndIf
	EndIf
EndFunction  
//
Function XWindow_GadgetAdaptInternal( GadNum As Integer )
	If GadNum > 0 And GadNum < 256
		If XWindow[ XGadget[ GadNum ].Window ].Borders = 1
			XAdd As Integer = 8 : YAdd As Integer = 8 
			If XWindow[ XGadget[ GadNum ].Window ].Title = 1
				YAdd = 16
			EndIf
			XGadget[ GadNum ].Xpos = XGadget[ GadNum ].Xpos + XAdd
			XGadget[ GadNum ].Ypos = XGadget[ GadNum ].Ypos + YAdd
		EndIf
	EndIf
EndFunction
//
//
Function XWindow_GadgetRefreshFast( GadNum As Integer )
	// Si le gadget possède une image, on l'affiche en premier.
	If XGadget[ GadNum ].Image > 0
		If GetImageExists( XGadget[ GadNum ].Image ) = 1
			PasteImageEx( XGadget[ GadNum ].Image , XGadget[ GadNum ].Xpos , XGadget[ GadNum ].YPos , 1 )
		EndIf
	EndIf
	// Dans le mode ChatWindowGadget, on peut afficher plusieurs lignes de textes ... alors on fait le compte d'abord.
	If XWinSystem.ChatWindowGadget = GadNum And XWinSystem.ChatWindowGadget > 0
		If XFontSys.CurrentFont > 0
			DefaultFont As Integer : DefaultFont = XFontSys.CurrentFont
			XFontSys.CurrentFont = XWindow[ XGadget[ GadNum ].Window ].XFont
			YSize As Integer : YSize = XFont_GetTextHeight( "TEST" )
			If YSIZE = 0 : YSIZE = 8 : EndIf
			YCount As Integer : YCount = XGadget[ GadNum ].YSize / YSize
			XCount As Integer : XCount = XGadget[ GadNum ].XSize / YSize
			If YCount * YSize > XGadget[ GadNum ].YSize : YCount = YCount - 1 : EndIf
			XPos As Integer : XPos = XGadget[ GadNum ].Xpos
			YPos As Integer : YPos = XGadget[ GadNum ].Ypos + XGadget[ GadNum ].YSize - YSize
			XLoop = 32
			TESTE As String
			Repeat
				If Len( TESTE ) = 0
					TESTE = ChatText[ XLoop ] : XLoop = XLoop - 1
				EndIf
				XFont_SetCursor( Xpos , Ypos )
				If Len( TESTE ) <= XCount
					XFont_GadgetPrintFast( TESTE )
					TESTE = ""
				Else
					XLines As Integer : XLines = Len( TESTE ) / XCount
					If XLines * XCount = Len( TESTE ) : XLines = XLines - 1 : EndIf
					XStart As Integer : XStart = XLines * XCount
					XQuant As Integer : XQuant = Len( TESTE ) - XStart
					TEST2 As String : TEST2 = Right( TESTE , XQuant )
					// TESTE As String
					TESTE = Left( TESTE , Len( TESTE ) - XQuant )
					XFont_GadgetPrintFast( TEST2 )
				EndIf
				YPos = YPos - YSize : YCount = YCount - 1
			Until YCount < 1
			XFontSys.CurrentFont = DefaultFont
		EndIf
	Else
		// Si le gadget contient du texte, on l'affiche après l'image.
		If Len( XGadget[ GadNum ].Texte ) > 0
			TEMPTEXT As String : TEMPTEXT = XGadget[ GadNum ].Texte
			If Len( TEMPTEXT ) > 0
				If XWindow[ XGadget[ GadNum ].Window ].XFont = 0
					XSize As Integer : XSize = dbTextWidth( TEMPTEXT )
					// YSize As Integer
					YSize = dbTextHeight( TEMPTEXT )
					If XWinSystem.ChatGadget = GadNum
						// XPos As Integer
						XPos = XGadget[ GadNum ].XPos
						// YSize As Integer
						YSize = DBTextHeight( TEMPTEXT )
						XCount = XGadget[ GadNum ].XSize / YSize
						If Len( TEMPTEXT ) >= XCount : TEMPTEXT = Right( TEMPTEXT , XCount ) : EndIf
					Else
						// XPos As Integer
						XPos = XGadget[ GadNum ].Xpos + ( XGadget[ GadNum ].XSize / 2 ) - ( XSize / 2 )
					EndIf
					// YPos As Integer
					YPos = XGadget[ GadNum ].Ypos + ( XGadget[ GadNum ].YSize / 2 ) - ( YSize / 2 )
					DBSetCursor( Xpos , Ypos ) : dbPrint( TEMPTEXT )
				Else
					// DefaultFont As Integer
					DefaultFont = XFontSys.CurrentFont
					XFontSys.CurrentFont = XWindow[ XGadget[ GadNum ].Window ].XFont
					// XSize As Integer
					XSize = XFont_GetTextWidth( TEMPTEXT )
					// YSize As Integer
					YSize = XFont_GetTextHeight( TEMPTEXT )
					If XWinSystem.ChatGadget = GadNum
						// XPos As Integer
						XPos = XGadget[ GadNum ].XPos
						// YSize As Integer
						YSize = XFont_GetTextHeight( TEMPTEXT )
						// XCount As Integer
						XCount = XGadget[ GadNum ].XSize / YSize
						If Len( TEMPTEXT ) >= XCount : TEMPTEXT = Right( TEMPTEXT , XCount ) : EndIf
					Else
						// XPos As Integer
						XPos = XGadget[ GadNum ].Xpos + ( XGadget[ GadNum ].XSize / 2 ) - ( XSize / 2 )
					EndIf
					// YPos As Integer
					XPos = XGadget[ GadNum ].Ypos + ( XGadget[ GadNum ].YSize / 2 ) - ( YSize / 2 )          
					XFont_SetCursor( Xpos , Ypos )
					XFont_GadgetPrintFast( TEMPTEXT )
					XFontSys.CurrentFont = DefaultFont
				EndIf
			EndIf
		EndIf
	EndIf
EndFunction
//
Function XWindow_DeleteGadget( GadNum As Integer )
	If GadNum > 0 And GadNum < 256
		If XGadget[ GadNum ].Exist = 1
			If XWindow[ XGadget[ GadNum ].Window ].Refresh < 4 : XWindow[ XGadget[ GadNum ].Window ].Refresh = 4 : EndIf
			XWindow[ XGadget[ GadNum ].Window ].GadgetCount = XWindow[ XGadget[ GadNum ].Window ].GadgetCount - 1
			XWinSystem.GadgetCount = XWinSystem.GadgetCount - 1
			XGadget[ GadNum ].Image = 0 : XGadget[ GadNum ].Window = 0
			XGadget[ GadNum ].XPos = 0 : XGadget[ GadNum ].YPos = 0
			XGadget[ GadNum ].XSize = 0 : XGadget[ GadNum ].YSize = 0
			XGadget[ GadNum ].Exist = 0 : XGadget[ GadNum ].Texte = ""
		EndIf
	EndIf
EndFunction
//
Function XWindow_GetCurrentGadget()
	GadNum As Integer : GadNum = XWinSystem.CurrentGadget
EndFunction GadNum
//
Function XWindow_SetGadgetImage( GadNum As Integer , Imag As Integer )
	If GadNum > 0 And GadNum < 256
		If XGadget[ GadNum ].Exist = 1
			If Imag > 0 : XGadget[ GadNum ].Image = Imag : EndIf
			If XWindow[ XGadget[ GadNum ].Window ].Refresh < 4 : XWindow[ XGadget[ GadNum ].Window ].Refresh = 4 : EndIf
		EndIf
	EndIf
EndFunction
//
Function XWindow_SetGadgetTextInternal( GadNum As Integer , Texte As String )
	If GadNum > 0 And GadNum < 256
		If XGadget[ GadNum ].Exist = 1
			XGadget[ GadNum ].Texte = Texte
			If XWindow[ XGadget[ GadNum ].Window ].Refresh < 4 : XWindow[ XGadget[ GadNum ].Window ].Refresh = 4 : EndIf
		EndIf
	EndIf
EndFunction
//
Function XWindow_SetGadgetText( GadNum As Integer , TEXTE As String )
	XWindow_SetGadgetTextInternal( GadNum , TEXTE )
EndFunction
//
Function XWindow_PositionGadget( GadNum As Integer , XPos As Integer , YPos As Integer )
	If GadNum > 0 And GadNum < 256
		If XGadget[ GadNum ].Exist = 1
			XGadget[ GadNum ].XPos = XPos : XGadget[ GadNum ].XPos = YPos
			If XWindow[ XGadget[ GadNum ].Window ].Refresh < 4 : XWindow[ XGadget[ GadNum ].Window ].Refresh = 4 : EndIf
		EndIf
	EndIf
EndFunction
