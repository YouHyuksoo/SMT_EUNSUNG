CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_2D_BARCODE_EXPLOSION
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   바코드/시리얼 문자열에서 업무 식별값을 추출하거나 라벨 출력용 값을 생성한다.
   *   입력값 포맷과 기준 정보는 원본 조건문 및 조회 조건을 따른다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_ITEM_BARCODE  (IN, VARCHAR2) - 바코드
   *   P_ORG  (IN, NUMBER) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   VARCHAR2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IM_ITEM_REQUEST - 품목 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_2D_BARCODE_EXPLOSION(...) FROM DUAL;
   * ================================================================ */
 "F_2D_BARCODE_EXPLOSION" (p_item_barcode IN VARCHAR2, p_org IN NUMBER)
/* Formatted on 2015-06-18 18:16:47 (QP5 v5.126) */
    RETURN VARCHAR2
IS

LVS_RETURN VARCHAR2(50) ;
BEGIN
        SELECT   REGEXP_SUBSTR (item_barcode,
                                '[^' || CHR (29) || ']+',
                                1,
                                LEVEL)
                     txt
                     into LVS_RETURN
          FROM   im_item_request
         WHERE   item_barcode = p_item_barcode
    CONNECT BY   LEVEL <= LENGTH (REGEXP_REPLACE (item_barcode, '[^' || CHR (29) || ']+', '')) + 1;

    RETURN LVS_RETURN;
EXCEPTION
    WHEN OTHERS
    THEN
        RETURN NULL;
END;
