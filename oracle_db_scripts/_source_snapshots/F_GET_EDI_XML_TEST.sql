function F_GET_EDI_XML_TEST return clob is
  FunctionResult CLOB;
  l_output_clob CLOB;
  p_xmldata     XMLtype;
  xTest raw(32767); 
begin
    /*xxadm_xml_test에 출하정보 생성*/
    select  xmltype( '<?xml version="1.0" encoding="UTF-8"?>'||chr(13)||'<CustomXML>'||chr(13)||
                       messageheader||  
                       messagebody||'</CustomXML>'
                    )
       into p_xmldata
     from xxadm_xml_test 
     where message_id = 'LG9999999000001'    ; 
     
     l_output_clob := p_xmldata.getClobVal();
     FunctionResult := l_output_clob ;
     --FunctionResult := UTL_RAW.CAST_TO_RAW(l_output_clob);
     xTest := utl_raw.cast_to_raw(c => l_output_clob); 
     
  return(FunctionResult);
end F_GET_EDI_XML_TEST;
