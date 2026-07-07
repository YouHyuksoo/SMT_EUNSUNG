# 세션 핸드오프 — 은성전장 MES (2026-07-08)

다음 세션(또는 다른 에이전트)이 이어서 작업하기 위한 현재 상태 요약.
중복은 피하고 spec/plan/커밋을 경로로 참조한다.

## 0. 환경 핵심 (먼저 읽을 것)

- **모노레포**: pnpm + turborepo. `apps/backend`(@eunsung/backend, NestJS 3003), `apps/frontend`(@eunsung/frontend, Next 3100), `packages/shared`(@smt/shared).
- **DB**: 은성 외부 Oracle. oracle-db 스킬 사이트명 **`ESDBext`** (61.105.35.54:1521/XE, INFINITY21_JSMES). 구버전 verifier라 **thick client 필수**.
  - 백엔드: `apps/backend/.env`(untracked) + TypeORM. 프론트 레거시 display: `apps/frontend/config/database.json`(untracked, activeProfile=은성전장외부).
- **서버는 사용자가 직접 기동**한다(임의 기동/재시작 금지). 필요하면 명령만 제시. dev는 `--watch`라 코드 저장 시 자동 반영됨.
- 로그인 계정 예: `ADMIN`/`12351235`, `KSW`/`5361` (ISYS_USERS). 토큰 = USER_ID.
- 회사코드는 **EUNSUNG**(ISYS_ORGANIZATION.COMPANY_CODE, ISYS_COMPANY와 정합). 변경 후 재로그인 필요.

## 1. 이번 세션에서 한 일 (전부 커밋·푸시됨, origin/main)

git log 참조. 주요 커밋:
- `f2d80c1`~ 이전: HANES UI 마이그레이션(기존)
- 백엔드/로그인: HANES `apps/backend` 통째 복사 → 은성 개조. auth를 `ISYS_USERS/ISYS_ORGANIZATION` 기반으로 재작성. 로그인 화면 은성화(회사/사업장·회원가입 제거, 아이디 입력).
- `be96f86` refactor(menu): 보세관리·영업관리·계측기관리·자재 입하/입고 메뉴·페이지 제거
- OEE: `883aa52`(DDL) `a239f73`(calc/validation) `2808de4`(입력 백엔드) `49d28b3`(입력 화면/메뉴) `8f29034`(집계층: 확장테이블·뷰·프로시저)
- menu-categories: `00e64d5`(테이블) `e531df0`(모듈 활성화+은성 가드)
- `754eb57` fix(menu): DB 메뉴트리 비면 menuConfig 폴백 + 회사코드 EUNSUNG

## 2. 확립된 아키텍처 규약 (반드시 준수)

- **Lean 백엔드**: `apps/backend`는 HANES 전체를 복사했지만, `tsconfig.json`의 **`include` allowlist**로 활성 모듈만 컴파일한다(auth, oee, menu-categories + 인프라). 전체 모듈 구성은 `apps/backend/src/app.module.full.ts.bak` 보존.
  - **화면/모듈을 하나씩 은성화**하며 activate: ① `app.module.ts` imports에 모듈 추가 ② `database.module.ts` entities 배열에 엔티티 추가 ③ `tsconfig.json` include에 모듈/엔티티 경로 추가 ④ 필요한 공유 provider(예: `TransactionService`)를 모듈 providers에 직접 등록.
- **은성 인증 가드**: `apps/backend/src/common/guards/jwt-auth.guard.ts` — Bearer 토큰=USER_ID → ISYS_USERS 검증, USER_LEVEL→role, req.user에 `{id,email,role,organizationId,company,plant}`. 인증 필요한 컨트롤러는 `@UseGuards(JwtAuthGuard)` 명시(전역 GuardModule 미사용). menu-categories는 organizationId로 tenant 스코핑.
- **엔티티 매핑**: TypeORM. IDENTITY PK는 **단건 insert**로 넣을 것(다중행 insert는 PK NULL 바인딩 오류 — `oee-log.service.ts` 참고). DATE에 시각 보존 필요하면 `type:'timestamp'`.
- **프론트 API**: `api`(axios, baseURL `/api`) → Next rewrite → `:3003/api/v1/*`. 응답 envelope `{success,data,...}`. SWR fetcher: `api.get(u).then(r=>r.data?.data??r.data)`.
- **공유 계산/검증**: `@smt/shared`(빌드 필요 `pnpm --filter @smt/shared build`). OEE calc/validation은 `@smt/shared/oee`(또는 루트 export).
- **삭제/정리**: 라우트 삭제 후 `node apps/frontend/scripts/gen-page-registry.mjs` 재생성. menuConfig·locales(ko/en/vi/zh) 동기. tsc로 검증.

## 3. OEE 현황 (spec/plan은 아래 참조)

- 근거: `docs/specs/2026-07-06-oee-management-design.md`, `docs/plans/2026-07-06-oee-{foundation,input,dashboard}.md`
- **주의**: plan 문서들은 마이그레이션 전 WebDisplay 구조(src/lib, /display/[screenId], cards.json) 전제. **현재는 NestJS+authenticated로 재배치**하기로 확정(도메인 설계는 spec 그대로).

완료:
- **Plan 1**: OEE 테이블 5종 + `@smt/shared` calc/validation(테스트 13). `oracle_db_scripts/oee/01_tables.sql,02_seed_reason.sql`.
- **Plan 2**: 백엔드 `apps/backend/src/modules/oee`(엔티티 3종 + 마스터/가동일지 API, `/api/v1/oee/{resource,reason,log}`) + 프론트 `apps/frontend/src/app/(authenticated)/oee/{entry,master/resource,master/reason}` + menuConfig OEE + `useOeeProfile`.
- **Plan 3 데이터층**: `oracle_db_scripts/oee/03_tables_ext.sql`(확장 5종+summary컬럼), `04_view_plan_time.sql`(V_OEE_PLAN_TIME), `05_view_live.sql`(V_OEE_LIVE), `06_proc_build_summary.sql`(P_OEE_BUILD_SUMMARY). ESDBext 배포·검증(OEE 계산·정합성). **프로시저는 `deploy_plsql.py`로 배포**(execute-file은 프로시저 본문 잘림).

남은 OEE (Plan 3 앱층):
- **대시보드 44/45/46**: NestJS dashboard 모듈(당일=V_OEE_LIVE, 과거=OEE_DAILY_SUMMARY, 스냅샷부재 409 `OEE_SUMMARY_NOT_BUILT`; 로스파레토=OEE_OPERATION_LOG) + `(authenticated)/oee` Recharts 화면 3종. (plan은 display/[screenId] 44~46이지만 authenticated 페이지로 재배치.)
- **잔여 입력화면**: 근무시간 마스터(`/oee/master/worktime`), 입력화면 수량 섹션(OEE_PRODUCTION_RESULT + plan-time 자동로드), 원자재준비/고객불량 입력.
- 스케줄러(P_OEE_BUILD_SUMMARY 정기 실행)는 선택(스펙 §11).

## 4. 기타 대기 작업

- **`/master/part → ID_ITEM`**: master(part) 백엔드 슬라이스를 은성화(활성화 + ID_ITEM 테이블 매핑)하고 화면 검증. (§2 activate 절차 준수)
- menu-categories 사이드바를 실제 DB 기반으로 쓰려면 MENU_CATEGORIES/ITEMS를 menuConfig로 시드해야 함(현재는 비어 있어 menuConfig 폴백). 테이블 PK가 COMPANY/PLANT_CD인데 컨트롤러는 organizationId 스코핑으로 리팩터링됨 — **정합성 확인 필요**(다른 에이전트 변경).
- 후속 정리(앱 영향 없음): 백엔드 seed/validator의 삭제 메뉴코드(customs/sales/gauge/material 입하), workflowMap/workflowConfig 죽은 링크.

## 5. 주의 (다른 에이전트 병렬 변경 감지됨)

작업트리에 내가 만들지 않은 변경 존재(ai-knowledge.service.ts, quality/inspection 삭제, seeds, CLAUDE.md 갱신, menu-categories organizationId 리팩터링 등). **되돌리지 말 것.** 커밋 시 의도한 파일만 스테이징.

## 다음 세션 추천 스킬
- `oracle-db`(ESDBext DDL/PLSQL), `frontend-design`(대시보드 UI), `superpowers:executing-plans`(oee-dashboard.md 이어서), `managing-docs`(문서 최신화).
