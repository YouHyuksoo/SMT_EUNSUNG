PACKAGE BODY "PKG_DESIGN" 
IS
   phase   VARCHAR2 (10);

   ---------------------------------------------------------------
   --
   -- New BOM constraints Check
   --
   ---------------------------------------------------------------
   FUNCTION bom_newins_check (p_work_no            IN NUMBER,
                              p_set_item_code      IN VARCHAR2,
                              p_parent_item_code   IN VARCHAR2,
                              p_child_item_code    IN VARCHAR2,
                              p_dateset            IN DATE,
                              p_org                IN NUMBER)
      RETURN NUMBER
   IS
      lvl_count   NUMBER := 0;
   BEGIN
      lvl_count :=
         bom_loop_check (p_parent_item_code,
                         p_child_item_code,
                         p_dateset,
                         p_org);

      IF lvl_count < 0
      THEN
         RETURN -3;
      END IF;

      IF p_parent_item_code = p_child_item_code
      THEN
         RETURN -1;                                   -- parent and child same
      END IF;

      BEGIN
         SELECT COUNT (*)
           INTO lvl_count
           FROM id_eng_bom
          WHERE     parent_item_code = p_parent_item_code
                AND child_item_code = p_child_item_code
                AND TRUNC (dateset) <= p_dateset
                AND dateend >= p_dateset
                AND organization_id = p_org;

         IF lvl_count > 0
         THEN
            RETURN -2;                               --aredy exists in eng bom
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RETURN 0;
      END;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20003, SQLERRM);
   END;

   ---------------------------------------------------------------
   --
   --
   ---------------------------------------------------------------
   FUNCTION bom_model_qty (p_org IN VARCHAR2, p_session_id IN NUMBER)
      RETURN NUMBER
   IS
      lvf_accqty     NUMBER;
      ll_max_level   NUMBER;
      inx            NUMBER;
   BEGIN
      SELECT NVL (MAX (bom_level), 0)
        INTO ll_max_level
        FROM id_eng_bom_temp
       WHERE session_id = p_session_id AND organization_id = p_org;

      UPDATE id_eng_bom_temp
         SET model_unit_qty = item_unit_qty,
             model_unit_qty_ext = item_unit_qty_ext
       WHERE     session_id = p_session_id
             AND organization_id = p_org
             AND bom_level = 1;

      IF ll_max_level <= 1
      THEN
         RETURN 0;
      END IF;

      FOR inx IN 2 .. ll_max_level
      LOOP
         UPDATE id_eng_bom_temp t1
            SET (model_unit_qty, model_unit_qty_ext) =
                   (SELECT SUM (
                              NVL (t1.item_unit_qty, 0)
                              * NVL (t2.model_unit_qty, 0)),
                           SUM (
                              NVL (t1.item_unit_qty_ext, 0)
                              * NVL (t2.model_unit_qty_ext, 0))
                      FROM id_eng_bom_temp t2
                     WHERE     t2.session_id = p_session_id
                           AND t1.parent_item_code = t2.child_item_code
                           AND t1.bom_level - 1 = t2.bom_level
                           AND t2.sort_order =
                                  (SELECT MAX (t3.sort_order)
                                     FROM id_eng_bom_temp t3
                                    WHERE session_id = p_session_id
                                          AND t1.parent_item_code =
                                                 t3.child_item_code
                                          AND t1.sort_order > t3.sort_order))
          WHERE     organization_id = p_org
                AND session_id = p_session_id
                AND bom_level = inx;
      END LOOP;

      RETURN 0;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         ROLLBACK;
         raise_application_error (-20003, SQLERRM);
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20003, SQLERRM);
   END;

   ---------------------------------------------------------------
   --
   --
   ---------------------------------------------------------------
   FUNCTION bom_query (p_parent_item_code   IN VARCHAR2,
                       p_dateset            IN DATE,
                       p_org                IN NUMBER)
      RETURN NUMBER
   IS
      lvl_session_id   NUMBER;
      lvd_datelimit    DATE := TO_DATE ('9999/12/31', 'yyyy/mm/dd');
      lvl_return       NUMBER;
      lvl_count        NUMBER;
   BEGIN
      IF p_parent_item_code IS NULL
      THEN
         RETURN 0;
      END IF;

      --Session id Extract
      lvl_session_id := bom_explosion (p_parent_item_code, p_dateset, p_org);

      IF lvl_session_id < 0
      THEN
         RETURN lvl_session_id;
      END IF;

      RETURN lvl_session_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20003, SQLERRM);
      WHEN OTHERS
      THEN
         raise_application_error (-20003, SQLERRM);
   END;

   ---------------------------------------------------------------
   --
   --
   ---------------------------------------------------------------
   FUNCTION bom_query_all (p_parent_item_code   IN VARCHAR2,
                           p_dateset            IN DATE,
                           p_org                IN NUMBER)
      RETURN NUMBER
   IS
      lvl_session_id   NUMBER;
      lvd_datelimit    DATE := TO_DATE ('9999/12/31', 'yyyy/mm/dd');
      lvl_return       NUMBER;
      lvl_count        NUMBER;
   BEGIN
      IF p_parent_item_code IS NULL
      THEN
         RETURN 0;
      END IF;

      --Session id Extract
      lvl_session_id :=
         bom_explosion_all (p_parent_item_code, p_dateset, p_org);

      IF lvl_session_id < 0
      THEN
         RETURN lvl_session_id;
      END IF;

      RETURN lvl_session_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20003, SQLERRM);
      WHEN OTHERS
      THEN
         raise_application_error (-20003, SQLERRM);
   END;

   ---------------------------------------------------------------
   --
   --
   ---------------------------------------------------------------
   FUNCTION bom_count (p_parent_item_code   IN VARCHAR2,
                       p_dateset            IN DATE,
                       p_org                IN NUMBER)
      RETURN NUMBER
   IS
      lvd_datelimit   DATE := TO_DATE ('9999/12/31', 'yyyy/mm/dd');
      lvl_count       NUMBER;
   BEGIN
      BEGIN
         SELECT COUNT (*)
           INTO lvl_count
           FROM id_eng_bom
          WHERE     TRUNC (dateset) <= p_dateset
                AND NVL (dateend, lvd_datelimit) >= p_dateset
                AND organization_id = p_org
         START WITH     parent_item_code = p_parent_item_code
                    AND TRUNC (dateset) <= p_dateset
                    AND NVL (dateend, lvd_datelimit) >= p_dateset
                    AND organization_id = p_org
         CONNECT BY     PRIOR child_item_code = parent_item_code
                    AND TRUNC (dateset) <= p_dateset
                    AND NVL (dateend, lvd_datelimit) >= p_dateset
                    AND organization_id = p_org;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RETURN -100;
      END;

      RETURN lvl_count;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20003, SQLERRM);
      WHEN OTHERS
      THEN
         raise_application_error (-20003, 'BOM Count ' || SQLERRM);
   END;

   ---------------------------------------------------------------
   -- Free assy explosion
   --
   --
   ---------------------------------------------------------------

   ---------------------------------------------------------------
   -- Material Cost
   -- B = Buy Price
   -- L Last Month avg Price
   ---------------------------------------------------------------
   FUNCTION bom_material_cost (p_parent_item_code   IN VARCHAR2,
                               p_dateset            IN DATE,
                               p_price_type         IN VARCHAR2,
                               p_org                IN NUMBER)
      RETURN NUMBER
   IS
      lvl_session_id      NUMBER;
      lvd_datelimit       DATE := TO_DATE ('9999/12/31', 'yyyy/mm/dd');
      lvl_return          NUMBER;
      lvl_count           NUMBER;
      lvf_material_cost   NUMBER;
      phase               VARCHAR2 (10);

      CURSOR cl1
      IS
         SELECT child_item_code,
                model_unit_qty,
                model_unit_qty_ext,
                item_type,
                line_type
           FROM id_eng_bom_temp
          WHERE session_id = lvl_session_id;

      v_rows              cl1%ROWTYPE;
   BEGIN
      phase := '10';
      lvl_session_id := bom_explosion (p_parent_item_code, p_dateset, p_org);

      IF lvl_session_id < 0
      THEN
         RETURN lvl_session_id;
      END IF;

      phase := '20';

      DELETE FROM id_eng_bom_temp
       WHERE     session_id = lvl_session_id
             AND line_type = 'T'
             AND TRUNC (dateset) <= p_dateset
             AND dateend >= p_dateset
             AND organization_id = p_org;

      phase := '30';

      BEGIN
         SELECT COUNT (*)
           INTO lvl_count
           FROM id_eng_bom_temp
          WHERE session_id = lvl_session_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (
               -20003,
                  p_parent_item_code
               || ' Materia Cost bom not found '
               || SQLERRM);
      END;

      phase := '40';

      OPEN cl1;

      LOOP
         FETCH cl1 INTO v_rows;

         IF cl1%NOTFOUND
         THEN
            CLOSE cl1;

            EXIT;
         END IF;

         phase := '50';

         IF p_price_type = 'L'
         THEN                                          -- last month avg price
            phase := '60';
            lvf_material_cost :=
               NVL (lvf_material_cost, 0)
               + (v_rows.model_unit_qty
                  * f_get_mat_mm_avg_price (
                       TO_CHAR (ADD_MONTHS (p_dateset, -1), 'yyyymm'),
                       v_rows.child_item_code,
                       v_rows.line_type,
                       p_org));
         ELSIF p_price_type = 'I'
         THEN                                        -- CURENT INVENTORY PRICE
            phase := '70';
            lvf_material_cost :=
               NVL (lvf_material_cost, 0)
               + (v_rows.model_unit_qty
                  * f_get_mat_inventory_price (v_rows.child_item_code,
                                               v_rows.line_type,
                                               p_org));
         ELSIF p_price_type = 'B'
         THEN                                                     -- buy price
            phase := '80';
            lvf_material_cost :=
               NVL (lvf_material_cost, 0)
               + (v_rows.model_unit_qty
                  * f_get_mat_max_unit_price_cfm (v_rows.child_item_code,
                                                  v_rows.line_type,
                                                  p_dateset,
                                                  p_org));
         ELSIF p_price_type = 'M'
         THEN                                       -- current month avg price
            phase := '90';
            lvf_material_cost :=
               NVL (lvf_material_cost, 0)
               + (v_rows.model_unit_qty
                  * f_get_mat_mm_avg_price (TO_CHAR (p_dateset, 'yyyymm'),
                                            v_rows.child_item_code,
                                            v_rows.line_type,
                                            p_org));
         END IF;
      END LOOP;

      phase := '100';

      DELETE FROM id_eng_bom_temp
       WHERE session_id = lvl_session_id;

      RETURN lvf_material_cost;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (
            -20003,
            'Phase=' || phase || ' PKG_DESIGN ' || SQLERRM);
      WHEN OTHERS
      THEN
         raise_application_error (
            -20003,
            'Phase=' || phase || ' PKG_DESIGN ' || SQLERRM);
   END;

   ----------------------------------------------------------------------
   --
   --
   ----------------------------------------------------------------------
   FUNCTION bom_oneself_assy_explosion (p_parent_item_code   IN VARCHAR2,
                                        p_dateset            IN DATE,
                                        p_org                IN NUMBER)
      RETURN NUMBER
   IS
      lvl_session_id   NUMBER;
      lvd_datelimit    DATE := TO_DATE ('9999/12/31', 'yyyy/mm/dd');
      lvl_return       NUMBER;
      lvl_count        NUMBER;
   BEGIN
      BEGIN
         SELECT COUNT (*)
           INTO lvl_count
           FROM id_eng_bom
          WHERE     TRUNC (dateset) <= p_dateset
                AND NVL (dateend, lvd_datelimit) >= p_dateset
                AND organization_id = p_org
         START WITH     parent_item_code = p_parent_item_code
                    --                    AND child_item_code = p_child_item_code
                    AND TRUNC (dateset) <= p_dateset
                    AND NVL (dateend, lvd_datelimit) >= p_dateset
                    AND organization_id = p_org
         CONNECT BY     PRIOR child_item_code = parent_item_code
                    AND TRUNC (dateset) <= p_dateset
                    AND NVL (dateend, lvd_datelimit) >= p_dateset
                    AND organization_id = p_org;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RETURN -100;
      END;

      IF lvl_count = 0
      THEN
         /*      raise_application_error (
                  -20008,
                     p_org
                  || ' '
                  || p_dateset
                  || ' '
                  || p_parent_item_code
                  || ' '
                  || 'BOM Explosion Error '
                  || SQLERRM
               ); */
         RETURN -100;
      END IF;

      --Session id Extract
      SELECT seq_bom_session_id.NEXTVAL INTO lvl_session_id FROM DUAL;

      BEGIN
         INSERT INTO id_eng_bom_temp (session_id,
                                      bom_level,
                                      sort_sequence,
                                      sort_order,
                                      parent_item_code,
                                      child_item_code,
                                      item_unit_qty,
                                      item_unit_qty_ext,
                                      model_unit_qty,
                                      model_unit_qty_ext,
                                      dateset,
                                      dateend,
                                      workstage_code,
                                      bom_work_no,
                                      enter_by,
                                      enter_date,
                                      last_modify_by,
                                      last_modify_date,
                                      item_type,
                                      line_type,
                                      loss_rate,
                                      scrap_rate,
                                      LOCATION_INFO,
                                      organization_id,
                                      item_code,
                                      REVISION)
            SELECT lvl_session_id,
                   LEVEL bom_level,
                   sort_sequence,
                   SYS_CONNECT_BY_PATH (
                      TRIM (TO_CHAR (sort_sequence || ROWNUM, '0000')),
                      '.')
                      AS sort_order,
                   parent_item_code,
                   child_item_code,
                   DECODE (child_item_code,
                           p_parent_item_code, 1,
                           item_unit_qty),
                   DECODE (child_item_code,
                           p_parent_item_code, 1,
                           item_unit_qty_ext),
                   0,
                   0,
                   TRUNC (dateset),
                   dateend,
                   workstage_code,
                   bom_work_no,
                   enter_by,
                   enter_date,
                   last_modify_by,
                   last_modify_date,
                   item_type,
                   line_type,
                   loss_rate,
                   scrap_rate,
                   LOCATION_INFO,
                   organization_id,
                   item_code,
                   REVISION
              FROM id_eng_bom
             WHERE     TRUNC (dateset) <= p_dateset
                   AND NVL (dateend, lvd_datelimit) >= p_dateset
                   AND organization_id = p_org
            START WITH child_item_code = p_parent_item_code
                       AND parent_item_code =
                              (SELECT MAX (parent_item_code)
                                 FROM id_eng_bom
                                WHERE child_item_code = p_parent_item_code
                                      AND TRUNC (dateset) <= p_dateset
                                      AND NVL (dateend, lvd_datelimit) >=
                                             p_dateset
                                      AND organization_id = p_org)
                       AND TRUNC (dateset) <= p_dateset
                       AND NVL (dateend, lvd_datelimit) >= p_dateset
                       AND organization_id = p_org
            CONNECT BY     PRIOR child_item_code = parent_item_code
                       AND TRUNC (dateset) <= p_dateset
                       AND NVL (dateend, lvd_datelimit) >= p_dateset
                       AND organization_id = p_org;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20003, SQLERRM);
         WHEN OTHERS
         THEN
            ROLLBACK;
            raise_application_error (-20003, SQLERRM);
      END;

      ---------------------------------------------------
      --Model Qty = Item Unit Qty
      ---------------------------------------------------
      /*     UPDATE id_eng_bom_temp
               SET model_unit_qty = item_unit_qty,
                   model_unit_qty_ext = item_unit_qty_ext
             WHERE session_id = lvl_session_id
               AND organization_id = p_org ;*/

      ---------------------------------------------------
      --Model Qty Rollup Item Unit Qty for Model Qty
      ---------------------------------------------------
      lvl_return := bom_model_qty (p_org, lvl_session_id);

      IF lvl_return < 0
      THEN
         raise_application_error (
            -20003,
            'BOM Model QTY Calculation Error ' || SQLERRM);
      END IF;

      RETURN lvl_session_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20003, SQLERRM);
      WHEN OTHERS
      THEN
         raise_application_error (-20003, SQLERRM);
   END;

   ---------------------------------------------------------------
   -- Free assy explosion
   --
   --
   ---------------------------------------------------------------
   FUNCTION bom_free_assy_explosion (p_parent_item_code   IN VARCHAR2,
                                     p_dateset            IN DATE,
                                     p_org                IN NUMBER)
      RETURN NUMBER
   IS
      lvl_session_id   NUMBER;
      lvd_datelimit    DATE := TO_DATE ('9999/12/31', 'yyyy/mm/dd');
      lvl_return       NUMBER;
      lvl_count        NUMBER;
   BEGIN
      lvl_session_id := bom_explosion (p_parent_item_code, p_dateset, p_org);

      IF lvl_session_id < 0
      THEN
         RETURN lvl_session_id;
      END IF;

      DELETE FROM id_eng_bom_temp
       WHERE     parent_item_code <> p_parent_item_code
             AND TRUNC (dateset) <= p_dateset
             AND dateend >= p_dateset
             AND organization_id = p_org;



      /*     DELETE FROM id_eng_bom_temp
                 WHERE parent_item_code <> p_parent_item_code
                   AND parent_item_code IN (
                          SELECT item_code
                            FROM id_item
                           WHERE item_type = 'M'
                             AND line_type IN ('M', 'S')
                             AND dateset <= p_dateset
                             AND dateend >= p_dateset
                             AND organization_id = p_org);
                             */

      RETURN lvl_session_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20003, 'PKG_DESIGN ' || SQLERRM);
      WHEN OTHERS
      THEN
         raise_application_error (-20003, 'PKG_DESIGN ' || SQLERRM);
   END;

   ---------------------------------------------------------------
   -- BOM  RETURN : 0  , -1 , -100 NO_DATA_FOUND
   --
   --
   ---------------------------------------------------------------
   FUNCTION bom_explosion (p_parent_item_code   IN VARCHAR2,
                           p_dateset            IN DATE,
                           p_org                IN NUMBER)
      RETURN NUMBER
   IS
      lvl_session_id   NUMBER;
      lvd_datelimit    DATE := TO_DATE ('9999/12/31', 'yyyy/mm/dd');
      lvl_return       NUMBER;
      lvl_count        NUMBER;
   BEGIN
      BEGIN
         SELECT COUNT (*)
           INTO lvl_count
           FROM id_eng_bom
          WHERE     TRUNC (dateset) <= p_dateset
                AND NVL (dateend, lvd_datelimit) >= p_dateset
                AND organization_id = p_org
         START WITH     child_item_code = p_parent_item_code
                    AND --                    parent_item_code = p_parent_item_code    AND
                        TRUNC (dateset) <= p_dateset
                    AND NVL (dateend, lvd_datelimit) >= p_dateset
                    AND organization_id = p_org
         CONNECT BY     PRIOR child_item_code = parent_item_code
                    AND TRUNC (dateset) <= p_dateset
                    AND NVL (dateend, lvd_datelimit) >= p_dateset
                    AND organization_id = p_org;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RETURN -100;
      END;

      IF lvl_count = 0
      THEN
         /*      raise_application_error (
                  -20008,
                     p_org
                  || ' '
                  || p_dateset
                  || ' '
                  || p_parent_item_code
                  || ' '
                  || 'BOM Explosion Error '
                  || SQLERRM
               ); */
         RETURN -100;
      END IF;

      --Session id Extract
      SELECT seq_bom_session_id.NEXTVAL INTO lvl_session_id FROM DUAL;

      BEGIN
         INSERT INTO id_eng_bom_temp (session_id,
                                      bom_level,
                                      sort_sequence,
                                      sort_order,
                                      parent_item_code,
                                      child_item_code,
                                      item_unit_qty,
                                      item_unit_qty_ext,
                                      model_unit_qty,
                                      model_unit_qty_ext,
                                      dateset,
                                      dateend,
                                      workstage_code,
                                      bom_work_no,
                                      enter_by,
                                      enter_date,
                                      last_modify_by,
                                      last_modify_date,
                                      item_type,
                                      line_type,
                                      loss_rate,
                                      scrap_rate,
                                      LOCATION_INFO,
                                      organization_id,
                                      assy_explosion_yn,
                                      item_code,
                                      REVISION,
                                      PCB_ITEM)
            SELECT lvl_session_id,
                   LEVEL bom_level,
                   sort_sequence,
                   SYS_CONNECT_BY_PATH (
                      TRIM (TO_CHAR (sort_sequence || ROWNUM, '0000')),
                      '.')
                      AS sort_order,
                   parent_item_code,
                   child_item_code,
                   DECODE (child_item_code,
                           p_parent_item_code, 1,
                           item_unit_qty),
                   DECODE (child_item_code,
                           p_parent_item_code, 1,
                           item_unit_qty_ext),
                   0,
                   0,
                   dateset,
                   dateend,
                   workstage_code,
                   bom_work_no,
                   enter_by,
                   enter_date,
                   last_modify_by,
                   last_modify_date,
                   item_type,
                   line_type,
                   loss_rate,
                   scrap_rate,
                   LOCATION_INFO,
                   organization_id,
                   assy_explosion_yn,
                   item_code,
                   REVISION,
                   PCB_ITEM
              FROM id_eng_bom
             WHERE     TRUNC (dateset) <= p_dateset
                   AND NVL (dateend, lvd_datelimit) >= p_dateset
                   AND organization_id = p_org
            START WITH child_item_code = p_parent_item_code
                       AND parent_item_code =
                              (SELECT MAX (parent_item_code)
                                 FROM id_eng_bom
                                WHERE child_item_code = p_parent_item_code
                                      AND TRUNC (dateset) <= p_dateset
                                      AND NVL (dateend, lvd_datelimit) >=
                                             p_dateset
                                      AND organization_id = p_org)
                       AND TRUNC (dateset) <= p_dateset
                       AND NVL (dateend, lvd_datelimit) >= p_dateset
                       AND organization_id = p_org
            CONNECT BY     PRIOR child_item_code = parent_item_code
                       AND TRUNC (dateset) <= p_dateset
                       AND NVL (dateend, lvd_datelimit) >= p_dateset
                       AND NVL (assy_explosion_yn, 'N') = 'Y'
                       AND organization_id = p_org;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20003, SQLERRM);
         WHEN OTHERS
         THEN
            ROLLBACK;
            raise_application_error (-20003, SQLERRM);
      END;

      ---------------------------------------------------
      --Model Qty = Item Unit Qty
      ---------------------------------------------------
      /*     UPDATE id_eng_bom_temp
               SET model_unit_qty = item_unit_qty,
                   model_unit_qty_ext = item_unit_qty_ext
             WHERE session_id = lvl_session_id
               AND organization_id = p_org ;*/

      ---------------------------------------------------
      --Model Qty Rollup Item Unit Qty for Model Qty
      ---------------------------------------------------
      lvl_return := bom_model_qty (p_org, lvl_session_id);

      IF lvl_return < 0
      THEN
         raise_application_error (
            -20003,
            'BOM Model QTY Calculation Error ' || SQLERRM);
      END IF;

      RETURN lvl_session_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20003, SQLERRM);
      WHEN OTHERS
      THEN
         raise_application_error (-20003, SQLERRM);
   END;

   ---------------------------------------------------------
   --
   -- BOM EXPLOSION ALL
   --
   ---------------------------------------------------------
   FUNCTION bom_explosion_all (p_parent_item_code   IN VARCHAR2,
                               p_dateset            IN DATE,
                               p_org                IN NUMBER)
      RETURN NUMBER
   IS
      lvl_session_id   NUMBER;
      lvd_datelimit    DATE := TO_DATE ('9999/12/31', 'yyyy/mm/dd');
      lvl_return       NUMBER;
      lvl_count        NUMBER;
   BEGIN
      BEGIN
         SELECT COUNT (*)
           INTO lvl_count
           FROM id_eng_bom
          WHERE     TRUNC (dateset) <= p_dateset
                AND NVL (TRUNC (dateend), lvd_datelimit) >= p_dateset
                AND organization_id = p_org
         START WITH     child_item_code = p_parent_item_code
                    AND --parent_item_code = p_parent_item_code    AND
                        TRUNC (dateset) <= p_dateset
                    AND NVL (dateend, lvd_datelimit) >= p_dateset
                    AND organization_id = p_org
         CONNECT BY     PRIOR child_item_code = parent_item_code
                    AND TRUNC (dateset) <= p_dateset
                    AND NVL (TRUNC (dateend), lvd_datelimit) >= p_dateset
                    AND organization_id = p_org;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RETURN -100;
      END;

      IF lvl_count = 0
      THEN
         /*      raise_application_error (
                  -20008,
                     p_org
                  || ' '
                  || p_dateset
                  || ' '
                  || p_parent_item_code
                  || ' '
                  || 'BOM Explosion Error '
                  || SQLERRM
               ); */
         RETURN -100;
      END IF;

      --Session id Extract
      SELECT seq_bom_session_id.NEXTVAL INTO lvl_session_id FROM DUAL;

      BEGIN
         INSERT INTO id_eng_bom_temp (session_id,
                                      bom_level,
                                      sort_sequence,
                                      sort_order,
                                      parent_item_code,
                                      child_item_code,
                                      item_unit_qty,
                                      item_unit_qty_ext,
                                      model_unit_qty,
                                      model_unit_qty_ext,
                                      dateset,
                                      dateend,
                                      workstage_code,
                                      bom_work_no,
                                      enter_by,
                                      enter_date,
                                      last_modify_by,
                                      last_modify_date,
                                      item_type,
                                      line_type,
                                      loss_rate,
                                      scrap_rate,
                                      LOCATION_INFO,
                                      organization_id,
                                      assy_explosion_yn,
                                      item_code,
                                      REVISION,
                                      PCB_ITEM)
            SELECT DISTINCT
                   lvl_session_id,
                   LEVEL bom_level,
                   sort_sequence,
                   SYS_CONNECT_BY_PATH (
                      TRIM (TO_CHAR (sort_sequence || ROWNUM, '0000')),
                      '.')
                      AS sort_order,
                   parent_item_code,
                   child_item_code,
                   DECODE (child_item_code,
                           p_parent_item_code, 1,
                           item_unit_qty),
                   DECODE (child_item_code,
                           p_parent_item_code, 1,
                           item_unit_qty_ext),
                   0,
                   0,
                   dateset,
                   dateend,
                   workstage_code,
                   bom_work_no,
                   enter_by,
                   enter_date,
                   last_modify_by,
                   last_modify_date,
                   item_type,
                   line_type,
                   loss_rate,
                   scrap_rate,
                   LOCATION_INFO,
                   organization_id,
                   assy_explosion_yn,
                   item_code,
                   REVISION,
                   PCB_ITEM
              FROM id_eng_bom
             WHERE     TRUNC (dateset) <= p_dateset
                   AND NVL (dateend, lvd_datelimit) >= p_dateset
                   AND organization_id = p_org
            START WITH child_item_code = p_parent_item_code
                       AND parent_item_code =
                              (SELECT MAX (parent_item_code)
                                 FROM id_eng_bom
                                WHERE child_item_code = p_parent_item_code
                                      AND TRUNC (dateset) <= p_dateset
                                      AND NVL (dateend, lvd_datelimit) >=
                                             p_dateset
                                      AND organization_id = p_org)
                       AND TRUNC (dateset) <= p_dateset
                       AND NVL (dateend, lvd_datelimit) >= p_dateset
                       AND organization_id = p_org
            CONNECT BY     PRIOR child_item_code = parent_item_code
                       AND TRUNC (dateset) <= p_dateset
                       AND NVL (dateend, lvd_datelimit) >= p_dateset
                       AND organization_id = p_org;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20003, SQLERRM);
         WHEN OTHERS
         THEN
            ROLLBACK;
            raise_application_error (-20003, SQLERRM);
      END;

      ---------------------------------------------------
      --Model Qty = Item Unit Qty
      ---------------------------------------------------
      /*     UPDATE id_eng_bom_temp
               SET model_unit_qty = item_unit_qty,
                   model_unit_qty_ext = item_unit_qty_ext
             WHERE session_id = lvl_session_id
               AND organization_id = p_org ;*/

      ---------------------------------------------------
      --Model Qty Rollup Item Unit Qty for Model Qty
      ---------------------------------------------------
      lvl_return := bom_model_qty (p_org, lvl_session_id);

      IF lvl_return < 0
      THEN
         raise_application_error (
            -20003,
            'BOM Model QTY Calculation Error ' || SQLERRM);
      END IF;

      RETURN lvl_session_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20003, SQLERRM);
      WHEN OTHERS
      THEN
         raise_application_error (-20003, SQLERRM);
   END;

   ----------------------------------------------------------
   --
   --
   --
   ----------------------------------------------------------
   FUNCTION bom_assy_explosion (p_parent_item_code   IN VARCHAR2,
                                p_child_item_code    IN VARCHAR2,
                                p_dateset            IN DATE,
                                p_org                IN NUMBER)
      RETURN NUMBER
   IS
      lvl_session_id   NUMBER;
      lvd_datelimit    DATE := TO_DATE ('9999/12/31', 'yyyy/mm/dd');
      lvl_return       NUMBER;
      lvl_count        NUMBER;
   BEGIN
      BEGIN
         SELECT COUNT (*)
           INTO lvl_count
           FROM id_eng_bom
          WHERE     TRUNC (dateset) <= p_dateset
                AND NVL (dateend, lvd_datelimit) >= p_dateset
                AND organization_id = p_org
         START WITH     parent_item_code = p_parent_item_code
                    AND child_item_code = p_child_item_code
                    AND TRUNC (dateset) <= p_dateset
                    AND NVL (dateend, lvd_datelimit) >= p_dateset
                    AND organization_id = p_org
         CONNECT BY     PRIOR child_item_code = parent_item_code
                    AND TRUNC (dateset) <= p_dateset
                    AND NVL (dateend, lvd_datelimit) >= p_dateset
                    AND organization_id = p_org;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RETURN -100;
      END;

      IF lvl_count = 0
      THEN
         /*      raise_application_error (
                  -20008,
                     p_org
                  || ' '
                  || p_dateset
                  || ' '
                  || p_parent_item_code
                  || ' '
                  || 'BOM Explosion Error '
                  || SQLERRM
               ); */
         RETURN -100;
      END IF;

      --Session id Extract
      SELECT seq_bom_session_id.NEXTVAL INTO lvl_session_id FROM DUAL;

      BEGIN
         INSERT INTO id_eng_bom_temp (session_id,
                                      bom_level,
                                      sort_sequence,
                                      sort_order,
                                      parent_item_code,
                                      child_item_code,
                                      item_unit_qty,
                                      item_unit_qty_ext,
                                      model_unit_qty,
                                      model_unit_qty_ext,
                                      dateset,
                                      dateend,
                                      workstage_code,
                                      bom_work_no,
                                      enter_by,
                                      enter_date,
                                      last_modify_by,
                                      last_modify_date,
                                      item_type,
                                      line_type,
                                      loss_rate,
                                      scrap_rate,
                                      LOCATION_INFO,
                                      organization_id,
                                      assy_explosion_yn,
                                      item_code,
                                      REVISION,
                                      PCB_ITEM)
            SELECT DISTINCT
                   lvl_session_id,
                   LEVEL bom_level,
                   sort_sequence,
                   SYS_CONNECT_BY_PATH (
                      TRIM (TO_CHAR (sort_sequence || ROWNUM, '0000')),
                      '.')
                      AS sort_order,
                   parent_item_code,
                   child_item_code,
                   DECODE (child_item_code,
                           p_child_item_code, 1,
                           item_unit_qty),
                   DECODE (child_item_code,
                           p_child_item_code, 1,
                           item_unit_qty_ext),
                   0,
                   0,
                   TRUNC (dateset),
                   dateend,
                   workstage_code,
                   bom_work_no,
                   enter_by,
                   enter_date,
                   last_modify_by,
                   last_modify_date,
                   item_type,
                   line_type,
                   loss_rate,
                   scrap_rate,
                   LOCATION_INFO,
                   organization_id,
                   assy_explosion_yn,
                   item_code,
                   REVISION,
                   PCB_ITEM
              FROM id_eng_bom
             WHERE     TRUNC (dateset) <= p_dateset
                   AND NVL (dateend, lvd_datelimit) >= p_dateset
                   AND organization_id = p_org
            START WITH     parent_item_code = p_parent_item_code
                       AND child_item_code = p_child_item_code
                       AND TRUNC (dateset) <= p_dateset
                       AND NVL (dateend, lvd_datelimit) >= p_dateset
                       AND organization_id = p_org
            CONNECT BY     PRIOR child_item_code = parent_item_code
                       AND TRUNC (dateset) <= p_dateset
                       AND NVL (dateend, lvd_datelimit) >= p_dateset
                       AND organization_id = p_org;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20003, SQLERRM);
         WHEN OTHERS
         THEN
            ROLLBACK;
            raise_application_error (-20003, SQLERRM);
      END;

      ---------------------------------------------------
      --Model Qty = Item Unit Qty
      ---------------------------------------------------
      /*     UPDATE id_eng_bom_temp
               SET model_unit_qty = item_unit_qty,
                   model_unit_qty_ext = item_unit_qty_ext
             WHERE session_id = lvl_session_id
               AND organization_id = p_org ;*/

      ---------------------------------------------------
      --Model Qty Rollup Item Unit Qty for Model Qty
      ---------------------------------------------------
      lvl_return := bom_model_qty (p_org, lvl_session_id);

      IF lvl_return < 0
      THEN
         raise_application_error (
            -20003,
            'BOM Model QTY Calculation Error ' || SQLERRM);
      END IF;

      RETURN lvl_session_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20003, SQLERRM);
      WHEN OTHERS
      THEN
         raise_application_error (-20003, SQLERRM);
   END;

   ---------------------------------------------------------------
   --
   -- BOM CONFIRM
   --
   ---------------------------------------------------------------
   FUNCTION bom_translation (p_work_no         IN NUMBER,
                             p_set_item_code   IN VARCHAR2,
                             p_org             IN NUMBER)
      RETURN NUMBER
   IS
   BEGIN
      INSERT INTO id_eng_bom (parent_item_code,
                              child_item_code,
                              organization_id,
                              dateset,
                              sort_sequence,
                              item_unit_qty,
                              item_unit_qty_ext,
                              workstage_code,
                              bom_work_no,
                              dateend,
                              item_type,
                              line_type,
                              loss_rate,
                              scrap_rate,
                              assy_explosion_yn,
                              location_info,
                              enter_by,
                              enter_date,
                              last_modify_by,
                              last_modify_date,
                              item_code ,
                              REVISION ,
                              PCB_ITEM)
         SELECT parent_item_code,
                child_item_code,
                organization_id,
                TRUNC (dateset),
                sort_sequence,
                item_unit_qty,
                item_unit_qty_ext,
                workstage_code,
                bom_work_no,
                dateend,
                item_type,
                line_type,
                loss_rate,
                scrap_rate,
                NVL (assy_explosion_yn, 'Y'),
                location_info,
                enter_by,
                SYSDATE,
                last_modify_by,
                SYSDATE ,
                item_code ,
                REVISION,
                PCB_ITEM
           FROM id_eng_bom_workspace
          WHERE     bom_work_no = p_work_no
                AND item_code = p_set_item_code
                AND organization_id = p_org
                AND new_bom_yn = 'Y'
                AND (parent_item_code, child_item_code) NOT IN
                       (SELECT NVL (parent_item_code, '*'),
                               NVL (child_item_code, '*')
                          FROM id_eng_bom
                         WHERE TRUNC (dateset) <= TRUNC (SYSDATE)
                               AND dateend >= TRUNC (SYSDATE));

      DELETE FROM id_eng_bom_workspace
       WHERE     bom_work_no = p_work_no
             AND item_code = p_set_item_code
             AND organization_id = p_org
             AND new_bom_yn = 'Y';

      RETURN SQL%ROWCOUNT;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         ROLLBACK;
         raise_application_error (-20003, SQLERRM);
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20003, SQLERRM);
   END;

   ----------------------------------------------------------------
   --
   ----------------------------------------------------------------
   FUNCTION bom_loop_check (p_parent_item_code   IN VARCHAR2,
                            p_child_item_code    IN VARCHAR2,
                            p_dateset            IN DATE,
                            p_org                IN NUMBER)
      RETURN NUMBER
   IS
      lvi_rowcnt_rev   NUMBER;
      lvi_rowcnt_seq   NUMBER;
   BEGIN
      SELECT COUNT (*)
        INTO lvi_rowcnt_seq
        FROM id_eng_bom
       WHERE parent_item_code = p_child_item_code AND organization_id = p_org
             AND p_parent_item_code IN
                    (SELECT child_item_code
                       FROM id_eng_bom
                      WHERE organization_id = p_org AND dateend >= p_dateset
                     START WITH parent_item_code = p_child_item_code
                                AND (organization_id = p_org
                                     AND dateend >= p_dateset)
                     CONNECT BY PRIOR child_item_code = parent_item_code
                                AND (organization_id = p_org
                                     AND TRUNC (dateset) >= p_dateset))
             AND dateend >= p_dateset;

      SELECT COUNT (*)
        INTO lvi_rowcnt_rev
        FROM id_eng_bom
       WHERE parent_item_code = p_child_item_code AND organization_id = p_org
             AND p_parent_item_code IN
                    (SELECT child_item_code
                       FROM id_eng_bom
                      WHERE organization_id = p_org AND dateend >= p_dateset
                     START WITH child_item_code = p_parent_item_code
                                AND (organization_id = p_org
                                     AND dateend >= p_dateset)
                     CONNECT BY PRIOR parent_item_code = child_item_code
                                AND (organization_id = p_org
                                     AND dateend >= p_dateset))
             AND dateend >= p_dateset;

      IF lvi_rowcnt_rev > 0 OR lvi_rowcnt_seq > 0
      THEN
         RETURN -1;
      ELSE
         RETURN 0;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20003, SQLERRM);
      WHEN OTHERS
      THEN
         raise_application_error (-20003, SQLERRM);
   END;

   ----------------------------------------------------------------
   --
   ----------------------------------------------------------------
   FUNCTION bom_loop_check_eco (p_parent_item_code   IN VARCHAR2,
                                p_child_item_code    IN VARCHAR2,
                                p_dateset            IN DATE,
                                p_org                IN NUMBER)
      RETURN NUMBER
   IS
      lvi_rowcnt_rev   NUMBER;
      lvi_rowcnt_seq   NUMBER;
   BEGIN
      SELECT COUNT (*)
        INTO lvi_rowcnt_seq
        FROM id_eng_bom_eco_workspace
       WHERE parent_item_code = p_child_item_code AND organization_id = p_org
             AND p_parent_item_code IN
                    (SELECT child_item_code
                       FROM id_eng_bom_eco_workspace
                      WHERE organization_id = p_org AND dateend >= p_dateset
                     START WITH parent_item_code = p_child_item_code
                                AND (organization_id = p_org
                                     AND dateend >= p_dateset)
                     CONNECT BY PRIOR child_item_code = parent_item_code
                                AND (organization_id = p_org
                                     AND dateend >= p_dateset))
             AND dateend >= p_dateset;

      SELECT COUNT (*)
        INTO lvi_rowcnt_rev
        FROM id_eng_bom_eco_workspace
       WHERE parent_item_code = p_child_item_code AND organization_id = p_org
             AND p_parent_item_code IN
                    (SELECT child_item_code
                       FROM id_eng_bom_eco_workspace
                      WHERE organization_id = p_org AND dateend >= p_dateset
                     START WITH child_item_code = p_parent_item_code
                                AND (organization_id = p_org
                                     AND dateend >= p_dateset)
                     CONNECT BY PRIOR parent_item_code = child_item_code
                                AND (organization_id = p_org
                                     AND dateend >= p_dateset))
             AND dateend >= p_dateset;

      IF lvi_rowcnt_rev > 0 OR lvi_rowcnt_seq > 0
      THEN
         RETURN -1;
      ELSE
         RETURN 0;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20003, SQLERRM);
      WHEN OTHERS
      THEN
         raise_application_error (-20003, SQLERRM);
   END;

   ----------------------------------------------------------------
   --BOM ECO CONFIRM
   --
   ----------------------------------------------------------------
   FUNCTION bom_eco_confirm (p_eco_work_no IN NUMBER, p_org IN NUMBER)
      RETURN NUMBER
   IS
      lvi_count   NUMBER;

      CURSOR cl1
      IS
         SELECT bom_work_no,
                eco_type,
                before_parent_item_code,
                before_child_item_code,
                parent_item_code,
                child_item_code,
                item_unit_qty,
                item_unit_qty_ext,
                TRUNC (dateset) dateset,
                TRUNC (dateend) dateend,
                workstage_code,
                sort_sequence,
                item_type,
                line_type,
                loss_rate,
                scrap_rate,
                NVL (assy_explosion_yn, 'Y') assy_explosion_yn,
                enter_date,
                enter_by,
                last_modify_date,
                last_modify_by,
                organization_id,
                item_code ,
                REVISION,
                PCB_ITEM
           FROM id_eng_bom_eco_workspace
          WHERE     bom_work_no = p_eco_work_no
                AND NVL (eco_apply_yn, 'N') = 'N'
                AND organization_id = p_org;

      v_rows      cl1%ROWTYPE;
   BEGIN
      BEGIN
         SELECT COUNT (*)
           INTO lvi_count
           FROM id_eng_bom_eco_workspace
          WHERE     bom_work_no = p_eco_work_no
                AND NVL (eco_apply_yn, 'N') = 'N'
                AND organization_id = p_org;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RETURN -1;
      END;

      IF lvi_count = 0
      THEN
         RETURN -2;
      END IF;

      phase := 20;

      OPEN cl1;

      LOOP
         FETCH cl1 INTO v_rows;

         IF cl1%NOTFOUND
         THEN
            CLOSE cl1;

            EXIT;
         END IF;

         IF v_rows.eco_type = 'D'
         THEN                                                    -- delete eco
            UPDATE id_eng_bom
               SET dateend = v_rows.dateset - 1
             WHERE     parent_item_code = v_rows.before_parent_item_code
                   AND child_item_code = v_rows.before_child_item_code
                   AND TRUNC (dateend) >= TRUNC (v_rows.dateset)
                   AND organization_id = v_rows.organization_id;

            phase := 30;
         ELSIF    v_rows.eco_type = 'I'
               OR v_rows.eco_type = 'C'
               OR v_rows.eco_type = 'M'
         THEN                                    -- insert child insert modify
            lvi_count := 0;

            SELECT COUNT (*)
              INTO lvi_count
              FROM id_eng_bom
             WHERE     parent_item_code = v_rows.parent_item_code
                   AND child_item_code = v_rows.child_item_code
                   AND TRUNC (dateset) = TRUNC (v_rows.dateset)
                   AND TRUNC (dateend) < TRUNC (dateset)
                   AND organization_id = v_rows.organization_id;

            IF lvi_count > 0
            THEN
               UPDATE id_eng_bom
                  SET dateset = dateend
                WHERE     parent_item_code = v_rows.parent_item_code
                      AND child_item_code = v_rows.child_item_code
                      AND TRUNC (dateset) = TRUNC (v_rows.dateset)
                      AND TRUNC (dateend) < TRUNC (dateset)
                      AND organization_id = v_rows.organization_id;
            END IF;

            UPDATE id_eng_bom
               SET dateend = v_rows.dateset - 1
             WHERE     parent_item_code = v_rows.parent_item_code
                   AND child_item_code = v_rows.child_item_code
                   AND TRUNC (dateend) >= TRUNC (v_rows.dateset)
                   AND organization_id = v_rows.organization_id;

            INSERT INTO id_eng_bom (bom_work_no,
                                    parent_item_code,
                                    child_item_code,
                                    organization_id,
                                    dateset,
                                    sort_sequence,
                                    item_unit_qty,
                                    item_unit_qty_ext,
                                    workstage_code,
                                    dateend,
                                    item_type,
                                    line_type,
                                    loss_rate,
                                    scrap_rate,
                                    assy_explosion_yn,
                                    enter_by,
                                    enter_date,
                                    last_modify_by,
                                    last_modify_date,
                                    item_code ,
                                    REVISION,
                                    PCB_ITEM)
            VALUES (v_rows.bom_work_no,
                    v_rows.parent_item_code,
                    v_rows.child_item_code,
                    v_rows.organization_id,
                    v_rows.dateset,
                    v_rows.sort_sequence,
                    v_rows.item_unit_qty,
                    v_rows.item_unit_qty_ext,
                    v_rows.workstage_code,
                    v_rows.dateend,
                    v_rows.item_type,
                    v_rows.line_type,
                    v_rows.loss_rate,
                    v_rows.scrap_rate,
                    v_rows.assy_explosion_yn,
                    v_rows.enter_by,
                    SYSDATE,
                    v_rows.last_modify_by,
                    SYSDATE,
                    v_rows.item_code ,
                    v_rows.revision,
                    v_rows.PCB_ITEM
                    

                    );
         ELSIF v_rows.eco_type = 'R'
         THEN                                                    --replace eco
            UPDATE id_eng_bom
               SET dateend = v_rows.dateset - 1
             WHERE     parent_item_code = v_rows.before_parent_item_code
                   AND child_item_code = v_rows.before_child_item_code
                   AND TRUNC (dateend) >= TRUNC (v_rows.dateset)
                   AND organization_id = v_rows.organization_id;

            phase := 40;

            INSERT INTO id_eng_bom (bom_work_no,
                                    parent_item_code,
                                    child_item_code,
                                    organization_id,
                                    dateset,
                                    sort_sequence,
                                    item_unit_qty,
                                    item_unit_qty_ext,
                                    workstage_code,
                                    dateend,
                                    item_type,
                                    line_type,
                                    loss_rate,
                                    scrap_rate,
                                    assy_explosion_yn,
                                    enter_by,
                                    enter_date,
                                    last_modify_by,
                                    last_modify_date,
                                    item_code,
                                    revision,
                                    PCB_ITEM)
            VALUES (v_rows.bom_work_no,
                    v_rows.parent_item_code,
                    v_rows.child_item_code,
                    v_rows.organization_id,
                    v_rows.dateset,
                    v_rows.sort_sequence,
                    v_rows.item_unit_qty,
                    v_rows.item_unit_qty_ext,
                    v_rows.workstage_code,
                    v_rows.dateend,
                    v_rows.item_type,
                    v_rows.line_type,
                    v_rows.loss_rate,
                    v_rows.scrap_rate,
                    v_rows.assy_explosion_yn,
                    v_rows.enter_by,
                    SYSDATE,
                    v_rows.last_modify_by,
                    SYSDATE,
                    v_rows.item_code ,
                    v_rows.revision,
                    v_rows.PCB_ITEM
                    );
         END IF;
      END LOOP;

      phase := 50;

      UPDATE id_eng_bom_eco_workspace
         SET eco_apply_yn = 'Y'
       WHERE     bom_work_no = p_eco_work_no
             AND NVL (eco_apply_yn, 'N') = 'N'
             AND organization_id = p_org;

      phase := 60;

      INSERT INTO id_eng_bom_eco_workspace_his (bom_work_no,
                                                before_parent_item_code,
                                                before_child_item_code,
                                                organization_id,
                                                dateset,
                                                dateend,
                                                before_dateset,
                                                before_dateend,
                                                child_item_code,
                                                parent_item_code,
                                                eco_type,
                                                eco_reason_code,
                                                eco_apply_yn,
                                                item_code,
                                                before_item_unit_qty,
                                                before_item_unit_qty_ext,
                                                item_unit_qty,
                                                item_unit_qty_ext,
                                                workstage_code,
                                                sort_sequence,
                                                item_type,
                                                line_type,
                                                loss_rate,
                                                scrap_rate,
                                                assy_explosion_yn,
                                                enter_by,
                                                enter_date,
                                                last_modify_by,
                                                last_modify_date,
                                                revision ,
                                                PCB_ITEM)
         SELECT b.bom_work_no,
                b.before_parent_item_code,
                b.before_child_item_code,
                b.organization_id,
                TRUNC (b.dateset),
                TRUNC (b.dateend),
                b.before_dateset,
                b.before_dateend,
                b.child_item_code,
                b.parent_item_code,
                b.eco_type,
                b.eco_reason_code,
                b.eco_apply_yn,
                b.item_code,
                b.before_item_unit_qty,
                b.before_item_unit_qty_ext,
                b.item_unit_qty,
                b.item_unit_qty_ext,
                b.workstage_code,
                b.sort_sequence,
                b.item_type,
                b.line_type,
                b.loss_rate,
                b.scrap_rate,
                NVL (b.assy_explosion_yn, 'Y'),
                b.enter_by,
                b.enter_date,
                b.last_modify_by,
                b.last_modify_date,

                B.REVISION,
                B.PCB_ITEM
           FROM id_eng_bom_eco_workspace b
          WHERE     b.bom_work_no = p_eco_work_no
                AND NVL (b.eco_apply_yn, 'N') = 'Y'
                AND                                       -- ECO Not Confirmed
                   b.organization_id = p_org;

      phase := 70;

      DELETE FROM id_eng_bom_eco_workspace
       WHERE     bom_work_no = p_eco_work_no
             AND NVL (eco_apply_yn, 'N') = 'Y'
             AND                                               --ECO Confirmed
                organization_id = p_org;

      phase := 80;
      RETURN SQL%ROWCOUNT;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20003, 'Phase=' || phase || SQLERRM);
      WHEN OTHERS
      THEN
         raise_application_error (
            -20003,
               v_rows.parent_item_code
            || ' '
            || v_rows.child_item_code
            || ' '
            || v_rows.dateset
            || ' Phase='
            || phase
            || SQLERRM);
   END;

   FUNCTION bom_copy (p_bom_work_no             IN NUMBER,
                      p_source_item_code        IN VARCHAR2,
                      p_dest_parent_item_code   IN VARCHAR2,
                      p_dest_item_code          IN VARCHAR,
                      p_dateset                    DATE,
                      p_org                     IN NUMBER)
      RETURN NUMBER
   IS
      lvd_datelimit   DATE := TO_DATE ('9999/12/31', 'yyyy/mm/dd');
   BEGIN
      INSERT INTO id_eng_bom_workspace (bom_work_no,
                                        parent_item_code,
                                        child_item_code,
                                        organization_id,
                                        dateset,
                                        new_bom_yn,
                                        item_code,
                                        sort_sequence,
                                        item_unit_qty,
                                        item_unit_qty_ext,
                                        workstage_code,
                                        dateend,
                                        item_type,
                                        line_type,
                                        loss_rate,
                                        scrap_rate,
                                        assy_explosion_yn,
                                        enter_by,
                                        enter_date,
                                        last_modify_by,
                                        last_modify_date,

                                        revision,
                                        PCB_ITEM)
         SELECT p_bom_work_no,
                p_dest_parent_item_code,
                p_dest_item_code,
                organization_id,
                dateset,
                'Y',
                p_dest_item_code,
                sort_sequence,
                item_unit_qty,
                item_unit_qty_ext,
                workstage_code,
                dateend,
                item_type,
                line_type,
                loss_rate,
                scrap_rate,
                NVL (assy_explosion_yn, 'Y'),
                enter_by,
                enter_date,
                last_modify_by,
                last_modify_date,
                                revision ,
                                PCB_ITEM
           FROM id_eng_bom
          WHERE     child_item_code = p_source_item_code
                AND TRUNC (dateset) <= p_dateset
                AND NVL (dateend, lvd_datelimit) >= p_dateset
                AND ROWNUM = 1
                AND organization_id = p_org;

      INSERT INTO id_eng_bom_workspace (bom_work_no,
                                        parent_item_code,
                                        child_item_code,
                                        organization_id,
                                        dateset,
                                        new_bom_yn,
                                        item_code,
                                        sort_sequence,
                                        item_unit_qty,
                                        item_unit_qty_ext,
                                        workstage_code,
                                        dateend,
                                        item_type,
                                        line_type,
                                        loss_rate,
                                        scrap_rate,
                                        assy_explosion_yn,
                                        enter_by,
                                        enter_date,
                                        last_modify_by,
                                        last_modify_date,

                                        revision,
                                        PCB_ITEM)
         SELECT p_bom_work_no,
                p_dest_item_code,
                child_item_code,
                organization_id,
                TRUNC (dateset),
                'Y',
                p_dest_item_code,
                sort_sequence,
                item_unit_qty,
                item_unit_qty_ext,
                workstage_code,
                dateend,
                item_type,
                line_type,
                loss_rate,
                scrap_rate,
                NVL (assy_explosion_yn, 'Y'),
                enter_by,
                enter_date,
                last_modify_by,
                last_modify_date,

                revision,
                PCB_ITEM
           FROM id_eng_bom
          WHERE     parent_item_code = p_source_item_code
                AND TRUNC (dateset) <= p_dateset
                AND NVL (dateend, lvd_datelimit) >= p_dateset
                AND organization_id = p_org;

      RETURN SQL%ROWCOUNT;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20003, SQLERRM);
      WHEN OTHERS
      THEN
         raise_application_error (-20003, SQLERRM);
   END;
-- Enter further code below as specified in the Package spec.
END;