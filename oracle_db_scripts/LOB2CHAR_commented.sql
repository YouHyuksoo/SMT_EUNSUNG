CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : LOB2CHAR
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   원본 함수 로직을 기준으로 업무 값을 계산, 조회 또는 변환하여 반환한다.
   *   반환 타입은 VARCHAR2이며 호출 위치에서 후속 판단/표시에 사용된다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   CLOB_COL  (IN, CLOB) - 함수 입력값
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
   *   조건 분기: IF 2회 / 반복문: 2회
   *   DML: 없음
   * ================================================================
   * 사용 예시:
   *   SELECT LOB2CHAR(...) FROM DUAL;
   * ================================================================ */
 "LOB2CHAR" (clob_col CLOB)
   RETURN VARCHAR2
IS
   buffer   VARCHAR2 (4000);
   amt      BINARY_INTEGER  := 4000;
   pos      INTEGER         := 1;
   l        CLOB;
   bfils    BFILE;
   l_var    VARCHAR2 (4000) := '';
BEGIN
   LOOP
      IF DBMS_LOB.getlength (clob_col) <= 4000
      THEN
         BEGIN
            NULL;
            EXIT;
--            DBMS_LOB.READ (clob_col, amt, pos, buffer);
         EXCEPTION
            WHEN OTHERS
            THEN
               raise_application_error (-20003, SQLERRM);
         END;

         l_var := l_var || buffer;
         pos := pos + amt;
      ELSE
         l_var :=
               DBMS_LOB.getlength (clob_col)
            || ' '
            || 'Cannot convert.  Exceeded varchar2 limit';
         EXIT;
      END IF;
   END LOOP;

   RETURN l_var;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN l_var;
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;
