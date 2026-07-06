PROCEDURE "P_INVENTORY_RECEIPT" (
   P_LOCATION_ADDRESS   IN     VARCHAR2,
   P_BARCODE            IN     VARCHAR2,
   P_SUPPLIER_BARCODE   IN     VARCHAR2,
   P_RETURN                OUT VARCHAR2)
IS
   LVS_BARCODE            VARCHAR2 (200);
   lvl_item_qty           NUMBER;
   LVS_ITEM_CODE          VARCHAR2 (30);
   LVS_ITEM_CODE_SUP      VARCHAR2 (30);
   lvs_lot_no             VARCHAR2 (30);
   lvl_first_origin       NUMBER;
   lvl_second_origin      NUMBER;
   LVS_SUPPLIER_BARCODE   VARCHAR2 (50);

   phase                  VARCHAR2 (10);
BEGIN
   -----------------------------------------------------------------------
   --  자사 바코드

   -----------------------------------------------------------------------

   IF SUBSTR (UPPER (P_BARCODE), 1, 1) = '['
   THEN
      LVS_BARCODE :=
            f_get_item_code_from_barcode (P_BARCODE)
         || '-'
         || f_get_lot_no_from_barcode (P_BARCODE)
         || '-'
         || f_get_lot_qty_from_barcode (P_BARCODE);
   ELSE
      LVS_BARCODE := f_get_prepare_barcode (P_BARCODE);
   END IF;

   ----------------------------------------------------------------------------
   --
   ----------------------------------------------------------------------------
   IF LENGTH (LVS_BARCODE) < 8
   THEN
      p_return := f_msg('00 ORIGIN BARCODE INVALID(SUP)','C',1) 
      || LVS_BARCODE;
      RETURN;
   END IF;


   phase := '11';
   --------------------------------------------------------------------------------
   --
   --------------------------------------------------------------------------------
   lvl_first_origin := INSTR (LVS_BARCODE, '-', 1);
   lvl_second_origin := INSTR (LVS_BARCODE, '-', lvl_first_origin + 1);
   phase := '12';

   IF lvl_first_origin <= 0
   THEN
      LVS_ITEM_CODE := TRIM (SUBSTR (LVS_BARCODE, 1, 100));
   ELSE
      LVS_ITEM_CODE := SUBSTR (LVS_BARCODE, 1, lvl_first_origin - 1);
   END IF;


   phase := '13';

   ----------------------------------------------------------------------
   --
   ----------------------------------------------------------------------
   IF lvl_first_origin <= 0 AND lvl_second_origin <= 0
   THEN
      lvs_lot_no := LVS_BARCODE;
   ELSIF lvl_first_origin > 0 AND lvl_second_origin <= 0
   THEN
      BEGIN
         lvs_lot_no :=
            SUBSTR (LVS_BARCODE, INSTR (LVS_BARCODE, '-', 1) + 1, 100);
      EXCEPTION
         WHEN OTHERS
         THEN
            lvs_lot_no :=
               SUBSTR (LVS_BARCODE, INSTR (LVS_BARCODE, '-', 1) + 1, 100);
      END;
   ----------------------------------------------------------------------
   --
   ----------------------------------------------------------------------
   ELSE
      BEGIN
         lvs_lot_no :=
            TO_NUMBER (
               SUBSTR (LVS_BARCODE,
                       INSTR (LVS_BARCODE, '-', 1) + 1,
                       (lvl_second_origin - lvl_first_origin) - 1));
      EXCEPTION
         WHEN OTHERS
         THEN
            lvs_lot_no :=
               SUBSTR (LVS_BARCODE,
                       INSTR (LVS_BARCODE, '-', 1) + 1,
                       (lvl_second_origin - lvl_first_origin) - 1);
      END;
   END IF;


   ----------------------------------------------------------------------------
   --  거래처 바코드

   ----------------------------------------------------------------------------

   IF SUBSTR (UPPER (P_SUPPLIER_BARCODE), 1, 1) = '['
   THEN
      LVS_SUPPLIER_BARCODE :=
            f_get_item_code_from_barcode (P_SUPPLIER_BARCODE)
         || '-'
         || f_get_lot_no_from_barcode (P_SUPPLIER_BARCODE)
         || '-'
         || f_get_lot_qty_from_barcode (P_SUPPLIER_BARCODE);
   -----------------------------------------------------------------------
   --
   -----------------------------------------------------------------------
   ELSE
      LVS_SUPPLIER_BARCODE :=
         f_get_prepare_supplier_barcode (P_SUPPLIER_BARCODE);
   END IF;

   ----------------------------------------------------------------------------
   --
   ----------------------------------------------------------------------------
   IF LENGTH (LVS_SUPPLIER_BARCODE) < 8
   THEN
      p_return := f_msg('00 SUPPLIER BARCODE INVALID(SUP)' ,'C',1) 
      || LVS_SUPPLIER_BARCODE;
      RETURN;
   END IF;

   --------------------------------------------------------------------------------
   -- 거래처 바코드에서 품목 추출
   --------------------------------------------------------------------------------
   lvl_first_origin := INSTR (LVS_SUPPLIER_BARCODE, '-', 1);
   lvl_second_origin :=
      INSTR (LVS_SUPPLIER_BARCODE, '-', lvl_first_origin + 1);
   phase := '12';

   IF lvl_first_origin <= 0
   THEN
      LVS_ITEM_CODE_SUP := TRIM (SUBSTR (LVS_SUPPLIER_BARCODE, 1, 100));
   ELSE
      LVS_ITEM_CODE_SUP :=
         SUBSTR (LVS_SUPPLIER_BARCODE, 1, lvl_first_origin - 1);
   END IF;

   ---------------------------------------------------------------------
   -- 품목 비교
   ---------------------------------------------------------------------
   IF INSTR (LVS_ITEM_CODE, LVS_ITEM_CODE_SUP, 1) = 0
   THEN
      P_RETURN :=
            LVS_ITEM_CODE
         || ' '
         || LVS_ITEM_CODE_SUP
         || f_msg('품목코드가 일치하지 않습니다.','C',1);
      RETURN;
   END IF;

   ---------------------------------------------------------------------
   --
   ---------------------------------------------------------------------

   UPDATE im_item_invenTory
      SET location_address_rack = p_location_address
    WHERE MATERIAL_MFS = LVS_LOT_NO;

   COMMIT;
   p_return := 'OK';                           -- OK 로 PDA 에서 판단 하므로 수정 하면 안됨.
   RETURN;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      P_RETURN :=
         LVS_ITEM_CODE || ' ' || LVS_LOT_NO || f_msg(' 자료가 없습니다','C',1);
      RETURN;
   WHEN OTHERS
   THEN
      P_RETURN := SQLERRM;
      RETURN;
END P_INVENTORY_RECEIPT;