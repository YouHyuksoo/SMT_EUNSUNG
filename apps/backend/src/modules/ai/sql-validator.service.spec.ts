import { SqlValidatorService } from './sql-validator.service';

describe('SqlValidatorService (은성전장: 조회 전용)', () => {
  const v = new SqlValidatorService();

  it('SELECT / WITH 는 통과하고 kind=select', () => {
    expect(v.validate('SELECT ITEM_CODE FROM ID_ITEM')).toEqual({ valid: true, kind: 'select' });
    expect(v.validate('WITH A AS (SELECT 1 X FROM DUAL) SELECT X FROM A')).toEqual({ valid: true, kind: 'select' });
    expect(v.validate('```sql\nSELECT 1 FROM DUAL;\n```')).toEqual({ valid: true, kind: 'select' });
  });

  it('INSERT / UPDATE 는 시작이든 안쪽이든 막는다', () => {
    expect(v.validate("INSERT INTO ID_ITEM (ITEM_CODE) VALUES ('A')").valid).toBe(false);
    expect(v.validate("UPDATE ID_ITEM SET ITEM_NAME='B' WHERE ITEM_CODE='A'").valid).toBe(false);
    expect(v.validate('SELECT * FROM ID_ITEM FOR UPDATE').valid).toBe(false);
    expect(v.validate('WITH X AS (SELECT 1 FROM DUAL) INSERT INTO T SELECT * FROM X').valid).toBe(false);
  });

  it('DDL·DELETE·다중 쿼리는 막는다', () => {
    expect(v.validate('DELETE FROM ID_ITEM').valid).toBe(false);
    expect(v.validate('SELECT 1 FROM DUAL; DROP TABLE ID_ITEM').valid).toBe(false);
    expect(v.validate('SELECT DBMS_RANDOM.VALUE FROM DUAL').valid).toBe(false);
  });
});
