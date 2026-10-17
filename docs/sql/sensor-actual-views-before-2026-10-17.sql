-- 센서실적 기반 뷰 원본 정의 (2026-10-17 조립실적으로 바꾸기 전). 되돌릴 때 실행한다.

CREATE OR REPLACE VIEW IP_ASSEMBLY_ACTUAL_TIME_V (RECEIPT_DATE, LINE_CODE, MODEL_NAME, MODEL_SUFFIX, PCB_ITEM, A_TIME_ACTUAL, B_TIME_ACTUAL, C_TIME_ACTUAL, D_TIME_ACTUAL, E_TIME_ACTUAL, F_TIME_ACTUAL, G_TIME_ACTUAL, H_TIME_ACTUAL, I_TIME_ACTUAL, J_TIME_ACTUAL) AS
SELECT A.RECEIPT_DATE,
          A.LINE_CODE,
          A.MODEL_NAME,
          A.MODEL_SUFFIX,
          A.PCB_ITEM,
          nvl(SUM (
             DECODE (A.TIME_DIVISION,
                     'A', A.PRODUCT_ACTUAL_QTY, -- * NVL (B.CARRIER_SIZE, 2),
                     0)) , 0)
             A_TIME_ACTUAL,
          nvl(SUM (
             DECODE (A.TIME_DIVISION,
                     'B', A.PRODUCT_ACTUAL_QTY, -- * NVL (B.CARRIER_SIZE, 2),
                     0)), 0)
             B_TIME_ACTUAL,
          nvl(SUM (
             DECODE (A.TIME_DIVISION,
                     'C', A.PRODUCT_ACTUAL_QTY, -- * NVL (B.CARRIER_SIZE, 2),
                     0)), 0)
             C_TIME_ACTUAL,
          nvl(SUM (
             DECODE (A.TIME_DIVISION,
                     'D', A.PRODUCT_ACTUAL_QTY, -- * NVL (B.CARRIER_SIZE, 2),
                     0)), 0)
             D_TIME_ACTUAL,
          nvl(SUM (
             DECODE (A.TIME_DIVISION,
                     'E', A.PRODUCT_ACTUAL_QTY, -- * NVL (B.CARRIER_SIZE, 2),
                     0)), 0)
             E_TIME_ACTUAL,
          nvl(SUM (
             DECODE (A.TIME_DIVISION,
                     'F', A.PRODUCT_ACTUAL_QTY, -- * NVL (B.CARRIER_SIZE, 2),
                     0)), 0)
             F_TIME_ACTUAL,
          nvl(SUM (
             DECODE (A.TIME_DIVISION,
                     'G', A.PRODUCT_ACTUAL_QTY, -- * NVL (B.CARRIER_SIZE, 2),
                     0)), 0)
             G_TIME_ACTUAL,
          nvl(SUM (
             DECODE (A.TIME_DIVISION,
                     'H', A.PRODUCT_ACTUAL_QTY, -- * NVL (B.CARRIER_SIZE, 2),
                     0)), 0)
             H_TIME_ACTUAL,
          nvl(SUM (
             DECODE (A.TIME_DIVISION,
                     'I', A.PRODUCT_ACTUAL_QTY, -- * NVL (B.CARRIER_SIZE, 2),
                     0)), 0)
             I_TIME_ACTUAL,
          nvl(SUM (
             DECODE (A.TIME_DIVISION,
                     'J', A.PRODUCT_ACTUAL_QTY, -- * NVL (B.CARRIER_SIZE, 2),
                     0)), 0)
             J_TIME_ACTUAL
     FROM IP_PRODUCT_SENSOR_ACTUAL_TIME A, IP_pRODUCT_MODEL_MASTER B
    WHERE A.MODEL_NAME = B.MODEL_NAME
   GROUP BY A.RECEIPT_DATE,
            A.LINE_CODE,
            A.MODEL_NAME,
            A.MODEL_SUFFIX,
            A.PCB_ITEM
/

CREATE OR REPLACE VIEW IP_ASSEMBLY_ACTUAL_DAY_V (RECEIPT_DATE, LINE_CODE, MODEL_NAME, MODEL_SUFFIX, PCB_ITEM, DAY_ACTUAL) AS
SELECT A.RECEIPT_DATE,
          A.LINE_CODE,
          A.MODEL_NAME,
          A.MODEL_SUFFIX,
          A.PCB_ITEM,
          SUM (
             DECODE (A.TIME_DIVISION,
                     'A', A.PRODUCT_ACTUAL_QTY, -- * NVL (B.CARRIER_SIZE, 2),
                     0))
            +
          SUM (
             DECODE (A.TIME_DIVISION,
                     'B', A.PRODUCT_ACTUAL_QTY, -- * NVL (B.CARRIER_SIZE, 2),
                     0))
            +
          SUM (
             DECODE (A.TIME_DIVISION,
                     'C', A.PRODUCT_ACTUAL_QTY, -- * NVL (B.CARRIER_SIZE, 2),
                     0))
            +
          SUM (
             DECODE (A.TIME_DIVISION,
                     'D', A.PRODUCT_ACTUAL_QTY, -- * NVL (B.CARRIER_SIZE, 2),
                     0))
            +
          SUM (
             DECODE (A.TIME_DIVISION,
                     'E', A.PRODUCT_ACTUAL_QTY, -- * NVL (B.CARRIER_SIZE, 2),
                     0))
            +
          SUM (
             DECODE (A.TIME_DIVISION,
                     'F', A.PRODUCT_ACTUAL_QTY, -- * NVL (B.CARRIER_SIZE, 2),
                     0))
           +
          SUM (
             DECODE (A.TIME_DIVISION,
                     'G', A.PRODUCT_ACTUAL_QTY, -- * NVL (B.CARRIER_SIZE, 2),
                     0))
           +
          SUM (
             DECODE (A.TIME_DIVISION,
                     'H', A.PRODUCT_ACTUAL_QTY, -- * NVL (B.CARRIER_SIZE, 2),
                     0))
           +
          SUM (
             DECODE (A.TIME_DIVISION,
                     'I', A.PRODUCT_ACTUAL_QTY, -- * NVL (B.CARRIER_SIZE, 2),
                     0))
           +
          SUM (
             DECODE (A.TIME_DIVISION,
                     'J', A.PRODUCT_ACTUAL_QTY, -- * NVL (B.CARRIER_SIZE, 2),,
                     0))
             DAY_ACTUAL
     FROM IP_PRODUCT_SENSOR_ACTUAL_TIME A, IP_pRODUCT_MODEL_MASTER B
    WHERE A.MODEL_NAME = B.MODEL_NAME
   GROUP BY A.RECEIPT_DATE,
            A.LINE_CODE,
            A.MODEL_NAME,
            A.MODEL_SUFFIX,
            A.PCB_ITEM
/

CREATE OR REPLACE VIEW IP_ASSEMBLY_ACTUAL_MONTH_V (PLAN_YM, MODEL_NAME, MODEL_SUFFIX, M1_ACTUAL, M2_ACTUAL, M3_ACTUAL, M4_ACTUAL, M5_ACTUAL, M6_ACTUAL, M7_ACTUAL, M8_ACTUAL, M9_ACTUAL, M10_ACTUAL, M11_ACTUAL, M12_ACTUAL) AS
SELECT TO_CHAR (A.RECEIPT_DATE, 'YYYYMM') PLAN_YM,

          A.MODEL_NAME,
          A.MODEL_SUFFIX,
          SUM (
             DECODE (TO_CHAR (A.RECEIPT_DATE, 'MM'),
                     '01', A.PRODUCT_ACTUAL_QTY, -- * NVL (B.CARRIER_SIZE, 2),
                     0)),
          SUM (
             DECODE (TO_CHAR (A.RECEIPT_DATE, 'MM'),
                     '02', A.PRODUCT_ACTUAL_QTY, -- * NVL (B.CARRIER_SIZE, 2),
                     0)),
          SUM (
             DECODE (TO_CHAR (A.RECEIPT_DATE, 'MM'),
                     '03', A.PRODUCT_ACTUAL_QTY, -- * NVL (B.CARRIER_SIZE, 2),
                     0)),
          SUM (
             DECODE (TO_CHAR (A.RECEIPT_DATE, 'MM'),
                     '04', A.PRODUCT_ACTUAL_QTY, -- * NVL (B.CARRIER_SIZE, 2),
                     0)),
          SUM (
             DECODE (A.TIME_DIVISION,
                     '05', A.PRODUCT_ACTUAL_QTY, -- * NVL (B.CARRIER_SIZE, 2),
                     0)),
          SUM (
             DECODE (TO_CHAR (A.RECEIPT_DATE, 'MM'),
                     '06', A.PRODUCT_ACTUAL_QTY, -- * NVL (B.CARRIER_SIZE, 2),
                     0)),
          SUM (
             DECODE (TO_CHAR (A.RECEIPT_DATE, 'MM'),
                     '07', A.PRODUCT_ACTUAL_QTY, -- * NVL (B.CARRIER_SIZE, 2),
                     0)),
          SUM (
             DECODE (TO_CHAR (A.RECEIPT_DATE, 'MM'),
                     '08', A.PRODUCT_ACTUAL_QTY, -- * NVL (B.CARRIER_SIZE, 2),
                     0)),
          SUM (
             DECODE (TO_CHAR (A.RECEIPT_DATE, 'MM'),
                     '09', A.PRODUCT_ACTUAL_QTY, -- * NVL (B.CARRIER_SIZE, 2),
                     0)),
          SUM (
             DECODE (TO_CHAR (A.RECEIPT_DATE, 'MM'),
                     '10', A.PRODUCT_ACTUAL_QTY, -- * NVL (B.CARRIER_SIZE, 2),
                     0)),
          SUM (
             DECODE (TO_CHAR (A.RECEIPT_DATE, 'MM'),
                     '11', A.PRODUCT_ACTUAL_QTY, -- * NVL (B.CARRIER_SIZE, 2),
                     0)),
          SUM (
             DECODE (TO_CHAR (A.RECEIPT_DATE, 'MM'),
                     '12', A.PRODUCT_ACTUAL_QTY, -- * NVL (B.CARRIER_SIZE, 2),
                     0))
     FROM IP_PRODUCT_SENSOR_ACTUAL_TIME A, IP_pRODUCT_MODEL_MASTER B
    WHERE A.MODEL_NAME = B.MODEL_NAME
   GROUP BY TO_CHAR (A.RECEIPT_DATE, 'YYYYMM'), A.MODEL_NAME, A.MODEL_SUFFIX
/

CREATE OR REPLACE VIEW IP_PRODUCT_ACTUAL_MONTH_V (PLAN_YM, MODEL_NAME, MODEL_SUFFIX, M1_ACTUAL, M2_ACTUAL, M3_ACTUAL, M4_ACTUAL, M5_ACTUAL, M6_ACTUAL, M7_ACTUAL, M8_ACTUAL, M9_ACTUAL, M10_ACTUAL, M11_ACTUAL, M12_ACTUAL) AS
SELECT TO_CHAR (A.RECEIPT_DATE, 'YYYYMM') PLAN_YM,
          A.MODEL_NAME,
          A.MODEL_SUFFIX,
          SUM (
             DECODE (TO_CHAR (A.RECEIPT_DATE, 'MM'),
                     '01', A.PRODUCT_ACTUAL_QTY * NVL (B.CARRIER_SIZE, 2),
                     0)),
          SUM (
             DECODE (TO_CHAR (A.RECEIPT_DATE, 'MM'),
                     '02', A.PRODUCT_ACTUAL_QTY * NVL (B.CARRIER_SIZE, 2),
                     0)),
          SUM (
             DECODE (TO_CHAR (A.RECEIPT_DATE, 'MM'),
                     '03', A.PRODUCT_ACTUAL_QTY * NVL (B.CARRIER_SIZE, 2),
                     0)),
          SUM (
             DECODE (TO_CHAR (A.RECEIPT_DATE, 'MM'),
                     '04', A.PRODUCT_ACTUAL_QTY * NVL (B.CARRIER_SIZE, 2),
                     0)),
          SUM (
             DECODE (A.TIME_DIVISION,
                     '05', A.PRODUCT_ACTUAL_QTY * NVL (B.CARRIER_SIZE, 2),
                     0)),
          SUM (
             DECODE (TO_CHAR (A.RECEIPT_DATE, 'MM'),
                     '06', A.PRODUCT_ACTUAL_QTY * NVL (B.CARRIER_SIZE, 2),
                     0)),
          SUM (
             DECODE (TO_CHAR (A.RECEIPT_DATE, 'MM'),
                     '07', A.PRODUCT_ACTUAL_QTY * NVL (B.CARRIER_SIZE, 2),
                     0)),
          SUM (
             DECODE (TO_CHAR (A.RECEIPT_DATE, 'MM'),
                     '08', A.PRODUCT_ACTUAL_QTY * NVL (B.CARRIER_SIZE, 2),
                     0)),
          SUM (
             DECODE (TO_CHAR (A.RECEIPT_DATE, 'MM'),
                     '09', A.PRODUCT_ACTUAL_QTY * NVL (B.CARRIER_SIZE, 2),
                     0)),
          SUM (
             DECODE (TO_CHAR (A.RECEIPT_DATE, 'MM'),
                     '10', A.PRODUCT_ACTUAL_QTY * NVL (B.CARRIER_SIZE, 2),
                     0)),
          SUM (
             DECODE (TO_CHAR (A.RECEIPT_DATE, 'MM'),
                     '11', A.PRODUCT_ACTUAL_QTY * NVL (B.CARRIER_SIZE, 2),
                     0)),
          SUM (
             DECODE (TO_CHAR (A.RECEIPT_DATE, 'MM'),
                     '12', A.PRODUCT_ACTUAL_QTY * NVL (B.CARRIER_SIZE, 2),
                     0))
     FROM IP_PRODUCT_SENSOR_ACTUAL_TIME A, IP_pRODUCT_MODEL_MASTER B
    WHERE A.MODEL_NAME = B.MODEL_NAME
   GROUP BY TO_CHAR (A.RECEIPT_DATE, 'YYYYMM'), A.MODEL_NAME, A.MODEL_SUFFIX
/

