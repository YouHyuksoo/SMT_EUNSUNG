CREATE OR REPLACE PROCEDURE "P_INTERLOCK_CHECK_JIG" (
  /* ================================================================
   * 프로시저명  : P_INTERLOCK_CHECK_JIG
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   입력 조건을 기준으로 상태 또는 기준 데이터의 유효성을 확인한다.
   *   조회 결과와 원본 분기 조건에 따라 OUT 파라미터 또는 관련 상태 값을 설정한다.
   *   호출부가 결과 코드와 메시지로 후속 처리를 판단할 수 있게 한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_LINE_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_WORKSTAGE_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_MACHINE_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_RESULT - 원본 선언부 기준 입력/출력 파라미터
   *   P_JIG_MODEL_NAME - 원본 선언부 기준 입력/출력 파라미터
   *   P_JIG_TYPE - 원본 선언부 기준 입력/출력 파라미터
   *   P_JIG_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_JIG_LOT_NO - 원본 선언부 기준 입력/출력 파라미터
   *   P_HIT_COUNT - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IMCN_JIG - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_WORKSTAGE_TYPE
   *   F_MSG
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_INTERLOCK_CHECK_JIG(...)
   * ================================================================ */
   p_line_code        IN     VARCHAR2,
   p_workstage_code   IN     VARCHAR2,
   p_machine_code     IN     VARCHAR2,
   p_result              OUT VARCHAR2,
   p_jig_model_name      OUT VARCHAR2,
   p_jig_type            OUT VARCHAR2,
   p_jig_code            OUT VARCHAR2,
   p_jig_lot_no          OUT VARCHAR2,
   p_hit_count           OUT VARCHAR2)
IS
   lvl_count            NUMBER; -- [AI] 내부 처리용 변수
   lvs_jig_model_name   VARCHAR2 (30); -- [AI] 내부 처리용 변수
   lvs_jig_type         VARCHAR2 (30); -- [AI] 내부 처리용 변수
   lvs_jig_code         VARCHAR2 (30); -- [AI] 내부 처리용 변수
   lvs_jig_lot_no       VARCHAR2 (20); -- [AI] 내부 처리용 변수
   lvl_break_value      NUMBER; -- [AI] 내부 처리용 변수
   lvl_hit_value        NUMBER; -- [AI] 내부 처리용 변수
   lvs_jit_type_param   VARCHAR2 (10); -- [AI] 내부 처리용 변수
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
   --   ------------------------------------------------------------------
   --   --  TEMPORARY SETUP
   --   ------------------------------------------------------------------
   --   p_jig_model_name := 'START';
   --   p_jig_type := '*';
   --   p_jig_code := '*';
   --   p_hit_count := 0;
   --   p_jig_lot_no := '*';
   --   p_result := 'OK';
   --   RETURN;

   -----------------------------------------------------------
   -- RETURN : MODEL , TYPE , ITEM_CODE , LOT_NO , COUNT
   -----------------------------------------------------------
   -- T :  FIXTURE
   -- M : METAL MASK
   -----------------------------------------------------------
   IF F_GET_WORKSTAGE_TYPE(p_workstage_code )  = 'ICT'                           --ICT 공정이면 픽스쳐 지그 조회
   THEN
      lvs_jit_type_param := 'T';                                         --픽스쳐
   ELSIF F_GET_WORKSTAGE_TYPE(p_workstage_code )  = 'SPI'                                -- SP 공정이면
   THEN
      lvs_jit_type_param := 'M';                                         --마스크
   ELSE
      lvs_jit_type_param := '*';                                          --기타
   END IF;


   SELECT jig_model_name,
  -- jig_type ,
         DECODE(jig_type,'M' , 'MASK' ,'S' ,'SQUEEZE' , 'T' , 'FIXTURE' , jig_type ) ,
          jig_code,
          jig_lot_no,
          NVL (break_value, 0),
          NVL (hit_value, 0)
     INTO lvs_jig_model_name,
          lvs_jig_type,
          lvs_jig_code,
          lvs_jig_lot_no,
          lvl_break_value,
          lvl_hit_value
     FROM imcn_jig
    WHERE     line_code = p_line_code
          AND jig_type = lvs_jit_type_param
          AND ROWNUM = 1;

   IF lvl_break_value > lvl_hit_value
   THEN
      p_jig_model_name := lvs_jig_model_name;
      p_jig_type := lvs_jig_type;
      p_jig_code := lvs_jig_code;
      p_hit_count := lvl_hit_value;
      p_jig_lot_no := lvs_jig_lot_no;

      p_result := 'OK';
   ELSE
      p_jig_model_name := f_msg('수명초과','C',1);
      p_jig_type := lvs_jig_type;
      p_jig_code := lvs_jig_code;
      p_hit_count := lvl_hit_value;
      p_jig_lot_no := lvs_jig_lot_no;
      p_result := 'NG';
   END IF;

   RETURN;
EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN NO_DATA_FOUND
   THEN
      p_jig_model_name := f_msg('정보없음','C',1);
      p_jig_type := '*';
      p_jig_code := '*';
      p_hit_count := 0;
      p_jig_lot_no := '*';
      p_result := 'OK';
      RETURN;
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS
   THEN
      p_jig_model_name := f_msg('정보없음','C',1);
      p_jig_type := '*';
      p_jig_code := '*';
      p_hit_count := 0;
      p_jig_lot_no := '*';
      p_result := 'ERROR' || SQLERRM;
      RETURN;
END;                                                              -- Procedure