---
sources:
  - docs/database/generated/infinity21-jsmes-schema.json
  - docs/database/ip-product-line.md
  - docs/database/imcn-machine.md
verifiedCommit: dee4f7e
---

# IP_PRODUCT_WORKSTAGE — 공정 마스터

> **수치 출처** — 이 문서의 라이브 데이터 수치는 `docs/database/generated/infinity21-jsmes-schema.json`(사이트 `ESDBext`, 2026-07-12 추출)의 `row_count`이며,
> 그 값은 `USER_TABLES.NUM_ROWS` 통계 추정치다. 운영 접속 대상(`ES_JSIDC`/`ESDBPDB`)의
> 실제 건수와는 다를 수 있다 — 2026-09-02 실측 기준 설비 123, 라인 19, 공정 13이다.

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
