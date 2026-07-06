HA$PBExportHeader$w_product_qc_repair_item.srw
$PBExportComments$new a led project
forward
global type w_product_qc_repair_item from w_main_root
end type
type sle_run_no from so_singlelineedit within w_product_qc_repair_item
end type
type st_3 from so_statictext within w_product_qc_repair_item
end type
type uo_dateset from uo_ymd_calendar within w_product_qc_repair_item
end type
type uo_dateend from uo_ymd_calendar within w_product_qc_repair_item
end type
type st_5 from so_statictext within w_product_qc_repair_item
end type
type sle_1 from so_singlelineedit within w_product_qc_repair_item
end type
type st_material_mfs from so_statictext within w_product_qc_repair_item
end type
type gb_where_condition from groupbox within w_product_qc_repair_item
end type
end forward

global type w_product_qc_repair_item from w_main_root
integer width = 4549
integer height = 2648
string title = "Product Qc Repair Report"
sle_run_no sle_run_no
st_3 st_3
uo_dateset uo_dateset
uo_dateend uo_dateend
st_5 st_5
sle_1 sle_1
st_material_mfs st_material_mfs
gb_where_condition gb_where_condition
end type
global w_product_qc_repair_item w_product_qc_repair_item

type variables

end variables

on w_product_qc_repair_item.create
int iCurrent
call super::create
this.sle_run_no=create sle_run_no
this.st_3=create st_3
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_5=create st_5
this.sle_1=create sle_1
this.st_material_mfs=create st_material_mfs
this.gb_where_condition=create gb_where_condition
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_run_no
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.uo_dateset
this.Control[iCurrent+4]=this.uo_dateend
this.Control[iCurrent+5]=this.st_5
this.Control[iCurrent+6]=this.sle_1
this.Control[iCurrent+7]=this.st_material_mfs
this.Control[iCurrent+8]=this.gb_where_condition
end on

on w_product_qc_repair_item.destroy
call super::destroy
destroy(this.sle_run_no)
destroy(this.st_3)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_5)
destroy(this.sle_1)
destroy(this.st_material_mfs)
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
		     
 			dw_1.retrieve(sle_run_no.text + '%', st_material_mfs.text + '%', uo_dateset.text() , uo_dateend.text() ,  gvi_organization_id)
			dw_1.setfocus()
	CASE ELSE
END CHOOSE
end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_product_qc_repair_item
integer y = 316
end type

type dw_4 from w_main_root`dw_4 within w_product_qc_repair_item
integer y = 316
end type

type dw_3 from w_main_root`dw_3 within w_product_qc_repair_item
integer y = 316
end type

type dw_2 from w_main_root`dw_2 within w_product_qc_repair_item
integer y = 316
integer taborder = 0
end type

type dw_1 from w_main_root`dw_1 within w_product_qc_repair_item
integer y = 316
integer width = 4507
integer height = 2120
integer taborder = 0
boolean titlebar = true
string title = "Repair Item List"
string dataobject = "d_product_qc_repair_item_rpt"
boolean livescroll = false
end type

type uo_tabpages from w_main_root`uo_tabpages within w_product_qc_repair_item
end type

type sle_run_no from so_singlelineedit within w_product_qc_repair_item
integer x = 46
integer y = 172
integer height = 84
integer taborder = 10
boolean bringtotop = true
end type

type st_3 from so_statictext within w_product_qc_repair_item
integer x = 46
integer y = 92
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Run No"
end type

type uo_dateset from uo_ymd_calendar within w_product_qc_repair_item
event destroy ( )
integer x = 1079
integer y = 172
integer taborder = 30
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_product_qc_repair_item
event destroy ( )
integer x = 1495
integer y = 172
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_5 from so_statictext within w_product_qc_repair_item
integer x = 1083
integer y = 92
integer width = 814
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Enter Date"
end type

type sle_1 from so_singlelineedit within w_product_qc_repair_item
integer x = 553
integer y = 172
integer height = 84
integer taborder = 40
boolean bringtotop = true
end type

type st_material_mfs from so_statictext within w_product_qc_repair_item
integer x = 544
integer y = 92
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Material Mfs"
end type

type gb_where_condition from groupbox within w_product_qc_repair_item
integer y = 4
integer width = 2034
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

