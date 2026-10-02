import * as fs from 'fs';
import * as path from 'path';

const repoRoot = path.resolve(__dirname, '..', '..', '..');
const frontendSrcRoot = path.join(repoRoot, 'frontend', 'src');
const frontendTypesIndexPath = path.join(frontendSrcRoot, 'types', 'index.ts');

function walk(dir: string): string[] {
  return fs.readdirSync(dir, { withFileTypes: true }).flatMap((entry) => {
    const fullPath = path.join(dir, entry.name);
    return entry.isDirectory() ? walk(fullPath) : [fullPath];
  });
}

function read(filePath: string): string {
  return fs.readFileSync(filePath, 'utf8');
}

function relativeToFrontend(filePath: string): string {
  return path.relative(frontendSrcRoot, filePath).replace(/\\/g, '/');
}

describe('frontend shared type boundaries', () => {
  const frontendSourceFiles = walk(frontendSrcRoot).filter((filePath) => /\.(ts|tsx)$/.test(filePath));

  it('does not import from the legacy global @/types barrel', () => {
    const legacyBarrelImport = /from\s+['"]@\/types['"]/;
    const offenders = frontendSourceFiles
      .filter((filePath) => legacyBarrelImport.test(read(filePath)))
      .map(relativeToFrontend);

    expect(offenders).toEqual([]);
  });

  it('does not reintroduce broad domain model interfaces in src/types/index.ts', () => {
    // 은성은 전역 타입 묶음(src/types/index.ts)을 없앴다 — 없으면 다시 생기지 않은 것이다.
    const globalTypesSource = fs.existsSync(frontendTypesIndexPath) ? read(frontendTypesIndexPath) : '';
    const broadDomainTypes = [
      'User',
      'ProductionResult',
      'MaterialLot',
      'InspectionResult',
      'DefectLog',
      'Equipment',
    ];

    const offenders = broadDomainTypes.filter((typeName) =>
      new RegExp(`export\\s+interface\\s+${typeName}\\b`).test(globalTypesSource),
    );

    expect(offenders).toEqual([]);
  });

  it('does not keep sample data placeholders in runtime frontend source', () => {
    // OEE 종합 현황은 산식 연결 전 목업 화면이다(ad858b44). 화면 헤더에 목업 배지를 상시 띄운다.
    // 산식을 붙이면 _lib/mock.ts 를 API 로 바꾸고 여기서 뺀다.
    const allowedPaths = new Set<string>([
      'app/(authenticated)/oee/overall-status/page.tsx',
      'app/(authenticated)/oee/overall-status/_lib/mock.ts',
    ]);
    const placeholderPattern = /\b(mock|dummy|stub|fixture)\b|(?:mock|dummy|stub|fixture)[A-Z_]/;
    const runtimeFiles = frontendSourceFiles.filter((filePath) => {
      const relativePath = relativeToFrontend(filePath);
      return !allowedPaths.has(relativePath)
        && !/\.(spec|test)\.(ts|tsx)$/.test(relativePath)
        && !relativePath.includes('__tests__/');
    });

    const offenders = runtimeFiles
      .filter((filePath) => placeholderPattern.test(read(filePath)))
      .map(relativeToFrontend);

    expect(offenders).toEqual([]);
  });

  it('does not leave console.log debug output in runtime frontend source', () => {
    const runtimeFiles = frontendSourceFiles.filter((filePath) => {
      const relativePath = relativeToFrontend(filePath);
      return !/\.(spec|test)\.(ts|tsx)$/.test(relativePath)
        && !relativePath.includes('__tests__/');
    });

    const offenders = runtimeFiles
      .filter((filePath) => /\bconsole\.log\s*\(/.test(read(filePath)))
      .map(relativeToFrontend);

    expect(offenders).toEqual([]);
  });
});
