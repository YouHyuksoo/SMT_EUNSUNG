-- =====================================================================
-- 2026-10-02 실시간 백플러시(단일 레벨) + 제품 마감표  (검토용 초안 — 아직 적용 안 함)
--
-- 목적: 생산실적이 생길 때 그 자리에서, 그 단계에서 만든 품목의 "직속 자품목"만 소비한다.
--       월마감(공정·반제품·완제품)은 이 소비·생산 기록을 합치기만 한다. 재료비만 다룬다.
--
-- BOM 구조 실측(최근 3개월 SMT 런카드 품목 113개):
--   제품 → 반제품 1개(+제품 직속 원자재) 39 / 제품 → TOP·BOT 반제품 2개 25 /
--   반제품 안에 반제품(다단) 37 / 반제품 없이 제품 직속 원자재 9 / 예외 6.
--   TOP·BOT 반제품은 제품 아래에 나란히 있다. B면 라인 레이아웃 부품 = BOT 반제품 원자재,
--   T면 라인 레이아웃 부품 = TOP 반제품 원자재 (예: 라인 09 의 28개 부품이 모두 BOT 반제품 자품목).
--
-- 규칙
--   A. SMT 센서 실적 (B면·T면 각각, 라인·시점이 달라도 된다)
--      - 그 라인에 걸린 제품(IP_PRODUCT_LINE.ITEM_CODE) 아래 모든 노드(제품 자신 + 모든 반제품) 중,
--        직속 원자재가 그 라인 활성 레이아웃 부품과 가장 많이 겹치는 노드 = "이번 SMT 가 만든 품목".
--      - 만든 품목은 공정재고로 입고(공정입고 DEFICIT '5').
--      - 그 품목의 직속 자품목만 소비(공정출고 DEFICIT '5'). 하위 반제품은 앞서 SMT 로 만든 것이라
--        공정재고에서 나간다.
--      - 만든 품목은 IM_BACKFLUSH_NODE 에 "SMT 생산 품목"으로 남긴다.
--   B. 완제품 입고 (IP_PRODUCT_FG_RECEIPT, 1 입고 / 2 취소)
--      - 제품 자체가 SMT 생산 품목이면(반제품 없는 구조) 공정재고에서 그 제품 하나를 소비.
--      - 아니면 제품의 직속 자품목을 소비. 자품목 반제품이 SMT 생산 품목이면 공정재고에서,
--        아니면(SMT 실적이 없는 팬텀) 한 단계 더 펼쳐 그 아래를 같은 규칙으로 소비.
--      - 취소(2)는 같은 수량을 반대로 넣는다.
--   D. 공정폐기 (품질 → 공정폐기관리, IP_PRODUCT_WORK_QC 의 QC_INSPECT_HANDLING='D' 등록)
--      - 폐기된 보드가 그때까지 거친 SMT 생산 품목을 공정재고에서 불량으로 뺀다:
--        제품 자체가 SMT 생산 품목이면 그 제품, 아니면 제품 직속 반제품 중 SMT 생산 품목들.
--      - 아직 쓰지 않은 조립 부품은 빼지 않는다.
--   C. 인팩(InFac) 백플러시가 이미 공정재고를 깎는 IP 사급자재(ID_ITEM.SUPPLIER_CODE='IP')는
--      원장에만 남기고(INFAC_YN='Y') 공정출고로 넣지 않는다 — 고객사 재고가 이중으로 줄지 않게.
--
-- 실시간 경로는 큐 한 줄만 적는다(인터락·입고 응답을 늦추지 않게, 실패해도 본 처리는 계속).
-- 전개·소비는 1분 잡(P_BACKFLUSH_PROCESS)이 한다.
-- 되돌리기: 맨 아래 ROLLBACK 절.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. 큐 — 실적 1건 = 1행 (SMT 센서 / 완제품 입고)
-- ---------------------------------------------------------------------
CREATE SEQUENCE SEQ_BACKFLUSH_QUEUE START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IM_BACKFLUSH_QUEUE (
  QUEUE_ID          NUMBER        NOT NULL,
  SOURCE            VARCHAR2(10)  NOT NULL,          -- SMT / FG / SCRAP
  EVENT_DATE        DATE          NOT NULL,
  WORK_DATE         DATE          NOT NULL,          -- 수불 일자 (SMT: 작업일, FG: 입고일)
  LINE_CODE         VARCHAR2(10),
  LAYOUT_MODEL      VARCHAR2(50),                    -- SMT: 피더 레이아웃 모델 (IB_PRODUCT_PLANDATA.MODEL_NAME)
  PCB_SIDE          VARCHAR2(5),                     -- SMT: T / B
  ITEM_CODE         VARCHAR2(30)  NOT NULL,          -- SMT: 라인에 걸린 제품 / FG: 입고 제품
  RUN_NO            VARCHAR2(30),
  BARCODE           VARCHAR2(100),                   -- FG: 입고 바코드
  QTY               NUMBER        NOT NULL,          -- 생산 수량 (FG 취소는 음수)
  STATUS            VARCHAR2(1)   DEFAULT 'N' NOT NULL, -- N 대기 / Y 처리 / E 오류
  ERROR_MESSAGE     VARCHAR2(500),
  PROCESSED_DATE    DATE,
  ORGANIZATION_ID   NUMBER        DEFAULT 1 NOT NULL,
  CONSTRAINT PK_IM_BACKFLUSH_QUEUE PRIMARY KEY (QUEUE_ID)
);
CREATE INDEX IX_IM_BACKFLUSH_QUEUE_STATUS ON IM_BACKFLUSH_QUEUE (STATUS, SOURCE);
COMMENT ON TABLE IM_BACKFLUSH_QUEUE IS '실시간 백플러시 대기열 (SMT 센서 실적·완제품 입고가 1건씩 적음)';

-- ---------------------------------------------------------------------
-- 2. 원장 — 처리 1회 × 품목 = 1행. 생산(P)·소비(C) 모두. 공정 마감의 근거
-- ---------------------------------------------------------------------
CREATE SEQUENCE SEQ_ITEM_BACKFLUSH START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IM_ITEM_BACKFLUSH (
  BACKFLUSH_ID      NUMBER        NOT NULL,
  WORK_DATE         DATE          NOT NULL,
  SOURCE            VARCHAR2(10)  NOT NULL,          -- SMT / FG
  TXN_TYPE          VARCHAR2(1)   NOT NULL,          -- P 생산(공정입고) / C 소비(공정출고)
  LINE_CODE         VARCHAR2(10),
  RUN_NO            VARCHAR2(30),
  TOP_ITEM_CODE     VARCHAR2(30),                    -- 실적 제품
  PARENT_ITEM_CODE  VARCHAR2(30),                    -- 이 소비를 일으킨 생산 품목
  ITEM_CODE         VARCHAR2(30)  NOT NULL,          -- 생산되거나 소비된 품목
  PRODUCE_QTY       NUMBER        NOT NULL,          -- 부모 생산 수량
  UNIT_QTY          NUMBER        NOT NULL,          -- 부모 1개당 (생산 행은 1)
  QTY               NUMBER        NOT NULL,          -- PRODUCE_QTY × UNIT_QTY (취소는 음수)
  INFAC_YN          VARCHAR2(1)   DEFAULT 'N' NOT NULL,
  WS_SEQUENCE       NUMBER,                          -- 넣은 공정입고/공정출고 순번
  QUEUE_FROM        NUMBER,
  QUEUE_TO          NUMBER,
  ORGANIZATION_ID   NUMBER        DEFAULT 1 NOT NULL,
  ENTER_DATE        DATE          DEFAULT SYSDATE NOT NULL,
  CONSTRAINT PK_IM_ITEM_BACKFLUSH PRIMARY KEY (BACKFLUSH_ID)
);
CREATE INDEX IX_IM_ITEM_BACKFLUSH_DATE ON IM_ITEM_BACKFLUSH (WORK_DATE, ITEM_CODE);
COMMENT ON TABLE IM_ITEM_BACKFLUSH IS '실시간 백플러시 원장 — 생산(P)·소비(C), 재료비 마감 근거';

-- SMT 에서 생산된 적이 있는 품목 (완제품 입고 때 공정재고에서 빼는지, 펼치는지 판단)
CREATE TABLE IM_BACKFLUSH_NODE (
  ITEM_CODE         VARCHAR2(30)  NOT NULL,
  TOP_ITEM_CODE     VARCHAR2(30),
  PCB_SIDE          VARCHAR2(5),
  FIRST_DATE        DATE          NOT NULL,
  LAST_DATE         DATE          NOT NULL,
  ORGANIZATION_ID   NUMBER        DEFAULT 1 NOT NULL,
  CONSTRAINT PK_IM_BACKFLUSH_NODE PRIMARY KEY (ITEM_CODE, ORGANIZATION_ID)
);

-- ---------------------------------------------------------------------
-- 3. 처리 패키지
-- ---------------------------------------------------------------------
CREATE OR REPLACE PACKAGE PKG_BACKFLUSH AS
  PROCEDURE PROCESS_QUEUE;
END PKG_BACKFLUSH;
/

CREATE OR REPLACE PACKAGE BODY PKG_BACKFLUSH AS

  -- 공정입고(P) 또는 공정출고(C) 한 줄 + 원장 한 줄
  PROCEDURE POST(p_work_date DATE, p_source VARCHAR2, p_txn VARCHAR2, p_line VARCHAR2, p_run VARCHAR2,
                 p_top VARCHAR2, p_parent VARCHAR2, p_item VARCHAR2, p_produce NUMBER, p_unit NUMBER,
                 p_qfrom NUMBER, p_qto NUMBER, p_org NUMBER) IS
    v_infac VARCHAR2(1) := 'N';
    v_seq   NUMBER;
    v_qty   NUMBER := p_produce * p_unit;
  BEGIN
    IF v_qty = 0 THEN RETURN; END IF;
    IF p_txn = 'C' THEN
      SELECT CASE WHEN MAX(SUPPLIER_CODE) = 'IP' THEN 'Y' ELSE 'N' END INTO v_infac
        FROM ID_ITEM WHERE ITEM_CODE = p_item AND ORGANIZATION_ID = p_org;
    END IF;
    IF v_infac = 'N' THEN
      IF p_txn = 'P' THEN
        v_seq := SEQ_WORKSTAGE_RECEIPT_SEQ.NEXTVAL;
        INSERT INTO IM_ITEM_WORKSTAGE_RECEIPT
          (RECEIPT_DATE, RECEIPT_SEQUENCE, ORGANIZATION_ID, ITEM_CODE, RECEIPT_DEFICIT, RECEIPT_QTY,
           ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
        VALUES (p_work_date, v_seq, p_org, p_item, '5', v_qty, SYSDATE, 'BACKFLUSH', SYSDATE, SUBSTR(p_top, 1, 20));
      ELSE
        v_seq := SEQ_WORKSTAGE_ISSUE_SEQ.NEXTVAL;
        INSERT INTO IM_ITEM_WORKSTAGE_ISSUE
          (ISSUE_DATE, ISSUE_SEQUENCE, ORGANIZATION_ID, ITEM_CODE, ISSUE_DEFICIT, ISSUE_QTY,
           ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
        VALUES (p_work_date, v_seq, p_org, p_item, '5', v_qty, SYSDATE, 'BACKFLUSH', SYSDATE, SUBSTR(p_top, 1, 20));
      END IF;
    END IF;
    INSERT INTO IM_ITEM_BACKFLUSH
      (BACKFLUSH_ID, WORK_DATE, SOURCE, TXN_TYPE, LINE_CODE, RUN_NO, TOP_ITEM_CODE, PARENT_ITEM_CODE,
       ITEM_CODE, PRODUCE_QTY, UNIT_QTY, QTY, INFAC_YN, WS_SEQUENCE, QUEUE_FROM, QUEUE_TO, ORGANIZATION_ID)
    VALUES (SEQ_ITEM_BACKFLUSH.NEXTVAL, p_work_date, p_source, p_txn, p_line, p_run, p_top, p_parent,
            p_item, p_produce, p_unit, v_qty, v_infac, v_seq, p_qfrom, p_qto, p_org);
  END POST;

  FUNCTION IS_SMT_NODE(p_item VARCHAR2, p_org NUMBER) RETURN BOOLEAN IS
    v_n NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_n FROM IM_BACKFLUSH_NODE WHERE ITEM_CODE = p_item AND ORGANIZATION_ID = p_org;
    RETURN v_n > 0;
  END IS_SMT_NODE;

  -- 품목 p_parent 를 p_qty 만큼 만들 때 직속 자품목 소비. 팬텀 반제품(SMT 생산 이력 없음)은 펼친다.
  PROCEDURE CONSUME_CHILDREN(p_work_date DATE, p_source VARCHAR2, p_line VARCHAR2, p_run VARCHAR2,
                             p_top VARCHAR2, p_parent VARCHAR2, p_qty NUMBER, p_qfrom NUMBER, p_qto NUMBER,
                             p_org NUMBER, p_depth NUMBER DEFAULT 0) IS
  BEGIN
    IF p_depth > 6 THEN RETURN; END IF;   -- 순환 BOM 방지
    FOR c IN (
      SELECT B.CHILD_ITEM_CODE, SUM(NVL(B.ITEM_UNIT_QTY, 0)) AS UNIT_QTY, MAX(I.ITEM_DIVISION) AS DIV
        FROM ID_ENG_BOM B
        LEFT JOIN ID_ITEM I ON I.ITEM_CODE = B.CHILD_ITEM_CODE AND I.ORGANIZATION_ID = B.ORGANIZATION_ID
       WHERE B.PARENT_ITEM_CODE = p_parent
         AND B.CHILD_ITEM_CODE <> p_parent
         AND B.ORGANIZATION_ID = p_org
         AND TRUNC(B.DATESET) <= p_work_date
         AND NVL(B.DATEEND, DATE '9999-12-31') >= p_work_date
       GROUP BY B.CHILD_ITEM_CODE
    ) LOOP
      IF c.DIV = 'W' AND NOT IS_SMT_NODE(c.CHILD_ITEM_CODE, p_org) THEN
        CONSUME_CHILDREN(p_work_date, p_source, p_line, p_run, p_top, c.CHILD_ITEM_CODE,
                         p_qty * c.UNIT_QTY, p_qfrom, p_qto, p_org, p_depth + 1);
      ELSE
        POST(p_work_date, p_source, 'C', p_line, p_run, p_top, p_parent, c.CHILD_ITEM_CODE,
             p_qty, c.UNIT_QTY, p_qfrom, p_qto, p_org);
      END IF;
    END LOOP;
  END CONSUME_CHILDREN;

  -- SMT 실적이 만든 노드: 제품 아래 모든 노드 중 직속 원자재가 레이아웃과 가장 많이 겹치는 것
  FUNCTION SMT_NODE(p_top VARCHAR2, p_line VARCHAR2, p_layout VARCHAR2, p_date DATE, p_org NUMBER)
    RETURN VARCHAR2 IS
    v_node VARCHAR2(30);
  BEGIN
    SELECT MAX(NODE) KEEP (DENSE_RANK FIRST ORDER BY HITS DESC, NODE) INTO v_node
      FROM (
        SELECT N.NODE, COUNT(DISTINCT L.ITEM_CODE) AS HITS
          FROM (SELECT p_top AS NODE FROM DUAL
                UNION
                SELECT CHILD_ITEM_CODE FROM ID_ENG_BOM
                 WHERE ORGANIZATION_ID = p_org
                   AND TRUNC(DATESET) <= p_date AND NVL(DATEEND, DATE '9999-12-31') >= p_date
                 START WITH PARENT_ITEM_CODE = p_top
                       AND ORGANIZATION_ID = p_org
                       AND TRUNC(DATESET) <= p_date AND NVL(DATEEND, DATE '9999-12-31') >= p_date
                 CONNECT BY NOCYCLE PRIOR CHILD_ITEM_CODE = PARENT_ITEM_CODE
                       AND ORGANIZATION_ID = p_org
                       AND TRUNC(DATESET) <= p_date AND NVL(DATEEND, DATE '9999-12-31') >= p_date) N
          JOIN ID_ENG_BOM B
            ON B.PARENT_ITEM_CODE = N.NODE AND B.ORGANIZATION_ID = p_org
           AND TRUNC(B.DATESET) <= p_date AND NVL(B.DATEEND, DATE '9999-12-31') >= p_date
          JOIN IB_PRODUCT_PLANDATA L
            ON L.ITEM_CODE = B.CHILD_ITEM_CODE AND L.LINE_CODE = p_line
           AND L.MODEL_NAME = p_layout AND L.ACTIVE_YN = 'Y'
         GROUP BY N.NODE
      )
     WHERE HITS > 0;
    RETURN v_node;
  END SMT_NODE;

  PROCEDURE PROCESS_QUEUE IS
    v_from NUMBER;
    v_to   NUMBER;
    v_node VARCHAR2(30);
  BEGIN
    SELECT MIN(QUEUE_ID), MAX(QUEUE_ID) INTO v_from, v_to FROM IM_BACKFLUSH_QUEUE WHERE STATUS = 'N';
    IF v_from IS NULL THEN RETURN; END IF;

    -- SMT 를 먼저 — 같은 회차의 완제품 입고가 이번에 만든 반제품을 공정재고에서 빼도록.
    FOR g IN (
      SELECT SOURCE, WORK_DATE, LINE_CODE, LAYOUT_MODEL, PCB_SIDE, ITEM_CODE, RUN_NO, ORGANIZATION_ID,
             SUM(QTY) AS QTY, MIN(QUEUE_ID) AS QFROM, MAX(QUEUE_ID) AS QTO
        FROM IM_BACKFLUSH_QUEUE
       WHERE STATUS = 'N' AND QUEUE_ID BETWEEN v_from AND v_to
       GROUP BY SOURCE, WORK_DATE, LINE_CODE, LAYOUT_MODEL, PCB_SIDE, ITEM_CODE, RUN_NO, ORGANIZATION_ID
       ORDER BY DECODE(SOURCE, 'SMT', 1, 'FG', 2, 3), MIN(QUEUE_ID)
    ) LOOP
      DECLARE
        v_err VARCHAR2(500);
      BEGIN
        v_err := NULL;
        IF g.SOURCE = 'SMT' THEN
          v_node := SMT_NODE(g.ITEM_CODE, g.LINE_CODE, g.LAYOUT_MODEL, g.WORK_DATE, g.ORGANIZATION_ID);
          IF v_node IS NULL THEN
            v_err := '레이아웃과 겹치는 BOM 노드 없음 (제품 ' || g.ITEM_CODE || ', 라인 ' || g.LINE_CODE || ')';
          ELSE
            POST(g.WORK_DATE, 'SMT', 'P', g.LINE_CODE, g.RUN_NO, g.ITEM_CODE, v_node, v_node,
                 g.QTY, 1, g.QFROM, g.QTO, g.ORGANIZATION_ID);
            CONSUME_CHILDREN(g.WORK_DATE, 'SMT', g.LINE_CODE, g.RUN_NO, g.ITEM_CODE, v_node, g.QTY,
                             g.QFROM, g.QTO, g.ORGANIZATION_ID);
            MERGE INTO IM_BACKFLUSH_NODE T
            USING (SELECT v_node AS ITEM_CODE, g.ORGANIZATION_ID AS ORG FROM DUAL) S
               ON (T.ITEM_CODE = S.ITEM_CODE AND T.ORGANIZATION_ID = S.ORG)
             WHEN MATCHED THEN UPDATE SET T.LAST_DATE = g.WORK_DATE
             WHEN NOT MATCHED THEN INSERT (ITEM_CODE, TOP_ITEM_CODE, PCB_SIDE, FIRST_DATE, LAST_DATE, ORGANIZATION_ID)
                  VALUES (v_node, g.ITEM_CODE, g.PCB_SIDE, g.WORK_DATE, g.WORK_DATE, g.ORGANIZATION_ID);
          END IF;
        ELSIF g.SOURCE = 'SCRAP' THEN
          -- 공정폐기: 그때까지 만든 SMT 생산 품목만 공정재고에서 뺀다
          IF IS_SMT_NODE(g.ITEM_CODE, g.ORGANIZATION_ID) THEN
            POST(g.WORK_DATE, 'SCRAP', 'C', g.LINE_CODE, g.RUN_NO, g.ITEM_CODE, g.ITEM_CODE, g.ITEM_CODE,
                 g.QTY, 1, g.QFROM, g.QTO, g.ORGANIZATION_ID);
          ELSE
            FOR w IN (
              SELECT B.CHILD_ITEM_CODE, SUM(NVL(B.ITEM_UNIT_QTY, 0)) AS UNIT_QTY
                FROM ID_ENG_BOM B
                JOIN IM_BACKFLUSH_NODE N ON N.ITEM_CODE = B.CHILD_ITEM_CODE AND N.ORGANIZATION_ID = B.ORGANIZATION_ID
               WHERE B.PARENT_ITEM_CODE = g.ITEM_CODE AND B.ORGANIZATION_ID = g.ORGANIZATION_ID
                 AND TRUNC(B.DATESET) <= g.WORK_DATE AND NVL(B.DATEEND, DATE '9999-12-31') >= g.WORK_DATE
               GROUP BY B.CHILD_ITEM_CODE
            ) LOOP
              POST(g.WORK_DATE, 'SCRAP', 'C', g.LINE_CODE, g.RUN_NO, g.ITEM_CODE, g.ITEM_CODE, w.CHILD_ITEM_CODE,
                   g.QTY, w.UNIT_QTY, g.QFROM, g.QTO, g.ORGANIZATION_ID);
            END LOOP;
          END IF;
        ELSE
          -- 완제품 입고: 제품이 SMT 생산 품목이면 그 제품을, 아니면 직속 자품목을 소비
          IF IS_SMT_NODE(g.ITEM_CODE, g.ORGANIZATION_ID) THEN
            POST(g.WORK_DATE, 'FG', 'C', g.LINE_CODE, g.RUN_NO, g.ITEM_CODE, g.ITEM_CODE, g.ITEM_CODE,
                 g.QTY, 1, g.QFROM, g.QTO, g.ORGANIZATION_ID);
          ELSE
            CONSUME_CHILDREN(g.WORK_DATE, 'FG', g.LINE_CODE, g.RUN_NO, g.ITEM_CODE, g.ITEM_CODE, g.QTY,
                             g.QFROM, g.QTO, g.ORGANIZATION_ID);
          END IF;
        END IF;

        UPDATE IM_BACKFLUSH_QUEUE
           SET STATUS = CASE WHEN v_err IS NULL THEN 'Y' ELSE 'E' END,
               ERROR_MESSAGE = v_err, PROCESSED_DATE = SYSDATE
         WHERE STATUS = 'N' AND QUEUE_ID BETWEEN g.QFROM AND g.QTO
           AND SOURCE = g.SOURCE AND WORK_DATE = g.WORK_DATE AND ITEM_CODE = g.ITEM_CODE
           AND NVL(LINE_CODE, '*') = NVL(g.LINE_CODE, '*') AND NVL(LAYOUT_MODEL, '*') = NVL(g.LAYOUT_MODEL, '*')
           AND NVL(PCB_SIDE, '*') = NVL(g.PCB_SIDE, '*') AND NVL(RUN_NO, '*') = NVL(g.RUN_NO, '*');
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          ROLLBACK;
          v_err := SUBSTR(SQLERRM, 1, 500);
          UPDATE IM_BACKFLUSH_QUEUE
             SET STATUS = 'E', ERROR_MESSAGE = v_err, PROCESSED_DATE = SYSDATE
           WHERE STATUS = 'N' AND QUEUE_ID BETWEEN g.QFROM AND g.QTO
             AND SOURCE = g.SOURCE AND WORK_DATE = g.WORK_DATE AND ITEM_CODE = g.ITEM_CODE
             AND NVL(LINE_CODE, '*') = NVL(g.LINE_CODE, '*') AND NVL(LAYOUT_MODEL, '*') = NVL(g.LAYOUT_MODEL, '*')
             AND NVL(PCB_SIDE, '*') = NVL(g.PCB_SIDE, '*') AND NVL(RUN_NO, '*') = NVL(g.RUN_NO, '*');
          COMMIT;
      END;
    END LOOP;
  END PROCESS_QUEUE;

END PKG_BACKFLUSH;
/

BEGIN
  DBMS_SCHEDULER.CREATE_JOB(
    job_name        => 'JOB_BACKFLUSH',
    job_type        => 'STORED_PROCEDURE',
    job_action      => 'PKG_BACKFLUSH.PROCESS_QUEUE',
    repeat_interval => 'FREQ=MINUTELY;INTERVAL=1',
    enabled         => FALSE,                -- 검토·시험 뒤 켠다
    comments        => '실시간 백플러시 (IM_BACKFLUSH_QUEUE → 공정입고·공정출고·IM_ITEM_BACKFLUSH)');
END;
/

-- ---------------------------------------------------------------------
-- 4. 실적 → 큐
-- ---------------------------------------------------------------------
-- 4-1. P_INTERLOCK_SENSOR_ACTUAL_NEO — phase '100' 앞에 아래 블록 하나만 추가
--      (재배포 전 원본 백업: oracle_db_scripts/_source_snapshots/P_INTERLOCK_SENSOR_ACTUAL_NEO.sql)
--   BEGIN
--      INSERT INTO IM_BACKFLUSH_QUEUE
--        (QUEUE_ID, SOURCE, EVENT_DATE, WORK_DATE, LINE_CODE, LAYOUT_MODEL, PCB_SIDE, ITEM_CODE, RUN_NO, QTY)
--      VALUES (SEQ_BACKFLUSH_QUEUE.NEXTVAL, 'SMT', SYSDATE, F_GET_WORK_ACTUAL_DATE(SYSDATE, 'A'),
--              LVS_LINE_CODE, LVS_FEEDER_LAYOUT_NAME, LVS_PCB_ITEM, LVS_ITEM_CODE, LVS_RUN_NO,
--              P_ACC_COUNT * lvl_carrier_qty);
--   EXCEPTION
--      WHEN OTHERS THEN NULL;   -- 백플러시 실패가 인터락을 막지 않게
--   END;

-- 4-2. 완제품 입고 → 큐 (기존 TRG_IP_PRODUCT_FG_RECEIPT_INS 는 그대로 두고 따로 단다)
CREATE OR REPLACE TRIGGER TRG_IP_PRODUCT_FG_RECEIPT_BF
AFTER INSERT ON IP_PRODUCT_FG_RECEIPT
FOR EACH ROW
WHEN (NEW.TXN_DEFICIT IN ('1', '2'))
BEGIN
  INSERT INTO IM_BACKFLUSH_QUEUE
    (QUEUE_ID, SOURCE, EVENT_DATE, WORK_DATE, LINE_CODE, ITEM_CODE, BARCODE, QTY, ORGANIZATION_ID)
  VALUES (SEQ_BACKFLUSH_QUEUE.NEXTVAL, 'FG', SYSDATE, TRUNC(:NEW.RECEIPT_DATE), :NEW.LINE_CODE,
          NVL(:NEW.ITEM_CODE, '*'), :NEW.BARCODE,
          DECODE(:NEW.TXN_DEFICIT, '2', -1, 1) * NVL(:NEW.QTY, 0), :NEW.ORGANIZATION_ID);
EXCEPTION
  WHEN OTHERS THEN NULL;   -- 백플러시 실패가 입고를 막지 않게
END;
/

-- 4-3. 공정폐기 등록 → 큐
CREATE OR REPLACE TRIGGER TRG_IP_PRODUCT_WORK_QC_BF
AFTER INSERT ON IP_PRODUCT_WORK_QC
FOR EACH ROW
WHEN (NEW.QC_INSPECT_HANDLING = 'D')
BEGIN
  INSERT INTO IM_BACKFLUSH_QUEUE
    (QUEUE_ID, SOURCE, EVENT_DATE, WORK_DATE, LINE_CODE, ITEM_CODE, BARCODE, QTY, ORGANIZATION_ID)
  VALUES (SEQ_BACKFLUSH_QUEUE.NEXTVAL, 'SCRAP', SYSDATE, TRUNC(NVL(:NEW.QC_DATE, SYSDATE)), :NEW.LINE_CODE,
          NVL(:NEW.ITEM_CODE, '*'), :NEW.SERIAL_NO, NVL(:NEW.BAD_QTY, 1), :NEW.ORGANIZATION_ID);
EXCEPTION
  WHEN OTHERS THEN NULL;   -- 백플러시 실패가 폐기 등록을 막지 않게
END;
/

-- ---------------------------------------------------------------------
-- 5. 반제품·완제품 마감표 (재료비)
-- ---------------------------------------------------------------------
CREATE TABLE IP_PRODUCT_INVENTORY_CLOSE (
  CLOSE_YYYYMM        VARCHAR2(6)   NOT NULL,
  ITEM_CODE           VARCHAR2(30)  NOT NULL,          -- 반제품(W)·완제품(F)
  LOCATION_CODE       VARCHAR2(20)  NOT NULL,
  ORGANIZATION_ID     NUMBER        NOT NULL,
  ITEM_DIVISION       VARCHAR2(1),
  UNIT_MATERIAL_COST  NUMBER,                          -- 그 달 생산입고 1개 재료비
  LAST_AVG_PRICE      NUMBER,
  LAST_INVENTORY_QTY  NUMBER,
  LAST_INVENTORY_AMT  NUMBER,
  MM_RECEIPT_QTY      NUMBER,
  MM_RECEIPT_AMT      NUMBER,
  MM_ISSUE_QTY        NUMBER,
  MM_ISSUE_AMT        NUMBER,
  MM_AVG_PRICE        NUMBER,
  MM_INVENTORY_QTY    NUMBER,
  MM_INVENTORY_AMT    NUMBER,
  ENTER_BY            VARCHAR2(20),
  ENTER_DATE          DATE,
  LAST_MODIFY_BY      VARCHAR2(20),
  LAST_MODIFY_DATE    DATE,
  CONSTRAINT PK_IP_PRODUCT_INVENTORY_CLOSE PRIMARY KEY (CLOSE_YYYYMM, ITEM_CODE, LOCATION_CODE, ORGANIZATION_ID)
);
COMMENT ON TABLE IP_PRODUCT_INVENTORY_CLOSE IS '반제품·완제품 월마감 (월총평균, 재료비 기준)';

-- =====================================================================
-- ROLLBACK
-- =====================================================================
-- BEGIN DBMS_SCHEDULER.DROP_JOB('JOB_BACKFLUSH'); END;
-- /
-- DROP TRIGGER TRG_IP_PRODUCT_FG_RECEIPT_BF;
-- DROP TRIGGER TRG_IP_PRODUCT_WORK_QC_BF;
-- P_INTERLOCK_SENSOR_ACTUAL_NEO 는 백업 스냅샷으로 재배포
-- DROP PACKAGE PKG_BACKFLUSH;
-- 공정재고 되돌리기: ENTER_BY='BACKFLUSH' 인 공정입고·공정출고를 반대 수량으로 넣어 상쇄한 뒤 삭제
-- DROP TABLE IM_BACKFLUSH_NODE; DROP TABLE IM_ITEM_BACKFLUSH; DROP SEQUENCE SEQ_ITEM_BACKFLUSH;
-- DROP TABLE IM_BACKFLUSH_QUEUE; DROP SEQUENCE SEQ_BACKFLUSH_QUEUE;
-- DROP TABLE IP_PRODUCT_INVENTORY_CLOSE;
