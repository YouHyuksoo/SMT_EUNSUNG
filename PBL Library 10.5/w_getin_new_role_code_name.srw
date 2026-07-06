HA$PBExportHeader$w_getin_new_role_code_name.srw
forward
global type w_getin_new_role_code_name from w_none_dw_popup_root
end type
type sle_role_code from so_singlelineedit within w_getin_new_role_code_name
end type
type sle_role_name from so_singlelineedit within w_getin_new_role_code_name
end type
type st_1 from so_statictext within w_getin_new_role_code_name
end type
type st_2 from so_statictext within w_getin_new_role_code_name
end type
type cb_1 from so_commandbutton within w_getin_new_role_code_name
end type
type gb_1 from so_groupbox within w_getin_new_role_code_name
end type
end forward

global type w_getin_new_role_code_name from w_none_dw_popup_root
integer width = 1792
integer height = 928
boolean controlmenu = false
long backcolor = 134217747
sle_role_code sle_role_code
sle_role_name sle_role_name
st_1 st_1
st_2 st_2
cb_1 cb_1
gb_1 gb_1
end type
global w_getin_new_role_code_name w_getin_new_role_code_name

on w_getin_new_role_code_name.create
int iCurrent
call super::create
this.sle_role_code=create sle_role_code
this.sle_role_name=create sle_role_name
this.st_1=create st_1
this.st_2=create st_2
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_role_code
this.Control[iCurrent+2]=this.sle_role_name
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.gb_1
end on

on w_getin_new_role_code_name.destroy
call super::destroy
destroy(this.sle_role_code)
destroy(this.sle_role_name)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.gb_1)
end on

event open;call super::open;sle_role_code.SETFOCUS()
end event

type p_title from w_none_dw_popup_root`p_title within w_getin_new_role_code_name
end type

type cb_close from w_none_dw_popup_root`cb_close within w_getin_new_role_code_name
boolean visible = true
integer x = 928
integer y = 620
integer taborder = 0
end type

type st_msg from w_none_dw_popup_root`st_msg within w_getin_new_role_code_name
boolean visible = true
integer y = 740
long backcolor = 134217747
boolean enabled = true
end type

type sle_role_code from so_singlelineedit within w_getin_new_role_code_name
integer x = 695
integer y = 348
integer width = 896
integer taborder = 10
boolean bringtotop = true
end type

type sle_role_name from so_singlelineedit within w_getin_new_role_code_name
integer x = 695
integer y = 452
integer width = 896
integer taborder = 20
boolean bringtotop = true
end type

type st_1 from so_statictext within w_getin_new_role_code_name
integer x = 160
integer y = 352
boolean bringtotop = true
integer weight = 700
long backcolor = 134217747
string text = "New Role Code"
alignment alignment = right!
long bordercolor = 1073741824
end type

type st_2 from so_statictext within w_getin_new_role_code_name
integer x = 160
integer y = 456
boolean bringtotop = true
integer weight = 700
long backcolor = 134217747
string text = "New Role Name"
alignment alignment = right!
long bordercolor = 134217747
end type

type cb_1 from so_commandbutton within w_getin_new_role_code_name
integer x = 649
integer y = 620
integer width = 274
integer height = 100
boolean bringtotop = true
string text = "Apply"
boolean default = true
end type

event clicked;call super::clicked;if sle_role_code.text = '' or isnull(sle_role_code.text) then 
else

	Gst_return.Gvs_return[1] = sle_role_code.text
	Gst_return.Gvs_return[2] = sle_role_name.text
	
	
	Gst_return.gvb_return = True
	
	Close( Parent)
	
end if
end event

type gb_1 from so_groupbox within w_getin_new_role_code_name
integer x = 123
integer y = 232
integer width = 1499
integer height = 356
integer weight = 700
long textcolor = 16711680
long backcolor = 134217747
string text = "Role Information"
end type

