CREATE OR REPLACE PROCEDURE P_ASSY_RESULT_ADD (
   p_run_no        IN  VARCHAR2,
   p_line_code     IN  VARCHAR2,
   p_time          IN  DATE,                 -- 실적 시각 (AOI 검사시각 · 수기 실적 완료시각 · 보정 기준시각)
   p_qty           IN  NUMBER,               -- 수량 (보정·수기 취소는 음수)
   p_source        IN  VARCHAR2,             -- AOI | MANUAL | ADJUST
   p_remark        IN  VARCHAR2,             -- 수기: 작업실적 키, 보정: 사유
   p_user          IN  VARCHAR2,
   p_item_code     OUT VARCHAR2,             -- 생산 품목 (반제품, 원자재만인 제품은 제품 자신)
   p_product_date  OUT DATE,
   p_product_seq   OUT NUMBER,
   p_result        OUT VARCHAR2              -- 'OK' 또는 건너뛴 이유
)
  /* ================================================================
   * 프로시저명 : P_ASSY_RESULT_ADD
   * 작성일     : 2026-10-17
   * 수정이력:
   *   2026-10-17 - AI(Claude) - 조립실적 한 건을 넣고 공정재고를 움직인다 (AOI 실시간 · 수기 작업실적 · 보정 공용)
   *   2026-10-17 - AI(Claude) - TOP = BOTTOM 품목(양면 런, 면마다 한 모델로 셈)이면 공정재고는 면마다 절반만 움직인다
   * ================================================================
   * 기능 설명:
   *   설계: docs/specs/2026-10-17-wip-semi-product-from-aoi-design.md
   *   - 생산 품목: 런카드(RUN_NO) 면(PCB_ITEM T/B)과 모델(MODEL_NAME) → 모델 마스터 TOP_ITEM_CODE / BOTTOM_ITEM_CODE.
   *     생산 품목이 없거나 품목·라인 마스터에 없으면 넣지 않고 p_result 에 이유를 돌려준다 (예외를 던지지 않는다).
   *   - 조립실적 (IP_ASSEMBLY_RESULT):
   *       AOI    : (작업일, 런, 라인, 품목, 시각의 시(時), 시간대 A~J, 소모 여부) 한 행에 수량을 더한다. ENTER_BY = 'AOI_JOB'.
   *       MANUAL : 한 건 한 행. ENTER_BY = 'WORK_RESULT', REMARK = 작업실적 키 (취소는 음수 행).
   *       ADJUST : 한 건 한 행. ENTER_BY = 'ASSY_ADJUST', REMARK = 사유.
   *     TIME_DIVISION = F_GET_WORKTIME_ZONE (센서실적과 같은 A~J 시간대). WORKSTAGE_ISSUE_YN = 소모 여부(Y/N).
   *   - 공정재고 (실적 시각 >= ISYS_CONFIG WIP_DIRECT_CONSUME_FROM 일 때만):
   *       공정입고 생산 품목 +수량, 공정출고 직속 자품목 × 소요량 × 수량.
   *       TOP_ITEM_CODE = BOTTOM_ITEM_CODE 이면 실적은 면마다 다 세고 공정재고 수량은 × 0.5 (두 면을 거쳐 보드 한 장).
   *       자품목이 AOI 로 만들지 않는 반제품(이 모델 TOP·BOTTOM 품목이 아니면서 BOM 아래가 있는 것)이면 한 단계씩 더 펼친다.
   *       자기 BOM 이 따로 있는 말단 품목(자체 생산 반제품)은 빼지 않는다 (P_WIP_ISSUE_CREATE 와 같다).
   *       AOI    : 시간대·품목별 한 행에 더한다 (ENTER_BY = 'AOI_RT', 구분 1·3).
   *       MANUAL : 건별 행 (ENTER_BY = 'ASSY_MANUAL'), ADJUST : 건별 행 (ENTER_BY = 'ASSY_ADJ').
   *                수량 부호에 따라 입고 구분 1/2, 출고 구분 3/4. LAST_MODIFY_BY = 조립실적 키(날짜-순번).
   *   - COMMIT 하지 않는다.
   * ================================================================ */
IS
   c_aoi_ws    CONSTANT VARCHAR2(10) := 'W060';   -- AOI 공정 (IP_PRODUCT_WORKSTAGE)
   v_side      VARCHAR2(1);
   v_model     VARCHAR2(100);
   v_product   VARCHAR2(30);
   v_item      VARCHAR2(30);
   v_top       VARCHAR2(30);
   v_bottom    VARCHAR2(30);
   v_line      VARCHAR2(20);
   v_cnt       NUMBER;
   v_time      DATE := NVL(p_time, SYSDATE);
   v_hour      DATE;
   v_work_date DATE;
   v_slot      VARCHAR2(5);
   v_date      DATE;
   v_seq       NUMBER;
   v_from      VARCHAR2(30);
   v_flag      VARCHAR2(1);
   v_enter_by  VARCHAR2(20);
   v_ws_by     VARCHAR2(20);
   v_key       VARCHAR2(20);
   v_wip_qty   NUMBER;
BEGIN
   p_result := 'OK';
   IF p_run_no IS NULL OR NVL(p_qty, 0) = 0 THEN p_result := '런 또는 수량 없음'; RETURN; END IF;
   IF p_source NOT IN ('AOI', 'MANUAL', 'ADJUST') THEN p_result := '알 수 없는 구분 ' || p_source; RETURN; END IF;

   BEGIN
      SELECT r.PCB_ITEM, r.MODEL_NAME, r.ITEM_CODE INTO v_side, v_model, v_product
        FROM IP_PRODUCT_RUN_CARD r
       WHERE r.RUN_NO = p_run_no AND r.ORGANIZATION_ID = 1 AND r.PCB_ITEM IN ('T', 'B') AND ROWNUM = 1;
   EXCEPTION WHEN NO_DATA_FOUND THEN p_result := 'SMT 런카드(면 T/B) 없음'; RETURN;
   END;
   BEGIN
      SELECT m.TOP_ITEM_CODE, m.BOTTOM_ITEM_CODE INTO v_top, v_bottom
        FROM IP_PRODUCT_MODEL_MASTER m WHERE m.MODEL_NAME = v_model AND m.ORGANIZATION_ID = 1;
   EXCEPTION WHEN NO_DATA_FOUND THEN p_result := '모델 마스터 없음 ' || v_model; RETURN;
   END;
   v_item := CASE v_side WHEN 'T' THEN v_top ELSE v_bottom END;
   IF v_item IS NULL THEN p_result := v_model || ' ' || v_side || '면 생산 품목 미지정'; RETURN; END IF;
   SELECT COUNT(*) INTO v_cnt FROM ID_ITEM WHERE ITEM_CODE = v_item AND ORGANIZATION_ID = 1;
   IF v_cnt = 0 THEN p_result := '품목 마스터에 없음 ' || v_item; RETURN; END IF;
   v_line := NVL(p_line_code, '*');
   SELECT COUNT(*) INTO v_cnt FROM IP_PRODUCT_LINE WHERE LINE_CODE = v_line AND ORGANIZATION_ID = 1;
   IF v_cnt = 0 THEN p_result := '라인 마스터에 없음 ' || v_line; RETURN; END IF;

   v_hour := TRUNC(v_time, 'HH24');
   v_work_date := F_GET_WORK_ACTUAL_DATE(v_time, 'A');
   v_slot := SUBSTR(F_GET_WORKTIME_ZONE(TO_CHAR(v_time, 'YYYYMMDD'), TO_CHAR(v_time, 'HH24MI'), 'ZONE'), 1, 1);
   SELECT MAX(CONFIG_VALUE) INTO v_from FROM ISYS_CONFIG
    WHERE CONFIG_NAME = 'WIP_DIRECT_CONSUME_FROM' AND ORGANIZATION_ID = 1 AND NVL(USE_YN, 'Y') = 'Y';
   v_flag := CASE WHEN v_from IS NOT NULL AND TO_CHAR(v_time, 'YYYY/MM/DD HH24:MI:SS') >= v_from THEN 'Y' ELSE 'N' END;
   v_enter_by := CASE p_source WHEN 'AOI' THEN 'AOI_JOB' WHEN 'MANUAL' THEN 'WORK_RESULT' ELSE 'ASSY_ADJUST' END;

   v_date := NULL;
   IF p_source = 'AOI' THEN
      BEGIN
         SELECT PRODUCT_DATE, PRODUCT_SEQUENCE INTO v_date, v_seq
           FROM IP_ASSEMBLY_RESULT
          WHERE PRODUCT_DATE = v_work_date AND ORGANIZATION_ID = 1
            AND MFS = SUBSTR(p_run_no, 1, 30) AND LINE_CODE = v_line AND ITEM_CODE = v_item
            AND ENTER_BY = 'AOI_JOB' AND WORKSTAGE_ISSUE_YN = v_flag AND NVL(TIME_DIVISION, '#') = NVL(v_slot, '#')
            AND TRUNC(PRODUCT_ACTUAL_TIME, 'HH24') = v_hour AND ROWNUM = 1
            FOR UPDATE;
         UPDATE IP_ASSEMBLY_RESULT
            SET PRODUCT_ACTUAL_QTY = PRODUCT_ACTUAL_QTY + p_qty,
                PRODUCT_START_TIME = LEAST(PRODUCT_START_TIME, TO_CHAR(v_time, 'HH24MI')),
                PRODUCT_END_TIME = GREATEST(PRODUCT_END_TIME, TO_CHAR(v_time, 'HH24MI')),
                PRODUCT_ACTUAL_TIME = GREATEST(PRODUCT_ACTUAL_TIME, v_time),
                LAST_MODIFY_DATE = SYSDATE
          WHERE PRODUCT_DATE = v_date AND PRODUCT_SEQUENCE = v_seq;
      EXCEPTION WHEN NO_DATA_FOUND THEN v_date := NULL;
      END;
   END IF;
   IF v_date IS NULL THEN
      v_date := v_work_date;
      v_seq := SEQ_ASSEMBLY_RESULT_SEQ.NEXTVAL;
      INSERT INTO IP_ASSEMBLY_RESULT
             (PRODUCT_DATE, PRODUCT_SEQUENCE, ORGANIZATION_ID, PRODUCT_LINE_TYPE, LQC_INSPECT_RESULT,
              PLAN_DATE, WORK_DIVISION, OQC_INSPECT_RESULT, PRODUCT_ACTUAL_STATUS, ITEM_CODE, RECEIPT_YN,
              MFS, PRODUCT_ACTUAL_QTY, LINE_CODE, WORKSTAGE_CODE, PRODUCT_START_TIME, PRODUCT_END_TIME,
              PRODUCT_ACTUAL_TIME, SHIFT_CODE, TIME_DIVISION, WORKSTAGE_ISSUE_YN, REMARK,
              ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
      VALUES (v_date, v_seq, 1,
              NVL((SELECT SUBSTR(MAX(i.LINE_TYPE), 1, 1) FROM ID_ITEM i WHERE i.ITEM_CODE = v_item AND i.ORGANIZATION_ID = 1), 'T'),
              'P', v_date, 'P', 'P', 'N', v_item, 'N',
              -- 시작·종료 칼럼은 HH24MI 4자 문자열이다. 실제 일시는 PRODUCT_ACTUAL_TIME
              SUBSTR(p_run_no, 1, 30), p_qty, v_line, c_aoi_ws, TO_CHAR(v_time, 'HH24MI'), TO_CHAR(v_time, 'HH24MI'),
              v_time, SUBSTR(F_GET_WORK_SHIFT_CODE(v_time), 1, 1), v_slot, v_flag, SUBSTR(p_remark, 1, 200),
              SYSDATE, v_enter_by, SYSDATE, SUBSTR(NVL(p_user, v_enter_by), 1, 20));
   END IF;
   p_item_code := v_item;
   p_product_date := v_date;
   p_product_seq := v_seq;

   IF v_flag <> 'Y' THEN RETURN; END IF;
   -- 두 면이 같은 품목이면 면마다 절반 — 보드 한 장이 두 면을 거쳐 1개가 된다
   v_wip_qty := p_qty * CASE WHEN v_top = v_bottom THEN 0.5 ELSE 1 END;

   IF p_source = 'AOI' THEN
      -- 공정입고: 생산 품목 (시간대·품목별 한 행)
      MERGE INTO IM_ITEM_WORKSTAGE_RECEIPT t
      USING (SELECT v_hour d, v_item c FROM DUAL) s
         ON (t.ENTER_BY = 'AOI_RT' AND t.RECEIPT_DATE = s.d AND t.ITEM_CODE = s.c AND t.ORGANIZATION_ID = 1)
       WHEN MATCHED THEN UPDATE SET t.RECEIPT_QTY = t.RECEIPT_QTY + v_wip_qty, t.LAST_MODIFY_DATE = SYSDATE
       WHEN NOT MATCHED THEN INSERT (RECEIPT_DATE, RECEIPT_SEQUENCE, ORGANIZATION_ID, ITEM_CODE, RECEIPT_DEFICIT, RECEIPT_QTY,
                                     ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
                             VALUES (s.d, SEQ_WORKSTAGE_RECEIPT_SEQ.NEXTVAL, 1, s.c, '1', v_wip_qty, SYSDATE, 'AOI_RT', SYSDATE, 'AOI_RT');
      -- 공정출고: 직속 자품목
      MERGE INTO IM_ITEM_WORKSTAGE_ISSUE t
      USING (
         WITH tr (child, qty) AS (
            SELECT b.CHILD_ITEM_CODE, b.ITEM_UNIT_QTY
              FROM ID_ENG_BOM b
             WHERE b.ITEM_CODE = v_product AND b.PARENT_ITEM_CODE = v_item AND b.ORGANIZATION_ID = 1
               AND b.CHILD_ITEM_CODE <> b.PARENT_ITEM_CODE
               AND NVL(b.DATESET, DATE '1900-01-01') <= SYSDATE AND NVL(b.DATEEND, DATE '9999-12-31') >= TRUNC(SYSDATE)
            UNION ALL
            SELECT b.CHILD_ITEM_CODE, tr.qty * b.ITEM_UNIT_QTY
              FROM tr JOIN ID_ENG_BOM b
                ON b.ITEM_CODE = v_product AND b.PARENT_ITEM_CODE = tr.child AND b.ORGANIZATION_ID = 1
               AND b.CHILD_ITEM_CODE <> b.PARENT_ITEM_CODE
               AND NVL(b.DATESET, DATE '1900-01-01') <= SYSDATE AND NVL(b.DATEEND, DATE '9999-12-31') >= TRUNC(SYSDATE)
             WHERE tr.child NOT IN (NVL(v_top, '#'), NVL(v_bottom, '#'))
         )
         SELECT v_hour d, tr.child c, SUM(tr.qty) * v_wip_qty q
           FROM tr
          WHERE tr.child IN (NVL(v_top, '#'), NVL(v_bottom, '#'))
             OR (NOT EXISTS (SELECT 1 FROM ID_ENG_BOM s WHERE s.ITEM_CODE = v_product AND s.PARENT_ITEM_CODE = tr.child
                                                          AND s.ORGANIZATION_ID = 1 AND s.CHILD_ITEM_CODE <> s.PARENT_ITEM_CODE)
                 AND NOT EXISTS (SELECT 1 FROM ID_ENG_BOM m WHERE m.ITEM_CODE = tr.child AND m.ORGANIZATION_ID = 1))
          GROUP BY tr.child
         HAVING SUM(tr.qty) > 0
      ) s
         ON (t.ENTER_BY = 'AOI_RT' AND t.ISSUE_DATE = s.d AND t.ITEM_CODE = s.c AND t.ORGANIZATION_ID = 1)
       WHEN MATCHED THEN UPDATE SET t.ISSUE_QTY = t.ISSUE_QTY + s.q, t.LAST_MODIFY_DATE = SYSDATE
       WHEN NOT MATCHED THEN INSERT (ISSUE_DATE, ISSUE_SEQUENCE, ORGANIZATION_ID, ITEM_CODE, ISSUE_DEFICIT, ISSUE_QTY,
                                     ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
                             VALUES (s.d, SEQ_WORKSTAGE_ISSUE_SEQ.NEXTVAL, 1, s.c, '3', s.q, SYSDATE, 'AOI_RT', SYSDATE, 'AOI_RT');
   ELSE
      -- 수기·보정: 건별 행. 부호에 따라 구분을 바꾼다 (체크 제약: 입고 1 ≥ 0 / 2 ≤ 0, 출고 3 ≥ 0 / 4 ≤ 0)
      v_ws_by := CASE p_source WHEN 'MANUAL' THEN 'ASSY_MANUAL' ELSE 'ASSY_ADJ' END;
      v_key := TO_CHAR(v_date, 'YYYYMMDD') || '-' || v_seq;
      INSERT INTO IM_ITEM_WORKSTAGE_RECEIPT (RECEIPT_DATE, RECEIPT_SEQUENCE, ORGANIZATION_ID, ITEM_CODE, RECEIPT_DEFICIT, RECEIPT_QTY,
                                             ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
      VALUES (v_time, SEQ_WORKSTAGE_RECEIPT_SEQ.NEXTVAL, 1, v_item, CASE WHEN v_wip_qty >= 0 THEN '1' ELSE '2' END, v_wip_qty,
              SYSDATE, v_ws_by, SYSDATE, v_key);
      INSERT INTO IM_ITEM_WORKSTAGE_ISSUE (ISSUE_DATE, ISSUE_SEQUENCE, ORGANIZATION_ID, ITEM_CODE, ISSUE_DEFICIT, ISSUE_QTY,
                                           ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
      SELECT v_time, SEQ_WORKSTAGE_ISSUE_SEQ.NEXTVAL, 1, x.c, CASE WHEN x.q >= 0 THEN '3' ELSE '4' END, x.q,
             SYSDATE, v_ws_by, SYSDATE, v_key
        FROM (
         WITH tr (child, qty) AS (
            SELECT b.CHILD_ITEM_CODE, b.ITEM_UNIT_QTY
              FROM ID_ENG_BOM b
             WHERE b.ITEM_CODE = v_product AND b.PARENT_ITEM_CODE = v_item AND b.ORGANIZATION_ID = 1
               AND b.CHILD_ITEM_CODE <> b.PARENT_ITEM_CODE
               AND NVL(b.DATESET, DATE '1900-01-01') <= SYSDATE AND NVL(b.DATEEND, DATE '9999-12-31') >= TRUNC(SYSDATE)
            UNION ALL
            SELECT b.CHILD_ITEM_CODE, tr.qty * b.ITEM_UNIT_QTY
              FROM tr JOIN ID_ENG_BOM b
                ON b.ITEM_CODE = v_product AND b.PARENT_ITEM_CODE = tr.child AND b.ORGANIZATION_ID = 1
               AND b.CHILD_ITEM_CODE <> b.PARENT_ITEM_CODE
               AND NVL(b.DATESET, DATE '1900-01-01') <= SYSDATE AND NVL(b.DATEEND, DATE '9999-12-31') >= TRUNC(SYSDATE)
             WHERE tr.child NOT IN (NVL(v_top, '#'), NVL(v_bottom, '#'))
         )
         SELECT tr.child c, SUM(tr.qty) * v_wip_qty q
           FROM tr
          WHERE tr.child IN (NVL(v_top, '#'), NVL(v_bottom, '#'))
             OR (NOT EXISTS (SELECT 1 FROM ID_ENG_BOM s WHERE s.ITEM_CODE = v_product AND s.PARENT_ITEM_CODE = tr.child
                                                          AND s.ORGANIZATION_ID = 1 AND s.CHILD_ITEM_CODE <> s.PARENT_ITEM_CODE)
                 AND NOT EXISTS (SELECT 1 FROM ID_ENG_BOM m WHERE m.ITEM_CODE = tr.child AND m.ORGANIZATION_ID = 1))
          GROUP BY tr.child
         HAVING SUM(tr.qty) > 0
        ) x;
   END IF;
END P_ASSY_RESULT_ADD;
