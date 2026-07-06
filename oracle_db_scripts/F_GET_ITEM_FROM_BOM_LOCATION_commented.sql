CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_ITEM_FROM_BOM_LOCATION
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
   *   P_QC_LOCATION  (IN, VARCHAR2) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   VARCHAR2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ID_ENG_BOM_SMT - BOM 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 5회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_ITEM_FROM_BOM_LOCATION(...) FROM DUAL;
   * ================================================================ */
 "F_GET_ITEM_FROM_BOM_LOCATION" (
                                                          P_MODEL_NAME  IN VARCHAR2,
                                                          P_QC_LOCATION IN VARCHAR2
                                                         )
   RETURN VARCHAR2
IS
   LVS_RETURN   VARCHAR2 (100);
BEGIN

  SELECT WM_CONCAT(ITEM_CODE) -- ？？？ LOCATION？？ ？？ 1 LEVEL BOM？？ITEM LAIST ？？
    INTO LVS_RETURN
    FROM (
          SELECT DISTINCT  (
                            SELECT CHILD_ITEM_CODE
                              FROM ID_ENG_BOM_SMT
                             WHERE PARENT_ITEM_CODE = Q.MODEL_NAME
                               AND ( REGEXP_COUNT(LOCATION_INFO, Q.LOCATION_CODE||'[ ,]') > 0   OR
                                     REGEXP_COUNT(LOCATION_INFO, Q.LOCATION_CODE||'$')    > 0 )
                               AND ROWNUM = 1
                          ) ITEM_CODE
           FROM (
                 SELECT DISTINCT P_MODEL_NAME  MODEL_NAME , UPPER(TRIM(REGEXP_SUBSTR(D.TXT, '[^,^ ]+', 1, LEVEL))) LOCATION_CODE
                   FROM (
                         SELECT P_QC_LOCATION  TXT   -- 1 LEVEL BOM？？？？ ？？？ ？？？ LOCATION ？？？？ ？？？？？ ？？
                           FROM DUAL
                        ) D
                CONNECT BY LEVEL <= LENGTH(REGEXP_REPLACE(D.TXT, '[^,^ ]+',''))+1
                ) Q
          WHERE Q.LOCATION_CODE IS NOT NULL
      );

     RETURN  LVS_RETURN;

EXCEPTION
   WHEN OTHERS THEN
        RETURN '';

END;
