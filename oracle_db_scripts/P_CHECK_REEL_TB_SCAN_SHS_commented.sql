CREATE OR REPLACE PROCEDURE "P_CHECK_REEL_TB_SCAN_SHS" (
  /* ================================================================
   * 프로시저명  : P_CHECK_REEL_TB_SCAN_SHS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2016-10-17
   * 수정이력:
   *   2016-10-17 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   입력 조건을 기준으로 업무 데이터의 유효성 또는 상태를 확인한다.
   *   조회 결과와 원본 분기 조건에 따라 OUT 파라미터 또는 상태 값을 설정한다.
   *   호출부가 결과 코드와 메시지로 후속 처리를 판단할 수 있게 한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_PLAN_DATE - 원본 선언부 기준 입력/출력 파라미터
   *   P_MODEL_NAME - 원본 선언부 기준 입력/출력 파라미터
   *   P_LINE_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_TOPBOT - 원본 선언부 기준 입력/출력 파라미터
   *   P_ADDRESS - 원본 선언부 기준 입력/출력 파라미터
   *   P_ORIGIN_BARCODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_SUPPLIER_BARCODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_BARCODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_USERID - 원본 선언부 기준 입력/출력 파라미터
   *   P_DEFICIT - 원본 선언부 기준 입력/출력 파라미터
   *   P_RETURN - 원본 선언부 기준 입력/출력 파라미터
   *   P_SEQUENCE - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IB_PRODUCT_PLANDATA - 원본 로직 참조 테이블
   *   IB_SMT_CHECKHIST - 원본 로직 참조 테이블
   *   ID_ITEM - Item Master
   *   IM_ITEM_BAKING_MASTER - 원본 로직 참조 테이블
   *   IM_ITEM_RECEIPT_BARCODE - 원본 로직 참조 테이블
   *   IP_PRODUCT_LINE - Product Line Master
   *   ISYS_CONFIG - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   FOUND
   *   F_CHECK_RECEIPT_BARCODE_EXISTS
   *   F_GET_ITEM_CODE_FROM_BARCODE
   *   F_GET_LOT_NO_FROM_BARCODE
   *   F_GET_LOT_QTY_FROM_BARCODE
   *   F_GET_MACHINE_NAME
   *   F_GET_MSL_PASSED_TIME
   *   F_GET_PREPARE_BARCODE
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
   *   EXEC P_CHECK_REEL_TB_SCAN_SHS(...)
   * ================================================================ */
   p_plan_date          IN     VARCHAR2,
   p_model_name         IN     VARCHAR2,
   p_line_code          IN     VARCHAR2,
   p_topbot             IN     VARCHAR2,
   p_address            IN     VARCHAR2,
   p_origin_barcode     IN     VARCHAR2,
   p_supplier_barcode   IN     VARCHAR2,
   p_barcode            IN     VARCHAR2,
   p_userid             IN     VARCHAR2,
   p_deficit            IN     VARCHAR2,
   p_return                OUT VARCHAR2,
   p_sequence              OUT VARCHAR2)
IS
   -------------------------------------------------------
   -- PLAN DATE FORMAT : YYYYMMDD
   -- p_deficit : 3 = NORMAL , 4 = CANCEL
   -- RETURN : OK , OTHERS : ERROR
   -- BARCODE STATUS : 0 = PRINT , 1 = RECEIPT , 2 = ISSUE
   -------------------------------------------------------
   lvi_count                        NUMBER; -- [AI] 내부 처리용 변수
   lvi_lot_count                    NUMBER; -- [AI] 내부 처리용 변수
   lvi_replace                      NUMBER; -- [AI] 내부 처리용 변수
   lvi_no_ccs                       NUMBER; -- [AI] 내부 처리용 변수

   lvs_line_code                    VARCHAR2 (20); -- [AI] 내부 처리용 변수
   lvs_new_barcode_status           VARCHAR2 (1); -- [AI] 내부 처리용 변수

   lvs_item_code                    VARCHAR2 (30); -- [AI] 내부 처리용 변수
   lvs_item_code_new                VARCHAR2 (30); -- [AI] 내부 처리용 변수
   lvs_item_code_origin             VARCHAR2 (30); -- [AI] 내부 처리용 변수

   lvs_partname                     VARCHAR2 (30); -- [AI] 내부 처리용 변수
   lvs_item_code_supplier           VARCHAR2 (50); -- [AI] 내부 처리용 변수
   lvs_item_code_supplier_replace   VARCHAR2 (50); -- [AI] 내부 처리용 변수

   lvs_item_code_new_replace        VARCHAR2 (50); -- [AI] 내부 처리용 변수

   lvl_item_qty                     NUMBER; -- [AI] 내부 처리용 변수
   lvs_model_name                   VARCHAR2 (50); -- [AI] 내부 처리용 변수
   lvs_receipt_compare_yn           VARCHAR2 (1); -- [AI] 내부 처리용 변수
   lvs_issue_compare_yn             VARCHAR2 (1); -- [AI] 내부 처리용 변수
   lvs_holding_yn                   VARCHAR2 (1); -- [AI] 내부 처리용 변수

   lvs_inventory_hold               VARCHAR2 (1); -- [AI] 내부 처리용 변수
   lvs_lot_no                       VARCHAR2 (30); -- [AI] 내부 처리용 변수
   lvs_lot_no_origin                VARCHAR2 (30); -- [AI] 내부 처리용 변수

   lvl_first                        NUMBER; -- [AI] 내부 처리용 변수
   lvl_second                       NUMBER; -- [AI] 내부 처리용 변수

   lvl_first_origin                 NUMBER; -- [AI] 내부 처리용 변수
   lvl_second_origin                NUMBER; -- [AI] 내부 처리용 변수

   lvl_first_supplier               NUMBER; -- [AI] 내부 처리용 변수
   lvl_second_supplier              NUMBER; -- [AI] 내부 처리용 변수

   lvs_origin_barcode               VARCHAR2 (100); -- [AI] 내부 처리용 변수
   lvs_supplier_barcode             VARCHAR2 (100); -- [AI] 내부 처리용 변수
   lvs_new_barcode                  VARCHAR2 (100); -- [AI] 내부 처리용 변수

   lvl_change_time                  NUMBER; -- [AI] 내부 처리용 변수
   lvl_delay_time                   NUMBER; -- [AI] 내부 처리용 변수
   phase                            VARCHAR2 (10); -- [AI] 내부 처리용 변수

   lvl_check_seq                    NUMBER; -- [AI] 내부 처리용 변수

   lvs_no_css_address               VARCHAR2 (30); -- [AI] 내부 처리용 변수
   lvs_label_type                   VARCHAR2 (10); -- [AI] 내부 처리용 변수
   lvs_lot_serial                   VARCHAR2 (10); -- [AI] 내부 처리용 변수
   lvdt_valid_date                  DATE; -- [AI] 내부 처리용 변수
   lvdt_inspect_date                DATE; -- [AI] 내부 처리용 변수
   lvs_trace_code                   VARCHAR2 (30); -- [AI] 내부 처리용 변수
   LVS_VENDOR_NAME                  VARCHAR2 (30); -- [AI] 내부 처리용 변수

   lvs_supplier_code                VARCHAR2 (30); -- [AI] 내부 처리용 변수

   lvl_new_scan_qty                 NUMBER; -- [AI] 내부 처리용 변수
   lvi_last_lot_no                  NUMBER; -- [AI] 내부 처리용 변수
   lvi_msl_over_count               NUMBER; -- [AI] 내부 처리용 변수
   LVL_TIME_TERM                    NUMBER := 1 ; --300000; -- [AI] 내부 처리용 변수
   
   lvs_inventory_type               VARCHAR2 (10) ; -- [AI] 내부 처리용 변수
   lvs_production_type              VARCHAR2 (10) ; -- [AI] 내부 처리용 변수
   
   lvs_smt_model_name  VARCHAR2(50) := '*' ; -- [AI] 내부 처리용 변수
   lvs_feeding_yn varchar2(10) ; -- [AI] 내부 처리용 변수
   lvi_aready_exists NUMBER ; -- [AI] 내부 처리용 변수
   
   lvi_row_count NUMBER ; -- [AI] 내부 처리용 변수
   lvl_ng_location_count NUMBER ; -- [AI] 내부 처리용 변수
   lvi_line_nsnp_count NUMBER ; -- [AI] 내부 처리용 변수
   
   lvs_run_no                       VARCHAR2 (30); -- [AI] 내부 처리용 변수
   
   lvs_reel_destroy_yn              VARCHAR2 (10) ; -- [AI] 내부 처리용 변수
   
   lvs_machine_name                VARCHAR2 (100); -- [AI] 내부 처리용 변수
   lvs_barcode                     VARCHAR2 (50); -- [AI] 내부 처리용 변수
    
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.

   phase := '05';

  
       IF (f_check_receipt_barcode_exists(p_origin_barcode, 1) <> 'EXISTS') THEN

           p_return := f_msg('[REEL] 자사 구 바코드가 올바르지 않습니다.','K',1) -- 00 Our previous Barcode Invalid
                       || ' = '
                       || p_line_code
                       || ', '
                       || p_address
                       || ', '
                       || p_origin_barcode;

           RETURN;

       END IF;
       
       
   phase := '06';

--   ----------------------------------------------------------------------------------------------
--   -- 2016/10/17 SHS, supplier barcode(p_supplier_barcode) 에 대해 바코드 master 등록여부 확인 
--   ----------------------------------------------------------------------------------------------
--
--       IF (f_check_receipt_barcode_exists(p_supplier_barcode, 1) = 'EXISTS') THEN
--
--           p_return := f_msg('[REEL] 원자재 바코드가 올바르지 않습니다.','K',1)  --'Material barcode Invalid '
--                       || ' = '
--                       || p_line_code
--                       || ' '
--                       || p_address
--                       || ' '
--                       || p_supplier_barcode;
--
--           RETURN;
--
--       END IF;
       
       
    phase := '07';

   ----------------------------------------------------------------------------------------------
   -- 2016/10/17 SHS, 이전 장착자재와 이후 장착 에정자재의 바코드가 동일한지 확인
   ----------------------------------------------------------------------------------------------

       IF (p_origin_barcode = p_barcode) THEN

           p_return := f_msg('[REEL] 자사 구,신 라벨이 동일 합니다.','K',1)  -- '00 Our new and old barcode same. '
                       || ' = '
                       || p_line_code
                       || ', '
                       || p_address
                       || ', '
                       || p_origin_barcode
                       || ', '
                       || p_barcode;

     
           RETURN;

       END IF;

   ----------------------------------------------------------------------------------------------
   -- 2016/10/17 SHS, our barcode(p_barcode) 에 대해 바코드 master 등록여부 확인 
   ----------------------------------------------------------------------------------------------

       IF (f_check_receipt_barcode_exists(p_barcode, 1) <> 'EXISTS') THEN

           p_return := f_msg('[REEL] 자사 신 바코드가 올바르지 않습니다.','K',1) -- '00 Our new barcode Invalid'
                       || ' = '
                       || p_line_code
                       || ', '
                       || p_address
                       || ', '
                       || p_barcode;


           RETURN;

       END IF;
       
       
   ----------------------------------------------------------------------------------------------
   -- 2020/11/16 SHS, 폐기여부 확인
   ----------------------------------------------------------------------------------------------       
       
       select count(*)
         into lvi_row_count
         from im_item_receipt_barcode
        where item_barcode = p_barcode
          and REEL_DESTROY_YN   = 'Y' ;
          
       IF ( lvi_row_count > 0 ) THEN

           p_return := f_msg('[REEL] 페기된 바코드 입니다.', 'K', 1) ; 
           p_sequence := '' ;
           RETURN;

       END IF;    
       
   ----------------------------------------------------------------------------------------------
   -- 2021/08/25  베이킹 또는 제습함 입고 자재인지 확인
   ----------------------------------------------------------------------------------------------       
       
	   select max(f_get_machine_name( chamber_code )), count(*)
       into lvs_machine_name, lvi_row_count     
       from im_item_baking_master

      where item_barcode like p_barcode
        and output_scan_date is null;
        
            
       IF ( lvi_row_count > 0 ) THEN

           p_return := f_msg('[REEL] '|| lvs_machine_name ||'에 미출고 자재입니다.', 'K', 1) ; --'00 'Our Barcode Invalid. '
           p_sequence := '' ;
           RETURN;

       END IF;                  


   phase := '10';

  
      lvs_origin_barcode   := f_get_prepare_barcode (p_origin_barcode);
      lvs_supplier_barcode := f_get_prepare_barcode (p_supplier_barcode);
  
   -----------------------------------------------------------------------------
   -- OUR NEW BARCODE
   -----------------------------------------------------------------------------

      lvs_new_barcode := f_get_prepare_barcode (p_barcode);
  
   ----------------------------------------------------------------------------
   --
   ----------------------------------------------------------------------------
   IF LENGTH (lvs_origin_barcode) < 8
      OR INSTR (lvs_origin_barcode, '@', 1) > 1
   THEN
      p_return := f_msg('[REEL] 구자재 바코드 오류.','K',1)  -- '00 Old barcode Invvalid '  
                  || ' = '
                  || lvs_origin_barcode;
      RETURN;
   END IF;

   phase := '11';

   IF LENGTH (lvs_supplier_barcode) < 5
   THEN
      p_return := f_msg('[REEL] 거래처 바코드 오류.','K',1) 
                  || ' = '
                  || lvs_supplier_barcode; -- '00 Supplier barcode Invvalid '  
      RETURN;
   END IF;

   IF    LENGTH (lvs_new_barcode) < 20
      OR INSTR (lvs_new_barcode, '@', 1) > 1
      OR INSTR (lvs_new_barcode, '---', 1) > 1
   THEN
      p_return :=  f_msg('[REEL] 신자재 바코드 오류.','K',1)
                   || ' = '
                   || lvs_new_barcode; -- '00 New barcode Invvalid '  
      RETURN;
   END IF;

   phase := '12';
   --------------------------------------------------------------------------------
   --
   --------------------------------------------------------------------------------

   lvs_item_code_origin   := f_get_item_code_from_barcode (lvs_origin_barcode);
  
   --------------------------------------------------------------------------------
   --
   --------------------------------------------------------------------------------
   lvs_item_code_supplier :=  f_get_item_code_from_barcode (lvs_supplier_barcode);

   ----------------------------------------------------------------------------------
   -- REPLACE SUPPLIER ITEM CODE
   -- 거래처 품목으로 대체품목을 찾아온다
   --
   ----------------------------------------------------------------------------------
   BEGIN
     
      SELECT MAX (item_code)
        INTO lvs_item_code_supplier_replace
        FROM id_item
       WHERE item_code = lvs_item_code_supplier
             OR part_no = lvs_item_code_supplier
             OR item_code =
                   SUBSTR (lvs_item_code_supplier, 1, LENGTH (item_code))
             OR part_no =
                   SUBSTR (lvs_item_code_supplier, 1, LENGTH (part_no));
                   
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND THEN
           lvs_item_code_supplier_replace := '*';
           
         --  p_return := f_msg('[REEL] 미등록 원자재 바코드 입니다.', 'K', 1);  --  '00 Our barcode Invalid.'
         --  RETURN;
   END;

   ----------------------------------------------------------------------------
   --
   ----------------------------------------------------------------------------
   lvs_item_code_new := f_get_item_code_from_barcode (lvs_new_barcode);

   phase := '13';

   ---------------------------------------------------------------------------
   -- check replace item
   -- 대체 가능한 자재인지 체크 한다
   ---------------------------------------------------------------------------
   lvi_replace := 0;

   BEGIN
     
      SELECT COUNT (*)
        INTO lvi_replace
        FROM ib_product_plandata
       WHERE model_name = p_model_name
         AND line_code = SUBSTR (p_line_code, 1, 2)
         AND location_code = p_address
         --    AND lvs_item_code_new LIKE '%' || item_code
         AND INSTR (lvs_item_code_new, item_code, 1) > 0
         AND pcb_item = p_topbot
         AND active_yn = 'Y';
             
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND THEN
           lvi_replace := 0;
   END;


---------------------------------------------------------------------
--   양산인지 샘플인지 체크 
---------------------------------------------------------------------
begin 

  select nvl(production_type, 'P'), run_no
    into lvs_production_type , lvs_run_no
    from ip_product_line 
   where line_code = SUBSTR (p_line_code, 1, 2) ;
   
 exception
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
    when others then 
         null;
end ;

   ----------------------------------------------------------------------------
   --
   ----------------------------------------------------------------------------
   lvs_lot_no_origin := f_get_lot_no_from_barcode (lvs_origin_barcode);
   lvs_lot_no        := f_get_lot_no_from_barcode (lvs_new_barcode);

   --------------------------------------------------
   -- CHECK ERP BARCODE CREATE HISTORY
   -- 인텍스 주의 LOT_NO 반드시 인덱스 태울것.
   --------------------------------------------------

   --IF SUBSTR (p_address, 1, 4) = 'TRAY' OR SUBSTR (p_address, 2, 4) = 'TRAY' THEN
   --   NULL;
   ---ELSE
     
      BEGIN
        
         SELECT barcode_status,
                scan_qty,
                receipt_compare_yn,
                NVL (issue_compare_yn, 'N'),
                holding_yn,
                label_type,
                NVL(line_code, '*'),
                supplier_code,
                NVL(new_scan_qty, 0) ,
                nvl(inventory_type , 'P'),
                feeding_yn,
                NVL(reel_destroy_yn, 'N')  
           INTO lvs_new_barcode_status,
                lvl_item_qty,
                lvs_receipt_compare_yn,
                lvs_issue_compare_yn,
                lvs_holding_yn,
                lvs_label_type,
                lvs_line_code,
                lvs_supplier_code,
                lvl_new_scan_qty ,
                lvs_inventory_type,
                lvs_feeding_yn,
                lvs_reel_destroy_yn
           FROM im_item_receipt_barcode
          WHERE lot_no = lvs_lot_no
             -- AND INSTR (lvs_item_code_new, item_code, 1) > 0
             -- AND issue_compare_yn = 'Y'
            AND NVL(receipt_compare_yn ,'N') = 'Y'  --   AND line_code = p_line_code
                                            ;
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND THEN
         
              lvs_receipt_compare_yn := 'N' ;
              lvs_issue_compare_yn   := 'N' ;
              
              null ;
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN OTHERS THEN
              p_return := SQLERRM;
      END;
      
   -- END IF;
  
   -----------------------------------------------------------------
   -- 이미종료된 자재인지 확인
   -----------------------------------------------------------------
   
   IF ( lvs_reel_destroy_yn = 'Y' ) THEN
     
        p_return := f_msg('[REEL] 이미 종료된 자재 입니다.', 'K', 1)    
                    || ' = '
                    || lvs_lot_no;
        RETURN; 
   
   END IF;  
   
   -----------------------------------------------------------------
   -- 생산유형과 자재 유형이 불일치 할 경우 
   -----------------------------------------------------------------
   
   IF lvs_production_type = 'P' THEN
     
       IF lvs_production_type <> lvs_inventory_type then 
         
             p_return := f_msg('[REEL] 자재유형이 일치하지 않습니다.','K',1)    -- '01 Inventory Type Unmatch '
                         || ' = '
                         || lvs_production_type
                         || ', '
                         || lvs_inventory_type ;
             RETURN; 
               
       END IF ; 
   
   END IF;
  ---------------------------------------------------------------------------
   --  이미 장착된 자재인지 체크 
   ---------------------------------------------------------------------------
   BEGIN
     
      SELECT count(*)
        INTO lvi_aready_exists
        FROM ib_product_plandata
       WHERE model_name = p_model_name
         AND line_code  = SUBSTR (p_line_code, 1, 2)
         AND pcb_item   = p_topbot
         AND lot_no     = lvs_lot_no
         AND active_yn  = 'Y'
         AND ROWNUM     = 1 ;
             
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND THEN
           NULL;
   END;

  IF nvl(lvi_aready_exists,0) > 0  then 
         p_return := f_msg('[REEL] 이미 장착된 바코드 입니다.','K',1)    -- 'Aready Used Barcode '
                     || ' = '
                     || lvs_new_barcode; 
         RETURN; 
  END IF ; 
  
   --------------------------------------------------------------------
   --  no issue barcode
   -- 미출고 자재 체크
   --------------------------------------------------------------------
   IF NVL(lvs_issue_compare_yn , 'N') = 'N' THEN --AND nvl(lvs_label_type , '*') NOT IN ('R', 'B') THEN                       --리볼 / 벌크
      
      lvl_check_seq := seq_check_seq.NEXTVAL;
      p_sequence    := lvl_check_seq;
      
      UPDATE ib_product_plandata
         SET check_status      = 'E',
             check_msg         = f_msg('[REEL] 미출고 자재입니다.','K',1)   --'02 Issue History Not Found (REEL) '
                                 || ' = '
                                 || lvs_new_barcode
                                 ||', '
                                 || lvs_issue_compare_yn ,
             selected_date     = TO_CHAR (SYSDATE, 'YYYY-MM-DD HH24:MI:SS'),
             change_date       = SYSDATE
       WHERE     model_name    = p_model_name
             AND line_code     = SUBSTR (p_line_code, 1, 2)
             AND location_code = p_address
             AND active_yn     = 'Y'
             AND pcb_item      = p_topbot;

        COMMIT;
      
        p_return := f_msg('[REEL] 미출고 자재입니다.','K',1)  -- 'No Issued Material '
                    || ' = '
                    || lvs_new_barcode
                    ||', '
                    ||lvs_issue_compare_yn ; 
        
        BEGIN
         --------------------------------------------------------------------------------
         -- NSNP START
         --------------------------------------------------------------------------------
         p_interlock_set_nsnp_time_msg (
                                         p_line_code,
                                         1,
                                         1,
                                         p_model_name,
                                         '*',
                                         'REEL CHECK',
                                         f_msg('[REEL] 미출고 자재입니다.','K',1)    -- 'No Issued Material '
                                         || ' = '
                                         || lvs_item_code_supplier
                                         || ', '
                                         || lvs_item_code_new
                                         || ', '
                                         || lvl_check_seq
                                         ||','
                                         || lvs_issue_compare_yn
                                        );
      --------------------------------------------------------------------------------
      -- NSNP END
      --------------------------------------------------------------------------------

      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN OTHERS THEN
              NULL;
      END;
      RETURN ;
   END IF;

   -----------------------------------------------------------------
   -- 신규스캔(생산잔량) 이 있으면 그수량으로 장착 아니면

   -- 라벨에 기입된 수량
   ----------------------------------------------------------------
   BEGIN
     
      IF lvl_new_scan_qty <> 0 THEN
         lvl_item_qty := lvl_new_scan_qty;
      ELSE
         -----------------------------------------------------------------
         --
         ----------------------------------------------------------------
         BEGIN
           
            lvl_item_qty := f_get_lot_qty_from_barcode (lvs_new_barcode);
            
         EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
            WHEN OTHERS THEN

               -- 2016/08/26 SHS, 수량정보 이상으로 인한 reflow 공정 NG 방지를 위해 NG 처리
               p_return := f_msg('[REEL] 바코드내 수량정보가 잘못 되었습니다.','K',1)    -- '01 Qty invaid in barcode. '
                           || ' = '
                           || lvs_new_barcode;
               RETURN;

               -- lvl_item_qty := 0;
         END;
         
      END IF;
      
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN OTHERS THEN
           lvl_item_qty := 0;
   END;

    ---------------------------------------------------------------------
    -- 제습함 check 
    ---------------------------------------------------------------------
         
        select count(*), max(item_barcode)
          into lvi_count, lvs_barcode
          from im_item_baking_master
         where chamber_type = 'D'
           and chamber_code = 'M0001'
           and output_scan_date is null
           and item_code        = lvs_item_code_new
           and input_scan_date  = (
                                    select min(input_scan_date)
                                      from im_item_baking_master
                                     where chamber_type = 'D'
                                       and chamber_code = 'M0001'
                                       and output_scan_date is null
                                       and item_code        = lvs_item_code_new
                                  );
       
    IF ( lvi_count > 0 ) then
      
         p_return := f_msg('[REEL] 제습함에 재고가 존재 합니다, 재고 소진 후 장착 하세요.', 'K', 1) 
                    || ' '
                    || lvs_barcode; 
          RETURN;
                              
    END IF;
    
    
/*
      ------------------------------------------------------------------------------
       --line unmatch
      ------------------------------------------------------------------------------
      IF SUBSTR (p_line_code, 1, 2) <> lvs_line_code THEN
        
         p_return := f_msg('[REEL] 출고와 투입라인이 일치 하지 않습니다.','K',1)       -- '06 Unmatch Line for Issue and Input .(REEL) '
                     || ' = '
                     || p_line_code
                     || ', '
                     || lvs_line_code;
         RETURN;
         
      END IF;
*/

   ---------------------------------------------------------------------------
   -- PARTNAME SELECT
   ---------------------------------------------------------------------------
   BEGIN
     
      SELECT item_code
        INTO lvs_partname
        FROM ib_product_plandata
       WHERE model_name    = p_model_name
         AND line_code     = SUBSTR (p_line_code, 1, 2)
         AND location_code = p_address
         AND pcb_item      = p_topbot
         AND active_yn     = 'Y'
         AND replace_yn    = 'N';
             
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND THEN
           lvi_replace := 0;
           NULL;
   END;


   IF SUBSTR (p_address, 1, 4) = 'TRAY' THEN
      NULL;
   ELSE
      ---------------------------------------------------------------------------
      --
      -- 이전자재 교환이력 있는지 체크
      ---------------------------------------------------------------------------
      BEGIN
        
         SELECT COUNT (*)
           INTO lvi_last_lot_no
           FROM IB_SMT_CHECKHIST
          WHERE lot_name      = p_model_name
            AND line_code     = SUBSTR (p_line_code, 1, 2)
            AND location_code = p_address
            AND pcb_item      = p_topbot
            AND partname      = lvs_item_code_origin
            AND lot_no        = lvs_lot_no_origin
            AND check_type    IN ('1', '2')  -- CCS, REEL CHANGE
            AND ROWNUM        = 1;
                
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND THEN
              lvi_last_lot_no := 0;
      END;

      IF NVL (lvi_last_lot_no, 0) = 0 THEN
        
         lvl_check_seq := seq_check_seq.NEXTVAL;
         p_sequence    := lvl_check_seq;

         ---------------------------------------------------
         --  SMT PDA MATERIAL POSITION check history insert
         ---------------------------------------------------
         INSERT INTO ib_smt_checkhist (check_date,
                                       check_sequence,
                                       plan_date,
                                       lot_name,
                                       partname,
                                       chipname,
                                       check_status,
                                       check_msg,
                                       check_by,
                                       line_code,
                                       machine,
                                       plan_date_sequence,
                                       scan_partname,
                                       scan_supplier_partname,
                                       location_code,
                                       check_type,
                                       table_id,
                                       pcb_item,
                                       item_code,
                                       supplier_barcode_origin,
                                       old_barcode,
                                       smt_model_name,
                                       ng_type,
                                       enter_date,
                                       enter_by)
         VALUES (
                   SYSDATE,
                   lvl_check_seq,
                   p_plan_date,
                   p_model_name,
                   lvs_item_code_origin,                      -- OUR ITEM CODE
                   lvs_item_code_origin,                 -- SUPPLIER ITEM CODE
                   'E',
                   f_msg('[REEL] 이전자재 교환 이력이 없습니다.','K',1),   -- '08 Previous reel change data notfound'
                   p_userid,
                   SUBSTR (p_line_code, 1, 2),
                   TRIM (SUBSTR (p_line_code, 4, 10)),
                   0,
                   lvs_new_barcode ,                          -- OUR BARCODE
                   lvs_supplier_barcode,
                   p_address,
                   p_deficit,
                   DECODE (SUBSTR (p_address, 1, 4), 'TRAY', 'Z', SUBSTR (p_address, 1, 1)),
                   p_topbot,
                   lvs_partname,
                   p_supplier_barcode,
                   lvs_smt_model_name,
                   p_origin_barcode,
                   '*',
                   sysdate,
                   p_userid
                 );

         COMMIT;

         UPDATE ib_product_plandata
            SET check_status  = 'E',
                check_msg     = f_msg('[REEL] 이전자재 교환 이력이 없습니다.','K',1)   -- '08 Previous reel change data notfound (REEL)'
                                || ' = '
                                || lvs_origin_barcode, 
                selected_date = TO_CHAR (SYSDATE, 'YYYY-MM-DD HH24:MI:SS'),
                change_date   = SYSDATE
          WHERE line_code     = SUBSTR (p_line_code, 1, 2)
            AND model_name    = p_model_name --   AND machine = TRIM (SUBSTR (p_line_code, 4, 10))
            AND location_code = p_address
            AND active_yn     = 'Y'
            AND pcb_item      = p_topbot;

                 p_return :=  f_msg('[REEL] 이전자재 교환 이력이 없습니다.','K',1) -- '08 Previous reel change data notfound'
                              || ' = '
                              || lvs_origin_barcode ;
     
                  --------------------------------------------------------------------------------
                  -- NSNP START
                  --------------------------------------------------------------------------------
                  BEGIN
                    
                     p_interlock_set_nsnp_time_msg (
                                                    p_line_code,
                                                    1,
                                                    lvl_time_term,
                                                    p_model_name,
                                                    '*',
                                                    'REEL CHECK',
                                                    f_msg('[REEL] 이전자재 교환 이력이 없습니다.','K',1)  -- '08 Previous reel change data notfound. '
                                                    || ' = '
                                                    || lvs_origin_barcode   
                                                    || ', '
                                                    || p_address
                                                    || ', '
                                                    || lvl_check_seq
                                                   );
                        
                  EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
                     WHEN OTHERS THEN
                          NULL;
                  END;

      --------------------------------------------------------------------------------
      -- NSNP END
      --------------------------------------------------------------------------------
      
         COMMIT;
         RETURN;
         
      END IF;
      
   END IF;

   --------------------------------------------------------------------------------
   --
   --------------------------------------------------------------------------------
   IF (NVL (lvs_item_code_origin, '*') <> NVL (lvs_item_code_new, '*')) AND (NVL (lvi_replace, 0) = 0) THEN
      ---------------------------------------------------
      -- replace check
      ---------------------------------------------------

      lvl_check_seq := seq_check_seq.NEXTVAL;
      p_sequence    := lvl_check_seq;

      ---------------------------------------------------
      --  SMT PDA MATERIAL POSITION check history insert
      ---------------------------------------------------
      INSERT INTO ib_smt_checkhist (check_date,
                                    check_sequence,
                                    plan_date,
                                    lot_name,
                                    partname,
                                    chipname,
                                    check_status,
                                    check_msg,
                                    check_by,
                                    line_code,
                                    machine,
                                    plan_date_sequence,
                                    scan_partname,
                                    scan_supplier_partname,
                                    location_code,
                                    check_type,
                                    table_id,
                                    pcb_item,
                                    old_barcode,
                                    lot_no,
                                    item_code,
                                    supplier_barcode_origin,
                                    smt_model_name,
                                    ng_type,
                                    enter_date,
                                    enter_by)
      VALUES (
                SYSDATE,
                lvl_check_seq,
                p_plan_date,
                p_model_name,
                lvs_item_code_origin,                         -- OUR ITEM CODE
                lvs_item_code_new,                       -- SUPPLIER ITEM CODE
                'E',
                f_msg('[REEL] 이전자재와 신자재 불일치.','K',1)     -- '01 New and Old Material Unmatch(REEL) '
                || ' = '
                || lvs_item_code_origin
                || ', '
                || lvs_item_code_new,
                p_userid,
                SUBSTR (p_line_code, 1, 2),
                TRIM (SUBSTR (p_line_code, 4, 10)),
                0,
                lvs_new_barcode,                         -- OUR ORIGIN BARCODE
                lvs_supplier_barcode,
                p_address,
                p_deficit,
                DECODE (SUBSTR (p_address, 1, 4), 'TRAY', 'Z', SUBSTR (p_address, 1, 1)),
                p_topbot,
                p_origin_barcode,
                lvs_lot_no,
                lvs_partname,
                p_supplier_barcode,
                lvs_smt_model_name,
                '*',
                sysdate,
                p_userid
             );

      UPDATE ib_product_plandata
         SET check_status  = 'E',
             check_msg = f_msg('[REEL] 이전자재와 신자재 불일치.','K',1)   -- '01 New and Old Material Unmatch(REEL) '
                         || ' = '               
                         || lvs_item_code_origin
                         || ', '
                         || lvs_item_code_new,
             selected_date = TO_CHAR (SYSDATE, 'YYYY-MM-DD HH24:MI:SS'),
             change_date   = SYSDATE
       WHERE model_name    = p_model_name
         AND line_code     = SUBSTR (p_line_code, 1, 2) --  AND machine = TRIM (SUBSTR (p_line_code, 4, 10))
         AND location_code = p_address
         AND pcb_item      = p_topbot
         AND active_yn     = 'Y';

      BEGIN
         --------------------------------------------------------------------------------
         -- NSNP START
         --------------------------------------------------------------------------------
         p_interlock_set_nsnp_time_msg (
                                         p_line_code,
                                         1,
                                         LVL_TIME_TERM,
                                         p_model_name,
                                         '*',
                                         'REEL CHECK',
                                         f_msg('[REEL] 이전자재와 신자재 불일치.','K',1)  -- '01 New and Old Material Unmatch(REEL)'
                                         || ' = '
                                         || lvs_item_code_origin
                                         || ', '
                                         || lvs_item_code_new
                                         || ', '
                                         || p_address
                                         || ', '
                                         || lvl_check_seq
                                       );
      --------------------------------------------------------------------------------
      -- NSNP END
      --------------------------------------------------------------------------------
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN OTHERS
         THEN
            NULL;
      END;

      p_return := f_msg('[REEL] 이전자재와 신자재 불일치.','K',1)    -- '01 New and Old Material Unmatch(REEL)'
                  || ' = '
                  || lvs_item_code_origin
                  || ', '
                  || lvs_item_code_new;
      COMMIT;
      RETURN;
   END IF;

   phase := '14';

-- ****************** IF
 --   IF (lvs_item_code_supplier_replace IS NULL or lvs_item_code_supplier_replace = '') THEN
      IF (1 = 2) THEN

-- ****************** IF

   IF     (lvs_item_code_supplier <> lvs_item_code_new)
      AND INSTR (lvs_item_code_supplier, lvs_item_code_new, 1) <= 0
      AND INSTR (lvs_item_code_supplier, TRIM (SUBSTR (lvs_item_code_new, 2, 20)), 1) <= 0 
   THEN

      lvl_check_seq := seq_check_seq.NEXTVAL;
      p_sequence    := lvl_check_seq;

      ---------------------------------------------------
      --  SMT PDA MATERIAL POSITION check history insert
      ---------------------------------------------------
      INSERT INTO ib_smt_checkhist (check_date,
                                    check_sequence,
                                    plan_date,
                                    lot_name,
                                    partname,
                                    chipname,
                                    check_status,
                                    check_msg,
                                    check_by,
                                    line_code,
                                    machine,
                                    plan_date_sequence,
                                    scan_partname,
                                    scan_supplier_partname,
                                    location_code,
                                    check_type,
                                    table_id,
                                    pcb_item,
                                    old_barcode,
                                    lot_no,
                                    item_code,
                                    supplier_barcode_origin,
                                    smt_model_name,
                                    ng_type ,
                                    enter_date,
                                    enter_by)
      VALUES (
                SYSDATE,
                lvl_check_seq,
                p_plan_date,
                p_model_name,
                lvs_item_code_new,                            -- OUR ITEM CODE
                lvs_item_code_supplier,                  -- SUPPLIER ITEM CODE
                'E',
                f_msg('[REEL] 공급상 자재와 신자재 불일치.','K',1)   -- '02 Supplier and new material unmatch(REEL)'
                || ' = '
                || lvs_item_code_supplier
                || ', '
                || lvs_item_code_new,
                p_userid,
                SUBSTR (p_line_code, 1, 2),
                TRIM (SUBSTR (p_line_code, 4, 10)),
                0,
                lvs_new_barcode,                                -- OUR BARCODE
                lvs_supplier_barcode,
                p_address,
                p_deficit,
                DECODE (SUBSTR (p_address, 1, 4), 'TRAY', 'Z', SUBSTR (p_address, 1, 1)),
                p_topbot,
                p_origin_barcode,
                lvs_lot_no,
                lvs_partname,
                p_supplier_barcode,
                lvs_smt_model_name,
                '*',
                sysdate,
                p_userid );

      COMMIT;

      UPDATE ib_product_plandata
         SET check_status      = 'E',
             check_msg         = f_msg('[REEL] 공급상 자재와 신자재 불일치.','K',1)   -- '02 Supplier and new material unmatch(REEL)'
                                 || ' = '
                                 || lvs_item_code_supplier
                                 || ', '
                                 || lvs_item_code_new,
             selected_date     = TO_CHAR (SYSDATE, 'YYYY-MM-DD HH24:MI:SS'),
             change_date       = SYSDATE
       WHERE     model_name    = p_model_name
             AND line_code     = SUBSTR (p_line_code, 1, 2) --    AND machine = TRIM (SUBSTR (p_line_code, 4, 10))
             AND location_code = p_address
             AND active_yn     = 'Y'
             AND pcb_item      = p_topbot;


      BEGIN
         --------------------------------------------------------------------------------
         -- NSNP START
         --------------------------------------------------------------------------------
         p_interlock_set_nsnp_time_msg (
                                        p_line_code,
                                        1,
                                        LVL_TIME_TERM,
                                        p_model_name,
                                        '*',
                                        'REEL CHECK',
                                        f_msg('[REEL] 공급상 자재와 신자재 불일치.','K',1)    -- '02 Supplier and new material unmatch(REEL)'
                                        || ' = '
                                        || lvs_item_code_supplier
                                        || ', '
                                        || lvs_item_code_new
                                        || ', '
                                        || p_address
                                        || ', '
                                        || lvl_check_seq
                                       );
      --------------------------------------------------------------------------------
      -- NSNP END
      --------------------------------------------------------------------------------
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN OTHERS THEN
              NULL;
      END;

      p_return :=  f_msg('[REEL] 공급상 자재와 신자재 불일치.','K',1)  -- '02 Supplier and new material unmatch(REEL)'
                   || ' = '
                   || lvs_item_code_supplier
                   || ', '
                   || lvs_item_code_new;
      COMMIT;
      RETURN;
      
   END IF;

-- ****************** ELSE
   ELSE
-- ****************** ELSE

   IF     (lvs_item_code_supplier <> lvs_item_code_new)
      AND lvs_item_code_supplier_replace <> lvs_item_code_new
      AND INSTR (lvs_item_code_supplier, lvs_item_code_new, 1) <= 0
      AND INSTR (lvs_item_code_supplier, TRIM (SUBSTR (lvs_item_code_new, 2, 20)),1) <= 0
   THEN

      lvl_check_seq := seq_check_seq.NEXTVAL;
      p_sequence    := lvl_check_seq;

      ---------------------------------------------------
      --  SMT PDA MATERIAL POSITION check history insert
      ---------------------------------------------------
      INSERT INTO ib_smt_checkhist (check_date,
                                    check_sequence,
                                    plan_date,
                                    lot_name,
                                    partname,
                                    chipname,
                                    check_status,
                                    check_msg,
                                    check_by,
                                    line_code,
                                    machine,
                                    plan_date_sequence,
                                    scan_partname,
                                    scan_supplier_partname,
                                    location_code,
                                    check_type,
                                    table_id,
                                    pcb_item,
                                    old_barcode,
                                    lot_no,
                                    item_code,
                                    supplier_barcode_origin,
                                    smt_model_name,
                                    ng_type,
                                    enter_date,
                                    enter_by)
      VALUES (
                SYSDATE,
                lvl_check_seq,
                p_plan_date,
                p_model_name,
                lvs_item_code_new,                            -- OUR ITEM CODE
                lvs_item_code_supplier,                  -- SUPPLIER ITEM CODE
                'E',
                f_msg('[REEL] 공급상 자재와 신자재 불일치.', 'K', 1)  -- '02 Supplier and new material unmatch(REEL)'
                || ' = '
                || lvs_item_code_supplier
                || ', '
                || lvs_item_code_new,
                p_userid,
                SUBSTR (p_line_code, 1, 2),
                TRIM (SUBSTR (p_line_code, 4, 10)),
                0,
                lvs_new_barcode,                                -- OUR BARCODE
                lvs_supplier_barcode,
                p_address,
                p_deficit,
                DECODE (SUBSTR (p_address, 1, 4), 'TRAY', 'Z', SUBSTR (p_address, 1, 1)),
                p_topbot,
                p_origin_barcode,
                lvs_lot_no,
                lvs_partname,
                p_supplier_barcode,
                lvs_smt_model_name,
                '*' ,
                sysdate,
                p_userid
            );

      COMMIT;

      UPDATE ib_product_plandata
         SET check_status     = 'E',
             check_msg        = f_msg('[REEL] 공급상 자재와 신자재 불일치.', 'K', 1)   -- '02 Supplier and new material unmatch(REEL)'
                                || ' = '
                                || lvs_item_code_supplier
                                || ', '
                                || lvs_item_code_new,
             selected_date = TO_CHAR (SYSDATE, 'YYYY-MM-DD HH24:MI:SS'),
             change_date       = SYSDATE
       WHERE     model_name    = p_model_name
             AND line_code     = SUBSTR (p_line_code, 1, 2) --    AND machine = TRIM (SUBSTR (p_line_code, 4, 10))
             AND location_code = p_address
             AND active_yn     = 'Y'
             AND pcb_item      = p_topbot;


      BEGIN
         --------------------------------------------------------------------------------
         -- NSNP START
         --------------------------------------------------------------------------------
         p_interlock_set_nsnp_time_msg (
                                         p_line_code,
                                         1,
                                         LVL_TIME_TERM,
                                         p_model_name,
                                         '*',
                                         'REEL CHECK',
                                         f_msg('[REEL] 공급상 자재와 신자재 불일치.', 'K', 1)    -- '02 Supplier and new material unmatch(REEL)'
                                         || ' = '
                                         || lvs_item_code_supplier
                                         || ', '
                                         || lvs_item_code_new
                                         || ', '
                                         || p_address
                                         || ', '
                                         || lvl_check_seq
                                       );
      --------------------------------------------------------------------------------
      -- NSNP END
      --------------------------------------------------------------------------------
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN OTHERS THEN
              NULL;
      END;


      p_return := f_msg('[REEL] 공급상 자재와 신자재 불일치.', 'K', 1)   -- '02 Supplier and new material unmatch(REEL)'
                  || ' = '
                  || lvs_item_code_supplier
                  || ', '
                  || lvs_item_code_new;
      COMMIT;
      RETURN;
      
   END IF;

-- ****************** END IF
   END IF;
-- ****************** END IF


   phase := '16';


   -----------------------------------------------------------
   --
   -----------------------------------------------------------
   IF lvs_item_code_new = '' OR lvs_item_code_new IS NULL THEN
     
      IF SUBSTR (p_address, 1, 4) = 'TRAY'  THEN
         NULL;
      ELSE
         NULL;
      END IF;

      lvl_check_seq := seq_check_seq.NEXTVAL;
      p_sequence    := lvl_check_seq;

      ---------------------------------------------------
      --  SMT PDA MATERIAL POSITION check history insert
      ---------------------------------------------------
      INSERT INTO ib_smt_checkhist (check_date,
                                    check_sequence,
                                    plan_date,
                                    lot_name,
                                    partname,
                                    chipname,
                                    check_status,
                                    check_msg,
                                    check_by,
                                    line_code,
                                    machine,
                                    plan_date_sequence,
                                    scan_partname,
                                    scan_supplier_partname,
                                    location_code,
                                    check_type,
                                    table_id,
                                    pcb_item,
                                    old_barcode,
                                    lot_no,
                                    item_code,
                                    supplier_barcode_origin,
                                    smt_model_name,
                                    ng_type,
                                    enter_date,
                                    enter_by)
      VALUES (
                SYSDATE,
                lvl_check_seq,
                p_plan_date,
                p_model_name,
                lvs_item_code_new,                            -- OUR ITEM CODE
                lvs_item_code_supplier,                  -- SUPPLIER ITEM CODE
                'E',
                f_msg('[REEL] 공급상 자재와 신자재 불일치.', 'K', 1),    -- '03 Feeder layout notfound(REEL) '
                p_userid,
                SUBSTR (p_line_code, 1, 2),
                TRIM (SUBSTR (p_line_code, 4, 10)),
                0,
                lvs_new_barcode,                                -- OUR BARCODE
                lvs_supplier_barcode,
                p_address,
                p_deficit,
                DECODE (SUBSTR (p_address, 1, 4), 'TRAY', 'Z', SUBSTR (p_address, 1, 1)),
                p_topbot,
                p_origin_barcode,
                lvs_lot_no,
                lvs_partname,
                p_supplier_barcode,
                lvs_smt_model_name,
                '*',
                sysdate,
                p_userid);

      COMMIT;

      UPDATE ib_product_plandata
         SET check_status      = 'E',
             check_msg         = f_msg('[REEL] 피더레이아웃에 없는 자재 입니다.', 'K', 1)   -- '03 Feeder layout notfound(REEL) '
                                 || ' = '
                                 || lvs_new_barcode,
             selected_date     = TO_CHAR (SYSDATE, 'YYYY-MM-DD HH24:MI:SS'),
             change_date       = SYSDATE
       WHERE     model_name    = p_model_name
             AND line_code     = SUBSTR (p_line_code, 1, 2) --   AND machine = TRIM (SUBSTR (p_line_code, 4, 10))
             AND location_code = p_address
             AND active_yn     = 'Y'
             AND pcb_item      = p_topbot;


      BEGIN
         --------------------------------------------------------------------------------
         -- NSNP START
         --------------------------------------------------------------------------------
         p_interlock_set_nsnp_time_msg (
                                         p_line_code,
                                         1,
                                         LVL_TIME_TERM,
                                         p_model_name,
                                         '*',
                                         'REEL CHECK',
                                         f_msg('[REEL] 피더레이아웃에 없는 자재 입니다.', 'K', 1)   -- '03 Feeder layout notfound(REEL) '
                                         || ' = '
                                         || lvs_item_code_supplier
                                         || ', '
                                         || lvs_item_code_new
                                         || ', '
                                         || lvl_check_seq
                                        );
      --------------------------------------------------------------------------------
      -- NSNP END
      --------------------------------------------------------------------------------

      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN OTHERS THEN
              NULL;
      END;

      p_return := f_msg('[REEL] 피더레이아웃에 없는 자재 입니다.', 'K', 1)   -- '03 Feeder layout notfound(REEL) '
                  || ' = '
                  || lvs_new_barcode;
      COMMIT;
      RETURN;
      
   END IF;

   phase := '30';

   --------------------------------------------------
   -- CHECK SMT ADDRES
   --------------------------------------------------
   BEGIN
     
      SELECT DISTINCT model_name , smt_model_name
        INTO lvs_model_name ,lvs_smt_model_name
        FROM ib_product_plandata
       WHERE model_name    = p_model_name
         AND line_code     = SUBSTR (p_line_code, 1, 2)
         AND location_code = p_address
         AND (   
                 INSTR (lvs_item_code_new, ITEM_CODE, 1) > 0
              OR ITEM_CODE = 'R' || lvs_item_code_new
              OR ITEM_CODE = 'D' || lvs_item_code_new 
              )
         AND active_yn     = 'Y'
         AND pcb_item      = p_topbot;
             
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND THEN
           lvs_model_name := '';
   END;

   phase := '40';

   ----------------------------------------------------------------------------
   -- 함습자재 체크
   -- 기존에 걸려 있던 자재를 체크 하지 않고 신규 자재를 체크함.
   ----------------------------------------------------------------------------
   BEGIN
     
     /*
      SELECT COUNT (*)
        INTO lvi_msl_over_count
        FROM im_item_receipt_barcode a, id_item b
       WHERE a.item_code            = b.item_code 
         AND a.lot_no               = lvs_lot_no
         AND TRUNC (NVL (a.msl_passed_time, 0) / b.msl_max_time * 100, 2) >= 100
         AND b.msl_level            IS NOT NULL
         AND NVL(B.MSL_LEVEL,'1')    >= '3'
         AND NVL (b.msl_max_time, 0) <> 0;
      */
         
      SELECT COUNT(*) --A.ITEM_CODE, A.LOT_NO, FEEDING_YN, FEEDING_DATE,REEL_DESTROY_YN, MSL_MAX_TIME, ROUND(MSL_PASSED_TIME + (SYSDATE - NVL(FEEDING_DATE,SYSDATE)) * 24)
        INTO lvi_msl_over_count
        FROM IM_ITEM_RECEIPT_BARCODE A, ID_ITEM B
       WHERE A.ITEM_CODE              = B.ITEM_CODE 
         AND A.LOT_NO                 = LVS_LOT_NO
         AND F_GET_MSL_PASSED_TIME( item_barcode ) > B.MSL_MAX_TIME    -- AND A.MSL_PASSED_TIME        >  B.MSL_MAX_TIME - ( (SYSDATE - NVL(FEEDING_DATE,SYSDATE)) * 24 )
         AND NVL(B.MSL_LEVEL,'1')     >= '3'
         AND NVL(FEEDING_YN,'N')      = 'N'
         AND NVL(REEL_DESTROY_YN,'N') = 'N';         
             
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN OTHERS THEN
           lvi_msl_over_count := 0;
   END;

--   IF NVL (lvi_msl_over_count, 0) > 0 AND 1 = 2  THEN
   IF NVL (lvi_msl_over_count, 0) > 0  THEN
     
      lvl_check_seq := seq_check_seq.NEXTVAL;

      ---------------------------------------------
      --  SMT PDA MATERIAL POSITION check history insert
      ---------------------------------------------
      INSERT INTO ib_smt_checkhist (check_date,
                                    check_sequence,
                                    plan_date,
                                    lot_name,
                                    partname,
                                    chipname,
                                    check_status,
                                    check_msg,
                                    check_by,
                                    line_code,
                                    machine,
                                    plan_date_sequence,
                                    scan_partname,
                                    location_code,
                                    check_type,
                                    table_id,
                                    pcb_item,
                                    lot_no,
                                    item_code,
                                    supplier_barcode_origin,
                                    smt_model_name,
                                    ng_type,
                                    enter_date,
                                    enter_by)
      VALUES (
                SYSDATE,
                lvl_check_seq,
                p_plan_date,
                p_model_name,
                lvs_item_code_new,
                lvs_item_code_supplier,
                'E',
                f_msg('[REEL] MSL 시간을 초과 되었습니다.', 'K', 1), -- '06 MSL Time Over.(REEL) '
                p_userid,
                SUBSTR (p_line_code, 1, 2),
                TRIM (SUBSTR (p_line_code, 4, 10)),
                0,
                lvs_new_barcode,
                p_address,
                p_deficit,
                DECODE (SUBSTR (p_address, 1, 4), 'TRAY', 'Z', SUBSTR (p_address, 1, 1)),
                p_topbot,
                lvs_lot_no,
                lvs_partname,
                p_supplier_barcode,
                lvs_smt_model_name,
                '*',
                sysdate,
                p_userid
             );

      ------------------------------------------------------------------------
      --
      ------------------------------------------------------------------------
      UPDATE ib_product_plandata
         SET check_status  = 'E',
             check_msg     = f_msg('[REEL] MSL 시간을 초과 되었습니다.', 'K', 1)   -- '06 MSL Time Over.(REEL) '
                             || ' = '
                             || lvs_new_barcode,
             selected_date = TO_CHAR (SYSDATE, 'YYYY-MM-DD HH24:MI:SS'),
             change_date   = SYSDATE
       WHERE model_name    = p_model_name
         AND line_code     = SUBSTR (p_line_code, 1, 2)
         AND location_code = p_address
         AND item_code     = TRIM (lvs_item_code_new)
         AND pcb_item      = p_topbot
          --       AND ccs_yn = 'Y'
         AND active_yn     = 'Y';

      --------------------------------------------------------------------------------
      -- NSNP START
      --------------------------------------------------------------------------------

      BEGIN
        
         p_interlock_set_nsnp_time_msg (
                                         p_line_code,
                                         1,
                                         LVL_TIME_TERM,
                                         p_model_name,
                                         '*',
                                         'REEL CHANGE',
                                         f_msg('[REEL] MSL 시간을 초과 되었습니다.', 'K', 1)   -- '06 MSL Time Over.(REEL) '
                                         || ' = '
                                         || lvs_new_barcode
                                         || ', '
                                         || lvl_check_seq
                                       );
            
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN OTHERS THEN
              NULL;
      END;

      --------------------------------------------------------------------------------
      -- NSNP END
      --------------------------------------------------------------------------------

      p_return := f_msg('[REEL] MSL 시간을 초과 되었습니다.', 'K', 1)   -- '06 MSL Time Over.(REEL) '
                  || ' = '
                  || lvs_new_barcode;
                  
      COMMIT;
      RETURN;
      
   END IF;

   --------------------------------------------------------------------------------
   --
   --------------------------------------------------------------------------------

   IF lvs_model_name = '' OR lvs_model_name IS NULL THEN
     
      lvl_check_seq := seq_check_seq.NEXTVAL;
      p_sequence    := lvl_check_seq;
      
      phase := '41';

      ---------------------------------------------
      --  SMT PDA MATERIAL POSITION check history insert
      ---------------------------------------------
      INSERT INTO ib_smt_checkhist (check_date,
                                    check_sequence,
                                    plan_date,
                                    lot_name,
                                    partname,
                                    chipname,
                                    check_status,
                                    check_msg,
                                    check_by,
                                    line_code,
                                    machine,
                                    plan_date_sequence,
                                    scan_partname,
                                    scan_supplier_partname,
                                    location_code,
                                    check_type,
                                    table_id,
                                    pcb_item,
                                    old_barcode,
                                    lot_no,
                                    item_code,
                                    supplier_barcode_origin,
                                    smt_model_name,
                                    ng_type,
                                    enter_date,
                                    enter_by)
      VALUES (
                SYSDATE,
                lvl_check_seq,
                p_plan_date,
                p_model_name,
                lvs_item_code_new,
                lvs_item_code_supplier,
                'E',          
                f_msg('[REEL] 피더레이아웃에 없는 자재 입니다.', 'K', 1)   -- '04 Feeder layout notfound'
                || ' = '
                || lvs_new_barcode
                || ', Loc='
                || p_address,
                p_userid,
                SUBSTR (p_line_code, 1, 2),
                TRIM (SUBSTR (p_line_code, 4, 10)),
                0,
                lvs_new_barcode,
                lvs_supplier_barcode,
                p_address,
                p_deficit,
                DECODE (SUBSTR (p_address, 1, 4), 'TRAY', 'Z', SUBSTR (p_address, 1, 1)),
                p_topbot,
                p_origin_barcode,
                lvs_lot_no,
                lvs_partname,
                p_supplier_barcode,
                lvs_smt_model_name,
                '*',
                sysdate,
                p_userid);

      COMMIT;
      phase := '42';

      ------------------------------------------------------------------------
      --
      ------------------------------------------------------------------------
      UPDATE ib_product_plandata
         SET check_status  = 'E',
             check_msg     = f_msg('[REEL] 피더레이아웃에 없는 자재 입니다.', 'K', 1)  -- '04 Feeder layout notfound (REEL)'
                             || ' = '
                             || lvs_new_barcode,
             selected_date = TO_CHAR (SYSDATE, 'YYYY-MM-DD HH24:MI:SS'),
             change_date   = SYSDATE
       WHERE model_name    = p_model_name
         AND line_code     = SUBSTR (p_line_code, 1, 2)
         AND location_code = p_address
         AND active_yn     = 'Y'
         AND pcb_item      = p_topbot -- AND item_code = TRIM (lvs_item_code_new)
                                    ;

      phase := '43';


      BEGIN
         --------------------------------------------------------------------------------
         -- NSNP START
         --------------------------------------------------------------------------------
         p_interlock_set_nsnp_time_msg (
                                         p_line_code,
                                         1,
                                         LVL_TIME_TERM,
                                         p_model_name,
                                         '*',
                                         'REEL CHECK',
                                         f_msg('[REEL] 피더레이아웃에 없는 자재 입니다.', 'K', 1)  -- '04 Feeder layout notfound (REEL)'
                                         || ' = '
                                         || lvs_new_barcode
                                         || ', ADD='
                                         || p_address
                                         || ', SEQ='
                                         || lvl_check_seq
                                        );
      --------------------------------------------------------------------------------
      -- NSNP END
      --------------------------------------------------------------------------------
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN OTHERS THEN
              NULL;
      END;


      p_return := f_msg('[REEL] 피더레이아웃에 없는 자재 입니다.', 'K', 1)  -- '04 Feeder layout notfound (REEL)'
                  || ' = '
                  || SUBSTR (p_line_code, 1, 2)
                  || ', '
                  || p_address
                  || ', '
                  || lvs_item_code_new;
                  
      COMMIT;
      RETURN;
      
   --------------------------------------------------------------------------
   -- OK INSERT
   --------------------------------------------------------------------------
   ELSE
     
      phase := '44';

      BEGIN
        
      --   SELECT (MAX (change_date) - (SYSDATE - 5 / 24 / 60)) * 24 * 60
         SELECT (MAX (change_date) - (SYSDATE - 1 / 24 / 60)) * 24 * 60    --  TMA모델의 경우 MOQ가 너무 소수이다보니 문제가 되는 현상같은데 시간을 조절할수있다면 1분으로 변경
           INTO lvl_change_time
           FROM ib_product_plandata
          WHERE model_name    = p_model_name
            AND line_code     = SUBSTR (p_line_code, 1, 2)
            AND location_code = p_address
            AND TRIM (lvs_item_code_new) LIKE '%' || item_code
            AND pcb_item      = p_topbot
            AND check_status  = 'P'
            AND active_yn     = 'Y';
                
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND THEN
              p_return := f_msg('[REEL] 5분 지연 검사 위반입니다.', 'K', 1);  -- '06 5 min delay violation(REEL) '
              RETURN;
      END;

      phase := '45';

      IF lvl_change_time > 0 THEN
         p_return := 'TL';
         RETURN;
      END IF;

      ---------------------------------------------------------------------
      -- DELAY TIME 30 SEC
      --  다른 테이블 동시작업은 인정한다 .
      ---------------------------------------------------------------------
      BEGIN
        
         SELECT (MAX (change_date) - (SYSDATE - 0.5 / 24 / 60))
                * 24
                * 60
                * 60
           INTO lvl_delay_time
           FROM ib_product_plandata
          WHERE model_name = p_model_name
            AND line_code  = SUBSTR (p_line_code, 1, 2)
            AND active_yn  = 'Y'
            AND pcb_item   = p_topbot
            AND location_code <> p_address
            AND SUBSTR (location_code, 1, 1) = SUBSTR (p_address, 1, 1);
            
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND THEN          
              p_return := f_msg('[REEL] 30초 지연 교환 위반 입니다', 'K', 1);    -- '07 30 Sec delay violation(REEL) '
              RETURN;
      END;

      phase := '46';

      IF lvl_delay_time > 0 THEN
         p_return := 'TD';
         RETURN;
      END IF;

      -----------------------------------------------------------------------------------------------
      -- OK 처리
      -----------------------------------------------------------------------------------------------
      lvi_count     := 1;
      lvl_check_seq := seq_check_seq.NEXTVAL;
      p_sequence    := lvl_check_seq;

      INSERT INTO ib_smt_checkhist (check_date,
                                    check_sequence,
                                    plan_date,
                                    lot_name,
                                    partname,
                                    chipname,
                                    check_status,
                                    check_msg,
                                    check_by,
                                    line_code,
                                    machine,
                                    plan_date_sequence,
                                    scan_partname,
                                    scan_supplier_partname,
                                    location_code,
                                    check_type,
                                    table_id,
                                    pcb_item,
                                    old_barcode,
                                    lot_no,
                                    item_code,
                                    valid_date,
                                    lot_serial,
                                    trace_code,
                                    SCAN_QTY,
                                    VENDOR_NAME,
                                    inspect_date,
                                    supplier_barcode_origin ,
                                    smt_model_name,
                                    ng_type,
                                    run_no,
                                    enter_date,
                                    enter_by)
      VALUES (
                SYSDATE,
                lvl_check_seq,
                p_plan_date,
                p_model_name,
                lvs_item_code_new,
                lvs_item_code_supplier,
                'P',
                'OK',
                p_userid,
                SUBSTR (p_line_code, 1, 2),
                TRIM (SUBSTR (p_line_code, 4, 10)),
                0,
                lvs_new_barcode,
                lvs_supplier_barcode,
                p_address,
                p_deficit,
                DECODE (SUBSTR (p_address, 1, 4), 'TRAY', 'Z', SUBSTR (p_address, 1, 1)),
                p_topbot,
                p_origin_barcode,
                lvs_lot_no,
                lvs_partname,
                lvdt_valid_date,
                lvs_lot_serial,
                lvs_trace_code,
                lvl_item_qty,
                LVS_VENDOR_NAME,
                lvdt_inspect_date,
                p_supplier_barcode,
                lvs_smt_model_name ,
                '*',
                lvs_run_no,
                sysdate,
                p_userid );

      COMMIT;

      ---------------------------------------------------------------------
      -- 릴체인지가 성공하면 수량 누적
      -- REEL_COLLECT_YN 해제
      ---------------------------------------------------------------------
      UPDATE ib_product_plandata
         SET check_status  = 'P',
             check_msg     = 'OK',
             selected_date = TO_CHAR (SYSDATE, 'YYYY-MM-DD HH24:MI:SS'),
             change_date   = SYSDATE,
             item_barcode  = lvs_new_barcode,
             feeding_qty   =
                NVL (feeding_qty, 0)
                + (CASE
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
                      WHEN lot_no =
                              f_get_lot_no_from_barcode (lvs_new_barcode)
                      THEN
                         0
                      ELSE
                         lvl_item_qty
                   END),                                        --스캔한 수량을 더한다.
             lot_no        = f_get_lot_no_from_barcode (lvs_new_barcode),
             feeding_count = feeding_count + 1,
             REEL_COLLECT_YN   = 'N'
       WHERE model_name    = p_model_name
         AND line_code     = SUBSTR (p_line_code, 1, 2)
         AND location_code = p_address
         AND active_yn     = 'Y'
         AND pcb_item      = p_topbot;

      -------------------------------------------------------------
      -- FEEDING DATE / MSL OPEN DATE
      -- 자재가 피더에 걸렸음을 표시
      -- 하고 함습자재 잔여시간 카운터를 시작한다.
      -------------------------------------------------------------
      UPDATE im_item_receipt_barcode
         SET feeding_date  = SYSDATE,
             feeding_model = p_model_name,
             feeding_yn    = 'Y',
             MSL_OPEN_DATE = decode(MSL_OPEN_DATE, null, sysdate, MSL_OPEN_DATE)
       --  new_scan_qty =  lvl_item_qty
       WHERE lot_no = f_get_lot_no_from_barcode (lvs_new_barcode);

      -------------------------------------------------------------
      -- 구자재는 공정에 다쓴거로 표시한다
      -- 20160831 : YHS
      -- 
      -------------------------------------------------------------
      UPDATE im_item_receipt_barcode
         SET  reel_destroy_yn  = 'Y',
              reel_destroy_date = sysdate,
              msl_passed_time  = nvl(msl_passed_time,0) + ((sysdate - nvl(msl_open_date,sysdate)) * 24),  -- 2016/09/02 SHS, 사용시간을 고정 시킨다
              last_modify_date = sysdate,        
             msl_open_date     = null
       WHERE lot_no = f_get_lot_no_from_barcode (lvs_origin_barcode);

      COMMIT;
          
      ---------------------------------------------------------------
      -- 레이아웃에 문제 로케이션 있는지 판단해서 해제 해줌 
      ---------------------------------------------------------------
       BEGIN
            SELECT NVL(COUNT(CONFIG_VALUE),0)  
              INTO lvi_row_count
              FROM ISYS_CONFIG      
             WHERE CONFIG_NAME     = 'NSNP_UNLCOK_BY_ACTION'  
               AND CONFIG_VALUE    = 'Y'
               AND ORGANIZATION_ID = 1 ;
        
        EXCEPTION WHEN NO_DATA_FOUND THEN 
          lvi_row_count := 0 ;
       END ;
        
      ------------------------------------------------------------------
      -- 매스캔시 잠금 해제 조건이면 
      ------------------------------------------------------------------
       IF nvl(lvi_row_count,0) > 0 THEN 
        
              BEGIN
                
               SELECT  COUNT(*)
                 INTO lvl_ng_location_count
                 FROM ib_product_plandata
                WHERE model_name   = p_model_name
                  AND line_code    = SUBSTR (p_line_code, 1, 2)
                  AND active_yn    = 'Y'
                  AND pcb_item     = p_topbot
                  AND check_status = 'E';
                  
              EXCEPTION  
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
                 WHEN NO_DATA_FOUND  THEN
                      lvl_ng_location_count := 0 ;
              END;  
              
              -------------------------------------------------------
              -- 현제 라인이 잠근 상태인지 체크
              -- 중복으로 해제 신호를 안보내기 위해 
              -------------------------------------------------------
              BEGIN  
                
                SELECT COUNT(*) INTO lvi_line_nsnp_count 
                  FROM ip_product_line
                 WHERE line_code    = SUBSTR (p_line_code, 1, 2)
                   AND nsnp_status  LIKE 'ON%';
                   
              EXCEPTION  
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
                 WHEN NO_DATA_FOUND  THEN
                      lvi_line_nsnp_count := 0 ;
              END;  
              
              -----------------------------------------------------------
              -- 기존에 잠겨있었는지 체크해서 문제가 해결 되었고 그리고 잠겨있었으면 
              -- 해제해줌 
              -----------------------------------------------------------
                IF nvl(lvl_ng_location_count,0) = 0 and nvl(lvi_line_nsnp_count,0) > 0 THEN 
                  
                    BEGIN
                        --------------------------------------------------------------------------------
                        -- NSNP START
                        --------------------------------------------------------------------------------
                        p_interlock_set_nsnp_time_msg (
                                                        substr(p_line_code,1,2),
                                                        0, --action code
                                                        0, -- time
                                                        p_model_name,
                                                        '*', -- suffix 
                                                        'UNLOCK', -- reason
                                                        'REEL AUTO UNLOCK' 
                                                      ); --error message
                     --------------------------------------------------------------------------------
                     -- NSNP END
                     --------------------------------------------------------------------------------
                     EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
                        WHEN OTHERS THEN
                             NULL;
                     END;              

                END IF  ;
      
       END IF ;

   END IF;
   
   commit ;
   phase := '110';

   --------------------------------------------------
   -- CHECK SMT ADDRES OK
   --------------------------------------------------

   IF lvi_count > 0 THEN
      p_return := 'OK';
      RETURN;
   ELSIF lvi_count < 1  THEN
      p_return :=  f_msg('[REEL] 피더레이아웃에 없는 자재 입니다. ', 'K', 1) ;   -- f_msg('05 Feeder Layout Error. ','E',1);
      RETURN;
   END IF;
   
EXCEPTION
  
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS THEN
        raise_application_error (
                                 -20003,
                                 'NG, [REEL] Phase='
                                 || phase
                                 || ', Origin='
                                 || p_origin_barcode
                                 || ', Sup='
                                 || p_supplier_barcode
                                 || ', New='
                                 || p_barcode
                                 || ', '
                                 || SQLERRM
                                );
                                
END;
