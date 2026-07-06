HA$PBExportHeader$w_product_workstage_magazine_stock_rpt.srw
forward
global type w_product_workstage_magazine_stock_rpt from w_main_root
end type
type rb_workstage from so_radiobutton within w_product_workstage_magazine_stock_rpt
end type
type rb_defect from so_radiobutton within w_product_workstage_magazine_stock_rpt
end type
type ddlb_model from uo_model_name_ddlb within w_product_workstage_magazine_stock_rpt
end type
type st_1 from so_statictext within w_product_workstage_magazine_stock_rpt
end type
type st_2 from so_statictext within w_product_workstage_magazine_stock_rpt
end type
type rb_destroy from so_radiobutton within w_product_workstage_magazine_stock_rpt
end type
type sle_suffix from singlelineedit within w_product_workstage_magazine_stock_rpt
end type
type ddlb_workstage_code from uo_workstage_code_all within w_product_workstage_magazine_stock_rpt
end type
type st_3 from so_statictext within w_product_workstage_magazine_stock_rpt
end type
type em_1 from so_editmask within w_product_workstage_magazine_stock_rpt
end type
type em_2 from so_editmask within w_product_workstage_magazine_stock_rpt
end type
type st_10 from so_statictext within w_product_workstage_magazine_stock_rpt
end type
type gb_1 from groupbox within w_product_workstage_magazine_stock_rpt
end type
type gb_2 from so_groupbox within w_product_workstage_magazine_stock_rpt
end type
end forward

global type w_product_workstage_magazine_stock_rpt from w_main_root
integer width = 5353
integer height = 2868
string title = "Workstage Megazine Query"
rb_workstage rb_workstage
rb_defect rb_defect
ddlb_model ddlb_model
st_1 st_1
st_2 st_2
rb_destroy rb_destroy
sle_suffix sle_suffix
ddlb_workstage_code ddlb_workstage_code
st_3 st_3
em_1 em_1
em_2 em_2
st_10 st_10
gb_1 gb_1
gb_2 gb_2
end type
global w_product_workstage_magazine_stock_rpt w_product_workstage_magazine_stock_rpt

type variables

end variables

on w_product_workstage_magazine_stock_rpt.create
int iCurrent
call super::create
this.rb_workstage=create rb_workstage
this.rb_defect=create rb_defect
this.ddlb_model=create ddlb_model
this.st_1=create st_1
this.st_2=create st_2
this.rb_destroy=create rb_destroy
this.sle_suffix=create sle_suffix
this.ddlb_workstage_code=create ddlb_workstage_code
this.st_3=create st_3
this.em_1=create em_1
this.em_2=create em_2
this.st_10=create st_10
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_workstage
this.Control[iCurrent+2]=this.rb_defect
this.Control[iCurrent+3]=this.ddlb_model
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.rb_destroy
this.Control[iCurrent+7]=this.sle_suffix
this.Control[iCurrent+8]=this.ddlb_workstage_code
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.em_1
this.Control[iCurrent+11]=this.em_2
this.Control[iCurrent+12]=this.st_10
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.gb_2
end on

on w_product_workstage_magazine_stock_rpt.destroy
call super::destroy
destroy(this.rb_workstage)
destroy(this.rb_defect)
destroy(this.ddlb_model)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.rb_destroy)
destroy(this.sle_suffix)
destroy(this.ddlb_workstage_code)
destroy(this.st_3)
destroy(this.em_1)
destroy(this.em_2)
destroy(this.st_10)
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
STRING lvsa_transfer_type[]

CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		
		if rb_workstage.checked = true then 
				
		 	dw_1.retrieve(ddlb_model.getcode( )+'%' , sle_suffix.text+'%',ddlb_workstage_code.getcode( )+'%' , gvi_organization_id)
			dw_1.setfocus()
			
		elseif rb_defect.checked = true then 
			dw_2.retrieve( em_1.text , em_2.text,  ddlb_model.getcode( )+'%' , sle_suffix.text+'%', ddlb_workstage_code.getcode( )+'%' , gvi_organization_id)
			dw_2.setfocus()			
		
	    elseif rb_destroy.checked = true then  
		    dw_3.retrieve(em_1.text , em_2.text,  ddlb_model.getcode( )+'%' , sle_suffix.text+'%', ddlb_workstage_code.getcode( )+'%' , gvi_organization_id)
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

type dw_5 from w_main_root`dw_5 within w_product_workstage_magazine_stock_rpt
integer x = 5
integer y = 368
integer width = 4032
integer height = 1504
boolean titlebar = true
string title = "Transaction List"
end type

type dw_4 from w_main_root`dw_4 within w_product_workstage_magazine_stock_rpt
integer x = 5
integer y = 368
integer width = 4032
integer height = 1504
boolean titlebar = true
string title = "Inventory by Defect list (Occurrencer)"
end type

type dw_3 from w_main_root`dw_3 within w_product_workstage_magazine_stock_rpt
integer x = 5
integer y = 368
integer width = 4032
integer height = 1504
boolean titlebar = true
string title = "Inventory by Destroy list"
string dataobject = "d_product_inventory_distroy_lst_dongdo"
end type

type dw_2 from w_main_root`dw_2 within w_product_workstage_magazine_stock_rpt
integer x = 5
integer y = 368
integer width = 4032
integer height = 1504
integer taborder = 0
boolean titlebar = true
string title = "Inventory by Defect list"
string dataobject = "d_product_inventory_defect_lst_dongdo"
end type

type dw_1 from w_main_root`dw_1 within w_product_workstage_magazine_stock_rpt
integer x = 5
integer y = 368
integer width = 4032
integer height = 1504
integer taborder = 0
boolean titlebar = true
string title = "Inventory by Workstage list"
string dataobject = "d_product_inventory_workstage_lst_dongdo"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_product_workstage_magazine_stock_rpt
end type

type rb_workstage from so_radiobutton within w_product_workstage_magazine_stock_rpt
integer x = 55
integer y = 80
integer width = 782
boolean bringtotop = true
integer weight = 700
string text = "Inventory by Workstage"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1

end event

type rb_defect from so_radiobutton within w_product_workstage_magazine_stock_rpt
integer x = 55
integer y = 156
integer width = 782
boolean bringtotop = true
integer weight = 700
string text = "Inventory by Defect"
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
selected_data_window = dw_2
end event

type ddlb_model from uo_model_name_ddlb within w_product_workstage_magazine_stock_rpt
integer x = 969
integer y = 208
integer taborder = 70
boolean bringtotop = true
end type

type st_1 from so_statictext within w_product_workstage_magazine_stock_rpt
integer x = 1783
integer y = 116
integer width = 366
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Suffix"
end type

type st_2 from so_statictext within w_product_workstage_magazine_stock_rpt
integer x = 983
integer y = 116
integer width = 809
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Model"
end type

type rb_destroy from so_radiobutton within w_product_workstage_magazine_stock_rpt
integer x = 55
integer y = 236
integer width = 782
boolean bringtotop = true
integer weight = 700
string text = "Inventory by Destroy"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3
end event

type sle_suffix from singlelineedit within w_product_workstage_magazine_stock_rpt
integer x = 1783
integer y = 208
integer width = 366
integer height = 84
integer taborder = 80
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

type ddlb_workstage_code from uo_workstage_code_all within w_product_workstage_magazine_stock_rpt
integer x = 2162
integer y = 204
integer width = 635
integer height = 1616
integer taborder = 20
boolean bringtotop = true
end type

type st_3 from so_statictext within w_product_workstage_magazine_stock_rpt
integer x = 2162
integer y = 116
integer width = 635
integer height = 68
boolean bringtotop = true
string text = "Workstage Code"
end type

type em_1 from so_editmask within w_product_workstage_magazine_stock_rpt
integer x = 2811
integer y = 208
integer width = 594
integer taborder = 40
boolean bringtotop = true
integer weight = 400
string text = ""
alignment alignment = left!
maskdatatype maskdatatype = datetimemask!
string mask = "yyyy/mm/dd hh:mm:ss"
boolean dropdowncalendar = true
end type

event constructor;call super::constructor;this.text =string( f_sysdate())
end event

type em_2 from so_editmask within w_product_workstage_magazine_stock_rpt
integer x = 3415
integer y = 208
integer width = 594
integer taborder = 50
boolean bringtotop = true
integer weight = 400
string text = ""
alignment alignment = left!
maskdatatype maskdatatype = datetimemask!
string mask = "yyyy/mm/dd hh:mm:ss"
boolean dropdowncalendar = true
end type

event constructor;call super::constructor;this.text =string( f_sysdate())
end event

type st_10 from so_statictext within w_product_workstage_magazine_stock_rpt
integer x = 2825
integer y = 120
integer width = 1179
integer height = 68
boolean bringtotop = true
string text = "Date"
end type

type gb_1 from groupbox within w_product_workstage_magazine_stock_rpt
integer x = 910
integer y = 4
integer width = 3122
integer height = 348
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

type gb_2 from so_groupbox within w_product_workstage_magazine_stock_rpt
integer width = 896
integer height = 348
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

