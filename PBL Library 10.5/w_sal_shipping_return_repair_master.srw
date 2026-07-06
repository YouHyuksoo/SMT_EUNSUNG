HA$PBExportHeader$w_sal_shipping_return_repair_master.srw
$PBExportComments$Line Master
forward
global type w_sal_shipping_return_repair_master from w_main_root
end type
type sle_pcb_serial_no from so_singlelineedit within w_sal_shipping_return_repair_master
end type
type st_2 from statictext within w_sal_shipping_return_repair_master
end type
type ddlb_line_code from uo_line_code within w_sal_shipping_return_repair_master
end type
type st_3 from statictext within w_sal_shipping_return_repair_master
end type
type uo_dateset from uo_ymd_calendar within w_sal_shipping_return_repair_master
end type
type st_5 from so_statictext within w_sal_shipping_return_repair_master
end type
type uo_dateend from uo_ymd_calendar within w_sal_shipping_return_repair_master
end type
type gb_2 from so_groupbox within w_sal_shipping_return_repair_master
end type
type gb_3 from so_groupbox within w_sal_shipping_return_repair_master
end type
type cb_1 from so_commandbutton within w_sal_shipping_return_repair_master
end type
type cb_issue from so_commandbutton within w_sal_shipping_return_repair_master
end type
type cb_issue_cancel from so_commandbutton within w_sal_shipping_return_repair_master
end type
type ddlb_workstage_code from uo_workstage_code_all within w_sal_shipping_return_repair_master
end type
type st_1 from so_statictext within w_sal_shipping_return_repair_master
end type
type ddlb_receipt_deficit from uo_basecode within w_sal_shipping_return_repair_master
end type
type st_7 from so_statictext within w_sal_shipping_return_repair_master
end type
type cb_6 from so_commandbutton within w_sal_shipping_return_repair_master
end type
type cb_2 from so_commandbutton within w_sal_shipping_return_repair_master
end type
type cb_7 from so_commandbutton within w_sal_shipping_return_repair_master
end type
type cb_8 from so_commandbutton within w_sal_shipping_return_repair_master
end type
type cb_9 from so_commandbutton within w_sal_shipping_return_repair_master
end type
type cb_10 from so_commandbutton within w_sal_shipping_return_repair_master
end type
type rb_repair_receipt from so_radiobutton within w_sal_shipping_return_repair_master
end type
type rb_2 from so_radiobutton within w_sal_shipping_return_repair_master
end type
type ddlb_repair_result_code from uo_basecode within w_sal_shipping_return_repair_master
end type
type st_8 from so_statictext within w_sal_shipping_return_repair_master
end type
type ddlb_model_name from uo_set_model_name_ddlb within w_sal_shipping_return_repair_master
end type
type st_4 from statictext within w_sal_shipping_return_repair_master
end type
type sle_model_name from so_singlelineedit within w_sal_shipping_return_repair_master
end type
type st_6 from statictext within w_sal_shipping_return_repair_master
end type
type sle_complaints_no from so_singlelineedit within w_sal_shipping_return_repair_master
end type
type st_complaint_no from statictext within w_sal_shipping_return_repair_master
end type
type st_10 from statictext within w_sal_shipping_return_repair_master
end type
type st_11 from statictext within w_sal_shipping_return_repair_master
end type
type sle_pcb_serial_cond from so_singlelineedit within w_sal_shipping_return_repair_master
end type
type sle_complaint_no_cond from so_singlelineedit within w_sal_shipping_return_repair_master
end type
type sle_model_name_scan from so_singlelineedit within w_sal_shipping_return_repair_master
end type
type sle_model_suffix_scan from so_singlelineedit within w_sal_shipping_return_repair_master
end type
type st_12 from statictext within w_sal_shipping_return_repair_master
end type
type st_13 from statictext within w_sal_shipping_return_repair_master
end type
type sle_item_code_scan from so_singlelineedit within w_sal_shipping_return_repair_master
end type
type st_14 from statictext within w_sal_shipping_return_repair_master
end type
type em_return_qty from so_editmask within w_sal_shipping_return_repair_master
end type
type st_9 from statictext within w_sal_shipping_return_repair_master
end type
type gb_1 from so_groupbox within w_sal_shipping_return_repair_master
end type
type gb_4 from so_groupbox within w_sal_shipping_return_repair_master
end type
type gb_5 from so_groupbox within w_sal_shipping_return_repair_master
end type
type gb_6 from so_groupbox within w_sal_shipping_return_repair_master
end type
end forward

global type w_sal_shipping_return_repair_master from w_main_root
integer width = 5545
integer height = 2748
string title = "Shipping Return Repair Master"
long backcolor = 16777215
sle_pcb_serial_no sle_pcb_serial_no
st_2 st_2
ddlb_line_code ddlb_line_code
st_3 st_3
uo_dateset uo_dateset
st_5 st_5
uo_dateend uo_dateend
gb_2 gb_2
gb_3 gb_3
cb_1 cb_1
cb_issue cb_issue
cb_issue_cancel cb_issue_cancel
ddlb_workstage_code ddlb_workstage_code
st_1 st_1
ddlb_receipt_deficit ddlb_receipt_deficit
st_7 st_7
cb_6 cb_6
cb_2 cb_2
cb_7 cb_7
cb_8 cb_8
cb_9 cb_9
cb_10 cb_10
rb_repair_receipt rb_repair_receipt
rb_2 rb_2
ddlb_repair_result_code ddlb_repair_result_code
st_8 st_8
ddlb_model_name ddlb_model_name
st_4 st_4
sle_model_name sle_model_name
st_6 st_6
sle_complaints_no sle_complaints_no
st_complaint_no st_complaint_no
st_10 st_10
st_11 st_11
sle_pcb_serial_cond sle_pcb_serial_cond
sle_complaint_no_cond sle_complaint_no_cond
sle_model_name_scan sle_model_name_scan
sle_model_suffix_scan sle_model_suffix_scan
st_12 st_12
st_13 st_13
sle_item_code_scan sle_item_code_scan
st_14 st_14
em_return_qty em_return_qty
st_9 st_9
gb_1 gb_1
gb_4 gb_4
gb_5 gb_5
gb_6 gb_6
end type
global w_sal_shipping_return_repair_master w_sal_shipping_return_repair_master

type variables
Long Lvl_row
end variables

on w_sal_shipping_return_repair_master.create
int iCurrent
call super::create
this.sle_pcb_serial_no=create sle_pcb_serial_no
this.st_2=create st_2
this.ddlb_line_code=create ddlb_line_code
this.st_3=create st_3
this.uo_dateset=create uo_dateset
this.st_5=create st_5
this.uo_dateend=create uo_dateend
this.gb_2=create gb_2
this.gb_3=create gb_3
this.cb_1=create cb_1
this.cb_issue=create cb_issue
this.cb_issue_cancel=create cb_issue_cancel
this.ddlb_workstage_code=create ddlb_workstage_code
this.st_1=create st_1
this.ddlb_receipt_deficit=create ddlb_receipt_deficit
this.st_7=create st_7
this.cb_6=create cb_6
this.cb_2=create cb_2
this.cb_7=create cb_7
this.cb_8=create cb_8
this.cb_9=create cb_9
this.cb_10=create cb_10
this.rb_repair_receipt=create rb_repair_receipt
this.rb_2=create rb_2
this.ddlb_repair_result_code=create ddlb_repair_result_code
this.st_8=create st_8
this.ddlb_model_name=create ddlb_model_name
this.st_4=create st_4
this.sle_model_name=create sle_model_name
this.st_6=create st_6
this.sle_complaints_no=create sle_complaints_no
this.st_complaint_no=create st_complaint_no
this.st_10=create st_10
this.st_11=create st_11
this.sle_pcb_serial_cond=create sle_pcb_serial_cond
this.sle_complaint_no_cond=create sle_complaint_no_cond
this.sle_model_name_scan=create sle_model_name_scan
this.sle_model_suffix_scan=create sle_model_suffix_scan
this.st_12=create st_12
this.st_13=create st_13
this.sle_item_code_scan=create sle_item_code_scan
this.st_14=create st_14
this.em_return_qty=create em_return_qty
this.st_9=create st_9
this.gb_1=create gb_1
this.gb_4=create gb_4
this.gb_5=create gb_5
this.gb_6=create gb_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_pcb_serial_no
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.ddlb_line_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.uo_dateset
this.Control[iCurrent+6]=this.st_5
this.Control[iCurrent+7]=this.uo_dateend
this.Control[iCurrent+8]=this.gb_2
this.Control[iCurrent+9]=this.gb_3
this.Control[iCurrent+10]=this.cb_1
this.Control[iCurrent+11]=this.cb_issue
this.Control[iCurrent+12]=this.cb_issue_cancel
this.Control[iCurrent+13]=this.ddlb_workstage_code
this.Control[iCurrent+14]=this.st_1
this.Control[iCurrent+15]=this.ddlb_receipt_deficit
this.Control[iCurrent+16]=this.st_7
this.Control[iCurrent+17]=this.cb_6
this.Control[iCurrent+18]=this.cb_2
this.Control[iCurrent+19]=this.cb_7
this.Control[iCurrent+20]=this.cb_8
this.Control[iCurrent+21]=this.cb_9
this.Control[iCurrent+22]=this.cb_10
this.Control[iCurrent+23]=this.rb_repair_receipt
this.Control[iCurrent+24]=this.rb_2
this.Control[iCurrent+25]=this.ddlb_repair_result_code
this.Control[iCurrent+26]=this.st_8
this.Control[iCurrent+27]=this.ddlb_model_name
this.Control[iCurrent+28]=this.st_4
this.Control[iCurrent+29]=this.sle_model_name
this.Control[iCurrent+30]=this.st_6
this.Control[iCurrent+31]=this.sle_complaints_no
this.Control[iCurrent+32]=this.st_complaint_no
this.Control[iCurrent+33]=this.st_10
this.Control[iCurrent+34]=this.st_11
this.Control[iCurrent+35]=this.sle_pcb_serial_cond
this.Control[iCurrent+36]=this.sle_complaint_no_cond
this.Control[iCurrent+37]=this.sle_model_name_scan
this.Control[iCurrent+38]=this.sle_model_suffix_scan
this.Control[iCurrent+39]=this.st_12
this.Control[iCurrent+40]=this.st_13
this.Control[iCurrent+41]=this.sle_item_code_scan
this.Control[iCurrent+42]=this.st_14
this.Control[iCurrent+43]=this.em_return_qty
this.Control[iCurrent+44]=this.st_9
this.Control[iCurrent+45]=this.gb_1
this.Control[iCurrent+46]=this.gb_4
this.Control[iCurrent+47]=this.gb_5
this.Control[iCurrent+48]=this.gb_6
end on

on w_sal_shipping_return_repair_master.destroy
call super::destroy
destroy(this.sle_pcb_serial_no)
destroy(this.st_2)
destroy(this.ddlb_line_code)
destroy(this.st_3)
destroy(this.uo_dateset)
destroy(this.st_5)
destroy(this.uo_dateend)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.cb_1)
destroy(this.cb_issue)
destroy(this.cb_issue_cancel)
destroy(this.ddlb_workstage_code)
destroy(this.st_1)
destroy(this.ddlb_receipt_deficit)
destroy(this.st_7)
destroy(this.cb_6)
destroy(this.cb_2)
destroy(this.cb_7)
destroy(this.cb_8)
destroy(this.cb_9)
destroy(this.cb_10)
destroy(this.rb_repair_receipt)
destroy(this.rb_2)
destroy(this.ddlb_repair_result_code)
destroy(this.st_8)
destroy(this.ddlb_model_name)
destroy(this.st_4)
destroy(this.sle_model_name)
destroy(this.st_6)
destroy(this.sle_complaints_no)
destroy(this.st_complaint_no)
destroy(this.st_10)
destroy(this.st_11)
destroy(this.sle_pcb_serial_cond)
destroy(this.sle_complaint_no_cond)
destroy(this.sle_model_name_scan)
destroy(this.sle_model_suffix_scan)
destroy(this.st_12)
destroy(this.st_13)
destroy(this.sle_item_code_scan)
destroy(this.st_14)
destroy(this.em_return_qty)
destroy(this.st_9)
destroy(this.gb_1)
destroy(this.gb_4)
destroy(this.gb_5)
destroy(this.gb_6)
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
Ivs_resize_type                      = 'MASTER_DETAIL_12T_3B'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )

ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

/****************************************
*  Menu Property
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

sle_complaints_no.setfocus()

end event

event ue_data_control;call super::ue_data_control;CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		   
			dw_3.reset()
		     dw_1.retrieve( sle_complaint_no_cond.text+'%' , sle_pcb_serial_no.text , gvi_organization_id )
		     dw_2.retrieve( sle_pcb_serial_no.text , gvi_organization_id )
			dw_3.RETRIEVE(sle_complaint_no_cond.text+'%' ,  ddlb_model_Name.getcode()+'%' ,  sle_pcb_serial_cond.TEXT +'%' ,uo_dateset.text() , uo_dateend.text() , ddlb_receipt_deficit.getcode( )+'%' , '%' ,   ddlb_repair_result_code.getcode( )+'%' , GVI_ORGANIZATION_ID )
			sle_pcb_serial_no.setfocus()
				
	CASE 'INSERT'
		
			if sle_pcb_serial_no.text = '' or isnull(sle_pcb_serial_no.text) or sle_pcb_serial_no.text = '%' then 
				return 
			end if 
			Lvl_row = dw_1.insertrow(0)
			dw_1.scrolltorow(Lvl_row)
			f_set_security_row(dw_1 , Lvl_row , 'ALL')
			F_MSG_MDI_HELP ( F_MSG_ST(152)	 )
			
	CASE 'DELETE'
		
		  	if dw_1.getrow() < 1 then return 
			  
			msg =f_msgbox(1003)
			if msg = 1 then
				gvl_row_deleted = dw_1.getrow()			
				dw_1.deleterow(gvl_row_deleted)		
				dw_1.setfocus()
				Lvl_row = dw_1.getrow()
				dw_1.scrolltorow(Lvl_row)
				dw_1.setcolumn(1)
			end if

			IF DW_1.UPDATE() < 0 THEN
				ROLLBACK;	
				sle_pcb_serial_no.setfocus()
			ELSE
				 COMMIT;
					 F_MSG_MDI_HELP ( F_MSG_ST(170)	 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
				sle_pcb_serial_no.setfocus()
			END IF			
			
			sle_pcb_serial_no.setfocus()
	CASE 'UPDATE'
		
		 DW_1.ACCEPTTEXT()
 
	      IF DW_1.UPDATE() < 0 THEN
				ROLLBACK;	
		ELSE
				 COMMIT;
       			 F_MSG_MDI_HELP ( F_MSG_ST(170)	 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			
		END IF
				sle_pcb_serial_no.text = ''
				sle_pcb_serial_no.setfocus()
	CASE ELSE
END CHOOSE


end event

type dw_5 from w_main_root`dw_5 within w_sal_shipping_return_repair_master
integer x = 585
integer y = 508
integer width = 782
integer height = 460
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_sal_shipping_return_repair_master
integer x = 585
integer y = 508
integer width = 782
integer height = 460
integer taborder = 0
end type

type dw_3 from w_main_root`dw_3 within w_sal_shipping_return_repair_master
integer x = 581
integer y = 1232
integer width = 4649
integer height = 1416
integer taborder = 0
string dragicon = ""
boolean titlebar = true
string title = "Repair History"
string dataobject = "d_pln_product_work_qc_4_return_hst"
borderstyle borderstyle = stylebox!
end type

event dw_3::doubleclicked;call super::doubleclicked;if row < 1 then return
sle_pcb_serial_no.text = this.object.serial_no[row]
sle_pcb_serial_no.selecttext( 1, 30) 
f_retrieve()
end event

type dw_2 from w_main_root`dw_2 within w_sal_shipping_return_repair_master
integer x = 4165
integer y = 508
integer width = 1070
integer height = 720
integer taborder = 0
string dragicon = ""
boolean titlebar = true
string title = "Issue List"
string dataobject = "d_pln_product_work_qc_issue_lst"
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

type dw_1 from w_main_root`dw_1 within w_sal_shipping_return_repair_master
integer x = 581
integer y = 508
integer width = 3575
integer height = 720
integer taborder = 0
string dragicon = ""
boolean titlebar = true
string title = "Receipt List"
string dataobject = "d_pln_product_work_qc_4_return_lst"
borderstyle borderstyle = stylebox!
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;lvl_row = currentrow
end event

type uo_tabpages from w_main_root`uo_tabpages within w_sal_shipping_return_repair_master
integer taborder = 0
long backcolor = 16777215
end type

type sle_pcb_serial_no from so_singlelineedit within w_sal_shipping_return_repair_master
integer x = 635
integer y = 388
integer width = 608
integer taborder = 1
boolean bringtotop = true
long backcolor = 16777215
textcase textcase = upper!
end type

event modified;call super::modified;string lvs_serial_no ,  lvs_line_code , lvs_bad_reason_code , lvs_workstage_code , lvs_item_code , lvs_model_name , lvs_complaint_no
long lvl_sequence , ll_row , lvi_count
		
//dw_1.reset()
//dw_2.reset()

//================================================
// $$HEX5$$7cb778c754cfdcb42000$$ENDHEX$$
//================================================

		lvs_complaint_no = sle_complaints_no.text
		if lvs_complaint_no = '' or isnull(lvs_complaint_no) or lvs_complaint_no = '%' then 
			
			f_msgbox1(126 , st_complaint_no.text )
			sle_complaints_no.setfocus( )
			return
		end if 
		
//		select count(*) into :lvi_count 
//		from ICOM_CUSTOMER_COMPLAINTS
//		where complaints_no = :lvs_complaint_no
//		and organization_id = :gvi_organization_id ;	
//
//		if f_sql_check() < 0 then return 
//		
//		if lvi_count = 0 then
//			f_msgbox1(126 , st_complaint_no.text )
//			sle_complaint_no.setfocus( )
//			return 
//		end if 
//================================================
// $$HEX5$$7cb778c754cfdcb42000$$ENDHEX$$
//================================================
		lvs_line_code = ddlb_line_code.getcode( )
		if lvs_line_code = '' or isnull(lvs_line_code) or lvs_line_code = '%' then 
			lvs_line_code = '*'
		end if 
//================================================
// $$HEX5$$f5ac15c854cfdcb42000$$ENDHEX$$
//================================================		
		lvs_workstage_code = ddlb_workstage_code.getcode( )
		if lvs_workstage_code = '' or isnull(lvs_workstage_code) or lvs_workstage_code = '%' then 
			lvs_workstage_code = '*'
		end if 
//================================================
// 
//================================================				
		if rb_repair_receipt.checked = true then 
		
						ll_row = dw_1.retrieve( sle_pcb_serial_no.text , gvi_organization_id )
						
						//$$HEX16$$85c7e0ac00ac200018b4b4c5200088c794b22000c1c0dcd0200074c774ba2000$$ENDHEX$$
						//$$HEX9$$f8ade5b02000acb934d120005cd5e4b22000$$ENDHEX$$
						if ll_row > 0 then 
							sle_pcb_serial_no.text = ''
							sle_pcb_serial_no.setfocus()			
							return 
						end if 
						
						lvs_serial_no = sle_pcb_serial_no.text 
						lvl_sequence = F_GET_SEQUENCE( "SEQ_QC_REPAIR_SEQUENCE")
						
						if lvs_serial_no = '' or isnull(lvs_serial_no) or lvs_serial_no = '%' then 
							sle_pcb_serial_no.text = ''
							sle_pcb_serial_no.setfocus()			
							return 
						end if 
						
						//==============================================
						// 
						//  $$HEX18$$a4c294ce2000c8b9a4c230d15cb8200080bd45d1200015c8f4bc200000ac38c834c62000$$ENDHEX$$
						//==============================================
						
						select  distinct  ITEM_CODE ,  MODEL_NAME 
						   into :lvs_item_code , :lvs_model_name 
						 from IP_PRODUCT_2D_BARCODE
						 where serial_no = :lvs_serial_no
							 and organization_id = :gvi_organization_id ;  
							 
						//=========================================
						//  $$HEX18$$14bc54cfdcb42000ddc031c1200074c725b874c72000c6c53cc774ba2000d8c5c0c92000$$ENDHEX$$HUB $$HEX7$$d0c51cc1200000ac38c834c62000$$ENDHEX$$.
						//=========================================
						if lvs_item_code = '' or isnull(lvs_item_code) then 
							
								 select  DISTINCT ITEM_CODE  , LOCATION  
									 into  :lvs_item_code ,   :lvs_workstage_code 
									 from TB_VIS_PID_ISSUE_HIST
								WHERE PRODUCT_ID = :lvs_serial_no ;		
								
							end if 
						//===============================================
						
						if lvs_item_code = '' or isnull(lvs_item_code) then 
							
								lvs_item_code = sle_item_code_scan.text 
								lvs_model_name = sle_model_name_scan.text 
							
						end if 
						
				
						//===================================================
						//
						//===================================================
						f_insert()
						
						dw_1.object.complaint_no[lvl_row]   = lvs_complaint_no
						dw_1.object.model_name[lvl_row] = lvs_model_name
						dw_1.object.item_code[lvl_row] = lvs_item_code
						dw_1.object.serial_no[lvl_row]   = lvs_serial_no
						
						dw_1.object.bad_reason_code[lvl_row]  =  lvs_bad_reason_code
						  
						dw_1.object.qc_result[lvl_row]  =  'W'
						dw_1.object.line_code[lvl_row] = lvs_line_code
						dw_1.object.machine_code[lvl_row] = '*'		
						dw_1.object.workstage_code[lvl_row] = lvs_workstage_code
					
						dw_1.object.receipt_deficit[lvl_row] = '1'
						dw_1.object.qc_inspect_handling[lvl_row] = 'W'	
						dw_1.object.qc_date[lvl_row] = f_sysdate()
						dw_1.object.charger[lvl_row] = gvs_user_id
					
						dw_1.object.qc_sequence[lvl_row] = lvl_sequence
						dw_1.object.repair_by[lvl_row] = Gvs_user_id
						
						dw_1.object.bad_qty[lvl_row] = 1
						dw_1.object.defect_qty[lvl_row] = 1
						
						f_update()
						//====================================
						// $$HEX23$$74c704c8d0c52000d9b37cc720005cd52000dcc2acb9bcc52000200010cde0ac200074c725b8200070c88cd62000$$ENDHEX$$
						//
						//====================================
						dw_2.retrieve(sle_pcb_serial_no.text , gvi_organization_id)		
				
						sle_pcb_serial_no.text = ''
						sle_pcb_serial_no.setfocus()
						
			else
						dw_2.retrieve(sle_pcb_serial_no.text , gvi_organization_id)		
			end if 

end event

event getfocus;call super::getfocus;this.selecttext( 1,30)
end event

type st_2 from statictext within w_sal_shipping_return_repair_master
integer x = 635
integer y = 308
integer width = 608
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 16777215
string text = "PCB Serial No"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_line_code from uo_line_code within w_sal_shipping_return_repair_master
integer x = 1193
integer y = 140
integer width = 366
integer height = 1936
boolean bringtotop = true
long backcolor = 16777215
end type

type st_3 from statictext within w_sal_shipping_return_repair_master
integer x = 1193
integer y = 64
integer width = 357
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 134217745
long backcolor = 16777215
string text = "Line Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_dateset from uo_ymd_calendar within w_sal_shipping_return_repair_master
event destroy ( )
integer x = 2149
integer y = 140
boolean bringtotop = true
long backcolor = 16777215
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_5 from so_statictext within w_sal_shipping_return_repair_master
integer x = 2158
integer y = 64
integer width = 823
integer height = 68
boolean bringtotop = true
long textcolor = 134217745
long backcolor = 16777215
string text = "QC Date"
end type

type uo_dateend from uo_ymd_calendar within w_sal_shipping_return_repair_master
event destroy ( )
integer x = 2569
integer y = 140
boolean bringtotop = true
long backcolor = 16777215
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type gb_2 from so_groupbox within w_sal_shipping_return_repair_master
integer x = 613
integer width = 4457
integer height = 240
integer weight = 700
long textcolor = 8421504
long backcolor = 16777215
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_sal_shipping_return_repair_master
integer y = 844
integer width = 576
integer height = 744
integer weight = 700
long textcolor = 8421504
long backcolor = 16777215
string text = "Select"
end type

type cb_1 from so_commandbutton within w_sal_shipping_return_repair_master
integer x = 27
integer y = 560
integer height = 124
boolean bringtotop = true
string text = "Bad Reason Code"
end type

event clicked;call super::clicked;open(w_bad_reason_select_popup)

if Gst_return.gvb_return = true then 

	dw_1.object.bad_reason_code[Lvl_row]  = Gst_return.gvs_return[1]
	dw_1.object.bad_qty[Lvl_row]  = Gst_return.gvl_return[1]
	dw_1.object.defect_qty[Lvl_row]  = Gst_return.gvl_return[2]

end if 

sle_pcb_serial_no.text = ''
sle_pcb_serial_no.setfocus()
end event

type cb_issue from so_commandbutton within w_sal_shipping_return_repair_master
integer x = 27
integer y = 1848
integer height = 156
boolean bringtotop = true
string text = "Issue"
boolean flatstyle = true
end type

event clicked;call super::clicked;sle_pcb_serial_no.text = ''
long lvl_sequence
string lvs_serial_no

		if dw_1.getrow() < 1 then 
			return 
		end if 
		
		if dw_1.object.qc_inspect_handling[dw_1.getrow()] ='U' then 
			

						if f_msgbox1(1161 , this.text ) = 1 THEN 
						else
							return
						end if 
						
						f_update()
						
						lvl_sequence = dw_1.object.qc_sequence[dw_1.getrow()]
						lvs_serial_no = dw_1.object.serial_no[dw_1.getrow()]
						
						update ip_product_work_qc set receipt_deficit = '2' ,
								  repair_date = sysdate
						 where serial_no = :lvs_serial_no
								and qc_sequence = :lvl_sequence
							 and organization_id = :gvi_organization_id ;
							  
						if f_sql_check() < 0 then 
							return 
						end if 
						
		elseif dw_1.object.qc_inspect_handling[dw_1.getrow()] ='D' then 				
						

						if f_msgbox1(1161 , this.text ) = 1 THEN 
						else
							return
						end if 
						
						f_update()
						
						lvl_sequence = dw_1.object.qc_sequence[dw_1.getrow()]
						lvs_serial_no = dw_1.object.serial_no[dw_1.getrow()]
						
						update ip_product_work_qc set receipt_deficit = '2' ,
								  repair_date = sysdate 
						 where serial_no = :lvs_serial_no
							and qc_sequence = :lvl_sequence
							 and organization_id = :gvi_organization_id ;
							  
						if f_sql_check() < 0 then 
							return 
						end if 				
					
//						update ip_product_pcb_scan_master 
//						     set pcb_status = 'D'
//					     where serial_no = :lvs_serial_no
//						    and organization_id = :gvi_organization_id ;	
//						
//						if f_sql_check() < 0 then 
//							return 
//						end if 			
						
		else
			//=================================
			// $$HEX10$$c4d698ccacb9200018bcdcb4dcc2200085c725b8$$ENDHEX$$
			//=================================
			f_msgbox(113)
			//messagebox("$$HEX2$$55d678c7$$ENDHEX$$" , "$$HEX18$$c4d698ccacb92000b4b0a9c644c7200018bcdcb4dcc2200085c725b8200058d538c194c6$$ENDHEX$$")
			f_msg("$$HEX18$$c4d698ccacb92000b4b0a9c644c7200018bcdcb4dcc2200085c725b8200058d538c194c6$$ENDHEX$$",'P')
			return 
		end if 


		commit ;
		
		dw_1.retrieve(lvs_serial_no , gvi_organization_id)
		dw_2.retrieve(lvs_serial_no , gvi_organization_id)
		
end event

type cb_issue_cancel from so_commandbutton within w_sal_shipping_return_repair_master
integer x = 27
integer y = 2008
integer height = 156
boolean bringtotop = true
string text = "Issue Cancel"
boolean flatstyle = true
end type

event clicked;call super::clicked;f_update()
sle_pcb_serial_no.text = ''

string lvs_serial_no , lvs_qc_inspect_handling

		if dw_2.getrow() < 1 then 
			return 
		end if 
		
		lvs_serial_no = dw_2.object.serial_no[dw_2.getrow()]
         lvs_qc_inspect_handling = dw_2.object.qc_inspect_handling[dw_2.getrow()] 
			
		update ip_product_work_qc set receipt_deficit = '1'  ,
		           repair_date = null ,
				  new_run_no = null 
		 where serial_no = :lvs_serial_no
			  and organization_id = :gvi_organization_id ;
			  
		if f_sql_check() < 0 then 
			return 
		end if 
		
//		IF lvs_qc_inspect_handling = 'D' THEN 
//			 UPDATE IP_PRODUCT_PCB_SCAN_MASTER 
//				  SET PCB_STATUS = 'N' 
//			 WHERE SERIAL_NO = :LVS_SERIAL_NO
//				  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID  ;
//			 
//			 IF F_SQL_CHECK() < 0 THEN 
//				  RETURN 
//			 END IF 
//		END IF 
//		 //=================================
//		 // $$HEX10$$30ae74c8200014bc54cfdcb42000c0bcbdac2000$$ENDHEX$$
//		 //=================================
//		 
//		 UPDATE IP_PRODUCT_PCB_BARCODE
//			  SET  RUN_NO = OLD_RUN_NO ,
//						 OLD_RUN_NO = NULL
//		 WHERE SERIAL_NO = :LVS_SERIAL_NO
//		 AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID  ;
//		 
//		 IF F_SQL_CHECK() < 0 THEN 
//			  RETURN 
//		 END IF 		
		commit ;
		
		dw_1.retrieve(lvs_serial_no , gvi_organization_id)
		dw_2.retrieve(lvs_serial_no , gvi_organization_id)
		
sle_pcb_serial_no.text = ''
sle_pcb_serial_no.setfocus()		
end event

type ddlb_workstage_code from uo_workstage_code_all within w_sal_shipping_return_repair_master
integer x = 1563
integer y = 140
integer width = 585
integer height = 1936
boolean bringtotop = true
long backcolor = 16777215
end type

event selectionchanged;call super::selectionchanged;SLE_PCB_SERIAL_NO.SETFOCUS( )    
end event

type st_1 from so_statictext within w_sal_shipping_return_repair_master
integer x = 1563
integer y = 64
integer width = 585
integer height = 68
boolean bringtotop = true
long textcolor = 134217745
long backcolor = 16777215
string text = "Workstage Code"
end type

type ddlb_receipt_deficit from uo_basecode within w_sal_shipping_return_repair_master
integer x = 2994
integer y = 144
integer width = 352
integer height = 508
boolean bringtotop = true
long backcolor = 16777215
end type

event constructor;call super::constructor;this.redraw("RECEIPT DEFICIT")
end event

type st_7 from so_statictext within w_sal_shipping_return_repair_master
integer x = 2994
integer y = 64
integer width = 352
integer height = 68
boolean bringtotop = true
long textcolor = 134217745
long backcolor = 16777215
string text = "Receipt Deficit"
end type

type cb_6 from so_commandbutton within w_sal_shipping_return_repair_master
integer x = 27
integer y = 684
integer height = 124
boolean bringtotop = true
string text = "Repair Item"
end type

event clicked;call super::clicked;if dw_1.getrow() < 1 then return
Gst_return.gvs_return[1] = string(dw_1.object.qc_sequence[dw_1.getrow()] )
openwithparm(w_qc_repair_item_popup , '%' )
end event

type cb_2 from so_commandbutton within w_sal_shipping_return_repair_master
integer x = 27
integer y = 900
integer height = 156
boolean bringtotop = true
string text = "NG / Reuse"
end type

event clicked;call super::clicked;if dw_1.getrow( ) < 1 then return 
	dw_1.object.qc_result[dw_1.getrow()] = 'N'
	dw_1.object.qc_inspect_handling[dw_1.getrow()] = 'U'
	
f_Update()
end event

type cb_7 from so_commandbutton within w_sal_shipping_return_repair_master
integer x = 27
integer y = 1184
integer height = 156
boolean bringtotop = true
string text = "NG / Destroy"
end type

event clicked;call super::clicked;if dw_1.getrow( ) < 1 then return 
	dw_1.object.qc_result[dw_1.getrow()] = 'N'
	dw_1.object.qc_inspect_handling[dw_1.getrow()] = 'D'
f_Update()
end event

type cb_8 from so_commandbutton within w_sal_shipping_return_repair_master
integer x = 27
integer y = 1032
integer height = 156
boolean bringtotop = true
string text = "OK / Reuse"
end type

event clicked;call super::clicked;if dw_1.getrow( ) < 1 then return 
	dw_1.object.qc_result[dw_1.getrow()] = 'O'
	dw_1.object.qc_inspect_handling[dw_1.getrow()] = 'U'


f_Update()
end event

type cb_9 from so_commandbutton within w_sal_shipping_return_repair_master
integer x = 27
integer y = 1336
integer height = 156
boolean bringtotop = true
string text = "NG / Wait"
end type

event clicked;call super::clicked;if dw_1.getrow( ) < 1 then return 
	dw_1.object.qc_result[dw_1.getrow()] = 'N'
	dw_1.object.qc_inspect_handling[dw_1.getrow()] = 'W'
f_Update()
end event

type cb_10 from so_commandbutton within w_sal_shipping_return_repair_master
integer x = 27
integer y = 2168
integer height = 164
boolean bringtotop = true
string text = "Excel Paste"
boolean flatstyle = true
end type

event clicked;call super::clicked;open(w_qc_repair_receipt_excel_form_popup)
end event

type rb_repair_receipt from so_radiobutton within w_sal_shipping_return_repair_master
integer x = 69
integer y = 60
boolean bringtotop = true
long textcolor = 0
long backcolor = 16777215
string text = "Repair Receipt List"
boolean checked = true
end type

type rb_2 from so_radiobutton within w_sal_shipping_return_repair_master
integer x = 69
integer y = 152
boolean bringtotop = true
long textcolor = 0
long backcolor = 16777215
string text = "Repair History"
end type

type ddlb_repair_result_code from uo_basecode within w_sal_shipping_return_repair_master
integer x = 3351
integer y = 144
integer width = 462
integer height = 1936
boolean bringtotop = true
long backcolor = 16777215
end type

event constructor;call super::constructor;this.redraw( 'REPAIR RESULT CODE')
end event

type st_8 from so_statictext within w_sal_shipping_return_repair_master
integer x = 3351
integer y = 64
integer width = 462
integer height = 68
boolean bringtotop = true
long textcolor = 134217745
long backcolor = 16777215
string text = "Repair Result Code"
end type

type ddlb_model_name from uo_set_model_name_ddlb within w_sal_shipping_return_repair_master
integer x = 654
integer y = 140
integer width = 535
integer height = 1936
boolean bringtotop = true
long backcolor = 16777215
end type

type st_4 from statictext within w_sal_shipping_return_repair_master
integer x = 654
integer y = 64
integer width = 535
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 134217745
long backcolor = 16777215
string text = "Model Name"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_model_name from so_singlelineedit within w_sal_shipping_return_repair_master
integer x = 27
integer y = 1752
integer width = 535
integer height = 84
integer taborder = 40
boolean bringtotop = true
long backcolor = 16777215
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_3.SETFILTER('')
dw_3.FILTER()

LVS_COLUMN = 'SERIAL_NO'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    dw_3.SETFILTER('')
    dw_3.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+UPPER(this.text)+'%'
END IF

dw_3.SETFILTER( "UPPER("+LVS_COLUMN+")"  +" LIKE '"+LVS_VALUE+"'")
dw_3.FILTER()
F_MSG_MDI_HELP( STRING( dw_3.ROWCOUNT() ) + " Found" )

dw_2.SETFILTER('')
dw_2.FILTER()

LVS_COLUMN = 'CHILD_ITEM_CODE'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    dw_2.SETFILTER('')
    dw_2.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+UPPER(this.text)+'%'
END IF

dw_2.SETFILTER( "UPPER("+LVS_COLUMN+")"  +" LIKE '"+LVS_VALUE+"'")
dw_2.FILTER()
F_MSG_MDI_HELP( STRING( dw_2.ROWCOUNT() ) + " Found" )


end event

type st_6 from statictext within w_sal_shipping_return_repair_master
integer x = 27
integer y = 1684
integer width = 535
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "PCB Serial No"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_complaints_no from so_singlelineedit within w_sal_shipping_return_repair_master
integer x = 18
integer y = 388
integer width = 608
integer taborder = 11
boolean bringtotop = true
long backcolor = 16777215
textcase textcase = upper!
end type

event getfocus;call super::getfocus;this.selecttext( 1,30)
end event

event modified;call super::modified;STRING LVS_MODEL_NAME , LVS_MODEL_SUFFIX , LVS_ITEM_CODE , LVS_COMPLAINTS_NO
INT LVI_COUNT  , LVL_COMPLAINTS_QTY

SELECT MODEL_NAME , MODEL_SUFFIX , ITEM_CODE , COMPLAINTS_QTY
    INTO  :LVS_MODEL_NAME , :LVS_MODEL_SUFFIX , :LVS_ITEM_CODE  , :LVL_COMPLAINTS_QTY
 FROM ICOM_CUSTOMER_COMPLAINTS
 WHERE COMPLAINTS_NO = :LVS_COMPLAINTS_NO
     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
 
IF F_SQL_CHECK() < 0 THEN 
	RETURN 
	THIS.TEXT = ''
END IF 

IF LVL_COMPLAINTS_QTY <=0 THEN 

	f_msgbox1(126 , st_complaint_no.text )
	sle_complaints_no.setfocus( )
	RETURN 
	
END IF 


SLE_MODEL_NAME_SCAN.TEXT = LVS_MODEL_NAME
SLE_model_suffix_scan.TEXT = LVS_MODEL_SUFFIX
SLE_ITEM_CODE_SCAN.TEXT = LVS_ITEM_CODE
em_return_qty.TEXT = STRING(LVL_COMPLAINTS_QTY)

sle_pcb_serial_no.setfocus( )
end event

type st_complaint_no from statictext within w_sal_shipping_return_repair_master
integer x = 18
integer y = 308
integer width = 608
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 16777215
string text = "Complaints No"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_10 from statictext within w_sal_shipping_return_repair_master
integer x = 3826
integer y = 64
integer width = 608
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 134217745
long backcolor = 16777215
string text = "Complaint No"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_11 from statictext within w_sal_shipping_return_repair_master
integer x = 4443
integer y = 48
integer width = 608
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "PCB Serial No"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_pcb_serial_cond from so_singlelineedit within w_sal_shipping_return_repair_master
integer x = 4443
integer y = 140
integer width = 608
integer taborder = 11
boolean bringtotop = true
long backcolor = 16777215
textcase textcase = upper!
end type

type sle_complaint_no_cond from so_singlelineedit within w_sal_shipping_return_repair_master
integer x = 3826
integer y = 140
integer width = 608
integer taborder = 21
boolean bringtotop = true
long backcolor = 16777215
textcase textcase = upper!
end type

type sle_model_name_scan from so_singlelineedit within w_sal_shipping_return_repair_master
integer x = 1253
integer y = 388
integer width = 608
integer taborder = 21
boolean bringtotop = true
long backcolor = 16777215
boolean enabled = false
textcase textcase = upper!
boolean displayonly = true
end type

type sle_model_suffix_scan from so_singlelineedit within w_sal_shipping_return_repair_master
integer x = 1870
integer y = 388
integer width = 384
integer taborder = 31
boolean bringtotop = true
long backcolor = 16777215
boolean enabled = false
textcase textcase = upper!
boolean displayonly = true
end type

type st_12 from statictext within w_sal_shipping_return_repair_master
integer x = 1253
integer y = 308
integer width = 603
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 16777215
string text = "Model Name"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_13 from statictext within w_sal_shipping_return_repair_master
integer x = 1865
integer y = 308
integer width = 384
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 16777215
string text = "Model Suffix"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_item_code_scan from so_singlelineedit within w_sal_shipping_return_repair_master
integer x = 2258
integer y = 388
integer width = 649
integer taborder = 41
boolean bringtotop = true
long backcolor = 16777215
boolean enabled = false
textcase textcase = upper!
boolean displayonly = true
end type

type st_14 from statictext within w_sal_shipping_return_repair_master
integer x = 2258
integer y = 308
integer width = 649
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 16777215
string text = "Item Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_return_qty from so_editmask within w_sal_shipping_return_repair_master
integer x = 2921
integer y = 388
integer taborder = 50
boolean bringtotop = true
long backcolor = 16777215
end type

type st_9 from statictext within w_sal_shipping_return_repair_master
integer x = 2921
integer y = 300
integer width = 402
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 16777215
string text = "Return Qty"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from so_groupbox within w_sal_shipping_return_repair_master
integer y = 1620
integer width = 576
integer height = 728
integer weight = 700
long textcolor = 8421504
long backcolor = 16777215
string text = "Issue"
end type

type gb_4 from so_groupbox within w_sal_shipping_return_repair_master
integer width = 608
integer height = 244
integer weight = 700
long textcolor = 8421504
long backcolor = 16777215
string text = "Category"
end type

type gb_5 from so_groupbox within w_sal_shipping_return_repair_master
integer y = 248
integer width = 3374
integer height = 244
integer taborder = 40
integer weight = 700
long textcolor = 8421504
long backcolor = 16777215
string text = "Scan Process"
end type

type gb_6 from so_groupbox within w_sal_shipping_return_repair_master
integer y = 504
integer width = 576
integer height = 328
integer taborder = 30
integer weight = 700
long textcolor = 8421504
long backcolor = 16777215
string text = "Process"
end type

