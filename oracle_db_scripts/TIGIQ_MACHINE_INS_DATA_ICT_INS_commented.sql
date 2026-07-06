CREATE OR REPLACE TRIGGER TIGIQ_MACHINE_INS_DATA_ICT_INS
  /* ================================================================
   * 트리거명  : TIGIQ_MACHINE_INS_DATA_ICT_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IQ_MACHINE_INSPECT_DATA_ICT 테이블의 INSERT 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IQ_MACHINE_INSPECT_DATA_ICT - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.RUN_NO - 신규/변경 후 작업지시/런 관련 값
   *   :NEW.PID - 신규/변경 후 제품 식별자 관련 값
   *   :NEW.ORGANIZATION_ID - 신규/변경 후 값 값
   *   :NEW.RESULT - 신규/변경 후 실적 관련 값
   *   :NEW.LINE_CODE - 신규/변경 후 라인 관련 값
   *   :NEW.EQUIPMENTID - 신규/변경 후 값 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IQ_MACHINE_INSPECT_DATA_ICT - 설비 / 검사 관련 트리거 대상 테이블
   *   IQ_INTERLOCK_CHECK_CONDITION - 인터락 관련 트리거 내부 SQL에서 참조/변경
   *   IP_PRODUCT_2D_BARCODE - 제품 / 바코드 관련 트리거 내부 SQL에서 참조/변경
   *   IP_PRODUCT_LINE - 제품 / 라인 관련 트리거 내부 SQL에서 참조/변경
   *   IMCN_JIG - 지그 관련 트리거 내부 SQL에서 참조/변경
   *   IMCN_SAMPLE_BCR_INPUT_HIST - 업무 데이터 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_LINE_CODE_BY_RUN_NO - 트리거 내부 업무 처리 호출
   *   P_INTERLOCK_CHECK - 트리거 내부 업무 처리 호출
   *   P_INTERLOCK_SET_NSNP_TIME_MSG2 - 트리거 내부 업무 처리 호출
   *   P_SET_WORKSTAGE_SCAN_IN - 트리거 내부 업무 처리 호출
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 13회 / 반복문: 3회
   *   DML: SELECT 5회, INSERT 2회, UPDATE 1회, DELETE 2회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TIGIQ_MACHINE_INS_DATA_ICT_INS';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TIGIQ_MACHINE_INS_DATA_ICT_INS';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */

 BEFORE INSERT ON IQ_MACHINE_INSPECT_DATA_ICT
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW
DECLARE

   LVI_COUNT           NUMBER ;
   LVS_RUN_NO          VARCHAR2(30); 
   
    LVS_OUT             VARCHAR2(4000); 
    LVS_MSG             VARCHAR2(4000);   
    
  lvs_nsnp_status       VARCHAR2(30);
  lvs_nsnp_status_prev  VARCHAR2(30);
  lvs_line_code         VARCHAR2(30);
  lvs_type              VARCHAR2(100);
  lvs_message           VARCHAR2(1000);
  lvs_ng_message        VARCHAR2(1000);
  lvs_ok_message        VARCHAR2(1000);
  LVS_ERROR_MESSAGE     VARCHAR2(2000);
  
  lvs_sample_code       VARCHAR2(30);
  lvs_sample_lot_no     VARCHAR2(30);
  lvs_sample_section    VARCHAR2(30);
  lvs_sample_type       VARCHAR2(30);
  
  lvl_sample_count      number;
  
  lvs_line_run_no       VARCHAR2(100); 
  lvs_line_model_name   VARCHAR2(100);
  
  LVS_WORKSTAGE_CODE    VARCHAR2(30);
  
  CURSOR CL1 IS 
          SELECT interlock_check_type, check_sequence
            FROM iq_interlock_check_condition
           WHERE line_code         = lvs_line_code 
             AND workstage_code    = 'W090'  
             AND NVL (use_yn, 'Y') = 'Y'
        ORDER BY check_sequence ASC;      
    
BEGIN
  
     
  
 --   IF ( :NEW.RUN_NO = 'NULL' OR :NEW.RUN_NO = ''  OR :NEW.RUN_NO IS NULL ) THEN
           
              BEGIN
                 
                  SELECT RUN_NO
                    INTO :NEW.RUN_NO
                    FROM IP_PRODUCT_2D_BARCODE
                   WHERE serial_no       = :NEW.PID
                     AND ORGANIZATION_ID = :NEW.ORGANIZATION_ID;     
                  
               EXCEPTION 
                     WHEN OTHERS THEN 
                          :NEW.RUN_NO := 'NULL';
               END;
         
  --  END IF;
    
    :new.pid    := nvl(:new.pid, 'NULL') ;
                                                                
 
    ------------------------------------------------------------
    -- 양불 마스터 sample 이지 확인하여 통과이력 남김
    ------------------------------------------------------------
  
   BEGIN
     
         lvl_sample_count := 0;
       
         select s.sample_type, s.sample_code, s.sample_lot_no, s.sample_section, 1, l.run_no, l.model_name
           into lvs_sample_type, lvs_sample_code, lvs_sample_lot_no, lvs_sample_section, lvl_sample_count,  lvs_line_run_no, lvs_line_model_name
           from ip_product_line l,
                imcn_sample     s
          where ( l.sample_ict_lot_no  = s.sample_lot_no or l.sample_ict_lot_no2  = s.sample_lot_no )
            and l.line_code      = lvs_line_code
        --    and s.sample_barcode like regexp_substr(:NEW.PID,'[^-]+',1,1)||'%'
            and s.sample_barcode = :NEW.PID
            and rownum = 1;
   
        -- IF ( ( lvl_sample_count = 1 ) AND ( substr( :NEW.PID, instr( :NEW.PID, '-' )+1, 2 ) = '01' ) ) THEN
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
    
     -----------------------------------------------------------
    -- INTLOCK 확인
    ----------------------------------------------------------- 
    
      IF ( NVL(:NEW.LINE_CODE,'*') = '*' ) THEN
         lvs_line_code := F_GET_LINE_CODE_BY_RUN_NO( :NEW.RUN_NO ,1 ) ;  
      ELSE     
         lvs_line_code := NVL(:NEW.LINE_CODE,'*');
      END IF;  
      
      LVS_WORKSTAGE_CODE := 'W090';
    
      FOR C_VAR IN CL1 LOOP
      
      
           -- P_mESSAGE 는 시리얼 번호가 리턴되고 
           -- NG  일경우 lvs_ng_message 참조
           -- OK  일경우 lvs_ok_message 참조 
           P_INTERLOCK_CHECK (lvs_line_code , LVS_WORKSTAGE_CODE, :NEW.EQUIPMENTID ,  :new.pid , C_VAR.interlock_check_type , lvs_nsnp_status , lvs_message , lvs_ng_message , lvs_ok_message ) ;       
    
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
      
    ------------------------------------------------------------
    -- 최종데이타만 남도록 삭제
    ------------------------------------------------------------

 --   DELETE IQ_MACHINE_INSPECT_DATA_ICT
 --    WHERE PID             = :NEW.PID
 --      AND ORGANIZATION_ID = :NEW.ORGANIZATION_ID; 
       
 --   DELETE IQ_MACHINE_INSPECT_DATA_ICT
 --    WHERE PID             = 'NULL' ;   
 
 
    ------------------------------------------------------------
    -- FIXTURE JIG 사용횟수 반영
    ------------------------------------------------------------
    
  update imcn_jig
     set hit_value = hit_value +1
   where jig_lot_no in (
                        select fixture_lot_no
                          from ip_product_line
                         where line_code = :NEW.LINE_CODE 
                        );
                      
                    
                      
  ------------------------------------------------------------------------------
 --실적취합 프로시져 호출 
 ------------------------------------------------------------------------------
 
             P_SET_WORKSTAGE_SCAN_IN(   
                                        :NEW.PID,         --  P_SERIAL    IN VARCHAR2, 
                                        :NEW.LINE_CODE,   --  P_LINE      IN VARCHAR2, 
                                        LVS_WORKSTAGE_CODE,           --  P_WORKSTAGE IN VARCHAR2, 
                                        1,                --  P_ORGID     IN NUMBER, 
                                        'I',              --  P_TYPE      IN VARCHAR2, 
                                        LVS_OUT,          --  P_OUT       OUT VARCHAR2, 
                                        LVS_MSG           --  P_MSG       OUT VARCHAR2
                                  ) ;       
                                                                 
                                       
EXCEPTION
    WHEN OTHERS THEN
   
        raise_application_error (
                                 -20003, 
                                 'ICT INS TRRIGER ERROR '
                                 || ' '
                                 || SQLERRM
                                 );
END;
