FUNCTION "F_GET_MAGAZINE_PID_CUR" (
                                                  p_line_code      IN VARCHAR2,
                                                  p_workstage_code IN VARCHAR2,
                                                  p_machine_code   IN VARCHAR2
                                                  )
RETURN sys_refcursor
IS
  o_cursor sys_refcursor;

BEGIN


  -- 20161223 SHS, ？？？？？？？ ？？？？？？ ？？？ ？？？ ？？？？？ run model ？？？？ ？？？？ ？？ ？？？？ ？？？ 30？？ ？？？ magazine pid list？？ ？？？？？

  OPEN o_cursor FOR
       select magazine_no, serial_no, sysdate
         from ip_product_2d_barcode
         where magazine_no in (
                            select magazine_no
                              from iq_interlock_check_result
                             where line_code      = p_line_code
                           --    and machine_code   = 'YSS-G-141'
                               and F_GET_WORKSTAGE_TYPE( WORKSTAGE_CODE )  =  'MAGAZINE' 
                               and receipt_date in (
                                                    select max(receipt_date)
                                                      from iq_interlock_check_result
                                                     where receipt_date   >= sysdate - (0.5/24)
                                                       and line_code      = p_line_code
                                                       and machine_code   = p_machine_code
                                                       and workstage_code = p_workstage_code
                                                       and  magazine_no <> '*'
                                                   )
                              and rownum = 1
                          )
        and model_name = (
                    select model_name
                      from ip_product_run_model
                     where line_code      = p_line_code
                       and workstage_code = p_workstage_code
                   );

  RETURN o_cursor;

END;