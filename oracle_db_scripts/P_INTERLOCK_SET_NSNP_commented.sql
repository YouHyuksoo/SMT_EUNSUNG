CREATE OR REPLACE PROCEDURE "P_INTERLOCK_SET_NSNP" (
  /* ================================================================
   * 프로시저명  : P_INTERLOCK_SET_NSNP
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2015-06-06
   * 수정이력:
   *   2015-06-06 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   NSNP 장비 또는 릴레이 호스트로 TCP 메시지를 전송한다.
   *   입력 호스트의 3456 포트에 연결한 뒤 전달 메시지를 그대로 write/flush 처리한다.
   *   연결 실패와 전송 중 오류는 각각 애플리케이션 오류로 변환한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_HOST     (IN, VARCHAR2) - TCP 연결 대상 호스트
   *   P_MESSAGE  (IN, VARCHAR2) - 전송할 NSNP 제어 메시지
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   없음 (외부 TCP 통신 프로시저)
   * ================================================================
   * [AI 분석] 호출 객체:
   *   UTL_TCP - TCP 연결, 메시지 전송, flush, 연결 종료 처리
   * ================================================================
   * [AI 분석] 예외 처리:
   *   내부 WHEN OTHERS - TCP 연결 실패 시 ORA-20102 발생
   *   외부 WHEN OTHERS - 전송/종료 중 오류 시 ORA-20101 발생
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 없음
   *   DML: 없음
   * ================================================================
   * 사용 예시:
   *   EXEC P_INTERLOCK_SET_NSNP('192.168.0.10', 'MESSAGE')
   * ================================================================ */
p_host IN VARCHAR2, p_message IN VARCHAR2)
/* Formatted on 2015-06-06 16:16:47 (QP5 v5.126) */
AS
    bt_conn      UTL_TCP.connection; -- [AI] 대상 호스트와의 TCP 연결 핸들
    retval       BINARY_INTEGER; -- [AI] TCP write_text 호출 결과값
    l_sequence   VARCHAR2 (3000) := p_message;  -- [AI] 전송할 메시지 버퍼
    p_port       NUMBER := 3456; -- [AI] NSNP 통신 대상 포트
BEGIN
----------------------------------------------------------------
--
----------------------------------------------------------------
  -- [AI] 기존 TCP 연결을 정리한 뒤 새 연결을 준비한다.
  UTL_TCP.close_all_connections;

----------------------------------------------------------------
    BEGIN
        -- [AI] 지정 호스트와 NSNP 포트로 TCP 연결을 생성한다.
        bt_conn := UTL_TCP.open_connection (remote_host => p_host, remote_port => p_port, tx_timeout => 1);
    EXCEPTION
        -- [AI] 연결 실패 시 호출부가 구분할 수 있는 오류 코드로 변환한다.
        WHEN OTHERS
        THEN
            raise_application_error (-20102, 'NSNP CONNET FAIL ' || SQLERRM);
    END;

    --------------------------------------------------------
    --  host , Relay No , on/off , Delay Time
    --------------------------------------------------------

      -- [AI] 입력 메시지를 실제 전송 버퍼에 설정한다.
      l_sequence := p_message;

    --------------------------------------------------------
    -- [AI] 메시지를 TCP 연결로 전송한다.
    retval := UTL_TCP.write_text (bt_conn, l_sequence, LENGTH (l_sequence));

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
