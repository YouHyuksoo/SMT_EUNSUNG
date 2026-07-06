CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_CREATE_CELLBIZ_BARCODE
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
   *   P_MODEL  (IN, varchar2) - 모델 관련 값
   *   P_SUFFIX  (IN, varchar2) - 함수 입력값
   *   P_ITEM  (IN, varchar2) - 품목 관련 값
   *   P_WORKDATE  (IN, date) - 함수 입력값
   *   P_LINE  (IN, varchar2) - 라인 관련 값
   *   P_WORKSTAGE  (IN, varchar2) - 공정 관련 값
   *   P_PACK_UNIT_QTY  (IN, number) - 수량
   * ================================================================
   * [AI 분석] 반환값:
   *   varchar2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   없음 (순수 연산 함수 또는 원본 소스 기준 명시 테이블 없음)
   * ================================================================
   * [AI 분석] 호출 객체:
   *   P_CREATE_CELL_BIZ_BARCODE - 관련 업무 함수 호출
   * ================================================================
   * [AI 분석] 예외 처리:
   *   명시적 EXCEPTION 블록 없음 - 호출부에서 표준 Oracle 예외를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: 없음
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_CREATE_CELLBIZ_BARCODE(...) FROM DUAL;
   * ================================================================ */
 "F_GET_CREATE_CELLBIZ_BARCODE" (p_model varchar2, p_suffix varchar2, p_item varchar2,  p_workdate date, p_line varchar2, p_workstage varchar2 , p_pack_unit_qty number) return varchar2 is
  /* Cell Biz Line 박스포장 바코드 생성 */
  lvs_barcode varchar2(100); 
begin
  
  P_CREATE_CELL_BIZ_BARCODE(p_model, p_suffix, p_item, p_workdate, p_line , p_workstage, p_pack_unit_qty ,  lvs_barcode ); 
  
  return lvs_barcode ;  

end F_GET_CREATE_CELLBIZ_BARCODE;
