CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_INTERLOCK_PASS_COUNT
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
   *   P_LINE_CODE  (IN, VARCHAR2) - 라인 코드
   *   P_WORKSTAGE_CODE  (IN, VARCHAR2) - 공정 코드
   * ================================================================
   * [AI 분석] 반환값:
   *   NUMBER - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IQ_INTERLOCK_CHECK_RESULT - 인터락 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_INTERLOCK_PASS_COUNT(...) FROM DUAL;
   * ================================================================ */
 "F_GET_INTERLOCK_PASS_COUNT" (
   P_LINE_CODE        IN VARCHAR2,
   P_WORKSTAGE_CODE   IN VARCHAR2)
   RETURN NUMBER
IS
   LVL_RETURN   NUMBER;
BEGIN
   SELECT COUNT (DISTINCT SERIAL_NO)
     INTO LVL_RETURN
     FROM IQ_INTERLOCK_CHECK_RESULT
    WHERE LINE_CODE = P_LINE_CODE AND WORKSTAGE_CODE = P_WORKSTAGE_CODE
          AND RECEIPT_DATE >=
                 CASE
                    WHEN TO_CHAR (SYSDATE, 'HH24MI') >= '0000'
                         AND TO_CHAR (SYSDATE, 'HH24MI') <= '0800'
                    THEN
                       TO_DATE (TO_CHAR (SYSDATE - 1, 'YYYYMMDD') || '0800',
                                'YYYYMMDDHH24MI')
                    ELSE
                       TO_DATE (TO_CHAR (SYSDATE, 'YYYYMMDD') || '0800',
                                'YYYYMMDDHH24MI')
                 END
          AND CHECK_RESULT <> 'NG';


   RETURN LVL_RETURN;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      RETURN 0;
END;
