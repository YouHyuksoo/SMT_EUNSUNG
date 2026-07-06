CREATE OR REPLACE PROCEDURE "P_PRODUCT_FG_ACTUAL_RECEIPT" (
  /* ================================================================
   * 프로시저명  : P_PRODUCT_FG_ACTUAL_RECEIPT
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   실적 발생 시 완제품 모델 단위 재고를 자동 입고 처리한다.
   *   바코드가 완제품 재고에 없으면 IP_PRODUCT_FG_INVENTORY에 신규 입고 데이터를 등록한다.
   *   커밋 여부 파라미터에 따라 변경 확정 여부를 제어한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_BARCODE (IN, VARCHAR2) - 완제품 바코드
   *   P_QTY (IN, NUMBER) - 입고 수량
   *   P_COMMIT (IN, VARCHAR2) - 커밋 처리 여부
   *   P_OUT (OUT, VARCHAR2) - 처리 결과
   *   P_MSG (OUT, VARCHAR2) - 처리 메시지
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_FG_INVENTORY - 완제품 재고 테이블
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN OTHERS/NO_DATA_FOUND 등 원본 예외 처리 흐름을 유지한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 로직 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_PRODUCT_FG_ACTUAL_RECEIPT('BARCODE', 1, 'Y', :P_OUT, :P_MSG)
   * ================================================================ */
                                                            p_barcode in varchar2, -- [AI] 내부 처리용 변수
                                                            p_qty     in number, -- [AI] 내부 처리용 변수
                                                            p_commit  in varchar2, -- [AI] 내부 처리용 변수
                                                            p_out     out varchar2, -- [AI] 내부 처리용 변수
                                                            p_msg     out varchar2 -- [AI] 내부 처리용 변수
                                                            ) is
   /****************************************************
    * 실적발생시 모델단위 자동입고 
    ****************************************************/
    lvl_count number; -- [AI] 내부 처리용 변수
    
begin
   -- [AI] 주요 업무 처리 로직을 시작한다.
    

    /******************************
    * Pack 수량 없는건은 입고 안됨
    ******************************/
     select count(*) 
       into lvl_count
       from ip_product_fg_inventory     
      where barcode   = p_barcode;
      
     if lvl_count = 0  then
        
          /*****************************************
          * 재고 테이블에 입력  
          *****************************************/
          
          insert into ip_product_fg_inventory ( 
                barcode , 
                pack_type, 
                location_code, 
                qty, 
                
                model_name, 
                model_suffix, 
                item_code, 
                item_type, 
                pallet_flag, 
                inventory_date, 
                
                enter_by, 
                enter_date, 
                last_modify_by, 
                last_modify_date, 
                organization_id
          ) 
		       select p_barcode, 
                  'G', 
                  'P01', 
                  p_qty,
               
                  model_name, 
                  model_suffix, 
                  item_code, 
                  '*',            
                  'N',                    
                  sysdate,            
                           
                 'FG_RECV_TRG',
                  sysdate,
                  'FG_RECV_TRG',
                  sysdate,
                  organization_id  
          from ip_product_model_master
		     where model_name = p_barcode
		       and rownum     = 1;
           
      else
     
          update ip_product_fg_inventory
             set qty = qty + p_qty
           where barcode = p_barcode;
        
      end if;  
      
      p_out := 'OK' ;
      p_msg :=  '';
      
      if p_commit = 'Y' then
         commit;
      end if;

exception
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
  when others then
    
    p_out := 'NG' ;
    p_msg := substr(sqlerrm,1,200);
    
    if p_commit = 'Y' then
         rollback;
    end if;    

end P_PRODUCT_FG_ACTUAL_RECEIPT;
