HA$PBExportHeader$w_mat_long_term_inventory_report.srw
$PBExportComments$Material Issue Master Window
forward
global type w_mat_long_term_inventory_report from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mat_long_term_inventory_report
end type
type st_issue_date from so_statictext within w_mat_long_term_inventory_report
end type
type st_3 from so_statictext within w_mat_long_term_inventory_report
end type
type ddlb_item_code from uo_item_code within w_mat_long_term_inventory_report
end type
type sle_material_mfs from so_singlelineedit within w_mat_long_term_inventory_report
end type
type st_4 from so_statictext within w_mat_long_term_inventory_report
end type
type sle_term from so_singlelineedit within w_mat_long_term_inventory_report
end type
type st_1 from so_statictext within w_mat_long_term_inventory_report
end type
type ddlb_supplier_code from uo_supplier_code within w_mat_long_term_inventory_report
end type
type st_12 from so_statictext within w_mat_long_term_inventory_report
end type
type gb_where_condition from so_groupbox within w_mat_long_term_inventory_report
end type
end forward

global type w_mat_long_term_inventory_report from w_main_root
integer width = 4631
integer height = 2736
string title = "Material Long Term Inventory Report"
uo_dateset uo_dateset
st_issue_date st_issue_date
st_3 st_3
ddlb_item_code ddlb_item_code
sle_material_mfs sle_material_mfs
st_4 st_4
sle_term sle_term
st_1 st_1
ddlb_supplier_code ddlb_supplier_code
st_12 st_12
gb_where_condition gb_where_condition
end type
global w_mat_long_term_inventory_report w_mat_long_term_inventory_report

on w_mat_long_term_inventory_report.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.st_issue_date=create st_issue_date
this.st_3=create st_3
this.ddlb_item_code=create ddlb_item_code
this.sle_material_mfs=create sle_material_mfs
this.st_4=create st_4
this.sle_term=create sle_term
this.st_1=create st_1
this.ddlb_supplier_code=create ddlb_supplier_code
this.st_12=create st_12
this.gb_where_condition=create gb_where_condition
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.st_issue_date
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.ddlb_item_code
this.Control[iCurrent+5]=this.sle_material_mfs
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.sle_term
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.ddlb_supplier_code
this.Control[iCurrent+10]=this.st_12
this.Control[iCurrent+11]=this.gb_where_condition
end on

on w_mat_long_term_inventory_report.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.st_issue_date)
destroy(this.st_3)
destroy(this.ddlb_item_code)
destroy(this.sle_material_mfs)
destroy(this.st_4)
destroy(this.sle_term)
destroy(this.st_1)
destroy(this.ddlb_supplier_code)
destroy(this.st_12)
destroy(this.gb_where_condition)
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

event ue_post_open;call super::ue_post_open;
/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

sle_term.text = '12'



end event

event ue_data_control;call super::ue_data_control;long row
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
			dw_1.retrieve(  uo_dateset.text()  , sle_term.text , ddlb_item_code.text+ '%'  ,  sle_material_mfs.text+'%',  ddlb_supplier_code.text+'%' , gvi_organization_id )
			dw_1.setfocus()
		
	case else
end choose


end event

type dw_5 from w_main_root`dw_5 within w_mat_long_term_inventory_report
integer y = 316
end type

type dw_4 from w_main_root`dw_4 within w_mat_long_term_inventory_report
integer y = 316
integer taborder = 20
end type

type dw_3 from w_main_root`dw_3 within w_mat_long_term_inventory_report
integer y = 316
integer taborder = 30
end type

type dw_2 from w_main_root`dw_2 within w_mat_long_term_inventory_report
integer y = 316
integer width = 4544
integer height = 2184
integer taborder = 40
boolean titlebar = true
string title = "Material Issue Report"
string dataobject = "d_mat_issue_by_item_rpt"
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_mat_long_term_inventory_report
integer y = 316
integer width = 4544
integer height = 2184
integer taborder = 50
boolean titlebar = true
string title = "Inventory Report"
string dataobject = "d_mat_long_term_inventory_report"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_mat_long_term_inventory_report
end type

type uo_dateset from uo_ymd_calendar within w_mat_long_term_inventory_report
integer x = 46
integer y = 184
integer taborder = 60
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_issue_date from so_statictext within w_mat_long_term_inventory_report
integer x = 46
integer y = 92
integer width = 416
boolean bringtotop = true
integer weight = 700
string text = "Date"
end type

type st_3 from so_statictext within w_mat_long_term_inventory_report
integer x = 654
integer y = 92
integer width = 530
integer height = 84
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_mat_long_term_inventory_report
integer x = 654
integer y = 184
integer width = 530
integer taborder = 30
boolean bringtotop = true
end type

type sle_material_mfs from so_singlelineedit within w_mat_long_term_inventory_report
integer x = 1198
integer y = 184
integer height = 84
integer taborder = 140
boolean bringtotop = true
end type

type st_4 from so_statictext within w_mat_long_term_inventory_report
integer x = 1198
integer y = 96
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Lot No"
end type

type sle_term from so_singlelineedit within w_mat_long_term_inventory_report
integer x = 475
integer y = 184
integer width = 165
integer height = 84
integer taborder = 40
boolean bringtotop = true
end type

type st_1 from so_statictext within w_mat_long_term_inventory_report
integer x = 475
integer y = 92
integer width = 165
boolean bringtotop = true
integer weight = 700
string text = "Term"
end type

type ddlb_supplier_code from uo_supplier_code within w_mat_long_term_inventory_report
integer x = 1710
integer y = 184
integer height = 1344
integer taborder = 150
boolean bringtotop = true
end type

type st_12 from so_statictext within w_mat_long_term_inventory_report
integer x = 1710
integer y = 96
integer width = 462
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Supplier Code"
end type

type gb_where_condition from so_groupbox within w_mat_long_term_inventory_report
integer x = 9
integer width = 2240
integer height = 304
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

