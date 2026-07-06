CREATE OR REPLACE PROCEDURE "TEST_P_ALIGO_HTTP_REMAIN"
  /* ================================================================
   * 프로시저명  : TEST_P_ALIGO_HTTP_REMAIN
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-09-25
   * 수정이력:
   *   2020-09-25 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   알리고 API 잔여 건수 조회 엔드포인트로 HTTP POST 요청을 보내는 테스트 프로시저이다.
   *   요청 파라미터를 form-urlencoded 문자열로 구성하고 wallet 설정 후 HTTPS 요청을 전송한다.
   *   응답 본문은 행 단위로 읽어 DBMS_OUTPUT에 출력한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   없음
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   없음 (외부 HTTP 통신 테스트 프로시저)
   * ================================================================
   * [AI 분석] 호출 객체:
   *   UTL_HTTP - HTTPS 요청 생성, 헤더 설정, 요청 본문 전송, 응답 수신 처리
   *   DBMS_OUTPUT - 응답 본문 출력
   * ================================================================
   * [AI 분석] 예외 처리:
   *   내부 WHEN UTL_HTTP.END_OF_BODY - 응답 본문 종료 시 정상 종료
   *   외부 WHEN OTHERS - ORA-20100으로 프로시저명과 오류 메시지를 재발생시킨다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: LOOP 1회
   *   DML: 없음
   * ================================================================
   * 사용 예시:
   *   EXEC TEST_P_ALIGO_HTTP_REMAIN
   * ================================================================ */
AS

   v_request   UTL_HTTP.req; -- [AI] 알리고 API HTTP 요청 핸들
   v_response  UTL_HTTP.resp; -- [AI] 알리고 API HTTP 응답 핸들
   v_text      varchar2(5000) := ''; -- [AI] 응답 본문 라인 읽기 버퍼
   v_param     varchar2(4000) := ''; -- [AI] POST 요청 파라미터 문자열
   v_length    number := 0; -- [AI] 요청 파라미터 문자열 길이

BEGIN
   -- [AI] 알리고 잔여 건수 조회용 POST 파라미터를 구성한다.
   v_param := 'key=' || '89dmul9fej3llmlkayieb3xrxd9g4mqp'
           || CHR(38) || 'user_id=' || 'js1025' ;
   --
   v_length := LENGTH(v_param);
   -- [AI] HTTPS 요청을 위한 wallet과 요청 객체를 설정한다.
   UTL_HTTP.set_wallet(path => 'file:D:\app\Administrator\virtual\product\12.2.0\dbhome_1\data\wallet', password => 'Passw0rd');
   v_request := UTL_HTTP.begin_request(url => 'https://apis.aligo.in/remain/'
                                      ,method =>  'POST'
                                      ,http_version =>  'HTTP/1.1'
                                      ,https_host => 'aligo.in');
   UTL_HTTP.set_header(r => v_request,
                       name => 'Content-Type',
                       value => 'application/x-www-form-urlencoded');
   UTL_HTTP.set_header(r => v_request,
                       name => 'Content-Length',
                       value => v_length);  

   --UTL_HTTP.write_line(r => v_request, data => 'key=89dmul9fej3llmlkayieb3xrxd9g4mqp' || CHR(38));
   --UTL_HTTP.write_line(r => v_request, data => 'user_id=js1025');


   -- [AI] 요청 본문을 전송하고 HTTP 응답을 수신한다.
   UTL_HTTP.write_text(r => v_request, data => v_param);
    
   v_response := UTL_HTTP.get_response(v_request);

   begin
     -- [AI] 응답 본문을 끝까지 읽어 서버 출력 버퍼에 기록한다.
     Loop
       UTL_HTTP.read_line(r => v_response, data => v_text, remove_crlf =>  true);
       Dbms_Output.put_line(v_text);
     End Loop;
   EXCEPTION
   -- [AI] HTTP 응답 본문을 모두 읽으면 내부 블록을 정상 종료한다.
   WHEN UTL_HTTP.end_of_body THEN
     null;
   end;

   -- [AI] HTTP 응답 리소스를 종료한다.
   UTL_HTTP.end_response(r => v_response);

EXCEPTION
   -- [AI] 통신 처리 중 오류를 애플리케이션 오류로 변환한다.
   WHEN OTHERS
   THEN

      raise_application_error (-20100, 'TEST_P_ALIGO_HTTP_REMAIN' || ' ' || SQLERRM);
END;
