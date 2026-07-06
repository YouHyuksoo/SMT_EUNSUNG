CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_REEL_CHANGE_COUNT
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   입력 파라미터와 기준 테이블을 이용해 업무 코드, 명칭, 수량, 상태 등의 조회 값을 반환한다.
   *   조회 실패 또는 예외 상황에서는 원본 로직에 정의된 기본값/NULL/오류 처리를 따른다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_LINE  (IN, VARCHAR2) - 라인 관련 값
   *   P_YYYYMMDD  (IN, VARCHAR2) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   NUMBER - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IB_SMT_CHECKHIST - 업무 기준/거래 데이터 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_REEL_CHANGE_COUNT(...) FROM DUAL;
   * ================================================================ */
 F_GET_REEL_CHANGE_COUNT (
                                                    p_line        IN VARCHAR2,
                                                    p_yyyymmdd    IN VARCHAR2
                                                   )
    RETURN NUMBER
IS
    lvl_return          NUMBER;
BEGIN
  
    select count(*)
      into lvl_return
      from ib_smt_checkhist
     where check_date >= to_date( substr(p_yyyymmdd, 1, 10) || ' 08:30:00', 'YYYY/MM/DD HH24:MI:SS')
       and check_date <  to_date( substr(p_yyyymmdd, 1, 10) || ' 08:30:00', 'YYYY/MM/DD HH24:MI:SS') +1
       and line_code    = substr(p_line, 1, 2)
       and check_status = 'P'
       and check_type   = '2';

    RETURN lvl_return;
    
EXCEPTION
    WHEN OTHERS THEN
         RETURN NULL;
END;
