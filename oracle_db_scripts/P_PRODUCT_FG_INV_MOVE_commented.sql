CREATE OR REPLACE PROCEDURE "P_PRODUCT_FG_INV_MOVE" (p_barcode varchar2,
  /* ================================================================
   * 프로시저명  : P_PRODUCT_FG_INV_MOVE
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
   *   P_LOCATION - 원본 선언부 기준 입력/출력 파라미터
   *   P_COMMIT - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   *   P_MSG - 원본 선언부 기준 입력/출력 파라미터
   *   P_LOCATION - 원본 선언부 기준 입력/출력 파라미터
   *   PACK_TYPE - 원본 선언부 기준 입력/출력 파라미터
   *   P_BARCODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   *   P_MSG - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   *   P_MSG - 원본 선언부 기준 입력/출력 파라미터
   *   P_LOCATION - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   *   P_MSG - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   *   P_MSG - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   *   P_MSG - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_FG_INVENTORY - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_MSG
   *   P_PRODUCT_FG_MAGAZINE_RECEIPT
   *   P_PRODUCT_FG_RECEIPT
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_PRODUCT_FG_INV_MOVE(...)
   * ================================================================ */
                                                  p_location varchar2,  
                                                  p_commit varchar2, 
                                                  p_out out varchar2, 
                                                  p_msg out varchar2) is

/*******************************************************
* 재고 이동 p_location : to Location 
********************************************************/
  lvs_c_location varchar2(20);  -- [AI] 내부 처리용 변수
  lvd_inv_date   date ;  -- [AI] 내부 처리용 변수
  lvs_pack_type  varchar2(20);  -- [AI] 내부 처리용 변수
  
  lvs_out        varchar2(4000); -- [AI] 내부 처리용 변수
  lvs_msg        varchar2(4000);  -- [AI] 내부 처리용 변수
  
begin
   -- [AI] 주요 업무 처리 로직을 시작한다.
  /*******************
  * 창고에 존재하는지 여부 확인 
  ********************/
  begin 
    select x.location_code , 
           x.inventory_date, 
           x.pack_type 
      into lvs_c_location, 
           lvd_inv_date  , 
           lvs_pack_type
      from ip_product_fg_inventory x 
     where x.barcode = p_barcode ; 
  exception 
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
     when no_data_found then
        p_out := 'NG' ; 
        p_msg := f_msg('존재하지 않는 Barcode 입니다.','C',1);
        return ;     
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      when others then
        p_out := 'NG'; 
        p_msg := substr(sqlerrm,1,200);
        return ;      
  end ;
  
  if lvs_c_location = p_location then 
     p_out := 'NG' ; 
     p_msg := f_msg('이동할 창고와 현창위치가 동일 합니다.','C',1);
     return ;   
  end if ; 
  
  
  /****************************
  * 1. 입고 반품 실시 
  *****************************/
  if lvs_pack_type = 'C' then 
  --   p_product_fg_receipt(p_barcode,'*','2','N', lvs_out, lvs_msg ) ; 
     p_product_fg_receipt(p_barcode,lvs_c_location,'2','N', lvs_out, lvs_msg ) ; 
  else 
--  p_product_fg_magazine_receipt(p_barcode,'*','2','N', lvs_out, lvs_msg ) ;     
     p_product_fg_magazine_receipt(p_barcode,lvs_c_location,'2','N', lvs_out, lvs_msg ) ; 
  end if ;
  
  if lvs_out = 'NG' then 
    p_out := 'NG' ; 
    p_msg := f_msg('재고이동 반품','C',1)||'  '||lvs_msg ;
    rollback ; 
    return ;     
  end if; 
  
  /****************************
  * 2. 입고 실시 
  *****************************/
  if lvs_pack_type = 'C' then 
     p_product_fg_receipt(p_barcode,p_location,'1','N', lvs_out, lvs_msg ) ; 
  else
     p_product_fg_magazine_receipt(p_barcode,p_location,'1','N', lvs_out, lvs_msg ) ; 
  end if; 
  
  if lvs_out = 'NG' then 
    p_out := 'NG' ; 
    p_msg := f_msg('재고이동 입고','C',1)||'  '||p_barcode||' '||lvs_msg ;
    rollback ; 
    return ;     
  end if; 
  
  p_out := 'OK' ; 
  p_msg := 'Inventory Move Success' ; 
  commit ; 
  
  begin 
    update ip_product_fg_inventory x 
       set x.inventory_date = lvd_inv_date 
     where barcode          = p_barcode ;
     
     commit ;  
  exception 
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
    when others then 
      rollback ; 
      return ; 
  end ; 
    
end P_PRODUCT_FG_INV_MOVE;
