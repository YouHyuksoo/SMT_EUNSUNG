TRIGGER "INFINITY21_JSMES"."TRG_ID_ENG_BOM_SMT_UPD" 
 BEFORE
   UPDATE OF table_id, item_unit_qty, location_code
 ON id_eng_bom_smt
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
BEGIN
  NULL;
  
--    UPDATE   ib_product_plandata a
--       SET   a.location_code = :new.location_code,
--             a.last_location_code = a.location_code ,
--             a.table_id = :new.table_id,
--             a.machine = :new.machine,
--             a.check_status = 'W',
--             a.check_yn = 'N' ,
--             a.item_unit_qty = :new.item_unit_qty
--     WHERE   a.line_code = :old.line_code
--         AND a.model_name = :old.parent_item_code
--         and a.table_id   = :old.table_id
--         and a.pcb_item   = :old.pcb_item
--      --   AND a.item_code = :old.child_item_code
--         AND a.location_code = :old.location_code;
--
------------------------------------------------------------------
----
------------------------------------------------------------------
--    UPDATE   id_eng_bom_smt_replace a
--       SET   a.location_code = :new.location_code,
--             a.table_id = :new.table_id,
--             a.machine = :new.machine,
--             a.item_unit_qty = :new.item_unit_qty
--     WHERE   a.line_code = :old.line_code
--         AND a.parent_item_code = :old.parent_item_code
--         AND a.child_item_code = :old.child_item_code
--         and a.table_id   = :old.table_id
--         and a.pcb_item   = :old.pcb_item
--         AND a.location_code = :old.location_code;
 ---------------------------------------------------------------
 --
 ---------------------------------------------------------------
EXCEPTION
    WHEN OTHERS
    THEN
        raise_application_error (-20003, SQLERRM);
END;