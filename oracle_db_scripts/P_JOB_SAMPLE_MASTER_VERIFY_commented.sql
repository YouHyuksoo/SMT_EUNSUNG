CREATE OR REPLACE PROCEDURE P_JOB_SAMPLE_MASTER_VERIFY
  /* ================================================================
   * 프로시저명  : P_JOB_SAMPLE_MASTER_VERIFY
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-10-15
   * 수정이력:
   *   2020-10-15 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   프로시저 원본 로직의 업무 처리 흐름을 수행한다.
   *   참조 테이블과 입력 파라미터를 기반으로 조회, 등록, 갱신 또는 메시지 반환을 처리한다.
   *   원본 코드의 트랜잭션 및 예외 처리 흐름은 변경하지 않았다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   없음
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IMCN_SAMPLE - 원본 로직 참조 테이블
   *   IMCN_SAMPLE_BCR_INPUT_HIST - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   FROM
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_JOB_SAMPLE_MASTER_VERIFY(...)
   * ================================================================ */
IS

  
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
  
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
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
    WHEN OTHERS THEN
   
         ROLLBACK;   
      
END;
