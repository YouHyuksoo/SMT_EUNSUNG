HA$PBExportHeader$w_mat_unit_price_4_purchase_order_popup.srw
$PBExportComments$$$HEX8$$6cade4b9e8b200ac20c1ddd01dd3c5c5$$ENDHEX$$
forward
global type w_mat_unit_price_4_purchase_order_popup from w_popup_root
end type
type cb_retrieve from commandbutton within w_mat_unit_price_4_purchase_order_popup
end type
type cb_select from commandbutton within w_mat_unit_price_4_purchase_order_popup
end type
type ddlb_supplier_code from uo_supplier_code within w_mat_unit_price_4_purchase_order_popup
end type
type st_4 from statictext within w_mat_unit_price_4_purchase_order_popup
end type
type st_5 from statictext within w_mat_unit_price_4_purchase_order_popup
end type
type uo_item from uo_item_code within w_mat_unit_price_4_purchase_order_popup
end type
type st_1 from statictext within w_mat_unit_price_4_purchase_order_popup
end type
type uo_dateset from uo_ymd_calendar within w_mat_unit_price_4_purchase_order_popup
end type
type st_14 from so_statictext within w_mat_unit_price_4_purchase_order_popup
end type
type sle_item_spec from so_singlelineedit within w_mat_unit_price_4_purchase_order_popup
end type
type ddlb_line_type from uo_line_type within w_mat_unit_price_4_purchase_order_popup
end type
type st_2 from statictext within w_mat_unit_price_4_purchase_order_popup
end type
type rb_6 from so_radiobutton within w_mat_unit_price_4_purchase_order_popup
end type
type rb_5 from so_radiobutton within w_mat_unit_price_4_purchase_order_popup
end type
type rb_4 from so_radiobutton within w_mat_unit_price_4_purchase_order_popup
end type
type cbx_show_all from so_checkbox within w_mat_unit_price_4_purchase_order_popup
end type
type cbx_auto_group_no from so_checkbox within w_mat_unit_price_4_purchase_order_popup
end type
type uo_delivery_date from uo_ymd_calendar within w_mat_unit_price_4_purchase_order_popup
end type
type st_3 from statictext within w_mat_unit_price_4_purchase_order_popup
end type
type sle_group_no from so_singlelineedit within w_mat_unit_price_4_purchase_order_popup
end type
type cb_group_no from so_commandbutton within w_mat_unit_price_4_purchase_order_popup
end type
type gb_1 from so_groupbox within w_mat_unit_price_4_purchase_order_popup
end type
type gb_2 from so_groupbox within w_mat_unit_price_4_purchase_order_popup
end type
type gb_4 from so_groupbox within w_mat_unit_price_4_purchase_order_popup
end type
type gb_3 from so_groupbox within w_mat_unit_price_4_purchase_order_popup
end type
end forward

global type w_mat_unit_price_4_purchase_order_popup from w_popup_root
integer width = 3899
integer height = 2136
string title = "Unit Price Master Popup"
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
ddlb_line_type ddlb_line_type
st_2 st_2
rb_6 rb_6
rb_5 rb_5
rb_4 rb_4
cbx_show_all cbx_show_all
cbx_auto_group_no cbx_auto_group_no
uo_delivery_date uo_delivery_date
st_3 st_3
sle_group_no sle_group_no
cb_group_no cb_group_no
gb_1 gb_1
gb_2 gb_2
gb_4 gb_4
gb_3 gb_3
end type
global w_mat_unit_price_4_purchase_order_popup w_mat_unit_price_4_purchase_order_popup

type variables
datawindow idw_parm
end variables

event ue_post_open;call super::ue_post_open;ddlb_supplier_code.TEXT = MESSAGE.STRINGPARM 
CB_RETRIEVE.TRIGGEREVENT(CLICKED!)
end event

on w_mat_unit_price_4_purchase_order_popup.create
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
this.ddlb_line_type=create ddlb_line_type
this.st_2=create st_2
this.rb_6=create rb_6
this.rb_5=create rb_5
this.rb_4=create rb_4
this.cbx_show_all=create cbx_show_all
this.cbx_auto_group_no=create cbx_auto_group_no
this.uo_delivery_date=create uo_delivery_date
this.st_3=create st_3
this.sle_group_no=create sle_group_no
this.cb_group_no=create cb_group_no
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_4=create gb_4
this.gb_3=create gb_3
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
this.Control[iCurrent+11]=this.ddlb_line_type
this.Control[iCurrent+12]=this.st_2
this.Control[iCurrent+13]=this.rb_6
this.Control[iCurrent+14]=this.rb_5
this.Control[iCurrent+15]=this.rb_4
this.Control[iCurrent+16]=this.cbx_show_all
this.Control[iCurrent+17]=this.cbx_auto_group_no
this.Control[iCurrent+18]=this.uo_delivery_date
this.Control[iCurrent+19]=this.st_3
this.Control[iCurrent+20]=this.sle_group_no
this.Control[iCurrent+21]=this.cb_group_no
this.Control[iCurrent+22]=this.gb_1
this.Control[iCurrent+23]=this.gb_2
this.Control[iCurrent+24]=this.gb_4
this.Control[iCurrent+25]=this.gb_3
end on

on w_mat_unit_price_4_purchase_order_popup.destroy
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
destroy(this.ddlb_line_type)
destroy(this.st_2)
destroy(this.rb_6)
destroy(this.rb_5)
destroy(this.rb_4)
destroy(this.cbx_show_all)
destroy(this.cbx_auto_group_no)
destroy(this.uo_delivery_date)
destroy(this.st_3)
destroy(this.sle_group_no)
destroy(this.cb_group_no)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_4)
destroy(this.gb_3)
end on

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
end if
end event

event open;call super::open;idw_parm = message.powerobjectparm
end event

type p_title from w_popup_root`p_title within w_mat_unit_price_4_purchase_order_popup
integer x = 18
integer width = 3881
end type

type cb_sort from w_popup_root`cb_sort within w_mat_unit_price_4_purchase_order_popup
boolean visible = true
integer x = 2565
integer y = 280
integer height = 156
integer taborder = 40
end type

type cb_close from w_popup_root`cb_close within w_mat_unit_price_4_purchase_order_popup
boolean visible = true
integer x = 3392
integer y = 280
integer height = 156
integer taborder = 70
end type

event cb_close::clicked;call super::clicked;Gst_return.Gvb_return = False
end event

type st_msg from w_popup_root`st_msg within w_mat_unit_price_4_purchase_order_popup
boolean visible = true
integer y = 488
integer width = 3881
end type

type dw_1 from w_popup_root`dw_1 within w_mat_unit_price_4_purchase_order_popup
boolean visible = true
integer y = 792
integer width = 3881
integer height = 1256
integer taborder = 0
boolean titlebar = true
string title = "Unit Price List"
string dataobject = "d_mat_unit_price_4_purchase_order_popup"
boolean maxbox = true
end type

event dw_1::itemchanged;call super::itemchanged;if dwo.name = 'order_qty' then 
	
	if long(data) = 0 then 
		this.object.check_yn[row] = 'N'
	else
		this.object.check_yn[row] = 'Y'
	end if 
	
end if
end event

type dw_2 from w_popup_root`dw_2 within w_mat_unit_price_4_purchase_order_popup
boolean visible = true
integer y = 792
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_mat_unit_price_4_purchase_order_popup
integer y = 792
end type

type cb_retrieve from commandbutton within w_mat_unit_price_4_purchase_order_popup
integer x = 2843
integer y = 280
integer width = 274
integer height = 156
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

event clicked;string lvs_user_id
if cbx_show_all.checked = true then 
	lvs_user_id = '%'	
else
	lvs_user_id = Gvs_user_id+'%'		
end if 
DW_1.RETRIEVE( ddlb_supplier_code.TEXT+'%' , UO_ITEM.TEXT+'%', uo_dateset.text() , ddlb_line_type.getcode()+'%' , lvs_user_id , GVI_ORGANIZATION_ID  )
end event

type cb_select from commandbutton within w_mat_unit_price_4_purchase_order_popup
integer x = 3118
integer y = 280
integer width = 274
integer height = 156
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

long i , row
string lvs_date

f_set_column_dddw(idw_parm)

do
	i++
	
	if dw_1.object.check_yn[i] = 'Y' then 
	else
		continue
	end if 
	
			idw_parm.ENABLED = TRUE
			ROW = idw_parm.INSERTROW(row)
			idw_parm.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(idw_parm , ROW ,'ALL')
			idw_parm.object.delivery_date[row] = uo_delivery_date.text()
			idw_parm.object.purchase_order_date[row]  = f_t_sysdate()	
			lvs_date = string(idw_parm.object.purchase_order_date[row],'yyyymmdd') + string( f_get_sequence( 'SEQ_PURCHASE_ORDER_NO'),'000')
			idw_parm.object.order_no[row] = lvs_date
			
			if cbx_auto_group_no.checked = true then 
				idw_parm.object.order_group_no[row] = lvs_date
			else
				if sle_group_no.text = '' or isnull(sle_group_no.text) then 
					cb_group_no.triggerevent(clicked!)
				end if 
					idw_parm.object.order_group_no[row] = sle_group_no.text			
			end if
			idw_parm.object.mfs[row] = lvs_date
			//			idw_parm.object.material_mfs[row] = lvs_date
			idw_parm.object.arrival_qty[row] = 0 
			idw_parm.object.order_type[row] = 'M'	
			
			idw_parm.object.supplier_code[row] = dw_1.object.supplier_code[i]
			idw_parm.trigger event itemchanged( row , idw_parm.object.supplier_code , idw_parm.object.supplier_code[row] ) 				 		
			
			idw_parm.object.item_code[row] =dw_1.object.item_code[i]
			idw_parm.trigger event itemchanged( row , idw_parm.object.item_code , idw_parm.object.item_code[row] ) 		
			idw_parm.object.item_name[row] = dw_1.object.item_name[i]
			idw_parm.object.item_spec[row] = dw_1.object.item_spec[i]
			
			idw_parm.object.supplier_name[row] = dw_1.object.supplier_name[i]
			idw_parm.object.line_type[row] = dw_1.object.line_type[i]
			idw_parm.trigger event itemchanged( row , idw_parm.object.line_type , idw_parm.object.line_type[row] ) 				
			idw_parm.object.item_uom[row] = dw_1.object.item_uom[i]
			idw_parm.object.order_qty[row] = dw_1.object.order_qty[i]	
			idw_parm.object.order_amt[row] = idw_parm.object.order_qty[row] * idw_parm.object.unit_price[row]
	
loop until i = dw_1.rowcount( )

Close(parent)
end event

type ddlb_supplier_code from uo_supplier_code within w_mat_unit_price_4_purchase_order_popup
integer x = 32
integer y = 344
integer width = 521
boolean bringtotop = true
end type

event modified;call super::modified;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN = "SUPPLIER_CODE"

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

dw_1.SETFILTER('')
dw_1.FILTER()

IF THIS.TEXT = '' THEN 
	dw_1.SETFILTER('')
	dw_1.FILTER()
	RETURN
ELSE
	LVS_VALUE =  UPPER( '%'+this.text+'%' )
END IF

dw_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
dw_1.FILTER()

end event

type st_4 from statictext within w_mat_unit_price_4_purchase_order_popup
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

type st_5 from statictext within w_mat_unit_price_4_purchase_order_popup
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

type uo_item from uo_item_code within w_mat_unit_price_4_purchase_order_popup
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

event modified;call super::modified;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN = "ITEM_CODE"

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

dw_1.SETFILTER('')
dw_1.FILTER()

IF THIS.TEXT = '' THEN 
	dw_1.SETFILTER('')
	dw_1.FILTER()
	RETURN
ELSE
	LVS_VALUE =  UPPER( '%'+this.text+'%' )
END IF

dw_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
dw_1.FILTER()

end event

type st_1 from statictext within w_mat_unit_price_4_purchase_order_popup
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

type uo_dateset from uo_ymd_calendar within w_mat_unit_price_4_purchase_order_popup
integer x = 1609
integer y = 344
integer width = 402
integer taborder = 30
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_14 from so_statictext within w_mat_unit_price_4_purchase_order_popup
integer x = 1184
integer y = 268
integer width = 421
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Item Spec"
end type

type sle_item_spec from so_singlelineedit within w_mat_unit_price_4_purchase_order_popup
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

dw_1.SETFILTER('')
dw_1.FILTER()

IF THIS.TEXT = '' THEN 
	dw_1.SETFILTER('')
	dw_1.FILTER()
	RETURN
ELSE
	LVS_VALUE =  UPPER( '%'+this.text+'%' )
END IF

dw_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
dw_1.FILTER()

end event

type ddlb_line_type from uo_line_type within w_mat_unit_price_4_purchase_order_popup
integer x = 2021
integer y = 344
integer width = 471
integer taborder = 20
boolean bringtotop = true
end type

type st_2 from statictext within w_mat_unit_price_4_purchase_order_popup
integer x = 2030
integer y = 276
integer width = 471
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

type rb_6 from so_radiobutton within w_mat_unit_price_4_purchase_order_popup
integer x = 73
integer y = 668
integer width = 251
boolean bringtotop = true
integer weight = 700
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.setfilter('')
dw_1.filter()
end event

type rb_5 from so_radiobutton within w_mat_unit_price_4_purchase_order_popup
integer x = 361
integer y = 668
integer width = 361
boolean bringtotop = true
integer weight = 700
string text = "Material"
end type

event clicked;call super::clicked;dw_1.setfilter("item_division = 'R' ")
dw_1.filter()
end event

type rb_4 from so_radiobutton within w_mat_unit_price_4_purchase_order_popup
integer x = 731
integer y = 668
integer width = 334
boolean bringtotop = true
integer weight = 700
string text = "Assembly"
end type

event clicked;call super::clicked;dw_1.setfilter("item_division = 'W")
dw_1.filter()
end event

type cbx_show_all from so_checkbox within w_mat_unit_price_4_purchase_order_popup
integer x = 1143
integer y = 664
integer width = 384
integer height = 80
boolean bringtotop = true
integer weight = 700
string text = "Show All"
boolean checked = true
end type

event constructor;call super::constructor;//if Gvi_user_level >= 8 then 
//	this.enabled = true
//	this.checked = true	
//else
//	this.enabled = false
//	this.checked = false
//end if
//
end event

type cbx_auto_group_no from so_checkbox within w_mat_unit_price_4_purchase_order_popup
integer x = 1550
integer y = 660
integer width = 471
integer height = 80
boolean bringtotop = true
integer weight = 700
string text = "Auto Group No"
boolean checked = true
end type

event clicked;call super::clicked;if this.checked = true then 
	cb_group_no.enabled = false
else
	cb_group_no.enabled = true
end if 
end event

type uo_delivery_date from uo_ymd_calendar within w_mat_unit_price_4_purchase_order_popup
integer x = 3333
integer y = 656
integer taborder = 40
boolean bringtotop = true
end type

on uo_delivery_date.destroy
call uo_ymd_calendar::destroy
end on

type st_3 from statictext within w_mat_unit_price_4_purchase_order_popup
integer x = 2930
integer y = 668
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
string text = "Delivery Date"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_group_no from so_singlelineedit within w_mat_unit_price_4_purchase_order_popup
integer x = 2030
integer y = 660
integer width = 434
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer weight = 700
string pointer = "HyperLink!"
textcase textcase = upper!
end type

type cb_group_no from so_commandbutton within w_mat_unit_price_4_purchase_order_popup
integer x = 2473
integer y = 652
integer width = 389
integer height = 100
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
string text = "Group No"
end type

event clicked;call super::clicked;sle_group_no.text = string(f_t_sysdate(),'yyyymmdd') + string( f_get_sequence( 'SEQ_PURCHASE_ORDER_NO'),'000')
end event

type gb_1 from so_groupbox within w_mat_unit_price_4_purchase_order_popup
integer y = 200
integer width = 2510
integer height = 280
integer taborder = 40
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_mat_unit_price_4_purchase_order_popup
integer x = 2514
integer y = 200
integer width = 1184
integer height = 280
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_4 from so_groupbox within w_mat_unit_price_4_purchase_order_popup
integer x = 23
integer y = 596
integer width = 1083
integer height = 184
integer taborder = 70
integer weight = 700
long textcolor = 16711680
string text = "Filter"
end type

type gb_3 from so_groupbox within w_mat_unit_price_4_purchase_order_popup
integer x = 1111
integer y = 596
integer width = 2697
integer height = 184
integer taborder = 80
integer weight = 700
long textcolor = 16711680
string text = "Option"
end type

