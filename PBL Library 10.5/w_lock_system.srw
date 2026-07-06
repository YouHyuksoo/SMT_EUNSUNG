HA$PBExportHeader$w_lock_system.srw
forward
global type w_lock_system from w_none_dw_popup_root
end type
type cb_lock from so_commandbutton within w_lock_system
end type
type sle_password from so_singlelineedit within w_lock_system
end type
type st_1 from so_statictext within w_lock_system
end type
type p_1 from picture within w_lock_system
end type
type sle_1 from so_singlelineedit within w_lock_system
end type
type st_2 from so_statictext within w_lock_system
end type
type gb_1 from so_groupbox within w_lock_system
end type
end forward

global type w_lock_system from w_none_dw_popup_root
integer width = 2194
integer height = 1172
string title = "System Locked"
boolean controlmenu = false
cb_lock cb_lock
sle_password sle_password
st_1 st_1
p_1 p_1
sle_1 sle_1
st_2 st_2
gb_1 gb_1
end type
global w_lock_system w_lock_system

type variables

end variables

on w_lock_system.create
int iCurrent
call super::create
this.cb_lock=create cb_lock
this.sle_password=create sle_password
this.st_1=create st_1
this.p_1=create p_1
this.sle_1=create sle_1
this.st_2=create st_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_lock
this.Control[iCurrent+2]=this.sle_password
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.p_1
this.Control[iCurrent+5]=this.sle_1
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.gb_1
end on

on w_lock_system.destroy
call super::destroy
destroy(this.cb_lock)
destroy(this.sle_password)
destroy(this.st_1)
destroy(this.p_1)
destroy(this.sle_1)
destroy(this.st_2)
destroy(this.gb_1)
end on

event open;call super::open;sle_password.setfocus()
cb_lock.triggerevent(clicked!)
end event

type p_title from w_none_dw_popup_root`p_title within w_lock_system
integer width = 2181
end type

type cb_close from w_none_dw_popup_root`cb_close within w_lock_system
boolean visible = true
integer x = 1298
integer y = 784
integer width = 329
integer taborder = 30
boolean enabled = false
string text = "UnLock"
boolean default = true
end type

event cb_close::clicked;if sle_password.text = Gvs_password then 
   Close(parent)
else
F_MSGBOX( 118 )
sle_password.setfocus()
end if
end event

type st_msg from w_none_dw_popup_root`st_msg within w_lock_system
boolean visible = true
integer y = 996
integer width = 2181
end type

type cb_lock from so_commandbutton within w_lock_system
integer x = 960
integer y = 784
integer width = 329
integer height = 100
integer taborder = 20
boolean bringtotop = true
string text = "Lock"
end type

event clicked;call super::clicked;this.enabled = false
cb_close.enabled = true

st_msg.text = "System Locked at "+string( f_sysdate() )
end event

type sle_password from so_singlelineedit within w_lock_system
integer x = 987
integer y = 600
integer width = 635
integer taborder = 10
boolean bringtotop = true
integer weight = 700
long textcolor = 255
boolean password = true
end type

type st_1 from so_statictext within w_lock_system
integer x = 987
integer y = 520
integer width = 635
boolean bringtotop = true
integer weight = 700
string text = "Password"
end type

type p_1 from picture within w_lock_system
integer width = 494
integer height = 992
boolean bringtotop = true
string picturename = "lock_left.jpg"
boolean border = true
boolean focusrectangle = false
end type

type sle_1 from so_singlelineedit within w_lock_system
integer x = 992
integer y = 428
integer width = 635
boolean bringtotop = true
long backcolor = 12632256
end type

event constructor;call super::constructor;this.text = Gvs_user_id
end event

type st_2 from so_statictext within w_lock_system
integer x = 992
integer y = 344
integer width = 635
boolean bringtotop = true
integer weight = 700
string text = "User ID"
end type

type gb_1 from so_groupbox within w_lock_system
integer x = 782
integer y = 268
integer width = 997
integer height = 668
end type

