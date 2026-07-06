CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_SET_DATA_MONITOR
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   입력값을 기준으로 번호, 문자열 또는 업무 데이터를 생성/변환하여 반환한다.
   *   필요 시 내부 테이블 조회와 계산 결과를 조합한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_ORG  (IN, NUMBER) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   NUMBER - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ISYS_MONITOR - 업무 기준/거래 데이터 조회 또는 참조
   *   IM_ITEM_ARRIVAL - 품목 관련 값 조회 또는 참조
   *   IM_ITEM_RECEIPT - 품목 관련 값 조회 또는 참조
   *   IM_ITEM_UNIT_PRICE - 품목 / 단가 관련 값 조회 또는 참조
   *   IS_PRODUCT_SALE_PRICE - 제품 / 단가 관련 값 조회 또는 참조
   *   IS_PRODUCT_SALE_PLAN - 제품 / 계획 관련 값 조회 또는 참조
   *   IS_PRODUCT_SHIPPING - 제품 관련 값 조회 또는 참조
   *   IS_ESTIMATE - 업무 기준/거래 데이터 조회 또는 참조
   *   IS_PRODUCT_RECEIPT - 제품 관련 값 조회 또는 참조
   *   IP_PRODUCT_RESULT - 제품 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_VOLUME_DC_RATE - 관련 업무 함수 호출
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 22회 / 반복문: 0회
   *   DML: SELECT 35회, INSERT 11회, UPDATE 11회, DELETE 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_SET_DATA_MONITOR(...) FROM DUAL;
   * ================================================================ */
 "F_SET_DATA_MONITOR" (p_org IN NUMBER)
   RETURN NUMBER
IS
   lvl_cnt   NUMBER;
BEGIN
   DELETE FROM isys_monitor;


----------------------------------------------
-- Arrival Monitor
----------------------------------------------
   SELECT COUNT (*)
     INTO lvl_cnt
     FROM isys_monitor
    WHERE monitor_date = TRUNC (SYSDATE)
      AND monitor_item = 'M100'
      AND organization_id = p_org;

   IF lvl_cnt = 0
   THEN
      INSERT INTO isys_monitor
                  (monitor_date,
                   monitor_item,
                   monitor_value_title1,
                   monitor_value_title2,
                   monitor_value_title3,
                   monitor_value1,
                   monitor_value2,
                   monitor_value3,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by,
                   organization_id
                  )
         SELECT   TRUNC (SYSDATE),
                  'M100',
                  'COUNT',
                  'QTY',
                  'AMOUNT',
                  COUNT (*),
                  SUM (arrival_qty),
                  SUM (arrival_amt),
                  SYSDATE,
                  'SYSTEM',
                  SYSDATE,
                  'SYSTEM',
                  p_org
             FROM im_item_arrival
            WHERE arrival_date = TRUNC (SYSDATE)
              AND arrival_status <> 'C'
              AND organization_id = p_org
         GROUP BY arrival_date, organization_id;
   ELSE
      UPDATE isys_monitor
         SET (monitor_value1, monitor_value2, monitor_value3, last_modify_date) =
                (SELECT   COUNT (*),
                          SUM (arrival_qty),
                          SUM (arrival_amt),
                          SYSDATE
                     FROM im_item_arrival
                    WHERE arrival_date = TRUNC (SYSDATE)
                      AND arrival_status <> 'C'
                      AND organization_id = p_org
                 GROUP BY arrival_date, organization_id)
       WHERE monitor_item = 'M100'
         AND organization_id = p_org;
   END IF;


----------------------------------------------
-- Material Receipt Monitor
----------------------------------------------
   SELECT COUNT (*)
     INTO lvl_cnt
     FROM isys_monitor
    WHERE monitor_date = TRUNC (SYSDATE)
      AND monitor_item = 'M200'
      AND organization_id = p_org;

   IF lvl_cnt = 0
   THEN
      INSERT INTO isys_monitor
                  (monitor_date,
                   monitor_item,
                   monitor_value_title1,
                   monitor_value_title2,
                   monitor_value_title3,
                   monitor_value1,
                   monitor_value2,
                   monitor_value3,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by,
                   organization_id
                  )
         SELECT   TRUNC (SYSDATE),
                  'M200',
                  'COUNT',
                  'QTY',
                  'AMOUNT',
                  COUNT (*),
                  SUM (receipt_qty),
                  SUM (receipt_amt),
                  SYSDATE,
                  'SYSTEM',
                  SYSDATE,
                  'SYSTEM',
                  p_org
             FROM im_item_receipt
            WHERE receipt_date = TRUNC (SYSDATE)
              AND receipt_status <> 'C'
              AND NVL(CONFIRM_YN,'N') <> 'Y'
              AND organization_id = p_org
         GROUP BY receipt_date, organization_id;
   ELSE
      UPDATE isys_monitor
         SET (monitor_value1, monitor_value2, monitor_value3, last_modify_date) =
                (SELECT   COUNT (*),
                          SUM (receipt_qty),
                          SUM (receipt_amt),
                          SYSDATE
                     FROM im_item_receipt
                    WHERE receipt_date = TRUNC (SYSDATE)
                      AND receipt_status <> 'C'
                      AND organization_id = p_org
                 GROUP BY receipt_date, organization_id)
       WHERE monitor_item = 'M200'
         AND organization_id = p_org;
   END IF;


----------------------------------------------
-- New Buy Price for Confirm
----------------------------------------------
   SELECT COUNT (*)
     INTO lvl_cnt
     FROM isys_monitor
    WHERE monitor_item = 'M300'
      AND organization_id = p_org;

   IF lvl_cnt = 0
   THEN
      INSERT INTO isys_monitor
                  (monitor_date,
                   monitor_item,
                   monitor_value_title1,
                   monitor_value_title2,
                   monitor_value_title3,
                   monitor_value1,
                   monitor_value2,
                   monitor_value3,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by,
                   organization_id
                  )
         SELECT   TRUNC (SYSDATE),
                  'M300',
                  'COUNT',
                  'QTY',
                  'AMOUNT',
                  COUNT (*),
                  0,
                  0,
                  SYSDATE,
                  'SYSTEM',
                  SYSDATE,
                  'SYSTEM',
                  p_org
             FROM im_item_unit_price
            WHERE dateset <= TRUNC (SYSDATE)
              AND dateend >= TRUNC (SYSDATE)
              AND NVL (price_change_confirm_yn, 'N') = 'N'
              AND organization_id = p_org
         GROUP BY organization_id;
   ELSE
      UPDATE isys_monitor
         SET (monitor_date, monitor_value1, monitor_value2, monitor_value3,
              last_modify_date) =
                (SELECT   TRUNC (SYSDATE),
                          COUNT (*),
                          0,
                          0,
                          SYSDATE
                     FROM im_item_unit_price
                    WHERE dateset <= TRUNC (SYSDATE)
                      AND dateend >= TRUNC (SYSDATE)
                      AND NVL (price_change_confirm_yn, 'N') = 'N'
                      AND organization_id = p_org
                 GROUP BY organization_id)
       WHERE monitor_item = 'M300'
         AND organization_id = p_org;
   END IF;


----------------------------------------------
-- New Sale Price for Confirm
----------------------------------------------
   SELECT COUNT (*)
     INTO lvl_cnt
     FROM isys_monitor
    WHERE monitor_item = 'P100'
      AND organization_id = p_org;

   IF lvl_cnt = 0
   THEN
      INSERT INTO isys_monitor
                  (monitor_date,
                   monitor_item,
                   monitor_value_title1,
                   monitor_value_title2,
                   monitor_value_title3,
                   monitor_value1,
                   monitor_value2,
                   monitor_value3,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by,
                   organization_id
                  )
         SELECT   TRUNC (SYSDATE),
                  'P100',
                  'COUNT',
                  'QTY',
                  'AMOUNT',
                  COUNT (*),
                  0,
                  0,
                  SYSDATE,
                  'SYSTEM',
                  SYSDATE,
                  'SYSTEM',
                  p_org
             FROM is_product_sale_price
            WHERE dateset <= TRUNC (SYSDATE)
              AND dateend >= TRUNC (SYSDATE)
              AND NVL (price_change_confirm_yn, 'N') = 'N'
              AND organization_id = p_org
         GROUP BY organization_id;
   ELSE
      UPDATE isys_monitor
         SET (monitor_date, monitor_value1, monitor_value2, monitor_value3,
              last_modify_date) =
                (SELECT   TRUNC (SYSDATE),
                          COUNT (*),
                          0,
                          0,
                          SYSDATE
                     FROM is_product_sale_price
                    WHERE dateset <= TRUNC (SYSDATE)
                      AND dateend >= TRUNC (SYSDATE)
                      AND NVL (price_change_confirm_yn, 'N') = 'N'
                      AND organization_id = p_org
                 GROUP BY organization_id)
       WHERE monitor_item = 'P100'
         AND organization_id = p_org;
   END IF;


----------------------------------------------
-- Product Sale Plan
----------------------------------------------
   SELECT COUNT (*)
     INTO lvl_cnt
     FROM isys_monitor
    WHERE monitor_item = 'P200'
      AND -- EXPORT PLAN
          organization_id = p_org;

   IF lvl_cnt = 0
   THEN
      INSERT INTO isys_monitor
                  (monitor_date,
                   monitor_item,
                   monitor_value_title1,
                   monitor_value_title2,
                   monitor_value_title3,
                   monitor_value1,
                   monitor_value2,
                   monitor_value3,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by,
                   organization_id
                  )
         SELECT   TRUNC (SYSDATE),
                  'P200',
                  'COUNT',
                  'QTY',
                  'AMOUNT',
                  COUNT (*),
                  SUM (order_qty),
                  SUM (
                       order_qty
                     * (  sale_plan_price
                        * (  1
                           - (  (  NVL (
                                    f_get_volume_dc_rate (
                                       customer_code,
                                       organization_id
                                    ),
                                    0
                                 )
                                 + NVL (order_dc_rate, 0)
                                )
                              / 100
                             )
                          )
                       )
                  ),
                  SYSDATE,
                  'SYSTEM',
                  SYSDATE,
                  'SYSTEM',
                  p_org
             FROM is_product_sale_plan
            WHERE confirm_yn = 'N'
              AND model_delivery_code = '1'
              AND organization_id = p_org
         GROUP BY organization_id;
   ELSE
      UPDATE isys_monitor
         SET (monitor_date, monitor_value1, monitor_value2, monitor_value3,
              last_modify_date) =
                (SELECT   TRUNC (SYSDATE),
                          COUNT (*),
                          SUM (order_qty),
                          SUM (order_qty * sale_plan_price),
                          SYSDATE
                     FROM is_product_sale_plan
                    WHERE confirm_yn = 'N'
                      AND model_delivery_code = '1'
                      AND organization_id = p_org
                 GROUP BY organization_id)
       WHERE monitor_item = 'P200'
         AND organization_id = p_org;
   END IF;

   SELECT COUNT (*)
     INTO lvl_cnt
     FROM isys_monitor
    WHERE monitor_item = 'P210'
      AND --DOSMESTIC PLAN
          organization_id = p_org;

   IF lvl_cnt = 0
   THEN
      INSERT INTO isys_monitor
                  (monitor_date,
                   monitor_item,
                   monitor_value_title1,
                   monitor_value_title2,
                   monitor_value_title3,
                   monitor_value1,
                   monitor_value2,
                   monitor_value3,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by,
                   organization_id
                  )
         SELECT   TRUNC (SYSDATE),
                  'P210',
                  'COUNT',
                  'QTY',
                  'AMOUNT',
                  COUNT (*),
                  SUM (order_qty),
                  SUM (
                       order_qty
                     * (  sale_plan_price
                        * (  1
                           - (  (  NVL (
                                    f_get_volume_dc_rate (
                                       customer_code,
                                       organization_id
                                    ),
                                    0
                                 )
                                 + NVL (order_dc_rate, 0)
                                )
                              / 100
                             )
                          )
                       )
                  ),
                  SYSDATE,
                  'SYSTEM',
                  SYSDATE,
                  'SYSTEM',
                  p_org
             FROM is_product_sale_plan
            WHERE delivery_date >= TRUNC (  SYSDATE
                                          - 30)
              AND confirm_yn = 'N'
              AND model_delivery_code = '2'
              AND organization_id = p_org
         GROUP BY organization_id;
   ELSE
      UPDATE isys_monitor
         SET (monitor_date, monitor_value1, monitor_value2, monitor_value3,
              last_modify_date) =
                (SELECT   TRUNC (SYSDATE),
                          COUNT (*),
                          SUM (order_qty),
                          SUM (order_qty * sale_plan_price),
                          SYSDATE
                     FROM is_product_sale_plan
                    WHERE delivery_date >= TRUNC (  SYSDATE
                                                  - 30)
                      AND confirm_yn = 'N'
                      AND model_delivery_code = '2'
                      AND organization_id = p_org
                 GROUP BY organization_id)
       WHERE monitor_item = 'P210'
         AND organization_id = p_org;
   END IF;


----------------------------------------------
-- Procur shipping Confirm
----------------------------------------------
   SELECT COUNT (*)
     INTO lvl_cnt
     FROM isys_monitor
    WHERE monitor_item = 'P300'
      AND organization_id = p_org;

   IF lvl_cnt = 0
   THEN
      INSERT INTO isys_monitor
                  (monitor_date,
                   monitor_item,
                   monitor_value_title1,
                   monitor_value_title2,
                   monitor_value_title3,
                   monitor_value1,
                   monitor_value2,
                   monitor_value3,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by,
                   organization_id
                  )
         SELECT   TRUNC (SYSDATE),
                  'P300',
                  'COUNT',
                  'QTY',
                  'AMOUNT',
                  COUNT (*),
                  0, --SUM(shipping_qty),
                  0, --SUM(shipping_amt),
                  SYSDATE,
                  'SYSTEM',
                  SYSDATE,
                  'SYSTEM',
                  p_org
             FROM is_product_shipping
            WHERE shipping_date >= TRUNC (  SYSDATE
                                          - 30)
              AND shipping_status <> 'C'
              AND confirm_yn = 'N'
              AND organization_id = p_org
         GROUP BY organization_id;
   ELSE
      UPDATE isys_monitor
         SET (monitor_date, monitor_value1, monitor_value2, monitor_value3,
              last_modify_date) =
                (SELECT   TRUNC (SYSDATE),
                          COUNT (*),
                          0, --SUM(shipping_qty),
                          0, --SUM(shipping_amt),
                          SYSDATE
                     FROM is_product_shipping
                    WHERE shipping_date >= TRUNC (  SYSDATE
                                                  - 30)
                      AND shipping_status <> 'C'
                      AND confirm_yn = 'N'
                      AND organization_id = p_org
                 GROUP BY organization_id)
       WHERE monitor_item = 'P300'
         AND organization_id = p_org;
   END IF;


----------------------------------------------
-- Procuct ESTIMATE Confirm
----------------------------------------------
   SELECT COUNT (*)
     INTO lvl_cnt
     FROM isys_monitor
    WHERE monitor_item = 'E100'
      AND organization_id = p_org;

   IF lvl_cnt = 0
   THEN
      INSERT INTO isys_monitor
                  (monitor_date,
                   monitor_item,
                   monitor_value_title1,
                   monitor_value_title2,
                   monitor_value_title3,
                   monitor_value1,
                   monitor_value2,
                   monitor_value3,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by,
                   organization_id
                  )
         SELECT   TRUNC (SYSDATE),
                  'E100',
                  'COUNT',
                  'QTY',
                  'AMOUNT',
                  COUNT (*),
                  SUM (qty),
                  SUM (amt),
                  SYSDATE,
                  'SYSTEM',
                  SYSDATE,
                  'SYSTEM',
                  p_org
             FROM (SELECT a.organization_id organization_id,
                          b.qty qty,
                          b.amt amt
                     FROM is_estimate a, is_estimate_detail b
                    WHERE a.estimate_no = b.estimate_no
                      AND a.version = b.version
                      AND a.organization_id = b.organization_id
                      AND NVL (a.confirm_status, 'N') = 'N')
            WHERE organization_id = p_org
         GROUP BY organization_id;
   ELSE
      UPDATE isys_monitor
         SET (monitor_date, monitor_value1, monitor_value2, monitor_value3,
              last_modify_date) =
                (SELECT   TRUNC (SYSDATE),
                          COUNT (*),
                          SUM (qty),
                          SUM (amt),
                          SYSDATE
                     FROM (SELECT a.organization_id organization_id,
                                  b.qty qty,
                                  b.amt amt
                             FROM is_estimate a, is_estimate_detail b
                            WHERE a.estimate_no = b.estimate_no
                              AND a.version = b.version
                              AND a.organization_id = b.organization_id
                              AND NVL (a.confirm_status, 'N') = 'N')
                    WHERE organization_id = p_org
                 GROUP BY organization_id)
       WHERE monitor_item = 'E100'
         AND organization_id = p_org;
   END IF;


----------------------------------------------
-- PRODUCT RECEIPT
----------------------------------------------
   SELECT COUNT (*)
     INTO lvl_cnt
     FROM isys_monitor
    WHERE monitor_item = 'S100'
      AND organization_id = p_org;

   IF lvl_cnt = 0
   THEN
      INSERT INTO isys_monitor
                  (monitor_date,
                   monitor_item,
                   monitor_value_title1,
                   monitor_value_title2,
                   monitor_value_title3,
                   monitor_value1,
                   monitor_value2,
                   monitor_value3,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by,
                   organization_id
                  )
         SELECT   TRUNC (SYSDATE),
                  'S100',
                  'COUNT',
                  'QTY',
                  'AMOUNT',
                  COUNT (*),
                  0,
                  0,
                  SYSDATE,
                  'SYSTEM',
                  SYSDATE,
                  'SYSTEM',
                  p_org
             FROM is_product_receipt
            WHERE receipt_status <> 'C'
              AND NVL (confirm_yn, 'N') = 'N'
              AND organization_id = p_org
         GROUP BY organization_id;
   ELSE
      UPDATE isys_monitor
         SET (monitor_date, monitor_value1, monitor_value2, monitor_value3,
              last_modify_date) =
                (SELECT   TRUNC (SYSDATE),
                          COUNT (*),
                          0,
                          0,
                          SYSDATE
                     FROM is_product_receipt
                    WHERE receipt_status <> 'C'
                      AND confirm_yn = 'N'
                      AND organization_id = p_org
                 GROUP BY organization_id)
       WHERE monitor_item = 'S100'
         AND organization_id = p_org;
   END IF;


----------------------------------------------
-- IQC BAD
----------------------------------------------
   SELECT COUNT (*)
     INTO lvl_cnt
     FROM isys_monitor
    WHERE monitor_item = 'Q100'
      AND organization_id = p_org;

   IF lvl_cnt = 0
   THEN
      INSERT INTO isys_monitor
                  (monitor_date,
                   monitor_item,
                   monitor_value_title1,
                   monitor_value_title2,
                   monitor_value_title3,
                   monitor_value1,
                   monitor_value2,
                   monitor_value3,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by,
                   organization_id
                  )
         SELECT   TRUNC (SYSDATE),
                  'Q100',
                  'COUNT',
                  'QTY',
                  'AMOUNT',
                  COUNT (*),
                  SUM (arrival_qty),
                  SUM (arrival_amt),
                  SYSDATE,
                  'SYSTEM',
                  SYSDATE,
                  'SYSTEM',
                  p_org
             FROM im_item_arrival
            WHERE inspect_result = 'R'
              AND organization_id = p_org
         GROUP BY organization_id;
   ELSE
      UPDATE isys_monitor
         SET (monitor_date, monitor_value1, monitor_value2, monitor_value3,
              last_modify_date) =
                (SELECT   TRUNC (SYSDATE),
                          COUNT (*),
                          SUM (arrival_qty),
                          SUM (arrival_amt),
                          SYSDATE
                     FROM im_item_arrival
                    WHERE inspect_result = 'R'
                      AND organization_id = p_org
                 GROUP BY organization_id)
       WHERE monitor_item = 'Q100'
         AND organization_id = p_org;
   END IF;


----------------------------------------------
-- Product LQC WAIT
----------------------------------------------
   SELECT COUNT (*)
     INTO lvl_cnt
     FROM isys_monitor
    WHERE monitor_item = 'Q200'
      AND organization_id = p_org;

   IF lvl_cnt = 0
   THEN
      INSERT INTO isys_monitor
                  (monitor_date,
                   monitor_item,
                   monitor_value_title1,
                   monitor_value_title2,
                   monitor_value_title3,
                   monitor_value1,
                   monitor_value2,
                   monitor_value3,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by,
                   organization_id
                  )
         SELECT   TRUNC (SYSDATE),
                  'Q200',
                  'COUNT',
                  'QTY',
                  'AMOUNT',
                  COUNT (*),
                  SUM (product_actual_qty), --SUM(ACTUAL_qty),
                  0, --SUM(shipping_amt),
                  SYSDATE,
                  'SYSTEM',
                  SYSDATE,
                  'SYSTEM',
                  p_org
             FROM ip_product_result
            WHERE product_date >= TRUNC (  SYSDATE
                                         - 30)
              AND lqc_inspect_result = 'W'
              AND organization_id = p_org
         GROUP BY organization_id;
   ELSE
      UPDATE isys_monitor
         SET (monitor_date, monitor_value1, monitor_value2, monitor_value3,
              last_modify_date) =
                (SELECT   TRUNC (SYSDATE),
                          COUNT (*),
                          0, --SUM(ACTUAL_QTY),
                          0, --SUM(shipping_amt),
                          SYSDATE
                     FROM ip_product_result
                    WHERE product_date >= TRUNC (  SYSDATE
                                                 - 30)
                      AND lqc_inspect_result = 'W'
                      AND organization_id = p_org
                 GROUP BY organization_id)
       WHERE monitor_item = 'Q200'
         AND organization_id = p_org;
   END IF;

   RETURN 1;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;
