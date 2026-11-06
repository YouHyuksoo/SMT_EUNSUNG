# 공정재고조회 운영자 안내

이 화면은 `IM_ITEM_WORKSTAGE_INVENTORY`의 조직별 공정재고를 `ID_ITEM` 품목정보와 함께 조회합니다. 원본 화면은 PowerBuilder `W_MAT_WORKSTAGE_INVENTORY_QUERY`, DataWindow는 `d_mat_workstage_inventory_query`입니다.

## 조회 조건

- **품목**: 선택한 품목코드 전방 일치 조건
- **품목구분**: `ID_ITEM.ITEM_DIVISION` 일치 (공통코드 `ITEM DIVISION`)
- **품목분류**: `ID_ITEM.ITEM_CLASS` 일치 (공통코드 `ITEM CLASS`)
- **공급상**: `ID_ITEM.SUPPLIER_CODE` 일치
- **0 재고 포함**: 선택 시 전체, 해제 시 `INVENTORY_QTY > 0`
- **조직**: 로그인 토큰의 조직 ID를 서버에서 강제 적용

## 데이터 확인

품목코드와 조직 ID를 기준으로 공정재고와 품목 마스터를 조인하고, 공급상명은 `ICOM_SUPPLIER`에서 가져옵니다(공급상 미등록 품목도 조회됨). 수량이 예상과 다르면 동일 조직의 `IM_ITEM_WORKSTAGE_INVENTORY.INVENTORY_QTY`와 `ID_ITEM` 등록 여부를 함께 확인하십시오.

## 제품(미입고 박스) 탭

`IP_PRODUCT_PACK_MASTER`에서 `RECEIPT_FLAG`가 'Y'가 아니고 `SHIP_FLAG`가 'Y'가 아니며 `PACK_DATE`가 2026-10-01 이후이고 완제품 실적 전환 시각(`ISYS_CONFIG.WIP_RESULT_CONSUME_FROM`) 전인 박스를 `MODEL_NAME`·`PART_NO`로 묶습니다. 생산투입 제외 모델(`DANA-LPS-680pF`)은 뺍니다. 조건은 `apps/backend/src/modules/inventory-query/wip-bom.ts`의 `wipUnreceivedPackWhere` 한 곳에서 관리합니다.

공정재고 장부(`IM_ITEM_WORKSTAGE_INVENTORY`)는 품목 합계입니다. 박스의 자재는 제품창고 입고 후 생산투입 잡(`P_WIP_ISSUE_CREATE`)이 BOM으로 차감하므로, 입고 전 박스의 자재는 장부에 남아 있습니다. 2026-10-01 이전 포장분은 옛 규칙으로 포장 때 자재를 일부 차감했기 때문에 이 탭에서 제외합니다. 전환 뒤에는 조립라인 완제품 실적(`IP_PRODUCT_RESULT`)이 `P_PRODUCT_RESULT_WIP` 로 제품 공정입고(`ENTER_BY = PROD_RT`)와 반제품·자재 소모를 하고, 박스는 제품창고 입고 때 제품 공정출고(`ENTER_BY = FG_RECEIPT`)만 합니다.

## 공정별 · 공정 이동 탭 (2026-10-18)

- 공정입고·출고에 `WORKSTAGE_CODE` 칼럼이 있습니다(기본 `*` = 공정 미지정). 공정은 반제품에만 붙입니다: AOI 실적(`P_ASSY_RESULT_ADD`) 반제품 입고는 `W180`(1층 SMT), 원자재 출고는 `*`. 제품 입고 차감(`P_WIP_ISSUE_CREATE`)은 반제품을 지금 있는 공정(후공정 우선, 수량 많은 곳, 없으면 W180)에서 뺍니다.
- 공정별 현재고는 `IM_ITEM_WORKSTAGE_INV_WS`(품목·공정, 트리거 `TRG_IM_WS_RECEIPT_INV_WS`·`TRG_IM_WS_ISSUE_INV_WS`)입니다. 품목 합계는 `IM_ITEM_WORKSTAGE_INVENTORY` 와 같습니다. 공정별 탭은 `WORKSTAGE_CODE <> *` 이고 수량이 0 이 아닌 행입니다.
- 공정 이동: 공정 IO(`IP_PRODUCT_WORKSTAGE_IO`)에 W180 이 아닌 공정의 투입(`IO_DEFICIT = I`) 행이 들어오면 트리거 `TRG_IP_PRODUCT_WS_IO_WIP_MOVE` 가 `P_WIP_MOVE_BY_MAGAZINE` 을 부릅니다.
  - `SERIAL_NO` = 매거진 라벨(`IP_PRODUCT_RUN_CARD_IO.MAGAZINE_LABEL_NO`), 품목 = 그 런의 반제품(`F_GET_ASSY_SEMI_ITEM`), 수량 = `IO_QTY`(없으면 장입수량).
  - 출발 공정 = 그 라벨의 마지막 도착 공정(`IM_ITEM_WS_MOVE`), 처음이면 W180. 출고(출발) + 입고(도착) 한 쌍, `ENTER_BY = WS_MOVE`, `LAST_MODIFY_BY` = 라벨.
  - 라벨·도착 공정당 한 번(`IM_ITEM_WS_MOVE` PK). 전환(`WIP_DIRECT_CONSUME_FROM`) 전에 발행한 매거진은 옮기지 않습니다.
  - 스캔은 막지 않습니다(자율 트랜잭션). 실패는 `ISYS_BATCHJOBERRLOG`(`WIP_MOVE` / NG). 놓친 스캔은 매일 07:45 잡 `P_WIP_MOVE_FROM_WS_IO(48)` 이 채웁니다.
  - 품목 합계로 0 이라 재고마감·공정 수불원장·공정재고 원장·인팩 전송에서는 뺍니다.
