CREATE OR REPLACE PROCEDURE "P_CREATE_CELL_BIZ_BARCODE" (p_model varchar2, p_suffix varchar2, p_item varchar2,  p_date date, p_line varchar2, p_workstage varchar2, p_pack_unit_qty number ,  p_out out varchar2) is
  /* ================================================================
   * 프로시저명  : P_CREATE_CELL_BIZ_BARCODE
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   업무 기준 데이터를 생성하고 대상 테이블에 등록한다.
   *   시퀀스, 현재일자, 입력 파라미터 등 원본 생성 규칙을 그대로 사용한다.
   *   정상 처리 또는 오류 결과는 원본 OUT 파라미터/예외 처리 흐름을 따른다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_MODEL - 원본 선언부 기준 입력/출력 파라미터
   *   P_SUFFIX - 원본 선언부 기준 입력/출력 파라미터
   *   P_ITEM - 원본 선언부 기준 입력/출력 파라미터
   *   P_DATE - 원본 선언부 기준 입력/출력 파라미터
   *   P_LINE - 원본 선언부 기준 입력/출력 파라미터
   *   P_WORKSTAGE - 원본 선언부 기준 입력/출력 파라미터
   *   P_PACK_UNIT_QTY - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   *   PRAGMA - 원본 선언부 기준 입력/출력 파라미터
   *   P_MODEL - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_MODEL_MASTER - 원본 로직 참조 테이블
   *   IP_PRODUCT_PACK_MASTER - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   PUT_LINE
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_CREATE_CELL_BIZ_BARCODE(...)
   * ================================================================ */

  Pragma autonomous_transaction ; 

  lvs_seq varchar2(7) ; -- [AI] 내부 처리용 변수
  lvs_date varchar2(8); -- [AI] 내부 처리용 변수
  lvs_pack_barcode varchar2(100) ; -- [AI] 내부 처리용 변수
  lvs_company_no varchar2(10) ; -- [AI] 내부 처리용 변수
  lvs_marking_condition varchar2(1) ; -- [AI] 내부 처리용 변수

begin
   -- [AI] 주요 업무 처리 로직을 시작한다.
    lvs_seq := to_char( SEQ_BOX4_SEQUENCE.NEXTVAL,'FM0000') ; 
    lvs_date     := to_char( p_date,'YYYYMMDD') ; 
    
------------------------------------------------------------------
--
------------------------------------------------------------------
    select company_no , marking_condition
      into lvs_company_no , lvs_marking_condition
      from ip_product_model_master 
    where model_name = p_model  ; 
 
 
 if nvl(lvs_marking_condition , 'N') = 'Y' then 

    lvs_pack_barcode := lvs_date||p_item||TRIM(TO_CHAR(p_pack_unit_qty,'0000000'))||lvs_seq ;
else
    lvs_pack_barcode := p_item||'/'||lvs_date||lvs_seq||'/'||p_pack_unit_qty||'/'||lvs_company_no||'//'||p_item||'/'||'120'||'/'||lvs_date||lvs_seq||'/////'   ;
end if  ;

    insert into ip_product_pack_master ( 
      pack_barcode, 
      pack_type, -- 'C' Cell Biz 
      model_name, 
      MODEL_SUFFIX,
      part_no, 
      pack_date, 
      packing_pcs_qty, 
      pack_qty, 
      
      line_code, 
      workstage_code, 
      
      attr1, 
      attr2, 
      attr3, 
      attr4, 
      attr5, 
      
      complete_flag, 
      print_flag, 
      reprint, 
          
      organization_id, 
      enter_date, 
      enter_by, 
      last_modify_date, 
      last_modify_by

    ) values ( 
      --p_model||lvs_supplier||lvs_date||lvs_seq, 
      lvs_pack_barcode, 
      'C',
      --'6871L-'||p_model,
      p_model, 
      p_suffix, 
      p_item,                             --'*', 
      p_date,
      p_pack_unit_qty, 
      0, 
      
      p_line, 
      p_workstage, 
      
      '', 
      '', 
      lvs_date,
      '',  
      'EUNSUNG',
      'N',
      'N',
      0, 
      1, 
      sysdate, 
      'PRC',
      sysdate,
      'PRC'
          
    ) ; 
    
    commit ; 
    
    p_out := lvs_pack_barcode ;
    
exception 
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
  when others then 
    rollback ;
    DBMS_OUTPUT.put_line(SQLERRM);
    p_out := 'ERROR' ; 
end P_CREATE_CELL_BIZ_BARCODE;
