
Type printSystem
	prtSetup as Integer              // System setup done (=1) or not (=0)
	xCursor As Integer               // The current yCursor position
	yCursor As Integer               // The current xCursor position
	rgbR as Integer                  // The current rgbR color valua
	rgbG as Integer                  // The current rgbG color value
	rgbB as Integer                  // The current rgbB color value
	rgbA as Integer                  // The current rgbA color value
	rgbBb as Integer                 // The current full rgbA+rgbR+rgbG+rgbB color value
	idFont As Integer                // The current font in fntSystem[] array
	fontName As String               // The current font name
	fontSize As Integer              // The current font size
	tBold As Integer                 // The current font bold mode (active=1)
	tItalic As Integer               // The current font italic mode (active=1)
	tTransparent As Integer          // The current font transparency mode (active=1
	prtStack as String[]             // The output list
	autoPurge as Integer             // To remove unused font when not used during 1 rendered frame
	prtText As Integer               // Text utilisé pour écrire
 EndType
Global prtSystem as printSystem
Global prtRender as printSystem

prtSystem.fromJSON( '{ "prtSetup": 0, "xCursor": 0, "yCursor": 0, "rgbR": 255, "rgbG": 255, "rgbB": 255, "rgbA": 255}, "idFont": 0, "fontName": default, "fontSize": 32, "tItalic": 0, "tTransparent" : 0, "tBold": 0, "autoPurge" : 0 , "prtText" : 0}' )

type fontSystem
	fontName As String          // Font name
	used As Integer              // If font was used during render (for auto purge mode )
EndType
global fntSystem as fontSystem[ 0 ]

