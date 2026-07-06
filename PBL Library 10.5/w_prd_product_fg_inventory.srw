HA$PBExportHeader$w_prd_product_fg_inventory.srw
$PBExportComments$finish goods $$HEX3$$85c7e0ac2000$$ENDHEX$$/ $$HEX6$$85c7e0ac2000e8cd8cc12000$$ENDHEX$$2017.03.29
forward
global type w_prd_product_fg_inventory from w_main_root
end type
type rb_stock from so_radiobutton within w_prd_product_fg_inventory
end type
type ddlb_model from uo_model_name_ddlb within w_prd_product_fg_inventory
end type
type st_2 from so_statictext within w_prd_product_fg_inventory
end type
type rb_model from so_radiobutton within w_prd_product_fg_inventory
end type
type cb_divide from so_commandbutton within w_prd_product_fg_inventory
end type
type rb_deadstock from so_radiobutton within w_prd_product_fg_inventory
end type
type em_dead_stock_days from so_editmask within w_prd_product_fg_inventory
end type
type st_1 from so_statictext within w_prd_product_fg_inventory
end type
type ddlb_product_loaction from uo_basecode within w_prd_product_fg_inventory
end type
type st_3 from so_statictext within w_prd_product_fg_inventory
end type
type ddlb_pack_type from uo_basecode within w_prd_product_fg_inventory
end type
type st_4 from so_statictext within w_prd_product_fg_inventory
end type
type cb_location_move from so_commandbutton within w_prd_product_fg_inventory
end type
type rb_1 from so_radiobutton within w_prd_product_fg_inventory
end type
type em_marking_passed_days from so_editmask within w_prd_product_fg_inventory
end type
type st_5 from so_statictext within w_prd_product_fg_inventory
end type
type gb_1 from groupbox within w_prd_product_fg_inventory
end type
type gb_2 from so_groupbox within w_prd_product_fg_inventory
end type
type gb_3 from groupbox within w_prd_product_fg_inventory
end type
type gb_4 from groupbox within w_prd_product_fg_inventory
end type
end forward

global type w_prd_product_fg_inventory from w_main_root
integer width = 5504
integer height = 2648
string title = "Product Inventory"
rb_stock rb_stock
ddlb_model ddlb_model
st_2 st_2
rb_model rb_model
cb_divide cb_divide
rb_deadstock rb_deadstock
em_dead_stock_days em_dead_stock_days
st_1 st_1
ddlb_product_loaction ddlb_product_loaction
st_3 st_3
ddlb_pack_type ddlb_pack_type
st_4 st_4
cb_location_move cb_location_move
rb_1 rb_1
em_marking_passed_days em_marking_passed_days
st_5 st_5
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
end type
global w_prd_product_fg_inventory w_prd_product_fg_inventory

type variables

end variables

on w_prd_product_fg_inventory.create
int iCurrent
call super::create
this.rb_stock=create rb_stock
this.ddlb_model=create ddlb_model
this.st_2=create st_2
this.rb_model=create rb_model
this.cb_divide=create cb_divide
this.rb_deadstock=create rb_deadstock
this.em_dead_stock_days=create em_dead_stock_days
this.st_1=create st_1
this.ddlb_product_loaction=create ddlb_product_loaction
this.st_3=create st_3
this.ddlb_pack_type=create ddlb_pack_type
this.st_4=create st_4
this.cb_location_move=create cb_location_move
this.rb_1=create rb_1
this.em_marking_passed_days=create em_marking_passed_days
this.st_5=create st_5
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_stock
this.Control[iCurrent+2]=this.ddlb_model
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.rb_model
this.Control[iCurrent+5]=this.cb_divide
this.Control[iCurrent+6]=this.rb_deadstock
this.Control[iCurrent+7]=this.em_dead_stock_days
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.ddlb_product_loaction
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.ddlb_pack_type
this.Control[iCurrent+12]=this.st_4
this.Control[iCurrent+13]=this.cb_location_move
this.Control[iCurrent+14]=this.rb_1
this.Control[iCurrent+15]=this.em_marking_passed_days
this.Control[iCurrent+16]=this.st_5
this.Control[iCurrent+17]=this.gb_1
this.Control[iCurrent+18]=this.gb_2
this.Control[iCurrent+19]=this.gb_3
this.Control[iCurrent+20]=this.gb_4
end on

on w_prd_product_fg_inventory.destroy
call super::destroy
destroy(this.rb_stock)
destroy(this.ddlb_model)
destroy(this.st_2)
destroy(this.rb_model)
destroy(this.cb_divide)
destroy(this.rb_deadstock)
destroy(this.em_dead_stock_days)
destroy(this.st_1)
destroy(this.ddlb_product_loaction)
destroy(this.st_3)
destroy(this.ddlb_pack_type)
destroy(this.st_4)
destroy(this.cb_location_move)
destroy(this.rb_1)
destroy(this.em_marking_passed_days)
destroy(this.st_5)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
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
F_MENU_CONTROL('RETRIEVE' , True)  // All Data Control





end event

event ue_data_control;call super::ue_data_control;Long ROW
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		
		if rb_stock.checked = true then 
				
		 	dw_1.retrieve( ddlb_model.getcode()+'%' , ddlb_product_loaction.GETCODE() + '%' , ddlb_pack_type.getcode()+'%' , gvi_organization_id )
			dw_1.setfocus()
			
		elseif rb_model.checked = true then 
             dw_2.retrieve(ddlb_model.getcode()+'%', ddlb_product_loaction.GETCODE() + '%' ,ddlb_pack_type.getcode()+'%' , gvi_organization_id  )
		    dw_2.setfocus()
			 
		elseif rb_deadstock.checked = true then 
		    dw_3.retrieve(ddlb_model.getcode()+'%', ddlb_product_loaction.GETCODE() + '%', long(em_dead_stock_days.text) ,ddlb_pack_type.getcode()+'%' , gvi_organization_id  )
		    dw_3.setfocus()
		else
		    dw_4.retrieve(ddlb_model.getcode()+'%', ddlb_product_loaction.GETCODE() + '%', long(em_marking_passed_days.text) ,ddlb_pack_type.getcode()+'%' , gvi_organization_id  )
		    dw_4.setfocus()			
		end if 
				
	CASE ELSE
END CHOOSE
end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_prd_product_fg_inventory
integer y = 564
end type

type dw_4 from w_main_root`dw_4 within w_prd_product_fg_inventory
integer y = 416
integer width = 4507
integer height = 2120
boolean titlebar = true
string title = "FG Stock ( Marking Passed )"
string dataobject = "d_product_fg_inventory_marking_Passed_lst"
end type

type dw_3 from w_main_root`dw_3 within w_prd_product_fg_inventory
integer y = 416
integer width = 4507
integer height = 2120
boolean titlebar = true
string title = "FG Stock ( Dead Stock )"
string dataobject = "d_product_fg_inventory_deadstock_lst"
end type

type dw_2 from w_main_root`dw_2 within w_prd_product_fg_inventory
integer y = 416
integer width = 4507
integer height = 2120
integer taborder = 0
boolean titlebar = true
string title = "FG Stock ( Model )"
string dataobject = "d_product_fg_inventory_model"
end type

type dw_1 from w_main_root`dw_1 within w_prd_product_fg_inventory
integer y = 416
integer width = 4507
integer height = 2120
integer taborder = 0
boolean titlebar = true
string title = "FG Stock ( List )"
string dataobject = "d_product_fg_inventory_lst"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_prd_product_fg_inventory
end type

type rb_stock from so_radiobutton within w_prd_product_fg_inventory
integer x = 41
integer y = 72
integer width = 690
boolean bringtotop = true
integer weight = 700
string text = "FG Stock ( List )"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1

em_dead_stock_days.ENABLED = FALSE
end event

type ddlb_model from uo_model_name_ddlb within w_prd_product_fg_inventory
integer x = 891
integer y = 184
integer height = 2024
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
end type

type st_2 from so_statictext within w_prd_product_fg_inventory
integer x = 891
integer y = 100
integer width = 809
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Model"
end type

type rb_model from so_radiobutton within w_prd_product_fg_inventory
integer x = 41
integer y = 156
integer width = 690
boolean bringtotop = true
integer weight = 700
string text = "FG Stock ( Model )"
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
selected_data_window = dw_2

em_dead_stock_days.ENABLED = FALSE
end event

type cb_divide from so_commandbutton within w_prd_product_fg_inventory
integer x = 4142
integer y = 108
integer width = 507
integer height = 192
integer taborder = 40
boolean bringtotop = true
string text = "Inventory Divide"
end type

event clicked;open(w_prd_fg_magazine_divide)
end event

type rb_deadstock from so_radiobutton within w_prd_product_fg_inventory
integer x = 41
integer y = 228
integer width = 690
boolean bringtotop = true
integer weight = 700
string text = "FG Stock ( Dead Stock )"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3

em_dead_stock_days.ENABLED = TRUE
end event

type em_dead_stock_days from so_editmask within w_prd_product_fg_inventory
integer x = 1719
integer y = 180
integer width = 421
integer height = 96
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
boolean enabled = false
string text = "000"
alignment alignment = center!
string mask = "###,##0"
boolean spin = true
end type

event constructor;call super::constructor;select f_get_sys_config('PRODUCT_DEAD_STOCK_DAYS',:gvi_organization_id ) 
   into :this.text 
   from dual ; 
	
	
end event

type st_1 from so_statictext within w_prd_product_fg_inventory
integer x = 1719
integer y = 96
integer width = 416
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Inventory Days"
end type

type ddlb_product_loaction from uo_basecode within w_prd_product_fg_inventory
integer x = 2619
integer y = 184
integer width = 690
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
end type

event constructor;call super::constructor;redraw('PRODUCT LOCATION CODE')
end event

type st_3 from so_statictext within w_prd_product_fg_inventory
integer x = 2619
integer y = 100
integer width = 690
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Product Location"
end type

type ddlb_pack_type from uo_basecode within w_prd_product_fg_inventory
integer x = 3323
integer y = 180
integer width = 690
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
end type

event constructor;call super::constructor;redraw('PACK TYPE')
end event

type st_4 from so_statictext within w_prd_product_fg_inventory
integer x = 3328
integer y = 96
integer width = 690
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Pack Type"
end type

type cb_location_move from so_commandbutton within w_prd_product_fg_inventory
integer x = 4745
integer y = 108
integer width = 507
integer height = 192
integer taborder = 40
boolean bringtotop = true
string text = "Location Move"
end type

event clicked;open(w_prd_fg_inv_loc_move)
end event

type rb_1 from so_radiobutton within w_prd_product_fg_inventory
integer x = 41
integer y = 304
integer width = 800
boolean bringtotop = true
integer weight = 700
string text = "FG Stock ( Marking Passed )"
end type

event clicked;call super::clicked;dw_4.bringtotop = true 
selected_data_window = dw_4

em_marking_passed_days.ENABLED = TRUE
end event

type em_marking_passed_days from so_editmask within w_prd_product_fg_inventory
integer x = 2149
integer y = 180
integer width = 421
integer height = 96
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
boolean enabled = false
string text = "000"
alignment alignment = center!
string mask = "###,##0.0"
boolean spin = true
end type

event constructor;call super::constructor;select f_get_sys_config('PRODUCT_MARKING_PASSED_DAYS',:gvi_organization_id ) 
   into :this.text 
   from dual ; 
	
	
end event

type st_5 from so_statictext within w_prd_product_fg_inventory
integer x = 2149
integer y = 92
integer width = 421
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Mk Passed Days"
end type

type gb_1 from groupbox within w_prd_product_fg_inventory
integer x = 878
integer y = 12
integer width = 3191
integer height = 392
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

type gb_2 from so_groupbox within w_prd_product_fg_inventory
integer width = 864
integer height = 408
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_3 from groupbox within w_prd_product_fg_inventory
integer x = 4713
integer y = 16
integer width = 571
integer height = 392
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 12632256
string text = "Location Move"
end type

type gb_4 from groupbox within w_prd_product_fg_inventory
integer x = 4082
integer y = 16
integer width = 613
integer height = 392
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 12632256
string text = "Inventory Divde"
end type

