import { readFileSync } from 'node:fs';
import { join } from 'node:path';

describe('local pnpm dev Oracle profile', () => {
  const root = join(__dirname, '../../../..');
  const packageJson = JSON.parse(
    readFileSync(join(root, 'apps/backend/package.json'), 'utf8'),
  ) as { scripts: Record<string, string> };
  const bootstrap = readFileSync(
    join(root, 'scripts/dev-backend-with-oracle-profile.mjs'),
    'utf8',
  );

  it('starts backend dev through the JSIDC2_ESDB profile bootstrap', () => {
    expect(packageJson.scripts.dev).toBe(
      'node ../../scripts/dev-backend-with-oracle-profile.mjs',
    );
    expect(bootstrap).toContain("const DEFAULT_PROFILE = 'JSIDC2_ESDB'");
    expect(bootstrap).toContain("JSIDC2_ESDB: 'EUNSUNG_DEV_ESDBPDB'");
    expect(bootstrap).toContain('ORACLE_SERVICE_NAME: serviceName');
    expect(bootstrap).toContain('ORACLE_PASSWORD: password');
    expect(bootstrap).toContain("shell: process.platform === 'win32'");
    expect(bootstrap).not.toMatch(/console\.log\([^)]*password/);
  });
});
