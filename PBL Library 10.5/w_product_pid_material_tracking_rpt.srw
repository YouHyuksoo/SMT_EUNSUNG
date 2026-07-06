HA$PBExportHeader$w_product_pid_material_tracking_rpt.srw
$PBExportComments$new a led project
forward
global type w_product_pid_material_tracking_rpt from w_main_root
end type
type sle_lot_no from so_singlelineedit within w_product_pid_material_tracking_rpt
end type
type st_1 from statictext within w_product_pid_material_tracking_rpt
end type
type gb_2 from so_groupbox within w_product_pid_material_tracking_rpt
end type
end forward

global type w_product_pid_material_tracking_rpt from w_main_root
string title = "PID Tracking Query"
sle_lot_no sle_lot_no
st_1 st_1
gb_2 gb_2
end type
global w_product_pid_material_tracking_rpt w_product_pid_material_tracking_rpt

type variables

end variables

on w_product_pid_material_tracking_rpt.create
int iCurrent
call super::create
this.sle_lot_no=create sle_lot_no
this.st_1=create st_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_lot_no
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.gb_2
end on

on w_product_pid_material_tracking_rpt.destroy
call super::destroy
destroy(this.sle_lot_no)
destroy(this.st_1)
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

event ue_data_control;call super::ue_data_control;string lvs_not_no , lvs_barcode

CHOOSE CASE Gvs_Ue_DATA_control
		
	CASE 'RETRIEVE'
			if sle_lot_no.text = '' or isnull(sle_lot_no.text) then 
				//Mess agebox("$$HEX2$$55d678c7$$ENDHEX$$" , "$$HEX20$$80acc9c060d5200090c7acc76fb8b8d2200088bc38d67cb9200085c725b8200058d538c194c62000$$ENDHEX$$")
				f_msg("$$HEX19$$80acc9c060d5200090c7acc76fb8b8d2200088bc38d67cb9200085c725b8200058d538c194c6$$ENDHEX$$",'P')
				return
			end if 
			DW_1.RESET( )
			  lvs_barcode = sle_lot_no.text 
			  select f_get_lot_no_from_barcode(  :lvs_barcode )
			    into :lvs_not_no
			  from dual  ;
			 
			 
			 
			DW_1.RETRIEVE( lvs_not_no ,  gvi_organization_id )

		
	CASE ELSE
END CHOOSE
end event

type dw_5 from w_main_root`dw_5 within w_product_pid_material_tracking_rpt
integer y = 392
end type

type dw_4 from w_main_root`dw_4 within w_product_pid_material_tracking_rpt
integer y = 392
boolean titlebar = true
end type

type dw_3 from w_main_root`dw_3 within w_product_pid_material_tracking_rpt
integer y = 392
boolean titlebar = true
boolean controlmenu = true
boolean minbox = true
end type

type dw_2 from w_main_root`dw_2 within w_product_pid_material_tracking_rpt
integer x = 2491
integer y = 372
integer width = 2048
integer height = 1356
boolean titlebar = true
string title = "SPI Data"
string dataobject = "d_ip_product_spi_data_4_tracking_rpt"
boolean controlmenu = true
boolean minbox = true
end type

type dw_1 from w_main_root`dw_1 within w_product_pid_material_tracking_rpt
integer y = 372
integer width = 2482
integer height = 1356
boolean titlebar = true
string title = "PDA Check History"
string dataobject = "d_ip_product_feeding_date_4_tracking_rpt"
boolean controlmenu = true
boolean minbox = true
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 


string lvsa_line_code[]

if  this.object.line_code[currentrow] = '31'  then 
	lvsa_line_code[1] = '01'
	lvsa_line_code[2] = '02'
elseif  this.object.line_code[currentrow] = '32'  then
	lvsa_line_code[1] = '03'
	lvsa_line_code[2] = '04'
elseif  this.object.line_code[currentrow] = '33'  then
	lvsa_line_code[1] = '05'
	lvsa_line_code[2] = '06'
elseif  this.object.line_code[currentrow] = '34'  then
	lvsa_line_code[1] = '07'
	lvsa_line_code[2] = '08'	
	
else
		lvsa_line_code[1] =this.object.line_code[currentrow]
end if 
	

DW_2.RETRIEVE(  string(this.object.check_Date_start[currentrow] , 'yyyymmddhhmmss') , string( this.object.check_Date_end[currentrow] , 'yyyymmddhhmmss' ) ,    lvsa_line_code , gvi_organization_id )
end event

type uo_tabpages from w_main_root`uo_tabpages within w_product_pid_material_tracking_rpt
end type

type sle_lot_no from so_singlelineedit within w_product_pid_material_tracking_rpt
integer x = 41
integer y = 196
integer width = 841
integer height = 84
integer taborder = 350
boolean bringtotop = true
textcase textcase = upper!
end type

type st_1 from statictext within w_product_pid_material_tracking_rpt
integer x = 41
integer y = 120
integer width = 841
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Material MFS"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_2 from so_groupbox within w_product_pid_material_tracking_rpt
integer x = 5
integer width = 933
integer height = 364
integer taborder = 90
string text = "Where Condition"
end type

