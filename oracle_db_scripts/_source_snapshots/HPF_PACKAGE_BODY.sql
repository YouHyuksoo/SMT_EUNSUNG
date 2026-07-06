PACKAGE BODY "HPF" as

   procedure xml_header is

   begin

      owa_util.mime_header('text/xml',false);

      htp.print('Cache-Control: no-cache');

      owa_util.http_header_close;

--      htp.print('<?xml version="1.0" encoding="'||lower(owa_util.get_cgi_env('REQUEST_IANA_CHARSET'))||'"?>');
      htp.print('<?xml version="1.0" encoding="'||'utf-8'||'"?>');

      htp.print('<root>');

      g_error_found := false;

   end;

   procedure xml_footer is

   begin

      htp.print('</root>');

      commit;

   end;

   procedure xml_begin_tag (

      p_tag_name in varchar2

   ) is

   begin

      htp.print('<'||p_tag_name||'>');

   end;

   procedure xml_end_tag (

      p_tag_name in varchar2

   ) is

   begin

      htp.print('</'||p_tag_name||'>');

   end;

   procedure xml_print_element (

      p_element_name  in varchar2,
      p_element_value in varchar2

   ) is

   begin

      htp.print('<'||p_element_name||'>'||utl_i18n.escape_reference(p_element_value)||'</'||p_element_name||'>');

   end;

   procedure xml_message (

      p_message_text in varchar2

   ) is

   begin

      hpf.xml_print_element('message_text',p_message_text);

   end;

   procedure xml_error (

      p_error_text in varchar2

   ) is

   begin

      hpf.xml_print_element('error_text',p_error_text);

      g_error_found := true;

   end;

   procedure xml_exception is

      l_exception_text varchar2(2048);
      l_call_stack     varchar2(1024);
      l_error_stack    varchar2(1024);

   begin

      l_call_stack  := replace(dbms_utility.format_call_stack,'----- PL/SQL Call Stack -----','Call Stack:'||chr(10));

      l_error_stack := 'Error Stack:'||chr(10)||chr(10)||dbms_utility.format_error_stack||dbms_utility.format_error_backtrace;

      l_exception_text := l_call_stack||chr(10)||l_error_stack;

      rollback;

      htp.init;

      hpf.xml_header;

      hpf.xml_print_element('exception_text',l_exception_text);

      hpf.xml_footer;

   end;

end;