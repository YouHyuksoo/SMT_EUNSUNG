CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_ECO_CHECK
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
   *   P_MODEL_NAME  (IN, VARCHAR2) - 모델 / 명칭 관련 값
   * ================================================================
   * [AI 분석] 반환값:
   *   NUMBER - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IB_PRODUCT_PLANDATA - 제품 관련 값 조회 또는 참조
   *   ID_ITEM - 품목 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 2회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_ECO_CHECK(...) FROM DUAL;
   * ================================================================ */
 "F_GET_ECO_CHECK" (p_line_code IN VARCHAR2, p_model_name IN VARCHAR2)
/* Formatted on 2015-05-09 10:25:02 (QP5 v5.126) */
    RETURN NUMBER
IS
    lvs_return   VARCHAR2 (10);
    lvi_count    NUMBER;
BEGIN
    SELECT   COUNT ( * )
      INTO   lvi_count
      FROM   ib_product_plandata
     WHERE   line_code = p_line_code
         AND model_name = p_model_name
         AND item_code IN (SELECT   item_code
                             FROM   id_item
                            WHERE   eco_check_yn = 'Y')
         AND active_yn = 'Y';


    IF lvi_count > 0
    THEN
        RETURN lvi_count;
    ELSE
        RETURN 0;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN 0;
    WHEN OTHERS
    THEN
        raise_application_error (-20003, SQLERRM);
END;
