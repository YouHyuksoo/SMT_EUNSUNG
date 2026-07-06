PROCEDURE "P_CHECK_PRODUCT_RECEIPT" (
   P_BARCODE   IN     VARCHAR2,
   P_DEFICIT   IN     VARCHAR2,
   P_OUT          OUT VARCHAR2,
   P_MSG          OUT VARCHAR2)
IS
    LVI_BARCODE           VARCHAR2 (500);

   LVI_COUNT              NUMBER;
   LVI_POWER_CHECK        NUMBER;
   LVI_VERIFY_CHECK       NUMBER;
   LVS_NO_POWER_SERIAL    VARCHAR2 (500);
   LVS_NO_VERIFY_SERIAL   VARCHAR2 (500);
BEGIN

    -- magazine row label에 대한 magazine no을 돌려준다 (IVI 자리 그외는 12자리)
    -- 2016/05/12 SHS

    BEGIN
         SELECT f_get_magazine_barcode(P_BARCODE)
           INTO LVI_BARCODE
           FROM DUAL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            LVI_BARCODE := P_BARCODE;

      END;
    ----------------------------------------------------------------------------

   IF P_DEFICIT = 'N'
   THEN

      BEGIN -- 2016/06/09 SHS, MAGAZIN 미 구성 품에 대해 error 처리
         SELECT COUNT (*)
           INTO LVI_COUNT
           FROM IP_PRODUCT_2D_BARCODE
          WHERE MAGAZINE_NO = LVI_BARCODE;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            P_OUT := 'NG';
      END;

      IF NVL (LVI_COUNT, 0) = 0
      THEN
         P_OUT := 'NG';
         P_MSG := LVI_BARCODE||f_msg(' : PID Mapping Info Notfound.','C',1);
        -- P_MSG := LVI_BARCODE||' : 매거진 라벨에 매핑된 PID가 없습니다.';

   -- test shs
   --        insert into shs_temp (a, enter_date, enter_by)
   --        select 'R >'||P_BARCODE||', '||'M >'||LVI_BARCODE,
   --               sysdate,
   --               'P_CHECK_PRODUCT_RECEIPT'
   --          from dual;
   --        commit;

         RETURN;
      END IF;


      BEGIN
         SELECT COUNT (*)
           INTO LVI_COUNT
           FROM IP_PRODUCT_2D_BARCODE
          WHERE MAGAZINE_NO = LVI_BARCODE AND SHIPPING_DEFICIT = '1';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            P_OUT := 'NG';
      END;

      IF NVL (LVI_COUNT, 0) > 0
      THEN
         P_OUT := 'NG';
         P_MSG := f_msg('Already receipted. check please!','C',1) ; -- '이미 입고 되었습니다. 확인하세요!!';
         RETURN;
      END IF;


      LVI_COUNT := 0;

      BEGIN
         SELECT COUNT (*)
           INTO LVI_COUNT
           FROM IP_PRODUCT_2D_BARCODE
          WHERE MAGAZINE_NO = LVI_BARCODE AND SHIPPING_DEFICIT IS NULL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            P_OUT := 'NG';
      END;

      IF NVL (LVI_COUNT, 0) = 0
      THEN
         P_OUT := 'NG';
         P_MSG :=  f_msg('Already receipted or shipped','C',1) ; --'이미 입고 또는 출하된 매거진 입니다.';
         RETURN;
      END IF;

     LVI_COUNT := 0;

      -------------------------------------------------------------

      UPDATE IP_PRODUCT_2D_BARCODE
         SET SHIPPING_DEFICIT = '1', RECEIPT_DATE = SYSDATE
       WHERE MAGAZINE_NO = LVI_BARCODE;

      P_OUT := 'OK';
      P_MSG := 'OK.'||'(QTY:'||to_char(sql%rowcount)||')';  -- 2016/05/31 SHS, 입고처리 수량 메세지 추가

      COMMIT;

      RETURN;
   --------------------------------------------------------------
   -- 취소
   ---------------------------------------------------------------
   ELSE

      BEGIN
         SELECT COUNT (*)
           INTO LVI_COUNT
           FROM IP_PRODUCT_2D_BARCODE
          WHERE MAGAZINE_NO = LVI_BARCODE AND SHIPPING_DEFICIT = '3';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            P_OUT := 'NG';
      END;

      IF NVL (LVI_COUNT, 0) > 0
      THEN
         P_OUT := 'NG';
         P_MSG := 
              f_msg('Already Shipped. Can`t Canel (Do Cancel and Continue)','C',1) ;
            --'이미 출하되어 취소불가 (출하취소하고 작업하세요).';
         RETURN;
      END IF;

      LVI_COUNT := 0;

      BEGIN
         SELECT COUNT (*)
           INTO LVI_COUNT
           FROM IP_PRODUCT_2D_BARCODE
          WHERE MAGAZINE_NO = LVI_BARCODE AND SHIPPING_DEFICIT = '1';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            P_OUT := 'NG';
            P_MSG := f_msg('Not yet receipt','C',1) ; --'입고된 매거진이 아닙니다';
      END;

      IF NVL (LVI_COUNT, 0) = 0
      THEN
         P_OUT := 'NG';
          P_MSG := f_msg('Not yet receipt','C',1) ; --'입고된 매거진이 아닙니다';
         RETURN;
      END IF;

      --입고 상태로 전환
      UPDATE IP_PRODUCT_2D_BARCODE
         SET SHIPPING_DEFICIT = NULL, RECEIPT_DATE = SYSDATE
       WHERE MAGAZINE_NO = LVI_BARCODE;

      P_OUT := 'OK';
      P_MSG := 'OK.'||'CANEL QTY:'||to_char(sql%rowcount)||')';  -- 2016/05/31 SHS, 입고처리 수량 메세지 추가
      COMMIT;

   END IF;

EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      P_OUT := 'NG';
      P_MSG := f_msg('Not yet receipt','C',1) ; --'입고된 매가진 정보가 없습니다';
      RETURN;
   WHEN OTHERS
   THEN
      RAISE_APPLICATION_ERROR (-20003, SQLERRM);
END ;