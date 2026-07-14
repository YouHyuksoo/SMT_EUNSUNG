---
sources:
  - docs/database/generated/infinity21-jsmes-schema.json
  - docs/database/id-item.md
verifiedCommit: 0480e7d
---

# IM_ITEM_MASTER — 품목별 공급처 마스터

## 확인된 역할

`IM_ITEM_MASTER`는 품목과 공급처 조합별 구매 운영 조건을 관리한다. 이름에
`MASTER`가 있지만 전체 품목의 기준정보는 `ID_ITEM`이며, 이 테이블은 품목 마스터와
공급처 사이의 관계 정보다.

현재 이 MES는 발주를 내는 시스템이 아니다. 이 관계정보는 공급처별 IQC 검사 대상
여부를 구분하는 데 주로 사용한다. 신규 품목 등록 시 공급처를 모르면
`SUPPLIER_CODE='*'`로 자동 생성하며 입력 직후 실제 공급처 코드로 정리하는 것이
원칙이다. 다만 시스템이 이 정리를 강제하지는 않는다.

## 식별자와 규모

- 기본키: `SUPPLIER_CODE + ITEM_CODE + ORGANIZATION_ID`
- 2026-07-12 라이브 데이터: 4,292건
- 고유 품목코드: 4,131개
- 고유 공급처코드: 74개

## 주요 정보

- 적용 시작일·종료일
- 발주형태·발주율·발주 리드타임·발주 불량률
- 최소발주량·포장수량
- 주거래선 여부
- 지불유형·부대비용 조건
- 입고검사 방법·검사 여부·검사 처리 절차
- 창고·발주 담당자

## 생성 관계

`TRG_ID_ITEM_INS`는 `ID_ITEM` 신규 등록 시 구입유형이 자작(`T`) 또는 내부거래(`N`)
가 아닌 품목에 대해 기본 구매조건을 생성한다. 동일 품목·공급처·조직 조합이 이미
있으면 추가하지 않는다. `ID_ITEM.SUPPLIER_CODE`가 없으면 `*`를 사용한다.

`SUPPLIER_CODE + ORGANIZATION_ID`는 공식 `공급처 마스터`인 `ICOM_SUPPLIER`를
참조하도록 정의되어 있다.

## 데이터 품질 상태

- `IM_ITEM_MASTER → ID_ITEM`, `IM_ITEM_MASTER → ICOM_SUPPLIER` FK는 현재
  `DISABLED / NOT VALIDATED`다.
- `*`는 오류 값이 아니라 공급처 미확정 단계의 임시 값이다.
- 공식 공급처가 정해진 뒤에도 `*`나 과거 코드가 남아 있을 수 있다. 입력 직후
  정리가 원칙이지만 시스템 강제 규칙은 아니다.
- 발주 기능의 기준 테이블로 해석하지 않는다. 현행 주요 용도는 공급처별 IQC 검사
  대상 여부 판단이다.

## IQC 실적과의 관계

`IM_ITEM_MASTER.INSPECT_RULE`은 공급처별 IQC 검사 대상 여부, `INSPECT_METHOD`는
검사방법을 나타낸다. 과거에는 `IM_ITEM_ARRIVAL` 검사결과 변경 트리거가 이 정보를
참조해 `IQ_ITEM_IQC` 실적을 생성했다. 현재 입하 원천 데이터는 0건이며 해당 실적
흐름은 휴면 상태다.
