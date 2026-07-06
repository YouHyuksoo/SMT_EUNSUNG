HA$PBExportHeader$w_pln_product_barcode_tracking.srw
$PBExportComments$Line Master
forward
global type w_pln_product_barcode_tracking from w_main_root
end type
type st_mrm_no from statictext within w_pln_product_barcode_tracking
end type
type sle_run_no from so_singlelineedit within w_pln_product_barcode_tracking
end type
type sle_pcb_serial_no from so_singlelineedit within w_pln_product_barcode_tracking
end type
type st_2 from statictext within w_pln_product_barcode_tracking
end type
type uo_dateset from uo_ymd_calendar within w_pln_product_barcode_tracking
end type
type st_4 from so_statictext within w_pln_product_barcode_tracking
end type
type uo_dateend from uo_ymd_calendar within w_pln_product_barcode_tracking
end type
type ddlb_model_name from uo_set_model_name_ddlb within w_pln_product_barcode_tracking
end type
type st_1 from statictext within w_pln_product_barcode_tracking
end type
type ddlb_line_code from uo_line_code within w_pln_product_barcode_tracking
end type
type st_3 from statictext within w_pln_product_barcode_tracking
end type
type gb_1 from so_groupbox within w_pln_product_barcode_tracking
end type
end forward

global type w_pln_product_barcode_tracking from w_main_root
integer width = 5870
integer height = 3008
string title = "Run No Tacking"
st_mrm_no st_mrm_no
sle_run_no sle_run_no
sle_pcb_serial_no sle_pcb_serial_no
st_2 st_2
uo_dateset uo_dateset
st_4 st_4
uo_dateend uo_dateend
ddlb_model_name ddlb_model_name
st_1 st_1
ddlb_line_code ddlb_line_code
st_3 st_3
gb_1 gb_1
end type
global w_pln_product_barcode_tracking w_pln_product_barcode_tracking

type variables
Long Lvl_row 
String lvs_current_array_type , lvs_last_run_no
String lvs_user_line_code  , lvs_user_machine_code
end variables

on w_pln_product_barcode_tracking.create
int iCurrent
call super::create
this.st_mrm_no=create st_mrm_no
this.sle_run_no=create sle_run_no
this.sle_pcb_serial_no=create sle_pcb_serial_no
this.st_2=create st_2
this.uo_dateset=create uo_dateset
this.st_4=create st_4
this.uo_dateend=create uo_dateend
this.ddlb_model_name=create ddlb_model_name
this.st_1=create st_1
this.ddlb_line_code=create ddlb_line_code
this.st_3=create st_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_mrm_no
this.Control[iCurrent+2]=this.sle_run_no
this.Control[iCurrent+3]=this.sle_pcb_serial_no
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.uo_dateset
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.uo_dateend
this.Control[iCurrent+8]=this.ddlb_model_name
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.ddlb_line_code
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.gb_1
end on

on w_pln_product_barcode_tracking.destroy
call super::destroy
destroy(this.st_mrm_no)
destroy(this.sle_run_no)
destroy(this.sle_pcb_serial_no)
destroy(this.st_2)
destroy(this.uo_dateset)
destroy(this.st_4)
destroy(this.uo_dateend)
destroy(this.ddlb_model_name)
destroy(this.st_1)
destroy(this.ddlb_line_code)
destroy(this.st_3)
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


end event

event ue_data_control;call super::ue_data_control;CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
				DW_1.RETRIEVE( ddlb_line_code.getcode()+'%' ,   ddlb_model_name.getcode() +'%' , sle_run_no.text+'%' , uo_dateset.text() , uo_dateend.text() ,  GVI_ORGANIZATION_ID )

	CASE ELSE
END CHOOSE
end event

type dw_5 from w_main_root`dw_5 within w_pln_product_barcode_tracking
integer y = 512
integer height = 1932
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_pln_product_barcode_tracking
integer y = 512
integer height = 1932
integer taborder = 0
end type

type dw_3 from w_main_root`dw_3 within w_pln_product_barcode_tracking
integer y = 320
integer width = 681
integer height = 456
integer taborder = 0
boolean titlebar = true
end type

type dw_2 from w_main_root`dw_2 within w_pln_product_barcode_tracking
integer x = 2034
integer y = 320
integer width = 2135
integer height = 2140
integer taborder = 0
boolean titlebar = true
string dataobject = "d_pln_product_2D_barcode_tracking"
end type

type dw_1 from w_main_root`dw_1 within w_pln_product_barcode_tracking
integer y = 320
integer width = 2025
integer height = 2140
integer taborder = 0
boolean titlebar = true
string dataobject = "d_ip_product_run_card_4_all_tracking_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
dw_2.retrieve( this.object.run_no[currentrow] , gvi_organization_id )
end event

type uo_tabpages from w_main_root`uo_tabpages within w_pln_product_barcode_tracking
integer taborder = 0
end type

type st_mrm_no from statictext within w_pln_product_barcode_tracking
integer x = 1408
integer y = 84
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

type sle_run_no from so_singlelineedit within w_pln_product_barcode_tracking
integer x = 1403
integer y = 172
integer width = 457
integer taborder = 10
boolean bringtotop = true
long backcolor = 16777215
textcase textcase = upper!
end type

event modified;call super::modified;//
//string  lvs_model_name, lvs_run_no
//
//lvs_run_no = trim(this.text)
//lvs_model_name = ''
//
// select model_name
//   into :lvs_model_name
//  from ip_product_run_card
//where run_no like :lvs_run_no
//    and rownum = 1;
//	 
//if ( f_sql_check() < 0 ) then 
//	
//	  RETURN;
//	  
//end if;
//	 
//	 
//IF ( lvs_model_name = '' OR ISNULL(lvs_model_name) ) THEN
//	sle_model_name.text = ''
//ELSE
//	sle_model_name.text = lvs_model_name 
//END IF;
end event

type sle_pcb_serial_no from so_singlelineedit within w_pln_product_barcode_tracking
integer x = 1865
integer y = 172
integer width = 1019
integer taborder = 20
boolean bringtotop = true
textcase textcase = upper!
end type

event modified;call super::modified;
string lvs_pid, lvs_model_name, lvs_run_no

lvs_pid = trim(this.text)
lvs_model_name = ''
lvs_run_no = ''

 select model_name, run_no
   into :lvs_model_name, :lvs_run_no
  from ip_product_2d_barcode
where serial_no like :lvs_pid
    and rownum = 1;
	 
	 
if ( f_sql_check() < 0 ) then 
	
	  RETURN;
	  
end if;
	 
	 
//IF ( lvs_model_name = '' OR ISNULL(lvs_model_name) ) THEN
//	sle_model_name.text = ''
//    sle_run_no.text = ''	
//ELSE
//	sle_model_name.text = lvs_model_name 
    sle_run_no.text = lvs_run_no  
//END IF;

//DW_1.RESET()
//DW_1.RETRIEVE(   sle_run_no.text , GVI_ORGANIZATION_ID )
end event

type st_2 from statictext within w_pln_product_barcode_tracking
integer x = 1865
integer y = 84
integer width = 1019
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "PCB Serial No"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_dateset from uo_ymd_calendar within w_pln_product_barcode_tracking
event destroy ( )
integer x = 64
integer y = 172
integer taborder = 90
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_4 from so_statictext within w_pln_product_barcode_tracking
integer x = 73
integer y = 84
integer width = 814
integer height = 68
boolean bringtotop = true
string text = "Run Date"
end type

type uo_dateend from uo_ymd_calendar within w_pln_product_barcode_tracking
event destroy ( )
integer x = 485
integer y = 172
integer taborder = 100
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_model_name from uo_set_model_name_ddlb within w_pln_product_barcode_tracking
integer x = 2894
integer y = 172
integer width = 1019
integer height = 1900
integer taborder = 30
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
boolean autohscroll = true
end type

type st_1 from statictext within w_pln_product_barcode_tracking
integer x = 2894
integer y = 88
integer width = 1019
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Mode Name"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_line_code from uo_line_code within w_pln_product_barcode_tracking
integer x = 905
integer y = 172
integer width = 485
integer taborder = 110
boolean bringtotop = true
long backcolor = 16777215
end type

type st_3 from statictext within w_pln_product_barcode_tracking
integer x = 896
integer y = 92
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
string text = "Line Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from so_groupbox within w_pln_product_barcode_tracking
integer width = 3959
integer height = 304
integer taborder = 40
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

