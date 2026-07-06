HA$PBExportHeader$w_qc_pcb_input_scan_master.srw
$PBExportComments$Line Master
forward
global type w_qc_pcb_input_scan_master from w_main_root
end type
type st_line_code from statictext within w_qc_pcb_input_scan_master
end type
type ddlb_line_code from uo_line_code within w_qc_pcb_input_scan_master
end type
type uo_dateset from uo_ymd_calendar within w_qc_pcb_input_scan_master
end type
type uo_dateend from uo_ymd_calendar within w_qc_pcb_input_scan_master
end type
type st_4 from so_statictext within w_qc_pcb_input_scan_master
end type
type uo_item from uo_item_code within w_qc_pcb_input_scan_master
end type
type st_5 from so_statictext within w_qc_pcb_input_scan_master
end type
type sle_pcb_barcode from so_singlelineedit within w_qc_pcb_input_scan_master
end type
type st_3 from so_statictext within w_qc_pcb_input_scan_master
end type
type gb_1 from so_groupbox within w_qc_pcb_input_scan_master
end type
end forward

global type w_qc_pcb_input_scan_master from w_main_root
integer width = 4571
integer height = 2748
string title = "PCB Input Scan List Query"
st_line_code st_line_code
ddlb_line_code ddlb_line_code
uo_dateset uo_dateset
uo_dateend uo_dateend
st_4 st_4
uo_item uo_item
st_5 st_5
sle_pcb_barcode sle_pcb_barcode
st_3 st_3
gb_1 gb_1
end type
global w_qc_pcb_input_scan_master w_qc_pcb_input_scan_master

on w_qc_pcb_input_scan_master.create
int iCurrent
call super::create
this.st_line_code=create st_line_code
this.ddlb_line_code=create ddlb_line_code
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_4=create st_4
this.uo_item=create uo_item
this.st_5=create st_5
this.sle_pcb_barcode=create sle_pcb_barcode
this.st_3=create st_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_line_code
this.Control[iCurrent+2]=this.ddlb_line_code
this.Control[iCurrent+3]=this.uo_dateset
this.Control[iCurrent+4]=this.uo_dateend
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.uo_item
this.Control[iCurrent+7]=this.st_5
this.Control[iCurrent+8]=this.sle_pcb_barcode
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.gb_1
end on

on w_qc_pcb_input_scan_master.destroy
call super::destroy
destroy(this.st_line_code)
destroy(this.ddlb_line_code)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_4)
destroy(this.uo_item)
destroy(this.st_5)
destroy(this.sle_pcb_barcode)
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

end event

event ue_data_control;call super::ue_data_control;long row
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
			dw_1.retrieve( uo_item.text()+'%' ,  sle_pcb_barcode.text+'%' ,  ddlb_line_code.getcode() + '%',  uo_dateset.text() , uo_dateend.text() ,   gvi_organization_id)
			dw_1.setfocus()
			
	case else
end choose


end event

type dw_5 from w_main_root`dw_5 within w_qc_pcb_input_scan_master
integer y = 316
end type

type dw_4 from w_main_root`dw_4 within w_qc_pcb_input_scan_master
integer y = 316
end type

type dw_3 from w_main_root`dw_3 within w_qc_pcb_input_scan_master
integer y = 316
integer width = 4544
integer height = 1388
end type

type dw_2 from w_main_root`dw_2 within w_qc_pcb_input_scan_master
integer y = 316
integer width = 4549
integer height = 828
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_qc_pcb_input_scan_master
integer x = 9
integer y = 320
integer width = 4544
integer height = 2328
boolean titlebar = true
string dataobject = "d_qc_pcb_input_scan_lst"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_qc_pcb_input_scan_master
end type

type st_line_code from statictext within w_qc_pcb_input_scan_master
integer x = 69
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
string text = "Line Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_line_code from uo_line_code within w_qc_pcb_input_scan_master
integer x = 69
integer y = 188
integer taborder = 20
boolean bringtotop = true
end type

type uo_dateset from uo_ymd_calendar within w_qc_pcb_input_scan_master
event destroy ( )
integer x = 2322
integer y = 184
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_qc_pcb_input_scan_master
event destroy ( )
integer x = 2738
integer y = 184
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_4 from so_statictext within w_qc_pcb_input_scan_master
integer x = 2327
integer y = 104
integer width = 814
integer height = 68
boolean bringtotop = true
string text = "Date"
end type

type uo_item from uo_item_code within w_qc_pcb_input_scan_master
integer x = 709
integer y = 188
integer width = 581
integer height = 764
integer taborder = 50
boolean bringtotop = true
end type

type st_5 from so_statictext within w_qc_pcb_input_scan_master
integer x = 709
integer y = 104
integer width = 581
integer height = 68
boolean bringtotop = true
boolean enabled = false
string text = "Item Code"
end type

type sle_pcb_barcode from so_singlelineedit within w_qc_pcb_input_scan_master
integer x = 1298
integer y = 188
integer width = 997
integer height = 84
integer taborder = 50
boolean bringtotop = true
end type

type st_3 from so_statictext within w_qc_pcb_input_scan_master
integer x = 1298
integer y = 104
integer width = 997
integer height = 68
boolean bringtotop = true
string text = "PCB Barcode"
end type

type gb_1 from so_groupbox within w_qc_pcb_input_scan_master
integer x = 9
integer width = 3173
integer height = 304
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

