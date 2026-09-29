# 공정통과이력 관리 런타임 검증 미완료 기록

## 대상

- 원본 PB: `W_PLN_PRODUCT_INOUT_SCAN_MASTER`
- 웹 경로: `/process-transaction/workstage-pass`
- 메뉴 코드: `PLN_WORKSTAGE_PASS`
- Oracle: `ESDBEXT`

## 완료된 검증

- ESDBEXT의 `IP_PRODUCT_WORKSTAGE_IO`, `IP_PRODUCT_2D_BARCODE`, `IP_PRODUCT_RUN_CARD_IO` 컬럼과 관련 인터록 오브젝트를 읽기 전용으로 확인했다.
- 백엔드 단위 테스트, 백엔드 TypeScript 검사, 프론트엔드 페이지 등록 검사와 TypeScript 검사를 수행했다.

## 남은 검증

2026-09-22 현재 사용자 기동 서버의 4010/4003 포트는 LISTEN 상태였으나, 실행 중인 백엔드가 신규 경로를 반영하지 않아 아래 요청이 `404 Not Found`를 반환했다.

```text
GET http://localhost:4003/process-transaction/workstage-pass?mode=history&dateFrom=2026-09-22&dateTo=2026-09-22
```

프로젝트 규칙에 따라 에이전트가 서버를 재기동하지 않았다. 사용자가 개발 서버를 재기동한 뒤 다음 순서로 확인해야 한다.

1. ESDBEXT에서 조직·기간별 기대 건수를 읽기 전용 SQL로 확인한다.
2. 인증된 백엔드 GET API와 프론트 프록시 응답 행을 비교한다.
3. `/process-transaction/workstage-pass` 화면의 5개 조회 모드와 행 표시를 확인한다.
4. 검증용 PID로 통과등록·취소를 실행하려면 운영 데이터 변경 승인을 먼저 받고, 전후 이력과 복구 여부를 확인한다.

## 주의

등록·취소 API는 운영성 DML이다. 라이브 데이터 검증은 대상 PID와 복구 절차가 합의되기 전 실행하지 않는다.
