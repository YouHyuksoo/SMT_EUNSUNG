HA$PBExportHeader$so_groupbox.sru
$PBExportComments$System Object Group Box
forward
global type so_groupbox from groupbox
end type
end forward

global type so_groupbox from groupbox
integer width = 549
integer height = 476
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
event ue_rbuttondown pbm_rbuttondown
end type
global so_groupbox so_groupbox

event ue_rbuttondown;if Gvi_language_direct_change = 1 then 
		 OPENWITHPARM( W_DUAL_LANGUAGE_POPUP ,  this.text)
end if

end event

on so_groupbox.create
end on

on so_groupbox.destroy
end on

