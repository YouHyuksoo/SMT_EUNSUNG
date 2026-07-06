HA$PBExportHeader$w_des_parent_item_from_bom_popup.srw
$PBExportComments$(Item Query)-$$HEX4$$80bd88d470c88cd6$$ENDHEX$$
forward
global type w_des_parent_item_from_bom_popup from w_popup_root
end type
type st_1 from statictext within w_des_parent_item_from_bom_popup
end type
type sle_item_name from singlelineedit within w_des_parent_item_from_bom_popup
end type
type cb_select from commandbutton within w_des_parent_item_from_bom_popup
end type
type cb_retrieve from commandbutton within w_des_parent_item_from_bom_popup
end type
type st_2 from statictext within w_des_parent_item_from_bom_popup
end type
type ddlb_line_type from uo_line_type within w_des_parent_item_from_bom_popup
end type
type st_3 from statictext within w_des_parent_item_from_bom_popup
end type
type sle_item_code from singlelineedit within w_des_parent_item_from_bom_popup
end type
type st_7 from statictext within w_des_parent_item_from_bom_popup
end type
type sle_1 from singlelineedit within w_des_parent_item_from_bom_popup
end type
type gb_1 from so_groupbox within w_des_parent_item_from_bom_popup
end type
type gb_2 from so_groupbox within w_des_parent_item_from_bom_popup
end type
end forward

global type w_des_parent_item_from_bom_popup from w_popup_root
integer width = 3785
integer height = 2156
string title = "Item Master Popup"
st_1 st_1
sle_item_name sle_item_name
cb_select cb_select
cb_retrieve cb_retrieve
st_2 st_2
ddlb_line_type ddlb_line_type
st_3 st_3
sle_item_code sle_item_code
st_7 st_7
sle_1 sle_1
gb_1 gb_1
gb_2 gb_2
end type
global w_des_parent_item_from_bom_popup w_des_parent_item_from_bom_popup

on w_des_parent_item_from_bom_popup.create
int iCurrent
call super::create
this.st_1=create st_1
this.sle_item_name=create sle_item_name
this.cb_select=create cb_select
this.cb_retrieve=create cb_retrieve
this.st_2=create st_2
this.ddlb_line_type=create ddlb_line_type
this.st_3=create st_3
this.sle_item_code=create sle_item_code
this.st_7=create st_7
this.sle_1=create sle_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.sle_item_name
this.Control[iCurrent+3]=this.cb_select
this.Control[iCurrent+4]=this.cb_retrieve
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.ddlb_line_type
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.sle_item_code
this.Control[iCurrent+9]=this.st_7
this.Control[iCurrent+10]=this.sle_1
this.Control[iCurrent+11]=this.gb_1
this.Control[iCurrent+12]=this.gb_2
end on

on w_des_parent_item_from_bom_popup.destroy
call super::destroy
destroy(this.st_1)
destroy(this.sle_item_name)
destroy(this.cb_select)
destroy(this.cb_retrieve)
destroy(this.st_2)
destroy(this.ddlb_line_type)
destroy(this.st_3)
destroy(this.sle_item_code)
destroy(this.st_7)
destroy(this.sle_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;dw_1.settransobject(sqlca)

SLE_ITEM_CODE.TEXT = message.stringparm

CB_RETRIEVE.TRIGGEREVENT(CLICKED!)
SLE_ITEM_CODE.SETFOCUS()
end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
end if
end event

type p_title from w_popup_root`p_title within w_des_parent_item_from_bom_popup
integer width = 3771
end type

type cb_sort from w_popup_root`cb_sort within w_des_parent_item_from_bom_popup
boolean visible = true
integer x = 1947
integer y = 304
integer width = 347
integer height = 104
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_des_parent_item_from_bom_popup
boolean visible = true
integer x = 3003
integer y = 304
integer width = 347
integer height = 104
integer taborder = 0
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_des_parent_item_from_bom_popup
boolean visible = true
integer y = 484
integer width = 3771
end type

type dw_1 from w_popup_root`dw_1 within w_des_parent_item_from_bom_popup
boolean visible = true
integer y = 576
integer width = 3771
integer height = 1304
integer taborder = 70
boolean titlebar = true
string title = "Parent Item List"
string dataobject = "d_des_parent_item_from_bom_popup"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
CB_SELECT.TRIGGEREVENT(CLICKED!)
end event

type dw_2 from w_popup_root`dw_2 within w_des_parent_item_from_bom_popup
boolean visible = true
integer y = 584
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_des_parent_item_from_bom_popup
integer y = 676
end type

type st_1 from statictext within w_des_parent_item_from_bom_popup
integer x = 462
integer y = 264
integer width = 398
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
boolean enabled = false
string text = "Item Name"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_item_name from singlelineedit within w_des_parent_item_from_bom_popup
event ue_editchange pbm_enchange
integer x = 462
integer y = 332
integer width = 398
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean autohscroll = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event ue_editchange;STRING LVS_item_name
DW_1.SETFILTER('')
DW_1.FILTER()

IF THIS.TEXT = '' THEN 
	
	IVD_SELECTED_DATA_WINDOW.SETFILTER('')
	IVD_SELECTED_DATA_WINDOW.FILTER()	
	RETURN 
ELSE
	LVS_item_name = '%'+this.text+'%'
END IF

DW_1.SETFILTER("item_name LIKE '"+LVS_item_name+"'")
DW_1.FILTER()

end event

type cb_select from commandbutton within w_des_parent_item_from_bom_popup
integer x = 2651
integer y = 304
integer width = 347
integer height = 104
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Select"
boolean default = true
end type

event clicked;IF DW_1.GETROW() = 0  THEN 
	gst_return.gvb_return = false
	RETURN -1
END IF
gst_return.gvb_return = true 

MESSAGE.STRINGPARM= DW_1.GETITEMSTRING( DW_1.GETROW() , 'parent_item_code')
Gst_return.gvs_return[1] = DW_1.GETITEMSTRING( DW_1.GETROW() , 'child_item_code')
CLOSEWITHRETURN(PARENT , MESSAGE.STRINGPARM )
end event

type cb_retrieve from commandbutton within w_des_parent_item_from_bom_popup
integer x = 2299
integer y = 304
integer width = 347
integer height = 104
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE(SLE_ITEM_CODE.TEXT+'%' ,  DDLB_LINE_TYPE.GETCODE()+'%' , GVI_ORGANIZATION_ID )
end event

type st_2 from statictext within w_des_parent_item_from_bom_popup
integer x = 37
integer y = 268
integer width = 421
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Item Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_line_type from uo_line_type within w_des_parent_item_from_bom_popup
integer x = 1367
integer y = 328
integer width = 457
integer taborder = 50
boolean bringtotop = true
boolean autohscroll = true
end type

type st_3 from statictext within w_des_parent_item_from_bom_popup
integer x = 1367
integer y = 260
integer width = 457
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
boolean enabled = false
string text = "Line Type"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_item_code from singlelineedit within w_des_parent_item_from_bom_popup
event ue_editchange pbm_enchange
integer x = 37
integer y = 332
integer width = 421
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type st_7 from statictext within w_des_parent_item_from_bom_popup
integer x = 859
integer y = 264
integer width = 494
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
boolean enabled = false
string text = "Item Spec"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_des_parent_item_from_bom_popup
event ue_editchange pbm_enchange
integer x = 864
integer y = 332
integer width = 494
integer height = 84
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean autohscroll = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event ue_editchange;STRING LVS_item_name
DW_1.SETFILTER('')
DW_1.FILTER()

IF THIS.TEXT = '' THEN 
	
	IVD_SELECTED_DATA_WINDOW.SETFILTER('')
	IVD_SELECTED_DATA_WINDOW.FILTER()	
	RETURN 
ELSE
	LVS_item_name = '%'+this.text+'%'
END IF

DW_1.SETFILTER("item_spec LIKE '"+LVS_item_name+"'")
DW_1.FILTER()

end event

type gb_1 from so_groupbox within w_des_parent_item_from_bom_popup
integer y = 196
integer width = 1893
integer height = 284
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_des_parent_item_from_bom_popup
integer x = 1906
integer y = 196
integer width = 1472
integer height = 284
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

