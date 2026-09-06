import { readFileSync } from 'fs';
import { join } from 'path';

const scriptPath = join(__dirname, '../../../../../oracle_db_scripts/13_prod_line_oee_fields.sql');

function stripComments(source: string): string {
  return source.replace(/--[^\r\n]*/g, ' ').replace(/\/\*[\s\S]*?\*\//g, ' ');
}

describe('production-line OEE field DDL', () => {
  const source = readFileSync(scriptPath, 'utf8');
  const sql = stripComments(source).trim();

  it('starts with an anonymous PL/SQL block and guards every catalog change', () => {
    expect(sql).toMatch(/^(DECLARE|BEGIN)\b/);
    expect(sql.match(/USER_TAB_COLUMNS/g)).toHaveLength(3);
    expect(sql.match(/USER_CONSTRAINTS/g)).toHaveLength(2);
  });

  it('adds the nullable production-line OEE columns and checks', () => {
    expect(sql).toContain('ALTER TABLE IP_PRODUCT_LINE ADD PROCESS_CODE VARCHAR2(20)');
    expect(sql).toContain('ALTER TABLE IP_PRODUCT_LINE ADD RESOURCE_TYPE VARCHAR2(20)');
    expect(sql).toContain('ALTER TABLE IP_PRODUCT_LINE ADD PARENT_LINE_CODE VARCHAR2(20)');
    expect(sql).toContain("PROCESS_CODE IS NULL OR PROCESS_CODE IN (''SMT'', ''ASSY'')");
    expect(sql).toContain("RESOURCE_TYPE IS NULL OR RESOURCE_TYPE IN (''LINE'', ''CELL'')");
  });

  it('does not mutate data or couple the production-line table to OEE_RESOURCE', () => {
    expect(sql).not.toMatch(/\b(?:INSERT|UPDATE|DELETE|MERGE)\b/i);
    expect(sql).not.toMatch(/\bDEFAULT\b/i);
    expect(sql).not.toMatch(/\bFOREIGN\s+KEY\b/i);
    expect(sql).not.toMatch(/OEE_RESOURCE/i);
  });
});
