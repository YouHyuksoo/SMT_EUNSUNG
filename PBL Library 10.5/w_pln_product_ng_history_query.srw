HA$PBExportHeader$w_pln_product_ng_history_query.srw
$PBExportComments$Line Master
forward
global type w_pln_product_ng_history_query from w_main_root
end type
type sle_pcb_serial_no from so_singlelineedit within w_pln_product_ng_history_query
end type
type st_2 from statictext within w_pln_product_ng_history_query
end type
type ddlb_line_code from uo_line_code within w_pln_product_ng_history_query
end type
type st_3 from statictext within w_pln_product_ng_history_query
end type
type st_1 from so_statictext within w_pln_product_ng_history_query
end type
type uo_dateset from uo_ymdh_calendar within w_pln_product_ng_history_query
end type
type uo_dateend from uo_ymdh_calendar within w_pln_product_ng_history_query
end type
type gb_1 from so_groupbox within w_pln_product_ng_history_query
end type
end forward

global type w_pln_product_ng_history_query from w_main_root
integer width = 4937
integer height = 2748
string title = ""
sle_pcb_serial_no sle_pcb_serial_no
st_2 st_2
ddlb_line_code ddlb_line_code
st_3 st_3
st_1 st_1
uo_dateset uo_dateset
uo_dateend uo_dateend
gb_1 gb_1
end type
global w_pln_product_ng_history_query w_pln_product_ng_history_query

type variables
Long Lvl_row 
String lvs_current_array_type , lvs_last_run_no
String lvs_user_line_code  , lvs_user_machine_code
end variables

on w_pln_product_ng_history_query.create
int iCurrent
call super::create
this.sle_pcb_serial_no=create sle_pcb_serial_no
this.st_2=create st_2
this.ddlb_line_code=create ddlb_line_code
this.st_3=create st_3
this.st_1=create st_1
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_pcb_serial_no
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.ddlb_line_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.uo_dateset
this.Control[iCurrent+7]=this.uo_dateend
this.Control[iCurrent+8]=this.gb_1
end on

on w_pln_product_ng_history_query.destroy
call super::destroy
destroy(this.sle_pcb_serial_no)
destroy(this.st_2)
destroy(this.ddlb_line_code)
destroy(this.st_3)
destroy(this.st_1)
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
Ivs_resize_type                      = 'MASTER_DETAIL_1L2R'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


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


//RegistryGet( "HKEY_LOCAL_MACHINE\Software\Infinity21\Jsmes", "APP_USER_LINE", RegString!, lvs_user_line_code)
//RegistryGet( "HKEY_LOCAL_MACHINE\Software\Infinity21\Jsmes", "APP_USER_MACHINE", RegString!, lvs_user_machine_code)		
//
//ddlb_line_code.text = lvs_user_line_code
//ddlb_machine_code.text= lvs_user_machine_code


end event

event ue_data_control;call super::ue_data_control;
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
			DW_1.RETRIEVE( sle_pcb_serial_no.TEXT+'%',ddlb_line_code.getcode( )+'%' ,uo_dateset.text() , uo_dateend.text() )
			dw_1.setfocus()	

CASE ELSE
END CHOOSE
end event

type dw_5 from w_main_root`dw_5 within w_pln_product_ng_history_query
integer x = 18
integer y = 548
integer height = 1932
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_pln_product_ng_history_query
integer x = 18
integer y = 548
integer height = 1932
integer taborder = 0
end type

type dw_3 from w_main_root`dw_3 within w_pln_product_ng_history_query
integer x = 18
integer y = 548
integer height = 1932
integer taborder = 0
end type

type dw_2 from w_main_root`dw_2 within w_pln_product_ng_history_query
integer x = 2930
integer y = 332
integer width = 1801
integer height = 1792
integer taborder = 0
boolean titlebar = true
string title = "PCB HISTORY"
string dataobject = "iq_interlock_check_result_4_2d_barcode_lst"
end type

type dw_1 from w_main_root`dw_1 within w_pln_product_ng_history_query
integer x = 9
integer y = 332
integer width = 2912
integer height = 1792
integer taborder = 0
boolean titlebar = true
string title = "PCB NG LIST"
string dataobject = "d_interlock_check_ng_log"
end type

event dw_1::clicked;call super::clicked;sle_pcb_serial_no.SETFOCUS()
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow <= 0 then 
   dw_2.reset()
else
   dw_2.retrieve( dw_1.object.serial_no[currentrow] , gvi_organization_id )
end if
end event

type uo_tabpages from w_main_root`uo_tabpages within w_pln_product_ng_history_query
integer taborder = 0
end type

type sle_pcb_serial_no from so_singlelineedit within w_pln_product_ng_history_query
integer x = 645
integer y = 164
integer width = 517
integer height = 84
integer taborder = 30
boolean bringtotop = true
textcase textcase = upper!
end type

type st_2 from statictext within w_pln_product_ng_history_query
integer x = 645
integer y = 84
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
string text = "PCB Serial No"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_line_code from uo_line_code within w_pln_product_ng_history_query
integer x = 160
integer y = 168
integer width = 402
integer height = 1328
boolean bringtotop = true
long backcolor = 16777215
end type

type st_3 from statictext within w_pln_product_ng_history_query
integer x = 165
integer y = 84
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

type st_1 from so_statictext within w_pln_product_ng_history_query
integer x = 1390
integer y = 92
integer width = 846
integer height = 68
boolean bringtotop = true
fontfamily fontfamily = modern!
string facename = "$$HEX5$$d1b940c72000e0ac15b5$$ENDHEX$$"
boolean enabled = false
string text = "Check Date"
end type

type uo_dateset from uo_ymdh_calendar within w_pln_product_ng_history_query
event destroy ( )
integer x = 1275
integer y = 164
integer width = 549
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymdh_calendar::destroy
end on

type uo_dateend from uo_ymdh_calendar within w_pln_product_ng_history_query
event destroy ( )
integer x = 1833
integer y = 164
integer width = 544
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymdh_calendar::destroy
end on

type gb_1 from so_groupbox within w_pln_product_ng_history_query
integer x = 9
integer width = 2629
integer height = 304
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

