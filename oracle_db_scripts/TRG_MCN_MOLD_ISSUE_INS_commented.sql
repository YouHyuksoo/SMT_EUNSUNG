CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_MCN_MOLD_ISSUE_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IMCN_MOLD_ISSUE 테이블의 INSERT 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IMCN_MOLD_ISSUE - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.MOLD_CODE - 신규/변경 후 값 값
   *   :NEW.MOLD_VERSION - 신규/변경 후 값 값
   *   :NEW.MOLD_SET_SERIAL - 신규/변경 후 시리얼 관련 값
   *   :NEW.ORGANIZATION_ID - 신규/변경 후 값 값
   *   :NEW.ISSUE_QTY - 신규/변경 후 출고 / 수량 관련 값
   *   :NEW.ISSUE_DEFICIT - 신규/변경 후 출고 관련 값
   *   :NEW.MACHINE_CODE - 신규/변경 후 설비 관련 값
   *   :NEW.WORKSTAGE_CODE - 신규/변경 후 공정 관련 값
   *   :NEW.LINE_CODE - 신규/변경 후 라인 관련 값
   *   :NEW.MOLD_ISSUE_ACCOUNT - 신규/변경 후 출고 관련 값
   *   :NEW.LOCATION_CODE - 신규/변경 후 값 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IMCN_MOLD_ISSUE - 출고 관련 트리거 대상 테이블
   *   IMCN_MOLD_INVENTORY - 재고 관련 트리거 내부 SQL에서 참조/변경
   *   IMCN_MACHINE - 설비 관련 트리거 내부 SQL에서 참조/변경
   *   IMCN_MOLD_LOCATION - 업무 데이터 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 6회 / 반복문: 0회
   *   DML: SELECT 1회, INSERT 1회, UPDATE 5회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_MCN_MOLD_ISSUE_INS';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_MCN_MOLD_ISSUE_INS';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_MCN_MOLD_ISSUE_INS" 
 BEFORE
  INSERT
 ON imcn_mold_issue
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvl_cnt                     NUMBER       := 0;
   lvs_currency                VARCHAR2 (3);
   lvs_local_currency          VARCHAR2 (3);
   lvf_exchange_rate           NUMBER       := 0;
   lvf_unit_price              NUMBER       := 0;
   lvs_delivery                VARCHAR (10);
   lvi_count                   NUMBER       := 0;
   lvf_last_dd_avg_price       NUMBER       := 0;
   lvf_last_dd_inventory_qty   NUMBER       := 0;
   lvf_last_dd_inventory_amt   NUMBER       := 0;
   lvf_mm_issue_qty            NUMBER       := 0;
   lvf_mm_issue_amt            NUMBER       := 0;
   lvf_mm_receipt_qty          NUMBER       := 0;
   lvf_mm_receipt_amt          NUMBER       := 0;
   phase                       NUMBER;
BEGIN
   BEGIN
      SELECT COUNT (*)
        INTO lvl_cnt
        FROM imcn_mold_inventory
       WHERE mold_code = :NEW.mold_code
         AND mold_version = :NEW.mold_version
         AND mold_set_serial = :NEW.mold_set_serial
         AND organization_id = :NEW.organization_id
         AND ROWNUM = 1;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvl_cnt := 0;
   END;

   IF lvl_cnt < 1
   THEN
      raise_application_error (-20003,
                                  'Mold Code Not Found in Mold Mastert '
                               || SQLERRM
                              );
   ELSE
      UPDATE imcn_mold_inventory
         SET inventory_qty = NVL (inventory_qty, 0) - :NEW.issue_qty,
             inventory_amt =
                            inventory_amt
                            - (:NEW.issue_qty * inventory_price),
             mold_in_out = DECODE (:NEW.issue_deficit, '3', 'O', 'I'),
             last_issue_date =
                    DECODE (:NEW.issue_deficit,
                            '3', SYSDATE,
                            last_issue_date
                           ),
             last_receipt_date =
                  DECODE (:NEW.issue_deficit,
                          '4', SYSDATE,
                          last_receipt_date
                         ),
             machine_code =
                      DECODE (:NEW.issue_deficit,
                              '3', :NEW.machine_code,
                              NULL
                             ),
             workstage_code =
                    DECODE (:NEW.issue_deficit,
                            '3', :NEW.workstage_code,
                            NULL
                           ),
             line_code = DECODE (:NEW.issue_deficit,
                                 '3', :NEW.line_code,
                                 NULL
                                ),
             mold_use_status = DECODE (:NEW.issue_deficit , '3' , DECODE(:NEW.MOLD_ISSUE_ACCOUNT , 'M010' ,'R','P'),'U') ,--R REPAIR , P PRODUCT
             location_code   = :new.location_code
       WHERE mold_code       = :NEW.mold_code
         AND mold_version    = :NEW.mold_version
         AND mold_set_serial = :NEW.mold_set_serial
         AND organization_id = :NEW.organization_id;

-------------------------------------------------------
-- MACHINE CURRENT MOLD SETUP
-------------------------------------------------------
      IF :NEW.mold_issue_account = 'M001'
      THEN
         UPDATE imcn_machine
            SET mold_code =
                         DECODE (:NEW.issue_deficit,
                                 '3', :NEW.mold_code,
                                 NULL
                                ),
                mold_version =
                      DECODE (:NEW.issue_deficit,
                              '3', :NEW.mold_version,
                              NULL
                             ),
                mold_set_serial =
                   DECODE (:NEW.issue_deficit,
                           '3', :NEW.mold_set_serial,
                           NULL
                          ),
                mold_exists_yn = DECODE (:NEW.issue_deficit, '3', 'Y', 'N')
          WHERE machine_code = :NEW.machine_code
            AND organization_id = :NEW.organization_id;
      END IF;
   END IF;

-------------------------------------------------
-- MOLD LOATION UPDATE
-------------------------------------------------
   IF :NEW.issue_deficit = '3'
   THEN                                                               -- issue
      UPDATE imcn_mold_location
         SET
             --mold_code = null,
             --mold_version = null,
             --mold_set_serial = null,
             mold_location_status = 'O'
       WHERE mold_location_code = :NEW.location_code
         AND organization_id = :NEW.organization_id;
   ELSE
      UPDATE imcn_mold_location
         SET mold_code = :NEW.mold_code,
             mold_version = :NEW.mold_version,
             mold_set_serial = :NEW.mold_set_serial,
             mold_location_status = 'I'
       WHERE mold_location_code = :NEW.location_code
         AND organization_id = :NEW.organization_id;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;
