CREATE OR REPLACE PROCEDURE P_WIP_MOVE_FROM_WS_IO (
   p_lookback_hours IN NUMBER DEFAULT 48   -- 이만큼 거슬러 후공정 매거진 스캔을 다시 본다
)
  /* ================================================================
   * 프로시저명 : P_WIP_MOVE_FROM_WS_IO
   * 작성일     : 2026-10-18
   * 수정이력:
   *   2026-10-18 - AI(Claude) - 트리거(TRG_IP_PRODUCT_WS_IO_WIP_MOVE)가 놓친 후공정 매거진 스캔의 공정간 이동을 채운다
   * ================================================================
   * 기능 설명:
   *   최근 p_lookback_hours 시간의 공정 IO 투입 행(W180 제외) 중 아직 이동 기록(IM_ITEM_WS_MOVE)이 없는
   *   매거진 라벨을 스캔 순서대로 P_WIP_MOVE_BY_MAGAZINE 에 넘긴다. 한 건씩 커밋하고, 실패는 오류 로그만 남긴다.
   *   매일 07:45 잡. 끝나면 ISYS_BATCHJOBERRLOG 에 OK 한 줄(후보·옮김 수).
   * ================================================================ */
IS
   v_result VARCHAR2(200);
   v_cand   NUMBER := 0;
   v_moved  NUMBER := 0;
   v_msg    VARCHAR2(200);
BEGIN
   FOR r IN (SELECT w.IO_DATE, w.IO_SEQUENCE, TRIM(w.SERIAL_NO) AS LABEL, w.WORKSTAGE_CODE, w.IO_QTY, w.LINE_CODE, w.ENTER_BY
               FROM IP_PRODUCT_WORKSTAGE_IO w
              WHERE w.IO_DATE >= SYSDATE - NVL(p_lookback_hours, 48) / 24
                AND w.IO_DEFICIT = 'I' AND w.WORKSTAGE_CODE <> 'W180' AND w.SERIAL_NO IS NOT NULL AND w.ORGANIZATION_ID = 1
                AND NOT EXISTS (SELECT 1 FROM IM_ITEM_WS_MOVE m
                                 WHERE m.MAGAZINE_LABEL_NO = TRIM(w.SERIAL_NO) AND m.TO_WORKSTAGE_CODE = w.WORKSTAGE_CODE
                                   AND m.ORGANIZATION_ID = 1)
              ORDER BY w.IO_DATE, w.IO_SEQUENCE)
   LOOP
      v_cand := v_cand + 1;
      BEGIN
         P_WIP_MOVE_BY_MAGAZINE(r.LABEL, r.WORKSTAGE_CODE, r.IO_QTY, r.IO_DATE, r.LINE_CODE, r.IO_DATE, r.IO_SEQUENCE,
                                r.ENTER_BY, v_result);
         IF v_result = 'OK' THEN v_moved := v_moved + 1; END IF;
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            v_msg := SUBSTR('LABEL ' || r.LABEL || ' WS ' || r.WORKSTAGE_CODE || ' : ' || SQLERRM, 1, 200);
            ROLLBACK;
            INSERT INTO ISYS_BATCHJOBERRLOG (BATCH_JOB_SEQ, ORGANIZATION_ID, BATCH_JOB_PROCESS_NAME, BATCH_JOB_OBJECT_NAME,
                                             BATCH_JOB_STATUS_CODE, BATCH_JOB_REMARK, ENTER_BY, LOG_DATE)
            VALUES (NULL, 1, 'WIP_MOVE', 'P_WIP_MOVE_FROM_WS_IO', 'NG', v_msg, 'JOB', SYSDATE);
            COMMIT;
      END;
   END LOOP;
   INSERT INTO ISYS_BATCHJOBERRLOG (BATCH_JOB_SEQ, ORGANIZATION_ID, BATCH_JOB_PROCESS_NAME, BATCH_JOB_OBJECT_NAME,
                                    BATCH_JOB_STATUS_CODE, BATCH_JOB_REMARK, ENTER_BY, LOG_DATE)
   VALUES (NULL, 1, 'WIP_MOVE', 'P_WIP_MOVE_FROM_WS_IO', 'OK',
           '최근 ' || NVL(p_lookback_hours, 48) || '시간 후보 ' || v_cand || ' / 옮김 ' || v_moved, 'JOB', SYSDATE);
   COMMIT;
END P_WIP_MOVE_FROM_WS_IO;
/
