HA$PBExportHeader$w_smt_pickup_rate_rpt.srw
forward
global type w_smt_pickup_rate_rpt from w_main_root
end type
type rb_master_plan_by_order_no from so_radiobutton within w_smt_pickup_rate_rpt
end type
type rb_weekly_assembly_plan from so_radiobutton within w_smt_pickup_rate_rpt
end type
type st_5 from so_statictext within w_smt_pickup_rate_rpt
end type
type uo_dateset from uo_ymd_calendar within w_smt_pickup_rate_rpt
end type
type uo_datend from uo_ymd_calendar within w_smt_pickup_rate_rpt
end type
type ddlb_line_code from uo_line_code_dd within w_smt_pickup_rate_rpt
end type
type st_1 from so_statictext within w_smt_pickup_rate_rpt
end type
type em_price from so_editmask within w_smt_pickup_rate_rpt
end type
type st_2 from so_statictext within w_smt_pickup_rate_rpt
end type
type rb_1 from so_radiobutton within w_smt_pickup_rate_rpt
end type
type sle_item_code from singlelineedit within w_smt_pickup_rate_rpt
end type
type st_3 from so_statictext within w_smt_pickup_rate_rpt
end type
type gb_1 from groupbox within w_smt_pickup_rate_rpt
end type
type gb_2 from so_groupbox within w_smt_pickup_rate_rpt
end type
end forward

global type w_smt_pickup_rate_rpt from w_main_root
integer width = 4791
integer height = 2648
string title = "Pickup Rate Report"
string ivs_set_column_dddw1 = "Y"
string ivs_set_column_dddw2 = "Y"
string ivs_set_column_dddw3 = "Y"
string ivs_set_column_dddw4 = "Y"
string ivs_set_column_dddw5 = "Y"
rb_master_plan_by_order_no rb_master_plan_by_order_no
rb_weekly_assembly_plan rb_weekly_assembly_plan
st_5 st_5
uo_dateset uo_dateset
uo_datend uo_datend
ddlb_line_code ddlb_line_code
st_1 st_1
em_price em_price
st_2 st_2
rb_1 rb_1
sle_item_code sle_item_code
st_3 st_3
gb_1 gb_1
gb_2 gb_2
end type
global w_smt_pickup_rate_rpt w_smt_pickup_rate_rpt

type variables

end variables

on w_smt_pickup_rate_rpt.create
int iCurrent
call super::create
this.rb_master_plan_by_order_no=create rb_master_plan_by_order_no
this.rb_weekly_assembly_plan=create rb_weekly_assembly_plan
this.st_5=create st_5
this.uo_dateset=create uo_dateset
this.uo_datend=create uo_datend
this.ddlb_line_code=create ddlb_line_code
this.st_1=create st_1
this.em_price=create em_price
this.st_2=create st_2
this.rb_1=create rb_1
this.sle_item_code=create sle_item_code
this.st_3=create st_3
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_master_plan_by_order_no
this.Control[iCurrent+2]=this.rb_weekly_assembly_plan
this.Control[iCurrent+3]=this.st_5
this.Control[iCurrent+4]=this.uo_dateset
this.Control[iCurrent+5]=this.uo_datend
this.Control[iCurrent+6]=this.ddlb_line_code
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.em_price
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.rb_1
this.Control[iCurrent+11]=this.sle_item_code
this.Control[iCurrent+12]=this.st_3
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.gb_2
end on

on w_smt_pickup_rate_rpt.destroy
call super::destroy
destroy(this.rb_master_plan_by_order_no)
destroy(this.rb_weekly_assembly_plan)
destroy(this.st_5)
destroy(this.uo_dateset)
destroy(this.uo_datend)
destroy(this.ddlb_line_code)
destroy(this.st_1)
destroy(this.em_price)
destroy(this.st_2)
destroy(this.rb_1)
destroy(this.sle_item_code)
destroy(this.st_3)
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
		
		if rb_master_plan_by_order_no.checked = true then 

		 	dw_1.retrieve(ddlb_line_code.getcode(),  uo_dateset.uf_get_ymd_dt() , uo_datend.uf_get_ymd_dt(), (em_price.text), sle_item_code.text+'%')
			dw_1.setfocus()
			
		elseif rb_weekly_assembly_plan.checked = true then 
			dw_2.retrieve(ddlb_line_code.getcode(),  uo_dateset.uf_get_ymd_dt() , uo_datend.uf_get_ymd_dt(), (em_price.text), sle_item_code.text+'%' )
			dw_2.setfocus()			
		
	    else 
		    dw_3.retrieve(ddlb_line_code.getcode(),  uo_dateset.uf_get_ymd_dt() , uo_datend.uf_get_ymd_dt(), (em_price.text), sle_item_code.text+'%' )
		    dw_3.setfocus()
		end if 
				
	CASE ELSE
END CHOOSE
end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())


em_price.text = '0.0000'
end event

type dw_5 from w_main_root`dw_5 within w_smt_pickup_rate_rpt
integer y = 316
end type

type dw_4 from w_main_root`dw_4 within w_smt_pickup_rate_rpt
integer y = 316
end type

type dw_3 from w_main_root`dw_3 within w_smt_pickup_rate_rpt
integer y = 316
integer width = 4507
integer height = 2120
boolean titlebar = true
string dataobject = "d_pickup_rate_by_LINE_amt_rpt"
end type

type dw_2 from w_main_root`dw_2 within w_smt_pickup_rate_rpt
integer y = 316
integer width = 4507
integer height = 2120
integer taborder = 0
boolean titlebar = true
string dataobject = "d_pickup_rate_by_period_amt_rpt"
end type

type dw_1 from w_main_root`dw_1 within w_smt_pickup_rate_rpt
integer y = 316
integer width = 4507
integer height = 2120
integer taborder = 0
boolean titlebar = true
string title = "Pick-Up Rate By Period"
string dataobject = "d_pickup_rate_by_period_rpt"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_smt_pickup_rate_rpt
end type

type rb_master_plan_by_order_no from so_radiobutton within w_smt_pickup_rate_rpt
integer x = 50
integer y = 60
integer width = 855
boolean bringtotop = true
integer weight = 700
string text = "Pickup Rate by Period"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1

end event

type rb_weekly_assembly_plan from so_radiobutton within w_smt_pickup_rate_rpt
integer x = 50
integer y = 136
integer width = 855
boolean bringtotop = true
integer weight = 700
string text = "PickUp Amount by Period"
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
selected_data_window = dw_2
end event

type st_5 from so_statictext within w_smt_pickup_rate_rpt
integer x = 1650
integer y = 96
integer width = 841
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Production Date"
end type

type uo_dateset from uo_ymd_calendar within w_smt_pickup_rate_rpt
event destroy ( )
integer x = 1646
integer y = 176
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_datend from uo_ymd_calendar within w_smt_pickup_rate_rpt
event destroy ( )
integer x = 2071
integer y = 176
integer taborder = 50
boolean bringtotop = true
end type

on uo_datend.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_line_code from uo_line_code_dd within w_smt_pickup_rate_rpt
integer x = 992
integer y = 176
integer taborder = 40
boolean bringtotop = true
end type

type st_1 from so_statictext within w_smt_pickup_rate_rpt
integer x = 992
integer y = 96
integer width = 631
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Line"
end type

type em_price from so_editmask within w_smt_pickup_rate_rpt
integer x = 2496
integer y = 176
integer taborder = 40
boolean bringtotop = true
integer weight = 400
alignment alignment = center!
string mask = "###,##0.0000"
end type

type st_2 from so_statictext within w_smt_pickup_rate_rpt
integer x = 2505
integer y = 92
integer width = 402
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Unit Price >"
end type

type rb_1 from so_radiobutton within w_smt_pickup_rate_rpt
integer x = 50
integer y = 216
integer width = 855
boolean bringtotop = true
integer weight = 700
string text = "PickUp Amount by Line"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3
end event

type sle_item_code from singlelineedit within w_smt_pickup_rate_rpt
integer x = 2912
integer y = 176
integer width = 782
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "%"
borderstyle borderstyle = stylelowered!
end type

type st_3 from so_statictext within w_smt_pickup_rate_rpt
integer x = 3077
integer y = 92
integer width = 402
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Part No"
end type

type gb_1 from groupbox within w_smt_pickup_rate_rpt
integer x = 951
integer width = 2798
integer height = 304
integer taborder = 30
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

type gb_2 from so_groupbox within w_smt_pickup_rate_rpt
integer width = 933
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

