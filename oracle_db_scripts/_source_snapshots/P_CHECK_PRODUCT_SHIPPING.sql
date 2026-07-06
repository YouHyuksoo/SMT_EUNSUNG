PROCEDURE "P_CHECK_PRODUCT_SHIPPING" (
   P_BARCODE   IN     VARCHAR2,
   P_DEFICIT   IN     VARCHAR2,
   P_OUT          OUT VARCHAR2,
   P_MSG          OUT VARCHAR2)
IS
   LVI_BARCODE           VARCHAR2 (100);

   LVI_COUNT             NUMBER;
   LVI_POWER_CHECK       NUMBER;
   LVS_NO_POWER_SERIAL   VARCHAR2 (100);
BEGIN


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
    ---------------------------------------------------------------------------------

   IF P_DEFICIT = 'N'
   THEN
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
         P_MSG := f_msg('It has already been shipped.','C',1) ; --' 이미 출하 되었습니다.';
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
            P_MSG := f_msg('This is not waiting to be shipped','C',1)     ; -- '출하 대기중인 매거진이 아닙니다';
      END;

      IF NVL (LVI_COUNT, 0) = 0
      THEN
         P_OUT := 'NG';
         P_MSG := f_msg('This is not waiting to be shipped','C',1)     ; -- '출하 대기중인 매거진이 아닙니다';
         RETURN;
      END IF;



      -- SELECT COUNT (*), MAX (SERIAL_NO)
      --   INTO LVI_POWER_CHECK, LVS_NO_POWER_SERIAL
      --   FROM IP_PRODUCT_2D_BARCODE
      --  WHERE     MAGAZINE_NO = LVI_BARCODE
      --        AND POWER_CHECK_YN <> 'Y'                                 --POWER
      --        AND MODEL_NAME IN (SELECT MODEL_NAME
      --                             FROM IP_PRODUCT_MODEL_MASTER
      --                            WHERE CUSTOMER_CODE = 'DY');
      --
      --
      -- IF NVL (LVI_POWER_CHECK, 0) > 0
      -- THEN
      --    P_OUT := 'NG';
      --    P_MSG :=
      --       '파워검사 이력이 없는 제품이 들어 있습니다 확인하세요';
      --    RETURN;
      --  END IF;


      -------------------------------------------------------------
      --
      -------------------------------------------------------------

      UPDATE IP_PRODUCT_2D_BARCODE
         SET SHIPPING_DEFICIT = '3', SHIPPING_DATE = SYSDATE
       WHERE MAGAZINE_NO = LVI_BARCODE;

      P_OUT := 'OK';
      P_MSG := 'OK.'||'(QTY:'||to_char(sql%rowcount)||')';
      COMMIT;
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
            P_MSG := f_msg('Information Notfound','C',1) ; --'출하된 매거진 정보가 없습니다';
            RETURN;
      END;

      IF NVL (LVI_COUNT, 0) = 0
      THEN
         P_OUT := 'NG';
         P_MSG := f_msg('Information Notfound','C',1) ; --'출하된 매거진 정보가 없습니다';
         RETURN;
      END IF;


      UPDATE IP_PRODUCT_2D_BARCODE
         SET SHIPPING_DEFICIT = '1', SHIPPING_DATE = SYSDATE
       WHERE MAGAZINE_NO = LVI_BARCODE AND SHIPPING_DEFICIT = '3';

      P_OUT := 'OK';
      P_MSG := 'OK.'||'(Canel QTY:'||to_char(sql%rowcount)||')';  -- 2016/05/31 SHS, 취소처리 수량 메세지 추가
      COMMIT;
      RETURN;
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      P_OUT := 'NG';
      P_MSG := f_msg('Information Notfound','C',1) ; --'출하된 매거진 정보가 없습니다';
      RETURN;
   WHEN OTHERS
   THEN

      -- test shs
           

      RAISE_APPLICATION_ERROR (-20003, SQLERRM);
END P_CHECK_PRODUCT_SHIPPING;