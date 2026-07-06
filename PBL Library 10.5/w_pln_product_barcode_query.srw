HA$PBExportHeader$w_pln_product_barcode_query.srw
$PBExportComments$Line Master
forward
global type w_pln_product_barcode_query from w_main_root
end type
type st_mrm_no from statictext within w_pln_product_barcode_query
end type
type sle_run_no from so_singlelineedit within w_pln_product_barcode_query
end type
type sle_pcb_serial_no from so_singlelineedit within w_pln_product_barcode_query
end type
type st_2 from statictext within w_pln_product_barcode_query
end type
type ddlb_line_code from uo_line_code within w_pln_product_barcode_query
end type
type st_3 from statictext within w_pln_product_barcode_query
end type
type ddlb_machine_code from uo_machine_code within w_pln_product_barcode_query
end type
type st_machine_code from statictext within w_pln_product_barcode_query
end type
type st_4 from statictext within w_pln_product_barcode_query
end type
type ddlb_model_name from uo_model_name_ddlb within w_pln_product_barcode_query
end type
type sle_magazine_no from so_singlelineedit within w_pln_product_barcode_query
end type
type st_5 from statictext within w_pln_product_barcode_query
end type
type sle_xout_pid from so_singlelineedit within w_pln_product_barcode_query
end type
type st_1 from statictext within w_pln_product_barcode_query
end type
type cbx_xout_cancel from so_checkbox within w_pln_product_barcode_query
end type
type sle_repair_by from so_singlelineedit within w_pln_product_barcode_query
end type
type st_6 from statictext within w_pln_product_barcode_query
end type
type st_status from so_statictext within w_pln_product_barcode_query
end type
type gb_1 from so_groupbox within w_pln_product_barcode_query
end type
type gb_2 from so_groupbox within w_pln_product_barcode_query
end type
end forward

global type w_pln_product_barcode_query from w_main_root
integer width = 5870
integer height = 3008
string title = "PID Master Query"
st_mrm_no st_mrm_no
sle_run_no sle_run_no
sle_pcb_serial_no sle_pcb_serial_no
st_2 st_2
ddlb_line_code ddlb_line_code
st_3 st_3
ddlb_machine_code ddlb_machine_code
st_machine_code st_machine_code
st_4 st_4
ddlb_model_name ddlb_model_name
sle_magazine_no sle_magazine_no
st_5 st_5
sle_xout_pid sle_xout_pid
st_1 st_1
cbx_xout_cancel cbx_xout_cancel
sle_repair_by sle_repair_by
st_6 st_6
st_status st_status
gb_1 gb_1
gb_2 gb_2
end type
global w_pln_product_barcode_query w_pln_product_barcode_query

type variables
Long Lvl_row 
String lvs_current_array_type , lvs_last_run_no
String lvs_user_line_code  , lvs_user_machine_code
end variables

on w_pln_product_barcode_query.create
int iCurrent
call super::create
this.st_mrm_no=create st_mrm_no
this.sle_run_no=create sle_run_no
this.sle_pcb_serial_no=create sle_pcb_serial_no
this.st_2=create st_2
this.ddlb_line_code=create ddlb_line_code
this.st_3=create st_3
this.ddlb_machine_code=create ddlb_machine_code
this.st_machine_code=create st_machine_code
this.st_4=create st_4
this.ddlb_model_name=create ddlb_model_name
this.sle_magazine_no=create sle_magazine_no
this.st_5=create st_5
this.sle_xout_pid=create sle_xout_pid
this.st_1=create st_1
this.cbx_xout_cancel=create cbx_xout_cancel
this.sle_repair_by=create sle_repair_by
this.st_6=create st_6
this.st_status=create st_status
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_mrm_no
this.Control[iCurrent+2]=this.sle_run_no
this.Control[iCurrent+3]=this.sle_pcb_serial_no
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.ddlb_line_code
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.ddlb_machine_code
this.Control[iCurrent+8]=this.st_machine_code
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.ddlb_model_name
this.Control[iCurrent+11]=this.sle_magazine_no
this.Control[iCurrent+12]=this.st_5
this.Control[iCurrent+13]=this.sle_xout_pid
this.Control[iCurrent+14]=this.st_1
this.Control[iCurrent+15]=this.cbx_xout_cancel
this.Control[iCurrent+16]=this.sle_repair_by
this.Control[iCurrent+17]=this.st_6
this.Control[iCurrent+18]=this.st_status
this.Control[iCurrent+19]=this.gb_1
this.Control[iCurrent+20]=this.gb_2
end on

on w_pln_product_barcode_query.destroy
call super::destroy
destroy(this.st_mrm_no)
destroy(this.sle_run_no)
destroy(this.sle_pcb_serial_no)
destroy(this.st_2)
destroy(this.ddlb_line_code)
destroy(this.st_3)
destroy(this.ddlb_machine_code)
destroy(this.st_machine_code)
destroy(this.st_4)
destroy(this.ddlb_model_name)
destroy(this.sle_magazine_no)
destroy(this.st_5)
destroy(this.sle_xout_pid)
destroy(this.st_1)
destroy(this.cbx_xout_cancel)
destroy(this.sle_repair_by)
destroy(this.st_6)
destroy(this.st_status)
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

    dw_1.resize( dw_1.width -34 , height - ( dw_1.y +120)  )
	
	dw_2.x = dw_1.x + dw_1.width 
	dw_2.resize( (width -34)  - dw_1.width, dw_1.height*2/3)		  
	
    dw_3.x = dw_1.x + dw_1.width 
	dw_3.y = dw_2.y + dw_2.height 
	dw_3.resize( (width -34)  - dw_1.width, dw_1.height*1/3)
	
    dw_4.resize(width - dw_4.x - 34, height - dw_1.y -120)	
    dw_5.resize(width - dw_5.x - 34, height - dw_2.y -120)	



st_status.width  = dw_1.width
end event

event ue_data_control;call super::ue_data_control;CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
			DW_1.RETRIEVE( ddlb_model_name.getcode()+'%' , SLE_RUN_NO.TEXT+'%' , ddlb_line_code.getcode( )+'%' ,   sle_pcb_serial_no.TEXT+'%' ,  sle_magazine_no.text+'%' ,  GVI_ORGANIZATION_ID )
	CASE ELSE
END CHOOSE
end event

event resize;call super::resize;st_status.width  = dw_1.width
end event

type dw_5 from w_main_root`dw_5 within w_pln_product_barcode_query
integer y = 512
integer height = 1932
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_pln_product_barcode_query
integer y = 512
integer height = 1932
integer taborder = 0
end type

type dw_3 from w_main_root`dw_3 within w_pln_product_barcode_query
integer y = 512
integer width = 1865
integer height = 1948
integer taborder = 0
boolean titlebar = true
end type

type dw_2 from w_main_root`dw_2 within w_pln_product_barcode_query
integer y = 512
integer width = 1865
integer height = 1948
integer taborder = 0
boolean titlebar = true
end type

type dw_1 from w_main_root`dw_1 within w_pln_product_barcode_query
integer y = 512
integer width = 4402
integer height = 1948
integer taborder = 0
boolean titlebar = true
string title = "PCB 2D List"
string dataobject = "d_pln_product_2D_barcode_query"
end type

event dw_1::clicked;call super::clicked;SLE_RUN_NO.SETFOCUS()
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;
if currentrow <= 0 then return 
dw_2.retrieve( dw_1.object.serial_no[currentrow] , gvi_organization_id )
dw_3.retrieve( dw_1.object.line_code[currentrow] , dw_1.object.machine_code[currentrow] ,dw_1.object.run_no[currentrow] )
end event

type uo_tabpages from w_main_root`uo_tabpages within w_pln_product_barcode_query
integer taborder = 0
end type

type st_mrm_no from statictext within w_pln_product_barcode_query
integer x = 1710
integer y = 80
integer width = 457
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

type sle_run_no from so_singlelineedit within w_pln_product_barcode_query
integer x = 1705
integer y = 164
integer width = 457
integer height = 84
integer taborder = 10
boolean bringtotop = true
textcase textcase = upper!
end type

type sle_pcb_serial_no from so_singlelineedit within w_pln_product_barcode_query
integer x = 55
integer y = 164
integer width = 736
integer taborder = 30
boolean bringtotop = true
textcase textcase = upper!
end type

type st_2 from statictext within w_pln_product_barcode_query
integer x = 55
integer y = 76
integer width = 736
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

type ddlb_line_code from uo_line_code within w_pln_product_barcode_query
integer x = 795
integer y = 164
integer width = 402
integer height = 1324
boolean bringtotop = true
long backcolor = 16777215
end type

event selectionchanged;call super::selectionchanged;RegistrySet( "HKEY_LOCAL_MACHINE\Software\Infinity21\"+GVS_APPLICATION_NAME, "APP_USER_LINE", RegString!, STRING(this.getcode()))	

sle_run_no.setfocus()
end event

type st_3 from statictext within w_pln_product_barcode_query
integer x = 800
integer y = 80
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

type ddlb_machine_code from uo_machine_code within w_pln_product_barcode_query
integer x = 1207
integer y = 164
integer width = 494
integer height = 1324
boolean bringtotop = true
end type

event selectionchanged;call super::selectionchanged;RegistrySet( "HKEY_LOCAL_MACHINE\Software\Infinity21\"+GVS_APPLICATION_NAME, "APP_USER_MACHINE", RegString!, STRING(this.getcode()))		
sle_run_no.setfocus()
end event

type st_machine_code from statictext within w_pln_product_barcode_query
integer x = 1207
integer y = 80
integer width = 494
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Machine Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_pln_product_barcode_query
integer x = 2167
integer y = 80
integer width = 773
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Model Name"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_model_name from uo_model_name_ddlb within w_pln_product_barcode_query
integer x = 2167
integer y = 164
integer width = 773
integer height = 1628
integer taborder = 80
boolean bringtotop = true
end type

type sle_magazine_no from so_singlelineedit within w_pln_product_barcode_query
integer x = 2944
integer y = 164
integer width = 571
integer taborder = 90
boolean bringtotop = true
textcase textcase = upper!
end type

type st_5 from statictext within w_pln_product_barcode_query
integer x = 2944
integer y = 76
integer width = 571
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Magazine No"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_xout_pid from so_singlelineedit within w_pln_product_barcode_query
integer x = 4174
integer y = 156
integer width = 759
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
textcase textcase = upper!
end type

event modified;call super::modified;int lvi_count
string lvs_pid  , lvs_repair_by

lvs_pid = sle_xout_pid.text
lvs_repair_by = sle_repair_by.text

select count(*) into :lvi_count 
 from ip_product_2d_barcode 
where serial_no = :lvs_pid
 and organization_id = :gvi_organization_id;

if f_sql_check() < 0 then 
	return 
end if 

if lvi_count < 1 then 
	f_msg("$$HEX11$$f8bbf1b45db8200014bc54cfdcb4200085c7c8b2e4b2$$ENDHEX$$" , "P")
	this.text = ''
	this.setfocus()
	st_status.text = f_msg("$$HEX11$$f8bbf1b45db8200014bc54cfdcb4200085c7c8b2e4b2$$ENDHEX$$" , "S" )
end if 


update ip_product_2d_barcode 
set barcode_status = 'N'  , last_modify_by = :lvs_repair_by
where serial_no = :lvs_pid 
 and organization_id = :gvi_organization_id;

if f_sql_check() < 0 then 
	return 
end if 


delete from IP_PRODUCT_WORK_QC where serial_no = :lvs_pid and bad_reason_code = 'X-OUT' and  organization_id = :gvi_organization_id ;
if f_sql_check() < 0 then 
	return 
end if 

commit ;

st_status.text = f_msg("$$HEX16$$18c2acb9200074c725b82000adc01cc820000fbc2000f5bc6cad200031c1f5ac$$ENDHEX$$" , "S" )
this.text = ''
this.setfocus()
end event

type st_1 from statictext within w_pln_product_barcode_query
integer x = 4178
integer y = 64
integer width = 736
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

type cbx_xout_cancel from so_checkbox within w_pln_product_barcode_query
integer x = 3643
integer y = 156
boolean bringtotop = true
string text = "X-OUT Repair"
end type

event clicked;call super::clicked;if this.checked  = true then 
	sle_xout_pid.enabled = true 
else
	
	sle_xout_pid.enabled = false 
end if 

sle_xout_pid.setfocus()
end event

type sle_repair_by from so_singlelineedit within w_pln_product_barcode_query
integer x = 4937
integer y = 156
integer width = 571
integer taborder = 90
boolean bringtotop = true
textcase textcase = upper!
end type

type st_6 from statictext within w_pln_product_barcode_query
integer x = 4933
integer y = 72
integer width = 571
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Repair By"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_status from so_statictext within w_pln_product_barcode_query
integer x = 27
integer y = 320
integer width = 4123
integer height = 164
boolean bringtotop = true
integer textsize = -22
long textcolor = 65535
long backcolor = 134217741
string text = "Message"
end type

type gb_1 from so_groupbox within w_pln_product_barcode_query
integer x = 23
integer width = 3547
integer height = 304
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_pln_product_barcode_query
integer x = 3598
integer width = 1957
integer height = 296
integer taborder = 10
end type

