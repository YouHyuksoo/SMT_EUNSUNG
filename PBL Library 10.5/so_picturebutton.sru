HA$PBExportHeader$so_picturebutton.sru
$PBExportComments$System Picture Button Object
forward
global type so_picturebutton from picturebutton
end type
end forward

global type so_picturebutton from picturebutton
integer width = 503
integer height = 100
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean originalsize = true
alignment htextalign = left!
end type
global so_picturebutton so_picturebutton

on so_picturebutton.create
end on

on so_picturebutton.destroy
end on

event rbuttondown;if Gvi_language_direct_change = 1 then 
		 OPENWITHPARM( W_DUAL_LANGUAGE_POPUP ,  this.text)
end if

end event

