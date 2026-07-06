HA$PBExportHeader$w_mcn_mold_receipt_rpt.srw
forward
global type w_mcn_mold_receipt_rpt from w_main_root
end type
type sle_mold_code from so_singlelineedit within w_mcn_mold_receipt_rpt
end type
type st_3 from so_statictext within w_mcn_mold_receipt_rpt
end type
type st_4 from so_statictext within w_mcn_mold_receipt_rpt
end type
type ddlb_supplier_code from uo_supplier_code within w_mcn_mold_receipt_rpt
end type
type uo_dateset from uo_ymd_calendar within w_mcn_mold_receipt_rpt
end type
type uo_dateend from uo_ymd_calendar within w_mcn_mold_receipt_rpt
end type
type st_5 from so_statictext within w_mcn_mold_receipt_rpt
end type
type gb_where_condition from groupbox within w_mcn_mold_receipt_rpt
end type
end forward

global type w_mcn_mold_receipt_rpt from w_main_root
integer width = 4549
integer height = 2648
string title = "Mold Receipt Report"
sle_mold_code sle_mold_code
st_3 st_3
st_4 st_4
ddlb_supplier_code ddlb_supplier_code
uo_dateset uo_dateset
uo_dateend uo_dateend
st_5 st_5
gb_where_condition gb_where_condition
end type
global w_mcn_mold_receipt_rpt w_mcn_mold_receipt_rpt

type variables

end variables

on w_mcn_mold_receipt_rpt.create
int iCurrent
call super::create
this.sle_mold_code=create sle_mold_code
this.st_3=create st_3
this.st_4=create st_4
this.ddlb_supplier_code=create ddlb_supplier_code
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_5=create st_5
this.gb_where_condition=create gb_where_condition
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_mold_code
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.ddlb_supplier_code
this.Control[iCurrent+5]=this.uo_dateset
this.Control[iCurrent+6]=this.uo_dateend
this.Control[iCurrent+7]=this.st_5
this.Control[iCurrent+8]=this.gb_where_condition
end on

on w_mcn_mold_receipt_rpt.destroy
call super::destroy
destroy(this.sle_mold_code)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.ddlb_supplier_code)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_5)
destroy(this.gb_where_condition)
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
/*****************************************
* Data Window Property
******************************************/
Ivs_resize_type                      = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


/*****************************************
* Data Window Property
******************************************/
ivs_dw_1_use_focusindicator = 'N' //Focus Indicator Show / Hide Property
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
F_MENU_CONTROL('REPORT' , True)  // All Data Control





end event

event ue_data_control;call super::ue_data_control;Long ROW
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		     
 			dw_1.retrieve(uo_dateset.text() , uo_dateend.text() , sle_mold_code.text + '%', ddlb_supplier_code.text +'%',  gvi_organization_id)
			dw_1.setfocus()
	CASE ELSE
END CHOOSE
end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_mcn_mold_receipt_rpt
integer y = 316
end type

type dw_4 from w_main_root`dw_4 within w_mcn_mold_receipt_rpt
integer y = 316
end type

type dw_3 from w_main_root`dw_3 within w_mcn_mold_receipt_rpt
integer y = 316
end type

type dw_2 from w_main_root`dw_2 within w_mcn_mold_receipt_rpt
integer y = 316
integer taborder = 0
end type

type dw_1 from w_main_root`dw_1 within w_mcn_mold_receipt_rpt
integer y = 316
integer width = 4507
integer height = 2120
integer taborder = 0
boolean titlebar = true
string title = "Mold Receipt List"
string dataobject = "d_mcn_mold_receipt_rpt"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_mcn_mold_receipt_rpt
end type

type sle_mold_code from so_singlelineedit within w_mcn_mold_receipt_rpt
integer x = 46
integer y = 172
integer height = 84
integer taborder = 10
boolean bringtotop = true
end type

type st_3 from so_statictext within w_mcn_mold_receipt_rpt
integer x = 46
integer y = 92
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Mold Code"
end type

type st_4 from so_statictext within w_mcn_mold_receipt_rpt
integer x = 549
integer y = 92
integer width = 439
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Supplier Code"
end type

type ddlb_supplier_code from uo_supplier_code within w_mcn_mold_receipt_rpt
integer x = 549
integer y = 172
integer width = 439
integer taborder = 20
boolean bringtotop = true
end type

type uo_dateset from uo_ymd_calendar within w_mcn_mold_receipt_rpt
event destroy ( )
integer x = 992
integer y = 172
integer taborder = 30
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mcn_mold_receipt_rpt
event destroy ( )
integer x = 1408
integer y = 172
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_5 from so_statictext within w_mcn_mold_receipt_rpt
integer x = 997
integer y = 92
integer width = 814
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Date"
end type

type gb_where_condition from groupbox within w_mcn_mold_receipt_rpt
integer y = 4
integer width = 1883
integer height = 304
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Where Condition"
end type

