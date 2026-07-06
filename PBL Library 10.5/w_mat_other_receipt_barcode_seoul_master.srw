HA$PBExportHeader$w_mat_other_receipt_barcode_seoul_master.srw
$PBExportComments$Material Mass Issue Return Master
forward
global type w_mat_other_receipt_barcode_seoul_master from w_main_root
end type
type ddlb_item_code from uo_item_code within w_mat_other_receipt_barcode_seoul_master
end type
type st_3 from so_statictext within w_mat_other_receipt_barcode_seoul_master
end type
type st_4 from so_statictext within w_mat_other_receipt_barcode_seoul_master
end type
type cb_cancel from so_commandbutton within w_mat_other_receipt_barcode_seoul_master
end type
type st_1 from so_statictext within w_mat_other_receipt_barcode_seoul_master
end type
type st_status from so_statictext within w_mat_other_receipt_barcode_seoul_master
end type
type sle_supplier_barcode from so_singlelineedit within w_mat_other_receipt_barcode_seoul_master
end type
type sle_our_barcode from so_singlelineedit within w_mat_other_receipt_barcode_seoul_master
end type
type st_2 from so_statictext within w_mat_other_receipt_barcode_seoul_master
end type
type sle_material_mfs from so_singlelineedit within w_mat_other_receipt_barcode_seoul_master
end type
type st_6 from so_statictext within w_mat_other_receipt_barcode_seoul_master
end type
type sle_qty from so_singlelineedit within w_mat_other_receipt_barcode_seoul_master
end type
type st_7 from so_statictext within w_mat_other_receipt_barcode_seoul_master
end type
type rb_wait from so_radiobutton within w_mat_other_receipt_barcode_seoul_master
end type
type rb_history from so_radiobutton within w_mat_other_receipt_barcode_seoul_master
end type
type sle_supplier_lot_no from so_singlelineedit within w_mat_other_receipt_barcode_seoul_master
end type
type sle_origin_supplier_code from so_singlelineedit within w_mat_other_receipt_barcode_seoul_master
end type
type st_8 from so_statictext within w_mat_other_receipt_barcode_seoul_master
end type
type st_9 from so_statictext within w_mat_other_receipt_barcode_seoul_master
end type
type pb_2 from so_commandbutton within w_mat_other_receipt_barcode_seoul_master
end type
type sle_our_barcode_cond from so_singlelineedit within w_mat_other_receipt_barcode_seoul_master
end type
type st_10 from so_statictext within w_mat_other_receipt_barcode_seoul_master
end type
type sle_invoice_no from so_singlelineedit within w_mat_other_receipt_barcode_seoul_master
end type
type st_5 from so_statictext within w_mat_other_receipt_barcode_seoul_master
end type
type ddlb_receipt_compare_yn from uo_basecode within w_mat_other_receipt_barcode_seoul_master
end type
type st_11 from so_statictext within w_mat_other_receipt_barcode_seoul_master
end type
type pb_1 from so_commandbutton within w_mat_other_receipt_barcode_seoul_master
end type
type dw_6 from so_datawindow within w_mat_other_receipt_barcode_seoul_master
end type
type pb_3 from so_commandbutton within w_mat_other_receipt_barcode_seoul_master
end type
type st_12 from so_statictext within w_mat_other_receipt_barcode_seoul_master
end type
type sle_week from so_singlelineedit within w_mat_other_receipt_barcode_seoul_master
end type
type cb_1 from commandbutton within w_mat_other_receipt_barcode_seoul_master
end type
type cbx_check_new_item from so_checkbox within w_mat_other_receipt_barcode_seoul_master
end type
type cbx_check_unit_price from so_checkbox within w_mat_other_receipt_barcode_seoul_master
end type
type cbx_ignore_sup_bcd from so_checkbox within w_mat_other_receipt_barcode_seoul_master
end type
type cbx_receipt_lot_check_yn from so_checkbox within w_mat_other_receipt_barcode_seoul_master
end type
type uo_dateset from uo_ymdh_calendar within w_mat_other_receipt_barcode_seoul_master
end type
type uo_dateend from uo_ymdh_calendar within w_mat_other_receipt_barcode_seoul_master
end type
type rb_barcode_history from so_radiobutton within w_mat_other_receipt_barcode_seoul_master
end type
type gb_2 from so_groupbox within w_mat_other_receipt_barcode_seoul_master
end type
type gb_4 from so_groupbox within w_mat_other_receipt_barcode_seoul_master
end type
type gb_1 from so_groupbox within w_mat_other_receipt_barcode_seoul_master
end type
type gb_3 from so_groupbox within w_mat_other_receipt_barcode_seoul_master
end type
type gb_5 from so_groupbox within w_mat_other_receipt_barcode_seoul_master
end type
end forward

global type w_mat_other_receipt_barcode_seoul_master from w_main_root
integer width = 5728
integer height = 3228
string title = "Material Receipt Barcode Master"
ddlb_item_code ddlb_item_code
st_3 st_3
st_4 st_4
cb_cancel cb_cancel
st_1 st_1
st_status st_status
sle_supplier_barcode sle_supplier_barcode
sle_our_barcode sle_our_barcode
st_2 st_2
sle_material_mfs sle_material_mfs
st_6 st_6
sle_qty sle_qty
st_7 st_7
rb_wait rb_wait
rb_history rb_history
sle_supplier_lot_no sle_supplier_lot_no
sle_origin_supplier_code sle_origin_supplier_code
st_8 st_8
st_9 st_9
pb_2 pb_2
sle_our_barcode_cond sle_our_barcode_cond
st_10 st_10
sle_invoice_no sle_invoice_no
st_5 st_5
ddlb_receipt_compare_yn ddlb_receipt_compare_yn
st_11 st_11
pb_1 pb_1
dw_6 dw_6
pb_3 pb_3
st_12 st_12
sle_week sle_week
cb_1 cb_1
cbx_check_new_item cbx_check_new_item
cbx_check_unit_price cbx_check_unit_price
cbx_ignore_sup_bcd cbx_ignore_sup_bcd
cbx_receipt_lot_check_yn cbx_receipt_lot_check_yn
uo_dateset uo_dateset
uo_dateend uo_dateend
rb_barcode_history rb_barcode_history
gb_2 gb_2
gb_4 gb_4
gb_1 gb_1
gb_3 gb_3
gb_5 gb_5
end type
global w_mat_other_receipt_barcode_seoul_master w_mat_other_receipt_barcode_seoul_master

type variables
string ivs_preview_yn = 'N' , lvs_msl_check_yn = 'N'
string  lvs_supplier_barcode , lvs_our_barcode , lvs_lot_no , lvs_item_code  , lvs_slip_no  , lvs_supplier_lot_no , lvs_origin_supplier_code
string LVS_RECEIPT_COMPARE_YN , LVS_FROM_SUPPLIER_CODE , lvs_supplier_barcode_check
string  lvs_line_type , LVS_SUPPLIER_CODE , LVS_RECEIPT_TYPE , LVS_MANUFACTURE_WEEK
int  lvi_pos1 , lvi_pos2 , lvi_pos_check
long lvl_receipt_qty , lvl_count , lvl_receipt_lot_no
decimal lvd_unit_price

long lvl_receipt_sequence  , lvi_item_count
string  ivs_chk='N'

string lvs_eco_check_yn , lvs_eco_check_comments , ivs_is_batch = 'N' ,  lvs_label_type , lvs_location_code  , lvs_receipt_lot_check_yn , LVS_NO_CHECK_ORIGIN_SUPPLIER

int ivi_vendor_check  = 0  // vendor code, lot id check flag (sys config, RECEIPT_VENDOR_INFO_CHECK)
string ivs_keyitem_check = "N"  // $$HEX3$$88d4a9ba2000$$ENDHEX$$master keyitem flag
end variables

forward prototypes
public function integer wf_receipt_barcode (string arg_type)
end prototypes

public function integer wf_receipt_barcode (string arg_type);LONG LVI_BARCODE_EXISTS
if arg_type = 'N' then 
	lvs_supplier_barcode  = sle_supplier_barcode.text
	lvs_our_barcode         = sle_our_barcode.text
else
     //$$HEX9$$08c604c814bc54cfdcb494b2200088d4a9ba$$ENDHEX$$+$$HEX9$$6fb8b8d220005cb8ccb920006cad31c12000$$ENDHEX$$
	lvs_supplier_barcode  = sle_supplier_barcode.text
	lvs_our_barcode = sle_our_barcode.text+"-"+sle_qty.text
end if 

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
//END IF 

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
//END IF 
//
//==================================================
//  $$HEX14$$f5ac09aec1c0200014bc54cfdcb42000a4c294ce2000b4cc6cd02000$$ENDHEX$$
//==================================================
if lvs_supplier_barcode = '' then 
	sle_supplier_barcode.setfocus()
	sle_supplier_barcode.selecttext( 1,100)
	f_play_sound("$$HEX8$$70ac98b798cc14bc54cfdcb4a4c294ce$$ENDHEX$$.wav")	
	st_status.text = "$$HEX19$$70ac98b798cc200014bc54cfdcb400ac2000a4c294ce18b4c0c920004ac558c5b5c2c8b2e4b2$$ENDHEX$$-$$HEX8$$9b4f945e4655616701782a676b62cf63$$ENDHEX$$"
//	if cbx_show_error_msg.checked = true then 
		f_msgbox(173)
//	end if 
	return -1
end if 

//==================================================
// $$HEX13$$90c7acc0200014bc54cfdcb42000a4c294ce2000b4cc6cd02000$$ENDHEX$$
//==================================================
if lvs_our_barcode = '' then 
	sle_our_barcode.setfocus()
	sle_our_barcode.selecttext( 1,100)
	f_play_sound("$$HEX7$$90c7acc014bc54cfdcb4a4c294ce$$ENDHEX$$.wav")	
	st_status.text = "$$HEX18$$90c7acc0200014bc54cfdcb400ac2000a4c294ce18b4c0c920004ac558c5b5c2c8b2e4b2$$ENDHEX$$-$$HEX8$$1162ec4e8476616701782a676b62cf63$$ENDHEX$$"
//	if cbx_show_error_msg.checked = true then 
		f_msgbox(173)
//	end if 
	return -1
end if 

//==================================================
//  $$HEX11$$f5ac09aec1c0200014bc54cfdcb4200034bbdcc22000$$ENDHEX$$
//==================================================

if cbx_ignore_sup_bcd.checked = true then 
else
		if lvs_supplier_barcode = lvs_our_barcode then 
			st_status.text = "$$HEX19$$d9b37cc75cd5200014bc54cfdcb47cb92000a4c294ce200058d574ba200048c529b4c8b2e4b2$$ENDHEX$$-$$HEX9$$0d4e8189004e37688476616701786b62cf63$$ENDHEX$$"
			f_play_sound("$$HEX9$$d9b37cc714bc54cfdcb4a4c294ce24c658b9$$ENDHEX$$.wav")
			sle_our_barcode.setfocus()
			sle_our_barcode.selecttext( 1,100)
	//		if cbx_show_error_msg.checked = true then 
				f_msgbox(173)
//			end if 			
			return -1 
		end if 
end if 
//==================================================
//  $$HEX6$$88d4a9ba200054cfdcb42000$$ENDHEX$$
//==================================================
//lvi_pos1 =  pos(lvs_our_barcode , '-' , 7 ) 
//
//if  lvi_pos1 <= 0 then 
//	f_msgbox1(1175 ,lvs_our_barcode )
//	sle_our_barcode.setfocus()
//	sle_our_barcode.selecttext( 1,100)
//
//	return -1 
//end if 
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
		return -1 
	end if 
if f_check_item_exists( lvs_item_code , f_t_sysdate())  <= 0 then 
	
	f_play_sound("$$HEX5$$88d4a9baf8bbf1b45db8$$ENDHEX$$.wav")
	f_msgbox(9041) //$$HEX10$$fcd3a9bac8b9a4c230d12000f8bbf1b45db82000$$ENDHEX$$
	
	sle_our_barcode.setfocus()
	sle_our_barcode.selecttext( 1,100)	
	
	return -1
end if 

//==================================================
// $$HEX6$$6fb8b8d2200088bc38d62000$$ENDHEX$$
//==================================================
//lvi_pos2 =  pos(lvs_our_barcode , '-' , lvi_pos1+1 ) 
//
//if  lvi_pos2 <= 0 then 
//	f_msgbox1(1175 ,lvs_our_barcode )
//	sle_our_barcode.setfocus()
//	sle_our_barcode.selecttext( 1,100)
//	return -1 
//end if 
//
//lvs_lot_no = trim( mid( lvs_our_barcode , lvi_pos1+1 ,   lvi_pos2 - lvi_pos1 -1 ))
//if lvs_lot_no = ''  then 
//	st_status.text = "$$HEX15$$6fb8b8d288bc38d600ac20002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$-LOT$$HEX4$$f75301780d4ef95b$$ENDHEX$$"
//	
//	sle_our_barcode.setfocus()
//	sle_our_barcode.selecttext( 1,100)	
//	
////	if cbx_show_error_msg.checked = true then 
//		f_msgbox(173)
////	end if 	
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
		return -1
	end if 
//==================================================
//  $$HEX6$$85c7e0ac200018c2c9b72000$$ENDHEX$$
//==================================================
//lvl_receipt_qty = long( trim( mid( lvs_our_barcode , lvi_pos2+1 ,  10  )) )
//
//if lvl_receipt_qty <=0 then 
//	
//	f_play_sound("$$HEX4$$18c2c9b724c658b9$$ENDHEX$$.wav")	
//	st_status.text = "$$HEX15$$85c7e0ac18c2c9b774c720002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$-$$HEX4$$7065cf910d4ef95b$$ENDHEX$$"	
//	sle_our_barcode.setfocus()
//	sle_our_barcode.selecttext( 1,100)	
////	if cbx_show_error_msg.checked = true then 
//		f_msgbox(173)
////	end if 	
//	
//	return -1
//end if 
	SELECT  TO_NUMBER( F_GET_LOT_QTY_FROM_BARCODE (:lvs_our_barcode ) )
	INTO :lvl_receipt_qty
	FROM DUAL ; 
	
	
	IF F_SQL_CHECK() < 0 THEN 
		sle_our_barcode.selecttext( 1,100)	
	END IF 	 


if lvl_receipt_qty <=0 then 
	
	f_play_sound("$$HEX4$$18c2c9b724c658b9$$ENDHEX$$.wav")	
	st_status.text = F_MSG( "$$HEX15$$85c7e0ac18c2c9b774c720002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$"	 , 'S')
	sle_our_barcode.setfocus()
	sle_our_barcode.selecttext( 1,100)	
	f_msgbox(173)
	return -1
end if 
//=========================================================
//  $$HEX21$$f5ac09aec1c0200014bc54cfdcb4200040c6200090c7acc0200088d4a9ba54cfdcb4200044be50ad2000$$ENDHEX$$
//=========================================================
   lvi_pos_check = pos( lvs_supplier_barcode ,  lvs_item_code , 1) 
	
   if lvi_pos_check <= 0 then 
		
		      SELECT NVL(PART_NO, '*')  
		  	    INTO :lvs_supplier_barcode_check
			   FROM ID_ITEM
			 WHERE ITEM_CODE = :lvs_item_code ;
			 
		//========================================
		// $$HEX15$$f5ac09aec1c0200014bc54cfdcb45cb82000e4b2dcc22000b4cc6cd02000$$ENDHEX$$
		//========================================
		lvi_pos_check = pos( lvs_supplier_barcode ,  lvs_supplier_barcode_check  , 1 ) 	 
		
		if lvi_pos_check <= 0  then 
		
					 SELECT ITEM_CODE  
						 INTO :lvs_supplier_barcode
						FROM ID_ITEM
					 WHERE PART_NO = :lvs_supplier_barcode ;
					 
				//========================================
				// $$HEX15$$f5ac09aec1c0200014bc54cfdcb45cb82000e4b2dcc22000b4cc6cd02000$$ENDHEX$$
				//========================================
				lvi_pos_check = pos( lvs_supplier_barcode ,  lvs_item_code , 1 ) 
				
				if lvi_pos_check <= 0 then 
						f_play_sound("$$HEX5$$90c7acc788bd7cc758ce$$ENDHEX$$.wav")
						st_status.text = "$$HEX16$$fcd3a9ba88bc38d600ac20007cc758ce200058d5c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$-$$HEX4$$c154ee760d4ef95b$$ENDHEX$$"
						sle_supplier_barcode.text = ''
						sle_our_barcode.text  = ''
						sle_supplier_barcode.setfocus()
					//	if cbx_show_error_msg.checked = true then 
							f_msgbox(173)
					//	end if 				
						return -1
				end if 
		
		end if 	
end if 

//=========================================================
//  $$HEX11$$85c7e0ac200098ccacb9200004d55cb838c1a4c22000$$ENDHEX$$
//=========================================================

lvl_receipt_lot_no         = LONG(f_get_any_no( 'RECEIPT_LOT_NO') )
lvs_line_type                = f_get_line_type_from_item( lvs_item_code )
lvs_supplier_lot_no       = sle_supplier_lot_no.text
lvs_origin_supplier_code= sle_origin_supplier_code.text

LVS_MANUFACTURE_WEEK = SLE_WEEK.TEXT  // $$HEX3$$fcc828cc2000$$ENDHEX$$

// SHS 2016/05/24, $$HEX2$$20c731c1$$ENDHEX$$2$$HEX4$$f5aca5c740c72000$$ENDHEX$$key item$$HEX5$$d0c5200000b374d52000$$ENDHEX$$vendor code$$HEX2$$40c62000$$ENDHEX$$Lot No$$HEX6$$7cb9200018bcdcb4dcc22000$$ENDHEX$$scan $$HEX4$$74d57cc5200068d5$$ENDHEX$$----------------------------
// SHS 2016/10/12, space$$HEX11$$44c72000ecc5ecb71cac7cb9200023b1b4c51cc12000$$ENDHEX$$pass $$HEX10$$18b494b283ac44c72000c9b930ae04c768d52000$$ENDHEX$$-------------------------------------------------------

  IF ivi_vendor_check > 0 and ivs_keyitem_check = "Y" THEN
	
	  IF len(trim(lvs_supplier_lot_no)) < 4 THEN
		 st_status.text = "NG, Keyitem$$HEX2$$40c72000$$ENDHEX$$Supplier Lot No $$HEX9$$14bc54cfdcb47cb9200018bcdcb4dcc22000$$ENDHEX$$Scan $$HEX6$$74d57cc5200069d5c8b2e4b2$$ENDHEX$$!!! ($$HEX3$$5ccd8cc12000$$ENDHEX$$4$$HEX2$$90c7acb9$$ENDHEX$$)"
		 sle_supplier_lot_no.setfocus( )
		 return -1 
	  END IF
	  
	  IF len(trim(lvs_origin_supplier_code)) <> 8  THEN
	  	 st_status.text = "NG, Keyitem$$HEX2$$40c72000$$ENDHEX$$Supplier Code $$HEX9$$14bc54cfdcb47cb9200018bcdcb4dcc22000$$ENDHEX$$Scan $$HEX6$$74d57cc5200069d5c8b2e4b2$$ENDHEX$$!!! (8$$HEX2$$90c7acb9$$ENDHEX$$)"
		 sle_origin_supplier_code.setfocus( )
		 return -1 
	  END IF
	  
  END IF
  //--------------------------------------------------------------------------------------------------------------------------------

//==================================================
// $$HEX12$$74c7f8bb74c8acc7200058d594b2c0c92000b4cc6cd02000$$ENDHEX$$
//==================================================
LVI_BARCODE_EXISTS = 0 

SELECT RECEIPT_SLIP_NO, 
            NVL(SUPPLIER_CODE ,'*'), 
		   NVL(RECEIPT_COMPARE_YN , 'N')  , 
            NVL(RECEIPT_TYPE,'N') , 
		   FROM_SUPPLIER_CODE ,
		   LABEL_TYPE ,
		  1
   INTO :LVS_SLIP_NO , :lvs_supplier_code , :LVS_RECEIPT_COMPARE_YN  , :LVS_RECEIPT_TYPE ,
		  :LVS_FROM_SUPPLIER_CODE ,
		  :LVS_LABEL_TYPE ,
		  :LVI_BARCODE_EXISTS
  FROM IM_ITEM_RECEIPT_BARCODE
 WHERE ITEM_CODE = :LVS_ITEM_CODE
     AND LOT_NO = :LVS_LOT_NO
      AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID  ;

IF F_SQL_CHECK() < 0 THEN 
	sle_our_barcode.setfocus( )
	sle_our_barcode.text = ''	
	st_status.text = LVS_OUR_BARCODE+' SLIP $$HEX15$$a4c294ce200074c725b8d0c5200024c658b900ac200088c7b5c2c8b2e4b2$$ENDHEX$$-$$HEX5$$d15368797e620d4e3052$$ENDHEX$$'
	
//if cbx_show_error_msg.checked = true then 
		f_msgbox(173)
//	end if 	
	return -1 
END IF 

if  LVS_SLIP_NO = '' OR LVI_BARCODE_EXISTS = 0  then	
	
	f_play_sound("$$HEX6$$acc2bdb974c725b8c6c54cc7$$ENDHEX$$.wav")	
	st_status.text = LVS_OUR_BARCODE+' SLIP $$HEX11$$a4c294ce200074c725b874c72000c6c5b5c2c8b2e4b2$$ENDHEX$$-$$HEX5$$d15368797e620d4e3052$$ENDHEX$$'
	sle_our_barcode.setfocus( )
	sle_our_barcode.text = ''
	
//	if cbx_show_error_msg.checked = true then 
		f_msgbox(173)
//	end if 	
	
	return -1
end if 

if LVS_RECEIPT_COMPARE_YN = 'Y'  then
	f_play_sound("$$HEX5$$74c7f8bb74c8acc768d5$$ENDHEX$$.wav")
	st_status.text = '$$HEX11$$74c7f8bb200085c7e0ac200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$-$$HEX4$$f25d6551935e864e$$ENDHEX$$'
	sle_our_barcode.setfocus( )
	sle_our_barcode.text = ''
//	if cbx_show_error_msg.checked = true then 
		f_msgbox(173)
//	end if 	
	
	return -1
	
end if 

if cbx_check_unit_price.checked = true then 

lvd_unit_price = f_get_item_unit_price_confirm(lvs_supplier_code,lvs_item_code , lvs_line_type , f_t_sysdate())
	
	if isnull(lvd_unit_price)   then
		f_msgbox1( 9086 , lvs_item_code )
		sle_our_barcode.setfocus()
		sle_our_barcode.selecttext( 1,100)				
		return -1
	end if
	
	if f_sql_check() <  0 then 
		sle_our_barcode.setfocus()
		sle_our_barcode.selecttext( 1,100)
		return -1 
	end if 			
	
else
	lvd_unit_price = f_get_item_unit_price_confirm(lvs_supplier_code,lvs_item_code , lvs_line_type , f_t_sysdate())
	 
	if f_sql_check() <  0 then 
		sle_our_barcode.setfocus()
		sle_our_barcode.selecttext( 1,100)
		return -1 
	end if 		 
		 
end if ;
//====================================================
// $$HEX13$$85c7e0ac200044c6ccb820000cd598b7f8ad200024c115c82000$$ENDHEX$$
//====================================================
	UPDATE IM_ITEM_RECEIPT_BARCODE
         SET RECEIPT_COMPARE_YN = 'Y' ,
			RECEIPT_COMPARE_DATE = SYSDATE  , 
			RECEIPT_COMPARE_BY = :GVS_USER_ID ,  
			SUPPLIER_BARCODE = :lvs_supplier_barcode ,
			RETURN_YN = 'N' ,
			RETURN_DATE = NULL ,
			VENDOR_LOTNO = :lvs_supplier_lot_no,
			VENDOR_CODE  = :lvs_origin_supplier_code
     WHERE  ITEM_CODE = :LVS_ITEM_CODE
          AND LOT_NO = :lvs_lot_no
          AND ORGANIZATION_ID = :GVI_ORganization_id ;
			 
     if f_sql_check() <  0 then 
		sle_our_barcode.setfocus()
		sle_our_barcode.selecttext( 1,100)
		return -1 
	end if 

		     if lvs_label_type = 'R' then 
				 lvs_location_code = 'M06' //$$HEX8$$acb9fcbc91c588d420003dcce0ac2000$$ENDHEX$$
			  else
				 lvs_location_code = 'M01'
			  end if 
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
							  CLOSE_DATE,
							  FROM_SUPPLIER_CODE ,
							  MANUFACTURE_WEEK )  
							  
					 VALUES( :lvl_receipt_sequence ,      //RECEIPT_SEQUENCE,   
							  TRUNC(SYSDATE),      //RECEIPT_DATE,   
							  1,      //ORGANIZATION_ID,   
							  :LVS_LOCATION_CODE ,      //LOCATION_CODE,   
							  1,      //DELIVERY,   
							  1,      //RECEIPT_DEFICIT,   
							  :lvs_line_type ,      //LINE_TYPE,   
							  :lvl_receipt_qty ,      //RECEIPT_QTY,   
							  0,      //MATERIAL_COST,   
							  :lvd_unit_price ,      //UNIT_PRICE,   
							  0,      //MATERIAL_COST_AMT,   
							  sysdate,      //ENTER_DATE,   
							  :lvs_slip_no ,      //INVOICE_NO,   
							  :lvl_receipt_qty * :lvd_unit_price,      //RECEIPT_AMT,   
							  :GVS_USER_ID ,      //ENTER_BY,   
							  1,      //EXCHANGE_RATE,   
							  0,      //FOREIGN_RECEIPT_AMT,   
							  :LVS_SUPPLIER_CODE ,      //SUPPLIER_CODE,   
							  SYSDATE,      //LAST_MODIFY_DATE,   
							  :GVS_USER_ID ,      //LAST_MODIFY_BY,   
							  'N',      //CONFIRM_YN,   
							  TRUNC(SYSDATE),      //CONFIRM_DATE,   
							  :LVS_RECEIPT_TYPE,      //RECEIPT_TYPE,   
							  :lvs_supplier_lot_no,      //MFS,   
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
							  :lvs_origin_supplier_code ,      //ORIGIN_SUPPLIER_CODE,   
							  'M',      //ORDER_TYPE,   
							  :gvs_user_id,      //CONFIRM_BY,   
							  NULL,     //SUBCONTRACT_INVOICE_NO,   
							  'N',      //INVOICE_OPEN_YN,   
							  0,      //INVOICE_OPEN_SEQUENCE,   
							  'Y',      //CLOSE_YN,   
							   NULL ,
							  :LVS_FROM_SUPPLIER_CODE,
							  :LVS_MANUFACTURE_WEEK)      //CLOSE_DATE
						  ;
						 
			 if  f_sql_check() < 0 then
				f_play_sound("$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav")
				st_status.text = '$$HEX18$$85c7e0ac98ccacb9200011c9200024c658b900ac20001cbcddc0200088d5b5c2c8b2e4b2$$ENDHEX$$-$$HEX4$$6551935e3159258d$$ENDHEX$$'
				sle_supplier_barcode.text=''
				sle_our_barcode.text=''
				sle_supplier_barcode.setfocus()
				
			//	if cbx_show_error_msg.checked = true then 
					f_msgbox(173)
			//	end if 				
				
				return -1
			end if
			
commit;

//==============================================
//
//==============================================
long lvl_row

	lvl_row = dw_2.insertrow(1)
	dw_2.object.origin_mfs[lvl_row] = lvs_supplier_barcode
	dw_2.object.item_code[lvl_row] = lvs_item_code
	dw_2.object.receipt_qty[lvl_row] = lvl_receipt_qty
	dw_2.object.material_mfs[lvl_row] = lvs_lot_no
//==============================================
//
//==============================================
f_play_sound("$$HEX4$$00c8a5c731c1f5ac$$ENDHEX$$.wav")
st_status.text = '$$HEX10$$15c8c1c098ccacb9200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$-$$HEX2$$636b385e$$ENDHEX$$'

sle_qty.text = ''
sle_origin_supplier_code.text = ''
sle_our_barcode.text = ''
sle_supplier_barcode.text = ''
sle_supplier_lot_no.text = ''
sle_supplier_barcode.setfocus( )

return  1
end function

on w_mat_other_receipt_barcode_seoul_master.create
int iCurrent
call super::create
this.ddlb_item_code=create ddlb_item_code
this.st_3=create st_3
this.st_4=create st_4
this.cb_cancel=create cb_cancel
this.st_1=create st_1
this.st_status=create st_status
this.sle_supplier_barcode=create sle_supplier_barcode
this.sle_our_barcode=create sle_our_barcode
this.st_2=create st_2
this.sle_material_mfs=create sle_material_mfs
this.st_6=create st_6
this.sle_qty=create sle_qty
this.st_7=create st_7
this.rb_wait=create rb_wait
this.rb_history=create rb_history
this.sle_supplier_lot_no=create sle_supplier_lot_no
this.sle_origin_supplier_code=create sle_origin_supplier_code
this.st_8=create st_8
this.st_9=create st_9
this.pb_2=create pb_2
this.sle_our_barcode_cond=create sle_our_barcode_cond
this.st_10=create st_10
this.sle_invoice_no=create sle_invoice_no
this.st_5=create st_5
this.ddlb_receipt_compare_yn=create ddlb_receipt_compare_yn
this.st_11=create st_11
this.pb_1=create pb_1
this.dw_6=create dw_6
this.pb_3=create pb_3
this.st_12=create st_12
this.sle_week=create sle_week
this.cb_1=create cb_1
this.cbx_check_new_item=create cbx_check_new_item
this.cbx_check_unit_price=create cbx_check_unit_price
this.cbx_ignore_sup_bcd=create cbx_ignore_sup_bcd
this.cbx_receipt_lot_check_yn=create cbx_receipt_lot_check_yn
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.rb_barcode_history=create rb_barcode_history
this.gb_2=create gb_2
this.gb_4=create gb_4
this.gb_1=create gb_1
this.gb_3=create gb_3
this.gb_5=create gb_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_item_code
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.cb_cancel
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_status
this.Control[iCurrent+7]=this.sle_supplier_barcode
this.Control[iCurrent+8]=this.sle_our_barcode
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.sle_material_mfs
this.Control[iCurrent+11]=this.st_6
this.Control[iCurrent+12]=this.sle_qty
this.Control[iCurrent+13]=this.st_7
this.Control[iCurrent+14]=this.rb_wait
this.Control[iCurrent+15]=this.rb_history
this.Control[iCurrent+16]=this.sle_supplier_lot_no
this.Control[iCurrent+17]=this.sle_origin_supplier_code
this.Control[iCurrent+18]=this.st_8
this.Control[iCurrent+19]=this.st_9
this.Control[iCurrent+20]=this.pb_2
this.Control[iCurrent+21]=this.sle_our_barcode_cond
this.Control[iCurrent+22]=this.st_10
this.Control[iCurrent+23]=this.sle_invoice_no
this.Control[iCurrent+24]=this.st_5
this.Control[iCurrent+25]=this.ddlb_receipt_compare_yn
this.Control[iCurrent+26]=this.st_11
this.Control[iCurrent+27]=this.pb_1
this.Control[iCurrent+28]=this.dw_6
this.Control[iCurrent+29]=this.pb_3
this.Control[iCurrent+30]=this.st_12
this.Control[iCurrent+31]=this.sle_week
this.Control[iCurrent+32]=this.cb_1
this.Control[iCurrent+33]=this.cbx_check_new_item
this.Control[iCurrent+34]=this.cbx_check_unit_price
this.Control[iCurrent+35]=this.cbx_ignore_sup_bcd
this.Control[iCurrent+36]=this.cbx_receipt_lot_check_yn
this.Control[iCurrent+37]=this.uo_dateset
this.Control[iCurrent+38]=this.uo_dateend
this.Control[iCurrent+39]=this.rb_barcode_history
this.Control[iCurrent+40]=this.gb_2
this.Control[iCurrent+41]=this.gb_4
this.Control[iCurrent+42]=this.gb_1
this.Control[iCurrent+43]=this.gb_3
this.Control[iCurrent+44]=this.gb_5
end on

on w_mat_other_receipt_barcode_seoul_master.destroy
call super::destroy
destroy(this.ddlb_item_code)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.cb_cancel)
destroy(this.st_1)
destroy(this.st_status)
destroy(this.sle_supplier_barcode)
destroy(this.sle_our_barcode)
destroy(this.st_2)
destroy(this.sle_material_mfs)
destroy(this.st_6)
destroy(this.sle_qty)
destroy(this.st_7)
destroy(this.rb_wait)
destroy(this.rb_history)
destroy(this.sle_supplier_lot_no)
destroy(this.sle_origin_supplier_code)
destroy(this.st_8)
destroy(this.st_9)
destroy(this.pb_2)
destroy(this.sle_our_barcode_cond)
destroy(this.st_10)
destroy(this.sle_invoice_no)
destroy(this.st_5)
destroy(this.ddlb_receipt_compare_yn)
destroy(this.st_11)
destroy(this.pb_1)
destroy(this.dw_6)
destroy(this.pb_3)
destroy(this.st_12)
destroy(this.sle_week)
destroy(this.cb_1)
destroy(this.cbx_check_new_item)
destroy(this.cbx_check_unit_price)
destroy(this.cbx_ignore_sup_bcd)
destroy(this.cbx_receipt_lot_check_yn)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.rb_barcode_history)
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
st_status.width = dw_1.width + dw_2.width
sle_supplier_barcode.setfocus()
f_set_column_dddw( dw_2 )
end event

event ue_data_control;call super::ue_data_control;choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
		if rb_wait.checked = true then 
			dw_1.reset()
			dw_1.retrieve(  ddlb_item_code.text() + '%',  sle_our_barcode_cond.text+'%' ,  ddlb_receipt_compare_yn.getcode()+'%' , sle_material_mfs.text+'%' ,  gvi_organization_id)
			sle_our_barcode.setfocus()
		elseif rb_history.checked = true then 
	
			dw_3.reset()
			dw_3.retrieve( uo_dateset.text() , uo_dateend.text(),    ddlb_item_code.text() + '%',   sle_invoice_no.text+'%' , sle_material_mfs.text+'%' ,   gvi_organization_id)
			sle_our_barcode.setfocus()
		else 
			dw_4.reset()
			dw_4.retrieve(  ddlb_item_code.text() + '%',  sle_our_barcode_cond.text+'%' ,   sle_material_mfs.text+'%' ,  sle_invoice_no.text+'%', gvi_organization_id)
			sle_our_barcode.setfocus()			
			
		end if 
		
	case 'UPDATE'	
		
		
			if dw_4.update( ) < 0 then 
				rollback;
			else
				commit ;
				f_msgbox(170)
			end if 
		
	case else
end choose

end event

event open;call super::open;sle_our_barcode.setfocus()
end event

event clicked;call super::clicked;sle_our_barcode.setfocus()
end event

event resize;call super::resize;st_status.width = dw_1.width + dw_2.width
end event

type dw_5 from w_main_root`dw_5 within w_mat_other_receipt_barcode_seoul_master
integer x = 14
integer y = 1256
integer width = 2267
integer height = 752
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_mat_other_receipt_barcode_seoul_master
integer x = 14
integer y = 1256
integer width = 2830
integer height = 752
integer taborder = 0
boolean titlebar = true
string title = "Barcode List"
string dataobject = "d_mat_receipt_barcode_all_lst"
end type

type dw_3 from w_main_root`dw_3 within w_mat_other_receipt_barcode_seoul_master
integer x = 14
integer y = 1256
integer width = 2880
integer height = 752
integer taborder = 0
boolean titlebar = true
string title = "Receipt History"
string dataobject = "d_mat_receipt_4_barcode_compare_lst"
end type

type dw_2 from w_main_root`dw_2 within w_mat_other_receipt_barcode_seoul_master
integer x = 2926
integer y = 1256
integer width = 1637
integer height = 952
integer taborder = 0
boolean titlebar = true
string title = "Receipt Scan History"
string dataobject = "d_mat_receipt_4_barcode_compare_view"
borderstyle borderstyle = styleraised!
end type

event dw_2::clicked;call super::clicked;sle_our_barcode.setfocus()
end event

type dw_1 from w_main_root`dw_1 within w_mat_other_receipt_barcode_seoul_master
integer x = 14
integer y = 1256
integer width = 2898
integer height = 952
integer taborder = 0
boolean titlebar = true
string title = "Receipt Wait List"
string dataobject = "d_mat_rceipt_barcode_4_receipt_wait_lst"
end type

event dw_1::clicked;call super::clicked;sle_our_barcode.setfocus()
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_other_receipt_barcode_seoul_master
integer taborder = 0
end type

type ddlb_item_code from uo_item_code within w_mat_other_receipt_barcode_seoul_master
integer x = 2011
integer y = 396
integer width = 530
integer height = 676
integer taborder = 0
boolean bringtotop = true
end type

event selectionchanged;call super::selectionchanged;sle_supplier_barcode.setfocus()
end event

type st_3 from so_statictext within w_mat_other_receipt_barcode_seoul_master
integer x = 2011
integer y = 312
integer width = 530
integer height = 72
boolean bringtotop = true
string text = "Item Code"
end type

type st_4 from so_statictext within w_mat_other_receipt_barcode_seoul_master
integer x = 681
integer y = 312
integer width = 1317
integer height = 72
boolean bringtotop = true
string text = "Receipt Date"
end type

type cb_cancel from so_commandbutton within w_mat_other_receipt_barcode_seoul_master
integer x = 3968
integer y = 672
integer width = 475
integer height = 168
boolean bringtotop = true
string text = "Cancel Receipt"
end type

event clicked;call super::clicked;open(w_mat_receipt_normal_cancel_4_barcode_popup)

sle_supplier_barcode.setfocus()
end event

type st_1 from so_statictext within w_mat_other_receipt_barcode_seoul_master
integer x = 55
integer y = 756
integer width = 686
integer height = 68
boolean bringtotop = true
integer textsize = -10
long textcolor = 16711680
string text = "Supplier Barcode"
alignment alignment = right!
end type

type st_status from so_statictext within w_mat_other_receipt_barcode_seoul_master
integer width = 4690
integer height = 168
boolean bringtotop = true
integer textsize = -18
integer weight = 700
long textcolor = 65535
long backcolor = 16711680
string text = "Message"
end type

type sle_supplier_barcode from so_singlelineedit within w_mat_other_receipt_barcode_seoul_master
integer x = 773
integer y = 740
integer width = 1609
integer height = 104
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
textcase textcase = upper!
end type

event modified;call super::modified;//if cbx_old_type.checked = true then 
//	sle_qty.setfocus()
//else
//	wf_receipt_barcode('N')
//end if 

sle_week.text = ''
STRING LVS_WEEK , LVS_SYS_WEEK, LVS_ITEM, LVS_SUPPLIER
LONG LVI_LOT_BLOCKING_COUNT


LVS_SUPPLIER = Trim(THIS.TEXT)
//===========================================================
// LG PCB $$HEX13$$78c7bdacb0c62000d0c5ccb92000fcc828cc200000adacb92000$$ENDHEX$$
//===========================================================
IF MID( LVS_SUPPLIER , 1,3) = 'EAX' THEN 
    
	 SELECT F_GET_PREPARE_SUPPLIER_BARCODE( :LVS_SUPPLIER )
	  INTO :LVS_ITEM
	  FROM DUAL ;
	  
	SELECT F_GET_PCB_FROM_BARCODE_WEEK( :LVS_ITEM , :LVS_SUPPLIER)  , TO_CHAR( SYSDATE , 'YYWW')
	  INTO :LVS_WEEK , :LVS_SYS_WEEK 
	  FROM DUAL ;
	  
	IF  LEN(LVS_WEEK) <= 10 THEN 
		sle_week.text = LVS_WEEK
	ELSE
		sle_week.text = LVS_SYS_WEEK
	END IF 
	
END IF 	

SELECT F_CHECK_ITEM_LOT_BLOCKING( :THIS.TEXT) 
    INTO :LVI_LOT_BLOCKING_COUNT
 FROM DUAL ;
//==========================================================
//  
//==========================================================

sle_our_barcode.setfocus()
end event

event getfocus;call super::getfocus;//if cbx_sound_on.checked = true then 
//	f_play_sound("$$HEX8$$70ac98b798cc14bc54cfdcb4a4c294ce$$ENDHEX$$.wav")
//end if 
st_status.text = "$$HEX15$$70ac98b798cc200014bc54cfdcb47cb92000a4c294ce200058d538c194c6$$ENDHEX$$"
this.selecttext(1,200)
end event

type sle_our_barcode from so_singlelineedit within w_mat_other_receipt_barcode_seoul_master
integer x = 773
integer y = 852
integer width = 1609
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
textcase textcase = upper!
end type

event modified;call super::modified;String  lvs_vendor_code
Long  lvl_cnt
lvs_our_barcode  = sle_our_barcode.text
ivs_chk               = 'N'  //$$HEX9$$34bc54b354cfdcb400ad28b820004bc105d3$$ENDHEX$$
//=======================================
// $$HEX11$$00cf3cd554cf200090c7acc778c72000bdacb0c62000$$ENDHEX$$
//=======================================
// IF MID (UPPER (lvs_our_barcode), 1, 1) = '['    THEN
//         SELECT  f_get_item_code_from_barcode (:lvs_our_barcode)|| '-' || f_get_lot_no_from_barcode (:lvs_our_barcode) || '-' || f_get_lot_qty_from_barcode (:lvs_our_barcode)
//		    INTO :lvs_our_barcode
//	       FROM DUAL ; 
//		
//		IF F_SQL_CHECK() < 0 THEN 
//				sle_supplier_barcode.selecttext( 1,100)	
//		END IF 	 
//END IF 
//==================================================
//  $$HEX6$$88d4a9ba200054cfdcb42000$$ENDHEX$$
//==================================================
//lvi_pos1 =  pos(lvs_our_barcode , '-' , 7 ) 
//
//if  lvi_pos1 <= 0 then 
//	
//	f_play_sound("$$HEX5$$88d4a9baf8bbf1b45db8$$ENDHEX$$.wav")
//	f_msgbox1(1175 ,lvs_our_barcode )
//	sle_supplier_barcode.setfocus()
//	sle_supplier_barcode.selecttext( 1,100)
//	return -1 
//end if 
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
//==========================================
// 4M $$HEX12$$c0bcbdac200000b3c1c02000ecc580bd200055d678c72000$$ENDHEX$$
//==========================================
select eco_check_yn , eco_check_comments 
   into :lvs_eco_check_yn , :lvs_eco_check_comments 
  from id_item
 where item_code = :lvs_item_code
     and organization_id = :gvi_organization_id  ;
	  
if f_sql_check() < 0 then 
	return 
end if 

if lvs_eco_check_yn = 'Y' then 
	f_play_sound("$$HEX5$$ecd3e0c5c0bcbdac88d4$$ENDHEX$$.wav")
	Gst_return.gvs_return[1] = lvs_eco_check_comments
	openwithparm(w_item_eco_notify_image_popup , lvs_item_code ) 
end if 


//================================================
// $$HEX11$$e0c2dcad88d4a9ba2000ecc580bd200055d678c72000$$ENDHEX$$
//================================================

if cbx_check_new_item.checked = true then 
         lvi_item_count = 0 
		select count(*)
			into :lvi_item_count
		  from im_item_receipt
		 where item_code = :lvs_item_code
			  and organization_id = :gvi_organization_id 
			  and rownum = 1 ;
			  
		if f_sql_check() < 0 then 
			return 
		end if 

		if lvi_item_count = 0 then 
		 	 openwithparm(w_mat_new_item_set_msl_location_popup, lvs_item_code ) 
		end if
end if 
//================================================
//  $$HEX17$$d0c690c7acc720006fb8b8d22000b4cc6cd0200029bcddc27cc72000bdacb0c62000$$ENDHEX$$
//================================================

IF cbx_receipt_lot_check_yn.CHECKED = TRUE THEN 

             // SHS 2016/05/24, RECEIPT_VENDOR_INFO_CHECK config value $$HEX2$$0fbc2000$$ENDHEX$$keyitem_yn $$HEX6$$70c88cd6200094cd00ac2000$$ENDHEX$$---------------------
						
		      SELECT NVL(COUNT(CONFIG_VALUE),0)  
                   INTO :ivi_vendor_check
                  FROM ISYS_CONFIG      
                WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID
                    AND CONFIG_NAME      = 'RECEIPT_VENDOR_INFO_CHECK'  // KEY ITEM$$HEX3$$74c774ba2000$$ENDHEX$$vendor code$$HEX2$$40c62000$$ENDHEX$$Lot no$$HEX8$$7cb9200018bcdcb4dcc2200085c725b8$$ENDHEX$$
                    AND CONFIG_VALUE      = 'Y';
						  
               IF f_sql_check() < 0 THEN
                   return 
               END IF	

			//$$HEX30$$88d4a9ba3cc75cb82000e4b2dcc220005cd588bc2000b4cc6cd0200074d51cc12000b9d215c8200088d4a9ba40c72000e4b2dcc220001cc878c62000$$ENDHEX$$
			SELECT   NVL(receipt_lot_check_yn , 'N') , NVL( NO_CHECK_ORIGIN_SUPPLIER , 'N'), NVL(KEYITEM_YN,'N')
			    INTO  :LVS_RECEIPT_LOT_CHECK_YN , :LVS_NO_CHECK_ORIGIN_SUPPLIER, :ivs_keyitem_check
			   FROM ID_ITEM 
		 	 WHERE ITEM_CODE           = :LVS_ITEM_CODE
			     AND  ORGANIZATION_ID = :GVI_ORGANIZATION_ID  ;
			
			//-------------------------------------------------------------------------------------------------------------------------

		if   LVS_RECEIPT_LOT_CHECK_YN = 'Y'  then 
			
						f_play_sound("$$HEX6$$e0c5d0c5a4c2d8c590c7acc7$$ENDHEX$$.wav" )
						sle_supplier_lot_no.enabled = true
						sle_origin_supplier_code.enabled = true
											
						IF LVS_NO_CHECK_ORIGIN_SUPPLIER = 'Y' THEN 
					//	if cbx_no_origin_supplier_code.checked = true then 
								sle_origin_supplier_code.text ='*'
								ivs_chk  = 'Y' 
								
					//  2016/05/24 SHS ----------------------------------------------------------------------------------
					// $$HEX8$$20c731c1bdacb0c6200088d4a9ba2000$$ENDHEX$$master$$HEX3$$d0c51cc12000$$ENDHEX$$vendor code$$HEX12$$7cb9200000ac38c824c694b28cac200044c5c8b27cb72000$$ENDHEX$$vendor code label$$HEX2$$44c72000$$ENDHEX$$scan$$HEX2$$58d5ecc5$$ENDHEX$$
					// $$HEX3$$88d4a9ba2000$$ENDHEX$$master$$HEX9$$7cb92000b5d174d5200055d678c75cd5e4b2$$ENDHEX$$(vendor_code1, vendor_code2, vendor_code3)
					// ------------------------------------------------------------------------------------------------------
					//  2016/06/13 SHS ----------------------------------------------------------------------------------
					// $$HEX2$$20c731c1$$ENDHEX$$. $$HEX3$$70c82ccc44d5$$ENDHEX$$K $$HEX8$$94c6adcc3cc75cb8200088d4a9ba2000$$ENDHEX$$master $$HEX18$$30ae00c93cc75cb8200070b374c7c0d07cb9200000ac38c824c6c4b35db82000c0bcbdac$$ENDHEX$$
					// ------------------------------------------------------------------------------------------------------
					
						else
						
									//$$HEX12$$34bc54b354cfdcb4200015c8f4bc200088bdecb724c630ae$$ENDHEX$$
									SELECT COUNT(VENDOR_CODE1)
									  INTO  :lvl_cnt
									  FROM ( 	SELECT VENDOR_CODE1
													  FROM ID_ITEM  
													  WHERE ITEM_CODE            = :lvs_item_code
														AND  ORGANIZATION_ID = :gvi_organization_id 
												  UNION ALL
													 SELECT VENDOR_CODE2
													 FROM ID_ITEM  
													 WHERE ITEM_CODE            = :lvs_item_code
														 AND  ORGANIZATION_ID = :gvi_organization_id 
												  UNION ALL
													 SELECT VENDOR_CODE3
													  FROM ID_ITEM  
													 WHERE ITEM_CODE            = :lvs_item_code
														AND  ORGANIZATION_ID = :gvi_organization_id ) ;
										  
														 If f_sql_check() < 0 Then 
															  return 
														 End if 
														 
											 If lvl_cnt = 1 Then
												
														SELECT  VENDOR_CODE1
														INTO  :lvs_vendor_code
														FROM ID_ITEM 
														WHERE ITEM_CODE = :lvs_item_code
														AND  ORGANIZATION_ID = :gvi_organization_id  ;
														
														If f_sql_check() < 0 Then 
															return 
														End if 		
													  
												sle_origin_supplier_code.text = lvs_vendor_code
												ivs_chk  = 'Y'   //$$HEX19$$34bc54b354cfdcb4200090c7d9b320000fbc20001dd3c5c53cc75cb8200020c1ddd0dcc22000$$ENDHEX$$lot$$HEX14$$88bc38d6200085c725b82000c4d6200014bc54cfdcb420009ccd25b8$$ENDHEX$$
												
											ElseIf lvl_cnt > 1 Then
												//$$HEX6$$34bc54b354cfdcb400ac2000$$ENDHEX$$1$$HEX11$$1cac74c7c1c07cc7bdacb0c6200020c1ddd01dd3c5c5$$ENDHEX$$
												Gst_return.gvs_return[1] =  lvs_item_code
												openwithparm(w_mat_item_vendor_popup, this ) 
												
												sle_origin_supplier_code.text = message.stringparm
												ivs_chk  = 'Y'  //$$HEX19$$34bc54b354cfdcb4200090c7d9b320000fbc20001dd3c5c53cc75cb8200020c1ddd0dcc22000$$ENDHEX$$lot$$HEX14$$88bc38d6200085c725b82000c4d6200014bc54cfdcb420009ccd25b8$$ENDHEX$$
												
											End If			
					 // --------------------------------------------------------------------------------------------------------------------------------			
							end if 
								
						sle_supplier_lot_no.setfocus()
	
		else
			
					sle_supplier_lot_no.enabled = false
					sle_origin_supplier_code.enabled = false
					//==============================
					//
					//==============================
					wf_receipt_barcode('N')
	
		end if 
//=====================================
// $$HEX19$$d0c690c7acc720006fb8b8d22000b4cc6cd0200029bcddc274c7200044c5ccb2bdacb0c62000$$ENDHEX$$
// 
//=====================================
ELSE
	
		sle_supplier_lot_no.enabled = false
		sle_origin_supplier_code.enabled = false
		//==============================
		//
		//==============================
		
		wf_receipt_barcode('N')

END IF 

end event

event getfocus;call super::getfocus;this.selecttext(1,200)
end event

type st_2 from so_statictext within w_mat_other_receipt_barcode_seoul_master
integer x = 55
integer y = 872
integer width = 686
integer height = 68
boolean bringtotop = true
integer textsize = -10
long textcolor = 16711680
string text = "Our Barcode"
alignment alignment = right!
end type

type sle_material_mfs from so_singlelineedit within w_mat_other_receipt_barcode_seoul_master
integer x = 3086
integer y = 396
integer height = 88
boolean bringtotop = true
end type

type st_6 from so_statictext within w_mat_other_receipt_barcode_seoul_master
integer x = 3095
integer y = 312
integer height = 72
boolean bringtotop = true
string text = "Material MFS"
end type

type sle_qty from so_singlelineedit within w_mat_other_receipt_barcode_seoul_master
integer x = 2391
integer y = 1084
integer width = 539
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
boolean enabled = false
textcase textcase = upper!
end type

event getfocus;call super::getfocus;this.selecttext(1,200)
end event

type st_7 from so_statictext within w_mat_other_receipt_barcode_seoul_master
integer x = 2391
integer y = 956
integer width = 539
integer height = 100
boolean bringtotop = true
integer textsize = -10
long textcolor = 0
string text = "Qty"
end type

type rb_wait from so_radiobutton within w_mat_other_receipt_barcode_seoul_master
integer x = 78
integer y = 276
boolean bringtotop = true
string text = "Wait Receipt"
boolean checked = true
end type

event clicked;call super::clicked;selected_data_window = dw_1
dw_1.bringtotop = true
dw_2.bringtotop = true

sle_our_barcode.setfocus()
end event

type rb_history from so_radiobutton within w_mat_other_receipt_barcode_seoul_master
integer x = 73
integer y = 368
boolean bringtotop = true
string text = "Receipt History"
end type

event clicked;call super::clicked;selected_data_window = dw_3
dw_3.bringtotop = true

sle_our_barcode.setfocus()
end event

type sle_supplier_lot_no from so_singlelineedit within w_mat_other_receipt_barcode_seoul_master
integer x = 773
integer y = 968
integer width = 1609
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
boolean enabled = false
textcase textcase = upper!
end type

event getfocus;call super::getfocus;this.selecttext(1,200)
end event

event modified;call super::modified;
int lvi_count

//--- 2016/06/24 $$HEX3$$70c82ccc44d5$$ENDHEX$$K $$HEX5$$94c6adcc3cc75cb82000$$ENDHEX$$LG$$HEX5$$58c7200004d0f4ce2000$$ENDHEX$$Vendor Lot check -------------------------------------------------------------------------------------------

string lvs_return

select F_CHECK_VENDOR_LOT_BLOCKING(:sle_our_barcode.text, :this.text ) 
   into :lvs_return   
   from dual ; 
   
if f_sql_check() < 0 then 
      sle_our_barcode.selecttext( 1,100)
   sle_supplier_barcode.selecttext( 1,100)   
   sle_supplier_barcode.SETFOcus( )
   return 
end if 

if lvs_return = 'NG' then 
   Messagebox('$$HEX4$$15d6ddc224c658b9$$ENDHEX$$',this.text + '    $$HEX3$$a4bc54b32000$$ENDHEX$$LOT $$HEX9$$15d6ddc2200024c658b9200085c7c8b2e4b2$$ENDHEX$$. ') 
     sle_our_barcode.selecttext( 1,100)
   sle_supplier_barcode.selecttext( 1,100)   
   sle_supplier_barcode.SETFOcus( )
   return 
end if

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

select F_CHECK_ITEM_LOT_BLOCKING(  :this.text ) 
   into :lvi_count 
  from dual ;

if f_sql_check() < 0 then 
	return 
end if 

if lvi_count > 0 then 
	Messagebox("Notify" , "THis item was  Bloacked Item can`t receipt!!!")
	return 
end if 

If ivs_chk = 'Y' Then  //$$HEX19$$34bc54b354cfdcb4200090c7d9b320000fbc20001dd3c5c53cc75cb8200020c1ddd0dcc22000$$ENDHEX$$lot$$HEX15$$88bc38d6200085c725b82000c4d6200014bc54cfdcb420009ccd25b80900$$ENDHEX$$
		wf_receipt_barcode('N')
Else
	    sle_origin_supplier_code.setfocus()	
End If


end event

type sle_origin_supplier_code from so_singlelineedit within w_mat_other_receipt_barcode_seoul_master
integer x = 773
integer y = 1084
integer width = 1609
integer height = 104
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
boolean enabled = false
textcase textcase = upper!
end type

event getfocus;call super::getfocus;this.selecttext(1,200)
end event

event modified;call super::modified;
int lvi_count

//---------------------------------------------------------------------------------------------------------------------------
// SHS 2016/05/24 Scan$$HEX2$$1cb42000$$ENDHEX$$vendor barcode $$HEX6$$30ae00c9200088d4a9ba2000$$ENDHEX$$Master$$HEX19$$d0c52000f1b45db81cb42000b4b0a9c6fcac200044be50ad58d5ecc52000e4b274b974ba2000$$ENDHEX$$NG $$HEX2$$98ccacb9$$ENDHEX$$
//---------------------------------------------------------------------------------------------------------------------------

IF ivs_chk = 'N' THEN  //$$HEX14$$34bc54b3c5c5b4cc200018c2d9b33cc75cb82000a4c294ce58d574ba$$ENDHEX$$

   IF ivi_vendor_check > 0 and ivs_keyitem_check = "Y" THEN
		
           SELECT NVL(COUNT(VENDOR_CODE1),0)
	        INTO  :lvi_count
     	 FROM ( 	SELECT VENDOR_CODE1
			     	  FROM ID_ITEM  
	     		     WHERE ITEM_CODE            = :lvs_item_code
				         AND  ORGANIZATION_ID = :gvi_organization_id 
			          UNION ALL
				    SELECT VENDOR_CODE2
				      FROM ID_ITEM  
			        WHERE ITEM_CODE             = :lvs_item_code
					    AND  ORGANIZATION_ID = :gvi_organization_id 
				     UNION ALL
			         SELECT VENDOR_CODE3
				      FROM ID_ITEM  
				     WHERE ITEM_CODE            = :lvs_item_code
					     AND  ORGANIZATION_ID = :gvi_organization_id 
			     ) ;
		
        IF f_sql_check() < 0 THEN
           return 
	    ELSE
		
	       IF lvi_count > 0 THEN 
              wf_receipt_barcode('N')		
		  ELSE
			 f_play_sound("scanfailed.wav")	
	          st_status.text =  f_msg_st(9114)   //$$HEX6$$f8bb2000f1b45db81cb42000$$ENDHEX$$VENDOR CODE $$HEX3$$85c7c8b2e4b2$$ENDHEX$$, $$HEX3$$88d4a9ba2000$$ENDHEX$$Master $$HEX12$$55d678c72000c4d6200085c7e0ac200058d538c194c62000$$ENDHEX$$!!!
		  END IF 
		  
	END IF

   ELSE
	 
	 wf_receipt_barcode('N')	
	 
   END IF 

END IF

//---------------------------------------------------------------------------------------------------------------------------


end event

type st_8 from so_statictext within w_mat_other_receipt_barcode_seoul_master
integer x = 55
integer y = 984
integer width = 686
integer height = 68
boolean bringtotop = true
integer textsize = -10
long textcolor = 0
string text = "Supplier Lot No"
alignment alignment = right!
end type

type st_9 from so_statictext within w_mat_other_receipt_barcode_seoul_master
integer x = 55
integer y = 1104
integer width = 686
integer height = 68
boolean bringtotop = true
integer textsize = -10
long textcolor = 0
string text = "Origin Supplier Code"
alignment alignment = right!
end type

type pb_2 from so_commandbutton within w_mat_other_receipt_barcode_seoul_master
integer x = 3968
integer y = 848
integer width = 475
integer height = 168
boolean bringtotop = true
string text = "Clear"
end type

event clicked;call super::clicked;sle_supplier_lot_no.text = ""
sle_our_barcode.text = ""
sle_origin_supplier_code.text = ""
sle_supplier_barcode.text = ""
end event

type sle_our_barcode_cond from so_singlelineedit within w_mat_other_receipt_barcode_seoul_master
integer x = 3589
integer y = 396
integer width = 672
integer height = 88
boolean bringtotop = true
end type

type st_10 from so_statictext within w_mat_other_receipt_barcode_seoul_master
integer x = 3589
integer y = 312
integer width = 672
integer height = 72
boolean bringtotop = true
string text = "Our Barcode"
end type

type sle_invoice_no from so_singlelineedit within w_mat_other_receipt_barcode_seoul_master
integer x = 2551
integer y = 396
integer width = 521
integer height = 88
boolean bringtotop = true
end type

type st_5 from so_statictext within w_mat_other_receipt_barcode_seoul_master
integer x = 2560
integer y = 312
integer width = 530
integer height = 72
boolean bringtotop = true
string text = "Invoice No"
end type

type ddlb_receipt_compare_yn from uo_basecode within w_mat_other_receipt_barcode_seoul_master
integer x = 4270
integer y = 396
integer width = 512
boolean bringtotop = true
end type

event constructor;call super::constructor;this.Redraw("RECEIPT COMPARE YN")
end event

type st_11 from so_statictext within w_mat_other_receipt_barcode_seoul_master
integer x = 4293
integer y = 312
integer width = 489
integer height = 72
boolean bringtotop = true
string text = "Receipt Yn"
end type

type pb_1 from so_commandbutton within w_mat_other_receipt_barcode_seoul_master
boolean visible = false
integer x = 5074
integer y = 592
integer width = 233
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;call super::clicked;dw_6.settransobject(sqlca)
dw_6.retrieve()
end event

type dw_6 from so_datawindow within w_mat_other_receipt_barcode_seoul_master
boolean visible = false
integer x = 4567
integer y = 724
integer width = 992
integer height = 492
boolean bringtotop = true
string dataobject = "d_mat_no_receipt_issue_barcode_lst"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

type pb_3 from so_commandbutton within w_mat_other_receipt_barcode_seoul_master
boolean visible = false
integer x = 5330
integer y = 592
integer width = 233
boolean bringtotop = true
string text = "Do"
end type

event clicked;call super::clicked;long i
do
	i++

	sle_our_barcode.text = dw_6.object.item_barcode[i] 
	sle_our_barcode.triggerevent( modified! )
	
	sle_supplier_barcode.text = dw_6.object.supplier_barcode[i] 
	IF sle_supplier_barcode.text = '' OR ISNULL(sle_supplier_barcode.text) OR Sle_our_barcode.text = sle_supplier_barcode.text  THEN 
		sle_supplier_barcode.text =  dw_6.object.item_barcode[i] +'-NB'
	ELSE
	END IF 
	sle_supplier_barcode.triggerevent( modified! )	
	
	F_MSG_MDI_HELP(STRING(I))
	
loop until i = dw_6.rowcount()
end event

type st_12 from so_statictext within w_mat_other_receipt_barcode_seoul_master
integer x = 2386
integer y = 648
integer width = 539
integer height = 84
boolean bringtotop = true
integer textsize = -10
long textcolor = 0
string text = "Manufacture Week"
end type

type sle_week from so_singlelineedit within w_mat_other_receipt_barcode_seoul_master
integer x = 2386
integer y = 740
integer width = 539
integer height = 100
boolean bringtotop = true
integer textsize = -10
textcase textcase = upper!
end type

type cb_1 from commandbutton within w_mat_other_receipt_barcode_seoul_master
integer x = 3968
integer y = 1020
integer width = 475
integer height = 168
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Batch"
end type

event clicked;int i

ivs_is_batch = 'Y'

do
	i++
	
	if   string(dw_1.object.scan_date[i] , 'yyyymmdd' ) = string( f_t_sysdate() , 'yyyymmdd') then 
		
		sle_supplier_barcode.text = dw_1.object.item_barcode[i]+string(i) 
		sle_supplier_barcode.event modified( )
		
		sle_our_barcode.text =  dw_1.object.item_barcode[i]
		sle_our_barcode.event modified( )
		
	else
		continue 
	end if 
	st_status.text = string(i)+"/"+string(dw_1.rowcount( )) 
loop until i = dw_1.rowcount()
end event

type cbx_check_new_item from so_checkbox within w_mat_other_receipt_barcode_seoul_master
integer x = 3145
integer y = 716
integer width = 603
boolean bringtotop = true
integer textsize = -10
string text = "Check New Item"
boolean checked = true
end type

type cbx_check_unit_price from so_checkbox within w_mat_other_receipt_barcode_seoul_master
integer x = 3145
integer y = 800
integer width = 603
boolean bringtotop = true
integer textsize = -10
string text = "Check Unit Price"
boolean checked = true
end type

type cbx_ignore_sup_bcd from so_checkbox within w_mat_other_receipt_barcode_seoul_master
integer x = 3145
integer y = 884
integer width = 617
boolean bringtotop = true
integer textsize = -10
long textcolor = 255
boolean enabled = false
string text = "No Check Smae BCD"
end type

type cbx_receipt_lot_check_yn from so_checkbox within w_mat_other_receipt_barcode_seoul_master
integer x = 3145
integer y = 632
integer width = 654
boolean bringtotop = true
integer textsize = -10
boolean enabled = false
string text = "Receipt Lot Check YN"
boolean checked = true
end type

event constructor;call super::constructor;if GVS_receipt_lot_check_yn = 'Y' then
	this.checked = true 
else
	this.checked = false 
end if 
end event

type uo_dateset from uo_ymdh_calendar within w_mat_other_receipt_barcode_seoul_master
integer x = 672
integer y = 396
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymdh_calendar::destroy
end on

type uo_dateend from uo_ymdh_calendar within w_mat_other_receipt_barcode_seoul_master
integer x = 1339
integer y = 396
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymdh_calendar::destroy
end on

type rb_barcode_history from so_radiobutton within w_mat_other_receipt_barcode_seoul_master
integer x = 73
integer y = 464
boolean bringtotop = true
string text = "Barcode History"
end type

event clicked;call super::clicked;dw_4.bringtotop = true 
selected_data_window = dw_4
end event

type gb_2 from so_groupbox within w_mat_other_receipt_barcode_seoul_master
integer y = 196
integer width = 622
integer height = 376
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_4 from so_groupbox within w_mat_other_receipt_barcode_seoul_master
integer x = 14
integer y = 576
integer width = 3072
integer height = 660
integer weight = 700
long textcolor = 16711680
string text = "Scan Receipt"
end type

type gb_1 from so_groupbox within w_mat_other_receipt_barcode_seoul_master
integer x = 640
integer y = 196
integer width = 4165
integer height = 376
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_mat_other_receipt_barcode_seoul_master
integer x = 3877
integer y = 592
integer width = 663
integer height = 644
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_5 from so_groupbox within w_mat_other_receipt_barcode_seoul_master
integer x = 3099
integer y = 588
integer width = 763
integer height = 644
integer taborder = 40
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

