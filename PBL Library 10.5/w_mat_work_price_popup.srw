HA$PBExportHeader$w_mat_work_price_popup.srw
$PBExportComments$$$HEX8$$6cade4b9e8b200ac20c1ddd01dd3c5c5$$ENDHEX$$
forward
global type w_mat_work_price_popup from w_popup_root
end type
type cb_retrieve from commandbutton within w_mat_work_price_popup
end type
type cb_select from commandbutton within w_mat_work_price_popup
end type
type ddlb_supplier_code from uo_supplier_code within w_mat_work_price_popup
end type
type st_4 from statictext within w_mat_work_price_popup
end type
type st_5 from statictext within w_mat_work_price_popup
end type
type uo_item from uo_item_code within w_mat_work_price_popup
end type
type st_1 from statictext within w_mat_work_price_popup
end type
type uo_dateset from uo_ymd_calendar within w_mat_work_price_popup
end type
type st_14 from so_statictext within w_mat_work_price_popup
end type
type sle_item_spec from so_singlelineedit within w_mat_work_price_popup
end type
type rb_6 from so_radiobutton within w_mat_work_price_popup
end type
type rb_2 from so_radiobutton within w_mat_work_price_popup
end type
type rb_5 from so_radiobutton within w_mat_work_price_popup
end type
type rb_1 from so_radiobutton within w_mat_work_price_popup
end type
type rb_4 from so_radiobutton within w_mat_work_price_popup
end type
type rb_3 from so_radiobutton within w_mat_work_price_popup
end type
type rb_goods from so_radiobutton within w_mat_work_price_popup
end type
type sle_drawing_no from so_singlelineedit within w_mat_work_price_popup
end type
type st_2 from so_statictext within w_mat_work_price_popup
end type
type gb_1 from so_groupbox within w_mat_work_price_popup
end type
type gb_2 from so_groupbox within w_mat_work_price_popup
end type
type gb_4 from so_groupbox within w_mat_work_price_popup
end type
end forward

global type w_mat_work_price_popup from w_popup_root
integer width = 3899
integer height = 2136
string title = "Work Price Master Popup"
event ue_post_open ( )
cb_retrieve cb_retrieve
cb_select cb_select
ddlb_supplier_code ddlb_supplier_code
st_4 st_4
st_5 st_5
uo_item uo_item
st_1 st_1
uo_dateset uo_dateset
st_14 st_14
sle_item_spec sle_item_spec
rb_6 rb_6
rb_2 rb_2
rb_5 rb_5
rb_1 rb_1
rb_4 rb_4
rb_3 rb_3
rb_goods rb_goods
sle_drawing_no sle_drawing_no
st_2 st_2
gb_1 gb_1
gb_2 gb_2
gb_4 gb_4
end type
global w_mat_work_price_popup w_mat_work_price_popup

event ue_post_open;call super::ue_post_open;ddlb_supplier_code.TEXT = MESSAGE.STRINGPARM 
CB_RETRIEVE.TRIGGEREVENT(CLICKED!)
end event

on w_mat_work_price_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.ddlb_supplier_code=create ddlb_supplier_code
this.st_4=create st_4
this.st_5=create st_5
this.uo_item=create uo_item
this.st_1=create st_1
this.uo_dateset=create uo_dateset
this.st_14=create st_14
this.sle_item_spec=create sle_item_spec
this.rb_6=create rb_6
this.rb_2=create rb_2
this.rb_5=create rb_5
this.rb_1=create rb_1
this.rb_4=create rb_4
this.rb_3=create rb_3
this.rb_goods=create rb_goods
this.sle_drawing_no=create sle_drawing_no
this.st_2=create st_2
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.ddlb_supplier_code
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.st_5
this.Control[iCurrent+6]=this.uo_item
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.uo_dateset
this.Control[iCurrent+9]=this.st_14
this.Control[iCurrent+10]=this.sle_item_spec
this.Control[iCurrent+11]=this.rb_6
this.Control[iCurrent+12]=this.rb_2
this.Control[iCurrent+13]=this.rb_5
this.Control[iCurrent+14]=this.rb_1
this.Control[iCurrent+15]=this.rb_4
this.Control[iCurrent+16]=this.rb_3
this.Control[iCurrent+17]=this.rb_goods
this.Control[iCurrent+18]=this.sle_drawing_no
this.Control[iCurrent+19]=this.st_2
this.Control[iCurrent+20]=this.gb_1
this.Control[iCurrent+21]=this.gb_2
this.Control[iCurrent+22]=this.gb_4
end on

on w_mat_work_price_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.ddlb_supplier_code)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.uo_item)
destroy(this.st_1)
destroy(this.uo_dateset)
destroy(this.st_14)
destroy(this.sle_item_spec)
destroy(this.rb_6)
destroy(this.rb_2)
destroy(this.rb_5)
destroy(this.rb_1)
destroy(this.rb_4)
destroy(this.rb_3)
destroy(this.rb_goods)
destroy(this.sle_drawing_no)
destroy(this.st_2)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_4)
end on

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
end if
end event

type p_title from w_popup_root`p_title within w_mat_work_price_popup
integer x = 18
integer width = 3881
end type

type cb_sort from w_popup_root`cb_sort within w_mat_work_price_popup
boolean visible = true
integer x = 2752
integer y = 292
integer taborder = 40
end type

type cb_close from w_popup_root`cb_close within w_mat_work_price_popup
boolean visible = true
integer x = 3579
integer y = 292
integer taborder = 70
end type

event cb_close::clicked;call super::clicked;Gst_return.Gvb_return = False
end event

type st_msg from w_popup_root`st_msg within w_mat_work_price_popup
boolean visible = true
integer y = 488
integer width = 3881
end type

type dw_1 from w_popup_root`dw_1 within w_mat_work_price_popup
boolean visible = true
integer y = 792
integer width = 3881
integer height = 1256
integer taborder = 0
boolean titlebar = true
string title = "Unit Price List"
string dataobject = "d_mat_work_price_popup"
boolean maxbox = true
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
CB_SELECT.TRIGGEREVENT(CLICKED!)
end event

type dw_2 from w_popup_root`dw_2 within w_mat_work_price_popup
boolean visible = true
integer y = 792
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_mat_work_price_popup
integer y = 792
end type

type cb_retrieve from commandbutton within w_mat_work_price_popup
integer x = 3031
integer y = 292
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

event clicked;DW_1.RETRIEVE( ddlb_supplier_code.TEXT+'%' , UO_ITEM.TEXT+'%', uo_dateset.text() , sle_drawing_no.text+'%' ,  GVI_ORGANIZATION_ID  )
end event

type cb_select from commandbutton within w_mat_work_price_popup
integer x = 3305
integer y = 292
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

if dw_1.object.supplier_code[dw_1.getrow()] = '*' then
	return
end if 

Gst_return.Gvb_return = True
MESSAGE.DOUBLEPARM = DW_1.GETITEMNUMBER( DW_1.GETROW() , 'unit_price')
Gst_return.Gvs_return[1]  = DW_1.GETITEMSTRING( DW_1.GETROW() , 'currency')

Gst_return.Gvs_return[2]  = DW_1.GETITEMSTRING( DW_1.GETROW() , 'supplier_code')
Gst_return.Gvs_return[3]  = DW_1.GETITEMSTRING( DW_1.GETROW() , 'supplier_name')

Gst_return.Gvs_return[4]  = DW_1.GETITEMSTRING( DW_1.GETROW() , 'item_code')
Gst_return.Gvs_return[5]  = DW_1.GETITEMSTRING( DW_1.GETROW() , 'delivery')
Gst_return.Gvs_return[6]  = DW_1.GETITEMSTRING( DW_1.GETROW() , 'line_type')

Gst_return.Gvs_return[7]  = DW_1.GETITEMSTRING( DW_1.GETROW() , 'item_name')
Gst_return.Gvs_return[8]  = DW_1.GETITEMSTRING( DW_1.GETROW() , 'item_spec')
Gst_return.Gvs_return[9]  = DW_1.GETITEMSTRING( DW_1.GETROW() , 'item_uom')

CLOSEWITHRETURN(PARENT ,MESSAGE.DOUBLEPARM )

end event

type ddlb_supplier_code from uo_supplier_code within w_mat_work_price_popup
integer x = 32
integer y = 344
integer width = 521
boolean bringtotop = true
end type

type st_4 from statictext within w_mat_work_price_popup
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
string text = "Supplier Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_5 from statictext within w_mat_work_price_popup
integer x = 567
integer y = 268
integer width = 594
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

type uo_item from uo_item_code within w_mat_work_price_popup
integer x = 558
integer y = 344
integer width = 617
integer height = 84
integer taborder = 20
boolean bringtotop = true
end type

on uo_item.destroy
call uo_item_code::destroy
end on

type st_1 from statictext within w_mat_work_price_popup
integer x = 1609
integer y = 268
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
string text = "Dateset"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_dateset from uo_ymd_calendar within w_mat_work_price_popup
integer x = 1609
integer y = 344
integer width = 402
integer taborder = 30
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_14 from so_statictext within w_mat_work_price_popup
integer x = 1184
integer y = 268
integer width = 421
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Item Spec"
end type

type sle_item_spec from so_singlelineedit within w_mat_work_price_popup
integer x = 1184
integer y = 344
integer width = 421
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer weight = 700
string pointer = "HyperLink!"
textcase textcase = upper!
end type

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN = "ITEM_SPEC"

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

IVD_SELECTED_DATA_WINDOW.SETFILTER('')
IVD_SELECTED_DATA_WINDOW.FILTER()

IF THIS.TEXT = '' THEN 
	IVD_SELECTED_DATA_WINDOW.SETFILTER('')
	IVD_SELECTED_DATA_WINDOW.FILTER()
	RETURN
ELSE
	LVS_VALUE =  UPPER( '%'+this.text+'%' )
END IF

IVD_SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
IVD_SELECTED_DATA_WINDOW.FILTER()

end event

type rb_6 from so_radiobutton within w_mat_work_price_popup
integer x = 41
integer y = 660
integer width = 251
boolean bringtotop = true
integer weight = 700
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.setfilter('')
dw_1.filter()
end event

type rb_2 from so_radiobutton within w_mat_work_price_popup
integer x = 306
integer y = 660
integer width = 315
boolean bringtotop = true
integer weight = 700
string text = "SET ITEM"
end type

event clicked;call super::clicked;dw_1.setfilter("SET_ITEM_YN = 'Y' ")
dw_1.filter()
end event

type rb_5 from so_radiobutton within w_mat_work_price_popup
integer x = 695
integer y = 660
integer width = 361
boolean bringtotop = true
integer weight = 700
string text = "Material"
end type

event clicked;call super::clicked;dw_1.setfilter("item_division = 'R' ")
dw_1.filter()
end event

type rb_1 from so_radiobutton within w_mat_work_price_popup
integer x = 1353
integer y = 660
integer width = 352
boolean bringtotop = true
integer weight = 700
string text = "Product"
end type

event clicked;call super::clicked;dw_1.setfilter("item_division = 'F' ")
dw_1.filter()
end event

type rb_4 from so_radiobutton within w_mat_work_price_popup
integer x = 1984
integer y = 660
integer width = 334
boolean bringtotop = true
integer weight = 700
string text = "Assembly"
end type

event clicked;call super::clicked;dw_1.setfilter("item_division = 'W")
dw_1.filter()
end event

type rb_3 from so_radiobutton within w_mat_work_price_popup
integer x = 1691
integer y = 660
integer width = 302
boolean bringtotop = true
integer weight = 700
string text = "Model"
end type

event clicked;call super::clicked;dw_1.setfilter("item_division = 'M' ")
dw_1.filter()
end event

type rb_goods from so_radiobutton within w_mat_work_price_popup
integer x = 1070
integer y = 660
integer width = 288
boolean bringtotop = true
integer weight = 700
string text = "Goods"
end type

event clicked;call super::clicked;dw_1.setfilter("item_division = 'G' ")
dw_1.filter()
end event

type sle_drawing_no from so_singlelineedit within w_mat_work_price_popup
integer x = 2021
integer y = 344
integer width = 594
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer weight = 700
string pointer = "HyperLink!"
textcase textcase = upper!
end type

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN = "ITEM_SPEC"

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

IVD_SELECTED_DATA_WINDOW.SETFILTER('')
IVD_SELECTED_DATA_WINDOW.FILTER()

IF THIS.TEXT = '' THEN 
	IVD_SELECTED_DATA_WINDOW.SETFILTER('')
	IVD_SELECTED_DATA_WINDOW.FILTER()
	RETURN
ELSE
	LVS_VALUE =  UPPER( '%'+this.text+'%' )
END IF

IVD_SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
IVD_SELECTED_DATA_WINDOW.FILTER()

end event

type st_2 from so_statictext within w_mat_work_price_popup
integer x = 2021
integer y = 268
integer width = 594
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Drawing No"
end type

type gb_1 from so_groupbox within w_mat_work_price_popup
integer y = 200
integer width = 2642
integer height = 280
integer taborder = 40
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_mat_work_price_popup
integer x = 2702
integer y = 196
integer width = 1184
integer height = 280
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_4 from so_groupbox within w_mat_work_price_popup
integer x = 14
integer y = 588
integer width = 2350
integer height = 184
integer taborder = 70
integer weight = 700
long textcolor = 16711680
string text = "Filter"
end type

