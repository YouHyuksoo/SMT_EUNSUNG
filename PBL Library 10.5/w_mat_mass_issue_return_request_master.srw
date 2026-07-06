HA$PBExportHeader$w_mat_mass_issue_return_request_master.srw
$PBExportComments$Material Mass Issue Return Master
forward
global type w_mat_mass_issue_return_request_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mat_mass_issue_return_request_master
end type
type uo_dateend from uo_ymd_calendar within w_mat_mass_issue_return_request_master
end type
type ddlb_item_code from uo_item_code within w_mat_mass_issue_return_request_master
end type
type st_3 from so_statictext within w_mat_mass_issue_return_request_master
end type
type st_4 from so_statictext within w_mat_mass_issue_return_request_master
end type
type rb_issue_list from so_radiobutton within w_mat_mass_issue_return_request_master
end type
type cb_request from so_commandbutton within w_mat_mass_issue_return_request_master
end type
type cb_preview from so_commandbutton within w_mat_mass_issue_return_request_master
end type
type cbx_dialog from so_checkbox within w_mat_mass_issue_return_request_master
end type
type em_copy from so_editmask within w_mat_mass_issue_return_request_master
end type
type st_2 from so_statictext within w_mat_mass_issue_return_request_master
end type
type cb_print from so_commandbutton within w_mat_mass_issue_return_request_master
end type
type st_14 from so_statictext within w_mat_mass_issue_return_request_master
end type
type sle_item_name from so_singlelineedit within w_mat_mass_issue_return_request_master
end type
type ddlb_mfs from uo_mfs_this_month within w_mat_mass_issue_return_request_master
end type
type st_5 from so_statictext within w_mat_mass_issue_return_request_master
end type
type cb_2 from so_commandbutton within w_mat_mass_issue_return_request_master
end type
type rb_issue_history from so_radiobutton within w_mat_mass_issue_return_request_master
end type
type st_1 from so_statictext within w_mat_mass_issue_return_request_master
end type
type ddlb_workstage_code from uo_workstage_code_all within w_mat_mass_issue_return_request_master
end type
type sle_group_no from so_singlelineedit within w_mat_mass_issue_return_request_master
end type
type cb_group_no from so_commandbutton within w_mat_mass_issue_return_request_master
end type
type st_6 from so_statictext within w_mat_mass_issue_return_request_master
end type
type cb_cancel from so_commandbutton within w_mat_mass_issue_return_request_master
end type
type gb_1 from so_groupbox within w_mat_mass_issue_return_request_master
end type
type gb_2 from so_groupbox within w_mat_mass_issue_return_request_master
end type
type gb_3 from so_groupbox within w_mat_mass_issue_return_request_master
end type
type gb_6 from so_groupbox within w_mat_mass_issue_return_request_master
end type
end forward

global type w_mat_mass_issue_return_request_master from w_main_root
integer width = 5609
integer height = 3172
string title = "Material Issue Return Master"
uo_dateset uo_dateset
uo_dateend uo_dateend
ddlb_item_code ddlb_item_code
st_3 st_3
st_4 st_4
rb_issue_list rb_issue_list
cb_request cb_request
cb_preview cb_preview
cbx_dialog cbx_dialog
em_copy em_copy
st_2 st_2
cb_print cb_print
st_14 st_14
sle_item_name sle_item_name
ddlb_mfs ddlb_mfs
st_5 st_5
cb_2 cb_2
rb_issue_history rb_issue_history
st_1 st_1
ddlb_workstage_code ddlb_workstage_code
sle_group_no sle_group_no
cb_group_no cb_group_no
st_6 st_6
cb_cancel cb_cancel
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_6 gb_6
end type
global w_mat_mass_issue_return_request_master w_mat_mass_issue_return_request_master

type variables
string ivs_preview_yn = 'N'
end variables

on w_mat_mass_issue_return_request_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.ddlb_item_code=create ddlb_item_code
this.st_3=create st_3
this.st_4=create st_4
this.rb_issue_list=create rb_issue_list
this.cb_request=create cb_request
this.cb_preview=create cb_preview
this.cbx_dialog=create cbx_dialog
this.em_copy=create em_copy
this.st_2=create st_2
this.cb_print=create cb_print
this.st_14=create st_14
this.sle_item_name=create sle_item_name
this.ddlb_mfs=create ddlb_mfs
this.st_5=create st_5
this.cb_2=create cb_2
this.rb_issue_history=create rb_issue_history
this.st_1=create st_1
this.ddlb_workstage_code=create ddlb_workstage_code
this.sle_group_no=create sle_group_no
this.cb_group_no=create cb_group_no
this.st_6=create st_6
this.cb_cancel=create cb_cancel
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_6=create gb_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.ddlb_item_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.rb_issue_list
this.Control[iCurrent+7]=this.cb_request
this.Control[iCurrent+8]=this.cb_preview
this.Control[iCurrent+9]=this.cbx_dialog
this.Control[iCurrent+10]=this.em_copy
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.cb_print
this.Control[iCurrent+13]=this.st_14
this.Control[iCurrent+14]=this.sle_item_name
this.Control[iCurrent+15]=this.ddlb_mfs
this.Control[iCurrent+16]=this.st_5
this.Control[iCurrent+17]=this.cb_2
this.Control[iCurrent+18]=this.rb_issue_history
this.Control[iCurrent+19]=this.st_1
this.Control[iCurrent+20]=this.ddlb_workstage_code
this.Control[iCurrent+21]=this.sle_group_no
this.Control[iCurrent+22]=this.cb_group_no
this.Control[iCurrent+23]=this.st_6
this.Control[iCurrent+24]=this.cb_cancel
this.Control[iCurrent+25]=this.gb_1
this.Control[iCurrent+26]=this.gb_2
this.Control[iCurrent+27]=this.gb_3
this.Control[iCurrent+28]=this.gb_6
end on

on w_mat_mass_issue_return_request_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.ddlb_item_code)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.rb_issue_list)
destroy(this.cb_request)
destroy(this.cb_preview)
destroy(this.cbx_dialog)
destroy(this.em_copy)
destroy(this.st_2)
destroy(this.cb_print)
destroy(this.st_14)
destroy(this.sle_item_name)
destroy(this.ddlb_mfs)
destroy(this.st_5)
destroy(this.cb_2)
destroy(this.rb_issue_history)
destroy(this.st_1)
destroy(this.ddlb_workstage_code)
destroy(this.sle_group_no)
destroy(this.cb_group_no)
destroy(this.st_6)
destroy(this.cb_cancel)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_6)
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
			dw_4.reset()			
	
			if rb_issue_list.checked = true then 
			    dw_1.retrieve( uo_dateset.text() , uo_dateend.text(),  ddlb_mfs.text+'%' ,ddlb_workstage_code.getcode()+'%' ,  ddlb_item_code.text() + '%', 'M001',  gvi_organization_id)
			else
			    dw_4.retrieve( sle_group_no.text+'%' ,  ddlb_item_code.text() + '%',   gvi_organization_id)
			end if
				
//	case 'DELETE'
//		
//		  	if dw_2.AcceptText() = -1 then
//				return
//			end if
//			
//			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
//			IF MSG = 1 THEN
//				Gvl_row_deleted = dw_2.GetRow()			
//				dw_2.DELETEROW(Gvl_row_deleted)		
//				dw_2.SetFocus()
//				ROW = dw_2.GetRow()
//				dw_2.ScrollToRow(row)
//				dw_2.SetColumn(1)
//				
//				IF dw_2.UPDATE() < 0   THEN
//					 ROLLBACK;
//				ELSE
//					 COMMIT;
//					 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
//				END IF
//				
//			END IF
		
		
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

type dw_5 from w_main_root`dw_5 within w_mat_mass_issue_return_request_master
integer y = 500
integer width = 4544
integer height = 1288
integer taborder = 0
boolean titlebar = true
string title = "Material Issue Return Request Invoice"
string dataobject = "d_mat_material_issue_return_request_invoice_rpt"
end type

type dw_4 from w_main_root`dw_4 within w_mat_mass_issue_return_request_master
integer y = 500
integer width = 4544
integer height = 1288
integer taborder = 0
boolean titlebar = true
string title = "Material Issue Return Request History"
string dataobject = "d_mat_mass_issue_return_request_hst"
end type

type dw_3 from w_main_root`dw_3 within w_mat_mass_issue_return_request_master
integer x = 2272
integer y = 1796
integer width = 2267
integer height = 752
integer taborder = 0
boolean titlebar = true
string title = "Current Inventory List"
string dataobject = "d_mat_current_inventory_4_issue_lst_tree"
end type

type dw_2 from w_main_root`dw_2 within w_mat_mass_issue_return_request_master
integer y = 1796
integer width = 2267
integer height = 752
integer taborder = 0
boolean titlebar = true
string title = "Material Issue Return Request List"
string dataobject = "d_mat_mass_issue_return_request_lst"
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

type dw_1 from w_main_root`dw_1 within w_mat_mass_issue_return_request_master
integer y = 500
integer width = 4544
integer height = 1288
integer taborder = 0
boolean titlebar = true
string title = "Material Issue List"
string dataobject = "d_mat_issue_4_return_lst"
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

type uo_dateset from uo_ymd_calendar within w_mat_mass_issue_return_request_master
event destroy ( )
integer x = 763
integer y = 160
integer taborder = 10
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_mass_issue_return_request_master
event destroy ( )
integer x = 1179
integer y = 160
integer taborder = 20
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_item_code from uo_item_code within w_mat_mass_issue_return_request_master
integer x = 2587
integer y = 160
integer width = 411
integer height = 676
integer taborder = 40
boolean bringtotop = true
end type

type st_3 from so_statictext within w_mat_mass_issue_return_request_master
integer x = 2587
integer y = 80
integer width = 411
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type st_4 from so_statictext within w_mat_mass_issue_return_request_master
integer x = 768
integer y = 80
integer width = 814
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Issue Date"
end type

type rb_issue_list from so_radiobutton within w_mat_mass_issue_return_request_master
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

cb_preview.enabled = false
cb_print.enabled = false

cb_request.enabled = true
cb_cancel.enabled = false
end event

type cb_request from so_commandbutton within w_mat_mass_issue_return_request_master
integer x = 2967
integer y = 364
integer width = 475
integer height = 112
integer taborder = 70
boolean bringtotop = true
string text = "Batch Request"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 
if dw_1.rowcount() < 1 then return 
long  i , j , lvl_issue_sequence
Datetime lvdt_issue_date 
String lvs_mfs , lvs_grouo_no
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
	
		if sle_group_no.text	= '' or isnull(sle_group_no.text) then
			
			cb_group_no.triggerevent(clicked!)
			
		end if		
		lvs_grouo_no = sle_group_no.text		
		if f_mat_issue_return_request ( lvs_mfs , lvdt_issue_date ,  lvl_issue_sequence ,lvf_return_qty , lvs_grouo_no ) < 0 then 
		   rollback;
		   return
		end if
	j++
loop until i = dw_1.rowcount()

if j > 0 then 
	msg = f_msgbox(1170)
	if msg = 1 then
		commit ;
		f_msgbox(170)
		f_retrieve()
	else
		rollback;
		return
	end if 
else
	Rollback;
	Return
end if
end event

type cb_preview from so_commandbutton within w_mat_mass_issue_return_request_master
integer x = 1285
integer y = 364
integer width = 384
integer height = 112
boolean bringtotop = true
string text = "Preview"
end type

event clicked;call super::clicked;SETPOINTER(HOURGLASS!)

if dw_4.getrow( ) < 1 then return

	if  ivs_preview_yn = 'Y' THEN 
		ivs_preview_yn = 'N' 	
		dw_4.bringtotop = TRUE
	else
		ivs_preview_yn = 'Y' 	
		dw_5.bringtotop = TRUE		
		
		
		dw_5.retrieve( dw_4.object.request_group_no[dw_4.getrow()] ,'%'  , gvi_organization_id  )
		
		
		if dw_5.Describe("DataWindow.Print.Preview") = '!' then
		else
			 dw_5.Modify("DataWindow.Print.Preview=yes")
			dw_5.Modify("DataWindow.Print.Preview.Rulers=yes")
		end if		
	end if

end event

type cbx_dialog from so_checkbox within w_mat_mass_issue_return_request_master
integer x = 846
integer y = 372
integer width = 421
boolean bringtotop = true
integer weight = 700
string text = "Show Dialog"
end type

type em_copy from so_editmask within w_mat_mass_issue_return_request_master
integer x = 448
integer y = 376
integer width = 320
boolean bringtotop = true
string text = "1"
string mask = "##0"
boolean spin = true
end type

type st_2 from so_statictext within w_mat_mass_issue_return_request_master
integer x = 41
integer y = 388
integer width = 343
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Print Copy"
alignment alignment = right!
end type

type cb_print from so_commandbutton within w_mat_mass_issue_return_request_master
integer x = 1673
integer y = 364
integer width = 384
integer height = 112
boolean bringtotop = true
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

type st_14 from so_statictext within w_mat_mass_issue_return_request_master
integer x = 3008
integer y = 80
integer width = 439
integer height = 72
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Item Name"
end type

type sle_item_name from so_singlelineedit within w_mat_mass_issue_return_request_master
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

type ddlb_mfs from uo_mfs_this_month within w_mat_mass_issue_return_request_master
integer x = 1600
integer y = 160
integer width = 434
integer taborder = 30
boolean bringtotop = true
end type

type st_5 from so_statictext within w_mat_mass_issue_return_request_master
integer x = 1600
integer y = 80
integer width = 434
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "MFS"
end type

type cb_2 from so_commandbutton within w_mat_mass_issue_return_request_master
integer x = 2062
integer y = 364
integer width = 384
integer height = 112
integer taborder = 70
boolean bringtotop = true
string text = "Show BOM"
end type

event clicked;string lvs_item_code

if dw_1.getrow() < 1 then return

lvs_item_code = dw_1.getitemstring( dw_1.getrow() , 'item_code' )
if lvs_item_code = '' or isnull(lvs_item_code) then return

openwithparm( w_des_bom_query_popup , lvs_item_code )
end event

type rb_issue_history from so_radiobutton within w_mat_mass_issue_return_request_master
integer x = 41
integer y = 176
integer width = 645
boolean bringtotop = true
integer weight = 700
string text = "Return Request List"
end type

event clicked;call super::clicked;dw_4.bringtotop = true 
selected_data_window = dw_4


cb_preview.enabled = true
cb_print.enabled = true

cb_request.enabled = false
cb_cancel.enabled = true
end event

type st_1 from so_statictext within w_mat_mass_issue_return_request_master
integer x = 2039
integer y = 80
integer width = 535
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Workstage Code"
end type

type ddlb_workstage_code from uo_workstage_code_all within w_mat_mass_issue_return_request_master
integer x = 2039
integer y = 160
integer width = 539
integer taborder = 50
boolean bringtotop = true
end type

type sle_group_no from so_singlelineedit within w_mat_mass_issue_return_request_master
integer x = 3447
integer y = 160
integer height = 84
integer taborder = 100
boolean bringtotop = true
end type

type cb_group_no from so_commandbutton within w_mat_mass_issue_return_request_master
integer x = 2519
integer y = 364
integer width = 443
integer height = 112
integer taborder = 90
boolean bringtotop = true
string text = "Gen New Group"
end type

event clicked;call super::clicked;SLE_GROUP_NO.TEXT = STRING(F_T_SYSDATE(), 'yymmdd')+STRING(f_get_sequence( 'SEQ_CARRYING_OUT_GROUP' ))
end event

type st_6 from so_statictext within w_mat_mass_issue_return_request_master
integer x = 3451
integer y = 80
integer height = 72
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Request Group No"
end type

type cb_cancel from so_commandbutton within w_mat_mass_issue_return_request_master
integer x = 3447
integer y = 364
integer width = 475
integer height = 112
integer taborder = 80
boolean bringtotop = true
boolean enabled = false
string text = "Request Cancel"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 
if dw_4.rowcount() < 1 then return 
long  i , j , lvl_issue_sequence
Datetime lvdt_issue_date 


dw_4.accepttext()

msg = f_msgbox1(1161,this.text)
if msg = 1 then 
else 
	return 
end if 

do
	i++
    if dw_4.object.check_yn[i] = 'Y' then 
    else
		continue
	end if
	
		lvdt_issue_date = dw_4.object.issue_date[i]
		lvl_issue_sequence = dw_4.object.issue_sequence[i]
	
		if f_mat_issue_return_request_cancel ( lvdt_issue_date ,  lvl_issue_sequence ) < 0 then 
		   rollback;
		   return
		end if
	j++
loop until i = dw_4.rowcount()

if j > 0 then 
	msg = f_msgbox(1170)
	if msg = 1 then
		commit ;
		f_msgbox(170)
		f_retrieve()
	else
		rollback;
		return
	end if 
else
	Rollback;
	Return
end if
end event

type gb_1 from so_groupbox within w_mat_mass_issue_return_request_master
integer width = 722
integer height = 300
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_2 from so_groupbox within w_mat_mass_issue_return_request_master
integer x = 731
integer width = 3246
integer height = 300
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_mat_mass_issue_return_request_master
integer x = 2469
integer y = 304
integer width = 1509
integer height = 188
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_6 from so_groupbox within w_mat_mass_issue_return_request_master
integer y = 304
integer width = 2469
integer height = 188
integer weight = 700
long textcolor = 16711680
string text = "Issue Invoice Print"
end type

