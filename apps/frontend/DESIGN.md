---
name: Eunsung MES Landing
description: 은성전장 MES 랜딩페이지(/) 시각 규칙. 업무 화면·display 화면은 이 문서 범위가 아니다.
---

# DESIGN.md — 랜딩페이지 (`/`) 전용

범위: `src/app/page.tsx`, `src/app/components/Landing*.tsx`. 업무 화면(`(authenticated)`)과 모니터링 display는 대상이 아니다.

## 의도

- 사내 사용자가 MES에 들어가기 전에 보는 회사 소개 겸 진입 화면이다.
- 구성과 내용은 회사 홈페이지(http://eunsungele.com/)의 회사소개·제품소개·생산공정을 따른다.
- 내용은 회사 홈페이지에 게시된 사실(2010년 설립, PCB Ass'y·Brushcard Ass'y, 현대·기아자동차 1차 협력사, SMT·Soldering·Welding, 제품 3종)과 MES 화면에서 확인되는 범위(SPI·AOI·FCT·VISION)만 쓴다. 홈페이지에 없는 수치·공정 순서·구호는 넣지 않는다.

## 색

- 색은 앱 테마 토큰(`--primary`, `--background`, `--surface`, `--card`, `--border`, `--text`, `--text-muted`)만 쓴다. `ThemeSelector`로 고른 포인트 색과 라이트/다크가 랜딩에도 그대로 적용돼야 하므로 회사 홈페이지의 블루를 하드코딩하지 않는다.
- 강조색은 `primary` 한 가지다. 카드·아이콘별로 다른 색을 주지 않는다.
- 대비 위계: 제목 `text` > 본문 `text-muted` > 라벨(영문 eyebrow) `primary`. CTA 1개(로그인)만 `primary` 채움, 나머지 버튼은 `border` 외곽선.

## 타이포

- 앱 공통 `--font-sans`를 따른다. Noto Sans KR TTF(`public/fonts`, 각 6MB)는 PDF 출력용이라 랜딩 웹폰트로 쓰지 않는다.
- 역할: display `text-4xl~6xl bold`(히어로), 섹션 제목 `text-3xl~4xl bold`, 영문 eyebrow `text-xs semibold tracking-[0.2em]`, 본문 `text-base~lg`, 번호 `font-mono`.

## 레이아웃

- 좌측 정렬, 12컬럼 비대칭(7:5, 5:6). 중앙 정렬 히어로를 쓰지 않는다.
- 섹션 순서: 헤더 → 히어로(소개 + 관리 범위 패널) → 회사소개(`#company`) → 제품·생산기술(`#products`) → MES 기능(`#modules`) → 푸터.
- 섹션 여백 `py-20 lg:py-28`, 좌우 `px-4 sm:px-6`, 최대폭 `max-w-7xl`. 섹션 경계는 `border-t border-border`, 교대로 `bg-surface/50`.
- 앵커 대상 섹션은 고정 헤더(64px) 만큼 `scroll-mt-16`.
- 목록형 정보는 카드 여러 개 대신 `gap-px bg-border` 격자 표로 묶는다.

## 컴포넌트 규칙

- **로그인 버튼은 인증 여부와 관계없이 항상 표시**한다(헤더·히어로). 로그인 상태면 대시보드 버튼을 옆에 추가한다.
- 배경 장식은 `--border` 색 격자 한 겹만 쓴다. 외부 이미지 금지(현장망 오프라인, 외부 호스트 의존 금지).
- 히어로 우측 "관리 범위"는 카드 3장 덱(`LandingScopeDeck`)이다. 겹친 상태에서 부채꼴로 펼쳐지고(하단 피벗, ±8°, hover 시 ±14°), 앞 카드 진행 막대(4초)가 끝나면 다음 카드로 넘어간다. hover 중엔 막대와 순환이 멈추고, 카드·탭 클릭으로 앞 카드를 고른다.
- 히어로 텍스트 등장은 gsap 1회. `prefers-reduced-motion`이면 등장·펼침·순환을 모두 끈다.

## 금지

- 중앙 정렬 히어로 + 중앙 CTA, 몽환적 블룸/그라데이션 오브, 글래스모피즘 카드
- 근거 없는 수치 통계("16+", "100%"), 영문/한글 캐치프레이즈
- 카드별 무지개 아이콘 색, 마우스 3D 틸트
- `href="#"` 같은 동작하지 않는 링크

구조 검사: `node --test apps/frontend/src/app/components/landing.structure.test.mjs`
