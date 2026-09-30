# 체크리스트 — 실적 구 테이블 복원 + 센서 프로시저 연계

계획: `docs/plans/2026-09-30-work-result-restore-sensor-proc.md`

## 1. 복원 DDL

- [x] `apps/backend/src/migrations/2026-09-30_restore_work_result.sql` 작성
      (원본 DDL + `SENSOR_APPLY_YN` + `SENSOR_APPLY_MSG` + 코멘트)
- [ ] DDL 실제 적용 — **사용자 결정 대기** (ES_JSIDC 접속 불가, es_mesi 적용 여부 미정)
      → 검증: `USER_TABLES`에 테이블 존재, `USER_TAB_COLUMNS` 16건

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
      **DDL 미적용이라 아직 불가**

## 5. 커밋

- [x] `d0ec666b` 계획·체크리스트·노트 + 복원 DDL
- [x] `b43000dc` 백엔드 — 원장 교체 + 프로시저 연계 + autoCommit 옵션
- [x] `08c49c6e` 프론트 — 빨간색 표기 + `실적반영` 버튼

## 미결

- [ ] DDL 적용 대상 확정 (es_mesi 지금 / ES_JSIDC 복구 후)
- [ ] ES_JSIDC 휴지통 `BIN$koAumyN1TTaJP/V4de49KQ==$0` 생존 확인
- [ ] 2026-09-02 이후 `IP_PRODUCT_SENSOR_ACTUAL` 수기 실적 역이관 여부
