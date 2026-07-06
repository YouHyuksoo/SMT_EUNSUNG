CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_IMCN_MOLD_INVENTORY_UPD
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IMCN_MOLD_INVENTORY 테이블의 UPDATE 발생 시 재고/수불 관련 후속 데이터를 자동 정리한다.
   *   입출고, 재고 수량, 수불장 연계 값을 일관되게 유지하기 위한 트리거로 추정된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: UPDATE
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IMCN_MOLD_INVENTORY - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.LOCATION_CODE - 신규/변경 후 값 값
   *   :NEW.LAST_ADJUST_DATE - 신규/변경 후 일자 관련 값
   *   :NEW.MOLD_CODE - 신규/변경 후 값 값
   *   :NEW.ORGANIZATION_ID - 신규/변경 후 값 값
   *   :NEW.LAST_MODIFY_BY - 신규/변경 후 값 값
   *   :NEW.ENTER_BY - 신규/변경 후 값 값
   *   :NEW.MOLD_VERSION - 신규/변경 후 값 값
   *   :NEW.MOLD_SET_SERIAL - 신규/변경 후 시리얼 관련 값
   *   :NEW.ACTUAL_VALUE - 신규/변경 후 값 값
   *   :OLD.LOCATION_CODE - 변경/삭제 전 값 값
   *   :OLD.ORGANIZATION_ID - 변경/삭제 전 값 값
   *   :OLD.MOLD_CODE - 변경/삭제 전 값 값
   *   :OLD.MOLD_VERSION - 변경/삭제 전 값 값
   *   :OLD.MOLD_SET_SERIAL - 변경/삭제 전 시리얼 관련 값
   *   :OLD.LAST_ADJUST_DATE - 변경/삭제 전 일자 관련 값
   *   :OLD.ACTUAL_VALUE - 변경/삭제 전 값 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IMCN_MOLD_INVENTORY - 재고 관련 트리거 대상 테이블
   *   IMCN_MOLD_LOCATION - 업무 데이터 트리거 내부 SQL에서 참조/변경
   *   IMCN_MOLD_REPAIR - 업무 데이터 트리거 내부 SQL에서 참조/변경
   *   IMCN_MOLD_SHORT_HISTORY - 이력 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 6회 / 반복문: 0회
   *   DML: INSERT 2회, UPDATE 3회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_IMCN_MOLD_INVENTORY_UPD';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_IMCN_MOLD_INVENTORY_UPD';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_IMCN_MOLD_INVENTORY_UPD" 
 BEFORE
   UPDATE OF actual_value, location_code, last_adjust_date
 ON imcn_mold_inventory
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
BEGIN
   IF :OLD.location_code <> :NEW.location_code
   THEN
      UPDATE imcn_mold_location
         SET mold_code = NULL,
             mold_version = NULL,
             mold_set_serial = NULL,
             mold_location_status = 'O'
       WHERE mold_location_code = :OLD.location_code
         AND organization_id = :OLD.organization_id;

      UPDATE imcn_mold_location
         SET mold_code = :OLD.mold_code,
             mold_version = :OLD.mold_version,
             mold_set_serial = :OLD.mold_set_serial,
             mold_location_status = 'I'
       WHERE mold_location_code = :NEW.location_code
         AND organization_id = :OLD.organization_id;
   END IF;

   -- ONLY MASK
   IF NVL (:OLD.last_adjust_date, SYSDATE) <> :NEW.last_adjust_date
   THEN
      INSERT INTO imcn_mold_repair
                  (mold_code,
                   repair_sequence,
                   organization_id,
                   repair_request_date,
                   repair_reason_code,
                   repair_vendor_code,
                   repair_status,
                   repair_by,
                   repair_date,
                   repair_qty,
                   repair_amt,
                   currency,
                   comments,
                   enter_by,
                   enter_date,
                   last_modify_by,
                   last_modify_date,
                   mold_version,
                   mold_set_serial,
                   repair_time,
                   repair_comments
                  )
           VALUES (:NEW.mold_code,
                   seq_mold_repair_sequence.NEXTVAL,       -- REPAIR_SEQUENCE,
                   :NEW.organization_id,
                   :NEW.last_adjust_date,              -- REPAIR_REQUEST_DATE,
                   'MJ31',                      --REPAIR_REASON_CODE, --ADJUST
                   '*',                                  --REPAIR_VENDOR_CODE,
                   'C',                            --REPAIR_STATUS, --COMPLETE
                   :NEW.last_modify_by,                          -- REPAIR_BY,
                   :NEW.last_adjust_date,                      -- REPAIR_DATE,
                   1,                                            --REPAIR_QTY,
                   0,                                            --REPAIR_AMT,
                   'CNY',                                         -- CURRENCY,
                   '',                                            -- COMMENTS,
                   :NEW.enter_by,
                   SYSDATE,                                     -- ENTER_DATE,
                   :NEW.last_modify_by,
                   SYSDATE,                                --LAST_MODIFY_DATE,
                   :NEW.mold_version,
                   :NEW.mold_set_serial,
                   0,                                           --REPAIR_TIME,
                   ''                                        --REPAIR_COMMENTS
                  );
   END IF;

   IF :NEW.actual_value IS NULL OR :NEW.actual_value = 0
   THEN
      NULL;
   ELSE
      INSERT INTO imcn_mold_short_history
                  (mold_code,
                   product_date,
                   short_qty,
                   organization_id,
                   enter_by,
                   enter_date,
                   last_modify_by,
                   last_modify_date,
                   mold_version,
                   mold_set_serial,
                   product_type,
                   delete_protect_yn
                  )
           VALUES (:NEW.mold_code,
                   TRUNC (SYSDATE),                            --PRODUCT_DATE,
                   :NEW.actual_value - NVL (:OLD.actual_value, 0),
                                                                  --SHORT_QTY,
                   :NEW.organization_id,
                   :NEW.enter_by,                                  --ENTER_BY,
                   SYSDATE,                                      --ENTER_DATE,
                   :NEW.last_modify_by,                      --LAST_MODIFY_BY,
                   SYSDATE,                                --LAST_MODIFY_DATE,
                   :NEW.mold_version,
                   :NEW.mold_set_serial,
                   'M',                                        --PRODUCT_TYPE,
                   'Y'                                     --DELETE_PROTECT_YN
                  );
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;
