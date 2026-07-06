CREATE OR REPLACE procedure XXADM_TEST
  /* ================================================================
   * 프로시저명  : XXADM_TEST
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2021-01-13
   * 수정이력:
   *   2021-01-13 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   UTL_HTTP를 사용해 외부 HTTPS EDI 테스트 URL로 POST 요청을 보내는 테스트 프로시저이다.
   *   상세 예외 지원과 wallet 설정을 적용한 뒤 요청을 생성하고 응답 상태를 DBMS_OUTPUT에 출력한다.
   *   요청 생성 또는 전체 처리 중 발생한 오류도 DBMS_OUTPUT으로 기록한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   없음
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   없음 (외부 HTTP 통신 테스트 프로시저)
   * ================================================================
   * [AI 분석] 호출 객체:
   *   UTL_HTTP - HTTPS 요청 생성, 응답 수신, 응답 본문 읽기, 응답 종료 처리
   *   DBMS_OUTPUT - 처리 로그 출력
   * ================================================================
   * [AI 분석] 예외 처리:
   *   내부 WHEN OTHERS - 요청 생성 오류를 DBMS_OUTPUT에 출력
   *   외부 WHEN OTHERS - 전체 처리 오류를 DBMS_OUTPUT에 출력
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 없음
   *   DML: 없음
   * ================================================================
   * 사용 예시:
   *   EXEC XXADM_TEST
   * ================================================================ */
as

  v_req UTL_HTTP.req; -- [AI] HTTP 요청 핸들
  

  v_resp  UTL_HTTP.resp; -- [AI] HTTP 응답 핸들

  t_response_text VARCHAR2 (2000); -- [AI] 응답 본문 일부를 담는 문자열 변수

begin

   
   -- [AI] HTTP 상세 예외와 wallet 경로를 설정한다.
   UTL_HTTP.set_detailed_excp_support(true); 
   utl_http.set_wallet(path => 'file:D:\app\Administrator\virtual\product\12.2.0\dbhome_1\data\wallet2', password => 'Passw0rd');
   
   -- [AI] 외부 HTTPS 테스트 URL로 POST 요청을 생성한다.
   begin 
   v_req:= utl_http.begin_request('https://165.243.115.36:4443/invoke/LGEB2Bi_TRP.listeners/commonListener?','POST','HTTP/1.1');
   --v_req:= UTL_HTTP.request(url => 'https://165.243.115.36:4443/invoke/LGEB2Bi_TRP.listeners/commonListener',
   --                 wallet_path => 'file:D:\app\Administrator\virtual\product\12.2.0\dbhome_1\data\wallet2',
   --                 wallet_password =>  'Passw0rd')
   exception 
     -- [AI] 요청 생성 실패 메시지를 출력한다.
     when others then
       dbms_output.put_line('Request -> '||sqlerrm); 
       
   end ; 
   
   
   
   --v_req:= utl_http.begin_request('https://google.com','POST','HTTP/1.1');
   -- [AI] 생성된 요청 정보를 출력하고 응답을 수신한다.
   dbms_output.put_line('Resonse -> 1'||v_req.url||v_req.method); 
       
   v_resp:= utl_http.get_response(v_req);
   dbms_output.put_line('Resonse -> 2'); 
   UTL_HTTP.read_text(v_resp, t_response_text);
   
   DBMS_OUTPUT.put_line('Response> status_code: "' || v_resp.status_code || '"');

   -- [AI] HTTP 응답 리소스를 종료한다.
   utl_http.end_response(v_resp);
exception 
  -- [AI] 전체 처리 중 발생한 오류 메시지를 출력한다.
  when others then 
    dbms_output.put_line(sqlerrm);
end;
