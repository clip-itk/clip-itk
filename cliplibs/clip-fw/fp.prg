#xcommand DEFAULT <uVar1> := <uVal1> ;
	       [, <uVarN> := <uValN> ] => ;
		  <uVar1> := If( <uVar1> == nil, <uVal1>, <uVar1> ) ;;
		[ <uVarN> := If( <uVarN> == nil, <uValN>, <uVarN> ); ]


	DEFAULT lVbx := .f., nStyle := numOR( DS_MODALFRAME, WS_POPUP, WS_CAPTION, WS_SYSMENU )
	DEFAULT	nClrText := CLR_BLACK, nClrBack := GetSysColor( COLOR_BTNFACE ), ;
		lPixels := .f., nTop := 0, nLeft := 0, nBottom := 10, nRight := 40, ;
		nWidth := 0, nHeight := 0

