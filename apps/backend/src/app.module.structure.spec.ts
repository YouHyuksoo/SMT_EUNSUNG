import { readFileSync } from 'fs';
import { join } from 'path';

describe('AppModule activated API modules', () => {
  const source = readFileSync(join(__dirname, 'app.module.ts'), 'utf8');
  const databaseModuleSource = readFileSync(join(__dirname, 'database/database.module.ts'), 'utf8');

  it('activates the system department API without importing the full master module', () => {
    expect(source).toContain('MasterDepartmentModule');
    expect(source).not.toMatch(/import\s+\{\s*MasterModule\s*\}/);
    expect(databaseModuleSource).toContain("import { DepartmentMaster } from '../entities/department-master.entity'");
    expect(databaseModuleSource).toMatch(/entities:\s*\[[\s\S]*\bDepartmentMaster\b/);
  });
});
