CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_MAGAZINE_SERIAL
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
   *   P_LINE_CODE  (IN, VARCHAR2) - 라인 코드
   *   P_MODEL_NAME  (IN, VARCHAR2) - 모델 / 명칭 관련 값
   *   P_ORG  (IN, NUMBER) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   VARCHAR2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_MODEL_MASTER - 제품 / 모델 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회, ELSIF 1회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_MAGAZINE_SERIAL(...) FROM DUAL;
   * ================================================================ */
 "F_GET_MAGAZINE_SERIAL" (p_line_code IN VARCHAR2, p_model_name IN VARCHAR2, p_org IN NUMBER)
    RETURN VARCHAR2
IS
    lvs_return   VARCHAR2 (30);
    lvi_length   NUMBER;
BEGIN
    BEGIN
        SELECT   magazine_no_length
          INTO   lvi_length
          FROM   ip_product_model_master
         WHERE   model_name = p_model_name
           AND   ORGANIZATION_ID = P_ORG ;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            lvi_length := 3;
    END;

    IF lvi_length = 3
    THEN
        lvs_return := TO_CHAR (seq_magazine_serial3.NEXTVAL, '000');
    ELSIF lvi_length = 4 THEN
        lvs_return := TO_CHAR (seq_magazine_serial4.NEXTVAL, '0000');

    ELSE
        lvs_return := TO_CHAR (seq_magazine_serial5.NEXTVAL, '00000');
    END IF;

    RETURN lvs_return;
EXCEPTION
    WHEN OTHERS
    THEN
        RETURN '*';
END;
