CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_ALPHABET_NUMBER
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
   *   P_PARAM  (IN, VARCHAR2) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   VARCHAR2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   없음 (순수 연산 함수 또는 원본 소스 기준 명시 테이블 없음)
   * ================================================================
   * [AI 분석] 예외 처리:
   *   명시적 EXCEPTION 블록 없음 - 호출부에서 표준 Oracle 예외를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회, ELSIF 25회 / 반복문: 0회
   *   DML: 없음
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_ALPHABET_NUMBER(...) FROM DUAL;
   * ================================================================ */
 "F_GET_ALPHABET_NUMBER" 
(
  P_PARAM IN VARCHAR2 
) RETURN VARCHAR2 AS 
BEGIN

IF P_PARAM = 'A' THEN 
RETURN  '1' ;
ELSIF P_PARAM = 'B' THEN 
RETURN  '2' ;
ELSIF P_PARAM = 'C' THEN 
RETURN  '3' ;
ELSIF P_PARAM = 'D' THEN 
RETURN  '4' ;
ELSIF P_PARAM = 'E' THEN 
RETURN  '5' ;
ELSIF P_PARAM = 'F' THEN 
RETURN  '6' ;
ELSIF P_PARAM = 'G' THEN 
RETURN  '7' ;
ELSIF P_PARAM = 'H' THEN 
RETURN  '8' ;
ELSIF P_PARAM = 'I' THEN 
RETURN  '9' ;
ELSIF P_PARAM = 'J' THEN 
RETURN  '10' ;
ELSIF P_PARAM = 'K' THEN 
RETURN  '11' ;
ELSIF P_PARAM = 'L' THEN 
RETURN  '12' ;
ELSIF P_PARAM = 'M' THEN 
RETURN  '13' ;
ELSIF P_PARAM = 'N' THEN 
RETURN  '14' ;
ELSIF P_PARAM = 'O' THEN 
RETURN  '15' ;
ELSIF P_PARAM = 'P' THEN 
RETURN  '16' ;
ELSIF P_PARAM = 'Q' THEN 
RETURN  '17' ;
ELSIF P_PARAM = 'R' THEN 
RETURN  '18' ;
ELSIF P_PARAM = 'S' THEN 
RETURN  '19' ;
ELSIF P_PARAM = 'T' THEN 
RETURN  '20' ;
ELSIF P_PARAM = 'U' THEN 
RETURN  '21' ;
ELSIF P_PARAM = 'V' THEN 
RETURN  '22' ;
ELSIF P_PARAM = 'W' THEN 
RETURN  '23' ;
ELSIF P_PARAM = 'X' THEN 
RETURN  '24' ;
ELSIF P_PARAM = 'Y' THEN 
RETURN  '25' ;
ELSIF P_PARAM = 'Z' THEN 
RETURN  '26' ;
ELSE 
RETURN P_PARAM ;
END IF ;

       

END F_GET_ALPHABET_NUMBER;
