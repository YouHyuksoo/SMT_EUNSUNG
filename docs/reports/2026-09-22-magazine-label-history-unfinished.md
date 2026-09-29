# 매거진발행이력 화면 미완료 검증 기록

## 범위

- PB `W_PLN_PRODUCT_MAGAZINE_LABEL_QUERY`의 이력·집계·매트릭스 조회 변환
- 공정수불관리 메뉴 등록

## 미완료 항목

- 2026-09-22 `ESDB` Oracle 프로필로 `IP_PRODUCT_RUN_CARD_IO` 스키마와 건수를 확인하려 했으나 `ORA-12170: TNS:Connect timeout occurred`가 발생했다.
- 따라서 Oracle 기대 건수 → 인증 백엔드 API → 프론트 프록시 → 렌더 행 순서 검증은 아직 수행하지 못했다.
- 프론트엔드 `http://localhost:4010/process-transaction/magazine-label-history`는 HTTP 200을 반환했다. 다만 Chrome 제어가 요청 헤더 정책 로드 오류로 중단되어 실제 메뉴 클릭·렌더 상태는 확인하지 못했다.
- 실행 중인 백엔드 `http://localhost:4003/process-transaction/magazine-label-history`는 HTTP 404를 반환했다. 현재 프로세스에 신규 모듈이 반영되지 않은 상태로 보이며, 프로젝트 규칙에 따라 서버를 임의 재기동하지 않았다.

## 재개 절차

1. `ESDB` 접속 가능 상태에서 `IP_PRODUCT_RUN_CARD_IO` 컬럼과 기간별 기대 건수를 확인한다.
2. 인증된 `GET /process-transaction/magazine-label-history`를 이력·집계·매트릭스 각각 호출한다.
3. `http://localhost:4010`에서 공정수불관리 → 매거진발행이력을 클릭해 URL·탭·행·콘솔 오류를 확인한다.
