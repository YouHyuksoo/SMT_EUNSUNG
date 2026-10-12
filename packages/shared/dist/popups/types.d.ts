/**
 * @file packages/shared/src/popups/types.ts
 * @description PB 팝업 ↔ 웹 팝업 계약 타입
 *
 * 프론트(엔진이 필터·컬럼을 렌더)와 백엔드(요청 파라미터 검증)가 같은 정의를 쓴다.
 * SQL 은 여기 두지 않는다 — 백엔드 전용(`modules/popup-search/popup-search.queries.ts`).
 */
/** PB 팝업의 구조 분류 — 팝업 인벤토리 JSON 의 `kind` 와 같은 값 */
export type PopupKind = 'search-select' | 'readonly' | 'complex' | 'util';
/**
 * - `ready`   : 지금 연결할 수 있다 (전용 컴포넌트 또는 엔진 설정 완비)
 * - `planned` : 정의는 확정했으나 구현/API 가 아직 없다
 * - `excluded`: 웹에서 되살리지 않는다. `note` 에 이유를 적는다
 */
export type PopupStatus = 'ready' | 'planned' | 'excluded';
export interface PopupColumn {
    /** 조회 결과의 필드명 (SQL 별칭과 같아야 한다) */
    key: string;
    /** 헤더 라벨 (기본 한국어) */
    label: string;
    /** 픽셀 폭. 미지정이면 엔진 기본값 */
    width?: number;
    align?: 'left' | 'center' | 'right';
}
/**
 * 검색 필터. `key` 는 조회 API 의 쿼리 파라미터명이자 SQL 바인드명이다.
 * 카탈로그에 없는 파라미터는 서버가 무시하지 않고 **거부한다**.
 */
export interface PopupFilter {
    key: string;
    label: string;
    /** 입력 형태. 코드성 값을 `text` 로 두지 않는다 */
    type: 'text' | 'com-code' | 'date' | 'select';
    /** `type: 'com-code'` 일 때 공통코드 그룹 */
    groupCode?: string;
    /** `type: 'select'` 일 때 고정 선택지 */
    options?: ReadonlyArray<{
        value: string;
        label: string;
    }>;
    /** 모달을 열 때 이 필터에 포커스를 준다 (한 카탈로그 엔트리에 하나만) */
    autoFocus?: boolean;
}
export interface PopupEntry {
    /** 웹 팝업 식별자 (kebab-case). 카탈로그 내 고유 */
    id: string;
    /** 대응하는 PB 창 이름. 여러 PB 창이 한 컴포넌트로 합쳐질 수 있다 */
    pbWindows: readonly string[];
    kind: PopupKind;
    status: PopupStatus;
    /** 모달 제목 (기본 한국어) */
    title: string;
    /** 전용 컴포넌트 import 경로. 엔진 설정형이면 없다 */
    component?: string;
    /**
     * 공용 팝업조회 API 의 화이트리스트 쿼리명.
     * 이 값이 있으면 엔진(`SearchSelectModal`)이 `component` 없이 동작한다.
     */
    query?: string;
    /** 조회 API 경로. 전용 컴포넌트가 자기 API 를 쓰는 경우에만 채운다 */
    endpoint?: string | null;
    /** 그리드 컬럼 (엔진 설정형에 필수) */
    columns?: readonly PopupColumn[];
    /** 검색 필터 (엔진 설정형) */
    filters?: readonly PopupFilter[];
    /**
     * 호출처에 돌려주는 필드 — PB 가 돌려주던 순서 그대로.
     * PB 전역구조체 방식(`gst_return.gvs_return[n]`)은 여러 컬럼을 넘기므로,
     * 엔진은 선택 행 객체를 통째로 넘기고 이 배열은 **읽는 순서**를 문서화한다.
     */
    returnColumns?: readonly string[];
    /** 근거·주의사항 */
    note?: string;
}
//# sourceMappingURL=types.d.ts.map