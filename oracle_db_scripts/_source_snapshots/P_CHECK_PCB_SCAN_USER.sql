PROCEDURE P_CHECK_PCB_SCAN_USER (
                                                  p_line_code    IN     VARCHAR2,
                                                  p_run_no       IN     VARCHAR2,
                                                  p_model_name   IN     VARCHAR2,
                                                  p_barcode      IN     VARCHAR2,
                                                  p_deficit      IN     VARCHAR2,
                                                  p_out          OUT    VARCHAR2,
                                                  p_userid       IN     VARCHAR2
                                                 )
IS
    lvs_manufacture_week   VARCHAR2 (10);
    lvs_ip_address         VARCHAR2 (20);
    lvs_use_nsnp_yn        VARCHAR2 (1);
    lvs_child_item_code    VARCHAR2 (30);
    lvs_parent_item_code    VARCHAR2 (30);
    lvi_count              NUMBER;
    phase                  VARCHAR2 (20);

    lvs_item_code          VARCHAR2 (30);

    lvs_pcb_barcode        VARCHAR2(500);    -- scan된 barcode 정보
    lvs_input_field        VARCHAR2(500);    -- P:part no, V:supplier, Q:Qty, H:Lot No, 입력 filed 위치

    lvs_out_result         VARCHAR2(500);    -- PCB barcode 검토 결과 OK/NG
    lvs_out_type           VARCHAR2(500);    -- U:통합, S:개별
    
    lvs_out_part_no        VARCHAR2(500);    -- PCB barcode 내 part no
    lvs_out_supplier       VARCHAR2(500);    -- PCB barcode 내 supplier
    lvs_out_qty            VARCHAR2(500);    -- PCB barcode 내 qty
    lvs_out_lot_no         VARCHAR2(500);    -- PCB barcode 내 lot_no

    lvs_model_name         VARCHAR2(50);
    issue_compare_yn       VARCHAR2(50);
    lvs_out                VARCHAR2(500);

BEGIN

    phase := '10';

    ----------------------------------------------------------------
    -- 2D Barcode parsing 하여 정보를 가져 온다
    ----------------------------------------------------------------
    lvs_item_code   := f_get_item_code_from_barcode (p_barcode);
    lvs_pcb_barcode := p_barcode;
    lvs_input_field := 'P';
    
    ----------------------------------------------------------------
    -- run no 확인
    ----------------------------------------------------------------    
    BEGIN
      
       SELECT model_name , item_code
         INTO LVS_MODEL_NAME , lvs_parent_item_code
         FROM IP_PRODUCT_RUN_CARD
        WHERE RUN_NO          = p_run_no
          AND ORGANIZATION_ID =  1;
          
    EXCEPTION
       WHEN OTHERS THEN
            
            p_out := f_msg('[PCB SCAN] 미등록 Run No 입니다.', 'K', 1)    --  Not PCB ITEM, ITEM CODE
                 || ' = '   
                 || p_run_no;
              
            RETURN;
                      
    END;
  
    ----------------------------------------------------------------
    -- PCB 품목인지 확인
    ----------------------------------------------------------------    
    phase     := '20';    
    LVI_COUNT := 0;
    
    BEGIN
      
       SELECT COUNT(*)
         INTO LVI_COUNT
         FROM ID_ITEM
        WHERE ITEM_CODE       = LVS_ITEM_CODE
          AND ITEM_CLASS      = 'PCB'
          AND ORGANIZATION_ID =  1;
          
    EXCEPTION
       WHEN OTHERS THEN
            LVI_COUNT := 0;
                      
    END;
         
    IF  LVI_COUNT = 0 THEN

        p_out := f_msg('[PCB SCAN] 스캔한 바코드의 PCB 품목이 없습니다.', 'K', 1)    --  Not PCB ITEM, ITEM CODE
                 || ' = '   
                 || 'ITEM CODE='
                 || LVS_ITEM_CODE;
              
        RETURN;

    END IF;
    
    ----------------------------------------------------------------
    -- 자재바코드 정보 추출
    ----------------------------------------------------------------    
    BEGIN
      
       phase     := '25';   
       LVI_COUNT := 1;
    
       SELECT item_code,
              supplier_code,
              to_char(scan_qty),
              lot_no,
              NVL(issue_compare_yn,'*')
         INTO lvs_out_part_no,
              lvs_out_supplier,
              lvs_out_qty,
              lvs_out_lot_no,
              issue_compare_yn
         FROM IM_ITEM_RECEIPT_BARCODE
        WHERE ITEM_BARCODE      = p_barcode
          AND ORGANIZATION_ID =  1;
          
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
            LVI_COUNT := 0;
                      
    END;
         
    IF  ( LVI_COUNT = 0 ) THEN

         p_out := f_msg('[PCB SCAN] 스캔한 바코드 바코드정보가 존재하지 않습니다.', 'K', 1)    --  Not found Material barcode
                  || ' = '   
                  || 'Barcode='
                  || p_barcode;
              
        RETURN;

    END IF;
           
    ----------------------------------------------------------------
    -- 자재바코드 정보 추출
    ----------------------------------------------------------------    
    BEGIN
      
       phase     := '26';   
    
       SELECT COUNT(*)
         INTO lvi_count
         FROM IM_ITEM_RECEIPT_BARCODE
        WHERE ITEM_BARCODE      = p_barcode
          AND REEL_DESTROY_DATE is not null
          AND ORGANIZATION_ID   =  1;
          
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
            LVI_COUNT := 0;
                      
    END;
         
    IF  ( lvi_count > 0 ) THEN

         p_out := f_msg('[PCB SCAN] 스캔한 바코드는 종료 되었습니다.', 'K', 1)    --  Not found Material barcode
                  || ' = '   
                  || 'Barcode='
                  || p_barcode;
              
        RETURN;

    END IF;    

    ----------------------------------------------------------------
    -- PCB 투입
    ----------------------------------------------------------------  
    IF ( p_deficit = 'N' ) THEN
      
   ---------------------------------------------------------------------------------------
    -- 투입이력이 확인
    ---------------------------------------------------------------------------------------
        phase := '100';
        
       SELECT COUNT(*)
         INTO LVI_COUNT
         FROM ip_product_pcb_scan_master
        WHERE PCB_BARCODE    = p_barcode
          AND receipt_status = 'N'
          AND rownum         = 1;
         
       IF  ( LVI_COUNT = 1 ) THEN

           p_out := f_msg('[PCB SCAN] 이미 투입된 PCB 입니다.', 'K', 1)    --  Not PCB ITEM, ITEM CODE
                    || ' = '   
                    || p_barcode;
              
           RETURN;

       END IF;
           
      
    ----------------------------------------------------------------
    -- 출고여부 확인
    ----------------------------------------------------------------      
        IF ( issue_compare_yn = 'Y' ) THEN
             NULL;
        ELSE

              p_out := f_msg('[PCB SCAN] 미 출고된 자재 입니다.', 'K', 1)    --  Not found Material barcode
                       || ' = '   
                       || 'Barcode='
                       || p_barcode;
              
             RETURN;

        END IF;
    
      
    ----------------------------------------------------------------
    --  투입 Run no 의 Model 에 투입자재가 맞는지 확인
    ----------------------------------------------------------------    
       phase := '30';  

       BEGIN
         
--            SELECT   COUNT ( * ), MAX (item_code)
--              INTO   lvi_count, lvs_child_item_code   -- id_item 에서 lvs_child_item_code 을 사용하나 PCB와 Model 1:1 이 아니면 문제가 되므로 ip_product_model_master로 변
--              FROM   ip_product_model_master
--             WHERE   model_name = LVS_MODEL_NAME
--               AND   item_code  IN ( 
--               
--                               --     SELECT   PARENT_ITEM_CODE  
--                               --       FROM   id_eng_bom m
--                               --      WHERE   m.child_item_code = lvs_item_code
--                                --             START WITH   m.child_item_code     = lvs_item_code
--                                 --            CONNECT BY   PRIOR child_item_code = parent_item_code
--                                             
--                                             
--                                    SELECT child_item_code
--                                      FROM id_eng_bom m
--                                     where parent_item_code = '*'
--                                     START WITH m.child_item_code    = lvs_item_code
--                                   CONNECT BY PRIOR parent_item_code = child_item_code 
--                                                                                
--                                   );

   select count(*) INTO lvi_count
    from (
           SELECT  child_item_code 
             FROM  id_eng_bom
            WHERE  child_item_code =  lvs_item_code  
              AND  TRUNC (dateset) <= trunc(sysdate)
              AND  dateend         >= trunc(sysdate)
              AND  organization_id =  1
              
           START WITH child_item_code   =  lvs_parent_item_code
                    AND TRUNC (dateset) <= trunc(sysdate)
                    AND dateend         >= trunc(sysdate)
                    AND organization_id =  1
                    
         CONNECT BY PRIOR child_item_code =  parent_item_code
                    AND TRUNC (dateset)   <= trunc(sysdate)
                    AND dateend           >= trunc(sysdate)
                    AND organization_id   =  1
       ) ;
                    
                    
                                   
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 lvi_count := 0;
            WHEN OTHERS THEN
                 
                 p_out := f_msg('[PCB SCAN] BOM 상에 PCB 확인중 오류입니다.', 'K', 1)    --  Not found Material barcode
                          || ' = '   
                          || 'Model='
                          || LVS_MODEL_NAME
                          || ', '
                          || 'PCB='
                          || lvs_item_code
                          || ', '
                          || SQLERRM;
                  
                 return ;

        END;

        --------------------------------------------------------------------------------------------
        --
        --------------------------------------------------------------------------------------------
        IF lvi_count = 0 THEN
          
        /*
        
            --------------------------------------------------------------------------------
            -- NSNP START
            -------------------------------------------------------------------------------- 
                       
            BEGIN
              
                p_interlock_set_nsnp_msg (
                                          p_line_code,
                                          1,
                                          p_model_name,
                                          '*',
                                          'PCB',
                                          'PCB UNMATCH BOM ' || lvs_item_code
                                         );
            EXCEPTION
                WHEN OTHERS THEN
                     NULL;
            END;
            
            --------------------------------------------------------------------------------
            -- NSNP END
            --------------------------------------------------------------------------------
            
        */


            ------------------------------------------------------------------------------------------
            -- PCB SCNA STATUS NG
            ------------------------------------------------------------------------------------------
            
            phase := '40';  
            
            UPDATE ip_product_line
               SET pcb_scan_date   = SYSDATE,
                   pcb_item_code   = lvs_item_code,
                   pcb_scan_status = 'N'
             WHERE line_code       = SUBSTR (p_line_code, 1, 2);

            COMMIT;
             
            p_out := f_msg('[PCB SCAN] BOM 상에 PCB 가 아닙니다.', 'K', 1)    --  Unmatch BOM
                          || ' = '   
                          || 'Model='
                          || LVS_MODEL_NAME
                          || ', '
                          || 'PCB='
                          || lvs_item_code;
            RETURN;
            
        END IF;

        ---------------------------------------------------------------------------------------------
        --   INSERT HISTORY
        ---------------------------------------------------------------------------------------------

    
        phase := '50';
        


        P_INTERLOCK_SET_PCB_USER (
                                  p_line_code,
                                  f_get_workstage_code_by_type( 'SMT'),
                                  'PDA',
                                  lvs_out_part_no,
                                  lvs_out_supplier,
                                  to_number(lvs_out_qty),
                                  p_barcode,
                                  p_run_no,
                                  lvs_model_name,
                                  lvs_out,
                                  p_userid
                            );


        IF ( substr(lvs_out,1,5) = 'ERROR' ) THEN

           p_out := f_msg('[PCB SCAN] P_INTERLOCK_SET_PCB_USER 오류입니다.', 'K', 1)    --  P_INTERLOCK_SET_PCB Error
                          || ' = '   
                          || lvs_out;
                          
           RETURN;

        END IF;
     
        ------------------------------------------------------------------------------------------
        -- PCB SCNA DATE  OK
        ------------------------------------------------------------------------------------------

        UPDATE ip_product_line
           SET pcb_scan_date   = SYSDATE,
               pcb_item_code   = lvs_out_part_no,
               pcb_scan_status = 'O'
         WHERE line_code       = SUBSTR (p_line_code, 1, 2)
           AND organization_id = 1;

        COMMIT;


        ------------------------------------------------------------------------------------------
        -- MSL 데이타 설정
        ------------------------------------------------------------------------------------------

        UPDATE IM_ITEM_RECEIPT_BARCODE
           SET MSL_OPEN_DATE     = NVL(MSL_OPEN_DATE, SYSDATE)
         WHERE ITEM_BARCODE      = p_barcode
           AND ORGANIZATION_ID   =  1;

        COMMIT;
        
        p_out := 'OK';
        RETURN;

    ---------------------------------------------------------------------------------------
    --
    ---------------------------------------------------------------------------------------

    ELSE

    ---------------------------------------------------------------------------------------
    -- 투입이력이 확인
    ---------------------------------------------------------------------------------------
        phase := '100';
        
       SELECT COUNT(*)
         INTO LVI_COUNT
         FROM ip_product_pcb_scan_master
        WHERE PCB_BARCODE    = p_barcode
          AND receipt_status = 'N'
          AND rownum         = 1;
         
       IF  ( LVI_COUNT = 0 ) THEN

           p_out := f_msg('[PCB SCAN] PCB 투입 이력이 없습니다.', 'K', 1)    --  Not PCB ITEM, ITEM CODE
                    || ' = '   
                    || p_barcode;
              
           RETURN;

       END IF;
              
     ---------------------------------------------------------------------------------------
    -- 취소처리
    ---------------------------------------------------------------------------------------      
     
        UPDATE ip_product_pcb_scan_master
           SET receipt_status = 'C',
               last_modify_date = SYSDATE
         WHERE line_code        = p_line_code
           AND run_no           = p_run_no
           AND PCB_BARCODE      = p_barcode
           AND item_code        = lvs_out_part_no
           AND receipt_status   = 'N'
           AND organization_id  = 1
           AND scan_date in (
                              SELECT max(scan_date)
                                FROM ip_product_pcb_scan_master
                               WHERE line_code       = p_line_code
                                 AND run_no          = p_run_no
                                 AND PCB_BARCODE     = p_barcode
                                 AND item_code       = lvs_out_part_no
                                 AND receipt_status  = 'N'
                                 AND organization_id = 1
                            );


        COMMIT;

        p_out := 'OK';
        RETURN;

    END IF;

-------------------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------------------
EXCEPTION

    WHEN OTHERS THEN
      
        p_out := 'NG, [P_CHECK_PCB_SCAN_USER] IP=' 
                 || lvs_ip_address 
                 || ', ' 
                 || 'PHASE=' 
                 || phase 
                 || ', '
                 || SQLERRM;

END;
