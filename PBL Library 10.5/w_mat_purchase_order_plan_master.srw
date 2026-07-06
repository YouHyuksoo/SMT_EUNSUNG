HA$PBExportHeader$w_mat_purchase_order_plan_master.srw
$PBExportComments$$$HEX6$$fcc838bb08c615c800adacb9$$ENDHEX$$
forward
global type w_mat_purchase_order_plan_master from w_main_root
end type
type st_5 from so_statictext within w_mat_purchase_order_plan_master
end type
type uo_item from uo_item_code within w_mat_purchase_order_plan_master
end type
type st_3 from so_statictext within w_mat_purchase_order_plan_master
end type
type ddlb_supplier_code from uo_supplier_code within w_mat_purchase_order_plan_master
end type
type rb_order_plan_list from so_radiobutton within w_mat_purchase_order_plan_master
end type
type rb_order_plan_matrix from so_radiobutton within w_mat_purchase_order_plan_master
end type
type tab_1 from tab within w_mat_purchase_order_plan_master
end type
type tabpage_1 from userobject within tab_1
end type
type rb_from_manual_plan from so_radiobutton within tabpage_1
end type
type cb_purchase_do from so_commandbutton within tabpage_1
end type
type st_1 from statictext within tabpage_1
end type
type uo_po_date from uo_ymd_calendar within tabpage_1
end type
type cb_gen_do from so_commandbutton within tabpage_1
end type
type rb_from_sale_plan from so_radiobutton within tabpage_1
end type
type rb_from_master_plan from so_radiobutton within tabpage_1
end type
type cb_price_reset from so_commandbutton within tabpage_1
end type
type cb_1 from so_commandbutton within tabpage_1
end type
type cb_purchase_po from so_commandbutton within tabpage_1
end type
type cb_gen_po from so_commandbutton within tabpage_1
end type
type tabpage_1 from userobject within tab_1
rb_from_manual_plan rb_from_manual_plan
cb_purchase_do cb_purchase_do
st_1 st_1
uo_po_date uo_po_date
cb_gen_do cb_gen_do
rb_from_sale_plan rb_from_sale_plan
rb_from_master_plan rb_from_master_plan
cb_price_reset cb_price_reset
cb_1 cb_1
cb_purchase_po cb_purchase_po
cb_gen_po cb_gen_po
end type
type tabpage_2 from userobject within tab_1
end type
type cbx_apply_leadtime from so_checkbox within tabpage_2
end type
type cbx_distinct_mfs from so_checkbox within tabpage_2
end type
type cbx_outside_inv from so_checkbox within tabpage_2
end type
type cbx_apply_workstage_inventory_qty from so_checkbox within tabpage_2
end type
type cbx_apply_calendar from so_checkbox within tabpage_2
end type
type cbx_round from so_checkbox within tabpage_2
end type
type cbx_apply_auto_order_rule from so_checkbox within tabpage_2
end type
type cbx_apply_inventory_qty from so_checkbox within tabpage_2
end type
type cbx_apply_unit_price from so_checkbox within tabpage_2
end type
type cbx_apply_arrival_qty from so_checkbox within tabpage_2
end type
type cbx_apply_order_qty from so_checkbox within tabpage_2
end type
type tabpage_2 from userobject within tab_1
cbx_apply_leadtime cbx_apply_leadtime
cbx_distinct_mfs cbx_distinct_mfs
cbx_outside_inv cbx_outside_inv
cbx_apply_workstage_inventory_qty cbx_apply_workstage_inventory_qty
cbx_apply_calendar cbx_apply_calendar
cbx_round cbx_round
cbx_apply_auto_order_rule cbx_apply_auto_order_rule
cbx_apply_inventory_qty cbx_apply_inventory_qty
cbx_apply_unit_price cbx_apply_unit_price
cbx_apply_arrival_qty cbx_apply_arrival_qty
cbx_apply_order_qty cbx_apply_order_qty
end type
type tabpage_4 from userobject within tab_1
end type
type cb_6 from so_commandbutton within tabpage_4
end type
type cb_5 from so_commandbutton within tabpage_4
end type
type tabpage_4 from userobject within tab_1
cb_6 cb_6
cb_5 cb_5
end type
type tab_1 from tab within w_mat_purchase_order_plan_master
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_4 tabpage_4
end type
type uo_generate_dateend from uo_ymd_calendar within w_mat_purchase_order_plan_master
end type
type st_plan_date from so_statictext within w_mat_purchase_order_plan_master
end type
type uo_generate_dateset from uo_ymd_calendar within w_mat_purchase_order_plan_master
end type
type rb_gen_po from so_radiobutton within w_mat_purchase_order_plan_master
end type
type rb_gen_do from so_radiobutton within w_mat_purchase_order_plan_master
end type
type rb_product_sale_plan from so_radiobutton within w_mat_purchase_order_plan_master
end type
type rb_product_master_plan from so_radiobutton within w_mat_purchase_order_plan_master
end type
type st_2 from so_statictext within w_mat_purchase_order_plan_master
end type
type ddlb_line_code from uo_line_code within w_mat_purchase_order_plan_master
end type
type st_4 from so_statictext within w_mat_purchase_order_plan_master
end type
type rb_manual_plan from so_radiobutton within w_mat_purchase_order_plan_master
end type
type ddlb_model_name from uo_set_model_name_ddlb within w_mat_purchase_order_plan_master
end type
type gb_where_condition from so_groupbox within w_mat_purchase_order_plan_master
end type
type gb_1 from so_groupbox within w_mat_purchase_order_plan_master
end type
type gb_3 from so_groupbox within w_mat_purchase_order_plan_master
end type
end forward

global type w_mat_purchase_order_plan_master from w_main_root
integer width = 5239
integer height = 2740
string title = "Material Purchase Order Plan Master"
st_5 st_5
uo_item uo_item
st_3 st_3
ddlb_supplier_code ddlb_supplier_code
rb_order_plan_list rb_order_plan_list
rb_order_plan_matrix rb_order_plan_matrix
tab_1 tab_1
uo_generate_dateend uo_generate_dateend
st_plan_date st_plan_date
uo_generate_dateset uo_generate_dateset
rb_gen_po rb_gen_po
rb_gen_do rb_gen_do
rb_product_sale_plan rb_product_sale_plan
rb_product_master_plan rb_product_master_plan
st_2 st_2
ddlb_line_code ddlb_line_code
st_4 st_4
rb_manual_plan rb_manual_plan
ddlb_model_name ddlb_model_name
gb_where_condition gb_where_condition
gb_1 gb_1
gb_3 gb_3
end type
global w_mat_purchase_order_plan_master w_mat_purchase_order_plan_master

type variables

end variables

on w_mat_purchase_order_plan_master.create
int iCurrent
call super::create
this.st_5=create st_5
this.uo_item=create uo_item
this.st_3=create st_3
this.ddlb_supplier_code=create ddlb_supplier_code
this.rb_order_plan_list=create rb_order_plan_list
this.rb_order_plan_matrix=create rb_order_plan_matrix
this.tab_1=create tab_1
this.uo_generate_dateend=create uo_generate_dateend
this.st_plan_date=create st_plan_date
this.uo_generate_dateset=create uo_generate_dateset
this.rb_gen_po=create rb_gen_po
this.rb_gen_do=create rb_gen_do
this.rb_product_sale_plan=create rb_product_sale_plan
this.rb_product_master_plan=create rb_product_master_plan
this.st_2=create st_2
this.ddlb_line_code=create ddlb_line_code
this.st_4=create st_4
this.rb_manual_plan=create rb_manual_plan
this.ddlb_model_name=create ddlb_model_name
this.gb_where_condition=create gb_where_condition
this.gb_1=create gb_1
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_5
this.Control[iCurrent+2]=this.uo_item
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.ddlb_supplier_code
this.Control[iCurrent+5]=this.rb_order_plan_list
this.Control[iCurrent+6]=this.rb_order_plan_matrix
this.Control[iCurrent+7]=this.tab_1
this.Control[iCurrent+8]=this.uo_generate_dateend
this.Control[iCurrent+9]=this.st_plan_date
this.Control[iCurrent+10]=this.uo_generate_dateset
this.Control[iCurrent+11]=this.rb_gen_po
this.Control[iCurrent+12]=this.rb_gen_do
this.Control[iCurrent+13]=this.rb_product_sale_plan
this.Control[iCurrent+14]=this.rb_product_master_plan
this.Control[iCurrent+15]=this.st_2
this.Control[iCurrent+16]=this.ddlb_line_code
this.Control[iCurrent+17]=this.st_4
this.Control[iCurrent+18]=this.rb_manual_plan
this.Control[iCurrent+19]=this.ddlb_model_name
this.Control[iCurrent+20]=this.gb_where_condition
this.Control[iCurrent+21]=this.gb_1
this.Control[iCurrent+22]=this.gb_3
end on

on w_mat_purchase_order_plan_master.destroy
call super::destroy
destroy(this.st_5)
destroy(this.uo_item)
destroy(this.st_3)
destroy(this.ddlb_supplier_code)
destroy(this.rb_order_plan_list)
destroy(this.rb_order_plan_matrix)
destroy(this.tab_1)
destroy(this.uo_generate_dateend)
destroy(this.st_plan_date)
destroy(this.uo_generate_dateset)
destroy(this.rb_gen_po)
destroy(this.rb_gen_do)
destroy(this.rb_product_sale_plan)
destroy(this.rb_product_master_plan)
destroy(this.st_2)
destroy(this.ddlb_line_code)
destroy(this.st_4)
destroy(this.rb_manual_plan)
destroy(this.ddlb_model_name)
destroy(this.gb_where_condition)
destroy(this.gb_1)
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

IF rb_order_plan_list.CHECKED = TRUE THEN
	f_menu_control('DATA_CONTROL_DELETE' , TRUE)  // $$HEX6$$adc01cc8ccb9200000aca5b2$$ENDHEX$$
ELSEIF rb_manual_plan.checked = true then 
	f_menu_control('DATA_CONTROL' , TRUE)  
else
	f_menu_control('DATA_CONTROL' , FALSE) 
END IF

end event

event ue_data_control;call super::ue_data_control;Long ROW
STRING  lvs_order_type

CHOOSE CASE Gvs_Ue_DATA_control
	CASE 'RETRIEVE'	
		
		       IF RB_ORDER_PLAN_LIST.CHECKED = TRUE THEN 
				
				DW_1.RESET()
				IF rb_gen_po.CHecked =true then 
					lvs_order_type = 'F'
				else
					lvs_order_type = 'O'					
				end if 
				DW_1.RETRIEVE( DDLB_SUPPLIER_CODE.TEXT+'%' , ddlb_model_name.getcode( )+'%'  , UO_ITEM.TEXT()+'%' , uo_generate_dateset.text() ,  uo_generate_dateend.text() , lvs_order_type , GVI_ORGANIZATION_ID)
				DW_1.SETFOCUS()
				
			ELSEIF rb_order_plan_matrix.CHECKED = TRUE THEN 
				
				DW_2.RESET()
				DW_2.RETRIEVE( DDLB_SUPPLIER_CODE.TEXT+'%' , UO_ITEM.TEXT()+'%' , uo_generate_dateset.text() ,  uo_generate_dateend.text() , GVI_ORGANIZATION_ID)
				DW_2.SETFOCUS()
				f_child_dw3( dw_2 , 'line_type' , gvs_language , string(gvi_organization_id) , 'LINE TYPE' )
				
				
			ELSEIF rb_product_sale_plan.CHECKED = TRUE THEN 
				DW_3.RESET()
				DW_3.RETRIEVE(  uo_generate_dateset.text( ) , uo_generate_dateend.text( ) , ddlb_model_name.getcode( )+'%'   , GVI_ORGANIZATION_ID)
				DW_3.SETFOCUS()								

			ELSEIF rb_product_master_plan.CHECKED = TRUE THEN 
				DW_4.RESET()
				DW_4.RETRIEVE( uo_generate_dateset.text() ,uo_generate_dateend.text() , ddlb_model_name.getcode( )+'%'   , ddlb_line_code.getcode( )+'%' ,  GVI_ORGANIZATION_ID)
				DW_4.SETFOCUS()								
			ELSEIF rb_manual_plan.CHecked = TRUE THEN 
				DW_5.RESET()
				DW_5.RETRIEVE( uo_generate_dateset.text() ,uo_generate_dateend.text() , ddlb_model_name.getitem( )+'%'  ,  GVI_ORGANIZATION_ID)
				DW_5.SETFOCUS()												
				
			END IF

	CASE 'INSERT' 
		
			ROW = DW_5.INSERTROW(DW_5.GETROW())
			DW_5.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_5 , ROW , 'ALL')
			
			DW_5.SETITEM( ROW, 'requirment_plan_date' ,F_T_SYSDATE() )
			DW_5.SETITEM( ROW, 'requirment_plan_seq' ,  f_get_requirment_plan_seq() )	
			F_MSG_ST(152)
		
	CASE 'DELETE'
		
		IF RB_ORDER_PLAN_LIST.Checked = TRUE THEN 
				IF DW_1.GETROW() < 1 THEN RETURN 
				  
				MSG = F_MSGBOX(1003) 
				IF MSG = 1 THEN
					GVL_ROW_DELETED = DW_1.GETROW()			
					DW_1.DELETEROW(GVL_ROW_DELETED)		
					DW_1.SETFOCUS()
					ROW = DW_1.GETROW()
					DW_1.SCROLLTOROW(ROW)
					DW_1.SETCOLUMN(1)
				END IF
			else
				IF DW_5.GETROW() < 1 THEN RETURN 
				  
				MSG = F_MSGBOX(1003) 
				IF MSG = 1 THEN
					GVL_ROW_DELETED = DW_5.GETROW()			
					DW_5.DELETEROW(GVL_ROW_DELETED)		
					DW_5.SETFOCUS()
					ROW = DW_5.GETROW()
					DW_5.SCROLLTOROW(ROW)
					DW_5.SETCOLUMN(1)
				END IF				
				
			end if 
			
	CASE 'UPDATE'
		if rb_order_plan_list.checked = true then 
			
				IF  DW_1.UPDATE() < 0 THEN
				ROLLBACK;
				ELSE
				 COMMIT;
				  F_MSG_ST(170 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
				END IF							
			else
				
				IF  DW_5.UPDATE() < 0 THEN
					ROLLBACK;
				ELSE
					 COMMIT;
					  F_MSG_ST(170 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
				END IF							
				
			end if 
	CASE ELSE

END CHOOSE
end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
uo_generate_dateend.settext(     string(f_v_sysdate(-3) ))
end event

type dw_5 from w_main_root`dw_5 within w_mat_purchase_order_plan_master
integer y = 604
integer width = 4366
integer height = 1988
boolean titlebar = true
string title = "Manual Plan"
string dataobject = "d_mat_master_plan_4_po_lst"
end type

event dw_5::rbuttondown;call super::rbuttondown;IF DWO.NAME = 'item_code' THEN
	OPEN(W_DES_SET_ITEM_POPUP)
	
	IF message.stringparm = '' THEN 
		RETURN
	END IF
	THIS.SETITEM( ROW , 'item_code' , MESSAGE.STRINGPARM )			
	THIS.SETITEM( ROW , 'item_name' , Gst_return.Gvs_return[3] )			
	THIS.SETITEM( ROW , 'item_spec' , Gst_return.Gvs_return[4] )			
	THIS.SETITEM( ROW , 'item_uom' , Gst_return.Gvs_return[5] )			
	Gst_return.Gvs_return[3]  = ''
	Gst_return.Gvs_return[4]  = ''
	Gst_return.Gvs_return[5]  = ''	
END IF
end event

event dw_5::itemchanged;call super::itemchanged;String lvs_return
if dwo.name = 'item_code' then 
   lvs_return = f_set_item_name_spec_uom( this , row , this.object.item_code[row] )		
   if 	lvs_return = 'ERROR' THEN 
		return 1
   end if	
	if lvs_return = 'NOTFOUND' then 
		return 1  
	end if 		
end if
end event

type dw_4 from w_main_root`dw_4 within w_mat_purchase_order_plan_master
integer y = 604
integer width = 4366
integer height = 1988
boolean titlebar = true
string title = "Product Master Plan List"
string dataobject = "d_pln_master_plan_4_order_plan_lst"
end type

event dw_4::rbuttondown;call super::rbuttondown;string lvs_item_code

if dw_4.getrow() < 1 then return

lvs_item_code = dw_4.getitemstring( dw_4.getrow() , 'item_code' )
if lvs_item_code = '' or isnull(lvs_item_code) then return

openwithparm( w_des_bom_query_popup , lvs_item_code )
end event

type dw_3 from w_main_root`dw_3 within w_mat_purchase_order_plan_master
integer y = 604
integer width = 4366
integer height = 1988
boolean titlebar = true
string title = "Product Sale Plan List"
string dataobject = "d_sal_product_sale_plan_4_order_plan_lst_tree"
end type

event dw_3::rbuttondown;call super::rbuttondown;string lvs_item_code

if dw_3.getrow() < 1 then return

lvs_item_code = dw_3.getitemstring( dw_3.getrow() , 'item_code' )
if lvs_item_code = '' or isnull(lvs_item_code) then return

openwithparm( w_des_bom_query_popup , lvs_item_code )
end event

type dw_2 from w_main_root`dw_2 within w_mat_purchase_order_plan_master
integer y = 604
integer width = 4366
integer height = 1988
boolean titlebar = true
string title = "Order Plan Matrix"
string dataobject = "d_mat_purchase_order_plan_matrix_rpt"
end type

type dw_1 from w_main_root`dw_1 within w_mat_purchase_order_plan_master
integer y = 604
integer width = 4366
integer height = 1988
boolean titlebar = true
string title = "Purchase Order Plan List"
string dataobject = "d_mat_order_plan_lst_tree"
end type

event dw_1::rbuttondown;call super::rbuttondown;STRING LVS_ITEM_CODE
IF DWO.NAME = 'item_code' THEN 
	LVS_ITEM_CODE = STRING(THIS.OBJECT.ITEM_CODE[ROW])
	OPENWITHPARM( W_MAT_ITEM_CHECK_POPUP ,LVS_ITEM_CODE  )
END IF
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_purchase_order_plan_master
end type

type st_5 from so_statictext within w_mat_purchase_order_plan_master
integer x = 2962
integer y = 80
integer width = 475
integer height = 64
boolean bringtotop = true
boolean enabled = false
string text = "Item Code"
end type

type uo_item from uo_item_code within w_mat_purchase_order_plan_master
integer x = 2962
integer y = 156
integer width = 475
integer height = 2156
integer taborder = 160
boolean bringtotop = true
end type

on uo_item.destroy
call uo_item_code::destroy
end on

type st_3 from so_statictext within w_mat_purchase_order_plan_master
integer x = 1682
integer y = 80
integer width = 448
integer height = 64
boolean bringtotop = true
boolean enabled = false
string text = "Supplier Code"
end type

type ddlb_supplier_code from uo_supplier_code within w_mat_purchase_order_plan_master
integer x = 1678
integer y = 156
integer width = 448
integer height = 2156
integer taborder = 90
boolean bringtotop = true
end type

event rbuttondown;call super::rbuttondown;THIS.TRIGGEREVENT(SELECTIONCHANGED!)
end event

type rb_order_plan_list from so_radiobutton within w_mat_purchase_order_plan_master
integer x = 32
integer y = 72
integer width = 590
integer height = 64
boolean bringtotop = true
long textcolor = 0
string text = "Order Plan List"
boolean checked = true
end type

event clicked;DW_1.BRINGTOTOP = TRUE
SELECTED_DATA_WINDOW = DW_1

IF rb_order_plan_list.CHECKED = TRUE THEN
	f_menu_control('DATA_CONTROL_DELETE' , TRUE)  // $$HEX6$$adc01cc8ccb9200000aca5b2$$ENDHEX$$
ELSEIF rb_manual_plan.checked = TRUE then 
	f_menu_control('DATA_CONTROL' , TRUE) 
ELSE
	f_menu_control('DATA_CONTROL' , FALSE) 
END IF
end event

type rb_order_plan_matrix from so_radiobutton within w_mat_purchase_order_plan_master
integer x = 32
integer y = 184
integer width = 590
integer height = 64
boolean bringtotop = true
long textcolor = 0
string text = "Order Plan Matrix"
end type

event clicked;DW_2.BRINGTOTOP = TRUE
SELECTED_DATA_WINDOW = DW_2

IF rb_order_plan_list.CHECKED = TRUE THEN
	f_menu_control('DATA_CONTROL_DELETE' , TRUE)  // $$HEX6$$adc01cc8ccb9200000aca5b2$$ENDHEX$$
ELSEIF rb_manual_plan.checked = TRUE then 
	f_menu_control('DATA_CONTROL' , TRUE) 
ELSE
	f_menu_control('DATA_CONTROL' , FALSE) 
END IF
end event

type tab_1 from tab within w_mat_purchase_order_plan_master
event create ( )
event destroy ( )
integer x = 14
integer y = 316
integer width = 4352
integer height = 280
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean fixedwidth = true
boolean raggedright = true
boolean focusonbuttondown = true
boolean powertips = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_4 tabpage_4
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_4=create tabpage_4
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_4}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_4)
end on

type tabpage_1 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 4315
integer height = 152
long backcolor = 15780518
string text = "Process"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Regenerate5!"
long picturemaskcolor = 536870912
rb_from_manual_plan rb_from_manual_plan
cb_purchase_do cb_purchase_do
st_1 st_1
uo_po_date uo_po_date
cb_gen_do cb_gen_do
rb_from_sale_plan rb_from_sale_plan
rb_from_master_plan rb_from_master_plan
cb_price_reset cb_price_reset
cb_1 cb_1
cb_purchase_po cb_purchase_po
cb_gen_po cb_gen_po
end type

on tabpage_1.create
this.rb_from_manual_plan=create rb_from_manual_plan
this.cb_purchase_do=create cb_purchase_do
this.st_1=create st_1
this.uo_po_date=create uo_po_date
this.cb_gen_do=create cb_gen_do
this.rb_from_sale_plan=create rb_from_sale_plan
this.rb_from_master_plan=create rb_from_master_plan
this.cb_price_reset=create cb_price_reset
this.cb_1=create cb_1
this.cb_purchase_po=create cb_purchase_po
this.cb_gen_po=create cb_gen_po
this.Control[]={this.rb_from_manual_plan,&
this.cb_purchase_do,&
this.st_1,&
this.uo_po_date,&
this.cb_gen_do,&
this.rb_from_sale_plan,&
this.rb_from_master_plan,&
this.cb_price_reset,&
this.cb_1,&
this.cb_purchase_po,&
this.cb_gen_po}
end on

on tabpage_1.destroy
destroy(this.rb_from_manual_plan)
destroy(this.cb_purchase_do)
destroy(this.st_1)
destroy(this.uo_po_date)
destroy(this.cb_gen_do)
destroy(this.rb_from_sale_plan)
destroy(this.rb_from_master_plan)
destroy(this.cb_price_reset)
destroy(this.cb_1)
destroy(this.cb_purchase_po)
destroy(this.cb_gen_po)
end on

type rb_from_manual_plan from so_radiobutton within tabpage_1
integer x = 2203
integer y = 60
integer width = 462
integer height = 64
boolean bringtotop = true
long backcolor = 15780518
string text = "Manual Plan"
end type

type cb_purchase_do from so_commandbutton within tabpage_1
integer x = 3442
integer y = 20
integer width = 393
integer height = 112
integer taborder = 90
boolean bringtotop = true
boolean enabled = false
string text = "Purchase All DO"
end type

event clicked;Long I , J 
DATETIME LVD_DATESET , LVD_DATEEND 
STRING LVS_ORDER_GROUP_NO , lvs_rowid

if dw_1.getrow( ) < 1 then 
	
	Messagebox("Notify" , "Retrieve order plan data first and Check item for order")
	return 
	
end if 

MSG = F_MSGBOX1( 1161 , THIS.TEXT ) //@ $$HEX7$$7cb9200098ccacb960d54cae94c6$$ENDHEX$$?
IF MSG = 1 THEN 
ELSE
	RETURN 
END IF

LVS_ORDER_GROUP_NO =  string(f_t_sysdate(),'yyyymmdd') + string( f_get_sequence( 'SEQ_PURCHASE_ORDER_NO'),'000')

do
	
	i++
	
	if dw_1.object.check_yn[i] = 'Y' then 
		
	    lvs_rowid = dw_1.object.rowid[i]	
		
	else
		continue
	end if
     
//==========================================
// $$HEX11$$f1b409ae2000c6c574c7200004c8b4cc20001cbcfcc8$$ENDHEX$$
//==========================================
  INSERT INTO "IM_ITEM_PURCHASE_ORDER"  
         ( "ORDER_NO",  "ORDER_GROUP_NO",
           "ORGANIZATION_ID",   
           "PURCHASE_ORDER_DATE",   
           "SUPPLIER_CODE",   
           "ITEM_CODE",   
           "DELIVERY_DATE",   
           "DELIVERY",   
           "LINE_TYPE",   
           "ORDER_TYPE",   
           "ORDER_QTY",   
           "UNIT_PRICE",   
           "CURRENCY",   
           "ARRIVAL_QTY",   
           "MFS",   
           "ENTER_BY",   
           "ENTER_DATE",   
           "LAST_MODIFY_BY",   
           "LAST_MODIFY_DATE")  
SELECT "ORDER_NO",  
            :LVS_ORDER_GROUP_NO ,
           "ORGANIZATION_ID",   
            TRUNC(SYSDATE) PURCHASE_ORDER_DATE,   
           "SUPPLIER_CODE",   
           "ITEM_CODE",   
           "DELIVERY_DATE",   
           "DELIVERY",   
           "LINE_TYPE",   
           "ORDER_TYPE",   
           "PURCHASE_ORDER_QTY",   
           "UNIT_PRICE",   
           "CURRENCY",   
           "ARRIVAL_QTY",   
           "MFS",   
           :GVS_USER_ID ,   
           SYSDATE,   
           :GVS_USER_ID,   
           SYSDATE
 FROM  IM_ITEM_PURCHASE_ORDER_PLAN 
WHERE ROWID = :LVS_ROWID;
  
	IF F_SQL_CHECK() < 0 THEN 
		 RETURN
	END IF
	
 UPDATE IM_ITEM_PURCHASE_ORDER_PLAN SET PURCHASE_ORDER_STATUS = 'Y'
 WHERE ROWID = :LVS_ROWID ;
 
 	IF F_SQL_CHECK() < 0 THEN 
		 RETURN
	END IF
	
J++
//=============================================
	
Loop until i = dw_1.rowcount( )

//=============================================

IF J  > 0 THEN 

	F_MSG_ST1(129 ,STRING(J)) //@$$HEX14$$89d558c7200098ccacb900ac200031c1f5ac58d500c6b5c2c8b2e4b2$$ENDHEX$$.
	F_MSGBOX(9088) //$$HEX14$$fcc838bb98ccacb900ac200044c6ccb8200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$
	COMMIT ;

ELSE
	
	ROLLBACK;
	F_MSGBOX(9026) //$$HEX12$$c0bcbdac1cb4200090c7ccb800ac2000c6c5b5c2c8b2e4b2$$ENDHEX$$

END IF	
end event

type st_1 from statictext within tabpage_1
integer x = 41
integer y = 4
integer width = 411
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 15780518
string text = "PO Date"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_po_date from uo_ymd_calendar within tabpage_1
event destroy ( )
integer x = 32
integer y = 64
integer taborder = 140
boolean bringtotop = true
end type

on uo_po_date.destroy
call uo_ymd_calendar::destroy
end on

type cb_gen_do from so_commandbutton within tabpage_1
integer x = 878
integer y = 24
integer width = 402
integer height = 112
integer taborder = 80
boolean bringtotop = true
boolean enabled = false
string text = "Generate DO"
end type

event clicked;IF F_OBJECT_ROLE_CHECK() = FALSE THEN  RETURN
//==========================================================
// 
//
//==========================================================

STRING  LVS_SUPPLIER_CODE , LVS_SET_ITEM_CODE,  LVS_ITEM_CODE ,LVS_LINE_TYPE ,  LVS_ROWID , LVS_ORDER_ROWID , LVS_ARRIVAL_ROWID , LVS_INV_ROWID 
LONG I , J , LVL_COUNT , LVI_RETURN
DECIMAL LVF_ORDER_PLAN_QTY , LVF_ORDER_QTY , LVF_INV_QTY  , LVF_PURCHASE_ORDER_CALC_QTY
DATETIME LVD_DATESET , LVD_DATEEND , LVD_PO_DATE
STRING LVS_NOT_FOUND

LVS_SET_ITEM_CODE = uo_item.text 
if LVS_SET_ITEM_CODE = '' or isnull(LVS_SET_ITEM_CODE) then
	LVS_SET_ITEM_CODE = '%'
end if 


LVD_DATESET  = uo_generate_dateset.text()
LVD_DATEEND  = uo_generate_dateend.text()
LVD_PO_DATE = uo_po_date.text()

//=================================================
// $$HEX8$$fcc838bb08c615c815c8f4bce4ce1cc1$$ENDHEX$$
//=================================================
DECLARE CL_PLAN CURSOR FOR 
  SELECT SUPPLIER_CODE , ITEM_CODE , LINE_TYPE , ORDER_QTY ,  ROWID 
    FROM IM_ITEM_PURCHASE_ORDER_PLAN 
  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 	 
  ORDER BY ITEM_CODE ,LINE_TYPE , DELIVERY_DATE , ORGANIZATION_ID ; 

//=================================================
// $$HEX6$$fcc838bb15c8f4bce4ce1cc1$$ENDHEX$$
// $$HEX3$$f8bbacc0a9c6$$ENDHEX$$
//=================================================
DECLARE CL_ORDER CURSOR FOR 
    SELECT ITEM_CODE ,LINE_TYPE ,   ORDER_QTY , ROWID
      FROM IM_ITEM_PURCHASE_ORDER_GEN
   WHERE ITEM_CODE = :LVS_ITEM_CODE
        AND LINE_TYPE = :LVS_LINE_TYPE
	   AND ORDER_QTY > 0
	   AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID	
  ORDER BY ITEM_CODE ,LINE_TYPE ,  ORGANIZATION_ID ;
		
//=================================================
// $$HEX8$$c4b329cc15c8f4bc2000e4ce1cc12000$$ENDHEX$$
// $$HEX3$$f8bbacc0a9c6$$ENDHEX$$
//=================================================
DECLARE CL_ARRIVAL CURSOR FOR 
  SELECT ITEM_CODE , LINE_TYPE , ARRIVAL_QTY  , ROWID 
    FROM IM_ITEM_ARRIVAL_GEN 
  WHERE ITEM_CODE = :LVS_ITEM_CODE
       AND LINE_TYPE = :LVS_LINE_TYPE  
       AND ARRIVAL_QTY > 0 
       AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID 	
  ORDER BY ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ;
  
//=================================================
// $$HEX7$$acc7e0ac15c8f4bc2000e4ce1cc1$$ENDHEX$$
//=================================================
DECLARE CL_INV CURSOR FOR 
  SELECT NVL(INVENTORY_QTY,0)  ,  ROWID 
    FROM IM_ITEM_INVENTORY_GEN 
  WHERE ITEM_CODE = :LVS_ITEM_CODE
       AND LINE_TYPE  = :LVS_LINE_TYPE
       AND NVL(INVENTORY_QTY,0) > 0 
       AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID 	
  ORDER BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID ;  
    
//=================================================
// $$HEX10$$fcc838bb94c7c9b7200069d5c4ac2000ddc031c1$$ENDHEX$$
//=================================================
  DELETE FROM IM_ITEM_PURCHASE_ORDER_GEN 
   WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID  ;
  IF F_SQL_CHECK_WITH_MSG(' PURCHASE ORDER GEN DELETE') < 0 THEN 
	 RETURN
  END IF		
	
  INSERT INTO IM_ITEM_PURCHASE_ORDER_GEN 
                    ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,DELIVERY_DATE ,  ORDER_QTY )
          SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , DELIVERY_DATE ,  SUM(ORDER_QTY - NVL(ARRIVAL_QTY,0) )
			FROM IM_ITEM_PURCHASE_ORDER
           WHERE  ORDER_QTY - NVL(ARRIVAL_QTY,0) > 0 
			   AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
	       GROUP BY ITEM_CODE ,LINE_TYPE , DELIVERY_DATE , ORGANIZATION_ID ;
			  
  IF F_SQL_CHECK_WITH_MSG(' PURCHASE ORDER GEN ') < 0 THEN
	 RETURN
  END IF			  
			  
  //================================================
  // $$HEX9$$c4b329cc94c7c9b769d5c4ac2000ddc031c1$$ENDHEX$$
  //================================================

  DELETE FROM IM_ITEM_ARRIVAL_GEN 
   WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID  ;
  IF F_SQL_CHECK_WITH_MSG('ARRIVAL GEN DELETE ') < 0 THEN 
	 RETURN
  END IF		
  
  INSERT INTO IM_ITEM_ARRIVAL_GEN
                    ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  ARRIVAL_QTY )
          SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  SUM(ARRIVAL_QTY)
			FROM IM_ITEM_ARRIVAL
           WHERE ARRIVAL_TYPE  = 'A'  //$$HEX4$$c4b329ccc1c0dcd0$$ENDHEX$$
			  AND ARRIVAL_STATUS = 'N'
			  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
	       GROUP BY ITEM_CODE ,LINE_TYPE  , ORGANIZATION_ID ;
			  
  IF F_SQL_CHECK_WITH_MSG('ARRIVAL GEN ') < 0 THEN 
	 RETURN
  END IF
    
  //================================================
  //$$HEX9$$acc7e0ac18c2c9b769d5c4ac2000ddc031c1$$ENDHEX$$
  //================================================
 DELETE FROM IM_ITEM_INVENTORY_GEN
  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID  ;
  
  IF F_SQL_CHECK_WITH_MSG('INVENTORY GEN DELETE ') < 0 THEN 
	 RETURN
  END IF		

IF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = True and tab_1.tabpage_2.cbx_apply_order_qty.checked = True and &
     tab_1.tabpage_2.cbx_apply_inventory_qty.checked = True and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = True and tab_1.tabpage_2.cbx_outside_inv.checked = TRUE THEN //$$HEX13$$04c880bd200010ac48c520002000acc7e0ac5cb8200020002000$$ENDHEX$$

		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
		
					 SELECT 	 ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY)	 , 0 			  
					 FROM  (
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  SUM(INVENTORY_QTY) QTY
								FROM IM_ITEM_INVENTORY
							  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
							 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID
							 
							  UNION ALL
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(ORDER_QTY) QTY 
							    FROM IM_ITEM_PURCHASE_ORDER_GEN
							  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	 
			                                GROUP BY 	 ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 						  
							 
							  UNION ALL
						
								SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  ARRIVAL_QTY  QTY
								  FROM IM_ITEM_ARRIVAL_GEN
								 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
								 
							  UNION ALL
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(INVENTORY_QTY) QTY
							    FROM IM_ITEM_WORKSTAGE_INVENTORY
							 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	
							      AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_DIVISION IN ( 'R' ,'S') AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
							   GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 
							
							 UNION ALL
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(INVENTORY_QTY) QTY
							    FROM IM_ITEM_FREE_INVENTORY
							 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	
							      AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_DIVISION IN ( 'R' ,'S') AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
							   GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 
								 
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID  ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF 
	
ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = True and tab_1.tabpage_2.cbx_apply_order_qty.checked = True and &
	     tab_1.tabpage_2.cbx_apply_inventory_qty.checked = True and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = false and tab_1.tabpage_2.cbx_outside_inv.checked = TRUE THEN //$$HEX19$$fcc838bb2000c4b329cc20003dcce0ac200010ac48c52000acc7e0ac5cb82000200020000900$$ENDHEX$$

		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
		
					 SELECT 	 ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY)	 , 0 			  
					 FROM  (
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  SUM(INVENTORY_QTY) QTY
								FROM IM_ITEM_INVENTORY
							  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
							 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID
							 
							  UNION ALL
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(ORDER_QTY) QTY 
							    FROM IM_ITEM_PURCHASE_ORDER_GEN
							  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	 
			                                GROUP BY 	 ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 						  
							 
							  UNION ALL
						
								SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  ARRIVAL_QTY  QTY
								  FROM IM_ITEM_ARRIVAL_GEN
								 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
								 
							 UNION ALL
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(INVENTORY_QTY) QTY
							    FROM IM_ITEM_FREE_INVENTORY
							 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	
							      AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_DIVISION IN ( 'R' ,'S') AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
							   GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID  ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  		 
  
ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = True and tab_1.tabpage_2.cbx_apply_order_qty.checked = True and & 
	     tab_1.tabpage_2.cbx_apply_inventory_qty.checked = false and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = false and tab_1.tabpage_2.cbx_outside_inv.checked = TRUE THEN //$$HEX19$$c4b329cc58d5e0ac2000fcc838bb44c7200010ac48c52000acc7e0ac5cb82000200020000900$$ENDHEX$$

		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
		
					 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY)	 , 0 			  
					 FROM  (

							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(ORDER_QTY) QTY 
							    FROM IM_ITEM_PURCHASE_ORDER_GEN
							  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	 
			                                GROUP BY 	 ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 						  
							 
							  UNION ALL
						
								SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  ARRIVAL_QTY  QTY
								  FROM IM_ITEM_ARRIVAL_GEN
								 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
								 
							 UNION ALL
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(INVENTORY_QTY) QTY
							    FROM IM_ITEM_FREE_INVENTORY
							 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	
							      AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_DIVISION IN ( 'R' ,'S') AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
							   GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 
								 							 
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID  ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  

ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = True and tab_1.tabpage_2.cbx_apply_order_qty.checked = false and &
	      tab_1.tabpage_2.cbx_apply_inventory_qty.checked = false and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = false and tab_1.tabpage_2.cbx_outside_inv.checked = TRUE THEN //$$HEX14$$c4b329ccccb9200010ac48c52000acc7e0ac5cb82000200020000900$$ENDHEX$$

		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
					 SELECT 	 ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY)	 , 0 		  
					 FROM  (
					
								SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  ARRIVAL_QTY  QTY
								  FROM IM_ITEM_ARRIVAL_GEN
								 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
								 
							UNION ALL
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(INVENTORY_QTY) QTY
							    FROM IM_ITEM_FREE_INVENTORY
							 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	
							      AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_DIVISION IN ( 'R' ,'S') AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
							   GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  		
ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = false and tab_1.tabpage_2.cbx_apply_order_qty.checked = true and &
	      tab_1.tabpage_2.cbx_apply_inventory_qty.checked = true and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = false and tab_1.tabpage_2.cbx_outside_inv.checked = TRUE THEN // $$HEX11$$fcc838bb15c8f4bc40c620003dcce0acacc7e0ac2000$$ENDHEX$$

		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
		
					 SELECT 	 ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY) , 0		  
					 FROM  (
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  SUM(INVENTORY_QTY) QTY
								FROM IM_ITEM_INVENTORY
							  WHERE  ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
							 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID
							 
							  UNION ALL
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(ORDER_QTY) QTY
							    FROM IM_ITEM_PURCHASE_ORDER_GEN
							  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	 
							   GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 
								
							UNION ALL
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(INVENTORY_QTY) QTY
							    FROM IM_ITEM_FREE_INVENTORY
							 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	
							      AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_DIVISION IN ( 'R' ,'S') AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
							   GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 
								
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  		
		
ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = true and tab_1.tabpage_2.cbx_apply_order_qty.checked = false and & 
	      tab_1.tabpage_2.cbx_apply_inventory_qty.checked = true and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = false and tab_1.tabpage_2.cbx_outside_inv.checked = TRUE THEN //$$HEX18$$c4b329cc58d5e0ac20003dcce0ac18c2c9b7ccb92000acc7e0ac5cb8200078c715c82000$$ENDHEX$$
		  

		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
		
					 SELECT 	 ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY)	 , 0 			  
					 FROM  (
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  SUM(INVENTORY_QTY) QTY
								FROM IM_ITEM_INVENTORY
							  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
							 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID
							 
							  UNION ALL
						
								SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  ARRIVAL_QTY  QTY
								  FROM IM_ITEM_ARRIVAL_GEN
								 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
								 
							 UNION ALL
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(INVENTORY_QTY) QTY
							    FROM IM_ITEM_FREE_INVENTORY
							 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	
							      AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_DIVISION IN ( 'R' ,'S') AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
							   GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 
								 
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID  ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  		  
				  
ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED =  true and tab_1.tabpage_2.cbx_apply_order_qty.checked = false and & 
	      tab_1.tabpage_2.cbx_apply_inventory_qty.checked = true and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = true and tab_1.tabpage_2.cbx_outside_inv.checked = TRUE THEN //$$HEX21$$c4b329cc58d5e0ac20003dcce0ac2000f5ac15c818c2c9b7ccb92000acc7e0ac5cb8200078c715c82000$$ENDHEX$$


		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
		
					 SELECT 	 ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY)	 , 0 			  
					 FROM  (
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  SUM(INVENTORY_QTY) QTY
								FROM IM_ITEM_INVENTORY
							  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
							 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID
							 
							  UNION ALL
						
								SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  ARRIVAL_QTY  QTY
								  FROM IM_ITEM_ARRIVAL_GEN
								 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
								 
							  UNION ALL
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(INVENTORY_QTY) QTY
							    FROM IM_ITEM_WORKSTAGE_INVENTORY
							 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	
							      AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_DIVISION IN ( 'R' ,'S') AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
							   GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 	
								
							UNION ALL
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(INVENTORY_QTY) QTY
							    FROM IM_ITEM_FREE_INVENTORY
							 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	
							      AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_DIVISION IN ( 'R' ,'S') AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
							   GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID  ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  		  				  


ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = false and tab_1.tabpage_2.cbx_apply_order_qty.checked = false and & 
	     tab_1.tabpage_2.cbx_apply_inventory_qty.checked = true and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = true and tab_1.tabpage_2.cbx_outside_inv.checked = TRUE THEN //$$HEX16$$3dcce0ac58d5e0ac2000f5ac15c8ccb92000acc7e0ac5cb8200078c715c82000$$ENDHEX$$

		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
		
					 SELECT 	 ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY) , 0		  
					 FROM  (
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  SUM(INVENTORY_QTY) QTY
								FROM IM_ITEM_INVENTORY
							  WHERE  ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
							 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID
							 
							  UNION ALL
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(INVENTORY_QTY) QTY
							    FROM IM_ITEM_WORKSTAGE_INVENTORY
							 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	
							      AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_DIVISION IN ( 'R' ,'S') AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
							   GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 
								
								UNION ALL
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(INVENTORY_QTY) QTY
							    FROM IM_ITEM_FREE_INVENTORY
							 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	
							      AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_DIVISION IN ( 'R' ,'S') AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
							   GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 
								
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  		

ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = false and tab_1.tabpage_2.cbx_apply_order_qty.checked = false and & 
	     tab_1.tabpage_2.cbx_apply_inventory_qty.checked = false and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = true and tab_1.tabpage_2.cbx_outside_inv.checked = TRUE THEN  // $$HEX11$$f5ac15c8ccb92000acc7e0ac5cb8200078c715c82000$$ENDHEX$$

		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
		
					 SELECT 	 ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY) , 0		  
					 FROM  (
						
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(INVENTORY_QTY) QTY
							    FROM IM_ITEM_WORKSTAGE_INVENTORY
							 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	
							      AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_DIVISION IN ( 'R' ,'S') AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
							   GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 
								
								UNION ALL
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(INVENTORY_QTY) QTY
							    FROM IM_ITEM_FREE_INVENTORY
							 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	
							      AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_DIVISION IN ( 'R' ,'S') AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
							   GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 
								
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  		


ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = false and tab_1.tabpage_2.cbx_apply_order_qty.checked = false and &
	     tab_1.tabpage_2.cbx_apply_inventory_qty.checked = true and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = false and tab_1.tabpage_2.cbx_outside_inv.checked = TRUE THEN //$$HEX10$$3dcce0acccb9acc7e0ac5cb8200078c715c82000$$ENDHEX$$

		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
		
					 SELECT 	 ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY) , 0		  
					 FROM  (
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  SUM(INVENTORY_QTY) QTY
								FROM IM_ITEM_INVENTORY
							  WHERE  ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
							 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID
								
								UNION ALL
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(INVENTORY_QTY) QTY
							    FROM IM_ITEM_FREE_INVENTORY
							 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	
							      AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_DIVISION IN ( 'R' ,'S') AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
							   GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 
								
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID ;
				  
				  
				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  

//===================================================  
ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = True and tab_1.tabpage_2.cbx_apply_order_qty.checked = True and &
     tab_1.tabpage_2.cbx_apply_inventory_qty.checked = True and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = True and tab_1.tabpage_2.cbx_outside_inv.checked = false THEN //$$HEX13$$04c880bd200010ac48c520002000acc7e0ac5cb8200020002000$$ENDHEX$$

		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
		
					 SELECT 	 ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY)	 , 0 			  
					 FROM  (
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  SUM(INVENTORY_QTY) QTY
								FROM IM_ITEM_INVENTORY
							  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
							 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID
							 
							  UNION ALL
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(ORDER_QTY) QTY 
							    FROM IM_ITEM_PURCHASE_ORDER_GEN
							  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	 
			                                GROUP BY 	 ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 						  
							 
							  UNION ALL
						
								SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  ARRIVAL_QTY  QTY
								  FROM IM_ITEM_ARRIVAL_GEN
								 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
								 
							  UNION ALL
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(INVENTORY_QTY) QTY
							    FROM IM_ITEM_WORKSTAGE_INVENTORY
							 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	
							      AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_DIVISION IN ( 'R' ,'S') AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
							   GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 
																 
								 
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID  ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF 
	
ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = True and tab_1.tabpage_2.cbx_apply_order_qty.checked = True and &
	     tab_1.tabpage_2.cbx_apply_inventory_qty.checked = True and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = false and tab_1.tabpage_2.cbx_outside_inv.checked = false THEN //$$HEX19$$fcc838bb2000c4b329cc20003dcce0ac200010ac48c52000acc7e0ac5cb82000200020000900$$ENDHEX$$

		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
		
					 SELECT 	 ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY)	 , 0 			  
					 FROM  (
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  SUM(INVENTORY_QTY) QTY
								FROM IM_ITEM_INVENTORY
							  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
							 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID
							 
							  UNION ALL
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(ORDER_QTY) QTY 
							    FROM IM_ITEM_PURCHASE_ORDER_GEN
							  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	 
			                                GROUP BY 	 ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 						  
							 
							  UNION ALL
						
								SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  ARRIVAL_QTY  QTY
								  FROM IM_ITEM_ARRIVAL_GEN
								 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID  ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  		 
  
ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = True and tab_1.tabpage_2.cbx_apply_order_qty.checked = True and & 
	     tab_1.tabpage_2.cbx_apply_inventory_qty.checked = false and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = false and tab_1.tabpage_2.cbx_outside_inv.checked = false THEN //$$HEX19$$c4b329cc58d5e0ac2000fcc838bb44c7200010ac48c52000acc7e0ac5cb82000200020000900$$ENDHEX$$

		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
		
					 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY)	 , 0 			  
					 FROM  (

							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(ORDER_QTY) QTY 
							    FROM IM_ITEM_PURCHASE_ORDER_GEN
							  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	 
			                                GROUP BY 	 ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 						  
							 
							  UNION ALL
						
								SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  ARRIVAL_QTY  QTY
								  FROM IM_ITEM_ARRIVAL_GEN
								 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
								 							 
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID  ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  

ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = True and tab_1.tabpage_2.cbx_apply_order_qty.checked = false and &
	      tab_1.tabpage_2.cbx_apply_inventory_qty.checked = false and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = false and tab_1.tabpage_2.cbx_outside_inv.checked = false THEN //$$HEX14$$c4b329ccccb9200010ac48c52000acc7e0ac5cb82000200020000900$$ENDHEX$$

		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
					 SELECT 	 ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY)	 , 0 		  
					 FROM  (
					
								SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  ARRIVAL_QTY  QTY
								  FROM IM_ITEM_ARRIVAL_GEN
								 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  		
ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = false and tab_1.tabpage_2.cbx_apply_order_qty.checked = true and &
	      tab_1.tabpage_2.cbx_apply_inventory_qty.checked = true and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = false and tab_1.tabpage_2.cbx_outside_inv.checked = false THEN // $$HEX11$$fcc838bb15c8f4bc40c620003dcce0acacc7e0ac2000$$ENDHEX$$

		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
		
					 SELECT 	 ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY) , 0		  
					 FROM  (
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  SUM(INVENTORY_QTY) QTY
								FROM IM_ITEM_INVENTORY
							  WHERE  ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
							 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID
							 
							  UNION ALL
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(ORDER_QTY) QTY
							    FROM IM_ITEM_PURCHASE_ORDER_GEN
							  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	 
							   GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 
								
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  		
		
ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = true and tab_1.tabpage_2.cbx_apply_order_qty.checked = false and & 
	      tab_1.tabpage_2.cbx_apply_inventory_qty.checked = true and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = false and tab_1.tabpage_2.cbx_outside_inv.checked = false THEN //$$HEX18$$c4b329cc58d5e0ac20003dcce0ac18c2c9b7ccb92000acc7e0ac5cb8200078c715c82000$$ENDHEX$$
		  

		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
		
					 SELECT 	 ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY)	 , 0 			  
					 FROM  (
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  SUM(INVENTORY_QTY) QTY
								FROM IM_ITEM_INVENTORY
							  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
							 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID
							 
							  UNION ALL
						
								SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  ARRIVAL_QTY  QTY
								  FROM IM_ITEM_ARRIVAL_GEN
								 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
								 
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID  ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  		  
				  
ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED =  true and tab_1.tabpage_2.cbx_apply_order_qty.checked = false and & 
	      tab_1.tabpage_2.cbx_apply_inventory_qty.checked = true and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = true and tab_1.tabpage_2.cbx_outside_inv.checked = false THEN //$$HEX21$$c4b329cc58d5e0ac20003dcce0ac2000f5ac15c818c2c9b7ccb92000acc7e0ac5cb8200078c715c82000$$ENDHEX$$


		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
		
					 SELECT 	 ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY)	 , 0 			  
					 FROM  (
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  SUM(INVENTORY_QTY) QTY
								FROM IM_ITEM_INVENTORY
							  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
							 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID
							 
							  UNION ALL
						
								SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  ARRIVAL_QTY  QTY
								  FROM IM_ITEM_ARRIVAL_GEN
								 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
								 
							  UNION ALL
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(INVENTORY_QTY) QTY
							    FROM IM_ITEM_WORKSTAGE_INVENTORY
							 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	
							      AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_DIVISION IN ( 'R' ,'S') AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
							   GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 								 
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID  ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  		  				  


ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = false and tab_1.tabpage_2.cbx_apply_order_qty.checked = false and & 
	     tab_1.tabpage_2.cbx_apply_inventory_qty.checked = true and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = true and tab_1.tabpage_2.cbx_outside_inv.checked = false THEN //$$HEX16$$3dcce0ac58d5e0ac2000f5ac15c8ccb92000acc7e0ac5cb8200078c715c82000$$ENDHEX$$

		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
		
					 SELECT 	 ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY) , 0		  
					 FROM  (
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  SUM(INVENTORY_QTY) QTY
								FROM IM_ITEM_INVENTORY
							  WHERE  ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
							 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID
							 
							  UNION ALL
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(INVENTORY_QTY) QTY
							    FROM IM_ITEM_WORKSTAGE_INVENTORY
							 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	
							      AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_DIVISION IN ( 'R' ,'S') AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
							   GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 
								
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  		

ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = false and tab_1.tabpage_2.cbx_apply_order_qty.checked = false and & 
	     tab_1.tabpage_2.cbx_apply_inventory_qty.checked = false and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = true and tab_1.tabpage_2.cbx_outside_inv.checked = false THEN  // $$HEX11$$f5ac15c8ccb92000acc7e0ac5cb8200078c715c82000$$ENDHEX$$

		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
		
					 SELECT 	 ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY) , 0		  
					 FROM  (
						
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(INVENTORY_QTY) QTY
							    FROM IM_ITEM_WORKSTAGE_INVENTORY
							 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	
							      AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_DIVISION IN ( 'R' ,'S') AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
							   GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 
								
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  		


ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = false and tab_1.tabpage_2.cbx_apply_order_qty.checked = false and &
	     tab_1.tabpage_2.cbx_apply_inventory_qty.checked = true and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = false and tab_1.tabpage_2.cbx_outside_inv.checked = false THEN //$$HEX10$$3dcce0acccb9acc7e0ac5cb8200078c715c82000$$ENDHEX$$

		  INSERT INTO IM_ITEM_INVENTORY_GEN 
						  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
			 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  SUM(INVENTORY_QTY) QTY , 0
			   FROM IM_ITEM_INVENTORY
	   	     WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
			  GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID ;
				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  
			else 
				Messagebox("Notify" , "Option Invalid !")
				  
END IF

	
 //=======================================
 // $$HEX18$$01c6c5c5fcc838bb3cc75cb82000200080bd30d12000fcc838bb08c615c82000ddc031c1$$ENDHEX$$
 //=======================================
  
IF tab_1.tabpage_1.RB_FROM_SALE_PLAN.CHECKED = TRUE THEN
	
		if Gvs_sale_division = 'SAMSUNG' then 
			
	      // $$HEX10$$10d3e4b9c4ac8dd6d0c5200000b358d5ecc52000$$ENDHEX$$BOM $$HEX15$$04c81cac20000fbc200084c7dcc220004cd174c714bed0c5200085c725b8$$ENDHEX$$
		 LVI_RETURN = F_GEN_PURCHASE_ORDER_PLAN_BY_SALE_PLAN_BY_TIME( LVD_DATESET , LVD_DATEEND , LVS_SET_ITEM_CODE ) ;
		 IF LVI_RETURN <= 0 THEN 
			MESSAGEBOX("Error" , " Can`t  BOM Explosion" )
			ROLLBACK ; 
			RETURN 
		 END IF
	ELSE
		
	      // $$HEX10$$10d3e4b9c4ac8dd6d0c5200000b358d5ecc52000$$ENDHEX$$BOM $$HEX15$$04c81cac20000fbc200084c7dcc220004cd174c714bed0c5200085c725b8$$ENDHEX$$
		 LVI_RETURN = F_GEN_PURCHASE_ORDER_PLAN_BY_SALE_PLAN( LVD_DATESET , LVD_DATEEND ) ;
		 IF LVI_RETURN <= 0 THEN 
			MESSAGEBOX("Error" , " Can`t  BOM Explosion" )
			ROLLBACK ; 
			RETURN 
		 END IF		
	END IF 
	 
     	  DELETE FROM IM_ITEM_PURCHASE_ORDER_PLAN WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID  ;
		  
		  IF F_SQL_CHECK() < 0 THEN 
			 RETURN
		  END IF

		  INSERT INTO IM_ITEM_PURCHASE_ORDER_PLAN  
						( ORDER_NO,    PURCHASE_ORDER_DATE,    ORGANIZATION_ID,    SUPPLIER_CODE,   
						  ITEM_CODE,   DELIVERY_DATE,   DELIVERY,   LINE_TYPE,   ORDER_TYPE,   
						  ORDER_QTY,   PURCHASE_ORDER_QTY ,  UNIT_PRICE,    CURRENCY,   
						  INVENTORY_QTY,    ARRIVAL_QTY,    PRE_ORDER_QTY,   
						  MFS,   PURCHASE_ORDER_STATUS ,
						  PAYMENT_TYPE ,
						  ENTER_BY,    ENTER_DATE,    LAST_MODIFY_BY,   LAST_MODIFY_DATE,
						  SET_ITEM_CODE , PARENT_ITEM_CODE ) 
		
				SELECT   TO_CHAR(A.ORGANIZATION_ID)||TO_CHAR(SYSDATE,'YYMMDD')||ROWNUM ,
						:LVD_PO_DATE       PURCHASE_ORDER_DATE ,
						A.ORGANIZATION_ID ,  
						NVL(B.SUPPLIER_CODE ,'*' )  SUPPLIER_CODE , // F_GET_MAX_VENDOR_BY_ITEM( A.ITEM_CODE , A.ORGANIZATION_ID ) SUPPLIER_CODE,   
						A.ITEM_CODE , 
						A.DELIVERY_DATE , 
						'1' DELIVERY , 
						A.LINE_TYPE ,
						'O'                               ORDER_TYPE,   //$$HEX4$$c1c9a9b085c72000$$ENDHEX$$
						DECODE( B.ORDER_RATE , NULL ,A.ORDER_QTY ,  ( A.ORDER_QTY * B.ORDER_RATE / 100 ) ) ORDER_QTY,
						DECODE( B.ORDER_RATE , NULL ,A.ORDER_QTY ,  ( A.ORDER_QTY * B.ORDER_RATE / 100 ) ) PURCHASE_ORDER_QTY,							
						0 UNIT_PRICE , '*' CURRENCY  , 0  INVENTORY_QTY , 0 ARRIVAL_QTY , 0 PRE_ORDER_QTY ,
						A.MFS ,'N' ,
						NVL(B.PAYMENT_TYPE ,'*') PAYMENT_TYPE , 
						:GVS_USER_ID,   
						SYSDATE,   
						:GVS_USER_ID,   
						SYSDATE ,
						SET_ITEM_CODE ,
						PARENT_ITEM_CODE
				FROM   (   SELECT  ORGANIZATION_ID,    
										 ITEM_CODE,   
										 PLAN_DATE   DELIVERY_DATE,   
										 LINE_TYPE,   
										 SUM(REQUIRMENT_QTY) ORDER_QTY,  
										 MFS ,SET_ITEM_CODE , MAX(PARENT_ITEM_CODE) PARENT_ITEM_CODE
								  FROM IM_ITEM_PURCHASE_REQUIR_ORDER 
								WHERE TRUNC(PLAN_DATE) >= :LVD_DATESET
									AND TRUNC(PLAN_DATE) <= :LVD_DATEEND
									AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM
									                                   WHERE DATESET <= TRUNC(SYSDATE)
																        AND DATEEND >= TRUNC(SYSDATE) 
																        AND NVL(ORDER_RULE,'*' )  ='O' //$$HEX7$$c1c9a9b0ccb9200098ccacb92000$$ENDHEX$$
									                                        AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ) 
									AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
								  GROUP BY MFS ,  PLAN_DATE , SET_ITEM_CODE ,  ITEM_CODE  ,LINE_TYPE ,  ORGANIZATION_ID 
							) A , IM_ITEM_MASTER B
						WHERE A.ITEM_CODE            = B.ITEM_CODE(+) 
						    AND A.ORGANIZATION_ID = B.ORGANIZATION_ID(+) 
						    AND B.ORDER_RATE(+) > 0 
						    AND B.ORDER_RATE(+) <= 100 
   				  ORDER BY A.ITEM_CODE ;			 

		IF F_SQL_CHECK() < 0 THEN
             RETURN
		END IF	
		  LVL_COUNT = SQLCA.SQLNROWS				
END IF

//================================================================
open(w_progress_popup)
w_progress_popup.f_set_range( 0 , LVL_COUNT )
w_progress_popup.f_setstep(1)

OPEN CL_PLAN ;
DO
FETCH  CL_PLAN INTO :LVS_SUPPLIER_CODE , :LVS_ITEM_CODE , :LVS_LINE_TYPE , :LVF_ORDER_PLAN_QTY  , :LVS_ROWID ;
			IF F_SQL_CHECK() < 0 THEN 
				CLOSE CL_PLAN ;
				EXIT
			END IF

             IF SQLCA.SQLCODE = 100 THEN 
			   CLOSE CL_PLAN ;
			   EXIT
			END IF

I++
w_progress_popup.f_STEPIT()
//=======================================
// $$HEX7$$fcc838bb18c2c9b7200010ac48c5$$ENDHEX$$
//=======================================
	IF tab_1.tabpage_2.cbx_apply_inventory_qty.checked  = TRUE THEN 
	
			OPEN CL_INV ;
			DO
				
			LVF_INV_QTY = 0 ;	LVS_INV_ROWID = ''
			FETCH CL_INV INTO :LVF_INV_QTY ,  :LVS_INV_ROWID ;
					  IF F_SQL_CHECK() < 0 THEN 
						CLOSE CL_INV ;CLOSE CL_PLAN ;
						EXIT
					  END IF
					  
					  IF SQLCA.SQLCODE = 100 THEN 					  
						LVS_NOT_FOUND = 'Y'
					ELSE
						LVS_NOT_FOUND = 'N'
					END IF
		
                    	  //==================================================
			         //$$HEX13$$fcc838bb08c615c874c72000acc7e0acf4bce4b220006cd074ba$$ENDHEX$$
				  //==================================================
					IF LVF_ORDER_PLAN_QTY >  LVF_INV_QTY  THEN    
					
					    LVF_ORDER_PLAN_QTY = LVF_ORDER_PLAN_QTY - LVF_INV_QTY 					

					        IF TAB_1.TABPAGE_2.cbx_apply_auto_order_rule.CHECKED = TRUE THEN 
						      LVF_PURCHASE_ORDER_CALC_QTY = 0 ; 
						

							LVF_PURCHASE_ORDER_CALC_QTY =  F_GET_ORDER_PROPERTY( LVS_SUPPLIER_CODE , LVS_ITEM_CODE,  LVF_ORDER_PLAN_QTY , 'A' )	  
							IF LVF_PURCHASE_ORDER_CALC_QTY < 0 THEN 
								MESSAGEBOX("Error" , "Order Property Apply Error")
								CLOSE CL_INV ;CLOSE CL_PLAN ;
								RETURN
							END IF
							
							LVF_PURCHASE_ORDER_CALC_QTY =    LVF_PURCHASE_ORDER_CALC_QTY - LVF_ORDER_PLAN_QTY ;
							
						ELSE
							  LVF_PURCHASE_ORDER_CALC_QTY = 0
						END IF										
														
						UPDATE IM_ITEM_INVENTORY_GEN SET INVENTORY_QTY = :LVF_PURCHASE_ORDER_CALC_QTY
						  WHERE ROWID = :LVS_INV_ROWID ;
						   IF F_SQL_CHECK() < 0 THEN 
      						  CLOSE CL_INV ;CLOSE CL_PLAN ;
						       RETURN 
						   END IF
							
						 UPDATE IM_ITEM_PURCHASE_ORDER_PLAN
						       SET ORDER_NO =  'DO'||TO_CHAR(SYSDATE,'YYMMDD')||SEQ_ORDER_NO.NEXTVAL,
								INVENTORY_QTY =  	INVENTORY_QTY + :LVF_INV_QTY,
								TOTAL_INVENTORY_QTY = :LVF_INV_QTY ,
								PURCHASE_ORDER_QTY = :LVF_PURCHASE_ORDER_CALC_QTY + :LVF_ORDER_PLAN_QTY
						   WHERE ROWID = :LVS_ROWID ;
						   IF F_SQL_CHECK() < 0 THEN 
						       CLOSE CL_INV ;CLOSE CL_PLAN ;
						       RETURN 
						   END IF							
							
                     //=================================================================					   		  							
			 //$$HEX16$$fcc838bb08c615c874c7200091c770ac98b0200019ac3cc774ba090009000900$$ENDHEX$$
                     //=================================================================					   		  
					ELSEIF  LVF_ORDER_PLAN_QTY <=  LVF_INV_QTY  THEN 
						
		
						UPDATE IM_ITEM_INVENTORY_GEN 
						      SET INVENTORY_QTY =  INVENTORY_QTY - :LVF_ORDER_PLAN_QTY
						  WHERE ROWID = :LVS_INV_ROWID ;
						  
						   IF F_SQL_CHECK() < 0 THEN 
						       CLOSE CL_INV ;CLOSE CL_PLAN ;
						       RETURN 
						   END IF						
						
						 UPDATE IM_ITEM_PURCHASE_ORDER_PLAN
						       SET ORDER_NO = 'TA'||TO_CHAR(SYSDATE,'YYMMDD')||SEQ_ORDER_NO.NEXTVAL ,
								     INVENTORY_QTY =  	INVENTORY_QTY + :LVF_ORDER_PLAN_QTY ,
								     TOTAL_INVENTORY_QTY = :LVF_INV_QTY ,
    									 PURCHASE_ORDER_QTY =  0 
						   WHERE ROWID = :LVS_ROWID ;
						   IF F_SQL_CHECK() < 0 THEN 
						      CLOSE CL_INV ;CLOSE CL_PLAN ;
						       RETURN 
						   END IF								
						
						   LVF_ORDER_PLAN_QTY = 0  
						   CLOSE CL_INV ;
						  EXIT
						  
					END IF
				
				      IF LVS_NOT_FOUND = 'Y' then
						IF  J = 0 THEN 
						//	MESSAGEBOX("Notify" , "Inventory Data Not Found "+lvs_item_code )
						END IF 
						CLOSE CL_INV ;
						EXIT
					  END IF				
	J++				
				
			LOOP UNTIL 1 = 2 // $$HEX6$$acc7e0ac15c8f4bce4ce1cc1$$ENDHEX$$
			
	END IF
	
	F_MSG_MDI_HELP( STRING(I)+" Rows Processed!" )

LOOP UNTIL 1 = 2  //$$HEX7$$fcc838bb08c615c82000e4ce1cc1$$ENDHEX$$
close(w_progress_popup)

//==================================================
// $$HEX9$$1cc870c8acb9dcb4c0d084c7200024c115c8$$ENDHEX$$
//==================================================
	F_MSG_MDI_HELP( STRING(I)+"Set Manufacture Leadtime...")
	UPDATE IM_ITEM_PURCHASE_ORDER_PLAN A
	      SET A.DELIVERY_DATE 
			= (    SELECT A.DELIVERY_DATE  - NVL( B.MANUFACTURE_LEADTIME , 0) 
				 	 FROM ID_ITEM B
					WHERE A.ITEM_CODE = B.ITEM_CODE
						AND B.DATESET <= TRUNC(SYSDATE)
						AND B.DATEEND >= TRUNC(SYSDATE)
						AND A.ORGANIZATION_ID = B.ORGANIZATION_ID
						AND A.ORGANIZATION_ID = :GVI_ORGANIZATION_ID
						AND B.ORGANIZATION_ID = :GVI_ORGANIZATION_ID
				       AND A.PURCHASE_ORDER_DATE = :LVD_PO_DATE

				  )
   WHERE ( A.ITEM_CODE , A.ORGANIZATION_ID )
	     IN  (  SELECT  B.ITEM_CODE ,  B.ORGANIZATION_ID 
				  FROM  ID_ITEM B
	 		     WHERE  A.ITEM_CODE = B.ITEM_CODE
					AND B.DATESET <= TRUNC(SYSDATE)
					AND B.DATEEND >= TRUNC(SYSDATE)
					AND A.ORGANIZATION_ID = B.ORGANIZATION_ID
					AND A.ORGANIZATION_ID = :GVI_ORGANIZATION_ID
					AND B.ORGANIZATION_ID = :GVI_ORGANIZATION_ID
					 AND A.PURCHASE_ORDER_DATE = :LVD_PO_DATE
	             ) 
       AND A.PURCHASE_ORDER_DATE = :LVD_PO_DATE
	  AND A.ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;					 	
   IF F_SQL_CHECK() < 0 THEN 
	  RETURN 
   END IF	
	
////==================================================
//// $$HEX16$$24c698b2f4bce4b2200074c704c8a9b030ae20007cc704ad200018c215c82000$$ENDHEX$$
////==================================================	
//	ST_MSG.TEXT = STRING(I)+"Delivery Date Reset..."
//	UPDATE IM_ITEM_PURCHASE_ORDER_PLAN
//	      SET DELIVERY_DATE = TRUNC(SYSDATE)
//    WHERE PURCHASE_ORDER_STATUS = 'N' 
//        AND DELIVERY_DATE < TRUNC(SYSDATE)
//        AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;		
//
//   IF F_SQL_CHECK() < 0 THEN 
//	  RETURN 
//   END IF	

//===================================================
//$$HEX4$$d4c625b801c8a9c6$$ENDHEX$$
//===================================================
if tab_1.tabpage_2.cbx_apply_calendar.checked = true then 
	
	UPDATE IM_ITEM_PURCHASE_ORDER_PLAN
		 SET DELIVERY_DATE = NVL(F_GET_DELIVERY_DATE( DELIVERY_DATE , ORGANIZATION_ID) , PURCHASE_ORDER_DATE -1 )
	WHERE PURCHASE_ORDER_STATUS = 'N' 
		  AND PURCHASE_ORDER_DATE = :LVD_PO_DATE
		  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;		 
			  
	IF F_SQL_CHECK() < 0 THEN
		RETURN
	END IF
end if	  
		  
////==================================================
//// $$HEX10$$00b308ae2000c0c988bd20c715d6200024c115c8$$ENDHEX$$
////==================================================		
//	ST_MSG.TEXT = STRING(I)+"Payment Type Reset."
//	UPDATE IM_ITEM_PURCHASE_ORDER_PLAN A
//	      SET ( A.PAYMENT_TYPE ) 
//			= ( 
//					SELECT PAYMENT_TYPE
//		  			  FROM IM_ITEM_MASTER B
//					WHERE A.SUPPLIER_CODE = B.SUPPLIER_CODE
//						AND A.ITEM_CODE = B.ITEM_CODE
//						AND B.DATESET <= TRUNC(SYSDATE)
//						AND B.DATEEND >= TRUNC(SYSDATE)
//						AND A.ORGANIZATION_ID = B.ORGANIZATION_ID
//				  )
//   WHERE ( A.SUPPLIER_CODE , A.ITEM_CODE , A.ORGANIZATION_ID )
//	     IN  (  SELECT B.SUPPLIER_CODE , B.ITEM_CODE , B.ORGANIZATION_ID 
//		           FROM IM_ITEM_MASTER B
//				WHERE A.SUPPLIER_CODE = B.SUPPLIER_CODE
//					AND A.ITEM_CODE = B.ITEM_CODE	  
//	     			AND B.DATESET <= TRUNC(SYSDATE)
//					AND B.DATEEND >= TRUNC(SYSDATE)
//					AND A.ORGANIZATION_ID = B.ORGANIZATION_ID
//	             ) ;					 		 	
//   IF F_SQL_CHECK() < 0 THEN 
//	  RETURN 
//   END IF			
//=====================================================					 

IF tab_1.tabpage_2.CBX_APPLY_UNIT_PRICE.CHECKED = TRUE THEN 

	F_MSG_MDI_HELP(STRING(I)+"Unit Price Reset"	)
	UPDATE IM_ITEM_PURCHASE_ORDER_PLAN A
	      SET ( A.DELIVERY , A.UNIT_PRICE , A.CURRENCY ) 
			= ( 
					SELECT DELIVERY , UNIT_PRICE , CURRENCY  
		  			  FROM IM_ITEM_UNIT_PRICE B
					WHERE A.SUPPLIER_CODE = B.SUPPLIER_CODE
						AND A.ITEM_CODE = B.ITEM_CODE
						AND A.LINE_TYPE  = B.LINE_TYPE
						AND B.DATESET <= TRUNC(SYSDATE)
						AND B.DATEEND >= TRUNC(SYSDATE)
						AND A.ORGANIZATION_ID = B.ORGANIZATION_ID
				  )
   WHERE ( A.SUPPLIER_CODE , A.ITEM_CODE , A.LINE_TYPE , A.ORGANIZATION_ID )
	     IN  (  SELECT B.SUPPLIER_CODE , B.ITEM_CODE ,B.LINE_TYPE ,  B.ORGANIZATION_ID 
		           FROM IM_ITEM_UNIT_PRICE B
				WHERE A.SUPPLIER_CODE = B.SUPPLIER_CODE
					AND A.ITEM_CODE         = B.ITEM_CODE	  
					AND A.LINE_TYPE           = B.LINE_TYPE
					AND B.DATESET            <= TRUNC(SYSDATE)
					AND B.DATEEND            >= TRUNC(SYSDATE)
					AND A.ORGANIZATION_ID = B.ORGANIZATION_ID
	             ) 
       AND PURCHASE_ORDER_DATE = :LVD_PO_DATE
	  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;					 		 
END IF

   IF F_SQL_CHECK() < 0 THEN 
	  RETURN 
   END IF		
	
//======================================
//$$HEX10$$fcc838bb18c2c9b720002cc6bcb998ccacb92000$$ENDHEX$$
//======================================
if tab_1.tabpage_2.cbx_round.checked = true then 
	UPDATE IM_ITEM_PURCHASE_ORDER_PLAN 
		  SET  PURCHASE_ORDER_QTY = ROUND(PURCHASE_ORDER_QTY,4),
				  ORDER_QTY = ROUND(ORDER_QTY,4)
	 WHERE PURCHASE_ORDER_STATUS = 'N' 
		  AND PURCHASE_ORDER_DATE = :LVD_PO_DATE
		  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
	
		IF F_SQL_CHECK() < 0 THEN 
		  RETURN 
		END IF		
	end if 
//======================================
//$$HEX11$$fcc838bb08c615c82000c1c0dcd02000c0bcbdac2000$$ENDHEX$$
//======================================
UPDATE IM_ITEM_PURCHASE_ORDER_PLAN 
      SET PURCHASE_ORDER_STATUS = 'P' 
 WHERE PURCHASE_ORDER_STATUS = 'N' 
     AND DELIVERY IS NULL
	AND PURCHASE_ORDER_DATE = :LVD_PO_DATE
     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;

   IF F_SQL_CHECK() < 0 THEN 
	  RETURN 
   END IF		

//=======================================	
COMMIT ;
IF I = 0 THEN 
     F_MSGBOX(9026) //$$HEX13$$c0bcbdac1cb4200090c7ccb800ac2000c6c5b5c2c8b2e4b20900$$ENDHEX$$
ELSE
	
	F_MSGBOX(170) // $$HEX25$$74d5f9b2200090c7ccb800ac200031c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b20900090009002000$$ENDHEX$$
END IF
end event

type rb_from_sale_plan from so_radiobutton within tabpage_1
integer x = 1312
integer y = 52
integer width = 434
integer height = 64
boolean bringtotop = true
long backcolor = 15780518
string text = "Sale Plan"
boolean checked = true
end type

type rb_from_master_plan from so_radiobutton within tabpage_1
integer x = 1723
integer y = 52
integer width = 462
integer height = 64
boolean bringtotop = true
long backcolor = 15780518
string text = "Product Plan"
end type

type cb_price_reset from so_commandbutton within tabpage_1
integer x = 2651
integer y = 20
integer width = 398
integer height = 112
integer taborder = 60
boolean bringtotop = true
string text = "Price Reset"
end type

event clicked;F_MSG_MDI_HELP("Set Unit Price...")
	UPDATE IM_ITEM_PURCHASE_ORDER_PLAN A
	      SET ( A.DELIVERY , A.UNIT_PRICE , A.CURRENCY ) 
			= ( 
					SELECT DELIVERY , UNIT_PRICE , CURRENCY  
		  			  FROM IM_ITEM_UNIT_PRICE B
					WHERE A.SUPPLIER_CODE = B.SUPPLIER_CODE
						AND A.ITEM_CODE = B.ITEM_CODE
						AND A.LINE_TYPE  = B.LINE_TYPE
						AND B.DATESET <= TRUNC(SYSDATE)
						AND B.DATEEND >= TRUNC(SYSDATE)
						AND A.ORGANIZATION_ID = B.ORGANIZATION_ID
				  )
   WHERE ( A.SUPPLIER_CODE , A.ITEM_CODE , A.LINE_TYPE , A.ORGANIZATION_ID )
	     IN  (  SELECT B.SUPPLIER_CODE , B.ITEM_CODE ,B.LINE_TYPE ,  B.ORGANIZATION_ID 
		           FROM IM_ITEM_UNIT_PRICE B
				WHERE A.SUPPLIER_CODE = B.SUPPLIER_CODE
					AND A.ITEM_CODE         = B.ITEM_CODE	  
					AND A.LINE_TYPE           = B.LINE_TYPE
					AND B.DATESET            <= TRUNC(SYSDATE)
					AND B.DATEEND            >= TRUNC(SYSDATE)
					AND A.ORGANIZATION_ID = B.ORGANIZATION_ID ) ;

   IF F_SQL_CHECK() < 0 THEN 
	  RETURN 
   END IF		

//======================================
//$$HEX11$$fcc838bb08c615c82000c1c0dcd02000c0bcbdac2000$$ENDHEX$$
//======================================
F_MSG_MDI_HELP( "Set Oder Plan Status")
UPDATE IM_ITEM_PURCHASE_ORDER_PLAN    
       SET PURCHASE_ORDER_STATUS = 'N' 
 WHERE PURCHASE_ORDER_STATUS  =  'P'
     AND DELIVERY IS NOT NULL
     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;

   IF F_SQL_CHECK() < 0 THEN 
	  RETURN 
   END IF			
	
//======================================
//
//======================================
F_MSG_MDI_HELP( "Set Line Type...")
	UPDATE IM_ITEM_PURCHASE_ORDER_PLAN A
	      SET ( A.DELIVERY , A.UNIT_PRICE , A.CURRENCY , A.LINE_TYPE ) 
			= ( 
					SELECT DISTINCT DELIVERY , UNIT_PRICE , CURRENCY  , LINE_TYPE
		  			  FROM IM_ITEM_UNIT_PRICE B
					WHERE A.SUPPLIER_CODE = B.SUPPLIER_CODE
						AND A.ITEM_CODE = B.ITEM_CODE
						AND A.PURCHASE_ORDER_STATUS = 'P'
						AND B.DATESET <= TRUNC(SYSDATE)
						AND B.DATEEND >= TRUNC(SYSDATE)
						AND A.ORGANIZATION_ID = B.ORGANIZATION_ID
				  )
   WHERE ( A.SUPPLIER_CODE , A.ITEM_CODE ,  A.ORGANIZATION_ID )
	     IN  (  SELECT B.SUPPLIER_CODE , B.ITEM_CODE , B.ORGANIZATION_ID 
		           FROM IM_ITEM_UNIT_PRICE B
				WHERE A.SUPPLIER_CODE = B.SUPPLIER_CODE
					AND A.ITEM_CODE         = B.ITEM_CODE	  
					AND A.PURCHASE_ORDER_STATUS = 'P'
					AND B.DATESET            <= TRUNC(SYSDATE)
					AND B.DATEEND            >= TRUNC(SYSDATE)
					AND A.ORGANIZATION_ID = B.ORGANIZATION_ID )
     AND A.PURCHASE_ORDER_STATUS = 'P'					;

   IF F_SQL_CHECK() < 0 THEN 
	  RETURN 
   END IF		


//======================================
//$$HEX11$$fcc838bb08c615c82000c1c0dcd02000c0bcbdac2000$$ENDHEX$$
//======================================
UPDATE IM_ITEM_PURCHASE_ORDER_PLAN    
       SET PURCHASE_ORDER_STATUS = 'N' 
 WHERE PURCHASE_ORDER_STATUS  =  'P'
     AND DELIVERY IS NOT NULL
     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;

   IF F_SQL_CHECK() < 0 THEN 
	  RETURN 
   END IF		

//=======================================	

//MSG = F_MSGBOX(1170)
//IF MSG = 1 THEN
	
	F_MSGBOX(170) // $$HEX23$$74d5f9b2200090c7ccb800ac200031c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b209000900$$ENDHEX$$
	COMMIT ;
//ELSE
//	ROLLBACK;
//     F_MSGBOX(9026) //$$HEX13$$c0bcbdac1cb4200090c7ccb800ac2000c6c5b5c2c8b2e4b20900$$ENDHEX$$
//END IF
end event

type cb_1 from so_commandbutton within tabpage_1
integer x = 3826
integer y = 20
integer width = 466
integer height = 112
integer taborder = 50
boolean bringtotop = true
string text = "Purchase Selected"
end type

event clicked;IF F_OBJECT_ROLE_CHECK() = FALSE THEN  RETURN
open(w_mat_purchase_order_condition_popup) 
end event

type cb_purchase_po from so_commandbutton within tabpage_1
integer x = 3045
integer y = 20
integer width = 389
integer height = 112
integer taborder = 60
boolean bringtotop = true
string text = "Purchase All PO"
end type

event clicked;Long I , J 
DATETIME LVD_DATESET , LVD_DATEEND 
STRING LVS_ORDER_GROUP_NO , lvs_rowid

if dw_1.getrow( ) < 1 then 
	
	Messagebox("Notify" , "Retrieve order plan data first and Check item for order")
	return 
	
end if 

MSG = F_MSGBOX1( 1161 , THIS.TEXT ) //@ $$HEX7$$7cb9200098ccacb960d54cae94c6$$ENDHEX$$?
IF MSG = 1 THEN 
ELSE
	RETURN 
END IF

LVS_ORDER_GROUP_NO =  string(f_t_sysdate(),'yyyymmdd') + string( f_get_sequence( 'SEQ_PURCHASE_ORDER_NO'),'000')

do
	
	i++
	
	if dw_1.object.check_yn[i] = 'Y' then 
		
	    lvs_rowid = dw_1.object.rowid[i]	
		
	else
		continue
	end if
     
	  
//==========================================
// $$HEX11$$f1b409ae2000c6c574c7200004c8b4cc20001cbcfcc8$$ENDHEX$$
//==========================================
  INSERT INTO "IM_ITEM_PURCHASE_ORDER"  
         ( "ORDER_NO",  "ORDER_GROUP_NO",
           "ORGANIZATION_ID",   
           "PURCHASE_ORDER_DATE",   
           "SUPPLIER_CODE",   
           "ITEM_CODE",   
           "DELIVERY_DATE",   
           "DELIVERY",   
           "LINE_TYPE",   
           "ORDER_TYPE",   
           "ORDER_QTY",   
           "UNIT_PRICE",   
           "CURRENCY",   
           "ARRIVAL_QTY",   
           "MFS",   
           "ENTER_BY",   
           "ENTER_DATE",   
           "LAST_MODIFY_BY",   
           "LAST_MODIFY_DATE" )  
SELECT "ORDER_NO",  
            :LVS_ORDER_GROUP_NO ,
           "ORGANIZATION_ID",   
            TRUNC(SYSDATE) PURCHASE_ORDER_DATE,   
           "SUPPLIER_CODE",   
           "ITEM_CODE",   
           "DELIVERY_DATE",   
           NVL("DELIVERY" , '1') ,    //$$HEX11$$30aef8bc2000b4b018c220005cb8200024c115c82000$$ENDHEX$$
           "LINE_TYPE",   
           "ORDER_TYPE",   
           "PURCHASE_ORDER_QTY",   
           "UNIT_PRICE",   
           "CURRENCY",   
           "ARRIVAL_QTY",   
           "MFS",   
           :GVS_USER_ID ,   
           SYSDATE,   
           :GVS_USER_ID,   
           SYSDATE 
 FROM  IM_ITEM_PURCHASE_ORDER_PLAN 
WHERE ROWID = :LVS_ROWID 
    AND LINE_TYPE <> 'T' 
    AND DELIVERY IS NOT NULL ;
  
	IF F_SQL_CHECK() < 0 THEN 
		 RETURN
	END IF
	
 UPDATE IM_ITEM_PURCHASE_ORDER_PLAN SET PURCHASE_ORDER_STATUS = 'Y' 
 WHERE ROWID = :LVS_ROWID
    AND LINE_TYPE <> 'T' 
    AND DELIVERY IS NOT NULL;
 
 	IF F_SQL_CHECK() < 0 THEN 
		 RETURN
	END IF
	
	
J++
//=============================================
	
Loop until i = dw_1.rowcount( )

//=============================================

IF J  > 0 THEN 

	F_MSG_ST1(129 ,STRING(J)) //@$$HEX14$$89d558c7200098ccacb900ac200031c1f5ac58d500c6b5c2c8b2e4b2$$ENDHEX$$.
	F_MSGBOX(9088) //$$HEX14$$fcc838bb98ccacb900ac200044c6ccb8200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$
	COMMIT ;

ELSE
	
	ROLLBACK;
	F_MSGBOX(9026) //$$HEX12$$c0bcbdac1cb4200090c7ccb800ac2000c6c5b5c2c8b2e4b2$$ENDHEX$$

END IF	
end event

type cb_gen_po from so_commandbutton within tabpage_1
integer x = 466
integer y = 24
integer width = 402
integer height = 112
integer taborder = 40
boolean bringtotop = true
string text = "Generate PO"
end type

event clicked;IF F_OBJECT_ROLE_CHECK() = FALSE THEN  RETURN
//==========================================================
// $$HEX12$$5ccd08cdc4ac8dd67cc790c700ac2000a9b030ae7cc790c7$$ENDHEX$$
//==========================================================

STRING  LVS_SUPPLIER_CODE ,lvs_set_item_code , LVS_ITEM_CODE ,LVS_LINE_TYPE ,  LVS_ROWID , LVS_ORDER_ROWID , LVS_ARRIVAL_ROWID , LVS_INV_ROWID , LVS_ORDER_RULE
LONG I , J , LVL_COUNT , LVI_RETURN
DECIMAL LVF_ORDER_PLAN_QTY , LVF_ORDER_QTY , LVF_INV_QTY  , LVF_PURCHASE_ORDER_CALC_QTY
DATETIME LVD_DATESET , LVD_DATEEND , LVD_PO_DATE
STRING LVS_NOT_FOUND , lvs_distinct_mfs_yn , LVS_LINE_CODE


if f_msgbox1(1161 , this.text) = 1 then 
else
	return 
end if 

//===================================
// $$HEX6$$ddc031c1200070c874ac2000$$ENDHEX$$
//===================================
LVS_LINE_CODE = ddlb_line_code.getcode()+'%'
lvs_set_item_code = ddlb_model_name.getitem( )+'%' 
LVD_DATESET  = uo_generate_dateset.text()
LVD_DATEEND  = uo_generate_dateend.text()
LVD_PO_DATE = uo_po_date.text()

if isnull(lvs_set_item_code) then 
	lvs_set_item_code = '%'
end if 
//====================================
// $$HEX23$$88d4a9ba2000c8b9a4c230d1d0c5200090c7d9b31cbcfcc85cb8200020c1ddd02000ecc580bd2000b4cc6cd02000$$ENDHEX$$
//====================================
if tab_1.tabpage_2.cbx_apply_auto_order_rule.checked = true then 
	LVS_ORDER_RULE = 'A%'	
else
	LVS_ORDER_RULE = '%'
end if
//====================================
// $$HEX16$$1cc870c888bc38d6200034bbdcc258d5e0ac200088d4a9ba200069d5d1bc2000$$ENDHEX$$
//====================================
if tab_1.tabpage_2.cbx_distinct_mfs.checked = true then
	lvs_distinct_mfs_yn = 'Y'
else
	lvs_distinct_mfs_yn = 'N'
end if 

//=================================================
// $$HEX8$$fcc838bb08c615c815c8f4bce4ce1cc1$$ENDHEX$$
//=================================================
DECLARE CL_PLAN CURSOR FOR 
  SELECT SUPPLIER_CODE , ITEM_CODE , LINE_TYPE , ORDER_QTY ,  ROWID 
    FROM IM_ITEM_PURCHASE_ORDER_PLAN 
  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 	 
  ORDER BY ITEM_CODE ,LINE_TYPE , DELIVERY_DATE , ORGANIZATION_ID ; 

//=================================================
// $$HEX6$$fcc838bb15c8f4bce4ce1cc1$$ENDHEX$$
// $$HEX3$$f8bbacc0a9c6$$ENDHEX$$
//=================================================
DECLARE CL_ORDER CURSOR FOR 
    SELECT ITEM_CODE ,LINE_TYPE ,   ORDER_QTY , ROWID
      FROM IM_ITEM_PURCHASE_ORDER_GEN
   WHERE ITEM_CODE = :LVS_ITEM_CODE
        AND LINE_TYPE = :LVS_LINE_TYPE
	   AND ORDER_QTY > 0
	   AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID	
  ORDER BY ITEM_CODE ,LINE_TYPE ,  ORGANIZATION_ID ;
		
//=================================================
// $$HEX8$$c4b329cc15c8f4bc2000e4ce1cc12000$$ENDHEX$$
// $$HEX3$$f8bbacc0a9c6$$ENDHEX$$
//=================================================
DECLARE CL_ARRIVAL CURSOR FOR 
  SELECT ITEM_CODE , LINE_TYPE , ARRIVAL_QTY  , ROWID 
    FROM IM_ITEM_ARRIVAL_GEN 
  WHERE ITEM_CODE = :LVS_ITEM_CODE
       AND LINE_TYPE = :LVS_LINE_TYPE  
       AND ARRIVAL_QTY > 0 
       AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID 	
  ORDER BY ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ;
  
//=================================================
// $$HEX7$$acc7e0ac15c8f4bc2000e4ce1cc1$$ENDHEX$$
//=================================================
DECLARE CL_INV CURSOR FOR 
  SELECT NVL(INVENTORY_QTY,0)  ,  ROWID 
    FROM IM_ITEM_INVENTORY_GEN 
  WHERE ITEM_CODE = :LVS_ITEM_CODE
       AND LINE_TYPE  = :LVS_LINE_TYPE
       AND NVL(INVENTORY_QTY,0) > 0 
       AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID 	
  ORDER BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID ;  
    
//=================================================
// $$HEX10$$fcc838bb94c7c9b7200069d5c4ac2000ddc031c1$$ENDHEX$$
//=================================================
  DELETE FROM IM_ITEM_PURCHASE_ORDER_GEN 
   WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID  ;
  IF F_SQL_CHECK_WITH_MSG(' PURCHASE ORDER GEN DELETE') < 0 THEN 
	 RETURN
  END IF		
	
  INSERT INTO IM_ITEM_PURCHASE_ORDER_GEN 
                    ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,DELIVERY_DATE ,  ORDER_QTY )
          SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , DELIVERY_DATE ,  SUM(ORDER_QTY - NVL(ARRIVAL_QTY,0) )
			FROM IM_ITEM_PURCHASE_ORDER
           WHERE  ORDER_QTY - NVL(ARRIVAL_QTY,0) > 0 
			   AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
	       GROUP BY ITEM_CODE ,LINE_TYPE , DELIVERY_DATE , ORGANIZATION_ID ;
			  
  IF F_SQL_CHECK_WITH_MSG(' PURCHASE ORDER GEN ') < 0 THEN
	 RETURN
  END IF			  
			  
  //================================================
  // $$HEX9$$c4b329cc94c7c9b769d5c4ac2000ddc031c1$$ENDHEX$$
  //================================================

  DELETE FROM IM_ITEM_ARRIVAL_GEN 
   WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID  ;
  IF F_SQL_CHECK_WITH_MSG('ARRIVAL GEN DELETE ') < 0 THEN 
	 RETURN
  END IF		
  
  INSERT INTO IM_ITEM_ARRIVAL_GEN
                    ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  ARRIVAL_QTY )
          SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  SUM(ARRIVAL_QTY)
			FROM IM_ITEM_ARRIVAL
           WHERE ARRIVAL_TYPE  = 'A'  //$$HEX4$$c4b329ccc1c0dcd0$$ENDHEX$$
			  AND ARRIVAL_STATUS = 'N'
			  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
	       GROUP BY ITEM_CODE ,LINE_TYPE  , ORGANIZATION_ID ;
			  
  IF F_SQL_CHECK_WITH_MSG('ARRIVAL GEN ') < 0 THEN 
	 RETURN
  END IF
    
  //================================================
  //$$HEX9$$acc7e0ac18c2c9b769d5c4ac2000ddc031c1$$ENDHEX$$
  //================================================
 DELETE FROM IM_ITEM_INVENTORY_GEN
  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID  ;
  
  IF F_SQL_CHECK_WITH_MSG('INVENTORY GEN DELETE ') < 0 THEN 
	 RETURN
  END IF		

IF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = True and tab_1.tabpage_2.cbx_apply_order_qty.checked = True and &
     tab_1.tabpage_2.cbx_apply_inventory_qty.checked = True and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = True and tab_1.tabpage_2.cbx_outside_inv.checked = TRUE THEN //$$HEX13$$04c880bd200010ac48c520002000acc7e0ac5cb8200020002000$$ENDHEX$$

		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
		
					 SELECT 	 ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY)	 , 0 			  
					 FROM  (
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  SUM(INVENTORY_QTY) QTY
								FROM IM_ITEM_INVENTORY
							  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
							      and  LOCATION_CODE = 'M01'
							 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID
					
							 
							  UNION ALL			
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(ORDER_QTY) QTY 
							    FROM IM_ITEM_PURCHASE_ORDER_GEN
							  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	 
			                                GROUP BY 	 ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 						  
							 
							  UNION ALL
						
								SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  ARRIVAL_QTY  QTY
								  FROM IM_ITEM_ARRIVAL_GEN
								 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
			
								 
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID  ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF 
	
ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = True and tab_1.tabpage_2.cbx_apply_order_qty.checked = True and &
	     tab_1.tabpage_2.cbx_apply_inventory_qty.checked = True and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = false and tab_1.tabpage_2.cbx_outside_inv.checked = TRUE THEN //$$HEX19$$fcc838bb2000c4b329cc20003dcce0ac200010ac48c52000acc7e0ac5cb82000200020000900$$ENDHEX$$

		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
		
					 SELECT 	 ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY)	 , 0 			  
					 FROM  (
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  SUM(INVENTORY_QTY) QTY
								FROM IM_ITEM_INVENTORY
							  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID
							      AND  LOCATION_CODE = 'M01'
							 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID
							  UNION ALL
			
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(ORDER_QTY) QTY 
							    FROM IM_ITEM_PURCHASE_ORDER_GEN
							  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	 
			                                GROUP BY 	 ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 						  
							 
							  UNION ALL
						
								SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  ARRIVAL_QTY  QTY
								  FROM IM_ITEM_ARRIVAL_GEN
								 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
								 
					
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID  ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  		 
  
ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = True and tab_1.tabpage_2.cbx_apply_order_qty.checked = True and & 
	     tab_1.tabpage_2.cbx_apply_inventory_qty.checked = false and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = false and tab_1.tabpage_2.cbx_outside_inv.checked = TRUE THEN //$$HEX19$$c4b329cc58d5e0ac2000fcc838bb44c7200010ac48c52000acc7e0ac5cb82000200020000900$$ENDHEX$$

		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
		
					 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY)	 , 0 			  
					 FROM  (

							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(ORDER_QTY) QTY 
							    FROM IM_ITEM_PURCHASE_ORDER_GEN
							  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	 
			                                GROUP BY 	 ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 						  
							 
							  UNION ALL
						
								SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  ARRIVAL_QTY  QTY
								  FROM IM_ITEM_ARRIVAL_GEN
								 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
								 
							 UNION ALL
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(INVENTORY_QTY) QTY
							    FROM IM_ITEM_FREE_INVENTORY
							 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	
							      AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_DIVISION IN ( 'R' ,'S') AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
							   GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 
								 							 
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID  ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  

ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = True and tab_1.tabpage_2.cbx_apply_order_qty.checked = false and &
	      tab_1.tabpage_2.cbx_apply_inventory_qty.checked = false and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = false and tab_1.tabpage_2.cbx_outside_inv.checked = TRUE THEN //$$HEX14$$c4b329ccccb9200010ac48c52000acc7e0ac5cb82000200020000900$$ENDHEX$$

		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
					 SELECT 	 ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY)	 , 0 		  
					 FROM  (
					
								SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  ARRIVAL_QTY  QTY
								  FROM IM_ITEM_ARRIVAL_GEN
								 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
								 
							UNION ALL
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(INVENTORY_QTY) QTY
							    FROM IM_ITEM_FREE_INVENTORY
							 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	
							      AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_DIVISION IN ( 'R' ,'S') AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
							   GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  		
ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = false and tab_1.tabpage_2.cbx_apply_order_qty.checked = true and &
	      tab_1.tabpage_2.cbx_apply_inventory_qty.checked = true and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = false and tab_1.tabpage_2.cbx_outside_inv.checked = TRUE THEN // $$HEX11$$fcc838bb15c8f4bc40c620003dcce0acacc7e0ac2000$$ENDHEX$$

		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
		
					 SELECT 	 ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY) , 0		  
					 FROM  (
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  SUM(INVENTORY_QTY) QTY
								FROM IM_ITEM_INVENTORY
							  WHERE  ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
							      AND   LOCATION_CODE = 'M01'
							 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID
							  UNION ALL

							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(ORDER_QTY) QTY
							    FROM IM_ITEM_PURCHASE_ORDER_GEN
							  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	 
							   GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 
								
							UNION ALL
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(INVENTORY_QTY) QTY
							    FROM IM_ITEM_FREE_INVENTORY
							 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	
							      AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_DIVISION IN ( 'R' ,'S') AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
							   GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 
								
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  		
		
ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = true and tab_1.tabpage_2.cbx_apply_order_qty.checked = false and & 
	      tab_1.tabpage_2.cbx_apply_inventory_qty.checked = true and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = false and tab_1.tabpage_2.cbx_outside_inv.checked = TRUE THEN //$$HEX18$$c4b329cc58d5e0ac20003dcce0ac18c2c9b7ccb92000acc7e0ac5cb8200078c715c82000$$ENDHEX$$
		  

		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
		
					 SELECT 	 ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY)	 , 0 			  
					 FROM  (
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  SUM(INVENTORY_QTY) QTY
								FROM IM_ITEM_INVENTORY
							  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
							       AND   LOCATION_CODE = 'M01'
							 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID
							 
							  UNION ALL
						
								SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  ARRIVAL_QTY  QTY
								  FROM IM_ITEM_ARRIVAL_GEN
								 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
								 
							 UNION ALL
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(INVENTORY_QTY) QTY
							    FROM IM_ITEM_FREE_INVENTORY
							 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	
							      AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_DIVISION IN ( 'R' ,'S') AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
							   GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 
								 
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID  ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  		  
				  
ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED =  true and tab_1.tabpage_2.cbx_apply_order_qty.checked = false and & 
	      tab_1.tabpage_2.cbx_apply_inventory_qty.checked = true and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = true and tab_1.tabpage_2.cbx_outside_inv.checked = TRUE THEN //$$HEX21$$c4b329cc58d5e0ac20003dcce0ac2000f5ac15c818c2c9b7ccb92000acc7e0ac5cb8200078c715c82000$$ENDHEX$$


		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
		
					 SELECT 	 ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY)	 , 0 			  
					 FROM  (
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  SUM(INVENTORY_QTY) QTY
								FROM IM_ITEM_INVENTORY
							  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
							      AND  LOCATION_CODE = 'M01'
							 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID
							 
							  UNION ALL
						
								SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  ARRIVAL_QTY  QTY
								  FROM IM_ITEM_ARRIVAL_GEN
								 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
								 
							  UNION ALL
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(INVENTORY_QTY) QTY
							    FROM IM_ITEM_WORKSTAGE_INVENTORY
							 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	
							      AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_DIVISION IN ( 'R' ,'S') AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
							   GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 	
								
							UNION ALL
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(INVENTORY_QTY) QTY
							    FROM IM_ITEM_FREE_INVENTORY
							 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	
							      AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_DIVISION IN ( 'R' ,'S') AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
							   GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID  ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  		  				  


ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = false and tab_1.tabpage_2.cbx_apply_order_qty.checked = false and & 
	     tab_1.tabpage_2.cbx_apply_inventory_qty.checked = true and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = true and tab_1.tabpage_2.cbx_outside_inv.checked = TRUE THEN //$$HEX16$$3dcce0ac58d5e0ac2000f5ac15c8ccb92000acc7e0ac5cb8200078c715c82000$$ENDHEX$$

		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
		
					 SELECT 	 ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY) , 0		  
					 FROM  (
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  SUM(INVENTORY_QTY) QTY
								FROM IM_ITEM_INVENTORY
							  WHERE  ORGANIZATION_ID = :GVI_ORGANIZATION_ID
							      AND   LOCATION_CODE = 'M01'
							 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID
							  UNION ALL
			
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(INVENTORY_QTY) QTY
							    FROM IM_ITEM_WORKSTAGE_INVENTORY
							 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	
							      AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_DIVISION IN ( 'R' ,'S') AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
							   GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 
					
								
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  		

ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = false and tab_1.tabpage_2.cbx_apply_order_qty.checked = false and & 
	     tab_1.tabpage_2.cbx_apply_inventory_qty.checked = false and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = true and tab_1.tabpage_2.cbx_outside_inv.checked = TRUE THEN  // $$HEX11$$f5ac15c8ccb92000acc7e0ac5cb8200078c715c82000$$ENDHEX$$

		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
		
					 SELECT 	 ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY) , 0		  
					 FROM  (
						
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(INVENTORY_QTY) QTY
							    FROM IM_ITEM_WORKSTAGE_INVENTORY
							 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	
							      AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_DIVISION IN ( 'R' ,'S') AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
							   GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 
								
								UNION ALL
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(INVENTORY_QTY) QTY
							    FROM IM_ITEM_FREE_INVENTORY
							 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	
							      AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_DIVISION IN ( 'R' ,'S') AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
							   GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 
								
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  		


ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = false and tab_1.tabpage_2.cbx_apply_order_qty.checked = false and &
	     tab_1.tabpage_2.cbx_apply_inventory_qty.checked = true and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = false and tab_1.tabpage_2.cbx_outside_inv.checked = TRUE THEN //$$HEX10$$3dcce0acccb9acc7e0ac5cb8200078c715c82000$$ENDHEX$$

		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
		
					 SELECT 	 ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY) , 0		  
					 FROM  (
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  SUM(INVENTORY_QTY) QTY
								FROM IM_ITEM_INVENTORY
							  WHERE  ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
							       AND   LOCATION_CODE = 'M01'
							 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID
							
								
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID ;
				  
				  
				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  

//===================================================  
ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = True and tab_1.tabpage_2.cbx_apply_order_qty.checked = True and &
     tab_1.tabpage_2.cbx_apply_inventory_qty.checked = True and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = True and tab_1.tabpage_2.cbx_outside_inv.checked = false THEN //$$HEX13$$04c880bd200010ac48c520002000acc7e0ac5cb8200020002000$$ENDHEX$$

		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
		
					 SELECT 	 ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY)	 , 0 			  
					 FROM  (
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  SUM(INVENTORY_QTY) QTY
								FROM IM_ITEM_INVENTORY
							  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
							      AND   LOCATION_CODE = 'M01'
							 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID
							  UNION ALL
					
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(ORDER_QTY) QTY 
							    FROM IM_ITEM_PURCHASE_ORDER_GEN
							  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	 
			                                GROUP BY 	 ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 						  
							 
							  UNION ALL
						
								SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  ARRIVAL_QTY  QTY
								  FROM IM_ITEM_ARRIVAL_GEN
								 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
								 
							  UNION ALL
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(INVENTORY_QTY) QTY
							    FROM IM_ITEM_WORKSTAGE_INVENTORY
							 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	
							      AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_DIVISION IN ( 'R' ,'S') AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
							   GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 
																 
								 
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID  ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF 
	
ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = True and tab_1.tabpage_2.cbx_apply_order_qty.checked = True and &
	     tab_1.tabpage_2.cbx_apply_inventory_qty.checked = True and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = false and tab_1.tabpage_2.cbx_outside_inv.checked = false THEN //$$HEX19$$fcc838bb2000c4b329cc20003dcce0ac200010ac48c52000acc7e0ac5cb82000200020000900$$ENDHEX$$

		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
		
					 SELECT 	 ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY)	 , 0 			  
					 FROM  (
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  SUM(INVENTORY_QTY) QTY
								FROM IM_ITEM_INVENTORY
							  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
							       AND   LOCATION_CODE = 'M01'
							 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID
							  UNION ALL
				
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(ORDER_QTY) QTY 
							    FROM IM_ITEM_PURCHASE_ORDER_GEN
							  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	 
			                                GROUP BY 	 ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 						  
							 
							  UNION ALL
						
								SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  ARRIVAL_QTY  QTY
								  FROM IM_ITEM_ARRIVAL_GEN
								 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID  ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  		 
  
ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = True and tab_1.tabpage_2.cbx_apply_order_qty.checked = True and & 
	     tab_1.tabpage_2.cbx_apply_inventory_qty.checked = false and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = false and tab_1.tabpage_2.cbx_outside_inv.checked = false THEN //$$HEX19$$c4b329cc58d5e0ac2000fcc838bb44c7200010ac48c52000acc7e0ac5cb82000200020000900$$ENDHEX$$

		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
		
					 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY)	 , 0 			  
					 FROM  (

							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(ORDER_QTY) QTY 
							    FROM IM_ITEM_PURCHASE_ORDER_GEN
							  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	 
			                                GROUP BY 	 ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 						  
							 
							  UNION ALL
						
								SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  ARRIVAL_QTY  QTY
								  FROM IM_ITEM_ARRIVAL_GEN
								 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
								 							 
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID  ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  

ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = True and tab_1.tabpage_2.cbx_apply_order_qty.checked = false and &
	      tab_1.tabpage_2.cbx_apply_inventory_qty.checked = false and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = false and tab_1.tabpage_2.cbx_outside_inv.checked = false THEN //$$HEX14$$c4b329ccccb9200010ac48c52000acc7e0ac5cb82000200020000900$$ENDHEX$$

		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
					 SELECT 	 ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY)	 , 0 		  
					 FROM  (
					
								SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  ARRIVAL_QTY  QTY
								  FROM IM_ITEM_ARRIVAL_GEN
								 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  		
				  
				  //==========================================
				  //Purchase Order Oty  And  Inventory Qty
				  //==========================================
ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = false and tab_1.tabpage_2.cbx_apply_order_qty.checked = true and &
	      tab_1.tabpage_2.cbx_apply_inventory_qty.checked = true and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = false and tab_1.tabpage_2.cbx_outside_inv.checked = false THEN // $$HEX11$$fcc838bb15c8f4bc40c620003dcce0acacc7e0ac2000$$ENDHEX$$

		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
		
					 SELECT 	 ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY) , 0		  
					 FROM  (
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  SUM(INVENTORY_QTY) QTY
								FROM IM_ITEM_INVENTORY
							  WHERE  ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
							       AND   LOCATION_CODE = 'M01'
							 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID
							  UNION ALL
					
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(ORDER_QTY) QTY
							    FROM IM_ITEM_PURCHASE_ORDER_GEN
							  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	 
							   GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 
								
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  		
		
ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = true and tab_1.tabpage_2.cbx_apply_order_qty.checked = false and & 
	      tab_1.tabpage_2.cbx_apply_inventory_qty.checked = true and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = false and tab_1.tabpage_2.cbx_outside_inv.checked = false THEN //$$HEX18$$c4b329cc58d5e0ac20003dcce0ac18c2c9b7ccb92000acc7e0ac5cb8200078c715c82000$$ENDHEX$$
		  

		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
		
					 SELECT 	 ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY)	 , 0 			  
					 FROM  (
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  SUM(INVENTORY_QTY) QTY
								FROM IM_ITEM_INVENTORY
							  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
							       AND   LOCATION_CODE = 'M01'
							 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID
							  UNION ALL
				
						
								SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  ARRIVAL_QTY  QTY
								  FROM IM_ITEM_ARRIVAL_GEN
								 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
								 
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID  ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  		  
				  
ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED =  true and tab_1.tabpage_2.cbx_apply_order_qty.checked = false and & 
	      tab_1.tabpage_2.cbx_apply_inventory_qty.checked = true and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = true and tab_1.tabpage_2.cbx_outside_inv.checked = false THEN //$$HEX21$$c4b329cc58d5e0ac20003dcce0ac2000f5ac15c818c2c9b7ccb92000acc7e0ac5cb8200078c715c82000$$ENDHEX$$


		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
		
					 SELECT 	 ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY)	 , 0 			  
					 FROM  (
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  SUM(INVENTORY_QTY) QTY
								FROM IM_ITEM_INVENTORY
							  WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
							       AND   LOCATION_CODE = 'M01'
							 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID
										 
							  UNION ALL
						
								SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  ARRIVAL_QTY  QTY
								  FROM IM_ITEM_ARRIVAL_GEN
								 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
								 
							  UNION ALL
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(INVENTORY_QTY) QTY
							    FROM IM_ITEM_WORKSTAGE_INVENTORY
							 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	
							      AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_DIVISION IN ( 'R' ,'S') AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
							   GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 								 
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID  ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  		  				  


ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = false and tab_1.tabpage_2.cbx_apply_order_qty.checked = false and & 
	     tab_1.tabpage_2.cbx_apply_inventory_qty.checked = true and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = true and tab_1.tabpage_2.cbx_outside_inv.checked = false THEN //$$HEX16$$3dcce0ac58d5e0ac2000f5ac15c8ccb92000acc7e0ac5cb8200078c715c82000$$ENDHEX$$

		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
		
					 SELECT 	 ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY) , 0		  
					 FROM  (
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  SUM(INVENTORY_QTY) QTY
								FROM IM_ITEM_INVENTORY
							  WHERE  ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
							       AND   LOCATION_CODE = 'M01'
							 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID
							 
							  UNION ALL
							   
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(INVENTORY_QTY) QTY
							    FROM IM_ITEM_WORKSTAGE_INVENTORY
							 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	
							      AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_DIVISION IN ( 'R' ,'S') AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
							   GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID 
								
								  ) 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  		

ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = false and tab_1.tabpage_2.cbx_apply_order_qty.checked = false and & 
	     tab_1.tabpage_2.cbx_apply_inventory_qty.checked = false and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = true and tab_1.tabpage_2.cbx_outside_inv.checked = false THEN  // $$HEX11$$f5ac15c8ccb92000acc7e0ac5cb8200078c715c82000$$ENDHEX$$

		  INSERT INTO IM_ITEM_INVENTORY_GEN 
								  ( ITEM_CODE , LINE_TYPE , ORGANIZATION_ID ,  INVENTORY_QTY , PURCHASE_ORDER_QTY )
		
					 SELECT 	 ITEM_CODE , LINE_TYPE , ORGANIZATION_ID  , SUM(QTY) , 0		  
					 FROM  (
						
							 SELECT ITEM_CODE , LINE_TYPE , ORGANIZATION_ID , SUM(INVENTORY_QTY) QTY
							    FROM IM_ITEM_WORKSTAGE_INVENTORY
							 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID   	
							      AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_DIVISION IN ( 'R' ,'S') AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
							   GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID )
								
								 
					 GROUP BY ITEM_CODE ,LINE_TYPE , ORGANIZATION_ID  ;

				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  		


ELSEIF tab_1.tabpage_2.cbx_apply_arrival_qty.CHECKED = false and tab_1.tabpage_2.cbx_apply_order_qty.checked = false and &
	     tab_1.tabpage_2.cbx_apply_inventory_qty.checked = true and tab_1.tabpage_2.cbx_apply_workstage_inventory_qty.checked = false and tab_1.tabpage_2.cbx_outside_inv.checked = false THEN //$$HEX10$$3dcce0acccb9acc7e0ac5cb8200078c715c82000$$ENDHEX$$

INSERT INTO im_item_inventory_gen
            (item_code, line_type, organization_id, inventory_qty,
             purchase_order_qty)
select      item_code,
            line_type,
            organization_id,
            SUM (qty) qty,
            0
 from (                    
   SELECT   item_code,
            line_type,
            organization_id,
            SUM (inventory_qty) qty
            
       FROM im_item_inventory
      WHERE organization_id = :gvi_organization_id
		   AND   LOCATION_CODE = 'M01'
   GROUP BY item_code, line_type, organization_id

   ) 
   GROUP BY item_code, line_type, organization_id   ;
				  IF F_SQL_CHECK_WITH_MSG('INSERT INVENTORY GEN ') < 0 THEN 
					 RETURN
				  END IF  
			else 
				Messagebox("Notify" , "Option Not Selected!")
				  
END IF
//==========================================
// $$HEX12$$18c2d9b32000c4ac8dd620003cc75cb8200080bd30d12000$$ENDHEX$$
//==========================================
	IF tab_1.tabpage_1.RB_FROM_MANUAL_PLAN.CHECKED = TRUE THEN
	
		if Gvs_sale_division = 'SAMSUNG' then
			
	      // $$HEX10$$10d3e4b9c4ac8dd6d0c5200000b358d5ecc52000$$ENDHEX$$BOM $$HEX15$$04c81cac20000fbc200084c7dcc220004cd174c714bed0c5200085c725b8$$ENDHEX$$
		 LVI_RETURN = F_GEN_PURCHASE_ORDER_PLAN_BY_MANUAL( LVD_DATESET , LVD_DATEEND , lvs_set_item_code , '%') ;
		 IF LVI_RETURN < 0 THEN 
			MESSAGEBOX("Error" , lvs_set_item_code+" Can`t  BOM Explosion Check BOM and Retry Again..." )
			ROLLBACK ; 
			RETURN 
		 END IF
	ELSE
		
	      // $$HEX10$$10d3e4b9c4ac8dd6d0c5200000b358d5ecc52000$$ENDHEX$$BOM $$HEX15$$04c81cac20000fbc200084c7dcc220004cd174c714bed0c5200085c725b8$$ENDHEX$$
		 LVI_RETURN = F_GEN_PURCHASE_ORDER_PLAN_BY_MANUAL( LVD_DATESET , LVD_DATEEND , lvs_set_item_code , '%' ) ;
		 IF LVI_RETURN < 0 THEN 
			MESSAGEBOX("Error" , " Can`t  BOM Explosion" )
			ROLLBACK ; 
			RETURN 
		 END IF		
	END IF 
	 
     	  DELETE FROM IM_ITEM_PURCHASE_ORDER_PLAN WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID  ;
		  
		  IF F_SQL_CHECK() < 0 THEN 
			 RETURN
		  END IF

		  IF LVS_distinct_mfs_yn = 'Y' then 
			
		  INSERT INTO IM_ITEM_PURCHASE_ORDER_PLAN  
						( ORDER_NO,    PURCHASE_ORDER_DATE,    ORGANIZATION_ID,    SUPPLIER_CODE,   
						  ITEM_CODE,   DELIVERY_DATE,   DELIVERY,   LINE_TYPE,   ORDER_TYPE,   
						  ORDER_QTY,   PURCHASE_ORDER_QTY ,  UNIT_PRICE,    CURRENCY,   
						  INVENTORY_QTY,    ARRIVAL_QTY,    PRE_ORDER_QTY,   
						  MFS,   PURCHASE_ORDER_STATUS ,
						  PAYMENT_TYPE ,
						  ENTER_BY,    ENTER_DATE,    LAST_MODIFY_BY,   LAST_MODIFY_DATE , 
						  SET_ITEM_CODE , PARENT_ITEM_CODE ) 
		
				SELECT   TO_CHAR(A.ORGANIZATION_ID)||TO_CHAR(SYSDATE,'YYMMDD')||ROWNUM ,
						:LVD_PO_DATE       PURCHASE_ORDER_DATE ,
						A.ORGANIZATION_ID ,  
						NVL(B.SUPPLIER_CODE ,'*' )  SUPPLIER_CODE , // F_GET_MAX_VENDOR_BY_ITEM( A.ITEM_CODE , A.ORGANIZATION_ID ) SUPPLIER_CODE,   
						A.ITEM_CODE , 
						A.DELIVERY_DATE , 
						'' DELIVERY , 
						A.LINE_TYPE ,
						'F'                               ORDER_TYPE,   
						DECODE( B.ORDER_RATE , NULL ,A.ORDER_QTY ,  ( A.ORDER_QTY * B.ORDER_RATE / 100 ) ) ORDER_QTY,
						DECODE( B.ORDER_RATE , NULL ,A.ORDER_QTY ,  ( A.ORDER_QTY * B.ORDER_RATE / 100 ) ) PURCHASE_ORDER_QTY,							
						0 UNIT_PRICE , '*' CURRENCY  , 0  INVENTORY_QTY , 0 ARRIVAL_QTY , 0 PRE_ORDER_QTY ,
						A.MFS ,'N' ,
						NVL(B.PAYMENT_TYPE ,'*') PAYMENT_TYPE , 
						:GVS_USER_ID,   
						SYSDATE,   
						:GVS_USER_ID,   
						SYSDATE ,
						SET_ITEM_CODE , PARENT_ITEM_CODE
				FROM   (   SELECT  ORGANIZATION_ID,    
										 ITEM_CODE,   
										 MIN(PLAN_DATE)   DELIVERY_DATE,   
										 LINE_TYPE,   
										 SUM(REQUIRMENT_QTY) ORDER_QTY,  
										 '*' MFS ,
										 MAX(SET_ITEM_CODE) SET_ITEM_CODE , MAX(PARENT_ITEM_CODE) PARENT_ITEM_CODE
								  FROM IM_ITEM_PURCHASE_REQUIR_ORDER 
								WHERE TRUNC(PLAN_DATE) >= :LVD_DATESET
									AND TRUNC(PLAN_DATE) <= :LVD_DATEEND
									AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM
									                                   WHERE DATESET <= TRUNC(SYSDATE)
																     AND DATEEND >= TRUNC(SYSDATE) 
																     AND NVL(ORDER_RULE,'*' )  LIKE :LVS_ORDER_RULE
									                                     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ) 
									AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
								  GROUP BY ITEM_CODE  ,LINE_TYPE ,  ORGANIZATION_ID 
							) A , IM_ITEM_MASTER B
						WHERE A.ITEM_CODE            = B.ITEM_CODE(+) 
						    AND A.ORGANIZATION_ID = B.ORGANIZATION_ID(+) 
						    AND B.ORDER_RATE(+) > 0 
						    AND B.ORDER_RATE(+) <= 100 
   				  ORDER BY A.ITEM_CODE ;		
					  
		  else

		  INSERT INTO IM_ITEM_PURCHASE_ORDER_PLAN  
						( ORDER_NO,    PURCHASE_ORDER_DATE,    ORGANIZATION_ID,    SUPPLIER_CODE,   
						  ITEM_CODE,   DELIVERY_DATE,   DELIVERY,   LINE_TYPE,   ORDER_TYPE,   
						  ORDER_QTY,   PURCHASE_ORDER_QTY ,  UNIT_PRICE,    CURRENCY,   
						  INVENTORY_QTY,    ARRIVAL_QTY,    PRE_ORDER_QTY,   
						  MFS,   PURCHASE_ORDER_STATUS ,
						  PAYMENT_TYPE ,
						  ENTER_BY,    ENTER_DATE,    LAST_MODIFY_BY,   LAST_MODIFY_DATE , SET_ITEM_CODE , PARENT_ITEM_CODE ) 
		
				SELECT   TO_CHAR(A.ORGANIZATION_ID)||TO_CHAR(SYSDATE,'YYMMDD')||ROWNUM ,
						:LVD_PO_DATE       PURCHASE_ORDER_DATE ,
						A.ORGANIZATION_ID ,  
						NVL(B.SUPPLIER_CODE ,'*' )  SUPPLIER_CODE , // F_GET_MAX_VENDOR_BY_ITEM( A.ITEM_CODE , A.ORGANIZATION_ID ) SUPPLIER_CODE,   
						A.ITEM_CODE , 
						A.DELIVERY_DATE , 
						'' DELIVERY , 
						A.LINE_TYPE ,
						'F'                               ORDER_TYPE,   
						DECODE( B.ORDER_RATE , NULL ,A.ORDER_QTY ,  ( A.ORDER_QTY * B.ORDER_RATE / 100 ) ) ORDER_QTY,
						DECODE( B.ORDER_RATE , NULL ,A.ORDER_QTY ,  ( A.ORDER_QTY * B.ORDER_RATE / 100 ) ) PURCHASE_ORDER_QTY,							
						0 UNIT_PRICE , '*' CURRENCY  , 0  INVENTORY_QTY , 0 ARRIVAL_QTY , 0 PRE_ORDER_QTY ,
						A.MFS ,'N' ,
						NVL(B.PAYMENT_TYPE ,'*') PAYMENT_TYPE , 
						:GVS_USER_ID,   
						SYSDATE,   
						:GVS_USER_ID,   
						SYSDATE,
						SET_ITEM_CODE , PARENT_ITEM_CODE
				FROM   (   SELECT  ORGANIZATION_ID,    
										 ITEM_CODE,   
										 PLAN_DATE   DELIVERY_DATE,   
										 LINE_TYPE,   
										 SUM(REQUIRMENT_QTY) ORDER_QTY,  
										 MFS ,
										 MAX(SET_ITEM_CODE) SET_ITEM_CODE , MAX(PARENT_ITEM_CODE) PARENT_ITEM_CODE
								  FROM IM_ITEM_PURCHASE_REQUIR_ORDER 
								WHERE TRUNC(PLAN_DATE) >= :LVD_DATESET
									AND TRUNC(PLAN_DATE) <= :LVD_DATEEND
									AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM
									                                   WHERE DATESET <= TRUNC(SYSDATE)
																     AND DATEEND >= TRUNC(SYSDATE) 
																     AND NVL(ORDER_RULE,'*' )  LIKE :LVS_ORDER_RULE
									                                     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ) 
									AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
								  GROUP BY MFS , PLAN_DATE , ITEM_CODE  ,LINE_TYPE ,  ORGANIZATION_ID 
							) A , IM_ITEM_MASTER B
						WHERE A.ITEM_CODE            = B.ITEM_CODE(+) 
						    AND A.ORGANIZATION_ID = B.ORGANIZATION_ID(+) 
						    AND B.ORDER_RATE(+) > 0 
						    AND B.ORDER_RATE(+) <= 100 
   				  ORDER BY A.ITEM_CODE ;			 
			end if; //distinct mfs 

		IF F_SQL_CHECK() < 0 THEN
             RETURN
		END IF	 
       
					  LVL_COUNT = SQLCA.SQLNROWS

//=======================================
// $$HEX17$$10d3e4b9c4ac8dd63cc75cb8200080bd30d12000fcc838bb08c615c82000ddc031c1$$ENDHEX$$
//=======================================

ELSEIF tab_1.tabpage_1.RB_FROM_SALE_PLAN.CHECKED = TRUE THEN
	

		if Gvs_sale_division = 'SAMSUNG' then 
			
	      // $$HEX10$$10d3e4b9c4ac8dd6d0c5200000b358d5ecc52000$$ENDHEX$$BOM $$HEX15$$04c81cac20000fbc200084c7dcc220004cd174c714bed0c5200085c725b8$$ENDHEX$$
		 LVI_RETURN = F_GEN_PURCHASE_ORDER_PLAN_BY_SALE_PLAN_BY_TIME( LVD_DATESET , LVD_DATEEND , lvs_set_item_code) ;
		 IF LVI_RETURN < 0 THEN 
			MESSAGEBOX("Error" , lvs_set_item_code+" Can`t  BOM Explosion Check BOM and Retry Again..." )
			ROLLBACK ; 
			RETURN 
		 END IF
	ELSE
		
	      // $$HEX10$$10d3e4b9c4ac8dd6d0c5200000b358d5ecc52000$$ENDHEX$$BOM $$HEX15$$04c81cac20000fbc200084c7dcc220004cd174c714bed0c5200085c725b8$$ENDHEX$$
		 LVI_RETURN = F_GEN_PURCHASE_ORDER_PLAN_BY_SALE_PLAN( LVD_DATESET , LVD_DATEEND ) ;
		 IF LVI_RETURN < 0 THEN 
			MESSAGEBOX("Error" , " Can`t  BOM Explosion" )
			ROLLBACK ; 
			RETURN 
		 END IF		
	END IF 
	 
     	  DELETE FROM IM_ITEM_PURCHASE_ORDER_PLAN WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID  ;
		  
		  IF F_SQL_CHECK() < 0 THEN 
			 RETURN
		  END IF
//==================================================================
//sale plan
//==================================================================
		  IF LVS_DIStinct_mfs_yn = 'Y' then 
			
		  INSERT INTO IM_ITEM_PURCHASE_ORDER_PLAN  
						( ORDER_NO,    PURCHASE_ORDER_DATE,    ORGANIZATION_ID,    SUPPLIER_CODE,   
						  ITEM_CODE,   DELIVERY_DATE,   DELIVERY,   LINE_TYPE,   ORDER_TYPE,   
						  ORDER_QTY,   PURCHASE_ORDER_QTY ,  UNIT_PRICE,    CURRENCY,   
						  INVENTORY_QTY,    ARRIVAL_QTY,    PRE_ORDER_QTY,   
						  MFS,   PURCHASE_ORDER_STATUS ,
						  PAYMENT_TYPE ,
						  ENTER_BY,    ENTER_DATE,    LAST_MODIFY_BY,   LAST_MODIFY_DATE , 
						  SET_ITEM_CODE , PARENT_ITEM_CODE ) 
		
				SELECT   TO_CHAR(A.ORGANIZATION_ID)||TO_CHAR(SYSDATE,'YYMMDD')||ROWNUM ,
						:LVD_PO_DATE       PURCHASE_ORDER_DATE ,
						A.ORGANIZATION_ID ,  
						NVL(B.SUPPLIER_CODE ,'*' )  SUPPLIER_CODE , // F_GET_MAX_VENDOR_BY_ITEM( A.ITEM_CODE , A.ORGANIZATION_ID ) SUPPLIER_CODE,   
						A.ITEM_CODE , 
						A.DELIVERY_DATE , 
						'' DELIVERY , 
						A.LINE_TYPE ,
						'F'                               ORDER_TYPE,   
						DECODE( B.ORDER_RATE , NULL ,A.ORDER_QTY ,  ( A.ORDER_QTY * B.ORDER_RATE / 100 ) ) ORDER_QTY,
						DECODE( B.ORDER_RATE , NULL ,A.ORDER_QTY ,  ( A.ORDER_QTY * B.ORDER_RATE / 100 ) ) PURCHASE_ORDER_QTY,							
						0 UNIT_PRICE , '*' CURRENCY  , 0  INVENTORY_QTY , 0 ARRIVAL_QTY , 0 PRE_ORDER_QTY ,
						A.MFS ,'N' ,
						NVL(B.PAYMENT_TYPE ,'*') PAYMENT_TYPE , 
						:GVS_USER_ID,   
						SYSDATE,   
						:GVS_USER_ID,   
						SYSDATE ,
						SET_ITEM_CODE , PARENT_ITEM_CODE
				FROM   (   SELECT  ORGANIZATION_ID,    
										 ITEM_CODE,   
										 MIN(PLAN_DATE)   DELIVERY_DATE,   
										 LINE_TYPE,   
										 SUM(REQUIRMENT_QTY) ORDER_QTY,  
										 '*' MFS ,
										 MAX(SET_ITEM_CODE) SET_ITEM_CODE , MAX(PARENT_ITEM_CODE) PARENT_ITEM_CODE
								  FROM IM_ITEM_PURCHASE_REQUIR_ORDER 
								WHERE TRUNC(PLAN_DATE) >= :LVD_DATESET
									AND TRUNC(PLAN_DATE) <= :LVD_DATEEND
									AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM
									                                   WHERE DATESET <= TRUNC(SYSDATE)
																     AND DATEEND >= TRUNC(SYSDATE) 
																     AND NVL(ORDER_RULE,'*' )  LIKE :LVS_ORDER_RULE
									                                     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ) 
									AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
								  GROUP BY ITEM_CODE  ,LINE_TYPE ,  ORGANIZATION_ID 
							) A , IM_ITEM_MASTER B
						WHERE A.ITEM_CODE            = B.ITEM_CODE(+) 
						    AND A.ORGANIZATION_ID = B.ORGANIZATION_ID(+) 
						    AND B.ORDER_RATE(+) > 0 
						    AND B.ORDER_RATE(+) <= 100 
   				  ORDER BY A.ITEM_CODE ;		
					  
		  else

		  INSERT INTO IM_ITEM_PURCHASE_ORDER_PLAN  
						( ORDER_NO,    PURCHASE_ORDER_DATE,    ORGANIZATION_ID,    SUPPLIER_CODE,   
						  ITEM_CODE,   DELIVERY_DATE,   DELIVERY,   LINE_TYPE,   ORDER_TYPE,   
						  ORDER_QTY,   PURCHASE_ORDER_QTY ,  UNIT_PRICE,    CURRENCY,   
						  INVENTORY_QTY,    ARRIVAL_QTY,    PRE_ORDER_QTY,   
						  MFS,   PURCHASE_ORDER_STATUS ,
						  PAYMENT_TYPE ,
						  ENTER_BY,    ENTER_DATE,    LAST_MODIFY_BY,   LAST_MODIFY_DATE , SET_ITEM_CODE , PARENT_ITEM_CODE ) 
		
				SELECT   TO_CHAR(A.ORGANIZATION_ID)||TO_CHAR(SYSDATE,'YYMMDD')||ROWNUM ,
						:LVD_PO_DATE       PURCHASE_ORDER_DATE ,
						A.ORGANIZATION_ID ,  
						NVL(B.SUPPLIER_CODE ,'*' )  SUPPLIER_CODE , // F_GET_MAX_VENDOR_BY_ITEM( A.ITEM_CODE , A.ORGANIZATION_ID ) SUPPLIER_CODE,   
						A.ITEM_CODE , 
						A.DELIVERY_DATE , 
						'' DELIVERY , 
						A.LINE_TYPE ,
						'F'                               ORDER_TYPE,   
						DECODE( B.ORDER_RATE , NULL ,A.ORDER_QTY ,  ( A.ORDER_QTY * B.ORDER_RATE / 100 ) ) ORDER_QTY,
						DECODE( B.ORDER_RATE , NULL ,A.ORDER_QTY ,  ( A.ORDER_QTY * B.ORDER_RATE / 100 ) ) PURCHASE_ORDER_QTY,							
						0 UNIT_PRICE , '*' CURRENCY  , 0  INVENTORY_QTY , 0 ARRIVAL_QTY , 0 PRE_ORDER_QTY ,
						A.MFS ,'N' ,
						NVL(B.PAYMENT_TYPE ,'*') PAYMENT_TYPE , 
						:GVS_USER_ID,   
						SYSDATE,   
						:GVS_USER_ID,   
						SYSDATE,
						SET_ITEM_CODE , PARENT_ITEM_CODE
				FROM   (   SELECT  ORGANIZATION_ID,    
										 ITEM_CODE,   
										 PLAN_DATE   DELIVERY_DATE,   
										 LINE_TYPE,   
										 SUM(REQUIRMENT_QTY) ORDER_QTY,  
										 MFS ,
										 MAX(SET_ITEM_CODE) SET_ITEM_CODE , MAX(PARENT_ITEM_CODE) PARENT_ITEM_CODE
								  FROM IM_ITEM_PURCHASE_REQUIR_ORDER 
								WHERE TRUNC(PLAN_DATE) >= :LVD_DATESET
									AND TRUNC(PLAN_DATE) <= :LVD_DATEEND
									AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM
									                                   WHERE DATESET <= TRUNC(SYSDATE)
																     AND DATEEND >= TRUNC(SYSDATE) 
																     AND NVL(ORDER_RULE,'*' )  LIKE :LVS_ORDER_RULE
									                                     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ) 
									AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
								  GROUP BY MFS , PLAN_DATE , ITEM_CODE  ,LINE_TYPE ,  ORGANIZATION_ID 
							) A , IM_ITEM_MASTER B
						WHERE A.ITEM_CODE            = B.ITEM_CODE(+) 
						    AND A.ORGANIZATION_ID = B.ORGANIZATION_ID(+) 
						    AND B.ORDER_RATE(+) > 0 
						    AND B.ORDER_RATE(+) <= 100 
   				  ORDER BY A.ITEM_CODE ;			 
			end if; //distinct mfs 

		IF F_SQL_CHECK() < 0 THEN
             RETURN
		END IF	 
       
					  LVL_COUNT = SQLCA.SQLNROWS
						
//=======================================
// $$HEX16$$ddc0b0c08dd63cc75cb8200080bd30d12000fcc838bb08c615c82000ddc031c1$$ENDHEX$$
//=======================================
ELSEIF tab_1.tabpage_1.RB_FROM_MASTER_PLAN.CHECKED = TRUE THEN

		if Gvs_sale_division = 'SAMSUNG' then 
	
				// $$HEX10$$ddc0b0c0c4ac8dd6d0c5200000b358d5ecc52000$$ENDHEX$$BOM $$HEX15$$04c81cac20000fbc200084c7dcc220004cd174c714bed0c5200085c725b8$$ENDHEX$$
			 LVI_RETURN = F_GEN_PURCHASE_ORDER_PLAN_BY_PROD_PLAN_BY_TIME( LVD_DATESET , LVD_DATEEND , lvs_set_item_code , LVS_LINE_CODE) ;
			 IF LVI_RETURN <= 0 THEN 
				MESSAGEBOX("Error" , " Can`t  BOM Explosion" )
				ROLLBACK ; 
				RETURN 
			 END IF
		 
		else
			
				// $$HEX10$$ddc0b0c0c4ac8dd6d0c5200000b358d5ecc52000$$ENDHEX$$BOM $$HEX15$$04c81cac20000fbc200084c7dcc220004cd174c714bed0c5200085c725b8$$ENDHEX$$
			 LVI_RETURN = F_GEN_PURCHASE_ORDER_PLAN_BY_PROD_PLAN( LVD_DATESET , LVD_DATEEND ) ;
			 IF LVI_RETURN <= 0 THEN 
				MESSAGEBOX("Error" , " Can`t  BOM Explosion" )
				ROLLBACK ; 
				RETURN 
			 END IF			
		
		end if 
	             //$$HEX12$$fcc838bb08c615c844c72000adc01cc820005cd5e4b22000$$ENDHEX$$
     	         DELETE FROM IM_ITEM_PURCHASE_ORDER_PLAN WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID  ;
		  
		  IF F_SQL_CHECK() < 0 THEN 
			 RETURN
		  END IF
		  
		  
		  
		  if lvs_distinct_mfs_yn = 'Y' then 
			
					  INSERT INTO IM_ITEM_PURCHASE_ORDER_PLAN  
									( ORDER_NO,    PURCHASE_ORDER_DATE,    ORGANIZATION_ID,    SUPPLIER_CODE,   
									  ITEM_CODE,   DELIVERY_DATE,   DELIVERY,   LINE_TYPE,   ORDER_TYPE,   
									  ORDER_QTY,   PURCHASE_ORDER_QTY ,  UNIT_PRICE,    CURRENCY,   
									  INVENTORY_QTY,    ARRIVAL_QTY,    PRE_ORDER_QTY,   
									  MFS,   PURCHASE_ORDER_STATUS ,
									  PAYMENT_TYPE ,
									  ENTER_BY,    ENTER_DATE,    LAST_MODIFY_BY,   LAST_MODIFY_DATE ,
									  SET_ITEM_CODE , PARENT_ITEM_CODE) 
					
							SELECT   TO_CHAR(A.ORGANIZATION_ID)||TO_CHAR(SYSDATE,'YYMMDD')||ROWNUM ,
										:LVD_PO_DATE       PURCHASE_ORDER_DATE ,
										A.ORGANIZATION_ID ,  
										NVL(B.SUPPLIER_CODE ,'*' )  SUPPLIER_CODE , // F_GET_MAX_VENDOR_BY_ITEM( A.ITEM_CODE , A.ORGANIZATION_ID ) SUPPLIER_CODE,   
										A.ITEM_CODE , 
										A.DELIVERY_DATE , 
										 '' DELIVERY , 
										A.LINE_TYPE ,
										'F'                               ORDER_TYPE,   
										DECODE( B.ORDER_RATE , NULL ,A.ORDER_QTY ,  ( A.ORDER_QTY * B.ORDER_RATE / 100 ) ) ORDER_QTY,
										DECODE( B.ORDER_RATE , NULL ,A.ORDER_QTY ,  ( A.ORDER_QTY * B.ORDER_RATE / 100 ) ) PURCHASE_ORDER_QTY,							
										0 UNIT_PRICE , '*' CURRENCY  , 0  INVENTORY_QTY , 0 ARRIVAL_QTY , 0 PRE_ORDER_QTY ,
										A.MFS ,'N' ,
										  NVL(B.PAYMENT_TYPE ,'*') PAYMENT_TYPE , 
										 :GVS_USER_ID,   
										 SYSDATE,   
										 :GVS_USER_ID,   
										 SYSDATE ,
										 SET_ITEM_CODE , PARENT_ITEM_CODE
							FROM   (   SELECT  ORGANIZATION_ID,    
													 ITEM_CODE,   
													 MIN(PLAN_DATE)   DELIVERY_DATE,   
													 LINE_TYPE,   
													 SUM(REQUIRMENT_QTY) ORDER_QTY,  
													 '*' MFS ,
													 MAX(SET_ITEM_CODE) SET_ITEM_CODE , MAX(PARENT_ITEM_CODE) PARENT_ITEM_CODE
											  FROM IM_ITEM_PURCHASE_REQUIR_ORDER 
											WHERE TRUNC(PLAN_DATE) >= :LVD_DATESET
									AND TRUNC(PLAN_DATE) <= :LVD_DATEEND
												AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM
																							  WHERE DATESET <= TRUNC(SYSDATE)
																			AND DATEEND >= TRUNC(SYSDATE) 
																			AND NVL(ORDER_RULE,'*' )  LIKE :LVS_ORDER_RULE
																									AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ) 
												AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
											  GROUP BY  ITEM_CODE  ,LINE_TYPE ,  ORGANIZATION_ID 
										) A , IM_ITEM_MASTER B
									WHERE A.ITEM_CODE            = B.ITEM_CODE(+) 
										 AND A.ORGANIZATION_ID = B.ORGANIZATION_ID(+) 
										 AND B.ORDER_RATE(+) > 0 
										 AND B.ORDER_RATE(+) <= 100 
								  ORDER BY A.ITEM_CODE ;				
			
		  else

					  INSERT INTO IM_ITEM_PURCHASE_ORDER_PLAN  
									( ORDER_NO,    PURCHASE_ORDER_DATE,    ORGANIZATION_ID,    SUPPLIER_CODE,   
									  ITEM_CODE,   DELIVERY_DATE,   DELIVERY,   LINE_TYPE,   ORDER_TYPE,   
									  ORDER_QTY,   PURCHASE_ORDER_QTY ,  UNIT_PRICE,    CURRENCY,   
									  INVENTORY_QTY,    ARRIVAL_QTY,    PRE_ORDER_QTY,   
									  MFS,   PURCHASE_ORDER_STATUS ,
									  PAYMENT_TYPE ,
									  ENTER_BY,    ENTER_DATE,    LAST_MODIFY_BY,   LAST_MODIFY_DATE,
									  SET_ITEM_CODE , PARENT_ITEM_CODE) 
					
							SELECT   TO_CHAR(A.ORGANIZATION_ID)||TO_CHAR(SYSDATE,'YYMMDD')||ROWNUM ,
										:LVD_PO_DATE       PURCHASE_ORDER_DATE ,
										A.ORGANIZATION_ID ,  
										NVL(B.SUPPLIER_CODE ,'*' )  SUPPLIER_CODE , // F_GET_MAX_VENDOR_BY_ITEM( A.ITEM_CODE , A.ORGANIZATION_ID ) SUPPLIER_CODE,   
										A.ITEM_CODE , 
										A.DELIVERY_DATE , 
										 '' DELIVERY , 
										A.LINE_TYPE ,
										'F'                               ORDER_TYPE,   
										DECODE( B.ORDER_RATE , NULL ,A.ORDER_QTY ,  ( A.ORDER_QTY * B.ORDER_RATE / 100 ) ) ORDER_QTY,
										DECODE( B.ORDER_RATE , NULL ,A.ORDER_QTY ,  ( A.ORDER_QTY * B.ORDER_RATE / 100 ) ) PURCHASE_ORDER_QTY,							
										0 UNIT_PRICE , '*' CURRENCY  , 0  INVENTORY_QTY , 0 ARRIVAL_QTY , 0 PRE_ORDER_QTY ,
										A.MFS ,'N' ,
										  NVL(B.PAYMENT_TYPE ,'*') PAYMENT_TYPE , 
										 :GVS_USER_ID,   
										 SYSDATE,   
										 :GVS_USER_ID,   
										 SYSDATE,
										 SET_ITEM_CODE , PARENT_ITEM_CODE
							FROM   (   SELECT  ORGANIZATION_ID,    
													 ITEM_CODE,   
													 PLAN_DATE   DELIVERY_DATE,   
													 LINE_TYPE,   
													 SUM(REQUIRMENT_QTY) ORDER_QTY,  
													 MFS,
													 MAX(SET_ITEM_CODE) SET_ITEM_CODE , MAX(PARENT_ITEM_CODE) PARENT_ITEM_CODE
											  FROM IM_ITEM_PURCHASE_REQUIR_ORDER 
											WHERE TRUNC(PLAN_DATE) >= :LVD_DATESET
									AND TRUNC(PLAN_DATE) <= :LVD_DATEEND
												AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM
																	     WHERE DATESET <= TRUNC(SYSDATE)
																			AND DATEEND >= TRUNC(SYSDATE) 
																			AND NVL(ORDER_RULE,'*' )  LIKE :LVS_ORDER_RULE
																			AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ) 
												AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
											  GROUP BY MFS  , PLAN_DATE ,  ITEM_CODE  ,LINE_TYPE ,  ORGANIZATION_ID 
										) A , IM_ITEM_MASTER B
									WHERE A.ITEM_CODE            = B.ITEM_CODE(+) 
										 AND A.ORGANIZATION_ID = B.ORGANIZATION_ID(+) 
										 AND B.ORDER_RATE(+) > 0 
										 AND B.ORDER_RATE(+) <= 100 
								  ORDER BY A.ITEM_CODE ;		
					  
				end if  //distinct mfs 
					  
					  
		  
		IF F_SQL_CHECK() < 0 THEN
			RETURN
		END IF	 
                  LVL_COUNT = SQLCA.SQLNROWS						
END IF

//================================================================
open(w_progress_popup)
w_progress_popup.f_set_range( 0 , LVL_COUNT )
w_progress_popup.f_setstep(1)

OPEN CL_PLAN ;
DO
FETCH  CL_PLAN INTO :LVS_SUPPLIER_CODE , :LVS_ITEM_CODE , :LVS_LINE_TYPE , :LVF_ORDER_PLAN_QTY  , :LVS_ROWID ;
			IF F_SQL_CHECK() < 0 THEN 
				CLOSE CL_PLAN ;
				EXIT
			END IF

             IF SQLCA.SQLCODE = 100 THEN 
			   CLOSE CL_PLAN ;
			   EXIT
			END IF

I++
w_progress_popup.f_STEPIT()
//=======================================
// $$HEX7$$fcc838bb18c2c9b7200010ac48c5$$ENDHEX$$
//=======================================
	IF tab_1.tabpage_2.cbx_apply_inventory_qty.checked  = TRUE THEN 
	
			OPEN CL_INV ;
			DO
				
			LVF_INV_QTY = 0 ;	LVS_INV_ROWID = ''
			FETCH CL_INV INTO :LVF_INV_QTY ,  :LVS_INV_ROWID ;
					  IF F_SQL_CHECK() < 0 THEN 
						CLOSE CL_INV ;CLOSE CL_PLAN ;
						EXIT
					  END IF
					  
					  IF SQLCA.SQLCODE = 100 THEN 					  
						LVS_NOT_FOUND = 'Y'
					ELSE
						LVS_NOT_FOUND = 'N'
					END IF
		
                    	  //==================================================
			         //$$HEX13$$fcc838bb08c615c874c72000acc7e0acf4bce4b220006cd074ba$$ENDHEX$$
				  //==================================================
					IF LVF_ORDER_PLAN_QTY >  LVF_INV_QTY  THEN    
					
					    LVF_ORDER_PLAN_QTY = LVF_ORDER_PLAN_QTY - LVF_INV_QTY 					

					        IF TAB_1.TABPAGE_2.cbx_apply_auto_order_rule.CHECKED = TRUE THEN 
						      LVF_PURCHASE_ORDER_CALC_QTY = 0 ; 
						

							LVF_PURCHASE_ORDER_CALC_QTY =  F_GET_ORDER_PROPERTY( LVS_SUPPLIER_CODE , LVS_ITEM_CODE,  LVF_ORDER_PLAN_QTY , 'A' )	  
							IF LVF_PURCHASE_ORDER_CALC_QTY < 0 THEN 
								MESSAGEBOX("Error" , "Order Property Apply Error")
								CLOSE CL_INV ;CLOSE CL_PLAN ;
								RETURN
							END IF
							
							LVF_PURCHASE_ORDER_CALC_QTY =    LVF_PURCHASE_ORDER_CALC_QTY - LVF_ORDER_PLAN_QTY ;
							
						ELSE
							  LVF_PURCHASE_ORDER_CALC_QTY = 0
						END IF										
														
						UPDATE IM_ITEM_INVENTORY_GEN SET INVENTORY_QTY = :LVF_PURCHASE_ORDER_CALC_QTY
						  WHERE ROWID = :LVS_INV_ROWID ;
						   IF F_SQL_CHECK() < 0 THEN 
      						  CLOSE CL_INV ;CLOSE CL_PLAN ;
						       RETURN 
						   END IF
							
						 UPDATE IM_ITEM_PURCHASE_ORDER_PLAN
						       SET ORDER_NO =  'TA'||TO_CHAR(SYSDATE,'YYMMDD')||SEQ_ORDER_NO.NEXTVAL,
								INVENTORY_QTY =  	INVENTORY_QTY + :LVF_INV_QTY,
								TOTAL_INVENTORY_QTY = :LVF_INV_QTY ,
								PURCHASE_ORDER_QTY = :LVF_PURCHASE_ORDER_CALC_QTY + :LVF_ORDER_PLAN_QTY
						   WHERE ROWID = :LVS_ROWID ;
						   IF F_SQL_CHECK() < 0 THEN 
						       CLOSE CL_INV ;CLOSE CL_PLAN ;
						       RETURN 
						   END IF							
							
                     //=================================================================					   		  							
			 //$$HEX16$$fcc838bb08c615c874c7200091c770ac98b0200019ac3cc774ba090009000900$$ENDHEX$$
                     //=================================================================					   		  
					ELSEIF  LVF_ORDER_PLAN_QTY <=  LVF_INV_QTY  THEN 
						
		
						UPDATE IM_ITEM_INVENTORY_GEN 
						      SET INVENTORY_QTY =  INVENTORY_QTY - :LVF_ORDER_PLAN_QTY
						  WHERE ROWID = :LVS_INV_ROWID ;
						  
						   IF F_SQL_CHECK() < 0 THEN 
						       CLOSE CL_INV ;CLOSE CL_PLAN ;
						       RETURN 
						   END IF						
						
						 UPDATE IM_ITEM_PURCHASE_ORDER_PLAN
						       SET ORDER_NO = 'TA'||TO_CHAR(SYSDATE,'YYMMDD')||SEQ_ORDER_NO.NEXTVAL ,
								     INVENTORY_QTY =  	INVENTORY_QTY + :LVF_ORDER_PLAN_QTY ,
								     TOTAL_INVENTORY_QTY = :LVF_INV_QTY ,
    									 PURCHASE_ORDER_QTY =  0 
						   WHERE ROWID = :LVS_ROWID ;
						   IF F_SQL_CHECK() < 0 THEN 
						      CLOSE CL_INV ;CLOSE CL_PLAN ;
						       RETURN 
						   END IF								
						
						   LVF_ORDER_PLAN_QTY = 0  
						   CLOSE CL_INV ;
						  EXIT
						  
					END IF
				
				      IF LVS_NOT_FOUND = 'Y' then
						IF  J = 0 THEN 
						//	MESSAGEBOX("Notify" , "Inventory Data Not Found "+lvs_item_code )
						END IF 
						CLOSE CL_INV ;
						EXIT
					  END IF				
	J++				
				
			LOOP UNTIL 1 = 2 // $$HEX6$$acc7e0ac15c8f4bce4ce1cc1$$ENDHEX$$
			
	END IF
	
	F_MSG_MDI_HELP( STRING(I)+" Rows Processed!" )

LOOP UNTIL 1 = 2  //$$HEX7$$fcc838bb08c615c82000e4ce1cc1$$ENDHEX$$
close(w_progress_popup)

//==================================================
// $$HEX9$$1cc870c8acb9dcb4c0d084c7200024c115c8$$ENDHEX$$
//==================================================
if tab_1.tabpage_2.cbx_apply_leadtime.checked = true then 
	F_MSG_MDI_HELP( STRING(I)+"Set Manufacture Leadtime...")
	UPDATE IM_ITEM_PURCHASE_ORDER_PLAN A
	      SET A.DELIVERY_DATE 
			= (    SELECT A.DELIVERY_DATE  - NVL( B.MANUFACTURE_LEADTIME , 0) 
				 	 FROM ID_ITEM B
					WHERE A.ITEM_CODE = B.ITEM_CODE
						AND B.DATESET <= TRUNC(SYSDATE)
						AND B.DATEEND >= TRUNC(SYSDATE)
						AND A.ORGANIZATION_ID = B.ORGANIZATION_ID
						AND A.ORGANIZATION_ID = :GVI_ORGANIZATION_ID
						AND B.ORGANIZATION_ID = :GVI_ORGANIZATION_ID
				         AND A.PURCHASE_ORDER_DATE = :LVD_PO_DATE
				  )
   WHERE ( A.ITEM_CODE , A.ORGANIZATION_ID )
	     IN  (  SELECT  B.ITEM_CODE ,  B.ORGANIZATION_ID 
				  FROM  ID_ITEM B
	 		     WHERE  A.ITEM_CODE = B.ITEM_CODE
					AND B.DATESET <= TRUNC(SYSDATE)
					AND B.DATEEND >= TRUNC(SYSDATE)
					AND A.ORGANIZATION_ID = B.ORGANIZATION_ID
					AND A.ORGANIZATION_ID = :GVI_ORGANIZATION_ID
					AND B.ORGANIZATION_ID = :GVI_ORGANIZATION_ID
					 AND A.PURCHASE_ORDER_DATE = :LVD_PO_DATE
	             ) 
       AND A.PURCHASE_ORDER_DATE = :LVD_PO_DATE
	  AND A.ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;					 	
   IF F_SQL_CHECK() < 0 THEN 
	  RETURN 
   END IF	
end if
//===================================================
//$$HEX4$$d4c625b801c8a9c6$$ENDHEX$$
//===================================================
if tab_1.tabpage_2.cbx_apply_calendar.checked = true then 
	
	F_MSG_MDI_HELP( STRING(I)+"Set Work Calendar...")	
	UPDATE IM_ITEM_PURCHASE_ORDER_PLAN
		 SET DELIVERY_DATE = NVL(F_GET_DELIVERY_DATE( DELIVERY_DATE , ORGANIZATION_ID) , PURCHASE_ORDER_DATE -1 )
	WHERE PURCHASE_ORDER_STATUS = 'N' 
		  AND PURCHASE_ORDER_DATE = :LVD_PO_DATE
		  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;		 
			  
	IF F_SQL_CHECK() < 0 THEN
		RETURN
	END IF
end if	  

IF tab_1.tabpage_2.CBX_APPLY_UNIT_PRICE.CHECKED = TRUE THEN 

	F_MSG_MDI_HELP(STRING(I)+"Unit Price Reset"	)
	UPDATE IM_ITEM_PURCHASE_ORDER_PLAN A
	      SET ( A.DELIVERY , A.UNIT_PRICE , A.CURRENCY ) 
			= ( 
					SELECT DELIVERY , UNIT_PRICE , CURRENCY  
		  			  FROM IM_ITEM_UNIT_PRICE B
					WHERE A.SUPPLIER_CODE = B.SUPPLIER_CODE
						AND A.ITEM_CODE = B.ITEM_CODE
						AND A.LINE_TYPE  = B.LINE_TYPE
						AND B.DATESET <= TRUNC(SYSDATE)
						AND B.DATEEND >= TRUNC(SYSDATE)
						AND A.ORGANIZATION_ID = B.ORGANIZATION_ID
				  )
   WHERE ( A.SUPPLIER_CODE , A.ITEM_CODE , A.LINE_TYPE , A.ORGANIZATION_ID )
	     IN  (  SELECT B.SUPPLIER_CODE , B.ITEM_CODE ,B.LINE_TYPE ,  B.ORGANIZATION_ID 
		           FROM IM_ITEM_UNIT_PRICE B
				WHERE A.SUPPLIER_CODE = B.SUPPLIER_CODE
					AND A.ITEM_CODE         = B.ITEM_CODE	  
					AND A.LINE_TYPE           = B.LINE_TYPE
					AND B.DATESET            <= TRUNC(SYSDATE)
					AND B.DATEEND            >= TRUNC(SYSDATE)
					AND A.ORGANIZATION_ID = B.ORGANIZATION_ID
	             ) 
       AND PURCHASE_ORDER_DATE = :LVD_PO_DATE
	  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;					 		 
END IF

   IF F_SQL_CHECK() < 0 THEN 
	  RETURN 
   END IF		
	
//======================================
//$$HEX10$$fcc838bb18c2c9b720002cc6bcb998ccacb92000$$ENDHEX$$
//======================================
if tab_1.tabpage_2.cbx_round.checked = true then 
		UPDATE IM_ITEM_PURCHASE_ORDER_PLAN 
			  SET  PURCHASE_ORDER_QTY = ROUND(PURCHASE_ORDER_QTY,4),
					  ORDER_QTY = ROUND(ORDER_QTY,4)
		 WHERE PURCHASE_ORDER_STATUS = 'N' 
			  AND PURCHASE_ORDER_DATE = :LVD_PO_DATE
			  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
		
			IF F_SQL_CHECK() < 0 THEN 
			  RETURN 
			END IF		
end if 
//======================================
//$$HEX11$$fcc838bb08c615c82000c1c0dcd02000c0bcbdac2000$$ENDHEX$$
//======================================
UPDATE IM_ITEM_PURCHASE_ORDER_PLAN 
      SET PURCHASE_ORDER_STATUS = 'P' 
 WHERE PURCHASE_ORDER_STATUS = 'N' 
     AND DELIVERY IS NULL
	AND PURCHASE_ORDER_DATE = :LVD_PO_DATE
     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;

   IF F_SQL_CHECK() < 0 THEN 
	  RETURN 
   END IF	
//=======================================	
COMMIT ;
IF I = 0 THEN 
     F_MSGBOX(9026) //$$HEX13$$c0bcbdac1cb4200090c7ccb800ac2000c6c5b5c2c8b2e4b20900$$ENDHEX$$
	  messagebox("1" , LVS_ORDER_RULE )
ELSE
	cb_price_reset.triggerevent(clicked!)
	F_MSGBOX(170) // $$HEX25$$74d5f9b2200090c7ccb800ac200031c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b20900090009002000$$ENDHEX$$
END IF
end event

type tabpage_2 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 4315
integer height = 152
long backcolor = 15780518
string text = "Option"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Options!"
long picturemaskcolor = 536870912
cbx_apply_leadtime cbx_apply_leadtime
cbx_distinct_mfs cbx_distinct_mfs
cbx_outside_inv cbx_outside_inv
cbx_apply_workstage_inventory_qty cbx_apply_workstage_inventory_qty
cbx_apply_calendar cbx_apply_calendar
cbx_round cbx_round
cbx_apply_auto_order_rule cbx_apply_auto_order_rule
cbx_apply_inventory_qty cbx_apply_inventory_qty
cbx_apply_unit_price cbx_apply_unit_price
cbx_apply_arrival_qty cbx_apply_arrival_qty
cbx_apply_order_qty cbx_apply_order_qty
end type

on tabpage_2.create
this.cbx_apply_leadtime=create cbx_apply_leadtime
this.cbx_distinct_mfs=create cbx_distinct_mfs
this.cbx_outside_inv=create cbx_outside_inv
this.cbx_apply_workstage_inventory_qty=create cbx_apply_workstage_inventory_qty
this.cbx_apply_calendar=create cbx_apply_calendar
this.cbx_round=create cbx_round
this.cbx_apply_auto_order_rule=create cbx_apply_auto_order_rule
this.cbx_apply_inventory_qty=create cbx_apply_inventory_qty
this.cbx_apply_unit_price=create cbx_apply_unit_price
this.cbx_apply_arrival_qty=create cbx_apply_arrival_qty
this.cbx_apply_order_qty=create cbx_apply_order_qty
this.Control[]={this.cbx_apply_leadtime,&
this.cbx_distinct_mfs,&
this.cbx_outside_inv,&
this.cbx_apply_workstage_inventory_qty,&
this.cbx_apply_calendar,&
this.cbx_round,&
this.cbx_apply_auto_order_rule,&
this.cbx_apply_inventory_qty,&
this.cbx_apply_unit_price,&
this.cbx_apply_arrival_qty,&
this.cbx_apply_order_qty}
end on

on tabpage_2.destroy
destroy(this.cbx_apply_leadtime)
destroy(this.cbx_distinct_mfs)
destroy(this.cbx_outside_inv)
destroy(this.cbx_apply_workstage_inventory_qty)
destroy(this.cbx_apply_calendar)
destroy(this.cbx_round)
destroy(this.cbx_apply_auto_order_rule)
destroy(this.cbx_apply_inventory_qty)
destroy(this.cbx_apply_unit_price)
destroy(this.cbx_apply_arrival_qty)
destroy(this.cbx_apply_order_qty)
end on

type cbx_apply_leadtime from so_checkbox within tabpage_2
integer x = 3493
integer y = 88
integer width = 517
integer height = 64
boolean bringtotop = true
integer weight = 700
long textcolor = 0
long backcolor = 15780518
string text = "Apply Lead Time"
end type

type cbx_distinct_mfs from so_checkbox within tabpage_2
integer x = 2025
integer y = 96
integer width = 699
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 0
long backcolor = 15780518
string text = "Distinct MFS / Plan Date"
boolean checked = true
end type

type cbx_outside_inv from so_checkbox within tabpage_2
integer x = 1243
integer y = 80
integer width = 695
integer height = 68
integer weight = 700
long backcolor = 15780518
string text = "Apply Outside Inv"
end type

type cbx_apply_workstage_inventory_qty from so_checkbox within tabpage_2
integer x = 1243
integer y = 16
integer width = 695
integer height = 68
integer weight = 700
long backcolor = 15780518
string text = "Apply Workstage Inv"
end type

type cbx_apply_calendar from so_checkbox within tabpage_2
integer x = 2843
integer y = 84
integer width = 517
integer height = 64
boolean bringtotop = true
integer weight = 700
long textcolor = 0
long backcolor = 15780518
string text = "Apply Calendar"
end type

type cbx_round from so_checkbox within tabpage_2
integer x = 2025
integer y = 16
integer width = 654
integer height = 64
boolean bringtotop = true
integer weight = 700
long textcolor = 0
long backcolor = 15780518
string text = "Apply Round"
boolean checked = true
end type

type cbx_apply_auto_order_rule from so_checkbox within tabpage_2
integer x = 2843
integer y = 8
integer width = 654
integer height = 64
boolean bringtotop = true
integer weight = 700
long textcolor = 0
long backcolor = 15780518
string text = "Apply Auto Order Rule"
boolean checked = true
end type

type cbx_apply_inventory_qty from so_checkbox within tabpage_2
integer x = 590
integer y = 16
integer width = 608
integer height = 64
boolean bringtotop = true
integer weight = 700
long textcolor = 0
long backcolor = 15780518
string text = "Apply Inventory Qty"
boolean checked = true
end type

type cbx_apply_unit_price from so_checkbox within tabpage_2
integer x = 590
integer y = 76
integer width = 521
integer height = 64
boolean bringtotop = true
integer weight = 700
long textcolor = 0
long backcolor = 15780518
string text = "Apply Unit Price"
end type

type cbx_apply_arrival_qty from so_checkbox within tabpage_2
integer x = 9
integer y = 76
integer width = 512
integer height = 64
boolean bringtotop = true
integer weight = 700
long textcolor = 0
long backcolor = 15780518
string text = "Apply Arrival Qty"
end type

type cbx_apply_order_qty from so_checkbox within tabpage_2
integer x = 9
integer y = 16
integer width = 512
integer height = 64
boolean bringtotop = true
integer weight = 700
long textcolor = 0
long backcolor = 15780518
string text = "Apply Order Qty"
end type

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 4315
integer height = 152
long backcolor = 12632256
string text = "Show BOM"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "TreeView!"
long picturemaskcolor = 536870912
cb_6 cb_6
cb_5 cb_5
end type

on tabpage_4.create
this.cb_6=create cb_6
this.cb_5=create cb_5
this.Control[]={this.cb_6,&
this.cb_5}
end on

on tabpage_4.destroy
destroy(this.cb_6)
destroy(this.cb_5)
end on

type cb_6 from so_commandbutton within tabpage_4
integer x = 457
integer y = 24
integer width = 466
integer height = 116
integer taborder = 70
string text = "Show Inventory"
end type

event clicked;call super::clicked;if dw_2.getrow() < 1 then 
	openwithparm( w_mat_item_inventory_popup , '%' )	
else
	openwithparm( w_mat_item_inventory_popup , string(dw_2.object.item_code[dw_2.getrow()]) )
end if
end event

type cb_5 from so_commandbutton within tabpage_4
integer x = 14
integer y = 24
integer width = 425
integer height = 112
integer taborder = 10
boolean bringtotop = true
string text = "Show BOM"
end type

event clicked;string lvs_item_code

if rb_product_sale_plan.checked = true then

	if dw_3.getrow() < 1 then return

	lvs_item_code = dw_3.getitemstring( dw_3.getrow() , 'item_code' )
	if lvs_item_code = '' or isnull(lvs_item_code) then return
	
	openwithparm( w_des_bom_query_popup , lvs_item_code )
	
elseif rb_product_master_plan.checked = true then 
	
	if dw_4.getrow() < 1 then return
	
	lvs_item_code = dw_4.getitemstring( dw_4.getrow() , 'item_code' )
	if lvs_item_code = '' or isnull(lvs_item_code) then return
	
	openwithparm( w_des_bom_query_popup , lvs_item_code )
	
end if
end event

type uo_generate_dateend from uo_ymd_calendar within w_mat_purchase_order_plan_master
event destroy ( )
integer x = 4297
integer y = 156
integer taborder = 120
boolean bringtotop = true
end type

on uo_generate_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_plan_date from so_statictext within w_mat_purchase_order_plan_master
integer x = 3904
integer y = 80
integer width = 814
integer height = 64
boolean bringtotop = true
boolean enabled = false
string text = "Plan Date"
end type

type uo_generate_dateset from uo_ymd_calendar within w_mat_purchase_order_plan_master
event destroy ( )
integer x = 3886
integer y = 156
integer taborder = 130
boolean bringtotop = true
end type

on uo_generate_dateset.destroy
call uo_ymd_calendar::destroy
end on

type rb_gen_po from so_radiobutton within w_mat_purchase_order_plan_master
integer x = 1166
integer y = 80
integer width = 448
integer height = 64
boolean bringtotop = true
string text = "Generate PO"
boolean checked = true
end type

event clicked;call super::clicked;tab_1.tabpage_1.cb_gen_do.enabled = false
tab_1.tabpage_1.cb_purchase_do.enabled = false
tab_1.tabpage_1.cb_gen_po.enabled = true
tab_1.tabpage_1.cb_purchase_po.enabled = true
end event

type rb_gen_do from so_radiobutton within w_mat_purchase_order_plan_master
integer x = 1166
integer y = 184
integer width = 448
integer height = 64
boolean bringtotop = true
string text = "Generate DO"
end type

event clicked;call super::clicked;tab_1.tabpage_1.cb_gen_do.enabled = true
tab_1.tabpage_1.cb_purchase_do.enabled = true
tab_1.tabpage_1.cb_gen_po.enabled = false
tab_1.tabpage_1.cb_purchase_po.enabled = false

tab_1.tabpage_1.rb_from_sale_plan.checked = true 
end event

type rb_product_sale_plan from so_radiobutton within w_mat_purchase_order_plan_master
integer x = 553
integer y = 52
integer width = 553
integer height = 64
boolean bringtotop = true
long textcolor = 0
string text = "Product Sale Plan"
end type

event clicked;DW_3.BRINGTOTOP = TRUE
SELECTED_DATA_WINDOW = DW_3

IF rb_order_plan_list.CHECKED = TRUE THEN
	f_menu_control('DATA_CONTROL_DELETE' , TRUE)  // $$HEX6$$adc01cc8ccb9200000aca5b2$$ENDHEX$$
ELSEIF rb_manual_plan.checked = TRUE then 
	f_menu_control('DATA_CONTROL' , TRUE) 
ELSE
	f_menu_control('DATA_CONTROL' , FALSE) 
END IF
end event

type rb_product_master_plan from so_radiobutton within w_mat_purchase_order_plan_master
integer x = 553
integer y = 132
integer width = 553
integer height = 64
boolean bringtotop = true
long textcolor = 0
string text = "Product Master Plan"
end type

event clicked;DW_4.BRINGTOTOP = TRUE
SELECTED_DATA_WINDOW = DW_4

IF rb_order_plan_list.CHECKED = TRUE THEN
	f_menu_control('DATA_CONTROL_DELETE' , TRUE)  // $$HEX6$$adc01cc8ccb9200000aca5b2$$ENDHEX$$
ELSEIF rb_manual_plan.checked = TRUE then 
	f_menu_control('DATA_CONTROL' , TRUE) 
ELSE
	f_menu_control('DATA_CONTROL' , FALSE) 
END IF
end event

type st_2 from so_statictext within w_mat_purchase_order_plan_master
integer x = 2135
integer y = 84
integer width = 809
integer height = 64
boolean bringtotop = true
boolean enabled = false
string text = "Model Name"
end type

type ddlb_line_code from uo_line_code within w_mat_purchase_order_plan_master
integer x = 3447
integer y = 156
integer width = 434
integer height = 2156
integer taborder = 170
boolean bringtotop = true
end type

type st_4 from so_statictext within w_mat_purchase_order_plan_master
integer x = 3447
integer y = 76
integer width = 434
integer height = 64
boolean bringtotop = true
boolean enabled = false
string text = "Line Code"
end type

type rb_manual_plan from so_radiobutton within w_mat_purchase_order_plan_master
integer x = 553
integer y = 216
integer width = 553
integer height = 64
boolean bringtotop = true
long textcolor = 0
string text = "Product Manual Plan"
end type

event clicked;call super::clicked;DW_5.BRINGTOTOP = TRUE
SELECTED_DATA_WINDOW = DW_5

IF rb_order_plan_list.CHECKED = TRUE THEN
	f_menu_control('DATA_CONTROL_DELETE' , TRUE)  // $$HEX6$$adc01cc8ccb9200000aca5b2$$ENDHEX$$
ELSEIF rb_manual_plan.checked = TRUE then 
	f_menu_control('DATA_CONTROL' , TRUE) 
ELSE
	f_menu_control('DATA_CONTROL' , FALSE) 
END IF
end event

type ddlb_model_name from uo_set_model_name_ddlb within w_mat_purchase_order_plan_master
integer x = 2135
integer y = 156
integer taborder = 170
boolean bringtotop = true
end type

type gb_where_condition from so_groupbox within w_mat_purchase_order_plan_master
integer x = 1655
integer width = 3086
integer height = 308
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_1 from so_groupbox within w_mat_purchase_order_plan_master
integer width = 1129
integer height = 308
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_3 from so_groupbox within w_mat_purchase_order_plan_master
integer x = 1143
integer width = 507
integer height = 308
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Generate Option"
end type

