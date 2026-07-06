HA$PBExportHeader$w_lock_by_config.srw
forward
global type w_lock_by_config from w_none_dw_popup_root
end type
type sle_password from so_singlelineedit within w_lock_by_config
end type
type st_1 from so_statictext within w_lock_by_config
end type
type sle_config_name from so_singlelineedit within w_lock_by_config
end type
type st_2 from so_statictext within w_lock_by_config
end type
type st_3 from so_statictext within w_lock_by_config
end type
type cb_exit from so_commandbutton within w_lock_by_config
end type
type gb_1 from so_groupbox within w_lock_by_config
end type
end forward

global type w_lock_by_config from w_none_dw_popup_root
integer width = 3255
integer height = 1444
boolean titlebar = false
boolean controlmenu = false
boolean contexthelp = false
sle_password sle_password
st_1 st_1
sle_config_name sle_config_name
st_2 st_2
st_3 st_3
cb_exit cb_exit
gb_1 gb_1
end type
global w_lock_by_config w_lock_by_config

type variables

end variables

on w_lock_by_config.create
int iCurrent
call super::create
this.sle_password=create sle_password
this.st_1=create st_1
this.sle_config_name=create sle_config_name
this.st_2=create st_2
this.st_3=create st_3
this.cb_exit=create cb_exit
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_password
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_config_name
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.cb_exit
this.Control[iCurrent+7]=this.gb_1
end on

on w_lock_by_config.destroy
call super::destroy
destroy(this.sle_password)
destroy(this.st_1)
destroy(this.sle_config_name)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.cb_exit)
destroy(this.gb_1)
end on

event open;call super::open;sle_password.setfocus()
sle_config_name.text = message.stringparm
end event

type p_title from w_none_dw_popup_root`p_title within w_lock_by_config
integer width = 3227
end type

type cb_close from w_none_dw_popup_root`cb_close within w_lock_by_config
boolean visible = true
integer x = 960
integer y = 908
integer width = 805
integer height = 156
integer taborder = 30
string text = "UnLock"
boolean default = true
end type

event cb_close::clicked;STRING LVS_CONFIG_NAME  , lvs_confg_value

LVS_CONFIG_NAME = sle_config_name.TEXT


SELECT config_value INTO :lvs_confg_value
 FROM ISYS_CONFIG 
 WHERE CONFIG_NAME = :LVS_CONFIG_NAME ;


if f_sql_check() < 0 then 
	return 
end if 

if  SLE_PASSWORD.TEXT = lvs_confg_value  then 
	
   gst_return.gvb_return = true 
   Close(parent)
else
	F_MSGBOX( 118 )
	sle_password.setfocus()
end if
end event

type st_msg from w_none_dw_popup_root`st_msg within w_lock_by_config
boolean visible = true
integer y = 1328
integer width = 3227
end type

type sle_password from so_singlelineedit within w_lock_by_config
integer x = 1312
integer y = 792
integer width = 635
integer taborder = 20
boolean bringtotop = true
integer weight = 700
long textcolor = 255
boolean password = true
end type

type st_1 from so_statictext within w_lock_by_config
integer x = 1307
integer y = 712
integer width = 635
boolean bringtotop = true
integer weight = 700
string text = "Password"
end type

type sle_config_name from so_singlelineedit within w_lock_by_config
integer x = 837
integer y = 616
integer width = 1637
integer taborder = 10
boolean bringtotop = true
long backcolor = 12632256
end type

type st_2 from so_statictext within w_lock_by_config
integer x = 837
integer y = 540
integer width = 1637
boolean bringtotop = true
integer weight = 700
string text = "User ID"
end type

type st_3 from so_statictext within w_lock_by_config
integer x = 530
integer y = 272
integer width = 2254
integer height = 164
boolean bringtotop = true
integer textsize = -20
integer weight = 700
long textcolor = 255
string text = "Input Password"
end type

type cb_exit from so_commandbutton within w_lock_by_config
integer x = 1765
integer y = 908
integer width = 805
integer height = 156
integer taborder = 40
boolean bringtotop = true
string text = "Cancel"
end type

event clicked;call super::clicked;gst_return.gvb_return = false
close(parent)
end event

type gb_1 from so_groupbox within w_lock_by_config
integer x = 667
integer y = 456
integer width = 1947
integer height = 668
end type

