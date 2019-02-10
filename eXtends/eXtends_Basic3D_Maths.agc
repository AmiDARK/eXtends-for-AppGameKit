

Function B3D_GetPointsDistance( XP1 AS INTEGER, YP1 AS INTEGER, ZP1 AS INTEGER, XC1 AS INTEGER, YC1 AS INTEGER, ZC1 AS INTEGER )
	DIST AS FLOAT = 0.0
	If B3DInitialized = 1
		XDist AS FLOAT : XDist = XC1 - XP1
		YDist AS FLOAT : YDist = YC1 - YP1
		ZDist AS FLOAT : ZDist = ZC1 - ZP1
		Dist = Sqrt( ( XDist*XDist ) + ( YDist*YDist ) + ( ZDist*ZDist ) )
	EndIf
EndFunction Dist

Function B3D_GetDistanceFromCamera( ObjectNumber AS INTEGER, CameraNumber AS INTEGER )
	Dist AS FLOAT = 0.0
	If B3DInitialized = 1
		XCam AS FLOAT : XCam = GetCameraX( CameraNumber )
		YCam AS FLOAT : YCam = GetCameraY( CameraNumber )
		ZCam AS FLOAT : ZCam = GetCameraZ( CameraNumber )
		XPos AS FLOAT : XPos = GetObjectX( ObjectNumber )
		YPos AS FLOAT : YPos = GetObjectY( ObjectNumber )
		ZPos AS FLOAT : ZPos = GetObjectZ( ObjectNumber )
		XDist AS FLOAT : XDist = XCam - XPos
		YDist AS FLOAT : YDist = YCam - YPos
		ZDist AS FLOAT : ZDist = ZCam - ZPos
		Dist = Sqrt( ( XDist*XDist ) + ( YDist*YDist ) + ( ZDist*ZDist ) )
	EndIf
EndFunction Dist

Function B3D_GetObjectsDistance( Object1 AS INTEGER, Object2 AS INTEGER )
	Dist AS FLOAT = 0.0
	If B3DInitialized = 1
		XCam AS FLOAT : XCam = GetObjectX( Object2 )
		YCam AS FLOAT : YCam = GetObjectY( Object2 )
		ZCam AS FLOAT : ZCam = GetObjectZ( Object2 )
		XPos AS FLOAT : XPos = GetObjectX( Object1 )
		YPos AS FLOAT : YPos = GetObjectY( Object1 )
		ZPos AS FLOAT : ZPos = GetObjectZ( Object1 )
		XDist AS FLOAT : XDist = XCam - XPos
		YDist AS FLOAT : YDist = YCam - YPos
		ZDist AS FLOAT : ZDist = ZCam - ZPos
		Dist = Sqrt( ( XDist*XDist ) + ( YDist*YDist ) + ( ZDist*ZDist ) )
	EndIf
EndFunction Dist

Function B3D_GetPointDistancetoObject( ObjectNumber AS INTEGER, XP1 AS FLOAT, YP1 AS FLOAT, ZP1 AS FLOAT )
	Dist AS FLOAT = 0.0
	If B3DInitialized = 1
		XPos AS FLOAT : XPos = GetObjectX( ObjectNumber )
		YPos AS FLOAT : YPos = GetObjectY( ObjectNumber )
		ZPos AS FLOAT : ZPos = GetObjectZ( ObjectNumber )
		XDist = XPos - XP1
		YDist = YPos - YP1
		ZDist = ZPos - ZP1
		Dist = Sqrt( ( XDist*XDist ) + ( YDist*YDist ) + ( ZDist*ZDist ) )
	EndIf
EndFunction Dist
 
Function B3D_GetPointDistancetoCamera( CameraNumber AS INTEGER, XP1 AS FLOAT, YP1 AS FLOAt, ZP1 AS FLOAT )
	Dist AS FLOAT = 0.0
	If B3DInitialized = 1
		XCam AS FLOAT : XCam = GetCameraX( CameraNumber )
		YCam AS FLOAT : YCam = GetCameraY( CameraNumber )
		ZCam AS FLOAT : ZCam = GetCameraZ( CameraNumber )
		XDist = XCam - XP1
		YDist = YCam - YP1
		ZDist = ZCam - ZP1
		Dist = Sqrt( ( XDist*XDist ) + ( YDist*YDist ) + ( ZDist*ZDist ) )
	EndIf
EndFunction Dist
