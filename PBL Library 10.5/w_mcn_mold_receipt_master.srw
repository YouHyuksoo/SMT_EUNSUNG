HA$PBExportHeader$w_mcn_mold_receipt_master.srw
$PBExportComments$Material Receipt Master
forward
global type w_mcn_mold_receipt_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mcn_mold_receipt_master
end type
type uo_dateend from uo_ymd_calendar within w_mcn_mold_receipt_master
end type
type st_3 from so_statictext within w_mcn_mold_receipt_master
end type
type st_4 from so_statictext within w_mcn_mold_receipt_master
end type
type rb_order_list from so_radiobutton within w_mcn_mold_receipt_master
end type
type rb_receipt from so_radiobutton within w_mcn_mold_receipt_master
end type
type st_1 from so_statictext within w_mcn_mold_receipt_master
end type
type cb_receipt_cancel from so_commandbutton within w_mcn_mold_receipt_master
end type
type cb_receipt from so_commandbutton within w_mcn_mold_receipt_master
end type
type cbx_auto_invoice_no from so_checkbox within w_mcn_mold_receipt_master
end type
type em_mold_version from so_editmask within w_mcn_mold_receipt_master
end type
type em_mold_set_serial from so_editmask within w_mcn_mold_receipt_master
end type
type st_2 from so_statictext within w_mcn_mold_receipt_master
end type
type st_5 from so_statictext within w_mcn_mold_receipt_master
end type
type ddlb_mold_code from uo_mold_code within w_mcn_mold_receipt_master
end type
type ddlb_supplier_code from uo_supplier_m_code within w_mcn_mold_receipt_master
end type
type gb_1 from so_groupbox within w_mcn_mold_receipt_master
end type
type gb_2 from so_groupbox within w_mcn_mold_receipt_master
end type
type gb_3 from so_groupbox within w_mcn_mold_receipt_master
end type
end forward

global type w_mcn_mold_receipt_master from w_main_root
integer width = 5170
integer height = 2820
string title = "Mold Receipt Master"
uo_dateset uo_dateset
uo_dateend uo_dateend
st_3 st_3
st_4 st_4
rb_order_list rb_order_list
rb_receipt rb_receipt
st_1 st_1
cb_receipt_cancel cb_receipt_cancel
cb_receipt cb_receipt
cbx_auto_invoice_no cbx_auto_invoice_no
em_mold_version em_mold_version
em_mold_set_serial em_mold_set_serial
st_2 st_2
st_5 st_5
ddlb_mold_code ddlb_mold_code
ddlb_supplier_code ddlb_supplier_code
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_mcn_mold_receipt_master w_mcn_mold_receipt_master

type variables

end variables

on w_mcn_mold_receipt_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_3=create st_3
this.st_4=create st_4
this.rb_order_list=create rb_order_list
this.rb_receipt=create rb_receipt
this.st_1=create st_1
this.cb_receipt_cancel=create cb_receipt_cancel
this.cb_receipt=create cb_receipt
this.cbx_auto_invoice_no=create cbx_auto_invoice_no
this.em_mold_version=create em_mold_version
this.em_mold_set_serial=create em_mold_set_serial
this.st_2=create st_2
this.st_5=create st_5
this.ddlb_mold_code=create ddlb_mold_code
this.ddlb_supplier_code=create ddlb_supplier_code
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.rb_order_list
this.Control[iCurrent+6]=this.rb_receipt
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.cb_receipt_cancel
this.Control[iCurrent+9]=this.cb_receipt
this.Control[iCurrent+10]=this.cbx_auto_invoice_no
this.Control[iCurrent+11]=this.em_mold_version
this.Control[iCurrent+12]=this.em_mold_set_serial
this.Control[iCurrent+13]=this.st_2
this.Control[iCurrent+14]=this.st_5
this.Control[iCurrent+15]=this.ddlb_mold_code
this.Control[iCurrent+16]=this.ddlb_supplier_code
this.Control[iCurrent+17]=this.gb_1
this.Control[iCurrent+18]=this.gb_2
this.Control[iCurrent+19]=this.gb_3
end on

on w_mcn_mold_receipt_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.rb_order_list)
destroy(this.rb_receipt)
destroy(this.st_1)
destroy(this.cb_receipt_cancel)
destroy(this.cb_receipt)
destroy(this.cbx_auto_invoice_no)
destroy(this.em_mold_version)
destroy(this.em_mold_set_serial)
destroy(this.st_2)
destroy(this.st_5)
destroy(this.ddlb_mold_code)
destroy(this.ddlb_supplier_code)
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

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
uo_dateset.settext(string(f_t_sysdate(), 'yyyy/mm')+'/01')
end event

event ue_data_control;call super::ue_data_control;long row
string lvs_date
double LVDB_RCV_ISS_SEQ
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
			dw_1.reset()
			dw_2.reset()
			dw_3.reset()
			
			if rb_order_list.checked = true  then 
			    dw_1.retrieve( ddlb_supplier_code.getcode()+'%' , ddlb_mold_code.text( ) + '%', uo_dateset.text() , uo_dateend.text() , gvi_organization_id)
			else
				dw_3.retrieve(uo_dateset.text() , uo_dateend.text() , ddlb_mold_code.text( ) + '%', ddlb_supplier_code.getcode() +'%',  gvi_organization_id)
			end if 
	
    case 'INSERT'
		
			ROW = DW_2.INSERTROW(0)
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')
              
			LVDB_RCV_ISS_SEQ  = F_GET_SEQUENCE('SEQ_MAT_RECEIPT')
			DW_2.SETITEM( ROW , 'SUPPLIER_CODE' , '*' )
			DW_2.SETITEM( ROW , 'RECEIPT_DATE' , F_T_SYSDATE() )
			DW_2.SETITEM( ROW , 'RECEIPT_SEQUENCE' , LVDB_RCV_ISS_SEQ )
			DW_2.SETITEM( ROW , 'UNIT_PRICE' , 0)			
			DW_2.SETITEM( ROW , 'CURRENCY' , GVS_CURRENCY )
			DW_2.SETITEM( ROW , 'RECEIPT_DEFICIT' , '1' )
			DW_2.SETITEM( ROW , 'RECEIPT_STATUS' , 'N' ) //$$HEX5$$85c7e0acc1c0dcd02000$$ENDHEX$$N $$HEX3$$15c8c1c02000$$ENDHEX$$, C $$HEX2$$e8cd8cc1$$ENDHEX$$
			DW_2.SETITEM( ROW , 'ORDER_NO' , STRING(F_T_SYSDATE(), 'YYYYMMDD') +STRING(LVDB_RCV_ISS_SEQ) )
			DW_2.SETITEM( ROW , 'MOLD_LOCATION_CODE' , '*' )
			if cbx_auto_invoice_no.checked = true then 

				dw_2.object.invoice_no[row]   = STRING(F_T_SYSDATE(),'yymmdd') + STRING(LVDB_RCV_ISS_SEQ)
				
			end if			
	case 'APPEND'		
			
			ROW = DW_2.INSERTROW(DW_2.GETROW())
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')	

			LVDB_RCV_ISS_SEQ  = F_GET_SEQUENCE('SEQ_MAT_RECEIPT')
			
			DW_2.SETITEM( ROW , 'SUPPLIER_CODE' , '*' )
			DW_2.SETITEM( ROW , 'RECEIPT_DATE' , F_T_SYSDATE() )
			DW_2.SETITEM( ROW , 'RECEIPT_SEQUENCE' , LVDB_RCV_ISS_SEQ )
			DW_2.SETITEM( ROW , 'UNIT_PRICE' , 0)			
			DW_2.SETITEM( ROW , 'CURRENCY' , GVS_CURRENCY )
			DW_2.SETITEM( ROW , 'RECEIPT_DEFICIT' , '1' )
			DW_2.SETITEM( ROW , 'RECEIPT_STATUS' , 'N' ) //$$HEX5$$85c7e0acc1c0dcd02000$$ENDHEX$$N $$HEX3$$15c8c1c02000$$ENDHEX$$, C $$HEX2$$e8cd8cc1$$ENDHEX$$
			DW_2.SETITEM( ROW , 'ORDER_NO' , STRING(F_T_SYSDATE(), 'YYYYMMDD') +STRING(LVDB_RCV_ISS_SEQ) )			
			DW_2.SETITEM( ROW , 'MOLD_LOCATION_CODE' , '*' )			
			
			if cbx_auto_invoice_no.checked = true then 

				dw_2.object.invoice_no[row]   = STRING(F_T_SYSDATE(),'yymmdd') + STRING(LVDB_RCV_ISS_SEQ)
				
			end if			
			
   		    DW_2.SETFOCUS()
		    F_MSG_MDI_HELP( F_MSG_ST(152 ))
			
	case 'DELETE'
		
		  	if DW_2.AcceptText() = -1 then
				return
			end if
			
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			IF MSG = 1 THEN
				Gvl_row_deleted = DW_2.GetRow()			
				DW_2.DELETEROW(Gvl_row_deleted)		
				DW_2.SetFocus()
				ROW = DW_2.GetRow()
				DW_2.ScrollToRow(row)
				DW_2.SetColumn(1)
			END IF		 
			
   case 'UPDATE'
		
			IF DW_2.UPDATE() < 0  THEN
			  	 ROLLBACK;
				 RETURN
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"			 
			END IF

	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mcn_mold_receipt_master
integer y = 316
end type

type dw_4 from w_main_root`dw_4 within w_mcn_mold_receipt_master
integer y = 316
end type

type dw_3 from w_main_root`dw_3 within w_mcn_mold_receipt_master
integer y = 316
integer width = 4544
integer height = 772
boolean titlebar = true
string title = "Mold Receipt List"
string dataobject = "d_mcn_mold_receipt_lst"
end type

type dw_2 from w_main_root`dw_2 within w_mcn_mold_receipt_master
integer y = 1100
integer width = 4549
integer height = 988
boolean titlebar = true
string title = "Receipt List"
string dataobject = "d_mcn_mold_receipt_mlst"
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_2::itemchanged;call super::itemchanged;DECIMAL LVF_UNIT_PRICE , LVF_MATERIAL_COST

IF DWO.NAME = 'supplier_code' THEN 
	
  IF F_CHECK_SUPPLIER_EXISTS( DATA ) < 1 then 
		F_MSGBOX(9042) //$$HEX19$$70ac98b720c12000c8b9a4c230d12000f8bbf1b45db8200070ac98b720c1200085c7c8b2e4b2$$ENDHEX$$
		THIS.OBJECT.SUPPLIER_CODE[ROW] = ''
		THIS.SETCOLUMN('supplier_code')
 		RETURN 1
	END IF	
   
	THIS.OBJECT.MOLD_CODE[ROW] = ''

ELSEIF DWO.NAME = 'mold_code' THEN 
	
		IF F_CHECK_MOLD_EXISTS( DATA) < 1 then 
			F_MSGBOX(9041) //$$HEX16$$80bd88d4c8b9a4c230d12000f8bbf1b45db8200080bd88d4200085c7c8b2e4b2$$ENDHEX$$
			THIS.OBJECT.MOLD_CODE[ROW] = ''
			THIS.SETCOLUMN('mold_code')
			RETURN 1
		END IF		
	
		THIS.OBJECT.CURRENCY[ROW]        = ''
		THIS.OBJECT.UNIT_PRICE[ROW]      = 0 
		THIS.OBJECT.RECEIPT_AMT[ROW]   = 0
		
//		LVF_UNIT_PRICE = F_GET_MOLD_UNIT_PRICE_BY_CONFIRM( this.object.supplier_code[row] , this.object.mold_code[row]  )			
//	     IF LVF_UNIT_PRICE < 0 THEN 
//			RETURN 1
//		END IF
		
		THIS.OBJECT.UNIT_PRICE[ROW] = 0 //LVF_UNIT_PRICE
		THIS.OBJECT.CURRENCY[ROW]   = Gvs_currency //Gst_return.Gvs_return[1]
		
ELSEIF DWO.NAME = 'receipt_qty' THEN
		 
         THIS.OBJECT.RECEIPT_AMT[ROW]                  =  THIS.OBJECT.UNIT_PRICE[ROW] * THIS.OBJECT.RECEIPT_QTY[ROW]
    
END IF


end event

event dw_2::rbuttondown;call super::rbuttondown;if dwo.name = 'supplier_code' then 	
	
	open(w_com_mold_supplier_popup)	
	if  gst_return.gvb_return  = true then
	   this.object.supplier_code[row] = message.stringparm
	   gst_return.gvs_return[1]  = ''		
	end if
end if

if dwo.name = 'mold_code' then 
	open(w_mcn_mold_popup)	
	if  gst_return.gvb_return  = true then
	   this.object.mold_code[row] = message.stringparm
	end if	
	
end if
end event

event dw_2::dragdrop;call super::dragdrop;DATAWINDOW ldw_Source 
LONG Lvl_row , lvl_return
DOUBLE LVDB_RCV_ISS_SEQ

IF source.TypeOf() = DataWindow! THEN
   ldw_Source	= source
	
   IF ldw_Source  = THIS THEN 
   ELSE
		
		if row < 1 then // $$HEX15$$70c88cd61cb4200089d574c72000c6c544c72000bdacb0c6200085c725b8$$ENDHEX$$
			
			Lvl_row = this.insertrow(0)
			f_set_security_row( this , lvl_row , 'ALL')
			
			
			LVDB_RCV_ISS_SEQ  = F_GET_SEQUENCE('SEQ_MAT_RECEIPT')
			
			DW_2.OBJECT.ORDER_NO[LVL_ROW] = ldw_Source.object.ORDER_NO[ldw_Source.getrow()]	
			DW_2.OBJECT.SUPPLIER_CODE[LVL_ROW] = ldw_Source.object.SUPPLIER_CODE[ldw_Source.getrow()]	
			DW_2.OBJECT.MOLD_CODE[LVL_ROW] = ldw_Source.object.MOLD_CODE[ldw_Source.getrow()]				
			
			DW_2.OBJECT.RECEIPT_QTY[LVL_ROW] = ldw_Source.object.order_remain_qty[ldw_Source.getrow()]											
			DW_2.OBJECT.UNIT_PRICE[LVL_ROW] = ldw_Source.object.UNIT_PRICE[ldw_Source.getrow()]								
			DW_2.OBJECT.CURRENCY[LVL_ROW] = ldw_Source.object.CURRENCY[ldw_Source.getrow()]										
			DW_2.OBJECT.RECEIPT_AMT[LVL_ROW] = ldw_Source.object.order_remain_qty[ldw_Source.getrow()] * ldw_Source.object.UNIT_PRICE[ldw_Source.getrow()]										
			
			DW_2.OBJECT.RECEIPT_DATE[LVL_ROW] = F_T_SYSDATE()	
			DW_2.OBJECT.RECEIPT_SEQUENCE[LVL_ROW] =LVDB_RCV_ISS_SEQ
			DW_2.OBJECT.RECEIPT_DEFICIT[LVL_ROW] ='1'			
			DW_2.OBJECT.RECEIPT_STATUS[LVL_ROW] ='N'						
	
		end if

	END IF
		  
END IF

THIS.DRAG(END!)

end event

type dw_1 from w_main_root`dw_1 within w_mcn_mold_receipt_master
integer y = 316
integer width = 4544
integer height = 772
boolean titlebar = true
string title = "Mold Purchase Order List"
string dataobject = "d_mcn_mold_4_receipt_lst"
end type

event dw_1::clicked;call super::clicked;IF UPPER(DWO.TYPE) = 'COLUMN' THEN
	DRAG(BEGIN!)
END IF
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mcn_mold_receipt_master
end type

type uo_dateset from uo_ymd_calendar within w_mcn_mold_receipt_master
event destroy ( )
integer x = 2290
integer y = 164
integer taborder = 30
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mcn_mold_receipt_master
event destroy ( )
integer x = 2706
integer y = 164
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_3 from so_statictext within w_mcn_mold_receipt_master
integer x = 763
integer y = 80
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Mold Code"
end type

type st_4 from so_statictext within w_mcn_mold_receipt_master
integer x = 2295
integer y = 84
integer width = 814
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Date"
end type

type rb_order_list from so_radiobutton within w_mcn_mold_receipt_master
integer x = 50
integer y = 80
integer width = 608
boolean bringtotop = true
integer weight = 700
string text = "Purchase Order List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1

cb_receipt.enabled = true
cb_receipt_cancel.enabled = false

end event

type rb_receipt from so_radiobutton within w_mcn_mold_receipt_master
integer x = 50
integer y = 184
integer width = 608
boolean bringtotop = true
integer weight = 700
string text = "Mold Receipt List"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3

cb_receipt.enabled = false
cb_receipt_cancel.enabled = true
end event

type st_1 from so_statictext within w_mcn_mold_receipt_master
integer x = 1266
integer y = 80
integer width = 1015
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Supplier Code"
end type

type cb_receipt_cancel from so_commandbutton within w_mcn_mold_receipt_master
integer x = 4544
integer y = 160
integer height = 108
integer taborder = 30
boolean bringtotop = true
boolean enabled = false
string text = "Batch Cancel"
end type

event clicked;call super::clicked;long lvl_seq, lvl_return , i , j 
string lvs_mfs
datetime lvdt_date
msg = f_msgbox1(1161,this.text)
if msg = 1  then 
else
	return 
end if 
for i = 1 to dw_3.rowcount()
	if dw_3.object.check_yn[i] = 'Y' then 
		lvdt_date = dw_3.object.receipt_date[i]
		lvl_seq = dw_3.object.receipt_sequence[i]
		lvl_return = f_mcn_mold_receipt_cancel(lvdt_date, lvl_seq)
		if lvl_return < 1  then 
			rollback;
			return
		end if 
		j++
	end if 
next
if j >0 then 
	msg = f_msgbox1(9014,string(j))
	if msg = 1 then 
		commit ; 
		f_retrieve()
	else
		rollback; 
		f_msg_mdi_help(f_msg_st(9026))
	end if 
end if 
end event

type cb_receipt from so_commandbutton within w_mcn_mold_receipt_master
integer x = 4009
integer y = 160
integer height = 108
integer taborder = 40
boolean bringtotop = true
string text = "Batch Receip"
end type

event clicked;call super::clicked;Int  i ,j , row
Double LVDB_RCV_ISS_SEQ

dw_1.accepttext()
do
	i++
	
	if dw_1.object.check_yn[i] ='Y'  then 
	else
		continue
	end if
	
	
			row = dw_2.insertrow(0)
			dw_2.scrolltorow(row)
			F_SET_SECURITY_ROW(DW_2 , row ,'ALL')
              
			LVDB_RCV_ISS_SEQ  = F_GET_SEQUENCE('SEQ_MAT_RECEIPT')
			
			dw_2.object.mold_code[row] = dw_1.object.mold_code[i]
			dw_2.object.mold_version[row] = Integer(em_mold_version.text)
			dw_2.object.mold_version_spec[row] = '*'
			dw_2.object.mold_set_serial[row] = Integer(em_mold_set_serial.text)
			
			dw_2.object.line_type[row] = dw_1.object.line_type[i]			
			dw_2.object.supplier_code[row] = dw_1.object.supplier_code[i]
			dw_2.object.receipt_date[row] =  F_T_SYSDATE()
			dw_2.object.receipt_sequence[row] =  LVDB_RCV_ISS_SEQ

			dw_2.object.RECEIPT_DEFICIT[row] = '1'
			dw_2.object.RECEIPT_STATUS[row] ='N'
			
			dw_2.object.unit_price[row]   =dw_1.object.unit_price[i]
			dw_2.object.currency[row] = dw_1.object.currency[i]
			dw_2.object.mold_location_code[row] = '*'
			dw_2.object.receipt_qty[row] =dw_1.object.order_remain_qty[i]
			dw_2.object.receipt_amt[row] =dw_1.object.unit_price[i] * dw_1.object.order_remain_qty[i] 
			
			dw_2.object.order_no[row] = dw_1.object.order_no[i]
			
			if cbx_auto_invoice_no.checked = true then 

				dw_2.object.invoice_no[row]   = STRING(F_T_SYSDATE(),'yymmdd') + STRING(LVDB_RCV_ISS_SEQ)
				
			end if
			
	j++
loop until i = dw_1.rowcount( )

//if j > 0 then
//	
//	msg = f_msgbox(1170)
//	if msg = 1 then 
//		if dw_2.update() < 0 then 
//			rollback;
//			return
//		else
//			commit ;
//		end if
//	else
//		
//		dw_2.reset()
//		
//	end if
//	
//end if
end event

type cbx_auto_invoice_no from so_checkbox within w_mcn_mold_receipt_master
integer x = 4032
integer y = 56
integer width = 640
boolean bringtotop = true
integer weight = 700
string text = "Auto Invoice No"
boolean checked = true
end type

type em_mold_version from so_editmask within w_mcn_mold_receipt_master
integer x = 3200
integer y = 172
integer width = 357
integer taborder = 50
boolean bringtotop = true
string text = "0"
string mask = "##0"
boolean spin = true
double increment = 1
string minmax = "1~~"
end type

type em_mold_set_serial from so_editmask within w_mcn_mold_receipt_master
integer x = 3593
integer y = 172
integer width = 375
integer taborder = 60
boolean bringtotop = true
string text = "0"
string mask = "##0"
boolean spin = true
double increment = 1
end type

type st_2 from so_statictext within w_mcn_mold_receipt_master
integer x = 3200
integer y = 84
integer width = 357
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Mold Version"
end type

type st_5 from so_statictext within w_mcn_mold_receipt_master
integer x = 3593
integer y = 84
integer width = 375
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Mold Set Serial"
end type

type ddlb_mold_code from uo_mold_code within w_mcn_mold_receipt_master
integer x = 754
integer y = 160
integer width = 503
integer height = 760
integer taborder = 70
boolean bringtotop = true
end type

type ddlb_supplier_code from uo_supplier_m_code within w_mcn_mold_receipt_master
integer x = 1262
integer y = 164
integer width = 1015
integer height = 1844
integer taborder = 20
boolean bringtotop = true
end type

type gb_1 from so_groupbox within w_mcn_mold_receipt_master
integer width = 699
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_2 from so_groupbox within w_mcn_mold_receipt_master
integer x = 713
integer width = 2459
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_mcn_mold_receipt_master
integer x = 3177
integer width = 1938
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

