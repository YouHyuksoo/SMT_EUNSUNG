CREATE OR REPLACE PROCEDURE P_ASSY_RESULT_ADD_PID (
   p_pid           IN VARCHAR2,
   p_run_no        IN VARCHAR2,
   p_line_code     IN VARCHAR2,
   p_inspect_date  IN VARCHAR2,              -- AOI INSPECT_DATE ('YYYY/MM/DD HH24:MI:SS')
   p_added         OUT NUMBER                -- 1 = 조립실적에 더함, 0 = 건너뜀
)
  /* ================================================================
   * 프로시저명 : P_ASSY_RESULT_ADD_PID
   * 작성일     : 2026-10-17
   * 수정이력:
   *   2026-10-17 - AI(Claude) - AOI 양품 PID 하나를 조립실적에 더한다 (실시간 트리거·보정 잡 공용)
   *   2026-10-17 - AI(Claude) - 조립실적·공정재고 처리를 P_ASSY_RESULT_ADD 로 옮겼다. PID 1개 수량 = 모델 마스터
   *                             PCB_TOTAL_QTY (어레이 판 하나에 PID 하나가 붙는 모델, 예: SM100·SM110 = 42)
   * ================================================================
   * 기능 설명:
   *   - 같은 PID·면은 한 번만 센다 (IP_ASSEMBLY_RESULT_PID, PK PID·면·조직).
   *   - 수량 = NVL(PCB_TOTAL_QTY, 1). 조립실적·공정재고는 P_ASSY_RESULT_ADD(p_source = 'AOI') 가 처리한다.
   *   - 양품 판정은 부르는 쪽이 한다. COMMIT 하지 않는다.
   * ================================================================ */
IS
   v_side    VARCHAR2(1);
   v_model   VARCHAR2(100);
   v_qty     NUMBER;
   v_cnt     NUMBER;
   v_item    VARCHAR2(30);
   v_date    DATE;
   v_seq     NUMBER;
   v_result  VARCHAR2(200);
BEGIN
   p_added := 0;
   IF p_pid IS NULL OR p_run_no IS NULL THEN RETURN; END IF;
   BEGIN
      SELECT r.PCB_ITEM, r.MODEL_NAME INTO v_side, v_model
        FROM IP_PRODUCT_RUN_CARD r
       WHERE r.RUN_NO = p_run_no AND r.ORGANIZATION_ID = 1 AND r.PCB_ITEM IN ('T', 'B') AND ROWNUM = 1;
   EXCEPTION WHEN NO_DATA_FOUND THEN RETURN;
   END;
   SELECT COUNT(*) INTO v_cnt FROM IP_ASSEMBLY_RESULT_PID
    WHERE PID = p_pid AND PCB_SIDE = v_side AND ORGANIZATION_ID = 1;
   IF v_cnt > 0 THEN RETURN; END IF;
   SELECT NVL(MAX(NULLIF(PCB_TOTAL_QTY, 0)), 1) INTO v_qty
     FROM IP_PRODUCT_MODEL_MASTER WHERE MODEL_NAME = v_model AND ORGANIZATION_ID = 1;

   P_ASSY_RESULT_ADD(p_run_no, p_line_code, NVL(TO_DATE(p_inspect_date, 'YYYY/MM/DD HH24:MI:SS'), SYSDATE),
                     v_qty, 'AOI', NULL, 'AOI_JOB', v_item, v_date, v_seq, v_result);
   IF v_result <> 'OK' THEN RETURN; END IF;

   INSERT INTO IP_ASSEMBLY_RESULT_PID
          (ORGANIZATION_ID, PID, PCB_SIDE, RUN_NO, LINE_CODE, ITEM_CODE, INSPECT_DATE, PRODUCT_DATE, PRODUCT_SEQUENCE, ENTER_DATE)
   VALUES (1, p_pid, v_side, p_run_no, NVL(p_line_code, '*'), v_item, p_inspect_date, v_date, v_seq, SYSDATE);
   p_added := 1;
END P_ASSY_RESULT_ADD_PID;
