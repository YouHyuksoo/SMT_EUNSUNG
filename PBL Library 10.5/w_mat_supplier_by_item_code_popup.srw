HA$PBExportHeader$w_mat_supplier_by_item_code_popup.srw
$PBExportComments$$$HEX16$$80bd88d488bc38d6d0c5200058c75cd5200070ac98b720c115c8f4bc70c88cd6$$ENDHEX$$
forward
global type w_mat_supplier_by_item_code_popup from w_popup_root
end type
type cb_retrieve from commandbutton within w_mat_supplier_by_item_code_popup
end type
type cb_select from commandbutton within w_mat_supplier_by_item_code_popup
end type
type ddlb_supplier_code from uo_supplier_code within w_mat_supplier_by_item_code_popup
end type
type st_4 from statictext within w_mat_supplier_by_item_code_popup
end type
type st_2 from statictext within w_mat_supplier_by_item_code_popup
end type
type sle_item_code from singlelineedit within w_mat_supplier_by_item_code_popup
end type
type st_1 from statictext within w_mat_supplier_by_item_code_popup
end type
type sle_item_name from singlelineedit within w_mat_supplier_by_item_code_popup
end type
type gb_2 from so_groupbox within w_mat_supplier_by_item_code_popup
end type
type gb_1 from so_groupbox within w_mat_supplier_by_item_code_popup
end type
end forward

global type w_mat_supplier_by_item_code_popup from w_popup_root
integer width = 3803
integer height = 2144
string title = "Matrial Master Popup"
cb_retrieve cb_retrieve
cb_select cb_select
ddlb_supplier_code ddlb_supplier_code
st_4 st_4
st_2 st_2
sle_item_code sle_item_code
st_1 st_1
sle_item_name sle_item_name
gb_2 gb_2
gb_1 gb_1
end type
global w_mat_supplier_by_item_code_popup w_mat_supplier_by_item_code_popup

on w_mat_supplier_by_item_code_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.ddlb_supplier_code=create ddlb_supplier_code
this.st_4=create st_4
this.st_2=create st_2
this.sle_item_code=create sle_item_code
this.st_1=create st_1
this.sle_item_name=create sle_item_name
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.ddlb_supplier_code
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.sle_item_code
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.sle_item_name
this.Control[iCurrent+9]=this.gb_2
this.Control[iCurrent+10]=this.gb_1
end on

on w_mat_supplier_by_item_code_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.ddlb_supplier_code)
destroy(this.st_4)
destroy(this.st_2)
destroy(this.sle_item_code)
destroy(this.st_1)
destroy(this.sle_item_name)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event open;call super::open;dw_1.settransobject(sqlca)
SLE_ITEM_CODE.TEXT =MESSAGE.STRINGPARM
CB_RETRIEVE.TRIGGEREVENT(CLICKED!)
SLE_ITEM_CODE.SETFOCUS()
end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
	
end if
end event

type p_title from w_popup_root`p_title within w_mat_supplier_by_item_code_popup
integer width = 3799
end type

type cb_sort from w_popup_root`cb_sort within w_mat_supplier_by_item_code_popup
boolean visible = true
integer x = 2107
integer y = 288
integer height = 116
end type

type cb_close from w_popup_root`cb_close within w_mat_supplier_by_item_code_popup
boolean visible = true
integer x = 2944
integer y = 288
integer height = 116
end type

event cb_close::clicked;call super::clicked;Gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_mat_supplier_by_item_code_popup
boolean visible = true
integer y = 484
integer width = 3799
end type

type dw_1 from w_popup_root`dw_1 within w_mat_supplier_by_item_code_popup
boolean visible = true
integer y = 572
integer width = 3799
integer height = 1488
boolean titlebar = true
string dataobject = "d_mat_material_popup"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
cb_select.triggerevent(clicked!)
end event

type dw_2 from w_popup_root`dw_2 within w_mat_supplier_by_item_code_popup
boolean visible = true
integer y = 580
end type

type dw_3 from w_popup_root`dw_3 within w_mat_supplier_by_item_code_popup
integer y = 576
end type

type cb_retrieve from commandbutton within w_mat_supplier_by_item_code_popup
integer x = 2386
integer y = 288
integer width = 279
integer height = 116
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE(DDLB_SUPPLIER_CODE.TEXT+'%' , SLE_ITEM_CODE.TEXT+'%' , GVI_ORGANIZATION_ID )
end event

type cb_select from commandbutton within w_mat_supplier_by_item_code_popup
integer x = 2665
integer y = 288
integer width = 274
integer height = 116
integer taborder = 80
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
	RETURN -1
END IF
Gst_return.gvb_return = true

MESSAGE.STRINGPARM   = DW_1.GETITEMSTRING( DW_1.GETROW() , 'supplier_code')
Gst_return.gvs_return[1] = DW_1.GETITEMSTRING( DW_1.GETROW() , 'supplier_name')

Gst_return.gvs_return[2] = DW_1.GETITEMSTRING( DW_1.GETROW() , 'item_code')
Gst_return.gvs_return[3] = DW_1.GETITEMSTRING( DW_1.GETROW() , 'line_type')

Gst_return.gvf_return[1] = DW_1.GETITEMDECIMAL( DW_1.GETROW() , 'unit_price')

CLOSEWITHRETURN(PARENT , MESSAGE.STRINGPARM )
end event

type ddlb_supplier_code from uo_supplier_code within w_mat_supplier_by_item_code_popup
integer x = 32
integer y = 332
integer width = 471
integer taborder = 90
boolean bringtotop = true
string item[] = {""}
end type

type st_4 from statictext within w_mat_supplier_by_item_code_popup
integer x = 32
integer y = 268
integer width = 462
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
string text = "Supplier Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_mat_supplier_by_item_code_popup
integer x = 507
integer y = 260
integer width = 558
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
string text = "Item Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_item_code from singlelineedit within w_mat_supplier_by_item_code_popup
integer x = 507
integer y = 328
integer width = 558
integer height = 92
integer taborder = 60
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

type st_1 from statictext within w_mat_supplier_by_item_code_popup
integer x = 1070
integer y = 260
integer width = 754
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

type sle_item_name from singlelineedit within w_mat_supplier_by_item_code_popup
event ue_editchange pbm_enchange
integer x = 1070
integer y = 328
integer width = 754
integer height = 92
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
	
	DW_1.SETFILTER('')
	DW_1.FILTER()	
	RETURN 
	
ELSE
	LVS_item_name = '%'+this.text+'%'
END IF

DW_1.SETFILTER("item_name LIKE '"+LVS_item_name+"'")
DW_1.FILTER()

end event

type gb_2 from so_groupbox within w_mat_supplier_by_item_code_popup
integer y = 196
integer width = 1851
integer height = 280
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_1 from so_groupbox within w_mat_supplier_by_item_code_popup
integer x = 2071
integer y = 196
integer width = 1179
integer height = 280
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

