CREATE OR REPLACE PROCEDURE "P_GET_INTERLOCK_CONDITION_CUR" (
  /* ================================================================
   * 프로시저명  : P_GET_INTERLOCK_CONDITION_CUR
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   라인과 공정 기준으로 사용 가능한 인터락 검사 조건을 조회한다.
   *   IQ_INTERLOCK_CHECK_CONDITION 테이블에서 사용 여부가 Y이거나 NULL인 조건만 대상으로 한다.
   *   조회 결과는 검사 순번 오름차순으로 정렬하여 SYS_REFCURSOR로 반환한다.
   *   설비코드와 PID 파라미터는 현재 SQL 조건에는 사용되지 않는 예비 입력값으로 보인다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_LINE_CODE       (IN, VARCHAR2) - 조회할 라인 코드
   *   P_WORKSTAGE_CODE  (IN, VARCHAR2) - 조회할 공정 코드
   *   P_MACHINE_CODE    (IN, VARCHAR2) - 설비 코드 입력값, 현재 로직에서는 미사용
   *   P_PID             (IN, VARCHAR2) - 제품/작업 식별 입력값, 현재 로직에서는 미사용
   *   P_OUT             (OUT, SYS_REFCURSOR) - 인터락 검사 타입과 검사 순번 조회 결과 커서
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IQ_INTERLOCK_CHECK_CONDITION - 라인/공정별 인터락 검사 조건 관리 테이블
   *     조건: LINE_CODE, WORKSTAGE_CODE 일치 및 NVL(USE_YN, 'Y') = 'Y'
   * ================================================================
   * [AI 분석] 예외 처리:
   *   별도 EXCEPTION 절 없음 - 조회 또는 커서 오픈 중 발생한 오류는 호출부로 전달된다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 없음
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   EXEC P_GET_INTERLOCK_CONDITION_CUR('LINE01', 'WS01', 'MC01', 'PID01', :P_OUT)
   * ================================================================ */
p_line_code        IN VARCHAR2,
                                        p_workstage_code   IN VARCHAR2,
                                        p_machine_code     IN VARCHAR2,
                                        p_pid              IN VARCHAR2, 
                                        p_out              out sys_refcursor )

IS

BEGIN

    -- [AI] 라인/공정 기준으로 사용 가능한 인터락 검사 조건 커서를 생성한다.
    OPEN p_out FOR
          SELECT   interlock_check_type, check_sequence
            FROM   iq_interlock_check_condition
           WHERE   line_code = p_line_code 
             AND workstage_code = p_workstage_code  
             AND NVL (use_yn, 'Y') = 'Y'
        ORDER BY   check_sequence ASC;

END;
