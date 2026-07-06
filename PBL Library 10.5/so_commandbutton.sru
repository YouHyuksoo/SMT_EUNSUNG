HA$PBExportHeader$so_commandbutton.sru
$PBExportComments$Command Button System Object
forward
global type so_commandbutton from commandbutton
end type
end forward

global type so_commandbutton from commandbutton
integer width = 530
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
end type
global so_commandbutton so_commandbutton

on so_commandbutton.create
end on

on so_commandbutton.destroy
end on

event rbuttondown;if Gvi_language_direct_change = 1 then 
		 OPENWITHPARM( W_DUAL_LANGUAGE_POPUP ,  this.text)
end if

end event

