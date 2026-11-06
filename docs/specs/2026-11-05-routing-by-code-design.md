# 라우팅 코드 기준 구조 설계

- 작성일: 2026-11-05
- 상태: 구현·ESDB 적용 완료
- 대체: `docs/specs/2026-07-14-fixed-item-routing-design.md`의 "품목별 단일 고정 라우팅, 라우팅 코드는 품목코드와 동일"

## 1. 결정

품목이 라우팅 코드를 물고, 라우팅 테이블은 라우팅 코드로 묶인다. 라우팅 그룹은 품목을 모른다.
공정 순서가 같은 품목은 하나의 라우팅을 공유한다.

## 2. 배경

2026-11-05 은성 시트(공정과 공정순서가 표시된 모델 17개)를 넣어 보니 공정 패턴이 8종뿐이었다
(4·4·2·2·2·1·1·1개 품목). 품목별 라우팅은 같은 공정 정의를 17벌 복제하고, 공정 하나를 바꾸려면
품목 수만큼 고쳐야 한다. 07-14 설계는 "품목 마스터에 라우팅 컬럼 추가"를 "공정 순서가 복수 행이라
단일 컬럼으로 표현할 수 없다"는 이유로 제외했지만, 컬럼은 행을 담는 것이 아니라 라우팅 코드를
가리키는 키이므로 이 이유는 성립하지 않는다.

## 3. 설계

| 항목 | 결정 | 근거 |
|---|---|---|
| 품목→라우팅 연결 | 새 컬럼 `ID_ITEM.ROUTING_CODE VARCHAR2(50)`, `FK_ID_ITEM_ROUTING (ORG, ROUTING_CODE)` | `ROUTE_NO`를 UPDATE하면 `ID_ITEM_UPD_MANUAL` 트리거가 재고 행을 지운다. 대상 품목 `E2010000310`은 재고 1행·입고 2행이 걸려 있었다. 품목마스터 화면도 `ROUTE_NO`를 `edit: never`로 막고 있다. |
| 라우팅 그룹 | `ITEM_CODE`·`FK_IP_RG_ITEM`·`UK_IP_RG_ACTIVE_ITEM` 삭제 | 그룹은 품목을 모른다 |
| 투입자재 | PK·`UK_IP_RM_CHILD`에 `ITEM_CODE`(상위 품목) 추가, `FK_IP_RM_PARENT (ITEM_CODE, ORG, ROUTING_CODE) → ID_ITEM` | BOM이 품목마다 다르므로 자재 배정은 품목별이다. FK가 자재 배정과 품목의 라우팅 코드가 어긋나는 것을 막고, 자재가 있는 품목의 라우팅 변경을 DB가 거절한다. `UK_ID_ITEM_ROUTING (ITEM_CODE, ORG, ROUTING_CODE)`이 FK 대상이다. |
| 라우팅 코드 | 자유 입력, 품목코드와 무관 | 여러 품목이 공유한다 |
| 대상 품목 | `ITEM_DIVISION IN ('W','F')` | 서비스가 검사. BOM이 없어도 붙일 수 있고 후보 API가 BOM 유무를 표시한다. |
| 삭제 | 공정이나 적용 품목이 있는 라우팅은 삭제 불가 | FK와 서비스 검사 |

## 4. 옛 라우팅 테이블 정리

`IP_PRODUCT_ROUTING_MASTER`·`IP_PRODUCT_ROUTING`은 0건이었다. 의존 객체는 `PKG_PLANNING` 본문(2026-08-11부터
INVALID, 이를 호출하는 트리거 4개도 INVALID)과 `F_GET_WORKSTAGE_CODE_4_LINE`(호출이 주석뿐)이었다.
살아 있는 호출처가 없어 삭제했고 `F_GET_WORKSTAGE_CODE_4_LINE`은 INVALID가 된다. PB의 `uo_route_code.sru`,
`vd_workstage_routing_code.srd`가 옛 테이블을 읽는 창이 있으며 이 화면은 이제 조회 오류가 난다
(데이터가 없었으므로 이전에도 빈 화면이었다). 복구용 DDL은 `docs/sql/2026-11-05-ip-product-routing-legacy-ddl.sql`.

## 5. API

- `GET /master/routing-groups` — 라우팅 목록(`itemCount` 포함)
- `GET /master/routing-groups/candidate-items` — 반제품·완제품 후보(검색·페이지, 현재 라우팅·`bomRegisteredYn`). `:code`보다 먼저 선언.
- `GET/PUT /master/routing-groups/:code/items` — 적용 품목 조회, `{assign, unassign}` 저장
- `GET/PUT /master/routing-groups/:code/processes/:seq/materials` — `itemCode` 필수

## 6. 이관 결과 (ESDB)

옛 17개 라우팅(공정 66건)을 공정 패턴 서명(`순서:공정코드` 나열)으로 묶어 `RT-01`~`RT-08`(공정 31건)을
만들고 17개 품목의 `ROUTING_CODE`를 채웠다. 투입자재는 0건이었다.
