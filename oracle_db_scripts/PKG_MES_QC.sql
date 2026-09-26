-- PKG_MES_QC — PB 이관 산출물 전용 품질(QC) 패키지
--
-- 기존 전역 FUNCTION/PROCEDURE 와 이름이 충돌하지 않도록
-- 웹 이관으로 생기는 오브젝트는 전부 이 패키지 안에만 만든다.
-- standalone FUNCTION/PROCEDURE 로 만들지 않는다.
--
-- 오브젝트를 추가할 때는 이 파일에 얹어 SPEC/BODY 를 통째로 다시 배포한다.

CREATE OR REPLACE PACKAGE PKG_MES_QC AS

  /**
   * PB w_qc_iqc_master b_ok / b_ng 이관 (2026-09-27) — IQC 판정.
   *
   * 입고전표(RECEIPT_SLIP_NO) 하나를 통째로 판정한다.
   *   1) 그 전표의 바코드 행마다 IQ_ITEM_IQC 검사이력 1건을 만든다.
   *      항번은 SEQ_QC_IQC_INSPECT 로 행마다 따로 채번된다(PB 도 INSERT..SELECT 안에서 NEXTVAL).
   *   2) IM_ITEM_RECEIPT_BARCODE.INSPECT_RESULT 를 판정값으로 바꾼다.
   *   3) IM_ITEM_RECEIPT_SLIP.INSPECT_RESULT 도 같은 값으로 바꾼다.
   *
   * PB 는 목록 필터(INSPECT_RESULT NOT IN ('P','R'))로 재판정을 막았다.
   * 화면이 낡은 목록을 들고 있을 수 있으므로 여기서도 이미 판정된 전표는 -2 로 막는다.
   *
   * p_inspect_result : 'P' 합격 / 'R' 불합격
   * p_result : 만든 검사이력 건수   -1 전표 없음   -2 이미 판정됨   -3 판정값이 P/R 아님
   */
  PROCEDURE SP_IQC_JUDGE(
    p_receipt_slip_no IN  VARCHAR2,
    p_inspect_result  IN  VARCHAR2,
    p_bad_reason_code IN  VARCHAR2,
    p_organization_id IN  NUMBER,
    p_user_id         IN  VARCHAR2,
    p_result          OUT NUMBER
  );

  /**
   * PB w_qc_iqc_master b_cancel 이관 — IQC 판정취소.
   *
   * 검사이력(IQ_ITEM_IQC)은 지우지 않는다 — PB 도 DELETE 를 주석 처리해 두고 이력을 남긴다.
   * 바코드·전표의 판정값만 대기('W')로 되돌린다.
   *
   * PB 조건 유지: 바코드는 판정된 것('P','R') 중 입고대조 전('RECEIPT_COMPARE_YN' = 'N')만 되돌린다.
   * 이미 입고대조가 끝난 바코드는 되돌리지 않는다.
   *
   * p_result : 되돌린 바코드 건수   -1 전표 없음
   */
  PROCEDURE SP_IQC_JUDGE_CANCEL(
    p_receipt_slip_no IN  VARCHAR2,
    p_organization_id IN  NUMBER,
    p_user_id         IN  VARCHAR2,
    p_result          OUT NUMBER
  );

  /**
   * PB w_qc_iqc_master b_esd_check 이관 — ESD 점검 완료 처리.
   *
   * 공급처·품목의 ESD 점검주기 카운터(IM_ITEM_MASTER.ESD_CHECK_CYCLE_VALUE)를 0 으로 되돌린다.
   * PB 는 이 값이 10 이면 IQC 합격 판정을 막았다 — 그 검사는 SP_IQC_JUDGE 가 아니라
   * 화면·서비스 쪽에서 한다(PB 도 화면에서 막았다).
   *
   * p_result : 되돌린 건수   -1 대상 없음
   */
  PROCEDURE SP_IQC_ESD_CHECK_DONE(
    p_supplier_code   IN  VARCHAR2,
    p_item_code       IN  VARCHAR2,
    p_organization_id IN  NUMBER,
    p_user_id         IN  VARCHAR2,
    p_result          OUT NUMBER
  );

END PKG_MES_QC;
/

CREATE OR REPLACE PACKAGE BODY PKG_MES_QC AS

  /** PB w_qc_iqc_master b_ok / b_ng 이관 — 상세는 SPEC 주석 참조 */
  PROCEDURE SP_IQC_JUDGE(
    p_receipt_slip_no IN  VARCHAR2,
    p_inspect_result  IN  VARCHAR2,
    p_bad_reason_code IN  VARCHAR2,
    p_organization_id IN  NUMBER,
    p_user_id         IN  VARCHAR2,
    p_result          OUT NUMBER
  ) IS
    l_total   NUMBER;
    l_pending NUMBER;
  BEGIN
    IF p_inspect_result NOT IN ('P', 'R') THEN
      p_result := -3;
      RETURN;
    END IF;

    SELECT COUNT(*),
           COUNT(CASE WHEN NVL(INSPECT_RESULT, 'N') NOT IN ('P', 'R') THEN 1 END)
      INTO l_total, l_pending
      FROM IM_ITEM_RECEIPT_BARCODE
     WHERE RECEIPT_SLIP_NO = p_receipt_slip_no
       AND ORGANIZATION_ID = p_organization_id;

    IF l_total = 0 THEN
      p_result := -1;   -- 그 전표의 바코드가 없다
      RETURN;
    END IF;
    IF l_pending = 0 THEN
      p_result := -2;   -- 전부 이미 판정됐다 (낡은 목록으로 두 번 누른 경우)
      RETURN;
    END IF;

    INSERT INTO IQ_ITEM_IQC (
      INSPECT_DATE, INSPECT_SEQUENCE, ORGANIZATION_ID, IQC_INSPECT_NO,
      DESTROY_QTY, SUPPLIER_CODE, MFS, ARRIVAL_QTY,
      INSPECT_LOT_QTY, INSPECT_BAD_LOT_QTY, INSPECT_QTY, INSPECT_BAD_QTY,
      INSPECT_RESULT, PRODUCT_DATE, DEPARTURE_DATE, ARRIVAL_DATE,
      INSPECT_BY, IQC_IMPROVE_NO, ARRIVAL_SEQ_NO, ENTER_DATE,
      DESTROY_REASON_CODE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY,
      ITEM_CODE, COMMENTS, INSPECT_METHOD, BAD_REASON_CODE
    )
    SELECT SYSDATE, SEQ_QC_IQC_INSPECT.NEXTVAL, ORGANIZATION_ID, RECEIPT_SLIP_NO,
           0, SUPPLIER_CODE, ORIGIN_LOT_NO, SCAN_QTY,
           SCAN_QTY, 0, 0, 0,
           p_inspect_result, NULL, SYSDATE, SYSDATE,
           p_user_id, NULL, NULL, SYSDATE,
           '*', p_user_id, SYSDATE, p_user_id,
           ITEM_CODE, COMMENTS, NULL, p_bad_reason_code
      FROM IM_ITEM_RECEIPT_BARCODE
     WHERE RECEIPT_SLIP_NO = p_receipt_slip_no
       AND ORGANIZATION_ID = p_organization_id;

    p_result := SQL%ROWCOUNT;

    UPDATE IM_ITEM_RECEIPT_BARCODE
       SET INSPECT_RESULT   = p_inspect_result,
           LAST_MODIFY_BY   = p_user_id,
           LAST_MODIFY_DATE = SYSDATE
     WHERE RECEIPT_SLIP_NO = p_receipt_slip_no
       AND ORGANIZATION_ID = p_organization_id;

    UPDATE IM_ITEM_RECEIPT_SLIP
       SET INSPECT_RESULT   = p_inspect_result,
           LAST_MODIFY_BY   = p_user_id,
           LAST_MODIFY_DATE = SYSDATE
     WHERE RECEIPT_SLIP_NO = p_receipt_slip_no
       AND ORGANIZATION_ID = p_organization_id;
  END SP_IQC_JUDGE;

  /** PB w_qc_iqc_master b_cancel 이관 — 상세는 SPEC 주석 참조 */
  PROCEDURE SP_IQC_JUDGE_CANCEL(
    p_receipt_slip_no IN  VARCHAR2,
    p_organization_id IN  NUMBER,
    p_user_id         IN  VARCHAR2,
    p_result          OUT NUMBER
  ) IS
    l_total NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_total
      FROM IM_ITEM_RECEIPT_BARCODE
     WHERE RECEIPT_SLIP_NO = p_receipt_slip_no
       AND ORGANIZATION_ID = p_organization_id;

    IF l_total = 0 THEN
      p_result := -1;
      RETURN;
    END IF;

    -- PB 조건 그대로: 판정된 것 중 입고대조 전인 바코드만 되돌린다
    UPDATE IM_ITEM_RECEIPT_BARCODE
       SET INSPECT_RESULT   = 'W',
           LAST_MODIFY_BY   = p_user_id,
           LAST_MODIFY_DATE = SYSDATE
     WHERE RECEIPT_SLIP_NO = p_receipt_slip_no
       AND ORGANIZATION_ID = p_organization_id
       AND INSPECT_RESULT IN ('P', 'R')
       AND RECEIPT_COMPARE_YN = 'N';

    p_result := SQL%ROWCOUNT;

    UPDATE IM_ITEM_RECEIPT_SLIP
       SET INSPECT_RESULT   = 'W',
           LAST_MODIFY_BY   = p_user_id,
           LAST_MODIFY_DATE = SYSDATE
     WHERE RECEIPT_SLIP_NO = p_receipt_slip_no
       AND ORGANIZATION_ID = p_organization_id;
  END SP_IQC_JUDGE_CANCEL;

  /** PB w_qc_iqc_master b_esd_check 이관 — 상세는 SPEC 주석 참조 */
  PROCEDURE SP_IQC_ESD_CHECK_DONE(
    p_supplier_code   IN  VARCHAR2,
    p_item_code       IN  VARCHAR2,
    p_organization_id IN  NUMBER,
    p_user_id         IN  VARCHAR2,
    p_result          OUT NUMBER
  ) IS
  BEGIN
    UPDATE IM_ITEM_MASTER
       SET ESD_CHECK_CYCLE_VALUE = 0,
           LAST_MODIFY_BY        = p_user_id,
           LAST_MODIFY_DATE      = SYSDATE
     WHERE SUPPLIER_CODE = p_supplier_code
       AND ITEM_CODE = p_item_code
       AND ORGANIZATION_ID = p_organization_id;

    p_result := SQL%ROWCOUNT;
    IF p_result = 0 THEN
      p_result := -1;
    END IF;
  END SP_IQC_ESD_CHECK_DONE;

END PKG_MES_QC;
/
