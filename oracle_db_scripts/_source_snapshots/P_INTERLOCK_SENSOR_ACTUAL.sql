PROCEDURE "P_INTERLOCK_SENSOR_ACTUAL" (
   P_LINE_CODE        IN     VARCHAR2,
   P_WORKSTAGE_CODE   IN     VARCHAR2,
   P_MACHINE_CODE     IN     VARCHAR2,
   P_PCB_ITEM         IN     VARCHAR2,
   P_COUNT            IN     NUMBER,       --누적 계수 수량
   P_ACC_COUNT        IN     NUMBER,       --   ( 1 , Network   1  )                
   P_OUT                 OUT VARCHAR2)
IS
   LVI_COUNT            NUMBER;
   LVS_LINE_CODE        VARCHAR2 (10);
   LVS_MODEL_NAME VARCHAR2 (30);
   LVS_PCB_ITEM         VARCHAR2 (10);

   LVS_ITEM_CODE        VARCHAR2 (30);
   LVS_OUT              VARCHAR2 (1000);
   lvi_exists           NUMBER;
   LVL_ACTUAL_QTY       NUMBER;
   LVL_SENSOR_ACTUAL    NUMBER;
   lvl_carrier_qty NUMBER;
   
   PHASE VARCHAR2(100) ;
/*****************************************************
*
*****************************************************/
BEGIN
  LVS_LINE_CODE  := SUBSTR (TRIM (P_LINE_CODE), 1, 2);
  LVS_PCB_ITEM   := NVL(P_PCB_ITEM , '*')  ;
  
    BEGIN  
    
          SELECT MODEL_NAME, NVL(PCB_ITEM,'*') 
            INTO LVS_MODEL_NAME, LVS_PCB_ITEM
            FROM IP_PRODUCT_LINE 
           WHERE LINE_CODE = LVS_LINE_CODE ;
    
    EXCEPTION WHEN OTHERS THEN 
          P_OUT := 'NG';
          RETURN;
    END ;

phase := '10' ;
   -------------------------------------------------------
   -- 
   -------------------------------------------------------
   --  lvl_carrier_qty := F_GET_CARRIER_SIZE (LVS_MODEL_NAME, 1);  
   lvl_carrier_qty := 1 ;
   
   
    
phase := '60' ;
   BEGIN
     
      SELECT COUNT (*)
        INTO LVI_COUNT
        FROM IP_PRODUCT_SENSOR_ACTUAL
       WHERE LINE_CODE       = LVS_LINE_CODE
         AND MODEL_NAME      = LVS_MODEL_NAME
         AND PCB_ITEM        = LVS_PCB_ITEM
         AND ORGANIZATION_ID = 1;
         -- AND IS_LAST_YN = 'Y';
         
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
           LVI_COUNT := 0;
   END;
      
phase := '70' ;
   IF NVL(LVI_COUNT, 0) = 0 THEN
      --------------------------------------------------------------------------------
      -- 센서 감지 정보를 저장
      -- P_COUNT 는 계속 1 만 넘어와야 함
      -- 누락이 있으면 누락된 수량 포함해서 넘기고 그다음부터는 다시 1 부터 
      --------------------------------------------------------------------------------
      INSERT INTO IP_PRODUCT_SENSOR_ACTUAL (
                                            RECEIPT_DATE,
                                            RECEIPT_SEQUENCE,
                                            LINE_CODE,
                                            WORKSTAGE_CODE,
                                            MODEL_NAME,
                                            MODEL_SUFFIX,
                                            PRODUCT_ACTUAL_QTY,
                                            ENTER_DATE,
                                            ENTER_BY,
                                            LAST_MODIFY_DATE,
                                            LAST_MODIFY_BY,
                                            ORGANIZATION_ID,
                                            ORIGIN_COUNT,
                                            IS_LAST_YN,
                                            ACTUAL_TYPE,
                                            PCB_ITEM,
                                            PRODUCT_ACTUAL_LOST_QTY,
                                            LAST_RECEIPT_DATE
                                           )
      SELECT  SYSDATE,                                      /* RECEIPT_DATE */
              SEQ_PRODUCT_SENSOR.NEXTVAL,               /* RECEIPT_SEQUENCE */
              LVS_LINE_CODE,                                     /* LINE_CODE */
              P_WORKSTAGE_CODE,
              LVS_MODEL_NAME,                                 /* MODEL_NAME */
              NVL (MODEL_SUFFIX, '*'),                  /* MODEL_SUFFIX */
              (P_ACC_COUNT *  lvl_carrier_qty ) , --   NVL (1, 0),                             /* PRODUCT_ACTUAL_QTY */
              SYSDATE,                                        /* ENTER_DATE */
              'SENSOR ACTUAL',                              /* ENTER_BY */
              SYSDATE,                                  /* LAST_MODIFY_DATE */
              'SYSTEM',                                   /* LAST_MODIFY_BY */
              1,                                         /* ORGANIZATION_ID */
              P_COUNT ,
              'Y',
              'N',
              LVS_PCB_ITEM,
              0 ,
              SYSDATE                                                   /* ORIGIN */
         FROM IP_PRODUCT_MODEL_MASTER
        WHERE MODEL_NAME = LVS_MODEL_NAME  ;   -- SMT_MODEL_NAME = LVS_MODEL_NAME  ;

   ELSE
     
      /*수량 업데이트 함 */
      UPDATE IP_PRODUCT_SENSOR_ACTUAL
         SET PRODUCT_ACTUAL_QTY  = NVL (PRODUCT_ACTUAL_QTY, 0) + (P_ACC_COUNT *  lvl_carrier_qty ) , --NVL (1, 0),
             ORIGIN_COUNT        = P_COUNT,                 --누적 계수 ( 참조정보로만 사용 )
             ENTER_BY            = 'SENSOR ACTUAL'
       WHERE LINE_CODE           = LVS_LINE_CODE
         AND MODEL_NAME          = LVS_MODEL_NAME
         AND PCB_ITEM            = LVS_PCB_ITEM
         AND ORGANIZATION_ID     = 1;
             
   END IF;


   --------------------------------------------------------------
   -- 타입 존 별로 누적
   --------------------------------------------------------------

phase := '80' ;
   LVI_COUNT := 0;

   BEGIN
     
      SELECT COUNT (*)
        INTO LVI_COUNT
        FROM IP_PRODUCT_SENSOR_ACTUAL_TIME
       WHERE LINE_CODE   = LVS_LINE_CODE
         AND MODEL_NAME  = LVS_MODEL_NAME  -- = LVS_FEEDER_LAYOUT_NAME
         AND PCB_ITEM    = LVS_PCB_ITEM
         AND ORGANIZATION_ID = 1
         AND NVL (ACTUAL_TYPE, 'N') = 'N'
         AND RECEIPT_DATE  = F_GET_WORK_ACTUAL_DATE (SYSDATE, 'A')
         AND TIME_DIVISION = F_GET_WORKTIME_SMT_ZONE ( TO_CHAR (SYSDATE, 'YYYYMMDD'), TO_CHAR (SYSDATE, 'HH24MI'), 'ZONE' );
                                             
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
           LVI_COUNT := 0;
   END;

   PHASE := '70';

   IF NVL (LVI_COUNT, 0) = 0  THEN
      --------------------------------------------------------------------------------
      -- 센서 감지 정보를 저장

      --------------------------------------------------------------------------------

      BEGIN
        
         INSERT INTO IP_PRODUCT_SENSOR_ACTUAL_TIME (
                                                    RECEIPT_DATE,
                                                    RECEIPT_SEQUENCE,
                                                    LINE_CODE,
                                                    WORKSTAGE_CODE,
                                                    MODEL_NAME,
                                                    MODEL_SUFFIX,
                                                    PRODUCT_ACTUAL_QTY,
                                                    ENTER_DATE,
                                                    ENTER_BY,
                                                    LAST_MODIFY_DATE,
                                                    LAST_MODIFY_BY,
                                                    ORGANIZATION_ID,
                                                    ORIGIN_COUNT,
                                                    IS_LAST_YN,
                                                    ACTUAL_TYPE,
                                                    TIME_DIVISION,
                                                    PCB_ITEM,
                                                    LAST_RECEIPT_DATE
                                                   )
           SELECT  F_GET_WORK_ACTUAL_DATE (SYSDATE, 'A'),
                   SEQ_PRODUCT_SENSOR.NEXTVAL,          /* RECEIPT_SEQUENCE */
                   LVS_LINE_CODE,                              /* LINE_CODE */
                   P_WORKSTAGE_CODE,
                   UPPER(MODEL_NAME),                    /* MODEL_NAME */
                   NVL (MODEL_SUFFIX, '*'),             /* MODEL_SUFFIX */
                   (P_ACC_COUNT *  lvl_carrier_qty ) , -- P_COUNT *  lvl_carrier_qty  , -- NVL (1, 0),                        /* PRODUCT_ACTUAL_QTY */
                   SYSDATE,                                   /* ENTER_DATE */
                   'SYSTEM',                                    /* ENTER_BY */
                   SYSDATE,                             /* LAST_MODIFY_DATE */
                   'SYSTEM',                              /* LAST_MODIFY_BY */
                   1,                                    /* ORGANIZATION_ID */
                   P_COUNT,                      /* ORIGIN */
                   'Y',
                   'N',
                   F_GET_WORKTIME_SMT_ZONE (TO_CHAR (SYSDATE, 'YYYYMMDD'), TO_CHAR (SYSDATE, 'HH24MI'), 'ZONE'),
                   LVS_PCB_ITEM,
                   SYSDATE
            FROM IP_PRODUCT_MODEL_MASTER
            WHERE MODEL_NAME = LVS_MODEL_NAME  ;     -- SMT_MODEL_NAME = LVS_MODEL_NAME  ;
  
      EXCEPTION
         WHEN OTHERS THEN
              NULL;
      END;
      
   ELSE
     
      /*수량 업데이트 함 */
      UPDATE IP_PRODUCT_SENSOR_ACTUAL_TIME
         SET PRODUCT_ACTUAL_QTY = NVL (PRODUCT_ACTUAL_QTY, 0) + (P_ACC_COUNT *  lvl_carrier_qty ) , -- ( P_COUNT *  lvl_carrier_qty ) , -- 1
             ORIGIN_COUNT = P_COUNT,                 --누적 계수 ( 참조정보로만 사용 )
             LAST_RECEIPT_DATE = SYSDATE
       WHERE LINE_CODE   = LVS_LINE_CODE
         AND MODEL_NAME  = LVS_MODEL_NAME  -- = LVS_FEEDER_LAYOUT_NAME
         AND PCB_ITEM    = LVS_PCB_ITEM
         AND ORGANIZATION_ID = 1
         AND NVL (ACTUAL_TYPE, 'N') = 'N'
         AND RECEIPT_DATE  = F_GET_WORK_ACTUAL_DATE (SYSDATE, 'A')
         AND TIME_DIVISION = F_GET_WORKTIME_SMT_ZONE ( TO_CHAR (SYSDATE, 'YYYYMMDD'), TO_CHAR (SYSDATE, 'HH24MI'), 'ZONE' );
          
   END IF;


   PHASE := '80';
   --------------------------------------------------------------
   -- 시간대 별로  누적
   --
   --
   --------------------------------------------------------------
   LVI_COUNT := 0;
phase := '90' ;

   BEGIN
     
      SELECT COUNT (*)
        INTO LVI_COUNT
        FROM IP_PRODUCT_SENSOR_ACTUAL_HOUR
       WHERE LINE_CODE  = LVS_LINE_CODE
         AND MODEL_NAME = LVS_MODEL_NAME 
         AND PCB_ITEM = LVS_PCB_ITEM
         AND ORGANIZATION_ID = 1
         AND NVL (ACTUAL_TYPE, 'N') = 'N'
         AND RECEIPT_DATE  = F_GET_WORK_ACTUAL_DATE (SYSDATE, 'A')
         AND TIME_DIVISION = TO_CHAR (SYSDATE, 'HH24');
             
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
           LVI_COUNT := 0;
   END;

   PHASE := '90';

   IF NVL (LVI_COUNT, 0) = 0 THEN
     
      BEGIN
        
         --------------------------------------------------------------------------------
         -- 센서 감지 정보를 저장

         --------------------------------------------------------------------------------
         INSERT INTO IP_PRODUCT_SENSOR_ACTUAL_HOUR (
                                                    RECEIPT_DATE,
                                                    RECEIPT_SEQUENCE,
                                                    LINE_CODE,
                                                    WORKSTAGE_CODE,
                                                    MODEL_NAME,
                                                    MODEL_SUFFIX,
                                                    PRODUCT_ACTUAL_QTY,
                                                    ENTER_DATE,
                                                    ENTER_BY,
                                                    LAST_MODIFY_DATE,
                                                    LAST_MODIFY_BY,
                                                    ORGANIZATION_ID,
                                                    ORIGIN_COUNT,
                                                    IS_LAST_YN,
                                                    ACTUAL_TYPE,
                                                    TIME_DIVISION,
                                                    PCB_ITEM,
                                                    LAST_RECEIPT_DATE
                                                   )

        SELECT   F_GET_WORK_ACTUAL_DATE (SYSDATE, 'A'),
                 SEQ_PRODUCT_SENSOR.NEXTVAL,            /* RECEIPT_SEQUENCE */
                 LVS_LINE_CODE,                                /* LINE_CODE */
                 P_WORKSTAGE_CODE,
                 UPPER (MODEL_NAME),                      /* MODEL_NAME */
                 NVL (MODEL_SUFFIX, '*'),               /* MODEL_SUFFIX */
                 (P_ACC_COUNT *  lvl_carrier_qty ) , --( P_COUNT *  lvl_carrier_qty )  , --NVL (1, 0),                          /* PRODUCT_ACTUAL_QTY */
                 SYSDATE,                                     /* ENTER_DATE */
                 'SYSTEM',                                      /* ENTER_BY */
                 SYSDATE,                               /* LAST_MODIFY_DATE */
                 'SYSTEM',                                /* LAST_MODIFY_BY */
                 1,                                      /* ORGANIZATION_ID */
                 P_COUNT,                                               /* ORIGIN */
                 'Y',
                 'N',
                 TO_CHAR (SYSDATE, 'HH24'),
                 LVS_PCB_ITEM,
                 SYSDATE
            FROM IP_PRODUCT_MODEL_MASTER
           WHERE MODEL_NAME = LVS_MODEL_NAME  ;   -- SMT_MODEL_NAME = LVS_MODEL_NAME  ;

      EXCEPTION
         WHEN OTHERS THEN
              NULL;
      END;
      
   ELSE
     
      /*수량 업데이트 함 */
      UPDATE IP_PRODUCT_SENSOR_ACTUAL_HOUR
         SET PRODUCT_ACTUAL_QTY = NVL (PRODUCT_ACTUAL_QTY, 0) + (P_ACC_COUNT *  lvl_carrier_qty ) , --  ( P_COUNT *  lvl_carrier_qty ) , --1,
             ORIGIN_COUNT = P_COUNT,                 --누적 계수 ( 참조정보로만 사용 )
             LAST_RECEIPT_DATE = SYSDATE
       WHERE LINE_CODE  = LVS_LINE_CODE
         AND MODEL_NAME = LVS_MODEL_NAME 
         AND PCB_ITEM = LVS_PCB_ITEM
         AND ORGANIZATION_ID = 1
         AND NVL (ACTUAL_TYPE, 'N') = 'N'
         AND RECEIPT_DATE  = F_GET_WORK_ACTUAL_DATE (SYSDATE, 'A')
         AND TIME_DIVISION = TO_CHAR (SYSDATE, 'HH24');       
         
   END IF;
   
phase := '100' ;

   P_OUT := 'OK';
   RETURN;
   
EXCEPTION
   WHEN NO_DATA_FOUND THEN
        P_OUT := '';
        RETURN;
        
   WHEN OTHERS THEN
        P_OUT := 'PHASE='||phase||' Model Name='||LVS_MODEL_NAME||' '||SQLERRM;
        RETURN;
      
END P_INTERLOCK_SENSOR_ACTUAL;
