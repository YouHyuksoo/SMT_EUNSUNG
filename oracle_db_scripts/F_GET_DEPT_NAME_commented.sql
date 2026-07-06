CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_DEPT_NAME
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
   *   P_DEPT_CODE  (IN, varchar2) - 함수 입력값
   *   P_LANGUAGE  (IN, varchar2) - 함수 입력값
   *   P_ORG  (IN, number) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   varchar2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ISYS_DEPARTMENT - 업무 기준/거래 데이터 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_DEPT_NAME(...) FROM DUAL;
   * ================================================================ */
 "F_GET_DEPT_NAME" 
  ( p_dept_code IN varchar2,p_language IN varchar2 , p_org In number )
  RETURN  varchar2 IS
--
-- To modify this template, edit file FUNC.TXT in TEMPLATE
-- directory of SQL Navigator
--
-- Purpose: Briefly explain the functionality of the function
--
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- ---------   ------  -------------------------------------------

lvs_dept_name varchar2(30);

BEGIN

    SELECT DECODE(p_language , 'C' , department_name_local,'K' , department_name_kor , 'E' , department_name_eng )
      INTO lvs_dept_name
      FROM ISYS_DEPARTMENT
     WHERE DEPARTMENT_CODE = p_dept_code
       AND ORGANIZATION_ID = p_org ;

    RETURN lvs_dept_name ;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
       return p_dept_code ;
   WHEN others THEN
       raise_application_error( -20003 , sqlerrm ) ;
END;
