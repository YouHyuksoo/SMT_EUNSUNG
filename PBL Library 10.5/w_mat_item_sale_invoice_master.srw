HA$PBExportHeader$w_mat_item_sale_invoice_master.srw
$PBExportComments$Product Sale Invoice Master
forward
global type w_mat_item_sale_invoice_master from w_main_root
end type
type cb_batch from so_commandbutton within w_mat_item_sale_invoice_master
end type
type uo_dateset from uo_ymd_calendar within w_mat_item_sale_invoice_master
end type
type uo_dateend from uo_ymd_calendar within w_mat_item_sale_invoice_master
end type
type st_1 from statictext within w_mat_item_sale_invoice_master
end type
type ddlb_customer_code from uo_customer_code within w_mat_item_sale_invoice_master
end type
type st_2 from so_statictext within w_mat_item_sale_invoice_master
end type
type rb_receipt from so_radiobutton within w_mat_item_sale_invoice_master
end type
type rb_invoice from so_radiobutton within w_mat_item_sale_invoice_master
end type
type cb_cancel from so_commandbutton within w_mat_item_sale_invoice_master
end type
type st_3 from so_statictext within w_mat_item_sale_invoice_master
end type
type uo_item from uo_set_item_code within w_mat_item_sale_invoice_master
end type
type gb_1 from so_groupbox within w_mat_item_sale_invoice_master
end type
type gb_2 from so_groupbox within w_mat_item_sale_invoice_master
end type
type gb_5 from so_groupbox within w_mat_item_sale_invoice_master
end type
end forward

global type w_mat_item_sale_invoice_master from w_main_root
integer width = 4882
integer height = 3320
string title = "Material Sale Invoice Master"
cb_batch cb_batch
uo_dateset uo_dateset
uo_dateend uo_dateend
st_1 st_1
ddlb_customer_code ddlb_customer_code
st_2 st_2
rb_receipt rb_receipt
rb_invoice rb_invoice
cb_cancel cb_cancel
st_3 st_3
uo_item uo_item
gb_1 gb_1
gb_2 gb_2
gb_5 gb_5
end type
global w_mat_item_sale_invoice_master w_mat_item_sale_invoice_master

on w_mat_item_sale_invoice_master.create
int iCurrent
call super::create
this.cb_batch=create cb_batch
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_1=create st_1
this.ddlb_customer_code=create ddlb_customer_code
this.st_2=create st_2
this.rb_receipt=create rb_receipt
this.rb_invoice=create rb_invoice
this.cb_cancel=create cb_cancel
this.st_3=create st_3
this.uo_item=create uo_item
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_5=create gb_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_batch
this.Control[iCurrent+2]=this.uo_dateset
this.Control[iCurrent+3]=this.uo_dateend
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.ddlb_customer_code
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.rb_receipt
this.Control[iCurrent+8]=this.rb_invoice
this.Control[iCurrent+9]=this.cb_cancel
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.uo_item
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.gb_2
this.Control[iCurrent+14]=this.gb_5
end on

on w_mat_item_sale_invoice_master.destroy
call super::destroy
destroy(this.cb_batch)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_1)
destroy(this.ddlb_customer_code)
destroy(this.st_2)
destroy(this.rb_receipt)
destroy(this.rb_invoice)
destroy(this.cb_cancel)
destroy(this.st_3)
destroy(this.uo_item)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_5)
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
		    dw_1.retrieve(uo_dateset.text() , uo_dateend.text(),ddlb_customer_code.text + '%' ,uo_item.text+'%',  gvi_organization_id)
		else
			dw_2.retrieve(uo_dateset.text() , uo_dateend.text(), ddlb_customer_code.text + '%', gvi_organization_id)
		end if 
//	case 'INSERT'
//		
//			DW_2.ENABLED = TRUE
//			ROW = DW_2.INSERTROW(DW_2.GETROW())
//			DW_2.SCROLLTOROW(ROW)
//			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')
//			dw_2.object.dateset[row] = f_t_sysdate()
//			dw_2.object.dateend[row] = date('2999-12-31')
//			dw_2.object.order_type[row] = 'M'
//			dw_2.object.inspect_rule[row] = 'I'
//			dw_2.object.inspect_method[row] = 'S'						
//			
//	case 'APPEND'		
//			DW_2.ENABLED = TRUE
//			ROW = DW_2.INSERTROW(DW_2.GETROW())
//			DW_2.SCROLLTOROW(ROW)
//			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')	
//			dw_2.object.dateset[row] = f_t_sysdate()
//			dw_2.object.dateend[row] = date('2999-12-31')
//			dw_2.object.order_type[row] = 'M'
//			dw_2.object.inspect_rule[row] = 'I'						
//			dw_2.object.inspect_method[row] = 'S'						
			
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

type dw_5 from w_main_root`dw_5 within w_mat_item_sale_invoice_master
integer y = 324
integer height = 504
end type

type dw_4 from w_main_root`dw_4 within w_mat_item_sale_invoice_master
integer y = 324
integer height = 504
end type

type dw_3 from w_main_root`dw_3 within w_mat_item_sale_invoice_master
integer y = 324
integer height = 504
boolean titlebar = true
end type

type dw_2 from w_main_root`dw_2 within w_mat_item_sale_invoice_master
integer y = 324
integer width = 4535
integer height = 1100
boolean titlebar = true
string title = "Product Sale Invoice List"
string dataobject = "d_mat_item_sale_invoice_lst_tree"
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

type dw_1 from w_main_root`dw_1 within w_mat_item_sale_invoice_master
integer y = 324
integer width = 4535
integer height = 1100
boolean titlebar = true
string title = "Material Sale List"
string dataobject = "d_mat_material_sale_4_invoice_lst"
end type

type cb_batch from so_commandbutton within w_mat_item_sale_invoice_master
integer x = 3269
integer y = 120
integer width = 411
integer height = 116
integer taborder = 20
boolean bringtotop = true
string text = "Batch Select"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 

Long i , j
Double lvdb_invoice_open_sequence
Datetime lvdt_dateset , lvdt_dateend
string lvs_supplier_code , lvs_item_code

lvdt_dateset  = uo_dateset.text()
lvdt_dateend = uo_dateend.text()
lvs_supplier_code = ddlb_customer_code.text+'%'
lvs_item_code = uo_item.text+'%' 

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

  INSERT INTO "IM_ITEM_SALE_INVOICE_MASTER"  
         ( "SUPPLIER_CODE",   
           "INVOICE_DATE",   
		 "INVOICE_OPEN_SEQUENCE" ,	  
           "INVOICE_NO",   
           "ORGANIZATION_ID",   
           "SALE_AMT",   
           "TAX_RATE",   
           "TAX_AMT",   
           "PAYMENT_TYPE",   
           "INVOICE_ACCOUNT",   
           "INVOICE_DEFICIT",    //1 $$HEX3$$15c8c1c02000$$ENDHEX$$2 $$HEX2$$01c890c7$$ENDHEX$$
           "BILL_COLLECTION_DATE",   
           "INVOICE_STATUS",    //NORMAL , CANCEL
		 "INVOICE_OPEN_YN" ,
           "LAST_MODIFY_DATE",   
           "LAST_MODIFY_BY",   
           "ENTER_DATE",   
           "ENTER_BY" )  
 
 SELECT  "SUPPLIER_CODE",   
           TRUNC(SYSDATE) , //"INVOICE_DATE",   
           INVOICE_OPEN_SEQUENCE ,
		 '' ,	  
           "ORGANIZATION_ID",   
           SUM( RECEIPT_AMT ) ,
           0, //"TAX_RATE",   
           0 , //"TAX_AMT",   
           MAX(PAYMENT_TYPE),   
           'M001',   
           '1',   
           NULL,
           'N',   
		 'R'	, //$$HEX13$$01c618c29dc920001cbc89d52000e0c2adcc2000c1c0dcd02000$$ENDHEX$$REQUEST
           SYSDATE,
           :GVS_USER_ID,
           SYSDATE,
           :GVS_USER_ID
   FROM  IM_ITEM_SALE_RECEIPT
 WHERE RECEIPT_DATE >=  :LVDT_DATESET
     AND RECEIPT_DATE <= :LVDT_DATEEND
	AND SUPPLIER_CODE LIKE :LVS_SUPPLIER_CODE
	AND ITEM_CODE LIKE :LVS_ITEM_CODE
	AND INVOICE_OPEN_SEQUENCE = :LVDB_INVOICE_OPEN_SEQUENCE
	AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
	
	GROUP BY SUPPLIER_CODE ,  INVOICE_OPEN_SEQUENCE , ORGANIZATION_ID ;
 
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

type uo_dateset from uo_ymd_calendar within w_mat_item_sale_invoice_master
event destroy ( )
integer x = 759
integer y = 160
integer width = 402
integer taborder = 110
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_item_sale_invoice_master
event destroy ( )
integer x = 1161
integer y = 160
integer width = 402
integer taborder = 120
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_1 from statictext within w_mat_item_sale_invoice_master
integer x = 759
integer y = 84
integer width = 786
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
string text = "Shipping Date"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_customer_code from uo_customer_code within w_mat_item_sale_invoice_master
integer x = 1563
integer y = 160
integer width = 485
integer taborder = 30
boolean bringtotop = true
end type

type st_2 from so_statictext within w_mat_item_sale_invoice_master
integer x = 1563
integer y = 96
integer width = 485
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Customer Code"
end type

type rb_receipt from so_radiobutton within w_mat_item_sale_invoice_master
integer x = 37
integer y = 80
integer width = 654
boolean bringtotop = true
integer weight = 700
string text = "Material Sale List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1
cb_batch.enabled = true 
cb_cancel.enabled = false



end event

type rb_invoice from so_radiobutton within w_mat_item_sale_invoice_master
integer x = 32
integer y = 176
integer width = 654
boolean bringtotop = true
integer weight = 700
string text = "Material Sale Invoice"
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
selected_data_window = dw_2
cb_batch.enabled = false
cb_cancel.enabled = true




end event

type cb_cancel from so_commandbutton within w_mat_item_sale_invoice_master
integer x = 3680
integer y = 120
integer width = 411
integer height = 116
integer taborder = 30
boolean bringtotop = true
boolean enabled = false
string text = "Batch Cancel"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 

if dw_2.rowcount() < 0 then return 

string lvs_supplier_code
long i ,j 
double lvdb_invoice_open_sequence , lvdb_null
setnull(lvdb_null)

msg = f_msgbox1(1161,this.text)
if msg = 1 then 
else
	return 
end if 

for i = 1 to dw_2.rowcount()
	
	if dw_2.object.check_yn[i] = 'Y' then 		
	else
		continue
	end if 
	
	lvdb_invoice_open_sequence = dw_2.object.invoice_open_sequence[i]
     lvs_supplier_code =  dw_2.object.customer_code[i]
	
	
	dw_2.deleterow( i)
//	dw_2.object.invoice_open_yn[i] = 'N'
//	dw_2.object.invoice_open_sequence[i] = lvdb_null
	  
	update im_item_sale_receipt set invoice_open_yn = 'N' , invoice_open_sequence = null
	where supplier_code = :lvs_supplier_code
		and invoice_open_sequence = :lvdb_invoice_open_sequence
		and invoice_open_yn = 'R'
		and organization_id = :gvi_organization_id ;
		  
	  if f_sql_check() < 0 then 
		return
	 end if
	J++
next

if j > 0 then 
	msg = f_msgbox1(9014, string(j))
	if msg = 1 then 
		if dw_2.update() < 1 then
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

type st_3 from so_statictext within w_mat_item_sale_invoice_master
integer x = 2053
integer y = 96
integer width = 398
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type uo_item from uo_set_item_code within w_mat_item_sale_invoice_master
integer x = 2053
integer y = 160
integer width = 1088
integer height = 84
integer taborder = 40
boolean bringtotop = true
end type

on uo_item.destroy
call uo_set_item_code::destroy
end on

type gb_1 from so_groupbox within w_mat_item_sale_invoice_master
integer x = 3182
integer y = 4
integer width = 969
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_mat_item_sale_invoice_master
integer x = 722
integer y = 4
integer width = 2459
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_5 from so_groupbox within w_mat_item_sale_invoice_master
integer y = 4
integer width = 722
integer height = 300
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

