CREATE OR REPLACE PROCEDURE P_INTERLOCK_RESET_LINE_BAK (
  /* ================================================================
   * 프로시저명  : P_INTERLOCK_RESET_LINE_BAK
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   인터락 조건, 상태, 실적 또는 검사 데이터를 처리한다.
   *   라인/공정/설비/품목 조건을 기준으로 원본 로직의 조회와 갱신을 수행한다.
   *   호출부가 인터락 결과와 메시지로 후속 처리를 판단할 수 있게 한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_LINE_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_FEEDER_LAYOUT_NAME - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IB_PRODUCT_PLANDATA - 원본 로직 참조 테이블
   *   IB_PRODUCT_PLANDATA_BACKUP - 원본 로직 참조 테이블
   *   IB_SMT_FEEDER_SHAFT - 원본 로직 참조 테이블
   *   IMCN_JIG - 원본 로직 참조 테이블
   *   IMCN_SAMPLE - 원본 로직 참조 테이블
   *   IM_ITEM_RECEIPT_BARCODE - 원본 로직 참조 테이블
   *   IM_ITEM_WORKSTAGE_ISSUE - Item Issue Master
   *   IP_PRODUCT_LINE - Product Line Master
   *   IP_PRODUCT_MODEL_MASTER - 원본 로직 참조 테이블
   *   IP_PRODUCT_SENSOR_ACTUAL - 원본 로직 참조 테이블
   *   IP_PRODUCT_SENSOR_ACTUAL_BACK - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_SMT_MODDEL_NAME_4_INOUT
   *   F_GET_WORKSTAGE_CODE_BY_TYPE
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
   *   EXEC P_INTERLOCK_RESET_LINE_BAK(...)
   * ================================================================ */
   p_line_code            IN     VARCHAR2,
   p_feeder_layout_name   IN     VARCHAR2,
   P_OUT                  OUT    VARCHAR2)
IS
   phase                  VARCHAR2 (10); -- [AI] 내부 처리용 변수
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
  
   --------------------------------------------------------------------------
   -- 백업 실행
   --------------------------------------------------------------------------
   phase := '10' ;
      
   INSERT INTO ib_product_plandata_BACKUP
   SELECT *
     FROM ib_product_plandata
    WHERE line_code = SUBSTR (p_line_code, 1, 2)
      AND model_name = UPPER (p_feeder_layout_name)
      AND active_yn = 'Y';

   ------------------------------------------------------------------------
   -- 생산실적은 최종모델 기준으로 취합되기 때문에
   -- 피더레이아웃으로 리셋을 하면 모델마스터에서 SMT MODEL NAME 으로 모델을 찾아서 
   -- 리셑해주어야함.
   ------------------------------------------------------------------------
   phase := '20' ;
   
   INSERT INTO IP_PRODUCT_SENSOR_ACTUAL_BACK
      SELECT receipt_date, 
             receipt_sequence, 
             line_code, 
             model_name, 
             model_suffix, 
             product_actual_qty, 
             enter_date, 
             enter_by, 
             last_modify_date, 
             last_modify_by, 
             organization_id, 
             workstage_code, 
             origin_count, 
             last_receipt_date, 
             adjust_qty, 
             product_actual_sum, 
             is_last_yn, 
             actual_type, 
             pcb_item, 
             product_actual_lost_qty, 
             run_no
        FROM IP_PRODUCT_SENSOR_ACTUAL
       WHERE line_code = SUBSTR (p_line_code, 1, 2)
             AND model_name IN ( SELECT MODEL_NAME 
                                   FROM IP_PRODUCT_MODEL_MASTER 
                                  WHERE SMT_MODEL_NAME = f_get_smt_moddel_name_4_inout( p_feeder_layout_name , organization_id )
                                );
                                
   phase := '30' ;
   
   DELETE FROM IP_PRODUCT_SENSOR_ACTUAL
    WHERE line_code = SUBSTR (p_line_code, 1, 2)
          AND model_name IN ( SELECT MODEL_NAME 
                                FROM IP_PRODUCT_MODEL_MASTER 
                               WHERE SMT_MODEL_NAME = f_get_smt_moddel_name_4_inout( p_feeder_layout_name , organization_id )
                             );

   -----------------------------------------------------------------------
   -- 피더 레이아웃에 기존에 이미 걸려있던 내용을 초기화 한다.
   -- NEW SCAN QTY 에 이론적으로 남아있는 수량을 업데이트 한다.
   --
   -----------------------------------------------------------------------
   BEGIN
   
     phase := '40' ;
     
      UPDATE IM_ITEM_RECEIPT_BARCODE A
         SET FEEDING_YN     = 'N',
             A.NEW_SCAN_QTY = (
                               SELECT SUM(NVL (B.FEEDING_QTY, 0) - NVL (B.PRODUCT_ACTUAL_QTY, 0))
                                 FROM ib_product_plandata B
                                WHERE B.line_code = SUBSTR (p_line_code, 1, 2)
                                  AND B.model_name = UPPER (p_feeder_layout_name)
                                  AND B.active_yn = 'Y'
                                  AND B.ITEM_CODE = A.ITEM_CODE
                                  AND B.LOT_NO = A.LOT_NO
                                  AND B.CHECK_STATUS = 'P'
                                  AND NVL (B.FEEDING_QTY, 0) - NVL (B.PRODUCT_ACTUAL_QTY, 0) >= 0
                                  AND rownum = 1
                               )
       WHERE (A.ITEM_CODE, A.LOT_NO) IN (
                                         SELECT B.ITEM_CODE, B.LOT_NO
                                           FROM ib_product_plandata B
                                          WHERE B.line_code = SUBSTR (p_line_code, 1, 2)
                                            AND B.model_name = UPPER (p_feeder_layout_name)
                                            AND B.active_yn = 'Y'
                                            AND B.ITEM_CODE = A.ITEM_CODE
                                            AND B.LOT_NO = A.LOT_NO
                                            AND B.CHECK_STATUS = 'P'
                                            AND NVL (B.FEEDING_QTY, 0) - NVL (B.PRODUCT_ACTUAL_QTY, 0) >= 0
                                         );
                            
      phase:='50' ;

      UPDATE IM_ITEM_RECEIPT_BARCODE A
         SET FEEDING_YN = 'N',
             A.NEW_SCAN_QTY = (
                               SELECT 0
                                 FROM ib_product_plandata B
                                WHERE B.line_code = SUBSTR (p_line_code, 1, 2)
                                  AND B.model_name = UPPER (p_feeder_layout_name)
                                  AND B.active_yn = 'Y'
                                  AND B.ITEM_CODE = A.ITEM_CODE
                                  AND B.LOT_NO = A.LOT_NO
                                  AND B.CHECK_STATUS = 'P'
                                  AND NVL (B.FEEDING_QTY, 0) - NVL (B.PRODUCT_ACTUAL_QTY, 0) < 0
                                  AND rownum = 1
                               )
       WHERE (A.ITEM_CODE, A.LOT_NO) IN (
                                         SELECT B.ITEM_CODE, B.LOT_NO
                                           FROM ib_product_plandata B
                                          WHERE B.line_code = SUBSTR (p_line_code, 1, 2)
                                            AND B.model_name = UPPER (p_feeder_layout_name)
                                            AND B.active_yn = 'Y'
                                            AND B.ITEM_CODE = A.ITEM_CODE
                                            AND B.LOT_NO = A.LOT_NO
                                            AND B.CHECK_STATUS = 'P'
                                            AND NVL (B.FEEDING_QTY, 0) - NVL (B.PRODUCT_ACTUAL_QTY, 0) < 0
                                        );
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR (-20003,
                                  'PHASE=' || PHASE || ' ' || SQLERRM);
   END;

   -----------------------------------------------------------------------
   --  성공적이면 이전 바코드를 공정에서 출고 처리 함
   --
   -----------------------------------------------------------------------
   BEGIN
     
      phase :='60' ;
      
--      INSERT INTO im_item_workstage_issue (
--                                           issue_date,
--                                           issue_sequence,
--                                           organization_id,
--                                           mfs,
--                                           material_mfs,
--                                           line_code,
--                                           workstage_code,
--                                           machine_code,
--                                           item_code,
--                                           item_type,
--                                           line_type,
--                                           issue_deficit,
--                                           issue_account,
--                                           issue_price,
--                                           issue_qty,
--                                           issue_amt,
--                                           issue_type,
--                                           product_date,
--                                           product_sequence,
--                                           issue_status,
--                                           enter_by,
--                                           enter_date,
--                                           last_modify_by,
--                                           last_modify_date,
--                                           sub_mfs,
--                                           issue_weight,
--                                           parent_item_code,
--                                           feeder_shaft
--                                          )
--         SELECT TRUNC (SYSDATE),
--                seq_workstage_issue_seq.NEXTVAL,
--                1,
--                '*',
--                B.lot_no,                                           -- 구자쟈자사라벨
--                SUBSTR (B.line_code, 1, 2),
--                f_get_workstage_code_by_type( 'SMT'),
--                '*',
--                B.item_code,
--                'T',
--                'F',
--                '3',
--                'M001',                                        --ISSUE ACCOUNT
--                0,                                               --ISSUE_PRICE
--                B.SCAN_QTY
--                - DECODE (NVL (A.NEW_SCAN_QTY, 0),
--                0, A.SCAN_QTY,
--                NVL (A.NEW_SCAN_QTY, 0)), --최초 장착되었던 상태에서 수량이 변한차이 , 릴교환으로인해 되려 수량이 많아지면 처리안함.
--                0,                                                -- ISSUE_AMT
--                'N',                                              --ISSUE TYPE
--                SYSDATE,
--                0,                                            --lvl_check_seq,
--                'N',
--                'SYSTEM',
--                SYSDATE,
--                'SYSTEM',
--                SYSDATE,
--                B.location_code,
--                0,
--                UPPER (B.model_name),
--                B.feeder_shaft
--           FROM IB_PRODUCT_PLANDATA B, IM_ITEM_RECEIPT_BARCODE A
--          WHERE B.LOT_NO = A.LOT_NO
--                AND B.LINE_CODE = SUBSTR (p_line_code, 1, 2)
--                AND B.model_name = UPPER (p_feeder_layout_name)
--                AND B.ACTIVE_YN = 'Y'
--                AND B.CHECK_STATUS = 'P'
--                AND A.ISSUE_COMPARE_YN = 'Y'
--                AND A.FEEDING_YN = 'N'
--                AND B.SCAN_QTY > DECODE (NVL(A.NEW_SCAN_QTY, 0), 0, A.SCAN_QTY, NVL (A.NEW_SCAN_QTY, 0));
                
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN OTHERS THEN
           NULL;
   END;

   -----------------------------------------------------------------------
   -- 피더 레이아웃에 기존에 이미 걸려있던 내용을 초기화 한다.
   -----------------------------------------------------------------------
   phase := '70' ;
   
   UPDATE ib_product_plandata
      SET check_status = 'W',
          check_msg = NULL,
          selected_date = NULL,
          item_barcode = NULL,
          feeding_date = NULL,
          feeding_end_date = NULL,
          feeding_qty = 0,
          active_yn = 'N',
          recycle_date = SYSDATE,
          check_yn = 'N',
          ccs_yn = 'N',
          change_date = NULL,
          full_check_yn = 'N',
          product_actual_qty = 0,
          reel_collect_yn = 'N',
          feeding_group_no = ''
    WHERE line_code = SUBSTR (p_line_code, 1, 2)
      AND model_name = UPPER (p_feeder_layout_name)
      AND active_yn = 'Y';

   -------------------------------------------------------------------------
   -- 라인 정보에서 모든 정보 초기화
   -------------------------------------------------------------------------
   phase := '80' ; 
         
   BEGIN
           
      UPDATE ip_product_line
         SET MASK_LOT_NO = NULL,
             MASK_CHECK_DATE = NULL,
             MASK_LOT_NO2 = NULL,
             MASK_CHECK_DATE2 = NULL,
             SQUEZE_LOT_NO = NULL,
             SQUEZE_CHECK_DATE = NULL,
             SOLDER_LOT_NO = NULL,
             SOLDER_CHECK_DATE = NULL,
             MODEL_NAME = NULL,
             MODEL_SUFFIX = NULL,
             ITEM_CODE = NULL,
             CCS_STATUS = NULL,
             FULL_CHECK_DATE = NULL,
             CCS_DATE = NULL,
             REFLOW_TEMP_VALUE = NULL,
             REFLOW_SOLDER_TYPE = NULL,
             NSNP_STATUS = 'WAIT',
             PCB_SCAN_DATE = NULL,
             PCB_ITEM_CODE = NULL,
             PCB_SCAN_STATUS = NULL,
             NSNP_START_DATE = NULL,
             PCB_ITEM = NULL,
             CHILD_ITEM_CODE = NULL,
             RUN_NO = NULL,
             RUN_NO_CHANGED_BY = NULL,
             RUN_DATE  = NULL,
             ACTIVE_YN = 'N' ,
             PRODUCTION_TYPE = '' ,
             FEEDER_LAYOUT_NAME = NULL,
             SMT_MODEL_NAME = NULL ,
             MASTER_MODEL_NAME = NULL,
             LAST_MODEL_NAME  = MODEL_NAME,
             LAST_MASK_LOT_NO = MASK_LOT_NO,
             LAST_MASK_LOT_NO2 = MASK_LOT_NO2,
             SPEC_CHECK_DATE = NULL,
             SPEC_CHECK_STATUS = NULL,
             SQUEEZE_LOT_NO= NULL, 
             SQUEEZE_CHECK_DATE= NULL ,   
             SQUEEZE_LOT_NO2= NULL, 
             SQUEEZE_CHECK_DATE2= NULL ,          
             backupblock_check_date = NULL , 
             backupblock_lot_no = NULL , 
             router_check_date = NULL , 
             router_lot_no = NULL , 
             romwrite_check_date = NULL , 
             romwrite_lot_no  = NULL , 
             fixture_check_date = NULL , 
             fixture_lot_no = NULL , 
             profile_check_date = NULL , 
             profile_lot_no = NULL,
             sample_check_date = NULL , 
             sample_lot_no = NULL , 
             sample_check_date2 = NULL , 
             sample_lot_no2 = NULL ,
             sample_ict_check_date = NULL , 
             sample_ict_lot_no = NULL ,
             sample_ict_check_date2 = NULL , 
             sample_ict_lot_no2 = NULL ,
             last_backupblock_lot_no = backupblock_lot_no,  
             last_squeeze_lot_no = squeeze_lot_no,
             last_squeeze_lot_no2 = squeeze_lot_no2,    
             last_router_lot_no = router_lot_no,    
             last_romwrite_lot_no = romwrite_lot_no,  
             last_fixture_lot_no = fixture_lot_no,   
             last_sample_lot_no = sample_lot_no,   
             last_sample_lot_no2  = sample_lot_no2,   
             last_profile_lot_no = profile_lot_no,    
             last_spec_check_status = spec_check_status,
             last_spec_check_date = spec_check_date,
             last_SOLDER_LOT_NO = SOLDER_LOT_NO,
             last_run_no = run_no,
             LAST_SOLDER_CHECK_DATE = SOLDER_CHECK_DATE ,
             LAST_PCB_ITEM = PCB_ITEM,
             ict_check_date = NULL , 
             ict_lot_no = NULL ,  
             last_ict_check_date = ict_check_date , 
             last_ict_lot_no = ict_lot_no ,
             LAST_SAMPLE_ICT_LOT_NO = SAMPLE_ICT_LOT_NO,
             LAST_SAMPLE_ICT_LOT_NO2 = SAMPLE_ICT_LOT_NO2 ,
             solder_type = null,
             LCR_CHECK_DATE = NULL ,
             LCR_LOT_NO = NULL
       WHERE line_code = SUBSTR (p_line_code, 1, 2);
       
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR (-20003, 'PHASE=' || PHASE || ' ' || SQLERRM);
   END;     
   
   ------------------------------------------------------------------------
   -- 지그류 초기화
   ------------------------------------------------------------------------
   
   update imcn_jig
      set line_code = '*' , 
          LAST_HIT_YN = 'N'
    where line_code = SUBSTR (p_line_code, 1, 2)
      and jig_type <> 'F';
   
   ------------------------------------------------------------------------
   -- 셈플 초기화
   ------------------------------------------------------------------------   
   
    update imcn_sample
       set line_code = '*'
     where line_code = SUBSTR (p_line_code, 1, 2);       

   ----------------------------------------------------------------------------
   -- 연배열 조정 초기화 
   ----------------------------------------------------------------------------
--   UPDATE IB_SMT_FEEDER_SHAFT SET CARRIER_SIZE_ADJUST_YN = 'N'     
--     WHERE line_code = SUBSTR (p_line_code, 1, 2);

   ---------------------------------------------------------------------------
   -- 다른 모델의 모든 실적을 초기화 한다
   -- PRODUCT_ACTUAL_SUM 에 기존까지의 모든 실적을 업데이트 해주고
   -- 실적 수량은 모두 0 으로 변경
   ---------------------------------------------------------------------------
   phase := '90';

   BEGIN
      UPDATE IP_PRODUCT_SENSOR_ACTUAL
         SET PRODUCT_ACTUAL_SUM = NVL (PRODUCT_ACTUAL_SUM, 0) + PRODUCT_ACTUAL_QTY,
             PRODUCT_ACTUAL_QTY = 0
       WHERE line_code = SUBSTR (p_line_code, 1, 2);
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR (-20003, 'PHASE=' || PHASE || ' ' || SQLERRM);
   END;

--   ------------------------------------------------------------------------
--   -- nsnp 실적 초기회
     -- NSNP 프로시져 RESET 호출한 함수로 상향 이동 COMMIT 트랜젝션 때문에. 
--   ------------------------------------------------------------------------
--   BEGIN
--     
--      phase := '100';
--      
--      --------------------------------------------------------------------------------
--      -- NSNP START
--      --------------------------------------------------------------------------------
--  
--      p_interlock_set_nsnp_time_msg (SUBSTR (p_line_code, 1, 2),
--                                     'RESET',
--                                     1000,
--                                     p_feeder_layout_name,
--                                     '*',
--                                     'RESET',
--                                     'RESET LINE ACTUAL ');
--  
                                       
   --------------------------------------------------------------------------------
   -- NSNP END
--   --------------------------------------------------------------------------------
--   EXCEPTION
--      WHEN OTHERS THEN
--         RAISE_APPLICATION_ERROR (-20003, 'PHASE=' || PHASE || ' ' || SQLERRM);
--         P_OUT := 'NG '
--                  || f_msg('센서초기화에 실패  했습니다.','K',1);
--         RETURN;
--   END;

   P_OUT := 'OK';

EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN NO_DATA_FOUND THEN
        NULL;
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS THEN
      P_OUT := 'NG';
      RAISE_APPLICATION_ERROR (-20003, 'PHASE=' || PHASE || ' ' || SQLERRM);
END;
