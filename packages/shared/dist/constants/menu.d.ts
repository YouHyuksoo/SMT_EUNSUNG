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
export declare const MENU_ITEMS: MenuItem[];
/** 메뉴 키로 메뉴 아이템 찾기 */
export declare function findMenuByKey(key: string, items?: MenuItem[]): MenuItem | undefined;
/** 경로로 메뉴 아이템 찾기 */
export declare function findMenuByPath(path: string, items?: MenuItem[]): MenuItem | undefined;
//# sourceMappingURL=menu.d.ts.map
