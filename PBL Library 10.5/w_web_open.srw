HA$PBExportHeader$w_web_open.srw
forward
global type w_web_open from window
end type
type cb_1 from commandbutton within w_web_open
end type
end forward

global type w_web_open from window
integer width = 1691
integer height = 852
windowtype windowtype = child!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_1 cb_1
end type
global w_web_open w_web_open

on w_web_open.create
this.cb_1=create cb_1
this.Control[]={this.cb_1}
end on

on w_web_open.destroy
destroy(this.cb_1)
end on

type cb_1 from commandbutton within w_web_open
integer x = 709
integer y = 604
integer width = 402
integer height = 92
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "OPen"
end type

event clicked;open(w_logon)
end event

