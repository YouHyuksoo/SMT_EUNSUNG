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

  it('activates the ISYS_USERS-backed user API', () => {
    expect(source).toContain("import { UserModule } from './modules/user/user.module'");
    expect(source).toMatch(/imports:\s*\[[\s\S]*\bUserModule\b/);
    expect(databaseModuleSource).toContain("import { IsysUser } from '../entities/isys-user.entity'");
    expect(databaseModuleSource).toMatch(/entities:\s*\[[\s\S]*\bIsysUser\b/);
  });

  it('activates the ID_ITEM-backed parts API', () => {
    expect(source).toContain("import { MasterPartModule } from './modules/master/master-part.module'");
    expect(source).toMatch(/imports:\s*\[[\s\S]*\bMasterPartModule\b/);
    expect(databaseModuleSource).toContain("import { ItemMaster } from '../entities/item-master.entity'");
    expect(databaseModuleSource).toMatch(/entities:\s*\[[\s\S]*\bItemMaster\b/);
  });
});
