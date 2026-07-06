HA$PBExportHeader$so_multilineedit_tooltip.sru
forward
global type so_multilineedit_tooltip from multilineedit
end type
end forward

global type so_multilineedit_tooltip from multilineedit
integer width = 1541
integer height = 240
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 65535
end type
global so_multilineedit_tooltip so_multilineedit_tooltip

on so_multilineedit_tooltip.create
end on

on so_multilineedit_tooltip.destroy
end on

event constructor;this.text = message.stringparm
end event

