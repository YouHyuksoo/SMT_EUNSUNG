HA$PBExportHeader$w_mat_departure_master.srw
$PBExportComments$Material Departure Master
forward
global type w_mat_departure_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mat_departure_master
end type
type uo_dateend from uo_ymd_calendar within w_mat_departure_master
end type
type ddlb_item_code from uo_item_code within w_mat_departure_master
end type
type st_3 from so_statictext within w_mat_departure_master
end type
type st_4 from so_statictext within w_mat_departure_master
end type
type rb_purchase from so_radiobutton within w_mat_departure_master
end type
type rb_departure from so_radiobutton within w_mat_departure_master
end type
type ddlb_supplier_code from uo_supplier_code within w_mat_departure_master
end type
type st_1 from so_statictext within w_mat_departure_master
end type
type tab_1 from tab within w_mat_departure_master
end type
type tabpage_1 from userobject within tab_1
end type
type pb_1 from so_commandbutton within tabpage_1
end type
type st_7 from so_statictext within tabpage_1
end type
type sle_invoice_no_cond from so_singlelineedit within tabpage_1
end type
type cbx_ignore_buy_price from so_checkbox within tabpage_1
end type
type ddlb_location_code from uo_basecode within tabpage_1
end type
type st_11 from so_statictext within tabpage_1
end type
type cb_batch_receipt from so_commandbutton within tabpage_1
end type
type cbx_direct_receipt from so_checkbox within tabpage_1
end type
type ddlb_arrival_location_code from uo_arrival_location_code within tabpage_1
end type
type st_6 from so_statictext within tabpage_1
end type
type cb_cancel from so_commandbutton within tabpage_1
end type
type cb_set from so_commandbutton within tabpage_1
end type
type tabpage_1 from userobject within tab_1
pb_1 pb_1
st_7 st_7
sle_invoice_no_cond sle_invoice_no_cond
cbx_ignore_buy_price cbx_ignore_buy_price
ddlb_location_code ddlb_location_code
st_11 st_11
cb_batch_receipt cb_batch_receipt
cbx_direct_receipt cbx_direct_receipt
ddlb_arrival_location_code ddlb_arrival_location_code
st_6 st_6
cb_cancel cb_cancel
cb_set cb_set
end type
type tabpage_2 from userobject within tab_1
end type
type cb_preview from so_commandbutton within tabpage_2
end type
type cb_print from so_commandbutton within tabpage_2
end type
type cbx_dialog from so_checkbox within tabpage_2
end type
type em_copy from so_editmask within tabpage_2
end type
type st_2 from so_statictext within tabpage_2
end type
type tabpage_2 from userobject within tab_1
cb_preview cb_preview
cb_print cb_print
cbx_dialog cbx_dialog
em_copy em_copy
st_2 st_2
end type
type tabpage_3 from userobject within tab_1
end type
type cbx_2 from so_checkbox within tabpage_3
end type
type cbx_excess_order_qty from so_checkbox within tabpage_3
end type
type cbx_departure_subsitute_arrival from so_checkbox within tabpage_3
end type
type tabpage_3 from userobject within tab_1
cbx_2 cbx_2
cbx_excess_order_qty cbx_excess_order_qty
cbx_departure_subsitute_arrival cbx_departure_subsitute_arrival
end type
type tabpage_4 from userobject within tab_1
end type
type cb_merge from so_commandbutton within tabpage_4
end type
type cb_divide from so_commandbutton within tabpage_4
end type
type tabpage_4 from userobject within tab_1
cb_merge cb_merge
cb_divide cb_divide
end type
type tab_1 from tab within w_mat_departure_master
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type
type st_5 from so_statictext within w_mat_departure_master
end type
type st_14 from so_statictext within w_mat_departure_master
end type
type sle_item_name from so_singlelineedit within w_mat_departure_master
end type
type sle_1 from so_singlelineedit within w_mat_departure_master
end type
type st_8 from so_statictext within w_mat_departure_master
end type
type sle_invoice_no from so_singlelineedit within w_mat_departure_master
end type
type gb_1 from so_groupbox within w_mat_departure_master
end type
type gb_2 from so_groupbox within w_mat_departure_master
end type
end forward

global type w_mat_departure_master from w_main_root
integer width = 4608
integer height = 3384
string title = "Material Departure Master"
uo_dateset uo_dateset
uo_dateend uo_dateend
ddlb_item_code ddlb_item_code
st_3 st_3
st_4 st_4
rb_purchase rb_purchase
rb_departure rb_departure
ddlb_supplier_code ddlb_supplier_code
st_1 st_1
tab_1 tab_1
st_5 st_5
st_14 st_14
sle_item_name sle_item_name
sle_1 sle_1
st_8 st_8
sle_invoice_no sle_invoice_no
gb_1 gb_1
gb_2 gb_2
end type
global w_mat_departure_master w_mat_departure_master

type variables
string ivs_preview_yn = 'N'
end variables

on w_mat_departure_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.ddlb_item_code=create ddlb_item_code
this.st_3=create st_3
this.st_4=create st_4
this.rb_purchase=create rb_purchase
this.rb_departure=create rb_departure
this.ddlb_supplier_code=create ddlb_supplier_code
this.st_1=create st_1
this.tab_1=create tab_1
this.st_5=create st_5
this.st_14=create st_14
this.sle_item_name=create sle_item_name
this.sle_1=create sle_1
this.st_8=create st_8
this.sle_invoice_no=create sle_invoice_no
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.ddlb_item_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.rb_purchase
this.Control[iCurrent+7]=this.rb_departure
this.Control[iCurrent+8]=this.ddlb_supplier_code
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.tab_1
this.Control[iCurrent+11]=this.st_5
this.Control[iCurrent+12]=this.st_14
this.Control[iCurrent+13]=this.sle_item_name
this.Control[iCurrent+14]=this.sle_1
this.Control[iCurrent+15]=this.st_8
this.Control[iCurrent+16]=this.sle_invoice_no
this.Control[iCurrent+17]=this.gb_1
this.Control[iCurrent+18]=this.gb_2
end on

on w_mat_departure_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.ddlb_item_code)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.rb_purchase)
destroy(this.rb_departure)
destroy(this.ddlb_supplier_code)
destroy(this.st_1)
destroy(this.tab_1)
destroy(this.st_5)
destroy(this.st_14)
destroy(this.sle_item_name)
destroy(this.sle_1)
destroy(this.st_8)
destroy(this.sle_invoice_no)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event activate;call super::activate;/***************************************
* Window Default Property 
****************************************/
Gst_set.window_id            = this.classname() 
Gst_set.author                  = "JiSheng"
Gst_set.creation_date      = '20051101'
Gst_set.last_modify_date = '20051101'
Gst_set.Report_window    = False  // Report Window  True / Flase

/*****************************************
* Data Window Property
******************************************/
Ivs_resize_type                      = 'MASTER_DETAIL_145_23M'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

/****************************************
* Menu Property 
*****************************************
* ADMIN  ( All Control )
* MANAGE ( Manager )
* GUEST  ( Only Query )
* QUERY  ( Only Query  )
* DATA_CONTROL  ( Insert Delete Update )
* REPORT ( Report )
****************************************/
F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control





end event

event ue_post_open;call super::ue_post_open;

/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

event ue_data_control;call super::ue_data_control;long row
string lvs_date
double lvd_seq
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
			dw_1.reset()
			dw_2.reset()
			dw_3.reset()
			dw_4.reset()			
			
			if    rb_purchase.checked   then 
			    dw_1.retrieve(ddlb_item_code.text() + '%',  ddlb_supplier_code.text+'%' ,   uo_dateset.text() , uo_dateend.text(),  gvi_organization_id)
			else
				dw_4.retrieve(ddlb_item_code.text() + '%',  ddlb_supplier_code.text + '%' ,  uo_dateset.text() , uo_dateend.text() , sle_invoice_no.text +'%' , gvi_organization_id)
			end if 
			
   case 'INSERT'
		
			dw_2.ENABLED = TRUE
			dw_2.bringtotop = true			
			ROW = dw_2.INSERTROW(dw_2.GETROW())
			dw_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(dw_2 , ROW ,'ALL')
			lvd_seq = f_get_sequence('seq_mat_arrival')
			lvs_date = string(f_t_sysdate(),'yyyymmdd') + string(lvd_seq)
			dw_2.object.arrival_date[row] = f_t_sysdate()
			dw_2.object.inspect_date[row] = f_t_sysdate()
			dw_2.object.arrival_seq_no[row] = lvd_seq
			dw_2.object.invoice_no[row] = lvs_date
			dw_2.object.order_no[row] = lvs_date
			dw_2.object.order_group_no[row] = lvs_date			
			dw_2.object.mfs[row] = lvs_date
			dw_2.object.arrival_status[row] = 'N'
			dw_2.object.arrival_type[row] = 'D'			
			dw_2.object.inspect_result[row]  = 'P'
			dw_2.object.inspect_rule[row]  ='P'
			dw_2.object.departure_date[row] = f_t_sysdate()
			
	case 'APPEND'		
		
			dw_2.ENABLED = TRUE
			dw_2.bringtotop = true
			ROW = dw_2.INSERTROW(dw_2.GETROW())
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')	
			lvd_seq = f_get_sequence('seq_mat_arrival')
			lvs_date = string(f_t_sysdate(),'yyyymmdd') + string(lvd_seq)
			dw_2.object.arrival_date[row] = f_t_sysdate()
			dw_2.object.inspect_date[row] = f_t_sysdate()
			dw_2.object.arrival_seq_no[row] = lvd_seq
			dw_2.object.invoice_no[row] = lvs_date
			
			dw_2.object.order_no[row] = lvs_date
			dw_2.object.order_group_no[row] = lvs_date			
			
			dw_2.object.mfs[row] = lvs_date
			dw_2.object.arrival_type[row] = 'D'						
			dw_2.object.arrival_status[row] = 'N'
			dw_2.object.inspect_result[row]  = 'P'
			dw_2.object.inspect_rule[row]  = 'P'
			dw_2.object.departure_date[row] = f_t_sysdate()			
			
//	case 'DELETE'
//		
//		  	if dw_2.AcceptText() = -1 then
//				return
//			end if
//			
//			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
//			IF MSG = 1 THEN
//				Gvl_row_deleted = dw_2.GetRow()			
//				dw_2.DELETEROW(Gvl_row_deleted)		
//				dw_2.SetFocus()
//				ROW = dw_2.GetRow()
//				dw_2.ScrollToRow(row)
//				dw_2.SetColumn(1)
//			END IF
		
		
	case 'UPDATE'
		
				if dw_1.update() < 0  or dw_2.update() < 0 or dw_3.update() < 0  then 
					rollback ; 
					f_msg_mdi_help(f_msg_st(9026))
				else
					commit ; 
					f_msg_mdi_help(f_msg_st(170))
					F_RETRIEVE()									
				end if 
				

	case else
end choose


end event

type dw_5 from w_main_root`dw_5 within w_mat_departure_master
integer y = 588
integer width = 4544
integer height = 1104
boolean titlebar = true
string title = "Material Departure Invoice Report"
string dataobject = "d_mat_departure_invoice_rpt"
end type

type dw_4 from w_main_root`dw_4 within w_mat_departure_master
integer y = 576
integer width = 4544
integer height = 1104
boolean titlebar = true
string title = "Material Departure List"
string dataobject = "d_mat_departure_lst"
end type

event dw_4::rbuttondown;call super::rbuttondown;//double  lvd_unit_price
//string lvs_item_code, lvs_supplier_code, lvs_line_type
//if dwo.name = 'supplier_code' then 
//	open(w_com_supplier_popup)
//	if message.stringparm = '' then 
//	else
//		this.object.supplier_code[row] = message.stringparm
//		this.trigger event itemchanged(row, this.object.supplier_code, this.object.supplier_code[row])
//	end if
//end if 
//
//if dwo.name = 'item_code' then 
//	open(w_mat_item_popup)
//	if gst_return.gvb_return = false then 
//	else
//		this.object.item_code[row] = gst_return.gvs_return[1] 
//		this.object.item_name[row] = gst_return.gvs_return[2] 
//		this.object.item_spec[row] = gst_return.gvs_return[3] 
//		this.object.supplier_code[row] = gst_return.gvs_return[4] 
//		this.object.supplier_name[row] = gst_return.gvs_return[5] 
//		this.object.line_type[row] = gst_return.gvs_return[6] 
//		this.object.item_uom[row] = gst_return.gvs_return[7] 		
//	end if 
//	gst_return.gvs_return[1] = ''
//	gst_return.gvs_return[2] = ''
//	gst_return.gvs_return[3] = ''
//	gst_return.gvs_return[4] = ''
//	gst_return.gvs_return[5] = ''
//	gst_return.gvs_return[6] = ''
//	gst_return.gvs_return[7] = ''	
//end if 
//		
//
//
//	
end event

event dw_4::itemchanged;call super::itemchanged;//string lvs_return , lvs_currency
//long lvl_arrival_qty
//Decimal lvd_unit_price , lvd_exchange_rate
//if dwo.name = 'supplier_code' then 
//	lvs_return = f_get_supplier_name(data , gvi_organization_id)
//	if lvs_return = 'ERROR' then 
//		return 1 
//	end if  
//	if lvs_return = 'NOTFOUND' then 
//		return 1 
//	end if
//	
//	this.object.supplier_name[row] = lvs_return 
//	
//	//$$HEX7$$18c2c9b7200008cd30ae54d62000$$ENDHEX$$
//	this.object.arrival_qty[row]  = 0
//	
//end if 
//
//if dwo.name = 'arrival_qty'  then 
//		//=============================================================
//		// $$HEX19$$6cade4b9e8b200ac20002000b9c278c71cb42000e8b200ac7cb9200070c88cd620005cd5e4b2$$ENDHEX$$
//		//=============================================================		
//		lvd_unit_price = f_get_item_unit_price_confirm(this.object.supplier_code[row] ,this.object.item_code[row] , this.object.line_type[row], f_t_sysdate())
//		
//		if lvd_unit_price <= 0 or isnull(lvd_unit_price) then 
//			dw_4.reset()
//			return 
//		else
//			dw_4.object.unit_price[row] = lvd_unit_price 
//		end if
//		
//		lvs_currency = gst_return.gvs_return[1]
//		
//		gst_return.gvs_return[1] = ''		
//		if lvs_currency  = '' or isnull( lvs_currency  ) then 
//			dw_4.reset()			
//			messagebox('Notify','Return currency is error!')
//			return 
//		else
//			dw_4.object.currency[row] = lvs_currency
//		end if 
//		
//		lvd_exchange_rate = gst_return.gvf_return[1]
//		gst_return.gvf_return[1] = 0 
//		
//		if lvd_exchange_rate <= 0 or isnull( lvd_exchange_rate ) then 
//			dw_4.reset()			
//			messagebox('Notify','Return exchange rate is error!')
//			return 
//		else
//			dw_4.object.exchange_rate[row] = lvd_exchange_rate
//		end if 		
//		dw_4.object.delivery[row] = gst_return.gvs_return[2]		
//		dw_4.object.arrival_amt[row] = Dec(this.object.arrival_qty[row]) * lvd_unit_price * lvd_exchange_rate
//		
//end if 
end event

event dw_4::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return

dw_5.retrieve( this.object.invoice_no[currentrow] , this.object.organization_id[currentrow] )
end event

type dw_3 from w_main_root`dw_3 within w_mat_departure_master
integer x = 2272
integer y = 1696
integer width = 2267
integer height = 788
boolean titlebar = true
string title = "Receipt List"
string dataobject = "d_mat_receipt_lst"
end type

type dw_2 from w_main_root`dw_2 within w_mat_departure_master
integer y = 1696
integer width = 2267
integer height = 788
boolean titlebar = true
string title = "Material Departure List"
string dataobject = "d_mat_departure_confirm_lst"
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_2::itemchanged;call super::itemchanged;long n 
if row < 1 then return 

if dwo.name = 'check_yn' then 
	if data = 'N' then 
		n = this.object.selected_row[row]
		dw_1.reselectrow(n)
		dw_1.object.check_yn[n] = 'N'
		dw_1.object.arrival_qty[n] = 0
		dw_2.deleterow(row)
	end if 
end if 

end event

type dw_1 from w_main_root`dw_1 within w_mat_departure_master
integer y = 576
integer width = 4544
integer height = 1104
boolean titlebar = true
string title = "Material Purchase Order List"
string dataobject = "d_mat_purchase_order_4_arrival_lst"
boolean resizable = true
end type

type uo_tabpages from w_main_root`uo_tabpages within w_mat_departure_master
end type

type uo_dateset from uo_ymd_calendar within w_mat_departure_master
event destroy ( )
integer x = 1655
integer y = 160
integer taborder = 30
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_departure_master
event destroy ( )
integer x = 2071
integer y = 160
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_item_code from uo_item_code within w_mat_departure_master
integer x = 704
integer y = 160
integer width = 507
integer taborder = 20
boolean bringtotop = true
end type

type st_3 from so_statictext within w_mat_departure_master
integer x = 704
integer y = 92
integer width = 507
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type st_4 from so_statictext within w_mat_departure_master
integer x = 1659
integer y = 92
integer width = 814
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Purchase Order Date"
end type

type rb_purchase from so_radiobutton within w_mat_departure_master
integer x = 32
integer y = 96
integer width = 631
boolean bringtotop = true
integer weight = 700
string text = "Purchase Order List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1
tab_1.tabpage_1.cb_cancel.enabled = false
tab_1.tabpage_1.cb_set.enabled = true


end event

type rb_departure from so_radiobutton within w_mat_departure_master
integer x = 32
integer y = 184
integer width = 631
boolean bringtotop = true
integer weight = 700
string text = "Departure List"
end type

event clicked;call super::clicked;dw_4.bringtotop = true 
selected_data_window = dw_4
tab_1.tabpage_1.cb_cancel.enabled = true
tab_1.tabpage_1.cb_set.enabled = false



end event

type ddlb_supplier_code from uo_supplier_code within w_mat_departure_master
integer x = 1211
integer y = 160
integer width = 439
integer taborder = 20
boolean bringtotop = true
end type

type st_1 from so_statictext within w_mat_departure_master
integer x = 1211
integer y = 92
integer width = 439
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Supplier Code"
end type

type tab_1 from tab within w_mat_departure_master
integer x = 5
integer y = 308
integer width = 4530
integer height = 280
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean fixedwidth = true
boolean raggedright = true
boolean focusonbuttondown = true
boolean powertips = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 4494
integer height = 152
long backcolor = 15780518
string text = "Process"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Regenerate5!"
long picturemaskcolor = 12632256
pb_1 pb_1
st_7 st_7
sle_invoice_no_cond sle_invoice_no_cond
cbx_ignore_buy_price cbx_ignore_buy_price
ddlb_location_code ddlb_location_code
st_11 st_11
cb_batch_receipt cb_batch_receipt
cbx_direct_receipt cbx_direct_receipt
ddlb_arrival_location_code ddlb_arrival_location_code
st_6 st_6
cb_cancel cb_cancel
cb_set cb_set
end type

on tabpage_1.create
this.pb_1=create pb_1
this.st_7=create st_7
this.sle_invoice_no_cond=create sle_invoice_no_cond
this.cbx_ignore_buy_price=create cbx_ignore_buy_price
this.ddlb_location_code=create ddlb_location_code
this.st_11=create st_11
this.cb_batch_receipt=create cb_batch_receipt
this.cbx_direct_receipt=create cbx_direct_receipt
this.ddlb_arrival_location_code=create ddlb_arrival_location_code
this.st_6=create st_6
this.cb_cancel=create cb_cancel
this.cb_set=create cb_set
this.Control[]={this.pb_1,&
this.st_7,&
this.sle_invoice_no_cond,&
this.cbx_ignore_buy_price,&
this.ddlb_location_code,&
this.st_11,&
this.cb_batch_receipt,&
this.cbx_direct_receipt,&
this.ddlb_arrival_location_code,&
this.st_6,&
this.cb_cancel,&
this.cb_set}
end on

on tabpage_1.destroy
destroy(this.pb_1)
destroy(this.st_7)
destroy(this.sle_invoice_no_cond)
destroy(this.cbx_ignore_buy_price)
destroy(this.ddlb_location_code)
destroy(this.st_11)
destroy(this.cb_batch_receipt)
destroy(this.cbx_direct_receipt)
destroy(this.ddlb_arrival_location_code)
destroy(this.st_6)
destroy(this.cb_cancel)
destroy(this.cb_set)
end on

type pb_1 from so_commandbutton within tabpage_1
integer x = 3954
integer y = 20
integer width = 416
integer height = 116
integer taborder = 40
string text = "Import From Excel"
end type

event clicked;call super::clicked;OPEN(w_mat_item_departure_excel_form_popup)
end event

type st_7 from so_statictext within tabpage_1
integer x = 1897
integer y = 8
integer width = 599
integer height = 60
integer weight = 700
long backcolor = 15780518
string text = "Invoice No"
end type

type sle_invoice_no_cond from so_singlelineedit within tabpage_1
integer x = 1897
integer y = 68
integer width = 599
integer taborder = 60
end type

type cbx_ignore_buy_price from so_checkbox within tabpage_1
integer x = 9
integer y = 80
integer width = 567
integer height = 68
integer weight = 700
long backcolor = 15780518
string text = "Ignore  Buy Price"
end type

type ddlb_location_code from uo_basecode within tabpage_1
integer x = 1307
integer y = 68
integer width = 576
integer height = 636
integer taborder = 40
end type

event constructor;call super::constructor;this.redraw( 'MATERIAL LOCATION CODE')
end event

type st_11 from so_statictext within tabpage_1
integer x = 1307
integer y = 4
integer width = 576
integer height = 60
integer weight = 700
long backcolor = 15780518
string text = "Location Code"
end type

type cb_batch_receipt from so_commandbutton within tabpage_1
boolean visible = false
integer x = 3538
integer y = 20
integer width = 416
integer height = 116
integer taborder = 30
string text = "Batch Receipt"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 
if dw_2.rowcount() = 0 then return 

long i , j , lvl_receipt_seq , lvi_return
string lvs_item_code, lvs_supplier_code, lvs_origin_supplier_code , lvs_line_type, lvs_currency , lvs_receipt_lot_no , lvs_arrival_location_code
Decimal  lvd_unit_price, lvd_exchange_rate , lvl_receipt_qty , lvd_material_cost , lvf_tariff_rate


msg = f_msgbox1(1161,this.text)
if msg = 1 then 
else
	return 
end if 

dw_2.accepttext()
dw_3.reset( )

lvs_receipt_lot_no= f_get_any_no( 'RECEIPT_LOT_NO')

open(w_progress_popup)
w_progress_popup.f_set_range(1 , dw_2.rowcount( ) )
w_progress_popup.f_setstep(1)


for i = 1 to dw_2.rowcount() 
//	if dw_2.object.check_yn[i] = 'Y' then 
		
		lvs_arrival_location_code =dw_2.object.arrival_location_code[i]
		//============================================		
		//$$HEX35$$c8d50cbe3dcce0ac7cb92000b4c6f0c558d5e0ac200004d6acc72000c4b329cc74c72000c8d50cbe3dcce0ac200074c774ba200085c7e0ac7cb9200060d518c22000c6c54cc7$$ENDHEX$$
		//$$HEX17$$b4b080bd3dcce0ac5cb8200074c7d9b32000c4d6200085c7e0ac200000aca5b22000$$ENDHEX$$
		//============================================				
//		if lvs_arrival_location_code ='HUB' and Gvs_use_hub_warehouse = 'Y' then
//			continue
//		end if
		//============================================		
		j = dw_3.insertrow(0)
		f_set_security_row(dw_3, j , 'ALL')
		
		
		dw_3.object.receipt_date[j] = f_t_sysdate()
		lvl_receipt_seq = f_get_sequence('seq_mat_receipt')
		dw_3.object.receipt_sequence[j] = long(lvl_receipt_seq)
		dw_3.object.receipt_deficit[j] = '1'
		dw_3.object.receipt_status[j] = 'N'	
		
//		if dw_2.object.iqc_inspect_handling[i] = 'U' then 
//		   dw_3.object.receipt_type[j] = 'A'	
//		else
		   dw_3.object.receipt_type[j] = 'N'	
//		end if 
		lvl_receipt_qty = dw_2.object.arrival_qty[i]
		dw_3.object.receipt_qty[j] = lvl_receipt_qty
		
		//==========================================
		//$$HEX33$$90c7d9b39ccde0ac88d47cc72000bdacb0c62000d0c6acc7ccb87cb920006fb8b8d2c4bc5cb8200000adacb958d5c0c94ac594b2e4b220005cc6d0b058d574ba2000$$ENDHEX$$
		//$$HEX16$$90c7d9b39ccde0acdcc2d0c594b220006fb8b8d2c4bc5cb820009ccde0ac2000$$ENDHEX$$
		//$$HEX29$$98ccacb9200060d518c22000c6c530ae200084b538bbd0c52000d0c6acc7ccb820006fb8b8d288bc38d600ac200058c7f8bb00ac2000c6c5e4b2$$ENDHEX$$
		//==========================================
//		if dw_2.object.auto_issue_yn[i] = 'Y' then
//			dw_3.object.material_mfs[j] = '*' 
//		else
			dw_3.object.material_mfs[j] = dw_2.object.material_mfs[i]
//		end if
		
		if Gvs_use_material_mfs = 'Y' then
			dw_3.object.material_mfs[j] = dw_2.object.material_mfs[i]			
		else
			dw_3.object.material_mfs[j] = '*'
		end if
		
		dw_3.object.mfs[j] = dw_2.object.mfs[i]
		dw_3.object.invoice_no[j] = dw_2.object.invoice_no[i]
		
		dw_3.object.arrival_date[j] = dw_2.object.arrival_date[i]
		dw_3.object.arrival_seq_no[j] = dw_2.object.arrival_seq_no[i]			
		
		lvs_item_code = dw_2.object.item_code[i]
		lvs_supplier_code =  dw_2.object.supplier_code[i]
		lvs_origin_supplier_code=  dw_2.object.origin_supplier_code[i]
		lvs_line_type = dw_2.object.line_type[i]
		dw_3.object.item_code[j] = lvs_item_code 
		dw_3.object.incidental_expense_code[j] = dw_2.object.incidental_expense_code[i]		
		dw_3.object.line_type[j] = lvs_line_type		
		dw_3.object.order_type[j] = dw_2.object.order_type[i]					
		dw_3.object.location_code[j] = ddlb_location_code.getcode()
		
		if lvs_line_type = 'P' then 
			lvf_tariff_rate = f_get_tariff_rate( lvs_item_code)
		end if
		
		dw_3.object.receipt_lot_no[j] = lvs_receipt_lot_no		
		dw_3.object.interface_yn[j] = 'N'
		//=============================================================
		// $$HEX19$$6cade4b9e8b200ac20002000b9c278c71cb42000e8b200ac7cb9200070c88cd620005cd5e4b2$$ENDHEX$$
		//=============================================================		
		
		if cbx_ignore_buy_price.checked = true then 
			
			lvd_unit_price  = 1
			lvd_material_cost = 0
			lvs_currency = Gvs_currency
			lvd_exchange_rate = 1
			
			dw_3.object.unit_price[j] = lvd_unit_price 
			dw_3.object.currency[j] = lvs_currency
			dw_3.object.exchange_rate[j] = lvd_exchange_rate
			dw_3.object.delivery[j] = '2'
			
		else
				lvd_unit_price = f_get_item_unit_price_confirm(lvs_supplier_code,lvs_item_code , lvs_line_type, f_t_sysdate())
				
				if ( lvd_unit_price <= 0 or isnull(lvd_unit_price) ) and lvs_line_type <> 'F' then 
					close(w_progress_popup)
					dw_3.reset()
					return 
				else
					dw_3.object.unit_price[j] = lvd_unit_price 
				end if
				
				lvs_currency = gst_return.gvs_return[1]
				
				gst_return.gvs_return[1] = ''		
				if ( lvs_currency  = '' or isnull( lvs_currency  ) ) and lvs_line_type <> 'F' then 
					dw_3.reset()			
					close(w_progress_popup)
					messagebox('Notify','Return currency is error!')
					return 
				else
					dw_3.object.currency[j] = lvs_currency
				end if 
				
				lvd_exchange_rate = gst_return.gvf_return[1]
				gst_return.gvf_return[1] = 0 
				
				if ( lvd_exchange_rate <= 0 or isnull( lvd_exchange_rate )) and lvs_line_type <> 'F' then 
					dw_3.reset()			
					close(w_progress_popup)
					messagebox('Notify','Return exchange rate is error!')
					return 
				else
					dw_3.object.exchange_rate[j] = lvd_exchange_rate
				end if 		
				dw_3.object.delivery[j] = gst_return.gvs_return[2]		
		
				dw_3.object.material_cost[j] =lvd_material_cost
				dw_3.object.receipt_amt[j] = lvl_receipt_qty * lvd_unit_price * lvd_exchange_rate
				dw_3.object.tariff_amt[j]  = Round(dw_3.object.receipt_amt[j]  * lvf_tariff_rate / 100 , 3)
				
				
				dw_3.object.material_cost_amt[j] = lvl_receipt_qty * lvd_material_cost
				dw_3.object.foreign_receipt_amt[j] =   lvl_receipt_qty * lvd_unit_price		
				dw_3.object.confirm_yn[j] = 'Y'
				dw_3.object.confirm_date[j] = f_t_sysdate()
				
				dw_3.object.supplier_code[j] = lvs_supplier_code 
				dw_3.object.supplier_name[j] = dw_2.object.supplier_name[i]
				
				dw_3.object.origin_supplier_code[j] = lvs_origin_supplier_code 
				
		end if 
		
		//=================================
		// $$HEX13$$8cd6c4ac2000dcc2a4c25cd1200078c730d198d374c7a4c22000$$ENDHEX$$interface
		// return : work_no
		//=================================
		if Gvs_interface_yn = 'N' then
		else
//			lvi_return = sqlca.f_interface_receipt(   f_t_sysdate() , &
//																  lvl_receipt_seq , &
//																'1' , &
//																lvs_line_type , &										
//																lvs_supplier_code,  &
//																lvl_receipt_qty * lvd_unit_price * lvd_exchange_rate , &
//																lvl_receipt_qty * lvd_unit_price,  &
//																lvd_exchange_rate, &
//																lvs_currency, &
//																Gvs_user_id,&
//																f_t_sysdate(),  &
//																0 , &
//																Gvi_organization_id ) ;
																
																
			
			if f_sql_check() < 0 then
				return
			end if ;
			
			if lvi_return < 0 then 
				Messagebox("Notify" , "Intrface Error")
				rollback;
				return
				
				
			elseif lvi_return = 0 then 
			else
				
						dw_3.object.interface_date[j] = f_t_sysdate()
						dw_3.object.interface_yn[j] = 'Y'
						dw_3.object.interface_work_no[j] = lvi_return
				
			end if
		end if
		
//=================================		
//	end if 
w_progress_popup.f_stepit()

next 
close(w_progress_popup)



end event

type cbx_direct_receipt from so_checkbox within tabpage_1
integer x = 9
integer width = 466
integer weight = 700
long backcolor = 15780518
string text = "Direct Receipt"
end type

type ddlb_arrival_location_code from uo_arrival_location_code within tabpage_1
integer x = 713
integer y = 68
integer width = 590
integer height = 628
integer taborder = 20
boolean allowedit = false
end type

type st_6 from so_statictext within tabpage_1
integer x = 709
integer y = 4
integer width = 590
integer height = 60
integer weight = 700
long backcolor = 15780518
string text = "Arrival Location Code"
end type

type cb_cancel from so_commandbutton within tabpage_1
integer x = 3118
integer y = 20
integer width = 416
integer height = 116
integer taborder = 70
boolean bringtotop = true
boolean enabled = false
string text = "Cancel"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 
if dw_4.rowcount() = 0 then return 

long i , lvl_qty , lvl_arrival_seq, j 
string lvs_order_no
datetime lvdt_arrival_date

msg = f_msgbox1(1161,this.text)
if msg = 1 then 
else
	return 
end if 
for i = 1 to dw_4.rowcount()
	
	if dw_4.object.check_yn[i] = 'Y' then 

		if (dw_4.object.inspect_result[i] = 'P' OR dw_4.object.inspect_result[i] = 'U') and dw_4.object.inspect_rule[i] = 'I' then
			     MESSAGEBOX("$$HEX2$$668b4a54$$ENDHEX$$","IQC$$HEX28$$a17b06742d4ec068e567d37e9c67c55f7b983a4e497b855f16620d4e08543c684d62fd80db8f4c88646bcd645c4f0cfff78be5670b772c7b$$ENDHEX$$"+STRING(i)+"$$HEX1$$4c88$$ENDHEX$$")
				continue
		else
			if tab_1.tabpage_3.cbx_departure_subsitute_arrival.checked = true and  dw_4.object.arrival_type[i] = 'A'  then 
		
			lvdt_arrival_date = dw_4.object.arrival_date[i]
			lvl_arrival_seq     = dw_4.object.arrival_seq_no[i]
			
			if F_MAT_DEPARTURE_CANCEL( lvdt_arrival_date , lvl_arrival_seq ) < 0 then 
				Return
			end if
		elseif tab_1.tabpage_3.cbx_departure_subsitute_arrival.checked = false and  dw_4.object.arrival_type[i] = 'D'  then 
		
			lvdt_arrival_date = dw_4.object.arrival_date[i]
			lvl_arrival_seq = dw_4.object.arrival_seq_no[i]
			
			if F_MAT_DEPARTURE_CANCEL( lvdt_arrival_date , lvl_arrival_seq ) < 0 then 
				Return
			end if
			
		end if
		end if

		j++
		
	end if 
next 

msg = f_msgbox1(9014,string(j))
if msg = 1 then 
   commit; 
   f_retrieve()
   f_msg_mdi_help(f_msg_st(170))
else 
	rollback; 
	f_msg_mdi_help(f_msg_st(9026))
end if 


end event

type cb_set from so_commandbutton within tabpage_1
integer x = 2706
integer y = 20
integer width = 416
integer height = 116
integer taborder = 40
boolean bringtotop = true
string text = "Batch Select"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 
if dw_1.rowcount() < 1 then return 
long n = 1  , i = 1  , lvl_arrival_seq , j 
Decimal lvl_order_qty,  lvl_arrival_qty, lvl_order_remain_qty, lvl_order_remain_qty_org
string lvs_invoice_no, lvs_supplier_code , lvs_virtual_receipt_yn , lvs_material_mfs , lvs_arrival_location_code , lvs_origin_mfs , lvs_inspect_rule

dw_2.bringtotop = true
dw_1.accepttext()

lvs_arrival_location_code = ddlb_arrival_location_code.getcode()

if lvs_arrival_location_code = '%' or lvs_arrival_location_code = '' or isnull(lvs_arrival_location_code) then
	Messagebox("Notify" , "Arrival Location Code Invalid" )
	return
end if 

msg = f_msgbox1(1161,this.text)
if msg = 1 then 
else 
	return 
end if 


lvs_invoice_no =  sle_invoice_no_cond.text
if lvs_invoice_no  = '' or isnull(lvs_invoice_no ) then 
	lvs_invoice_no = string(f_t_sysdate(),'yyyymmdd') + string(long(f_get_sequence('seq_mat_arrival')),'0000')
end if 
for i = 1 to dw_1.rowcount()
	if dw_1.object.check_yn[i] =  'Y'  then 
	else 
		continue 
	end if 	
	if isnull(dw_1.object.order_group_no[i]) then 
		messagebox('Notify','Please generate order group no ,first')
		return 
	end if 
	lvl_order_qty = dw_1.object.order_qty[i]
	lvl_arrival_qty = dw_1.object.arrival_qty[i]
	lvl_order_remain_qty = dw_1.object.order_remain_qty[i]
	lvl_order_remain_qty_org = dw_1.object.order_remain_qty_org[i]
	
	//=======================================
	// $$HEX11$$fcc838bb18c2c9b7200008cdfcac200000aca5b22000$$ENDHEX$$
	//=======================================
      if Gvs_arrival_excess_order_qty = 'Y' then
	  
      else	
		if lvl_order_remain_qty > lvl_order_remain_qty_org then 
			messagebox('Notify','Arrival qty should not be larger than the order qty')
			return 
		end if 
	end if
	n = dw_2.insertrow(0)
	dw_2.scrolltorow(n)
	f_set_security_row(dw_2, n, 'ALL')
	dw_2.object.arrival_date[n] = f_t_sysdate()
	dw_2.object.departure_date[n] = dw_1.object.departure_date[i]
	lvl_arrival_seq = long(f_get_sequence('seq_mat_arrival'))
	
	dw_2.object.arrival_seq_no[n] = lvl_arrival_seq
	dw_2.object.arrival_seq_no_origin[n] = lvl_arrival_seq	
	
	dw_2.object.arrival_qty[n] = lvl_order_remain_qty
	
	if tab_1.tabpage_3.cbx_departure_subsitute_arrival.checked = true then 
		dw_2.object.arrival_type[n] = 'A'   //$$HEX16$$9ccd1cbc44c72000c4b329cc3cc75cb8200000b3e0c268d5200035c658c12000$$ENDHEX$$
	else
		dw_2.object.arrival_type[n] = 'D'		
	end if
	
	dw_2.object.arrival_status[n] = 'N'
	dw_2.object.order_no[n] =  dw_1.object.order_no[i]
	dw_2.object.line_type[n] = dw_1.object.line_type[i]
	dw_2.object.comments[n] = dw_1.object.shipment_comment[i]
	dw_2.object.order_type[n] = dw_1.object.order_type[i]
	//=============================================================
	//
	//=============================================================
	
	lvs_inspect_rule = F_GET_MAT_INSPECT_RULE(dw_1.object.supplier_code[i] ,dw_1.object.item_code[i] )
	
	if lvs_inspect_rule = 'P' then
		
		dw_2.object.inspect_result[n] = 'P'
		dw_2.object.inspect_rule[n] = lvs_inspect_rule
		
	else
		dw_2.object.inspect_result[n] = 'W'
		dw_2.object.inspect_rule[n] = lvs_inspect_rule
	end if
	dw_2.object.unit_price[n]  = dw_1.object.unit_price[i]	
	dw_2.object.arrival_amt[n] =  dw_1.object.unit_price[i]  *  lvl_order_remain_qty
	dw_2.object.currency[n]  =  dw_1.object.currency[i]

	dw_2.object.delivery[n]  = dw_1.object.delivery[i]
	dw_2.object.delivery_date[n]  = dw_1.object.delivery_date[i]	
	dw_2.object.invoice_no[n] = lvs_invoice_no
	dw_2.object.order_group_no[n] = dw_1.object.order_group_no[i]
	
	if dw_1.object.mfs[i] = '' or isnull(dw_1.object.mfs[i]) then 
		dw_2.object.mfs[n] = '*'
	else
		dw_2.object.mfs[n] = dw_1.object.mfs[i]
	end if
	
	lvs_material_mfs = dw_1.object.material_mfs[i]	
	
	if lvs_material_mfs='' or isnull(lvs_material_mfs) then 
		dw_2.object.material_mfs[n] =  '*'
	else
		dw_2.object.material_mfs[n] =  lvs_material_mfs
	end if
	
	dw_2.object.subcontract_invoice_no[n] =  dw_1.object.subcontract_invoice_no[i]
	//=============================================
	// $$HEX35$$34bbc1c0acc009ae00acf5ac88d42000c4b329ccdcc22000d0c66fb8b8d288bc38d67cb9200030ae00c93cc75cb8200034bbc1c0acc009ae98cc58c72000acc7e0ac7cb92000$$ENDHEX$$
	// $$HEX30$$10ac8cc198ccacb958d594b22000bdacb0c62000d0c66fb8b8d2200088bc38d67cb9200070c874ac3cc75cb8200010ac8cc1dcc2a4d0c0bb5cb82000$$ENDHEX$$
	// $$HEX16$$34bbc1c0acc009ae88d4200085c7e0acdcc2200058c7f8bb00ac200088c74cc7$$ENDHEX$$
	//=============================================
	lvs_origin_mfs = dw_1.object.origin_mfs[i]	
	
	if lvs_origin_mfs='' or isnull(lvs_origin_mfs) then 
		dw_2.object.origin_mfs[n] =  '*'
	else
		dw_2.object.origin_mfs[n] =  lvs_origin_mfs
	end if	
	
	//==============================================

	dw_2.object.supplier_code[n]  = dw_1.object.supplier_code[i]
	dw_2.object.supplier_name[n] = dw_1.object.supplier_name[i]
	dw_2.object.item_code[n] = dw_1.object.item_code[i]		
	dw_2.object.incidental_expense_code[n] = dw_1.object.incidental_expense_code[i]		
	
	//===================================
	// $$HEX22$$dcc2a4c25cd1200058d6bdacd0c51cc12000c8d580bd3dcce0ac7cb92000b4c601c658d58cac18b474ba2000$$ENDHEX$$
	// $$HEX21$$acc0a9c690c700ac200020c1ddd05cd520003dcce0ac7cb92000c4b329cc98ccacb97cb9200058d5e0ac$$ENDHEX$$
	// $$HEX26$$c8d50cbe3dcce0ac7cb92000b4c601c658d5c0c920004ac53cc774ba2000a8ba50b42000b4b080bd3dcce0ac5cb8200024c115c8$$ENDHEX$$
	//===================================
	if Gvs_use_hub_warehouse = 'Y' then
		dw_2.object.arrival_location_code[n] = lvs_arrival_location_code
	else
		dw_2.object.arrival_location_code[n] = 'INSIDE'
	end if
	//========================================
	// $$HEX11$$c4b329cc200018c2c9b72000c9b720009dc900ac2000$$ENDHEX$$
	// $$HEX6$$30aec4b329cc18c2c9b72000$$ENDHEX$$+ $$HEX24$$e0c2dcad9ccd1cbc200018c2c9b744c7200054b374d51cc12000c4b329cc18c2c9b7d0c52000c5c570b374c7b8d22000$$ENDHEX$$
	//========================================
	dw_1.object.arrival_qty[i] = lvl_arrival_qty + lvl_order_remain_qty //$$HEX8$$e0c2dcad9ccd1cbc200018c2c9b72000$$ENDHEX$$
	dw_2.object.selected_row[n] = i
 j++
next
//==============================================
// 
//==============================================

IF cbx_direct_receipt.CHECKED = TRUE THEN 
	
	cb_batch_receipt.triggerevent( clicked!)
	
END IF 


//==============================================
//
//==============================================
if dw_2.rowcount() <  1 then return 

msg = f_msgbox1(9014,string(j))
if msg = 1 then 

	if dw_1.update() < 0  or dw_2.update() < 0 or dw_3.update() < 0  then 
		rollback ; 
		f_msg_mdi_help(f_msg_st(9026))
	else
		commit ; 
		f_msg_mdi_help(f_msg_st(170))
		f_retrieve()
	end if 
	
elseif msg = 2 then
	
else
	 dw_2.reset()	
end if 

end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 4494
integer height = 152
long backcolor = 12632256
string text = "Print"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Print!"
long picturemaskcolor = 12632256
cb_preview cb_preview
cb_print cb_print
cbx_dialog cbx_dialog
em_copy em_copy
st_2 st_2
end type

on tabpage_2.create
this.cb_preview=create cb_preview
this.cb_print=create cb_print
this.cbx_dialog=create cbx_dialog
this.em_copy=create em_copy
this.st_2=create st_2
this.Control[]={this.cb_preview,&
this.cb_print,&
this.cbx_dialog,&
this.em_copy,&
this.st_2}
end on

on tabpage_2.destroy
destroy(this.cb_preview)
destroy(this.cb_print)
destroy(this.cbx_dialog)
destroy(this.em_copy)
destroy(this.st_2)
end on

type cb_preview from so_commandbutton within tabpage_2
integer x = 1545
integer y = 24
integer width = 407
integer height = 112
integer taborder = 80
boolean bringtotop = true
string text = "Preview"
end type

event clicked;call super::clicked;if rb_departure.checked = true then 
	if  ivs_preview_yn = 'Y' THEN 
		ivs_preview_yn = 'N' 	
		dw_4.bringtotop = TRUE
	else
		ivs_preview_yn = 'Y' 	
		dw_5.bringtotop = TRUE			
		if dw_5.Describe("DataWindow.Print.Preview") = '!' or dw_5.Describe("DataWindow.Print.Preview") = '?' then
		else
			 dw_5.Modify("DataWindow.Print.Preview=yes")
			dw_5.Modify("DataWindow.Print.Preview.Rulers=yes")
		end if		
	end if
end if
	
end event

type cb_print from so_commandbutton within tabpage_2
integer x = 1952
integer y = 24
integer width = 407
integer height = 112
integer taborder = 90
boolean bringtotop = true
string text = "Print"
end type

event clicked;call super::clicked;Int		i, lvi_cnt , rows

If dw_5.rowcount() < 1 Then Return

		lvi_cnt = Integer(em_copy.text)
		If lvi_cnt > 0 Then
			If rb_departure.checked = True Then
				For i = 1 To lvi_cnt
					
					if cbx_dialog.checked = true then 
						dw_5.print(false, True)
					else
						dw_5.print(false, False)						
					end if
				Next
			End If
		End If

end event

type cbx_dialog from so_checkbox within tabpage_2
integer x = 699
integer y = 40
integer width = 393
integer height = 84
boolean bringtotop = true
integer weight = 700
string text = "Show Dialog"
end type

type em_copy from so_editmask within tabpage_2
integer x = 325
integer y = 40
integer width = 311
integer taborder = 50
boolean bringtotop = true
string text = "1"
string mask = "##0"
boolean spin = true
end type

type st_2 from so_statictext within tabpage_2
integer x = 14
integer y = 52
integer width = 311
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Print Copy"
end type

type tabpage_3 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 4494
integer height = 152
long backcolor = 15780518
string text = "Option"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "CheckBox!"
long picturemaskcolor = 12632256
cbx_2 cbx_2
cbx_excess_order_qty cbx_excess_order_qty
cbx_departure_subsitute_arrival cbx_departure_subsitute_arrival
end type

on tabpage_3.create
this.cbx_2=create cbx_2
this.cbx_excess_order_qty=create cbx_excess_order_qty
this.cbx_departure_subsitute_arrival=create cbx_departure_subsitute_arrival
this.Control[]={this.cbx_2,&
this.cbx_excess_order_qty,&
this.cbx_departure_subsitute_arrival}
end on

on tabpage_3.destroy
destroy(this.cbx_2)
destroy(this.cbx_excess_order_qty)
destroy(this.cbx_departure_subsitute_arrival)
end on

type cbx_2 from so_checkbox within tabpage_3
integer x = 2007
integer y = 36
integer width = 613
integer height = 80
integer weight = 700
long backcolor = 15780518
boolean enabled = false
string text = "Use Material MFS"
end type

event constructor;call super::constructor;if Gvs_use_material_mfs = 'Y' then 
	this.checked = true 
else
	this.checked = false
end if
end event

type cbx_excess_order_qty from so_checkbox within tabpage_3
integer x = 1010
integer y = 36
integer width = 759
integer height = 80
boolean bringtotop = true
integer weight = 700
long backcolor = 15780518
boolean enabled = false
string text = "Arrival  Excess Order Qty"
end type

event constructor;call super::constructor;if Gvs_arrival_excess_order_qty= 'Y' then
	this.checked = True
else
	this.checked = False	
end if
end event

type cbx_departure_subsitute_arrival from so_checkbox within tabpage_3
integer x = 32
integer y = 36
integer width = 759
integer height = 80
boolean bringtotop = true
integer weight = 700
long backcolor = 15780518
boolean enabled = false
string text = "Substitute for the arrival"
boolean checked = true
end type

event constructor;call super::constructor;if Gvs_substitute_for_arrival = 'Y' then
	this.checked = True
else
	this.checked = False	
end if
end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 4494
integer height = 152
long backcolor = 12632256
string text = "Lot Manage"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "ArrangeTables!"
long picturemaskcolor = 12632256
cb_merge cb_merge
cb_divide cb_divide
end type

on tabpage_4.create
this.cb_merge=create cb_merge
this.cb_divide=create cb_divide
this.Control[]={this.cb_merge,&
this.cb_divide}
end on

on tabpage_4.destroy
destroy(this.cb_merge)
destroy(this.cb_divide)
end on

type cb_merge from so_commandbutton within tabpage_4
integer x = 357
integer y = 28
integer width = 315
integer height = 100
integer taborder = 50
boolean bringtotop = true
string text = "Merge"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 
if dw_1.rowcount() < 1  then return 

long i , j= 0 , k= 1 , lvl_row[]
Decimal lvl_order_qty
msg = f_msgbox1(1161, this.text)
if msg = 1 then 
else
	return 
end if 
for i = 1 to dw_1.rowcount() 
     if dw_1.object.check_yn[i] = 'Y'  then 
		if dw_1.object.arrival_qty[i] = 0 then 
		else
		     messagebox('Notify','The arrival qty of this record is found,so it can not be performed!')
		     return 
		end if 
		j++
		lvl_row[k] = dw_1.object.selected_row[i]
		k++
	else
		continue 
	end if 				
next 
if j <>  2  then 
	messagebox('Notify','You would select two records.') 
	return 
end if 
if (dw_1.object.item_code[lvl_row[1]] = dw_1.object.item_code[lvl_row[2]]) and (dw_1.object.supplier_code[lvl_row[1]] = dw_1.object.supplier_code[lvl_row[2]])  and &
   (dw_1.object.unit_price[lvl_row[1]] = dw_1.object.unit_price[lvl_row[2]]) and (dw_1.object.line_type[lvl_row[1]] = dw_1.object.line_type[lvl_row[2]]) then 
	
	lvl_order_qty = dw_1.object.order_qty[lvl_row[1]]  + dw_1.object.order_qty[lvl_row[2]]
	dw_1.object.order_qty[lvl_row[1]]  = lvl_order_qty
	dw_1.object.order_amt[lvl_row[1]] = dw_1.object.order_qty[lvl_row[1]] * dw_1.object.unit_price[lvl_row[1]]	
	dw_1.object.check_yn[lvl_row[1]] = 'N'
	dw_1.deleterow(lvl_row[2])
else
	messagebox('Notify','Two records are not match,please select again.')
	return 
end if 

msg = f_msgbox(1170)
if msg = 1 then 

	if dw_1.update() < 0 then 
		rollback; 
		f_msg_mdi_help(f_msg_st(9026))
	else
		commit; 
		f_msg_mdi_help(f_msg_st(170))
		f_retrieve()
	end if 
else
	f_retrieve()
end if

	

		
end event

type cb_divide from so_commandbutton within tabpage_4
integer x = 37
integer y = 28
integer width = 315
integer height = 100
integer taborder = 40
boolean bringtotop = true
string text = "Divide"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 
if dw_1.rowcount() < 1 then return 
Long j
Decimal  lvl_origin_qty, lvl_new_qty, lvl_arrival_qty
String lvs_date
msg = f_msgbox1(1161, this.text)
if msg = 1 then 
else
	return 
end if 
if dw_1.object.check_yn[dw_1.getrow()] = 'Y' then 		
else
	return 
end if 
lvl_arrival_qty = dw_1.object.arrival_qty[dw_1.getrow()]
if dw_1.object.arrival_qty[dw_1.getrow()] = 0 then 
else
	messagebox('Notify','The arrival qty of this record is found,so it can not be performed!')
	return 
end if 

lvl_origin_qty =  dw_1.object.order_qty[dw_1.getrow()]
openwithparm(w_mat_order_qty_divide_popup, lvl_origin_qty)
if gst_return.gvb_return = false then 
	return
else 	
	lvl_new_qty = gst_return.gvl_return[1]
	gst_return.gvl_return[1] = 0 
end if 
if lvl_new_qty >= lvl_origin_qty  then 
	messagebox('Notify','Divide Qty Should be smaller than the origin qty, please do again!')
	return 
end if 
j = dw_1.getrow()

dw_1.rowscopy(j, j, Primary!, dw_1, j+1 , Primary!)
dw_1.object.order_qty[j] = lvl_origin_qty -  lvl_new_qty
dw_1.object.order_amt[j] = dw_1.object.order_qty[j] * dw_1.object.unit_price[j]

dw_1.object.order_qty[j + 1]  = lvl_new_qty
dw_1.object.order_amt[j +1] = dw_1.object.order_qty[j+1] * dw_1.object.unit_price[j+1]
lvs_date =  string(dw_1.object.purchase_order_date[j],'yyyymmdd') + string( f_get_sequence( 'SEQ_PURCHASE_ORDER_NO'),'000')
dw_1.object.mfs[j + 1]  = lvs_date
dw_1.object.order_no[j + 1]  = lvs_date
dw_1.object.check_yn[j] = 'N'
dw_1.object.check_yn[j+1] = 'N'
if dw_1.update() < 0 then 
	rollback; 
	f_msg_mdi_help(f_msg_st(9026))
else
	commit; 
	f_msg_mdi_help(f_msg_st(170))
	f_retrieve()
end if 


end event

type st_5 from so_statictext within w_mat_departure_master
integer x = 2939
integer y = 92
integer width = 453
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Item Spec"
end type

type st_14 from so_statictext within w_mat_departure_master
integer x = 2482
integer y = 92
integer width = 448
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Item Name"
end type

type sle_item_name from so_singlelineedit within w_mat_departure_master
integer x = 2482
integer y = 160
integer width = 448
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
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
STRING LVS_VALUE , LVS_COLUMN

dw_1.SETFILTER('')
dw_1.FILTER()

LVS_COLUMN = 'ITEM_NAME'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    dw_1.SETFILTER('')
    dw_1.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

dw_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found" )
end event

type sle_1 from so_singlelineedit within w_mat_departure_master
integer x = 2939
integer y = 160
integer width = 453
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
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
STRING LVS_VALUE , LVS_COLUMN

dw_1.SETFILTER('')
dw_1.FILTER()

LVS_COLUMN = 'ITEM_SPEC'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    dw_1.SETFILTER('')
    dw_1.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

dw_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found" )
end event

type st_8 from so_statictext within w_mat_departure_master
integer x = 3438
integer y = 96
integer width = 453
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Invoice No"
end type

type sle_invoice_no from so_singlelineedit within w_mat_departure_master
integer x = 3401
integer y = 160
integer width = 558
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

type gb_1 from so_groupbox within w_mat_departure_master
integer width = 677
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_2 from so_groupbox within w_mat_departure_master
integer x = 686
integer width = 3319
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

