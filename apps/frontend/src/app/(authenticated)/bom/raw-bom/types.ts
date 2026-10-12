/** 원단위BOM 한 행 (ID_ENG_BOM + ID_ITEM 자/모품목, PB d_des_raw_bom_lst) */
export interface RawBomRow {
  parentItemCode: string;
  childItemCode: string;
  /** 'YYYY-MM-DD' — 키 컬럼 */
  dateset: string;
  /** 'YYYY-MM-DD' */
  dateend: string | null;
  /** 종료일자가 오늘보다 이전이면 'Y' (서버에서 TRUNC(SYSDATE) 기준으로 판정) */
  expiredYn: 'Y' | 'N';
  sortSequence: number | null;
  itemUnitQty: number | null;
  itemUnitQtyExt: number | null;
  workstageCode: string | null;
  workstageName: string | null;
  bomWorkNo: number | null;
  itemType: string | null;
  lineType: string | null;
  assyExplosionYn: string | null;
  locationInfo: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  drawingNo: string | null;
  abcGrade: string | null;
  manufactureLeadtime: number | null;
  workBadRate: number | null;
  itemDivision: string | null;
  setItemYn: string | null;
  parentItemName: string | null;
  parentItemSpec: string | null;
}

/** 수정 폼 — 키(parent/child/dateset)는 읽기 전용 */
export interface RawBomForm {
  parentItemCode: string;
  childItemCode: string;
  dateset: string;
  assyExplosionYn: string;
  itemType: string;
  lineType: string;
  itemUnitQty: string;
  itemUnitQtyExt: string;
  workstageCode: string;
  sortSequence: string;
  dateend: string;
}

/** 순환 검사 결과 한 건 — path 는 닫힌 경로(첫 품목이 끝에 다시 나온다) */
export interface RawBomLoop {
  path: string[];
  length: number;
}

export interface RawBomLoopResult {
  itemCode: string | null;
  loops: RawBomLoop[];
  total: number;
}
