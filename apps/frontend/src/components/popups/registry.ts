/**
 * @file src/components/popups/registry.ts
 * @description 팝업 카탈로그 재노출 — 정본은 `@smt/shared` 다
 *
 * 카탈로그(PB 창 ↔ 웹 팝업 매핑, 필터·컬럼 정의)는 프론트 엔진과 백엔드 화이트리스트가
 * 함께 쓰므로 `packages/shared/src/popups/` 에 한 번만 정의한다. 여기서는 프론트에서
 * 짧게 import 할 수 있게 다시 내보내기만 한다 — **정의를 여기에 추가하지 않는다.**
 */
export {
  POPUP_CATALOG,
  findPopupByPbWindow,
  findPopupById,
  findPopupByQuery,
} from "@smt/shared";
export type {
  PopupColumn,
  PopupEntry,
  PopupFilter,
  PopupKind,
  PopupStatus,
} from "@smt/shared";
