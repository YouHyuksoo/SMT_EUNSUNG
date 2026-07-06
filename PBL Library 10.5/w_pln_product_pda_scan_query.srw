HA$PBExportHeader$w_pln_product_pda_scan_query.srw
$PBExportComments$Line Master
forward
global type w_pln_product_pda_scan_query from w_main_root
end type
type ddlb_line_code from uo_line_code within w_pln_product_pda_scan_query
end type
type st_3 from statictext within w_pln_product_pda_scan_query
end type
type st_6 from so_statictext within w_pln_product_pda_scan_query
end type
type st_5 from so_statictext within w_pln_product_pda_scan_query
end type
type uo_item from uo_item_code within w_pln_product_pda_scan_query
end type
type ddlb_check_status from uo_basecode within w_pln_product_pda_scan_query
end type
type st_4 from so_statictext within w_pln_product_pda_scan_query
end type
type st_1 from statictext within w_pln_product_pda_scan_query
end type
type ddlb_check_type from uo_basecode within w_pln_product_pda_scan_query
end type
type st_2 from so_statictext within w_pln_product_pda_scan_query
end type
type sle_lot_no from so_singlelineedit within w_pln_product_pda_scan_query
end type
type st_7 from so_statictext within w_pln_product_pda_scan_query
end type
type rb_detail from so_radiobutton within w_pln_product_pda_scan_query
end type
type rb_summary from so_radiobutton within w_pln_product_pda_scan_query
end type
type em_1 from so_editmask within w_pln_product_pda_scan_query
end type
type em_2 from so_editmask within w_pln_product_pda_scan_query
end type
type sle_scan_supplier_partname from so_singlelineedit within w_pln_product_pda_scan_query
end type
type st_8 from so_statictext within w_pln_product_pda_scan_query
end type
type rb_check_list from so_radiobutton within w_pln_product_pda_scan_query
end type
type ddlb_ng_type from uo_basecode within w_pln_product_pda_scan_query
end type
type st_9 from so_statictext within w_pln_product_pda_scan_query
end type
type ddlb_feeder_layout_name from uo_smt_layout_model_name_ddlb within w_pln_product_pda_scan_query
end type
type ddlb_smt_model_name from uo_smt_model_name_ddlb within w_pln_product_pda_scan_query
end type
type st_10 from statictext within w_pln_product_pda_scan_query
end type
type sle_location_code from so_singlelineedit within w_pln_product_pda_scan_query
end type
type st_11 from so_statictext within w_pln_product_pda_scan_query
end type
type gb_1 from so_groupbox within w_pln_product_pda_scan_query
end type
type gb_2 from so_groupbox within w_pln_product_pda_scan_query
end type
end forward

global type w_pln_product_pda_scan_query from w_main_root
integer width = 4896
integer height = 2748
string title = "PDA Scan List Query"
ddlb_line_code ddlb_line_code
st_3 st_3
st_6 st_6
st_5 st_5
uo_item uo_item
ddlb_check_status ddlb_check_status
st_4 st_4
st_1 st_1
ddlb_check_type ddlb_check_type
st_2 st_2
sle_lot_no sle_lot_no
st_7 st_7
rb_detail rb_detail
rb_summary rb_summary
em_1 em_1
em_2 em_2
sle_scan_supplier_partname sle_scan_supplier_partname
st_8 st_8
rb_check_list rb_check_list
ddlb_ng_type ddlb_ng_type
st_9 st_9
ddlb_feeder_layout_name ddlb_feeder_layout_name
ddlb_smt_model_name ddlb_smt_model_name
st_10 st_10
sle_location_code sle_location_code
st_11 st_11
gb_1 gb_1
gb_2 gb_2
end type
global w_pln_product_pda_scan_query w_pln_product_pda_scan_query

type variables
Long Lvl_row 
String lvs_current_array_type , lvs_last_run_no
String lvs_user_line_code  , lvs_user_machine_code
end variables

on w_pln_product_pda_scan_query.create
int iCurrent
call super::create
this.ddlb_line_code=create ddlb_line_code
this.st_3=create st_3
this.st_6=create st_6
this.st_5=create st_5
this.uo_item=create uo_item
this.ddlb_check_status=create ddlb_check_status
this.st_4=create st_4
this.st_1=create st_1
this.ddlb_check_type=create ddlb_check_type
this.st_2=create st_2
this.sle_lot_no=create sle_lot_no
this.st_7=create st_7
this.rb_detail=create rb_detail
this.rb_summary=create rb_summary
this.em_1=create em_1
this.em_2=create em_2
this.sle_scan_supplier_partname=create sle_scan_supplier_partname
this.st_8=create st_8
this.rb_check_list=create rb_check_list
this.ddlb_ng_type=create ddlb_ng_type
this.st_9=create st_9
this.ddlb_feeder_layout_name=create ddlb_feeder_layout_name
this.ddlb_smt_model_name=create ddlb_smt_model_name
this.st_10=create st_10
this.sle_location_code=create sle_location_code
this.st_11=create st_11
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_line_code
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_6
this.Control[iCurrent+4]=this.st_5
this.Control[iCurrent+5]=this.uo_item
this.Control[iCurrent+6]=this.ddlb_check_status
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.ddlb_check_type
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.sle_lot_no
this.Control[iCurrent+12]=this.st_7
this.Control[iCurrent+13]=this.rb_detail
this.Control[iCurrent+14]=this.rb_summary
this.Control[iCurrent+15]=this.em_1
this.Control[iCurrent+16]=this.em_2
this.Control[iCurrent+17]=this.sle_scan_supplier_partname
this.Control[iCurrent+18]=this.st_8
this.Control[iCurrent+19]=this.rb_check_list
this.Control[iCurrent+20]=this.ddlb_ng_type
this.Control[iCurrent+21]=this.st_9
this.Control[iCurrent+22]=this.ddlb_feeder_layout_name
this.Control[iCurrent+23]=this.ddlb_smt_model_name
this.Control[iCurrent+24]=this.st_10
this.Control[iCurrent+25]=this.sle_location_code
this.Control[iCurrent+26]=this.st_11
this.Control[iCurrent+27]=this.gb_1
this.Control[iCurrent+28]=this.gb_2
end on

on w_pln_product_pda_scan_query.destroy
call super::destroy
destroy(this.ddlb_line_code)
destroy(this.st_3)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.uo_item)
destroy(this.ddlb_check_status)
destroy(this.st_4)
destroy(this.st_1)
destroy(this.ddlb_check_type)
destroy(this.st_2)
destroy(this.sle_lot_no)
destroy(this.st_7)
destroy(this.rb_detail)
destroy(this.rb_summary)
destroy(this.em_1)
destroy(this.em_2)
destroy(this.sle_scan_supplier_partname)
destroy(this.st_8)
destroy(this.rb_check_list)
destroy(this.ddlb_ng_type)
destroy(this.st_9)
destroy(this.ddlb_feeder_layout_name)
destroy(this.ddlb_smt_model_name)
destroy(this.st_10)
destroy(this.sle_location_code)
destroy(this.st_11)
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
Ivs_resize_type                      = 'MASTER_DETAIL_1L2R4B'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

/****************************************
*  Menu Property
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
ivs_modify_security = 'N'

end event

event ue_data_control;call super::ue_data_control;datetime lvdt_1 , lvdt_2
long ROW
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		
			if rb_detail.checked = true then 
			
				DW_1.RETRIEVE( em_1.text , em_2.text ,  DDLB_LINE_CODE.GETCODE()+'%' , ddlb_feeder_layout_name.getcode() ,  ddlb_smt_model_name.getcode()+'%' ,  sle_location_code.text+'%'  , uo_item.text()+'%' , ddlb_check_status.getcode()+'%'  ,  ddlb_check_type.getcode()+'%' , '%'+sle_lot_no.text+'%' , sle_scan_supplier_partname.text+'%' ,  GVI_ORGANIZATION_ID )
			 
			elseIF RB_SUMMARY.CHECKED = TRUE THEN 

				dw_3.setredraw(false)
				dw_3.retrieve( em_1.text , em_2.text ,  DDLB_LINE_CODE.GETCODE()+'%' , ddlb_feeder_layout_name.getcode() , uo_item.text()+'%' , '%'+sle_lot_no.text+'%' , ddlb_check_type.getcode()+'%' ,  ddlb_check_status.getcode()+'%'  ,  GVI_ORGANIZATION_ID)
			    dw_3.setredraw(true)
				 
			ELSE
				DW_5.RETRIEVE( em_1.text , em_2.text ,  DDLB_LINE_CODE.GETCODE()+'%' , ddlb_feeder_layout_name.getcode() , ddlb_smt_model_name.getcode()+'%' ,  sle_location_code.text+'%' ,  uo_item.text()+'%' , ddlb_check_status.getcode()+'%'  ,  ddlb_check_type.getcode()+'%' , '%'+sle_lot_no.text+'%' , sle_scan_supplier_partname.text+'%' ,  ddlb_ng_type.text( )+'%' ,   GVI_ORGANIZATION_ID )
		    end if 

			 
	CASE 'DELETE' 
		
		
		if rb_check_list.checked = true then 
			
		
			if DW_5.AcceptText() = -1 then
				return
			end if
			
			IF GVI_USER_LEVEL < 8 THEN 
				F_MSGBOX(9090)
				RETURN 
			END IF 
			
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			IF MSG = 1 THEN
				Gvl_row_deleted = DW_5.GetRow()			
				DW_5.DELETEROW(Gvl_row_deleted)		
				DW_5.SetFocus()
				ROW = DW_5.GetRow()
				DW_5.ScrollToRow(row)
				DW_5.SetColumn(1)
			END IF
			
		else
			if DW_1.AcceptText() = -1 then
				return
			end if
			
			IF GVI_USER_LEVEL < 8 THEN 
				F_MSGBOX(9090)
				RETURN 
			END IF 
			
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			IF MSG = 1 THEN
				Gvl_row_deleted = DW_1.GetRow()			
				DW_1.DELETEROW(Gvl_row_deleted)		
				DW_1.SetFocus()
				ROW = DW_1.GetRow()
				DW_1.ScrollToRow(row)
				DW_1.SetColumn(1)
			END IF			
			
		end if 
		
	CASE 'UPDATE'			 
			 
			 if dw_1.update() < 0 or  dw_5.update() < 0 then 
				rollback ;
			else
				commit ;
				f_msgbox(170)
			end if 
				
				
			 
CASE ELSE
END CHOOSE
end event

type dw_5 from w_main_root`dw_5 within w_pln_product_pda_scan_query
integer y = 528
integer width = 2295
integer height = 1648
integer taborder = 0
boolean titlebar = true
string dataobject = "d_smt_checklist_lst"
end type

event dw_5::doubleclicked;call super::doubleclicked;if row < 1 then return 
dw_2.retrieve( this.object.scan_partname[row])
dw_4.retrieve( this.object.partname[row]   ,this.object.lot_no[row]  , gvi_organization_id )
end event

type dw_4 from w_main_root`dw_4 within w_pln_product_pda_scan_query
integer x = 2295
integer y = 1456
integer width = 2551
integer height = 712
integer taborder = 0
boolean titlebar = true
string dataobject = "d_mat_issue_4_pda_scan_lst"
end type

type dw_3 from w_main_root`dw_3 within w_pln_product_pda_scan_query
integer y = 528
integer width = 2295
integer height = 1648
integer taborder = 0
boolean titlebar = true
string title = "Summary"
string dataobject = "d_smt_checklist_group_lst"
end type

type dw_2 from w_main_root`dw_2 within w_pln_product_pda_scan_query
integer x = 2299
integer y = 532
integer width = 2578
integer height = 920
integer taborder = 0
boolean titlebar = true
string dataobject = "d_smt_checkhist_4_issue_rpt"
end type

type dw_1 from w_main_root`dw_1 within w_pln_product_pda_scan_query
integer y = 528
integer width = 2290
integer height = 1648
integer taborder = 0
boolean titlebar = true
string title = "PDA Scan List"
string dataobject = "d_smt_plandata_checklist"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
dw_2.retrieve( dw_1.object.scan_partname[currentrow])
dw_4.retrieve( dw_1.object.partname[currentrow]   ,dw_1.object.lot_no[currentrow]  , gvi_organization_id )
end event

type uo_tabpages from w_main_root`uo_tabpages within w_pln_product_pda_scan_query
integer taborder = 0
end type

type ddlb_line_code from uo_line_code within w_pln_product_pda_scan_query
integer x = 2281
integer y = 168
integer width = 379
integer height = 1628
boolean bringtotop = true
long backcolor = 16777215
end type

type st_3 from statictext within w_pln_product_pda_scan_query
integer x = 2286
integer y = 84
integer width = 370
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Line Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_6 from so_statictext within w_pln_product_pda_scan_query
integer x = 699
integer y = 92
integer width = 1573
integer height = 68
boolean bringtotop = true
string text = "Scan Date"
end type

type st_5 from so_statictext within w_pln_product_pda_scan_query
integer x = 699
integer y = 292
integer width = 526
integer height = 68
boolean bringtotop = true
boolean enabled = false
string text = "Item Code"
end type

type uo_item from uo_item_code within w_pln_product_pda_scan_query
integer x = 699
integer y = 376
integer width = 526
integer height = 1628
integer taborder = 40
boolean bringtotop = true
end type

type ddlb_check_status from uo_basecode within w_pln_product_pda_scan_query
integer x = 1230
integer y = 376
integer width = 480
integer height = 1628
integer taborder = 40
boolean bringtotop = true
boolean allowedit = true
boolean autohscroll = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;THIS.REdraw( 'CHECK STATUS')
end event

type st_4 from so_statictext within w_pln_product_pda_scan_query
integer x = 1230
integer y = 292
integer width = 480
integer height = 68
boolean bringtotop = true
string text = "Check Status"
end type

type st_1 from statictext within w_pln_product_pda_scan_query
integer x = 2665
integer y = 80
integer width = 818
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Feeder Layout Name"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_check_type from uo_basecode within w_pln_product_pda_scan_query
integer x = 1719
integer y = 376
integer width = 603
integer height = 1628
integer taborder = 80
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw('CHECK TYPE')
end event

type st_2 from so_statictext within w_pln_product_pda_scan_query
integer x = 1719
integer y = 292
integer width = 603
integer height = 68
boolean bringtotop = true
string text = "Check Type"
end type

type sle_lot_no from so_singlelineedit within w_pln_product_pda_scan_query
integer x = 2935
integer y = 376
integer width = 768
integer taborder = 90
boolean bringtotop = true
end type

type st_7 from so_statictext within w_pln_product_pda_scan_query
integer x = 2935
integer y = 292
integer width = 768
integer height = 68
boolean bringtotop = true
string text = "Our Barcode"
end type

type rb_detail from so_radiobutton within w_pln_product_pda_scan_query
integer x = 46
integer y = 84
integer width = 549
boolean bringtotop = true
string text = "Detail By Feeder List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
selected_data_window = dw_1
dw_2.bringtotop = true
dw_4.bringtotop = true
end event

type rb_summary from so_radiobutton within w_pln_product_pda_scan_query
integer x = 46
integer y = 220
integer width = 549
boolean bringtotop = true
string text = "Summary"
end type

event clicked;call super::clicked;dw_3.bringtotop = true
selected_data_window =dw_3
end event

type em_1 from so_editmask within w_pln_product_pda_scan_query
integer x = 690
integer y = 168
integer width = 791
integer taborder = 20
boolean bringtotop = true
string text = ""
alignment alignment = left!
maskdatatype maskdatatype = datetimemask!
string mask = "yyyy/mm/dd hh:mm:ss"
boolean dropdowncalendar = true
end type

event constructor;call super::constructor;this.text =string( f_sysdate())
end event

type em_2 from so_editmask within w_pln_product_pda_scan_query
integer x = 1486
integer y = 168
integer width = 791
integer taborder = 30
boolean bringtotop = true
string text = ""
alignment alignment = left!
maskdatatype maskdatatype = datetimemask!
string mask = "yyyy/mm/dd hh:mm:ss"
boolean dropdowncalendar = true
end type

event constructor;call super::constructor;this.text =string( f_sysdate())
end event

type sle_scan_supplier_partname from so_singlelineedit within w_pln_product_pda_scan_query
integer x = 3712
integer y = 376
integer width = 800
integer taborder = 90
boolean bringtotop = true
end type

type st_8 from so_statictext within w_pln_product_pda_scan_query
integer x = 3712
integer y = 292
integer width = 800
integer height = 68
boolean bringtotop = true
string text = "Supplier Barcode"
end type

type rb_check_list from so_radiobutton within w_pln_product_pda_scan_query
integer x = 46
integer y = 364
integer width = 549
boolean bringtotop = true
string text = "Check List"
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
dw_4.bringtotop = true 
dw_5.bringtotop = true
selected_data_window =dw_5
end event

type ddlb_ng_type from uo_basecode within w_pln_product_pda_scan_query
integer x = 2327
integer y = 376
integer width = 603
integer height = 1628
integer taborder = 50
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw('NG TYPE')
end event

type st_9 from so_statictext within w_pln_product_pda_scan_query
integer x = 2327
integer y = 292
integer width = 603
integer height = 68
boolean bringtotop = true
string text = "NG Type"
end type

type ddlb_feeder_layout_name from uo_smt_layout_model_name_ddlb within w_pln_product_pda_scan_query
integer x = 2665
integer y = 164
integer taborder = 40
boolean bringtotop = true
end type

type ddlb_smt_model_name from uo_smt_model_name_ddlb within w_pln_product_pda_scan_query
integer x = 3493
integer y = 164
integer taborder = 40
boolean bringtotop = true
end type

type st_10 from statictext within w_pln_product_pda_scan_query
integer x = 3543
integer y = 84
integer width = 818
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "SMT Model Name"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_location_code from so_singlelineedit within w_pln_product_pda_scan_query
integer x = 4306
integer y = 164
integer width = 421
integer taborder = 100
boolean bringtotop = true
textcase textcase = upper!
end type

type st_11 from so_statictext within w_pln_product_pda_scan_query
integer x = 4311
integer y = 84
integer width = 411
integer height = 68
boolean bringtotop = true
string text = "Location Code"
end type

type gb_1 from so_groupbox within w_pln_product_pda_scan_query
integer x = 654
integer width = 4192
integer height = 508
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_pln_product_pda_scan_query
integer width = 645
integer height = 508
integer taborder = 10
string text = "Category"
end type

