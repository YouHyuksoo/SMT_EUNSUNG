FUNCTION "F_SET_DATA_MONITOR" (p_org IN NUMBER)
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