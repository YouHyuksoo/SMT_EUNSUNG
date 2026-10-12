/**
 * @file dashboard-value-stream.structure.test.mjs
 * @description 대시보드(공정 흐름) 구조 테스트 — 페이지 얇기, 데이터 소스, 탭 숨김 시 타이머 금지, 디자인 금지 규칙,
 *              조치 큐 이동 경로가 실제 메뉴에 있는지, i18n 4언어 키 동기화
 * 실행: node --test "apps/frontend/src/app/(authenticated)/dashboard/dashboard-value-stream.structure.test.mjs"
 */
import { readFileSync, readdirSync, existsSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";
import { test } from "node:test";
import assert from "node:assert/strict";

const __dirname = dirname(fileURLToPath(import.meta.url));
const read = (p) => readFileSync(join(__dirname, p), "utf8");

const page = read("page.tsx");
const hook = read("components/useDashboardData.ts");
const attention = read("components/buildAttention.ts");
const stageViews = read("components/stageViews.ts");
const skins = read("components/skins.ts");
const layouts = read("components/layouts.ts");

const componentDir = join(__dirname, "components");
const tsxSources = readdirSync(componentDir).filter((f) => f.endsWith(".tsx")).map((f) => [f, read(`components/${f}`)]);
tsxSources.push(["page.tsx", page]);
const allSources = [...tsxSources, ["stageViews.ts", stageViews], ["buildAttention.ts", attention], ["useDashboardData.ts", hook]];

test("페이지는 배선만: 데이터 훅/큐 빌더를 소비하고, 구 카드 그리드를 쓰지 않는다", () => {
  assert.match(page, /useDashboardData\(\)/);
  assert.match(page, /buildAttention\(data, nowHour\)/);
  assert.doesNotMatch(page, /StatusCard/, "구 카드 그리드 컴포넌트를 사용하면 안 됩니다.");
  assert.ok(!existsSync(join(componentDir, "InspectRails.tsx")), "은성은 점검 데이터가 없어 InspectRails 를 두지 않습니다.");
  for (const f of ["CockpitLayout", "BoardLayout", "FlowMapLayout", "ChartsLayout"]) {
    assert.match(page, new RegExp(`import ${f} from`), `${f} 가 page 에 연결돼야 합니다.`);
  }
});

test("형태 4종 + 스킨 레지스트리 + localStorage 키", () => {
  assert.match(layouts, /DASHBOARD_LAYOUT_IDS = \["cockpit", "board", "map", "charts"\]/);
  assert.match(layouts, /DASHBOARD_LAYOUT_STORAGE_KEY = "dashboard:layout"/);
  assert.match(skins, /DASHBOARD_SKIN_STORAGE_KEY = "dashboard:skin"/);
  for (const id of ["control", "departure", "datawall", "white"]) assert.match(skins, new RegExp(`id: "${id}"`));
  assert.match(skins, /DASHBOARD_DEFAULT_SKIN: DashboardSkinId = "white"/);
  assert.match(page, /useTvMode\(\)/, "TV 모드가 있어야 합니다.");
  assert.match(page, /MOTION_CSS/);
});

test("데이터 소스: API 5개 병렬(allSettled) + 로컬 날짜 + 탭 숨김 시 타이머 중지", () => {
  for (const url of ['"/dashboard/summary"', '"/dashboard/insights"', '"/monitoring/boards/production"', '"/monitoring/boards/quality"', '"/monitoring/boards/inventory"']) {
    assert.match(hook, new RegExp(url.replace(/[/]/g, "\\/")), `${url} 호출이 있어야 합니다.`);
  }
  assert.doesNotMatch(hook, /boards\/equipment/, "설비 보드 응답 형태에 의존하지 않는다 (summary 사용).");
  assert.match(hook, /Promise\.allSettled/, "일부 API 실패 시에도 나머지를 표시해야 합니다.");
  assert.match(hook, /prev\.summary/, "실패한 API 는 이전 값을 유지해야 합니다.");
  assert.match(hook, /getTodayLocal/, "오늘 날짜는 로컬 기준 헬퍼를 써야 합니다 (toISOString 금지).");
  assert.doesNotMatch(hook, /toISOString\(\)/);
  assert.match(hook, /useActiveInterval\(/, "자동 갱신은 useActiveInterval 이어야 합니다.");
  assert.match(hook, /REFRESH_MS = 60_000/);
  for (const [name, src] of allSources) {
    assert.doesNotMatch(src, /\bsetInterval\(/, `${name}: 숨겨진 탭에서도 도는 setInterval 금지 (useActiveInterval 사용)`);
  }
  assert.doesNotMatch(page, /useNow\(/, "page 는 공용 useNow(항상 도는 1초 타이머) 대신 HeaderClock 을 쓴다.");
});

test("HANES 전용 개념(점검·소모품·작업지시)이 남아 있지 않다", () => {
  for (const [name, src] of allSources) {
    assert.doesNotMatch(src, /InspectRails|consumableSafety|summary\??\.job\b|summary\??\.daily|summary\??\.pm\b|summary\??\.mat\b|inspectFail|inspectNotDone/, `${name}: HANES 전용 개념 잔재`);
  }
});

test("조치 큐: 심각도 정렬 + 0건 제외 + 은성 데이터로 판정 가능한 항목", () => {
  assert.match(attention, /critical: 0, high: 1, medium: 2, low: 3/);
  assert.match(attention, /\.sort\(/);
  for (const key of ["equipDown", "solderNg", "mslNg", "defectPending", "defectUnrepaired", "lowAchieveSmd", "lowAchieveProduct", "expiredLot", "holdStock", "shortage", "nearExpiry"]) {
    assert.match(attention, new RegExp(`key: "${key}"`), `조치 항목 ${key} 가 있어야 합니다.`);
  }
  assert.match(attention, /LOW_ACHIEVE_PCT/);
  assert.match(attention, /LOW_ACHIEVE_AFTER_HOUR/);
});

test("이동 경로(href)는 menuConfig.ts 에 실제 있는 화면이다", () => {
  const menu = readFileSync(join(__dirname, "../../../config/menuConfig.ts"), "utf8");
  const menuPaths = new Set([...menu.matchAll(/path:\s*"(\/[^"]+)"/g)].map((m) => m[1]));
  const hrefSources = [attention, stageViews, read("components/LineRails.tsx")];
  const hrefs = new Set();
  for (const src of hrefSources) for (const m of src.matchAll(/href[=:]\s*[{]?\s*"(\/[^"]+)"/g)) hrefs.add(m[1]);
  assert.ok(hrefs.size >= 8, "이동 경로가 충분히 추출되어야 합니다.");
  for (const h of hrefs) assert.ok(menuPaths.has(h), `${h} 는 menuConfig.ts 에 없는 경로입니다.`);
});

test("디자인 규칙: 파스텔 배경·hex 리터럴·그라디언트 카드·브라우저 다이얼로그 금지", () => {
  for (const [name, src] of tsxSources) {
    assert.doesNotMatch(src, /bg-[a-z]+-50\b/, `${name}: 파스텔 -50 배경 금지`);
    assert.doesNotMatch(src, /#[0-9a-fA-F]{6}\b/, `${name}: hex 색상 리터럴 금지 (의미 토큰 사용)`);
    assert.doesNotMatch(src, /bg-gradient-to/, `${name}: 그라디언트 카드 금지`);
    assert.doesNotMatch(src, /\balert\(|\bconfirm\(|\bprompt\(/, `${name}: 브라우저 다이얼로그 금지`);
  }
});

test("i18n: 4언어 dashboard 블록 키 구조 동일 + 코드에서 쓰는 키가 ko 에 존재", () => {
  const localeDir = join(__dirname, "../../../locales");
  const keysOf = (obj, prefix = "") =>
    Object.entries(obj).flatMap(([k, v]) => (v && typeof v === "object" ? keysOf(v, `${prefix}${k}.`) : [`${prefix}${k}`]));
  const ko = JSON.parse(readFileSync(join(localeDir, "ko.json"), "utf8"));
  const koKeys = keysOf(ko.dashboard).sort();
  for (const lang of ["en", "zh", "vi"]) {
    const raw = readFileSync(join(localeDir, `${lang}.json`), "utf8");
    assert.ok(!raw.startsWith("﻿"), `${lang}.json 에 BOM 금지`);
    const other = JSON.parse(raw);
    assert.deepEqual(keysOf(other.dashboard).sort(), koKeys, `${lang}.json dashboard 키가 ko 와 같아야 합니다.`);
  }

  const allSrc = allSources.map(([, s]) => s).join("\n");
  const used = new Set([...allSrc.matchAll(/\bt\(\s*["'`](dashboard\.[a-zA-Z0-9.]+)["'`]/g)].map((m) => m[1]));
  const koSet = new Set(koKeys.map((k) => `dashboard.${k}`));
  assert.ok(used.size > 20, "사용 키가 충분히 추출되어야 합니다.");
  for (const k of used) assert.ok(koSet.has(k), `ko.json 에 ${k} 키가 없습니다.`);

  // 동적 키: dashboard.stream.{stage}, {stage}Hero 가 아닌 key 는 stageViews 가 직접 지정 — 단계명만 확인
  for (const s of ["stock", "material", "smd", "product", "quality"]) assert.ok(koSet.has(`dashboard.stream.${s}`), `stream ${s} 키 누락`);
  for (const k of ["equipInUse", "equipDown", "equipNotUsed"]) assert.ok(koSet.has(`dashboard.${k}`), `${k} 키 누락`);
  for (const k of ["equipDown", "solderNg", "mslNg", "defectPending", "defectUnrepaired", "lowAchieveSmd", "lowAchieveProduct", "expiredLot", "holdStock", "shortage", "nearExpiry"]) {
    assert.ok(koSet.has(`dashboard.attention.${k}`), `attention ${k} 키 누락`);
  }
  for (const k of ["RUNNING", "DONE", "WAITING", "HOLD"]) assert.ok(koSet.has(`dashboard.board.state.${k}`), `board.state.${k} 키 누락`);
  for (const k of ["layout.cockpit", "layout.board", "layout.map", "layout.charts", "skin.control", "skin.departure", "skin.datawall", "skin.white"]) {
    assert.ok(koSet.has(`dashboard.${k}`), `${k} 키 누락`);
  }
});
