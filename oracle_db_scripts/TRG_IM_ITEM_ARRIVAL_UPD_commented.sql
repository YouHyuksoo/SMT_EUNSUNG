CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_IM_ITEM_ARRIVAL_UPD
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IM_ITEM_ARRIVAL 테이블의 UPDATE 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: UPDATE
   *   단위: FOR EACH ROW
   *   조건: 
NEW.inspect_result = 'U'
         OR NEW.inspect_result = 'P'
         OR NEW.inspect_result = 'R'
         OR NEW.inspect_result = 'W'
      
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IM_ITEM_ARRIVAL - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.INSPECT_RESULT - 신규/변경 후 검사 / 실적 관련 값
   *   :NEW.IQC_INSPECT_NO - 신규/변경 후 검사 관련 값
   *   :NEW.LAST_MODIFY_BY - 신규/변경 후 값 값
   *   :NEW.LAST_MODIFY_DATE - 신규/변경 후 일자 관련 값
   *   :OLD.IQC_INSPECT_NO - 변경/삭제 전 검사 관련 값
   *   :OLD.ORGANIZATION_ID - 변경/삭제 전 값 값
   *   :OLD.SUPPLIER_CODE - 변경/삭제 전 공급사 관련 값
   *   :OLD.MFS - 변경/삭제 전 값 값
   *   :OLD.ITEM_CODE - 변경/삭제 전 품목 관련 값
   *   :OLD.ARRIVAL_QTY - 변경/삭제 전 수량 관련 값
   *   :OLD.PRODUCT_DATE - 변경/삭제 전 제품 / 일자 관련 값
   *   :OLD.DEPARTURE_DATE - 변경/삭제 전 일자 관련 값
   *   :OLD.ARRIVAL_DATE - 변경/삭제 전 일자 관련 값
   *   :OLD.ARRIVAL_SEQ_NO - 변경/삭제 전 값 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IM_ITEM_ARRIVAL - 품목 관련 트리거 대상 테이블
   *   IQ_ITEM_IQC - 품목 관련 트리거 내부 SQL에서 참조/변경
   *   IQ_ITEM_IQC_BAD - 품목 관련 트리거 내부 SQL에서 참조/변경
   *   IM_ITEM_MASTER - 품목 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_INSPECT_SAMPLE_QTY - 트리거 내부 업무 처리 호출
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회, ELSIF 1회 / 반복문: 0회
   *   DML: SELECT 2회, INSERT 2회, UPDATE 1회, DELETE 2회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_IM_ITEM_ARRIVAL_UPD';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_IM_ITEM_ARRIVAL_UPD';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_IM_ITEM_ARRIVAL_UPD" 
 BEFORE
   UPDATE OF inspect_result
 ON im_item_arrival
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
 WHEN (
NEW.inspect_result = 'U'
         OR NEW.inspect_result = 'P'
         OR NEW.inspect_result = 'R'
         OR NEW.inspect_result = 'W'
      ) DECLARE
   lvl_cnt   NUMBER;
BEGIN
   IF :NEW.inspect_result = 'W'
   THEN
      DELETE FROM iq_item_iqc
            WHERE iqc_inspect_no = :OLD.iqc_inspect_no
              AND organization_id = :OLD.organization_id;

      DELETE FROM iq_item_iqc_bad
            WHERE iqc_inspect_no = :OLD.iqc_inspect_no
              AND organization_id = :OLD.organization_id;
   ELSIF    :NEW.inspect_result = 'P'
         OR :NEW.inspect_result = 'U'
   THEN
      INSERT INTO iq_item_iqc
                  (inspect_date,
                   inspect_sequence,
                   organization_id,
                   iqc_inspect_no,
                   supplier_code,
                   destroy_qty,
                   mfs,
                   item_code,
                   arrival_qty,
                   inspect_lot_qty,
                   inspect_bad_lot_qty,
                   inspect_qty,
                   inspect_bad_qty,
                   inspect_result,
                   product_date,
                   departure_date,
                   arrival_date,
                   arrival_seq_no,
                   inspect_by,
                   iqc_improve_no,
                   destroy_reason_code,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by,
                   inspect_method
                  )
           VALUES (TRUNC (SYSDATE),
                   seq_qc_iqc_inspect.NEXTVAL,
                   :OLD.organization_id,
                   :NEW.iqc_inspect_no,
                   :OLD.supplier_code,
                   0, -- DESTROY_QTY,
                   :OLD.mfs,
                   :OLD.item_code,
                   :OLD.arrival_qty,
                   1,
                   0,
                   f_get_inspect_sample_qty (
                      :OLD.arrival_qty,
                      :OLD.organization_id
                   ), --ROUND(:OLD.ARRIVAL_QTY * 0.1,0) ,
                   0,
                   :NEW.inspect_result,
                   :OLD.product_date,
                   :OLD.departure_date,
                   :OLD.arrival_date,
                   :OLD.arrival_seq_no,
                   :NEW.last_modify_by,
                   '',
                   '',
                   :NEW.last_modify_date,
                   :NEW.last_modify_by,
                   :NEW.last_modify_date,
                   :NEW.last_modify_by,
                   (SELECT inspect_method
                      FROM im_item_master
                     WHERE item_code = :OLD.item_code
                       AND supplier_code = :OLD.supplier_code
                       AND organization_id = :OLD.organization_id)
                  );
   ELSE
      -- INSET INTO NEW INSPECT RESULT RETURN
      INSERT INTO iq_item_iqc
                  (inspect_date,
                   inspect_sequence,
                   organization_id,
                   iqc_inspect_no,
                   supplier_code,
                   destroy_qty,
                   mfs,
                   item_code,
                   arrival_qty,
                   inspect_lot_qty,
                   inspect_bad_lot_qty,
                   inspect_qty,
                   inspect_bad_qty,
                   inspect_result,
                   product_date,
                   departure_date,
                   arrival_date,
                   arrival_seq_no,
                   inspect_by,
                   iqc_improve_no,
                   destroy_reason_code,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by,
                   inspect_method
                  )
           VALUES (TRUNC (SYSDATE),
                   seq_qc_iqc_inspect.NEXTVAL,
                   :OLD.organization_id,
                   :NEW.iqc_inspect_no,
                   :OLD.supplier_code,
                   0, -- DESTROY_QTY,
                   :OLD.mfs,
                   :OLD.item_code,
                   :OLD.arrival_qty,
                   1,
                   1,
                   f_get_inspect_sample_qty (
                      :OLD.arrival_qty,
                      :OLD.organization_id
                   ), --INSPECT_QTY,
                   0,
                   :NEW.inspect_result,
                   :OLD.product_date,
                   :OLD.departure_date,
                   :OLD.arrival_date,
                   :OLD.arrival_seq_no,
                   :NEW.last_modify_by,
                   '',
                   '',
                   :NEW.last_modify_date,
                   :NEW.last_modify_by,
                   :NEW.last_modify_date,
                   :NEW.last_modify_by,
                   (SELECT inspect_method
                      FROM im_item_master
                     WHERE item_code = :OLD.item_code
                       AND supplier_code = :OLD.supplier_code
                       AND organization_id = :OLD.organization_id)
                  );
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;
