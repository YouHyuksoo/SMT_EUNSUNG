HA$PBExportHeader$uo_menu_list.sru
$PBExportComments$Organization
forward
global type uo_menu_list from dropdownlistbox
end type
end forward

global type uo_menu_list from dropdownlistbox
integer width = 512
integer height = 784
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean vscrollbar = true
string item[] = {"M_MAIN_FRAME_MENU","M_MAIN_PRINT_MENU"}
borderstyle borderstyle = stylelowered!
end type
global uo_menu_list uo_menu_list

forward prototypes
public function string getcode ()
public function string getname ()
end prototypes

public function string getcode ();RETURN TRIM(MID( THIS.TEXT ,  1, POS( THIS.TEXT , ':' ) -1 ))
end function

public function string getname ();RETURN TRIM(MID( THIS.TEXT ,  POS( THIS.TEXT , ':' )+1  , LEN(THIS.TEXT) ))
end function

on uo_menu_list.create
end on

on uo_menu_list.destroy
end on

