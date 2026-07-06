CREATE OR REPLACE PROCEDURE "P_CHECK_NG_UNLOCK" (
  /* ================================================================
   * 프로시저명  : P_CHECK_NG_UNLOCK
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   입력 조건을 기준으로 업무 데이터의 유효성 또는 상태를 확인한다.
   *   조회 결과와 원본 분기 조건에 따라 OUT 파라미터 또는 상태 값을 설정한다.
   *   호출부가 결과 코드와 메시지로 후속 처리를 판단할 수 있게 한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_LINE_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_MODEL_NAME - 원본 선언부 기준 입력/출력 파라미터
   *   P_SEQUENCE - 원본 선언부 기준 입력/출력 파라미터
   *   P_REASON - 원본 선언부 기준 입력/출력 파라미터
   *   P_USERID - 원본 선언부 기준 입력/출력 파라미터
   *   P_RETURN - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IB_PRODUCT_PLANDATA - 원본 로직 참조 테이블
   *   IB_SMT_CHECKHIST - 원본 로직 참조 테이블
   *   ISYS_CONFIG - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   P_INTERLOCK_SET_NSNP_TIME_MSG
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_CHECK_NG_UNLOCK(...)
   * ================================================================ */
   p_line_code    IN     VARCHAR2,
   p_model_name   IN     VARCHAR2,
   p_sequence     IN     VARCHAR2,
   p_reason       IN     VARCHAR2,
   p_userid       IN     VARCHAR2,
   p_return          OUT VARCHAR2)
IS
   LVF_REMAIN_TIME   NUMBER; -- [AI] 내부 처리용 변수
   lvl_remain_QTY    NUMBER; -- [AI] 내부 처리용 변수
   lvi_row_count  NUMBER ; -- [AI] 내부 처리용 변수
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
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
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
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
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS
   THEN
      p_return := 'NG, [P_CHECK_NG_UNLOCK] ERROR ' || SQLERRM;
      RETURN;
END;                                                              -- Procedure
