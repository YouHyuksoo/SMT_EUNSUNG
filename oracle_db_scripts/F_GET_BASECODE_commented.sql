CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_BASECODE
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
   *   P_CODE_TYPE  (IN, varchar2) - 함수 입력값
   *   P_CODE_NAME  (IN, varchar2) - 명칭 관련 값
   *   P_LANG  (IN, varchar2) - 함수 입력값
   *   P_ORG  (IN, number) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   varchar2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ISYS_BASECODE - 기준코드 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_BASECODE(...) FROM DUAL;
   * ================================================================ */
 "F_GET_BASECODE" 
  ( p_code_type IN varchar2,
    p_code_name IN varchar2,
    p_lang IN varchar2,
    p_org IN number)
  RETURN  varchar2 IS

   ls_return   VARCHAR2(100);

BEGIN

    SELECT  DECODE(p_lang, 'C', NVL(CODE_MEAN_LOCAL, ''), 'K', NVL(CODE_MEAN_KOR, ''), CODE_MEAN_ENG)
    INTO    ls_return
    FROM    ISYS_BASECODE
    WHERE   CODE_TYPE       =   UPPER(p_code_type)
    AND     CODE_NAME       =   UPPER(p_code_name)
    AND     ORGANIZATION_ID =   p_org
    ;

    return ls_return;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
        RETURN '';
   WHEN others THEN
       raise_application_error( -20003 , sqlerrm ) ;
END;
