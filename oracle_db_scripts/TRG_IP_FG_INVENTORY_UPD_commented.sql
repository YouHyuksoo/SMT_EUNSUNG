CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_IP_FG_INVENTORY_UPD
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IP_PRODUCT_FG_INVENTORY 테이블의 UPDATE 발생 시 재고/수불 관련 후속 데이터를 자동 정리한다.
   *   입출고, 재고 수량, 수불장 연계 값을 일관되게 유지하기 위한 트리거로 추정된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: UPDATE
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IP_PRODUCT_FG_INVENTORY - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.PALLET_FLAG - 신규/변경 후 값 값
   *   :NEW.PALLET_DATE - 신규/변경 후 일자 관련 값
   *   :NEW.PALLET_NO - 신규/변경 후 값 값
   *   :OLD.PALLET_FLAG - 변경/삭제 전 값 값
   *   :OLD.PALLET_DATE - 변경/삭제 전 일자 관련 값
   *   :OLD.PALLET_NO - 변경/삭제 전 값 값
   *   :OLD.BARCODE - 변경/삭제 전 바코드 관련 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_FG_INVENTORY - 제품 / 재고 관련 트리거 대상 테이블
   *   IP_PRODUCT_PACK_MASTER - 제품 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 4회 / 반복문: 0회
   *   DML: UPDATE 3회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_IP_FG_INVENTORY_UPD';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_IP_FG_INVENTORY_UPD';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_IP_FG_INVENTORY_UPD" 
  before update of pallet_flag on ip_product_fg_inventory  
  for each row
declare
  -- local variables here
begin
  if :new.pallet_flag = 'Y' and :old.pallet_flag = 'N' then 
    update ip_product_pack_master x 
       set x.pallet_flag  = :new.pallet_flag
          ,x.pallet_date  = nvl(:new.pallet_date,:old.pallet_date)
          ,x.pallet_no     = nvl(:new.pallet_no,:old.pallet_no) 
     where x.pack_barcode = :old.barcode ; 
  end if; 
  
  if :new.pallet_flag = 'N' and :old.pallet_flag = 'Y' then 
    update ip_product_pack_master 
       set pallet_flag  = :new.pallet_flag
          ,pallet_date  = null
          ,pallet_no     = null
     where pack_barcode = :old.barcode ; 
     
  end if ;
  
exception 
  when others then 
    raise_application_error(-20099,' TRG FG_INVENTORY_UPD '||substr(sqlerrm,1,150)); 
  
end TRG_ip_FG_Inventory_upd;
