CREATE OR REPLACE PROCEDURE p_interlock_set_nsnp_time_msg2 (
  /* ================================================================
   * 프로시저명  : P_INTERLOCK_SET_NSNP_TIME_MSG2
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
   *   P_MESSAGE - 원본 선언부 기준 입력/출력 파라미터
   *   P_TIME - 원본 선언부 기준 입력/출력 파라미터
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
   *   EXEC P_INTERLOCK_SET_NSNP_TIME_MSG2(...)
   * ================================================================ */
   p_line_code            IN VARCHAR2,
   p_message              IN VARCHAR2,
   p_time                 IN NUMBER,
   p_model_name           IN VARCHAR2 DEFAULT '*',
   p_model_suffix         IN VARCHAR2 DEFAULT '*',
   p_nsnp_reason          IN VARCHAR2 DEFAULT '*',
   p_nsnp_error_message   IN VARCHAR2 DEFAULT '*')
AS

   bt_conn              UTL_TCP.connection; -- [AI] 내부 처리용 변수
   retval               BINARY_INTEGER; -- [AI] 내부 처리용 변수
   l_sequence           VARCHAR2 (200); -- [AI] 내부 처리용 변수
   p_host               VARCHAR2 (100); -- [AI] 내부 처리용 변수
   p_port               NUMBER := 3456; -- [AI] 내부 처리용 변수
   LVS_SQLERRM          VARCHAR2 (1000); -- [AI] 내부 처리용 변수
   LVS_MINUS_CHECK_YN   VARCHAR2 (10); -- [AI] 내부 처리용 변수
   lvs_use_status       VARCHAR2 (10); -- [AI] 내부 처리용 변수
   
   pragma autonomous_transaction ;
   
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
  
   LVS_SQLERRM := 'STEP 0';

   UTL_TCP.close_all_connections;

  --------------------------------------------------------
   --
   --------------------------------------------------------
   IF p_message = 'OPEN' OR p_message = '1'
   THEN
      UPDATE ip_product_line
         SET nsnp_status = 'ON',
             nsnp_start_date = SYSDATE,
             COMMENTS = SUBSTR (LVS_SQLERRM, 1, 500),
             NSNP_REASON = p_nsnp_error_message,
             NSNP_LOCK_TYPE = p_nsnp_reason
       WHERE line_code = SUBSTR (p_line_code, 1, 2);
   ELSE
      UPDATE ip_product_line
         SET nsnp_status = 'WAIT',
             nsnp_start_date = NULL,
             COMMENTS = SUBSTR (LVS_SQLERRM, 1, 500),
             NSNP_REASON = NULL,
             NSNP_LOCK_TYPE = NULL
       WHERE line_code = SUBSTR (p_line_code, 1, 2);
   END IF;

   ------------------------------------------------------------------------------------------
   -- IP
   ------------------------------------------------------------------------------------------

   BEGIN
      SELECT NVL (ip_address, '*'),
             use_status,
             NVL (nsnp_minus_check_yn, 'N')
        INTO p_host, lvs_use_status, LVS_MINUS_CHECK_YN
        FROM imcn_machine
       WHERE line_code = SUBSTR (p_line_code, 1, 2) AND machine_type = 'NSNP';
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN NO_DATA_FOUND
      THEN
         IF p_message = 'OPEN' OR p_message = '1'
         THEN
            UPDATE ip_product_line
               SET nsnp_status = 'ON[X]',
                   nsnp_start_date = SYSDATE,
                   COMMENTS = LVS_SQLERRM,
                   NSNP_REASON = p_nsnp_error_message,
                   NSNP_LOCK_TYPE = p_nsnp_reason
             WHERE line_code = SUBSTR (p_line_code, 1, 2);
         ELSE
            UPDATE ip_product_line
               SET nsnp_status = 'WAIT[X]',
                   nsnp_start_date = NULL,
                   COMMENTS = LVS_SQLERRM,
                   NSNP_REASON = NULL,
                   NSNP_LOCK_TYPE = NULL
             WHERE line_code = SUBSTR (p_line_code, 1, 2);
         END IF;

         COMMIT;
         LVS_SQLERRM := 'STEP 2';
         RETURN;
   END;

   LVS_SQLERRM := 'STEP 11';

   -----------------------------------------------------------
   -- IP
   -----------------------------------------------------------
   IF p_host = '*' OR p_host IS NULL
   THEN
      IF p_message = 'OPEN' OR p_message = '1'
      THEN
         UPDATE ip_product_line
            SET nsnp_status = 'ON[IP]',
                nsnp_start_date = SYSDATE,
                COMMENTS = LVS_SQLERRM,
                NSNP_REASON = p_nsnp_error_message,
                NSNP_LOCK_TYPE = p_nsnp_reason
          WHERE line_code = SUBSTR (p_line_code, 1, 2);
      ELSE
         UPDATE ip_product_line
            SET nsnp_status = 'WAIT[IP]',
                nsnp_start_date = NULL,
                COMMENTS = LVS_SQLERRM,
                NSNP_REASON = NULL,
                NSNP_LOCK_TYPE = NULL
          WHERE line_code = SUBSTR (p_line_code, 1, 2);
      END IF;

      COMMIT;
      LVS_SQLERRM := 'STEP 3';
      RETURN;
   END IF;

   LVS_SQLERRM := 'STEP 12';

   --------------------------------------------------------
   --  host , Relay No , on/off , Delay Time
   --------------------------------------------------------

   IF p_message = 'OPEN' OR p_message = '1'
   THEN
      l_sequence := '1,' || P_TIME || ',' || p_nsnp_error_message; -- 2 MINUTES 120000
   ELSIF p_message = 'CLOSE' OR p_message = '0'
   THEN
      l_sequence := '0,0,0';
   -------------------------------------------------------
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

   LVS_SQLERRM := 'STEP 14';

   ---------------------------------------------------------------------------
   -- nsnp
   ---------------------------------------------------------------------------

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

            LVS_SQLERRM := SUBSTR ('STEP 4 CONNECT ' || SQLERRM, 1, 500);

            UPDATE ip_product_line
               SET nsnp_status = 'RESET CONNECT ERROR',
                   nsnp_start_date = NULL,
                   COMMENTS = LVS_SQLERRM
             WHERE line_code = SUBSTR (p_line_code, 1, 2);

            COMMIT;
            RETURN;
      END;

      BEGIN
         --   l_sequence := 'RESET,' || '1' || ',' || 'RESET' ;

         retval :=
            UTL_TCP.write_text (bt_conn, l_sequence, LENGTH (l_sequence));
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN OTHERS
         THEN
            LVS_SQLERRM := SUBSTR ('STEP 5 SEND ' || SQLERRM, 1, 500);

            UPDATE ip_product_line
               SET nsnp_status = 'RESET SEND ERROR',
                   nsnp_start_date = NULL,
                   COMMENTS = LVS_SQLERRM
             WHERE line_code = SUBSTR (p_line_code, 1, 2);

            COMMIT;
            RETURN;
      END;

      LVS_SQLERRM := 'STEP 15';
      --------------------------------------------------------

      UTL_TCP.flush (bt_conn);
      UTL_TCP.close_connection (bt_conn);
      LVS_SQLERRM := 'OK';

      BEGIN
         -----------------------------------------------------
         --
         -----------------------------------------------------
           P_NSNP_NET_ERROR_LOG(p_line_code, p_model_name, p_model_suffix, p_nsnp_reason,p_nsnp_error_message,p_host, lvs_sqlerrm) ;  

      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN OTHERS
         THEN
            LVS_SQLERRM := 'STEP 20';
      END;

      COMMIT;
      RETURN;
   END IF;

   ------------------------------------------------------------
   -- NSNP 
   ------------------------------------------------------------

   IF lvs_use_status = 'U'
   THEN
      IF p_NSNP_REASON = 'MINUS' AND LVS_MINUS_CHECK_YN = 'N'
      THEN
         NULL;
      ELSE
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
               LVS_SQLERRM := SUBSTR ('STEP 4 ' || SQLERRM, 1, 500);
         END;

         LVS_SQLERRM := 'STEP 16';

         BEGIN
            retval :=
               UTL_TCP.write_text (bt_conn, l_sequence, LENGTH (l_sequence));
         EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
            WHEN OTHERS
            THEN
               RAISE_APPLICATION_ERROR (-20003, SQLERRM);
               LVS_SQLERRM := SUBSTR (SQLERRM, 1, 500);
         END;

         --------------------------------------------------------

         UTL_TCP.flush (bt_conn);
         UTL_TCP.close_connection (bt_conn);
      -----------------------------------------------------------
      --
      --
      -----------------------------------------------------------

      END IF;
   ELSE
      LVS_SQLERRM := 'STEP 18';
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
            UTL_TCP.close_connection (C => bt_conn);
            LVS_SQLERRM := SUBSTR ('STEP 4 ' || SQLERRM, 1, 500);
      -- raise_application_error (-20102, 'NSNP CONNET FAIL ' || SQLERRM);
      END;

      BEGIN
         retval :=
            UTL_TCP.write_text (bt_conn, l_sequence, LENGTH (l_sequence));
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN OTHERS
         THEN
            LVS_SQLERRM := 'STEP 5';
      END;

      --------------------------------------------------------

      UTL_TCP.flush (bt_conn);
      UTL_TCP.close_connection (bt_conn);
   END IF;

   BEGIN
      -----------------------------------------------------
      --
      -----------------------------------------------------
      IF p_NSNP_REASON = 'MINUS' AND LVS_MINUS_CHECK_YN = 'N'
      THEN
         NULL;
      ELSE
           P_NSNP_NET_ERROR_LOG(p_line_code, p_model_name, p_model_suffix, p_nsnp_reason,p_nsnp_error_message,p_host, lvs_sqlerrm) ;
      END IF;
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      WHEN OTHERS
      THEN
         LVS_SQLERRM := 'STEP 20';
   END;

   COMMIT;
--------------------------------------------------------
--
--------------------------------------------------------

EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS
   THEN
      --   RAISE_APPLICATION_ERROR( -20003 , SQLERRM ) ;
      LVS_SQLERRM := SQLERRM||' IP='||p_host;
      UTL_TCP.close_connection (bt_conn);

      UPDATE ip_product_line
         SET nsnp_status = 'ERROR',
             nsnp_start_date = NULL,
             COMMENTS = SUBSTR (LVS_SQLERRM, 1, 500)
       WHERE line_code = SUBSTR (p_line_code, 1, 2);
       ------------------------------------------------
       --
       ------------------------------------------------
       P_NSNP_NET_ERROR_LOG(p_line_code, p_model_name, p_model_suffix, p_nsnp_reason,p_nsnp_error_message,p_host, lvs_sqlerrm) ;
       COMMIT;
END;
