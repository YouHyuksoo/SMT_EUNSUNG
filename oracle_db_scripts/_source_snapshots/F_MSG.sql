FUNCTION "F_MSG" (p_message varchar2, p_lang varchar2, p_org number ) return varchar2 is
  /*******************************************************/
  /*P_MESSAGE, P_LANG, P_ORG                             */
  /* 2017.03.27 추가 PDA 에서 호출하는 Procedure Multi Lang 처리*/
  /*******************************************************/
  
  pragma autonomous_transaction ; 
  lvs_return varchar2(4000);
  lvs_msg    varchar2(4000); 
begin
  
  begin 
    select decode( p_lang , 'K' , msg_kor , 'E' , msg_eng , 'C', msg_chn, lvs_msg )
      into lvs_msg
      from isys_dual_message_direct
     where origin_msg      = p_message
       and organization_id = nvl(p_org,1)  ;
     
     lvs_return := nvl(lvs_msg,p_message) ; 
      
  exception 
    when no_data_found then
         
      begin 
        insert into isys_dual_message_direct ( 
               origin_msg , 
               enter_date , 
               enter_by , 
               last_modify_date , 
               last_moDiFy_by , 
               organization_id 
        ) 
        values ( 
               p_message , 
               sysdate , 
               'F_MSG' , 
               sysdate , 
               'F_MSG' , 
               nvl(p_org,1) 
        ) ;
        
        commit ; 
        lvs_return := p_message ; 
        
      exception 
        when others then 
          rollback ; 
          lvs_return := p_message ; 
      end ; 
         
  end ; 
  
  return lvs_return  ; 
   
end F_MSG;