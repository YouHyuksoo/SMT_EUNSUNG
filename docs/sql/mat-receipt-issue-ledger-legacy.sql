-- 자재입출고수불원장(w_mat_ledger_report) 레거시 DataWindow SQL 스냅샷
-- 출처: infinity21_uw_mat.pbl / infinity21_urd_com.pbl (PBORCA 읽기 전용 export, 2026-09-16)
-- 설계: docs/specs/2026-09-16-material-receipt-issue-ledger-design.md

-- ===== d_mat_daily_receipt_issue_rpt =====
-- ARGS: ("arg_dateset", datetime),("arg_dateend", datetime),("arg_item", string),("arg_lot_no", string),("arg_line_code", string),("arg_workstage_code", string),("arg_deficit", string),("arg_supplier_code", string),("arg_from_supplier_code", string),("arg_location_code", string),("arg_supplier_issue", string),("arg_issue_deficit", string),("arg_etc_line", stringlist),("arg_org", number),("arg_keyitem_yn", string),("arg_inventory_type", string),("arg_w00_yn", string)
-- SORT: organization_id A enter_date A receipt_issue_date D receipt_issue_sequence D 
SELECT A.RCV_ISS_CODE ,
         A.RECEIPT_ISSUE_SEQUENCE,   
         A.RECEIPT_ISSUE_DATE,   
         A.ORGANIZATION_ID,   
         A.RECEIPT_ISSUE_DEFICIT,   
         A.LINE_TYPE,   
         A.QTY,   
         A.MATERIAL_MFS,   
         A.PRICE,   
         A.MATERIAL_COST_AMT,   
         A.INVOICE_NO,   
         A.AMT,   
         A.SUPPLIER_CODE,   
         A.RECEIPT_ISSUE_TYPE ,   

         A.RECEIPT_ISSUE_STATUS,   
         A.ITEM_CODE  ,
	    B.ITEM_NAME,
	    B.ITEM_SPEC,
	    B.ITEM_UOM   ,
		A.ENTER_DATE ,
		A.BARCODE,
		A.FROM_SUPPLIER_CODE ,
		A.LINE_CODE ,
		A.WORKSTAGE_CODE ,
		B.LOCATION_ADDRESS ,
	    A.LOCATION_CODE ,
		A.ORIGIN_MFS ,
		C.LOT_DIVIDE_YN ,
		C.LABEL_TYPE ,
		C.RECEIPT_TYPE ,
		A.FEEDER_LOCATION_CODE ,
		A.FEEDER_SHAFT,
         C.VENDOR_LOTNO,
         C.VENDOR_CODE  ,
         A.MODEL_NAME ,
		A.INVENTORY_TYPE,
         C.MANUFACTURE_WEEK,
         C.led_rank_info,
         c.feeding_date, 
         c.reel_destroy_date
 FROM 
(

  SELECT 'R' RCV_ISS_CODE ,
         RECEIPT_SEQUENCE RECEIPT_ISSUE_SEQUENCE,   
         RECEIPT_DATE           RECEIPT_ISSUE_DATE,   
         ORGANIZATION_ID,   
         RECEIPT_DEFICIT        RECEIPT_ISSUE_DEFICIT,   
         LINE_TYPE,   
         RECEIPT_QTY               QTY,   
         MATERIAL_MFS,   
         UNIT_PRICE                  PRICE,   
         MATERIAL_COST_AMT,   
         INVOICE_NO,   
         RECEIPT_AMT               AMT,   
         SUPPLIER_CODE,   
         RECEIPT_TYPE              RECEIPT_ISSUE_TYPE,   
         RECEIPT_STATUS         RECEIPT_ISSUE_STATUS,   
         ITEM_CODE  ,
		ENTER_DATE ,
		BARCODE ,
		FROM_SUPPLIER_CODE ,
		'' LINE_CODE ,
		'' WORKSTAGE_CODE ,
		LOCATION_CODE ,
		ORIGIN_MFS ,
         '' FEEDER_LOCATION_CODE ,
		'' FEEDER_SHAFT  ,
		'' MODEL_NAME ,
		INVENTORY_TYPE
    FROM IM_ITEM_RECEIPT   
WHERE RECEIPT_DATE >=:ARG_DATESET
      AND RECEIPT_DATE < :ARG_DATEEND +1
      AND ITEM_CODE LIKE :ARG_ITEM
  AND MATERIAL_MFS LIKE :ARG_LOT_NO
	  AND NVL(SUPPLIER_CODE , '*') LIKE :arg_supplier_code
	  AND NVL(FROM_SUPPLIER_CODE , '*') LIKE :arg_from_supplier_code
      AND LOCATION_CODE  LIKE :arg_location_code  
      AND nvl(INVENTORY_TYPE ,'*')  LIKE :arg_inventory_type
      AND ORGANIZATION_ID = :ARG_ORG

UNION  ALL

  SELECT  'I' RCV_ISS_CODE ,
         ISSUE_SEQUENCE  RECEIPT_ISSUE_SEQUENCE,   
         ISSUE_DATE                 RECEIPT_ISSUE_DATE,   
         ORGANIZATION_ID,   
         ISSUE_DEFICIT            RECEIPT_ISSUE_DEFICIT,   
         LINE_TYPE,   
         ISSUE_QTY                   QTY,   
         MATERIAL_MFS ,   
         ISSUE_PRICE               PRICE ,   
         0 MATERIAL_COST_AMT,   
         '' INVOICE_NO,   
         ISSUE_AMT                  AMT,   
         SUPPLIER_CODE,   
         ISSUE_TYPE                 RECEIPT_ISSUE_TYPE,   
         ISSUE_STATUS            RECEIPT_ISSUE_STATUS,   
         ITEM_CODE  ,
         ENTER_DATE ,
         '' BARCODE,
		'' FROM_SUPPLIER_CODE ,
		LINE_CODE ,
		WORKSTAGE_CODE ,
		LOCATION_CODE ,
	    '' ORIGIN_MFS ,
		FEEDER_LOCATION_CODE ,
		FEEDER_SHAFT ,
		MODEL_NAME,
		INVENTORY_TYPE
    FROM IM_ITEM_ISSUE  
 WHERE ISSUE_DATE >= :ARG_DATESET
      AND ISSUE_DATE <  :ARG_DATEEND  +1
      AND ITEM_CODE LIKE :ARG_ITEM
	 AND MATERIAL_MFS LIKE :ARG_LOT_NO
     AND LINE_CODE LIKE :ARG_LINE_CODE
      AND LINE_CODE NOT IN (:arg_etc_line)
      AND WORKSTAGE_CODE LIKE :ARG_WORKSTAGE_CODE
      AND LOCATION_CODE  LIKE :arg_location_code 
      AND NVL(SUPPLIER_CODE,'*') LIKE :arg_supplier_issue
      AND ISSUE_DEFICIT  LIKE :arg_issue_deficit
      AND nvl(INVENTORY_TYPE ,'*')  LIKE :arg_inventory_type
      AND ORGANIZATION_ID = :ARG_ORG 
      AND (
               (:arg_w00_yn = 'Y' ) OR
               ( :arg_w00_yn = 'N' and WORKSTAGE_CODE <> 'W00' )
             )
)   A , ID_ITEM B  , IM_ITEM_RECEIPT_BARCODE C
WHERE A.ITEM_CODE = B.ITEM_CODE
  AND A.ITEM_CODE = C.ITEM_CODE(+)
  AND A.MATERIAL_MFS  = C.LOT_NO(+)
  AND A.RCV_ISS_CODE LIKE :arg_deficit

-- ===== d_mat_ws_receipt_issue_rpt =====
-- ARGS: ("arg_dateset", datetime),("arg_dateend", datetime),("arg_item", string),("arg_lot_no", string),("arg_line_code", string),("arg_workstage_code", string),("arg_deficit", string),("arg_supplier_code", string),("arg_from_supplier_code", string),("arg_location_code", string),("arg_supplier_issue", string),("arg_issue_deficit", string),("arg_etc_line", stringlist),("arg_org", number),("arg_keyitem_yn", string),("arg_inventory_type", string)
-- SORT: organization_id A enter_date A receipt_issue_date D receipt_issue_sequence D 
SELECT A.RCV_ISS_CODE ,
			A.RECEIPT_ISSUE_SEQUENCE,   
			A.RECEIPT_ISSUE_DATE,   
			A.ORGANIZATION_ID,   
			A.RECEIPT_ISSUE_DEFICIT,   
			
			A.QTY,   
			A.ITEM_CODE  ,
			B.ITEM_NAME,
			B.ITEM_SPEC,
			B.ITEM_UOM   ,
			A.ENTER_DATE ,
			B.LOCATION_ADDRESS 
 FROM 
(

  SELECT 'R' RCV_ISS_CODE ,
         RECEIPT_SEQUENCE RECEIPT_ISSUE_SEQUENCE,   
         RECEIPT_DATE           RECEIPT_ISSUE_DATE,   
         ORGANIZATION_ID,   
         RECEIPT_DEFICIT        RECEIPT_ISSUE_DEFICIT,   
    
         RECEIPT_QTY               QTY,   
     
         ITEM_CODE  ,
		ENTER_DATE

    FROM IM_ITEM_WORKSTAGE_RECEIPT   
WHERE RECEIPT_DATE >=:ARG_DATESET
      AND RECEIPT_DATE < :ARG_DATEEND +1
      AND ITEM_CODE LIKE :ARG_ITEM
      AND ORGANIZATION_ID = :ARG_ORG

UNION  ALL

  SELECT  'I' RCV_ISS_CODE ,
         ISSUE_SEQUENCE  RECEIPT_ISSUE_SEQUENCE,   
         ISSUE_DATE                 RECEIPT_ISSUE_DATE,   
         ORGANIZATION_ID,   
         ISSUE_DEFICIT            RECEIPT_ISSUE_DEFICIT,   
   
         ISSUE_QTY                   QTY,   
 
         ITEM_CODE  ,
         ENTER_DATE 
  
    FROM IM_ITEM_WORKSTAGE_ISSUE  
 WHERE ISSUE_DATE >= :ARG_DATESET
      AND ISSUE_DATE <  :ARG_DATEEND  +1
      AND ITEM_CODE LIKE :ARG_ITEM
      AND ORGANIZATION_ID = :ARG_ORG 
)   A , ID_ITEM B 
WHERE A.ITEM_CODE = B.ITEM_CODE
  AND A.RCV_ISS_CODE LIKE :arg_deficit

-- ===== d_mat_receipt_barcode_rpt =====
-- ARGS: ("arg_dateset", datetime),("arg_dateend", datetime),("arg_item_code", string),("arg_lot_no", string),("arg_slip_no", string),("arg_lot_divide", string),("arg_suppliercode", string),("arg_org", number),("arg_keyitem_yn", string)
-- SORT: scan_date A lot_no A 
SELECT "IM_ITEM_RECEIPT_BARCODE"."ITEM_BARCODE",   
         "IM_ITEM_RECEIPT_BARCODE"."SUPPLIER_CODE",   
         "IM_ITEM_RECEIPT_BARCODE"."ITEM_CODE",   
         "IM_ITEM_RECEIPT_BARCODE"."SCAN_DATE",   
         "IM_ITEM_RECEIPT_BARCODE"."LOT_NO",   
         "IM_ITEM_RECEIPT_BARCODE"."SCAN_QTY",   
         "IM_ITEM_RECEIPT_BARCODE"."SUPPLIER_BARCODE",   
         "IM_ITEM_RECEIPT_BARCODE"."SUPPLIER_ITEM_CODE",   
         "IM_ITEM_RECEIPT_BARCODE"."RECEIPT_COMPARE_YN",   
         "IM_ITEM_RECEIPT_BARCODE"."RECEIPT_COMPARE_DATE",   
         "IM_ITEM_RECEIPT_BARCODE"."RECEIPT_COMPARE_BY",   
         "IM_ITEM_RECEIPT_BARCODE"."RECEIPT_SLIP_NO",   
         "IM_ITEM_RECEIPT_BARCODE"."ENTER_DATE",   
         "IM_ITEM_RECEIPT_BARCODE"."ENTER_BY",   
         "IM_ITEM_RECEIPT_BARCODE"."LAST_MODIFY_DATE",   
         "IM_ITEM_RECEIPT_BARCODE"."LAST_MODIFY_BY",   
         "IM_ITEM_RECEIPT_BARCODE"."ORGANIZATION_ID",   
         "IM_ITEM_RECEIPT_BARCODE"."ISSUE_COMPARE_YN",   
         "IM_ITEM_RECEIPT_BARCODE"."ISSUE_COMPARE_DATE",   
         "IM_ITEM_RECEIPT_BARCODE"."ISSUE_COMPARE_BY",   
         "IM_ITEM_RECEIPT_BARCODE"."BARCODE_STATUS",   
         "IM_ITEM_RECEIPT_BARCODE"."RECEIPT_TYPE",   
         "IM_ITEM_RECEIPT_BARCODE"."ISSUE_TYPE",   
         "IM_ITEM_RECEIPT_BARCODE"."FROM_SUPPLIER_CODE",   
         "IM_ITEM_RECEIPT_BARCODE"."LOT_DIVIDE_YN",   
         "IM_ITEM_RECEIPT_BARCODE"."ORIGIN_ITEM_BARCODE",   
         "IM_ITEM_RECEIPT_BARCODE"."LABEL_TYPE",   
         "IM_ITEM_RECEIPT_BARCODE"."SUPPLIER_LOT_NO",   
         "IM_ITEM_RECEIPT_BARCODE"."ORIGIN_SUPPLIER_CODE",   
         "ID_ITEM"."LOCATION_ADDRESS",   
         "IM_ITEM_RECEIPT_BARCODE"."VENDOR_LOTNO",   
         "IM_ITEM_RECEIPT_BARCODE"."VENDOR_CODE"  
    FROM "IM_ITEM_RECEIPT_BARCODE",   
         "ID_ITEM"  
   WHERE ( im_item_receipt_barcode.item_code = id_item.item_code (+)) and  
         ( ( "IM_ITEM_RECEIPT_BARCODE"."SCAN_DATE" >= :arg_dateset ) AND  
         ( "IM_ITEM_RECEIPT_BARCODE"."SCAN_DATE" < :arg_dateend+1 ) AND  
         ( "IM_ITEM_RECEIPT_BARCODE"."ITEM_CODE" like :arg_item_code ) AND  
         ( "IM_ITEM_RECEIPT_BARCODE"."LOT_NO" like :arg_lot_no ) AND  
         ( "IM_ITEM_RECEIPT_BARCODE"."ORGANIZATION_ID" = :arg_org ) AND  
         ( "IM_ITEM_RECEIPT_BARCODE"."RECEIPT_SLIP_NO" like :arg_slip_no ) AND  
         ( NVL("IM_ITEM_RECEIPT_BARCODE"."LOT_DIVIDE_YN" ,'*') like :arg_lot_divide ) AND
         ( "IM_ITEM_RECEIPT_BARCODE"."SUPPLIER_CODE" like :arg_suppliercode ) )    AND
       (NVL( "ID_ITEM"."KEYITEM_YN",'N') like :ARG_KEYITEM_YN )

-- ===== d_mat_item_feeder_layout_detail_rpt =====
-- ARGS: ("arg_item_code", string),("arg_model_name", string),("arg_keyitem_yn", string)
-- SORT: id_eng_bom_smt_child_item_code A id_item_item_name A id_item_item_spec A id_item_location_address A id_item_msl_level A inventory_qty A 
SELECT "ID_ENG_BOM_SMT"."CHILD_ITEM_CODE",   
         "ID_ENG_BOM_SMT"."LINE_CODE",   
         "ID_ENG_BOM_SMT"."ITEM_UNIT_QTY",   
         "ID_ENG_BOM_SMT"."PCB_ITEM",   
         ( select sum(inventory_qty) from im_item_inventory b where b.item_code = id_eng_bom_smt.child_item_code ) inventory_qty,   
         "ID_ITEM"."ITEM_NAME",   
         "ID_ITEM"."ITEM_SPEC",   
         "ID_ITEM"."LOCATION_ADDRESS",   
         "ID_ITEM"."MSL_LEVEL",   
         "ID_ITEM"."MATERIAL_QTY",   
         "ID_ITEM"."MATERIAL_QTY2",   
         ( select sum(inventory_qty) from im_item_workstage_inventory b where b.item_code = id_eng_bom_smt.child_item_code and b.line_code = id_eng_bom_smt.line_code ) workstage_inventory_qty  
    FROM "ID_ENG_BOM_SMT",   
         "ID_ITEM"  
   WHERE ( id_eng_bom_smt.child_item_code = id_item.item_code (+)) and  
         ( id_eng_bom_smt.organization_id = id_item.organization_id (+)) and  
          ( "ID_ENG_BOM_SMT"."CHILD_ITEM_CODE" like :arg_item_code ) AND  
        ( NVL( "ID_ITEM"."KEYITEM_YN",'N')  like :arg_keyitem_yn ) AND  
         ( "ID_ENG_BOM_SMT"."PARENT_ITEM_CODE" like :arg_model_name )

-- ===== d_mat_item_issue_loss_lst =====
-- ARGS: ("arg_dateset", datetime),("arg_dateend", datetime),("arg_line_code", string),("arg_model_name", string),("arg_item_code", string),("arg_material_mfs", string),("arg_org", number),("arg_keyitem_yn", string)
-- SORT: line_code A issue_date A issue_sequence A 
SELECT "IM_ITEM_ISSUE_LOSS"."ISSUE_DATE",   
         "IM_ITEM_ISSUE_LOSS"."ISSUE_SEQUENCE",   
         "IM_ITEM_ISSUE_LOSS"."ITEM_CODE",   
         "IM_ITEM_ISSUE_LOSS"."MATERIAL_MFS",   
         "IM_ITEM_ISSUE_LOSS"."LINE_CODE",   
         "IM_ITEM_ISSUE_LOSS"."MODEL_NAME",   
         "IM_ITEM_ISSUE_LOSS"."ISSUE_QTY",   
         "IM_ITEM_ISSUE_LOSS"."ENTER_DATE",   
         "IM_ITEM_ISSUE_LOSS"."ENTER_BY",   
         "IM_ITEM_ISSUE_LOSS"."LAST_MODIFY_DATE",   
         "IM_ITEM_ISSUE_LOSS"."LAST_MODIFY_BY",   
         "IM_ITEM_ISSUE_LOSS"."ORGANIZATION_ID"  
    FROM "IM_ITEM_ISSUE_LOSS"  ,
              "ID_ITEM" 
   WHERE  ( IM_ITEM_ISSUE_LOSS.item_code = id_item.item_code (+)) and  
         ( IM_ITEM_ISSUE_LOSS.organization_id = id_item.organization_id (+)) and 
         ( "IM_ITEM_ISSUE_LOSS"."ISSUE_DATE" >= :arg_dateset ) AND  
         ( "IM_ITEM_ISSUE_LOSS"."ISSUE_DATE" < :arg_dateend ) AND  
         ( "IM_ITEM_ISSUE_LOSS"."LINE_CODE" like :arg_line_code ) AND  
         ( NVL("IM_ITEM_ISSUE_LOSS"."MODEL_NAME" , '*') like :arg_model_name ) AND  
         ( "IM_ITEM_ISSUE_LOSS"."ITEM_CODE" like :arg_item_code ) AND  
         ( "IM_ITEM_ISSUE_LOSS"."MATERIAL_MFS" like :arg_material_mfs ) AND  
         ( "IM_ITEM_ISSUE_LOSS"."ORGANIZATION_ID" = :arg_org )  AND
         ( NVL("ID_ITEM"."KEYITEM_YN" , 'N') like :arg_keyitem_yn )
