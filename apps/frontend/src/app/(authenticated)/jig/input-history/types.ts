/** PB d_mcn_jig_input_history_query 의 컬럼 계약 */
export interface JigInputHistoryRow {
  inputDate: string | null;
  lineCode: string | null;
  lineName: string | null;
  jigType: string | null;
  jigTypeName: string | null;
  jigCode: string | null;
  jigLotNo: string | null;
  jigSpec: string | null;
  solderType: string | null;
  currentHitValue: number | null;
  runNo: string | null;
  itemCode: string | null;
  modelName: string | null;
  inputModelName: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}
