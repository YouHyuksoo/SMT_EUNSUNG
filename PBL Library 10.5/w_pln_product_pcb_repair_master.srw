HA$PBExportHeader$w_pln_product_pcb_repair_master.srw
$PBExportComments$Line Master
forward
global type w_pln_product_pcb_repair_master from w_main_root
end type
type sle_pcb_serial_no from so_singlelineedit within w_pln_product_pcb_repair_master
end type
type st_2 from so_statictext within w_pln_product_pcb_repair_master
end type
type ddlb_line_code from uo_line_code within w_pln_product_pcb_repair_master
end type
type st_3 from so_statictext within w_pln_product_pcb_repair_master
end type
type uo_dateset from uo_ymd_calendar within w_pln_product_pcb_repair_master
end type
type st_5 from so_statictext within w_pln_product_pcb_repair_master
end type
type uo_dateend from uo_ymd_calendar within w_pln_product_pcb_repair_master
end type
type gb_2 from so_groupbox within w_pln_product_pcb_repair_master
end type
type cb_1 from so_commandbutton within w_pln_product_pcb_repair_master
end type
type cb_save from so_commandbutton within w_pln_product_pcb_repair_master
end type
type cb_issue from so_commandbutton within w_pln_product_pcb_repair_master
end type
type cb_5 from so_commandbutton within w_pln_product_pcb_repair_master
end type
type ddlb_workstage_code from uo_workstage_code_all within w_pln_product_pcb_repair_master
end type
type st_1 from so_statictext within w_pln_product_pcb_repair_master
end type
type ddlb_receipt_deficit from uo_basecode within w_pln_product_pcb_repair_master
end type
type st_7 from so_statictext within w_pln_product_pcb_repair_master
end type
type cb_6 from so_commandbutton within w_pln_product_pcb_repair_master
end type
type cb_10 from so_commandbutton within w_pln_product_pcb_repair_master
end type
type rb_repair_receipt from so_radiobutton within w_pln_product_pcb_repair_master
end type
type rb_history from so_radiobutton within w_pln_product_pcb_repair_master
end type
type ddlb_repair_result_code from uo_basecode within w_pln_product_pcb_repair_master
end type
type st_8 from so_statictext within w_pln_product_pcb_repair_master
end type
type ddlb_model_name from uo_set_model_name_ddlb within w_pln_product_pcb_repair_master
end type
type st_4 from so_statictext within w_pln_product_pcb_repair_master
end type
type sle_issue_pid from so_singlelineedit within w_pln_product_pcb_repair_master
end type
type st_6 from so_statictext within w_pln_product_pcb_repair_master
end type
type ddlb_1 from uo_line_code within w_pln_product_pcb_repair_master
end type
type ddlb_2 from uo_workstage_code_all within w_pln_product_pcb_repair_master
end type
type sle_workstage_type from so_singlelineedit within w_pln_product_pcb_repair_master
end type
type st_9 from so_statictext within w_pln_product_pcb_repair_master
end type
type st_10 from so_statictext within w_pln_product_pcb_repair_master
end type
type st_11 from so_statictext within w_pln_product_pcb_repair_master
end type
type ddlb_bad_reason from uo_code_master within w_pln_product_pcb_repair_master
end type
type dw_6 from so_datawindow within w_pln_product_pcb_repair_master
end type
type dw_7 from so_datawindow within w_pln_product_pcb_repair_master
end type
type cb_2 from so_commandbutton within w_pln_product_pcb_repair_master
end type
type cb_3 from so_commandbutton within w_pln_product_pcb_repair_master
end type
type gb_1 from so_groupbox within w_pln_product_pcb_repair_master
end type
type gb_4 from so_groupbox within w_pln_product_pcb_repair_master
end type
type gb_5 from so_groupbox within w_pln_product_pcb_repair_master
end type
type gb_6 from so_groupbox within w_pln_product_pcb_repair_master
end type
type gb_7 from so_groupbox within w_pln_product_pcb_repair_master
end type
type ln_1 from line within w_pln_product_pcb_repair_master
end type
end forward

global type w_pln_product_pcb_repair_master from w_main_root
integer width = 6569
integer height = 3720
string title = "WQC Repair Master(PID)"
sle_pcb_serial_no sle_pcb_serial_no
st_2 st_2
ddlb_line_code ddlb_line_code
st_3 st_3
uo_dateset uo_dateset
st_5 st_5
uo_dateend uo_dateend
gb_2 gb_2
cb_1 cb_1
cb_save cb_save
cb_issue cb_issue
cb_5 cb_5
ddlb_workstage_code ddlb_workstage_code
st_1 st_1
ddlb_receipt_deficit ddlb_receipt_deficit
st_7 st_7
cb_6 cb_6
cb_10 cb_10
rb_repair_receipt rb_repair_receipt
rb_history rb_history
ddlb_repair_result_code ddlb_repair_result_code
st_8 st_8
ddlb_model_name ddlb_model_name
st_4 st_4
sle_issue_pid sle_issue_pid
st_6 st_6
ddlb_1 ddlb_1
ddlb_2 ddlb_2
sle_workstage_type sle_workstage_type
st_9 st_9
st_10 st_10
st_11 st_11
ddlb_bad_reason ddlb_bad_reason
dw_6 dw_6
dw_7 dw_7
cb_2 cb_2
cb_3 cb_3
gb_1 gb_1
gb_4 gb_4
gb_5 gb_5
gb_6 gb_6
gb_7 gb_7
ln_1 ln_1
end type
global w_pln_product_pcb_repair_master w_pln_product_pcb_repair_master

type variables
Long Lvl_row
string ivs_line_code
string ivs_workstage_code
string ivs_type
end variables

on w_pln_product_pcb_repair_master.create
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
this.cb_1=create cb_1
this.cb_save=create cb_save
this.cb_issue=create cb_issue
this.cb_5=create cb_5
this.ddlb_workstage_code=create ddlb_workstage_code
this.st_1=create st_1
this.ddlb_receipt_deficit=create ddlb_receipt_deficit
this.st_7=create st_7
this.cb_6=create cb_6
this.cb_10=create cb_10
this.rb_repair_receipt=create rb_repair_receipt
this.rb_history=create rb_history
this.ddlb_repair_result_code=create ddlb_repair_result_code
this.st_8=create st_8
this.ddlb_model_name=create ddlb_model_name
this.st_4=create st_4
this.sle_issue_pid=create sle_issue_pid
this.st_6=create st_6
this.ddlb_1=create ddlb_1
this.ddlb_2=create ddlb_2
this.sle_workstage_type=create sle_workstage_type
this.st_9=create st_9
this.st_10=create st_10
this.st_11=create st_11
this.ddlb_bad_reason=create ddlb_bad_reason
this.dw_6=create dw_6
this.dw_7=create dw_7
this.cb_2=create cb_2
this.cb_3=create cb_3
this.gb_1=create gb_1
this.gb_4=create gb_4
this.gb_5=create gb_5
this.gb_6=create gb_6
this.gb_7=create gb_7
this.ln_1=create ln_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_pcb_serial_no
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.ddlb_line_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.uo_dateset
this.Control[iCurrent+6]=this.st_5
this.Control[iCurrent+7]=this.uo_dateend
this.Control[iCurrent+8]=this.gb_2
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.cb_save
this.Control[iCurrent+11]=this.cb_issue
this.Control[iCurrent+12]=this.cb_5
this.Control[iCurrent+13]=this.ddlb_workstage_code
this.Control[iCurrent+14]=this.st_1
this.Control[iCurrent+15]=this.ddlb_receipt_deficit
this.Control[iCurrent+16]=this.st_7
this.Control[iCurrent+17]=this.cb_6
this.Control[iCurrent+18]=this.cb_10
this.Control[iCurrent+19]=this.rb_repair_receipt
this.Control[iCurrent+20]=this.rb_history
this.Control[iCurrent+21]=this.ddlb_repair_result_code
this.Control[iCurrent+22]=this.st_8
this.Control[iCurrent+23]=this.ddlb_model_name
this.Control[iCurrent+24]=this.st_4
this.Control[iCurrent+25]=this.sle_issue_pid
this.Control[iCurrent+26]=this.st_6
this.Control[iCurrent+27]=this.ddlb_1
this.Control[iCurrent+28]=this.ddlb_2
this.Control[iCurrent+29]=this.sle_workstage_type
this.Control[iCurrent+30]=this.st_9
this.Control[iCurrent+31]=this.st_10
this.Control[iCurrent+32]=this.st_11
this.Control[iCurrent+33]=this.ddlb_bad_reason
this.Control[iCurrent+34]=this.dw_6
this.Control[iCurrent+35]=this.dw_7
this.Control[iCurrent+36]=this.cb_2
this.Control[iCurrent+37]=this.cb_3
this.Control[iCurrent+38]=this.gb_1
this.Control[iCurrent+39]=this.gb_4
this.Control[iCurrent+40]=this.gb_5
this.Control[iCurrent+41]=this.gb_6
this.Control[iCurrent+42]=this.gb_7
this.Control[iCurrent+43]=this.ln_1
end on

on w_pln_product_pcb_repair_master.destroy
call super::destroy
destroy(this.sle_pcb_serial_no)
destroy(this.st_2)
destroy(this.ddlb_line_code)
destroy(this.st_3)
destroy(this.uo_dateset)
destroy(this.st_5)
destroy(this.uo_dateend)
destroy(this.gb_2)
destroy(this.cb_1)
destroy(this.cb_save)
destroy(this.cb_issue)
destroy(this.cb_5)
destroy(this.ddlb_workstage_code)
destroy(this.st_1)
destroy(this.ddlb_receipt_deficit)
destroy(this.st_7)
destroy(this.cb_6)
destroy(this.cb_10)
destroy(this.rb_repair_receipt)
destroy(this.rb_history)
destroy(this.ddlb_repair_result_code)
destroy(this.st_8)
destroy(this.ddlb_model_name)
destroy(this.st_4)
destroy(this.sle_issue_pid)
destroy(this.st_6)
destroy(this.ddlb_1)
destroy(this.ddlb_2)
destroy(this.sle_workstage_type)
destroy(this.st_9)
destroy(this.st_10)
destroy(this.st_11)
destroy(this.ddlb_bad_reason)
destroy(this.dw_6)
destroy(this.dw_7)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.gb_1)
destroy(this.gb_4)
destroy(this.gb_5)
destroy(this.gb_6)
destroy(this.gb_7)
destroy(this.ln_1)
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

sle_pcb_serial_no.setfocus()

end event

event ue_data_control;call super::ue_data_control;CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		   
			dw_3.reset()
		     dw_1.retrieve( sle_pcb_serial_no.text , gvi_organization_id )
		     dw_2.retrieve( sle_pcb_serial_no.text , gvi_organization_id )
			dw_3.RETRIEVE( ddlb_model_Name.getcode()+'%' ,  sle_pcb_serial_no.TEXT +'%' ,uo_dateset.text() , uo_dateend.text() , ddlb_receipt_deficit.getcode( )+'%' , '%' ,   ddlb_repair_result_code.getcode( )+'%' , GVI_ORGANIZATION_ID, ddlb_line_code.getcode(), ddlb_workstage_code.getcode() )

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
			dw_6.reset()
	CASE 'UPDATE'
		
		 DW_1.ACCEPTTEXT()
 
	      IF DW_1.UPDATE() < 0 OR DW_3.UPDATE() < 0 THEN
				
				ROLLBACK;	
				sle_pcb_serial_no.setfocus()
				
		ELSE
				 COMMIT;
       			 F_MSG_MDI_HELP ( F_MSG_ST(170)	 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
				sle_pcb_serial_no.setfocus()
		END IF
         
		dw_6.reset()
	CASE ELSE
END CHOOSE


end event

event open;call super::open;dw_6.settransobject(sqlca)
f_set_column_dddw( dw_6 )

dw_7.settransobject(sqlca)
f_set_column_dddw( dw_7 )
end event

type dw_5 from w_main_root`dw_5 within w_pln_product_pcb_repair_master
integer x = 1065
integer y = 360
integer height = 908
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_pln_product_pcb_repair_master
integer x = 1033
integer y = 344
integer width = 4142
integer height = 908
integer taborder = 0
end type

type dw_3 from w_main_root`dw_3 within w_pln_product_pcb_repair_master
integer x = 1033
integer y = 1068
integer width = 5335
integer height = 1232
integer taborder = 0
boolean titlebar = true
string title = "Repair History"
string dataobject = "d_pln_product_work_qc_hst"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_3::doubleclicked;call super::doubleclicked;if row < 1 then return
sle_pcb_serial_no.text = this.object.serial_no[row]
sle_pcb_serial_no.selecttext( 1, 30) 
f_retrieve()
end event

event dw_3::buttonclicked;call super::buttonclicked;IF dwo.name = 'b_show' then 
			
		if dw_3.getrow() < 1 then 
			return
		end if
		
		Long Lvl_return
		String  lvs_file_name
		
		Lvl_return = f_download_work_qc_ng_image_data ( dw_3.object.qc_date[dw_3.getrow()] , long(dw_3.object.qc_sequence[dw_3.getrow()] ) )

		if  Lvl_return > 0 then 
		
			lvs_file_name = Gvs_default_directory+"\Temp\"+ Gst_return.gvs_return[1]
			
			IF lvs_file_name = '' OR ISNULL(lvs_file_name) THEN 
				RETURN
			END IF
			
			f_shell_execute_by_extention ( Gst_return.gvs_return[1]   , '' ,Gvs_default_directory+'\Temp'  )
		else
			
		end if
		
		Changedirectory(Gvs_default_directory)
	
	
end if 
end event

type dw_2 from w_main_root`dw_2 within w_pln_product_pcb_repair_master
integer x = 5307
integer y = 344
integer width = 1070
integer height = 720
integer taborder = 0
boolean titlebar = true
string title = "Issue List"
string dataobject = "d_pln_product_work_qc_issue_lst"
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = false
boolean hsplitscroll = false
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

type dw_1 from w_main_root`dw_1 within w_pln_product_pcb_repair_master
integer x = 1033
integer y = 344
integer width = 4270
integer height = 720
integer taborder = 0
boolean titlebar = true
string title = "Receipt List"
string dataobject = "d_pln_product_work_qc_lst"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;lvl_row = currentrow
end event

event dw_1::buttonclicked;call super::buttonclicked;IF dwo.name = 'b_show' then 
			
		if dw_1.getrow() < 1 then 
			return
		end if
		
		Long Lvl_return
		String  lvs_file_name
		
		
	
		
			Lvl_return = f_download_work_qc_ng_image_data ( dw_1.object.qc_date[dw_1.getrow()] , long(dw_1.object.qc_sequence[dw_1.getrow()] ) )
	
		
		if  Lvl_return > 0 then 
		
			lvs_file_name = Gvs_default_directory+"\Temp\"+ Gst_return.gvs_return[1]
			
			IF lvs_file_name = '' OR ISNULL(lvs_file_name) THEN 
				RETURN
			END IF
			
			f_shell_execute_by_extention ( Gst_return.gvs_return[1]   , '' ,Gvs_default_directory+'\Temp'  )
		else
			
		end if
		
		Changedirectory(Gvs_default_directory)
	
	
end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_pln_product_pcb_repair_master
integer taborder = 0
end type

type sle_pcb_serial_no from so_singlelineedit within w_pln_product_pcb_repair_master
integer x = 2583
integer y = 172
integer width = 768
integer taborder = 1
boolean bringtotop = true
textcase textcase = upper!
end type

event modified;call super::modified;string lvs_serial_no ,  lvs_line_code , lvs_bad_reason_code , lvs_workstage_code , lvs_item_code , lvs_model_name  , lvs_force_input_yn
string lvs_model_suffix, lvs_operationname, lvs_location, lvs_shift_code, lvs_t_serial_no
long lvl_sequence , ll_row , lvl_lot_qty
integer lvi_count , lvi_count_magazine


if rb_repair_receipt.checked = true then 
	
		
		dw_1.reset()
		dw_2.reset()
		
		if ivs_line_code = '' or ivs_workstage_code = '' or ivs_line_code = '%' or ivs_workstage_code = '%'  then
			f_msg('Check Line','P')
			this.text = ''
			return 
		end if 
		
		lvs_serial_no = this.text 
				
		//==============================================
		//shift code 
		//==============================================
		 select f_get_work_shift_code(sysdate) 
			into :lvs_shift_code
		  from dual l; 
		
		if sqlca.sqlcode = 100 or sqlca.sqlcode < 0  then 
			lvs_shift_code = '1'
		end if 
		
		//==============================================
		// 12.21 
		// IP_PRODUCT_WORKSTAGE_IO $$HEX11$$5cb8200080bd30d120005ccd85c820007cb778c72000$$ENDHEX$$, $$HEX10$$f5ac15c815c8f4bc7cb9200000ac38c834c62000$$ENDHEX$$
		//
		//==============================================
		select line_code, workstage_code 
			into :lvs_line_code, :lvs_workstage_code 
		  from ip_product_workstage_io 
		where serial_no = :lvs_serial_no 
			and io_date  = ( select max(io_date) 
											  from ip_product_workstage_io
								  where serial_no = :lvs_serial_no ) ;

		if sqlca.sqlcode = 100 then 
			
			//==============================================
			//*PID WorkStage $$HEX12$$d0c51cc120003eccc0c92000bbba60d52000bdacb0c62000$$ENDHEX$$
			//* $$HEX8$$20c1ddd01cb420007cb778c7fcac2000$$ENDHEX$$WS $$HEX6$$7cb9200023b1b4c50cc92000$$ENDHEX$$
			//==============================================
			
		     lvs_line_code = ddlb_line_code.getcode( )
			if lvs_line_code = '' or isnull(lvs_line_code) or lvs_line_code = '%' then 
				lvs_line_code = '*'
			end if 
			
			lvs_workstage_code = ddlb_workstage_code.getcode( )
			if lvs_workstage_code = '' or isnull(lvs_workstage_code) or lvs_workstage_code = '%' then 
				lvs_workstage_code = '*'
			end if 				
		end if
		//===============================================
		// $$HEX5$$d9b3c4b3c1c069d62000$$ENDHEX$$
		 // 1. SMT $$HEX9$$f5ac15c820000fbc2000c4d6f5ac15c82000$$ENDHEX$$Routing $$HEX14$$f5ac15c8c0c998b0c0c920004ac558c544c720002000bdacb0c62000$$ENDHEX$$workstage $$HEX9$$d0c5200070b374c730d12000c6c54cc72000$$ENDHEX$$
		//    $$HEX14$$f8adf4b72000bdacb0c6200020c1ddd01cb420007cb778c7fcac2000$$ENDHEX$$workstage $$HEX4$$15c8f4bc7cb92000$$ENDHEX$$
		//==============================================	
	

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
			
				 //----------------------------------------------------------------------------------
				 // 2016/07/13 SHS, PID $$HEX4$$85c725b8dcc22000$$ENDHEX$$Barcode master $$HEX11$$55d678c72000c4d62000f8bb74c8acc72000dcc22000$$ENDHEX$$NG $$HEX2$$98ccacb9$$ENDHEX$$
				 //----------------------------------------------------------------------------------

				 lvi_count  = 0;
				lvs_force_input_yn = 'N'
				
				  select nvl(sum(1) ,0) 
					 into :lvi_count
				  from ip_product_2d_barcode
				  where organization_id = :gvi_organization_id
					 and serial_no = :lvs_serial_no
					and rownum = 1; 
					
				if f_sql_check() < 0 then 
						sle_pcb_serial_no.text = ''
						sle_pcb_serial_no.setfocus()					
				end if 
		
				if lvi_count = 0 then 
					
							  select nvl(sum(1) ,0) 
								 into :lvi_count_magazine
							  from ip_product_run_card_io
							  where magazine_label_no = :lvs_serial_no
						 and organization_id = :gvi_organization_id
								and rownum = 1; 		
								
											
							if f_sql_check() < 0 then 
									sle_pcb_serial_no.text = ''
									sle_pcb_serial_no.setfocus()					
							end if 		
							
							//=====================================
							//
							//=====================================
							
	
							
							if sqlca.sqlcode = 100  or lvi_count_magazine = 0 then 
								
								
								
								msg = messagebox('PID', f_msg('Check PID, No exist!! :','S') + lvs_serial_no +" $$HEX10$$15ac1cc85cb82000f1b45db860d54cae94c62000$$ENDHEX$$?", Question! , yesno! ) 
								if msg = 1 then 
									
									lvs_force_input_yn = 'Y'
									
								else
					
									sle_pcb_serial_no.text = ''
									sle_pcb_serial_no.setfocus()			
									return 
									
								end if 
								
							end if		
								
				end if 

				 
				//==============================================
				// 
				//  $$HEX19$$a4c294ce2000c8b9a4c230d15cb8200080bd30d12000200015c8f4bc200000ac38c834c62000$$ENDHEX$$
				//  2017.03.20  GMES $$HEX9$$00ad28b82000b4b0a9c62000adc01cc82000$$ENDHEX$$
				//==============================================
				
				
				
				if lvi_count > 0 then 
				
							select distinct  ITEM_CODE ,  MODEL_NAME  , MODEL_SUFFIX , '', ''  
							into :lvs_item_code , :lvs_model_name  , :lvs_model_suffix, :lvs_operationname ,:lvs_location			 
							from IP_PRODUCT_2D_BARCODE
						 where  serial_no = :lvs_serial_no
							 and organization_id = :gvi_organization_id ;  
							 
						if f_sql_check() < 0 then 
							return 
						end if 	 							
						
				elseif lvi_count = 0 and lvi_count_magazine > 0 then 
						
						 select distinct  ITEM_CODE ,  MODEL_NAME  , MODEL_SUFFIX , '', ''  ,  lot_qty
							into :lvs_item_code , :lvs_model_name  , :lvs_model_suffix, :lvs_operationname ,:lvs_location		 , :lvl_lot_qty	 
							from IP_PRODUCT_RUN_CARD_IO
						 where  magazine_label_no = :lvs_serial_no
							 and organization_id = :gvi_organization_id
							 and rownum = 1 ;  
							 
						if f_sql_check() < 0 then 
							return 
						end if 	 		
						
				elseif lvi_count = 0 and lvi_count_magazine = 0 and lvs_force_input_yn = 'Y' then 
						
						lvs_model_name = ddlb_model_name.getcode() 
						
						select distinct  ITEM_CODE ,  MODEL_NAME  , MODEL_SUFFIX , '', ''  
							into :lvs_item_code , :lvs_model_name  , :lvs_model_suffix, :lvs_operationname ,:lvs_location			 
							from IP_PRODUCT_MODEL_MASTER
						 where  MODEL_NAME = :lvs_model_name
							 and organization_id = :gvi_organization_id ;  
							 
						if f_sql_check() < 0 then 
							return 
						end if 	 										
				end if 
		
			f_insert()
			//===================================================
			//
			//===================================================
			
			dw_1.object.repair_line_code[lvl_row] = ivs_line_code                       //$$HEX9$$18c2acb990c7e0c258c720007cb778c72000$$ENDHEX$$
			dw_1.object.repair_workstage_code[lvl_row]   = ivs_workstage_code  //$$HEX7$$18c2acb990c7e0c2f5ac15c82000$$ENDHEX$$
			
			dw_1.object.model_name[lvl_row] = lvs_model_name
			dw_1.object.model_suffix[lvl_row] = lvs_model_suffix
			dw_1.object.item_code[lvl_row] = lvs_item_code
			dw_1.object.serial_no[lvl_row]   = lvs_serial_no
			lvs_bad_reason_code = ddlb_bad_reason.getcode()
			dw_1.object.bad_reason_code[lvl_row]  =  lvs_bad_reason_code
			  
			dw_1.object.qc_result[lvl_row]  =  'W'
			dw_1.object.line_code[lvl_row] = lvs_line_code
			dw_1.object.machine_code[lvl_row] = '*'		
			dw_1.object.workstage_code[lvl_row] = lvs_workstage_code
		
			 dw_1.object.location_code[lvl_row] = lvs_location + ' ' + lvs_operationname
		
			dw_1.object.receipt_deficit[lvl_row] = '1'
			dw_1.object.qc_inspect_handling[lvl_row] = 'W'	
			dw_1.object.qc_date[lvl_row] = f_sysdate()
			dw_1.object.charger[lvl_row] = gvs_user_id
			
			dw_1.object.shift_code[lvl_row] = lvs_shift_code
		
			dw_1.object.qc_sequence[lvl_row] = lvl_sequence
			dw_1.object.repair_by[lvl_row] = Gvs_user_id
			
			dw_1.object.bad_qty[lvl_row]    = 1
			dw_1.object.defect_qty[lvl_row] = 1
			dw_1.object.array_yn[lvl_row] = 'N'
			dw_1.object.bad_cause_by[lvl_row] = 'M' // $$HEX14$$91c7c5c588bdc9b720003cc75cb8200030aef8bc200024c115c82000$$ENDHEX$$
			
			f_update()
			//====================================
			// $$HEX23$$74c704c8d0c52000d9b37cc720005cd52000dcc2acb9bcc52000200010cde0ac200074c725b8200070c88cd62000$$ENDHEX$$
			//
			//====================================
			dw_2.retrieve(sle_pcb_serial_no.text , gvi_organization_id)		
			  
			 //====================================
			// $$HEX6$$88bdc9b7b4b0edc570c88cd6$$ENDHEX$$
			// $$HEX16$$b4c508b874c7200078c7bdacb0c62000a4b420005db090c7acb920007cb92000$$ENDHEX$$like $$HEX12$$14bcb8af94b270b32000d9b3c4b394b220001cc878c62000$$ENDHEX$$
			//====================================
			//len(sle_pcb_serial_no.text)
			//lvs_t_serial_no = mid(sle_pcb_serial_no.text, 1, len(sle_pcb_serial_no.text) - 1) + '%'
			
			dw_6.retrieve(lvs_serial_no , gvi_organization_id)    //$$HEX9$$f5ac15c82000b5d1fcac200074c725b82000$$ENDHEX$$
			dw_7.retrieve(lvs_serial_no , gvi_organization_id)	 //$$HEX14$$f5ac15c8200088bdc9b72000b4b0edc5200009000900090009000900$$ENDHEX$$
			sle_pcb_serial_no.text = ''
			sle_pcb_serial_no.setfocus()
			
else
			dw_2.retrieve(sle_pcb_serial_no.text , gvi_organization_id)		
end if 

end event

event getfocus;call super::getfocus;this.selecttext( 1,30)
end event

type st_2 from so_statictext within w_pln_product_pcb_repair_master
integer x = 2583
integer y = 72
integer width = 768
boolean bringtotop = true
long textcolor = 255
string text = "PCB Serial No"
end type

type ddlb_line_code from uo_line_code within w_pln_product_pcb_repair_master
integer x = 1467
integer y = 168
integer width = 521
integer height = 1936
boolean bringtotop = true
long backcolor = 16777215
end type

type st_3 from so_statictext within w_pln_product_pcb_repair_master
integer x = 1467
integer y = 72
integer width = 512
boolean bringtotop = true
string text = "Defect Line Code"
end type

type uo_dateset from uo_ymd_calendar within w_pln_product_pcb_repair_master
event destroy ( )
integer x = 3355
integer y = 168
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_5 from so_statictext within w_pln_product_pcb_repair_master
integer x = 3355
integer y = 72
integer width = 823
boolean bringtotop = true
string text = "QC Date"
end type

type uo_dateend from uo_ymd_calendar within w_pln_product_pcb_repair_master
event destroy ( )
integer x = 3771
integer y = 168
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type gb_2 from so_groupbox within w_pln_product_pcb_repair_master
integer x = 613
integer width = 4645
integer height = 324
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type cb_1 from so_commandbutton within w_pln_product_pcb_repair_master
integer x = 23
integer y = 800
integer width = 471
integer height = 112
boolean bringtotop = true
integer weight = 400
string text = "Bad Reason Code"
end type

event clicked;call super::clicked;
open(w_bad_reason_select_popup)

if Gst_return.gvb_return = true then 
   ddlb_bad_reason.text = Gst_return.gvs_return[1]
end if 

if dw_1.getrow( ) < 1 then 
	return 
end if 

if Gst_return.gvb_return = true then 
	
	dw_1.object.bad_reason_code[Lvl_row]  = Gst_return.gvs_return[1]
	dw_1.object.bad_qty[Lvl_row]  = Gst_return.gvl_return[1]
	dw_1.object.defect_qty[Lvl_row]  = Gst_return.gvl_return[2]

end if 

sle_pcb_serial_no.text = ''
sle_pcb_serial_no.setfocus()
end event

type cb_save from so_commandbutton within w_pln_product_pcb_repair_master
integer x = 32
integer y = 1628
integer width = 471
integer height = 144
boolean bringtotop = true
integer weight = 400
string text = "Save [F6]"
end type

event clicked;call super::clicked;f_update()
sle_pcb_serial_no.text = ''
sle_pcb_serial_no.setfocus()
end event

type cb_issue from so_commandbutton within w_pln_product_pcb_repair_master
integer x = 32
integer y = 1488
integer width = 471
integer height = 144
boolean bringtotop = true
integer weight = 400
string text = "Issue"
end type

event clicked;call super::clicked;sle_pcb_serial_no.text = ''
long lvl_sequence, lvl_count
string lvs_serial_no, lvs_line_code, lvs_workstage_code, lvs_location, lvs_comments, lvs_lcr_measure, lvs_repair_method

		if dw_1.getrow() < 1 then 
			return 
		end if 
		
		if dw_1.object.qc_inspect_handling[dw_1.getrow()] ='U' then 
			
			
			             	lvs_location     = dw_1.object.location_code[dw_1.getrow()]
						lvs_comments  = dw_1.object.comments[dw_1.getrow()]
						lvs_lcr_measure  = dw_1.object.lcr_measure[dw_1.getrow()]
						lvs_repair_method  = dw_1.object.repair_method[dw_1.getrow()]
						
						if ( isnull( lvs_location ) or trim(lvs_location) = ''  )then
							 f_msg("$$HEX4$$5cb800cf74c758c1$$ENDHEX$$($$HEX2$$04c758ce$$ENDHEX$$) $$HEX16$$44c7200018bcdcb4dcc2200085c725b8200058d554c17cc5200069d5c8b2e4b2$$ENDHEX$$","P")
							 return
						end if
						
						if ( isnull( lvs_lcr_measure ) or trim(lvs_lcr_measure) = ''  )then
							 f_msg("LCR $$HEX19$$21ce15c812ac44c7200018bcdcb4dcc2200085c725b8200058d554c17cc5200069d5c8b2e4b2$$ENDHEX$$","P")
							 return
						end if			
						
						if ( isnull( lvs_repair_method ) or trim(lvs_repair_method) = ''  )then
							 f_msg("$$HEX20$$18c2acb929bcddc244c7200018bcdcb4dcc2200085c725b8200058d554c17cc5200069d5c8b2e4b2$$ENDHEX$$","P")
							 return
						end if							

						if f_msgbox1(1161 , this.text ) = 1 THEN 
						else
							return
						end if 
						
						f_update()
						
						lvl_sequence = dw_1.object.qc_sequence[dw_1.getrow()]
						lvs_serial_no = dw_1.object.serial_no[dw_1.getrow()]
						
						//-------------------------------------------------------------------------------
						// 2016/10/27 SHS $$HEX17$$f5ac15c8b5d1fcac74c725b844c7200055d678c758d5ecc52000c6c53cc774ba2000$$ENDHEX$$message $$HEX4$$98ccacb9200068d5$$ENDHEX$$
						//-------------------------------------------------------------------------------
						
						lvs_line_code           = dw_1.object.line_code[dw_1.getrow()]
						lvs_workstage_code = dw_1.object.workstage_code[dw_1.getrow()]
						
						lvl_count = 0
												
						update ip_product_work_qc 
						      set receipt_deficit = '2' ,
								  repair_date = sysdate 
						 where serial_no = :lvs_serial_no
								and qc_sequence = :lvl_sequence
							 and organization_id = :gvi_organization_id ;
							  
						if f_sql_check() < 0 then 
							return 
						end if 
						
		//$$HEX13$$d0d330ae200098ccacb9200074c774ba20000900090009000900$$ENDHEX$$
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
			f_msg("$$HEX18$$c4d698ccacb92000b4b0a9c644c7200018bcdcb4dcc2200085c725b8200058d538c194c6$$ENDHEX$$","P")
			return 
		end if 


		commit ;
		sle_issue_pid.text = ''
		sle_issue_pid.setfocus()
		dw_1.retrieve(lvs_serial_no , gvi_organization_id)
		dw_2.retrieve(lvs_serial_no , gvi_organization_id)
		
end event

type cb_5 from so_commandbutton within w_pln_product_pcb_repair_master
integer x = 503
integer y = 1488
integer width = 471
integer height = 144
boolean bringtotop = true
integer weight = 400
string text = "Issue Cancel"
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
		           repair_date = null 
		 where serial_no = :lvs_serial_no
			  and organization_id = :gvi_organization_id ;
			  
		if f_sql_check() < 0 then 
			return 
		end if 
		
		IF lvs_qc_inspect_handling = 'D' THEN 
			 UPDATE IP_PRODUCT_2D_BARCODE
				  SET BARCODE_STATUS = 'N' 
			 WHERE SERIAL_NO = :LVS_SERIAL_NO
				  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID  ;
			 
			 IF F_SQL_CHECK() < 0 THEN 
				  RETURN 
			 END IF 
		END IF 

		commit ;
		
		dw_1.retrieve(lvs_serial_no , gvi_organization_id)
		dw_2.retrieve(lvs_serial_no , gvi_organization_id)
		
sle_pcb_serial_no.text = ''
sle_pcb_serial_no.setfocus()		
end event

type ddlb_workstage_code from uo_workstage_code_all within w_pln_product_pcb_repair_master
integer x = 1993
integer y = 168
integer width = 585
integer height = 1936
boolean bringtotop = true
end type

event selectionchanged;call super::selectionchanged;SLE_PCB_SERIAL_NO.SETFOCUS( )    
end event

type st_1 from so_statictext within w_pln_product_pcb_repair_master
integer x = 1993
integer y = 72
integer width = 585
boolean bringtotop = true
long textcolor = 0
string text = "Defect Workstage Code"
end type

type ddlb_receipt_deficit from uo_basecode within w_pln_product_pcb_repair_master
integer x = 4192
integer y = 168
integer width = 457
integer height = 1936
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw("RECEIPT DEFICIT")
end event

type st_7 from so_statictext within w_pln_product_pcb_repair_master
integer x = 4192
integer y = 72
integer width = 457
boolean bringtotop = true
string text = "Receipt Deficit"
end type

type cb_6 from so_commandbutton within w_pln_product_pcb_repair_master
integer x = 23
integer y = 900
integer width = 471
integer height = 112
boolean bringtotop = true
integer weight = 400
string text = "Repair Item"
end type

event clicked;call super::clicked;if dw_1.getrow() < 1 then return
Gst_return.gvs_return[1] = string(dw_1.object.qc_sequence[dw_1.getrow()] )
openwithparm(w_qc_repair_item_popup , '%' )
end event

type cb_10 from so_commandbutton within w_pln_product_pcb_repair_master
integer x = 503
integer y = 1628
integer width = 471
integer height = 144
boolean bringtotop = true
integer weight = 400
string text = "Excel Paste"
end type

event clicked;call super::clicked;open(w_qc_repair_receipt_excel_form_popup)
end event

type rb_repair_receipt from so_radiobutton within w_pln_product_pcb_repair_master
integer x = 69
integer y = 100
boolean bringtotop = true
string text = "Repair Receipt List"
boolean checked = true
end type

type rb_history from so_radiobutton within w_pln_product_pcb_repair_master
integer x = 73
integer y = 180
boolean bringtotop = true
string text = "Repair History"
end type

type ddlb_repair_result_code from uo_basecode within w_pln_product_pcb_repair_master
integer x = 4654
integer y = 168
integer width = 558
integer height = 1936
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'REPAIR RESULT CODE')
end event

type st_8 from so_statictext within w_pln_product_pcb_repair_master
integer x = 4654
integer y = 72
integer width = 558
boolean bringtotop = true
string text = "Repair Result Code"
end type

type ddlb_model_name from uo_set_model_name_ddlb within w_pln_product_pcb_repair_master
integer x = 654
integer y = 168
integer height = 1936
boolean bringtotop = true
end type

type st_4 from so_statictext within w_pln_product_pcb_repair_master
integer x = 658
integer y = 72
integer width = 809
boolean bringtotop = true
string text = "Model Name"
end type

type sle_issue_pid from so_singlelineedit within w_pln_product_pcb_repair_master
integer x = 137
integer y = 1372
integer width = 741
integer height = 84
integer taborder = 40
boolean bringtotop = true
end type

event modified;call super::modified; dw_1.retrieve( this.text , gvi_organization_id )
end event

type st_6 from so_statictext within w_pln_product_pcb_repair_master
integer x = 137
integer y = 1304
integer width = 741
integer height = 52
boolean bringtotop = true
long textcolor = 255
string text = "PCB Serial No"
end type

type ddlb_1 from uo_line_code within w_pln_product_pcb_repair_master
integer x = 503
integer y = 440
integer width = 457
integer height = 1916
integer taborder = 50
boolean bringtotop = true
end type

event constructor;call super::constructor;IVS_LINE_CODE = Profilestring("WORKENV.INI","LINE","WORKSTAGE_IO","")
THIS.SELECtitem(IVS_LINE_CODE )

end event

event selectionchanged;call super::selectionchanged;f_jsSetProfileString ("WORKENV.INI", "LINE", "WORKSTAGE_IO", THIS.GETCODE() )

IVS_LINE_CODE = THIS.GETCODE()
sle_pcb_serial_no.setfocus()

end event

type ddlb_2 from uo_workstage_code_all within w_pln_product_pcb_repair_master
integer x = 503
integer y = 532
integer width = 457
integer height = 1912
integer taborder = 50
boolean bringtotop = true
end type

event constructor;call super::constructor;IVS_WORKSTAGE_CODE = Profilestring("WORKENV.INI","WORKSTAGE","WORKSTAGE_IO","")
THIS.SELECtitem(IVS_WORKSTAGE_CODE )

SELECT WORKSTAGE_TYPE INTO :IVS_TYPE 
  FROM IP_PRODUCT_WORKSTAGE
 WHERE WORKSTAGE_CODE = :IVS_WORKstage_code 
      AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
		
IF F_SQL_CHECK() < 0 THEN 
	RETURN 
END IF 
		
sle_workstage_type.text  = IVS_TYPE
end event

event selectionchanged;call super::selectionchanged;//RegistrySet( "HKEY_LOCAL_MACHINE\Software\Infinity21\" +  GVS_APPLICATION_NAME, "IO_WORKSTAGE", RegString!,THIS.GETCODE())
//IVS_WORkstage_code = THIS.GETCODE()
//
//SELECT WORKSTAGE_TYPE INTO :IVS_TYPE 
//  FROM IP_PRODUCT_WORKSTAGE
// WHERE WORKSTAGE_CODE = :IVS_WORKstage_code 
//      AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
//		
//IF F_SQL_CHECK() < 0 THEN 
//	RETURN 
//END IF 
//		
//sle_workstage_type.text  = IVS_TYPE
//
//sle_pcb_serial_no.setfocus()


f_jsSetProfileString ("WORKENV.INI", "WORKSTAGE", "WORKSTAGE_IO", THIS.GETCODE() )
IVS_WORkstage_code = THIS.GETCODE()

SELECT WORKSTAGE_TYPE INTO :IVS_TYPE 
  FROM IP_PRODUCT_WORKSTAGE
 WHERE WORKSTAGE_CODE = :IVS_WORKstage_code 
      AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
		
IF F_SQL_CHECK() < 0 THEN 
	RETURN 
END IF 
		
sle_workstage_type.text  = IVS_TYPE

sle_pcb_serial_no.setfocus()


end event

type sle_workstage_type from so_singlelineedit within w_pln_product_pcb_repair_master
integer x = 370
integer y = 620
integer width = 256
integer height = 88
integer taborder = 30
boolean bringtotop = true
long backcolor = 134217750
boolean displayonly = true
end type

type st_9 from so_statictext within w_pln_product_pcb_repair_master
integer x = 55
integer y = 440
integer width = 430
boolean bringtotop = true
string text = "Repair Line code"
alignment alignment = right!
end type

type st_10 from so_statictext within w_pln_product_pcb_repair_master
integer x = 55
integer y = 632
integer width = 302
boolean bringtotop = true
string text = "WS Type"
alignment alignment = right!
end type

type st_11 from so_statictext within w_pln_product_pcb_repair_master
integer x = 55
integer y = 532
integer width = 430
boolean bringtotop = true
string text = "Repair WorkStage"
alignment alignment = right!
end type

type ddlb_bad_reason from uo_code_master within w_pln_product_pcb_repair_master
integer x = 137
integer y = 1108
integer width = 741
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw('WQC BAD REASON CODE')
end event

type dw_6 from so_datawindow within w_pln_product_pcb_repair_master
integer y = 1808
integer width = 1006
integer height = 652
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "Interlok Ng List"
string dataobject = "d_pln_product_work_qc_ng_lst"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

type dw_7 from so_datawindow within w_pln_product_pcb_repair_master
integer y = 2480
integer width = 1006
integer height = 652
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "Product Work QC List"
string dataobject = "d_qc_visual_inspect_bad_4_repair_lst"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

type cb_2 from so_commandbutton within w_pln_product_pcb_repair_master
integer x = 512
integer y = 800
integer width = 471
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer weight = 400
string text = "BOM"
end type

event clicked;call super::clicked;openwithparm( w_des_bom_query_popup , ddlb_model_name.getcode() )
end event

type cb_3 from so_commandbutton within w_pln_product_pcb_repair_master
integer x = 512
integer y = 908
integer width = 471
integer height = 112
integer taborder = 70
boolean bringtotop = true
integer weight = 400
string text = "Image"
end type

event clicked;call super::clicked;int    li_filenum , loops, i , lvi_count
long   flen, bytes_read , bytes_read_sum , new_pos
blob   lib_file , b
double lvdb_sequence
string is_filename, is_fullname  
datetime lvdt_qc_date

if  dw_1.getrow() < 1 then 
	return
end if

lvdt_qc_date  = dw_1.object.qc_date[dw_1.getrow()]
lvdb_sequence= dw_1.object.qc_sequence[dw_1.getrow()]

if  isnull(lvdt_qc_date) then 
return
end if		

if getfileopenname("select file", is_fullname, is_filename, "jpg", &
+ "jpg files (*.jpg),*.jpg," &	
+ "bmp files (*.bmp),*.bmp," &			
+ "all files (*.*), *.*") < 1 then return

flen = filelength(is_fullname)

if flen < 0 then 
	rollback;			
	f_msgbox1(9020 ,is_fullname )
	return 
end if

li_filenum = fileopen(is_fullname,  streammode!, read!, lockread!)

if li_filenum <> -1 then

	setpointer(hourglass!)
	
if flen > 32765 then

	if mod(flen, 32765) = 0 then
		loops = flen/32765
	else
		loops = (flen/32765) + 1
	end if
else
	loops = 1
end if

new_pos = 1

for i = 1 to loops
	bytes_read = fileread(li_filenum, b)
	bytes_read_sum = bytes_read_sum + bytes_read
	lib_file = lib_file + b
	f_msg_mdi_help( string(bytes_read_sum)+"/"+string(flen)+" bytes read" )
next

fileclose(li_filenum)


  INSERT INTO "IP_PRODUCT_WORK_QC_IMAGE"  
         ( "QC_DATE",   
           "QC_SEQUENCE",   
 
             "ORGANIZATION_ID",   
           "ENTER_DATE",   
           "ENTER_BY",   
           "LAST_MODIFY_DATE",   
           "LAST_MODIFY_BY" )  
  VALUES ( :lvdt_qc_date,   
           :lvdb_sequence,   
             
   
           :gvi_organization_id,   
           sysdate,   
           :gvs_user_id,   
            sysdate,   
           :gvs_user_id )  ;


		update IP_PRODUCT_WORK_QC_IMAGE 
		set ng_image_file_name = :is_filename 
		where qc_date       = :lvdt_qc_date
		and qc_sequence = :lvdb_sequence
		and organization_id = :gvi_organization_id ;
		
		if f_sql_check() < 0 then 
			return
		end if 
		
		updateblob IP_PRODUCT_WORK_QC_IMAGE set ng_image = :lib_file 
		where qc_date       = :lvdt_qc_date
		and qc_sequence    = :lvdb_sequence
		and organization_id = :gvi_organization_id ;
		if f_sql_check() < 0 then 
			return
		end if 		
	commit ;
	f_msgbox(9022)

end if
changedirectory(gvs_default_directory)
end event

type gb_1 from so_groupbox within w_pln_product_pcb_repair_master
integer y = 1236
integer width = 1015
integer height = 572
integer weight = 700
long textcolor = 16711680
string text = "Issue"
end type

type gb_4 from so_groupbox within w_pln_product_pcb_repair_master
integer width = 608
integer height = 324
integer weight = 700
string text = "Category"
end type

type gb_5 from so_groupbox within w_pln_product_pcb_repair_master
integer y = 1036
integer width = 1015
integer height = 192
integer taborder = 40
integer weight = 700
long textcolor = 16711680
string text = "Bad Reason Code"
end type

type gb_6 from so_groupbox within w_pln_product_pcb_repair_master
integer y = 344
integer width = 1015
integer height = 384
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Repair Workstage"
end type

type gb_7 from so_groupbox within w_pln_product_pcb_repair_master
integer y = 736
integer width = 1015
integer height = 296
integer taborder = 50
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type ln_1 from line within w_pln_product_pcb_repair_master
long linecolor = 33554432
integer linethickness = 4
integer beginx = 91
integer beginy = 436
integer endx = 421
integer endy = 612
end type

