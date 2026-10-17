# 공정재고 재설계 — AOI 실적으로 반제품 공정입고 (2026-10-17)

상태: 설계 초안 (구현 전). 대체 대상: `apps/backend/src/migrations/2026-10-02_smt_backflush.sql`(미적용 초안).

**결정 (2026-10-17 사용자 확인):**
- AOI 실적을 센서실적(`IP_PRODUCT_SENSOR_ACTUAL*`)에 넣던 구조를 **조립실적(`IP_ASSEMBLY_RESULT`)**으로 옮긴다.
- 조립실적이 생길 때 공정재고를 같이 움직인다(반제품 +, 직속 원자재 −).
- 센서실적을 계속 쌓을지(화면 호환용)는 화면 이관과 같이 정한다.

## 1. 왜 바꾸나

지금 공정재고는 여러 곳에 흩어져 서로 맞지 않는다.

| 움직임 | 지금 | 문제 |
|---|---|---|
| 공정재고 + | 자재 출고 → `IM_ITEM_WORKSTAGE_RECEIPT` (원자재만) | 반제품이 없다 |
| 공정재고 − | 제품 입고 × BOM 말단 → `P_WIP_ISSUE_CREATE` (하루 2회) | 생산하고 입고 안 한 것은 원자재로 남는다 |
| 생산실적 | 센서실적 `IP_PRODUCT_SENSOR_ACTUAL*`. PID 검사 스캔 `P_INTERLOCK_SET_CHECK_DATA` 가 공정 W050(공정 유형 REFLOW로 등록)일 때 `P_INTERLOCK_SENSOR_ACTUAL_NEO` 로 시간대별로 더한다. 실측 2026-10-15 라인 10: 센서 16,656 · AOI PID 16,544, 사실상 AOI 실적이다 | 재고와 연결되지 않는다 |
| 반제품 | 매거진 발행 `IP_PRODUCT_RUN_CARD_IO`, 공정 통과 `IP_PRODUCT_WORKSTAGE_IO` | 이력뿐이고 재고가 아니다 |
| 조립실적 | `IP_ASSEMBLY_RESULT` 0건. INSERT 트리거 없음, 계획 테이블 `IP_ASSEMBLY_MASTER_PLAN` 없음, DEL 트리거 비활성, MANUAL 트리거 `IF 1 = 2` | 레거시 자동처리가 깨져 있다 |
| 실적 기반 차감 | `IP_PRODUCT_RESULT` 트리거 → `PKG_PLANNING.plan_prod_child_item_issue` | 그 테이블이 0건이라 한 번도 돌지 않았다 |
| 인팩 전송 | 잔량 스냅샷 `ESEAI_M107` (ESEM 원자재 창고 · ESEF 원자재 공정 · ESEG 제품) | 잔량이 맞아야 맞는다 |

2026-10-16에 9월 공정 마감 기말이 196.97억이 나왔다. 2026-10-11까지 소비를 인팩 사급 자재만 빼서 장부에 11.8억 개가 쌓였기 때문이다.

## 2. 원칙

**생산 이벤트 하나 = 공정재고 움직임 한 쌍.** 생산실적과 재고는 같은 이벤트를 쓴다.

| 이벤트 | 실적 기록 | 공정재고 + | 공정재고 − |
|---|---|---|---|
| 자재 출고 | – | 원자재 | – |
| **AOI 실적** (SMT 면별) | `IP_ASSEMBLY_RESULT` | 그 면 반제품 | 그 반제품의 직속 원자재 |
| 제품 입고 | (제품 입고) | – | 제품의 직속 자품목 (반제품 + 조립 원자재) |
| 공정 폐기 | (품질 폐기) | – | 그 시점까지 만든 반제품 |

- 매거진은 보드 묶음(라벨)이다. 재고를 움직이지 않는다.
- 공정재고 장부(`IM_ITEM_WORKSTAGE_INVENTORY`)는 원자재 + 반제품을 품목 단위로 갖는다.
- 공정재고조회, 인팩 전송, 공정 마감, 공정 실사는 이 장부와 원장을 같이 쓴다.

## 3. AOI 실적 (실측 2026-10-15 하루)

- `IQ_MACHINE_INSPECT_AOI`: 126,219행, PID 90,835개, 런 40개, 라인 12개. 트리거 없음. 장비 인터페이스가 넣는다.
  - 인덱스: (INSPECT_DATE, PID), (PID, INSPECT_DATE), CSTID.
  - `INSPECT_DATE` 는 문자열 `YYYY/MM/DD HH24:MI:SS` 다.
- 같은 라인 재검사 PID 1,325개, 두 라인에 걸친 PID 17개.
- 판정: OK 124,288 · USEROK 921 · OK+리뷰OK 430 · NG+리뷰USEROK 93 · USERNG 90 · NG+리뷰USERNG 39 · MasterOK/NG 358(제외).
- 런카드 `IP_PRODUCT_RUN_CARD`: ITEM_CODE 는 완제품(F), `PCB_ITEM` 이 면(T/B)이다. 라인·런 번호는 AOI 행에 있다.
- BOM 예: `E2010000480` → 반제품 `E2040100510`(PCB ASSY, 자품목 5개) + 원자재 COATING.
- OEE 런 마감 미리보기(`smt-close-run-preview.service.ts`)가 이미 AOI로 생산수량을 센다.
  - PID별 최신 판정이고, Master 판정은 제외하며, 판정 충돌을 검출한다.
  - 같은 판정 규칙을 쓴다.

**실적 1건 정의:** (PID, 런, 면)의 최종 판정이 양품(OK·USEROK·리뷰 OK/USEROK)인 첫 시점.
- 재검사는 한 번만 센다.
- 최종 NG는 실적이 아니다. 리페어 후 양품이 되면 그때 실적이 된다.

## 4. 처리 흐름

AOI 테이블에 트리거를 걸지 않는다. 장비 인터페이스가 넣는 테이블이고 하루 12만 행이라, 실패하면 장비 적재가 막힌다.

1. **잡 `P_ASSY_RESULT_FROM_AOI`** (5분 주기 제안)
   - 마지막 처리 시점 이후 AOI 행을 읽는다.
   - (PID, 런, 면)이 처음 양품이 된 것만 고른다.
   - 중복 방지는 PID 단위 처리 기록으로 한다. `IP_ASSEMBLY_RESULT_BARCODE` 재사용을 검토한다(트리거 `TRG_IP_ASSY_RESULT_BARCODE_INS` 확인 필요).
2. **`IP_ASSEMBLY_RESULT` 적재**
   - (런, 면, 반제품 품목, 라인, 처리 회차)로 묶어 수량을 넣는다.
   - 필수 칸 중 계획일·작업구분·LQC/OQC 판정·입고여부는 기본값을 쓴다. 계획 테이블이 없기 때문이다.
3. **공정 원장** (같은 트랜잭션)
   - 공정입고 `IM_ITEM_WORKSTAGE_RECEIPT`: 반제품 + 수량.
   - 공정출고 `IM_ITEM_WORKSTAGE_ISSUE`: 반제품의 직속 원자재 × BOM 수량.
   - 기존 장부 트리거(`TRG_MAT_ITEM_WS_RECEIPT_INS`·`TRG_MAT_ITEM_WS_ISSUE_INS`)가 장부를 움직인다. 구분 코드는 새로 정한다(생산입고 / 생산투입).
4. **제품 입고 소비** (`P_WIP_ISSUE_CREATE` 변경)
   - BOM 말단까지 펼치지 않고 직속 자품목만 뺀다.
   - 직속 반제품이 AOI 실적 대상(SMT 반제품)이면 공정재고에서 빼고, 아니면(팬텀) 한 단계 더 펼친다.
5. **공정 폐기:** 폐기 보드가 거친 반제품을 뺀다(10/2 초안 규칙 D).

## 5. 정해야 할 것

1. **면 → 반제품 매핑.** 런카드는 완제품 + 면(T/B)만 갖는다.
   - BOM 실측(다른 세션 2026-10-17, ESDBext 유효 BOM). 엑셀: `Downloads/BOM_TOP_BOT_구조목록_2026-10-17.xlsx`.
     - 다단계이고 최대 7단계다.

     | TOP/BOT 구조 | 부모 품목 |
     |---|---|
     | 제품 바로 아래 TOP·BOT 나란히 | 43 |
     | 중간 반제품(SUB-Assy) 아래 TOP·BOT 나란히 | 55 |
     | TOP 반제품 아래 BOT (ICCU CONTROL `M1590-239600-001T`·`-002T`) | 2 |
     | 반제품 없이 원자재만 달린 제품 | 39 / 290 |

     - TOP/BOT 구분은 품목명 기준이다. 이름에 면이 없는 단면 반제품(예: `E2040100510` PCB ASSY)은 빠져 있다.
   - 그래서 한 가지 규칙으로는 못 정한다.
     - 단면 반제품 하나뿐인 제품: 면과 상관없이 그 반제품.
     - 원자재만 있는 제품: 제품 자신이 AOI 생산 품목이다.
     - SUB-Assy가 여러 개면 TOP·BOT 이름만으로는 노드가 여러 개 걸린다.
   - **결정 방향 (2026-10-17 사용자): 제품별 "BOM 전개 방식"을 따로 관리하고, 소비 규칙을 그 방식으로 정한다.**

     | 전개 방식 | AOI 실적 (면별) | 제품 입고 소비 |
     |---|---|---|
     | ① 제품 직하 TOP·BOT | T → TOP 반제품 +, TOP 직속 원자재 − / B → BOT 동일 | TOP·BOT 반제품 + 제품 직속 원자재 |
     | ② SUB-Assy 아래 TOP·BOT | ①과 같다 (SUB-Assy는 AOI가 없는 팬텀) | TOP·BOT 반제품 + SUB 직속 원자재 + 제품 직속 원자재 |
     | ③ TOP 안에 BOT | B → BOT +, BOT 원자재 − / T → TOP +, TOP 직속 원자재 − **와 BOT 반제품 −** | TOP 반제품 + 제품 직속 원자재 |
     | ④ 단면 반제품 하나 | 지정한 면 하나만 → 그 반제품 +, 직속 원자재 − (양면 보드면 나머지 면 AOI는 세지 않는다) | 반제품 + 제품 직속 원자재 |
     | ⑤ 원자재만 (반제품 없음) | 지정한 면 하나만 → **제품 자신** +, 직속 원자재 − | 제품 1:1 (공정재고에서 제품을 뺀다) |
     | 미분류 | 재고를 움직이지 않고 "미분류" 목록에 남긴다 | 지금 규칙(BOM 말단 소비)을 유지한다 |

     - **기준정보** (제품 1행): 전개 방식, 면별 AOI 생산 품목(T·B), 실적을 세는 면(④⑤), 입고 소비 품목 목록(자동 계산 결과를 저장해 사람이 확인).
     - **구현 (2026-10-17, 사용자 지시 "ip_product_model_master 에 분류기준을 등록해서 관리"):** `IP_PRODUCT_MODEL_MASTER` 에 둔다.
       - 칼럼: `BOM_EXPLODE_TYPE`, `BOM_EXPLODE_SOURCE`(A 자동 / M 사람), `BOM_EXPLODE_NOTE`
       - 면별 생산 품목은 기존 `TOP_ITEM_CODE`·`BOTTOM_ITEM_CODE` 를 쓴다.
       - 세는 면은 생산 품목이 채워진 면이다.
       - 화면: 제품모델관리 (자동 분류 · 행 편집). 키는 `MODEL_NAME` 이다.
     - **자동 분류:** BOM과 품목명(TOP/BOT)으로 ①~⑤를 먼저 채운다. 애매한 품목(SUB-Assy 여러 개, 이름에 면 없음)은 미분류로 두고 화면에서 사람이 정한다.
     - **BOM이 바뀌면** 그 제품을 "재확인 필요"로 표시한다(BOM 변경일 > 기준정보 확인일).
   - **자동 분류 1차 결과** (2026-10-17, ESDBext 유효 BOM, 완제품 297개)
     - 엑셀: `Downloads/BOM_전개방식_자동분류_2026-10-17.xlsx`

     | 전개 방식 | 전체 | 최근 6개월 생산 |
     |---|---|---|
     | ① 제품 직하 TOP·BOT | 35 | 17 |
     | ② SUB-Assy 아래 TOP·BOT | 26 | 4 |
     | ③ TOP 안에 BOT | 2 | 1 |
     | ④ 단면 반제품 하나 | 148 | 65 |
     | ⑤ 원자재만 | 45 | 15 |
     | 미분류 | 36 | 17 |
     | BOM 없음 | 5 | 1 |

     - 면은 BOM 행 `PCB_ITEM` 이 있으면 그것을 쓰고, 없으면 품목명(TOP/BOT)을 쓴다. `PCB_ITEM` 은 10,495행 중 137행에만 있다.
     - **미분류 대부분**은 TOP/BOT 이름이 없는 SMT 반제품이 2~3개인 제품이다.
       - 예: `E1710000570` NE-EV-VOLT-SNSG-RR, ETT28 SUB ASSY 계열, ICCU CONTROL.
       - 런카드 면은 T 하나뿐인 경우가 많아, 한 런이 어느 반제품을 만들었는지 면으로는 못 가른다.
       - 피더 레이아웃 부품 겹침(10/2 초안)으로 런마다 정하거나, 런카드에 생산 반제품을 지정해야 한다.
     - **면 확인 필요 4건:** ④⑤인데 런카드가 양면(BT)이다(`E0010001300`, `E0510000020`, `E1810000050`, `M1590-067700`). 세는 면을 지정해야 한다.
     - ①인데 최근 런카드 면이 비어 있는 1건: `E2010000250`.
2. **PID 1개 = 반제품 1개인가.** 배열(어레이) 보드면 PID와 개수가 다를 수 있다. `ARRAY_NO` 는 비어 있다.
3. **인팩 전송 범위.**
   - AOI 시점에 원자재가 빠지면, 인팩 사급 원자재가 반제품으로 바뀌어 ESEF·ESEG 어디에도 안 나간다.
   - 반제품을 BOM으로 풀어 ESEF에 더할지, 반제품 코드로 따로 보낼지 정해야 한다.
4. **반제품 단가.** 공정 마감 단가는 자재 마감(원자재) 평균단가라 반제품은 0원이다.
   - 직속 자품목 단가를 합산해 원가를 올리는 계산이 필요하다.
5. **생산실적 화면 기준.** 백엔드 15개 파일이 센서실적을 읽는다(생산현황판, 설비현황판, 작업실적, SMD실적, 피더모니터 등).
   - 조립실적으로 옮긴 뒤 화면을 하나씩 조립실적 기준으로 바꾼다.
   - 다 옮기기 전까지는 센서실적 적재를 같이 유지한다.
   - 센서실적은 시간대 누계(PRODUCT_ACTUAL_SUM 등)라 실시간 현황판에 쓰인다. 조립실적에서 같은 집계를 만들 수 있는지 확인한다.
6. **전환일.**
   - 그날 이후 AOI부터 새 규칙을 적용한다.
   - 그 전 포장 박스는 지금 규칙(말단 소비)으로 처리한다.
   - 전환 시점 공정의 반제품 기초는 0으로 두고, 11월 말 실사로 맞춘다.

## 5-1. 1단계 구현 (2026-10-17 적용, 재고 무관)

- **프로시저** `P_ASSY_RESULT_FROM_AOI(p_lookback_hours, p_from, p_to)` — 소스 `oracle_db_scripts/P_ASSY_RESULT_FROM_AOI.sql`
  - 판정: (PID, 면)의 최신 검사 행 `NVL(REVIEW_RESULT, RESULT)` 가 OK·GOOD·PASS·USEROK 면 양품이다. Master 판정은 뺀다. 같은 시각에 판정이 엇갈리면 불량으로 본다.
  - 면은 런카드 `PCB_ITEM` 이고, 생산 품목은 런카드 모델의 `TOP_ITEM_CODE`/`BOTTOM_ITEM_CODE` 다.
  - 생산 품목이 없거나, 품목 마스터·라인 마스터에 없으면 넣지 않는다(조립실적 외래키). 기준정보를 채운 뒤 `p_from` 으로 다시 돌린다.
  - 중복 방지: `IP_ASSEMBLY_RESULT_AOI_PID` (PID, 면, 조직 PK).
  - 조립실적 1행 = (작업일, 런, 라인, 면, 생산 품목).
    - 공정 W060, LQC·OQC = P, 작업구분 P
    - `WORKSTAGE_ISSUE_YN = 'N'`, `ENTER_BY = 'AOI_JOB'`
    - 시작·종료 칼럼은 HH24MI, 실제 일시는 `PRODUCT_ACTUAL_TIME`
  - 시작: `ISYS_CONFIG.ASSY_RESULT_AOI_FROM = '2026/10/17 00:00:00'`
- **잡:** 141 = 5분마다 최근 2시간, 142 = 매일 07:40 최근 48시간. AOI 리뷰가 다음 날 새벽까지 붙기 때문이다.
- **DDL:** `apps/backend/src/migrations/2026-10-17_assy_result_from_aoi.sql`
- **첫 적재** (2026-10-17 00:00~08:21 AOI)
  - 양품 PID·면 20,566개
    - 적재: 19,001개 → 조립실적 8행
    - 빠짐: 1개, ICCU B면 반제품 `M1590-204701-002` 가 품목 마스터에 없다
    - 생산 품목 없음: 1,564개, `SM100-SUB-PCB ASSY`(원자재만인데 양면 런이라 세는 면 미지정)
  - 처리 시간 3초.

## 5-2. 실시간 전환 (2026-10-17 15:33:42 적용)

사용자 지시:
- "aoi 는 잡으로 처리할게 아닌데 실시간 처리해야 하는데"
- "인팩으로 전송하기 위한 흐름을 다른 임시 테이블을 이용하게 하고 정상적인 처리를 실시간으로 assembly_result 와 소모가 실시간 처리되게 하자"
- "지금 전환"

- **실시간:** 트리거 `TRG_IQ_AOI_ASSY_RESULT`(AOI INSERT·판정/리뷰 UPDATE) → 자율 트랜잭션에서 `P_ASSY_RESULT_ADD_PID`.
  - 실패해도 AOI 적재는 막지 않는다. 오류 로그만 남긴다(`ISYS_BATCHJOBERRLOG`, `TRG_IQ_AOI_ASSY_RESULT` / NG).
  - 같은 시각 충돌(ORA-00001)은 한 번 다시 한다.
- **조립실적:** (작업일, 런, 라인, 생산 품목, 시간대, 소모 여부) 한 행에 수량을 더한다.
  - `WORKSTAGE_ISSUE_YN = 'Y'` 는 공정재고에 반영한 행, `'N'` 은 전환 전 검사분이다.
- **공정재고:** 시간대·품목별 한 행, `ENTER_BY = 'AOI_RT'`. 함수 기반 유일 인덱스로 중복 행을 막는다.
  - 공정입고 구분 1: 생산 품목 +1
  - 공정출고 구분 3: 직속 자품목 × 소요량. AOI로 만들지 않는 반제품은 펼친다.
- **제품 입고:** `P_WIP_ISSUE_CREATE` 가 전환 이후 포장 박스 중 전개 방식이 정해진 모델에 직속 규칙을 쓴다.
  - 원자재만인 제품은 제품 1:1로 뺀다.
  - 나머지 박스는 예전처럼 BOM 말단까지 뺀다.
- **인팩 전송:** `IM_ITEM_WS_INV_INFAC` 를 둔다.
  - 시작값: 장부의 IP 자재 19품목, 10,108,829개.
  - 움직임: 공정입고(AOI_RT 제외) +, 실사 조정 −, 제품 입고 × BOM 말단(모든 박스) −.
  - `P_JOB_INFAC_DATA_CREATE`·`_MANUAL` 의 ESEF 는 이 테이블을 읽는다.
- **보정 잡:** 5분 잡은 지웠다. 142(매일 07:40, 최근 48시간)만 남겼다.
- **죽은 트리거 비활성화:** `TRG_IP_ASSEMBLY_RESULT_MANUAL`
  - 본문이 IF 1 = 2 이고, 없는 테이블을 참조해 조립실적 UPDATE 가 ORA-04098 로 막혔다.
- **검증 (롤백 시험)**
  - 가짜 PID 2개: 반제품 +2, 직속 자재 5품목이 소요량 × 2 만큼 줄었다. 인팩 테이블은 그대로였다.
  - 대기 박스 47개를 직속 규칙으로 계산했다. `ME-EV-VOLT-SNSG-RR` 가 반제품 1 + COATING 1.4 로 BOM 과 같았다.
- **전환 경계의 오차:** 전환 전 AOI 를 거쳤는데 전환 후에 포장되는 보드가 있다.
  - 반제품 공정입고 없이 직속 소모만 되어 반제품이 음수가 된다.
  - 그 대신 원자재는 빠지지 않아 그만큼 남는다.
  - 11월 말 실사로 맞춘다.
- **배포 파일**
  - DDL: `apps/backend/src/migrations/2026-10-17_wip_realtime_consume.sql`
  - 소스: `oracle_db_scripts/` (P_ASSY_RESULT_ADD_PID, P_ASSY_RESULT_FROM_AOI, TRG_IQ_AOI_ASSY_RESULT, P_WIP_ISSUE_CREATE, P_JOB_INFAC_DATA_CREATE(_MANUAL))

## 5-3. 생산실적 = 조립실적 (2026-10-17 적용)

사용자 지시:
- "지금 전환하고 기존에 sensor_actual 을 사용하던 실적을 assembly_result 로 전환"
- "조립실적 보정 기능을 따로 만들어야지 당연히 수기도 조립실적에 넣어야함"

- **쓰기 하나:** `P_ASSY_RESULT_ADD(런, 라인, 실적 시각, 수량, AOI|MANUAL|ADJUST, 비고, 사용자)`.
  - AOI는 시간·시간대 행에 더하고, MANUAL(`ENTER_BY=WORK_RESULT`)·ADJUST(`ASSY_ADJUST`)는 자기 행을 넣는다.
  - 전환 이후 시각이면 공정입고·출고도 같은 규칙으로 만든다(음수면 구분 2·4).
- **수기:** 작업실적 완료(SMT 라인)는 센서 프로시저 대신 MANUAL로 넣는다. 취소하면 같은 실적 시각에 음수 행을 넣는다.
- **보정:** 행을 고치거나 지우지 않고 보정 행을 더한다. 사유는 필수다.
  - API: `POST /production/assembly-results/adjust`
  - 반제품생산실적관리 화면: 보정 등록 / 수정(새 수량 − 지금 수량) / 삭제(−지금 수량)
  - 330 생산실적 조회: 실적 보정
- **읽기:** 뷰 `IP_ASSEMBLY_RESULT_SENSOR_V`. 예전 센서 시간대 테이블과 칼럼 이름이 같다.
  - `IP_ASSEMBLY_ACTUAL_TIME_V`·`_DAY_V`·`_MONTH_V`, `IP_PRODUCT_ACTUAL_MONTH_V` 가 이 뷰를 읽는다. 이전 정의: `docs/sql/sensor-actual-views-before-2026-10-17.sql`.
  - 라인 대시보드 `IRPT_PRODUCT_LINE_DASHBOARD.SENSOR_COUNT` = 조립실적 런 합계. 인덱스 `IX_IP_ASSEMBLY_RESULT_MFS` 추가. 원복: `docs/sql/irpt-product-line-dashboard-before-2026-10-17.sql`.
  - 백엔드: 반제품생산실적관리, 330 조회, 설비현황판·생산현황판 마지막 실적, 피더 모니터, 런카드 실적 건수·삭제 차단.
- **센서실적 적재:** `P_INTERLOCK_SENSOR_ACTUAL_NEO` 는 장비 쪽 호출이 남아 있어 그대로 둔다. 화면·뷰는 더 이상 읽지 않는다.
- **양면 런 단면 모델** (사용자: "단면 자체도 한개의 모델로 봐야함"):
  - 원자재만(RAW)·단면 반제품(SINGLE)인데 런카드가 T·B 둘 다인 모델은 각 면을 하나의 모델 생산으로 본다. TOP_ITEM_CODE = BOTTOM_ITEM_CODE = 같은 품목, 실적은 면마다 다 센다.
  - BOM 에 면 구분이 없어 자재를 면별로 나눌 수 없다. 그래서 `P_ASSY_RESULT_ADD` 는 TOP = BOTTOM 이면 공정입고·출고를 면마다 × 0.5 로 움직인다(두 면을 거쳐 1개).
  - 적용 모델 6개: SM100-SUB-PCB ASSY, SDH110_PCB ASSY, IG-MAIN-PCB ASSY, IG-MAIN-PCB A'SSY, EOP36-LF-PCB ASSY, OS-EV-19MY-FILTER. 오늘(10-17) AOI 는 보정 잡으로 다시 채웠다(SM100 T 25,620 / B 40,068).
- **SMT 반제품 + 조립 SUB ASSY 모델** (DN8-PE-HOUSING-ASSY, MV-EV-CURRENT-SENSOR, NE-EV-VOLT-SNSG-FRT/RR-2P6S):
  - SMT 런카드는 T면뿐이고, 면이 빈 런카드는 61·62 조립라인 런이다(T·B 를 생산하면 면마다 작업지시·런카드를 따로 발행한다).
  - T면 = SMT 반제품(PCB ASSY), 분류 SINGLE, 사람 지정(BOM_EXPLODE_SOURCE = 'M')으로 넣었다.
- **런카드 번호가 `*` 인 AOI 행**은 2D 바코드·마킹(LOTID)·SPI 어디에도 런이 없어 넣지 않는다.
- **배포 파일:** `apps/backend/src/migrations/2026-10-17_assy_result_as_production_actual.sql`, `2026-10-17_line_dashboard_assy_result.sql`, `oracle_db_scripts/P_ASSY_RESULT_ADD.sql`

## 6. 단계

1. 5장 1·2·3을 결정하고 이 문서를 고친다.
2. 잡 + 조립실적 적재 + 공정입고·출고를 만든다. 검증 DB에서 하루치 AOI를 재생해 수량을 대조한다(AOI 양품 PID 수 = 조립실적 합계).
3. `P_WIP_ISSUE_CREATE` 를 직속 자품목 소비로 바꾼다. 전환일 이후 포장분만 대상이다.
4. 공정재고조회에 반제품을 표시하고, 공정 마감에 반제품 원가를 넣는다.
5. 인팩 전송을 결정 사항대로 바꾼다.
6. 생산실적 화면을 조립실적 기준으로 옮기고, 다 옮기면 센서실적 적재를 끝낸다.
