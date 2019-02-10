
Function FadeObject( ObjectID As Integer, FadeValue As Integer )
	SetObjectColor( ObjectID, FadeValue, FadeValue, FadeValue, 255 )
EndFunction


// SET OBJECT Object Number, Wire, Transparent, Cull, Filter, Light, Fog, Ambient
Function DBSetObject4( ObjectID As Integer, Wire As Integer, TranspMode As Integer, Culling As Integer, Filter As Integer, LightSensor As Integer, FogSensor As Integer, AmbientSensor As Integer )
	if ( GetObjectExists( ObjectID ) = 1 )
		SetObjectTransparency( ObjectID, TranspMode ) // -> SetObjectBlendMode()
		SetObjectCullMode( ObjectID, Culling )
		// SetObjectFilter( ObjectID, Filter ) does not exists
		SetObjectLightMode( ObjectID, LightSensor )
		SetObjectFogMode( ObjectID, FogSensor )
		// SetObjectAmbient( ObjectID, AmbientSensor ) does not exist
	Endif
EndFunction

Function DBDisableObjectZWrite( ObjectID As Integer )
	SetObjectDepthWrite( ObjectID, 0 )
EndFunction

Function DBGhostObjectOn( ObjectID )
	SetObjectTransparency( ObjectID, 3 )
	SetObjectBlendModes( ObjectID, 2, 3 )
	SetObjectalpha( ObjectID, 128 )
EndFunction

Function DBGhostObjectOff( ObjectID )
	SetObjectTransparency( ObjectID, 0 )
	SetObjectalpha( ObjectID, 255 )
EndFunction
