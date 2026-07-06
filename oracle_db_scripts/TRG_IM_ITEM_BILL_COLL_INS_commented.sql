CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_IM_ITEM_BILL_COLL_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IM_ITEM_BILL_COLLECTION 테이블의 INSERT 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IM_ITEM_BILL_COLLECTION - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.SUPPLIER_CODE - 신규/변경 후 공급사 관련 값
   *   :NEW.INVOICE_NO - 신규/변경 후 값 값
   *   :NEW.ORGANIZATION_ID - 신규/변경 후 값 값
   *   :NEW.BILL_COLLECTION_AMT - 신규/변경 후 값 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IM_ITEM_BILL_COLLECTION - 품목 관련 트리거 대상 테이블
   *   IM_ITEM_SALE_INVOICE_MASTER - 품목 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 6회 / 반복문: 0회
   *   DML: SELECT 1회, INSERT 1회, UPDATE 4회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_IM_ITEM_BILL_COLL_INS';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_IM_ITEM_BILL_COLL_INS';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_IM_ITEM_BILL_COLL_INS" 
 BEFORE
  INSERT
 ON im_item_bill_collection
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvf_bill_collection_amt   NUMBER;
   lvf_sale_amt              NUMBER;
BEGIN
   BEGIN
      SELECT sale_amt, NVL (bill_collection_amt, 0)
        INTO lvf_sale_amt, lvf_bill_collection_amt
        FROM im_item_sale_invoice_master
       WHERE supplier_code = :NEW.supplier_code
         AND invoice_no = :NEW.invoice_no
         AND organization_id = :NEW.organization_id
         AND invoice_open_yn = 'Y';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (
            -20003,
               'SALE INVOICE NOT FOUND '
            || :NEW.invoice_no
         );
   END;

   IF :NEW.bill_collection_amt < 0
   THEN
      IF lvf_sale_amt =
                    NVL (lvf_bill_collection_amt, 0)
                  + :NEW.bill_collection_amt
      THEN
         UPDATE im_item_sale_invoice_master
            SET bill_collection_amt =
                        NVL (bill_collection_amt, 0)
                      + :NEW.bill_collection_amt,
                bill_collection_type = 'C'
          WHERE supplier_code = :NEW.supplier_code
            AND invoice_no = :NEW.invoice_no
            AND organization_id = :NEW.organization_id
            AND invoice_open_yn = 'Y';
      ELSE
         UPDATE im_item_sale_invoice_master
            SET bill_collection_amt =
                        NVL (bill_collection_amt, 0)
                      + :NEW.bill_collection_amt,
                bill_collection_type = 'P'
          WHERE supplier_code = :NEW.supplier_code
            AND invoice_no = :NEW.invoice_no
            AND organization_id = :NEW.organization_id
            AND invoice_open_yn = 'Y';
      END IF;
   ELSE
      IF lvf_sale_amt =
                    NVL (lvf_bill_collection_amt, 0)
                  + :NEW.bill_collection_amt
      THEN
         UPDATE im_item_sale_invoice_master
            SET bill_collection_amt =
                        NVL (bill_collection_amt, 0)
                      + :NEW.bill_collection_amt,
                bill_collection_type = 'C'
          WHERE supplier_code = :NEW.supplier_code
            AND invoice_no = :NEW.invoice_no
            AND organization_id = :NEW.organization_id
            AND invoice_open_yn = 'Y';
      ELSE
         UPDATE im_item_sale_invoice_master
            SET bill_collection_amt =
                        NVL (bill_collection_amt, 0)
                      + :NEW.bill_collection_amt,
                bill_collection_type = 'P'
          WHERE supplier_code = :NEW.supplier_code
            AND invoice_no = :NEW.invoice_no
            AND organization_id = :NEW.organization_id
            AND invoice_open_yn = 'Y';
      END IF;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;
