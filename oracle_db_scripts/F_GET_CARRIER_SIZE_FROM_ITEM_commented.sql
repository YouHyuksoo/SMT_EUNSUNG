CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_CARRIER_SIZE_FROM_ITEM
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
   *   P_MODEL_NAME  (IN, VARCHAR2) - 모델 / 명칭 관련 값
   *   P_ORG  (IN, NUMBER) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   NUMBER - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ID_ITEM - 품목 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_CARRIER_SIZE_FROM_ITEM(...) FROM DUAL;
   * ================================================================ */
 "F_GET_CARRIER_SIZE_FROM_ITEM" (p_model_name IN VARCHAR2, p_org IN NUMBER)
/* Formatted on 2015-08-04 21:59:22 (QP5 v5.126) */
    RETURN NUMBER
IS
    lvl_return   NUMBER;
BEGIN
    SELECT   MAX (carrier_size)
      INTO   lvl_return
      FROM   id_item
     WHERE   model_name = p_model_name AND organization_id = p_org;


    IF NVL(lvl_return,0) = 0
    THEN
        RETURN 2;
    ELSE
        RETURN lvl_return;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN 2;
    WHEN OTHERS
    THEN
        raise_application_error (-20003, SQLERRM);
END;
