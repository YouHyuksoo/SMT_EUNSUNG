PACKAGE BODY "PKG_PLANNING" 
AS

----------------------------------------------------
--
----------------------------------------------------
   FUNCTION plan_prod_explosion (
      p_plan_date       IN   DATE,
      p_plan_sequence   IN   NUMBER,
      p_org             IN   NUMBER
   )
      RETURN NUMBER
   IS
      lvl_session_id           NUMBER;
      lvl_routing_session_id   NUMBER;
      lvd_datelimit            DATE          := TO_DATE (
                                                   '9999/12/31',
                                                   'yyyy/mm/dd'
                                                );
      lvl_return               NUMBER;
      lvl_count                NUMBER;
      lvs_parent_item_code     VARCHAR2 (20);
      lvs_mfs                  VARCHAR2 (20);
      lvs_origin_mfs           VARCHAR2 (20);
      lvs_plan_yyyymm          VARCHAR2 (6);
      lvs_plan_priority        VARCHAR2 (10);
      lvs_shift_code           VARCHAR2 (10);
      lvs_line_code            VARCHAR2 (20);
      lvf_plan_qty             NUMBER;
      lvs_workstage_code       VARCHAR2 (20);
      lvs_machine_code         VARCHAR2 (20);
      lvs_route_no             VARCHAR2 (20);
      lvdb_work_order_no       NUMBER;
      lvs_config_value         VARCHAR2 (10);
      lvl_bom_level            NUMBER;
      lvs_work_order_by_mfs    VARCHAR2 (1);
      phase                    VARCHAR2 (30);
   BEGIN

--------------------------------------------------
--
--------------------------------------------------
      phase := 10;

      BEGIN
         SELECT item_code,
                mfs,
                plan_yyyymm,
                plan_priority,
                shift_code,
                line_code,
                order_qty,
                machine_code,
                workstage_code,
                origin_mfs,
                route_no
           INTO lvs_parent_item_code,
                lvs_mfs,
                lvs_plan_yyyymm,
                lvs_plan_priority,
                lvs_shift_code,
                lvs_line_code,
                lvf_plan_qty,
                lvs_machine_code,
                lvs_workstage_code,
                lvs_origin_mfs,
                lvs_route_no
           FROM ip_product_master_plan
          WHERE plan_date = p_plan_date
            AND plan_date_sequence = p_plan_sequence
            AND organization_id = p_org;
         phase := 20;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (
               -20003,
                  lvs_parent_item_code
               || ' '
               || p_plan_date
               || ' '
               || p_plan_sequence
               || ' '
               || SQLERRM
            );
      END;

      phase := 30;
      lvl_session_id := pkg_design.bom_explosion (
                           lvs_parent_item_code,
                           TRUNC (SYSDATE),
                           p_org
                        );
      phase := 40;

      IF lvl_session_id < 0
      THEN
         RETURN lvl_session_id;
      END IF;

      phase := 50;


--------------------------------------------------
--
--------------------------------------------------
      BEGIN
         SELECT COUNT (*)
           INTO lvl_count
           FROM id_eng_bom_temp
          WHERE session_id = lvl_session_id;
         phase := 60;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (
               -20003,
                  'BOM Explosion Result Not Found '
               || SQLERRM
            );
      END;

      IF lvl_count = 0
      THEN
         raise_application_error (
            -20003,
               'BOM Explosion Result Not Found '
            || SQLERRM
         );
      END IF;

      phase := 70;

      DELETE FROM im_item_work_order
            WHERE plan_date = p_plan_date
              AND plan_date_sequence = p_plan_sequence
              AND organization_id = p_org;

      phase := 80;
      SELECT seq_work_order_no.NEXTVAL
        INTO lvdb_work_order_no
        FROM DUAL;


------------------------------------
-- SYSTEM CONFIG VALUE GET
-- CURRENT VALUE = Y
------------------------------------
      BEGIN
         SELECT NVL (config_value, 'N')
           INTO lvs_config_value
           FROM isys_config
          WHERE config_name = 'WORKODER_GEN_BY_PROD_PLAN'
            AND use_yn = 'Y'
            AND organization_id = p_org;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            lvs_config_value := 'N'; --ONLY PRODUCT CHILD
         WHEN OTHERS
         THEN
            raise_application_error (-20003, SQLERRM);
      END;

      IF    lvs_config_value = 'N'
         OR lvs_config_value IS NULL
      THEN
         lvl_bom_level := 2;
      ELSIF lvs_config_value = 'X' --NO EXPLOSION
      THEN
         lvl_bom_level := 0;
      ELSE
         lvl_bom_level := 1000; -- ALL EXPLOSION
      END IF;


------------------------------------
-- SYSTEM CONFIG VALUE GET
-- CURRENT VALUE = Y
--
------------------------------------
      BEGIN
         SELECT NVL (config_value, 'N')
           INTO lvs_config_value
           FROM isys_config
          WHERE config_name = 'WORK_ORDER_BY_MFS'
            AND use_yn = 'Y'
            AND organization_id = p_org;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            lvs_config_value := 'N'; --ONLY PRODUCT CHILD
         WHEN OTHERS
         THEN
            raise_application_error (-20003, SQLERRM);
      END;

      IF    lvs_config_value = 'N'
         OR lvs_config_value IS NULL
      THEN
         lvs_work_order_by_mfs := 'N';
         lvs_mfs := '*';
         lvs_origin_mfs := '*';
      ELSE
         lvs_work_order_by_mfs := 'Y';
      END IF;


------------------------------------
-- Issue Plan  Generate
------------------------------------
      INSERT INTO im_item_work_order
                  (mfs,
                   origin_mfs,
                   work_order_no,
                   organization_id,
                   plan_yyyymm,
                   plan_date,
                   plan_date_sequence,
                   plan_priority,
                   item_code,
                   item_type,
                   line_type,
                   issue_type,
                   issue_division,
                   issue_plan_qty,
                   issue_qty,
                   issue_account,
                   issue_status,
                   issue_date,
                   model_unit_qty,
                   shift_code,
                   line_code,
                   work_order_type,
                   workstage_code,
                   parent_item_code,
                   last_modify_date,
                   last_modify_by,
                   enter_date,
                   enter_by,
                   route_no,
                   sort_sequence
                  )
         SELECT   lvs_mfs,
                  lvs_origin_mfs,
                  lvdb_work_order_no,
                  a.organization_id,
                  lvs_plan_yyyymm,
                  p_plan_date,
                  p_plan_sequence,
                  lvs_plan_priority,
                  a.child_item_code,
                  a.item_type,
                  a.line_type,
                  'N' issue_type,
                  'P',
                  SUM (lvf_plan_qty * model_unit_qty),
                  0,
                  'M001',
                  'N',
                  p_plan_date,
                  SUM (model_unit_qty),
                  lvs_shift_code,
                  lvs_line_code,
                  'N',
                  NVL (a.workstage_code, '*'),
                  lvs_parent_item_code,
                  SYSDATE,
                  'SYSTEM',
                  SYSDATE,
                  'SYSTEM',
                  lvs_route_no,
                  a.sort_sequence
             FROM id_eng_bom_temp a, ip_product_routing b, id_item c
            WHERE a.session_id = lvl_session_id
              AND a.parent_item_code <> '*'
              AND a.bom_level <= lvl_bom_level
              AND a.child_item_code = c.item_code
              AND c.organization_id = p_org
              AND c.dateset <= TRUNC (SYSDATE)
              AND c.dateend >= TRUNC (SYSDATE)
              AND c.route_no = b.route_no(+)
              AND NVL (c.auto_issue_plan_yn, 'Y') = 'Y'
              AND c.organization_id = b.organization_id(+)
              AND a.organization_id = c.organization_id
         GROUP BY a.organization_id,
                  a.child_item_code,
                  a.item_type,
                  a.line_type,
                  NVL (a.workstage_code, '*'),
                  a.sort_sequence;

      phase := 90;

-----------------------------------------------------
-- Generate Workstage Transfer Plan Start
-----------------------------------------------------
/*

      BEGIN
         SELECT COUNT(*)
         INTO   lvl_count
         FROM   ip_product_routing
         WHERE  route_no = lvs_route_no;
         phase := 100;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error(
               -20003, lvs_route_no || ' Routing Explosion Result Not Found '
                       || SQLERRM
            );
      END;

      IF lvl_count = 0
      THEN
         raise_application_error(
            -20003, lvs_route_no || ' Routing Explosion Result Not Found '
                    || SQLERRM
         );
      END IF;


-----------------------------------------------------
--
-----------------------------------------------------

      INSERT INTO im_item_workstage_issue_plan
                  (issue_date,
                   issue_sequence,
                   organization_id,
                   mfs,
                   mfs_connect,
                   work_order_no,
                   invoice_no,
                   item_code,
                   item_type,
                   line_type,
                   line_code,
                   dest_line_code,
                   workstage_code,
                   dest_workstage_code,
                   machine_code,
                   issue_plan_qty,
                   issue_qty,
                   issue_weight,
                   bad_weight,
                   loss_weight,
                   scrap_weight,
                   item_unit_weight,
                   transfer_yn,
                   transfer_type,
                   issue_status,
                   product_date,
                   product_sequence,
                   route_no,
                   comments,
                   origin_mfs,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by,
                   issue_deficit
                  )
         SELECT TRUNC(SYSDATE), --ISSUE_DATE,
                seq_workstage_issue_seq.NEXTVAL, --ISSUE_SEQUENCE,
                a.organization_id, --ORGANIZATION_ID,
                lvs_mfs, --MFS,
                lvs_mfs, --MFS,
                lvdb_work_order_no, -- WORK ORDER NO
                '', --INVOICE_NO,
                DECODE(bom_level, '1', parent_item_code, a.child_item_code), --ITEM_CODE,
                a.item_type, --ITEM_TYPE,
                a.line_type, --LINE_TYPE,
                lvs_line_code, --LINE_CODE,
                lvs_line_code, --LINE_CODE,
                NVL(b.workstage_code, '*'), --WORKSTAGE_CODE,
                NVL(b.trans_workstage_code, '*'), --DEST_WORKSTAGE_CODE,
                '*', --MACHINE_CODE,
                lvf_plan_qty * model_unit_qty, --ISSUE_PLAN_QTY,
                0, --ISSUE_QTY,
                0, --ISSUE_WEIGHT,
                0, --BAD_WEIGHT,
                0, --LOSS_WEIGHT,
                0, --SCRAP_WEIGHT,
                a.item_unit_qty, --ITEM_UNIT_WEIGHT,
                'N', --TRANSFER_YN,
                b.transfer_type,
                'N', --ISSUE_STATUS,
                NULL, --PRODUCT_DATE,
                NULL, --PRODUCT_SEQUENCE,
                b.route_no,
                '*', --COMMENTS,
                lvs_origin_mfs,
                SYSDATE, --ENTER_DATE,
                'SYSTEM', --ENTER_BY,
                SYSDATE, --LAST_MODIFY_DATE,
                'SYSTEM', --LAST_MODIFY_BY,
                '3' --ISSUE_DEFICIT
         FROM   id_eng_bom_temp a,
                ip_product_routing b,
                id_item c
         WHERE  a.session_id = lvl_session_id            AND
                a.line_type = 'T'                        AND
                a.bom_level = 1                          AND
                a.organization_id = p_org                AND
                a.child_item_code = c.item_code          AND
                c.route_no = b.route_no(+)               AND
                c.organization_id = b.organization_id(+) AND
                b.transfer_type IN ('T', 'L', 'C');

*/
-----------------------------------------------------
-- Generate Workstage Issue Plan End
-----------------------------------------------------
      UPDATE ip_product_master_plan
         SET plan_transfer_yn = 'Y'
       WHERE plan_date = p_plan_date
         AND plan_date_sequence = p_plan_sequence
         AND organization_id = p_org;

   --   DELETE FROM id_eng_bom_temp
    --        WHERE session_id = lvl_session_id;

      phase := 100;
      RETURN lvl_count;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (
            -20003,
               'Phase='
            || phase
            || ' PKG_DESIGN '
            || SQLERRM
         );
      WHEN OTHERS
      THEN
       /* INSERT INTO xxadm_item_work_order
                  (mfs,
                   origin_mfs,
                   work_order_no,
                   organization_id,
                   plan_yyyymm,
                   plan_date,
                   plan_date_sequence,
                   plan_priority,
                   item_code,
                   item_type,
                   line_type,
                   issue_type,
                   issue_division,
                   issue_plan_qty,
                   issue_qty,
                   issue_account,
                   issue_status,
                   issue_date,
                   model_unit_qty,
                   shift_code,
                   line_code,
                   work_order_type,
                   workstage_code,
                   parent_item_code,
                   last_modify_date,
                   last_modify_by,
                   enter_date,
                   enter_by,
                   route_no,
                   sort_sequence
                  )

          SELECT   lvs_mfs,
                  lvs_origin_mfs,
                  lvdb_work_order_no,
                  a.organization_id,
                  lvs_plan_yyyymm,
                  p_plan_date,
                  p_plan_sequence,
                  lvs_plan_priority,
                  a.child_item_code,
                  a.item_type,
                  a.line_type,
                  'N' issue_type,
                  'P',
                  SUM (lvf_plan_qty * model_unit_qty),
                  0,
                  'M001',
                  'N',
                  p_plan_date,
                  SUM (model_unit_qty),
                  lvs_shift_code,
                  lvs_line_code,
                  'N',
                  NVL (a.workstage_code, '*'),
                  lvs_parent_item_code,
                  SYSDATE,
                  'SYSTEM',
                  SYSDATE,
                  'SYSTEM',
                  lvs_route_no,
                  a.sort_sequence
             FROM id_eng_bom_temp a, ip_product_routing b, id_item c
            WHERE a.session_id = lvl_session_id
              AND a.parent_item_code <> '*'
              AND a.bom_level <= lvl_bom_level
              AND a.child_item_code = c.item_code
              AND c.organization_id = p_org
              AND c.dateset <= TRUNC (SYSDATE)
              AND c.dateend >= TRUNC (SYSDATE)
              AND c.route_no = b.route_no(+)
              AND NVL (c.auto_issue_plan_yn, 'Y') = 'Y'
              AND c.organization_id = b.organization_id(+)
              AND a.organization_id = c.organization_id
         GROUP BY a.organization_id,
                  a.child_item_code,
                  a.item_type,
                  a.line_type,
                  NVL (a.workstage_code, '*'),
                  a.sort_sequence;
          commit ; */


         raise_application_error (
            -20003,
               'Phase='
            || phase
            || ' PKG_DESIGN '
            || SQLERRM
         );
   END;


----------------------------------------------------
--
----------------------------------------------------
   FUNCTION plan_assy_explosion (
      p_plan_date       IN   DATE,
      p_plan_sequence   IN   NUMBER,
      p_org             IN   NUMBER
   )
      RETURN NUMBER
   IS
      lvl_session_id           NUMBER;
      lvl_routing_session_id   NUMBER;
      lvd_datelimit            DATE          := TO_DATE (
                                                   '9999/12/31',
                                                   'yyyy/mm/dd'
                                                );
      lvl_return               NUMBER;
      lvl_count                NUMBER;
      lvs_parent_item_code     VARCHAR2 (20);
      lvs_child_item_code      VARCHAR2 (20);
      lvs_mfs                  VARCHAR2 (20);
      lvs_origin_mfs           VARCHAR2 (20);
      lvs_plan_yyyymm          VARCHAR2 (6);
      lvs_plan_priority        VARCHAR2 (20);
      lvs_shift_code           VARCHAR2 (20);
      lvs_line_code            VARCHAR2 (20);
      lvf_plan_qty             NUMBER;
      lvs_workstage_code       VARCHAR2 (20);
      lvs_machine_code         VARCHAR2 (20);
      lvs_route_no             VARCHAR2 (20);
      lvdb_work_order_no       NUMBER;
      lvs_config_value         VARCHAR2 (10);
      lvl_bom_level            NUMBER;
      phase                    VARCHAR2 (30);
   BEGIN

--------------------------------------------------
--
--------------------------------------------------
      phase := 9;

      BEGIN
         SELECT parent_item_code,
                item_code,
                mfs,
                origin_mfs,
                plan_yyyymm,
                plan_priority,
                shift_code,
                line_code,
                order_qty,
                machine_code,
                workstage_code,
                route_no
           INTO lvs_parent_item_code,
                lvs_child_item_code,
                lvs_mfs,
                lvs_origin_mfs,
                lvs_plan_yyyymm,
                lvs_plan_priority,
                lvs_shift_code,
                lvs_line_code,
                lvf_plan_qty,
                lvs_machine_code,
                lvs_workstage_code,
                lvs_route_no
           FROM ip_assembly_master_plan
          WHERE plan_date = p_plan_date
            AND plan_date_sequence = p_plan_sequence
            AND organization_id = p_org;
         phase := 20;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20003, SQLERRM);
      END;

      IF lvs_parent_item_code = '*'
      THEN
         BEGIN
            SELECT MAX (parent_item_code)
              INTO lvs_parent_item_code
              FROM id_eng_bom
             WHERE child_item_code = lvs_child_item_code
               AND dateset <= p_plan_date
               AND dateend >= p_plan_date
               AND organization_id = p_org
               AND ROWNUM = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error (-20003, SQLERRM);
         END;
      END IF;

      phase := 30;
      lvl_session_id := pkg_design.bom_assy_explosion (
                           lvs_parent_item_code,
                           lvs_child_item_code,
                           TRUNC (SYSDATE),
                           p_org
                        );
      phase := 40;

      IF lvl_session_id < 0
      THEN
         RETURN lvl_session_id;
      END IF;

      phase := 50;


--------------------------------------------------
--
--------------------------------------------------
      BEGIN
         SELECT COUNT (*)
           INTO lvl_count
           FROM id_eng_bom_temp
          WHERE session_id = lvl_session_id;
         phase := 60;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (
               -20003,
                  'BOM Explosion Result Not Found '
               || SQLERRM
            );
      END;

      IF lvl_count = 0
      THEN
         raise_application_error (
            -20003,
               'BOM Explosion Result Not Found '
            || SQLERRM
         );
      END IF;

      phase := 70;

      DELETE FROM im_item_work_order
            WHERE plan_date = p_plan_date
              AND plan_date_sequence = p_plan_sequence
              AND organization_id = p_org;

      phase := 80;
      SELECT seq_work_order_no.NEXTVAL
        INTO lvdb_work_order_no
        FROM DUAL;


------------------------------------
-- SYSTEM CONFIG VALUE GET
-----------------------------------
      BEGIN
         SELECT NVL (config_value, 'N')
           INTO lvs_config_value
           FROM isys_config
          WHERE config_name = 'WORKODER_GEN_BY_PROD_PLAN'
            AND use_yn = 'Y'
            AND organization_id = p_org;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            lvs_config_value := 'N';
         WHEN OTHERS
         THEN
            raise_application_error (-20003, SQLERRM);
      END;

      IF    lvs_config_value = 'N'
         OR lvs_config_value IS NULL
      THEN
         lvl_bom_level := 2;
      ELSIF lvs_config_value = 'X' --NO EXPLOSION
      THEN
         lvl_bom_level := 0;
      ELSE
         lvl_bom_level := 1000; -- ALL EXPLOSION
      END IF;


------------------------------------
-- Issue Plan  Generate
-- Y = ??????? ???????????????????
-- ??????????????????????????o???? ??
-- ??????-- N (2 ???? ??????? )
------------------------------------
      IF lvs_config_value = 'N'
      THEN
         INSERT INTO im_item_work_order
                     (mfs,
                      origin_mfs,
                      work_order_no,
                      organization_id,
                      plan_yyyymm,
                      plan_date,
                      plan_date_sequence,
                      plan_priority,
                      item_code,
                      item_type,
                      line_type,
                      issue_type,
                      issue_division,
                      issue_plan_qty,
                      issue_qty,
                      issue_account,
                      issue_status,
                      issue_date,
                      model_unit_qty,
                      shift_code,
                      line_code,
                      work_order_type,
                      workstage_code,
                      parent_item_code,
                      last_modify_date,
                      last_modify_by,
                      enter_date,
                      enter_by,
                      route_no,
                      sort_sequence
                     )
            SELECT lvs_mfs,
                   lvs_origin_mfs,
                   lvdb_work_order_no,
                   a.organization_id,
                   lvs_plan_yyyymm,
                   p_plan_date,
                   p_plan_sequence,
                   lvs_plan_priority,
                   a.child_item_code,
                   a.item_type,
                   a.line_type,
                   'N' issue_type,
                   'P',
                   lvf_plan_qty * model_unit_qty,
                   0,
                   'M001',
                   'N',
                   p_plan_date,
                   model_unit_qty,
                   lvs_shift_code,
                   lvs_line_code,
                   'N',
                   a.workstage_code,
                   DECODE (
                      lvs_config_value,
                      'N', a.parent_item_code,
                      lvs_parent_item_code
                   ),
                   SYSDATE,
                   'SYSTEM',
                   SYSDATE,
                   'SYSTEM',
                   lvs_route_no,
                   a.sort_sequence
              FROM id_eng_bom_temp a, ip_product_routing b, id_item c
             WHERE a.session_id = lvl_session_id
               AND a.parent_item_code <> '*'

--               AND a.line_type <> 'T'
               AND a.child_item_code = c.item_code
               AND a.bom_level > 1
               AND a.bom_level <= lvl_bom_level
               AND c.route_no = b.route_no(+)
               AND NVL (c.auto_issue_plan_yn, 'Y') = 'Y'
               AND c.organization_id = b.organization_id(+)
               AND a.organization_id = c.organization_id;

--                b.transfer_type IN ('S');
      END IF; -- config value

      phase := 90;


-----------------------------------------------------
-- Generate Workstage Transfer Plan Start
-----------------------------------------------------
/*

      BEGIN
         SELECT COUNT(*)
         INTO   lvl_count
         FROM   ip_product_routing
         WHERE  route_no = lvs_route_no;
         phase := 100;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error(
               -20003, lvs_route_no || ' Routing Explosion Result Not Found '
                       || SQLERRM
            );
      END;

      IF lvl_count = 0
      THEN
         raise_application_error(
            -20003, lvs_route_no || ' Routing Explosion Result Not Found '
                    || SQLERRM
         );
      END IF;


-----------------------------------------------------
--
-----------------------------------------------------


      INSERT INTO im_item_workstage_issue_plan
                  (issue_date,
                   issue_sequence,
                   organization_id,
                   mfs,
                   mfs_connect,
                   work_order_no,
                   invoice_no,
                   item_code,
                   item_type,
                   line_type,
                   line_code,
                   dest_line_code,
                   workstage_code,
                   dest_workstage_code,
                   machine_code,
                   issue_plan_qty,
                   issue_qty,
                   issue_weight,
                   bad_weight,
                   loss_weight,
                   scrap_weight,
                   item_unit_weight,
                   transfer_yn,
                   transfer_type,
                   issue_status,
                   product_date,
                   product_sequence,
                   comments,
                   route_no,
                   origin_mfs,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by,
                   issue_deficit
                  )
         SELECT TRUNC(SYSDATE), --ISSUE_DATE,
                seq_workstage_issue_seq.NEXTVAL, --ISSUE_SEQUENCE,
                a.organization_id, --ORGANIZATION_ID,
                lvs_mfs, --MFS,
                lvs_origin_mfs, --MFS,
                lvdb_work_order_no,
                '', --INVOICE_NO,
                a.child_item_code, --ITEM_CODE,
                a.item_type, --ITEM_TYPE,
                a.line_type, --LINE_TYPE,
                lvs_line_code, --LINE_CODE,
                lvs_line_code, --LINE_CODE,
                NVL(b.workstage_code, '*'), --WORKSTAGE_CODE,
                NVL(b.trans_workstage_code, '*'), --DEST_WORKSTAGE_CODE,
                '*', --MACHINE_CODE,
                lvf_plan_qty * model_unit_qty, --ISSUE_PLAN_QTY,
                0, --ISSUE_QTY,
                0, --ISSUE_WEIGHT,
                0, --BAD_WEIGHT,
                0, --LOSS_WEIGHT,
                0, --SCRAP_WEIGHT,
                a.item_unit_qty, --ITEM_UNIT_WEIGHT,
                'N', --TRANSFER_YN,
                transfer_type,
                'N', --ISSUE_STATUS,
                NULL, --PRODUCT_DATE,
                NULL, --PRODUCT_SEQUENCE,
                '*', --COMMENTS,
                b.route_no,
                lvs_origin_mfs,
                SYSDATE, --ENTER_DATE,
                'SYSTEM', --ENTER_BY,
                SYSDATE, --LAST_MODIFY_DATE,
                'SYSTEM', --LAST_MODIFY_BY,
                '3' --ISSUE_DEFICIT
         FROM   id_eng_bom_temp a,
                ip_product_routing b,
                id_item c
         WHERE  a.session_id = lvl_session_id            AND
                a.line_type = 'T'                        AND
                a.organization_id = p_org                AND
                a.child_item_code = c.item_code          AND
                c.organization_id = p_org                AND
                c.dateset <= TRUNC(SYSDATE)              AND
                c.dateend >= TRUNC(SYSDATE)              AND
                c.route_no = b.route_no(+)               AND
                c.organization_id = b.organization_id(+);

*/
-----------------------------------------------------
-- Generate Workstage Issue Plan End
-----------------------------------------------------
      UPDATE ip_assembly_master_plan
         SET plan_transfer_yn = 'Y'
       WHERE plan_date = p_plan_date
         AND plan_date_sequence = p_plan_sequence
         AND organization_id = p_org;

      DELETE FROM id_eng_bom_temp
            WHERE session_id = lvl_session_id;

      phase := 100;
      RETURN lvl_count;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (
            -20003,
               'Phase='
            || phase
            || ' PKG_DESIGN '
            || SQLERRM
         );
      WHEN OTHERS
      THEN
         raise_application_error (
            -20003,
               'Phase='
            || phase
            || ' PKG_DESIGN '
            || SQLERRM
         );
   END;


-----------------------------------------------------
--
-----------------------------------------------------

   ----------------------------------------------------
--
----------------------------------------------------
   FUNCTION plan_assy_explosion_oneself (
      p_plan_date       IN   DATE,
      p_plan_sequence   IN   NUMBER,
      p_org             IN   NUMBER
   )
      RETURN NUMBER
   IS
      lvl_session_id           NUMBER;
      lvl_routing_session_id   NUMBER;
      lvd_datelimit            DATE          := TO_DATE (
                                                   '9999/12/31',
                                                   'yyyy/mm/dd'
                                                );
      lvl_return               NUMBER;
      lvl_count                NUMBER;
      lvs_parent_item_code     VARCHAR2 (20);
      lvs_child_item_code      VARCHAR2 (20);
      lvs_mfs                  VARCHAR2 (20);
      lvs_origin_mfs           VARCHAR2 (20);
      lvs_plan_yyyymm          VARCHAR2 (6);
      lvs_plan_priority        VARCHAR2 (6);
      lvs_shift_code           VARCHAR2 (10);
      lvs_line_code            VARCHAR2 (20);
      lvf_plan_qty             NUMBER;
      lvs_workstage_code       VARCHAR2 (10);
      lvs_machine_code         VARCHAR2 (10);
      lvs_route_no             VARCHAR2 (20);
      lvdb_work_order_no       NUMBER;
      phase                    VARCHAR2 (30);
   BEGIN

--------------------------------------------------
--
--------------------------------------------------
      phase := 10;

      BEGIN
         SELECT parent_item_code,
                item_code,
                mfs,
                origin_mfs,
                plan_yyyymm,
                plan_priority,
                shift_code,
                line_code,
                order_qty,
                machine_code,
                workstage_code,
                route_no
           INTO lvs_parent_item_code,
                lvs_child_item_code,
                lvs_mfs,
                lvs_origin_mfs,
                lvs_plan_yyyymm,
                lvs_plan_priority,
                lvs_shift_code,
                lvs_line_code,
                lvf_plan_qty,
                lvs_machine_code,
                lvs_workstage_code,
                lvs_route_no
           FROM ip_assembly_master_plan
          WHERE plan_date = p_plan_date
            AND plan_date_sequence = p_plan_sequence
            AND organization_id = p_org;
         phase := 20;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20003, SQLERRM);
      END;

      phase := 30;
      lvl_session_id :=
            pkg_design.bom_oneself_assy_explosion (
               lvs_child_item_code,
               TRUNC (SYSDATE),
               p_org
            );
      phase := 40;

      IF lvl_session_id < 0
      THEN
         RETURN lvl_session_id;
      END IF;

      phase := 50;


--------------------------------------------------
--
--------------------------------------------------
      BEGIN
         SELECT COUNT (*)
           INTO lvl_count
           FROM id_eng_bom_temp
          WHERE session_id = lvl_session_id;
         phase := 60;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (
               -20003,
                  'BOM Explosion Result Not Found '
               || SQLERRM
            );
      END;

      IF lvl_count = 0
      THEN
         raise_application_error (
            -20003,
               'BOM Explosion Result Not Found '
            || SQLERRM
         );

--      ELSE
--          RAISE_APPLICATION_ERROR( -20003 , lvl_count ) ;
      END IF;

      phase := 70;

      DELETE FROM im_item_work_order
            WHERE plan_date = p_plan_date
              AND plan_date_sequence = p_plan_sequence
              AND organization_id = p_org;

      phase := 80;
      SELECT seq_work_order_no.NEXTVAL
        INTO lvdb_work_order_no
        FROM DUAL;


 ------------------------------------
-- Issue Plan  Generate
------------------------------------
      INSERT INTO im_item_work_order
                  (mfs,
                   origin_mfs,
                   work_order_no,
                   organization_id,
                   plan_yyyymm,
                   plan_date,
                   plan_date_sequence,
                   plan_priority,
                   item_code,
                   item_type,
                   line_type,
                   issue_type,
                   issue_division,
                   issue_plan_qty,
                   issue_qty,
                   issue_account,
                   issue_status,
                   issue_date,
                   model_unit_qty,
                   shift_code,
                   line_code,
                   work_order_type,
                   workstage_code,
                   parent_item_code,
                   last_modify_date,
                   last_modify_by,
                   enter_date,
                   enter_by,
                   route_no
                  )
         SELECT lvs_mfs,
                lvs_origin_mfs,
                lvdb_work_order_no,
                a.organization_id,
                lvs_plan_yyyymm, --PLAN_YYYYMM,
                p_plan_date, --PLAN_DATE,
                p_plan_sequence,
                lvs_plan_priority, --PLAN_PRIORITY,
                a.child_item_code,
                a.item_type,
                a.line_type,
                'N' issue_type,
                'P',
                --issue_division,
                lvf_plan_qty * model_unit_qty, --ISSUE_PLAN_QTY,
                0, --ISSUE_QTY,
                'M001', --ISSUE_ACCOUNT,
                'N', --ISSUE_STATUS,
                p_plan_date, --ISSUE_DATE,
                model_unit_qty,
                lvs_shift_code, --SHIFT_CODE,
                lvs_line_code, --LINE_CODE,
                'N', --work_order_type,
                NVL (b.trans_workstage_code, '*'),
                lvs_parent_item_code,
                SYSDATE, --LAST_MODIFY_DATE,
                'SYSTEM', --LAST_MODIFY_BY,
                SYSDATE, --ENTER_DATE,
                'SYSTEM', --ENTER_BY
                lvs_route_no
           FROM id_eng_bom_temp a, ip_product_routing b, id_item c
          WHERE a.session_id = lvl_session_id
            AND a.line_type <> 'T'
            AND a.child_item_code = c.item_code
            AND a.organization_id = c.organization_id
            AND c.route_no = b.route_no(+)
            AND c.organization_id = b.organization_id(+)
            AND b.transfer_type IN ('S');

      phase := 90;


-----------------------------------------------------
-- Generate Workstage Transfer Plan Start
-----------------------------------------------------
      BEGIN
         SELECT COUNT (*)
           INTO lvl_count
           FROM ip_product_routing
          WHERE route_no = lvs_route_no;
         phase := 100;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (
               -20003,
                  lvs_route_no
               || ' Routing Explosion Result Not Found '
               || SQLERRM
            );
      END;

      IF lvl_count = 0
      THEN
         raise_application_error (
            -20003,
               lvs_route_no
            || ' Routing Explosion Result Not Found '
            || SQLERRM
         );
      END IF;


-----------------------------------------------------
--
-----------------------------------------------------
      INSERT INTO im_item_workstage_issue_plan
                  (issue_date,
                   issue_sequence,
                   organization_id,
                   mfs,
                   mfs_connect,
                   work_order_no,
                   invoice_no,
                   item_code,
                   item_type,
                   line_type,
                   line_code,
                   dest_line_code,
                   workstage_code,
                   dest_workstage_code,
                   machine_code,
                   issue_plan_qty,
                   issue_qty,
                   issue_weight,
                   bad_weight,
                   loss_weight,
                   scrap_weight,
                   item_unit_weight,
                   transfer_yn,
                   transfer_type,
                   issue_status,
                   product_date,
                   product_sequence,
                   comments,
                   route_no,
                   origin_mfs,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by,
                   issue_deficit
                  )
         SELECT TRUNC (SYSDATE), --ISSUE_DATE,
                seq_workstage_issue_seq.NEXTVAL,
                --ISSUE_SEQUENCE,
                a.organization_id, --ORGANIZATION_ID,
                lvs_mfs, --MFS,
                '', --lvs_origin_mfs, --MFS,
                lvdb_work_order_no,
                '',
                --INVOICE_NO,
                DECODE (bom_level, '1', parent_item_code, a.child_item_code),
                --ITEM_CODE,
                a.item_type, --ITEM_TYPE,
                a.line_type, --LINE_TYPE,
                lvs_line_code, --LINE_CODE,
                lvs_line_code,
                NVL (b.workstage_code, '*'), --WORKSTAGE_CODE,
                NVL (b.trans_workstage_code, '*'), --DEST_WORKSTAGE_CODE,
                '*', --MACHINE_CODE,
                lvf_plan_qty * model_unit_qty, --ISSUE_PLAN_QTY,
                0, --ISSUE_QTY,
                0, --ISSUE_WEIGHT,
                0, --BAD_WEIGHT,
                0, --LOSS_WEIGHT,
                0, --SCRAP_WEIGHT,
                a.item_unit_qty, --ITEM_UNIT_WEIGHT,
                'N', --TRANSFER_YN,
                transfer_type,
                'N', --ISSUE_STATUS,
                NULL, --PRODUCT_DATE,
                NULL, --PRODUCT_SEQUENCE,
                '*', --COMMENTS,
                b.route_no,
                lvs_origin_mfs,
                SYSDATE, --ENTER_DATE,
                'SYSTEM', --ENTER_BY,
                SYSDATE, --LAST_MODIFY_DATE,
                'SYSTEM', --LAST_MODIFY_BY,
                '3' --ISSUE_DEFICIT
           FROM id_eng_bom_temp a, ip_product_routing b, id_item c
          WHERE a.session_id = lvl_session_id
            AND a.line_type = 'T'
            AND a.organization_id = p_org
            AND a.child_item_code = c.item_code
            AND c.organization_id = p_org
            AND c.dateset <= TRUNC (SYSDATE)
            AND c.dateend >= TRUNC (SYSDATE)
            AND c.route_no = b.route_no(+)
            AND c.organization_id = b.organization_id(+);


-----------------------------------------------------
-- Generate Workstage Issue Plan End
-----------------------------------------------------
      UPDATE ip_assembly_master_plan
         SET plan_transfer_yn = 'Y'
       WHERE plan_date = p_plan_date
         AND plan_date_sequence = p_plan_sequence
         AND organization_id = p_org;

      DELETE FROM id_eng_bom_temp
            WHERE session_id = lvl_session_id;

      phase := 100;
      RETURN lvl_count;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (
            -20003,
               'Phase='
            || phase
            || ' PKG_DESIGN '
            || SQLERRM
         );
      WHEN OTHERS
      THEN
         raise_application_error (
            -20003,
               'Phase='
            || phase
            || ' PKG_DESIGN '
            || SQLERRM
         );
   END;


----------------------------------------------------
--
----------------------------------------------------
   FUNCTION plan_assy_plan_gen (
      p_plan_date       IN   DATE,
      p_plan_sequence   IN   NUMBER,
      p_org             IN   NUMBER
   )
      RETURN NUMBER
   IS
      lvl_session_id          NUMBER;
      lvd_datelimit           DATE          := TO_DATE (
                                                  '9999/12/31',
                                                  'yyyy/mm/dd'
                                               );
      lvl_return              NUMBER;
      lvl_count               NUMBER;
      lvs_parent_item_code    VARCHAR2 (20);
      lvs_mfs                 VARCHAR2 (20);
      lvs_origin_mfs          VARCHAR2 (20);
      lvs_plan_yyyymm         VARCHAR2 (6);
      lvs_plan_priority       VARCHAR2 (10);
      lvs_shift_code          VARCHAR2 (10);
      lvs_line_code           VARCHAR2 (20);
      lvf_plan_qty            NUMBER;
      lvs_workstage_code      VARCHAR2 (10);
      lvs_machine_code        VARCHAR2 (30);
      lvs_route_no            VARCHAR2 (20);
      lvs_work_division       VARCHAR2 (1);
      lvs_customer_code       VARCHAR2 (20);
      lvs_customer_order_no   VARCHAR2 (30);
      phase                   VARCHAR2 (10);
   BEGIN

--------------------------------------------------
--
--------------------------------------------------
      phase := 10;

      BEGIN
         SELECT item_code,
                mfs,
                origin_mfs,
                plan_yyyymm,
                plan_priority,
                shift_code,
                line_code,
                order_qty,
                route_no,
                machine_code,
                work_division,
                customer_code,
                customer_order_no
           INTO lvs_parent_item_code,
                lvs_mfs,
                lvs_origin_mfs,
                lvs_plan_yyyymm,
                lvs_plan_priority,
                lvs_shift_code,
                lvs_line_code,
                lvf_plan_qty,
                lvs_route_no,
                lvs_machine_code,
                lvs_work_division,
                lvs_customer_code,
                lvs_customer_order_no
           FROM ip_product_master_plan
          WHERE plan_date = p_plan_date
            AND plan_date_sequence = p_plan_sequence
            AND organization_id = p_org;
         phase := 20;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20003, SQLERRM);
      END;

      phase := 30;
      lvl_session_id := pkg_design.bom_explosion (
                           lvs_parent_item_code,
                           TRUNC (SYSDATE),
                           p_org
                        );
      phase := 40;

      IF lvl_session_id < 0
      THEN
         RETURN lvl_session_id;
      END IF;

      phase := 50;


--------------------------------------------------
-- Extract Assy from BOm
--------------------------------------------------
      BEGIN
         SELECT COUNT (*)
           INTO lvl_count
           FROM id_eng_bom_temp
          WHERE session_id = lvl_session_id
            AND line_type = 'T'
            AND bom_level >= '2';
         phase := 60;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (
               -20003,
                  'BOM Explosion Result Not Found '
               || SQLERRM
            );
      END;

      IF lvl_count = 0
      THEN
         raise_application_error (
            -20003,
               'BOM Explosion Result Not Found '
            || SQLERRM
         );
      END IF;

      phase := 70;

      INSERT INTO ip_assembly_master_plan
                  (plan_date,
                   plan_date_sequence,
                   organization_id,
                   plan_yyyymm,
                   mfs,
                   parent_item_code,
                   item_code,
                   plan_priority,
                   plan_time,
                   product_line_type,
                   workstage_code,
                   machine_code,
                   line_code,
                   work_division,
                   order_qty,
                   product_actual_qty,
                   customer_code,
                   customer_order_no,
                   shipping_account,
                   delivery_date,
                   origin_mfs,
                   shift_code,
                   plan_transfer_yn,
                   plan_status,
                   enter_by,
                   enter_date,
                   last_modify_by,
                   last_modify_date,
                   route_no,
                   plan_transfer_type
                  )
         SELECT p_plan_date, --PLAN_DATE,
                seq_assembly_plan_date_seq.NEXTVAL,
                a.organization_id,
                lvs_plan_yyyymm, --PLAN_YYYYMM,
                f_get_any_no ('MFS', a.organization_id),
                a.parent_item_code,
                a.child_item_code,
                lvs_plan_priority, --PLAN_PRIORITY,
                '0800',
                a.line_type,
                a.workstage_code,
                lvs_machine_code,
                lvs_line_code,
                lvs_work_division,
                lvf_plan_qty * a.model_unit_qty,
                --PLAN_QTY,
                0,
                lvs_customer_code,
                lvs_customer_order_no, --customer order no
                'M001',
                --ISSUE_ACCOUNT,
                p_plan_date, --delivery date
                lvs_mfs,
                lvs_shift_code, --SHIFT_CODE,
                'N',
                'W',
                'SYSTEM', --LAST_MODIFY_BY,
                SYSDATE,
                --LAST_MODIFY_DATE,
                'SYSTEM', --ENTER_BY
                SYSDATE, --ENTER_DATE,
                b.route_no,
                'P' -- FROM PLAN
           FROM id_eng_bom_temp a, id_item b
          WHERE a.session_id = lvl_session_id
            AND a.child_item_code IN (SELECT item_code
                                        FROM id_item
                                       WHERE organization_id = p_org)
            AND a.line_type = 'T'
            AND a.bom_level >= '2'
            AND a.child_item_code = b.item_code
            AND a.organization_id = b.organization_id
            AND b.dateset <= TRUNC (SYSDATE)
            AND b.dateend >= TRUNC (SYSDATE);

      phase := 90;

      UPDATE ip_product_master_plan
         SET assy_exp_yn = 'Y',
             assy_exp_date = TRUNC (SYSDATE)
       WHERE plan_date = p_plan_date
         AND plan_date_sequence = p_plan_sequence
         AND organization_id = p_org;

      RETURN lvl_count;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (
            -20003,
               'Phase='
            || phase
            || ' PKG_PLANNING '
            || SQLERRM
         );
      WHEN OTHERS
      THEN
         raise_application_error (
            -20003,
               'Phase='
            || phase
            || ' PKG_PLANNING '
            || SQLERRM
         );
   END;


----------------------------------------------------------------
-- wire assembly plan generate
----------------------------------------------------------------
   FUNCTION plan_assy_plan_gen_oneself (
      p_plan_date       IN   DATE,
      p_plan_sequence   IN   NUMBER,
      p_line_code       IN   VARCHAR2,
      p_org             IN   NUMBER
   )
      RETURN NUMBER
   IS
      lvl_session_id          NUMBER;
      lvd_datelimit           DATE          := TO_DATE (
                                                  '9999/12/31',
                                                  'yyyy/mm/dd'
                                               );
      lvl_return              NUMBER;
      lvl_count               NUMBER;
      lvs_parent_item_code    VARCHAR2 (20);
      lvs_mfs                 VARCHAR2 (20);
      lvs_origin_mfs          VARCHAR2 (20);
      lvs_plan_yyyymm         VARCHAR2 (6);
      lvs_plan_priority       VARCHAR2 (6);
      lvs_shift_code          VARCHAR2 (10);
      lvs_line_code           VARCHAR2 (20);
      lvf_plan_qty            NUMBER;
      lvs_workstage_code      VARCHAR2 (10);
      lvs_machine_code        VARCHAR2 (30);
      lvs_route_no            VARCHAR2 (20);
      lvs_work_division       VARCHAR2 (1);
      lvs_customer_code       VARCHAR2 (20);
      lvs_customer_order_no   VARCHAR2 (30);
      phase                   VARCHAR2 (10);
   BEGIN

--------------------------------------------------
--
--------------------------------------------------
      phase := 10;

      BEGIN
         SELECT item_code,
                mfs,
                origin_mfs,
                plan_yyyymm,
                plan_priority,
                shift_code,
                line_code,
                order_qty,
                route_no,
                machine_code,
                work_division,
                customer_code,
                customer_order_no
           INTO lvs_parent_item_code,
                lvs_mfs,
                lvs_origin_mfs,
                lvs_plan_yyyymm,
                lvs_plan_priority,
                lvs_shift_code,
                lvs_line_code,
                lvf_plan_qty,
                lvs_route_no,
                lvs_machine_code,
                lvs_work_division,
                lvs_customer_code,
                lvs_customer_order_no
           FROM ip_product_master_plan
          WHERE plan_date = p_plan_date
            AND plan_date_sequence = p_plan_sequence
            AND organization_id = p_org;
         phase := 20;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20003, SQLERRM);
      END;

      phase := 30;
      lvl_session_id := pkg_design.bom_explosion_all (
                           lvs_parent_item_code,
                           TRUNC (SYSDATE),
                           p_org
                        );
      phase := 40;

      IF lvl_session_id < 0
      THEN
         RETURN lvl_session_id;
      END IF;

      phase := 50;


--------------------------------------------------
-- Extract Assy from BOm
--------------------------------------------------
      BEGIN
         SELECT COUNT (*)
           INTO lvl_count
           FROM id_eng_bom_temp
          WHERE session_id = lvl_session_id
            AND line_type = 'T'
            AND bom_level > '2';
         phase := 60;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (
               -20003,
                  'BOM Explosion Result Not Found '
               || SQLERRM
            );
      END;

      IF lvl_count = 0
      THEN
         raise_application_error (
            -20100,
               'BOM Explosion Result Not Found '
            || SQLERRM
         );
      END IF;

      phase := 70;

      INSERT INTO ip_assembly_master_plan
                  (plan_date,
                   plan_date_sequence,
                   organization_id,
                   plan_yyyymm,
                   mfs,
                   parent_item_code,
                   item_code,
                   plan_priority,
                   plan_time,
                   product_line_type,
                   workstage_code,
                   machine_code,
                   line_code,
                   work_division,
                   order_qty,
                   product_actual_qty,
                   customer_code,
                   customer_order_no,
                   shipping_account,
                   delivery_date,
                   origin_mfs,
                   shift_code,
                   plan_transfer_yn,
                   plan_status,
                   enter_by,
                   enter_date,
                   last_modify_by,
                   last_modify_date,
                   route_no
                  )
         SELECT p_plan_date, --PLAN_DATE,
                seq_assembly_plan_date_seq.NEXTVAL,
                a.organization_id,
                lvs_plan_yyyymm, --PLAN_YYYYMM,
                f_get_any_no ('MFS', a.organization_id),
                lvs_parent_item_code,
                a.parent_item_code,
                lvs_plan_priority, --PLAN_PRIORITY,
                '0800',
                a.line_type,
                a.workstage_code,
                lvs_machine_code,
                p_line_code,
                --lvs_line_code,
                lvs_work_division,
                lvf_plan_qty * a.model_unit_qty,
                --PLAN_QTY,
                0,
                lvs_customer_code,
                lvs_customer_order_no, --customer order no
                'M001',
                --ISSUE_ACCOUNT,
                p_plan_date, --delivery date
                lvs_mfs,
                lvs_shift_code, --SHIFT_CODE,
                'N',
                'W',
                'SYSTEM', --LAST_MODIFY_BY,
                SYSDATE,
                --LAST_MODIFY_DATE,
                'SYSTEM', --ENTER_BY
                SYSDATE, --ENTER_DATE,
                b.route_no
           FROM id_eng_bom_temp a, id_item b
          WHERE a.session_id = lvl_session_id
            AND a.child_item_code IN (SELECT item_code
                                        FROM id_item
                                       WHERE organization_id = p_org)
            AND a.line_type = 'T'
            AND a.bom_level > '2'
            AND a.child_item_code = b.item_code
            AND a.organization_id = b.organization_id
            AND b.dateset <= TRUNC (SYSDATE)
            AND b.dateend >= TRUNC (SYSDATE);

      phase := 90;

      UPDATE ip_product_master_plan
         SET assy_exp_yn = 'Y',
             assy_exp_date = TRUNC (SYSDATE)
       WHERE plan_date = p_plan_date
         AND plan_date_sequence = p_plan_sequence
         AND organization_id = p_org;

      RETURN lvl_count;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (
            -20003,
               'Phase='
            || phase
            || ' PKG_PLANNING '
            || SQLERRM
         );
      WHEN OTHERS
      THEN
         raise_application_error (
            -20003,
               'Phase='
            || phase
            || ' PKG_PLANNING '
            || SQLERRM
         );
   END;


-----------------------------------------------
-- Product Child Item Issue
--
-----------------------------------------------
   FUNCTION plan_prod_child_item_issue (
      p_product_date         IN   DATE,
      p_product_sequence     IN   NUMBER,
      p_mfs                  IN   VARCHAR2,
      p_item_code            IN   VARCHAR2,
      p_line_code            IN   VARCHAR2,
      p_workstage_code       IN   VARCHAR2,
      p_machine_code         IN   VARCHAR2,
      p_product_result_qty   IN   NUMBER,
      p_result_status        IN   VARCHAR2,
      p_org                  IN   NUMBER
   )
      RETURN NUMBER
   AS
      lvi_count                NUMBER;
      lvi_seq                  NUMBER;
      lvl_session_id           NUMBER;
      lvl_product_result_qty   NUMBER;
      lvf_issue_price          NUMBER;
      lvs_material_mfs         VARCHAR2 (30);
      lvl_bom_level            NUMBER;
      lvs_config_value         VARCHAR2 (1);
      lvs_prie_type_value      VARCHAR2 (1);
      phase                    VARCHAR2 (10);

      CURSOR cl1
      IS
         SELECT parent_item_code,
                child_item_code,
                model_unit_qty,
                item_type,
                line_type
           FROM id_eng_bom_temp
          WHERE session_id = lvl_session_id;

      v_rows                   cl1%ROWTYPE;
   BEGIN
      IF    p_product_result_qty = 0
         OR p_product_result_qty IS NULL
      THEN
         raise_application_error (
            -20003,
               'PHASE='
            || phase
            || ' Product Result Qty Invalid '
            || SQLERRM
         );
      END IF;
--raise_application_error( -20004 , p_product_result_qty ) ;
      phase := '10';
------------------------------------
-- SYSTEM CONFIG VALUE GET
-- CURRENT VALUE = Y
------------------------------------
      BEGIN
         SELECT NVL(config_value, 'N')
           INTO lvs_config_value
           FROM isys_config
          WHERE config_name = 'WORKODER_GEN_BY_PROD_PLAN'
            AND use_yn = 'Y'
            AND organization_id = p_org;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            lvs_config_value := 'N';
         WHEN OTHERS
         THEN
            raise_application_error (-20003, SQLERRM);
      END;

      phase := '20';

      IF    lvs_config_value = 'N'
         OR lvs_config_value IS NULL
      THEN
         lvl_bom_level := 2;
      ELSIF lvs_config_value = 'X'
      THEN
         lvl_bom_level := 0;
      ELSE
         lvl_bom_level := 1000;
      END IF;

      phase := '30';


------------------------------------
-- SYSTEM CONFIG VALUE GET
-- CURRENT VALUE = Y
------------------------------------
      BEGIN
         SELECT NVL (config_value, 'B')
           INTO lvs_prie_type_value
           FROM isys_config
          WHERE config_name = 'PRODUCT_RECEIPT_PRICE_TYPE'
            AND use_yn = 'Y'
            AND organization_id = p_org;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            lvs_prie_type_value := 'B';
         WHEN OTHERS
         THEN
            raise_application_error (-20003, SQLERRM);
      END;

      phase := '40';

-----------------------------------------------------------
-- Check Isuse Deficit
-----------------------------------------------------------
      IF p_result_status = 'C'
      THEN
         lvl_product_result_qty := ABS (p_product_result_qty) * -1;
      ELSE
         lvl_product_result_qty := ABS (p_product_result_qty);
      END IF;

      phase := '50';

-----------------------------------------------------------
--
-----------------------------------------------------------
/*      IF p_result_status = 'C'
      THEN

---------------------------------------------
-- IF  AUTO ISSUE ITEM THEN
---------------------------------------------
         lvi_count := 0;

         BEGIN
            SELECT COUNT (*)
              INTO lvi_count
              FROM id_item
             WHERE item_code = v_rows.child_item_code
               AND auto_issue_yn = 'Y'
               AND organization_id = p_org;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               lvi_count := 0;
         END;

         phase := '60';

         IF lvi_count = 1
         THEN
            INSERT INTO im_item_issue
                        (issue_date,
                         issue_sequence,
                         organization_id,
                         mfs,
                         item_code,
                         location_code,
                         item_type,
                         line_code,
                         workstage_code,
                         issue_deficit,
                         issue_qty,
                         issue_status,
                         issue_amt,
                         issue_account,
                         line_type,
                         comments,
                         issue_price,
                         virtual_receipt_yn,
                         issue_type,
                         supplier_code,
                         work_order_no,
                         enter_date,
                         enter_by,
                         last_modify_date,
                         last_modify_by,
                         machine_code,
                         invoice_no,
                         made_by,
                         parent_item_code,
                         material_mfs,
                         interface_yn,
                         interface_date,
                         sale_price,
                         sale_amt,
                         sale_currency,
                         arrival_date,
                         arrival_seq_no,
                         dest_organization_id,
                         inspect_no,
                         return_request_date,
                         return_request_sequence
                        )
               SELECT p_product_date, --issue_date,
                      seq_mat_issue.NEXTVAL,
                      p_org,
                      p_mfs,
                      item_code,
                      '*',
                      item_type,
                      line_code,
                      workstage_code,
                      4,
                      issue_qty * -1,
                      'N',
                      issue_amt * -1,
                      'M001',
                      line_type,
                      '*',
                      issue_price,
                      'N',
                      'N',
                      '*',
                      '*',
                      SYSDATE,
                      'SYSTEM',
                      SYSDATE,
                      'SYSTEM',
                      machine_code,
                      '*',
                      '*',
                      parent_item_code,
                      '*',
                      'N',
                      NULL,
                      0,
                      0,
                      NULL,
                      NULL,
                      NULL,
                      NULL,
                      NULL,
                      NULL,
                      NULL
                 FROM im_item_workstage_issue
                WHERE product_date = p_product_date
                  AND product_sequence = p_product_sequence
                  AND item_code <> p_item_code
                  AND organization_id = p_org;
         END IF;

         phase := '70';

---------------------------------------------
--
---------------------------------------------
         UPDATE im_item_workstage_issue
            SET issue_status = 'C'
          WHERE product_date = p_product_date
            AND product_sequence = p_product_sequence
            AND item_code <> p_item_code
            AND organization_id = p_org;

         INSERT INTO im_item_workstage_issue
                     (issue_date,
                      issue_sequence,
                      organization_id,
                      mfs,
                      material_mfs,
                      line_code,
                      workstage_code,
                      machine_code,
                      item_code,
                      item_type,
                      line_type,
                      issue_deficit,
                      issue_account,
                      issue_price,
                      issue_qty,
                      real_issue_qty,
                      issue_amt,
                      real_issue_amt,
                      issue_type,
                      product_date,
                      product_sequence,
                      issue_status,
                      enter_by,
                      enter_date,
                      last_modify_by,
                      last_modify_date,
                      sub_mfs,
                      parent_item_code,
                      origin_item_code,
                      origin_material_mfs
                     )
            SELECT TRUNC (SYSDATE),
                   seq_workstage_issue_seq.NEXTVAL,
                   organization_id,
                   mfs,
                   material_mfs,
                   line_code,
                   workstage_code,
                   machine_code,
                   item_code,
                   item_type,
                   line_type,
                   4, --issue_deficit,
                   issue_account,
                   issue_price,
                   issue_qty * -1,
                   real_issue_qty * -1,
                   issue_amt * -1,
                   real_issue_amt * -1,
                   issue_type,
                   product_date,
                   product_sequence,
                   'C', --issue_status,
                   enter_by,
                   enter_date,
                   last_modify_by,
                   last_modify_date,
                   sub_mfs,
                   parent_item_code,
                   origin_item_code,
                   origin_material_mfs
              FROM im_item_workstage_issue
             WHERE product_date = p_product_date
               AND product_sequence = p_product_sequence
               AND item_code <> p_item_code
               AND organization_id = p_org;

         phase := '80';

-------------------------------------------------------------
--  New OR UPDATE ADD Insert
-------------------------------------------------------------
      ELSE
*/
      phase := 10;
      lvl_session_id :=
                 pkg_design.bom_explosion (p_item_code, p_product_date, p_org);
      phase := '90';

      IF lvl_session_id < 0
      THEN
         raise_application_error (
            -20003,
               'PHASE='
            || phase
            || ' BOM EXLOSION (pkg_design.bom_explosion) NOT FOUND '
            || SQLERRM
         );
         RETURN lvl_session_id;
      ELSE
         phase := '100';

         DELETE FROM id_eng_bom_temp
               WHERE session_id = lvl_session_id
                 AND bom_level = 1;

         DELETE FROM id_eng_bom_temp
               WHERE session_id = lvl_session_id
                 AND item_type IN ('M', 'S');

--------------------------------------------------
--
--------------------------------------------------
         DELETE FROM id_eng_bom_temp
               WHERE session_id = lvl_session_id
                 AND bom_level > lvl_bom_level;

         DELETE FROM id_eng_bom_temp
            WHERE session_id = lvl_session_id
              AND workstage_code  <> p_workstage_code ;


      END IF;

-----------------------------------------------------------
--
-----------------------------------------------------------
      phase := '110';

      BEGIN
         SELECT COUNT (*)
           INTO lvi_count
           FROM id_eng_bom_temp
          WHERE session_id = lvl_session_id;

         IF lvi_count = 0
         THEN
            NULL;
         --MODIFY BY YOUHS 20100328
         --   raise_application_error (-20003,
         --                               'PHASE='
         --                            || phase
         --                            || ' BOM EXLOSION RESULT NOT FOUND '
         --                            || SQLERRM
         --                           );
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      --              raise_application_error (-20003,
      --                                          'PHASE='
      --                                       || phase
      --                                       || ' BOM EXLOSION RESULT NOT FOUND '
      --                                       || SQLERRM
      --                                      );
      END;

      phase := '120';
      OPEN cl1;

      LOOP
         FETCH cl1 INTO v_rows;

         IF cl1%NOTFOUND
         THEN
            CLOSE cl1;
            EXIT;
         END IF;

         phase := '130';

         IF v_rows.line_type = 'T'
         THEN
            lvf_issue_price :=
                  pkg_design.bom_material_cost (
                     v_rows.child_item_code /*IN VARCHAR2*/,
                     p_product_date /*IN DATE*/,
                     lvs_prie_type_value /*IN VARCHAR2*/,
                     p_org                                       /*IN NUMBER*/
                  );
         --              lvf_issue_price :=
         --                    f_get_assy_inventory_price(
         --                       v_rows.child_item_code,   /*IN VARCHAR2*/
         --                       v_rows.line_type,         /*IN VARCHAR2*/
         --                       p_org                     /*IN NUMBER*/
         --                    );
         ELSE
            lvf_issue_price :=
                  f_get_mat_inventory_price (
                     v_rows.child_item_code,                   /*IN VARCHAR2*/
                     v_rows.line_type,                         /*IN VARCHAR2*/
                     p_org
                  /*IN NUMBER*/
                  );
         END IF;

         phase := '140';

--raise_application_error(-2003 , p_result_status||' '||lvl_product_result_qty ) ;


---------------------------------------------
-- IF  AUTO ISSUE ITEM THEN
---------------------------------------------
 /*        lvi_count := 0;

         BEGIN
            SELECT COUNT (*)
              INTO lvi_count
              FROM id_item
             WHERE item_code = v_rows.child_item_code
               AND auto_issue_yn = 'Y'
               AND organization_id = p_org;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               lvi_count := 0;
         END;

         IF lvi_count = 1
         THEN
            INSERT INTO im_item_issue
                        (issue_date,
                         issue_sequence,
                         organization_id,
                         mfs,
                         item_code,
                         location_code,
                         item_type,
                         line_code,
                         workstage_code,
                         issue_deficit,
                         issue_qty,
                         issue_status,
                         issue_amt,
                         issue_account,
                         line_type,
                         comments,
                         issue_price,
                         virtual_receipt_yn,
                         issue_type,
                         supplier_code,
                         work_order_no,
                         enter_date,
                         enter_by,
                         last_modify_date,
                         last_modify_by,
                         machine_code,
                         invoice_no,
                         made_by,
                         parent_item_code,
                         material_mfs,
                         interface_yn,
                         interface_date,
                         sale_price,
                         sale_amt,
                         sale_currency,
                         arrival_date,
                         arrival_seq_no,
                         dest_organization_id,
                         inspect_no,
                         return_request_date,
                         return_request_sequence
                        )
                 VALUES (p_product_date, --issue_date,
                         seq_mat_issue.NEXTVAL,
                         p_org,
                         p_mfs, --mfs,
                         v_rows.child_item_code, --item_code,
                         'M01' , --'*', --location_code,
                         v_rows.item_type, --item_type,
                         p_line_code, --line_code,
                         p_workstage_code, --workstage_code,
                         DECODE (p_result_status, 'C', 4, 3), --issue_deficit,
                         v_rows.model_unit_qty * lvl_product_result_qty, --issue_qty,
                         'N', --issue_status,
                           v_rows.model_unit_qty
                         * lvl_product_result_qty
                         * lvf_issue_price, --issue_amt,
                         'M001', --issue_account,
                         v_rows.line_type, --line_type,
                         '*', --comments,
                         lvf_issue_price, --issue_price,
                         'N', --virtual_receipt_yn,
                         'N', --issue_type,
                         '*', --supplier_code,
                         '*', --work_order_no,
                         SYSDATE, --enter_date,
                         'SYSTEM', --enter_by,
                         SYSDATE, --last_modify_date,
                         'SYSTEM', --last_modify_by,
                         p_machine_code, --machine_code,
                         seq_issue_invoice_sequence.NEXTVAL, --invoice_no,
                         '*', --made_by,
                         v_rows.parent_item_code, --parent_item_code,
                         '*', --material_mfs,
                         'N', --interface_yn,
                         NULL, --interface_date,
                         0, --sale_price,
                         0, --sale_amt,
                         NULL, --sale_currency,
                         NULL, --arrival_date,
                         NULL, --arrival_seq_no,
                         NULL, --dest_organization_id,
                         NULL, --inspect_no,
                         NULL, --return_request_date,
                         NULL --return_request_sequence
                        );
         END IF;
*/
         phase := '150';


---------------------------------------------
-- issue from workstage by product result
---------------------------------------------

         BEGIN
            SELECT COUNT (*)
              INTO lvi_count
              FROM im_item_workstage_issue
             WHERE item_code = v_rows.child_item_code
               AND line_type = v_rows.line_type
               AND line_code = p_line_code
               AND workstage_code = p_workstage_code
               AND mfs = p_mfs
               AND product_date = p_product_date
               AND product_sequence = p_product_sequence
               AND organization_id = p_org;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               lvi_count := 0;
         END;

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
     --    RAISE_APPLICATION_ERROR( -20009 ,'DATE='||p_product_date||' COUNT= '||lvi_count ) ;

         IF lvi_count > 0
         THEN
            UPDATE im_item_workstage_issue
               SET issue_qty =   issue_qty
                               +   v_rows.model_unit_qty
                                 * lvl_product_result_qty,
                   real_issue_qty =   real_issue_qty
                                    +   v_rows.model_unit_qty
                                      * lvl_product_result_qty,
                   issue_amt =   issue_amt
                               + real_issue_qty
                               +   v_rows.model_unit_qty
                                 * lvl_product_result_qty
                                 * lvf_issue_price,
                   real_issue_amt =   real_issue_amt
                                    + real_issue_qty
                                    +   v_rows.model_unit_qty
                                      * lvl_product_result_qty
                                      * lvf_issue_price
             WHERE item_code = v_rows.child_item_code
               AND line_type = v_rows.line_type
               AND line_code = p_line_code
               AND workstage_code = p_workstage_code
               AND mfs = p_mfs
               AND product_date = p_product_date
               AND product_sequence = p_product_sequence
               AND organization_id = p_org;

            phase := '160';
            ---------------------------------------------
            --
            ---------------------------------------------
            DELETE FROM im_item_workstage_issue
                  WHERE item_code = v_rows.child_item_code
                    AND line_type = v_rows.line_type
                    AND line_code = p_line_code
                    AND workstage_code = p_workstage_code
                    AND mfs = p_mfs
                    AND product_date = p_product_date
                    AND product_sequence = p_product_sequence
                    AND organization_id = p_org
                    AND issue_qty = 0;
         ELSE

            INSERT INTO im_item_workstage_issue
                        (issue_date,
                         issue_sequence,
                         organization_id,
                         mfs,
                         material_mfs,
                         line_code,
                         workstage_code,
                         machine_code,
                         item_code,
                         item_type,
                         line_type,
                         issue_deficit,
                         issue_account,
                         issue_price,
                         issue_qty,
                         real_issue_qty,
                         issue_amt,
                         real_issue_amt,
                         issue_type,
                         product_date,
                         product_sequence,
                         issue_status,
                         enter_by,
                         enter_date,
                         last_modify_by,
                         last_modify_date,
                         sub_mfs,
                         parent_item_code
                        )
                 VALUES (p_product_date,
                         seq_workstage_issue_seq.NEXTVAL,
                         p_org,
                         p_mfs,
                         '*', --lvs_material_mfs ,
                         p_line_code,
                         p_workstage_code,
                         p_machine_code,
                         v_rows.child_item_code,
                         v_rows.item_type,
                         v_rows.line_type,
                         DECODE (p_result_status, 'N', 3, 4),
                         'M001',
                         --ISSUE ACCOUNT
                         lvf_issue_price, --ISSUE_PRICE
                         v_rows.model_unit_qty * lvl_product_result_qty,
                         v_rows.model_unit_qty * lvl_product_result_qty,
                           lvf_issue_price
                         * v_rows.model_unit_qty
                         * lvl_product_result_qty, -- ISSUE_AMT
                           lvf_issue_price
                         * v_rows.model_unit_qty
                         * lvl_product_result_qty, -- REAL ISSUE_AMT
                         'N', --ISSUE TYPE
                         p_product_date,
                         p_product_sequence,
                         'N',
                         'SYSTEM',
                         SYSDATE,
                         'SYSTEM',
                         SYSDATE,
                         '',
                         DECODE (
                            lvs_config_value,
                            'N', v_rows.parent_item_code,
                            p_item_code
                         )
                        );
         END IF;

         phase := '170';

-------------------------------------------------------------
--
-------------------------------------------------------------
      END LOOP;

      DELETE FROM id_eng_bom_temp
            WHERE session_id = lvl_session_id;

--      END IF; --CHECK DEFICIT

      phase := '180';
      RETURN 0;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (
            -20003,
               'PHASE='
            || phase
            || '  '
            || SQLERRM
         );
      WHEN OTHERS
      THEN
         raise_application_error (
            -20003,
               'PHASE='
            || phase
            || ' Parent Item Code ='
            || p_item_code
            || ' Child Item Code='
            || v_rows.child_item_code
            || ' '
            || SQLERRM
         );
   END;


-----------------------------------------------
-- Product Child Item Bad Issue
--
-----------------------------------------------
   FUNCTION plan_prod_child_item_bad_issue (
      p_product_date         IN   DATE,
      p_product_sequence     IN   NUMBER,
      p_mfs                  IN   VARCHAR2,
      p_item_code            IN   VARCHAR2,
      p_line_code            IN   VARCHAR2,
      p_workstage_code       IN   VARCHAR2,
      p_machine_code         IN   VARCHAR2,
      p_product_result_qty   IN   NUMBER,
      p_result_status        IN   VARCHAR2,
      p_org                  IN   NUMBER
   )
      RETURN NUMBER
   AS
      lvi_count                NUMBER;
      lvi_seq                  NUMBER;
      lvl_session_id           NUMBER;
      lvl_product_result_qty   NUMBER;
      lvf_issue_price          NUMBER;
      lvs_material_mfs         VARCHAR2 (30);
      lvl_bom_level            NUMBER;
      lvs_config_value         VARCHAR2 (1);
      lvs_prie_type_value      VARCHAR2 (1);
      phase                    NUMBER;

      CURSOR cl1
      IS
         SELECT parent_item_code,
                child_item_code,
                model_unit_qty,
                item_type,
                line_type
           FROM id_eng_bom_temp
          WHERE session_id = lvl_session_id;

      v_rows                   cl1%ROWTYPE;
   BEGIN
      IF    p_product_result_qty = 0
         OR p_product_result_qty IS NULL
      THEN
         raise_application_error (
            -20003,
               'PHASE='
            || phase
            || ' Product Result Qty Invalid '
            || SQLERRM
         );
      END IF;


------------------------------------
-- SYSTEM CONFIG VALUE GET
-- CURRENT VALUE = Y
------------------------------------
      BEGIN
         SELECT NVL (config_value, 'N')
           INTO lvs_config_value
           FROM isys_config
          WHERE config_name = 'WORKODER_GEN_BY_PROD_PLAN'
            AND use_yn = 'Y'
            AND organization_id = p_org;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            lvs_config_value := 'N';
         WHEN OTHERS
         THEN
            raise_application_error (-20003, SQLERRM);
      END;

      IF    lvs_config_value = 'N'
         OR lvs_config_value IS NULL
      THEN
         lvl_bom_level := 2;
      ELSIF lvs_config_value = 'X'
      THEN
         lvl_bom_level := 0;
      ELSE
         lvl_bom_level := 1000;
      END IF;


------------------------------------
-- SYSTEM CONFIG VALUE GET
-- CURRENT VALUE = Y
------------------------------------
      BEGIN
         SELECT NVL (config_value, 'B')
           INTO lvs_prie_type_value
           FROM isys_config
          WHERE config_name = 'PRODUCT_RECEIPT_PRICE_TYPE'
            AND use_yn = 'Y'
            AND organization_id = p_org;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            lvs_prie_type_value := 'B';
         WHEN OTHERS
         THEN
            raise_application_error (-20003, SQLERRM);
      END;


-----------------------------------------------------------
--
-----------------------------------------------------------
      IF p_result_status = 'C'
      THEN
         lvl_product_result_qty := ABS (p_product_result_qty) * -1;
      ELSE
         lvl_product_result_qty := ABS (p_product_result_qty);
      END IF;


-----------------------------------------------------------
--
-----------------------------------------------------------
      IF p_result_status = 'C'
      THEN
         INSERT INTO im_item_workstage_issue
                     (issue_date,
                      issue_sequence,
                      organization_id,
                      mfs,
                      material_mfs,
                      line_code,
                      workstage_code,
                      machine_code,
                      item_code,
                      item_type,
                      line_type,
                      issue_deficit,
                      issue_account,
                      issue_price,
                      issue_qty,
                      real_issue_qty,
                      issue_amt,
                      real_issue_amt,
                      issue_type,
                      product_date,
                      product_sequence,
                      issue_status,
                      enter_by,
                      enter_date,
                      last_modify_by,
                      last_modify_date,
                      sub_mfs,
                      parent_item_code,
                      origin_item_code,
                      origin_material_mfs
                     )
            SELECT TRUNC (SYSDATE),
                   seq_workstage_issue_seq.NEXTVAL,
                   organization_id,
                   mfs,
                   material_mfs,
                   line_code,
                   workstage_code,
                   machine_code,
                   item_code,
                   item_type,
                   line_type,
                   4, --issue_deficit,
                   issue_account,
                   issue_price,
                   issue_qty * -1,
                   real_issue_qty * -1,
                   issue_amt * -1,
                   real_issue_amt * -1,
                   issue_type,
                   product_date,
                   product_sequence,
                   issue_status,
                   enter_by,
                   enter_date,
                   last_modify_by,
                   last_modify_date,
                   sub_mfs,
                   parent_item_code,
                   origin_item_code,
                   origin_material_mfs
              FROM im_item_workstage_issue
             WHERE product_date = p_product_date
               AND product_sequence = p_product_sequence
               AND item_code <> p_item_code
               AND organization_id = p_org;
      ELSE
         phase := 10;
         lvl_session_id :=
                pkg_design.bom_explosion (p_item_code, p_product_date, p_org);

         IF lvl_session_id < 0
         THEN
            raise_application_error (
               -20003,
                  'PHASE='
               || phase
               || ' BOM EXLOSION RESULT NOT FOUND '
               || SQLERRM
            );
            RETURN lvl_session_id;
         ELSE
            phase := 20;

            DELETE FROM id_eng_bom_temp
                  WHERE session_id = lvl_session_id
                    AND bom_level = 1;

            DELETE FROM id_eng_bom_temp
                  WHERE session_id = lvl_session_id
                    AND item_type IN ('M', 'S');


--------------------------------------------------
--
--------------------------------------------------
            DELETE FROM id_eng_bom_temp
                  WHERE session_id = lvl_session_id
                    AND bom_level > lvl_bom_level;
         END IF;


-----------------------------------------------------------
--
-----------------------------------------------------------
         phase := 30;

         BEGIN
            SELECT COUNT (*)
              INTO lvi_count
              FROM id_eng_bom_temp
             WHERE session_id = lvl_session_id;

            IF lvi_count = 0
            THEN
               raise_application_error (
                  -20003,
                     'PHASE='
                  || phase
                  || ' BOM EXLOSION RESULT NOT FOUND '
                  || SQLERRM
               );
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error (
                  -20003,
                     'PHASE='
                  || phase
                  || ' BOM EXLOSION RESULT NOT FOUND '
                  || SQLERRM
               );
         END;

         phase := 40;
         OPEN cl1;

         LOOP
            FETCH cl1 INTO v_rows;

            IF cl1%NOTFOUND
            THEN
               CLOSE cl1;
               EXIT;
            END IF;

            phase := 50;

            IF v_rows.line_type = 'T'
            THEN
               lvf_issue_price :=
                     pkg_design.bom_material_cost (
                        v_rows.child_item_code /*IN VARCHAR2*/,
                        p_product_date /*IN DATE*/,
                        lvs_prie_type_value /*IN VARCHAR2*/,
                        p_org                                    /*IN NUMBER*/
                     );

--               lvf_issue_price :=
--                  f_get_assy_inventory_price
--                                      (v_rows.child_item_code, /*IN VARCHAR2*/
--                                       v_rows.line_type,       /*IN VARCHAR2*/
--                                       p_org                     /*IN NUMBER*/
--                                      );
            ELSE
               lvf_issue_price :=
                     f_get_mat_inventory_price (
                        v_rows.child_item_code,                /*IN VARCHAR2*/
                        v_rows.line_type,                      /*IN VARCHAR2*/
                        p_org                                    /*IN NUMBER*/
                     );
            END IF;

            phase := 60;


-------------------------------------------------
-- issue from workstage by product result
-------------------------------------------------
            INSERT INTO im_item_workstage_issue
                        (issue_date,
                         issue_sequence,
                         organization_id,
                         mfs,
                         material_mfs,
                         line_code,
                         workstage_code,
                         machine_code,
                         item_code,
                         item_type,
                         line_type,
                         issue_deficit,
                         issue_account,
                         issue_price,
                         issue_qty,
                         real_issue_qty,
                         issue_amt,
                         real_issue_amt,
                         issue_type,
                         product_date,
                         product_sequence,
                         issue_status,
                         enter_by,
                         enter_date,
                         last_modify_by,
                         last_modify_date,
                         sub_mfs,
                         parent_item_code
                        )
                 VALUES (TRUNC (SYSDATE),
                         seq_workstage_issue_seq.NEXTVAL,
                         p_org,
                         p_mfs,
                         '*', --lvs_material_mfs ,
                         p_line_code,
                         p_workstage_code,
                         p_machine_code,
                         v_rows.child_item_code,
                         v_rows.item_type,
                         v_rows.line_type,
                         DECODE (p_result_status, 'N', 3, 4),
                         'M002',
                         --ISSUE ACCOUNT
                         lvf_issue_price, --ISSUE_PRICE
                         v_rows.model_unit_qty * lvl_product_result_qty,
                         v_rows.model_unit_qty * lvl_product_result_qty,
                           lvf_issue_price
                         * v_rows.model_unit_qty
                         * lvl_product_result_qty, -- ISSUE_AMT
                           lvf_issue_price
                         * v_rows.model_unit_qty
                         * lvl_product_result_qty, -- REAL ISSUE_AMT
                         'D', --ISSUE TYPE
                         p_product_date,
                         p_product_sequence,
                         'N',
                         'SYSTEM',
                         SYSDATE,
                         'SYSTEM',
                         SYSDATE,
                         '',
                         DECODE (
                            lvs_config_value,
                            'N', v_rows.parent_item_code,
                            p_item_code
                         )
                        );

            phase := 70;

-------------------------------------------------------------
--
-------------------------------------------------------------
         END LOOP;

         DELETE FROM id_eng_bom_temp
               WHERE session_id = lvl_session_id;
      END IF; --check deficit

      phase := 90;
      RETURN 0;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (
            -20003,
               'PHASE='
            || phase
            || '  '
            || SQLERRM
         );
      WHEN OTHERS
      THEN
         raise_application_error (
            -20003,
               'PHASE='
            || phase
            || ' Parent Item Code ='
            || p_item_code
            || ' Child Item Code='
            || v_rows.child_item_code
            || ' '
            || SQLERRM
         );
   END;


-----------------------------------------------
-- Child Item Issue
--
-----------------------------------------------
   FUNCTION plan_child_item_issue (
      p_product_date         IN   DATE,
      p_product_sequence     IN   NUMBER,
      p_mfs                  IN   VARCHAR2,
      p_item_code            IN   VARCHAR2,
      p_line_code            IN   VARCHAR2,
      p_workstage_code       IN   VARCHAR2,
      p_machine_code         IN   VARCHAR2,
      p_product_result_qty   IN   NUMBER,
      p_result_status        IN   VARCHAR2,
      p_org                  IN   NUMBER
   )
      RETURN NUMBER
   AS
      lvi_count                NUMBER;
      lvi_seq                  NUMBER;
      lvl_session_id           NUMBER;
      lvl_product_result_qty   NUMBER;
      lvf_issue_price          NUMBER;
      phase                    NUMBER;

      CURSOR cl1
      IS
         SELECT parent_item_code,
                child_item_code,
                model_unit_qty,
                item_type,
                line_type
           FROM id_eng_bom_temp
          WHERE session_id = lvl_session_id
            AND parent_item_code = p_item_code;

      v_rows                   cl1%ROWTYPE;
   BEGIN
      phase := 10;
      lvl_session_id :=
                pkg_design.bom_explosion (p_item_code, p_product_date, p_org);

      IF lvl_session_id < 0
      THEN
         RETURN lvl_session_id;
      ELSE
         phase := 20;

         --Delete all not in Own's Child item
         DELETE FROM id_eng_bom_temp
               WHERE session_id = lvl_session_id
                 AND line_type = 'T';

         DELETE FROM id_eng_bom_temp
               WHERE session_id = lvl_session_id
                 AND item_type IN ('M', 'S');

         DELETE FROM id_eng_bom_temp
               WHERE session_id = lvl_session_id
                 AND bom_level > 2;
      END IF;

      phase := 30;

      BEGIN
         SELECT COUNT (*)
           INTO lvi_count
           FROM id_eng_bom_temp
          WHERE session_id = lvl_session_id;

         IF lvi_count = 0
         THEN
            raise_application_error (
               -20003,
                  'PHASE='
               || phase
               || ' BOM EXLOSION RESULT NOT FOUND '
               || SQLERRM
            );
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (
               -20003,
                  'PHASE='
               || phase
               || ' BOM EXLOSION RESULT NOT FOUND '
               || SQLERRM
            );
      END;

      IF p_result_status = 'C'
      THEN
         lvl_product_result_qty := ABS (p_product_result_qty) * -1;
      ELSE
         lvl_product_result_qty := ABS (p_product_result_qty);
      END IF;

      phase := 40;
      OPEN cl1;

      LOOP
         FETCH cl1 INTO v_rows;

         IF cl1%NOTFOUND
         THEN
            CLOSE cl1;
            EXIT;
         END IF;

         phase := 50;
         lvf_issue_price :=
               f_get_mat_inventory_price (
                  v_rows.child_item_code,                       /*IN VARCHAR2*/
                  v_rows.line_type,
                  /*IN VARCHAR2*/
                  p_org                                           /*IN NUMBER*/
               );
         phase := 60;


-------------------------------------------------------
--
-------------------------------------------------------
         INSERT INTO im_item_workstage_issue
                     (issue_date,
                      issue_sequence,
                      organization_id,
                      mfs,
                      material_mfs,
                      line_code,
                      workstage_code,
                      machine_code,
                      item_code,
                      item_type,
                      line_type,
                      issue_deficit,
                      issue_account,
                      issue_price,
                      issue_qty,
                      issue_amt,
                      issue_type,
                      product_date,
                      product_sequence,
                      issue_status,
                      enter_by,
                      enter_date,
                      last_modify_by,
                      last_modify_date,
                      parent_item_code
                     )
              VALUES (TRUNC (SYSDATE),
                      seq_workstage_issue_seq.NEXTVAL,
                      p_org,
                      p_mfs,
                      '*',
                      p_line_code,
                      p_workstage_code,
                      p_machine_code,
                      v_rows.child_item_code,
                      v_rows.item_type,
                      v_rows.line_type,
                      DECODE (p_result_status, 'N', 3, 4),
                      'M001', --ISSUE ACCOUNT
                      lvf_issue_price, --ISSUE_PRICE
                      v_rows.model_unit_qty * lvl_product_result_qty,
                        lvf_issue_price
                      * v_rows.model_unit_qty
                      * lvl_product_result_qty, -- ISSUE_AMT
                      'N', --ISSUE TYPE
                      p_product_date,
                      p_product_sequence,
                      p_result_status,
                      'SYSTEM',
                      SYSDATE,
                      'SYSTEM',
                      SYSDATE,
                      p_item_code
                     );

         phase := 70;


-------------------------------------------------------
--
---------------------------------------------------------
         IF p_result_status = 'C'
         THEN
            UPDATE im_item_workstage_issue
               SET issue_status = 'C'
             WHERE mfs = p_mfs
               AND line_code = p_line_code
               AND workstage_code = p_workstage_code
               AND item_code = v_rows.child_item_code
               AND product_date = p_product_date
               AND product_sequence = p_product_sequence
               AND issue_status = 'N'
               AND organization_id = p_org;
         END IF;

         phase := 80;
      END LOOP;

      DELETE FROM id_eng_bom_temp
            WHERE session_id = lvl_session_id;

      phase := 90;
      RETURN 0;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (
            -20003,
               'PHASE='
            || phase
            || '  '
            || SQLERRM
         );
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (
            -20003,
               'PHASE='
            || phase
            || ' Parent Item Code ='
            || p_item_code
            || ' Child Item Code='
            || v_rows.child_item_code
            || ' '
            || SQLERRM
         );
   END;


-----------------------------------------------
-- Child Item Issue
-----------------------------------------------
   FUNCTION plan_ws_child_item_issue (
      p_product_date            IN   DATE,
      p_product_sequence        IN   NUMBER,
      p_mfs                     IN   VARCHAR2,
      p_sub_mfs                 IN   VARCHAR2,
      p_item_code               IN   VARCHAR2,
      p_line_code               IN   VARCHAR2,
      p_workstage_code          IN   VARCHAR2,
      p_machine_code            IN   VARCHAR2,
      p_product_result_qty      IN   NUMBER,
      p_product_result_weight   IN   NUMBER,
      p_result_status           IN   VARCHAR2,
      p_org                     IN   NUMBER
   )
      RETURN NUMBER
   AS
      lvi_count                   NUMBER;
      lvi_seq                     NUMBER;
      lvl_session_id              NUMBER;
      lvl_product_result_qty      NUMBER;
      lvf_issue_price             NUMBER;
      phase                       NUMBER;
      lvs_assy_exp_yn             VARCHAR2 (1);
      lvs_line_product_division   VARCHAR2 (10);
      lvs_item_code               VARCHAR2 (30);
      lvs_item_type               VARCHAR2 (1);
      lvs_line_type               VARCHAR2 (1);
      lvs_config_value            VARCHAR2 (1);
      lvs_prie_type_value         VARCHAR2 (1);
      lvl_bom_level               NUMBER;

      CURSOR cl1
      IS
         SELECT parent_item_code,
                child_item_code,
                model_unit_qty,
                item_type,
                line_type
           FROM id_eng_bom_temp
          WHERE session_id = lvl_session_id;

      v_rows                      cl1%ROWTYPE;
   BEGIN
      IF p_result_status = 'C'
      THEN
         lvl_product_result_qty := ABS (p_product_result_qty) * -1;
      ELSE
         lvl_product_result_qty := ABS (p_product_result_qty);
      END IF;


--------------------------------------------------------------------

      --------------------------------------------------------------------------
--
--------------------------------------------------------------------------
      phase := 10;
      lvl_session_id :=
                 pkg_design.bom_explosion (p_item_code, p_product_date, p_org);

      IF lvl_session_id < 0
      THEN
         RETURN lvl_session_id;
      ELSE
         phase := 20;

         BEGIN
            SELECT assy_exp_yn
              INTO lvs_assy_exp_yn
              FROM ip_product_workstage
             WHERE workstage_code = p_workstage_code
               AND organization_id = p_org;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error (
                  -20003,
                     'WS='
                  || p_workstage_code
                  || ' Workstage Assy Explosion YN not found '
                  || SQLERRM
               );
         END;

         phase := 25;


------------------------------------
-- SYSTEM CONFIG VALUE GET
------------------------------------
         BEGIN
            SELECT NVL (config_value, 'N')
              INTO lvs_config_value
              FROM isys_config
             WHERE config_name = 'WORKODER_GEN_BY_PROD_PLAN'
               AND use_yn = 'Y'
               AND organization_id = p_org;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               lvs_config_value := 'N';
            WHEN OTHERS
            THEN
               raise_application_error (-20003, SQLERRM);
         END;

         IF    lvs_config_value = 'N'
            OR lvs_config_value IS NULL
         THEN

------------------------
-- EXPEND JUST OWN`S CHILD
------------------------
            lvl_bom_level := 2;
         ELSIF lvs_config_value = 'X'
         THEN

-------------------------
-- Not use
-------------------------
            lvl_bom_level := 0;
         ELSE

-------------------------
-- Y : ALL EXPEND
-------------------------
            lvl_bom_level := 1000;
         END IF;


-----------------------------------------------------------
--
-----------------------------------------------------------
         IF lvs_assy_exp_yn = 'Y'
         THEN
            --Delete all not in Own's Child item
            DELETE FROM id_eng_bom_temp
                  WHERE session_id = lvl_session_id
                    AND bom_level = 1
                    AND line_type = 'T';

            DELETE FROM id_eng_bom_temp
                  WHERE session_id = lvl_session_id
                    AND item_type IN ('M', 'S');

            DELETE FROM id_eng_bom_temp
                  WHERE session_id = lvl_session_id
                    AND bom_level > lvl_bom_level;
         ELSE

----------------------------------------------
-- Delete all except Own.s item code
----------------------------------------------
            DELETE FROM id_eng_bom_temp
                  WHERE session_id = lvl_session_id
                    AND parent_item_code <> p_item_code;
         END IF;
      END IF;


------------------------------------
-- SYSTEM CONFIG VALUE GET
-- CURRENT VALUE = Y
------------------------------------
      BEGIN
         SELECT NVL (config_value, 'B')
           INTO lvs_prie_type_value
           FROM isys_config
          WHERE config_name = 'PRODUCT_RECEIPT_PRICE_TYPE'
            AND use_yn = 'Y'
            AND organization_id = p_org;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            lvs_prie_type_value := 'B';
         WHEN OTHERS
         THEN
            raise_application_error (-20003, SQLERRM);
      END;


----------------------------------------------
      phase := 30;

      BEGIN
         SELECT COUNT (*)
           INTO lvi_count
           FROM id_eng_bom_temp
          WHERE session_id = lvl_session_id;

         IF lvi_count = 0
         THEN
            raise_application_error (
               -20003,
                  'PHASE='
               || phase
               || ' BOM Max Level='
               || lvl_bom_level
               || ' Assy Exp YN='
               || lvs_assy_exp_yn
               || ' item_type = '
               || p_item_code
               || ' Date='
               || p_product_date
               || ' BOM EXLOSION RESULT NOT FOUND '
               || SQLERRM
            );
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (
               -20003,
                  'PHASE='
               || phase
               || ' BOM Max Level='
               || lvl_bom_level
               || ' Assy Exp YN='
               || lvs_assy_exp_yn
               || ' item_type = '
               || p_item_code
               || ' Date='
               || p_product_date
               || ' BOM EXLOSION RESULT NOT FOUND '
               || SQLERRM
            );
      END;

      phase := 40;
      OPEN cl1;

      LOOP
         FETCH cl1 INTO v_rows;

         IF cl1%NOTFOUND
         THEN
            CLOSE cl1;
            EXIT;
         END IF;

         phase := 50;

         IF v_rows.line_type = 'T'
         THEN
            lvf_issue_price :=
                  pkg_design.bom_material_cost (
                     v_rows.child_item_code /*IN VARCHAR2*/,
                     p_product_date /*IN DATE*/,
                     lvs_prie_type_value /*IN VARCHAR2*/,
                     p_org                                       /*IN NUMBER*/
                  );

--            lvf_issue_price :=
--               f_get_assy_inventory_price
--                                      (v_rows.child_item_code, /*IN VARCHAR2*/
--                                       v_rows.line_type,       /*IN VARCHAR2*/
--                                       p_org                   /*IN NUMBER*/
--                                      );
         ELSE
            lvf_issue_price :=
                  f_get_mat_inventory_price (
                     v_rows.child_item_code,                   /*IN VARCHAR2*/
                     v_rows.line_type,
                     /*IN VARCHAR2*/
                     p_org                                       /*IN NUMBER*/
                  );
         END IF;

         phase := 60;


-------------------------------------------------------
--
-------------------------------------------------------
         INSERT INTO im_item_workstage_issue
                     (issue_date,
                      issue_sequence,
                      organization_id,
                      mfs,
                      material_mfs,
                      line_code,
                      workstage_code,
                      machine_code,
                      item_code,
                      item_type,
                      line_type,
                      issue_deficit,
                      issue_account,
                      issue_price,
                      issue_qty,
                      issue_amt,
                      issue_type,
                      product_date,
                      product_sequence,
                      issue_status,
                      enter_by,
                      enter_date,
                      last_modify_by,
                      last_modify_date,
                      sub_mfs,
                      issue_weight,
                      parent_item_code
                     )
              VALUES (p_product_date,
                      seq_workstage_issue_seq.NEXTVAL,
                      p_org,
                      p_mfs,
                      '*',
                      p_line_code,
                      p_workstage_code,
                      p_machine_code,
                      DECODE (
                         lvs_assy_exp_yn,
                         'Y', v_rows.child_item_code,
                         p_item_code
                      ),
                      v_rows.item_type,
                      v_rows.line_type,
                      DECODE (p_result_status, 'N', 3, 4),
                      'M001',
                      --ISSUE ACCOUNT
                      lvf_issue_price, --ISSUE_PRICE
                      v_rows.model_unit_qty * lvl_product_result_qty,
                        lvf_issue_price
                      * v_rows.model_unit_qty
                      * lvl_product_result_qty, -- ISSUE_AMT
                      'N', --ISSUE TYPE
                      p_product_date,
                      p_product_sequence,
                      p_result_status,
                      'SYSTEM',
                      SYSDATE,
                      'SYSTEM',
                      SYSDATE,
                      p_sub_mfs,
                      p_product_result_weight,
                      DECODE (
                         lvs_config_value,
                         'N', v_rows.parent_item_code,
                         p_item_code
                      )
                     );

         phase := 70;


-------------------------------------------------------
--
-------------------------------------------------------
         IF p_result_status = 'C'
         THEN
            UPDATE im_item_workstage_issue
               SET issue_status = 'C'
             WHERE mfs = p_mfs
               AND line_code = p_line_code
               AND workstage_code = p_workstage_code
               AND item_code = DECODE (
                                  lvs_assy_exp_yn,
                                  'Y', v_rows.child_item_code,
                                  p_item_code
                               )
               AND product_date = p_product_date
               AND product_sequence = p_product_sequence
               AND issue_status = 'N'
               AND organization_id = p_org;
         END IF;

         phase := 80;
      END LOOP;


-------------------------------------------------------
--
-------------------------------------------------------
      DELETE FROM id_eng_bom_temp
            WHERE session_id = lvl_session_id;

      phase := 90;
      RETURN 0;

--------------------------------------------------------------------------
--
--------------------------------------------------------------------------
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (
            -20003,
               'PHASE='
            || phase
            || '  '
            || SQLERRM
         );
      WHEN OTHERS
      THEN
         raise_application_error (
            -20003,
               'PHASE='
            || phase
            || ' Parent Item Code ='
            || p_item_code
            || ' Child Item Code='
            || v_rows.child_item_code
            || ' '
            || SQLERRM
         );
   END;


-----------------------------------------------
-- Child Item Issue
-----------------------------------------------
   FUNCTION plan_ws_child_item_issue_gen (
      p_product_date            IN   DATE,
      p_product_sequence        IN   NUMBER,
      p_mfs                     IN   VARCHAR2,
      p_sub_mfs                 IN   VARCHAR2,
      p_item_code               IN   VARCHAR2,
      p_line_code               IN   VARCHAR2,
      p_workstage_code          IN   VARCHAR2,
      p_machine_code            IN   VARCHAR2,
      p_product_result_qty      IN   NUMBER,
      p_product_result_weight   IN   NUMBER,
      p_result_status           IN   VARCHAR2,
      p_org                     IN   NUMBER
   )
      RETURN NUMBER
   AS
      lvi_count                   NUMBER;
      lvi_seq                     NUMBER;
      lvl_session_id              NUMBER;
      lvl_product_result_qty      NUMBER;
      lvf_product_result_weight   NUMBER;
      lvf_issue_price             NUMBER;
      phase                       NUMBER;
      lvs_line_product_division   VARCHAR2 (10);
      lvs_item_code               VARCHAR2 (30);
      lvs_item_type               VARCHAR2 (1);
      lvs_line_type               VARCHAR2 (1);
      lvs_config_value            VARCHAR2 (1);
      lvs_prie_type_value         VARCHAR2 (1);
      lvl_bom_level               NUMBER;

      CURSOR cl1
      IS
         SELECT parent_item_code,
                child_item_code,
                model_unit_qty,
                item_type,
                line_type
           FROM id_eng_bom_temp
          WHERE session_id = lvl_session_id;

      v_rows                      cl1%ROWTYPE;
   BEGIN
      IF p_result_status = 'C'
      THEN
         lvl_product_result_qty := ABS (p_product_result_qty) * -1;
         lvf_product_result_weight := ABS (p_product_result_weight) * -1;
      ELSE
         lvl_product_result_qty := ABS (p_product_result_qty);
         lvf_product_result_weight := ABS (p_product_result_weight);
      END IF;


--------------------------------------------------------------------

      --------------------------------------------------------------------------
--
--------------------------------------------------------------------------
      phase := 10;
      lvl_session_id :=
                pkg_design.bom_explosion (p_item_code, TRUNC (SYSDATE), p_org);

      IF lvl_session_id < 0
      THEN
         RETURN lvl_session_id;
      ELSE

------------------------------------
-- SYSTEM CONFIG VALUE GET
------------------------------------
         BEGIN
            SELECT NVL (config_value, 'N')
              INTO lvs_config_value
              FROM isys_config
             WHERE config_name = 'WORKODER_GEN_BY_PROD_PLAN'
               AND use_yn = 'Y'
               AND organization_id = p_org;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               lvs_config_value := 'N';
            WHEN OTHERS
            THEN
               raise_application_error (-20003, SQLERRM);
         END;

         IF    lvs_config_value = 'N'
            OR lvs_config_value IS NULL
         THEN

------------------------
-- EXPEND JUST OWN`S CHILD
------------------------
            lvl_bom_level := 2;
         ELSIF lvs_config_value = 'X'
         THEN

-------------------------
-- Not use
-------------------------
            lvl_bom_level := 0;
         ELSE

-------------------------
-- Y : ALL EXPEND
-------------------------
            lvl_bom_level := 1000;
         END IF;


-----------------------------------------------------------
--
-----------------------------------------------------------

         --Delete all not in Own's Child item
         DELETE FROM id_eng_bom_temp
               WHERE session_id = lvl_session_id
                 AND bom_level = 1
                 AND line_type = 'T';

         DELETE FROM id_eng_bom_temp
               WHERE session_id = lvl_session_id
                 AND item_type IN ('M', 'S');

         DELETE FROM id_eng_bom_temp
               WHERE session_id = lvl_session_id
                 AND bom_level > lvl_bom_level;
      END IF;


------------------------------------
-- SYSTEM CONFIG VALUE GET
-- CURRENT VALUE = Y
------------------------------------
      BEGIN
         SELECT NVL (config_value, 'B')
           INTO lvs_prie_type_value
           FROM isys_config
          WHERE config_name = 'PRODUCT_RECEIPT_PRICE_TYPE'
            AND use_yn = 'Y'
            AND organization_id = p_org;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            lvs_prie_type_value := 'B';
         WHEN OTHERS
         THEN
            raise_application_error (-20003, SQLERRM);
      END;


------------------------------------
      phase := 30;

      BEGIN
         SELECT COUNT (*)
           INTO lvi_count
           FROM id_eng_bom_temp
          WHERE session_id = lvl_session_id;

         IF lvi_count = 0
         THEN
            NULL;

--            raise_application_error(
--               -20003, 'PHASE=' || phase || ' BOM Max Level=' || lvl_bom_level
--                       || ' Assy Exp YN=' || ' item_type = ' || p_item_code
--                       || ' Date=' || p_product_date
--                       || ' BOM EXLOSION RESULT NOT FOUND ' || SQLERRM
--            );
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;

--            raise_application_error(
--               -20003, 'PHASE=' || phase || ' BOM Max Level=' || lvl_bom_level
--                       || ' Assy Exp YN=' || ' item_type = ' || p_item_code
--                       || ' Date=' || p_product_date
--                       || ' BOM EXLOSION RESULT NOT FOUND ' || SQLERRM
--            );
      END;

      phase := 40;
      OPEN cl1;

      LOOP
         FETCH cl1 INTO v_rows;

         IF cl1%NOTFOUND
         THEN
            CLOSE cl1;
            EXIT;
         END IF;

         phase := 50;

         IF v_rows.line_type = 'T'
         THEN
            lvf_issue_price :=
                  pkg_design.bom_material_cost (
                     v_rows.child_item_code /*IN VARCHAR2*/,
                     p_product_date /*IN DATE*/,
                     lvs_prie_type_value /*IN VARCHAR2*/,
                     p_org                                       /*IN NUMBER*/
                  );

--            lvf_issue_price :=
--               f_get_assy_inventory_price
--                                      (v_rows.child_item_code, /*IN VARCHAR2*/
--                                       v_rows.line_type,
--                                       /*IN VARCHAR2*/
--                                       p_org                     /*IN NUMBER*/
--                                      );
         ELSE
            lvf_issue_price :=
                  f_get_mat_inventory_price (
                     v_rows.child_item_code,                   /*IN VARCHAR2*/
                     v_rows.line_type,
                     /*IN VARCHAR2*/
                     p_org                                       /*IN NUMBER*/
                  );
         END IF;

         phase := 60;

         INSERT INTO im_item_workstage_issue_gen
                     (issue_date,
                      issue_sequence,
                      organization_id,
                      mfs,
                      material_mfs,
                      line_code,
                      workstage_code,
                      machine_code,
                      item_code,
                      item_type,
                      line_type,
                      issue_deficit,
                      issue_account,
                      issue_price,
                      issue_qty,
                      issue_amt,
                      issue_type,
                      product_date,
                      product_sequence,
                      issue_status,
                      enter_by,
                      enter_date,
                      last_modify_by,
                      last_modify_date,
                      sub_mfs,
                      issue_weight,
                      parent_item_code
                     )
              VALUES (p_product_date,
                      seq_workstage_issue_seq.NEXTVAL,
                      p_org,
                      p_mfs,
                      '*',
                      p_line_code,
                      p_workstage_code,
                      p_machine_code,
                      v_rows.child_item_code,
                      v_rows.item_type,
                      v_rows.line_type,
                      DECODE (p_result_status, 'N', 3, 4),
                      'M001',
                      --ISSUE ACCOUNT
                      lvf_issue_price, --ISSUE_PRICE
                      v_rows.model_unit_qty * lvl_product_result_qty,
                        lvf_issue_price
                      * v_rows.model_unit_qty
                      * lvl_product_result_qty, -- ISSUE_AMT
                      'N', --ISSUE TYPE
                      p_product_date,
                      p_product_sequence,
                      'N',
                      'SYSTEM',
                      SYSDATE,
                      'SYSTEM',
                      SYSDATE,
                      p_sub_mfs,
                      lvf_product_result_weight,
                      DECODE (
                         lvs_config_value,
                         'N', v_rows.parent_item_code,
                         p_item_code
                      )
                     );

         phase := 70;
      END LOOP;

      DELETE FROM id_eng_bom_temp
            WHERE session_id = lvl_session_id;

      phase := 90;
      RETURN 0;

--------------------------------------------------------------------------
--
--------------------------------------------------------------------------
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (
            -20003,
               'PHASE='
            || phase
            || '  '
            || SQLERRM
         );
      WHEN OTHERS
      THEN
         raise_application_error (
            -20003,
               'PHASE='
            || phase
            || ' Parent Item Code ='
            || p_item_code
            || ' Child Item Code='
            || v_rows.child_item_code
            || ' '
            || SQLERRM
         );
   END;
END pkg_planning;