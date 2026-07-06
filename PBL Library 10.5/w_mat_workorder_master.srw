HA$PBExportHeader$w_mat_workorder_master.srw
$PBExportComments$Material Mass Issue Master
forward
global type w_mat_workorder_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mat_workorder_master
end type
type uo_dateend from uo_ymd_calendar within w_mat_workorder_master
end type
type ddlb_item_code from uo_item_code within w_mat_workorder_master
end type
type st_3 from so_statictext within w_mat_workorder_master
end type
type st_4 from so_statictext within w_mat_workorder_master
end type
type rb_workorder from so_radiobutton within w_mat_workorder_master
end type
type rb_issue from so_radiobutton within w_mat_workorder_master
end type
type ddlb_mfs from uo_mfs_this_month within w_mat_workorder_master
end type
type st_5 from so_statictext within w_mat_workorder_master
end type
type ddlb_line_code from uo_line_code within w_mat_workorder_master
end type
type st_6 from so_statictext within w_mat_workorder_master
end type
type ddlb_parent_item_code from uo_item_code within w_mat_workorder_master
end type
type st_7 from so_statictext within w_mat_workorder_master
end type
type ddlb_line_type from uo_line_type within w_mat_workorder_master
end type
type st_8 from so_statictext within w_mat_workorder_master
end type
type tab_1 from tab within w_mat_workorder_master
end type
type tabpage_1 from userobject within tab_1
end type
type cb_1 from so_commandbutton within tabpage_1
end type
type tabpage_1 from userobject within tab_1
cb_1 cb_1
end type
type tabpage_2 from userobject within tab_1
end type
type cb_2 from so_commandbutton within tabpage_2
end type
type cb_print from so_commandbutton within tabpage_2
end type
type cb_preview from so_commandbutton within tabpage_2
end type
type cbx_dialog from so_checkbox within tabpage_2
end type
type em_copy from so_editmask within tabpage_2
end type
type st_2 from so_statictext within tabpage_2
end type
type tabpage_2 from userobject within tab_1
cb_2 cb_2
cb_print cb_print
cb_preview cb_preview
cbx_dialog cbx_dialog
em_copy em_copy
st_2 st_2
end type
type tabpage_3 from userobject within tab_1
end type
type st_14 from so_statictext within tabpage_3
end type
type sle_item_name from so_singlelineedit within tabpage_3
end type
type st_1 from so_statictext within tabpage_3
end type
type sle_1 from so_singlelineedit within tabpage_3
end type
type tabpage_3 from userobject within tab_1
st_14 st_14
sle_item_name sle_item_name
st_1 st_1
sle_1 sle_1
end type
type tab_1 from tab within w_mat_workorder_master
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
type gb_2 from so_groupbox within w_mat_workorder_master
end type
type gb_3 from so_groupbox within w_mat_workorder_master
end type
end forward

global type w_mat_workorder_master from w_main_root
integer width = 5609
integer height = 3172
string title = "Material Issue Master"
uo_dateset uo_dateset
uo_dateend uo_dateend
ddlb_item_code ddlb_item_code
st_3 st_3
st_4 st_4
rb_workorder rb_workorder
rb_issue rb_issue
ddlb_mfs ddlb_mfs
st_5 st_5
ddlb_line_code ddlb_line_code
st_6 st_6
ddlb_parent_item_code ddlb_parent_item_code
st_7 st_7
ddlb_line_type ddlb_line_type
st_8 st_8
tab_1 tab_1
gb_2 gb_2
gb_3 gb_3
end type
global w_mat_workorder_master w_mat_workorder_master

type variables
string ivs_preview_yn = 'N'
end variables

on w_mat_workorder_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.ddlb_item_code=create ddlb_item_code
this.st_3=create st_3
this.st_4=create st_4
this.rb_workorder=create rb_workorder
this.rb_issue=create rb_issue
this.ddlb_mfs=create ddlb_mfs
this.st_5=create st_5
this.ddlb_line_code=create ddlb_line_code
this.st_6=create st_6
this.ddlb_parent_item_code=create ddlb_parent_item_code
this.st_7=create st_7
this.ddlb_line_type=create ddlb_line_type
this.st_8=create st_8
this.tab_1=create tab_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.ddlb_item_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.rb_workorder
this.Control[iCurrent+7]=this.rb_issue
this.Control[iCurrent+8]=this.ddlb_mfs
this.Control[iCurrent+9]=this.st_5
this.Control[iCurrent+10]=this.ddlb_line_code
this.Control[iCurrent+11]=this.st_6
this.Control[iCurrent+12]=this.ddlb_parent_item_code
this.Control[iCurrent+13]=this.st_7
this.Control[iCurrent+14]=this.ddlb_line_type
this.Control[iCurrent+15]=this.st_8
this.Control[iCurrent+16]=this.tab_1
this.Control[iCurrent+17]=this.gb_2
this.Control[iCurrent+18]=this.gb_3
end on

on w_mat_workorder_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.ddlb_item_code)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.rb_workorder)
destroy(this.rb_issue)
destroy(this.ddlb_mfs)
destroy(this.st_5)
destroy(this.ddlb_line_code)
destroy(this.st_6)
destroy(this.ddlb_parent_item_code)
destroy(this.st_7)
destroy(this.ddlb_line_type)
destroy(this.st_8)
destroy(this.tab_1)
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
Ivs_resize_type                      = 'MASTER_DETAIL_145_23M'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default


 ivs_dw_2_retrice_cancel_popup_open = 'N'
 ivs_dw_3_retrice_cancel_popup_open = 'N'
 ivs_dw_4_retrice_cancel_popup_open = 'N'
 ivs_dw_5_retrice_cancel_popup_open = 'N'
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
F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control





end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
uo_dateset.settext(string(f_t_sysdate(), 'yyyy/mm')+'/01')
end event

event ue_data_control;call super::ue_data_control;long row, i 
string lvs_date, lvs_item_code
double lvd_seq
Decimal  lvd_qty, lvd_packing_qty, lvd_request_qty, lvd_issue_qty
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
			dw_1.reset()
			dw_2.reset()
			dw_3.reset()
			dw_4.reset()
			if    rb_workorder.checked = true  then 				
			    dw_1.retrieve( uo_dateset.text() , uo_dateend.text(),  ddlb_mfs.text+'%' , ddlb_item_code.text() + '%', ddlb_line_code.getcode( )+'%' ,   ddlb_parent_item_code.text+'%' , ddlb_line_type.getcode()+'%' , gvi_organization_id)
			else
				dw_4.retrieve( uo_dateset.text() , uo_dateend.text(), ddlb_mfs.text+'%' , '%' , ddlb_item_code.text() + '%',  '%' ,   gvi_organization_id)
			end if 
			
	case 'DELETE'
		
		  	if dw_1.AcceptText() = -1 then
				return
			end if
			
			if dw_1.getrow( ) < 1 then 
				return
			end if
			
			if dw_1.object.issue_qty[dw_1.getrow()]  <> 0 then
				Messagebox("Notify" , "Aready Issued Can`t Delete")
				Return
			end if
			
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			IF MSG = 1 THEN
				Gvl_row_deleted = dw_1.GetRow()			
				dw_1.DELETEROW(Gvl_row_deleted)		
				dw_1.SetFocus()
				ROW = dw_1.GetRow()
				dw_1.ScrollToRow(row)
				dw_1.SetColumn(1)
				
				IF dw_1.UPDATE() < 0   THEN
					 ROLLBACK;
				ELSE
					 COMMIT;
					 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
				END IF
				
			END IF
		
		
	case 'UPDATE'
		
			IF dw_1.UPDATE() < 0   THEN
				ROLLBACK;
				RETURN					
			ELSE
				COMMIT;
				F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
				F_RETRIEVE()				 
			END IF

	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mat_workorder_master
integer y = 572
integer width = 4544
integer height = 1220
integer taborder = 0
boolean titlebar = true
string title = "Issue Invoice"
string dataobject = "d_mat_material_transfer_invoice_rpt"
end type

type dw_4 from w_main_root`dw_4 within w_mat_workorder_master
integer y = 572
integer width = 4544
integer height = 1220
integer taborder = 0
boolean titlebar = true
string title = "Material Issue List"
string dataobject = "d_mat_issue_lst"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event dw_4::rowfocuschanged;call super::rowfocuschanged;//if currentrow < 1 then return
//
//dw_5.retrieve( this.object.mfs[currentrow] , '%' ,  'N' , Gvi_organization_id )
//f_dual_lang_change_dwtext(dw_5)
//DataWindowChild	state_child_1,state_child_2
//
//dw_5.GetChild('dw_1', state_child_1)
//dw_5.GetChild('dw_2', state_child_2)
//
//F_CHILD_DW1_REPORT(state_child_1, 'customer_code', string(gvi_organization_id))
//F_CHILD_DW1_REPORT(state_child_2, 'customer_code', string(gvi_organization_id))
//
end event

type dw_3 from w_main_root`dw_3 within w_mat_workorder_master
integer x = 2272
integer y = 1796
integer width = 2267
integer height = 752
integer taborder = 0
boolean titlebar = true
string title = "Current Inventory List"
string dataobject = "d_mat_current_inventory_4_work_order_lst_tree"
end type

type dw_2 from w_main_root`dw_2 within w_mat_workorder_master
integer y = 1796
integer width = 2267
integer height = 752
integer taborder = 0
boolean titlebar = true
string title = "Issue List"
string dataobject = "d_mat_mass_issue_4_work_order_lst"
boolean hsplitscroll = false
boolean livescroll = false
borderstyle borderstyle = styleraised!
end type

event dw_2::itemchanged;call super::itemchanged;decimal lvf_inventory_price

if dwo.name = 'issue_qty' then 
	lvf_inventory_price = this.object.issue_price[row]
	this.object.issue_amt[row] = lvf_inventory_price  *  Dec(data)
end if 
end event

event dw_2::rbuttondown;call super::rbuttondown;string lvs_location_code, lvs_item_code
Decimal lvd_inventory_qty , lvd_issue_qty ,lvd_inventory_price
if dwo.name = 'supplier_code' then 
	openwithparm(w_mat_item_popup , string(this.object.item_code[row]))	
	if  gst_return.gvb_return  = true then
	   this.object.supplier_code[row] = gst_return.gvs_return[4] 
	end if

end if

end event

type dw_1 from w_main_root`dw_1 within w_mat_workorder_master
integer y = 572
integer width = 4544
integer height = 1220
integer taborder = 0
boolean titlebar = true
string title = "Work Order List"
string dataobject = "d_mat_work_order_lst_tree"
end type

event dw_1::rbuttondown;call super::rbuttondown;if row > 0 then 
else
	Return
end if 

if dwo.name = 'supplier_code' then 
	
	openwithparm(w_mat_item_popup , string(this.object.item_code[row]))
	
	if  gst_return.gvb_return  = true then
	   this.object.supplier_code[row] = gst_return.gvs_return[4] 
	end if
	
end if
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return

dw_2.retrieve( this.object.work_order_no[currentrow] , this.object.item_code[currentrow] , gvi_organization_id )

dw_3.retrieve( this.object.item_code[currentrow] , this.object.line_type[currentrow] , gvi_organization_id )
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_workorder_master
end type

type uo_dateset from uo_ymd_calendar within w_mat_workorder_master
event destroy ( )
integer x = 763
integer y = 160
integer taborder = 10
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_workorder_master
event destroy ( )
integer x = 1179
integer y = 160
integer taborder = 20
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_item_code from uo_item_code within w_mat_workorder_master
integer x = 3040
integer y = 156
integer width = 558
integer height = 676
integer taborder = 40
boolean bringtotop = true
end type

type st_3 from so_statictext within w_mat_workorder_master
integer x = 3040
integer y = 76
integer width = 558
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type st_4 from so_statictext within w_mat_workorder_master
integer x = 768
integer y = 80
integer width = 814
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Issue Request Date"
end type

type rb_workorder from so_radiobutton within w_mat_workorder_master
integer x = 46
integer y = 76
integer width = 631
boolean bringtotop = true
integer weight = 700
string text = "Work Order List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1

tab_1.tabpage_2.cb_preview.enabled = false
tab_1.tabpage_2.cb_print.enabled = false

end event

type rb_issue from so_radiobutton within w_mat_workorder_master
integer x = 46
integer y = 176
integer width = 558
boolean bringtotop = true
integer weight = 700
string text = "Material Issue List"
end type

event clicked;call super::clicked;dw_4.bringtotop = true 
selected_data_window = dw_4

tab_1.tabpage_2.cb_preview.enabled = True
tab_1.tabpage_2.cb_print.enabled = True
end event

type ddlb_mfs from uo_mfs_this_month within w_mat_workorder_master
integer x = 2048
integer y = 160
integer width = 434
integer taborder = 30
boolean bringtotop = true
end type

type st_5 from so_statictext within w_mat_workorder_master
integer x = 2048
integer y = 80
integer width = 434
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "MFS"
end type

type ddlb_line_code from uo_line_code within w_mat_workorder_master
integer x = 1595
integer y = 160
integer width = 448
integer taborder = 30
boolean bringtotop = true
end type

type st_6 from so_statictext within w_mat_workorder_master
integer x = 1595
integer y = 80
integer width = 448
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "LIne Code"
end type

type ddlb_parent_item_code from uo_item_code within w_mat_workorder_master
integer x = 2487
integer y = 156
integer width = 549
integer height = 676
integer taborder = 40
boolean bringtotop = true
end type

type st_7 from so_statictext within w_mat_workorder_master
integer x = 2487
integer y = 76
integer width = 549
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Parent Item Code"
end type

type ddlb_line_type from uo_line_type within w_mat_workorder_master
integer x = 3607
integer y = 156
integer width = 480
integer height = 948
integer taborder = 20
boolean bringtotop = true
end type

type st_8 from so_statictext within w_mat_workorder_master
integer x = 3611
integer y = 76
integer width = 480
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Line Type"
end type

type tab_1 from tab within w_mat_workorder_master
event create ( )
event destroy ( )
integer y = 304
integer width = 2885
integer height = 264
integer taborder = 60
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
tabpage_3 tabpage_3
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2848
integer height = 136
long backcolor = 12632256
string text = "Process"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Regenerate5!"
long picturemaskcolor = 536870912
cb_1 cb_1
end type

on tabpage_1.create
this.cb_1=create cb_1
this.Control[]={this.cb_1}
end on

on tabpage_1.destroy
destroy(this.cb_1)
end on

type cb_1 from so_commandbutton within tabpage_1
integer x = 27
integer y = 20
integer height = 104
integer taborder = 50
string text = "Generate Plan"
end type

event clicked;call super::clicked;int i , lvi_return

do
	i++
	
	if dw_1.object.check_yn[i] = "Y" and dw_1.object.remain_qty[i] > 0 then
	else
		continue 
	end if 
	
	lvi_return = f_gen_work_order_to_assy_plan( dw_1.object.work_order_no[i] /*string arg_work_order_no*/, &
											    dw_1.object.item_code[i] /*string arg_item_code*/, &
												dw_1.object.line_type[i] /*string arg_line_type*/, &
												dw_1.object.mfs[i] /*string arg_mfs*/, & 
												dw_1.object.plan_date[i]  /*datetime arg_plan_date*/, &
												dw_1.object.line_code[i] /*string arg_line_code*/, & 
												dw_1.object.workstage_code[i]  /*string arg_workstage_code*/, & 
												'*' /*string arg_machine_code*/, & 
												dw_1.object.remain_qty[i]  /*double arg_plan_qty */ )
	

	  if lvi_return < 0 then 
		rollback ;
	 else
		commit ;
	  end if 
	
loop until i = dw_1.rowcount( )

f_retrieve()
end event

type tabpage_2 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 2848
integer height = 136
long backcolor = 12632256
string text = "Print"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Print!"
long picturemaskcolor = 536870912
cb_2 cb_2
cb_print cb_print
cb_preview cb_preview
cbx_dialog cbx_dialog
em_copy em_copy
st_2 st_2
end type

on tabpage_2.create
this.cb_2=create cb_2
this.cb_print=create cb_print
this.cb_preview=create cb_preview
this.cbx_dialog=create cbx_dialog
this.em_copy=create em_copy
this.st_2=create st_2
this.Control[]={this.cb_2,&
this.cb_print,&
this.cb_preview,&
this.cbx_dialog,&
this.em_copy,&
this.st_2}
end on

on tabpage_2.destroy
destroy(this.cb_2)
destroy(this.cb_print)
destroy(this.cb_preview)
destroy(this.cbx_dialog)
destroy(this.em_copy)
destroy(this.st_2)
end on

type cb_2 from so_commandbutton within tabpage_2
integer x = 2025
integer y = 12
integer width = 384
integer height = 112
integer taborder = 80
boolean bringtotop = true
string text = "Show BOM"
end type

event clicked;string lvs_item_code

if dw_1.getrow() < 1 then return

lvs_item_code = dw_1.getitemstring( dw_1.getrow() , 'item_code' )
if lvs_item_code = '' or isnull(lvs_item_code) then return

openwithparm( w_des_bom_query_popup , lvs_item_code )
end event

type cb_print from so_commandbutton within tabpage_2
integer x = 1637
integer y = 12
integer width = 384
integer height = 112
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
string text = "Print"
end type

event clicked;call super::clicked;Int		i, lvi_cnt , rows

		If dw_5.rowcount() < 1 Then Return		
		lvi_cnt = Integer(em_copy.text)
		If lvi_cnt > 0 Then		
				For i = 1 To lvi_cnt		
					if cbx_dialog.checked = true then 
						dw_5.print(false, True)
					else
						dw_5.print(false, False)						
					end if
				Next	
		End If

end event

type cb_preview from so_commandbutton within tabpage_2
integer x = 1248
integer y = 12
integer width = 384
integer height = 112
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
string text = "Preview"
end type

event clicked;call super::clicked;SETPOINTER(HOURGLASS!)
		if  ivs_preview_yn = 'Y' THEN 
		ivs_preview_yn = 'N' 	
		dw_4.bringtotop = TRUE
	else
		ivs_preview_yn = 'Y' 	
		dw_5.bringtotop = TRUE			
		if dw_5.Describe("DataWindow.Print.Preview") = '!' then
		else
			 dw_5.Modify("DataWindow.Print.Preview=yes")
			dw_5.Modify("DataWindow.Print.Preview.Rulers=yes")
		end if		
	end if

end event

type cbx_dialog from so_checkbox within tabpage_2
integer x = 809
integer y = 32
integer width = 421
boolean bringtotop = true
integer weight = 700
string text = "Show Dialog"
end type

type em_copy from so_editmask within tabpage_2
integer x = 411
integer y = 36
integer width = 320
integer taborder = 40
boolean bringtotop = true
string text = "1"
string mask = "##0"
boolean spin = true
end type

type st_2 from so_statictext within tabpage_2
integer x = 5
integer y = 48
integer width = 343
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Print Copy"
alignment alignment = right!
end type

type tabpage_3 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 2848
integer height = 136
long backcolor = 12632256
string text = "Filter"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Search!"
long picturemaskcolor = 536870912
st_14 st_14
sle_item_name sle_item_name
st_1 st_1
sle_1 sle_1
end type

on tabpage_3.create
this.st_14=create st_14
this.sle_item_name=create sle_item_name
this.st_1=create st_1
this.sle_1=create sle_1
this.Control[]={this.st_14,&
this.sle_item_name,&
this.st_1,&
this.sle_1}
end on

on tabpage_3.destroy
destroy(this.st_14)
destroy(this.sle_item_name)
destroy(this.st_1)
destroy(this.sle_1)
end on

type st_14 from so_statictext within tabpage_3
integer x = 9
integer y = 44
integer width = 439
integer height = 72
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Item Name"
alignment alignment = right!
end type

type sle_item_name from so_singlelineedit within tabpage_3
integer x = 507
integer y = 32
integer width = 439
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

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

SELECTED_DATA_WINDOW.SETFILTER('')
SELECTED_DATA_WINDOW.FILTER()

LVS_COLUMN = 'ITEM_NAME'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    SELECTED_DATA_WINDOW.SETFILTER('')
    SELECTED_DATA_WINDOW.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
SELECTED_DATA_WINDOW.FILTER()
F_MSG_MDI_HELP( STRING( SELECTED_DATA_WINDOW.ROWCOUNT() ) + " Found" )
end event

type st_1 from so_statictext within tabpage_3
integer x = 983
integer y = 44
integer width = 357
integer height = 72
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Item Spec"
alignment alignment = right!
end type

type sle_1 from so_singlelineedit within tabpage_3
integer x = 1358
integer y = 32
integer width = 439
integer height = 84
integer taborder = 70
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

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

SELECTED_DATA_WINDOW.SETFILTER('')
SELECTED_DATA_WINDOW.FILTER()

LVS_COLUMN = 'ITEM_SPEC'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    SELECTED_DATA_WINDOW.SETFILTER('')
    SELECTED_DATA_WINDOW.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
SELECTED_DATA_WINDOW.FILTER()
F_MSG_MDI_HELP( STRING( SELECTED_DATA_WINDOW.ROWCOUNT() ) + " Found" )
end event

type gb_2 from so_groupbox within w_mat_workorder_master
integer x = 722
integer width = 3387
integer height = 300
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_mat_workorder_master
integer width = 722
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

