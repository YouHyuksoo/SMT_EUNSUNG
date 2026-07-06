FUNCTION "F_SET_SERIAL" (serial_no varchar2  )
   return integer
as
begin
   dbms_application_info.set_client_info(serial_no);

   return 1;
end f_set_serial;