PROCEDURE "P_INTERLOCK_FEEDER_ACTUAL" (
   p_line_code    IN     VARCHAR2,
   p_feeder_layout_name   IN     VARCHAR2,
   p_actual_qty   IN     NUMBER,
   p_out             OUT VARCHAR2)
IS
    lvl_remain          NUMBER;
    lvl_carrier_qty     NUMBER := 1;
    LVF_REMAIN_TIME     NUMBER;
    LVI_ITEM_UNIT_QTY   NUMBER;
    lvs_location_code   VARCHAR2 (30);
    LVS_ERRORMSG        VARCHAR2 (1000);
    lvl_minus_limit     number := 0 ;
    lvs_config_value    VARCHAR2(100) ;
    lvs_smt_model_name  varchar2(100) ;
    lvi_no_ccs                NUMBER;
    lvs_no_css_address        VARCHAR2 (30);
    phase varchar2(10) ;
    
BEGIN
      
------------------------------------
-- SYSTEM CONFIG VALUE GET
-- CURRENT VALUE = Y
------------------------------------
phase :='10' ;
   BEGIN
      SELECT NVL (config_value, '0')
        INTO lvs_config_value
        FROM isys_config
       WHERE config_name = 'MINUS_INTERLOCK_LIMIT'
         AND use_yn = 'Y' ;
         
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvs_config_value := '0'; --PRODUCT RESULT
   
   END;

   lvl_minus_limit := TO_NUMBER(lvs_config_value) ;
      
--------------------------------------------------------------
-- 단위수량 체크 
-- 최소수량이 1 이 있다는 뜻은  어레이 라도 한개의 PCB 기준으로 
-- 레시피를 만들었기 때문에 소요량이 1 이 나오고  1 이 없다는건 어레이
-- 수량만큼 소요량을 감안해서 레시피를 만들었다는 뜻이됨.
--------------------------------------------------------------
phase :='20' ;
   BEGIN
      SELECT MIN (ITEM_UNIT_QTY) ,max( smt_model_name)
        INTO LVI_ITEM_UNIT_QTY , lvs_smt_model_name
        FROM ib_product_plandata
       WHERE     line_code = SUBSTR(p_line_code,1,2)
             AND model_name = p_feeder_layout_name
             AND active_yn = 'Y';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         LVI_ITEM_UNIT_QTY := 1;
      WHEN OTHERS
      THEN
         LVI_ITEM_UNIT_QTY := 1;
   END;

phase :='30' ;

--   ----------------------------------------------------------------------------
--   -- 1 이 아니라는 뜻은 레시피가 에레이 단위로 짜여져 있으므로 
--   -- 어레이를 알아야 함.
--   ----------------------------------------------------------------------------
--   IF NVL (LVI_ITEM_UNIT_QTY, 0) <> 1
--   THEN
--      lvl_carrier_qty := NVL (F_GET_CARRIER_SIZE_BY_SMT (lvs_smt_model_name, 1), 1);
--   ELSE
--      lvl_carrier_qty := 1;
--   END IF;
    
   --------------------------------------------------------------------------------
   -- ccs 여부체크 
   --------------------------------------------------------------------------------
   phase :='40' ;
       BEGIN
           SELECT   COUNT ( * ), MAX (location_code)
             INTO   lvi_no_ccs, lvs_no_css_address
             FROM   ib_product_plandata
            WHERE       model_name = UPPER (p_feeder_layout_name)
                    AND line_code = SUBSTR (p_line_code, 1, 2)
                  --  AND pcb_item = lvs_topbot
                    AND active_yn = 'Y'
                    AND ccs_yn = 'N'
                    AND ROWNUM = 1 ;
       EXCEPTION
           WHEN NO_DATA_FOUND
           THEN
               lvi_no_ccs := 0;
       END;
 phase :='50' ;     
       IF NVL(lvi_no_ccs,0) > 0 OR lvi_no_ccs is null  THEN
   
            
            BEGIN
                --------------------------------------------------------------------------------
                -- NSNP START
                --------------------------------------------------------------------------------
                p_interlock_set_nsnp_time_msg (
                p_line_code,
                1,
                1,
                p_feeder_layout_name,
                '*',
                'CCS COMPLETE CHECK',
                f_msg('00 CSS NOT COMPLETED ','C',1));
                --------------------------------------------------------------------------------
                -- NSNP END
                --------------------------------------------------------------------------------
            EXCEPTION WHEN OTHERS THEN
                NULL;
            END;
            p_out := '00 CSS NOT COMPLETED'||' '||lvs_no_css_address;
            ------------------------------------------------------------------------------------
            --
            ------------------------------------------------------------------------------------
            RETURN;
       END IF ;
              
   ---------------------------------------------------------------------------
   -- FEEDER ACTUAL QTY
   -- 실적이 넘어올때 미리 어레이 수량 감안된 수량을 넘기도록 되어 있으므로 
   -- 여기서는 어레이 감안 안함
   -- ACTUAL 에서 보내온 수량은 사용 안하고 횟수를 가지고 카운트 실적으로 처리함
   -- 
   ----------------------------------------------------------------------------
   
   phase :='60' ;
   UPDATE ib_product_plandata
    --  SET product_actual_qty =NVL( product_actual_qty,0) + ( (NVL (item_unit_qty, 0) / lvl_carrier_qty) * 1) ,
      SET product_actual_qty = NVL (item_unit_qty, 0) * p_actual_qty , --p_actual_qty 이 연배열 감안된 누적 수량이 넘어온다는 전제로 
          last_actual_date = sysdate ,
          sensor_qty = p_actual_qty
    WHERE     line_code = SUBSTR (p_line_code, 1, 2)
          AND model_name = p_feeder_layout_name
          AND active_yn = 'Y';

   -------------------------------------------------------------------------------------------
   -- 피더 잔량이 0 이하 인 위치 건수 조회
   --
   -------------------------------------------------------------------------------------------
  phase :='70' ;
  
   BEGIN
     
      SELECT COUNT (*), MAX (LOCATION_CODE)
        INTO lvl_remain, lvs_location_code
        FROM ib_product_plandata
       WHERE     line_code = p_line_code
             AND active_yn = 'Y'
             AND NVL (PRODUCT_ACTUAL_QTY, 0) > 0
             AND LOCATION_CODE NOT LIKE 'TRAY%'
             AND NVL (feeding_qty, 0) - ABS (product_actual_qty) < lvl_minus_limit;
             
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvl_remain := 0;
   END;
phase :='80' ;

/*  ----------------------

  IF lvl_remain > 0 THEN
          
      BEGIN
         --------------------------------------------------------------------------------
         -- NSNP START
         -- 정지 대기 시간을 줘서 세운다
         -- NSNP REASON 이 MINUS 인경우
         -- 함수안에서 설비에 설정된 NSNP MINUS CHECK YN 를 체크해서
         -- 장비정지 명령을 스킵한다.
         --------------------------------------------------------------------------------
            p_interlock_set_nsnp_time_msg (
            p_line_code,
            'OPEN',
            1000,                                                 --1 SEC TIME
            p_feeder_layout_name,
            '*',
            'MINUS',                                            -- NSNP REASON
               lvs_location_code
            ||f_msg( '포함 '  ,'C',1)
            || lvl_remain
            ||f_msg( '건의  음수가 발생했습니다. ' ,'C',1)
            || TO_CHAR (SYSDATE, 'YYYY/MM/DD HH24:MI:SS'));
      --------------------------------------------------------------------------------
      -- NSNP END
      --------------------------------------------------------------------------------
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;
   ELSE
   phase :='90' ;
      ------------------------------------------------------------------------------------
      --  잔량이 0 은 아니지만 시간이 기준 시간 이하이면 세운다 .
      ------------------------------------------------------------------------------------

      SELECT COUNT (*), MAX (A.LOCATION_CODE)
        INTO LVF_REMAIN_TIME, lvs_location_code
        FROM ib_product_plandata A, IP_PRODUCT_LINE C
       WHERE     A.LINE_CODE = C.LINE_CODE(+)
             AND A.ORGANIZATION_ID = C.ORGANIZATION_ID(+)
             AND A.LINE_CODE = P_LINE_CODE
             --    AND A.MODEL_NAME = p_feeder_layout_name
             AND A.ACTIVE_YN = 'Y'
             AND NVL (A.PRODUCT_ACTUAL_QTY, 0) > 0
             AND LOCATION_CODE NOT LIKE 'TRAY%'
             AND DECODE (
                    NVL (A.item_unit_qty * C.REAL_ST, 0),
                    0, 0,
                    TRUNC (
                       (NVL (A.FEEDING_QTY, 0)
                        - NVL (A.PRODUCT_ACTUAL_QTY, 0))
                       / A.item_unit_qty
                       * C.REAL_ST
                       / 60,
                       0)) <= 5;

      ------------------------------------------------------------------------------
      --  잔여시간 체크해서 5분 이하면 라인 스톱
      ------------------------------------------------------------------------------
      IF NVL (LVF_REMAIN_TIME, 0) > 0
      THEN
         NULL;
      --         BEGIN
      --            --------------------------------------------------------------------------------
      --            -- NSNP START
      --            -- 정지 대기 시간을 줘서 세운다
      --            --------------------------------------------------------------------------------
      --            p_interlock_set_nsnp_time_msg (
      --               p_line_code,
      --               'OPEN',
      --               1000,                                                    --TIME
      --               p_feeder_layout_name,
      --               '*',
      --               'REEL',
      --               '잔여시간이 5분 이하로 남았습니다.'||lvs_location_code);
      --         --------------------------------------------------------------------------------
      --         -- NSNP END
      --         --------------------------------------------------------------------------------
      --         EXCEPTION
      --            WHEN OTHERS
      --            THEN
      --               NULL;
      --         END;
      --------------------------------------------------------------
      --
      ---------------------------------------------------------------
      ELSE
         NULL;
         UPDATE IP_PRODUCT_LINE
            SET NSNP_STATUS = 'WAIT', NSNP_REASON = ''
          WHERE line_code = p_line_code;
      END IF;
   END IF;
   
   
*/ ----------------------
   
phase :='100' ;
   ------------------------------------------------------------------------------------
   --
   ------------------------------------------------------------------------------------
   p_out := 'OK';

   RETURN;
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
   WHEN OTHERS
   THEN
      LVS_ERRORMSG :=
         '[p_interlock_feeder_actual]' || SUBSTR (SQLERRM, 1, 200);

      INSERT
        INTO ICOM_MACHINE_INSERT_LOG (LOG_DATE, ERROR_MESSAGE, ERROR_DESC)
      VALUES (SYSDATE, NVL(LVS_ERRORMSG,'p_interlock_feeder_actual') , 'PHSE='||phase||'  Line='||p_line_code || ' Feeder Layout Name=' || p_feeder_layout_name||' SMT Model Name='||lvs_smt_model_name);

      COMMIT;
   
END p_interlock_feeder_actual;
