/**
 * @file packages/shared/src/master/item-master-columns.ts
 * @description 품목마스터(ID_ITEM) 컬럼 목록 — 백엔드 저장·검증과 화면 그리드·필터·등록창이 함께 쓴다.
 *
 * 초보자 가이드:
 * 1. **ID_ITEM 의 109개 컬럼이 빠짐없이 한 줄씩 있다.** 컬럼을 늘리거나 바꾸면 여기 한 곳만 고친다.
 *    itemMasterColumns.test.ts 가 컬럼 수·키 중복을 확인한다.
 * 2. **key 는 API 필드 이름이다.** 예전부터 쓰던 36개는 다른 화면이 읽고 있어 이름을 그대로 둔다
 *    (예: ABC_GRADE → rev, BARCODE → markingText). 라벨은 DB 의미대로 적는다.
 * 3. **edit**: always = 등록·수정 / create = 등록 때만(키) / never = 표시 전용.
 *    ROUTE_NO 는 바꾸면 DB 트리거(ID_ITEM_UPD_MANUAL)가 재고 행을 지워서 never 다.
 * 4. **LINE_TYPE·SUPPLIER_CODE·CUSTOMER_CODE 는 바꾸면 DB 트리거(TRG_ID_ITEM_UPD)가 연결 테이블을 고친다.**
 *    화면은 저장 전에 알리고, 서버는 값이 실제로 바뀐 컬럼만 UPDATE 한다
 *    (Oracle 의 UPDATE OF 트리거는 SET 에 들어가기만 해도 돈다).
 * 5. **defaultValue 는 최근 등록 데이터가 쓰는 값이다.** "today" 는 등록하는 날이다.
 */
export type ItemMasterSection = 'basic' | 'class' | 'stock' | 'material' | 'size' | 'price' | 'trade' | 'etc' | 'audit';
export type ItemMasterInput = 'text' | 'textarea' | 'number' | 'date' | 'code' | 'yn' | 'abc' | 'supplier' | 'customer' | 'line' | 'none';
export interface ItemMasterColumn {
    /** ID_ITEM 컬럼명 */
    column: string;
    /** API 필드 이름 */
    key: string;
    label: string;
    type: 'string' | 'number' | 'date';
    maxLength?: number;
    /** NUMBER(p,s) 일 때만 */
    precision?: number;
    scale?: number;
    /** NOT NULL */
    required: boolean;
    input: ItemMasterInput;
    /** input 이 code 일 때 ISYS_BASECODE CODE_TYPE */
    codeGroup?: string;
    section: ItemMasterSection;
    edit: 'always' | 'create' | 'never';
    defaultValue?: string | number;
    help: string;
}
/** 등록창 구역 순서와 이름 */
export declare const ITEM_MASTER_SECTIONS: ReadonlyArray<{
    key: ItemMasterSection;
    label: string;
}>;
/** ID_ITEM 전체 컬럼 (DB 컬럼 순서) */
export declare const ITEM_MASTER_COLUMNS: readonly ItemMasterColumn[];
/** 바꾸면 DB 트리거가 다른 테이블을 고치는 컬럼 — 수정 저장 전에 알린다 */
export declare const ITEM_MASTER_CASCADE_COLUMNS: readonly string[];
/** 등록·수정 화면에서 값을 받는 컬럼 */
export declare const ITEM_MASTER_EDITABLE_COLUMNS: readonly ItemMasterColumn[];
/** 등록 기본값. today 는 YYYY-MM-DD. */
export declare function itemMasterDefaults(today: string): Record<string, string | number>;
//# sourceMappingURL=item-master-columns.d.ts.map