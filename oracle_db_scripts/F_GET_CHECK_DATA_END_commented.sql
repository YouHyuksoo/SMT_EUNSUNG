CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_CHECK_DATA_END
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   입력 조건 또는 기준 데이터의 존재/상태를 확인하여 검증 결과를 반환한다.
   *   화면, 설비, 인터락 로직에서 사전 체크용으로 호출되는 함수로 추정된다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_LINE_CODE  (IN, VARCHAR2) - 라인 코드
   *   P_LOT_NAME  (IN, VARCHAR2) - LOT / 명칭 관련 값
   *   P_PARTNAME  (IN, VARCHAR2) - 함수 입력값
   *   P_LOCATION_CODE  (IN, VARCHAR2) - 위치 코드
   *   P_LOT_NO  (IN, VARCHAR2) - LOT 번호
   *   P_CHECK_DATE  (IN, DATE) - 일자 관련 값
   * ================================================================
   * [AI 분석] 반환값:
   *   DATE - 함수 처리 결과값
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
   *   SELECT F_GET_CHECK_DATA_END(...) FROM DUAL;
   * ================================================================ */
 "F_GET_CHECK_DATA_END" (
   p_line_code       IN VARCHAR2,
   p_lot_name        IN VARCHAR2,
   p_partname        IN VARCHAR2,
   p_location_code   IN VARCHAR2,
   p_lot_no          IN VARCHAR2,
   p_check_date      IN DATE)
   RETURN DATE
IS
   lvdt_end_date   DATE;
BEGIN
   ---------------------------------------------------
   --     AND lot_name = p_lot_name
   --     AND partname = p_partname
   ---------------------------------------------------

   SELECT MIN (check_date)
     INTO lvdt_end_date
     FROM ib_smt_checkhist
    WHERE  check_date > p_check_date
          AND location_code = p_location_code
          AND line_code = p_line_code
          AND check_type IN (1, 2)
          AND check_status = 'P';

   ---------------------------------------------------
   --
   ---------------------------------------------------
   RETURN  NVL(lvdt_end_date ,SYSDATE ) ;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      lvdt_end_date := NULL;
END;
