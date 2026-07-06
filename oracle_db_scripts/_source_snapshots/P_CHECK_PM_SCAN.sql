PROCEDURE "P_CHECK_PM_SCAN" (p_barcode    IN     VARCHAR2,
                           p_division   IN     VARCHAR2,
                           p_deficit    IN     VARCHAR2,
                           p_out           OUT VARCHAR2)
IS
    lvs_line_code      VARCHAR2 (10);
    lvs_pm_type        VARCHAR2 (10);
    lvs_machine_code   VARCHAR2 (20);
    lvs_jig_lot_no     VARCHAR2 (20);
    phase              VARCHAR2 (20);
    lvl_first          NUMBER;
    lvl_second         NUMBER;
    lvi_count          NUMBER;
    lvi_checck_hit_value NUMBER ;
BEGIN
    phase := '10';

    ---------------------------------------------------------------------------------------
    -- pm 라벨의 규격이 맞게 라인 + 공백 + 바코드 + 공백 + pm 유형 인데 
    -- 동도는 그렇게 안하므로 
    ---------------------------------------------------------------------------------------

--    lvl_first := INSTR (p_barcode, ' ', 1);
--    lvl_second := INSTR (p_barcode, ' ', lvl_first + 1);

    ---------------------------------------------------------------------------------------
    -- MACHINE
    ---------------------------------------------------------------------------------------
    IF p_division = 'M'
    THEN
        lvs_line_code := SUBSTR (p_barcode, 1, lvl_first - 1);
        lvs_machine_code := SUBSTR (p_barcode, lvl_first + 1, (lvl_second - lvl_first) - 1);
        lvs_pm_type := TRIM (SUBSTR (p_barcode, lvl_second + 1, 100));

        IF p_deficit = 'N'
        THEN
            BEGIN
                SELECT   COUNT ( * )
                  INTO   lvi_count
                  FROM   imcn_machine_pm_master_hist
                 WHERE   machine_code = lvs_machine_code
                     AND pm_type = lvs_pm_type
                     AND TRUNC (pm_date) = TRUNC (SYSDATE)
                     AND organization_id = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    lvi_count := 0;
            END;

            IF lvi_count = 0
            THEN
                INSERT INTO imcn_machine_pm_master_hist (organization_id,
                                                         line_code,
                                                         machine_code,
                                                         break_value,
                                                         plan_date,
                                                         pm_date,
                                                         comments,
                                                         enter_date,
                                                         enter_by,
                                                         last_modify_date,
                                                         last_modify_by,
                                                         hit_value,
                                                         pm_type,
                                                         confirm_yn,
                                                         pm_division)
                    SELECT   organization_id,
                             line_code,
                             machine_code,
                             break_value,
                             plan_date,
                             SYSDATE pm_date,
                             comments,
                             SYSDATE,
                             enter_by,
                             SYSDATE,
                             last_modify_by,
                             hit_value,
                             lvs_pm_type pm_type,
                             'N' confirm_yn,
                             pm_division
                      FROM   imcn_machine_pm_master
                     WHERE   machine_code = lvs_machine_code AND pm_type = lvs_pm_type AND organization_id = 1;
            ELSE
                p_out := f_msg('ALREADY EXISTS','C',1);
                RETURN;
            END IF;
        ELSE
            DELETE FROM   imcn_machine_pm_master_hist
                  WHERE   machine_code = lvs_machine_code
                      AND pm_type = lvs_pm_type
                      AND TRUNC (pm_date) = TRUNC (SYSDATE)
                      AND organization_id = 1;
        END IF;
    ---------------------------------------------------------------------------------------
    -- JIG 수명 관리만 하기로 해서 
    -- 다른거 다 막고 바코드를 기준으로 수명만 체크하게 
    ---------------------------------------------------------------------------------------
    ELSE
    
    
          lvs_line_code := '*' ; --SUBSTR (p_barcode, 1, lvl_first - 1);
          lvs_jig_lot_no := p_barcode ; --SUBSTR (p_barcode, lvl_first + 1, (lvl_second - lvl_first) - 1);
          lvs_pm_type := '*' ; --TRIM (SUBSTR (p_barcode, lvl_second + 1, 100));

        ------------------------------------------------------------------------
        -- 정상 등록이면 
        -- 수명 등록 
        ------------------------------------------------------------------------
   
           
        IF p_deficit = 'N'
        THEN
        
            BEGIN 
            
               select count(*) into lvi_checck_hit_value 
                 from imcn_jig
                where jig_lot_no = lvs_jig_lot_no
                  and nvl(break_value,0) < nvl(hit_value,0)
                  and organization_id = 1;
                  
                EXCEPTION WHEN NO_DATA_FOUND THEN 
                 lvi_checck_hit_value := 0 ;
                
             END ;
              
             -----------------------------------------
             -- 수명 초과면 
             -----------------------------------------
             IF nvl(lvi_checck_hit_value,0) > 0  then 
             
                p_out := f_msg('LIFE CYCLE OVER','C',1);
                RETURN;
                
              else
                  update imcn_jig set hit_value = nvl(hit_value ,0) + 1
                  where jig_lot_no = lvs_jig_lot_no
                  and organization_id = 1;               
             end if ;

            BEGIN
                SELECT   COUNT ( * )
                  INTO   lvi_count
                  FROM   imcn_jig_pm_master_hist
                 WHERE   jig_lot_no = lvs_jig_lot_no
                     AND pm_type = lvs_pm_type
                     AND TRUNC (pm_date) = TRUNC (SYSDATE)
                     AND organization_id = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    lvi_count := 0;
            END;

                IF lvi_count = 0
                THEN
                    INSERT INTO imcn_jig_pm_master_hist (organization_id,
                                                         line_code,
                                                         jig_code,
                                                         jig_lot_no,
                                                         break_value,
                                                         plan_date,
                                                         pm_date,
                                                         comments,
                                                         enter_date,
                                                         enter_by,
                                                         last_modify_date,
                                                         last_modify_by,
                                                         hit_value,
                                                         pm_type,
                                                         confirm_yn,
                                                         pm_division)
                        SELECT   organization_id,
                                 line_code,
                                 jig_code,
                                 jig_lot_no,
                                 break_value,
                                 plan_date,
                                 SYSDATE pm_date,
                                 comments,
                                 SYSDATE,
                                 enter_by,
                                 SYSDATE,
                                 last_modify_by,
                                 hit_value,
                                 lvs_pm_type pm_type,
                                 'N' confirm_yn,
                                 pm_division
                          FROM   imcn_jig_pm_master
                         WHERE   jig_lot_no = lvs_jig_lot_no AND pm_type = lvs_pm_type AND organization_id = 1;
                ELSE
                    p_out := f_msg('ALREADY EXISTS','C',1);
                    RETURN;
                END IF;
        ELSE
        
        ---------------------------------------------------
        -- 원래는 바코드에 지그 번호 PM 타입이 같이 있어야 하는데 없으면
        ---------------------------------------------------
            DELETE FROM   imcn_jig_pm_master_hist
                  WHERE   jig_lot_no = lvs_jig_lot_no
                      AND pm_type = lvs_pm_type
                      AND TRUNC (pm_date) = TRUNC (SYSDATE)
                      AND organization_id = 1;
        END IF;
    END IF;

    p_out := 'OK';
    RETURN;
-------------------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------------------
EXCEPTION
    WHEN OTHERS
    THEN
        p_out := 'NG ' || 'PHASE=' || phase || ' ' || SQLERRM;
        RETURN;
END;