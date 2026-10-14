/**
 * @file src/lib/trace/trace-source-label.ts
 * @description 추적성 섹션에 쓰는 테이블명 → 표시명.
 * 초보자 가이드: 타임라인 좌측 배지에 원본 테이블명이 그대로 나오면 안 된다.
 */

/** 명시 매핑 (PB nested DW 제목 + 기존 멕시코 라벨) */
const SOURCE_LABEL: Record<string, string> = {
  MATERIAL_BOARD: '자재(한화-BOARD)',
  MATERIAL_DETAIL: '자재(한화-상세)',
  MATERIAL_PANASONIC: '자재투입',
  IP_PRODUCT_2D_BARCODE: '바코드마스터',
  IP_PRODUCT_2D_BARCODE_PAIR: 'TOP/BOTTOM 짝',
  IP_PRODUCT_RUN_CARD: '작업지시',
  IP_PRODUCT_MODEL_MASTER: '모델마스터',
  IP_PRODUCT_PACK_SERIAL: '출하정보',
  IP_PRODUCT_WORK_QC: '수리이력',
  IP_PRODUCT_WORKSTAGE_IO: '공정이동',
  IP_PRODUCT_MAGAZINE_MASTER: '매거진장입',
  IP_PRODUCT_PCB_SCAN_MASTER: 'PCB원자재',
  IB_SMT_CHECKHIST: '릴자재투입',
  IM_ITEM_SOLDER_INPUT_HIST: '솔더투입이력',
  IM_ITEM_SOLDER_MASTER: '솔더마스터',
  IMCN_JIG_INPUT_HIST: '지그투입이력',
  IQ_MACHINE_INSPECT_RESULT: '공정설비통신',
  IQ_MACHINE_INSPECT_DATA_SPI: 'SPI',
  IQ_MACHINE_INSPECT_DATA_SPI_NG: 'SPI NG',
  IQ_MACHINE_INSPECT_DATA_SPI_DFT: 'SPI DFT',
  IQ_MACHINE_INSPECT_DATA_SPI_DTL: 'SPI 상세',
  IQ_MACHINE_INSPECT_DATA_AOI: 'AOI',
  IQ_MACHINE_INSPECT_DATA_AOI_NG: 'AOI NG',
  IQ_MACHINE_INSPECT_DATA_AOI_DFT: 'AOI DFT',
  IQ_MACHINE_INSPECT_DATA_MAOI: 'MAOI',
  IQ_MACHINE_INSPECT_DATA_MAOI_NG: 'MAOI NG',
  IQ_MACHINE_INSPECT_DATA_MK: '마킹',
  IQ_MACHINE_INSPECT_DATA_SP: 'SP',
  IQ_MACHINE_INSPECT_DATA_REFLOW: '리플로우',
  IQ_MACHINE_INSPECT_DATA_ICT: 'ICT',
  IQ_MACHINE_INSPECT_DATA_RT: 'RT',
  IQ_MACHINE_INSPECT_DATA_RW: 'RW',
  IQ_MACHINE_ATE_U1_DATA_RAW: 'U1 ATE',
  IQ_MACHINE_FW_U1_DATA_RAW: 'U1 FW',
  IQ_MACHINE_HIPOT_U1_DATA_RAW: 'U1 HIPOT',
  IQ_MACHINE_ICT_U1_DATA_RAW: 'U1 ICT',
  IQ_MACHINE_ICT_DTL_U1_DATA_RAW: 'U1 ICT 상세',
  IQ_MACHINE_BURNIN_U1_DATA_RAW: 'U1 BURN-IN',
  IQ_MACHINE_AOI_U1_DATA_RAW: 'U1 AOI',
  IQ_MACHINE_AOI_NG_U1_DATA_RAW: 'U1 AOI NG',
  IQ_MACHINE_AIM_U1_DATA_RAW: 'U1 AIM',
  IQ_MACHINE_EPOXY_U1_DATA_RAW: 'U1 EPOXY',
  IQ_MACHINE_RTV_U1_DATA_RAW: 'U1 RTV',
  LOG_LCR: 'LCR 측정로그',
};

const IQ_STRIP = [
  /^IQ_MACHINE_INSPECT_DATA_/,
  /^IQ_MACHINE_INSPECT_/,
  /^IQ_MACHINE_/,
];

const IQ_SUFFIX = [/_U1_DATA_RAW$/, /_DATA_RAW$/, /_RAW$/];

/** IQ_MACHINE_* 에서 짧은 공정명 추출. */
function deriveIqLabel(name: string): string {
  let s = name;
  for (const re of IQ_STRIP) s = s.replace(re, '');
  for (const re of IQ_SUFFIX) s = s.replace(re, '');
  return s.replace(/_/g, ' ').trim() || name;
}

/**
 * 추적 소스 테이블명을 화면 라벨로 바꾼다.
 * 명시 맵이 없으면 IQ_ / LOG_ / IP_PRODUCT_ 접두어를 떼고 읽기 쉽게 만든다.
 */
export function traceSourceLabel(source: string): string {
  const key = (source || '').toUpperCase();
  if (SOURCE_LABEL[key]) return SOURCE_LABEL[key];
  if (key.startsWith('IQ_MACHINE_')) return deriveIqLabel(key);
  return source
    .replace(/^LOG_/i, '')
    .replace(/^IP_PRODUCT_/i, '')
    .replace(/^IB_/i, '')
    .replace(/^IM_ITEM_/i, '')
    .replace(/_/g, ' ')
    .trim() || source;
}

export const TRACE_SOURCE_LABELS = SOURCE_LABEL;
