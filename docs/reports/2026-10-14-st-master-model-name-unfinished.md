# 표준시간 마스터 모델명 키 전환 — 미완료 기록

- 작성일: 2026-10-14
- 관련: `apps/backend/src/migrations/2026-10-13_st_master_model_name.sql`, `docs/specs/2026-10-13-oee-tables-into-existing-design.md` REV1

## 완료

- ESDBext `IP_PRODUCT_ST_MASTER`를 `MODEL_NAME + MACHINE_CODE + DATESET + ORGANIZATION_ID` 키로 전환했다(1단계).
  - 3,421행이 1,261행(모델 119개)이 됐다.
  - 모델 마스터에 없는 97품목 2,217행은 삭제했다. 원본은 `docs/sql/2026-10-13-ip-product-st-master-backup.sql`에 있다.
- 코드를 모델명 키로 바꿨다.
  - 표준시간 관리 화면·서비스·DTO·엔티티
  - 작업실적 목록 C/T 조회: 런카드 `MODEL_NAME` 기준으로 바꿨다. 기간 조건 없이 MAX로 조회하는 기존 방식은 그대로다.
  - 최근 60일 런카드 1,183건을 이전 조회와 비교했다. C/T 값이 바뀐 행도, 모델명 불일치로 C/T를 잃은 행도 0건이다.
- 백엔드·프론트 typecheck와 관련 jest 23개 스위트 218건이 통과했다.
- 최근 30일 생산 모델 50개 중 44개가 모델명으로 C/T를 찾는다.
- 같은 날 시도한 `IP_PRODUCT_SENSOR_ACTUAL_TIME.ITEM_CODE` 추가는 되돌렸다.
  - 컬럼을 삭제했고 `P_INTERLOCK_SENSOR_ACTUAL_NEO`를 원래 본으로 재배포했다.
  - 의존 객체 8개는 VALID다.

## 남은 일

1. 새 백엔드를 배포한다.
   - 배포 전까지 운영 백엔드는 `ITEM_CODE`로 C/T를 읽는다. 값을 남겨 두어 지금도 동작한다.
   - 운영 표준시간 화면에서 저장하면 실패한다. 구버전은 `MODEL_NAME` 없이 INSERT하기 때문이다.
2. 로컬 백엔드를 재기동한 뒤 화면 렌더를 확인한다: 표준시간 관리 목록·등록·수정, 작업실적 C/T 표시.
3. 2단계 `ALTER TABLE IP_PRODUCT_ST_MASTER DROP (ITEM_CODE)`는 아래 둘이 끝난 뒤 실행한다.
   - 새 백엔드 배포
   - `smt-close-run-preview`(아직 `ITEM_CODE`로 조회, 호출 화면 없음) 삭제. OEE_ 정리 작업에서 함께 지운다.
