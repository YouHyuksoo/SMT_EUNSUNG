TRIGGER "INFINITY21_JSMES"."TRGIP_PRODUCT_SENSOR_ACT_UPD" 
   after UPDATE
   OF ADJUST_QTY
   ON IP_PRODUCT_SENSOR_ACTUAL    REFERENCING NEW AS New OLD AS Old
   FOR EACH ROW
DECLARE
 
   LVDT_DATE   DATE;
BEGIN

-----------------------------------------------------------
--
-----------------------------------------------------------
  

   UPDATE ib_product_plandata
      SET product_actual_qty =  NVL( :new.adjust_qty ,0) * ( (NVL (item_unit_qty, 0) / NVL (F_GET_CARRIER_SIZE_BY_SMT (smt_model_name, 1), 1) ) * 1)
    WHERE     line_code = SUBSTR ( :new.line_code, 1, 2)
       --  AND model_name = :old.model_name
          AND active_yn = 'Y';
 
-----------------------------------------------------------
--
-----------------------------------------------------------
--   LVDT_DATE := SYSDATE;
--
--   UPDATE IP_PRODUCT_LINE
--      SET REAL_ST =
--             TRUNC ( (SYSDATE - :OLD.LAST_RECEIPT_DATE) * 24 * 60 * 60, 2),
--          LAST_MODIFY_BY = 'SENSOR ACT U-TRG'
--    WHERE LINE_CODE = SUBSTR (:NEW.LINE_CODE, 1, 2);



--   BEGIN
--      UPDATE IP_PRODUCT_MODEL_ST_MASTER
--         SET ASSY_ST =
--                TRUNC ( (SYSDATE - :OLD.LAST_RECEIPT_DATE) * 24 * 60 * 60, 2),
--             LAST_MODIFY_DATE = SYSDATE,
--             ENTER_BY = 'SENSOR ACT U-TRG'
--       WHERE (LINE_CODE, MODEL_NAME, PCB_ITEM) =
--                (SELECT DISTINCT LINE_CODE, MODEL_NAME, PCB_ITEM
--                   FROM IB_PRODUCT_PLANDATA
--                  WHERE LINE_CODE = SUBSTR (:NEW.LINE_CODE, 1, 2)
--                        AND ACTIVE_YN = 'Y');
--
--      :NEW.LAST_RECEIPT_DATE := LVDT_DATE;
--
--   EXCEPTION
--      WHEN OTHERS
--      THEN
--         NULL;
--   END;
EXCEPTION
   WHEN OTHERS
   THEN
      NULL;
END;