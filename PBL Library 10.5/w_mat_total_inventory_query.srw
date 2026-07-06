HA$PBExportHeader$w_mat_total_inventory_query.srw
$PBExportComments$$$HEX5$$1dcdacc7e0ac70c88cd6$$ENDHEX$$
forward
global type w_mat_total_inventory_query from w_main_root
end type
type uo_item from uo_item_code within w_mat_total_inventory_query
end type
type st_5 from so_statictext within w_mat_total_inventory_query
end type
type ddlb_line_type from uo_line_type within w_mat_total_inventory_query
end type
type st_6 from so_statictext within w_mat_total_inventory_query
end type
type ddlb_item_division from uo_item_division within w_mat_total_inventory_query
end type
type st_3 from so_statictext within w_mat_total_inventory_query
end type
type rb_total_inventory from so_radiobutton within w_mat_total_inventory_query
end type
type rb_detail from so_radiobutton within w_mat_total_inventory_query
end type
type rb_all from so_radiobutton within w_mat_total_inventory_query
end type
type rb_gt from so_radiobutton within w_mat_total_inventory_query
end type
type rb_bom from so_radiobutton within w_mat_total_inventory_query
end type
type st_1 from so_statictext within w_mat_total_inventory_query
end type
type ddlb_model_name from uo_set_model_name_ddlb within w_mat_total_inventory_query
end type
type gb_where_condition from so_groupbox within w_mat_total_inventory_query
end type
type gb_1 from so_groupbox within w_mat_total_inventory_query
end type
type gb_5 from so_groupbox within w_mat_total_inventory_query
end type
end forward

global type w_mat_total_inventory_query from w_main_root
integer width = 5733
integer height = 2708
string title = "Total Inventory Query"
uo_item uo_item
st_5 st_5
ddlb_line_type ddlb_line_type
st_6 st_6
ddlb_item_division ddlb_item_division
st_3 st_3
rb_total_inventory rb_total_inventory
rb_detail rb_detail
rb_all rb_all
rb_gt rb_gt
rb_bom rb_bom
st_1 st_1
ddlb_model_name ddlb_model_name
gb_where_condition gb_where_condition
gb_1 gb_1
gb_5 gb_5
end type
global w_mat_total_inventory_query w_mat_total_inventory_query

on w_mat_total_inventory_query.create
int iCurrent
call super::create
this.uo_item=create uo_item
this.st_5=create st_5
this.ddlb_line_type=create ddlb_line_type
this.st_6=create st_6
this.ddlb_item_division=create ddlb_item_division
this.st_3=create st_3
this.rb_total_inventory=create rb_total_inventory
this.rb_detail=create rb_detail
this.rb_all=create rb_all
this.rb_gt=create rb_gt
this.rb_bom=create rb_bom
this.st_1=create st_1
this.ddlb_model_name=create ddlb_model_name
this.gb_where_condition=create gb_where_condition
this.gb_1=create gb_1
this.gb_5=create gb_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_item
this.Control[iCurrent+2]=this.st_5
this.Control[iCurrent+3]=this.ddlb_line_type
this.Control[iCurrent+4]=this.st_6
this.Control[iCurrent+5]=this.ddlb_item_division
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.rb_total_inventory
this.Control[iCurrent+8]=this.rb_detail
this.Control[iCurrent+9]=this.rb_all
this.Control[iCurrent+10]=this.rb_gt
this.Control[iCurrent+11]=this.rb_bom
this.Control[iCurrent+12]=this.st_1
this.Control[iCurrent+13]=this.ddlb_model_name
this.Control[iCurrent+14]=this.gb_where_condition
this.Control[iCurrent+15]=this.gb_1
this.Control[iCurrent+16]=this.gb_5
end on

on w_mat_total_inventory_query.destroy
call super::destroy
destroy(this.uo_item)
destroy(this.st_5)
destroy(this.ddlb_line_type)
destroy(this.st_6)
destroy(this.ddlb_item_division)
destroy(this.st_3)
destroy(this.rb_total_inventory)
destroy(this.rb_detail)
destroy(this.rb_all)
destroy(this.rb_gt)
destroy(this.rb_bom)
destroy(this.st_1)
destroy(this.ddlb_model_name)
destroy(this.gb_where_condition)
destroy(this.gb_1)
destroy(this.gb_5)
end on

event activate;call super::activate;/***************************************
* $$HEX17$$08c7c4b324c115c8d0c5200000ad5cd52000acc06dd544c720004bc105d35cd5e4b2$$ENDHEX$$
*
*
****************************************/
Gst_set.window_id            = this.classname() 
Gst_set.author                  = "JiSheng"
Gst_set.creation_date      = '20051101'
Gst_set.last_modify_date = '20051101'
Gst_set.Report_window    = False  // Report Window  True / Flase

/*****************************************
* Data WIndow Property
******************************************/
Ivs_resize_type    = 'MASTER_DETAIL_1L2FR'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

/****************************************
* Menu Property $$HEX6$$54ba74b2200078d5e4b4c1b9$$ENDHEX$$
*****************************************
* ADMIN     : ADMIN  ( $$HEX5$$04c8b4ccacc0a9c62000$$ENDHEX$$)
* $$HEX8$$00adacb9200020002000200020002000$$ENDHEX$$: MANAGE ( $$HEX8$$04c854ba74b2acc0a9c600aca5b22000$$ENDHEX$$)
* $$HEX7$$acc0a9c690c72000200020002000$$ENDHEX$$: GUEST  ( $$HEX11$$30ae08cd2000f1b45db8200070c88cd6200000aca5b2$$ENDHEX$$)
* $$HEX8$$70c88cd6200020002000200020002000$$ENDHEX$$: QUERY  ( $$HEX10$$15c8f4bc70c88cd6ccb9200000aca5b220002000$$ENDHEX$$)
* $$HEX5$$70b374c7c0d070c891c7$$ENDHEX$$: DATA_CONTROL  ( $$HEX12$$85c725b8200018c215c82000adc01cc8200024c115c82000$$ENDHEX$$)
* $$HEX7$$08b8ecd3b8d22000200020002000$$ENDHEX$$: REPORT ( $$HEX4$$08b8ecd3b8d22000$$ENDHEX$$, $$HEX5$$9ccd25b800adacb92000$$ENDHEX$$)
****************************************/

F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control

/****************************************
* 
****************************************/

end event

event ue_data_control;call super::ue_data_control;DOUBLE LVDB_SESSION_ID

CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
			
			
			IF RB_total_inventory.CHecked = TRUE THEN 
				DW_1.RESET()
				DW_1.RETRIEVE( UO_ITEM.TEXT()+'%' ,  ddlb_item_division.getcode()+'%' , DDLB_LINE_TYPE.GETCODE()+'%' , GVI_ORGANIZATION_ID)
				DW_1.SETFOCUS()
			ELSEIF rb_detail.Checked = TRUE THEN 
				DW_3.RESET()
				DW_3.RETRIEVE( UO_ITEM.TEXT()+'%' , GVI_ORGANIZATION_ID, GVS_LANGUAGE)
				DW_3.SETFOCUS()		
				
			ELSEIF rb_bom.Checked = TRUE THEN 
				
				LVDB_SESSION_ID = F_BOM_QUERY_ALL_PRC( ddlb_model_name.getitem( ) , F_T_SYSDATE() )

				DW_4.RESET()
				
				DW_4.RETRIEVE( LVDB_SESSION_ID , GVI_ORGANIZATION_ID, GVS_LANGUAGE)
				DW_4.SETFOCUS()	
				ROLLBACK; 
			END IF 
		
	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/

WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_mat_total_inventory_query
integer y = 308
integer height = 396
end type

type dw_4 from w_main_root`dw_4 within w_mat_total_inventory_query
integer y = 308
integer width = 3337
integer height = 1660
boolean titlebar = true
string title = "Total Inventory By BOM"
string dataobject = "d_mat_total_inventory_by_bom_query"
end type

type dw_3 from w_main_root`dw_3 within w_mat_total_inventory_query
integer y = 308
integer width = 3337
integer height = 1660
integer taborder = 50
boolean titlebar = true
string title = "Total Detail Query"
string dataobject = "d_mat_total_inventory_detail"
end type

type dw_2 from w_main_root`dw_2 within w_mat_total_inventory_query
integer x = 2455
integer y = 308
integer width = 1710
integer height = 1660
integer taborder = 0
boolean titlebar = true
string dataobject = "d_mat_total_inventory_detail_lot_qty"
end type

type dw_1 from w_main_root`dw_1 within w_mat_total_inventory_query
integer y = 308
integer width = 2455
integer height = 1660
integer taborder = 40
boolean titlebar = true
string title = "Total Inventory Query"
string dataobject = "d_mat_total_inventory_query"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow = 0 then return
dw_2.retrieve(string(this.object.item_code[currentrow]), GVS_LANGUAGE, GVI_ORGANIZATION_ID)
end event

event dw_1::doubleclicked;call super::doubleclicked;if row = 0 then return

	dw_2.retrieve(string(this.object.item_code[row]), GVS_LANGUAGE, GVI_ORGANIZATION_ID)
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_total_inventory_query
end type

type uo_item from uo_item_code within w_mat_total_inventory_query
integer x = 2213
integer y = 176
integer width = 645
integer height = 764
boolean bringtotop = true
end type

on uo_item.destroy
call uo_item_code::destroy
end on

type st_5 from so_statictext within w_mat_total_inventory_query
integer x = 2213
integer y = 96
integer width = 645
integer height = 68
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Item Code"
end type

type ddlb_line_type from uo_line_type within w_mat_total_inventory_query
integer x = 3392
integer y = 176
integer width = 443
integer taborder = 40
boolean bringtotop = true
end type

type st_6 from so_statictext within w_mat_total_inventory_query
integer x = 3392
integer y = 96
integer width = 421
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Line Type"
end type

type ddlb_item_division from uo_item_division within w_mat_total_inventory_query
integer x = 2866
integer y = 176
integer taborder = 20
boolean bringtotop = true
end type

type st_3 from so_statictext within w_mat_total_inventory_query
integer x = 2871
integer y = 96
integer width = 466
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Item Division"
end type

type rb_total_inventory from so_radiobutton within w_mat_total_inventory_query
integer x = 123
integer y = 88
boolean bringtotop = true
string text = "Total Inventory"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1

dw_2.bringtotop = true 
selected_data_window = dw_2
end event

type rb_detail from so_radiobutton within w_mat_total_inventory_query
integer x = 123
integer y = 184
boolean bringtotop = true
string text = "Detail"
end type

event clicked;call super::clicked;//dw_2.bringtotop = true 
//selected_data_window = dw_2

dw_3.bringtotop = true 
selected_data_window = dw_3
end event

type rb_all from so_radiobutton within w_mat_total_inventory_query
integer x = 3927
integer y = 80
integer width = 457
integer height = 84
boolean bringtotop = true
integer weight = 700
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.setfilter( '')
dw_1.filter( )
end event

type rb_gt from so_radiobutton within w_mat_total_inventory_query
integer x = 3927
integer y = 188
integer width = 590
integer height = 84
boolean bringtotop = true
integer weight = 700
string text = "Inventory Qty > 0"
end type

event clicked;call super::clicked;dw_1.setfilter('total_inventory_qty > 0 ')
dw_1.filter( )
end event

type rb_bom from so_radiobutton within w_mat_total_inventory_query
integer x = 786
integer y = 84
boolean bringtotop = true
string text = "Total By BOM"
end type

event clicked;call super::clicked;dw_4.bringtotop = true 
selected_data_window = dw_4
end event

type st_1 from so_statictext within w_mat_total_inventory_query
integer x = 1399
integer y = 96
integer width = 809
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Model Name"
end type

type ddlb_model_name from uo_set_model_name_ddlb within w_mat_total_inventory_query
integer x = 1399
integer y = 176
integer taborder = 20
boolean bringtotop = true
end type

type gb_where_condition from so_groupbox within w_mat_total_inventory_query
integer x = 1376
integer width = 2491
integer height = 300
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_1 from so_groupbox within w_mat_total_inventory_query
integer width = 1353
integer height = 292
integer taborder = 60
string text = "Category"
end type

type gb_5 from so_groupbox within w_mat_total_inventory_query
integer x = 3881
integer y = 4
integer width = 773
integer height = 292
integer taborder = 60
integer weight = 700
long textcolor = 16711680
string text = "Filter"
end type

