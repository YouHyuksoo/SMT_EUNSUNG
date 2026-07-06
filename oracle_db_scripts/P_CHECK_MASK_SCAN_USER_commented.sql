CREATE OR REPLACE PROCEDURE p_check_mask_scan_user (
  /* ================================================================
   * 프로시저명  : P_CHECK_MASK_SCAN_USER
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
   *   P_MODEL_NAME - 원본 선언부 기준 입력/출력 파라미터
   *   P_BARCODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_DEFICIT - 원본 선언부 기준 입력/출력 파라미터
   *   P_NO - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   *   P_USERID - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IMCN_JIG - 원본 로직 참조 테이블
   *   IMCN_JIG_APPLY_MODEL - 원본 로직 참조 테이블
   *   IMCN_JIG_INPUT_HIST - 원본 로직 참조 테이블
   *   IMCN_JIG_ISSUE - 원본 로직 참조 테이블
   *   IMCN_JIG_MASK_CHECK - 원본 로직 참조 테이블
   *   IP_PRODUCT_LINE - Product Line Master
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_MSG
   *   P_INTERLOCK_SET_NSNP_TIME_MSG
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_CHECK_MASK_SCAN_USER(...)
   * ================================================================ */
   p_line_code    IN     VARCHAR2,
   p_model_name   IN     VARCHAR2,
   p_barcode      IN     VARCHAR2,
   p_deficit      IN     VARCHAR2,
   p_no           IN     VARCHAR2,
   p_out          OUT VARCHAR2,
   p_userid       IN     VARCHAR2)
IS
   lvs_jig_status    VARCHAR2 (20); -- [AI] 내부 처리용 변수
   lvs_item_code     VARCHAR2 (50); -- [AI] 내부 처리용 변수
   lvl_break_value   NUMBER; -- [AI] 내부 처리용 변수
   lvl_hit_value     NUMBER; -- [AI] 내부 처리용 변수
   lvs_ip_address    VARCHAR2 (20); -- [AI] 내부 처리용 변수
   lvs_use_nsnp_yn   VARCHAR2 (1); -- [AI] 내부 처리용 변수
   phase             VARCHAR2 (20); -- [AI] 내부 처리용 변수
   LVL_TIME_TERM     NUMBER := 300000; -- [AI] 내부 처리용 변수
   
   lvs_jig_line_code      VARCHAR2 (10); -- [AI] 내부 처리용 변수
   lvs_check_status       VARCHAR2 (1); -- [AI] 내부 처리용 변수
   lvi_cnt                NUMBER; -- [AI] 내부 처리용 변수
   lvs_use_status         varchar2(1) ; -- [AI] 내부 처리용 변수
   lvdt_issue_date        date ; -- [AI] 내부 처리용 변수
   lvdt_last_inspect_date date ; -- [AI] 내부 처리용 변수
   lvs_tension_check_yn   varchar2(1) ; -- [AI] 내부 처리용 변수
   
   lvs_last_model_name   varchar2(50) ; -- [AI] 내부 처리용 변수
   lvs_last_mask_lot_no  varchar2(50) ; -- [AI] 내부 처리용 변수
   lvs_last_mask_lot_no2 varchar2(50) ; -- [AI] 내부 처리용 변수

   lvs_set_mask_lot_no  varchar2(50) ; -- [AI] 내부 처리용 변수
   lvs_set_mask_lot_no2 varchar2(50) ;    -- [AI] 내부 처리용 변수
   
   lvs_line_run_no       VARCHAR2 (50); -- [AI] 내부 처리용 변수
   lvs_line_pcb_item     VARCHAR2 (50); -- [AI] 내부 처리용 변수
   lvs_mask_pcb_item     VARCHAR2 (50); -- [AI] 내부 처리용 변수
   lvs_mask_model_name   VARCHAR2 (50); -- [AI] 내부 처리용 변수
   
   lvs_line_model_name   VARCHAR2 (50); -- [AI] 내부 처리용 변수
   lvs_line_item_code    VARCHAR2 (50); -- [AI] 내부 처리용 변수
   
   
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
  
   phase := '10';
   
   ------------------------------------------
   -- 장착할 mask id 확인
   ------------------------------------------
   
   BEGIN
     
      SELECT NVL (item_code, '*'),
             NVL (break_value, 0),
             NVL (hit_value, 0),
             jig_status,
             NVL (use_nsnp_yn, 'N') ,
             nvl( use_status , 'U') ,
             nvl(issue_date  , sysdate ) ,
             nvl(last_inspect_date  , sysdate ) ,
             tension_check_yn,
             pcb_item,
             nvl(line_code, '*') 
        INTO lvs_item_code,
             lvl_break_value,
             lvl_hit_value,
             lvs_jig_status,
             lvs_use_nsnp_yn,
             lvs_use_status ,
             lvdt_issue_date ,
             lvdt_last_inspect_date ,
             lvs_tension_check_yn,
             lvs_mask_pcb_item,
             lvs_jig_line_code
        FROM imcn_jig
       WHERE jig_lot_no      = p_barcode
         AND organization_id = 1
         AND jig_type        = 'M';

   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND THEN
        
           p_out := f_msg('스캔된 마스크 정보가 없습니다.', 'K', 1)
                    || ' = '                  
                    || 'Model='
                    || p_model_name
                    || ', '
                    || 'Barcode='
                    || p_barcode;
           RETURN;
   END;
   
   phase := '20';
   
   -------------------------------
   -- 라인정보에서 이전 장착 마스크 확인
   ------------------------------
   
   BEGIN
     
      SELECT NVL(LAST_MODEL_NAME,'*'),
             NVL(LAST_MASK_LOT_NO,'*'),
             NVL(LAST_MASK_LOT_NO2,'*'),
             run_no,
             pcb_item,
             model_name,
             item_code,
             NVL(MASK_LOT_NO,'*'),
             NVL(MASK_LOT_NO2,'*')
        INTO lvs_last_model_name,
             lvs_last_mask_lot_no,
             lvs_last_mask_lot_no2,
             lvs_line_run_no,
             lvs_line_pcb_item,
             lvs_line_model_name,
             lvs_line_item_code,
             lvs_set_mask_lot_no,
             lvs_set_mask_lot_no2
        FROM ip_product_line
       WHERE line_code       = p_line_code   -- 이전 진행롯트 확인
         AND organization_id = 1;

   phase := '25';
   
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND THEN
        
            p_out := f_msg('스캔된 라인정보가 없습니다.', 'K', 1)
                     || ' = '
                     || 'Line='
                     || p_line_code
                     || ', '
                     || 'Barcode='
                     || p_barcode;
         RETURN;
         
   END;
   
   -------------------------------
   -- 취소처리
   ------------------------------   
   IF ( p_deficit = 'C' ) THEN
     
      --------------------------------------------------------------------------------
      -- 스퀴즈 투입 취소처리
      --------------------------------------------------------------------------------   
     
      UPDATE imcn_jig
         SET line_code       = '*'
       WHERE jig_lot_no      = p_barcode
         AND organization_id = 1
         AND jig_type        = 'M';
       
      IF ( SUBSTR(P_NO,1,1) = '1') THEN           
            UPDATE ip_product_line
               SET mask_check_date  = NULL, 
                   mask_lot_no      = NULL
               WHERE line_code      = SUBSTR (p_line_code, 1, 2);             
      ELSE             
            UPDATE ip_product_line
               SET mask_check_date2 = NULL, 
                   mask_lot_no2     = NULL
             WHERE line_code        = SUBSTR (p_line_code, 1, 2);                   
      END IF;
                    
       
      p_out := 'OK';
      
      COMMIT;
      RETURN;      
        
  ELSE

      IF ( LENGTH( lvs_jig_line_code ) > 1   ) THEN
        
        p_out := f_msg('이미 장착된 마스크 입니다.', 'K', 1)   -- 다른라인에 이미 장착
                 || ' = '
                 || 'Line='
                 || lvs_jig_line_code
                 || ', '
                 || p_line_code ;
        RETURN;
         
      END IF; 
      
                
   -------------------------------
   -- 투입처리
   ------------------------------      
   -------------------------------
   -- 텐션측정, PCB_ITEM, 장착모젤 등을 확인한다
   ------------------------------
     -- if ( p_model_name <> NVL(lvs_last_model_name,'*') ) or ( ( NVL(lvs_last_mask_lot_no,'*') <> p_barcode ) or ( NVL(lvs_last_mask_lot_no2,'*') <> p_barcode ) ) then
         
          if  ( lvs_tension_check_yn = 'N' )  then 
        
              p_out := f_msg('텐션 측정 이력정보가 없습니다.', 'K', 1)
                           || ' = '  
                           || 'Tension_check_yn='
                           || lvs_tension_check_yn;
                           
              P_INTERLOCK_SET_NSNP_TIME_MSG( p_line_code , '1', 1, p_barcode, '*', 'P_CHECK_MASK_SCAN_USER', '텐션 측정 이력정보가 없습니다' ); 	
                                         
              RETURN; 
              
          else
            
              if  ( lvs_mask_pcb_item <> lvs_line_pcb_item ) then 
        
                 p_out := f_msg('Mask의 1st/2nd 가 다릅니다.', 'K', 1)
                           || ' = ' 
                           || 'pcb_item='
                           || lvs_mask_pcb_item
                           || ', '
                           || lvs_line_pcb_item;
                           
                  P_INTERLOCK_SET_NSNP_TIME_MSG( p_line_code, '1', 1, p_barcode, '*', 'P_CHECK_MASK_SCAN_USER', 'Mask의 1st/2nd 가 다릅니다' ); 	
                                             
                  RETURN; 
              
              else
                
                  if  (  p_model_name is null or lvs_line_model_name is null or p_model_name <> lvs_line_model_name ) then 
        
                        p_out := f_msg('장착모델과 일치하지 않습니다.', 'K', 1)
                                || ' = ' 
                                || p_model_name
                                || ', '
                                || lvs_line_model_name;
                                
                        P_INTERLOCK_SET_NSNP_TIME_MSG( p_line_code, '1', 1, p_barcode, '*', 'P_CHECK_MASK_SCAN_USER', '장착모델과 일치하지 않습니다' ); 
                                
                        RETURN; 
              
                  end if;       
              
              
              end if;
              
          end if;
       
      IF ( lvs_set_mask_lot_no = p_barcode OR lvs_set_mask_lot_no2 = p_barcode ) THEN
           
            p_out := f_msg('이미 투입된 Mask 입니다.', 'K', 1)   -- Already input Metal mask
                           || ' = '
                           || lvs_set_mask_lot_no
                           || ', '
                           || lvs_set_mask_lot_no2
                           || ', '
                           || p_barcode;
                          
            P_INTERLOCK_SET_NSNP_TIME_MSG( p_line_code, '1', 1, p_barcode, '*', 'P_CHECK_MASK_SCAN_USER', '이미 투입된 Mask 입니다' ); 
                                        
            RETURN; 
              
      end if  ;
       
       
      /* 
         -- 7일 이내 출고이력 확인
         select count(*)
           into lvi_cnt
           from imcn_jig_issue
          where issue_date >= (sysdate -7)
            and jig_code   = p_barcode
            and issue_deficit = 3
            AND organization_id = 1;
            
        if lvi_cnt = 0 then 
        
          p_out :=' Barcode='|| p_barcode || chr(13)||f_msg('Issue Check History Notfound','C',1) ; -- ' 출고 이력 정보가 없습니다.';
          RETURN; 
        
        end if  ;   
      */     

         ---------------------------------------------------------------------------
         -- 적용모델 체크
         ---------------------------------------------------------------------------
         BEGIN
           
            SELECT NVL (item_code, '*')
              INTO lvs_mask_model_name
              FROM imcn_jig_apply_model
             WHERE jig_lot_no      = p_barcode
               AND item_code       = p_model_name
               AND organization_id = 1
               AND ROWNUM          = 1 ;
               
         EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
            WHEN NO_DATA_FOUND THEN
                 lvs_mask_model_name := '*';
         END;
         --------------------------------------------------------------------------
         -- ITEM UNMATCH ERROR
         --------------------------------------------------------------------------
         IF ( lvs_mask_model_name <> p_model_name ) THEN
           
            p_out := f_msg('적용모델이 일치하지 않습니다.', 'K', 1)    --  f_msg('Model Unmatch','C',1) 
                     || ' = ' 
                     || lvs_mask_model_name
                     || ', '
                     || p_model_name;
                     
            P_INTERLOCK_SET_NSNP_TIME_MSG( p_line_code, '1', 1, p_barcode, '*', 'P_CHECK_MASK_SCAN_USER', '적용모델이 일치하지 않습니다' ); 
                     
            RETURN;
            
         END IF;


         phase := '50';

         -------------------------------------------------------------------------------------------
         --
         -------------------------------------------------------------------------------------------

         IF lvs_jig_status <> 'Z' or lvs_use_status <> 'U'  THEN

            --------------------------------------------------------------------------------
            -- NSNP END
            --------------------------------------------------------------------------------
           
             p_out := f_msg('Mask 상태가 비정상 입니다.', 'K', 1)    -- Mask Status Invalid.
                      || ' = '
                      || 'Jig Status(Z)='
                      || lvs_jig_status
                      ||', '
                      || 'Use Status(U)='
                      ||lvs_use_status;
                      
             P_INTERLOCK_SET_NSNP_TIME_MSG( p_line_code, '1', 1, p_barcode, '*', 'P_CHECK_MASK_SCAN_USER', 'Mask 상태가 비정상 입니다' );         
                      
             RETURN;
             
         END IF;

         phase := '60';
         
         
      --   -------------------------------------------------------------------------------------------
      --   -- 마스크 검사 확인
      --   -- 검사내역 없는 경우 RETURN
      --   -- 검사 불합격인 경우 RETURN
      --   -------------------------------------------------------------------------------------------   
      --   BEGIN
      --      SELECT COUNT(*)
      --        INTO lvi_cnt
      --        FROM IMCN_JIG_MASK_CHECK
      --       WHERE (JIG_CODE, JIG_LOT_NO, JIG_CHECK_DATE) IN ( SELECT A.JIG_CODE, A.JIG_LOT_NO, MAX(JIG_CHECK_DATE) 
      --                                                         FROM IMCN_JIG_MASK_CHECK A,
      --                                                              IMCN_JIG            B
      --                                                         WHERE A.JIG_CODE   = B.JIG_CODE 
      --                                                           AND A.JIG_LOT_NO = B.JIG_LOT_NO
      --                                                           AND B.JIG_TYPE    = 'M'
      --                                                           AND B.ORGANIZATION_ID = 1
      --                                                           AND A.JIG_LOT_NO      = p_barcode
      --                                                       GROUP BY A.JIG_CODE, A.JIG_LOT_NO ) ;
      --   EXCEPTION
      --      WHEN NO_DATA_FOUND
      --      THEN
      --         lvi_cnt := 0;
      --   END;                                                    
      --   
      --   IF NVL(lvi_cnt,0) = 0 
      --   THEN
      --     
      --      p_out := f_msg('Check history not found','C',1) ; --'검사내역이 존재하지 않습니다.';
      --      RETURN;
      --      
      --   ELSE
      --      BEGIN
      --         SELECT NVL(JIG_CHECK_STATUS, 'N')
      --           INTO lvs_check_status
      --           FROM IMCN_JIG_MASK_CHECK
      --          WHERE (JIG_CODE, JIG_LOT_NO, JIG_CHECK_DATE) IN ( SELECT A.JIG_CODE, A.JIG_LOT_NO, MAX(JIG_CHECK_DATE) 
      --                                                            FROM IMCN_JIG_MASK_CHECK A,
      --                                                                IMCN_JIG            B
      --                                                           WHERE A.JIG_CODE   = B.JIG_CODE 
      --                                                             AND A.JIG_LOT_NO = B.JIG_LOT_NO
      --                                                             AND B.JIG_TYPE    = 'M'
      --                                                             AND B.ORGANIZATION_ID = 1                                                             
      --                                                             AND A.JIG_LOT_NO      = p_barcode
      --                                                         GROUP BY A.JIG_CODE, A.JIG_LOT_NO )  ;
      --       EXCEPTION
      --          WHEN NO_DATA_FOUND
      --          THEN
      --             lvs_check_status := 'N';
      --       END;                    
      --       
      --       IF NVL(lvs_check_status , '*')  = 'N' 
      --       THEN
      --          p_out := f_msg('Tention Check NG','C',1) ; --'마스크 탠션 측정 결과  불합격입니다.';
      --          RETURN;
      --        END IF;  
      --                                        
      --   END IF;
         
         phase := '60';
         -------------------------------------------------------------------------------------------
         --
         -------------------------------------------------------------------------------------------
         
         
         IF lvl_break_value <= lvl_hit_value
         THEN
      --      IF lvs_use_nsnp_yn = 'Y'
      --      THEN
      --         BEGIN
      --            --------------------------------------------------------------------------------
      --            -- NSNP START
      --            --------------------------------------------------------------------------------
      --            p_interlock_set_nsnp_time_msg (p_line_code,
      --                                           1,
      --                                           LVL_TIME_TERM,
      --                                           p_model_name,
      --                                           '*',
      --                                           'MASK CHECK',
      --                                           'LIFE CYCLE OVER ' || p_barcode);
      --         --------------------------------------------------------------------------------
      --         -- NSNP END
      --         --------------------------------------------------------------------------------
      --
      --         EXCEPTION
      --            WHEN OTHERS
      --            THEN
      --               NULL;
      --         END;
      --      END IF;

            
           p_out := f_msg('Mask 유효수명을 초과 했습니다.', 'K', 1)    -- Life Cycle Over
                    || ' = '  
                    || lvl_break_value
                    || ', '
                    || lvl_hit_value;
                    
           P_INTERLOCK_SET_NSNP_TIME_MSG( p_line_code, '1', 1, p_barcode, '*', 'P_CHECK_MASK_SCAN_USER', 'Mask 유효수명을 초과 했습니다' );          
                      
            RETURN;
            
         -------------------------------------------------------------------
         --
         -------------------------------------------------------------------
            
         ELSE
         
            ----------------------------------------------------------------
            -- 라인정보에 정보 업데이트
            ----------------------------------------------------------------
            
            IF ( SUBSTR(P_NO,1,1) = '1') THEN           
                  UPDATE ip_product_line
                     SET mask_check_date  = SYSDATE, 
                         mask_lot_no      = p_barcode
                   WHERE line_code        = SUBSTR (p_line_code, 1, 2);             
            ELSE             
                  UPDATE ip_product_line
                     SET mask_check_date2 = SYSDATE, 
                         mask_lot_no2     = p_barcode
                   WHERE line_code        = SUBSTR (p_line_code, 1, 2);                   
            END IF;


            -- 해당 라인에 한개만 걸수 있으므로 먼저 초기화 하고 
            -- 2개 장착시 어쩔수 없이 라인해제시 일괄 정리로 변경
            
            UPDATE imcn_jig
               SET line_code       = '*'   ,
                   ISSUE_DATE      = NULL                         
             WHERE line_code       = SUBSTR (p_line_code, 1, 2)
              -- AND jig_lot_no      <> p_barcode
               AND jig_lot_no      not in (     
                                            select mask_lot_no
                                              from ip_product_line 
                                             where line_code  =    SUBSTR (p_line_code, 1, 2)   
                                             union all
                                            select mask_lot_no2
                                              from ip_product_line 
                                             where line_code  =    SUBSTR (p_line_code, 1, 2) 
                                             union all
                                            select p_barcode
                                              from dual
                                          )
               AND organization_id = 1
               AND jig_type        = 'M';

            ------------------------------------------------------------------
            -- 라인 설정 
            -- 출고 도면 텐션 측정 안한거로 초기화
            -- 다음번 출고시 측정 안되어 있으면 장착 불가 
            ------------------------------------------------------------------
            UPDATE imcn_jig
               SET line_code        = SUBSTR (p_line_code, 1, 2) , 
                   ISSUE_DATE       = SYSDATE ,
                   TENSION_CHECK_YN = 'N',
                   last_modify_by   = 'Line Input',
                   last_modify_date = sysdate 
             WHERE jig_lot_no       = p_barcode 
               AND jig_type         = 'M';
               
               --------------------------------------------------------------------
               -- 장착이력 등록
               --------------------------------------------------------------------
               
               INSERT INTO IMCN_JIG_input_hist (
                                                input_date, 
                                                line_code, 
                                                jig_code, 
                                                jig_lot_no, 
                                                run_no, 
                                                current_hit_value, 
                                                jig_type, 
                                                organization_id, 
                                                enter_by, 
                                                enter_date, 
                                                last_modify_by, 
                                                last_modify_date,
                                                model_name
                                               )
                                       VALUES (
                                                sysdate,
                                                SUBSTR(p_line_code, 1, 2),
                                                p_barcode,
                                                p_barcode,
                                                lvs_line_run_no,
                                                lvl_hit_value,
                                                'M',
                                                1,
                                                p_userid,
                                                sysdate,
                                                p_userid,
                                                sysdate,
                                                p_model_name
                                              );           

            COMMIT;

            p_out := 'OK';
              
            RETURN;
            
         END IF;
   
   
   END IF;

   phase := '70';
-------------------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------------------
EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS THEN
     
      p_out := 'NG, [P_CHECK_MASK_SCAN_USER] IP='
               || lvs_ip_address
               || ' '
               || 'NG '
               || 'PHASE='
               || phase
               || ' '
               || SQLERRM;
      RETURN;
END;
