CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_IP_PRODUCT_PACK_MASTER_UPD
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IP_PRODUCT_PACK_MASTER 테이블의 UPDATE 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: UPDATE
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IP_PRODUCT_PACK_MASTER - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.COMPLETE_FLAG - 신규/변경 후 값 값
   *   :NEW.PACK_QTY - 신규/변경 후 수량 관련 값
   *   :OLD.PACK_BARCODE - 변경/삭제 전 바코드 관련 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_PACK_MASTER - 제품 관련 트리거 대상 테이블
   *   IP_PRODUCT_PACK_SERIAL - 제품 / 시리얼 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   명시적 EXCEPTION 블록 없음 - 호출부/Oracle 표준 예외 처리를 따른다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 1회, UPDATE 2회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_IP_PRODUCT_PACK_MASTER_UPD';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_IP_PRODUCT_PACK_MASTER_UPD';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_IP_PRODUCT_PACK_MASTER_UPD" 
  before update of complete_flag on ip_product_pack_master  
  for each row
declare
  lvl_pack_count number; 
begin
   -- local variables here
   --  Pack 수량 Update 
  if :new.complete_flag = 'Y' then 
    SELECT COUNT(*) 
      into lvl_pack_count
      FROM IP_PRODUCT_PACK_SERIAL X 
     WHERE X.Pack_Barcode = :old.pack_barcode ; 
     
    
    :new.pack_qty := lvl_pack_count ;  
     
  end if ; 
end TRG_IP_PRODUCT_PACK_MASTER_UPD;
