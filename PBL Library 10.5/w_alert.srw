HA$PBExportHeader$w_alert.srw
forward
global type w_alert from w_none_dw_popup_root
end type
type cb_exit from so_commandbutton within w_alert
end type
type mle_text from multilineedit within w_alert
end type
type p_1 from picture within w_alert
end type
type ln_1 from line within w_alert
end type
end forward

global type w_alert from w_none_dw_popup_root
integer width = 1755
integer height = 1644
string title = "Alert Message"
boolean controlmenu = false
long backcolor = 67108864
boolean clientedge = true
cb_exit cb_exit
mle_text mle_text
p_1 p_1
ln_1 ln_1
end type
global w_alert w_alert

type variables

end variables

on w_alert.create
int iCurrent
call super::create
this.cb_exit=create cb_exit
this.mle_text=create mle_text
this.p_1=create p_1
this.ln_1=create ln_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_exit
this.Control[iCurrent+2]=this.mle_text
this.Control[iCurrent+3]=this.p_1
this.Control[iCurrent+4]=this.ln_1
end on

on w_alert.destroy
call super::destroy
destroy(this.cb_exit)
destroy(this.mle_text)
destroy(this.p_1)
destroy(this.ln_1)
end on

event open;call super::open;MLE_TEXT.TEXT = F_GET_ALERT_MESSAGE()
cb_exit.setfocus()
end event

type p_title from w_none_dw_popup_root`p_title within w_alert
integer x = 14
integer width = 1696
end type

type cb_close from w_none_dw_popup_root`cb_close within w_alert
integer y = 1592
end type

type st_msg from w_none_dw_popup_root`st_msg within w_alert
integer y = 1716
end type

type cb_exit from so_commandbutton within w_alert
integer x = 1390
integer y = 1436
integer width = 325
integer height = 104
integer taborder = 20
string text = "Exit"
boolean default = true
end type

event clicked;call super::clicked;Close(parent)
end event

type mle_text from multilineedit within w_alert
integer x = 480
integer y = 408
integer width = 937
integer height = 792
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 65535
boolean border = false
boolean autohscroll = true
boolean autovscroll = true
alignment alignment = center!
borderstyle borderstyle = stylelowered!
end type

type p_1 from picture within w_alert
integer x = 14
integer y = 212
integer width = 1696
integer height = 1196
string picturename = "alert_notepad.wmf"
boolean focusrectangle = false
end type

type ln_1 from line within w_alert
long linecolor = 16776960
integer linethickness = 6
integer beginx = 27
integer beginy = 1428
integer endx = 1705
integer endy = 1428
end type

