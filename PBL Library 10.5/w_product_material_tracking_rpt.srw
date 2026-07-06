HA$PBExportHeader$w_product_material_tracking_rpt.srw
$PBExportComments$new a led project
forward
global type w_product_material_tracking_rpt from w_main_root
end type
type sle_serial_no from so_singlelineedit within w_product_material_tracking_rpt
end type
type st_2 from statictext within w_product_material_tracking_rpt
end type
type cbx_line_ignore from so_checkbox within w_product_material_tracking_rpt
end type
type cbx_model_ignore from so_checkbox within w_product_material_tracking_rpt
end type
type cbx_time from so_checkbox within w_product_material_tracking_rpt
end type
type em_time from so_editmask within w_product_material_tracking_rpt
end type
type st_1 from so_statictext within w_product_material_tracking_rpt
end type
type gb_1 from so_groupbox within w_product_material_tracking_rpt
end type
type gb_2 from so_groupbox within w_product_material_tracking_rpt
end type
end forward

global type w_product_material_tracking_rpt from w_main_root
string title = "Material Tracking Query(Dynamic)"
sle_serial_no sle_serial_no
st_2 st_2
cbx_line_ignore cbx_line_ignore
cbx_model_ignore cbx_model_ignore
cbx_time cbx_time
em_time em_time
st_1 st_1
gb_1 gb_1
gb_2 gb_2
end type
global w_product_material_tracking_rpt w_product_material_tracking_rpt

type variables

end variables

on w_product_material_tracking_rpt.create
int iCurrent
call super::create
this.sle_serial_no=create sle_serial_no
this.st_2=create st_2
this.cbx_line_ignore=create cbx_line_ignore
this.cbx_model_ignore=create cbx_model_ignore
this.cbx_time=create cbx_time
this.em_time=create em_time
this.st_1=create st_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_serial_no
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.cbx_line_ignore
this.Control[iCurrent+4]=this.cbx_model_ignore
this.Control[iCurrent+5]=this.cbx_time
this.Control[iCurrent+6]=this.em_time
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.gb_2
end on

on w_product_material_tracking_rpt.destroy
call super::destroy
destroy(this.sle_serial_no)
destroy(this.st_2)
destroy(this.cbx_line_ignore)
destroy(this.cbx_model_ignore)
destroy(this.cbx_time)
destroy(this.em_time)
destroy(this.st_1)
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
Gst_set.Report_window    = True  // Report Window  True / Flase

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

event ue_data_control;call super::ue_data_control;
CHOOSE CASE Gvs_Ue_DATA_control
		
	CASE 'RETRIEVE'
		
			DW_1.RESET()
			DW_2.RESET()
		

			DW_1.RETRIEVE( sle_serial_no.TEXT , GVI_ORGANIZATION_ID )

	CASE ELSE
END CHOOSE
end event

type dw_5 from w_main_root`dw_5 within w_product_material_tracking_rpt
integer y = 420
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_product_material_tracking_rpt
integer y = 420
integer taborder = 0
boolean titlebar = true
end type

type dw_3 from w_main_root`dw_3 within w_product_material_tracking_rpt
integer y = 420
integer taborder = 0
boolean titlebar = true
boolean controlmenu = true
boolean minbox = true
end type

type dw_2 from w_main_root`dw_2 within w_product_material_tracking_rpt
integer x = 2491
integer y = 404
integer width = 2094
integer height = 1356
integer taborder = 0
boolean titlebar = true
string title = "CCS / Reel Change List"
string dataobject = "d_ip_product_material_4_aoi_tracking_rpt"
boolean controlmenu = true
boolean minbox = true
end type

type dw_1 from w_main_root`dw_1 within w_product_material_tracking_rpt
integer y = 404
integer width = 2478
integer height = 1356
integer taborder = 0
boolean titlebar = true
string title = "SPI / AOI Check List"
string dataobject = "d_pln_product_spi_aoi_list_4_tracking"
boolean controlmenu = true
boolean minbox = true
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
//
// if this.object.workstage_name[currentrow] = 'SPI' and dw_2.dataobject <>  'd_ip_product_material_4_spi_tracking_rpt' then 
//
//	dw_2.dataobject = 'd_ip_product_material_4_spi_tracking_rpt'
//	dw_2.settransobject( sqlca)
//	f_set_column_dddw(dw_2)
//	f_dual_lang_change_dwtext(dw_2)
//elseif this.object.workstage_name[currentrow] = 'AOI' and dw_2.dataobject <>  'd_ip_product_material_4_aoi_tracking_rpt' then 
//	dw_2.dataobject = 'd_ip_product_material_4_aoi_tracking_rpt'
//	dw_2.settransobject( sqlca)
//	f_set_column_dddw(dw_2)
//	f_dual_lang_change_dwtext(dw_2)
//	
//end if 


string lvs_model_name , lvs_line_code

if cbx_line_ignore.checked = true then 
	lvs_line_code = '%'
else
	lvs_line_code = this.object.line_code[currentrow]
end if 

if cbx_model_ignore.checked = true then 
	lvs_model_name = '%'
else
	lvs_model_name = this.object.smt_model_name[currentrow]
end if 
	

IF ISNULL(em_time.TEXT) OR em_time.TEXT = '' THEN 
	em_time.TEXT = '0'
END IF 

DW_2.RESET( )
DW_2.RETRIEVE(lvs_model_name ,lvs_line_code , this.object.serial_no[currentrow] ,  this.object.min_datetime[currentrow]  ,  this.object.max_datetime[currentrow] , LONG(em_time.TEXT) , gvi_organization_id )
end event

type uo_tabpages from w_main_root`uo_tabpages within w_product_material_tracking_rpt
integer taborder = 0
end type

type sle_serial_no from so_singlelineedit within w_product_material_tracking_rpt
integer x = 123
integer y = 212
integer width = 805
integer taborder = 20
boolean bringtotop = true
textcase textcase = upper!
end type

type st_2 from statictext within w_product_material_tracking_rpt
integer x = 123
integer y = 132
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
string text = "PCB Serial No"
alignment alignment = center!
boolean focusrectangle = false
end type

type cbx_line_ignore from so_checkbox within w_product_material_tracking_rpt
integer x = 1216
integer y = 176
boolean bringtotop = true
string text = "Line Ignore"
end type

type cbx_model_ignore from so_checkbox within w_product_material_tracking_rpt
integer x = 1216
integer y = 272
boolean bringtotop = true
string text = "Model Ignore"
end type

type cbx_time from so_checkbox within w_product_material_tracking_rpt
integer x = 1216
integer y = 72
integer width = 329
boolean bringtotop = true
string text = "+ Time"
end type

type em_time from so_editmask within w_product_material_tracking_rpt
integer x = 1577
integer y = 76
integer width = 315
integer taborder = 50
boolean bringtotop = true
string text = "0"
alignment alignment = center!
string mask = "##0"
boolean spin = true
double increment = 1
end type

type st_1 from so_statictext within w_product_material_tracking_rpt
integer x = 1897
integer y = 84
integer width = 178
boolean bringtotop = true
string text = "minute"
end type

type gb_1 from so_groupbox within w_product_material_tracking_rpt
integer x = 1088
integer width = 1074
integer height = 384
integer taborder = 40
integer weight = 700
long textcolor = 16711680
string text = "Option"
end type

type gb_2 from so_groupbox within w_product_material_tracking_rpt
integer width = 1074
integer height = 384
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

