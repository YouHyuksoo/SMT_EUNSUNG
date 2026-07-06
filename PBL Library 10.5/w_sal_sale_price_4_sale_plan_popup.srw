HA$PBExportHeader$w_sal_sale_price_4_sale_plan_popup.srw
$PBExportComments$$$HEX10$$f9b2d4c6c4ac8dd61cc888bc20c1ddd01dd3c5c5$$ENDHEX$$
forward
global type w_sal_sale_price_4_sale_plan_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_sal_sale_price_4_sale_plan_popup
end type
type cb_select from so_commandbutton within w_sal_sale_price_4_sale_plan_popup
end type
type st_2 from statictext within w_sal_sale_price_4_sale_plan_popup
end type
type ddlb_customer_code from uo_customer_code within w_sal_sale_price_4_sale_plan_popup
end type
type sle_customer_order_no_origin from so_singlelineedit within w_sal_sale_price_4_sale_plan_popup
end type
type st_1 from statictext within w_sal_sale_price_4_sale_plan_popup
end type
type uo_delivery_date from uo_ymd_calendar within w_sal_sale_price_4_sale_plan_popup
end type
type st_yyyymm from statictext within w_sal_sale_price_4_sale_plan_popup
end type
type rb_domestic from so_radiobutton within w_sal_sale_price_4_sale_plan_popup
end type
type rb_export from so_radiobutton within w_sal_sale_price_4_sale_plan_popup
end type
type ddlb_item_code from uo_item_code within w_sal_sale_price_4_sale_plan_popup
end type
type st_4 from statictext within w_sal_sale_price_4_sale_plan_popup
end type
type ddlb_dest_customer_code from uo_customer_code within w_sal_sale_price_4_sale_plan_popup
end type
type st_3 from statictext within w_sal_sale_price_4_sale_plan_popup
end type
type gb_1 from so_groupbox within w_sal_sale_price_4_sale_plan_popup
end type
type gb_2 from so_groupbox within w_sal_sale_price_4_sale_plan_popup
end type
type gb_3 from so_groupbox within w_sal_sale_price_4_sale_plan_popup
end type
end forward

global type w_sal_sale_price_4_sale_plan_popup from w_popup_root
integer width = 4635
integer height = 2428
string title = "Sale Price Master Popup"
cb_retrieve cb_retrieve
cb_select cb_select
st_2 st_2
ddlb_customer_code ddlb_customer_code
sle_customer_order_no_origin sle_customer_order_no_origin
st_1 st_1
uo_delivery_date uo_delivery_date
st_yyyymm st_yyyymm
rb_domestic rb_domestic
rb_export rb_export
ddlb_item_code ddlb_item_code
st_4 st_4
ddlb_dest_customer_code ddlb_dest_customer_code
st_3 st_3
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_sal_sale_price_4_sale_plan_popup w_sal_sale_price_4_sale_plan_popup

type variables
datawindow idw_parm
end variables

on w_sal_sale_price_4_sale_plan_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.st_2=create st_2
this.ddlb_customer_code=create ddlb_customer_code
this.sle_customer_order_no_origin=create sle_customer_order_no_origin
this.st_1=create st_1
this.uo_delivery_date=create uo_delivery_date
this.st_yyyymm=create st_yyyymm
this.rb_domestic=create rb_domestic
this.rb_export=create rb_export
this.ddlb_item_code=create ddlb_item_code
this.st_4=create st_4
this.ddlb_dest_customer_code=create ddlb_dest_customer_code
this.st_3=create st_3
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.ddlb_customer_code
this.Control[iCurrent+5]=this.sle_customer_order_no_origin
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.uo_delivery_date
this.Control[iCurrent+8]=this.st_yyyymm
this.Control[iCurrent+9]=this.rb_domestic
this.Control[iCurrent+10]=this.rb_export
this.Control[iCurrent+11]=this.ddlb_item_code
this.Control[iCurrent+12]=this.st_4
this.Control[iCurrent+13]=this.ddlb_dest_customer_code
this.Control[iCurrent+14]=this.st_3
this.Control[iCurrent+15]=this.gb_1
this.Control[iCurrent+16]=this.gb_2
this.Control[iCurrent+17]=this.gb_3
end on

on w_sal_sale_price_4_sale_plan_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.st_2)
destroy(this.ddlb_customer_code)
destroy(this.sle_customer_order_no_origin)
destroy(this.st_1)
destroy(this.uo_delivery_date)
destroy(this.st_yyyymm)
destroy(this.rb_domestic)
destroy(this.rb_export)
destroy(this.ddlb_item_code)
destroy(this.st_4)
destroy(this.ddlb_dest_customer_code)
destroy(this.st_3)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event open;call super::open;dw_1.settransobject(sqlca)

idw_parm = message.powerobjectparm

IVS_MOUSEMOVE_YN = 'N'
end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
	
end if
end event

type p_title from w_popup_root`p_title within w_sal_sale_price_4_sale_plan_popup
integer width = 4635
end type

type cb_sort from w_popup_root`cb_sort within w_sal_sale_price_4_sale_plan_popup
boolean visible = true
integer x = 3328
integer y = 312
integer height = 164
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_sal_sale_price_4_sale_plan_popup
boolean visible = true
integer x = 4165
integer y = 312
integer height = 164
integer taborder = 40
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_sal_sale_price_4_sale_plan_popup
boolean visible = true
integer x = 5
integer y = 560
integer width = 4626
end type

type dw_1 from w_popup_root`dw_1 within w_sal_sale_price_4_sale_plan_popup
boolean visible = true
integer x = 5
integer y = 652
integer width = 4631
integer height = 1708
integer taborder = 50
boolean titlebar = true
string title = "Product Sale Price List"
string dataobject = "d_sal_sale_price_4_sale_plan_popup_tree"
end type

event dw_1::itemchanged;call super::itemchanged;if dwo.name = 'order_qty' then 
	
	if long(data) = 0 then 
		this.object.check_yn[row] = 'N'
	else
		this.object.check_yn[row] = 'Y'
	end if 
	
end if
end event

type dw_2 from w_popup_root`dw_2 within w_sal_sale_price_4_sale_plan_popup
boolean visible = true
integer y = 800
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_sal_sale_price_4_sale_plan_popup
integer taborder = 60
end type

type cb_retrieve from so_commandbutton within w_sal_sale_price_4_sale_plan_popup
integer x = 3607
integer y = 312
integer width = 274
integer height = 164
integer taborder = 20
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;SETPOINTER(HOURGLASS!)
DW_1.RETRIEVE( ddlb_item_code.text+ '%' , ddlb_customer_code.text+'%' , GVI_ORGANIZATION_ID )
end event

type cb_select from so_commandbutton within w_sal_sale_price_4_sale_plan_popup
integer x = 3886
integer y = 312
integer width = 274
integer height = 164
integer taborder = 30
boolean bringtotop = true
string text = "Select"
boolean default = true
end type

event clicked;call super::clicked;long i , row
string lvs_customer_order_no , lvs_dest_customer_code

if Gvs_customer_order_no_auto_set <> 'Y' and ( sle_customer_order_no_origin.text = '' or  isnull(sle_customer_order_no_origin.text) ) then 
	f_msgbox1(111 , f_get_dual_lang_text( gvs_language , 'CUSTOMER ORDER NO' ))
	return
end if 
		
do
	i++
	
		if dw_1.object.check_yn[i] = "Y" then
		else
			continue
		end if 

		row = idw_parm.insertrow(0)
	//	idw_parm.scrolltorow(row)		
		f_set_security_row(idw_parm , row , 'ALL')
	//	f_msg_mdi_help(f_msg_st(152))
		idw_parm.object.plan_yyyymm[row] = string(f_t_sysdate(),'yyyymm')
		idw_parm.object.delivery_date[row] = uo_delivery_date.text()
		idw_parm.object.plan_date[row] = f_t_sysdate()
		idw_parm.object.plan_transfer_yn[row] = 'N'
		
		if Gvs_product_sale_plan_auto_confirm = 'Y' then
			idw_parm.object.confirm_yn[row] = 'Y'								
		else
			idw_parm.object.confirm_yn[row] = 'N'			
		end if
		
		idw_parm.object.mfs[row] = '*'			
		
		lvs_dest_customer_code = ddlb_dest_customer_code.text
		if lvs_dest_customer_code = '%' or isnull(lvs_dest_customer_code) or lvs_dest_customer_code = '' and dw_1.object.customer_code[i]	='*' then 
			idw_parm.object.customer_code[row] = dw_1.object.customer_code[i]			
			idw_parm.object.customer_name[row] = dw_1.object.customer_name[i]					
		else
			idw_parm.object.customer_code[row] = lvs_dest_customer_code		
			idw_parm.object.customer_name[row] = '*'
		end if 
		
		idw_parm.object.item_code[row] = dw_1.object.item_code[i]		
		idw_parm.object.item_name[row] = dw_1.object.item_name[i]		
		idw_parm.object.item_spec[row] = dw_1.object.item_spec[i]		
		idw_parm.object.delivery_nation_code[row] = dw_1.object.nation_code[i]				
		idw_parm.object.order_qty[row] = dw_1.object.order_qty[i]						
		
		idw_parm.object.sale_plan_price[row] = dw_1.object.product_sale_price[i]	
		idw_parm.object.sale_currency[row] = dw_1.object.sale_currency[i]			
		
		if rb_domestic.checked = true then 		
			idw_parm.object.model_delivery_code[row] = '1'						
		else
			idw_parm.object.model_delivery_code[row] = '2'									
		end if 
		
		idw_parm.object.product_line_type[row] = dw_1.object.product_line_type[i]		
		idw_parm.object.sale_plan_status[row] = 'N'				
		idw_parm.object.shipping_account[row] = 'M001'			
		idw_parm.object.exchange_rate[row] = 1.0000
		idw_parm.object.customer_order_no[row] = '*'
		idw_parm.object.sale_charge[row] = Gvs_user_id
		
		if ddlb_customer_code.text = '%' or ddlb_customer_code.text = '*' then 
		else
			idw_parm.object.customer_code[row] = ddlb_customer_code.text
		end if 
		idw_parm.object.plan_priority[row] = '1'
		idw_parm.object.line_code[row] = '*'				
		idw_parm.object.work_division[row] = 'P'	
		idw_parm.object.sale_plan_type[row] = 'F'	
		
		if Gvs_customer_order_no_auto_set = 'Y' then
			lvs_customer_order_no =  f_get_any_no('CUSTOMER_ORDER_NO')
			idw_parm.object.customer_order_no[row] =lvs_customer_order_no
			idw_parm.object.customer_order_no_origin[row] =lvs_customer_order_no
		else
			lvs_customer_order_no =  f_get_any_no('CUSTOMER_ORDER_NO')			
			idw_parm.object.customer_order_no_origin[row] = sle_customer_order_no_origin.text
			idw_parm.object.customer_order_no[row] =lvs_customer_order_no
		end if
		
		idw_parm.setredraw( True)	
	
loop until i = dw_1.rowcount()

close(parent)
end event

type st_2 from statictext within w_sal_sale_price_4_sale_plan_popup
integer x = 599
integer y = 320
integer width = 457
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Customer Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_customer_code from uo_customer_code within w_sal_sale_price_4_sale_plan_popup
integer x = 599
integer y = 392
integer taborder = 0
boolean bringtotop = true
end type

type sle_customer_order_no_origin from so_singlelineedit within w_sal_sale_price_4_sale_plan_popup
integer x = 1129
integer y = 392
integer width = 530
integer height = 84
integer taborder = 10
boolean bringtotop = true
textcase textcase = upper!
end type

event constructor;call super::constructor;if Gvs_customer_order_no_auto_set = 'Y' then 
	this.enabled = false
else
	this.enabled = true
end if 
end event

type st_1 from statictext within w_sal_sale_price_4_sale_plan_popup
integer x = 1129
integer y = 312
integer width = 530
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 12632256
string text = "Customer Order No Origin"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_delivery_date from uo_ymd_calendar within w_sal_sale_price_4_sale_plan_popup
event destroy ( )
integer x = 1664
integer y = 392
boolean bringtotop = true
end type

on uo_delivery_date.destroy
call uo_ymd_calendar::destroy
end on

type st_yyyymm from statictext within w_sal_sale_price_4_sale_plan_popup
integer x = 1664
integer y = 316
integer width = 407
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Delivery Date"
alignment alignment = center!
boolean focusrectangle = false
end type

type rb_domestic from so_radiobutton within w_sal_sale_price_4_sale_plan_popup
integer x = 2610
integer y = 308
integer width = 544
boolean bringtotop = true
string text = "Domestic Delivery"
boolean checked = true
end type

type rb_export from so_radiobutton within w_sal_sale_price_4_sale_plan_popup
integer x = 2610
integer y = 412
integer width = 544
boolean bringtotop = true
string text = "Export Delivery"
end type

type ddlb_item_code from uo_item_code within w_sal_sale_price_4_sale_plan_popup
integer x = 59
integer y = 392
integer width = 535
integer taborder = 0
boolean bringtotop = true
end type

event modified;call super::modified;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN


LVS_COLUMN = "ITEM_CODE"	

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

dw_1.SETFILTER('')
dw_1.FILTER()

IF THIS.TEXT = '' THEN 
	dw_1.SETFILTER('')
	dw_1.FILTER()
	RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

dw_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found")
end event

type st_4 from statictext within w_sal_sale_price_4_sale_plan_popup
integer x = 59
integer y = 324
integer width = 535
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Item Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_dest_customer_code from uo_customer_code within w_sal_sale_price_4_sale_plan_popup
integer x = 2089
integer y = 392
integer taborder = 60
boolean bringtotop = true
end type

type st_3 from statictext within w_sal_sale_price_4_sale_plan_popup
integer x = 2075
integer y = 304
integer width = 457
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Customer Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from so_groupbox within w_sal_sale_price_4_sale_plan_popup
integer x = 3255
integer y = 216
integer width = 1243
integer height = 328
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_sal_sale_price_4_sale_plan_popup
integer x = 1102
integer y = 216
integer width = 2144
integer height = 328
integer weight = 700
long textcolor = 16711680
string text = "Order Condition"
end type

type gb_3 from so_groupbox within w_sal_sale_price_4_sale_plan_popup
integer x = 5
integer y = 220
integer width = 1079
integer height = 328
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

