HA$PBExportHeader$w_edit_window.srw
$PBExportComments$$$HEX7$$38bb90c7b8d3d1c908c7c4b3b0c6$$ENDHEX$$
forward
global type w_edit_window from window
end type
type cb_2 from commandbutton within w_edit_window
end type
type cb_1 from commandbutton within w_edit_window
end type
type mle_1 from multilineedit within w_edit_window
end type
end forward

global type w_edit_window from window
integer x = 827
integer y = 576
integer width = 2990
integer height = 1980
boolean titlebar = true
string title = "Edit Control"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79741120
boolean center = true
cb_2 cb_2
cb_1 cb_1
mle_1 mle_1
end type
global w_edit_window w_edit_window

on w_edit_window.create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.mle_1=create mle_1
this.Control[]={this.cb_2,&
this.cb_1,&
this.mle_1}
end on

on w_edit_window.destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.mle_1)
end on

event open;Gst_return.gvb_return = false
if message.stringparm = '' then 
	mle_1.setfocus()
else
	mle_1.text = message.stringparm
end if
end event

event key;IF key = keyescape! THEN 
	CB_2.TRIGGEREVENT('CLICKED')
END IF

end event

type cb_2 from commandbutton within w_edit_window
integer x = 1522
integer y = 1784
integer width = 640
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel[Esc]"
end type

event clicked;Gst_return.gvb_return = false
closewithreturn(parent, '')
end event

type cb_1 from commandbutton within w_edit_window
integer x = 878
integer y = 1784
integer width = 640
integer height = 92
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Confirm[Ctrl+Enter]"
end type

event clicked;Gst_return.gvb_return = true
closewithreturn(parent ,string(mle_1.text))
end event

type mle_1 from multilineedit within w_edit_window
integer x = 23
integer y = 16
integer width = 2953
integer height = 1744
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean hscrollbar = true
boolean vscrollbar = true
boolean autohscroll = true
boolean autovscroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;this.text = message.stringParm
end event

