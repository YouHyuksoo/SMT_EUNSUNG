export type ResultQueryType = 'sp' | 'spi' | 'ict' | 'aoi' | 'router' | 'rom-write' | 'solder' | 'reflow' | 'performance';

export interface ResultColumn { key: string; label: string; width?: number }
export interface ResultQueryDefinition {
  type: ResultQueryType;
  title: string;
  menuCode: string;
  pbWindow: string;
  table: string;
  filters: { line?: boolean; pid?: string; model?: boolean; runNo?: boolean; result?: boolean; review?: boolean; jobFile?: boolean };
  columns: ResultColumn[];
}

const audit: ResultColumn[] = [
  { key: 'fileName', label: '파일명', width: 220 },
  { key: 'enterDate', label: '등록일시', width: 170 },
  { key: 'enterBy', label: '등록자', width: 110 },
];
const inspectionBase: ResultColumn[] = [
  { key: 'inspectDate', label: '검사일시', width: 170 },
  { key: 'lineCode', label: '라인', width: 90 },
  { key: 'machineCode', label: '설비', width: 130 },
  { key: 'runNo', label: '작업지시', width: 140 },
  { key: 'pid', label: 'PID', width: 190 },
  { key: 'modelName', label: '모델명', width: 180 },
  { key: 'result', label: '결과', width: 90 },
  { key: 'defectCode', label: '불량코드', width: 130 },
];

export const RESULT_QUERY_DEFINITIONS: Record<ResultQueryType, ResultQueryDefinition> = {
  sp: { type: 'sp', title: 'SP 작업결과조회', menuCode: 'EQUIP_RESULT_SP', pbWindow: 'w_qc_machine_inspect_data_sp_query', table: 'IQ_MACHINE_INSPECT_DATA_SP', filters: { line: true, pid: 'PID', model: true, runNo: true }, columns: [...inspectionBase, { key: 'jobFile', label: 'Job File', width: 180 }, { key: 'stencilId', label: 'Stencil ID', width: 130 }, { key: 'pasteId', label: 'Paste ID', width: 130 }, { key: 'squeegeeId', label: 'Squeegee ID', width: 140 }, { key: 'productCount', label: '생산수', width: 100 }, ...audit] },
  spi: { type: 'spi', title: 'SPI 검사결과조회', menuCode: 'EQUIP_RESULT_SPI', pbWindow: 'w_spi_time_query', table: 'IQ_MACHINE_INSPECT_DATA_SPI', filters: { line: true, pid: 'PID', model: true, runNo: true }, columns: [...inspectionBase, { key: 'customerModelName', label: '고객 모델명', width: 180 }, ...audit] },
  ict: { type: 'ict', title: 'ICT 검사결과조회', menuCode: 'EQUIP_RESULT_ICT', pbWindow: 'w_qc_machine_inspect_data_ict_query', table: 'IQ_MACHINE_INSPECT_DATA_ICT', filters: { line: true, pid: 'PID', model: true, runNo: true }, columns: [...inspectionBase, { key: 'stepNo', label: 'Step', width: 90 }, { key: 'partsName', label: '부품명', width: 130 }, { key: 'actual', label: '실측값', width: 100 }, { key: 'standard', label: '기준값', width: 100 }, { key: 'hiLimit', label: '상한', width: 90 }, { key: 'loLimit', label: '하한', width: 90 }, ...audit] },
  aoi: { type: 'aoi', title: 'AOI 검사결과조회', menuCode: 'EQUIP_RESULT_AOI', pbWindow: 'w_aoi_header_detail_query', table: 'IQ_MACHINE_INSPECT_DATA_AOI', filters: { line: true, pid: 'PID', model: true, runNo: true, result: true, review: true }, columns: [...inspectionBase, { key: 'customerModelName', label: '고객 모델명', width: 180 }, { key: 'reviewDate', label: '리뷰일시', width: 170 }, { key: 'reviewResult', label: '리뷰결과', width: 100 }, { key: 'jobFile', label: 'Job File', width: 180 }, ...audit] },
  router: { type: 'router', title: 'ROUTER 작업결과조회', menuCode: 'EQUIP_RESULT_ROUTER', pbWindow: 'w_qc_machine_inspect_data_rt_query', table: 'IQ_MACHINE_INSPECT_DATA_RT', filters: { line: true, pid: 'PID', model: true, runNo: true }, columns: [...inspectionBase, { key: 'rpmValue', label: 'RPM', width: 100 }, { key: 'bitValue', label: 'Bit', width: 100 }, ...audit] },
  'rom-write': { type: 'rom-write', title: 'ROM WRITE 작업결과조회', menuCode: 'EQUIP_RESULT_ROM_WRITE', pbWindow: 'w_qc_machine_inspect_data_rw_query', table: 'IQ_MACHINE_INSPECT_DATA_RW', filters: { line: true, pid: 'PID', model: true, runNo: true }, columns: [...inspectionBase, { key: 'pinCount', label: 'Pin 수', width: 90 }, { key: 'routeProgram', label: '프로그램', width: 180 }, { key: 'checkSum', label: 'Check Sum', width: 140 }, { key: 'workTime', label: '작업시간', width: 110 }, ...audit] },
  solder: { type: 'solder', title: '솔더점도 검사결과조회', menuCode: 'EQUIP_RESULT_SOLDER', pbWindow: 'w_qc_machine_inspect_data_solder_query', table: 'IQ_MACHINE_INSPECT_DATA_SOLDER', filters: { line: true, pid: '솔더 번호' }, columns: [{ key: 'measureDate', label: '측정일시', width: 170 }, { key: 'lineCode', label: '라인', width: 90 }, { key: 'machineCode', label: '설비', width: 130 }, { key: 'solderNo', label: '솔더 번호', width: 140 }, { key: 'solderLotNo', label: '솔더 Lot', width: 160 }, { key: 'rpm', label: 'RPM', width: 90 }, { key: 'time', label: '시간', width: 90 }, { key: 'viscosity', label: '점도', width: 100 }, { key: 'temp', label: '온도', width: 90 }, ...audit] },
  reflow: { type: 'reflow', title: 'REFLOW 작업결과조회', menuCode: 'EQUIP_RESULT_REFLOW', pbWindow: 'w_qc_machine_inspect_data_reflow_query', table: 'IQ_MACHINE_INSPECT_DATA_REFLOW', filters: { line: true, jobFile: true }, columns: [{ key: 'measureDate', label: '측정일시', width: 170 }, { key: 'lineCode', label: '라인', width: 90 }, { key: 'machineCode', label: '설비', width: 130 }, { key: 'jobFile', label: 'Job File', width: 180 }, { key: 'beltSpeed', label: 'Belt Speed', width: 110 }, { key: 'oxygenConcentration', label: '산소농도', width: 110 }, ...Array.from({ length: 13 }, (_, index) => [{ key: `top${index + 1}`, label: `Top ${index + 1}`, width: 85 }, { key: `bottom${index + 1}`, label: `Bottom ${index + 1}`, width: 95 }]).flat(), ...audit] },
  performance: { type: 'performance', title: '성능 검사결과조회', menuCode: 'EQUIP_RESULT_PERFORMANCE', pbWindow: 'w_qc_machine_inspect_data_eol_query', table: 'IQ_MACHINE_INSPECT_DATA_EOL', filters: { line: true, pid: 'PID', model: true, runNo: true }, columns: [{ key: 'inspectStartDate', label: '검사 시작', width: 170 }, { key: 'inspectEndDate', label: '검사 종료', width: 170 }, ...inspectionBase.slice(1), { key: 'testChannel', label: '채널', width: 90 }, ...Array.from({ length: 4 }, (_, index) => [{ key: `currentTestData${index + 1}`, label: `전류값 ${index + 1}`, width: 110 }, { key: `currentTestResult${index + 1}`, label: `전류결과 ${index + 1}`, width: 110 }, { key: `connectivityTestData${index + 1}`, label: `통전값 ${index + 1}`, width: 110 }, { key: `connectivityTestResult${index + 1}`, label: `통전결과 ${index + 1}`, width: 110 }]).flat(), ...audit] },
};
