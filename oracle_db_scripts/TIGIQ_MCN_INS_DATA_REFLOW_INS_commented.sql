CREATE OR REPLACE TRIGGER TIGIQ_MCN_INS_DATA_REFLOW_INS
  /* ================================================================
   * 트리거명  : TIGIQ_MCN_INS_DATA_REFLOW_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IQ_MACHINE_INSPECT_DATA_REFLOW 테이블의 INSERT 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IQ_MACHINE_INSPECT_DATA_REFLOW - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.LINE_CODE - 신규/변경 후 라인 관련 값
   *   :NEW.MACHINE_CODE - 신규/변경 후 설비 관련 값
   *   :NEW.OXYGEN_CONCENTRATION - 신규/변경 후 값 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IQ_MACHINE_INSPECT_DATA_REFLOW - 설비 / 검사 관련 트리거 대상 테이블
   *   IQ_INTERLOCK_CHECK_CONDITION - 인터락 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 호출 객체:
   *   P_INTERLOCK_CHECK - 트리거 내부 업무 처리 호출
   *   P_INTERLOCK_SET_NSNP_TIME_MSG2 - 트리거 내부 업무 처리 호출
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 6회 / 반복문: 3회
   *   DML: SELECT 1회, INSERT 1회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TIGIQ_MCN_INS_DATA_REFLOW_INS';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TIGIQ_MCN_INS_DATA_REFLOW_INS';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */

 BEFORE INSERT ON IQ_MACHINE_INSPECT_DATA_REFLOW
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW
DECLARE
    
   LVS_WORKSTAGE_CODE    VARCHAR2(30);
   
   lvs_nsnp_status       VARCHAR2(30);
   lvs_nsnp_status_prev  VARCHAR2(30);
   lvs_line_code         VARCHAR2(30);
   lvs_message           VARCHAR2(1000);
   lvs_ng_message        VARCHAR2(1000);
   lvs_ok_message        VARCHAR2(1000);
  
    CURSOR CL1 IS 
          SELECT interlock_check_type, check_sequence
            FROM iq_interlock_check_condition
           WHERE line_code         = lvs_line_code 
             AND workstage_code    = 'W050'  
             AND NVL (use_yn, 'Y') = 'Y'
           ORDER BY check_sequence ASC;
  
BEGIN
  
  NULL;   
  
      lvs_line_code      := NVL(:NEW.LINE_CODE,'*');       
      LVS_WORKSTAGE_CODE := 'W050';
 
      FOR C_VAR IN CL1 LOOP
      
      
           -- P_mESSAGE 는 시리얼 번호가 리턴되고 
           -- NG  일경우 lvs_ng_message 참조
           -- OK  일경우 lvs_ok_message 참조 
           
           -- PID 대신 산소농도를 parameter에 넘긴다
           P_INTERLOCK_CHECK (lvs_line_code , LVS_WORKSTAGE_CODE , :NEW.MACHINE_CODE ,  :new.oxygen_concentration , C_VAR.interlock_check_type , lvs_nsnp_status , lvs_message , lvs_ng_message , lvs_ok_message ) ;       

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
                  
              --    P_INTERLOCK_SET_NSNP_TIME_MSG2( lvs_line_code , '0' , 1 , :new.pid, '*' ,  lvs_message , lvs_ok_message  ) ;
                  lvs_nsnp_status_prev := lvs_nsnp_status ;
                end if ; 
          else
    
                  -- NSNP 동작 
                  if nvl(lvs_nsnp_status_prev , '*') = lvs_nsnp_status then 
                      null ; 
                  else
                  
                      BEGIN
                        
                           P_INTERLOCK_SET_NSNP_TIME_MSG2( lvs_line_code , '1' , 1 , :new.oxygen_concentration, '*' , lvs_message , lvs_ng_message  ) ; 
                           lvs_nsnp_status_prev := lvs_nsnp_status ;
                           exit ;
                      
                      EXCEPTION
                           WHEN OTHERS THEN
                                NULL;
                                      
                      END;                
                      
                  end if ;
          end if ;

      END LOOP;
      
  
EXCEPTION
    WHEN OTHERS THEN
   
        raise_application_error (
                                 -20003, 
                                 'REFLOW INS TRRIGER ERROR '
                                 || ' '
                                 || SQLERRM
                                 );
                                 
END;
