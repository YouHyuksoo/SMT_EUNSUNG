/**
 * 랜딩페이지 구조 테스트 (DESIGN.md "Landing" 규칙)
 * 실행: node --test apps/frontend/src/app/components/landing.structure.test.mjs
 */
import assert from "node:assert/strict";
import { existsSync, readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import test from "node:test";
import { fileURLToPath } from "node:url";

const dir = dirname(fileURLToPath(import.meta.url));
const read = (name) => readFileSync(join(dir, name), "utf8");

const LANDING_FILES = [
  "../page.tsx",
  "LandingHeader.tsx",
  "LandingHero.tsx",
  "LandingCompany.tsx",
  "LandingFeatures.tsx",
  "LandingFooter.tsx",
  "LandingSectionTitle.tsx",
  "LandingScopeDeck.tsx",
];

test("login button is rendered unconditionally in header and hero", () => {
  for (const name of ["LandingHeader.tsx", "LandingHero.tsx"]) {
    const src = read(name);
    assert.match(src, /onClick=\{onLogin\}/, `${name}: 로그인 버튼 없음`);
    assert.doesNotMatch(src, /isAuthenticated\s*\?/, `${name}: 인증 여부로 로그인 버튼을 바꾸면 안 됨`);
  }
});

test("no dead links, dreamy bloom, or per-card rainbow colors", () => {
  assert.equal(existsSync(join(dir, "DreamyBackground.tsx")), false);
  for (const name of LANDING_FILES) {
    const src = read(name);
    assert.doesNotMatch(src, /href=["']#["']/, `${name}: href="#" 금지`);
    assert.doesNotMatch(src, /DreamyBackground/, `${name}: DreamyBackground 사용 금지`);
    assert.doesNotMatch(src, /text-(blue|amber|green|purple|red|cyan)-\d{3}/, `${name}: 카드별 색 금지`);
    assert.doesNotMatch(src, /rgba?\(\s*\d/, `${name}: 하드코딩 색상 대신 테마 토큰 사용`);
  }
});

test("header anchors match section ids", () => {
  const header = read("LandingHeader.tsx");
  const body = read("LandingCompany.tsx") + read("LandingFeatures.tsx");
  const anchors = [...header.matchAll(/href: "#([a-z-]+)"/g)].map((m) => m[1]);
  assert.ok(anchors.length >= 3);
  for (const id of anchors) {
    assert.match(body, new RegExp(`id="${id}"[^>]*scroll-mt-16`), `#${id} 섹션 또는 scroll-mt 없음`);
  }
});

test("scope deck fans out, rotates, and respects reduced motion", () => {
  const deck = read("LandingScopeDeck.tsx");
  assert.match(read("LandingHero.tsx"), /<LandingScopeDeck \/>/);
  assert.match(deck, /prefers-reduced-motion: reduce/);
  assert.match(deck, /onAnimationEnd=\{next\}/, "순환은 진행 막대 종료에 맞춰야 함");
  assert.doesNotMatch(deck, /setInterval/, "막대와 별개 타이머 금지");
  assert.doesNotMatch(deck, /<button[^>]*>(?:(?!<\/button>)[\s\S])*<ul/, "button 안에 ul 금지");
});
