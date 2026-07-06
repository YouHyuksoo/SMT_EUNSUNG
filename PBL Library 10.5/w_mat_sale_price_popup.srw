HA$PBExportHeader$w_mat_sale_price_popup.srw
$PBExportComments$$$HEX8$$6cade4b9e8b200ac20c1ddd01dd3c5c5$$ENDHEX$$
forward
global type w_mat_sale_price_popup from w_popup_root
end type
type cb_retrieve from commandbutton within w_mat_sale_price_popup
end type
type cb_select from commandbutton within w_mat_sale_price_popup
end type
type ddlb_supplier_code from uo_supplier_code within w_mat_sale_price_popup
end type
type st_4 from statictext within w_mat_sale_price_popup
end type
type st_5 from statictext within w_mat_sale_price_popup
end type
type uo_item from uo_item_code within w_mat_sale_price_popup
end type
type gb_2 from so_groupbox within w_mat_sale_price_popup
end type
type gb_1 from so_groupbox within w_mat_sale_price_popup
end type
end forward

global type w_mat_sale_price_popup from w_popup_root
integer width = 3250
integer height = 2100
string title = "Sale Price Master Popup"
event ue_post_open ( )
cb_retrieve cb_retrieve
cb_select cb_select
ddlb_supplier_code ddlb_supplier_code
st_4 st_4
st_5 st_5
uo_item uo_item
gb_2 gb_2
gb_1 gb_1
end type
global w_mat_sale_price_popup w_mat_sale_price_popup

event ue_post_open;call super::ue_post_open;uo_item.TEXT = MESSAGE.STRINGPARM 
CB_RETRIEVE.TRIGGEREVENT(CLICKED!)
end event

on w_mat_sale_price_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.ddlb_supplier_code=create ddlb_supplier_code
this.st_4=create st_4
this.st_5=create st_5
this.uo_item=create uo_item
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.ddlb_supplier_code
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.st_5
this.Control[iCurrent+6]=this.uo_item
this.Control[iCurrent+7]=this.gb_2
this.Control[iCurrent+8]=this.gb_1
end on

on w_mat_sale_price_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.ddlb_supplier_code)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.uo_item)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
	
end if
end event

type p_title from w_popup_root`p_title within w_mat_sale_price_popup
integer x = 9
integer width = 3232
end type

type cb_sort from w_popup_root`cb_sort within w_mat_sale_price_popup
boolean visible = true
integer x = 2089
integer y = 300
integer taborder = 40
end type

type cb_close from w_popup_root`cb_close within w_mat_sale_price_popup
boolean visible = true
integer x = 2917
integer y = 300
integer taborder = 70
end type

type st_msg from w_popup_root`st_msg within w_mat_sale_price_popup
boolean visible = true
integer y = 492
integer width = 3232
end type

type dw_1 from w_popup_root`dw_1 within w_mat_sale_price_popup
boolean visible = true
integer y = 588
integer width = 3232
integer height = 1464
integer taborder = 0
string dataobject = "d_mat_sale_price_popup_tree"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
CB_SELECT.TRIGGEREVENT(CLICKED!)
end event

type dw_2 from w_popup_root`dw_2 within w_mat_sale_price_popup
boolean visible = true
integer y = 588
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_mat_sale_price_popup
integer y = 608
end type

type cb_retrieve from commandbutton within w_mat_sale_price_popup
integer x = 2368
integer y = 300
integer width = 274
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE( ddlb_supplier_code.TEXT+'%' , UO_ITEM.TEXT+'%',  GVI_ORGANIZATION_ID  )
end event

type cb_select from commandbutton within w_mat_sale_price_popup
integer x = 2642
integer y = 300
integer width = 274
integer height = 100
integer taborder = 60
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

event clicked;IF DW_1.GETROW() < 1 THEN RETURN

MESSAGE.DOUBLEPARM = DW_1.GETITEMNUMBER( DW_1.GETROW() , 'unit_price')
Gst_return.gvs_return[1] = dw_1.object.supplier_code[dw_1.getrow()]
Gst_return.gvs_return[2] = dw_1.object.supplier_name[dw_1.getrow()]

Gst_return.gvs_return[3] = dw_1.object.item_code[dw_1.getrow()]

CLOSEWITHRETURN(PARENT ,MESSAGE.DOUBLEPARM )

end event

type ddlb_supplier_code from uo_supplier_code within w_mat_sale_price_popup
integer x = 32
integer y = 328
integer width = 521
boolean bringtotop = true
end type

type st_4 from statictext within w_mat_sale_price_popup
integer x = 32
integer y = 268
integer width = 521
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
string text = "Supplier ID"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_5 from statictext within w_mat_sale_price_popup
integer x = 567
integer y = 268
integer width = 622
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

type uo_item from uo_item_code within w_mat_sale_price_popup
integer x = 558
integer y = 328
integer width = 645
integer height = 948
integer taborder = 20
boolean bringtotop = true
end type

on uo_item.destroy
call uo_item_code::destroy
end on

type gb_2 from so_groupbox within w_mat_sale_price_popup
integer y = 204
integer width = 1211
integer height = 280
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_1 from so_groupbox within w_mat_sale_price_popup
integer x = 2043
integer y = 204
integer width = 1189
integer height = 280
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

