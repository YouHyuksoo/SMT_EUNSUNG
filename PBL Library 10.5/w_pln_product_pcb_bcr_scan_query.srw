HA$PBExportHeader$w_pln_product_pcb_bcr_scan_query.srw
$PBExportComments$Line Master
forward
global type w_pln_product_pcb_bcr_scan_query from w_main_root
end type
type st_mrm_no from so_statictext within w_pln_product_pcb_bcr_scan_query
end type
type sle_run_no from so_singlelineedit within w_pln_product_pcb_bcr_scan_query
end type
type sle_pcb_serial_no from so_singlelineedit within w_pln_product_pcb_bcr_scan_query
end type
type st_2 from so_statictext within w_pln_product_pcb_bcr_scan_query
end type
type ddlb_line_code from uo_line_code within w_pln_product_pcb_bcr_scan_query
end type
type st_3 from so_statictext within w_pln_product_pcb_bcr_scan_query
end type
type st_6 from so_statictext within w_pln_product_pcb_bcr_scan_query
end type
type ddlb_workstage_code from uo_workstage_code_all within w_pln_product_pcb_bcr_scan_query
end type
type st_1 from so_statictext within w_pln_product_pcb_bcr_scan_query
end type
type ddlb_is_last_yn from uo_basecode within w_pln_product_pcb_bcr_scan_query
end type
type st_4 from so_statictext within w_pln_product_pcb_bcr_scan_query
end type
type ddlb_model_name from uo_set_model_name_ddlb within w_pln_product_pcb_bcr_scan_query
end type
type st_5 from so_statictext within w_pln_product_pcb_bcr_scan_query
end type
type rb_list from so_radiobutton within w_pln_product_pcb_bcr_scan_query
end type
type rb_matrix from so_radiobutton within w_pln_product_pcb_bcr_scan_query
end type
type rb_check from so_radiobutton within w_pln_product_pcb_bcr_scan_query
end type
type ddlb_result from uo_basecode within w_pln_product_pcb_bcr_scan_query
end type
type st_7 from so_statictext within w_pln_product_pcb_bcr_scan_query
end type
type rb_pass_rate from so_radiobutton within w_pln_product_pcb_bcr_scan_query
end type
type rb_distinct_list from so_radiobutton within w_pln_product_pcb_bcr_scan_query
end type
type cb_2 from so_commandbutton within w_pln_product_pcb_bcr_scan_query
end type
type cb_3 from so_commandbutton within w_pln_product_pcb_bcr_scan_query
end type
type ddlb_dest_workstage_code from uo_workstage_code_all within w_pln_product_pcb_bcr_scan_query
end type
type st_9 from so_statictext within w_pln_product_pcb_bcr_scan_query
end type
type em_time_term from so_editmask within w_pln_product_pcb_bcr_scan_query
end type
type st_10 from so_statictext within w_pln_product_pcb_bcr_scan_query
end type
type ddlb_dest_machine_code from uo_machine_code within w_pln_product_pcb_bcr_scan_query
end type
type st_11 from so_statictext within w_pln_product_pcb_bcr_scan_query
end type
type ddlb_customer_code from uo_customer_code_name within w_pln_product_pcb_bcr_scan_query
end type
type st_12 from statictext within w_pln_product_pcb_bcr_scan_query
end type
type uo_dateset from uo_ymdh_calendar within w_pln_product_pcb_bcr_scan_query
end type
type uo_dateend from uo_ymdh_calendar within w_pln_product_pcb_bcr_scan_query
end type
type cb_4 from so_commandbutton within w_pln_product_pcb_bcr_scan_query
end type
type cb_5 from so_commandbutton within w_pln_product_pcb_bcr_scan_query
end type
type sle_mapping_label from so_singlelineedit within w_pln_product_pcb_bcr_scan_query
end type
type st_mapping_label from so_statictext within w_pln_product_pcb_bcr_scan_query
end type
type gb_1 from so_groupbox within w_pln_product_pcb_bcr_scan_query
end type
type gb_2 from so_groupbox within w_pln_product_pcb_bcr_scan_query
end type
type gb_3 from so_groupbox within w_pln_product_pcb_bcr_scan_query
end type
end forward

global type w_pln_product_pcb_bcr_scan_query from w_main_root
integer width = 6377
integer height = 3248
string title = ""
st_mrm_no st_mrm_no
sle_run_no sle_run_no
sle_pcb_serial_no sle_pcb_serial_no
st_2 st_2
ddlb_line_code ddlb_line_code
st_3 st_3
st_6 st_6
ddlb_workstage_code ddlb_workstage_code
st_1 st_1
ddlb_is_last_yn ddlb_is_last_yn
st_4 st_4
ddlb_model_name ddlb_model_name
st_5 st_5
rb_list rb_list
rb_matrix rb_matrix
rb_check rb_check
ddlb_result ddlb_result
st_7 st_7
rb_pass_rate rb_pass_rate
rb_distinct_list rb_distinct_list
cb_2 cb_2
cb_3 cb_3
ddlb_dest_workstage_code ddlb_dest_workstage_code
st_9 st_9
em_time_term em_time_term
st_10 st_10
ddlb_dest_machine_code ddlb_dest_machine_code
st_11 st_11
ddlb_customer_code ddlb_customer_code
st_12 st_12
uo_dateset uo_dateset
uo_dateend uo_dateend
cb_4 cb_4
cb_5 cb_5
sle_mapping_label sle_mapping_label
st_mapping_label st_mapping_label
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_pln_product_pcb_bcr_scan_query w_pln_product_pcb_bcr_scan_query

type variables
Long Lvl_row 
String lvs_current_array_type , lvs_last_run_no
String lvs_user_line_code  , lvs_user_machine_code
end variables

on w_pln_product_pcb_bcr_scan_query.create
int iCurrent
call super::create
this.st_mrm_no=create st_mrm_no
this.sle_run_no=create sle_run_no
this.sle_pcb_serial_no=create sle_pcb_serial_no
this.st_2=create st_2
this.ddlb_line_code=create ddlb_line_code
this.st_3=create st_3
this.st_6=create st_6
this.ddlb_workstage_code=create ddlb_workstage_code
this.st_1=create st_1
this.ddlb_is_last_yn=create ddlb_is_last_yn
this.st_4=create st_4
this.ddlb_model_name=create ddlb_model_name
this.st_5=create st_5
this.rb_list=create rb_list
this.rb_matrix=create rb_matrix
this.rb_check=create rb_check
this.ddlb_result=create ddlb_result
this.st_7=create st_7
this.rb_pass_rate=create rb_pass_rate
this.rb_distinct_list=create rb_distinct_list
this.cb_2=create cb_2
this.cb_3=create cb_3
this.ddlb_dest_workstage_code=create ddlb_dest_workstage_code
this.st_9=create st_9
this.em_time_term=create em_time_term
this.st_10=create st_10
this.ddlb_dest_machine_code=create ddlb_dest_machine_code
this.st_11=create st_11
this.ddlb_customer_code=create ddlb_customer_code
this.st_12=create st_12
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.cb_4=create cb_4
this.cb_5=create cb_5
this.sle_mapping_label=create sle_mapping_label
this.st_mapping_label=create st_mapping_label
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_mrm_no
this.Control[iCurrent+2]=this.sle_run_no
this.Control[iCurrent+3]=this.sle_pcb_serial_no
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.ddlb_line_code
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.st_6
this.Control[iCurrent+8]=this.ddlb_workstage_code
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.ddlb_is_last_yn
this.Control[iCurrent+11]=this.st_4
this.Control[iCurrent+12]=this.ddlb_model_name
this.Control[iCurrent+13]=this.st_5
this.Control[iCurrent+14]=this.rb_list
this.Control[iCurrent+15]=this.rb_matrix
this.Control[iCurrent+16]=this.rb_check
this.Control[iCurrent+17]=this.ddlb_result
this.Control[iCurrent+18]=this.st_7
this.Control[iCurrent+19]=this.rb_pass_rate
this.Control[iCurrent+20]=this.rb_distinct_list
this.Control[iCurrent+21]=this.cb_2
this.Control[iCurrent+22]=this.cb_3
this.Control[iCurrent+23]=this.ddlb_dest_workstage_code
this.Control[iCurrent+24]=this.st_9
this.Control[iCurrent+25]=this.em_time_term
this.Control[iCurrent+26]=this.st_10
this.Control[iCurrent+27]=this.ddlb_dest_machine_code
this.Control[iCurrent+28]=this.st_11
this.Control[iCurrent+29]=this.ddlb_customer_code
this.Control[iCurrent+30]=this.st_12
this.Control[iCurrent+31]=this.uo_dateset
this.Control[iCurrent+32]=this.uo_dateend
this.Control[iCurrent+33]=this.cb_4
this.Control[iCurrent+34]=this.cb_5
this.Control[iCurrent+35]=this.sle_mapping_label
this.Control[iCurrent+36]=this.st_mapping_label
this.Control[iCurrent+37]=this.gb_1
this.Control[iCurrent+38]=this.gb_2
this.Control[iCurrent+39]=this.gb_3
end on

on w_pln_product_pcb_bcr_scan_query.destroy
call super::destroy
destroy(this.st_mrm_no)
destroy(this.sle_run_no)
destroy(this.sle_pcb_serial_no)
destroy(this.st_2)
destroy(this.ddlb_line_code)
destroy(this.st_3)
destroy(this.st_6)
destroy(this.ddlb_workstage_code)
destroy(this.st_1)
destroy(this.ddlb_is_last_yn)
destroy(this.st_4)
destroy(this.ddlb_model_name)
destroy(this.st_5)
destroy(this.rb_list)
destroy(this.rb_matrix)
destroy(this.rb_check)
destroy(this.ddlb_result)
destroy(this.st_7)
destroy(this.rb_pass_rate)
destroy(this.rb_distinct_list)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.ddlb_dest_workstage_code)
destroy(this.st_9)
destroy(this.em_time_term)
destroy(this.st_10)
destroy(this.ddlb_dest_machine_code)
destroy(this.st_11)
destroy(this.ddlb_customer_code)
destroy(this.st_12)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.cb_4)
destroy(this.cb_5)
destroy(this.sle_mapping_label)
destroy(this.st_mapping_label)
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


end event

event ue_data_control;call super::ue_data_control;CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		           if rb_list.checked = true then	
					    
						DW_1.RETRIEVE( ddlb_line_code.getcode()+'%' ,  ddlb_workstage_code.getcode( )+'%' ,   SLE_RUN_NO.text+'%' ,  ddlb_model_name.getcode( )+'%' ,   sle_pcb_serial_no.text+'%' ,  uo_dateset.text() , uo_dateend.text() ,  ddlb_is_last_yn.getcode()+'%' , ddlb_result.getcode( )+'%' ,   ddlb_customer_code.getcode( )+'%' ,     GVI_ORGANIZATION_ID )
					
					elseif rb_matrix.checked = true then 			
						DW_2.RETRIEVE( ddlb_line_code.getcode()+'%' ,  ddlb_workstage_code.getcode( )+'%' ,   SLE_RUN_NO.text+'%' ,  ddlb_model_name.getcode( )+'%' ,   sle_pcb_serial_no.text+'%' ,  uo_dateset.text() , uo_dateend.text() ,  ddlb_is_last_yn.getcode()+'%' , GVI_ORGANIZATION_ID )			
					
					elseif rb_check.checked = true then 
						//DW_3.RETRIEVE( ddlb_line_code.getcode()+'%' ,  ddlb_workstage_code.getcode( )+'%' ,   SLE_RUN_NO.text+'%' ,  ddlb_model_name.getcode( )+'%' ,   sle_pcb_serial_no.text+'%' ,  uo_dateset.text() , uo_dateend.text() ,  ddlb_is_last_yn.getcode()+'%' , GVI_ORGANIZATION_ID )			
						  DW_3.RETRIEVE( uo_dateset.text() , ddlb_line_code.getcode()+'%' , ddlb_model_name.getcode( )+'%' , ddlb_workstage_code.getcode( )+'%' ,  GVI_ORGANIZATION_ID )			
						  f_set_column_dddw(dw_3)
						  
				    elseif rb_pass_rate.checked = true then 
						DW_4.RETRIEVE( ddlb_line_code.getcode()+'%' ,  ddlb_model_name.getcode( )+'%' ,uo_dateset.text() , uo_dateend.text() ,  GVI_ORGANIZATION_ID )			
					else 
						DW_5.RETRIEVE( ddlb_line_code.getcode()+'%' ,  ddlb_workstage_code.getcode( )+'%' ,   SLE_RUN_NO.text+'%' ,  ddlb_model_name.getcode( )+'%' ,   sle_pcb_serial_no.text+'%' ,  uo_dateset.text() , uo_dateend.text() ,  ddlb_is_last_yn.getcode()+'%' , ddlb_result.getcode( )+'%' ,   GVI_ORGANIZATION_ID )
					end if
	CASE 'UPDATE' 
			DW_1.UPDATE()
			COMMIT ;
	CASE ELSE
	
END CHOOSE
end event

type dw_5 from w_main_root`dw_5 within w_pln_product_pcb_bcr_scan_query
integer y = 496
integer width = 4256
integer height = 1932
integer taborder = 0
boolean titlebar = true
string title = "Distinct List"
string dataobject = "iq_interlock_check_distinct_result_lst"
boolean controlmenu = true
end type

type dw_4 from w_main_root`dw_4 within w_pln_product_pcb_bcr_scan_query
integer y = 496
integer width = 4256
integer height = 1932
integer taborder = 0
boolean titlebar = true
string dataobject = "iq_interlock_check_result_pass_rate_matrix"
end type

type dw_3 from w_main_root`dw_3 within w_pln_product_pcb_bcr_scan_query
string tag = "iq_interlock_check_result_check_matrix"
integer y = 496
integer width = 4256
integer height = 1932
integer taborder = 0
boolean titlebar = true
string dataobject = "d_ip_product_interlock_data_4_result_rpt"
end type

type dw_2 from w_main_root`dw_2 within w_pln_product_pcb_bcr_scan_query
integer y = 496
integer width = 4256
integer height = 1932
integer taborder = 0
boolean titlebar = true
string dataobject = "iq_interlock_check_result_matrix"
end type

type dw_1 from w_main_root`dw_1 within w_pln_product_pcb_bcr_scan_query
integer y = 496
integer width = 5111
integer height = 1932
integer taborder = 0
boolean titlebar = true
string title = "Interlock Check Result"
string dataobject = "iq_interlock_check_result_lst"
end type

event dw_1::clicked;call super::clicked;SLE_RUN_NO.SETFOCUS()
end event

type uo_tabpages from w_main_root`uo_tabpages within w_pln_product_pcb_bcr_scan_query
integer taborder = 0
end type

type st_mrm_no from so_statictext within w_pln_product_pcb_bcr_scan_query
integer x = 2423
integer y = 80
integer width = 430
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Run No"
end type

type sle_run_no from so_singlelineedit within w_pln_product_pcb_bcr_scan_query
integer x = 2414
integer y = 160
integer width = 430
integer height = 84
integer taborder = 10
boolean bringtotop = true
textcase textcase = upper!
end type

type sle_pcb_serial_no from so_singlelineedit within w_pln_product_pcb_bcr_scan_query
integer x = 3502
integer y = 160
integer width = 544
integer height = 84
integer taborder = 50
boolean bringtotop = true
textcase textcase = upper!
end type

type st_2 from so_statictext within w_pln_product_pcb_bcr_scan_query
integer x = 3502
integer y = 84
integer width = 544
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "PCB Serial No"
end type

type ddlb_line_code from uo_line_code within w_pln_product_pcb_bcr_scan_query
integer x = 1417
integer y = 160
integer width = 471
boolean bringtotop = true
long backcolor = 16777215
end type

event selectionchanged;call super::selectionchanged;RegistrySet( "HKEY_LOCAL_MACHINE\Software\Infinity21\"+GVS_APPLICATION_NAME, "APP_USER_LINE", RegString!, STRING(this.getcode()))	

sle_run_no.setfocus()
end event

type st_3 from so_statictext within w_pln_product_pcb_bcr_scan_query
integer x = 1422
integer y = 76
integer width = 462
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Line Code"
end type

type st_6 from so_statictext within w_pln_product_pcb_bcr_scan_query
integer x = 4064
integer y = 72
integer width = 1088
integer height = 68
boolean bringtotop = true
string text = "Receipt Date"
end type

type ddlb_workstage_code from uo_workstage_code_all within w_pln_product_pcb_bcr_scan_query
integer x = 1897
integer y = 160
integer width = 512
integer height = 1752
integer taborder = 20
boolean bringtotop = true
end type

type st_1 from so_statictext within w_pln_product_pcb_bcr_scan_query
integer x = 1906
integer y = 72
integer width = 512
integer height = 76
boolean bringtotop = true
integer weight = 700
string text = "Workstage Code"
end type

type ddlb_is_last_yn from uo_basecode within w_pln_product_pcb_bcr_scan_query
integer x = 5230
integer y = 156
integer width = 288
integer taborder = 100
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'IS LAST YN')
end event

type st_4 from so_statictext within w_pln_product_pcb_bcr_scan_query
integer x = 5234
integer y = 72
integer width = 288
integer height = 68
boolean bringtotop = true
string text = "Is Last YN"
end type

type ddlb_model_name from uo_set_model_name_ddlb within w_pln_product_pcb_bcr_scan_query
integer x = 2853
integer y = 160
integer width = 645
integer height = 2368
integer taborder = 200
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
boolean hscrollbar = false
end type

type st_5 from so_statictext within w_pln_product_pcb_bcr_scan_query
integer x = 2853
integer y = 84
integer width = 645
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Model Name"
end type

type rb_list from so_radiobutton within w_pln_product_pcb_bcr_scan_query
integer x = 37
integer y = 68
integer width = 640
boolean bringtotop = true
string text = "Interlock List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
selected_data_window = dw_1
end event

type rb_matrix from so_radiobutton within w_pln_product_pcb_bcr_scan_query
integer x = 37
integer y = 140
integer width = 640
boolean bringtotop = true
string text = "Interlock Matrix"
end type

event clicked;call super::clicked;dw_2.bringtotop = true
selected_data_window = dw_2
end event

type rb_check from so_radiobutton within w_pln_product_pcb_bcr_scan_query
integer x = 37
integer y = 208
integer width = 640
boolean bringtotop = true
string text = "Interlock Check Matrix"
end type

event clicked;call super::clicked;dw_3.bringtotop = true
selected_data_window = dw_3
end event

type ddlb_result from uo_basecode within w_pln_product_pcb_bcr_scan_query
integer x = 5527
integer y = 156
integer width = 325
integer taborder = 150
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'RESULT')
end event

type st_7 from so_statictext within w_pln_product_pcb_bcr_scan_query
integer x = 5527
integer y = 68
integer width = 325
integer height = 68
boolean bringtotop = true
string text = "Result"
end type

type rb_pass_rate from so_radiobutton within w_pln_product_pcb_bcr_scan_query
integer x = 37
integer y = 288
integer width = 640
boolean bringtotop = true
string text = "Interlock Pass Rate"
end type

event clicked;call super::clicked;dw_4.bringtotop = true
selected_data_window = dw_4
end event

type rb_distinct_list from so_radiobutton within w_pln_product_pcb_bcr_scan_query
integer x = 37
integer y = 368
integer width = 640
boolean bringtotop = true
string text = "Interlock Distinct  List"
end type

event clicked;call super::clicked;dw_5.bringtotop = true
selected_data_window = dw_5
end event

type cb_2 from so_commandbutton within w_pln_product_pcb_bcr_scan_query
boolean visible = false
integer x = 5147
integer y = 500
integer width = 421
integer height = 148
integer taborder = 110
boolean bringtotop = true
string text = "Make Maching"
end type

event clicked;call super::clicked;//string 	lvs_line_code , lvs_serial_no ,lvs_machine_code , lvs_item_code , lvs_model_name , lvs_pcb_item
//datetime lvs_receipt_date
//long i  , lvi_count
//DO
//	
//	
//	i++
//	 sle_reason.text = string(i)
//	 
//	lvs_line_code = dw_1.object.line_code[i]
//	lvs_serial_no= dw_1.object.serial_no[i]
//	lvs_machine_code= dw_1.object.machine_code[i]
//	lvs_receipt_date= dw_1.object.receipt_date[i]
//	lvs_item_code = dw_1.object.item_code[i]
//	lvs_model_name= dw_1.object.model_name[i]
//    lvs_pcb_item= dw_1.object.pcb_item[i]
//	
//	select count(*) into :lvi_count 
//	  from ip_prod_material_tracking_kfc
//	where p_pcb = :lvs_serial_no
//	    and p_prog = :lvs_line_code 
//		and p_status = :lvs_pcb_item  ;
//	
//	if f_sql_check() < 0 then 
//		return 
//	end if 
//	
//	if lvi_count > 1 then 
//		continue 
//	end if 
//	
//	 INSERT INTO ip_prod_material_tracking_kfc (p_pcb,
//                                               p_kefilot,
//                                               p_material,
//                                               m_material,
//                                               p_prog,
//                                               p_equip,
//                                               p_process_time,
//                                               p_status)
//        SELECT   :lvs_serial_no,
//					a.lot_no,
//					:lvs_item_code,
//					a.partname,
//					a.line_code,
//					:lvs_machine_code,
//					:lvs_receipt_date,
//					a.pcb_item
//          FROM   ib_smt_checkhist a
//         WHERE   (a.check_date, a.line_code, a.lot_name, a.pcb_item, a.location_code) IN
//			
//                       (  SELECT   MAX (check_date),
//									line_code,
//									lot_name,
//									pcb_item,
//									location_code
//                               FROM ib_smt_checkhist
//                             WHERE check_date <= :lvs_receipt_date
//						       AND line_code     = :lvs_line_code
//                                  AND lot_name      = :lvs_model_name
//                                  AND check_type IN (1, 2)
//
//                         GROUP BY line_code,
//									lot_name,
//									pcb_item,
//									location_code
//					    )
//						
//             AND a.check_type IN (1, 2)
//             AND a.line_code  = :lvs_line_code
//             AND a.lot_name  = :lvs_model_name ;
//				 
//			if f_sql_check() < 0 then 
//				return 
//			end if 
//		  COMMIT ;
//		  
//LOOP UNTIL i = DW_1.ROWCOUNT() 
end event

type cb_3 from so_commandbutton within w_pln_product_pcb_bcr_scan_query
boolean visible = false
integer x = 5161
integer y = 812
integer width = 421
integer height = 148
integer taborder = 160
boolean bringtotop = true
string text = "Make History"
end type

event clicked;call super::clicked;long i  , lvi_time  , LVI_EXISTS
string LVS_LINE_CODE , lvs_serial_no , lvs_dest_workstage_code ,lvs_workstage_code ,  lvs_dest_machine_code , lvs_is_last_yn

lvs_dest_workstage_code = ddlb_dest_workstage_code.getcode()
lvs_dest_machine_code    = ddlb_dest_machine_code.getcode()

lvi_time  = Long( em_time_term.text )

DO 
	
  i++	
  
		lvs_is_last_yn = dw_1.OBject.is_last_yn[i]
		
		if lvs_is_last_yn = 'Y' then
		else
			continue 
		end if 
		
		lvs_serial_no = DW_1.OBject.serial_no[i]
		lvs_line_code = dw_1.object.line_code[i]
		lvs_workstage_code = dw_1.object.workstage_code[i]
		
		 SELECT COUNT(*) INTO :LVI_EXISTS 
			FROM IQ_INTERLOCK_CHECK_RESULT
			WHERE SERIAL_NO = :LVS_SERIAL_no
			  AND  LINE_CODE = :LVS_LINE_CODE
			  AND  WORKSTAGE_CODE = :LVS_DEST_workstage_code ;
			  
			 IF F_SQL_CHECK() < 0 THEN 
				RETURN 
			 END IF 
	 
	IF LVI_EXISTS > 0 THEN 
		
//		UPDATE IQ_INTERLOCK_CHECK_RESULT SET RECEIPT_DATE = RECEIPT_DATE +  :lvi_time / 24 / 60 
//		WHERE  SERIAL_NO = :LVS_SERIAL_no
//		AND  LINE_CODE = :LVS_LINE_CODE
//		AND  WORKSTAGE_CODE = :LVS_DEST_workstage_code ;
		
		
		CONTINUE 
	END IF 
	
  INSERT INTO IQ_INTERLOCK_CHECK_RESULT  
         ( RECEIPT_DATE,   
           ITEM_CODE,   
           SERIAL_NO,   
           LINE_CODE,   
           WORKSTAGE_CODE,   
           MACHINE_CODE,   
           CHECK_RESULT,   
           ENTER_DATE,   
           ENTER_BY,   
           LAST_MODIFY_DATE,   
           LAST_MODIFY_BY,   
           ORGANIZATION_ID,   
           RUN_NO,   
           MAGAZINE_NO,   
           MODEL_NAME,   
           PCB_ITEM,   
           IS_LAST_YN,   
           CHILD_ITEM_CODE,   
           CUSTOMER_MODEL_NAME,   
           PART_NO,   
           EC_NO,   
           FORCE_PASS_MESSAGE,   
           FORCE_PASS_DATE,   
           FORCE_PASS_BY,   
           BAD_REASON_COMMENTS,   
           BAD_REASON_CODE,   
           MAPPING_LABEL,   
           ORIGIN_ITEM_CODE,   
           DEBUG_LOG )  
			  
     SELECT RECEIPT_DATE +  :lvi_time / 24 / 60 ,
            ITEM_CODE,   
            SERIAL_NO,   
            LINE_CODE,   
            :lvs_dest_workstage_code ,
            :lvs_dest_machine_code ,
            CHECK_RESULT,   
            ENTER_DATE,   
            ENTER_BY,   
            LAST_MODIFY_DATE,   
            LAST_MODIFY_BY,   
            ORGANIZATION_ID,   
            RUN_NO,   
            MAGAZINE_NO,   
            MODEL_NAME,   
            PCB_ITEM,   
            IS_LAST_YN,   
            CHILD_ITEM_CODE,   
            CUSTOMER_MODEL_NAME,   
            PART_NO,   
            EC_NO,   
            FORCE_PASS_MESSAGE,   
            FORCE_PASS_DATE,   
            FORCE_PASS_BY,   
            BAD_REASON_COMMENTS,   
            BAD_REASON_CODE,   
            MAPPING_LABEL,   
            ORIGIN_ITEM_CODE,   
            DEBUG_LOG  
       FROM IQ_INTERLOCK_CHECK_RESULT 
     WHERE SERIAL_NO = :LVS_SERIAL_NO 
	     AND LINE_CODE = :LVS_LINE_CODE
	     AND WORKSTAGE_CODE = :LVS_WORKSTAGE_CODE
		 
	     AND IS_LAST_YN = 'Y' ;
	  
	 IF F_SQL_CHECK() < 0 THEN 
		RETURN 
	 END IF 
      commit ;
	  F_MSG_MDI_HELP( STRING(I))
	  
LOOP UNTIL i = dw_1.rowcount( ) 



end event

event rbuttondown;call super::rbuttondown;long i 
string lvs_serial
do
	i++
	
	lvs_serial = mid( string(dw_1.object.serial_no[i]) ,1,6) + string( i , '0000')
	dw_1.object.serial_no[i] = lvs_serial
	
loop until i = dw_1.rowcount( )
end event

type ddlb_dest_workstage_code from uo_workstage_code_all within w_pln_product_pcb_bcr_scan_query
integer x = 2464
integer y = 388
integer width = 517
integer height = 1752
integer taborder = 70
boolean bringtotop = true
end type

type st_9 from so_statictext within w_pln_product_pcb_bcr_scan_query
integer x = 2478
integer y = 320
integer width = 503
integer height = 64
boolean bringtotop = true
integer weight = 700
string text = "Workstage Code"
end type

type em_time_term from so_editmask within w_pln_product_pcb_bcr_scan_query
integer x = 2994
integer y = 388
integer width = 343
integer taborder = 120
boolean bringtotop = true
end type

type st_10 from so_statictext within w_pln_product_pcb_bcr_scan_query
integer x = 2994
integer y = 320
integer width = 343
integer height = 64
boolean bringtotop = true
integer weight = 700
string text = "Time Term"
end type

type ddlb_dest_machine_code from uo_machine_code within w_pln_product_pcb_bcr_scan_query
integer x = 3351
integer y = 388
integer height = 2124
integer taborder = 210
boolean bringtotop = true
end type

type st_11 from so_statictext within w_pln_product_pcb_bcr_scan_query
integer x = 3351
integer y = 320
integer width = 631
integer height = 64
boolean bringtotop = true
integer weight = 700
string text = "Workstage Code"
end type

type ddlb_customer_code from uo_customer_code_name within w_pln_product_pcb_bcr_scan_query
integer x = 745
integer y = 160
integer width = 663
integer height = 1324
integer taborder = 170
boolean bringtotop = true
boolean autohscroll = true
boolean vscrollbar = false
end type

event selectionchanged;call super::selectionchanged;ddlb_model_name.REdraw_customer( this.getcode() )
end event

type st_12 from statictext within w_pln_product_pcb_bcr_scan_query
integer x = 745
integer y = 76
integer width = 663
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

type uo_dateset from uo_ymdh_calendar within w_pln_product_pcb_bcr_scan_query
integer x = 4055
integer y = 156
integer width = 549
integer taborder = 130
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymdh_calendar::destroy
end on

type uo_dateend from uo_ymdh_calendar within w_pln_product_pcb_bcr_scan_query
integer x = 4613
integer y = 156
integer width = 544
integer taborder = 180
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymdh_calendar::destroy
end on

type cb_4 from so_commandbutton within w_pln_product_pcb_bcr_scan_query
boolean visible = false
integer x = 5147
integer y = 652
integer width = 421
integer height = 148
integer taborder = 190
boolean bringtotop = true
string text = "Upload"
end type

event clicked;call super::clicked;open(w_iq_interlock_reult_load_popup)
end event

type cb_5 from so_commandbutton within w_pln_product_pcb_bcr_scan_query
integer x = 768
integer y = 320
integer width = 421
integer height = 148
integer taborder = 140
boolean bringtotop = true
string text = "AOI Review"
end type

event clicked;call super::clicked;if dw_1.getrow() < 1 then return 
Openwithparm( w_qc_aoi_review_r_tf_popup , string(dw_1.object.serial_no[dw_1.getrow()]) )
end event

type sle_mapping_label from so_singlelineedit within w_pln_product_pcb_bcr_scan_query
integer x = 1486
integer y = 388
integer width = 782
integer taborder = 80
boolean bringtotop = true
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

DW_1.SETFILTER('')
DW_1.FILTER()

LVS_COLUMN = 'MAPPING_LABEL'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    DW_1.SETFILTER('')
    DW_1.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

DW_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
DW_1.FILTER()
F_MSG_MDI_HELP( STRING( DW_1.ROWCOUNT() ) + " Found" )
end event

type st_mapping_label from so_statictext within w_pln_product_pcb_bcr_scan_query
integer x = 1486
integer y = 320
integer width = 782
integer height = 64
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Mapping Label"
end type

type gb_1 from so_groupbox within w_pln_product_pcb_bcr_scan_query
integer x = 722
integer y = 4
integer width = 5147
integer height = 280
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_pln_product_pcb_bcr_scan_query
integer width = 713
integer height = 488
integer taborder = 90
string text = "Category"
end type

type gb_3 from so_groupbox within w_pln_product_pcb_bcr_scan_query
integer x = 722
integer y = 276
integer width = 5147
integer height = 212
integer taborder = 30
integer weight = 700
long textcolor = 16711680
end type

