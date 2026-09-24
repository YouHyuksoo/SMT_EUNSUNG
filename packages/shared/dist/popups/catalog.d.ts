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
export declare const POPUP_CATALOG: readonly PopupEntry[];
/** PB 창 이름으로 등록된 웹 팝업을 찾는다. 이관 작업의 첫 조회 지점 */
export declare function findPopupByPbWindow(pbWindow: string): PopupEntry | undefined;
export declare function findPopupById(id: string): PopupEntry | undefined;
/** 공용 팝업조회 API 의 쿼리명으로 찾는다 (백엔드 화이트리스트 검증) */
export declare function findPopupByQuery(query: string): PopupEntry | undefined;
//# sourceMappingURL=catalog.d.ts.map