PROCEDURE "P_INTERLOCK_CHECK_JIG" (
   p_line_code        IN     VARCHAR2,
   p_workstage_code   IN     VARCHAR2,
   p_machine_code     IN     VARCHAR2,
   p_result              OUT VARCHAR2,
   p_jig_model_name      OUT VARCHAR2,
   p_jig_type            OUT VARCHAR2,
   p_jig_code            OUT VARCHAR2,
   p_jig_lot_no          OUT VARCHAR2,
   p_hit_count           OUT VARCHAR2)
IS
   lvl_count            NUMBER;
   lvs_jig_model_name   VARCHAR2 (30);
   lvs_jig_type         VARCHAR2 (30);
   lvs_jig_code         VARCHAR2 (30);
   lvs_jig_lot_no       VARCHAR2 (20);
   lvl_break_value      NUMBER;
   lvl_hit_value        NUMBER;
   lvs_jit_type_param   VARCHAR2 (10);
BEGIN
   --   ------------------------------------------------------------------
   --   --  TEMPORARY SETUP
   --   ------------------------------------------------------------------
   --   p_jig_model_name := 'START';
   --   p_jig_type := '*';
   --   p_jig_code := '*';
   --   p_hit_count := 0;
   --   p_jig_lot_no := '*';
   --   p_result := 'OK';
   --   RETURN;

   -----------------------------------------------------------
   -- RETURN : MODEL , TYPE , ITEM_CODE , LOT_NO , COUNT
   -----------------------------------------------------------
   -- T :  FIXTURE
   -- M : METAL MASK
   -----------------------------------------------------------
   IF F_GET_WORKSTAGE_TYPE(p_workstage_code )  = 'ICT'                           --ICT 공정이면 픽스쳐 지그 조회
   THEN
      lvs_jit_type_param := 'T';                                         --픽스쳐
   ELSIF F_GET_WORKSTAGE_TYPE(p_workstage_code )  = 'SPI'                                -- SP 공정이면
   THEN
      lvs_jit_type_param := 'M';                                         --마스크
   ELSE
      lvs_jit_type_param := '*';                                          --기타
   END IF;


   SELECT jig_model_name,
  -- jig_type ,
         DECODE(jig_type,'M' , 'MASK' ,'S' ,'SQUEEZE' , 'T' , 'FIXTURE' , jig_type ) ,
          jig_code,
          jig_lot_no,
          NVL (break_value, 0),
          NVL (hit_value, 0)
     INTO lvs_jig_model_name,
          lvs_jig_type,
          lvs_jig_code,
          lvs_jig_lot_no,
          lvl_break_value,
          lvl_hit_value
     FROM imcn_jig
    WHERE     line_code = p_line_code
          AND jig_type = lvs_jit_type_param
          AND ROWNUM = 1;

   IF lvl_break_value > lvl_hit_value
   THEN
      p_jig_model_name := lvs_jig_model_name;
      p_jig_type := lvs_jig_type;
      p_jig_code := lvs_jig_code;
      p_hit_count := lvl_hit_value;
      p_jig_lot_no := lvs_jig_lot_no;

      p_result := 'OK';
   ELSE
      p_jig_model_name := f_msg('수명초과','C',1);
      p_jig_type := lvs_jig_type;
      p_jig_code := lvs_jig_code;
      p_hit_count := lvl_hit_value;
      p_jig_lot_no := lvs_jig_lot_no;
      p_result := 'NG';
   END IF;

   RETURN;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      p_jig_model_name := f_msg('정보없음','C',1);
      p_jig_type := '*';
      p_jig_code := '*';
      p_hit_count := 0;
      p_jig_lot_no := '*';
      p_result := 'OK';
      RETURN;
   WHEN OTHERS
   THEN
      p_jig_model_name := f_msg('정보없음','C',1);
      p_jig_type := '*';
      p_jig_code := '*';
      p_hit_count := 0;
      p_jig_lot_no := '*';
      p_result := 'ERROR' || SQLERRM;
      RETURN;
END;                                                              -- Procedure