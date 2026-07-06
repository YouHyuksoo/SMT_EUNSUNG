CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_OQC_INSPECT_HANDLING
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
   *   P_OQC_INSPECT_NO  (IN, varchar2) - 검사 관련 값
   *   P_ORG  (IN, number) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   varchar2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IQ_PRODUCT_OQC_BAD - 제품 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_OQC_INSPECT_HANDLING(...) FROM DUAL;
   * ================================================================ */
 "F_GET_OQC_INSPECT_HANDLING" 
  ( P_OQC_INSPECT_NO IN varchar2 ,
    p_org in number)
  RETURN  varchar2 IS

LVS_OQC_INSPECT_HANDLING varchar2(1) ;

BEGIN

        select NVL(OQC_INSPECT_HANDLING,'N')
        into LVS_OQC_INSPECT_HANDLING
        from IQ_PRODUCT_OQC_BAD
        where OQC_INSPECT_NO = P_OQC_INSPECT_NO
        AND OQC_INSPECT_HANDLING = 'D'
        and organization_id = p_org
        and rownum = 1 ;

     return LVS_OQC_INSPECT_HANDLING ;

EXCEPTION

   when no_data_found then
     return 'N' ;

   WHEN others THEN

       raise_application_error( -20003 ,P_OQC_INSPECT_NO||' '||sqlerrm ) ;

END;
