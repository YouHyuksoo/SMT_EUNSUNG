PROCEDURE "P_CHECK_NG_UNLOCK" (
   p_line_code    IN     VARCHAR2,
   p_model_name   IN     VARCHAR2,
   p_sequence     IN     VARCHAR2,
   p_reason       IN     VARCHAR2,
   p_userid       IN     VARCHAR2,
   p_return          OUT VARCHAR2)
IS
   LVF_REMAIN_TIME   NUMBER;
   lvl_remain_QTY    NUMBER;
   lvi_row_count  NUMBER ;
BEGIN
   -------------------------------------------------------------------------------
   --
   -------------------------------------------------------------------------------
   UPDATE ib_smt_checkhist
      SET ng_reason = p_reason, unlock_by = p_userid, unlock_date = SYSDATE
    WHERE     check_sequence = p_sequence
          AND check_date >= SYSDATE - 1
          AND line_code = SUBSTR(p_line_code,1,2)
          AND lot_name = p_model_name;

   p_return := 'OK';

   --------------------------------------------------------------------------------
   --  해제
   --  무조건 해제 하지 않고
   --  릴 체인지 여견을 판단하고 해제 해 준다.
   --------------------------------------------------------------------------------
 /*-------------------------------------------------------------------------------------------
   -- 피더 잔량이 0 이하 인 위치 건수 조회
   --
   -------------------------------------------------------------------------------------------

   SELECT COUNT (*)
     INTO lvl_remain_QTY
     FROM ib_product_plandata
    WHERE     line_code = SUBSTR(p_line_code,1,2)
          AND model_name = p_model_name
          AND active_yn = 'Y'
          AND feeding_qty - ABS (product_actual_qty) <= 0;

   IF lvl_remain_QTY > 0
   THEN
      COMMIT;
      RETURN;                                             -- NSNP 는 해제 하지 않는다.
   ELSE
      ------------------------------------------------------------------------------------
      --  잔량이 0 은 아니지만 시간이 기준 시간 이하이면 세운다 .
      ------------------------------------------------------------------------------------

      SELECT COUNT (*)
        INTO LVF_REMAIN_TIME
        FROM ib_product_plandata A, IP_PRODUCT_LINE C
       WHERE     A.LINE_CODE = C.LINE_CODE(+)
             AND A.ORGANIZATION_ID = C.ORGANIZATION_ID(+)
             AND A.LINE_CODE = SUBSTR(p_line_code,1,2)
             AND A.MODEL_NAME = p_model_name
             AND DECODE (
                    NVL (A.item_unit_qty * C.REAL_ST, 0),
                    0, 0,
                    TRUNC (
                       (NVL (A.FEEDING_QTY, 0)
                        - NVL (A.PRODUCT_ACTUAL_QTY, 0))
                       / A.item_unit_qty
                       * C.REAL_ST
                       / 60,
                       0)) <= 5;

      ------------------------------------------------------------------------------
      --  잔여시간 체크해서 5 분 이하면 라인 스톱
      ------------------------------------------------------------------------------
      IF LVF_REMAIN_TIME > 0
      THEN
         COMMIT;
         RETURN;
      END IF;
   END IF;*/

   --------------------------------------------------------------------------------
   -- 요청으로 인해 언락시 해제 안하고 스캔시 마다 체크 하도록 수정
   -- 해제 해준다
   --------------------------------------------------------------------------------
   
   BEGIN
    SELECT NVL(COUNT(CONFIG_VALUE),0)  
    INTO lvi_row_count
    FROM ISYS_CONFIG      
    WHERE CONFIG_NAME     = 'NSNP_UNLCOK_BY_ACTION'  
    AND CONFIG_VALUE    = 'Y'
    AND ORGANIZATION_ID = 1 ;
    
    EXCEPTION WHEN NO_DATA_FOUND THEN 
      lvi_row_count := 0 ;
   END ;
   
   
   -- 매스캔시 마다 해제한다는 조건이 있으면  여기서 해제 안하고 스캔시 마다 체크 해서 판단
   IF nvl(lvi_row_count,0) > 0 THEN 
      NULL; 
   ELSE
         BEGIN
            --------------------------------------------------------------------------------
            -- NSNP START
            --------------------------------------------------------------------------------
            p_interlock_set_nsnp_time_msg (
               substr(p_line_code,1,2),
               0, --action code
               0, -- time
               p_model_name,
               '*', -- suffix 
               'UNLOCK', -- reason
               p_sequence || ' ' || p_reason || ' ' || p_userid); --error message
         --------------------------------------------------------------------------------
         -- NSNP END
         --------------------------------------------------------------------------------
         EXCEPTION
            WHEN OTHERS
            THEN
               NULL;
         END;
    END IF ;
    
    
   COMMIT;
   RETURN;
-------------------------------------------------------------------------
--
-------------------------------------------------------------------------
EXCEPTION
   WHEN OTHERS
   THEN
      p_return := 'NG, [P_CHECK_NG_UNLOCK] ERROR ' || SQLERRM;
      RETURN;
END;                                                              -- Procedure
