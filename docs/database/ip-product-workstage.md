---
sources:
  - docs/database/generated/infinity21-jsmes-schema.json
  - docs/database/ip-product-line.md
  - docs/database/imcn-machine.md
verifiedCommit: 0480e7d
---

# IP_PRODUCT_WORKSTAGE — 공정 마스터

## 확인된 역할

`IP_PRODUCT_WORKSTAGE`는 제품이 거치는 작업 단계의 기준정보다. 생산라인은 물리적
생산 구역, 설비는 개별 장비, 공정은 작업 단계를 나타낸다.

기본키는 `WORKSTAGE_CODE + ORGANIZATION_ID`이며 2026-07-12 라이브 데이터는
33개 공정이다.

## 주요 정보

- 공정코드·공정명·정렬순서
- 시작공정 여부
- 공정유형: 일반·최종·검사
- 표준작업시간·사람작업시간·설비작업시간
- 대기시간·이동시간·준비시간·총작업시간
- 작업자 수·설비 수·CAPACITY·UPH·효율
- 불량률 통제 여부와 최대불량률
- 하위 반제품 전개 여부

## 라인·설비 관계

`LINE_CODE`와 `MACHINE_CODE`는 공정이 수행되는 대표 생산라인과 설비를 참조한다.
동일 행에 공정 현재상태와 PLC 주소도 저장돼 있어 기준정보와 운영상태가 혼합돼 있다.
