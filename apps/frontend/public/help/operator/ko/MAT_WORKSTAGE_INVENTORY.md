# 공정재고조회 운영자 안내

이 화면은 `IM_ITEM_WORKSTAGE_INVENTORY`의 조직별 공정재고를 `ID_ITEM` 품목정보와 함께 조회합니다. 원본 화면은 PowerBuilder `W_MAT_WORKSTAGE_INVENTORY_QUERY`, DataWindow는 `d_mat_workstage_inventory_query`입니다.

## 조회 조건

- **품목**: 선택한 품목코드 전방 일치 조건
- **0 재고 포함**: 선택 시 전체, 해제 시 `INVENTORY_QTY > 0`
- **조직**: 로그인 토큰의 조직 ID를 서버에서 강제 적용

## 데이터 확인

품목코드와 조직 ID를 기준으로 공정재고와 품목 마스터를 조인합니다. 수량이 예상과 다르면 동일 조직의 `IM_ITEM_WORKSTAGE_INVENTORY.INVENTORY_QTY`와 `ID_ITEM` 등록 여부를 함께 확인하십시오.
