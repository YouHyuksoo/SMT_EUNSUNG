HA$PBExportHeader$w_mcn_mold_issue_master.srw
$PBExportComments$Material Receipt Master
forward
global type w_mcn_mold_issue_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mcn_mold_issue_master
end type
type uo_dateend from uo_ymd_calendar within w_mcn_mold_issue_master
end type
type st_3 from so_statictext within w_mcn_mold_issue_master
end type
type st_4 from so_statictext within w_mcn_mold_issue_master
end type
type rb_inventory from so_radiobutton within w_mcn_mold_issue_master
end type
type rb_issue from so_radiobutton within w_mcn_mold_issue_master
end type
type ddlb_supplier_code from uo_supplier_code within w_mcn_mold_issue_master
end type
type st_1 from so_statictext within w_mcn_mold_issue_master
end type
type cb_batch_issue from so_commandbutton within w_mcn_mold_issue_master
end type
type rb_all from so_radiobutton within w_mcn_mold_issue_master
end type
type rb_inventory_qty from so_radiobutton within w_mcn_mold_issue_master
end type
type cb_issue_cancel from so_commandbutton within w_mcn_mold_issue_master
end type
type ddlb_workstage_code from uo_workstage_code_all within w_mcn_mold_issue_master
end type
type st_2 from so_statictext within w_mcn_mold_issue_master
end type
type st_5 from so_statictext within w_mcn_mold_issue_master
end type
type ddlb_issue_account from uo_basecode within w_mcn_mold_issue_master
end type
type st_6 from so_statictext within w_mcn_mold_issue_master
end type
type ddlb_line_code from uo_line_code within w_mcn_mold_issue_master
end type
type st_7 from so_statictext within w_mcn_mold_issue_master
end type
type rb_1 from so_radiobutton within w_mcn_mold_issue_master
end type
type rb_2 from so_radiobutton within w_mcn_mold_issue_master
end type
type ddlb_mold_use_status from uo_basecode within w_mcn_mold_issue_master
end type
type st_8 from so_statictext within w_mcn_mold_issue_master
end type
type ddlb_mold_code from uo_mold_code within w_mcn_mold_issue_master
end type
type ddlb_machine_code from uo_machine_code within w_mcn_mold_issue_master
end type
type rb_request from so_radiobutton within w_mcn_mold_issue_master
end type
type gb_1 from so_groupbox within w_mcn_mold_issue_master
end type
type gb_2 from so_groupbox within w_mcn_mold_issue_master
end type
type gb_3 from so_groupbox within w_mcn_mold_issue_master
end type
type gb_4 from so_groupbox within w_mcn_mold_issue_master
end type
end forward

global type w_mcn_mold_issue_master from w_main_root
integer width = 5253
integer height = 3028
string title = "Mold Issue Master"
uo_dateset uo_dateset
uo_dateend uo_dateend
st_3 st_3
st_4 st_4
rb_inventory rb_inventory
rb_issue rb_issue
ddlb_supplier_code ddlb_supplier_code
st_1 st_1
cb_batch_issue cb_batch_issue
rb_all rb_all
rb_inventory_qty rb_inventory_qty
cb_issue_cancel cb_issue_cancel
ddlb_workstage_code ddlb_workstage_code
st_2 st_2
st_5 st_5
ddlb_issue_account ddlb_issue_account
st_6 st_6
ddlb_line_code ddlb_line_code
st_7 st_7
rb_1 rb_1
rb_2 rb_2
ddlb_mold_use_status ddlb_mold_use_status
st_8 st_8
ddlb_mold_code ddlb_mold_code
ddlb_machine_code ddlb_machine_code
rb_request rb_request
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
end type
global w_mcn_mold_issue_master w_mcn_mold_issue_master

on w_mcn_mold_issue_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_3=create st_3
this.st_4=create st_4
this.rb_inventory=create rb_inventory
this.rb_issue=create rb_issue
this.ddlb_supplier_code=create ddlb_supplier_code
this.st_1=create st_1
this.cb_batch_issue=create cb_batch_issue
this.rb_all=create rb_all
this.rb_inventory_qty=create rb_inventory_qty
this.cb_issue_cancel=create cb_issue_cancel
this.ddlb_workstage_code=create ddlb_workstage_code
this.st_2=create st_2
this.st_5=create st_5
this.ddlb_issue_account=create ddlb_issue_account
this.st_6=create st_6
this.ddlb_line_code=create ddlb_line_code
this.st_7=create st_7
this.rb_1=create rb_1
this.rb_2=create rb_2
this.ddlb_mold_use_status=create ddlb_mold_use_status
this.st_8=create st_8
this.ddlb_mold_code=create ddlb_mold_code
this.ddlb_machine_code=create ddlb_machine_code
this.rb_request=create rb_request
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.rb_inventory
this.Control[iCurrent+6]=this.rb_issue
this.Control[iCurrent+7]=this.ddlb_supplier_code
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.cb_batch_issue
this.Control[iCurrent+10]=this.rb_all
this.Control[iCurrent+11]=this.rb_inventory_qty
this.Control[iCurrent+12]=this.cb_issue_cancel
this.Control[iCurrent+13]=this.ddlb_workstage_code
this.Control[iCurrent+14]=this.st_2
this.Control[iCurrent+15]=this.st_5
this.Control[iCurrent+16]=this.ddlb_issue_account
this.Control[iCurrent+17]=this.st_6
this.Control[iCurrent+18]=this.ddlb_line_code
this.Control[iCurrent+19]=this.st_7
this.Control[iCurrent+20]=this.rb_1
this.Control[iCurrent+21]=this.rb_2
this.Control[iCurrent+22]=this.ddlb_mold_use_status
this.Control[iCurrent+23]=this.st_8
this.Control[iCurrent+24]=this.ddlb_mold_code
this.Control[iCurrent+25]=this.ddlb_machine_code
this.Control[iCurrent+26]=this.rb_request
this.Control[iCurrent+27]=this.gb_1
this.Control[iCurrent+28]=this.gb_2
this.Control[iCurrent+29]=this.gb_3
this.Control[iCurrent+30]=this.gb_4
end on

on w_mcn_mold_issue_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.rb_inventory)
destroy(this.rb_issue)
destroy(this.ddlb_supplier_code)
destroy(this.st_1)
destroy(this.cb_batch_issue)
destroy(this.rb_all)
destroy(this.rb_inventory_qty)
destroy(this.cb_issue_cancel)
destroy(this.ddlb_workstage_code)
destroy(this.st_2)
destroy(this.st_5)
destroy(this.ddlb_issue_account)
destroy(this.st_6)
destroy(this.ddlb_line_code)
destroy(this.st_7)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.ddlb_mold_use_status)
destroy(this.st_8)
destroy(this.ddlb_mold_code)
destroy(this.ddlb_machine_code)
destroy(this.rb_request)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
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
			if rb_inventory.checked = true  then 
			    dw_1.retrieve(ddlb_mold_code.text() + '%',  ddlb_supplier_code.text+'%' , ddlb_mold_use_status.getcode( )+'%' , gvi_organization_id)
				 
			elseif rb_request.checked = true then 
			   dw_4.retrieve(ddlb_mold_code.text() + '%' , gvi_organization_id)	
			else
				dw_3.retrieve(uo_dateset.text() , uo_dateend.text() , ddlb_mold_code.text() + '%', gvi_organization_id)
			end if 
	
    case 'INSERT'
		
			ROW = DW_2.INSERTROW(0)
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')
              
			LVDB_RCV_ISS_SEQ  = F_GET_SEQUENCE('SEQ_MAT_ISSUE')
			
			DW_2.SETITEM( ROW , 'ISSUE_DATE' , F_T_SYSDATE() )
			DW_2.SETITEM( ROW , 'ISSUE_SEQUENCE' , LVDB_RCV_ISS_SEQ )
			DW_2.SETITEM( ROW , 'CURRENCY' , GVS_CURRENCY )
			DW_2.SETITEM( ROW , 'ISSUE_DEFICIT' , '3' )
			DW_2.SETITEM( ROW , 'ISSUE_STATUS' , 'N' ) //$$HEX5$$85c7e0acc1c0dcd02000$$ENDHEX$$N $$HEX3$$15c8c1c02000$$ENDHEX$$, C $$HEX2$$e8cd8cc1$$ENDHEX$$
			
	case 'APPEND'		
			
			ROW = DW_2.INSERTROW(DW_2.GETROW())
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')	

			LVDB_RCV_ISS_SEQ  = F_GET_SEQUENCE('SEQ_MAT_ISSUE')
			
			DW_2.SETITEM( ROW , 'ISSUE_DATE' , F_T_SYSDATE() )
			DW_2.SETITEM( ROW , 'ISSUE_SEQUENCE' , LVDB_RCV_ISS_SEQ )
			DW_2.SETITEM( ROW , 'CURRENCY' , GVS_CURRENCY )
			DW_2.SETITEM( ROW , 'ISSUE_DEFICIT' , '3' )
			DW_2.SETITEM( ROW , 'ISSUE_STATUS' , 'N' ) //$$HEX5$$85c7e0acc1c0dcd02000$$ENDHEX$$N $$HEX3$$15c8c1c02000$$ENDHEX$$, C $$HEX2$$e8cd8cc1$$ENDHEX$$
			
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
		
			IF DW_3.UPDATE() < 0 OR DW_2.UPDATE() < 0  THEN
			  	 ROLLBACK;
				 RETURN
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"			 
			END IF

	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mcn_mold_issue_master
integer y = 544
end type

type dw_4 from w_main_root`dw_4 within w_mcn_mold_issue_master
integer y = 544
integer width = 4439
integer height = 1524
boolean titlebar = true
string title = "Request List"
string dataobject = "d_mcn_mold_request_4_issue_lst"
end type

type dw_3 from w_main_root`dw_3 within w_mcn_mold_issue_master
integer y = 544
integer width = 4544
integer height = 1540
boolean titlebar = true
string title = "Mold Issue List"
string dataobject = "d_mcn_mold_issue_lst"
end type

type dw_2 from w_main_root`dw_2 within w_mcn_mold_issue_master
integer y = 2088
integer width = 4549
integer height = 572
string dataobject = "d_mcn_mold_issue_mst"
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_2::itemchanged;call super::itemchanged;//DECIMAL LVF_ISSUE_PRICE 
//
//IF DWO.NAME = 'mold_code' THEN 
//	
//		IF F_CHECK_MOLD_EXISTS( DATA) < 1 then 
//			F_MSGBOX(9041) //$$HEX16$$80bd88d4c8b9a4c230d12000f8bbf1b45db8200080bd88d4200085c7c8b2e4b2$$ENDHEX$$
//			THIS.OBJECT.MOLD_CODE[ROW] = ''
//			THIS.SETCOLUMN('mold_code')
//			RETURN 1
//		END IF		
//	
//	THIS.OBJECT.CURRENCY[ROW]    = ''
//	THIS.OBJECT.ISSUE_PRICE[ROW] = 0 
//	THIS.OBJECT.ISSUE_AMT[ROW]    = 0
//		
//		LVF_ISSUE_PRICE = f_get_mold_unit_price( dw_1.object.supplier_code[row] , this.object.mold_code[row]  )			
//     
//	     IF LVF_ISSUE_PRICE < 0 THEN 
//			RETURN 1
//		END IF
//		
//		THIS.OBJECT.ISSUE_PRICE[ROW] = LVF_ISSUE_PRICE
//		THIS.OBJECT.CURRENCY[ROW] =     gst_return.gvs_return[1]
//		
//		gst_return.gvs_return[1] = ''
//		
//ELSEIF DWO.NAME = 'issue_qty' THEN
//	
//         THIS.OBJECT.ISSUE_AMT[ROW]                  = THIS.OBJECT.ISSUE_PRICE[ROW] * THIS.OBJECT.ISSUE_QTY[ROW]
//			
//END IF

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
	   this.trigger event itemchanged( row , this.object.mold_code , this.object.mold_code[row] )
		
		
	end if	
	
end if
end event

type dw_1 from w_main_root`dw_1 within w_mcn_mold_issue_master
integer y = 544
integer width = 4544
integer height = 1540
boolean titlebar = true
string title = "Mold Inventory List"
string dataobject = "d_mcn_mold_inventory_4_issue_lst"
end type

event dw_1::itemchanged;call super::itemchanged;if dwo.name = 'issue_qty' then 
	
	if long(data) = 0 or isnull(data) then 
		
		this.object.check_yn[row] = 'N' 
	else
		this.object.check_yn[row] = 'Y' 		
	end if 
	
end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mcn_mold_issue_master
end type

type uo_dateset from uo_ymd_calendar within w_mcn_mold_issue_master
event destroy ( )
integer x = 1774
integer y = 160
integer taborder = 30
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mcn_mold_issue_master
event destroy ( )
integer x = 2190
integer y = 160
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_3 from so_statictext within w_mcn_mold_issue_master
integer x = 731
integer y = 80
integer width = 594
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Mold Code"
end type

type st_4 from so_statictext within w_mcn_mold_issue_master
integer x = 1778
integer y = 80
integer width = 814
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Date"
end type

type rb_inventory from so_radiobutton within w_mcn_mold_issue_master
integer x = 50
integer y = 64
integer width = 631
boolean bringtotop = true
integer weight = 700
string text = "Mold Inventory List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1
cb_batch_issue.enabled = true
cb_issue_cancel.enabled = false

end event

type rb_issue from so_radiobutton within w_mcn_mold_issue_master
integer x = 50
integer y = 204
integer width = 521
boolean bringtotop = true
integer weight = 700
string text = "Mold Issue List"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3
cb_batch_issue.enabled = false
cb_issue_cancel.enabled = true
end event

type ddlb_supplier_code from uo_supplier_code within w_mcn_mold_issue_master
integer x = 1330
integer y = 160
integer width = 439
integer taborder = 20
boolean bringtotop = true
end type

type st_1 from so_statictext within w_mcn_mold_issue_master
integer x = 1330
integer y = 80
integer width = 439
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Supplier Code"
end type

type cb_batch_issue from so_commandbutton within w_mcn_mold_issue_master
integer x = 2999
integer y = 368
integer width = 434
integer height = 132
integer taborder = 30
boolean bringtotop = true
string text = "Batch Issue"
end type

event clicked;call super::clicked;long LVDB_RCV_ISS_SEQ , Lvl_row , i , j
string lvs_line_code , lvs_workstage_code , lvs_machine_code , lvs_mold_issue_account
datetime lvdt_date

if rb_inventory.checked = true then 

			if dw_1.getrow( ) < 1 then return
			
			lvs_line_code = ddlb_line_code.getcode()
			lvs_workstage_code = ddlb_workstage_code.getcode()
			lvs_machine_code= ddlb_machine_code.getcode()
			lvs_mold_issue_account =ddlb_issue_account.getcode( )
			
			if lvs_line_code = '' or lvs_line_code='%' or isnull(lvs_line_code) then
				
				f_msgbox1( 102 , f_get_dual_lang_text( Gvs_language , "LINE CODE"))
				return
			end if 
			
			if lvs_workstage_code = '' or lvs_workstage_code='%' or isnull(lvs_workstage_code) then
				f_msgbox1( 102 , f_get_dual_lang_text( Gvs_language , "WORKSTAGE CODE"))
				return
			end if 
			
			if lvs_mold_issue_account = '' or lvs_mold_issue_account='%' or isnull(lvs_mold_issue_account) then
				f_msgbox1( 102 , f_get_dual_lang_text( Gvs_language , "ISSUE ACCOUNT"))
				return
			end if 
			
			if lvs_machine_code = '' or lvs_machine_code='%' or isnull(lvs_machine_code) then
				f_msgbox1( 102 , f_get_dual_lang_text( Gvs_language , "MACHINE CODE"))
				return
			end if 
			
			msg = f_msgbox1(1161,this.text)
			if msg = 1  then 
			else
				return 
			end if 
			
			dw_2.reset()
			
			for i = 1 to dw_1.rowcount()
				if dw_1.object.check_yn[i] = 'Y' then 
				
						Lvl_row = dw_2.insertrow(0)
						f_set_security_row( dw_2 , lvl_row , 'ALL')
						lvdt_date =  F_SYSDATE()	
						
						
						DW_2.OBJECT.LINE_CODE[LVL_ROW] = lvs_line_code
						DW_2.OBJECT.WORKSTAGE_CODE[LVL_ROW] = lvs_workstage_code
						DW_2.OBJECT.MACHINE_CODE[LVL_ROW] = lvs_machine_code
						LVDB_RCV_ISS_SEQ  = F_GET_SEQUENCE('SEQ_MOLD_ISSUE_SEQUENCE')
			
						DW_2.OBJECT.SUPPLIER_CODE[LVL_ROW] = dw_1.object.SUPPLIER_CODE[i]							
						DW_2.OBJECT.MOLD_CODE[LVL_ROW] = dw_1.object.MOLD_CODE[i]				
						dw_2.trigger event itemchanged( lvl_row , dw_2.object.mold_code , dw_2.object.mold_code[lvl_row] ) 
						
						DW_2.OBJECT.MOLD_VERSION[LVL_ROW] = dw_1.object.MOLD_VERSION[i]				
						DW_2.OBJECT.MOLD_SET_SERIAL[LVL_ROW] = dw_1.object.MOLD_SET_SERIAL[i]						
						
						DW_2.OBJECT.MOLD_ISSUE_ACCOUNT[LVL_ROW] = lvs_mold_issue_account								
								
						DW_2.OBJECT.CURRENCY[LVL_ROW] = Gvs_currency
						DW_2.OBJECT.ISSUE_DATE[LVL_ROW] =lvdt_date
						DW_2.OBJECT.ISSUE_SEQUENCE[LVL_ROW] =LVDB_RCV_ISS_SEQ
						DW_2.OBJECT.ISSUE_DEFICIT[LVL_ROW] ='3'			
						DW_2.OBJECT.ISSUE_STATUS[LVL_ROW] ='N'
						DW_2.OBJECT.ISSUE_QTY[LVL_ROW] = dw_1.object.issue_qty[i]					
						dw_2.trigger event itemchanged( lvl_row , dw_2.object.issue_qty , STRING(dw_2.object.issue_qty[lvl_row]) ) 
						
					j++
				end if 
			next
			if j >0 then 
				msg = f_msgbox1(9014,string(j))
				if msg = 1 then 
					if dw_2.update() < 0 then 
						rollback;
					else
						commit ;
						f_retrieve()
					end if
				else
					rollback; 
					f_msg_mdi_help(f_msg_st(9026))
				end if 
			end if 
//=================================================================
//
//=================================================================
elseif rb_request.checked = true then 
			if dw_4.getrow( ) < 1 then return
			
			lvs_line_code = ddlb_line_code.getcode()
			lvs_workstage_code = ddlb_workstage_code.getcode()
			lvs_machine_code= ddlb_machine_code.getcode()
			lvs_mold_issue_account =ddlb_issue_account.getcode( )
			
			if lvs_line_code = '' or lvs_line_code='%' or isnull(lvs_line_code) then
				
				f_msgbox1( 102 , f_get_dual_lang_text( Gvs_language , "LINE CODE"))
				return
			end if 
			
			if lvs_workstage_code = '' or lvs_workstage_code='%' or isnull(lvs_workstage_code) then
				f_msgbox1( 102 , f_get_dual_lang_text( Gvs_language , "WORKSTAGE CODE"))
				return
			end if 
			
			if lvs_mold_issue_account = '' or lvs_mold_issue_account='%' or isnull(lvs_mold_issue_account) then
				f_msgbox1( 102 , f_get_dual_lang_text( Gvs_language , "ISSUE ACCOUNT"))
				return
			end if 
			
			if lvs_machine_code = '' or lvs_machine_code='%' or isnull(lvs_machine_code) then
				f_msgbox1( 102 , f_get_dual_lang_text( Gvs_language , "MACHINE CODE"))
				return
			end if 
			
			msg = f_msgbox1(1161,this.text)
			if msg = 1  then 
			else
				return 
			end if 
			
			dw_2.reset()
			
			for i = 1 to dw_4.rowcount()
				
				if dw_4.object.check_yn[i] = 'Y' then 
					
							
					
				
						Lvl_row = dw_2.insertrow(0)
						f_set_security_row( dw_2 , lvl_row , 'ALL')
						lvdt_date =  F_SYSDATE()	
						
						DW_2.OBJECT.LINE_CODE[LVL_ROW] = lvs_line_code
						DW_2.OBJECT.WORKSTAGE_CODE[LVL_ROW] = lvs_workstage_code
						DW_2.OBJECT.MACHINE_CODE[LVL_ROW] = lvs_machine_code
						LVDB_RCV_ISS_SEQ  = F_GET_SEQUENCE('SEQ_MOLD_ISSUE_SEQUENCE')
			
						DW_2.OBJECT.SUPPLIER_CODE[LVL_ROW] = dw_4.object.SUPPLIER_CODE[i]			
						
						DW_2.OBJECT.MOLD_CODE[LVL_ROW] = dw_4.object.MOLD_CODE[i]				
						dw_2.trigger event itemchanged( lvl_row , dw_2.object.mold_code , dw_2.object.mold_code[lvl_row] ) 
						
						DW_2.OBJECT.MOLD_VERSION[LVL_ROW] = dw_4.object.MOLD_VERSION[i]				
						DW_2.OBJECT.MOLD_SET_SERIAL[LVL_ROW] = dw_4.object.MOLD_SET_SERIAL[i]						
						
						DW_2.OBJECT.MOLD_ISSUE_ACCOUNT[LVL_ROW] = lvs_mold_issue_account								
								
						DW_2.OBJECT.CURRENCY[LVL_ROW] = Gvs_currency
						DW_2.OBJECT.ISSUE_DATE[LVL_ROW] =lvdt_date
						
	
						DW_2.OBJECT.ISSUE_SEQUENCE[LVL_ROW] =LVDB_RCV_ISS_SEQ
						DW_2.OBJECT.ISSUE_DEFICIT[LVL_ROW] ='3'			
						DW_2.OBJECT.ISSUE_STATUS[LVL_ROW] ='N'
						DW_2.OBJECT.ISSUE_QTY[LVL_ROW] = dw_4.object.issue_qty[i]					
						dw_2.trigger event itemchanged( lvl_row , dw_2.object.issue_qty , STRING(dw_2.object.issue_qty[lvl_row]) ) 
						
				         DW_4.OBJECT.ISSUE_DATE[LVL_ROW] =lvdt_date
						DW_4.OBJECT.REQUEST_STATUS[LVL_ROW] = 'C' // $$HEX3$$44c6ccb82000$$ENDHEX$$
						DW_4.OBJECT.ISSUE_SEQUENCE[LVL_ROW] =LVDB_RCV_ISS_SEQ
												
						
						
					j++
				end if 
			next
			
			
			if j >0 then 
				msg = f_msgbox1(9014,string(j))
				if msg = 1 then 
					if dw_2.update() < 0 or dw_4.update() < 0  then 
						rollback;
					else
						commit ;
						f_retrieve()
					end if
				else
					rollback; 
					f_msg_mdi_help(f_msg_st(9026))
				end if 
			end if 	
	
end if 
end event

type rb_all from so_radiobutton within w_mcn_mold_issue_master
integer x = 3159
integer y = 76
boolean bringtotop = true
integer weight = 700
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.setfilter( '')
dw_1.filter( )
end event

type rb_inventory_qty from so_radiobutton within w_mcn_mold_issue_master
integer x = 3159
integer y = 188
integer width = 567
boolean bringtotop = true
integer weight = 700
string text = "Inventory  Qty > 0 "
end type

event clicked;call super::clicked;dw_1.setfilter('Inventory_qty > 0 ')
dw_1.filter( )
end event

type cb_issue_cancel from so_commandbutton within w_mcn_mold_issue_master
integer x = 3831
integer y = 368
integer width = 434
integer height = 132
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
string text = "Issue Cancel"
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
		lvdt_date = dw_3.object.issue_date[i]
		lvl_seq = dw_3.object.issue_sequence[i]
		lvl_return = f_mcn_mold_issue_cancel(lvdt_date, lvl_seq)
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

type ddlb_workstage_code from uo_workstage_code_all within w_mcn_mold_issue_master
integer x = 850
integer y = 424
integer height = 1980
integer taborder = 30
boolean bringtotop = true
end type

type st_2 from so_statictext within w_mcn_mold_issue_master
integer x = 850
integer y = 352
integer width = 631
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Workstage Code"
end type

type st_5 from so_statictext within w_mcn_mold_issue_master
integer x = 1486
integer y = 352
integer width = 631
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Machine Code"
end type

type ddlb_issue_account from uo_basecode within w_mcn_mold_issue_master
integer x = 2121
integer y = 424
integer height = 1496
integer taborder = 60
boolean bringtotop = true
end type

event constructor;call super::constructor;THIS.REdraw( 'MOLD ISSUE ACCOUNT')

end event

type st_6 from so_statictext within w_mcn_mold_issue_master
integer x = 2121
integer y = 348
integer width = 731
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Mold Issue Account"
end type

type ddlb_line_code from uo_line_code within w_mcn_mold_issue_master
integer x = 206
integer y = 424
integer height = 1980
integer taborder = 40
boolean bringtotop = true
end type

type st_7 from so_statictext within w_mcn_mold_issue_master
integer x = 206
integer y = 360
integer width = 631
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Line Code"
end type

type rb_1 from so_radiobutton within w_mcn_mold_issue_master
integer x = 3813
integer y = 76
integer width = 443
boolean bringtotop = true
integer weight = 700
string text = "Mold In"
end type

event clicked;call super::clicked;dw_1.setfilter("mold_in_out = 'I'")
dw_1.filter( )
end event

type rb_2 from so_radiobutton within w_mcn_mold_issue_master
integer x = 3813
integer y = 188
integer width = 443
boolean bringtotop = true
integer weight = 700
string text = "Mold Out"
end type

event clicked;call super::clicked;dw_1.setfilter("mold_in_out = 'O'")
dw_1.filter( )
end event

type ddlb_mold_use_status from uo_basecode within w_mcn_mold_issue_master
integer x = 2606
integer y = 160
integer width = 425
integer taborder = 70
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'MOLD USE STATUS')
end event

type st_8 from so_statictext within w_mcn_mold_issue_master
integer x = 2610
integer y = 88
integer width = 425
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Mold Use Status"
end type

type ddlb_mold_code from uo_mold_code within w_mcn_mold_issue_master
integer x = 754
integer y = 164
integer width = 567
integer taborder = 50
boolean bringtotop = true
end type

type ddlb_machine_code from uo_machine_code within w_mcn_mold_issue_master
integer x = 1486
integer y = 424
integer height = 1752
integer taborder = 40
boolean bringtotop = true
end type

type rb_request from so_radiobutton within w_mcn_mold_issue_master
integer x = 50
integer y = 132
integer width = 631
boolean bringtotop = true
integer weight = 700
string text = "Request List"
end type

event clicked;call super::clicked;dw_4.bringtotop = true 
selected_data_window = dw_4
cb_batch_issue.enabled = true
cb_issue_cancel.enabled = false
end event

type gb_1 from so_groupbox within w_mcn_mold_issue_master
integer width = 699
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_2 from so_groupbox within w_mcn_mold_issue_master
integer x = 713
integer width = 2391
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_mcn_mold_issue_master
integer x = 3136
integer width = 1147
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Filter"
end type

type gb_4 from so_groupbox within w_mcn_mold_issue_master
integer y = 308
integer width = 4279
integer height = 228
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

