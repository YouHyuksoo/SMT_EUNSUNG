/**
 * @file master/process/types.ts
 * @description 공정마스터 화면 타입 - 백엔드 IP_PRODUCT_WORKSTAGE 매핑과 1:1 대응
 */

/** 라인/디스플레이 그룹에서 "지정 없음"을 뜻하는 현장 관례값 */
export const WILDCARD_CODE = "*";

export interface Process {
  /* 기본 */
  processCode: string;
  processName: string;
  processType: string;
  sortOrder: number;
  startYn?: string | null;
  codeGroup?: string | null;
  workstageStatus?: string | null;
  lineCode?: string | null;
  departmentCode?: string | null;
  shiftCode?: string | null;
  machineCode?: string | null;
  costCenterCode?: string | null;
  mesDisplayGroup?: string | null;
  actualPlcAddress?: string | null;

  /* 표준시간 / 생산성 */
  stValue?: number | null;
  otValue?: number | null;
  standardQty?: number | null;
  uphValue?: number | null;
  capacity?: number | null;
  capacityUom?: string | null;
  useRate?: number | null;
  waitTime?: number | null;
  moveTime?: number | null;
  prepareTime?: number | null;
  totalWorkTime?: number | null;
  workerWorkTime?: number | null;
  machineWorkTime?: number | null;
  workerQty?: number | null;
  machineQty?: number | null;
  workingEfficiency?: number | null;
  machineEfficiency?: number | null;

  /* 원가율 */
  wageRate?: number | null;
  expenseRate?: number | null;
  machineryRate?: number | null;

  /* 불량관리 */
  badRateControl?: string | null;
  badMaxRate?: number | null;
  badQtyExtractYn?: string | null;

  /* 기타 */
  genSubMfsYn?: string | null;
  assyExpYn?: string | null;
}

/**
 * 값이 비어 있을 수 있는 숫자 필드 키.
 * 필수 숫자인 sortOrder는 null을 허용하지 않으므로 제외된다.
 */
export type NumericProcessField = {
  [K in keyof Process]-?: null extends Process[K]
    ? NonNullable<Process[K]> extends number
      ? K
      : never
    : never;
}[keyof Process];

export interface Equipment {
  equipCode: string;
  equipName: string;
  equipType: string | null;
  modelName: string | null;
  maker: string | null;
  lineCode: string | null;
  status: string;
  useYn: string;
}
