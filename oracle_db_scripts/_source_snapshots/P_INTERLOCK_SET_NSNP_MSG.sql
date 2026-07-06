PROCEDURE "P_INTERLOCK_SET_NSNP_MSG" (
   p_line_code            IN VARCHAR2,
   p_message              IN VARCHAR2,
   p_model_name           IN VARCHAR2 DEFAULT '*',
   p_model_suffix         IN VARCHAR2 DEFAULT '*',
   p_nsnp_reason          IN VARCHAR2 DEFAULT '*',
   p_nsnp_error_message   IN VARCHAR2 DEFAULT '*')
AS
   bt_conn          UTL_TCP.connection;
   retval           BINARY_INTEGER;
   l_sequence       VARCHAR2 (200) := p_message;
   p_host           VARCHAR2 (100);
   p_port           NUMBER := 3456;
   lvs_use_status   VARCHAR2 (10);
   lvs_error varchar2(1000);
   lvs_sqlerrm varchar2(1000) ;
BEGIN
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
         WHEN OTHERS
         THEN
            UTL_TCP.close_connection (C => bt_conn);
      --   LVS_SQLERRM := 'STEP 4 ' || SQLERRM;

      END;

      BEGIN
         retval :=
            UTL_TCP.write_text (bt_conn, l_sequence, LENGTH (l_sequence));
      EXCEPTION
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
   WHEN OTHERS
   THEN
  
      UTL_TCP.close_connection (bt_conn);
      raise_application_error (-20101, p_host || ' ' || SQLERRM);
END;