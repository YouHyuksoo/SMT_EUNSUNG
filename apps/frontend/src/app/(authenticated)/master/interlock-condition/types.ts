/**
 * @file src/app/(authenticated)/master/interlock-condition/types.ts
 * @description 인터락조건관리 타입 — IQ_INTERLOCK_CHECK_CONDITION
 */
export interface InterlockCondition {
  /** 행 식별자 (ROWID) — 테이블에 PK 가 없어 수정·삭제에 쓴다 */
  rowKey: string;
  lineCode: string;
  lineName: string | null;
  workstageCode: string;
  workstageName: string | null;
  machineCode: string | null;
  /** 공통코드 INTERLOCK CHECK TYPE */
  interlockCheckType: string;
  checkLimitTime: number | null;
  checkSequence: number | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  modelName: string | null;
  modelSuffix: string | null;
  useYn: "Y" | "N";
  enterDate: string | null;
  enterBy: string | null;
  lastModifyDate: string | null;
  lastModifyBy: string | null;
}
