CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_MAT_WS_ISSUE_QTY
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
   *   P_WORKSTAGE_CODE  (IN, VARCHAR2) - 공정 코드
   *   P_MFS  (IN, VARCHAR2) - 제조/공급 구분
   *   P_ITEM_CODE  (IN, VARCHAR2) - 품목 코드
   *   P_ORG  (IN, NUMBER) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   NUMBER - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IM_ITEM_WORKSTAGE_ISSUE - 품목 / 공정 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_MAT_WS_ISSUE_QTY(...) FROM DUAL;
   * ================================================================ */
 "F_GET_MAT_WS_ISSUE_QTY" 
  ( P_WORKSTAGE_code IN VARCHAR2 , P_MFS in VARCHAR2 , P_ITEM_CODE IN VARCHAR2 ,
    P_ORG IN NUMBER)
  RETURN  NUMBER IS


   lvf_issue_qty                number;

BEGIN
    select sum(issue_qty)
      into lvf_issue_qty
      from im_item_workstage_issue
     where workstage_code = P_WORKSTAGE_code
       and mfs = p_mfs
       and item_code = p_item_code
       and organization_id = p_org ;



    RETURN lvf_issue_qty ;
EXCEPTION
when no_data_found then
return 0 ;

   WHEN others THEN
       raise_application_error( -20003 , sqlerrm ) ;
END;
