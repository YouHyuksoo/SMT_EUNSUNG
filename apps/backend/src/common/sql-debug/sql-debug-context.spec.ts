import {
  extractSqlTables,
  getSqlDebugQueries,
  recordSqlDebugQuery,
  runWithSqlDebugContext,
} from './sql-debug-context';

describe('sql-debug-context', () => {
  it('extracts table names from FROM and JOIN clauses', () => {
    expect(
      extractSqlTables(
        'SELECT lot.MAT_UID FROM "MAT_LOTS" lot JOIN ITEM_MASTERS item ON item.ITEM_CODE = lot.ITEM_CODE',
      ),
    ).toEqual(['MAT_LOTS', 'ITEM_MASTERS']);
  });

  it('records SELECT statements only inside a request debug context', () => {
    runWithSqlDebugContext(() => {
      recordSqlDebugQuery('UPDATE MAT_LOTS SET STATUS = :1', ['OK']);
      recordSqlDebugQuery('SELECT * FROM MAT_LOTS WHERE MAT_UID = :1', ['LOT-001']);

      expect(getSqlDebugQueries()).toEqual([
        {
          sql: 'SELECT * FROM MAT_LOTS WHERE MAT_UID = :1',
          parameters: ['LOT-001'],
          tables: ['MAT_LOTS'],
        },
      ]);
    });

    expect(getSqlDebugQueries()).toEqual([]);
  });

  it('records WITH (CTE) and comment-led SELECT statements, skips DML', () => {
    runWithSqlDebugContext(() => {
      recordSqlDebugQuery('\n  WITH wd AS (SELECT 1 X FROM DUAL) SELECT * FROM wd');
      recordSqlDebugQuery('/* 목록 */ SELECT * FROM ID_ITEM');
      recordSqlDebugQuery('-- 조회\nSELECT * FROM ID_ITEM');
      recordSqlDebugQuery('(SELECT 1 FROM DUAL) UNION ALL (SELECT 2 FROM DUAL)');
      recordSqlDebugQuery('/* 갱신 */ UPDATE ID_ITEM SET ITEM_NAME = :1');
      recordSqlDebugQuery('INSERT INTO ID_ITEM (ITEM_CODE) SELECT ITEM_CODE FROM ID_ITEM');
      recordSqlDebugQuery('SELECTED_FLAG = 1');

      expect(getSqlDebugQueries().map((query) => query.sql)).toEqual([
        '\n  WITH wd AS (SELECT 1 X FROM DUAL) SELECT * FROM wd',
        '/* 목록 */ SELECT * FROM ID_ITEM',
        '-- 조회\nSELECT * FROM ID_ITEM',
        '(SELECT 1 FROM DUAL) UNION ALL (SELECT 2 FROM DUAL)',
      ]);
    });
  });
});
