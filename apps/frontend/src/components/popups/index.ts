/**
 * @file src/components/popups/index.ts
 * @description PB 팝업 컴포넌트·카탈로그 배럴 export
 *
 * 화면을 이관할 때는 먼저 `findPopupByPbWindow('w_...')` 로 등록된 팝업을 찾고,
 * 엔진 설정형이면 `SearchSelectModal` 에 `popupId` 를 넘겨 연결한다.
 */
export { default as SearchSelectModal } from "./SearchSelectModal";
export type { PopupRow } from "./SearchSelectModal";
export * from "./registry";
