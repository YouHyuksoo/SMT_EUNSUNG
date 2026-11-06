CREATE OR REPLACE TRIGGER TRG_IP_PRODUCT_WS_IO_WIP_MOVE
  /* ================================================================
   * 트리거명 : TRG_IP_PRODUCT_WS_IO_WIP_MOVE
   * 작성일   : 2026-10-18
   * 수정이력:
   *   2026-10-18 - AI(Claude) - 후공정에서 매거진을 스캔(공정 IO 투입 행)하면 반제품 공정재고를 그 공정으로 옮긴다
   * ================================================================
   * 기능 설명:
   *   IP_PRODUCT_WORKSTAGE_IO 에 투입(IO_DEFICIT = 'I') 행이 SMT(W180)가 아닌 공정으로 들어오면
   *   P_WIP_MOVE_BY_MAGAZINE 으로 공정간 이동을 만든다 (PDA·웹 같은 경로).
   *   - 스캔을 절대 막지 않는다: 자율 트랜잭션에서 처리하고, 실패하면 오류 로그
   *     (ISYS_BATCHJOBERRLOG, WIP_MOVE / NG)만 남긴다. 놓친 스캔은 매일 07:45 잡(P_WIP_MOVE_FROM_WS_IO(48))이 채운다.
   *   - 매거진 라벨이 아니거나 전환 전 매거진·이미 옮긴 것은 조용히 건너뛴다.
   *   설계: docs/specs/2026-10-17-wip-semi-product-from-aoi-design.md (5-5)
   * ================================================================ */
  AFTER INSERT ON IP_PRODUCT_WORKSTAGE_IO
  FOR EACH ROW
  WHEN (NEW.IO_DEFICIT = 'I' AND NEW.WORKSTAGE_CODE <> 'W180' AND NEW.SERIAL_NO IS NOT NULL AND NEW.ORGANIZATION_ID = 1)
DECLARE
   PROCEDURE move_autonomous IS
      PRAGMA AUTONOMOUS_TRANSACTION;
      v_result VARCHAR2(200);
      v_msg    VARCHAR2(200);
   BEGIN
      P_WIP_MOVE_BY_MAGAZINE(TRIM(:NEW.SERIAL_NO), :NEW.WORKSTAGE_CODE, :NEW.IO_QTY, NVL(:NEW.IO_DATE, SYSDATE),
                             :NEW.LINE_CODE, :NEW.IO_DATE, :NEW.IO_SEQUENCE, :NEW.ENTER_BY, v_result);
      COMMIT;
   EXCEPTION
      WHEN OTHERS THEN
         v_msg := SUBSTR('LABEL ' || :NEW.SERIAL_NO || ' WS ' || :NEW.WORKSTAGE_CODE || ' : ' || SQLERRM, 1, 200);
         ROLLBACK;
         BEGIN
            INSERT INTO ISYS_BATCHJOBERRLOG (BATCH_JOB_SEQ, ORGANIZATION_ID, BATCH_JOB_PROCESS_NAME, BATCH_JOB_OBJECT_NAME,
                                             BATCH_JOB_STATUS_CODE, BATCH_JOB_REMARK, ENTER_BY, LOG_DATE)
            VALUES (NULL, 1, 'WIP_MOVE', 'TRG_IP_PRODUCT_WS_IO_WIP_MOVE', 'NG', v_msg, 'TRIGGER', SYSDATE);
            COMMIT;
         EXCEPTION WHEN OTHERS THEN ROLLBACK;
         END;
   END move_autonomous;
BEGIN
   move_autonomous;
EXCEPTION
   WHEN OTHERS THEN NULL;   -- 스캔은 어떤 경우에도 막지 않는다
END TRG_IP_PRODUCT_WS_IO_WIP_MOVE;
/
