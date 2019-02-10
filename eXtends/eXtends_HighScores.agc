


Function DSK_AddHighScore( Score As Integer, nomme As String , Level As Integer )
	If DSKInitialized = 1
		Position As Integer = 0
		Repeat
			Inc Position, 1
		Until Score > Scores[ Position ] Or Position = 33
		If Position < 33
			If Position < 31
				For XLoop = 31 To Position Step - 1
					Scores[ XLoop ] = Scores[ XLoop - 1 ]
					Names[ XLoop ] = Names[ XLoop - 1 ]
					Levels[ XLoop ] = Levels[ XLoop - 1 ]
				Next XLoop
			Else
				Scores[ 32 ] = Scores[ 31 ]
				Names[ 32 ] = Names[ 31 ]
				Levels[ 32 ] = Levels[ 31 ]
			EndIf
			Scores[ Position ] = Score
			Names[ Position ] = nomme
			Levels[ Position ] = Level
		EndIf   
	EndIf
EndFunction

Function DSK_GetHighScore( Position As Integer )
	Result As Integer = 0
	If DSKInitialized = 1
		If Position > 0 And Position < 33
			Result = Scores[ Position ]
		Else
			Result = -1
		EndIf
	Else
		Result = -1
	EndIf
EndFunction Result

Function DSK_GetHighScoreName( Position As Integer )
	TextOut As String = ""
	If DSKInitialized = 1
		If Position < 1 Or Position > 32
			Position = 0
		Endif
		TextOut = Names[ Position ]
		If TextOut = ""
			TextOut = "--------"
		EndIf
	Endif
 EndFunction TextOut

Function DSK_GetHighScoreLevel( Position As Integer )
	Result As Integer = -1
	If DSKInitialized = 1
		If Position > 0 And Position < 33
			Result = Levels[ Position ]
		EndIf
	EndIf
 EndFunction Result

Function DSK_SaveHighScore( Fichier As String )
	If Len( Fichier ) > 0
		If DSKInitialized = 1
			If Fichier = ""
				Fichier = "highscores.dat"
			EndIf
			FileIO = OpenToWrite( Fichier )
				WriteString( FileIO, "AGK_ExtendsPack_highscores" )
				For XLoop = 1 To 32
					WriteInteger( FileIO, Scores[ XLoop ] )
					WriteInteger( FileIO, Levels[ XLoop ] )
					WriteString( FileIO, Names[ XLoop ] )
				Next XLoop
				WriteString( FileIO, "_EOF" )
			CloseFile( FileIO )
		EndIf
	EndIf
EndFunction
 
Function DSK_LoadHighScore( Fichier As String )
	If Len( Fichier ) > 0
		If DSKInitialized = 1
			If Fichier = ""
				Fichier = "highscores.dat"
			EndIf
			FileIO = OpenToRead( Fichier )
				_HEADER As String
				_HEADER = ReadString( FileIO )
				If _HEADER = "AGK_ExtendsPack_highscores"
					For XLoop = 1 To 32
						Scores[ XLoop ] = ReadInteger( FileIO )
						Levels[ XLoop ] = ReadInteger( FileIO )
						Names[ XLoop ] = ReadString( FileIO )
					Next XLoop
				EndIf
			CloseFile( FileIO )
		EndIf
	EndIf
EndFunction

Function DSK_ClearHighScore()
	If DSKInitialized = 1
		For XLoop = 1 To 32
			Scores[ XLoop ] = 0
			Levels[ XLoop ] = 0
			Names[ XLoop ] = "--------"
		Next XLoop
	EndIf
EndFunction
 
