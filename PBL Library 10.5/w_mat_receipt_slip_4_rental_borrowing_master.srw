HA$PBExportHeader$w_mat_receipt_slip_4_rental_borrowing_master.srw
$PBExportComments$Material Mass Issue Return Master
forward
global type w_mat_receipt_slip_4_rental_borrowing_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mat_receipt_slip_4_rental_borrowing_master
end type
type uo_dateend from uo_ymd_calendar within w_mat_receipt_slip_4_rental_borrowing_master
end type
type ddlb_item_code from uo_item_code within w_mat_receipt_slip_4_rental_borrowing_master
end type
type st_3 from so_statictext within w_mat_receipt_slip_4_rental_borrowing_master
end type
type st_4 from so_statictext within w_mat_receipt_slip_4_rental_borrowing_master
end type
type st_1 from so_statictext within w_mat_receipt_slip_4_rental_borrowing_master
end type
type st_status from so_statictext within w_mat_receipt_slip_4_rental_borrowing_master
end type
type sle_item_barcode from so_singlelineedit within w_mat_receipt_slip_4_rental_borrowing_master
end type
type sle_slip_no from so_singlelineedit within w_mat_receipt_slip_4_rental_borrowing_master
end type
type st_2 from so_statictext within w_mat_receipt_slip_4_rental_borrowing_master
end type
type sle_reel_qty from so_singlelineedit within w_mat_receipt_slip_4_rental_borrowing_master
end type
type sle_total_qty from so_singlelineedit within w_mat_receipt_slip_4_rental_borrowing_master
end type
type sle_unit_qty from so_singlelineedit within w_mat_receipt_slip_4_rental_borrowing_master
end type
type st_6 from so_statictext within w_mat_receipt_slip_4_rental_borrowing_master
end type
type st_7 from so_statictext within w_mat_receipt_slip_4_rental_borrowing_master
end type
type st_8 from so_statictext within w_mat_receipt_slip_4_rental_borrowing_master
end type
type cbx_auto_print from so_checkbox within w_mat_receipt_slip_4_rental_borrowing_master
end type
type sle_slip_no_condition from so_singlelineedit within w_mat_receipt_slip_4_rental_borrowing_master
end type
type st_9 from so_statictext within w_mat_receipt_slip_4_rental_borrowing_master
end type
type pb_1 from so_commandbutton within w_mat_receipt_slip_4_rental_borrowing_master
end type
type rb_rental from so_radiobutton within w_mat_receipt_slip_4_rental_borrowing_master
end type
type rb_borrowing from so_radiobutton within w_mat_receipt_slip_4_rental_borrowing_master
end type
type ddlb_supplier_code from uo_customer_supplier_code_name within w_mat_receipt_slip_4_rental_borrowing_master
end type
type st_5 from so_statictext within w_mat_receipt_slip_4_rental_borrowing_master
end type
type ddlb_from_supplier_code from uo_customer_supplier_code_name within w_mat_receipt_slip_4_rental_borrowing_master
end type
type st_10 from so_statictext within w_mat_receipt_slip_4_rental_borrowing_master
end type
type ddlb_receipt_type from uo_basecode within w_mat_receipt_slip_4_rental_borrowing_master
end type
type st_11 from so_statictext within w_mat_receipt_slip_4_rental_borrowing_master
end type
type cbx_return_real from so_checkbox within w_mat_receipt_slip_4_rental_borrowing_master
end type
type ddlb_barcode_status from uo_basecode within w_mat_receipt_slip_4_rental_borrowing_master
end type
type st_13 from so_statictext within w_mat_receipt_slip_4_rental_borrowing_master
end type
type cbx_reball_yn from so_checkbox within w_mat_receipt_slip_4_rental_borrowing_master
end type
type cbx_msl from so_checkbox within w_mat_receipt_slip_4_rental_borrowing_master
end type
type gb_2 from so_groupbox within w_mat_receipt_slip_4_rental_borrowing_master
end type
type gb_1 from so_groupbox within w_mat_receipt_slip_4_rental_borrowing_master
end type
type gb_3 from so_groupbox within w_mat_receipt_slip_4_rental_borrowing_master
end type
type gb_4 from so_groupbox within w_mat_receipt_slip_4_rental_borrowing_master
end type
type gb_5 from so_groupbox within w_mat_receipt_slip_4_rental_borrowing_master
end type
end forward

global type w_mat_receipt_slip_4_rental_borrowing_master from w_main_root
integer width = 5303
integer height = 3100
string title = "Material Slip Rental Borrowing Master"
uo_dateset uo_dateset
uo_dateend uo_dateend
ddlb_item_code ddlb_item_code
st_3 st_3
st_4 st_4
st_1 st_1
st_status st_status
sle_item_barcode sle_item_barcode
sle_slip_no sle_slip_no
st_2 st_2
sle_reel_qty sle_reel_qty
sle_total_qty sle_total_qty
sle_unit_qty sle_unit_qty
st_6 st_6
st_7 st_7
st_8 st_8
cbx_auto_print cbx_auto_print
sle_slip_no_condition sle_slip_no_condition
st_9 st_9
pb_1 pb_1
rb_rental rb_rental
rb_borrowing rb_borrowing
ddlb_supplier_code ddlb_supplier_code
st_5 st_5
ddlb_from_supplier_code ddlb_from_supplier_code
st_10 st_10
ddlb_receipt_type ddlb_receipt_type
st_11 st_11
cbx_return_real cbx_return_real
ddlb_barcode_status ddlb_barcode_status
st_13 st_13
cbx_reball_yn cbx_reball_yn
cbx_msl cbx_msl
gb_2 gb_2
gb_1 gb_1
gb_3 gb_3
gb_4 gb_4
gb_5 gb_5
end type
global w_mat_receipt_slip_4_rental_borrowing_master w_mat_receipt_slip_4_rental_borrowing_master

type variables
string lvs_item_code   , lvs_slip_no  , lvs_supplier_code , lvs_itemcode_me
long lvl_row
datetime lvdt_receipt_date
string lvs_receipt_lot_no , lvs_receipt_type  , lvs_label_type
double LVDB_SLIP_RCV_SEQ  , lvdb_receipt_lot_no


end variables

forward prototypes
public subroutine wf_reset_column ()
end prototypes

public subroutine wf_reset_column ();sle_item_barcode.text = ''

end subroutine

on w_mat_receipt_slip_4_rental_borrowing_master.create
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
this.sle_slip_no=create sle_slip_no
this.st_2=create st_2
this.sle_reel_qty=create sle_reel_qty
this.sle_total_qty=create sle_total_qty
this.sle_unit_qty=create sle_unit_qty
this.st_6=create st_6
this.st_7=create st_7
this.st_8=create st_8
this.cbx_auto_print=create cbx_auto_print
this.sle_slip_no_condition=create sle_slip_no_condition
this.st_9=create st_9
this.pb_1=create pb_1
this.rb_rental=create rb_rental
this.rb_borrowing=create rb_borrowing
this.ddlb_supplier_code=create ddlb_supplier_code
this.st_5=create st_5
this.ddlb_from_supplier_code=create ddlb_from_supplier_code
this.st_10=create st_10
this.ddlb_receipt_type=create ddlb_receipt_type
this.st_11=create st_11
this.cbx_return_real=create cbx_return_real
this.ddlb_barcode_status=create ddlb_barcode_status
this.st_13=create st_13
this.cbx_reball_yn=create cbx_reball_yn
this.cbx_msl=create cbx_msl
this.gb_2=create gb_2
this.gb_1=create gb_1
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_5=create gb_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.ddlb_item_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.st_status
this.Control[iCurrent+8]=this.sle_item_barcode
this.Control[iCurrent+9]=this.sle_slip_no
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.sle_reel_qty
this.Control[iCurrent+12]=this.sle_total_qty
this.Control[iCurrent+13]=this.sle_unit_qty
this.Control[iCurrent+14]=this.st_6
this.Control[iCurrent+15]=this.st_7
this.Control[iCurrent+16]=this.st_8
this.Control[iCurrent+17]=this.cbx_auto_print
this.Control[iCurrent+18]=this.sle_slip_no_condition
this.Control[iCurrent+19]=this.st_9
this.Control[iCurrent+20]=this.pb_1
this.Control[iCurrent+21]=this.rb_rental
this.Control[iCurrent+22]=this.rb_borrowing
this.Control[iCurrent+23]=this.ddlb_supplier_code
this.Control[iCurrent+24]=this.st_5
this.Control[iCurrent+25]=this.ddlb_from_supplier_code
this.Control[iCurrent+26]=this.st_10
this.Control[iCurrent+27]=this.ddlb_receipt_type
this.Control[iCurrent+28]=this.st_11
this.Control[iCurrent+29]=this.cbx_return_real
this.Control[iCurrent+30]=this.ddlb_barcode_status
this.Control[iCurrent+31]=this.st_13
this.Control[iCurrent+32]=this.cbx_reball_yn
this.Control[iCurrent+33]=this.cbx_msl
this.Control[iCurrent+34]=this.gb_2
this.Control[iCurrent+35]=this.gb_1
this.Control[iCurrent+36]=this.gb_3
this.Control[iCurrent+37]=this.gb_4
this.Control[iCurrent+38]=this.gb_5
end on

on w_mat_receipt_slip_4_rental_borrowing_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.ddlb_item_code)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_1)
destroy(this.st_status)
destroy(this.sle_item_barcode)
destroy(this.sle_slip_no)
destroy(this.st_2)
destroy(this.sle_reel_qty)
destroy(this.sle_total_qty)
destroy(this.sle_unit_qty)
destroy(this.st_6)
destroy(this.st_7)
destroy(this.st_8)
destroy(this.cbx_auto_print)
destroy(this.sle_slip_no_condition)
destroy(this.st_9)
destroy(this.pb_1)
destroy(this.rb_rental)
destroy(this.rb_borrowing)
destroy(this.ddlb_supplier_code)
destroy(this.st_5)
destroy(this.ddlb_from_supplier_code)
destroy(this.st_10)
destroy(this.ddlb_receipt_type)
destroy(this.st_11)
destroy(this.cbx_return_real)
destroy(this.ddlb_barcode_status)
destroy(this.st_13)
destroy(this.cbx_reball_yn)
destroy(this.cbx_msl)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.gb_3)
destroy(this.gb_4)
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

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
sle_slip_no.setfocus()
st_status.text = 'Ready.'
st_status.width = dw_1.width + dw_2.width

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
end event

event ue_data_control;call super::ue_data_control;
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
			dw_1.reset()
			dw_1.retrieve( uo_dateset.text() , uo_dateend.text(),    ddlb_item_code.text() + '%',  sle_slip_no_condition.text+'%' , ddlb_receipt_type.getcode()+'%' ,  ddlb_barcode_status.GETCODE()+'%' , gvi_organization_id)
			
			sle_item_barcode.text = ''
			sle_item_barcode.setfocus()
			st_status.text = 'Waitting'
	 
     case 'INSERT'
		
					LVL_ROW = DW_1.INSERTROW(1)
					DW_1.SCROLLTOROW(LVL_ROW)
					F_SET_SECURITY_ROW(DW_1 , LVL_ROW ,'ALL')
	
	case 'UPDATE'
		
			IF dw_1.UPDATE() < 0  OR dw_2.UPDATE() < 0    THEN
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

type dw_5 from w_main_root`dw_5 within w_mat_receipt_slip_4_rental_borrowing_master
integer y = 996
integer width = 2267
integer height = 752
integer taborder = 0
string title = "Msl Label"
string dataobject = "d_mat_receipt_lot_barcode_msl_rpt"
end type

type dw_4 from w_main_root`dw_4 within w_mat_receipt_slip_4_rental_borrowing_master
integer y = 996
integer width = 2267
integer height = 752
integer taborder = 0
end type

type dw_3 from w_main_root`dw_3 within w_mat_receipt_slip_4_rental_borrowing_master
integer y = 996
integer width = 2267
integer height = 1428
integer taborder = 0
boolean titlebar = true
string dataobject = "d_mat_receipt_lot_barcode_rpt"
end type

type dw_2 from w_main_root`dw_2 within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 2277
integer y = 996
integer width = 2267
integer height = 1428
integer taborder = 0
boolean titlebar = true
string title = "Receipt Slip Barcode List"
string dataobject = "d_mat_rceipt_barcode_4_slip_lst"
borderstyle borderstyle = styleraised!
end type

event dw_2::buttonclicked;call super::buttonclicked;String lvs_itemcode, lvs_msl_level

if dwo.name = 'b_print' then 
	 lvs_itemcode = this.object.item_code[row]
     dw_3.retrieve( this.object.item_code[row] , this.object.receipt_slip_no[row] , this.object.lot_no[row] , gvi_organization_id )
	  
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
						 dw_5.retrieve( this.object.item_code[row] , this.object.receipt_slip_no[row] , this.object.lot_no[row] , gvi_organization_id )
						 if dw_5.rowcount() > 0 then 	
							dw_5.print( )
						 end if
					  End if	
				  END IF 		
			End if
	else
		f_msgbox(117)
	end if 


end if 
end event

type dw_1 from w_main_root`dw_1 within w_mat_receipt_slip_4_rental_borrowing_master
integer y = 996
integer width = 2267
integer height = 1428
integer taborder = 0
boolean titlebar = true
string title = "Receipt Slip List"
string dataobject = "d_mat_receipt_slip_4_rent_bowring_lst"
end type

event dw_1::clicked;call super::clicked;sle_item_barcode.setfocus()
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
dw_2.retrieve( this.object.item_code[currentrow] , this.object.receipt_slip_no[currentrow] , gvi_organization_id)

end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_receipt_slip_4_rental_borrowing_master
integer taborder = 0
end type

type uo_dateset from uo_ymd_calendar within w_mat_receipt_slip_4_rental_borrowing_master
event destroy ( )
integer x = 41
integer y = 160
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_receipt_slip_4_rental_borrowing_master
event destroy ( )
integer x = 457
integer y = 160
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_item_code from uo_item_code within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 873
integer y = 156
integer width = 530
integer height = 676
integer taborder = 0
boolean bringtotop = true
end type

event selectionchanged;call super::selectionchanged;sle_item_barcode.setfocus()
end event

type st_3 from so_statictext within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 873
integer y = 76
integer width = 530
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type st_4 from so_statictext within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 46
integer y = 80
integer width = 814
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Receipt Date"
end type

type st_1 from so_statictext within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 1440
integer y = 668
integer width = 425
integer height = 68
boolean bringtotop = true
long textcolor = 16711680
string text = "Barcode"
alignment alignment = right!
end type

event clicked;call super::clicked;sle_item_barcode.setfocus()
end event

type st_status from so_statictext within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 9
integer y = 792
integer width = 4530
integer height = 184
boolean bringtotop = true
integer textsize = -26
integer weight = 700
long textcolor = 33327873
long backcolor = 24510463
string text = "Message"
end type

event clicked;call super::clicked;sle_item_barcode.setfocus()
end event

type sle_item_barcode from so_singlelineedit within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 1897
integer y = 652
integer width = 1143
integer height = 88
integer taborder = 10
boolean bringtotop = true
textcase textcase = upper!
end type

event modified;call super::modified;if ddlb_supplier_code.getcode() = '' or ddlb_supplier_code.getcode() = '*' or ddlb_supplier_code.getcode() = '%' then 
	
	st_status.text = F_MSG(  "$$HEX11$$70ac98b798cc7cb9200020c1ddd0200058d538c194c6$$ENDHEX$$." , 'S')
	f_play_sound("$$HEX9$$70ac98b798cc7cb920c1ddd058d538c194c6$$ENDHEX$$.wav")
	
	sle_item_barcode.text = ''	
	sle_item_barcode.setfocus()
	sle_item_barcode.selecttext( 1,100)		
	
	ddlb_supplier_code.setfocus()
	return 
end if 

if ddlb_from_supplier_code.getcode() = '' or ddlb_from_supplier_code.getcode() = '*' or ddlb_from_supplier_code.getcode() = '%' then 
	
	st_status.text =  F_MSG( "$$HEX17$$04c85cd420001cbc89d5200070ac98b798cc7cb9200020c1ddd0200058d538c194c6$$ENDHEX$$." , 'S')
	f_play_sound("$$HEX9$$70ac98b798cc7cb920c1ddd058d538c194c6$$ENDHEX$$.wav")
	
	sle_item_barcode.text = ''	
	sle_item_barcode.setfocus()
	sle_item_barcode.selecttext( 1,100)		
	
	ddlb_from_supplier_code.setfocus()
	return 
end if 

if len(this.text) < 0 or isnull(this.text) or sle_item_barcode.text ='' then
	return
	sle_item_barcode.setfocus()
end if



Long lvl_pos1
////==========================================
////LABEL $$HEX9$$6cad84bd200004c758ce20003ecc30ae2000$$ENDHEX$$
////==========================================
//lvl_pos1 = 0
//
//lvl_pos1 =  pos( this.text , "-" , 7 ) 
//
//if 	lvl_pos1 > 0 then 
//
//	if mid(this.text,1,1) = "P" then  
//		lvs_itemcode_me = mid(this.text,2,lvl_pos1 - 2) 
//	elseif mid(this.text,1,2) = "SA" then 
//		lvs_itemcode_me = mid(this.text,3,lvl_pos1 - 3) 
//	else 
//		lvs_itemcode_me = mid(this.text,1,lvl_pos1 - 1) 		
//	end if
//else
//	if mid(this.text,1,1) = "P" then  
//		lvs_itemcode_me = trim(mid(this.text,2,100) )
//	elseif mid(this.text,1,2) = "SA" then 
//		lvs_itemcode_me = trim(mid(this.text,3,100) )
//	else 
//		lvs_itemcode_me = trim(mid(this.text,1,100) )		
//	end if			
//end if 


//=======================================
// 
// $$HEX16$$14bc54cfdcb47cb9200084bd74d5200074d51cc1200088d4a9ba98ccacb92000$$ENDHEX$$
//=======================================
			lvs_itemcode_me = this.text 
			SELECT  f_get_item_code_from_barcode (:lvs_itemcode_me)
				 INTO :lvs_itemcode_me 
				FROM DUAL ; 
		
		IF F_SQL_CHECK() < 0 THEN 
			this.text = ''	
			lvs_itemcode_me = ''
		END IF 	 
		
////===========================================
//// $$HEX10$$f5ac31bc200078c7bdacb0c620003ecc30ae2000$$ENDHEX$$
////===========================================
//lvl_pos1 =  pos( this.text , " " , 1 )  //LABEL $$HEX9$$6cad84bd200004c758ce20003ecc30ae2000$$ENDHEX$$
//
//if 	lvl_pos1 > 0 then 
//	lvs_itemcode_me = mid(this.text,1,lvl_pos1 - 1) 		
//end if 		
					
	 lvs_item_code = ''
	 int lvi_dup_count
	 
	 SELECT max(ITEM_CODE) , count(*)
		 INTO :lvs_item_code  , :lvi_dup_count 
		FROM ID_ITEM 
	 WHERE ( ITEM_CODE = SUBSTR( :lvs_itemcode_me , 1, LENGTH(ITEM_CODE)  )  OR PART_NO = :lvs_itemcode_me  )
			AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;					
	
	
	IF lvi_dup_count > 1 THEN 
		
		F_MSG( "$$HEX5$$88d4a9ba54cfdcb42000$$ENDHEX$$/ Part No $$HEX28$$00ac200011c9f5bc2000f1b45db8200018b4b4c5200088c7b5c2c8b2e4b2200088d4a9bac8b9a4c230d144c7200055d678c758d538c194c6$$ENDHEX$$" , 'P')
		sle_item_barcode.text = ''	
		sle_item_barcode.setfocus()
		sle_item_barcode.selecttext( 1,100)		
		return 
		
	END IF 
	
	IF F_SQL_CHECK() < 0 THEN 
		sle_item_barcode.text = ''	
		sle_item_barcode.setfocus()
		sle_item_barcode.selecttext( 1,100)	
		return 
	END IF 

if f_check_item_exists( lvs_item_code , f_t_sysdate())  < 1 then 
	
		f_play_sound("$$HEX6$$98c7bbba1cb414bc54cfdcb4$$ENDHEX$$.wav")		
		f_msgbox(9041)	
		sle_item_barcode.text = ''	
		sle_item_barcode.setfocus()
		sle_item_barcode.selecttext( 1,100)		
		return 
end if 
sle_reel_qty.text = ''
sle_reel_qty.setfocus()  




end event

type sle_slip_no from so_singlelineedit within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 1897
integer y = 496
integer width = 704
integer height = 88
boolean bringtotop = true
textcase textcase = upper!
end type

event getfocus;call super::getfocus;f_play_sound("$$HEX6$$acc2bdb988bc38d6a4c294ce$$ENDHEX$$.wav")
end event

event modified;call super::modified;if this.text = '' or isnull(this.text) then 
   sle_slip_no.setfocus( )
   return 
end if 

if f_check_slip_exists( this.text)  > 0 then
	st_status.text = "$$HEX21$$85c725b858d5e0c2200004c85cd4200088bc38d600ac200074c7f8bb200074c8acc7200069d5c8b2e4b2$$ENDHEX$$."
	f_play_sound( "$$HEX5$$74c7f8bb74c8acc768d5$$ENDHEX$$.wav")
	f_msgbox1(813 , this.text) 
	this.text = ''
	sle_slip_no.setfocus()
	return 
end if 

sle_item_barcode.setfocus()
end event

type st_2 from so_statictext within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 1440
integer y = 512
integer width = 425
integer height = 72
boolean bringtotop = true
long textcolor = 255
string text = "Slip No"
alignment alignment = right!
end type

event clicked;call super::clicked;sle_item_barcode.setfocus()
end event

type sle_reel_qty from so_singlelineedit within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 3049
integer y = 652
integer width = 283
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -14
long backcolor = 16777215
textcase textcase = upper!
end type

event modified;call super::modified;if  sle_item_barcode.text = '' or isnull(sle_item_barcode.text)  then 
	
	st_status.text = "$$HEX24$$14bc54cfdcb47cb92000a4c294ce200058d570ac98b0200088d4a9ba88bc38d67cb9200085c725b8200058d538c194c6$$ENDHEX$$"
	f_play_sound("$$HEX6$$98c7bbba1cb414bc54cfdcb4$$ENDHEX$$.wav")
	f_msgbox1(1175 ,sle_item_barcode.text )
	sle_reel_qty.text = ''
	sle_item_barcode.setfocus()		
	sle_item_barcode.selecttext( 1,100)
	return
else
	sle_total_qty.setfocus()
end if 	
end event

type sle_total_qty from so_singlelineedit within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 3337
integer y = 652
integer width = 302
integer height = 88
integer taborder = 30
boolean bringtotop = true
textcase textcase = upper!
end type

event getfocus;call super::getfocus;if sle_item_barcode.text = '' or  isnull(sle_item_barcode.text) then 
	sle_item_barcode.setfocus()
	st_status.text = "$$HEX24$$14bc54cfdcb47cb92000a4c294ce200058d570ac98b0200088d4a9ba88bc38d67cb9200085c725b8200058d538c194c6$$ENDHEX$$"
	return 

end if 
end event

event modified;call super::modified;long i ,  lvl_count , lvl_receipt_qty , lvl_receipt_sequence ,  lvl_totla_qty , lvl_reel_qty
String   lvs_itemcode, lvs_msl_level 


if   sle_slip_no.text = '' or isnull(sle_slip_no.text)  then 
	st_status.text = "$$HEX12$$acc2bdb988bc38d67cb9200085c725b8200058d538c194c6$$ENDHEX$$"
	f_play_sound("$$HEX6$$98c7bbba1cb414bc54cfdcb4$$ENDHEX$$.wav")
	f_msgbox1(1175 ,sle_item_barcode.text )
	sle_item_barcode.text  = ''
	sle_reel_qty.text = ''
	sle_slip_no.setfocus()		
	sle_slip_no.text = ''
	return 
end if

if   sle_item_barcode.text = '' or isnull(sle_item_barcode.text)  then 
	st_status.text = "$$HEX24$$14bc54cfdcb47cb92000a4c294ce200058d570ac98b0200088d4a9ba88bc38d67cb9200085c725b8200058d538c194c6$$ENDHEX$$"
	f_play_sound("$$HEX6$$98c7bbba1cb414bc54cfdcb4$$ENDHEX$$.wav")
	f_msgbox1(1175 ,sle_item_barcode.text )
	sle_item_barcode.text  = ''
	sle_reel_qty.text = ''
	sle_item_barcode.setfocus()		
	sle_item_barcode.text = ''
	return 
end if 	

if  Integer(sle_reel_qty.text) <= 0 then 
	st_status.text = "$$HEX12$$b4b9200018c2c9b744c7200085c725b8200058d538c194c6$$ENDHEX$$"
	f_play_sound("$$HEX6$$98c7bbba1cb414bc54cfdcb4$$ENDHEX$$.wav")
	f_msgbox1(1175 ,sle_item_barcode.text )
	sle_item_barcode.text  = ''
	sle_reel_qty.text = ''
	sle_item_barcode.setfocus()		
	sle_item_barcode.text = ''
	return 
end if 	

lvl_totla_qty = long(this.text)
lvl_reel_qty = Integer(sle_reel_qty.text)
//======================================================
// $$HEX9$$15c818c22000ecc580bd2000b4cc6cd02000$$ENDHEX$$
//======================================================
    if mod( lvl_totla_qty , lvl_reel_qty ) > 0 then 
		f_play_sound("$$HEX6$$98c7bbba1cb414bc54cfdcb4$$ENDHEX$$.wav")
		f_Msgbox(113)
		sle_total_qty.text = ''
		sle_item_barcode.text  = ''
		sle_reel_qty.text = ''		
		sle_item_barcode.setfocus()
		sle_item_barcode.text = ''
		return 
	end if 
	
	sle_unit_qty.text = string(lvl_totla_qty / lvl_reel_qty) 

//lvl_receipt_sequence =    LONG(f_get_any_no( 'SEQ_RECEIPT_SLIP') )
//lvdt_receipt_date         = f_sysdate()
//==================================================
//  $$HEX13$$acc2bdb9200015c8f4bcd0c5200074c725b820005cd5e4b22000$$ENDHEX$$
//==================================================

			f_insert()

			LVDB_SLIP_RCV_SEQ  = F_GET_SEQUENCE('SEQ_RECEIPT_SLIP')
			
			dw_1.object.receipt_date[LVL_ROW]         = f_t_sysdate()
			dw_1.object.receipt_sequence[LVL_ROW] =  LVDB_SLIP_RCV_SEQ
			dw_1.object.item_code[LVL_ROW]            = lvs_item_code
			dw_1.object.reel_qty[LVL_ROW]               = long(sle_reel_qty.text)
			dw_1.object.receipt_unit_qty[LVL_ROW]    = long(sle_unit_qty.text)
			dw_1.object.receipt_sum_qty[LVL_ROW]   = long(sle_total_qty.text)
			dw_1.object.receipt_barcode[LVL_ROW]    = sle_item_barcode.text
			dw_1.object.receipt_slip_no[LVL_ROW]     = sle_slip_no.text
			dw_1.object.receipt_status[LVL_ROW]       = 'N'
			dw_1.object.supplier_code[LVL_ROW]         = ddlb_supplier_code.getcode()
			dw_1.object.from_supplier_code[LVL_ROW] = ddlb_from_supplier_code.getcode()			
			//=================================================
			// $$HEX6$$85c7e0ac200020c715d62000$$ENDHEX$$
			//=================================================
			
			if rb_borrowing.checked = true then 
				lvs_receipt_type = 'B'
			else
				lvs_receipt_type = 'T'	
			end if 
			
			dw_1.object.receipt_type[LVL_ROW]       = lvs_receipt_type
			//=================================================
			//
			//=================================================
			dw_1.object.eco_item_yn[lvl_row] = 'N'
			
			if cbx_reball_yn.checked = true then 
				lvs_label_type  = 'R'
			else
				lvs_label_type  = 'N'
			end if 
			
//messagebox("$$HEX2$$55d678c7$$ENDHEX$$" , "$$HEX9$$1cbc89d5200060d5200018c2c9b740c72000$$ENDHEX$$"+string(lvl_reel_qty) 	)		
//==================================================
// $$HEX13$$14bc54cfdcb4200015c8f4bcd0c5200085c725b85cd5e4b22000$$ENDHEX$$
//==================================================
lvl_row = 0 

//do
	    i++
		LVL_ROW = DW_2.INSERTROW(1)
		DW_2.SCROLLTOROW(LVL_ROW)
		F_SET_SECURITY_ROW(DW_2 , LVL_ROW ,'ALL')
		
		lvdb_receipt_lot_no = F_GET_SEQUENCE('SEQ_MATERIAL_BARCODE')
		lvs_receipt_lot_no =   F_YMD_SYSDATE()+STRING(lvdb_receipt_lot_no) // STRING(F_T_SYSDATE(),'YYMMDD')+STRING(lvdb_receipt_lot_no)
		
		dw_2.object.scan_date[LVL_ROW]            =  f_sysdate()
		dw_2.object.item_code[LVL_ROW]            = lvs_item_code //$$HEX5$$fcd3a9ba54cfdcb42000$$ENDHEX$$
		dw_2.object.lot_no[LVL_ROW]                  = lvs_receipt_lot_no  //$$HEX5$$6fb8b8d288bc38d62000$$ENDHEX$$

		dw_2.object.receipt_slip_no[LVL_ROW]      = sle_slip_no.text
		dw_2.object.supplier_code[LVL_ROW]        = ddlb_supplier_code.getcode()
		dw_2.object.from_supplier_code[LVL_ROW] = ddlb_from_supplier_code.getcode()		
		
		dw_2.object.receipt_compare_yn[lvl_row] = 'N' //$$HEX5$$44be50ad44c6ccb82000$$ENDHEX$$
		dw_2.object.barcode_status[lvl_row]         = 'N' //$$HEX7$$44be50ad44c6ccb8200009000900$$ENDHEX$$

		dw_2.object.scan_qty[LVL_ROW]              = long(sle_unit_qty.text)
		dw_2.object.item_barcode[LVL_ROW]       = lvs_item_code+"-"+lvs_receipt_lot_no+"-"+sle_unit_qty.text // $$HEX9$$5ccd85c814bc54cfdcb42000090009000900$$ENDHEX$$

	     dw_2.object.receipt_type[lvl_row]             = lvs_receipt_type //$$HEX5$$85c7e0ac20c715d62000$$ENDHEX$$
		 dw_2.object.label_type[lvl_row]                = lvs_label_type
		  
		 if dw_2.update() < 0 then 
				rollback ;
				sle_reel_qty.text = ''
				sle_total_qty.text = ''
				sle_unit_qty.text = ''
				sle_item_barcode.text = ''
				sle_item_barcode.SETFOCus( )
				f_play_sound("$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav")			
				return 
		 else
			
			if cbx_auto_print.checked = true then 
					
//					//=====================================
//					//  $$HEX3$$9ccd25b82000$$ENDHEX$$
//					//=====================================
//					if (cbx_width.checked) then 
//						dw_3.dataobject = 'd_mat_receipt_lot_barcode_w_rpt' 
//						dw_3.settransobject(sqlca) 
//					else 
//						dw_3.dataobject = 'd_mat_receipt_lot_barcode_rpt' 
//						dw_3.settransobject(sqlca) 
//					end if
				
                       lvs_itemcode = dw_2.object.item_code[lvl_row]
					dw_3.retrieve( dw_2.object.item_code[lvl_row] , dw_2.object.receipt_slip_no[lvl_row]   ,  dw_2.object.lot_no[lvl_row] , gvi_organization_id )
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
										 dw_5.retrieve( dw_2.object.item_code[lvl_row] , dw_2.object.receipt_slip_no[lvl_row]   ,  dw_2.object.lot_no[lvl_row] , gvi_organization_id )
										 if dw_5.rowcount() > 0 then 	
											dw_5.print( )
										 end if
									  End if	
								  END IF 		
							End if
							
					else
						f_msgbox(117)
					end if 
			end if 	
		end if 
	   
//loop until i = lvl_reel_qty
//===================================================
//
//===================================================
IF dw_1.UPDATE() < 0   THEN
	ROLLBACK;
	sle_reel_qty.text = ''
	sle_total_qty.text = ''
	sle_unit_qty.text = ''
	sle_item_barcode.text = ''
	sle_item_barcode.SETFOCus( )
	f_play_sound("$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav")
	RETURN					
ELSE
	COMMIT;
	F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
	f_play_sound("$$HEX4$$00c8a5c731c1f5ac$$ENDHEX$$.wav")	
END IF 

st_status.text = "OK"

sle_reel_qty.text = ''
sle_total_qty.text = ''
sle_unit_qty.text = ''
sle_item_barcode.text = ''
sle_item_barcode.setfocus()


end event

type sle_unit_qty from so_singlelineedit within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 3648
integer y = 652
integer width = 279
integer height = 88
boolean bringtotop = true
long backcolor = 12632256
textcase textcase = upper!
boolean displayonly = true
end type

type st_6 from so_statictext within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 3054
integer y = 504
integer width = 283
integer height = 112
boolean bringtotop = true
long textcolor = 0
string text = "Reel Qty"
end type

type st_7 from so_statictext within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 3342
integer y = 508
integer width = 302
integer height = 112
boolean bringtotop = true
long textcolor = 0
string text = "Total Qty"
end type

type st_8 from so_statictext within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 3648
integer y = 508
integer width = 279
integer height = 112
boolean bringtotop = true
long textcolor = 0
string text = "Unit Qty"
end type

type cbx_auto_print from so_checkbox within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 3433
integer y = 68
integer width = 590
integer height = 100
boolean bringtotop = true
integer textsize = -10
string text = "Auto Print"
boolean checked = true
end type

type sle_slip_no_condition from so_singlelineedit within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 1413
integer y = 156
integer width = 608
integer height = 84
boolean bringtotop = true
end type

type st_9 from so_statictext within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 1413
integer y = 72
integer width = 608
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Slip No"
end type

type pb_1 from so_commandbutton within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 2994
integer y = 104
integer width = 416
boolean bringtotop = true
string text = "Cancel"
end type

event clicked;call super::clicked;open(w_mat_slip_cancel_popup)
sle_item_barcode.setfocus()
end event

type rb_rental from so_radiobutton within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 55
integer y = 468
integer width = 517
integer height = 100
boolean bringtotop = true
integer textsize = -10
string text = "Rental"
end type

event clicked;call super::clicked;lvs_receipt_type = 'T'
end event

type rb_borrowing from so_radiobutton within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 55
integer y = 596
integer width = 517
integer height = 100
boolean bringtotop = true
integer textsize = -10
string text = "Borrowing"
boolean checked = true
end type

event clicked;call super::clicked;lvs_receipt_type = 'B'
end event

type ddlb_supplier_code from uo_customer_supplier_code_name within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 645
integer y = 492
integer width = 695
integer height = 2248
boolean bringtotop = true
end type

event selectionchanged;call super::selectionchanged;lvs_supplier_code = this.getcode()
end event

type st_5 from so_statictext within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 649
integer y = 416
integer width = 695
integer height = 64
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Supplier Code"
end type

event clicked;call super::clicked;sle_item_barcode.setfocus()
end event

type ddlb_from_supplier_code from uo_customer_supplier_code_name within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 645
integer y = 660
integer width = 695
integer height = 2248
boolean bringtotop = true
end type

type st_10 from so_statictext within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 640
integer y = 596
integer width = 695
integer height = 48
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "From Supplier"
end type

event clicked;call super::clicked;sle_item_barcode.setfocus()
end event

type ddlb_receipt_type from uo_basecode within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 2030
integer y = 156
integer width = 448
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw('RECEIPT TYPE')
end event

type st_11 from so_statictext within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 2030
integer y = 68
integer width = 448
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Receipt Type"
end type

type cbx_return_real from so_checkbox within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 1911
integer y = 388
integer width = 453
boolean bringtotop = true
string text = "Return Original"
end type

type ddlb_barcode_status from uo_basecode within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 2487
integer y = 156
integer width = 439
integer taborder = 50
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw('RECEIPT STATUS')
this.selectitem( 3)
end event

type st_13 from so_statictext within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 2501
integer y = 72
integer width = 407
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Slip Status"
end type

type cbx_reball_yn from so_checkbox within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 2624
integer y = 492
integer width = 361
boolean bringtotop = true
string text = "Reball YN"
end type

type cbx_msl from so_checkbox within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 3433
integer y = 180
integer width = 549
integer height = 76
boolean bringtotop = true
integer textsize = -10
string text = "Msl Label Print"
end type

type gb_2 from so_groupbox within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 2958
integer width = 1326
integer height = 300
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_1 from so_groupbox within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 5
integer y = 340
integer width = 599
integer height = 436
integer weight = 700
long textcolor = 16711680
string text = "Scan Receipt"
end type

type gb_3 from so_groupbox within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 1385
integer y = 340
integer width = 2898
integer height = 436
integer weight = 700
long textcolor = 16711680
string text = "Scan Receipt"
end type

type gb_4 from so_groupbox within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 9
integer width = 2935
integer height = 300
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_5 from so_groupbox within w_mat_receipt_slip_4_rental_borrowing_master
integer x = 613
integer y = 344
integer width = 754
integer height = 436
integer weight = 700
long textcolor = 16711680
string text = "Supplier"
end type

