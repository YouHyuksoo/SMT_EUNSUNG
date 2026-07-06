TRIGGER "INFINITY21_JSMES"."TRGIQ_MCN_INSPECT_AOI_R_TF_INS" 
BEFORE INSERT
ON IQ_MACHINE_INSPECT_AOI_R_TF
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE

   LVS_MARKING_CONDITION          VARCHAR2 (10);
   LVS_BARCODE                    VARCHAR2 (30);
   LVS_CUSTOMER_NAME              VARCHAR2 (30);
   LVS_SITE_CODE                  VARCHAR2 (30);

   LVI_CARRIER_SIZE               NUMBER;
   LVI_SERIAL_NO_POSITION         NUMBER;
   LVS_CARRIER_BARCODE_POSITION   VARCHAR2 (10);

   LVI_NG_COUNT                   NUMBER;

BEGIN

    :NEW.IS_LAST_YN := 'Y' ;

   ------------------------------------------------------
   -- ？？ ？？？？？？？？ LS_LAST_FLAG N？？？？ ？？？？
   ------------------------------------------------------
     UPDATE IQ_MACHINE_INSPECT_AOI_R_TF
       SET IS_LAST_YN = 'N'
     WHERE BARCODE     = :NEW.BARCODE
        AND LINE_CODE  = :NEW.LINE_CODE
        AND IMAGENAME  = :NEW.IMAGENAME
        AND LOCATIONID = :NEW.LOCATIONID
        AND PARTNUMBER = :NEW.PARTNUMBER ;

   ------------------------------------------------------
   -- ？？？ ？？？？？？ ？？？？ ？ð？？뿡 NG？？ ？？？？？？？ o？？ ？？？？？ ？？？
   ------------------------------------------------------
   BEGIN

      SELECT NVL(SUM(1),0)
        INTO LVI_NG_COUNT
        FROM IQ_MACHINE_INSPECT_AOI_R_TF
       WHERE BARCODE         = :NEW.BARCODE
         AND TESTDATA        = :NEW.TESTDATA
         AND LINE_CODE       = :NEW.LINE_CODE
         AND NVL(REVIEW,'*') <> '？？？';

   EXCEPTION
      WHEN OTHERS THEN
           LVI_NG_COUNT := 0;
   END;

IF (LVI_NG_COUNT = 0) THEN

   ------------------------------------------------------
   -- ？？？迭 ？？？？ ？？？
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
   -- ？？？ ？？？？？ ？？？？？ ？？？迭o？？？？ ？？？？ PID ？？？？
   ----------------------------------------------------------------------------
   IF ( LVI_CARRIER_SIZE >= 2 )  THEN

      IF LVI_CARRIER_SIZE > 9   THEN
         LVS_BARCODE := SUBSTR (:NEW.BARCODE, 1, LENGTH (:NEW.BARCODE) - 2) || '%';
      ELSE
         LVS_BARCODE := SUBSTR (:NEW.BARCODE, 1, LENGTH (:NEW.BARCODE) - 1) || '%';
      END IF;
   ELSE
      LVS_BARCODE := :NEW.BARCODE;
   END IF;

   ------------------------------------------------------
   -- HLDS ？？？？ ？？？？？ ？？？？ Serial ？？ ？？？？？？？ ？？？？ o？？ ？？
   ------------------------------------------------------
   IF LVS_CUSTOMER_NAME = 'HLDS' THEN

      IF (LVI_CARRIER_SIZE >= 2)  THEN

          IF ( LVS_CARRIER_BARCODE_POSITION = '1' ) THEN

               UPDATE /*+ INDEX(IQ_INTERLOCK_CHECK_RESULT INDXIQ_INTERLOCK_CHECK_RESULT2) */ IQ_INTERLOCK_CHECK_RESULT
                  SET AOI_REVIEW_RESULT =  :NEW.REVIEW
                WHERE IS_LAST_YN = 'Y'
                  AND LINE_CODE = :NEW.LINE_CODE
                  AND F_GET_WORKSTAGE_TYPE(WORKSTAGE_CODE) = 'AOI'
                  AND SERIAL_NO >= :NEW.BARCODE
                  AND SERIAL_NO <= LVS_SITE_CODE||TRIM(TO_CHAR(TO_NUMBER(SUBSTR(:NEW.BARCODE,4,5))+ (( LVI_CARRIER_SIZE) -1),'00000'))||SUBSTR(:NEW.BARCODE,9,18);

          ELSE

               UPDATE /*+ INDEX(IQ_INTERLOCK_CHECK_RESULT INDXIQ_INTERLOCK_CHECK_RESULT2) */ IQ_INTERLOCK_CHECK_RESULT
                  SET AOI_REVIEW_RESULT =  :NEW.REVIEW
                WHERE IS_LAST_YN = 'Y'
                  AND LINE_CODE = :NEW.LINE_CODE
                  AND F_GET_WORKSTAGE_TYPE(WORKSTAGE_CODE) = 'AOI'
                  AND SERIAL_NO >= LVS_SITE_CODE||TRIM(TO_CHAR(TO_NUMBER(SUBSTR(:NEW.BARCODE,4,5))+ (( -1 * LVI_CARRIER_SIZE) +1),'00000'))||SUBSTR(:NEW.BARCODE,9,18)
                  AND SERIAL_NO <= :NEW.BARCODE;

          END IF;

      ELSE

          UPDATE IQ_INTERLOCK_CHECK_RESULT
             SET AOI_REVIEW_RESULT =  :NEW.REVIEW
           WHERE SERIAL_NO      = :NEW.BARCODE
             AND IS_LAST_YN     = 'Y'
             AND LINE_CODE      = :NEW.LINE_CODE
             AND F_GET_WORKSTAGE_TYPE(WORKSTAGE_CODE) = 'AOI';

      END IF;

   ELSE

       UPDATE  IQ_INTERLOCK_CHECK_RESULT
          SET AOI_REVIEW_RESULT =  :NEW.REVIEW
        WHERE SERIAL_NO      LIKE LVS_BARCODE    --SERIAL_NO = :NEW.BARCODE
          AND IS_LAST_YN     = 'Y'
          AND LINE_CODE      = :NEW.LINE_CODE
          AND F_GET_WORKSTAGE_TYPE(WORKSTAGE_CODE) = 'AOI' ;

   END IF;


END IF ;


EXCEPTION
     WHEN OTHERS THEN

       RAISE_APPLICATION_ERROR( -20003 , SQLERRM ) ;

END TRGIQ_MCN_INSPECT_AOI_R_TF_INS;