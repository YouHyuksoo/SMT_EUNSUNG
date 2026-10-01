# 체크리스트 — 실적 구 테이블 복원 + 센서 프로시저 연계

계획: `docs/plans/2026-09-30-work-result-restore-sensor-proc.md`

## 1. 복원 DDL

- [x] `apps/backend/src/migrations/2026-09-30_restore_work_result.sql` 작성
      (원본 DDL + `SENSOR_APPLY_YN` + `SENSOR_APPLY_MSG` + 코멘트)
- [x] DDL 적용 — **es_mesi(192.168.175.100/XE) 완료** (2026-09-30 13:4x)
      - PRE: 테이블 0건 / 휴지통 0건 / 전체 테이블 600
      - 실행: `blocks_executed: 8`, 전부 success
      - POST: 테이블 1건 / 컬럼 16 / PK 1 / 컬럼주석 6 / 전체 테이블 601
      - 쿼리 검증: `results` 조회 0행 정상, `SEQ_NO` 첫 채번값 `01`, `list()` 집계 서브쿼리 3행 정상
- [-] DDL 적용 — ES_JSIDC는 **대상 제외** (2026-09-30 사용자 지시: ES_JSIDC 접속은 신경 쓰지 않음)

## 2. 백엔드

- [x] `product-work-result.entity.ts` 복원 (`6871e12^`에서 되살리고 컬럼 2개 추가)
- [x] `database.module.ts` 엔티티 배열에 `ProductWorkResult` 추가
- [x] `work-result.module.ts` `forFeature`를 `ProductWorkResult`로 교체
- [x] `oracle.service.ts` `callProcScalar`에 `options?: { autoCommit?: boolean }` 추가
      → 확인: 기존 호출부(`P_INTERLOCK_CHECK`) 무변경, `workstage-pass`·`oracle` 테스트 통과
- [x] `work-result.service.ts` 조회 3곳을 구 테이블로 교체 + `saveDefect`의 실적합계 1곳
      → 확인: `results`·`resultDetail` 응답에 `sensorApplyYn`/`sensorApplyMsg` 포함
- [x] `upsertResult` 구 테이블 upsert + `SEQ_NO` 작업지시별 2자리 채번
- [x] `DONE`일 때만 프로시저 호출 + 결과를 `SENSOR_APPLY_YN`/`MSG`에 기록
- [x] `applySensor(runNo, seqNo)` 재반영 메서드 (이미 반영된 건은 거부)
- [x] `work-result.dto.ts` `ApplySensorDto`
- [x] `work-result.controller.ts` `POST results/apply-sensor`
- [x] 백엔드 테스트 갱신 + 신규 5건 추가

## 3. 프론트엔드

- [x] `ResultRow`에 `sensorApplyYn`·`sensorApplyMsg` 추가
- [x] 이력 처리구분 셀 — `DONE` + 미반영이면 빨간색, `title`에 `P_OUT` 원문
- [x] '실적 이력' 타이틀 옆 `실적반영` 버튼 (선택 실적이 완료 + 미반영일 때만 활성)
- [x] 저장 응답의 `sensorWarning` 경고 토스트

## 4. 검증

- [x] `pnpm --filter @eunsung/frontend exec tsc --noEmit --pretty false` — 오류 없음
- [x] `pnpm --filter @eunsung/backend exec tsc --noEmit --pretty false` — 오류 없음
- [x] `pnpm --filter @eunsung/backend test` — 11 실패 / 104 통과.
      기준선(변경 전 stash)도 11 실패 / 67건으로 동일. 실패 스위트는 auth·inventory·master·
      system·architecture 계열로 이 작업과 무관하다. 통과 테스트가 885 → 890으로 5건 늘었다.
- [x] `pnpm --filter @eunsung/frontend test` — 1/1 통과
- [ ] 화면 왕복 — 등록(WIP) → 수정(DONE) → 프로시저 반영 → 실패 시 빨간색 → `실적반영` 재시도
      es_mesi에는 DDL 적용 완료. **es_mesi가 사내망 전용이라 사외에서는 백엔드가 기동되지 않아 미검증**

## 5. 커밋

- [x] `d0ec666b` 계획·체크리스트·노트 + 복원 DDL
- [x] `b43000dc` 백엔드 — 원장 교체 + 프로시저 연계 + autoCommit 옵션
- [x] `08c49c6e` 프론트 — 빨간색 표기 + `실적반영` 버튼

## 6. 추가 수정 (2026-09-30 오후)

- [x] `364735a3` 라인 조회조건에서 라인구분 SMT(코드 `D`·`SMT`) 제외 — 콤보 + 목록 조회(`excludeSmt=Y`).
      제외 코드는 `@smt/shared` `SMT_LINE_DIVISIONS`. 이 화면에만 적용
- [x] `1434b2cf` 설비비가동 패널 — 작업지시를 골라도 다른 설비로 검색·변경 가능.
      작업지시 설비가 아닌 설비로 등록하면 RUN_NO 없이 저장. 모니터링 탭은 기존처럼 고정
- [x] 검증 — 프론트·백엔드 tsc 통과, work-result 테스트 14/14 통과.
      lint 오류 3건(`set-state-in-effect`)은 변경 전부터 있던 것
- [ ] 화면 확인 — 두 건 모두 es_mesi 접속 후 확인 필요
- [ ] es_mesi에 공정그룹 `PBA` 설비가 있는지 확인 (esh_mes는 0건 → 콤보가 비면 검색 불가처럼 보임)

## 미결

- [x] DDL 적용 대상 확정 — es_mesi만 (ES_JSIDC 제외)
- [-] ES_JSIDC 휴지통 확인 — 대상 제외
- [ ] 2026-09-02 이후 `IP_PRODUCT_SENSOR_ACTUAL` 수기 실적 역이관 여부
