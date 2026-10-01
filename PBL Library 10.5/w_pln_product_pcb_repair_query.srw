HA$PBExportHeader$w_pln_product_pcb_repair_query.srw
$PBExportComments$Line Master
forward
global type w_pln_product_pcb_repair_query from w_main_root
end type
type sle_pcb_serial_no from so_singlelineedit within w_pln_product_pcb_repair_query
end type
type st_2 from statictext within w_pln_product_pcb_repair_query
end type
type ddlb_line_code from uo_line_code within w_pln_product_pcb_repair_query
end type
type st_3 from statictext within w_pln_product_pcb_repair_query
end type
type sle_model_name from so_singlelineedit within w_pln_product_pcb_repair_query
end type
type st_4 from statictext within w_pln_product_pcb_repair_query
end type
type uo_dateset from uo_ymd_calendar within w_pln_product_pcb_repair_query
end type
type st_5 from so_statictext within w_pln_product_pcb_repair_query
end type
type uo_dateend from uo_ymd_calendar within w_pln_product_pcb_repair_query
end type
type ddlb_inspect_handling from uo_basecode within w_pln_product_pcb_repair_query
end type
type st_6 from statictext within w_pln_product_pcb_repair_query
end type
type ddlb_receipt_deficit from uo_basecode within w_pln_product_pcb_repair_query
end type
type st_7 from statictext within w_pln_product_pcb_repair_query
end type
type rb_list from so_radiobutton within w_pln_product_pcb_repair_query
end type
type rb_model from so_radiobutton within w_pln_product_pcb_repair_query
end type
type ddlb_repair_result_code from uo_basecode within w_pln_product_pcb_repair_query
end type
type st_8 from so_statictext within w_pln_product_pcb_repair_query
end type
type rb_inventory from so_radiobutton within w_pln_product_pcb_repair_query
end type
type rb_summary from so_radiobutton within w_pln_product_pcb_repair_query
end type
type rb_position from so_radiobutton within w_pln_product_pcb_repair_query
end type
type gb_2 from so_groupbox within w_pln_product_pcb_repair_query
end type
type gb_1 from so_groupbox within w_pln_product_pcb_repair_query
end type
end forward

global type w_pln_product_pcb_repair_query from w_main_root
integer width = 5102
integer height = 3460
string title = "WQC Repair History Query"
sle_pcb_serial_no sle_pcb_serial_no
st_2 st_2
ddlb_line_code ddlb_line_code
st_3 st_3
sle_model_name sle_model_name
st_4 st_4
uo_dateset uo_dateset
st_5 st_5
uo_dateend uo_dateend
ddlb_inspect_handling ddlb_inspect_handling
st_6 st_6
ddlb_receipt_deficit ddlb_receipt_deficit
st_7 st_7
rb_list rb_list
rb_model rb_model
ddlb_repair_result_code ddlb_repair_result_code
st_8 st_8
rb_inventory rb_inventory
rb_summary rb_summary
rb_position rb_position
gb_2 gb_2
gb_1 gb_1
end type
global w_pln_product_pcb_repair_query w_pln_product_pcb_repair_query

type variables
Long Lvl_row
end variables

on w_pln_product_pcb_repair_query.create
int iCurrent
call super::create
this.sle_pcb_serial_no=create sle_pcb_serial_no
this.st_2=create st_2
this.ddlb_line_code=create ddlb_line_code
this.st_3=create st_3
this.sle_model_name=create sle_model_name
this.st_4=create st_4
this.uo_dateset=create uo_dateset
this.st_5=create st_5
this.uo_dateend=create uo_dateend
this.ddlb_inspect_handling=create ddlb_inspect_handling
this.st_6=create st_6
this.ddlb_receipt_deficit=create ddlb_receipt_deficit
this.st_7=create st_7
this.rb_list=create rb_list
this.rb_model=create rb_model
this.ddlb_repair_result_code=create ddlb_repair_result_code
this.st_8=create st_8
this.rb_inventory=create rb_inventory
this.rb_summary=create rb_summary
this.rb_position=create rb_position
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_pcb_serial_no
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.ddlb_line_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.sle_model_name
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.uo_dateset
this.Control[iCurrent+8]=this.st_5
this.Control[iCurrent+9]=this.uo_dateend
this.Control[iCurrent+10]=this.ddlb_inspect_handling
this.Control[iCurrent+11]=this.st_6
this.Control[iCurrent+12]=this.ddlb_receipt_deficit
this.Control[iCurrent+13]=this.st_7
this.Control[iCurrent+14]=this.rb_list
this.Control[iCurrent+15]=this.rb_model
this.Control[iCurrent+16]=this.ddlb_repair_result_code
this.Control[iCurrent+17]=this.st_8
this.Control[iCurrent+18]=this.rb_inventory
this.Control[iCurrent+19]=this.rb_summary
this.Control[iCurrent+20]=this.rb_position
this.Control[iCurrent+21]=this.gb_2
this.Control[iCurrent+22]=this.gb_1
end on

on w_pln_product_pcb_repair_query.destroy
call super::destroy
destroy(this.sle_pcb_serial_no)
destroy(this.st_2)
destroy(this.ddlb_line_code)
destroy(this.st_3)
destroy(this.sle_model_name)
destroy(this.st_4)
destroy(this.uo_dateset)
destroy(this.st_5)
destroy(this.uo_dateend)
destroy(this.ddlb_inspect_handling)
destroy(this.st_6)
destroy(this.ddlb_receipt_deficit)
destroy(this.st_7)
destroy(this.rb_list)
destroy(this.rb_model)
destroy(this.ddlb_repair_result_code)
destroy(this.st_8)
destroy(this.rb_inventory)
destroy(this.rb_summary)
destroy(this.rb_position)
destroy(this.gb_2)
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

event ue_data_control;call super::ue_data_control;CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		   
			
			if rb_list.checked = true then 
				dw_1.reset()
				DW_1.RETRIEVE(  sle_model_name.text+'%' , sle_pcb_serial_no.TEXT+'%' , ddlb_line_code.getcode()+'%' , uo_dateset.text() , uo_dateend.text() ,ddlb_receipt_deficit.getcode()+'%' ,  ddlb_inspect_handling.getcode()+'%' ,  ddlb_repair_result_code.getcode( )+'%' , GVI_ORGANIZATION_ID )
				sle_pcb_serial_no.setfocus()
			elseif rb_model.checked = true then 
				dw_2.reset()
				DW_2.RETRIEVE(  sle_model_name.text+'%' , sle_pcb_serial_no.TEXT +'%', ddlb_line_code.getcode()+'%'  , uo_dateset.text() , uo_dateend.text() ,ddlb_receipt_deficit.getcode()+'%' ,  ddlb_inspect_handling.getcode()+'%' , ddlb_repair_result_code.getcode( )+'%' , GVI_ORGANIZATION_ID )
				sle_pcb_serial_no.setfocus()
			elseif rb_inventory.checked = true then 
				dw_3.reset()
				DW_3.RETRIEVE(  sle_model_name.text+'%' , sle_pcb_serial_no.TEXT +'%' , ddlb_line_code.getcode()+'%' , ddlb_inspect_handling.getcode()+'%' , ddlb_repair_result_code.getcode( )+'%' , GVI_ORGANIZATION_ID )
				sle_pcb_serial_no.setfocus()
			elseif rb_summary.checked = true then 
				
				dw_4.reset()
				DW_4.RETRIEVE( uo_dateset.text() , uo_dateend.text() , ddlb_line_code.getcode()+'%' ,  sle_model_name.text+'%' , GVS_LANGUAGE , GVI_ORGANIZATION_ID )
			else
								dw_5.reset()
				DW_5.RETRIEVE( uo_dateset.text() , uo_dateend.text() , ddlb_line_code.getcode()+'%' ,  sle_model_name.text+'%' , GVS_LANGUAGE , GVI_ORGANIZATION_ID )
			
			end if 

	CASE ELSE
END CHOOSE


end event

type dw_5 from w_main_root`dw_5 within w_pln_product_pcb_repair_query
integer x = 9
integer y = 452
integer width = 3648
integer height = 776
integer taborder = 0
boolean titlebar = true
string title = "NG Position Summary"
string dataobject = "d_pln_product_work_qc_4_position_summary_lst_q"
end type

type dw_4 from w_main_root`dw_4 within w_pln_product_pcb_repair_query
integer x = 9
integer y = 452
integer width = 4005
integer height = 2312
integer taborder = 0
boolean titlebar = true
string title = "Daily Summary"
string dataobject = "d_pln_product_work_qc_4_daily_summary_lst_q"
end type

type dw_3 from w_main_root`dw_3 within w_pln_product_pcb_repair_query
integer x = 9
integer y = 452
integer width = 4005
integer height = 2312
integer taborder = 0
boolean titlebar = true
string title = "Inventory"
string dataobject = "d_pln_product_work_qc_4_inventory_lst_q"
end type

type dw_2 from w_main_root`dw_2 within w_pln_product_pcb_repair_query
integer x = 9
integer y = 452
integer width = 4005
integer height = 2312
integer taborder = 0
boolean titlebar = true
string title = "Model"
string dataobject = "d_pln_product_work_qc_4_model_lst_q"
end type

type dw_1 from w_main_root`dw_1 within w_pln_product_pcb_repair_query
integer x = 9
integer y = 452
integer width = 4005
integer height = 2312
integer taborder = 0
boolean titlebar = true
string title = "List"
string dataobject = "d_pln_product_work_qc_hst_q"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;lvl_row = currentrow
end event

type uo_tabpages from w_main_root`uo_tabpages within w_pln_product_pcb_repair_query
integer taborder = 0
end type

type sle_pcb_serial_no from so_singlelineedit within w_pln_product_pcb_repair_query
integer x = 1038
integer y = 212
integer width = 613
integer taborder = 1
boolean bringtotop = true
textcase textcase = upper!
end type

type st_2 from statictext within w_pln_product_pcb_repair_query
integer x = 1038
integer y = 128
integer width = 613
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

type ddlb_line_code from uo_line_code within w_pln_product_pcb_repair_query
integer x = 1659
integer y = 208
integer width = 485
boolean bringtotop = true
long backcolor = 16777215
end type

type st_3 from statictext within w_pln_product_pcb_repair_query
integer x = 1655
integer y = 128
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
string text = "Defect Line Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_model_name from so_singlelineedit within w_pln_product_pcb_repair_query
integer x = 2158
integer y = 212
integer width = 535
integer height = 76
boolean bringtotop = true
textcase textcase = upper!
end type

type st_4 from statictext within w_pln_product_pcb_repair_query
integer x = 2158
integer y = 128
integer width = 535
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

type uo_dateset from uo_ymd_calendar within w_pln_product_pcb_repair_query
event destroy ( )
integer x = 3502
integer y = 208
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_5 from so_statictext within w_pln_product_pcb_repair_query
integer x = 3529
integer y = 128
integer width = 795
integer height = 68
boolean bringtotop = true
string text = "Qc Date"
end type

type uo_dateend from uo_ymd_calendar within w_pln_product_pcb_repair_query
event destroy ( )
integer x = 3922
integer y = 208
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_inspect_handling from uo_basecode within w_pln_product_pcb_repair_query
integer x = 2702
integer y = 208
integer width = 475
integer height = 832
integer taborder = 21
boolean bringtotop = true
end type

event constructor;call super::constructor;THIS.REdraw( "QC INSPECT HANDLING")
end event

type st_6 from statictext within w_pln_product_pcb_repair_query
integer x = 2702
integer y = 132
integer width = 475
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "QC Inspect Handling"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_receipt_deficit from uo_basecode within w_pln_product_pcb_repair_query
integer x = 3182
integer y = 208
integer width = 320
integer height = 832
integer taborder = 31
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( "RECEIPT DEFICIT")
end event

type st_7 from statictext within w_pln_product_pcb_repair_query
integer x = 3182
integer y = 132
integer width = 320
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Receipt Deficit"
alignment alignment = center!
boolean focusrectangle = false
end type

type rb_list from so_radiobutton within w_pln_product_pcb_repair_query
integer x = 64
integer y = 80
integer width = 393
boolean bringtotop = true
string text = "List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1
end event

type rb_model from so_radiobutton within w_pln_product_pcb_repair_query
integer x = 64
integer y = 184
integer width = 393
boolean bringtotop = true
string text = "Model"
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
selected_data_window = dw_2
end event

type ddlb_repair_result_code from uo_basecode within w_pln_product_pcb_repair_query
integer x = 4343
integer y = 208
integer width = 462
integer height = 832
integer taborder = 31
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'REPAIR RESULT CODE')
end event

type st_8 from so_statictext within w_pln_product_pcb_repair_query
integer x = 4343
integer y = 124
integer width = 462
integer height = 68
boolean bringtotop = true
string text = "Repair Result Code"
end type

type rb_inventory from so_radiobutton within w_pln_product_pcb_repair_query
integer x = 64
integer y = 288
integer width = 393
boolean bringtotop = true
string text = "Inventory"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3
end event

type rb_summary from so_radiobutton within w_pln_product_pcb_repair_query
integer x = 453
integer y = 80
integer width = 393
boolean bringtotop = true
string text = "Daily Summary"
end type

event clicked;call super::clicked;dw_4.bringtotop = true 
selected_data_window = dw_4
end event

type rb_position from so_radiobutton within w_pln_product_pcb_repair_query
integer x = 453
integer y = 184
integer width = 453
boolean bringtotop = true
string text = "Position Summary"
end type

event clicked;call super::clicked;dw_5.bringtotop = true 
selected_data_window = dw_5
end event

type gb_2 from so_groupbox within w_pln_product_pcb_repair_query
integer x = 1006
integer y = 4
integer width = 3835
integer height = 432
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_1 from so_groupbox within w_pln_product_pcb_repair_query
integer width = 987
integer height = 428
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

