TRIGGER "INFINITY21_JSMES"."TRG_MAT_RECEIPT_INS"
 AFTER
 INSERT
 ON IM_ITEM_RECEIPT  REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW
DECLARE
    lvl_cnt                     NUMBER := 0;
    lvi_return                  NUMBER;
    lvf_last_dd_avg_price       NUMBER;
    lvf_last_dd_inventory_qty   NUMBER;
    lvf_last_dd_inventory_amt   NUMBER;
    lvf_arrival_qty             NUMBER;
    lvf_arrival_amt             NUMBER;
    lvf_mm_receipt_qty          NUMBER;
    lvf_mm_receipt_amt          NUMBER;
    lvf_mm_issue_qty            NUMBER;
    lvf_mm_issue_amt            NUMBER;
    lvf_mm_free_issue_qty       NUMBER;
    lvf_mm_free_issue_amt       NUMBER;
    lvf_last_inventory_qty      NUMBER;
    lvf_last_avg_price          NUMBER;
    lvf_last_inventory_amt      NUMBER;

    lvs_supplier_code varchar2(20) ;
    lvs_config_value  varchar2(30) ;
BEGIN
    -------------------------------------
    -- current inventory get
    -------------------------------------

    BEGIN
      SELECT nvl(supplier_code,'*')
        INTO lvs_supplier_code
        FROM id_item
       WHERE item_code = :new.item_code;

   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvs_supplier_code := '*';
   END;

    BEGIN
        SELECT   COUNT ( * )
          INTO   lvl_cnt
          FROM   im_item_inventory
         WHERE   item_code = :new.item_code
             AND line_type = :new.line_type
             AND material_mfs = :new.material_mfs
             AND organization_id = :new.organization_id
             AND location_code = :new.location_code
             AND ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            lvl_cnt := 0;
    END;

    IF NVL(lvl_cnt,0) < 1
    THEN
        lvf_last_inventory_qty := 0;
        lvf_last_avg_price := 0;
        lvf_last_inventory_amt := 0;

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
                                       last_receipt_date,
                                       manufacture_week,
                                       LOCATION_ADDRESS_RACK,
                                       supplier_code,
                                       inventory_type,
                                       pcb_coating_date,
                                       manufacture_date)
          VALUES   (:new.material_mfs,
                    :new.item_code,
                    'G',
                    :new.organization_id,
                    :new.line_type,
                    'W',
                    :new.unit_price * :new.exchange_rate,
                    :new.receipt_qty,
                    (:new.exchange_rate * :new.unit_price * :new.receipt_qty) + NVL (:new.material_cost_amt, 0),
                    :new.location_code,
                    NULL,
                    SYSDATE,
                    :new.enter_by,
                    SYSDATE,
                    :new.last_modify_by,
                    TRUNC(SYSDATE) ,
                    nvl(:new.manufacture_week, TO_CHAR (SYSDATE, 'YYWW')),
                    :NEW.LOCATION_ADDRESS ,
                    :new.supplier_code,
                    NVL(:new.inventory_type , 'P') ,
                    :new.pcb_coating_date,
                    :new.manufacture_date
                    );

    ELSE
        SELECT   inventory_qty, inventory_price, inventory_amt
          INTO   lvf_last_inventory_qty, lvf_last_avg_price, lvf_last_inventory_amt
          FROM   im_item_inventory
         WHERE   item_code = :new.item_code
             AND line_type = :new.line_type
             AND material_mfs = :new.material_mfs
             AND location_code = :new.location_code
             AND organization_id = :new.organization_id;

            UPDATE   im_item_inventory
               SET   inventory_qty = NVL (inventory_qty, 0) + :new.receipt_qty,
                     inventory_amt =
                           NVL (inventory_amt, 0)
                         + (:new.receipt_qty * :new.unit_price * :new.exchange_rate)
                         + NVL (:new.material_cost_amt, 0),
                     location_code = :new.location_code
             WHERE   item_code = :new.item_code
                 AND line_type = :new.line_type
                 AND material_mfs = :new.material_mfs
                 AND location_code = :new.location_code
                 AND organization_id = :new.organization_id;

        UPDATE   im_item_inventory
           SET   inventory_price = DECODE (inventory_qty, 0, 0, inventory_amt / inventory_qty)
         WHERE   item_code = :new.item_code
             AND line_type = :new.line_type
             AND material_mfs = :new.material_mfs
             AND location_code = :new.location_code
             AND organization_id = :new.organization_id;
    END IF;



    ----------------------------------------------------
    -- ARRIVAL STATUS CHANGE
    ----------------------------------------------------
    IF :new.line_type <> ' T'
    THEN
        IF :new.receipt_status = 'C'
        THEN
            UPDATE   im_item_arrival
               SET   arrival_type = 'A', receipt_date = NULL, receipt_sequence = NULL
             WHERE   arrival_date = :new.arrival_date
                 AND arrival_seq_no = :new.arrival_seq_no
                 AND organization_id = :new.organization_id;
        ELSE
            UPDATE   im_item_arrival
               SET   arrival_type = 'R', receipt_date = :new.receipt_date, receipt_sequence = :new.receipt_sequence
             WHERE   arrival_date = :new.arrival_date
                 AND arrival_seq_no = :new.arrival_seq_no
                 AND organization_id = :new.organization_id;
        END IF;
    ----------------------------------------------------
    -- ASSEMBLY ACTUAL STATUS CHANGE
    ----------------------------------------------------
    ELSE
        IF :new.receipt_status = 'C'
        THEN
            UPDATE   ip_assembly_result
               SET   receipt_yn = 'N', receipt_date = NULL, receipt_sequence = NULL
             WHERE   product_date = :new.arrival_date
                 AND product_sequence = :new.arrival_seq_no
                 AND organization_id = :new.organization_id;
        ELSE
            UPDATE   ip_assembly_result
               SET   receipt_yn = 'Y', receipt_date = :new.receipt_date, receipt_sequence = :new.receipt_sequence
             WHERE   product_date = :new.arrival_date
                 AND product_sequence = :new.arrival_seq_no
                 AND organization_id = :new.organization_id;
        END IF;
    END IF;
   -----------------------------------------------------------------------------------------
    --
    -----------------------------------------------------------------------------------------

    BEGIN
        SELECT   config_value
          INTO   lvs_config_value
          FROM   isys_config
         WHERE   config_name = 'MATERIAL_RCVISS_AUTO_INV_CHECK' AND organization_id = :new.organization_id;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            lvs_config_value := 'N';
    END;

    IF lvs_config_value = 'Y'
    THEN
        IF :new.receipt_deficit = '1'
        THEN
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
                                                     location_code)
              VALUES   (to_char(sysdate,'YYYYMM'),
                        :new.location_code,
                        :new.item_code || '-' || :new.material_mfs || '-' || :new.receipt_qty,           --item_barcode,
                        :new.item_code,                                                                    -- item_code,
                        'SYSTEM',                                                                           -- enter_by,
                        SYSDATE,                                                                          -- enter_date,
                        'SYSTEM',                                                                     -- last_modify_by,
                        SYSDATE,                                                                    -- last_modify_date,
                        :new.organization_id,
                        :new.material_mfs,                                                                     --lot_no,
                        :new.receipt_qty,                                                              -- inventory_qty,
                        :new.receipt_qty,                                                                 --barcode_qty,
                        0,                                                                                 --unit_price,
                        0,
                        1 ,
                        :new.location_code                                                                               --inventory_amt
                         );
        ELSE
            DELETE FROM   im_item_inventory_check_bcd
                  WHERE   check_yyyymm >= to_char(sysdate,'YYYYMM') AND item_code = :new.item_code AND lot_no = :new.material_mfs;
        END IF;
    END IF;
EXCEPTION
    WHEN OTHERS
    THEN
        raise_application_error (-20003, :new.item_code || ' ' || SQLERRM);
END;