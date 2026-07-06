CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_IQ_INTERLOCK_CHECK_RESULT
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IQ_INTERLOCK_CHECK_RESULT 테이블의 INSERT 발생 시 생산/검사 실적 관련 값을 자동 보정하거나 이력을 갱신한다.
   *   제품 실적, 검사 결과, 공정 흐름의 데이터 정합성을 유지하기 위한 트리거로 추정된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IQ_INTERLOCK_CHECK_RESULT - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.IS_LAST_YN - 신규/변경 후 값 값
   *   :NEW.SERIAL_NO - 신규/변경 후 시리얼 관련 값
   *   :NEW.RECEIPT_DATE - 신규/변경 후 입고 / 일자 관련 값
   *   :NEW.MACHINE_CODE - 신규/변경 후 설비 관련 값
   *   :NEW.LINE_CODE - 신규/변경 후 라인 관련 값
   *   :NEW.PCB_ITEM - 신규/변경 후 PCB / 품목 관련 값
   *   :NEW.ORGANIZATION_ID - 신규/변경 후 값 값
   *   :NEW.WORKSTAGE_CODE - 신규/변경 후 공정 관련 값
   *   :NEW.ITEM_CODE - 신규/변경 후 품목 관련 값
   *   :NEW.MODEL_NAME - 신규/변경 후 모델 / 명칭 관련 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IB_PRODUCT_PLANDATA - 제품 관련 트리거 내부 SQL에서 참조/변경
   *   IQ_INTERLOCK_CHECK_RESULT - 인터락 / 실적 관련 트리거 대상 테이블
   *   IP_PROD_MATERIAL_TRACKING_KFC - 자재 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_WORKSTAGE_TYPE - 트리거 내부 업무 처리 호출
   *   F_GET_VENDOR_FROM_BARCODE - 트리거 내부 업무 처리 호출
   *   F_GET_LOT_QTY_FROM_BARCODE - 트리거 내부 업무 처리 호출
   *   F_GET_PREPARE_BARCODE - 트리거 내부 업무 처리 호출
   *   F_GET_TRACE_NO_FROM_BARCODE - 트리거 내부 업무 처리 호출
   *   F_GET_INSPECT_FROM_BARCODE - 트리거 내부 업무 처리 호출
   *   F_GET_VALID_DATE_FROM_BARCODE - 트리거 내부 업무 처리 호출
   *   F_GET_ITEMNAME_FROM_BARCODE - 트리거 내부 업무 처리 호출
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 6회, ELSIF 4회 / 반복문: 0회
   *   DML: SELECT 2회, INSERT 3회, UPDATE 2회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_IQ_INTERLOCK_CHECK_RESULT';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_IQ_INTERLOCK_CHECK_RESULT';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_IQ_INTERLOCK_CHECK_RESULT" 
   BEFORE INSERT
   ON IQ_INTERLOCK_CHECK_RESULT    REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   lvi_exists       NUMBER;
   PHASE            VARCHAR2 (10);
   LVI_EXISTS_SUM   NUMBER;
   LVI_OK           NUMBER;
   LVI_NG           NUMBER;
   LVI_PASS         NUMBER;
-- pragma autonomous_transaction;

BEGIN
   ----------------------------------------------------------
   --
   ----------------------------------------------------------
   :new.is_last_yn := 'Y';
   PHASE := '10';

   UPDATE iq_interlock_check_result
      SET is_last_yn = 'N'
    WHERE     serial_no = :new.serial_no
          AND receipt_date < :new.receipt_date
           AND machine_code = :new.machine_code
          AND line_code = :new.line_code
          AND NVL (pcb_item, '*') = NVL (:new.pcb_item, '*')
          AND organization_id = :new.organization_id;

   PHASE := '20';


--
--   ---------------------------------------------------------------------------
--   -- ？？？？
--   ---------------------------------------------------------------------------
--
--   SELECT COUNT (*)
--     INTO LVI_EXISTS_SUM
--     FROM iq_interlock_check_result_sum
--    WHERE     receipt_date = TRUNC (:new.receipt_date)
--          AND MODEL_NAME = :NEW.MODEL_NAME
--          AND machine_code = :new.machine_code
--          AND line_code = :new.line_code
--          and WORKSTAGE_CODE = :new.WORKSTAGE_CODE
--          AND organization_id = :new.organization_id
--          AND ROWNUM = 1;
--
--
--   IF NVL (LVI_EXISTS_SUM, 0) = 0
--   THEN
--      INSERT
--        INTO IQ_INTERLOCK_CHECK_RESULT_SUM (
--                RECEIPT_DATE,
--                MODEL_NAME,
--                ITEM_CODE,
--                LINE_CODE,
--                WORKSTAGE_CODE,
--                MACHINE_CODE,
--                CHECK_RESULT_OK,
--                CHECK_RESULT_NG,
--                CHECK_RESULT_PASS,
--                ENTER_DATE,
--                ENTER_BY,
--                LAST_MODIFY_DATE,
--                LAST_MODIFY_BY,
--                ORGANIZATION_ID)
--      VALUES (TRUNC (:NEW.RECEIPT_DATE),
--              :NEW.MODEL_NAME,
--              :NEW.ITEM_CODE,
--              :NEW.LINE_CODE,
--              :NEW.WORKSTAGE_CODE,
--              :NEW.MACHINE_CODE,
--              0,                                            --CHECK_RESULT_OK,
--              0,                                            --CHECK_RESULT_NG,
--              0,                                          --CHECK_RESULT_PASS,
--              SYSDATE,
--              'SYSTEM',
--              SYSDATE,
--              'SYSTEM',
--              1);
--   ELSE
--      IF :NEW.CHECK_RESULT = 'OK'
--      THEN
--         LVI_OK := 1;
--         LVI_NG := 0;
--         LVI_PASS := 0;
--      ELSIF :NEW.CHECK_RESULT = 'NG'
--      THEN
--         LVI_OK := 0;
--         LVI_NG := 1;
--         LVI_PASS := 0;
--      ELSIF :NEW.CHECK_RESULT = 'PASS'
--      THEN
--         LVI_OK := 0;
--         LVI_NG := 0;
--         LVI_PASS := 1;
--      ELSE
--         LVI_OK := 1;
--         LVI_NG := 0;
--         LVI_PASS := 0;
--      END IF;
--
--      UPDATE iq_interlock_check_result_sum
--         SET CHECK_RESULT_OK = NVL (CHECK_RESULT_OK, 0) + LVI_OK,
--             CHECK_RESULT_NG = NVL (CHECK_RESULT_NG, 0) + LVI_NG,
--             CHECK_RESULT_PASS = NVL (CHECK_RESULT_PASS, 0) + LVI_PASS,
--             CHECK_COUNT = NVL (CHECK_COUNT, 0) + 1
--       WHERE     receipt_date = TRUNC (:new.receipt_date)
--             AND MODEL_NAME = :NEW.MODEL_NAME
--             AND machine_code = :new.machine_code
--             AND line_code = :new.line_code
--             and WORKSTAGE_CODE = :new.WORKSTAGE_CODE
--             AND organization_id = :new.organization_id;
--   END IF;

   ---------------------------------------------------------------------------
   -- SPI  RESULT
   -- ？？？ ？？？？？ . ？？？？？？ ？？？？ ？？？뷮 ？？？？
   ---------------------------------------------------------------------------

   IF F_GET_WORKSTAGE_TYPE(:new.workstage_code )   = 'SPI'                               -- SPI ,
   THEN
      NULL;
   ELSIF F_GET_WORKSTAGE_TYPE(:new.workstage_code ) = 'ICT'
   THEN
      PHASE := '30';
      NULL;                                                              --ICT
   ---------------------------------------------------------------------------------
   -- ？？？÷ο？ ？？？？ ？o？？？？？ ？？？ ？？？？？？ ？？？？ ？？？ ？？？？ ？？？？？？ ？？？´？.
   -- W050 ？？ ？？？÷ο？ ？？？？
   -- ？？？？？ W230 : LG ？？？？？？？？ ？？？？ ？？？？？？ ？？？？ ？？？？？？
   -- ？？？？？？？？ ？？？+？？？？？？？  ？？？？？？
   ---------------------------------------------------------------------------------
   ELSIF  F_GET_WORKSTAGE_TYPE(:new.workstage_code ) = 'REFLOW'
   THEN
      PHASE := '40';

      INSERT INTO ip_prod_material_tracking_kfc (P_PCB,
                                                 P_KEFILOT,
                                                 P_MATERIAL,
                                                 M_MATERIAL,
                                                 P_PROG,
                                                 P_EQUIP,
                                                 P_PROCESS_TIME,
                                                 P_STATUS,
                                                 MAT_VENDOR,
                                                 SCAN_QTY,
                                                 TRACE_CODE,
                                                 INSPECT_DATE,
                                                 VALID_DATE,
                                                 EMP_CODE,
                                                 ITEM_NAME_IN_BARCODE)
         SELECT :NEW.SERIAL_NO,
                A.LOT_NO,
                :NEW.ITEM_CODE AS P_MATERIAL,
                A.ITEM_CODE AS M_MATERIAL,
                A.LINE_CODE,
                :NEW.MACHINE_CODE,
                :NEW.RECEIPT_DATE,
                A.PCB_ITEM,
                F_GET_VENDOR_FROM_BARCODE (a.our_barcode_origin),
                F_GET_LOT_QTY_FROM_BARCODE (
                   f_get_prepare_barcode (a.our_barcode_origin)),
                --decode( lot_no ,'1603236982', '4000', F_GET_LOT_QTY_FROM_BARCODE (a.our_barcode_origin)),

                F_GET_TRACE_NO_FROM_BARCODE (a.our_barcode_origin),
                TO_DATE (F_GET_INSPECT_FROM_BARCODE (a.our_barcode_origin),
                         'yyyymmdd'),
                TO_DATE (
                   f_get_valid_date_from_barcode (a.our_barcode_origin),
                   'yyyymmdd'),
                'SYSTEM',
                F_GET_ITEMNAME_FROM_BARCODE (a.our_barcode_origin)
           FROM IB_PRODUCT_PLANDATA A
          WHERE A.LINE_CODE = :NEW.LINE_CODE AND A.ACTIVE_YN = 'Y';
   --------------------------------------------------------------------
   --
   --------------------------------------------------------------------
   END IF;
--COMMIT;
EXCEPTION
   WHEN OTHERS
   THEN
      RAISE_APPLICATION_ERROR (
         -20003,
            'PHASE='
         || PHASE
         || ' LINE='
         || :NEW.LINE_CODE ||' MD='||:NEW.MODEL_NAME||' MC='||:NEW.MACHINE_CODE
         || ' '
         || 'WS='
         || :new.workstage_code
         || ' '
         || SQLERRM);

END;
