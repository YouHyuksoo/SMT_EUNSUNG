PROCEDURE "P_INTERLOCK_SENSOR_ACTUAL_NEO" (
   P_LINE_CODE        IN     VARCHAR2,
   P_WORKSTAGE_CODE   IN     VARCHAR2,
   P_MACHINE_CODE     IN     VARCHAR2,
   P_COUNT            IN     NUMBER,       --누적 계수 수량
   P_ACC_COUNT        IN     NUMBER,       --   ( 1 , Network   1  )                
   P_OUT                 OUT VARCHAR2)
IS
   LVI_COUNT            NUMBER;
   LVS_LINE_CODE        VARCHAR2 (10);
   LVS_FEEDER_LAYOUT_NAME       VARCHAR2 (30);
   LVS_MODEL_SUFFIX     VARCHAR2 (30);
   LVS_MODEL_NAME VARCHAR2 (30);
   LVS_PCB_ITEM         VARCHAR2 (10);

   LVS_ITEM_CODE        VARCHAR2 (30);
   LVS_OUT              VARCHAR2 (1000);
   LVL_HIT_VALUE        NUMBER;
   lvi_exists           NUMBER;
   LVL_ACTUAL_QTY       NUMBER;
   LVF_REAL_ST          NUMBER;
   LVL_NO_CSS_COUNT     NUMBER;

   LVL_SENSOR_ACTUAL    NUMBER;

   LVI_DUAL_COUNT       NUMBER;
   LVS_LINE_ACTIVE_YN   VARCHAR2 (10);
   LVS_SMT_MODEL_NAME VARCHAR2(50) ;

   LVS_LINE_CODE_GROUP VARCHAR2(10) ;
   LVI_LINE_COUNT NUMBER ;
   
   lvl_carrier_qty NUMBER;
   LVI_ADJUST_QTY NUMBER;
   LVS_RUN_NO VARCHAR2(30);
   PHASE VARCHAR2(100) ;
/*****************************************************
* 2015.12.21 장비 리셋등의 Logic 처리를 위해서
*            Count 수량 Logic 변경

*            장비에서 올리는 값으로 무존건 더하는 로직으로 변경

*****************************************************/
BEGIN
  LVS_LINE_CODE := SUBSTR (TRIM (P_LINE_CODE), 1, 2);

--------------------------------------------------------------------------
---- 듀얼 라인 여부를 판단해서 라인코드 바꿔줌 
--------------------------------------------------------------------------
--  BEGIN 
--    SELECT COUNT(*) 
--      INTO LVI_LINE_COUNT 
--      FROM IB_PRODUCT_PLANDATA
--     WHERE LINE_CODE = LVS_LINE_CODE 
--       AND ACTIVE_YN = 'Y' 
--       AND ROWNUM = 1;
--       
--   EXCEPTION WHEN NO_DATA_FOUND THEN     
--     LVI_LINE_COUNT := 0 ;
--   END ; 
   --------------------------------------
   -- 센서에서 올라온 라인이랑 동일하면 그냥 처리 
   --------------------------------------
--   IF   NVL(LVI_LINE_COUNT,0)> 0 THEN
--       NULL ;
--   ELSE
        
      -----------------------------------
      -- 라인 마스터에서 듀얼 그룹라인코드 조회 
      -----------------------------------
--      BEGIN  
--        SELECT LINE_CODE
--          INTO LVS_LINE_CODE_GROUP
--          FROM IB_PRODUCT_PLANDATA
--         WHERE LINE_CODE  IN ( SELECT LINE_CODE_GROUP FROM IP_PRODUCT_LINE WHERE LINE_CODE = LVS_LINE_CODE ) 
--           AND ACTIVE_YN = 'Y' AND ROWNUM = 1;
--      EXCEPTION WHEN NO_DATA_FOUND THEN
--      
--        LVS_LINE_CODE_GROUP := NULL ;
--        
--      END ;          
--      ------------------------------------------------------------------------
--      -- 두얼라인 으로 되어 있는지 조건 체크 
--      ------------------------------------------------------------------------
--      IF  LVS_LINE_CODE_GROUP IS NULL  OR  LVS_LINE_CODE = LVS_LINE_CODE_GROUP THEN 
--         NULL ;
--      ELSE
--           -----------------------------------------
--           -- 실적 올라온 라인의 그룹(듀얼라인) 으로 장착이 되어 있으면 
--           -----------------------------------------
--           LVS_LINE_CODE := LVS_LINE_CODE_GROUP ;
--      END IF ;
      
--   END IF ;


------------------------------------------------------------------------
phase := '10' ;

   ---------------------------------------------------------------------
   -- 피더레이아웃에서 활성화 되어 있는거를 조회 한다.
   -- SMT 모델과 피더레이아웃명을 조회 한다
   ---------------------------------------------------------------------
   BEGIN
phase := '20' ;
      SELECT  UPPER(MAX (MODEL_NAME)),
              MAX (PCB_ITEM),
              SUM (DECODE (NVL (CCS_YN, 'N'), 'N', 1, 0)) ,
              UPPER(MAX (SMT_MODEL_NAME))
        INTO LVS_FEEDER_LAYOUT_NAME, LVS_PCB_ITEM, LVL_NO_CSS_COUNT , LVS_SMT_MODEL_NAME
        FROM IB_PRODUCT_PLANDATA
       WHERE LINE_CODE = LVS_LINE_CODE AND ACTIVE_YN = 'Y';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         LVS_FEEDER_LAYOUT_NAME := '*';
   END;

   ----------------------------------------------------
   -- 활성 화되어 있는 피더레이이웃이 없으면
   ----------------------------------------------------
phase := '30' ;
   IF NVL (LVS_FEEDER_LAYOUT_NAME, '*') = '*'
   THEN
      P_OUT := 'NG ACTIVE PLAN NOT FOUND. Line Code=['||LVS_LINE_CODE||'] Line Group=['||LVS_LINE_CODE_GROUP||']';

      ------------------------------------------------------------------------
      -- nsnp 실적 초기회
      ------------------------------------------------------------------------
      BEGIN
         --------------------------------------------------------------------------------
         -- NSNP START
         --------------------------------------------------------------------------------
         p_interlock_set_nsnp_time_msg (LVS_line_code,
                                   'RESET',
                                   1,
                                   '*',
                                   '*',
                                   'RESET',
                                   'RESET LINE ACTUAL NO ACTIVE PLAN');
      --------------------------------------------------------------------------------
      -- NSNP END
      --------------------------------------------------------------------------------
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      RETURN;
   END IF;
phase := '40' ;
   -----------------------------------------------------------------------------------
   -- 라인 정보에서 모델/서픽스 조회
   -- 정상적으로 장착이 되면 라인마스터에 장착모델이 자동 세팅 되어 지므로.
   -----------------------------------------------------------------------------------
   BEGIN
      LVS_ITEM_CODE := '*';
      LVS_MODEL_SUFFIX := '*';

phase := '50' ;

        SELECT NVL (ITEM_CODE, '*'),   NVL (MODEL_NAME, '*'),  NVL (MODEL_SUFFIX, '*') , RUN_NO
          INTO LVS_ITEM_CODE, LVS_MODEL_NAME , LVS_MODEL_SUFFIX  , LVS_RUN_NO
          FROM IP_PRODUCT_LINE
         WHERE LINE_CODE = LVS_LINE_CODE ;
  
     EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
           LVS_ITEM_CODE := '*';
           LVS_MODEL_SUFFIX := '*';
  
        WHEN OTHERS
        THEN
           LVS_ITEM_CODE := '*';
           LVS_MODEL_SUFFIX := '*';
      END;
  -------------------------------------------------------
   --  X OUT PCB 를 위해 연배열 수량을 다시 가져옴 
   -------------------------------------------------------
phase := '55' ;
   BEGIN
      SELECT DECODE (NVL (B.CARRIER_SIZE_ADJUST_QTY, 0),0,0,NVL (B.CARRIER_SIZE_ADJUST_QTY, 0))
        INTO LVI_ADJUST_QTY
        FROM ib_product_plandata A, IB_SMT_FEEDER_SHAFT B
       WHERE     A.line_code = LVS_LINE_CODE
             AND A.model_name = LVS_FEEDER_LAYOUT_NAME
             AND A.active_yn = 'Y'
             AND A.LINE_CODE = B.LINE_CODE
             AND A.MODEL_NAME = B.MODEL_NAME
             AND NVL (B.CARRIER_SIZE_ADJUST_YN, 'N') = 'Y'
             AND ROWNUM = 1;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         LVI_ADJUST_QTY := 0;
   END;
   phase := '70' ;
   -------------------------------------------------------
   -- 
   -------------------------------------------------------
   IF NVL (LVI_ADJUST_QTY, 0) = 0
   THEN
      lvl_carrier_qty := F_GET_CARRIER_SIZE (LVS_MODEL_NAME, 1);   
   ELSE
      lvl_carrier_qty := LVI_ADJUST_QTY;
   END IF;
------------------------------------------------------------
-- 피더레이아웃에 이미 연배열 수량으로 단위수량을 설정해서 
-- 만들기때문에 여기선 실적수량만 넘기고
-- FEEDER ACTUAL 에서 소요량을 X 아웃 감안된 수량을 계산해서 처리 
------------------------------------------------------------
--     lvl_carrier_qty := 1 ;
     
     
   --------------------------------------------------------------------------------
   --smt 모델을 가지고 실제 제품 모델을찾아서 센서 감지 수량을 저장 .
   --------------------------------------------------------------------------------
phase := '60' ;
   BEGIN
      SELECT COUNT (*)
        INTO LVI_COUNT
        FROM IP_PRODUCT_SENSOR_ACTUAL
       WHERE   LINE_CODE = LVS_LINE_CODE
             AND MODEL_NAME IN ( SELECT MODEL_NAME FROM IP_PRODUCT_MODEL_MASTER
                                               WHERE SMT_MODEL_NAME = LVS_SMT_MODEL_NAME )
             AND ORGANIZATION_ID = 1
             AND IS_LAST_YN = 'Y';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         LVI_COUNT := 0;
   END;
phase := '70' ;
   IF NVL (LVI_COUNT, 0) = 0
   THEN
      --------------------------------------------------------------------------------
      -- 센서 감지 정보를 저장
      -- P_COUNT 는 계속 1 만 넘어와야 함
      -- 누락이 있으면 누락된 수량 포함해서 넘기고 그다음부터는 다시 1 부터 
      --------------------------------------------------------------------------------
      INSERT
        INTO IP_PRODUCT_SENSOR_ACTUAL (
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
                LAST_RECEIPT_DATE,
                RUN_NO )
      SELECT  SYSDATE,                                      /* RECEIPT_DATE */
              SEQ_PRODUCT_SENSOR.NEXTVAL,               /* RECEIPT_SEQUENCE */
              LVS_LINE_CODE,                                     /* LINE_CODE */
              P_WORKSTAGE_CODE,
              MODEL_NAME,                                 /* MODEL_NAME */
              NVL (MODEL_SUFFIX, '*'),                  /* MODEL_SUFFIX */
              (P_ACC_COUNT *  lvl_carrier_qty ) , --   NVL (1, 0),                             /* PRODUCT_ACTUAL_QTY */
              SYSDATE,                                        /* ENTER_DATE */
              'SENSOR ACTUAL NEO',                              /* ENTER_BY */
              SYSDATE,                                  /* LAST_MODIFY_DATE */
              'SYSTEM',                                   /* LAST_MODIFY_BY */
              1,                                         /* ORGANIZATION_ID */
              P_COUNT ,
              'Y',
              'N',
              LVS_PCB_ITEM,
              0 ,
              SYSDATE ,                                                  /* ORIGIN */
              LVS_RUN_NO
         FROM IP_PRODUCT_MODEL_MASTER
        WHERE SMT_MODEL_NAME = LVS_SMT_MODEL_NAME  ;
        --SMT_MODEL_NAME = LVS_FEEDER_LAYOUT_NAME ;



   ELSE
      /*수량 업데이트 함 */
      UPDATE IP_PRODUCT_SENSOR_ACTUAL
         SET PRODUCT_ACTUAL_QTY = NVL (PRODUCT_ACTUAL_QTY, 0) + (P_ACC_COUNT *  lvl_carrier_qty ) , --NVL (1, 0),
             ORIGIN_COUNT = P_COUNT,                 --누적 계수 ( 참조정보로만 사용 )
             ENTER_BY = 'SENSOR ACTUAL NEO' ,
             RUN_NO = LVS_RUN_NO
       WHERE     LINE_CODE = LVS_LINE_CODE
             AND MODEL_NAME  IN ( SELECT MODEL_NAME FROM IP_PRODUCT_MODEL_MASTER WHERE SMT_MODEL_NAME = LVS_SMT_MODEL_NAME  )
             AND ORGANIZATION_ID = 1;
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
       WHERE     LINE_CODE   = LVS_LINE_CODE
             AND MODEL_NAME  IN ( SELECT MODEL_NAME FROM IP_PRODUCT_MODEL_MASTER WHERE  SMT_MODEL_NAME = LVS_SMT_MODEL_NAME  ) -- = LVS_FEEDER_LAYOUT_NAME
             AND PCB_ITEM    = LVS_PCB_ITEM
             AND ORGANIZATION_ID = 1
             AND NVL (ACTUAL_TYPE, 'N') = 'N'
             AND RECEIPT_DATE = F_GET_WORK_ACTUAL_DATE (SYSDATE, 'A')
             AND TIME_DIVISION =
                    F_GET_WORKTIME_SMT_ZONE (TO_CHAR (SYSDATE, 'YYYYMMDD'),
                                             TO_CHAR (SYSDATE, 'HH24MI'),
                                             'ZONE');
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         LVI_COUNT := 0;
   END;

   PHASE := '70';

   IF NVL (LVI_COUNT, 0) = 0
   THEN
      --------------------------------------------------------------------------------
      -- 센서 감지 정보를 저장

      --------------------------------------------------------------------------------

      BEGIN
         INSERT
           INTO IP_PRODUCT_SENSOR_ACTUAL_TIME (
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
                   LAST_RECEIPT_DATE )
--         VALUES (
--                   F_GET_WORK_ACTUAL_DATE (SYSDATE, 'A'),
--                   SEQ_PRODUCT_SENSOR.NEXTVAL,          /* RECEIPT_SEQUENCE */
--                   LVS_LINE_CODE,                              /* LINE_CODE */
--                   P_WORKSTAGE_CODE,
--                   UPPER (LVS_FEEDER_LAYOUT_NAME),                    /* MODEL_NAME */
--                   NVL (LVS_MODEL_SUFFIX, '*'),             /* MODEL_SUFFIX */
--                   NVL (1, 0),                        /* PRODUCT_ACTUAL_QTY */
--                   SYSDATE,                                   /* ENTER_DATE */
--                   'SYSTEM',                                    /* ENTER_BY */
--                   SYSDATE,                             /* LAST_MODIFY_DATE */
--                   'SYSTEM',                              /* LAST_MODIFY_BY */
--                   1,                                    /* ORGANIZATION_ID */
--                   1,                                             /* ORIGIN */
--                   'Y',
--                   'N',
--                   F_GET_WORKTIME_SMT_ZONE (TO_CHAR (SYSDATE, 'YYYYMMDD'),
--                                            TO_CHAR (SYSDATE, 'HH24MI'),
--                                            'ZONE'),
--                   LVS_PCB_ITEM,
--                   SYSDATE );

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
                   F_GET_WORKTIME_SMT_ZONE (TO_CHAR (SYSDATE, 'YYYYMMDD'),
                                            TO_CHAR (SYSDATE, 'HH24MI'),
                                            'ZONE'),
                   LVS_PCB_ITEM,
                   SYSDATE
            FROM IP_PRODUCT_MODEL_MASTER
            WHERE SMT_MODEL_NAME = LVS_SMT_MODEL_NAME  ;
            --SMT_MODEL_NAME = LVS_FEEDER_LAYOUT_NAME ;

      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;
   ELSE
      /*수량 업데이트 함 */
      UPDATE IP_PRODUCT_SENSOR_ACTUAL_TIME
         SET PRODUCT_ACTUAL_QTY = NVL (PRODUCT_ACTUAL_QTY, 0) + (P_ACC_COUNT *  lvl_carrier_qty ) , -- ( P_COUNT *  lvl_carrier_qty ) , -- 1
             ORIGIN_COUNT = P_COUNT,                 --누적 계수 ( 참조정보로만 사용 )
             LAST_RECEIPT_DATE = SYSDATE
       WHERE     LINE_CODE = LVS_LINE_CODE
             AND MODEL_NAME  IN ( SELECT MODEL_NAME FROM IP_PRODUCT_MODEL_MASTER WHERE SMT_MODEL_NAME = LVS_SMT_MODEL_NAME   )
             AND PCB_ITEM = LVS_PCB_ITEM
             AND ORGANIZATION_ID = 1
             AND RECEIPT_DATE = F_GET_WORK_ACTUAL_DATE (SYSDATE, 'A')
             AND NVL (ACTUAL_TYPE, 'N') = 'N'
             AND TIME_DIVISION =
                    F_GET_WORKTIME_SMT_ZONE (TO_CHAR (SYSDATE, 'YYYYMMDD'),
                                             TO_CHAR (SYSDATE, 'HH24MI'),
                                             'ZONE');
           --  AND LAST_RECEIPT_DATE <> SYSDATE;
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
       WHERE     LINE_CODE = LVS_LINE_CODE
             AND MODEL_NAME  IN ( SELECT MODEL_NAME FROM IP_PRODUCT_MODEL_MASTER WHERE SMT_MODEL_NAME = LVS_SMT_MODEL_NAME   )
             AND PCB_ITEM = LVS_PCB_ITEM
             AND ORGANIZATION_ID = 1
             AND NVL (ACTUAL_TYPE, 'N') = 'N'
             AND RECEIPT_DATE = F_GET_WORK_ACTUAL_DATE (SYSDATE, 'A')
             AND TIME_DIVISION = TO_CHAR (SYSDATE, 'HH24');
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         LVI_COUNT := 0;
   END;

   PHASE := '90';

   IF NVL (LVI_COUNT, 0) = 0
   THEN
      BEGIN
         --------------------------------------------------------------------------------
         -- 센서 감지 정보를 저장

         --------------------------------------------------------------------------------
         INSERT
           INTO IP_PRODUCT_SENSOR_ACTUAL_HOUR (
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
                   LAST_RECEIPT_DATE)

--         VALUES (F_GET_WORK_ACTUAL_DATE (SYSDATE, 'A'),
--                 SEQ_PRODUCT_SENSOR.NEXTVAL,            /* RECEIPT_SEQUENCE */
--                 LVS_LINE_CODE,                                /* LINE_CODE */
--                 P_WORKSTAGE_CODE,
--                 UPPER (LVS_FEEDER_LAYOUT_NAME),                      /* MODEL_NAME */
--                 NVL (LVS_MODEL_SUFFIX, '*'),               /* MODEL_SUFFIX */
--                 NVL (1, 0),                          /* PRODUCT_ACTUAL_QTY */
--                 SYSDATE,                                     /* ENTER_DATE */
--                 'SYSTEM',                                      /* ENTER_BY */
--                 SYSDATE,                               /* LAST_MODIFY_DATE */
--                 'SYSTEM',                                /* LAST_MODIFY_BY */
--                 1,                                      /* ORGANIZATION_ID */
--                 1,                                               /* ORIGIN */
--                 'Y',
--                 'N',
--                 TO_CHAR (SYSDATE, 'HH24'),
--                 LVS_PCB_ITEM,
--                 SYSDATE );

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
            WHERE SMT_MODEL_NAME = LVS_SMT_MODEL_NAME  ;
            --SMT_MODEL_NAME = LVS_FEEDER_LAYOUT_NAME ;


      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;
   ELSE
      /*수량 업데이트 함 */
      UPDATE IP_PRODUCT_SENSOR_ACTUAL_HOUR
         SET PRODUCT_ACTUAL_QTY = NVL (PRODUCT_ACTUAL_QTY, 0) + (P_ACC_COUNT *  lvl_carrier_qty ) , --  ( P_COUNT *  lvl_carrier_qty ) , --1,
             ORIGIN_COUNT = P_COUNT,                 --누적 계수 ( 참조정보로만 사용 )
             LAST_RECEIPT_DATE = SYSDATE
       WHERE     LINE_CODE = LVS_LINE_CODE
             AND MODEL_NAME  IN ( SELECT MODEL_NAME FROM IP_PRODUCT_MODEL_MASTER WHERE SMT_MODEL_NAME = LVS_SMT_MODEL_NAME   )
             AND PCB_ITEM = LVS_PCB_ITEM
             AND ORGANIZATION_ID = 1
             AND RECEIPT_DATE = F_GET_WORK_ACTUAL_DATE (SYSDATE, 'A')
             AND NVL (ACTUAL_TYPE, 'N') = 'N'
             AND TIME_DIVISION = TO_CHAR (SYSDATE, 'HH24') ;
         --    AND LAST_RECEIPT_DATE <>  SYSDATE ;
            
   END IF;
phase := '100' ;
  
      BEGIN
         ----------------------------------------------------------------
         --  지그 사용 이력을 업데이트 한다
         --  공정코드에 'ALL' 을 입력하면 모든 지그를 한꺼번에
         --  사용수량을 증가 한다.
         ----------------------------------------------------------------
   
         P_INTERLOCK_SET_JIG (P_LINE_CODE,
                              'ALL',                                 -- 공정 또는 ALL
                              P_MACHINE_CODE,
                              LVS_OUT,
                              LVL_HIT_VALUE);
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

   ----------------------------------------------------------------
   -- 피더 잔량 변경
   -- 한피시비에 두모델인경우 를 생각해서 MAX 값으로 리 가져옴 
   -- 만약 한 피시비에서 두모델인데 연배열이 틀린경우는 문제될수 있으니 그런경우 없을것으로 보임
   --
   ----------------------------------------------------------------
   SELECT MAX(NVL (PRODUCT_ACTUAL_QTY, 0))
     INTO LVL_SENSOR_ACTUAL
     FROM IP_PRODUCT_SENSOR_ACTUAL
    WHERE     LINE_CODE = LVS_LINE_CODE
          AND MODEL_NAME  IN ( SELECT MODEL_NAME FROM IP_PRODUCT_MODEL_MASTER WHERE SMT_MODEL_NAME = LVS_SMT_MODEL_NAME  )
          AND ORGANIZATION_ID = 1;
  

   BEGIN
phase := '110' ;
      --------------------------------------------------------------
      -- 실제 plandata 테이블은 레이아웃 명으로 찾아서 실적 누적
      --------------------------------------------------------------
      P_INTERLOCK_FEEDER_ACTUAL (LVS_LINE_CODE,
                                 LVS_FEEDER_LAYOUT_NAME, --  피더레이아웃용 모델 명
                                 NVL(LVL_SENSOR_ACTUAL,0),
                                 LVS_OUT);
   EXCEPTION
      WHEN OTHERS
      THEN
         P_OUT := SQLERRM;
         
   END;

   COMMIT;

   P_OUT := 'OK';
   RETURN;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      P_OUT := '';
      RETURN;
   WHEN OTHERS
   THEN
      P_OUT := 'PHASE='||phase||' Feeder Name='||LVS_FEEDER_LAYOUT_NAME||' SMT Model Name='||LVS_SMT_MODEL_NAME||' '||SQLERRM;
      RETURN;
END P_INTERLOCK_SENSOR_ACTUAL_NEO;