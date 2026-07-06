FUNCTION "F_GET_MAGAZINE_INFO" (p_pid    IN VARCHAR2,
                                                p_option IN VARCHAR2)
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
                    and work_order = f_get_run_no_info(p_pid, 'WO');

              EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                      lvs_charge_qty := '0';
              END;

              lvs_return := lvs_charge_qty;

         WHEN 'HLDS LAST LOT NO'   THEN

              BEGIN

                 select trim(to_char(SEQ_MAGAZINE_HLDS.NEXTVAL, '0000'))
                   into lvs_lot_no_count
                   from dual;

              EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                      lvs_lot_no_count := '0000';
              END;

              lvs_return := lvs_lot_no_count;

         ELSE
              lvs_return := 'ERROR';

    END CASE;

    RETURN lvs_return;

EXCEPTION

    WHEN OTHERS THEN
         RETURN 'ERROR';

END;