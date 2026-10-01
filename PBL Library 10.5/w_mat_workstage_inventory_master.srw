HA$PBExportHeader$w_mat_workstage_inventory_master.srw
$PBExportComments$Material Current Inventory Master
forward
global type w_mat_workstage_inventory_master from w_main_root
end type
type st_1 from so_statictext within w_mat_workstage_inventory_master
end type
type ddlb_item_code from uo_item_code within w_mat_workstage_inventory_master
end type
type st_4 from so_statictext within w_mat_workstage_inventory_master
end type
type rb_summary from so_radiobutton within w_mat_workstage_inventory_master
end type
type rb_detail from so_radiobutton within w_mat_workstage_inventory_master
end type
type ddlb_item_division from uo_item_division within w_mat_workstage_inventory_master
end type
type st_5 from so_statictext within w_mat_workstage_inventory_master
end type
type sle_mfs from so_singlelineedit within w_mat_workstage_inventory_master
end type
type ddlb_line_code from uo_line_code within w_mat_workstage_inventory_master
end type
type st_6 from so_statictext within w_mat_workstage_inventory_master
end type
type ddlb_workstage_code from uo_workstage_code_workstage within w_mat_workstage_inventory_master
end type
type st_10 from statictext within w_mat_workstage_inventory_master
end type
type st_2 from so_statictext within w_mat_workstage_inventory_master
end type
type sle_material_mfs from so_singlelineedit within w_mat_workstage_inventory_master
end type
type rb_all from so_radiobutton within w_mat_workstage_inventory_master
end type
type rb_gt from so_radiobutton within w_mat_workstage_inventory_master
end type
type gb_1 from so_groupbox within w_mat_workstage_inventory_master
end type
type gb_2 from so_groupbox within w_mat_workstage_inventory_master
end type
type gb_5 from so_groupbox within w_mat_workstage_inventory_master
end type
end forward

global type w_mat_workstage_inventory_master from w_main_root
integer width = 5102
integer height = 3056
string title = "Material Workstage Inventory Query"
st_1 st_1
ddlb_item_code ddlb_item_code
st_4 st_4
rb_summary rb_summary
rb_detail rb_detail
ddlb_item_division ddlb_item_division
st_5 st_5
sle_mfs sle_mfs
ddlb_line_code ddlb_line_code
st_6 st_6
ddlb_workstage_code ddlb_workstage_code
st_10 st_10
st_2 st_2
sle_material_mfs sle_material_mfs
rb_all rb_all
rb_gt rb_gt
gb_1 gb_1
gb_2 gb_2
gb_5 gb_5
end type
global w_mat_workstage_inventory_master w_mat_workstage_inventory_master

on w_mat_workstage_inventory_master.create
int iCurrent
call super::create
this.st_1=create st_1
this.ddlb_item_code=create ddlb_item_code
this.st_4=create st_4
this.rb_summary=create rb_summary
this.rb_detail=create rb_detail
this.ddlb_item_division=create ddlb_item_division
this.st_5=create st_5
this.sle_mfs=create sle_mfs
this.ddlb_line_code=create ddlb_line_code
this.st_6=create st_6
this.ddlb_workstage_code=create ddlb_workstage_code
this.st_10=create st_10
this.st_2=create st_2
this.sle_material_mfs=create sle_material_mfs
this.rb_all=create rb_all
this.rb_gt=create rb_gt
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_5=create gb_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.ddlb_item_code
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.rb_summary
this.Control[iCurrent+5]=this.rb_detail
this.Control[iCurrent+6]=this.ddlb_item_division
this.Control[iCurrent+7]=this.st_5
this.Control[iCurrent+8]=this.sle_mfs
this.Control[iCurrent+9]=this.ddlb_line_code
this.Control[iCurrent+10]=this.st_6
this.Control[iCurrent+11]=this.ddlb_workstage_code
this.Control[iCurrent+12]=this.st_10
this.Control[iCurrent+13]=this.st_2
this.Control[iCurrent+14]=this.sle_material_mfs
this.Control[iCurrent+15]=this.rb_all
this.Control[iCurrent+16]=this.rb_gt
this.Control[iCurrent+17]=this.gb_1
this.Control[iCurrent+18]=this.gb_2
this.Control[iCurrent+19]=this.gb_5
end on

on w_mat_workstage_inventory_master.destroy
call super::destroy
destroy(this.st_1)
destroy(this.ddlb_item_code)
destroy(this.st_4)
destroy(this.rb_summary)
destroy(this.rb_detail)
destroy(this.ddlb_item_division)
destroy(this.st_5)
destroy(this.sle_mfs)
destroy(this.ddlb_line_code)
destroy(this.st_6)
destroy(this.ddlb_workstage_code)
destroy(this.st_10)
destroy(this.st_2)
destroy(this.sle_material_mfs)
destroy(this.rb_all)
destroy(this.rb_gt)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_5)
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
Ivs_resize_type                      = 'MASTER_DETAIL_1L2FR'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


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
F_MENU_CONTROL('DATA_CONTROL_MODIFY' , TRUE)  // All Data Control





end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

event ue_data_control;call super::ue_data_control;Long row
String lvs_date
choose case gvs_ue_data_control
		
	case 'RETRIEVE'			
		IF RB_SUMMARY.CHecked = true then 
			dw_1.reset()
			dw_1.retrieve( sle_mfs.text+'%' , ddlb_line_code.getcode()+'%' , ddlb_workstage_code.getcode()+'%' , ddlb_item_code.text() + '%',  ddlb_item_division.getcode()+'%' , sle_material_mfs.text+'%' ,  gvi_organization_id)
		else
			dw_3.reset()			
			dw_3.retrieve(sle_mfs.text+'%' ,ddlb_line_code.getcode()+'%' , ddlb_workstage_code.getcode()+'%' , ddlb_item_code.text() + '%',   ddlb_item_division.getcode()+'%' ,  sle_material_mfs.text+'%' , gvi_organization_id)			
		end if
		
	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mat_workstage_inventory_master
integer y = 332
end type

type dw_4 from w_main_root`dw_4 within w_mat_workstage_inventory_master
integer y = 332
end type

type dw_3 from w_main_root`dw_3 within w_mat_workstage_inventory_master
integer y = 332
integer width = 4411
integer height = 1816
boolean titlebar = true
string dataobject = "d_mat_workstage_inventory_lst_tree"
end type

type dw_2 from w_main_root`dw_2 within w_mat_workstage_inventory_master
integer x = 2651
integer y = 328
integer width = 2386
integer height = 1792
boolean titlebar = true
string dataobject = "d_mat_workstage_inventory_lst_tree"
end type

type dw_1 from w_main_root`dw_1 within w_mat_workstage_inventory_master
integer y = 332
integer width = 2656
integer height = 1792
boolean titlebar = true
string title = "Material Workstage Inventory List"
string dataobject = "d_mat_workstage_inventory_sum_lst_tree"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
dw_2.retrieve( '%' ,'%' , '%' ,  this.object.item_code[currentrow] + '%',   '%' , '%' , gvi_organization_id)			
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_workstage_inventory_master
end type

type st_1 from so_statictext within w_mat_workstage_inventory_master
integer x = 1847
integer y = 96
integer width = 539
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_mat_workstage_inventory_master
integer x = 1847
integer y = 168
integer width = 539
integer height = 676
integer taborder = 20
boolean bringtotop = true
end type

type st_4 from so_statictext within w_mat_workstage_inventory_master
integer x = 3383
integer y = 92
integer width = 489
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "MFS"
end type

type rb_summary from so_radiobutton within w_mat_workstage_inventory_master
integer x = 73
integer y = 88
integer width = 539
boolean bringtotop = true
integer weight = 700
string text = "Summary"
boolean checked = true
end type

event clicked;call super::clicked;selected_data_window = dw_1
dw_1.bringtotop = true
dw_2.bringtotop = true
end event

type rb_detail from so_radiobutton within w_mat_workstage_inventory_master
integer x = 73
integer y = 192
integer width = 539
boolean bringtotop = true
integer weight = 700
string text = "Detail"
end type

event clicked;call super::clicked;selected_data_window = dw_3
dw_3.bringtotop = true
end event

type ddlb_item_division from uo_item_division within w_mat_workstage_inventory_master
integer x = 2921
integer y = 168
integer width = 453
integer taborder = 20
boolean bringtotop = true
end type

type st_5 from so_statictext within w_mat_workstage_inventory_master
integer x = 2926
integer y = 96
integer width = 448
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Item Division"
end type

type sle_mfs from so_singlelineedit within w_mat_workstage_inventory_master
integer x = 3383
integer y = 164
integer width = 489
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

type ddlb_line_code from uo_line_code within w_mat_workstage_inventory_master
integer x = 681
integer y = 168
integer width = 512
integer taborder = 50
boolean bringtotop = true
boolean sorted = true
end type

type st_6 from so_statictext within w_mat_workstage_inventory_master
integer x = 681
integer y = 96
integer width = 517
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Line Code"
end type

type ddlb_workstage_code from uo_workstage_code_workstage within w_mat_workstage_inventory_master
integer x = 1198
integer y = 168
integer width = 640
integer taborder = 60
boolean bringtotop = true
end type

type st_10 from statictext within w_mat_workstage_inventory_master
integer x = 1198
integer y = 96
integer width = 640
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Workstage Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from so_statictext within w_mat_workstage_inventory_master
integer x = 2395
integer y = 96
integer width = 521
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Material MFS"
end type

type sle_material_mfs from so_singlelineedit within w_mat_workstage_inventory_master
integer x = 2395
integer y = 168
integer width = 521
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

type rb_all from so_radiobutton within w_mat_workstage_inventory_master
integer x = 3945
integer y = 76
integer width = 590
integer height = 84
boolean bringtotop = true
integer weight = 700
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.setfilter( '')
dw_1.filter( )
end event

type rb_gt from so_radiobutton within w_mat_workstage_inventory_master
integer x = 3945
integer y = 192
integer width = 590
integer height = 84
boolean bringtotop = true
integer weight = 700
string text = "Inventory Qty > 0"
end type

event clicked;call super::clicked;dw_1.setfilter('inventory_qty > 0 ')
dw_1.filter( )
end event

type gb_1 from so_groupbox within w_mat_workstage_inventory_master
integer x = 9
integer width = 622
integer height = 320
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_2 from so_groupbox within w_mat_workstage_inventory_master
integer x = 640
integer width = 3250
integer height = 320
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_5 from so_groupbox within w_mat_workstage_inventory_master
integer x = 3899
integer width = 773
integer height = 320
integer taborder = 70
integer weight = 700
long textcolor = 16711680
string text = "Filter"
end type

