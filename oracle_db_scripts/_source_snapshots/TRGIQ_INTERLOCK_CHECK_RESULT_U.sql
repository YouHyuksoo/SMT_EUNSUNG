TRIGGER "INFINITY21_JSMES"."TRGIQ_INTERLOCK_CHECK_RESULT_U" 
 BEFORE
 UPDATE OF ENTER_BY
 ON IQ_INTERLOCK_CHECK_RESULT
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW
BEGIN
    INSERT INTO ip_prod_material_tracking_kfc (p_pcb,
                                               p_kefilot,
                                               p_material,
                                               m_material,
                                               p_prog,
                                               p_equip,
                                               p_process_time,
                                               p_status)
        SELECT   :old.serial_no,
                 a.lot_no,
                 :old.item_code,
                 a.partname,
                 a.line_code,
                 :old.machine_code,
                 :old.receipt_date,
                 a.pcb_item
          FROM   ib_smt_checkhist a
         WHERE   (a.check_date, a.line_code, a.lot_name, a.pcb_item, a.location_code) IN
                         (  SELECT   MAX (check_date),
                                     line_code,
                                     lot_name,
                                     pcb_item,
                                     location_code
                              FROM   ib_smt_checkhist
                             WHERE   check_date <= :old.receipt_date
                                 AND check_type IN (1, 2)
                                 AND line_code = :old.line_code
                                 and lot_name = :old.model_name

                          GROUP BY   line_code,
                                     lot_name,
                                     pcb_item,
                                     location_code)
             AND a.check_type IN (1, 2)
             AND a.line_code = :old.line_code
             AND a.lot_name  = :old.model_name ;
END;