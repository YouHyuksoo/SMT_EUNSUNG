CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRGIP_PRODUCT_WORK_QC_UPD
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IP_PRODUCT_WORK_QC 테이블의 UPDATE 발생 시 생산/검사 실적 관련 값을 자동 보정하거나 이력을 갱신한다.
   *   제품 실적, 검사 결과, 공정 흐름의 데이터 정합성을 유지하기 위한 트리거로 추정된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: UPDATE
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IP_PRODUCT_WORK_QC - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.RECEIPT_DEFICIT - 신규/변경 후 입고 관련 값
   *   :NEW.SERIAL_NO - 신규/변경 후 시리얼 관련 값
   *   :NEW.QC_INSPECT_HANDLING - 신규/변경 후 검사 관련 값
   *   :OLD.RECEIPT_DEFICIT - 변경/삭제 전 입고 관련 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_WORK_QC - 제품 관련 트리거 대상 테이블
   *   IP_PRODUCT_2D_BARCODE - 제품 / 바코드 관련 트리거 내부 SQL에서 참조/변경
   *   IQ_PRODUCT_WQC - 제품 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   명시적 EXCEPTION 블록 없음 - 호출부/Oracle 표준 예외 처리를 따른다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 4회 / 반복문: 0회
   *   DML: UPDATE 5회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRGIP_PRODUCT_WORK_QC_UPD';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRGIP_PRODUCT_WORK_QC_UPD';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRGIP_PRODUCT_WORK_QC_UPD" 
 BEFORE 
 UPDATE OF RECEIPT_DEFICIT
 ON IP_PRODUCT_WORK_QC
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW 
DECLARE
   lvi_count               NUMBER;

BEGIN
   ---------------------------------------
   -- 출고인경우
   ---------------------------------------
   IF :OLD.RECEIPT_DEFICIT <> :NEW.RECEIPT_DEFICIT    AND :NEW.RECEIPT_DEFICIT = '2'
   THEN
    
       --BARCODE_STATUS  N :정상 , D : 폐기 , R : 수리품  , B : 불량품  , X : 엑스아웃 

        UPDATE ip_product_2d_barcode SET BARCODE_STATUS = 'R' 
        WHERE serial_no = :new.serial_no 
          AND BARCODE_STATUS <> 'X' ;
        
        UPDATE IQ_PRODUCT_WQC 
           SET REPAIR_RECEIPT_DEFICIT = '2' ,
               REPAIR_DATE = SYSDATE 
        WHERE SERIAL_NO = :NEW.SERIAL_NO ;    
  
   ELSE  

         --------------------------------------------------------------
         -- 출고 했다가 취소 한 겨우

         IF     :OLD.RECEIPT_DEFICIT <> :NEW.RECEIPT_DEFICIT   AND :NEW.RECEIPT_DEFICIT = '1'      AND :NEW.QC_INSPECT_HANDLING <> 'D'
         THEN
           
               --BARCODE_STATUS  N :정상 , D : 폐기 , R : 수리품  , B : 불량품 , X : 엑스아웃 
              
              UPDATE ip_product_2d_barcode SET BARCODE_STATUS = 'B' 
              WHERE serial_no = :new.serial_no 
                AND BARCODE_STATUS <> 'X' ;
              
              UPDATE IQ_PRODUCT_WQC SET REPAIR_RECEIPT_DEFICIT = '1' , REPAIR_DATE = SYSDATE 
              WHERE SERIAL_NO = :NEW.SERIAL_NO ;               
                   
     
     END IF;
END IF ;


END ;
