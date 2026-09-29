/**
 * @file packages/shared/src/popups/catalog.ts
 * @description PB 팝업 ↔ 웹 팝업 카탈로그 (이관 이력의 단일 출처)
 *
 * PB 창을 웹으로 옮길 때 그 창이 여는 팝업은 **여기를 먼저 조회한다.**
 * - `pbWindows` 에 대상 PB 팝업이 있으면 → 등록된 것을 연결한다. 새로 만들지 않는다.
 * - 없으면 → 팝업을 만들고 같은 변경에서 이 배열에 엔트리를 추가한다.
 *
 * 전체 PB 팝업 실측 목록(221개, 호출관계 기준)은 자동 생성물이다:
 *   docs/database/generated/pb-popup-inventory.json
 * 이 카탈로그와 인벤토리를 대조한 이관 현황:
 *   docs/business-logics/pb-popup-migration-status.md  (pnpm gen:popup-status)
 *
 * `query` 가 있는 엔트리는 백엔드 `modules/popup-search/popup-search.queries.ts` 의
 * 같은 이름 SQL 로 조회된다. 둘의 짝이 맞는지는 백엔드 테스트가 검사한다.
 */
import type { PopupEntry } from './types';

export const POPUP_CATALOG: readonly PopupEntry[] = [
  // ── 전용 컴포넌트 (이 카탈로그보다 먼저 존재했다. 자기 도메인 API 를 쓴다) ──
  {
    id: 'part-search',
    pbWindows: ['w_des_item_popup', 'w_des_set_item_popup'],
    kind: 'search-select',
    status: 'ready',
    title: '품목검색',
    component: '@/components/shared/PartSearchModal',
    endpoint: '/master/parts',
    returnColumns: ['item_code'],
    note: 'PB 는 품목/세트품목 팝업이 분리돼 있으나 웹은 itemType 필터로 합쳤다.',
  },
  {
    id: 'model-search',
    pbWindows: ['w_des_model_master_popup'],
    kind: 'search-select',
    status: 'ready',
    title: '모델검색',
    component: '@/components/shared/ModelSearchModal',
    endpoint: '/master/product-models',
    returnColumns: ['model_name'],
  },
  {
    id: 'equip-search',
    pbWindows: ['w_mcn_master_popup'],
    kind: 'search-select',
    status: 'ready',
    title: '설비검색',
    component: '@/components/shared/EquipSearchModal',
    endpoint: '/equipment/equips',
    note: 'PB dataobject 는 d_mcn_machine_popup.',
  },
  {
    id: 'line-select',
    pbWindows: ['w_plan_line_workstage_popup'],
    kind: 'search-select',
    status: 'ready',
    title: '라인선택',
    component: '@/components/common/LineSelectModal',
    endpoint: '/api/display/lines',
    returnColumns: ['line_code'],
    note: 'display 계열 Next API Route 를 쓴다. 업무화면에서 재사용할 때 엔드포인트 확인 필요.',
  },

  // ── 엔진 설정형 (SearchSelectModal + 공용 팝업조회 API) ──
  {
    id: 'supplier-search',
    pbWindows: ['w_com_supplier_popup'],
    kind: 'search-select',
    status: 'ready',
    title: '공급처검색',
    query: 'supplier-search',
    returnColumns: ['supplierCode', 'supplierName'],
    filters: [
      { key: 'supplierCode', label: '공급처코드', type: 'text', autoFocus: true },
      { key: 'supplierName', label: '공급처명', type: 'text' },
    ],
    columns: [
      { key: 'supplierCode', label: '공급처코드', width: 130 },
      { key: 'supplierName', label: '공급처명', width: 220 },
      { key: 'supplierNameEng', label: '영문명', width: 180 },
      { key: 'businessNo', label: '사업자번호', width: 130 },
      { key: 'ownerName', label: '대표자', width: 100 },
      { key: 'telNo', label: '전화번호', width: 130 },
    ],
    note:
      'PB d_com_supplier_popup — ARG_SUPPLIER_CODE(앞자리 LIKE) / ARG_SUPPLIER_NAME(부분 LIKE), ' +
      "SUPPLIER_CODE <> '*' 제외 조건 포함. 금형 공급처 팝업은 업종 조건이 달라 별도 엔트리다.",
  },
  {
    id: 'customer-search',
    pbWindows: ['w_com_customer_popup'],
    kind: 'search-select',
    status: 'ready',
    title: '고객검색',
    query: 'customer-search',
    returnColumns: ['customerCode', 'customerName'],
    filters: [
      { key: 'customerCode', label: '고객코드', type: 'text', autoFocus: true },
      { key: 'customerName', label: '고객명', type: 'text' },
      { key: 'saleCharge', label: '영업담당', type: 'text' },
    ],
    columns: [
      { key: 'customerCode', label: '고객코드', width: 130 },
      { key: 'customerName', label: '고객명', width: 220 },
      { key: 'customerNameEng', label: '영문명', width: 180 },
      { key: 'businessNo', label: '사업자번호', width: 130 },
      { key: 'ownerName', label: '대표자', width: 100 },
      { key: 'telNo', label: '전화번호', width: 130 },
    ],
    note:
      'PB d_com_customer_popup — 정렬도 PB 와 같다(BUSINESS_TYPE, CUSTOMER_CODE). ' +
      "CUSTOMER_CODE <> '*' 제외 조건과 NVL(SALE_CHARGE,'*') 비교를 그대로 옮겼다.",
  },
  {
    id: 'mold-supplier-search',
    pbWindows: ['w_com_mold_supplier_popup'],
    kind: 'search-select',
    status: 'ready',
    title: '금형 공급처검색',
    query: 'mold-supplier-search',
    returnColumns: ['supplierCode', 'supplierName'],
    filters: [
      { key: 'supplierCode', label: '공급처코드', type: 'text', autoFocus: true },
      { key: 'supplierName', label: '공급처명', type: 'text' },
    ],
    columns: [
      { key: 'supplierCode', label: '공급처코드', width: 130 },
      { key: 'supplierName', label: '공급처명', width: 220 },
      { key: 'supplierNameEng', label: '영문명', width: 180 },
      { key: 'businessNo', label: '사업자번호', width: 130 },
      { key: 'ownerName', label: '대표자', width: 100 },
      { key: 'telNo', label: '전화번호', width: 130 },
    ],
    note:
      'PB d_com_mold_supplier_popup — 공급처 팝업과 필터는 같지만 ' +
      "BUSINESS_CATEGORY = 'M' 조건이 더 있다. 그래서 공급처검색과 합치지 않았다. " +
      '은성 DB 는 현재 모든 공급처의 BUSINESS_CATEGORY 가 NULL 이라 결과가 0건이다.',
  },
  {
    id: 'mold-search',
    pbWindows: ['w_mcn_mold_popup'],
    kind: 'search-select',
    status: 'ready',
    title: 'S-PARTS 검색',
    query: 'mold-search',
    returnColumns: ['moldCode', 'moldName', 'moldVersion', 'moldSetSerial'],
    filters: [
      { key: 'moldCode', label: 'S-PARTS 코드', type: 'text', autoFocus: true },
      { key: 'supplierCode', label: '공급처', type: 'text' },
      { key: 'moldGroup', label: 'S-PARTS 그룹', type: 'com-code', groupCode: 'MOLD GROUP' },
    ],
    columns: [
      { key: 'moldCode', label: 'S-PARTS 코드', width: 150 },
      { key: 'moldName', label: 'S-PARTS 명', width: 200 },
      { key: 'moldGroupName', label: '그룹', width: 120 },
      { key: 'moldSpec', label: '규격', width: 160 },
      { key: 'supplierName', label: '공급처', width: 160 },
      { key: 'moldVersion', label: '버전', width: 70, align: 'right' },
      { key: 'moldSetSerial', label: 'SET번호', width: 80, align: 'right' },
      { key: 'moldUseStatusName', label: '사용상태', width: 100 },
      { key: 'inventoryQty', label: '재고수량', width: 90, align: 'right' },
      { key: 'locationCode', label: '보관위치', width: 110 },
    ],
    note:
      'PB d_mcn_mold_popup — IMCN_MOLD 기준 좌측 외부조인으로 재고·공급처를 붙인다. ' +
      "PB 의 MOLD_CODE <> '*' 제외 조건을 유지한다. 재고행이 없으면 버전·SET번호가 비어 나온다. " +
      '연결: app/(authenticated)/mold/components/MoldCodeField.tsx (S-PARTS 8화면 조회조건 + 주문 등록).',
  },
  {
    id: 'mold-location-search',
    pbWindows: ['w_mcn_mold_location_popup'],
    kind: 'search-select',
    status: 'ready',
    title: 'S-PARTS 보관위치 검색',
    query: 'mold-location-search',
    returnColumns: ['moldLocationCode', 'moldLocationName'],
    filters: [
      { key: 'moldLocationCode', label: '위치코드', type: 'text', autoFocus: true },
      { key: 'moldGroup', label: 'S-PARTS 그룹', type: 'com-code', groupCode: 'MOLD GROUP' },
    ],
    columns: [
      { key: 'moldLocationCode', label: '위치코드', width: 130 },
      { key: 'moldLocationName', label: '위치명', width: 200 },
      { key: 'moldLocationGroup', label: '위치그룹', width: 110 },
      { key: 'moldLocationNo', label: '위치번호', width: 90, align: 'right' },
      { key: 'moldLocationStatus', label: '상태', width: 80 },
      { key: 'moldCode', label: '적치 S-PARTS', width: 150 },
      { key: 'moldGroupName', label: 'S-PARTS 그룹', width: 120 },
    ],
    note:
      'PB d_mcn_mold_location_popup — IMCN_MOLD_LOCATION 단일 테이블. ' +
      'PB 는 S-PARTS 코드로도 걸렀지만 웹에서는 위치코드·그룹으로 찾는 쪽이 쓰기 편해 필터를 그렇게 뒀다. ' +
      '연결: app/(authenticated)/mold/receipt (입고 등록의 보관위치).',
  },
];

const BY_PB_WINDOW = new Map<string, PopupEntry>();
const BY_ID = new Map<string, PopupEntry>();
const BY_QUERY = new Map<string, PopupEntry>();
for (const entry of POPUP_CATALOG) {
  BY_ID.set(entry.id, entry);
  if (entry.query) BY_QUERY.set(entry.query, entry);
  for (const pbWindow of entry.pbWindows) {
    BY_PB_WINDOW.set(pbWindow.toLowerCase(), entry);
  }
}

/** PB 창 이름으로 등록된 웹 팝업을 찾는다. 이관 작업의 첫 조회 지점 */
export function findPopupByPbWindow(pbWindow: string): PopupEntry | undefined {
  return BY_PB_WINDOW.get(pbWindow.trim().toLowerCase());
}

export function findPopupById(id: string): PopupEntry | undefined {
  return BY_ID.get(id);
}

/** 공용 팝업조회 API 의 쿼리명으로 찾는다 (백엔드 화이트리스트 검증) */
export function findPopupByQuery(query: string): PopupEntry | undefined {
  return BY_QUERY.get(query);
}
