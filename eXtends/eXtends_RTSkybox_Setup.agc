
// Data setup for Real Time Sky box system
Global RTSInitialized As Integer
Global UseShadowsOn As Integer
// Global ActualTime As Integer
// Global OldTime As Integer
// Global TimeFactor As Float
Global DefAutoZoom As Float
Global TextureQuality As Integer

Global Editor_MasterSkyBox As Integer
Global Editor_SkyBoxTexture As Integer

Type RealTimeSky_type
	Hour As Float
	Minutes As Float
	Secunds As Float
	Day As Integer
	Year As Integer
	YearDays As Integer
	TimeSpeed As Float
	NewTimer As Integer
	CloudPercent As Float
	SkyHalo As Integer
	Initialized As Integer
	RainDelay As Integer
	RainCycle As Integer
	RainCount As Float
	WindXSpeed As Float
	WindYSpeed As Float
	CloudPersistence As Float
	MistPercent As Float
	SkyBoxfile As String
	SkyBoxDrawer As String
	SkyFile As String
	CloudFile As String
	StarsFile As String
	SunFile As String
	MoonFile As String
	GetUpHalo As String
	GetDownHalo As String
	Aurore1 As String
	Aurore2 As String
	FarAway As String
	Ground As String
	AmbientRed As Integer
	AmbientGreen As Integer
	AmbientBlue As Integer
	FogRed As Integer
	FogGreen As Integer
	FogBlue As Integer
	FogDistance As Float
	FogControl As Integer
	MinAmbientRed As Integer
	MinAmbientGreen As Integer
	MinAmbientBlue As Integer
	MinFogRed As Integer
	MinFogGreen As Integer
	MinFogBlue As Integer
	XView As Float
	YView As Float
	ZView As Float
	CloudsXShift As Float
	CloudsYShift As Float
EndType
Global RTSky As RealTimeSky_Type

Global Dim RTSObjects[ 11 ] // Objets chargés pour le système de Skybox.

Global Dim RTSTextures[ 11 ] // Images utilisées pour les textures du système de skyboxes.

Type OldCam_Type
	XPos As Float
	YPos As Float
	ZPos As Float
	XAngle As Float
	YAngle As Float
	ZAngle As Float
	XShift As Float
	YShift As Float
	ZShift As Float
EndType
Global CamMemory As OldCam_Type
