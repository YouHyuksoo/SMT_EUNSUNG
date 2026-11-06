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
  - docs/specs/2026-11-05-routing-by-code-design.md
  - apps/backend/src/migrations/2026-11-05_item_routing_code.sql
  - apps/backend/src/migrations/2026-11-05_routing_groups_drop_item_code.sql
verifiedCommit: 83834cfd
---

# IP_ROUTING_* — 생산 라우팅

## 확인된 역할

생산 라우팅은 품목이 거치는 공정 순서와, 품목별로 각 공정에 투입되는 생산 BOM
하위품목의 배정을 묶은 생산 기준정보다. 공정 순서가 같은 품목은 하나의 라우팅을 함께 따른다.

생산 BOM은 상위품목을 구성하는 전체 하위품목과 소요량의 기준이고, 생산 라우팅은
그 하위품목이 어떤 순서의 어느 공정에 투입되는지를 관리한다. 생산 라우팅은 생산
BOM을 대체하지 않는다.

## 구조 (2026-11-05 코드 기준 라우팅)

```text
ID_ITEM.ROUTING_CODE ──▶ IP_ROUTING_GROUPS (ORG, ROUTING_CODE)
  품목이 코드를 문다          └─ IP_ROUTING_PROCESSES (ORG, ROUTING_CODE, PROCESS_SEQ)
                                  └─ IP_ROUTING_MATERIALS (ORG, ROUTING_CODE, PROCESS_SEQ, ITEM_CODE, CHILD_ITEM_CODE)
```

- `IP_ROUTING_GROUPS`: 라우팅 코드·명칭·사용여부. 품목을 모른다(`ITEM_CODE` 없음).
- `ID_ITEM.ROUTING_CODE`: 품목이 따르는 라우팅 코드. `FK_ID_ITEM_ROUTING (ORGANIZATION_ID, ROUTING_CODE)`.
  `NULL`이면 라우팅이 없는 품목이다. 라우팅 관리 화면의 적용 품목에서만 바꾼다.
- `IP_ROUTING_PROCESSES`: 라우팅 안의 공정 순서와 내작·외주 실행 속성. 같은 라우팅을 따르는 모든 품목이 공유한다.
- `IP_ROUTING_MATERIALS`: BOM이 품목마다 다르므로 투입자재는 `ITEM_CODE`(상위 품목)별로 둔다.
  `FK_IP_RM_PARENT (ITEM_CODE, ORGANIZATION_ID, ROUTING_CODE) → ID_ITEM`(`UK_ID_ITEM_ROUTING`)이
  자재 배정과 품목의 라우팅 코드가 어긋나지 않게 한다. 자재가 있는 품목은 DB가 라우팅 변경을 막는다.
  `UK_IP_RM_CHILD (ORG, ROUTING_CODE, ITEM_CODE, CHILD_ITEM_CODE)`로 한 품목의 하위자재는 한 공정에만 배정된다.

## `ROUTE_NO`를 쓰지 않는 이유

`ID_ITEM.ROUTE_NO`는 레거시 컬럼이다. 2026-11-05까지 `UPDATE OF route_no` 트리거(`ID_ITEM_UPD_MANUAL`)가
재고 행을 지우고 입출고 구입유형을 고쳐 써서 새 컬럼 `ROUTING_CODE`를 두었다. 이 트리거는 같은 날 업무 판단으로
삭제했다(복구 DDL: `docs/sql/2026-11-05-id-item-upd-manual-trigger-ddl.sql`). 라우팅은 `ROUTE_NO`와 무관하게 `ROUTING_CODE`만 쓴다.

## 대상 품목

라우팅은 반제품(`ITEM_DIVISION='W'`)·완제품(`'F'`)에만 붙일 수 있다(서비스가 검사).
후보 조회는 현재 유효 BOM 유무(`bomRegisteredYn`)를 함께 돌려주지만 BOM이 없어도 붙일 수 있다.
투입자재 배정은 현재 유효 BOM이 있는 하위품목만 허용한다.

## 삭제된 객체

- `IP_ROUTING_GROUPS.ITEM_CODE`, `FK_IP_RG_ITEM`, `UK_IP_RG_ACTIVE_ITEM`: 품목이 라우팅을 물도록 바꾸면서 삭제.
- `IP_PRODUCT_ROUTING_MASTER`, `IP_PRODUCT_ROUTING`(옛 라우팅 테이블): 0건이었고 살아 있는 호출처가 없어 삭제.
  `PKG_PLANNING` 본문은 2026-08-11부터 INVALID였고 `F_GET_WORKSTAGE_CODE_4_LINE`은 주석에서만 호출됐다.
  삭제 후 `F_GET_WORKSTAGE_CODE_4_LINE`이 INVALID가 된다. 복구용 DDL: `docs/sql/2026-11-05-ip-product-routing-legacy-ddl.sql`.

## 현재 상태 (2026-11-05 ESDB)

완제품 17개 품목이 8개 라우팅(`RT-01`~`RT-08`, 공정 31건)을 따른다. 공정이 같은 품목끼리 묶었고
(4·4·2·2·2·1·1·1개), 투입자재 배정은 0건이다. 이관 스크립트: `docs/sql/2026-11-05-routing-by-code-data-move.sql`.

## 마이그레이션 순서

1. `2026-11-05_item_routing_code.sql` — `ID_ITEM.ROUTING_CODE`·제약·인덱스 추가, 그룹의 품목 제약 해제
2. `docs/sql/2026-11-05-routing-by-code-data-move.sql` — 옛 품목별 라우팅을 공정 패턴별로 묶어 이관
3. `2026-11-05_routing_groups_drop_item_code.sql` — `ITEM_CODE` 삭제, 투입자재 재구성, 옛 테이블 삭제
4. `2026-07-12_ip_routing_tables.sql` — 최종 구조 검증(신규 환경은 이 파일만으로 최종 구조가 만들어진다)

## 라우팅 그룹 정책

`USE_YN`은 라우팅의 사용 여부다. 라우팅 코드는 자유 입력이며 품목코드와 무관하다.
품목이 배정된 라우팅과 공정이 있는 라우팅은 삭제할 수 없다.

## 공정별 라벨 발행 여부

2026-07-14 설계의 `LABEL_ISSUE_YN`은 아직 구현되지 않았다.

## BOM 변경 처리

BOM에서 빠진 기존 라우팅 자재는 자동 삭제하지 않고 `BOM 불일치`로 표시한다.
