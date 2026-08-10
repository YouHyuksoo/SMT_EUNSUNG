DECLARE
  -- 생산2팀 2층 조립 CELL 최초 등록 시드
  -- 근거: docs/adr/0001-oee-mobile-seed-and-scanner-scope.md
  -- 기존 행의 관리값은 보존하고, 실제 PK를 다른 tenant가 소유하면 중단한다.
  CURSOR c_cells IS
    SELECT 'EUNSUNG' AS company, '1' AS plant_cd,
           'EUNSUNG' AS plant_code, '-' AS shop_code, '-' AS line_code, '-' AS cell_code,
           '은성전장 홍성공장' AS plant_name, 'PLANT' AS plant_type, 0 AS sort_order, 'Y' AS use_yn FROM DUAL
    UNION ALL SELECT 'EUNSUNG', '1', 'EUNSUNG', '2F', '-', '-', '2층 작업장', 'SHOP', 10, 'Y' FROM DUAL
    UNION ALL SELECT 'EUNSUNG', '1', 'EUNSUNG', '2F', 'PROD2', '-', '생산2팀', 'LINE', 20, 'Y' FROM DUAL
    UNION ALL SELECT 'EUNSUNG', '1', 'EUNSUNG', '2F', 'PROD2', '50', 'CMA', 'CELL', 50, 'Y' FROM DUAL
    UNION ALL SELECT 'EUNSUNG', '1', 'EUNSUNG', '2F', 'PROD2', '51', 'O1XX', 'CELL', 51, 'Y' FROM DUAL
    UNION ALL SELECT 'EUNSUNG', '1', 'EUNSUNG', '2F', 'PROD2', '52', 'DN8', 'CELL', 52, 'Y' FROM DUAL
    UNION ALL SELECT 'EUNSUNG', '1', 'EUNSUNG', '2F', 'PROD2', '53', 'CD6', 'CELL', 53, 'Y' FROM DUAL
    UNION ALL SELECT 'EUNSUNG', '1', 'EUNSUNG', '2F', 'PROD2', '54', 'HG', 'CELL', 54, 'Y' FROM DUAL
    UNION ALL SELECT 'EUNSUNG', '1', 'EUNSUNG', '2F', 'PROD2', '55', 'MOC28', 'CELL', 55, 'Y' FROM DUAL
    UNION ALL SELECT 'EUNSUNG', '1', 'EUNSUNG', '2F', 'PROD2', '56', 'ECM', 'CELL', 56, 'Y' FROM DUAL
    UNION ALL SELECT 'EUNSUNG', '1', 'EUNSUNG', '2F', 'PROD2', '57', 'AE_EV', 'CELL', 57, 'Y' FROM DUAL
    UNION ALL SELECT 'EUNSUNG', '1', 'EUNSUNG', '2F', 'PROD2', '58', 'UPPER', 'CELL', 58, 'Y' FROM DUAL
    UNION ALL SELECT 'EUNSUNG', '1', 'EUNSUNG', '2F', 'PROD2', '59', 'EOP', 'CELL', 59, 'Y' FROM DUAL
    UNION ALL SELECT 'EUNSUNG', '1', 'EUNSUNG', '2F', 'PROD2', '60', '대양전기', 'CELL', 60, 'Y' FROM DUAL
    UNION ALL SELECT 'EUNSUNG', '1', 'EUNSUNG', '2F', 'PROD2', '61', 'BMA', 'CELL', 61, 'Y' FROM DUAL
    UNION ALL SELECT 'EUNSUNG', '1', 'EUNSUNG', '2F', 'PROD2', '62', 'TSMOST', 'CELL', 62, 'Y' FROM DUAL
    UNION ALL SELECT 'EUNSUNG', '1', 'EUNSUNG', '2F', 'PROD2', '63', 'AS', 'CELL', 63, 'Y' FROM DUAL
    UNION ALL SELECT 'EUNSUNG', '1', 'EUNSUNG', '2F', 'PROD2', '64', 'LED', 'CELL', 64, 'Y' FROM DUAL;
  v_foreign_owner_count NUMBER;
BEGIN
  -- PLANTS의 실제 PK에는 tenant 컬럼이 없으므로 외부 tenant 소유 키는 조용히 건너뛰지 않는다.
  FOR source IN c_cells LOOP
    SELECT COUNT(*)
      INTO v_foreign_owner_count
      FROM PLANTS target
     WHERE target.PLANT_CODE = source.plant_code
       AND target.SHOP_CODE = source.shop_code
       AND target.LINE_CODE = source.line_code
       AND target.CELL_CODE = source.cell_code
       AND (target.COMPANY <> source.company OR target.PLANT_CD <> source.plant_cd);

    IF v_foreign_owner_count > 0 THEN
      RAISE_APPLICATION_ERROR(
        -20001,
        'PLANTS key belongs to another tenant: '
          || source.plant_code || '/' || source.shop_code || '/'
          || source.line_code || '/' || source.cell_code
      );
    END IF;
  END LOOP;

  FOR source IN c_cells LOOP
    MERGE INTO PLANTS target
    USING (
      SELECT source.company AS company, source.plant_cd AS plant_cd,
             source.plant_code AS plant_code, source.shop_code AS shop_code,
             source.line_code AS line_code, source.cell_code AS cell_code,
             source.plant_name AS plant_name, source.plant_type AS plant_type,
             source.sort_order AS sort_order, source.use_yn AS use_yn
        FROM DUAL
    ) seed
    ON (
      target.PLANT_CODE = seed.plant_code
      AND target.SHOP_CODE = seed.shop_code
      AND target.LINE_CODE = seed.line_code
      AND target.CELL_CODE = seed.cell_code
    )
    WHEN NOT MATCHED THEN INSERT (
      COMPANY, PLANT_CD, PLANT_CODE, SHOP_CODE, LINE_CODE, CELL_CODE,
      PLANT_NAME, PLANT_TYPE, SORT_ORDER, USE_YN,
      CREATED_BY, UPDATED_BY, CREATED_AT, UPDATED_AT
    ) VALUES (
      seed.company, seed.plant_cd, seed.plant_code, seed.shop_code, seed.line_code, seed.cell_code,
      seed.plant_name, seed.plant_type, seed.sort_order, seed.use_yn,
      'SYSTEM', 'SYSTEM', SYSTIMESTAMP, SYSTIMESTAMP
    );
  END LOOP;

  COMMIT;
END;
/
