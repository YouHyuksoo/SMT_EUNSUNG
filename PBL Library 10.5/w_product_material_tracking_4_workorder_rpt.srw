HA$PBExportHeader$w_product_material_tracking_4_workorder_rpt.srw
$PBExportComments$new a led project
forward
global type w_product_material_tracking_4_workorder_rpt from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_product_material_tracking_4_workorder_rpt
end type
type uo_dateend from uo_ymd_calendar within w_product_material_tracking_4_workorder_rpt
end type
type sle_run_no from so_singlelineedit within w_product_material_tracking_4_workorder_rpt
end type
type st_1 from statictext within w_product_material_tracking_4_workorder_rpt
end type
type sle_model_name from so_singlelineedit within w_product_material_tracking_4_workorder_rpt
end type
type st_3 from statictext within w_product_material_tracking_4_workorder_rpt
end type
type sle_lot_no from so_singlelineedit within w_product_material_tracking_4_workorder_rpt
end type
type st_4 from statictext within w_product_material_tracking_4_workorder_rpt
end type
type sle_work_order from so_singlelineedit within w_product_material_tracking_4_workorder_rpt
end type
type st_5 from statictext within w_product_material_tracking_4_workorder_rpt
end type
type st_2 from statictext within w_product_material_tracking_4_workorder_rpt
end type
type gb_1 from so_groupbox within w_product_material_tracking_4_workorder_rpt
end type
end forward

global type w_product_material_tracking_4_workorder_rpt from w_main_root
integer width = 5600
string title = "Work Order Tracking Query"
uo_dateset uo_dateset
uo_dateend uo_dateend
sle_run_no sle_run_no
st_1 st_1
sle_model_name sle_model_name
st_3 st_3
sle_lot_no sle_lot_no
st_4 st_4
sle_work_order sle_work_order
st_5 st_5
st_2 st_2
gb_1 gb_1
end type
global w_product_material_tracking_4_workorder_rpt w_product_material_tracking_4_workorder_rpt

type variables

end variables

on w_product_material_tracking_4_workorder_rpt.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.sle_run_no=create sle_run_no
this.st_1=create st_1
this.sle_model_name=create sle_model_name
this.st_3=create st_3
this.sle_lot_no=create sle_lot_no
this.st_4=create st_4
this.sle_work_order=create sle_work_order
this.st_5=create st_5
this.st_2=create st_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.sle_run_no
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.sle_model_name
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.sle_lot_no
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.sle_work_order
this.Control[iCurrent+10]=this.st_5
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.gb_1
end on

on w_product_material_tracking_4_workorder_rpt.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.sle_run_no)
destroy(this.st_1)
destroy(this.sle_model_name)
destroy(this.st_3)
destroy(this.sle_lot_no)
destroy(this.st_4)
destroy(this.sle_work_order)
destroy(this.st_5)
destroy(this.st_2)
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
Ivs_resize_type                      = 'MASTER_DETAIL_12T_3B'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
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
F_MENU_CONTROL('REPORT' , TRUE)  // All Data Control
end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())


end event

event ue_data_control;call super::ue_data_control;long i 
string lvas_lot_id[]  , lvs_lot_id
CHOOSE CASE Gvs_Ue_DATA_control
		
	CASE 'RETRIEVE'
		
		
							dw_1.retrieve(  sle_model_name.text+'%' , sle_run_no.text+'%' , sle_lot_no.text+'%' , sle_work_order.text+'%' , uo_dateset.text() , uo_dateend.text() , gvi_organization_id  )

	CASE ELSE
END CHOOSE
end event

type dw_5 from w_main_root`dw_5 within w_product_material_tracking_4_workorder_rpt
integer y = 832
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_product_material_tracking_4_workorder_rpt
integer y = 772
integer taborder = 0
boolean titlebar = true
end type

type dw_3 from w_main_root`dw_3 within w_product_material_tracking_4_workorder_rpt
integer y = 1316
integer width = 5536
integer height = 1524
integer taborder = 0
boolean titlebar = true
string dataobject = "d_ip_product_material_tracking_kfc_4_workorder_rpt"
boolean controlmenu = true
boolean minbox = true
end type

type dw_2 from w_main_root`dw_2 within w_product_material_tracking_4_workorder_rpt
integer x = 2633
integer y = 324
integer width = 2898
integer height = 988
integer taborder = 0
boolean titlebar = true
string title = "PCB"
string dataobject = "d_pln_product_2d_barcode_4_workorder_tracking"
boolean controlmenu = true
boolean minbox = true
end type

event dw_2::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
dw_3.retrieve( this.object.serial_no[currentrow]  , gvi_organization_id )
end event

type dw_1 from w_main_root`dw_1 within w_product_material_tracking_4_workorder_rpt
integer y = 320
integer width = 2629
integer height = 988
integer taborder = 0
boolean titlebar = true
string title = "Work Order"
string dataobject = "d_ip_product_run_card_4_work_order_lst"
boolean controlmenu = true
boolean minbox = true
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
dw_2.retrieve( dw_1.object.run_no[currentrow] , gvi_organization_id  )
end event

type uo_tabpages from w_main_root`uo_tabpages within w_product_material_tracking_4_workorder_rpt
integer taborder = 0
end type

type uo_dateset from uo_ymd_calendar within w_product_material_tracking_4_workorder_rpt
event destroy ( )
integer x = 2222
integer y = 172
integer taborder = 80
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_product_material_tracking_4_workorder_rpt
event destroy ( )
integer x = 2642
integer y = 172
integer taborder = 90
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type sle_run_no from so_singlelineedit within w_product_material_tracking_4_workorder_rpt
integer x = 603
integer y = 172
integer width = 530
integer taborder = 40
boolean bringtotop = true
textcase textcase = upper!
end type

type st_1 from statictext within w_product_material_tracking_4_workorder_rpt
integer x = 603
integer y = 88
integer width = 530
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Run No"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_model_name from so_singlelineedit within w_product_material_tracking_4_workorder_rpt
integer x = 59
integer y = 172
integer width = 530
integer taborder = 40
boolean bringtotop = true
textcase textcase = upper!
end type

type st_3 from statictext within w_product_material_tracking_4_workorder_rpt
integer x = 59
integer y = 88
integer width = 530
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Model Name"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_lot_no from so_singlelineedit within w_product_material_tracking_4_workorder_rpt
integer x = 1147
integer y = 172
integer width = 530
integer taborder = 50
boolean bringtotop = true
textcase textcase = upper!
end type

type st_4 from statictext within w_product_material_tracking_4_workorder_rpt
integer x = 1147
integer y = 88
integer width = 530
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Lot No"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_work_order from so_singlelineedit within w_product_material_tracking_4_workorder_rpt
integer x = 1687
integer y = 172
integer width = 530
integer taborder = 50
boolean bringtotop = true
textcase textcase = upper!
end type

type st_5 from statictext within w_product_material_tracking_4_workorder_rpt
integer x = 1687
integer y = 88
integer width = 530
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Work Order"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_product_material_tracking_4_workorder_rpt
integer x = 2245
integer y = 88
integer width = 805
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Run Date"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from so_groupbox within w_product_material_tracking_4_workorder_rpt
integer x = 18
integer width = 3077
integer height = 304
integer taborder = 40
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

