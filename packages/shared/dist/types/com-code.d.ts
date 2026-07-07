/**
 * @file packages/shared/src/types/com-code.ts
 * @description 공통코드 중앙 타입 정의
 *
 * 초보자 가이드:
 * 1. **ComCodeItem**: DB com_codes 테이블의 단일 코드 항목
 * 2. **ComCodeMap**: groupCode별 코드 목록 (API 응답 형태)
 * 3. **COM_CODE_GROUPS**: 시스템에서 사용하는 모든 groupCode 상수
 */
/** 공통코드 단일 항목 */
export interface ComCodeItem {
    detailCode: string;
    codeName: string;
    codeDesc: string | null;
    sortOrder: number;
    /** Tailwind CSS 배지 색상 클래스 */
    attr1: string | null;
    /** 아이콘 이름 (lucide-react) */
    attr2: string | null;
    /** 영어 라벨 */
    attr3: string | null;
}
/** groupCode별 코드 목록 맵 (API 응답 형태) */
export type ComCodeMap = Record<string, ComCodeItem[]>;
/** 시스템에서 사용하는 모든 groupCode 상수 */
export declare const COM_CODE_GROUPS: {
    /** 작업지시 상태 */
    readonly JOB_ORDER_STATUS: "JOB_ORDER_STATUS";
    /** 작업지시 유형 */
    readonly JOB_ORDER_TYPE: "JOB_ORDER_TYPE";
    /** 반제품 상태 */
    readonly SEMI_PRODUCT_STATUS: "SEMI_PRODUCT_STATUS";
    /** BOX 상태 */
    readonly BOX_STATUS: "BOX_STATUS";
    /** 팔레트 상태 */
    readonly PALLET_STATUS: "PALLET_STATUS";
    /** 출하 상태 */
    readonly SHIPMENT_STATUS: "SHIPMENT_STATUS";
    /** 입하 상태 */
    readonly RECEIVE_STATUS: "RECEIVE_STATUS";
    /** 출고 상태 */
    readonly ISSUE_STATUS: "ISSUE_STATUS";
    /** 설비 상태 */
    readonly EQUIP_STATUS: "EQUIP_STATUS";
    /** 설비 PM 상태 */
    readonly PM_STATUS: "PM_STATUS";
    /** 불량 상태 */
    readonly DEFECT_STATUS: "DEFECT_STATUS";
    /** 불량 처리 유형 */
    readonly DEFECT_DISPOSITION: "DEFECT_DISPOSITION";
    /** 검사 결과 */
    readonly INSPECT_RESULT: "INSPECT_RESULT";
    /** 검사 유형 */
    readonly INSPECT_TYPE: "INSPECT_TYPE";
    /** IQC 검사구분 */
    readonly IQC_INSPECT_METHOD: "IQC_INSPECT_METHOD";
    /** IQC 검사유형 */
    readonly IQC_INSPECT_TYPE: "IQC_INSPECT_TYPE";
    /** IQC 유형 */
    readonly IQC_TYPE: "IQC_TYPE";
    /** 품질 판정 */
    readonly QUALITY_JUDGMENT: "QUALITY_JUDGMENT";
    /** 승인 상태 */
    readonly APPROVAL_STATUS: "APPROVAL_STATUS";
    /** 인터페이스 상태 */
    readonly INTERFACE_STATUS: "INTERFACE_STATUS";
    /** 검사기 연결 상태 */
    readonly CONNECTION_STATUS: "CONNECTION_STATUS";
    /** 공정 유형 */
    readonly PROCESS_TYPE: "PROCESS_TYPE";
    /** 공정 대분류 */
    readonly PROCESS_CATEGORY: "PROCESS_CATEGORY";
    /** 품목 유형 */
    readonly ITEM_TYPE: "ITEM_TYPE";
    /** BOM 유형 */
    readonly BOM_TYPE: "BOM_TYPE";
    /** 창고 유형 */
    readonly WAREHOUSE_TYPE: "WAREHOUSE_TYPE";
    /** 재고 이동 유형 */
    readonly INVENTORY_MOVE_TYPE: "INVENTORY_MOVE_TYPE";
    /** 금형 상태 */
    readonly MOLD_STATUS: "MOLD_STATUS";
    /** 일반 상태 */
    readonly GENERAL_STATUS: "GENERAL_STATUS";
    /** 사용여부 */
    readonly USE_YN: "USE_YN";
};
export type ComCodeGroupKey = keyof typeof COM_CODE_GROUPS;
export type ComCodeGroupValue = typeof COM_CODE_GROUPS[ComCodeGroupKey];
//# sourceMappingURL=com-code.d.ts.map
