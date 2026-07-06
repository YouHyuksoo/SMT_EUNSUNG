CREATE OR REPLACE PROCEDURE "TEST_P_EDI_HTTPS_SEND" (
  /* ================================================================
   * 프로시저명  : TEST_P_EDI_HTTPS_SEND
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-12-03
   * 수정이력:
   *   2020-12-03 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   외부 연계 또는 HTTP 통신 데이터를 처리한다.
   *   요청/응답 메시지와 처리 결과를 원본 로직 기준으로 생성하거나 기록한다.
   *   통신 오류와 예외 처리는 원본 EXCEPTION 흐름을 그대로 유지한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_URL - 원본 선언부 기준 입력/출력 파라미터
   *   P_FILE - 원본 선언부 기준 입력/출력 파라미터
   *   P_HOST - 원본 선언부 기준 입력/출력 파라미터
   *   P_DEBUG - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   없음 (순수 연산/외부 처리 프로시저)
   * ================================================================
   * [AI 분석] 호출 객체:
   *   FCLOSE
   *   FGETATTR
   *   FOPEN
   *   F_GET_EDI_XML_TEST
   *   PUT_LINE
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC TEST_P_EDI_HTTPS_SEND(...)
   * ================================================================ */
   --p_url                  IN VARCHAR2,
   --p_file                 IN VARCHAR2,
   p_host                   IN VARCHAR2,
   p_debug                  IN VARCHAR2 DEFAULT 'N'
)
AS
lvs_detal_err varchar2(5000) ; -- [AI] 내부 처리용 변수
phase varchar2(10) ; -- [AI] 내부 처리용 변수
   v_request   UTL_HTTP.req; -- [AI] 내부 처리용 변수
   v_response  UTL_HTTP.resp; -- [AI] 내부 처리용 변수

   v_text      varchar2(5000) := ''; -- [AI] 내부 처리용 변수
   -- v_param     varchar2(4000) := '';
   v_length    number := 0; -- [AI] 내부 처리용 변수
   
   -- v_data      varchar2(32767) := '';
   MAX_AMOUNT  CONSTANT PLS_INTEGER := 32767; -- [AI] 내부 처리용 변수
   
   v_fh     UTL_FILE.FILE_TYPE; -- [AI] 내부 처리용 변수
   v_f_exist   BOOLEAN := false; -- [AI] 내부 처리용 변수
   v_f_length  NUMBER  := 0; -- [AI] 내부 처리용 변수
   v_f_block    BINARY_INTEGER  := 0;   -- [AI] 내부 처리용 변수
   
   v_buf        RAW(32767); -- [AI] 내부 처리용 변수
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
  
  /******************************** 
     임시 
     F_GET_EDI_XML_TEST return clob 
     raw := utl_raw.cast_to_raw(F_GET_EDI_XML_TEST())
  *********************************/
Dbms_Output.put_line('0.START ');  
  begin
    UTL_FILE.fgetattr('EDI_DOC'
                      ,'SAMPLE_xml_for_MARKONE_EDI_SYSTEM_CHECKING_20201203.xml'          --p_file
                      ,v_f_exist, v_f_length, v_f_block);
    if v_f_exist = false or v_f_length = 0 then
      return;
    end if;  
    
    v_fh := UTL_FILE.fopen('EDI_DOC'
                           ,'SAMPLE_xml_for_MARKONE_EDI_SYSTEM_CHECKING_20201203.xml'          --p_file
                           , 'rb', MAX_AMOUNT);
    UTL_FILE.get_raw(v_fh, v_buf, MAX_AMOUNT);
    UTL_FILE.fclose(v_fh);
  Exception
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS
   THEN
    Dbms_Output.put_line(SQLERRM);
    return;
  end;


Dbms_Output.put_line('1.START ');  
   
   --byte length
   v_length := UTL_RAW.length(v_buf);
  
phase :='10' ;  
   -- need wallet to use https protocol
   --UTL_HTTP.set_transfer_timeout(90);
   UTL_HTTP.set_detailed_excp_support(true);
phase :='20' ;   
   UTL_HTTP.set_wallet(path => 'file:D:\app\Administrator\virtual\product\12.2.0\dbhome_1\data\wallet2', password => 'Passw0rd');
phase :='30' ;
   v_request := UTL_HTTP.begin_request(url => 'https://165.243.115.36:4443/invoke/LGEB2Bi_TRP.listeners/commonListener' --p_url
                                      ,method =>  'POST'
                                      ,http_version =>  UTL_HTTP.HTTP_VERSION_1_1
                                      ,https_host => p_host                  -- 'lgekrb2bi.lge.com'                                                          
                                      );

Dbms_Output.put_line('2.REQUEST ');
/*   v_request := UTL_HTTP.begin_request(url => p_url
                                      ,method =>  'POST'
                                      ,http_version =>  'HTTP/1.1');*/
  phase :='40' ;
   UTL_HTTP.set_header(r => v_request,
                       name => 'Content-Type',
                       value => 'text/xml');

   UTL_HTTP.SET_BODY_CHARSET('UTF-8');
   

   UTL_HTTP.set_header(r => v_request,
                       name => 'Content-Length',
                       value => v_length);

   UTL_HTTP.WRITE_RAW (r    => v_request,
                       data => v_buf);
 
Dbms_Output.put_line('3.WRITE_RAW ');

 --  UTL_HTTP.write_text(r => v_request, data => v_param);

   v_response := UTL_HTTP.get_response(v_request);

Dbms_Output.put_line('4.RESPONSE ');

   begin
     Loop
       UTL_HTTP.read_line(r => v_response, data => v_text, remove_crlf =>  true);
       Dbms_Output.put_line(v_text);
     End Loop;
   EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN UTL_HTTP.end_of_body THEN
     null;
   end;

   UTL_HTTP.end_response(r => v_response);

EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN UTL_HTTP.protocol_error then
     Dbms_Output.put_line('protocol_error ' || SQLERRM);
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN UTL_HTTP.bad_argument then
     Dbms_Output.put_line('bad_argument ' || SQLERRM);
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN UTL_HTTP.bad_url then
     Dbms_Output.put_line('bad_url ' || SQLERRM);
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN UTL_HTTP.end_of_body then
     Dbms_Output.put_line('end_of_body ' || SQLERRM);
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN UTL_HTTP.header_not_found then
     Dbms_Output.put_line('header_not_found ' || SQLERRM); 
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN UTL_HTTP.network_access_denied then
     Dbms_Output.put_line('network_access_denied ' || SQLERRM);  
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN UTL_HTTP.illegal_call then
     Dbms_Output.put_line('illegal_call ' || SQLERRM);
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN UTL_HTTP.request_failed then
     Dbms_Output.put_line('request_failed ' || SQLERRM);     
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN UTL_HTTP.transfer_timeout then
     Dbms_Output.put_line('transfer_timeout ' || SQLERRM);      
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN UTL_HTTP.unknown_scheme then
     Dbms_Output.put_line('unknown_scheme ' || SQLERRM);                   
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS
   THEN
   
      select  utl_http.get_detailed_sqlerrm into lvs_detal_err from dual ;
      Dbms_Output.put_line('others ' || SQLERRM);     
      raise_application_error (-20100, to_char(sysdate , 'yymmdd hh24:mi:ss')||' '||phase||'=> TEST_P_EDI_HTTPS_SEND' || ' ' || SQLERRM||' Detail :'||lvs_detal_err);
END;
