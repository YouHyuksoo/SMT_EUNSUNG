CREATE OR REPLACE TRIGGER TRG_IQ_MAC_INSPECT_DATA_MK_BEF
  /* ================================================================
   * 트리거명  : TRG_IQ_MAC_INSPECT_DATA_MK_BEF
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IQ_MACHINE_INSPECT_DATA_MK 테이블의 INSERT 발생 시 생산/검사 실적 관련 값을 자동 보정하거나 이력을 갱신한다.
   *   제품 실적, 검사 결과, 공정 흐름의 데이터 정합성을 유지하기 위한 트리거로 추정된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IQ_MACHINE_INSPECT_DATA_MK - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.RUN_NO - 신규/변경 후 작업지시/런 관련 값
   *   :NEW.PID - 신규/변경 후 제품 식별자 관련 값
   *   :NEW.LOTID - 신규/변경 후 값 값
   *   :NEW.LINE_CODE - 신규/변경 후 라인 관련 값
   *   :NEW.EQUIPMENTID - 신규/변경 후 값 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IQ_MACHINE_INSPECT_DATA_MK - 설비 / 검사 관련 트리거 대상 테이블
   *   IQ_INTERLOCK_CHECK_CONDITION - 인터락 관련 트리거 내부 SQL에서 참조/변경
   *   IP_PRODUCT_2D_BARCODE - 제품 / 바코드 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_LINE_CODE_BY_RUN_NO - 트리거 내부 업무 처리 호출
   *   P_INTERLOCK_CHECK - 트리거 내부 업무 처리 호출
   *   P_INTERLOCK_SET_NSNP_TIME_MSG2 - 트리거 내부 업무 처리 호출
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 10회 / 반복문: 3회
   *   DML: SELECT 2회, INSERT 1회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_IQ_MAC_INSPECT_DATA_MK_BEF';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_IQ_MAC_INSPECT_DATA_MK_BEF';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */

  before insert on iq_machine_inspect_data_mk  
  for each row
declare
  /*SMT 공정 통과 WORKSTAGE IO 에 입력 테스트*/
  V_OUT                 VARCHAR2(4000); 
  V_MSG                 VARCHAR2(4000); 
  LVS_OUT               VARCHAR2(4000); 
  
  LVS_MSG               VARCHAR2(4000); 
  
  lvs_nsnp_status       VARCHAR2(30);
  lvs_nsnp_status_prev  VARCHAR2(30);
  lvs_line_code         VARCHAR2(30);
  lvs_type              VARCHAR2(100);
  lvs_message           VARCHAR2(1000);
  lvs_ng_message        VARCHAR2(1000);
  lvs_ok_message        VARCHAR2(1000);
  LVS_ERROR_MESSAGE     VARCHAR2(2000);
  
  CURSOR CL1 IS 
          SELECT interlock_check_type, check_sequence
            FROM iq_interlock_check_condition
           WHERE line_code         = lvs_line_code 
             AND workstage_code    = 'W010'  
             AND NVL (use_yn, 'Y') = 'Y'
        ORDER BY check_sequence ASC;
   
    BEGIN
    
    
    -----------------------------------------------------------
    -- PID 확인
    -----------------------------------------------------------
      
     --    IF ( :NEW.RUN_NO = 'NULL' OR :NEW.RUN_NO = ''  OR :NEW.RUN_NO IS NULL ) THEN
           
              BEGIN
                 
                  SELECT RUN_NO
                    INTO :NEW.RUN_NO
                    FROM IP_PRODUCT_2D_BARCODE
                   WHERE serial_no       = :NEW.PID
                    ;     
                  
               EXCEPTION 
                     WHEN OTHERS THEN 
                          :NEW.RUN_NO := 'NULL';
               END;
           
    --     END IF;
         
      :new.pid      := nvl(:new.pid, 'NULL') ;
      :new.LOTID    := nvl(:new.LOTID, 'NULL') ;
          
    -----------------------------------------------------------
    -- INTLOCK 확인
    ----------------------------------------------------------- 
    
      IF ( NVL(:NEW.LINE_CODE,'*') = '*' ) THEN
         lvs_line_code := F_GET_LINE_CODE_BY_RUN_NO( :NEW.LOTID ,1 ) ;  
      ELSE     
         lvs_line_code := NVL(:NEW.LINE_CODE,'*');
      END IF;  
    
      FOR C_VAR IN CL1 LOOP
      
      
           -- P_mESSAGE 는 시리얼 번호가 리턴되고 
           -- NG  일경우 lvs_ng_message 참조
           -- OK  일경우 lvs_ok_message 참조 
           P_INTERLOCK_CHECK (lvs_line_code , 'W010' , :NEW.EQUIPMENTID ,  :new.pid , C_VAR.interlock_check_type , lvs_nsnp_status , lvs_message , lvs_ng_message , lvs_ok_message ) ;       
    
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
                  
               --   P_INTERLOCK_SET_NSNP_TIME_MSG2( lvs_line_code , '0' , 1 , :new.pid, '*' ,  lvs_message , lvs_ok_message  ) ;
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
                 
          
--    -----------------------------------------------------------
--    -- 공정투입실적 처리
--    -----------------------------------------------------------
--             
--    P_SET_WORKSTAGE_SCAN_IN(    :NEW.PID,         --  P_SERIAL    IN VARCHAR2, 
--                                :NEW.LINE_CODE,   --  P_LINE      IN VARCHAR2, 
--                                'W010',           --  P_WORKSTAGE IN VARCHAR2, 
--                                1,                --  P_ORGID     IN NUMBER, 
--                                'I',              --  P_TYPE      IN VARCHAR2, 
--                                LVS_OUT,          --  P_OUT       OUT VARCHAR2, 
--                                LVS_MSG           --  P_MSG       OUT VARCHAR2
--                            ) ;  
--                                      
 
 
EXCEPTION 
  WHEN OTHERS THEN 
        RAISE_APPLICATION_ERROR(-20003,SQLERRM ) ;
end;
