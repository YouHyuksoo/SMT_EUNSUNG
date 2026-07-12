---
sources:
  - apps/backend/src/entities/item-master.entity.ts
  - apps/backend/src/modules/master/services/part.service.ts
  - apps/backend/src/modules/interface/services/interface.service.ts
  - docs/database/generated/infinity21-jsmes-schema.json
verifiedCommit: 0480e7d
---

# ID_ITEM — 품목 마스터

## 확인된 역할

`ID_ITEM`은 MES가 단독으로 소유·관리하는 조직별 품목 마스터다. ERP 수신본이
아니며 품목 등록·변경의 기준이다. 기본키는 `ITEM_CODE + ORGANIZATION_ID`이며,
자재·BOM·재고·생산·품질·출하 관련 테이블과 PL/SQL이 공통으로 참조한다.

2026-07-12 `ESDBext`의 `INFINITY21_JSMES` 스키마에서 확인한 행은 2,501건이며,
모두 `ORGANIZATION_ID = 1`이었다.

## 확정된 분류축

| 업무 용어 | 물리 컬럼 | 값 | 의미 | 상태 |
|---|---|---|---|---|
| 품목구분 | `ITEM_DIVISION` | `R` | 원자재 | 확정 |
| 품목구분 | `ITEM_DIVISION` | `W` | 반제품 | 확정 |
| 품목구분 | `ITEM_DIVISION` | `F` | 제품 | 확정 |
| 제조유형 | `ITEM_TYPE` | `T` | 자작 | 확정 |
| 제조유형 | `ITEM_TYPE` | `M` | 무상 | 확정(현재 데이터 0건) |
| 제조유형 | `ITEM_TYPE` | `S` | 유상 | 확정 |
| 제조유형 | `ITEM_TYPE` | `Y` | 유상 | 미사용 후보 |
| 구입유형 | `LINE_TYPE` | 공통코드 참조 | 상세 구입·공급 경로 | 확정 |
| 품목분류 | `ITEM_CLASS` | 공통코드 참조 | 기술적 품목 종류 | 확정 |
| 세트구성여부 | `SET_ITEM_YN` | `Y` | 세트 구성 품목 | 확정 |
| 세트구성여부 | `SET_ITEM_YN` | `N` | 단품 | 확정 |
| 세트구성여부 | `SET_ITEM_YN` | `M` | 미사용 레거시 코드 | 확정 |

`품목구분`은 원자재·반제품·제품만 구분한다. `제조유형`은 자작 또는
무상·유상 조달을 구분한다. `구입유형`은 국내구매·사급·내부거래·OEM·자작 등
상세 구입 또는 공급 경로를 나타낸다. `품목분류`는 PCB·저항·커패시터·IC·ASSY 등
기술적 품목 종류를 세분화한다. `세트구성여부`는 세트 구성 품목과 단품을 나누는
별도의 분류축이며 같은 의미로 사용하지 않는다.

## 라이브 데이터 분포

| `ITEM_DIVISION` | 건수 |
|---|---:|
| `R` | 1,375 |
| `W` | 789 |
| `F` | 337 |

`ITEM_TYPE`은 `T` 2,476건, `S` 25건이며 `M`, `Y`는 현재 0건이다.
`PKG_PLANNING`은 구매 대상 조건으로 `ITEM_TYPE IN ('M', 'S')`를 사용한다.
따라서 `Y`는 현재 미사용 후보지만 인터페이스·과거 데이터 확인 전에는 삭제 코드로
확정하지 않는다.

`SET_ITEM_YN`은 `Y` 334건, `N` 2,167건이며 `M`은 현재 0건이다. `Y`는 세트 구성
품목, `N`은 단품이고 `M`은 미사용 레거시 코드다. 현재 애플리케이션의
`isSplittable` 매핑은 이 의미와 일치하지 않는다.

## 관계 근거

- Oracle PK: `ITEM_CODE + ORGANIZATION_ID`
- `ID_ITEM`을 참조하는 Oracle FK: 28개 제약조건(복합키 컬럼 행으로는 56개)
- `ID_ITEM`을 참조하는 DB 객체: 함수·프로시저·패키지 본문·트리거·뷰
- ERP 품목 동기화 진입점: `IF_ITEM_MASTER` 프로시저

`ID_ITEM` 등록 트리거는 구매 대상 품목에 대해 `IM_ITEM_MASTER` 기본 행을 만든다.
`IM_ITEM_MASTER`는 품목 기준정보의 복제본이 아니라 공급처별 발주·구매·검사 조건을
관리하는 `품목별 공급처 마스터`다. 등록 시 공급처를 모르면 `*`로 생성하고,
실제 공급처가 정해진 뒤 공식 코드로 정리한다.

현재 애플리케이션에는 `IF_ITEM_MASTER` 호출 코드가 있지만 2026-07-12 라이브 Oracle의
`ALL_OBJECTS`와 `ALL_SYNONYMS`에는 해당 객체가 없다. MES 단독 관리 원칙과도 맞지
않으므로 현행 품목 마스터의 정상 데이터 경로로 보지 않는다.

## 코드 정합성 점검 필요

현재 `PartService.create()`는 화면의 `itemType` 값을 `ITEM_TYPE`, `ITEM_CLASS`,
`ITEM_DIVISION`에 함께 기록한다. 라이브 Oracle에서 세 컬럼은 서로 다른 분류축이므로,
이 매핑은 별도 수정 설계가 필요하다. 이 문서는 현행 코드를 정당화하지 않고 불일치를
그대로 기록한다.

## 아직 확정하지 않은 용어

- 소모품을 `ID_ITEM`에서 관리하는지 여부
