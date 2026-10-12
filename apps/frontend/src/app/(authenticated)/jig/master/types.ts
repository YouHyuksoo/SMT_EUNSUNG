/** PB d_mcn_jig_lst 의 컬럼 계약 (IMCN_JIG) */
export interface JigMasterRow {
  jigCode: string;
  jigLotNo: string;
  jigName: string | null;
  jigType: string | null;
  jigTypeName: string | null;
  jigStatus: string | null;
  jigStatusName: string | null;
  useStatus: string | null;
  useStatusName: string | null;
  acquisitionType: string | null;
  acquisitionTypeName: string | null;
  pcbItem: string | null;
  pcbItemName: string | null;
  lineCode: string | null;
  lineName: string | null;
  workstageCode: string | null;
  workstageName: string | null;
  machineCode: string | null;
  itemCode: string | null;
  jigModelName: string | null;
  jigSpec: string | null;
  solderType: string | null;
  customerCode: string | null;
  supplierCode: string | null;
  nationCode: string | null;
  capacity: number | null;
  capacityUom: string | null;
  reservedCapacity: number | null;
  useRate: number | null;
  uphValue: number | null;
  breakValue: number | null;
  hitValue: number | null;
  minTension: number | null;
  maxTension: number | null;
  tensionCheckYn: string | null;
  useTpmYn: string | null;
  useNsnpYn: string | null;
  locationAddress: string | null;
  manualLocationComment: string | null;
  managementCommnets: string | null;
  acquisitionDate: string | null;
  receiptDate: string | null;
  lastInspectDate: string | null;
  issueDate: string | null;
  destroyDate: string | null;
  jigImageFileName: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/** PB d_mcn_jig_apply_model_lst */
export interface JigApplyModelRow {
  jigCode: string;
  jigLotNo: string;
  itemCode: string;
  applySmtModelName: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}
