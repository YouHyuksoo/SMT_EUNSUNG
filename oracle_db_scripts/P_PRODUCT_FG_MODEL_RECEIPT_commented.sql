CREATE OR REPLACE PROCEDURE "P_PRODUCT_FG_MODEL_RECEIPT" (p_barcode varchar2, p_qty varchar2, p_location varchar2,  p_txn number,  p_commit varchar2, p_out out varchar2, p_msg out varchar2) is
  /* ================================================================
   * 프로시저명  : P_PRODUCT_FG_MODEL_RECEIPT
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   제품 또는 재고 관련 업무 데이터를 등록/갱신한다.
   *   대상 재고와 실적 데이터의 존재 여부를 확인한 뒤 원본 로직에 따라 처리한다.
   *   COMMIT/ROLLBACK 포함 여부는 원본 트랜잭션 흐름을 그대로 유지한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_BARCODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_QTY - 원본 선언부 기준 입력/출력 파라미터
   *   P_LOCATION - 원본 선언부 기준 입력/출력 파라미터
   *   P_TXN - 원본 선언부 기준 입력/출력 파라미터
   *   P_COMMIT - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   *   P_MSG - 원본 선언부 기준 입력/출력 파라미터
   *   PACKING - 원본 선언부 기준 입력/출력 파라미터
   *   PDA - 원본 선언부 기준 입력/출력 파라미터
   *   P_LOCATOIN - 원본 선언부 기준 입력/출력 파라미터
   *   PRODUCT - 원본 선언부 기준 입력/출력 파라미터
   *   P_COMMIT - 원본 선언부 기준 입력/출력 파라미터
   *   P_TXN - 원본 선언부 기준 입력/출력 파라미터
   *   P_QTY - 원본 선언부 기준 입력/출력 파라미터
   *   P_BARCODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   *   P_MSG - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   *   P_MSG - 원본 선언부 기준 입력/출력 파라미터
   *   PACK - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_FG_RECEIPT - 원본 로직 참조 테이블
   *   IP_PRODUCT_MODEL_MASTER - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_WORKTIME_ZONE
   *   F_GET_WORK_ACTUAL_DATE
   *   F_GET_WORK_SHIFT_CODE
   *   F_MSG
   *   P_LOCATOIN
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_PRODUCT_FG_MODEL_RECEIPT(...)
   * ================================================================ */
   /****************************************************
    * 제품 입고
    * 1. Packing 된 제품을 창고로 입고 한다.
    *    PDA / UI 동시 사용 가능
    *    p_locatoin ( isys basecode PRODUCT LOCATION CODE )
    *    p_commit 'Y" procedure 내에서 Txn 종료
    *             'N' 호출 UI 에서 Txn 종료 처리
    *    p_txn  1 정상 , 2 취소
    ****************************************************
    * IP_PRODUCT_PACK_MASTER RECEIPT_FLAG = 'N' 인것
    ****************************************************/
    lvs_receipt_flag varchar2(1); -- [AI] 내부 처리용 변수
    lvs_pallet_flag  varchar2(1); -- [AI] 내부 처리용 변수
    lvs_ship_flag    varchar2(1); -- [AI] 내부 처리용 변수
    lvs_pack_type    varchar2(2); -- [AI] 내부 처리용 변수
    lvl_pack_qty     number     ; -- [AI] 내부 처리용 변수
    lvs_model_name   varchar2(50); -- [AI] 내부 처리용 변수
    lvs_item_code    varchar2(50); -- [AI] 내부 처리용 변수
    
begin
   -- [AI] 주요 업무 처리 로직을 시작한다.
    /******************************
    * 바코드 확인
    ******************************/
    begin
      
      select model_name, item_code, to_number( p_qty ), 'G'
        into lvs_model_name, lvs_item_code, lvl_pack_qty, lvs_pack_type
        from ip_product_model_master
       where model_name = p_barcode 
         and rownum     = 1;
       
    exception
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      when no_data_found then
        p_out := 'NG' ;
        p_msg := f_msg('존재하지 않는 모델 입니다.','C',1);
        return ;
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      when others then
        p_out := 'NG';
        p_msg := substr(sqlerrm,1,200);
        return ;
    end ;

    /******************************
    * Pack 수량 없는건은 입고 안됨
    ******************************/
    if lvl_pack_qty < 1 then
        p_out := 'NG' ;
        p_msg := f_msg('Packing 수량을 확인하세요.','C',1);
        return ;
    end if ;

    -- 처리
          insert into ip_product_fg_receipt (
                                             receipt_date,
                                             receipt_sequence,
                                             barcode,
                                             pack_type,
                                             txn_deficit,
                                             qty,

                                             model_name,
                                             model_suffix,

                                             item_code,

                                             line_code,
                                             workstage_code,

                                             location_code,
                                             enter_by,
                                             enter_date,
                                             last_modify_by,
                                             last_modify_date,
                                             organization_id ,
                                             actual_date,
                                             work_time_zone,
                                             shift_code

          )
          select sysdate,
                 seq_fg_receipt_seq.nextval,
                 p_barcode,
                 lvs_pack_type,
                 p_txn,
                 lvl_pack_qty,

                 lvs_model_name,
                 '*',
                 lvs_item_code,

                 '*',
                 '*',

                 p_location,
                 'FG_RECEIPT',
                 sysdate,
                 'FG_RECEIPT',
                 sysdate,
                 1      ,
                 f_get_work_actual_date(sysdate,'A'),
                 f_get_worktime_zone(to_char(sysdate,'yyyymmdd'), to_char(sysdate,'hh24mi'),'ZONE'),
                 f_get_work_shift_code(sysdate)
           from dual;

         if p_commit = 'Y' then
           commit ;
         end if;
 

         if p_commit = 'Y' then
           commit ;
         end if;

    p_out := 'OK';

    if p_txn = 1 then
       p_msg := lvs_model_name||', '||to_char(lvl_pack_qty)||'  '||'Receipt '||' '||f_msg('정상처리 되었습니다.','C',1);
    else
       p_msg := lvs_model_name||', '||to_char(lvl_pack_qty)||'  '||'Cancel '||' '||f_msg('정상처리 되었습니다.','C',1);
    end if;

exception
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
  when others then
    p_out := 'NG' ;
    p_msg := substr(sqlerrm,1,200);

    if p_commit = 'Y' then
      rollback ;
    end if;

end P_PRODUCT_FG_MODEL_RECEIPT;
