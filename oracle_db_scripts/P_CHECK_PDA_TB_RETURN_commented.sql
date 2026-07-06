CREATE OR REPLACE PROCEDURE "P_CHECK_PDA_TB_RETURN" (
  /* ================================================================
   * 프로시저명  : P_CHECK_PDA_TB_RETURN
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2017-10-26
   * 수정이력:
   *   2017-10-26 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   입력 조건을 기준으로 업무 데이터의 유효성 또는 상태를 확인한다.
   *   조회 결과와 원본 분기 조건에 따라 OUT 파라미터 또는 상태 값을 설정한다.
   *   호출부가 결과 코드와 메시지로 후속 처리를 판단할 수 있게 한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_LINE_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_MODEL_NAME - 원본 선언부 기준 입력/출력 파라미터
   *   P_TOPBOT - 원본 선언부 기준 입력/출력 파라미터
   *   P_ADDRESS - 원본 선언부 기준 입력/출력 파라미터
   *   P_BARCODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_RETURN - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IB_PRODUCT_PLANDATA - 원본 로직 참조 테이블
   *   IM_ITEM_RECEIPT_BARCODE - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_ITEM_CODE_FROM_BARCODE
   *   F_GET_LOT_NO_FROM_BARCODE
   *   F_GET_LOT_QTY_FROM_BARCODE
   *   F_MSG
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_CHECK_PDA_TB_RETURN(...)
   * ================================================================ */
   P_LINE_CODE    IN     VARCHAR2,
   P_MODEL_NAME   IN     VARCHAR2,
   P_TOPBOT       IN     VARCHAR2,
   P_ADDRESS      IN     VARCHAR2,
   P_BARCODE      IN     VARCHAR2,
   P_RETURN          OUT VARCHAR2)
IS
   LVI_COUNT         NUMBER; -- [AI] 내부 처리용 변수
   LVS_OUT           VARCHAR2 (1000); -- [AI] 내부 처리용 변수
   LVS_MODEL_NAME    VARCHAR2 (30); -- [AI] 내부 처리용 변수

   LVL_FIRST         NUMBER; -- [AI] 내부 처리용 변수
   LVL_SECOND        NUMBER; -- [AI] 내부 처리용 변수
   LVS_ITEM_CODE     VARCHAR2(30); -- [AI] 내부 처리용 변수
   LVS_NEW_BARCODE   VARCHAR2 (100); -- [AI] 내부 처리용 변수
   LVL_ITEM_QTY      NUMBER; -- [AI] 내부 처리용 변수
   LVS_LOT_NO        VARCHAR2 (30); -- [AI] 내부 처리용 변수
   LVL_REMAIN_QTY    NUMBER; -- [AI] 내부 처리용 변수
   phase varchar2(10); -- [AI] 내부 처리용 변수
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.

    LVS_NEW_BARCODE := SUBSTR (UPPER (P_BARCODE), 1, 100);
  
   ------------------------------------------------------------------------------
   --
   ------------------------------------------------------------------------------

   IF LENGTH (LVS_NEW_BARCODE) < 10
   THEN
      P_RETURN := f_msg('[REEL RETURN] 바코드가 올바르지 않습니다.','K',1)
                  || ' = '
                  || P_ADDRESS
                  || ', '
                  || LVS_NEW_BARCODE;
      RETURN;
   END IF;
phase := '10' ;



 LVS_ITEM_CODE := f_get_item_code_from_barcode (lvs_new_barcode);
 lvs_lot_no := f_get_lot_no_from_barcode (lvs_new_barcode);
   
   
--   ----------------------------------------------------------------------------
--   --
--   ----------------------------------------------------------------------------
--   LVL_FIRST := INSTR (LVS_NEW_BARCODE, '-', 7);
--   phase := '14' ;
--   IF LVL_FIRST <= 0
--   THEN
--      LVL_SECOND := 0;
--   ELSE
--      LVL_SECOND := INSTR (LVS_NEW_BARCODE, '-', LVL_FIRST + 1);
--   END IF;
--   phase := '15' ;
--   IF LVL_FIRST <= 0
--   THEN
--      phase := '16' ;
--      LVS_ITEM_CODE := TRIM (SUBSTR (LVS_NEW_BARCODE, 1, 11));
--      phase := '17' ;
--   ELSE
--      phase := '18' ;
--      LVS_ITEM_CODE := SUBSTR (LVS_NEW_BARCODE, 1, LVL_FIRST - 1);
--      phase := '19' ;
--   END IF;
--   
--   phase := '20' ;
--   -----------------------------------------------------------------------------
--   --
--   -----------------------------------------------------------------------------
--   IF LVL_FIRST <= 0 AND LVL_SECOND <= 0
--   THEN
--      LVS_LOT_NO := LVS_NEW_BARCODE;
--   ELSIF LVL_FIRST > 0 AND LVL_SECOND <= 0
--   THEN
--      BEGIN
--         LVS_LOT_NO :=
--            TO_NUMBER (
--               SUBSTR (LVS_NEW_BARCODE,
--                       INSTR (LVS_NEW_BARCODE, '-', 7) + 1,
--                       100));
--      EXCEPTION
--         WHEN OTHERS
--         THEN
--            LVS_LOT_NO :=
--               SUBSTR (LVS_NEW_BARCODE,
--                       INSTR (LVS_NEW_BARCODE, '-', 1) + 1,
--                       100);
--      END;
--   ELSE
--      BEGIN
--         LVS_LOT_NO :=
--            TO_NUMBER (
--               SUBSTR (LVS_NEW_BARCODE,
--                       INSTR (LVS_NEW_BARCODE, '-', 7) + 1,
--                       (LVL_SECOND - LVL_FIRST) - 1));
--      EXCEPTION
--         WHEN OTHERS
--         -- CHAR TO NUMBER ERROR
--         THEN
--            LVS_LOT_NO :=
--               SUBSTR (LVS_NEW_BARCODE,
--                       INSTR (LVS_NEW_BARCODE, '-', 7) + 1,
--                       (LVL_SECOND - LVL_FIRST) - 1);
--      END;
--
--
--phase := '30' ;
--      -----------------------------------------------------------------
--      --
--      ----------------------------------------------------------------
--      BEGIN
--         LVL_ITEM_QTY :=
--            NVL (TO_NUMBER (SUBSTR (LVS_NEW_BARCODE, LVL_SECOND + 1, 10)), 0);
--      EXCEPTION
--         WHEN OTHERS
--         THEN
--            LVL_ITEM_QTY := 0;
--      END;
--   END IF;

   BEGIN
      lvl_item_qty := f_get_lot_qty_from_barcode (lvs_new_barcode);
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN OTHERS
      THEN
      p_return := f_msg('[REEL RETURN] 바코드 내 수량정보 오류 입니다.','K',1)   --'01 Qty Invalid in baarcoe '
                  || ' = '
                  || lvs_new_barcode ; 
      RETURN;
 
   END;
   
   
phase := '40' ;
   ----------------------------------------------------------------------------
   -- LINE OFF
   ---------------------------------------------------------------------------

   BEGIN
     
      SELECT COUNT (*)
        INTO LVI_COUNT
        FROM IB_PRODUCT_PLANDATA
       WHERE LINE_CODE = SUBSTR (P_LINE_CODE, 1, 2)
         AND MODEL_NAME = UPPER (P_MODEL_NAME);
             
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND THEN
           P_RETURN := f_msg('[REEL RETURN] 피더 레이아웃에 라인/적용모델이 없습니다.','K',1);   -- '1 Line/Model Notfound in Feeder Layout'
           RETURN;
   END;

   IF LVI_COUNT = 0 THEN
      P_RETURN := f_msg('[REEL RETURN] 피더 레이아웃에 라인/적용모델이 없습니다.','K',1);      -- '1 Line/Model Notfound in Feeder Layout'
      RETURN;
   END IF;

   LVI_COUNT := 0;
   phase := '50' ;
   -------------------------------------------------------------------
   -- 해당 모델이 활성화 상태인지 체크
   --
   -------------------------------------------------------------------
   BEGIN
     
      SELECT COUNT (*)
        INTO LVI_COUNT
        FROM IB_PRODUCT_PLANDATA
       WHERE LINE_CODE = SUBSTR (P_LINE_CODE, 1, 2)
         AND MODEL_NAME = UPPER (P_MODEL_NAME)
         AND ITEM_CODE = LVS_ITEM_CODE
         AND LOT_NO = LVS_LOT_NO
         AND LOCATION_CODE = P_ADDRESS
         AND ACTIVE_YN = 'Y';
         
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND THEN
           LVI_COUNT := 0;
   END;
   
phase := '60' ;
   IF LVI_COUNT = 0 THEN
     
      P_RETURN := f_msg('[REEL RETURN] 생산중인 모델/해당자재가 없습니다.','K',1)    -- '2 There is no model/material in production'
                  || ' = '
                  || P_ADDRESS
                  || ', '
                  || LVS_ITEM_CODE
                  || ', '
                  || LVS_LOT_NO;
      RETURN;
   --------------------------------------------------------------------
   --  남아있는 잔량을 조회 한다.
   --------------------------------------------------------------------
   ELSE
     
      BEGIN
        
         SELECT FEEDING_QTY - NVL (PRODUCT_ACTUAL_QTY, 0)
           INTO LVL_REMAIN_QTY
           FROM IB_PRODUCT_PLANDATA
          WHERE LINE_CODE = SUBSTR (P_LINE_CODE, 1, 2)
            AND MODEL_NAME = UPPER (P_MODEL_NAME)
            AND ITEM_CODE = LVS_ITEM_CODE
            AND LOT_NO = LVS_LOT_NO
            AND LOCATION_CODE = P_ADDRESS
            AND ACTIVE_YN = 'Y'
            AND CHECK_YN = 'Y';
                
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND THEN
           
            P_RETURN := f_msg('[REEL RETURN] 생산중인 모델/해당자재가 없습니다.','K',1)    -- '3 There is no model/material in production.'
                        || ' = '
                        || P_ADDRESS
                        || ', '
                        || LVS_ITEM_CODE
                        || ', '
                        || LVS_LOT_NO;
            RETURN;
            
      END;
phase := '70' ;
     -----------------------------------------------------------------
      -- 0 보다 작으면 리턴할수 없도록 조치 
      -- 20171026 yhs
      -----------------------------------------------------------------

      IF LVL_REMAIN_QTY < 0 THEN 
        
            P_RETURN := f_msg('[REEL RETURN] 리텅 수량이 0 보다 작습니다.','K',1)     -- 'Return QTY less then zero.'
                        || ' = '
                        || P_ADDRESS
                        || ', '
                        || LVS_ITEM_CODE
                        || ', '
                        || LVS_LOT_NO;
            RETURN;     
      
      END IF ;

      -----------------------------------------------------------------
      -- 바코드 이력 조회
      -----------------------------------------------------------------
      LVI_COUNT := 0;

      BEGIN
        
         SELECT COUNT (*)
           INTO LVI_COUNT
           FROM IM_ITEM_RECEIPT_BARCODE
          WHERE ITEM_CODE = LVS_ITEM_CODE
            AND LOT_NO = LVS_LOT_NO
            AND ORGANIZATION_ID = 1;
                
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND THEN
           
            P_RETURN := f_msg('[REEL RETURN] 자재가 바코드 입출고 이력에 없습니다.','K',1)   -- 'Material is not in receive/issue history.'
                        || ' = '
                        || P_ADDRESS
                        || ', '
                        || LVS_ITEM_CODE
                        || ', '
                        || LVS_LOT_NO;
            RETURN;
            
      END;
------------------------------------------------------------------
-- 바코드 마스터에  회수된 잔량을 기록해서 
-- 릴 체인지 또는 CCS 시에 NEW_SCAN_QTY 를 바코드수량보다 우선하여 
-- 장착수량으로 사용하도록 함.
-- 만약음수 상태에서 리턴하면 ?
--
------------------------------------------------------------------

      UPDATE IM_ITEM_RECEIPT_BARCODE
         SET NEW_SCAN_QTY = LVL_REMAIN_QTY
       WHERE ITEM_CODE = LVS_ITEM_CODE
         AND LOT_NO = LVS_LOT_NO
         AND ORGANIZATION_ID = 1;


phase := '80' ;
      ---------------------------------------------------------------
      -- 초기화
      -- 되돌릴수 없음 주의.
      -- 단일릴 회수 이므로 REEL_COLLECT_YN = 로 설정
      -- 회수 된 상태에서 는 릴교환이 안되므로 
      -- 릴교환 로직에 REEL_COLLECT_YN 인경우 제외하고 처리하도록 수
      ---------------------------------------------------------------
      UPDATE IB_PRODUCT_PLANDATA
         SET CCS_YN = 'N',
             CHECK_YN = 'N',
             FEEDING_END_DATE = NULL,
             FEEDING_QTY = FEEDING_QTY - LVL_REMAIN_QTY,
             CHECK_STATUS = 'W' ,
             REEL_COLLECT_YN = 'Y',
             LOT_NO = NULL,
             ITEM_BARCODE = '*'||ITEM_BARCODE
       WHERE LINE_CODE = SUBSTR (P_LINE_CODE, 1, 2)
         AND MODEL_NAME = UPPER (P_MODEL_NAME)
         AND ITEM_CODE = LVS_ITEM_CODE
         AND LOT_NO = LVS_LOT_NO
         AND LOCATION_CODE = P_ADDRESS
         AND ACTIVE_YN = 'Y'
         AND CHECK_YN = 'Y';
         
   END IF;
   
phase := '90' ;

   COMMIT;
   P_RETURN := 'OK';
   RETURN;
-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------
EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS
   THEN
      P_RETURN := 'NG, [REEL RETURN] ' ||'PHASE='||phase||' '||SQLERRM;
END;
