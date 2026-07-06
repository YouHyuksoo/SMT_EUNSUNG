CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_LOCATION_COMPARE
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
   *   P_DATA1  (IN, VARCHAR2) - 함수 입력값
   *   P_DATA2  (IN, VARCHAR2) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   VARCHAR2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   없음 (순수 연산 함수 또는 원본 소스 기준 명시 테이블 없음)
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 10회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_LOCATION_COMPARE(...) FROM DUAL;
   * ================================================================ */
 "F_GET_LOCATION_COMPARE" (p_data1 IN VARCHAR2,
                                                p_data2 IN VARCHAR2)
   RETURN VARCHAR2
IS

   lvs_return VARCHAR2(10);

   lvl_cnt1   NUMBER;
   lvl_cnt2   NUMBER;
BEGIN
    SELECT COUNT(*)
      INTO lvl_cnt1
      FROM
     (
        SELECT REGEXP_SUBSTR(STR, '[^,]+', 1, LEVEL) AS DATA
          FROM (
                  SELECT p_data1 STR
                    FROM DUAL
               )
        CONNECT BY LEVEL <= LENGTH(REGEXP_REPLACE(STR, '[^,]+')) + 1
        MINUS
        SELECT REGEXP_SUBSTR(STR, '[^,]+', 1, LEVEL) AS DATA
          FROM (
                  SELECT p_data2 STR
                    FROM DUAL
               )
        CONNECT BY LEVEL <= LENGTH(REGEXP_REPLACE(STR, '[^,]+')) + 1
    );

   SELECT COUNT(*)
     INTO lvl_cnt2
     FROM
     (
        SELECT REGEXP_SUBSTR(STR, '[^,]+', 1, LEVEL) AS DATA
          FROM (
                  SELECT p_data2 STR
                    FROM DUAL
               )
        CONNECT BY LEVEL <= LENGTH(REGEXP_REPLACE(STR, '[^,]+')) + 1
        MINUS
        SELECT REGEXP_SUBSTR(STR, '[^,]+', 1, LEVEL) AS DATA
          FROM (
                  SELECT p_data1 STR
                    FROM DUAL
               )
        CONNECT BY LEVEL <= LENGTH(REGEXP_REPLACE(STR, '[^,]+')) + 1
    );

   IF lvl_cnt1 = 0 AND  lvl_cnt2 = 0
   THEN
      lvs_return := 'OK';
   ELSE
      lvs_return := 'NG';
   END IF;

   RETURN lvs_return ;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN 'NOTFOUND';
   WHEN OTHERS THEN
      raise_application_error (-20003, SQLERRM);
END;
