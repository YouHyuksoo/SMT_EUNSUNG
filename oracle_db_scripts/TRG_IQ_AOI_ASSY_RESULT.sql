CREATE OR REPLACE TRIGGER TRG_IQ_AOI_ASSY_RESULT
  /* ================================================================
   * 트리거명 : TRG_IQ_AOI_ASSY_RESULT
   * 작성일   : 2026-10-17
   * 수정이력:
   *   2026-10-17 - AI(Claude) - AOI 양품을 실시간으로 조립실적에 더한다
   *   2026-10-17 - AI(Claude) - 전환 이후 공정입고·출고도 같은 자율 트랜잭션에서 실시간으로 만든다 (P_ASSY_RESULT_ADD_PID)
   * ================================================================
   * 기능 설명:
   *   AOI 검사 행이 들어오거나 판정·리뷰 결과가 바뀔 때, 최종 판정 NVL(REVIEW_RESULT, RESULT) 가
   *   OK·GOOD·PASS·USEROK 이면 P_ASSY_RESULT_ADD_PID 로 그 PID 를 조립실적에 더한다.
   *   MasterOK/MasterNG(마스터 샘플)는 뺀다.
   *   - 장비 인터페이스가 넣는 테이블이라 AOI 적재를 절대 막지 않는다: 처리는 자율 트랜잭션에서 하고,
   *     실패해도 오류 로그(ISYS_BATCHJOBERRLOG, ASSY_RESULT_FROM_AOI / NG)만 남기고 넘어간다.
   *   - 놓친 PID 는 매일 07:40 보정 잡(P_ASSY_RESULT_FROM_AOI(48))이 채운다.
   *   설계: docs/specs/2026-10-17-wip-semi-product-from-aoi-design.md
   * ================================================================ */
  AFTER INSERT OR UPDATE OF RESULT, REVIEW_RESULT ON IQ_MACHINE_INSPECT_AOI
  FOR EACH ROW
  WHEN (NEW.ORGANIZATION_ID = 1 AND NEW.PID IS NOT NULL AND NEW.RUN_NO IS NOT NULL)
DECLARE
   PROCEDURE add_pid_autonomous IS
      PRAGMA AUTONOMOUS_TRANSACTION;
      v_added NUMBER;
      v_msg   VARCHAR2(200);
   BEGIN
      BEGIN
         P_ASSY_RESULT_ADD_PID(TRIM(:NEW.PID), TRIM(:NEW.RUN_NO), :NEW.LINE_CODE, :NEW.INSPECT_DATE, v_added);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            -- 다른 AOI 행이 같은 시각에 같은 시간대 행(공정입고·출고)이나 같은 PID 를 먼저 만들었다 — 한 번 다시 한다
            ROLLBACK;
            P_ASSY_RESULT_ADD_PID(TRIM(:NEW.PID), TRIM(:NEW.RUN_NO), :NEW.LINE_CODE, :NEW.INSPECT_DATE, v_added);
      END;
      COMMIT;
   EXCEPTION
      WHEN OTHERS THEN
         v_msg := SUBSTR('PID ' || :NEW.PID || ' RUN ' || :NEW.RUN_NO || ' : ' || SQLERRM, 1, 200);
         ROLLBACK;
         BEGIN
            INSERT INTO ISYS_BATCHJOBERRLOG (BATCH_JOB_SEQ, ORGANIZATION_ID, BATCH_JOB_PROCESS_NAME, BATCH_JOB_OBJECT_NAME,
                                             BATCH_JOB_STATUS_CODE, BATCH_JOB_REMARK, ENTER_BY, LOG_DATE)
            VALUES (NULL, 1, 'ASSY_RESULT_FROM_AOI', 'TRG_IQ_AOI_ASSY_RESULT', 'NG', v_msg, 'TRIGGER', SYSDATE);
            COMMIT;
         EXCEPTION WHEN OTHERS THEN ROLLBACK;
         END;
   END add_pid_autonomous;
BEGIN
   IF UPPER(TRIM(NVL(:NEW.REVIEW_RESULT, :NEW.RESULT))) IN ('OK', 'GOOD', 'PASS', 'USEROK')
      AND (:NEW.RESULT IS NULL OR UPPER(TRIM(:NEW.RESULT)) NOT IN ('MASTEROK', 'MASTERNG'))
      AND UPPER(TRIM(:NEW.PID)) <> 'NULL' AND TRIM(:NEW.RUN_NO) <> '*'
   THEN
      add_pid_autonomous;
   END IF;
EXCEPTION
   WHEN OTHERS THEN NULL;   -- AOI 적재는 어떤 경우에도 막지 않는다
END TRG_IQ_AOI_ASSY_RESULT;
