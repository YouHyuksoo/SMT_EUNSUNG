HA$PBExportHeader$w_product_pid_tracking_fpcb_rpt.srw
$PBExportComments$new a led project
forward
global type w_product_pid_tracking_fpcb_rpt from w_main_root
end type
type sle_pcb_serial_no from so_singlelineedit within w_product_pid_tracking_fpcb_rpt
end type
type st_1 from so_statictext within w_product_pid_tracking_fpcb_rpt
end type
type sle_run_no from so_singlelineedit within w_product_pid_tracking_fpcb_rpt
end type
type st_mrm_no from statictext within w_product_pid_tracking_fpcb_rpt
end type
type st_4 from statictext within w_product_pid_tracking_fpcb_rpt
end type
type sle_model_name from so_singlelineedit within w_product_pid_tracking_fpcb_rpt
end type
type cb_print from commandbutton within w_product_pid_tracking_fpcb_rpt
end type
type gb_2 from so_groupbox within w_product_pid_tracking_fpcb_rpt
end type
end forward

global type w_product_pid_tracking_fpcb_rpt from w_main_root
string title = "PID Tracking Query"
sle_pcb_serial_no sle_pcb_serial_no
st_1 st_1
sle_run_no sle_run_no
st_mrm_no st_mrm_no
st_4 st_4
sle_model_name sle_model_name
cb_print cb_print
gb_2 gb_2
end type
global w_product_pid_tracking_fpcb_rpt w_product_pid_tracking_fpcb_rpt

type variables

end variables

on w_product_pid_tracking_fpcb_rpt.create
int iCurrent
call super::create
this.sle_pcb_serial_no=create sle_pcb_serial_no
this.st_1=create st_1
this.sle_run_no=create sle_run_no
this.st_mrm_no=create st_mrm_no
this.st_4=create st_4
this.sle_model_name=create sle_model_name
this.cb_print=create cb_print
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_pcb_serial_no
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_run_no
this.Control[iCurrent+4]=this.st_mrm_no
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.sle_model_name
this.Control[iCurrent+7]=this.cb_print
this.Control[iCurrent+8]=this.gb_2
end on

on w_product_pid_tracking_fpcb_rpt.destroy
call super::destroy
destroy(this.sle_pcb_serial_no)
destroy(this.st_1)
destroy(this.sle_run_no)
destroy(this.st_mrm_no)
destroy(this.st_4)
destroy(this.sle_model_name)
destroy(this.cb_print)
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
Ivs_resize_type                      = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
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

			if sle_pcb_serial_no.text = '' or isnull(sle_pcb_serial_no.text) then 
				return
			end if 
			
			DW_1.RESET( )
			DW_1.RETRIEVE( sle_pcb_serial_no.text , gvi_organization_id )
			
			f_set_column_dddw( dw_1 )
	//		f_dual_lang_change_dwtext( dw_1 )
			
	CASE ELSE
		
END CHOOSE
end event

type dw_5 from w_main_root`dw_5 within w_product_pid_tracking_fpcb_rpt
integer y = 392
end type

type dw_4 from w_main_root`dw_4 within w_product_pid_tracking_fpcb_rpt
integer y = 392
boolean titlebar = true
end type

type dw_3 from w_main_root`dw_3 within w_product_pid_tracking_fpcb_rpt
integer y = 392
boolean titlebar = true
boolean controlmenu = true
boolean minbox = true
end type

type dw_2 from w_main_root`dw_2 within w_product_pid_tracking_fpcb_rpt
integer y = 392
boolean titlebar = true
string title = "Item"
boolean controlmenu = true
boolean minbox = true
end type

type dw_1 from w_main_root`dw_1 within w_product_pid_tracking_fpcb_rpt
integer y = 392
integer width = 3662
integer height = 1356
boolean titlebar = true
string title = "PID Tracking"
string dataobject = "d_ip_product_pid_tracking_fpcb_rpt_k"
boolean controlmenu = true
boolean minbox = true
end type

type uo_tabpages from w_main_root`uo_tabpages within w_product_pid_tracking_fpcb_rpt
end type

type sle_pcb_serial_no from so_singlelineedit within w_product_pid_tracking_fpcb_rpt
integer x = 50
integer y = 188
integer width = 1591
integer height = 88
integer taborder = 310
boolean bringtotop = true
integer weight = 700
end type

event modified;call super::modified;


sle_run_no.text         = f_get_run_no_by_serial(this.text)
sle_model_name.text = f_get_model_name_by_run_no(sle_run_no.text)

if sle_pcb_serial_no.text = '' or isnull(sle_pcb_serial_no.text) then 
	return
end if 
			
DW_1.RESET( )
DW_1.RETRIEVE( sle_pcb_serial_no.text , gvi_organization_id )
		
		
OPEN(w_please_wait_popup)
w_please_wait_popup.st_msg.text = "$$HEX17$$94cd01c870b374c730d12000ddc031c111c9200030aee4b224b82000fcc838c194c6$$ENDHEX$$..."
f_set_column_dddw( dw_1 )
f_dual_lang_change_dwtext( dw_1 )
CLOSE(w_please_wait_popup)
end event

event rbuttondown;call super::rbuttondown;open( w_pln_serial_info_popup)

if gst_return.gvb_return = TRUE THEN 

this.text = message.stringparm

END IF 
end event

type st_1 from so_statictext within w_product_pid_tracking_fpcb_rpt
integer x = 50
integer y = 120
integer width = 1591
integer height = 72
boolean bringtotop = true
string text = "2D Barcode"
end type

type sle_run_no from so_singlelineedit within w_product_pid_tracking_fpcb_rpt
integer x = 1650
integer y = 184
integer width = 617
integer height = 88
integer taborder = 320
boolean bringtotop = true
boolean enabled = false
textcase textcase = upper!
end type

type st_mrm_no from statictext within w_product_pid_tracking_fpcb_rpt
integer x = 1650
integer y = 104
integer width = 617
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

type st_4 from statictext within w_product_pid_tracking_fpcb_rpt
integer x = 2555
integer y = 104
integer width = 631
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

type sle_model_name from so_singlelineedit within w_product_pid_tracking_fpcb_rpt
integer x = 2555
integer y = 188
integer width = 631
integer height = 88
integer taborder = 330
boolean bringtotop = true
boolean enabled = false
textcase textcase = upper!
end type

type cb_print from commandbutton within w_product_pid_tracking_fpcb_rpt
integer x = 3355
integer y = 140
integer width = 640
integer height = 128
integer taborder = 100
boolean bringtotop = true
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Print"
end type

event clicked;
//if dw_1.Describe("DataWindow.Print.Preview") = '!' or dw_1.Describe("DataWindow.Print.Preview") = '?' then
//else
//	 dw_1.Modify("DataWindow.Print.Preview=yes")
//	 dw_1.Modify("DataWindow.Print.Preview.Rulers=yes")
//end if	
//
//if dw_1.rowcount( ) > 0 then 
//	dw_1.print( TRUE)
//end if 

openwithparm(w_zetprint , dw_1 )
end event

type gb_2 from so_groupbox within w_product_pid_tracking_fpcb_rpt
integer width = 3264
integer height = 364
integer taborder = 90
string text = "Where Condition"
end type

