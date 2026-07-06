CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_WORKSTAGE_TYPE
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
   *   P_WORKSTAGE  (IN, VARCHAR2) - 공정 관련 값
   * ================================================================
   * [AI 분석] 반환값:
   *   VARCHAR2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_WORKSTAGE - 제품 / 공정 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_WORKSTAGE_TYPE(...) FROM DUAL;
   * ================================================================ */
 "F_GET_WORKSTAGE_TYPE" (p_workstage IN VARCHAR2)
/* Formatted on 2013-01-21 ??? 1:38:55 (QP5 v5.126) */
    RETURN VARCHAR2
IS
    lvs_return   VARCHAR2 (30);
BEGIN
    SELECT   workstage_type
      INTO   lvs_return
      FROM   ip_product_workstage
     WHERE   workstage_code = p_workstage;

    IF lvs_return IS NULL
    THEN
        RETURN p_workstage;
    ELSE
        RETURN lvs_return;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN '';
    WHEN OTHERS
    THEN
        raise_application_error (-20003, SQLERRM);
END;
