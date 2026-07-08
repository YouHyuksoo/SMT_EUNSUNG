DECLARE
  PROCEDURE upsert_category(
    p_organization_id NUMBER,
    p_category_code VARCHAR2,
    p_label_key VARCHAR2,
    p_icon_name VARCHAR2,
    p_sort_order NUMBER
  ) IS
  BEGIN
    MERGE INTO MENU_CATEGORIES target
    USING (
      SELECT p_organization_id AS organization_id,
             p_category_code AS category_code,
             p_label_key AS label_key,
             p_icon_name AS icon_name,
             p_sort_order AS sort_order
        FROM DUAL
    ) source
    ON (target.ORGANIZATION_ID = source.organization_id AND target.CATEGORY_CODE = source.category_code)
    WHEN MATCHED THEN UPDATE SET
      target.LABEL_KEY = source.label_key,
      target.ICON_NAME = source.icon_name,
      target.SORT_ORDER = source.sort_order,
      target.IS_ACTIVE = 'Y',
      target.UPDATED_AT = SYSTIMESTAMP,
      target.UPDATED_BY = 'SYSTEM'
    WHEN NOT MATCHED THEN INSERT (
      ORGANIZATION_ID, CATEGORY_CODE, LABEL_KEY, ICON_NAME, SORT_ORDER, IS_ACTIVE,
      CREATED_AT, CREATED_BY, UPDATED_AT, UPDATED_BY
    ) VALUES (
      source.organization_id, source.category_code, source.label_key, source.icon_name, source.sort_order, 'Y',
      SYSTIMESTAMP, 'SYSTEM', SYSTIMESTAMP, 'SYSTEM'
    );
  END;

  PROCEDURE upsert_item(
    p_organization_id NUMBER,
    p_menu_code VARCHAR2,
    p_category_code VARCHAR2,
    p_sort_order NUMBER
  ) IS
  BEGIN
    MERGE INTO MENU_CATEGORY_ITEMS target
    USING (
      SELECT p_organization_id AS organization_id,
             p_menu_code AS menu_code,
             p_category_code AS category_code,
             p_sort_order AS sort_order
        FROM DUAL
    ) source
    ON (target.ORGANIZATION_ID = source.organization_id AND target.MENU_CODE = source.menu_code)
    WHEN MATCHED THEN UPDATE SET
      target.CATEGORY_CODE = source.category_code,
      target.SORT_ORDER = source.sort_order,
      target.UPDATED_AT = SYSTIMESTAMP,
      target.UPDATED_BY = 'SYSTEM'
    WHEN NOT MATCHED THEN INSERT (
      ORGANIZATION_ID, MENU_CODE, CATEGORY_CODE, SORT_ORDER,
      CREATED_AT, CREATED_BY, UPDATED_AT, UPDATED_BY
    ) VALUES (
      source.organization_id, source.menu_code, source.category_code, source.sort_order,
      SYSTIMESTAMP, 'SYSTEM', SYSTIMESTAMP, 'SYSTEM'
    );
  END;
BEGIN
  FOR org IN (SELECT ORGANIZATION_ID FROM ISYS_ORGANIZATION) LOOP
    upsert_category(org.ORGANIZATION_ID, 'SYSTEM', 'menu.system', 'Settings', 20);

    upsert_item(org.ORGANIZATION_ID, 'SYS_COMPANY', 'SYSTEM', 10);
    upsert_item(org.ORGANIZATION_ID, 'SYS_CODE', 'SYSTEM', 20);
    upsert_item(org.ORGANIZATION_ID, 'SYS_CONFIG', 'SYSTEM', 30);
    upsert_item(org.ORGANIZATION_ID, 'SYS_MENU_CATEGORY', 'SYSTEM', 40);
    upsert_item(org.ORGANIZATION_ID, 'SYS_DEPT', 'SYSTEM', 50);
    upsert_item(org.ORGANIZATION_ID, 'SYS_USER', 'SYSTEM', 60);
    upsert_item(org.ORGANIZATION_ID, 'SYS_ROLE', 'SYSTEM', 70);
    upsert_item(org.ORGANIZATION_ID, 'SYS_DOCUMENT', 'SYSTEM', 80);
    upsert_item(org.ORGANIZATION_ID, 'SYS_SCHEDULER', 'SYSTEM', 90);
    upsert_item(org.ORGANIZATION_ID, 'SYS_ER_VIEW', 'SYSTEM', 100);
    upsert_item(org.ORGANIZATION_ID, 'SYS_IMPR_REQ', 'SYSTEM', 110);
  END LOOP;
END;
/
