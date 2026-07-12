---
menuCode: MST_ROUTING
audience: operator
title: 라우팅관리 — 운영 가이드
summary: IP 라우팅 그룹·공정·BOM 자재 배정의 데이터 계약과 운영 규칙
tags: [기준정보, 라우팅, 공정순서, 운영]
keywords: [IP_ROUTING_GROUPS, IP_ROUTING_PROCESSES, IP_ROUTING_MATERIALS, ID_ENG_BOM, INTERNAL, SUBCON, BACKFLUSH, PRE_ISSUE]
related: [MST_PART, MST_PROCESS, MST_BOM]
---

# 라우팅관리 — 운영 가이드

## 데이터 구조

```text
IP_ROUTING_GROUPS (ORGANIZATION_ID, ROUTING_CODE)
  ├─ IP_ROUTING_PROCESSES (ROUTING_CODE, PROCESS_SEQ)
  └─ IP_ROUTING_MATERIALS (ROUTING_CODE, PROCESS_SEQ, CHILD_ITEM_CODE)
       └─ 후보 기준: ID_ENG_BOM의 오늘 유효 행
```

- 그룹은 품목(`ITEM_CODE`)에 연결되며, 조직별 한 품목의 활성(`USE_YN='Y'`) 라우팅은 하나입니다.
- 공정은 공정 마스터의 `WORKSTAGE_CODE`를 참조합니다. 공정명은 별도 저장하지 않고 마스터에서 파생합니다.
- `EXECUTION_TYPE`은 `INTERNAL` 또는 `SUBCON`입니다. `SUBCON`이면 유효한 `SUBCON_SUPPLIER_CODE`가 필수이고, `INTERNAL`이면 공급처를 `NULL`로 저장합니다.
- 자재의 고유 제약은 `(ORGANIZATION_ID, ROUTING_CODE, CHILD_ITEM_CODE)`입니다. 따라서 하위 자재 하나는 같은 그룹의 공정 하나에만 배정됩니다.

## 자재 후보와 저장 규칙

조회 결과는 다음 두 집합의 합집합입니다.

1. 그룹 품목의 현재 BOM 후보: `DATESET <= TRUNC(SYSDATE)` 및 `DATEEND >= TRUNC(SYSDATE)`
2. 해당 라우팅 그룹에 이미 저장된 모든 자재 배정

현재 BOM에 없는 기존 배정은 `bomMatchYn='N'`, `mismatchReason='현재 유효 BOM에 없음'`으로 반환됩니다. 다른 공정 배정은 `selectableYn='N'`입니다. 현재 BOM 기간이 같은 자재에 대해 중복되면 저장 후보를 임의 선택하지 않고 요청을 거절합니다.

저장은 `upserts`와 `deletes`를 분리한 명시적 변경 계약입니다.

- `upserts`: 현재 유효 BOM 자재만 허용하며 `allocQty > 0`이어야 합니다.
- `deletes`: 사용자가 휴지통으로 삭제 요청한 기존 배정만 전달합니다. 체크 해제나 BOM 변경만으로 삭제하지 않습니다.
- 동일 요청에서 같은 자재를 중복 변경하거나 다른 공정 소유 자재를 변경하면 충돌로 처리합니다.
- 그룹 잠금 후 삭제·저장을 수행하고 커밋 이후 다시 조회합니다.

## 삭제와 장애 대응

- 공정에 `IP_ROUTING_MATERIALS`가 남아 있으면 공정 삭제를 거절합니다. 자재를 명시적으로 삭제한 뒤 재시도합니다.
- 하위 공정이 남아 있으면 라우팅 그룹 삭제를 거절합니다.
- 동시 변경 또는 FK/UK 충돌(`ORA-00001`, `ORA-02291`, `ORA-02292`)은 무결성 충돌로 반환하므로 새로 조회한 뒤 재시도합니다.
- Oracle `IN` 목록은 1,000개 단위로 분할 조회합니다.

## 화면 범위

현재 구현 범위는 라우팅 그룹, 공정 순서, 공정별 BOM 투입자재입니다. 양품조건(QC), 자주검사, SG/FG 라벨, 회로사양, BOM 트리는 이 화면의 계약이나 테이블 구조에 포함되지 않습니다.
