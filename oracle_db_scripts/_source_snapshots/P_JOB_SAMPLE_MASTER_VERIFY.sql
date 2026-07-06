PROCEDURE P_JOB_SAMPLE_MASTER_VERIFY
IS

  
BEGIN
  
  -- 최근 6개월경과 sample master AOI이력 확인 **********************************************************************************************
  
     update imcn_sample 
        set verification_date1  = sysdate,
            verification_state1 = 'NG' -- 'SYS_NG'  -- 20201015, 이승빈 차장의 요청은 system 에서 판정으로 변경 요청하여 으넝전장도 동일하게 반영함
      where sample_type = 'S'
        and sample_apply_date = trunc( add_months(sysdate, -6) )
        and (
              verification_date1            is null  or
              nvl(verification_state1, '*') = '*'
            )
       and ( sample_code, sample_lot_no ) in (      
                                               select sample_code, sample_lot_no
                                                 from (
                                                        select sample_code, sample_lot_no, sample_section, decode(inspect_result,'GOOD','OK','PASS', decode(sample_section, 'G','OK',inspect_result), inspect_result) inspect_value, sum(1) inspect_count
                                                          from imcn_sample_bcr_input_hist
                                                         where input_date >=  trunc(add_months(sysdate, -6)) 
                                                           and input_date <   sysdate
                                                           and sample_type = 'S'
                                                         group by sample_code, sample_lot_no, sample_section, decode(inspect_result,'GOOD','OK','PASS', decode(sample_section, 'G','OK',inspect_result), inspect_result)
                                                      )
                                                where ( sample_section = 'G' and inspect_value = 'NG' and inspect_count > 0 )
                                                   or ( sample_section = 'B' and inspect_value = 'OK' and inspect_count > 0 )
                                             );
                                         
                                         
     COMMIT;
                                               
     update imcn_sample 
        set verification_date1  = sysdate,
            verification_state1 = 'OK' -- 'SYS_OK'
      where sample_type = 'S'
        and sample_apply_date = trunc( add_months(sysdate, -6) )
        and (
              verification_date1            is null  or
              nvl(verification_state1, '*') = '*'
            );                                                       
            
     COMMIT;                                                  
                
  -- 최근 12개월경과 sample master AOI이력 확인 **********************************************************************************************
  
     update imcn_sample 
        set verification_date2  = sysdate,
            verification_state2 = 'NG' -- 'SYS_NG' 
      where sample_type = 'S'
        and sample_apply_date = trunc( add_months(sysdate, -12) )
        and (
              verification_date2            is null  or
              nvl(verification_state2, '*') = '*'
            )
       and ( sample_code, sample_lot_no ) in (      
                                               select sample_code, sample_lot_no
                                                 from (
                                                        select sample_code, sample_lot_no, sample_section, decode(inspect_result,'GOOD','OK','PASS', decode(sample_section, 'G','OK',inspect_result), inspect_result) inspect_value, sum(1) inspect_count
                                                          from imcn_sample_bcr_input_hist
                                                         where input_date >=  trunc(add_months(sysdate, -6)) 
                                                           and input_date <   sysdate
                                                           and sample_type = 'S'
                                                         group by sample_code, sample_lot_no, sample_section, decode(inspect_result,'GOOD','OK','PASS', decode(sample_section, 'G','OK',inspect_result), inspect_result)
                                                      )
                                                where ( sample_section = 'G' and inspect_value = 'NG' and inspect_count > 0 )
                                                   or ( sample_section = 'B' and inspect_value = 'OK' and inspect_count > 0 )
                                             );
                                         

     COMMIT;                                           
                                         
     update imcn_sample 
        set verification_date2  = sysdate,
            verification_state2 = 'OK' -- 'SYS_OK'
      where sample_type = 'S'
        and sample_apply_date = trunc( add_months(sysdate, -12) )
        and (
              verification_date2            is null  or
              nvl(verification_state2, '*') = '*'
            );  
           
     COMMIT;  
                 
  -- 최근 18개월경과 sample master AOI이력 확인 **********************************************************************************************
  
     update imcn_sample 
        set verification_date3  = sysdate,
            verification_state3 = 'NG' -- 'SYS_NG' 
      where sample_type = 'S'
        and sample_apply_date = trunc( add_months(sysdate, -18) )
        and (
              verification_date3            is null  or
              nvl(verification_state3, '*') = '*'
            )
       and ( sample_code, sample_lot_no ) in (      
                                               select sample_code, sample_lot_no
                                                 from (
                                                        select sample_code, sample_lot_no, sample_section, decode(inspect_result,'GOOD','OK','PASS', decode(sample_section, 'G','OK',inspect_result), inspect_result) inspect_value, sum(1) inspect_count
                                                          from imcn_sample_bcr_input_hist
                                                         where input_date >=  trunc(add_months(sysdate, -6)) 
                                                           and input_date <   sysdate
                                                           and sample_type = 'S'
                                                         group by sample_code, sample_lot_no, sample_section, decode(inspect_result,'GOOD','OK','PASS', decode(sample_section, 'G','OK',inspect_result), inspect_result)
                                                      )
                                                where ( sample_section = 'G' and inspect_value = 'NG' and inspect_count > 0 )
                                                   or ( sample_section = 'B' and inspect_value = 'OK' and inspect_count > 0 )
                                             );
                                         
                                         
     COMMIT;  
                                              
     update imcn_sample 
        set verification_date3  = sysdate,
            verification_state3 = 'OK' -- 'SYS_OK'
      where sample_type = 'S'
        and sample_apply_date = trunc( add_months(sysdate, -18) )
        and (
              verification_date3            is null  or
              nvl(verification_state3, '*') = '*'
            );  
           
     COMMIT;              
            
  -- 최근 24개월경과 sample master AOI이력 확인 **********************************************************************************************
  
     update imcn_sample 
        set verification_date4  = sysdate,
            verification_state4 = 'NG' -- 'SYS_NG' 
      where sample_type = 'S'
        and sample_apply_date = trunc( add_months(sysdate, -24) )
        and (
              verification_date4            is null  or
              nvl(verification_state4, '*') = '*'
            )
       and ( sample_code, sample_lot_no ) in (      
                                               select sample_code, sample_lot_no
                                                 from (
                                                        select sample_code, sample_lot_no, sample_section, decode(inspect_result,'GOOD','OK','PASS', decode(sample_section, 'G','OK',inspect_result), inspect_result) inspect_value, sum(1) inspect_count
                                                          from imcn_sample_bcr_input_hist
                                                         where input_date >=  trunc(add_months(sysdate, -6)) 
                                                           and input_date <   sysdate
                                                           and sample_type = 'S'
                                                         group by sample_code, sample_lot_no, sample_section, decode(inspect_result,'GOOD','OK','PASS', decode(sample_section, 'G','OK',inspect_result), inspect_result)
                                                      )
                                                where ( sample_section = 'G' and inspect_value = 'NG' and inspect_count > 0 )
                                                   or ( sample_section = 'B' and inspect_value = 'OK' and inspect_count > 0 )
                                             );
                                         
                                         
     COMMIT;  
                                              
     update imcn_sample 
        set verification_date4  = sysdate,
            verification_state4 = 'OK' -- 'SYS_OK'
      where sample_type = 'S'
        and sample_apply_date = trunc( add_months(sysdate, -24) )
        and (
              verification_date4            is null  or
              nvl(verification_state4, '*') = '*'
            );  
           
     COMMIT;  
                 
  -- 최근 30개월경과 sample master AOI이력 확인 **********************************************************************************************
  
     update imcn_sample 
        set verification_date5  = sysdate,
            verification_state5 = 'NG' -- 'SYS_NG' 
      where sample_type = 'S'
        and sample_apply_date = trunc( add_months(sysdate, -30) )
        and (
              verification_date5            is null  or
              nvl(verification_state5, '*') = '*'
            )
       and ( sample_code, sample_lot_no ) in (      
                                               select sample_code, sample_lot_no
                                                 from (
                                                        select sample_code, sample_lot_no, sample_section, decode(inspect_result,'GOOD','OK','PASS', decode(sample_section, 'G','OK',inspect_result), inspect_result) inspect_value, sum(1) inspect_count
                                                          from imcn_sample_bcr_input_hist
                                                         where input_date >=  trunc(add_months(sysdate, -6)) 
                                                           and input_date <   sysdate
                                                           and sample_type = 'S'
                                                         group by sample_code, sample_lot_no, sample_section, decode(inspect_result,'GOOD','OK','PASS', decode(sample_section, 'G','OK',inspect_result), inspect_result)
                                                      )
                                                where ( sample_section = 'G' and inspect_value = 'NG' and inspect_count > 0 )
                                                   or ( sample_section = 'B' and inspect_value = 'OK' and inspect_count > 0 )
                                             );
                                         
      COMMIT;  
                                              
     update imcn_sample 
        set verification_date5  = sysdate,
            verification_state5 = 'OK' -- 'SYS_OK'
      where sample_type = 'S'
        and sample_apply_date = trunc( add_months(sysdate, -30) )
        and (
              verification_date5            is null  or
              nvl(verification_state5, '*') = '*'
            );  
            
     COMMIT;              
            
  -- 최근 36개월경과 sample master AOI이력 확인 **********************************************************************************************
  
     update imcn_sample 
        set verification_date6  = sysdate,
            verification_state6 = 'NG' -- 'SYS_NG' 
      where sample_type = 'S'
        and sample_apply_date = trunc( add_months(sysdate, -36) )
        and (
              verification_date6            is null  or
              nvl(verification_state6, '*') = '*'
            )
       and ( sample_code, sample_lot_no ) in (      
                                               select sample_code, sample_lot_no
                                                 from (
                                                        select sample_code, sample_lot_no, sample_section, decode(inspect_result,'GOOD','OK','PASS', decode(sample_section, 'G','OK',inspect_result), inspect_result) inspect_value, sum(1) inspect_count
                                                          from imcn_sample_bcr_input_hist
                                                         where input_date >=  trunc(add_months(sysdate, -6)) 
                                                           and input_date <   sysdate
                                                           and sample_type = 'S'
                                                         group by sample_code, sample_lot_no, sample_section, decode(inspect_result,'GOOD','OK','PASS', decode(sample_section, 'G','OK',inspect_result), inspect_result)
                                                      )
                                                where ( sample_section = 'G' and inspect_value = 'NG' and inspect_count > 0 )
                                                   or ( sample_section = 'B' and inspect_value = 'OK' and inspect_count > 0 )
                                             );
                                         
                                         
      COMMIT;  
                                              
     update imcn_sample 
        set verification_date6  = sysdate,
            verification_state6 = 'OK' -- 'SYS_OK'
      where sample_type = 'S'
        and sample_apply_date = trunc( add_months(sysdate, -36) )
        and (
              verification_date6            is null  or
              nvl(verification_state6, '*') = '*'
            );  
           
      COMMIT;
      
EXCEPTION
    WHEN OTHERS THEN
   
         ROLLBACK;   
      
END;
