# 체크리스트 — 실적 구 테이블 복원 + 센서 프로시저 연계

계획: `docs/plans/2026-09-30-work-result-restore-sensor-proc.md`

## 1. 복원 DDL

- [ ] `apps/backend/src/migrations/2026-09-30_restore_work_result.sql` 작성
      (원본 DDL + `SENSOR_APPLY_YN` + `SENSOR_APPLY_MSG` + 코멘트)
      → 검증: 파일 내 `CREATE TABLE` 1개, 컬럼 16개
- [ ] DDL 실제 적용 — **사용자 결정 대기** (ES_JSIDC 접속 불가, es_mesi 적용 여부 미정)
      → 검증: `USER_TABLES`에 테이블 존재, `USER_TAB_COLUMNS` 16건

## 2. 백엔드

- [ ] `product-work-result.entity.ts` 복원 (`6871e12^`에서 되살리고 컬럼 2개 추가)
      → 검증: `tsc --noEmit` 통과
- [ ] `database.module.ts` 엔티티 배열에 `ProductWorkResult` 추가
      → 검증: 백엔드 기동 시 엔티티 오류 없음
- [ ] `work-result.module.ts` `forFeature`를 `ProductWorkResult`로 교체
      → 검증: `tsc --noEmit` 통과
- [ ] `oracle.service.ts` `callProcScalar`에 `options?: { autoCommit?: boolean }` 추가
      → 검증: 기존 호출부(`P_INTERLOCK_CHECK`) 무변경, `work-result`·`process-transaction` 테스트 통과
- [ ] `work-result.service.ts` 조회 3곳을 구 테이블로 교체 (`list` 집계 서브쿼리, `results`, `resultDetail`)
      → 검증: `results` 응답에 `sensorApplyYn` 포함
- [ ] `work-result.service.ts` `upsertResult` 구 테이블 upsert + `SEQ_NO` 작업지시별 채번
      → 검증: 같은 작업지시에 2건 등록 시 `01`, `02`
- [ ] `upsertResult`에서 `DONE`일 때만 프로시저 호출 + 결과로 `SENSOR_APPLY_YN`/`MSG` 기록
      → 검증: WIP 저장은 호출 없음, DONE 저장은 1회 호출
- [ ] `applySensor(runNo, seqNo)` 재반영 메서드
      → 검증: 이미 반영된 건은 거부, 미반영 건만 재호출
- [ ] `work-result.dto.ts` `ApplySensorDto`
      → 검증: `tsc --noEmit` 통과
- [ ] `work-result.controller.ts` `POST results/apply-sensor`
      → 검증: 라우트 매핑 로그에 노출
- [ ] 백엔드 테스트 갱신 (`work-result.service.spec.ts`의 `ProductSensorActual` 참조)
      → 검증: `pnpm --filter @eunsung/backend test`

## 3. 프론트엔드

- [ ] `ResultRow`에 `sensorApplyYn` 추가
      → 검증: `tsc --noEmit` 통과
- [ ] 이력 처리구분 셀 — `DONE` + 미반영이면 빨간색, `title`에 `P_OUT` 원문
      → 검증: 렌더 확인
- [ ] '실적 이력' 타이틀 옆 `실적반영` 버튼 (선택된 실적이 미반영일 때만 활성)
      → 검증: 렌더 확인
- [ ] 저장 응답의 경고 문구 노출
      → 검증: 프로시저 실패 시 경고 토스트

## 4. 검증

- [ ] `pnpm --filter @eunsung/frontend exec tsc --noEmit --pretty false`
- [ ] `pnpm --filter @eunsung/backend exec tsc --noEmit --pretty false`
- [ ] `pnpm --filter @eunsung/backend test`
- [ ] `pnpm --filter @eunsung/frontend test`
- [ ] 화면 왕복 — 등록(WIP) → 수정(DONE) → 프로시저 반영 → 실패 시 빨간색 → `실적반영` 재시도
      (DDL 적용 후에만 가능)

## 5. 커밋

- [ ] 복원 DDL + 엔티티 (1커밋)
- [ ] 서비스·컨트롤러 프로시저 연계 (1커밋)
- [ ] 프론트 표기·재반영 버튼 (1커밋)

## 미결

- [ ] DDL 적용 대상 확정 (es_mesi 지금 / ES_JSIDC 복구 후)
- [ ] ES_JSIDC 휴지통 `BIN$koAumyN1TTaJP/V4de49KQ==$0` 생존 확인
- [ ] 2026-09-02 이후 `IP_PRODUCT_SENSOR_ACTUAL` 수기 실적 역이관 여부
