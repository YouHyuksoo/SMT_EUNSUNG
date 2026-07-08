/**
 * @file packages/shared/src/constants/menu.ts
 * @description 메뉴 구조 상수 정의
 *
 * 초보자 가이드:
 * 1. **icon**: Lucide React 아이콘 이름 (실제 렌더링은 프론트엔드에서)
 * 2. **children**: 하위 메뉴가 있는 경우
 * 3. **permission**: 해당 메뉴에 접근 가능한 권한
 */

/** 메뉴 아이템 타입 */
export interface MenuItem {
  key: string;
  label: string;
  labelEn?: string;
  labelVi?: string;
  icon: string;
  path?: string;
  permission?: string[];
  children?: MenuItem[];
}

/** 메인 메뉴 구조 */
export const MENU_ITEMS: MenuItem[] = [
  {
    key: 'master',
    label: '기준정보',
    labelEn: 'Master Data',
    labelVi: 'Dữ liệu cơ sở',
    icon: 'Database',
    children: [
      { key: 'master-part', label: '품목관리', icon: 'Box', path: '/master/part' },
      { key: 'master-bom', label: 'BOM관리', icon: 'GitBranch', path: '/master/bom' },
      { key: 'master-process', label: '공정관리', icon: 'Workflow', path: '/master/process' },
      { key: 'master-partner', label: '거래처관리', icon: 'Building', path: '/master/partner' },
      { key: 'master-company', label: '회사관리', icon: 'Building2', path: '/master/company' },
      { key: 'master-code', label: '코드관리', icon: 'Tags', path: '/master/code' },
    ],
  },
  {
    key: 'oee',
    label: 'OEE관리',
    labelEn: 'OEE Management',
    labelVi: 'Quản lý OEE',
    icon: 'Activity',
    children: [
      { key: 'oee-dashboard', label: '공정별 OEE 종합', icon: 'Activity', path: '/oee/dashboard' },
      { key: 'oee-entry', label: '가동일지 입력', icon: 'ClipboardEdit', path: '/oee/entry' },
    ],
  },
  {
    key: 'material',
    label: '자재수불관리',
    labelEn: 'Material Transaction',
    labelVi: 'Quản lý xuất nhập vật tư',
    icon: 'Package',
    children: [
      { key: 'material-request', label: '출고요청', icon: 'ClipboardList', path: '/material/request' },
      { key: 'material-issue', label: '출고관리', icon: 'PackageMinus', path: '/material/issue' },
      { key: 'material-lot', label: 'LOT관리', icon: 'QrCode', path: '/material/lot' },
      { key: 'material-transaction', label: '자재수불이력조회', icon: 'ArrowLeftRight', path: '/inventory/transaction' },
    ],
  },
  {
    key: 'process-transaction',
    label: '공정수불관리',
    labelEn: 'Process Transaction',
    labelVi: 'Quản lý xuất nhập công đoạn',
    icon: 'GitBranch',
    children: [],
  },
  {
    key: 'product-transaction',
    label: '제품수불관리',
    labelEn: 'Product Transaction',
    labelVi: 'Quản lý xuất nhập sản phẩm',
    icon: 'Boxes',
    children: [],
  },
  {
    key: 'outsourcing',
    label: '외주수불관리',
    labelEn: 'Outsourcing Transaction',
    labelVi: 'Quản lý xuất nhập gia công',
    icon: 'Building2',
    children: [],
  },
] as const;

/** 메뉴 키로 메뉴 아이템 찾기 */
export function findMenuByKey(key: string, items: MenuItem[] = MENU_ITEMS): MenuItem | undefined {
  for (const item of items) {
    if (item.key === key) return item;
    if (item.children) {
      const found = findMenuByKey(key, item.children);
      if (found) return found;
    }
  }
  return undefined;
}

/** 경로로 메뉴 아이템 찾기 */
export function findMenuByPath(path: string, items: MenuItem[] = MENU_ITEMS): MenuItem | undefined {
  for (const item of items) {
    if (item.path === path) return item;
    if (item.children) {
      const found = findMenuByPath(path, item.children);
      if (found) return found;
    }
  }
  return undefined;
}
