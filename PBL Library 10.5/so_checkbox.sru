HA$PBExportHeader$so_checkbox.sru
$PBExportComments$System Object Check Box
forward
global type so_checkbox from checkbox
end type
end forward

global type so_checkbox from checkbox
integer width = 457
integer height = 96
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
end type
global so_checkbox so_checkbox

on so_checkbox.create
end on

on so_checkbox.destroy
end on

event rbuttondown;if Gvi_language_direct_change = 1 then 
		 OPENWITHPARM( W_DUAL_LANGUAGE_POPUP ,  this.text)
end if

end event

