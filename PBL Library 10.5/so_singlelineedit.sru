HA$PBExportHeader$so_singlelineedit.sru
$PBExportComments$System Object Single LIne Edit
forward
global type so_singlelineedit from singlelineedit
end type
end forward

global type so_singlelineedit from singlelineedit
integer width = 498
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
event ue_editchange pbm_enchange
end type
global so_singlelineedit so_singlelineedit

on so_singlelineedit.create
end on

on so_singlelineedit.destroy
end on

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

