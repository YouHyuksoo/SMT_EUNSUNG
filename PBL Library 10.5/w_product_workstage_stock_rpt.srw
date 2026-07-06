HA$PBExportHeader$w_product_workstage_stock_rpt.srw
forward
global type w_product_workstage_stock_rpt from w_main_root
end type
type rb_stock_matrix from so_radiobutton within w_product_workstage_stock_rpt
end type
type ddlb_workstage from uo_workstage_code_all within w_product_workstage_stock_rpt
end type
type ddlb_model from uo_model_name_ddlb within w_product_workstage_stock_rpt
end type
type st_1 from so_statictext within w_product_workstage_stock_rpt
end type
type st_2 from so_statictext within w_product_workstage_stock_rpt
end type
type rb_stock_list from so_radiobutton within w_product_workstage_stock_rpt
end type
type rb_all from so_radiobutton within w_product_workstage_stock_rpt
end type
type rb_gt from so_radiobutton within w_product_workstage_stock_rpt
end type
type rb_stock_list_model from so_radiobutton within w_product_workstage_stock_rpt
end type
type gb_1 from groupbox within w_product_workstage_stock_rpt
end type
type gb_2 from so_groupbox within w_product_workstage_stock_rpt
end type
type gb_3 from groupbox within w_product_workstage_stock_rpt
end type
end forward

global type w_product_workstage_stock_rpt from w_main_root
integer width = 5111
integer height = 2648
string title = "Workstage Stock Query"
rb_stock_matrix rb_stock_matrix
ddlb_workstage ddlb_workstage
ddlb_model ddlb_model
st_1 st_1
st_2 st_2
rb_stock_list rb_stock_list
rb_all rb_all
rb_gt rb_gt
rb_stock_list_model rb_stock_list_model
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_product_workstage_stock_rpt w_product_workstage_stock_rpt

type variables

end variables

on w_product_workstage_stock_rpt.create
int iCurrent
call super::create
this.rb_stock_matrix=create rb_stock_matrix
this.ddlb_workstage=create ddlb_workstage
this.ddlb_model=create ddlb_model
this.st_1=create st_1
this.st_2=create st_2
this.rb_stock_list=create rb_stock_list
this.rb_all=create rb_all
this.rb_gt=create rb_gt
this.rb_stock_list_model=create rb_stock_list_model
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_stock_matrix
this.Control[iCurrent+2]=this.ddlb_workstage
this.Control[iCurrent+3]=this.ddlb_model
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.rb_stock_list
this.Control[iCurrent+7]=this.rb_all
this.Control[iCurrent+8]=this.rb_gt
this.Control[iCurrent+9]=this.rb_stock_list_model
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.gb_2
this.Control[iCurrent+12]=this.gb_3
end on

on w_product_workstage_stock_rpt.destroy
call super::destroy
destroy(this.rb_stock_matrix)
destroy(this.ddlb_workstage)
destroy(this.ddlb_model)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.rb_stock_list)
destroy(this.rb_all)
destroy(this.rb_gt)
destroy(this.rb_stock_list_model)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
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

event ue_data_control;call super::ue_data_control;Long ROW , lvi_sign
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		
			if rb_all.checked = true then 
				lvi_sign = -2
			elseif rb_gt.checked = true then 
				lvi_sign = 1
			end if

		if rb_stock_matrix.checked = true then 
				
		 	dw_1.retrieve( ddlb_model.getcode()+'%' , ddlb_workstage.getcode()+'%')
			dw_1.setfocus()
		elseif rb_stock_list.checked = true then 
			dw_2.retrieve( ddlb_model.getcode()+'%' , ddlb_workstage.getcode()+'%' , lvi_sign ,  gvi_organization_id )
			dw_2.setfocus()
		else
			dw_3.retrieve( ddlb_model.getcode()+'%' , ddlb_workstage.getcode()+'%' , lvi_sign ,  gvi_organization_id )
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

type dw_5 from w_main_root`dw_5 within w_product_workstage_stock_rpt
integer y = 360
end type

type dw_4 from w_main_root`dw_4 within w_product_workstage_stock_rpt
integer y = 360
integer width = 4507
integer height = 2120
boolean titlebar = true
end type

type dw_3 from w_main_root`dw_3 within w_product_workstage_stock_rpt
integer y = 360
integer width = 4507
integer height = 2120
boolean titlebar = true
string title = "Model List"
string dataobject = "d_proudct_workstage_stock_4_model_lst"
end type

type dw_2 from w_main_root`dw_2 within w_product_workstage_stock_rpt
integer y = 360
integer width = 4507
integer height = 2120
integer taborder = 0
boolean titlebar = true
string title = "Run List"
string dataobject = "d_proudct_workstage_stock_lst"
end type

type dw_1 from w_main_root`dw_1 within w_product_workstage_stock_rpt
integer y = 360
integer width = 4507
integer height = 2120
integer taborder = 0
boolean titlebar = true
string title = "Matrix"
string dataobject = "d_proudct_workstage_stock_rpt"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_product_workstage_stock_rpt
end type

type rb_stock_matrix from so_radiobutton within w_product_workstage_stock_rpt
integer x = 69
integer y = 96
integer width = 933
boolean bringtotop = true
integer weight = 700
string text = "WorkStage Stock (Matrix)"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1
end event

type ddlb_workstage from uo_workstage_code_all within w_product_workstage_stock_rpt
integer x = 2935
integer y = 180
integer width = 823
integer height = 2024
integer taborder = 60
boolean bringtotop = true
end type

type ddlb_model from uo_model_name_ddlb within w_product_workstage_stock_rpt
integer x = 2112
integer y = 180
integer height = 2024
integer taborder = 70
boolean bringtotop = true
end type

type st_1 from so_statictext within w_product_workstage_stock_rpt
integer x = 2935
integer y = 92
integer width = 805
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "WorkStage"
end type

type st_2 from so_statictext within w_product_workstage_stock_rpt
integer x = 2112
integer y = 100
integer width = 809
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Model"
end type

type rb_stock_list from so_radiobutton within w_product_workstage_stock_rpt
integer x = 69
integer y = 208
integer width = 933
boolean bringtotop = true
integer weight = 700
string text = "WorkStage Stock List (Run No)"
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
selected_data_window = dw_2
end event

type rb_all from so_radiobutton within w_product_workstage_stock_rpt
integer x = 3936
integer y = 108
integer width = 457
integer height = 84
boolean bringtotop = true
integer weight = 700
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;dw_2.setfilter( '')
dw_2.filter( )
end event

type rb_gt from so_radiobutton within w_product_workstage_stock_rpt
integer x = 3936
integer y = 204
integer width = 590
integer height = 84
boolean bringtotop = true
integer weight = 700
string text = "Inventory Qty > 0"
end type

event clicked;call super::clicked;dw_2.setfilter('inventory_qty > 0 ')
dw_2.filter( )
end event

type rb_stock_list_model from so_radiobutton within w_product_workstage_stock_rpt
integer x = 969
integer y = 92
integer width = 850
boolean bringtotop = true
integer weight = 700
string text = "WorkStage Stock List (Model)"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3
end event

type gb_1 from groupbox within w_product_workstage_stock_rpt
integer x = 3854
integer width = 782
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
string text = "Stock List Filter"
end type

type gb_2 from so_groupbox within w_product_workstage_stock_rpt
integer y = 4
integer width = 1883
integer height = 348
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_3 from groupbox within w_product_workstage_stock_rpt
integer x = 2030
integer width = 1787
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

