HA$PBExportHeader$w_mat_other_issue_barcode_return_master.srw
$PBExportComments$Material Mass Issue Return Master
forward
global type w_mat_other_issue_barcode_return_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mat_other_issue_barcode_return_master
end type
type uo_dateend from uo_ymd_calendar within w_mat_other_issue_barcode_return_master
end type
type ddlb_item_code from uo_item_code within w_mat_other_issue_barcode_return_master
end type
type st_3 from so_statictext within w_mat_other_issue_barcode_return_master
end type
type st_4 from so_statictext within w_mat_other_issue_barcode_return_master
end type
type st_status from so_statictext within w_mat_other_issue_barcode_return_master
end type
type sle_item_code from so_singlelineedit within w_mat_other_issue_barcode_return_master
end type
type st_2 from so_statictext within w_mat_other_issue_barcode_return_master
end type
type sle_invoice_no from so_singlelineedit within w_mat_other_issue_barcode_return_master
end type
type sle_material_mfs from so_singlelineedit within w_mat_other_issue_barcode_return_master
end type
type st_5 from so_statictext within w_mat_other_issue_barcode_return_master
end type
type st_6 from so_statictext within w_mat_other_issue_barcode_return_master
end type
type st_7 from so_statictext within w_mat_other_issue_barcode_return_master
end type
type rb_repair from so_radiobutton within w_mat_other_issue_barcode_return_master
end type
type rb_reball from so_radiobutton within w_mat_other_issue_barcode_return_master
end type
type cbx_auto_print from so_checkbox within w_mat_other_issue_barcode_return_master
end type
type st_1 from so_statictext within w_mat_other_issue_barcode_return_master
end type
type sle_qty from so_singlelineedit within w_mat_other_issue_barcode_return_master
end type
type sle_line_code from so_singlelineedit within w_mat_other_issue_barcode_return_master
end type
type cbx_force_return from so_checkbox within w_mat_other_issue_barcode_return_master
end type
type ddlb_line_code from uo_line_code within w_mat_other_issue_barcode_return_master
end type
type dw_6 from so_datawindow within w_mat_other_issue_barcode_return_master
end type
type pb_paste from so_commandbutton within w_mat_other_issue_barcode_return_master
end type
type pb_return from so_commandbutton within w_mat_other_issue_barcode_return_master
end type
type sle_return_invoice_no from so_singlelineedit within w_mat_other_issue_barcode_return_master
end type
type st_9 from so_statictext within w_mat_other_issue_barcode_return_master
end type
type cbx_bad_yn from so_checkbox within w_mat_other_issue_barcode_return_master
end type
type cbx_wait_reball from so_checkbox within w_mat_other_issue_barcode_return_master
end type
type ddlb_line_code_cond from uo_line_code within w_mat_other_issue_barcode_return_master
end type
type st_8 from so_statictext within w_mat_other_issue_barcode_return_master
end type
type cbx_check_price from so_checkbox within w_mat_other_issue_barcode_return_master
end type
type em_check_price from so_editmask within w_mat_other_issue_barcode_return_master
end type
type cbx_auto_qty from so_checkbox within w_mat_other_issue_barcode_return_master
end type
type pb_cancel from so_commandbutton within w_mat_other_issue_barcode_return_master
end type
type cbx_bulk from so_checkbox within w_mat_other_issue_barcode_return_master
end type
type sle_scan_qty from so_singlelineedit within w_mat_other_issue_barcode_return_master
end type
type st_10 from so_statictext within w_mat_other_issue_barcode_return_master
end type
type gb_2 from so_groupbox within w_mat_other_issue_barcode_return_master
end type
type gb_4 from so_groupbox within w_mat_other_issue_barcode_return_master
end type
type gb_1 from so_groupbox within w_mat_other_issue_barcode_return_master
end type
type gb_3 from so_groupbox within w_mat_other_issue_barcode_return_master
end type
type gb_5 from so_groupbox within w_mat_other_issue_barcode_return_master
end type
end forward

global type w_mat_other_issue_barcode_return_master from w_main_root
integer width = 5710
integer height = 3228
string title = "Material Issue Barcode Return (Repair/Reball) Master"
long backcolor = 16777215
uo_dateset uo_dateset
uo_dateend uo_dateend
ddlb_item_code ddlb_item_code
st_3 st_3
st_4 st_4
st_status st_status
sle_item_code sle_item_code
st_2 st_2
sle_invoice_no sle_invoice_no
sle_material_mfs sle_material_mfs
st_5 st_5
st_6 st_6
st_7 st_7
rb_repair rb_repair
rb_reball rb_reball
cbx_auto_print cbx_auto_print
st_1 st_1
sle_qty sle_qty
sle_line_code sle_line_code
cbx_force_return cbx_force_return
ddlb_line_code ddlb_line_code
dw_6 dw_6
pb_paste pb_paste
pb_return pb_return
sle_return_invoice_no sle_return_invoice_no
st_9 st_9
cbx_bad_yn cbx_bad_yn
cbx_wait_reball cbx_wait_reball
ddlb_line_code_cond ddlb_line_code_cond
st_8 st_8
cbx_check_price cbx_check_price
em_check_price em_check_price
cbx_auto_qty cbx_auto_qty
pb_cancel pb_cancel
cbx_bulk cbx_bulk
sle_scan_qty sle_scan_qty
st_10 st_10
gb_2 gb_2
gb_4 gb_4
gb_1 gb_1
gb_3 gb_3
gb_5 gb_5
end type
global w_mat_other_issue_barcode_return_master w_mat_other_issue_barcode_return_master

type variables
string LVS_ISSUE_COMPARE_YN ,LVS_ISSUE_RETURN_YN 
string LVS_WORKSTAGE_CODE ,  lvs_item_barcode 
string lvs_our_barcode , lvs_lot_no , lvs_item_code   , LVS_LOCATION_CODE , lvs_line_type , lvs_line_code , lvs_label_type , lvs_slip_no
long lvl_issue_qty  , lvl_row , lvi_count , lvi_pos1 , lvi_pos2 , lvl_new_scan_qty
double lvdb_receipt_lot_no
string lvs_error_check , LVS_MODEL_NAME
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

on w_mat_other_issue_barcode_return_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.ddlb_item_code=create ddlb_item_code
this.st_3=create st_3
this.st_4=create st_4
this.st_status=create st_status
this.sle_item_code=create sle_item_code
this.st_2=create st_2
this.sle_invoice_no=create sle_invoice_no
this.sle_material_mfs=create sle_material_mfs
this.st_5=create st_5
this.st_6=create st_6
this.st_7=create st_7
this.rb_repair=create rb_repair
this.rb_reball=create rb_reball
this.cbx_auto_print=create cbx_auto_print
this.st_1=create st_1
this.sle_qty=create sle_qty
this.sle_line_code=create sle_line_code
this.cbx_force_return=create cbx_force_return
this.ddlb_line_code=create ddlb_line_code
this.dw_6=create dw_6
this.pb_paste=create pb_paste
this.pb_return=create pb_return
this.sle_return_invoice_no=create sle_return_invoice_no
this.st_9=create st_9
this.cbx_bad_yn=create cbx_bad_yn
this.cbx_wait_reball=create cbx_wait_reball
this.ddlb_line_code_cond=create ddlb_line_code_cond
this.st_8=create st_8
this.cbx_check_price=create cbx_check_price
this.em_check_price=create em_check_price
this.cbx_auto_qty=create cbx_auto_qty
this.pb_cancel=create pb_cancel
this.cbx_bulk=create cbx_bulk
this.sle_scan_qty=create sle_scan_qty
this.st_10=create st_10
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
this.Control[iCurrent+7]=this.sle_item_code
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.sle_invoice_no
this.Control[iCurrent+10]=this.sle_material_mfs
this.Control[iCurrent+11]=this.st_5
this.Control[iCurrent+12]=this.st_6
this.Control[iCurrent+13]=this.st_7
this.Control[iCurrent+14]=this.rb_repair
this.Control[iCurrent+15]=this.rb_reball
this.Control[iCurrent+16]=this.cbx_auto_print
this.Control[iCurrent+17]=this.st_1
this.Control[iCurrent+18]=this.sle_qty
this.Control[iCurrent+19]=this.sle_line_code
this.Control[iCurrent+20]=this.cbx_force_return
this.Control[iCurrent+21]=this.ddlb_line_code
this.Control[iCurrent+22]=this.dw_6
this.Control[iCurrent+23]=this.pb_paste
this.Control[iCurrent+24]=this.pb_return
this.Control[iCurrent+25]=this.sle_return_invoice_no
this.Control[iCurrent+26]=this.st_9
this.Control[iCurrent+27]=this.cbx_bad_yn
this.Control[iCurrent+28]=this.cbx_wait_reball
this.Control[iCurrent+29]=this.ddlb_line_code_cond
this.Control[iCurrent+30]=this.st_8
this.Control[iCurrent+31]=this.cbx_check_price
this.Control[iCurrent+32]=this.em_check_price
this.Control[iCurrent+33]=this.cbx_auto_qty
this.Control[iCurrent+34]=this.pb_cancel
this.Control[iCurrent+35]=this.cbx_bulk
this.Control[iCurrent+36]=this.sle_scan_qty
this.Control[iCurrent+37]=this.st_10
this.Control[iCurrent+38]=this.gb_2
this.Control[iCurrent+39]=this.gb_4
this.Control[iCurrent+40]=this.gb_1
this.Control[iCurrent+41]=this.gb_3
this.Control[iCurrent+42]=this.gb_5
end on

on w_mat_other_issue_barcode_return_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.ddlb_item_code)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_status)
destroy(this.sle_item_code)
destroy(this.st_2)
destroy(this.sle_invoice_no)
destroy(this.sle_material_mfs)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.st_7)
destroy(this.rb_repair)
destroy(this.rb_reball)
destroy(this.cbx_auto_print)
destroy(this.st_1)
destroy(this.sle_qty)
destroy(this.sle_line_code)
destroy(this.cbx_force_return)
destroy(this.ddlb_line_code)
destroy(this.dw_6)
destroy(this.pb_paste)
destroy(this.pb_return)
destroy(this.sle_return_invoice_no)
destroy(this.st_9)
destroy(this.cbx_bad_yn)
destroy(this.cbx_wait_reball)
destroy(this.ddlb_line_code_cond)
destroy(this.st_8)
destroy(this.cbx_check_price)
destroy(this.em_check_price)
destroy(this.cbx_auto_qty)
destroy(this.pb_cancel)
destroy(this.cbx_bulk)
destroy(this.sle_scan_qty)
destroy(this.st_10)
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
sle_item_code.setfocus()
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
			dw_1.retrieve( uo_dateset.text() , uo_dateend.text(),   ddlb_line_code_cond.getcode( )+'%' ,  ddlb_item_code.text() + '%',   sle_invoice_no.text+'%' , sle_material_mfs.text+'%' ,  '%' ,  gvi_organization_id)
			sle_item_code.setfocus()

	case else
end choose

end event

event open;call super::open;sle_item_code.setfocus()
end event

event clicked;call super::clicked;sle_item_code.setfocus()
end event

event resize;call super::resize;st_status.width = dw_1.width + dw_2.width
end event

type dw_5 from w_main_root`dw_5 within w_mat_other_issue_barcode_return_master
integer y = 1028
integer width = 2373
integer height = 752
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_mat_other_issue_barcode_return_master
integer y = 1028
integer width = 2373
integer height = 752
integer taborder = 0
end type

type dw_3 from w_main_root`dw_3 within w_mat_other_issue_barcode_return_master
integer x = 5
integer y = 1028
integer width = 2373
integer height = 948
integer taborder = 0
boolean titlebar = true
string dataobject = "d_mat_receipt_lot_barcode_rpt"
end type

type dw_2 from w_main_root`dw_2 within w_mat_other_issue_barcode_return_master
integer x = 3474
integer y = 1028
integer width = 1385
integer height = 952
integer taborder = 0
boolean titlebar = true
string dataobject = "d_mat_rceipt_barcode_4_issue_return_lst"
borderstyle borderstyle = stylebox!
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

type dw_1 from w_main_root`dw_1 within w_mat_other_issue_barcode_return_master
integer y = 1028
integer width = 3465
integer height = 952
integer taborder = 0
boolean titlebar = true
string title = "Issue Return List"
string dataobject = "d_mat_issue_4_barcode_return_lst"
borderstyle borderstyle = stylebox!
end type

event dw_1::clicked;call super::clicked;sle_item_code.setfocus()
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
dw_2.retrieve( this.object.item_code[currentrow] , this.object.material_mfs[currentrow] , this.object.invoice_no[currentrow] , gvi_organization_id ) 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_other_issue_barcode_return_master
integer taborder = 0
long backcolor = 16777215
end type

type uo_dateset from uo_ymd_calendar within w_mat_other_issue_barcode_return_master
event destroy ( )
integer x = 78
integer y = 412
boolean bringtotop = true
long backcolor = 16777215
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_other_issue_barcode_return_master
event destroy ( )
integer x = 494
integer y = 412
boolean bringtotop = true
long backcolor = 16777215
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_item_code from uo_item_code within w_mat_other_issue_barcode_return_master
integer x = 1513
integer y = 420
integer width = 530
integer height = 668
integer taborder = 0
boolean bringtotop = true
long backcolor = 16777215
end type

event selectionchanged;call super::selectionchanged;sle_item_code.setfocus()
end event

type st_3 from so_statictext within w_mat_other_issue_barcode_return_master
integer x = 1513
integer y = 332
integer width = 530
integer height = 72
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
string text = "Item Code"
end type

type st_4 from so_statictext within w_mat_other_issue_barcode_return_master
integer x = 82
integer y = 332
integer width = 814
integer height = 72
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
string text = "Issue Date"
end type

type st_status from so_statictext within w_mat_other_issue_barcode_return_master
integer width = 5371
integer height = 248
boolean bringtotop = true
integer textsize = -36
long textcolor = 16777215
string text = "Message"
end type

type sle_item_code from so_singlelineedit within w_mat_other_issue_barcode_return_master
integer x = 1371
integer y = 844
integer width = 1239
integer height = 108
integer taborder = 10
boolean bringtotop = true
long backcolor = 16777215
textcase textcase = upper!
end type

event getfocus;call super::getfocus;this.selecttext(1,100)
st_status.text = "$$HEX18$$88d4a9ba54cfdcb47cb9200085c725b858d570ac98b02000a4c294ce200058d538c194c6$$ENDHEX$$"
end event

event modified;call super::modified;lvs_error_check = ''
//=================================================
// $$HEX18$$acb9fcbc2000c5c5b4cc5cb8200080bd30d1200018bc88d444c72000a1c794b2e4b22000$$ENDHEX$$
//=================================================
if rb_reball.checked = true then 
	
		if sle_line_code.text = '' or isnull(sle_line_code.text) then
			Messagebox("$$HEX2$$55d678c7$$ENDHEX$$" , "$$HEX10$$acb9fcbc18bc88d4200000b3c1c02000c5c5b4cc$$ENDHEX$$/$$HEX9$$7cb778c744c7200020c1ddd058d538c194c6$$ENDHEX$$")
			lvs_error_check = 'ERROR'
			return -1
		else
			//$$HEX6$$7cb778c7200054cfdcb42000$$ENDHEX$$
			lvs_line_code = sle_line_code.text
		end if 
		
		//=============================
		//   
		//=============================
		if cbx_bad_yn.checked = true then 
			LVS_LOCATION_CODE = 'M02'
		else
			
			if cbx_wait_reball.checked = true then 
				LVS_LOCATION_CODE = 'M04' //$$HEX9$$acb9fcbc200000aca5b2200000b330ae2000$$ENDHEX$$
			else
				LVS_LOCATION_CODE = 'M06'	//$$HEX5$$acb9fcbc91c588d42000$$ENDHEX$$
			end if 
		end if 	
		lvs_label_type = 'R'
	
//==============================================
// $$HEX10$$18c2acb9e4c2200018bca9b0200020c715d62000$$ENDHEX$$: $$HEX3$$88bdc9b72000$$ENDHEX$$, $$HEX6$$acb9fcbc00b330ae20002000$$ENDHEX$$, $$HEX3$$91c588d42000$$ENDHEX$$
//==============================================
elseif  rb_repair.checked = true then 

	if cbx_bad_yn.checked = true then 
		LVS_LOCATION_CODE = 'M02' //$$HEX3$$88bdc9b72000$$ENDHEX$$
		lvs_label_type = 'N'
		
	elseif cbx_bulk.checked = true then 
		LVS_LOCATION_CODE = 'M05' //$$HEX4$$8cbc6cd020002000$$ENDHEX$$
		lvs_label_type = 'B'		
	else	
		if cbx_wait_reball.checked = true then 
			LVS_LOCATION_CODE = 'M04' //$$HEX9$$acb9fcbc200000aca5b2200000b330ae2000$$ENDHEX$$
			lvs_label_type = 'R'
		else
			LVS_LOCATION_CODE = 'M01' //$$HEX3$$91c588d42000$$ENDHEX$$
			lvs_label_type = 'N'
		end if 
	end if 

	//$$HEX18$$18c2d9b33cc75cb820007cb778c744c7200020c1ddd058d574ba2000f8ad7cb778c72000$$ENDHEX$$
	if  sle_line_code.text = '' or isnull(sle_line_code.text) then 
		lvs_line_code  = '21' //$$HEX17$$18c2acb9e4c218bca9b040c72000a8ba50b4200018c2acb9e4c220007cb778c72000$$ENDHEX$$
	else
		lvs_line_code = sle_line_code.text
	end if 
//==============================================
//
//==============================================
else
	LVS_LOCATION_CODE = 'M99'
	lvs_label_type = 'E'
end if 

//=================================================================================
// $$HEX3$$18c2acb92000$$ENDHEX$$/  $$HEX3$$8cbc6cd02000$$ENDHEX$$/ $$HEX6$$acb9fcbc200018bc88d42000$$ENDHEX$$
//=================================================================================

lvs_item_barcode = sle_item_code.text 

lvi_pos1 =  pos( sle_item_code.text ,'-' , 7 )

if lvi_pos1 <= 0 then 
	lvs_item_code = mid( sle_item_code.text , 1, 11 )
else
	lvs_item_code = mid( sle_item_code.text , 1, lvi_pos1 - 1 ) 
end if 
lvs_line_type   = f_get_line_type_from_item( lvs_item_code )

//==================================================
//
//==================================================

if f_check_item_exists( lvs_item_code , f_t_sysdate())  <= 0 then 
	lvs_error_check = 'ERROR'
	f_play_sound("barcodeno.wav")	
	f_msgbox(9041) //$$HEX10$$fcd3a9bac8b9a4c230d12000f8bbf1b45db82000$$ENDHEX$$
	sle_item_code.setfocus()
	sle_item_code.selecttext( 1,100)
end if 


//==================================================
//  
//==================================================
if cbx_check_price.checked = true then 	
	
	    DECIMAL LVF_UNIT_PRICE
		SELECT F_GET_MAT_MAX_UNIT_PRICE_CFM( :LVS_ITEM_CODE , :lvs_line_type , SYSDATE , :GVI_ORGANIZATION_ID )  
		    INTO :LVF_UNIT_PRICE 
		 FROM DUAL  ;

		 IF F_SQL_CHECK() < 0 THEN 
				sle_item_code.text = ''	
				sle_item_code.setfocus()
				return -1 
		END IF 		 
		 
		if LVF_UNIT_PRICE> Dec(em_check_price.text) then 
			f_play_sound("scanfailed.wav")
			st_status.text = "$$HEX17$$e0ac00ac200090c7acc7200085c7c8b2e4b220009ccde0ac18bc88d4200088bd00ac$$ENDHEX$$"
			messagebox("Nofity" , "$$HEX6$$55d678c7200058d538c194c6$$ENDHEX$$")
			sle_item_code.text = ''	
			sle_item_code.setfocus()
			return -1				
		end if 
		if LVF_UNIT_PRICE = 0 then 
			st_status.text = "$$HEX8$$e8b200ac20004cc518c22000c6c54cc7$$ENDHEX$$"
		end if 
end if 

sle_qty.setfocus()
end event

type st_2 from so_statictext within w_mat_other_issue_barcode_return_master
integer x = 1088
integer y = 864
integer width = 274
integer height = 68
boolean bringtotop = true
long textcolor = 16711680
long backcolor = 16777215
string text = "Item Code"
alignment alignment = right!
end type

type sle_invoice_no from so_singlelineedit within w_mat_other_issue_barcode_return_master
integer x = 2071
integer y = 416
integer height = 88
boolean bringtotop = true
long backcolor = 16777215
end type

type sle_material_mfs from so_singlelineedit within w_mat_other_issue_barcode_return_master
integer x = 2587
integer y = 416
integer height = 88
boolean bringtotop = true
long backcolor = 16777215
end type

type st_5 from so_statictext within w_mat_other_issue_barcode_return_master
integer x = 2071
integer y = 340
integer height = 72
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
string text = "Invoice No"
end type

type st_6 from so_statictext within w_mat_other_issue_barcode_return_master
integer x = 2587
integer y = 340
integer height = 72
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
string text = "Material MFS"
end type

type st_7 from so_statictext within w_mat_other_issue_barcode_return_master
integer x = 1088
integer y = 756
integer width = 274
integer height = 64
boolean bringtotop = true
long textcolor = 16711680
long backcolor = 16777215
string text = "Line Code"
alignment alignment = right!
end type

type rb_repair from so_radiobutton within w_mat_other_issue_barcode_return_master
integer x = 82
integer y = 692
integer width = 517
boolean bringtotop = true
integer textsize = -10
long backcolor = 16777215
string text = "Repair Return"
end type

event clicked;call super::clicked;st_status.text = "$$HEX7$$18c2acb97cb7a8bc20001cbc89d5$$ENDHEX$$"
sle_item_code.setfocus()
cbx_bad_yn.checked = false
cbx_wait_reball.checked = false
end event

type rb_reball from so_radiobutton within w_mat_other_issue_barcode_return_master
integer x = 82
integer y = 844
integer width = 517
boolean bringtotop = true
integer textsize = -10
long backcolor = 16777215
string text = "Reball Return"
end type

event clicked;call super::clicked;sle_item_code.setfocus()
st_status.text = "$$HEX14$$acb9fcbc7cb7a8bc20001cbc89d5200018bc85c760d520007cb778c7$$ENDHEX$$/$$HEX10$$c5c5b4cc7cb9200020c1ddd0200058d538c194c6$$ENDHEX$$"
cbx_bad_yn.checked = false
cbx_wait_reball.checked = false
cbx_bulk.checked = false 
sle_line_code.text = ''
sle_line_code.setfocus()
end event

type cbx_auto_print from so_checkbox within w_mat_other_issue_barcode_return_master
integer x = 3195
integer y = 320
integer width = 631
integer height = 92
boolean bringtotop = true
long backcolor = 16777215
string text = "Auto Print"
boolean checked = true
end type

event clicked;call super::clicked;sle_item_code.setfocus()
end event

type st_1 from so_statictext within w_mat_other_issue_barcode_return_master
integer x = 2624
integer y = 736
integer width = 393
integer height = 84
boolean bringtotop = true
long textcolor = 16711680
long backcolor = 16777215
string text = "Qty"
end type

type sle_qty from so_singlelineedit within w_mat_other_issue_barcode_return_master
integer x = 2619
integer y = 844
integer width = 393
integer height = 108
integer taborder = 20
boolean bringtotop = true
long backcolor = 16777215
end type

event modified;call super::modified;//==================================================
//  $$HEX3$$18c2c9b72000$$ENDHEX$$
//==================================================
lvs_error_check = ''
lvl_new_scan_qty = 0 
lvl_issue_qty = 0 

IF lvs_item_code = '' OR ISNULL(lvs_item_code) THEN 
	MESSAGEBOX("$$HEX2$$55d678c7$$ENDHEX$$" , "$$HEX15$$88d4a9ba200054cfdcb400ac200098c7bbba200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$")
	lvs_error_check = 'ERROR'
	RETURN 
END IF 
lvl_issue_qty = long(this.text)
lvl_new_scan_qty = long(sle_scan_qty.text)

if lvl_issue_qty <=0 then 
		f_play_sound("scanfailed.wav")		
		st_status.text = "$$HEX15$$9ccde0ac18c2c9b774c720002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$"	
		sle_item_code.setfocus()
		sle_item_code.selecttext( 1,100)	
		sle_qty.text = ''
//		cbx_force_return.checked = false
			lvs_error_check = 'ERROR'
		return
end if 
	
lvdb_receipt_lot_no = F_GET_SEQUENCE('SEQ_MATERIAL_BARCODE')

if sle_return_invoice_no.text = '' or  isnull(sle_return_invoice_no.text) then 
	lvs_slip_no =string( lvdb_receipt_lot_no )
else
	lvs_slip_no =  sle_return_invoice_no.text
end if 
		
//================================================
//$$HEX47$$88bdc9b7200074c770ac98b02000acb9fcbc00b330ae200088d4200074c774ba20006fb8b8d27cb920006cad84bd58d5c0c920004ac5e0ac200014bc54cfdcb420007cb7a8bc44c72000ddc031c1200058d5c0c9c4b320004ac54cc72000$$ENDHEX$$
//================================================
if cbx_bad_yn.checked = true or cbx_wait_reball.checked = true then 
	
	cbx_auto_print.checked = false
	LVS_OUR_BARCODE = lvs_item_code+"-"+ STRING(F_T_SYSDATE(),'YYMMDD')+STRING(lvdb_receipt_lot_no,'00000')+"-"+string(lvl_issue_qty)
	lvs_lot_no  =  lvs_item_code
	
else		
			
		//================================================
		//  $$HEX8$$7cb7a8bc44c72000ddc031c120002000$$ENDHEX$$
		//================================================
				cbx_auto_print.checked = true
				
				lvs_lot_no = STRING(F_T_SYSDATE(),'YYMMDD')+STRING(lvdb_receipt_lot_no,'00000')
				LVS_OUR_BARCODE = lvs_item_code+"-"+lvs_lot_no+"-"+string(lvl_issue_qty)

					//==================================================
					
				 SELECT count(*)
					INTO :lvi_count
					FROM IM_ITEM_RECEIPT_BARCODE
					WHERE ITEM_BARCODE     = :LVS_OUR_BARCODE
						AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
					
					IF F_SQL_CHECK() < 0 THEN 
							sle_item_code.setfocus( )
							this.text = ''
							sle_item_code.text = ''	
			//				cbx_force_return.checked = false
							lvs_error_check = 'ERROR'
							RETURN 
					END IF
					//===================================================
					//
					//===================================================
						
					if lvi_count > 0   then
							
						f_play_sound("eixst.wav")
						st_status.text = '$$HEX21$$74c7f8bb200074c8acc758d594b2200014bc54cfdcb42000acc7ddc031c1200088bd00ac69d5c8b2e4b2$$ENDHEX$$'
						sle_item_code.setfocus( )
						sle_item_code.text = ''
				//		cbx_force_return.checked = false
						lvs_error_check = 'ERROR'
						return

					end if 
	
					//==================================================
					//
					//==================================================
						lvl_row = 0 
						LVL_ROW = DW_2.INSERTROW(1)
						DW_2.SCROLLTOROW(LVL_ROW)
						F_SET_SECURITY_ROW(DW_2 , LVL_ROW ,'ALL')
					
						dw_2.object.scan_date[LVL_ROW]            = f_t_sysdate()
						dw_2.object.item_code[LVL_ROW]            = lvs_item_code //$$HEX5$$fcd3a9ba54cfdcb42000$$ENDHEX$$
						dw_2.object.lot_no[LVL_ROW]                  = lvs_lot_no  //$$HEX5$$6fb8b8d288bc38d62000$$ENDHEX$$
						
						dw_2.object.receipt_slip_no[LVL_ROW]     = lvs_slip_no //$$HEX6$$85c7e0ac200020c715d62000$$ENDHEX$$+ $$HEX3$$6fb8b8d22000$$ENDHEX$$
						dw_2.object.receipt_compare_yn[lvl_row]  = 'Y' //$$HEX4$$44be50ad44c6ccb8$$ENDHEX$$
						dw_2.object.barcode_status[lvl_row]         = 'N'	
						
						dw_2.object.issue_compare_yn[lvl_row]  = 'N' //$$HEX5$$44be50ad44c6ccb82000$$ENDHEX$$
						dw_2.object.issue_return_yn[lvl_row]      = 'Y' 
						dw_2.object.issue_return_date[lvl_row]      = f_sysdate()
						
						dw_2.object.scan_qty[LVL_ROW]              = lvl_issue_qty
						dw_2.object.item_barcode[LVL_ROW]       = lvs_item_code+"-"+lvs_lot_no+"-"+string(lvl_issue_qty)// $$HEX9$$5ccd85c814bc54cfdcb42000090009000900$$ENDHEX$$
						
						dw_2.object.receipt_type[lvl_row]             = 'R' //$$HEX14$$18bc88d4d0c5200058c7d0c52000ddc034ae200070b374c730d12000$$ENDHEX$$
						dw_2.object.supplier_code[LVL_ROW]       = lvs_line_code
						dw_2.object.label_type[lvl_row]                = lvs_label_type
						dw_2.object.supplier_barcode[lvl_row]      = lvs_item_barcode
						dw_2.object.supplier_item_code[lvl_row]   = lvs_item_code
						
						dw_2.object.line_code[lvl_row]             = lvs_line_code
						dw_2.object.workstage_code[lvl_row]   = '*'
						dw_2.object.origin_item_barcode[LVL_ROW]       = lvs_item_code+"-"+lvs_lot_no+"-"+string(lvl_issue_qty)// $$HEX6$$5ccd85c814bc54cfdcb42000$$ENDHEX$$
 end if 
//====================================================
// $$HEX6$$9ccde0ac200018bc88d42000$$ENDHEX$$
//====================================================
		//		SELECT SUPPLIER_CODE INTO :LVS_supplier_code


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
								F_GET_MAX_SUPPLIER_BY_ITEM(  :lvs_item_code  , :gvi_organization_id )  ,      //SUPPLIER_CODE,   
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
							sle_item_code.text=''
							sle_qty.text = ''
							
							sle_item_code.setfocus()
							lvs_error_check = 'ERROR'
							return
						end if
						
//						
//	INSERT INTO IM_ITEM_ISSUE_LOSS
//	                   ( ISSUE_DATE , ISSUE_SEQUENCE , ITEM_CODE , MATERIAL_MFS  , MODEL_NAME , LINE_CODE , ISSUE_QTY , ENTER_DATE , ENTER_BY ,
//	                     LAST_MODIFY_DATE , LAST_MODIFY_BY , ORGANIZATION_ID ) 
//	VALUES ( SYSDATE , 
//	              SEQ_MAT_ISSUE.NEXTVAL ,  
//			     :lvs_item_code , 
//				 :lvs_lot_no , 
//	              :LVS_MODEL_NAME ,
//				 :LVS_LINE_CODE ,
//				 :lvl_issue_qty - :lvl_new_scan_qty , 
//				 SYSDATE , 
//			     :GVS_USER_ID ,  
//				  SYSDATE ,
//				 :GVS_USER_ID  , 
//				 :GVI_ORGANIZATION_ID 
//			    ) ;
//
//	 if  f_sql_check() < 0 then
//		st_status.text = '$$HEX25$$10cde0ac200018bc88d420005cb8a4c2200098ccacb9200011c9200024c658b900ac20001cbcddc0200088d5b5c2c8b2e4b2$$ENDHEX$$'
//		sle_item_code.text=''
//		sle_qty.text = ''
//		
//		sle_item_code.setfocus()
//		lvs_error_check = 'ERROR'
//		return
//	end if						

						
//==================================================================
	
		IF  dw_2.UPDATE() < 0   THEN
				ROLLBACK;
				sle_item_code.TEXT = ''
				sle_qty.text = ''
		//		cbx_force_return.checked = false
				sle_item_code.SETFOCus( )
				st_status.text = '$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$'
				f_play_sound("scanfailed.wav")
				
				RETURN					
		ELSE
		
				COMMIT;
				f_play_sound("kittingok.wav")
				st_status.text = '$$HEX11$$15c8c1c0200098ccacb9200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$'
				sle_item_code.text = ''
				sle_qty.text = ''
				sle_item_code.setfocus( )
		
		END IF 
		//=============================================================
		// $$HEX4$$04d5b0b9b8d22000$$ENDHEX$$
		//=============================================================
		if cbx_auto_print.checked = true then 

			
			dw_3.retrieve( lvs_item_code,   lvs_slip_no  ,  lvs_lot_no  , gvi_organization_id )
		
			if dw_3.rowcount() > 0 then 	
					dw_3.print( )
			else
					st_status.text = '$$HEX32$$90c7ccb894b2200015c8c1c098ccacb9200018b4c8c5e0ac20009ccd25b8d0c52000e4c228d3200088d5b5c2c8b2e4b22000acc71cbc89d5200058d538c194c6$$ENDHEX$$'
					f_msgbox(117)
					sle_item_code.text = ''
					sle_line_code.text = ''
					sle_qty.text = ''
					sle_item_code.setfocus()
					lvs_error_check = 'ERROR'
					return
			end if 
		
		end if 
		st_status.text = 'OK'
		sle_item_code.text = ''
//		sle_line_code.text = ''
		sle_qty.text = ''
		sle_item_code.SETFOCUS()

//=============================================================
//
//=============================================================
end event

type sle_line_code from so_singlelineedit within w_mat_other_issue_barcode_return_master
integer x = 1371
integer y = 732
integer width = 411
integer height = 88
integer taborder = 30
boolean bringtotop = true
long backcolor = 16777215
end type

type cbx_force_return from so_checkbox within w_mat_other_issue_barcode_return_master
integer x = 3195
integer y = 392
integer width = 631
integer height = 84
boolean bringtotop = true
long textcolor = 255
long backcolor = 16777215
string text = "Force Return"
end type

type ddlb_line_code from uo_line_code within w_mat_other_issue_barcode_return_master
integer x = 1792
integer y = 736
integer width = 818
integer height = 2044
integer taborder = 40
boolean bringtotop = true
long backcolor = 16777215
boolean sorted = true
boolean hscrollbar = false
end type

event selectionchanged;call super::selectionchanged;sle_line_code.text = this.getcode( )

end event

type dw_6 from so_datawindow within w_mat_other_issue_barcode_return_master
integer x = 3465
integer y = 580
integer width = 1394
integer height = 432
boolean bringtotop = true
boolean titlebar = true
string title = ""
string dataobject = "d_mat_batch_return_excel_lst"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
borderstyle borderstyle = stylebox!
end type

type pb_paste from so_commandbutton within w_mat_other_issue_barcode_return_master
integer x = 3854
integer y = 368
integer width = 407
integer height = 96
boolean bringtotop = true
string text = "Excel Paste"
end type

event clicked;call super::clicked;dw_6.reset()
dw_6.importclipboard( )
STRING lvs_item_code_CHECK
long lvl_return_qty
int i
do
	i++
	lvs_item_code_CHECK = upper(dw_6.object.item_code[i])
	lvl_return_qty = long(dw_6.object.return_qty[i])
	
		if lvl_return_qty <= 0 then 
				Messagebox("$$HEX2$$55d678c7$$ENDHEX$$" , "$$HEX13$$18c2c9b774c720002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$")
				st_status.text =f_msg_st(9041)+" "+lvs_item_code_CHECK
				sle_item_code.setfocus()
				sle_item_code.selecttext( 1,100)	
				return -1
			end if 
	
	
			if f_check_item_exists( lvs_item_code_CHECK , f_t_sysdate())  <= 0 then 
				f_play_sound("$$HEX5$$88d4a9baf8bbf1b45db8$$ENDHEX$$.wav")	
				f_msgbox(9041) //$$HEX10$$fcd3a9bac8b9a4c230d12000f8bbf1b45db82000$$ENDHEX$$
				st_status.text =f_msg_st(9041)+" "+lvs_item_code_CHECK
				sle_item_code.setfocus()
				sle_item_code.selecttext( 1,100)	
				return -1
			end if 
loop until i = dw_6.rowcount()
end event

type pb_return from so_commandbutton within w_mat_other_issue_barcode_return_master
integer x = 3854
integer y = 464
integer width = 407
integer height = 96
boolean bringtotop = true
string text = "Batch Return"
end type

event clicked;call super::clicked;int i




IF rb_repair.checked = true or rb_reball.checked = true then 
else
	messagebox("$$HEX2$$55d678c7$$ENDHEX$$" , "$$HEX3$$18c2acb92000$$ENDHEX$$/ $$HEX16$$acb9fcbc2000ccb9200098ccacb9200060d518c2200088c7b5c2c8b2e4b22000$$ENDHEX$$")
	return 
end if 
i = 0

if dw_6.getrow() < 1 then 
	return 
end if 

do
	i++
	sle_return_invoice_no.text = dw_6.object.return_invoice_no[i]
	sle_item_code.text = upper(dw_6.object.item_code[i])
	sle_item_code.triggerevent( modified!)
	
	if lvs_error_check = 'ERROR' then 
		exit
	end if 
	
	sle_qty.text = string( dw_6.object.return_qty[i] )
	sle_qty.triggerevent( modified!)
	
	if lvs_error_check = 'ERROR' then 
		exit
	end if 	
loop until i = dw_6.rowcount()

dw_6.reset()
end event

type sle_return_invoice_no from so_singlelineedit within w_mat_other_issue_barcode_return_master
integer x = 2615
integer y = 632
integer width = 384
integer height = 88
boolean bringtotop = true
long backcolor = 16777215
end type

type st_9 from so_statictext within w_mat_other_issue_barcode_return_master
integer x = 2249
integer y = 644
integer width = 297
integer height = 76
boolean bringtotop = true
long textcolor = 16711680
long backcolor = 16777215
string text = "Invoice"
end type

type cbx_bad_yn from so_checkbox within w_mat_other_issue_barcode_return_master
integer x = 663
integer y = 624
integer width = 398
boolean bringtotop = true
integer textsize = -10
long backcolor = 16777215
string text = "Bad"
end type

event clicked;call super::clicked;cbx_bulk.checked = false 
cbx_wait_reball.checked = false 
end event

type cbx_wait_reball from so_checkbox within w_mat_other_issue_barcode_return_master
integer x = 663
integer y = 876
integer width = 398
boolean bringtotop = true
integer textsize = -10
long backcolor = 16777215
string text = "Wait Reball"
end type

event clicked;call super::clicked;cbx_bad_yn.checked = false
cbx_bulk.checked = false
end event

type ddlb_line_code_cond from uo_line_code within w_mat_other_issue_barcode_return_master
integer x = 923
integer y = 412
integer width = 576
integer height = 2044
integer taborder = 40
boolean bringtotop = true
long backcolor = 16777215
boolean sorted = true
boolean hscrollbar = false
end type

event selectionchanged;call super::selectionchanged;sle_line_code.text = this.getcode( )

end event

type st_8 from so_statictext within w_mat_other_issue_barcode_return_master
integer x = 923
integer y = 324
integer width = 576
integer height = 72
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
string text = "Line Code"
end type

type cbx_check_price from so_checkbox within w_mat_other_issue_barcode_return_master
integer x = 1385
integer y = 648
integer width = 553
integer height = 64
boolean bringtotop = true
long textcolor = 255
long backcolor = 16777215
string text = "Check Price"
end type

type em_check_price from so_editmask within w_mat_other_issue_barcode_return_master
integer x = 1792
integer y = 640
integer width = 434
integer taborder = 30
boolean bringtotop = true
long backcolor = 16777215
string text = "1000"
string mask = "###,##0"
boolean spin = true
double increment = 1
end type

type cbx_auto_qty from so_checkbox within w_mat_other_issue_barcode_return_master
integer x = 3200
integer y = 472
integer width = 389
integer height = 64
boolean bringtotop = true
long textcolor = 255
long backcolor = 16777215
string text = "Auto Qty"
end type

type pb_cancel from so_commandbutton within w_mat_other_issue_barcode_return_master
integer x = 3858
integer y = 272
integer width = 402
integer height = 96
integer taborder = 60
boolean bringtotop = true
string text = "Cancel"
end type

event clicked;call super::clicked;open(w_mat_issue_return_cancel_4_barcode_popup)
end event

type cbx_bulk from so_checkbox within w_mat_other_issue_barcode_return_master
integer x = 663
integer y = 752
integer width = 398
boolean bringtotop = true
integer textsize = -10
long backcolor = 16777215
string text = "Bulk"
end type

event clicked;call super::clicked;cbx_bad_yn.checked = false
cbx_wait_reball.checked = false

end event

type sle_scan_qty from so_singlelineedit within w_mat_other_issue_barcode_return_master
integer x = 3031
integer y = 844
integer width = 393
integer height = 108
integer taborder = 30
boolean bringtotop = true
long backcolor = 16777215
end type

type st_10 from so_statictext within w_mat_other_issue_barcode_return_master
integer x = 3035
integer y = 736
integer width = 393
integer height = 84
boolean bringtotop = true
long textcolor = 16711680
long backcolor = 16777215
string text = "Scan Qty"
end type

type gb_2 from so_groupbox within w_mat_other_issue_barcode_return_master
integer x = 23
integer y = 564
integer width = 617
integer height = 440
integer weight = 700
long textcolor = 8421504
long backcolor = 16777215
string text = "Category"
end type

type gb_4 from so_groupbox within w_mat_other_issue_barcode_return_master
integer x = 1083
integer y = 568
integer width = 2368
integer height = 440
integer weight = 700
long textcolor = 8421504
long backcolor = 16777215
string text = "Scan Issue Return"
end type

type gb_1 from so_groupbox within w_mat_other_issue_barcode_return_master
integer x = 23
integer y = 256
integer width = 3113
integer height = 300
integer weight = 700
long textcolor = 8421504
long backcolor = 16777215
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_mat_other_issue_barcode_return_master
integer x = 3159
integer y = 260
integer width = 681
integer height = 300
integer weight = 700
long textcolor = 8421504
long backcolor = 16777215
string text = "Process"
end type

type gb_5 from so_groupbox within w_mat_other_issue_barcode_return_master
integer x = 645
integer y = 564
integer width = 425
integer height = 440
integer taborder = 40
long backcolor = 16777215
end type

