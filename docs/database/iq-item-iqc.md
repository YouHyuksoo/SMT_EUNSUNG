---
sources:
  - docs/database/generated/infinity21-jsmes-schema.json
  - docs/database/im-item-master.md
verifiedCommit: 0480e7d
---

# IQ_ITEM_IQC — IQC 검사 실적(현재 미사용)

## 확인된 역할

`IQ_ITEM_IQC`는 입하 품목의 IQC 검사 실적을 기록한다. 품목·공급처·제조번호,
입하수량·검사수량·불량수량, 검사방법과 검사결과를 보유한다.

검사결과 코드는 `P=합격`, `R=불합격`, `U=재사용`, `W=대기`다.

## 생성 흐름

`TRG_IM_ITEM_ARRIVAL_UPD`는 `IM_ITEM_ARRIVAL.INSPECT_RESULT` 변경 시
`IQ_ITEM_IQC`를 생성하거나 삭제한다. 검사방법은 `IM_ITEM_MASTER`에서 품목·공급처·
조직 조합으로 조회한다.

## 현행 상태

- `IQ_ITEM_IQC`: 242건
- 데이터 기간: 2022-11-09 ~ 2022-11-11
- `IM_ITEM_ARRIVAL`: 0건
- `TRG_IM_ITEM_ARRIVAL_UPD`: 활성

구조와 트리거는 남아 있지만 입력 원천과 신규 실적이 없어 현재 운영하지 않는 휴면
테이블로 분류한다. 삭제 대상으로 단정하지 않는다.
