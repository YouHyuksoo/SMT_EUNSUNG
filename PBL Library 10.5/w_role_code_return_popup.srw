HA$PBExportHeader$w_role_code_return_popup.srw
forward
global type w_role_code_return_popup from w_none_dw_popup_root
end type
type st_1 from so_statictext within w_role_code_return_popup
end type
type sle_dest_role_code from so_singlelineedit within w_role_code_return_popup
end type
type sle_dest_role_name from so_singlelineedit within w_role_code_return_popup
end type
type st_2 from so_statictext within w_role_code_return_popup
end type
type cb_1 from so_commandbutton within w_role_code_return_popup
end type
type gb_1 from so_groupbox within w_role_code_return_popup
end type
end forward

global type w_role_code_return_popup from w_none_dw_popup_root
integer width = 1696
integer height = 788
st_1 st_1
sle_dest_role_code sle_dest_role_code
sle_dest_role_name sle_dest_role_name
st_2 st_2
cb_1 cb_1
gb_1 gb_1
end type
global w_role_code_return_popup w_role_code_return_popup

on w_role_code_return_popup.create
int iCurrent
call super::create
this.st_1=create st_1
this.sle_dest_role_code=create sle_dest_role_code
this.sle_dest_role_name=create sle_dest_role_name
this.st_2=create st_2
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.sle_dest_role_code
this.Control[iCurrent+3]=this.sle_dest_role_name
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.gb_1
end on

on w_role_code_return_popup.destroy
call super::destroy
destroy(this.st_1)
destroy(this.sle_dest_role_code)
destroy(this.sle_dest_role_name)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.gb_1)
end on

type p_title from w_none_dw_popup_root`p_title within w_role_code_return_popup
integer x = 14
integer width = 1673
end type

type cb_close from w_none_dw_popup_root`cb_close within w_role_code_return_popup
boolean visible = true
integer x = 832
integer width = 306
end type

type st_msg from w_none_dw_popup_root`st_msg within w_role_code_return_popup
boolean visible = true
integer x = 14
integer y = 200
integer width = 1673
integer height = 100
boolean enabled = true
end type

type st_1 from so_statictext within w_role_code_return_popup
integer x = 329
integer y = 340
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Dest Role Code"
end type

type sle_dest_role_code from so_singlelineedit within w_role_code_return_popup
integer x = 334
integer y = 416
integer taborder = 10
boolean bringtotop = true
long backcolor = 16777215
end type

type sle_dest_role_name from so_singlelineedit within w_role_code_return_popup
integer x = 837
integer y = 416
integer taborder = 20
boolean bringtotop = true
long backcolor = 16777215
end type

type st_2 from so_statictext within w_role_code_return_popup
integer x = 837
integer y = 348
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Dest Role Name"
end type

type cb_1 from so_commandbutton within w_role_code_return_popup
integer x = 521
integer y = 568
integer width = 306
integer height = 100
integer taborder = 20
boolean bringtotop = true
string text = "Apply"
boolean default = true
end type

event clicked;call super::clicked;if sle_dest_role_code.text = '' then 
else
	gst_return.gvs_return[1] = sle_dest_role_name.text
	closewithreturn( parent , sle_dest_role_code.text)
end if
end event

type gb_1 from so_groupbox within w_role_code_return_popup
integer x = 78
integer y = 288
integer width = 1568
integer height = 260
integer taborder = 10
end type

