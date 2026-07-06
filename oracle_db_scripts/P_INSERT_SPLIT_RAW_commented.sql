CREATE OR REPLACE PROCEDURE "P_INSERT_SPLIT_RAW" (
  /* ================================================================
   * 프로시저명  : P_INSERT_SPLIT_RAW
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   외부 또는 설비에서 전달된 원시/연계 데이터를 대상 테이블에 등록한다.
   *   입력 파라미터와 원본 로직의 데이터 적재 흐름은 그대로 유지했다.
   *   오류 발생 시 원본 예외 처리 방식에 따라 메시지 반환 또는 로그 처리를 수행한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_DATA - 원본 선언부 기준 입력/출력 파라미터
   *   P_INFO - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IB_PRODUCT_PLANDATA - 원본 로직 참조 테이블
   *   IB_SMT_CHECKHIST - 원본 로직 참조 테이블
   *   ICOM_MACHINE_INSERT_LOG - 원본 로직 참조 테이블
   *   IP_PRODUCT_LINE - Product Line Master
   *   IQ_MACHINE_INSPECT_DATA_SPLIT - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_MSG
   *   P_DATA
   *   P_INFO
   *   P_INTERLOCK_SET_NSNP_TIME_MSG
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_INSERT_SPLIT_RAW(...)
   * ================================================================ */
   P_DATA   IN ARRAY5_PARAMS_T,
   P_INFO   IN ARRAY5_PARAMS_T)
IS
   LVS_FILE_NAME      VARCHAR2 (200) := ''; -- [AI] 내부 처리용 변수
   LVS_LINE_CODE      VARCHAR2 (20) := ''; -- [AI] 내부 처리용 변수
   LVS_MACHINE_CODE   VARCHAR2 (20) := ''; -- [AI] 내부 처리용 변수
   LVS_COLUMN_COUNT   VARCHAR2 (20) := ''; -- [AI] 내부 처리용 변수
   LVS_ERRORMSG       VARCHAR2 (32000); -- [AI] 내부 처리용 변수
   LVS_LOCATION_CODE  VARCHAR2(10) ; -- [AI] 내부 처리용 변수
   LVS_FEEDERBASEID   VARCHAR2(10) ; -- [AI] 내부 처리용 변수
   LVS_POSITION       VARCHAR2(10) ; -- [AI] 내부 처리용 변수
   LVDT_CHECK_DATE    DATE ; -- [AI] 내부 처리용 변수
   LVS_CHECK_STATUS   VARCHAR2(10) ; -- [AI] 내부 처리용 변수
   LVF_TERM_HOUR      NUMBER ; -- [AI] 내부 처리용 변수
   LVS_LAST_CHANGE_LOT_NO VARCHAR2(100) ; -- [AI] 내부 처리용 변수
   LVS_MODEL_NAME     VARCHAR2(50) ; -- [AI] 내부 처리용 변수
   LVL_FEEDING_COUNT  NUMBER ; -- [AI] 내부 처리용 변수
   LVL_CHANGE_EVENT_COUNT  NUMBER ; -- [AI] 내부 처리용 변수
   LVS_PCB_ITEM       VARCHAR2(20); -- [AI] 내부 처리용 변수
   LVS_RUN_NO VARCHAR2(50) ; -- [AI] 내부 처리용 변수
   
   LVL_IGNORE_COUNT  NUMBER := 0; --건수를 무시하는 횟수 -- [AI] 내부 처리용 변수
--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------

BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.

   IF P_INFO.LAST >= 1
   THEN
      LVS_FILE_NAME := REPLACE (TRIM (P_INFO (1)), '"');
   END IF;

   IF P_INFO.LAST >= 2
   THEN
      LVS_LINE_CODE := REPLACE (TRIM (P_INFO (2)), '"');
   END IF;

   IF P_INFO.LAST >= 3
   THEN
      LVS_MACHINE_CODE := REPLACE (TRIM (P_INFO (3)), '"');
   END IF;
   LVS_COLUMN_COUNT :=  TO_CHAR( P_DATA.LAST ); 

        --------------------------------------------------------------
        -- 이력저장
        --------------------------------------------------------------
        LVS_LINE_CODE :=  TRIM(TO_CHAR(SUBSTR(REPLACE(TRIM (P_DATA(3)), '"'),5,2) , '00'))  ;
        LVS_MACHINE_CODE :=  TRIM(TO_CHAR(SUBSTR(REPLACE(TRIM (P_DATA(4)), '"'),5,2) , '00'))  ;
        
        LVS_FEEDERBASEID := REPLACE (TRIM (P_DATA(6)), '"') ;
        LVS_POSITION := REPLACE (TRIM (P_DATA(7)), '"') ;
        
        --------------------------------------------------------------
        -- 로케이션 코드 조합 생성
        --------------------------------------------------------------
        
        IF LVS_MACHINE_CODE = '01' THEN 
        
           IF LVS_FEEDERBASEID   = '1' THEN
              LVS_LOCATION_CODE := 'A'||LVS_POSITION ; 
           ELSE
              LVS_LOCATION_CODE := 'B'||LVS_POSITION ; 
           END IF ;
          
        ELSIF LVS_MACHINE_CODE = '02' THEN 
          IF LVS_FEEDERBASEID = '1' THEN
              LVS_LOCATION_CODE := 'C'||LVS_POSITION ; 
           ELSE
              LVS_LOCATION_CODE := 'D'||LVS_POSITION ; 
           END IF ;        
        ELSIF LVS_MACHINE_CODE = '03' THEN   
            IF LVS_FEEDERBASEID = '1' THEN
              LVS_LOCATION_CODE := 'E'||LVS_POSITION ; 
           ELSE
              LVS_LOCATION_CODE := 'F'||LVS_POSITION ; 
           END IF ;      
        ELSIF LVS_MACHINE_CODE = '04' THEN 
        
          IF LVS_FEEDERBASEID = '1' THEN
              LVS_LOCATION_CODE := 'G'||LVS_POSITION ; 
           ELSE
              LVS_LOCATION_CODE := 'H'||LVS_POSITION ; 
           END IF ;        
        ELSIF LVS_MACHINE_CODE = '05' THEN 
                  IF LVS_FEEDERBASEID = '1' THEN
              LVS_LOCATION_CODE := 'I'||LVS_POSITION ; 
           ELSE
              LVS_LOCATION_CODE := 'J'||LVS_POSITION ; 
           END IF ;
        ELSIF LVS_MACHINE_CODE = '06' THEN 
                  IF LVS_FEEDERBASEID = '1' THEN
              LVS_LOCATION_CODE := 'K'||LVS_POSITION ; 
           ELSE
              LVS_LOCATION_CODE := 'L'||LVS_POSITION ; 
           END IF ;
        END IF ;
    
    ------------------------------------------------------------------------
    -- 라인 마스터에서 런번호 추출 
    ------------------------------------------------------------------------
    BEGIN
       SELECT RUN_NO INTO LVS_RUN_NO 
         FROM IP_PRODUCT_LINE 
        WHERE LINE_CODE = LVS_LINE_CODE ;
    EXCEPTION WHEN OTHERS THEN 
       LVS_RUN_NO := '*' ;
    END ;    
    
    -----------------------------------------------------------------------
    -- 해당라인 엑티브된 레이아웃에 이벤트 횟수저장
    -----------------------------------------------------------------------      
      UPDATE IB_PRODUCT_PLANDATA
         SET CHANGE_EVENT_COUNT = NVL(CHANGE_EVENT_COUNT,0) + 1
       WHERE LINE_CODE     = LVS_LINE_CODE
         AND LOCATION_CODE = LVS_LOCATION_CODE
         AND ACTIVE_YN     = 'Y' ;    
  
    -----------------------------------------------------------------------
    --  이벤트 발생횟수 카운트 
    -----------------------------------------------------------------------        
      BEGIN   
          SELECT nvl(CHANGE_EVENT_COUNT,0) INTO LVL_CHANGE_EVENT_COUNT
            FROM IB_PRODUCT_PLANDATA
           WHERE LINE_CODE     = LVS_LINE_CODE
             AND LOCATION_CODE = LVS_LOCATION_CODE
             AND ACTIVE_YN     = 'Y' ; 
      EXCEPTION WHEN NO_DATA_FOUND THEN 
          LVL_CHANGE_EVENT_COUNT := 0 ;
      END ; 
    -----------------------------------------------------------------------
    -- 최종 걸려있는 롯트번호 추출 
    -----------------------------------------------------------------------
     BEGIN
      SELECT ITEM_BARCODE  , 
             SMT_MODEL_NAME , 
             FEEDING_COUNT , 
             PCB_ITEM
        INTO LVS_LAST_CHANGE_LOT_NO ,
             LVS_MODEL_NAME , 
             LVL_FEEDING_COUNT , -- CCS / 릴교환 프로시에서 자동 증가
             LVS_PCB_ITEM
        FROM IB_PRODUCT_PLANDATA
       WHERE LINE_CODE     = LVS_LINE_CODE
         AND LOCATION_CODE = LVS_LOCATION_CODE
         AND ACTIVE_YN     = 'Y'
         AND ROWNUM = 1 ;   
     EXCEPTION WHEN NO_DATA_FOUND THEN 
         LVS_LAST_CHANGE_LOT_NO := 'NOTFOUND' ;
     END ;
       -----------------------------------------------------------------------
       -- 릴교환을 했는지 판단하는 로직 구성
       -- 교환 횟수( MES 는 CCS 횟수도 증가함 ) 와 이벤트 발생 횟수로 비교 
       -- MES 는 CCS 건수 1 회를 빼고 비교 
       -----------------------------------------------------------------------
       BEGIN 
           SELECT MAX(CHECK_DATE) , ( SYSDATE - MAX(CHECK_DATE))  * 24
             INTO LVDT_CHECK_DATE , LVF_TERM_HOUR
             FROM IB_SMT_CHECKHIST
            WHERE LINE_CODE = LVS_LINE_CODE
              AND LOCATION_CODE = LVS_LOCATION_CODE
              AND CHECK_TYPE = '2'   -- 릴교환
              AND CHECK_STATUS = 'P' -- 합격인것
              ;
       EXCEPTION WHEN OTHERS THEN 
           LVDT_CHECK_DATE := NULL;
       END ;
       --------------------------------------------------------
       -- 지정 시간 이내에 교환 이력이 없으면 NG 처리 
       -- 8 시간전에 교환 하기도 하고 그래서 시간 처리 의미없어서 막음
       --------------------------------------------------------
--       IF LVF_TERM_HOUR >= 2 THEN 
--          LVS_CHECK_STATUS :='NG' ;
--       ELSE
--          LVS_CHECK_STATUS := 'OK' ;
--       END IF  ;
       --------------------------------------------------------
       -- MES 릴장착 CCS 도 카운트 되므로 1 을 빼고 비교 한다 
       -- 한화마운터 이벤트는 최초장착(CCS) 은 건수를 안보낸다는 전제로 비교
       -- 이미 이전롯트에서 릴교환을 한상태로 릴을 회수하면 테이프가 릴안에 
       -- 들어가 있는경우가 있으므로 이경우 마운터이벤트에서 올라온 건수제외 로직 추가
       --
       --------------------------------------------------------
       
       
       
       --------------------------------------------------------
       IF LVL_FEEDING_COUNT -1  <  LVL_CHANGE_EVENT_COUNT - LVL_IGNORE_COUNT THEN 
               LVS_CHECK_STATUS :='NG' ;
               
                 BEGIN
                 --------------------------------------------------------------------------------
                 -- NSNP START
                 --------------------------------------------------------------------------------
                 p_interlock_set_nsnp_time_msg (
                                                 LVS_LINE_CODE,
                                                 1,
                                                 1,
                                                 LVS_MODEL_NAME,
                                                 '*',
                                                 'REEL CHECK',
                                                 f_msg('[REEL] SPLIT 이력없음.','K',1)    -- 'No Issued Material '
                                                 || 'RunNo='||LVS_RUN_NO||' Location='|| LVS_LOCATION_CODE
                                                 || ' Feeding='||LVL_FEEDING_COUNT||' Event='||LVL_CHANGE_EVENT_COUNT
                                                );
              --------------------------------------------------------------------------------
              -- NSNP END
              --------------------------------------------------------------------------------
              EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
                 WHEN OTHERS THEN
                      NULL;
              END;
       ELSE
               LVS_CHECK_STATUS := 'OK' ;
       END IF ;
       -----------------------------------------------------------------------
       INSERT INTO IQ_MACHINE_INSPECT_DATA_SPLIT (      

                                                SPLIT_DATE, 
                                                SPLIT_TIME, 
                                                LINE,
                                                EQP,
                                                FEEDERBASE,
                                                FEEDERBASEID,
                                                SLOTID,
                                                CURRENTREELBARCODE,
                                                PARTNAME,
                                                REMAINCOUNT,
                                                STATUS,
                                                
                                                LOCATION_CODE ,
                                                LAST_CHANGE_DATE ,
                                                LAST_CHANGE_LOT_NO ,
                                                CHECK_STATUS ,

                                                ENTER_DATE,
                                                ENTER_BY,
                                                FILE_NAME,
                                                LINE_CODE,
                                                MACHNE_CODE,
                                                ORGANIZATION_ID ,
                                                MODEL_NAME ,
                                                FEEDING_COUNT , --릴교환건수 
                                                CHANGE_EVENT_COUNT ,
                                                PCB_ITEM ,
                                                RUN_NO
                                             )
                                     VALUES (

                                                REPLACE (TRIM (P_DATA(1)), '"'),
                                                REPLACE (TRIM (P_DATA(2)), '"'),
                                                REPLACE (TRIM (P_DATA(3)), '"'), --LINE
                                                REPLACE (TRIM (P_DATA(4)), '"'), --EQP
                                                REPLACE (TRIM (P_DATA(5)), '"'), --BASE 1F , 1R
                                                REPLACE (TRIM (P_DATA(6)), '"'), --BASEID 1 , 2
                                                REPLACE (TRIM (P_DATA(7)), '"'), --POSITION
                                                REPLACE (TRIM (P_DATA(8)), '"'),
                                                REPLACE (TRIM (P_DATA(9)), '"'),
                                                REPLACE (TRIM (P_DATA(10)), '"'),
                                                REPLACE (TRIM (P_DATA(11)), '"'),

                                                LVS_LOCATION_CODE ,
                                                
                                                LVDT_CHECK_DATE , 
                                                LVS_LAST_CHANGE_LOT_NO ,
                                                
                                                LVS_CHECK_STATUS ,
                                                
                                                SYSDATE,
                                                'FILE WATCHER',

                                                LVS_FILE_NAME,
                                                LVS_LINE_CODE,
                                                LVS_MACHINE_CODE,
                                                1 ,
                                                LVS_MODEL_NAME ,
                                                LVL_FEEDING_COUNT ,
                                                LVL_CHANGE_EVENT_COUNT ,
                                                LVS_PCB_ITEM ,
                                                LVS_RUN_NO
                                           );
   COMMIT;

EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS
   THEN

      LVS_ERRORMSG := '[P_INSERT_SPLIT_RAW]' ||SUBSTR (SQLERRM, 1, 200);
      ROLLBACK ;
      -------------------------------------------------------------------------
      --
      -------------------------------------------------------------------------      
      INSERT INTO ICOM_MACHINE_INSERT_LOG( LOG_DATE , ERROR_MESSAGE , ERROR_DESC )
       VALUES ( SYSDATE  , LVS_ERRORMSG  , 'FILE = '||LVS_FILE_NAME||', LINE = '||LVS_LINE_CODE || ', COLUMN COUNT = ' || LVS_COLUMN_COUNT ) ;
      COMMIT;
END P_INSERT_SPLIT_RAW;