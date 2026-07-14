---
sources:
  - apps/backend/src/entities/supplier-master.entity.ts
  - apps/backend/src/modules/master/services/partner.service.ts
  - docs/database/generated/infinity21-jsmes-schema.json
verifiedCommit: 0480e7d
---

# ICOM_SUPPLIER — 공급처 마스터

## 확인된 역할

`ICOM_SUPPLIER`는 MES가 사용하는 공식 공급처 기준정보다. 기본키는
`SUPPLIER_CODE + ORGANIZATION_ID`다.

2026-07-12 라이브 데이터는 15건이며 모두 거래 중(`BUSINESS_STATUS='A'`)이고,
사업유형은 협력사(`BUSINESS_TYPE='S'`)다. 물리 컬럼은 고객·납품처·제조사 등 다른
유형도 표현할 수 있지만 현행 애플리케이션과 데이터는 공급처로 사용한다.

## 주요 관계

- `IM_ITEM_MASTER`: 품목별 공급처 마스터
- `IM_ITEM_UNIT_PRICE`: 품목·공급처별 단가
- 공급처 코드와 조직 ID를 함께 사용해 관계를 식별한다.

## 데이터 품질 주의

`IM_ITEM_MASTER`의 공급처 FK는 `DISABLED / NOT VALIDATED` 상태다. 따라서
`ICOM_SUPPLIER`에 없는 과거 코드나 임시 값 `*`가 남아 있을 수 있다.
