HA$PBExportHeader$w_qc_visual_inspect_data_master.srw
$PBExportComments$$$HEX11$$24c144be80acacc074c725b870b374c730d19ccd25b8$$ENDHEX$$
forward
global type w_qc_visual_inspect_data_master from w_main_root
end type
type st_4 from so_statictext within w_qc_visual_inspect_data_master
end type
type sle_pcb_serial_no from so_singlelineedit within w_qc_visual_inspect_data_master
end type
type rb_inspect from so_radiobutton within w_qc_visual_inspect_data_master
end type
type rb_2 from so_radiobutton within w_qc_visual_inspect_data_master
end type
type st_status from statictext within w_qc_visual_inspect_data_master
end type
type ddlb_line_code from uo_line_code within w_qc_visual_inspect_data_master
end type
type st_1 from so_statictext within w_qc_visual_inspect_data_master
end type
type st_2 from so_statictext within w_qc_visual_inspect_data_master
end type
type ddlb_workstage_code from uo_workstage_code_all within w_qc_visual_inspect_data_master
end type
type ddlb_model_name from uo_set_model_name_ddlb within w_qc_visual_inspect_data_master
end type
type st_5 from so_statictext within w_qc_visual_inspect_data_master
end type
type ddlb_bad_reason from uo_code_master within w_qc_visual_inspect_data_master
end type
type st_3 from so_statictext within w_qc_visual_inspect_data_master
end type
type uo_dateset from uo_ymd_calendar within w_qc_visual_inspect_data_master
end type
type st_6 from so_statictext within w_qc_visual_inspect_data_master
end type
type uo_dateend from uo_ymd_calendar within w_qc_visual_inspect_data_master
end type
type rb_insepct_bad_reason from so_radiobutton within w_qc_visual_inspect_data_master
end type
type gb_3 from so_groupbox within w_qc_visual_inspect_data_master
end type
type gb_1 from so_groupbox within w_qc_visual_inspect_data_master
end type
end forward

global type w_qc_visual_inspect_data_master from w_main_root
integer width = 5920
integer height = 3056
string title = "AOI Inspect Query"
boolean resizable = false
string ivs_dw_4_use_focusindicator = "Y"
st_4 st_4
sle_pcb_serial_no sle_pcb_serial_no
rb_inspect rb_inspect
rb_2 rb_2
st_status st_status
ddlb_line_code ddlb_line_code
st_1 st_1
st_2 st_2
ddlb_workstage_code ddlb_workstage_code
ddlb_model_name ddlb_model_name
st_5 st_5
ddlb_bad_reason ddlb_bad_reason
st_3 st_3
uo_dateset uo_dateset
st_6 st_6
uo_dateend uo_dateend
rb_insepct_bad_reason rb_insepct_bad_reason
gb_3 gb_3
gb_1 gb_1
end type
global w_qc_visual_inspect_data_master w_qc_visual_inspect_data_master

type variables
Long ll_row
string ivs_line_code
string ivs_workstage_code
string ivs_type
end variables

on w_qc_visual_inspect_data_master.create
int iCurrent
call super::create
this.st_4=create st_4
this.sle_pcb_serial_no=create sle_pcb_serial_no
this.rb_inspect=create rb_inspect
this.rb_2=create rb_2
this.st_status=create st_status
this.ddlb_line_code=create ddlb_line_code
this.st_1=create st_1
this.st_2=create st_2
this.ddlb_workstage_code=create ddlb_workstage_code
this.ddlb_model_name=create ddlb_model_name
this.st_5=create st_5
this.ddlb_bad_reason=create ddlb_bad_reason
this.st_3=create st_3
this.uo_dateset=create uo_dateset
this.st_6=create st_6
this.uo_dateend=create uo_dateend
this.rb_insepct_bad_reason=create rb_insepct_bad_reason
this.gb_3=create gb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_4
this.Control[iCurrent+2]=this.sle_pcb_serial_no
this.Control[iCurrent+3]=this.rb_inspect
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.st_status
this.Control[iCurrent+6]=this.ddlb_line_code
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.ddlb_workstage_code
this.Control[iCurrent+10]=this.ddlb_model_name
this.Control[iCurrent+11]=this.st_5
this.Control[iCurrent+12]=this.ddlb_bad_reason
this.Control[iCurrent+13]=this.st_3
this.Control[iCurrent+14]=this.uo_dateset
this.Control[iCurrent+15]=this.st_6
this.Control[iCurrent+16]=this.uo_dateend
this.Control[iCurrent+17]=this.rb_insepct_bad_reason
this.Control[iCurrent+18]=this.gb_3
this.Control[iCurrent+19]=this.gb_1
end on

on w_qc_visual_inspect_data_master.destroy
call super::destroy
destroy(this.st_4)
destroy(this.sle_pcb_serial_no)
destroy(this.rb_inspect)
destroy(this.rb_2)
destroy(this.st_status)
destroy(this.ddlb_line_code)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.ddlb_workstage_code)
destroy(this.ddlb_model_name)
destroy(this.st_5)
destroy(this.ddlb_bad_reason)
destroy(this.st_3)
destroy(this.uo_dateset)
destroy(this.st_6)
destroy(this.uo_dateend)
destroy(this.rb_insepct_bad_reason)
destroy(this.gb_3)
destroy(this.gb_1)
end on

event activate;call super::activate;/***************************************
* Window Default Property 
****************************************/
Gst_set.window_id            = this.classname() 
Gst_set.author                  = "JiSheng"
Gst_set.creation_date      = '20051101'
Gst_set.last_modify_date = '20051101'
Gst_set.Report_window    = True  // Report Window  True / Flase

/*****************************************
* Data Window Property
******************************************/
Ivs_resize_type                      = 'MASTER_DETAIL_1L2R'  // Resize Data Window Property ( NORMAL , MASTER_DETAIL )

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
F_MENU_CONTROL('DATA_CONTROL' ,TRUE)  // All Data Control


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

st_status.width = dw_1.width + dw_2.width

f_retrieve()


end event

event ue_data_control;call super::ue_data_control;Long Row
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
			if rb_inspect.checked = true then 

				dw_1.reset()
				dw_1.retrieve( gvs_language , gvi_organization_id )
				sle_pcb_serial_no.SETFOCUS()
				
			elseif rb_insepct_bad_reason.checked = true then 
				
				dw_5.retrieve( ddlb_model_name.getcode()+'%'   , ddlb_line_code.getcode()+'%' , uo_dateset.text() , uo_dateend.text() ,  gvs_language , gvi_organization_id )

			else
				
				dw_4.reset()
				dw_4.retrieve( uo_dateset.text() , uo_dateend.text() ,  ddlb_line_code.getcode()+'%' ,  ddlb_workstage_code.getcode()+'%' ,  ddlb_model_name.getcode()+'%'  ,  sle_pcb_serial_no.text+'%' , gvs_language ,   gvi_organization_id )
				sle_pcb_serial_no.SETFOCUS()
				
			end if 
		CASE 'INSERT' 
			
			DW_2.ENABLED = TRUE
			ll_row = DW_2.INSERTROW(DW_2.GETROW())
			DW_2.SCROLLTOROW(ll_row)
			F_SET_SECURITY_ROW(DW_2 , ll_row ,'ALL')		
			dw_2.setcolumn( 'location_infor')

	CASE 'DELETE'
		
		  	if dw_2.getrow() < 1 then return 
			  
			msg =f_msgbox(1003)
			if msg = 1 then
				gvl_row_deleted = dw_2.getrow()			
				dw_2.deleterow(gvl_row_deleted)		
				dw_2.setfocus()
				row = dw_2.getrow()
				dw_2.scrolltorow(row)
				dw_2.setcolumn(1)
			end if
			f_Update()
			sle_pcb_serial_no.SETFOCUS()

	CASE 'UPDATE'
		
		dw_2.ACCEPTTEXT()
 
	      IF dw_2.UPDATE() < 0 THEN
				ROLLBACK;
				RETURN
		ELSE
				 COMMIT;
       			 F_MSG_MDI_HELP ( F_MSG_ST(170)	 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
		END IF
		sle_pcb_serial_no.SETFOCUS()	
		case else
end choose

end event

event clicked;call super::clicked;sle_pcb_serial_no.setfocus()
end event

type dw_5 from w_main_root`dw_5 within w_qc_visual_inspect_data_master
integer y = 560
integer width = 2277
integer height = 1396
integer taborder = 0
boolean titlebar = true
string dataobject = "d_qc_visual_inspect_bad_query"
boolean maxbox = false
end type

event dw_5::itemerror;any la
Dynamic post setitem( row,  string(dwo.name) , la)

return 3
end event

type dw_4 from w_main_root`dw_4 within w_qc_visual_inspect_data_master
integer y = 556
integer width = 4530
integer height = 1396
integer taborder = 0
boolean titlebar = true
string title = "History"
string dataobject = "d_qc_visual_inspect_bad_hst"
end type

type dw_3 from w_main_root`dw_3 within w_qc_visual_inspect_data_master
integer y = 556
integer width = 2455
integer height = 1592
integer taborder = 0
boolean titlebar = true
string title = "Grapgh"
boolean controlmenu = true
borderstyle borderstyle = styleraised!
end type

type dw_2 from w_main_root`dw_2 within w_qc_visual_inspect_data_master
integer x = 2450
integer y = 552
integer width = 2071
integer height = 1596
integer taborder = 0
boolean titlebar = true
string title = "Inspect List"
string dataobject = "d_qc_visual_inspect_bad_lst"
borderstyle borderstyle = styleraised!
end type

event dw_2::itemchanged;call super::itemchanged;f_update()
sle_pcb_serial_no.setfocus()
end event

event dw_2::clicked;call super::clicked;sle_pcb_serial_no.setfocus()
end event

type dw_1 from w_main_root`dw_1 within w_qc_visual_inspect_data_master
integer y = 556
integer width = 2455
integer height = 1592
integer taborder = 0
boolean titlebar = true
string title = "Visual Bad Reason Code"
string dataobject = "d_bad_reason_select_4_visual_inspect_lst"
borderstyle borderstyle = styleraised!
end type

event dw_1::doubleclicked;call super::doubleclicked;if row < 1 or dw_2.getrow() < 1 then return 
dw_2.object.bad_reason_code[dw_2.getrow()] = this.object.code_name[row]
f_update()
sle_pcb_serial_no.setfocus()
end event

type uo_tabpages from w_main_root`uo_tabpages within w_qc_visual_inspect_data_master
integer taborder = 0
end type

type st_4 from so_statictext within w_qc_visual_inspect_data_master
integer x = 2249
integer y = 80
integer width = 937
integer height = 72
boolean bringtotop = true
string text = "Serial No "
end type

type sle_pcb_serial_no from so_singlelineedit within w_qc_visual_inspect_data_master
integer x = 2249
integer y = 168
integer width = 937
integer height = 88
integer taborder = 1
boolean bringtotop = true
integer weight = 700
textcase textcase = upper!
end type

event modified;call super::modified;string lvs_serial_no ,  lvs_line_code , lvs_bad_reason_code , lvs_workstage_code , lvs_item_code , lvs_model_name 
string lvs_model_suffix, lvs_machine_code, lvs_shift_code, lvs_t_serial_no
long lvl_sequence 
  
         dw_2.reset()

		/***************************
		*PID WorkStage $$HEX12$$d0c51cc120003eccc0c92000bbba60d52000bdacb0c62000$$ENDHEX$$
		* $$HEX8$$20c1ddd01cb420007cb778c7fcac2000$$ENDHEX$$WS $$HEX6$$7cb9200023b1b4c50cc92000$$ENDHEX$$
		***************************/
		
		  lvs_line_code = ddlb_line_code.getcode( )
		if lvs_line_code = '' or isnull(lvs_line_code) or lvs_line_code = '%' then 
			    this.text = ''
				f_msg('Check Line' , 'P' ) 
				return 
		end if 
		
		lvs_workstage_code = ddlb_workstage_code.getcode( )
		if lvs_workstage_code = '' or isnull(lvs_workstage_code) or lvs_workstage_code = '%' then 
			     this.text = ''
				f_msg('Check Workstage' , 'P' ) 
				
				return 
		end if 		
		
		lvs_serial_no = this.text 
		
		//=================
		//shift code 
		
	    select f_get_work_shift_code(sysdate) 
		   into :lvs_shift_code
		  from dual l; 
		
		if sqlca.sqlcode = 100 or sqlca.sqlcode < 0  then 
			lvs_shift_code = '1'
		end if 
		
		//===============================================
		// $$HEX5$$d9b3c4b3c1c069d62000$$ENDHEX$$
		 // 1. SMT $$HEX9$$f5ac15c820000fbc2000c4d6f5ac15c82000$$ENDHEX$$Routing $$HEX14$$f5ac15c8c0c998b0c0c920004ac558c544c720002000bdacb0c62000$$ENDHEX$$workstage $$HEX9$$d0c5200070b374c730d12000c6c54cc72000$$ENDHEX$$
		//    $$HEX14$$f8adf4b72000bdacb0c6200020c1ddd01cb420007cb778c7fcac2000$$ENDHEX$$workstage $$HEX4$$15c8f4bc7cb92000$$ENDHEX$$
		//==============================================

		if rb_inspect.checked = true then 
		
						ll_row = dw_2.retrieve( lvs_serial_no , gvi_organization_id )
						
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
						//  $$HEX18$$a4c294ce2000c8b9a4c230d15cb8200080bd45d1200015c8f4bc200000ac38c834c62000$$ENDHEX$$
						//==============================================
                           int lvi_check_pid_exists
							           select  count(*) into :lvi_check_pid_exists
									   from IP_PRODUCT_2D_BARCODE
									 where  serial_no = :lvs_serial_no
										 and organization_id = :gvi_organization_id ;  

						if  lvi_check_pid_exists = 0  then 
								//=========================================
								//  $$HEX31$$14bc54cfdcb42000ddc031c1200074c725b874c72000c6c53cc774ba2000e4b970acc4c920001cbcddc0200015c8f4bcd0c51cc1200000ac38c834c62000$$ENDHEX$$.
								//=========================================

										 select   ITEM_CODE  ,
										            MODEL_NAME, 
												   model_suffix											
												  
											 into  :lvs_item_code , 
											        :lvs_model_name, 
												    :lvs_model_suffix
												
											 from IP_PRODUCT_RUN_CARD_IO
										WHERE MAGAZINE_LABEL_NO = :lvs_serial_no ;		
										
									if f_sql_check() < 0 then 
										sle_pcb_serial_no.text = ''
										sle_pcb_serial_no.setfocus()
										return 
									end if 	 				

						else		
								      select distinct  ITEM_CODE ,  MODEL_NAME  , MODEL_SUFFIX 
										into :lvs_item_code , :lvs_model_name  , :lvs_model_suffix
									   from IP_PRODUCT_2D_BARCODE
									 where  serial_no = :lvs_serial_no
										 and organization_id = :gvi_organization_id ;  
										 
									if f_sql_check() < 0 then 
										sle_pcb_serial_no.text = ''
										sle_pcb_serial_no.setfocus()
										return 
									end if 	 							
						end if 

						//===============================================

						f_insert()
						//===================================================
						//
						//===================================================

						dw_2.object.model_name[ll_row] = lvs_model_name
						dw_2.object.model_suffix[ll_row]  = lvs_model_suffix
						dw_2.object.item_code[ll_row]     = lvs_item_code
						dw_2.object.serial_no[ll_row]       = lvs_serial_no // $$HEX15$$e4b970acc4c9200088bc38d600ac200020b418c2c4b3200088c7e0ac2000$$ENDHEX$$pid  $$HEX7$$7cc718c2c4b3200088c74cc72000$$ENDHEX$$
					
						lvs_bad_reason_code                   = ddlb_bad_reason.getcode()
						dw_2.object.bad_reason_code[ll_row]  =  lvs_bad_reason_code
						  
						dw_2.object.repair_result[ll_row]  =  'N'
						dw_2.object.line_code[ll_row]            = lvs_line_code
						dw_2.object.machine_code[ll_row]     =lvs_machine_code
						dw_2.object.workstage_code[ll_row] = lvs_workstage_code
						dw_2.object.wqc_division[ll_row] = 'A' 
						
						dw_2.object.inspect_date[ll_row] = f_sysdate()
						dw_2.object.inspect_by[ll_row] = gvs_user_id
					
						dw_2.object.inspect_sequence[ll_row] = lvl_sequence
					     dw_2.object.inspect_qty[ll_row] = 1					
						dw_2.object.inspect_bad_qty[ll_row] = 1
						
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
						sle_pcb_serial_no.text = ''
						sle_pcb_serial_no.setfocus()
			end if 
	

end event

type rb_inspect from so_radiobutton within w_qc_visual_inspect_data_master
integer x = 69
integer y = 72
integer width = 585
boolean bringtotop = true
string text = "Inspect"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
dw_2.bringtotop = true
dw_3.bringtotop = true
selected_data_window  = dw_1
sle_pcb_serial_no.SETFOCUS()
end event

type rb_2 from so_radiobutton within w_qc_visual_inspect_data_master
integer x = 69
integer y = 148
integer width = 585
boolean bringtotop = true
string text = "Inspect Hsitory"
end type

event clicked;call super::clicked;dw_4.bringtotop = true
selected_data_window  = dw_4
sle_pcb_serial_no.SETFOCUS()
end event

type st_status from statictext within w_qc_visual_inspect_data_master
integer y = 364
integer width = 4535
integer height = 176
boolean bringtotop = true
integer textsize = -22
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Message"
alignment alignment = center!
boolean focusrectangle = false
end type

event clicked;sle_pcb_serial_no .setfocus()
end event

type ddlb_line_code from uo_line_code within w_qc_visual_inspect_data_master
integer x = 713
integer y = 168
integer width = 535
integer height = 1936
integer taborder = 10
boolean bringtotop = true
long backcolor = 16777215
end type

event constructor;call super::constructor;IVS_LINE_CODE = Profilestring("WORKENV.INI","LINE","WORKSTAGE_IO","")
THIS.SELECtitem(IVS_LINE_CODE )


end event

event selectionchanged;call super::selectionchanged;f_jsSetProfileString ("WORKENV.INI", "LINE", "WORKSTAGE_IO", THIS.GETCODE() )
IVS_LINE_CODE = THIS.GETCODE()
end event

type st_1 from so_statictext within w_qc_visual_inspect_data_master
integer x = 713
integer y = 84
integer width = 526
integer height = 68
boolean bringtotop = true
string text = "Line Code"
end type

type st_2 from so_statictext within w_qc_visual_inspect_data_master
integer x = 1253
integer y = 88
integer width = 987
integer height = 68
boolean bringtotop = true
long textcolor = 0
string text = "Workstage Code"
end type

type ddlb_workstage_code from uo_workstage_code_all within w_qc_visual_inspect_data_master
integer x = 1253
integer y = 168
integer width = 987
integer height = 1936
integer taborder = 20
boolean bringtotop = true
end type

event selectionchanged;call super::selectionchanged;f_jsSetProfileString ("WORKENV.INI", "WORKSTAGE", "WORKSTAGE_IO", THIS.GETCODE() )
IVS_WORkstage_code = THIS.GETCODE()

SLE_PCB_SERIAL_NO.SETFOCUS( )    
end event

event constructor;call super::constructor;//RegistryGet( "HKEY_LOCAL_MACHINE\Software\Infinity21\"+GVS_APPLICATION_NAME, "IO_WORKSTAGE", RegString!,  IVS_WORKSTAGE_CODE)

IVS_WORKSTAGE_CODE = Profilestring("WORKENV.INI","WORKSTAGE","WORKSTAGE_IO","")
THIS.SELECtitem(IVS_WORKSTAGE_CODE )

////========================================
//// $$HEX7$$f5ac15c858c7200020c715d62000$$ENDHEX$$
////========================================
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


end event

type ddlb_model_name from uo_set_model_name_ddlb within w_qc_visual_inspect_data_master
integer x = 3195
integer y = 168
integer width = 640
integer height = 1936
integer taborder = 10
boolean bringtotop = true
long backcolor = 1073741824
end type

event selectionchanged;call super::selectionchanged;sle_pcb_serial_no.setfocus()
end event

type st_5 from so_statictext within w_qc_visual_inspect_data_master
integer x = 3200
integer y = 88
integer width = 640
integer height = 68
boolean bringtotop = true
string text = "Model Name"
end type

type ddlb_bad_reason from uo_code_master within w_qc_visual_inspect_data_master
integer x = 3849
integer y = 168
integer width = 626
integer height = 1936
integer taborder = 10
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw('WQC BAD REASON CODE')
end event

event selectionchanged;call super::selectionchanged;sle_pcb_serial_no.setfocus()
end event

type st_3 from so_statictext within w_qc_visual_inspect_data_master
integer x = 3849
integer y = 80
integer width = 626
integer height = 68
boolean bringtotop = true
long textcolor = 0
string text = "Bad Reason Code"
end type

type uo_dateset from uo_ymd_calendar within w_qc_visual_inspect_data_master
event destroy ( )
integer x = 4489
integer y = 160
integer taborder = 20
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_6 from so_statictext within w_qc_visual_inspect_data_master
integer x = 4494
integer y = 80
integer width = 827
integer height = 68
boolean bringtotop = true
string text = "Inspect Date"
end type

type uo_dateend from uo_ymd_calendar within w_qc_visual_inspect_data_master
event destroy ( )
integer x = 4910
integer y = 160
integer taborder = 30
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type rb_insepct_bad_reason from so_radiobutton within w_qc_visual_inspect_data_master
integer x = 69
integer y = 228
integer width = 585
boolean bringtotop = true
string text = "Inspect By Bad Reason"
end type

event clicked;call super::clicked;dw_5.bringtotop = true
selected_data_window  = dw_5
sle_pcb_serial_no.SETFOCUS()
end event

type gb_3 from so_groupbox within w_qc_visual_inspect_data_master
integer width = 667
integer height = 348
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_1 from so_groupbox within w_qc_visual_inspect_data_master
integer x = 686
integer width = 4681
integer height = 348
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

