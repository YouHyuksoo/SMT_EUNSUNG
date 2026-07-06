CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_BILL_DISBURSE_DATE
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
   *   P_SUPPLIER_CODE  (IN, VARCHAR2) - 공급사 관련 값
   *   P_DATE  (IN, DATE) - 일자 관련 값
   *   P_ORG  (IN, NUMBER) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   DATE - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ICOM_SUPPLIER - 공급사 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 2회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_BILL_DISBURSE_DATE(...) FROM DUAL;
   * ================================================================ */
 "F_GET_BILL_DISBURSE_DATE" (
   p_supplier_code   IN   VARCHAR2,
   p_date                 DATE,
   p_org             IN   NUMBER
)
   RETURN DATE
IS
   lvs_payment_CONDITION              VARCHAR2(10);
   lvs_payment_cycle             VARCHAR2(10);
   lvdt_return_date              DATE;
BEGIN
   SELECT NVL(payment_condition, '0'),
          NVL(payment_cycle, '1')
   INTO   lvs_payment_CONDITION,
          lvs_payment_cycle
   FROM   icom_supplier
   WHERE  supplier_code = p_supplier_code AND
          organization_id = p_org;


-------------------------------------------------
--
-------------------------------------------------
   SELECT TO_DATE(
             SUBSTR(to_char(ADD_MONTHS(p_date, TO_NUMBER(lvs_payment_CONDITION)),'yyyymmdd'), 1, 4)
             ||  SUBSTR(to_char(ADD_MONTHS(p_date, TO_NUMBER(lvs_payment_CONDITION)),'yyyymmdd'), 5, 2)
             || lvs_payment_cycle, 'yyyymmdd'
          )
   INTO   lvdt_return_date
   FROM   DUAL;
   RETURN lvdt_return_date;

EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN p_date;
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;
