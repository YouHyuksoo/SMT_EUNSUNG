HA$PBExportHeader$w_mat_receipt_return_master.srw
$PBExportComments$Material Receipt Cancel Master
forward
global type w_mat_receipt_return_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mat_receipt_return_master
end type
type uo_dateend from uo_ymd_calendar within w_mat_receipt_return_master
end type
type ddlb_item_code from uo_item_code within w_mat_receipt_return_master
end type
type st_3 from so_statictext within w_mat_receipt_return_master
end type
type st_4 from so_statictext within w_mat_receipt_return_master
end type
type rb_cancel from so_radiobutton within w_mat_receipt_return_master
end type
type rb_hst from so_radiobutton within w_mat_receipt_return_master
end type
type ddlb_supplier_code from uo_supplier_code within w_mat_receipt_return_master
end type
type st_1 from so_statictext within w_mat_receipt_return_master
end type
type sle_item_name from so_singlelineedit within w_mat_receipt_return_master
end type
type st_14 from so_statictext within w_mat_receipt_return_master
end type
type st_2 from so_statictext within w_mat_receipt_return_master
end type
type sle_1 from so_singlelineedit within w_mat_receipt_return_master
end type
type cb_batch from so_commandbutton within w_mat_receipt_return_master
end type
type cbx_auto_purchase from so_checkbox within w_mat_receipt_return_master
end type
type st_5 from so_statictext within w_mat_receipt_return_master
end type
type uo_cancel_date from uo_ymd_calendar within w_mat_receipt_return_master
end type
type cbx_allow_last_mm_cancel from so_checkbox within w_mat_receipt_return_master
end type
type ddlb_location_code from uo_basecode within w_mat_receipt_return_master
end type
type st_6 from so_statictext within w_mat_receipt_return_master
end type
type ddlb_location_code_cond from uo_basecode within w_mat_receipt_return_master
end type
type st_7 from so_statictext within w_mat_receipt_return_master
end type
type st_8 from so_statictext within w_mat_receipt_return_master
end type
type sle_invoice_no from so_singlelineedit within w_mat_receipt_return_master
end type
type gb_1 from so_groupbox within w_mat_receipt_return_master
end type
type gb_2 from so_groupbox within w_mat_receipt_return_master
end type
type gb_3 from so_groupbox within w_mat_receipt_return_master
end type
end forward

global type w_mat_receipt_return_master from w_main_root
integer width = 4914
integer height = 2952
string title = "Material Receipt Cancel  Master"
uo_dateset uo_dateset
uo_dateend uo_dateend
ddlb_item_code ddlb_item_code
st_3 st_3
st_4 st_4
rb_cancel rb_cancel
rb_hst rb_hst
ddlb_supplier_code ddlb_supplier_code
st_1 st_1
sle_item_name sle_item_name
st_14 st_14
st_2 st_2
sle_1 sle_1
cb_batch cb_batch
cbx_auto_purchase cbx_auto_purchase
st_5 st_5
uo_cancel_date uo_cancel_date
cbx_allow_last_mm_cancel cbx_allow_last_mm_cancel
ddlb_location_code ddlb_location_code
st_6 st_6
ddlb_location_code_cond ddlb_location_code_cond
st_7 st_7
st_8 st_8
sle_invoice_no sle_invoice_no
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_mat_receipt_return_master w_mat_receipt_return_master

on w_mat_receipt_return_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.ddlb_item_code=create ddlb_item_code
this.st_3=create st_3
this.st_4=create st_4
this.rb_cancel=create rb_cancel
this.rb_hst=create rb_hst
this.ddlb_supplier_code=create ddlb_supplier_code
this.st_1=create st_1
this.sle_item_name=create sle_item_name
this.st_14=create st_14
this.st_2=create st_2
this.sle_1=create sle_1
this.cb_batch=create cb_batch
this.cbx_auto_purchase=create cbx_auto_purchase
this.st_5=create st_5
this.uo_cancel_date=create uo_cancel_date
this.cbx_allow_last_mm_cancel=create cbx_allow_last_mm_cancel
this.ddlb_location_code=create ddlb_location_code
this.st_6=create st_6
this.ddlb_location_code_cond=create ddlb_location_code_cond
this.st_7=create st_7
this.st_8=create st_8
this.sle_invoice_no=create sle_invoice_no
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.ddlb_item_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.rb_cancel
this.Control[iCurrent+7]=this.rb_hst
this.Control[iCurrent+8]=this.ddlb_supplier_code
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.sle_item_name
this.Control[iCurrent+11]=this.st_14
this.Control[iCurrent+12]=this.st_2
this.Control[iCurrent+13]=this.sle_1
this.Control[iCurrent+14]=this.cb_batch
this.Control[iCurrent+15]=this.cbx_auto_purchase
this.Control[iCurrent+16]=this.st_5
this.Control[iCurrent+17]=this.uo_cancel_date
this.Control[iCurrent+18]=this.cbx_allow_last_mm_cancel
this.Control[iCurrent+19]=this.ddlb_location_code
this.Control[iCurrent+20]=this.st_6
this.Control[iCurrent+21]=this.ddlb_location_code_cond
this.Control[iCurrent+22]=this.st_7
this.Control[iCurrent+23]=this.st_8
this.Control[iCurrent+24]=this.sle_invoice_no
this.Control[iCurrent+25]=this.gb_1
this.Control[iCurrent+26]=this.gb_2
this.Control[iCurrent+27]=this.gb_3
end on

on w_mat_receipt_return_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.ddlb_item_code)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.rb_cancel)
destroy(this.rb_hst)
destroy(this.ddlb_supplier_code)
destroy(this.st_1)
destroy(this.sle_item_name)
destroy(this.st_14)
destroy(this.st_2)
destroy(this.sle_1)
destroy(this.cb_batch)
destroy(this.cbx_auto_purchase)
destroy(this.st_5)
destroy(this.uo_cancel_date)
destroy(this.cbx_allow_last_mm_cancel)
destroy(this.ddlb_location_code)
destroy(this.st_6)
destroy(this.ddlb_location_code_cond)
destroy(this.st_7)
destroy(this.st_8)
destroy(this.sle_invoice_no)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
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
Ivs_resize_type                      = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


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
F_MENU_CONTROL('DATA_CONTROL_MODIFY' , TRUE)  // All Data Control





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
	
			if rb_cancel.checked = true  then 
			    dw_1.retrieve(ddlb_item_code.text() + '%', ddlb_supplier_code.text +'%', uo_dateset.text(), uo_dateend.text(),  gvs_material_receipt_auto_confirm , ddlb_location_code_cond.getcode( )+'%' , gvi_organization_id)
			else
				dw_2.retrieve(ddlb_item_code.text() + '%', ddlb_supplier_code.text +'%' , uo_dateset.text() , uo_dateend.text(), ddlb_location_code_cond.getcode( )+'%' , '%'+sle_invoice_no.text+'%' ,  gvi_organization_id)
			end if 
	
//    case 'INSERT'
//		
//			ROW = DW_2.INSERTROW(DW_2.GETROW())
//			DW_2.SCROLLTOROW(ROW)
//			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')
//			lvd_seq = f_get_sequence('seq_mat_arrival')
//			lvs_date = string(f_t_sysdate(),'yyyymmdd') + string(lvd_seq)
//			dw_2.object.arrival_date[row] = f_t_sysdate()
//			dw_2.object.inspect_date[row] = f_t_sysdate()
//			dw_2.object.arrival_seq_no[row] = lvd_seq
//			dw_2.object.invoice_no[row] = lvs_date
//			dw_2.object.order_no[row] = lvs_date
//			dw_2.object.mfs[row] = lvs_date
//			dw_2.object.arrival_status[row] = 'N'
//			dw_2.object.inspect_result[row]  = 'P'
//			dw_2.object.inspect_rule[row]  = 'P'			
//			
//	case 'APPEND'		
//			
//			ROW = DW_2.INSERTROW(DW_2.GETROW())
//			DW_2.SCROLLTOROW(ROW)
//			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')	
//			lvd_seq = f_get_sequence('seq_mat_arrival')
//			lvs_date = string(f_t_sysdate(),'yyyymmdd') + string(lvd_seq)
//			dw_2.object.arrival_date[row] = f_t_sysdate()
//			dw_2.object.inspect_date[row] = f_t_sysdate()
//			dw_2.object.arrival_seq_no[row] = lvd_seq
//			dw_2.object.invoice_no[row] = lvs_date
//			dw_2.object.order_no[row] = lvs_date
//			dw_2.object.mfs[row] = lvs_date
//			dw_2.object.arrival_status[row] = 'N'
//			dw_2.object.inspect_result[row]  = 'P'
//			dw_2.object.inspect_rule[row]  = 'P'
//			
//	case 'DELETE'
//		
//		  	if DW_2.AcceptText() = -1 then
//				return
//			end if
//			
//			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
//			IF MSG = 1 THEN
//				Gvl_row_deleted = DW_2.GetRow()			
//				DW_2.DELETEROW(Gvl_row_deleted)		
//				DW_2.SetFocus()
//				ROW = DW_2.GetRow()
//				DW_2.ScrollToRow(row)
//				DW_2.SetColumn(1)
//			END IF		 
//   case 'UPDATE'
//		long lvl_seq, lvl_return , i , j 
//		string lvs_mfs
//		datetime lvdt_date
//		msg = f_msgbox1(1161,'Update')
//		if msg = 1  then 
//		else
//			return 
//		end if 
//		for i = 1 to dw_1.rowcount()
//			if dw_1.object.check_yn[i] = 'Y' then 
//				lvdt_date = dw_1.object.receipt_date[i]
//				lvl_seq = dw_1.object.receipt_sequence[i]
//				lvl_return = f_mat_receipt_cancel(lvdt_date, lvl_seq)
//				if lvl_return < 1  then 
//					rollback;
//					return
//				else				
//					update  im_item_arrival
//					set       arrival_type = 'A' , 
//					           receipt_date  =  NULL,
//							   receipt_sequence = 0 
//					where   receipt_sequence = :lvl_seq
//					and      organization_id = :gvi_organization_id ; 
//					if f_sql_check() < 0 then return 
//				end if 
//				j++
//			end if 
//		next
//		if j >0 then 
//			msg = f_msgbox1(9014,string(j))
//			if msg = 1 then 
//				commit ; 
//				f_retrieve()
//			else
//				rollback; 
//				f_msg_mdi_help('Update error')
//			end if 
//		end if 
//			
	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mat_receipt_return_master
integer y = 624
end type

type dw_4 from w_main_root`dw_4 within w_mat_receipt_return_master
integer y = 624
end type

type dw_3 from w_main_root`dw_3 within w_mat_receipt_return_master
integer y = 572
end type

type dw_2 from w_main_root`dw_2 within w_mat_receipt_return_master
integer y = 572
integer width = 4549
integer height = 2228
boolean titlebar = true
string title = "Material Receipt History"
string dataobject = "d_mat_receipt_hst"
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_mat_receipt_return_master
integer y = 572
integer width = 4544
integer height = 2228
boolean titlebar = true
string title = "Material Receipt Return List"
string dataobject = "d_mat_receipt_return_lst"
end type

event dw_1::itemchanged;call super::itemchanged;if dwo.name = 'return_qty' then 
	if data = '0' or isnull(data)  then 
			this.object.check_yn[row] = 'N'
	else
		this.object.check_yn[row] = 'Y'
	end if 
end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_receipt_return_master
end type

type uo_dateset from uo_ymd_calendar within w_mat_receipt_return_master
event destroy ( )
integer x = 1819
integer y = 160
integer taborder = 30
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_receipt_return_master
event destroy ( )
integer x = 2235
integer y = 160
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_item_code from uo_item_code within w_mat_receipt_return_master
integer x = 750
integer y = 160
integer width = 626
integer taborder = 20
boolean bringtotop = true
end type

type st_3 from so_statictext within w_mat_receipt_return_master
integer x = 750
integer y = 80
integer width = 626
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type st_4 from so_statictext within w_mat_receipt_return_master
integer x = 1824
integer y = 80
integer width = 814
boolean bringtotop = true
integer weight = 700
string text = "Date"
end type

type rb_cancel from so_radiobutton within w_mat_receipt_return_master
integer x = 55
integer y = 80
integer width = 613
boolean bringtotop = true
integer weight = 700
string text = "Receipt Cancel List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1



end event

type rb_hst from so_radiobutton within w_mat_receipt_return_master
integer x = 55
integer y = 168
integer width = 613
boolean bringtotop = true
integer weight = 700
string text = "Receipt History"
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
selected_data_window = dw_2


end event

type ddlb_supplier_code from uo_supplier_code within w_mat_receipt_return_master
integer x = 1381
integer y = 160
integer width = 439
integer height = 692
integer taborder = 20
boolean bringtotop = true
end type

type st_1 from so_statictext within w_mat_receipt_return_master
integer x = 1381
integer y = 80
integer width = 439
boolean bringtotop = true
integer weight = 700
string text = "Supplier Code"
end type

type sle_item_name from so_singlelineedit within w_mat_receipt_return_master
integer x = 2647
integer y = 160
integer width = 384
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

SELECTED_DATA_WINDOW.SETFILTER('')
SELECTED_DATA_WINDOW.FILTER()

LVS_COLUMN = 'ITEM_NAME'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    SELECTED_DATA_WINDOW.SETFILTER('')
    SELECTED_DATA_WINDOW.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
SELECTED_DATA_WINDOW.FILTER()
F_MSG_MDI_HELP( STRING( SELECTED_DATA_WINDOW.ROWCOUNT() ) + " Found" )
end event

type st_14 from so_statictext within w_mat_receipt_return_master
integer x = 2647
integer y = 92
integer width = 384
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Item Name"
end type

type st_2 from so_statictext within w_mat_receipt_return_master
integer x = 3045
integer y = 92
integer width = 443
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Item Spec"
end type

type sle_1 from so_singlelineedit within w_mat_receipt_return_master
integer x = 3040
integer y = 160
integer width = 443
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

SELECTED_DATA_WINDOW.SETFILTER('')
SELECTED_DATA_WINDOW.FILTER()

LVS_COLUMN = 'ITEM_SPEC'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    SELECTED_DATA_WINDOW.SETFILTER('')
    SELECTED_DATA_WINDOW.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
SELECTED_DATA_WINDOW.FILTER()
F_MSG_MDI_HELP( STRING( SELECTED_DATA_WINDOW.ROWCOUNT() ) + " Found" )
end event

type cb_batch from so_commandbutton within w_mat_receipt_return_master
integer x = 1824
integer y = 428
integer width = 503
integer height = 116
integer taborder = 40
boolean bringtotop = true
string text = "Batch Return"
end type

event clicked;call super::clicked;long  lvl_return , i , j 
integer  lvl_row
string lvs_mfs , lvs_new_order_type , lvs_location_code
double lvl_seq,lvdb_work_no
datetime lvdt_date , lvdt_work_date , lvdt_cancel_date
Decimal lvf_return_qty

//====================================
// 
//====================================
msg = f_msgbox1(1161,this.text)
if msg = 1  then 
else
	return 
end if 
dw_1.accepttext()

lvs_location_code = ddlb_location_code.getcode()

for lvl_row = dw_1.rowcount() to 1 step -1
	if dw_1.getitemstring(lvl_row ,'confirm_yn') = 'Y' then continue
next

for i = 1 to dw_1.rowcount()

	if dw_1.object.check_yn[i] = 'Y' then 
		
		lvdt_date = dw_1.object.receipt_date[i]
		lvdt_cancel_date = uo_cancel_date.text()

		//========================================
		// $$HEX24$$f9b2d4c674c704c8200085c7e0ac2000e8cd8cc1200000aca5b2ecc580bd200058d6bdacc0bc18c2200080acacc02000$$ENDHEX$$
		// Gvs_allow_last_month_receipt_cancel
		//========================================
		if  Gvs_allow_last_mm_receipt_cancel= 'Y' then 	
		else
			if  lvdt_date < f_get_first_day() then 
				Messagebox("Notify" , "Last Month Receipted Item Cant`t Cancel")
			   continue
			end if
		end if
		
		lvl_seq = dw_1.object.receipt_sequence[i]
		lvf_return_qty = dw_1.object.return_qty[i]
		lvs_new_order_type = dw_1.object.new_order_type[i]
		
		if lvf_return_qty <= 0 then 
			continue
		end if 
		
		//====================================
		// $$HEX5$$85c7e0ac200018bc88d4$$ENDHEX$$
		//$$HEX19$$acc0a9c690c700ac200085c725b82000a0b0dcc95cb82000e8cd8cc1200098ccacb968d52000$$ENDHEX$$
		//====================================		
		
		if lvs_location_code = '%' or isnull(lvs_location_code) or lvs_location_code = '' then 
			Setnull(lvs_location_code )
//			f_msgbox()
		end if 
		lvl_return = f_mat_receipt_return(lvdt_cancel_date, lvdt_date, lvl_seq , lvf_return_qty , lvs_location_code )		
		if lvl_return < 0  then 
			rollback;
			Messagebox("Notify" , "Receipt Return Error")
			return
		end if 

		//====================================
		// $$HEX5$$90c7d9b31cbcfcc82000$$ENDHEX$$
		//====================================		

		if cbx_auto_purchase.checked = true then 
			
			lvl_return = f_mat_receipt_return_auto_order(lvdt_date, lvl_seq , abs(lvf_return_qty),lvs_new_order_type)
			if lvl_return < 0  then 
				rollback;
				Messagebox("Notify" , "Auto Purchase Order Error")
				return
			end if 		
			
		end if
		//====================================				
		Integer lvi_return		
		Decimal lvd_exchange_rate , lvd_unit_price
		String lvs_line_type , lvs_supplier_code , lvs_currency

		lvs_line_type = dw_1.object.line_type[i]
		lvs_supplier_code = dw_1.object.supplier_code[i]
		lvd_exchange_rate = dw_1.object.exchange_rate[i]
		lvs_currency = dw_1.object.currency[i]
		lvd_unit_price = dw_1.object.unit_price[i]
		
		//=================================
		// $$HEX13$$8cd6c4ac2000dcc2a4c25cd1200078c730d198d374c7a4c22000$$ENDHEX$$interface
		// return : work_no
		//=================================
		if Gvs_interface_yn = 'N' then
		else
//			lvi_return = sqlca.f_interface_receipt(   f_t_sysdate() , &
//																 lvl_seq , &
//																'1' , &
//																lvs_line_type , &										
//																lvs_supplier_code,  &
//																lvf_return_qty * lvd_unit_price * lvd_exchange_rate , &
//																lvf_return_qty * lvd_unit_price,  &
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
				
						dw_1.object.interface_date[j] = f_t_sysdate()
						dw_1.object.interface_yn[j] = 'Y'
						dw_1.object.interface_work_no[j] = lvi_return
				
			end if		
		end if

		j++
	end if 
next
if j >0 then 
	msg = f_msgbox1(9014,string(j))
	if msg = 1 then 
		
		if dw_1.update() < 0 then
			rollback;
		else
			commit ; 
			f_retrieve()
		end if
	else
		rollback; 
		f_msg_mdi_help(f_msg_st(173) )
	end if 
end if 
	
end event

type cbx_auto_purchase from so_checkbox within w_mat_receipt_return_master
integer x = 55
integer y = 468
integer height = 72
boolean bringtotop = true
string text = "Auto P/O"
end type

event constructor;call super::constructor;IF Gvs_material_receipt_return_auto_po = 'Y' then
	this.checked = true
else
	this.checked = false
end if
end event

type st_5 from so_statictext within w_mat_receipt_return_master
integer x = 722
integer y = 388
integer width = 416
integer height = 52
boolean bringtotop = true
integer weight = 700
long textcolor = 255
string text = "Return Date"
end type

type uo_cancel_date from uo_ymd_calendar within w_mat_receipt_return_master
integer x = 722
integer y = 456
integer taborder = 60
boolean bringtotop = true
end type

on uo_cancel_date.destroy
call uo_ymd_calendar::destroy
end on

type cbx_allow_last_mm_cancel from so_checkbox within w_mat_receipt_return_master
integer x = 50
integer y = 384
integer width = 617
integer height = 68
boolean bringtotop = true
string text = "Allow Last Month Receipt Cancel"
boolean automatic = false
boolean checked = true
end type

event constructor;call super::constructor;if Gvs_allow_last_mm_receipt_cancel = 'Y' then
	this.checked = true
else
	this.checked = false
end if
end event

type ddlb_location_code from uo_basecode within w_mat_receipt_return_master
integer x = 1152
integer y = 452
integer width = 640
integer taborder = 90
boolean bringtotop = true
boolean allowedit = false
end type

event constructor;call super::constructor;this.redraw( 'MATERIAL LOCATION CODE')
end event

type st_6 from so_statictext within w_mat_receipt_return_master
integer x = 1152
integer y = 372
integer width = 640
integer height = 68
boolean bringtotop = true
integer weight = 700
long textcolor = 255
string text = "Location Code"
end type

type ddlb_location_code_cond from uo_basecode within w_mat_receipt_return_master
integer x = 3493
integer y = 156
integer width = 640
integer taborder = 100
boolean bringtotop = true
boolean allowedit = false
end type

event constructor;call super::constructor;this.redraw( 'MATERIAL LOCATION CODE')
end event

type st_7 from so_statictext within w_mat_receipt_return_master
integer x = 3493
integer y = 92
integer width = 640
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Location Code"
end type

type st_8 from so_statictext within w_mat_receipt_return_master
integer x = 4142
integer y = 92
integer width = 558
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Invoice No"
end type

type sle_invoice_no from so_singlelineedit within w_mat_receipt_return_master
integer x = 4137
integer y = 156
integer width = 576
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

type gb_1 from so_groupbox within w_mat_receipt_return_master
integer x = 9
integer width = 699
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_2 from so_groupbox within w_mat_receipt_return_master
integer x = 18
integer y = 308
integer width = 2341
integer height = 252
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_3 from so_groupbox within w_mat_receipt_return_master
integer x = 713
integer width = 4082
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

