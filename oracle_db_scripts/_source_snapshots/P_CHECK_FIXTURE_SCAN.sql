PROCEDURE "P_CHECK_FIXTURE_SCAN" (
   p_line_code    IN     VARCHAR2,
   p_model_name   IN     VARCHAR2,
   p_barcode      IN     VARCHAR2,
   p_deficit      IN     VARCHAR2,
   p_out             OUT VARCHAR2)
IS
   lvs_jig_status    VARCHAR2 (20);
   lvs_item_code     VARCHAR2 (20);
   lvl_break_value   NUMBER;
   lvl_hit_value     NUMBER;
   lvs_ip_address    VARCHAR2 (20);
   lvs_use_nsnp_yn   VARCHAR2 (1);
   phase             VARCHAR2 (20);
BEGIN
   phase := '10';

   BEGIN
      SELECT NVL (item_code, '*'),
             NVL (break_value, 0),
             NVL (hit_value, 0),
             jig_status,
             NVL (use_nsnp_yn, 'N')
        INTO lvs_item_code,
             lvl_break_value,
             lvl_hit_value,
             lvs_jig_status,
             lvs_use_nsnp_yn
        FROM imcn_jig
       WHERE     jig_lot_no = p_barcode
             AND organization_id = 1
             AND jig_type = 'T';

      phase := '20';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         IF lvs_use_nsnp_yn = 'Y'
         THEN
            NULL;
         --            BEGIN
         --               --------------------------------------------------------------------------------
         --               -- NSNP START
         --               --------------------------------------------------------------------------------
         --               p_interlock_set_nsnp_msg (p_line_code,
         --                                         1,
         --                                         p_model_name,
         --                                         '*',
         --                                         'FIXTURE CHECK',
         --                                         'NO NOT FOUND ' || p_barcode);
         --            --------------------------------------------------------------------------------
         --            -- NSNP END
         --            --------------------------------------------------------------------------------
         --            EXCEPTION
         --               WHEN OTHERS
         --               THEN
         --                  NULL;
         --            END;
         END IF;

         --------------------------------------------------------------------------------
         -- NSNP END
         --------------------------------------------------------------------------------
         p_out := f_msg('픽스쳐정보가 없습니다.', 'K', 1)
                  || ' = '
                  ||'Line='
                  || p_line_code
                  || ', '
                  || 'Model='
                  || p_model_name
                  || ', '
                  || 'Barcode='
                  || p_barcode ;
         RETURN;
   END;

  phase := '30';

   IF p_deficit = 'N'
   THEN
      ---------------------------------------------------------------------------
      --
      ---------------------------------------------------------------------------
      BEGIN
         SELECT NVL (item_code, '*')
           INTO lvs_item_code
           FROM imcn_jig_apply_model
          WHERE     jig_lot_no = p_barcode
                AND item_code = p_model_name
                AND organization_id = 1;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            lvs_item_code := '*';
      END;
  phase := '40';
      --------------------------------------------------------------------------
      -- ITEM UNMATCH ERROR
      --------------------------------------------------------------------------
      IF NVL(lvs_item_code, '*') <> p_model_name THEN
        
         p_out :=  f_msg('적용모델이 일치하지 않습니다.', 'K', 1)    -- Model Unmatch
                   || ' = '
                   || lvs_item_code
                   || ', '
                   || p_model_name;
         RETURN;
         
      END IF;


      phase := '50';

      -------------------------------------------------------------------------------------------
      --
      -------------------------------------------------------------------------------------------

      IF lvs_jig_status <> 'Z'
      THEN
         IF lvs_use_nsnp_yn = 'Y'
         THEN
            NULL;
         --            BEGIN
         --               --------------------------------------------------------------------------------
         --               -- NSNP START
         --               --------------------------------------------------------------------------------
         --               p_interlock_set_nsnp_msg (p_line_code,
         --                                         1,
         --                                         p_model_name,
         --                                         '*',
         --                                         'FIXTURE CHECK',
         --                                         'STATUS NOT NORMAL ' || p_barcode);
         --            --------------------------------------------------------------------------------
         --            -- NSNP END
         --            --------------------------------------------------------------------------------
         --            EXCEPTION
         --               WHEN OTHERS
         --               THEN
         --                  NULL;
         --            END;
         END IF;

         --------------------------------------------------------------------------------
         -- NSNP END
         --------------------------------------------------------------------------------
         p_out := f_msg('픽스쳐 상태가 비정상 입니다.', 'K', 1);     --Fixture Status Invalid
         RETURN;
         
      END IF;
      
      phase := '60';
      
      -------------------------------------------------------------------------------------------
      --
      -------------------------------------------------------------------------------------------

      IF lvl_break_value <= lvl_hit_value
      THEN
         IF lvs_use_nsnp_yn = 'Y'
         THEN
            NULL;
         --            BEGIN
         --               --------------------------------------------------------------------------------
         --               -- NSNP START
         --               --------------------------------------------------------------------------------
         --               p_interlock_set_nsnp_msg (p_line_code,
         --                                         1,
         --                                         p_model_name,
         --                                         '*',
         --                                         'FIXTURE CHECK',
         --                                         'LIFE CYCLE OVER ' || p_barcode);
         --            --------------------------------------------------------------------------------
         --            -- NSNP END
         --            --------------------------------------------------------------------------------
         --            EXCEPTION
         --               WHEN OTHERS
         --               THEN
         --                  NULL;
         --            END;
         END IF;
         
  phase := '70';
  
         p_out := f_msg('유효수명초을 초과 했습니다.', 'K', 1);  -- Life Cycle Over
         RETURN;
         
      ELSE
         --------------------------------------------------------------------
         -- 기존 라인에서 뺴고 신규 라인으로 설정
         --------------------------------------------------------------------

         UPDATE imcn_jig
            SET line_code = '*'                         --, machine_code = '*'
          WHERE     jig_lot_no <> p_barcode
            AND line_code = SUBSTR (p_line_code, 1, 2) 
                AND organization_id = 1
                AND jig_type = 'T';


         UPDATE imcn_jig
            SET line_code = SUBSTR (p_line_code, 1, 2)      --, machine_code = p_machine_code
          WHERE     jig_lot_no = p_barcode
                AND organization_id = 1
                AND jig_type = 'T';

  phase := '90';
         COMMIT;

         p_out := 'OK';
         RETURN;
      END IF;
   ELSE
      --------------------------------------------------------------------
      -- 기존 라인에서 뺴고 신규 라인으로 설정
      --------------------------------------------------------------------

      UPDATE imcn_jig
         SET line_code = '*'                            --, machine_code = '*'
       WHERE     jig_lot_no = p_barcode
             AND organization_id = 1
             AND jig_type = 'T';

      COMMIT;

      p_out := 'OK';
      RETURN;
   END IF;

   phase := '70';
-------------------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------------------
EXCEPTION
   WHEN OTHERS
   THEN
      p_out := 'NG '
               || 'PHASE='
               || phase
               || ', '
               || p_barcode
               || ', '
               || SQLERRM;
      RETURN;
END;