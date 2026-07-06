PROCEDURE "TEST_P_EDI_HTTP_SEND" (
   p_url                    IN VARCHAR2,
   p_file                   IN VARCHAR2,
   p_debug                  IN VARCHAR2 DEFAULT 'N'
)
AS
lvs_detal_err varchar2(5000) ;
phase varchar2(10) ;
   v_request   UTL_HTTP.req;
   v_response  UTL_HTTP.resp;

   v_text      varchar2(5000) := '';
   -- v_param     varchar2(4000) := '';
   v_length    number := 0;
   
   -- v_data      varchar2(32767) := '';
   MAX_AMOUNT  CONSTANT PLS_INTEGER := 32767;
   
   v_fh     UTL_FILE.FILE_TYPE;
   v_f_exist   BOOLEAN := false;
   v_f_length  NUMBER  := 0;
   v_f_block    BINARY_INTEGER  := 0;  
   
   v_buf        RAW(32767);
BEGIN
  
  /******************************** 
     임시 
     F_GET_EDI_XML_TEST return clob 
     raw := utl_raw.cast_to_raw(F_GET_EDI_XML_TEST())
  *********************************/
Dbms_Output.put_line('0.START ');  
  begin
    UTL_FILE.fgetattr('EDI_DIR'
                      ,p_file
                      ,v_f_exist, v_f_length, v_f_block);
    if v_f_exist = false or v_f_length = 0 then
      return;
    end if;  
    
    v_fh := UTL_FILE.fopen('EDI_DIR'
                           , p_file
                           , 'rb', MAX_AMOUNT);
    UTL_FILE.get_raw(v_fh, v_buf, MAX_AMOUNT);
    UTL_FILE.fclose(v_fh);
  Exception
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
   --UTL_HTTP.set_wallet(path => 'file:D:\app\Administrator\virtual\product\12.2.0\dbhome_1\data\wallet2', password => 'Passw0rd');
phase :='30' ;
   v_request := UTL_HTTP.begin_request(url => p_url
                                      ,method =>  'POST'
                                      ,http_version =>  UTL_HTTP.HTTP_VERSION_1_1                                                       
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
   WHEN UTL_HTTP.end_of_body THEN
     null;
   end;

   UTL_HTTP.end_response(r => v_response);

EXCEPTION
   WHEN UTL_HTTP.protocol_error then
     Dbms_Output.put_line('protocol_error ' || SQLERRM);
   WHEN UTL_HTTP.bad_argument then
     Dbms_Output.put_line('bad_argument ' || SQLERRM);
   WHEN UTL_HTTP.bad_url then
     Dbms_Output.put_line('bad_url ' || SQLERRM);
   WHEN UTL_HTTP.end_of_body then
     Dbms_Output.put_line('end_of_body ' || SQLERRM);
   WHEN UTL_HTTP.header_not_found then
     Dbms_Output.put_line('header_not_found ' || SQLERRM); 
   WHEN UTL_HTTP.network_access_denied then
     Dbms_Output.put_line('network_access_denied ' || SQLERRM);  
   WHEN UTL_HTTP.illegal_call then
     Dbms_Output.put_line('illegal_call ' || SQLERRM);
   WHEN UTL_HTTP.request_failed then
     Dbms_Output.put_line('request_failed ' || SQLERRM);     
   WHEN UTL_HTTP.transfer_timeout then
     Dbms_Output.put_line('transfer_timeout ' || SQLERRM);      
   WHEN UTL_HTTP.unknown_scheme then
     Dbms_Output.put_line('unknown_scheme ' || SQLERRM);                   
   WHEN OTHERS
   THEN
   
      select  utl_http.get_detailed_sqlerrm into lvs_detal_err from dual ;
      Dbms_Output.put_line('others ' || SQLERRM);     
      raise_application_error (-20100, to_char(sysdate , 'yymmdd hh24:mi:ss')||' '||phase||'=> TEST_P_EDI_HTTP_SEND' || ' ' || SQLERRM||' Detail :'||lvs_detal_err);
END;
