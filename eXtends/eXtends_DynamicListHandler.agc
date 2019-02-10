

Global ReservedItems AS INTEGER // Give the number of user items.
Global ListLength AS INTEGER    // Give the position in ListItems
Global Dim ListItems[ 65536 ] AS INTEGER

Function InsertItemInList( Value AS INTEGER )
	// On calcule la position ou l'on doit insérer l'item.
	ActualPos = 0
	ListItems[ 0 ] = 1000000
	Repeat
		ActualPos = ActualPos + 1
		If ActualPos = 1
			Left = Value + 1
		Else
			Left = ListItems[ ActualPos - 1 ]
		EndIf
		Right = ListItems[ ActualPos ]
	Until ( Value < Left And Value > Right ) Or ActualPos > ( ListLength - 1 )
	// On décale les items suivants puis on insère le nouvel item.
	For XLoop = ListLength To ActualPos + 1 Step -1
		ListItems[ XLoop ] = ListItems[ XLoop -1 ]
	Next XLoop
	// On insère le nouvel item dans la liste.
	ListItems[ ActualPos ] = Value
	// Fin D'insertion.
EndFunction ActualPos

Function DLH_ClearList()
	ReservedItems = 0
	ListLength = 0
EndFunction

Function DLH_GetNextFreeItem()
	FreeItem = 0
	If ListLength = 0
		// Si la liste d'objets supprimés est vide, on incrémente le compteur d'objets réels et on l'utilise.
		ReservedItems = ReservedItems + 1
		FreeItem = ReservedItems
	Else
		// Si la liste d'objets supprimés n'est pas vide, on utilise la dernière valeur et on décrémente la dimension de la liste.
		FreeItem = ListItems[ ListLength ]
		ListLength = ListLength - 1
		Dim ListItems[ ListLength ]
	EndIf  
EndFunction FreeItem

Function DLH_FreeItem( ItemNumber AS INTEGER )
	If ItemNumber > 0
		If ItemNumber = ReservedItems
			// Si l'objet à enlever de la liste est le dernier du compteur réel, on décrémente simplement le compteur réel.
			ReservedItems = ReservedItems - 1
		Else
			// Si l'objet est inférieur au compteur réel, on incrément la liste et on positionne l'objet dedans.
			ListLength = ListLength + 1
			// Dim ListItems( ListLength )
			ListItems[ ListLength ] = 0
			TruePos  = InsertItemInList( ItemNumber )
		EndIf
	EndIf
 EndFunction 0

Function DLH_GetCount()
	ItemCount = ReservedItems - listLength
EndFunction ItemCount

Function DLH_GetItemCounter()
EndFunction ReservedItems
