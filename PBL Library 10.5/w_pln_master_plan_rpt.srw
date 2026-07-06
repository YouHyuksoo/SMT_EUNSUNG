HA$PBExportHeader$w_pln_master_plan_rpt.srw
forward
global type w_pln_master_plan_rpt from w_main_root
end type
type st_2 from statictext within w_pln_master_plan_rpt
end type
type ddlb_customer_code from uo_customer_code within w_pln_master_plan_rpt
end type
type ddlb_line_code from uo_line_code within w_pln_master_plan_rpt
end type
type st_3 from statictext within w_pln_master_plan_rpt
end type
type rb_master_plan_by_order_no from so_radiobutton within w_pln_master_plan_rpt
end type
type rb_weekly_assembly_plan from so_radiobutton within w_pln_master_plan_rpt
end type
type st_5 from so_statictext within w_pln_master_plan_rpt
end type
type uo_dateset from uo_ymd_calendar within w_pln_master_plan_rpt
end type
type rb_daily_master_plan from so_radiobutton within w_pln_master_plan_rpt
end type
type rb_1 from so_radiobutton within w_pln_master_plan_rpt
end type
type ddlb_model_name from uo_set_model_name_ddlb within w_pln_master_plan_rpt
end type
type st_4 from statictext within w_pln_master_plan_rpt
end type
type gb_1 from groupbox within w_pln_master_plan_rpt
end type
type gb_2 from so_groupbox within w_pln_master_plan_rpt
end type
end forward

global type w_pln_master_plan_rpt from w_main_root
integer width = 5550
integer height = 2648
string title = "Product Master Plan Report"
st_2 st_2
ddlb_customer_code ddlb_customer_code
ddlb_line_code ddlb_line_code
st_3 st_3
rb_master_plan_by_order_no rb_master_plan_by_order_no
rb_weekly_assembly_plan rb_weekly_assembly_plan
st_5 st_5
uo_dateset uo_dateset
rb_daily_master_plan rb_daily_master_plan
rb_1 rb_1
ddlb_model_name ddlb_model_name
st_4 st_4
gb_1 gb_1
gb_2 gb_2
end type
global w_pln_master_plan_rpt w_pln_master_plan_rpt

type variables

end variables

on w_pln_master_plan_rpt.create
int iCurrent
call super::create
this.st_2=create st_2
this.ddlb_customer_code=create ddlb_customer_code
this.ddlb_line_code=create ddlb_line_code
this.st_3=create st_3
this.rb_master_plan_by_order_no=create rb_master_plan_by_order_no
this.rb_weekly_assembly_plan=create rb_weekly_assembly_plan
this.st_5=create st_5
this.uo_dateset=create uo_dateset
this.rb_daily_master_plan=create rb_daily_master_plan
this.rb_1=create rb_1
this.ddlb_model_name=create ddlb_model_name
this.st_4=create st_4
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.ddlb_customer_code
this.Control[iCurrent+3]=this.ddlb_line_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.rb_master_plan_by_order_no
this.Control[iCurrent+6]=this.rb_weekly_assembly_plan
this.Control[iCurrent+7]=this.st_5
this.Control[iCurrent+8]=this.uo_dateset
this.Control[iCurrent+9]=this.rb_daily_master_plan
this.Control[iCurrent+10]=this.rb_1
this.Control[iCurrent+11]=this.ddlb_model_name
this.Control[iCurrent+12]=this.st_4
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.gb_2
end on

on w_pln_master_plan_rpt.destroy
call super::destroy
destroy(this.st_2)
destroy(this.ddlb_customer_code)
destroy(this.ddlb_line_code)
destroy(this.st_3)
destroy(this.rb_master_plan_by_order_no)
destroy(this.rb_weekly_assembly_plan)
destroy(this.st_5)
destroy(this.uo_dateset)
destroy(this.rb_daily_master_plan)
destroy(this.rb_1)
destroy(this.ddlb_model_name)
destroy(this.st_4)
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
				
			dw_1.retrieve(uo_dateset.text()  , ddlb_line_code.getcode()+'%' ,  ddlb_customer_code.text+'%' ,   ddlb_model_name.getcode()+'%' ,  gvi_organization_id)
			dw_1.setfocus()
			
		elseif rb_weekly_assembly_plan.checked = true then 
			dw_2.retrieve( uo_dateset.text(), ddlb_line_code.getcode()+'%' ,  ddlb_customer_code.text+'%' ,  ddlb_model_name.getcode()+'%' ,  gvi_organization_id)
			dw_2.setfocus()			
		elseif rb_daily_master_plan.checked = true then 
			dw_3.retrieve(uo_dateset.text()  ,  ddlb_line_code.getcode()+'%' ,  ddlb_customer_code.text+'%' ,  ddlb_model_name.getcode()+'%' ,  gvi_organization_id)		
		else
			dw_4.retrieve(uo_dateset.text()  , ddlb_line_code.getcode()+'%' ,  ddlb_customer_code.text+'%' ,  ddlb_model_name.getcode()+'%' ,  gvi_organization_id)		
		end if 
				
	CASE ELSE
END CHOOSE
end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_pln_master_plan_rpt
integer y = 316
end type

type dw_4 from w_main_root`dw_4 within w_pln_master_plan_rpt
integer y = 316
integer width = 4215
integer height = 1764
boolean titlebar = true
string dataobject = "d_pln_assembly_plan_matrix_rpt"
end type

type dw_3 from w_main_root`dw_3 within w_pln_master_plan_rpt
integer y = 316
integer width = 4507
integer height = 2120
boolean titlebar = true
string dataobject = "d_pln_master_plan_matrix_rpt"
end type

type dw_2 from w_main_root`dw_2 within w_pln_master_plan_rpt
integer y = 316
integer width = 4507
integer height = 2120
integer taborder = 0
boolean titlebar = true
string dataobject = "d_pln_weekly_assembly_master_plan_rpt"
end type

type dw_1 from w_main_root`dw_1 within w_pln_master_plan_rpt
integer y = 316
integer width = 4507
integer height = 2120
integer taborder = 0
boolean titlebar = true
string title = "Weekly Master Plan List"
string dataobject = "d_pln_master_plan_weekly_matrix_rpt"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_pln_master_plan_rpt
end type

type st_2 from statictext within w_pln_master_plan_rpt
integer x = 3173
integer y = 92
integer width = 617
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Customer Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_customer_code from uo_customer_code within w_pln_master_plan_rpt
integer x = 3173
integer y = 180
integer width = 617
integer height = 1608
integer taborder = 30
boolean bringtotop = true
end type

type ddlb_line_code from uo_line_code within w_pln_master_plan_rpt
integer x = 3799
integer y = 180
integer width = 581
integer height = 1608
integer taborder = 40
boolean bringtotop = true
boolean allowedit = true
end type

type st_3 from statictext within w_pln_master_plan_rpt
integer x = 3799
integer y = 92
integer width = 581
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Line Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type rb_master_plan_by_order_no from so_radiobutton within w_pln_master_plan_rpt
integer x = 50
integer y = 80
integer width = 855
boolean bringtotop = true
integer weight = 700
string text = "Weekly Product Plan"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1

end event

type rb_weekly_assembly_plan from so_radiobutton within w_pln_master_plan_rpt
integer x = 50
integer y = 184
integer width = 855
boolean bringtotop = true
integer weight = 700
string text = "Weekly SMT Plan"
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
selected_data_window = dw_2
end event

type st_5 from so_statictext within w_pln_master_plan_rpt
integer x = 2030
integer y = 100
integer width = 411
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Plan Date"
end type

type uo_dateset from uo_ymd_calendar within w_pln_master_plan_rpt
event destroy ( )
integer x = 2025
integer y = 180
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type rb_daily_master_plan from so_radiobutton within w_pln_master_plan_rpt
integer x = 891
integer y = 72
integer width = 855
boolean bringtotop = true
integer weight = 700
string text = "Daily Product Plan"
end type

event clicked;call super::clicked;dw_3.bringtotop = true
selected_data_window = dw_3
end event

type rb_1 from so_radiobutton within w_pln_master_plan_rpt
integer x = 891
integer y = 172
integer width = 855
boolean bringtotop = true
integer weight = 700
string text = "Daily SMT Plan"
end type

event clicked;call super::clicked;dw_4.bringtotop = true
selected_data_window = dw_4
end event

type ddlb_model_name from uo_set_model_name_ddlb within w_pln_master_plan_rpt
integer x = 2450
integer y = 180
integer width = 713
integer taborder = 50
boolean bringtotop = true
end type

type st_4 from statictext within w_pln_master_plan_rpt
integer x = 2455
integer y = 96
integer width = 713
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

type gb_1 from groupbox within w_pln_master_plan_rpt
integer x = 1970
integer width = 2528
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

type gb_2 from so_groupbox within w_pln_master_plan_rpt
integer width = 1824
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

