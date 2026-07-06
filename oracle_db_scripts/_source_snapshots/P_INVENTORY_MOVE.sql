PROCEDURE "P_INVENTORY_MOVE" (
   p_item_barcode   IN     VARCHAR2,
   p_fr_location    IN     VARCHAR2,
   p_to_location    IN     VARCHAR2,
   p_err               OUT VARCHAR2)
IS
   lvs_lot_no             VARCHAR2 (30);
   lvs_item_code          VARCHAR2 (100);
   lvs_suppliercode       VARCHAR2 (20);
   lvs_barcode            VARCHAR2 (200);


   lvl_cnt                NUMBER;
   lvi_count              NUMBER;
   lvl_qty                NUMBER;
   lvs_issue_compare_yn   VARCHAR2 (10);
BEGIN
   
      lvs_barcode := f_get_prepare_barcode (p_item_barcode);
      lvs_item_code := f_get_item_code_from_barcode (lvs_barcode);
  
   IF    lvs_barcode = '--'
      OR lvs_barcode IS NULL
      OR LENGTH (lvs_barcode) > 50
      OR LENGTH (lvs_barcode) < 10
   THEN
      p_err := f_msg('[REQ:01] BARCODE INVALID : 바코드형식이틀립니다.','C',1);
      RETURN;
   END IF;

   ----------------------------------------------------------------------
   --
   ----------------------------------------------------------------------
   BEGIN
      SELECT COUNT (*)
        INTO lvi_count
        FROM id_item
       WHERE item_code = lvs_item_code;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_err := f_msg('[REQ:04] ITEM NOT FOUND : 품목마스터가 없습니다.','C',1);
         RETURN;
   END;

   IF NVL (lvi_count, 0) = 0
   THEN
      p_err := f_msg('[REQ:04] ITEM NOT FOUND : 품목마스터가 없습니다.','C',1);
      RETURN;
   END IF;

   BEGIN
      SELECT SUPPLIER_CODE
        INTO lvs_suppliercode
        FROM id_item
       WHERE item_code = lvs_item_code;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvs_suppliercode := '';
   END;


   ----------------------------------------------------------------------
   --  INVENTORY CHECK
   ----------------------------------------------------------------------
  
      lvs_lot_no := f_get_lot_no_from_barcode (p_item_barcode);
  
   BEGIN
      SELECT COUNT (*)
        INTO lvl_cnt
        FROM IM_ITEM_INVENTORY
       WHERE item_code = UPPER (lvs_item_code)
             AND material_mfs = UPPER (lvs_lot_no);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvl_cnt := 0;
   END;


   IF lvl_cnt = 0
   THEN
      p_err :=
            f_msg('[REQ:05] INVENTORY NOT FOUND : 재고없는품목 : ' ,'C',1) 
         || lvs_item_code
         || ' '
         || lvs_lot_no;
      RETURN;
   END IF;

   --------------------------------------------------------------
   --
   --------------------------------------------------------------
   BEGIN
      SELECT NVL (issue_compare_yn, 'N')
        INTO lvs_issue_compare_yn
        FROM IM_ITEM_receipt_barcode
       WHERE lot_no = UPPER (lvs_lot_no);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvs_issue_compare_yn := 'N';
   END;


   IF lvs_issue_compare_yn = 'Y'
   THEN
      p_err :=
            f_msg('[MOVE:05] 출고 반품 후 이동하세요 : ' ,'C',1) 
         || lvs_item_code
         || ' '
         || lvs_lot_no;
      RETURN;
   END IF;

   ------------------------------------------------------------------
   --재고수량
   ------------------------------------------------------------------
   BEGIN
      SELECT NVL (inventory_qty, 0)
        INTO lvl_qty
        FROM IM_ITEM_INVENTORY
       WHERE     item_code = UPPER (lvs_item_code)
             AND material_mfs = UPPER (lvs_lot_no)
             AND location_code = UPPER (p_fr_location);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvl_qty := 0;
   END;

   IF lvl_qty <> 0
   THEN
      --기존 창고에서 출고처리
      INSERT INTO im_item_issue (issue_date,
                                 issue_sequence,
                                 organization_id,
                                 material_mfs,
                                 mfs,
                                 item_code,
                                 location_code,
                                 supplier_code,
                                 item_type,
                                 line_code,
                                 workstage_code,
                                 machine_code,
                                 issue_deficit,
                                 issue_qty,
                                 issue_status,
                                 issue_amt,
                                 issue_account,
                                 line_type,
                                 issue_price,
                                 issue_type,
                                 virtual_receipt_yn,
                                 work_order_no,
                                 comments,
                                 enter_date,
                                 enter_by,
                                 last_modify_date,
                                 last_modify_by,
                                 invoice_no,
                                 parent_item_code,
                                 interface_yn,
                                 interface_date,
                                 arrival_date,
                                 arrival_seq_no,
                                 dest_organization_id)
         SELECT TRUNC (SYSDATE),
                seq_mat_issue.NEXTVAL,
                1,
                material_mfs,
                '*' mfs,
                item_code,
                location_code,
                NVL (supplier_code, '*'),
                'T' item_type,
                '*',
                '*',
                '*' machine_code,
                3,
                ABS (lvl_qty),
                'N' issue_status,
                ABS (lvl_qty) * inventory_price,
                'M001' issue_account,
                line_type,
                inventory_price,
                'N' issue_type,
                'N' virtual_receipt_yn,
                seq_mat_issue.NEXTVAL work_order_no,
                'SELECT INSPECT' comments,
                SYSDATE,
                'SYSTEM',
                SYSDATE,
                'SYSTEM',
                TO_CHAR (SYSDATE, 'YYYYMMDD')
                || TRIM (
                      TO_CHAR (
                         SEQ_ISSUE_INVOICE_SEQUENCE.NEXTVAL)),
                '*' parent_item_code,
                'N' interface_yn,
                NULL interface_date,
                NULL arrival_date,
                NULL arrival_seq_no,
                NULL dest_organization_id
           FROM im_item_inventory
          WHERE     item_code = UPPER (lvs_item_code)
                AND location_code = UPPER (p_fr_location)
                AND material_mfs = UPPER (lvs_lot_no);


      --목적지 창고 반입처리
      INSERT INTO im_item_issue (issue_date,
                                 issue_sequence,
                                 organization_id,
                                 material_mfs,
                                 mfs,
                                 item_code,
                                 location_code,
                                 supplier_code,
                                 item_type,
                                 line_code,
                                 workstage_code,
                                 machine_code,
                                 issue_deficit,
                                 issue_qty,
                                 issue_status,
                                 issue_amt,
                                 issue_account,
                                 line_type,
                                 issue_price,
                                 issue_type,
                                 virtual_receipt_yn,
                                 work_order_no,
                                 comments,
                                 enter_date,
                                 enter_by,
                                 last_modify_date,
                                 last_modify_by,
                                 invoice_no,
                                 parent_item_code,
                                 interface_yn,
                                 interface_date,
                                 arrival_date,
                                 arrival_seq_no,
                                 dest_organization_id)
         SELECT TRUNC (SYSDATE),
                seq_mat_issue.NEXTVAL,
                1,
                material_mfs,
                '*' mfs,
                item_code,
                p_to_location,
                NVL (supplier_code, '*'),
                'T' item_type,
                '*',
                '*',
                '*' machine_code,
                4,
                ABS (lvl_qty) * -1,
                'N' issue_status,
                ABS (lvl_qty) * -1 * inventory_price,
                'M001' issue_account,
                line_type,
                inventory_price,
                'N' issue_type,
                'N' virtual_receipt_yn,
                seq_mat_issue.NEXTVAL work_order_no,
                'MOVE' comments,
                SYSDATE,
                'SYSTEM',
                SYSDATE,
                'SYSTEM',
                TO_CHAR (SYSDATE, 'YYYYMMDD')
                || TRIM (
                      TO_CHAR (
                         SEQ_ISSUE_INVOICE_SEQUENCE.NEXTVAL)),
                '*' parent_item_code,
                'N' interface_yn,
                NULL interface_date,
                NULL arrival_date,
                NULL arrival_seq_no,
                NULL dest_organization_id
           FROM im_item_inventory
          WHERE     item_code = UPPER (lvs_item_code)
                AND location_code = UPPER (p_fr_location)
                AND material_mfs = UPPER (lvs_lot_no);
   END IF;

   COMMIT;
   p_err := 'OK';
   RETURN;
EXCEPTION
   WHEN OTHERS
   THEN
      p_err := p_item_barcode || ' ' || SUBSTR (SQLERRM, 1, 100);
      RETURN;
END;