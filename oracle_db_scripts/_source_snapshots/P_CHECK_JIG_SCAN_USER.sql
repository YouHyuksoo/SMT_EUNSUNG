PROCEDURE "P_CHECK_JIG_SCAN_USER" (
   p_line_code    IN     VARCHAR2,
   p_model_name   IN     VARCHAR2,
   p_jig_type     IN     VARCHAR2,   
   p_barcode      IN     VARCHAR2,
   p_deficit      IN     VARCHAR2,
   p_out          OUT    VARCHAR2,
   p_userid       IN     VARCHAR2)
IS
   lvs_line_model        VARCHAR2 (50);
   lvs_line_item_code    VARCHAR2 (50);
   lvs_line_run_no       VARCHAR2 (50);
   
   lvs_jig_status        VARCHAR2 (20);
   lvs_item_code         VARCHAR2 (20);
   lvl_break_value       NUMBER;
   lvl_hit_value         NUMBER;
   lvs_ip_address        VARCHAR2 (20);
   lvs_use_nsnp_yn       VARCHAR2 (1);
   phase                 VARCHAR2 (20);
   
   lvs_jig_line_code     VARCHAR2 (20);
   lvs_jig_model_name    VARCHAR2 (50);
   
   lvs_solder_type   varchar2(10) ;
   lvs_line_model_solder_type VARCHAR2(10) ;
   
   LVS_TENSION_CHECK_YN  VARCHAR2 (20);
   
BEGIN
  
   phase := '10';
   
   ---------------------------------------------------------------
   -- JIG 바코드 확인
   ---------------------------------------------------------------
   
   phase := '20';
         
   BEGIN
     
      SELECT NVL (break_value, 0),
             NVL (hit_value, 0),
             jig_status,
             NVL (use_nsnp_yn, 'N'),
             NVL (line_code, '*'),
             solder_type,
             NVL(TENSION_CHECK_YN, 'N') 
        INTO lvl_break_value,
             lvl_hit_value,
             lvs_jig_status,
             lvs_use_nsnp_yn,
             lvs_jig_line_code,
             lvs_solder_type,
             LVS_TENSION_CHECK_YN
        FROM imcn_jig
       WHERE jig_lot_no      = p_barcode
         AND jig_type        = p_jig_type
         AND organization_id = 1;
      
   EXCEPTION
     
      WHEN NO_DATA_FOUND THEN
        
         p_out :=  f_msg('스캔한 지그 바코드가 없습니다.','K',1)
                   || ' = '
                   || 'JIG Type ='
                   || p_jig_type
                   || ', '
                   || 'Model='
                   || p_model_name
                   || ', '
                   || 'Barcode='
                   || p_barcode;
                  
         RETURN;
   END;

   ------------------------------------------------------------------
   -- 솔더 주걱은 별도 체크처리 
   -- 유무연 타입만 비교 
   ------------------------------------------------------------------
   IF p_jig_type = 'H' then 
   
        SELECT SOLDER_TYPE
           INTO lvs_line_model_solder_type
           FROM IP_PRODUCT_LINE
          where line_code = SUBSTR(p_line_code, 1, 2)
            and organization_id = 1;
            
         IF ( lvs_solder_type <> lvs_line_model_solder_type ) THEN
              
              p_out := f_msg('장착 모델과 솔더타입이 동일하지 않습니다.','K',1)   -- f_msg('Model Unmatch','C',1) 
                       || ' = '
                       || lvs_solder_type
                       || ', '
                       || NVL(lvs_line_model_solder_type, '*');
              RETURN;
               
         END IF;  
         
      p_out := 'OK';
      RETURN;
   END IF ;
   
   ---------------------------------------------------------------
   -- 작업구분에 따른 처리 N:처리 C:취소
   ---------------------------------------------------------------

   phase := '30';   
   
   IF ( p_deficit = 'N' ) THEN
     
     
         IF ( LENGTH( lvs_jig_line_code ) > 1 ) THEN
              
              p_out := f_msg('이미 장착된 지그 입니다.', 'K', 1)   -- 다른라인에 이미 장착
                       || ' = '
                       || 'Line='
                       || lvs_jig_line_code
                       || ', '
                       || p_line_code ;
              RETURN;
               
         END IF; 
         

         --------------------------------------------------------------------
         -- 라인 장착모델 확인
         --------------------------------------------------------------------   
         
         

         phase := '25';
         
         lvs_line_model := '*';
         
         SELECT MODEL_NAME, RUN_NO, ITEM_CODE
           INTO lvs_line_model, lvs_line_run_no, lvs_line_item_code
           FROM IP_PRODUCT_LINE
          where line_code = SUBSTR(p_line_code, 1, 2)
            and organization_id = 1;
            
         IF ( lvs_line_model <> p_model_name ) THEN
              
              p_out := f_msg('장착 모델과 동일하지 않습니다.','K',1)   -- f_msg('Model Unmatch','C',1) 
                       || ' = '
                       || p_model_name
                       || ', '
                       || NVL(lvs_line_model, '*');
              RETURN;
               
         END IF; 
   
     
   ---------------------------------------------------------------
   -- 작업구분에 따른 처리 N:처리 C:취소
   ---------------------------------------------------------------   
   
      phase := '40';

      BEGIN
        
         SELECT NVL(item_code, '*')
           INTO lvs_jig_model_name
           FROM imcn_jig_apply_model
          WHERE jig_lot_no      = p_barcode
            AND item_code       = p_model_name
            AND organization_id = 1;
                
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              lvs_jig_model_name := '*';
      END;
      
      --------------------------------------------------------------------------
      -- 적용모델이 아니면 UNMATCH ERROR
      --------------------------------------------------------------------------
      phase := '50';
  
      IF ( lvs_jig_model_name <> p_model_name ) THEN
        
         p_out := f_msg('적용모델이 일치하지 않습니다.','K',1) -- f_msg('Model Unmatch','C',1) 
                  || ' = '
                  || lvs_jig_model_name
                  || ', '
                  || p_model_name;
         RETURN;
         
      END IF;

      -------------------------------------------------------------------------------------------
      -- JIG 상태 확인
      -------------------------------------------------------------------------------------------

      phase := '60';

      IF ( lvs_jig_status <> 'Z' ) THEN

         p_out := f_msg('투입지그 상태가 비정상 입니다.','K',1) -- f_msg('Fixture Status Invalid','C',1); 
                  || ' = '
                  || lvs_jig_status;
         RETURN;
         
      END IF;
      
      -------------------------------------------------------------------------------------------
      -- 백업블럭 청소상태 확인
      -------------------------------------------------------------------------------------------

      phase := '65';

      IF ( p_jig_type = 'B' ) THEN

         IF ( LVS_TENSION_CHECK_YN <> 'Y' ) THEN
         
               p_out := f_msg('백업블럭이 체크상태가 아닙니다.','K',1) -- f_msg('Fixture Status Invalid','C',1); 
                        || ' = '
                        || LVS_TENSION_CHECK_YN;
               RETURN;
         
         END IF;
         
      END IF;
            
      
      -------------------------------------------------------------------------------------------
      -- 지그 사용횟수 확인
      -------------------------------------------------------------------------------------------

      phase := '70';

      IF ( lvl_break_value <= lvl_hit_value and lvl_break_value > 0)  THEN -- 사용횟수를 관리 하지 않는것은 SKIP 한다
        
         IF ( lvs_use_nsnp_yn = 'Y' ) THEN
           
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

         p_out := f_msg('유효수명초을 초과 했습니다.','K',1)  -- f_msg('Life Cycle Over','C',1) ;
                  || ' = '
                  || TO_CHAR( lvl_break_value )
                  || ', '
                  || TO_CHAR( lvl_hit_value );
         
         RETURN;

      ELSE
        
         --------------------------------------------------------------------
         -- 기존 라인에서 뺴고 신규 라인으로 설정
         --------------------------------------------------------------------

         phase := '80';
      
         UPDATE imcn_jig
            SET line_code = '*'                                 --, machine_code = '*'
          WHERE jig_lot_no      <> p_barcode
            AND line_code       = SUBSTR(p_line_code, 1, 2) 
            AND organization_id = 1
            AND jig_type        = p_jig_type;


         UPDATE imcn_jig
            SET line_code          = SUBSTR(p_line_code, 1, 2),    --, machine_code = p_machine_code
                TENSION_CHECK_YN   = 'N'
          WHERE jig_lot_no         = p_barcode
            AND organization_id    = 1
            AND jig_type           = p_jig_type;

         --------------------------------------------------------------------
         -- 라인 마스타에 장착정보 등록
         --------------------------------------------------------------------
         
         phase := '90';
         
         IF ( p_jig_type = 'B' ) THEN
           
             update ip_product_line
                set BACKUPBLOCK_CHECK_DATE = sysdate,
                    BACKUPBLOCK_LOT_NO     = p_barcode
              where line_code = SUBSTR(p_line_code, 1, 2)
                and organization_id = 1;
         
         ELSIF ( p_jig_type = 'R' OR p_jig_type = 'O' ) THEN

             update ip_product_line
                set ROUTER_CHECK_DATE = sysdate,
                    ROUTER_LOT_NO     = p_barcode
              where line_code = SUBSTR(p_line_code, 1, 2)
                and organization_id = 1;           
           
         ELSIF ( p_jig_type = 'T' OR p_jig_type = 'U') THEN

             update ip_product_line
                set FIXTURE_CHECK_DATE = sysdate,
                    FIXTURE_LOT_NO     = p_barcode
              where line_code = SUBSTR(p_line_code, 1, 2)
                and organization_id = 1;           
           
         ELSIF ( p_jig_type = 'W' ) THEN
           
             update ip_product_line
                set ROMWRITE_CHECK_DATE = sysdate,
                    ROMWRITE_LOT_NO     = p_barcode
              where line_code = SUBSTR(p_line_code, 1, 2)
                and organization_id = 1;         
           
         END IF;
                 

         --------------------------------------------------------------------
         -- 장착이력 등록
         --------------------------------------------------------------------
         
         phase := '100';
         
         INSERT INTO IMCN_JIG_input_hist (
                                          input_date, 
                                          line_code, 
                                          jig_code, 
                                          jig_lot_no, 
                                          run_no, 
                                          current_hit_value, 
                                          jig_type, 
                                          organization_id, 
                                          enter_by, 
                                          enter_date, 
                                          last_modify_by, 
                                          last_modify_date,
                                          model_name
                                         )
                                 VALUES (
                                          sysdate,
                                          SUBSTR(p_line_code, 1, 2),
                                          p_barcode,
                                          p_barcode,
                                          lvs_line_run_no,
                                          lvl_hit_value,
                                          p_jig_type,
                                          1,
                                          p_userid,
                                          sysdate,
                                          p_userid,
                                          sysdate,
                                          p_model_name
                                        );          
                                         
         COMMIT;

         p_out := 'OK';
         RETURN;
         
      END IF;
      
   ELSE
     
      --------------------------------------------------------------------
      -- 기존 라인에서 뺴고 신규 라인으로 설정
      --------------------------------------------------------------------
      
      phase := '90';

      UPDATE imcn_jig
         SET line_code         = '*',                          --, machine_code = '*'
              TENSION_CHECK_YN = 'N'
       WHERE jig_lot_no      = p_barcode
         AND organization_id = 1
         AND jig_type        = p_jig_type;
         
         IF ( p_jig_type = 'B' ) THEN
           
             update ip_product_line
                set BACKUPBLOCK_CHECK_DATE = NULL,
                    BACKUPBLOCK_LOT_NO     = NULL
              where line_code = SUBSTR(p_line_code, 1, 2)
                and organization_id = 1;
         
         ELSIF ( p_jig_type = 'R' OR p_jig_type = 'O' ) THEN

             update ip_product_line
                set ROUTER_CHECK_DATE = NULL,
                    ROUTER_LOT_NO     = NULL
              where line_code = SUBSTR(p_line_code, 1, 2)
                and organization_id = 1;           
           
         ELSIF ( p_jig_type = 'T' OR p_jig_type = 'U') THEN

             update ip_product_line
                set FIXTURE_CHECK_DATE = NULL,
                    FIXTURE_LOT_NO     = NULL
              where line_code = SUBSTR(p_line_code, 1, 2)
                and organization_id = 1;           
           
         ELSIF ( p_jig_type = 'W' ) THEN
           
             update ip_product_line
                set ROMWRITE_CHECK_DATE = NULL,
                    ROMWRITE_LOT_NO     = NULL
              where line_code = SUBSTR(p_line_code, 1, 2)
                and organization_id = 1;         
           
         END IF;
                  

      COMMIT;

      p_out := 'OK';
      RETURN;
      
   END IF;

-------------------------------------------------------------------------------------------
-- 에러에 대한 예외처리
-------------------------------------------------------------------------------------------
EXCEPTION
   WHEN OTHERS THEN
        p_out := p_barcode||' NG, [P_CHECK_JIG_SCAN_USER] '
                          || 'PHASE='
                          || phase
                          || ', '
                          || SQLERRM;
        RETURN;
        
END;
