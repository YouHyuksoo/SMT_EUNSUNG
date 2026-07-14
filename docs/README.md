---
standardVersion: 1
---

# Docs Manifest — 문서 표준 규정 (단일 출처)

이 파일은 이 프로젝트 `docs/`의 규정이다. AI/사람 구분 없이 docs 아래 문서를
생성·이동·삭제할 때 이 규정을 따른다. 관리 명령은 Claude `managing-docs` 스킬
(init/new/audit/sync/upgrade)이 제공하지만, 규정 자체는 도구 중립이다.

<!-- COMMON:START (upgrade가 이 블록만 교체한다 — 직접 수정 금지) -->

## 분류체계 (core 9)

| 폴더 | 용도 | 명명규칙 | 계층 |
|---|---|---|---|
| adr/ | 아키텍처 결정기록 | `NNNN-kebab-제목.md` | 기록형 |
| specs/ | 설계문서 (구현 전 의도) | `YYYY-MM-DD-주제-design.md` | 기록형 |
| plans/ | 구현계획 | `YYYY-MM-DD-주제.md` | 기록형 |
| standards/ | 코드·업무 규칙, 컨벤션, 절차 | `kebab-case.md` | 살아있음 |
| design/ | UI 디자인 시스템 (화면 공용화·표준화 규칙) | overview/theme/layout/buttons/data-grid/navigation/modals/forms.md | 살아있음 |
| database/ | 데이터 계층 문서 (스키마/ERD/컬럼 도메인/엔티티 설계) | `kebab-case.md` | 살아있음 |
| business-logics/ | 화면/기능 단위 로직·데이터 흐름 분석 (구현 후 실측) | `MENU_CODE.md` 또는 `kebab-case.md` | 살아있음 |
| guides/ | 설치·운영·사용 가이드 | `kebab-case.md` | 살아있음 |
| reports/ | 산출물·감사·미완료기록 | `YYYY-MM-DD-주제.md` 또는 주제 폴더 | 기록형 |

## 공통 규칙

1. docs 루트에 md 파일 금지 (이 README 제외). 임시 문서는 docs가 아니라 작업 스크래치.
2. 아래 등록부에 없는 특화 폴더 생성 금지. 필요하면 등록부에 먼저 추가.
3. **살아있는 문서**(standards/design/database/business-logics/guides)는 frontmatter에
   `sources`(설명 대상 소스 경로 목록)와 `verifiedCommit`(마지막 대조 커밋)을 선언한다.
   소스가 바뀌면 문서도 동기화 대상이 된다 (`managing-docs sync`).
4. **기록형 문서**(adr/specs/plans/reports)는 작성 시점 기록이다 — 사후 수정하지 않는다.
5. 경계 판단: specs=구현 전 설계 / business-logics=구현 후 실측. standards=코드·절차 / design=화면.

<!-- COMMON:END -->

<!-- LOCAL:START (프로젝트 소유 — upgrade가 건드리지 않는다) -->

## 특화 폴더 등록부

| 폴더 | 용도 | 명명규칙 |
|---|---|---|
| sql/ | 화면/기능 개발 근거가 된 Oracle SQL·PL-SQL 원본 스냅샷 (기록형) | `대문자_함수명.sql` 또는 `kebab-case.sql` |
| test-checklists/ | 구현 후 수동 검증 체크리스트 (기록형) | `YYYY-MM-DD-주제.md` |
| presentations/ | 발표·데모용 렌더 산출물 (계획/설계문서의 발표본, HTML·PDF·PPTX 등, 기록형) | `YYYY-MM-DD-주제.html` (또는 `.pdf`/`.pptx`) |

## 외부 문서 집합 (위치를 앱이 결정하는 문서)

| 위치 | 용도 | 관리 규정 (audit 점검 명령 포함) |
|---|---|---|
| 루트 `CONTEXT.md` (다중 컨텍스트면 루트 `CONTEXT-MAP.md` + 모듈별 `apps/**/CONTEXT.md`) | 도메인 용어집(ubiquitous language) — 용어·경계·불변식을 적는 **살아있는 문서**. `/grill-with-docs`·`/wayfinder`가 용어가 확정되는 순간 갱신한다. | audit: CONTEXT.md가 있으면 코드 최신 상태와 용어 정합성을 확인. 결정 **근거**(왜 이렇게 정했나)는 여기 적지 말고 core `adr/`에 남긴다. |

## 프로젝트 참고사항

- 이 저장소는 은성전장 MES Display (은성전장 현장 Next.js 모니터링 앱)의 문서 루트다.
- 과거 superpowers 계열 스킬이 `docs/superpowers/{plans,specs,sql,test-checklist}`에 저장하던 문서는
  2026-07-05 표준 폴더(`plans/`, `specs/`, `sql/`, `test-checklists/`)로 흡수했다. 이후 spec/plan은
  `docs/superpowers/`가 아니라 core 폴더에 직접 생성한다.
- `config/database.json`은 자격증명 포함 — git 미추적. 관련 스키마 문서는 `database/`에 둔다.
- 도메인 지식은 두 곳으로 나눈다: **용어/경계**는 루트 `CONTEXT.md`(외부 문서 집합), **결정 근거**는 core `adr/`.
  `/grill-with-docs`·`/wayfinder`가 이 둘을 갱신하며, mattpocock 계열 스킬의 `CONTEXT.md`+`docs/adr/` 컨벤션과 그대로 맞물린다.

<!-- LOCAL:END -->
