


//
Function PrepareSpriteForCollision( Sprite1 As Integer )
	If SPRInitialized = 1
		If Sprite1 > 0
			If GetSpriteExists( Sprite1 ) = 1
				SpriteImage1 As Integer : SpriteImage1 = GetSpriteImageID( Sprite1 )
				If SpriteImage1 <> SpriteIMG[ Sprite1 ]
					SpriteIMG[ Sprite1 ] = SpriteImage1
					If SpriteCOL[ Sprite1 ] = 0
						SpriteCOL[ Sprite1 ] = CreateMemblockFromImage( SpriteImage1 )
					Else
						DeleteMemblock( SpriteCOL[ Sprite1 ] )
						CreateMemblockFromImage( SpriteCOL[ Sprite1 ], SpriteImage1 )
					EndIf 
				EndIf
			EndIf
		EndIf
	EndIf
EndFunction

Function FreeSpriteFromCollision( SpriteNum As Integer )
	If SPRInitialized = 1
		If SpriteNum > 0
			If GetSpriteExists( SpriteNum ) = 1 And SpriteCol[ SpriteNum ] > 0
				SpriteCOL[ SpriteNum ] = 0 : DeleteMemblock( SpriteCol[ SpriteNum ] )
				// SpritePTR[ SpriteNum ] = 0
				SpriteIMG[ SpriteNum ] = 0
			EndIf
		EndIf
	EndIf
EndFunction

Function GetSpritesDistance( Sprite1 As Integer, Sprite2 As Integer )
	_Distance As Integer = -1
	If SPRInitialized = 1
		If Sprite1 > 0 And Sprite2 > 0
			xp1 As Integer : xp1 = GetSpriteX( Sprite1 )
			yp1 As Integer : yp1 = GetSpriteY( Sprite1 )
			xsize1 As Integer : xsize1 = GetSpriteWidth( Sprite1 )
			ysize1 As Integer : ysize1 = GetSpriteHeight( Sprite1 )
			xp2 As Integer : xp2 = GetSpriteX( Sprite2 )
			yp2 As Integer : yp2 = GetSpriteY( Sprite2 )
			xsize2 As Integer : xsize2 = GetSpriteWidth( Sprite2 )
			ysize2 As Integer : ysize2 = GetSpriteHeight( Sprite2 )
			If xp1 < xp2
				xp1 = xp1 + xsize1 : If xp1 > xp2 : xp1 = xp2 : EndIf
			Else
				xp2 = xp2 + xsize2 : If xp2 > xp1 : xp2 = xp1 : EndIf
			EndIf
			If yp1 < yp2
				yp1 = yp1 + ysize1 : If yp1 > yp2 : yp1 = yp2 : EndIf
			Else
				yp2 = yp2 + ysize2 : If yp2 > yp1 : yp2 = yp1 : EndIf
			EndIf
			xdist As Integer : xdist= Abs( xp1 - xp2 )
			ydist As Integer : ydist = Abs( yp1 - yp2 )
			_distance = Sqrt( ( xdist * xdist ) + ( ydist * ydist ) )
		EndIf
	EndIf
EndFunction _distance

Function extGetSpriteCollision( _Sprite1 As Integer, _Sprite2 As Integer, COLMODE As Integer )
	VALUE As Integer = -1
	If SPRInitialized = 1
		// Check If any rotation/scaling is applied To sprite
		If _Sprite1 > 0 And _Sprite2 > 0
			If GetSpriteScaleX( _Sprite1 ) = 100.0 And GetSpriteScaleY( _Sprite1 ) = 100.0
				If GetSpriteScaleX( _Sprite2 ) = 100.0 And GetSpriteScaleY( _Sprite2 ) = 100.0
					If GetSpriteAngle( _Sprite1 ) = 0 And GetSpriteAngle( _Sprite2 ) = 0    
						// VALUE = extGetSpriteCollisionOPT( _sprite1, _sprite2, COLMODE )
						VALUE = extGetSpriteCollisionAdvanced( _sprite1, _sprite2, COLMODE )
					Else
						VALUE = extGetSpriteCollisionAdvanced( _sprite1, _sprite2, COLMODE )
					EndIf
				Else
					VALUE = extGetSpriteCollisionAdvanced( _sprite1, _sprite2, COLMODE )
				EndIf
			Else
				VALUE = extGetSpriteCollisionAdvanced( _sprite1, _sprite2, COLMODE )
			EndIf
		EndIf
	EndIf
EndFunction VALUE




// Internal functions

Function GetPixelColor( Sprite1 As Integer, XPos As Integer, YPos As Integer )
	_RESULT As Integer = 0
	_xs As Integer : _xs = GetMemblockInt( SpriteCOL[ Sprite1 ], 0 )
	_ys As Integer : _ys = GetMemblockInt( SpriteCOL[ Sprite1 ], 4 )
	_dp As Integer : _dp = GetMemblockInt( SpriteCOL[ Sprite1 ], 8 )
	_pixsize As Integer : _pixsize = _dp / 8
	If XPos > -1 And XPos < _xs
		If YPos > -1 And YPos < _ys
			_Adress = 12 + ( YPos * _xs * _PixSize ) + ( XPos * _PixSize )
			If _Adress > -1 And _Adress < GetMemblockSize( SpriteCOL[ Sprite1 ] )
				If _dp = 8
					_RESULT = GetMemblockByte( SpriteCOL[ Sprite1 ], _Adress )
				EndIf
				If _dp = 16
					_RESULT = GetMemblockShort( SpriteCOL[ Sprite1 ], _Adress )
				EndIf
				If _dp = 32
					_RESULT = GetMemblockInt( SpriteCOL[ Sprite1 ], _Adress ) 
				EndIf
			EndIf
		EndIf
	EndIf
EndFunction _RESULT

Function GetSpritePixel( Spr As Integer, XScreen As Integer, YScreen As Integer )
	// Now we take the coordinate of the screen pixel To see If it's in the memblock image or outside.
	XPosInRot As Float = 0 : XPosInTor = XScreen - GetSpriteX( Spr )
	YPosInRot As Float = 0 : YPosInRot = YScreen - GetSpriteY( Spr )
	// Angle1 As Float = 0 : Angle1 = Deg2Rad( GetSpriteAngle( Spr ) )
	// Angle2 As Float = 0 : Angle2 = Deg2Rad( 0.0 - GetSpriteAngle( Spr ) )
	Angle1 As Float = 0 : Angle1 = GetSpriteAngle( Spr )
	Angle2 As Float = 0 : Angle2 = 0.0 - GetSpriteAngle( Spr )
	XPosInFinal As Float = 0 : XPosInFinal = ( ( Cos( Angle2 ) * XPosInRot ) - ( Sin( Angle2 ) * YPosInRot ) ) / ( GetSpriteScaleX( Spr ) / 100.0 )
	YPosInFinal As Float = 0 : YPosInFinal = ( ( Sin( Angle2 ) * XPosInRot ) + ( Cos( Angle2 ) * YPosInRot ) ) / ( GetSpriteScaleY( Spr ) / 100.0 )
	// Update to handle Mirror sprite
	If GetSpriteFlippedH( Spr ) = 1
		XPosInFinal = GetSpriteWidth( spr ) - XPosInFinal    
	EndIf
	// Update to handle flipped sprite
	If GetSpriteFlippedV( Spr ) = 1
		YPosInFinal = GetSpriteHeight( Spr ) - YPosInFinal
	EndIf
	// Update to handle offset sprite
	XPosInFinal = XPosInFinal + GetSpriteOffsetX( Spr )
	YPosInFinal = YPosInFinal + GetSpriteOffsetY( Spr )
	// Get the pixel color.
	COLOR As Integer : COLOR = GetPixelColor( Spr, XPosInFinal, YPosInFinal )
EndFunction COLOR

Function extGetSpriteCollisionAdvanced( M_Sprite1 As Integer, M_Sprite2 As Integer, COLMODE As Integer )
	_PIXEL As Integer = 0
	// Firstly, we'll calculate the 4 rounding spot positions : SPRITE#1
	XSize As Float : XSize = GetSpriteWidth( M_Sprite1 ) // * DBGetSpriteXScale( _Sprite1 ) / 100.0
	YSize As Float : YSize = GetSpriteHeight( M_Sprite1 ) // * DBGetSpriteYScale( _Sprite1 ) / 100.0
	// Angle1 As Float = Deg2Rad( GetSpriteAngle( M_Sprite1 ) )
	// Angle2 As Float = Deg2Rad( 0.0 - GetSpriteAngle( M_Sprite1 ) ) )
	Angle1 As Float : Angle1 = GetSpriteAngle( M_Sprite1 )
	Angle2 As Float : Angle2 = 0.0 - GetSpriteAngle( M_Sprite1 )
	// Top Left
	SpotA[ 1 ].XPos = 0 + GetSpriteX( M_Sprite1 )
	SpotA[ 1 ].YPos = 0 + GetSpriteY( M_Sprite1 )
	// Top Right
	SpotA[ 2 ].Xpos = ( XSize * Cos( Angle1 ) ) + GetSpriteX( M_Sprite1 )
	SpotA[ 2 ].Ypos = ( XSize * Sin( Angle1 ) ) + GetSpriteY( M_Sprite1 )
	// Bottom Left
	SpotA[ 3 ].XPos = ( YSize * Sin( Angle2 ) ) + GetSpriteX( M_Sprite1 )
	SpotA[ 3 ].YPos = ( YSize * Cos( Angle2 ) ) + GetSpriteY( M_Sprite1 )
	// Bottom Right
	SpotA[ 4 ].Xpos = SpotA[ 3 ].Xpos + ( SpotA[ 2 ].Xpos - SpotA[ 1 ].Xpos )
	SpotA[ 4 ].Ypos = SpotA[ 3 ].Ypos + ( SpotA[ 2 ].Ypos - SpotA[ 1 ].Ypos )

	// Secondly, we'll calculate the 4 rounding spot positions : SPRITE#2
	XSize = GetSpriteWidth( M_Sprite2 ) // * DBGetSpriteXScale( _Sprite2 ) / 100.0
	YSize = GetSpriteHeight( M_Sprite2 ) // * DBGetSpriteYScale( _Sprite2 ) / 100.0
	// Angle1 As Float = Deg2Rad( GetSpriteAngle( M_Sprite2 ) )
	// Angle2 As Float = Deg2Rad( 0.0 - GetSpriteAngle( M_Sprite2 ) )
	Angle1 = GetSpriteAngle( M_Sprite2 )
	Angle2 = 0.0 - GetSpriteAngle( M_Sprite2 )
	// Top Left
	SpotB[ 1 ].XPos = 0 + GetSpriteX( M_Sprite2 )
	SpotB[ 1 ].YPos = 0 + GetSpriteY( M_Sprite2 )
	// Top Right
	SpotB[ 2 ].Xpos = ( XSize * Cos( Angle1 ) ) + GetSpriteX( M_Sprite2 )
	SpotB[ 2 ].Ypos = ( XSize * Sin( Angle1 ) ) + GetSpriteY( M_Sprite2 )
	// Bottom Left
	SpotB[ 3 ].XPos = ( YSize * Sin( Angle2 ) ) + GetSpriteX( M_Sprite2 )
	SpotB[ 3 ].YPos = ( YSize * Cos( Angle2 ) ) + GetSpriteY( M_Sprite2 )
	// Bottom Right
	SpotB[ 4 ].Xpos = SpotB[ 3 ].Xpos + ( SpotB[ 2 ].Xpos - SpotB[ 1 ].Xpos )
	SpotB[ 4 ].Ypos = SpotB[ 3 ].Ypos + ( SpotB[ 2 ].Ypos - SpotB[ 1 ].Ypos )

	// We check now to know if a collision box exist between 2 boxes defined.
	XMax1 As Integer = -1 : YMax1 As Integer = -1 : XMax2 As Integer = -1 : YMax2 As Integer = -1
	XMin1 As Integer = 8000 : YMin1 As Integer = 8000 : XMin2 As Integer = 8000 : YMin2 As Integer = 8000
	For XLoop = 1 To 4
		If SpotA[ XLoop ].Xpos < XMin1 : XMin1 = SpotA[ XLoop ].Xpos : EndIf
		If SpotA[ XLoop ].Ypos < YMin1 : YMin1 = SpotA[ XLoop ].Ypos : EndIf
		If SpotA[ XLoop ].Xpos > XMax1 : XMax1 = SpotA[ XLoop ].Xpos : EndIf
		If SpotA[ XLoop ].Ypos > YMax1 : YMax1 = SpotA[ XLoop ].Ypos : EndIf
		If SpotB[ XLoop ].Xpos < XMin2 : XMin2 = SpotB[ XLoop ].Xpos : EndIf
		If SpotB[ XLoop ].Ypos < YMin2 : YMin2 = SpotB[ XLoop ].Ypos : EndIf
		If SpotB[ XLoop ].Xpos > XMax2 : XMax2 = SpotB[ XLoop ].Xpos : EndIf
		If SpotB[ XLoop ].Ypos > YMax2 : YMax2 = SpotB[ XLoop ].Ypos : EndIf
	Next XLoop
	XStart As Integer = -1 : YStart As Integer = -1 : XEnd As Integer = -1 : YEnd As Integer = -1
	If XMin1 < XMin2 : XStart = XMin2 : Else : XStart = XMin1 : EndIf
	If XMax1 < XMax2 : XEnd = XMax1 : Else : XEnd = XMax2 : EndIf
	If YMin1 < YMin2 : YStart = YMin2 : Else : YStart = YMin1 : EndIf
	If YMax1 < YMax2 : YEnd = YMax1 : Else : YEnd = YMax2 : EndIf
	If XMax1 > XMin2 And XMin1 < XMax2
		If YMax1 > YMin2 And YMin1 < YMax2
			// SI l'on a détecté qu'une collision était possible, on update les 2 sprites : images&memblocks
			// 4A / On Update l'image utilisée par le sprite 1.
			SpriteImage1 As Integer : SpriteImage1 = GetSpriteImageID( M_Sprite1 )
			If SpriteImage1 <> SpriteIMG[ M_Sprite1 ]
				SpriteIMG[ M_Sprite1 ] = SpriteImage1
				If SpriteCOL[ M_Sprite1 ] = 0
					SpriteCOL[ M_Sprite1 ] = CreateMemblockFromImage( SpriteImage1 )
					// SpritePTR[ M_Sprite1 ] = DBGetMemblockPtr( SpriteCOL[ M_Sprite1 ] )
				Else
					CreateMemblockFromImage( SpriteCOL[ M_Sprite1 ], SpriteImage1 )
					// SpritePTR[ M_Sprite1 ] = DBGetMemblockPtr( SpriteCOL[ M_Sprite1 ] )
				EndIf 
			EndIf
			// 4B / Meme manipulation pour le sprite 2.
			SpriteImage2 As Integer : SpriteImage2 = GetSpriteImageID( M_Sprite2 )
			If SpriteImage2 <> SpriteIMG[ M_Sprite2 ]
				SpriteIMG[ M_Sprite2 ] = SpriteImage2
				If SpriteCOL[ M_Sprite2 ] = 0
					SpriteCOL[ M_Sprite2 ] = CreateMemblockFromImage( SpriteImage2 )
					// SpritePTR( M_Sprite2 ) = DBGetMemblockPtr( SpriteCOL[ M_Sprite2 ] )
				Else
					CreateMemblockFromImage( SpriteCOL[ M_Sprite2 ], SpriteImage2 )
					// SpritePTR( M_Sprite2 ) = DBGetMemblockPtr( SpriteCOL[ M_Sprite2 ] )
				EndIf 
			EndIf
			// Maintenant on procède aux calculs de collisions ...
			YLoop = YStart : Repeat
			// For YLoop = YStart To YEnd
				XLoop = XStart : Repeat
				// For XLoop = XStart To XEnd
					Pixel1 = GetSpritePixel( M_Sprite1, XLoop, YLoop )
					Pixel2 = GetSpritePixel( M_Sprite2, XLoop, YLoop )
					// Pixel Collision detected ?
					If Pixel1 <> 0 And Pixel2 <> 0
						_PIXEL = _PIXEL + 1
						If COLMODE = 0 : XLoop = XEnd - 1 : YLoop = YEnd - 1 : EndIf
					EndIf
				// Next XLoop
				XLoop = XLoop + 1 : Until XLoop = XEnd
			// Next YLoop
			YLoop = YLoop + 1 : Until YLoop = YEnd
		EndIf
	EndIf
 EndFunction _PIXEL
//
Function extGetSpriteCollisionOPT( Sprite1 As Integer, Sprite2 As Integer, _MODE As Integer )
	_CHECK As Integer = 0
	If SPRInitialized = 1  
		// 1 / On saisit les coordonnées et dimensions pour vérifier si il y a collision des cadres.
		xp1 As Integer : xp1 = GetSpriteX( Sprite1 )
		yp1 As Integer : yp1 = GetSpriteY( Sprite1 )
		xs1 As Integer : xs1 = GetSpriteWidth( Sprite1 )
		ys1 As Integer : ys1 = GetSpriteHeight( Sprite1 )
		xp2 As Integer : xp2 = GetSpriteX( Sprite2 )
		yp2 As Integer : yp2 = GetSpriteY( Sprite2 )
		xs2 As Integer : xs2 = GetSpriteWidth( Sprite2 )
		ys2 As Integer : ys2 = GetSpriteHeight( Sprite2 )
		// 2 / On calcule si il y a collision des cadres.
		If xp2 > ( xp1 + xs1 ) Or xp2 < ( xp1 - xs2 ) : _CHECK = 0 : Else : _CHECK = 1 : EndIf
		If yp2 > ( yp1 + ys1 ) Or yp2 < ( yp1 - ys2 ) : _CHECK = 0 : EndIf
		// 3 / Si il y a collision des cadres, on calcule la collision au pixel près.
		If _CHECK = 1
			// 4A / On Update l'image utilisée par le sprite 1.
			SpriteImage1 As Integer : SpriteImage1 = GetSpriteImageID( Sprite1 )
			If SpriteImage1 <> SpriteIMG[ Sprite1 ]
				SpriteIMG[ Sprite1 ] = SpriteImage1
				If SpriteCOL[ Sprite1 ] = 0
					SpriteCOL[ Sprite1 ] = CreateMemblockFromImage( SpriteImage1 )
					// SpritePTR[ Sprite1 ] = DBGetMemblockPtr( SpriteCOL[ Sprite1 ] )
				Else
					CreateMemblockFromImage( SpriteCOL[ Sprite1 ], SpriteImage1 )
					// SpritePTR[ Sprite1 ] = DBGetMemblockPtr( SpriteCOL[ Sprite1 ] )
				EndIf 
			EndIf
			// 4B / Meme manipulation pour le sprite 2.
			SpriteImage2 As Integer : SpriteImage2 = GetSpriteImageID( Sprite2 )
			If SpriteImage2 <> SpriteIMG[ Sprite2 ]
				SpriteIMG[ Sprite2 ] = SpriteImage2
				If SpriteCOL[ Sprite2 ] = 0
					SpriteCOL[ Sprite2 ] = CreateMemblockFromImage( SpriteImage2 )
					// SpritePTR[ Sprite2 ] = DBGetMemblockPtr( SpriteCOL[ Sprite2 ] )
				Else
					CreateMemblockFromImage( SpriteCOL[ Sprite2 ], SpriteImage2 )
					// SpritePTR[ Sprite2 ] = DBGetMemblockPtr( SpriteCOL[ Sprite2 ] )
				EndIf 
			EndIf
			// 5 / Lecture des profondeurs de pixels des 2 images originales.
			// _dp1 As Integer = PeekL( SpritePTR( Sprite1 ) + 8 ) : _pixsize1As Integer = _dp1 / 8
			// _dp2 As Integer = PeekL( SpritePTR( Sprite2 ) + 8 ) : _pixsize2As Integer = _dp2 / 8
			_dp1 As Integer : _dp1 = GetMemblockInt( SpriteCOL[ Sprite1 ], 8 )
			_pixsize1 As Integer : _pixsize1 = _dp1 / 8
			_dp2 As Integer : _dp2 = GetMemblockInt( SpriteCOL[ Sprite2 ], 8 )
			_pixsize2 As Integer : _pixsize2 = _dp2 / 8
			// 5B / On lit les coordonnées et dimensions des parties communes des 2 sprites.
			If xp2 > xp1
				xstart1 = xp2 - xp1
				xstart2 = 0 
				xchecksize As Integer : xchecksize = xs1 - xstart1
			Else
				xstart1 = 0
				xstart2 = xp1 - xp2
				xchecksize = xs2 - xstart2
			EndIf
			If yp2 > yp1
				ystart1 = yp2 - yp1
				ystart2 = 0
				ychecksize = ys1 - ystart1
			Else
				ystart1 = 0
				ystart2 = yp1 - yp2
				ychecksize = ys2 - ystart2
			EndIf
			// 6 / Maintenant, on compare les pixels communs pour voir si il y a collision et, de combien de pixels.
			//  For yloop As Integer = 0 To ychecksize
			YLoop = 0 : Repeat
			// For xloopAs Integer = 0 To xchecksize
			XLoop = 0 : Repeat
			_pix1 As Integer = 0 : _pix2 As Integer = 0
			xpos As Integer : xpos = xloop + xstart1
			ypos As Integer : ypos = yloop + ystart1
			If xpos > -1 And xpos < xs1
				If ypos> -1 And ypos < ys1
					_Adress = 12 + ( ypos * xs1 * _pixsize1 ) + ( xpos * _pixsize1 )
					If _Adress > -1 And _Adress < ( GetMemblockSize( SpriteCOL[ Sprite1 ] ) - _pixsize1 )
						// If _dp1 = 16 : _pix1 = PeekW( SpritePTR( Sprite1 ) + _Adress ) : EndIf
						// If _dp1 = 32 : _pix1 = PeekL( SpritePTR( Sprite1 ) + _Adress ) : EndIf
						If _dp1 = 16 : _pix1 = GetMemblockShort( SpriteCOL[ Sprite1 ], _Adress ) : EndIf
						If _dp1 = 32 : _pix1 = GetMemblockInt( SpriteCOL[ Sprite1 ], _Adress ) : EndIf
					EndIf
				EndIf
			EndIf
			xpos = xloop + xstart2 : ypos = yloop + ystart2
			If xpos > -1 And xpos < xs2
				If ypos > -1 And ypos < ys2
					_Adress = 12 + ( ypos * xs2 * _pixsize2 ) + ( xpos * _pixsize2 )
					If _Adress > -1 And _Adress < ( GetMemblockSize( SpriteCOL[ Sprite2 ] ) - _pixsize2 )
						// If _dp2 = 16 : _pix2 = PeekW( SpritePTR( Sprite2 ) + _Adress ) : EndIf
						// If _dp2 = 32 : _pix2 = PeekL( SpritePTR( Sprite2 ) + _Adress ) : EndIf
						If _dp2 = 16 : _pix2 = GetMemblockShort( SpriteCOL[ Sprite2 ], _Adress ) : EndIf
						If _dp2 = 32 : _pix2 = GetMemblockInt( SpriteCOL[ Sprite2 ], _Adress ) : EndIf
					EndIf
				EndIf
			EndIf
			If _pix1 <> 0 And _pix2 <> 0 : _PIXEL=_PIXEL+1 : EndIf
			If _PIXEL > 0 And _MODE = 0
				xloop = xchecksize : yloop = ychecksize
			EndIf
			XLoop = XLoop + 1 : Until XLoop > xchecksize
//		Next xloop
			YLoop = YLoop + 1 : Until YLoop > ychecksize
//		Next yloop
		Else
			_PIXEL = 0
		EndIf
	EndIf
EndFunction _PIXEL
