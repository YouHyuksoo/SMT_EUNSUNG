TRIGGER "INFINITY21_JSMES"."TRG_IP_PRODUCT_LINE_UPD" 
 AFTER
   UPDATE OF line_status
 ON ip_product_line
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvi_count   NUMBER;
BEGIN
----------------------------------------------
-- LINE STATUS CODE
----------------------------------------------
-- S = NORMAL START
-- N = NORMAL END
-- P = STOP
-- R = REPAIR
-- I = IDLE
-- M = MODEL CHANGE
-- C = CLEAN
-- W = POWER OFF



   ----------------------------------------------
   IF :NEW.line_status IN ('S', 'P', 'R', 'I', 'M', 'C', 'W')
   THEN
      BEGIN
         SELECT COUNT (*)
           INTO lvi_count
           FROM ip_line_daily_operation
          WHERE plan_date = nvl(TRUNC (:NEW.action_date) , trunc(sysdate) )
            AND line_code = :OLD.line_code
            AND line_status_code = :NEW.line_status
            AND NVL (action_close_yn, 'N') = 'N'
            AND organization_id = :OLD.organization_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            lvi_count := 0;
      END;

-----------------------------------------------
--
-----------------------------------------------
      IF lvi_count = 0
      THEN
         INSERT INTO ip_line_daily_operation
                     (plan_date,
                      line_operation_sequence, line_status_code,
                      organization_id, line_code, shift_code,
                      start_time, end_time, total_operation_time,
                      action_close_yn, operation_by, repair_by,
                      enter_by, enter_date, last_modify_by,
                      last_modify_date , action_date
                     )
              VALUES (nvl(TRUNC (:NEW.action_date),trunc(sysdate))   ,                --PLAN_DATE,
                      seq_line_operation_sequence.NEXTVAL,
                                                   -- LINE_OPERATION_SEQUENCE,
                                                          :NEW.line_status,
                      :OLD.organization_id, :OLD.line_code, '*', --SHIFT_CODE,
                      nvl(TRUNC (:NEW.action_date),trunc(sysdate)) ,                           --START_TIME
                                       NULL,                        --END_TIME
                                            0,         --TOTAL_OPERATION_TIME,
                      'N',                                  --ACTION_CLOSE_YN,
                          :OLD.last_modify_by,                 --OPERATION_BY,
                                              :OLD.last_modify_by,
                                                                  --REPAIR_BY,
                      :OLD.enter_by, :OLD.enter_date, :OLD.last_modify_by,
                      :OLD.last_modify_date ,
                      :new.action_date
                     );
      END IF;
   ELSIF :NEW.line_status = 'N'
   THEN                                                              -- NORMAL
      UPDATE ip_line_daily_operation
         SET end_time = nvl(TRUNC (:NEW.action_date),trunc(sysdate)) ,
             total_operation_time =
                     ROUND ((nvl(TRUNC (:NEW.action_date),trunc(sysdate))  - start_time) * 24 * 60 * 60, 2),
             action_close_yn = 'Y'
       WHERE plan_date = nvl(TRUNC (:NEW.action_date),trunc(sysdate))
         AND line_code = :OLD.line_code
         AND line_status_code = :OLD.line_status
         AND NVL (action_close_yn, 'N') = 'N'
         AND organization_id = :OLD.organization_id;
   ELSE
      NULL;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;