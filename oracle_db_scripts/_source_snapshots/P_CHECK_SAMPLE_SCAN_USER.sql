PROCEDURE "P_CHECK_SAMPLE_SCAN_USER" (
   p_line_code    IN     VARCHAR2,
   p_model_name   IN     VARCHAR2,
   p_sample_type  IN     VARCHAR2,   
   p_barcode      IN     VARCHAR2,
   p_deficit      IN     VARCHAR2,
   p_no           IN     VARCHAR2,
   p_out          OUT    VARCHAR2,
   p_userid       IN     VARCHAR2)
IS
   lvs_line_model        VARCHAR2 (50);
   lvs_line_item         VARCHAR2 (50);
   lvs_line_run_no       VARCHAR2 (50);
   
   lvs_sample_section    VARCHAR2 (20);
   lvs_sample_status     VARCHAR2 (20);
   lvs_item_code         VARCHAR2 (20);
   lvdt_apply_date       DATE;
   lvdt_valid_date       DATE;
   lvs_ip_address        VARCHAR2 (20);
   lvs_use_nsnp_yn       VARCHAR2 (1);
   
   phase                   VARCHAR2 (20);
   
   lvs_sample_line_code    VARCHAR2 (20);
   
   lvs_samlple_model_name  VARCHAR2 (50);
   lvl_count               NUMBER;
     
BEGIN
  
   phase := '10';
   
   ---------------------------------------------------------------
   -- SAMPLE 바코드 확인
   ---------------------------------------------------------------
   if p_sample_type = 'L' then 
   
   
         lvs_line_model := '*';
         
         SELECT NVL(MODEL_NAME,'*'), RUN_NO, ITEM_CODE
           INTO lvs_line_model, lvs_line_run_no, lvs_line_item
           FROM IP_PRODUCT_LINE
          where line_code = SUBSTR(p_line_code, 1, 2)
            and organization_id = 1;
            
        update ip_product_line
        set LCR_CHECK_DATE = sysdate,
            LCR_LOT_NO     = p_barcode
        where line_code          = SUBSTR(p_line_code, 1, 2)
        and organization_id    = 1;     
        
          --------------------------------------------------------------------
         -- 샘플 장착이력 등록
         --------------------------------------------------------------------
         
         phase := '20';
         
         INSERT INTO IMCN_SAMPLE_input_hist (
                                          input_date, 
                                          line_code, 
                                          sample_code, 
                                          sample_lot_no, 
                                          run_no, 
                                          current_apply_date, 
                                          sample_type, 
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
                                          lvdt_valid_date,
                                          p_sample_type,
                                          1,
                                          p_userid,
                                          sysdate,
                                          p_userid,
                                          sysdate,
                                          lvs_line_model   -- p_model_name
                                        );          
                                         
         COMMIT;

         p_out := 'OK';
         RETURN;
        
end if ;
   
--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
   
   phase := '20';
         
   BEGIN
     
      SELECT NVL(sample_apply_date, sysdate),
             add_months(sample_apply_date, VALID_MONTHS),
             sample_status,
             NVL (use_nsnp_yn, 'N'),
             sample_section,
             NVL( line_code, '*')
        INTO lvdt_apply_date,
             lvdt_valid_date,
             lvs_sample_status,
             lvs_use_nsnp_yn,
             lvs_sample_section,
             lvs_sample_line_code
        FROM imcn_sample
       WHERE sample_lot_no      = p_barcode
         AND sample_type        = p_sample_type
         AND organization_id = 1;
      
   EXCEPTION
     
      WHEN NO_DATA_FOUND THEN
        
         p_out := f_msg('스캔한 SAMPLE 바코드가 없습니다.', 'K', 1)
                  || ' = '
                  || 'Barcode='
                  || p_barcode;
                  
         RETURN;
   END;
   
   ---------------------------------------------------------------
   -- 작업구분에 따른 처리 N:처리 C:취소
   ---------------------------------------------------------------

   phase := '30';   
   
   IF ( p_deficit = 'N' ) THEN
     
         IF ( LENGTH( lvs_sample_line_code ) > 1 ) THEN
              
              p_out := f_msg('이미 장착된 샘플 입니다.', 'K', 1)   -- 다른라인에 이미 장착
                       || ' = '
                       || 'Line='
                       || lvs_sample_line_code
                       || ', '
                       || p_line_code ;
              RETURN;
               
         END IF; 
         
   ---------------------------------------------------------------
   -- Verification check 확인 ( 6, 12, 18, 24, 30, 36개월)
   ---------------------------------------------------------------

         PHASE := '40';
         
    --     IF ( ) THEN
                 
             BEGIN
               
                LVL_COUNT := 0;      
                       
                SELECT COUNT(*)
                  INTO LVL_COUNT
                  FROM IMCN_SAMPLE
                 WHERE SAMPLE_LOT_NO      = P_BARCODE
                   AND SAMPLE_TYPE        = P_SAMPLE_TYPE
                   AND ORGANIZATION_ID = 1
                   AND ( 
                         NVL( VERIFICATION_STATE1, '*') in ('NG', 'SYS_NG', 'SYS_OK') OR  
                         NVL( VERIFICATION_STATE2, '*') in ('NG', 'SYS_NG', 'SYS_OK') OR  
                         NVL( VERIFICATION_STATE3, '*') in ('NG', 'SYS_NG', 'SYS_OK') OR  
                         NVL( VERIFICATION_STATE4, '*') in ('NG', 'SYS_NG', 'SYS_OK') OR  
                         NVL( VERIFICATION_STATE5, '*') in ('NG', 'SYS_NG', 'SYS_OK') OR  
                         NVL( VERIFICATION_STATE6, '*') in ('NG', 'SYS_NG', 'SYS_OK') 
                       );
                
             EXCEPTION
               
                WHEN NO_DATA_FOUND THEN
                  
                     LVL_COUNT := 0;      
             END;
                
             IF ( P_SAMPLE_TYPE = 'S' AND LVL_COUNT > 0 ) THEN
               
                  P_OUT := F_MSG('스캔한 SAMPLE 의 마스터 검증(갱신)을 확인 바랍니다.', 'K', 1)
                            || ' = '
                            || 'BARCODE='
                            || P_BARCODE;
                            
                  RETURN; 
                  
             END IF; 
         
    --     END IF;        

         --------------------------------------------------------------------
         -- 라인 장착모델 확인
         --------------------------------------------------------------------   

         phase := '50';
         
         lvs_line_model := '*';
         
         SELECT NVL(MODEL_NAME,'*'), RUN_NO, ITEM_CODE
           INTO lvs_line_model, lvs_line_run_no, lvs_line_item
           FROM IP_PRODUCT_LINE
          where line_code = SUBSTR(p_line_code, 1, 2)
            and organization_id = 1;
            
         IF ( lvs_line_model <> p_model_name ) THEN
              
              p_out := f_msg('장착모델과 일치하지 않습니다.', 'K', 1) -- f_msg('Model Unmatch','C',1) 
                       || ' = '
                       || p_model_name
                       || ', '
                       || NVL(lvs_line_model, '*');
              RETURN;
               
         END IF; 
         
        
         ---------------------------------------------------------------
         -- 샘플유형 확인 ( 양품, 불량)
         --------------------------------------------------------------- 
         
         IF ( p_sample_type = 'S' OR  p_sample_type = 'M' ) THEN
              
              IF ( lvs_sample_section <> substr(P_NO,1,1) ) THEN
                
                    p_out := f_msg('샘플유형이 틀립니다.', 'K', 1) -- f_msg('Model Unmatch','C',1) 
                             || ' = '
                             || lvs_sample_section
                             || ', '
                             || P_NO;
                             
                    RETURN;
              
              END IF;
               
         END IF;  
   
     
   ---------------------------------------------------------------
   -- 작업구분에 따른 처리 N:처리 C:취소
   ---------------------------------------------------------------   
   
      phase := '60';

      BEGIN
        
         SELECT NVL(item_code, '*')
           INTO lvs_samlple_model_name
           FROM imcn_sample_apply_model
          WHERE sample_lot_no      = p_barcode
            AND item_code          = p_model_name
            AND organization_id = 1;
                
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              lvs_samlple_model_name := '*';
      END;
      
      --------------------------------------------------------------------------
      -- 적용모델이 아니면 UNMATCH ERROR
      --------------------------------------------------------------------------
      phase := '70';
  
      IF ( lvs_samlple_model_name <> p_model_name  ) THEN
        
         p_out :=  f_msg('적용모델이 일치하지 않습니다.', 'K', 1) -- f_msg('Model Unmatch','C',1) 
                   || ' = '
                   || lvs_samlple_model_name
                   || ', '
                   || p_model_name;
         RETURN;
         
      END IF;

      -------------------------------------------------------------------------------------------
      -- JIG 상태 확인
      -------------------------------------------------------------------------------------------

      phase := '80';

      IF ( lvs_sample_status <> 'Z' ) THEN

         p_out := f_msg('스캔한 SAMPLE 상태가 비정상 입니다.', 'K', 1) -- f_msg('Fixture Status Invalid','C',1); 
                  || ' = '
                  || lvs_sample_status;
         RETURN;
         
      END IF;
      
      -------------------------------------------------------------------------------------------
      -- 지그 사용횟수 확인
      -------------------------------------------------------------------------------------------

      phase := '90';

      IF ( sysdate > lvdt_valid_date )  THEN
        
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

         p_out := '유효날짜를 초과 했습니다. '  -- f_msg('Life Cycle Over','C',1) ;
                  || ' = '
                  || TO_CHAR( lvdt_valid_date, 'YYYY/MM/DD' )
                  || ', '
                  || TO_CHAR( sysdate, 'YYYY/MM/DD' );
         
         RETURN;

      ELSE
        
         --------------------------------------------------------------------
         -- 라인 마스타에 장착정보 등록
         --------------------------------------------------------------------
         
         phase := '110';
         
         IF ( p_sample_type = 'M' OR p_sample_type = 'S'  ) THEN
                  
               --------------------------------------------------------------------
               -- 기존 라인에서 뺴고 신규 라인으로 설정
               --------------------------------------------------------------------
  
               UPDATE imcn_sample
                  SET line_code = '*'                                 --, machine_code = '*'
                WHERE sample_lot_no   not in (     
                                                  select sample_lot_no
                                                    from ip_product_line 
                                                   where line_code  =    SUBSTR (p_line_code, 1, 2)   
                                                   union all
                                                  select sample_lot_no2
                                                    from ip_product_line 
                                                   where line_code  =    SUBSTR (p_line_code, 1, 2) 
                                                   union all
                                                  select p_barcode
                                                    from dual
                                                )
                  AND line_code        = SUBSTR(p_line_code, 1, 2) 
                  AND organization_id  = 1
                  AND sample_type      = p_sample_type;


               UPDATE imcn_sample
                  SET line_code       = SUBSTR(p_line_code, 1, 2)      --, machine_code = p_machine_code
                WHERE sample_lot_no   = p_barcode
                  AND organization_id = 1
                  AND sample_type     = p_sample_type;           
           
              IF ( p_no = 'GOOD' ) THEN
                
                   update ip_product_line
                      set SAMPLE_CHECK_DATE = sysdate,
                          SAMPLE_LOT_NO     = p_barcode
                    where line_code         = SUBSTR(p_line_code, 1, 2)
                      and organization_id   = 1;
                      
              ELSE
                   update ip_product_line
                      set SAMPLE_CHECK_DATE2 = sysdate,
                          SAMPLE_LOT_NO2     = p_barcode
                    where line_code          = SUBSTR(p_line_code, 1, 2)
                      and organization_id    = 1;                
              END IF;
         
         ELSIF ( p_sample_type = 'P' ) THEN
           
               --------------------------------------------------------------------
               -- 기존 라인에서 뺴고 신규 라인으로 설정
               --------------------------------------------------------------------
  
               UPDATE imcn_sample
                  SET line_code = '*'                                 --, machine_code = '*'
                WHERE sample_lot_no    <>  p_barcode
                  AND line_code        = SUBSTR(p_line_code, 1, 2) 
                  AND organization_id  = 1
                  AND sample_type      = p_sample_type;

               UPDATE imcn_sample
                  SET line_code       = SUBSTR(p_line_code, 1, 2)      --, machine_code = p_machine_code
                WHERE sample_lot_no   = p_barcode
                  AND organization_id = 1
                  AND sample_type     = p_sample_type;            

             update ip_product_line
                set PROFILE_CHECK_DATE = sysdate,
                    PROFILE_LOT_NO     = p_barcode
              where line_code          = SUBSTR(p_line_code, 1, 2)
                and organization_id    = 1;        

         ELSIF ( p_sample_type = 'C' ) THEN
           
               --------------------------------------------------------------------
               -- 기존 라인에서 뺴고 신규 라인으로 설정
               --------------------------------------------------------------------
  
               --------------------------------------------------------------------
               -- 기존 라인에서 뺴고 신규 라인으로 설정
               --------------------------------------------------------------------
  
               UPDATE imcn_sample
                  SET line_code = '*'                                 --, machine_code = '*'
                WHERE sample_lot_no   not in (     
                                                  select sample_ict_lot_no
                                                    from ip_product_line 
                                                   where line_code  =    SUBSTR (p_line_code, 1, 2)   
                                                   union all
                                                  select sample_ict_lot_no2
                                                    from ip_product_line 
                                                   where line_code  =    SUBSTR (p_line_code, 1, 2) 
                                                   union all
                                                  select p_barcode
                                                    from dual
                                                )
                  AND line_code        = SUBSTR(p_line_code, 1, 2) 
                  AND organization_id  = 1
                  AND sample_type      = p_sample_type;


               UPDATE imcn_sample
                  SET line_code       = SUBSTR(p_line_code, 1, 2)      --, machine_code = p_machine_code
                WHERE sample_lot_no   = p_barcode
                  AND organization_id = 1
                  AND sample_type     = p_sample_type;           
           
              IF ( p_no = 'GOOD' ) THEN
                
                   update ip_product_line
                      set SAMPLE_ICT_CHECK_DATE = sysdate,
                          SAMPLE_ICT_LOT_NO     = p_barcode
                    where line_code             = SUBSTR(p_line_code, 1, 2)
                      and organization_id       = 1;
                      
              ELSE
                   update ip_product_line
                      set SAMPLE_ICT_CHECK_DATE2 = sysdate,
                          SAMPLE_ICT_LOT_NO2     = p_barcode
                    where line_code              = SUBSTR(p_line_code, 1, 2)
                      and organization_id        = 1;                
              END IF;                           
           
         END IF;
                 

         --------------------------------------------------------------------
         -- 샘플 장착이력 등록
         --------------------------------------------------------------------
         
         phase := '120';
         
         INSERT INTO IMCN_SAMPLE_input_hist (
                                          input_date, 
                                          line_code, 
                                          sample_code, 
                                          sample_lot_no, 
                                          run_no, 
                                          current_apply_date, 
                                          sample_type, 
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
                                          lvdt_valid_date,
                                          p_sample_type,
                                          1,
                                          p_userid,
                                          sysdate,
                                          p_userid,
                                          sysdate,
                                          lvs_line_model   -- p_model_name
                                        );          
                                         
         COMMIT;

         p_out := 'OK';
         RETURN;
         
      END IF;
      
   ELSE
     
      --------------------------------------------------------------------
      -- 기존 라인에서 뺴고 신규 라인으로 설정
      --------------------------------------------------------------------
      
      phase := '130';

      UPDATE imcn_sample
         SET line_code          = '*'                            --, machine_code = '*'
       WHERE sample_lot_no      = p_barcode
         AND organization_id    = 1
         AND sample_type        = p_sample_type;
         
         IF ( p_sample_type = 'M' OR p_sample_type = 'S'  ) THEN
           
              IF ( p_no = 'GOOD' ) THEN
                
                   update ip_product_line
                      set SAMPLE_CHECK_DATE = NULL,
                          SAMPLE_LOT_NO     = NULL
                    where line_code         = SUBSTR(p_line_code, 1, 2)
                      and organization_id   = 1;
                      
              ELSE
                
                   update ip_product_line
                      set SAMPLE_CHECK_DATE2 = NULL,
                          SAMPLE_LOT_NO2     = NULL
                    where line_code          = SUBSTR(p_line_code, 1, 2)
                      and organization_id    = 1;
                                    
              END IF;
         
         ELSIF ( p_sample_type = 'P' ) THEN

             update ip_product_line
                set PROFILE_CHECK_DATE = NULL,
                    PROFILE_LOT_NO     = NULL
              where line_code = SUBSTR(p_line_code, 1, 2)
                and organization_id = 1;   
                
         ELSIF ( p_sample_type = 'C' ) THEN

              IF ( p_no = 'GOOD' ) THEN
                
                   update ip_product_line
                      set SAMPLE_ICT_CHECK_DATE = NULL,
                          SAMPLE_ICT_LOT_NO     = NULL
                    where line_code             = SUBSTR(p_line_code, 1, 2)
                      and organization_id       = 1;
                      
              ELSE
                
                   update ip_product_line
                      set SAMPLE_ICT_CHECK_DATE2 = NULL,
                          SAMPLE_ICT_LOT_NO2     = NULL
                    where line_code              = SUBSTR(p_line_code, 1, 2)
                      and organization_id        = 1;
                                    
              END IF;             
                             
           
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
        p_out := 'NG, [P_CHECK_SAMPLE_SCAN_USER] '
                 || p_barcode
                 || ', '
                 || 'PHASE='
                 || phase
                 || ', '
                 || SQLERRM;
        RETURN;
        
END;
