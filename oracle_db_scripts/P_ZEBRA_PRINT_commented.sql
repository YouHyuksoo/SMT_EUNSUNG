CREATE OR REPLACE PROCEDURE p_ZEBRA_PRINT(
  /* ================================================================
   * 프로시저명  : P_ZEBRA_PRINT
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   Zebra 프린터로 TCP 9100 포트에 라벨 명령 문자열을 전송한다.
   *   기존 TCP 연결을 정리한 뒤 지정 호스트로 연결하고, 입력 메시지를 그대로 write/flush 처리한다.
   *   연결 실패와 전송 오류는 애플리케이션 오류로 변환한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_HOST     (IN, VARCHAR2) - Zebra 프린터 호스트
   *   P_MESSAGE  (IN, VARCHAR2) - 전송할 ZPL 또는 라벨 명령 문자열
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   없음 (외부 TCP 프린터 통신 프로시저)
   * ================================================================
   * [AI 분석] 호출 객체:
   *   UTL_TCP - TCP 연결, 라벨 명령 전송, flush, 연결 종료 처리
   * ================================================================
   * [AI 분석] 예외 처리:
   *   내부 WHEN OTHERS - 프린터 연결 실패 시 ORA-20102 발생
   *   외부 WHEN OTHERS - 전송 처리 오류 시 ORA-20101 발생
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 없음
   *   DML: 없음
   * ================================================================
   * 사용 예시:
   *   EXEC P_ZEBRA_PRINT('192.168.100.252', '^XA...^XZ')
   * ================================================================ */
p_host IN VARCHAR2, p_message IN VARCHAR2)
AS
    bt_conn      UTL_TCP.connection; -- [AI] Zebra 프린터 TCP 연결 핸들
    retval       BINARY_INTEGER; -- [AI] TCP write_text 호출 결과값
    l_sequence   VARCHAR2(3000) := p_message ; -- [AI] 프린터로 전송할 라벨 명령 버퍼
    p_port       NUMBER := 9100; -- [AI] Zebra 프린터 RAW TCP 포트

    /*192.168.100.252*/
    /* ^XA^FO50,5^BXN,4,200^FDZETHANI^FS^XZ */
    /*
    ^XA

    ^FO10,30^BXN,6,200^FDADMIN@8888^FS
    ^CFA,25^FO10,130^FDADMIN^FS
    ^CFA,20^FO20,160^FDLCDMES^FS
    ^CFA,20^FO20,230^FDJiSung^FS

    ^FO150,30^BXN,6,200^FDADMIN@8888^FS
    ^CFA,25^FO150,130^FDADMIN^FS
    ^CFA,20^FO160,160^FDLCDMES^FS
    ^CFA,20^FO160,230^FDJiSung^FS

    ^FO290,30^BXN,6,200^FDADMIN@8888^FS
    ^CFA,25^FO290,130^FDADMIN^FS
    ^CFA,20^FO300,160^FDLCDMES^FS
    ^CFA,20^FO300,230^FDJiSung^FS

    ^FO430,30^BXN,6,200^FDADMIN@8888^FS
    ^CFA,25^FO430,130^FDADMIN^FS
    ^CFA,20^FO440,160^FDLCDMES^FS
    ^CFA,20^FO440,230^FDJiSung^FS

    ^XZ
    */

BEGIN
----------------------------------------------------------------
--
----------------------------------------------------------------
  -- [AI] 기존 TCP 연결을 모두 정리한다.
  UTL_TCP.close_all_connections;

----------------------------------------------------------------
    BEGIN
        -- [AI] Zebra 프린터의 RAW TCP 포트로 연결한다.
        bt_conn := UTL_TCP.open_connection (remote_host => p_host, remote_port => p_port, tx_timeout => 1 );
    EXCEPTION
        -- [AI] 프린터 연결 실패를 애플리케이션 오류로 변환한다.
        WHEN OTHERS
        THEN
            raise_application_error (-20102, 'NSNP CONNET FAIL ' || SQLERRM);
    END;

    --------------------------------------------------------
    --  host , Relay No , on/off , Delay Time
    --------------------------------------------------------

    -- [AI] 입력 라벨 명령을 전송 버퍼에 설정한다.
    l_sequence :=  p_message ;

    --------------------------------------------------------
    -- [AI] 라벨 명령 문자열을 프린터로 전송한다.
    retval := UTL_TCP.write_text (bt_conn, l_sequence , LENGTH (l_sequence));

   -- retval := UTL_TCP.write_raw (bt_conn, UTL_RAW.CAST_TO_RAW(UTL_TCP.CRLF||l_sequence||UTL_TCP.CRLF));

    --------------------------------------------------------
    -- [AI] TCP 버퍼를 flush하고 연결을 종료한다.
    UTL_TCP.flush (bt_conn);
    UTL_TCP.close_connection (bt_conn);

--------------------------------------------------------
EXCEPTION
    -- [AI] 전송 처리 중 오류를 애플리케이션 오류로 변환한다.
    WHEN OTHERS
    THEN
        raise_application_error (-20101, SQLERRM);

        UTL_TCP.close_connection (bt_conn);
END;
