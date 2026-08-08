# 생산2팀 OEE CELL 상세 데이터 재평가

- 작성일: 2026-08-07
- 원문: `D:\Documents\jss\PI_MES\ESFA_P2026\260526_MES 고도화 제안서_REV1.pdf`
- Oracle 근거: `ESFA_EXTDB`의 `IP_PRODUCT_LINE`, `IP_PRODUCT_WORKSTAGE`, `ISYS_BASECODE`
- 개발 대상: `EUNSUNG_DEV_ESDBPDB`
- 선행 기록: `2026-08-06-production2-cell-extraction.md`

## 결론

선행 기록에서 추출한 9개 항목은 CELL 자체가 아니라 제품별로 선택되는 **공정 그룹**이다. `SMT 이후 포장 이전`이라는 위치만으로 공정을 모두 CELL로 분류하지 않는다.

2층 OEE CELL 초기 후보는 Oracle에서 `LINE_DIVISION='L'`로 관리되는 조립라인 중 일반 생산라인인 `LINE_CODE` 50~64의 15건을 사용한다. PDF 공정 항목은 각 CELL의 라우팅 또는 공정 속성으로 별도 관리한다.

이 문서는 `2026-08-06-production2-cell-extraction.md`의 "9개 공정=9개 CELL" 해석을 대체한다.

## 근거 우선순위

1. Oracle 실제 기준정보의 코드 의미와 식별자
2. PDF의 거래처·주요품목별 공정 경로
3. PDF의 대표 공정 흐름
4. 사용자 아이디어인 `SMT 공정과 포장 사이`

하위 근거로 상위 근거에 없는 CELL을 만들지 않는다.

## Oracle 분류

`ISYS_BASECODE`, `CODE_TYPE='LINE DIVISION'`의 실제 의미는 다음과 같다.

| 코드 | 의미 | OEE 리소스 해석 |
|---|---|---|
| `D` | SMT | 1층 SMT LINE |
| `W` | 가공공정 | WAVE·코팅·조립 가공 공정 LINE |
| `T` | 검사라인 | ICT·성능검사 LINE |
| `L` | 조립라인 | 2층 CELL 초기 후보 |
| `C` | CELL | 명시적 CELL 타입이나 현재 `IP_PRODUCT_LINE` 데이터는 0건 |

`LINE_STATUS='N'`은 `LINE STATUS` 공통코드에서 `정상`을 뜻한다. `N`을 비활성으로 해석하지 않는다.

## 2층 CELL 초기 후보

| SOURCE_LINE_CODE | CELL 명칭 | Oracle 분류 | PDF 교차 근거 |
|---|---|---|---|
| `50` | CMA | 조립라인 | 직접 모델 매칭 없음 |
| `51` | O1XX | 조립라인 | 직접 모델 매칭 없음 |
| `52` | DN8 | 조립라인 | p8 TSMOST `DN8 PE` |
| `53` | CD6 | 조립라인 | 직접 모델 매칭 없음 |
| `54` | HG | 조립라인 | 직접 모델 매칭 없음 |
| `55` | MOC28 | 조립라인 | 직접 모델 매칭 없음 |
| `56` | ECM | 조립라인 | 직접 모델 매칭 없음 |
| `57` | AE_EV | 조립라인 | p8 `전동화`와 관련 가능하나 직접 매칭은 미확정 |
| `58` | UPPER | 조립라인 | 직접 모델 매칭 없음 |
| `59` | EOP | 조립라인 | 직접 모델 매칭 없음 |
| `60` | 대양전기 | 조립라인 | p8 대양전기 `SM100` |
| `61` | BMA | 조립라인 | p8 인팩EPM `BMA` |
| `62` | TSMOST | 조립라인 | p8 TSMOST `DN8 PE`, `NQ5 PE`, `MV PRA`, `NX4` |
| `63` | AS | 조립라인 | 직접 모델 매칭 없음 |
| `64` | LED | 조립라인 | 직접 모델 매칭 없음 |

`80:GP-12`도 `LINE_DIVISION='L'`이지만 일반 조립 생산 CELL이 아니라 품질 선별·봉쇄 공정으로 판단해 초기 후보에서 제외한다. `99:REPAIR`도 수리 라인이므로 제외한다.

## 공정 그룹

PDF와 `IP_PRODUCT_WORKSTAGE`를 결합한 공정 그룹이다. 이 값들은 CELL이 아니라 CELL별 적용 라우팅에 사용한다.

| 공정 그룹 | PDF 근거 | Oracle 상세 기준정보 |
|---|---|---|
| 성능검사 | p5~p11 | 검사라인 `31:AE-EV 검사`, `32:BMA 검사 1`, `33:BMA 검사 2`; 작업공정 `W200:FINAL` 등 |
| ICT | p6, p8, p9, p11 | 검사라인 `26`~`29`; 작업공정 `W090:ICT` |
| 디스펜서 | p8, p9 | 독립 Oracle LINE/CELL 없음, 기준정보 관리 필요 |
| WAVE | p7~p9, p11 | 가공공정 `19:Wave 1라인`, `20:Wave 2라인`; 작업공정 `W130:WAVE` |
| 코팅 | p5~p11 | 가공공정 `40`~`47`; 작업공정 `W091:COATIING` |
| 라우터 | p5~p11 | 작업공정 `W100:ROUTER`; 독립 Oracle LINE/CELL 없음 |
| 조립 | p5~p11 | 가공공정 `34`~`39`; 작업공정 `W150:ASSY`; 조립라인 `50`~`64` |
| 수납땜 | p8 | 직접 대응 작업공정은 미확정. `W045:SMT수삽`, `W160:INSERT`와 동일하다고 단정하지 않음 |
| 외관검사 | p8 | 작업공정 `W205:외관검사`; 독립 Oracle LINE/CELL 없음 |
| 포장 | p5, p7~p10 | 작업공정 `W220:PACKING`; OEE CELL 종료 경계로 고정하지 않음 |

## PDF 제품별 경로 사용법

p8은 모든 제품이 같은 순서로 9개 공정을 통과한다고 정의하지 않는다. 거래처·주요품목별로 `입고/출고`, `포장 변경`, `모델 선택` 지점이 다르다.

- `BMA`, `DN8`, `TSMOST`, `대양전기`는 Oracle 조립라인과 직접 교차 확인된다.
- `NQ5`, `MV PRA`, `NX4`, `SM100`은 PDF에 있으나 동일 이름의 Oracle 조립라인이 모두 존재하지 않는다.
- 직접 매칭되지 않는 제품을 유사 명칭 CELL에 자동 연결하지 않는다.
- 모델·거래처는 CELL 식별자가 아니라 라우팅 조건이다.
- `IP_PRODUCT_ROUTING`과 `IP_PRODUCT_ROUTING_MASTER`는 운영·개발 DB 모두 0건이므로 PDF 경로를 정식 라우팅 데이터로 자동 변환하지 않는다.

## PLANTS 적재 규칙

초기 계층은 다음과 같이 구성한다.

| PLANT_TYPE | PLANT_CODE | SHOP_CODE | LINE_CODE | CELL_CODE | 내용 |
|---|---|---|---|---|---|
| PLANT | `EUNSUNG` | `-` | `-` | `-` | 은성전장 홍성공장 |
| SHOP | `EUNSUNG` | `2F` | `-` | `-` | 2층 작업장 |
| LINE | `EUNSUNG` | `2F` | `PROD2` | `-` | 생산2팀 |
| CELL | `EUNSUNG` | `2F` | `PROD2` | `50`~`64` | Oracle 조립라인 15건 |

공통 tenant 값:

- `COMPANY='EUNSUNG'`
- `PLANT_CD='1'`

적재 원칙:

- `CELL_CODE`에는 원천 `IP_PRODUCT_LINE.LINE_CODE`를 그대로 보존한다.
- `PLANT_NAME`에는 원천 `LINE_NAME`을 사용한다.
- 원천 `LINE_STATUS='N'`인 15건은 정상 후보로 적재한다.
- `MERGE`로 재실행 가능하게 작성하고 다른 `PLANTS` 행은 변경하지 않는다.
- CELL 관리 화면에서 명칭, 사용 여부, 표시 순서를 관리한다.
- 공정 그룹과 제품 라우팅은 CELL 자체와 분리한다.

## 구현 영향

- MOBILE의 LINE/CELL 선택 API는 `PLANTS` CELL 15건을 반환한다.
- 공정 그룹 9개를 9개 CELL로 seed하지 않는다.
- WAVE 1·2, ICT 1~4, 검사 3, 코팅 1~8, 조립 H/Y/A/D/B/K는 상세 공정 LINE 자료로 보존하지만 2층 CELL 목록에는 넣지 않는다.
- 공정별 OEE가 추가되면 `resourceType=LINE`으로 위 상세 LINE을 별도 등록한다.
- 라우팅 데이터가 비어 있으므로 현재 비가동 이벤트에는 CELL과 작업자·사유만 필수로 하고 모델별 자동 라우팅 검증은 후속으로 둔다.

## 검증 기준

1. 개발 DB `PLANTS`에 `2F/PROD2` CELL이 정확히 15건 존재한다.
2. CELL 코드는 `50`~`64`, 명칭은 `IP_PRODUCT_LINE`과 일치한다.
3. `GP-12`, `REPAIR`, SMT·WAVE·ICT·코팅 공정 LINE은 CELL 선택 목록에 나오지 않는다.
4. `LINE_STATUS='N'`을 정상으로 처리한다.
5. PDF 공정 그룹은 CELL 명칭으로 생성되지 않는다.
6. 미확정 제품 라우팅을 자동 생성하지 않는다.
