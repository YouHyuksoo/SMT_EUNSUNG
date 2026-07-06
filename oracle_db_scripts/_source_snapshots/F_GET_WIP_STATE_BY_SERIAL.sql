FUNCTION "F_GET_WIP_STATE_BY_SERIAL" (p_serial IN VARCHAR2)
/* Formatted on 2015-07-07 10:59:40 (QP5 v5.126) */
    RETURN VARCHAR2
IS
    --
    -- To modify this template, edit file FUNC.TXT in TEMPLATE
    -- directory of SQL Navigator
    --
    -- Purpose: Briefly explain the functionality of the function
    --
    -- MODIFICATION HISTORY
    -- Person      Date    Comments
    -- ---------   ------  -------------------------------------------
    -- SHS         2016/10/04   WIP 재공위치 정보를 추

    lvs_return   VARCHAR2 (100);
-- Declare program variables as shown above
BEGIN

   -- 불량창고 check
   BEGIN

     SELECT NVL(F_GET_LINE_NAME('Z1',1)||' '||F_GET_WORKSTAGE_NAME('W900'), '*')
       INTO LVS_RETURN
       FROM IP_PRODUCT_WORK_QC
      WHERE SERIAL_NO       = P_SERIAL
        AND RECEIPT_DEFICIT = 1
        AND ROWNUM          = 1;

   EXCEPTION

     WHEN OTHERS THEN
          lvs_return := '*';

   END;

   -- 제품창고 check
   IF LVS_RETURN = '*' THEN

      BEGIN

        SELECT NVL(DECODE(SHIPPING_DEFICIT, '1', '제품창고 입고', '3', '제품창고 출하', '*'),'*')
          INTO LVS_RETURN
          FROM IP_PRODUCT_2D_BARCODE
         WHERE SERIAL_NO = P_SERIAL
           AND ROWNUM    = 1;

      EXCEPTION

        WHEN OTHERS THEN
             lvs_return := '*';

      END;

   END IF;

   -- 톡과이력 check
   IF LVS_RETURN = '*' THEN

      BEGIN

        SELECT NVL(F_GET_LINE_NAME(LINE_CODE,ORGANIZATION_ID)||' '||F_GET_WORKSTAGE_NAME(WORKSTAGE_CODE),'*')
          INTO LVS_RETURN
          FROM IQ_INTERLOCK_CHECK_RESULT
         WHERE SERIAL_NO    = P_SERIAL
           AND RECEIPT_DATE IN (
                                SELECT MAX(RECEIPT_DATE)
                                  FROM IQ_INTERLOCK_CHECK_RESULT
                                 WHERE SERIAL_NO= P_SERIAL
                               )
           AND ROWNUM = 1;

      EXCEPTION

        WHEN OTHERS THEN
             lvs_return := '*';

      END;

   END IF;

   -- 데이타가 없을경우 '*'로 표기

   RETURN lvs_return;

EXCEPTION
    WHEN OTHERS
    THEN
        RETURN '*';
END;