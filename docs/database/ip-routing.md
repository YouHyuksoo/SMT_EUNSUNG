---
sources:
  - apps/backend/src/migrations/2026-07-12_ip_routing_tables.sql
  - apps/backend/src/entities/routing-group.entity.ts
  - apps/backend/src/entities/routing-process.entity.ts
  - apps/backend/src/entities/routing-material.entity.ts
  - apps/backend/src/modules/master/services/routing-group.service.ts
  - apps/frontend/src/app/(authenticated)/master/routing/
  - docs/specs/2026-07-12-ip-routing-design.md
  - docs/specs/2026-07-14-fixed-item-routing-design.md
verifiedCommit: 60adf9d
---

# IP_ROUTING_* — 생산 라우팅

## 확인된 역할

생산 라우팅은 특정 품목이 거치는 공정 순서와 각 공정에 투입되는 생산 BOM
하위품목의 배정을 묶은 생산 기준정보다.

생산 BOM은 상위품목을 구성하는 전체 하위품목과 소요량의 기준이고, 생산 라우팅은
그 하위품목이 어떤 순서의 어느 공정에 투입되는지를 관리한다. 생산 라우팅은 생산
BOM을 대체하지 않는다.

## 대상 품목

생산 라우팅은 현재 유효한 생산 BOM을 가진 반제품(`ITEM_DIVISION='W'`)과
완제품(`ITEM_DIVISION='F'`)만 등록할 수 있다. 원자재는 대상에서 제외하고, 생산 BOM이
없는 반제품·완제품은 `BOM 미등록` 상태로 표시해 라우팅 등록을 허용하지 않는다.

2026-07-14 `ESDB` 기준으로 완제품 337개 중 317개, 반제품 789개 중 525개가 생산
BOM의 상위품목으로 등록되어 있다.

## 테이블 구성

- `IP_ROUTING_GROUPS`: 품목과 라우팅 코드의 연결
- `IP_ROUTING_PROCESSES`: 라우팅 안의 공정 순서와 내작·외주 실행 속성
- `IP_ROUTING_MATERIALS`: 생산 BOM 하위품목의 공정별 투입 배정

## 현재 상태

2026-07-14 `ESDBext` 라이브 Oracle에서 신규 세 테이블과 레거시
`IP_PRODUCT_ROUTING_MASTER`, `IP_PRODUCT_ROUTING`은 모두 0건이다. 현재 화면과
백엔드 API는 신규 `IP_ROUTING_*` 구조를 사용하지만 기준 데이터는 아직 등록되지 않았다.

레거시 두 테이블은 신규 구조와 병행 보존되어 있으며 현행 화면의 저장 대상이 아니다.

2026-07-14 승인된 품목별 고정 라우팅과 `LABEL_ISSUE_YN` 변경은 아직 구현·Oracle
적용 전이다. 아래 정책은 구현 목표이며, 현재 소스에는 자유 입력 라우팅 코드와 기존
활성 라우팅 제약이 남아 있다.

## 승인된 라우팅 그룹 정책

라우팅 그룹은 버전이나 대안이 아니라 품목 하나에 고정된 단일 생산 라우팅이다.
라우팅 코드는 품목코드와 같고, 한 조직에서 동일 품목은 라우팅을 하나만 가진다.
`USE_YN`은 해당 고정 라우팅의 사용 여부이며 다른 버전을 의미하지 않는다.

## 승인된 공정별 라벨 발행 여부

`IP_ROUTING_PROCESSES.LABEL_ISSUE_YN`은 해당 공정의 라벨 발행 대상 여부를
`Y/N`으로 관리한다. 한 라우팅의 여러 공정에 `Y`를 설정할 수 있다. 라벨 종류는
사용자가 선택하지 않으며, 후속 생산실적 기능이 품목 구분 W/F로 판단한다.

현재 범위는 발행 여부 저장까지다. 실제 라벨 채번·인쇄는 생산실적 기능에서 구현한다.

## BOM 변경 처리

BOM에서 빠진 기존 라우팅 자재는 자동 삭제하지 않고 `BOM 불일치`로 표시한다.
불일치가 남은 라우팅은 사용자가 자재 배정을 정리하기 전까지 신규 작업지시에 사용할
수 없는 상태다.
