CREATE OR REPLACE PROCEDURE "P_INTERLOCK_MODEL_INFO" (
  /* ================================================================
   * 프로시저명  : P_INTERLOCK_MODEL_INFO
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   프로시저 원본 로직의 업무 처리 흐름을 수행한다.
   *   참조 테이블과 입력 파라미터를 기반으로 조회, 등록, 갱신 또는 메시지 반환을 처리한다.
   *   원본 코드의 트랜잭션 및 예외 처리 흐름은 변경하지 않았다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_MODEL_NAME - 원본 선언부 기준 입력/출력 파라미터
   *   P_LINE_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_WORKSTAGE_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_MACHINE_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_TYPE - 원본 선언부 기준 입력/출력 파라미터
   *   P_ORG - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   *   P_MESSAGE - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_2D_BARCODE - 원본 로직 참조 테이블
   *   IP_PRODUCT_MODEL_MASTER - 원본 로직 참조 테이블
   *   IQ_INTERLOCK_REQUEST_LOG - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_WORKSTAGE_TYPE
   *   F_MSG
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_INTERLOCK_MODEL_INFO(...)
   * ================================================================ */
   p_model_name       IN     VARCHAR2,
   p_line_code        IN     VARCHAR2,
   p_workstage_code   IN     VARCHAR2,
   p_machine_code     IN     VARCHAR2,
   p_type             IN     VARCHAR2,
   p_org              IN     NUMBER,
   p_out              OUT VARCHAR2,
   p_message          OUT VARCHAR2
   )
IS
   -- ---------   ------  -------------------------------------------
   lvs_customer_model_name        VARCHAR2 (50); -- [AI] 내부 처리용 변수
   lvs_model_name                 VARCHAR2 (50); -- [AI] 내부 처리용 변수
   lvs_part_no                    VARCHAR2 (50); -- [AI] 내부 처리용 변수
   lvs_carrier_size               VARCHAR2 (50); -- [AI] 내부 처리용 변수
   lvs_marking_condition          VARCHAR2 (50); -- [AI] 내부 처리용 변수
   lvs_carrier_barcode_yn         VARCHAR2 (50); -- [AI] 내부 처리용 변수
   lvs_ng_process                 VARCHAR2 (50); -- [AI] 내부 처리용 변수
   lvl_customer_code              VARCHAR2 (50); -- [AI] 내부 처리용 변수
   lvl_serial_no_length           NUMBER; -- [AI] 내부 처리용 변수
   lvl_packing_pcs_qty            NUMBER; -- [AI] 내부 처리용 변수
   lvl_serial_array_length        NUMBER; -- [AI] 내부 처리용 변수
   lvs_carrier_barcode_position   VARCHAR2 (50); -- [AI] 내부 처리용 변수
   lvi_magazine_print_x           NUMBER; -- [AI] 내부 처리용 변수
   lvi_magazine_print_y           NUMBER; -- [AI] 내부 처리용 변수
   lvs_barcode_type               VARCHAR2 (50); -- [AI] 내부 처리용 변수
   lvi_magazine_no_length         NUMBER; -- [AI] 내부 처리용 변수
   lvi_model_count                NUMBER; -- [AI] 내부 처리용 변수
   lvs_model_name_cond            VARCHAR2 (50); -- [AI] 내부 처리용 변수
   lvs_item_code                  VARCHAR2 (50); -- [AI] 내부 처리용 변수
   lvs_revision                   VARCHAR2 (50); -- [AI] 내부 처리용 변수
   lvs_ec_no                      VARCHAR2 (50); -- [AI] 내부 처리용 변수
   lvs_packing_tray_box_qty       NUMBER; -- [AI] 내부 처리용 변수
   lvl_pid_print_x                NUMBER := 34; -- [AI] 내부 처리용 변수
   lvl_pid_print_y                NUMBER := 26; -- [AI] 내부 처리용 변수
   lvs_model_suffix               VARCHAR2 (50); -- [AI] 내부 처리용 변수
   lvs_serial_no_position         VARCHAR2 (50); -- [AI] 내부 처리용 변수
------------------------------------------------------------------
-- spi
------------------------------------------------------------------

BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.

   BEGIN
      SELECT COUNT (*)
        INTO lvi_model_count
        FROM ip_product_model_master
       WHERE model_name = p_model_name
         AND organization_id = p_org;
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND
      THEN
         lvi_model_count := 0;
   END;

   --------------------------------------------------------------------
   --
   --------------------------------------------------------------------

   IF lvi_model_count > 0
   THEN
      lvs_model_name_cond := p_model_name;
   ELSE
      BEGIN
         SELECT model_name
           INTO lvs_model_name_cond
           FROM ip_product_2d_barcode
          WHERE serial_no = p_model_name
            AND organization_id = p_org;
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND
         THEN
            p_out     := 'NG';
            p_message := p_model_name||f_msg(', 바코드 이력 없음','C',1);

            RETURN;
      END;
   END IF;

   ---------------------------------------------------------------------------------
   --
   ---------------------------------------------------------------------------------
   BEGIN
      SELECT model_name,
             part_no,
             carrier_size,
             marking_condition,
             carrier_barcode_yn,
             serial_no_length,
             customer_code,
             packing_pcs_qty,
             serial_array_length,
             carrier_barcode_position,
             magazine_print_x,
             magazine_print_y,
             barcode_type,
             magazine_no_length,
             item_code,
             revision,
             customer_model_name,
             ec_no,
             packing_tray_box_qty,
             pid_print_x,
             pid_print_y,
             model_suffix,
             serial_no_position
        INTO lvs_model_name,
             lvs_part_no,
             lvs_carrier_size,
             lvs_marking_condition,
             lvs_carrier_barcode_yn,
             lvl_serial_no_length,
             lvl_customer_code,
             lvl_packing_pcs_qty,
             lvl_serial_array_length,
             lvs_carrier_barcode_position,
             lvi_magazine_print_x,
             lvi_magazine_print_y,
             lvs_barcode_type,
             lvi_magazine_no_length,
             lvs_item_code,
             lvs_revision,
             lvs_customer_model_name,
             lvs_ec_no,
             lvs_packing_tray_box_qty,
             lvl_pid_print_x,
             lvl_pid_print_y,
             lvs_model_suffix,
             lvs_serial_no_position
        FROM ip_product_model_master
       WHERE model_name = lvs_model_name_cond
         AND organization_id = p_org;

   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND THEN

         p_out     := 'NG';
         p_message := lvs_model_name_cond||f_msg(', 미 등록 모델','C',1);
         RETURN;

   END;

   --------------------------------------------------------------------------
   --
   --------------------------------------------------------------------------
   IF p_type = 'CUSTOMER_MODEL_NAME'
   THEN
      p_out := lvs_customer_model_name;
   ELSIF p_type = 'SERIAL_NO_POSITION'
   THEN
      p_out := lvs_serial_no_position;
   ELSIF p_type = 'MODEL_NAME'
   THEN
      p_out := lvs_model_name;
   ELSIF p_type = 'PART_NO'
   THEN
      p_out := lvs_part_no;
   ELSIF p_type = 'CARRIER_BARCODE_YN'
   THEN
      p_out := lvs_carrier_barcode_yn;
   ELSIF p_type = 'CARRIER_SIZE'
   THEN
      p_out := lvs_carrier_size;
   ----------------------------------------------------
   ELSIF p_type = 'MARKING_CONDITION'
   THEN
      p_out := lvs_marking_condition;
   -----------------------------------------------------
   ELSIF p_type = 'NG_PROCESS'
   THEN
      p_out := lvs_ng_process;
   ELSIF p_type = 'SERIAL_NO_LENGTH'
   THEN
      p_out := lvl_serial_no_length;
   ELSIF p_type = 'SERIAL_ARRAY_LENGTH'                             -- ARRAY 2
   THEN
      p_out := lvl_serial_array_length;
   ELSIF p_type = 'CARRIER_BARCODE_POSITION'
   THEN
      p_out := lvs_carrier_barcode_position;
   ELSIF p_type = 'CUSTOMER_CODE'
   THEN
      p_out := lvl_customer_code;
   ----------------------------------------------------
   -- insprect / selectev
   ----------------------------------------------------
   ELSIF p_type = 'PACKING_PCS_QTY'
   THEN
      IF F_GET_WORKSTAGE_TYPE(p_workstage_code ) = 'MAGAZINE' -- 'W080'
      THEN
         p_out := lvl_packing_pcs_qty;
      END IF;
   ELSIF P_TYPE = 'PACKING_TRAY_BOX_QTY'
   THEN
      p_out := lvs_packing_tray_box_qty;
   ELSIF p_type = 'MAGAZINE_PRINT_X'
   THEN
    
         p_out := lvi_magazine_print_x;
     
   ELSIF p_type = 'MAGAZINE_PRINT_Y'
   THEN
    
         p_out := lvi_magazine_print_y;
    
   ELSIF p_type = 'BARCODE_TYPE'
   THEN
      p_out := lvs_barcode_type;
   ELSIF p_type = 'MAGAZINE_NO_LENGTH'
   THEN
      p_out := lvi_magazine_no_length;
   ELSIF p_type = 'ITEM_CODE'
   THEN
      p_out := lvs_item_code;
   ELSIF p_type = 'REVISION'
   THEN
      p_out := lvs_revision;
   ELSIF p_type = 'EC_NO'
   THEN
      p_out := lvs_ec_no;
   ELSIF p_type = 'MODEL_SUFFIX'
   THEN
      p_out := lvs_model_suffix;
   ELSE
      p_out := '*';
   END IF;

   --    -------------------------------------------------------------------------
   --    --
   --    ------------------------------------------------------------------------
   --    INSERT INTO iq_interlock_request_log (line_code,
   --                                          machine_code,
   --                                          serial_no,
   --                                          request_date,
   --                                          comments,
   --                                          log_sequence,
   --                                          workstage_code,
   --                                          interlock_type,
   --                                          return_value)
   --      VALUES   ('*',
   --                '*',
   --                p_model_name,
   --                SYSDATE,
   --                'MODEL INFOR',
   --                seq_interlock_log.NEXTVAL,
   --                '*',
   --                p_type,
   --                p_out);
   --
   --    COMMIT;
   ---------------------------------------------------------------------------
   --
   ---------------------------------------------------------------------------
   RETURN;
EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN NO_DATA_FOUND
   THEN
     p_out     :=  'NG';
     p_message :=  'NOT FOUND';

      --        -------------------------------------------------------------------------
      --        --
      --        ------------------------------------------------------------------------
      --        INSERT INTO iq_interlock_request_log (line_code,
      --                                              machine_code,
      --                                              serial_no,
      --                                              request_date,
      --                                              comments,
      --                                              log_sequence,
      --                                              workstage_code,
      --                                              interlock_type,
      --                                              return_value)
      --          VALUES   ('*',
      --                    '*',
      --                    p_model_name,
      --                    SYSDATE,
      --                    'MODEL INFOR',
      --                    seq_interlock_log.NEXTVAL,
      --                    '*',
      --                    p_type,
      --                    p_out);
      --
      --        COMMIT;

      RETURN;
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS
   THEN
     p_out     := 'NG';
     p_message := SQLERRM;

     raise_application_error (-20003, SQLERRM);
END;