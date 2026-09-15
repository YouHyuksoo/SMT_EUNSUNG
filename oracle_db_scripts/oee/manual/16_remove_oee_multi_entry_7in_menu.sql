BEGIN
  -- The canonical OEE_MULTI_ENTRY menu and downtime records are unaffected.
  DELETE FROM MENU_CATEGORY_ITEMS
   WHERE ORGANIZATION_ID = 1
     AND MENU_CODE = 'OEE_MULTI_ENTRY_7IN';
  COMMIT;
END;
/
