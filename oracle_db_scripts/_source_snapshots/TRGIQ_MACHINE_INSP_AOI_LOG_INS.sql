TRIGGER "INFINITY21_JSMES"."TRGIQ_MACHINE_INSP_AOI_LOG_INS" 
   BEFORE INSERT
   ON IQ_MACHINE_INSPECT_AOI_LOG
   REFERENCING NEW AS New OLD AS Old
   FOR EACH ROW
DECLARE

   LVS_MARKING_CONDITION          VARCHAR2 (10);
   LVI_CARRIER_SIZE               NUMBER;
   LVS_CARRIER_BARCODE_POSITION   VARCHAR2 (10);
   LVS_CUSTOMER_NAME              VARCHAR2 (30);
   LVS_SITE_CODE                  VARCHAR2 (30);
   LVI_SERIAL_NO_POSITION         NUMBER;

   LVS_BARCODE                    VARCHAR2 (30);

BEGIN

   ------------------------------------------------------
   -- 연배열 정보 확인
   ------------------------------------------------------
   BEGIN

     SELECT MARKING_CONDITION, CARRIER_SIZE, CARRIER_BARCODE_POSITION, CUSTOMER_NAME, SITE_CODE, SERIAL_NO_POSITION
       INTO LVS_MARKING_CONDITION,
            LVI_CARRIER_SIZE,
            LVS_CARRIER_BARCODE_POSITION,
            LVS_CUSTOMER_NAME,
            LVS_SITE_CODE,
            LVI_SERIAL_NO_POSITION
       FROM IP_PRODUCT_MODEL_MASTER
      WHERE ITEM_CODE = (
                         SELECT ITEM_CODE
                           FROM IP_PRODUCT_2D_BARCODE
                          WHERE SERIAL_NO = :NEW.BARCODE
                        )
        AND ROWNUM = 1;

   EXCEPTION
      WHEN OTHERS THEN
           NULL;
   END;

   ----------------------------------------------------------------------------
   -- 대표 바코드 인경우 연배열처리를 위한 PID 산출
   ----------------------------------------------------------------------------
   IF (LVI_CARRIER_SIZE >= 2) THEN

      IF (LVI_CARRIER_SIZE > 9) THEN
         LVS_BARCODE := SUBSTR (:NEW.BARCODE, 1, LENGTH (:NEW.BARCODE) - 2) || '%';  -- 10연배 이상
      ELSE
         LVS_BARCODE := SUBSTR (:NEW.BARCODE, 1, LENGTH (:NEW.BARCODE) - 1) || '%';  -- 2연배 에서 9연배 까지
      END IF;

   ELSE

      LVS_BARCODE := :NEW.BARCODE;

   END IF;

   ------------------------------------------------------
   -- HLDS 경우 바코드 중앙에 Serial 이 존재하여 예외 처리 함
   ------------------------------------------------------
   IF (LVS_CUSTOMER_NAME = 'HLDS') THEN

       IF (LVI_CARRIER_SIZE >= 2)  THEN

           IF ( LVS_CARRIER_BARCODE_POSITION = '1' ) THEN

                UPDATE /*+ INDEX(IQ_INTERLOCK_CHECK_RESULT INDXIQ_INTERLOCK_CHECK_RESULT2) */ IQ_INTERLOCK_CHECK_RESULT
                   SET CHECK_RESULT = DECODE (:NEW.CHECK_RESULT, '양품', 'OK', 'NG'),
                       BAD_REASON_COMMENTS = '설비판정:'
                                             || CHECK_RESULT
                                             || ' 로그판정(CSV): '
                                             || :NEW.CHECK_RESULT
                 WHERE SERIAL_NO >= :NEW.BARCODE
                   AND SERIAL_NO <= LVS_SITE_CODE||TRIM(TO_CHAR(TO_NUMBER(SUBSTR(:NEW.BARCODE,4,5))+ (( LVI_CARRIER_SIZE) -1),'00000'))||SUBSTR(:NEW.BARCODE,9,18)
                   AND IS_LAST_YN     = 'Y'
                   AND F_GET_WORKSTAGE_TYPE(WORKSTAGE_CODE) = 'AOI'
                   AND LINE_CODE      = :NEW.LINE_CODE
                   AND CHECK_RESULT   = 'PASS';

           ELSE

                UPDATE /*+ INDEX(IQ_INTERLOCK_CHECK_RESULT INDXIQ_INTERLOCK_CHECK_RESULT2) */ IQ_INTERLOCK_CHECK_RESULT
                   SET CHECK_RESULT = DECODE (:NEW.CHECK_RESULT, '양품', 'OK', 'NG'),
                       BAD_REASON_COMMENTS = '설비판정:'
                                             || CHECK_RESULT
                                             || ' 로그판정(CSV): '
                                             || :NEW.CHECK_RESULT
                 WHERE SERIAL_NO >= LVS_SITE_CODE||TRIM(TO_CHAR(TO_NUMBER(SUBSTR(:NEW.BARCODE,4,5))+ (( -1 * LVI_CARRIER_SIZE) +1),'00000'))||SUBSTR(:NEW.BARCODE,9,18)
                   AND SERIAL_NO <= :NEW.BARCODE
                   AND IS_LAST_YN     = 'Y'
                   AND F_GET_WORKSTAGE_TYPE(WORKSTAGE_CODE) = 'AOI'
                   AND LINE_CODE      = :NEW.LINE_CODE
                   AND CHECK_RESULT   = 'PASS';

           END IF;

       ELSE

           UPDATE IQ_INTERLOCK_CHECK_RESULT
              SET CHECK_RESULT = DECODE (:NEW.CHECK_RESULT, '양품', 'OK', 'NG'),
                  BAD_REASON_COMMENTS = '설비판정:'
                                        || CHECK_RESULT
                                        || ' 로그판정(CSV): '
                                        || :NEW.CHECK_RESULT
            WHERE SERIAL_NO LIKE LVS_BARCODE
              AND IS_LAST_YN     = 'Y'
              AND F_GET_WORKSTAGE_TYPE(WORKSTAGE_CODE) = 'AOI'
              AND LINE_CODE      = :NEW.LINE_CODE
              AND CHECK_RESULT   = 'PASS';

      END IF;

   ELSE

       UPDATE IQ_INTERLOCK_CHECK_RESULT
          SET CHECK_RESULT = DECODE (:NEW.CHECK_RESULT, '양품', 'OK', 'NG'),
              BAD_REASON_COMMENTS = '설비판정:'
                                    || CHECK_RESULT
                                    || ' 로그판정(CSV): '
                                    || :NEW.CHECK_RESULT
        WHERE SERIAL_NO LIKE LVS_BARCODE
          AND IS_LAST_YN     = 'Y'
          AND F_GET_WORKSTAGE_TYPE(WORKSTAGE_CODE) = 'AOI'
          AND LINE_CODE      = :NEW.LINE_CODE
          AND CHECK_RESULT   = 'PASS';                             -- 2016/05/26 조찬필K 요청으로 PASS 인 경우에 대해 update

   END IF;


EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR( -20003 , SQLERRM ) ;
END;