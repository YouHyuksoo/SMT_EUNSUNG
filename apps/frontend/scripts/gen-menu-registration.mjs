/**
 * @file gen-menu-registration.mjs
 * @description menuConfig.ts(단일 소스)에서 백엔드 메뉴 등록 3파일을 생성한다.
 *   - apps/backend/src/modules/menu-categories/utils/menu-code-validator.ts
 *   - apps/backend/src/modules/menu-categories/utils/default-menu-category-layout.ts
 *   - apps/backend/src/seeds/menu-config.json
 *
 * 메뉴 추가·삭제 시 menuConfig.ts만 편집하면 이 스크립트가 나머지를 동기화한다.
 * gen-page-registry.mjs 와 함께 `pnpm test`/dev 파이프라인에서 실행된다.
 */
import { readFileSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const scriptDir = dirname(fileURLToPath(import.meta.url));
const frontendRoot = join(scriptDir, "..");
const repoRoot = join(frontendRoot, "..", "..");
const menuConfigPath = join(frontendRoot, "src", "config", "menuConfig.ts");

// --- menuConfig.ts 파싱: icon(React 컴포넌트) 제거 후 배열 리터럴을 평가한다 ---
function parseMenuConfig(source) {
  const marker = source.indexOf("export const menuConfig");
  if (marker < 0) throw new Error("menuConfig 선언을 찾지 못했습니다.");
  // `=` 이후의 `[` (타입 주석 MenuConfigItem[] 의 `[]` 를 건너뛴다)
  const eq = source.indexOf("=", marker);
  const arrStart = source.indexOf("[", eq);
  let depth = 0;
  let end = -1;
  for (let i = arrStart; i < source.length; i++) {
    if (source[i] === "[") depth++;
    else if (source[i] === "]" && --depth === 0) { end = i; break; }
  }
  if (end < 0) throw new Error("menuConfig 배열의 끝을 찾지 못했습니다.");
  const literal = source.slice(arrStart, end + 1).replace(/icon:\s*\w+,?/g, "");
  // 배열 리터럴은 문자열/중첩배열/객체만 남아 순수 데이터가 된다.
  return new Function(`return ${literal};`)();
}

const menu = parseMenuConfig(readFileSync(menuConfigPath, "utf8"));
const categories = menu.map((cat) => ({
  code: cat.code,
  labelKey: cat.labelKey,
  children: (cat.children ?? []).map((child) => child.code),
}));
const leafCodes = categories.flatMap((cat) => cat.children);

const banner = (summary) =>
  `/**\n` +
  ` * @file AUTO-GENERATED — 직접 편집하지 마세요.\n` +
  ` * @description ${summary}\n` +
  ` * Source: apps/frontend/src/config/menuConfig.ts\n` +
  ` * Regenerate: pnpm --filter @eunsung/frontend gen:menu (또는 pnpm --filter @eunsung/frontend test)\n` +
  ` */\n`;

// 1) menu-code-validator.ts — leaf 코드 화이트리스트
const validatorTs =
  banner("메뉴 코드 유효성 검증 화이트리스트 (menuConfig leaf 코드)") +
  `const KNOWN_LEAF_CODES: ReadonlySet<string> = new Set<string>([\n` +
  leafCodes.map((code) => `  '${code}',`).join("\n") +
  `\n]);\n\n` +
  `export function isValidMenuCode(code: string): boolean {\n` +
  `  return KNOWN_LEAF_CODES.has(code);\n}\n\n` +
  `export function listKnownMenuCodes(): string[] {\n` +
  `  return Array.from(KNOWN_LEAF_CODES);\n}\n`;

// 2) default-menu-category-layout.ts — 카테고리 기본 레이아웃
const layoutTs =
  banner("기본 메뉴 카테고리 레이아웃 (menuConfig 카테고리 구조)") +
  `export interface DefaultMenuCategoryLayout {\n` +
  `  categoryCode: string;\n  labelKey: string;\n  sortOrder: number;\n  menuCodes: readonly string[];\n}\n\n` +
  `export const DEFAULT_MENU_CATEGORY_LAYOUT: readonly DefaultMenuCategoryLayout[] = [\n` +
  categories
    .map((cat, index) => {
      const codes = cat.children.map((code) => `'${code}'`).join(", ");
      return `  { categoryCode: '${cat.code}', labelKey: '${cat.labelKey}', sortOrder: ${(index + 1) * 10}, menuCodes: [${codes}] },`;
    })
    .join("\n") +
  `\n];\n`;

// 3) seeds/menu-config.json — 시드용 카테고리/코드 매핑
const seedJson = {
  _comment: "AUTO-GENERATED from apps/frontend/src/config/menuConfig.ts — 직접 편집 금지. Regenerate: pnpm --filter @eunsung/frontend gen:menu",
  topMenuCodes: categories.map((cat) => cat.code),
  childMenuCodes: Object.fromEntries(categories.map((cat) => [cat.code, cat.children])),
};

const targets = [
  ["apps/backend/src/modules/menu-categories/utils/menu-code-validator.ts", validatorTs],
  ["apps/backend/src/modules/menu-categories/utils/default-menu-category-layout.ts", layoutTs],
  ["apps/backend/src/seeds/menu-config.json", `${JSON.stringify(seedJson, null, 2)}\n`],
];
for (const [rel, content] of targets) writeFileSync(join(repoRoot, rel), content);

console.log(
  `Generated backend menu registration from menuConfig → ${categories.length} categories, ${leafCodes.length} leaf codes`,
);
