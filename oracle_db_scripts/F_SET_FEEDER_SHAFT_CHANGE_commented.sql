CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_SET_FEEDER_SHAFT_CHANGE
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   입력값을 기준으로 번호, 문자열 또는 업무 데이터를 생성/변환하여 반환한다.
   *   필요 시 내부 테이블 조회와 계산 결과를 조합한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_LINE_CODE  (IN, VARCHAR2) - 라인 코드
   *   P_S_SHAFT  (IN, VARCHAR2) - 함수 입력값
   *   P_D_SHAFT  (IN, VARCHAR2) - 함수 입력값
   *   P_LOCATION_CODE  (IN, VARCHAR2) - 위치 코드
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
   *   조건 분기: IF 4회, ELSIF 1회 / 반복문: 0회
   *   DML: 없음
   * ================================================================
   * 사용 예시:
   *   SELECT F_SET_FEEDER_SHAFT_CHANGE(...) FROM DUAL;
   * ================================================================ */
 "F_SET_FEEDER_SHAFT_CHANGE" (
   P_LINE_CODE       IN VARCHAR2,
   P_S_SHAFT         IN VARCHAR2,
   P_D_SHAFT         IN VARCHAR2,
   P_LOCATION_CODE   IN VARCHAR2)
   RETURN VARCHAR2
IS
   LVS_RETURN   VARCHAR2(30);
   LVS_TABLE    VARCHAR2 (10);
   LVS_TRIM1    VARCHAR2 (10);
   LVS_TRIM2    VARCHAR2 (10);
   LVS_TRIM3    VARCHAR2 (10);
   PHASE        VARCHAR2 (10);
BEGIN
   PHASE := '10';
   LVS_TABLE :=
      SUBSTR (P_LOCATION_CODE, 1, INSTR (P_LOCATION_CODE, 'T', 1) - 1);

   IF p_d_shaft IN ('A', 'C', 'E')
   THEN
      LVS_RETURN := p_location_code;
   ELSE
      PHASE := '20';

      -- ？？？？？+ 10

      IF LVS_TABLE IN ('1', '3', '5', '7', '9', '11')
      THEN
         LVS_TRIM1 :=
            SUBSTR (p_location_code, 1, INSTR (p_location_code, 'T', 1));
         PHASE := '30';
         LVS_TRIM2 :=
            TO_CHAR (
               TO_NUMBER (
                  TRIM (
                     SUBSTR (p_location_code,
                             INSTR (p_location_code, 'T', 1) + 1,
                             2)))
               + 10,
               '00');
         PHASE := '40';
         LVS_TRIM3 :=
            SUBSTR (p_location_code, INSTR (p_location_code, 'T', 1) + 3, 1);
         PHASE := '50';
          LVS_RETURN := TRIM(LVS_TRIM1) || TRIM(LVS_TRIM2) || TRIM(LVS_TRIM3);
      ELSIF LVS_TABLE IN ('2', '4', '6', '8', '10', '12') THEN
         PHASE := '60';
         LVS_TRIM1 :=
            SUBSTR (p_location_code, 1, INSTR (p_location_code, 'T', 1));
         PHASE := '70';
         LVS_TRIM2 :=
            TO_CHAR (
               TO_NUMBER (
                  TRIM (
                     SUBSTR (p_location_code,
                             INSTR (p_location_code, 'T', 1) + 1,
                             2)))
               - 10,
               '00');
         PHASE := '80';
         LVS_TRIM3 :=
            SUBSTR (p_location_code, INSTR (p_location_code, 'T', 1) + 3, 1);
         PHASE := '90';
          LVS_RETURN := TRIM(LVS_TRIM1) || TRIM(LVS_TRIM2) || TRIM(LVS_TRIM3);
      ELSE

           LVS_RETURN := p_location_code;

      END IF;


      PHASE := '110';
   END IF;


   PHASE := '120';
   RETURN LVS_RETURN;
   PHASE := '130';
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN p_location_code;
   WHEN OTHERS
   THEN
      RAISE_application_error (
         -20003,
            'PHASE='
         || PHASE
         || ' '
         || 'TABLE='
         || LVS_TABLE
         || ' T1='
         || LVS_TRIM1
         || ' T2='
         || LVS_TRIM2
         || ' T3='
         || LVS_TRIM3
         || ' LOC='
         || p_location_code
         || ' '
         || SQLERRM);
END;
