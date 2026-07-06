HA$PBExportHeader$w_mat_other_mass_issue_barcode_return_master.srw
$PBExportComments$Material Mass Issue Return Master
forward
global type w_mat_other_mass_issue_barcode_return_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mat_other_mass_issue_barcode_return_master
end type
type uo_dateend from uo_ymd_calendar within w_mat_other_mass_issue_barcode_return_master
end type
type ddlb_item_code from uo_item_code within w_mat_other_mass_issue_barcode_return_master
end type
type st_3 from so_statictext within w_mat_other_mass_issue_barcode_return_master
end type
type st_4 from so_statictext within w_mat_other_mass_issue_barcode_return_master
end type
type st_status from so_statictext within w_mat_other_mass_issue_barcode_return_master
end type
type sle_our_barcode from so_singlelineedit within w_mat_other_mass_issue_barcode_return_master
end type
type sle_invoice_no from so_singlelineedit within w_mat_other_mass_issue_barcode_return_master
end type
type sle_material_mfs from so_singlelineedit within w_mat_other_mass_issue_barcode_return_master
end type
type st_5 from so_statictext within w_mat_other_mass_issue_barcode_return_master
end type
type st_6 from so_statictext within w_mat_other_mass_issue_barcode_return_master
end type
type st_7 from so_statictext within w_mat_other_mass_issue_barcode_return_master
end type
type cbx_auto_print from so_checkbox within w_mat_other_mass_issue_barcode_return_master
end type
type st_1 from so_statictext within w_mat_other_mass_issue_barcode_return_master
end type
type sle_qty from so_singlelineedit within w_mat_other_mass_issue_barcode_return_master
end type
type st_8 from so_statictext within w_mat_other_mass_issue_barcode_return_master
end type
type rb_mass_return from so_radiobutton within w_mat_other_mass_issue_barcode_return_master
end type
type sle_line_code from so_singlelineedit within w_mat_other_mass_issue_barcode_return_master
end type
type ddlb_line_code from uo_line_code within w_mat_other_mass_issue_barcode_return_master
end type
type sle_return_invoice_no from so_singlelineedit within w_mat_other_mass_issue_barcode_return_master
end type
type st_9 from so_statictext within w_mat_other_mass_issue_barcode_return_master
end type
type cbx_bad_yn from so_checkbox within w_mat_other_mass_issue_barcode_return_master
end type
type rb_bulk from so_radiobutton within w_mat_other_mass_issue_barcode_return_master
end type
type rb_mass_reball_wait_return from so_radiobutton within w_mat_other_mass_issue_barcode_return_master
end type
type ddlb_line_code_cond from uo_line_code within w_mat_other_mass_issue_barcode_return_master
end type
type st_2 from so_statictext within w_mat_other_mass_issue_barcode_return_master
end type
type dw_6 from so_datawindow within w_mat_other_mass_issue_barcode_return_master
end type
type pb_paste from so_commandbutton within w_mat_other_mass_issue_barcode_return_master
end type
type pb_return from so_commandbutton within w_mat_other_mass_issue_barcode_return_master
end type
type rb_romcopy from so_radiobutton within w_mat_other_mass_issue_barcode_return_master
end type
type cbx_line_manual_check from so_checkbox within w_mat_other_mass_issue_barcode_return_master
end type
type ddlb_issue_type from uo_basecode within w_mat_other_mass_issue_barcode_return_master
end type
type st_10 from so_statictext within w_mat_other_mass_issue_barcode_return_master
end type
type pb_cancel from so_commandbutton within w_mat_other_mass_issue_barcode_return_master
end type
type cbx_label_size from so_checkbox within w_mat_other_mass_issue_barcode_return_master
end type
type cbx_check_price from so_checkbox within w_mat_other_mass_issue_barcode_return_master
end type
type em_check_price from so_editmask within w_mat_other_mass_issue_barcode_return_master
end type
type cbx_msl from so_checkbox within w_mat_other_mass_issue_barcode_return_master
end type
type rb_outreturn from so_radiobutton within w_mat_other_mass_issue_barcode_return_master
end type
type sle_scan_qty from so_singlelineedit within w_mat_other_mass_issue_barcode_return_master
end type
type st_11 from so_statictext within w_mat_other_mass_issue_barcode_return_master
end type
type gb_2 from so_groupbox within w_mat_other_mass_issue_barcode_return_master
end type
type gb_4 from so_groupbox within w_mat_other_mass_issue_barcode_return_master
end type
type gb_1 from so_groupbox within w_mat_other_mass_issue_barcode_return_master
end type
type gb_3 from so_groupbox within w_mat_other_mass_issue_barcode_return_master
end type
type gb_5 from so_groupbox within w_mat_other_mass_issue_barcode_return_master
end type
end forward

global type w_mat_other_mass_issue_barcode_return_master from w_main_root
integer width = 5650
integer height = 3228
string title = "Material Issue Barcode Return (Mass/Bulk) Master"
long backcolor = 12639424
uo_dateset uo_dateset
uo_dateend uo_dateend
ddlb_item_code ddlb_item_code
st_3 st_3
st_4 st_4
st_status st_status
sle_our_barcode sle_our_barcode
sle_invoice_no sle_invoice_no
sle_material_mfs sle_material_mfs
st_5 st_5
st_6 st_6
st_7 st_7
cbx_auto_print cbx_auto_print
st_1 st_1
sle_qty sle_qty
st_8 st_8
rb_mass_return rb_mass_return
sle_line_code sle_line_code
ddlb_line_code ddlb_line_code
sle_return_invoice_no sle_return_invoice_no
st_9 st_9
cbx_bad_yn cbx_bad_yn
rb_bulk rb_bulk
rb_mass_reball_wait_return rb_mass_reball_wait_return
ddlb_line_code_cond ddlb_line_code_cond
st_2 st_2
dw_6 dw_6
pb_paste pb_paste
pb_return pb_return
rb_romcopy rb_romcopy
cbx_line_manual_check cbx_line_manual_check
ddlb_issue_type ddlb_issue_type
st_10 st_10
pb_cancel pb_cancel
cbx_label_size cbx_label_size
cbx_check_price cbx_check_price
em_check_price em_check_price
cbx_msl cbx_msl
rb_outreturn rb_outreturn
sle_scan_qty sle_scan_qty
st_11 st_11
gb_2 gb_2
gb_4 gb_4
gb_1 gb_1
gb_3 gb_3
gb_5 gb_5
end type
global w_mat_other_mass_issue_barcode_return_master w_mat_other_mass_issue_barcode_return_master

type variables
string LVS_ISSUE_COMPARE_YN ,LVS_ISSUE_RETURN_YN 
string LVS_WORKSTAGE_CODE , lvs_supplier_code ,  lvs_item_barcode ,  lvs_our_barcode , lvs_lot_no , lvs_item_code   , LVS_LOCATION_CODE , lvs_line_type , lvs_line_code , lvs_label_type , lvs_slip_no
long lvl_issue_qty  , lvl_row , lvi_count , lvi_pos1 , lvi_pos2 , lvl_new_scan_qty
double lvdb_receipt_lot_no

string lvs_error_check  , LVS_MODEL_NAME
STRING  LVS_FEEDER_SHAFT , LVS_ISSUE_DIVISION , LVS_FEEDER_LOCATION_CODE , lvs_inventory_type
end variables

forward prototypes
public subroutine wf_barcode_receipt_faild (string arg_msg)
public subroutine wf_reset_column ()
end prototypes

public subroutine wf_barcode_receipt_faild (string arg_msg);wf_reset_column()
st_status.text = F_GET_DUAL_LANG_TEXT( gvs_language , arg_msg) 

if arg_msg = "Print EXISTS" then 
		f_play_sound("Eixst.wav")
elseif arg_msg = "FORMAT UNMATCH" then 
		f_play_sound("scanfailed.wav")
else
	f_play_sound("INFAILED.WAV")
end if 
st_status.backColor = 255
end subroutine

public subroutine wf_reset_column ();

end subroutine

on w_mat_other_mass_issue_barcode_return_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.ddlb_item_code=create ddlb_item_code
this.st_3=create st_3
this.st_4=create st_4
this.st_status=create st_status
this.sle_our_barcode=create sle_our_barcode
this.sle_invoice_no=create sle_invoice_no
this.sle_material_mfs=create sle_material_mfs
this.st_5=create st_5
this.st_6=create st_6
this.st_7=create st_7
this.cbx_auto_print=create cbx_auto_print
this.st_1=create st_1
this.sle_qty=create sle_qty
this.st_8=create st_8
this.rb_mass_return=create rb_mass_return
this.sle_line_code=create sle_line_code
this.ddlb_line_code=create ddlb_line_code
this.sle_return_invoice_no=create sle_return_invoice_no
this.st_9=create st_9
this.cbx_bad_yn=create cbx_bad_yn
this.rb_bulk=create rb_bulk
this.rb_mass_reball_wait_return=create rb_mass_reball_wait_return
this.ddlb_line_code_cond=create ddlb_line_code_cond
this.st_2=create st_2
this.dw_6=create dw_6
this.pb_paste=create pb_paste
this.pb_return=create pb_return
this.rb_romcopy=create rb_romcopy
this.cbx_line_manual_check=create cbx_line_manual_check
this.ddlb_issue_type=create ddlb_issue_type
this.st_10=create st_10
this.pb_cancel=create pb_cancel
this.cbx_label_size=create cbx_label_size
this.cbx_check_price=create cbx_check_price
this.em_check_price=create em_check_price
this.cbx_msl=create cbx_msl
this.rb_outreturn=create rb_outreturn
this.sle_scan_qty=create sle_scan_qty
this.st_11=create st_11
this.gb_2=create gb_2
this.gb_4=create gb_4
this.gb_1=create gb_1
this.gb_3=create gb_3
this.gb_5=create gb_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.ddlb_item_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.st_status
this.Control[iCurrent+7]=this.sle_our_barcode
this.Control[iCurrent+8]=this.sle_invoice_no
this.Control[iCurrent+9]=this.sle_material_mfs
this.Control[iCurrent+10]=this.st_5
this.Control[iCurrent+11]=this.st_6
this.Control[iCurrent+12]=this.st_7
this.Control[iCurrent+13]=this.cbx_auto_print
this.Control[iCurrent+14]=this.st_1
this.Control[iCurrent+15]=this.sle_qty
this.Control[iCurrent+16]=this.st_8
this.Control[iCurrent+17]=this.rb_mass_return
this.Control[iCurrent+18]=this.sle_line_code
this.Control[iCurrent+19]=this.ddlb_line_code
this.Control[iCurrent+20]=this.sle_return_invoice_no
this.Control[iCurrent+21]=this.st_9
this.Control[iCurrent+22]=this.cbx_bad_yn
this.Control[iCurrent+23]=this.rb_bulk
this.Control[iCurrent+24]=this.rb_mass_reball_wait_return
this.Control[iCurrent+25]=this.ddlb_line_code_cond
this.Control[iCurrent+26]=this.st_2
this.Control[iCurrent+27]=this.dw_6
this.Control[iCurrent+28]=this.pb_paste
this.Control[iCurrent+29]=this.pb_return
this.Control[iCurrent+30]=this.rb_romcopy
this.Control[iCurrent+31]=this.cbx_line_manual_check
this.Control[iCurrent+32]=this.ddlb_issue_type
this.Control[iCurrent+33]=this.st_10
this.Control[iCurrent+34]=this.pb_cancel
this.Control[iCurrent+35]=this.cbx_label_size
this.Control[iCurrent+36]=this.cbx_check_price
this.Control[iCurrent+37]=this.em_check_price
this.Control[iCurrent+38]=this.cbx_msl
this.Control[iCurrent+39]=this.rb_outreturn
this.Control[iCurrent+40]=this.sle_scan_qty
this.Control[iCurrent+41]=this.st_11
this.Control[iCurrent+42]=this.gb_2
this.Control[iCurrent+43]=this.gb_4
this.Control[iCurrent+44]=this.gb_1
this.Control[iCurrent+45]=this.gb_3
this.Control[iCurrent+46]=this.gb_5
end on

on w_mat_other_mass_issue_barcode_return_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.ddlb_item_code)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_status)
destroy(this.sle_our_barcode)
destroy(this.sle_invoice_no)
destroy(this.sle_material_mfs)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.st_7)
destroy(this.cbx_auto_print)
destroy(this.st_1)
destroy(this.sle_qty)
destroy(this.st_8)
destroy(this.rb_mass_return)
destroy(this.sle_line_code)
destroy(this.ddlb_line_code)
destroy(this.sle_return_invoice_no)
destroy(this.st_9)
destroy(this.cbx_bad_yn)
destroy(this.rb_bulk)
destroy(this.rb_mass_reball_wait_return)
destroy(this.ddlb_line_code_cond)
destroy(this.st_2)
destroy(this.dw_6)
destroy(this.pb_paste)
destroy(this.pb_return)
destroy(this.rb_romcopy)
destroy(this.cbx_line_manual_check)
destroy(this.ddlb_issue_type)
destroy(this.st_10)
destroy(this.pb_cancel)
destroy(this.cbx_label_size)
destroy(this.cbx_check_price)
destroy(this.em_check_price)
destroy(this.cbx_msl)
destroy(this.rb_outreturn)
destroy(this.sle_scan_qty)
destroy(this.st_11)
destroy(this.gb_2)
destroy(this.gb_4)
destroy(this.gb_1)
destroy(this.gb_3)
destroy(this.gb_5)
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
Ivs_resize_type                      = 'MASTER_DETAIL_1L2R'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
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
st_status.width = dw_1.width + dw_2.width
sle_our_barcode.setfocus()
f_set_column_dddw( dw_3 )


//====================================
// $$HEX22$$acb9ecd3b8d2200000adacb9d0c52000f1b45db818b4b4c5200088c73cc774ba200014bcd4af00c9e4b22000$$ENDHEX$$
//====================================

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

//$$HEX10$$68d5b5c27cb7a8bc20001cbc89d52000ecc580bd$$ENDHEX$$($$HEX2$$20c731c1$$ENDHEX$$2$$HEX4$$f5aca5c7acc0a9c6$$ENDHEX$$)
if Gvs_msl_label_print = 'Y' then
   cbx_msl.checked = true
else	
   cbx_msl.checked = false
end if


//==================================
//
//==================================


//===================================
//
//===================================
dw_2.retrieve( '%' , '%' , '%' , gvi_organization_id)
dw_3.retrieve( '%', '%' , '%' , gvi_organization_id)
end event

event ue_data_control;call super::ue_data_control;
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
	
			dw_1.reset()
			dw_1.retrieve( uo_dateset.text() , uo_dateend.text(), ddlb_line_code_cond.getcode()+'%' ,   ddlb_item_code.text() + '%',   sle_invoice_no.text+'%' , sle_material_mfs.text+'%' , ddlb_issue_type.getcode()+'%' ,   gvi_organization_id)
			sle_our_barcode.setfocus()

	case else
end choose

end event

event open;call super::open;sle_our_barcode.setfocus()
end event

event clicked;call super::clicked;sle_our_barcode.setfocus()
end event

event resize;call super::resize;st_status.width = dw_1.width + dw_2.width
end event

type dw_5 from w_main_root`dw_5 within w_mat_other_mass_issue_barcode_return_master
integer y = 1064
integer width = 2373
integer height = 752
integer taborder = 0
string title = "Msl Label"
string dataobject = "d_mat_receipt_lot_barcode_msl_rpt"
boolean maxbox = false
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
end type

type dw_4 from w_main_root`dw_4 within w_mat_other_mass_issue_barcode_return_master
integer y = 1068
integer width = 2373
integer height = 752
integer taborder = 0
end type

type dw_3 from w_main_root`dw_3 within w_mat_other_mass_issue_barcode_return_master
integer y = 1068
integer width = 2373
integer height = 948
integer taborder = 0
boolean titlebar = true
string dataobject = "d_mat_receipt_lot_barcode_rpt"
end type

type dw_2 from w_main_root`dw_2 within w_mat_other_mass_issue_barcode_return_master
integer x = 3182
integer y = 1064
integer width = 2363
integer height = 964
integer taborder = 0
boolean titlebar = true
string title = "Receipt Barcode History"
string dataobject = "d_mat_rceipt_barcode_4_issue_return_lst"
borderstyle borderstyle = styleraised!
end type

event dw_2::buttonclicked;call super::buttonclicked;if dwo.name = 'b_print' then 
     dw_3.retrieve( this.object.item_code[row] , this.object.receipt_slip_no[row] , this.object.lot_no[row] , gvi_organization_id )
	  
	if dw_3.rowcount() > 0 then 	
		dw_3.print( )
	else
		f_msgbox(117)
	end if 

end if 
end event

type dw_1 from w_main_root`dw_1 within w_mat_other_mass_issue_barcode_return_master
integer y = 1064
integer width = 3168
integer height = 964
integer taborder = 0
boolean titlebar = true
string title = "Issue Return List"
string dataobject = "d_mat_issue_4_barcode_return_lst"
end type

event dw_1::clicked;call super::clicked;sle_our_barcode.setfocus()
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
dw_2.retrieve( this.object.item_code[currentrow] , this.object.material_mfs[currentrow] , this.object.invoice_no[currentrow] , gvi_organization_id ) 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_other_mass_issue_barcode_return_master
integer taborder = 0
end type

type uo_dateset from uo_ymd_calendar within w_mat_other_mass_issue_barcode_return_master
event destroy ( )
integer x = 32
integer y = 424
boolean bringtotop = true
long backcolor = 12639424
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_other_mass_issue_barcode_return_master
event destroy ( )
integer x = 448
integer y = 424
boolean bringtotop = true
long backcolor = 12639424
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_item_code from uo_item_code within w_mat_other_mass_issue_barcode_return_master
integer x = 1317
integer y = 420
integer width = 530
integer height = 676
integer taborder = 0
boolean bringtotop = true
long backcolor = 16777215
end type

event selectionchanged;call super::selectionchanged;sle_our_barcode.setfocus()
end event

type st_3 from so_statictext within w_mat_other_mass_issue_barcode_return_master
integer x = 1317
integer y = 340
integer width = 530
integer height = 72
boolean bringtotop = true
long backcolor = 12639424
string text = "Item Code"
end type

type st_4 from so_statictext within w_mat_other_mass_issue_barcode_return_master
integer x = 37
integer y = 340
integer width = 814
integer height = 72
boolean bringtotop = true
long backcolor = 12639424
string text = "Issue Date"
end type

type st_status from so_statictext within w_mat_other_mass_issue_barcode_return_master
integer y = 4
integer width = 5536
integer height = 248
boolean bringtotop = true
integer textsize = -36
integer weight = 700
long textcolor = 0
long backcolor = 65535
string text = "Message"
end type

type sle_our_barcode from so_singlelineedit within w_mat_other_mass_issue_barcode_return_master
integer x = 1824
integer y = 812
integer width = 1371
integer height = 88
integer taborder = 10
boolean bringtotop = true
long backcolor = 16777215
textcase textcase = upper!
end type

event getfocus;call super::getfocus;this.selecttext(1,100)
st_status.text = f_msg_st1(126 ,f_get_dual_lang_text( gvs_language , "ITEM CODE") ) 
end event

event modified;call super::modified;LVS_ERROR_CHECK = ''
LVS_OUR_BARCODE = THIS.TEXT
//SLE_LINE_CODE.TEXT  = ''
LVS_LINE_CODE = ''
LVS_LOT_NO = '' 
LVS_SLIP_NO = ''
LVS_ISSUE_COMPARE_YN = ''
LVS_ISSUE_RETURN_YN = ''
LVS_LABEL_TYPE = ''


//=======================================
// $$HEX11$$00cf3cd554cf200090c7acc778c72000bdacb0c62000$$ENDHEX$$
//=======================================
// IF MID (UPPER (lvs_our_barcode), 1, 1) = '['    THEN
//         SELECT  f_get_item_code_from_barcode (:lvs_our_barcode)|| '-' || f_get_lot_no_from_barcode (:lvs_our_barcode) || '-' || f_get_lot_qty_from_barcode (:lvs_our_barcode)
//		    INTO :lvs_our_barcode
//	       FROM DUAL ; 
//		
//		IF F_SQL_CHECK() < 0 THEN 
//			SLE_OUR_BARCODE.SETFOCUS( )
//			SLE_OUR_BARCODE.TEXT = ''
//				
//		END IF 	 
//else
      
    SELECT  f_get_prepare_barcode (:LVS_OUR_BARCODE)
           INTO :LVS_OUR_BARCODE
          FROM DUAL ; 
      
      IF F_SQL_CHECK() < 0 THEN 
            SLE_OUR_BARCODE.SETFOCUS( )
		   SLE_OUR_BARCODE.TEXT = ''
      END IF     
		
//END IF 

//================================================
//
//================================================
IF LEN(LVS_OUR_BARCODE) < 7  THEN 

            F_MSGBOX1(1175 ,LVS_OUR_BARCODE )
					SLE_OUR_BARCODE.SETFOCUS( )
					SLE_OUR_BARCODE.TEXT = ''
            LVS_ERROR_CHECK = 'ERROR'
            RETURN -1 
END IF 

LVDB_RECEIPT_LOT_NO = F_GET_SEQUENCE('SEQ_MATERIAL_BARCODE')

        //============================================
        //  $$HEX6$$88d4a9ba200054cfdcb42000$$ENDHEX$$7 $$HEX13$$88bc30ca200074c7c4d6200080bd30d120003ecc94b2e4b22000$$ENDHEX$$
	   // $$HEX4$$88d4a9bad0c52000$$ENDHEX$$- $$HEX15$$00ac2000ecd368d51cb4200090c7acc700ac200088c73cc7c0bb5cb82000$$ENDHEX$$
        //============================================
//        LVI_POS1 =  POS(LVS_OUR_BARCODE, '-' , 7 ) 
//
//        IF  LVI_POS1 <= 0 THEN 
//            LVS_ITEM_CODE = TRIM( MID( LVS_OUR_BARCODE , 1 , 100 ))
//        ELSE
//            //=================================================
//            //
//            //=================================================
//            LVS_ITEM_CODE = TRIM( MID( LVS_OUR_BARCODE , 1 ,  LVI_POS1 -1 ))        
//        END IF 


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

        IF F_CHECK_ITEM_EXISTS( LVS_ITEM_CODE , F_T_SYSDATE())  <= 0 THEN 
                F_PLAY_SOUND("$$HEX5$$88d4a9baf8bbf1b45db8$$ENDHEX$$.WAV")	  
                F_MSGBOX(9041) //$$HEX10$$fcd3a9bac8b9a4c230d12000f8bbf1b45db82000$$ENDHEX$$
                ST_STATUS.TEXT =F_MSG_ST(9041)
				SLE_OUR_BARCODE.SETFOCUS( )
				SLE_OUR_BARCODE.TEXT = ''
                LVS_ERROR_CHECK = 'ERROR'
                RETURN -1
        END IF 

        //==================================================
        // $$HEX6$$6fb8b8d2200088bc38d62000$$ENDHEX$$
        //==================================================
//        LVI_POS2 =  POS(LVS_OUR_BARCODE , '-' , LVI_POS1+1 ) 
//        
//        IF  LVI_POS1 > 0 AND LVI_POS2 <= 0 THEN 
//                LVS_LOT_NO = TRIM( MID( LVS_OUR_BARCODE , LVI_POS1+1 ,   100))
//        ELSEIF LVI_POS1 > 0 AND LVI_POS2 > 0 THEN 
//                LVS_LOT_NO = TRIM( MID( LVS_OUR_BARCODE , LVI_POS1+1 ,   LVI_POS2 - LVI_POS1 -1 ))
//        ELSE
//                 LVS_LOT_NO = STRING(F_T_SYSDATE(),'YYMMDD')+STRING(LVDB_RECEIPT_LOT_NO,'00000')
//        END IF 
//
//        IF LVS_LOT_NO = ''  THEN 
//            
//            ST_STATUS.TEXT = "$$HEX15$$6fb8b8d288bc38d600ac20002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$"
//			SLE_OUR_BARCODE.SETFOCUS( )
//			SLE_OUR_BARCODE.TEXT = ''
//            LVS_ERROR_CHECK = 'ERROR'
//            RETURN -1
//				
//        END IF     
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


//====================================================
// $$HEX11$$6fb8b8d200ac200088c73cc774ba200070c88cd62000$$ENDHEX$$
// 8 $$HEX6$$90c7acb9200074c7c1c02000$$ENDHEX$$
//====================================================

IF LVS_LOT_NO <>  '' THEN
        
				SELECT RECEIPT_SLIP_NO,
							  NVL(SUPPLIER_CODE ,'*') , 
							  NVL(ISSUE_COMPARE_YN , 'N')  ,
							  NVL(ISSUE_RETURN_YN , 'N') ,
							  NVL(WORKSTAGE_CODE , '*') ,
							  NVL(LABEL_TYPE,'N') ,
							  NVL(FEEDER_SHAFT,'*') ,
							  NVL(ISSUE_DIVISION,'*') ,
							  NVL(LOCATION_CODE,'*') ,
							  DECODE( NVL(NEW_SCAN_QTY,0)  , 0 , SCAN_QTY , NEW_SCAN_QTY ) SCAN_QTY
							  
					INTO :LVS_SLIP_NO , 
								:LVS_SUPPLIER_CODE , 
							  :LVS_ISSUE_COMPARE_YN ,
							  :LVS_ISSUE_RETURN_YN,
							  :LVS_WORKSTAGE_CODE,
							  :LVS_LABEL_TYPE ,
							  :LVS_FEEDER_SHAFT ,
							  :LVS_ISSUE_DIVISION ,
							  :LVS_FEEDER_LOCATION_CODE,
							  :LVL_NEW_SCAN_QTY
							  
							  
				 FROM IM_ITEM_RECEIPT_BARCODE
			    WHERE ITEM_CODE          = :LVS_ITEM_CODE
					 AND LOT_NO               = :LVS_LOT_NO
					 AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
			  
			  IF F_SQL_CHECK() < 0 THEN 
					ST_STATUS.TEXT = "$$HEX13$$14bc54cfdcb4200074c725b8200070c88cd611c9200024c658b9$$ENDHEX$$"
					SLE_OUR_BARCODE.SETFOCUS( )
					SLE_OUR_BARCODE.TEXT = ''
					LVS_ERROR_CHECK = 'ERROR'
					RETURN 
			  END IF 
			  
END IF 

//================================================
// $$HEX13$$74c760b8200014bc54cfdcb4200094c7c9b7200018c2c9b72000$$ENDHEX$$
//================================================
SLE_SCAN_QTY.TEXT = STRING(LVL_NEW_SCAN_QTY) 

//================================================
// $$HEX6$$04d6a5c7200018bc88d42000$$ENDHEX$$
//================================================

IF  RB_MASS_RETURN.CHECKED  = TRUE  AND  ( LVS_LABEL_TYPE   ='N'  OR LVS_LABEL_TYPE = '' OR ISNULL(LVS_LABEL_TYPE) ) THEN 

        //$$HEX5$$88bdc9b774c774ba2000$$ENDHEX$$
        IF CBX_BAD_YN.CHECKED = TRUE THEN 
            LVS_LOCATION_CODE = 'M02' //$$HEX7$$88bdc9b720003dcce0ac5cb82000$$ENDHEX$$
            LVS_LINE_CODE  = '28' //$$HEX5$$04d6a5c788bdc9b72000$$ENDHEX$$
        ELSE
            LVS_LOCATION_CODE = 'M01' //$$HEX12$$91c588d43dcce0ac5cb82000200009002000200020002000$$ENDHEX$$
            //$$HEX24$$18bca9b02000a1c794b220007cb778c740c72000e4c21cc820009ccde0ac18b4c8c558b320007cb778c7d0c51cc12000$$ENDHEX$$
        END IF 
        
        LVS_LABEL_TYPE = 'N'

ELSEIF  RB_MASS_RETURN.CHECKED  = TRUE  AND  LVS_LABEL_TYPE   ='R'  THEN 

        //$$HEX5$$88bdc9b774c774ba2000$$ENDHEX$$
        IF CBX_BAD_YN.CHECKED = TRUE THEN 
            LVS_LOCATION_CODE = 'M02' //$$HEX7$$88bdc9b720003dcce0ac5cb82000$$ENDHEX$$
            LVS_LINE_CODE  = '28' //$$HEX5$$04d6a5c788bdc9b72000$$ENDHEX$$
        ELSE
            LVS_LOCATION_CODE = 'M06' //$$HEX12$$91c588d43dcce0ac5cb82000200009002000200020002000$$ENDHEX$$
            //$$HEX24$$18bca9b02000a1c794b220007cb778c740c72000e4c21cc820009ccde0ac18b4c8c558b320007cb778c7d0c51cc12000$$ENDHEX$$
        END IF 
        
        LVS_LABEL_TYPE = 'R'


ELSEIF  RB_MASS_RETURN.CHECKED  = TRUE  AND  LVS_LABEL_TYPE   ='B'  THEN 

        //$$HEX5$$88bdc9b774c774ba2000$$ENDHEX$$
        IF CBX_BAD_YN.CHECKED = TRUE THEN 
            LVS_LOCATION_CODE = 'M02' //$$HEX7$$88bdc9b720003dcce0ac5cb82000$$ENDHEX$$
        ELSE
            LVS_LOCATION_CODE = 'M05'   //$$HEX17$$8cbc6cd091c588d4200020003dcce0ac5cb820002000200009002000200020002000$$ENDHEX$$
            //$$HEX24$$18bca9b02000a1c794b220007cb778c740c72000e4c21cc820009ccde0ac18b4c8c558b320007cb778c7d0c51cc12000$$ENDHEX$$
        END IF 
        
       LVS_LABEL_TYPE = 'B'    

//=================================================================================
//
//=================================================================================
ELSEIF  RB_BULK.CHECKED = TRUE  AND  ( LVS_LABEL_TYPE   ='B'  OR LVS_LABEL_TYPE = '' OR ISNULL(LVS_LABEL_TYPE) )  THEN 
    
        LVS_LOCATION_CODE = 'M05'   //$$HEX7$$8cbc6cd020003dcce0ac5cb82000$$ENDHEX$$
        LVS_LINE_CODE  = '25' //$$HEX8$$8cbc6cd07cb778c72000d0c51cc12000$$ENDHEX$$
        LVS_LABEL_TYPE = 'B'    
        
ELSEIF RB_ROMCOPY.CHECKED = TRUE THEN 
    
        IF CBX_BAD_YN.CHECKED = TRUE THEN 
            LVS_LOCATION_CODE = 'M02' //$$HEX7$$88bdc9b720003dcce0ac5cb82000$$ENDHEX$$
            LVS_LINE_CODE  = '22' //$$HEX6$$6cb874ce3cd5d0c51cc12000$$ENDHEX$$
            LVS_LABEL_TYPE = 'N'

        ELSE
            LVS_LOCATION_CODE = 'M01' //$$HEX7$$91c588d420003dcce0ac5cb82000$$ENDHEX$$
            LVS_LINE_CODE  = '22' //$$HEX7$$6cb874ce3cd52000d0c51cc12000$$ENDHEX$$
            LVS_LABEL_TYPE = 'N' 
        END IF 

//===============================================   
// $$HEX6$$acb9fcbc200000b330ae2000$$ENDHEX$$
//===============================================
ELSEIF  RB_MASS_REBALL_WAIT_RETURN.CHECKED = TRUE  THEN 
    
		LVS_LOCATION_CODE = 'M04'
		LVS_LABEL_TYPE = 'R'
		LVS_LINE_CODE  = '27' //$$HEX6$$04d6a5c7200091c588d42000$$ENDHEX$$
		
ELSEIF  rb_outreturn.CHECKED = TRUE  THEN 
    
		LVS_LOCATION_CODE = 'M01'
		LVS_LABEL_TYPE = 'N'
//================================================  
//
//================================================
ELSE
    
		MESSAGEBOX("$$HEX2$$55d678c7$$ENDHEX$$" , "$$HEX20$$20c1ddd0200020c715d674c7200098c7bbba200018b4c8c5b5c2c8b2e4b220007cb7a8bcc0d085c7$$ENDHEX$$="+LVS_LABEL_TYPE) 
		SLE_OUR_BARCODE.SETFOCUS( )
		SLE_OUR_BARCODE.TEXT = ''
		LVS_ERROR_CHECK = 'ERROR'
		RETURN 
    
END IF 

//================================================
//  $$HEX24$$04d6a5c7200018bc88d4200074c774ba1cc1200088bdc9b774c7200044c5c8b274ba20006fb8b8d22000b4cc6cd02000$$ENDHEX$$
//================================================
IF RB_MASS_RETURN.CHECKED  = TRUE AND CBX_BAD_YN.CHECKED  = FALSE THEN
    
        //$$HEX14$$acc2bdb9200074c725b874c7200088c794b2c0c92000b4cc6cd02000$$ENDHEX$$
		IF LVS_SLIP_NO = '' OR ISNULL(LVS_SLIP_NO) THEN
			SLE_OUR_BARCODE.SETFOCUS( )
			SLE_OUR_BARCODE.TEXT = ''
			LVS_ERROR_CHECK = 'ERROR'				
			ST_STATUS.TEXT = "$$HEX21$$14bc54cfdcb4200015c8f4bc00ac2000ddc031c1200018b4b4c5200088c7c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$"
		RETURN              
		END IF      
		  
        //$$HEX22$$9ccde0ac00ac200048c518b4c8c52000c0c9ccb9200015ac1cc8200018bc88d474c7200044c5f8bb50b12000$$ENDHEX$$
        IF  LVS_ISSUE_COMPARE_YN = 'N'  OR LVS_ISSUE_COMPARE_YN = '' THEN
            
			MESSAGEBOX("$$HEX2$$55d678c7$$ENDHEX$$" , "$$HEX30$$74c7f8bb200018bc88d41cb4200090c7acc7200074c770ac98b0200014bc54cfdcb42000ddc031c11cb4200074c725b874c72000c6c5b5c2c8b2e4b2$$ENDHEX$$")
			SLE_OUR_BARCODE.SETFOCUS( )
			SLE_OUR_BARCODE.TEXT = ''
			LVS_ERROR_CHECK = 'ERROR'		

            RETURN 

        END IF 
	
				  //=====================================================
				  //$$HEX19$$04d6a5c7200091c588d474c774ba20007cb778c744c7200070c88cd620005cd5e4b220002000$$ENDHEX$$
				  //=====================================================
				if cbx_line_manual_check.checked = true then 
					
					 LVS_LINE_CODE = SLE_LINE_CODE.TEXT
					 
				else
								 SELECT MAX(LINE_CODE) 
									  INTO :LVS_LINE_CODE
									  FROM IM_ITEM_ISSUE 
								  WHERE ITEM_CODE         = :LVS_ITEM_CODE 
										AND MATERIAL_MFS = :LVS_LOT_NO
										AND ISSUE_DEFICIT  = '3' 
										AND ISSUE_ACCOUNT <> 'M009'
										AND ENTER_DATE     = ( SELECT MAX(ENTER_DATE) 
										                                       FROM IM_ITEM_ISSUE 
																	     WHERE ITEM_CODE        = :LVS_ITEM_CODE
																		     AND MATERIAL_MFS = :LVS_LOT_NO
																		     AND ISSUE_DEFICIT  = '3'
																			 AND ISSUE_ACCOUNT <> 'M009'
																        ) ;
								 
									 IF F_SQL_CHECK() < 0 THEN 
										  SLE_OUR_BARCODE.SETFOCUS( )
										  SLE_OUR_BARCODE.TEXT = ''   
										  LVS_ERROR_CHECK = 'ERROR'
										  RETURN 
									 END IF 
								 
									//============================================
									//$$HEX11$$7cb778c744c720004cc518c22000c6c53cc774ba2000$$ENDHEX$$
									//============================================
									IF  LVS_LINE_CODE = '' OR LVS_LINE_CODE = '*' OR LVS_LINE_CODE = '%'  OR ISNULL(LVS_LINE_CODE) THEN 
										 
													ST_STATUS.TEXT =LVS_ITEM_CODE+"  "+LVS_LOT_NO+" $$HEX29$$5ccd85c820007cb778c7200054cfdcb47cb920004cc518c22000c6c5b5c2200018c2d9b398ccacb9200074d57cc5200069d5c8b2e4b220002000$$ENDHEX$$"
													SLE_OUR_BARCODE.SETFOCUS( )
													SLE_OUR_BARCODE.TEXT = ''
													LVS_ERROR_CHECK = 'ERROR'
													RETURN      
									ELSE
											 SLE_LINE_CODE.TEXT = LVS_LINE_CODE
									END IF 
							
						END IF 
						  
//=================================================================================
//
//=================================================================================
ELSEIF rb_outreturn.CHECKED  = TRUE  THEN
	LVS_LINE_CODE = SLE_LINE_CODE.TEXT
ELSE
    
//=================================================================================
//  $$HEX5$$04d6a5c788bdc9b72000$$ENDHEX$$/ $$HEX3$$8cbc6cd02000$$ENDHEX$$/ $$HEX9$$acb9fcbc00aca5b22000200018bc88d42000$$ENDHEX$$
//=================================================================================

        LVS_ITEM_BARCODE = SLE_OUR_BARCODE.TEXT 
        LVS_ITEM_CODE = MID( SLE_OUR_BARCODE.TEXT , 1, 11 )
        LVS_LINE_TYPE   = F_GET_LINE_TYPE_FROM_ITEM( LVS_ITEM_CODE )
        
        //==================================================
        //
        //==================================================

        IF F_CHECK_ITEM_EXISTS( LVS_ITEM_CODE , F_T_SYSDATE())  <= 0 THEN 
            F_PLAY_SOUND("$$HEX5$$88d4a9baf8bbf1b45db8$$ENDHEX$$.WAV")	  
            F_MSGBOX(9041) //$$HEX10$$fcd3a9bac8b9a4c230d12000f8bbf1b45db82000$$ENDHEX$$
			SLE_OUR_BARCODE.SETFOCUS( )
			SLE_OUR_BARCODE.TEXT = ''
            LVS_ERROR_CHECK = 'ERROR'
        END IF 

END IF 
//=============================================
if cbx_check_price.checked = true then    
      
       DECIMAL LVF_UNIT_PRICE
       
      SELECT F_GET_MAT_MAX_UNIT_PRICE_CFM( :lvs_item_code , :lvs_line_type , SYSDATE , :GVI_ORGANIZATION_ID )  
          INTO :LVF_UNIT_PRICE 
       FROM DUAL  ;

       IF F_SQL_CHECK() < 0 THEN 
            sle_our_barcode.text = ''
            sle_our_barcode.setfocus()
            return -1 
      END IF        
       
      if LVF_UNIT_PRICE> Dec(em_check_price.text) then 
         f_play_sound("scanfailed.wav")
         st_status.text = "$$HEX17$$e0ac00ac200090c7acc7200085c7c8b2e4b220009ccde0ac18bc88d4200088bd00ac$$ENDHEX$$"
         messagebox("Nofity" , "$$HEX6$$55d678c7200058d538c194c6$$ENDHEX$$")
         sle_our_barcode.text = ''
         sle_our_barcode.setfocus()
         return -1            
      end if 
      if LVF_UNIT_PRICE = 0 then 
         st_status.text = "$$HEX8$$e8b200ac20004cc518c22000c6c54cc7$$ENDHEX$$"
      end if 
end if 
SLE_QTY.SETFOCUS()
end event

type sle_invoice_no from so_singlelineedit within w_mat_other_mass_issue_barcode_return_master
integer x = 1856
integer y = 416
integer height = 88
boolean bringtotop = true
long backcolor = 16777215
end type

type sle_material_mfs from so_singlelineedit within w_mat_other_mass_issue_barcode_return_master
integer x = 2373
integer y = 416
integer height = 88
boolean bringtotop = true
long backcolor = 16777215
end type

type st_5 from so_statictext within w_mat_other_mass_issue_barcode_return_master
integer x = 1856
integer y = 340
integer height = 72
boolean bringtotop = true
long backcolor = 12639424
string text = "Invoice No"
end type

type st_6 from so_statictext within w_mat_other_mass_issue_barcode_return_master
integer x = 2373
integer y = 340
integer height = 72
boolean bringtotop = true
long backcolor = 12639424
string text = "Material MFS"
end type

type st_7 from so_statictext within w_mat_other_mass_issue_barcode_return_master
integer x = 1326
integer y = 740
integer width = 485
integer height = 76
boolean bringtotop = true
long textcolor = 16711680
long backcolor = 12639424
string text = "Line Code"
alignment alignment = right!
end type

type cbx_auto_print from so_checkbox within w_mat_other_mass_issue_barcode_return_master
integer x = 3497
integer y = 312
integer width = 475
integer height = 76
boolean bringtotop = true
long backcolor = 12639424
string text = "Auto Print"
boolean checked = true
end type

event clicked;call super::clicked;sle_our_barcode.setfocus()
end event

type st_1 from so_statictext within w_mat_other_mass_issue_barcode_return_master
integer x = 1326
integer y = 916
integer width = 485
integer height = 84
boolean bringtotop = true
long textcolor = 16711680
long backcolor = 12639424
string text = "Qty"
alignment alignment = right!
end type

type sle_qty from so_singlelineedit within w_mat_other_mass_issue_barcode_return_master
integer x = 1824
integer y = 904
integer width = 393
integer height = 88
integer taborder = 20
boolean bringtotop = true
long backcolor = 16777215
end type

event modified;call super::modified;String lvs_msl_level, lvs_vendor_code

//==================================================
//  $$HEX3$$18c2c9b72000$$ENDHEX$$
//==================================================
lvl_issue_qty = long(this.text)
lvl_new_scan_qty = long(sle_scan_qty.text) 

if lvl_issue_qty <=0 then 
		f_play_sound("scanfailed.wav")		
		st_status.text = "$$HEX15$$9ccde0ac18c2c9b774c720002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$"	
		sle_our_barcode.setfocus()
		sle_our_barcode.selecttext( 1,100)	
		sle_qty.text = ''
//		cbx_force_return.checked = false
		lvs_error_check = 'ERROR'
		return
end if 


IF lvs_line_code  = '' OR ISNULL( lvs_line_code) then 
	
		st_status.text = "$$HEX13$$7cb778c774c720002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$"	
		sle_our_barcode.setfocus()
		sle_our_barcode.selecttext( 1,100)	
		sle_qty.text = ''
		lvs_error_check = 'ERROR'
		return	
	
end if 

//========================================================
// $$HEX15$$04d6a5c718bc85c7d0c51cc1200091c588d478c72000bdacb0c6ccb92000$$ENDHEX$$
//========================================================
IF RB_MASS_RETURN.CHECKED = TRUE AND cbx_bad_yn.checked = FALSE  THEN 
//    cbx_auto_print.checked = true
	 
	    int lvi_exists
	 	select count(*) , max( inventory_type)
		   into :lvi_exists  , :lvs_inventory_type
		  from 	IM_ITEM_RECEIPT_BARCODE
		  WHERE ITEM_CODE = :LVS_ITEM_CODE 
			      AND LOT_NO = :lvs_lot_no
			      AND ORGANIZATION_ID = :GVI_ORganization_id ;
	 
			  if f_sql_check() <  0 then 
					sle_our_barcode.setfocus()
					sle_our_barcode.selecttext( 1,100)
				//	cbx_force_return.checked = false
					lvs_error_check = 'ERROR'
					return -1 
			  end if 
			  
			 
			  if lvi_exists = 0 then 
					st_status.text = '$$HEX10$$14bc54cfdcb4200074c725b82000c6c54cc72000$$ENDHEX$$: '+LVS_ITEM_CODE+"-"+lvs_lot_no
					sle_our_barcode.setfocus()
					sle_our_barcode.selecttext( 1,100)

					lvs_error_check = 'ERROR'
					return -1 
					
			  end if 
		//====================================================
		// $$HEX13$$85c7e0ac200044c6ccb820000cd598b7f8ad200024c115c82000$$ENDHEX$$
		// $$HEX10$$14bc54cfdcb4200018c2c9b72000c0bcbdac2000$$ENDHEX$$
		//====================================================
			UPDATE IM_ITEM_RECEIPT_BARCODE
				SET   ISSUE_COMPARE_YN = 'N' ,
						ISSUE_COMPARE_DATE = NULL  , 
						ISSUE_COMPARE_BY = NULL , 
						SUPPLIER_BARCODE = '*'  ,
						ISSUE_RETURN_YN = 'Y' ,
						ISSUE_RETURN_DATE = SYSDATE ,
						SCAN_QTY = :lvl_issue_qty ,
						LAST_SCAN_QTY = SCAN_QTY ,
						LAST_ISSUE_COMPARE_DATE = ISSUE_COMPARE_DATE ,
						LAST_ISSUE_COMPARE_BY = ISSUE_COMPARE_BY ,
						ITEM_BARCODE = :LVS_ITEM_CODE||'-'||:LVS_LOT_NO||'-'||:lvl_issue_qty ,
						FEEDING_YN = 'N' ,
						NEW_SCAN_QTY = 0 ,
						FEEDER_SHAFT = '' ,
						ISSUE_DIVISION = '',
						LOCATION_CODE = '' ,
						FEEDING_GROUP_NO = '' ,
						LAST_MODIFY_BY = :GVS_USER_ID ,
						LAST_MODIFY_DATE = SYSDATE 
			  WHERE ITEM_CODE = :LVS_ITEM_CODE 
			      AND LOT_NO = :lvs_lot_no
			      AND ORGANIZATION_ID = :GVI_ORganization_id ;
					 
			  if f_sql_check() <  0 then 
					sle_our_barcode.setfocus()
					sle_our_barcode.selecttext( 1,100)
				//	cbx_force_return.checked = false
					lvs_error_check = 'ERROR'
					return -1 
			  end if 
//====================================================
// $$HEX6$$9ccde0ac200018bc88d42000$$ENDHEX$$
//====================================================

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
			  DEMAND_QTY,BARCODE , FEEDER_SHAFT ,  ISSUE_DIVISION , FEEDER_LOCATION_CODE , MODEL_NAME , PCB_ITEM , INVENTORY_TYPE
			  )  
VALUES  (   :lvs_item_code,      //ITEM_CODE, 
				trunc(sysdate) ,      //ISSUE_DATE,   
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
				F_GET_LINE_TYPE_FROM_ITEM( :lvs_item_code  , :gvi_organization_id ) ,  //'F' ,      //LINE_TYPE,   
				NULL,      //COMMENTS,   
				0 ,      //ISSUE_PRICE,   
				NULL,      //VIRTUAL_RECEIPT_YN,   
				'N',      //ISSUE_TYPE,   
				F_GET_MAX_SUPPLIER_BY_ITEM(  :lvs_item_code  , :gvi_organization_id )  ,      //SUPPLIER_CODE,   
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
				:LVS_OUR_BARCODE ,
				 :LVS_FEEDER_SHAFT ,
				  :LVS_ISSUE_DIVISION ,
				  :LVS_FEEDER_LOCATION_CODE,
				  :LVS_MODEL_NAME , 
				  '*' ,
				  :lvs_inventory_type
		)  ;

	 if  f_sql_check() < 0 then
		st_status.text = '$$HEX22$$10cde0ac200018bc88d4200098ccacb9200011c9200024c658b900ac20001cbcddc0200088d5b5c2c8b2e4b2$$ENDHEX$$'
		sle_our_barcode.text=''
		sle_our_barcode.setfocus()
		lvs_error_check = 'ERROR'
		return
	end if
	
	//=======================================================
	//
	//=======================================================
	
	INSERT INTO IM_ITEM_ISSUE_LOSS
	                   ( 
					   ISSUE_DATE , ISSUE_SEQUENCE , ITEM_CODE , MATERIAL_MFS  , 
					   MODEL_NAME , LINE_CODE , ISSUE_QTY , ENTER_DATE , ENTER_BY ,
	                     LAST_MODIFY_DATE , LAST_MODIFY_BY , ORGANIZATION_ID 
					  )
					  
	VALUES ( SYSDATE , 
	              SEQ_MAT_ISSUE.NEXTVAL ,  
			     :lvs_item_code , 
				 :lvs_lot_no , 
	              :LVS_MODEL_NAME ,
				 :LVS_LINE_CODE ,
				 :lvl_issue_qty - :lvl_new_scan_qty , 
				 SYSDATE , 
			     :GVS_USER_ID ,  
				  SYSDATE ,
				 :GVS_USER_ID  , 
				 :GVI_ORGANIZATION_ID 
			    ) ;

		if  f_sql_check() < 0 then
				st_status.text = '$$HEX24$$10cde0ac200018bc88d45cb8a4c2200098ccacb9200011c9200024c658b900ac20001cbcddc0200088d5b5c2c8b2e4b2$$ENDHEX$$'
				sle_our_barcode.text=''
				sle_our_barcode.setfocus()
				lvs_error_check = 'ERROR'
				return
		end if				
	
	    COMMIT;
	
	f_play_sound("kittingok.wav")
	st_status.text = '$$HEX20$$15c8c1c098ccacb9200018b4c8c5b5c2c8b2e4b220007cb7a8bc200080bd29cc200058d538c194c6$$ENDHEX$$'
	sle_our_barcode.text = ''
	sle_our_barcode.text = ''
    sle_qty.text = ''

	//=============================================================
	// $$HEX4$$04d5b0b9b8d22000$$ENDHEX$$
	//=============================================================
	if cbx_auto_print.checked = true then 
	     f_set_column_dddw(dw_3)	
		dw_3.retrieve( lvs_item_code, lvs_slip_no  ,  lvs_lot_no  , gvi_organization_id )
	
		if dw_3.rowcount() > 0 then 	
				dw_3.print( )
		else
				st_status.text = '$$HEX32$$90c7ccb894b2200015c8c1c098ccacb9200018b4c8c5e0ac20009ccd25b8d0c52000e4c228d3200088d5b5c2c8b2e4b22000acc71cbc89d5200058d538c194c6$$ENDHEX$$'
				f_msgbox(117)
				sle_qty.setfocus()
		//		cbx_force_return.checked = false
				lvs_error_check = 'ERROR'
				return
		end if 
	
	end if 
	st_status.text = 'OK '	
	sle_our_barcode.SETFOCUS()
	
ELSEIF rb_outreturn.CHECKED = TRUE THEN 	
	
	lvdb_receipt_lot_no = F_GET_SEQUENCE('SEQ_MATERIAL_BARCODE')
	
	if sle_return_invoice_no.text = '' or  isnull(sle_return_invoice_no.text) then 
		lvs_slip_no =string( lvdb_receipt_lot_no )
	else
		lvs_slip_no =  sle_return_invoice_no.text
	end if 

	cbx_auto_print.checked = true
	lvs_lot_no =  STRING(F_T_SYSDATE(),'YYMMDD')+STRING(lvdb_receipt_lot_no,'00000')
	LVS_OUR_BARCODE = lvs_item_code+"-"+lvs_lot_no+"-"+string(lvl_issue_qty)

	//==================================================
	//
	//==================================================
	lvl_row = 0 
	LVL_ROW = DW_2.INSERTROW(1)
	DW_2.SCROLLTOROW(LVL_ROW)
	F_SET_SECURITY_ROW(DW_2 , LVL_ROW ,'ALL')

	dw_2.object.scan_date[LVL_ROW]            = f_sysdate()
	dw_2.object.item_code[LVL_ROW]            = lvs_item_code //$$HEX5$$fcd3a9ba54cfdcb42000$$ENDHEX$$
	dw_2.object.lot_no[LVL_ROW]                  = lvs_lot_no  //$$HEX5$$6fb8b8d288bc38d62000$$ENDHEX$$
	
	dw_2.object.receipt_slip_no[LVL_ROW]     = lvs_slip_no //$$HEX6$$85c7e0ac200020c715d62000$$ENDHEX$$+ $$HEX3$$6fb8b8d22000$$ENDHEX$$
	dw_2.object.receipt_compare_yn[lvl_row]  = 'Y' //$$HEX4$$44be50ad44c6ccb8$$ENDHEX$$
	dw_2.object.barcode_status[lvl_row]         = 'N'	
	
	dw_2.object.issue_compare_yn[lvl_row]    = 'N' //$$HEX5$$44be50ad44c6ccb82000$$ENDHEX$$
	dw_2.object.issue_return_yn[lvl_row]        = 'Y' 
	dw_2.object.issue_return_date[lvl_row]     = f_sysdate()
	
	dw_2.object.scan_qty[LVL_ROW]              = lvl_issue_qty
	dw_2.object.item_barcode[LVL_ROW]       = lvs_item_code+"-"+lvs_lot_no+"-"+string(lvl_issue_qty)// $$HEX9$$5ccd85c814bc54cfdcb42000090009000900$$ENDHEX$$
	dw_2.object.origin_item_barcode[LVL_ROW]       = lvs_item_code+"-"+lvs_lot_no+"-"+string(lvl_issue_qty)// $$HEX8$$5ccd85c814bc54cfdcb4200009000900$$ENDHEX$$
	dw_2.object.receipt_type[lvl_row]             = 'N' 
	dw_2.object.supplier_code[LVL_ROW]       = lvs_line_code
	dw_2.object.label_type[lvl_row]                = lvs_label_type
	dw_2.object.supplier_barcode[lvl_row]      = lvs_item_barcode
	dw_2.object.supplier_item_code[lvl_row]   = lvs_item_code
	
	dw_2.object.line_code[lvl_row]                  = lvs_line_code
	dw_2.object.workstage_code[lvl_row]         = '*'

//====================================================
// $$HEX6$$9ccde0ac200018bc88d42000$$ENDHEX$$
//====================================================

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
			  DEMAND_QTY ,
			  BARCODE )  
VALUES  (   :lvs_item_code,      //ITEM_CODE, 
				trunc(sysdate) ,      //ISSUE_DATE,   
				SEQ_MAT_ISSUE.NEXTVAL ,      //ISSUE_SEQUENCE,   
				:GVI_ORGANIZATION_ID ,      //ORGANIZATION_ID,   
				'*',      //MFS,   
				:LVS_LOCATION_CODE ,      //LOCATION_CODE,   
				'T',      //ITEM_TYPE,   
				:lvs_line_code,    //LINE_CODE,   
				'*',      //WORKSTAGE_CODE,   
				4,      //ISSUE_DEFICIT,   
				:lvl_issue_qty * -1 ,      //ISSUE_QTY,   
				'N',      //ISSUE_STATUS,   
				0 ,      //ISSUE_AMT,   
				'M001',      //ISSUE_ACCOUNT,   
				F_GET_LINE_TYPE_FROM_ITEM( :lvs_item_code  , :gvi_organization_id ) ,  //'F' ,      //LINE_TYPE,   
				:lvs_label_type,      //COMMENTS,   
				0 ,      //ISSUE_PRICE,   
				NULL,      //VIRTUAL_RECEIPT_YN,   
				:lvs_label_type,      //ISSUE_TYPE,    
				F_GET_MAX_SUPPLIER_BY_ITEM(  :lvs_item_code  , :gvi_organization_id )   ,      //SUPPLIER_CODE,   
				'*',      //WORK_ORDER_NO,   
				sysdate ,      //ENTER_DATE,   
				:gvs_user_id ,      //ENTER_BY,   
				sysdate ,      //LAST_MODIFY_DATE,   
				:gvs_user_id ,      //LAST_MODIFY_BY,   
				'*',      //MACHINE_CODE,   
				nvl(:LVS_SLIP_NO , :lvs_lot_no ) ,      //INVOICE_NO,   
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

		if  f_sql_check() < 0 then
			st_status.text = '$$HEX22$$10cde0ac200018bc88d4200098ccacb9200011c9200024c658b900ac20001cbcddc0200088d5b5c2c8b2e4b2$$ENDHEX$$'
			sle_our_barcode.text=''
			sle_qty.text = ''
			sle_our_barcode.setfocus()
			lvs_error_check = 'ERROR'
			return
		end if

	    COMMIT;
				
		IF  dw_2.UPDATE() < 0   THEN
				ROLLBACK;
				sle_our_barcode.TEXT = ''
				sle_qty.text = ''
				sle_our_barcode.SETFOCus( )
				st_status.text = '$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$'
				f_play_sound("scanfailed.wav")
				lvs_error_check = 'ERROR'
				RETURN					
		ELSE
				COMMIT;
				f_play_sound("KITTINGOK.wav")
				st_status.text = 'OK'
				sle_our_barcode.text = ''
				sle_qty.text = ''
				sle_our_barcode.setfocus( )
		END IF 
		
		//=============================================================
		// $$HEX4$$04d5b0b9b8d22000$$ENDHEX$$
		//=============================================================		
		if cbx_auto_print.checked = true then 
		     f_set_column_dddw(dw_3)	
			dw_3.retrieve( lvs_item_code,   lvs_slip_no  ,  lvs_lot_no  , gvi_organization_id )
			
			if dw_3.rowcount() > 0 then 	
			   dw_3.print( )
			else
			   st_status.text = '$$HEX21$$90c7ccb894b2200015c8c1c098ccacb9200018b4c8c5e0ac20009ccd25b840c72000c6c5b5c2c8b2e4b2$$ENDHEX$$.'
  			   sle_our_barcode.text = ''
			   sle_line_code.text = ''
			   sle_qty.text = ''
			   sle_our_barcode.setfocus()
			   return
			end if 
		end if 
		
		st_status.text = 'OK'
		sle_our_barcode.text = ''
	//	sle_line_code.text = ''
		sle_qty.text = ''
		sle_our_barcode.SETFOCUS()
		
	
//=============================================================
//  $$HEX6$$04d6a5c7200088bdc9b72000$$ENDHEX$$/ $$HEX5$$acb9fcbc00b330ae2000$$ENDHEX$$/ $$HEX6$$8cbc6cd0200018bc85c72000$$ENDHEX$$/ $$HEX7$$6cb874ce3cd5200018bc85c72000$$ENDHEX$$
//=============================================================
ELSE
		
		if sle_return_invoice_no.text = '' or  isnull(sle_return_invoice_no.text) then 
			lvs_slip_no =string( lvdb_receipt_lot_no )
		else
			lvs_slip_no =  sle_return_invoice_no.text
		end if 

 		 //================================================
	      //$$HEX48$$88bdc9b7200074c770ac98b02000acb9fcbc00b330ae200088d4200074c774ba20006fb8b8d27cb920006cad84bd58d5c0c920004ac5e0ac200014bc54cfdcb420007cb7a8bc44c72000ddc031c1200058d5c0c9c4b320004ac54cc720000900$$ENDHEX$$
		  //================================================
		if cbx_bad_yn.checked = true  or rb_mass_reball_wait_return.checked = true  then 
			
			cbx_auto_print.checked = false
			lvs_lot_no  =  lvs_item_code
			LVS_OUR_BARCODE = lvs_item_code+"-"+ STRING(F_T_SYSDATE(),'YYMMDD')+STRING(lvdb_receipt_lot_no,'00000')+"-"+string(lvl_issue_qty)
			
		else
				cbx_auto_print.checked = true
				//lvs_lot_no = STRING(F_T_SYSDATE(),'YYMMDD')+STRING(lvdb_receipt_lot_no,'00000')
				LVS_OUR_BARCODE = lvs_item_code+"-"+lvs_lot_no+"-"+string(lvl_issue_qty)
	
					//==================================================
					// SQL ERROR
					//==================================================
					
					SELECT count(*)
					INTO :lvi_count
					FROM IM_ITEM_RECEIPT_BARCODE
					WHERE ITEM_CODE     = :LVS_ITEM_CODE
					     AND LOT_NO = :LVS_LOT_NO
						 AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
					
					IF F_SQL_CHECK() < 0 THEN 
							sle_our_barcode.setfocus( )
							this.text = ''
							sle_our_barcode.text = ''	
					//		cbx_force_return.checked = false
							lvs_error_check = 'ERROR'
							RETURN 
					END IF
					
					//===================================================
					// $$HEX10$$74c7f8bb2000f1b45db81cb4200014bc54cfdcb4$$ENDHEX$$
					//===================================================
						
					if lvi_count > 0  then
						
						f_play_sound("EIXST.wav")
						st_status.text = '$$HEX21$$74c7f8bb200074c8acc758d594b2200014bc54cfdcb42000acc7ddc031c1200088bd00ac69d5c8b2e4b2$$ENDHEX$$'
						sle_our_barcode.setfocus( )
						sle_our_barcode.text = ''
				//		cbx_force_return.checked = false
						lvs_error_check = 'ERROR'
						return
					end if 
	
					//==================================================
					// 2016/10/19 SHS, ID_ITEM $$HEX3$$30ae00c92000$$ENDHEX$$VENDOR_CODE $$HEX2$$55d678c7$$ENDHEX$$
					//==================================================
					
				 	select NVL(VENDOR_CODE1, '') 
					   into :lvs_vendor_code 
		               from  ID_ITEM
				   WHERE ITEM_CODE = :LVS_ITEM_CODE 
			            AND ORGANIZATION_ID = :GVI_ORganization_id 
					   AND ROWNUM = 1;
	 
					if f_sql_check() <  0 then 
					  
					       sle_our_barcode.setfocus()
					       sle_our_barcode.selecttext( 1,100)
			      	       //	cbx_force_return.checked = false
					       lvs_error_check = 'ERROR'
					    return -1 
					
				     end if
					  
					//==================================================
					// 
					//==================================================					  

					    lvl_row = 0 
						LVL_ROW = DW_2.INSERTROW(1)
						DW_2.SCROLLTOROW(LVL_ROW)
						F_SET_SECURITY_ROW(DW_2 , LVL_ROW ,'ALL')
					
						dw_2.object.scan_date[LVL_ROW]            = f_sysdate()
						dw_2.object.item_code[LVL_ROW]            = lvs_item_code //$$HEX5$$fcd3a9ba54cfdcb42000$$ENDHEX$$
						dw_2.object.lot_no[LVL_ROW]                  = lvs_lot_no  //$$HEX5$$6fb8b8d288bc38d62000$$ENDHEX$$
						
						dw_2.object.receipt_slip_no[LVL_ROW]     = lvs_slip_no //$$HEX6$$85c7e0ac200020c715d62000$$ENDHEX$$+ $$HEX3$$6fb8b8d22000$$ENDHEX$$
						dw_2.object.receipt_compare_yn[lvl_row]  = 'Y' //$$HEX4$$44be50ad44c6ccb8$$ENDHEX$$
						dw_2.object.barcode_status[lvl_row]         = 'N'	
						
						dw_2.object.issue_compare_yn[lvl_row]    = 'N' //$$HEX5$$44be50ad44c6ccb82000$$ENDHEX$$
						dw_2.object.issue_return_yn[lvl_row]        = 'Y' 
						dw_2.object.issue_return_date[lvl_row]     = f_sysdate()
						
						dw_2.object.scan_qty[LVL_ROW]              = lvl_issue_qty
						dw_2.object.item_barcode[LVL_ROW]       = lvs_item_code+"-"+lvs_lot_no+"-"+string(lvl_issue_qty)// $$HEX9$$5ccd85c814bc54cfdcb42000090009000900$$ENDHEX$$
						dw_2.object.origin_item_barcode[LVL_ROW]       = lvs_item_code+"-"+lvs_lot_no+"-"+string(lvl_issue_qty)// $$HEX8$$5ccd85c814bc54cfdcb4200009000900$$ENDHEX$$
						dw_2.object.receipt_type[lvl_row]             = 'R' //$$HEX12$$18bc88d4d0c5200058c774d52000ddc034ae20007cb7a8bc$$ENDHEX$$
						dw_2.object.supplier_code[LVL_ROW]       = lvs_line_code
						dw_2.object.label_type[lvl_row]                = lvs_label_type
						dw_2.object.supplier_barcode[lvl_row]      = lvs_item_barcode
						dw_2.object.supplier_item_code[lvl_row]   = lvs_item_code
						
						dw_2.object.line_code[lvl_row]                  = lvs_line_code
						dw_2.object.workstage_code[lvl_row]         = '*'
											
					//==================================================
					// 2016/10/19 SHS, ID_ITEM $$HEX3$$30ae00c92000$$ENDHEX$$VENDOR_CODE $$HEX2$$55d678c7$$ENDHEX$$
					//==================================================
					
						if lvs_label_type = 'R' then
						   dw_2.object.vendor_lotno[lvl_row]   = 'REBALL'
 				  	        dw_2.object.vendor_code[lvl_row]   = lvs_vendor_code
						else
  						   if lvs_label_type = 'B' then
						      dw_2.object.vendor_lotno[lvl_row] = 'BULK'
						      dw_2.object.vendor_code[lvl_row]  = lvs_vendor_code	
						   end if	
					    end if
						 
					//==================================================
					// 
					//==================================================						
						
						
		    end if  // IF BAD 
//====================================================
// $$HEX6$$9ccde0ac200018bc88d42000$$ENDHEX$$
//====================================================

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
			  DEMAND_QTY ,
			  BARCODE )  
VALUES  (   :lvs_item_code,      //ITEM_CODE, 
				trunc(sysdate) ,      //ISSUE_DATE,   
				SEQ_MAT_ISSUE.NEXTVAL ,      //ISSUE_SEQUENCE,   
				:GVI_ORGANIZATION_ID ,      //ORGANIZATION_ID,   
				'*',      //MFS,   
				:LVS_LOCATION_CODE ,      //LOCATION_CODE,   
				'T',      //ITEM_TYPE,   
				:lvs_line_code,    //LINE_CODE,   
				'*',      //WORKSTAGE_CODE,   
				4,      //ISSUE_DEFICIT,   
				:lvl_issue_qty * -1 ,      //ISSUE_QTY,   
				'N',      //ISSUE_STATUS,   
				0 ,      //ISSUE_AMT,   
				'M001',      //ISSUE_ACCOUNT,   
				F_GET_LINE_TYPE_FROM_ITEM( :lvs_item_code  , :gvi_organization_id ) ,  //'F' ,      //LINE_TYPE,   
				:lvs_label_type,      //COMMENTS,   
				0 ,      //ISSUE_PRICE,   
				NULL,      //VIRTUAL_RECEIPT_YN,   
				:lvs_label_type,      //ISSUE_TYPE,   $$HEX9$$91c5b0c020008cbc6cd02000acb9fcbc2000$$ENDHEX$$
				F_GET_MAX_SUPPLIER_BY_ITEM(  :lvs_item_code  , :gvi_organization_id )   ,      //SUPPLIER_CODE,   
				'*',      //WORK_ORDER_NO,   
				sysdate ,      //ENTER_DATE,   
				:gvs_user_id ,      //ENTER_BY,   
				sysdate ,      //LAST_MODIFY_DATE,   
				:gvs_user_id ,      //LAST_MODIFY_BY,   
				'*',      //MACHINE_CODE,   
				nvl(:LVS_SLIP_NO , :lvs_lot_no ) ,      //INVOICE_NO,   
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

		 if  f_sql_check() < 0 then
			st_status.text = '$$HEX22$$10cde0ac200018bc88d4200098ccacb9200011c9200024c658b900ac20001cbcddc0200088d5b5c2c8b2e4b2$$ENDHEX$$'
			sle_our_barcode.text=''
			sle_qty.text = ''
		//	cbx_force_return.checked = false
			sle_our_barcode.setfocus()
			lvs_error_check = 'ERROR'
			return
		end if
//======================================================
//
//======================================================
	COMMIT;
				
		IF  dw_2.UPDATE() < 0   THEN
				ROLLBACK;
				sle_our_barcode.TEXT = ''
				sle_qty.text = ''
		//		cbx_force_return.checked = false
				sle_our_barcode.SETFOCus( )
				st_status.text = '$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$'
				f_play_sound("scanfailed.wav")
				lvs_error_check = 'ERROR'
				RETURN					
		ELSE
		
				COMMIT;
				f_play_sound("KITTINGOK.wav")
				st_status.text = 'OK'
				sle_our_barcode.text = ''
				sle_qty.text = ''
				sle_our_barcode.setfocus( )
		
		END IF 
		//=============================================================
		// $$HEX4$$04d5b0b9b8d22000$$ENDHEX$$
		//=============================================================
		
		if rb_bulk.checked = false then
			if cbx_auto_print.checked = true then 
					 f_set_column_dddw(dw_3)	
				dw_3.retrieve( lvs_item_code,   lvs_slip_no  ,  lvs_lot_no  , gvi_organization_id )
			
				if dw_3.rowcount() > 0 then 	
						dw_3.print( )
				else
						st_status.text = '$$HEX21$$90c7ccb894b2200015c8c1c098ccacb9200018b4c8c5e0ac20009ccd25b840c72000c6c5b5c2c8b2e4b2$$ENDHEX$$.'
						sle_our_barcode.text = ''
						sle_line_code.text = ''
						sle_qty.text = ''
						sle_our_barcode.setfocus()
						return
				end if 
			
			end if 
		else  //$$HEX6$$8cbc6cd074c774ba1cc12000$$ENDHEX$$msl$$HEX14$$90c7acc794b2200068d5b5c27cb7a8bcc4b320001cbc89d55cd5e4b2$$ENDHEX$$.
			if cbx_auto_print.checked = true then 
				f_set_column_dddw(dw_3)	
				dw_3.retrieve( lvs_item_code,   lvs_slip_no  ,  lvs_lot_no  , gvi_organization_id )
			
				if dw_3.rowcount() > 0 then 	
				   dw_3.print( )
					
				     //$$HEX7$$68d5b5c27cb7a8bc20009ccd25b8$$ENDHEX$$
					If cbx_msl.checked = true Then			  	 
						// MSL$$HEX6$$90c7acc7ecc580bdb4cc6cd0$$ENDHEX$$
						  SELECT NVL(msl_level, '0')
							  INTO :lvs_msl_level
							FROM  id_item
						  WHERE item_code = :lvs_item_code
							  AND organization_id = :gvi_organization_id  ;
						  
						  IF F_SQL_CHECK() < 0 THEN 
						  Else
							 IF  lvs_msl_level > '2'  THEN
								 dw_5.retrieve( lvs_item_code,   lvs_slip_no  ,  lvs_lot_no  , gvi_organization_id )
								 if dw_5.rowcount() > 0 then 	
									dw_5.print( )
								 end if
							  End if	
						  END IF 		
					End if
					
				else
				   st_status.text = '$$HEX21$$90c7ccb894b2200015c8c1c098ccacb9200018b4c8c5e0ac20009ccd25b840c72000c6c5b5c2c8b2e4b2$$ENDHEX$$.'
   			   	   sle_our_barcode.text = ''
				   sle_line_code.text = ''
			  	   sle_qty.text = ''
				   sle_our_barcode.setfocus()
				   return
				end if 
			
			end if 
		end if
		st_status.text = 'OK'
		sle_our_barcode.text = ''
		sle_line_code.text = ''
		sle_qty.text = ''
		sle_our_barcode.SETFOCUS()

END IF ;

end event

type st_8 from so_statictext within w_mat_other_mass_issue_barcode_return_master
integer x = 1326
integer y = 832
integer width = 485
integer height = 76
boolean bringtotop = true
long textcolor = 16711680
long backcolor = 12639424
boolean enabled = false
string text = "Our Barcode"
alignment alignment = right!
end type

type rb_mass_return from so_radiobutton within w_mat_other_mass_issue_barcode_return_master
integer x = 91
integer y = 620
integer width = 517
boolean bringtotop = true
integer textsize = -10
long backcolor = 12639424
string text = "Mass Return"
boolean checked = true
end type

event clicked;call super::clicked;st_status.text = "$$HEX7$$91c5b0c07cb7a8bc20001cbc89d5$$ENDHEX$$"
sle_our_barcode.setfocus()
cbx_check_price.checked = True
end event

type sle_line_code from so_singlelineedit within w_mat_other_mass_issue_barcode_return_master
integer x = 1824
integer y = 720
integer width = 411
integer height = 88
integer taborder = 30
boolean bringtotop = true
long backcolor = 16777215
end type

type ddlb_line_code from uo_line_code within w_mat_other_mass_issue_barcode_return_master
integer x = 2245
integer y = 720
integer width = 439
integer height = 2044
integer taborder = 40
boolean bringtotop = true
long backcolor = 12639424
boolean sorted = true
boolean hscrollbar = false
end type

event selectionchanged;call super::selectionchanged;String lvs_line_division

sle_line_code.text = this.getcode( )

if this.getcode( ) = '11' then
     select line_division 
	   into :lvs_line_division
	 from ip_product_line 
   where line_code = '11' ;
	
  if f_sql_check() <  0 then 
	st_status.text = '$$HEX13$$7cb778c7200015c8f4bc7cb9200055d678c7200058d538c194c6$$ENDHEX$$'
	return -1 
  end if 
  
  if lvs_line_division = 'ETC' then
	rb_outreturn.checked = true
  else
	rb_mass_return.checked = true
  end if
else
    rb_mass_return.checked = true
end if	
end event

type sle_return_invoice_no from so_singlelineedit within w_mat_other_mass_issue_barcode_return_master
integer x = 2697
integer y = 720
integer height = 88
boolean bringtotop = true
long backcolor = 16777215
end type

type st_9 from so_statictext within w_mat_other_mass_issue_barcode_return_master
integer x = 2697
integer y = 652
integer height = 60
boolean bringtotop = true
long textcolor = 16711680
long backcolor = 12639424
string text = "Invoice"
end type

type cbx_bad_yn from so_checkbox within w_mat_other_mass_issue_barcode_return_master
integer x = 914
integer y = 608
integer width = 338
boolean bringtotop = true
integer textsize = -10
long backcolor = 12639424
string text = "Bad"
end type

type rb_bulk from so_radiobutton within w_mat_other_mass_issue_barcode_return_master
integer x = 91
integer y = 872
integer width = 517
boolean bringtotop = true
integer textsize = -10
long backcolor = 12639424
string text = "Bulk Return"
end type

event clicked;call super::clicked;st_status.text = "$$HEX7$$8cbc6cd07cb7a8bc20001cbc89d5$$ENDHEX$$"
cbx_bad_yn.checked = false
sle_our_barcode.setfocus()
cbx_check_price.checked = false
end event

type rb_mass_reball_wait_return from so_radiobutton within w_mat_other_mass_issue_barcode_return_master
integer x = 91
integer y = 700
integer width = 722
boolean bringtotop = true
integer textsize = -10
long backcolor = 12639424
string text = "Mass Reball Wait Return"
end type

event clicked;call super::clicked;if this.checked = true then 
	cbx_bad_yn.checked = false
	cbx_bad_yn.enabled = false
else
	cbx_bad_yn.checked = false	
	cbx_bad_yn.enabled = true
end if 

cbx_check_price.checked = false
end event

type ddlb_line_code_cond from uo_line_code within w_mat_other_mass_issue_barcode_return_master
integer x = 873
integer y = 420
integer width = 439
integer height = 2044
integer taborder = 50
boolean bringtotop = true
long backcolor = 12639424
boolean sorted = true
boolean hscrollbar = false
end type

event selectionchanged;call super::selectionchanged;sle_line_code.text = this.getcode( )

end event

type st_2 from so_statictext within w_mat_other_mass_issue_barcode_return_master
integer x = 873
integer y = 340
integer width = 439
integer height = 72
boolean bringtotop = true
long backcolor = 12639424
string text = "Line Code"
end type

type dw_6 from so_datawindow within w_mat_other_mass_issue_barcode_return_master
integer x = 4087
integer y = 412
integer width = 1458
integer height = 640
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = ""
string dataobject = "d_mat_batch_return_excel_lst"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

type pb_paste from so_commandbutton within w_mat_other_mass_issue_barcode_return_master
integer x = 4571
integer y = 276
integer width = 466
integer taborder = 40
boolean bringtotop = true
string text = "Excel Paste"
end type

event clicked;call super::clicked;dw_6.reset()
dw_6.importclipboard( )
string lvs_item_code_check
long  lvl_return_qty
int i
do
	i++
		lvs_item_code_check = upper(dw_6.object.item_code[i])
		lvl_return_qty = long(dw_6.object.return_qty[i])
		
			if lvl_return_qty <= 0 then 
				Messagebox("$$HEX2$$55d678c7$$ENDHEX$$" , "$$HEX13$$18c2c9b774c720002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$")
				st_status.text =f_msg_st(9041)+" "+lvs_item_code_CHECK
				sle_our_barcode.setfocus()
				sle_our_barcode.selecttext( 1,100)	
				return -1
			end if 
	
			if f_check_item_exists( lvs_item_code , f_t_sysdate())  <= 0 then 
				f_play_sound("$$HEX5$$88d4a9baf8bbf1b45db8$$ENDHEX$$.wav")	
				f_msgbox(9041) //$$HEX10$$fcd3a9bac8b9a4c230d12000f8bbf1b45db82000$$ENDHEX$$
				st_status.text =f_msg_st(9041)+" "+lvs_item_code
				sle_our_barcode.setfocus()
				sle_our_barcode.selecttext( 1,100)	
				return -1
			end if 
			
loop until i = dw_6.rowcount()
end event

type pb_return from so_commandbutton within w_mat_other_mass_issue_barcode_return_master
integer x = 5047
integer y = 268
integer width = 466
integer taborder = 40
boolean bringtotop = true
string text = "Batch Return"
end type

event clicked;call super::clicked;int i

IF rb_romcopy.checked = true or rb_mass_reball_wait_return.checked = true or rb_bulk.checked = true or ( rb_mass_return.checked = true and cbx_bad_yn.checked =true ) then 
else
	messagebox("$$HEX2$$55d678c7$$ENDHEX$$" , "$$HEX8$$04d6a5c788bdc9b7200018bc88d42000$$ENDHEX$$/ $$HEX6$$acb9fcbc00aca5b220002000$$ENDHEX$$/ $$HEX16$$8cbc6cd02000ccb9200098ccacb9200060d518c2200088c7b5c2c8b2e4b22000$$ENDHEX$$")
	return 
end if 

do
	i++
	sle_return_invoice_no.text = dw_6.object.return_invoice_no[i]
	sle_our_barcode.text = upper(dw_6.object.item_code[i])
	sle_our_barcode.triggerevent( modified!)
	
	sle_qty.text = string( dw_6.object.return_qty[i] )
	sle_qty.triggerevent( modified!)
	
loop until i = dw_6.rowcount()

dw_6.reset()
end event

type rb_romcopy from so_radiobutton within w_mat_other_mass_issue_barcode_return_master
integer x = 91
integer y = 784
integer width = 521
boolean bringtotop = true
integer textsize = -10
long backcolor = 12639424
string text = "RomCopy Return"
end type

event clicked;call super::clicked;cbx_check_price.checked = false
end event

type cbx_line_manual_check from so_checkbox within w_mat_other_mass_issue_barcode_return_master
integer x = 1824
integer y = 640
integer width = 631
integer height = 76
boolean bringtotop = true
long textcolor = 255
long backcolor = 12639424
string text = "Line Manual Check"
end type

type ddlb_issue_type from uo_basecode within w_mat_other_mass_issue_barcode_return_master
integer x = 2880
integer y = 416
integer width = 507
integer taborder = 60
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'ISSUE TYPE')
end event

type st_10 from so_statictext within w_mat_other_mass_issue_barcode_return_master
integer x = 2880
integer y = 340
integer width = 507
integer height = 72
boolean bringtotop = true
long backcolor = 12639424
string text = "Issue Type"
end type

type pb_cancel from so_commandbutton within w_mat_other_mass_issue_barcode_return_master
integer x = 4091
integer y = 276
integer width = 466
integer taborder = 50
boolean bringtotop = true
string text = "Cancel"
end type

event clicked;call super::clicked;open(w_mat_issue_return_cancel_4_barcode_popup)
end event

type cbx_label_size from so_checkbox within w_mat_other_mass_issue_barcode_return_master
integer x = 3497
integer y = 388
integer width = 379
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
long backcolor = 12639424
string text = "Width Type"
end type

event clicked;//=====================================
// $$HEX10$$1cc80cbe7cb7200029bcddc220009ccd25b82000$$ENDHEX$$
//=====================================
if (this.checked) then 

	dw_3.dataobject = 'd_mat_receipt_lot_barcode_w_rpt' 
	dw_3.settransobject(sqlca) 
else 
	dw_3.dataobject = 'd_mat_receipt_lot_barcode_rpt' 
	dw_3.settransobject(sqlca) 
end if
end event

type cbx_check_price from so_checkbox within w_mat_other_mass_issue_barcode_return_master
integer x = 3209
integer y = 732
integer width = 434
integer height = 64
boolean bringtotop = true
long textcolor = 255
long backcolor = 12639424
string text = "Check Price"
boolean checked = true
end type

type em_check_price from so_editmask within w_mat_other_mass_issue_barcode_return_master
integer x = 3209
integer y = 800
integer width = 434
integer taborder = 40
boolean bringtotop = true
long backcolor = 16777215
string text = "1000"
alignment alignment = center!
string mask = "###,##0"
boolean spin = true
double increment = 1
end type

type cbx_msl from so_checkbox within w_mat_other_mass_issue_barcode_return_master
integer x = 3497
integer y = 464
integer width = 549
integer height = 76
boolean bringtotop = true
integer textsize = -10
long backcolor = 12639424
string text = "Msl Label Print"
end type

type rb_outreturn from so_radiobutton within w_mat_other_mass_issue_barcode_return_master
integer x = 91
integer y = 956
integer width = 594
boolean bringtotop = true
integer textsize = -10
long backcolor = 12639424
string text = "Out Return"
end type

event clicked;call super::clicked;if this.checked = true then 
	cbx_bad_yn.checked = false
	cbx_bad_yn.enabled = false
else
	cbx_bad_yn.checked = false	
	cbx_bad_yn.enabled = true
end if 

cbx_check_price.checked = false
end event

type sle_scan_qty from so_singlelineedit within w_mat_other_mass_issue_barcode_return_master
integer x = 2798
integer y = 908
integer width = 393
integer height = 88
integer taborder = 30
boolean bringtotop = true
long backcolor = 16777215
boolean enabled = false
end type

type st_11 from so_statictext within w_mat_other_mass_issue_barcode_return_master
integer x = 2304
integer y = 916
integer width = 485
integer height = 84
boolean bringtotop = true
long textcolor = 16711680
long backcolor = 12639424
string text = "Scan Qty"
alignment alignment = right!
end type

type gb_2 from so_groupbox within w_mat_other_mass_issue_barcode_return_master
integer x = 27
integer y = 564
integer width = 818
integer height = 484
integer weight = 700
long textcolor = 16711680
long backcolor = 12639424
string text = "Category"
end type

type gb_4 from so_groupbox within w_mat_other_mass_issue_barcode_return_master
integer x = 1298
integer y = 568
integer width = 2770
integer height = 484
integer weight = 700
long textcolor = 16711680
long backcolor = 12639424
string text = "Scan Issue Return"
end type

type gb_1 from so_groupbox within w_mat_other_mass_issue_barcode_return_master
integer y = 260
integer width = 3433
integer height = 300
integer weight = 700
long textcolor = 16711680
long backcolor = 12639424
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_mat_other_mass_issue_barcode_return_master
integer x = 3442
integer y = 252
integer width = 622
integer height = 308
integer weight = 700
long textcolor = 16711680
long backcolor = 12639424
string text = "Process"
end type

type gb_5 from so_groupbox within w_mat_other_mass_issue_barcode_return_master
integer x = 859
integer y = 564
integer width = 425
integer height = 484
integer taborder = 40
long backcolor = 12639424
end type

