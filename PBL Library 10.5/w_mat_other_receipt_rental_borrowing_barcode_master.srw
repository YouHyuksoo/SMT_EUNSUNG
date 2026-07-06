HA$PBExportHeader$w_mat_other_receipt_rental_borrowing_barcode_master.srw
$PBExportComments$Material Mass Issue Return Master
forward
global type w_mat_other_receipt_rental_borrowing_barcode_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type uo_dateend from uo_ymd_calendar within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type ddlb_item_code from uo_item_code within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type st_3 from so_statictext within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type st_4 from so_statictext within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type cb_cancel from so_commandbutton within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type st_1 from so_statictext within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type st_status from so_statictext within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type sle_supplier_barcode from so_singlelineedit within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type sle_our_barcode from so_singlelineedit within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type st_2 from so_statictext within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type sle_invoice_no from so_singlelineedit within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type sle_material_mfs from so_singlelineedit within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type st_5 from so_statictext within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type st_6 from so_statictext within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type cbx_old_type from so_checkbox within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type sle_qty from so_singlelineedit within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type st_7 from so_statictext within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type st_8 from so_statictext within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type rb_rental from so_radiobutton within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type rb_borrowing from so_radiobutton within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type ddlb_supplier_code from uo_customer_supplier_code_name within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type sle_return_slip_no from so_singlelineedit within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type st_9 from so_statictext within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type rb_normal from so_radiobutton within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type rb_report from so_radiobutton within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type pb_print from so_commandbutton within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type pb_1 from so_commandbutton within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type cbx_check_out_barcode from so_checkbox within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type cbx_no_supplier_barcode from so_checkbox within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type rb_lg_return from so_radiobutton within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type st_10 from so_statictext within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type ddlb_supplier_code_cond from uo_customer_supplier_code_name within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type rb_lg_return_scan from so_radiobutton within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type cbx_check_request_qty from so_checkbox within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type gb_2 from so_groupbox within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type gb_4 from so_groupbox within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type gb_1 from so_groupbox within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type gb_3 from so_groupbox within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type gb_5 from so_groupbox within w_mat_other_receipt_rental_borrowing_barcode_master
end type
type gb_6 from so_groupbox within w_mat_other_receipt_rental_borrowing_barcode_master
end type
end forward

global type w_mat_other_receipt_rental_borrowing_barcode_master from w_main_root
integer width = 5129
integer height = 3228
string title = "Material Barcode Rental/Borrowing Master"
uo_dateset uo_dateset
uo_dateend uo_dateend
ddlb_item_code ddlb_item_code
st_3 st_3
st_4 st_4
cb_cancel cb_cancel
st_1 st_1
st_status st_status
sle_supplier_barcode sle_supplier_barcode
sle_our_barcode sle_our_barcode
st_2 st_2
sle_invoice_no sle_invoice_no
sle_material_mfs sle_material_mfs
st_5 st_5
st_6 st_6
cbx_old_type cbx_old_type
sle_qty sle_qty
st_7 st_7
st_8 st_8
rb_rental rb_rental
rb_borrowing rb_borrowing
ddlb_supplier_code ddlb_supplier_code
sle_return_slip_no sle_return_slip_no
st_9 st_9
rb_normal rb_normal
rb_report rb_report
pb_print pb_print
pb_1 pb_1
cbx_check_out_barcode cbx_check_out_barcode
cbx_no_supplier_barcode cbx_no_supplier_barcode
rb_lg_return rb_lg_return
st_10 st_10
ddlb_supplier_code_cond ddlb_supplier_code_cond
rb_lg_return_scan rb_lg_return_scan
cbx_check_request_qty cbx_check_request_qty
gb_2 gb_2
gb_4 gb_4
gb_1 gb_1
gb_3 gb_3
gb_5 gb_5
gb_6 gb_6
end type
global w_mat_other_receipt_rental_borrowing_barcode_master w_mat_other_receipt_rental_borrowing_barcode_master

type variables
string ivs_preview_yn = 'N'
string  lvs_supplier_barcode , lvs_our_barcode ,  lvs_line_type , lvs_lot_no , lvs_item_code  , lvs_return_slip_no  , lvs_from_supplier_code , LVS_LOCATION_CODE
string  LVS_SUPPLIER_CODE , LVS_RECEIPT_TYPE
int      lvi_pos1 , lvi_pos2 , lvi_pos_check
long lvl_receipt_qty , lvl_count   , lvl_row
double  lvl_receipt_sequence 
string lvs_invoice_no , lvs_return_type
end variables

forward prototypes
public function integer wf_receipt_barcode (string arg_type, string arg_receipt_type)
end prototypes

public function integer wf_receipt_barcode (string arg_type, string arg_receipt_type);//================================================
// $$HEX21$$08c604c814bc54cfdcb4200015d6ddc278c7c0c9200044c5ccb2c0c920006cad84bd20005cd5e4b22000$$ENDHEX$$
//================================================

	lvs_supplier_barcode  =sle_supplier_barcode.text
	lvs_our_barcode = sle_our_barcode.text

////=================================================
//// $$HEX11$$00cf3cd554cf200090c7acc778c72000bdacb0c62000$$ENDHEX$$
////=================================================
// IF MID (UPPER (lvs_supplier_barcode), 1, 1) = '['    THEN
//         SELECT  f_get_item_code_from_barcode (:lvs_supplier_barcode)|| '-' || f_get_lot_no_from_barcode (:lvs_supplier_barcode) || '-' || f_get_lot_qty_from_barcode (:lvs_supplier_barcode)
//		    INTO :lvs_supplier_barcode
//	       FROM DUAL ; 
//		
//		IF F_SQL_CHECK() < 0 THEN 
//				sle_supplier_barcode.selecttext( 1,100)	
//		END IF 	 
//END IF 

//=======================================
// $$HEX11$$00cf3cd554cf200090c7acc778c72000bdacb0c62000$$ENDHEX$$
//=======================================
// IF MID (UPPER (lvs_our_barcode), 1, 1) = '['    THEN
//         SELECT  f_get_item_code_from_barcode (:lvs_our_barcode)|| '-' || f_get_lot_no_from_barcode (:lvs_our_barcode) || '-' || f_get_lot_qty_from_barcode (:lvs_our_barcode)
//		    INTO :lvs_our_barcode
//	       FROM DUAL ; 
//		
//		IF F_SQL_CHECK() < 0 THEN 
//				sle_our_barcode.selecttext( 1,100)	
//		END IF 	 
//END IF 

if lvs_supplier_barcode = '' then 
	sle_our_barcode.setfocus()
	sle_our_barcode.selecttext( 1,100)
	f_play_sound("$$HEX8$$70ac98b798cc14bc54cfdcb4a4c294ce$$ENDHEX$$.wav")	
	st_status.text = "$$HEX19$$70ac98b798cc200014bc54cfdcb400ac2000a4c294ce18b4c0c920004ac558c5b5c2c8b2e4b2$$ENDHEX$$"
	return -1
end if 

if lvs_supplier_barcode = lvs_our_barcode then 
	st_status.text = "$$HEX19$$d9b37cc75cd5200014bc54cfdcb47cb92000a4c294ce200058d574ba200048c529b4c8b2e4b2$$ENDHEX$$"
	f_play_sound("$$HEX9$$d9b37cc714bc54cfdcb4a4c294ce24c658b9$$ENDHEX$$.wav")
	sle_our_barcode.setfocus()
	sle_our_barcode.selecttext( 1,100)
	return -1 
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
end if 

//==================================================
// $$HEX5$$04c85cd488bc38d62000$$ENDHEX$$
//==================================================
lvs_return_slip_no     = sle_return_slip_no.text 
LVS_SUPPLIER_CODE = DDLB_SUPPLIER_CODE.GETCODE()

//==================================================
// $$HEX10$$f8bbc1c058d62000b4b0edc5200070c88cd62000$$ENDHEX$$
//==================================================
dw_3.retrieve( lvs_supplier_code , lvs_item_code , gvi_organization_id ) 
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
//	st_status.text = "$$HEX15$$6fb8b8d288bc38d600ac20002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$"
//	sle_our_barcode.setfocus()
//	sle_our_barcode.selecttext( 1,100)	
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
//	st_status.text = "$$HEX15$$85c7e0ac18c2c9b774c720002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$"	
//	sle_our_barcode.setfocus()
//	sle_our_barcode.selecttext( 1,100)	
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
//  $$HEX8$$88d4a9ba54cfdcb4200044be50ad2000$$ENDHEX$$
//=========================================================

   lvi_pos_check = pos( lvs_supplier_barcode ,  lvs_item_code , 1 ) 
	
   if lvi_pos_check <= 0 then 
		
		f_play_sound("$$HEX5$$90c7acc788bd7cc758ce$$ENDHEX$$.wav")
		st_status.text = "$$HEX16$$fcd3a9ba88bc38d600ac20007cc758ce200058d5c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$"
		sle_supplier_barcode.text = ''
		sle_our_barcode.text  = ''
		sle_supplier_barcode.setfocus()
		return -1
	end if 

//=========================================================
//  $$HEX11$$85c7e0ac200098ccacb9200004d55cb838c1a4c22000$$ENDHEX$$
//=========================================================
//lvl_receipt_lot_no         =    LONG(f_get_any_no( 'RECEIPT_LOT_NO') )
lvs_line_type                = f_get_line_type_from_item( lvs_item_code )
//==================================================
// $$HEX12$$74c7f8bb74c8acc7200058d594b2c0c92000b4cc6cd02000$$ENDHEX$$
//==================================================

if cbx_check_out_barcode.checked = true then 

			SELECT COUNT(*)
				INTO  :lvl_count
			  FROM IM_ITEM_RECEIPT_BARCODE
			 WHERE ITEM_CODE = :LVS_ITEM_CODE 
				AND LOT_NO = :lvs_lot_no
				AND ORGANIZATION_ID  = :GVI_ORGANIZATION_ID ;
			
			IF F_SQL_CHECK() < 0 THEN 
				sle_our_barcode.setfocus( )
				sle_our_barcode.text = ''	
				return -1 
			END IF 
			
			if  lvl_count = 0  then	
				f_play_sound("$$HEX6$$acc2bdb974c725b8c6c54cc7$$ENDHEX$$.wav")	
				st_status.text = LVS_OUR_BARCODE+' $$HEX14$$14bc54cfdcb42000ddc031c1200074c725b82000c6c5b5c2c8b2e4b2$$ENDHEX$$'
				sle_our_barcode.setfocus( )
				sle_our_barcode.text = ''
				return -1
			end if 
			
			//===========================================
			// $$HEX16$$85c7e0ac200074c725b82000c6c53cc774ba200018bc88d4200088bd00ac2000$$ENDHEX$$
			//===========================================
			SELECT COUNT(*)
				INTO  :lvl_count
			  FROM IM_ITEM_INVENTORY
			 WHERE ITEM_CODE = :LVS_ITEM_CODE 
				AND MATERIAL_MFS = :lvs_lot_no
				AND ORGANIZATION_ID  = :GVI_ORGANIZATION_ID ;			
			
			IF F_SQL_CHECK() < 0 THEN 
				sle_our_barcode.setfocus( )
				sle_our_barcode.text = ''	
				return -1 
			END IF 
			
			if  lvl_count = 0  then	
				f_play_sound("$$HEX6$$acc2bdb974c725b8c6c54cc7$$ENDHEX$$.wav")	
				st_status.text = LVS_OUR_BARCODE+' $$HEX5$$14bc54cfdcb4200085c7$$ENDHEX$$/$$HEX12$$9ccde0ac200074c725b874c720002000c6c5b5c2c8b2e4b2$$ENDHEX$$'
				sle_our_barcode.setfocus( )
				sle_our_barcode.text = ''
				return -1
			end if 			 		
			
end if 

//=====================================================
//
//=====================================================
if cbx_check_request_qty.checked = true then 
	     long lvi_check_request
		  
	     select sum(request_qty) into :lvi_check_request 
		  from IM_ITEM_RECEIPT_RETURN_REQUEST
		 where  INVOICE_NO   = :lvs_return_slip_no
			    and ITEM_CODE =      :LVS_ITEM_CODE
				and organization_id = :gvi_organization_id  ;
				
		  if f_sql_check() <  0 then 
			sle_our_barcode.setfocus()
			sle_our_barcode.selecttext( 1,100)
			return -1 
		 end if 	
				 
		  if  lvi_check_request < lvl_receipt_qty then 
				rollback;
				st_status.text = lvs_item_code+' $$HEX17$$e0c2adcc18c2c9b744c7200008cdfcac200060d5200018c22000c6c5b5c2c8b2e4b2$$ENDHEX$$'		
				sle_our_barcode.setfocus()
				sle_our_barcode.selecttext( 1,100)
				return -1 
		end if 

end if 
//====================================================
// $$HEX16$$20c7c4c928c500ac2000e0c2adcc20005cd52000b4b0edc52000b4cc6cd02000$$ENDHEX$$
// $$HEX12$$e0c2adccc6c53cc774ba200018bc88d4200088bd00ac2000$$ENDHEX$$
// $$HEX27$$d8c5c0c918bc88d42000a4c294ce40c72000e0c2adcc2000b4cc6cd048c5200058d5e0ac200014bc5cb82000ddc031c174d50cc92000$$ENDHEX$$
//====================================================
IF rb_lg_return_scan.checked = true then 
	//$$HEX15$$e0c2adcc74c725b844c7200070c88cd6200058d5c0c920004ac54cc72000$$ENDHEX$$
else
		if f_check_return_request_slip_exists ( lvs_return_slip_no , lvs_item_code ) < 1  then 
				f_play_sound("$$HEX6$$acc2bdb974c725b8c6c54cc7$$ENDHEX$$.wav")	
				st_status.text = lvs_item_code+' $$HEX5$$88d4a9ba200000b3ecc5$$ENDHEX$$/$$HEX14$$c1c058d62000e0c2adcc200074c725b874c72000c6c5b5c2c8b2e4b2$$ENDHEX$$'	
				sle_our_barcode.setfocus( )
				sle_our_barcode.text = ''
				return -1
		end if 
end if 

		//====================================================
		// $$HEX17$$74c7f8bb200085c7e0ac200018bc88d4200018b4c8c594b2c0c92000b4cc6cd02000$$ENDHEX$$
		//====================================================
		
		if cbx_check_out_barcode.checked = true then 
				
				 SELECT COUNT(*) INTO :LVL_COUNT 
					 FROM IM_ITEM_RECEIPT_BARCODE
				  WHERE  ITEM_CODE = :LVS_ITEM_CODE 
				       AND LOT_NO       = :lvs_lot_no
					  AND RETURN_YN   = 'Y'
					  AND ORGANIZATION_ID = :gvi_ORganization_id   	 ;
						 
				  if f_sql_check() <  0 then 
					sle_our_barcode.setfocus()
					sle_our_barcode.selecttext( 1,100)
					return -1 
				 end if 	
				
				if LVL_COUNT > 0 THEN 
					st_status.text = lvs_item_code+' $$HEX11$$74c7f8bb200098ccacb9200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$.'		
					sle_our_barcode.setfocus()
					sle_our_barcode.selecttext( 1,100)
					return -1 
				END IF 
	
		end if 
		
		//===========================================
		// $$HEX10$$e0ac1dacacc0200018bca9b078c7bdacb0c62000$$ENDHEX$$
		//===========================================
		if rb_lg_return_scan.checked = true then 
			
			if f_check_return_request_slip_exists ( lvs_return_slip_no , lvs_item_code ) > 0  then 
			else
							lvl_row= DW_1.INSERTROW(0)
							F_SET_SECURITY_ROW(DW_1 , lvl_row ,'ALL')
							
							DW_1.object.item_code[lvl_row] = lvs_item_code
							DW_1.object.request_qty[lvl_row] =lvl_receipt_qty
							DW_1.object.supplier_code[lvl_row] = lvs_supplier_code
							
							DW_1.object.return_date[lvl_row] = f_t_sysdate()
							DW_1.object.return_status[lvl_row] = 'N'
							DW_1.object.invoice_no[lvl_row]   = sle_return_slip_no.text
							DW_1.object.return_type[lvl_row] = 'R'  
							DW_1.object.reel_qty[lvl_row] =0	
							
							IF DW_1.UPDATE() < 0 THEN 
								ROLLBACK;
							END IF 
				end if 
		end if 		
		


			update IM_ITEM_RECEIPT_RETURN_REQUEST 
				  set reel_qty = nvl(reel_qty,0)  + 1 , 
					   return_qty = nvl(return_qty,0) + :lvl_receipt_qty 
			where INVOICE_NO   = :lvs_return_slip_no
			    and ITEM_CODE =      :LVS_ITEM_CODE
				and organization_id = :gvi_organization_id 
				;
			
			  if f_sql_check() <  0 then 
				sle_our_barcode.setfocus()
				sle_our_barcode.selecttext( 1,100)
				return -1 
			end if 		

//====================================================
// $$HEX13$$85c7e0ac200044c6ccb820000cd598b7f8ad200024c115c82000$$ENDHEX$$
//====================================================

if cbx_check_out_barcode.checked = true then 

	UPDATE IM_ITEM_RECEIPT_BARCODE
			SET RETURN_YN = 'Y' , 
				 RETURN_DATE = SYSDATE ,
				 RECEIPT_COMPARE_YN = 'N' , 
				 RECEIPT_COMPARE_DATE = NULL,
				 TO_SUPPLIER_CODE = 	 :LVS_SUPPLIER_CODE
	  WHERE ITEM_CODE = :LVS_ITEM_CODE 
	      AND LOT_NO               = :lvs_lot_no
		  AND ORGANIZATION_ID = :GVI_ORganization_id  ;
			 
	  if f_sql_check() <  0 then 
		sle_our_barcode.setfocus()
		sle_our_barcode.selecttext( 1,100)
		return -1 
	end if 
	
end if 



//====================================================
//
//====================================================

			lvl_receipt_sequence = F_GET_SEQUENCE('SEQ_MAT_RECEIPT')

			LVS_LOCATION_CODE = 'M01'
			
			SELECT MIN(LOCATION_CODE) 
			   INTO :LVS_LOCATION_CODE
			  FROM IM_ITEM_INVENTORY
			 WHERE ITEM_CODE        = :LVS_ITEM_CODE
			     AND MATERIAL_MFS   = :lvs_lot_no
				 AND INVENTORY_QTY > 0 
				 AND ORGANIZATION_ID = :GVI_ORGANization_id ;
				 
			IF F_SQL_CHECK() < 0 THEN 
				sle_our_barcode.setfocus()
				sle_our_barcode.selecttext( 1,100)
				return -1 
			END IF 
			
			if LVS_LOCATION_CODE = '' or isnull(LVS_LOCATION_CODE) then 
				LVS_LOCATION_CODE = 'M01'
			end if 
				
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
							  CLOSE_DATE , 
							  FROM_SUPPLIER_CODE)  
							  
					 VALUES( :lvl_receipt_sequence ,  //RECEIPT_SEQUENCE,   
							  TRUNC(SYSDATE),      //RECEIPT_DATE,   
							  1,      //ORGANIZATION_ID,   
							   :LVS_LOCATION_CODE , // 'M01',      //LOCATION_CODE,   
							  1,      //DELIVERY,   
							  2,      //RECEIPT_DEFICIT,   
							  :lvs_line_type ,      //LINE_TYPE,   
							  :lvl_receipt_qty * -1  ,      //RECEIPT_QTY,   
							  0,      //MATERIAL_COST,   
							  0 ,      //UNIT_PRICE,   
							  0,      //MATERIAL_COST_AMT,   
							  sysdate,      //ENTER_DATE,   
							  :lvs_return_slip_no, //:lvs_slip_no ,      //INVOICE_NO,   
							  0 ,     //RECEIPT_AMT,   
							  :GVS_USER_ID ,      //ENTER_BY,   
							  1,      //EXCHANGE_RATE,   
							  0,      //FOREIGN_RECEIPT_AMT,   
							  :LVS_SUPPLIER_CODE ,      //SUPPLIER_CODE,   
							  SYSDATE,      //LAST_MODIFY_DATE,   
							  :GVS_USER_ID ,      //LAST_MODIFY_BY,   
							  'N',      //CONFIRM_YN,   
							  TRUNC(SYSDATE),      //CONFIRM_DATE,   
							  :arg_receipt_type,      //RECEIPT_TYPE,   
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
							  :lvs_return_slip_no , //:LVL_RECEIPT_LOT_NO ,      //RECEIPT_LOT_NO,   
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
							  'N',      //CLOSE_YN,   
							  NULL,
							  :lvs_from_supplier_code)      //CLOSE_DATE
						  ;
						 
			 if  f_sql_check() < 0 then
				f_play_sound("$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav")
				st_status.text = '$$HEX18$$85c7e0ac98ccacb9200011c9200024c658b900ac20001cbcddc0200088d5b5c2c8b2e4b2$$ENDHEX$$'
				sle_our_barcode.text=''
				sle_our_barcode.setfocus()
				return -1
			end if
	
commit;

//==============================================
//  $$HEX17$$98ccacb92000b4b0edc52000acb9a4c2b8d22000f4bcecc5fcc830aeccb9200068d5$$ENDHEX$$.
//==============================================

lvl_row = 0 ;

lvl_row = dw_2.insertrow(1)
dw_2.object.origin_mfs[lvl_row]     = lvs_supplier_barcode
dw_2.object.item_code[lvl_row]     = lvs_item_code
dw_2.object.receipt_qty[lvl_row]    = lvl_receipt_qty * -1
dw_2.object.material_mfs[lvl_row] = lvs_lot_no

//==============================================
//
//==============================================
f_play_sound("$$HEX4$$00c8a5c731c1f5ac$$ENDHEX$$.wav")
st_status.text = '$$HEX10$$15c8c1c098ccacb9200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$'
sle_supplier_barcode.text = ''
sle_our_barcode.text = ''
sle_qty.text = ''
sle_supplier_barcode.setfocus( )

return  1
end function

on w_mat_other_receipt_rental_borrowing_barcode_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.ddlb_item_code=create ddlb_item_code
this.st_3=create st_3
this.st_4=create st_4
this.cb_cancel=create cb_cancel
this.st_1=create st_1
this.st_status=create st_status
this.sle_supplier_barcode=create sle_supplier_barcode
this.sle_our_barcode=create sle_our_barcode
this.st_2=create st_2
this.sle_invoice_no=create sle_invoice_no
this.sle_material_mfs=create sle_material_mfs
this.st_5=create st_5
this.st_6=create st_6
this.cbx_old_type=create cbx_old_type
this.sle_qty=create sle_qty
this.st_7=create st_7
this.st_8=create st_8
this.rb_rental=create rb_rental
this.rb_borrowing=create rb_borrowing
this.ddlb_supplier_code=create ddlb_supplier_code
this.sle_return_slip_no=create sle_return_slip_no
this.st_9=create st_9
this.rb_normal=create rb_normal
this.rb_report=create rb_report
this.pb_print=create pb_print
this.pb_1=create pb_1
this.cbx_check_out_barcode=create cbx_check_out_barcode
this.cbx_no_supplier_barcode=create cbx_no_supplier_barcode
this.rb_lg_return=create rb_lg_return
this.st_10=create st_10
this.ddlb_supplier_code_cond=create ddlb_supplier_code_cond
this.rb_lg_return_scan=create rb_lg_return_scan
this.cbx_check_request_qty=create cbx_check_request_qty
this.gb_2=create gb_2
this.gb_4=create gb_4
this.gb_1=create gb_1
this.gb_3=create gb_3
this.gb_5=create gb_5
this.gb_6=create gb_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.ddlb_item_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.cb_cancel
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.st_status
this.Control[iCurrent+9]=this.sle_supplier_barcode
this.Control[iCurrent+10]=this.sle_our_barcode
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.sle_invoice_no
this.Control[iCurrent+13]=this.sle_material_mfs
this.Control[iCurrent+14]=this.st_5
this.Control[iCurrent+15]=this.st_6
this.Control[iCurrent+16]=this.cbx_old_type
this.Control[iCurrent+17]=this.sle_qty
this.Control[iCurrent+18]=this.st_7
this.Control[iCurrent+19]=this.st_8
this.Control[iCurrent+20]=this.rb_rental
this.Control[iCurrent+21]=this.rb_borrowing
this.Control[iCurrent+22]=this.ddlb_supplier_code
this.Control[iCurrent+23]=this.sle_return_slip_no
this.Control[iCurrent+24]=this.st_9
this.Control[iCurrent+25]=this.rb_normal
this.Control[iCurrent+26]=this.rb_report
this.Control[iCurrent+27]=this.pb_print
this.Control[iCurrent+28]=this.pb_1
this.Control[iCurrent+29]=this.cbx_check_out_barcode
this.Control[iCurrent+30]=this.cbx_no_supplier_barcode
this.Control[iCurrent+31]=this.rb_lg_return
this.Control[iCurrent+32]=this.st_10
this.Control[iCurrent+33]=this.ddlb_supplier_code_cond
this.Control[iCurrent+34]=this.rb_lg_return_scan
this.Control[iCurrent+35]=this.cbx_check_request_qty
this.Control[iCurrent+36]=this.gb_2
this.Control[iCurrent+37]=this.gb_4
this.Control[iCurrent+38]=this.gb_1
this.Control[iCurrent+39]=this.gb_3
this.Control[iCurrent+40]=this.gb_5
this.Control[iCurrent+41]=this.gb_6
end on

on w_mat_other_receipt_rental_borrowing_barcode_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.ddlb_item_code)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.cb_cancel)
destroy(this.st_1)
destroy(this.st_status)
destroy(this.sle_supplier_barcode)
destroy(this.sle_our_barcode)
destroy(this.st_2)
destroy(this.sle_invoice_no)
destroy(this.sle_material_mfs)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.cbx_old_type)
destroy(this.sle_qty)
destroy(this.st_7)
destroy(this.st_8)
destroy(this.rb_rental)
destroy(this.rb_borrowing)
destroy(this.ddlb_supplier_code)
destroy(this.sle_return_slip_no)
destroy(this.st_9)
destroy(this.rb_normal)
destroy(this.rb_report)
destroy(this.pb_print)
destroy(this.pb_1)
destroy(this.cbx_check_out_barcode)
destroy(this.cbx_no_supplier_barcode)
destroy(this.rb_lg_return)
destroy(this.st_10)
destroy(this.ddlb_supplier_code_cond)
destroy(this.rb_lg_return_scan)
destroy(this.cbx_check_request_qty)
destroy(this.gb_2)
destroy(this.gb_4)
destroy(this.gb_1)
destroy(this.gb_3)
destroy(this.gb_5)
destroy(this.gb_6)
end on

event activate;call super::activate;/***************************************
* Window Default Property 
****************************************/
Gst_set.window_id            = this.classname() 
Gst_set.author                  = "JiSheng"
Gst_set.creation_date      = '20051101'
Gst_set.last_modify_date = '20051101'
Gst_set.Report_window    = True  // Report Window  True / Flase

/*****************************************
* Data Window Property
******************************************/
Ivs_resize_type                      = 'MASTER_DETAIL_12T_3B'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
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
F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control






end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
st_status.width = dw_1.width + dw_2.width
sle_return_slip_no.setfocus()
f_play_sound("$$HEX6$$acc2bdb988bc38d6a4c294ce$$ENDHEX$$.wav")

//====================================
// $$HEX22$$acb9ecd3b8d2200000adacb9d0c52000f1b45db818b4b4c5200088c73cc774ba200014bcd4af00c9e4b22000$$ENDHEX$$
//====================================

STRING ls_syntax

ls_syntax   =   f_get_dataobject('REPORT', upper(THIS.CLASSNAME()) ,  string( dw_4.dataobject )   )
if   ls_syntax = '' or isnull(ls_syntax) then
   f_msg_mdi_help("Report Not Changed")
   
else
   dw_4.create(ls_syntax)
   dw_4.settransobject(sqlca)
   f_set_column_dddw(dw_4)
   f_dual_lang_change_dwtext(dw_4)
   f_msg_mdi_help("Report Changed")
end if
end event

event ue_data_control;call super::ue_data_control;long row, i 
string lvs_date
double lvd_seq
Decimal  lvd_qty, lvd_packing_qty, lvd_request_qty, lvd_issue_qty
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
		   rb_rental.checked = true 
		
		if rb_normal.checked = true then 
			dw_1.reset()
			dw_1.retrieve(  uo_dateset.text() , uo_dateend.text() ,  ddlb_item_code.text()+'%' ,   sle_invoice_no.text+'%' ,  ddlb_supplier_code_cond.getcode()+'%' ,   gvi_organization_id)
			sle_supplier_barcode.setfocus()
		else
			
			dw_4.reset()
			dw_4.retrieve(  sle_invoice_no.text+'%' , gvi_organization_id)
			sle_supplier_barcode.setfocus()		
			
		end if 
		
	case 'INSERT'

			ROW = DW_1.INSERTROW(0)
			DW_1.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_1 , ROW ,'ALL')
			DW_1.object.return_date[row] = f_t_sysdate()
	         DW_1.object.return_status[row] = 'N'
	         DW_1.object.return_condition[row] = 'N'				
			DW_1.object.invoice_no[row] = string(f_t_sysdate(),'yymmdd')+string(f_get_sequence('SEQ_ISSUE_INVOICE_SEQUENCE'))
	case 'DELETE'
		
		  	if DW_1.AcceptText() = -1 then
				return
			end if
			
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			IF MSG = 1 THEN
				Gvl_row_deleted = DW_1.GetRow()			
				DW_1.DELETEROW(Gvl_row_deleted)		
				DW_1.SetFocus()
				ROW = DW_1.GetRow()
				DW_1.ScrollToRow(row)
				DW_1.SetColumn(1)
			END IF				
	case 'UPDATE'
		
			IF dw_1.UPDATE() < 0   THEN
				ROLLBACK;
				RETURN					
			ELSE
				COMMIT;
				F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"		 
			END IF

	case else
end choose

end event

event open;call super::open;sle_return_slip_no.setfocus()
end event

event clicked;call super::clicked;sle_return_slip_no.setfocus()
end event

event resize;call super::resize;st_status.width = dw_1.width + dw_2.width
end event

type dw_5 from w_main_root`dw_5 within w_mat_other_receipt_rental_borrowing_barcode_master
integer y = 1148
integer width = 2267
integer height = 1004
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_mat_other_receipt_rental_borrowing_barcode_master
integer y = 1056
integer width = 2267
integer height = 1004
integer taborder = 0
boolean titlebar = true
string dataobject = "d_mat_receipt_4_rental_borrowing_request_rpt"
end type

type dw_3 from w_main_root`dw_3 within w_mat_other_receipt_rental_borrowing_barcode_master
integer y = 2164
integer width = 4562
integer height = 576
integer taborder = 0
boolean titlebar = true
string title = "Borrowing List"
string dataobject = "d_mat_rceipt_barcode_4_receipt_returnt_lst"
end type

type dw_2 from w_main_root`dw_2 within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 2971
integer y = 1036
integer width = 1591
integer height = 1124
integer taborder = 0
boolean titlebar = true
string title = "Receipt Scan History"
string dataobject = "d_mat_receipt_4_barcode_compare_view"
borderstyle borderstyle = styleraised!
end type

type dw_1 from w_main_root`dw_1 within w_mat_other_receipt_rental_borrowing_barcode_master
integer y = 1024
integer width = 2967
integer height = 1124
integer taborder = 0
boolean titlebar = true
string title = "Return Request List"
string dataobject = "d_mat_receipt_return_4_request_lst"
end type

event dw_1::clicked;call super::clicked;sle_supplier_barcode.setfocus()


end event

event dw_1::buttonclicked;call super::buttonclicked;if dwo.name  = 'b_copy' then 
   	dw_1.rowscopy( row,row,primary!, dw_1, row+1 ,primary!)
	dw_1.scrolltorow(row+1)	
	dw_1.object.item_code[row] = ''
	dw_1.object.reel_qty[row] = 0
	dw_1.object.return_qty[row] = 0
end if 
end event

event dw_1::editchanged;call super::editchanged;if dwo.name = 'item_code' then 
		IF GVS_ITEM_SEARCH_YN = 'Y' THEN
				if this.object.item_code[row] = '' then
				else
						openwithparm(w_item_search_flat ,string(this.object.item_code[row]) )
						this.object.item_code[row]= message.stringparm
				end if 
		END IF
end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_other_receipt_rental_borrowing_barcode_master
integer taborder = 0
end type

type uo_dateset from uo_ymd_calendar within w_mat_other_receipt_rental_borrowing_barcode_master
event destroy ( )
integer x = 814
integer y = 328
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_other_receipt_rental_borrowing_barcode_master
event destroy ( )
integer x = 1230
integer y = 328
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_item_code from uo_item_code within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 1646
integer y = 328
integer width = 558
integer height = 676
integer taborder = 0
boolean bringtotop = true
end type

event selectionchanged;call super::selectionchanged;sle_supplier_barcode.setfocus()
end event

type st_3 from so_statictext within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 1646
integer y = 248
integer width = 558
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type st_4 from so_statictext within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 818
integer y = 248
integer width = 814
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Receipt Date"
end type

type cb_cancel from so_commandbutton within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 4014
integer y = 284
integer width = 475
integer height = 112
boolean bringtotop = true
string text = "Cancel"
end type

event clicked;call super::clicked;open(w_mat_receipt_cancel_4_barcode_popup)
end event

type st_1 from so_statictext within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 1408
integer y = 800
integer width = 590
integer height = 76
boolean bringtotop = true
integer textsize = -10
long textcolor = 16711680
string text = "Supplier Barcode"
alignment alignment = right!
end type

type st_status from so_statictext within w_mat_other_receipt_rental_borrowing_barcode_master
integer width = 5115
integer height = 156
boolean bringtotop = true
integer textsize = -22
integer weight = 700
long textcolor = 16711935
long backcolor = 12639424
string text = "Message"
end type

type sle_supplier_barcode from so_singlelineedit within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 2016
integer y = 768
integer width = 1614
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
textcase textcase = upper!
end type

event getfocus;call super::getfocus;if ddlb_supplier_code.getcode() = '' or ddlb_supplier_code.getcode()  = '%'  or ddlb_supplier_code.getcode()   = '*' then 
	ddlb_supplier_code.setfocus()
	return 
end if 
st_status.text = "$$HEX15$$70ac98b798cc200014bc54cfdcb47cb92000a4c294ce200058d538c194c6$$ENDHEX$$"
this.selecttext( 1,100)
end event

event modified;call super::modified;

if ddlb_supplier_code.getcode() = '' or ddlb_supplier_code.getcode() = '*' or ddlb_supplier_code.getcode() = '%' then 
	
	st_status.text = "$$HEX11$$70ac98b798cc7cb9200020c1ddd0200058d538c194c6$$ENDHEX$$."
	f_play_sound("$$HEX9$$70ac98b798cc7cb920c1ddd058d538c194c6$$ENDHEX$$.wav")
	this.text = ''
	
	ddlb_supplier_code.setfocus()
	return 
end if 

if sle_return_slip_no.text = '' or sle_return_slip_no.text  = '*' or sle_return_slip_no.text  = '%' then 
	
	st_status.text = "$$HEX10$$04c85cd488bc38d6200085c7200058d538c194c6$$ENDHEX$$."
	f_play_sound("$$HEX6$$acc2bdb988bc38d6a4c294ce$$ENDHEX$$.wav")
	
	this.text = ''
    sle_return_slip_no.setfocus()
	return 
else
	lvs_return_slip_no = sle_return_slip_no.text
end if 

if cbx_no_supplier_barcode.checked = true then 
	this.text = this.text+'NB'
end if 

sle_our_barcode.setfocus()
end event

type sle_our_barcode from so_singlelineedit within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 2016
integer y = 884
integer width = 1614
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
textcase textcase = upper!
end type

event getfocus;call super::getfocus;
if ddlb_supplier_code.getcode() = '' or ddlb_supplier_code.getcode()  = '%'  or ddlb_supplier_code.getcode()   = '*' then 
     st_status.text = "$$HEX14$$00b3c1c0200070ac98b798cc7cb9200020c1ddd0200058d538c194c6$$ENDHEX$$"
	 f_play_sound("$$HEX11$$00b3c1c070ac98b798cc7cb920c1ddd058d538c194c6$$ENDHEX$$.wav")
	ddlb_supplier_code.setfocus()
	return 
end if 
f_play_sound("$$HEX7$$90c7acc014bc54cfdcb4a4c294ce$$ENDHEX$$.wav")
this.selecttext( 1,100)
end event

event modified;call super::modified;if cbx_old_type.checked = true then 
	sle_qty.setfocus()
else
	if rb_rental.checked = true then 
		wf_receipt_barcode('N' , 'T') //$$HEX5$$00b3ecc518bca9b02000$$ENDHEX$$
	elseif rb_borrowing.checked = true then 
		wf_receipt_barcode('N' , 'B') //$$HEX4$$28cca9c618bca9b0$$ENDHEX$$
	else
		wf_receipt_barcode('N' , 'U') //$$HEX6$$e0ac1dacacc018bca9b02000$$ENDHEX$$
	end if 
end if 
end event

type st_2 from so_statictext within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 1408
integer y = 908
integer width = 590
integer height = 60
boolean bringtotop = true
integer textsize = -10
long textcolor = 16711680
string text = "Our Barcode"
alignment alignment = right!
end type

type sle_invoice_no from so_singlelineedit within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 2208
integer y = 328
integer width = 507
integer height = 88
boolean bringtotop = true
end type

type sle_material_mfs from so_singlelineedit within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 2725
integer y = 328
integer height = 88
boolean bringtotop = true
end type

type st_5 from so_statictext within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 2203
integer y = 248
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Invoice No"
end type

type st_6 from so_statictext within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 2720
integer y = 248
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Material MFS"
end type

type cbx_old_type from so_checkbox within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 3648
integer y = 560
integer width = 718
boolean bringtotop = true
string text = "Old Type Barcode"
end type

event clicked;call super::clicked;if this.checked = true then 
	sle_qty.enabled = true
else
	sle_qty.enabled = false
end if 

sle_supplier_barcode.setfocus( )
end event

type sle_qty from so_singlelineedit within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 3973
integer y = 880
integer width = 393
integer height = 112
boolean bringtotop = true
integer textsize = -10
boolean enabled = false
textcase textcase = upper!
end type

event modified;call super::modified;if cbx_old_type.checked = true then 
	if rb_rental.checked = true then 
		wf_receipt_barcode('O' , 'T') //$$HEX5$$00b3ecc518bca9b02000$$ENDHEX$$
	elseif rb_borrowing.checked = true then 
		wf_receipt_barcode('O' , 'B') //$$HEX4$$28cca9c618bca9b0$$ENDHEX$$
	else
		wf_receipt_barcode('O' , 'U') //$$HEX6$$e0ac1dacacc018bca9b02000$$ENDHEX$$
	end if 
end if 


end event

type st_7 from so_statictext within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 3639
integer y = 912
integer width = 306
integer height = 64
boolean bringtotop = true
long textcolor = 16711680
string text = "Qty"
alignment alignment = right!
end type

type st_8 from so_statictext within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 1408
integer y = 684
integer width = 590
integer height = 72
boolean bringtotop = true
integer textsize = -10
long textcolor = 16711680
string text = "To Supplier Code"
alignment alignment = right!
end type

type rb_rental from so_radiobutton within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 105
integer y = 568
integer width = 585
boolean bringtotop = true
integer textsize = -10
string text = "Rental Return"
boolean checked = true
end type

type rb_borrowing from so_radiobutton within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 105
integer y = 664
integer width = 585
boolean bringtotop = true
integer textsize = -10
string text = "Borrowing Return"
end type

type ddlb_supplier_code from uo_customer_supplier_code_name within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 2016
integer y = 664
integer width = 1614
integer height = 2248
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
end type

event selectionchanged;call super::selectionchanged;sle_return_slip_no.setfocus()
end event

type sle_return_slip_no from so_singlelineedit within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 2016
integer y = 552
integer width = 1614
integer height = 108
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
textcase textcase = upper!
end type

event modified;call super::modified;if this.text = '' or isnull(this.text) then 
   sle_return_slip_no.setfocus( )
   return 
end if 

////===============================================
////
////===============================================
//if f_check_slip_exists( this.text)  < 1 then
//	
//	f_play_sound("$$HEX6$$acc2bdb974c725b8c6c54cc7$$ENDHEX$$.wav")	
//	st_status.text = "$$HEX22$$85c725b858d5e0c2200004c85cd4200088bc38d600ac200074c8acc7200058d5c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$."
//	this.text = ''
//	
//	f_msgbox1(813 , this.text) 
//	sle_return_slip_no.setfocus()
//	return 
//end if 

//===============================================
// 
//===============================================
string lvs_to_supplier_code

lvs_to_supplier_code =f_get_to_supplier_by_invoice(this.text)
ddlb_supplier_code.text = lvs_to_supplier_code

dw_1.reset()
dw_1.retrieve(  uo_dateset.text() , uo_dateend.text() ,   ddlb_item_code.text()+'%' ,  this.text+'%' ,   '%' ,   gvi_organization_id)

sle_supplier_barcode.setfocus()
end event

event getfocus;call super::getfocus;this.selecttext( 1,100)
end event

type st_9 from so_statictext within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 1408
integer y = 572
integer width = 590
integer height = 76
boolean bringtotop = true
integer textsize = -10
long textcolor = 255
string text = "Return Invoice No"
alignment alignment = right!
end type

type rb_normal from so_radiobutton within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 73
integer y = 248
integer width = 603
boolean bringtotop = true
string text = "Barcode Scan"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
dw_2.bringtotop = true
end event

type rb_report from so_radiobutton within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 73
integer y = 336
integer width = 603
boolean bringtotop = true
string text = "Return Invoice Report"
end type

event clicked;call super::clicked;dw_4.bringtotop = true
end event

type pb_print from so_commandbutton within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 4539
integer y = 284
integer width = 475
integer height = 112
boolean bringtotop = true
string text = "Print"
end type

event clicked;call super::clicked;if rb_report.checked = true then 
	openwithparm( w_zetprint ,  dw_4)
end if 
end event

type pb_1 from so_commandbutton within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 462
integer y = 872
integer width = 475
integer height = 112
integer taborder = 40
boolean bringtotop = true
string text = "Excel Paste"
end type

event clicked;call super::clicked;
msg = f_msgbox(1160)
//=============================================
//
//=============================================

if msg = 1 then 
    dw_1.reset() 
else
	return 
end if 

dw_1.importclipboard( )

if dw_1.rowcount() < 1 then 
	return 
end if 

int i

if rb_rental.checked = true then 	
		lvs_return_type = 'T'
elseif rb_borrowing.checked = true then 
		lvs_return_type = 'B'
else
	    lvs_return_type = 'R'
end if 

//======================================================================
// $$HEX8$$04c85cd488bc38d62000ddc031c12000$$ENDHEX$$
//======================================================================
lvs_invoice_no = string(f_t_sysdate(),'yymmdd')+string(f_get_sequence('SEQ_ISSUE_INVOICE_SEQUENCE'))
sle_return_slip_no.text =lvs_invoice_no

do
	i++
	
	F_SET_SECURITY_ROW(DW_1 , i ,'ALL')
	DW_1.object.return_date[i] = f_t_sysdate()
	DW_1.object.return_status[i] = 'N'
	DW_1.object.invoice_no[i] = lvs_invoice_no
	DW_1.object.return_type[i] = lvs_return_type 
	DW_1.object.reel_qty[i] =0	
	
//	if f_check_item_exists( string(dw_1.object.item_code[i]) , f_t_sysdate() ) < 0 then 
//		
//	    st_status.text = string(i)+" $$HEX7$$88bc30ca200070b374c730d12000$$ENDHEX$$: "+string(dw_1.object.item_code[i]) 
//		f_play_sound("$$HEX5$$88d4a9baf8bbf1b45db8$$ENDHEX$$.wav")
//		f_msgbox(9041)
//		return
//
//	end if 
	//====================================================
	if f_check_supplier_exists( string(dw_1.object.supplier_code[i]) ) < 1 then 
		
	    st_status.text = string(i)+" $$HEX7$$88bc30ca200070b374c730d12000$$ENDHEX$$: "+string(dw_1.object.supplier_code[i]) +" $$HEX7$$70ac98b798cc2000f8bbf1b45db8$$ENDHEX$$"
		f_msgbox(9041)
     //    return
	end if 	
	
loop until i = dw_1.rowcount()
end event

type cbx_check_out_barcode from so_checkbox within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 3648
integer y = 636
integer width = 718
integer height = 80
boolean bringtotop = true
boolean enabled = false
string text = "Check Our Barcode"
boolean checked = true
end type

type cbx_no_supplier_barcode from so_checkbox within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 3648
integer y = 716
integer width = 718
integer height = 76
boolean bringtotop = true
string text = "No Supplier Barcode"
end type

type rb_lg_return from so_radiobutton within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 741
integer y = 556
integer width = 544
boolean bringtotop = true
integer textsize = -10
string text = "LG Return(Excel)"
end type

type st_10 from so_statictext within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 3237
integer y = 248
integer width = 677
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Supplier Code"
end type

type ddlb_supplier_code_cond from uo_customer_supplier_code_name within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 3237
integer y = 324
integer width = 677
integer height = 2248
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
end type

event selectionchanged;call super::selectionchanged;sle_return_slip_no.setfocus()
end event

type rb_lg_return_scan from so_radiobutton within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 741
integer y = 664
integer width = 594
boolean bringtotop = true
integer textsize = -10
string text = "LG Return(Scan)"
end type

event clicked;call super::clicked;msg = f_msgbox1( 1161 , this.text )
if msg = 1 then 
	
	//======================================================================
	// $$HEX8$$04c85cd488bc38d62000ddc031c12000$$ENDHEX$$
	//======================================================================
	lvs_invoice_no = string(f_t_sysdate(),'yymmdd')+string(f_get_sequence('SEQ_ISSUE_INVOICE_SEQUENCE'))
	sle_return_slip_no.text =lvs_invoice_no
	
	sle_return_slip_no.triggerevent( modified! )
	
	ddlb_supplier_code.setfocus()
end if 
end event

type cbx_check_request_qty from so_checkbox within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 3648
integer y = 788
integer width = 718
integer height = 76
boolean bringtotop = true
string text = "Check Request Qty"
boolean checked = true
end type

type gb_2 from so_groupbox within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 27
integer y = 492
integer width = 1321
integer height = 308
integer weight = 700
long textcolor = 16711680
string text = "Receipt Type"
end type

type gb_4 from so_groupbox within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 1367
integer y = 492
integer width = 3195
integer height = 532
integer weight = 700
long textcolor = 16711680
string text = "Scan"
end type

type gb_1 from so_groupbox within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 782
integer y = 168
integer width = 3168
integer height = 300
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_mat_other_receipt_rental_borrowing_barcode_master
integer y = 168
integer width = 777
integer height = 300
integer weight = 700
long textcolor = 16711680
string text = "Catgory"
end type

type gb_5 from so_groupbox within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 23
integer y = 792
integer width = 1321
integer height = 240
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_6 from so_groupbox within w_mat_other_receipt_rental_borrowing_barcode_master
integer x = 3968
integer y = 172
integer width = 1111
integer height = 300
integer taborder = 40
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

