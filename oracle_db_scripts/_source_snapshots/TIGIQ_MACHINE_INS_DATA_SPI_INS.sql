TRIGGER TIGIQ_MACHINE_INS_DATA_SPI_INS
 BEFORE INSERT ON IQ_MACHINE_INSPECT_DATA_SPI
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW
DECLARE
   LVI_COUNT            NUMBER ;
   LVS_RUN_NO           VARCHAR2(30);
   LVS_WORKSTAGE_CODE   VARCHAR2(30);
   
   LVS_OUT VARCHAR2(4000); 
   LVS_MSG VARCHAR2(4000); 

  lvs_nsnp_status       VARCHAR2(30);
  lvs_nsnp_status_prev  VARCHAR2(30);
  lvs_line_code         VARCHAR2(30);
  lvs_type              VARCHAR2(100);
  lvs_message           VARCHAR2(1000);
  lvs_ng_message        VARCHAR2(1000);
  lvs_ok_message        VARCHAR2(1000);
  LVS_ERROR_MESSAGE     VARCHAR2(2000);
  LVL_HIT_VALUE        NUMBER;  
  
  CURSOR CL1 IS 
          SELECT interlock_check_type, check_sequence
            FROM iq_interlock_check_condition
           WHERE line_code         = lvs_line_code 
             AND workstage_code    = 'W030'  
             AND NVL (use_yn, 'Y') = 'Y'
        ORDER BY check_sequence ASC;
            
BEGIN
 
             IF ( :NEW.PID IS NULL ) THEN
                  :NEW.PID := 'NULL';
             END IF;
    ------------------------------------------------------------
    -- 해당라인의 진행중인 RUN NO을 가져온다
    ------------------------------------------------------------

              BEGIN
                 
                  SELECT RUN_NO
                    INTO :NEW.RUN_NO
                    FROM IP_PRODUCT_2D_BARCODE
                   WHERE serial_no       = :NEW.PID
                     AND ORGANIZATION_ID = :NEW.ORGANIZATION_ID;     
                  
               EXCEPTION 
                     WHEN OTHERS THEN 
                          :NEW.RUN_NO := '*';
               END;
    -----------------------------------------------------------
    -- INTLOCK 확인
    ----------------------------------------------------------- 
   
      IF ( NVL(:NEW.LINE_CODE,'*') = '*' ) THEN
         lvs_line_code := F_GET_LINE_CODE_BY_RUN_NO( :NEW.RUN_NO ,1 ) ;  
      ELSE     
         lvs_line_code := NVL(:NEW.LINE_CODE,'*');
      END IF;  
      
      :NEW.CSTID         :=:NEW.CSTID||' '||'LINE='||lvs_line_code||' WS='||'W030'   ;     
      LVS_WORKSTAGE_CODE := 'W030';
 
      FOR C_VAR IN CL1 LOOP
      
      
           -- P_mESSAGE 는 시리얼 번호가 리턴되고 
           -- NG  일경우 lvs_ng_message 참조
           -- OK  일경우 lvs_ok_message 참조 
           P_INTERLOCK_CHECK (lvs_line_code , LVS_WORKSTAGE_CODE , :NEW.EQUIPMENTID ,  :new.pid , C_VAR.interlock_check_type , lvs_nsnp_status , lvs_message , lvs_ng_message , lvs_ok_message ) ;       

        IF C_VAR.interlock_check_type = 'LCR_STATUS_CHECK' THEN 
           :NEW.CSTID := :NEW.CSTID||' '||C_VAR.interlock_check_type||' '||lvs_nsnp_status||' MSG='|| lvs_ok_message;   
        END IF ;
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
    -- IQ_MACHINE_INSPECT_SPI 에 수집이력 저장
    ------------------------------------------------------------
    IF  :NEW.PID = 'NULL' OR :NEW.PID IS NULL THEN 
      NULL ;
    ELSE
        INSERT INTO IQ_MACHINE_INSPECT_SPI (
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
                                            RESULT_GROUP
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
                                            :NEW.RESULT_GROUP
                                       FROM DUAL;
     END IF ;
 
    ------------------------------------------------------------
    -- 최종데이타만 남도록 삭제
    ------------------------------------------------------------

    -- DELETE IQ_MACHINE_INSPECT_DATA_SPI
    --   WHERE PID             = :NEW.PID
    --     AND ORGANIZATION_ID = :NEW.ORGANIZATION_ID;      
       
-- ------------------------------------------------------------------------------
-- --실적취합 프로시져 호출 
-- ------------------------------------------------------------------------------
--
--                                
--    LVS_OUT := '*';
--                                
--    P_SET_WORKSTAGE_SCAN_IN(    :NEW.PID,         --  P_SERIAL    IN VARCHAR2, 
--                                :NEW.LINE_CODE,   --  P_LINE      IN VARCHAR2, 
--                                LVS_WORKSTAGE_CODE,           --  P_WORKSTAGE IN VARCHAR2, 
--                                1,                --  P_ORGID     IN NUMBER, 
--                                'I',              --  P_TYPE      IN VARCHAR2, 
--                                LVS_OUT,          --  P_OUT       OUT VARCHAR2, 
--                                LVS_MSG           --  P_MSG       OUT VARCHAR2
--                            ) ;       
--                            
--    IF ( LVS_OUT = 'OK' ) THEN

--   BEGIN
--         ----------------------------------------------------------------
--         --  지그 사용 이력을 업데이트 한다
--         --  공정코드에 'ALL' 을 입력하면 모든 지그를 한꺼번에
--         --  사용수량을 증가 한다.
--         ----------------------------------------------------------------
--   
--         P_INTERLOCK_SET_JIG (:NEW.LINE_CODE,
--                              'ALL',                                 -- 공정 또는 ALL
--                              'SP',
--                              LVS_OUT,
--                              LVL_HIT_VALUE);
--      EXCEPTION
--         WHEN OTHERS
--         THEN
--            NULL;
--      END;
      
         UPDATE IP_PRODUCT_RUN_CARD
            SET RUN_STATUS = '4'
          WHERE RUN_NO = :NEW.RUN_NO
            AND NVL(RUN_STATUS,'0') < '4';            
--    END IF;

    
    ------------------------------------------------------------
    -- NG 발생시 라인정지 발생
    ------------------------------------------------------------
    
    IF ( NVL(:NEW.RESULT, 'NULL') in ( 'NO', 'NG', 'NULL' ) and :new.line_code in ( '05','06','07','08', '09' ) ) THEN
      
      ---NULL;
      
         
         P_INTERLOCK_SET_NSNP_TIME_MSG2( :new.line_code , '1' , 1 , :new.pid, '*' , 'TIGIQ_MACHINE_INS_DATA_SPI_INS' , 'SPI NG 발생 => '||NVL(:new.result,'NULL')  ) ;
      
    END iF;
    
                                                                         
 ------------------------------------------------------------------------------       

EXCEPTION
    WHEN OTHERS THEN
      
         NULL;
   
   /*    
         raise_application_error (
                                 -20003, 
                                 'SPI INS TRRIGER ERROR '
                                 || ' '
                                 || SQLERRM
                                 );
   */
END;
