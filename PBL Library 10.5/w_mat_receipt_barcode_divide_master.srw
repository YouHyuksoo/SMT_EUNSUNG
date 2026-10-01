HA$PBExportHeader$w_mat_receipt_barcode_divide_master.srw
$PBExportComments$Material Mass Issue Return Master
forward
global type w_mat_receipt_barcode_divide_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mat_receipt_barcode_divide_master
end type
type uo_dateend from uo_ymd_calendar within w_mat_receipt_barcode_divide_master
end type
type ddlb_item_code from uo_item_code within w_mat_receipt_barcode_divide_master
end type
type st_3 from so_statictext within w_mat_receipt_barcode_divide_master
end type
type st_4 from so_statictext within w_mat_receipt_barcode_divide_master
end type
type st_1 from so_statictext within w_mat_receipt_barcode_divide_master
end type
type st_status from so_statictext within w_mat_receipt_barcode_divide_master
end type
type sle_item_barcode from so_singlelineedit within w_mat_receipt_barcode_divide_master
end type
type sle_total_qty from so_singlelineedit within w_mat_receipt_barcode_divide_master
end type
type st_7 from so_statictext within w_mat_receipt_barcode_divide_master
end type
type cbx_auto_print from so_checkbox within w_mat_receipt_barcode_divide_master
end type
type sle_slip_no_condition from so_singlelineedit within w_mat_receipt_barcode_divide_master
end type
type st_9 from so_statictext within w_mat_receipt_barcode_divide_master
end type
type pb_1 from so_commandbutton within w_mat_receipt_barcode_divide_master
end type
type rb_tray from so_radiobutton within w_mat_receipt_barcode_divide_master
end type
type rb_reel from so_radiobutton within w_mat_receipt_barcode_divide_master
end type
type cb_divide from commandbutton within w_mat_receipt_barcode_divide_master
end type
type sle_item_code from so_singlelineedit within w_mat_receipt_barcode_divide_master
end type
type st_5 from so_statictext within w_mat_receipt_barcode_divide_master
end type
type ddlb_receipt_type from uo_basecode within w_mat_receipt_barcode_divide_master
end type
type st_2 from so_statictext within w_mat_receipt_barcode_divide_master
end type
type sle_qty from so_singlelineedit within w_mat_receipt_barcode_divide_master
end type
type sle_lot_no from so_singlelineedit within w_mat_receipt_barcode_divide_master
end type
type st_6 from so_statictext within w_mat_receipt_barcode_divide_master
end type
type rb_barcode_list from so_radiobutton within w_mat_receipt_barcode_divide_master
end type
type rb_2 from so_radiobutton within w_mat_receipt_barcode_divide_master
end type
type pb_2 from so_commandbutton within w_mat_receipt_barcode_divide_master
end type
type cbx_reel_divide_compare_yn from so_checkbox within w_mat_receipt_barcode_divide_master
end type
type sle_supplier_barcode from so_singlelineedit within w_mat_receipt_barcode_divide_master
end type
type sle_our_barcode from so_singlelineedit within w_mat_receipt_barcode_divide_master
end type
type st_8 from so_statictext within w_mat_receipt_barcode_divide_master
end type
type st_10 from so_statictext within w_mat_receipt_barcode_divide_master
end type
type st_divide_reason from so_statictext within w_mat_receipt_barcode_divide_master
end type
type sle_divide_reason from so_singlelineedit within w_mat_receipt_barcode_divide_master
end type
type cbx_1 from so_checkbox within w_mat_receipt_barcode_divide_master
end type
type dw_6 from so_datawindow within w_mat_receipt_barcode_divide_master
end type
type cbx_lg from so_checkbox within w_mat_receipt_barcode_divide_master
end type
type cbx_msl from so_checkbox within w_mat_receipt_barcode_divide_master
end type
type gb_1 from so_groupbox within w_mat_receipt_barcode_divide_master
end type
type gb_3 from so_groupbox within w_mat_receipt_barcode_divide_master
end type
type gb_4 from so_groupbox within w_mat_receipt_barcode_divide_master
end type
type gb_5 from so_groupbox within w_mat_receipt_barcode_divide_master
end type
type gb_2 from so_groupbox within w_mat_receipt_barcode_divide_master
end type
type gb_6 from so_groupbox within w_mat_receipt_barcode_divide_master
end type
type dw_7 from so_datawindow within w_mat_receipt_barcode_divide_master
end type
end forward

global type w_mat_receipt_barcode_divide_master from w_main_root
integer width = 5211
integer height = 2856
string title = "Material Reel Divide Master"
windowstate windowstate = maximized!
string ivs_dw_2_retrice_cancel_popup_open = "N"
string ivs_dw_3_retrice_cancel_popup_open = "N"
string ivs_dw_4_retrice_cancel_popup_open = "N"
string ivs_dw_5_retrice_cancel_popup_open = "N"
uo_dateset uo_dateset
uo_dateend uo_dateend
ddlb_item_code ddlb_item_code
st_3 st_3
st_4 st_4
st_1 st_1
st_status st_status
sle_item_barcode sle_item_barcode
sle_total_qty sle_total_qty
st_7 st_7
cbx_auto_print cbx_auto_print
sle_slip_no_condition sle_slip_no_condition
st_9 st_9
pb_1 pb_1
rb_tray rb_tray
rb_reel rb_reel
cb_divide cb_divide
sle_item_code sle_item_code
st_5 st_5
ddlb_receipt_type ddlb_receipt_type
st_2 st_2
sle_qty sle_qty
sle_lot_no sle_lot_no
st_6 st_6
rb_barcode_list rb_barcode_list
rb_2 rb_2
pb_2 pb_2
cbx_reel_divide_compare_yn cbx_reel_divide_compare_yn
sle_supplier_barcode sle_supplier_barcode
sle_our_barcode sle_our_barcode
st_8 st_8
st_10 st_10
st_divide_reason st_divide_reason
sle_divide_reason sle_divide_reason
cbx_1 cbx_1
dw_6 dw_6
cbx_lg cbx_lg
cbx_msl cbx_msl
gb_1 gb_1
gb_3 gb_3
gb_4 gb_4
gb_5 gb_5
gb_2 gb_2
gb_6 gb_6
dw_7 dw_7
end type
global w_mat_receipt_barcode_divide_master w_mat_receipt_barcode_divide_master

type variables
string lvs_receipt_lot_no_org ,  lvs_origin_lot_no , lvs_supplier_code  
STRING LVS_FROM_SUPPLIER_CODE , lvs_slip_no , lvs_receipt_lot_no , lvs_mark , lvs_item_code , lvs_line_type  , LVS_LABEL_TYPE
STRING lvs_our_barcode , lvs_receipt_type , LVS_RECEIPT_COMPARE_YN , LVS_ISSUE_COMPARE_YN , lvs_location_code
Long  LVL_QTY,  i , ivl_divide_qty[] , lvl_row , lvl_pos1 , lvl_pos2 , lvl_pos3 , lvl_check_Pos , lvl_reel_qty , lvl_total_qty , lvl_issue_qty

double lvdb_receipt_lot_no , lvdb_lot_divide_sequence


end variables

on w_mat_receipt_barcode_divide_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.ddlb_item_code=create ddlb_item_code
this.st_3=create st_3
this.st_4=create st_4
this.st_1=create st_1
this.st_status=create st_status
this.sle_item_barcode=create sle_item_barcode
this.sle_total_qty=create sle_total_qty
this.st_7=create st_7
this.cbx_auto_print=create cbx_auto_print
this.sle_slip_no_condition=create sle_slip_no_condition
this.st_9=create st_9
this.pb_1=create pb_1
this.rb_tray=create rb_tray
this.rb_reel=create rb_reel
this.cb_divide=create cb_divide
this.sle_item_code=create sle_item_code
this.st_5=create st_5
this.ddlb_receipt_type=create ddlb_receipt_type
this.st_2=create st_2
this.sle_qty=create sle_qty
this.sle_lot_no=create sle_lot_no
this.st_6=create st_6
this.rb_barcode_list=create rb_barcode_list
this.rb_2=create rb_2
this.pb_2=create pb_2
this.cbx_reel_divide_compare_yn=create cbx_reel_divide_compare_yn
this.sle_supplier_barcode=create sle_supplier_barcode
this.sle_our_barcode=create sle_our_barcode
this.st_8=create st_8
this.st_10=create st_10
this.st_divide_reason=create st_divide_reason
this.sle_divide_reason=create sle_divide_reason
this.cbx_1=create cbx_1
this.dw_6=create dw_6
this.cbx_lg=create cbx_lg
this.cbx_msl=create cbx_msl
this.gb_1=create gb_1
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_5=create gb_5
this.gb_2=create gb_2
this.gb_6=create gb_6
this.dw_7=create dw_7
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.ddlb_item_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.st_status
this.Control[iCurrent+8]=this.sle_item_barcode
this.Control[iCurrent+9]=this.sle_total_qty
this.Control[iCurrent+10]=this.st_7
this.Control[iCurrent+11]=this.cbx_auto_print
this.Control[iCurrent+12]=this.sle_slip_no_condition
this.Control[iCurrent+13]=this.st_9
this.Control[iCurrent+14]=this.pb_1
this.Control[iCurrent+15]=this.rb_tray
this.Control[iCurrent+16]=this.rb_reel
this.Control[iCurrent+17]=this.cb_divide
this.Control[iCurrent+18]=this.sle_item_code
this.Control[iCurrent+19]=this.st_5
this.Control[iCurrent+20]=this.ddlb_receipt_type
this.Control[iCurrent+21]=this.st_2
this.Control[iCurrent+22]=this.sle_qty
this.Control[iCurrent+23]=this.sle_lot_no
this.Control[iCurrent+24]=this.st_6
this.Control[iCurrent+25]=this.rb_barcode_list
this.Control[iCurrent+26]=this.rb_2
this.Control[iCurrent+27]=this.pb_2
this.Control[iCurrent+28]=this.cbx_reel_divide_compare_yn
this.Control[iCurrent+29]=this.sle_supplier_barcode
this.Control[iCurrent+30]=this.sle_our_barcode
this.Control[iCurrent+31]=this.st_8
this.Control[iCurrent+32]=this.st_10
this.Control[iCurrent+33]=this.st_divide_reason
this.Control[iCurrent+34]=this.sle_divide_reason
this.Control[iCurrent+35]=this.cbx_1
this.Control[iCurrent+36]=this.dw_6
this.Control[iCurrent+37]=this.cbx_lg
this.Control[iCurrent+38]=this.cbx_msl
this.Control[iCurrent+39]=this.gb_1
this.Control[iCurrent+40]=this.gb_3
this.Control[iCurrent+41]=this.gb_4
this.Control[iCurrent+42]=this.gb_5
this.Control[iCurrent+43]=this.gb_2
this.Control[iCurrent+44]=this.gb_6
this.Control[iCurrent+45]=this.dw_7
end on

on w_mat_receipt_barcode_divide_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.ddlb_item_code)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_1)
destroy(this.st_status)
destroy(this.sle_item_barcode)
destroy(this.sle_total_qty)
destroy(this.st_7)
destroy(this.cbx_auto_print)
destroy(this.sle_slip_no_condition)
destroy(this.st_9)
destroy(this.pb_1)
destroy(this.rb_tray)
destroy(this.rb_reel)
destroy(this.cb_divide)
destroy(this.sle_item_code)
destroy(this.st_5)
destroy(this.ddlb_receipt_type)
destroy(this.st_2)
destroy(this.sle_qty)
destroy(this.sle_lot_no)
destroy(this.st_6)
destroy(this.rb_barcode_list)
destroy(this.rb_2)
destroy(this.pb_2)
destroy(this.cbx_reel_divide_compare_yn)
destroy(this.sle_supplier_barcode)
destroy(this.sle_our_barcode)
destroy(this.st_8)
destroy(this.st_10)
destroy(this.st_divide_reason)
destroy(this.sle_divide_reason)
destroy(this.cbx_1)
destroy(this.dw_6)
destroy(this.cbx_lg)
destroy(this.cbx_msl)
destroy(this.gb_1)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_5)
destroy(this.gb_2)
destroy(this.gb_6)
destroy(this.dw_7)
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
Ivs_resize_type                      = 'MASTER_DETAIL_12T'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
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

event ue_post_open;call super::ue_post_open;//====================================
// $$HEX22$$acb9ecd3b8d2200000adacb9d0c52000f1b45db818b4b4c5200088c73cc774ba200014bcd4af00c9e4b22000$$ENDHEX$$
//====================================

dw_6.settransobject( sqlca)
dw_7.settransobject( sqlca)

STRING ls_syntax

ls_syntax	=	f_get_dataobject('REPORT', upper(THIS.CLASSNAME()) ,  string( dw_3.dataobject )	)
if	ls_syntax = '' or isnull(ls_syntax) then
	f_msg_mdi_help("Report Not Changed")
else
	dw_3.create(ls_syntax)
	dw_3.settransobject(sqlca)
	f_set_column_dddw(dw_3)
	f_dual_lang_change_dwtext(dw_3)
	f_msg_mdi_help("Report Changed")
end if	


ls_syntax	=	f_get_dataobject('REPORT', upper(THIS.CLASSNAME()) ,  string( dw_4.dataobject )	)
if	ls_syntax = '' or isnull(ls_syntax) then
	f_msg_mdi_help("Report Not Changed")
else
	dw_4.create(ls_syntax)
	dw_4.settransobject(sqlca)
	f_set_column_dddw(dw_4)
	f_dual_lang_change_dwtext(dw_4)
	f_msg_mdi_help("Report Changed")
end if	

/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
st_status.text = 'Ready.'
st_status.width = dw_1.width + dw_2.width

f_play_sound("$$HEX7$$90c7acc014bc54cfdcb4a4c294ce$$ENDHEX$$.wav")
st_status.text = "$$HEX14$$90c7acc0200014bc54cfdcb47cb92000a4c294ce200058d538c194c6$$ENDHEX$$"

dw_3.retrieve( '%', '%'  , '%' , gvi_organization_id )
dw_4.retrieve( '%', '%'  , '%' , gvi_organization_id )


//$$HEX10$$68d5b5c27cb7a8bc20001cbc89d52000ecc580bd$$ENDHEX$$($$HEX2$$20c731c1$$ENDHEX$$2$$HEX4$$f5aca5c7acc0a9c6$$ENDHEX$$)
if Gvs_msl_label_print = 'Y' then
   cbx_msl.checked = true
else	
   cbx_msl.checked = false
end if

sle_divide_reason.setfocus()
end event

event ue_data_control;call super::ue_data_control;
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
			dw_1.reset()
			dw_2.reset()
			
			if rb_barcode_list.checked = true then 
				dw_1.retrieve( uo_dateset.text() , uo_dateend.text(),    ddlb_item_code.text() + '%',  sle_slip_no_condition.text+'%' , ddlb_receipt_type.getcode()+'%' , sle_lot_no.text+'%' ,  gvi_organization_id)
			else
				dw_5.retrieve( uo_dateset.text() , uo_dateend.text(),    ddlb_item_code.text() + '%',  sle_slip_no_condition.text+'%' , ddlb_receipt_type.getcode()+'%' , sle_lot_no.text+'%' ,  gvi_organization_id)
			end if 
			
			sle_item_barcode.text = ''
			sle_item_barcode.setfocus()
			st_status.text = 'Waitting'
	 
     case 'INSERT'
		
					LVL_ROW = DW_2.INSERTROW(1)
					DW_2.SCROLLTOROW(LVL_ROW)
					F_SET_SECURITY_ROW(DW_2 , LVL_ROW ,'ALL')
	
	case 'UPDATE'
		
			IF dw_1.UPDATE() < 0  OR  dw_2.UPDATE() < 0 THEN
				ROLLBACK;
				RETURN					
			ELSE
				COMMIT;
				F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
				sle_item_barcode.setfocus()		 
			END IF

	case else
end choose

end event

event clicked;call super::clicked;sle_item_barcode.setfocus()
end event

event resize;call super::resize;st_status.width = dw_1.width + dw_2.width
end event

type dw_5 from w_main_root`dw_5 within w_mat_receipt_barcode_divide_master
integer y = 876
integer width = 2267
integer height = 1428
integer taborder = 0
boolean titlebar = true
string title = "Lot Divide List"
string dataobject = "d_mat_receipt_barcode_4_lot_divide_lst"
end type

type dw_4 from w_main_root`dw_4 within w_mat_receipt_barcode_divide_master
integer y = 876
integer width = 2267
integer height = 1428
integer taborder = 0
boolean titlebar = true
string title = "Tray"
string dataobject = "d_mat_receipt_lot_tray_divide_barcode_rpt"
end type

type dw_3 from w_main_root`dw_3 within w_mat_receipt_barcode_divide_master
integer y = 876
integer width = 2267
integer height = 1428
integer taborder = 0
boolean titlebar = true
string title = "Reel"
string dataobject = "d_mat_receipt_lot_barcode_rpt"
end type

type dw_2 from w_main_root`dw_2 within w_mat_receipt_barcode_divide_master
integer x = 2286
integer y = 872
integer width = 2853
integer height = 1428
integer taborder = 0
boolean titlebar = true
string title = "New Barcode List"
string dataobject = "d_mat_rceipt_barcode_4_slip_lst"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_2::buttonclicked;call super::buttonclicked;string lvs_itemcode, lvs_msl_level

if dwo.name = 'b_print' then 
	if rb_reel.checked = true then 
		    
			 lvs_itemcode = this.object.item_code[row]
			dw_3.retrieve( this.object.item_code[row] , this.object.receipt_slip_no[row] ,  this.object.lot_no[row] , gvi_organization_id )
			if dw_3.rowcount() > 0 then 	
			   dw_3.print( )
				//$$HEX7$$68d5b5c27cb7a8bc20009ccd25b8$$ENDHEX$$
				  If cbx_msl.checked = true Then			  	 
					// MSL$$HEX6$$90c7acc7ecc580bdb4cc6cd0$$ENDHEX$$
					  SELECT NVL(msl_level, '0')
						  INTO :lvs_msl_level
						FROM  id_item
					  WHERE item_code = :lvs_itemcode
						  AND organization_id = :gvi_organization_id  ;
					  
					  IF F_SQL_CHECK() < 0 THEN 
					  Else
						 IF  lvs_msl_level > '2'  THEN
							 dw_7.retrieve( this.object.item_code[row] , this.object.receipt_slip_no[row] ,  this.object.lot_no[row] , gvi_organization_id )
							 if dw_7.rowcount() > 0 then 	
								dw_7.print( )
							 end if
						  End if	
					  END IF 		
				End if
			else
			f_msgbox(117)
			end if 
	else
			dw_4.retrieve( this.object.item_code[row] , this.object.receipt_slip_no[row] , this.object.lot_no[row] ,  gvi_organization_id )
			if dw_4.rowcount() > 0 then 	
			dw_4.print( )
			else
			f_msgbox(117)
			end if 		
	end if 

end if 
end event

type dw_1 from w_main_root`dw_1 within w_mat_receipt_barcode_divide_master
integer y = 876
integer width = 2281
integer height = 1428
integer taborder = 0
boolean titlebar = true
string title = "Barcode List"
string dataobject = "d_mat_rceipt_barcode_4_reel_divide_lst"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_1::clicked;call super::clicked;sle_item_barcode.setfocus()
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
dw_2.retrieve( this.object.item_code[currentrow] , this.object.receipt_slip_no[currentrow] , gvi_organization_id)

end event

event dw_1::buttonclicked;call super::buttonclicked;string lvs_itemcode, lvs_msl_level

if dwo.name = 'b_print' then 
	if rb_reel.checked = true then 
		    lvs_itemcode = this.object.item_code[row]
			dw_3.retrieve( this.object.item_code[row] , this.object.receipt_slip_no[row] , this.object.lot_no[row]  , gvi_organization_id )
			if dw_3.rowcount() > 0 then 	
				dw_3.print( )
				  //$$HEX7$$68d5b5c27cb7a8bc20009ccd25b8$$ENDHEX$$
				  If cbx_msl.checked = true Then			  	 
					// MSL$$HEX6$$90c7acc7ecc580bdb4cc6cd0$$ENDHEX$$
					  SELECT NVL(msl_level, '0')
						  INTO :lvs_msl_level
						FROM  id_item
					  WHERE item_code = :lvs_itemcode
						  AND organization_id = :gvi_organization_id  ;
					  
					  IF F_SQL_CHECK() < 0 THEN 
					  Else
						 IF  lvs_msl_level > '2'  THEN
							 dw_7.retrieve( this.object.item_code[row] , this.object.receipt_slip_no[row] , this.object.lot_no[row]  , gvi_organization_id )
							 if dw_7.rowcount() > 0 then 	
								dw_7.print( )
							 end if
						  End if	
					  END IF 		
				End if
			else
			f_msgbox(117)
			end if 
	else
		 //   dw_4.bringtotop = true
			dw_4.retrieve( this.object.item_code[row] ,this.object.receipt_slip_no[row] , this.object.lot_no[row]  ,  gvi_organization_id )
			if dw_4.rowcount() > 0 then 	
 				dw_4.print( )
			else
				f_msgbox(117)
			end if 	
		//	  dw_4.bringtotop = false
	end if 

end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_receipt_barcode_divide_master
integer taborder = 0
end type

type uo_dateset from uo_ymd_calendar within w_mat_receipt_barcode_divide_master
event destroy ( )
integer x = 681
integer y = 160
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_receipt_barcode_divide_master
event destroy ( )
integer x = 1097
integer y = 160
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_item_code from uo_item_code within w_mat_receipt_barcode_divide_master
integer x = 1513
integer y = 156
integer width = 530
integer height = 676
integer taborder = 0
boolean bringtotop = true
end type

event selectionchanged;call super::selectionchanged;sle_item_barcode.setfocus()
end event

type st_3 from so_statictext within w_mat_receipt_barcode_divide_master
integer x = 1513
integer y = 76
integer width = 530
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type st_4 from so_statictext within w_mat_receipt_barcode_divide_master
integer x = 686
integer y = 80
integer width = 814
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Receipt Date"
end type

type st_1 from so_statictext within w_mat_receipt_barcode_divide_master
integer x = 704
integer y = 516
integer width = 1189
integer height = 56
boolean bringtotop = true
integer textsize = -10
long textcolor = 16711680
string text = "Our Barcode"
end type

event clicked;call super::clicked;sle_item_barcode.setfocus()
end event

type st_status from so_statictext within w_mat_receipt_barcode_divide_master
integer y = 692
integer width = 5125
integer height = 160
boolean bringtotop = true
integer textsize = -20
integer weight = 700
long textcolor = 65535
long backcolor = 16711680
string text = "Message"
end type

event clicked;call super::clicked;sle_item_barcode.setfocus()
end event

type sle_item_barcode from so_singlelineedit within w_mat_receipt_barcode_divide_master
integer x = 699
integer y = 576
integer width = 896
integer height = 84
integer taborder = 10
boolean bringtotop = true
textcase textcase = upper!
end type

event modified;call super::modified;lvs_our_barcode = this.text

//=======================================
// $$HEX11$$00cf3cd554cf200090c7acc778c72000bdacb0c62000$$ENDHEX$$
//=======================================
// IF MID (UPPER (lvs_our_barcode), 1, 1) = '['    THEN
//         SELECT  f_get_item_code_from_barcode (:lvs_our_barcode)|| '-' || f_get_lot_no_from_barcode (:lvs_our_barcode) || '-' || f_get_lot_qty_from_barcode (:lvs_our_barcode)
//          INTO :lvs_our_barcode
//          FROM DUAL ; 
//      
//      IF F_SQL_CHECK() < 0 THEN 
//            sle_our_barcode.selecttext( 1,100)   
//      END IF    
//      
//else
//      
//    SELECT  f_get_prepare_barcode (:lvs_our_barcode)
//           INTO :lvs_our_barcode
//          FROM DUAL ; 
//      
//      IF F_SQL_CHECK() < 0 THEN 
//            sle_our_barcode.selecttext( 1,100)   
//      END IF     
//   
//END IF 

//==================================================
//  $$HEX6$$88d4a9ba200054cfdcb42000$$ENDHEX$$
//==================================================

//lvl_pos1 =  pos(lvs_our_barcode , '-' , 7 ) 
//
//if  lvl_pos1 <= 0 then 
//	f_msgbox1(1175 ,lvs_our_barcode )
//	this.setfocus()
//	this.selecttext( 1,100)
//	return -1 
//end if 
////================================================
////  $$HEX6$$88d4a9ba2000b4cc6cd02000$$ENDHEX$$
////================================================
//lvs_item_code = trim( mid( lvs_our_barcode , 1 ,  lvl_pos1 -1 ))
	SELECT  f_get_item_code_from_barcode (:lvs_our_barcode) 
	INTO :lvs_item_code
	FROM DUAL ; 
	
	IF F_SQL_CHECK() < 0 THEN 
		sle_our_barcode.selecttext( 1,100)	
	END IF 	 
	
	if  lvs_item_code = '' then 
		
		f_play_sound("$$HEX5$$88d4a9baf8bbf1b45db8$$ENDHEX$$.wav")
		f_msgbox1(1175 ,lvs_our_barcode )
		sle_our_barcode.setfocus()
		sle_our_barcode.selecttext( 1,100)
		return 
	end if 
	
if f_check_item_exists( lvs_item_code , f_t_sysdate())  <= 0 then 
	
	f_play_sound("$$HEX5$$88d4a9baf8bbf1b45db8$$ENDHEX$$.wav")
	f_msgbox(9041) //$$HEX10$$fcd3a9bac8b9a4c230d12000f8bbf1b45db82000$$ENDHEX$$
	
	this.setfocus()
	this.selecttext( 1,100)	
end if 
sle_item_code.text = lvs_item_code


//==================================================
// $$HEX6$$6fb8b8d2200088bc38d62000$$ENDHEX$$
//==================================================
//lvl_pos2 =  pos(lvs_our_barcode , '-' , lvl_pos1+1 ) 
//
//if  lvl_pos2 <= 0 then 
//	lvs_receipt_lot_no_org = trim( mid( lvs_our_barcode , lvl_pos1+1 ,  100 ))
//else
//	lvs_receipt_lot_no_org = trim( mid( lvs_our_barcode , lvl_pos1+1 ,   lvl_pos2 - lvl_pos1 -1 ))
//end if 
//
//if  lvs_receipt_lot_no_org= ''  then 
//	st_status.text = "LOT NO INVALID : $$HEX15$$6fb8b8d288bc38d600ac20002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$"
//	this.setfocus()
//	this.selecttext( 1,100)	
//	return -1
//end if 

SELECT  F_GET_LOT_NO_FROM_BARCODE (:lvs_our_barcode ) 
	INTO :lvs_receipt_lot_no_org
	FROM DUAL ; 
	
	IF F_SQL_CHECK() < 0 THEN 
		sle_our_barcode.selecttext( 1,100)	
	END IF 	 

	if lvs_receipt_lot_no_org = ''  then 
		st_status.text =f_msg( "$$HEX15$$6fb8b8d288bc38d600ac20002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$",'S')
		sle_our_barcode.setfocus()
		sle_our_barcode.selecttext( 1,100)	
		return
	end if 
//==================================================
// $$HEX12$$74c7f8bb74c8acc7200058d594b2c0c92000b4cc6cd02000$$ENDHEX$$
//==================================================

lvs_receipt_type = ''
lvs_slip_no = ''
lvs_supplier_code = ''
LVS_FROM_SUPPLIER_CODE = ''
lvs_receipt_type = ''

SELECT RECEIPT_SLIP_NO, NVL(SUPPLIER_CODE ,'*'),
            NVL(RECEIPT_COMPARE_YN , 'N')  , 
            NVL(RECEIPT_TYPE,'N') , 
		   FROM_SUPPLIER_CODE , 
		   LOT_NO ,
		   SCAN_QTY ,
		   NVL(ISSUE_COMPARE_YN , 'N') ,
		   LABEL_TYPE
   INTO :LVS_SLIP_NO , :lvs_supplier_code , 
	       :LVS_RECEIPT_COMPARE_YN  ,
	       :LVS_RECEIPT_TYPE , 
		   :LVS_FROM_SUPPLIER_CODE , 
		   :LVS_ORIGIN_LOT_NO,
		   :lvl_total_qty ,
		   :LVS_ISSUE_COMPARE_YN ,
		   :LVS_LABEL_TYPE
			
  FROM IM_ITEM_RECEIPT_BARCODE
  WHERE ITEM_CODE = :LVS_ITEM_CODE
      AND LOT_NO  = :lvs_receipt_lot_no_org
	 AND RECEIPT_COMPARE_YN = 'Y'
      AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;

IF F_SQL_CHECK() < 0 THEN 
	sle_item_barcode.setfocus( )
	sle_item_barcode.text = ''	
	return -1 
END IF 

//======================================================
//
//======================================================
IF  LVS_LABEL_TYPE  =  'R'  THEN 
	lvs_location_code = 'M06' //$$HEX11$$acb98cbc00aca5b2200000b330ae20003dcce0ac2000$$ENDHEX$$
ELSEIF LVS_LABEL_TYPE  = 'B' THEN 
	lvs_location_code = 'M05' // $$HEX5$$8cbc6cd03dcce0ac2000$$ENDHEX$$
ELSE	
	lvs_location_code = 'M01'  //$$HEX5$$91c5b0c03dcce0ac2000$$ENDHEX$$
END IF 

//========================================
// $$HEX16$$acc2bdb9200074c725b82000c6c5b4c5c4b32000c4ac8dc12000c4c989d52000$$ENDHEX$$
//========================================
if  LVS_SLIP_NO = ''  then	
	
	f_play_sound("$$HEX6$$acc2bdb974c725b8c6c54cc7$$ENDHEX$$.wav")	
	st_status.text = LVS_OUR_BARCODE+'BARCODE NOT FOUND :  $$HEX25$$14bc54cfdcb42000ddc031c1200074c725b874c72000c6c570ac98b0200085c7e0ac18b4c0c920004ac558c5b5c2c8b2e4b2$$ENDHEX$$.'
	
	LVS_SLIP_NO  =  lvs_receipt_lot_no_org
	lvs_supplier_code = 'LGE'
//	lvs_receipt_type = 'N'
	
else
	
		IF LVS_ISSUE_COMPARE_YN = 'Y'  AND rb_reel.checked = true  THEN 
		
			st_status.text = LVS_OUR_BARCODE+' NOT RETURN : $$HEX15$$9ccde0ac18bc88d420005cd52000c4d6200084bd60d5200058d538c194c6$$ENDHEX$$'
			sle_item_barcode.setfocus( )
			sle_item_barcode.selecttext(1,100)
			return 
		END IF 

end if 


//
if rb_tray.checked = true and LVS_ISSUE_COMPARE_YN <> 'Y' then 
	
	st_status.text = LVS_OUR_BARCODE+' ISSUED TRAY ONLY DIVIDE : $$HEX19$$9ccde0ac1cb42000b8d208b874c7ccb9200084bd60d5200060d518c2200088c7b5c2c8b2e4b2$$ENDHEX$$'	
	return 
	
end if 



//=========================================
cb_divide.enabled = true
//=========================================
//
//=========================================
//if cbx_old_type.checked = true then 
//	sle_qty.setfocus()
//	sle_qty.text = string(lvl_total_qty)
//else

	sle_qty.text = string(lvl_total_qty)
//	lvl_total_qty =  long(trim( mid( lvs_our_barcode ,  lvl_pos2+1   ,  len(lvs_our_barcode) - lvl_pos2 )))
	
	if lvl_total_qty <=0 then 
		f_play_sound("$$HEX4$$18c2c9b724c658b9$$ENDHEX$$.wav")	
		st_status.text = "$$HEX13$$18c2c9b774c720002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$"	
		this.setfocus()
		this.selecttext( 1,100)	
		return -1
	end if 
     sle_qty.text =  string(lvl_total_qty)
	  
	cb_divide.setfocus()
	
//end if 

end event

type sle_total_qty from so_singlelineedit within w_mat_receipt_barcode_divide_master
integer x = 3909
integer y = 528
integer width = 544
integer height = 88
boolean bringtotop = true
textcase textcase = upper!
end type

event getfocus;call super::getfocus;if sle_item_barcode.text = '' or  isnull(sle_item_barcode.text) then 
	sle_item_barcode.setfocus()
	st_status.text = "$$HEX24$$14bc54cfdcb47cb92000a4c294ce200058d570ac98b0200088d4a9ba88bc38d67cb9200085c725b8200058d538c194c6$$ENDHEX$$"
	return 
end if 
end event

type st_7 from so_statictext within w_mat_receipt_barcode_divide_master
integer x = 3575
integer y = 532
integer width = 325
boolean bringtotop = true
integer textsize = -10
long textcolor = 0
string text = "Total Qty"
alignment alignment = right!
end type

type cbx_auto_print from so_checkbox within w_mat_receipt_barcode_divide_master
integer x = 4037
integer y = 52
integer width = 357
integer height = 68
boolean bringtotop = true
string text = "Auto Print"
boolean checked = true
end type

type sle_slip_no_condition from so_singlelineedit within w_mat_receipt_barcode_divide_master
integer x = 2053
integer y = 156
integer width = 608
integer height = 84
boolean bringtotop = true
end type

type st_9 from so_statictext within w_mat_receipt_barcode_divide_master
integer x = 2053
integer y = 72
integer width = 608
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Slip No"
end type

type pb_1 from so_commandbutton within w_mat_receipt_barcode_divide_master
integer x = 3602
integer y = 76
integer width = 416
integer height = 156
boolean bringtotop = true
integer weight = 400
string text = "Cancel"
end type

event clicked;call super::clicked;open(w_mat_reel_divide_cancel_popup)
sle_item_barcode.setfocus()
end event

type rb_tray from so_radiobutton within w_mat_receipt_barcode_divide_master
integer x = 73
integer y = 528
integer width = 503
integer height = 84
boolean bringtotop = true
integer textsize = -10
string text = "Tray"
end type

type rb_reel from so_radiobutton within w_mat_receipt_barcode_divide_master
integer x = 73
integer y = 424
integer width = 503
integer height = 84
boolean bringtotop = true
integer textsize = -10
string text = "Reel"
boolean checked = true
end type

type cb_divide from commandbutton within w_mat_receipt_barcode_divide_master
integer x = 1989
integer y = 368
integer width = 480
integer height = 276
integer taborder = 20
boolean bringtotop = true
integer textsize = -18
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Divide"
end type

event clicked;DATETIME LVDT_ISSUE_COMPARE_DATE  , lvdt_receipt_compare_date, lvdt_manufacture_date, lvdt_pcb_coating_date
STRING LVS_vendor_lotno , LVS_vendor_CODE , LVS_real_divide_reason
STRING LVS_LINE_CODE , LVS_FEEDING_MODEL , LVS_FEEDING_YN , LVS_ISSUE_DIVISION , LVS_FEEDER_SHAFT  
LONG  LVL_MSL_PASSED_TIME , LVL_MSL_REMAIN_TIME 
STRING  LVS_FEEDER_LOCATION_CODE
STRING lvs_msl_level, lvs_itemcode, lvs_manufacture_week, lvs_suppiler_barcode , lvs_inventory_type

lvs_real_divide_reason = sle_divide_reason.text
if lvs_real_divide_reason = '' or isnull(lvs_real_divide_reason) then 
	f_msgbox1(126 , st_divide_reason.text )
	return 
end if 


//=================================================
// $$HEX8$$6fb8b8d2200084bd60d520003dcc2000$$ENDHEX$$
//=================================================
ivl_divide_qty = {0}
openwithparm (w_mat_reel_divide_qty_popup ,string(lvl_total_qty) )   

if  Upperbound(ivl_divide_qty) <= 0 then 
	sle_item_barcode.setfocus()
	sle_item_barcode.selecttext( 1,100)		
	return 
end if 

IF  ivl_divide_qty[1] = 0 THEN 
	ST_STATUS.TEXT = "$$HEX15$$84bd60d574c7200098ccacb9200018b4c0c920004ac558c5b5c2c8b2e4b2$$ENDHEX$$"
	sle_item_barcode.setfocus()
	sle_item_barcode.selecttext( 1,100)		
	RETURN 
END IF 

//======================================================
// $$HEX4$$b4b984bd60d52000$$ENDHEX$$
//======================================================
if rb_reel.checked = true then 

		SELECT LINE_CODE , FEEDING_MODEL , FEEDING_YN , ISSUE_DIVISION , FEEDER_SHAFT , LOCATION_CODE , ISSUE_COMPARE_YN , ISSUE_COMPARE_DATE  ,
			  	   MSL_PASSED_TIME , MSL_REMAIN_TIME , vendor_lotno , vendor_CODE , real_divide_reason , receipt_compare_date, nvl(MANUFACTURE_WEEK, '*') ,
				   NVL(SUPPLIER_BARCODE, '*') , INVENTORY_TYPE,
				   manufacture_date, pcb_coating_date
		   INTO :LVS_LINE_CODE , :LVS_FEEDING_MODEL , :LVS_FEEDING_YN , :LVS_ISSUE_DIVISION , :LVS_FEEDER_SHAFT , :LVS_FEEDER_LOCATION_CODE , :LVS_ISSUE_COMPARE_YN ,
		           :LVDT_ISSUE_COMPARE_DATE  ,
		           :LVL_MSL_PASSED_TIME , :LVL_MSL_REMAIN_TIME , :LVS_vendor_lotno , :LVS_vendor_CODE , :LVS_real_divide_reason , :lvdt_receipt_compare_date, :lvs_manufacture_week, 
				  :lvs_suppiler_barcode		, :lvs_inventory_type,
				  :lvdt_manufacture_date, :lvdt_pcb_coating_date
		  FROM IM_ITEM_RECEIPT_BARCODE 
		WHERE ITEM_BARCODE = :LVS_our_barcode 
			AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
			
	  if f_sql_check() <  0 then 
		sle_item_barcode.text = ''
		sle_item_barcode.setfocus( )
		return -1 
	  end if 	
  
		lvdb_lot_divide_sequence =  F_GET_SEQUENCE('SEQ_LOT_DIVIDE_SEQUENCE')
		//==================================================
		// $$HEX13$$14bc54cfdcb4200015c8f4bcd0c5200085c725b85cd5e4b22000$$ENDHEX$$
		//==================================================
		lvl_row = 0 
		i = 0
		do
			
				i++

				F_INSERT()
				
				//$$HEX18$$e0c2dcad20006fb8b8d2200088bc38d67cb9200094cd9ccd74d51cc1200001c8a9c62000$$ENDHEX$$
				lvdb_receipt_lot_no = F_GET_SEQUENCE('SEQ_MATERIAL_BARCODE')
				lvs_receipt_lot_no =   F_YMD_SYSDATE() +TRIM(STRING(lvdb_receipt_lot_no,'00000')) // STRING(F_T_SYSDATE(),'YYMMDD')+TRIM(STRING(lvdb_receipt_lot_no,'00000'))
				
				dw_2.object.item_code[LVL_ROW]              = lvs_item_code //$$HEX5$$fcd3a9ba54cfdcb42000$$ENDHEX$$
				dw_2.object.lot_no[LVL_ROW]                    = lvs_receipt_lot_no  //$$HEX5$$6fb8b8d288bc38d62000$$ENDHEX$$
				
				dw_2.object.receipt_slip_no[LVL_ROW]       = lvs_slip_no
				dw_2.object.supplier_code[LVL_ROW]         = lvs_supplier_code
				dw_2.object.from_supplier_code[LVL_ROW] = lvs_from_SUPPLIER_CODE
				
				dw_2.object.receipt_compare_yn[lvl_row]  = 'Y' //$$HEX5$$44be50ad44c6ccb82000$$ENDHEX$$
				dw_2.object.receipt_compare_date[lvl_row]  = lvdt_receipt_compare_date
				dw_2.object.issue_compare_yn[lvl_row]     = 'N' //$$HEX8$$9ccde0ac200044be50ad44c6ccb82000$$ENDHEX$$
				dw_2.object.barcode_status[lvl_row]         =  'N' // 		
				
				dw_2.object.receipt_type[lvl_row]             = lvs_receipt_type //$$HEX5$$85c7e0ac20c715d62000$$ENDHEX$$
				dw_2.object.scan_date[LVL_ROW]            = f_t_sysdate()
				
				dw_2.object.scan_qty[LVL_ROW]              = ivl_divide_qty[i]
				dw_2.object.new_scan_qty[LVL_ROW]      = ivl_divide_qty[i]
				
				dw_2.object.item_barcode[LVL_ROW]       = sle_item_code.text+"-"+lvs_receipt_lot_no+"-"+string( ivl_divide_qty[i])	
				dw_2.object.lot_divide_yn[lvl_row]            = 'Y' 
				dw_2.object.lot_divide_date[lvl_row]         = f_sysdate()
				dw_2.object.origin_item_barcode[lvl_row] = lvs_our_barcode
				dw_2.object.label_type[lvl_row]                = lvs_label_type
				dw_2.object.origin_lot_no[lvl_row]            = lvs_receipt_lot_no_org
				dw_2.object.lot_divide_sequence[lvl_row] = lvdb_lot_divide_sequence

				lvl_issue_qty = ivl_divide_qty[i]
				
				dw_2.object.line_code[lvl_row] = LVS_LINE_CODE
				dw_2.object.feeding_model[lvl_row] =LVS_FEEDING_MODEL
				dw_2.object.feeding_yn[lvl_row] = LVS_FEEDING_YN
				dw_2.object.issue_compare_date[lvl_row] = LVDT_ISSUE_COMPARE_DATE
				dw_2.object.issue_compare_by[lvl_row] = gvs_user_id
				dw_2.object.feeder_shaft[lvl_row] = lvs_feeder_shaft
				dw_2.object.location_code[lvl_row] = LVS_FEEDER_LOCATION_CODE
				dw_2.object.msl_passed_time[lvl_row] = lvl_MSL_PASSED_TIME
				dw_2.object.msl_remain_time[lvl_row] = lvl_msl_remain_time 
				dw_2.object.vendor_lotno[lvl_row] = lvs_vendor_lotno
				dw_2.object.vendor_code[lvl_row] = lvs_vendor_CODE
				dw_2.object.real_divide_reason[lvl_row] = lvs_real_divide_reason
				dw_2.object.issue_division[lvl_row] = lvs_issue_division	
                  dw_2.object.manufacture_week[lvl_row] = lvs_manufacture_week	
                  dw_2.object.supplier_barcode[lvl_row] = lvs_suppiler_barcode		
				dw_2.object.inventory_type[lvl_row] = lvs_inventory_type		
						
			    dw_2.object.manufacture_date[lvl_row] = lvdt_manufacture_date
			    dw_2.object.pcb_coating_date[lvl_row] = lvdt_pcb_coating_date	 						
										
				//=====================================================
				//
				//=====================================================
				   if dw_2.update() < 0 then 
						dw_2.reset()
						rollback ;
						sle_item_barcode.TEXT = ''
						sle_item_barcode.SETFOCus( )
						f_play_sound("$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav")			
						return 
				    end if 
				  
					if cbx_auto_print.checked = true then
						
						
							    if cbx_lg.checked = true then 
										dw_6.retrieve( sle_item_code.text , lvs_slip_no  , lvs_receipt_lot_no , gvi_organization_id )
										if dw_6.rowcount() > 0 then 	
											dw_6.print( )
										else
											f_msgbox(117)
											sle_item_barcode.text = ''
											sle_item_barcode.setfocus( )
										end if 									
								end if 			
							//==============================================
							//
							//==============================================
							if rb_reel.checked = true then 

												lvs_itemcode =  sle_item_code.text
												dw_3.retrieve( sle_item_code.text , lvs_slip_no  , lvs_receipt_lot_no , gvi_organization_id )
												if dw_3.rowcount() > 0 then 	
													dw_3.print( )
													
														  //$$HEX7$$68d5b5c27cb7a8bc20009ccd25b8$$ENDHEX$$
														  If cbx_msl.checked = true Then			  	 
																	// MSL$$HEX6$$90c7acc7ecc580bdb4cc6cd0$$ENDHEX$$
																	  SELECT NVL(msl_level, '0')
																		  INTO :lvs_msl_level
																		FROM  id_item
																	  WHERE item_code = :lvs_itemcode
																		  AND organization_id = :gvi_organization_id  ;
																  
																	  IF F_SQL_CHECK() < 0 THEN 
																	  Else
																		 IF  lvs_msl_level > '2'  THEN
																			 dw_7.retrieve( sle_item_code.text , lvs_slip_no  , lvs_receipt_lot_no , gvi_organization_id )
																			 if dw_7.rowcount() > 0 then 	
																				dw_7.print( )
																			 end if
																		  End if	
																	  END IF 		
															End if // $$HEX3$$69d5b5c22000$$ENDHEX$$
												else // $$HEX6$$c6c544c72000bdacb0c62000$$ENDHEX$$
													f_msgbox(117)
													sle_item_barcode.text = ''
													sle_item_barcode.setfocus( )
												end if 
												
											//======================================
											// TRAY $$HEX6$$15d6ddc220007cb7a8bc2000$$ENDHEX$$
											//======================================
											else
													dw_4.retrieve(  sle_item_code.text , lvs_slip_no  , lvs_receipt_lot_no  , gvi_organization_id )
													if dw_4.rowcount() > 0 then 	
														dw_4.print( )
													else
														f_msgbox(117)
														sle_item_barcode.text = ''
														sle_item_barcode.setfocus( )
													end if 												
												
											end if 
					end if
					
					//===============================================
					//
					//===============================================
					 INSERT INTO IM_ITEM_ISSUE  
										( ITEM_CODE,   
										  ISSUE_DATE,   
										  ISSUE_SEQUENCE,   
										  ORGANIZATION_ID,   
										  MFS,   
										  LOCATION_CODE,   
										  ITEM_TYPE,   
										  LINE_CODE,   
										  WORKSTAGE_CODE,   
										  ISSUE_DEFICIT,   
										  ISSUE_QTY,   
										  ISSUE_STATUS,   
										  ISSUE_AMT,   
										  ISSUE_ACCOUNT,   
										  LINE_TYPE,   
										  COMMENTS,   
										  ISSUE_PRICE,   
										  VIRTUAL_RECEIPT_YN,   
										  ISSUE_TYPE,   
										  SUPPLIER_CODE,   
										  WORK_ORDER_NO,   
										  ENTER_DATE,   
										  ENTER_BY,   
										  LAST_MODIFY_DATE,   
										  LAST_MODIFY_BY,   
										  MACHINE_CODE,   
										  INVOICE_NO,   
										  MADE_BY,   
										  PARENT_ITEM_CODE,   
										  MATERIAL_MFS,   
										  INTERFACE_YN,   
										  INTERFACE_DATE,   
										  SALE_PRICE,   
										  SALE_AMT,   
										  SALE_CURRENCY,   
										  ARRIVAL_DATE,   
										  ARRIVAL_SEQ_NO,   
										  DEST_ORGANIZATION_ID,   
										  INSPECT_NO,   
										  RETURN_REQUEST_DATE,   
										  RETURN_REQUEST_SEQUENCE,   
										  CLOSE_YN,   
										  CLOSE_DATE,   
										  DEMAND_QTY,
										  LOT_DIVIDE_SEQUENCE ,
										  ISSUE_DIVISION , 
										  FEEDER_SHAFT ,
										  FEEDER_LOCATION_CODE,
										  MODEL_NAME, 
										  RECEIPT_DATE ,
										  INVENTORY_TYPE)  
				    		     VALUES  (  :lvs_item_code,      //ITEM_CODE, 
											trunc(sysdate) ,      //ISSUE_DATE,   
											SEQ_MAT_ISSUE.NEXTVAL ,      //ISSUE_SEQUENCE,   
											:GVI_ORGANIZATION_ID ,      //ORGANIZATION_ID,   
											:lvs_receipt_lot_no_org,      //MFS,   
											:lvs_location_code  , //:lvs_location_code,      //LOCATION_CODE,   
											'T',      //ITEM_TYPE,   
											'00' , //:lvs_line_code,      //LINE_CODE,   
											'W00' , //:lvs_workstage_code,      //WORKSTAGE_CODE,   
											3,      //ISSUE_DEFICIT,   
											:lvl_issue_qty ,      //ISSUE_QTY,   
											'N',      //ISSUE_STATUS,   
											0 ,      //ISSUE_AMT,   
											'M016',      //ISSUE_ACCOUNT,   
											F_GET_LINE_TYPE_FROM_ITEM( :lvs_item_code , :gvi_organization_id ) ,      //LINE_TYPE,   
											'LOT DIVIDE',  //COMMENTS,   
											0 ,      //ISSUE_PRICE,   
											NULL,      //VIRTUAL_RECEIPT_YN,   
											'N',      //ISSUE_TYPE,   
											:lvs_supplier_code ,      //SUPPLIER_CODE,   
											'*',      //WORK_ORDER_NO,   
											sysdate ,      //ENTER_DATE,   
										    :gvs_user_id ,      //ENTER_BY,   
											sysdate ,      //LAST_MODIFY_DATE,   
											:gvs_user_id ,      //LAST_MODIFY_BY,   
											'*',      //MACHINE_CODE,   
											:lvs_slip_no ,      //INVOICE_NO,   
											NULL,      //MADE_BY,   
											'*',      //PARENT_ITEM_CODE,
											:lvs_receipt_lot_no_org , //:lvs_lot_no ,  //MATERIAL_MFS,   
											NULL,      //INTERFACE_YN,   
											NULL,      //INTERFACE_DATE,   
											NULL,      //SALE_PRICE,   
											NULL,      //SALE_AMT,   
											NULL,      //SALE_CURRENCY,   
											NULL,      //ARRIVAL_DATE,   
											NULL,      //ARRIVAL_SEQ_NO,   
											NULL,      //DEST_ORGANIZATION_ID,   
											NULL,      //INSPECT_NO,   
											NULL,      //RETURN_REQUEST_DATE,   
											NULL,      //RETURN_REQUEST_SEQUENCE,   
											'N',         //CLOSE_YN,   
											NULL,      //CLOSE_DATE,   
											NULL,       //DEMAND_QTY 
											:lvdb_lot_divide_sequence ,
											'' ,
											'' , 
											:LVS_FEEDER_LOCATION_CODE ,
											'*' ,
											:lvdt_receipt_compare_date ,
											:lvs_inventory_type
											
									)  ;				
									
					//===============================================
					//
					//===============================================
					 INSERT INTO IM_ITEM_ISSUE  
										( ITEM_CODE,   
										  ISSUE_DATE,   
										  ISSUE_SEQUENCE,   
										  ORGANIZATION_ID,   
										  MFS,   
										  LOCATION_CODE,   
										  ITEM_TYPE,   
										  LINE_CODE,   
										  WORKSTAGE_CODE,   
										  ISSUE_DEFICIT,   
										  ISSUE_QTY,   
										  ISSUE_STATUS,   
										  ISSUE_AMT,   
										  ISSUE_ACCOUNT,   
										  LINE_TYPE,   
										  COMMENTS,   
										  ISSUE_PRICE,   
										  VIRTUAL_RECEIPT_YN,   
										  ISSUE_TYPE,   
										  SUPPLIER_CODE,   
										  WORK_ORDER_NO,   
										  ENTER_DATE,   
										  ENTER_BY,   
										  LAST_MODIFY_DATE,   
										  LAST_MODIFY_BY,   
										  MACHINE_CODE,   
										  INVOICE_NO,   
										  MADE_BY,   
										  PARENT_ITEM_CODE,   
										  MATERIAL_MFS,   
										  INTERFACE_YN,   
										  INTERFACE_DATE,   
										  SALE_PRICE,   
										  SALE_AMT,   
										  SALE_CURRENCY,   
										  ARRIVAL_DATE,   
										  ARRIVAL_SEQ_NO,   
										  DEST_ORGANIZATION_ID,   
										  INSPECT_NO,   
										  RETURN_REQUEST_DATE,   
										  RETURN_REQUEST_SEQUENCE,   
										  CLOSE_YN,   
										  CLOSE_DATE,   
										  DEMAND_QTY,
										  LOT_DIVIDE_SEQUENCE,
										    ISSUE_DIVISION , 
										  FEEDER_SHAFT ,
										  FEEDER_LOCATION_CODE,
										  RECEIPT_DATE,
										  INVENTORY_TYPE)  
										  
						   VALUES  (:lvs_item_code,      //ITEM_CODE, 
										trunc(sysdate) ,      //ISSUE_DATE,   
										SEQ_MAT_ISSUE.NEXTVAL ,      //ISSUE_SEQUENCE,   
										:GVI_ORGANIZATION_ID ,      //ORGANIZATION_ID,   
										:lvs_receipt_lot_no,      //MFS,   
										:lvs_location_code , //:lvs_location_code,      //LOCATION_CODE,   
										'T',      //ITEM_TYPE,   
										'00' , //:lvs_line_code,      //LINE_CODE,   
										'W00' , //:lvs_workstage_code,      //WORKSTAGE_CODE,   
										4,      //ISSUE_DEFICIT,   
										:lvl_issue_qty * -1  ,      //ISSUE_QTY,   
										'N',      //ISSUE_STATUS,   
										0 ,      //ISSUE_AMT,   
										'M016',      //ISSUE_ACCOUNT,   
										F_GET_LINE_TYPE_FROM_ITEM( :lvs_item_code , :gvi_organization_id ) ,      //LINE_TYPE,   
										'LOT DIVIDE',  //COMMENTS,   
										0 ,      //ISSUE_PRICE,   
										NULL,      //VIRTUAL_RECEIPT_YN,   
										'N',      //ISSUE_TYPE,   
										:lvs_supplier_code ,      //SUPPLIER_CODE,   
										'*',      //WORK_ORDER_NO,   
										sysdate ,      //ENTER_DATE,   
										 :gvs_user_id ,      //ENTER_BY,   
										sysdate ,      //LAST_MODIFY_DATE,   
										:gvs_user_id ,      //LAST_MODIFY_BY,   
										'*',      //MACHINE_CODE,   
										:lvs_slip_no ,      //INVOICE_NO,   
										NULL,      //MADE_BY,   
										'*',      //PARENT_ITEM_CODE,
										:lvs_receipt_lot_no , //:lvs_lot_no ,  //MATERIAL_MFS,   
										NULL,      //INTERFACE_YN,   
										NULL,      //INTERFACE_DATE,   
										NULL,      //SALE_PRICE,   
										NULL,      //SALE_AMT,   
										NULL,      //SALE_CURRENCY,   
										NULL,      //ARRIVAL_DATE,   
										NULL,      //ARRIVAL_SEQ_NO,   
										NULL,      //DEST_ORGANIZATION_ID,   
										NULL,      //INSPECT_NO,   
										NULL,      //RETURN_REQUEST_DATE,   
										NULL,      //RETURN_REQUEST_SEQUENCE,   
										'N',         //CLOSE_YN,   
										NULL,      //CLOSE_DATE,   
										NULL,      //DEMAND_QTY 
										:lvdb_lot_divide_sequence ,
										'',
										'',
										:LVS_FEEDER_LOCATION_CODE,
										:lvdt_receipt_compare_date,
										:lvs_inventory_type
									)  ;												
						
			         //================================================
				     //
					 //===============================================
					if Upperbound(ivl_divide_qty)  = 1 or i = Upperbound(ivl_divide_qty) -1  then 
						exit
					end if 
					
					//================================================
					//
					//================================================
					
		loop until i = Upperbound(ivl_divide_qty) 
		
			if Upperbound(ivl_divide_qty)  = 1 then 
			else	
				    //$$HEX8$$d0c620006fb8b8d2200088bc38d62000$$ENDHEX$$
					lvs_receipt_lot_no = lvs_receipt_lot_no_org
					LVL_QTY = ivl_divide_qty[upperbound(ivl_divide_qty)]
					
					//====================================================
					// $$HEX10$$14bc54cfdcb4200018c2c9b72000c0bcbdac2000$$ENDHEX$$
					//====================================================
					UPDATE IM_ITEM_RECEIPT_BARCODE
						SET 	SCAN_QTY =:LVL_QTY ,
								LOT_DIVIDE_DATE = SYSDATE  ,
								ITEM_BARCODE = :lvs_item_code||'-'||:lvs_receipt_lot_no||'-'||:LVL_QTY ,
								LOT_DIVIDE_YN = 'Y' ,
								ORIGIN_LOT_NO = :lvs_receipt_lot_no ,
								LOT_DIVIDE_SEQUENCE = :lvdb_lot_divide_sequence ,
								REAL_DIVIDE_REASON = :lvs_real_divide_reason ||' REEL' , 
								NEW_SCAN_QTY = :LVL_QTY ,
								INVENTORY_TYPE = :lvs_inventory_type
								
					WHERE ITEM_CODE   = :LVS_ITEM_CODE
						 AND LOT_NO       = :lvs_receipt_lot_no
						 AND ORGANIZATION_ID = :GVI_ORganization_id ;
							 
					  if f_sql_check() <  0 then 
						sle_item_barcode.text = ''
						sle_item_barcode.setfocus( )
						return -1 
					  end if 
					  
					  //=====================================================
		  
						if cbx_auto_print.checked = true then 		
							
									
										 if cbx_lg.checked = true then 
												dw_6.retrieve( sle_item_code.text , lvs_slip_no  , lvs_receipt_lot_no , gvi_organization_id )
												if dw_6.rowcount() > 0 then 	
													dw_6.print( )
												else
													f_msgbox(117)
													sle_item_barcode.text = ''
													sle_item_barcode.setfocus( )
												end if 									
										end if 
							
										   if rb_reel.checked = true then 
							
														
															lvs_itemcode = sle_item_code.text 
															dw_3.retrieve( sle_item_code.text , lvs_slip_no  , lvs_receipt_lot_no , gvi_organization_id )
															if dw_3.rowcount() > 0 then 	
																dw_3.print( )
																  
																  //$$HEX7$$68d5b5c27cb7a8bc20009ccd25b8$$ENDHEX$$
																  If cbx_msl.checked = true Then			  	 
																	// MSL$$HEX6$$90c7acc7ecc580bdb4cc6cd0$$ENDHEX$$
																	  SELECT NVL(msl_level, '0')
																		  INTO :lvs_msl_level
																		FROM  id_item
																	  WHERE item_code = :lvs_itemcode
																		  AND organization_id = :gvi_organization_id  ;
																	  
																	  IF F_SQL_CHECK() < 0 THEN 
																	  Else
																		 IF  lvs_msl_level > '2'  THEN
																			 dw_7.retrieve( sle_item_code.text , lvs_slip_no  , lvs_receipt_lot_no , gvi_organization_id )
																			 if dw_7.rowcount() > 0 then 	
																				dw_7.print( )
																			 end if
																		  End if	
																	  END IF 		
																End if
															else
																f_msgbox(117)
																sle_item_barcode.text = ''
																sle_item_barcode.setfocus( )
															end if 
										else
											
												dw_4.retrieve(  sle_item_code.text , lvs_slip_no  , lvs_receipt_lot_no  , gvi_organization_id )
												if dw_4.rowcount() > 0 then 	
												   dw_4.print( )
												else
													f_msgbox(117)
													sle_item_barcode.text = ''
													sle_item_barcode.setfocus( )
												end if 
												
										end if 
															
															
															
															
						end if 		
						
			end if
//==================================================
// $$HEX10$$b8d208b874c720007cb7a8bc78c7bdacb0c62000$$ENDHEX$$
// $$HEX32$$74c7f8bb20007cb778c7d0c5200000b35cd42000b8d208b874c77cb920009ccde0ac20005cd5c4d6200084bd60d544c7200058d530ae20004cb538bbd0c52000$$ENDHEX$$...
//==================================================
else	

	SELECT LINE_CODE , FEEDING_MODEL , FEEDING_YN , ISSUE_DIVISION , FEEDER_SHAFT , LOCATION_CODE , ISSUE_COMPARE_YN , ISSUE_COMPARE_DATE  ,
	            MSL_PASSED_TIME , MSL_REMAIN_TIME , vendor_lotno , vendor_CODE , real_divide_reason , receipt_compare_date, nvl(MANUFACTURE_WEEK, '*'),
			   NVL(SUPPLIER_BARCODE, '*') , inventory_type,
				manufacture_date, pcb_coating_date
	    INTO :LVS_LINE_CODE , :LVS_FEEDING_MODEL , :LVS_FEEDING_YN , :LVS_ISSUE_DIVISION , :LVS_FEEDER_SHAFT , :LVS_FEEDER_LOCATION_CODE , :LVS_ISSUE_COMPARE_YN ,
		        :LVDT_ISSUE_COMPARE_DATE  ,
	            :LVL_MSL_PASSED_TIME , :LVL_MSL_REMAIN_TIME , :LVS_vendor_lotno , :LVS_vendor_CODE , :LVS_real_divide_reason , :lvdt_receipt_compare_date, :lvs_manufacture_week,
			   :lvs_suppiler_barcode	, :lvs_inventory_type,
		  	   :lvdt_manufacture_date, :lvdt_pcb_coating_date
     FROM IM_ITEM_RECEIPT_BARCODE 
   WHERE ITEM_BARCODE = :LVS_our_barcode 
	   AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
		
  if f_sql_check() <  0 then 
		sle_item_barcode.text = ''
		sle_item_barcode.setfocus( )
		return -1 
  end if 	

//==================================================
// $$HEX13$$14bc54cfdcb4200015c8f4bcd0c5200085c725b85cd5e4b22000$$ENDHEX$$
//==================================================
lvdb_lot_divide_sequence =  F_GET_SEQUENCE('SEQ_LOT_DIVIDE_SEQUENCE')
lvl_row = 0 
i = 0
do
	    i++
         F_INSERT()
		
		lvdb_receipt_lot_no = F_GET_SEQUENCE('SEQ_MATERIAL_BARCODE')
		lvs_receipt_lot_no =   F_YMD_SYSDATE() +STRING(lvdb_receipt_lot_no) //  STRING(F_T_SYSDATE(),'YYMMDD')+STRING(lvdb_receipt_lot_no)
		
		dw_2.object.item_code[LVL_ROW]             = lvs_item_code //$$HEX5$$fcd3a9ba54cfdcb42000$$ENDHEX$$
		dw_2.object.lot_no[LVL_ROW]                   = lvs_receipt_lot_no  //$$HEX5$$6fb8b8d288bc38d62000$$ENDHEX$$

		dw_2.object.receipt_slip_no[LVL_ROW]       = lvs_slip_no
		dw_2.object.supplier_code[LVL_ROW]         = lvs_supplier_code
		dw_2.object.from_supplier_code[LVL_ROW] = LVS_FROM_SUPPLIER_CODE
		
		dw_2.object.receipt_compare_yn[lvl_row]   = 'Y' //$$HEX5$$44be50ad44c6ccb82000$$ENDHEX$$
		dw_2.object.receipt_compare_date[lvl_row]   =  lvdt_receipt_compare_date
		dw_2.object.issue_compare_yn[lvl_row]     =  'Y' //$$HEX42$$9ccde0ac200044be50ad44c6ccb820002000b4b940c720009ccde0ac200000b330ae5cb82000ccb9e4b4e0ac2000b8d208b874c794b2200074c7f8bb20009ccde0ac1cb42000c1c0dcd05cb820005cd5e4b22000$$ENDHEX$$
		dw_2.object.barcode_status[lvl_row]          =  'N'// 		

	     dw_2.object.receipt_type[lvl_row]             = lvs_receipt_type //$$HEX5$$85c7e0ac20c715d62000$$ENDHEX$$
		dw_2.object.scan_date[LVL_ROW]            = f_t_sysdate()
	
		dw_2.object.scan_qty[LVL_ROW]              = ivl_divide_qty[i]
		dw_2.object.new_scan_qty[LVL_ROW]              = ivl_divide_qty[i]
		dw_2.object.item_barcode[LVL_ROW]       = sle_item_code.text+"-"+lvs_receipt_lot_no+"-"+string( ivl_divide_qty[i])// $$HEX7$$5ccd85c814bc54cfdcb420000900$$ENDHEX$$
		
		dw_2.object.lot_divide_yn[lvl_row] = 'Y' 
		DW_2.object.origin_item_barcode[lvl_row] = lvs_our_barcode
		dw_2.object.lot_divide_date[lvl_row]          = f_sysdate()
	     dw_2.object.label_type[lvl_row]                 = lvs_label_type
		dw_2.object.lot_divide_sequence[lvl_row]   = lvdb_lot_divide_sequence 

		dw_2.object.line_code[lvl_row] = LVS_LINE_CODE
		dw_2.object.feeding_model[lvl_row] =LVS_FEEDING_MODEL
		dw_2.object.feeding_yn[lvl_row] = LVS_FEEDING_YN
		dw_2.object.issue_compare_date[lvl_row] = LVDT_ISSUE_COMPARE_DATE
		dw_2.object.issue_compare_by[lvl_row] = gvs_user_id
		dw_2.object.feeder_shaft[lvl_row] = lvs_feeder_shaft
		dw_2.object.location_code[lvl_row] = LVS_FEEDER_LOCATION_CODE
		dw_2.object.msl_passed_time[lvl_row] = lvl_MSL_PASSED_TIME
		dw_2.object.msl_remain_time[lvl_row] = lvl_msl_remain_time 
		dw_2.object.vendor_lotno[lvl_row] = lvs_vendor_lotno
		dw_2.object.vendor_code[lvl_row] = lvs_vendor_CODE
		dw_2.object.real_divide_reason[lvl_row] = lvs_real_divide_reason
		dw_2.object.issue_division[lvl_row] = lvs_issue_division
         dw_2.object.manufacture_week[lvl_row] = lvs_manufacture_week	
         dw_2.object.supplier_barcode[lvl_row] = lvs_suppiler_barcode
			
		dw_2.object.manufacture_date[lvl_row] = lvdt_manufacture_date
		dw_2.object.pcb_coating_date[lvl_row] = lvdt_pcb_coating_date	 

			//=====================================================
			//
			//=====================================================
			 if dw_2.update() < 0 then 
					dw_2.reset()
					rollback ;
					sle_item_barcode.TEXT = ''
					sle_item_barcode.SETFOCus( )
					f_play_sound("$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav")			
					return 
			end if 
//====================================================
//
//====================================================

					if cbx_auto_print.checked = true then 	

								dw_4.retrieve(  sle_item_code.text ,lvs_slip_no  , lvs_receipt_lot_no  , gvi_organization_id )
								if dw_4.rowcount() > 0 then 	
									dw_4.print( )
								else
									f_msgbox(117)
									sle_item_barcode.text = ''
									sle_item_barcode.setfocus( )
								end if 		
					end if 			
					
					if Upperbound(ivl_divide_qty)  = 1 or i = Upperbound(ivl_divide_qty) -1  then 
						exit
					end if 
		
		loop until i = Upperbound(ivl_divide_qty) 
		//===========================================================
		//  1 $$HEX33$$1cac74c7c1c0200084bd60d5200018b4c8c53cc774ba2000c8b9c0c9c9b92000d0c52000d0c620007cb7a8bc200018c2c9b744c72000c0bcbdac20005cd5e4b22000$$ENDHEX$$
		//===========================================================
		if Upperbound(ivl_divide_qty)  = 1 then 
			
		else
			
			lvs_receipt_lot_no = lvs_receipt_lot_no_org
			LVL_QTY = ivl_divide_qty[upperbound(ivl_divide_qty)]
			
			//====================================================
			// $$HEX10$$14bc54cfdcb4200018c2c9b72000c0bcbdac2000$$ENDHEX$$
			//====================================================
			UPDATE IM_ITEM_RECEIPT_BARCODE
				SET 	SCAN_QTY =:LVL_QTY ,
						LOT_DIVIDE_DATE = SYSDATE  ,
						ITEM_BARCODE = :lvs_item_code||'-'||:lvs_receipt_lot_no||'-'||:LVL_QTY ,
						LOT_DIVIDE_YN = 'Y' ,
						ORIGIN_LOT_NO = :lvs_receipt_lot_no ,
						LOT_DIVIDE_SEQUENCE = :lvdb_lot_divide_sequence,
						REAL_DIVIDE_REASON = :lvs_real_divide_reason||' TRAY' ,
						NEW_SCAN_QTY = :LVL_QTY ,
						INVENTORY_TYPE = :lvs_inventory_type
						
			WHERE ITEM_CODE   = :LVS_ITEM_CODE
				 AND LOT_NO       = :lvs_receipt_lot_no
				 AND ORGANIZATION_ID = :GVI_ORganization_id ;
					 
			  if f_sql_check() <  0 then 
				sle_item_barcode.text = ''
				sle_item_barcode.setfocus( )
				return -1 
			  end if 
		
			if cbx_auto_print.checked = true then 
			
					dw_4.retrieve(  sle_item_code.text , lvs_slip_no  , lvs_receipt_lot_no  , gvi_organization_id )
					if dw_4.rowcount() > 0 then 	
						dw_4.print( )
					else
						f_msgbox(117)
						sle_item_barcode.text = ''
						sle_item_barcode.setfocus( )
					end if 
			end if 		
		
		end if
end if 		
//====================================================
//
//====================================================

IF  dw_2.UPDATE() < 0   THEN
	dw_2.reset()
	ROLLBACK;
	sle_item_barcode.text = ''
	sle_item_barcode.setfocus( )
	f_play_sound("$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav")
	RETURN					
ELSE
	COMMIT;
	F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
	f_play_sound("$$HEX4$$00c8a5c731c1f5ac$$ENDHEX$$.wav")	
END IF 

//==================================================
//
//==================================================
st_status.text = "OK"
cb_divide.enabled = false
sle_qty.text = ''
sle_item_code.text = ''
sle_total_qty.text = ''
sle_item_barcode.text = ''
sle_divide_reason.text = ''
//=======================================
//
//=======================================
if cbx_reel_divide_compare_yn.checked = true then 
	
	sle_supplier_barcode.text = ''
	sle_supplier_barcode.setfocus()
	
else
	sle_divide_reason.setfocus()
end if


end event

type sle_item_code from so_singlelineedit within w_mat_receipt_barcode_divide_master
integer x = 3909
integer y = 384
integer width = 544
integer height = 96
boolean bringtotop = true
textcase textcase = upper!
end type

event getfocus;call super::getfocus;sle_item_barcode.setfocus()
end event

type st_5 from so_statictext within w_mat_receipt_barcode_divide_master
integer x = 3570
integer y = 396
integer width = 329
integer height = 72
boolean bringtotop = true
integer textsize = -10
long textcolor = 0
string text = "Item Code"
alignment alignment = right!
end type

event clicked;call super::clicked;sle_item_barcode.setfocus()
end event

type ddlb_receipt_type from uo_basecode within w_mat_receipt_barcode_divide_master
integer x = 3131
integer y = 156
integer width = 370
integer taborder = 40
boolean bringtotop = true
boolean allowedit = true
boolean hscrollbar = true
boolean vscrollbar = true
string ivs_type = "0"
end type

event constructor;call super::constructor;this.redraw('RECEIPT TYPE')
end event

type st_2 from so_statictext within w_mat_receipt_barcode_divide_master
integer x = 3131
integer y = 68
integer width = 370
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Receipt Type"
end type

type sle_qty from so_singlelineedit within w_mat_receipt_barcode_divide_master
integer x = 1605
integer y = 576
integer width = 302
integer height = 84
integer taborder = 70
boolean bringtotop = true
boolean enabled = false
textcase textcase = upper!
end type

event modified;call super::modified;
//if cbx_old_type.checked = true then 
//	
//	lvl_total_qty =  long(this.text)
//	if lvl_total_qty <=0 then 
//		
//		f_play_sound("$$HEX4$$18c2c9b724c658b9$$ENDHEX$$.wav")	
//		st_status.text = "$$HEX15$$85c7e0ac18c2c9b774c720002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$"	
//		this.setfocus()
//		this.selecttext( 1,100)	
//		return -1
//	end if 	
//	
//end if 

sle_total_qty.text = string(lvl_total_qty)
//=========================================
//
//=========================================
//if cbx_old_type.checked = true then 
//	cb_divide.setfocus()
//end if 
end event

type sle_lot_no from so_singlelineedit within w_mat_receipt_barcode_divide_master
integer x = 2670
integer y = 156
integer width = 457
integer height = 84
integer taborder = 40
boolean bringtotop = true
end type

type st_6 from so_statictext within w_mat_receipt_barcode_divide_master
integer x = 2674
integer y = 68
integer width = 457
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Lot No"
end type

type rb_barcode_list from so_radiobutton within w_mat_receipt_barcode_divide_master
integer x = 82
integer y = 76
boolean bringtotop = true
integer textsize = -10
string text = "Barcode List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
dw_2.bringtotop = true 
selected_data_window = dw_1
end event

type rb_2 from so_radiobutton within w_mat_receipt_barcode_divide_master
integer x = 82
integer y = 184
boolean bringtotop = true
integer textsize = -10
string text = "Reel Divide List"
end type

event clicked;call super::clicked;dw_5.bringtotop = true 
selected_data_window = dw_5
end event

type pb_2 from so_commandbutton within w_mat_receipt_barcode_divide_master
boolean visible = false
integer x = 37
integer y = 708
integer width = 416
integer height = 128
integer taborder = 50
boolean bringtotop = true
integer weight = 400
string text = "Check"
end type

event clicked;call super::clicked;long lvi_check , lvi_issue_check , lvi_receipt_check , lvl_loop
string lvs_lot_no  , lvs_issue_return_yn , lvs_check_status , lvs_check_issue_status , lvs_check_receipt_status
string lvs_line_code   , lvs_supplier_barcode
long    lvl_receipt_sequence , lvl_receipt_qty
LONG LVL_RECEIPT_LOT_NO
DATETIME lvdt_receipt_Date ,  lvdt_issue_Date

lvl_loop =  dw_1.rowcount()

if lvl_loop = 0 then 
	return 
end if 

//=====================================================
//
//=====================================================
do
	
	lvi_check++
	
	lvs_item_code = dw_1.object.item_code[lvi_check]
	lvs_lot_no = dw_1.object.lot_no[lvi_check]
	lvs_origin_lot_no= dw_1.object.origin_lot_no[lvi_check]
	lvs_receipt_compare_yn = dw_1.object.receipt_compare_yn[lvi_check]
	lvs_issue_compare_yn = dw_1.object.issue_compare_yn[lvi_check]
	lvs_issue_return_yn = dw_1.object.issue_return_yn[lvi_check]
	
	select count(*) 
	  into :lvi_issue_check
	 from im_item_issue 
   where item_code     = :lvs_item_code
	  and material_mfs = :lvs_lot_no ;
	 
	 if f_sql_check() < 0 then 
		return 
	 end if 
	  
	select count(*) 
	  into :lvi_receipt_check
	 from im_item_receipt
   where item_code = :lvs_item_code
	  and material_mfs = :lvs_lot_no ;	  
	  
	 if f_sql_check() < 0 then 
		return 
	 end if 	

//====================================================
// $$HEX6$$9ccde0ac200018bc88d42000$$ENDHEX$$
//====================================================
if lvs_check_issue_status = '3' then 
			INSERT INTO IM_ITEM_ISSUE  
			( ITEM_CODE,   
			  ISSUE_DATE,   
			  ISSUE_SEQUENCE,   
			  ORGANIZATION_ID,   
			  MFS,   
			  LOCATION_CODE,   
			  ITEM_TYPE,   
			  LINE_CODE,   
			  WORKSTAGE_CODE,   
			  ISSUE_DEFICIT,   
			  ISSUE_QTY,   
			  ISSUE_STATUS,   
			  ISSUE_AMT,   
			  ISSUE_ACCOUNT,   
			  LINE_TYPE,   
			  COMMENTS,   
			  ISSUE_PRICE,   
			  VIRTUAL_RECEIPT_YN,   
			  ISSUE_TYPE,   
			  SUPPLIER_CODE,   
			  WORK_ORDER_NO,   
			  ENTER_DATE,   
			  ENTER_BY,   
			  LAST_MODIFY_DATE,   
			  LAST_MODIFY_BY,   
			  MACHINE_CODE,   
			  INVOICE_NO,   
			  MADE_BY,   
			  PARENT_ITEM_CODE,   
			  MATERIAL_MFS,   
			  INTERFACE_YN,   
			  INTERFACE_DATE,   
			  SALE_PRICE,   
			  SALE_AMT,   
			  SALE_CURRENCY,   
			  ARRIVAL_DATE,   
			  ARRIVAL_SEQ_NO,   
			  DEST_ORGANIZATION_ID,   
			  INSPECT_NO,   
			  RETURN_REQUEST_DATE,   
			  RETURN_REQUEST_SEQUENCE,   
			  CLOSE_YN,   
			  CLOSE_DATE,   
			  DEMAND_QTY,BARCODE )  
VALUES  (   :lvs_item_code,      //ITEM_CODE, 
				:lvdt_issue_Date,      //ISSUE_DATE,   
				SEQ_MAT_ISSUE.NEXTVAL ,      //ISSUE_SEQUENCE,   
				:GVI_ORGANIZATION_ID ,      //ORGANIZATION_ID,   
				'*',      //MFS,   
				:LVS_LOCATION_CODE ,      //LOCATION_CODE,   
				'T',      //ITEM_TYPE,   
				:lvs_line_code,      //LINE_CODE,   
				'*',      //WORKSTAGE_CODE,   
				3,      //ISSUE_DEFICIT,   
				:lvl_issue_qty  ,      //ISSUE_QTY,   
				'N',      //ISSUE_STATUS,   
				0 ,      //ISSUE_AMT,   
				'M001',      //ISSUE_ACCOUNT,   
				F_GET_LINE_TYPE_FROM_ITEM( :lvs_item_code , :gvi_organization_id ) ,      //LINE_TYPE,   
				NULL,      //COMMENTS,   
				0 ,      //ISSUE_PRICE,   
				NULL,      //VIRTUAL_RECEIPT_YN,   
				'N',      //ISSUE_TYPE,   
				'*' ,      //SUPPLIER_CODE,   
				'*',      //WORK_ORDER_NO,   
				sysdate ,      //ENTER_DATE,   
				:gvs_user_id ,      //ENTER_BY,   
				sysdate ,      //LAST_MODIFY_DATE,   
				:gvs_user_id ,      //LAST_MODIFY_BY,   
				'*',      //MACHINE_CODE,   
				:LVS_SLIP_NO ,      //INVOICE_NO,   
				NULL,      //MADE_BY,   
				'*',      //PARENT_ITEM_CODE,   
				:lvs_lot_no ,      //MATERIAL_MFS,   
				NULL,      //INTERFACE_YN,   
				NULL,      //INTERFACE_DATE,   
				NULL,      //SALE_PRICE,   
				NULL,      //SALE_AMT,   
				NULL,      //SALE_CURRENCY,   
				NULL,      //ARRIVAL_DATE,   
				NULL,      //ARRIVAL_SEQ_NO,   
				NULL,      //DEST_ORGANIZATION_ID,   
				NULL,      //INSPECT_NO,   
				NULL,      //RETURN_REQUEST_DATE,   
				NULL,      //RETURN_REQUEST_SEQUENCE,   
				'N',         //CLOSE_YN,   
				NULL,      //CLOSE_DATE,   
				NULL ,      //DEMAND_QTY 
				:LVS_OUR_BARCODE
		)  ;
		
elseif lvs_check_issue_status = '4' then 
	
		INSERT INTO IM_ITEM_ISSUE  
			( ITEM_CODE,   
			  ISSUE_DATE,   
			  ISSUE_SEQUENCE,   
			  ORGANIZATION_ID,   
			  MFS,   
			  LOCATION_CODE,   
			  ITEM_TYPE,   
			  LINE_CODE,   
			  WORKSTAGE_CODE,   
			  ISSUE_DEFICIT,   
			  ISSUE_QTY,   
			  ISSUE_STATUS,   
			  ISSUE_AMT,   
			  ISSUE_ACCOUNT,   
			  LINE_TYPE,   
			  COMMENTS,   
			  ISSUE_PRICE,   
			  VIRTUAL_RECEIPT_YN,   
			  ISSUE_TYPE,   
			  SUPPLIER_CODE,   
			  WORK_ORDER_NO,   
			  ENTER_DATE,   
			  ENTER_BY,   
			  LAST_MODIFY_DATE,   
			  LAST_MODIFY_BY,   
			  MACHINE_CODE,   
			  INVOICE_NO,   
			  MADE_BY,   
			  PARENT_ITEM_CODE,   
			  MATERIAL_MFS,   
			  INTERFACE_YN,   
			  INTERFACE_DATE,   
			  SALE_PRICE,   
			  SALE_AMT,   
			  SALE_CURRENCY,   
			  ARRIVAL_DATE,   
			  ARRIVAL_SEQ_NO,   
			  DEST_ORGANIZATION_ID,   
			  INSPECT_NO,   
			  RETURN_REQUEST_DATE,   
			  RETURN_REQUEST_SEQUENCE,   
			  CLOSE_YN,   
			  CLOSE_DATE,   
			  DEMAND_QTY,BARCODE )  
VALUES  (   :lvs_item_code,      //ITEM_CODE, 
				:lvdt_issue_Date ,      //ISSUE_DATE,   
				SEQ_MAT_ISSUE.NEXTVAL ,      //ISSUE_SEQUENCE,   
				:GVI_ORGANIZATION_ID ,      //ORGANIZATION_ID,   
				'*',      //MFS,   
				:LVS_LOCATION_CODE ,      //LOCATION_CODE,   
				'T',      //ITEM_TYPE,   
				:lvs_line_code,      //LINE_CODE,   
				'*',      //WORKSTAGE_CODE,   
				4,      //ISSUE_DEFICIT,   
				:lvl_issue_qty * -1 ,      //ISSUE_QTY,   
				'N',      //ISSUE_STATUS,   
				0 ,      //ISSUE_AMT,   
				'M001',      //ISSUE_ACCOUNT,   
				F_GET_LINE_TYPE_FROM_ITEM( :lvs_item_code , :gvi_organization_id ) ,      //LINE_TYPE,   
				NULL,      //COMMENTS,   
				0 ,      //ISSUE_PRICE,   
				NULL,      //VIRTUAL_RECEIPT_YN,   
				'N',      //ISSUE_TYPE,   
				'*' ,      //SUPPLIER_CODE,   
				'*',      //WORK_ORDER_NO,   
				sysdate ,      //ENTER_DATE,   
				:gvs_user_id ,      //ENTER_BY,   
				sysdate ,      //LAST_MODIFY_DATE,   
				:gvs_user_id ,      //LAST_MODIFY_BY,   
				'*',      //MACHINE_CODE,   
				:LVS_SLIP_NO ,      //INVOICE_NO,   
				NULL,      //MADE_BY,   
				'*',      //PARENT_ITEM_CODE,   
				:lvs_lot_no ,      //MATERIAL_MFS,   
				NULL,      //INTERFACE_YN,   
				NULL,      //INTERFACE_DATE,   
				NULL,      //SALE_PRICE,   
				NULL,      //SALE_AMT,   
				NULL,      //SALE_CURRENCY,   
				NULL,      //ARRIVAL_DATE,   
				NULL,      //ARRIVAL_SEQ_NO,   
				NULL,      //DEST_ORGANIZATION_ID,   
				NULL,      //INSPECT_NO,   
				NULL,      //RETURN_REQUEST_DATE,   
				NULL,      //RETURN_REQUEST_SEQUENCE,   
				'N',         //CLOSE_YN,   
				NULL,      //CLOSE_DATE,   
				NULL ,      //DEMAND_QTY 
				:LVS_OUR_BARCODE
		)  ;
		
	end if 
	

	 if  f_sql_check() < 0 then
		st_status.text = '$$HEX22$$10cde0ac200018bc88d4200098ccacb9200011c9200024c658b900ac20001cbcddc0200088d5b5c2c8b2e4b2$$ENDHEX$$'
		return
	end if      
     
//=====================================================
//
//=====================================================
if lvs_check_receipt_status = '1' then 
			lvl_receipt_sequence = F_GET_SEQUENCE('SEQ_MAT_RECEIPT')
			
			INSERT INTO IM_ITEM_RECEIPT  
							( RECEIPT_SEQUENCE,   
							  RECEIPT_DATE,   
							  ORGANIZATION_ID,   
							  LOCATION_CODE,   
							  DELIVERY,   
							  RECEIPT_DEFICIT,   
							  LINE_TYPE,   
							  RECEIPT_QTY,   
							  MATERIAL_COST,   
							  UNIT_PRICE,   
							  MATERIAL_COST_AMT,   
							  ENTER_DATE,   
							  INVOICE_NO,   
							  RECEIPT_AMT,   
							  ENTER_BY,   
							  EXCHANGE_RATE,   
							  FOREIGN_RECEIPT_AMT,   
							  SUPPLIER_CODE,   
							  LAST_MODIFY_DATE,   
							  LAST_MODIFY_BY,   
							  CONFIRM_YN,   
							  CONFIRM_DATE,   
							  RECEIPT_TYPE,   
							  MFS,   
							  ARRIVAL_DATE,   
							  ARRIVAL_SEQ_NO,   
							  VIRTUAL_RECEIPT_YN,   
							  COMMENTS,   
							  WORK_ORDER_NO,   
							  CURRENCY,   
							  BARCODE,   
							  RECEIPT_STATUS,   
							  ITEM_CODE,   
							  MATERIAL_MFS,   
							  INTERFACE_YN,   
							  INTERFACE_DATE,   
							  RECEIPT_LOT_NO,   
							  RECEIPT_EXPENSE_COST,   
							  INCIDENTAL_EXPENSE_CODE,   
							  INTERFACE_WORK_NO,   
							  TARIFF_RATE,   
							  TARIFF_AMT,   
							  ORDER_NO,   
							  ORIGIN_MFS,   
							  ORIGIN_SUPPLIER_CODE,   
							  ORDER_TYPE,   
							  CONFIRM_BY,   
							  SUBCONTRACT_INVOICE_NO,   
							  INVOICE_OPEN_YN,   
							  INVOICE_OPEN_SEQUENCE,   
							  CLOSE_YN,   
							  CLOSE_DATE, FROM_SUPPLIER_CODE )  
							  
					 VALUES( :lvl_receipt_sequence ,      //RECEIPT_SEQUENCE,   
							  :lvdt_receipt_Date,      //RECEIPT_DATE,   
							  1,      //ORGANIZATION_ID,   
							   'M01',      //LOCATION_CODE,   
							  1,      //DELIVERY,   
							  1,      //RECEIPT_DEFICIT,   
							  F_GET_LINE_TYPE_FROM_ITEM( :lvs_item_code , :gvi_organization_id ) ,      //LINE_TYPE,   
							  :lvl_receipt_qty ,      //RECEIPT_QTY,   
							  0,      //MATERIAL_COST,   
							  0 ,      //UNIT_PRICE,   
							  0,      //MATERIAL_COST_AMT,   
							  sysdate,      //ENTER_DATE,   
							  :lvs_slip_no ,      //INVOICE_NO,   
							  0 ,      //RECEIPT_AMT,   
							  :GVS_USER_ID ,      //ENTER_BY,   
							  1,      //EXCHANGE_RATE,   
							  0,      //FOREIGN_RECEIPT_AMT,   
							  :LVS_SUPPLIER_CODE ,      //SUPPLIER_CODE,   
							  SYSDATE,      //LAST_MODIFY_DATE,   
							  :GVS_USER_ID ,      //LAST_MODIFY_BY,   
							  'N',      //CONFIRM_YN,   
							  TRUNC(SYSDATE),      //CONFIRM_DATE,   
							  :LVS_RECEIPT_TYPE,      //RECEIPT_TYPE,   
							  'M01',      //MFS,   
							  NULL,      //ARRIVAL_DATE,   
							  0,      //ARRIVAL_SEQ_NO,   
							  'N',      //VIRTUAL_RECEIPT_YN,   
							  '*',      //COMMENTS,   
							  NULL,      //WORK_ORDER_NO,   
							  'WON',      //CURRENCY,   
							  :LVS_OUR_BARCODE,      //BARCODE,   
							  'N',      //RECEIPT_STATUS,   
							  :LVS_ITEM_CODE ,      //ITEM_CODE,   
							 :lvs_lot_no,      //MATERIAL_MFS,   
							  'N',      //INTERFACE_YN,   
							  NULL,      //INTERFACE_DATE,   
							  :LVL_RECEIPT_LOT_NO ,      //RECEIPT_LOT_NO,   
							  0,      //RECEIPT_EXPENSE_COST,   
							  '*',      //INCIDENTAL_EXPENSE_CODE,   
							  NULL,      //INTERFACE_WORK_NO,   
							  0,      //TARIFF_RATE,   
							  0,      //TARIFF_AMT,   
							  0,      //ORDER_NO,   
							  :lvs_supplier_barcode,      //ORIGIN_MFS,   
							  '*',      //ORIGIN_SUPPLIER_CODE,   
							  'M',      //ORDER_TYPE,   
							  :gvs_user_id,      //CONFIRM_BY,   
							  NULL,      //SUBCONTRACT_INVOICE_NO,   
							  'N',      //INVOICE_OPEN_YN,   
							  0,      //INVOICE_OPEN_SEQUENCE,   
							  'Y',      //CLOSE_YN,   
							  NULL,
							  :LVS_FROM_SUPPLIER_CODE)      //CLOSE_DATE
						  ;
						 
						 
elseif lvs_check_receipt_status = '2' then 

		lvl_receipt_sequence = F_GET_SEQUENCE('SEQ_MAT_RECEIPT')
			
			INSERT INTO IM_ITEM_RECEIPT  
							( RECEIPT_SEQUENCE,   
							  RECEIPT_DATE,   
							  ORGANIZATION_ID,   
							  LOCATION_CODE,   
							  DELIVERY,   
							  RECEIPT_DEFICIT,   
							  LINE_TYPE,   
							  RECEIPT_QTY,   
							  MATERIAL_COST,   
							  UNIT_PRICE,   
							  MATERIAL_COST_AMT,   
							  ENTER_DATE,   
							  INVOICE_NO,   
							  RECEIPT_AMT,   
							  ENTER_BY,   
							  EXCHANGE_RATE,   
							  FOREIGN_RECEIPT_AMT,   
							  SUPPLIER_CODE,   
							  LAST_MODIFY_DATE,   
							  LAST_MODIFY_BY,   
							  CONFIRM_YN,   
							  CONFIRM_DATE,   
							  RECEIPT_TYPE,   
							  MFS,   
							  ARRIVAL_DATE,   
							  ARRIVAL_SEQ_NO,   
							  VIRTUAL_RECEIPT_YN,   
							  COMMENTS,   
							  WORK_ORDER_NO,   
							  CURRENCY,   
							  BARCODE,   
							  RECEIPT_STATUS,   
							  ITEM_CODE,   
							  MATERIAL_MFS,   
							  INTERFACE_YN,   
							  INTERFACE_DATE,   
							  RECEIPT_LOT_NO,   
							  RECEIPT_EXPENSE_COST,   
							  INCIDENTAL_EXPENSE_CODE,   
							  INTERFACE_WORK_NO,   
							  TARIFF_RATE,   
							  TARIFF_AMT,   
							  ORDER_NO,   
							  ORIGIN_MFS,   
							  ORIGIN_SUPPLIER_CODE,   
							  ORDER_TYPE,   
							  CONFIRM_BY,   
							  SUBCONTRACT_INVOICE_NO,   
							  INVOICE_OPEN_YN,   
							  INVOICE_OPEN_SEQUENCE,   
							  CLOSE_YN,   
							  CLOSE_DATE, FROM_SUPPLIER_CODE )  
							  
					 VALUES( :lvl_receipt_sequence ,      //RECEIPT_SEQUENCE,   
							  :lvdt_receipt_Date,      //RECEIPT_DATE,   
							  1,      //ORGANIZATION_ID,   
							   'M01',      //LOCATION_CODE,   
							  1,      //DELIVERY,   
							  2,      //RECEIPT_DEFICIT,   
							  F_GET_LINE_TYPE_FROM_ITEM( :lvs_item_code , :gvi_organization_id ) ,      //LINE_TYPE,   
							  :lvl_receipt_qty * -1 ,      //RECEIPT_QTY,   
							  0,      //MATERIAL_COST,   
							  0 ,      //UNIT_PRICE,   
							  0,      //MATERIAL_COST_AMT,   
							  sysdate,      //ENTER_DATE,   
							  :lvs_slip_no ,      //INVOICE_NO,   
							  0 ,      //RECEIPT_AMT,   
							  :GVS_USER_ID ,      //ENTER_BY,   
							  1,      //EXCHANGE_RATE,   
							  0,      //FOREIGN_RECEIPT_AMT,   
							  :LVS_SUPPLIER_CODE ,      //SUPPLIER_CODE,   
							  SYSDATE,      //LAST_MODIFY_DATE,   
							  :GVS_USER_ID ,      //LAST_MODIFY_BY,   
							  'N',      //CONFIRM_YN,   
							  TRUNC(SYSDATE),      //CONFIRM_DATE,   
							  :LVS_RECEIPT_TYPE,      //RECEIPT_TYPE,   
							  'M01',      //MFS,   
							  NULL,      //ARRIVAL_DATE,   
							  0,      //ARRIVAL_SEQ_NO,   
							  'N',      //VIRTUAL_RECEIPT_YN,   
							  '*',      //COMMENTS,   
							  NULL,      //WORK_ORDER_NO,   
							  'WON',      //CURRENCY,   
							  :LVS_OUR_BARCODE,      //BARCODE,   
							  'N',      //RECEIPT_STATUS,   
							  :LVS_ITEM_CODE ,      //ITEM_CODE,   
							 :lvs_lot_no,      //MATERIAL_MFS,   
							  'N',      //INTERFACE_YN,   
							  NULL,      //INTERFACE_DATE,   
							  :LVL_RECEIPT_LOT_NO ,      //RECEIPT_LOT_NO,   
							  0,      //RECEIPT_EXPENSE_COST,   
							  '*',      //INCIDENTAL_EXPENSE_CODE,   
							  NULL,      //INTERFACE_WORK_NO,   
							  0,      //TARIFF_RATE,   
							  0,      //TARIFF_AMT,   
							  0,      //ORDER_NO,   
							  :lvs_supplier_barcode,      //ORIGIN_MFS,   
							  '*',      //ORIGIN_SUPPLIER_CODE,   
							  'M',      //ORDER_TYPE,   
							  :gvs_user_id,      //CONFIRM_BY,   
							  NULL,      //SUBCONTRACT_INVOICE_NO,   
							  'N',      //INVOICE_OPEN_YN,   
							  0,      //INVOICE_OPEN_SEQUENCE,   
							  'Y',      //CLOSE_YN,   
							  NULL,
							  :LVS_FROM_SUPPLIER_CODE)      //CLOSE_DATE
						  ;
		end if 
			 if  f_sql_check() < 0 then
				st_status.text = '$$HEX18$$85c7e0ac98ccacb9200011c9200024c658b900ac20001cbcddc0200088d5b5c2c8b2e4b2$$ENDHEX$$'
				return -1
			end if
//=====================================================
//
//=====================================================			
			
	if dw_1.update() < 0 then 
		rollback;
	else
		commit ;
		f_msg_mdi_help( string(lvi_check)+"/"+string(lvl_loop) )
	end if 
		
loop until lvi_check = lvl_loop



end event

type cbx_reel_divide_compare_yn from so_checkbox within w_mat_receipt_barcode_divide_master
integer x = 4037
integer y = 128
integer width = 544
integer height = 68
integer taborder = 20
boolean bringtotop = true
string text = "REEL DVD CPR YN"
end type

event constructor;call super::constructor;if Gvs_REEL_DIVIDE_COMPARE_YN = 'Y' THEN 
  this.checked = true 
else
	this.checked = false
end if 
end event

type sle_supplier_barcode from so_singlelineedit within w_mat_receipt_barcode_divide_master
integer x = 2542
integer y = 428
integer width = 896
integer height = 84
integer taborder = 20
boolean bringtotop = true
textcase textcase = upper!
end type

event modified;call super::modified;sle_our_barcode.setfocus()
end event

type sle_our_barcode from so_singlelineedit within w_mat_receipt_barcode_divide_master
integer x = 2542
integer y = 584
integer width = 896
integer height = 84
integer taborder = 30
boolean bringtotop = true
textcase textcase = upper!
end type

event modified;call super::modified;string lvs_supplier_barcode ,  lvs_lot_no
long lvi_pos1 ,   lvi_pos2 , lvi_pos_check

lvs_supplier_barcode  =sle_supplier_barcode.text
lvs_our_barcode         =sle_our_barcode.text

////=======================================
//// $$HEX11$$00cf3cd554cf200090c7acc778c72000bdacb0c62000$$ENDHEX$$
////=======================================
// IF MID (UPPER (lvs_supplier_barcode), 1, 1) = '['    THEN
//         SELECT  f_get_item_code_from_barcode (:lvs_supplier_barcode)|| '-' || f_get_lot_no_from_barcode (:lvs_supplier_barcode) || '-' || f_get_lot_qty_from_barcode (:lvs_supplier_barcode)
//		    INTO :lvs_supplier_barcode
//	       FROM DUAL ; 
//		
//		IF F_SQL_CHECK() < 0 THEN 
//				sle_supplier_barcode.selecttext( 1,100)	
//		END IF 	 
//ELSE
//		 SELECT  f_get_prepare_barcode (:lvs_supplier_barcode)
//		     INTO :lvs_supplier_barcode
//	       FROM DUAL ; 
//		
//		IF F_SQL_CHECK() < 0 THEN 
//				sle_supplier_barcode.selecttext( 1,100)	
//		END IF 	 
//END IF 
//
////=======================================
//// $$HEX11$$00cf3cd554cf200090c7acc778c72000bdacb0c62000$$ENDHEX$$
////=======================================
// IF MID (UPPER (lvs_our_barcode), 1, 1) = '['    THEN
//         SELECT  f_get_item_code_from_barcode (:lvs_our_barcode)|| '-' || f_get_lot_no_from_barcode (:lvs_our_barcode) || '-' || f_get_lot_qty_from_barcode (:lvs_our_barcode)
//		    INTO :lvs_our_barcode
//	       FROM DUAL ; 
//		
//		IF F_SQL_CHECK() < 0 THEN 
//				sle_our_barcode.selecttext( 1,100)	
//		END IF 	
//		
//	else
//		
//	 SELECT  f_get_prepare_barcode (:lvs_our_barcode)
//		     INTO :lvs_our_barcode
//	       FROM DUAL ; 
//		
//		IF F_SQL_CHECK() < 0 THEN 
//				sle_supplier_barcode.selecttext( 1,100)	
//		END IF 	 
//END IF 

if   lvs_supplier_barcode = '' then 
	sle_supplier_barcode.setfocus()
	sle_supplier_barcode.selecttext( 1,100)
	return -1 
end if 

if lvs_our_barcode = '' then 
	sle_our_barcode.setfocus()
	sle_our_barcode.selecttext( 1,100)
	return -1 
end if 


if lvs_supplier_barcode = lvs_our_barcode then 
	
	f_play_sound("$$HEX9$$d9b37cc714bc54cfdcb4a4c294ce24c658b9$$ENDHEX$$.wav")	
	st_status.text = "$$HEX19$$d9b37cc75cd5200014bc54cfdcb47cb92000a4c294ce200058d574ba200048c529b4c8b2e4b2$$ENDHEX$$"
	sle_our_barcode.text = ''
	sle_supplier_barcode.text = ''
	sle_supplier_barcode.setfocus()
	return -1 
end if 

//==================================================
//  $$HEX6$$88d4a9ba200054cfdcb42000$$ENDHEX$$
//  - $$HEX15$$6cad84bd90c700ac2000c6c53cc774ba200024c658b9200098ccacb92000$$ENDHEX$$
//==================================================

//lvi_pos1 =  pos(lvs_our_barcode , '-' , 7 ) 
//
//if  lvi_pos1 <= 0 then 
//	
//	f_msgbox1(1175 ,lvs_our_barcode )
//	sle_our_barcode.text = ''
//	sle_our_barcode.setfocus()
//	return -1 
//	
//end if 
//
////=================================================
////
////=================================================
//
//lvs_item_code = trim( mid( lvs_our_barcode , 1 ,  lvi_pos1 -1 ))
	SELECT  f_get_item_code_from_barcode (:lvs_our_barcode) 
	INTO :lvs_item_code
	FROM DUAL ; 
	
	IF F_SQL_CHECK() < 0 THEN 
		sle_our_barcode.selecttext( 1,100)	
	END IF 	 
	
	if  lvs_item_code = '' then 
		
		f_play_sound("$$HEX5$$88d4a9baf8bbf1b45db8$$ENDHEX$$.wav")
		f_msgbox1(1175 ,lvs_our_barcode )
		sle_our_barcode.setfocus()
		sle_our_barcode.selecttext( 1,100)
		return 
	end if 
if f_check_item_exists( lvs_item_code , f_t_sysdate())  <= 0 then 
	f_play_sound("$$HEX5$$88d4a9baf8bbf1b45db8$$ENDHEX$$.wav")	
	f_msgbox(9041) //$$HEX10$$fcd3a9bac8b9a4c230d12000f8bbf1b45db82000$$ENDHEX$$
	st_status.text =f_msg_st(9041)
	sle_our_barcode.text = ''
	sle_our_barcode.setfocus()
	return -1
end if 
//==================================================
// $$HEX6$$6fb8b8d2200088bc38d62000$$ENDHEX$$
//==================================================
//lvi_pos2 =  pos(lvs_our_barcode , '-' , lvi_pos1+1 ) 
//
//if  lvi_pos2 <= 0 then 
//	f_msgbox1(1175 ,lvs_our_barcode )
//	sle_our_barcode.text = ''
//	sle_our_barcode.setfocus()
//	return -1 
//end if 
//
//lvs_lot_no = trim( mid( lvs_our_barcode , lvi_pos1+1 ,   lvi_pos2 - lvi_pos1 -1 ))
//if lvs_lot_no = ''  then 
//	st_status.text = "$$HEX15$$6fb8b8d288bc38d600ac20002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$"
//	sle_our_barcode.text = ''
//	sle_our_barcode.setfocus()
//	return -1
//end if 
SELECT  F_GET_LOT_NO_FROM_BARCODE (:lvs_our_barcode ) 
	INTO :lvs_lot_no
	FROM DUAL ; 
	
	IF F_SQL_CHECK() < 0 THEN 
		sle_our_barcode.selecttext( 1,100)	
	END IF 	 

	if lvs_lot_no = ''  then 
		st_status.text =f_msg( "$$HEX15$$6fb8b8d288bc38d600ac20002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$",'S')
		sle_our_barcode.setfocus()
		sle_our_barcode.selecttext( 1,100)	
		return
	end if 

//=========================================================
//  $$HEX8$$88d4a9ba54cfdcb4200044be50ad2000$$ENDHEX$$
//=========================================================
lvi_pos_check = pos( lvs_supplier_barcode ,  lvs_item_code , 1 ) 

		if lvi_pos_check <= 0 then 
				f_play_sound("$$HEX5$$90c7acc788bd7cc758ce$$ENDHEX$$.wav")
				st_status.text = "$$HEX16$$fcd3a9ba88bc38d600ac20007cc758ce200058d5c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$"
				sle_our_barcode.text  = ''
				sle_our_barcode.setfocus()
				return -1
		end if 
//======================================
//
//======================================
IF cbx_reel_divide_compare_yn.Checked = TRUE THEN 
	
	UPDATE IM_ITEM_RECEIPT_BARCODE
	      SET REEL_DIVIDE_COMPARE_YN = 'Y' , 
			    REEL_DIVIDE_COMPARE_DATE = SYSDATE 
	  WHERE LOT_NO = :lvs_lot_no
			 AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
			 
	 IF  F_SQL_CHECK() < 0 THEN 
		 RETURN 
	END IF 

END IF 

f_play_sound("$$HEX4$$00c8a5c731c1f5ac$$ENDHEX$$.wav")
st_status.text = '$$HEX10$$15c8c1c098ccacb9200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$'

sle_our_barcode.text = ''
sle_supplier_barcode.text = ''
sle_supplier_barcode.setfocus()
end event

type st_8 from so_statictext within w_mat_receipt_barcode_divide_master
integer x = 2542
integer y = 512
integer width = 896
integer height = 60
boolean bringtotop = true
integer textsize = -10
long textcolor = 16711680
string text = "Our Barcode"
end type

event clicked;call super::clicked;sle_item_barcode.setfocus()
end event

type st_10 from so_statictext within w_mat_receipt_barcode_divide_master
integer x = 2542
integer y = 356
integer width = 896
integer height = 60
boolean bringtotop = true
integer textsize = -10
long textcolor = 16711680
string text = "Supplier Barcode"
end type

event clicked;call super::clicked;sle_item_barcode.setfocus()
end event

type st_divide_reason from so_statictext within w_mat_receipt_barcode_divide_master
integer x = 709
integer y = 364
integer width = 1193
integer height = 56
boolean bringtotop = true
integer textsize = -10
long textcolor = 16711680
string text = "Divide Reason"
end type

event clicked;call super::clicked;sle_item_barcode.setfocus()
end event

type sle_divide_reason from so_singlelineedit within w_mat_receipt_barcode_divide_master
integer x = 695
integer y = 424
integer width = 1207
integer height = 84
integer taborder = 30
boolean bringtotop = true
textcase textcase = upper!
end type

event modified;call super::modified;sle_item_barcode.setfocus( )
end event

type cbx_1 from so_checkbox within w_mat_receipt_barcode_divide_master
integer x = 4617
integer y = 52
integer width = 517
integer height = 68
integer taborder = 20
boolean bringtotop = true
boolean enabled = false
string text = "Use Tray Divide"
boolean checked = true
end type

event constructor;call super::constructor;if Gvs_USE_TRAY_DIVIDE_YN = 'Y' THEN 
  this.checked = true 
  rb_tray.ENabled = TRUE 
else
	this.checked = false
	rb_tray.ENabled = FALSE 
end if 
end event

type dw_6 from so_datawindow within w_mat_receipt_barcode_divide_master
integer x = 4507
integer y = 320
integer width = 645
integer height = 360
integer taborder = 30
boolean bringtotop = true
boolean titlebar = true
string title = "LG Label"
string dataobject = "d_mat_receipt_lot_barcode_rpt_type3"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
end type

type cbx_lg from so_checkbox within w_mat_receipt_barcode_divide_master
boolean visible = false
integer x = 4617
integer y = 128
integer width = 517
integer height = 68
boolean bringtotop = true
long textcolor = 0
string text = "LG Label"
end type

event constructor;call super::constructor;if Gvs_lot_divide_print_lg_label_yn = 'Y' then 
	this.checked = true 
else
	this.checked = false
end if 
end event

type cbx_msl from so_checkbox within w_mat_receipt_barcode_divide_master
integer x = 4037
integer y = 204
integer width = 549
integer height = 76
boolean bringtotop = true
integer textsize = -10
string text = "Msl Label Print"
end type

type gb_1 from so_groupbox within w_mat_receipt_barcode_divide_master
integer width = 640
integer height = 300
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_3 from so_groupbox within w_mat_receipt_barcode_divide_master
integer x = 649
integer y = 308
integer width = 2894
integer height = 372
integer weight = 700
long textcolor = 16711680
string text = "Barcode Scan"
end type

type gb_4 from so_groupbox within w_mat_receipt_barcode_divide_master
integer x = 649
integer width = 2889
integer height = 300
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_5 from so_groupbox within w_mat_receipt_barcode_divide_master
integer x = 3557
integer y = 304
integer width = 933
integer height = 372
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_mat_receipt_barcode_divide_master
integer x = 3547
integer width = 1595
integer height = 300
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_6 from so_groupbox within w_mat_receipt_barcode_divide_master
integer y = 304
integer width = 640
integer height = 372
integer taborder = 40
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type dw_7 from so_datawindow within w_mat_receipt_barcode_divide_master
integer x = 14
integer y = 884
integer width = 645
integer height = 360
integer taborder = 40
boolean titlebar = true
string title = "Msl Label"
string dataobject = "d_mat_receipt_lot_barcode_msl_rpt"
end type

