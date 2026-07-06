CREATE OR REPLACE PROCEDURE "P_INTERLOCK_LINE_CONFIG" (p_line_code      IN     VARCHAR2,
  /* ================================================================
   * 프로시저명  : P_INTERLOCK_LINE_CONFIG
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
   *   P_LINE_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_MACHINE_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_CONFIG - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IMCN_MACHINE - 원본 로직 참조 테이블
   *   IQ_INTERLOCK_REQUEST_LOG - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_INTERLOCK_LINE_CONFIG(...)
   * ================================================================ */
/* Formatted on 2015-07-12 15:51:26 (QP5 v5.126) */
                                   p_machine_code   IN     VARCHAR2,
                                   p_config         IN     VARCHAR2,
                                   p_out               OUT VARCHAR2)
IS
    lvs_return                 VARCHAR2 (30); -- [AI] 내부 처리용 변수

    lvs_dio_port               VARCHAR2 (30); -- [AI] 내부 처리용 변수
    lvs_scanner_port           VARCHAR2 (30); -- [AI] 내부 처리용 변수
    lvs_equipment_port         VARCHAR2 (30); -- [AI] 내부 처리용 변수
    lvs_dio_address            VARCHAR2 (30); -- [AI] 내부 처리용 변수
    lvs_bcr_code               VARCHAR2 (30); -- [AI] 내부 처리용 변수
    lvs_buffer_type            VARCHAR2 (30); -- [AI] 내부 처리용 변수
    lvs_workstage_code         VARCHAR2 (30); -- [AI] 내부 처리용 변수
    lvs_workstage_name         VARCHAR2 (30); -- [AI] 내부 처리용 변수
    lvf_process_process_time   NUMBER; -- [AI] 내부 처리용 변수
    lvs_scanner_address        VARCHAR2 (30); -- [AI] 내부 처리용 변수
    lvs_process_wait_time      VARCHAR2 (30); -- [AI] 내부 처리용 변수
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------

    SELECT   NVL (a.dio_port, 'N'),
             NVL (a.scanner_port, 'N'),
             NVL (a.equipment_port, 'N'),
             a.dio_address,
             a.bcr_code,
             a.buffer_type,
             a.workstage_code,                                                                         -- workstage code
             b.workstage_name,
             a.process_wait_time,
             a.scanner_address,
             a.process_wait_time
      INTO   lvs_dio_port,
             lvs_scanner_port,
             lvs_equipment_port,
             lvs_dio_address,
             lvs_bcr_code,
             lvs_buffer_type,
             lvs_workstage_code,
             lvs_workstage_name,
             lvf_process_process_time,
             lvs_scanner_address,
             lvs_process_wait_time
      FROM   imcn_machine a, ip_product_workstage b
     WHERE   a.line_code = p_line_code
         AND a.machine_code = p_machine_code
         AND a.workstage_code = b.workstage_code(+)
         AND a.organization_id = b.organization_id(+);

    -------------------------------------------------------------------
    --
    -------------------------------------------------------------------

    IF p_config = 'DIO_PORT'
    THEN
        p_out := lvs_dio_port;
    ELSIF p_config = 'SCANNER_PORT'
    THEN
        p_out := lvs_scanner_port;
    ELSIF p_config = 'EQUIPMENT_PORT'
    THEN
        p_out := lvs_equipment_port;
    ELSIF p_config = 'DIO_ADDRESS'
    THEN
        p_out := lvs_dio_address;
    ELSIF p_config = 'BCR_CODE'
    THEN
        p_out := lvs_bcr_code;
    ELSIF p_config = 'BUFFER_TYPE'
    THEN
        p_out := lvs_buffer_type;
    ELSIF p_config = 'WORKSTAGE_CODE'
    THEN
        p_out := lvs_workstage_code;
    ELSIF p_config = 'WORKSTAGE_NAME'
    THEN
        p_out := lvs_workstage_name;
    ELSIF p_config = 'SCANNER_ADDRESS'
    THEN
        p_out := lvs_scanner_address;
    ELSIF p_config = 'PROCESS_WAIT_TIME'
    THEN
        p_out := lvs_process_wait_time;
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
--      VALUES   (p_line_code,
--                p_machine_code,
--                '*',
--                SYSDATE,
--                'LINE CONFIG',
--                seq_interlock_log.NEXTVAL,
--                '*',
--                p_config,
--                p_out);
--
--    COMMIT;
    RETURN;
EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
    WHEN NO_DATA_FOUND
    THEN
        p_out := 'NO DATA FOUND';

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
--          VALUES   (p_line_code,
--                    p_machine_code,
--                    '*',
--                    SYSDATE,
--                    'LINE CONFIG',
--                    seq_interlock_log.NEXTVAL,
--                    '*',
--                    p_config,
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