HA$PBExportHeader$w_mat_inventory_close_report.srw
$PBExportComments$Material Inventory Close Report
forward
global type w_mat_inventory_close_report from w_main_root
end type
type st_yyyymm from so_statictext within w_mat_inventory_close_report
end type
type st_item_code from so_statictext within w_mat_inventory_close_report
end type
type em_yyyymm from uo_ym within w_mat_inventory_close_report
end type
type ddlb_item_code from uo_item_code within w_mat_inventory_close_report
end type
type ddlb_supplier_code from uo_supplier_code within w_mat_inventory_close_report
end type
type st_1 from so_statictext within w_mat_inventory_close_report
end type
type cb_1 from so_commandbutton within w_mat_inventory_close_report
end type
type rb_close from so_radiobutton within w_mat_inventory_close_report
end type
type rb_1 from so_radiobutton within w_mat_inventory_close_report
end type
type rb_all from so_radiobutton within w_mat_inventory_close_report
end type
type rb_2 from so_radiobutton within w_mat_inventory_close_report
end type
type rb_3 from so_radiobutton within w_mat_inventory_close_report
end type
type rb_4 from so_radiobutton within w_mat_inventory_close_report
end type
type ddlb_location_code from uo_basecode within w_mat_inventory_close_report
end type
type st_5 from so_statictext within w_mat_inventory_close_report
end type
type cb_2 from so_commandbutton within w_mat_inventory_close_report
end type
type sle_material_mfs from so_singlelineedit within w_mat_inventory_close_report
end type
type st_7 from so_statictext within w_mat_inventory_close_report
end type
type ddlb_customer_code from uo_customer_code_name within w_mat_inventory_close_report
end type
type st_2 from so_statictext within w_mat_inventory_close_report
end type
type gb_where_condition from so_groupbox within w_mat_inventory_close_report
end type
type gb_1 from so_groupbox within w_mat_inventory_close_report
end type
type gb_2 from so_groupbox within w_mat_inventory_close_report
end type
type gb_3 from so_groupbox within w_mat_inventory_close_report
end type
end forward

global type w_mat_inventory_close_report from w_main_root
integer width = 6025
integer height = 2944
string title = "Material Inventory Close"
st_yyyymm st_yyyymm
st_item_code st_item_code
em_yyyymm em_yyyymm
ddlb_item_code ddlb_item_code
ddlb_supplier_code ddlb_supplier_code
st_1 st_1
cb_1 cb_1
rb_close rb_close
rb_1 rb_1
rb_all rb_all
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
ddlb_location_code ddlb_location_code
st_5 st_5
cb_2 cb_2
sle_material_mfs sle_material_mfs
st_7 st_7
ddlb_customer_code ddlb_customer_code
st_2 st_2
gb_where_condition gb_where_condition
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_mat_inventory_close_report w_mat_inventory_close_report

on w_mat_inventory_close_report.create
int iCurrent
call super::create
this.st_yyyymm=create st_yyyymm
this.st_item_code=create st_item_code
this.em_yyyymm=create em_yyyymm
this.ddlb_item_code=create ddlb_item_code
this.ddlb_supplier_code=create ddlb_supplier_code
this.st_1=create st_1
this.cb_1=create cb_1
this.rb_close=create rb_close
this.rb_1=create rb_1
this.rb_all=create rb_all
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.ddlb_location_code=create ddlb_location_code
this.st_5=create st_5
this.cb_2=create cb_2
this.sle_material_mfs=create sle_material_mfs
this.st_7=create st_7
this.ddlb_customer_code=create ddlb_customer_code
this.st_2=create st_2
this.gb_where_condition=create gb_where_condition
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_yyyymm
this.Control[iCurrent+2]=this.st_item_code
this.Control[iCurrent+3]=this.em_yyyymm
this.Control[iCurrent+4]=this.ddlb_item_code
this.Control[iCurrent+5]=this.ddlb_supplier_code
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.rb_close
this.Control[iCurrent+9]=this.rb_1
this.Control[iCurrent+10]=this.rb_all
this.Control[iCurrent+11]=this.rb_2
this.Control[iCurrent+12]=this.rb_3
this.Control[iCurrent+13]=this.rb_4
this.Control[iCurrent+14]=this.ddlb_location_code
this.Control[iCurrent+15]=this.st_5
this.Control[iCurrent+16]=this.cb_2
this.Control[iCurrent+17]=this.sle_material_mfs
this.Control[iCurrent+18]=this.st_7
this.Control[iCurrent+19]=this.ddlb_customer_code
this.Control[iCurrent+20]=this.st_2
this.Control[iCurrent+21]=this.gb_where_condition
this.Control[iCurrent+22]=this.gb_1
this.Control[iCurrent+23]=this.gb_2
this.Control[iCurrent+24]=this.gb_3
end on

on w_mat_inventory_close_report.destroy
call super::destroy
destroy(this.st_yyyymm)
destroy(this.st_item_code)
destroy(this.em_yyyymm)
destroy(this.ddlb_item_code)
destroy(this.ddlb_supplier_code)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.rb_close)
destroy(this.rb_1)
destroy(this.rb_all)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.ddlb_location_code)
destroy(this.st_5)
destroy(this.cb_2)
destroy(this.sle_material_mfs)
destroy(this.st_7)
destroy(this.ddlb_customer_code)
destroy(this.st_2)
destroy(this.gb_where_condition)
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
Gst_set.Report_window    = False  // Report Window  True / Flase

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

event ue_post_open;call super::ue_post_open;
/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
//ddlb_account_code.redraw()
//uo_date_from.settext(string(f_t_sysdate(), 'yyyy/mm')+'/01')
//
//F_CHILD_DW3(DW_1, 'account_code', gvs_language, string(gvi_organization_id), '%')
//
//// $$HEX7$$a5c780bdccb9f4bcecc500c9e4b2$$ENDHEX$$.
//F_CHILD_DW3(DW_1, 'account_book', gvs_language, string(gvi_organization_id), 'B')
//
//// $$HEX8$$70ac98b798ccccb9f4bcecc500c9e4b2$$ENDHEX$$.
//F_CHILD_DW3(DW_1, 'customer', gvs_language, string(gvi_organization_id), 'C')
//
//
//
end event

event ue_data_control;call super::ue_data_control;long row
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		if rb_close.checked = true then 
			dw_1.retrieve( em_yyyymm.text ,  ddlb_item_code.text() + '%' , ddlb_location_code.getcode( )+'%' ,  ddlb_customer_code.getcode()+'%' ,   gvi_organization_id)
			dw_1.setfocus()
		elseif rb_1.checked = true then 
			dw_2.retrieve( em_yyyymm.text ,  ddlb_item_code.text() + '%' , ddlb_location_code.GETCODE()+'%' ,  gvi_organization_id)
			dw_2.setfocus()
		elseif  rb_4.checked = true then 
			dw_3.retrieve( em_yyyymm.text ,  ddlb_item_code.text() + '%' , ddlb_location_code.getcode( )+'%' ,  sle_material_mfs.text+'%' , gvi_organization_id)
			dw_3.setfocus()
		end if
		
	case else
end choose


end event

type dw_5 from w_main_root`dw_5 within w_mat_inventory_close_report
integer y = 328
end type

type dw_4 from w_main_root`dw_4 within w_mat_inventory_close_report
integer y = 328
integer taborder = 20
end type

type dw_3 from w_main_root`dw_3 within w_mat_inventory_close_report
integer y = 328
integer width = 4544
integer height = 2116
integer taborder = 30
boolean titlebar = true
string dataobject = "d_mat_inventory_by_mfs_close_rpt"
end type

type dw_2 from w_main_root`dw_2 within w_mat_inventory_close_report
integer y = 328
integer width = 4544
integer height = 2116
integer taborder = 40
boolean titlebar = true
string title = "Material Receipt Issue List"
string dataobject = "d_mat_receipt_issue_rpt"
end type

type dw_1 from w_main_root`dw_1 within w_mat_inventory_close_report
integer y = 328
integer width = 4544
integer height = 2116
integer taborder = 50
boolean titlebar = true
string title = "Material Inventroy Close List"
string dataobject = "d_mat_inventory_close_rpt"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_mat_inventory_close_report
end type

type st_yyyymm from so_statictext within w_mat_inventory_close_report
integer x = 1024
integer y = 80
integer width = 325
integer height = 72
boolean bringtotop = true
string text = "YYYYMM"
end type

type st_item_code from so_statictext within w_mat_inventory_close_report
integer x = 1792
integer y = 80
integer width = 558
integer height = 72
boolean bringtotop = true
string text = "Item Code"
end type

type em_yyyymm from uo_ym within w_mat_inventory_close_report
integer x = 1024
integer y = 164
integer height = 84
integer taborder = 30
boolean bringtotop = true
end type

type ddlb_item_code from uo_item_code within w_mat_inventory_close_report
integer x = 1797
integer y = 164
integer width = 558
integer taborder = 40
boolean bringtotop = true
end type

type ddlb_supplier_code from uo_supplier_code within w_mat_inventory_close_report
integer x = 1353
integer y = 164
integer width = 439
integer taborder = 30
boolean bringtotop = true
end type

type st_1 from so_statictext within w_mat_inventory_close_report
integer x = 1353
integer y = 80
integer width = 439
integer height = 72
boolean bringtotop = true
string text = "Supplier Code"
end type

type cb_1 from so_commandbutton within w_mat_inventory_close_report
integer x = 4210
integer y = 60
integer height = 120
integer taborder = 40
boolean bringtotop = true
string text = "Inventory Close"
end type

event clicked;string lvs_yyyymm, lvs_supplier_code
int lvi_return 

	if f_object_role_check() = false then return 

	msg = f_msgbox1(1161,this.text)
	if msg = 1 then 
	else
		return 
	end if 
	lvs_yyyymm = em_yyyymm.text
	lvs_supplier_code = ddlb_supplier_code.text
	
	lvi_return = f_mat_inventory_close_location(lvs_yyyymm)
	if lvi_return < 0  then 	
		messagebox('Notify','The process of company inventory close is failure, please try it again.')
		rollback ; 
	else 
	
		commit ; 
		f_msgbox( 170)	
	end if 
		
end event

event rbuttondown;call super::rbuttondown;string lvs_yyyymm, lvs_supplier_code
int lvi_return 

	if f_object_role_check() = false then return 

	msg = f_msgbox1(1161,this.text)
	if msg = 1 then 
	else
		return 
	end if 
	lvs_yyyymm = em_yyyymm.text
	lvs_supplier_code = ddlb_supplier_code.text
	
	lvi_return = f_mat_inventory_close_location_ORIGIN(lvs_yyyymm)
	if lvi_return < 0  then 	
		messagebox('Notify','The process of company inventory close is failure, please try it again.')
		rollback ; 
	else 
	
		commit ; 
		f_msgbox( 170)	
	end if 
		
end event

type rb_close from so_radiobutton within w_mat_inventory_close_report
integer x = 59
integer y = 76
integer width = 841
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Material Inventory List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
selected_data_window = dw_1

end event

type rb_1 from so_radiobutton within w_mat_inventory_close_report
integer x = 59
integer y = 160
integer width = 841
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Material Receipt Issue List"
end type

event clicked;call super::clicked;dw_2.bringtotop = true
selected_data_window = dw_2

end event

type rb_all from so_radiobutton within w_mat_inventory_close_report
integer x = 4855
integer y = 80
integer width = 558
boolean bringtotop = true
integer weight = 700
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.setfilter( '')
dw_1.filter( )
end event

type rb_2 from so_radiobutton within w_mat_inventory_close_report
integer x = 5179
integer y = 80
integer width = 558
boolean bringtotop = true
integer weight = 700
string text = "Inventory Qty > 0"
end type

event clicked;call super::clicked;dw_1.setfilter('mm_inventory_qty > 0 ')
dw_1.filter( )
end event

type rb_3 from so_radiobutton within w_mat_inventory_close_report
integer x = 5179
integer y = 180
integer width = 558
boolean bringtotop = true
integer weight = 700
string text = "Inventory Qty < 0"
end type

event clicked;call super::clicked;dw_1.setfilter('mm_inventory_qty < 0 ')
dw_1.filter( )
end event

type rb_4 from so_radiobutton within w_mat_inventory_close_report
integer x = 59
integer y = 236
integer width = 841
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Material Inventory List(MFS)"
end type

event clicked;call super::clicked;dw_3.bringtotop = true
selected_data_window = dw_3

end event

type ddlb_location_code from uo_basecode within w_mat_inventory_close_report
integer x = 2354
integer y = 164
integer width = 558
integer taborder = 60
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw('MATERIAL LOCATION CODE')
end event

type st_5 from so_statictext within w_mat_inventory_close_report
integer x = 2354
integer y = 80
integer width = 558
integer height = 72
boolean bringtotop = true
long textcolor = 0
string text = "Location Code"
end type

type cb_2 from so_commandbutton within w_mat_inventory_close_report
integer x = 4210
integer y = 180
integer height = 120
integer taborder = 50
boolean bringtotop = true
string text = "Inventory Close(Customer)"
end type

event clicked;call super::clicked;string lvs_yyyymm, lvs_customer_code
int lvi_return 

	if f_object_role_check() = false then return 

	msg = f_msgbox1(1161,this.text)
	if msg = 1 then 
	else
		return 
	end if 
	lvs_yyyymm = em_yyyymm.text
	lvs_customer_code = ddlb_customer_code.getcode()
	
	lvi_return = f_mat_inventory_close_location_4_customer(lvs_yyyymm , lvs_customer_code )
	if lvi_return < 0  then 	
		messagebox('Notify','The process of company inventory close is failure, please try it again.')
		rollback ; 
	else 
	
		commit ; 
		f_msgbox( 170)	
	end if 
		
end event

type sle_material_mfs from so_singlelineedit within w_mat_inventory_close_report
integer x = 2921
integer y = 164
integer width = 645
integer height = 84
integer taborder = 60
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

type st_7 from so_statictext within w_mat_inventory_close_report
integer x = 2921
integer y = 80
integer width = 645
integer height = 72
boolean bringtotop = true
long textcolor = 0
string text = "Material MFS"
end type

type ddlb_customer_code from uo_customer_code_name within w_mat_inventory_close_report
integer x = 3575
integer y = 164
integer width = 562
integer taborder = 60
boolean bringtotop = true
end type

type st_2 from so_statictext within w_mat_inventory_close_report
integer x = 3570
integer y = 80
integer width = 562
integer height = 72
boolean bringtotop = true
long textcolor = 0
string text = "Customer Code"
end type

type gb_where_condition from so_groupbox within w_mat_inventory_close_report
integer x = 951
integer y = 4
integer width = 3214
integer height = 320
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_1 from so_groupbox within w_mat_inventory_close_report
integer x = 27
integer y = 4
integer width = 891
integer height = 320
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_2 from so_groupbox within w_mat_inventory_close_report
integer x = 4174
integer width = 576
integer height = 320
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_3 from so_groupbox within w_mat_inventory_close_report
integer x = 4759
integer width = 1010
integer height = 320
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Filter"
end type

