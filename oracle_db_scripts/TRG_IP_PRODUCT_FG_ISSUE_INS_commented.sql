CREATE OR REPLACE TRIGGER "TRG_IP_PRODUCT_FG_ISSUE_INS"
  /* ================================================================
   * 트리거명  : TRG_IP_PRODUCT_FG_ISSUE_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IP_PRODUCT_FG_ISSUE 테이블의 INSERT 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IP_PRODUCT_FG_ISSUE - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.TXN_DEFICIT - 신규/변경 후 값 값
   *   :NEW.BARCODE - 신규/변경 후 바코드 관련 값
   *   :NEW.LOCATION_CODE - 신규/변경 후 값 값
   *   :NEW.QTY - 신규/변경 후 수량 관련 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_FG_ISSUE - 제품 / 출고 관련 트리거 대상 테이블
   *   IP_PRODUCT_FG_INVENTORY - 제품 / 재고 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 호출 객체:
   *   P_JOB_ERRORLOG - 트리거 내부 업무 처리 호출
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 6회, ELSIF 1회 / 반복문: 0회
   *   DML: SELECT 2회, INSERT 1회, UPDATE 2회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_IP_PRODUCT_FG_ISSUE_INS';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_IP_PRODUCT_FG_ISSUE_INS';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */

  before insert on ip_product_fg_issue 
  for each row

declare

  /**********************************************
  * 모델단위 입고 시 재고 생성
  ***********************************************/     
   lvs_error_msg      varchar2(500); 
   lvl_count          number;
  
   lvs_txn_deficit    varchar2(10); 
   lvs_location_code  varchar2(10); 
   lvl_qty            number;  
   
   lvs_step           varchar2(200); 
   
   lvl_last_seq       number;
  
begin
  

 /*****************************************
  * 2.정상입고 
  *****************************************/
  if :new.txn_deficit = '3' then   
      
     select count(*) 
       into lvl_count
       from ip_product_fg_inventory     
      where barcode       = :new.barcode
        and location_code = :new.location_code;
      
      if lvl_count = 0  then
        
         lvs_error_msg := '출고 할 재고가 없습니다';
         p_job_errorlog(920,1,'제품출고 TRG','TRG_IP_PRODUCT_FG_ISSUE_INS',substr(lvs_error_msg,1,200),'TRG') ; 
         raise_application_error(-20099,'TRG NG : '||substr(lvs_error_msg,1,150));
          
      else
     
          update ip_product_fg_inventory
             set qty           = qty - :new.qty
           where barcode       = :new.barcode
             and location_code = :new.location_code;
        
      end if;
        
   elsif :new.txn_deficit = '4' then  
     
     -- 출고이력 확인
     begin
      
         select qty
           into lvl_qty
           from ip_product_fg_inventory     
          where barcode       = :new.barcode
            and location_code = :new.location_code;
          
         if ( lvl_qty <> 0 ) then
                              
              lvs_error_msg := '출고 취소 할 재고가 0이 아닙니다';    -- 출고취소시 재고는 0 이이어야 함
              p_job_errorlog(920,1,'제품출고 TRG','TRG_IP_PRODUCT_FG_ISSUE_INS',substr(lvs_error_msg,1,200),'TRG') ; 
              raise_application_error(-20099,'TRG NG : '||substr(lvs_error_msg,1,150));
                                                   
         else
                                                      
              update ip_product_fg_inventory
                 set qty            = qty + :new.qty
               where barcode        = :new.barcode
                 and location_code  = :new.location_code;    
                               
         end if; 
         
     exception 
         when no_data_found then 
           
              lvs_error_msg := '지정한 로케이션에 재고정보가 없습니다';
              p_job_errorlog(920,1,'제품출고 TRG','TRG_IP_PRODUCT_FG_ISSUE_INS',substr(lvs_error_msg,1,200),'TRG') ; 
              raise_application_error(-20099,'TRG NG : '||substr(lvs_error_msg,1,150));   
              
         when others then 
           
              lvs_error_msg := substr(sqlerrm,1,150); 
              p_job_errorlog(920,1,'제품출고 TRG','TRG_IP_PRODUCT_FG_ISSUE_INS',substr(lvs_error_msg,1,200),'TRG') ; 
              raise_application_error(-20099,'TRG NG : '||substr(lvs_error_msg,1,150));                
           
     end;  
     
      
   end if;

exception 
  when others then 
       p_job_errorlog(920,1,'제품출고 TRG','TRG_IP_PRODUCT_FG_ISSUE_INS',substr(sqlerrm,1,200),'TRG') ; 
       raise_application_error(-20099,'TRG NG : '||substr(sqlerrm,1,150)); 

end TRG_IP_PRODUCT_FG_ISSUE_INS;
