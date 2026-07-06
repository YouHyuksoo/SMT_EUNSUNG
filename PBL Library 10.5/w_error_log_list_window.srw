HA$PBExportHeader$w_error_log_list_window.srw
$PBExportComments$$$HEX7$$38bb90c7b8d3d1c908c7c4b3b0c6$$ENDHEX$$
forward
global type w_error_log_list_window from window
end type
type cb_2 from commandbutton within w_error_log_list_window
end type
type mle_1 from multilineedit within w_error_log_list_window
end type
end forward

global type w_error_log_list_window from window
integer x = 827
integer y = 576
integer width = 2158
integer height = 1980
boolean titlebar = true
boolean controlmenu = true
boolean minbox = true
windowtype windowtype = popup!
long backcolor = 79741120
cb_2 cb_2
mle_1 mle_1
end type
global w_error_log_list_window w_error_log_list_window

on w_error_log_list_window.create
this.cb_2=create cb_2
this.mle_1=create mle_1
this.Control[]={this.cb_2,&
this.mle_1}
end on

on w_error_log_list_window.destroy
destroy(this.cb_2)
destroy(this.mle_1)
end on

event open;this.setredraw( false)
f_set_layered_window( handle(this) , 85 )

Gst_return.gvb_return = false
if message.stringparm = '' then 
	mle_1.setfocus()
else
	mle_1.text = message.stringparm
end if

this.setredraw( true)
end event

event key;IF key = keyescape! THEN 
	CB_2.TRIGGEREVENT('CLICKED')
END IF

end event

type cb_2 from commandbutton within w_error_log_list_window
integer x = 695
integer y = 1768
integer width = 640
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Close"
end type

event clicked;Close(parent)
end event

type mle_1 from multilineedit within w_error_log_list_window
integer width = 2149
integer height = 1744
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean hscrollbar = true
boolean vscrollbar = true
boolean autohscroll = true
boolean autovscroll = true
borderstyle borderstyle = stylelowered!
boolean hideselection = false
end type

event constructor;this.text = message.stringParm
end event

