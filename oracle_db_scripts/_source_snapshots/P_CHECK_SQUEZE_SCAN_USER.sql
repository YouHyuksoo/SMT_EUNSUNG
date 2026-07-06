PROCEDURE p_check_squeze_scan_user (
   p_line_code    IN     VARCHAR2,
   p_model_name   IN     VARCHAR2,
   p_barcode      IN     VARCHAR2,
   P_DEFICIT      IN     VARCHAR2,
   P_no           IN     VARCHAR2,
   p_out          OUT    VARCHAR2,
   p_userid       IN     VARCHAR2)
IS
   lvs_jig_status          VARCHAR2 (20);
   lvs_use_status          VARCHAR2 (20);
   lvl_break_value         NUMBER;
   lvl_hit_value           NUMBER;
   lvs_ip_address          VARCHAR2 (20);
   lvs_use_nsnp_yn         VARCHAR2 (1);
   lvl_time_term           NUMBER := 300000;
   
   phase                   VARCHAR2 (20);
   
   lvs_line_run_no         VARCHAR2 (50);
   lvs_line_model_name     VARCHAR2 (50);
   lvs_line_item_code      VARCHAR2 (50);
   
   lvs_set_squeeze_lot_no  VARCHAR2 (50);
   lvs_set_squeeze_lot_no2 VARCHAR2 (50);
   
   lvs_jig_line_code       VARCHAR2 (10);
   lvs_jig_model_name      VARCHAR2 (50);
   lvs_item_code           VARCHAR2 (50);
   lvs_solder_type         VARCHAR2 (1);
   LVS_LINE_SOLDER_TYPE    VARCHAR2 (1);
   
   lvs_TENSION_CHECK_YN    VARCHAR2 (10);
   lvs_check_date          VARCHAR2 (10);
   lvs_last_clean_date     VARCHAR2 (20);
   
   lvl_count               NUMBER;
   
BEGIN
  
   phase := '10';
   
      --------------------------------------------------------------------------------
      -- 장착 롯트 확인
      -------------------------------------------------------------------------------- 
    
   -- 다른라인에 장착 확인
   BEGIN
        
      SELECT NVL(line_code, '*') , SOLDER_TYPE 
        INTO lvs_jig_line_code , lvs_solder_type
        FROM imcn_jig
       WHERE jig_lot_no      = p_barcode
         AND organization_id = 1
         AND jig_type        = 'S';
         
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
        
            p_out := f_msg('미등록 스퀴즈 입니다.', 'K', 1)    -- Line not found.
                     || ' = '
                     || 'Line='
                     || p_line_code
                     || ', '
                     || 'Barcode='
                     || p_barcode ;
         RETURN;
   END;  
   
   IF P_DEFICIT = 'C'  THEN
     
      --------------------------------------------------------------------------------
      -- 스퀴즈 투입 취소처리
      --------------------------------------------------------------------------------   
           
      UPDATE imcn_jig
         SET line_code       = '*'
       WHERE jig_lot_no      = p_barcode
         AND organization_id = 1
         AND jig_type        = 'S';  
       
       IF ( SUBSTR(P_NO,1,1) = '1') THEN
        
            UPDATE ip_product_line
               SET squeeze_check_date = NULL, 
                   squeeze_lot_no     = NULL
             WHERE line_code          = SUBSTR (p_line_code, 1, 2);
      
      ELSE
        
            UPDATE ip_product_line
               SET squeeze_check_date2 = NULL, 
                   squeeze_lot_no2     = NULL
             WHERE line_code          = SUBSTR (p_line_code, 1, 2);        
        
      END IF;   
       
   ELSE
     
     
      IF ( LENGTH( lvs_jig_line_code ) > 1   ) THEN
        
        p_out := f_msg('이미 장착된 스퀴즈 입니다.', 'K', 1)   -- 다른라인에 이미 장착
                 || ' = '
                 || 'Line='
                 || lvs_jig_line_code
                 || ', '
                 || p_line_code ;
        RETURN;
         
      END IF; 
                        
       --------------------------------------------------------------------------------   
       -- 이전 장착 마스크 확인
       --------------------------------------------------------------------------------
       
       BEGIN
          SELECT run_no, model_name, item_code, NVL(squeeze_lot_no,'*'), NVL(squeeze_lot_no2,'*') , SOLDER_TYPE
            INTO lvs_line_run_no, lvs_line_model_name, lvs_line_item_code, lvs_set_squeeze_lot_no, lvs_set_squeeze_lot_no2 , LVS_LINE_SOLDER_TYPE
            FROM ip_product_line
           WHERE line_code       = p_line_code   -- 이전 진행롯트 확인
             AND organization_id = 1;

       EXCEPTION
          WHEN NO_DATA_FOUND THEN
            
                p_out := f_msg('미등록 라인입니다.', 'K', 1)    -- Line not found.
                         || ' = '
                         || 'Line='
                         || p_line_code
                         || ', '
                         || 'Barcode='
                         || p_barcode ;
             RETURN;
       END;   
      --------------------------------------------------- 
      -- 모델 입력 없으면 전모델 적용 으로 판단 YHS 
      --------------------------------------------------- 
      IF p_model_name IS NULL OR P_MODEL_NAME = lvs_line_model_name  THEN 
         NULL;
       ELSE
       
               IF ( lvs_line_model_name IS NULL or p_model_name is NULL  or ( lvs_line_model_name <> p_model_name) ) THEN
                    
                    p_out := f_msg('장착모델과 일치하지 않습니다.', 'K', 1)   -- Model Unmatch
                             || ' = '
                             || p_model_name
                             || ', '
                             || NVL(lvs_line_model_name, '*');
                    RETURN;
                     
               END IF; 
       
       END IF ;
       
      --------------------------------------------------- 
      -- 솔더 타입 비교  
      --------------------------------------------------- 
    
       
               IF ( LVS_SOLDER_TYPE IS NULL or LVS_LINE_SOLDER_TYPE is NULL  or ( LVS_LINE_SOLDER_TYPE <> LVS_SOLDER_TYPE) ) THEN
                    
                    p_out := f_msg('솔더타입이 일치하지 않습니다.', 'K', 1)   -- Model Unmatch
                             || ' = '
                             || p_model_name
                             || ', Line solder='
                             ||LVS_LINE_SOLDER_TYPE
                             ||' Squeeze SOlder='
                             || LVS_SOLDER_TYPE;
                    RETURN;
                     
               END IF; 
       
       
       IF ( lvs_set_squeeze_lot_no = p_barcode OR p_barcode = lvs_set_squeeze_lot_no2 ) THEN
            
            p_out := f_msg('이미 장착된 스퀴즈 입니다.', 'K', 1)   -- Model Unmatch
                     || ' = '
                     || lvs_set_squeeze_lot_no
                     || ', '
                     || lvs_set_squeeze_lot_no2
                     || ', '
                     || p_barcode;
            RETURN;
             
       END IF; 
       
   ---------------------------------------------------------------
   -- 작업구분에 따른 처리 N:처리 C:취소
   ---------------------------------------------------------------   
   
 
--      BEGIN
--        
--         SELECT NVL(item_code, '*')
--           INTO lvs_jig_model_name
--           FROM imcn_jig_apply_model
--          WHERE jig_lot_no      = p_barcode
--            AND item_code       = p_model_name
--            AND organization_id = 1;
--                
--      EXCEPTION
--         WHEN NO_DATA_FOUND THEN
--              lvs_jig_model_name := '*';
--      END;
--             
--      --------------------------------------------------------------------------
--      -- 적용모델이 아니면 UNMATCH ERROR
--      --------------------------------------------------------------------------
--  
--      IF ( lvs_jig_model_name <> p_model_name )  THEN
--        
--         p_out := f_msg('적용모델이 일치하지 않습니다.','K',1) -- f_msg('Model Unmatch','C',1) 
--                  || ' = '
--                  || lvs_jig_model_name
--                  || ', '
--                  || p_model_name;
--         RETURN;
--         
--      END IF;       
  
      --------------------------------------------------------------------------------
      -- 스퀴즈 투입 처리
      --------------------------------------------------------------------------------       
          
      BEGIN
        
         SELECT break_value,
                hit_value,
                jig_status,
                use_status,
                NVL (use_nsnp_yn, 'N'),
                NVL(TENSION_CHECK_YN,'*'),
                to_char( sysdate, 'HH24MI'),
                NVL(
                      (
                       select max( to_char(jig_check_date, 'YYYY/MM/DD HH24:MI:SS') )
                         from imcn_jig_squeze_check
                        where jig_lot_no   = p_barcode
                          and clean_yn     = 'Y'
                          and pin_hole_yn  = 'Y'                      
                      )
                   , '검사OK 이력없음'
                   ) 
           INTO lvl_break_value,
                lvl_hit_value,
                lvs_jig_status,
                lvs_use_status,
                lvs_use_nsnp_yn,
                lvs_TENSION_CHECK_YN,
                lvs_check_date,
                lvs_last_clean_date
           FROM imcn_jig
          WHERE jig_lot_no      = p_barcode
            AND organization_id = 1
            AND jig_type        = 'S';

         phase := '20';
         
      EXCEPTION
         WHEN NO_DATA_FOUND  THEN
              p_out := f_msg('미등록 스퀴즈 입니다.', 'K', 1) 
                       || ' = '
                       || p_barcode ;
              RETURN;
      END;

      phase := '50';

      --------------------------------------------------------------------------------
      -- 타발수 확인
      --------------------------------------------------------------------------------
      
      IF lvl_break_value <= lvl_hit_value THEN
        
         --      BEGIN
         --         IF lvs_use_nsnp_yn = 'Y'
         --         THEN
         --            --------------------------------------------------------------------------------
         --            -- NSNP START
         --            --------------------------------------------------------------------------------
         --            p_interlock_set_nsnp (p_line_code, 1);
         --         --------------------------------------------------------------------------------
         --         -- NSNP END
         --         --------------------------------------------------------------------------------
         --
         --         END IF;
         --      --------------------------------------------------------------------------------
         --      -- NSNP END
         --      --------------------------------------------------------------------------------
         --      EXCEPTION
         --         WHEN OTHERS
         --         THEN
         --            NULL;ㅏ
         --      END;


         IF lvs_use_nsnp_yn = 'Y' THEN
           
            BEGIN
               --------------------------------------------------------------------------------
               -- NSNP START
               --------------------------------------------------------------------------------
               p_interlock_set_nsnp_time_msg (
                                               p_line_code,
                                               1,
                                               lvl_time_term,
                                               p_model_name,
                                               '*',
                                               'SQUEEZE',
                                               f_msg('LIFE CYCLE OVER ','K',1) 
                                               || p_barcode
                                             );
            --------------------------------------------------------------------------------
            -- NSNP END
            --------------------------------------------------------------------------------
            EXCEPTION
               WHEN OTHERS THEN
                     NULL;
            END;
            
         END IF;
         
         p_out := f_msg('유효수명을 초과 했습니다.','K',1);   -- Life Cycle Over.
         RETURN;
         
      END IF;

      phase := '70';

      --------------------------------------------------------------------------------
      -- 사용유무, 지그상태를 확인
      --------------------------------------------------------------------------------
      
      IF ( lvs_jig_status <> 'Z' OR lvs_use_status <> 'U' ) THEN
        
         IF ( lvs_use_nsnp_yn = 'Y' ) THEN
           
            BEGIN
               --------------------------------------------------------------------------------
               -- NSNP START
               --------------------------------------------------------------------------------
               p_interlock_set_nsnp_time_msg (
                                               p_line_code,
                                               1,
                                               lvl_time_term,
                                               p_model_name,
                                               '*',
                                               'SQUEEZE',
                                               f_msg('STATUS NOT NORMAL '  ,'K',1) 
                                               || p_barcode
                                             );
            --------------------------------------------------------------------------------
            -- NSNP END
            --------------------------------------------------------------------------------
            EXCEPTION
               WHEN OTHERS THEN
                     NULL;
            END;
            
         END IF;
         
         p_out := f_msg('지그가 비정상 상태 입니다.', 'K',1)   -- Squeeze status not normal
                  || ' = '
                  ||lvs_jig_status;
         RETURN;
         
      END IF;
      
      --------------------------------------------------------------------------------
      -- 시퀴즈 검사유무 확인 : 2021/07/12 : 정D 요청으로 처리
      --------------------------------------------------------------------------------
      
    IF ( lvs_TENSION_CHECK_YN <> 'Y'  AND lvs_check_date >= '0830' ) THEN
        
          p_out := f_msg('시업 후 스퀴즈 검사이력 없음', 'K',1)   -- Squeeze status not normal
                  || ' : '
                  || lvs_last_clean_date
                  || ', '
                  || lvs_TENSION_CHECK_YN;
          RETURN;
            
       END IF;
               
      
      ----------------------------------------------------------------
      -- 이미 장착 되었는지 확인
      ----------------------------------------------------------------      

      ----------------------------------------------------------------
      -- 라인정보에 정보 업데이트
      ----------------------------------------------------------------
      
      IF ( SUBSTR(P_NO,1,1) = '1') THEN
        
            SELECT count(*)
              INTO lvl_count
              FROM ip_product_line
             where line_code       = SUBSTR (p_line_code, 1, 2)
               and squeeze_lot_no is null;
               
            IF ( lvl_count > 0 ) THEN
        
                  UPDATE ip_product_line
                     SET squeeze_check_date = SYSDATE, 
                         squeeze_lot_no     = p_barcode
                   WHERE line_code          = SUBSTR (p_line_code, 1, 2);
             
            ELSE
              
                 p_out := f_msg('스퀴즈 1번 에는 이미 장착 되어 있습니다.','K',1);   -- Life Cycle Over.
                 RETURN;
              
            END IF;
      
      ELSE
        
            SELECT count(*)
              INTO lvl_count
              FROM ip_product_line
             where line_code       = SUBSTR (p_line_code, 1, 2)
               and squeeze_lot_no2 is null;
               
            IF ( lvl_count > 0 ) THEN   
                     
                 UPDATE ip_product_line
                    SET squeeze_check_date2 = SYSDATE, 
                        squeeze_lot_no2     = p_barcode
                  WHERE line_code           = SUBSTR (p_line_code, 1, 2);  
             
            ELSE
              
                 p_out := f_msg('스퀴즈 2번 에는 이미 장착 되어 있습니다.','K',1);   -- Life Cycle Over.
                 RETURN;                           
             
            END IF;   
        
      END IF;

        -- 2개 장착시 어쩔수 없이 라인해제시 일괄 정리로 변경
      UPDATE imcn_jig
         SET line_code       = '*'                            --, machine_code = '*'
       WHERE LINE_CODE       = SUBSTR (p_line_code, 1, 2)
--         AND jig_lot_no      <> p_barcode
        AND jig_lot_no      not in (     
                                     select squeeze_lot_no
                                       from ip_product_line 
                                      where line_code  =    SUBSTR (p_line_code, 1, 2)   
                                      union all
                                     select squeeze_lot_no2
                                       from ip_product_line 
                                      where line_code  =    SUBSTR (p_line_code, 1, 2) 
                                      union all
                                     select p_barcode
                                       from dual
                                   )
         AND organization_id = 1
         AND jig_type        = 'S';

      UPDATE imcn_jig
         SET LINE_CODE        = SUBSTR (p_line_code, 1, 2),   
             TENSION_CHECK_YN = 'N',
             last_modify_by   = 'LINE INPUT',
             last_modify_date = sysdate 
       WHERE jig_lot_no       = p_barcode
         AND organization_id  = 1
         AND jig_type         = 'S';
                                  
         
         --------------------------------------------------------------------
         -- 장착이력 등록
         --------------------------------------------------------------------
         
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
                                          'S',
                                          1,
                                          p_userid,
                                          sysdate,
                                          p_userid,
                                          sysdate,
                                          p_model_name
                                        ); 
                                                 
     IF lvs_use_nsnp_yn = 'Y' THEN
        
         BEGIN
            --------------------------------------------------------------------------------
            -- NSNP START
            --------------------------------------------------------------------------------
            p_interlock_set_nsnp_time_msg (
                                           p_line_code,
                                           0,
                                           0,
                                           p_model_name,
                                           '*',
                                           'SQUEZE',
                                           'UNLOCK ' || p_barcode
                                          );
         --------------------------------------------------------------------------------
         -- NSNP END
         --------------------------------------------------------------------------------
         EXCEPTION
            WHEN OTHERS THEN
                 NULL;
         END;
         
      END IF;
      
   END IF;

   COMMIT;
   
   p_out := 'OK';

   
EXCEPTION
   WHEN OTHERS THEN
        p_out := 'NG, [P_CHECK_SQUEZE_SCAN_USER] '
                 || 'IP='
                 || lvs_ip_address
                 || ', '
                 || 'PHASE='|| phase
                 || ', '
                 || SQLERRM;
END;
