CREATE OR REPLACE PROCEDURE P_SMART_FACTORY_API_LOG_POST  (
  /* ================================================================
   * 프로시저명  : P_SMART_FACTORY_API_LOG_POST
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2022-09-25
   * 수정이력:
   *   2022-09-25 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   스마트공장 API 사용 로그를 외부 API로 POST 전송한다.
   *   인증키, 로그일시, 사용구분, 시스템 사용자, 접속 IP, 데이터 사용량을 form 파라미터로 구성한다.
   *   UTL_HTTP로 응답을 수신하고 처리 결과를 OUT 파라미터로 반환한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_CRTFCKEY (IN, VARCHAR2) - 스마트공장 인증키
   *   P_LOGDT (IN, VARCHAR2) - 로그 일시
   *   P_USESE (IN, VARCHAR2) - 사용 구분
   *   P_SYSUSER (IN, VARCHAR2) - 시스템 사용자
   *   P_CONECTIP (IN, VARCHAR2) - 접속 IP
   *   P_DATAUSGQTY (IN, VARCHAR2) - 데이터 사용량
   *   P_OUT (OUT, VARCHAR2) - API 처리 결과
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   없음 (외부 HTTP API 통신 프로시저)
   * ================================================================
   * [AI 분석] 호출 객체:
   *   UTL_HTTP - 스마트공장 로그 API POST 전송
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN OTHERS/NO_DATA_FOUND 등 원본 예외 처리 흐름을 유지한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 로직 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_SMART_FACTORY_API_LOG_POST('KEY','20260701220000','I','USER','127.0.0.1','1',:P_OUT)
   * ================================================================ */
                                                            p_crtfcKey   IN varchar2, -- [AI] 내부 처리용 변수
                                                            p_logdt      IN varchar2,  -- [AI] 내부 처리용 변수
                                                            p_usese      in varchar2,  -- [AI] 내부 처리용 변수
                                                            p_sysuser    in varchar2,  -- [AI] 내부 처리용 변수
                                                            p_conectip   in varchar2,  -- [AI] 내부 처리용 변수
                                                            p_dataUsgqty in varchar2,  -- [AI] 내부 처리용 변수
                                                            p_out        OUT varchar2 -- [AI] 내부 처리용 변수
                                                         ) is
  
  --PRAGMA AUTONOMOUS_TRANSACTION ; 
  
  lvl_seq number ;  -- [AI] 내부 처리용 변수
  LVL_RESULT number ;  -- [AI] 내부 처리용 변수
  
 -- lvs_result varchar2(8000); 
 
  V_REQ UTL_HTTP.REQ; -- [AI] 내부 처리용 변수
  V_RESP UTL_HTTP.RESP; -- [AI] 내부 처리용 변수
  
  v_text          varchar2(4000) := ''; -- [AI] 내부 처리용 변수
  v_json_query    varchar2(4000) := '';  -- [AI] 내부 처리용 변수
  v_json_templete varchar2(4000) := 'crtfcKey=@1&logDt=@2&useSe=@3&sysUser=@4&conectIp=@5&dataUsgqty=@6'; -- [AI] 내부 처리용 변수
 
  url VARCHAR2(1000)             := 'https://log.smart-factory.kr/apisvc/sendLogData.json'; -- [AI] 내부 처리용 변수
  v_content varchar2(1000)       := 'application/x-www-form-urlencoded; charset="utf-8"';  -- [AI] 내부 처리용 변수
  v_api_key varchar2(100)        := '$5$API$PwbkISAXo.TR1E0pJIbzZ89D3G3kzar7gmjZTFaHCNA'; -- 은성전장 로그 API KEY -- [AI] 내부 처리용 변수
  
begin
   -- [AI] 주요 업무 처리 로직을 시작한다.
    
   --p_out := 'NG';
    v_json_query := replace(v_json_templete,'@1',p_crtfcKey);
    v_json_query := replace(v_json_query,'@2',p_logdt);
    v_json_query := replace(v_json_query,'@3',p_usese);
    v_json_query := replace(v_json_query,'@4',p_sysuser);
    v_json_query := replace(v_json_query,'@5',p_conectip);
    v_json_query := replace(v_json_query,'@6',p_dataUsgqty); 
     

 
  -- UTL_HTTP.set_detailed_excp_support(true); 
    utl_http.set_wallet('file:D:\app\Administrator\virtual\product\12.2.0\dbhome_1\bin\SmartFactory','Passw0rd');
  
    UTL_HTTP.SET_BODY_CHARSET('UTF-8');
    
    V_REQ := utl_http.begin_request(url, 'POST', utl_http.HTTP_VERSION_1_1);
  
    utl_http.set_body_charset(V_REQ, 'UTF-8');
    utl_http.set_header(V_REQ, 'user-agent', 'mozilla/4.0'); 
    utl_http.set_header(V_REQ, 'Content-Type',v_content); 
  
                                
    utl_http.set_header(V_REQ, 'Content-Length', length(v_json_query)); 
                                  
                                              
    UTL_HTTP.WRITE_TEXT ( v_req ,v_json_query )       ;      
  

    V_RESP := UTL_HTTP.GET_RESPONSE(V_REQ);
    

    LOOP
      
        UTL_HTTP.READ_LINE(V_RESP, V_TEXT, TRUE);
            
        --dbms_output.put_line( v_text ) ; 
            
        p_out := v_text ;
            
    END LOOP; 

  

exception 
  
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN UTL_HTTP.END_OF_BODY THEN
     
        dbms_output.put_line('LAST  '||to_char(lvl_result)) ;
        UTL_HTTP.END_RESPONSE(V_RESP);
     
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN others THEN 
     
        ps_job_errorlog(922,1,'P_SMART_FACTORY_API_LOG_POST','PSSS',SUBSTR(SQLERRM,1,200),'FFF');
        p_out      := 'NG' ; 
        dbms_output.put_line('-'||substr(sqlerrm,1,200) ) ;  
        UTL_HTTP.END_RESPONSE(V_RESP);
     
end P_SMART_FACTORY_API_LOG_POST;
