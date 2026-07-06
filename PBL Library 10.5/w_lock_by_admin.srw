HA$PBExportHeader$w_lock_by_admin.srw
forward
global type w_lock_by_admin from w_none_dw_popup_root
end type
type sle_password from so_singlelineedit within w_lock_by_admin
end type
type st_1 from so_statictext within w_lock_by_admin
end type
type sle_user_id from so_singlelineedit within w_lock_by_admin
end type
type st_2 from so_statictext within w_lock_by_admin
end type
type st_3 from so_statictext within w_lock_by_admin
end type
type gb_1 from so_groupbox within w_lock_by_admin
end type
end forward

global type w_lock_by_admin from w_none_dw_popup_root
integer width = 4443
integer height = 2064
boolean titlebar = false
boolean controlmenu = false
boolean contexthelp = false
sle_password sle_password
st_1 st_1
sle_user_id sle_user_id
st_2 st_2
st_3 st_3
gb_1 gb_1
end type
global w_lock_by_admin w_lock_by_admin

type variables

end variables

on w_lock_by_admin.create
int iCurrent
call super::create
this.sle_password=create sle_password
this.st_1=create st_1
this.sle_user_id=create sle_user_id
this.st_2=create st_2
this.st_3=create st_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_password
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_user_id
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.gb_1
end on

on w_lock_by_admin.destroy
call super::destroy
destroy(this.sle_password)
destroy(this.st_1)
destroy(this.sle_user_id)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.gb_1)
end on

event open;call super::open;sle_user_id.setfocus()

end event

type p_title from w_none_dw_popup_root`p_title within w_lock_by_admin
integer width = 4443
end type

type cb_close from w_none_dw_popup_root`cb_close within w_lock_by_admin
boolean visible = true
integer x = 1687
integer y = 832
integer width = 805
integer height = 156
integer taborder = 30
string text = "UnLock"
boolean default = true
end type

event cb_close::clicked;if F_CHECK_IS_ADMIN_YN( SLE_USER_ID.TEXT , SLE_PASSWORD.TEXT ) = 1 then 
   Close(parent)
else
F_MSGBOX( 118 )
sle_password.setfocus()
end if
end event

type st_msg from w_none_dw_popup_root`st_msg within w_lock_by_admin
boolean visible = true
integer x = 9
integer y = 1952
integer width = 4421
end type

type sle_password from so_singlelineedit within w_lock_by_admin
integer x = 1774
integer y = 708
integer width = 635
integer taborder = 20
boolean bringtotop = true
integer weight = 700
long textcolor = 255
boolean password = true
end type

type st_1 from so_statictext within w_lock_by_admin
integer x = 1774
integer y = 628
integer width = 635
boolean bringtotop = true
integer weight = 700
string text = "Password"
end type

type sle_user_id from so_singlelineedit within w_lock_by_admin
integer x = 1778
integer y = 536
integer width = 635
integer taborder = 10
boolean bringtotop = true
long backcolor = 16777215
end type

type st_2 from so_statictext within w_lock_by_admin
integer x = 1778
integer y = 452
integer width = 635
boolean bringtotop = true
integer weight = 700
string text = "User ID"
end type

type st_3 from so_statictext within w_lock_by_admin
integer x = 142
integer y = 1320
integer width = 4137
integer height = 360
boolean bringtotop = true
integer textsize = -50
integer weight = 700
long textcolor = 255
string text = "Call Your Manager"
end type

type gb_1 from so_groupbox within w_lock_by_admin
integer x = 1568
integer y = 376
integer width = 997
integer height = 668
end type

