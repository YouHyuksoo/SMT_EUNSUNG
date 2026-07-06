CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_JIG_VALUE_QTY
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
   *   P_LOT_NO  (IN, VARCHAR2) - LOT 번호
   *   P_TYPE  (IN, VARCHAR2) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   NUMBER - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IMCN_JIG - 지그 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   명시적 EXCEPTION 블록 없음 - 호출부에서 표준 Oracle 예외를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_JIG_VALUE_QTY(...) FROM DUAL;
   * ================================================================ */
 F_GET_JIG_VALUE_QTY 
(
  P_LOT_NO IN VARCHAR2 ,
  P_TYPE VARCHAR2 
) RETURN NUMBER AS 

LVL_HIT_VALUE NUMBER ;
LVL_BREAK_VALUE NUMBER ;
BEGIN

   SELECT NVL(HIT_VALUE,0) , NVL(BREAK_VALUE,0)
     INTO LVL_HIT_VALUE , LVL_BREAK_VALUE 
      FROM IMCN_JIG 
      WHERE jig_lot_no = P_LOT_NO ;
      
      
      IF P_TYPE = 'BREAK' THEN 
        RETURN LVL_BREAK_VALUE ;
      ELSE
          RETURN LVL_HIT_VALUE ;
      END IF  ;


END F_GET_JIG_VALUE_QTY;
