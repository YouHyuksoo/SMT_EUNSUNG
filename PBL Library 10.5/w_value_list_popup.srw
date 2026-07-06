HA$PBExportHeader$w_value_list_popup.srw
forward
global type w_value_list_popup from w_popup_root
end type
type st_20 from statictext within w_value_list_popup
end type
type sle_code_type from singlelineedit within w_value_list_popup
end type
type cb_1 from commandbutton within w_value_list_popup
end type
type cb_2 from commandbutton within w_value_list_popup
end type
type cb_3 from commandbutton within w_value_list_popup
end type
type gb_1 from so_groupbox within w_value_list_popup
end type
type gb_2 from so_groupbox within w_value_list_popup
end type
end forward

global type w_value_list_popup from w_popup_root
integer width = 3150
integer height = 2192
string title = "Basecode List"
st_20 st_20
sle_code_type sle_code_type
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
gb_1 gb_1
gb_2 gb_2
end type
global w_value_list_popup w_value_list_popup

event open;call super::open;SLE_CODE_TYPE.TEXT = MESSAGE.STRINGPARM
DW_1.RETRIEVE(SLE_CODE_TYPE.TEXT , GVI_ORGANIZATION_ID)
end event

on w_value_list_popup.create
int iCurrent
call super::create
this.st_20=create st_20
this.sle_code_type=create sle_code_type
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_20
this.Control[iCurrent+2]=this.sle_code_type
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.cb_3
this.Control[iCurrent+6]=this.gb_1
this.Control[iCurrent+7]=this.gb_2
end on

on w_value_list_popup.destroy
call super::destroy
destroy(this.st_20)
destroy(this.sle_code_type)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.gb_1)
destroy(this.gb_2)
end on

type p_title from w_popup_root`p_title within w_value_list_popup
integer width = 3136
end type

type cb_sort from w_popup_root`cb_sort within w_value_list_popup
boolean visible = true
integer x = 2405
integer y = 324
integer width = 343
end type

type cb_close from w_popup_root`cb_close within w_value_list_popup
boolean visible = true
integer x = 2747
integer y = 324
integer width = 343
end type

type st_msg from w_popup_root`st_msg within w_value_list_popup
boolean visible = true
integer y = 520
integer width = 3136
boolean enabled = true
end type

type dw_1 from w_popup_root`dw_1 within w_value_list_popup
boolean visible = true
integer y = 616
integer width = 3136
integer height = 1492
string dataobject = "d_value_list_popup"
end type

type dw_2 from w_popup_root`dw_2 within w_value_list_popup
boolean visible = true
integer y = 616
end type

type dw_3 from w_popup_root`dw_3 within w_value_list_popup
integer y = 616
end type

type st_20 from statictext within w_value_list_popup
integer x = 242
integer y = 300
integer width = 850
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Code Type"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_code_type from singlelineedit within w_value_list_popup
integer x = 23
integer y = 368
integer width = 1189
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_value_list_popup
integer x = 1367
integer y = 324
integer width = 343
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE(SLE_CODE_TYPE.TEXT, GVI_ORGANIZATION_ID)
end event

type cb_2 from commandbutton within w_value_list_popup
integer x = 1714
integer y = 324
integer width = 343
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Insert"
end type

event clicked;int row 
row = dw_1.insertrow(0)
dw_1.scrolltorow(row)
f_set_security_row( dw_1 , row , 'ALL') 


end event

type cb_3 from commandbutton within w_value_list_popup
integer x = 2062
integer y = 324
integer width = 343
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Update"
end type

event clicked;if dw_1.update() < 0 then 
	rollback;
else
	commit ;
	f_msgbox(170)
end if
end event

type gb_1 from so_groupbox within w_value_list_popup
integer x = 1312
integer y = 232
integer width = 1815
integer height = 276
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_value_list_popup
integer y = 232
integer width = 1243
integer height = 276
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

