// Dépréci, utilisa auparavant pour l'activation du plugin dans DarkBASIC Professional
Global B2DInitialized AS INTEGER = 1

// 
// PARAMETRES SYSTEME DE XWINDOW
Type XWindowSystem_Type
	Skin  AS String
	GadgetCount AS INTEGER
	CheckPriorities AS INTEGER
	CurrentWindow AS INTEGER
	OldWindow AS INTEGER
	SkinLoaded AS INTEGER
	AllowDragging AS INTEGER
	Dragging AS INTEGER
	DragWindow AS INTEGER
	XDragOrigin AS INTEGER
	YDragOrigin AS INTEGER
	XDragMouse AS INTEGER
	YDragMouse AS INTEGER
	AllowAlphaiser AS INTEGER
	CloseMode AS INTEGER
	OldMouseClick AS INTEGER
	CurrentGadget AS INTEGER
	MipMapMode AS INTEGER
	ChatGadget AS INTEGER
	ChatWindowGadget AS INTEGER
	ChatInText AS String
	ChatReading AS INTEGER
	ChatScanCode AS INTEGER
	LastKey AS INTEGER
 EndType
Global XWinSystem AS XWindowSystem_Type
Dim XWinFiles[ 16 ] As String

// LISTE DES FENETRES DU SYSTEM XWINDOW
Type XWindow_Type
	Exist AS INTEGER
	Format AS INTEGER
	Refresh AS INTEGER
	XSize AS INTEGER
	YSize AS INTEGER
	Linked AS INTEGER
	Moveable AS INTEGER
	Close AS INTEGER
	Borders AS INTEGER
	Bgd AS INTEGER
	XFont AS INTEGER
	ChildCount AS INTEGER
	Alpha AS INTEGER
	GadgetCount AS INTEGER
	XPos AS INTEGER
	YPos AS INTEGER
	Hidden AS INTEGER
	Title AS INTEGER
	Name AS String
	Hide AS INTEGER
	XDsize AS INTEGER
	YDSize AS INTEGER
	Parent AS INTEGER
	Alignment AS Integer
 EndType
Dim XWindow[16] AS XWindow_Type
Dim XWinDisplay[ 16 ]


Type CP_Type
	Window AS INTEGER
	Alignment AS INTEGER
EndType
Dim XWinChild[ 16, 16] AS CP_Type

// LISTE DE TOUT LES GADGETS EXISTANTS DANS LES FENETRES OU EN DEHORS
Type XWindowGadgets_Type
	Exist AS INTEGER
	mType AS INTEGER
	Window AS INTEGER
	XPos AS INTEGER
	YPos AS INTEGER
	Action AS INTEGER
	Image AS INTEGER
	XSize AS INTEGER
	YSize AS INTEGER
	Texte AS String
Endtype
Dim XGadget[ 256 ] AS XWindowGadgets_Type
Global InputText AS String
Global OutPutText As String


Type XFont_Type
	Exist AS INTEGER
	FontSize AS INTEGER
	FirstChar AS INTEGER
	mType AS INTEGER
EndType
Dim XFont[ 16] As XFont_Type

Type XFontSystem_Type
	XCursor AS INTEGER
	YCursor AS INTEGER
	CurrentFont AS INTEGER
	Bitmap AS INTEGER
	Opaque AS INTEGER
	AutoReturn AS INTEGER
EndType
Global XFontsys AS XFontSystem_Type
Global Temp AS INTEGER
Dim ChatText[ 32 ] AS String
Dim ChatChar[ 256 ] AS String

// Values used with Dynamic media handling.
Dim SkinImage[ 11 ] // Numéro des images utilisées pour le Skin des fenêtres chargé.
Dim SkinImageX[ 11 ] // Largeur de toutes les images du skin
Dim SkinImageY[ 11 ] // Hauteur de toutes les images du skin
Dim XWindowBitmap[ 16 ] // Numéros des bitmaps utilisés pour les fenêtres du GUI.
Dim XWindowImage[ 16 ] // Numéros des images utilisées pour les fenêtres du GUI.
Dim XWindowSprite[ 16 ] // Numéros des sprites utilisés pour les fenêtres du GUI.
Dim XFontImage[ 16, 255 ] // Numéros des images utilisées pour gérer les fontes bitmap.
