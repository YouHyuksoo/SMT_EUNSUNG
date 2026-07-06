procedure P_SMART_FACTORY_API_LOG_POST  (
                                                            p_crtfcKey   IN varchar2,
                                                            p_logdt      IN varchar2, 
                                                            p_usese      in varchar2, 
                                                            p_sysuser    in varchar2, 
                                                            p_conectip   in varchar2, 
                                                            p_dataUsgqty in varchar2, 
                                                            p_out        OUT varchar2
                                                         ) is
  
  --PRAGMA AUTONOMOUS_TRANSACTION ; 
  
  lvl_seq number ; 
  LVL_RESULT number ; 
  
 -- lvs_result varchar2(8000); 
 
  V_REQ UTL_HTTP.REQ;
  V_RESP UTL_HTTP.RESP;
  
  v_text          varchar2(4000) := '';
  v_json_query    varchar2(4000) := ''; 
  v_json_templete varchar2(4000) := 'crtfcKey=@1&logDt=@2&useSe=@3&sysUser=@4&conectIp=@5&dataUsgqty=@6';
 
  url VARCHAR2(1000)             := 'https://log.smart-factory.kr/apisvc/sendLogData.json';
  v_content varchar2(1000)       := 'application/x-www-form-urlencoded; charset="utf-8"'; 
  v_api_key varchar2(100)        := '$5$API$PwbkISAXo.TR1E0pJIbzZ89D3G3kzar7gmjZTFaHCNA'; -- 은성전장 로그 API KEY
  
begin
    
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
  
   WHEN UTL_HTTP.END_OF_BODY THEN
     
        dbms_output.put_line('LAST  '||to_char(lvl_result)) ;
        UTL_HTTP.END_RESPONSE(V_RESP);
     
   WHEN others THEN 
     
        ps_job_errorlog(922,1,'P_SMART_FACTORY_API_LOG_POST','PSSS',SUBSTR(SQLERRM,1,200),'FFF');
        p_out      := 'NG' ; 
        dbms_output.put_line('-'||substr(sqlerrm,1,200) ) ;  
        UTL_HTTP.END_RESPONSE(V_RESP);
     
end P_SMART_FACTORY_API_LOG_POST;
