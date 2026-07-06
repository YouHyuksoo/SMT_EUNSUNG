CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_MAT_ISSUE_QTY_4_DISUSED
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
   *   P_MFS  (IN, VARCHAR2) - 제조/공급 구분
   *   P_ITEM_CODE  (IN, varchar2) - 품목 코드
   *   P_LINE_TYPE  (IN, varchar2) - 라인 관련 값
   *   P_MONTH_TERM  (IN, number) - 함수 입력값
   *   P_ORG  (IN, number) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   number - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IM_ITEM_RECEIPT - 품목 관련 값 조회 또는 참조
   *   IM_ITEM_ISSUE - 품목 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 2회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_MAT_ISSUE_QTY_4_DISUSED(...) FROM DUAL;
   * ================================================================ */
 "F_GET_MAT_ISSUE_QTY_4_DISUSED" 
  ( p_mfs in VARCHAR2 ,
    p_item_code IN varchar2 ,p_line_type IN varchar2 ,
    p_month_term in number ,
    p_org IN number)
  RETURN  number IS

-- ---------   ------  -------------------------------------------
   lvf_issue_qty number ;
   lvf_count number ;

BEGIN

   select count(*)
   into lvf_count
   from im_item_receipt
   where receipt_date <= trunc(sysdate) - p_month_term
      and item_code = p_item_code
      and line_type = p_line_type
      and organization_id = p_org ;

  if lvf_count = 0 then
   return -1;
  else
    select nvl(sum(issue_qty),0)
    into lvf_issue_qty
    from im_item_issue
    where item_code = p_item_code
      and line_type = p_line_type
      and issue_date >= trunc(sysdate) - p_month_term
      and issue_account in ( 'M001' , 'M002' )
      and issue_status = 'N'
      and organization_id = p_org ;

     RETURN nvl(lvf_issue_qty,0) ;
   end if;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
        RETURN 0 ;
   WHEN others THEN
       raise_application_error( -20003 , sqlerrm ) ;
END;
