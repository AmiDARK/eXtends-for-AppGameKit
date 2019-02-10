

Function xtCreateBitmapEx( Width as Integer, Height As Integer, MipmapMode As Integer )
	bmpID As Integer =  -1
	For bLoop = 0 to 15 Step 1
		if BitmapID[ bLoop ] = 0
			bmpID = bLoop
		endif
	next bLoop
	if bmpID > -1
			Message( "Image Sizes 2 : " + Str( Width ) + " / " + Str( Height ) )
		BitmapID[ bmpID ] = CreateRenderImage( Width, Height, 0, 0 )
	Endif
EndFunction bmpID

Function xtCreateBitmap( Width as Integer, Height As Integer )
  NewBitmap = xtCreateBitmapEx( Width, Height, 0 )
  EndFunction NewBitmap
 
Function xtDeleteBitmap( bmpID as Integer )
	if bmpID > 0 and bmpID < 16
		if BitmapID[ bmpID ] > 0
			DeleteImage( BitmapID[ bmpID ] )
			BitmapID[ bmpID ] = 0
		Endif
	endif
	if CurrentBitmap = bmpID
		xtSetCurrentBitmap( 0 )
	Endif
EndFunction

Function xtSetCurrentBitmap( bmpID as Integer )
	if bmpID > -1 and bmpID < 16
		if bmpID = 0
			SetRenderToScreen()
		Else
			if BitmapID[ bmpID ] > 0
				if GetImageExists( BitmapID[ bmpID ] ) = 1
					SetRenderToImage( BitmapID[ bmpID ], 0 )
					CurrentBitmap = bmpID
				Else
					SetRenderToScreen()
				Endif
			else
				SetRenderToScreen()
			Endif
		Endif

	Endif
EndFunction

Function xtGetBitmapExists( bmpID As Integer )
	success As Integer = 0
	if bmpID > 0 and bmpID < 16
		if BitmapID[ bmpID ] > 0
			if GetImageExists( BitmapID[ bmpID ] ) > 0 then success = 1
		Endif
	endif
EndFunction success

Function xtGetBitmapWidth( bmpID As Integer )
	feedback As Integer = 0
	if bmpID > 0 and bmpID < 16
		if BitmapID[ bmpID ] > 0
			if GetImageExists( BitmapID[ bmpID ] ) > 0 then feedback = getImageWidth( BitmapID[ bmpID ] )
		Endif
	else
		if bmpID = 0 then feedback = getVirtualWidth()
	endif
EndFunction feedback

Function xtGetBitmapHeight( bmpID As Integer )
	feedback As Integer = 0
	if bmpID > 0 and bmpID < 16
		if BitmapID[ bmpID ] > 0
			if GetImageExists( BitmapID[ bmpID ] ) > 0 then feedback = getImageHeight( BitmapID[ bmpID ] )
		Endif
	else
		if bmpID = 0 then feedback = getVirtualHeight()
	endif
EndFunction feedback
	
Function xtLoadBitmapEx( FileImage As String, mipMapMode as Integer )
	newBMP As Integer = -1
	if getFileExists( FileImage ) = 1
		trueImg As Integer : trueImg = LoadImage( FileImage )
		if ( trueImg > 0 )
			Message( "Image Sizes : " + Str( GetImageWidth( trueImg ) ) + " / " + Str( GetImageHeight( trueImg ) ) )
			newBMP = xtCreateBitmapEx( GetImageWidth( trueImg ), GetImageHeight( trueImg ), mipMapMode )
			xtSetCurrentBitmap( newBMP )
			PasteImage( trueImg, 0, 0 )
			DeleteImage( trueImg )
			xtSetCurrentBitmap( 0 )
		Endif
	Endif
EndFunction newBMP

Function xtLoadBitmap( FileImage As String )
	newBMP = xtLoadBitmapEx( FileImage, 0 )
EndFunction newBMP
