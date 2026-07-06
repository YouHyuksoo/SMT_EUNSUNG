CREATE OR REPLACE PROCEDURE P_CHECK_PDA_TB_INOUT_PS_USER (
  /* ================================================================
   * 프로시저명  : P_CHECK_PDA_TB_INOUT_PS_USER
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   입력 조건을 기준으로 업무 데이터의 유효성 또는 상태를 확인한다.
   *   조회 결과와 원본 분기 조건에 따라 OUT 파라미터 또는 상태 값을 설정한다.
   *   호출부가 결과 코드와 메시지로 후속 처리를 판단할 수 있게 한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_LINE_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_FEEDER_LAYOUT_NAME - 원본 선언부 기준 입력/출력 파라미터
   *   P_TOPBOT - 원본 선언부 기준 입력/출력 파라미터
   *   P_INOUT - 원본 선언부 기준 입력/출력 파라미터
   *   P_PS - 원본 선언부 기준 입력/출력 파라미터
   *   P_ERR - 원본 선언부 기준 입력/출력 파라미터
   *   P_USERID - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IB_PRODUCT_PLANDATA - 원본 로직 참조 테이블
   *   IB_SMT_LINE_ONOFF_HISTORY - 원본 로직 참조 테이블
   *   IMCN_JIG - 원본 로직 참조 테이블
   *   IMCN_JIG_APPLY_MODEL - 원본 로직 참조 테이블
   *   IMCN_JIG_INPUT_HIST - 원본 로직 참조 테이블
   *   IMCN_SAMPLE - 원본 로직 참조 테이블
   *   IMCN_SAMPLE_INPUT_HIST - 원본 로직 참조 테이블
   *   IM_ITEM_SOLDER_INPUT_HIST - 원본 로직 참조 테이블
   *   IM_ITEM_SOLDER_MASTER - 원본 로직 참조 테이블
   *   IP_PRODUCT_LINE - Product Line Master
   *   IP_PRODUCT_MODEL_MASTER - 원본 로직 참조 테이블
   *   IP_PRODUCT_RUN_CARD - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_MSG
   *   P_INTERLOCK_RESET_LINE
   *   P_INTERLOCK_SET_NSNP_TIME_MSG
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_CHECK_PDA_TB_INOUT_PS_USER(...)
   * ================================================================ */
   p_line_code            IN     VARCHAR2,
   P_FEEDER_LAYOUT_NAME   IN     VARCHAR2,  -- RUN_NO
   p_topbot               IN     VARCHAR2,
   p_inout                IN     VARCHAR2,
   P_PS                   IN     VARCHAR2,  -- 양산 샘플 장착 구분 
   p_err                  OUT    VARCHAR2,
   p_userid               IN     VARCHAR2)
IS

   phase                     varchar2(10) ; -- [AI] 내부 처리용 변수
   
   lvi_count                 NUMBER; -- [AI] 내부 처리용 변수
   LVS_OUT                   VARCHAR2 (1000); -- [AI] 내부 처리용 변수

   LVS_RUN_NO                VARCHAR2 (50);    -- [AI] 내부 처리용 변수
   LVS_MASTER_MODEL_NAME     VARCHAR2 (50); -- [AI] 내부 처리용 변수
   LVS_MODEL_NAME            VARCHAR2 (50); -- [AI] 내부 처리용 변수
   LVS_SMT_MODEL_NAME        VARCHAR2 (50); -- [AI] 내부 처리용 변수
   LVS_ITEM_CODE             VARCHAR2 (50); -- [AI] 내부 처리용 변수
   
   LVS_SET_SMT_MODEL_NAME    VARCHAR2 (50); -- [AI] 내부 처리용 변수
   LVS_SET_FEEDER_MODEL_NAME VARCHAR2 (50); -- [AI] 내부 처리용 변수
   
   LVS_FEEDER_MODEL_NAME     VARCHAR2 (50); -- [AI] 내부 처리용 변수
   LVS_run_model             VARCHAR2 (50);   -- [AI] 내부 처리용 변수
   LVS_run_pcb_item          VARCHAR2 (50);   -- [AI] 내부 처리용 변수
   LVS_RUN_RUN_NO            VARCHAR2 (50);   -- [AI] 내부 처리용 변수
   
   LVS_PCB_ITEM              VARCHAR2 (50);   -- [AI] 내부 처리용 변수
   LVS_LAST_MODEL_NAME       VARCHAR2 (50); -- [AI] 내부 처리용 변수
   LVS_LAST_RUN_NO           VARCHAR2 (50); -- [AI] 내부 처리용 변수
   LVS_LAST_PCB_ITEM         VARCHAR2 (50); -- [AI] 내부 처리용 변수
   LVS_SOLDER_TYPE           VARCHAR2 (1); -- [AI] 내부 처리용 변수
   LVI_APPLY_MODEL_CHECK NUMBER ; -- [AI] 내부 처리용 변수
   LVS_last_mask_lot_no VARCHAR2(50) ; -- [AI] 내부 처리용 변수
   
   LVS_CHK_RUN_NO            VARCHAR2 (50);  -- [AI] 내부 처리용 변수
   
   
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
  
   LVS_RUN_NO := P_FEEDER_LAYOUT_NAME;
   -- LINE ON ***************************************************************************************************************
   IF p_inout = '1' THEN    
   
      ---------------------------------------------
      -- RUN CARD 등록여부 확인
      ---------------------------------------------
      phase     := '10' ;
      lvi_count := 0;
      
      BEGIN
        
         SELECT COUNT (*), MAX(MASTER_MODEL_NAME), MAX(MODEL_NAME), MAX(PCB_ITEM)
           INTO lvi_count, LVS_MASTER_MODEL_NAME,  LVS_MODEL_NAME, LVS_PCB_ITEM
           FROM ip_product_run_card
          WHERE run_no = LVS_RUN_NO;

      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND THEN
              lvi_count := 0;
      END;
      
      IF nvl(lvi_count ,0) = 0 THEN
         P_ERR := f_msg('[INOUT PS] 런카드 정보가 없습니다.','K',1)   -- Run Card Notfound
                  || ' = '
                  || LVS_RUN_NO;
         RETURN;
      END IF;
      
      LVS_PCB_ITEM := p_topbot;
      
      ---------------------------------------------
      -- 모델등록 여부 확인
      ---------------------------------------------
      phase     := '20' ;      
      lvi_count := 0;
      
      BEGIN
        
         SELECT COUNT (*), MAX(SMT_MODEL_NAME), MAX(ITEM_CODE) , MAX(SOLDER_TYPE)
           INTO lvi_count, LVS_SMT_MODEL_NAME,  LVS_ITEM_CODE , LVS_SOLDER_TYPE
           FROM ip_product_model_master
          WHERE model_name = LVS_MODEL_NAME;

      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND THEN
              lvi_count := 0;
      END;
      
      IF nvl(lvi_count ,0) = 0 THEN
         P_ERR := f_msg('[INOUT PS] 모델 정보가 없습니다.','K',1)   -- Model Notfound.
                  || ' = '
                  || LVS_MODEL_NAME;
         RETURN;
      END IF;
      
      ---------------------------------------------
      -- 진행모델 확인
      ---------------------------------------------
      phase     := '25' ;      
      lvi_count := 0;
      
      BEGIN
        
         SELECT NVL(model_name, '*'), NVL(pcb_item,'*'), NVL(run_no,'*'), NVL(LAST_MODEL_NAME,'*'), NVL(LAST_RUN_NO,'*'), NVL(LAST_PCB_ITEM,'*') , NVL(last_mask_lot_no , '*')
           INTO LVS_run_model,        LVS_run_pcb_item,  LVS_RUN_RUN_NO,  LVS_LAST_MODEL_NAME,      LVS_LAST_RUN_NO,      LVS_LAST_PCB_ITEM , LVS_last_mask_lot_no
           FROM ip_product_line
          WHERE line_code = substr(p_line_code,1,2)
          ;

      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND THEN
              LVS_run_model := '*';
      END;
    
      ---------------------------------------------
      -- RUN NO인지 확인
      ---------------------------------------------   
      
       IF (LVS_RUN_NO = LVS_RUN_RUN_NO AND   LVS_PCB_ITEM =  LVS_run_pcb_item ) THEN
         
           P_ERR := f_msg('[INOUT PS] 이미 장착 되었습니다. RUN NO 입니다.','K',1)    -- Already active run no.
                    || ' = '
                    || p_line_code
                    || ', '
                    || LVS_RUN_NO
                    || ', '
                    || LVS_PCB_ITEM;
                      
             RETURN;
          
       END IF;
                    
       ---------------------------------------------
       -- 다른 라인 이미 장착여부 확인
       ---------------------------------------------
     BEGIN
        
         SELECT COUNT(*)
           INTO lvi_count
           FROM ip_product_line
          WHERE RUN_NO = P_FEEDER_LAYOUT_NAME  ;

      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND THEN
              lvi_count := 0;
      END;                  
                    
        IF lvi_count > 0 THEN
         
           P_ERR := f_msg('[INOUT PS] 다른 라인에 이미 장착 되었습니다. RUN NO 입니다.','K',1)    -- Already active run no.
                    || ' = '
                    || p_line_code
                    || ', '
                    || LVS_RUN_NO
                    || ', '
                    || LVS_PCB_ITEM;
             RETURN;
          
       END IF;  
     
                    
       ---------------------------------------------
       -- 장착여부 확인
       ---------------------------------------------
       phase     := '30' ;   
       lvi_count := 0;

       BEGIN
          SELECT COUNT(*),   MAX(MODEL_NAME),           MAX(SMT_MODEL_NAME)
            INTO lvi_count , LVS_SET_FEEDER_MODEL_NAME, LVS_SET_SMT_MODEL_NAME
            FROM ib_product_plandata
           WHERE line_code = SUBSTR(p_line_code, 1, 2)
             AND ACTIVE_YN = 'Y';
       EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
          WHEN NO_DATA_FOUND THEN
               lvi_count := 0;
       END;
          
       IF nvl(lvi_count ,0) > 0 THEN
         
          P_ERR := f_msg('[INOUT PS] 이미 장착 되었습니다. 해제를 먼저 하세요.','K',1)   -- Already exists, Need unload
                   || ' = '
                   || p_line_code
                   || ', '
                   || LVS_MODEL_NAME
                   || ', '
                   || LVS_PCB_ITEM;
          RETURN;
      
      END IF;
      
       ---------------------------------------------
       -- 장착여부 확인
       ---------------------------------------------
       phase     := '30' ;   
       lvi_count := 0;

       BEGIN
         
          SELECT COUNT(*), max(run_no)
            INTO lvi_count, LVS_CHK_RUN_NO
            FROM ip_product_line
           WHERE line_code = SUBSTR(p_line_code, 1, 2)
             AND run_no is not null;
             
       EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
          WHEN NO_DATA_FOUND THEN
               lvi_count := 0;
       END;
          
       IF nvl(lvi_count ,0) > 0 THEN
         
          P_ERR := f_msg('[INOUT PS] 이미 장착 되었습니다. 해제를 먼저 하세요.','K',1)   -- Already exists, Need unload
                   || ' = '
                   || p_line_code
                   || ', '
                   || LVS_CHK_RUN_NO
                   || ', '
                   || LVS_PCB_ITEM;
          RETURN;
      
      END IF;      
         
           
      ---------------------------------------------
      -- 피더레이아웃 등록여부 확인
      ---------------------------------------------
            phase     := '40' ;   
            lvi_count := 0;
           
            BEGIN
               select COUNT(*),  MAX(model_name) 
                 INTO lvi_count, LVS_FEEDER_MODEL_NAME
                 from ib_product_plandata
                where line_code      = SUBSTR(p_line_code, 1, 2)
                  and smt_model_name = LVS_SMT_MODEL_NAME
                  and pcb_item       = LVS_PCB_ITEM ;
                                 
            EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
               WHEN NO_DATA_FOUND THEN
                    lvi_count := 0;
            END;
                                  
            IF nvl(lvi_count ,0) = 0 THEN
               P_ERR := f_msg('[INOUT PS] 피더레이아웃정보가 없습니다.','K',1)   -- Feeder Layout Notfound.
                        || ' = '
                        || p_line_code
                        || ', '
                        || LVS_SMT_MODEL_NAME
                        || ', '
                        || LVS_PCB_ITEM;
               RETURN;
            END IF;
      
                              
      ---------------------------------------------------------
      -- 라인온 히스토리 등록 
      ---------------------------------------------------------
      phase     := '50' ;  
         
      INSERT INTO IB_SMT_LINE_ONOFF_HISTORY (
                                             LINE_CODE , 
                                             MODEL_NAME , 
                                             PCB_ITEM ,
                                             LINE_ONOFF , 
                                             LINE_ONOFF_DATE , 
                                             ENTER_BY , 
                                             ENTER_DATE , 
                                             LAST_MODIFY_BY , 
                                             LAST_MODIFY_DATE , 
                                             ORGANIZATION_ID,
                                             RUN_NO
                                            )
                                     VALUES ( SUBSTR(p_line_code,1,2) , 
                                             NVL(LVS_FEEDER_MODEL_NAME, LVS_MODEL_NAME), 
                                             LVS_PCB_ITEM , 
                                             'ON' , 
                                             SYSDATE , 
                                             p_userid , 
                                             SYSDATE , 
                                             p_userid , 
                                             SYSDATE , 
                                             1,
                                             LVS_RUN_NO
                                             );
     
      ----------------------------------------------------------------
      -- 조합된 PCB 인경우를 감안해서 마스터 모델을 저장한다
      ----------------------------------------------------------------
      phase     := '60' ;  
          
      UPDATE ib_product_plandata
         SET active_yn        = 'Y', 
             feeding_date     = SYSDATE, 
             feeding_end_date = NULL , 
             CHANGE_EVENT_COUNT = 0 ,
             feeding_count = 0
       WHERE line_code  = SUBSTR (p_line_code, 1, 2)
         AND model_name = LVS_FEEDER_MODEL_NAME
         AND pcb_item   = LVS_PCB_ITEM;

      ----------------------------------------------------------------
      -- 조합된 PCB 인경우를 감안해서 마스터 모델을 저장한다
      ----------------------------------------------------------------
      phase     := '70' ;  
   
      -----------------------------------------------------------------
      -- 메탈 마스크 적용 모델 같은지 체크 
      -----------------------------------------------------------------
        LVI_APPLY_MODEL_CHECK := 0 ;
        
        BEGIN 
        
        SELECT COUNT(*)
          INTO LVI_APPLY_MODEL_CHECK
          FROM IMCN_JIG_APPLY_MODEL
         WHERE ITEM_CODE IN  LVS_MODEL_NAME -- 신규장착 모델에도 마지막 장착된 마스크가 적용모델 이면 
           AND JIG_LOT_NO = LVS_last_mask_lot_no; --마지막 걸려던 마스크 롯트 번호 
         EXCEPTION WHEN OTHERS THEN 
             LVI_APPLY_MODEL_CHECK := 0 ;
        END ;
      -----------------------------------------------------------------    
      
   --   IF ( LVS_MODEL_NAME = LVS_LAST_MODEL_NAME ) OR LVI_APPLY_MODEL_CHECK = 1  THEN
   
   IF ( 1=2 )  THEN
        
           IF ( LVS_LAST_PCB_ITEM = LVS_PCB_ITEM ) THEN
        
            -- 라인진척 정보 생성
            
                  UPDATE IP_PRODUCT_LINE
                     SET MODEL_NAME              = LVS_MODEL_NAME ,
                         MASTER_MODEL_NAME       = LVS_MASTER_MODEL_NAME,
                         SMT_MODEL_NAME          = LVS_SMT_MODEL_NAME ,         
                         PCB_ITEM                = LVS_PCB_ITEM ,
                         PRODUCTION_TYPE         = P_PS ,
                         FEEDER_LAYOUT_NAME      = LVS_FEEDER_MODEL_NAME,
                         LAST_MODIFY_DATE        = SYSDATE,
                         RUN_NO                  = LVS_RUN_NO,
                         ITEM_CODE               = LVS_ITEM_CODE,
                         RUN_NO_CHANGED_BY       = 'PDA M',
                         RUN_DATE                = SYSDATE,
                         MASK_LOT_NO             = LAST_MASK_LOT_NO,
                         MASK_CHECK_DATE         = DECODE(LAST_MASK_LOT_NO, NULL, NULL, SYSDATE),
                         MASK_LOT_NO2            = LAST_MASK_LOT_NO2,
                         MASK_CHECK_DATE2        = DECODE(LAST_MASK_LOT_NO2, NULL, NULL, SYSDATE),
                         SQUEEZE_LOT_NO          = LAST_SQUEEZE_LOT_NO,
                         SQUEEZE_CHECK_DATE      = DECODE(LAST_SQUEEZE_LOT_NO, NULL, NULL, SYSDATE),
                         SQUEEZE_LOT_NO2         = LAST_SQUEEZE_LOT_NO2,
                         SQUEEZE_CHECK_DATE2     = DECODE(LAST_SQUEEZE_LOT_NO2, NULL, NULL, SYSDATE),
                         BACKUPBLOCK_LOT_NO      = LAST_BACKUPBLOCK_LOT_NO,
                         BACKUPBLOCK_CHECK_DATE  = DECODE(LAST_BACKUPBLOCK_LOT_NO, NULL, NULL, SYSDATE),
                         ROUTER_LOT_NO           = LAST_ROUTER_LOT_NO,
                         ROUTER_CHECK_DATE       = DECODE(LAST_ROUTER_LOT_NO, NULL, NULL, SYSDATE),
                         ROMWRITE_LOT_NO         = LAST_ROMWRITE_LOT_NO,
                         ROMWRITE_CHECK_DATE     = DECODE(LAST_ROMWRITE_LOT_NO, NULL, NULL, SYSDATE),
                         FIXTURE_LOT_NO          = LAST_FIXTURE_LOT_NO,
                         FIXTURE_CHECK_DATE      = DECODE(LAST_FIXTURE_LOT_NO, NULL, NULL, SYSDATE),
                         SAMPLE_LOT_NO           = LAST_SAMPLE_LOT_NO,
                         SAMPLE_CHECK_DATE       = DECODE(LAST_SAMPLE_LOT_NO, NULL, NULL, SYSDATE),
                         SAMPLE_LOT_NO2          = LAST_SAMPLE_LOT_NO2,
                         SAMPLE_CHECK_DATE2      = DECODE(LAST_SAMPLE_LOT_NO2, NULL, NULL, SYSDATE),
                         SAMPLE_ICT_LOT_NO       = LAST_SAMPLE_ICT_LOT_NO,
                         SAMPLE_ICT_CHECK_DATE   = DECODE(LAST_SAMPLE_ICT_LOT_NO, NULL, NULL, SYSDATE),
                         SAMPLE_ICT_LOT_NO2      = LAST_SAMPLE_ICT_LOT_NO2,
                         SAMPLE_ICT_CHECK_DATE2  = DECODE(LAST_SAMPLE_ICT_LOT_NO2, NULL, NULL, SYSDATE),                         
                         PROFILE_LOT_NO          = LAST_PROFILE_LOT_NO,
                         PROFILE_CHECK_DATE      = DECODE(LAST_PROFILE_LOT_NO, NULL, NULL, SYSDATE),
                         SOLDER_LOT_NO           = LAST_SOLDER_LOT_NO,
                         SOLDER_CHECK_DATE       = LAST_SOLDER_CHECK_DATE, 
                   --      SPEC_CHECK_STATUS       = LAST_SPEC_CHECK_STATUS,
                   --      SPEC_CHECK_DATE         = LAST_SPEC_CHECK_DATE,
                         ICT_LOT_NO              = LAST_ICT_LOT_NO,
                         ICT_CHECK_DATE          = DECODE(LAST_ICT_CHECK_DATE, NULL, NULL, SYSDATE),
                         
                         SOLDER_TYPE             = LVS_SOLDER_TYPE 
                   WHERE line_code = SUBSTR(p_line_code, 1, 2);
                  
                  -- JIG 투입이력 생성
                   
                  INSERT INTO IMCN_JIG_INPUT_HIST (
                                                   INPUT_DATE, 
                                                   LINE_CODE, 
                                                   JIG_CODE, 
                                                   JIG_LOT_NO, 
                                                   RUN_NO, 
                                                   CURRENT_HIT_VALUE, 
                                                   JIG_TYPE, 
                                                   ORGANIZATION_ID, 
                                                   ENTER_BY, 
                                                   ENTER_DATE, 
                                                   LAST_MODIFY_BY, 
                                                   LAST_MODIFY_DATE, 
                                                   MODEL_NAME
                                                  )
                  SELECT SYSDATE, 
                         LINE_CODE, 
                         JIG_CODE, 
                         JIG_LOT_NO, 
                         LVS_RUN_NO, 
                         CURRENT_HIT_VALUE, 
                         JIG_TYPE, 
                         ORGANIZATION_ID, 
                         'AUTO', 
                         sysdate, 
                         'AUTO', 
                         sysdate, 
                         MODEL_NAME
                    FROM IMCN_JIG_INPUT_HIST    
                   WHERE RUN_NO = LVS_LAST_RUN_NO;
                   
                  -- SAMPLE 투입이력 생성
         
                  INSERT INTO IMCN_SAMPLE_INPUT_HIST (
                                                      INPUT_DATE, 
                                                      LINE_CODE, 
                                                      SAMPLE_CODE, 
                                                      SAMPLE_LOT_NO, 
                                                      RUN_NO, 
                                                      current_apply_date, 
                                                      SAMPLE_TYPE, 
                                                      ORGANIZATION_ID, 
                                                      ENTER_BY, 
                                                      ENTER_DATE, 
                                                      LAST_MODIFY_BY, 
                                                      LAST_MODIFY_DATE, 
                                                      MODEL_NAME
                                                     )
                  SELECT SYSDATE, 
                         LINE_CODE, 
                         SAMPLE_CODE, 
                         SAMPLE_LOT_NO, 
                         LVS_RUN_NO, 
                         current_apply_date, 
                         SAMPLE_TYPE, 
                         ORGANIZATION_ID, 
                         'AUTO', 
                         sysdate, 
                         'AUTO', 
                         sysdate, 
                         MODEL_NAME
                    FROM IMCN_SAMPLE_INPUT_HIST    
                   WHERE RUN_NO = LVS_LAST_RUN_NO;
                   
                  UPDATE IMCN_JIG
                     SET LINE_CODE = SUBSTR(p_line_code, 1, 2)
                   WHERE JIG_LOT_NO IN (
                                            SELECT LAST_MASK_LOT_NO        FROM IP_PRODUCT_LINE WHERE LINE_CODE = SUBSTR(p_line_code, 1, 2)
                                            UNION ALL    
                                            SELECT LAST_MASK_LOT_NO2       FROM IP_PRODUCT_LINE WHERE LINE_CODE = SUBSTR(p_line_code, 1, 2)  
                                            UNION ALL   
                                            SELECT LAST_SQUEEZE_LOT_NO     FROM IP_PRODUCT_LINE WHERE LINE_CODE = SUBSTR(p_line_code, 1, 2)     
                                            UNION ALL
                                            SELECT LAST_SQUEEZE_LOT_NO2    FROM IP_PRODUCT_LINE WHERE LINE_CODE = SUBSTR(p_line_code, 1, 2)       
                                            UNION ALL
                                            SELECT LAST_BACKUPBLOCK_LOT_NO FROM IP_PRODUCT_LINE WHERE LINE_CODE = SUBSTR(p_line_code, 1, 2)      
                                            UNION ALL
                                            SELECT LAST_ROUTER_LOT_NO      FROM IP_PRODUCT_LINE WHERE LINE_CODE = SUBSTR(p_line_code, 1, 2)    
                                            UNION ALL
                                            SELECT LAST_ROMWRITE_LOT_NO    FROM IP_PRODUCT_LINE WHERE LINE_CODE = SUBSTR(p_line_code, 1, 2)       
                                            UNION ALL
                                            SELECT LAST_FIXTURE_LOT_NO     FROM IP_PRODUCT_LINE WHERE LINE_CODE = SUBSTR(p_line_code, 1, 2) 
                                       );   
                    
                  UPDATE IMCN_SAMPLE
                     SET LINE_CODE = SUBSTR(p_line_code, 1, 2)
                   WHERE SAMPLE_LOT_NO IN (
                                            SELECT LAST_SAMPLE_LOT_NO  FROM IP_PRODUCT_LINE WHERE LINE_CODE = SUBSTR(p_line_code, 1, 2) 
                                            UNION ALL    
                                            SELECT LAST_SAMPLE_LOT_NO2 FROM IP_PRODUCT_LINE WHERE LINE_CODE = SUBSTR(p_line_code, 1, 2) 
                                            UNION ALL   
                                            SELECT LAST_PROFILE_LOT_NO FROM IP_PRODUCT_LINE WHERE LINE_CODE = SUBSTR(p_line_code, 1, 2) 
                                            UNION ALL   
                                            SELECT LAST_ICT_LOT_NO     FROM IP_PRODUCT_LINE WHERE LINE_CODE = SUBSTR(p_line_code, 1, 2)
                                          );              
            
            -- 솔더 투입이력 저장
            
                  insert into im_item_solder_input_hist (
                                                          line_code, 
                                                          run_no, 
                                                          input_date, 
                                                          solder_lot_no, 
                                                          enter_date, 
                                                          enter_by, 
                                                          last_modify_date, 
                                                          last_modify_by
                                                        )
                  select line_code, run_no, solder_check_date, solder_lot_no, sysdate, 'AUTO', sysdate, 'AUTO' 
                    from ip_product_line
                   where line_code         =  SUBSTR(p_line_code, 1, 2)
                     and solder_check_date is not null
                     and solder_lot_no     is not null;
                        
            /*      
                  UPDATE IM_ITEM_SOLDER_MASTER
                     SET LINE_CODE  = SUBSTR(p_line_code, 1, 2),
                         MODEL_NAME = LVS_MODEL_NAME,
                         RUN_NO     = LVS_RUN_NO,
                         INPUT_DATE = SYSDATE,
                         open_date  = SYSDATE
                   WHERE ITEM_BARCODE = (
                                          SELECT LAST_SOLDER_LOT_NO FROM IP_PRODUCT_LINE WHERE LINE_CODE = SUBSTR(p_line_code, 1, 2)
                                        );
            */
         ELSE
           
            UPDATE IP_PRODUCT_LINE
               SET MODEL_NAME              = LVS_MODEL_NAME ,
                   MASTER_MODEL_NAME       = LVS_MASTER_MODEL_NAME,
                   SMT_MODEL_NAME          = LVS_SMT_MODEL_NAME ,         
                   PCB_ITEM                = LVS_PCB_ITEM ,
                   PRODUCTION_TYPE         = P_PS ,
                   FEEDER_LAYOUT_NAME      = LVS_FEEDER_MODEL_NAME,
                   LAST_MODIFY_DATE        = SYSDATE,
                   RUN_NO                  = LVS_RUN_NO,
                   ITEM_CODE               = LVS_ITEM_CODE,
                   RUN_NO_CHANGED_BY       = 'PDA M',
                   RUN_DATE                = SYSDATE,
                   SQUEEZE_LOT_NO          = LAST_SQUEEZE_LOT_NO,
                   SQUEEZE_CHECK_DATE      = DECODE(LAST_SQUEEZE_LOT_NO, NULL, NULL, SYSDATE),
                   SQUEEZE_LOT_NO2         = LAST_SQUEEZE_LOT_NO2,
                   SQUEEZE_CHECK_DATE2     = DECODE(LAST_SQUEEZE_LOT_NO2, NULL, NULL, SYSDATE),
                   BACKUPBLOCK_LOT_NO      = LAST_BACKUPBLOCK_LOT_NO,
                   BACKUPBLOCK_CHECK_DATE  = DECODE(LAST_BACKUPBLOCK_LOT_NO, NULL, NULL, SYSDATE),
                   ROUTER_LOT_NO           = LAST_ROUTER_LOT_NO,
                   ROUTER_CHECK_DATE       = DECODE(LAST_ROUTER_LOT_NO, NULL, NULL, SYSDATE),
                   ROMWRITE_LOT_NO         = LAST_ROMWRITE_LOT_NO,
                   ROMWRITE_CHECK_DATE     = DECODE(LAST_ROMWRITE_LOT_NO, NULL, NULL, SYSDATE),
                   FIXTURE_LOT_NO          = LAST_FIXTURE_LOT_NO,
                   FIXTURE_CHECK_DATE      = DECODE(LAST_FIXTURE_LOT_NO, NULL, NULL, SYSDATE),
                   PROFILE_LOT_NO          = LAST_PROFILE_LOT_NO,
                   PROFILE_CHECK_DATE      = DECODE(LAST_PROFILE_LOT_NO, NULL, NULL, SYSDATE),
                   SOLDER_LOT_NO           = LAST_SOLDER_LOT_NO,
                   SOLDER_CHECK_DATE       = LAST_SOLDER_CHECK_DATE ,
                   
                   SOLDER_TYPE             = LVS_SOLDER_TYPE
                   -- SPEC_CHECK_STATUS       = LAST_SPEC_CHECK_STATUS,
                   -- SPEC_CHECK_DATE         = LAST_SPEC_CHECK_DATE
             WHERE line_code = SUBSTR(p_line_code, 1, 2);
            
            -- JIG 투입이력 생성
             
            INSERT INTO IMCN_JIG_INPUT_HIST (
                                             INPUT_DATE, 
                                             LINE_CODE, 
                                             JIG_CODE, 
                                             JIG_LOT_NO, 
                                             RUN_NO, 
                                             CURRENT_HIT_VALUE, 
                                             JIG_TYPE, 
                                             ORGANIZATION_ID, 
                                             ENTER_BY, 
                                             ENTER_DATE, 
                                             LAST_MODIFY_BY, 
                                             LAST_MODIFY_DATE, 
                                             MODEL_NAME
                                            )
            SELECT SYSDATE, 
                   LINE_CODE, 
                   JIG_CODE, 
                   JIG_LOT_NO, 
                   LVS_RUN_NO, 
                   CURRENT_HIT_VALUE, 
                   JIG_TYPE, 
                   ORGANIZATION_ID, 
                   'AUTO', 
                   sysdate, 
                   'AUTO', 
                   sysdate, 
                   MODEL_NAME
              FROM IMCN_JIG_INPUT_HIST    
             WHERE RUN_NO = LVS_LAST_RUN_NO
               AND JIG_TYPE <> 'M';
             
            -- SAMPLE 투입이력 생성
   
            INSERT INTO IMCN_SAMPLE_INPUT_HIST (
                                                INPUT_DATE, 
                                                LINE_CODE, 
                                                SAMPLE_CODE, 
                                                SAMPLE_LOT_NO, 
                                                RUN_NO, 
                                                current_apply_date, 
                                                SAMPLE_TYPE, 
                                                ORGANIZATION_ID, 
                                                ENTER_BY, 
                                                ENTER_DATE, 
                                                LAST_MODIFY_BY, 
                                                LAST_MODIFY_DATE, 
                                                MODEL_NAME
                                               )
            SELECT SYSDATE, 
                   LINE_CODE, 
                   SAMPLE_CODE, 
                   SAMPLE_LOT_NO, 
                   LVS_RUN_NO, 
                   current_apply_date, 
                   SAMPLE_TYPE, 
                   ORGANIZATION_ID, 
                   'AUTO', 
                   sysdate, 
                   'AUTO', 
                   sysdate, 
                   MODEL_NAME
              FROM IMCN_SAMPLE_INPUT_HIST    
             WHERE RUN_NO = LVS_LAST_RUN_NO
               AND ( SAMPLE_TYPE <> 'S' OR SAMPLE_TYPE <> 'M')
               ;
             
            UPDATE IMCN_JIG
               SET LINE_CODE = SUBSTR(p_line_code, 1, 2)
             WHERE JIG_LOT_NO IN (
                                      SELECT LAST_SQUEEZE_LOT_NO     FROM IP_PRODUCT_LINE WHERE LINE_CODE = SUBSTR(p_line_code, 1, 2)     
                                      UNION ALL
                                      SELECT LAST_SQUEEZE_LOT_NO2    FROM IP_PRODUCT_LINE WHERE LINE_CODE = SUBSTR(p_line_code, 1, 2)       
                                      UNION ALL
                                      SELECT LAST_BACKUPBLOCK_LOT_NO FROM IP_PRODUCT_LINE WHERE LINE_CODE = SUBSTR(p_line_code, 1, 2)      
                                      UNION ALL
                                      SELECT LAST_ROUTER_LOT_NO      FROM IP_PRODUCT_LINE WHERE LINE_CODE = SUBSTR(p_line_code, 1, 2)    
                                      UNION ALL
                                      SELECT LAST_ROMWRITE_LOT_NO    FROM IP_PRODUCT_LINE WHERE LINE_CODE = SUBSTR(p_line_code, 1, 2)       
                                      UNION ALL
                                      SELECT LAST_FIXTURE_LOT_NO     FROM IP_PRODUCT_LINE WHERE LINE_CODE = SUBSTR(p_line_code, 1, 2) 
                                 );   
              
            UPDATE IMCN_SAMPLE
               SET LINE_CODE = SUBSTR(p_line_code, 1, 2)
             WHERE SAMPLE_LOT_NO IN (
                                      SELECT LAST_PROFILE_LOT_NO FROM IP_PRODUCT_LINE WHERE LINE_CODE = SUBSTR(p_line_code, 1, 2) 
                                    );       
                                    
      -- 솔더 투입이력 저장
            
            insert into im_item_solder_input_hist (
                                                    line_code, 
                                                    run_no, 
                                                    input_date, 
                                                    solder_lot_no, 
                                                    enter_date, 
                                                    enter_by, 
                                                    last_modify_date, 
                                                    last_modify_by
                                                  )
            select line_code, run_no, solder_check_date, solder_lot_no, sysdate, 'AUTO', sysdate, 'AUTO' 
              from ip_product_line
             where line_code         =  SUBSTR(p_line_code, 1, 2)
               and solder_check_date is not null
               and solder_lot_no     is not null;                                           
                 
         END IF;
                                                        
      ELSE
             
            UPDATE IP_PRODUCT_LINE
               SET MODEL_NAME         = LVS_MODEL_NAME ,
                   MASTER_MODEL_NAME  = LVS_MASTER_MODEL_NAME,
                   SMT_MODEL_NAME     = LVS_SMT_MODEL_NAME ,         
                   PCB_ITEM           = LVS_PCB_ITEM ,
                   PRODUCTION_TYPE    = P_PS ,
                   FEEDER_LAYOUT_NAME = LVS_FEEDER_MODEL_NAME,
                   LAST_MODIFY_DATE   = SYSDATE,
                   RUN_NO             = LVS_RUN_NO,
                   ITEM_CODE          = LVS_ITEM_CODE,
                   RUN_NO_CHANGED_BY  = 'PDA M',
                   RUN_DATE           = sysdate,
                   
                   SOLDER_TYPE        = LVS_SOLDER_TYPE
                --   SPEC_CHECK_STATUS  = LAST_SPEC_CHECK_STATUS,
                --   SPEC_CHECK_DATE    = LAST_SPEC_CHECK_DATE
             WHERE line_code = SUBSTR(p_line_code, 1, 2);
             
            --------------------------------------------------------------------
            -- Model이 다르면 마지막에 장착된 솔더를 투입취소 한다
            --------------------------------------------------------------------
            
/*            UPDATE im_item_solder_master
               SET input_date  = NULL, 
                   return_date = SYSDATE , 
                   line_code   = null, 
                   model_name  = null, 
                   run_no      = null
             WHERE item_barcode    = (
                                       SELECT LAST_SOLDER_LOT_NO
                                         FROM ip_product_line
                                        WHERE line_code = SUBSTR(p_line_code, 1, 2)
                                     )
               AND receipt_date    IS NOT NULL
               AND issue_date      IS NOT NULL
               AND input_date      IS NOT NULL
               AND mix_end_date    IS NOT NULL
               AND organization_id = 1;     
*/               
       
      END IF;
           
   -----------------------------------------------------------------------------       
   -- LINE OFF (회수처리) *******************************************************
   -----------------------------------------------------------------------------
   ELSIF p_inout = '2' THEN 

      ---------------------------------------------
      -- RUN CARD 등록여부 확인
      ---------------------------------------------
      phase     := '100' ;  
      lvi_count := 0;
      
      BEGIN
        
         SELECT COUNT (*), MAX(MASTER_MODEL_NAME), MAX(MODEL_NAME), MAX(PCB_ITEM)
           INTO lvi_count, LVS_MASTER_MODEL_NAME,  LVS_MODEL_NAME, LVS_PCB_ITEM
           FROM ip_product_run_card
          WHERE run_no = LVS_RUN_NO;

      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND THEN
              lvi_count := 0;
      END;
      
      IF nvl(lvi_count ,0) = 0 THEN
         P_ERR := f_msg('[INOUT PS] 런카드 정보가 없습니다.','K',1)    -- Run Card Notfound 
                  || ' = '
                  || LVS_RUN_NO;
         RETURN;
      END IF;
      
      LVS_PCB_ITEM := p_topbot;
      
      ---------------------------------------------
      -- 모델등록 여부 확인
      ---------------------------------------------
      phase     := '110' ; 
      lvi_count := 0;
      
      BEGIN
        
         SELECT COUNT (*), MAX(SMT_MODEL_NAME)
           INTO lvi_count, LVS_SMT_MODEL_NAME
           FROM ip_product_model_master
          WHERE model_name = LVS_MODEL_NAME;

      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND THEN
              lvi_count := 0;
      END;
      
      IF nvl(lvi_count ,0) = 0 THEN
         P_ERR := f_msg('[INOUT PS] 미등록 모델 입니다.','K',1)    -- Model Notfound
                  || ' = '
                  || LVS_MODEL_NAME;
         RETURN;
      END IF;
      
            ---------------------------------------------
            -- 장착여부 확인
            ---------------------------------------------
            phase     := '120' ; 
            lvi_count := 0;

            BEGIN
               SELECT COUNT(*),   MAX(MODEL_NAME),           MAX(SMT_MODEL_NAME)
                 INTO lvi_count , LVS_SET_FEEDER_MODEL_NAME, LVS_SET_SMT_MODEL_NAME
                 FROM ib_product_plandata
                WHERE line_code      = SUBSTR(p_line_code, 1, 2)
                  AND SMT_MODEL_NAME = LVS_SMT_MODEL_NAME
                  AND ACTIVE_YN      = 'Y';
            EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
               WHEN NO_DATA_FOUND THEN
                    lvi_count := 0;
            END;
            
           IF nvl(lvi_count ,0) = 0 THEN        
               P_ERR := f_msg('[INOUT PS] 활성화 취소할 모델이 없습니다.','K',1)     -- It is not active model
                        || ' = '
                        || LVS_SMT_MODEL_NAME
                        || ', '
                        || P_FEEDER_LAYOUT_NAME;
               RETURN;         
            END IF;
                  
       ---------------------------------------------------------
     -- 라인off 히스토리 등록 
     ---------------------------------------------------------
     phase := '130' ; 
     
      INSERT INTO IB_SMT_LINE_ONOFF_HISTORY ( 
                                              LINE_CODE , 
                                              MODEL_NAME , 
                                              PCB_ITEM , 
                                              LINE_ONOFF , 
                                              LINE_ONOFF_DATE , 
                                              ENTER_BY , 
                                              ENTER_DATE , 
                                              LAST_MODIFY_BY , 
                                              LAST_MODIFY_DATE , 
                                              ORGANIZATION_ID,
                                              RUN_NO
                                            )
      VALUES ( 
               SUBSTR( p_line_code,1,2) , 
               NVL( LVS_SET_FEEDER_MODEL_NAME, LVS_MODEL_NAME) , 
               NVL( LVS_PCB_ITEM,'*') , 
               'OFF' , 
               SYSDATE , 
               p_userid , 
               SYSDATE , 
               p_userid , 
               SYSDATE , 
               1,
               LVS_RUN_NO
             ) ;    
      ---------------------------------------------------------------
      -- 활성 모델 초기화
      -- 되돌릴수 없음 주의.
      -- 함수 안에서 잔량을  NEW SCAN QTY 로 업데이트 해줌...
      -- NEW SCAN QTY 가 이론잔량으로 남아있다가 다른곳에 장착시
      -- NEW SCAN QTY 가 장착수량으로 설정됨.
         ---------------------------------------------------------------
      phase := '140' ; 

      P_INTERLOCK_RESET_LINE (P_LINE_CODE, LVS_SET_FEEDER_MODEL_NAME, LVS_OUT);

      IF LVS_OUT <> 'OK'  THEN
             P_ERR := f_msg('[INOUT PS] 라인 초기화 실패.','K',1)   -- Line reset Failed
                      || ' = '
                      ||  LVS_OUT;   
             ROLLBACK;
             RETURN;
       ELSE
       
            COMMIT ; 
            ------------------------------------------------------------------------
            -- nsnp 실적 초기회
            -- NSNP 프로시져 안에 별도로 COMMIT 또 있음
            -- NSNP 는 로직에 큰 영향이 없고 장비를 세우는 과정 만 있으므로 실해해도 
            -- 그냥 이전 로직 COMMIT 처리 
            ------------------------------------------------------------------------
              BEGIN
             
              phase := '150';
              
              -------------------------------------------------------------------
              -- NSNP START
              -------------------------------------------------------------------
          
              p_interlock_set_nsnp_time_msg (SUBSTR (P_LINE_CODE, 1, 2),
                                             'RESET',
                                             1000,
                                             LVS_SET_FEEDER_MODEL_NAME,
                                             '*',
                                             'RESET',
                                             'RESET LINE ACTUAL ');
           ----------------------------------------------------------------------
           -- NSNP END
           ---------------------------------------------------------------------- 
               EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
                  WHEN OTHERS THEN
                     p_err := 'NG '|| f_msg('센서초기화에 실패  했습니다.','K',1);
                     RAISE_APPLICATION_ERROR (-20003, 'PHASE=' || PHASE || ' ' || SQLERRM);
                     RETURN;
               END;
   
       END IF;
    
   END IF;
   
   COMMIT;
   p_err := 'OK';
   
-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------

EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS THEN
      p_err := 'NG, [INOUT PS] ERROR Phase=' ||phase||' '|| SQLERRM;
END;