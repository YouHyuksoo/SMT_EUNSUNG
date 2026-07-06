TRIGGER "INFINITY21_JSMES"."TRG_MAT_ISSUE_INS"
 BEFORE
 INSERT
 ON IM_ITEM_ISSUE
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW
DECLARE
   lvl_cnt                     NUMBER := 0;
   lvs_currency                VARCHAR2 (3);
   lvs_local_currency          VARCHAR2 (3);
   lvf_exchange_rate           NUMBER := 0;
   lvf_unit_price              NUMBER := 0;
   lvs_delivery                VARCHAR (10);
   lvi_count                   NUMBER := 0;
   lvf_last_dd_avg_price       NUMBER := 0;
   lvf_last_dd_inventory_qty   NUMBER := 0;
   lvf_last_dd_inventory_amt   NUMBER := 0;
   lvf_arrival_qty             NUMBER := 0;
   lvf_arrival_amt             NUMBER := 0;
   lvf_mm_issue_qty            NUMBER := 0;
   lvf_mm_issue_amt            NUMBER := 0;
   lvf_mm_receipt_qty          NUMBER := 0;
   lvf_mm_receipt_amt          NUMBER := 0;
   lvf_mm_free_issue_qty       NUMBER := 0;
   lvf_mm_free_issue_amt       NUMBER := 0;
   lvf_last_inventory_qty      NUMBER := 0;
   lvf_last_avg_price          NUMBER := 0;
   lvf_last_inventory_amt      NUMBER := 0;
   lvs_supplier_code           VARCHAR2 (20);
   phase                       NUMBER := 0;
   lvs_config_value            VARCHAR2 (10);
   lvs_location_address_rack   VARCHAR2 (30);
   lvs_bosch_item_code         VARCHAR2 (30);
BEGIN


 

   ---------------------------------------------------------------------------------------
   --
   ---------------------------------------------------------------------------------------

   BEGIN
      phase := 5;

      SELECT NVL (supplier_code, '*')
        INTO lvs_supplier_code
        FROM id_item
       WHERE item_code = :new.item_code;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvs_supplier_code := '*';
   END;

   BEGIN
      phase := 10;

      SELECT COUNT (*)
        INTO lvl_cnt
        FROM im_item_inventory
       WHERE     material_mfs = :new.material_mfs
             AND item_code = :new.item_code
       --      AND line_type = :new.line_type
             AND location_code = :new.location_code
             AND organization_id = :new.organization_id
             AND ROWNUM = 1;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvl_cnt := 0;
   END;

   IF lvl_cnt < 1
   THEN
      phase := 20;

         INSERT INTO im_item_inventory (material_mfs,
                                        item_code,
                                        inventory_status,
                                        organization_id,
                                        line_type,
                                        inventory_hold,
                                        inventory_price,
                                        inventory_qty,
                                        inventory_amt,
                                        location_code,
                                        comments,
                                        enter_date,
                                        enter_by,
                                        last_modify_date,
                                        last_modify_by,
                                        supplier_code,
                                        last_receipt_date,
                                        inventory_type)
         VALUES (:new.material_mfs,
                 :new.item_code,
                 'G',
                 :new.organization_id,
                 :new.line_type,
                 'W',
                 0,
                 :new.issue_qty * -1,
                 0,
                 :new.location_code,
                 NULL,
                 SYSDATE,
                 :new.enter_by,
                 SYSDATE,
                 :new.last_modify_by,
                 :new.supplier_code,
                 nvl(:new.enter_date,sysdate) ,
                 NVL(:new.inventory_type,'P'));
  --    END IF;
   ELSE
      phase := 30;

--         SELECT inventory_qty,
--                inventory_price,
--                DECODE (NVL (inventory_qty, 0), 0, 0, inventory_amt)
--           INTO lvf_last_inventory_qty,
--                lvf_last_avg_price,
--                lvf_last_inventory_amt
--           FROM im_item_inventory
--          WHERE     material_mfs = :new.material_mfs
--                AND item_code = :new.item_code
--                AND line_type = :new.line_type
--                AND location_code = :new.location_code
--                AND organization_id = :new.organization_id;

         phase := 40;

         UPDATE im_item_inventory
            SET inventory_qty = NVL (inventory_qty, 0) - :new.issue_qty
--                inventory_amt =
--                   DECODE (NVL (inventory_qty, 0),
--                           0, 0,
--                           NVL (inventory_amt, 0))
--                   - :new.issue_amt
          WHERE     material_mfs = :new.material_mfs
                AND item_code = :new.item_code
         --       AND line_type = :new.line_type
                AND location_code = :new.location_code
                AND organization_id = :new.organization_id;

         phase := 50;

--         UPDATE im_item_inventory
--            SET inventory_price =
--                   ABS (
--                      DECODE (inventory_qty,
--                              0, 0,
--                              inventory_amt / inventory_qty))
--          WHERE     material_mfs = :new.material_mfs
--                AND item_code = :new.item_code
--                AND line_type = :new.line_type
--                AND location_code = :new.location_code
--                AND organization_id = :new.organization_id;

   END IF;


   -------------------------------------------------------
   --
   -------------------------------------------------------
   --   IF :new.issue_type = 'N'
   --   THEN
   --      ---------------------------------------------------------------------------
   --      IF :new.issue_account IN ('M001', 'M011')                --MASS , REWORK
   --      THEN
   --         ---------------------------------------------------------------------------
   --
   --
   --         phase := 70;
   --
            INSERT INTO im_item_workstage_receipt (receipt_date,
                                                   receipt_sequence,
                                                   organization_id,
                                                
                                                   item_code,
                                               
                                                   receipt_deficit,
                                                
                                                   receipt_qty,
                                               
                                                   enter_date,
                                                   enter_by,
                                                   last_modify_date,
                                                   last_modify_by)
            VALUES (:new.issue_date,
                    seq_workstage_receipt_seq.NEXTVAL,
                    :new.organization_id,
                 
                    :new.item_code,
                
                    DECODE (:new.issue_deficit,  '3', '1',  '4', '2'),
               
                    :new.issue_qty,
               
                    SYSDATE,
                    :new.enter_by,
                    SYSDATE,
                    :new.last_modify_by);
   --      ---------------------------------------------------------------------
   --
   --      END IF;
   --   END IF;


   --------------------------------------------------------------------------
   --
   --
   --------------------------------------------------------------------------

   IF :NEW.ISSUE_DEFICIT = '3'
   THEN
      BEGIN
         SELECT COUNT (*)
           INTO LVI_COUNT
           FROM IM_ITEM_REQUEST
          WHERE     ITEM_CODE = :new.item_code
                AND REQUEST_STATUS = 'R'
                AND LINE_CODE = :NEW.LINE_CODE
                AND ROWNUM = 1
                AND REQUEST_DATE =
                       (SELECT MIN (REQUEST_DATE)
                          FROM IM_ITEM_REQUEST
                         WHERE     ITEM_CODE = :new.item_code
                               AND REQUEST_STATUS = 'R'
                               AND LINE_CODE = :NEW.LINE_CODE);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            LVI_COUNT := 0;
      END;

      IF NVL (LVI_COUNT, 0) = 0
      THEN
         NULL;
      ELSE
         UPDATE IM_ITEM_REQUEST
            SET REQUEST_STATUS = 'C',
                MATERIAL_MFS = :new.material_mfs,
                ITEM_BARCODE = :new.barcode,
                ISSUE_QTY = :new.issue_qty,
                ISSUE_DATE = SYSDATE
          WHERE     ITEM_CODE = :new.item_code
                AND REQUEST_STATUS = 'R'
                AND LINE_CODE = :NEW.LINE_CODE
                AND REQUEST_DATE =
                       (SELECT MIN (REQUEST_DATE)
                          FROM IM_ITEM_REQUEST
                         WHERE     ITEM_CODE = :new.item_code
                               AND REQUEST_STATUS = 'R'
                               AND LINE_CODE = :NEW.LINE_CODE);
      END IF;


         BEGIN
            SELECT MIN (
                      NVL (a.location_address_rack,
                           NVL (b.location_address, '*')))
              INTO lvs_location_address_rack
              FROM im_item_inventory a, id_item b
             WHERE a.item_code = b.item_code AND a.item_code = :new.item_code
                   AND a.last_receipt_date =
                          (SELECT MIN (last_receipt_date)
                             FROM im_item_inventory
                            WHERE     item_code = :new.item_code
                                  AND INVENTORY_QTY > 0
                                  AND LOCATION_CODE <> 'M02')
                   AND a.inventory_qty > 0
                   AND a.LOCATION_CODE <> 'M02';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               lvs_location_address_rack := '*';
         END;



      UPDATE IM_ITEM_REQUEST
         SET LOCATION_ADDRESS_RACK = lvs_location_address_rack
       WHERE     ITEM_CODE = :new.item_code
             AND REQUEST_STATUS = 'R'
             AND LINE_CODE = SUBSTR (:NEW.LINE_CODE, 1, 2);

   ELSIF :NEW.ISSUE_DEFICIT = '4'
   THEN

      UPDATE IM_ITEM_RECEIPT_BARCODE
        SET ISSUE_RETURN_DATE = SYSDATE
      WHERE LOT_NO = :NEW.MATERIAL_MFS ;


   END IF;

   -----------------------------------------------------------------------------------------
   --
   -----------------------------------------------------------------------------------------

   BEGIN
      SELECT config_value
        INTO lvs_config_value
        FROM isys_config
       WHERE config_name = 'MATERIAL_RCVISS_AUTO_INV_CHECK'
             AND organization_id = :new.organization_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvs_config_value := 'N';
   END;

   IF lvs_config_value = 'Y'
   THEN
      IF :new.issue_deficit = '3'
      THEN
         DELETE FROM im_item_inventory_check_bcd
          WHERE     item_code = :new.item_code
                AND lot_no = :new.material_mfs
                AND check_yyyymm >= TO_CHAR (SYSDATE, 'YYYYMM');
      ELSIF :new.issue_deficit = '4'
      THEN
         ------------------------------------------------------
         --
         ------------------------------------------------------
         lvi_count := 0;

         BEGIN
            SELECT COUNT (*)
              INTO lvi_count
              FROM im_item_inventory_check_bcd
             WHERE     item_code = :new.item_code
                   AND lot_no = :new.material_mfs
                   AND check_yyyymm >= TO_CHAR (SYSDATE, 'YYYYMM');
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               lvi_count := 0;
         END;

         IF lvi_count > 0
         THEN
            DELETE FROM im_item_inventory_check_bcd
             WHERE     check_yyyymm >= TO_CHAR (SYSDATE, 'YYYYMM')
                   AND item_code = :new.item_code
                   AND lot_no = :new.material_mfs;

            INSERT INTO im_item_inventory_check_bcd (check_yyyymm,
                                                     line_code,
                                                     item_barcode,
                                                     item_code,
                                                     enter_by,
                                                     enter_date,
                                                     last_modify_by,
                                                     last_modify_date,
                                                     organization_id,
                                                     lot_no,
                                                     inventory_qty,
                                                     barcode_qty,
                                                     unit_price,
                                                     inventory_amt,
                                                     check_type,
                                                     invoice_no,
                                                     location_code)
            VALUES (
                      TO_CHAR (SYSDATE, 'YYYYMM'),
                      :new.line_code,
                         :new.item_code
                      || '-'
                      || :new.material_mfs
                      || '-'
                      || ABS (:new.issue_qty),                 --item_barcode,
                      :new.item_code,                            -- item_code,
                      'SYSTEM',                                   -- enter_by,
                      SYSDATE,                                  -- enter_date,
                      'SYSTEM',                             -- last_modify_by,
                      SYSDATE,                            -- last_modify_date,
                      :new.organization_id,
                      :new.material_mfs,                             --lot_no,
                      0,                                     -- inventory_qty,
                      ABS (:new.issue_qty),                     --barcode_qty,
                      0,                                         --unit_price,
                      0,                                       --inventory_amt
                      '4',
                      :new.invoice_no,
                      :new.location_code);
    

         ELSE
            INSERT INTO im_item_inventory_check_bcd (check_yyyymm,
                                                     line_code,
                                                     item_barcode,
                                                     item_code,
                                                     enter_by,
                                                     enter_date,
                                                     last_modify_by,
                                                     last_modify_date,
                                                     organization_id,
                                                     lot_no,
                                                     inventory_qty,
                                                     barcode_qty,
                                                     unit_price,
                                                     inventory_amt,
                                                     check_type,
                                                     invoice_no,
                                                     location_code)
            VALUES (
                      TO_CHAR (SYSDATE, 'YYYYMM'),
                      :new.line_code,
                         :new.item_code
                      || '-'
                      || :new.material_mfs
                      || '-'
                      || ABS (:new.issue_qty),                 --item_barcode,
                      :new.item_code,                            -- item_code,
                      'SYSTEM',                                   -- enter_by,
                      SYSDATE,                                  -- enter_date,
                      'SYSTEM',                             -- last_modify_by,
                      SYSDATE,                            -- last_modify_date,
                      :new.organization_id,
                      :new.material_mfs,                             --lot_no,
                      0,                                     -- inventory_qty,
                      ABS (:new.issue_qty),                     --barcode_qty,
                      0,                                         --unit_price,
                      0,                                       --inventory_amt
                      '4',
                      :new.invoice_no,
                      :new.location_code);
         END IF;
      -------------------------------------------------------------------------------------
      --
      -------------------------------------------------------------------------------------

      ELSE
         DELETE FROM im_item_inventory_check_bcd
          WHERE     check_yyyymm >= TO_CHAR (SYSDATE, 'YYYYMM')
                AND item_code = :new.item_code
                AND lot_no = :new.material_mfs;
      END IF;
   END IF;
-------------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------------

EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (
         -20003,
         'Phase = ' || TO_CHAR (phase) || '  ' || SQLERRM);
END;