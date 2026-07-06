CREATE OR REPLACE TRIGGER "TRG_ip_product_2d_barcode_INS"
  /* ================================================================
   * 트리거명  : TRG_ip_product_2d_barcode_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IP_PRODUCT_2D_BARCODE 테이블의 INSERT 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IP_PRODUCT_2D_BARCODE - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.SERIAL_NO - 신규/변경 후 시리얼 관련 값
   *   :NEW.BOX_NO - 신규/변경 후 값 값
   *   :NEW.ENTER_BY - 신규/변경 후 값 값
   *   :NEW.LAST_MODIFY_BY - 신규/변경 후 값 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_2D_BARCODE - 제품 / 바코드 관련 트리거 대상 테이블
   *   IP_PRODUCT_PACK_SERIAL - 제품 / 시리얼 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 1회, INSERT 1회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_ip_product_2d_barcode_INS';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_ip_product_2d_barcode_INS';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */

  before insert on ip_product_2d_barcode
  for each row
declare
  
  lvs_box_no    varchar2(100);
  
begin
  
   -- Pack serial 생성시 box_no 확인

   BEGIN
   
      SELECT PACK_BARCODE
        INTO lvs_box_no
        FROM IP_PRODUCT_PACK_SERIAL
       WHERE BARCODE = :NEW.SERIAL_NO
         AND ROWNUM  = 1;
       
   EXCEPTION
      WHEN OTHERS THEN
           lvs_box_no := NULL; 
   END;
      
   :new.box_no          := lvs_box_no;
   :new.enter_by        := 'TRG INS 2D BCR';
   :new.last_modify_by  := 'TRG INS 2D BCR';
   
  
end;
