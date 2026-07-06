CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRGIP_PRODUCT_SENSOR_ACT_UPD
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IP_PRODUCT_SENSOR_ACTUAL 테이블의 UPDATE 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: AFTER
   *   이벤트: UPDATE
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IP_PRODUCT_SENSOR_ACTUAL - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.ADJUST_QTY - 신규/변경 후 수량 관련 값
   *   :NEW.LINE_CODE - 신규/변경 후 라인 관련 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_SENSOR_ACTUAL - 제품 관련 트리거 대상 테이블
   *   IB_PRODUCT_PLANDATA - 제품 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_CARRIER_SIZE_BY_SMT - 트리거 내부 업무 처리 호출
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 1회, UPDATE 4회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRGIP_PRODUCT_SENSOR_ACT_UPD';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRGIP_PRODUCT_SENSOR_ACT_UPD';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRGIP_PRODUCT_SENSOR_ACT_UPD" 
   after UPDATE
   OF ADJUST_QTY
   ON IP_PRODUCT_SENSOR_ACTUAL    REFERENCING NEW AS New OLD AS Old
   FOR EACH ROW
DECLARE
 
   LVDT_DATE   DATE;
BEGIN

-----------------------------------------------------------
--
-----------------------------------------------------------
  

   UPDATE ib_product_plandata
      SET product_actual_qty =  NVL( :new.adjust_qty ,0) * ( (NVL (item_unit_qty, 0) / NVL (F_GET_CARRIER_SIZE_BY_SMT (smt_model_name, 1), 1) ) * 1)
    WHERE     line_code = SUBSTR ( :new.line_code, 1, 2)
       --  AND model_name = :old.model_name
          AND active_yn = 'Y';
 
-----------------------------------------------------------
--
-----------------------------------------------------------
--   LVDT_DATE := SYSDATE;
--
--   UPDATE IP_PRODUCT_LINE
--      SET REAL_ST =
--             TRUNC ( (SYSDATE - :OLD.LAST_RECEIPT_DATE) * 24 * 60 * 60, 2),
--          LAST_MODIFY_BY = 'SENSOR ACT U-TRG'
--    WHERE LINE_CODE = SUBSTR (:NEW.LINE_CODE, 1, 2);



--   BEGIN
--      UPDATE IP_PRODUCT_MODEL_ST_MASTER
--         SET ASSY_ST =
--                TRUNC ( (SYSDATE - :OLD.LAST_RECEIPT_DATE) * 24 * 60 * 60, 2),
--             LAST_MODIFY_DATE = SYSDATE,
--             ENTER_BY = 'SENSOR ACT U-TRG'
--       WHERE (LINE_CODE, MODEL_NAME, PCB_ITEM) =
--                (SELECT DISTINCT LINE_CODE, MODEL_NAME, PCB_ITEM
--                   FROM IB_PRODUCT_PLANDATA
--                  WHERE LINE_CODE = SUBSTR (:NEW.LINE_CODE, 1, 2)
--                        AND ACTIVE_YN = 'Y');
--
--      :NEW.LAST_RECEIPT_DATE := LVDT_DATE;
--
--   EXCEPTION
--      WHEN OTHERS
--      THEN
--         NULL;
--   END;
EXCEPTION
   WHEN OTHERS
   THEN
      NULL;
END;
