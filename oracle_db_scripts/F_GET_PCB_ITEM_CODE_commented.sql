CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_PCB_ITEM_CODE
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
   *   P_TYPE  (IN, VARCHAR2) - 함수 입력값
   *   P_ITEM  (IN, VARCHAR2) - 품목 관련 값
   * ================================================================
   * [AI 분석] 반환값:
   *   VARCHAR2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_MODEL_MASTER - 제품 / 모델 관련 값 조회 또는 참조
   *   IP_PRODUCT_RUN_CARD - 제품 / 작업지시/런 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회, ELSIF 1회 / 반복문: 0회
   *   DML: SELECT 2회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_PCB_ITEM_CODE(...) FROM DUAL;
   * ================================================================ */
 "F_GET_PCB_ITEM_CODE" (
                                                  P_TYPE        IN VARCHAR2, -- M:model, R:Run Card
                                                  P_ITEM       IN VARCHAR2
                                                  ) RETURN VARCHAR2
IS

    lvs_item                VARCHAR2(50);

BEGIN

--------------------------------------------------------------------------
-- 2016/08/29 SHS, PID？？ Master sample ？？？ ？？？
--------------------------------------------------------------------------

    lvs_item := '';

    -- Model master item ？？
    IF    P_TYPE = 'M' THEN

          BEGIN

            SELECT NVL(PCB_ITEM_CODE,'')
              INTO lvs_item
              FROM IP_PRODUCT_MODEL_MASTER
             WHERE ITEM_CODE       = P_ITEM
               AND ORGANIZATION_ID = 1
               AND ROWNUM          = 1;

          EXCEPTION

             WHEN OTHERS THEN
                  lvs_item := '';
                  RETURN lvs_item;

         END;

    -- Run card ？？
    ELSIF P_TYPE = 'R' THEN

          BEGIN

             SELECT NVL(M.PCB_ITEM_CODE,'')
               INTO lvs_item
               FROM IP_PRODUCT_RUN_CARD     R,
                    IP_PRODUCT_MODEL_MASTER M
              WHERE R.PARENT_ITEM_CODE = M.ITEM_CODE
                AND R.ORGANIZATION_ID  = M.ORGANIZATION_ID
                AND R.RUN_NO           = P_ITEM
                AND ROWNUM             = 1;

          EXCEPTION

             WHEN OTHERS THEN
                  lvs_item := '';
                  RETURN lvs_item;

         END;

    END IF;

    RETURN lvs_item;

EXCEPTION

    WHEN OTHERS THEN
        lvs_item := '';
        RETURN lvs_item;

END;
