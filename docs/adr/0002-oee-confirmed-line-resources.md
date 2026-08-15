# 0002. OEE 확정 LINE 리소스 범위

- 결정일: 2026-08-15
- 상태: 승인
- 대상: OEE 모바일 입력, 대시보드, Oracle OEE 리소스
- 대체 결정: `0001-oee-mobile-seed-and-scanner-scope.md`

## 배경

초기 OEE 모바일 범위는 `PLANTS`의 `PROD2` 아래에 조립 CELL `50~64`를 별도로 시드하고 선택하는 방식이었다. 이후 실제 라인 마스터와 업무 범위를 재검증한 결과, OEE 리소스는 `IP_PRODUCT_LINE`의 확정 LINE만 사용해야 하며 `50~64`는 OEE 대상이 아닌 기존 원천 마스터임이 확인됐다.

## 결정

1. OEE의 리소스 원천은 `IP_PRODUCT_LINE`으로 통일한다.
2. SMT는 `LINE_CODE` `01~12`만 사용한다.
3. 조립은 `LINE_CODE` `19~24`만 사용한다.
4. 두 공정의 `RESOURCE_TYPE`은 모두 `LINE`이다.
5. `PLANTS`, `PROD2`, 조립 CELL `50~64`는 OEE 리소스로 사용하지 않는다.
6. `IP_PRODUCT_LINE`의 `50~64` 원천 행은 다른 업무가 소유하므로 삭제하거나 변경하지 않는다.
7. API DTO, 서비스 조회, 프론트 타입, Oracle seed와 cleanup이 같은 계약을 강제한다.

## 결과

- `0001`의 생산2팀 CELL seed 및 LINE/CELL 직접 선택 결정은 이 ADR로 대체된다.
- OEE 모바일과 대시보드는 SMT 12개, 조립 6개 LINE만 조회한다.
- `09_seed_dashboard_resources.sql`은 확정 LINE을 동기화하고 다른 OEE 리소스를 비활성화한다.
- `08_cleanup_legacy_oee_plants.sql`과 `10_cleanup_unapproved_oee_resources.sql`은 과거 OEE 파생 데이터만 정리한다.
- `oee-mobile.service.spec.ts`와 `oee-mobile-ddl.spec.ts`가 코드 및 배포 스크립트의 확정 범위를 검증한다.
