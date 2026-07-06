CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_IP_PROD_REWORK_RESULT_UPD
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IP_PRODUCT_REWORK_RESULT 테이블의 UPDATE 발생 시 생산/검사 실적 관련 값을 자동 보정하거나 이력을 갱신한다.
   *   제품 실적, 검사 결과, 공정 흐름의 데이터 정합성을 유지하기 위한 트리거로 추정된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: UPDATE
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IP_PRODUCT_REWORK_RESULT - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.LQC_INSPECT_RESULT - 신규/변경 후 검사 / 실적 관련 값
   *   :NEW.LQC_INSPECT_NO - 신규/변경 후 검사 관련 값
   *   :NEW.LAST_MODIFY_BY - 신규/변경 후 값 값
   *   :NEW.LAST_MODIFY_DATE - 신규/변경 후 일자 관련 값
   *   :NEW.OQC_INSPECT_RESULT - 신규/변경 후 검사 / 실적 관련 값
   *   :NEW.OQC_INSPECT_NO - 신규/변경 후 검사 관련 값
   *   :OLD.LQC_INSPECT_RESULT - 변경/삭제 전 검사 / 실적 관련 값
   *   :OLD.ORGANIZATION_ID - 변경/삭제 전 값 값
   *   :OLD.MFS - 변경/삭제 전 값 값
   *   :OLD.ITEM_CODE - 변경/삭제 전 품목 관련 값
   *   :OLD.LINE_CODE - 변경/삭제 전 라인 관련 값
   *   :OLD.WORKSTAGE_CODE - 변경/삭제 전 공정 관련 값
   *   :OLD.PRODUCT_ACTUAL_QTY - 변경/삭제 전 제품 / 수량 관련 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_REWORK_RESULT - 제품 / 실적 관련 트리거 대상 테이블
   *   IQ_PRODUCT_LQC - 제품 관련 트리거 내부 SQL에서 참조/변경
   *   IQ_PRODUCT_OQC - 제품 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   명시적 EXCEPTION 블록 없음 - 호출부/Oracle 표준 예외 처리를 따른다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 4회, ELSIF 6회 / 반복문: 0회
   *   DML: INSERT 6회, UPDATE 1회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_IP_PROD_REWORK_RESULT_UPD';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_IP_PROD_REWORK_RESULT_UPD';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_IP_PROD_REWORK_RESULT_UPD" 
 BEFORE
   UPDATE OF lqc_inspect_result, oqc_inspect_result
 ON ip_product_rework_result
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvl_cnt   NUMBER;
BEGIN
   IF :NEW.lqc_inspect_result = 'W'
   THEN
      NULL;
   ELSIF      :NEW.lqc_inspect_result = 'P'
          AND :NEW.lqc_inspect_result <> :OLD.lqc_inspect_result
   THEN
      -- INSET INTO NEW INSPECT RESULT PASS
      INSERT INTO iq_product_lqc
                  (inspect_date,
                   inspect_sequence,
                   organization_id,
                   lqc_inspect_no,
                   mfs,
                   item_code,
                   line_code,
                   workstage_code,
                   lqc_inspect_result,
                   product_actual_qty,
                   inspect_bad_qty,
                   inspect_by,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by
                  )
           VALUES (TRUNC (SYSDATE),
                   seq_lqc_inspect_no.NEXTVAL,
                   :OLD.organization_id,
                   :NEW.lqc_inspect_no,
                   :OLD.mfs,
                   :OLD.item_code,
                   :OLD.line_code,
                   :OLD.workstage_code,
                   'P',
                   :OLD.product_actual_qty,
                   0,
                   :NEW.last_modify_by,
                   :NEW.last_modify_date,
                   :NEW.last_modify_by,
                   :NEW.last_modify_date,
                   :NEW.last_modify_by
                  );
   ELSIF      :NEW.lqc_inspect_result = 'R'
          AND :NEW.lqc_inspect_result <> :OLD.lqc_inspect_result
   THEN
      -- INSET INTO NEW INSPECT RESULT RETURN
      INSERT INTO iq_product_lqc
                  (inspect_date,
                   inspect_sequence,
                   organization_id,
                   lqc_inspect_no,
                   mfs,
                   item_code,
                   line_code,
                   workstage_code,
                   lqc_inspect_result,
                   product_actual_qty,
                   inspect_bad_qty,
                   inspect_by,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by
                  )
           VALUES (TRUNC (SYSDATE),
                   seq_lqc_inspect_no.NEXTVAL,
                   :OLD.organization_id,
                   :NEW.lqc_inspect_no,
                   :OLD.mfs,
                   :OLD.item_code,
                   :OLD.line_code,
                   :OLD.workstage_code,
                   'R',
                   :OLD.product_actual_qty,
                   0,
                   :NEW.last_modify_by,
                   :NEW.last_modify_date,
                   :NEW.last_modify_by,
                   :NEW.last_modify_date,
                   :NEW.last_modify_by
                  );
   ELSIF      :NEW.lqc_inspect_result = 'U'
          AND :NEW.lqc_inspect_result <> :OLD.lqc_inspect_result
   THEN
      -- INSET INTO NEW INSPECT RESULT REUSE
      INSERT INTO iq_product_lqc
                  (inspect_date,
                   inspect_sequence,
                   organization_id,
                   lqc_inspect_no,
                   mfs,
                   item_code,
                   line_code,
                   workstage_code,
                   lqc_inspect_result,
                   product_actual_qty,
                   inspect_bad_qty,
                   inspect_by,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by
                  )
           VALUES (TRUNC (SYSDATE),
                   seq_lqc_inspect_no.NEXTVAL,
                   :OLD.organization_id,
                   :NEW.lqc_inspect_no,
                   :OLD.mfs,
                   :OLD.item_code,
                   :OLD.line_code,
                   :OLD.workstage_code,
                   'U',
                   :OLD.product_actual_qty,
                   0,
                   :NEW.last_modify_by,
                   :NEW.last_modify_date,
                   :NEW.last_modify_by,
                   :NEW.last_modify_date,
                   :NEW.last_modify_by
                  );
   END IF;

   IF :NEW.oqc_inspect_result = 'W'
   THEN
      NULL;
   ELSIF      :NEW.oqc_inspect_result = 'P'
          AND :NEW.lqc_inspect_result <> :OLD.lqc_inspect_result
   THEN
      -- INSET INTO NEW INSPECT RESULT PASS
      INSERT INTO iq_product_oqc
                  (inspect_date,
                   inspect_sequence,
                   organization_id,
                   oqc_inspect_no,
                   mfs,
                   item_code,
                   receipt_qty,
                   oqc_inspect_result,
                   inspect_bad_qty,
                   inspect_by,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by
                  )
           VALUES (TRUNC (SYSDATE),
                   seq_qc_oqc_inspect_no.NEXTVAL,
                   :OLD.organization_id,
                   :NEW.oqc_inspect_no,
                   :OLD.mfs,
                   :OLD.item_code,
                   0,
                   'P',
                   0,
                   :NEW.last_modify_by,
                   :NEW.last_modify_date,
                   :NEW.last_modify_by,
                   :NEW.last_modify_date,
                   :NEW.last_modify_by
                  );
   ELSIF      :NEW.oqc_inspect_result = 'R'
          AND :NEW.lqc_inspect_result <> :OLD.lqc_inspect_result
   THEN
      -- INSET INTO NEW INSPECT RESULT RETURN
      INSERT INTO iq_product_oqc
                  (inspect_date,
                   inspect_sequence,
                   organization_id,
                   oqc_inspect_no,
                   mfs,
                   item_code,
                   receipt_qty,
                   oqc_inspect_result,
                   inspect_bad_qty,
                   inspect_by,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by
                  )
           VALUES (TRUNC (SYSDATE),
                   seq_qc_oqc_inspect_no.NEXTVAL,
                   :OLD.organization_id,
                   :NEW.oqc_inspect_no,
                   :OLD.mfs,
                   :OLD.item_code,
                   0,
                   'R',
                   0,
                   :NEW.last_modify_by,
                   :NEW.last_modify_date,
                   :NEW.last_modify_by,
                   :NEW.last_modify_date,
                   :NEW.last_modify_by
                  );
   ELSIF      :NEW.oqc_inspect_result = 'U'
          AND :NEW.lqc_inspect_result <> :OLD.lqc_inspect_result
   THEN
      -- INSET INTO NEW INSPECT RESULT REUSE
      INSERT INTO iq_product_oqc
                  (inspect_date,
                   inspect_sequence,
                   organization_id,
                   oqc_inspect_no,
                   mfs,
                   item_code,
                   receipt_qty,
                   oqc_inspect_result,
                   inspect_bad_qty,
                   inspect_by,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by
                  )
           VALUES (TRUNC (SYSDATE),
                   seq_qc_oqc_inspect_no.NEXTVAL,
                   :OLD.organization_id,
                   :NEW.oqc_inspect_no,
                   :OLD.mfs,
                   :OLD.item_code,
                   0,
                   'U',
                   0,
                   :NEW.last_modify_by,
                   :NEW.last_modify_date,
                   :NEW.last_modify_by,
                   :NEW.last_modify_date,
                   :NEW.last_modify_by
                  );
   END IF;
END;
