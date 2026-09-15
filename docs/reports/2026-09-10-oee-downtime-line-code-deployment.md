# 다중입력 원장 LINE_CODE 추가 결과

- 작성일: 2026-09-10
- 승인: 사용자가 원장 LINE_CODE 컬럼 추가 승인.
- 상태: 컬럼 추가 완료, 다중입력 저장·조회 전환 구현은 미완료.

## 적용

- 대상 개발 프로필: `EUNSUNG_DEV_ESDBPDB`.
- 사전 조회: 원장 LINE_CODE 없음. 실제 `IP_PRODUCT_LINE.LINE_CODE`는 VARCHAR2(20 BYTE).
- `oracle_db_scripts/oee/15_downtime_line_code.sql`로 nullable VARCHAR2(20 BYTE) 컬럼 및 주석 추가.
- 기존 행 UPDATE/DELETE와 기본값 지정 없음. 기존 데이터는 NULL로 유지하는 additive DDL이다.
- 배포 manifest에 등록하고 `EquipDowntimeResult.lineCode` nullable 매핑 추가.

## 검증

- Oracle connector `--execute-file`: 최초 실행 및 재실행 모두 2개 블록 성공.
- 사후 USER_TAB_COLUMNS: LINE_CODE, VARCHAR2, DATA_LENGTH=20, CHAR_USED=B, NULLABLE=Y, DATA_DEFAULT=null.
- `pnpm --filter @eunsung/backend test --runInBand --runTestsByPath src/modules/oee/oee-mobile-ddl.spec.ts`: 15개 통과.
- `pnpm --filter @eunsung/backend exec tsc --noEmit --pretty false`: 통과.

## 미완료 및 다음 단계

- 승인된 입력·일괄 처리 기준은 `2026-09-10-oee-multi-entry-decisions-and-storage-gap.md` 참조.
- LINE_CODE 저장 방식은 승인·적용되었으나 프론트/API의 원장 전환과 단일 트랜잭션 batch 처리는 아직 구현하지 않았다.
- 응답 유실 시 재시도 정책 및 동시성·중복 요청 처리 계약을 확정한 뒤 구현한다.
- 실제 앱 DB·조직 일치 및 DB → 인증 API → 프록시 → 렌더 검증은 후속 구현 후 수행해야 한다. 컬럼 배포를 화면 기능 완료로 간주하지 않는다.
