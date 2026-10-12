/** PB d_mcn_sample_bcr_input_history_query 의 컬럼 계약 */
export interface SampleBcrHistoryRow {
  inputDate: string | null;
  lineCode: string | null;
  lineName: string | null;
  workstageCode: string | null;
  workstageName: string | null;
  runNo: string | null;
  modelName: string | null;
  sampleType: string | null;
  sampleTypeName: string | null;
  sampleSection: string | null;
  sampleLotNo: string | null;
  sampleBarcode: string | null;
  inspectResult: string | null;
}

/** PB 라디오버튼 rb_list / rb_ng → 웹은 탭 */
export type SampleBcrMode = 'ALL' | 'NG';
