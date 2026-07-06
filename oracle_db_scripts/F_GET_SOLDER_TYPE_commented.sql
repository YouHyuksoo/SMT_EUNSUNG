CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_SOLDER_TYPE
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
   * ================================================================
   * [AI 분석] 반환값:
   *   VARCHAR2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ID_ITEM - 품목 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_SOLDER_TYPE(...) FROM DUAL;
   * ================================================================ */
 "F_GET_SOLDER_TYPE" (p_item_code IN VARCHAR2)
   RETURN VARCHAR2
IS
   lvs_solder_type   VARCHAR2(10);
/******************************************************************************
   NAME:       f_get_solder_type
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        2015-10-13   hsyou_000       1. Created this function.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     f_get_solder_type
      Sysdate:         2015-10-13
      Date and Time:   2015-10-13, ？？？ 5:17:40, and 2015-10-13 ？？？ 5:17:40
      Username:        hsyou_000 (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
BEGIN
   SELECT SOLDER_TYPE
     INTO LVS_SOLDER_TYPE
     FROM ID_ITEM
    WHERE ITEM_CODE = P_ITEM_CODE;

   RETURN LVS_SOLDER_TYPE;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
   WHEN OTHERS
   THEN
      -- Consider logging the error and then re-raise
      RAISE_APPLICATION_ERROR (-20003, SQLERRM);
END f_get_solder_type;
