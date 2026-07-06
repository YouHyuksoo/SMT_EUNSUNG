CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_IP_PROD_RESULT_BARCODE_DEL
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IP_PRODUCT_RESULT_BARCODE 테이블의 DELETE 발생 시 생산/검사 실적 관련 값을 자동 보정하거나 이력을 갱신한다.
   *   제품 실적, 검사 결과, 공정 흐름의 데이터 정합성을 유지하기 위한 트리거로 추정된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: DELETE
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IP_PRODUCT_RESULT_BARCODE - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :OLD.PRODUCT_DATE - 변경/삭제 전 제품 / 일자 관련 값
   *   :OLD.PRODUCT_SEQUENCE - 변경/삭제 전 제품 관련 값
   *   :OLD.ORGANIZATION_ID - 변경/삭제 전 값 값
   *   :OLD.PRODUCT_ACTUAL_QTY - 변경/삭제 전 제품 / 수량 관련 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_RESULT_BARCODE - 제품 / 실적 / 바코드 관련 트리거 대상 테이블
   *   IP_PRODUCT_RESULT - 제품 / 실적 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 1회, UPDATE 1회, DELETE 2회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_IP_PROD_RESULT_BARCODE_DEL';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_IP_PROD_RESULT_BARCODE_DEL';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_IP_PROD_RESULT_BARCODE_DEL" 
 BEFORE
  DELETE
 ON ip_product_result_barcode
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
    lvi_exists   NUMBER;
BEGIN
    BEGIN
        SELECT   COUNT ( * )
          INTO   lvi_exists
          FROM   ip_product_result
         WHERE       product_date = :old.product_date
                 AND product_sequence = :old.product_sequence
                 AND organization_id = :old.organization_id;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            lvi_exists := 0;
    END;

    IF lvi_exists = 0
    THEN
        NULL;
    --   raise_application_error (-20003, 'PRODUCT RESULT NOT FOUND '||SQLERRM);
    ELSE
        UPDATE   ip_product_result
           SET   product_actual_qty =
                     product_actual_qty - :old.product_actual_qty
         WHERE       product_date = :old.product_date
                 AND product_sequence = :old.product_sequence
                 AND organization_id = :old.organization_id;

        DELETE FROM   ip_product_result
              WHERE       product_date = :old.product_date
                      AND product_sequence = :old.product_sequence
                      AND product_actual_qty = 0
                      AND organization_id = :old.organization_id;
    END IF;
EXCEPTION
    WHEN OTHERS
    THEN
        raise_application_error (-20003, SQLERRM);
END;
