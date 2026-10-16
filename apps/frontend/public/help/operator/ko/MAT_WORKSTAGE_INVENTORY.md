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

`IP_PRODUCT_PACK_MASTER`에서 `RECEIPT_FLAG`가 'Y'가 아니고 `SHIP_FLAG`가 'Y'가 아니며 `PACK_DATE`가 2026-10-01 이후인 박스를 `MODEL_NAME`·`PART_NO`로 묶습니다. 생산투입 제외 모델(`DANA-LPS-680pF`)은 뺍니다. 조건은 `apps/backend/src/modules/inventory-query/wip-bom.ts`의 `wipUnreceivedPackWhere` 한 곳에서 관리합니다.

공정재고 장부(`IM_ITEM_WORKSTAGE_INVENTORY`)는 원자재만 관리합니다. 박스의 자재는 제품창고 입고 후 생산투입 잡(`P_WIP_ISSUE_CREATE`)이 BOM으로 차감하므로, 입고 전 박스의 자재는 장부에 남아 있습니다. 2026-10-01 이전 포장분은 옛 규칙으로 포장 때 자재를 일부 차감했기 때문에 이 탭에서 제외합니다.

반제품 재공은 표시하지 않습니다. `IP_PRODUCT_WORKSTAGE_IO`에는 공정 In 기록만 있고, 반제품 조립 소모를 기록하는 `IP_ASSEMBLY_ISSUE`는 비어 있습니다.
