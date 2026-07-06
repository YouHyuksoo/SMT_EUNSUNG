PROCEDURE "P_INVENTORY_CHECK" (
   p_line_code      IN     VARCHAR2,
   p_item_barcode   IN     VARCHAR2,
   p_err               OUT VARCHAR2)
IS
   lvs_line_code     VARCHAR2 (30);
   lvs_item_code     VARCHAR2 (30);
   lvi_count         NUMBER;
   lvs_our_barcode   VARCHAR2 (100);
BEGIN
   -------------------------------------------------------
   --   P_TYPE : N = NORMAL , C = CANCEL
   --   1 : BARCODE INVALID
   --   2 : ITEM NOT FOUND
   --   3 : DELETE DATA NOT FOUND
   --   9 : SQLERROR
   -------------------------------------------------------
  -- lvs_our_barcode := UPPER (p_item_barcode);


   lvs_our_barcode := f_get_prepare_barcode (p_item_barcode);

   ------------------------------------------------------------------------------


   IF LENGTH (lvs_our_barcode) < 10 or instr( lvs_our_barcode , '@' , 1 ) > 0  or instr( lvs_our_barcode , '---' , 1 ) > 0  OR length (lvs_our_barcode) > 40
   THEN
      p_err :=f_msg( '00 BARCODE INVLIAD' , 'C' , 1 );
      RETURN;
   END IF;


   --------------------------------------------------------
   --
   --------------------------------------------------------

   lvs_item_code :=    f_get_item_code_from_barcode(lvs_our_barcode) ;  -- SUBSTR (lvs_our_barcode, 1, INSTR (lvs_our_barcode, '-', 7) - 1);

   IF lvs_item_code = '' OR LENGTH (lvs_item_code) <> 11
   THEN
      lvs_item_code :=
         SUBSTR (lvs_our_barcode, 1, INSTR (lvs_our_barcode, '+', 1) - 1);

      IF lvs_item_code = '' OR LENGTH (lvs_item_code) <> 11
      THEN
         lvs_item_code := SUBSTR (lvs_our_barcode, 1, 11);
      END IF;
   END IF;

-------------------------------------------------------------
--  폼목 코드 체크
-------------------------------------------------------------
   BEGIN
      SELECT COUNT (*)
        INTO lvi_count
        FROM id_item
       WHERE item_code = lvs_item_code;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_err := f_msg('02 ITEM NOT FOUND' , 'C' , 1 ) ;
         RETURN;
   END;

   IF NVL (lvi_count, 0) < 1
   THEN
      p_err :=f_msg( '02 ITEM NOT FOUND' , 'C' ,1 ) ;
      RETURN;
   END IF;

   BEGIN
      SELECT COUNT (*)
        INTO lvi_count
        FROM im_item_inventory_check_bcd
       WHERE item_barcode = lvs_our_barcode;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvi_count := 0;
   END;

   IF NVL (lvi_count, 0) > 0
   THEN
      p_err :=f_msg( '03 AREADY EXITS' , 'C' , 1 ) ;
      RETURN;
   END IF;

   INSERT INTO im_item_inventory_check_bcd (check_yyyymm,
                                            line_code,
                                            item_barcode,
                                            item_code,
                                            lot_no,
                                            enter_by,
                                            enter_date,
                                            last_modify_by,
                                            last_modify_date,
                                            organization_id)
   VALUES (TO_CHAR (SYSDATE, 'yyyymm'),
           SUBSTR (p_line_code, 1, 2),
           p_item_barcode,
           NVL (lvs_item_code, p_item_barcode),
           f_get_lot_no_from_barcode (p_item_barcode),
           'SYSTEM',
           SYSDATE,
           'SYSTEM',
           SYSDATE,
           1);

   COMMIT;
   p_err := '';
   RETURN;
EXCEPTION
   WHEN OTHERS
   THEN
      p_err :=
            p_line_code
         || ' '
         || p_item_barcode
         || ' '
         || SUBSTR (SQLERRM, 1, 100);
      RETURN;
END;