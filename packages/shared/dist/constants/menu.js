"use strict";
/**
 * @file packages/shared/src/constants/menu.ts
 * @description 메뉴 구조 상수 정의
 *
 * 초보자 가이드:
 * 1. **icon**: Lucide React 아이콘 이름 (실제 렌더링은 프론트엔드에서)
 * 2. **children**: 하위 메뉴가 있는 경우
 * 3. **permission**: 해당 메뉴에 접근 가능한 권한
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.MENU_ITEMS = void 0;
exports.findMenuByKey = findMenuByKey;
exports.findMenuByPath = findMenuByPath;
/** 메인 메뉴 구조 */
exports.MENU_ITEMS = [
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
        ],
    },
    {
        key: 'system',
        label: '시스템관리',
        labelEn: 'System',
        labelVi: 'Hệ thống',
        icon: 'Settings',
        children: [
            { key: 'system-company', label: '회사관리', icon: 'Building2', path: '/master/company' },
            { key: 'system-code', label: '코드관리', icon: 'Tags', path: '/master/code' },
            { key: 'system-config', label: '환경설정', icon: 'Settings', path: '/system/config' },
            { key: 'system-menu-categories', label: '메뉴 카테고리 관리', icon: 'FolderTree', path: '/system/menu-categories' },
            { key: 'system-department', label: '부서관리', icon: 'Building2', path: '/system/department' },
            { key: 'system-users', label: '사용자관리', icon: 'Users', path: '/system/users' },
            { key: 'system-roles', label: '역할관리', icon: 'Shield', path: '/system/roles' },
            { key: 'system-document', label: '문서관리', icon: 'FileText', path: '/system/document' },
            { key: 'system-scheduler', label: '스케줄러', icon: 'CalendarClock', path: '/system/scheduler' },
            { key: 'system-er-view', label: 'ER VIEW', icon: 'Network', path: '/system/er-view' },
            { key: 'system-improvement-requests', label: '개선요청 관리', icon: 'MessageSquareWarning', path: '/system/improvement-requests' },
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
        children: [],
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
];
/** 메뉴 키로 메뉴 아이템 찾기 */
function findMenuByKey(key, items = exports.MENU_ITEMS) {
    for (const item of items) {
        if (item.key === key)
            return item;
        if (item.children) {
            const found = findMenuByKey(key, item.children);
            if (found)
                return found;
        }
    }
    return undefined;
}
/** 경로로 메뉴 아이템 찾기 */
function findMenuByPath(path, items = exports.MENU_ITEMS) {
    for (const item of items) {
        if (item.path === path)
            return item;
        if (item.children) {
            const found = findMenuByPath(path, item.children);
            if (found)
                return found;
        }
    }
    return undefined;
}
