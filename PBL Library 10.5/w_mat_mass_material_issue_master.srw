HA$PBExportHeader$w_mat_mass_material_issue_master.srw
$PBExportComments$Material Mass Issue Master
forward
global type w_mat_mass_material_issue_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mat_mass_material_issue_master
end type
type uo_dateend from uo_ymd_calendar within w_mat_mass_material_issue_master
end type
type ddlb_item_code from uo_item_code within w_mat_mass_material_issue_master
end type
type st_3 from so_statictext within w_mat_mass_material_issue_master
end type
type st_4 from so_statictext within w_mat_mass_material_issue_master
end type
type rb_workorder from so_radiobutton within w_mat_mass_material_issue_master
end type
type rb_issue from so_radiobutton within w_mat_mass_material_issue_master
end type
type st_14 from so_statictext within w_mat_mass_material_issue_master
end type
type sle_item_name from so_singlelineedit within w_mat_mass_material_issue_master
end type
type ddlb_mfs from uo_mfs_this_month within w_mat_mass_material_issue_master
end type
type st_5 from so_statictext within w_mat_mass_material_issue_master
end type
type st_1 from so_statictext within w_mat_mass_material_issue_master
end type
type ddlb_workstage_code from uo_workstage_code_all within w_mat_mass_material_issue_master
end type
type sle_1 from so_singlelineedit within w_mat_mass_material_issue_master
end type
type st_8 from so_statictext within w_mat_mass_material_issue_master
end type
type ddlb_set_item_code from uo_item_code within w_mat_mass_material_issue_master
end type
type st_7 from so_statictext within w_mat_mass_material_issue_master
end type
type tab_1 from tab within w_mat_mass_material_issue_master
end type
type tabpage_1 from userobject within tab_1
end type
type cbx_auto_save from so_checkbox within tabpage_1
end type
type cb_set from so_commandbutton within tabpage_1
end type
type ddlb_takeover_by from uo_user_id_name within tabpage_1
end type
type st_6 from so_statictext within tabpage_1
end type
type tabpage_1 from userobject within tab_1
cbx_auto_save cbx_auto_save
cb_set cb_set
ddlb_takeover_by ddlb_takeover_by
st_6 st_6
end type
type tabpage_2 from userobject within tab_1
end type
type cbx_dialog from so_checkbox within tabpage_2
end type
type cb_print from so_commandbutton within tabpage_2
end type
type cb_preview from so_commandbutton within tabpage_2
end type
type em_copy from so_editmask within tabpage_2
end type
type st_2 from so_statictext within tabpage_2
end type
type tabpage_2 from userobject within tab_1
cbx_dialog cbx_dialog
cb_print cb_print
cb_preview cb_preview
em_copy em_copy
st_2 st_2
end type
type tabpage_3 from userobject within tab_1
end type
type rb_3 from so_radiobutton within tabpage_3
end type
type rb_2 from so_radiobutton within tabpage_3
end type
type rb_all from so_radiobutton within tabpage_3
end type
type tabpage_3 from userobject within tab_1
rb_3 rb_3
rb_2 rb_2
rb_all rb_all
end type
type tabpage_4 from userobject within tab_1
end type
type cb_2 from so_commandbutton within tabpage_4
end type
type tabpage_4 from userobject within tab_1
cb_2 cb_2
end type
type tab_1 from tab within w_mat_mass_material_issue_master
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type
type gb_1 from so_groupbox within w_mat_mass_material_issue_master
end type
type gb_2 from so_groupbox within w_mat_mass_material_issue_master
end type
end forward

global type w_mat_mass_material_issue_master from w_main_root
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
st_14 st_14
sle_item_name sle_item_name
ddlb_mfs ddlb_mfs
st_5 st_5
st_1 st_1
ddlb_workstage_code ddlb_workstage_code
sle_1 sle_1
st_8 st_8
ddlb_set_item_code ddlb_set_item_code
st_7 st_7
tab_1 tab_1
gb_1 gb_1
gb_2 gb_2
end type
global w_mat_mass_material_issue_master w_mat_mass_material_issue_master

type variables
string ivs_preview_yn = 'N'
end variables

on w_mat_mass_material_issue_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.ddlb_item_code=create ddlb_item_code
this.st_3=create st_3
this.st_4=create st_4
this.rb_workorder=create rb_workorder
this.rb_issue=create rb_issue
this.st_14=create st_14
this.sle_item_name=create sle_item_name
this.ddlb_mfs=create ddlb_mfs
this.st_5=create st_5
this.st_1=create st_1
this.ddlb_workstage_code=create ddlb_workstage_code
this.sle_1=create sle_1
this.st_8=create st_8
this.ddlb_set_item_code=create ddlb_set_item_code
this.st_7=create st_7
this.tab_1=create tab_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.ddlb_item_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.rb_workorder
this.Control[iCurrent+7]=this.rb_issue
this.Control[iCurrent+8]=this.st_14
this.Control[iCurrent+9]=this.sle_item_name
this.Control[iCurrent+10]=this.ddlb_mfs
this.Control[iCurrent+11]=this.st_5
this.Control[iCurrent+12]=this.st_1
this.Control[iCurrent+13]=this.ddlb_workstage_code
this.Control[iCurrent+14]=this.sle_1
this.Control[iCurrent+15]=this.st_8
this.Control[iCurrent+16]=this.ddlb_set_item_code
this.Control[iCurrent+17]=this.st_7
this.Control[iCurrent+18]=this.tab_1
this.Control[iCurrent+19]=this.gb_1
this.Control[iCurrent+20]=this.gb_2
end on

on w_mat_mass_material_issue_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.ddlb_item_code)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.rb_workorder)
destroy(this.rb_issue)
destroy(this.st_14)
destroy(this.sle_item_name)
destroy(this.ddlb_mfs)
destroy(this.st_5)
destroy(this.st_1)
destroy(this.ddlb_workstage_code)
destroy(this.sle_1)
destroy(this.st_8)
destroy(this.ddlb_set_item_code)
destroy(this.st_7)
destroy(this.tab_1)
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
F_MENU_CONTROL('DATA_CONTROL_MODIFY' , TRUE)  // All Data Control





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
			if    rb_workorder.checked = true  then 				
			    dw_1.retrieve( uo_dateset.text() , uo_dateend.text(),  ddlb_set_item_code.text()+'%',  ddlb_mfs.text+'%' , ddlb_workstage_code.getcode()+'%' , ddlb_item_code.text() + '%',   gvi_organization_id)
			else
				dw_4.retrieve( uo_dateset.text() , uo_dateend.text(),  ddlb_mfs.text+'%' , ddlb_workstage_code.getcode()+'%' , ddlb_item_code.text() + '%',   gvi_organization_id)
			end if 
			
	case 'DELETE'
		
		  	if dw_2.AcceptText() = -1 then
				return
			end if
			
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			IF MSG = 1 THEN
				Gvl_row_deleted = dw_2.GetRow()			
				dw_2.DELETEROW(Gvl_row_deleted)		
				dw_2.SetFocus()
				ROW = dw_2.GetRow()
				dw_2.ScrollToRow(row)
				dw_2.SetColumn(1)
				
				IF dw_2.UPDATE() < 0   THEN
					 ROLLBACK;
				ELSE
					 COMMIT;
					 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
				END IF
				
			END IF
		
	case 'UPDATE'
		
			IF dw_1.UPDATE() < 0   or dw_2.UPDATE() < 0   THEN
				ROLLBACK;
				RETURN					
			ELSE
				COMMIT;
				F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$" 
			END IF
			F_RETRIEVE()				

	case else
end choose

end event

event close;call super::close;Rollback ;
end event

type dw_5 from w_main_root`dw_5 within w_mat_mass_material_issue_master
integer y = 580
integer width = 4544
integer height = 1300
integer taborder = 0
boolean titlebar = true
string title = "Issue Invoice"
string dataobject = "d_mat_material_transfer_invoice_rpt"
end type

type dw_4 from w_main_root`dw_4 within w_mat_mass_material_issue_master
integer y = 580
integer width = 4544
integer height = 1300
integer taborder = 0
boolean titlebar = true
string title = "Material Issue List"
string dataobject = "d_mat_issue_lst"
end type

type dw_3 from w_main_root`dw_3 within w_mat_mass_material_issue_master
integer x = 2272
integer y = 1888
integer width = 2267
integer height = 612
integer taborder = 0
boolean titlebar = true
string title = "Current Inventory List"
string dataobject = "d_mat_current_inventory_4_issue_lst_tree"
end type

type dw_2 from w_main_root`dw_2 within w_mat_mass_material_issue_master
integer y = 1888
integer width = 2267
integer height = 612
integer taborder = 0
boolean titlebar = true
string title = "Material Issue List"
string dataobject = "d_mat_mass_issue_lst"
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

type dw_1 from w_main_root`dw_1 within w_mat_mass_material_issue_master
integer y = 580
integer width = 4544
integer height = 1300
integer taborder = 0
boolean titlebar = true
string title = "Work Order List"
string dataobject = "d_mat_work_order_4_issue_batch_tree"
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


if dwo.name = 'item_code' then 
	open(w_mat_item_popup)
	if gst_return.gvb_return = false then 
	else
		this.object.item_code[row] = gst_return.gvs_return[1] 
		this.object.item_name[row] = gst_return.gvs_return[2] 
		this.object.item_spec[row] = gst_return.gvs_return[3] 
		this.object.line_type[row] = gst_return.gvs_return[6] 
		this.object.item_uom[row] = gst_return.gvs_return[7] 		
	end if 
	gst_return.gvs_return[1] = ''
	gst_return.gvs_return[2] = ''
	gst_return.gvs_return[3] = ''
	gst_return.gvs_return[6] = ''
	gst_return.gvs_return[7] = ''	
end if 
		
		
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;Long i

dw_2.reset()
dw_3.reset()
if currentrow < 1 then return

dw_2.retrieve( this.object.mfs[currentrow] , this.object.item_code[currentrow] , gvi_organization_id )
dw_3.retrieve( this.object.item_code[currentrow] ,  this.object.line_type[currentrow] ,  gvi_organization_id )


end event

event dw_1::itemchanged;call super::itemchanged;string lvs_return
if dwo.name = 'item_code' then    
	
   lvs_return = f_set_item_name_spec_uom( this , row , this.object.item_code[row] )		

	if 	lvs_return = 'ERROR' THEN 
		return 1
	end if	
		
	if lvs_return = 'NOTFOUND' then 
		return 1  
	end if 		
	
	this.object.line_type = ''
	
end if


end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_mass_material_issue_master
end type

type uo_dateset from uo_ymd_calendar within w_mat_mass_material_issue_master
event destroy ( )
integer x = 745
integer y = 160
integer taborder = 10
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_mass_material_issue_master
event destroy ( )
integer x = 1161
integer y = 160
integer taborder = 20
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_item_code from uo_item_code within w_mat_mass_material_issue_master
integer x = 2921
integer y = 160
integer width = 475
integer height = 676
integer taborder = 40
boolean bringtotop = true
end type

type st_3 from so_statictext within w_mat_mass_material_issue_master
integer x = 2921
integer y = 80
integer width = 475
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type st_4 from so_statictext within w_mat_mass_material_issue_master
integer x = 750
integer y = 80
integer width = 814
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Issue Request Date"
end type

type rb_workorder from so_radiobutton within w_mat_mass_material_issue_master
integer x = 32
integer y = 84
integer width = 654
boolean bringtotop = true
integer weight = 700
string text = "Work Order List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1

tab_1.tabpage_1.cb_set.enabled = true
tab_1.tabpage_2.cb_preview.enabled = false
tab_1.tabpage_2.cb_print.enabled = false

end event

type rb_issue from so_radiobutton within w_mat_mass_material_issue_master
integer x = 32
integer y = 184
integer width = 654
boolean bringtotop = true
integer weight = 700
string text = "Material Issue History"
end type

event clicked;call super::clicked;dw_4.bringtotop = true 
selected_data_window = dw_4

tab_1.tabpage_1.cb_set.enabled = false

tab_1.tabpage_2.cb_preview.enabled = True
tab_1.tabpage_2.cb_print.enabled = True
end event

type st_14 from so_statictext within w_mat_mass_material_issue_master
integer x = 3397
integer y = 80
integer width = 334
integer height = 72
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Item Name"
end type

type sle_item_name from so_singlelineedit within w_mat_mass_material_issue_master
integer x = 3397
integer y = 160
integer width = 334
integer height = 84
integer taborder = 50
boolean bringtotop = true
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

dw_1.SETFILTER('')
dw_1.FILTER()

LVS_COLUMN = 'ITEM_NAME'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    dw_1.SETFILTER('')
    dw_1.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

dw_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found" )
end event

type ddlb_mfs from uo_mfs_this_month within w_mat_mass_material_issue_master
integer x = 2039
integer y = 160
integer width = 434
integer taborder = 30
boolean bringtotop = true
end type

type st_5 from so_statictext within w_mat_mass_material_issue_master
integer x = 2039
integer y = 80
integer width = 434
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "MFS"
end type

type st_1 from so_statictext within w_mat_mass_material_issue_master
integer x = 2478
integer y = 92
integer width = 439
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Workstage Code"
end type

type ddlb_workstage_code from uo_workstage_code_all within w_mat_mass_material_issue_master
integer x = 2478
integer y = 160
integer width = 443
integer height = 676
integer taborder = 40
boolean bringtotop = true
end type

type sle_1 from so_singlelineedit within w_mat_mass_material_issue_master
integer x = 3730
integer y = 160
integer width = 334
integer height = 84
integer taborder = 50
boolean bringtotop = true
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

dw_1.SETFILTER('')
dw_1.FILTER()

LVS_COLUMN = 'ITEM_SPEC'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    dw_1.SETFILTER('')
    dw_1.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

dw_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found" )
end event

type st_8 from so_statictext within w_mat_mass_material_issue_master
integer x = 3730
integer y = 80
integer width = 334
integer height = 72
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Item Spec"
end type

type ddlb_set_item_code from uo_item_code within w_mat_mass_material_issue_master
integer x = 1568
integer y = 160
integer width = 471
integer height = 676
integer taborder = 50
boolean bringtotop = true
end type

type st_7 from so_statictext within w_mat_mass_material_issue_master
integer x = 1582
integer y = 76
integer width = 439
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Set Item Code"
end type

type tab_1 from tab within w_mat_mass_material_issue_master
event create ( )
event destroy ( )
integer y = 312
integer width = 2949
integer height = 264
integer taborder = 50
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
tabpage_4 tabpage_4
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
end on

event selectionchanged;if newindex = 2 then 
	dw_4.bringtotop = true 
	selected_data_window = dw_4
	
	tab_1.tabpage_1.cb_set.enabled = false
	
	tab_1.tabpage_2.cb_preview.enabled = True
	tab_1.tabpage_2.cb_print.enabled = True
else
	
	dw_1.bringtotop = true 
	selected_data_window = dw_1
	
	tab_1.tabpage_1.cb_set.enabled = true
	tab_1.tabpage_2.cb_preview.enabled = false
	tab_1.tabpage_2.cb_print.enabled = false
	
end if 
end event

type tabpage_1 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 2912
integer height = 136
long backcolor = 15780518
string text = "Process"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Regenerate5!"
long picturemaskcolor = 536870912
cbx_auto_save cbx_auto_save
cb_set cb_set
ddlb_takeover_by ddlb_takeover_by
st_6 st_6
end type

on tabpage_1.create
this.cbx_auto_save=create cbx_auto_save
this.cb_set=create cb_set
this.ddlb_takeover_by=create ddlb_takeover_by
this.st_6=create st_6
this.Control[]={this.cbx_auto_save,&
this.cb_set,&
this.ddlb_takeover_by,&
this.st_6}
end on

on tabpage_1.destroy
destroy(this.cbx_auto_save)
destroy(this.cb_set)
destroy(this.ddlb_takeover_by)
destroy(this.st_6)
end on

type cbx_auto_save from so_checkbox within tabpage_1
integer x = 974
integer y = 32
integer width = 439
integer height = 80
boolean bringtotop = true
integer weight = 700
long backcolor = 15780518
string text = "Auto Save"
boolean checked = true
end type

type cb_set from so_commandbutton within tabpage_1
integer x = 1371
integer y = 12
integer width = 416
integer height = 112
integer taborder = 80
boolean bringtotop = true
string text = "Issue"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 
//===============================================
//
//===============================================
long n = 1  , i = 1  , J ,lvi_check , lvi_check_count
Double LVDB_ISSUE_INVOICE_NO , lvl_issue_seq
String Lvs_made_by
Decimal  lvf_inventory_price, lvf_inventory_qty  , lvf_issue_qty, lvf_remain_qty

dw_1.accepttext()
if dw_1.getrow() < 0 then 
	return
end if

Lvs_made_by =  ddlb_takeover_by.getcode()
//==================================================
//
//==================================================
if isnull(Lvs_made_by) or Lvs_made_by = '%' or Lvs_made_by = '' then 
  Messagebox("Notify" , 'Takeover By Invalid' )
  return
end if
//==================================================
//
//==================================================
if dw_3.rowcount( ) < 1 then 
	Messagebox("Notify" , "Inventory not found" )
	Return
end if

//==================================================
//
//==================================================

do
	
	lvi_check++
	if dw_3.object.check_yn[lvi_check] = 'Y' then
	   lvi_check_count++
	end if	
	
loop until lvi_check = dw_3.rowcount( )

if lvi_check_count > 0 then 
else
	Messagebox("Notify" , "Inventory data was not selected" )	
	return
end if 

//==================================================
//
//==================================================
msg = f_msgbox1(1161,this.text)
if msg = 1 then 
else 
	return 
end if 

dw_2.reset()
//==================================================
//
//==================================================

LVDB_ISSUE_INVOICE_NO = F_GET_SEQUENCE('SEQ_ISSUE_INVOICE_SEQUENCE')

Open(w_progress_popup)
w_progress_popup.f_set_range(1,dw_1.rowcount( ))
w_progress_popup.f_setstep(1)

//for i = 1 to dw_1.rowcount()
	
	if dw_1.object.check_yn[dw_1.getrow()] =  'Y' and  Dec(dw_1.object.inventory_qty[dw_1.getrow()])  > 0 and Dec(dw_1.object.remain_qty[dw_1.getrow()])  > 0  then 
	else 
		return
//		continue 
	end if 	


		//=============================================		
		// $$HEX8$$acc7e0ac200069d5c4ac200070c88cd6$$ENDHEX$$
		//=============================================				
			  lvf_inventory_qty =  f_get_item_inventory_sum_qty(  dw_1.object.item_code[dw_1.getrow()]	 , dw_1.object.line_type[dw_1.getrow()] )
				 
				if lvf_inventory_qty <= 0 then 
					
							close(w_progress_popup)
							Messagebox("Notify" , "Inventory Information Not Found or Invalid" )
							return 
				end if 
		//=============================================		
		//
		//=============================================		
		

				if Truncate(lvf_inventory_qty,8)  < truncate(lvf_remain_qty,8) then 
					
							close(w_progress_popup)
							f_msgbox(9040) // Inventory Not Found or Not enough 
							f_msg_mdi_help( 'Inventory ='+string(lvf_inventory_qty) +' Remain='+string(lvf_remain_qty))
							return 
				 end if
			//=============================================		
		
	lvf_remain_qty = Dec(dw_1.object.remain_qty[dw_1.getrow()])
	if lvf_remain_qty <= 0 then 

				close(w_progress_popup)
				Messagebox("Notify" , "Issue Qty Invalid")
				Return
	end if
		
	Int k , L
	String lvs_material_mfs
	k = 0 
	do
		k++
				if dw_3.object.check_yn[K] = 'Y' then
					lvs_material_mfs  = dw_3.object.material_mfs[k]
					lvf_inventory_qty = dw_3.object.inventory_qty[k]
				else
					continue
				end if
		//=============================================		
		// $$HEX8$$acc7e0ac2000e8b200ac200070c88cd6$$ENDHEX$$
		//=============================================		
			  lvf_inventory_price =  dw_3.object.inventory_price[k]
				 
				if lvf_inventory_price <= 0 then 
						
						if dw_3.object.line_type[k] = 'F' then  //$$HEX16$$34bbc1c06cade4b988d478c7bdacb0c62000acc7e0ace8b200ac200034bbdcc2$$ENDHEX$$
						   lvf_inventory_price = 0
						else
							close(w_progress_popup)
							Messagebox("Notify" , "Inventory Price Invalid" )
							return 
						end if 
			end if
		
		//=============================================				
		// $$HEX18$$acc7e0ac00ac20009ccde0ac08c615c82000f4bce4b2200001c840c72000bdacb0c62000$$ENDHEX$$
		//=============================================						
		
		if Truncate(lvf_inventory_qty,8)  < truncate(lvf_remain_qty,8) then 
			
			
				n = dw_2.insertrow(0)
				dw_2.scrolltorow(n)
				f_set_security_row(dw_2, n, 'ALL')
				
				dw_2.object.issue_date[n] = f_t_sysdate()	
				lvl_issue_seq = long(f_get_sequence('seq_mat_issue'))
				
				dw_2.object.issue_sequence[n] = lvl_issue_seq
			
				dw_2.object.mfs[n] = dw_1.object.mfs[dw_1.getrow()]	
				dw_2.object.work_order_no[n] =dw_1.object.work_order_no[dw_1.getrow()]
				
				dw_2.object.item_code[n] = dw_1.object.item_code[dw_1.getrow()]	
				dw_2.object.parent_item_code[n] = dw_1.object.parent_item_code[dw_1.getrow()]		
				dw_2.object.item_type[n] = dw_1.object.item_type[dw_1.getrow()]
				dw_2.object.line_type[n] = dw_1.object.line_type[dw_1.getrow()]
				
				dw_2.object.item_name[n] = dw_1.object.item_name[dw_1.getrow()]
				dw_2.object.item_spec[n] = dw_1.object.item_spec[dw_1.getrow()]
				dw_2.object.item_uom[n] = dw_1.object.item_uom[dw_1.getrow()]	
			
				  dw_2.object.line_code[n] = dw_1.object.line_code[dw_1.getrow()]
				dw_2.object.workstage_code[n] = dw_1.object.workstage_code[dw_1.getrow()]
				
				dw_2.object.issue_deficit[n] = '3'
				
				dw_2.object.issue_status[n] = 'N'
				dw_2.object.issue_type[n] = 'N'		
				dw_2.object.issue_account[n] = dw_1.object.issue_account[dw_1.getrow()]
				dw_2.object.invoice_no[n] = string(LVDB_ISSUE_INVOICE_NO)
				dw_2.object.location_code[n] = '*'	
				dw_2.object.made_by[n] =lvs_made_by				
		
		          //=================================================
				dw_2.object.issue_qty[n] = Truncate(lvf_inventory_qty,8)
				dw_2.object.issue_amt[n] = lvf_inventory_price *   Truncate(lvf_inventory_qty,8)
				dw_2.object.issue_price[n]  = lvf_inventory_price
				dw_2.object.material_mfs[n]  = lvs_material_mfs		
				
				lvf_remain_qty = lvf_remain_qty - Truncate(lvf_inventory_qty,8)
		          L++
		          //=================================================				
			else
		//=============================================				
		// $$HEX21$$acc7e0ac00ac20009ccde0ac08c615c82000fcac200019ac70ac98b02000ceb940c72000bdacb0c62000$$ENDHEX$$
		//=============================================									
				n = dw_2.insertrow(0)
				dw_2.scrolltorow(n)
				f_set_security_row(dw_2, n, 'ALL')
				
				dw_2.object.issue_date[n] = f_t_sysdate()	
				lvl_issue_seq = long(f_get_sequence('seq_mat_issue'))
				
				dw_2.object.issue_sequence[n] = lvl_issue_seq
			
				dw_2.object.mfs[n] = dw_1.object.mfs[dw_1.getrow()]	
				dw_2.object.work_order_no[n] =dw_1.object.work_order_no[dw_1.getrow()]
				
				dw_2.object.item_code[n] = dw_1.object.item_code[dw_1.getrow()]	
				dw_2.object.parent_item_code[n] = dw_1.object.parent_item_code[dw_1.getrow()]		
				dw_2.object.item_type[n] = dw_1.object.item_type[dw_1.getrow()]
				dw_2.object.line_type[n] = dw_1.object.line_type[dw_1.getrow()]
				
				dw_2.object.item_name[n] = dw_1.object.item_name[dw_1.getrow()]
				dw_2.object.item_spec[n] = dw_1.object.item_spec[dw_1.getrow()]
				dw_2.object.item_uom[n] = dw_1.object.item_uom[dw_1.getrow()]	
			
				  dw_2.object.line_code[n] = dw_1.object.line_code[dw_1.getrow()]
				dw_2.object.workstage_code[n] = dw_1.object.workstage_code[dw_1.getrow()]
				
				dw_2.object.issue_deficit[n] = '3'
				
				dw_2.object.issue_status[n] = 'N'
				dw_2.object.issue_type[n] = 'N'		
				dw_2.object.issue_account[n] = dw_1.object.issue_account[dw_1.getrow()]
				dw_2.object.invoice_no[n] = string(LVDB_ISSUE_INVOICE_NO)
				dw_2.object.location_code[n] = '*'	
				dw_2.object.made_by[n] =lvs_made_by						
				
		          //=================================================			
				dw_2.object.issue_qty[n] = truncate(lvf_remain_qty,8)
				dw_2.object.issue_amt[n] = lvf_inventory_price *   truncate(lvf_remain_qty,8)
				dw_2.object.issue_price[n]  = lvf_inventory_price			
				dw_2.object.material_mfs[n]  = lvs_material_mfs			
				
				lvf_remain_qty = 0
		          L++
				exit
		          //=================================================				
		end if
				
		//==============================================
		//
		//==============================================

	loop until k = dw_3.rowcount()
	
	if L = 0 then 
		close(w_progress_popup)
		Messagebox("Notify" , "Inventory Not Selected or Inventory Price = 0 , Please Check Inventory for issue")
		Return
	end if
	
	J++
	w_progress_popup.f_stepit()

	if dw_2.update() < 0 then 
		Return
	end if

//next
//=========================================================
//
//=========================================================
if tab_1.tabpage_1.cbx_auto_save.checked = true and j > 0 then 
	f_update()
end if 

close(w_progress_popup)
end event

type ddlb_takeover_by from uo_user_id_name within tabpage_1
integer x = 462
integer y = 28
integer width = 503
integer taborder = 50
boolean bringtotop = true
end type

type st_6 from so_statictext within tabpage_1
integer x = 9
integer y = 36
integer width = 430
integer height = 60
boolean bringtotop = true
integer weight = 700
long backcolor = 15780518
string text = "Takeover By"
end type

type tabpage_2 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 2912
integer height = 136
long backcolor = 15780518
string text = "Print"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Print!"
long picturemaskcolor = 536870912
cbx_dialog cbx_dialog
cb_print cb_print
cb_preview cb_preview
em_copy em_copy
st_2 st_2
end type

on tabpage_2.create
this.cbx_dialog=create cbx_dialog
this.cb_print=create cb_print
this.cb_preview=create cb_preview
this.em_copy=create em_copy
this.st_2=create st_2
this.Control[]={this.cbx_dialog,&
this.cb_print,&
this.cb_preview,&
this.em_copy,&
this.st_2}
end on

on tabpage_2.destroy
destroy(this.cbx_dialog)
destroy(this.cb_print)
destroy(this.cb_preview)
destroy(this.em_copy)
destroy(this.st_2)
end on

type cbx_dialog from so_checkbox within tabpage_2
integer x = 1408
integer y = 40
integer width = 421
integer height = 60
boolean bringtotop = true
integer weight = 700
long backcolor = 15780518
string text = "Show Dialog"
end type

type cb_print from so_commandbutton within tabpage_2
integer x = 1033
integer y = 24
integer width = 361
integer height = 92
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
string text = "Print"
end type

event clicked;call super::clicked;Int	 i, lvi_cnt , rows

if dw_4.getrow() < 0 then return

cb_preview.triggerevent( clicked!)

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
integer x = 672
integer y = 24
integer width = 361
integer height = 92
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
string text = "Preview"
end type

event clicked;call super::clicked;if dw_4.getrow() < 1 then return

SETPOINTER(HOURGLASS!)
	if  ivs_preview_yn = 'Y' THEN 
		ivs_preview_yn = 'N' 	
		dw_4.bringtotop = TRUE
	else
		
		ivs_preview_yn = 'Y' 	
		dw_5.bringtotop = TRUE			
		
		dw_5.retrieve( dw_4.object.mfs[dw_4.getrow()] , '%' ,  'N' , Gvi_organization_id )
		f_dual_lang_change_dwtext(dw_5)
		DataWindowChild	state_child_1,state_child_2
		
		dw_5.GetChild('dw_1', state_child_1)
		dw_5.GetChild('dw_2', state_child_2)
		
		F_CHILD_DW1_REPORT(state_child_1, 'customer_code', string(gvi_organization_id))
		F_CHILD_DW1_REPORT(state_child_2, 'customer_code', string(gvi_organization_id))
			
		F_CHILD_DW1_REPORT(state_child_1, 'line_code', string(gvi_organization_id))
		F_CHILD_DW1_REPORT(state_child_2, 'line_code', string(gvi_organization_id))
		
		F_CHILD_DW1_REPORT(state_child_1, 'workstage_code', string(gvi_organization_id))
		F_CHILD_DW1_REPORT(state_child_2, 'workstage_code', string(gvi_organization_id))
		
		F_CHILD_DW1_REPORT(state_child_1, 'dest_workstage_code', string(gvi_organization_id))
		F_CHILD_DW1_REPORT(state_child_2, 'dest_workstage_code', string(gvi_organization_id))		
		
		
		if dw_5.Describe("DataWindow.Print.Preview") = '!' then
		else
			 dw_5.Modify("DataWindow.Print.Preview=yes")
			dw_5.Modify("DataWindow.Print.Preview.Rulers=yes")
		end if		
	end if

end event

type em_copy from so_editmask within tabpage_2
integer x = 375
integer y = 28
integer width = 242
integer taborder = 50
boolean bringtotop = true
string text = "1"
alignment alignment = center!
string mask = "##0"
boolean spin = true
end type

type st_2 from so_statictext within tabpage_2
integer x = 27
integer y = 36
integer width = 297
integer height = 60
boolean bringtotop = true
integer weight = 700
long backcolor = 15780518
string text = "Print Copy"
alignment alignment = right!
end type

type tabpage_3 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 2912
integer height = 136
long backcolor = 15780518
string text = "Filter"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Find!"
long picturemaskcolor = 536870912
rb_3 rb_3
rb_2 rb_2
rb_all rb_all
end type

on tabpage_3.create
this.rb_3=create rb_3
this.rb_2=create rb_2
this.rb_all=create rb_all
this.Control[]={this.rb_3,&
this.rb_2,&
this.rb_all}
end on

on tabpage_3.destroy
destroy(this.rb_3)
destroy(this.rb_2)
destroy(this.rb_all)
end on

type rb_3 from so_radiobutton within tabpage_3
integer x = 1074
integer y = 32
integer width = 558
boolean bringtotop = true
integer weight = 700
long backcolor = 15780518
string text = "Remain Qty <= 0"
end type

event clicked;call super::clicked;dw_1.setfilter('remain_qty <= 0 ')
dw_1.filter( )
end event

type rb_2 from so_radiobutton within tabpage_3
integer x = 439
integer y = 32
integer width = 558
boolean bringtotop = true
integer weight = 700
long backcolor = 15780518
string text = "Remain Qty > 0"
end type

event clicked;call super::clicked;dw_1.setfilter('remain_qty > 0 ')
dw_1.filter( )
end event

type rb_all from so_radiobutton within tabpage_3
integer x = 32
integer y = 32
integer width = 343
boolean bringtotop = true
integer weight = 700
long backcolor = 15780518
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.setfilter( '')
dw_1.filter( )
end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2912
integer height = 136
long backcolor = 15780518
string text = "Show BOM"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "TabOrder!"
long picturemaskcolor = 536870912
cb_2 cb_2
end type

on tabpage_4.create
this.cb_2=create cb_2
this.Control[]={this.cb_2}
end on

on tabpage_4.destroy
destroy(this.cb_2)
end on

type cb_2 from so_commandbutton within tabpage_4
integer x = 18
integer y = 20
integer width = 361
integer height = 92
integer taborder = 90
boolean bringtotop = true
string text = "Show BOM"
end type

event clicked;string lvs_item_code

if dw_1.getrow() < 1 then return

lvs_item_code = dw_1.getitemstring( dw_1.getrow() , 'item_code' )
if lvs_item_code = '' or isnull(lvs_item_code) then return

openwithparm( w_des_bom_query_popup , lvs_item_code )
end event

type gb_1 from so_groupbox within w_mat_mass_material_issue_master
integer width = 722
integer height = 300
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_2 from so_groupbox within w_mat_mass_material_issue_master
integer x = 727
integer width = 3355
integer height = 300
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

