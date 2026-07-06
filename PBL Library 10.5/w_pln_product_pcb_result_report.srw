HA$PBExportHeader$w_pln_product_pcb_result_report.srw
$PBExportComments$Line Master
forward
global type w_pln_product_pcb_result_report from w_main_root
end type
type sle_model_name from so_singlelineedit within w_pln_product_pcb_result_report
end type
type st_2 from statictext within w_pln_product_pcb_result_report
end type
type ddlb_line_code from uo_line_code within w_pln_product_pcb_result_report
end type
type st_3 from statictext within w_pln_product_pcb_result_report
end type
type st_1 from so_statictext within w_pln_product_pcb_result_report
end type
type st_run_no from statictext within w_pln_product_pcb_result_report
end type
type sle_run_no from so_singlelineedit within w_pln_product_pcb_result_report
end type
type uo_dateset from uo_ymd_calendar within w_pln_product_pcb_result_report
end type
type rb_plan_date from so_radiobutton within w_pln_product_pcb_result_report
end type
type rb_actual_date from so_radiobutton within w_pln_product_pcb_result_report
end type
type gb_1 from so_groupbox within w_pln_product_pcb_result_report
end type
type gb_2 from so_groupbox within w_pln_product_pcb_result_report
end type
end forward

global type w_pln_product_pcb_result_report from w_main_root
integer width = 6354
integer height = 2748
string title = "Daily Production Report"
string ivs_dw_2_use_focusindicator = "Y"
string ivs_dw_2_selected_row_yn = "Y"
sle_model_name sle_model_name
st_2 st_2
ddlb_line_code ddlb_line_code
st_3 st_3
st_1 st_1
st_run_no st_run_no
sle_run_no sle_run_no
uo_dateset uo_dateset
rb_plan_date rb_plan_date
rb_actual_date rb_actual_date
gb_1 gb_1
gb_2 gb_2
end type
global w_pln_product_pcb_result_report w_pln_product_pcb_result_report

type variables
Long Lvl_row 
String lvs_current_array_type , lvs_last_run_no
String lvs_user_line_code  , lvs_user_machine_code
end variables

on w_pln_product_pcb_result_report.create
int iCurrent
call super::create
this.sle_model_name=create sle_model_name
this.st_2=create st_2
this.ddlb_line_code=create ddlb_line_code
this.st_3=create st_3
this.st_1=create st_1
this.st_run_no=create st_run_no
this.sle_run_no=create sle_run_no
this.uo_dateset=create uo_dateset
this.rb_plan_date=create rb_plan_date
this.rb_actual_date=create rb_actual_date
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_model_name
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.ddlb_line_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_run_no
this.Control[iCurrent+7]=this.sle_run_no
this.Control[iCurrent+8]=this.uo_dateset
this.Control[iCurrent+9]=this.rb_plan_date
this.Control[iCurrent+10]=this.rb_actual_date
this.Control[iCurrent+11]=this.gb_1
this.Control[iCurrent+12]=this.gb_2
end on

on w_pln_product_pcb_result_report.destroy
call super::destroy
destroy(this.sle_model_name)
destroy(this.st_2)
destroy(this.ddlb_line_code)
destroy(this.st_3)
destroy(this.st_1)
destroy(this.st_run_no)
destroy(this.sle_run_no)
destroy(this.uo_dateset)
destroy(this.rb_plan_date)
destroy(this.rb_actual_date)
destroy(this.gb_1)
destroy(this.gb_2)
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
ivs_dw_2_use_focusindicator = 'Y' //Default
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


//RegistryGet( "HKEY_LOCAL_MACHINE\Software\Infinity21\Jsmes", "APP_USER_LINE", RegString!, lvs_user_line_code)
//RegistryGet( "HKEY_LOCAL_MACHINE\Software\Infinity21\Jsmes", "APP_USER_MACHINE", RegString!, lvs_user_machine_code)		
//
//ddlb_line_code.text = lvs_user_line_code
//ddlb_machine_code.text= lvs_user_machine_code



end event

event ue_data_control;call super::ue_data_control;
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		
		     IF ( rb_plan_date.checked = TRUE ) THEN
				
			    DW_1.RETRIEVE( uo_dateset.text() , sle_model_name.TEXT+'%', sle_run_no.TEXT+'%', ddlb_line_code.getcode( )+'%' )
			    dw_1.setfocus()	
			
	       	ELSE
					
			    DW_2.RETRIEVE( uo_dateset.text() , sle_model_name.TEXT+'%', sle_run_no.TEXT+'%', ddlb_line_code.getcode( )+'%' )
			    dw_2.setfocus()	
				 
		    END IF

CASE ELSE
END CHOOSE
end event

type dw_5 from w_main_root`dw_5 within w_pln_product_pcb_result_report
integer x = 18
integer y = 548
integer height = 1040
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_pln_product_pcb_result_report
integer x = 18
integer y = 548
integer height = 1044
integer taborder = 0
end type

type dw_3 from w_main_root`dw_3 within w_pln_product_pcb_result_report
integer x = 1513
integer y = 856
integer width = 1001
integer height = 1072
integer taborder = 0
boolean titlebar = true
end type

type dw_2 from w_main_root`dw_2 within w_pln_product_pcb_result_report
integer x = 9
integer y = 332
integer width = 1001
integer height = 712
integer taborder = 0
boolean titlebar = true
string dataobject = "d_pln_product_pcb_result_report_actual_date"
end type

type dw_1 from w_main_root`dw_1 within w_pln_product_pcb_result_report
integer x = 9
integer y = 332
integer width = 4357
integer height = 1792
integer taborder = 0
boolean titlebar = true
string title = "Production Results"
string dataobject = "d_pln_product_pcb_result_report"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_pln_product_pcb_result_report
integer taborder = 0
end type

type sle_model_name from so_singlelineedit within w_pln_product_pcb_result_report
integer x = 1399
integer y = 168
integer width = 814
integer height = 84
integer taborder = 30
boolean bringtotop = true
textcase textcase = upper!
end type

type st_2 from statictext within w_pln_product_pcb_result_report
integer x = 1399
integer y = 96
integer width = 814
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Model name"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_line_code from uo_line_code within w_pln_product_pcb_result_report
integer x = 2807
integer y = 168
integer width = 576
integer height = 1328
boolean bringtotop = true
long backcolor = 16777215
end type

type st_3 from statictext within w_pln_product_pcb_result_report
integer x = 2907
integer y = 96
integer width = 393
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Line Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from so_statictext within w_pln_product_pcb_result_report
integer x = 951
integer y = 96
integer width = 421
integer height = 68
boolean bringtotop = true
fontfamily fontfamily = modern!
string facename = "$$HEX5$$d1b940c72000e0ac15b5$$ENDHEX$$"
boolean enabled = false
string text = "Product Date"
end type

type st_run_no from statictext within w_pln_product_pcb_result_report
integer x = 2249
integer y = 96
integer width = 517
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Run No"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_run_no from so_singlelineedit within w_pln_product_pcb_result_report
integer x = 2249
integer y = 168
integer width = 517
integer height = 84
integer taborder = 60
boolean bringtotop = true
textcase textcase = upper!
end type

type uo_dateset from uo_ymd_calendar within w_pln_product_pcb_result_report
event destroy ( )
integer x = 951
integer y = 168
integer taborder = 80
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type rb_plan_date from so_radiobutton within w_pln_product_pcb_result_report
integer x = 69
integer y = 80
integer width = 690
boolean bringtotop = true
integer weight = 700
string text = "Plan Date"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1
end event

type rb_actual_date from so_radiobutton within w_pln_product_pcb_result_report
integer x = 69
integer y = 180
integer width = 690
boolean bringtotop = true
integer weight = 700
string text = "Actual Date"
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
selected_data_window = dw_2
end event

type gb_1 from so_groupbox within w_pln_product_pcb_result_report
integer x = 823
integer width = 2697
integer height = 304
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_pln_product_pcb_result_report
integer x = 5
integer width = 800
integer height = 304
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

