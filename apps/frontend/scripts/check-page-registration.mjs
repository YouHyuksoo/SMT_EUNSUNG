import { existsSync, readFileSync, readdirSync, statSync } from "node:fs";
import { dirname, join, relative, sep } from "node:path";
import { fileURLToPath } from "node:url";

const scriptDir = dirname(fileURLToPath(import.meta.url));
const frontendRoot = join(scriptDir, "..");
const repoRoot = join(frontendRoot, "..", "..");
const authRoot = join(frontendRoot, "src", "app", "(authenticated)");
const registryPath = join(frontendRoot, "src", "components", "layout", "pageRegistry.generated.ts");
const registryDir = join(frontendRoot, "src", "components", "layout", "page-registries");

function collectPages(dir) {
  return readdirSync(dir).flatMap((name) => {
    const full = join(dir, name);
    return statSync(full).isDirectory() ? collectPages(full) : name === "page.tsx" ? [full] : [];
  });
}

function routeOf(page) {
  const segments = relative(authRoot, dirname(page)).split(sep).filter((part) => part && !/^\(.*\)$/.test(part));
  return `/${segments.join("/")}`;
}

function registryName(route) {
  return (route.split("/").filter(Boolean).join("__") || "root").replace(/[^a-zA-Z0-9_-]/g, "-");
}

function stripComments(source) {
  return source.replace(/\/\*[\s\S]*?\*\//g, "").replace(/\/\/[^\r\n]*/g, "");
}

const failures = [];
const registry = readFileSync(registryPath, "utf8");
const routes = collectPages(authRoot).map((page) => ({ page, route: routeOf(page) }));

for (const { page, route } of routes) {
  if (!registry.includes(`case "${route}"`)) failures.push(`registry 누락: ${route}`);
  const generated = join(registryDir, `${registryName(route)}.generated.ts`);
  if (!existsSync(generated)) {
    failures.push(`lazy registry 파일 누락: ${route}`);
    continue;
  }
  const importPath = `@/${relative(join(frontendRoot, "src"), page).replace(/\\/g, "/").replace(/\.tsx$/, "")}`;
  if (!readFileSync(generated, "utf8").includes(`import("${importPath}")`)) failures.push(`lazy import 불일치: ${route}`);
}

const menuSource = readFileSync(join(frontendRoot, "src", "config", "menuConfig.ts"), "utf8");
const menuEntries = [...stripComments(menuSource).matchAll(/code:\s*"([A-Z0-9_]+)"[^\n]*path:\s*"([^"]+)"/g)]
  .map((match) => ({ code: match[1], route: match[2] }));
const pageRouteSet = new Set(routes.map(({ route }) => route));
const backendRegistries = [
  "apps/backend/src/seeds/menu-config.json",
  "apps/backend/src/modules/menu-categories/utils/menu-code-validator.ts",
  "apps/backend/src/modules/menu-categories/utils/default-menu-category-layout.ts",
].map((path) => ({ path, source: readFileSync(join(repoRoot, path), "utf8") }));

for (const { code, route } of menuEntries) {
  if (!pageRouteSet.has(route)) failures.push(`메뉴 경로에 page.tsx 없음: ${code} ${route}`);
  for (const registryFile of backendRegistries) {
    if (!registryFile.source.includes(code)) failures.push(`메뉴 코드 누락: ${code} -> ${registryFile.path}`);
  }
}

// 삭제된 메뉴/페이지가 되살아나지 않았는지 검사한다.
// 정본 목록: src/config/deleted-menu-pages.json (메뉴/페이지를 제거하면 여기에 등록한다)
const deleted = JSON.parse(readFileSync(join(frontendRoot, "src", "config", "deleted-menu-pages.json"), "utf8"));
const containsLiteral = (source, value) =>
  source.includes(`"${value}"`) || source.includes(`'${value}'`) || source.includes(`\`${value}\``);

for (const target of deleted.scanTargets) {
  const full = join(repoRoot, target);
  if (!existsSync(full)) continue;
  const source = readFileSync(full, "utf8");
  for (const route of deleted.forbiddenRoutes) {
    if (containsLiteral(source, route)) failures.push(`삭제된 라우트 부활: ${route} -> ${target}`);
  }
  for (const code of deleted.forbiddenCodes) {
    if (source.includes(code)) failures.push(`삭제된 메뉴코드 부활: ${code} -> ${target}`);
  }
}

for (const path of [...deleted.deletedRouteDirs, ...deleted.deletedRegistryFiles]) {
  if (existsSync(join(repoRoot, path))) failures.push(`삭제 대상이 존재함: ${path}`);
}

const menuArrayLines = menuSource.slice(menuSource.indexOf("export const menuConfig")).split(/\r?\n/);
const topLevelCodes = menuArrayLines.flatMap((line, index) => {
  if (line.trimEnd() !== "  {") return [];
  const match = /^    code: "([^"]+)"/.exec(menuArrayLines[index + 1] ?? "");
  return match ? [match[1]] : [];
});
if (topLevelCodes.join(",") !== deleted.expectedTopLevelMenuCodes.join(",")) {
  failures.push(`메뉴 상위 구조 불일치: [${topLevelCodes.join(", ")}] != [${deleted.expectedTopLevelMenuCodes.join(", ")}]`);
}

if (failures.length) {
  console.error(["Page registration check failed:", ...failures.map((failure) => `- ${failure}`)].join("\n"));
  process.exit(1);
}

console.log(
  `Page registration OK: ${routes.length} pages, ${menuEntries.length} menu leaves, ` +
    `${deleted.forbiddenRoutes.length} deleted routes / ${deleted.forbiddenCodes.length} deleted codes guarded`,
);
