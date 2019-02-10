
Function MBC_CloneMemblock( MemblockSource As Integer )
	Target As Integer = 0 : NULL As Integer = 0
	If GetMemblockExists( MemblockSource ) = 1
		Size As Integer : Size = GetMemblockSize( MemblockSource )
		Target = CreateMemblock( Size )
		CopyMemblock( MemblockSource, Target, 0, 0, Size )
	EndIf
EndFunction Target



Function MakeMemblockImage( MWidth As Integer, MHeight As Integer, MDepth As Integer )
	MNumber As Integer = 0 
	If MWidth > 0 And MHeight > 0
		Select MDepth
			Case 32 : Lgt As Integer = 4 : EndCase
			Case 16 : Lgt = 2 : EndCase
			Case 8 : Lgt = 1 : EndCase
		EndSelect
		FSize As Integer : FSize = 12 + ( MWidth * MHeight * Lgt )
		MNumber = CreateMemblock( FSize )
		SetMemblockInt( MNumber, 0, MWidth )
		SetMemblockInt( MNumber, 4, MHeight )
		SetMemblockInt( MNumber, 8, MDepth )
	EndIf
 EndFunction MNumber

Function IMPlot( Memblok As Integer, XPos As Integer, YPos As Integer, RGBColor As Integer )
	If Memblok > 0
		If getMemblockExists( Memblok ) = 1
			XSize As Integer : XSize = GetMemblockInt( Memblok, 0 )
			YSize As Integer : YSize = GetMemblockInt( Memblok, 4 )
			Depth As Integer : ZSize = GetMemblockInt( Memblok, 8 ) / 8
			If XPos < XSize And YPos < YSize
				If XPos > -1 And YPos > -1
					Adr As Integer : Adr = 12 + ( XPos * Depth ) + ( YPos * Xsize * Depth )
					Select Depth
						Case 1 : SetMemblockByte( Memblok, Adr, RGBColor ) : EndCase
						Case 2 : SetMemblockShort( Memblok, Adr, RGBColor ) : EndCase
						Case 4 : SetMemblockInt( Memblok, Adr, RGBColor ) : EndCase
					EndSelect
				EndIf
			EndIf
		EndIf
	EndIf
EndFunction

Function IMGetPixel( Memblok As Integer, XPos As Integer, YPos As Integer )
	RGBColor As Integer = 0
	If Memblok > 0
		If getMemblockExists( Memblok ) = 1
			XSize As Integer = 0 : XSize = GetMemblockInt( Memblok, 0 )
			YSize As Integer = 0 : YSize = GetMemblockInt( Memblok, 4 )
			Depth As Integer = 0 : Depth = GetMemblockInt( Memblok, 8 ) / 8
			If XPos < XSize And YPos < YSize
				If XPos > -1 And YPos > -1
					Adr As Integer : Adr = 12 + ( XPos * Depth ) + ( YPos * Xsize * Depth )
					Select Depth
						Case 1 : RGBColor = GetMemblockByte( Memblok, Adr ) : EndCase
						Case 2 : RGBColor = GetMemblockShort( Memblok, Adr ) : EndCase
						Case 4 : RGBColor = GetMemblockInt( Memblok, Adr ) : EndCase
					EndSelect
				EndIf
			EndIf
		EndIf
	EndIf
EndFunction RGBColor

Function IMCircle( Memblok As Integer, XPos As Integer, YPos As Integer, Radius As Integer, RGBColor As Integer, Mode As Integer )
	XIn As Integer = 0
	YIn As Integer = 0
	Size As Float = 0.0
	AngleF As Float = 0.0
	If Memblok > 0
		If getMemblockExists( Memblok ) = 1
			If Radius > 0
				Select Mode
					Case 0
						For Angle = 0 To 360 Step 1
							XIn = Xpos + ( Cos( Angle ) * ( Radius / 2.0 ) )
							YIn = YPos + ( Sin( Angle ) * ( Radius / 2.0 ) )
							IMPlot( Memblok, XIn, YIn, RGBColor )
						Next Angle
					EndCase
					Case 1
						Size = Radius
						Repeat
							AngleF = 0.0
							Repeat
								XIn = XPos + ( Cos( AngleF ) * ( Size / 2.0 ) )
								YIn = YPos + ( Sin( AngleF ) * ( Size / 2.0 ) )
								IMPlot( Memblok, XIn, YIn, RGBColor )
								AngleF = AngleF + 0.5
							Until AngleF > 360.0
							Size = Size - 0.5
						Until Size = 0
						IMPlot( Memblok, XPos, YPos, RGBColor )
					EndCase
				EndSelect
			EndIf
		EndIf
	EndIf
 EndFunction

Function IMCube( Memblok As Integer, XPos As Integer, YPos As Integer, XYSize As Integer, RGBColor As Integer, Mode As Integer )
	If Memblok > 0
		If getMemblockExists( Memblok ) = 1
			If XYSize > 1
				Select Mode
					Case 0
						For XYLoop = XPos To XPos + XYSize - 1
							IMPlot( Memblok, XYLoop, YPos, RGBColor ) // Top Line
							IMPlot( Memblok, XPos, XYLoop, RGBColor ) // Left Line
							IMPlot( Memblok, XYLoop, YPos + XYSize -1, RGBColor ) // Bottom Line
							IMPlot( Memblok, XPos + XYSize -1, XYLoop, RGBColor ) // Right Line
						Next XYLoop
					EndCase
					Case 1
						For XLoop = XPos To XPos + XYSize -1
							For YLoop = YPos To YPos + XYSize -1
								IMPlot( Memblok, XLoop, YLoop, RGBColor )
							Next YLoop
						Next XLoop
					EndCase
				EndSelect
			Else
				If XYSize = 1
					IMPlot( Memblok, XPos, YPos, RGBColor )
				EndIf
			EndIf
		EndIf
	EndIf
EndFunction

Function IMBox( Memblok As Integer, XPos As Integer, YPos As Integer, XRight As Integer, YDown As Integer, RGBColor As Integer, Mode As Integer )
	If Memblok > 0
		If getMemblockExists( Memblok ) = 1
			Select Mode
				Case 0
					For XLoop = Xpos To XRight
						IMPlot( Memblok, XLoop, YPos, RGBColor )  // Top Line
						IMPlot( Memblok, XLoop, YDown, RGBColor ) // Bottom Line
					Next XLoop
					For YLoop = YPos To YDown
						IMPlot( Memblok, XPos, YLoop, RGBColor )   // Left Line
						IMPlot( Memblok, XRight, YLoop, RGBColor ) // Right Line
					Next YLoop
				EndCase
				Case 1
					For XLoop = XPos To XRight
						For YLoop = YPos To YDown
							IMPlot( Memblok, XLoop, YLoop, RGBColor )
						Next YLoop
					Next XLoop
				EndCase
			EndSelect
		EndIf
	EndIf
 EndFunction

Function IMStretch( SourceMBC, TargetMBC )
	If SourceMBC > 0 And TargetMBC > 0
		If getMemblockExists( SourceMBC ) = 1 And getMemblockExists( TargetMBC ) = 1
			XSize1 As Integer = 0 : XSize1 = GetMemblockInt( SourceMBC, 0 )
			YSize1 As Integer = 0 : YSize1 = GetMemblockInt( SourceMBC, 4 )
			Depth1 As Integer = 0 : Depth1 = GetMemblockInt( SourceMBC, 8 )
			XSize2 As Integer = 0 : XSize2 = GetMemblockInt( TargetMBC, 0 )
			YSize2 As Integer = 0 : YSize2 = GetMemblockInt( TargetMBC, 4 )
			Depth2 As Integer = 0 : Depth2 = GetMemblockInt( TargetMBC, 8 )
			XScaling As Float = 0.0 : XScaling = XSize1 / XSize2
			YScaling As Float = 0.0 : YScaling = YSize1 / YSize2      
			For YLoop = 0 To YSize2 -1
				For XLoop = 0 To XSize2 -1
					RGBColor = IMGetPixel( SourceMBC, XLoop * XScaling, YLoop * YScaling )
					IMPlot( TargetMBC, XLoop, YLoop, RGBColor )
				Next XLoop
			Next YLoop
		EndIf
	EndIf
EndFunction

Function IMStretch2( SourceMBC, XSize As Integer, YSize As Integer )
	DepthSRC As Integer : DepthSRC = GetMemblockInt( SourceMBC, 8 ) // Read original depth to use the same.
	TargetMBC = MakeMemblockImage( XSize, YSize, DepthSRC )
	If SourceMBC > 0 And XSize > 0 And YSize > 0
		If getMemblockExists( SourceMBC ) = 1 And getMemblockExists( TargetMBC ) = 1
			XSize1 As Integer = 0 : XSize1 = GetMemblockInt( SourceMBC, 0 )
			YSize1 As Integer = 0 : YSize1 = GetMemblockInt( SourceMBC, 4 )
			Depth1 As Integer = 0 : Depth1 = GetMemblockInt( SourceMBC, 8 )
			XSize2 As Integer = 0 : XSize2 = GetMemblockInt( TargetMBC, 0 )
			YSize2 As Integer = 0 : YSize2 = GetMemblockInt( TargetMBC, 4 )
			Depth2 As Integer = 0 : Depth2 = GetMemblockInt( TargetMBC, 8 )
			XScaling As Float = 0.0 : XScaling = XSize1 / XSize2
			YScaling As Float = 0.0 : YScaling = YSize1 / YSize2      
			For YLoop = 0 To YSize2 -1
				For XLoop = 0 To XSize2 -1
					RGBColor = IMGetPixel( SourceMBC, XLoop * XScaling, YLoop * YScaling )
					IMPlot( TargetMBC, XLoop, YLoop, RGBColor )
				Next XLoop
			Next YLoop
		EndIf
	EndIf
EndFunction TargetMBC

Function CopyMemblockImage( SourceMBC As Integer, X As Integer, Y As Integer, Width As Integer, Height As Integer, TargetMBC As Integer, X2 As Integer, Y2 As Integer )
	Reduce As Integer = 0
  If SourceMBC > 0 And TargetMBC > 0
    If GetMemblockExists( SourceMBC ) = 1 And GetMemblockExists( TargetMBC ) = 1
      XSize1 As Integer = 0 : XSize1 = GetMemblockInt( SourceMBC, 0 )
      YSize1 As Integer = 0 : YSize1 = GetMemblockInt( SourceMBC, 4 )
      Depth1 As Integer = 0 : Depth1 = GetMemblockInt( SourceMBC, 8 )
      XSize2 As Integer = 0 : XSuze2 = GetMemblockInt( TargetMBC, 0 )
      YSize2 As Integer = 0 : YSize2 = GetMemblockInt( TargetMBC, 4 )
      Depth2 As Integer = 0 : Depth2 = GetMemblockInt( TargetMBC, 8 )
      If Width <= XSize1 And Width <= XSize2
        If Height <= YSize1 And Height <= YSize2
          // On checke si la zone à copier déborde du cadre ... Si c'est le cas, on réduit.
          If X < 0 : Width = Width + X : X = 0 : EndIf // Si X < 0 On réduit la 
          If Y < 0 : Height = Height + Y : Y = 0 : EndIf
          If X + Width > XSize1
            Reduce = ( X + Width ) - XSize1
            Width = Width - Reduce
           EndIf
          If Y + Height > YSize1
            Reduce = ( Y + Height ) - YSize1
            Height = Height - Reduce
           EndIf
          // On checke si la zone copiée sortira du cadre cible ... Si c'est le cas, on réduit.
          If X2 < 0 : X = X + X2 : Width = Width + X2 : X2 = 0 : EndIf
          If Y2 < 0 : Y = Y + Y2 : Height = Height + Y2 : Y2 = 0 : EndIf
          If X2 + Width > XSize2
            Reduce = ( X2 + Width ) - XSize2
            Width = Width - Reduce
           EndIf
          If Y2 + Height > YSize2
            Reduce = ( Y2 + Height ) - YSize2
            Height = Height - Reduce
           EndIf
          // On vérifie qu'après tout les checking, il reste un morceau de bloc à copier...
          If Width > 0 And Height > 0
            // On défini les variables nécessaires à la copie du bloc final nécessaire.
            BytesPerCycle As Integer = 0 :BytesPerCycle = Width * 4              // Nombre d'octets à copier par lignes.
            ReadSkip As Integer = 0 : ReadSkip = ( XSize1 - Width ) * 4      // Nombre d'octets à skipper par lignes.
            WriteSkip As Integer = 0 : WriteSkip = ( XSize2 - Width ) * 4   // Nombre d'octets à skipper par lignes.
            SourcePTR As Integer = 0 : SourcePTR = ( X * 4 ) + ( Y * XSize1 * 4 ) + 12
            TargetPTR As Integer = 0 : TargetPTR = ( X2 * 4 ) + ( Y2 * XSize2 * 4 ) + 12
            // CopyMemoryM( SourcePTR, TargetPTR, BytesPerCycle, ReadSkip, WriteSkip, Height) 
           EndIf
         EndIf
       EndIf
     EndIf
   EndIf
 EndFunction
 
Function PrepareMeshMemblock( TriangleCount As Integer )
	Size As Integer : Size = ( ( 36 * 3 ) * TriangleCount ) + 16
	MemblockNumber As Integer : MemblockNumber = CreateMemblock( Size )
	// Définition du format FVF
	SetMemblockInt( MemblockNumber , 0 , 338 )
	// Définition de la longueur d'un Vertex
	SetMemblockInt( MemblockNumber , 4 , 36 )
	// Combien de sommets ( = Vertex = Vertices ) sont présents ?
	SetMemblockInt( MemblockNumber , 8 , TriangleCount )
EndFunction MemblockNumber

Function MBC_PrepareMbc( XCount As Integer, ZCount As Integer )
	Tiles_Count As Integer : Tiles_Count = XCount * ZCount
	Memory_Used As Integer : Memory_Used = ( Tiles_Count * 216 ) + 16
	Vertex_Count As Integer : Vertex_Count = Tiles_Count * 6
	Mem As Integer : Mem = CreateMemblock( Memory_Used )
	// Définition du format FVF
	SetMemblockInt( Mem, 0, 338 )
	// Définition de la longueur d'un vertex
	SetMemblockInt( Mem, 4, 36 )
	// Nombre de sommets ( = vertex, vertices ) dans la meshe )
	SetMemblockInt( Mem, 8, Vertex_Count )
EndFunction Mem

Function MBC_MakeVector( Mem As Integer, Vector_Num As Integer, X1 As Float, Y1 As Float, Z1 As Float, Xn As Float, Yn As Float, Zn As Float, RGBColor As Integer, TU As Float, TV As Float )
	InPos As Integer : InPos = 12 + ( Vector_Num * 36 )
	SetMemblockFloat( Mem, InPos, X1 )
	SetMemblockFloat( Mem, InPos + 4, Y1 )
	SetMemblockFloat( Mem, InPos + 8, Z1 )
	SetMemblockFloat( Mem, InPos + 12, Xn )
	SetMemblockFloat( Mem, InPos + 16, Yn )
	SetMemblockFloat( Mem, InPos + 20, Zn )
	SetMemblockFloat( Mem, InPos + 24, RGBColor )
	SetMemblockFloat( Mem, InPos + 28, TU )
	SetMemblockFloat( Mem, InPos + 32, TV )
EndFunction

Function MBC_MakeTile( Mem As Integer, Tile As Integer, X1 As Float, Y1 As Float, Z1 As Float, X2 As Float, Y2 As Float, Z2 As Float, X3 As Float, Y3 As Float, Z3 As Float, X4 As Float, Y4 As Float, Z4 As Float )
	Vector_Number As Integer : Vector_Number = Tile * 6
	_Nk As Integer : _Nk = ( 255+65536 ) + (255*256 ) + 255
	MBC_MakeVector( Mem, Vector_Number + 0, X3, Y3, Z3, 0.000 , 1.000 , 0.000 , _Nk , 0.000 , 1.000 )
	MBC_MakeVector( Mem, Vector_Number + 1, X2, Y2, Y2, 0.000 , 1.000 , 0.000 , _Nk , 1.000 , 0.000 )
	MBC_MakeVector( Mem, Vector_Number + 2, X4, Y4, Y4, 0.000 , 1.000 , 0.000 , _Nk , 1.000 , 1.000 )
	MBC_MakeVector( Mem, Vector_Number + 3, X3, Y3, Y3, 0.000 , 1.000 , 0.000 , _Nk , 0.000 , 1.000 )
	MBC_MakeVector( Mem, Vector_Number + 4, X1, Y1, Y1, 0.000 , 1.000 , 0.000 , _Nk , 0.000 , 0.000 )
	MBC_MakeVector( Mem, Vector_Number + 5, X2, Y2, Y2, 0.000 , 1.000 , 0.000 , _Nk , 1.000 , 0.000 )
EndFunction


