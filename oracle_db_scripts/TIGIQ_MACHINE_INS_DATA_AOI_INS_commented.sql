CREATE OR REPLACE TRIGGER TIGIQ_MACHINE_INS_DATA_AOI_INS
 BEFORE INSERT ON IQ_MACHINE_INSPECT_DATA_AOI
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW
DECLARE
    
    LVS_OUT             VARCHAR2(4000); 
    LVS_MSG             VARCHAR2(4000); 
    LVS_WORKSTAGE_CODE  VARCHAR2(30);  

  lvs_nsnp_status       VARCHAR2(30);
  lvs_nsnp_status_prev  VARCHAR2(30);
  lvs_line_code         VARCHAR2(30);
  lvs_type              VARCHAR2(100);
  lvs_message           VARCHAR2(1000);
  lvs_ng_message        VARCHAR2(1000);
  lvs_ok_message        VARCHAR2(1000);
  LVS_ERROR_MESSAGE     VARCHAR2(2000);
  
  lvs_model_name        VARCHAR2(100);
  p_out                 VARCHAR2(2000);
  p_msg                 VARCHAR2(2000);
  
  lvs_sample_code       VARCHAR2(30);
  lvs_sample_lot_no     VARCHAR2(30);
  lvs_sample_section    VARCHAR2(30);
  lvs_sample_type       VARCHAR2(30);
  
  lvs_nsnp_message      VARCHAR2(1000);
  lvs_nsnp_ng_message   VARCHAR2(1000);
             
  lvl_sample_count      number;
  lvl_aoi_hist_count    number;  
  
  lvs_line_run_no       VARCHAR2(100); 
  lvs_line_model_name   VARCHAR2(100);
  
  CURSOR CL1 IS 
          SELECT interlock_check_type, check_sequence
            FROM iq_interlock_check_condition
           WHERE line_code         = lvs_line_code 
             AND workstage_code    = LVS_WORKSTAGE_CODE
             AND NVL (use_yn, 'Y') = 'Y'
        ORDER BY check_sequence ASC;
        
  
BEGIN
    /* ================================================================
     * 트리거명  : TIGIQ_MACHINE_INS_DATA_AOI_INS
     * 작성일  : 2026-07-02
     * 수정이력: 2026-07-02 - AI(Codex) - 한글 주석 자동 추가
     * ================================================================
     * [AI 분석] 기능 설명:
     *   IQ_MACHINE_INSPECT_DATA_AOI 테이블의 INSERT 이벤트 발생 시 원본 로직에 정의된 자동 처리를 수행한다.
     * ================================================================
     * [AI 분석] 발화 조건:
     *   시점/단위: BEFORE EACH ROW / 이벤트: INSERT / 조건: 없음
     * ================================================================
     * [AI 분석] 대상 객체:
     *   IQ_MACHINE_INSPECT_DATA_AOI - 트리거가 걸린 테이블/뷰
     * ================================================================
     * [AI 분석] OLD/NEW 사용:
     *   :NEW - RUN_NO, PID, ORGANIZATION_ID, LINE_CODE, RESULT, EQUIPMENTID, CSTID, SEQ_NO, INSPECT_DATE, DEFECT_CODE 변경 후 값 참조
     * ================================================================
     * [AI 분석] 예외 처리:
     *   원본 EXCEPTION 블록 기준으로 오류를 처리한다.
     * ================================================================
     * [AI 분석] 복잡도:
     *   조건 분기: IF 17회 / 반복문: 3회 / DML: SELECT 6회, INSERT 3회, UPDATE 1회, DELETE 1회
     * ================================================================
     * 검증 방법: USER_OBJECTS, USER_ERRORS, USER_SOURCE, USER_TRIGGERS 조회만 사용한다.
     * 주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
     * ================================================================ */

  
 /*
    :NEW.SEQ_NO := NVL(:NEW.SEQ_NO , 0 ) ;
    :NEW.EQUIPMENTID := NVL(:NEW.EQUIPMENTID , '*') ;
    ------------------------------------------------------------
    -- 해당라인의 진행중인 RUN NO을 가져온다
    ------------------------------------------------------------


    BEGIN
      
       SELECT RUN_NO
         INTO :NEW.RUN_NO
         FROM IP_PRODUCT_LINE
        WHERE LINE_CODE       = :NEW.LINE_CODE
          AND ORGANIZATION_ID = :NEW.ORGANIZATION_ID; 
      
    EXCEPTION
       WHEN OTHERS THEN
            NULL;  
    END;
    
*/

 --   IF ( :NEW.RUN_NO = 'NULL' OR :NEW.RUN_NO = ''  OR :NEW.RUN_NO IS NULL ) THEN
           
              BEGIN
                 
                  SELECT RUN_NO, model_name
                    INTO :NEW.RUN_NO, lvs_model_name
                    FROM IP_PRODUCT_2D_BARCODE
                   WHERE serial_no       = :NEW.PID
                     AND ORGANIZATION_ID = :NEW.ORGANIZATION_ID;     
                  
               EXCEPTION 
                     WHEN OTHERS THEN 
                          :NEW.RUN_NO    := '*';                         
                          lvs_model_name := '*';
                          
               END;
           
 --   END IF;
    
    :new.pid    := nvl(:new.pid, 'NULL') ;

/*    
    :NEW.INSPECT_DATE :=   SUBSTR(:NEW.INSPECT_DATE, 1,4)||'/'
                         ||SUBSTR(:NEW.INSPECT_DATE, 5,2)||'/'
                         ||SUBSTR(:NEW.INSPECT_DATE, 7,2)||' '
                         ||SUBSTR(:NEW.INSPECT_DATE, 9,2)||':'
                         ||SUBSTR(:NEW.INSPECT_DATE,11,2)||':'
                         ||SUBSTR(:NEW.INSPECT_DATE,13,2);
                         
    :NEW.EQUIPMENTID := NVL(:NEW.EQUIPMENTID , '*') ;    
                         
    :NEW.CSTID  := regexp_substr(:NEW.PID,'[^-]+',1,1);                     
    :NEW.SEQ_NO := substr(regexp_substr(:NEW.PID,'[^-]+',1,2),1,2);
    :NEW.SEQ_NO := NVL(:NEW.SEQ_NO , '00' ) ;
*/
    
    LVS_WORKSTAGE_CODE := 'W060';
    
      
    -----------------------------------------------------------
    -- INTLOCK 확인
    ----------------------------------------------------------- 
    
      IF ( NVL(:NEW.LINE_CODE,'*') = '*' ) THEN
         lvs_line_code := F_GET_LINE_CODE_BY_RUN_NO( :NEW.RUN_NO,1 ) ;  
      ELSE     
         lvs_line_code := :NEW.LINE_CODE;
      END IF;  
      
      
   ------------------------------------------------------------
    -- 양불 마스터 sample 이지 확인하여 통과이력 남김
    ------------------------------------------------------------
  
   BEGIN
     
         lvl_sample_count := 0;
       
         select s.sample_type, s.sample_code, s.sample_lot_no, s.sample_section, 1, l.run_no, l.model_name
           into lvs_sample_type, lvs_sample_code, lvs_sample_lot_no, lvs_sample_section, lvl_sample_count,  lvs_line_run_no, lvs_line_model_name
           from ip_product_line l,
                imcn_sample     s
          where ( l.sample_lot_no  = s.sample_lot_no or l.sample_lot_no2  = s.sample_lot_no )
            and l.line_code      = lvs_line_code
          --  and s.sample_barcode like regexp_substr(:NEW.PID,'[^-]+',1,1)||'%'
            and s.sample_barcode = :NEW.PID
            and rownum = 1;
   
         --IF ( ( lvl_sample_count = 1 ) AND ( substr( :NEW.PID, instr( :NEW.PID, '-' )+1, 2 ) = '01' ) ) THEN
         IF ( ( lvl_sample_count = 1 ) ) THEN
        
             INSERT INTO IMCN_SAMPLE_BCR_INPUT_HIST (
                                                      input_date, 
                                                      line_code, 
                                                      workstage_code, 
                                                      run_no, 
                                                      model_name, 
                                                      sample_type, 
                                                      sample_section, 
                                                      sample_code, 
                                                      sample_lot_no, 
                                                      organization_id, 
                                                      enter_by, 
                                                      enter_date,  
                                                      last_modify_by, 
                                                      last_modify_date,
                                                      sample_barcode,
                                                      inspect_result
                                                    )
                   SELECT sysdate,
                          lvs_line_code,
                          LVS_WORKSTAGE_CODE,
                          lvs_line_run_no,
                          lvs_line_model_name,
                          lvs_sample_type,
                          lvs_sample_section,
                          lvs_sample_code,
                          lvs_sample_lot_no,
                          :NEW.ORGANIZATION_ID, 
                          'TRIGGER',
                          sysdate,
                          'TRIGGER',
                          sysdate,
                          :NEW.PID,
                          :NEW.RESULT
                     FROM DUAL;
            
         ElSE
           
             -- NSNP NG CALL
             -- lvs_nsnp_message    := 'TIGIQ_MACHINE_INS_DATA_AOI_INS';
             -- lvs_nsnp_ng_message := '장착된 양불마스터와 AOI 검사결과 불일치 => '||lvs_sample_lot_no||', '||lvs_sample_section||', '||:NEW.RESULT;
             
             -- P_INTERLOCK_SET_NSNP_TIME_MSG2( lvs_line_code , '1' , 1 , :NEW.LOTID , '*' , lvs_nsnp_message , lvs_nsnp_ng_message  ) ; 
             
             NULL;
             
         END IF;
    
    EXCEPTION 
         WHEN OTHERS THEN 
              NULL ;
    END ; 
          
    ---------------------------------------------------------------------------
    -- 인터락 확인
    ---------------------------------------------------------------------------
    IF :new.pid = 'NULL' then 
        null ;
    ELSE
    
              FOR C_VAR IN CL1 LOOP
              
              
                   -- P_mESSAGE 는 시리얼 번호가 리턴되고 
                   -- NG  일경우 lvs_ng_message 참조
                   -- OK  일경우 lvs_ok_message 참조 
                   P_INTERLOCK_CHECK (lvs_line_code , LVS_WORKSTAGE_CODE , :NEW.EQUIPMENTID ,  :new.pid , C_VAR.interlock_check_type , lvs_nsnp_status , lvs_message , lvs_ng_message , lvs_ok_message ) ;       
            
                 ----------------------------------------------------------------------
                  -- 라인별 블럭킹 상태 체크 및 NSNP 동작처리 
                  --  p_interlock_set_nsnp_time_msg 파라메터 
                  --   p_line_code            IN VARCHAR2,
                  --   p_message              IN VARCHAR2,
                  --   p_time                 IN NUMBER,
                  --   p_model_name           IN VARCHAR2 DEFAULT '*',
                  --   p_model_suffix         IN VARCHAR2 DEFAULT '*',
                  --   p_nsnp_reason          IN VARCHAR2 DEFAULT '*',
                  --   p_nsnp_error_message   IN VARCHAR2 DEFAULT '*'
                  ----------------------------------------------------------------------       
                  
                  
                  if lvs_nsnp_status = 'OK' then   
                        -- NSNP 해제
                        if nvl(lvs_nsnp_status_prev , '*') = lvs_nsnp_status then 
                             --이전 상태랑 같으면 무시 
                             null ; 
                        else
                          --이전 상태가 잠긴 상태 였으면 풀어줌 
                          lvs_ok_message := C_VAR.interlock_check_type ;
                          
                     --     P_INTERLOCK_SET_NSNP_TIME_MSG2( lvs_line_code , '0' , 1 , :new.pid, '*' ,  lvs_message , lvs_ok_message  ) ;
                          lvs_nsnp_status_prev := lvs_nsnp_status ;
                        end if ; 
                  else
                          -- NSNP 동작 
                          if nvl(lvs_nsnp_status_prev , '*') = lvs_nsnp_status then 
                              null ; 
                          else
                          
                              BEGIN
                                
                                  P_INTERLOCK_SET_NSNP_TIME_MSG2( lvs_line_code , '1' , 1 , :new.pid, '*' , lvs_message , lvs_ng_message  ) ; 
                                  lvs_nsnp_status_prev := lvs_nsnp_status ;
                                  exit ;
                              
                              EXCEPTION
                                   WHEN OTHERS THEN
                                        NULL;
                                      
                              END;
                              
                          end if ;
                  end if ;
        
              END LOOP;
            
      END IF ;
    ------------------------------------------------------------
    -- IQ_MACHINE_INSPECT_AOI 에 수집이력 저장
    ------------------------------------------------------------
    BEGIN 
      
    INSERT INTO IQ_MACHINE_INSPECT_AOI (
                                        CSTID, 
                                        SEQ_NO, 
                                        PID, 
                                        EQUIPMENTID, 
                                        INSPECT_DATE, 
                                        RESULT, 
                                        DEFECT_CODE, 
                                        ENTER_DATE, 
                                        ENTER_BY, 
                                        LAST_MODIFY_DATE, 
                                        LAST_MODIFY_BY, 
                                        ORGANIZATION_ID, 
                                        FILE_NAME, 
                                        ARRAY_NO, 
                                        RUN_NO, 
                                        LINE_CODE, 
                                        C7,
                                        REVIEW_DATE,
                                        REVIEW_RESULT
                                       )
    SELECT :NEW.CSTID, 
           :NEW.SEQ_NO, 
           :NEW.PID, 
           :NEW.EQUIPMENTID, 
           :NEW.INSPECT_DATE, 
           :NEW.RESULT, 
           :NEW.DEFECT_CODE, 
           :NEW.ENTER_DATE, 
           :NEW.ENTER_BY, 
           :NEW.LAST_MODIFY_DATE, 
           :NEW.LAST_MODIFY_BY, 
           :NEW.ORGANIZATION_ID, 
           :NEW.FILE_NAME, 
           :NEW.ARRAY_NO, 
           :NEW.RUN_NO, 
           :NEW.LINE_CODE, 
           :NEW.C7,
           :NEW.REVIEW_DATE,
           :NEW.REVIEW_RESULT
      FROM DUAL;
      
    EXCEPTION 
         WHEN OTHERS THEN 
              NULL ;
    END ;   
    
    ------------------------------------------------------------
    -- 최종데이타만 남도록 삭제
    ------------------------------------------------------------
     
 --   DELETE IQ_MACHINE_INSPECT_DATA_AOI
 --    WHERE PID             = :NEW.PID
 --      AND ORGANIZATION_ID = :NEW.ORGANIZATION_ID; 
       
-- ------------------------------------------------------------------------------
-- --실적취합 프로시져 호출 
-- ------------------------------------------------------------------------------
-- 
--        
--    LVS_OUT := '*';
--             
--  
--              
--    P_SET_WORKSTAGE_SCAN_IN(    :NEW.PID,         --  P_SERIAL    IN VARCHAR2, 
--                                :NEW.LINE_CODE,   --  P_LINE      IN VARCHAR2, 
--                                LVS_WORKSTAGE_CODE,           --  P_WORKSTAGE IN VARCHAR2, 
--                                1,                --  P_ORGID     IN NUMBER, 
--                                'I',              --  P_TYPE      IN VARCHAR2, 
--                                LVS_OUT,          --  P_OUT       OUT VARCHAR2, 
--                                LVS_MSG           --  P_MSG       OUT VARCHAR2
--                          ) ;      
--                                  
--   IF ( LVS_OUT = 'OK' ) THEN
--             
        UPDATE IP_PRODUCT_RUN_CARD
           SET RUN_STATUS = '5'
         WHERE RUN_NO = :NEW.RUN_NO
           AND NVL(RUN_STATUS,'0') < '5';
--            
--   END IF;
            

  

 ------------------------------------------------------------------------------    
        

EXCEPTION
    WHEN OTHERS THEN
   
        raise_application_error (
                                 -20003, 
                                 'AOI INS TRRIGER ERROR '
                                 || ' '
                                 || SQLERRM
                                 );
END;
