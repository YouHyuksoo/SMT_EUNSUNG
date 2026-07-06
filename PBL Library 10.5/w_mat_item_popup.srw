HA$PBExportHeader$w_mat_item_popup.srw
$PBExportComments$$$HEX8$$6cade4b9e8b200ac20c1ddd01dd3c5c5$$ENDHEX$$
forward
global type w_mat_item_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_mat_item_popup
end type
type cb_select from so_commandbutton within w_mat_item_popup
end type
type st_item_code from so_statictext within w_mat_item_popup
end type
type st_3 from so_statictext within w_mat_item_popup
end type
type st_1 from so_statictext within w_mat_item_popup
end type
type ddlb_supplier_code from uo_supplier_code within w_mat_item_popup
end type
type ddlb_item_code from uo_item_code within w_mat_item_popup
end type
type uo_date from uo_ymd_calendar within w_mat_item_popup
end type
type sle_item_spec from so_singlelineedit within w_mat_item_popup
end type
type st_14 from so_statictext within w_mat_item_popup
end type
type rb_all from so_radiobutton within w_mat_item_popup
end type
type rb_2 from so_radiobutton within w_mat_item_popup
end type
type rb_goods from so_radiobutton within w_mat_item_popup
end type
type rb_1 from so_radiobutton within w_mat_item_popup
end type
type rb_3 from so_radiobutton within w_mat_item_popup
end type
type rb_4 from so_radiobutton within w_mat_item_popup
end type
type gb_1 from so_groupbox within w_mat_item_popup
end type
type gb_2 from so_groupbox within w_mat_item_popup
end type
type gb_3 from so_groupbox within w_mat_item_popup
end type
end forward

global type w_mat_item_popup from w_popup_root
integer width = 4123
integer height = 2232
string title = "Material Item Popup"
cb_retrieve cb_retrieve
cb_select cb_select
st_item_code st_item_code
st_3 st_3
st_1 st_1
ddlb_supplier_code ddlb_supplier_code
ddlb_item_code ddlb_item_code
uo_date uo_date
sle_item_spec sle_item_spec
st_14 st_14
rb_all rb_all
rb_2 rb_2
rb_goods rb_goods
rb_1 rb_1
rb_3 rb_3
rb_4 rb_4
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_mat_item_popup w_mat_item_popup

on w_mat_item_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.st_item_code=create st_item_code
this.st_3=create st_3
this.st_1=create st_1
this.ddlb_supplier_code=create ddlb_supplier_code
this.ddlb_item_code=create ddlb_item_code
this.uo_date=create uo_date
this.sle_item_spec=create sle_item_spec
this.st_14=create st_14
this.rb_all=create rb_all
this.rb_2=create rb_2
this.rb_goods=create rb_goods
this.rb_1=create rb_1
this.rb_3=create rb_3
this.rb_4=create rb_4
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.st_item_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.ddlb_supplier_code
this.Control[iCurrent+7]=this.ddlb_item_code
this.Control[iCurrent+8]=this.uo_date
this.Control[iCurrent+9]=this.sle_item_spec
this.Control[iCurrent+10]=this.st_14
this.Control[iCurrent+11]=this.rb_all
this.Control[iCurrent+12]=this.rb_2
this.Control[iCurrent+13]=this.rb_goods
this.Control[iCurrent+14]=this.rb_1
this.Control[iCurrent+15]=this.rb_3
this.Control[iCurrent+16]=this.rb_4
this.Control[iCurrent+17]=this.gb_1
this.Control[iCurrent+18]=this.gb_2
this.Control[iCurrent+19]=this.gb_3
end on

on w_mat_item_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.st_item_code)
destroy(this.st_3)
destroy(this.st_1)
destroy(this.ddlb_supplier_code)
destroy(this.ddlb_item_code)
destroy(this.uo_date)
destroy(this.sle_item_spec)
destroy(this.st_14)
destroy(this.rb_all)
destroy(this.rb_2)
destroy(this.rb_goods)
destroy(this.rb_1)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event open;call super::open;dw_1.settransobject(sqlca)
ddlb_item_code.text = message.stringparm

end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
	
end if
end event

type p_title from w_popup_root`p_title within w_mat_item_popup
integer width = 4128
end type

type cb_sort from w_popup_root`cb_sort within w_mat_item_popup
boolean visible = true
integer x = 2930
integer y = 356
end type

type cb_close from w_popup_root`cb_close within w_mat_item_popup
boolean visible = true
integer x = 3767
integer y = 356
end type

event cb_close::clicked;call super::clicked;Gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_mat_item_popup
boolean visible = true
integer x = 5
integer y = 556
integer width = 4128
end type

type dw_1 from w_popup_root`dw_1 within w_mat_item_popup
boolean visible = true
integer x = 5
integer y = 648
integer width = 4128
integer height = 1504
boolean titlebar = true
string title = "Material Item List"
string dataobject = "d_mat_item_pop_tree"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
cb_select.triggerevent(clicked!)
end event

type dw_2 from w_popup_root`dw_2 within w_mat_item_popup
integer y = 580
end type

type dw_3 from w_popup_root`dw_3 within w_mat_item_popup
integer y = 668
end type

type cb_retrieve from so_commandbutton within w_mat_item_popup
integer x = 3209
integer y = 356
integer width = 274
integer height = 100
integer taborder = 70
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE( ddlb_item_code.text + '%'  , ddlb_supplier_code.text + '%' , uo_date.text(), GVI_ORGANIZATION_ID )
end event

type cb_select from so_commandbutton within w_mat_item_popup
integer x = 3488
integer y = 356
integer width = 274
integer height = 100
integer taborder = 80
boolean bringtotop = true
string text = "Select"
boolean default = true
end type

event clicked;if dw_1.getrow() < 1 then 
	gst_return.gvb_return = false
	return -1 
end if 

gst_return.gvb_return = true 
gst_return.gvs_return[1] = dw_1.object.item_code[dw_1.getrow()]
gst_return.gvs_return[2] = dw_1.object.item_name[dw_1.getrow()]
gst_return.gvs_return[3] = dw_1.object.item_spec[dw_1.getrow()]
gst_return.gvs_return[4] = dw_1.object.supplier_code[dw_1.getrow()]
gst_return.gvs_return[5] = dw_1.object.supplier_name[dw_1.getrow()]
gst_return.gvs_return[6] = dw_1.object.line_type[dw_1.getrow()]
gst_return.gvs_return[7] = dw_1.object.item_uom[dw_1.getrow()]
gst_return.gvs_return[9] = dw_1.object.item_type[dw_1.getrow()]


 
close(parent)



end event

type st_item_code from so_statictext within w_mat_item_popup
integer x = 32
integer y = 332
integer width = 622
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type st_3 from so_statictext within w_mat_item_popup
integer x = 658
integer y = 332
integer width = 466
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Supplier Code"
end type

type st_1 from so_statictext within w_mat_item_popup
integer x = 1125
integer y = 332
integer width = 407
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Date"
end type

type ddlb_supplier_code from uo_supplier_code within w_mat_item_popup
integer x = 658
integer y = 404
integer width = 466
integer taborder = 20
boolean bringtotop = true
end type

type ddlb_item_code from uo_item_code within w_mat_item_popup
integer x = 32
integer y = 404
integer width = 622
integer taborder = 20
boolean bringtotop = true
end type

type uo_date from uo_ymd_calendar within w_mat_item_popup
integer x = 1129
integer y = 404
integer taborder = 30
boolean bringtotop = true
end type

on uo_date.destroy
call uo_ymd_calendar::destroy
end on

type sle_item_spec from so_singlelineedit within w_mat_item_popup
integer x = 1545
integer y = 404
integer width = 421
integer height = 84
integer taborder = 30
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

type st_14 from so_statictext within w_mat_item_popup
integer x = 1545
integer y = 316
integer width = 421
integer height = 68
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Item Spec"
end type

type rb_all from so_radiobutton within w_mat_item_popup
integer x = 2053
integer y = 288
integer width = 379
boolean bringtotop = true
integer weight = 700
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.setfilter('')
dw_1.filter()
end event

type rb_2 from so_radiobutton within w_mat_item_popup
integer x = 2469
integer y = 296
integer width = 389
boolean bringtotop = true
integer weight = 700
string text = "Material"
end type

event clicked;call super::clicked;dw_1.setfilter("item_division = 'R' ")
dw_1.filter()
end event

type rb_goods from so_radiobutton within w_mat_item_popup
integer x = 2053
integer y = 372
integer width = 379
boolean bringtotop = true
integer weight = 700
string text = "Goods"
end type

event clicked;call super::clicked;dw_1.setfilter("item_division = 'G' ")
dw_1.filter()
end event

type rb_1 from so_radiobutton within w_mat_item_popup
integer x = 2469
integer y = 376
integer width = 379
boolean bringtotop = true
integer weight = 700
string text = "Product"
end type

event clicked;call super::clicked;dw_1.setfilter("item_division = 'F' ")
dw_1.filter()
end event

type rb_3 from so_radiobutton within w_mat_item_popup
integer x = 2053
integer y = 452
integer width = 379
boolean bringtotop = true
integer weight = 700
string text = "Free"
end type

event clicked;call super::clicked;dw_1.setfilter("line_type = 'M'  or  line_type = 'T' ")
dw_1.filter()
end event

type rb_4 from so_radiobutton within w_mat_item_popup
integer x = 2469
integer y = 448
integer width = 407
boolean bringtotop = true
integer weight = 700
string text = "Sub Material"
end type

event clicked;call super::clicked;dw_1.setfilter("item_division = 'B' ")
dw_1.filter()
end event

type gb_1 from so_groupbox within w_mat_item_popup
integer x = 1993
integer y = 216
integer width = 910
integer height = 328
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Filter"
end type

type gb_2 from so_groupbox within w_mat_item_popup
integer x = 9
integer y = 216
integer width = 1979
integer height = 328
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_mat_item_popup
integer x = 2907
integer y = 216
integer width = 1152
integer height = 328
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

