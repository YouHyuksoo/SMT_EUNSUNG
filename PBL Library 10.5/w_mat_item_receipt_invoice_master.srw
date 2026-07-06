HA$PBExportHeader$w_mat_item_receipt_invoice_master.srw
$PBExportComments$Product Sale Invoice Master
forward
global type w_mat_item_receipt_invoice_master from w_main_root
end type
type cb_batch from so_commandbutton within w_mat_item_receipt_invoice_master
end type
type st_2 from so_statictext within w_mat_item_receipt_invoice_master
end type
type rb_receipt from so_radiobutton within w_mat_item_receipt_invoice_master
end type
type rb_invoice from so_radiobutton within w_mat_item_receipt_invoice_master
end type
type cb_cancel from so_commandbutton within w_mat_item_receipt_invoice_master
end type
type st_3 from so_statictext within w_mat_item_receipt_invoice_master
end type
type cb_1 from so_commandbutton within w_mat_item_receipt_invoice_master
end type
type em_exchange_rate from so_editmask within w_mat_item_receipt_invoice_master
end type
type st_4 from statictext within w_mat_item_receipt_invoice_master
end type
type em_yyyymm from uo_ym within w_mat_item_receipt_invoice_master
end type
type st_1 from so_statictext within w_mat_item_receipt_invoice_master
end type
type ddlb_item_code from uo_item_code within w_mat_item_receipt_invoice_master
end type
type ddlb_invoice_open_yn from uo_basecode within w_mat_item_receipt_invoice_master
end type
type st_5 from so_statictext within w_mat_item_receipt_invoice_master
end type
type ddlb_supplier_code from uo_supplier_code within w_mat_item_receipt_invoice_master
end type
type gb_1 from so_groupbox within w_mat_item_receipt_invoice_master
end type
type gb_2 from so_groupbox within w_mat_item_receipt_invoice_master
end type
type gb_5 from so_groupbox within w_mat_item_receipt_invoice_master
end type
type gb_4 from so_groupbox within w_mat_item_receipt_invoice_master
end type
end forward

global type w_mat_item_receipt_invoice_master from w_main_root
integer width = 4882
integer height = 3320
string title = "Material Rceipt Invoice Master"
cb_batch cb_batch
st_2 st_2
rb_receipt rb_receipt
rb_invoice rb_invoice
cb_cancel cb_cancel
st_3 st_3
cb_1 cb_1
em_exchange_rate em_exchange_rate
st_4 st_4
em_yyyymm em_yyyymm
st_1 st_1
ddlb_item_code ddlb_item_code
ddlb_invoice_open_yn ddlb_invoice_open_yn
st_5 st_5
ddlb_supplier_code ddlb_supplier_code
gb_1 gb_1
gb_2 gb_2
gb_5 gb_5
gb_4 gb_4
end type
global w_mat_item_receipt_invoice_master w_mat_item_receipt_invoice_master

on w_mat_item_receipt_invoice_master.create
int iCurrent
call super::create
this.cb_batch=create cb_batch
this.st_2=create st_2
this.rb_receipt=create rb_receipt
this.rb_invoice=create rb_invoice
this.cb_cancel=create cb_cancel
this.st_3=create st_3
this.cb_1=create cb_1
this.em_exchange_rate=create em_exchange_rate
this.st_4=create st_4
this.em_yyyymm=create em_yyyymm
this.st_1=create st_1
this.ddlb_item_code=create ddlb_item_code
this.ddlb_invoice_open_yn=create ddlb_invoice_open_yn
this.st_5=create st_5
this.ddlb_supplier_code=create ddlb_supplier_code
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_5=create gb_5
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_batch
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.rb_receipt
this.Control[iCurrent+4]=this.rb_invoice
this.Control[iCurrent+5]=this.cb_cancel
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.em_exchange_rate
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.em_yyyymm
this.Control[iCurrent+11]=this.st_1
this.Control[iCurrent+12]=this.ddlb_item_code
this.Control[iCurrent+13]=this.ddlb_invoice_open_yn
this.Control[iCurrent+14]=this.st_5
this.Control[iCurrent+15]=this.ddlb_supplier_code
this.Control[iCurrent+16]=this.gb_1
this.Control[iCurrent+17]=this.gb_2
this.Control[iCurrent+18]=this.gb_5
this.Control[iCurrent+19]=this.gb_4
end on

on w_mat_item_receipt_invoice_master.destroy
call super::destroy
destroy(this.cb_batch)
destroy(this.st_2)
destroy(this.rb_receipt)
destroy(this.rb_invoice)
destroy(this.cb_cancel)
destroy(this.st_3)
destroy(this.cb_1)
destroy(this.em_exchange_rate)
destroy(this.st_4)
destroy(this.em_yyyymm)
destroy(this.st_1)
destroy(this.ddlb_item_code)
destroy(this.ddlb_invoice_open_yn)
destroy(this.st_5)
destroy(this.ddlb_supplier_code)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_5)
destroy(this.gb_4)
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
Ivs_resize_type                      = 'MASTER_DETAIL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


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
choose case gvs_ue_data_control
		
	case 'RETRIEVE'		
		dw_1.reset()
		dw_2.reset()
		dw_3.reset()
		if rb_receipt.checked = true then 			
		    dw_1.retrieve(f_get_first_day_by_month(em_yyyymm.text) , f_get_last_day_by_month(em_yyyymm.text),ddlb_supplier_code.text + '%' ,ddlb_item_code.text+'%',  ddlb_invoice_open_yn.text+'%' , gvi_organization_id)
		else
			dw_3.retrieve(f_get_first_day_by_month(em_yyyymm.text), f_get_last_day_by_month(em_yyyymm.text), ddlb_supplier_code.text + '%', gvi_organization_id)
			dw_3.groupcalc( )
		end if 
			
	case 'DELETE'
		
		  	if DW_1.AcceptText() = -1 then
				return
			end if
			
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			IF MSG = 1 THEN
				Gvl_row_deleted = DW_1.GetRow()			
				DW_1.DELETEROW(Gvl_row_deleted)		
				DW_1.SetFocus()
				ROW = DW_1.GetRow()
				DW_1.ScrollToRow(row)
				DW_1.SetColumn(1)
			END IF
	case 'UPDATE'
		
			IF DW_2.UPDATE() < 0 THEN
			  	 ROLLBACK;
			ELSE
				 COMMIT;
 				 f_msg_mdi_help( f_msg_st( 170) ) //$$HEX7$$00c8a5c718b4c8c5b5c2c8b2e4b2$$ENDHEX$$

				  F_RETRIEVE()
			END IF              
	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mat_item_receipt_invoice_master
integer y = 324
integer height = 504
end type

type dw_4 from w_main_root`dw_4 within w_mat_item_receipt_invoice_master
integer y = 324
integer height = 504
end type

type dw_3 from w_main_root`dw_3 within w_mat_item_receipt_invoice_master
integer y = 324
integer width = 4535
integer height = 1100
boolean titlebar = true
string dataobject = "d_mat_material_receipt_invoice_4_query_lst_tree"
end type

type dw_2 from w_main_root`dw_2 within w_mat_item_receipt_invoice_master
integer y = 1416
integer width = 4535
integer height = 732
boolean titlebar = true
string title = "Material Receipt Invoice List"
string dataobject = "d_mat_material_receipt_invoice_lst_tree"
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_2::rbuttondown;call super::rbuttondown;string lvs_payment_type,  lvs_customer_code
if dwo.name = 'customer_code' then 
	open(w_com_customer_popup)
	
	if message.stringparm = '' then 
	else
		lvs_customer_code = message.stringparm 		
	end if 	
	
	this.object.customer_code[row] = message.stringparm
	this.object.customer_name[row] = gst_return.gvs_return[1]
	gst_return.gvs_return[1]	 = ''
	
	select payment_type
		into   :lvs_payment_type
	from  icom_customer
	where customer_code = :lvs_customer_code
		and    organization_id = :gvi_organization_id ; 
		
	if f_sql_check() < 0 then return 
	
	if lvs_payment_type = '' or isnull(lvs_payment_type) then 
	else
		this.object.payment_type[row] = lvs_payment_type
	end if
end if 



end event

type dw_1 from w_main_root`dw_1 within w_mat_item_receipt_invoice_master
integer y = 324
integer width = 4535
integer height = 1100
boolean titlebar = true
string title = "Material Receipt List"
string dataobject = "d_mat_material_receipt_4_invoice_lst"
end type

event dw_1::itemchanged;call super::itemchanged;this.accepttext()

if dwo.name = 'exchange_rate' then 
	
		if dw_1.object.sale_currency[row] <> Gvs_currency then
		else
			  return 1
		end if
		
		dw_1.object.shipping_amt[row] = dw_1.object.shipping_qty[row] * dw_1.object.product_sale_price[row] * Dec(data)
	
end if
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow  = 0 then return

dw_2.retrieve( this.object.invoice_no[currentrow] , gvi_organization_id )
end event

event dw_1::doubleclicked;call super::doubleclicked;if row  = 0 then return

dw_2.retrieve( this.object.invoice_no[row] , gvi_organization_id )
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_item_receipt_invoice_master
end type

type cb_batch from so_commandbutton within w_mat_item_receipt_invoice_master
integer x = 2711
integer y = 68
integer width = 526
integer height = 108
integer taborder = 20
boolean bringtotop = true
string text = "Batch Select"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 

Long i , j
Double lvdb_invoice_open_sequence
Datetime lvdt_dateset , lvdt_dateend
string lvs_supplier_code , lvs_item_code , lvs_invoice_no

lvdt_dateset  =f_get_first_day_by_month( em_yyyymm.text )
lvdt_dateend = f_get_last_day_by_month( em_yyyymm.text )
lvs_supplier_code = ddlb_supplier_code.text+'%'
lvs_item_code = ddlb_item_code.text+'%' 

lvdb_invoice_open_sequence = f_get_sequence( 'SEQ_INVOICE_OPEN_SEQUENCE')

do
	i++
	
	if dw_1.object.check_yn[i] = 'Y' then 
	else
		continue
	end if
	
	j++
	
	dw_1.object.invoice_open_sequence[i] = lvdb_invoice_open_sequence
	dw_1.object.invoice_open_yn[i] = 'R'
	
loop until i = dw_1.rowcount()

if j > 0 then 
	if dw_1.update( ) < 0 then 
		rollback;
		return
	end if
else
	Return
end if

//================================================
// $$HEX15$$c4acb0c01cc120001cbc89d5200090c7d9b3b9c278c7200098ccacb92000$$ENDHEX$$
//================================================
IF Gvs_item_receipt_invoice_auto_confirm = 'Y' then
	
	i = 0 ; j = 0 
	do
		i++
		
		if dw_1.object.check_yn[i] = 'Y' then 
		else
			continue
		end if
		
		j++
	
		dw_1.object.invoice_open_yn[i] = 'Y'
		lvs_invoice_no =  STRING(F_T_SYSDATE(),'YYYYMMDD')+STRING(dw_1.object.invoice_open_sequence[i] )
		dw_1.object.invoice_no[i] = lvs_invoice_no // STRING(dw_1.object.invoice_open_sequence[i] )
		
	loop until i = dw_1.rowcount()

		if j > 0 then 
			if dw_1.update( ) < 0 then 
				rollback;
				return
			end if
		else
			Return
		end if
end if 
//================================================
//
//================================================
		
		  INSERT INTO "IM_ITEM_RECEIPT_INVOICE_MASTER"  
		    ( "SUPPLIER_CODE",   
			"INVOICE_DATE",   
			"INVOICE_OPEN_SEQUENCE" ,	  
			"INVOICE_NO",   
			"ORGANIZATION_ID",   
			"RECEIPT_AMT",   
			"TAX_RATE",   
			"TAX_AMT",   
			//"PAYMENT_TYPE",   
			"INVOICE_ACCOUNT",   
			"INVOICE_DEFICIT",    //1 $$HEX3$$15c8c1c02000$$ENDHEX$$2 $$HEX2$$01c890c7$$ENDHEX$$
			"BILL_DISBURSE_DATE",   
			"INVOICE_STATUS",    //NORMAL , CANCEL
			"INVOICE_OPEN_YN" ,
			"LAST_MODIFY_DATE",   
			"LAST_MODIFY_BY",   
			"ENTER_DATE",   
			"ENTER_BY" ,
			ITEM_DIVISION )  
			
			SELECT  "SUPPLIER_CODE",   
			TRUNC(SYSDATE) , //"INVOICE_DATE",   
			INVOICE_OPEN_SEQUENCE ,
			INVOICE_NO ,
			"ORGANIZATION_ID",   
			SUM("RECEIPT_AMT"),  
			0, //"TAX_RATE",   
			0 , //"TAX_AMT",   
			//					MAX(PAYMENT_TYPE),   
			'M001',   
			'1',   
			F_GET_BILL_DISBURSE_DATE(SUPPLIER_CODE , MAX(RECEIPT_DATE) , ORGANIZATION_ID )  , //$$HEX5$$c0c909ae20007cc790c7$$ENDHEX$$
			'N',   
			DECODE( :Gvs_product_sale_invoice_auto_confirm , 'Y' , 'Y' ,  'R'), //$$HEX13$$01c618c29dc920001cbc89d52000e0c2adcc2000c1c0dcd02000$$ENDHEX$$REQUEST , $$HEX8$$90c7d9b3b9c278c735c658c1b4cc6cd0$$ENDHEX$$
			SYSDATE,
			:GVS_USER_ID,
			SYSDATE,
			:GVS_USER_ID ,
			'R' //$$HEX4$$d0c6acc7ccb82000$$ENDHEX$$
			FROM  IM_ITEM_RECEIPT
			WHERE RECEIPT_DATE >=  :LVDT_DATESET
			AND RECEIPT_DATE <= :LVDT_DATEEND
			AND SUPPLIER_CODE LIKE :LVS_SUPPLIER_CODE
			AND ITEM_CODE LIKE :LVS_ITEM_CODE
			AND INVOICE_OPEN_SEQUENCE = :LVDB_INVOICE_OPEN_SEQUENCE
			AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
			AND RECEIPT_STATUS <>  'C'
			GROUP BY SUPPLIER_CODE ,  INVOICE_OPEN_SEQUENCE , INVOICE_NO , ORGANIZATION_ID ;
		 
		IF F_SQL_CHECK() < 0 THEN 
			RETURN
		END IF
		
		MSG = F_MSGBOX( 1170 ) 
		IF MSG = 1 THEN 
			COMMIT ;
			f_retrieve()
		ELSE
			ROLLBACK;
		END IF
end event

type st_2 from so_statictext within w_mat_item_receipt_invoice_master
integer x = 1216
integer y = 96
integer width = 485
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Supplier Code"
end type

type rb_receipt from so_radiobutton within w_mat_item_receipt_invoice_master
integer x = 27
integer y = 84
integer width = 649
boolean bringtotop = true
integer weight = 700
string text = "Material Receipt List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1
cb_batch.enabled = true 
cb_cancel.enabled = false



end event

type rb_invoice from so_radiobutton within w_mat_item_receipt_invoice_master
integer x = 27
integer y = 176
integer width = 667
boolean bringtotop = true
integer weight = 700
string text = "Receipt Invoice Cancel"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3

cb_batch.enabled = false
cb_cancel.enabled = true



end event

type cb_cancel from so_commandbutton within w_mat_item_receipt_invoice_master
integer x = 2711
integer y = 184
integer width = 526
integer height = 108
integer taborder = 30
boolean bringtotop = true
boolean enabled = false
string text = "Batch Cancel"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 
if dw_3.rowcount() < 0 then return 

string lvs_supplier_code
long i ,j 
double lvdb_invoice_open_sequence , lvdb_null
setnull(lvdb_null)

msg = f_msgbox1(1161,this.text)
if msg = 1 then 
else
	return 
end if 

for i = 1 to dw_3.rowcount()
	
	if dw_3.object.check_yn[i] = 'Y' then 		
	else
		continue
	end if 
	
	// $$HEX35$$74c7f8bb20001cbc89d5200018b4c8c53cc798b0200090c7d9b3b9c278c720003cc75cb820001cbc89d520001cb42000bdacb0c6d0c594b22000e8cd8cc1200000aca5b22000$$ENDHEX$$
	if dw_3.object.invoice_open_yn[i] = 'Y' and  Gvs_product_sale_invoice_auto_confirm = 'Y' then 		

			lvdb_invoice_open_sequence = dw_3.object.invoice_open_sequence[i]
			lvs_supplier_code                  =  dw_3.object.supplier_code[i]
			
			
			update im_item_receipt set invoice_open_yn = 'N' , invoice_open_sequence = null , invoice_no = ''
			where supplier_code                = :lvs_supplier_code
			and invoice_open_sequence = :lvdb_invoice_open_sequence
			and invoice_open_yn            = 'Y'
			and organization_id               = :gvi_organization_id ;
			
			if f_sql_check() < 0 then 
			return
			end if
			//============================================
			// $$HEX33$$9ccd58d5a1c1a5c71cbcddc044c72000e8cd8cc158d574ba2000b8d2acb970acd0c5200058c774d5200001c8a1c1acc7e0ac7cb9200010ac8dc12000dcc2a8d0e4b2$$ENDHEX$$.
			// $$HEX7$$b8d2acb970ac200038cc70c82000$$ENDHEX$$: TRG_IS_PRODUCT_SHIPPING_UPD
			//============================================	 
			
			dw_3.deleterow( i)		
		
	elseif dw_3.object.invoice_open_yn[i] = 'N' and  Gvs_product_sale_invoice_auto_confirm = 'N' then 		
		    // $$HEX18$$c4acb0c01cc120001cbc89d5200090c7d9b32000b9c278c774c7200044c5c8b2e0ac2000$$ENDHEX$$
		    // $$HEX28$$c4acb0c01cc120001cbc89d5200094c6adcc44c7200088d53cc798b0200044c5c1c920001cbc89d518b4c0c920004ac540c7bdacb0c62000$$ENDHEX$$
		
			lvdb_invoice_open_sequence = dw_3.object.invoice_open_sequence[i]
			lvs_supplier_code                  =  dw_3.object.supplier_code[i]
			
			
			update im_item_receipt set invoice_open_yn = 'N' , invoice_open_sequence = null , invoice_no = ''
			where supplier_code                = :lvs_supplier_code
			and invoice_open_sequence = :lvdb_invoice_open_sequence
			and invoice_open_yn            = 'R'
			and organization_id               = :gvi_organization_id ;
			
			if f_sql_check() < 0 then 
			return
			end if
			//============================================
			// $$HEX33$$9ccd58d5a1c1a5c71cbcddc044c72000e8cd8cc158d574ba2000b8d2acb970acd0c5200058c774d5200001c8a1c1acc7e0ac7cb9200010ac8dc12000dcc2a8d0e4b2$$ENDHEX$$.
			// $$HEX7$$b8d2acb970ac200038cc70c82000$$ENDHEX$$: TRG_IS_PRODUCT_SHIPPING_UPD
			//============================================	 
			
			dw_3.deleterow( i)				
		
	elseif dw_3.object.invoice_open_yn[i] = 'R' and  Gvs_product_sale_invoice_auto_confirm = 'N' then 		
		
			//$$HEX18$$c4acacc01cc120001cbc89d5200090c7d9b3b9c278c774c7200044c5c8b2e0ac20000900$$ENDHEX$$
			//$$HEX15$$c4acb0c01cc120001cbc89d5200094c6adcc74c7200078c7bdacb0c62000$$ENDHEX$$
			
			lvdb_invoice_open_sequence = dw_3.object.invoice_open_sequence[i]
			lvs_supplier_code                  =  dw_3.object.supplier_code[i]
			
			
			update im_item_receipt set invoice_open_yn = 'N' , invoice_open_sequence = null , invoice_no = ''
			where supplier_code                = :lvs_supplier_code
			and invoice_open_sequence = :lvdb_invoice_open_sequence
			and invoice_open_yn            = 'R'
			and organization_id               = :gvi_organization_id ;
			
			if f_sql_check() < 0 then 
			return
			end if
			//============================================
			// $$HEX33$$9ccd58d5a1c1a5c71cbcddc044c72000e8cd8cc158d574ba2000b8d2acb970acd0c5200058c774d5200001c8a1c1acc7e0ac7cb9200010ac8dc12000dcc2a8d0e4b2$$ENDHEX$$.
			// $$HEX7$$b8d2acb970ac200038cc70c82000$$ENDHEX$$: TRG_IS_PRODUCT_SHIPPING_UPD
			//============================================	 
			
			dw_3.deleterow( i)				
			
	elseif dw_3.object.invoice_open_yn[i] = 'R' and  Gvs_product_sale_invoice_auto_confirm = 'Y' then 		
		
		    //$$HEX12$$c4acb0c01cc190c7d9b31cbc89d5200035c658c174c72000$$ENDHEX$$Y $$HEX25$$78c770b32000c4acb0c01cc120001cbc89d5200054d674bad0c51cc120001cbc89d52000e8cd8cc17cb9200058d574ba2000$$ENDHEX$$
		    //$$HEX19$$74c7f8bb20009ccd58d515c8f4bcd0c594b22000c4acb0c01cc120001cbc89d53cc75cb82000$$ENDHEX$$invoice_open_yn= 'Y' $$HEX14$$5cb82000e4b4b4c500ac200088c7c8c530ae20004cb538bbd0c52000$$ENDHEX$$
		    //$$HEX7$$9ccd58d515c8f4bcd0c51cc12000$$ENDHEX$$invoice_open_yn ='Y' $$HEX15$$78c783acd0c5200000b374d51cc12000e8cd8cc198ccacb95cd5e4b22000$$ENDHEX$$
		    //$$HEX39$$c4acb0c01cc1200090c7d9b31cbc89d5200035c658c174c774ba2000c4acb0c01cc120001cbc89d554d674ba2000d0c51cc12000e8cd8cc194b2200058d5c0c92000d0b944c57cc520005cd5e4b2$$ENDHEX$$. $$HEX14$$58d5c0c9ccb9200088d5e4b274ba200098ccacb974d5200000c9e4b2$$ENDHEX$$.
		
			lvdb_invoice_open_sequence = dw_3.object.invoice_open_sequence[i]
			lvs_supplier_code                  =  dw_3.object.supplier_code[i]
			
			
			update im_item_receipt set invoice_open_yn = 'N' , invoice_open_sequence = null , invoice_no = ''
			where supplier_code                = :lvs_supplier_code
			and invoice_open_sequence = :lvdb_invoice_open_sequence
			and invoice_open_yn            = 'Y'
			and organization_id               = :gvi_organization_id ;
			
			if f_sql_check() < 0 then 
			return
			end if
			//============================================
			// $$HEX33$$9ccd58d5a1c1a5c71cbcddc044c72000e8cd8cc158d574ba2000b8d2acb970acd0c5200058c774d5200001c8a1c1acc7e0ac7cb9200010ac8dc12000dcc2a8d0e4b2$$ENDHEX$$.
			// $$HEX7$$b8d2acb970ac200038cc70c82000$$ENDHEX$$: TRG_IS_PRODUCT_SHIPPING_UPD
			//============================================	 
			
			dw_3.deleterow( i)							
	else
		continue
	end if 	
	
	J++
next

//=======================================
// Update
//=======================================
if j > 0 then 
	msg = f_msgbox1(9014, string(j))
	if msg = 1 then 
		if dw_3.update() < 1 then
			rollback ; 
		     f_msgbox(173)
			return 
		else			
			commit; 
			f_msgbox(170)
			f_retrieve()
		end if 	
	end if 
else
	f_msgbox(9026)
end if 
end event

type st_3 from so_statictext within w_mat_item_receipt_invoice_master
integer x = 1705
integer y = 96
integer width = 521
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type cb_1 from so_commandbutton within w_mat_item_receipt_invoice_master
integer x = 3822
integer y = 116
integer width = 411
integer height = 116
integer taborder = 40
boolean bringtotop = true
string text = "Change"
end type

event clicked;call super::clicked;long i , j

if Dec(em_exchange_rate.text) < 0 then 
	Messagebox("Notify" , "Exchange Rate Invalid")
	return
end if

if dw_1.getrow( ) < 1 then 
	return
end if

do
	i++
	
	if dw_1.object.check_yn[i] = 'Y' then 
	else
		continue
	end if
	
	if dw_1.object.sale_currency[i] <> Gvs_currency then
	else
		continue
	end if
	
	dw_1.object.exchange_rate[i] = Dec(em_exchange_rate.text)
	dw_1.object.shipping_amt[i] = dw_1.object.shipping_qty[i]  *  dw_1.object.product_sale_price[i]  * Dec(em_exchange_rate.text)
j++	
loop until i = dw_1.rowcount( )


//if j > 0 then 
//	
//	f_sal_product_inventory_close( em_yyyymm.text )
//	
//end if

msg = f_msgbox(1170)

if msg = 1 then 
	if dw_1.update( ) < 0 then 
		rollback;
	else
		commit;
	end if
else
	
end if
end event

type em_exchange_rate from so_editmask within w_mat_item_receipt_invoice_master
integer x = 3337
integer y = 176
integer taborder = 30
boolean bringtotop = true
end type

type st_4 from statictext within w_mat_item_receipt_invoice_master
integer x = 3337
integer y = 100
integer width = 402
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Exchange Rate"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_yyyymm from uo_ym within w_mat_item_receipt_invoice_master
integer x = 741
integer y = 160
integer width = 471
integer taborder = 20
boolean bringtotop = true
end type

type st_1 from so_statictext within w_mat_item_receipt_invoice_master
integer x = 727
integer y = 96
integer width = 485
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Receipt YYYYMM"
end type

type ddlb_item_code from uo_item_code within w_mat_item_receipt_invoice_master
integer x = 1705
integer y = 160
integer taborder = 20
boolean bringtotop = true
end type

type ddlb_invoice_open_yn from uo_basecode within w_mat_item_receipt_invoice_master
integer x = 2231
integer y = 160
integer width = 398
integer height = 360
integer taborder = 30
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'INVOICE OPEN YN')
end event

type st_5 from so_statictext within w_mat_item_receipt_invoice_master
integer x = 2231
integer y = 88
integer width = 398
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Invoice Open YN"
end type

type ddlb_supplier_code from uo_supplier_code within w_mat_item_receipt_invoice_master
integer x = 1216
integer y = 160
integer width = 485
integer taborder = 20
boolean bringtotop = true
end type

type gb_1 from so_groupbox within w_mat_item_receipt_invoice_master
integer x = 3301
integer y = 4
integer width = 987
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Exchange Rate Change"
end type

type gb_2 from so_groupbox within w_mat_item_receipt_invoice_master
integer x = 709
integer y = 4
integer width = 1943
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_5 from so_groupbox within w_mat_item_receipt_invoice_master
integer y = 4
integer width = 709
integer height = 300
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_4 from so_groupbox within w_mat_item_receipt_invoice_master
integer x = 2661
integer y = 4
integer width = 613
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

