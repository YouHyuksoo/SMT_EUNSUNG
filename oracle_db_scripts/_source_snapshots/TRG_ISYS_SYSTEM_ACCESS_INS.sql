trigger trg_isys_system_access_ins
  before insert
  on ISYS_SYSTEM_ACCESS 
  for each row
declare
  -- local variables here
  lvs_out varchar2(200);
  
begin
  

  if :new.system_access_type IN ( 'LOGON','LOGOFF') then  
    
 
       -- API 전송 
       
   

       P_SMART_FACTORY_API_LOG_POST('$5$API$PwbkISAXo.TR1E0pJIbzZ89D3G3kzar7gmjZTFaHCNA',                      -- 은성전장 로그 API KEY
                                    to_char(systimestamp,'yyyy-mm-dd hh24:mi:ss.ff3'), 
                                    :new.system_access_type, 
                                    :new.access_by,
                                    :NEW.IP_ADDRESS,
                                    '0',
                                    lvs_out);
      --                         

      insert into smart_factory_use_log_if ( 
                                             crtfckey, 
                                             logdt_date, 
                                             logdt, 
                                             usese, 
                                             sysuser, 
                                             conectip, 
                                             datausgqty, 
                                             api_message,
                                             transfer_flag, 
                                             transfer_date
                                           ) 
                                    values ( 
                                             '$5$API$PwbkISAXo.TR1E0pJIbzZ89D3G3kzar7gmjZTFaHCNA',              -- 은성전장 로그 API KEY
                                             to_char(:new.access_date,'yyyy-mm-dd hh24:mi:ss')||'.000', 
                                             to_char(systimestamp,'yyyy-mm-dd hh24:mi:ss.ff3'), 
                                             decode(:new.system_access_type,'LOGON','접속','LOGOFF','종료'), 
                                             :new.access_by, 
                                             :NEW.IP_ADDRESS, 
                                             '0', 
                                             lvs_out, 
                                             'Y', 
                                             sysdate 
                                          ) ;
       
 
       
   end if ;
   
   
exception 
  
  when others then 
       null ; 
    
end trg_isys_system_access_ins;
