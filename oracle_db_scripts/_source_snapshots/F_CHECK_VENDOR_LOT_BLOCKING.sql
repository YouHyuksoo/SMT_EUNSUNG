FUNCTION "F_CHECK_VENDOR_LOT_BLOCKING" (
   p_our_barcode  IN VARCHAR2,
   p_vendor_lot   IN VARCHAR2)
   RETURN VARCHAR2
IS
   lvi_count   NUMBER;
   lvi_cnt     NUMBER;
   lvs_str     varchar2(2);
   lvs_return  varchar2(200);
BEGIN
      SELECT COUNT(*)
        INTO LVI_COUNT
        FROM IM_ITEM_RECEIPT_BARCODE X,
             ID_ITEM                 Y
       WHERE X.ITEM_BARCODE = p_our_barcode
         AND X.ITEM_CODE    = Y.ITEM_CODE
         AND ( Y.VENDOR_CODE  = 'US000163' or Y.VENDOR_CODE1  = 'US000163' or Y.VENDOR_CODE2  = 'US000163' or Y.VENDOR_CODE3  = 'US000163')  ; --？？？？ ？？？？


      lvs_return := 'OK' ;

      lvs_str := substr(p_vendor_lot,1,2) ;


      IF LVI_COUNT > 0 THEN                  --？？？？ ？？？？？？？


       /* SELECT COUNT(*)
          INTO lvi_cnt
          FROM (
                 SELECT p_vendor_lot as lot
                   FROM dual
                )
         WHERE regexp_like ( lot,'^[1-9][A-Z].') ;*/



         IF lvs_str <> '1T' THEN
           lvs_return := 'NG' ;
         ELSE
           lvs_return := 'OK' ;
         END IF;

      END IF ;


     return lvs_return ;
EXCEPTION
   WHEN OTHERS
   THEN
     return 'DB'||substr(sqlerrm,1,100) ;
END ;