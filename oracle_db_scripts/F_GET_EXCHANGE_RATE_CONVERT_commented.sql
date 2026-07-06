CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_EXCHANGE_RATE_CONVERT
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
   *   P_BASIS_CURRENCY  (IN, varchar2) - 함수 입력값
   *   P_CURRENCY  (IN, varchar2) - 함수 입력값
   *   P_TYPE  (IN, varchar2) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   number - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ICOM_EXCHANGE_RATE - 율 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 2회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_EXCHANGE_RATE_CONVERT(...) FROM DUAL;
   * ================================================================ */
 "F_GET_EXCHANGE_RATE_CONVERT" 
  ( p_basis_currency IN varchar2 , p_currency In varchar2 , p_type In varchar2 )
  RETURN  number IS

-- ---------   ------  -------------------------------------------
   lvf_exchange_rate                 number;

BEGIN

    RETURN 1 ;
    
    if p_type = 'F' then --first exchange rate


    select exchange_rate into lvf_exchange_rate
      from icom_exchange_rate
     where basis_currency = p_basis_currency
       and currency = p_currency
       and dateset  = to_date( to_char(sysdate , 'yyyymm')||'01','yyyymmdd') ;


    else


    select exchange_rate into lvf_exchange_rate
      from icom_exchange_rate
     where basis_currency = p_basis_currency
       and currency = p_currency
       and dateset  = trunc(sysdate) ;


    end if ;

    RETURN lvf_exchange_rate ;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
        return 0 ;

   WHEN others THEN
       raise_application_error( -20003 , sqlerrm ) ;
END;
