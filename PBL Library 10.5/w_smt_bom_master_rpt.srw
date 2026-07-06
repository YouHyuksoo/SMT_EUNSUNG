HA$PBExportHeader$w_smt_bom_master_rpt.srw
$PBExportComments$BOM$$HEX3$$acb9ecd3b8d2$$ENDHEX$$
forward
global type w_smt_bom_master_rpt from w_main_root
end type
type rb_part_list_simple from so_radiobutton within w_smt_bom_master_rpt
end type
type st_2 from so_statictext within w_smt_bom_master_rpt
end type
type ddlb_line_code from uo_line_code within w_smt_bom_master_rpt
end type
type ddlb_top_bottom from uo_basecode within w_smt_bom_master_rpt
end type
type st_3 from so_statictext within w_smt_bom_master_rpt
end type
type rb_location_comparision from so_radiobutton within w_smt_bom_master_rpt
end type
type st_7 from so_statictext within w_smt_bom_master_rpt
end type
type ddlb_b_line_code from uo_line_code within w_smt_bom_master_rpt
end type
type st_8 from so_statictext within w_smt_bom_master_rpt
end type
type rb_suffix from so_radiobutton within w_smt_bom_master_rpt
end type
type rb_same_material from so_radiobutton within w_smt_bom_master_rpt
end type
type st_1 from so_statictext within w_smt_bom_master_rpt
end type
type dw_6 from datawindow within w_smt_bom_master_rpt
end type
type dw_7 from datawindow within w_smt_bom_master_rpt
end type
type rb_layout_list from so_radiobutton within w_smt_bom_master_rpt
end type
type ddlb_b_model_name from uo_set_model_name_ddlb within w_smt_bom_master_rpt
end type
type sle_revision from so_singlelineedit within w_smt_bom_master_rpt
end type
type st_4 from so_statictext within w_smt_bom_master_rpt
end type
type ddlb_customer_code from uo_customer_code_name within w_smt_bom_master_rpt
end type
type st_10 from statictext within w_smt_bom_master_rpt
end type
type ddlb_model_name from uo_smt_layout_model_name_ddlb within w_smt_bom_master_rpt
end type
type gb_where_condition from groupbox within w_smt_bom_master_rpt
end type
type gb_1 from groupbox within w_smt_bom_master_rpt
end type
type gb_2 from so_groupbox within w_smt_bom_master_rpt
end type
end forward

global type w_smt_bom_master_rpt from w_main_root
integer width = 6729
integer height = 2648
string title = "SMT BOM Master Report"
windowstate windowstate = maximized!
rb_part_list_simple rb_part_list_simple
st_2 st_2
ddlb_line_code ddlb_line_code
ddlb_top_bottom ddlb_top_bottom
st_3 st_3
rb_location_comparision rb_location_comparision
st_7 st_7
ddlb_b_line_code ddlb_b_line_code
st_8 st_8
rb_suffix rb_suffix
rb_same_material rb_same_material
st_1 st_1
dw_6 dw_6
dw_7 dw_7
rb_layout_list rb_layout_list
ddlb_b_model_name ddlb_b_model_name
sle_revision sle_revision
st_4 st_4
ddlb_customer_code ddlb_customer_code
st_10 st_10
ddlb_model_name ddlb_model_name
gb_where_condition gb_where_condition
gb_1 gb_1
gb_2 gb_2
end type
global w_smt_bom_master_rpt w_smt_bom_master_rpt

type variables

end variables

on w_smt_bom_master_rpt.create
int iCurrent
call super::create
this.rb_part_list_simple=create rb_part_list_simple
this.st_2=create st_2
this.ddlb_line_code=create ddlb_line_code
this.ddlb_top_bottom=create ddlb_top_bottom
this.st_3=create st_3
this.rb_location_comparision=create rb_location_comparision
this.st_7=create st_7
this.ddlb_b_line_code=create ddlb_b_line_code
this.st_8=create st_8
this.rb_suffix=create rb_suffix
this.rb_same_material=create rb_same_material
this.st_1=create st_1
this.dw_6=create dw_6
this.dw_7=create dw_7
this.rb_layout_list=create rb_layout_list
this.ddlb_b_model_name=create ddlb_b_model_name
this.sle_revision=create sle_revision
this.st_4=create st_4
this.ddlb_customer_code=create ddlb_customer_code
this.st_10=create st_10
this.ddlb_model_name=create ddlb_model_name
this.gb_where_condition=create gb_where_condition
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_part_list_simple
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.ddlb_line_code
this.Control[iCurrent+4]=this.ddlb_top_bottom
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.rb_location_comparision
this.Control[iCurrent+7]=this.st_7
this.Control[iCurrent+8]=this.ddlb_b_line_code
this.Control[iCurrent+9]=this.st_8
this.Control[iCurrent+10]=this.rb_suffix
this.Control[iCurrent+11]=this.rb_same_material
this.Control[iCurrent+12]=this.st_1
this.Control[iCurrent+13]=this.dw_6
this.Control[iCurrent+14]=this.dw_7
this.Control[iCurrent+15]=this.rb_layout_list
this.Control[iCurrent+16]=this.ddlb_b_model_name
this.Control[iCurrent+17]=this.sle_revision
this.Control[iCurrent+18]=this.st_4
this.Control[iCurrent+19]=this.ddlb_customer_code
this.Control[iCurrent+20]=this.st_10
this.Control[iCurrent+21]=this.ddlb_model_name
this.Control[iCurrent+22]=this.gb_where_condition
this.Control[iCurrent+23]=this.gb_1
this.Control[iCurrent+24]=this.gb_2
end on

on w_smt_bom_master_rpt.destroy
call super::destroy
destroy(this.rb_part_list_simple)
destroy(this.st_2)
destroy(this.ddlb_line_code)
destroy(this.ddlb_top_bottom)
destroy(this.st_3)
destroy(this.rb_location_comparision)
destroy(this.st_7)
destroy(this.ddlb_b_line_code)
destroy(this.st_8)
destroy(this.rb_suffix)
destroy(this.rb_same_material)
destroy(this.st_1)
destroy(this.dw_6)
destroy(this.dw_7)
destroy(this.rb_layout_list)
destroy(this.ddlb_b_model_name)
destroy(this.sle_revision)
destroy(this.st_4)
destroy(this.ddlb_customer_code)
destroy(this.st_10)
destroy(this.ddlb_model_name)
destroy(this.gb_where_condition)
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
double LVDB_SESSION_ID
String LVS_SET_ITEM_CODE , LVS_MODEL_NAME
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		
		if rb_part_list_simple.checked = true then 
			
			DW_1.RETRIEVE( ddlb_model_name.getcode( ) ,  ddlb_line_code.getcode( )+'%' ,   ddlb_top_bottom.getcode()+'%' ,  GVI_ORGANIZATION_ID  ,  sle_revision.text+'%'  )
			DW_1.SETFOCUS()			
			
		elseif 	rb_layout_list.checked = true then 
			
			DW_2.RETRIEVE(   ddlb_line_code.getcode( ),  ddlb_model_name.getcode( ) ,  ddlb_top_bottom.getcode() , GVI_ORGANIZATION_ID )
			DW_2.SETFOCUS()				
	
		elseif rb_location_comparision.checked = true then 
			
			DW_3.RETRIEVE(   ddlb_line_code.getcode( ),ddlb_model_name.getcode( ) ,ddlb_b_line_code.getcode( ) ,  ddlb_b_model_name.getcode( ) ,    ddlb_top_bottom.getcode() , GVI_ORGANIZATION_ID )
			DW_3.SETFOCUS()	
			
		elseif rb_suffix.checked = true then 
			
			dw_4.retrieve(  ddlb_line_code.getcode( ),ddlb_model_name.getcode( ) ,  F_T_SYSDATE() , F_T_SYSDATE()  ,GVI_ORGANIZATION_ID  )
			
		elseif rb_same_material.checked = true then
			
			DW_5.RETRIEVE(   ddlb_line_code.getcode( ),ddlb_model_name.getcode( ) ,ddlb_b_line_code.getcode( ) ,  ddlb_b_model_name.getcode( ) ,    ddlb_top_bottom.getcode() , GVI_ORGANIZATION_ID )
			DW_5.SETFOCUS()				
		end if 
						
	CASE ELSE
END CHOOSE
end event

event ue_post_open;call super::ue_post_open;//====================================
// $$HEX22$$acb9ecd3b8d2200000adacb9d0c52000f1b45db818b4b4c5200088c73cc774ba200014bcd4af00c9e4b22000$$ENDHEX$$
//====================================

STRING ls_syntax

ls_syntax	=	f_get_dataobject('REPORT', upper(THIS.CLASSNAME()) ,  string( dw_1.dataobject )	)
if	ls_syntax = '' or isnull(ls_syntax) then
	f_msg_mdi_help("Report Not Changed")
else
	dw_1.create(ls_syntax)
	dw_1.settransobject(sqlca)
	f_dual_lang_change_dwtext(dw_1)
	f_msg_mdi_help("Report Changed")
end if	

/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
dw_6.settransobject( sqlca)
dw_7.settransobject( sqlca)


end event

type dw_5 from w_main_root`dw_5 within w_smt_bom_master_rpt
integer y = 572
integer width = 4507
integer height = 1928
boolean titlebar = true
string dataobject = "d_smt_plandata_material_comparision_rpt"
end type

type dw_4 from w_main_root`dw_4 within w_smt_bom_master_rpt
integer y = 572
integer width = 4507
integer height = 1928
boolean titlebar = true
string dataobject = "d_pln_product_suffix_label_rpt"
boolean controlmenu = true
end type

type dw_3 from w_main_root`dw_3 within w_smt_bom_master_rpt
integer y = 572
integer width = 4507
integer height = 1896
boolean titlebar = true
string title = "Part List Simple"
string dataobject = "d_smt_plandata_location_comparision_rpt"
end type

type dw_2 from w_main_root`dw_2 within w_smt_bom_master_rpt
integer y = 568
integer width = 4507
integer height = 1928
integer taborder = 0
boolean titlebar = true
string dataobject = "D_PRODUCT_PLANDATA"
end type

type dw_1 from w_main_root`dw_1 within w_smt_bom_master_rpt
integer y = 568
integer width = 4507
integer height = 1928
integer taborder = 0
boolean titlebar = true
string dataobject = "d_smt_plandata_list_rpt"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_smt_bom_master_rpt
end type

type rb_part_list_simple from so_radiobutton within w_smt_bom_master_rpt
integer x = 46
integer y = 72
integer width = 695
boolean bringtotop = true
string text = "Feeder Layout(Plan)"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
selected_data_window = dw_1


end event

type st_2 from so_statictext within w_smt_bom_master_rpt
integer x = 2263
integer y = 76
integer width = 457
integer height = 72
boolean bringtotop = true
boolean enabled = false
string text = "Line Code"
end type

type ddlb_line_code from uo_line_code within w_smt_bom_master_rpt
integer x = 2263
integer y = 156
integer width = 457
integer height = 1664
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
end type

type ddlb_top_bottom from uo_basecode within w_smt_bom_master_rpt
integer x = 2725
integer y = 156
integer width = 434
integer height = 1664
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 400
boolean allowedit = true
integer limit = 10
end type

event constructor;call super::constructor;this.redraw( 'TOP BOTTOM')
end event

type st_3 from so_statictext within w_smt_bom_master_rpt
integer x = 2743
integer y = 76
integer width = 379
integer height = 72
boolean bringtotop = true
boolean enabled = false
string text = "Top/Bottom"
end type

type rb_location_comparision from so_radiobutton within w_smt_bom_master_rpt
integer x = 46
integer y = 260
integer width = 695
boolean bringtotop = true
string text = "Location Comparision"
end type

event clicked;call super::clicked;dw_3.bringtotop = true
selected_data_window = dw_3

end event

type st_7 from so_statictext within w_smt_bom_master_rpt
integer x = 1042
integer y = 344
integer width = 809
integer height = 84
boolean bringtotop = true
integer textsize = -9
boolean enabled = false
string text = "Model Name"
end type

type ddlb_b_line_code from uo_line_code within w_smt_bom_master_rpt
integer x = 1947
integer y = 440
integer width = 457
integer height = 1848
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
end type

type st_8 from so_statictext within w_smt_bom_master_rpt
integer x = 1861
integer y = 344
integer width = 535
integer height = 84
boolean bringtotop = true
integer textsize = -9
boolean enabled = false
string text = "Line Code"
end type

type rb_suffix from so_radiobutton within w_smt_bom_master_rpt
integer x = 46
integer y = 452
integer width = 695
boolean bringtotop = true
string text = "Suffix Label List"
end type

event clicked;call super::clicked;dw_4.bringtotop = true
selected_data_window = dw_4


end event

type rb_same_material from so_radiobutton within w_smt_bom_master_rpt
integer x = 46
integer y = 348
integer width = 695
boolean bringtotop = true
string text = "Same Material List"
end type

event clicked;call super::clicked;dw_5.bringtotop = true
selected_data_window = dw_5

end event

type st_1 from so_statictext within w_smt_bom_master_rpt
integer x = 1541
integer y = 76
integer width = 741
integer height = 72
boolean bringtotop = true
boolean enabled = false
string text = "SMT Model name"
end type

type dw_6 from datawindow within w_smt_bom_master_rpt
integer x = 3483
integer y = 28
integer width = 1591
integer height = 528
integer taborder = 90
boolean bringtotop = true
boolean titlebar = true
string title = "Model"
string dataobject = "d_des_item_4_plan_smt_modify_lst"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

type dw_7 from datawindow within w_smt_bom_master_rpt
integer x = 5079
integer y = 32
integer width = 1591
integer height = 528
integer taborder = 100
boolean bringtotop = true
boolean titlebar = true
string title = "Comparision"
string dataobject = "d_des_item_4_plan_smt_modify_lst"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

type rb_layout_list from so_radiobutton within w_smt_bom_master_rpt
integer x = 46
integer y = 172
integer width = 695
boolean bringtotop = true
string text = "Feeder Layout(List)"
end type

event clicked;call super::clicked;dw_2.bringtotop = true
selected_data_window = dw_2


end event

type ddlb_b_model_name from uo_set_model_name_ddlb within w_smt_bom_master_rpt
integer x = 1019
integer y = 444
integer width = 919
integer height = 1900
integer taborder = 70
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
boolean autohscroll = true
end type

event selectionchanged;call super::selectionchanged;dw_7.retrieve( this.getcode() , gvi_organization_id )
end event

type sle_revision from so_singlelineedit within w_smt_bom_master_rpt
integer x = 3163
integer y = 156
integer width = 283
integer height = 88
integer taborder = 100
boolean bringtotop = true
end type

type st_4 from so_statictext within w_smt_bom_master_rpt
integer x = 3163
integer y = 76
integer width = 283
integer height = 72
boolean bringtotop = true
boolean enabled = false
string text = "Revision"
end type

type ddlb_customer_code from uo_customer_code_name within w_smt_bom_master_rpt
integer x = 818
integer y = 156
integer width = 690
integer height = 1324
integer taborder = 190
boolean bringtotop = true
boolean autohscroll = true
boolean vscrollbar = false
end type

type st_10 from statictext within w_smt_bom_master_rpt
integer x = 818
integer y = 76
integer width = 690
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Customer Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_model_name from uo_smt_layout_model_name_ddlb within w_smt_bom_master_rpt
integer x = 1518
integer y = 160
integer width = 745
integer taborder = 70
boolean bringtotop = true
end type

event selectionchanged;call super::selectionchanged;dw_6.retrieve( this.getcode() , gvi_organization_id )
end event

type gb_where_condition from groupbox within w_smt_bom_master_rpt
integer x = 5
integer y = 4
integer width = 763
integer height = 552
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Where Condition"
end type

type gb_1 from groupbox within w_smt_bom_master_rpt
integer x = 782
integer y = 4
integer width = 2688
integer height = 276
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_smt_bom_master_rpt
integer x = 791
integer y = 276
integer width = 1641
integer height = 284
integer taborder = 60
integer textsize = -9
string text = "Comarision Condition"
end type

