HA$PBExportHeader$w_mat_mass_issue_return_confirm_master.srw
$PBExportComments$Material Mass Issue Return Master
forward
global type w_mat_mass_issue_return_confirm_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mat_mass_issue_return_confirm_master
end type
type uo_dateend from uo_ymd_calendar within w_mat_mass_issue_return_confirm_master
end type
type ddlb_item_code from uo_item_code within w_mat_mass_issue_return_confirm_master
end type
type st_3 from so_statictext within w_mat_mass_issue_return_confirm_master
end type
type st_4 from so_statictext within w_mat_mass_issue_return_confirm_master
end type
type rb_issue_list from so_radiobutton within w_mat_mass_issue_return_confirm_master
end type
type cb_set from so_commandbutton within w_mat_mass_issue_return_confirm_master
end type
type st_14 from so_statictext within w_mat_mass_issue_return_confirm_master
end type
type sle_item_name from so_singlelineedit within w_mat_mass_issue_return_confirm_master
end type
type ddlb_mfs from uo_mfs_this_month within w_mat_mass_issue_return_confirm_master
end type
type st_5 from so_statictext within w_mat_mass_issue_return_confirm_master
end type
type rb_issue_history from so_radiobutton within w_mat_mass_issue_return_confirm_master
end type
type st_1 from so_statictext within w_mat_mass_issue_return_confirm_master
end type
type ddlb_workstage_code from uo_workstage_code_all within w_mat_mass_issue_return_confirm_master
end type
type gb_1 from so_groupbox within w_mat_mass_issue_return_confirm_master
end type
type gb_2 from so_groupbox within w_mat_mass_issue_return_confirm_master
end type
type gb_3 from so_groupbox within w_mat_mass_issue_return_confirm_master
end type
end forward

global type w_mat_mass_issue_return_confirm_master from w_main_root
integer width = 5609
integer height = 3172
string title = "Material Issue Return Master"
uo_dateset uo_dateset
uo_dateend uo_dateend
ddlb_item_code ddlb_item_code
st_3 st_3
st_4 st_4
rb_issue_list rb_issue_list
cb_set cb_set
st_14 st_14
sle_item_name sle_item_name
ddlb_mfs ddlb_mfs
st_5 st_5
rb_issue_history rb_issue_history
st_1 st_1
ddlb_workstage_code ddlb_workstage_code
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_mat_mass_issue_return_confirm_master w_mat_mass_issue_return_confirm_master

type variables
string ivs_preview_yn = 'N'
end variables

on w_mat_mass_issue_return_confirm_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.ddlb_item_code=create ddlb_item_code
this.st_3=create st_3
this.st_4=create st_4
this.rb_issue_list=create rb_issue_list
this.cb_set=create cb_set
this.st_14=create st_14
this.sle_item_name=create sle_item_name
this.ddlb_mfs=create ddlb_mfs
this.st_5=create st_5
this.rb_issue_history=create rb_issue_history
this.st_1=create st_1
this.ddlb_workstage_code=create ddlb_workstage_code
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.ddlb_item_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.rb_issue_list
this.Control[iCurrent+7]=this.cb_set
this.Control[iCurrent+8]=this.st_14
this.Control[iCurrent+9]=this.sle_item_name
this.Control[iCurrent+10]=this.ddlb_mfs
this.Control[iCurrent+11]=this.st_5
this.Control[iCurrent+12]=this.rb_issue_history
this.Control[iCurrent+13]=this.st_1
this.Control[iCurrent+14]=this.ddlb_workstage_code
this.Control[iCurrent+15]=this.gb_1
this.Control[iCurrent+16]=this.gb_2
this.Control[iCurrent+17]=this.gb_3
end on

on w_mat_mass_issue_return_confirm_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.ddlb_item_code)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.rb_issue_list)
destroy(this.cb_set)
destroy(this.st_14)
destroy(this.sle_item_name)
destroy(this.ddlb_mfs)
destroy(this.st_5)
destroy(this.rb_issue_history)
destroy(this.st_1)
destroy(this.ddlb_workstage_code)
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
	
			if rb_issue_list.checked = true then 
			    dw_1.retrieve( uo_dateset.text() , uo_dateend.text(),  ddlb_mfs.text+'%' ,ddlb_workstage_code.getcode()+'%' ,  ddlb_item_code.text() + '%', gvi_organization_id)
			else
			    dw_4.retrieve( uo_dateset.text() , uo_dateend.text(),  ddlb_mfs.text+'%' , ddlb_workstage_code.getcode()+'%' ,ddlb_item_code.text() + '%',   gvi_organization_id)
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
		
			IF dw_2.UPDATE() < 0   THEN
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

type dw_5 from w_main_root`dw_5 within w_mat_mass_issue_return_confirm_master
integer y = 316
integer width = 489
integer height = 372
integer taborder = 0
boolean titlebar = true
end type

type dw_4 from w_main_root`dw_4 within w_mat_mass_issue_return_confirm_master
integer y = 316
integer width = 4544
integer height = 1288
integer taborder = 0
boolean titlebar = true
string title = "Material Issue Return History"
string dataobject = "d_mat_issue_4_return_history_lst"
end type

event dw_4::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 

dw_5.retrieve( this.object.mfs[currentrow] , '%' ,  'N' , Gvi_organization_id )
f_dual_lang_change_dwtext(dw_5)

DataWindowChild	state_child_1,state_child_2
dw_5.GetChild('dw_1', state_child_1)
dw_5.GetChild('dw_2', state_child_2)

F_CHILD_DW1_REPORT(state_child_1, 'customer_code', string(gvi_organization_id))
F_CHILD_DW1_REPORT(state_child_2, 'customer_code', string(gvi_organization_id))
F_CHILD_DW1_REPORT(state_child_1, 'workstage_code', string(gvi_organization_id))
F_CHILD_DW1_REPORT(state_child_2, 'workstage_code', string(gvi_organization_id))		
F_CHILD_DW1_REPORT(state_child_1, 'dest_workstage_code', string(gvi_organization_id))
F_CHILD_DW1_REPORT(state_child_2, 'dest_workstage_code', string(gvi_organization_id))		
end event

type dw_3 from w_main_root`dw_3 within w_mat_mass_issue_return_confirm_master
integer x = 2272
integer y = 1608
integer width = 2267
integer height = 752
integer taborder = 0
boolean titlebar = true
string title = "Current Inventory List"
string dataobject = "d_mat_current_inventory_4_issue_lst_tree"
end type

type dw_2 from w_main_root`dw_2 within w_mat_mass_issue_return_confirm_master
integer y = 1608
integer width = 2267
integer height = 752
integer taborder = 0
boolean titlebar = true
string title = "Material Issue Return List"
string dataobject = "d_mat_mass_issue_return_lst"
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

type dw_1 from w_main_root`dw_1 within w_mat_mass_issue_return_confirm_master
integer y = 316
integer width = 4544
integer height = 1288
integer taborder = 0
boolean titlebar = true
string title = "Material Issue Return Confirm List"
string dataobject = "d_mat_issue_4_return_confirm_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return
dw_2.retrieve( this.object.mfs[currentrow] , this.object.item_code[currentrow] , gvi_organization_id )
dw_3.retrieve( this.object.item_code[currentrow] ,  this.object.line_type[currentrow]  , gvi_organization_id )

end event

event dw_1::itemchanged;call super::itemchanged;if dwo.name = 'new_return_qty' then 
	
	if dec(this.object.issue_qty[row] ) - abs(dec(this.object.issue_return_qty[row])) <  abs(Dec(data)) then 
              this.object.new_return_qty[row]  = 0
		return 1
	end if
	
end if 
end event

type uo_dateset from uo_ymd_calendar within w_mat_mass_issue_return_confirm_master
event destroy ( )
integer x = 763
integer y = 160
integer taborder = 10
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_mass_issue_return_confirm_master
event destroy ( )
integer x = 1179
integer y = 160
integer taborder = 20
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_item_code from uo_item_code within w_mat_mass_issue_return_confirm_master
integer x = 2587
integer y = 160
integer width = 411
integer height = 676
integer taborder = 40
boolean bringtotop = true
end type

type st_3 from so_statictext within w_mat_mass_issue_return_confirm_master
integer x = 2587
integer y = 80
integer width = 411
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type st_4 from so_statictext within w_mat_mass_issue_return_confirm_master
integer x = 768
integer y = 80
integer width = 814
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Issue Date"
end type

type rb_issue_list from so_radiobutton within w_mat_mass_issue_return_confirm_master
integer x = 41
integer y = 72
integer width = 645
boolean bringtotop = true
integer weight = 700
string text = "Material Issue List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1

end event

type cb_set from so_commandbutton within w_mat_mass_issue_return_confirm_master
integer x = 3520
integer y = 104
integer width = 475
integer height = 112
integer taborder = 70
boolean bringtotop = true
string text = "Batch Confirm"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 
if dw_1.rowcount() < 1 then return 
long  i , j , lvl_issue_sequence
Datetime lvdt_issue_date 
String lvs_mfs
Decimal lvf_return_qty

dw_1.accepttext()

msg = f_msgbox1(1161,this.text)
if msg = 1 then 
else 
	return 
end if 

do
	i++
    if dw_1.object.check_yn[i] = 'Y' then 
    else
		continue
	end if
		lvs_mfs = dw_1.object.mfs[i]	
		lvdt_issue_date = dw_1.object.issue_date[i]
		lvl_issue_sequence = dw_1.object.issue_sequence[i]
		lvf_return_qty = dec(dw_1.object.new_return_qty[i])
	
		if f_mat_issue_return_confirm ( lvs_mfs , lvdt_issue_date ,  lvl_issue_sequence ,lvf_return_qty ) < 0 then 
		   rollback;
		   return
		end if
	j++
loop until i = dw_1.rowcount()

if j > 0 then 
	commit ;
	f_msgbox(170)
	f_retrieve()
else
	Rollback;
	Return
end if
end event

type st_14 from so_statictext within w_mat_mass_issue_return_confirm_master
integer x = 3003
integer y = 80
integer width = 439
integer height = 72
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Item Name"
end type

type sle_item_name from so_singlelineedit within w_mat_mass_issue_return_confirm_master
integer x = 3003
integer y = 160
integer width = 439
integer height = 84
integer taborder = 50
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

type ddlb_mfs from uo_mfs_this_month within w_mat_mass_issue_return_confirm_master
integer x = 1600
integer y = 160
integer width = 434
integer taborder = 30
boolean bringtotop = true
end type

type st_5 from so_statictext within w_mat_mass_issue_return_confirm_master
integer x = 1600
integer y = 80
integer width = 434
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "MFS"
end type

type rb_issue_history from so_radiobutton within w_mat_mass_issue_return_confirm_master
integer x = 41
integer y = 176
integer width = 645
boolean bringtotop = true
integer weight = 700
string text = "Material Issue History"
end type

event clicked;call super::clicked;dw_4.bringtotop = true 
selected_data_window = dw_4

end event

type st_1 from so_statictext within w_mat_mass_issue_return_confirm_master
integer x = 2039
integer y = 92
integer width = 535
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Workstage Code"
end type

type ddlb_workstage_code from uo_workstage_code_all within w_mat_mass_issue_return_confirm_master
integer x = 2039
integer y = 160
integer width = 539
integer taborder = 50
boolean bringtotop = true
end type

type gb_1 from so_groupbox within w_mat_mass_issue_return_confirm_master
integer width = 722
integer height = 300
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_2 from so_groupbox within w_mat_mass_issue_return_confirm_master
integer x = 731
integer width = 2743
integer height = 300
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_mat_mass_issue_return_confirm_master
integer x = 3479
integer width = 544
integer height = 300
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

