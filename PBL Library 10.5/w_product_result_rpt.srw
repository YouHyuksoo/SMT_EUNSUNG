HA$PBExportHeader$w_product_result_rpt.srw
forward
global type w_product_result_rpt from w_main_root
end type
type rb_day from so_radiobutton within w_product_result_rpt
end type
type rb_line from so_radiobutton within w_product_result_rpt
end type
type st_5 from so_statictext within w_product_result_rpt
end type
type uo_dateset from uo_ymd_calendar within w_product_result_rpt
end type
type uo_datend from uo_ymd_calendar within w_product_result_rpt
end type
type ddlb_model from uo_model_name_ddlb within w_product_result_rpt
end type
type st_1 from so_statictext within w_product_result_rpt
end type
type st_2 from so_statictext within w_product_result_rpt
end type
type ddlb_line_code from uo_line_code within w_product_result_rpt
end type
type rb_detail from so_radiobutton within w_product_result_rpt
end type
type st_3 from so_statictext within w_product_result_rpt
end type
type sle_mapping_model from singlelineedit within w_product_result_rpt
end type
type gb_1 from groupbox within w_product_result_rpt
end type
type gb_2 from so_groupbox within w_product_result_rpt
end type
end forward

global type w_product_result_rpt from w_main_root
integer width = 4549
integer height = 2648
string title = "Product Result (PID)"
rb_day rb_day
rb_line rb_line
st_5 st_5
uo_dateset uo_dateset
uo_datend uo_datend
ddlb_model ddlb_model
st_1 st_1
st_2 st_2
ddlb_line_code ddlb_line_code
rb_detail rb_detail
st_3 st_3
sle_mapping_model sle_mapping_model
gb_1 gb_1
gb_2 gb_2
end type
global w_product_result_rpt w_product_result_rpt

type variables

end variables

on w_product_result_rpt.create
int iCurrent
call super::create
this.rb_day=create rb_day
this.rb_line=create rb_line
this.st_5=create st_5
this.uo_dateset=create uo_dateset
this.uo_datend=create uo_datend
this.ddlb_model=create ddlb_model
this.st_1=create st_1
this.st_2=create st_2
this.ddlb_line_code=create ddlb_line_code
this.rb_detail=create rb_detail
this.st_3=create st_3
this.sle_mapping_model=create sle_mapping_model
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_day
this.Control[iCurrent+2]=this.rb_line
this.Control[iCurrent+3]=this.st_5
this.Control[iCurrent+4]=this.uo_dateset
this.Control[iCurrent+5]=this.uo_datend
this.Control[iCurrent+6]=this.ddlb_model
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.ddlb_line_code
this.Control[iCurrent+10]=this.rb_detail
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.sle_mapping_model
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.gb_2
end on

on w_product_result_rpt.destroy
call super::destroy
destroy(this.rb_day)
destroy(this.rb_line)
destroy(this.st_5)
destroy(this.uo_dateset)
destroy(this.uo_datend)
destroy(this.ddlb_model)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.ddlb_line_code)
destroy(this.rb_detail)
destroy(this.st_3)
destroy(this.sle_mapping_model)
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
		
		if rb_day.checked = true then 
				
		 	dw_1.retrieve( ddlb_line_code.getcode(),ddlb_model.text()+'%', sle_mapping_model.text+'%', uo_dateset.text(), uo_datend.text() ,GVI_ORGANIZATION_ID )
			dw_1.setfocus()
			
		elseif rb_line.checked = true then 
			dw_2.retrieve( ddlb_line_code.getcode(),ddlb_model.text()+'%',  sle_mapping_model.text+'%',uo_dateset.text(), uo_datend.text() ,GVI_ORGANIZATION_ID )
			dw_2.setfocus()		

		elseif rb_detail.checked = true then 
			dw_3.retrieve( ddlb_line_code.getcode(),ddlb_model.text()+'%',  sle_mapping_model.text+'%',uo_dateset.text(), uo_datend.text() ,GVI_ORGANIZATION_ID )
			dw_3.setfocus()				
		
		end if 
				
	CASE ELSE
		
END CHOOSE
end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_product_result_rpt
integer y = 316
end type

type dw_4 from w_main_root`dw_4 within w_product_result_rpt
integer y = 316
integer width = 4503
boolean titlebar = true
end type

type dw_3 from w_main_root`dw_3 within w_product_result_rpt
integer y = 316
integer width = 4507
integer height = 2120
boolean titlebar = true
string title = "Result by Detail"
string dataobject = "d_product_result_by_day_detail"
end type

type dw_2 from w_main_root`dw_2 within w_product_result_rpt
integer y = 316
integer width = 4507
integer height = 2120
integer taborder = 0
boolean titlebar = true
string title = "Result by Line"
string dataobject = "d_product_result_by_day_line_crosstab"
end type

type dw_1 from w_main_root`dw_1 within w_product_result_rpt
integer y = 316
integer width = 4507
integer height = 2120
integer taborder = 0
boolean titlebar = true
string title = "Reuslt by Day"
string dataobject = "d_product_result_by_day_crosstab"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_product_result_rpt
end type

type rb_day from so_radiobutton within w_product_result_rpt
integer x = 50
integer y = 80
integer width = 855
boolean bringtotop = true
integer weight = 700
string text = "Result by Day"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1

end event

type rb_line from so_radiobutton within w_product_result_rpt
integer x = 526
integer y = 80
integer width = 512
boolean bringtotop = true
integer weight = 700
string text = "Result by Line"
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
selected_data_window = dw_2
end event

type st_5 from so_statictext within w_product_result_rpt
integer x = 1189
integer y = 96
integer width = 841
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Production Date"
end type

type uo_dateset from uo_ymd_calendar within w_product_result_rpt
event destroy ( )
integer x = 1184
integer y = 176
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_datend from uo_ymd_calendar within w_product_result_rpt
event destroy ( )
integer x = 1609
integer y = 176
integer taborder = 50
boolean bringtotop = true
end type

on uo_datend.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_model from uo_model_name_ddlb within w_product_result_rpt
integer x = 2683
integer y = 176
integer taborder = 70
boolean bringtotop = true
end type

type st_1 from so_statictext within w_product_result_rpt
integer x = 2039
integer y = 96
integer width = 631
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Line Code"
end type

type st_2 from so_statictext within w_product_result_rpt
integer x = 2683
integer y = 96
integer width = 809
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Model"
end type

type ddlb_line_code from uo_line_code within w_product_result_rpt
integer x = 2048
integer y = 176
integer width = 617
integer height = 1328
integer taborder = 40
boolean bringtotop = true
long backcolor = 16777215
end type

type rb_detail from so_radiobutton within w_product_result_rpt
integer x = 50
integer y = 176
integer width = 567
boolean bringtotop = true
integer weight = 700
string text = "Result by Detail"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3
end event

type st_3 from so_statictext within w_product_result_rpt
integer x = 3474
integer y = 96
integer width = 809
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Mapping Model"
boolean disabledlook = true
end type

type sle_mapping_model from singlelineedit within w_product_result_rpt
integer x = 3515
integer y = 172
integer width = 722
integer height = 88
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
boolean hideselection = false
end type

type gb_1 from groupbox within w_product_result_rpt
integer x = 1134
integer width = 3191
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

type gb_2 from so_groupbox within w_product_result_rpt
integer width = 1106
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

