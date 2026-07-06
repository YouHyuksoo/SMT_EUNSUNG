PACKAGE "HPF" as

   g_error_found boolean;

   procedure xml_header;

   procedure xml_footer;

   procedure xml_begin_tag (

      p_tag_name in varchar2

   );

   procedure xml_end_tag (

      p_tag_name in varchar2

   );

   procedure xml_print_element (

      p_element_name  in varchar2,
      p_element_value in varchar2

   );

   procedure xml_message (

      p_message_text in varchar2

   );

   procedure xml_error (

      p_error_text in varchar2

   );

   procedure xml_exception;

end;