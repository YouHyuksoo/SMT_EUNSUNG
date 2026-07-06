PROCEDURE "P_INVENTORY_CHECK_QTY" (
   p_line_code      IN     VARCHAR2,
   p_item_barcode   IN     VARCHAR2,
   p_qty            IN     VARCHAR2,
   p_err               OUT VARCHAR2)
IS
   lvs_line_code          VARCHAR2 (30);
   lvs_item_code          VARCHAR2 (30);
   lvs_lot_no             VARCHAR2 (100);
   lvi_count              NUMBER;
   lvs_our_barcode        VARCHAR2 (100);
   lvl_barcode_qty        NUMBER;
   lvi_scan_qty           NUMBER;
   lvs_location_address   VARCHAR2 (20);
BEGIN
   -------------------------------------------------------
   --   P_TYPE : N = NORMAL , C = CANCEL
   --   1 : BARCODE INVALID
   --   2 : ITEM NOT FOUND
   --   3 : DELETE DATA NOT FOUND
   --   9 : SQLERROR
   -------------------------------------------------------
   lvs_our_barcode := UPPER (p_item_barcode);

   lvs_item_code := UPPER (TRIM(SUBSTR (lvs_our_barcode, 1, INSTR (lvs_our_barcode, '-',7 ) -1)));


   lvs_lot_no :=
      UPPER (
         SUBSTR (lvs_our_barcode, INSTR (lvs_our_barcode, '-', 7) + 1, 100));


   IF lvs_lot_no = '' OR lvs_lot_no IS NULL
   THEN
      p_err := '바코드형식이 틀립니다.';
      RETURN;
   END IF;

   -------------------------------
   -- 사용자 지정 수량이 있으면
   -------------------------------
   IF NVL (p_qty, 0) > 0
   THEN
      lvl_barcode_qty := TO_NUMBER (p_qty);
   ELSE
      p_err := '수량을 입력하세요.';
      RETURN;
   END IF;

   -------------------------------------------------------------------------------------
   -- 품목존재 여부 체크
   -------------------------------------------------------------------------------------

   BEGIN
      SELECT COUNT (*), MAX (location_address)
        INTO lvi_count, lvs_location_address
        FROM id_item
       WHERE item_code = lvs_item_code
       GROUP BY ITEM_CODE;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_err := lvs_item_code||' : 품목정보를 찾을수 없습니다'||SQLERRM;
         RETURN;
   END;

   IF NVL(lvi_count,0) < 1
   THEN
      p_err := lvs_item_code||f_msg( ' : 품목정보를 찾을수 없습니다.' , 'C' , 1 ) ;
      RETURN;
   END IF;

   BEGIN
      SELECT COUNT (*)
        INTO lvi_count
        FROM im_item_inventory_check_bcd
       WHERE lot_no = lvs_lot_no;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvi_count := 0;
   END;

   IF NVL (lvi_count, 0) > 0
   THEN
      p_err := lvs_lot_no||f_msg(' : 이미존재 합니다.' ,'C' , 1 ) ;
      RETURN;
   END IF;

   --------------------------------------------------------
   --  barcode_qty 가 0 이면 트리거에서
   --  RECEIPT BARCODE 에서 scan_qty 수량을 가져와서 넣어줌
   --  여기서 넣어주면 안가져오고 여기서 넣은 수량으로 등록
   --------------------------------------------------------

   INSERT INTO im_item_inventory_check_bcd (check_yyyymm,
                                            line_code,
                                            item_barcode,
                                            item_code,
                                            enter_by,
                                            enter_date,
                                            last_modify_by,
                                            last_modify_date,
                                            barcode_qty,
                                            inventory_qty,
                                            organization_id,
                                            check_type,
                                            location_address)
   VALUES (TO_CHAR (SYSDATE, 'yyyymm'),
           UPPER (p_line_code),
           p_item_barcode,
           NVL (lvs_item_code, p_item_barcode),
           'PDA',
           SYSDATE,
           'SYSTEM',
           SYSDATE,
           NVL (lvl_barcode_qty, 0),
           0,
           1,
           'M',
           lvs_location_address);                               --MOVING CHECK

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