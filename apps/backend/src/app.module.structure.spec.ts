import { readFileSync } from 'fs';
import { join } from 'path';

describe('AppModule activated API modules', () => {
  const source = readFileSync(join(__dirname, 'app.module.ts'), 'utf8');
  const databaseModuleSource = readFileSync(join(__dirname, 'database/database.module.ts'), 'utf8');
  const plantModuleSource = readFileSync(
    join(__dirname, 'modules/master/master-plant.module.ts'),
    'utf8',
  );
  const oeeModuleSource = readFileSync(join(__dirname, 'modules/oee/oee.module.ts'), 'utf8');

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

  it('provides OracleService from the root module for scheduler procedure jobs', () => {
    expect(source).toContain("import { OracleModule } from './common/modules/oracle.module'");
    expect(source).toMatch(/imports:\s*\[[\s\S]*\bOracleModule\b/);
  });

  it('activates the ID_ITEM-backed parts API', () => {
    expect(source).toContain("import { MasterPartModule } from './modules/master/master-part.module'");
    expect(source).toMatch(/imports:\s*\[[\s\S]*\bMasterPartModule\b/);
    expect(databaseModuleSource).toContain("import { ItemMaster } from '../entities/item-master.entity'");
    expect(databaseModuleSource).toMatch(/entities:\s*\[[\s\S]*\bItemMaster\b/);
  });

  it('activates the actual PLANTS-backed plant API and registers its entity', () => {
    expect(source).toContain("import { MasterPlantModule } from './modules/master/master-plant.module'");
    expect(source).toMatch(/imports:\s*\[[\s\S]*\bMasterPlantModule\b/);
    expect(databaseModuleSource).toContain("import { Plant } from '../entities/plant.entity'");
    expect(databaseModuleSource).toMatch(/entities:\s*\[[\s\S]*\bPlant\b/);
    expect(plantModuleSource).toMatch(/controllers:\s*\[[\s\S]*\bPlantController\b/);
    expect(plantModuleSource).toMatch(/providers:\s*\[[\s\S]*\bPlantService\b/);
    expect(plantModuleSource).toMatch(/providers:\s*\[[\s\S]*\bJwtAuthGuard\b/);
  });

  it('activates the IMCN_MACHINE-backed equipment API without importing the full equipment module', () => {
    expect(source).toContain("import { MasterEquipModule } from './modules/master/master-equip.module'");
    expect(source).toMatch(/imports:\s*\[[\s\S]*\bMasterEquipModule\b/);
    expect(source).not.toMatch(/import\s+\{\s*EquipmentModule\s*\}/);
    expect(databaseModuleSource).toContain("import { EquipMaster } from '../entities/equip-master.entity'");
    expect(databaseModuleSource).toMatch(/entities:\s*\[[\s\S]*\bEquipMaster\b/);
  });

  it('activates the scheduler API and registers its TypeORM entities', () => {
    expect(source).toContain("import { SchedulerModule } from './modules/scheduler/scheduler.module'");
    expect(source).toMatch(/imports:\s*\[[\s\S]*\bSchedulerModule\b/);
    expect(databaseModuleSource).toContain("import { SchedulerJob } from '../entities/scheduler-job.entity'");
    expect(databaseModuleSource).toContain("import { SchedulerLog } from '../entities/scheduler-log.entity'");
    expect(databaseModuleSource).toContain("import { SchedulerNotification } from '../entities/scheduler-notification.entity'");
    expect(databaseModuleSource).toMatch(/entities:\s*\[[\s\S]*\bSchedulerJob\b/);
    expect(databaseModuleSource).toMatch(/entities:\s*\[[\s\S]*\bSchedulerLog\b/);
    expect(databaseModuleSource).toMatch(/entities:\s*\[[\s\S]*\bSchedulerNotification\b/);
  });

  it('registers the mobile event/worktime entities and prerequisite repositories', () => {
    expect(databaseModuleSource).toContain(
      "import { OeeDowntimeEvent } from '../entities/oee-downtime-event.entity'",
    );
    expect(databaseModuleSource).toContain(
      "import { WorktimeRange } from '../entities/worktime-range.entity'",
    );
    expect(databaseModuleSource).toMatch(/entities:\s*\[[\s\S]*\bOeeDowntimeEvent\b/);
    expect(databaseModuleSource).toMatch(/entities:\s*\[[\s\S]*\bWorktimeRange\b/);
    expect(oeeModuleSource).toMatch(/forFeature\(\[[\s\S]*\bOeeDowntimeEvent\b/);
    expect(oeeModuleSource).toMatch(/forFeature\(\[[\s\S]*\bWorktimeRange\b/);
    expect(oeeModuleSource).toMatch(/forFeature\(\[[\s\S]*\bIsysUser\b/);
    expect(oeeModuleSource).toMatch(/forFeature\(\[[\s\S]*\bComCode\b/);
  });
});
