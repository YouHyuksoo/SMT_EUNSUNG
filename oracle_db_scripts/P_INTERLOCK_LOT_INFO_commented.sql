CREATE OR REPLACE PROCEDURE "P_INTERLOCK_LOT_INFO" (p_run_no IN VARCHAR2, p_type IN VARCHAR2, p_out OUT VARCHAR2)
  /* ================================================================
   * 프로시저명  : P_INTERLOCK_LOT_INFO
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2015-07-12
   * 수정이력:
   *   2015-07-12 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   프로시저 원본 로직의 업무 처리 흐름을 수행한다.
   *   참조 테이블과 입력 파라미터를 기반으로 조회, 등록, 갱신 또는 메시지 반환을 처리한다.
   *   원본 코드의 트랜잭션 및 예외 처리 흐름은 변경하지 않았다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_RUN_NO - 원본 선언부 기준 입력/출력 파라미터
   *   P_TYPE - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_2D_BARCODE - 원본 로직 참조 테이블
   *   IP_PRODUCT_MODEL_MASTER - 원본 로직 참조 테이블
   *   IP_PRODUCT_RUN_CARD - 원본 로직 참조 테이블
   *   IQ_INTERLOCK_REQUEST_LOG - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_INTERLOCK_LOT_INFO(...)
   * ================================================================ */
/* Formatted on 2015-07-12 15:49:56 (QP5 v5.126) */
IS
    -- ---------   ------  -------------------------------------------
    lvs_model_name         VARCHAR2 (30); -- [AI] 내부 처리용 변수
    lvs_parent_item_code   VARCHAR2 (30); -- [AI] 내부 처리용 변수
    lvl_lot_size           NUMBER; -- [AI] 내부 처리용 변수
    lvs_array_type         VARCHAR2 (10); -- [AI] 내부 처리용 변수
    lvl_good_count         INT; -- [AI] 내부 처리용 변수
------------------------------------------------------------------

-- CARRIER_SIZE

BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
    SELECT   model_name, parent_item_code, lot_size
      INTO   lvs_model_name, lvs_parent_item_code, lvl_lot_size
      FROM   ip_product_run_card
     WHERE   run_no = p_run_no;

    BEGIN
        SELECT   MAX (array_type)
          INTO   lvs_array_type
          FROM   ip_product_model_master
         WHERE   item_code = lvs_parent_item_code;
    EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
        WHEN NO_DATA_FOUND
        THEN
            raise_application_error (-20003, 'ARRAY TYPE ERROR ' || SQLERRM);
    END;

    --------------------------------------------------------------------------
    --
    --------------------------------------------------------------------------

    IF p_type = 'MODEL_NAME'
    THEN
        p_out := lvs_model_name;
    ELSIF p_type = 'ITEM_CODE'
    THEN
        p_out := lvs_parent_item_code;
    ELSIF p_type = 'LOT_SIZE'
    THEN
        p_out := lvl_lot_size;
    ELSIF p_type = 'ARRAY_TYPE'
    THEN
        p_out := lvs_array_type;
    ELSIF p_type = 'GOOD_COUNT'
    THEN
        SELECT   COUNT (1)
          INTO   lvl_good_count
          FROM   ip_product_2d_barcode
         WHERE   run_no = p_run_no;

        p_out := lvl_good_count;
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
--                p_run_no,
--                SYSDATE,
--                'LOT INFOR',
--                seq_interlock_log.NEXTVAL,
--                '*',
--                p_type,
--                p_out);
--
--    COMMIT;

    --------------------------------------------------------------------------
    --
    --------------------------------------------------------------------------

    RETURN;
EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
    WHEN NO_DATA_FOUND
    THEN
        p_out := 'NOT FOUND RUNCARD';

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
--                    p_run_no,
--                    SYSDATE,
--                    'LOT INFOR',
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
      p_out :=SQLERRM ;
        raise_application_error (-20003, SQLERRM);
END;