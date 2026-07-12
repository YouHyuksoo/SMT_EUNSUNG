---
sources:
  - CLAUDE.md
  - AGENTS.md
  - docs/README.md
  - apps/backend/src/database/
  - apps/frontend/src/lib/screens.ts
verifiedCommit: 1bd1735
---

# CONTEXT — 은성 MES 도메인 용어집 (ubiquitous language)

이 문서는 은성 MES(`eunsung-mes`)의 **공용 언어**다. 사람과 코드가 같은 뜻으로 쓰는
용어·경계·불변식을 여기 적는다. **결정의 근거(왜 이렇게 정했나)는 여기가 아니라
`docs/adr/`에 남긴다.**

- 살아있는 문서다 — 용어가 확정되는 순간 `/grill-with-docs`·`/wayfinder`가 갱신한다.
- 아래 용어집은 **이미 확립·문서화된 것만** 담은 seed다. 도메인 엔티티의 정밀한 의미는
  아직 비어 있고, grilling 세션에서 하나씩 확정해 채운다 (추측으로 채우지 않는다).

## 시스템 개요 (검증된 사실)

- **Site**: 은성전장 (EUNSUNG).
- **Shape**: pnpm + turborepo 모노레포 — NestJS 백엔드(`@eunsung/backend`, :3003) +
  Next.js 프론트엔드(`@eunsung/frontend`, :3100) + 공유 패키지(`@smt/shared`).
- **DB**: Oracle. 백엔드는 TypeORM으로 접속(스키마 `INFINITY21_JSMES`, 서비스 `XE`).
- **언어(UI)**: 한국어/영어/스페인어/베트남어.
- **도메인**: 생산 · 품질 · 재고 · 자재 · 설비 · OEE · 출하 · 외주 · 소모품 ·
  메뉴/권한 · 인터페이스 · AI.

## 용어집 — 확립된 것

| 용어 | 정의 | 근거 |
|---|---|---|
| **은성전장 / EUNSUNG** | 이 MES가 운영되는 사이트. 모노레포 이름 `eunsung-mes`. | CLAUDE.md |
| **Legacy Display** | 프론트엔드 안의 3D 메뉴 + `/display/[screenId]` 모니터링 화면 서브시스템. 백엔드 API가 아니라 Next API Route + `apps/frontend/src/lib/db.ts`로 Oracle에 직접 접속한다. | CLAUDE.md, screens.ts |
| **display screen** | `apps/frontend/src/lib/screens.ts`의 `SCREENS`에 등록된 모니터링 화면(예: `21` 제품생산현황, `42` FCT). | screens.ts |
| **업무일 (business day)** | 캘린더 자정이 아니라 **07:30 ~ 다음날 07:30**. FCT(`/display/42`) 집계 기준: `TRUNC(SYSDATE - 7.5/24) + 7.5/24`. | CLAUDE.md (FCT screen rules) |
| **MENU_CODE** | 화면/기능 단위 식별 코드. `docs/business-logics/<MENU_CODE>.md` 문서 단위이자 화면 로직 분석의 기준. | docs/README.md |
| **ESDB** | 은성 내부 Oracle 접속(내부 IP). | 접속 프로파일 |
| **ESDBEXT** | 은성 외부 Oracle 접속(외부 IP, `oracle-db` 스킬 프로파일 `ESDBext`). 내부와 포트·계정·서비스(XE) 동일. | 접속 프로파일 |

## 미확정 — grilling으로 채움

<!-- 아래는 아직 정밀 정의가 합의되지 않은 영역. /grill-with-docs 또는 /wayfinder 세션에서
     용어가 확정되는 순간 위 용어집으로 승격하고 이 목록에서 지운다. 추측으로 미리 채우지 않는다. -->

- 재고/수불 핵심 엔티티의 경계 (예: 창고 vs 위치, Lot/시리얼 단위, 입고/출고/이동/실사)
- 생산 단위 용어 (지시/작업/공정/라우팅 간 관계)
- OEE 계산에서 쓰는 시간·수량 정의 (가동/부하/정지/양품 기준 — `packages/shared` OEE 로직과 대조)
- 품질 판정 용어 (검사결과 코드, IQC/AQL 정책 등)
