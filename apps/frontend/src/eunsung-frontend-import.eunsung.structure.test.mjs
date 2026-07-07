import assert from "node:assert/strict";
import fs from "node:fs";
import path from "node:path";
import test from "node:test";

const root = process.cwd();
const read = (relativePath) => fs.readFileSync(path.join(root, relativePath), "utf8");
const exists = (relativePath) => fs.existsSync(path.join(root, relativePath));
const legacyBrandPattern = new RegExp(["하" + "네스", "H" + "ARNESS", "H" + "ANES"].join("|"));

test("은성 프론트 루트는 원본 랜딩/메인 레이아웃을 이식해 사용한다", () => {
  assert.ok(exists("src/app/page.tsx"));
  assert.ok(exists("src/app/layout.tsx"));
  assert.ok(exists("src/app/components/LandingHeader.tsx"));
  assert.ok(exists("src/app/components/LandingHero.tsx"));
  assert.ok(exists("src/app/components/LandingFeatures.tsx"));
  assert.ok(exists("src/components/layout/MainLayout.tsx"));
  assert.ok(exists("src/components/layout/Header.tsx"));
  assert.ok(exists("src/components/layout/Sidebar.tsx"));

  const landing = read("src/app/page.tsx");
  assert.match(landing, /LandingHeader/);
  assert.match(landing, /LandingHero/);
  assert.match(landing, /LandingFeatures/);
  assert.doesNotMatch(landing, /LandingWorkbench/);

  const rootLayout = read("src/app/layout.tsx");
  assert.match(rootLayout, /은성전장 MES/);
});

test("모니터링은 비즈니스 랜딩과 분리된 라우트로 보존한다", () => {
  assert.ok(exists("src/app/(menu)/monitoring/page.tsx"));
  assert.ok(exists("src/app/(display)/display/[screenId]/page.tsx"));
  assert.ok(exists("src/app/api/display/21/route.ts"));
  assert.ok(exists("src/components/menu"));
  assert.ok(exists("src/components/display"));
  assert.ok(!exists("src/app/(business)/page.tsx"));
});

test("은성 브랜드와 SMT 공유 패키지명을 사용한다", () => {
  const appPackage = read("package.json");
  const nextConfig = read("next.config.ts");
  const features = read("src/app/components/LandingFeatures.tsx");

  assert.match(appPackage, /"@smt\/shared": "workspace:\*"/);
  assert.match(nextConfig, /"@smt\/shared"/);
  assert.match(features, /수불관리/);
  assert.match(features, /OEE 관리/);
  assert.doesNotMatch(features, legacyBrandPattern);
});
