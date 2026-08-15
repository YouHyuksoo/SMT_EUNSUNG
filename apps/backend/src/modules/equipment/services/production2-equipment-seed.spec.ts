import { readFileSync } from 'fs';
import { join } from 'path';

describe('Production2 equipment seed', () => {
  const source = readFileSync(
    join(__dirname, '../../../../../../oracle_db_scripts/oee/11_seed_production2_equipment.sql'),
    'utf8',
  );

  it('starts with an executable PL/SQL block and preserves the approved scope', () => {
    expect(source.trimStart()).toMatch(/^BEGIN\b/);
    expect(source).toContain('MERGE INTO IMCN_MACHINE');
    expect(source).toContain("'M0240'");
    expect(source).toContain("'M0250'");
    expect(source).toContain("'ICT05'");
    expect(source).not.toMatch(/'ICT0[1-4]'/);
    expect(source).toContain("'19', 'W080', '2500'");
    expect(source).toContain("'24', 'W130', '2500'");
    expect(source).toContain("'*', 'Y', 'N', 'N'");
    expect(source).toContain("'Y', 'CODEX', SYSDATE, 'CODEX', SYSDATE");
  });

  it('contains exactly the approved 31 equipment codes', () => {
    const codes = [...source.matchAll(/(?:SELECT|UNION ALL SELECT)\s+'([^']+)'(?:\s+MACHINE_CODE)?/g)]
      .map((match) => match[1])
      .filter((code) => /^(?:WAVE|ICT|PERF|COAT|JET|ROUTER)/.test(code));

    expect(codes).toHaveLength(31);
    expect(new Set(codes).size).toBe(31);
  });
});
