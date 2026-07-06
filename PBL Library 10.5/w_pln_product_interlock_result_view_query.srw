HA$PBExportHeader$w_pln_product_interlock_result_view_query.srw
$PBExportComments$Line Master
forward
global type w_pln_product_interlock_result_view_query from w_main_root
end type
type st_mrm_no from so_statictext within w_pln_product_interlock_result_view_query
end type
type sle_run_no from so_singlelineedit within w_pln_product_interlock_result_view_query
end type
type sle_pcb_serial_no from so_singlelineedit within w_pln_product_interlock_result_view_query
end type
type st_2 from so_statictext within w_pln_product_interlock_result_view_query
end type
type ddlb_line_code from uo_line_code within w_pln_product_interlock_result_view_query
end type
type st_3 from so_statictext within w_pln_product_interlock_result_view_query
end type
type st_6 from so_statictext within w_pln_product_interlock_result_view_query
end type
type ddlb_workstage_code from uo_workstage_code_all within w_pln_product_interlock_result_view_query
end type
type st_1 from so_statictext within w_pln_product_interlock_result_view_query
end type
type ddlb_model_name from uo_set_model_name_ddlb within w_pln_product_interlock_result_view_query
end type
type st_5 from so_statictext within w_pln_product_interlock_result_view_query
end type
type ddlb_result from uo_basecode within w_pln_product_interlock_result_view_query
end type
type st_7 from so_statictext within w_pln_product_interlock_result_view_query
end type
type uo_dateset from uo_ymdh_calendar within w_pln_product_interlock_result_view_query
end type
type uo_dateend from uo_ymdh_calendar within w_pln_product_interlock_result_view_query
end type
type gb_1 from so_groupbox within w_pln_product_interlock_result_view_query
end type
end forward

global type w_pln_product_interlock_result_view_query from w_main_root
integer width = 6377
integer height = 3248
string title = "InterLock Check List Query"
st_mrm_no st_mrm_no
sle_run_no sle_run_no
sle_pcb_serial_no sle_pcb_serial_no
st_2 st_2
ddlb_line_code ddlb_line_code
st_3 st_3
st_6 st_6
ddlb_workstage_code ddlb_workstage_code
st_1 st_1
ddlb_model_name ddlb_model_name
st_5 st_5
ddlb_result ddlb_result
st_7 st_7
uo_dateset uo_dateset
uo_dateend uo_dateend
gb_1 gb_1
end type
global w_pln_product_interlock_result_view_query w_pln_product_interlock_result_view_query

type variables
Long Lvl_row 
String lvs_current_array_type , lvs_last_run_no
String lvs_user_line_code  , lvs_user_machine_code
end variables

on w_pln_product_interlock_result_view_query.create
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
this.ddlb_model_name=create ddlb_model_name
this.st_5=create st_5
this.ddlb_result=create ddlb_result
this.st_7=create st_7
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.gb_1=create gb_1
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
this.Control[iCurrent+10]=this.ddlb_model_name
this.Control[iCurrent+11]=this.st_5
this.Control[iCurrent+12]=this.ddlb_result
this.Control[iCurrent+13]=this.st_7
this.Control[iCurrent+14]=this.uo_dateset
this.Control[iCurrent+15]=this.uo_dateend
this.Control[iCurrent+16]=this.gb_1
end on

on w_pln_product_interlock_result_view_query.destroy
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
destroy(this.ddlb_model_name)
destroy(this.st_5)
destroy(this.ddlb_result)
destroy(this.st_7)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.gb_1)
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
	
						DW_1.RETRIEVE( ddlb_line_code.getcode()+'%' ,  ddlb_workstage_code.getcode( )+'%' ,   SLE_RUN_NO.text+'%' ,  ddlb_model_name.getcode( )+'%' ,   sle_pcb_serial_no.text+'%' ,  uo_dateset.text() , uo_dateend.text() ,  ddlb_result.getcode( )+'%' ,    GVI_ORGANIZATION_ID )
	
	CASE 'UPDATE' 
			DW_1.UPDATE()
			COMMIT ;
	CASE ELSE
	
END CHOOSE
end event

type dw_5 from w_main_root`dw_5 within w_pln_product_interlock_result_view_query
integer y = 344
integer width = 4256
integer height = 1932
integer taborder = 0
boolean titlebar = true
boolean controlmenu = true
end type

type dw_4 from w_main_root`dw_4 within w_pln_product_interlock_result_view_query
integer y = 344
integer width = 4256
integer height = 1932
integer taborder = 0
boolean titlebar = true
end type

type dw_3 from w_main_root`dw_3 within w_pln_product_interlock_result_view_query
string tag = "iq_interlock_check_result_check_matrix"
integer y = 344
integer width = 4256
integer height = 1932
integer taborder = 0
boolean titlebar = true
end type

type dw_2 from w_main_root`dw_2 within w_pln_product_interlock_result_view_query
integer y = 344
integer width = 4256
integer height = 1932
integer taborder = 0
boolean titlebar = true
end type

type dw_1 from w_main_root`dw_1 within w_pln_product_interlock_result_view_query
integer y = 340
integer width = 5111
integer height = 1932
integer taborder = 0
boolean titlebar = true
end type

event dw_1::clicked;call super::clicked;SLE_RUN_NO.SETFOCUS()
end event

type uo_tabpages from w_main_root`uo_tabpages within w_pln_product_interlock_result_view_query
integer taborder = 0
end type

type st_mrm_no from so_statictext within w_pln_product_interlock_result_view_query
integer x = 1047
integer y = 80
integer width = 430
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Run No"
end type

type sle_run_no from so_singlelineedit within w_pln_product_interlock_result_view_query
integer x = 1038
integer y = 160
integer width = 430
integer height = 84
integer taborder = 10
boolean bringtotop = true
textcase textcase = upper!
end type

type sle_pcb_serial_no from so_singlelineedit within w_pln_product_interlock_result_view_query
integer x = 2126
integer y = 160
integer width = 544
integer height = 84
integer taborder = 50
boolean bringtotop = true
textcase textcase = upper!
end type

type st_2 from so_statictext within w_pln_product_interlock_result_view_query
integer x = 2126
integer y = 84
integer width = 544
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "PCB Serial No"
end type

type ddlb_line_code from uo_line_code within w_pln_product_interlock_result_view_query
integer x = 41
integer y = 160
integer width = 471
boolean bringtotop = true
long backcolor = 16777215
end type

event selectionchanged;call super::selectionchanged;RegistrySet( "HKEY_LOCAL_MACHINE\Software\Infinity21\"+GVS_APPLICATION_NAME, "APP_USER_LINE", RegString!, STRING(this.getcode()))	

sle_run_no.setfocus()
end event

type st_3 from so_statictext within w_pln_product_interlock_result_view_query
integer x = 46
integer y = 76
integer width = 462
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Line Code"
end type

type st_6 from so_statictext within w_pln_product_interlock_result_view_query
integer x = 2688
integer y = 72
integer width = 1088
integer height = 68
boolean bringtotop = true
string text = "Receipt Date"
end type

type ddlb_workstage_code from uo_workstage_code_all within w_pln_product_interlock_result_view_query
integer x = 521
integer y = 160
integer width = 512
integer height = 1752
integer taborder = 20
boolean bringtotop = true
end type

type st_1 from so_statictext within w_pln_product_interlock_result_view_query
integer x = 530
integer y = 72
integer width = 512
integer height = 76
boolean bringtotop = true
integer weight = 700
string text = "Workstage Code"
end type

type ddlb_model_name from uo_set_model_name_ddlb within w_pln_product_interlock_result_view_query
integer x = 1477
integer y = 160
integer width = 645
integer height = 2368
integer taborder = 200
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
boolean hscrollbar = false
end type

type st_5 from so_statictext within w_pln_product_interlock_result_view_query
integer x = 1477
integer y = 84
integer width = 645
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Model Name"
end type

type ddlb_result from uo_basecode within w_pln_product_interlock_result_view_query
integer x = 3790
integer y = 160
integer width = 599
integer height = 1752
integer taborder = 150
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'RESULT')
end event

type st_7 from so_statictext within w_pln_product_interlock_result_view_query
integer x = 3790
integer y = 64
integer width = 599
integer height = 68
boolean bringtotop = true
string text = "Result"
end type

type uo_dateset from uo_ymdh_calendar within w_pln_product_interlock_result_view_query
integer x = 2679
integer y = 156
integer width = 549
integer taborder = 130
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymdh_calendar::destroy
end on

type uo_dateend from uo_ymdh_calendar within w_pln_product_interlock_result_view_query
integer x = 3237
integer y = 156
integer width = 544
integer taborder = 180
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymdh_calendar::destroy
end on

type gb_1 from so_groupbox within w_pln_product_interlock_result_view_query
integer width = 4411
integer height = 324
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

