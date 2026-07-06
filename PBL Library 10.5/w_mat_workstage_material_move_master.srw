HA$PBExportHeader$w_mat_workstage_material_move_master.srw
$PBExportComments$Material Current Inventory Master
forward
global type w_mat_workstage_material_move_master from w_main_root
end type
type st_1 from so_statictext within w_mat_workstage_material_move_master
end type
type ddlb_item_code from uo_item_code within w_mat_workstage_material_move_master
end type
type sle_item_name from so_singlelineedit within w_mat_workstage_material_move_master
end type
type st_14 from so_statictext within w_mat_workstage_material_move_master
end type
type sle_1 from so_singlelineedit within w_mat_workstage_material_move_master
end type
type st_2 from so_statictext within w_mat_workstage_material_move_master
end type
type st_3 from so_statictext within w_mat_workstage_material_move_master
end type
type st_4 from so_statictext within w_mat_workstage_material_move_master
end type
type st_6 from so_statictext within w_mat_workstage_material_move_master
end type
type cbx_dialog from so_checkbox within w_mat_workstage_material_move_master
end type
type em_copy from so_editmask within w_mat_workstage_material_move_master
end type
type cb_preview from so_commandbutton within w_mat_workstage_material_move_master
end type
type cb_print from so_commandbutton within w_mat_workstage_material_move_master
end type
type cb_1 from commandbutton within w_mat_workstage_material_move_master
end type
type ddlb_mfs from uo_mfs_workorder within w_mat_workstage_material_move_master
end type
type ddlb_workstage_code from uo_workstage_code_all within w_mat_workstage_material_move_master
end type
type cbx_date_fixed from so_checkbox within w_mat_workstage_material_move_master
end type
type cb_2 from commandbutton within w_mat_workstage_material_move_master
end type
type gb_1 from so_groupbox within w_mat_workstage_material_move_master
end type
type gb_2 from so_groupbox within w_mat_workstage_material_move_master
end type
type gb_6 from so_groupbox within w_mat_workstage_material_move_master
end type
end forward

global type w_mat_workstage_material_move_master from w_main_root
integer width = 4754
integer height = 3056
string title = "Material Workstage Translate"
st_1 st_1
ddlb_item_code ddlb_item_code
sle_item_name sle_item_name
st_14 st_14
sle_1 sle_1
st_2 st_2
st_3 st_3
st_4 st_4
st_6 st_6
cbx_dialog cbx_dialog
em_copy em_copy
cb_preview cb_preview
cb_print cb_print
cb_1 cb_1
ddlb_mfs ddlb_mfs
ddlb_workstage_code ddlb_workstage_code
cbx_date_fixed cbx_date_fixed
cb_2 cb_2
gb_1 gb_1
gb_2 gb_2
gb_6 gb_6
end type
global w_mat_workstage_material_move_master w_mat_workstage_material_move_master

type variables
string ivs_preview_yn
end variables

on w_mat_workstage_material_move_master.create
int iCurrent
call super::create
this.st_1=create st_1
this.ddlb_item_code=create ddlb_item_code
this.sle_item_name=create sle_item_name
this.st_14=create st_14
this.sle_1=create sle_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_6=create st_6
this.cbx_dialog=create cbx_dialog
this.em_copy=create em_copy
this.cb_preview=create cb_preview
this.cb_print=create cb_print
this.cb_1=create cb_1
this.ddlb_mfs=create ddlb_mfs
this.ddlb_workstage_code=create ddlb_workstage_code
this.cbx_date_fixed=create cbx_date_fixed
this.cb_2=create cb_2
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_6=create gb_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.ddlb_item_code
this.Control[iCurrent+3]=this.sle_item_name
this.Control[iCurrent+4]=this.st_14
this.Control[iCurrent+5]=this.sle_1
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.st_6
this.Control[iCurrent+10]=this.cbx_dialog
this.Control[iCurrent+11]=this.em_copy
this.Control[iCurrent+12]=this.cb_preview
this.Control[iCurrent+13]=this.cb_print
this.Control[iCurrent+14]=this.cb_1
this.Control[iCurrent+15]=this.ddlb_mfs
this.Control[iCurrent+16]=this.ddlb_workstage_code
this.Control[iCurrent+17]=this.cbx_date_fixed
this.Control[iCurrent+18]=this.cb_2
this.Control[iCurrent+19]=this.gb_1
this.Control[iCurrent+20]=this.gb_2
this.Control[iCurrent+21]=this.gb_6
end on

on w_mat_workstage_material_move_master.destroy
call super::destroy
destroy(this.st_1)
destroy(this.ddlb_item_code)
destroy(this.sle_item_name)
destroy(this.st_14)
destroy(this.sle_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_6)
destroy(this.cbx_dialog)
destroy(this.em_copy)
destroy(this.cb_preview)
destroy(this.cb_print)
destroy(this.cb_1)
destroy(this.ddlb_mfs)
destroy(this.ddlb_workstage_code)
destroy(this.cbx_date_fixed)
destroy(this.cb_2)
destroy(this.gb_1)
destroy(this.gb_2)
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
Ivs_resize_type                      = 'MASTER_DETAIL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

ivs_dw_1_retrice_cancel_popup_open = 'Y'
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

end event

event ue_data_control;call super::ue_data_control;Long row
String lvs_date
choose case gvs_ue_data_control
		
	case 'RETRIEVE'			
		     dw_1.reset()
		     dw_2.reset()
			dw_3.reset()			 
			dw_1.retrieve(   ddlb_mfs.text+'%' ,ddlb_item_code.text()+'%' , ddlb_workstage_code.getcode( )+'%' , gvi_organization_id)
	case else
		
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mat_workstage_material_move_master
integer y = 524
integer width = 567
integer height = 448
end type

type dw_4 from w_main_root`dw_4 within w_mat_workstage_material_move_master
integer y = 524
integer width = 567
integer height = 448
boolean titlebar = true
end type

type dw_3 from w_main_root`dw_3 within w_mat_workstage_material_move_master
integer y = 524
integer width = 4544
integer height = 1188
boolean titlebar = true
string title = "Normal Invoice List"
string dataobject = "d_mat_workstage_move_invoice_rpt"
end type

type dw_2 from w_main_root`dw_2 within w_mat_workstage_material_move_master
integer y = 1708
integer width = 4544
integer height = 788
boolean titlebar = true
string title = "Material Move List"
string dataobject = "d_mat_workstage_receipt_4_move_receipt_lst"
end type

type dw_1 from w_main_root`dw_1 within w_mat_workstage_material_move_master
integer y = 524
integer width = 4544
integer height = 1188
boolean titlebar = true
string title = "Material Receipt List"
string dataobject = "d_mat_workstage_inventory_4_material_move_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return

dw_2.retrieve( dw_1.object.mfs[currentrow] , dw_1.object.item_code[currentrow] , dw_1.object.organization_id[currentrow] )
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_workstage_material_move_master
end type

type st_1 from so_statictext within w_mat_workstage_material_move_master
integer x = 1038
integer y = 108
integer width = 535
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_mat_workstage_material_move_master
integer x = 1038
integer y = 180
integer width = 535
integer taborder = 20
boolean bringtotop = true
end type

type sle_item_name from so_singlelineedit within w_mat_workstage_material_move_master
integer x = 1573
integer y = 180
integer width = 471
integer height = 84
integer taborder = 30
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

type st_14 from so_statictext within w_mat_workstage_material_move_master
integer x = 1573
integer y = 112
integer width = 471
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Item Name"
end type

type sle_1 from so_singlelineedit within w_mat_workstage_material_move_master
integer x = 2043
integer y = 180
integer width = 416
integer height = 84
integer taborder = 30
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

type st_2 from so_statictext within w_mat_workstage_material_move_master
integer x = 2043
integer y = 112
integer width = 416
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Item Spec"
end type

type st_3 from so_statictext within w_mat_workstage_material_move_master
integer x = 498
integer y = 112
integer width = 535
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Workstage Code"
end type

type st_4 from so_statictext within w_mat_workstage_material_move_master
integer x = 27
integer y = 116
integer width = 471
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "MFS"
end type

type st_6 from so_statictext within w_mat_workstage_material_move_master
integer x = 2565
integer y = 68
integer width = 329
integer height = 64
boolean bringtotop = true
integer weight = 700
string text = "Print Copy"
end type

type cbx_dialog from so_checkbox within w_mat_workstage_material_move_master
integer x = 2565
integer y = 228
integer width = 421
integer height = 64
boolean bringtotop = true
integer weight = 700
string text = "Show Dialog"
end type

type em_copy from so_editmask within w_mat_workstage_material_move_master
integer x = 2565
integer y = 136
integer width = 229
integer taborder = 60
boolean bringtotop = true
string text = "1"
string mask = "##0"
boolean spin = true
end type

type cb_preview from so_commandbutton within w_mat_workstage_material_move_master
integer x = 2985
integer y = 68
integer width = 379
integer height = 100
integer taborder = 70
boolean bringtotop = true
string text = "Preview"
end type

event clicked;call super::clicked;if dw_2.getrow() < 1 then 
	return
end if 

if  ivs_preview_yn = 'Y' THEN 
	ivs_preview_yn = 'N' 	
	dw_1.bringtotop = TRUE
else

DataWindowChild	state_child_1,state_child_2
	
	dw_3.retrieve( dw_2.object.mfs[dw_2.getrow()] ,  dw_2.object.invoice_no[dw_2.getrow()] , Gvi_organization_id  )
	f_dual_lang_change_dwtext(dw_3)
	
	
	dw_3.GetChild('dw_1', state_child_1)
	dw_3.GetChild('dw_2', state_child_2)
	
	F_CHILD_DW1_REPORT(state_child_1, 'takeover_by', string(gvi_organization_id))
	F_CHILD_DW1_REPORT(state_child_1, 'takeover_by', string(gvi_organization_id))	
	
	F_CHILD_DW1_REPORT(state_child_1, 'line_code', string(gvi_organization_id))
	F_CHILD_DW1_REPORT(state_child_1, 'line_code', string(gvi_organization_id))
	
	F_CHILD_DW1_REPORT(state_child_1, 'workstage_code', string(gvi_organization_id))
	F_CHILD_DW1_REPORT(state_child_1, 'workstage_code', string(gvi_organization_id))
	
	F_CHILD_DW1_REPORT(state_child_1, 'dest_workstage_code', string(gvi_organization_id))
	F_CHILD_DW1_REPORT(state_child_1, 'dest_workstage_code', string(gvi_organization_id))
		
	F_CHILD_DW1_REPORT(state_child_1, 'customer_code', string(gvi_organization_id))
	F_CHILD_DW1_REPORT(state_child_1, 'customer_code', string(gvi_organization_id))	
	
	F_CHILD_DW1_REPORT(state_child_2, 'takeover_by', string(gvi_organization_id))
	F_CHILD_DW1_REPORT(state_child_2, 'takeover_by', string(gvi_organization_id))	
	
	F_CHILD_DW1_REPORT(state_child_2, 'line_code', string(gvi_organization_id))
	F_CHILD_DW1_REPORT(state_child_2, 'line_code', string(gvi_organization_id))
	
	F_CHILD_DW1_REPORT(state_child_2, 'workstage_code', string(gvi_organization_id))
	F_CHILD_DW1_REPORT(state_child_2, 'workstage_code', string(gvi_organization_id))
	
	F_CHILD_DW1_REPORT(state_child_2, 'dest_workstage_code', string(gvi_organization_id))
	F_CHILD_DW1_REPORT(state_child_2, 'dest_workstage_code', string(gvi_organization_id))
		
	F_CHILD_DW1_REPORT(state_child_2, 'customer_code', string(gvi_organization_id))
	F_CHILD_DW1_REPORT(state_child_2, 'customer_code', string(gvi_organization_id))		
	
		
		ivs_preview_yn = 'Y' 	

			dw_3.bringtotop = TRUE			
			if dw_3.Describe("DataWindow.Print.Preview") = '!' or dw_3.Describe("DataWindow.Print.Preview") = '?' then
			else
				 dw_3.Modify("DataWindow.Print.Preview=yes")
				 dw_3.Modify("DataWindow.Print.Preview.Rulers=yes")
			end if		

		
	end if

end event

type cb_print from so_commandbutton within w_mat_workstage_material_move_master
integer x = 2985
integer y = 176
integer width = 379
integer height = 100
integer taborder = 100
boolean bringtotop = true
string text = "Print"
end type

event clicked;call super::clicked;Int		i, lvi_cnt , rows


		If dw_3.rowcount() < 1 Then Return		
		lvi_cnt = Integer(em_copy.text)
		If lvi_cnt > 0 Then		
				For i = 1 To lvi_cnt		
					if cbx_dialog.checked = true then 
						dw_3.print(false, True)
					else
						dw_3.print(false, False)						
					end if
				Next	
		End If

end event

type cb_1 from commandbutton within w_mat_workstage_material_move_master
integer x = 1253
integer y = 380
integer width = 489
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Move"
end type

event clicked;Long i , j , lvi_return
string lvs_rowid , lvs_dest_workstage_code , lvs_invoice_no , lvs_line_code , lvs_workstage_code , lvs_dest_line_code , lvs_date_fixed , lvs_item_type
datetime Lvdt_transfer_date
double Lvdb_transfer_sequence
decimal lvf_move_qty , lvf_move_weight , lvf_inventory_price

dw_1.accepttext( )

if dw_1.getrow( ) < 1 then 
	Messagebox( "Notify" , "Receipt data not found")
	return
end if

msg = f_msgbox1(1161 , this.text )
if msg = 1 then 
else
	return
end if

do
	i++
	if dw_1.object.check_yn[i] = 'Y' then 
		
		lvs_rowid = dw_1.object.rowid[i]
	else
		continue
	end if
	
//==========================================================================
//
//==========================================================================
	lvf_move_qty        = dw_1.object.move_qty[i]
//	lvf_move_weight   = dw_1.object.move_weight[i]
	
	lvs_dest_line_code= dw_1.object.dest_line_code[i]		
	lvs_dest_workstage_code = dw_1.object.dest_workstage_code[i]
	lvf_inventory_price = dw_1.object.inventory_price[i]
	lvdt_transfer_date = f_t_sysdate()
	lvdb_transfer_sequence = f_get_sequence(  'SEQ_WORKSTAGE_TRANSFER_SEQ' )
	lvs_invoice_no = string(F_GET_SEQUENCE('SEQ_ISSUE_INVOICE_SEQUENCE'))
	lvs_item_type = dw_1.object.item_type[i]
	 
	 if cbx_date_fixed.checked = true then 
		lvs_date_fixed = 'Y'
	 else
		lvs_date_fixed = 'N'		
	 end if 
	 
	lvi_return = f_mat_workstage_inventory_move( lvs_rowid ,lvs_invoice_no,  lvs_dest_line_code , lvs_dest_workstage_code , lvf_move_qty , lvs_item_type, lvf_inventory_price )
	
	if lvi_return < 0 then 
		Rollback;
		return
	end if
	
 j++	
loop until  i = dw_1.rowcount( )

if j > 0  then 
		commit ;		  
		f_msgbox(170) //$$HEX7$$00c8a5c718b4c8c5b5c2c8b2e4b2$$ENDHEX$$
else
	       rollback ;
		f_msg_mdi_help( f_msg_st( 9026) ) //$$HEX12$$98ccacb91cb4200074ac18c200ac2000c6c5b5c2c8b2e4b2$$ENDHEX$$.
end if
end event

type ddlb_mfs from uo_mfs_workorder within w_mat_workstage_material_move_master
integer x = 27
integer y = 184
integer width = 466
integer taborder = 20
boolean bringtotop = true
end type

type ddlb_workstage_code from uo_workstage_code_all within w_mat_workstage_material_move_master
integer x = 503
integer y = 184
integer width = 526
integer taborder = 30
boolean bringtotop = true
end type

type cbx_date_fixed from so_checkbox within w_mat_workstage_material_move_master
integer x = 37
integer y = 388
integer width = 567
boolean bringtotop = true
integer weight = 700
string text = "Receipt Date Fixed"
end type

type cb_2 from commandbutton within w_mat_workstage_material_move_master
integer x = 686
integer y = 380
integer width = 562
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Show WS Inventory"
end type

event clicked;if dw_1.getrow() < 1 then 
	return
end if
openwithparm(w_mat_item_workstage_inventory_popup , string(dw_1.object.item_code[dw_1.getrow()] ))
end event

type gb_1 from so_groupbox within w_mat_workstage_material_move_master
integer y = 4
integer width = 2487
integer height = 320
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Translate Where Condition"
end type

type gb_2 from so_groupbox within w_mat_workstage_material_move_master
integer y = 336
integer width = 1765
integer height = 172
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_6 from so_groupbox within w_mat_workstage_material_move_master
integer x = 2514
integer width = 896
integer height = 320
integer taborder = 50
integer weight = 700
long textcolor = 16711680
string text = "Print Copy"
end type

