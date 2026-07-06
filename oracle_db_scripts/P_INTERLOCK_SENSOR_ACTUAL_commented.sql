CREATE OR REPLACE PROCEDURE "P_INTERLOCK_SENSOR_ACTUAL" (
  /* ================================================================
   * 프로시저명  : P_INTERLOCK_SENSOR_ACTUAL
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   인터락 조건, 상태, 실적 또는 검사 데이터를 처리한다.
   *   라인/공정/설비/품목 조건을 기준으로 원본 로직의 조회와 갱신을 수행한다.
   *   호출부가 인터락 결과와 메시지로 후속 처리를 판단할 수 있게 한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_LINE_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_WORKSTAGE_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_MACHINE_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_PCB_ITEM - 원본 선언부 기준 입력/출력 파라미터
   *   P_COUNT - 원본 선언부 기준 입력/출력 파라미터
   *   P_ACC_COUNT - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_LINE - Product Line Master
   *   IP_PRODUCT_MODEL_MASTER - 원본 로직 참조 테이블
   *   IP_PRODUCT_SENSOR_ACTUAL - 원본 로직 참조 테이블
   *   IP_PRODUCT_SENSOR_ACTUAL_HOUR - 원본 로직 참조 테이블
   *   IP_PRODUCT_SENSOR_ACTUAL_TIME - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_CARRIER_SIZE
   *   F_GET_WORKTIME_SMT_ZONE
   *   F_GET_WORK_ACTUAL_DATE
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_INTERLOCK_SENSOR_ACTUAL(...)
   * ================================================================ */
   P_LINE_CODE        IN     VARCHAR2,
   P_WORKSTAGE_CODE   IN     VARCHAR2,
   P_MACHINE_CODE     IN     VARCHAR2,
   P_PCB_ITEM         IN     VARCHAR2,
   P_COUNT            IN     NUMBER,       --누적 계수 수량
   P_ACC_COUNT        IN     NUMBER,       --   ( 1 , Network   1  )                
   P_OUT                 OUT VARCHAR2)
IS
   LVI_COUNT            NUMBER; -- [AI] 내부 처리용 변수
   LVS_LINE_CODE        VARCHAR2 (10); -- [AI] 내부 처리용 변수
   LVS_MODEL_NAME VARCHAR2 (30); -- [AI] 내부 처리용 변수
   LVS_PCB_ITEM         VARCHAR2 (10); -- [AI] 내부 처리용 변수

   LVS_ITEM_CODE        VARCHAR2 (30); -- [AI] 내부 처리용 변수
   LVS_OUT              VARCHAR2 (1000); -- [AI] 내부 처리용 변수
   lvi_exists           NUMBER; -- [AI] 내부 처리용 변수
   LVL_ACTUAL_QTY       NUMBER; -- [AI] 내부 처리용 변수
   LVL_SENSOR_ACTUAL    NUMBER; -- [AI] 내부 처리용 변수
   lvl_carrier_qty NUMBER; -- [AI] 내부 처리용 변수
   
   PHASE VARCHAR2(100) ; -- [AI] 내부 처리용 변수
/*****************************************************
*
*****************************************************/
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
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
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
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
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
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
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
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
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
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
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
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
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN NO_DATA_FOUND THEN
        P_OUT := '';
        RETURN;
        
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS THEN
        P_OUT := 'PHASE='||phase||' Model Name='||LVS_MODEL_NAME||' '||SQLERRM;
        RETURN;
      
END P_INTERLOCK_SENSOR_ACTUAL;
