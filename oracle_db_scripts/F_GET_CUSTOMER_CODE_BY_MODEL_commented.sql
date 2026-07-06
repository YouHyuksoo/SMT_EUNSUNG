CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_CUSTOMER_CODE_BY_MODEL
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
   * ================================================================
   * [AI 분석] 반환값:
   *   VARCHAR2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_MODEL_MASTER - 제품 / 모델 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_CUSTOMER_CODE_BY_MODEL(...) FROM DUAL;
   * ================================================================ */
 "F_GET_CUSTOMER_CODE_BY_MODEL" (
   P_MODEL_NAME   IN VARCHAR2
)
   RETURN VARCHAR2
IS
   LVS_CUSTOMER_CODE   VARCHAR2 (100);
/******************************************************************************
   NAME:       F_GET_CUSTOMER_NAME_BY_MODEL
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        2016-10-21          1. Created this function.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     F_GET_CUSTOMER_NAME_BY_MODEL
      Sysdate:         2016-10-21
      Date and Time:   2016-10-21, ？？？？ 3:46:40, and 2016-10-21 ？？？？ 3:46:40
      Username:         (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
BEGIN
  
   LVS_CUSTOMER_CODE := '*';

   SELECT   MAX (CUSTOMER_CODE)
     INTO   LVS_CUSTOMER_CODE
     FROM   IP_PRODUCT_MODEL_MASTER
    WHERE   MODEL_NAME = P_MODEL_NAME;


   RETURN LVS_CUSTOMER_CODE;
   
EXCEPTION
   WHEN NO_DATA_FOUND THEN
        RETURN '*';
   WHEN OTHERS THEN
        RETURN NULL;
END F_GET_CUSTOMER_CODE_BY_MODEL;
