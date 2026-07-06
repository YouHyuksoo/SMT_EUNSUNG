PROCEDURE P_INTERLOCK_CHECK_BAK
(
   p_line_code        IN     VARCHAR2,
   p_workstage_code   IN     VARCHAR2,
   p_machine_code     IN     VARCHAR2,
   p_serial_no        IN     VARCHAR2,
   p_type             IN     VARCHAR2,
   p_result              OUT VARCHAR2,
   p_message             OUT VARCHAR2,
   p_ng_message          OUT VARCHAR2,
   p_ok_message          OUT VARCHAR2)
IS

    lvs_data                    VARCHAR2 (100);
    lvs_message                 VARCHAR2 (1000);
    lvs_ok_message              VARCHAR2 (1000);
    lvs_jig_model_name          VARCHAR2 (30);
    lvs_jig_type                VARCHAR2 (10);
    lvs_jig_code                VARCHAR2 (30);
    lvs_jog_lot_no              VARCHAR2 (30);
    lvs_reflow_result           VARCHAR2 (10);
    lvs_solder_type             VARCHAR2 (10);
    lvs_solder_type_scan        VARCHAR2 (10);
    lvs_solder_barcode          VARCHAR2 (50);
    lvl_air_density             NUMBER;
    lvl_check_temp              VARCHAR2 (10); --NUMBER;
    lvs_serial_solder_type      VARCHAR2 (10);
    lvs_check_result            VARCHAR2 (100);
    lvs_machine_code            VARCHAR2 (30);
    lvs_workstage_code          VARCHAR2 (30);
    lvs_item_code               VARCHAR2 (30);
    LVS_PCB_ITEM                VARCHAR2 (10);
    LVDT_REPAIR_DATE            DATE;
    LVS_CARRIER_PID             VARCHAR2 (100);
    lvs_model_name              VARCHAR2 (30);
    lvs_model_division          VARCHAR2 (30);
    
    LVS_MARKING_CONDITION          VARCHAR2 (100);
    LVS_CARRIER_BARCODE_POSITION   VARCHAR2 (100);   -- HLDS check
    LVS_CUSTOMER_NAME              VARCHAR2 (100);
    LVS_SITE_CODE                  VARCHAR2 (100);
    lvs_location_code              VARCHAR2 (30);
   
    lvl_count                   NUMBER;
    lvi_check_result_count      NUMBER;
    lvi_spi_time_check          NUMBER;
    lvi_reflow_time_check       NUMBER;
    lvi_coating_time_check      NUMBER;
    lvi_xray_check              NUMBER;
    LVI_CARRIER_SIZE            NUMBER;
    lvl_jig_status              NUMBER;
    lvi_check_result_ok_count   NUMBER;
    lvi_check_result_ng_count   NUMBER;
    LVI_AOI_REWORK_COUNT        NUMBER;
    LVI_OK_COUNT                NUMBER;
    LVI_NG_COUNT                NUMBER;
    lvl_break_value             NUMBER;
    lvl_hit_value               NUMBER;
    lvi_count                   NUMBER;
    lvl_solder_time_check       NUMBER; 
    
    LVS_NG_DATE                 VARCHAR2 (20);
    
    LVI_REPAIR_COUNT            NUMBER;
   
    lvs_lcr_lot_no              VARCHAR2(100) ;
    
    LVS_MIN_VALUE               VARCHAR2 (10);
    LVS_MAX_VALUE               VARCHAR2 (10);
    
    LVS_CUR_VALUE               VARCHAR2 (10);
    
    lvs_repair_result           VARCHAR2 (10);
    lvs_inspect_handling        VARCHAR2 (10);
    
    lvs_jig_status              VARCHAR2 (10);
    lvs_use_status              VARCHAR2 (10);  
    
    LVS_LINE_MARKING_YN         VARCHAR2 (10);

    
   --------------------------------------
   -- mask
   --------------------------------------
   lvdt_issue_date             DATE;
   lvdt_last_inspect_date      DATE;
   lvdt_backupblock_check_date DATE;

   LVS_TENSION_CHECK_YN        VARCHAR2 (1);
   LVS_PART_NO                 VARCHAR2(30);
   
   lvs_run_no                  VARCHAR2(30);
   lvs_pid_run_no              VARCHAR2(30);
   LVS_MARKING_YN              VARCHAR2(30);
   
   lvl_qc_count                number ;
   
   lvdt_max_ng_date            date ;
   lvs_max_spi_date            varchar2(20) ;
   
   lvl_max_count               number;
   
   LVS_CARRIER_BARCODE_YN      VARCHAR2 (1);
   LVS_BOT_BARCODE             VARCHAR2 (50);
   
   lvs_pcb_tb_suffix           VARCHAR2 (50);  
   
   lvl_pcb_input_qty           number;
   lvl_lot_input_qty           number;
   
   
BEGIN


--
--   p_result      := 'OK'; 
--   p_message     := '테스트 입니다.';
--   p_ng_message  := 'NG가 났어요'; 
--   p_ok_message  := '모든 검사가 성공 했어요 .'; 
--   
--   return ;

   BEGIN

        ---------------------------------------------------------------------
        -- RUN NO 확인
        ---------------------------------------------------------------------
         SELECT RUN_NO           
           INTO lvs_run_no
           FROM IP_PRODUCT_LINE
          WHERE LINE_CODE = p_line_code;

   EXCEPTION
         WHEN OTHERS THEN
              lvs_run_no := '*';

   END;

   BEGIN

        ---------------------------------------------------------------------
        -- 모델의 정보 추출 
        ---------------------------------------------------------------------
         SELECT MARKING_CONDITION, 
                CARRIER_SIZE, 
                CUSTOMER_NAME, 
                CARRIER_BARCODE_POSITION, 
                SITE_CODE,
                NVL(MARKING_YN,'N'),
                NVL(CARRIER_BARCODE_YN,'N')               
           INTO LVS_MARKING_CONDITION,
                LVI_CARRIER_SIZE,
                LVS_CUSTOMER_NAME,
                LVS_CARRIER_BARCODE_POSITION,
                LVS_SITE_CODE,
                LVS_MARKING_YN,
                LVS_CARRIER_BARCODE_YN             
           FROM IP_PRODUCT_MODEL_MASTER
          WHERE MODEL_NAME = (
                              SELECT MODEL_NAME
                                FROM IP_PRODUCT_2D_BARCODE
                               WHERE SERIAL_NO = p_serial_no
                             )
           AND ROWNUM = 1;

   EXCEPTION
         WHEN OTHERS THEN
              LVI_CARRIER_SIZE := 0;

   END;
       
   ------------------------------------------------------------------
   -- 장착모델이 바코드 미사용이라면 SKIP 
   ------------------------------------------------------------------
      
   IF ( LVS_MARKING_YN = 'N') THEN
     
        p_result     := 'OK';
        p_message    := 'SKIP';
        p_ng_message := f_msg('해당 롯트는 바코드 미사용으로 무조건 합격','C',1);
        p_ok_message := f_msg('해당 롯트는 바코드 미사용으로 무조건 합격','C',1);   
        
        RETURN;
        
   END IF;
   
   ------------------------------------------------------------------
   -- 라인 장착 모델 기준 MAKING_YN 확인 
   ------------------------------------------------------------------   
   
    BEGIN
      
        select nvl(marking_yn, 'Y')
          into LVS_LINE_MARKING_YN
          from ip_product_model_master
         where model_name = (
                              select model_name 
                                from ip_product_line 
                               where line_code = p_line_code 
                            );
                    
  EXCEPTION
         WHEN OTHERS THEN
              LVS_LINE_MARKING_YN := 'Y';

  END; 

   ------------------------------------------------------------------
   -- 해당 라인 해당 공정에 인터락 조건이 있는지 체크 
   ------------------------------------------------------------------
  BEGIN
    
      IF ( p_type = 'AOI_OK_EXISTS_CHECK_TB' ) THEN
        
           lvi_count := 1;
        
      ELSE
        
            SELECT COUNT (*)
              INTO lvi_count
              FROM iq_interlock_check_condition
             WHERE line_code            = p_line_code
               AND workstage_code       = p_workstage_code
               AND interlock_check_type = p_type
               AND organization_id      = 1
               AND use_yn               = 'Y';
         
      END IF;
         

   EXCEPTION
      WHEN NO_DATA_FOUND THEN
           lvi_count := 0;
   END;

   IF lvi_count = 0 THEN
     
      p_result     := 'OK';
      p_message    := 'SKIP';
      p_ng_message := 'SKIP LINE='||p_line_code||' p_workstage_code='||p_workstage_code||' Typ='||p_type;
      p_ok_message := 'SKIP';
      
      RETURN;
      
   END IF;
   
   --------------------------------------------------------------------------
   -- TOP에 대해 BOT check 하는 곳에서 확인한 PCB 구분을 위해 미리 구함
   --
	 -- AOI_OK_EXISTS_CHECK_TB
   -- AOI_OK_EXISTS_CHECK2_TB
   -- AOI_NG_EXISTS_CHECK_TB
   -- 
   -- SPI_OK_EXISTS_CHECK_TB
   -- 
   -- REPAIR_STATUS_CHECK_TB
   -- REPAIR_AOI_STATUS_CHECK_TB    
   --------------------------------------------------------------------------
   if substr(p_serial_no, -1) = 'T' then
      lvs_pcb_tb_suffix := '(TOP)';
   elsif substr(p_serial_no, -1) = 'B'   then
      lvs_pcb_tb_suffix := '(BOT)';
   else
      lvs_pcb_tb_suffix := '';
   end if;
   
   --------------------------------------------------------------------------
   -- 바코드 마스터에 바코드가 존재하는지 확인
   --------------------------------------------------------------------------

   IF p_type = 'EXISTS_PID_CHECK' THEN
     
      BEGIN
        
         SELECT count(*)
           INTO lvl_count
           FROM ip_product_2d_barcode
          WHERE serial_no = p_serial_no;
          
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              lvi_count := 0;
      END;
      
      IF lvl_count = 0 THEN
        
            p_result     := 'NG';
            p_message    := 'EXISTS_PID_CHECK';
            p_ng_message := f_msg('미등록 바코드 투입','C',1);
            p_ok_message := '';
         
         /*********************************************************************/
          P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                   p_machine_code,
                                   p_serial_no,
                                   sysdate,
                                   p_ng_message,     --Comment
                                   p_workstage_code,
                                   p_result,         --Return
                                   p_type);

          /********************************************************************/
                    
      ELSE
        
          p_result     := 'OK';
          p_message    := 'EXISTS_PID_CHECK';
          p_ng_message := '';
          p_ok_message := '';     

      END IF;
      
      RETURN;
 
   END IF;
   
   --------------------------------------------------------------------------
   -- 바코드 마킹 중복 check
   --------------------------------------------------------------------------

   IF p_type = 'MARKING_DUP_CHECK' THEN
     
      BEGIN
        
         SELECT count(*)
           INTO lvl_count
           FROM iq_machine_inspect_data_mk
          WHERE pid = p_serial_no;
          
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              lvi_count := 0;
      END;
      
      IF ( p_workstage_code = 'W010') then
           lvl_max_count := 0;
      ELSE
           lvl_max_count := 1;
      END IF;

      IF lvl_count > lvl_max_count THEN
        
            p_result     := 'NG';
            p_message    := 'MARKING_DUP_CHECK';
            p_ng_message := f_msg('바코드 마킹 중복발생','C',1);
            p_ok_message := '';
         
         /*********************************************************************/
          P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                   p_machine_code,
                                   p_serial_no,
                                   sysdate,
                                   p_ng_message,     --Comment
                                   p_workstage_code,
                                   p_result,         --Return
                                   p_type);

          /********************************************************************/
                    
      ELSE
        
          p_result     := 'OK';
          p_message    := 'MARKING_DUP_CHECK';
          p_ng_message := '';
          p_ok_message := '';     

      END IF;
      
      RETURN;
 
   END IF;   

   --------------------------------------------------------------------------
   -- 바코드 마킹 중복 check
   --------------------------------------------------------------------------

   IF p_type = 'MARKING_DUP_CHECK2' THEN
     
      BEGIN
        
         SELECT count(*)
           INTO lvl_count
           FROM iq_machine_inspect_data_mk
          WHERE pid = p_serial_no;
          
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              lvi_count := 0;
      END;
      
      IF ( p_workstage_code = 'W010') then
           lvl_max_count := 4;
      ELSE
           lvl_max_count := 4;
      END IF;

      IF lvl_count >= lvl_max_count THEN
        
            p_result     := 'NG';
            p_message    := 'MARKING_DUP_CHECK2';
            p_ng_message := f_msg('바코드 마킹 중복발생','C',1);
            p_ok_message := '';
         
         /*********************************************************************/
          P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                   p_machine_code,
                                   p_serial_no,
                                   sysdate,
                                   p_ng_message,     --Comment
                                   p_workstage_code,
                                   p_result,         --Return
                                   p_type);

          /********************************************************************/
                    
      ELSE
        
          p_result     := 'OK';
          p_message    := 'MARKING_DUP_CHECK2';
          p_ng_message := '';
          p_ok_message := '';     

      END IF;
      
      RETURN;
 
   END IF;  
   
   -------------------------------------------------------------------------------------
   --
   -------------------------------------------------------------------------------------

   IF p_type = 'LOT_MATCH_CHECK' THEN
     
      BEGIN
         SELECT NVL(RUN_NO,'')
           INTO lvs_pid_run_no
           FROM ip_product_2d_barcode
          WHERE serial_no = p_serial_no;
          
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
           
            p_result     := 'NG';
            p_message    := 'LOT_MATCH_CHECK';
            p_ng_message := f_msg( '미등록 바코드 투입','C',1);
            p_ok_message :='';

            /*********************************************************************/
            P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                     p_machine_code,
                                     p_serial_no,
                                     sysdate,
                                     p_ng_message,
                                     p_workstage_code,
                                     p_result,     --Return
                                     p_type);

            /********************************************************************/
            
            RETURN;
      END;

           
      IF ( lvs_pid_run_no = lvs_run_no) THEN
        
         p_result     := 'OK';
         p_message    := 'LOT_MATCH_CHECK';
         p_ng_message := '';
         p_ok_message := f_msg('장착 Lot와 투입 바코드 확인 정상.','C',1);
         
      ELSE
        
            p_result     := 'NG';
            p_message    := 'LOT_MATCH_CHECK';
            p_ng_message := f_msg('장착 Lot와 투입 바코드 불일치','C',1);
            p_ok_message := '';
            
            /*********************************************************************/
            P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                     p_machine_code,
                                     p_serial_no,
                                     sysdate,
                                     p_ng_message,
                                     p_workstage_code,
                                     p_result,     --Return
                                     p_type);

            /********************************************************************/
         
      END IF;

      RETURN;
      
   END IF;
      
   -------------------------------------------------------------------------------------
   --
   -------------------------------------------------------------------------------------

   IF p_type = 'MODEL_MATCH_CHECK' THEN
     
      BEGIN
         SELECT NVL(MODEL_NAME,'')
           INTO lvs_item_code
           FROM ip_product_2d_barcode
          WHERE serial_no = p_serial_no;
          
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
           
            p_result     := 'NG';
            p_message    := 'MODEL_MATCH_CHECK';
            p_ng_message := f_msg( '미등록 바코드 투입','C',1);
            p_ok_message :='';

            /*********************************************************************/
            P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                     p_machine_code,
                                     p_serial_no,
                                     sysdate,
                                     p_ng_message,
                                     p_workstage_code,
                                     p_result,     --Return
                                     p_type);

            /********************************************************************/
            
            RETURN;
      END;

      
      SELECT COUNT (*)
        INTO lvi_count
        FROM ip_product_line
       WHERE line_code  = p_line_code 
         AND MODEL_NAME = lvs_item_code;

      
      IF lvi_count = 1 THEN
        
         p_result     := 'OK';
         p_message    := 'MODEL_MATCH_CHECK';
         p_ng_message := '';
         p_ok_message := f_msg('장착모델과 투입 바코드 확인 정상.','C',1);
         
      ELSE
        
            p_result     := 'NG';
            p_message    := 'MODEL_MATCH_CHECK';
            p_ng_message := f_msg('장착모델과 투입 바코드 불일치','C',1);
            p_ok_message := '';
            
            /*********************************************************************/
            P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                     p_machine_code,
                                     p_serial_no,
                                     sysdate,
                                     p_ng_message,
                                     p_workstage_code,
                                     p_result,     --Return
                                     p_type);

            /********************************************************************/
         
      END IF;

      RETURN;
      
   END IF;
   

   ----------------------------------------------------------------------------------------------------------------------------------------------------
   -- CCS 체크 유무 
   ----------------------------------------------------------------------------------------------------------------------------------------------------
   IF p_type = 'CCS_STATUS_CHECK' THEN
     
      BEGIN
        
         SELECT COUNT (*)
           INTO lvi_check_result_count
           FROM ip_product_line
          WHERE LINE_CODE = P_LINE_CODE 
            AND CCS_DATE IS NOT NULL;
            
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              lvi_check_result_count := 0;
      END;

      --------------------------------------------------------
      --
      --------------------------------------------------------
      IF NVL (lvi_check_result_count, 0) < 1 THEN
         
         p_result     := 'NG';
         p_message    := 'CCS_STATUS_CHECK';
         p_ng_message := f_msg('오삽방지 이력 없음','C',1);
         p_ok_message := '';
                    
             /*********************************************************************/
             P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                      p_machine_code,
                                      p_serial_no,
                                      sysdate,
                                      p_ng_message,
                                      p_workstage_code,
                                      p_result,     --Return
                                      p_type);

             /********************************************************************/

      ELSE
        
         p_result     := 'OK';
         p_message    := 'CCS_STATUS_CHECK';
         p_ng_message := '';
         p_ok_message := f_msg( '오삽방지 체크 정상','C',1);    
                                    
      END IF;

      RETURN;
      
   END IF;
   
   ----------------------------------------------------------------------------------------------------------------------------------------------------
   -- FULL 체크 유무 
   ----------------------------------------------------------------------------------------------------------------------------------------------------
   IF p_type = 'FULL_STATUS_CHECK' THEN
     
      BEGIN
        
         SELECT COUNT (*)
           INTO lvi_check_result_count
           FROM ip_product_line
          WHERE LINE_CODE = P_LINE_CODE 
            AND ( CCS_DATE IS NULL OR
                  ((sysdate - NVL(FULL_CHECK_DATE, CCS_DATE)) * 24) < 2
                ) ;
            
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              lvi_check_result_count := 0;
      END;

      --------------------------------------------------------
      --
      --------------------------------------------------------
      IF NVL (lvi_check_result_count, 0) = 0 THEN
         
         p_result     := 'NG';
         p_message    := 'FULL_STATUS_CHECK';
         p_ng_message := f_msg('중간체크 이력 없거나 2시간 오버','C',1);
         p_ok_message := '';
                    
             /*********************************************************************/
             P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                      p_machine_code,
                                      p_serial_no,
                                      sysdate,
                                      p_ng_message,
                                      p_workstage_code,
                                      p_result,     --Return
                                      p_type);

             /********************************************************************/

      ELSE
        
         p_result     := 'OK';
         p_message    := 'FULL_STATUS_CHECK';
         p_ng_message := '';
         p_ok_message := f_msg( '중간체크 정상','C',1);    
                                    
      END IF;

      RETURN;
      
   END IF;
   
  ----------------------------------------------------------------------------------------------------------------------------------------------------
   -- FULL 체크 유무 
   ----------------------------------------------------------------------------------------------------------------------------------------------------
   IF p_type = 'FULL_STATUS_CHECK_4H' THEN
     
      BEGIN
        
         SELECT COUNT (*)
           INTO lvi_check_result_count
           FROM ip_product_line
          WHERE LINE_CODE = P_LINE_CODE 
            AND ( CCS_DATE IS NULL OR
                  ((sysdate - NVL(FULL_CHECK_DATE, CCS_DATE)) * 24) < 4
                ) ;
            
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              lvi_check_result_count := 0;
      END;

      --------------------------------------------------------
      --
      --------------------------------------------------------
      IF NVL (lvi_check_result_count, 0) = 0 THEN
         
         p_result     := 'NG';
         p_message    := 'FULL_STATUS_CHECK';
         p_ng_message := f_msg('중간체크 이력 없거나 4시간 오버','C',1);
         p_ok_message := '';
                    
             /*********************************************************************/
             P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                      p_machine_code,
                                      p_serial_no,
                                      sysdate,
                                      p_ng_message,
                                      p_workstage_code,
                                      p_result,     --Return
                                      p_type);

             /********************************************************************/

      ELSE
        
         p_result     := 'OK';
         p_message    := 'FULL_STATUS_CHECK';
         p_ng_message := '';
         p_ok_message := f_msg( '중간체크 정상','C',1);    
                                    
      END IF;

      RETURN;
      
   END IF;   
   
    ----------------------------------------------------------------------------------------------------------------------------------------------------
   -- LCR STATUS CHECK 체크 유무 
   ----------------------------------------------------------------------------------------------------------------------------------------------------
   IF p_type = 'LCR_STATUS_CHECK' THEN
     
      BEGIN
        
         SELECT LCR_LOT_NO
           INTO lvs_lcr_lot_no
           FROM ip_product_line
          WHERE LINE_CODE = P_LINE_CODE ;
            
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              lvs_lcr_lot_no := NULL ;
      END;

      --------------------------------------------------------
      --
      --------------------------------------------------------
      IF lvs_lcr_lot_no IS NULL THEN
         
         p_result     := 'NG';
         p_message    := 'LCR_STATUS_CHECK';
         p_ng_message := f_msg('LCR 체크 이력 없음','C',1);
         p_ok_message := '';
                    
             /*********************************************************************/
             P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                      p_machine_code,
                                      p_serial_no,
                                      sysdate,
                                      p_ng_message,
                                      p_workstage_code,
                                      p_result,     --Return
                                      p_type);

             /********************************************************************/

      ELSE
        
         p_result     := 'OK';
         p_message    := 'LCR_STATUS_CHECK';
         p_ng_message := '';
         p_ok_message := lvs_lcr_lot_no||' '||f_msg( 'LCR 체크 정상','C',1);    
                                    
      END IF;

      RETURN;
      
   END IF;
   
   ----------------------------------------------------------------------------------------------------------------------------------------------------
   -- 양불마스타 장착이력 체크 
   ----------------------------------------------------------------------------------------------------------------------------------------------------
   IF p_type = 'SAMPLE_STATUS_CHECK' THEN
     
      BEGIN
        
         SELECT COUNT (*)
           INTO lvi_check_result_count
           FROM ip_product_line
          WHERE LINE_CODE = P_LINE_CODE 
            AND sample_check_date  IS NOT NULL
            AND sample_check_date2 IS NOT NULL;
            
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              lvi_check_result_count := 0;
      END;

      --------------------------------------------------------
      --
      --------------------------------------------------------
      IF NVL (lvi_check_result_count, 0) < 1 THEN
         
         p_result     := 'NG';
         p_message    := 'SAMPLE_STATUS_CHECK';
         p_ng_message := f_msg('양불마스터 투입이력이 없음','C',1);
         p_ok_message := '';
                    
             /*********************************************************************/
             P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                      p_machine_code,
                                      p_serial_no,
                                      sysdate,
                                      p_ng_message,
                                      p_workstage_code,
                                      p_result,     --Return
                                      p_type);

             /********************************************************************/

      ELSE
        
         p_result     := 'OK';
         p_message    := 'SAMPLE_STATUS_CHECK';
         p_ng_message := '';
         p_ok_message := f_msg( '양불마스터 투입이력 체크 정상','C',1);    
                                    
      END IF;

      RETURN;
      
   END IF;
   
   ------------------------------------------------------------------------
   -- REPAIR 상태 확인
   -----------------------------------------------------------------------

   IF p_type = 'REPAIR_STATUS_CHECK' THEN
     
      BEGIN
        
         SELECT COUNT (*)
           INTO lvl_count
           FROM ip_product_work_qc
          WHERE serial_no       = p_serial_no
            AND receipt_deficit = '1';
            
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              lvl_count := 0;
      END;

      IF NVL (lvl_count, 0) > 0 THEN
        
         p_result     := 'NG';
         p_message    := 'REPAIR_STATUS_CHECK';
         p_ng_message := f_msg('수리실에서 출고처리 하지 않았음','C',1);
         p_ok_message := '';
         
         /*********************************************************************/
          P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                   p_machine_code,
                                   p_serial_no,
                                   sysdate,
                                   p_ng_message,
                                   p_workstage_code,
                                   p_result,     --Return
                                   p_type);

          /********************************************************************/

      ELSE
        
      
          BEGIN
            
      -------------------------------------------------------------------
      -- 수리 후 결과를 확인한다
      -------------------------------------------------------------------
                
             SELECT repair_result_code, qc_inspect_handling 
               INTO lvs_repair_result,  lvs_inspect_handling
               FROM ip_product_work_qc
              WHERE serial_no = p_serial_no
                AND qc_date   = ( 
                                  SELECT max(qc_date)
                                    FROM ip_product_work_qc
                                   WHERE serial_no = p_serial_no
                                )
                AND rownum  = 1;
                
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  lvs_repair_result    := 'G';
                  lvs_inspect_handling := 'U';
          END;
      
          IF ( lvs_repair_result <> 'G' or lvs_inspect_handling <> 'U') THEN       --  G: 수리완료, U: 재사용
        
               select '수리결과 '|| 
                       F_GET_BASECODE('REPAIR RESULT CODE', lvs_repair_result, 'K', 1) ||
                       ':'||
                       F_GET_BASECODE('QC INSPECT HANDLING', lvs_inspect_handling, 'K', 1) ||
                      ' 된 제품 입니다' 
               into lvs_message
               from dual;             
               
             p_result     := 'NG';
             p_message    := 'REPAIR_STATUS_CHECK';
             p_ng_message := lvs_message;
             p_ok_message := '';
         
             /*********************************************************************/
             P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                      p_machine_code,
                                      p_serial_no,
                                      sysdate,
                                      p_ng_message,
                                      p_workstage_code,
                                      p_result,     --Return
                                      p_type);

             /********************************************************************/

           ELSE  
             
                    p_result     := 'OK';
                    p_message    := 'REPAIR_STATUS_CHECK';
                    p_ng_message := '';
                    p_ok_message := f_msg('수리상태 체크 정상','C',1);
                        
      
           END IF;
         
      END IF;

      RETURN;
      
   END IF;
      
   ------------------------------------------------------------------------
   -- REPAIR 상태 확인, TOP 확인 후 BOT 확인
   -----------------------------------------------------------------------

   IF p_type = 'REPAIR_STATUS_CHECK_TB' THEN
     
      BEGIN
        
         SELECT COUNT (*)
           INTO lvl_count
           FROM ip_product_work_qc
          WHERE serial_no       = p_serial_no
            AND receipt_deficit = '1';
            
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              lvl_count := 0;
      END;

      IF NVL (lvl_count, 0) > 0 THEN
        
         p_result     := 'NG';
         p_message    := 'REPAIR_STATUS_CHECK_TB';
         p_ng_message := f_msg('수리실에서 출고처리 하지 않았음','C',1)||lvs_pcb_tb_suffix;
         p_ok_message := '';
         
         /*********************************************************************/
          P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                   p_machine_code,
                                   p_serial_no,
                                   sysdate,
                                   p_ng_message,
                                   p_workstage_code,
                                   p_result,     --Return
                                   p_type);

          /********************************************************************/
          
          RETURN;

      ELSE
        
      
          BEGIN
            
      -------------------------------------------------------------------
      -- 수리 후 결과를 확인한다
      -------------------------------------------------------------------
                
             SELECT repair_result_code, qc_inspect_handling 
               INTO lvs_repair_result,  lvs_inspect_handling
               FROM ip_product_work_qc
              WHERE serial_no = p_serial_no
                AND qc_date   = ( 
                                  SELECT max(qc_date)
                                    FROM ip_product_work_qc
                                   WHERE serial_no = p_serial_no
                                )
                AND rownum  = 1;
                
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  lvs_repair_result    := 'G';
                  lvs_inspect_handling := 'U';
          END;
      
          IF ( lvs_repair_result <> 'G' or lvs_inspect_handling <> 'U') THEN       --  G: 수리완료, U: 재사용
        
               select '수리결과 '|| 
                       F_GET_BASECODE('REPAIR RESULT CODE', lvs_repair_result, 'K', 1) ||
                       ':'||
                       F_GET_BASECODE('QC INSPECT HANDLING', lvs_inspect_handling, 'K', 1) ||
                      ' 된 제품 입니다' 
               into lvs_message
               from dual;             
               
             p_result     := 'NG';
             p_message    := 'REPAIR_STATUS_CHECK_TB';
             p_ng_message := lvs_message||lvs_pcb_tb_suffix;
             p_ok_message := '';
         
             /*********************************************************************/
             P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                      p_machine_code,
                                      p_serial_no,
                                      sysdate,
                                      p_ng_message,
                                      p_workstage_code,
                                      p_result,     --Return
                                      p_type);

             /********************************************************************/
             
             RETURN;

           ELSE  
             
                    p_result     := 'OK';
                    p_message    := 'REPAIR_STATUS_CHECK_TB';
                    p_ng_message := '';
                    p_ok_message := f_msg('수리상태 체크 정상','C',1);
                        
      
           END IF;
         
      END IF;

   --------------------------------------------------------------------------
   --  TOP 에 대해 BOT CHECK 
   --------------------------------------------------------------------------
      IF ( p_workstage_code = 'W220' and substr(p_serial_no, -1) = 'T' and LVS_CARRIER_BARCODE_YN = 'Y') THEN
        
           LVS_BOT_BARCODE := substr(p_serial_no, 1, length(p_serial_no)-1)||'B';
           
            BEGIN
              
               SELECT COUNT (*)
                 INTO lvl_count
                 FROM ip_product_work_qc
                WHERE serial_no       = LVS_BOT_BARCODE
                  AND receipt_deficit = '1';
                  
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                    lvl_count := 0;
            END;

            IF NVL (lvl_count, 0) > 0 THEN
              
               p_result     := 'NG';
               p_message    := 'REPAIR_STATUS_CHECK_TB';
               p_ng_message := f_msg('수리실에서 출고처리 하지 않았음(BOT)','C',1);
               p_ok_message := '';
               
               /*********************************************************************/
                P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                         p_machine_code,
                                         p_serial_no,
                                         sysdate,
                                         p_ng_message,
                                         p_workstage_code,
                                         p_result,     --Return
                                         p_type);

                /********************************************************************/
                
                RETURN;

            ELSE
              
            
                BEGIN
                  
            -------------------------------------------------------------------
            -- 수리 후 결과를 확인한다
            -------------------------------------------------------------------
                      
                   SELECT repair_result_code, qc_inspect_handling 
                     INTO lvs_repair_result,  lvs_inspect_handling
                     FROM ip_product_work_qc
                    WHERE serial_no = LVS_BOT_BARCODE
                      AND qc_date   = ( 
                                        SELECT max(qc_date)
                                          FROM ip_product_work_qc
                                         WHERE serial_no = LVS_BOT_BARCODE
                                      )
                      AND rownum  = 1;
                      
                EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                        lvs_repair_result    := 'G';
                        lvs_inspect_handling := 'U';
                END;
            
                IF ( lvs_repair_result <> 'G' or lvs_inspect_handling <> 'U') THEN       --  G: 수리완료, U: 재사용
              
                     select '수리결과 '|| 
                             F_GET_BASECODE('REPAIR RESULT CODE', lvs_repair_result, 'K', 1) ||
                             ':'||
                             F_GET_BASECODE('QC INSPECT HANDLING', lvs_inspect_handling, 'K', 1) ||
                            ' 된 제품 입니다' 
                     into lvs_message
                     from dual;             
                     
                   p_result     := 'NG';
                   p_message    := 'REPAIR_STATUS_CHECK_TB';
                   p_ng_message := lvs_message||'(BOT)';
                   p_ok_message := '';
               
                   /*********************************************************************/
                   P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                            p_machine_code,
                                            p_serial_no,
                                            sysdate,
                                            p_ng_message,
                                            p_workstage_code,
                                            p_result,     --Return
                                            p_type);

                   /********************************************************************/
                   
                   RETURN;

                 ELSE  
                   
                          p_result     := 'OK';
                          p_message    := 'REPAIR_STATUS_CHECK_TB';
                          p_ng_message := '';
                          p_ok_message := f_msg('수리상태 체크 정상','C',1);
                              
            
                 END IF;
               
            END IF;           
           

      END IF;
      
   --------------------------------------------------------------------------
   --  TOP 에 대해 BOT CHECK 
   --------------------------------------------------------------------------  
   
      RETURN;
      
   END IF;
 
    
   ------------------------------------------------------------------------
   -- REPAIR 출고제품에 대해 AOI 검사 상태 확인 (OK, USER_OK )
   -----------------------------------------------------------------------

   IF p_type = 'REPAIR_AOI_STATUS_CHECK' THEN
     
      BEGIN
        
        -------------------------------------------------------------------
        -- 수리 후 출고상태 확인
        -------------------------------------------------------------------           
         SELECT COUNT (*)
           INTO lvl_count
           FROM ip_product_work_qc
          WHERE serial_no       = p_serial_no
            AND receipt_deficit = '1';
            
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              lvl_count := 0;
      END;

      IF NVL (lvl_count, 0) > 0 THEN
        
         p_result     := 'NG';
         p_message    := 'REPAIR_AOI_STATUS_CHECK';
         p_ng_message := f_msg('수리실에서 출고처리 하지 않았음','C',1);
         p_ok_message := '';
         
         /*********************************************************************/
          P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                   p_machine_code,
                                   p_serial_no,
                                   sysdate,
                                   p_ng_message,
                                   p_workstage_code,
                                   p_result,     --Return
                                   p_type);

          /********************************************************************/

      ELSE
        
          BEGIN
            
             SELECT COUNT (*)
               INTO lvl_count
               FROM ip_product_work_qc
              WHERE serial_no       = p_serial_no
                AND receipt_deficit = '2';
                
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  lvl_count := 0;
          END;
        
          IF NVL(lvl_count, 0) = 0 THEN
            
             p_result     := 'OK';
             p_message    := 'REPAIR_AOI_STATUS_CHECK';
             p_ng_message := '';
             p_ok_message := f_msg('수리후 출고된 제품이 없음, 정상','C',1);        
            
          ELSE
                
          -------------------------------------------------------------------
          -- 수리 후 결과를 확인한다
          -------------------------------------------------------------------
                  
              BEGIN
                    
                SELECT COUNT(*)
                  INTO lvl_count
                  FROM IQ_MACHINE_INSPECT_DATA_AOI
                 WHERE PID = p_serial_no
                   AND ( RESULT = 'OK' OR REVIEW_RESULT = 'USEROK' )
                   AND TO_DATE(INSPECT_DATE, 'YYYY/MM/DD HH24:MI:SS') > (
                                                                          SELECT MAX(REPAIR_DATE)                  -- 2021-10-27 오전 4:21:52
                                                                            FROM IP_PRODUCT_WORK_QC
                                                                           WHERE SERIAL_NO       = p_serial_no 
                                                                             AND RECEIPT_DEFICIT = '2' 
                                                                        )
                   AND INSPECT_DATE >= (
                                         SELECT MAX(INSPECT_DATE)
                                           FROM IQ_MACHINE_INSPECT_DATA_AOI
                                          WHERE PID = p_serial_no
                                       );
                    
              EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                      lvl_count := 0;
              END;
          
              IF ( lvl_count = 0) THEN   
            
                   
                 p_result     := 'NG';
                 p_message    := 'REPAIR_AOI_STATUS_CHECK';
                 p_ng_message := f_msg('수리 후 AOI 검사결과 OK 또는 USEROK 가 없음','C',1);
                 p_ok_message := '';
             
                 /*********************************************************************/
                 P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                          p_machine_code,
                                          p_serial_no,
                                          sysdate,
                                          p_ng_message,
                                          p_workstage_code,
                                          p_result,     --Return
                                          p_type);

                 /********************************************************************/

               ELSE  
                 
                  p_result     := 'OK';
                  p_message    := 'REPAIR_AOI_STATUS_CHECK';
                  p_ng_message := '';
                  p_ok_message := f_msg('수리후 AOI 상태 체크 정상','C',1);
                            
          
               END IF;
             
            END IF;
           
        END IF;

        RETURN;
      
   END IF;

   ------------------------------------------------------------------------
   -- REPAIR 출고제품에 대해 AOI 검사 상태 확인 (OK만)
   -----------------------------------------------------------------------

   IF p_type = 'REPAIR_AOI_STATUS_CHECK2' THEN
     
      BEGIN
        
        -------------------------------------------------------------------
        -- 수리 후 출고상태 확인
        -------------------------------------------------------------------           
         SELECT COUNT (*)
           INTO lvl_count
           FROM ip_product_work_qc
          WHERE serial_no       = p_serial_no
            AND receipt_deficit = '1';
            
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              lvl_count := 0;
      END;

      IF NVL (lvl_count, 0) > 0 THEN
        
         p_result     := 'NG';
         p_message    := 'REPAIR_AOI_STATUS_CHECK2';
         p_ng_message := f_msg('수리실에서 출고처리 하지 않았음','C',1);
         p_ok_message := '';
         
         /*********************************************************************/
          P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                   p_machine_code,
                                   p_serial_no,
                                   sysdate,
                                   p_ng_message,
                                   p_workstage_code,
                                   p_result,     --Return
                                   p_type);

          /********************************************************************/

      ELSE
        
          BEGIN
            
             SELECT COUNT (*)
               INTO lvl_count
               FROM ip_product_work_qc
              WHERE serial_no       = p_serial_no
                AND receipt_deficit = '2';
                
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  lvl_count := 0;
          END;
        
          IF NVL(lvl_count, 0) = 0 THEN
            
             p_result     := 'OK';
             p_message    := 'REPAIR_AOI_STATUS_CHECK2';
             p_ng_message := '';
             p_ok_message := f_msg('수리후 출고된 제품이 없음, 정상','C',1);        
            
          ELSE
                
          -------------------------------------------------------------------
          -- 수리 후 결과를 확인한다
          -------------------------------------------------------------------
                  
              BEGIN
                    
                SELECT COUNT(*)
                  INTO lvl_count
                  FROM IQ_MACHINE_INSPECT_DATA_AOI
                 WHERE PID = p_serial_no
                   AND ( RESULT = 'OK')
                   AND TO_DATE(INSPECT_DATE, 'YYYY/MM/DD HH24:MI:SS') > (
                                                                          SELECT MAX(REPAIR_DATE)                  -- 2021-10-27 오전 4:21:52
                                                                            FROM IP_PRODUCT_WORK_QC
                                                                           WHERE SERIAL_NO       = p_serial_no 
                                                                             AND RECEIPT_DEFICIT = '2' 
                                                                        )
                   AND INSPECT_DATE >= (
                                         SELECT MAX(INSPECT_DATE)
                                           FROM IQ_MACHINE_INSPECT_DATA_AOI
                                          WHERE PID = p_serial_no
                                       );
                    
              EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                      lvl_count := 0;
              END;
          
              IF ( lvl_count = 0) THEN   
            
                   
                 p_result     := 'NG';
                 p_message    := 'REPAIR_AOI_STATUS_CHECK2';
                 p_ng_message := f_msg('수리 후 AOI 검사결과 OK 가 없음','C',1);
                 p_ok_message := '';
             
                 /*********************************************************************/
                 P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                          p_machine_code,
                                          p_serial_no,
                                          sysdate,
                                          p_ng_message,
                                          p_workstage_code,
                                          p_result,     --Return
                                          p_type);

                 /********************************************************************/

               ELSE  
                 
                  p_result     := 'OK';
                  p_message    := 'REPAIR_AOI_STATUS_CHECK2';
                  p_ng_message := '';
                  p_ok_message := f_msg('수리후 AOI 상태 체크 정상','C',1);
                            
          
               END IF;
             
            END IF;
           
        END IF;

        RETURN;
      
   END IF;
         
   ------------------------------------------------------------------------
   -- REPAIR 출고제품에 대해 AOI 검사 상태 확인(OK, USER_OK), TOP 확인 후 BOT 확인
   -----------------------------------------------------------------------

   IF p_type = 'REPAIR_AOI_STATUS_CHECK_TB' THEN
     
      BEGIN
        
        -------------------------------------------------------------------
        -- 수리 후 출고상태 확인
        -------------------------------------------------------------------           
         SELECT COUNT (*)
           INTO lvl_count
           FROM ip_product_work_qc
          WHERE serial_no       = p_serial_no
            AND receipt_deficit = '1';
            
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              lvl_count := 0;
      END;

      IF NVL (lvl_count, 0) > 0 THEN
        
         p_result     := 'NG';
         p_message    := 'REPAIR_AOI_STATUS_CHECK_TB';
         p_ng_message := f_msg('수리실에서 출고처리 하지 않았음','C',1)||lvs_pcb_tb_suffix;
         p_ok_message := '';
         
         /*********************************************************************/
          P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                   p_machine_code,
                                   p_serial_no,
                                   sysdate,
                                   p_ng_message,
                                   p_workstage_code,
                                   p_result,     --Return
                                   p_type);

          /********************************************************************/
          
          RETURN;

      ELSE
        
          BEGIN
            
             SELECT COUNT (*)
               INTO lvl_count
               FROM ip_product_work_qc
              WHERE serial_no       = p_serial_no
                AND receipt_deficit = '2';
                
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  lvl_count := 0;
          END;
        
          IF NVL(lvl_count, 0) = 0 THEN
            
             p_result     := 'OK';
             p_message    := 'REPAIR_AOI_STATUS_CHECK_TB';
             p_ng_message := '';
             p_ok_message := f_msg('수리후 출고된 제품이 없음, 정상','C',1);        
            
          ELSE
                
          -------------------------------------------------------------------
          -- 수리 후 결과를 확인한다
          -------------------------------------------------------------------
                  
              BEGIN
                    
                SELECT COUNT(*)
                  INTO lvl_count
                  FROM IQ_MACHINE_INSPECT_DATA_AOI
                 WHERE PID = p_serial_no
                   AND ( RESULT = 'OK' OR REVIEW_RESULT = 'USEROK' )
                   AND TO_DATE(INSPECT_DATE, 'YYYY/MM/DD HH24:MI:SS') > (
                                                                          SELECT MAX(REPAIR_DATE)                  -- 2021-10-27 오전 4:21:52
                                                                            FROM IP_PRODUCT_WORK_QC
                                                                           WHERE SERIAL_NO       = p_serial_no 
                                                                             AND RECEIPT_DEFICIT = '2' 
                                                                        )
                   AND INSPECT_DATE >= (
                                         SELECT MAX(INSPECT_DATE)
                                           FROM IQ_MACHINE_INSPECT_DATA_AOI
                                          WHERE PID = p_serial_no
                                       );
                    
              EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                      lvl_count := 0;
              END;
          
              IF ( lvl_count = 0) THEN   
            
                   
                 p_result     := 'NG';
                 p_message    := 'REPAIR_AOI_STATUS_CHECK_TB';
                 p_ng_message := f_msg('수리 후 AOI 검사결과 OK 또는 USEROK 가 없음','C',1)||lvs_pcb_tb_suffix;
                 p_ok_message := '';
             
                 /*********************************************************************/
                 P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                          p_machine_code,
                                          p_serial_no,
                                          sysdate,
                                          p_ng_message,
                                          p_workstage_code,
                                          p_result,     --Return
                                          p_type);

                 /********************************************************************/
                 
                 RETURN;

               ELSE  
                 
                  p_result     := 'OK';
                  p_message    := 'REPAIR_AOI_STATUS_CHECK_TB';
                  p_ng_message := '';
                  p_ok_message := f_msg('수리후 AOI 상태 체크 정상','C',1);
                            
          
               END IF;
             
            END IF;
           
        END IF;

   --------------------------------------------------------------------------
   --  TOP 에 대해 BOT CHECK 
   --------------------------------------------------------------------------
      IF ( p_workstage_code = 'W220' and substr(p_serial_no, -1) = 'T' and LVS_CARRIER_BARCODE_YN = 'Y') THEN
        
           LVS_BOT_BARCODE := substr(p_serial_no, 1, length(p_serial_no)-1)||'B';
           
            BEGIN
              
              -------------------------------------------------------------------
              -- 수리 후 출고상태 확인
              -------------------------------------------------------------------           
               SELECT COUNT (*)
                 INTO lvl_count
                 FROM ip_product_work_qc
                WHERE serial_no       = LVS_BOT_BARCODE
                  AND receipt_deficit = '1';
                  
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                    lvl_count := 0;
            END;

            IF NVL (lvl_count, 0) > 0 THEN
              
               p_result     := 'NG';
               p_message    := 'REPAIR_AOI_STATUS_CHECK_TB';
               p_ng_message := f_msg('수리실에서 출고처리 하지 않았음(BOT)','C',1);
               p_ok_message := '';
               
               /*********************************************************************/
                P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                         p_machine_code,
                                         p_serial_no,
                                         sysdate,
                                         p_ng_message,
                                         p_workstage_code,
                                         p_result,     --Return
                                         p_type);

                /********************************************************************/
                
                RETURN;

            ELSE
              
                BEGIN
                  
                   SELECT COUNT (*)
                     INTO lvl_count
                     FROM ip_product_work_qc
                    WHERE serial_no       = LVS_BOT_BARCODE
                      AND receipt_deficit = '2';
                      
                EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                        lvl_count := 0;
                END;
              
                IF NVL(lvl_count, 0) = 0 THEN
                  
                   p_result     := 'OK';
                   p_message    := 'REPAIR_AOI_STATUS_CHECK_TB';
                   p_ng_message := '';
                   p_ok_message := f_msg('수리후 출고된 제품이 없음, 정상','C',1);        
                  
                ELSE
                      
                -------------------------------------------------------------------
                -- 수리 후 결과를 확인한다
                -------------------------------------------------------------------
                        
                    BEGIN
                          
                      SELECT COUNT(*)
                        INTO lvl_count
                        FROM IQ_MACHINE_INSPECT_DATA_AOI
                       WHERE PID = LVS_BOT_BARCODE
                         AND ( RESULT = 'OK' OR REVIEW_RESULT = 'USEROK' )
                         AND TO_DATE(INSPECT_DATE, 'YYYY/MM/DD HH24:MI:SS') > (
                                                                                SELECT MAX(REPAIR_DATE)                  -- 2021-10-27 오전 4:21:52
                                                                                  FROM IP_PRODUCT_WORK_QC
                                                                                 WHERE SERIAL_NO       = LVS_BOT_BARCODE 
                                                                                   AND RECEIPT_DEFICIT = '2' 
                                                                              )
                         AND INSPECT_DATE >= (
                                               SELECT MAX(INSPECT_DATE)
                                                 FROM IQ_MACHINE_INSPECT_DATA_AOI
                                                WHERE PID = LVS_BOT_BARCODE
                                             );
                          
                    EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                            lvl_count := 0;
                    END;
                
                    IF ( lvl_count = 0) THEN   
                  
                         
                       p_result     := 'NG';
                       p_message    := 'REPAIR_AOI_STATUS_CHECK_TB';
                       p_ng_message := f_msg('수리 후 AOI 검사결과 OK 또는 USEROK 가 없음(BOT)','C',1);
                       p_ok_message := '';
                   
                       /*********************************************************************/
                       P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                                p_machine_code,
                                                p_serial_no,
                                                sysdate,
                                                p_ng_message,
                                                p_workstage_code,
                                                p_result,     --Return
                                                p_type);

                       /********************************************************************/
                       
                       RETURN;

                     ELSE  
                       
                        p_result     := 'OK';
                        p_message    := 'REPAIR_AOI_STATUS_CHECK_TB';
                        p_ng_message := '';
                        p_ok_message := f_msg('수리후 AOI 상태 체크 정상','C',1);
                                  
                
                     END IF;
                   
                  END IF;
                 
              END IF;
                   

      END IF;
      
   --------------------------------------------------------------------------
   --  TOP 에 대해 BOT CHECK 
   --------------------------------------------------------------------------  
   
        RETURN;
      
   END IF;
   
   
   ------------------------------------------------------------------------
   -- REPAIR 출고제품에 대해 AOI 검사 상태 확인 (OK만), TOP 확인 후 BOT 확인
   -----------------------------------------------------------------------

   IF p_type = 'REPAIR_AOI_STATUS_CHECK_TB2' THEN
     
      BEGIN
        
        -------------------------------------------------------------------
        -- 수리 후 출고상태 확인
        -------------------------------------------------------------------           
         SELECT COUNT (*)
           INTO lvl_count
           FROM ip_product_work_qc
          WHERE serial_no       = p_serial_no
            AND receipt_deficit = '1';
            
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              lvl_count := 0;
      END;

      IF NVL (lvl_count, 0) > 0 THEN
        
         p_result     := 'NG';
         p_message    := 'REPAIR_AOI_STATUS_CHECK_TB2';
         p_ng_message := f_msg('수리실에서 출고처리 하지 않았음','C',1)||lvs_pcb_tb_suffix;
         p_ok_message := '';
         
         /*********************************************************************/
          P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                   p_machine_code,
                                   p_serial_no,
                                   sysdate,
                                   p_ng_message,
                                   p_workstage_code,
                                   p_result,     --Return
                                   p_type);

          /********************************************************************/
          
          RETURN;

      ELSE
        
          BEGIN
            
             SELECT COUNT (*)
               INTO lvl_count
               FROM ip_product_work_qc
              WHERE serial_no       = p_serial_no
                AND receipt_deficit = '2';
                
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  lvl_count := 0;
          END;
        
          IF NVL(lvl_count, 0) = 0 THEN
            
             p_result     := 'OK';
             p_message    := 'REPAIR_AOI_STATUS_CHECK_TB2';
             p_ng_message := '';
             p_ok_message := f_msg('수리후 출고된 제품이 없음, 정상','C',1);        
            
          ELSE
                
          -------------------------------------------------------------------
          -- 수리 후 결과를 확인한다
          -------------------------------------------------------------------
                  
              BEGIN
                    
                SELECT COUNT(*)
                  INTO lvl_count
                  FROM IQ_MACHINE_INSPECT_DATA_AOI
                 WHERE PID = p_serial_no
                   AND ( RESULT = 'OK' )
                   AND TO_DATE(INSPECT_DATE, 'YYYY/MM/DD HH24:MI:SS') > (
                                                                          SELECT MAX(REPAIR_DATE)                  -- 2021-10-27 오전 4:21:52
                                                                            FROM IP_PRODUCT_WORK_QC
                                                                           WHERE SERIAL_NO       = p_serial_no 
                                                                             AND RECEIPT_DEFICIT = '2' 
                                                                        )
                   AND INSPECT_DATE >= (
                                         SELECT MAX(INSPECT_DATE)
                                           FROM IQ_MACHINE_INSPECT_DATA_AOI
                                          WHERE PID = p_serial_no
                                       );
                    
              EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                      lvl_count := 0;
              END;
          
              IF ( lvl_count = 0) THEN   
            
                   
                 p_result     := 'NG';
                 p_message    := 'REPAIR_AOI_STATUS_CHECK_TB2';
                 p_ng_message := f_msg('수리 후 AOI 검사결과 OK 가 없음','C',1)||lvs_pcb_tb_suffix;
                 p_ok_message := '';
             
                 /*********************************************************************/
                 P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                          p_machine_code,
                                          p_serial_no,
                                          sysdate,
                                          p_ng_message,
                                          p_workstage_code,
                                          p_result,     --Return
                                          p_type);

                 /********************************************************************/
                 
                 RETURN;

               ELSE  
                 
                  p_result     := 'OK';
                  p_message    := 'REPAIR_AOI_STATUS_CHECK_TB2';
                  p_ng_message := '';
                  p_ok_message := f_msg('수리후 AOI 상태 체크 정상','C',1);
                            
          
               END IF;
             
            END IF;
           
        END IF;

   --------------------------------------------------------------------------
   --  TOP 에 대해 BOT CHECK 
   --------------------------------------------------------------------------
      IF ( p_workstage_code = 'W220' and substr(p_serial_no, -1) = 'T' and LVS_CARRIER_BARCODE_YN = 'Y') THEN
        
           LVS_BOT_BARCODE := substr(p_serial_no, 1, length(p_serial_no)-1)||'B';
           
            BEGIN
              
              -------------------------------------------------------------------
              -- 수리 후 출고상태 확인
              -------------------------------------------------------------------           
               SELECT COUNT (*)
                 INTO lvl_count
                 FROM ip_product_work_qc
                WHERE serial_no       = LVS_BOT_BARCODE
                  AND receipt_deficit = '1';
                  
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                    lvl_count := 0;
            END;

            IF NVL (lvl_count, 0) > 0 THEN
              
               p_result     := 'NG';
               p_message    := 'REPAIR_AOI_STATUS_CHECK_TB2';
               p_ng_message := f_msg('수리실에서 출고처리 하지 않았음(BOT)','C',1);
               p_ok_message := '';
               
               /*********************************************************************/
                P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                         p_machine_code,
                                         p_serial_no,
                                         sysdate,
                                         p_ng_message,
                                         p_workstage_code,
                                         p_result,     --Return
                                         p_type);

                /********************************************************************/
                
                RETURN;

            ELSE
              
                BEGIN
                  
                   SELECT COUNT (*)
                     INTO lvl_count
                     FROM ip_product_work_qc
                    WHERE serial_no       = LVS_BOT_BARCODE
                      AND receipt_deficit = '2';
                      
                EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                        lvl_count := 0;
                END;
              
                IF NVL(lvl_count, 0) = 0 THEN
                  
                   p_result     := 'OK';
                   p_message    := 'REPAIR_AOI_STATUS_CHECK_TB2';
                   p_ng_message := '';
                   p_ok_message := f_msg('수리후 출고된 제품이 없음, 정상','C',1);        
                  
                ELSE
                      
                -------------------------------------------------------------------
                -- 수리 후 결과를 확인한다
                -------------------------------------------------------------------
                        
                    BEGIN
                          
                      SELECT COUNT(*)
                        INTO lvl_count
                        FROM IQ_MACHINE_INSPECT_DATA_AOI
                       WHERE PID = LVS_BOT_BARCODE
                         AND ( RESULT = 'OK')
                         AND TO_DATE(INSPECT_DATE, 'YYYY/MM/DD HH24:MI:SS') > (
                                                                                SELECT MAX(REPAIR_DATE)                  -- 2021-10-27 오전 4:21:52
                                                                                  FROM IP_PRODUCT_WORK_QC
                                                                                 WHERE SERIAL_NO       = LVS_BOT_BARCODE 
                                                                                   AND RECEIPT_DEFICIT = '2' 
                                                                              )
                         AND INSPECT_DATE >= (
                                               SELECT MAX(INSPECT_DATE)
                                                 FROM IQ_MACHINE_INSPECT_DATA_AOI
                                                WHERE PID = LVS_BOT_BARCODE
                                             );
                          
                    EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                            lvl_count := 0;
                    END;
                
                    IF ( lvl_count = 0) THEN   
                  
                         
                       p_result     := 'NG';
                       p_message    := 'REPAIR_AOI_STATUS_CHECK_TB2';
                       p_ng_message := f_msg('수리 후 AOI 검사결과 OK 가 없음(BOT)','C',1);
                       p_ok_message := '';
                   
                       /*********************************************************************/
                       P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                                p_machine_code,
                                                p_serial_no,
                                                sysdate,
                                                p_ng_message,
                                                p_workstage_code,
                                                p_result,     --Return
                                                p_type);

                       /********************************************************************/
                       
                       RETURN;

                     ELSE  
                       
                        p_result     := 'OK';
                        p_message    := 'REPAIR_AOI_STATUS_CHECK_TB2';
                        p_ng_message := '';
                        p_ok_message := f_msg('수리후 AOI 상태 체크 정상','C',1);
                                  
                
                     END IF;
                   
                  END IF;
                 
              END IF;
                   

      END IF;
      
   --------------------------------------------------------------------------
   --  TOP 에 대해 BOT CHECK 
   --------------------------------------------------------------------------  
   
        RETURN;
      
   END IF;
      
   --------------------------------------------------------------------------
   -- 솔더투입 이력 확인
   --------------------------------------------------------------------------

   IF p_type = 'SOLDER_STATUS_CHECK' THEN

      BEGIN

         lvi_count := 0;

         SELECT solder_lot_no
           INTO lvs_solder_barcode
           FROM ip_product_line
          WHERE line_code         = p_line_code
            AND solder_check_date is not null
            AND organization_id   = 1;

      EXCEPTION
         WHEN NO_DATA_FOUND THEN

              p_result     := 'NG';
              p_message    := 'SOLDER_STATUS_CHECK';
              p_ng_message := f_msg('솔더 스캔이력 없음','C',1);
              p_ok_message := '';

              /*********************************************************************/
              P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                       p_machine_code,
                                       p_serial_no,
                                       sysdate,
                                       p_ng_message,
                                       p_workstage_code,
                                       p_result,     --Return
                                       p_type);

              /********************************************************************/
            
              RETURN;
            
      END;

   --------------------------------------------------------------------------
   -- 솔더투입시간 확인
   --------------------------------------------------------------------------

      BEGIN
        
         SELECT count(*)
           INTO lvl_count
           FROM im_item_solder_master
          WHERE line_code    = p_line_code
            AND item_barcode = lvs_solder_barcode
            AND issue_date   <= SYSDATE - (24 / 24);  -- 냉장고 출고 24시간 오버
                                  
      EXCEPTION
         WHEN NO_DATA_FOUND THEN         
              lvl_count := 0;
     
      END;
      
      IF  lvl_count > 0 THEN
                
          p_result     := 'NG';
          p_message    := 'SOLDER_STATUS_CHECK' ;
          p_ng_message := f_msg('냉장고 출고 후 24시간 오버','C',1);
          p_ok_message := '';

          /*********************************************************************/
          P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                   p_machine_code,
                                   p_serial_no,
                                   sysdate,
                                   p_ng_message,
                                   p_workstage_code,
                                   p_result,     --Return
                                   p_type);

          /********************************************************************/
          
          RETURN;
            
     ELSE
        
          BEGIN
            
             SELECT count(*)
               INTO lvl_count
               FROM im_item_solder_master
              WHERE line_code    = p_line_code
                AND item_barcode = lvs_solder_barcode
                AND input_date   <= SYSDATE - (12 / 24);  -- 라인투입 12시간 오버
                                      
          EXCEPTION
             WHEN NO_DATA_FOUND THEN         
                  lvl_count := 0;
         
          END;
          
          IF  lvl_count > 0 THEN
                    
              p_result     := 'NG';
              p_message    := 'SOLDER_STATUS_CHECK' ;
              p_ng_message := f_msg('라인투입 후 12시간 오버','C',1);
              p_ok_message := '';

              /*********************************************************************/
              P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                       p_machine_code,
                                       p_serial_no,
                                       sysdate,
                                       p_ng_message,
                                       p_workstage_code,
                                       p_result,     --Return
                                       p_type);

              /********************************************************************/
              
              RETURN;
              
           END IF;
                       
      END IF;
  
  
   --------------------------------------------------------------------------
   -- 솔더 최초 투입 또는 점도측정시간 확인
   --------------------------------------------------------------------------
       
      BEGIN
        
         select ((sysdate - nvl(viscosity_start_date, first_line_input_date) ) * 24) -- 경과시간
           into lvl_solder_time_check
           from im_item_solder_master
          where item_barcode in (
                                  select solder_lot_no
                                    from ip_product_line
                                   where line_code = p_line_code
                                );
                                
      EXCEPTION
        
         WHEN NO_DATA_FOUND THEN         
              lvl_solder_time_check := 0;
         
      END;
          
              
      IF  lvl_solder_time_check > 12 THEN
                    
              p_result     := 'NG';
              p_message    := 'SOLDER_STATUS_CHECK' ;
              p_ng_message := f_msg('점도측정 또는 최초투입 후 12시간 오버','C',1);
              p_ok_message := '';

              /*********************************************************************/
              P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                       p_machine_code,
                                       p_serial_no,
                                       sysdate,
                                       p_ng_message,
                                       p_workstage_code,
                                       p_result,     --Return
                                       p_type);

              /********************************************************************/
                
      ELSE
            
             p_result     := 'OK';
             p_message    := 'SOLDER_STATUS_CHECK';
             p_ok_message := f_msg('솔더상태 체크 정상','C',1);
             p_ng_message := '';            
                
      END IF;             
    
      RETURN;
      
   END IF;
   
   --------------------------------------------------------------------------
   --  SPI 이력 확인
   --------------------------------------------------------------------------
   IF p_type = 'SPI_EXISTS_CHECK' THEN

      BEGIN
        
         SELECT COUNT (*)
           INTO lvi_check_result_count
           FROM IQ_MACHINE_INSPECT_DATA_SPI
          WHERE PID = p_serial_no ;
          
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              lvi_check_result_count := 0;
      END;

      --------------------------------------------------------
      --
      --------------------------------------------------------
      IF NVL (lvi_check_result_count, 0) = 0 THEN
        
         p_result     := 'NG';
         p_message    := 'SPI_EXISTS_CHECK';
         p_ng_message := f_msg('SPI 이력 미존재','C',1);
         p_ok_message := '';                  
         
         /*********************************************************************/
          P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                   p_machine_code,
                                   p_serial_no,
                                   sysdate,
                                   p_ng_message,
                                   p_workstage_code,
                                   p_result,     --Return
                                   p_type);

          /********************************************************************/
      ELSE
        
         p_result     := 'OK';
         p_message    := 'SPI_EXISTS_CHECK';
         p_ng_message := '';
         p_ok_message := f_msg('SPI 이력 정상','C',1);           
         
      END IF;

      RETURN;

   END IF;
     --------------------------------------------------------------------------
   --  SPI OK 이력 확인
   --------------------------------------------------------------------------
   IF p_type = 'SPI_OK_EXISTS_CHECK' THEN

      BEGIN
        
         SELECT COUNT (*)
           INTO lvi_check_result_count
           FROM IQ_MACHINE_INSPECT_DATA_SPI
          WHERE PID       = p_serial_no 
            -- AND LINE_CODE = p_line_code 
             AND RESULT    IN ( 'OK', 'GOOD', 'Good', 'PASS' ) -- 2021/06/23 정D -- , 'USEROK' )
             AND INSPECT_DATE = (
                                  SELECT MAX(inspect_date)
                                    FROM IQ_MACHINE_INSPECT_DATA_SPI
                                   WHERE PID = p_serial_no 
                                );
          
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              lvi_check_result_count := 0;
      END;

      --------------------------------------------------------
      --
      --------------------------------------------------------
      IF NVL (lvi_check_result_count, 0) = 0 THEN
        
         p_result     := 'NG';
         p_message    := 'SPI_OK_EXISTS_CHECK';
         p_ng_message := f_msg('SPI OK 이력 미존재','C',1);
         p_ok_message := '';      
         
         /*********************************************************************/
          P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                   p_machine_code,
                                   p_serial_no,
                                   sysdate,
                                   p_ng_message,
                                   p_workstage_code,
                                   p_result,     --Return
                                   p_type);

          /********************************************************************/                          
         
      ELSE
        
         
         p_result     := 'OK';
         p_message    := 'SPI_OK_EXISTS_CHECK';
         p_ng_message := '';
         p_ok_message := f_msg('SPI OK 이력 정상','C',1);            
         
      END IF;

      RETURN;

   END IF;
      
   --------------------------------------------------------------------------
   --  SPI OK 이력 확인, TOP 확인 후 BOT 확인
   --------------------------------------------------------------------------
   IF p_type = 'SPI_OK_EXISTS_CHECK_TB' THEN

      BEGIN
        
         SELECT COUNT (*)
           INTO lvi_check_result_count
           FROM IQ_MACHINE_INSPECT_DATA_SPI
          WHERE PID       = p_serial_no 
            -- AND LINE_CODE = p_line_code 
             AND RESULT    IN ( 'OK', 'GOOD', 'Good', 'PASS' ) -- 2021/06/23 정D -- , 'USEROK' )
             AND INSPECT_DATE = (
                                  SELECT MAX(inspect_date)
                                    FROM IQ_MACHINE_INSPECT_DATA_SPI
                                   WHERE PID = p_serial_no 
                                );
          
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              lvi_check_result_count := 0;
      END;

      --------------------------------------------------------
      --
      --------------------------------------------------------
      IF NVL (lvi_check_result_count, 0) = 0 THEN
        
         p_result     := 'NG';
         p_message    := 'SPI_OK_EXISTS_CHECK_TB';
         p_ng_message := f_msg('SPI OK 이력 미존재','C',1)||lvs_pcb_tb_suffix;
         p_ok_message := '';      
         
         /*********************************************************************/
          P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                   p_machine_code,
                                   p_serial_no,
                                   sysdate,
                                   p_ng_message,
                                   p_workstage_code,
                                   p_result,     --Return
                                   p_type);

          /********************************************************************/      
          
          RETURN;                   
         
      ELSE
        
         
         p_result     := 'OK';
         p_message    := 'SPI_OK_EXISTS_CHECK_TB';
         p_ng_message := '';
         p_ok_message := f_msg('SPI OK 이력 정상','C',1);            
         
      END IF;

   --------------------------------------------------------------------------
   --  TOP 에 대해 BOT CHECK 
   --------------------------------------------------------------------------
      IF ( p_workstage_code = 'W220' and substr(p_serial_no, -1) = 'T' and LVS_CARRIER_BARCODE_YN = 'Y') THEN
        
           LVS_BOT_BARCODE := substr(p_serial_no, 1, length(p_serial_no)-1)||'B';
           
            BEGIN
              
               SELECT COUNT (*)
                 INTO lvi_check_result_count
                 FROM IQ_MACHINE_INSPECT_DATA_SPI
                WHERE PID       = LVS_BOT_BARCODE 
                  -- AND LINE_CODE = p_line_code 
                   AND RESULT    IN ( 'OK', 'GOOD', 'Good', 'PASS' ) -- 2021/06/23 정D -- , 'USEROK' )
                   AND INSPECT_DATE = (
                                        SELECT MAX(inspect_date)
                                          FROM IQ_MACHINE_INSPECT_DATA_SPI
                                         WHERE PID = LVS_BOT_BARCODE 
                                      );
                
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                    lvi_check_result_count := 0;
            END;

            --------------------------------------------------------
            --
            --------------------------------------------------------
            IF NVL (lvi_check_result_count, 0) = 0 THEN
              
               p_result     := 'NG';
               p_message    := 'SPI_OK_EXISTS_CHECK_TB';
               p_ng_message := f_msg('SPI OK 이력 미존재(BOT)','C',1);
               p_ok_message := '';      
               
               /*********************************************************************/
                P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                         p_machine_code,
                                         p_serial_no,
                                         sysdate,
                                         p_ng_message,
                                         p_workstage_code,
                                         p_result,     --Return
                                         p_type);

                /********************************************************************/      
                
                RETURN;                   
               
            ELSE
              
               
               p_result     := 'OK';
               p_message    := 'SPI_OK_EXISTS_CHECK_TB';
               p_ng_message := '';
               p_ok_message := f_msg('SPI OK 이력 정상','C',1);            
               
            END IF;
                 

      END IF;
      
   --------------------------------------------------------------------------
   --  TOP 에 대해 BOT CHECK 
   --------------------------------------------------------------------------  
   
      RETURN;

   END IF;
   
   --------------------------------------------------------------------------
   --  SPI OK 이력 확인 ( USEROK 포함)
   --------------------------------------------------------------------------
   IF p_type = 'SPI_OK_EXISTS_CHECK2' THEN

      BEGIN
        
         SELECT COUNT (*)
           INTO lvi_check_result_count
           FROM IQ_MACHINE_INSPECT_DATA_SPI
          WHERE PID       = p_serial_no 
            -- AND LINE_CODE = p_line_code 
             AND RESULT    IN ( 'OK', 'GOOD', 'Good', 'PASS', 'USEROK' )
             AND INSPECT_DATE = (
                                  SELECT MAX(inspect_date)
                                    FROM IQ_MACHINE_INSPECT_DATA_SPI
                                   WHERE PID = p_serial_no 
                                );
          
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              lvi_check_result_count := 0;
      END;

      --------------------------------------------------------
      --
      --------------------------------------------------------
      IF NVL (lvi_check_result_count, 0) = 0 THEN
        
         p_result     := 'NG';
         p_message    := 'SPI_OK_EXISTS_CHECK2';
         p_ng_message := f_msg('SPI OK 이력 미존재','C',1);
         p_ok_message := '';      
         
         /*********************************************************************/
          P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                   p_machine_code,
                                   p_serial_no,
                                   sysdate,
                                   p_ng_message,
                                   p_workstage_code,
                                   p_result,     --Return
                                   p_type);

          /********************************************************************/                          
         
      ELSE
        
         
         p_result     := 'OK';
         p_message    := 'SPI_OK_EXISTS_CHECK2';
         p_ng_message := '';
         p_ok_message := f_msg('SPI OK 이력 정상','C',1);            
         
      END IF;

      RETURN;

   END IF;
   
   --------------------------------------------------------------------------
   --  ICT 이력 확인
   --------------------------------------------------------------------------
   IF p_type = 'ICT_EXISTS_CHECK' THEN

      BEGIN
        
         SELECT COUNT (*)
           INTO lvi_check_result_count
           FROM IQ_MACHINE_INSPECT_DATA_ICT
          WHERE PID = p_serial_no ;
          
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              lvi_check_result_count := 0;
      END;

      --------------------------------------------------------
      --
      --------------------------------------------------------
      IF NVL (lvi_check_result_count, 0) = 0 THEN
        
         p_result     := 'NG';
         p_message    := 'ICT_EXISTS_CHECK';
         p_ng_message := f_msg('ICT 이력 미존재','C',1);
         p_ok_message := '';                  
         
         /*********************************************************************/
          P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                   p_machine_code,
                                   p_serial_no,
                                   sysdate,
                                   p_ng_message,
                                   p_workstage_code,
                                   p_result,     --Return
                                   p_type);

          /********************************************************************/
      ELSE
        
         p_result     := 'OK';
         p_message    := 'ICT_EXISTS_CHECK';
         p_ng_message := '';
         p_ok_message := f_msg('ICT 이력 정상','C',1);           
         
      END IF;

      RETURN;

   END IF;
   
   --------------------------------------------------------------------------
   --  ICT OK 이력 확인
   --------------------------------------------------------------------------
   IF p_type = 'ICT_OK_EXISTS_CHECK' THEN

      BEGIN
        
         SELECT COUNT (*)
           INTO lvi_check_result_count
           FROM IQ_MACHINE_INSPECT_DATA_ICT
          WHERE PID       = p_serial_no 
       --     AND  LINE_CODE = p_line_code 
            AND RESULT    IN ( 'OK','GOOD', 'PASS' )
            AND INSPECT_DATE = (
                                  SELECT MAX(inspect_date)
                                    FROM IQ_MACHINE_INSPECT_DATA_ICT
                                   WHERE PID = p_serial_no 
                                );
          
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              lvi_check_result_count := 0;
      END;

      --------------------------------------------------------
      --
      --------------------------------------------------------
      IF NVL (lvi_check_result_count, 0) = 0 THEN
        
         p_result     := 'NG';
         p_message    := 'ICT_OK_EXISTS_CHECK';
         p_ng_message := f_msg('ICT OK 이력 미존재','C',1);
         p_ok_message := '';      
         
         /*********************************************************************/
          P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                   p_machine_code,
                                   p_serial_no,
                                   sysdate,
                                   p_ng_message,
                                   p_workstage_code,
                                   p_result,     --Return
                                   p_type);

          /********************************************************************/                          
         
      ELSE
        
         
         p_result     := 'OK';
         p_message    := 'ICT_OK_EXISTS_CHECK';
         p_ng_message := '';
         p_ok_message := f_msg('ICT OK 이력 정상','C',1);            
         
      END IF;

      RETURN;

   END IF;   
   
   
   --------------------------------------------------------------------------
   --  ROM WRITE  OK 이력 확인
   --  유혁수 추가 20200624
   --------------------------------------------------------------------------
   IF p_type = 'ROMWRITE_OK_EXISTS_CHECK' THEN

      BEGIN
        
         SELECT COUNT (*)
           INTO lvi_check_result_count
           FROM IQ_MACHINE_INSPECT_DATA_RW
          WHERE PID       = p_serial_no 
       --     AND  LINE_CODE = p_line_code 
            AND RESULT    IN ( 'OK','GOOD', 'PASS' )
            AND INSPECT_DATE = (
                                  SELECT MAX(inspect_date)
                                    FROM IQ_MACHINE_INSPECT_DATA_RW
                                   WHERE PID = p_serial_no 
                                );
          
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              lvi_check_result_count := 0;
      END;

      --------------------------------------------------------
      --
      --------------------------------------------------------
      IF NVL (lvi_check_result_count, 0) = 0 THEN
        
         p_result     := 'NG';
         p_message    := 'ICT_OK_EXISTS_CHECK';
         p_ng_message := f_msg('ROMWRITE OK 이력 미존재','C',1);
         p_ok_message := '';      
         
         /*********************************************************************/
          P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                   p_machine_code,
                                   p_serial_no,
                                   sysdate,
                                   p_ng_message,
                                   p_workstage_code,
                                   p_result,     --Return
                                   p_type);

          /********************************************************************/                          
         
      ELSE
        
         
         p_result     := 'OK';
         p_message    := 'ROMWRITE_OK_EXISTS_CHECK';
         p_ng_message := '';
         p_ok_message := f_msg('ROMWRITE OK 이력 정상','C',1);            
         
      END IF;

      RETURN;

   END IF;    
   
   --------------------------------------------------------------------------
   --  AOI 이력 확인
   --------------------------------------------------------------------------
   IF p_type = 'AOI_EXISTS_CHECK' THEN

      BEGIN
        
         SELECT COUNT (*)
           INTO lvi_check_result_count
           FROM IQ_MACHINE_INSPECT_DATA_AOI
          WHERE PID = p_serial_no ;
          
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              lvi_check_result_count := 0;
      END;

      --------------------------------------------------------
      --
      --------------------------------------------------------
      IF NVL (lvi_check_result_count, 0) = 0 THEN
        
         p_result     := 'NG';
         p_message    := 'AOI_EXISTS_CHECK';
         p_ng_message := f_msg('AOI 이력 미존재','C',1);
         p_ok_message := '';                  
         
         /*********************************************************************/
          P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                   p_machine_code,
                                   p_serial_no,
                                   sysdate,
                                   p_ng_message,
                                   p_workstage_code,
                                   p_result,     --Return
                                   p_type);

          /********************************************************************/
      ELSE
        
         p_result     := 'OK';
         p_message    := 'AOI_EXISTS_CHECK';
         p_ng_message := '';
         p_ok_message := f_msg('AOI 이력 정상','C',1);           
         
      END IF;

      RETURN;

   END IF;
  
     --------------------------------------------------------------------------
   --  AOI OK 이력 확인
   --------------------------------------------------------------------------
   IF p_type = 'AOI_OK_EXISTS_CHECK' THEN

      BEGIN
        
         SELECT COUNT (*)
           INTO lvi_check_result_count
           FROM IQ_MACHINE_INSPECT_DATA_AOI
          WHERE PID       = p_serial_no 
            -- AND LINE_CODE = p_line_code 
            AND ( 
                   RESULT           IN ( 'OK', 'GOOD', 'PASS' )  -- OR -- 2021/06/23 정D   -- , 'USEROK' )
              --     REVIEW_RESULT    IN ( 'OK', 'USEROK' )  
                )
            AND INSPECT_DATE = (
                                  SELECT MAX(inspect_date)
                                    FROM IQ_MACHINE_INSPECT_DATA_AOI
                                   WHERE PID = p_serial_no 
                                );            
          
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              lvi_check_result_count := 0;
      END;

      --------------------------------------------------------
      --
      --------------------------------------------------------
      IF NVL (lvi_check_result_count, 0) = 0 THEN
        
      --------------------------------------------------------
      -- Master Sample 일 경우 SKIP
      --------------------------------------------------------   
      
         SELECT COUNT (*)
           INTO lvi_check_result_count
           FROM imcn_sample
          WHERE sample_barcode = p_serial_no
             OR sample_barcode = regexp_substr( p_serial_no, '[^-]+',1,1);
             
         IF NVL (lvi_check_result_count, 0) = 0 THEN   
           
             p_result     := 'NG';
             p_message    := 'AOI_OK_EXISTS_CHECK';
             p_ng_message := f_msg('AOI OK 이력 미존재','C',1);
             p_ok_message := '';      
             
             /*********************************************************************/
              P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                       p_machine_code,
                                       p_serial_no,
                                       sysdate,
                                       p_ng_message,
                                       p_workstage_code,
                                       p_result,     --Return
                                       p_type);

              /********************************************************************/   
         
         ELSE         
           
              p_result     := 'OK';
              p_message    := 'AOI_OK_EXISTS_CHECK';
              p_ng_message := '';
              p_ok_message := f_msg('PID 가 Maste Sample 입니다, SKIP','C',1);  
                                           
         END IF;
         
      ELSE
              
         p_result     := 'OK';
         p_message    := 'AOI_OK_EXISTS_CHECK';
         p_ng_message := '';
         p_ok_message := f_msg('AOI OK 이력 정상','C',1);            
         
      END IF;

      RETURN;

   END IF;   
    
   --------------------------------------------------------------------------
   --  AOI OK 이력 확인, TOP 확인 후 BOT 확인
   --------------------------------------------------------------------------
   IF p_type = 'AOI_OK_EXISTS_CHECK_TB' THEN

      BEGIN
        
         SELECT COUNT (*)
           INTO lvi_check_result_count
           FROM IQ_MACHINE_INSPECT_DATA_AOI
          WHERE PID       = p_serial_no 
            -- AND LINE_CODE = p_line_code 
            AND ( 
                   RESULT           IN ( 'OK', 'GOOD', 'PASS' )  -- OR -- 2021/06/23 정D   -- , 'USEROK' )
              --     REVIEW_RESULT    IN ( 'OK', 'USEROK' )  
                )
            AND INSPECT_DATE = (
                                  SELECT MAX(inspect_date)
                                    FROM IQ_MACHINE_INSPECT_DATA_AOI
                                   WHERE PID = p_serial_no 
                                );            
          
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              lvi_check_result_count := 0;
      END;

      --------------------------------------------------------
      --
      --------------------------------------------------------
      IF NVL (lvi_check_result_count, 0) = 0 THEN
        
      --------------------------------------------------------
      -- Master Sample 일 경우 SKIP
      --------------------------------------------------------   
      
         SELECT COUNT (*)
           INTO lvi_check_result_count
           FROM imcn_sample
          WHERE sample_barcode = p_serial_no
             OR sample_barcode = regexp_substr( p_serial_no, '[^-]+',1,1);
             
         IF NVL (lvi_check_result_count, 0) = 0 THEN   
           
             p_result     := 'NG';
             p_message    := 'AOI_OK_EXISTS_CHECK_TB';
             p_ng_message := f_msg('AOI OK 이력 미존재','C',1)||lvs_pcb_tb_suffix;
             p_ok_message := '';      
             
             /*********************************************************************/
              P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                       p_machine_code,
                                       p_serial_no,
                                       sysdate,
                                       p_ng_message,
                                       p_workstage_code,
                                       p_result,     --Return
                                       p_type);

              /********************************************************************/   
              
              RETURN;
         
         ELSE         
           
              p_result     := 'OK';
              p_message    := 'AOI_OK_EXISTS_CHECK_TB';
              p_ng_message := '';
              p_ok_message := f_msg('PID 가 Maste Sample 입니다, SKIP','C',1)||lvs_pcb_tb_suffix;  
              
              RETURN;
                                           
         END IF;
         
      ELSE
              
         p_result     := 'OK';
         p_message    := 'AOI_OK_EXISTS_CHECK_TB';
         p_ng_message := '';
         p_ok_message := f_msg('AOI OK 이력 정상','C',1);       
         
      END IF;

   --------------------------------------------------------------------------
   --  TOP 에 대해 BOT CHECK 
   --------------------------------------------------------------------------
      IF ( p_workstage_code = 'W220' and substr(p_serial_no, -1) = 'T' and LVS_CARRIER_BARCODE_YN = 'Y') THEN
        
           LVS_BOT_BARCODE := substr(p_serial_no, 1, length(p_serial_no)-1)||'B';
           
           
            BEGIN
              
               SELECT COUNT (*)
                 INTO lvi_check_result_count
                 FROM IQ_MACHINE_INSPECT_DATA_AOI
                WHERE PID       = LVS_BOT_BARCODE 
                  -- AND LINE_CODE = p_line_code 
                  AND ( 
                         RESULT           IN ( 'OK', 'GOOD', 'PASS' )  -- OR -- 2021/06/23 정D   -- , 'USEROK' )
                    --     REVIEW_RESULT    IN ( 'OK', 'USEROK' )  
                      )
                  AND INSPECT_DATE = (
                                        SELECT MAX(inspect_date)
                                          FROM IQ_MACHINE_INSPECT_DATA_AOI
                                         WHERE PID = LVS_BOT_BARCODE 
                                      );            
                
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                    lvi_check_result_count := 0;
            END;

            --------------------------------------------------------
            --
            --------------------------------------------------------
            
            IF NVL (lvi_check_result_count, 0) = 0 THEN
              
            --------------------------------------------------------
            -- Master Sample 일 경우 SKIP
            --------------------------------------------------------   
            
               SELECT COUNT (*)
                 INTO lvi_check_result_count
                 FROM imcn_sample
                WHERE sample_barcode = LVS_BOT_BARCODE
                   OR sample_barcode = regexp_substr( LVS_BOT_BARCODE, '[^-]+',1,1);
                   
               IF NVL (lvi_check_result_count, 0) = 0 THEN   
                 
                   p_result     := 'NG';
                   p_message    := 'AOI_OK_EXISTS_CHECK_TB';
                   p_ng_message := f_msg('AOI OK 이력 미존재(BOT)','C',1);
                   p_ok_message := '';      
                   
                   /*********************************************************************/
                    P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                             p_machine_code,
                                             p_serial_no,
                                             sysdate,
                                             p_ng_message,
                                             p_workstage_code,
                                             p_result,     --Return
                                             p_type);

                    /********************************************************************/   
                    
                    RETURN;
               
               ELSE         
                 
                    p_result     := 'OK';
                    p_message    := 'AOI_OK_EXISTS_CHECK_TB';
                    p_ng_message := '';
                    p_ok_message := f_msg('PID 가 Maste Sample 입니다(BOT), SKIP','C',1);  
                    
                    RETURN;
                                                 
               END IF;
               
            ELSE
                    
               p_result     := 'OK';
               p_message    := 'AOI_OK_EXISTS_CHECK_TB';
               p_ng_message := '';
               p_ok_message := f_msg('AOI OK 이력 정상','C',1);    
               
               return;        
               
            END IF;           
                   
      END IF;
      
   --------------------------------------------------------------------------
   --  TOP 에 대해 BOT CHECK 
   --------------------------------------------------------------------------   
      
      RETURN;

   END IF;   
   
      --------------------------------------------------------------------------
   --  AOI OK 이력 확인 ( USEROK 포함)
   --------------------------------------------------------------------------
   IF p_type = 'AOI_OK_EXISTS_CHECK2' THEN

      BEGIN
        
         SELECT COUNT (*)
           INTO lvi_check_result_count
           FROM IQ_MACHINE_INSPECT_DATA_AOI
          WHERE PID       = p_serial_no 
            -- AND LINE_CODE = p_line_code 
            AND ( 
                   RESULT           IN ( 'OK', 'GOOD', 'PASS', 'USEROK' ) OR -- 2021/06/23 정D   
                   REVIEW_RESULT    IN ( 'OK', 'USEROK' )  
                )
            AND INSPECT_DATE = (
                                  SELECT MAX(inspect_date)
                                    FROM IQ_MACHINE_INSPECT_DATA_AOI
                                   WHERE PID = p_serial_no 
                                );            
          
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              lvi_check_result_count := 0;
      END;

      --------------------------------------------------------
      --
      --------------------------------------------------------
      IF NVL (lvi_check_result_count, 0) = 0 THEN
        
      --------------------------------------------------------
      -- Master Sample 일 경우 SKIP
      --------------------------------------------------------   
      
         SELECT COUNT (*)
           INTO lvi_check_result_count
           FROM imcn_sample
          WHERE sample_barcode = p_serial_no
             OR sample_barcode = regexp_substr( p_serial_no, '[^-]+',1,1);
             
         IF NVL (lvi_check_result_count, 0) = 0 THEN   
           
             p_result     := 'NG';
             p_message    := 'AOI_OK_EXISTS_CHECK2';
             p_ng_message := f_msg('AOI OK 이력 미존재','C',1);
             p_ok_message := '';      
             
             /*********************************************************************/
              P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                       p_machine_code,
                                       p_serial_no,
                                       sysdate,
                                       p_ng_message,
                                       p_workstage_code,
                                       p_result,     --Return
                                       p_type);

              /********************************************************************/   
         
         ELSE         
           
              p_result     := 'OK';
              p_message    := 'AOI_OK_EXISTS_CHECK2';
              p_ng_message := '';
              p_ok_message := f_msg('PID 가 Maste Sample 입니다, SKIP','C',1);  
                                           
         END IF;
         
      ELSE
              
         p_result     := 'OK';
         p_message    := 'AOI_OK_EXISTS_CHECK2';
         p_ng_message := '';
         p_ok_message := f_msg('AOI OK 이력 정상','C',1);            
         
      END IF;

      RETURN;

   END IF;    
   
   --------------------------------------------------------------------------
   --  AOI OK 이력 확인 ( USEROK 포함), TOP 확인 후 BOT 확인
   --------------------------------------------------------------------------
   IF p_type = 'AOI_OK_EXISTS_CHECK2_TB' THEN

      BEGIN
        
         SELECT COUNT (*)
           INTO lvi_check_result_count
           FROM IQ_MACHINE_INSPECT_DATA_AOI
          WHERE PID       = p_serial_no 
            -- AND LINE_CODE = p_line_code 
            AND ( 
                   RESULT           IN ( 'OK', 'GOOD', 'PASS', 'USEROK' ) OR -- 2021/06/23 정D   
                   REVIEW_RESULT    IN ( 'OK', 'USEROK' )  
                )
            AND INSPECT_DATE = (
                                  SELECT MAX(inspect_date)
                                    FROM IQ_MACHINE_INSPECT_DATA_AOI
                                   WHERE PID = p_serial_no 
                                );            
          
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              lvi_check_result_count := 0;
      END;

      --------------------------------------------------------
      --
      --------------------------------------------------------
      IF NVL (lvi_check_result_count, 0) = 0 THEN
        
      --------------------------------------------------------
      -- Master Sample 일 경우 SKIP
      --------------------------------------------------------   
      
         SELECT COUNT (*)
           INTO lvi_check_result_count
           FROM imcn_sample
          WHERE sample_barcode = p_serial_no
             OR sample_barcode = regexp_substr( p_serial_no, '[^-]+',1,1);
             
         IF NVL (lvi_check_result_count, 0) = 0 THEN   
           
             p_result     := 'NG';
             p_message    := 'AOI_OK_EXISTS_CHECK2_TB';
             p_ng_message := f_msg('AOI OK 이력 미존재','C',1)||lvs_pcb_tb_suffix;
             p_ok_message := '';      
             
             /*********************************************************************/
              P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                       p_machine_code,
                                       p_serial_no,
                                       sysdate,
                                       p_ng_message,
                                       p_workstage_code,
                                       p_result,     --Return
                                       p_type);

              /********************************************************************/   
              
              RETURN;
         
         ELSE         
           
              p_result     := 'OK';
              p_message    := 'AOI_OK_EXISTS_CHECK2_TB';
              p_ng_message := '';
              p_ok_message := f_msg('PID 가 Maste Sample 입니다, SKIP','C',1)||lvs_pcb_tb_suffix;  
              
              RETURN;
                                           
         END IF;
         
      ELSE
              
         p_result     := 'OK';
         p_message    := 'AOI_OK_EXISTS_CHECK2_TB';
         p_ng_message := '';
         p_ok_message := f_msg('AOI OK 이력 정상','C',1);            
         
      END IF;
      
   --------------------------------------------------------------------------
   --  TOP 에 대해 BOT CHECK 
   --------------------------------------------------------------------------
      IF ( p_workstage_code = 'W220' and substr(p_serial_no, -1) = 'T' and LVS_CARRIER_BARCODE_YN = 'Y') THEN
        
           LVS_BOT_BARCODE := substr(p_serial_no, 1, length(p_serial_no)-1)||'B';
                 
            BEGIN
              
               SELECT COUNT (*)
                 INTO lvi_check_result_count
                 FROM IQ_MACHINE_INSPECT_DATA_AOI
                WHERE PID       = LVS_BOT_BARCODE 
                  -- AND LINE_CODE = p_line_code 
                  AND ( 
                         RESULT           IN ( 'OK', 'GOOD', 'PASS', 'USEROK' ) OR -- 2021/06/23 정D   
                         REVIEW_RESULT    IN ( 'OK', 'USEROK' )  
                      )
                  AND INSPECT_DATE = (
                                        SELECT MAX(inspect_date)
                                          FROM IQ_MACHINE_INSPECT_DATA_AOI
                                         WHERE PID = LVS_BOT_BARCODE 
                                      );            
                
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                    lvi_check_result_count := 0;
            END;

            --------------------------------------------------------
            --
            --------------------------------------------------------
            IF NVL (lvi_check_result_count, 0) = 0 THEN
              
            --------------------------------------------------------
            -- Master Sample 일 경우 SKIP
            --------------------------------------------------------   
            
               SELECT COUNT (*)
                 INTO lvi_check_result_count
                 FROM imcn_sample
                WHERE sample_barcode = LVS_BOT_BARCODE
                   OR sample_barcode = regexp_substr( LVS_BOT_BARCODE, '[^-]+',1,1);
                   
               IF NVL (lvi_check_result_count, 0) = 0 THEN   
                 
                   p_result     := 'NG';
                   p_message    := 'AOI_OK_EXISTS_CHECK2_TB';
                   p_ng_message := f_msg('AOI OK 이력 미존재(BOT)','C',1);
                   p_ok_message := '';      
                   
                   /*********************************************************************/
                    P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                             p_machine_code,
                                             p_serial_no,
                                             sysdate,
                                             p_ng_message,
                                             p_workstage_code,
                                             p_result,     --Return
                                             p_type);

                    /********************************************************************/         
                    
                    RETURN;              
               
               ELSE         
                 
                    p_result     := 'OK';
                    p_message    := 'AOI_OK_EXISTS_CHECK2_TB';
                    p_ng_message := '';
                    p_ok_message := f_msg('PID 가 Maste Sample 입니다(BOT), SKIP','C',1);  
                    
                    RETURN;
                                                 
               END IF;
               
            ELSE
                    
               p_result     := 'OK';
               p_message    := 'AOI_OK_EXISTS_CHECK2_TB';
               p_ng_message := '';
               p_ok_message := f_msg('AOI OK 이력 정상','C',1);            
               
            END IF;
      
      END IF;
      
   --------------------------------------------------------------------------
   --  TOP 에 대해 BOT CHECK 
   --------------------------------------------------------------------------            

      RETURN;

   END IF;     
   
      --------------------------------------------------------------------------
   --  AOI NG 이력 확인
   --------------------------------------------------------------------------
   IF p_type = 'AOI_NG_EXISTS_CHECK' THEN

      BEGIN
        
         SELECT COUNT (*), MAX( inspect_date )
           INTO lvi_ng_count, LVS_NG_DATE
           FROM IQ_MACHINE_INSPECT_DATA_AOI
          WHERE PID           = p_serial_no 
            AND RESULT        in ('NG', 'USERNG')
            AND NVL(REVIEW_RESULT,'NG') in ('NG', 'USERNG');
          
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              lvi_ng_count := 0;
      END;

      IF NVL (lvi_ng_count, 0) = 0 THEN
        
         p_result     := 'OK';
         p_message    := 'AOI_NG_EXISTS_CHECK';
         p_ng_message := '';
         p_ok_message := f_msg('AOI NG 이력이 없습니다','C',1);        
     
      ELSE
          
      --------------------------------------------------------
      -- 수리이력 확인
      --------------------------------------------------------   
      
         SELECT COUNT (*)
           INTO LVI_REPAIR_COUNT
           FROM ip_product_work_qc     
          WHERE QC_DATE         > to_date(LVS_NG_DATE, 'YYYY/MM/DD HH24:MI:SS')
            AND SERIAL_NO       = p_serial_no
            AND RECEIPT_DEFICIT = '2' ;
             
         IF NVL (LVI_REPAIR_COUNT, 0) = 0 THEN   
                                    
            p_result     := 'NG';
            p_message    := 'AOI_NG_EXISTS_CHECK';
            p_ng_message := f_msg('AOI 최종 NG 발생 이후 수리공정 출고이력이 없습니다','C',1);
            p_ok_message := '';  
                               
             /*********************************************************************/
              P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                       p_machine_code,
                                       p_serial_no,
                                       sysdate,
                                       p_ng_message,
                                       p_workstage_code,
                                       p_result,     --Return
                                       p_type);

              /********************************************************************/    
              
         ELSE
           
            SELECT COUNT (*)
              INTO lvi_count
              FROM IQ_MACHINE_INSPECT_DATA_AOI     
             WHERE inspect_date    > LVS_NG_DATE
               AND PID             = p_serial_no 
               AND ( 
                     ( RESULT IN ( 'OK', 'GOOD', 'PASS', 'USEROK' ) ) or
                     ( RESULT = 'NG' AND  REVIEW_RESULT = 'USEROK')
                   );
                   
            IF ( lvi_count = 0 ) THEN
                    
                  p_result     := 'NG';
                  p_message    := 'AOI_NG_EXISTS_CHECK';
                  p_ng_message := f_msg('AOI 최종 NG 발생 이후 수리품 AOI 검사력이 없습니다','C',1);
                  p_ok_message := '';  
                                     
                   /*********************************************************************/
                    P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                             p_machine_code,
                                             p_serial_no,
                                             sysdate,
                                             p_ng_message,
                                             p_workstage_code,
                                             p_result,     --Return
                                             p_type);

                    /********************************************************************/               
              
            ELSE       
                   
                   p_result     := 'OK';
                   p_message    := 'AOI_NG_EXISTS_CHECK';
                   p_ng_message := '';
                   p_ok_message := f_msg('AOI 최종 NG에 대한 수리/재검사 이력 존재','C',1);     
            
            END IF;    
           
         END IF;
                                        
      END IF;

      RETURN;

   END IF;  
   
   --------------------------------------------------------------------------
   --  AOI NG 이력 확인, TOP 확인 후 BOT 확인
   --------------------------------------------------------------------------
   IF p_type = 'AOI_NG_EXISTS_CHECK_TB' THEN

      BEGIN
        
         SELECT COUNT (*), MAX( inspect_date )
           INTO lvi_ng_count, LVS_NG_DATE
           FROM IQ_MACHINE_INSPECT_DATA_AOI
          WHERE PID           = p_serial_no 
            AND RESULT        in ('NG', 'USERNG')
            AND NVL(REVIEW_RESULT,'NG') in ('NG', 'USERNG');
          
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              lvi_ng_count := 0;
      END;

      IF NVL (lvi_ng_count, 0) = 0 THEN
        
         p_result     := 'OK';
         p_message    := 'AOI_NG_EXISTS_CHECK_TB';
         p_ng_message := '';
         p_ok_message := f_msg('AOI NG 이력이 없습니다','C',1)||lvs_pcb_tb_suffix;       
     
      ELSE
          
      --------------------------------------------------------
      -- 수리이력 확인
      --------------------------------------------------------   
      
         SELECT COUNT (*)
           INTO LVI_REPAIR_COUNT
           FROM ip_product_work_qc     
          WHERE QC_DATE         > to_date(LVS_NG_DATE, 'YYYY/MM/DD HH24:MI:SS')
            AND SERIAL_NO       = p_serial_no
            AND RECEIPT_DEFICIT = '2' ;
             
         IF NVL (LVI_REPAIR_COUNT, 0) = 0 THEN   
                                    
            p_result     := 'NG';
            p_message    := 'AOI_NG_EXISTS_CHECK_TB';
            p_ng_message := f_msg('AOI 최종 NG 발생 이후 수리공정 출고이력이 없습니다','C',1)||lvs_pcb_tb_suffix;
            p_ok_message := '';  
                               
             /*********************************************************************/
              P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                       p_machine_code,
                                       p_serial_no,
                                       sysdate,
                                       p_ng_message,
                                       p_workstage_code,
                                       p_result,     --Return
                                       p_type);

              /********************************************************************/    
              
              RETURN;
              
         ELSE
           
            SELECT COUNT (*)
              INTO lvi_count
              FROM IQ_MACHINE_INSPECT_DATA_AOI     
             WHERE inspect_date    > LVS_NG_DATE
               AND PID             = p_serial_no 
               AND ( 
                     ( RESULT IN ( 'OK', 'GOOD', 'PASS', 'USEROK' ) ) or
                     ( RESULT = 'NG' AND  REVIEW_RESULT = 'USEROK')
                   );
                   
            IF ( lvi_count = 0 ) THEN
                    
                  p_result     := 'NG';
                  p_message    := 'AOI_NG_EXISTS_CHECK_TB';
                  p_ng_message := f_msg('AOI 최종 NG 발생 이후 수리품 AOI 검사력이 없습니다','C',1)||lvs_pcb_tb_suffix;
                  p_ok_message := '';  
                                     
                   /*********************************************************************/
                    P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                             p_machine_code,
                                             p_serial_no,
                                             sysdate,
                                             p_ng_message,
                                             p_workstage_code,
                                             p_result,     --Return
                                             p_type);

                    /********************************************************************/      
                    
                   RETURN;         
              
            ELSE       
                   
                   p_result     := 'OK';
                   p_message    := 'AOI_NG_EXISTS_CHECK_TB';
                   p_ng_message := '';
                   p_ok_message := f_msg('AOI 최종 NG에 대한 수리/재검사 이력 존재','C',1);     
            
            END IF;    
           
         END IF;
                                        
      END IF;

   --------------------------------------------------------------------------
   --  TOP 에 대해 BOT CHECK 
   --------------------------------------------------------------------------
      IF ( p_workstage_code = 'W220' and substr(p_serial_no, -1) = 'T' and LVS_CARRIER_BARCODE_YN = 'Y') THEN
        
           LVS_BOT_BARCODE := substr(p_serial_no, 1, length(p_serial_no)-1)||'B';
           
                 
            BEGIN
              
               SELECT COUNT (*), MAX( inspect_date )
                 INTO lvi_ng_count, LVS_NG_DATE
                 FROM IQ_MACHINE_INSPECT_DATA_AOI
                WHERE PID           = LVS_BOT_BARCODE 
                  AND RESULT        in ('NG', 'USERNG')
                  AND NVL(REVIEW_RESULT,'NG') in ('NG', 'USERNG');
                
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                    lvi_ng_count := 0;
            END;

            IF NVL (lvi_ng_count, 0) = 0 THEN
              
               p_result     := 'OK';
               p_message    := 'AOI_NG_EXISTS_CHECK_TB';
               p_ng_message := '';
               p_ok_message := f_msg('AOI NG 이력이 없습니다','C',1);        
           
            ELSE
                
            --------------------------------------------------------
            -- 수리이력 확인
            --------------------------------------------------------   
            
               SELECT COUNT (*)
                 INTO LVI_REPAIR_COUNT
                 FROM ip_product_work_qc     
                WHERE QC_DATE         > to_date(LVS_NG_DATE, 'YYYY/MM/DD HH24:MI:SS')
                  AND SERIAL_NO       = LVS_BOT_BARCODE
                  AND RECEIPT_DEFICIT = '2' ;
                   
               IF NVL (LVI_REPAIR_COUNT, 0) = 0 THEN   
                                          
                  p_result     := 'NG';
                  p_message    := 'AOI_NG_EXISTS_CHECK_TB';
                  p_ng_message := f_msg('AOI 최종 NG 발생 이후 수리공정 출고이력이 없습니다(BOT)','C',1);
                  p_ok_message := '';  
                                     
                   /*********************************************************************/
                    P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                             p_machine_code,
                                             p_serial_no,
                                             sysdate,
                                             p_ng_message,
                                             p_workstage_code,
                                             p_result,     --Return
                                             p_type);

                    /********************************************************************/    
                    
                    RETURN;
                    
               ELSE
                 
                  SELECT COUNT (*)
                    INTO lvi_count
                    FROM IQ_MACHINE_INSPECT_DATA_AOI     
                   WHERE inspect_date    > LVS_NG_DATE
                     AND PID             = LVS_BOT_BARCODE 
                     AND ( 
                           ( RESULT IN ( 'OK', 'GOOD', 'PASS', 'USEROK' ) ) or
                           ( RESULT = 'NG' AND  REVIEW_RESULT = 'USEROK')
                         );
                         
                  IF ( lvi_count = 0 ) THEN
                          
                        p_result     := 'NG';
                        p_message    := 'AOI_NG_EXISTS_CHECK_TB';
                        p_ng_message := f_msg('AOI 최종 NG 발생 이후 수리품 AOI 검사력이 없습니다(BOT)','C',1);
                        p_ok_message := '';  
                                           
                         /*********************************************************************/
                          P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                                   p_machine_code,
                                                   p_serial_no,
                                                   sysdate,
                                                   p_ng_message,
                                                   p_workstage_code,
                                                   p_result,     --Return
                                                   p_type);

                          /********************************************************************/      
                          
                          RETURN;
                    
                  ELSE       
                         
                         p_result     := 'OK';
                         p_message    := 'AOI_NG_EXISTS_CHECK_TB';
                         p_ng_message := '';
                         p_ok_message := f_msg('AOI 최종 NG에 대한 수리/재검사 이력 존재','C',1);     
                  
                  END IF;    
                 
               END IF;
                                              
            END IF;
                 

      END IF;
      
   --------------------------------------------------------------------------
   --  TOP 에 대해 BOT CHECK 
   -------------------------------------------------------------------------- 
   
      RETURN;

   END IF;     
   
   --------------------------------------------------------------------------
   --  AOI NG 이력 확인
   --------------------------------------------------------------------------
   IF p_type = 'AOI_NG_COUNT_CHECK' THEN
     
      BEGIN
        
         SELECT COUNT (*)
           INTO lvi_ng_count
           FROM IQ_MACHINE_INSPECT_DATA_AOI
          WHERE PID              = p_serial_no 
            AND (
                  ( RESULT = 'NG'     AND REVIEW_RESULT = 'USERNG' ) or
                  ( RESULT = 'USERNG' )
                ) 
            AND PID not in (
                             select sample_barcode
                               from imcn_sample            
                           );
          
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              lvi_check_result_count := 0;
      END;
      
      IF NVL (lvi_ng_count, 0) > 1 THEN
                  
      --------------------------------------------------------
      --  NG 1회 이상 발생 확인
      --------------------------------------------------------   
      
         p_result     := 'NG';
         p_message    := 'AOI_NG_COUNT_CHECK';
         p_ng_message := f_msg('AOI 검사 이상 발생','C',1) || ' : NG '|| to_char( NVL(lvi_ng_count, 0)) || '회 발생';
       --  p_ng_message := f_msg('AOI 검사 이상 발생, PID 에 1회 이상 NG 발생','C',1); 
         p_ok_message := '';  
                               
         /*********************************************************************/
           P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                    p_machine_code,
                                    p_serial_no,
                                    sysdate,
                                    p_ng_message,
                                    p_workstage_code,
                                    p_result,     --Return
                                    p_type);
        /********************************************************************/    
              
      ELSE
        
         p_result     := 'OK';
         p_message    := 'AOI_NG_COUNT_CHECK';
         p_ng_message := '';
         p_ok_message := f_msg('AOI 불량 카운터(1회이상) 이상없음','C',1);         
                     
      END IF;
      
      RETURN;
      
   END IF;
   -----------------------------------------------------------
   -- 메탈마스크 상태 체크
   -----------------------------------------------------------

   IF p_type = 'JIG_METALMAKS_STATUS_CHECK' THEN                     --CHECK_COUNT
   
 
      BEGIN
        
         SELECT jig_model_name,
                jig_type,
                jig_code,
                NVL (break_value, 0),
                NVL (hit_value, 0),
                NVL (issue_date, SYSDATE),
                NVL (last_inspect_date, SYSDATE),
                TENSION_CHECK_YN,
                nvl(jig_status,'*'),
                nvl(use_status,'*')
           INTO lvs_jig_model_name,
                lvs_jig_type,
                lvs_jig_code,
                lvl_break_value,
                lvl_hit_value,
                lvdt_issue_date,
                lvdt_last_inspect_date,
                LVS_TENSION_CHECK_YN,
                lvs_jig_status,
                lvs_use_status
           FROM imcn_jig
          WHERE line_code = p_line_code
            AND jig_type = 'M'
            AND ROWNUM = 1;
                
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
           
            p_result     := 'NG';
            p_message    := 'JIG_METALMAKS_STATUS_CHECK'; 
            p_ng_message := f_msg('메탈마스크 장착정보 없음','C',1);
            p_ok_message := '';
           

            /*********************************************************************/
            P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                     p_machine_code,
                                     p_serial_no,
                                     sysdate,
                                     p_ng_message,
                                     p_workstage_code,
                                     p_result,     --Return
                                     p_type);

            /********************************************************************/
            
            RETURN;

         WHEN OTHERS THEN
           
            p_result     := 'NG';
            p_message    := 'JIG_METALMAKS_STATUS_CHECK';
            p_ng_message := f_msg('마스크 정보 체크시 DB ERROR','C',1);
            p_ok_message := '';
            
            /*********************************************************************/
            P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                     p_machine_code,
                                     p_serial_no,
                                     sysdate,
                                     p_ng_message,
                                     p_workstage_code,
                                     p_result,     --Return
                                     p_type);

            /********************************************************************/
            
            RETURN;
            
      END;
            
      -----------------------------------------------------------
      -- 수명 관리
      -----------------------------------------------------------
      IF NVL (lvl_break_value, 0) > NVL (lvl_hit_value, 0) THEN
         
         IF ( lvs_jig_status <> 'Z' or lvs_use_status <> 'U') THEN
           
             p_result     := 'NG';
             p_message    := 'JIG_METALMAKS_STATUS_CHECK';
             p_ok_message := '';
             p_ng_message := f_msg('마스크 상태 이상','C',1)||' => '||lvs_jig_status||', '||lvs_use_status;

             --*******************************************************************
              P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                       p_machine_code,
                                       p_serial_no,
                                       sysdate,
                                       p_ng_message,
                                       p_workstage_code,
                                       p_result,     --Return
                                       p_type);

             --******************************************************************
                  
         ELSE
           
             p_result     := 'OK';
             p_message    := 'JIG_METALMAKS_STATUS_CHECK';
             p_ng_message := 'OK';
             p_ok_message := f_msg('마스크 상태 체크 OK','C',1);
                  
         END IF;
             
      ELSE
            
         p_result     := 'NG';
         p_message    := 'JIG_METALMAKS_STATUS_CHECK';
         p_ok_message := '';
         p_ng_message := f_msg('유효수명 초과','C',1)||' => '||lvl_hit_value;

         --*******************************************************************
          P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                   p_machine_code,
                                   p_serial_no,
                                   sysdate,
                                   p_ng_message,
                                   p_workstage_code,
                                   p_result,     --Return
                                   p_type);

         --******************************************************************
              
      END IF;

      RETURN;
      
   END IF;

   -------------------------------------------------------------------------------------------
   -- SQUEZE STATUS CHECK
   -------------------------------------------------------------------------------------------

   IF p_type = 'JIG_SQUEEZE_STATUS_CHECK' THEN                       --CHECK_COUNT
  
         SELECT count(*)
           INTO lvl_count
           FROM imcn_jig
          WHERE line_code = p_line_code 
            AND jig_type  = 'S';        
      
      IF ( lvl_count <> 2 ) THEN
        
            p_result     := 'NG';
            p_message    := 'JIG_SQUEEZE_STATUS_CHECK';
            p_ok_message := '';
            p_ng_message := f_msg('장착된 스퀴즈가 2개가 아닙니다, 확인 바랍니다','C',1);

            /*********************************************************************/
            P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                     p_machine_code,
                                     p_serial_no,
                                     sysdate,
                                     p_ng_message,
                                     p_workstage_code,
                                     p_result,     --Return
                                     p_type);

            /********************************************************************/
            
            RETURN;
            
      END IF;
        
      -- JIG 가 2개가 장착되어야 하기에 수명과 상태를 한번 더 수행한다    
      
      -- *****************************
      -- 1번째 SEQUUZE
      -- *****************************       
            
      BEGIN
        
         SELECT jig_model_name,
                jig_type,
                jig_code,
                break_value,
                hit_value,
                solder_type,
                nvl(jig_status,'*'),
                nvl(use_status,'*')
           INTO lvs_jig_model_name,
                lvs_jig_type,
                lvs_jig_code,
                lvl_break_value,
                lvl_hit_value,
                lvs_solder_type,
                lvs_jig_status,
                lvs_use_status
           FROM imcn_jig
          WHERE line_code = p_line_code 
            AND jig_type = 'S' 
            AND ROWNUM = 1;
          
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
           
            p_result     := 'NG';
            p_message    := 'JIG_SQUEEZE_STATUS_CHECK';
            p_ok_message := '';
            p_ng_message := f_msg('스퀴즈 장착정보 없음','C',1);

            /*********************************************************************/
            P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                     p_machine_code,
                                     p_serial_no,
                                     sysdate,
                                     p_ng_message,
                                     p_workstage_code,
                                     p_result,     --Return
                                     p_type);

            /********************************************************************/
            
            RETURN;
            
      END;

      IF NVL (lvl_break_value, 0) > NVL (lvl_hit_value, 0) THEN
               
         IF ( lvs_jig_status <> 'Z' or lvs_use_status <> 'U') THEN
           
             p_result     := 'NG';
             p_message    := 'JIG_SQUEEZE_STATUS_CHECK';
             p_ok_message := '';
             p_ng_message := f_msg('첫번쨰 스퀴즈 상태 이상','C',1)||' => '||lvs_jig_status||', '||lvs_use_status;

             --*******************************************************************
              P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                       p_machine_code,
                                       p_serial_no,
                                       sysdate,
                                       p_ng_message,
                                       p_workstage_code,
                                       p_result,     --Return
                                       p_type);

             --******************************************************************
                  
         ELSE
           
             p_result     := 'OK';
             p_message    := 'JIG_SQUEEZE_STATUS_CHECK';
             p_ok_message := f_msg('스퀴즈정보 유효수명 OK.','C',1);
             p_ng_message := '';
                  
         END IF;         
         
      ELSE
        
         p_result     := 'NG';
         p_message    := 'JIG_SQUEZE_STATUS_CHECK';
         p_ok_message := '';
         p_ng_message := f_msg('첫번쨰 스퀴즈 유효수명 초과','C',1)||' => '||lvl_hit_value;
         
         /*********************************************************************/
          P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                   p_machine_code,
                                   p_serial_no,
                                   sysdate,
                                   p_ng_message,
                                   p_workstage_code,
                                   p_result,     --Return
                                   p_type);

          /********************************************************************/
          
      END IF;
      

      -- *****************************
      -- 2번째 SEQUUZE
      -- *****************************
      
      BEGIN
        
         SELECT jig_model_name,
                jig_type,
                jig_code,
                break_value,
                hit_value,
                solder_type,
                nvl(jig_status,'*'),
                nvl(use_status,'*')
           INTO lvs_jig_model_name,
                lvs_jig_type,
                lvs_jig_code,
                lvl_break_value,
                lvl_hit_value,
                lvs_solder_type,
                lvs_jig_status,
                lvs_use_status
           FROM imcn_jig
          WHERE line_code = p_line_code 
            AND jig_type  = 'S' 
            AND jig_code  <> lvs_jig_code
            AND ROWNUM = 1;
          
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
           
            p_result     := 'NG';
            p_message    := 'JIG_SQUEEZE_STATUS_CHECK';
            p_ok_message := '';
            p_ng_message := f_msg('두번째 스퀴즈 장착정보 없음','C',1);

            /*********************************************************************/
            P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                     p_machine_code,
                                     p_serial_no,
                                     sysdate,
                                     p_ng_message,
                                     p_workstage_code,
                                     p_result,     --Return
                                     p_type);

            /********************************************************************/
            
            RETURN;
            
      END;

      IF NVL (lvl_break_value, 0) > NVL (lvl_hit_value, 0) THEN
               
         IF ( lvs_jig_status <> 'Z' or lvs_use_status <> 'U') THEN
           
             p_result     := 'NG';
             p_message    := 'JIG_SQUEEZE_STATUS_CHECK';
             p_ok_message := '';
             p_ng_message := f_msg('두번째 스퀴즈 상태 이상','C',1)||' => '||lvs_jig_status||', '||lvs_use_status;

             --*******************************************************************
              P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                       p_machine_code,
                                       p_serial_no,
                                       sysdate,
                                       p_ng_message,
                                       p_workstage_code,
                                       p_result,     --Return
                                       p_type);

             --******************************************************************
                  
         ELSE
           
             p_result     := 'OK';
             p_message    := 'JIG_SQUEEZE_STATUS_CHECK';
             p_ok_message := f_msg('스퀴즈정보 유효수명 OK.','C',1);
             p_ng_message := '';
                  
         END IF;         
         
      ELSE
        
         p_result     := 'NG';
         p_message    := 'JIG_SQUEZE_STATUS_CHECK';
         p_ok_message := '';
         p_ng_message := f_msg('두번째 스퀴즈 유효수명 초과','C',1)||' => '||lvl_hit_value;
         
         /*********************************************************************/
          P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                   p_machine_code,
                                   p_serial_no,
                                   sysdate,
                                   p_ng_message,
                                   p_workstage_code,
                                   p_result,     --Return
                                   p_type);

          /********************************************************************/
          
      END IF;

      RETURN;
      
   END IF;

   ----------------------------------------------------------------------------------
   -- FIXTURE STATUS CHECK
   -------------------------------------------------------------------------------------------
   IF p_type = 'JIG_FIXTURE_STATUS_CHECK' THEN
     
      BEGIN
        
         SELECT jig_model_name,
                jig_type,
                jig_code,
                NVL (break_value, 0),
                NVL (hit_value, 0),
                nvl(jig_status,'*'),
                nvl(use_status,'*')
           INTO lvs_jig_model_name,
                lvs_jig_type,
                lvs_jig_code,
                lvl_break_value,
                lvl_hit_value,
                lvs_jig_status,
                lvs_use_status
           FROM imcn_jig
          WHERE line_code = p_line_code 
            AND jig_type  = 'T' 
            AND ROWNUM    = 1;
          
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
           
            p_result     := 'NG';
            p_message    := 'JIG_FIXTURE_STATUS_CHECK';
            p_ng_message := f_msg('픽스쳐 투입정보 없음','C',1);
            p_ok_message := '';
            
            /*********************************************************************/
            P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                     p_machine_code,
                                     p_serial_no,
                                     sysdate,
                                     p_ng_message,
                                     p_workstage_code,
                                     p_result,     --Return
                                     p_type);

            /********************************************************************/
            
            RETURN;
            
      END;

      IF lvl_break_value > lvl_hit_value THEN
         
         IF ( lvs_jig_status <> 'Z' or lvs_use_status <> 'U') THEN
           
             p_result     := 'NG';
             p_message    := 'JIG_FIXTURE_STATUS_CHECK';
             p_ok_message := '';
             p_ng_message := f_msg('픽스쳐 상태 이상','C',1)||' => '||lvs_jig_status||', '||lvs_use_status;

             --*******************************************************************
              P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                       p_machine_code,
                                       p_serial_no,
                                       sysdate,
                                       p_ng_message,
                                       p_workstage_code,
                                       p_result,     --Return
                                       p_type);

             --******************************************************************
                  
         ELSE
           
             p_result     := 'OK';
             p_message    := 'JIG_FIXTURE_STATUS_CHECK';
             p_ng_message := '';
             p_ok_message := f_msg('픽스쳐 유효수명 정상.','C',1);
                  
         END IF;           
         
      ELSE
        
         p_result     := 'NG';
         p_message    := 'JIG_FIXTURE_STATUS_CHECK';
         p_ng_message := f_msg('픽스쳐 유효수명 초과','C',1)||' => '||lvl_hit_value;
         p_ok_message := '';
         
         /*********************************************************************/
          P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                   p_machine_code,
                                   p_serial_no,
                                   sysdate,
                                   p_ng_message,
                                   p_workstage_code,
                                   p_result,     --Return
                                   p_type);

          /********************************************************************/
          
      END IF;

      RETURN;
      
    END IF;
    
   ----------------------------------------------------------------------------------------------------------------------------------------------------
   -- 양불마스타 투입이력 체크 
   ----------------------------------------------------------------------------------------------------------------------------------------------------
   IF ( p_type = 'SAMPLE_INPUT_CHECK' ) THEN
       
        BEGIN
        
           lvl_count := 0;
      
            SELECT count(*)
              INTO lvl_count
              FROM IMCN_SAMPLE
             WHERE SAMPLE_BARCODE LIKE regexp_substr(p_serial_no,'[^-]+',1,1)||'%'   
               AND SAMPLE_TYPE = 'S';
            
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 lvl_count := 0;
        END;

      --------------------------------------------------------
      -- 양불마스타 바코드 인지 확인
      --------------------------------------------------------
       IF ( lvl_count < 1 ) THEN
   
            BEGIN
             
               lvl_count := 0;
            
               SELECT DECODE(SAMPLE_LOT_NO,NULL,0,1) + DECODE(SAMPLE_LOT_NO2,NULL,0,1) -- 2:OK
                 INTO lvl_count
                 FROM IP_PRODUCT_LINE
                WHERE LINE_CODE = p_line_code;
            
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                     lvl_count := 0;
             END;
      
      --------------------------------------------------------
      -- 양불마스타 바코드 인지 확인
      --------------------------------------------------------
             IF ( lvl_count = 2 ) THEN
             
                  BEGIN
             
                     lvl_count := 0;
            
                     SELECT COUNT(DISTINCT SAMPLE_SECTION)  -- 2: OK
                       INTO lvl_count 
                       FROM IMCN_SAMPLE_BCR_INPUT_HIST
                      WHERE LINE_CODE        = p_line_code
                        AND WORKSTAGE_CODE   = 'W060'
                        AND RUN_NO           = lvs_run_no
                        AND SAMPLE_TYPE      = 'S'
                        AND ( 
                             ( sample_section = 'G' AND inspect_result in ('OK','GOOD','PASS', 'USEROK', 'MasterOK') ) OR      -- 양품일경우 PASS 인경우 양품으로 본다, 2020-03-13 이승빈C
                             ( sample_section = 'B' AND inspect_result in ('NG', 'USERNG','MasterNG') )         
                            );                               
                               
                   EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                           lvl_count := 0;
                   END;
                   
                   IF ( lvl_count = 2 ) THEN
                     
                        p_result     := 'OK';
                        p_message    := 'SAMPLE_INPUT_CHECK';
                        p_ng_message := '';
                        p_ok_message := f_msg( '양불마스터 장착 및 투입이력 정상','C',1);    
                       
                   ELSE
                     
                        p_result     := 'NG';
                        p_message    := 'SAMPLE_INPUT_CHECK';
                        p_ng_message := f_msg('양불마스터 투입이력을 확인 하세요','C',1);
                        p_ok_message := '';
                    
                        /*********************************************************************/
                        P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                                 p_machine_code,
                                                 p_serial_no,
                                                 sysdate,
                                                 p_ng_message,
                                                 p_workstage_code,
                                                 p_result,     --Return
                                                 p_type);
   
                        /********************************************************************/                                 
                          
                   END IF;
             
             ELSE
             
                   p_result     := 'NG';
                   p_message    := 'SAMPLE_INPUT_CHECK';
                   p_ng_message := f_msg('양불마스터 장착이력을 확인 하세요','C',1);
                   p_ok_message := '';
                    
                   /*********************************************************************/
                   P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                            p_machine_code,
                                            p_serial_no,
                                            sysdate,
                                            p_ng_message,
                                            p_workstage_code,
                                            p_result,     --Return
                                            p_type);
   
                   /********************************************************************/                       
           
             END IF;

      ELSE
        
         p_result     := 'OK';
         p_message    := 'SAMPLE_INPUT_CHECK';
         p_ng_message := '';
         p_ok_message := f_msg( '양불 마스터 입니다 - SKIP','C',1);    
                                    
      END IF;

      RETURN;
      
   END IF;    
   
   ----------------------------------------------------------------------------------------------------------------------------------------------------
   -- Profile check
   ----------------------------------------------------------------------------------------------------------------------------------------------------
   IF ( p_type = 'LINE_PROFILE_CHECK' ) THEN
       
             BEGIN
             
               lvl_count := 0;
            
               SELECT count(*)
                 INTO lvl_count
                 FROM IP_PRODUCT_LINE
                WHERE LINE_CODE = p_line_code
                  AND SPEC_CHECK_DATE IS NULL
                  AND TO_NUMBER(TO_CHAR(sysdate,'HH24MISS')) > 123000;
            
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                     lvl_count := 0;
             END;
      

             IF ( lvl_count > 0) THEN
                                       
                        p_result     := 'NG';
                        p_message    := 'LINE_PROFILE_CHECK';
                        p_ng_message := f_msg('Profile을 확인 하세요','C',1);
                        p_ok_message := '';
                    
                        /*********************************************************************/
                        P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                                 p_machine_code,
                                                 p_serial_no,
                                                 sysdate,
                                                 p_ng_message,
                                                 p_workstage_code,
                                                 p_result,     --Return
                                                 p_type);
   
                        /********************************************************************/       
                        
            ELSE
              
                        p_result     := 'OK';
                        p_message    := 'LINE_PROFILE_CHECK';
                        p_ng_message := '';
                        p_ok_message := f_msg( 'Profile Check 정상','C',1);                                                                  
                                     
            END IF;           

      RETURN;
      
   END IF; 
   
   
   ----------------------------------------------------------------------------------------------------------------------------------------------------
   -- Nozzle check
   ----------------------------------------------------------------------------------------------------------------------------------------------------
   IF ( p_type = 'LINE_NOZZLE_CHECK' ) THEN
       
             BEGIN
             
               lvl_count := 0;
            
               SELECT count(*)
                 INTO lvl_count
                 FROM IP_PRODUCT_LINE
                WHERE LINE_CODE = p_line_code
                  AND NOZZLE_CHECK_DATE IS NULL
              --    AND TO_NUMBER(TO_CHAR(sysdate,'HH24MISS')) > 123000
                ;
            
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                     lvl_count := 0;
             END;
      

             IF ( lvl_count > 0) THEN
                                       
                        p_result     := 'NG';
                        p_message    := 'LINE_NOZZLE_CHECK';
                        p_ng_message := f_msg('Nozzle 을 확인 하세요','C',1);
                        p_ok_message := '';
                    
                        /*********************************************************************/
                        P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                                 p_machine_code,
                                                 p_serial_no,
                                                 sysdate,
                                                 p_ng_message,
                                                 p_workstage_code,
                                                 p_result,     --Return
                                                 p_type);
   
                        /********************************************************************/       
                        
            ELSE
              
                        p_result     := 'OK';
                        p_message    := 'LINE_NOZZLE_CHECK';
                        p_ng_message := '';
                        p_ok_message := f_msg( 'Nozzle Check 정상','C',1);                                                                  
                                     
            END IF;           

      RETURN;
      
   END IF; 
      
  --------------------------------------------------
  -- 최근 20 분 이네 리플로우 데이터 로그 올라오는지 체크
  -- ADD BY YHS 20220524
  -- SPI 또는 AOI 공정에서 인터락 조건 걸것.
  --------------------------------------------------
  IF p_type = 'REFLOW_STATUS_CHECK' THEN
    
     BEGIN 
         SELECT COUNT(*) 
          INTO lvi_count 
          FROM IQ_MACHINE_INSPECT_DATA_REFLOW
         WHERE LINE_CODE = P_LINE_CODE 
           AND TO_DATE( MEASURE_DATE , 'YYYY/MM/DD HH24:MI:SS') >=  SYSDATE - 20 / 24 / 60 ;
           
     EXCEPTION WHEN NO_DATA_FOUND THEN
         lvi_count := 0 ;
     END ;
     
     IF lvi_count = 0 THEN 
      
            p_result     := 'NG';
            p_message    := 'REFLOW_STATUS_CHECK';
            p_ng_message := f_msg('리플러 로그 이상','C',1)||' : '||P_LINE_CODE;
            p_ok_message := '';
         
         /*********************************************************************/
          P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                   p_machine_code,
                                   p_serial_no,
                                   sysdate,
                                   p_ng_message,     --Comment
                                   p_workstage_code,
                                   p_result,         --Return
                                   p_type);

          /********************************************************************/
                    
      ELSE
        
          p_result     := 'OK';
          p_message    := 'REFLOW_STATUS_CHECK';
          p_ng_message := '';
          p_ok_message := '';     

      END IF;
      
      RETURN;
      
  END IF ;
      
   --------------------------------------------------------------------------
   -- 최종값 reflow  확인
   --------------------------------------------------------------------------

   IF p_type = 'REFLOW_OXYGEN_CHECK' THEN
     
      -- 모델 장착된 라인에서 만 확인
      IF NVL(lvs_run_no,'*') = '*' THEN
        
          p_result     := 'OK';
          p_message    := 'REFLOW_OXYGEN_CHECK';
          p_ng_message := 'SKIP'; 
          p_ok_message := 'SKIP'; 
          
          RETURN;
                
      END IF;
      
      
      -- reflow 상하한선 조회
      begin
        
             select config_value
               into LVS_MIN_VALUE
               from ISYS_CONFIG     
              where config_name = 'REFLOW_OXGEN_MIN';
     
      EXCEPTION
         WHEN OTHERS THEN
              LVS_MIN_VALUE := '500';  -- PPM
      END;
      
      begin
        
             select config_value
               into LVS_MAX_VALUE
               from ISYS_CONFIG     
              where config_name = 'REFLOW_OXGEN_MAX';
     
      EXCEPTION
         WHEN OTHERS THEN
              LVS_MAX_VALUE := '2000'; -- PPM
      END;
              
     
      BEGIN
        
/* 
     select nvl(to_char(oxygen_concentration),'')
       into LVS_CUR_VALUE
       from IQ_MACHINE_INSPECT_DATA_REFLOW
      where measure_date = (
                          select max(measure_date)
                            from IQ_MACHINE_INSPECT_DATA_REFLOW
                           where line_code = p_line_code
                        )
        and line_code = p_line_code
        and rownum    = 1;
        
*/
        
        LVS_CUR_VALUE := NVL(p_serial_no, '0');
          
      EXCEPTION
         WHEN OTHERS THEN
              LVS_CUR_VALUE := '0';
      END;

      IF (to_number(LVS_MIN_VALUE) > to_number(LVS_CUR_VALUE)) or (to_number(LVS_MAX_VALUE) < to_number(LVS_CUR_VALUE))  THEN
        
            p_result     := 'NG';
            p_message    := 'REFLOW_OXYGEN_CHECK';
            p_ng_message := f_msg('리플러 산소농도 이상','C',1)||' : '||LVS_CUR_VALUE;
            p_ok_message := '';
         
         /*********************************************************************/
          P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                   p_machine_code,
                                   p_serial_no,
                                   sysdate,
                                   p_ng_message,     --Comment
                                   p_workstage_code,
                                   p_result,         --Return
                                   p_type);

          /********************************************************************/
                    
      ELSE
        
          p_result     := 'OK';
          p_message    := 'REFLOW_OXYGEN_CHECK';
          p_ng_message := '';
          p_ok_message := '';     

      END IF;
      
      RETURN;
 
   END IF;   
   
   --------------------------------------------------------------------------
   -- SPI 기준 mounter기에 장착된 릴자재 MSL 확인
   --------------------------------------------------------------------------

   IF p_type = 'LINE_MSL_CHECK' THEN
     
      -- 모델 장착된 라인에서 만 확인
      IF NVL(lvs_run_no,'*') = '*' or NVL(p_line_code,'*') = '*' THEN
        
          p_result     := 'OK';
          p_message    := 'LINE_MSL_CHECK';
          p_ng_message := 'SKIP'; 
          p_ok_message := 'SKIP'; 
          
          RETURN;
                
      END IF;
         
      -- 라인단위 MSL over 자재확인
      begin
        
             select count(*) ,
                    max(location_code)
               into lvl_count, 
                    lvs_location_code   
               from IM_ITEM_MSL_CHECK_VIEW
              where MSL_LEVEL >= '2'
                and line_code = p_line_code
                and passed_time / msl_max_time > 0.99;
     
      EXCEPTION
         WHEN OTHERS THEN
              lvl_count := 0;
      END;
 
      IF (lvl_count > 0)  THEN
        
            -- MSL over 자재정보 구하기
            begin
                               
                   select count(*), 
                          max(line_code|| ', ' ||location_code||', '||item_barcode||' => MSL 99% Over')  
                     into lvl_count, 
                          lvs_check_result   
                     from IM_ITEM_MSL_CHECK_VIEW
                    where line_code     = p_line_code
                      and location_code = lvs_location_code;
           
            EXCEPTION
               WHEN OTHERS THEN
                    lvl_count := 0;
            END;      
        
            if ( lvl_count > 0 ) THEN
              
                  p_result     := 'NG';
                  p_message    := 'LINE_MSL_CHECK';
                  p_ng_message := lvs_check_result;
                  p_ok_message := '';
               
               /*********************************************************************/
                P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                         p_machine_code,
                                         p_serial_no,
                                         sysdate,
                                         p_ng_message,     --Comment
                                         p_workstage_code,
                                         p_result,         --Return
                                         p_type);

                /********************************************************************/
          
            else
                    
                p_result     := 'OK';
                p_message    := 'LINE_MSL_CHECK';
                p_ng_message := 'SKIP'; 
                p_ok_message := 'SKIP';              
                        
            end if;
                    
      ELSE
        
          p_result     := 'OK';
          p_message    := 'LINE_MSL_CHECK';
          p_ng_message := '';
          p_ok_message := '';     

      END IF;
      
      RETURN;
 
   END IF;      
   
   --------------------------------------------------------------------------
   -- 외관검사 NG이후 수리여부 확인
   --------------------------------------------------------------------------

   IF p_type = 'VISUAL_NG_REPAIR' THEN
         
      -- 공정품질검사 이력 확인
      begin
        
             select max(inspect_date) , count(*)      
               into lvdt_max_ng_date, lvl_count
               from iq_product_wqc    
              where serial_no       =  p_serial_no  
                and bad_reason_code = 'NG' ;          -- 불량
     
      EXCEPTION
         WHEN OTHERS THEN
              lvl_count := 0;
      END;
 
      IF (lvl_count > 0)  THEN
        
            -- 불량 수리이력 확인
            begin
                               
                  select count(*)     
                    into lvl_count   
                    from ip_product_work_qc
                   where serial_no          = p_serial_no
                     and receipt_deficit    = '2'          -- 출고
                     and repair_result_code = 'G'          -- 수리완료
                     and qc_date = (
                                      select max(qc_date)
                                        from ip_product_work_qc
                                       where serial_no = p_serial_no
                                         and qc_date   > lvdt_max_ng_date
                                   );
           
            EXCEPTION
               WHEN OTHERS THEN
                    lvl_count := 0;
            END;      
        
            if ( lvl_count = 0 ) THEN
              
                  p_result     := 'NG';
                  p_message    := 'VISUAL_NG_REPAIR';
                  p_ng_message := '외관검사 NG이후 수리공정에 수리완료 출고이력이 없습니다';
                  p_ok_message := '';
               
               /*********************************************************************/
                P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                         p_machine_code,
                                         p_serial_no,
                                         sysdate,
                                         p_ng_message,     --Comment
                                         p_workstage_code,
                                         p_result,         --Return
                                         p_type);

                /********************************************************************/
          
            else
                    
                p_result     := 'OK';
                p_message    := 'VISUAL_NG_REPAIR';
                p_ng_message := '';
                p_ok_message := '';           
                        
            end if;
                    
      ELSE
        
          p_result     := 'OK';
          p_message    := 'VISUAL_NG_REPAIR';
          p_ng_message := '';
          p_ok_message := '';     

      END IF;
      
      RETURN;
 
   END IF;     
   
   --------------------------------------------------------------------------
   -- 외관검사 NG이후 수리여부 확인 ( TOP 인경우 BOT에 대해서도 확인 )
   --------------------------------------------------------------------------
      
   IF p_type = 'VISUAL_NG_REPAIR_TB' THEN
         
      -- 공정품질검사 이력 확인
      begin
        
             select max(inspect_date) , count(*)      
               into lvdt_max_ng_date, lvl_count
               from iq_product_wqc    
              where serial_no       =  p_serial_no  
                and bad_reason_code = 'NG' ;          -- 불량
     
      EXCEPTION
         WHEN OTHERS THEN
              lvl_count := 0;
      END;
 
      IF (lvl_count > 0)  THEN
        
            -- 불량 수리이력 확인
            begin
                               
                  select count(*)     
                    into lvl_count   
                    from ip_product_work_qc
                   where serial_no          = p_serial_no
                     and receipt_deficit    = '2'          -- 출고
                     and repair_result_code = 'G'          -- 수리완료
                     and qc_date = (
                                      select max(qc_date)
                                        from ip_product_work_qc
                                       where serial_no = p_serial_no
                                         and qc_date   > lvdt_max_ng_date
                                   );
           
            EXCEPTION
               WHEN OTHERS THEN
                    lvl_count := 0;
            END;      
        
            if ( lvl_count = 0 ) THEN
              
                  p_result     := 'NG';
                  p_message    := 'VISUAL_NG_REPAIR_TB';
                  p_ng_message := '외관검사 NG이후 수리공정에 수리완료 출고이력이 없습니다'||lvs_pcb_tb_suffix;
                  p_ok_message := '';
               
               /*********************************************************************/
                P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                         p_machine_code,
                                         p_serial_no,
                                         sysdate,
                                         p_ng_message,     --Comment
                                         p_workstage_code,
                                         p_result,         --Return
                                         p_type);

                /********************************************************************/
          
            else
                    
                p_result     := 'OK';
                p_message    := 'VISUAL_NG_REPAIR_TB';
                p_ng_message := '';
                p_ok_message := '';           
                        
            end if;
                    
      ELSE
        
          p_result     := 'OK';
          p_message    := 'VISUAL_NG_REPAIR_TB';
          p_ng_message := '';
          p_ok_message := '';     

      END IF;
      
   --------------------------------------------------------------------------
   --  TOP 에 대해 BOT CHECK 
   --------------------------------------------------------------------------
   
      IF ( p_result = 'OK' and substr(p_serial_no, -1) = 'T' and LVS_CARRIER_BARCODE_YN = 'Y') THEN
        
           LVS_BOT_BARCODE := substr(p_serial_no, 1, length(p_serial_no)-1)||'B';
           
           
            -- 공정품질검사 이력 확인
            begin
              
                   select max(inspect_date) , count(*)      
                     into lvdt_max_ng_date, lvl_count
                     from iq_product_wqc    
                    where serial_no       =  LVS_BOT_BARCODE  
                      and bad_reason_code = 'NG' ;          -- 불량
           
            EXCEPTION
               WHEN OTHERS THEN
                    lvl_count := 0;
            END;
       
            IF (lvl_count > 0)  THEN
              
                  -- 불량 수리이력 확인
                  begin
                                     
                        select count(*)     
                          into lvl_count   
                          from ip_product_work_qc
                         where serial_no          = LVS_BOT_BARCODE
                           and receipt_deficit    = '2'          -- 출고
                           and repair_result_code = 'G'          -- 수리완료
                           and qc_date = (
                                            select max(qc_date)
                                              from ip_product_work_qc
                                             where serial_no = LVS_BOT_BARCODE
                                               and qc_date   > lvdt_max_ng_date
                                         );
                 
                  EXCEPTION
                     WHEN OTHERS THEN
                          lvl_count := 0;
                  END;      
              
                  if ( lvl_count = 0 ) THEN
                    
                        p_result     := 'NG';
                        p_message    := 'VISUAL_NG_REPAIR_TB';
                        p_ng_message := '외관검사 NG이후 수리공정에 수리완료 출고이력이 없습니다'||'(BOT)';
                        p_ok_message := '';
                     
                     /*********************************************************************/
                      P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                               p_machine_code,
                                               p_serial_no,
                                               sysdate,
                                               p_ng_message,     --Comment
                                               p_workstage_code,
                                               p_result,         --Return
                                               p_type);

                      /********************************************************************/
                
                  else
                          
                      p_result     := 'OK';
                      p_message    := 'VISUAL_NG_REPAIR_TB';
                      p_ng_message := '';
                      p_ok_message := '';           
                              
                  end if;
                          
            ELSE
              
                p_result     := 'OK';
                p_message    := 'VISUAL_NG_REPAIR_TB';
                p_ng_message := '';
                p_ok_message := '';     

            END IF;
                            
      END IF;
      
      RETURN;
 
   END IF; 
   
   --------------------------------------------------------------------------
   -- 외관검사 NG이후 재검사여부 확인
   --------------------------------------------------------------------------   
   
   IF p_type = 'VISUAL_NG_RECHECK' THEN
         
      -- 공정품질검사 이력 확인
      begin
        
             select max(inspect_date) , count(*)      
               into lvdt_max_ng_date, lvl_count
               from iq_product_wqc    
              where serial_no       =  p_serial_no  
                and bad_reason_code = 'NG' ;          -- 불량
     
      EXCEPTION
         WHEN OTHERS THEN
              lvl_count := 0;
      END;
 
      IF (lvl_count > 0)  THEN
        
            -- AOI 검사 확인
            begin
                               
                  select count(*)
                    into lvl_count
                    from iq_machine_inspect_data_aoi
                   where pid           = p_serial_no
                     and result        = 'OK'
                     and inspect_date  = (
                                            select max(inspect_date)
                                              from iq_machine_inspect_data_aoi    
                                             where pid   = p_serial_no
                                               and inspect_date > to_char(lvdt_max_ng_date, 'YYYY/MM/DD HH24:MI:SS')
                                         );
           
            EXCEPTION
               WHEN OTHERS THEN
                    lvl_count := 0;
            END;      
        
            if ( lvl_count = 0 ) THEN
              
                  p_result     := 'NG';
                  p_message    := 'VISUAL_NG_RECHECK';
                  p_ng_message := '외관검사 NG 이후 AOI 검사이력이 없습니다';
                  p_ok_message := '';
               
               /*********************************************************************/
                P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                         p_machine_code,
                                         p_serial_no,
                                         sysdate,
                                         p_ng_message,     --Comment
                                         p_workstage_code,
                                         p_result,         --Return
                                         p_type);

                /********************************************************************/
          
            else
                    

                 -- 재 검사 확인
                  begin
                               
                          select count(*)    
                            into lvl_count        
                            from iq_product_wqc    
                           where serial_no       = p_serial_no
                             and bad_reason_code = 'OK'    
                             and inspect_date = (
                                                   select max(inspect_date)
                                                     from iq_product_wqc    
                                                    where serial_no    = p_serial_no
                                                      and inspect_date > lvdt_max_ng_date
                                                );
                 
                  EXCEPTION
                     WHEN OTHERS THEN
                          lvl_count := 0;
                  END; 
                              
                  if ( lvl_count = 0 ) THEN
              
                        p_result     := 'NG';
                        p_message    := 'VISUAL_NG_RECHECK';
                        p_ng_message := '외관검사 NG 이후 외관검사 OK 이력이 없습니다';
                        p_ok_message := '';
                     
                     /*********************************************************************/
                      P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                               p_machine_code,
                                               p_serial_no,
                                               sysdate,
                                               p_ng_message,     --Comment
                                               p_workstage_code,
                                               p_result,         --Return
                                               p_type);

                      /********************************************************************/
                      
                  else
                    
                      p_result     := 'OK';
                      p_message    := 'VISUAL_NG_RECHECK';
                      p_ng_message := '';
                      p_ok_message := '';      
                      
                  end if;     
                        
            end if;
                    
      ELSE
        
          p_result     := 'OK';
          p_message    := 'VISUAL_NG_RECHECK';
          p_ng_message := '';
          p_ok_message := '';     

      END IF;
      
      RETURN;
 
   END IF;   
   
   --------------------------------------------------------------------------
   -- 외관검사 NG이후 재검사여부 확인 ( TOP 인경우 BOT에 대해서도 확인 )
   --------------------------------------------------------------------------   
   
   IF p_type = 'VISUAL_NG_RECHECK_TB' THEN
         
      -- 공정품질검사 이력 확인
      begin
        
             select max(inspect_date) , count(*)      
               into lvdt_max_ng_date, lvl_count
               from iq_product_wqc    
              where serial_no       =  p_serial_no  
                and bad_reason_code = 'NG' ;          -- 불량
     
      EXCEPTION
         WHEN OTHERS THEN
              lvl_count := 0;
      END;
 
      IF (lvl_count > 0)  THEN
        
            -- AOI 검사 확인
            begin
                               
                  select count(*)
                    into lvl_count
                    from iq_machine_inspect_data_aoi
                   where pid           = p_serial_no
                     and result        = 'OK'
                     and inspect_date  = (
                                            select max(inspect_date)
                                              from iq_machine_inspect_data_aoi    
                                             where pid   = p_serial_no
                                               and inspect_date > to_char(lvdt_max_ng_date, 'YYYY/MM/DD HH24:MI:SS')
                                         );
           
            EXCEPTION
               WHEN OTHERS THEN
                    lvl_count := 0;
            END;      
        
            if ( lvl_count = 0 ) THEN
              
                  p_result     := 'NG';
                  p_message    := 'VISUAL_NG_RECHECK_TB';
                  p_ng_message := '외관검사 NG 이후 AOI 검사이력이 없습니다'||lvs_pcb_tb_suffix;
                  p_ok_message := '';
               
               /*********************************************************************/
                P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                         p_machine_code,
                                         p_serial_no,
                                         sysdate,
                                         p_ng_message,     --Comment
                                         p_workstage_code,
                                         p_result,         --Return
                                         p_type);

                /********************************************************************/
          
            else
                    

                 -- 재 검사 확인
                  begin
                               
                          select count(*)    
                            into lvl_count        
                            from iq_product_wqc    
                           where serial_no       = p_serial_no
                             and bad_reason_code = 'OK'    
                             and inspect_date = (
                                                   select max(inspect_date)
                                                     from iq_product_wqc    
                                                    where serial_no    = p_serial_no
                                                      and inspect_date > lvdt_max_ng_date
                                                );
                 
                  EXCEPTION
                     WHEN OTHERS THEN
                          lvl_count := 0;
                  END; 
                              
                  if ( lvl_count = 0 ) THEN
              
                        p_result     := 'NG';
                        p_message    := 'VISUAL_NG_RECHECK_TB';
                        p_ng_message := '외관검사 NG 이후 외관검사 OK 이력이 없습니다'||lvs_pcb_tb_suffix;
                        p_ok_message := '';
                     
                     /*********************************************************************/
                      P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                               p_machine_code,
                                               p_serial_no,
                                               sysdate,
                                               p_ng_message,     --Comment
                                               p_workstage_code,
                                               p_result,         --Return
                                               p_type);

                      /********************************************************************/
                      
                  else
                    
                      p_result     := 'OK';
                      p_message    := 'VISUAL_NG_RECHECK_TB';
                      p_ng_message := '';
                      p_ok_message := '';      
                      
                  end if;     
                        
            end if;
                    
      ELSE
        
          p_result     := 'OK';
          p_message    := 'VISUAL_NG_RECHECK_TB';
          p_ng_message := '';
          p_ok_message := '';     

      END IF;
      
   --------------------------------------------------------------------------
   --  TOP 에 대해 BOT CHECK 
   --------------------------------------------------------------------------
   
      IF ( p_result = 'OK' and substr(p_serial_no, -1) = 'T' and LVS_CARRIER_BARCODE_YN = 'Y') THEN
        
           LVS_BOT_BARCODE := substr(p_serial_no, 1, length(p_serial_no)-1)||'B';
                      
            -- 공정품질검사 이력 확인
            begin
              
                   select max(inspect_date) , count(*)      
                     into lvdt_max_ng_date, lvl_count
                     from iq_product_wqc    
                    where serial_no       =  LVS_BOT_BARCODE  
                      and bad_reason_code = 'NG' ;          -- 불량
           
            EXCEPTION
               WHEN OTHERS THEN
                    lvl_count := 0;
            END;
       
            IF (lvl_count > 0)  THEN
              
                  -- AOI 검사 확인
                  begin
                                     
                        select count(*)
                          into lvl_count
                          from iq_machine_inspect_data_aoi
                         where pid           = LVS_BOT_BARCODE
                           and result        = 'OK'
                           and inspect_date  = (
                                                  select max(inspect_date)
                                                    from iq_machine_inspect_data_aoi    
                                                   where pid   = LVS_BOT_BARCODE
                                                     and inspect_date > to_char(lvdt_max_ng_date, 'YYYY/MM/DD HH24:MI:SS')
                                               );
                 
                  EXCEPTION
                     WHEN OTHERS THEN
                          lvl_count := 0;
                  END;      
              
                  if ( lvl_count = 0 ) THEN
                    
                        p_result     := 'NG';
                        p_message    := 'VISUAL_NG_RECHECK_TB';
                        p_ng_message := '외관검사 NG 이후 AOI 검사이력이 없습니다'||'(BOT)';
                        p_ok_message := '';
                     
                     /*********************************************************************/
                      P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                               p_machine_code,
                                               p_serial_no,
                                               sysdate,
                                               p_ng_message,     --Comment
                                               p_workstage_code,
                                               p_result,         --Return
                                               p_type);

                      /********************************************************************/
                
                  else
                          

                       -- 재 검사 확인
                        begin
                                     
                                select count(*)    
                                  into lvl_count        
                                  from iq_product_wqc    
                                 where serial_no       = LVS_BOT_BARCODE
                                   and bad_reason_code = 'OK'    
                                   and inspect_date = (
                                                         select max(inspect_date)
                                                           from iq_product_wqc    
                                                          where serial_no    = LVS_BOT_BARCODE
                                                            and inspect_date > lvdt_max_ng_date
                                                      );
                       
                        EXCEPTION
                           WHEN OTHERS THEN
                                lvl_count := 0;
                        END; 
                                    
                        if ( lvl_count = 0 ) THEN
                    
                              p_result     := 'NG';
                              p_message    := 'VISUAL_NG_RECHECK_TB';
                              p_ng_message := '외관검사 NG 이후 외관검사 OK 이력이 없습니다'||'(BOT)';
                              p_ok_message := '';
                           
                           /*********************************************************************/
                            P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                                     p_machine_code,
                                                     p_serial_no,
                                                     sysdate,
                                                     p_ng_message,     --Comment
                                                     p_workstage_code,
                                                     p_result,         --Return
                                                     p_type);

                            /********************************************************************/
                            
                        else
                          
                            p_result     := 'OK';
                            p_message    := 'VISUAL_NG_RECHECK_TB';
                            p_ng_message := '';
                            p_ok_message := '';      
                            
                        end if;     
                              
                  end if;
                          
            ELSE
              
                p_result     := 'OK';
                p_message    := 'VISUAL_NG_RECHECK_TB';
                p_ng_message := '';
                p_ok_message := '';     

            END IF;                 
           
      END IF;      
      
      RETURN;
 
   END IF;      
   
   --------------------------------------------------------------------------
   -- PCB 투입수량 대비 마킹수량 확인
   --------------------------------------------------------------------------   
   
   IF p_type = 'PCB_INPUT_QTY_CHECK' THEN
     
     
      BEGIN
        
            -- 마킨수량, PCB 투입수량 확인
             
            SELECT F_GET_RUN_LINE_INPUT_QTY(PL.RUN_NO,  PL.LINE_CODE, PL.ORGANIZATION_ID)  AS LOT_INPUT_QTY,
                   (
                     SELECT NVL(SUM( LOT_QTY),0) 
                       FROM IP_PRODUCT_PCB_SCAN_MASTER
                      WHERE RUN_NO    = PL.RUN_NO
                      --  AND LINE_CODE = PL.LINE_CODE
                  ) AS PCB_INPUT_QTY,
                  (
                    SELECT NVL(PCB_ITEM, '*')
                      FROM IP_PRODUCT_RUN_CARD
                     WHERE RUN_NO = PL.RUN_NO
                  ) AS PCB_ITEM
             INTO lvl_lot_input_qty, lvl_pcb_input_qty, LVS_PCB_ITEM
             FROM IP_PRODUCT_2D_BARCODE   PL
            WHERE SERIAL_NO = p_serial_no;

      EXCEPTION
  
            WHEN OTHERS THEN
         
                 LVS_PCB_ITEM := '*';
                 lvl_lot_input_qty := 0;
                 lvl_pcb_input_qty := 0;
         
      END;    
      
      -- 양면 PCB 사용이 BOT, 단면경우 TOP 에서 확인 
      
      IF ( (LVS_CARRIER_BARCODE_YN = 'Y' AND  LVS_PCB_ITEM = 'B') or (LVS_CARRIER_BARCODE_YN = 'N' AND  LVS_PCB_ITEM = 'T') ) THEN
        
          IF ( lvl_pcb_input_qty >= lvl_lot_input_qty ) THEN
            
                p_result     := 'OK';
                p_message    := 'PCB_INPUT_QTY_CHECK';
                p_ng_message := '';
                p_ok_message := '';   
                          
          ELSE
            
                p_result     := 'NG';
                p_message    := 'PCB_INPUT_QTY_CHECK';
                p_ng_message := '마킹수량 대비 PCB 투입수량 부족';
                p_ok_message := '';  
                          
                           
               /*********************************************************************/
                P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                         p_machine_code,
                                         p_serial_no,
                                         sysdate,
                                         p_ng_message,     --Comment
                                         p_workstage_code,
                                         p_result,         --Return
                                         p_type);

                /********************************************************************/
                                            
          END IF; 
           
      ELSE
        
          p_result     := 'OK';
          p_message    := 'PCB_INPUT_QTY_CHECK';
          p_ng_message := '';
          p_ok_message := 'SKIP';         
            
      END IF;
      
      RETURN;
  
 
   END IF;         
         
   --------------------------------------------------------------------------
   -- 마운터기 장착수량 대비 실적수량 확인
   --------------------------------------------------------------------------   
   
   IF p_type = 'MOUNTER_FEEDING_QTY_CHECK' THEN
     
     
      BEGIN
        
            -- 마킨수량, PCB 투입수량 확인
             
            select sum(1) ng_count, min( location_code||' : '||item_code) location_info
              into lvl_count, lvs_data
              from IB_PRODUCT_PLANDATA
             where line_code = p_line_code
               and active_yn = 'Y'
               and feeding_qty - product_actual_qty < 0;

      EXCEPTION
  
            WHEN OTHERS THEN
         
                 lvl_count := -1;
         
      END;    
      
      -- 양면 PCB 사용이 BOT, 단면경우 TOP 에서 확인 
      
      IF ( lvl_count = -1 ) THEN
        
          IF ( lvl_count = 0 ) THEN
            
                p_result     := 'OK';
                p_message    := 'MOUNTER_FEEDING_QTY_CHECK';
                p_ng_message := '';
                p_ok_message := '';   
                          
          ELSE
            
                p_result     := 'NG';
                p_message    := 'MOUNTER_FEEDING_QTY_CHECK';
                p_ng_message := '마운터기 실적수량 대비 장착수량 부족' || '(' || lvs_data ||')';
                p_ok_message := '';  
                          
                           
               /*********************************************************************/
                P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                         p_machine_code,
                                         p_serial_no,
                                         sysdate,
                                         p_ng_message,     --Comment
                                         p_workstage_code,
                                         p_result,         --Return
                                         p_type);

                /********************************************************************/
                                            
          END IF; 
           
      ELSE
        
          p_result     := 'OK';
          p_message    := 'MOUNTER_FEEDING_QTY_CHECK';
          p_ng_message := '';
          p_ok_message := 'SKIP';         
            
      END IF;
      
      RETURN;
  
 
   END IF;       
   
   --------------------------------------------------------------------------
   -- BACKUPBLOCK CEHCK
   --------------------------------------------------------------------------   
   
   IF p_type = 'BACKUPBLOCK_CHECK' THEN
     
     
      BEGIN
        
            -- Model Division 과 백업블럭 장착확인
             
            select count(*), NVL(F_GET_MODEL_DIVISTION( model_name, organization_id), '*'), backupblock_check_date
              into lvl_count, lvs_model_division, lvdt_backupblock_check_date
              from IP_PRODUCT_LINE
             where line_code = p_line_code;

      EXCEPTION
  
            WHEN OTHERS THEN
         
                 lvl_count := 0;
         
      END;    
      
       IF ( lvl_count > 0) THEN
         
             
                -- MODEL_DIVISION = 'D' and  PCB_ITEM = 'T' 이면 백업블럭을 장착해야 한다
      
 
                IF ( lvs_model_division = 'D' ) THEN
                  
                     BEGIN
                        
                         select pcb_item
                           into LVS_PCB_ITEM
                           from ip_product_run_card
                          where run_no = (
                                           select run_no
                                             from ip_product_2d_barcode
                                            where serial_no = ''
                                         );
                                     
                     EXCEPTION

  
                         WHEN OTHERS THEN
         
                              LVS_PCB_ITEM := '*';
         
                     END;                                        
                                     
                     IF ( LVS_PCB_ITEM = 'T') THEN
                       
                          IF ( lvdt_backupblock_check_date is null ) THEN
                            
                               p_result     := 'NG';
                               p_message    := 'BACKUPBLOCK_CHECK';
                               p_ng_message := '백업블럭을 장착하세요' || '(' || p_line_code ||')';
                               p_ok_message := '';  
                               
                               /*********************************************************************/

                               P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                                        p_machine_code,
                                                        p_serial_no,
                                                        sysdate,
                                                        p_ng_message,     --Comment
                                                        p_workstage_code,
                                                        p_result,         --Return
                                                        p_type);

                               /********************************************************************/                               
                                                      
                          ELSE
                            
                               p_result     := 'OK';
                               p_message    := 'BACKUPBLOCK_CHECK';
                               p_ng_message := '';
                               p_ok_message := '';  
                                                      
                          END IF;
                          
                     ELSE

                          p_result     := 'OK';
                          p_message    := 'BACKUPBLOCK_CHECK';
                          p_ng_message := '';
                          p_ok_message := 'SKIP';   
                                            
                     END IF;
                                     
                  
                ELSE  
                  
                     p_result     := 'OK';
                     p_message    := 'BACKUPBLOCK_CHECK';
                     p_ng_message := '';
                     p_ok_message := 'SKIP';   
                
                END IF;
                
                          
       ELSE
            
                p_result     := 'NG';
                p_message    := 'BACKUPBLOCK_CHECK';
                p_ng_message := '미등록 라인 입니다' || '(' || p_line_code ||')';
                p_ok_message := '';  
                          
                           
               /*********************************************************************/
                P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                         p_machine_code,
                                         p_serial_no,
                                         sysdate,
                                         p_ng_message,     --Comment
                                         p_workstage_code,
                                         p_result,         --Return
                                         p_type);

                /********************************************************************/
                                            
      END IF; 
           
      RETURN;
  
 
   END IF;      
      
   --------------------------------------------------------------------------
   -- SPI NULL CHECK
   --------------------------------------------------------------------------   
   
   IF p_type = 'SPI_NULL_CHECK' THEN
     
      IF ( p_serial_no = 'NULL' ) THEN
        
            select count(*)
              into lvl_count
              from ip_product_2d_barcode             -- SPI 이력 바코드 없음
             where run_no = (
                              select run_no
                                from ip_product_line
                               where line_code = p_line_code
                            )
               and rownum = 1;
                     
            
             IF ( lvl_count > 0) THEN
               
                   
                  p_result     := 'NG';
                  p_message    := 'SPI_NULL_CHECK';
                  p_ng_message := 'SPI LOG 내 바코드 없음' ;
                  p_ok_message := '';  
                                 
                 /*********************************************************************/
                  P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                           p_machine_code,
                                           p_serial_no,
                                           sysdate,
                                           p_ng_message,     --Comment
                                           p_workstage_code,
                                           p_result,         --Return
                                           p_type);

                  /********************************************************************/
                      
             ELSE
                        
                   p_result     := 'OK';
                   p_message    := 'SPI_NULL_CHECK';
                   p_ng_message := '';
                   p_ok_message := '';   
                      
             END IF;
       
       ELSE
         
             p_result     := 'OK';
             p_message    := 'SPI_NULL_CHECK';
             p_ng_message := '';
             p_ok_message := 'SKIP';         
         
       END IF;
       
      --------------------------------------------------------------------------
              
       RETURN;
  
 
   END IF;    
   
   --------------------------------------------------------------------------
   -- SPI COUNT CHECK
   --------------------------------------------------------------------------   
   
   IF p_type = 'SPI_COUNT_CHECK' THEN
     
        SELECT COUNT (*)
           INTO lvi_check_result_count
           FROM IQ_MACHINE_INSPECT_DATA_SPI
          WHERE PID = p_serial_no ;
          
          
        IF ( lvi_check_result_count >= 1 and LVS_LINE_MARKING_YN = 'Y' ) THEN
                   
                  p_result     := 'NG';
                  p_message    := 'SPI_COUNT_CHECK';
                  p_ng_message := 'SPI 검사 2회 발생' ;
                  p_ok_message := '';  
                                 
                 /*********************************************************************/
                  P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                           p_machine_code,
                                           p_serial_no,
                                           sysdate,
                                           p_ng_message,     --Comment
                                           p_workstage_code,
                                           p_result,         --Return
                                           p_type);

                  /********************************************************************/
                      
         ELSE
                        
                   p_result     := 'OK';
                   p_message    := 'SPI_COUNT_CHECK';
                   p_ng_message := '';
                   p_ok_message := '';   
                      
         END IF;
       
      --------------------------------------------------------------------------
              
       RETURN;
  
 
   END IF;   
   
   --------------------------------------------------------------------------
   -- SPI NG LOG COUNT CHECK
   --------------------------------------------------------------------------   
   
   IF p_type = 'SPI_NG_COUNT_CHECK_TB' THEN
     
        begin
          
           select count(*)
             into lvl_count
             from iq_machine_inspect_data_spi
            where pid like substr( p_serial_no, 1, length(p_serial_no)-1)||'%'     -- p_serial_no
              and NVL(result, 'NULL') in ('NG','NO','NULL')
              and rownum = 1; 
              
         exception
        
            when others then
           
                 lvl_count := 0;
         end;              
                     
            
         IF ( lvl_count > 0) THEN
               
                   
              p_result     := 'NG';
              p_message    := 'SPI_NG_COUNT_CHECK_TB';
              p_ng_message := 'SPI NG품 포장불가' ;
              p_ok_message := '';  
                                 
             /*********************************************************************/
              P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                       p_machine_code,
                                       p_serial_no,
                                       sysdate,
                                       p_ng_message,     --Comment
                                       p_workstage_code,
                                       p_result,         --Return
                                       p_type);

              /********************************************************************/
                      
         ELSE
                        
               p_result     := 'OK';
               p_message    := 'SPI_NG_COUNT_CHECK_TB';
               p_ng_message := '';
               p_ok_message := '';   
                      
         END IF;
      
      --------------------------------------------------------------------------
              
       RETURN;
  
 
   END IF;      
   
   --------------------------------------------------------------------------
   -- PCB OPEN CHECK ( Marking 기준 60일 경과시 NG )
   --------------------------------------------------------------------------   
   
   IF p_type = 'PCB_OPEN_DAY_CHECK_TB' THEN
     
      begin
             
            select sysdate - nvl(to_date(min(dateset), 'YYYY/MM/DD HH24:MI:SS'), sysdate)
              into lvl_count
              from iq_machine_inspect_data_mk
             where pid like substr( p_serial_no, 1, length(p_serial_no)-1)||'%' ;
      
      exception
        
         when others then
           
               lvl_count := 0;
      end;
      
      ---------------------------------------------------
  
      IF ( lvl_count >= 60) THEN
               
                   
            p_result     := 'NG';
            p_message    := 'PCB_OPEN_DAY_CHECK_TB';
            p_ng_message := 'PCB OPEN DAY ( 60일 경과) 발생' ;
            p_ok_message := '';  
                                 
           /*********************************************************************/
            P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                                     p_machine_code,
                                     p_serial_no,
                                     sysdate,
                                     p_ng_message,     --Comment
                                     p_workstage_code,
                                     p_result,         --Return
                                     p_type);

            /********************************************************************/
                      
       ELSE
                        
             p_result     := 'OK';
             p_message    := 'PCB_OPEN_DAY_CHECK_TB';
             p_ng_message := '';
             p_ok_message := '';   
                      
       END IF;
      
      --------------------------------------------------------------------------
              
       RETURN;
  
 
   END IF;        
      
-------------------------------------------------------------------------------
-- 여기 까지 오면 조건이 없으므로 일단 합격처리로 ( 없으니깐 ) 리턴 함 
-------------------------------------------------------------------------------

p_result     := 'OK';
p_message    := 'SKIP';
p_ng_message := f_msg('인터락 조건없음 무조건 합격처리함','C',1);
p_ok_message := f_msg('인터락 조건없음 무조건 합격처리함','C',1);

/*********************************************************************/
  P_INTERLOCK_REQUEST_LOG(p_line_code,
                           p_machine_code,
                           p_serial_no,
                           sysdate,
                           p_ng_message,
                           p_workstage_code,
                           p_result,    
                           p_type);

 /********************************************************************/   

EXCEPTION

   WHEN OTHERS THEN
     
      p_result     := 'NG';
      p_message    := p_type;
      p_ng_message := substr(SQLERRM,1,200);
      p_ok_message := '';

      /*********************************************************************/
      P_INTERLOCK_CHECK_NG_LOG(p_line_code,
                               p_machine_code,
                               p_serial_no,
                               sysdate,
                               p_ng_message,
                               p_workstage_code,
                               p_result,     --Return
                               p_type);

      /********************************************************************/

      RETURN;

END;
