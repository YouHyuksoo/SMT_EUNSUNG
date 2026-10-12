HA$PBExportHeader$w_mat_workstage_inventory_query.srw
$PBExportComments$Material Current Inventory Master
forward
global type w_mat_workstage_inventory_query from w_main_root
end type
type st_1 from so_statictext within w_mat_workstage_inventory_query
end type
type ddlb_item_code from uo_item_code within w_mat_workstage_inventory_query
end type
type rb_all from so_radiobutton within w_mat_workstage_inventory_query
end type
type rb_gt from so_radiobutton within w_mat_workstage_inventory_query
end type
type gb_2 from so_groupbox within w_mat_workstage_inventory_query
end type
type gb_5 from so_groupbox within w_mat_workstage_inventory_query
end type
end forward

global type w_mat_workstage_inventory_query from w_main_root
integer width = 5102
integer height = 3056
string title = "Material Workstage Inventory Query"
st_1 st_1
ddlb_item_code ddlb_item_code
rb_all rb_all
rb_gt rb_gt
gb_2 gb_2
gb_5 gb_5
end type
global w_mat_workstage_inventory_query w_mat_workstage_inventory_query

on w_mat_workstage_inventory_query.create
int iCurrent
call super::create
this.st_1=create st_1
this.ddlb_item_code=create ddlb_item_code
this.rb_all=create rb_all
this.rb_gt=create rb_gt
this.gb_2=create gb_2
this.gb_5=create gb_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.ddlb_item_code
this.Control[iCurrent+3]=this.rb_all
this.Control[iCurrent+4]=this.rb_gt
this.Control[iCurrent+5]=this.gb_2
this.Control[iCurrent+6]=this.gb_5
end on

on w_mat_workstage_inventory_query.destroy
call super::destroy
destroy(this.st_1)
destroy(this.ddlb_item_code)
destroy(this.rb_all)
destroy(this.rb_gt)
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
	
			dw_1.reset()
			dw_1.retrieve( ddlb_item_code.text() + '%', gvi_organization_id)
	
	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mat_workstage_inventory_query
integer y = 332
end type

type dw_4 from w_main_root`dw_4 within w_mat_workstage_inventory_query
integer y = 332
end type

type dw_3 from w_main_root`dw_3 within w_mat_workstage_inventory_query
integer y = 332
integer width = 4411
integer height = 1816
boolean titlebar = true
end type

type dw_2 from w_main_root`dw_2 within w_mat_workstage_inventory_query
integer y = 332
integer width = 4411
integer height = 1816
boolean titlebar = true
end type

type dw_1 from w_main_root`dw_1 within w_mat_workstage_inventory_query
integer y = 332
integer width = 4411
integer height = 1816
boolean titlebar = true
string title = "Material Workstage Inventory List"
string dataobject = "d_mat_workstage_inventory_query"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
dw_2.retrieve( '%' ,'%' , '%' ,  this.object.item_code[currentrow] + '%',   '%' , '%' , gvi_organization_id)			
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_workstage_inventory_query
end type

type st_1 from so_statictext within w_mat_workstage_inventory_query
integer x = 101
integer y = 96
integer width = 731
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_mat_workstage_inventory_query
integer x = 101
integer y = 168
integer width = 731
integer height = 676
integer taborder = 20
boolean bringtotop = true
end type

type rb_all from so_radiobutton within w_mat_workstage_inventory_query
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

type rb_gt from so_radiobutton within w_mat_workstage_inventory_query
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

type gb_2 from so_groupbox within w_mat_workstage_inventory_query
integer x = 32
integer width = 859
integer height = 320
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_5 from so_groupbox within w_mat_workstage_inventory_query
integer x = 3899
integer width = 773
integer height = 320
integer taborder = 70
integer weight = 700
long textcolor = 16711680
string text = "Filter"
end type

