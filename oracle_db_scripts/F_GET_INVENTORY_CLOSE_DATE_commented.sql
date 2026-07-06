CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_INVENTORY_CLOSE_DATE
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
   *   P_CLOSE_YYYYMM  (IN, VARCHAR2) - 함수 입력값
   *   P_START_END_DIV  (IN, VARCHAR2) - 함수 입력값
   *   P_ORG  (IN, NUMBER) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   DATE - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ISYS_INVENTORY_CLOSE_DATE - 재고 / 일자 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 6회, ELSIF 3회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_INVENTORY_CLOSE_DATE(...) FROM DUAL;
   * ================================================================ */
 "F_GET_INVENTORY_CLOSE_DATE" (
   p_close_yyyymm    IN VARCHAR2,
   p_start_end_div   IN VARCHAR2,
   p_org             IN NUMBER)
   RETURN DATE
IS
   lvdt_close_start_date   DATE;
   lvdt_close_end_date     DATE;
   lvdt_close_last_date    DATE;
BEGIN
   -------------------------------------------------------
   --
   -----------------------------------------------------

   SELECT start_date, end_date, last_close_date
     INTO lvdt_close_start_date, lvdt_close_end_date, lvdt_close_last_date
     FROM isys_inventory_close_date
    WHERE close_yyyymm = p_close_yyyymm AND organization_id = p_org;

   IF p_start_end_div = 'START'
   THEN
      RETURN lvdt_close_start_date;
   ELSIF p_start_end_div = 'END'
   THEN
      RETURN lvdt_close_end_date;
   ELSE
      IF lvdt_close_last_date IS NULL
      THEN
         RETURN TO_DATE (
                   TO_CHAR (lvdt_close_end_date, 'yyyymmdd') || '235959',
                   'yyyymmdd hh24:mi:ss');
      ELSE
         RETURN lvdt_close_last_date;
      END IF;
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      IF p_start_end_div = 'START'
      THEN
         RETURN TO_DATE (p_close_yyyymm || '01', 'YYYYMMDD');
      ELSIF p_start_end_div = 'END'
      THEN
         RETURN ADD_MONTHS (TO_DATE (p_close_yyyymm || '01235959', 'YYYYMMDDhh24miss'), 1)
                - 1;
      ELSIF p_start_end_div = 'LAST'
      THEN
         RETURN ADD_MONTHS (TO_DATE (p_close_yyyymm || '01235959', 'YYYYMMDDhh24miss'), 1)
                - 1;
      END IF;
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;
