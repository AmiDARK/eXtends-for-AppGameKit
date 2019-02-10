// **************************************************************************** Définition des variables du système Billboards de Basic3D

Global B3DInitialized AS Integer = 1
Dim BBList[ 16384 ] AS Integer
Dim BBYRot[ 16384 ] AS Integer
Global BBCount AS Integer = 0
Global BBCamera AS Integer = 0


//
// ************************************************************************************
// *                                                                                  *
// *                          DYNAMIC Virtual Lights COMMANDS                         *
// *                                                                                  *
// ************************************************************************************
//
Global L3DInitialized As Integer = 1
Type DLightStruct
	Locked As Integer
	VLight As Integer
	Active As Integer
	HaloObject As Integer
	Range As Integer
	Color As Integer
EndType
Global Dim DLight[ 7 ] As DLightStruct // For real lights from 0 to 7
//
Type CLightStruct
	VLight As Integer
	Distance As Float
EndType
Global Dim CLight[ 7 ] As CLightStruct
//
Type VLightStruct
	Active As Integer
	On As Integer
	Xpos As Float
	YPos As Float
	ZPos As Float
	Range As Float
	Red As Integer
	Green As Integer
	Blue As Integer
	Style As Integer
	Halo As Integer
	XTile As Integer
	ZTile As Integer
	lType As Integer
	ActualState As Float
EndType
Global Dim VLight[ 65536 ] As VLightStruct
Global VisibilityCam As Integer
Global VisibilityDistance As Integer
