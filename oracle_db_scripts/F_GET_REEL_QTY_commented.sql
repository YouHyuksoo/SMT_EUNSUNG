CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_REEL_QTY
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
   *   P_ITEM_CODE  (IN, VARCHAR2) - 품목 코드
   *   P_TYPE  (IN, NUMBER) - 함수 입력값
   *   P_QTY  (IN, NUMBER) - 수량
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
   *   조건 분기: IF 10회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_REEL_QTY(...) FROM DUAL;
   * ================================================================ */
 "F_GET_REEL_QTY" (p_item_code   IN VARCHAR2,
/* Formatted on 29-11-2014 15:50:56 (QP5 v5.126) */
                         p_type        IN NUMBER,
                         p_qty         IN NUMBER,
                         p_org         IN NUMBER)
    RETURN NUMBER
IS
    lvl_return          NUMBER;
    lvl_material_qty    NUMBER;
    lvl_material_qty2   NUMBER;
BEGIN
    SELECT   NVL (material_qty, 0), NVL (material_qty2, 0)
      INTO   lvl_material_qty, lvl_material_qty2
      FROM   id_item
     WHERE   item_code = p_item_code AND organization_id = p_org;


    IF p_type = 1
    THEN
        IF lvl_material_qty = 0
        THEN
            RETURN 0;
        END IF;

        lvl_return := TRUNC (p_qty / lvl_material_qty, 0);

        IF MOD (p_qty, lvl_material_qty) > 0
        THEN
            lvl_return := lvl_return + 1;
        END IF;
    ELSE
        IF lvl_material_qty2 = 0
        THEN
            RETURN 0;
        END IF;

        lvl_return := TRUNC (p_qty / lvl_material_qty2, 0);

        IF MOD (p_qty, lvl_material_qty2) > 0
        THEN
            lvl_return := lvl_return + 1;
        END IF;
    END IF;

    RETURN lvl_return;
EXCEPTION
    WHEN OTHERS
    THEN
        RETURN 0;
END;
