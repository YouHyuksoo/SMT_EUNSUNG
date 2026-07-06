HA$PBExportHeader$so_statictext.sru
$PBExportComments$System Object Static Text
forward
global type so_statictext from statictext
end type
end forward

global type so_statictext from statictext
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
alignment alignment = center!
boolean focusrectangle = false
end type
global so_statictext so_statictext

on so_statictext.create
end on

on so_statictext.destroy
end on

event rbuttondown;if Gvi_language_direct_change = 1 then 
		 OPENWITHPARM( W_DUAL_LANGUAGE_POPUP ,  this.text)
end if

end event

