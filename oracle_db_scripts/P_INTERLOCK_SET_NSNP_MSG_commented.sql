CREATE OR REPLACE PROCEDURE "P_INTERLOCK_SET_NSNP_MSG" (
  /* ================================================================
   * 프로시저명  : P_INTERLOCK_SET_NSNP_MSG
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
   *   P_LINE_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_MESSAGE - 원본 선언부 기준 입력/출력 파라미터
   *   P_MODEL_NAME - 원본 선언부 기준 입력/출력 파라미터
   *   P_MODEL_SUFFIX - 원본 선언부 기준 입력/출력 파라미터
   *   P_NSNP_REASON - 원본 선언부 기준 입력/출력 파라미터
   *   P_NSNP_ERROR_MESSAGE - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IMCN_MACHINE - 원본 로직 참조 테이블
   *   IP_PRODUCT_LINE - Product Line Master
   * ================================================================
   * [AI 분석] 호출 객체:
   *   FLUSH
   *   P_NSNP_NET_ERROR_LOG
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_INTERLOCK_SET_NSNP_MSG(...)
   * ================================================================ */
   p_line_code            IN VARCHAR2,
   p_message              IN VARCHAR2,
   p_model_name           IN VARCHAR2 DEFAULT '*',
   p_model_suffix         IN VARCHAR2 DEFAULT '*',
   p_nsnp_reason          IN VARCHAR2 DEFAULT '*',
   p_nsnp_error_message   IN VARCHAR2 DEFAULT '*')
AS
   bt_conn          UTL_TCP.connection; -- [AI] 내부 처리용 변수
   retval           BINARY_INTEGER; -- [AI] 내부 처리용 변수
   l_sequence       VARCHAR2 (200) := p_message; -- [AI] 내부 처리용 변수
   p_host           VARCHAR2 (100); -- [AI] 내부 처리용 변수
   p_port           NUMBER := 3456; -- [AI] 내부 처리용 변수
   lvs_use_status   VARCHAR2 (10); -- [AI] 내부 처리용 변수
   lvs_error varchar2(1000); -- [AI] 내부 처리용 변수
   lvs_sqlerrm varchar2(1000) ; -- [AI] 내부 처리용 변수
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
   BEGIN
      UTL_TCP.close_all_connections;
      
   --------------------------------------------------------
   --
   --------------------------------------------------------
   IF p_message = 'OPEN' OR p_message = '1'
   THEN
      UPDATE ip_product_line
         SET nsnp_status = 'ON', nsnp_start_date = SYSDATE
       WHERE line_code = SUBSTR (p_line_code, 1, 2);
   ELSE
      UPDATE ip_product_line
         SET nsnp_status = 'WAIT', nsnp_start_date = NULL
       WHERE line_code = SUBSTR (p_line_code, 1, 2);
   END IF;     

      ------------------------------------------------------------------------------------------
      --
      ------------------------------------------------------------------------------------------

      BEGIN
         SELECT NVL (ip_address, '*'), use_status
           INTO p_host, lvs_use_status
           FROM imcn_machine
          WHERE line_code = SUBSTR (p_line_code, 1, 2)
                AND machine_type = 'NSNP';
       EXCEPTION
      
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND
         THEN
            IF p_message = 'OPEN' OR p_message = '1'
            THEN
               UPDATE ip_product_line
                  SET nsnp_status = 'ON[X]', nsnp_start_date = SYSDATE
                WHERE line_code = SUBSTR (p_line_code, 1, 2);
            ELSE
               UPDATE ip_product_line
                  SET nsnp_status = 'WAIT[X]', nsnp_start_date = NULL
                WHERE line_code = SUBSTR (p_line_code, 1, 2);
            END IF;

            COMMIT;
            RETURN;
      END;

      -----------------------------------------------------------
      --
      -----------------------------------------------------------
      IF p_host = '*' OR p_host IS NULL
      THEN
         IF p_message = 'OPEN' OR p_message = '1'
         THEN
            UPDATE ip_product_line
               SET nsnp_status = 'ON[IP]', nsnp_start_date = SYSDATE
             WHERE line_code = SUBSTR (p_line_code, 1, 2);
         ELSE
            UPDATE ip_product_line
               SET nsnp_status = 'WAIT[IP]', nsnp_start_date = NULL
             WHERE line_code = SUBSTR (p_line_code, 1, 2);
         END IF;

         COMMIT;
         RETURN;
      END IF;
   END;
   --------------------------------------------------------
   --  host , Relay No , on/off , Delay Time
   --------------------------------------------------------

   IF p_message = 'OPEN' OR p_message = '1'
   THEN
      -----------------------------------------------------
      --
      -----------------------------------------------------
      l_sequence := '1,1,' || p_nsnp_error_message;        -- 2 MINUTES 120000
    
   ELSIF p_message = 'CLOSE' OR p_message = '0'
   THEN
   
      l_sequence := '0,0,0';
   ------------------------------------------------------
   -- QC INERLOCK
   ------------------------------------------------------

   ELSIF p_message = 'LOCK'
   THEN
      l_sequence := 'LOCK';
   ELSIF p_message = 'UNLOCK'
   THEN
      l_sequence := 'UNLOCK';
   ELSE
      l_sequence := p_message;
   END IF;

  -----------------------------------------------------------
  --
  -----------------------------------------------------------
   IF l_sequence = 'RESET'
   THEN           
      BEGIN
         bt_conn :=
            UTL_TCP.
             open_connection (remote_host   => p_host,
                              remote_port   => p_port,
                              tx_timeout    => 1);
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN OTHERS
         THEN
            UTL_TCP.close_connection (C => bt_conn);
      --   LVS_SQLERRM := 'STEP 4 ' || SQLERRM;

      END;

      BEGIN
         retval :=
            UTL_TCP.write_text (bt_conn, l_sequence, LENGTH (l_sequence));
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN OTHERS
         THEN
            NULL;
      --      LVS_SQLERRM := 'STEP 5';
      END;

      --------------------------------------------------------

      UTL_TCP.flush (bt_conn);
      UTL_TCP.close_connection (bt_conn);

      -----------------------------------------------------
      --
      -----------------------------------------------------
       P_NSNP_NET_ERROR_LOG(p_line_code, p_model_name, p_model_suffix, p_nsnp_reason,p_nsnp_error_message,p_host, lvs_sqlerrm) ;


      COMMIT;
      RETURN;
   END IF;

   -----------------------------------------------------------------
   --
   -----------------------------------------------------------------

   IF upper(lvs_use_status) = 'U'
   THEN
      BEGIN
         bt_conn :=
            UTL_TCP.
             open_connection (remote_host   => p_host,
                              remote_port   => p_port,
                              tx_timeout    => 1);
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN OTHERS
         THEN
            UTL_TCP.close_connection (bt_conn);
            raise_application_error (-20102, 'NSNP CONNET FAIL ' || SQLERRM);
      END;

      --------------------------------------------------------
      retval := UTL_TCP.write_text (bt_conn, l_sequence, LENGTH (l_sequence));

      --------------------------------------------------------
      UTL_TCP.flush (bt_conn);
      UTL_TCP.close_connection (bt_conn);
   ELSE
      l_sequence := '0,0,0';

      BEGIN
         bt_conn :=
            UTL_TCP.
             open_connection (remote_host   => p_host,
                              remote_port   => p_port,
                              tx_timeout    => 1);
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN OTHERS
         THEN
            UTL_TCP.close_connection (bt_conn);
            raise_application_error (-20102, 'NSNP CONNET FAIL ' || SQLERRM);
      END;

      --------------------------------------------------------
      retval := UTL_TCP.write_text (bt_conn, l_sequence, LENGTH (l_sequence));

      --------------------------------------------------------
      UTL_TCP.flush (bt_conn);
      UTL_TCP.close_connection (bt_conn);
   END IF;

     
   COMMIT;
--------------------------------------------------------
EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS
   THEN
  
      UTL_TCP.close_connection (bt_conn);
      raise_application_error (-20101, p_host || ' ' || SQLERRM);
END;