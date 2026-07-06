HA$PBExportHeader$so_radiobutton.sru
$PBExportComments$System Object Radio Button
forward
global type so_radiobutton from radiobutton
end type
end forward

global type so_radiobutton from radiobutton
integer width = 498
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
end type
global so_radiobutton so_radiobutton

on so_radiobutton.create
end on

on so_radiobutton.destroy
end on

event rbuttondown;if Gvi_language_direct_change = 1 then 
		 OPENWITHPARM( W_DUAL_LANGUAGE_POPUP ,  this.text)
end if

end event

