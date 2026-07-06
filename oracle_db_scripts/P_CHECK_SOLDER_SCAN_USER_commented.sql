CREATE OR REPLACE PROCEDURE p_check_solder_scan_user (
  /* ================================================================
   * 프로시저명  : P_CHECK_SOLDER_SCAN_USER
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-10-05
   * 수정이력:
   *   2020-10-05 - 지성솔루션컨설팅 - 최초 작성
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
   *   P_TYPE - 원본 선언부 기준 입력/출력 파라미터
   *   P_TEMP1 - 원본 선언부 기준 입력/출력 파라미터
   *   P_TEMP2 - 원본 선언부 기준 입력/출력 파라미터
   *   P_DEFICIT - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   *   P_USERID - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ID_ITEM - Item Master
   *   IM_ITEM_RECEIPT_BARCODE - 원본 로직 참조 테이블
   *   IM_ITEM_SOLDER_INPUT_HIST - 원본 로직 참조 테이블
   *   IM_ITEM_SOLDER_MASTER - 원본 로직 참조 테이블
   *   IP_PRODUCT_LINE - Product Line Master
   *   IP_PRODUCT_MODEL_MASTER - 원본 로직 참조 테이블
   *   IQ_MACHINE_INSPECT_DATA_SOLDER - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_ITEM_CODE_FROM_BARCODE
   *   F_GET_LOT_NO_FROM_BARCODE
   *   F_GET_SOLDER_TYPE
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
   *   EXEC P_CHECK_SOLDER_SCAN_USER(...)
   * ================================================================ */
   p_line_code    IN     VARCHAR2,
   p_model_name   IN     VARCHAR2,
   p_barcode      IN     VARCHAR2,
   p_type         IN     VARCHAR2,
   p_temp1        IN     VARCHAR2,
   p_temp2        IN     VARCHAR2,
   p_deficit      IN     VARCHAR2,
   p_out          OUT    VARCHAR2,
   p_userid       IN     VARCHAR2 )
IS
   lvi_count              NUMBER; -- [AI] 내부 처리용 변수
   lvs_item_code          VARCHAR2 (20); -- [AI] 내부 처리용 변수
   lvl_passed_time        NUMBER; -- [AI] 내부 처리용 변수
   lvdt_input_date        DATE; -- [AI] 내부 처리용 변수
   lvs_line_code          VARCHAR2 (30); -- [AI] 내부 처리용 변수
   lvs_model_name         VARCHAR2 (30); -- [AI] 내부 처리용 변수
   LVL_TIME_TERM          NUMBER := 300000; -- [AI] 내부 처리용 변수

   lvs_solder_lot_no      VARCHAR2 (50); -- [AI] 내부 처리용 변수
   lvs_pre_solder         VARCHAR2 (50); -- [AI] 내부 처리용 변수
   lvs_solder_type        VARCHAR2 (10); -- [AI] 내부 처리용 변수
   lvs_solder_type_cond   VARCHAR2 (10); -- [AI] 내부 처리용 변수
   
   lvdt_valid_date        DATE; -- [AI] 내부 처리용 변수
   lvl_temp1              NUMBER; -- [AI] 내부 처리용 변수
   lvl_temp2              NUMBER; -- [AI] 내부 처리용 변수
   
   lv1_viscosity           NUMBER; -- [AI] 내부 처리용 변수
   
   lvs_line_solder_type   VARCHAR2 (10); -- [AI] 내부 처리용 변수
   lvs_run_no             VARCHAR2 (20); -- [AI] 내부 처리용 변수
   
   lvs_last_solder_lot_no      VARCHAR2 (50); -- [AI] 내부 처리용 변수
   lvs_last_solder_check_date  DATE; -- [AI] 내부 처리용 변수
   
   lvs_fifo_item_barcode       VARCHAR2 (50);    -- [AI] 내부 처리용 변수
   lvs_str                     VARCHAR2 (50);    -- [AI] 내부 처리용 변수
   
   lvl_dup_count               NUMBER; -- [AI] 내부 처리용 변수
   lvl_dup_count2              NUMBER; -- [AI] 내부 처리용 변수

BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.

   --------------------------------------------------
   -- 솔더라벨 확인 임시로 막음
   -- 원래는 im_item_receipt_barcode 여기를 체크하게 되어 있었음.
   --------------------------------------------------
   BEGIN
     
      SELECT item_code,
             SOLDER_LOT_NO , --lot_no, 임시로 솔더 마스터 보도록 수정 YHS 20201005
             valid_date
        INTO lvs_item_code, lvs_solder_lot_no, lvdt_valid_date
        FROM im_item_solder_master          --  FROM im_item_receipt_barcode 임시로 솔더 마스터 보도록 수정 YHS 20201005
       WHERE item_barcode    = p_barcode      -- WHERE lot_no = f_get_lot_no_from_barcode (p_barcode)
         AND organization_id = 1;              
         
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND THEN
           p_out :=  f_msg('스캔한 솔더라벨 바코드 없음.', 'K', 1)   -- Not found Solder label info.
                     || ' = '
                     || p_barcode;
                     
           RETURN;
   END;
   
   --------------------------------------------------------------------
   -- 폐기 처리
   --------------------------------------------------------------------

   IF ( p_type = 'D' AND p_deficit = 'N' ) THEN
     
      SELECT COUNT (*)
        INTO lvi_count
        FROM im_item_solder_master
       WHERE item_barcode    = p_barcode
         AND DESTROY_DATE    IS NOT NULL
         AND organization_id = 1;

      IF ( lvi_count > 0 ) THEN
        
           p_out :=  f_msg('이미 폐기 되었습니다.', 'K', 1);   -- Already destroyed.          
           RETURN;
      ELSE
        
         UPDATE im_item_solder_master
            SET DESTROY_DATE    = SYSDATE
             --   line_code = SUBSTR (p_line_code, 1, 2)   -- 폐기란 사용완료 개념이기도 하기에 투입된 라인정보엔 손되지 않음
          WHERE item_barcode    = p_barcode                
            AND organization_id = 1;
                
         ----------------------------------------------------------------
         -- 라인 마스터에 솔더 정보 초기화 
         ----------------------------------------------------------------
          UPDATE ip_product_line
             SET solder_check_date      = NULL ,
                 SOLDER_LOT_NO          = NULL ,                -- 2016.04.27 zethani
                 last_solder_check_date = NULL ,
                 last_SOLDER_LOT_NO     = NULL                  
           WHERE solder_lot_no     = p_barcode;
           
        --     AND line_code         = SUBSTR (p_line_code, 1, 2)
     
         COMMIT;
         p_out := 'OK';
         RETURN;
         
      END IF;
      
   END IF;
      
   --------------------------------------------------------------------
   -- 폐기 취소 처리
   --------------------------------------------------------------------

   IF ( p_type = 'D' AND p_deficit = 'C' ) THEN
   
  
      SELECT COUNT (*) 
        INTO lvi_count 
        FROM im_item_solder_master
       WHERE item_barcode    = p_barcode
         AND DESTROY_DATE    IS NULL  
         AND organization_id = 1;

      IF ( lvi_count > 0 ) THEN 
  
           p_out := f_msg('폐기 취소할 솔더가 없습니다.', 'K', 1); --  Not found data for destroy cancel.      
           RETURN;
         
      ELSE
          
          SELECT COUNT (*) , max(input_date)
            INTO lvi_count , lvdt_input_date
            FROM im_item_solder_master
           WHERE item_barcode    = p_barcode
             AND DESTROY_DATE    IS NOT NULL   
             AND organization_id = 1;    
      
         UPDATE im_item_solder_master
            SET DESTROY_DATE = NULL,
                input_date  = NULL, 
                return_date = SYSDATE , 
                line_code   = null, 
                model_name  = null, 
                run_no      = null
          WHERE item_barcode    = p_barcode
            AND organization_id = 1;
            
         ----------------------------------------------------------------
         -- 라인 마스터에 솔더 정보 초기화  복구
         ----------------------------------------------------------------
        --  UPDATE ip_product_line
        --     SET solder_check_date = lvdt_input_date ,
        --         SOLDER_LOT_NO     = lvs_solder_lot_no  
        --   WHERE line_code          = SUBSTR (p_line_code, 1, 2)
        --     AND solder_lot_no      = p_barcode
        --  ;             
        
         COMMIT;
         p_out := 'OK';
         RETURN;
         
      END IF;
      
   END IF;
   
   --------------------------------------------------
   -- 솔더 유효기간 확인
   --------------------------------------------------
      
   IF ( trunc(lvdt_valid_date) < trunc(sysdate) ) THEN
     
        p_out :=  f_msg('솔더 사용시한이 지났습니다', 'K', 1)
                  || ' = '
                  || to_char( lvdt_valid_date, 'YYYY-MM-DD');
                                
        RETURN;
   
   END IF;

   --------------------------------------------------
   -- 솔더타입 확인 (유연, 무연)
   --------------------------------------------------   
                     
   BEGIN
     
      SELECT nvl(solder_type,'*')
        INTO lvs_solder_type
        FROM id_item
       WHERE item_code = lvs_item_code
         AND organization_id = 1;
             
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND THEN
        
           p_out := f_msg('스캔한 바코드의 품목을 알수 없습니다.', 'K', 1)   --  Solder Type Unknown(In item master)
                    || ' = '
                    || p_barcode;
 
           RETURN;
   END;

   if ( lvs_solder_type is null or lvs_solder_type = '' ) then
     
         p_out := f_msg('스캔된한 바코드의 솔더타입을 알수 없습니다.', 'K', 1)  -- Solder Type Unknown(In item master)
                  || ' = '
                  || p_barcode
                  || CHR(13);
 
         RETURN;

   end if ;
   
   -------------------------------------------------------------------------------------------------------
   -- 페기된 솔더인지 확인 ( D:폐기  R: 냉장고 입고 I: 냉장고 출고 H:상온방치  M: 교반  O: 라인투입 C: 라인투입
   -------------------------------------------------------------------------------------------------------
   IF p_type IN ('D', 'R', 'I', 'C' , 'H' , 'M' , 'O' ) THEN  
      
      BEGIN
        
         SELECT COUNT (*)
           INTO lvi_count
           FROM im_item_solder_master
          WHERE item_barcode    = p_barcode
            AND DESTROY_DATE    IS NOT NULL
            AND organization_id = 1;
                
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND THEN
              p_out := 'OK';
              RETURN;
      END;


      IF ( lvi_count > 0 ) THEN
        
           p_out :=  f_msg('폐기된 솔더 입니다.', 'K', 1);   -- Destroyed Solder.
           RETURN;
      END IF;
      
   END IF;
   --------------------------------------------------------------------
   -- RECEIPT AND NORMAL
   -- 입고 처리이면
   --------------------------------------------------------------------

   IF ( p_type = 'R' AND p_deficit = 'N' ) THEN
     
   
   --------------------------------------------------------------------
   -- 자재창고 출고이력 확인
   --------------------------------------------------------------------   

/*
      SELECT COUNT (*)
        INTO lvi_count
        FROM im_item_receipt_barcode
       WHERE item_barcode       = p_barcode
         AND receipt_compare_yn = 'Y'
         AND issue_compare_yn   = 'Y'
         AND organization_id    = 1;

      IF lvi_count = 0 THEN
        
          p_out := f_msg('21 No have issue histrory in Warehouse','K',1);
        -- p_out := '7 이미 입고된솔더 입니다.';
         RETURN;
         
      END IF;
*/

   --------------------------------------------------------------------
   -- 냉장고 입고이력 확인
   --------------------------------------------------------------------  
      
      SELECT COUNT (*)
        INTO lvi_count
        FROM im_item_solder_master
       WHERE item_barcode    = p_barcode
         AND organization_id = 1;

      IF ( lvi_count > 0 ) THEN
        
           p_out := f_msg('이미 입고된 솔더 입니다.', 'K', 1);  -- Already receipted.
           RETURN;
         
      ELSE
        
         INSERT INTO im_item_solder_master (item_code,
                                            solder_lot_no,
                                            receipt_date,
                                            issue_date,
                                            open_date,
                                            return_date,
                                            line_code,
                                            workstage_code,
                                            machine_code,
                                            enter_date,
                                            enter_by,
                                            last_modify_date,
                                            last_modify_by,
                                            organization_id,
                                            item_barcode,
                                            model_name,
                                            solder_type,
                                            valid_date)
         VALUES (lvs_item_code,
                 lvs_solder_lot_no, --f_get_lot_no_from_barcode (p_barcode),
                 SYSDATE,                                      --RECEIPT_DATE,
                 NULL,                                           --ISSUE_DATE,
                 NULL,                                            --OPEN_DATE,
                 NULL,                                          --RETURN_DATE,
                 SUBSTR(P_LINE_CODE,1,2),                         --LINE_CODE,
                 NULL,                                       --WORKSTAGE_CODE,
                 NULL,                                         --MACHINE_CODE,
                 SYSDATE,                                        --ENTER_DATE,
                 'SYSTEM',                                         --ENTER_BY,
                 SYSDATE,                                  --LAST_MODIFY_DATE,
                 'SYSTEM',                                   --LAST_MODIFY_BY,
                 1,
                 p_barcode,
                 p_model_name,
                 lvs_solder_type,   -- NVL(F_GET_SOLDER_TYPE (lvs_item_code),'*')
                 lvdt_valid_date
                 );
      END IF;

      COMMIT;
      p_out := 'OK';
      RETURN;
      
   ---------------------------------------------------------------------------------
   -- RECEIPT CANCEL
   -- 입고 취소면
   ---------------------------------------------------------------------------------

   ELSIF ( p_type = 'R' AND p_deficit = 'C' ) THEN
     
      BEGIN
         SELECT COUNT (*)
           INTO lvi_count
           FROM im_item_solder_master
          WHERE item_barcode    = p_barcode 
            AND receipt_date    IS NOT NULL
            AND issue_date      IS NULL
            AND input_date      IS NULL
            AND organization_id = 1;
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND THEN
              lvi_count := 0;
      END;

      IF ( lvi_count = 0 ) THEN
        
           p_out := f_msg('입고 취소할 솔더가 없습니다.', 'K', 1);   -- Not found data for cancel.
           RETURN;
      END IF;

      DELETE FROM im_item_solder_master
       WHERE item_barcode    = p_barcode
         AND receipt_date    IS NOT NULL
         AND issue_date      IS NULL
         AND input_date      IS NULL
         AND organization_id = 1;

      COMMIT;
      p_out := 'OK';
      RETURN;
      
   END IF;

   ----------------------------------------------------------------------------------
   -- ISSUE AND NORMAL
   -- 냉장고 출고면
   ----------------------------------------------------------------------------------

   IF ( p_type = 'I' AND p_deficit = 'N' ) THEN
     
   --------------------------------------------------------------------
   -- 냉장고 출고이력 확인
   -------------------------------------------------------------------- 
      
      BEGIN
        
         SELECT COUNT (*)
           INTO lvi_count
           FROM im_item_solder_master
          WHERE item_barcode    = p_barcode
            AND receipt_date    IS NOT NULL
            AND issue_date      IS NOT NULL
            AND input_date      IS NULL
            AND destroy_date    IS NULL
            AND organization_id = 1;
            
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND THEN
              lvi_count := 0;
      END;

      IF ( lvi_count = 1 ) THEN
        
          p_out :=  f_msg('이미 출고처리 되었습니다.', 'K', 1)     -- Not yet receipted or no data for issue.
                    || ' = '
                    || p_barcode;
  
          RETURN;
      END IF;
     
   ----------------------------------------------------------------------------------    
   -- 냉장고 온도 확인
   ----------------------------------------------------------------------------------  
   
   
      IF ( NVL(TRIM(p_temp1),'*') = '*' ) THEN
        
           p_out :=  f_msg('냉장고 온도를 입력하세요.', 'K', 1)  -- Check Temperature
                     || ' = '
                     || p_temp1;
  
           RETURN;        
      END IF;
      
      BEGIN
        
         SELECT NVL(to_number( p_temp1 ),0)
           INTO lvl_temp1
           FROM dual;
            
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN OTHERS THEN
           
              p_out :=  f_msg('잘못된 냉장고 온도 입니다.', 'K', 1)    
                        || ' = '
                        || p_temp1;
                        
 
              RETURN;
      END;
         
     
      BEGIN
        
         SELECT COUNT (*)
           INTO lvi_count
           FROM im_item_solder_master
          WHERE item_barcode    = p_barcode
            AND receipt_date    IS NOT NULL
            AND issue_date      IS NULL
            AND input_date      IS NULL
            AND destroy_date    IS NULL
            AND organization_id = 1;
            
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND THEN
              lvi_count := 0;
      END;

      IF ( lvi_count = 0 ) THEN
        
          p_out :=  f_msg('입고되지 않았거나 출고 할 솔더가 없습니다.', 'K', 1)     -- Not yet receipted or no data for issue.
                    || ' = '
                    || lvs_solder_lot_no;
  
          RETURN;
      END IF;
         
      -------------------------------------------------------------------------
      -- 선입선출 확인
      -------------------------------------------------------------------------
      lvi_count := 0 ;
      
          SELECT COUNT (*), MIN( item_barcode )
            INTO lvi_count, lvs_fifo_item_barcode
            FROM im_item_solder_master
           WHERE item_code     = lvs_item_code
             AND item_barcode  <> p_barcode
             AND receipt_date  IS NOT NULL
             AND issue_date    IS NULL
             AND input_date    IS NULL
             AND DESTROY_DATE  IS NULL
             AND item_barcode  <  p_barcode   -- 순차적으로 출고
        --     AND trunc(receipt_date) < ( 
        --                                 select trunc(receipt_date) 
        --                                   from im_item_solder_master
        --                                   WHERE item_barcode    = p_barcode
        --                                    AND receipt_date   IS NOT NULL
        --                                     AND issue_date     IS NULL
        --                                    AND input_date     IS NULL
        --                                    AND organization_id = 1 
        --                                )      
              AND nvl(machine_code, '') = nvl(substr( p_barcode, 11, 1), 'A')                                 
              AND organization_id = 1      ;
                
      
      IF ( lvi_count > 0 ) THEN
        
         p_out :=  f_msg('선입선출 위반.', 'K', 1)      -- First In First Out. Validation NG
                   || ' = '
                   || p_barcode || ', ' || lvs_fifo_item_barcode;
   
         RETURN;
         
      END IF; 
    
      
      -------------------------------------------------------------------------
      -- 덕일산업, 냉장고 온도 확인 10도 이상이면 NG 처리
      -------------------------------------------------------------------------     
      
      IF ( lvl_temp1 > 10 ) THEN
        
         p_out :=  f_msg('냉장고 온도가 10도을 넘었습니다.', 'K', 1)      -- Freezer Temperature is over 10 degree
                   || ' = '
                   || p_barcode;
  
         RETURN;          
      
      END IF;        

      --출고 되면 상온방치도 처리
      --상온방치 시작시간 업데이트함

      UPDATE im_item_solder_master
         SET issue_date            = SYSDATE,
             unfreezing_start_date = SYSDATE,
             freezer_in_temp       = lvl_temp1
             --line_code = SUBSTR (p_line_code, 1, 2)
       WHERE item_barcode    = p_barcode
         AND receipt_date    IS NOT NULL
         AND issue_date      IS NULL
         AND input_date      IS NULL
         AND organization_id = 1;

      COMMIT;
      p_out := 'OK';
      RETURN;
      
   ---------------------------------------------------------------------
   --  ISSUE CANCEL
   -- 출고 취소면
   ---------------------------------------------------------------------
   ELSIF ( p_type = 'I' AND p_deficit = 'C' ) THEN
     
      BEGIN
        
         SELECT COUNT (*)
           INTO lvi_count
           FROM im_item_solder_master
          WHERE item_barcode          = p_barcode
            AND receipt_date          IS NOT NULL
            AND issue_date            IS NOT NULL
            AND unfreezing_start_date IS NOT NULL
            AND unfreezing_end_date   IS NULL
            AND input_date            IS NULL
            AND organization_id       = 1;
            
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND THEN
              lvi_count := 0;
      END;

      IF ( lvi_count = 0 ) THEN
        
          p_out := f_msg('출고 취소 할 솔더가 없습니다.', 'K', 1)      -- Not found for issue cancel.
                   || ' = '
                   || p_barcode;
 
         RETURN;
      END IF;

      -- 출고취소 되면 상온방치 시작시간도 null처리
      UPDATE im_item_solder_master
         SET issue_date = NULL , 
             line_code  = null, 
             unfreezing_start_date = null,
             freezer_in_temp = null
       WHERE item_barcode          = p_barcode
         AND receipt_date          IS NOT NULL
         AND issue_date            IS NOT NULL
         AND unfreezing_start_date IS NOT NULL
         AND unfreezing_end_date   IS NULL
         AND input_date            IS NULL
         AND organization_id       = 1;

      COMMIT;
      p_out := 'OK';
      RETURN;
      
   END IF;

   ----------------------------------------------------------------------------------
   -- 상온방치 AND NORMAL -- 취소로직 없슴
   ----------------------------------------------------------------------------------
   IF ( p_type = 'H' ) THEN --AND p_deficit = 'N'
     
   --------------------------------------------------------------------
   -- 상온방치 이력 확인
   -------------------------------------------------------------------- 

      BEGIN
        
         SELECT COUNT (*)
           INTO lvi_count
           FROM im_item_solder_master
          WHERE item_barcode          = p_barcode
            AND receipt_date          IS NOT NULL
            AND issue_date            IS NOT NULL
            AND unfreezing_start_date IS NOT NULL
            AND organization_id       = 1;
            
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND  THEN
              lvi_count := 0;
      END;

      IF ( lvi_count = 1 ) THEN
        
           p_out := f_msg('이미 상온방치 되었습니다.', 'K', 1)      -- Not yet receipt/issue or unfreezing data not found
                    || ' = '
                    || p_barcode;
  
         RETURN;
      END IF;
      
      BEGIN
        
         SELECT COUNT (*)
           INTO lvi_count
           FROM im_item_solder_master
          WHERE item_barcode          = p_barcode
            AND receipt_date          IS NOT NULL
            AND issue_date            IS NOT NULL
            AND unfreezing_start_date IS NULL
            AND organization_id       = 1;
            
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND  THEN
              lvi_count := 0;
      END;

      IF ( lvi_count = 0 ) THEN
        
           p_out := f_msg('입/출고되지 않았거나 상온방치 할 솔더가 없습니다.', 'K', 1)      -- Not yet receipt/issue or unfreezing data not found
                    || ' = '
                    || p_barcode;
  
         RETURN;
      END IF;
      
      
 
      

      UPDATE im_item_solder_master
         SET unfreezing_start_date = SYSDATE
       WHERE item_barcode          = p_barcode
         AND receipt_date          IS NOT NULL
         AND issue_date            IS NOT NULL
         AND unfreezing_start_date IS NULL
         AND organization_id       = 1;

      COMMIT;
      p_out := 'OK';
      RETURN;
      
   END IF;

   ----------------------------------------------------------------------------------
   -- 교반입 AND NORMAL -- 취소로직 없슴
   ----------------------------------------------------------------------------------
   IF p_type = 'M' THEN   --AND p_deficit = 'N'
     
   --------------------------------------------------------------------
   -- 교반시작 이력 확인
   --------------------------------------------------------------------    
     
      BEGIN
        
        SELECT COUNT (*)
         INTO lvi_count
         FROM im_item_solder_master
        WHERE item_barcode          = p_barcode
          AND receipt_date          IS NOT NULL
          AND issue_date            IS NOT NULL
          AND unfreezing_start_date IS NOT NULL
          AND mix_start_date        IS NOT NULL
          AND organization_id       = 1;
          
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND THEN
              lvi_count := 0;
      END;


      IF (lvi_count = 1 ) THEN
        
         p_out :=  f_msg('이미 교반시작 처리가 되었습니다.', 'K', 1);   -- This is not need mixing
  
         RETURN;
         
      END IF;
      
     
   ----------------------------------------------------------------------------------    
   -- 냉장고 온도 확인
   ----------------------------------------------------------------------------------    
      IF ( ( NVL(TRIM(p_temp1),'*') = '*' ) OR (NVL(TRIM(p_temp2),'*') = '*' ) ) THEN
        
           p_out := f_msg('상온시작 및 완료 온도를 입력하세요.', 'K', 1)      -- Check Temperature 
                    || ' = '
                    || p_temp1
                    || ', '
                    || p_temp2;
  
           RETURN;        
      END IF;
      
      BEGIN
        
         SELECT NVL(to_number( p_temp1 ),0), NVL(to_number( p_temp2 ),0)
           INTO lvl_temp1, lvl_temp2
           FROM dual;
            
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN OTHERS THEN
           
              p_out := f_msg('잘못된 상온시작 또는 완료온도 입니다.', 'K', 1)      -- Check Temperature 
                       || ' = '
                       || p_temp1
                       || ', '
                       || p_temp2;
                       
      --        P_INTERLOCK_SET_NSNP_TIME_MSG( '04', '1', 1, p_barcode,'*', 'P_CHECK_SOLDER_SCAN_USER', '잘못된 상온시작 또는 완료온도 입니다' ); 
                       
              RETURN;
      END;   
      
      IF ( lvl_temp1 > 13 ) THEN
        
         p_out :=  f_msg('상온시작 온도가 13도을 넘었습니다.', 'K', 1)      -- Freezer Temperature is over 13 degree
                   || ' = '
                   || p_temp1;
    
         RETURN;          
      
      END IF;       
   
      IF ( lvl_temp2 < 19 OR lvl_temp2 > 28 ) THEN
        
         p_out :=  f_msg('상온종료 온도가 19도에서 28도 사이가 아닙니다.', 'K', 1)      -- Freezer Temperature is over 21 < < 28 degree
                   || ' = '
                   || p_temp2;
  
         RETURN;          
      
      END IF;   
        
      BEGIN
        
        SELECT COUNT (*), ROUND (SUM ( (SYSDATE - unfreezing_start_date) * 24), 1)
         INTO lvi_count, lvl_passed_time
         FROM im_item_solder_master
        WHERE item_barcode          = p_barcode
          AND receipt_date          IS NOT NULL
          AND issue_date            IS NOT NULL
          AND unfreezing_start_date IS NOT NULL
          AND mix_start_date        IS NULL
          AND organization_id       = 1;
          
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND THEN
              lvi_count := 0;
      END;


      IF ( NVL (lvi_count, 0) = 0 ) THEN
        
         p_out :=  f_msg('스캔한 솔더가 교반입 대상이 아닙니다.', 'K', 1);   -- This is not need mixing
  
         RETURN;
         
      END IF;

      IF ( lvl_passed_time < 2 ) THEN
        
           p_out := f_msg('상온방치 2시간이 경과되지 않았습니다.', 'K', 1)  -- Not passed 2 Hour
                    || ' = '
                    || lvl_passed_time;
    
           RETURN;
      END IF;

      IF ( lvl_passed_time > 24 ) THEN
        
           p_out := f_msg('상온방치 24시간을 초과 하였습니다.', 'K', 1)    -- Unfreezing over passed 24 Hour
                    || ' = '
                    || lvl_passed_time;
  
           RETURN;
           
      END IF;
      
      
      
      -------------------------------------------------------------------------
      -- 선입선출 확인
      -------------------------------------------------------------------------
      lvi_count := 0 ;
      
          SELECT COUNT (*), MIN( item_barcode )
            INTO lvi_count, lvs_fifo_item_barcode
            FROM im_item_solder_master
           WHERE item_code     = lvs_item_code
             AND item_barcode  <> p_barcode
             AND receipt_date  IS NOT NULL
             AND issue_date    IS NOT NULL
             AND unfreezing_start_date IS NOT NULL
             AND mix_start_date        IS NULL
             AND input_date    IS NULL
             AND DESTROY_DATE  IS NULL
             AND item_barcode  <  p_barcode   -- 순차적으로 출고  
             AND nvl(machine_code, '') = nvl(substr( p_barcode, 11, 1), 'A')   -- 공장단위 FIFO  
             AND organization_id = 1 ;
        
      IF ( lvi_count > 0 ) THEN
        
         p_out :=  f_msg('교반 선입선출 위반.', 'K', 1)      -- First In First Out. Validation NG
                   || ' = '
                   || p_barcode || ', ' || lvs_fifo_item_barcode;
                   
 
         RETURN;
         
      END IF;      
      

      -- 교반입시 상온방치종료시간, 교반입시간 모두 업데이트
      UPDATE im_item_solder_master
         SET unfreezing_end_date   = SYSDATE,
             mix_start_date        = SYSDATE,
             unfreezing_start_temp = lvl_temp1,
             unfreezing_end_temp   = lvl_temp2
       WHERE item_barcode          = p_barcode
         AND receipt_date          IS NOT NULL
         AND issue_date            IS NOT NULL
         AND unfreezing_start_date IS NOT NULL
         AND mix_start_date        IS NULL
         AND organization_id       = 1;

      COMMIT;
      p_out := 'OK';
      RETURN;
      
   END IF;

   ----------------------------------------------------------------------------------
   -- 교반출 AND NORMAL -- 취소로직 없슴
   ----------------------------------------------------------------------------------
   IF p_type = 'O' THEN  --AND p_deficit = 'N'
     
   --------------------------------------------------------------------
   -- 교반완료 이력 확인
   --------------------------------------------------------------------    
     
      BEGIN
        
       SELECT COUNT (*)
         INTO lvi_count
         FROM im_item_solder_master
        WHERE item_barcode          = p_barcode
          AND receipt_date          IS NOT NULL
          AND issue_date            IS NOT NULL
          AND unfreezing_start_date IS NOT NULL
          AND mix_start_date        IS NOT NULL
          AND mix_end_date          IS NOT NULL
          AND organization_id       = 1;
          
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND THEN
              lvi_count := 0;
      END;


      IF ( lvi_count = 1 ) THEN
        
         p_out := f_msg('이미 교반완료 처리가 되었습니다.', 'K', 1);       -- Not found data for solder mixing
  
         RETURN;
         
      END IF;
      
   
      BEGIN
        
       SELECT COUNT (*), SUM ( ( sysdate - mix_start_date ) * (24*60*60))
         INTO lvi_count, lvl_passed_time
         FROM im_item_solder_master
        WHERE item_barcode          = p_barcode
          AND receipt_date          IS NOT NULL
          AND issue_date            IS NOT NULL
          AND unfreezing_start_date IS NOT NULL
          AND mix_start_date        IS NOT NULL
          AND mix_end_date          IS NULL
          AND organization_id       = 1;
          
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND THEN
              lvi_count := 0;
      END;


      IF ( NVL (lvi_count, 0) = 0 ) THEN
        
         p_out := f_msg('스캔한 솔더가 교반출 할 내역이 존재하지 않습니다.', 'K', 1);       -- Not found data for solder mixing
  
         RETURN;
         
      END IF;

      IF ( lvl_passed_time < 60 ) THEN
        
--         p_out := f_msg('교반시간이 1분을 경과되지 않았습니다.', 'K', 1)      --  Not yet passed 1 minute  -- 3/26일 60sec 에서 30sec 로 변경 요청
           p_out := f_msg('교반시간이 60초를 경과되지 않았습니다.', 'K', 1)      
                          || ' = '
                          || lvl_passed_time;
              
        RETURN;
        
      END IF;

      UPDATE im_item_solder_master
         SET mix_end_date          = SYSDATE
       WHERE item_barcode          = p_barcode
         AND receipt_date          IS NOT NULL
         AND issue_date            IS NOT NULL
         AND unfreezing_start_date IS NOT NULL
         AND mix_start_date        IS NOT NULL
         AND mix_end_date          IS NULL
         AND organization_id       = 1;

      COMMIT;
      p_out := 'OK';
      RETURN;
      
   END IF;

   ----------------------------------------------------------------------------------
   -- COMPARE AND NORMAL
   -- 기존에 이미 투입이력 있는지 체크 한다 .
   ----------------------------------------------------------------------------------

   IF ( p_type = 'C' AND p_deficit = 'N' ) THEN

      IF ( p_line_code = '' OR p_line_code  IS NULL ) THEN
           p_out :=  f_msg('투입할 라인을 입력하세요.', 'K', 1);  -- Input Line
           RETURN;
      END IF ;
      

      BEGIN
        
      -------------------------------------------
      -- 투입라인에 이미 투입된 솔더인지 확인
      -------------------------------------------           

/*
         SELECT COUNT(*)
           INTO lvi_count
           FROM im_item_solder_master
          WHERE item_barcode    = p_barcode
            AND receipt_date    IS NOT NULL
            AND issue_date      IS NOT NULL
            AND mix_end_date    IS NOT NULL
            AND input_date      IS NOT NULL
            AND DESTROY_DATE    IS NULL
            AND organization_id = 1
            AND line_code       = p_line_code;
*/            
            
        SELECT COUNT(*)
           INTO lvi_count
           FROM ip_product_line
          WHERE solder_lot_no   = p_barcode
            AND line_code       = p_line_code
            AND organization_id = 1;            
            
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND THEN
              lvi_count := 0;
      END;
      
      IF ( lvi_count = 1 ) THEN
        
          p_out := f_msg('투입 할 라인에 스캔 솔더가 이미 투입 되었습니다.', 'K', 1);    -- Solder status unmaatch for Input
          RETURN;
          
      END IF;
      

      BEGIN
        
      -------------------------------------------
      -- 솔더상태 확인, 교반완료이면서 폐기가 안된것
      -------------------------------------------      
            
         SELECT COUNT(*)
           INTO lvi_count
           FROM im_item_solder_master
          WHERE item_barcode    = p_barcode
            AND receipt_date    IS NOT NULL
            AND issue_date      IS NOT NULL
            AND mix_end_date    IS NOT NULL
         --   AND input_date      IS NOT NULL    -- 2021-06-21 중복투입허용
            AND DESTROY_DATE    IS NULL
            AND organization_id = 1;
            
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND THEN
              lvi_count := 0;
      END;

      IF ( lvi_count = 0 ) THEN
        
         -- p_out := f_msg('이미 라인투입 처리된 솔더 입니다.', 'K', 1);    -- Solder status unmaatch for Input
          p_out := f_msg('교반완료가 안되거나 폐기된 솔더 입니다.', 'K', 1); 
 
          RETURN;
          
      END IF;
      
      
      BEGIN
       
   ----------------------------------------------------------------------------------
   -- 장착모델 소러타입
   ----------------------------------------------------------------------------------
          
        select NVL(solder_type, '*')
          into lvs_line_solder_type
          from ip_product_model_master
         where model_name = ( 
                             select model_name
                               from ip_product_line
                              where line_code       = P_LINE_CODE
                                AND organization_id = 1
                            )
            AND organization_id = 1;
                          
     EXCEPTION 
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
        WHEN OTHERS THEN 
             lvs_line_solder_type := '*' ;
     END ;                 
      
     IF ( (lvs_line_solder_type <> lvs_solder_type) OR lvs_line_solder_type = '*' OR lvs_solder_type = '*' ) THEN
       
           p_out := f_msg('장착 모델에 맞지 않은 솔더타입 입니다.', 'K', 1)
                    || ' = '
                    || lvs_line_solder_type
                    || ', '
                    || lvs_solder_type;
    
           RETURN;
           
     END IF ;  
     
   ----------------------------------------------------------------------------------
   -- 장착라인 확인
   ----------------------------------------------------------------------------------     
     
     BEGIN 
 
        SELECT run_no,     last_solder_lot_no,     last_solder_check_date    --decode(to_char(last_solder_check_date,'HH24:MI:SS'),'00:00:00', sysdate, last_solder_check_date )
          INTO lvs_run_no, lvs_last_solder_lot_no, lvs_last_solder_check_date 
          FROM IP_PRODUCT_LINE
         WHERE LINE_CODE = SUBSTR (p_line_code, 1, 2);
         
     EXCEPTION 
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
        WHEN OTHERS THEN 
            lvs_run_no := '*';
     END ; 
        
        
     
     
/*  
   ----------------------------------------------------------------------------------
   -- 기존투입 솔더가 24시간이 지났다면 NG 처리
   -- 라인 정보에서 기존 솔더 정보 조회 
   ----------------------------------------------------------------------------------
    BEGIN 
 
      SELECT SOLDER_LOT_NO
        INTO lvs_pre_solder
        FROM IP_PRODUCT_LINE
       WHERE LINE_CODE         = P_LINE_CODE
         AND SOLDER_CHECK_DATE IS NOT NULL
         AND SOLDER_LOT_NO     IS NOT NULL
         AND (SYSDATE - SOLDER_CHECK_DATE) > 1 ;  -- over 24 hour 
         
     EXCEPTION 
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
        WHEN OTHERS THEN 
             NULL ;
     END ;  
     
      --과거 솔더가 있고              
      IF  lvs_pre_solder IS NOT NULL THEN   
             
         SELECT COUNT (*)
           INTO lvi_count
           FROM im_item_solder_master
          WHERE solder_lot_no   = f_get_lot_no_from_barcode (lvs_pre_solder)
            AND DESTROY_DATE    IS NULL 
            AND organization_id = 1;
            
          -- 폐기도 되안되어 있으면          
         IF LVI_COUNT > 0 THEN
            p_out := f_get_item_code_from_barcode (lvs_pre_solder)||' '
                     || CHR(13)
                     || f_msg('The previous lot has already passed 24 hours. Need destroy','E',1);
                   --    p_out := '앞서 투입한 솔더가 24시간을 넘었습니다';
            RETURN;
        END IF;             
         
     END IF;    
 */
 
   ----------------------------------------------------------------------------------
   --  투입 이력
   ----------------------------------------------------------------------------------
      BEGIN
        
         SELECT MAX (line_code),
                MAX (model_name),
                MAX (input_date),
                COUNT (*),
                ROUND (SUM ( (SYSDATE - input_date) * 24), 1)
           INTO lvs_line_code,
                lvs_model_name,
                lvdt_input_date,
                lvi_count,
                lvl_passed_time
           FROM im_item_solder_master
          WHERE item_barcode    = p_barcode
            AND receipt_date    IS NOT NULL
            AND issue_date      IS NOT NULL
            AND mix_end_date    IS NOT NULL
               -- AND input_date IS NOT NULL                                        -- 2021-06-21 중복투입허용
            AND organization_id = 1;
            
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND THEN
              lvi_count := 0;
      END;

      -------------------------------------------
      -- 모델 마스터에 솔더 품목 코드 세팅
      -------------------------------------------
      IF ( NVL (lvi_count, 0) = 0 ) THEN
        
          p_out := f_msg('투입 할 솔더상태가 교반완료 상태가 안닙니다.', 'K', 1);    -- Solder status unmaatch for Input
   
          RETURN;
     
      -----------------------------------------------------------------
      -- 투입 된 시간을 조회 한다 
      -----------------------------------------------------------------
      ELSE
        
               SELECT COUNT (*), MAX (input_date), MAX (solder_lot_no)
                 INTO lvi_count, lvdt_input_date, lvs_solder_lot_no
                 FROM im_item_solder_master
                WHERE item_barcode    = p_barcode
                  AND organization_id = 1;
               --   AND input_date      IS NOT NULL; --이미 투입된것을 찾는데     -- 2021-06-21 중복투입허용

         --      IF ( lvi_count = 0 ) THEN
         --           NULL ;  -- 투입가능                
         --      ELSE
         --        
         --           p_out := f_msg('이미 투입 되었습니다.', 'K', 1);              -- Already has been Input
         --
         --           RETURN;
         --           
         --     END IF;
              
        END IF;

      ----------------------------------------------------------------------------------
      -- 교반이력 확인
      ----------------------------------------------------------------------------------
      BEGIN
        
         SELECT COUNT (*), ROUND (SUM ( (SYSDATE - issue_date) * 24), 1)
           INTO lvi_count, lvl_passed_time
           FROM im_item_solder_master
          WHERE item_barcode    = p_barcode
            AND receipt_date    IS NOT NULL
            AND issue_date      IS NOT NULL
            AND mix_end_date    IS NOT NULL
          --  AND input_date      IS NULL                                         -- 2021-06-21 중복투입허용
            AND organization_id = 1;
            
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND THEN
              lvi_count := 0;
      END;

      IF ( NVL (lvi_count, 0) = 0 ) THEN
        
          p_out := f_msg('교반출 이력이 없습니다.', 'K', 1);   -- Not found mixing out data.

          RETURN;
          
      END IF;

--      IF ( lvl_passed_time < 2 ) THEN
--           -- p_out := f_msg('Not yet over passed 2 hour=','E',1)
--           --          || lvl_passed_time;
--          p_out := '2시간이 경과되지 않았습니다 = '|| lvl_passed_time;
--          RETURN;
--      END IF;
      
      

      ------------------------------------------------------------------------------------
      -- 당일 해당 LOT 에 대한 점도측정 확인
      -----------------------------------------------------------------------------------

         SELECT count(*)
           INTO lvi_count
           FROM IQ_MACHINE_INSPECT_DATA_SOLDER
          WHERE ENTER_DATE >= TRUNC(SYSDATE)
            AND SOLDER_NO IN ( 
                               SELECT ITEM_BARCODE
                                 FROM IM_ITEM_SOLDER_MASTER
                                WHERE (ITEM_CODE, VALID_DATE) = (
                                                                 SELECT ITEM_CODE, VALID_DATE
                                                                   FROM IM_ITEM_SOLDER_MASTER
                                                                  WHERE ITEM_BARCODE = p_barcode
                                                                )
                             );
                         
          
         SELECT TO_CHAR(SYSDATE, 'HH24MI')
           INTO lvs_str
           FROM DUAL;
          
         IF ( lvs_str > '0830' AND lvi_count = 0 and nvl(substr( p_barcode, 11, 1), 'A') = 'A' ) THEN  -- A 공장만 적용
           
              p_out := f_msg('당일 투입 LOT에 점도 측정이 안되었습니다.', 'K', 1);
 
              RETURN;
                    
         END IF;
                
      ------------------------------------------------------------------------------------
      -- 점도 측정후 10시간 경과 확인
      -----------------------------------------------------------------------------------
      BEGIN
        
         SELECT COUNT (*), SUM( (SYSDATE - decode(viscosity_start_date, NULL, sysdate, viscosity_end_date)) * 24), NVL(MAX(VISCOSITY),0)
           INTO lvi_count, lvl_passed_time, lv1_viscosity
           FROM im_item_solder_master
          WHERE item_barcode       = p_barcode
            AND receipt_date       IS NOT NULL
            AND issue_date         IS NOT NULL
            AND viscosity_end_date IS NOT NULL
         --   AND input_date   IS NULL                        -- 2021-06-21 중복투입허용
            AND organization_id = 1;
            
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND THEN
              lvi_count := 0;
      END;

      IF ( lvi_count = 0 and nvl(substr( p_barcode, 11, 1), 'A') = 'A' ) THEN  -- A 공장만 적용
        
           p_out := f_msg('점도측정이 되지 않은 솔더입니다.', 'K', 1);
 
           RETURN;
           
      ELSE
        
          IF ( lvs_solder_type = 'F' ) THEN
            
               IF ( lv1_viscosity < 180 OR lv1_viscosity > 220 ) and nvl(substr( p_barcode, 11, 1), 'A') = 'A' THEN  -- A 공장만 적용
                 
                    p_out := f_msg('무연솔더 측정점도 이상( 180< <220 )', 'K', 1)
                             || ' = '
                             || lv1_viscosity;
  
                    RETURN;
                    
               END IF;
            
          ELSE

               IF ( lv1_viscosity < 180 OR lv1_viscosity > 230 ) and nvl(substr( p_barcode, 11, 1), 'A') = 'A' THEN  -- A 공장만 적용
                 
                    p_out := f_msg('유연솔더 측정점도 이상( 180< <230 )', 'K', 1)
                             || ' = '
                             || lv1_viscosity;
  
                    RETURN;
                    
               END IF;            
            
          END IF;
          
      END IF; 
      
       
      
      IF ( lvl_passed_time >= 10 and nvl(substr( p_barcode, 11, 1), 'A') = 'A' ) THEN   -- A 공장만 적용
        
           p_out := f_msg('점도측정 후 10시간이 경과 되었습니다.', 'K', 1)   -- After Input 24 Hour Over Passed
                    || ' = '
                    || lvl_passed_time;
 
           RETURN;
         
      END IF;     
      
 

      ------------------------------------------------------------------------------------
      -- 냉장고 출고 후 24시간 경과 확인
      -----------------------------------------------------------------------------------
      BEGIN
        
         SELECT COUNT (*), ROUND (SUM ( (SYSDATE - issue_date) * 24), 1)
           INTO lvi_count, lvl_passed_time
           FROM im_item_solder_master
          WHERE item_barcode = p_barcode
            AND receipt_date IS NOT NULL
            AND issue_date   IS NOT NULL
        --    AND input_date   IS NULL          -- 2021-06-21 중복투입허용
            AND organization_id = 1;
            
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND THEN
              lvi_count       := 0;
      END;

      IF ( lvl_passed_time > 24 ) THEN
        
           p_out := f_msg('냉장고 출고 후 24시간이 경과 되었습니다.', 'K', 1)     -- After Input 24 Hour Over Passed
                    || ' = '
                    || lvl_passed_time;
 
           RETURN;
         
      END IF;
      
      -------------------------------------------------------------------------
      -- 선입선출 확인
      -------------------------------------------------------------------------
      lvi_count := 0 ;
      
          SELECT COUNT (*), MIN( item_barcode )
            INTO lvi_count, lvs_fifo_item_barcode
            FROM im_item_solder_master
           WHERE item_code     = lvs_item_code
             AND item_barcode  <> p_barcode
             AND receipt_date  IS NOT NULL
             AND issue_date    IS NOT NULL
             AND unfreezing_start_date IS NOT NULL
             AND mix_start_date        IS  NOT NULL
             AND input_date    IS NULL               
             AND DESTROY_DATE  IS NULL
             AND item_barcode  <  p_barcode   -- 순차적으로 출고  
             AND nvl(machine_code, '') = nvl(substr( p_barcode, 11, 1), 'A')   -- 공장단위 FIFO  
             AND organization_id = 1 ;
        
      IF ( lvi_count > 0 ) THEN
        
         p_out :=  f_msg('투입 선입선출 위반.', 'K', 1)      -- First In First Out. Validation NG
                   || ' = '
                   || p_barcode || ', ' || lvs_fifo_item_barcode;
         RETURN;
         
      END IF;          
      

      ------------------------------------------------------------------
      -- 복수투입인지 확인
      ------------------------------------------------------------------
      
   --   select count(*)
   --     into lvl_dup_count
   --     from ip_product_line
   --    where solder_lot_no = p_barcode;
       
       
      select count(*)   -- 투입여부 확인
        into lvl_dup_count
        from im_item_solder_master
       where item_barcode = p_barcode
         and input_date is not null;             
         
      ------------------------------------------------------------------
      -- 투입이력갱신
      ------------------------------------------------------------------       
           
      IF ( p_barcode = lvs_last_solder_lot_no ) THEN
      
         if ( lvl_dup_count = 0 ) then
           
              UPDATE im_item_solder_master
                 SET input_date             = NVL(first_line_input_date, sysdate) , 
                     first_line_input_date  = NVL(first_line_input_date, sysdate),
                     line_code              = SUBSTR (p_line_code, 1, 2), 
                     model_name             = p_model_name,
                     run_no                 = lvs_run_no,
                     open_date              = NVL(first_line_input_date, sysdate)
               WHERE item_barcode           = p_barcode
                 AND receipt_date           IS NOT NULL
                 AND issue_date             IS NOT NULL
                 AND mix_end_date           IS NOT NULL
                 AND input_date             IS NULL
                 AND organization_id        = 1;
             
         end if;
         
          UPDATE ip_product_line x
             SET solder_check_date      = NVL(last_solder_check_date, sysdate) ,              
                 SOLDER_LOT_NO          = p_barcode,
                 LAST_SOLDER_LOT_NO     = NVL(LAST_SOLDER_LOT_NO, p_barcode),
                 LAST_SOLDER_CHECK_DATE = NVL(LAST_SOLDER_CHECK_DATE, sysdate)           
           WHERE line_code         = SUBSTR (p_line_code, 1, 2);
                   
      ELSE
        
          if ( lvl_dup_count = 0 ) then
            
                UPDATE im_item_solder_master
                   SET input_date             = SYSDATE,   
                       first_line_input_date  = NVL(first_line_input_date, sysdate),
                       line_code              = SUBSTR (p_line_code, 1, 2), 
                       model_name             = p_model_name,
                       run_no                 = lvs_run_no,
                       open_date              = SYSDATE
                 WHERE item_barcode    = p_barcode
                   AND receipt_date    IS NOT NULL
                   AND issue_date      IS NOT NULL
                   AND mix_end_date    IS NOT NULL
                   AND input_date      IS NULL
                   AND organization_id = 1;   
             
           end if;   
        
          UPDATE ip_product_line x
             SET solder_check_date      = SYSDATE                          -- INPUT DATE 와 같은 의미
                ,SOLDER_LOT_NO          = p_barcode                        -- 2016.04.27 zethani
                ,LAST_SOLDER_LOT_NO     = NVL(SOLDER_LOT_NO, p_barcode)
                ,LAST_SOLDER_CHECK_DATE = NVL(SOLDER_CHECK_DATE, sysdate)
           WHERE line_code              = SUBSTR (p_line_code, 1, 2);
       
      END IF;
      
      ------------------------------------------------------------------
      -- 솔더를 작업지시대비 재투입되기에 별도의 이력을 남김
      ------------------------------------------------------------------      
      INSERT INTO IM_ITEM_SOLDER_INPUT_HIST (
                                             line_code, 
                                             run_no, 
                                             input_date, 
                                             solder_lot_no, 
                                             enter_date,  
                                             enter_by, 
                                             last_modify_date, 
                                             last_modify_by,
                                             machine_code
                                            )
                                      VALUES(
                                              SUBSTR (p_line_code, 1, 2), 
                                              lvs_run_no,
                                              sysdate,
                                              p_barcode,
                                              sysdate,
                                              p_userid,
                                              sysdate,
                                              p_userid,
                                              nvl(substr( p_barcode, 11, 1), 'A') 
                                            );

       
      COMMIT;
      p_out := 'OK';
      RETURN;
   -------------------------------------------------------------------
   -- COMPARE  CANCEL
   --
   -------------------------------------------------------------------
   ELSIF ( p_type = 'C' AND p_deficit = 'C' ) THEN

       IF ( p_line_code = '' OR p_line_code IS NULL ) THEN

            p_out := f_msg('취소 할 라인을 입력 하세요.', 'K', 1);  -- Inut Line
            RETURN;

      END IF ;

      BEGIN
        
         SELECT COUNT (*)
           INTO lvi_count
           FROM im_item_solder_master
          WHERE item_barcode    = p_barcode
            AND receipt_date    IS NOT NULL
            AND issue_date      IS NOT NULL
            AND mix_end_date    IS NOT NULL
            AND input_date      IS NOT NULL
            AND DESTROY_DATE    IS NULL 
            AND organization_id = 1;
                
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND THEN
              lvi_count := 0;
      END;

      IF ( lvi_count = 0 ) THEN
        
           p_out := f_msg('솔더가 라인투입 상태가 아닙니다.', 'K', 1);   -- Inut data not found.
           RETURN;
           
      END IF;   
      
      select count(*)
        into lvi_count
        from ip_product_line
       where solder_lot_no = p_barcode
         and line_code     = SUBSTR (p_line_code, 1, 2);
       
      IF ( lvi_count = 0 ) THEN
        
           p_out := f_msg('라인 투입이력이 없습니다.', 'K', 1);   -- Inut data not found.
           RETURN;
           
      END IF;  
      
      ------------------------------------------------------------------
      -- 복수투입인지 확인
      ------------------------------------------------------------------      
       
      select count(*), max(line_code)
        into lvl_dup_count, lvs_line_code
        from ip_product_line
       where solder_lot_no = p_barcode;
                
      --------------------------------------------------------------------
      -- 복수투입을 고려하여 하나이상 투입되어 있다면 투입상태 유지
      --------------------------------------------------------------------
      
      if ( lvl_dup_count = 1 and lvs_line_code = SUBSTR (p_line_code, 1, 2) ) then
        
          UPDATE im_item_solder_master
             SET input_date  = NULL, 
                 return_date = SYSDATE , 
                 line_code   = null, 
                 model_name  = null, 
                 run_no      = null
           WHERE item_barcode    = p_barcode
             AND receipt_date    IS NOT NULL
             AND issue_date      IS NOT NULL
             AND mix_end_date    IS NOT NULL
             AND input_date      IS NOT NULL
             AND organization_id = 1;
         
      end if;

      UPDATE ip_product_line
         SET solder_check_date = NULL
            ,SOLDER_LOT_NO     = null                 -- 2016.04.27 zethani
       WHERE SOLDER_LOT_NO     = p_barcode
         and line_code         = SUBSTR (p_line_code, 1, 2);
       
   END IF;
   
   COMMIT;
   p_out := 'OK';
   
EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS THEN
     
        p_out := 'NG, [P_CHECK_SOLDER_SCAN_USER] ' 
                 || SQLERRM;
                 
END;
