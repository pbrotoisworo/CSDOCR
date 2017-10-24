#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#InstallKeybdHook
;#IfWinActive, Cook`, Serve`, Delicious!
; To Add: Initial IF statements to go to individual food labels. Add color pixel value for 2nd step pasta cooking process.
; double check verification process for pasta
;Check Sushi THEMIX and check errors

;========START UP COMMANDS==============

Startup:

; Always run script as admin
if not A_IsAdmin
	{
	   Run *RunAs "%A_ScriptFullPath%"  ; Requires v1.0.92.01+
	   ExitApp
	}

IniRead, OCR_exe, settings.ini, Settings, OCR_exe	;Check saved states in the ini file
IniRead, Dishwasher, settings.ini, Settings, Dishwasher
IniRead, Garbage, settings.ini, Settings, Garbage
IniRead, user_Hotkey, settings.ini, Settings, user_Hotkey
IniRead, user_Speed, settings.ini, Settings, user_Speed

	If (Dishwasher = 1)	;Check the save state of the difficulty level
		Dishwasher = Checked	;If difficulty was checked before. Re-load variable as Checked
	else if (Dishwasher = 0)
		Dishwasher = 
	
	If (Garbage = 1)	;Check the save state of the garbage upgrade
		Garbage = Checked	;If garbage was checked before. Re-load variable as Checked
	else if (Garbage = 0)
		Garbage = 

;=====GUI MENU=====


Menu, SubMenuFile, Add, &About, AboutMenu
Menu, SubMenuFile, Icon, &About, shell32.dll, 24
Menu, SubMenuFile, Add, End and Close Script`tAlt+F4, Guiclose
Menu, SubMenuFile, Icon, End and Close Script`tAlt+F4, shell32.dll, 28

Menu, FileMenu, Add, &File, :SubMenuFile
Gui Menu, FileMenu

Gui Font, Bold Underline, Verdana
Gui Add, Text, x8 y8 w144 h23 +0x200, Macro Settings
Gui Font
Gui Add, CheckBox, %Dishwasher% x16 y40 w150 h23 vuser_Dishwasher, Dishwasher Upgrade
Gui Add, CheckBox, %Garbage% x16 y62 w120 h23 vuser_Garbage, Garbage Upgrade
Gui Add, Text, x16 y93 w120 h20 +0x200, Capture2Text Executable File:
Gui Add, Edit, x16 y116 w198 h20 vOCR_exe, %OCR_exe%
Gui Add, Button, x216 y116 w80 h20, Browse...
Gui Add, Text, x55 y150 w150 h20 +0x200, Choose Hotkey to run macro
Gui Add, Text, x55 y180 w150 h20 +0x200, Hotkey delay (milliseconds)
Gui Add, Hotkey, x16 y150 w30 h20 vuser_Hotkey, %user_Hotkey%
Gui Add, Edit, x16 y180 w30 h20 vuser_Speed Limit4 Number, %user_Speed%
Gui Add, Text, x17 y220 w300 h15 +0x200, Check Readme file before running the program!
Gui Add, Text, x17 y235 w300 h15 +0x200, CSD OCR is a script that uses Optical Character
Gui Add, Text, x17 y250 w300 h15 +0x200, Recognition (OCR) software to run macros.
Gui Add, Button, guser_Close x105 y280 w100 h35, Save Settings and Run Script
Gui Add, StatusBar,, CSD OCR 1.0
Gui Add, Picture, x160 y16 w127 h74, CSD_Logo.png

Gui Show, w310 h350, CSD OCR Configuration

If Dishwasher = Checked	;Reconvert difficulty variable back to binary
	user_Dishwasher = 1
else if (Dishwasher = "")
	user_Dishwasher = 0

If Garbage = Checked	;Reconvert difficulty variable back to binary
	user_Garbage = 1
else if (Garbage = "")
	user_Garbage = 0

Return

AboutMenu:
	{
	Msgbox, 4096, About CSD OCR, CSD OCR Version 1.0`nCreated by Esparko`nhttps://github.com/Esparko/
	Return
	}

ButtonBrowse...:
	{
	FileSelectFile, user_OCR_exe, 3, Select file,
	If (user_OCR_exe = "")
		{
		OCR_exe = %OCR_exe%
		Return
		}
	else
	{
	IniWrite, %user_OCR_exe%, settings.ini, Settings, OCR_exe
	IniRead, OCR_exe, settings.ini, Settings, OCR_exe
	Msgbox, 4096, CSD OCR ,New path is %OCR_exe%
	GuiControl,,OCR_exe, %OCR_exe%
	}
	}
	Return

CloseMenu:

	Gui, Submit, NoHide ;this command submits the guis' datas' state
	If user_Dishwasher = 1
		{
		IniWrite, 1, settings.ini, Settings, Dishwasher
		IniWrite, %user_Hotkey%, settings.ini, Settings, user_Hotkey
		Gui Destroy
		Return
		}
	If user_Dishwasher = 0
		{
		;Msgbox user_Difficulty variable is %user_Difficulty%
		;Msgbox DEBUG: Line 104: Close button clicked
		IniWrite, 0, settings.ini, Settings, Dishwasher
		IniWrite, %user_Hotkey%, settings.ini, Settings, user_Hotkey
		;Msgbox Difficulty variable is %user_Difficulty%
		}
	
	IfWinNotExist, Cook`, Serve`, Delicious!
		{
		Msgbox, 4096, CSD OCR, Error! Please start Cook, Serve, Delicious! before running script.
		Return
		}
	IfWinExist, Cook`, Serve`, Delicious!
		{
		WinMinimize, CSD OCR Configuration
		;Gui Destroy
		Return
		}
	
user_Close:
	Gui, Submit, NoHide ;this command submits the GUIs' datas' state
	If user_Garbage = 1
		IniWrite, 1, settings.ini, Settings, Garbage
	
	else if user_Garbage = 0
		IniWrite, 0, settings.ini, Settings, Garbage
	
	If user_Dishwasher = 1
		{
		;Msgbox DEBUG: User hotkey is %user_Hotkey%
		IniWrite, 1, settings.ini, Settings, Dishwasher
		;Gui Destroy
		}
	else if user_Dishwasher = 0
		{
		;Msgbox DEBUG: Line 133: user_Difficulty variable is %user_Dishwasher%
		IniWrite, 0, settings.ini, Settings, Dishwasher
		}
	
	IfWinNotExist, Cook`, Serve`, Delicious!
		{
		IniWrite, %user_Hotkey%, settings.ini, Settings, user_Hotkey
		IniWrite, %user_Speed%, settings.ini, Settings, user_Speed
		Msgbox, 4096, CSD OCR, Error! Please start Cook, Serve, Delicious! before running script.
		Return
		}
	IfWinExist, Cook`, Serve`, Delicious!
		{
		WinMinimize, CSD OCR Configuration
		;Msgbox DEBUG: Close button clicked
		IniWrite, %user_Hotkey%, settings.ini, Settings, user_Hotkey
		IniWrite, %user_Speed%, settings.ini, Settings, user_Speed
		;Msgbox DEBUG: Line 148: user_Dishwasher variable is %user_Difficulty%
		;Gui Destroy
		Goto, CSDConfigure
		Return
		}
	Return
		
	
MenuHandler:
Return

GuiEscape:
GuiClose:
	Process, Close, Capture2Text.exe
	ExitApp

	
;================INITIAL SET UP========================
;The macro works with relative pixel location so the window needs to be a specific size.
;If the window is not 1302x776 it will be resized.
;The script will also check if Capture2Text is currently running as it is required.

;ESC::	;Debugging Purposes
;	ExitApp


CSDConfigure:

Hotkey, %user_Hotkey%, Macro	;Declaring saved custom user input as a hotkey and will trigger 'Macro' label

IfWinExist, Cook`, Serve`, Delicious!	;Get current state of CSD window
	{
		WinActivate, Cook`, Serve`, Delicious!
		WinGetPos, X, Y, Width, Height, Cook`, Serve`, Delicious!
	}

If (Width != 1302 or Height != 776)	;Check resolution of CSD window
	{
	Msgbox, 4096, CSD OCR, Cook, Serve, Delicious! needs to be in 1302x776 for this script to work. This script will now resize the window automatically. If the window size is changed after this re-run script using the config window.
	WinMove, Cook`, Serve`, Delicious!,,,,1302, 776
	WinMove, Cook`, Serve`, Delicious!, 199, 110
	;WinMove, Cook`, Serve`, Delicious!,, (A_ScreenWidth/2)-(Width/2), (A_ScreenHeight/2)-(Height/2)
	}

Process, Exist, Capture2Text.exe ; check to see if Capture2Text.exe is running
	{
		If ! errorLevel	;Check for existance of exe. If NOT the same as errorLevel 0 (successful) then run this expression
			{
			IfExist, %OCR_exe%
				{
				Run *RunAs %OCR_exe%
				Msgbox, 4096, CSD OCR, Capture2Text.exe not running! Enabling now...
				Sleep 1500
				MouseMove, 813, 18, 2	;Top right corner of recipe title
				Send, +{BS}
				MouseMove, 1285, 86, 2
				MouseClick left
				Sleep 1500
				IfWinExist, Capture2Text - OCR Text
					WinMove, 1557, 829
				}
			IfNotExist, %OCR_exe%
				{
				Msgbox, 4096, CSD OCR, Capture2Text not found! Please locate Capture2Text.exe
				FileSelectFile, user_OCR_exe, 3, Select file,
				If (user_OCR_exe = "")
					{
					OCR_exe = %OCR_exe%
					Gosub, Startup
					Return
					}
				IniWrite, %user_OCR_exe%, settings.ini, Settings, OCR_exe
				IniRead, OCR_exe, settings.ini, Settings, OCR_exe
				Msgbox, 4096, CSD OCR, New path is %OCR_exe%
				Run *RunAs %OCR_exe%
				}
			Return
			}	
		else
			{
			Return
			}
	}
Return



;================IMAGE OCR ACQUISITION========================

Macro:
	
; Command to run OCR process
	
	MouseMove, 288, 643, 2	;Bottom Left Corner of recipe title
	
	Send, +{BS}	;Command to start OCR process
		MouseMove, 880, 606, 2	;Top right corner of recipe title
		MouseClick left	;Finalize selection for OCR
		ClipWait,2 
	IfWinNotExist, Capture2Text - OCR Text
		Sleep 1000
		
	WinWait, Capture2Text - OCR Text	;Wait for OCR window to pop-up automatically
	
	IfWinExist, Cook`, Serve`, Delicious!
		WinActivate		

	OCR = %clipboard% ;Raw OCR text
	;Msgbox DEBUG: Raw Clipboard contents is %OCR%	;TEST OCR OUTPUT
	StringReplace, OCR, OCR, %A_Space%,,All	;Remove spaces from string 
	StringTrimLeft, OCR, OCR, 1		;Trim One Character from left
	StringTrimRight, OCR, OCR, 1	;Trim one character from right
	
	;Msgbox DEBUG: Cleaned Clipboard contents is %OCR%	;Msgbox to help debug OCR errors

;================FOOD TYPE LIST================
;This area is the first set of if commands that search for the food type labels
;to increase efficiency of the program

SetKeyDelay, %user_Speed%
WinActivate, Cook`, Serve`, Delicious!
CoordMode, Mouse, Window
PixelGetColor, color_FoodType, 507, 347
;Msgbox DEBUG: Line 288: Color value is %color_FoodType%

If color_FoodType = 0x13121A
	{
	;Msgbox StackedEnchiladas Detected
	Goto StackedEnchiladas
	}

If color_FoodType = 0x67675B
	{
	;Msgbox Kabob detected
	Goto Kabob
	}

If color_FoodType = 0xC6DBDC
	Goto Pizza

If color_FoodType = 0x777A80
	Goto Coffee

If color_FoodType = 0x12121A
	Goto BananaFoster

If color_FoodType = 0x0E36A6
	Goto Steak

If color_FoodType = 0x13151A
	Goto Sushi

If color_FoodType = 0xB9B1B4
	Goto IceCream

If color_FoodType = 0x8A8384
	Goto Soups

If color_FoodType = 0x444B4F
	Goto Soda

If color_FoodType = 0x969596
	Goto ChickenBreast

If color_FoodType = 0xE5B696
	Goto Lasagna

If color_FoodType = 0x6A6962
	Goto FriedRice

If color_FoodType = 0x1345B2
	Goto CornDog

If color_FoodType = 0x198C4E
	Goto Salads

If color_FoodType = 0x7C7FC3
	Goto Pretzels

If color_FoodType = 0x0F121C
	Goto Beer

If color_FoodType = 0x85D2FA	;2nd stage of pasta prep
	Goto Pasta
	
If color_FoodType = 0x589ABA
	Goto BakedPotato

If color_FoodType = 0x1835B6
	Goto BreakfastSandwich

If color_FoodType = 0x6CD3EC
	Goto Lobster

If color_FoodType = 0x746D6E ;stove
	{
	PixelGetColor, color_FoodType, 1051, 179
	;Msgbox hotkey color is %color_FoodType%
	If color_FoodType = 0x3E5280
		{
		;Msgbox hotkey color is %color_FoodType%. LOBSTER STOVE
		Goto Lobster
		Return
		}
	If color_FoodType = 0x65A1DB
		{
		;Msgbox hotkey color is %color_FoodType%. PASTA STOVE
		Goto Pasta
		Return
		}		
	
	Return
	}

If color_FoodType = 0x464747
	{
	PixelGetColor, color_FoodType, 1051, 179
	;Msgbox hotkey color is %color_FoodType%
	If color_FoodType = 0x4454CD
		{
		;Msgbox hotkey color is %color_FoodType%. BURGER GRILL
		Goto Burgers
		}
	If color_FoodType = 0x575B71
		{
		;Msgbox hotkey color is %color_FoodType%. NACHO GRILL
		Goto Nachos
		}
	}

If color_FoodType = 0x464747
	Goto Grill
	
If (OCR = "DeliciousLiteSopapillas" or OCR = "DeliciousSopapillas")
	Goto Sopapillas
	
If (OCR = "WorkTicket(Clean)" or OCR = "WorkTicket(Dishes)" or OCR = "WorkTicket(Rodents)" or OCR = "WorkTicket(Trash)")
	Goto Chores

If (OCR = "LiteFastFries" or OCR = "FastFries" or OCR = "ThickCutLiteFries" or OCR = "ThickCutFries")
	Goto FrenchFries

If (OCR = "LeCheapValu-Wlne" or OCR = "LeCheapValu-Wine" or OCR = "CasuMarzu" or OCR = "SerpentBeard" or OCR = "Elk" or OCR = "DeckardVineyards")
	Goto Wine

If (OCR = "HashPatties" or OCR = "LiteHashPatties")
	Goto HashBrowns

If (OCR = "GreasyFriedChicken" or OCR = "GreasvFriedChicken" or OCR = "GoldenFriedChicken")
	Goto FriedChicken
	

;================LASAGANA================
Lasagna:

	If (OCR = "ClassicItalianLasagna" or OCR = "ClassicItalianLasaqna" or OCR = "ClassicltalianLasagna" or OCR = "ClassicltalianLasaqna" or OCR = "ClassicitalianLasaqna")
		{
		Send, pscrpscrpscr{enter}
		Return
		}
	
	If (OCR = "MeatyRomeLasagna" or OCR = "MeatyRomeLasagqna" or OCR = "MeatyRomeLasaqna")
		{
		Send, psmcrpsmcrpscr{enter}
		Return
		}
	
	If (OCR = "VegetableLasagna" or OCR = "VegetableLasaqna")
		{
		Send, psvcrpsvcrpscr{enter}
		Return
		}
		
	If (OCR = "StuffedPizaLasagna" or OCR = "StuffedPizaLasaqna")
		{
		Send, psmcrpsvcrpscr{enter}
		Return
		}

;================FRIED RICE================
FriedRice:

	If (OCR = "ClassicFriedRice")
		{
		Send, fpceo{enter}
		Return
		}
	
	If (OCR = "LiteFriedRice")
		{
		Send, fpc{enter}
		Return
		}
	
	If (OCR = "SourFriedRice")
		{
		Send, feo{enter}
		Return
		}
		
	If (OCR = "SweetFriedRice")
		{
		Send, fpce{enter}
		Return
		}
	
	If (OCR = "ClassicWhiteRice")
		{
		Send, wpceo{enter}
		Return
		}
	
	If (OCR = "YellowWhiteRice")
		{
		Send, wen{enter}
		Return
		}
	
	If (OCR = "CrunchyWhiteRice")
		{
		Send, weon{enter}
		Return
		}
	
	If (OCR = "SpecialWhiteRice")
		{
		Send, wpceon{enter}
		Return
		}
	
	If (OCR = "ClassicBrownRice")
		{
		Send, bpceo{enter}
		Return
		}
	
	If (OCR = "DeluxeBrownRice")
		{
		Send, bpceonr{enter}
		Return
		}
	
	If (OCR = "DelightWhiteRice")
		{
		Send, wpceonr{enter}
		Return
		}
	
	If (OCR = "LiteRice")
		{
		Send, wnr{enter}
		Return
		}
	
	If (OCR = "BrownSourRice")
		{
		Send, beo{enter}
		Return
		}
	
	If (OCR = "OrientalShrimpRice")
		{
		Send, fpcers{enter}
		Return
		}
	
	If (OCR = "OrientalChickenRice")
		{
		Send, fpcerk{enter}
		Return
		}
	
	If (OCR = "OrientalBeefRice")
		{
		Send, fpcem{enter}
		Return
		}
	
	If (OCR = "GourmetRice")
		{
		Send, fpceonrmk{enter}
		Return
		}
	
	If (OCR = "EmperorFriedRice")
		{
		Send, fpceonrsmk{enter}
		Return
		}
	
	If (OCR = "EmperorWhiteRice")
		{
		Send, wpceonrsmk{enter}
		Return
		}
	
	If (OCR = "EmperorBrownRice")
		{
		Send, bpceonrsmk{enter}
		Return
		}
		
;================KABOB================
Kabob:

	If (OCR = "ClassicKabob")
		{
		Send, tmtgkrgr{enter}
		Return
		}
	
	If (OCR = "MeatyKabob")
		{
		Send, mtmkmkgk{enter}
		Return
		}
	
	If (OCR = "PepperKabob")
		{
		Send, grtgrmgr{enter}
		Return
		}
	
	If (OCR = "RedKabob")
		{
		Send, trmtrtgr{enter}
		Return
		}
	
	If (OCR = "Kabobber")
		{
		Send, tmkgrtkm{enter}
		Return
		}
	
	If (OCR = "ChickenKabob")
		{
		Send, ktktkgkr{enter}
		Return
		}
	
	If (OCR = "OnionKabob")
		{
		Send, otokogor{enter}
		Return
		}
	
	If (OCR = "TowerKabob")
		{
		Send, mgrokgro{enter}
		Return
		}
	
	If (OCR = "TangyKabob" or OCR = "TangvKabob" or OCR = "TanqvKabob")
		{
		Send, otogorgr{enter}
		Return
		}
	
	If (OCR = "JuicyKabob" or OCR = "JuicvKabob")
		{
		Send, mokmokgo{enter}
		Return
		}
	
	If (OCR = "HawaiianKabob")
		{
		Send, optopkmk{enter}
		Return
		}
	
	If (OCR = "PineappleKabob")
		{
		Send, ptpmpkpo{enter}
		Return
		}

	If (OCR = "Kabomber")
		{
		Send, pmpkmorg{enter}
		Return
		}
	
	If (OCR = "KabobSampler")
		{
		Send, ptpmkgro{enter}
		Return
		}
	
	If (OCR = "SquashKabob")
		{
		Send, sgsrpsop{enter}
		Return
		}
	
	If (OCR = "YellowKabob")
		{
		Send, spsmspkp{enter}
		Return
		}
	
	If (OCR = "CrazyKabob" or OCR = "CrazvKabob")
		{
		Send, gosgoskt{enter}
		Return
		}
	
	If (OCR = "KabobPlatter")
		{
		Send, ktkgrops{enter}
		Return
		}
	
	If (OCR = "VeggieKabob")
		{
		Send, ozuozutg{enter}
		Return
		}
	
	If (OCR = "AmericanKabob")
		{
		Send, susumkro{enter}
		Return
		}
	
	If (OCR = "GreenKabob")
		{
		Send, kgzukgzu{enter}
		Return
		}
	
	If (OCR = "OdessaKabob")
		{
		Send, mszmzmzu{enter}
		Return
		}
	
	If (OCR = "KabobSpecial")
		{
		Send, tgputgpu{enter}
		Return
		}
	
	If (OCR = "TomatoKabob")
		{
		Send, tmtuktzu{enter}
		Return
		}
		
;================PANCAKE================

	If (OCR = "JuniorClassic")
		{
		Send, pmb{enter}
		Return
		}

	If (OCR = "TripleMaple")
		{
		Send, pppmb{enter}
		Return
		}
	
	If (OCR = "DualMapleStack")
		{
		Send, ppmb{enter}
		Return
		}
		
	If (OCR = "JuniorRedberry" or OCR = "JuniorRedberrv")
		{
		Send, psb{enter}
		Return
		}
	
	If (OCR = "TripleRedStack")
		{
		Send, pppsb{enter}
		Return
		}
	
	If (OCR = "DoubleStrawberry" or OCR = "DoubleStrawberrv")
		{
		Send, ppsb{enter}
		Return
		}
	
	If (OCR = "DrySingle" or OCR = "DrvSingle" or OCR = "DrvSingale" or OCR = "DrySinqle" or OCR = "DrySingale" or OCR = "DrvSinqle")
		{
		Send, pb{enter}
		Return
		}
	
	If (OCR = "TripleDry" or OCR = "TripleDrv")
		{
		Send, pppb{enter}
		Return
		}
	
	If (OCR = "DoubleDesert")
		{
		Send, ppb{enter}
		Return
		}
	
	If (OCR = "JuniorBlueberry" or OCR = "JuniorBlueberrv")
		{
		Send, plb{enter}
		Return
		}
	
	If (OCR = "BlueDoubleStack")
		{
		Send, pplb{enter}
		Return
		}
	
	If (OCR = "TripleBerryBlue" or OCR = "TripleBerrvBlue")
		{
		Send, ppplb{enter}
		Return
		}
		
	If (OCR = "TheLonelyPancake" or OCR = "TheLonelvPancake")
		{
		Send, p{enter}
		Return
		}
		
	If (OCR = "JuniorPecan")
		{
		Send, peb{enter}
		Return
		}
		
	If (OCR = "DoublePecanStack")
		{
		Send, ppeb{enter}
		Return
		}
	
	If (OCR = "TriplePecanStack")
		{
		Send, pppeb{enter}
		Return
		}
		
	If (OCR = "LiteDoublePecan")
		{
		Send, ppe{enter}
		Return
		}
	
	If (OCR = "LiteMapleClassic")
		{
		Send, ppm{enter}
		Return
		}
		
;================BEER================
Beer:

	If (OCR = "TheRichBrewsky" or OCR = "TheRichBrewskv")
		{
		Send, {down Down}
		sleep 1300
		Send, {down Up}{enter}
		}
	
	If (OCR = "TheBrewsky" or OCR = "TheBrewskv")
		{
		Send, {down Down}
		sleep 1300
		Send, {down Up}{enter}
		}

;================CHICKEN BREAST=================
ChickenBreast:
	
	If (OCR = "RichChickenBreast")	;Level 4
		{
		Send, tttttts{enter}
		Return
		}
	
	If (OCR = "EdibleChickenBreast")	; Level 1 breast
		{
		Send, tttttts{enter}
		Return
		}
	
	If (OCR = "PlumpChickenBreast")
		{
		Send, tttttts{enter}
		Return
		}
	
	If (OCR = "ClassicChickenBreast")
		{
		Send, tttttts{enter}
		Return
		}

;================SODA FOUNTAIN=================
Soda:

	If (OCR = "SmallCola")
		{
		Send, {down}i{enter}
		Return
		}
	
	If (OCR = "SmallGrape")
		{
		Send, {right 2}{down}i{enter}
		Return
		}
	
	If (OCR = "SmallDiet")
		{
		Send, {right 4}{down}i{enter}
		Return
		}
	
	If (OCR = "SmallCola(noice)")
		{
		Send, {down}{enter}
		Return
		}
	
	If (OCR = "SmallWater")
		{
		Send, {right 3}{down}i{enter}
		Return
		}
	
	If (OCR = "SmallTea")
		{
		Send, {right}{down}i{enter}
		Return
		}
	
	If (OCR = "MediumCola")
		{
		Send, {up}{down}i{enter}
		Return
		}
	
	If (OCR = "MediumGrape")
		{
		Send, {up}{right 2}{down}i{enter}
		Return
		}
	
	If (OCR = "MediumDiet")
		{
		Send, {up}{right 4}{down}i{enter}
		Return
		}
	
	If (OCR = "MediumCola(noice)")
		{
		Send, {up}{down}{enter}
		Return
		}
	
	If (OCR = "MediumWater")
		{
		Send, {up}{right 3}{down}i{enter}
		Return
		}
	
	If (OCR = "MediumTea")
		{
		Send, {up}{right}{down}i{enter}
		Return
		}
	
	If (OCR = "LargeCola" or OCR = "LameCola")
		{
		Send, {up 2}{down}i{enter}
		Return
		}

	If (OCR = "LargeColaw/FlavorBlast" or OCR = "LameColaw/FlavorBlast")
		{
		Send, {up 2}{down}if{enter}
		Return
		}
	
	If (OCR = "LargeGrape" or OCR = "LameGrape")
		{
		Send, {up 2}{right 2}{down}i{enter}
		Return
		}

	If (OCR = "LargeGrapew/FlavorBlast" or OCR = "LameGrapew/FlavorBlast")
		{
		Send, {up 2}{right 2}{down}if{enter}
		Return
		}
	
	If (OCR = "LargeDiet" or OCR = "LameDiet")
		{
		Send, {up 2}{right 4}{down}i{enter}
		Return
		}

	If (OCR = "LargeDietw/FlavorBlast" or OCR = "LameDietw/FlavorBlast")
		{
		Send, {up 2}{right 4}{down}if{enter}
		Return
		}
	
	If (OCR = "LargeCola(noice)" or OCR = "LameCola(noice)")
		{
		Send, {up 2}{down}{enter}
		Return
		}
	
	If (OCR = "LargeWater" or OCR = "LameWater")
		{
		Send, {up 2}{right 3}{down}i{enter}
		Return
		}
	
	If (OCR = "LargeTea" or OCR = "LameTea")
		{
		Send, {up 2}{right}{down}i{enter}
		Return
		}
	
	If (OCR = "JumboCola")
		{
		Send, {up 3}{down}i{enter}
		Return
		}
	
	If (OCR = "JumboGrape")
		{
		Send, {up 3}{right 2}{down}i{enter}
		Return
		}
	
	If (OCR = "JumboDiet")
		{
		Send, {up 3}{right 4}{down}i{enter}
		Return
		}
	
	If (OCR = "JumboCola(noice)")
		{
		Send, {up 3}{down}{enter}
		Return
		}
	
	If (OCR = "JumboWater")
		{
		Send, {up 3}{right 3}{down}i{enter}
		Return
		}
	
	If (OCR = "JumboTea")
		{
		Send, {up 3}{right}{down}i{enter}
		Return
		}
	
	If (OCR = "JumboColaw/FlavorBlast")
		{
		Send, {up 3}{down}if{enter}
		Return
		}
	
	If (OCR = "JumboGrapew/FlavorBlast")
		{
		Send, {up 3}{right 2}{down}if{enter}
		Return
		}
	
	If (OCR = "JumboDietw/FlavorBlast")
		{
		Send, {up 3}{right 4}{down}if{enter}
		Return
		}
	
	If (OCR = "JumboCola(noice)w/FlavorBlast")
		{
		Send, {up 3}{down}f{enter}
		Return
		}
	
	If (OCR = "JumboWaterw/FlavorBlast")
		{
		Send, {up 3}{right 3}{down}if{enter}
		Return
		}
	
	If (OCR = "JumboTeaw/FlavorBlast")
		{
		Send, {up 3}{right}{down}if{enter}
		Return
		}
	
	If (OCR = "SmallColaw/FlavorBlast")
		{
		Send, {down}if{enter}
		Return
		}
	
	If (OCR = "SmallGrapew/FlavorBlast")
		{
		Send, {right 2}{down}if{enter}
		Return
		}
	
	If (OCR = "SmallDietw/FlavorBlast")
		{
		Send, {right 4}{down}if{enter}
		Return
		}
	
	If (OCR = "SmallCola(noice)w/FlavorBlast")
		{
		Send, {down}f{enter}
		Return
		}
	
	If (OCR = "SmallWaterw/FlavorBlast")
		{
		Send, {right 3}{down}if{enter}
		Return
		}
	
	If (OCR = "SmallTeaw/FlavorBlast")
		{
		Send, {right}{down}if{enter}
		Return
		}
	
	If (OCR = "MediumColaw/FlavorBlast")
		{
		Send, {up}{down}if{enter}
		Return
		}
	
	If (OCR = "MediumGrapew/FlavorBlast")
		{
		Send, {up}{right 2}{down}if{enter}
		Return
		}
	
	If (OCR = "MediumDietw/FlavorBlast")
		{
		Send, {up}{right 4}if{enter}
		Return
		}
	
	If (OCR = "LargeColaw/FlavorBlast")
		{
		Send, {up 2}{down}if{enter}
		Return
		}
	
	If (OCR = "LargeGrapew/FlavorBlast")
		{
		Send, {up 2}{right 2}if{enter}
		Return
		}
	
	If (OCR = "LargeDietw/FlavorBlast")
		{
		Send, {up 2}{right 4}if{enter}
		Return
		}

;================SUSHI=================
Sushi:
		
	If (OCR = "StandardSampler")
		{
		Send, eerrttuu{enter}
		Return
		}
	
	If (OCR = "RoeSpecial")
		{
		Send, eeerrrrt{enter}
		Return
		}
	
	If (OCR = "TunaPlatter")
		{
		Send, ertuuuuu{enter}
		Return
		}
	
	If (OCR = "EbiSpecial")
		{
		Send, eeeeertu{enter}
		Return
		}
	
	If (OCR = "OceanPlate")
		{
		Send, eeerrtuu{enter}
		Return
		}
	
	If (OCR = "SeaSpirit")
		{
		Send, errtttuu{enter}
		Return
		}
		
	If (OCR = "MixedDelicious")
		{
		Send, eerrrttu{enter}
		Return
		}
	
	If (OCR = "ToroSpecial")
		{
		Send, ertttttu{enter}
		Return
		}
	
	If (OCR = "SalmonSpecial")
		{
		Send, erusssss{enter}
		Return
		}
	
	If (OCR = "FivesDelight" or OCR = "FivesDeliqht")
		{
		Send, erttusss{enter}
		Return
		}
	
	If(OCR = "DelightPlatter" or OCR = "DeligqhtPlatter" or OCR = "DeliqhtPlatter")
		{
		Send, eerrtuss{enter}
		Return
		}
	
	If (OCR = "PlateofGreat")
		{
		Send, errtuuss{enter}
		Return
		}
	
	If (OCR = "ETSTray" or OCR = "ETSTrav")
		{
		Send, eeettsss{enter}
		Return
		}
	
	If (OCR = "ShogunPlate" or OCR = "ShoqunPlate")
		{
		Send, rrrttuss{enter}
		Return
		}
	
	If (OCR = "EastSampler")
		{
		Send, eettuuss{enter}
		Return
		}
	
	If (OCR = "MackerelSpecial")
		{
		Send, uusmmmmm{enter}
		Return
		}
	
	If (OCR = "GourmetPlatter")
		{
		Send, eerrtumm{enter}
		Return
		}
	
	If (OCR = "SpecialSampler")
		{
		Send, eertusmm{enter}
		Return
		}
	
	If (OCR = "TheMix")	;Sushi "TheMix"
		{
		PixelGetColor, color_TheMix, 554, 196
		Msgbox Value is %color_TheMix%
		
		If color_TheMix = 69A02A
			{
			Msgbox Value of color is %color_TheMix%
			Send, rcbo{enter}
			Return
			}
		If (color_TheMix = 0xE0A784 or color_TheMix = 0xF6F6F6)
			{
			Msgbox Color is not green.
			Send, etuusmmm{enter}
			Return
			}
		}
	
	If (OCR = "RiceSampler")
		{
		Send, eettssmm{enter}
		Return
		}
	
	If (OCR = "ChomperPlate")
		{
		Send, errruusm{enter}
		Return
		}
	
	If (OCR = "YellowtailSpecial")
		{
		Send, tsmyyyyy{enter}
		Return
		}
	
	If (OCR = "GourmetSampler")
		{
		Send, ertussmy{enter}
		Return
		}
	
	If (OCR = "BailTray" or OCR = "BailTrav")
		{
		Send, tummyyyy{enter}
		Return
		}
	
	If (OCR = "YUMTray" or OCR = "YUMTrav")
		{
		Send, rruusyyy{enter}
		Return
		}
	
	If (OCR = "SeaofOceans")
		{
		Send, eeetuuyy{enter}
		Return
		}
	
	If (OCR = "BlueOilDelight")
		{
		Send, rrttssmy{enter}
		Return
		}
	
	If (OCR = "UnagiSpecial")
		{
		Send, rmyggggg{enter}
		Return
		}
	
	If (OCR = "EmperorSpecial")
		{
		Send, ertusmyg{enter}
		Return
		}
	
	If (OCR = "GoldenTray" or OCR = "GoldenTrav")
		{
		Send, usmygggg{enter}
		Return
		}
	
	If (OCR = "Fortune")
		{
		Send, smmyyggg{enter}
		Return
		}
	
	If (OCR = "SlamPlatter")
		{
		Send, eerummyg{enter}
		Return
		}
	
	If (OCR = "TrayPlatterPlate" or OCR = "TravPlatterPlate")
		{
		Send, rrruumyg{enter}
		Return
		}
	
	If (OCR = "TheMysteries" or OCR = "TheMvsteries")
		{
		Send, eeetsggg{enter}
		Return
		}
	
	If (OCR = "RoyalDebut" or OCR = "RovalDebut")
		{
		Send, tttsyyyg{enter}
		Return
		}
	
	If (OCR = "CrunchyPlate" or OCR = "CrunchvPlate")
		{
		Send, uuummmyg{enter}
		Return
		}
		
;================BREAKFAST SANDWICH================
BreakfastSandwich:

	If (OCR = "EggBiscuit" or OCR = "quBiscuit")
		{
		Send, e{enter}
		Return
		}

	If (OCR = "TheDeluxe")
		{
		Send, es{enter}
		Return
		}
	
	If (OCR = "DoubleAM")
		{
		Send, esb{enter}
		Return
		}
	
	If (OCR = "MorningFuel" or OCR = "MorningqFuel" or OCR = "MorninqFuel")
		{
		Send, sb{enter}
		Return
		}
	
	If (OCR = "SunriseSandwich")
		{
		Send, s{enter}
		Return
		}
	
	If (OCR = "TheClassic")
		{
		Send, eb{enter}
		Return
		}
	
;================FRESH FISH================

	If (OCR = "GreyTailFish" or OCR = "GrevTailFish")
		{
		Send, {right}{down}{left}s{enter}
		Return
		}
	
	If (OCR = "LongBodyBrownRaccuda" or OCR = "LonaBodvBrownRaccuda" or OCR = "LonqBodvBrownRaccuda")
		{
		Send, {right}{down}{left}s{enter}
		Return
		}
	
	If (OCR = "LongBodyBrownRaccudaw/Lemon" or OCR = "LonaBodvBrownRaccudaw/Lemon" or OCR = "LonqBodvBrownRaccudaw/Lemon")
		{
		Send, {right}{down}{left}sl{enter}
		Return
		}
	
	If (OCR = "RainbowGruza")
		{
		Send, {right}{down}{left}s{enter}
		Return
		}

	If (OCR = "RainbowGruzaw/Lemon")
		{
		Send, {right}{down}{left}sl{enter}
		Return
		}
		
;================STACKED ENCHILADAS================

StackedEnchiladas:

	If (OCR = "JuniorStack")
		{
		Send, {down}{up}tc{enter}
		Return
		}
	
	If (OCR = "DoubleStack")
		{
		Send, {down}{up}t{down}{up}tc{enter}
		Return
		}
	
	If (OCR = "Triplew/Egg" or OCR = "Triplew/Em" or OCR = "Triplew/chl" or OCR = "Triplew/chf")
		{
		Send, {down}{up}t{down}{up}t{down}{up}tce{enter}
		Return
		}
	
	If (OCR = "TripleStack")
		{
		Send, {down}{up}t{down}{up}t{down}{up}tc{enter}
		Return
		}
	
	If (OCR = "Triplew/Onion")
		{
		Send, {down}{up}t{down}{up}t{down}{up}tco{enter}
		Return
		}
	
	If (OCR = "TripleWorks")
		{
		Send, {down}{up}t{down}{up}t{down}{up}tceo{enter}
		Return
		}
	
	If (OCR = "Juniorw/Onion")
		{
		Send, {down}{up}tco{enter}
		Return
		}
	
	If (OCR = "DoubleOnion")
		{
		Send, {down}{up}t{down}{up}tco{enter}
		Return
		}
	
	If (OCR = "DoubleWorks")
		{
		Send, {down}{up}t{down}{up}tceo{enter}
		Return
		}

;================STEAK================
Steak:

	If (OCR = "ClassicSteak")
		{
		Send, sssj{enter}
		Return
		}

	If (OCR = "CitrusSteak")
		{
		Send, sjjc{enter}
		Return
		}
	
	If (OCR = "SpicySteak" or OCR = "SpicvSteak")
		{
		Send, sppppjj{enter}
		Return
		}
	
	If (OCR = "TheDrySpicySteak" or OCR = "TheDrySpicvSteak" or OCR = "TheDrvSpicySteak" or OCR = "TheDrvSpicvSteak")
		{
		Send, spp{enter}
		Return
		}
	
	If (OCR = "Baconesque" or OCR = "Baconesaue" or OCR = "Baconesclue")
		{
		Send, sjjbb{enter}
		Return
		}
	
	If (OCR = "SpicyBaconesque" or OCR = "SpicvBaconesque")
		{
		Send, sjppbb{enter}
		Return
		}
	
	If (OCR = "SpicySmokevSteak" or OCR = "SpicvSmokevSteak" or OCR = "SpicvSmokevSteak")
		{
		Send, ssdpppjj{enter}
		Return
		}
	
	If (OCR = "SmokeyOrangeSteak" or OCR = "SmokeyOranqeSteak")
		{
		Send, sdjcc{enter}
		Return
		}
	
	If (OCR = "HickorySteak" or OCR = "HickorvSteak")
		{
		Send, sshhjjjj{enter}
		Return
		}
	
	If (OCR = "WestTexasSteak")
		{
		Send, ssjjppbbddhh{enter}
		Return
		}
	
;================STOVE STATION================
Stove:


;================LOBSTER================
Lobster:

	If (OCR = "ClassicLiteLobster")
		{
		PixelGetColor, color_StoveStage, 1062, 172
		;Msgbox DEBUG: Lobster StoveStage color is %color_StoveStage%
		If color_StoveStage = 0x2D3032
			{
			Send, L
			Sleep 500
			Send, {enter}
			Return
			}
		
		If color_StoveStage != 0x2D3032
			{
			;Msgbox DEBUG: Lobster StoveStage is cooked
			Sleep 500
			Send, {enter}
			Return
			}
		}
	
	If (OCR = "ClassicLobster")
		{
		PixelGetColor, color_StoveStage, 1062, 172
		;Msgbox DEBUG: Lobster StoveStage color is %color_StoveStage%
		If color_StoveStage = 0x2D3032
			{
			Send, L
			Sleep 500
			Send, {enter}
			Return
			}
		
		If color_StoveStage != 0x2D3032
			{
			;Msgbox DEBUG: Lobster StoveStage is cooked
			Sleep 500
			Send, b{enter}
			Return
			}
		}
	
	If (OCR = "ButteryLobster" or OCR = "ButtervLobster")
		{
		PixelGetColor, color_StoveStage, 1062, 172
		;Msgbox DEBUG: Lobster StoveStage color is %color_StoveStage%
		If color_StoveStage = 0x2D3032
			{
			Send, L
			Sleep 200
			Send, {enter}
			Return
			}
		
		If color_StoveStage != 0x2D3032
			{
			;Msgbox DEBUG: Lobster StoveStage is cooked
			Sleep 500
			Send, bb{enter}
			Return
			}
		}

	If (OCR = "LobsterCocktail")
		{
		PixelGetColor, color_StoveStage, 1062, 172
		;Msgbox DEBUG: Lobster StoveStage color is %color_StoveStage%
		If color_StoveStage = 0x2D3032
			{
			Send, L
			Sleep 200
			Send, {enter}
			Return
			}
		
		If color_StoveStage != 0x2D3032
			{
			;Msgbox DEBUG: Lobster StoveStage is cooked
			Sleep 500
			Send, c{enter}
			Return
			}
		}
	
	If (OCR = "ButteryCocktail" or OCR = "ButtervCocktail")
		{
		PixelGetColor, color_StoveStage, 1062, 172
		;Msgbox DEBUG: Lobster StoveStage color is %color_StoveStage%
		If color_StoveStage = 0x2D3032
			{
			Send, L
			Sleep 200
			Send, {enter}
			Return
			}
		
		If color_StoveStage != 0x2D3032
			{
			;Msgbox DEBUG: Lobster StoveStage is cooked
			Sleep 500
			Send, cb{enter}
			Return
			}
		}
	
	If (OCR = "DoubleCocktail")
		{
		PixelGetColor, color_StoveStage, 1062, 172
		If color_StoveStage = 0x2D3032
			{
			Send, L
			Sleep 200
			Send, {enter}
			Return
			}
		
		If color_StoveStage != 0x2D3032
			{
			Sleep 500
			Send, cc{enter}
			Return
			}
		}
	
	If (OCR = "GarlicLobster")
		{
		PixelGetColor, color_StoveStage, 1062, 172
		If color_StoveStage = 0x2D3032
			{
			Send, L
			Sleep 200
			Send, {enter}
			Return
			}
		
		If color_StoveStage != 0x2D3032
			{
			Sleep 500
			Send, a{enter}
			Return
			}
		}
	
	If (OCR = "GarlicCocktail")
		{
		PixelGetColor, color_StoveStage, 1062, 172
		If color_StoveStage = 0x2D3032
			{
			Send, L
			Sleep 200
			Send, {enter}
			Return
			}
		
		If color_StoveStage != 0x2D3032
			{
			Sleep 500
			Send, ac{enter}
			Return
			}
		}
	
	If (OCR = "ButteryGarlic" or OCR = "ButtervGarlic")
		{
		PixelGetColor, color_StoveStage, 1062, 172
		If color_StoveStage = 0x2D3032
			{
			Send, L
			Sleep 200
			Send, {enter}
			Return
			}
		
		If color_StoveStage != 0x2D3032
			{
			Sleep 500
			Send, ba{enter}
			Return
			}
		}
	
	If (OCR = "GingerLobster")
		{
		PixelGetColor, color_StoveStage, 1062, 172
		If color_StoveStage = 0x2D3032
			{
			Send, L
			Sleep 200
			Send, {enter}
			Return
			}
		
		If color_StoveStage != 0x2D3032
			{
			Sleep 500
			Send, g{enter}
			Return
			}
		}
	
	If (OCR = "TangyGarlic" or OCR = "TangvGarlic")
		{
		PixelGetColor, color_StoveStage, 1062, 172
		If color_StoveStage = 0x2D3032
			{
			Send, L
			Sleep 200
			Send, {enter}
			Return
			}
		
		If color_StoveStage != 0x2D3032
			{
			Sleep 500
			Send, ag{enter}
			Return
			}
		}
	
	If (OCR = "GingerCocktail" or OCR = "GinqerCocktail")
		{
		PixelGetColor, color_StoveStage, 1062, 172
		If color_StoveStage = 0x2D3032
			{
			Send, L
			Sleep 200
			Send, {enter}
			Return
			}
		
		If color_StoveStage != 0x2D3032
			{
			Sleep 500
			Send, cg{enter}
			Return
			}
		}
	
	If (OCR = "SpicyLobster" or OCR = "SpicvLobster")
		{
		PixelGetColor, color_StoveStage, 1062, 172
		If color_StoveStage = 0x2D3032
			{
			Send, L
			Sleep 200
			Send, {enter}
			Return
			}
		
		If color_StoveStage != 0x2D3032
			{
			Sleep 500
			Send, s{enter}
			Return
			}
		}
	
	If (OCR = "SpicyMax" or OCR = "SpicvMax")
		{
		PixelGetColor, color_StoveStage, 1062, 172
		If color_StoveStage = 0x2D3032
			{
			Send, L
			Sleep 200
			Send, {enter}
			Return
			}
		
		If color_StoveStage != 0x2D3032
			{
			Sleep 500
			Send, sb{enter}
			Return
			}
		}

	If (OCR = "LobsterTwist")
		{
		PixelGetColor, color_StoveStage, 1062, 172
		If color_StoveStage = 0x2D3032
			{
			Send, L
			Sleep 200
			Send, {enter}
			Return
			}
		
		If color_StoveStage != 0x2D3032
			{
			Sleep 500
			Send, as{enter}
			Return
			}
		}

	If (OCR = "LobsterNights")
		{
		PixelGetColor, color_StoveStage, 1062, 172
		If color_StoveStage = 0x2D3032
			{
			Send, L
			Sleep 200
			Send, {enter}
			Return
			}
		
		If color_StoveStage != 0x2D3032
			{
			Sleep 500
			Send, cs{enter}
			Return
			}
		}

	If (OCR = "LeanLobster")
		{
		PixelGetColor, color_StoveStage, 1062, 172
		If color_StoveStage = 0x2D3032
			{
			Send, L
			Sleep 200
			Send, {enter}
			Return
			}
		
		If color_StoveStage != 0x2D3032
			{
			Sleep 500
			Send, sg{enter}
			Return
			}
		}

	If (OCR = "ExtremeLobster")
		{
		PixelGetColor, color_StoveStage, 1062, 172
		If color_StoveStage = 0x2D3032
			{
			Send, L
			Sleep 200
			Send, {enter}
			Return
			}
		
		If color_StoveStage != 0x2D3032
			{
			Sleep 500
			Send, ss{enter}
			Return
			}
		}
;================PASTA================
Pasta:

	If (OCR = "CheesePasta")
		{
		PixelGetColor, color_StoveStage, 576, 333
		If color_StoveStage = 0x736C6D
		Send, r{enter}
		
		If color_StoveStage != 0x736C6D
		Send, c{enter}
		Return
		}
	
	If (OCR = "ClassicSpaghetti")
		{
		PixelGetColor, color_StoveStage, 576, 333
		If color_StoveStage = 0x736C6D
		Send, r{enter}
		
		If color_StoveStage != 0x736C6D
		Send, rm{enter}
		Return
		}
	
	If (OCR = "RedVeggiePasta" or OCR = "RedVeqqiePasta")
		{
		PixelGetColor, color_StoveStage, 576, 333
		If color_StoveStage = 0x736C6D
		Send, r{enter}
		
		If color_StoveStage != 0x736C6D		
		Send, rpuso{enter}
		Return
		}
	
	If (OCR = "TheMeatyPasta" or OCR = "TheMeatvPasta")
		{
		PixelGetColor, color_StoveStage, 576, 333
		If color_StoveStage = 0x736C6D
		Send, r{enter}
		
		If color_StoveStage != 0x736C6D		
		Send, rmkb{enter}
		Return
		}
	
	If (OCR = "HotBaconPasta")
		{
		PixelGetColor, color_StoveStage, 576, 333
		If color_StoveStage = 0x736C6D
		Send, r{enter}
		
		If color_StoveStage != 0x736C6D	
		Send, rbp{enter}
		Return
		}
	
	If (OCR = "CheesyOnionPasta" or OCR = "CheesvOnionPasta")
		{
		PixelGetColor, color_StoveStage, 576, 333
		If color_StoveStage = 0x736C6D
		Send, r{enter}
		
		If color_StoveStage != 0x736C6D	
		Send, co{enter}
		Return
		}
	
	If (OCR = "CheesyMeatyPasta" or OCR = "CheesvMeatvPasta" or OCR = "CheesyMeatvPasta")
		{
		PixelGetColor, color_StoveStage, 576, 333
		If color_StoveStage = 0x736C6D
		Send, r{enter}
		
		If color_StoveStage != 0x736C6D			
		Send, cmkb{enter}
		Return
		}
	
	If (OCR = "CheesyDeluxePasta" or OCR = "CheesvDeluxePasta")
		{
		PixelGetColor, color_StoveStage, 576, 333
		If color_StoveStage = 0x736C6D
		Send, r{enter}
		
		If color_StoveStage != 0x736C6D					
		Send, cmkbpuso{enter}
		Return
		}
	
	If (OCR = "RedDeluxePasta")
		{
		PixelGetColor, color_StoveStage, 576, 333
		If color_StoveStage = 0x736C6D
		Send, r{enter}
		
		If color_StoveStage != 0x736C6D			
		Send, rmkbpuso{enter}
		Return
		}
	
	If (OCR = "CheesyChickenPasta" or OCR = "CheesvChickenPasta")
		{
		PixelGetColor, color_StoveStage, 576, 333
		If color_StoveStage = 0x736C6D
		Send, r{enter}

		If color_StoveStage != 0x736C6D	
		Send, ckb{enter}
		Return
		}
	
	If (OCR = "SpaghettiDeluxe" or OCR = "SpaqhettiDeluxe")
		{
		PixelGetColor, color_StoveStage, 576, 333
		If color_StoveStage = 0x736C6D
		Send, r{enter}
		
		If color_StoveStage != 0x736C6D	
		Send, rmbus{enter}
		Return
		}
	
	If (OCR = "CheesyVeggiePasta" or OCR = "CheesvVeggiePasta" or OCR = "CheesyVeqqiePasta" or OCR = "CheesvVeqqiePasta" or OCR = "CheesyVeqqiePasta")
		{
		PixelGetColor, color_StoveStage, 576, 333
		If color_StoveStage = 0x736C6D
		Send, r{enter}
		
		If color_StoveStage != 0x736C6D	
		Send, cpuso{enter}
		Return
		}
	
	If (OCR = "CreamyAlfredo" or OCR = "CreamvAlfredo")
		{
		PixelGetColor, color_StoveStage, 576, 333
		If color_StoveStage = 0x736C6D
		Send, r{enter}
		
		If color_StoveStage != 0x736C6D	
		Send, wks{enter}
		Return
		}
	
	If (OCR = "TheCarbonara")
		{
		PixelGetColor, color_StoveStage, 576, 333
		If color_StoveStage = 0x736C6D
		Send, r{enter}
		
		If color_StoveStage != 0x736C6D			
		Send, wkbpui{enter}
		Return
		}
	
	If (OCR = "CreamyMeatPasta" or OCR = "CreamvMeatPasta")
		{
		PixelGetColor, color_StoveStage, 576, 333
		If color_StoveStage = 0x736C6D
		Send, r{enter}
		
		If color_StoveStage != 0x736C6D			
		Send, wmkbu{enter}
		Return
		}
	
	If (OCR = "CreamyVeggiePasta" or OCR = "CreamvVeggiePasta" or OCR = "CreamyVeqqiePasta" or OCR = "CreamvVeqqiePasta")
		{
		PixelGetColor, color_StoveStage, 576, 333
		If color_StoveStage = 0x736C6D
		Send, r{enter}
		
		If color_StoveStage != 0x736C6D				
		Send, wpuso{enter}
		Return
		}
		
	If (OCR = "SpicyBaconPasta" or OCR = "SpicvBaconPasta")
		{
		PixelGetColor, color_StoveStage, 576, 333
		If color_StoveStage = 0x736C6D
		Send, r{enter}
		
		If color_StoveStage != 0x736C6D			
		Send, rbi{enter}
		Return
		}
	
	If (OCR = "SpicySpaghetti" or OCR = "SpicvSpaghetti" or OCR = "SpicySpaqhetti" or OCR = "SpicvSpaqhetti")
		{
		PixelGetColor, color_StoveStage, 576, 333
		If color_StoveStage = 0x736C6D
		Send, r{enter}

		If color_StoveStage != 0x736C6D		
		Send, rmi{enter}
		Return
		}
		
	If (OCR = "TheDryTomato" or OCR = "TheDrvTomato")
		{
		PixelGetColor, color_StoveStage, 576, 333
		If color_StoveStage = 0x736C6D
		Send, r{enter}
		
		If color_StoveStage != 0x736C6D
		Send, mt{enter}
		Return
		}
		
	If (OCR = "RedPastaRally" or OCR = "RedPastaRallv")
		{
		PixelGetColor, color_StoveStage, 576, 333
		If color_StoveStage = 0x736C6D
		Send, r{enter}		
		
		If color_StoveStage != 0x736C6D
		Send, rpit{enter}
		Return
		}
	
	If (OCR = "RedVeggiePasta")
		{
		PixelGetColor, color_StoveStage, 576, 333
		If color_StoveStage = 0x736C6D
		Send, r{enter}
		
		If color_StoveStage != 0x736C6D		
		Send, psit{enter}
		Return
		}
	
	If (OCR = "DryVeggiePasta" or OCR = "DrvVeggiePasta" or OCR = "DrvVeqqiePasta")
		{
		PixelGetColor, color_StoveStage, 576, 333
		If color_StoveStage = 0x736C6D
		Send, r{enter}
		
		If color_StoveStage != 0x736C6D			
		Send, psit{enter}
		Return
		}
		
	If (OCR = "CheesyTomato" or OCR = "CheesvTomato")
		{
		PixelGetColor, color_StoveStage, 576, 333
		If color_StoveStage = 0x736C6D
		Send, r{enter}
		
		If color_StoveStage != 0x736C6D			
		Send, cit{enter}
		Return
		}
		
	If (OCR = "SpaghettiPesto")
		{
		PixelGetColor, color_StoveStage, 576, 333
		If color_StoveStage = 0x736C6D
		Send, r{enter}
		
		If color_StoveStage != 0x736C6D		
		Send, gm{enter}
		Return
		}
	
	If (OCR = "ManhattanPesto")
		{
		PixelGetColor, color_StoveStage, 576, 333
		If color_StoveStage = 0x736C6D
		Send, r{enter}
		
		If color_StoveStage != 0x736C6D		
		Send, gmkbpusoit{enter}
		Return
		}
	
	If (OCR = "ChickenPesto")
		{
		PixelGetColor, color_StoveStage, 576, 333
		If color_StoveStage = 0x736C6D
		Send, r{enter}
		
		If color_StoveStage != 0x736C6D		
		Send, gkui{enter}
		Return
		}
	
	If (OCR = "VerdePesto")
		{
		PixelGetColor, color_StoveStage, 576, 333
		If color_StoveStage = 0x736C6D
		Send, r{enter}

		If color_StoveStage != 0x736C6D
		Send, gsi{enter}
		Return
		}
		
;================CHORES================

Chores:

	If (OCR = "WorkTicket(Clean)" or OCR = "orkTicket(Clean")
		{
		Send, {down}s{enter}
		Return
		}
	
	If (OCR = "WorkTicket(Dishes)" or OCR = "orkTicket(Dishes")
		{
		If user_Dishwasher = 0
			{
			Send, {left}{right}{left}{right}{up}{left}{right}{left}{right}{up}{left}{right}{left}{right}{up}{left}{right}{left}{right}{up}{left}{right}{left}{right}{up}{left}{right}{left}{right}{up}
			Return
			}
		else
		{
		Send, {left}{right}{left}{right}{up}{left}{right}{left}{right}{up}{left}{right}{left}{right}{up}
		Return
		}
		}
		
	If (OCR = "WorkTicket(Trash)" or OCR = "orkTicket(Trash")
		{
		If user_Garbage = 0
			{
			;Msgbox DEBUG: Line 896: Difficulty variable is %Dishwasher%
			Send, {up}
			sleep 270
			Send, {right}
			sleep 270
			Send, {up}
			sleep 270
			Send, {right}
			sleep 270
			Send, {up}
			sleep 270
			Send, {right}
			sleep 270
			Send, {up}
			sleep 270
			Send, {right}
			sleep 270
			Send, {up}
			sleep 270
			Send, {right}s
			sleep 100
			Send, s
			Return
			}
		else
		{
		;Msgbox DEBUG: Line 922: Dishwasher variable is %Dishwasher%
		Send, {up}
		sleep 500
		Send, {right}
		sleep 500
		Send, {up}
		sleep 500
		Send, {right}
		sleep 500
		Send, s
		Return
		}
		}
	
	If (OCR = "WorkTicket(Rodents)" or OCR = "orkTicket(Rodents")
		{
		Send, {right}{down}cs
		Return
		}
		
;================SOPAPILLAS================
Sopapillas:

	If (OCR = "DeliciousLiteSopapillas")
		{
		Send, {down Down}
		sleep 2500
		Send, {down Up}p{enter}
		Return
		}
	
	If (OCR = "DeliciousSopapillas")
		{
		Send, {down Down}
		sleep 2500
		Send, {down Up}ps{enter}
		Return
		}

;================CORN DOG==============
CornDog:

	If (OCR = "TheRedDog")
		{
		Send, k{enter}
		Return
		}
	
	If (OCR = "TheClassicCornDog" or OCR = "TheClassicCornDon")
		{
		Send, km{enter}
		Return
		}
	
	If (OCR = "TheYellowDog" or OCR = "TheYellowDon")
		{
		Send, m{enter}
		Return
		}
	
	If (OCR = "TheGerstmann")
		{
		Send, k{enter}
		Return
		}

;================PRETZELS================
Pretzels:

	If (OCR = "TheButteryCurves" or OCR= "TheButtervCurves")
		{
		Send, b{enter}
		Return
		}
	
	If (OCR = "TheSweetTwist")
		{
		Send, bc{enter}
		Return
		}
	
	If (OCR = "TheSaltyKnot" or OCR = "TheSaltvKnot")
		{
		Send, s{enter}
		Return
		}
	
	If (OCR = "TheDryTwister" or OCR = "TheDrvTwister")
		{
		Send, {enter}
		Return
		}
	
	If (OCR = "CinnamonPretzel")
		{
		Send, c{enter}
		Return
		}
	
	If (OCR = "TheClassicPretzel")
		{
		Send, sb{enter}
		Return
		}

;================PIZZA================
Pizza:

	If (OCR = "PepperoniPizza" or OCR = "PeqqeroniPizza")
		{
		Send, tcp{enter}
		Return
		}
	
	If (OCR = "CheesePizza")
		{
		Send, tc{enter}
		Return
		}
	
	If (OCR = "MeatPizza")
		{
		Send, tcm{enter}
		Return
		}
	
	If (OCR = "P&MPizza")
		{
		Send, tcpm{enter}
		Return
		}
	
	If (OCR = "CheesyBread" or OCR = "CheesvBread")
		{
		Send, c{enter}
		Return
		}
	
	If (OCR = "MeatloversPizza")
		{
		Send, tcpmb{enter}
		Return
		}
	
	If (OCR = "VeggiePizza" or OCR = "VeqqiePizza")
		{
		Send, tcuvn{enter}
		Return
		}
	
	If (OCR = "DeluxePizza")
		{
		Send, tcpmbuvn{enter}
		Return
		}
	
	If (OCR = "ItalianPizza" or OCR = "ltalianPizza")
		{
		Send, tcmuvn{enter}
		Return
		}
	
	If (OCR = "BaconandMushroomPizza")
		{
		Send, tcbu{enter}
		Return
		}
	
	If (OCR = "OlivesandOnionsPizza")
		{
		Send, tcvn{enter}
		Return
		}
	
	If (OCR = "ThePCGBPizza")
		{
		Send, tcpbn{enter}
		Return
		}
	
	If (OCR = "AnchovyPizza" or OCR = "AnchovvPizza")
		{
		Send, tca{enter}
		Return
		}

	If (OCR = "DeluxeAnchovyPizza" or OCR = "DeluxeAnchovvPizza")
		{
		Send, tcauvn{enter}
		Return
		}
	
	If (OCR = "MeatyAnchovyPizza" or OCR = "MeatvAnchovvPizza")
		{
		Send, tcpmba{enter}
		Return
		}
	
	If (OCR = "Dairy-LitePizza" or OCR = "Dairv-LitePizza")
		{
		Send, tau{enter}
		Return
		}
	
	If (OCR = "PineappleandHamPizza")
		{
		Send, tchi{enter}
		Return
		}
	
	If (OCR = "TheHawaiianPizza")
		{
		Send, tcpbhni{enter}
		Return
		}
	
	If (OCR = "SweetVeggieP." or OCR = "SweetVeqqieP.")
		{
		Send, tcuvi{enter}
		Return
		}
	
	If (OCR = "ExtraMeatLoversPizza")
		{
		Send, tcpmbh{enter}
		Return
		}
	
	If (OCR = "SuperSurpremePizza")
		{
		Send, tcpmbgahuvni{enter}
		Return
		}
	
	If (OCR = "TheH.A.M.Pizza")
		{
		Send, tcahu{enter}
		Return
		}
	
	If (OCR = "TomatoLoversPizza")
		{
		Send, tcpo{enter}
		Return
		}
	
	If (OCR = "Tomato&AnchovyPizza" or OCR = "Tomato&AnchovvPizza")
		{
		Send, tcai{enter}
		Return
		}
	
	If (OCR = "Tomato&PineapplePizza")
		{
		Send, tcio{enter}
		Return
		}
	
	If (OCR = "TheAll-Meat-TomatoPizza")
		{
		Send, tcpmbaho{enter}
		Return
		}
	
	If (OCR = "PestoPepperoniPizza")
		{
		Send, gcp{enter}
		Return
		}
	
	If (OCR = "AllVeggiePestoPizza" or OCR = "AllVeqqiePestoPizza")
		{
		Send, gcuvnio{enter}
		Return
		}
	
	If (OCR = "SuperDeluxePestoPizza")
		{
		Send, gcaphmbuvnio{enter}
		Return
		}
	
	If (OCR = "AnchovyPestoPizza" or OCR = "AnchovvPestoPizza")
		{
		Send, gcau{enter}
		Return
		}
	
	If (OCR = "MeatLoversPestoPizza")
		{
		Send, gcpmbh{enter}
		Return
		}
	
	If (OCR = "PineappleandHamPestoPizza")
		{
		Send, gchi{enter}
		Return
		}
	
	If (OCR = "SweetVeggiePestoP." or OCR = "SweetVeqqiePestoP.")
		{
		Send, gcuvi{enter}
		Return
		}
	
	If (OCR = "CheesyPestoPizza" or OCR = "CheesvPestoPizza")
		{
		Send, gc{enter}
		Return
		}
	
	If (OCR = "PiggyPestoPizza" or OCR = "PiqqyPestoPizza")
		{
		Send, gcbhun{enter}
		Return
		}
	
	If (OCR = "ItalianPestoPizza" or OCR = "italianPestoPizza" or OCR = "ltalianPestoPizza")
		{
		Send, gcpuvno{enter}
		Return
		}
	
;================SALADS================
Salads:

	If (OCR = "HouseSalad")
		{
		Send, rcb{enter}
		Return
		}
	
	If (OCR = "PepperRanch" or OCR = "PeqqerRanch")
		{
		Send, rco{enter}
		Return
		}
	
	If (OCR = "CheesyLeaves" or OCR = "CheesvLeaves")
		{
		Send, rc{enter}
		Return
		}
	
	If (OCR = "PepperRanch")
		{
		Send, rco{enter}
		Return
		}
	
	If (OCR = "TheDryGreens" or OCR = "TheDrvGreens")
		{
		Send, g{enter}
		Return
		}
	
	If (OCR = "TheDryDeluxe" or OCR = "TheDrvDeluxe")
		{
		Send, mg{enter}
		Return
		}
	
	If (OCR = "TheKidsDelight" or OCR = "KidsDeliqht")
		{
		Send, rc{enter}
		Return
		}
	
	If (OCR = "TheManhattan")
		{
		Send, rcbomg{enter}
		Return
		}
	
	If (OCR = "TheMix") ;Salad "TheMix"
		{
		Send, rcbo{enter}
		Return
		}
	
	If (OCR = "TomatoRanch")
		{
		Send, rcm{enter}
		Return
		}
	
	If (OCR = "TheBigSalad" or OCR = "TheBinSalad" or OCR = "TheBioSalad" or OCR = "TheBiqSalad")
		{
		Send, cg{enter}
		Return
		}
	
	If (OCR = "CheesyPeppers" or OCR = "CheesvPeppers")
		{
		Send, co{enter}
		Return
		}
		
	If (OCR = "SaladVerde")
		{
		Send, rg{enter}
		Return
		}
	
	If (OCR = "TheThousandSalad")
		{
		Send, tcg{enter}
		Return
		}
	
	If (OCR = "TheThousandPeppers")
		{
		Send, tco{enter}
		Return
		}
	
	If (OCR = "ThousandHouse")
		{
		Send, tcb{enter}
		Return
		}
		
	If (OCR = "ThousandTomatoes")
		{
		Send, tcm{enter}
		Return
		}
	
	If (OCR = "ThreeThousand")
		{
		Send, tcbog{enter}
		Return
		}
	
	If (OCR = "AThousandFlavors")
		{
		Send, tcbomg{enter}
		Return
		}
		
	If (OCR = "TheOilyPepper" or OCR = "TheOilvPepper")
		{
		Send, vco{enter}
		Return
		}
	
	If (OCR = "TheOilBleu")
		{
		Send, vcbomg{enter}
		Return
		}
	
	If (OCR = "VinaigretteHouse")
		{
		Send, vcb{enter}
		Return
		}
	
	If (OCR = "TheOilyGreens" or OCR = "TheOilvGreens")
		{
		Send, vmg{enter}
		Return
		}
	
	If (OCR = "CheesyVinaigrette" or OCR = "CheesvVinaigrette")
		{
		Send, vc{enter}
		Return
		}
	
	If (OCR = "VinaigretteClassic")
		{
		Send, vcobm{enter}
		Return
		}
	
;================BAKED POTATO================
BakedPotato:

	If (OCR = "ClassicBakedPotato")
		{
		Send, csy{enter}
		Return
		}
	
	If (OCR = "ClassicPotatow/Bacon")
		{
		Send, csyb{enter}
		Return
		}
	
	If (OCR = "DeluxePotato")
		{
		Send, csyhbo{enter}
		Return
		}
	
	If (OCR = "PlainPotato")
		{
		Send, y{enter}
		Return
		}
	
	If (OCR = "SourPotato")
		{
		Send, so{enter}
		Return
		}
	
	If (OCR = "LitePotato")
		{
		Send, sho{enter}
		Return
		}
	
	If (OCR = "TheDryPotato")
		{
		Send, {enter}
		Return
		}
	
	If (OCR = "SourPotatow/Bacon")
		{
		Send, sbo{enter}
		Return
		}
	
	If (OCR = "LitenCheesyPotato" or OCR = "LitenCheesvPotato")
		{
		Send, cs{enter}
		Return
		}
	
	If (OCR = "Chives&BaconPotato")
		{
		Send, yhb{enter}
		Return
		}
	
	If (OCR = "SpicyOlivePotato" or OCR = "SpicvOlivePotato")
		{
		Send, csyvp{enter}
		Return
		}
	
	If (OCR = "SpicyClassicPotato" or OCR = "SpicvClassicPotato")
		{
		Send, csyp{enter}
		Return
		}
	
	If (OCR = "SpicyBaconPotato" or OCR = "SpicvBaconPotato")
		{
		Send, csybop{enter}
		Return
		}
	
	If (OCR = "SpicyDeluxePotato" or OCR = "SpicvDeluxePotato")
		{
		Send, cyhbovp{enter}
		Return
		}
		
	If (OCR = "Broccoli&CheesyPotato" or OCR = "Broccoli&ChessvPotato")
		{
		Send, rq{enter}
		Return
		}
	
	If (OCR = "Broccoli&CheesySurpremePotato" or OCR = "Broccoli&CheesvSurpremePotato")
		{
		Send, borq{enter}
		Return
		}
	
	If (OCR = "GreenPotato")
		{
		Send, cshovpr{enter}
		Return
		}
	
	If (OCR = "CheesyDeluxePotato" or OCR = "CheesvDeluxePotato")
		{
		Send, cybpq{enter}
		Return
		}
	
	If (OCR = "MeatClassicPotato")
		{
		Send, csbm{enter}
		Return
		}
		
	If (OCR = "MeatyDeluxePotato" or OCR = "MeatvDeluxePotato")
		{
		Send, hbpqm{enter}
		Return
		}
	
	If (OCR = "SimplyMeatPotato" or OCR = "SimplvMeatPotato")
		{
		Send, ym{enter}
		Return
		}
	
	If (OCR = "MeatyBroccoliPotato" or OCR = "MeatvBroccoliPotato")
		{
		Send, prqm{enter}
		Return
		}
	
	If (OCR = "FullyLoadedPotato" or OCR = "FullvLoadedPotato")
		{
		Send, csyhboprm{enter}
		Return
		}
	
	If (OCR = "FullyLoadedPotatow/Queso" or OCR = "FullvLoadedPotatow/Queso" or OCR = "FullyLoadedPotatow/Oueso")
		{
		Send, syhbovprqm{enter}
		Return
		}
	
;================ICE CREAM================
IceCream:

	If (OCR = "PlainVanilla" or OCR = "PlainVanllla")
		{
		Send, vvv{enter}
		Return
		}
	
	If (OCR = "PlainChocolate")
		{
		Send, ccc{enter}
		Return
		}
	
	If (OCR = "VanillaandChocolate" or OCR = "VanlllaandChocolate")
		{
		Send, vc{enter}
		Return
		}
	
	If (OCR = "TheYinandYang" or OCR = "TheYinandYanQ" or OCR = "TheYinandYanq")
		{
		Send, vchp{enter}
		Return
		}
	
	If (OCR = "CherryVanilla" or OCR = "CherrvVanilla")
		{
		Send, vvh{enter}
		Return
		}
	
	If (OCR = "ChocolateSprinkles")
		{
		Send, ccp{enter}
		Return
		}
	
	If (OCR = "TrioofDelicious")
		{
		Send, vcm{enter}
		Return
		}
		
	If (OCR = "MintyDeluxe" or OCR = "MintvDeluxe")
		{
		Send, mmhwn{enter}
		Return
		}
	
	If (OCR = "MintyCherry" or OCR = "MintvCherrv" or OCR = "MintCherrv" or OCR = "MintCherry")
		{
		Send, mmh{enter}
		Return
		}

	If (OCR = "NuttyMint" or OCR = "NuttvMint")
		{
		Send, mmn{enter}
		Return
		}
		
	If (OCR = "NuttyVanilla" or OCR = "NuttvVanilla")
		{
		Send, vvn{enter}
		Return
		}
	
	If (OCR = "NuttyChocolate" or OCR = "NuttvChocolate")
		{
		Send, ccn{enter}
		Return
		}
	
	If (OCR = "VanillaDream")
		{
		Send, vvvhpwnos{enter}
		Return
		}
	
	If (OCR = "ChocolateHeaven")
		{
		Send, cmmhpwnos{enter}
		Return
		}
	
	If (OCR = "DeluxeButterPecan")
		{
		Send, bbhpwnos{enter}
		Return
		}
	
	If (OCR = "ButteryNuts" or OCR = "ButtervNuts")
		{
		Send, bbhwn{enter}
		Return
		}
	
	If (OCR = "BirthdaySurprise!" or OCR = "BirthdaySurprisel" or OCR = "BithdavSurprise!" or OCR = "BirthdavSurprisel")
		{
		Send, vcbhpwo{enter}
		Return
		}
	
	If (OCR = "TheFiestaBowl")
		{
		Send, cmbhpws{enter}
		Return
		}
;================FRIED CHICKEN================
FriedChicken:

	If (OCR = "GreasyFriedChicken" or OCR = "GreasvFriedChicken")
		{
		Send, {down Down}
		sleep 3000
		Send, {down Up}p{enter}
		Return
		}
	
	If (OCR = "GoldenFriedChicken")
		{
		Send, {down Down}
		sleep 3000
		Send, {down Up}p{enter}
		Return
		}

;================HASH BROWNS================		
HashBrowns:

	If (OCR = "LiteHashPatties")
		{
		Send, {down Down}
		sleep 1500
		Send, {down Up}p{enter}
		Return
		}
	
	If (OCR = "HashPatties")
		{
		Send, {down Down}
		sleep 1500
		Send, {down Up}ps{enter}
		Return
		}
	
	If (OCR = "GoldenHashBrowns")
		{
		Send, {down Down}
		sleep 1500
		Send, {down Up}ps{enter}
		Return
		}
	
;================FRENCH FRIES================
FrenchFries:

	If (OCR = "LiteFastFries")
		{
		Send, {down Down}
		sleep 2500
		Send, {down Up}p{enter}
		Return
		}
	
	If (OCR = "FastFries")
		{
		Send, {down Down}
		sleep 2600
		Send, {down Up}pa{enter}
		Return
		}
	
	If (OCR = "ThickCutLiteFries")
		{
		Send, {down Down}
		sleep 2500
		Send, {down Up}p{enter}
		Return
		}
	
	If (OCR = "ThickCutFries")
		{
		Send, {down Down}
		sleep 2500
		Send, {down Up}pa{enter}
		Return
		}

	If (OCR = "ThickCutSeaFries")
		{
		Send, {down Down}
		sleep 2500
		Send, {down Up}pe{enter}
		Return
		}

	If (OCR = "SweetPotatoFries")
		{
		Send, {down Down}
		sleep 2600
		Send, {down Up}pa{enter}
		Return
		}

	If (OCR = "SweetPotatoSeaFries")
		{
		Send, {down Down}
		sleep 2600
		Send, {down Up}pe{enter}
		Return
		}		

	If (OCR = "SweetestPotatoFries")
		{
		Send, {down Down}
		sleep 2600
		Send, {down Up}ps{enter}
		Return
		}

	If (OCR = "SweetPotatoMixFries")
		{
		Send, {down Down}
		sleep 2600
		Send, {down Up}pas{enter}
		Return
		}			
;================WINES================
Wine:
;SetKeyDelay, 50

	If (OCR = "LeCheapValu-Wlne" or OCR = "LeCheapValu-Wine")
		{
		Send, {up 30}{enter}
		Return
		}
			
	If (OCR = "CasuMarzu")
		{
		Send, w{up 30}{enter}
		Return
		}
		
	If (OCR = "SerpentBeard")
		{
		Send, ww{up 30}{enter}
		Return
		}
		
	If (OCR = "Elk")
		{
		Send, www{up 30}{enter}
		Return
		}
		
	If (OCR = "DeckardVineyards" or OCR = "DeckardVinevards")
		{
		Send, wwww{up 30}{enter}
		Return
		}


;================GRILL================	
Grill:

;================BURGERS================	
Burgers:

	 If (OCR = "TheOriginal" or OCR = "TheOriqinal")
		{
		Send, mlbct{enter}
		Return
		}
	
	If (OCR = "TheDoubule")
		{
		Send, mmlbct{enter}
		Return
		}
	
	If (OCR = "BLT")
		{
		Send, blt{enter}
		Return
		}
	
	If (OCR = "BLTandC")
		{
		Send, bltc{enter}
		Return
		}
	
	If (OCR = "TheHEARTSTOPPER!")
		{
		Send, mmbbc{enter}
		Return
		}

	If (OCR = "TheLiteDelight" or OCR = "TheLiteDeliqht")
		{
		Send, ml{enter}
		Return
		}
	
	If (OCR = "TheRyanDavis")
		{
		Send, mbcct{enter}
		Return
		}
	
	If (OCR = "TheTumbleweed")
		{
		Send, bc{enter}
		Return
		}
	
	If (OCR = "TheLonelyPatty" or OCR = "TheLonelvPattv" or OCR = "TheLonelyPattv")
		{
		Send, m{enter}
		Return
		}
	
	If (OCR = "TheTriple")
		{
		Send, mmmc{enter}
		Return
		}
	
	If (OCR = "TheTriplew/Bacon")
		{
		Send, mmmbc{enter}
		Return
		}
	
	If (OCR = "TheRED")
		{
		Send, mt{enter}
		Return
		}
		
	If (OCR = "TheVeggie" or OCR = "TheVeqme" or OCR = "TheVeqqie")
		{
		Send, ltp{enter}
		Return
		}
	
	If (OCR = "ThePickler")
		{
		Send, mcp{enter}
		Return
		}
	
	If (OCR = "TheTrio")
		{
		Send, mtp{enter}
		Return
		}
	
	If (OCR = "TheP-D")
		{
		Send, mmbp{enter}
		Return
		}
	
	If (OCR = "TheStacked")
		{
		Send, mlbctp{enter}
		Return
		}
	
	If (OCR = "TheGreens")
		{
		Send, mlp{enter}
		Return
		}
	
	If (OCR = "TheSuperSour")
		{
		Send, mtpo{enter}
		Return
		}
	
	If (OCR = "TheAroma!!!")
		{
		Send, mo{enter}
		Return
		}
	
	If (OCR = "TheExtraVeggies" or OCR = "TheExtraVeqqies")
		{
		Send, ltpo{enter}
		Return
		}
	
	If (OCR = "ThePOWER!")
		{
		Send, mmbco{enter}
		Return
		}
	
	If (OCR = "TheBLOT")
		{
		Send, blot{enter}
		Return
		}
	
	If (OCR = "TheC-BLOT")
		{
		Send, cblot{enter}
		Return
		}
	
	If (OCR = "TheCheesyBread" or OCR = "TheCheesvBread")
		{
		Send, bcs{enter}
		Return
		}
	
	If (OCR = "TheMELT!")
		{
		Send, mcs{enter}
		Return
		}
	
	If (OCR = "TheSwiss")
		{
		Send, mlts{enter}
		Return
		}
	
	If (OCR = "TheHolyBurger")
		{
		Send, mlos{enter}
		Return
		}
	
	If (OCR = "ChubigansSpecial" or OCR = "ChubiqansSpecial")
		{
		Send, mlbcs{enter}
		Return
		}
	
	If (OCR = "TheDoubleMelt")
		{
		Send, mmcs{enter}
		Return
		}
	
	If (OCR = "TheChick-a")
		{
		Send, kp{enter}
		Return
		}
	
	If (OCR = "TheChick-aDeluxe")
		{
		Send, kltp{enter}
		Return
		}
	
	If (OCR = "TheChick-aSurpreme")
		{
		Send, klbctp{enter}
		Return
		}
	
	If (OCR = "TheChick-aMelt")
		{
		Send, kbcps{enter}
		Return
		}
	
	If (OCR = "TheThreeCs")
		{
		Send, kcs{enter}
		Return
		}
	
	If (OCR = "TheDouble")
		{
		Send, mmlbct{enter}
		Return
		}
	
	If (OCR = "TheDoubleCs")
		{
		Send, kklp{enter}
		Return
		}
	
	If (OCR = "TheMeatLovers")
		{
		Send, kmb{enter}
		Return
		}
	
	If (OCR = "TheMIX")
		{
		Send, kmlct{enter}
		Return
		}
	
	If (OCR = "TheAmerican")
		{
		Send, kmbcos{enter}
		Return
		}
	
	If (OCR = "TheEVERYTHING" or OCR = "TheEVERYTHENG")
		{
		Send, mklpbocst{enter}
		Return
		}

;================BANANA FOSTER================
BananaFoster:

	If (OCR = "BananasFoster")
		{
		Send, bs
		Sleep 2000
		Send, a{enter}
		Return
		}
	
	If (OCR = "BananasFosterFlambe")
		{
		Send, bs
		Sleep 2000
		Send, arf{enter}
		Return
		}

;================NACHOS================
Nachos:
	
	If (OCR = "GuacandChips")
		{
		Send, ujt{enter}
		Return
		}
	
	If (OCR = "ClassicNachos")
		{
		Send, qg{enter}
		Return
		}
	
	If (OCR = "SurpremeNachos")
		{
		Send, qcjtg{enter}
		Return
		}
	
	If (OCR = "RoyalNachos" or OCR = "RovalNachos")
		{
		Send, qcuvjtog{enter}
		Return
		}
	
	If (OCR = "VeggieNachos" or OCR = "VeqqieNachos")
		{
		Send, qvjto{enter}
		Return
		}
	
	If (OCR = "SourVeggieNachos" or OCR = "SourVeqqieNachos")
		{
		Send, qcvjto{enter}
		Return
		}
	
	If (OCR = "GuacaNachos")
		{
		Send, qu{enter}
		Return
		}
	
	If (OCR = "FiestyNachos" or OCR = "FiestvNachos")
		{
		Send, qcujo{enter}
		Return
		}
	
	If (OCR = "GuacaChips")
		{
		Send, ujt{enter}
		Return
		}
	
	If (OCR = "Jalanacho")
		{
		Send, qj{enter}
		Return
		}
	
	If (OCR = "BowlofChips")
		{
		Send, {enter}
		Return
		}
	
	If (OCR = "ItalianStyleNachos" or OCR = "ItalianStvleNachos" or OCR = "ltalianStyleNachos" or OCR = "ltalianStvleNachos")
		{
		Send, qvog{enter}
		Return
		}
	
	If (OCR = "ScoopsofPlenty" or OCR = "ScoonsofPlenty" or OCR = "Sc00psofPlenty")
		{
		Send, qcuo{enter}
		Return
		}
	
	If (OCR = "TheChubigansSpecial" or OCR = "TheChubiqansSpecial")
		{
		Send, qbrg{enter}
		Return
		}
	
	If (OCR = "MexicanSiesta")
		{
		Send, qubrg{enter}
		Return
		}
	
	If (OCR = "MexicanFiesta")
		{
		Send, qcvjtobr{enter}
		Return
		}
	
	If (OCR = "RiceandBeans")
		{
		Send, qbr{enter}
		Return
		}
	
	If (OCR = "BeefandBeans")
		{
		Send, qbg{enter}
		Return
		}
	
	If (OCR = "SpicyRiceSpecial")
		{
		Send, qcjtor{enter}
		Return
		}
	
	If (OCR = "ShrimpNachos")
		{
		Send, qcujts{enter}
		Return
		}
	
	If (OCR = "DeluxeShrimpNachos" or OCR = "DeluxeShrimqNachos")
		{
		Send, qcuvjtobgs{enter}
		Return
		}
	
	If (OCR = "NewOrleansNachos")
		{
		Send, quvtbrs{enter}
		Return
		}
	
	If (OCR = "ClassicShrimpNachos")
		{
		Send, qcus{enter}
		Return
		}
	
	If (OCR = "BeefFajitaNachos" or OCR = "BeefFaiitaNachos")
		{
		Send, qcutobf{enter}
		Return
		}
	
	If (OCR = "ChickenFajitaNachos")
		{
		Send, qcutobk{enter}
		Return
		}
	
	If (OCR = "ComboFajitaNachos" or OCR = "ComboFaiitaNachos")
		{
		Send, qcutobkf{enter}
		Return
		}
	
	If (OCR = "EXTREMEFAJITAS!!!!!" or OCR = "EXTREMEFAIITAS!!!!!" or OCR = "EXTREMEFAJiTASEHH")
		{
		Send, qcjtobkfs{enter}
		Return
		}
	
	If (OCR = "ChubigansDeluxeSpecial" or OCR = "ChubiqansDeluxeSpecial")
		{
		Send, qbrkf{enter}
		Return
		}
	
	If (OCR = "ClassicAmerican")
		{
		Send, qcuvjtkfg{enter}
		Return
		}
	
	If (OCR = "FieryFiestaNachos" or OCR = "FiervFiestaNachos")
		{
		Send, qvjorks{enter}
		Return
		}
	
	If (OCR = "AllMeatSpecial")
		{
		Send, qcubkfsg{enter}
		Return
		}
	
	If (OCR = "BeefySupreme" or OCR = "BeefvSupreme" or OCR = "BeefySurpreme" or OCR = "BeefvSurpreme")
		{
		Send, qubfg{enter}
		Return
		}
	
	If (OCR = "FullyLoadedNachos" or OCR = "FullvLoadedNachos")
		{
		Send, qcuvjtobrgksf{enter}
		Return
		}

	Return
;================COFFEE================
Coffee: 

	If (OCR = "BlackCoffee")
		{
		Send, {down}{enter}
		Return
		}
	
	If (OCR = "CoffeewithCream")
		{
		Send, {down}c{enter}
		Return
		}

	If (OCR = "CoffeewithSugar")
		Goto CoffeewithSugar
	
	If (OCR = "FullyLoaded")
		Goto FullyLoadedCoffee

CoffeewithSugar:
Sugar_1 = 1
Sugar_2 = 2
Sugar_Z = Z
Sugar_3 = 3
Sugar_4 = 4
Sugar_5 = 5

	Sleep 250
	MouseMove, 419, 675, 2	;Bottom Left Corner of sugar amount
	Send, +{BS}
	Sleep 250
	MouseMove, 512, 650, 2	;Top right corner of sugar amount
	MouseClick left	;Finalize selection for OCR
	;ClipWait,2
	Sleep 500
	OCR = %clipboard% ;Raw OCR text
	;MsgBox DEBUG: OCR value is %clipboard%		
	
	IfInString, OCR, %Sugar_1%
	{
		;MsgBox Sugar amount is 1
		Send, {down}s{enter}
		Return
	}

	IfInString, OCR, %Sugar_Z%
	{
		;MsgBox Sugar amount is Z (2)
		Send, {down}ss{enter}
		Return
	}

	IfInString, OCR, %Sugar_2%
	{
		;MsgBox Sugar amount is 2
		Send, {down}ss{enter}
		Return
	}
	
	IfInString, OCR, %Sugar_3%
	{
		;MsgBox Sugar amount is 3
		Send, {down}sss{enter}
		Return
	}

	IfInString, OCR, %Sugar_4%
	{
		MsgBox, 4096, CSD OCR, OCR does not recognize the number 4. Please manually input recipe.
		;Send, {down}ssss{enter}
		Return
	}

	IfInString, OCR, %Sugar_5%
	{
		;MsgBox Sugar amount is 5
		Send, {down}sssss{enter}
		Return
	}
	
	Return
	
	
FullyLoadedCoffee:
Sugar_1 = 1
Sugar_2 = 2
Sugar_Z = Z
Sugar_3 = 3
Sugar_4 = 4
Sugar_5 = 5

	Sleep 250
	MouseMove, 549, 679, 2	;Bottom Left Corner of sugar amount
	Send, +{BS}
	Sleep 250
	MouseMove, 636, 651, 2	;Top right corner of sugar amount
	MouseClick left	;Finalize selection for OCR
	;ClipWait,2
	Sleep 500
	OCR = %clipboard% ;Raw OCR text
	;MsgBox DEBUG: OCR value is %clipboard%

	IfInString, OCR, %Sugar_1%
		{
		MsgBox, 4096, CSD OCR, Sorry. OCR cannot distinguish between 1 and 4 sugars.
		;Send, {down}cs{enter}
		Return
		}
	
	IfInString, OCR, %Sugar_2%
		{
		;MsgBox Sugar amount is 2
		Send, {down}css{enter}
		Return
		}

	IfInString, OCR, %Sugar_Z%
	{
		;MsgBox Sugar amount is Z (2)
		Send, {down}css{enter}
		Return
	}

	IfInString, OCR, %Sugar_3%
		{
		;MsgBox Sugar amount is 3
		Send, {down}csss{enter}
		Return
		}

	IfInString, OCR, %Sugar_4%
		{
		MsgBox, 4096, CSD OCR, Sorry. OCR cannot distinguish between 1 and 4 sugars. 
		;Send, {down}cssss{enter}
		Return
		}

	IfInString, OCR, %Sugar_5%
		{
		;MsgBox Sugar amount is 5	
		Send, {down}csssss{enter}
		Return
		}
	
	Return	

;================SOUPS================	
Soups:

SetKeyDelay, 200	;200 is the lowest value that can work with soups
	
	If (OCR = "ChickenNoodleSoup")
		{
		Send, kwuy{down 3}{enter}
		Return
		}
		
	If (OCR = "SoupduJour")
		{
		Send, wust{down 3}a{down 3}y{down 3}{enter}
		Return
		}
		
	If (OCR = "VegetableSoup")
		{
		Send, t{down 3}a{down 3}y{down 3}l{down 3}d{enter}
		Return
		}
		
	If (OCR = "BaristoboSoup")
		{
		Send, kwspa{down 3}l{down 3}{enter}
		Return
		}
		
	If (OCR = "CreamyPotato" or OCR = "CreamvPotato")
		{
		Send, spbc{enter}
		Return
		}
		
	If (OCR = "LouisianaDelight" or OCR = "LouisianaDeliqht")
		{
		Send, kmiusby{down 3}{enter}
		Return
		}
		
	If (OCR = "HeartyMeatSoup" or OCR = "HeatvMeatSoup")
		{
		Send, kmihpcy{down 3}g{enter}
		Return
		}
		
	If (OCR = "OneBeanSoup")
		{
		Send, ispy{down 3}e{enter}
		Return
		}
		
	If (OCR = "BroccoliSoup")
		{
		Send, sbca{down 3}r{enter}
		Return
		}
	
	If (OCR = "ItalianSoup" or OCR = "ltalianSoup")
		{
		Send, mibct{down 3}z{down 3}o{enter}
		Return
		}
	
	If (OCR = "SuinoStew")
		{
		Send, hwcl{down 3}z{down 3}go{enter}
		Return
		}

		

	

	
	
		