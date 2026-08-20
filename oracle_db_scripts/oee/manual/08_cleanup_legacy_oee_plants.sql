BEGIN
  DELETE FROM PLANTS
   WHERE COMPANY = 'EUNSUNG'
     AND PLANT_CD = '1'
     AND PLANT_CODE = 'EUNSUNG'
     AND CREATED_BY = 'SYSTEM'
     AND (
       (SHOP_CODE = '-' AND LINE_CODE = '-' AND CELL_CODE = '-')
       OR (SHOP_CODE = '2F' AND LINE_CODE = '-' AND CELL_CODE = '-')
       OR (
         SHOP_CODE = '2F'
         AND LINE_CODE = 'PROD2'
         AND CELL_CODE IN ('-','50','51','52','53','54','55','56','57','58','59','60','61','62','63','64')
       )
     );
  COMMIT;
END;
/
