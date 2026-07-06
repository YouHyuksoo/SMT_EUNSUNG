FUNCTION "F_GET_MAGAZINE_INFO_NEW" (p_pid         IN VARCHAR2,
                                                    p_line_code   IN VARCHAR2,
                                                    p_option      IN VARCHAR2)
    RETURN VARCHAR2
IS
    lvs_return        VARCHAR2 (100);

    lvs_charge_qty    VARCHAR2 (100);
    lvs_lot_no_count  VARCHAR2 (100);

BEGIN

   CASE p_option

         WHEN 'LGEIVI LAST CHARGE QTY'  THEN

              BEGIN

                 select TO_CHAR(NVL(MAX(charge_qty),0))
                   into lvs_charge_qty
                   from ip_product_magazine_his
                  where customer_code = 'LGIVI'
                    and line_code     = p_line_code
                    and work_order    = f_get_run_no_info(p_pid, 'WO');

              EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                      lvs_charge_qty := '0';
              END;

              lvs_return := lvs_charge_qty;

         WHEN 'HLDS LAST LOT NO'   THEN

              IF (p_line_code = 'VC') THEN

                  BEGIN

                    -- select trim(to_char(SEQ_MAGAZINE_HLDS.NEXTVAL, '0000'))
                    --  into lvs_lot_no_count
                    --  from dual;

                     select trim(to_char(to_number(nvl(max(lot_no_count),0))+1, '0000'))
                       into lvs_lot_no_count
                       from ip_product_magazine_his
                      where line_code     =  p_line_code
                        and customer_code =  'HLDS'
                        and print_date    >= trunc(sysdate)
                        and part_no = (
                                        select part_no
                                          from ip_product_2d_barcode
                                         where serial_no = p_pid
                                      );

                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                          lvs_lot_no_count := '0001';
                  END;

              ELSE

                  BEGIN

                     select to_char(sysdate, 'YYYY-MM-DD HH24:MI')
                       into lvs_lot_no_count
                       from dual;

                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                          lvs_lot_no_count := to_char(sysdate, 'YYYY-MM-DD HH24:MI');
                  END;

              END IF;

              lvs_return := lvs_lot_no_count;

         ELSE
              lvs_return := 'ERROR';

    END CASE;

    RETURN lvs_return;

EXCEPTION

    WHEN OTHERS THEN
         RETURN 'ERROR';

END;